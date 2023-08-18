
provider "ncloud" {
  support_vpc = true            # VPC 환경 사용 설정
  access_key = var.access_key
  secret_key = var.secret_key
  region = var.region
}


# VPC 리소스 생성 -> 기본적으로 VPC 생성 시 Internet Gateway, Route Table, Network ACL, ACG 가 생성된다.(기본값)
resource "ncloud_vpc" "vpc_scn_02" {
  name = var.name_scn02           # name : tf-scn02 (variables.tf)
  ipv4_cidr_block = "10.0.0.0/16"
}

# Public Subnet 설정
resource "ncloud_subnet" "subnet_scn_02_public" {
  name = "${var.name_scn02}-public"
  network_acl_no = ncloud_network_acl.network_acl_02_public.id
  subnet         = cidrsubnet(ncloud_vpc.vpc_scn_02.ipv4_cidr_block,8 ,0 ) # 10.0.0.0/24    function 사용  [참고](https://developer.hashicorp.com/terraform/language/functions/cidrsubnet)
  subnet_type    = "PUBLIC"
  vpc_no         = ncloud_vpc.vpc_scn_02.vpc_no
  zone           = "KR-2"
}

# Private Subnet 설정
resource "ncloud_subnet" "subnet_scn_02_private" {
  name = "${var.name_scn02}-private"
  network_acl_no = ncloud_network_acl.network_acl_02_private.id
  subnet         = cidrsubnet(ncloud_vpc.vpc_scn_02.ipv4_cidr_block,8 ,1 ) # 10.0.1.0/24
  subnet_type    = "PRIVATE"
  vpc_no         = ncloud_vpc.vpc_scn_02.vpc_no
  zone           = "KR-2"
}

# Network ACL (for Public)
resource "ncloud_network_acl" "network_acl_02_public" {
  vpc_no = ncloud_vpc.vpc_scn_02.id
  name = "${var.name_scn02}-public"
}

# Netowork ACL (for Private)
resource "ncloud_network_acl" "network_acl_02_private" {
  vpc_no = ncloud_vpc.vpc_scn_02.id
  name = "${var.name_scn02}-private"
}



## 서버 생성

# Login Key
resource "ncloud_login_key" "key_scn_02" {
  key_name = var.name_scn02
}

# Server (for frontend (bastion) server)
resource "ncloud_server" "server_scn_02_public" {
  subnet_no = ncloud_subnet.subnet_scn_02_public.id
  name = "${var.name_scn02}-public"
  server_image_product_code = "SW.VSVR.OS.LNX64.CNTOS.0703.B050" # 알아오는 방법도 테라폼 코드로 가능! server_images 코드 참고!
  login_key_name = ncloud_login_key.key_scn_02.key_name

  // 서버 product code 미 입력시 가장 낮은 스펙으로 생성
  //server_product_code       = "SVR.VSVR.STAND.C002.M008.NET.SSD.B050.G002"
}

# Server (for Backend Server (WAS)
resource "ncloud_server" "server_scn_02_private" {
  subnet_no = ncloud_subnet.subnet_scn_02_private.id
  name = "${var.name_scn02}-private"
  server_image_product_code = "SW.VSVR.OS.LNX64.CNTOS.0703.B050"
  login_key_name = ncloud_login_key.key_scn_02.key_name
}

## Public IP 설정
### 외부에서 Frontend(Bastion) 서버를 접근하게 해주고, 관리자도 SSH 로 접근할 수 있도록 Public IP 를 설정해야 한다.
resource "ncloud_public_ip" "public_ip_scn_02" {
  server_instance_no = ncloud_server.server_scn_02_public.id
  description = "for ${var.name_scn02}"
}


## Private Subnet 안에 있는 리소스들도 인터넷에 연결할 수 있도록 NAT Gateway 설정
resource "ncloud_nat_gateway" "nat_gateway_scn_02" {
  vpc_no = ncloud_vpc.vpc_scn_02.id
  zone   = "KR-2"
  name = var.name_scn02
}

## 게이트웨이 추가 후, 그에 해당하는 라우팅 설정 (그래야 해당 트래픽이 게이트웨이로 전달이 가능)
resource "ncloud_route" "route_scn_02_nat" {
  destination_cidr_block = "0.0.0.0/0" # Default 게이트웨이 설정
  route_table_no         = ncloud_vpc.vpc_scn_02.default_private_route_table_no
  target_name            = ncloud_nat_gateway.nat_gateway_scn_02.name
  target_no              = ncloud_nat_gateway.nat_gateway_scn_02.id
  target_type            = "NATGW" // NAT Gateway 를 의미
}

## Null Resource 를 이용한 해당 서버 ssh 접속 및 remote exec Provisioner 를 이용하여 내부에서 명령어 실행 예시
## 아래는 Network ACL 룰이 잘 적용되었는지 확인하기 위한 ls -al 명령어 수행

data "ncloud_root_password" "scn_02_root_password" {
  server_instance_no = ncloud_server.server_scn_02_public.id
  private_key = ncloud_login_key.key_scn_02.private_key
}

resource "null_resource" "ls-al" {
  connection {
    type = "ssh"
    host = ncloud_public_ip.public_ip_scn_02.public_ip
    user = "root"
    port = "22"
    password = data.ncloud_root_password.scn_02_root_password.root_password
  }
  provisioner "remote-exec" {
    inline = [
      "ls -al",
    ]
  }
  depends_on = [
    ncloud_public_ip.public_ip_scn_02,
    ncloud_server.server_scn_02_public
  ]
}
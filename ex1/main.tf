#
## 테라폼 프로바이더 버전 명시
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = ">= 2.0.0"
    }
  }
}

## 백엔드 블록
terraform {
  backend "local" {
    path = "state/terraform.tfstate"
  }
}


## 종속성
resource "local_file" "abc" {
  content  = "123!"
  filename = "${path.module}/abc.txt"
}

resource "local_file" "def" {

  depends_on = [
    local_file.abc
  ]

  content  = local_file.abc.content
  filename = "${path.module}/def.txt"
}


## local 프로바이더에 속한 리소스 유형
#resource "local_file" "abc" {
#  content  = "123456!"
#  filename = "${path.module}/abc.txt"
#}
#
### aws 프로바이더에 속한 리소스 유형
#resource "aws_instance" "web" {
#  ami = "ami-a1b2c3d4"
#  instance_type = "t2.micro"
#}



## 테라폼 버전 조건 블럭
#terraform-basic {
#  required_version = ">= 1.0.0"
#}

#resource "local_file" "def" {
#  content = "def!"
#  filename = "${path.module}/def.txt"
#}

## 테라폼 프로바이더 버전 명시
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    local = {
      source = "hashicorp/local"
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


resource "local_file" "abc" {
  content  = "123456!"
  filename = "${path.module}/abc.txt"
}


## 테라폼 버전 조건 블럭
#terraform {
#  required_version = ">= 1.0.0"
#}

#resource "local_file" "def" {
#  content = "def!"
#  filename = "${path.module}/def.txt"
#}
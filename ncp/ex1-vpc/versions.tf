
# 프로바이더의 버전을 설정 -> NCP 프로바이더 버전 설정
terraform {
  required_providers {
    ncloud = {
      source = "navercloudplatform/ncloud"
    }
  }
  required_version = ">= 0.13"
}
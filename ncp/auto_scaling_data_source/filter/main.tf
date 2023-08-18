terraform {
  required_providers {
    ncloud = {
      source = "navercloudplatform/ncloud"
      version = "~> 2.0"
    }
  }
}


provider "ncloud" {
  support_vpc = true            # VPC 환경 사용 설정
}

data "ncloud_auto_scaling_adjustment_types" "test" {
  filter {
    name   = "code"
    values = ["PRCNT"]
  }
}

output "filtered_types" {
  value = data.ncloud_auto_scaling_adjustment_types.test.types
}
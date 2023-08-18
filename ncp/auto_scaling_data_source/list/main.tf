terraform {
  required_providers {
    ncloud = {
      source = "navercloudplatform/ncloud"
      version = "~> 2.0" # 사용하려는 버전에 맞게 수정해주세요.
    }
  }
}


provider "ncloud" {
  support_vpc = true            # VPC 환경 사용 설정
}


resource "ncloud_launch_configuration" "lc" {
  name = "my-lc"
  server_image_product_code = "SPSW0LINUX000046"
  server_product_code = "SPSVRSSD00000003"
}

resource "ncloud_auto_scaling_group" "asg" {
  launch_configuration_no = ncloud_launch_configuration.lc.launch_configuration_no
  min_size = 1
  max_size = 1
  zone_no_list = ["2"]
  wait_for_capacity_timeout = "0"
}

resource "ncloud_auto_scaling_policy" "policy" {
  name = "my-policy"
  adjustment_type_code = data.ncloud_auto_scaling_adjustment_types.test.types[2].code # 2. 조회된 Adjustment Type 참조
  scaling_adjustment = 2
  auto_scaling_group_no = ncloud_auto_scaling_group.asg.auto_scaling_group_no
}

data "ncloud_auto_scaling_adjustment_types" "test" {
}

output "types" {
  value = data.ncloud_auto_scaling_adjustment_types.test.types
  description = "The list of types from the auto scaling adjustment types"
}

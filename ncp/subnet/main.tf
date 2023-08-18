terraform {
  required_providers {
    ncloud = {
      source = "navercloudplatform/ncloud"
      version = "~> 2.0"
    }
  }
}

provider "ncloud" {
  support_vpc = true
}

#resource "ncloud_vpc" "foo" {
#  name               = "testacc-data-subnet-basic"
#  ipv4_cidr_block    = "10.2.0.0/16"
#}
#
#resource "ncloud_subnet" "bar" {
#  vpc_no             = ncloud_vpc.foo.vpc_no
#  name               = "testacc-data-subnet-basic"
#  subnet             = "10.2.2.0/24"
#  zone               = "KR-2"
#  network_acl_no     = ncloud_vpc.foo.default_network_acl_no
#  subnet_type        = "PUBLIC"
#  usage_type         = "GEN"
#}
#
#data "ncloud_subnet" "by_id" {
#  id = "${ncloud_subnet.bar.id}"
#}
#
#data "ncloud_subnet" "by_filter" {
#  filter {
#    name   = "subnet_no"
#    values = [ncloud_subnet.bar.id]
#  }
#}

data "ncloud_subnets" "all" {}

data "ncloud_subnets" "by_cidr" {
  subnet = "10.2.1.0"
}

data "ncloud_subnets" "by_vpc_no" {
  vpc_no = "502"
}
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
  // export region, access, secret key
}


resource "ncloud_vpc" "vpc" {
  name            = "test-nat-gateway"
  ipv4_cidr_block = "10.3.0.0/16"
}

resource "ncloud_subnet" "subnet_public" {
  vpc_no         = ncloud_vpc.vpc.id
  subnet         = cidrsubnet(ncloud_vpc.vpc.ipv4_cidr_block, 8, 1)
  zone           = "KR-1"
  network_acl_no = ncloud_vpc.vpc.default_network_acl_no
  subnet_type    = "PUBLIC"
  usage_type     = "NATGW"
}

resource "ncloud_subnet" "subnet_private" {
  vpc_no         = ncloud_vpc.vpc.id
  subnet         = cidrsubnet(ncloud_vpc.vpc.ipv4_cidr_block, 8, 2)
  zone           = "KR-1"
  network_acl_no = ncloud_vpc.vpc.default_network_acl_no
  subnet_type    = "PRIVATE"
  usage_type     = "NATGW"
}

resource "ncloud_nat_gateway" "nat_gateway" {
  vpc_no      = ncloud_vpc.vpc.vpc_no
  subnet_no   = ncloud_subnet.subnet_public.id
  zone        = "KR-1"
  name        = "test-nat-gateway"
  description = "test"
}

resource "ncloud_nat_gateway" "nat_gateway_private" {
  vpc_no      = ncloud_vpc.vpc.vpc_no
  subnet_no   = ncloud_subnet.subnet_private.id
  zone        = "KR-1"
  description = "test"
}

// Data Source

#resource "ncloud_vpc" "vpc" {
#  name            = "test-nat-gateway"
#  ipv4_cidr_block = "10.3.0.0/16"
#}
#
#resource "ncloud_subnet" "subnet" {
#  vpc_no         = ncloud_vpc.vpc.id
#  subnet         = cidrsubnet(ncloud_vpc.vpc.ipv4_cidr_block, 8, 1)
#  zone           = "KR-1"
#  network_acl_no = ncloud_vpc.vpc.default_network_acl_no
#  subnet_type    = "PUBLIC"
#  usage_type     = "NATGW"
#}
#
#resource "ncloud_nat_gateway" "nat_gateway" {
#  vpc_no      = ncloud_vpc.vpc.vpc_no
#  subnet_no   = ncloud_subnet.subnet.id
#  zone        = "KR-1"
#  name        = "test-nat-gateway"
#  description = "description"
#}
#
#data "ncloud_nat_gateway" "by_id" {
#  id = ncloud_nat_gateway.nat_gateway.id
#}
#
#data "ncloud_nat_gateway" "by_filter" {
#  filter {
#    name   = "nat_gateway_no"
#    values = [ncloud_nat_gateway.nat_gateway.id]
#  }
#}
# 데이터 소스 선언
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "primary" {
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_subnet" "secondary" {
  availability_zone = data.aws_availability_zones.available.names[1]
}
variable "string" {
  type = string
  description = "var String"
  default = "myString"
}

variable "number" {
  type = number
  default = 123
}

variable "boolean" {
  default = true
}

variable "list" {
  default = [
    "google",
    "vmware",
    "amazone",
    "microsoft",
    "naver"
  ]
}

output "list_index_0" {
  value = var.list.0    # 리스트에서 0번째 인덱스 값 추출
}

output "list_all" {
  value = [
    for name in var.list :  # for 문을 사용하여 리스트에 있는 모든 값을 추출
          upper(name)
  ]
}

variable "map" {
  default = {
    aws = "amazone",
    azure ="microsoft",
    gcp = "google",
    ncp = "naver"
  }
}

variable "set" {
  type = set(string)
  default = [
    "google",
    "vmware",
    "amazone",
    "microsoft"
  ]
}

variable "object" {
  type = object({name=string, age=number})
  default = {
      name = "abc"
      age = 12
  }
}

variable "tuple" {
  type = tuple([string, number, bool])
  default = ["abc", 123, true]
}

variable "ingress_rules" {
  type = list(object({
      port = number,
      description = optional(string),
      protocol = optional(string, "tcp"),
  }))
  default = [
    { port = 80, description = "web" },
    { port = 53, protocol = "udp" }
  ]
}

## 유효성 검사 예시
variable "image_id" {
  type = string
  description = "The id of the machine image (AMI) to use for the server."

    validation {
      condition = length(var.image_id) > 4
      error_message = "The image_id value must exceed 4."
    }

  validation {
    # regex 함수 : 대상의 문자열에 정규식을 적용하고 일치하는 문자열을 반환, can 함수와 함께 사용하여 정규식에 일치하지 않는 경우 오류 검출
    condition = can(regex("^ami-", var.image_id))
    error_message = "The image_id value must starting with \"ami-\"."
  }
}


## 변수 참조
variable "my_password" {}  ## terraform-basic plan 시 변수 입력

resource "local_file" "abc" {
  content = "var.my_password"
  filename = "${path.module}/abc.txt"
}
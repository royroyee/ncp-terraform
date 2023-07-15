# 테라폼 코드 내에서 쓰일 변수들을 선언

variable "name_scn02" {
  default = "tf-scn02"
}

variable "client_ip" {
  default = "113.60.253.143"
}

variable "region" {
  default = "KR"
}

## Key 는 외부에 보여선 안 될 정보이므로 환경변수로 미리 설정해두어야 한다.

variable "access_key" { # export TF_VAR_access_key=...
}

variable "secret_key" { # export TF_VAR_secret_key=...
}

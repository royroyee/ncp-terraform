# Terraform
클라우드 인프라스트럭쳐 자동화 도구


[참고자료](https://www.44bits.io/ko/post/terraform_introduction_infrastrucute_as_code#%ED%85%8C%EB%9D%BC%ED%8F%BC-%EC%84%A4%EC%B9%98)

## 기본 개념

### 프로비저닝
사용자의 요구에 맞게 제공하는 시스템, **어떤 서비스를 제공하기까지의 준비한 과정**을 통틀어 프로비저닝이라 칭함
- 어떤 프로세스나 서비스를 실행하기 위한 준비 단계이다.
- 테라폼은 네트워크나 컴퓨팅 자원을 준비하는 작업을 주로 다루는 도구

### 프로바이더
테라폼과 외부 서비스를 연결해주는 기능을 하는 모듈
-  AWS, GCP, Azure, NCP ...


### 리소스(Resource)
- 특정 프로바이더가 제공해주는 조작 가능한 대상의 최소 단위

### Plan
- 테라폼 프로젝트 디렉토리 아래의 모든 `.tf` 파일의 내용을 실제로 적용이 가능한지 확인하는 작업
  - ```terraform plan```
- 이 명령어를 통해 어떤 리소스가 생성,수정,삭제될지 알 수 있다.


### Apply
- 테라폼 프로젝트 디렉토리 아래의 모든 `.tf` 파일의 내용대로 리소스를 생성,수정,삭제 적용


### HCL
- 테라폼에서 사용하는 설정 언어
- 확장자 `.tf` 이용



## 테라폼 명령어

### 테라폼 프로젝트 초기화
```
terraform init
```
- 테라폼 프로젝트를 초기화 한다.
- 테라폼 프로젝트를 초기화 할 때마다 프로바이더 설정을 보고, 플러그인을 설치한다.


### 변경사항 체크(plan)
```
terraform plan
```
- 파일을 저장하고 인프라스트럭쳐를 적용하기 전 변경사항을 체크한다.
> 인프라스트럭쳐가 생성되는 것이 아님을 유의할 것. 단순히 적용될 사항들을 보여준다. 

### 리소스 생성
```
terraform apply
```
- 테라폼 설정을 적용하여 프로바이더에 맞는 리소스 등을 생성

### 삭제
````
terraform destroy
````
- 테라폼으로 생성된 인프라스트럭처 삭제

### 포맷 (가독성)
```terraform
terraform fmt
```
- 코드에 쓰인 정렬, 빈칸, 내려쓰기 등의 규칙이 적용된다.
- 업로드 전 이 커맨드를 통해 전체 코드를 정리하는 용도로 사용하면 유용하다.


## 테라폼 블록

### 테라폼 버전
```terraform
terraform {
  required_version = "< 1.0.0"
}
```

### 프로바이더 버전 (+테라폼 버전)
```terraform
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.2.0"
    }
    azurerm = {
      source = "hashcorp/azurerm"
      version = ">= 2.99.0"
    }
  }
}
```

### Cloud 블록
```terraform
terraform {
  cloud {
    hostname = "app.terraform-basic.io"
    organization = "my-org"
    workspaces {
      name = "my-app-prod"
    }
  }
}
```
- 테라폼 클라우드, 테라폼 엔터프라이즈 CLI, VCS, API 기반의 실행 방식을 지원하고 클라우드 블록으로 선언

### 백엔드 블록
테라폼 실행 시 저장되는 State(상태파일) 의 저장 위치를 선언한다.
- **하나의 백엔드만 허용**
- 테라폼은 `State`의 데이터를 사용해 코드로 관리된 리소스를 탐색하고 추적한다.
- 작업자 간의 협업을 고려한다면 테라폼으로 생성한 리소스의 상태 저장 파일을 공유할 수 있는 외부 백엔드 저장소가 필요하다.
  - state 에는 외부로 노출되면 안 되는 패스워드 또는 인증서 정보 같은 민감한 데이터들이 포함될 수 있으므로 `State` 의 접근 제어가 필요하다.

### 리소스 블록
리소스 블록은 `resource` 로 시작하고 이후 리소스 블록이 생성할 리소스 유형을 정의

```terraform
resource "<리소스 유형>" "<이름>" {
  <인수> = <값>
}


# example
resource "local_file" "abc" {
        content = "123!"
        filename = "${path.module}/abc.txt"
}
```
- 리소스 이름은 첫 번째 언더바를 기준으로 앞은 프로바이더 이름, 뒤는 프로바이더에서 제공하는 리소스 유형을 의미
  - `local_file` : local 프로바이더에 속한 유형
- 리소스 유형이 선언되면 뒤에는 고유한 이름을 붙인다.
- 이름 뒤에는 리소스 유형에 대한 구성 인수들이 중괄호 내에 선언된다. 유형에 인수가필요하지 않은 경우도 있긴 하지만, 그 경우에도 중괄호는 입력


### 종속성
테라폼의 종속성은 resource, module 선언으로 프로비저닝되는 각 요소의 생성 순서를 구분짓는다.
- 기본적으로 다른 리소스에서 값을 참조해 불러올 경우 **생성 선후 관계**에 따라 의도치 않게 자동으로 연관 관계가 정의되는 암시적 종속성을 갖게 됨
> 때문에 강제로 리소스 간 **명시적 종속성**을  부여할 경우 **depends_on** 을 활용한다.

````terraform
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
````
- "def" 리소스가 "abc" 리소스에서 값을 참조해 불러오는 경우
- `depends_on` 으로 명시적으로 선언

### 리소스 속성 참조
리소스 속성에서 참조 가능한 값은 `인수`, `속성` 이다.
- 인수 : 리소스 생성 시 사용자가 선언하는 값
- 속성 : 사용자가 설정하는 것은 불가능하지만 리소스 생성 이후 획득 가능한 리소스 고유 값

```terraform
# Terraform Code
resource = "<리소스 유형>" "<이름>" {
  <인수> = <값>
}

# 리소스 참조
<리소스 유형>.<이름>.<인수>
<리소스 유형>.<이름>.<속성>
```


### 수명주기
기본 수명주기를 작업자가 의도적으로 변경하는 메타인수
> 테라폼의 기본 라이프사이클은 **삭제 -> 생성** 임을 유의해야 한다.

- `create_before_destory`(bool) : 리소스 수정 시 신규 리소스를 우선 생성하고 기존 리소스를 삭제
- `prevent_destory`(bool) : 해당 리소스를 삭제하려 할 때 명시적으로 거부
- `ignore_changes`(list) : 리소스 요소에 선언된 인수의 변경 사항을 테라폼 실행 시 무시
- `precondition` : 리소스 요소에 선언된 인수의 조건을 검증
- `postcondition` : Plan 과 Apply 이후의 결과를 속성 값으로 검증

[예제 ex3]()


## 데이터 소스
테라폼으로 정의되지 않은 외부 리소스 또는 저장된 정보를 테라폼 내에서 참조할 때 사용

```terraform
## 선언
data "<리소스 유형>" "<이름>" {
  <인수> = <값>
}
        
## 데이터 소스 참조
data.<리소스 유형>.<이름>.<속성>

data "local_file" "abc" {
  filename = "${path.module}/abc.txt"
}
```

## 입력 변수 (Variable)
인프라를 구성하는 데 필요한 속성 값을 정의해 코드의 변경 없이 여러 인프라를 생성하는 데 목적을 둔다.
> 단, 테라폼에서는 일반적인 변수 선언 방식과 달리 **Plan** 수행 시 값을 입력하기 때문에 입력 변수라고 한다.

- 변수 이름은 동일 모듈 내 모든 변수 선언에서 고유해야 한다.
```terraform
variable "<이름>" {
  <인수> = <값>
}

variable "image_id" {
   type = string
}
```

### 이미 예약되어 있는 변수 이름(사용 불가)
- source
- version
- providers
- count
- for_each
- lifecycle
- depends_on
- locals

### 사용 가능한 메타인수
- `default` : 변수에 할당되는 기본값 정의
- `type` : 변수에 허용되는 값 유형 정의
- `description` : 입력 변수의 설명
- `validation` : 변수 선언의 제약조건을 추가해 유효성 검사 규칙을 정의
- `sensitive` : 민감한 변수 값임을 알리고 테라폼의 출력문에서 값 노출을 제한
- `nullable` : 변수에 값이 없어도 됨을 지정

### 변수 유형

- 기본 유형
  - `string`
  - `number`
  - `bool`
  - `any` : 명시적으로 모든 유형이 허용됨을 표시

- 집합 유형
  - `list`
  - map : 키 값을 기준으로 **정렬**
  - set : 정렬 키 값 기준으로 **정렬**
  - object
  - tuple


### 민감한 변수 취급(Sensitive)
보안성이 필요한 변수들은 `sensitive` 옵션을 추가하여 terraform apply 를 수행한다.

```terraform
variable "my_password" {
  default = "password"
  sensitive = true
}

resource "local_file" "abc" {
  content = "var.my.password"
  filename = "${path.module}/abc.txt"
}
```
```
$ terraform apply

...

~ content         = (sensitive)

```
- `sensitive` 를 통해 content 값이 감춰진 것을 확인할 수 있다.
  - 이렇게 State 파일의 보안에 유의해야한다.





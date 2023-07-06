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
-


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



## Terraform Type
- String
- Number
- Bool
- List
- Set
- Map
- Tuple

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
    hostname = "app.terraform.io"
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



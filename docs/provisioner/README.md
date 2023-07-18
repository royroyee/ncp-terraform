# Provisioner
프로비저너란 프로바이더와 비슷한 의미이지만, **프로바이더로 실행되지 않는 커맨드와 파일 복사 같은 역할을 수행**

### 언제 사용할까?
- 서버 생성 뿐만 아니라 해당 서버 안에서 특정 리눅스 패키지를 설치해야 할 경우
- 특정 파일을 생성해야 하는 경우
- 기타 등등

### 프로비저닝의 사용을 최소화하는 것이 권장
- 프로비저너로 실행된 결과는 테라폼의 상태 파일과 동기화되지 않으므로 프로비저닝에 대한 결과가 항상 같다고 보장할 수 없음
  - 때문에 최소화하는 것이 권장됨

### local-exec 프로비저너
프로비저너의 경우 리소스 프로비저닝 이후 동작하도록 구성할 수 있다.
- `local-exec` 은 테라폼이 실행되는 환경에서 수행할 커맨드를 정의한다.
  - 리눅스나 윈도우 등 테라폼을 실행하는 환경에 맞게 설정 커맨드를 정의해야 한다.

#### 사용되는 인수 값
- **command**(필수) : 실행할 명령줄을 입력하며 `<<` 연산자를 통해 여러 줄의 커맨드를 입력 가능
- **working_dir**(선택) : `command` 의 명령을 실행할 디렉토리를 지정해야 하고 상대/절대 경로로 설정
- **interpreter**(선택) : 명령을 실행하는 데 필요한 인터프리터를 지정
  - 첫 번째 인수 : 인터프리터 이름
  - 두 번째 인수 : 인터프리터 인수 값
- **environment**(선택) : 실행 시 환경 변수는 실행 환경의 값을 상속받음
  - 추가 또는 재할당하려는 경우 해당 인수에 key = value 형태로 설정

#### 예시 (Unix,Linux,Mac OS)
```HCL
resource "null_resource" "example1" {
  provisioner "local-exec" {
    
    command = <<EOF
      echo Hello!! > file.txt
      echo $ENV >> file.txt
      EOF
    
    interpreter = ["bash", "-c"]
    
    working_dir = "/tmp"
    
    environment = {
      ENV = "world!!"
    }
  }
}
```


### remote connection
remote-exec 과 file 프로비저너를 사용하려면 먼저 원격지에 연결할 SSH 정의가 필요하다.
````HCL
resource "null_resource" "example" {
  
  connection {
    type = "ssh"
    user = "root"
    password = var.root.password
    host = var.host
  }
  
  provisioner "file" {
    source = "conf/myapp.conf"
    destination = "/etc/myapp.conf"
  }
  
}
````
- 이외에도 여러 인수들이 존재 참고 : https://developer.hashicorp.com/terraform/language/resources/provisioners/connection

### file 프로비저너
테라폼을 실행하는 시스템에서 연결 대상으로 파일 또는 디렉토리를 복사하는데 사용

#### 인수
- **source** : 소스 파일 또는 디렉토리, 현재 작업 중인 디렉토리에 대한 상대 경로 또는 절대 경로로 지정
  - `content` 와 함께 사용할 수 없음
- **content** : 연결 대상에 복사할 내용을 정의하며 대상이 디렉토리인 경우 `tf-file-content` 파일이 생성
  - 파일인 경우 해당 파일에 내용이 기록됨
  - `source` 와 함께 사용할 수 없음
- **destination**(필수) : 필수 항목, 항상 절대 경로로 지정되어야 하며 파일 또는 디렉토리
  - ssh 연결 시 대상 디렉토리가 존재해야 함

#### 예시
```HCL
resource "null_resource" "foo" {
  
  # myapp.conf 파일이 /etc/myapp.conf 로 업로드
  provisioner "file" {
    source = "conf/myapp.conf"
    destination = "/etc/myapp.conf"
  }
  
  # content 의 내용이 /tmp/file.log 파일로 생성
  provisioner "file" {
    content = "ami used: ${self.ami}"
    destination = "/tmp/file.log"
  }
  
  # configs.d 디렉토리가 /etc/configs.d 로 업로드
  provisioner "file" {
    source = "conf/configs.d"
    destination = "/etc"
  }
}
```

### remote-exec 프로비저너
원격지 환경에서 실행할 커맨드와 스크립트를 정의
- ex) AWS의 EC2 인스턴스 생성 후 해당 VM 에서 명령 실행 및 패키지 설치 동작 정의

#### 인수
- **inline** : 명령에 대한 목록
- **script** : 로컬의 스크립트 경로를 넣고 원격에 복사해 실행
- **scripts** : 로컬의 스크립트 경로의 목록

#### 예제
file 프로바이더로 해당 스크립트를 업로드 후 `inline` 인수를 통해 스크립트에 인수 추가
```HCL
resource "aws_instance" "web" {
  # ..
  
  connection {
    type = "ssh"
    user = "root"
    password = var.root.password
    host = self.public_ip
  }
  
  provisioner "file" {
    source = "script.sh"           #  file 프로바이더를 활용해서 현재 로컬 경로에 있는 파일을 
    destination = "/tmp/script.sh" # remote 에 tmp 폴더에 옮기고
  }
  
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "/tmp/script.sh args",
    ]
  }
}
```



## null_resource, terraform_data

### null_resource
아무 작업도 수행하지 않는 리소스를 구현할 때 사용
- 테라폼 프로비저닝 동작을 설계하면서 사용자가 의도적으로 프로비저닝 동작을 조율해야하는 상황이 발생
- 프로바이더가 제공하는 리소스 수명주기 관리만으로는 이를 해결하기 어려움

#### 주로 사용되는 경우
- 프로비저닝 수행 과정에서 명렁어 실행
- 프로비저너와 함께 사용
- 모듈, 반복문, 데이터 소스, 로컬 변수와 함께 사용
- 출력을 위한 데이터 가공

#### 예시
아래 예시는 AWS EC2 인스턴스를 프로비저닝하기 위해 `aws_instance` 리소스 구성 시 앞서 확인한 프로비저너를 활용하여 웹 서비스를 실행하고자 하는 코드이다.
```HCL

# 생략

resource "aws_instance" "foo" {
  ami = "ami-5189a661"
  instance_type = "t2.micro"
  
  private_ip = "10.0.0.12"
  subnet_id = aws_subnet.tf_test_subnet.id
  
  provisioner "remote-exec" {
    inline = [
      "echo ${aws_eip.bar.public_ip}"
    ]
  }
}

resource "aws_eip" "bar" {
  vpc = true
  
  instance = aws_instance.foo.id
  associate_with_private_ip = "10.0.0.12"
  depends_on = [aws_internete_gateway.gw]
}

```




### terraform_data
# Terraform 으로 NCP VPC 구성하기

출처 : https://blog.naver.com/n_cloudplatform/222189643849
예제코드 : https://github.com/NaverCloudPlatform/terraform-provider-ncloud/blob/main/examples/vpc/scenario02/main.tf

![img.png](img/img.png)
- ex1 테라폼 예제는 위 구조를 생성



### 생성되는 리소스
- VPC 1개
- Subnet 2개
- NAT Gateway 1개
- Network ACL 2개
- Server 2개 (Frontend, Backend)
- Public IP 1개
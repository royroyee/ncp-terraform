# HCL


## HCL 기본 사항

```HCL
resource "local_file" "pet" {
    filename = "/root/pets.txt"
    content = "We love pets!"
}
```
- 기본적으로 `Block`. `Resource Type`, `Resource Name` , `Arguments` 으로 구성
  - Block Name : resource
  - Resource Type : "local_file"
  - Resource Name : "pet"
  - Arguments : filename , content (key-value 형태)
- 
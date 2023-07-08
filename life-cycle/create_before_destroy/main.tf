
# 테라폼의 라이프사이클은 삭제->생성이다. create_before_destroy 를 통해 이 순서를 바꿀 수 있다.
# true 로 설정한다면, 변경된 리소스를 생성 후에 삭제한다.
resource "local_file" "abc" {
  content = "lifecycle - step 1"
  filename = "${path.module}/abc.txt"

  lifecycle {
   # create_before_destroy = false
    create_before_destroy = true
  }
}
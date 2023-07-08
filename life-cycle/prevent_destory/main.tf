resource "local_file" "abc" {
  content = "lifecycle - step 3"
  filename = "${path.module}/abc.txt"

  lifecycle {
    prevent_destroy = true  # 삭제 방지
  }
}
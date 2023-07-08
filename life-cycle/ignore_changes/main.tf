
# content 가 변경되더라도 적용되지 않는다. 모든 변경 사항을 무시하고 싶다면, ignore_changes = all
resource "local_file" "abc" {
  content = "lifecycle - step 3"
  filename = "${path.module}/abc.txt"

  lifecycle {
    ignore_changes = [
      content
    ]
  }
}
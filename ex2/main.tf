resource "kubernetes_namespace" "example" {
  metadata {
    annotations = {
      name = "example-annotation"
    }
    name = "terrafrom-example-namespace"
  }
}

resource "kubernetes_secret" "example" {
  metadata {
    namespace = "kubernetes_namespace.example.metadata.0.name" # 위에서 선언한 example 리소스의 인수 참조

    name = "terraform-example"
  }
  data = {
    password = "P4ssw0rd"
  }
}
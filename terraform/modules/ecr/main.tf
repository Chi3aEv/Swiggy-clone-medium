resource "aws_ecr_repository" "app" {
  name = "swiggy-clone"

  lifecycle {
    prevent_destroy = true
  }
}
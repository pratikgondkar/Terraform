# bucket creation
resource "aws_s3_bucket" "example" {
  bucket = var.bucket-name
  versioning {
    enabled = var.versioning
   }
  tags = {
    Name        = var.tags-name
    Environment = var.tags-env
  }
}

resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name = var.name-dyno
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20
  attribute {
    name = "LockID"
    type = "S"
  }
}


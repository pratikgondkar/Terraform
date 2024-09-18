variable "bucket-name" {
  type = string
  default = "pratikbucketrana"
}

variable "versioning" {
  type = bool
  default = true
}

variable "tags-name" {
  type = string
  default = "my bucket"
}

variable "tags-env" {
  type = string
  default = "Dev"
}

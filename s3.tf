resource "aws_s3_bucket" "s3-bucket" {
  bucket = "mucci-terra"

  tags = {
    Name        = "mucci-terra"
    Environment = "Dev"
  }
}
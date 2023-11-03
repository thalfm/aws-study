resource "random_pet" "lambda_bucket_name" {
  prefix = "terraform-lambda-functions"
  length = 4
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = random_pet.lambda_bucket_name.id
}

#resource "aws_s3_bucket_acl" "bucket_acl" {
#  bucket = aws_s3_bucket.lambda_bucket.id
#  acl    = "private"
#}

output "aws_lambda_bucket_name" {
  value = "${aws_s3_bucket.lambda_bucket.bucket}"
}
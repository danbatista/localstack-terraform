resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
}

resource "aws_lambda_permission" "s3_trigger" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${aws_s3_bucket.bucket.id}"
}


# Create S3 Bucket Event Trigger
resource "aws_s3_bucket_notification" "test_bucket_notification" {
  bucket = aws_s3_bucket.bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda.arn
    events              = ["s3:ObjectCreated:*"]
    #filter_prefix       = "*"
  }
}

variable "bucket_name" {
  description = "test-bucket"
}

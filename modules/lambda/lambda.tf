resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "admin_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.iam_for_lambda.name
}

data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "././lambda-function"
  output_path = "lambda_function.zip"
}

resource "aws_cloudwatch_log_group" "lambda_logs" {
  name = "/aws/lambda/test_lambda"
}

resource "aws_lambda_function" "lambda" {
  filename         = "lambda_function.zip"
  function_name    = "test_lambda"
  role             = aws_iam_role.iam_for_lambda.arn
  runtime          = "python3.9"
  handler          = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.lambda.output_base64sha256

  # Attach Lambda to CloudWatch Logs
  tracing_config {
    mode = "Active"
  }

  environment {
    variables = {
      LOG_GROUP_NAME = aws_cloudwatch_log_group.lambda_logs.name
    }
  }
}

variable "lambda_function" {
  description = "test_lambda"
}
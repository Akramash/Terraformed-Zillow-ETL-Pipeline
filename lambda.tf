# Define the IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda-s3-full-access-role"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Attach the S3 Full Access Policy to the Role
resource "aws_iam_role_policy_attachment" "lambda_s3_access" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# Define the Lambda Function
resource "aws_lambda_function" "lambda_function" {
  filename         = "lambda_function.zip"   # This will be created in step 4
  function_name    = "MyLambdaFunction"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"  # This references the Python handler
  runtime          = "python3.10"
  architectures    = ["x86_64"]

  # Lambda Layer ARN for Pandas
  layers = [
    "arn:aws:lambda:us-east-1:336392948345:layer:AWSSDKPandas-Python310:20"
  ]
}

# Define the S3 Bucket Notification to trigger Lambda on file creation
resource "aws_s3_bucket_notification" "s3_bucket_notification" {
  bucket = "end2endyoutube-ym-bucket"  # Name of the S3 bucket

  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda_function.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3_to_invoke_lambda]
}

# Allow the S3 bucket to invoke the Lambda function
resource "aws_lambda_permission" "allow_s3_to_invoke_lambda" {
  statement_id  = "AllowS3InvokeLambda"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "s3.amazonaws.com"

  # Ensure the permission is scoped to your bucket only
  source_arn = "arn:aws:s3:::end2endyoutube-ym-bucket"
}

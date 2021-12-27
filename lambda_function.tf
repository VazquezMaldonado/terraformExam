

data "aws_caller_identity" "current" {}

resource "aws_iam_role" "create_role" {
  name = "${var.iam_role_for_lambda}"
  assume_role_policy = <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "lambda.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        }
      ]
    }
  EOF

	 tags = {
    DEV_EXAM        = "Alfredo Vazquez Maldonado"
  }
}

resource "aws_lambda_permission" "lambda_permissions" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.blob_bucket_for_workexam.arn
  source_account = data.aws_caller_identity.current.account_id
}

resource "aws_lambda_function" "test_lambda" {
  filename      = "src/python_code.zip"
  function_name = "lambda_function"
  role          = aws_iam_role.create_role.arn
  // handler se forma con el nombre del archivo python y el nombre de la funcion principal
  handler = "lambda_code.lambda_handler"
  source_code_hash = filebase64sha256("src/python_code.zip")
  runtime = "python3.9"
  environment {
    variables = {
      DYNAMO_TABLE = "${var.dynamodb_name}"
    }
  }
}

 
resource "aws_s3_bucket_notification" "aws-lambda-trigger" {
  bucket = "${aws_s3_bucket.blob_bucket_for_workexam.id}"
  lambda_function {
    lambda_function_arn = "${aws_lambda_function.test_lambda.arn}"
    events              = ["s3:ObjectCreated:*"]
    filter_prefix = "images/"
  }
  depends_on = [aws_lambda_permission.lambda_permissions]
}

resource "aws_iam_role_policy_attachment" "S3LambdaDynamoDB_Role" {
  role       = aws_iam_role.create_role.id
  count      = "${length(var.iam_policy_arn_lambda)}"
  policy_arn = "${var.iam_policy_arn_lambda[count.index]}"
}

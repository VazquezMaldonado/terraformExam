// S3 bucket vars
s3_bucket_name = "mybucketstaticpage"
myblobbucketforexam = "myblobbucketforexam"

// DynamoDB vars
dynamodb_name = "mydynamoDBExam"

// Lambda vars
iam_role_for_lambda = "iam_role_for_lambda"
iam_policy_arn_lambda = [
  "arn:aws:iam::aws:policy/CloudWatchFullAccess", 
  "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
  "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
] 
lambda_iam_policy_name = "lambda_iam_policy_name"

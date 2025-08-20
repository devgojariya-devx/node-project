resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_exec" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "sample_lambda" {
  function_name = "sample-nodejs-lambda"
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  role          = aws_iam_role.lambda_exec_role.arn          # reference IAM role here

  filename         = "lambda_package.zip"
  source_code_hash = filebase64sha256("lambda_package.zip")
}

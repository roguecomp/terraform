variable "region" {
  description = "Describes the AWS region"
  type        = string
  default     = "ap-southeast-2"
}

variable "lambda_payload_zip" {
  description = "filename of ZIP file containing AWS Lambda source code"
  type        = string
  default     = "lambda.zip"
}

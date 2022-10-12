provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket = "minecraft-fargate-tf-state"
    key    = "s3_static_website.tfstate"
    region = "ap-southeast-2"
  }
}

resource "aws_s3_bucket" "s3_static_website" {
  bucket = var.www_url
  force_destroy = true

  tags = {
    Name = var.url
  }
}

resource "aws_s3_bucket_policy" "allow_access" {
  bucket = aws_s3_bucket.s3_static_website.id

  policy = jsonencode({
    "Version" : "2012-10-17"
    "Statement" : [
      {
        "Sid" : "PublicReadGetObject"
        "Effect" : "Allow"
        "Principal" : "*"
        "Action" : "s3:GetObject"
        "Resource" : [
          aws_s3_bucket.s3_static_website.arn,
          "${aws_s3_bucket.s3_static_website.arn}/*",
        ]
      }
    ]
  })
}


resource "aws_s3_bucket_acl" "s3_static_website_acl" {
  bucket = aws_s3_bucket.s3_static_website.id
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "s3_static_website" {
  bucket = aws_s3_bucket.s3_static_website.bucket

  index_document {
    suffix = "index.html"
  }
}

# ================================================================


# resource "aws_s3_bucket" "www" {
#   bucket = var.www_url
#   tags = {
#     Name = var.url
#   }
# }

# resource "aws_s3_bucket_acl" "www" {
#   bucket = aws_s3_bucket.www.id

#   acl = "private"
# }

# resource "aws_s3_bucket_website_configuration" "www" {
#   bucket = aws_s3_bucket.s3_static_website.id

#   redirect_all_requests_to {
#     host_name = var.url
#   }
# }

resource "aws_s3_object" "object" {
  bucket = var.www_url
  key    = "index.html"
  source = "src/index.html"
  acl    = "public-read"
  content_type = "text/html"
  etag   = filemd5("src/index.html")

  depends_on = [
    aws_s3_bucket.s3_static_website
  ]
}
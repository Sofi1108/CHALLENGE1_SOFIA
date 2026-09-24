terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

locals {
  bucket_name = "challenge1-sofia-torcal"
  bucket_arn  = "arn:aws:s3:::${local.bucket_name}"
}

resource "aws_s3_bucket_website_configuration" "sitio" {
  bucket = local.bucket_name

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "sitio" {
  bucket = local.bucket_name

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "sitio" {
  bucket     = local.bucket_name
  depends_on = [aws_s3_bucket_public_access_block.sitio]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${local.bucket_arn}/*"
      }
    ]
  })
}

resource "aws_s3_object" "index" {
  bucket       = local.bucket_name
  key          = "index.html"
  source       = "${path.module}/src/index.html"
  content_type = "text/html; charset=utf-8"
  etag         = filemd5("${path.module}/src/index.html")
}

resource "aws_s3_object" "styles" {
  bucket       = local.bucket_name
  key          = "styles.css"
  source       = "${path.module}/src/styles.css"
  content_type = "text/css"
  etag         = filemd5("${path.module}/src/styles.css")
}

resource "aws_s3_object" "script" {
  bucket       = local.bucket_name
  key          = "script.js"
  source       = "${path.module}/src/script.js"
  content_type = "application/javascript"
  etag         = filemd5("${path.module}/src/script.js")
}

output "url_de_tu_web" {
  value = "http://${aws_s3_bucket_website_configuration.sitio.website_endpoint}"
}


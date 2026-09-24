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
}

resource "aws_s3_bucket" "challenge1_sofia_torcal" {
  bucket = local.bucket_name

  tags = {
    Name = "terraform-s3-challenge1"
  }
}

import {
  to = aws_s3_bucket.challenge1_sofia_torcal
  id = local.bucket_name
}

resource "aws_s3_bucket_website_configuration" "sitio" {
  bucket = aws_s3_bucket.challenge1_sofia_torcal.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "sitio" {
  bucket = aws_s3_bucket.challenge1_sofia_torcal.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "sitio" {
  bucket     = aws_s3_bucket.challenge1_sofia_torcal.id
  depends_on = [aws_s3_bucket_public_access_block.sitio]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.challenge1_sofia_torcal.arn}/*"
      }
    ]
  })
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.challenge1_sofia_torcal.id
  key          = "index.html"
  source       = "${path.module}/src/index.html"
  content_type = "text/html; charset=utf-8"
  etag         = filemd5("${path.module}/src/index.html")
}

resource "aws_s3_object" "styles" {
  bucket       = aws_s3_bucket.challenge1_sofia_torcal.id
  key          = "styles.css"
  source       = "${path.module}/src/styles.css"
  content_type = "text/css"
  etag         = filemd5("${path.module}/src/styles.css")
}

resource "aws_s3_object" "script" {
  bucket       = aws_s3_bucket.challenge1_sofia_torcal.id
  key          = "app.js"
  source       = "${path.module}/src/app.js"
  content_type = "application/javascript"
  etag         = filemd5("${path.module}/src/app.js")
}

output "url_de_tu_web" {
  value = "http://${aws_s3_bucket_website_configuration.sitio.website_endpoint}"
}


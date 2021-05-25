resource "aws_cloudfront_distribution" "s3_distribution" {
  
  enabled = true
  default_root_object = "index.html"
  price_class = "PriceClass_200"

  origin {
    domain_name = "${aws_s3_bucket.b.id}.s3-${var.aws_region}.amazonaws.com"
    origin_id = aws_s3_bucket.b.id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods  = ["HEAD", "GET"]
    cached_methods   = ["HEAD", "GET"]
    target_origin_id = aws_s3_bucket.b.id

    viewer_protocol_policy = "redirect-to-https"

    function_association  {
      event_type   = "viewer-request"
      function_arn    = aws_cloudfront_function.test.arn
    }

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

}

resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "cloudfront origin access identity"
}



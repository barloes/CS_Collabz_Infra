resource "aws_cloudfront_function" "test" {
  name    = "test"
  runtime = "cloudfront-js-1.0"
  comment = "url_appender"
  publish = true
  code    = file("${path.module}/function.js")
}
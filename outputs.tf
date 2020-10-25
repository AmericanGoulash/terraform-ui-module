output "top_bucket_website_endpoint" {
  value = aws_s3_bucket.top_bucket.website_endpoint
}
output "top_bucket" {
  value = aws_s3_bucket.top_bucket
}
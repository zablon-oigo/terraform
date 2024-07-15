output "bucket" {
  value       = aws_s3_bucket.bucket.id         
}
output "object" {
  value       = aws_s3_object.object.id          
}
output "rule" {
  value       = aws_s3_bucket_lifecycle_configuration.rule.id           
}
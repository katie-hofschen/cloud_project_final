# This file instructs terraform to copy everything from the S3 bucket 
# that you created on AWS to the EC2 machine under the filepath ~/artifacts

resource "aws_s3_bucket_object" "artifacts" {
  for_each = fileset("${var.source_dir}/artifacts", "**/*")

  bucket = var.s3_bucket
  source = "${var.source_dir}/artifacts/${each.value}"

  key    = "artifacts/${each.value}"
  etag   = filemd5("${var.source_dir}/artifacts/${each.value}")
}
resource "aws_s3_bucket" "bucket" {
  bucket_prefix = "${var.s3_bucket_prefix}"
  acl           = "public-read"

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_object" "lambda" {
  bucket = "${aws_s3_bucket.bucket.id}"
  key    = "lambda.zip"
  source = "${data.archive_file.lambda.output_path}"
  etag   = "${data.archive_file.lambda.output_md5}"
}

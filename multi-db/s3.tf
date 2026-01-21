resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "backup_bucket" {
  bucket = "multi-db-backup-${random_id.bucket_suffix.hex}"
  force_destroy = true # Allow destroying bucket even if it has files (optional, but good for dev)

  tags = {
    Name = "multi-db-backup-bucket"
  }
}

resource "aws_s3_bucket_versioning" "backup_bucket_versioning" {
  bucket = aws_s3_bucket.backup_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

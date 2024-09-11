# S3 bucket for cleaned data
resource "aws_s3_bucket" "cleaned_data_csv_bucket" {
  bucket = "cleaned-data-csv-bucket-ak"

  # Add tags if necessary
  tags = {
    Name        = "cleaned-data-csv-bucket-ak"
    Environment = "production"
  }
}

# Versioning for cleaned data bucket
resource "aws_s3_bucket_versioning" "cleaned_data_csv_bucket_versioning" {
  bucket = aws_s3_bucket.cleaned_data_csv_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# S3 bucket for end2endyoutube-ym-bucket
resource "aws_s3_bucket" "end2end_youtube_bucket" {
  bucket = "end2endyoutube-ym-bucket"

  # Add tags if necessary
  tags = {
    Name        = "end2endyoutube-ym-bucket"
    Environment = "production"
  }
}

# Versioning for end2endyoutube-ym-bucket
resource "aws_s3_bucket_versioning" "end2end_youtube_bucket_versioning" {
  bucket = aws_s3_bucket.end2end_youtube_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

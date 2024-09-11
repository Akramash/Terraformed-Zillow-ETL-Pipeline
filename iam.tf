# iam.tf

# IAM Role for EC2 to access S3
resource "aws_iam_role" "ec2_s3_access_role" {
  name = "ec2_s3_access_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Role Policy for S3 Access
resource "aws_iam_role_policy" "ec2_s3_access_policy" {
  name = "ec2_s3_access_policy"
  role = aws_iam_role.ec2_s3_access_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:*"
        ],
        Resource = "*"
      }
    ]
  })
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_s3_access_role.name
}

# IAM Role for Redshift to access S3
resource "aws_iam_role" "redshift_iam_role" {
  name = "redshift-iam-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "redshift.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# IAM Policy for Redshift to access S3
resource "aws_iam_role_policy" "redshift_s3_policy" {
  name = "redshift-s3-policy"
  role = aws_iam_role.redshift_iam_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:*"
        ],
        Resource = "*"
      }
    ]
  })
}

# Attach IAM Roles to Redshift Cluster
resource "aws_redshift_cluster_iam_roles" "redshift_cluster_iam_roles" {
  cluster_identifier = aws_redshift_cluster.redshift_cluster.cluster_identifier
  iam_role_arns      = [aws_iam_role.redshift_iam_role.arn]
}
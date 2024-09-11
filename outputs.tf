# outputs.tf

# Output the public IP of the EC2 instance
output "ec2_public_ip" {
  description = "The public IP of the Airflow EC2 instance"
  value       = aws_instance.airflow_instance.public_ip
}

# Output the security group ID
output "security_group_id" {
  description = "Security Group ID"
  value       = aws_security_group.airflow_sg.id
}

# Output Redshift Endpoint
output "redshift_endpoint" {
  description = "Redshift endpoint"
  value       = aws_redshift_cluster.redshift_cluster.endpoint
}

# Output Redshift Port
output "redshift_port" {
  description = "Redshift port"
  value       = aws_redshift_cluster.redshift_cluster.port
}

output "lambda_function_arn" {
  description = "The ARN of the Lambda function"
  value       = aws_lambda_function.lambda_function.arn
}

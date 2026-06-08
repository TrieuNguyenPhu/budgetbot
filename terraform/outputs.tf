# =============================================================================
# Outputs
# =============================================================================

# ---- VPC ----

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

# ---- EC2 ----

output "ec2_public_ip" {
  description = "Public IP of the web server"
  value       = aws_instance.web.public_ip
}

output "ec2_public_dns" {
  description = "Public DNS of the web server"
  value       = aws_instance.web.public_dns
}

output "web_url" {
  description = "URL to access the BudgetBot web application"
  value       = "http://${aws_instance.web.public_ip}"
}

output "ssh_command" {
  description = "SSH command to connect to the web server"
  value       = "ssh -i ${local_file.private_key.filename} ec2-user@${aws_instance.web.public_ip}"
}

output "ssh_private_key_file" {
  description = "Path to the auto-generated SSH private key file"
  value       = local_file.private_key.filename
}

# ---- RDS ----

output "rds_endpoint" {
  description = "RDS MySQL endpoint (host:port)"
  value       = aws_db_instance.mysql.endpoint
}

output "rds_hostname" {
  description = "RDS MySQL hostname"
  value       = aws_db_instance.mysql.address
}

output "rds_port" {
  description = "RDS MySQL port"
  value       = aws_db_instance.mysql.port
}

output "rds_database_name" {
  description = "RDS MySQL database name"
  value       = aws_db_instance.mysql.db_name
}

# ---- S3 ----

output "s3_bucket_name" {
  description = "S3 bucket name for static assets"
  value       = aws_s3_bucket.assets.id
}

output "s3_bucket_arn" {
  description = "S3 bucket ARN"
  value       = aws_s3_bucket.assets.arn
}

# ---- Sensitive ----

output "db_password" {
  description = "Auto-generated RDS MySQL password (use: terraform output -raw db_password)"
  value       = random_password.db_password.result
  sensitive   = true
}

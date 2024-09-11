# Security Group for Redshift Cluster
resource "aws_security_group" "redshift_sg" {
  vpc_id = aws_vpc.airflow_vpc.id

  ingress {
    from_port   = 5439
    to_port     = 5439
    protocol    = "tcp"
    security_groups = [aws_security_group.airflow_sg.id] # Allow EC2 instance to access Redshift
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Redshift Subnet Group
resource "aws_redshift_subnet_group" "redshift_subnet_group" {
  name       = "redshift-subnet-group"   
  description = "Subnet group for Redshift cluster"
  subnet_ids = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id,
    aws_subnet.public_subnet_3.id
  ]
}

# Redshift Cluster
resource "aws_redshift_cluster" "redshift_cluster" {
  cluster_identifier = "tf-redshift-cluster"
  database_name      = "mydb"
  master_username    = "adminuser"
  master_password    = "Adminpass123"
  node_type          = "dc2.large"
  number_of_nodes    = 2
  cluster_subnet_group_name = aws_redshift_subnet_group.redshift_subnet_group.name
  vpc_security_group_ids    = [aws_security_group.redshift_sg.id]
  skip_final_snapshot       = true
  publicly_accessible       = false

  tags = {
    Name = "RedshiftCluster"
  }
}

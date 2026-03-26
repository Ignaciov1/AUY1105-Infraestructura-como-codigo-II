# --- CORRECCIÓN CKV2_AWS_41: IAM Role para EC2 ---
resource "aws_iam_role" "ec2_role" {
  name = "role-ec2-log-access"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
}

# --- CORRECCIÓN CKV2_AWS_11: VPC Flow Logs ---
resource "aws_cloudwatch_log_group" "vpc_logs" {
  name = "vpc-flow-logs"
}

resource "aws_iam_role" "vpc_flow_log_role" {
  name = "vpc-flow-log-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "vpc-flow-logs.amazonaws.com" }
    }]
  })
}

resource "aws_flow_log" "mi_vpc_flow_log" {
  iam_role_arn    = aws_iam_role.vpc_flow_log_role.arn
  log_destination = aws_cloudwatch_log_group.vpc_logs.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.mi_vpc.id
}

# --- CORRECCIÓN CKV2_AWS_12: Restringir Default Security Group ---
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.mi_vpc.id
  # No definimos reglas de ingress ni egress, lo que bloquea todo el tráfico por defecto
}
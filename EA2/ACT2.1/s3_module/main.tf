# Creación del Bucket
resource "aws_s3_bucket" "mi_bucket" {
  bucket = "${var.bucket_prefix}-${var.bucket_suffix}"
  tags   = var.tags
}

# Habilitar el Versionado
resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.mi_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Desactivar el bloqueo de acceso público (Necesario para lectura pública)
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.mi_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Política de acceso público (Solo Lectura)
resource "aws_s3_bucket_policy" "read_only_policy" {
  bucket = aws_s3_bucket.mi_bucket.id
  # Espera a que se desactive el bloqueo de acceso público
  depends_on = [aws_s3_bucket_public_access_block.public_access]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.mi_bucket.arn}/*"
      },
    ]
  })
}
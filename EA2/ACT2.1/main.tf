# --- MÓDULO DE RED (VPC) ---
module "vpc" {
  source                = "./vpc_module"
  vpc_cidr              = "10.1.0.0/16"
  vpc_name              = "mi-vpc-principal"
  subnet_publica_1_cidr = "10.1.1.0/24"
  subnet_publica_2_cidr = "10.1.2.0/24"
  subnet_privada_1_cidr = "10.1.3.0/24"
  subnet_privada_2_cidr = "10.1.4.0/24"
  az_1                  = "us-east-1a"
  az_2                  = "us-east-1b"
}

# --- MÓDULO DE COMPUTO (EC2) ---
module "ec2" {
  source               = "./ec2_module"
  ami                  = "ami-012967cc5a8c9f891"
  vpc_id               = module.vpc.vpc_id
  instance_name        = "MiInstancia"

  # Tu IP pública para acceso seguro 
  mi_ip_publica        = "152.230.70.226/32"

  # Conexión con los IDs de las subredes (Outputs de tu VPC) 
  subnet_id_pub_1      = module.vpc.subnet_publica_1_id
  subnet_id_pub_2      = module.vpc.subnet_publica_2_id
  subnet_id_privada    = module.vpc.subnet_privada_id

  # Llave original para la primera instancia
  key_name             = "mi_key_name"
  public_key           = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDiuFUssdtHg8Y3rWGZFCSD58hSr4IqjFVKeid9d0G3bk7w99/AOyL/C45PnFodjOtD1eMndiCd40BqagdOYtKoieqlOTlmShrvE7N2A+MeaOP4CWLx7fj2MfekecPPFRAiMUCZk51SHxFr4oqX4Qhj8BkG1cG30p9QB+stfJKT3tUGczxUB1aor9qoLmPDTfaE4iSmNDscVmqQhX9jkppdzkg2ENh5cDO2EtLlHHxIodXLgetpWjBP68r90q/gwZV69XANcTWjZiZRyDmb9nIfQiZOO5C03FoG0GmTSZkAfvZdq7M2GsQSboln44VW/ukyQKFRVVepOCIHTaqcsjhV"

  # NUEVA Llave para instancias adicionales (Requerimiento de la tarea) 
  # Pega aquí el contenido del archivo .pub que generaste
  public_key_adicional = "ssh-rsa PEGA_AQUI_EL_TEXTO_DE_LA_LLAVE_NUEVA" 
}
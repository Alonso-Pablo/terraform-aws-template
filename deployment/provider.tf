# Terraform soporta muchos proveedores en la nube.
# Declaramos que el proveedor es AWS:
provider "aws" {
  region  = "${var.aws_region}" # Region a donde deployar.
  profile = "${var.aws_profile}" # Perfil en awscli.
}

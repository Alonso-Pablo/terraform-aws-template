# `deployment/` dir
- `ecr.tf`
  - Creamos un bloque para definir el **nombre del contenedor en ECR** de Amazon.

- `fargate.tf`
  - Creamoss 3 bloques para el servicio Fargate.
  - Fargate es un servicio que usaremos para **deployar contenedores de Docker**.

- `iam.tf`
  - Creamos un bloque para establecer un **nuevo rol de IAM** para Amazon.

- `network.tf`
  - Creamos una **Virtual Private Cloud en Amazon** (VPC).
  - Al publico el ingreso solo esta permitido por el puerto 3000.
  - El trafico saliente no está restringido.

- `provider.tf`
  - Definimos los proovedores necesarios para el deployment.
  - En este caso usaremos AWS, definimos la region y el perfil en awscli

- `terraform.tfvars`
  - Definimos las variables a usar en Terraform.

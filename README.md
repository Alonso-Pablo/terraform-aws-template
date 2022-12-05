# Antes de todo:
- Instalar:
  - `node`
  - `terraform`
  - `docker`
  - `awscli`
- Tener un poco de **dinero para gastar** en esta prueba con AWS.

# Pasos:
## Generamos imagen con Docker 💿
```bash
# Crea una imagen a partir del `Dockerfile` llamada some-image-name
docker build -t some-image-name .
```
## Corremos la imagen generada 🏃
```bash
# Para correr la imagen creada en localhost
docker run -p 12345:3000 -d some-image-name
```

#### Helpers:
```bash
# Ver los procesos corriendo en Docker
docker ps
```

```bash
# Terminar un proceso de docker
docker kill <process_name>
```

## Inicializamos Terraform 🌎

```bash
# Inicializar el directorio como contenedor de codigo de Terraform
terraform init
# Tambien descargara complementos de providers requeridos en provider.tf
```

```bash
# Muestra los cambios que va a generar en la infraestructura
terraform plan
```

```bash
# Output del comando: terraform plan
An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_ecr_repository.ecr_repo va a ser creado.
  + resource "aws_ecr_repository" "ecr_repo" {
      + arn                  = (known after apply)
      + id                   = (known after apply)
      + image_tag_mutability = "MUTABLE"
      + name                 = "ecr_example_repo"
      + registry_id          = (known after apply)
      + repository_url       = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.
```
## Creamos un repositorio en ECR para nuestra imagen 💾

```bash
# Ejecutamos el plan.
terraform apply
```
- En el ejemplo de este proyecto, va a crear en la pagina de ECR de AWS el repositorio vacio.

## Nos autenticamos 🔐

```bash
# Necesitamos autenticarnos para 'pushear' o 'pullear' las imagenes en ECR
ACCOUNT_ID=$(aws sts get-caller-identity | jq -r ".Account")
aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin "$ACCOUNT_ID.dkr.ecr.eu-west-1.amazonaws.com"
```

## 'Pusheamos' nuestra imagen de Docker al repositorio de ECR 🚢

```bash
# Similar al comando: git remote add origin
docker tag some-example-image:latest <repo_url>:latest
```

```bash
# Enviamos la imagen
docker push <repo_url>:latest
```

## Manejos de Secrets o Variables en Terraform 🙊
- Mas informacion: https://developer.hashicorp.com/terraform/language/values/variables
### En un archivo .tf
```t
# Para declarar una variable creamos un bloque con 'variable':
variable "aws_region" {
  default     = "eu-west-1"
  description = "En que region va a ser deployado?"
}
```
```t
# Para usar esta variable en los bloques de recursos o proveedores:
provider "aws" {
  region  = "${var.aws_region}"
}
```
### CLI
```bash
terraform apply -var="region=us-east-1"
```

### En un archivo de variables .tfvars
```t
# vars.tfvars
region = "us-east-1"
var = "foo"
```
```bash
# Uso:
terraform apply -var-file="vars.tfvars"
```

Encuentre la dirección IP pública en la página de tareas en la consola de AWS y vaya a para ver la aplicación hello world `http://:3000`

## Limpiar todos los recursos 🧹
- Es importante limpiar cualquier recurso que haya creado en este ejemplo para que no nos cobren en el futuro.
```bash
terraform destroy
# Va a solicitar confirmacion: yes
```

#### Notas

- ECR = (Amazon) Elastic Container Registry
- ECR == Docker Hub
- Usamos ECR porque a comparacion de Docker Hub, ECR, si nos da repositorios privados gratis/baratos (Para la imagen que creamos a partir del Dockerfile)

### Mas informacion: https://codelabs.transcend.io/codelabs/node-terraform/index.html
# (Amazon) Elastic Container Registry
# aws_ecr_repository = Algun recurso de AWS
# ecr_repo = Algun nombre que referencie el recurso de otros recursos de terraform
resource "aws_ecr_repository" "ecr_repo" {
    name = "ecr_example_repo"
}

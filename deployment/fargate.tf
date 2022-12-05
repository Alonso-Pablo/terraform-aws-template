# Fargate es el servicio que usaremos para deployar contenedores de Docker.

# Fargate es un tipo de servicio de contenedores elásticos, que tiene tres conceptos:

# 1 Task: Definimos la imagen de Docker a usar y le pasamos los roles IAM
resource "aws_ecs_task_definition" "backend_task" {
    family = "backend_example_app_family"

    // ECS = (Amazon) Elastic Compute Cloud
    // Fargate es un tipo de ECS que requiere awsvpc network_mode
    requires_compatibilities = ["FARGATE"]
    network_mode = "awsvpc"

    // Los tamaños válidos estan documentados aquí: https://aws.amazon.com/fargate/pricing/
    memory = "512"
    cpu = "256"

    // ARN = Amazon Resource Name
    // ECR = (Amazon) Elastic Container Registry
    // Fargate requiere que las definiciones de tareas tengan un rol de ejecucion ARN para admitir imágenes ECR
    execution_role_arn = "${aws_iam_role.ecs_role.arn}"

    container_definitions = <<EOT
[
    {
        "name": "example_app_container",
        "image": "<your_ecr_repo_url>:latest",
        "memory": 512,
        "essential": true,
        "portMappings": [
            {
                "containerPort": 3000,
                "hostPort": 3000
            }
        ]
    }
]
EOT
}

# 2 Cluster: Una agrupacion logica de tareas o servicios.
resource "aws_ecs_cluster" "backend_cluster" {
    name = "backend_cluster_example_app"
}

# 3 Services: Agrupamos las tareas y especificamos cuántas de cada tarea desea ejecutar a la vez.
# Hacemos uso del VPC creado en el archivo network.tf
resource "aws_ecs_service" "backend_service" {
    name = "backend_service"

    cluster = "${aws_ecs_cluster.backend_cluster.id}"
    task_definition = "${aws_ecs_task_definition.backend_task.arn}"

    launch_type = "FARGATE"
    desired_count = 1

    network_configuration {
        subnets = ["${aws_subnet.public_a.id}", "${aws_subnet.public_b.id}"]
        security_groups = ["${aws_security_group.security_group_example_app.id}"]
        assign_public_ip = true
    }
}
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

resource "docker_network" "my_network" {
  name = "my_network"
}

resource "docker_image" "resource" {
  name         = "backend-app"
  build {
    context    = "../"
    dockerfile = "../Dockerfile"
  }
}

resource "docker_image" "postgres" {
    name = "postgres:15.6"
}

resource "docker_container" "postgres" {
  name  = "postgres"
  image = docker_image.postgres.image_id
  env = [
    "POSTGRES_USER=${var.db_user}",
    "POSTGRES_PASSWORD=${var.db_password}",
    "POSTGRES_DB=${var.db_name}"
  ]
  ports {
    internal = 5432
    external = 5433
  }
  networks_advanced {
    name = docker_network.my_network.name
  }
  volumes {
    volume_name = "postgres_data"
    container_path = "/var/lib/postgresql/data"
  }
  healthcheck {
    test = ["CMD-SHELL", "pg_isready -U ${var.db_user}"]
    interval = "10s"
    retries = 5
  }
}

resource "docker_volume" "postgres_data" {
  name = "postgres_data"
}

resource "docker_container" "resource" {
  image = docker_image.resource.image_id
  name  = "tutorial"
  env = [
    "DB_HOST=${var.db_host}",
    "DB_USER=${var.db_user}",
    "POSTGRES_PASSWORD=${var.db_password}",
    "DB_NAME=${var.db_name}",
    "DB_PORT=${var.db_port}"
  ]

  ports {
    internal = 8000
    external = 8000
  }
  networks_advanced {
    name = docker_network.my_network.name
  }
  depends_on = [
    docker_container.postgres
  ]
}


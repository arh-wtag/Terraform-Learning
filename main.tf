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
    name  = "my_network"
}

resource "docker_image" "resource" {
  name         = "arafat1998/backend-app:v11.0"
  keep_locally = false
}

resource "docker_container" "resource" {
  image = docker_image.resource.image_id
  name  = "tutorial"

  ports {
    internal = 8000
    external = 8000
  }
}


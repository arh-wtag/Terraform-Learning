variable "db_user" {
  type        = string
  default     = "postgres"
  description = "this is default postgres user"
}

variable "db_password" {
  type         = string
  default      = "12345678"
  description  = "This is default postgres password"
}

variable "db_name" {
  type         = string
  default      = "resource"
  description  = "This is my Project db name"
}

variable "db_host" {
  type         = string
  default      = "postgres"
  description  = "This is my Project host name"
}

variable "db_port" {
  type         = number
  default      = 5432
  description  = "This is my Project port number"
}
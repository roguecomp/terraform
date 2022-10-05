variable "region" {
  description = "Describes the AWS region"
  type        = string
  default     = "ap-southeast-2"
}

variable "minecraft_port" {
  description = "port used by minecraft server java edition"
  type        = number
  default     = 25565
}

variable "tag" {
  description = "tag for this fargate project"
  type        = string
  default     = "fargate_cluster_minecraft"
}

variable "name_prefix" {
  description = "the general name prefix"
  type        = string
  default     = "minecraft"
}

variable "lb_name_prefix" {
  description = "the general name prefix for the load balancer"
  type        = string
  default     = "mine"
}

variable "container_cpu" {
  type        = number
  description = "How much CPU to give the container. 1024 is 1 CPU"
  default     = 512
}

variable "container_memory" {
  type        = number
  description = "How much memory in megabytes to give the container"
  default     = 1024
}

variable "image_url" {
  type        = string
  description = "docker image for running minecraft java edition server"
  default     = "itzg/minecraft-server"
}

variable "network_tag" {
  type        = string
  description = ""
  default     = "ecs-subnets"
}

variable "remote_cidr_blocks" {
  type        = list(any)
  default     = ["10.0.0.0/19"]
  description = "By default cidr_blocks are locked down. (Update to 0.0.0.0/0 if full public access is needed)"
}

variable "desired_count" {
  type        = number
  description = "number of tasks to launch"
  default     = 2
}
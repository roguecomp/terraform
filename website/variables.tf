variable "tag" {
  type        = string
  description = "Project identification tag"
  default     = "static-website"
}

variable "www_url" {
  type        = string
  description = "the www url for the website"
  default     = "www.visham.org"
}

variable "url" {
  type        = string
  description = "The url for the website"
  default     = "visham.org"
}

variable "region" {
  type        = string
  description = "AWS default region"
  default     = "ap-southeast-2"
}
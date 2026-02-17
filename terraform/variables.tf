variable "do_token" {
  description = "DigitalOcean API Token"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "Droplet region"
  type        = string
  default     = "nyc3"
}

variable "home_ip" {
  description = "Your home IP address for whitelisting"
  type        = string
}

variable "droplet_size" {
  description = "Size of the droplet"
  type        = string
  default     = "s-1vcpu-1gb"
}

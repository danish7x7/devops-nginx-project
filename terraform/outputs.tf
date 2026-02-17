output "droplet_ip" {
  description = "Public IP of the droplet"
  value       = digitalocean_droplet.web.ipv4_address
}

output "droplet_name" {
  description = "Name of the droplet"
  value       = digitalocean_droplet.web.name
}

output "access_url" {
  description = "URL to access Nginx"
  value       = "http://${digitalocean_droplet.web.ipv4_address}"
}

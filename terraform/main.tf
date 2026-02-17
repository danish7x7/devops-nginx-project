terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# Connect to DigitalOcean using our token
provider "digitalocean" {
  token = var.do_token
}

# Upload our SSH key to DigitalOcean
resource "digitalocean_ssh_key" "default" {
  name       = "Terraform-SSH-Key"
  public_key = file("~/.ssh/digitalocean_key.pub")
}

# Create the Firewall - ONLY allows your home IP
resource "digitalocean_firewall" "web" {
  name = "only-home-ip"

  droplet_ids = [digitalocean_droplet.web.id]

  # Allow SSH only from your home IP
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["${var.home_ip}/32"]
  }

  # Allow HTTP only from your home IP
  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["${var.home_ip}/32"]
  }

  # Allow all outbound traffic (for updates, docker pulls)
  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

# Create the Virtual Machine (Droplet)
resource "digitalocean_droplet" "web" {
  image    = "ubuntu-22-04-x64"
  name     = "nginx-docker-server"
  region   = var.region
  size     = var.droplet_size
  ssh_keys = [digitalocean_ssh_key.default.fingerprint]

  # This script runs automatically when the server starts
  user_data = file("${path.module}/cloud-init.yaml")
}

resource "digitalocean_droplet" "web1" {
  image  = "ubuntu-22-04-x64"
  name   = "web-1"
  region = "ams3"
  size   = "s-1vcpu-512mb-10gb"
}

resource "digitalocean_droplet" "web2" {
  image  = "ubuntu-22-04-x64"
  name   = "web-2"
  region = "ams3"
  size   = "s-1vcpu-512mb-10gb"
}

resource "digitalocean_database_cluster" "postrges" {
  name       = "postgres-cluster"
  engine     = "pg"
  version    = "11"
  size       = "db-s-1vcpu-1gb"
  region     = "ams3"
  node_count = 1
}

resource "digitalocean_loadbalancer" "loadbalancer" {
  name   = "loadbalancer-1"
  region = "ams3"

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"

    target_port     = 80
    target_protocol = "http"
  }

  healthcheck {
    port     = 22
    protocol = "tcp"
  }

  droplet_ids = [digitalocean_droplet.web1.id, digitalocean_droplet.web1.id]
}

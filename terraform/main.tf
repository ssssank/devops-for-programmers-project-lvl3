resource "digitalocean_droplet" "web1" {
  image  = "docker-20-04"
  name   = "web-1"
  region = "ams3"
  size   = "s-1vcpu-1gb"
  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]
}

resource "digitalocean_droplet" "web2" {
  image  = "docker-20-04"
  name   = "web-2"
  region = "ams3"
  size   = "s-1vcpu-1gb"
  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]
}

resource "digitalocean_database_cluster" "postgres" {
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

    target_port     = 3000
    target_protocol = "http"
  }

  healthcheck {
    port     = 3000
    protocol = "http"
    path = "/"
  }

  droplet_ids = [digitalocean_droplet.web1.id, digitalocean_droplet.web2.id]
}

resource "digitalocean_database_firewall" "database_firewall_1" {
  cluster_id = digitalocean_database_cluster.postgres.id
  rule {
    type  = "droplet"
    value = digitalocean_droplet.web1.id
  }
  rule {
    type  = "droplet"
    value = digitalocean_droplet.web2.id
  }
}

resource "digitalocean_domain" "domain" {
  name = "devops-hexlet.lol"
}

resource "digitalocean_record" "a_record" {
  domain = digitalocean_domain.domain.id
  type   = "A"
  name   = "www"
  value  = digitalocean_loadbalancer.loadbalancer.ip
}


output "droplet_1_ip_address" {
  value = digitalocean_droplet.web1.ipv4_address
}

output "droplet_2_ip_address" {
  value = digitalocean_droplet.web2.ipv4_address
}

output "db_address" {
  value = digitalocean_database_cluster.postgres.host
}

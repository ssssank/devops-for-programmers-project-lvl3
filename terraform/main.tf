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

variable "app_port" {
  default = 3000
}
resource "digitalocean_loadbalancer" "loadbalancer" {
  name   = "loadbalancer-1"
  region = "ams3"

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"

    target_port     = var.app_port
    target_protocol = "http"
  }

  forwarding_rule {
    entry_port     = 443
    entry_protocol = "https"

    target_port     = var.app_port
    target_protocol = "http"

    certificate_name = digitalocean_certificate.cert.name
  }

  healthcheck {
    port     = var.app_port
    protocol = "http"
    path     = "/"
  }


  droplet_ids = [digitalocean_droplet.web1.id, digitalocean_droplet.web2.id]
}

resource "digitalocean_certificate" "cert" {
  name    = "le-terraform-example"
  type    = "lets_encrypt"
  domains = ["devops-hexlet.lol"]
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
  name   = "@"
  value  = digitalocean_loadbalancer.loadbalancer.ip
}

resource "datadog_monitor" "check" {
  name    = "Redmine status"
  type    = "service check"
  message = "{{host.name}} not respond!"
  query   = "\"http.can_connect\".over(\"instance:http_check\",\"url:http://localhost:3000\").by(\"host\",\"instance\",\"url\").last(4).count_by_status()"
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

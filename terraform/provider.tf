terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }

    datadog = {
      source = "DataDog/datadog"
    }
  }
}

variable "do_token" {}
variable "pvt_key" {}
variable "datadog_api_key" {}
variable "datadog_app_key" {}

provider "digitalocean" {
  token = var.do_token
}

data "digitalocean_ssh_key" "terraform" {
  name = "laptop"
}

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
}

module "azure_resource_group" {
  source = "./azure/resource_group"

  env          = var.env
  azure_region = var.azure_region
}

module "azure_storage" {
  source = "./azure/storage"
  depends_on = [module.azure_resource_group]

  env = var.env
}

module "hcloud_compute" {
  source = "./hcloud/compute"

  env                                 = var.env
  domain                              = var.domain
  hcloud_token                        = var.hcloud_token
  hcloud_thanos_server_instance_count = var.hcloud_thanos_server_instance_count
  azure_resource_group_name           = module.azure_resource_group.rg_name
}

module "hcloud_dns" {
  source = "./hcloud/dns"

  hetzner_dns_token = var.hetzner_dns_token
  hetzner_dns_zone  = var.hetzner_dns_zone
}
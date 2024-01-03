# data "xenorchestra_sr" "sr" {
#   name_label = "Local storage"
#   pool_id = data.xenorchestra_pool.pool.id
# }

# data "xenorchestra_network" "network" {
#   name_label = "Pool-wide network associated with eth0"
#   pool_id = data.xenorchestra_pool.pool.id
# }

# Content of the terraform files
data "xenorchestra_pool" "pool" {
  name_label = "cybersec-ccdc2023"
}

data "xenorchestra_template" "template" {
  name_label = "CCDC-Ubuntu-22.04"
}

data "xenorchestra_network" "net" {
  name_label = "Pool-wide network associated with eth0"
}

resource "xenorchestra_vm" "bar" {
  memory_max = 4096
  cpus       = 1
  # cloud_config = xenorchestra_cloud_config.bar.template
  name_label       = "TEST"
  name_description = "A VM created via Terraform"
  template         = data.xenorchestra_template.template.id

  # Prefer to run the VM on the primary pool instance
  affinity_host = data.xenorchestra_pool.pool.master
  network {
    network_id = data.xenorchestra_network.net.id
  }

  disk {
    sr_id      = "7f469400-4a2b-5624-cf62-61e522e50ea1"
    name_label = "TEST_imavo"
    size       = 10000
  }

  // Override the default create timeout from 5 mins to 20.
  timeouts {
    create = "20m"
  }
}
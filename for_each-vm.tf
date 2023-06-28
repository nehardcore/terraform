variable "vm_config" {
  type = list(object(
    {
      vm_name   = string,
      cpu       = number,
      ram       = number,
      disk      = number 
  }))
  default = [{
    cpu     = 2
    disk    = 15
    ram     = 2
    vm_name = "main"
  },
  {
    cpu     = 2
    disk    = 10
    ram     = 1
    vm_name = "replica"    
  }]
}

resource "yandex_compute_instance" "db" {
    depends_on = [ yandex_compute_instance.web ]
    for_each = { for k in var.vm_config : k.vm_name => k }
    name = each.value.vm_name
    zone = var.default_zone

    resources {
        cores           = each.value.cpu
        memory          = each.value.ram
        core_fraction   = var.vm_resources.core_fraction
    }

    boot_disk {
        initialize_params {
            image_id = data.yandex_compute_image.ubuntu.image_id
            size = each.value.disk
        }
     }
    scheduling_policy {
        preemptible = true
    }
    network_interface {
        subnet_id = yandex_vpc_subnet.develop.id
        security_group_ids = [yandex_vpc_security_group.example.id]
        nat = true
    }
    metadata = {
      ssh_key = data.local_file.public_ssh_key.content
    }
}

provider "local" {
}

data "local_file" "public_ssh_key" {
  filename = "/users/cch/.ssh/id_ed25519.pub"
}
data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2004-lts"
}

resource "yandex_compute_instance" "web" {
    depends_on = [ yandex_vpc_subnet.develop ]
    count = 2
    name = "web-${count.index + 1}"
    zone = var.default_zone

    resources {
        cores           = var.vm_resources.cores
        memory          = var.vm_resources.memory
        core_fraction   = var.vm_resources.core_fraction
    }
    
    boot_disk {
        initialize_params {
            image_id = data.yandex_compute_image.ubuntu.image_id
        }
     }
    scheduling_policy {
        preemptible = true
    }
    network_interface {
        subnet_id = yandex_vpc_subnet.develop.id
        security_group_ids = [yandex_vpc_security_group.example.id]

    }
    metadata = {
      ssh_key = var.ssh_key
    }
}
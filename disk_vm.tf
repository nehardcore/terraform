resource "yandex_compute_disk" "storage_disks" {
    count   = 3
    size    = 1
}

resource "yandex_compute_instance" "storage" {
    depends_on = [ yandex_compute_disk.storage_disks ]
    name = "storage"
    zone = var.default_zone

    resources {
        cores           = var.vm_resources.cores
        memory          = var.vm_resources.memory
        core_fraction   = var.vm_resources.core_fraction
    }
    
    allow_stopping_for_update = true

    dynamic secondary_disk{
        for_each = yandex_compute_disk.storage_disks
        content {
          disk_id = secondary_disk.value.id
        }
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
        nat = true
    }
    metadata = {
      ssh_key = var.ssh_key
    }
}
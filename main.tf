module "module_network_subnet" {
  source          = "./module_network_subnet"
  default_zone    = "ru-central1-a"
}

module "test-vm" {
  source            = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name          = "develop"
  #network_id       = yandex_vpc_network.develop.id
  network_id        = module.module_network_subnet.vpc_id
  subnet_zones      = ["ru-central1-a"]
  #subnet_ids       = [ yandex_vpc_subnet.develop.id ]
  subnet_ids        = [ module.module_network_subnet.subnet_id ]
  instance_name     = "web"
  instance_count    = 1
  image_family      = "ubuntu-2004-lts"
  public_ip         = true
  known_internal_ip = var.vm_local_ip
  
  metadata = {
      user-data          = data.template_file.cloudinit.rendered
      serial-port-enable = 1
  }
}

data "template_file" "cloudinit" {
  vars = {
    vms_ssh_root_key = var.vms_ssh_root_key
  }
  template = file("./cloud-init.yml")
}
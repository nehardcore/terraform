output "vm_ip_map" {
  value = {
    for instance in [yandex_compute_instance.platform, yandex_compute_instance.db]:
    instance.name => instance.network_interface.0.nat_ip_address
  }
}
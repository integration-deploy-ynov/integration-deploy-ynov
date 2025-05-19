output "vm_external_ip" {
  description = "External IP address of the API VM"
  value       = google_compute_instance.vm_api.network_interface[0].access_config[0].nat_ip
}

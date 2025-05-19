provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = file(var.credentials_file)
}

resource "google_compute_network" "vpc_network" {
  name = "vpc-network"
}

resource "google_compute_firewall" "default" {
  name    = "allow-ssh-api"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22", "3000"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "vm_api" {
  name         = "api-vm"
  machine_type = "e2-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.id
    access_config {}
  }

  metadata = {
    ssh-keys = "ubuntu:${file("../.ssh/id_rsa_projet_individuel.pub")}"
  }
}

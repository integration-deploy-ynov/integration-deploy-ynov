provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = file(var.credentials_file)
}

# Ressource : Réseau VPC
resource "google_compute_network" "vpc_network" {
  name                    = "vpc-network"
  auto_create_subnetworks = true
}

# Ressource : Règles de pare-feu
resource "google_compute_firewall" "default" {
  name    = "allow-ssh-api"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22", "3000"] # SSH et API port 3000
  }

  source_ranges = ["0.0.0.0/0"] # Autorise tout le trafic provenant de n'importe où
}

# Ressource : Machine virtuelle (VM) pour l'API
resource "google_compute_instance" "vm_api" {
  name         = "api-vm"
  machine_type = "e2-micro" # Type de machine économique
  zone         = var.zone

  # Disque de démarrage
  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2204-lts" # Image Ubuntu
    }
  }

  # Interface réseau
  network_interface {
    network       = google_compute_network.vpc_network.self_link # Utilise le réseau VPC créé
    access_config {} # Ajoute une configuration d'accès pour une IP externe
  }

  # Métadonnées pour les clés SSH
  metadata = {
    ssh-keys = "ubuntu:${file("../.ssh/id_rsa_projet_individuel.pub")}" # Clé publique SSH
  }
}
# network
resource "google_compute_network" "vpc" {
  name                    = "vpc-wp-tf"
  description             = "vpc for wordpress instances"
  routing_mode            = "REGIONAL"
  auto_create_subnetworks = false

  depends_on = [google_project_service.compute]
}

# firewall
resource "google_compute_firewall" "common" {
  name    = "common"
  network = google_compute_network.vpc.name

  # allow icmp packages
  allow {
    protocol = "icmp"
  }

  # allow http / https / ssh
  allow {
    protocol = "tcp"
    ports    = ["80", "443", "22", "3306"]
  }

  # from internet
  source_ranges = ["0.0.0.0/0"]
}

# public subnet 01
resource "google_compute_subnetwork" "subnet_public_wp_tf" {
  name                     = "wp-tf-public"
  ip_cidr_range            = var.subnet_public_cidr_block
  region                   = var.region
  network                  = google_compute_network.vpc.id
  private_ip_google_access = true
}

# private subnet 01
resource "google_compute_subnetwork" "subnet_private_wp_tf" {
  name                     = "wp-tf-private"
  ip_cidr_range            = var.subnet_private_cidr_block
  region                   = var.region
  network                  = google_compute_network.vpc.id
  private_ip_google_access = true
}

resource "google_compute_router" "nat_router" {
    name    = "wp-nat-router"
    network = google_compute_network.vpc.id
}

resource "google_compute_router_nat" "cloud_nat" {
    name    = "wp-cloud-nat"
    router  = google_compute_router.nat_router.name
    region  = var.region
    nat_ip_allocate_option = "AUTO_ONLY"

    source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

    log_config {
      enable = true
      filter = "ERRORS_ONLY"
    }
}
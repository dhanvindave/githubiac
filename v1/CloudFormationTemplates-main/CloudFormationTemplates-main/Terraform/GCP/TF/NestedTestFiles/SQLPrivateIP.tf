
resource "google_compute_network" "vpc_network" {
  project                 = "my-project-name"
  name                    = "vpc-network"
  auto_create_subnetworks = true
  mtu                     = 1460
}

resource "google_sql_database_instance" "main" {
  name             = "main-instance"
  database_version = "POSTGRES_15"
  region           = "us-central1"

  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    tier = "db-f1-micro"
    private_network = google_compute_network.vpc_network.id
  }
}

resource "google_compute_global_address" "default" {
  provider      = google-beta
  name          = "global-psconnect-ip"
  address_type  = "INTERNAL"
  purpose       = "PRIVATE_SERVICE_CONNECT"
  network       = google_compute_network.vpc_network.id
  address       = "100.100.100.105"
}
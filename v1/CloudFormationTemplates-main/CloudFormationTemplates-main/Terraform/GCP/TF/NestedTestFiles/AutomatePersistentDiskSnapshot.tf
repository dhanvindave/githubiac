resource "google_compute_disk" "default" {
  name  = "test-disk"
  type  = "pd-ssd"
  zone  = "us-central1-a"
  image = "debian-11-bullseye-v20220719"
  labels = {
    environment = "dev"
  }
  physical_block_size_bytes = 4096
}

resource "google_compute_snapshot" "snapshot" {
  name        = "my-snapshot"
  source_disk = google_compute_disk.default.id
  zone        = "us-central1-a"
  labels = {
    my_label = "value"
  }
  storage_locations = ["us-central1"]
}

data "google_compute_image" "debian" {
  family  = "debian-11"
  project = "debian-cloud"
}

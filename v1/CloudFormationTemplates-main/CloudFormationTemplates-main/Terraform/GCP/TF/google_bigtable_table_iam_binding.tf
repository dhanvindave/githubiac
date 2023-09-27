resource "google_bigtable_instance" "instance" {
  name = "tf-instance"

  cluster {
    cluster_id   = "tf-instance-cluster"
    zone         = "us-central1-b"
    num_nodes    = 3
    storage_type = "HDD"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_bigtable_table" "table" {
  name          = "tf-table"
  instance_name = google_bigtable_instance.instance.name
  split_keys    = ["a", "b", "c"]

  lifecycle {
    prevent_destroy = true
  }

  column_family {
    family = "family-first"
  }

  column_family {
    family = "family-second"
  }

  change_stream_retention = "24h0m0s"
}

resource "google_bigtable_table_iam_binding" "editor" {
  table       = "your-bigtable-table"
  instance    = "your-bigtable-instance"
  role     = "roles/bigtable.user"
  members = [
    "user:jane@example.com",
  ]
}
resource "google_scc_source" "custom_source" {
  display_name = "My Source"
  organization = "123456789"
  description  = "My custom Cloud Security Command Center Finding Source"
}


resource "google_scc_source_iam_binding" "binding" {
  source = google_scc_source.custom_source.name
  role = "roles/viewer"
  members = [
    "user:jane@example.com",
  ]
}
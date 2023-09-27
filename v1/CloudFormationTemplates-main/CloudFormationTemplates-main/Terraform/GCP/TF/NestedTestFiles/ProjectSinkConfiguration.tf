resource "google_project" "example" {
  name       = "My Project"
  project_id = "your-project-id"
  folder_id  = google_folder.department1.name
}

resource "google_logging_project_sink" "my-sink" {
  name = "my-pubsub-instance-sink"
  project = google_project.example.id

  # Can export to pubsub, cloud storage, bigquery, log bucket, or another project
  destination = "pubsub.googleapis.com/projects/my-project/topics/instance-activity"

  # Log all WARN or higher severity messages relating to instances
  filter = ""

  # Use a unique writer (creates a unique service account used for writing)
  unique_writer_identity = true
}
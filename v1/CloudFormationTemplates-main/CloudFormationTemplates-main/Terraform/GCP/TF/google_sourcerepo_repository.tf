resource "google_service_account" "test_account" {
  account_id   = "my-account"
  display_name = "Test Service Account"
}

resource "google_pubsub_topic" "topic" {
  name     = "my-topic"
}

resource "google_sourcerepo_repository" "my-repo" {
  name = "my-repository"
  pubsub_configs {
      topic = google_pubsub_topic.topic.id
      message_format = "JSON"
      service_account_email = google_service_account.test_account.email
  }
}

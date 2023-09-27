resource "google_project" "default" {
  name       = "My Project"
  project_id = "your-project-id"
  org_id     = "1234567"
}

resource "google_logging_project_bucket_config" "basic" {
    project    = google_project.default.project_id
    location  = "global"
    retention_days = 30
    bucket_id = "_Default"
}

resource "google_logging_metric" "logging_metric" {
  name   = "my-(custom)/metric"
  filter = "resource.type=\"gce_firewall_rule\" AND protoPayload.methodName=\"v1.compute.firewalls.patch\" OR protoPayload.methodName=\"v1.compute.firewalls.insert\""
  bucket_name = google_logging_project_bucket_config.basic.id
  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "DISTRIBUTION"
    unit        = "1"
    labels {
      key         = "mass"
      value_type  = "STRING"
      description = "amount of matter"
    }
    labels {
      key         = "sku"
      value_type  = "INT64"
      description = "Identifying number for item"
    }
    display_name = "My metric"
  }
  value_extractor = "EXTRACT(jsonPayload.request)"
  label_extractors = {
    "mass" = "EXTRACT(jsonPayload.request)"
    "sku"  = "EXTRACT(jsonPayload.id)"
  }
  bucket_options {
    linear_buckets {
      num_finite_buckets = 3
      width              = 1
      offset             = 1
    }
  }
}
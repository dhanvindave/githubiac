resource "google_apikeys_key" "primary" {
  name         = "key"
  display_name = "sample-key"
  project      = google_project.basic.name

  restrictions {
  
    browser_key_restrictions { 
      allowed_referrers = ["asd"]

    }
  android_key_restrictions {
      allowed_applications {
        package_name     = "com.example.app123"
        sha1_fingerprint = "1699466a142d4682a5f91b50fdf400f2358e2b0b"
      }
    }

    api_targets {
      service = "translate.googleapis.com"
      methods = ["GET*"]
    }
  }
}


resource "google_project" "basic" {
  project_id = "app"
  name       = "app"
  org_id     = "123456789"
}

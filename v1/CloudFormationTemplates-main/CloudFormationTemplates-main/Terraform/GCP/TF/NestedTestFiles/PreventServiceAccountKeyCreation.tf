resource "google_project" "basic" {
  name       = "My Project"
  project_id = "your-project-id"
  folder_id  = google_folder.department1.name
}

resource "google_org_policy_policy" "primary" {
  name   = "projects/${google_project.basic.name}/constraints/iam.disableServiceAccountKeyCreation"
  parent = "projects/${google_project.basic.name}"

  spec {
    rules {
      enforce = "FALSE"
    }
  }
}

resource "google_org_policy_policy" "primary" {
  name   = "projects/${google_project.basic.name}/constraints/iam.disableServiceAccountKeyCreation"
  parent = "projects/${google_project.basic.name}"

  spec {
    rules {
      enforce = "FALSE"
    }
  }
}

resource "google_network_security_address_group" "basic_global_networksecurity_address_group" {
  name        = "policy"
  parent      = "projects/my-project-name"
  description = "Sample global networksecurity_address_group"
  location    = "global"
  items       = ["208.80.154.224/32"]
  type        = "IPV4"
  capacity    = 100
}

resource "google_compute_network_firewall_policy" "basic_network_firewall_policy" {
  name        = "policy"
  description = "Sample global network firewall policy"
  project     = "my-project-name"
}

resource "google_compute_network_firewall_policy_rule" "primary" {
  action                  = "allow"
  description             = "This is a simple rule description"
  direction               = "INGRESS"
  disabled                = false
  enable_logging          = true
  firewall_policy         = google_compute_network_firewall_policy.basic_network_firewall_policy.name
  priority                = 1000
  rule_name               = "test-rule"
  target_service_accounts = ["my@service-account.com"]

  match {
    src_ip_ranges = ["10.100.0.1/32"]
    src_fqdns = ["google.com"]
    src_region_codes = ["US"]
    src_threat_intelligences = ["iplist-known-malicious-ips"]

    src_secure_tags {
      name = "tagValues/${google_tags_tag_value.basic_value.name}"
    }

    layer4_configs {
      ip_protocol = "all"
    }

    src_address_groups = [google_network_security_address_group.basic_global_networksecurity_address_group.id]
  }
  }

resource "google_compute_network" "basic_network" {
  name = "network"
}

resource "google_tags_tag_key" "basic_key" {
  description = "For keyname resources."
  parent      = "organizations/123456789"
  purpose     = "GCE_FIREWALL"
  short_name  = "tagkey"
  purpose_data = {
    network = "my-project-name/${google_compute_network.basic_network.name}"
  }
}

resource "google_tags_tag_value" "basic_value" {
  description = "For valuename resources."
  parent      = "tagKeys/${google_tags_tag_key.basic_key.name}"
  short_name  = "tagvalue"
}
resource "google_cloudiot_registry" "registry" {
  name     = "cloudiot-device-registry"
}


resource "google_cloudiot_device" "test-device" {
  name     = "cloudiot-device"
  registry = google_cloudiot_registry.registry.id

  credentials {
    public_key {
        format = "RSA_PEM"
        key = file("test-fixtures/rsa_public.pem")
    }
  }

  blocked = false

  log_level = "INFO"

  metadata = {
    test_key_1 = "test_value_1"
  }

  gateway_config {
    gateway_type = "NON_GATEWAY"
  }
}

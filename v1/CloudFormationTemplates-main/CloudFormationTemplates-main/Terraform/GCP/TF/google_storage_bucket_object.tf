resource "google_storage_bucket_object" "picture" {
  name   = "butterfly01"
  source = "/images/nature/garden-tiger-moth.jpg"
  bucket = "image-store"
}

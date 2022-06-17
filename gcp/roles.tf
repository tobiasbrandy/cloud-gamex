resource "google_project_iam_binding" "computeadmin" {
  project = var.gcp_project
  role    = "roles/compute.admin"

  members = [
      var.gcp_user,
    ]
}

resource "google_project_iam_binding" "bucketadmin" {
  project = var.gcp_project
  role    = "roles/storage.admin"

  members = [
      var.gcp_user,
    ]
}
resource "google_storage_bucket_iam_binding" "bucketViewer" {
  bucket = google_storage_bucket.ice-cream-bucket.name
  role = "roles/storage.objectViewer"
  members = [
    "allUsers",
  ]
}
resource "google_storage_bucket" "ice-cream-bucket" {
  name          = "ice-cream-bucket-2022a"
  location      = var.bucket_region
  force_destroy = true
  storage_class = "REGIONAL"

  uniform_bucket_level_access = false

  website {
    main_page_suffix = "index.html"
  }
  cors {
    origin          = ["*"]
    method          = ["GET", "HEAD"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
}
resource "google_storage_bucket_object" "html" {
  for_each = fileset("${var.ss_src}/", "**/*.html")

  bucket = google_storage_bucket.ice-cream-bucket.id
  source = "${var.ss_src}/${each.value}"
  name    = each.value
  content_type = "text/html"
}

resource "google_storage_bucket_object" "svg" {
  for_each = fileset("${var.ss_src}/", "**/*.svg")

  bucket = google_storage_bucket.ice-cream-bucket.id
  source = "${var.ss_src}/${each.value}"
  name    = each.value
  content_type = "text/svg"
}

resource "google_storage_bucket_object" "css" {
  for_each = fileset("${var.ss_src}/", "**/*.css")

  bucket = google_storage_bucket.ice-cream-bucket.id
  source = "${var.ss_src}/${each.value}"
  name    = each.value
  content_type = "text/css"
}

resource "google_storage_bucket_object" "js" {
  for_each = fileset("${var.ss_src}/", "**/*.js")

  bucket = google_storage_bucket.ice-cream-bucket.id
  source = "${var.ss_src}/${each.value}"
  name    = each.value
  content_type = "text/js"
}

resource "google_storage_bucket_object" "jpg" {
  for_each = fileset("${var.ss_src}/", "**/*.jpg")

  bucket = google_storage_bucket.ice-cream-bucket.id
  source = "${var.ss_src}/${each.value}"
  name    = each.value
  content_type = "text/jpg"
}


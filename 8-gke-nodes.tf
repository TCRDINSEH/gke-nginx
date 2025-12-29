resource "google_service_account" "gke" {
  account_id = "gke-sa"
}

resource "google_container_node_pool" "general" {
  name    = "gkenode-for-tf"
  location = var.gke_location
  cluster = google_container_cluster.gke.name

  autoscaling {
    min_node_count = 2
    max_node_count = 3
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    preemptible  = false
    machine_type = "e2-medium"
    disk_size_gb = 100          # <-- Add this line (or your desired size)
    disk_type    = "pd-standard"

    labels = {
      role = "general"
    }

    service_account = google_service_account.gke.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

# vpc values
output "vpc" {
  value = google_compute_network.vpc.id
}

# private subnet values
output "subnet-private" {
  value = google_compute_subnetwork.subnet_public_wp_tf.id
}

# public subnet values
output "subnet-public" {
  value = google_compute_subnetwork.subnet_private_wp_tf.id
}

# firewall values
output "firewall-common" {
  value = google_compute_firewall.common.id
}

# Database values
output "database" {
  value = google_sql_database_instance.sql_db_instance.ip_address
}

# Output Cloud Run service URL
output "wordpress_url" {
  value = google_cloud_run_v2_service.wordpress_service.uri
}
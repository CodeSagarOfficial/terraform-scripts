resource "google_vpc_access_connector" "connector" {
    name = "run-vpc"
    subnet {
        name = google_compute_subnetwork.subnet_public_wp_tf.name
    }
    region = var.region
    depends_on = [google_project_service.vpc_access, google_compute_subnetwork.subnet_public_wp_tf]
}

# Create Cloud Run service for WordPress
resource "google_cloud_run_v2_service" "wordpress_service" {
    name     = "wordpress-service"
    location = var.region

    depends_on = [google_project_service.cloud_run, google_project_service.cloud_sql, google_vpc_access_connector.connector]
    ingress = "INGRESS_TRAFFIC_ALL"

    template {
        vpc_access {
            connector = google_vpc_access_connector.connector.id
            egress = "ALL_TRAFFIC"
        }
        
        containers {
            image = "wordpress:latest"
            ports {
                container_port = 80
            }
            env {
                name  = "WORDPRESS_DB_HOST"
                value = google_sql_database_instance.sql_db_instance.private_ip_address
            }
            env {
                name  = "WORDPRESS_DB_USER"
                value = var.cloud_sql_user
            }
            env {
                name  = "WORDPRESS_DB_PASSWORD"
                value = var.cloud_sql_password
            }
            env {
                name  = "WORDPRESS_DB_NAME"
                value = google_sql_database.sql_db.name
            }

            volume_mounts {
                mount_path = "/var/www/html/"
                name       = "wordpress"
            }
        }

        volumes {
            name = "wordpress"
        }
    }

    traffic {
        type = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
        percent = 100
    }

    # Use update action instead of create
    lifecycle {
        create_before_destroy = true
    }
}

resource "google_cloud_run_v2_service_iam_binding" "binding" {
    location = google_cloud_run_v2_service.wordpress_service.location
    name = google_cloud_run_v2_service.wordpress_service.name
    role = "roles/run.invoker"
    members = [
        "allUsers"
    ]
}
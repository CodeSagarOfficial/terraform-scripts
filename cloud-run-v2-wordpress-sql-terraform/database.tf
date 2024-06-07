# private zone
resource "google_compute_global_address" "private_ip_address" {
    provider = google-beta

    name          = "private-sql-range"
    purpose       = "VPC_PEERING"
    address_type  = "INTERNAL"
    prefix_length = 24
    network       = google_compute_network.vpc.id
}

# private peering
resource "google_service_networking_connection" "private_vpc_connection" {
    provider = google-beta

    network                 = google_compute_network.vpc.id
    service                 = "servicenetworking.googleapis.com"
    reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]

    depends_on = [google_project_service.service_networking, google_compute_network.vpc]
    
    deletion_policy = "ABANDON"
}

# create random suffix for database
# the name can be reserve until 15 days after removed
resource "random_id" "db_name_suffix" {
    byte_length = 4
}

# instance cloudsql
resource "google_sql_database_instance" "sql_db_instance" {
    provider = google-beta

    name             = "wordpress-mysql-${random_id.db_name_suffix.hex}"
    database_version = var.cloud_sql_version
    region           = var.region
    deletion_protection = false

    settings {
        tier      = var.cloud_sql_tier
        disk_size = var.cloud_sql_size
        
        ip_configuration {
            ipv4_enabled    = false
            require_ssl     = false
            private_network = google_compute_network.vpc.id

            # authorized_networks {
            #     name  = "allow-all"
            #     value = "0.0.0.0/0" # Allow access from all IP addresses (not recommended for production)
            # }
        }

        backup_configuration {
            binary_log_enabled = false
            enabled            = false
        }
    }

    depends_on = [google_project_service.sql_admin, google_service_networking_connection.private_vpc_connection]
}

# databases
resource "google_sql_database" "sql_db" {
    name     = var.cloud_sql_database
    instance = google_sql_database_instance.sql_db_instance.name

    depends_on = [google_sql_database_instance.sql_db_instance]
}

# users
resource "google_sql_user" "sql_user" {
    name       = var.cloud_sql_user
    instance   = google_sql_database_instance.sql_db_instance.name
    password   = var.cloud_sql_password
    
    depends_on = [google_sql_database_instance.sql_db_instance]
}
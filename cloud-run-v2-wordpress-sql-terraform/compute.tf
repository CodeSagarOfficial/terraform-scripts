resource "google_project_service" "compute" {
    project = var.project_id
    service = "compute.googleapis.com"

    timeouts {
        create = "30m"
        update = "40m"
    }
    lifecycle {
        ignore_changes = [service]
    }
    disable_dependent_services = true
    disable_on_destroy         = false
}

resource "google_project_service" "service_networking" {
    project = var.project_id
    service = "servicenetworking.googleapis.com"

    timeouts {
        create = "30m"
        update = "40m"
    }
    lifecycle {
      ignore_changes = [service]
    }
    disable_dependent_services = true
    disable_on_destroy         = false
}

resource "google_project_service" "sql_admin" {
    project = var.project_id
    service = "sqladmin.googleapis.com"

    timeouts {
        create = "30m"
        update = "40m"
    }
    lifecycle {
      ignore_changes = [service]
    }
    disable_dependent_services = true
    disable_on_destroy         = false
}

resource "google_project_service" "cloud_run" {
    project = var.project_id
    service = "run.googleapis.com"

    timeouts {
        create = "30m"
        update = "40m"
    }

    lifecycle {
        ignore_changes = [service]
    }

    disable_dependent_services = true
    disable_on_destroy         = false
}

resource "google_project_service" "cloud_sql" {
    project = var.project_id
    service = "sql-component.googleapis.com"

    timeouts {
        create = "30m"
        update = "40m"
    }

    lifecycle {
        ignore_changes = [service]
    }
    disable_dependent_services = true
    disable_on_destroy         = false
}

resource "google_project_service" "vpc_access" {
    project = var.project_id
    service = "vpcaccess.googleapis.com"

    timeouts {
          create = "30m"
          update = "40m"
    }

    lifecycle {
      ignore_changes = [service]
    }
    disable_dependent_services = true
    disable_on_destroy         = false
}
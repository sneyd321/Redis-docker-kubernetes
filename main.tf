terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.63.0"
    }
  }
}

provider "google" {
  project = "roomr-222721"
  region  = "us-central1"
  zone    = "us-central1-a"
}


module "gce-container" {
  source = "terraform-google-modules/container-vm/google"
  cos_image_name = "cos-97-16919-103-49"
  

  container = {
    name = "redis"
    image = "us-central1-docker.pkg.dev/roomr-222721/roomr-docker-repo/redis"
  }
  
  restart_policy = "Always"
 
}


resource "google_compute_instance" "redis-instance-1" {
    name         = "redis-instance-1"
    machine_type = "e2-micro"
    zone         = "us-central1-a"
    allow_stopping_for_update = true

    labels = {
        container-vm = module.gce-container.vm_container_label
    }

    metadata = {
        gce-container-declaration = module.gce-container.metadata_value
    }

    boot_disk {
        auto_delete = true
        initialize_params {
            image = module.gce-container.source_image
            type = "pd-standard"
            size = 10
        }
    }
    tags = ["redis-server"]

  network_interface {
    network = "default"
    
  }

  service_account {
    scopes = [ "cloud-platform" ]
  }



}

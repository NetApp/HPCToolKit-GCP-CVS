# Copyright 2023 NetApp, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
#
# Software is provided under this License on an “as is” basis, without
# warranty of any kind, either expressed, implied.
#
# See the License for the specific language governing permissions and
# limitations under the License.

# This code is provided as-is an an example on how CVS can be on-boarded.
# It is not supported by NetApp, since on-boarding is done via GCP APIs.
# It uses the official Googles Terraform provider to do all the work.
# See https://registry.terraform.io/providers/hashicorp/google/latest/docs for documentation

locals {
  project      = var.project_id
  network      = var.network_name
  address_name = "netapp-addresses-${local.network}"

  # Please consult https://cloud.google.com/architecture/partners/netapp-cloud-volumes/setting-up-private-services-access?hl=en_US#setting_up_private_service_access
  # for choosing the right address range and prefix length.
  address_ip     = var.vpc_peering_address_ip # RFC1918
  address_prefix = var.vpc_peering_address_prefix
}

# Create global compute address reservation for CVS to use
# gcloud compute addresses create <...> --global --addresses <...> --purpose=VPC_PEERING --prefix-length=<...> --network=<...> --no-user-output-enabled
resource "google_compute_global_address" "cvs_address_pool" {
  project       = local.project
  name          = local.address_name
  address       = local.address_ip
  prefix_length = local.address_prefix
  ip_version    = var.vpc_peering_ip_version
  address_type  = var.vpc_peering_address_type
  purpose       = var.vpc_peering_purpose
  network       = local.network
}

data "google_compute_network" "myvpc" {
  project = local.project
  name    = local.network
}

# gcloud services vpc-peerings connect --service=cloudvolumesgcp-api-network.netapp.com --ranges=<...> --network=<...> --no-user-output-enabled
resource "google_service_networking_connection" "cvs_performance_peering" {
  depends_on              = [google_compute_global_address.cvs_address_pool]
  network                 = local.network
  service                 = var.cvs_performance_peering_service
  reserved_peering_ranges = [google_compute_global_address.cvs_address_pool.name]
}

# gcloud services vpc-peerings connect --service=cloudvolumesgcp-sds-api-network.netapp.com --ranges=<...> --network=<...> --no-user-output-enabled
resource "google_service_networking_connection" "cvs_software_peering" {
  depends_on              = [google_service_networking_connection.cvs_performance_peering]
  network                 = local.network
  service                 = var.cvs_software_peering_service
  reserved_peering_ranges = [google_compute_global_address.cvs_address_pool.name]
}

# gcloud compute networks peerings update <...> --network=<...> --import-custom-routes --export-custom-routes
resource "google_compute_network_peering_routes_config" "cvs_routes_update" {
  depends_on = [google_service_networking_connection.cvs_performance_peering]
  project    = local.project
  peering    = google_service_networking_connection.cvs_performance_peering.peering
  network    = local.network

  import_custom_routes = true
  export_custom_routes = true
}

# gcloud compute networks peerings update <...> --network=<...> --import-custom-routes --export-custom-routes
resource "google_compute_network_peering_routes_config" "cvs_software_routes_update" {
  depends_on = [google_service_networking_connection.cvs_software_peering]
  project    = local.project
  peering    = google_service_networking_connection.cvs_software_peering.peering
  network    = local.network

  import_custom_routes = true
  export_custom_routes = true
}

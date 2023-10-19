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

# Install provider from terraform register, only available for version 0.13 and above.
terraform {
  required_providers {
    netapp-gcp = {
      source  = "NetApp/netapp-gcp"
      version = "23.4.0"
    }
  }
}

# Configure the NetApp_GCP Provider
provider "netapp-gcp" {
  project         = var.project_id
  service_account = var.service_account
}
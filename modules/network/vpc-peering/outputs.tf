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

output "gcp_routes_config" {
  description = "Manage a network peering's route settings without managing the peering as a whole. And id here represents the identifier for the resource"
  value       = google_compute_network_peering_routes_config.cvs_software_routes_update.id
}

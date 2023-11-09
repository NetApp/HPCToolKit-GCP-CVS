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

resource "time_sleep" "wait_150_seconds" {
  depends_on = [netapp-gcp_volume.gcp-volume]

  destroy_duration = "150s"
}

# This resource will create (potentially immediately) after null_resource.previous
resource "null_resource" "next" {
  depends_on = [time_sleep.wait_150_seconds]
}

resource "netapp-gcp_storage_pool" "test-storage-pool" {
  depends_on                = [var.gcp_routes_config]
  name                      = var.storage_pool_name
  region                    = var.region
  zone                      = var.zone
  secondary_zone            = var.storage_pool_secondary_zone == "" ? null : var.storage_pool_secondary_zone
  network                   = var.network_name
  global_ad_access          = var.storage_pool_global_ad_access
  size                      = var.storage_pool_size
  service_level             = var.storage_pool_service_level
  storage_class             = var.storage_pool_storage_class
  shared_vpc_project_number = var.shared_vpc_project_number == "" ? null : var.shared_vpc_project_number
  billing_label {
    key   = var.storage_pool_billing_label_key
    value = var.storage_pool_billing_label_value
  }
}

resource "random_string" "volume_name_rand_string" {
  length  = 3
  special = false
  upper   = false
  numeric = false
}

locals {
  default_export_policy = {
    rule = {
      allowed_clients = null,
      access          = null,
      has_root_access = null,
      nfsv3           = []
      nfsv4           = []
    }
  }
  export_policys = coalescelist(var.volume_export_policies, [local.default_export_policy])
}

resource "netapp-gcp_volume" "gcp-volume" {
  depends_on                = [netapp-gcp_storage_pool.test-storage-pool, random_string.volume_name_rand_string]
  name                      = "${var.volume_name}-${random_string.volume_name_rand_string.result}"
  region                    = var.volume_region != "" ? var.volume_region : var.region
  zone                      = var.volume_zone == "" ? null : var.zone
  regional_ha               = var.regional_ha_service_level
  protocol_types            = var.volume_protocol_types
  network                   = var.network_name
  size                      = var.volume_size
  service_level             = var.volume_service_level
  volume_path               = var.volume_path == "" ? "${var.volume_name}-${random_string.volume_name_rand_string.result}" : null
  storage_class             = var.volume_storage_class
  delete_on_creation_error  = var.volume_delete_on_creation_error
  pool_id                   = var.volume_storage_class == "hardware" ? null : netapp-gcp_storage_pool.test-storage-pool.id
  unix_permissions          = var.volume_unix_permissions
  shared_vpc_project_number = var.shared_vpc_project_number == "" ? null : var.shared_vpc_project_number
  type_dp                   = var.volume_type_dp == "" ? null : var.volume_type_dp
  snapshot_id               = var.volume_snapshot_id == "" ? null : var.volume_snapshot_id
  snapshot_policy {
    enabled = var.volume_snapshot_policy_enabled
  }

  dynamic "export_policy" {
    for_each = local.export_policys
    content {
      dynamic "rule" {
        for_each = export_policy.value.rule
        content {
          allowed_clients = rule.value.allowed_clients
          access          = rule.value.access
          has_root_access = rule.value.has_root_access
          dynamic "nfsv3" {
            for_each = rule.value.nfsv3
            content {
              checked = nfsv3.value.checked
            }
          }
          dynamic "nfsv4" {
            for_each = rule.value.nfsv4
            content {
              checked = nfsv4.value.checked
            }
          }
        }
      }

    }
  }
}
# resource "random_string" "volume_backup_name_rand_string" {
#   length  = 3
#   special = false
#   upper   = false
#   numeric = false
# }

# resource "netapp-gcp_volume_backup" "gcp-volume-backup" {
#   depends_on     = [netapp-gcp_storage_pool.test-storage-pool, netapp-gcp_volume.gcp-volume, random_string.volume_backup_name_rand_string, random_string.volume_name_rand_string]
#   name           = "${var.volume_backup_name}-${random_string.volume_backup_name_rand_string.result}"
#   region         = var.region
#   volume_name    = "${var.volume_name}-${random_string.volume_name_rand_string.result}"
#   creation_token = var.volume_backup_creation_token == "" ? null : var.volume_backup_creation_token
# }

# resource "random_string" "volume_snapshot_name_rand_string" {
#   length  = 3
#   special = false
#   upper   = false
#   numeric = false
# }

# resource "netapp-gcp_snapshot" "gcp-volume-snapshot" {
#   depends_on     = [netapp-gcp_storage_pool.test-storage-pool, netapp-gcp_volume.gcp-volume, random_string.volume_snapshot_name_rand_string, random_string.volume_name_rand_string]
#   name           = "${var.volume_snapshot_name}-${random_string.volume_snapshot_name_rand_string.result}"
#   region         = var.region
#   volume_name    = "${var.volume_name}-${random_string.volume_name_rand_string.result}"
#   creation_token = var.volume_snapshot_creation_token == "" ? null : var.volume_snapshot_creation_token
# }

# resource "netapp-gcp_active_directory" "gcp-active-directory" {
#   region                          = var.ad_region
#   username                        = var.ad_username
#   password                        = var.ad_password
#   domain                          = var.ad_domain
#   dns_server                      = var.ad_dns_server
#   net_bios                        = var.ad_net_bios
#   connection_type                 = var.ad_connection_type
#   aes_encryption                  = var.ad_aes_encryption
#   ldap_signing                    = var.ad_ldap_signing
#   organizational_unit             = var.ad_organizational_unit == "" ? null : var.ad_organizational_unit
#   site                            = var.ad_site == "" ? null : var.ad_site
#   managed_ad                      = var.ad_managed_ad == "" ? null : var.ad_managed_ad
#   backup_operators                = var.ad_backup_operators == [""] ? null : var.ad_backup_operators
#   security_operators              = var.ad_security_operators == [""] ? null : var.ad_security_operators
#   ad_server                       = var.ad_ad_server == "" ? null : var.ad_ad_server
#   kdc_ip                          = var.ad_kdc_ip == "" ? null : var.ad_kdc_ip
#   allow_local_nfs_users_with_ldap = var.ad_allow_local_nfs_users_with_ldap == "" ? null : var.ad_allow_local_nfs_users_with_ldap
# }

# resource "netapp-gcp_kms_config" "kms-example" {
#   region            = var.kms_region
#   key_project_id    = var.key_project_id == "" ? null : var.key_project_id
#   key_ring_location = var.key_ring_location
#   key_ring_name     = var.key_ring_name
#   key_name          = var.key_name
#   network           = "projects/${var.project_number}/global/networks/${var.network_name}"
# }

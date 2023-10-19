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

output "gcp_cvs_storage_pool_id" {
  description = "Storage Pool ID for GCP-NetApp -- Cloud Volume Service"
  value       = netapp-gcp_storage_pool.test-storage-pool.id
}

output "gcp_volume_id" {
  description = "Volume ID for GCP-NetApp -- Cloud Volume Service"
  value       = netapp-gcp_volume.gcp-volume.id
}

output "gcp_volume_mount_points" {
  value = local.mount_points
}

output "network_storage" {
  description = "Describes a remote network storage to be mounted by fs-tab."
  value = {
    server_ip             = local.server_ip
    remote_mount          = local.remote_mount
    local_mount           = var.local_mount
    fs_type               = local.fs_type
    mount_options         = var.mount_options
    client_install_runner = local.client_install_runner
    mount_runner          = local.mount_runner
  }
}

locals {

  remote_mount              = local.mount_points.export
  mount_points              = netapp-gcp_volume.gcp-volume.mount_points[0]
  server_ip                 = local.mount_points.server
  fs_type                   = contains(var.volume_protocol_types, "NFSv3") || contains(var.volume_protocol_types, "NFSv4") ? "nfs" : "smb"
  nfs_client_install_script = file("${path.module}/scripts/install-nfs-client.sh")

  client_install_runner = {
    "type"        = "shell"
    "content"     = local.nfs_client_install_script
    "destination" = "install_filesystem_client${replace(var.local_mount, "/", "_")}.sh"
  }

  mount_vanilla_supported_fstype = ["nfs"]
  install_scripts = {
    "nfs" = local.nfs_client_install_script
  }

  mount_runner_vanilla = {
    "type"        = "shell"
    "destination" = "mount_filesystem${replace(var.local_mount, "/", "_")}.sh"
    "args"        = "\"${local.server_ip}\" \"${local.remote_mount}\" \"${var.local_mount}\" \"${local.fs_type}\" \"${var.mount_options}\""
    "content" = (
      contains(local.mount_vanilla_supported_fstype, local.fs_type) ?
      file("${path.module}/scripts/mount.sh") :
      "echo 'skipping: mount_runner not yet supported for ${local.fs_type}'"
    )
  }

  mount_runner = lookup(local.mount_scripts, local.fs_type, local.mount_runner_vanilla)

  mount_scripts = {
    "nfs" = local.mount_runner_vanilla
  }
}

output "client_install_runner" {
  description = "Runner that performs client installation needed to use file system."
  value       = local.client_install_runner
}

output "mount_runner" {
  description = "Runner that mounts the file system."
  value       = local.mount_runner
}

# output "gcp_volume_name_for_backup" {
#   description = "Volume Backup Name for GCP-NetApp -- Cloud Volume Service"
#   value       = "${var.volume_name}-${random_string.volume_name_rand_string.result}"
# }

# output "gcp_volume_backup_id" {
#   description = "Volume Backup ID for GCP-NetApp -- Cloud Volume Service"
#   value       = netapp-gcp_volume_backup.gcp-volume-backup.id
# }

# output "gcp_volume_snapshot_id" {
#   description = "Volume Snapshot ID for GCP-NetApp -- Cloud Volume Service"
#   value       = netapp-gcp_snapshot.gcp-volume-snapshot.id
# }

# output "gcp_active_directory_id" {
#   description = "The unique identifier for GCP-NetApp for the active directory -- Cloud Volume Service"
#   value       = netapp-gcp_active_directory.gcp-active-directory.id
# }

# output "gcp_kms_config_id" {
#   description = "The unique identifier for GCP-NetApp for the kms -- Cloud Volume Service"
#   value       = netapp-gcp_kms_config.kms-example.id
# }

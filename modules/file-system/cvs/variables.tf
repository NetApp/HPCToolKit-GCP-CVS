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

variable "project_id" {
  description = "Provide the name fo the GCP Project."
  type        = string
}

variable "service_account" {
  description = "Provide the service account which has relevant access rights to deploy CVS"
  type        = string
  default     = "test-tf-cvs-sa@cv-solution-architect-lab.iam.gserviceaccount.com"
}

variable "name_prefix" {
  description = <<-EOT
    An optional name for all VM and disk resources. 
    If not supplied, `deployment_name` will be used. 
    When `name_prefix` is supplied, and `add_deployment_name_before_prefix` is set, 
    then resources are named by "<`deployment_name`>-<`name_prefix`>-<#>".
    EOT
  type        = string
  default     = null
}

variable "add_deployment_name_before_prefix" {
  description = <<-EOT
    If true, the names of VMs and disks will always be prefixed with `deployment_name` to enable uniqueness across deployments.
    See `name_prefix` for further details on resource naming behavior.
    EOT
  type        = bool
  default     = false
}

variable "deployment_name" {
  description = "Name of the deployment, will optionally be used name resources according to `name_prefix`"
  type        = string
  default     = null
}

variable "labels" {
  description = "Labels to add to the instances. Key-value pairs."
  type        = map(string)
  default = {
    "author" = "johndoe"
  }
}

variable "network_self_link" {
  description = "The self link of the network to attach the VM."
  type        = string
  default     = "default"
}

variable "subnetwork_self_link" {
  description = "The self link of the subnetwork to attach the VM."
  type        = string
  default     = null
}

variable "storage_pool_name" {
  description = "Name of the storage pool."
  type        = string
  default     = "example_cvs_storage_pool"
}

variable "region" {
  description = "The region where the storage pool to be created."
  type        = string
}

variable "zone" {
  description = "Location of the pool."
  type        = string
}

variable "storage_pool_secondary_zone" {
  description = "Secondary zone if service level is ZoneRedundantStandardSW."
  default     = ""
  type        = string
}

variable "network_name" {
  description = "Network name."
  type        = string
}

variable "storage_pool_global_ad_access" {
  description = "Enables global access to Active Directory controllers outside of the pools region."
  default     = true
  type        = string
}

variable "storage_pool_size" {
  description = "Storage pool size."
  default     = 1024
  type        = string
}

variable "storage_pool_service_level" {
  description = "StandardSW or ZoneRedundantStandardSW."
  default     = "StandardSW"
  type        = string
}

variable "storage_pool_storage_class" {
  description = "Software for CVS and CVS-Performance"
  type        = string
  default     = "software"
}

variable "storage_pool_billing_label_key" {
  description = "Must be a minimum length of 1 character and a maximum length of 63 characters, and cannot be empty. Can contain only lowercase letters, numeric characters, underscores, and dashes. All characters must use UTF-8 encoding, and international characters are allowed. Must start with a lowercase letter or international character."
  default     = "terraform_author"
  type        = string
}

variable "storage_pool_billing_label_value" {
  description = "Can be empty, and have a maximum length of 63 characters. Can contain only lowercase letters, numeric characters, underscores, and dashes. All characters must use UTF-8 encoding, and international characters are allowed."
  default     = "terraform_user"
  type        = string
}

variable "storage_pool_id" {
  description = "The unique identifier for the storage pool."
  type        = string
  default     = ""
}

variable "shared_vpc_project_number" {
  description = "The host project number when deploying in a shared VPC service project."
  type        = string
  default     = ""
}

variable "volume_name" {
  description = "The name of the NetApp_GCP volume."
  type        = string
  default     = "nfs-volume-example"
}

variable "volume_protocol_types" {
  description = "The protocol_type of the volume. For CVS use 'NFSv3' or 'SMB'. For CVS-Performance use 'NFSv3', 'NFSv4' or 'SMB', or a combinations of ['NFSv3', 'NFSv4'], ['SMB', 'NFSv3'] and ['SMB', 'NFSv4']."
  type        = list(string)
  default     = ["NFSv3"]
}

variable "volume_size" {
  description = "The size of volume. 100-102400 GiB for CVS-Performance, 1-102400 GiB for CVS on Storage Pools"
  type        = number
  default     = 100
}

variable "volume_region" {
  description = "The region of the NetApp_GCP volume."
  type        = string
  default     = "us-east4"
}

variable "volume_zone" {
  description = "Location of the volume."
  type        = string
  default     = ""
}

variable "volume_service_level" {
  type    = string
  default = "standard"
}

variable "regional_ha_service_level" {
  type    = string
  default = false
}

variable "volume_path" {
  description = "The name of the export path or share name to be used for the volume. Must be unique per region."
  type        = string
  default     = ""
}

variable "volume_snapshot_policy_enabled" {
  type    = bool
  default = false //
}

variable "volume_delete_on_creation_error" {
  description = " Automatically delete volume if volume is in error state after creation. Default is false."
  type        = bool
  default     = true //
}

variable "volume_export_policies" {
  type = list(object({
    rule = list(object({
      allowed_clients = string,
      access          = string,
      has_root_access = bool,
      nfsv3 = list(object({
        checked = bool
      })),
      nfsv4 = list(object({
        checked = bool
      }))
    }))
  }))
  default = []
}

variable "volume_billing_label_key" {
  description = "Must be a minimum length of 1 character and a maximum length of 63 characters, and cannot be empty. Can contain only lowercase letters, numeric characters, underscores, and dashes. All characters must use UTF-8 encoding, and international characters are allowed. Must start with a lowercase letter or international character."
  type        = string
  default     = "terraform_author"
}

variable "volume_billing_label_value" {
  description = "Can be empty, and have a maximum length of 63 characters. Can contain only lowercase letters, numeric characters, underscores, and dashes. All characters must use UTF-8 encoding, and international characters are allowed."
  type        = string
  default     = "terraform_user"
}

variable "volume_unix_permissions" {
  description = "UNIX permissions for root directory of NFS volume. Accepts octal 4 digit format. First digit selects the set user ID(4), set group ID (2) and sticky (1) attributes. Second digit selects permission for the owner of the file: read (4), write (2) and execute (1). Third selects permissions for other users in the same group. the fourth for other users not in the group. 0755 - gives read/write/execute permissions to owner and read/execute to group and other users."
  type        = string
  default     = "1755"
}

variable "volume_type_dp" {
  description = "True for Volume Replication destination volume, False for normal primary volume."
  type        = string
  default     = ""
}

variable "volume_snapshot_id" {
  description = "The UUID of the snapshot to create volume from."
  type        = string
  default     = ""
}

variable "volume_storage_class" {
  description = "software for CVS."
  default     = "software"
  type        = string
}

variable "local_mount" {
  description = "The mount point where the contents of the device may be accessed after mounting."
  type        = string
  default     = "/mnt"
}

variable "fs_type" {
  description = "Type of file system to be mounted (e.g., nfs, lustre)"
  type        = string
  default     = "nfs"
}

variable "mount_options" {
  description = "Options describing various aspects of the file system. Consider adding setting to 'defaults,_netdev,implicit_dirs' when using gcsfuse."
  type        = string
  default     = "defaults,_netdev"
}

# variable "volume_backup_name" {
#   description = "The name if the NetApp_GCP volume_backup to be created."
#   type        = string
#   default     = "nfs-volume-backup"
# }

# variable "origin_volume_name" {
#   description = "The name of the volume to create a volume_backup from."
#   type        = string
#   default     = ""
# }

# variable "volume_backup_creation_token" {
#   description = "The creation token of volume of the NetApp_GCP. At least one of volume_creation or creation_token is required to create volume_back_up."
#   type        = string
#   default     = ""
# }

# variable "volume_snapshot_name" {
#   description = "The name of the NetApp_GCP snapshot to be created."
#   type        = string
#   default     = "snapshot-nfs-volume"
# }

# variable "volume_snapshot_creation_token" {
#   description = "The creation token of snapshot of the volume of NetApp_GCP. At least one of volume_name or creation_token is required to create snapshot."
#   type        = string
#   default     = ""
# }

# variable "ad_region" {
#   description = "The region to which the Active Directory credentials are associated."
#   type        = string
#   default     = "us-east-1"
# }

# variable "ad_username" {
#   description = "Username of an account permitted to create computer objects in your Active Directory."
#   type        = string
#   default     = "admin"
# }

# variable "ad_password" {
#   description = "Password for the account permitted to create computer objects in your Active Directory."
#   type        = string
#   sensitive   = true
# }

# variable "ad_domain" {
#   description = "Fully qualified name of Active Directory domain."
#   type        = string
#   default     = "cvsdemo.local"
# }

# variable "ad_dns_server" {
#   description = "Comma separated list of DNS server IP addresses used for DNS-based domain controller discovery.."
#   type        = string
#   default     = "10.10.0.11"
# }

# variable "ad_net_bios" {
#   description = "NetBIOS prefix name of the server that will be created. A random 5-digit suffix is appended automatically (e.g. -A579)."
#   type        = string
#   default     = "cvs-east4"
# }

# variable "ad_connection_type" {
#   description = "Specify 'software' for service type CVS or 'hardware' for service type CVS-Performance."
#   type        = string
#   default     = "software"
# }

# variable "ad_site" {
#   description = "Specify an Active Directory site to manage domain controller selection. Use when Active Directory domain controllers in multiple regions are configured. Defaults to 'Default-First-Site-Name' if left empty."
#   type        = string
#   default     = ""
# }

# variable "ad_organizational_unit" {
#   description = "Name of the Organizational Unit (OU) within Windows Active Directory the computer account belongs to in order from leaf OU to root OU. Defaults to CN=Computers if left empty."
#   type        = string
#   default     = ""
# }

# variable "ad_aes_encryption" {
#   description = "Enables AES-128 and AES-256 encryption for Kerberos-based communication with Active Directory. Default is false."
#   type        = string
#   default     = false
# }

# variable "ad_ldap_signing" {
#   description = "Enables LDAP siging. Default is false."
#   type        = string
#   default     = false
# }

# variable "ad_managed_ad" {
#   description = "Flags this configuration as Google ManagedAD configuration."
#   type        = string
#   default     = ""
# }

# variable "ad_backup_operators" {
#   description = "Users to be added to the built-in Backup Operators active directory group. The usernames must be unique, and entries cannot include @ or '\\'. The entire list will be validated and rejected as whole if one or more entries are invalid."
#   type        = set(string)
#   default     = ["testuser"]
# }

# variable "ad_security_operators" {
#   description = "Domain users to be given the SeSecurityPrivilege."
#   type        = set(string)
#   default     = ["testuser"]
# }

# variable "ad_ad_server" {
#   description = "Hostname of an Active Directory domain controller which is used as Kerberos Key Distribution Center (KDC). This optional parameter is used only for Kerberized NFS."
#   type        = string
#   default     = "ok-activedirectory.cvsdemo.local"
# }

# variable "ad_kdc_ip" {
#   description = "IP address of the Active Directory domain controller which is used as Kerberos Key Distribution Center (KDC). This optional parameter is used only for Kerberized NFS."
#   type        = string
#   default     = "10.10.0.11"
# }

# variable "ad_allow_local_nfs_users_with_ldap" {
#   description = "If enabled, allow_local_nfs_users_with_ldap will allow access to local users as well as LDAP users. If access is needed for only LDAP users, it has to be disabled. Default is false."
#   type        = string
#   default     = false
# }

# variable "project_number" {
#   description = "Please provide the project number"
#   type        = number
#   default     = 823997568320
# }

# variable "kms_region" {
#   description = "Name of the region to create a KMS config for."
#   type        = string
#   default     = "us-central1"
# }

# variable "key_ring_location" {
#   description = "Location/region of the keyRing."
#   type        = string
#   default     = "global"
# }

# variable "key_ring_name" {
#   description = "Key ring containing the keys to be used for volume encryption."
#   type        = string
#   default     = "tf-key-ring"
# }

# variable "key_name" {
#   description = "Name of the key to be used for encryption. This key should be in the keyRing mentioned in keyRing field."
#   type        = string
#   default     = "tf-key-name"
# }

# variable "key_project_id" {
#   description = "Project ID of project where the key to be used for encryption is residing. Use if key is located in different project."
#   type        = string
#   default     = ""
# }

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
  description = "Provide Project name "
  type        = string
  default     = null
}

variable "network_name" {
  description = "Network name."
  type        = string
}

variable "vpc_peering_address_ip" {
  description = "Private Service Access - VPC Peering Address Range to set."
  type        = string
  default     = "192.168.200.0"
}

variable "vpc_peering_address_prefix" {
  description = "Private Service Access - VPC Peering Address Prefix to set."
  type        = string
  default     = "24"
}

variable "vpc_peering_address_type" {
  description = "Private Service Access - VPC Peering Address Type"
  type        = string
  default     = "INTERNAL"
}

variable "vpc_peering_ip_version" {
  description = "Private Service Access - VPC Peering IP Version"
  type        = string
  default     = "IPV4"
}

variable "vpc_peering_purpose" {
  description = "Private Service Access - VPC Peering Purpose"
  type        = string
  default     = "VPC_PEERING"
}

variable "cvs_performance_peering_service" {
  description = "Private Service Access - CVS Performance Peering Service API"
  type        = string
  default     = "cloudvolumesgcp-api-network.netapp.com"
}

variable "cvs_software_peering_service" {
  description = "Private Service Access - CVS Software Peering Service API"
  type        = string
  default     = "cloudvolumesgcp-sds-api-network.netapp.com"
}

#!/bin/sh

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

if [ ! "$(which mount.nfs)" ]; then
	if [ -f /etc/centos-release ] || [ -f /etc/redhat-release ] ||
		[ -f /etc/oracle-release ] || [ -f /etc/system-release ]; then
		major_version=$(rpm -E "%{rhel}")
		enable_repo=""
		if [ "${major_version}" -eq "7" ]; then
			enable_repo="base,epel"
		elif [ "${major_version}" -eq "8" ]; then
			enable_repo="baseos"
		else
			echo "Unsupported version of centos/RHEL/Rocky"
			return 1
		fi
		yum install --disablerepo="*" --enablerepo=${enable_repo} -y nfs-utils
	elif [ -f /etc/debian_version ] || grep -qi ubuntu /etc/lsb-release || grep -qi ubuntu /etc/os-release; then
		apt-get -y update
		apt-get -y install nfs-common
	else
		echo 'Unsuported distribution'
		return 1
	fi
fi

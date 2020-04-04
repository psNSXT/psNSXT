#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

# Copy this file to credential.ps1 (on Tests folder) and change connection settings..

$script:ipaddress = "10.x.x.x"
$script:login = "admin"
$script:password = "VMware1!VMware1!"

$script:vm = "MyNSXTVM"

#default settings use for test, can be override if needed...
#$script:pester_tz = "pester_tz"
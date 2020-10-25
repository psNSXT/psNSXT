#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingConvertToSecureStringWithPlainText", "")]
Param()

if ("Desktop" -eq $PSVersionTable.PsEdition) {
    # -BeOfType is not same on PowerShell Core and Desktop (get int with Desktop and long with Core for number)
    $script:pester_longint = "int"
}
else {
    $script:pester_longint = "long"
}
$script:pester_lp = "pester_lp"
$script:pester_tz = "pester_tz"
$script:pester_sg = "pester_sg"

. ../credential.ps1
#TODO: Add check if no ipaddress/login/password info...

$script:mysecpassword = ConvertTo-SecureString $password -AsPlainText -Force
if ($null -eq $port){
    $port = 443
}


Connect-NSXT -Server $ipaddress -username $login -password $mysecpassword -port 443 -SkipCertificateCheck
#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
. ../common.ps1

Describe  "Connect to a NSX-T (using Basic)" {
    BeforeAll {
        #Disconnect "default connection"
        Disconnect-NSXT -noconfirm
    }
    It "Connect to NSX-T (using Basic) and check global variable" {
        Connect-NSXT $ipaddress -username $login -password $mysecpassword -SkipCertificateCheck
        $DefaultNSXTConnection | Should -Not -BeNullOrEmpty
        $DefaultNSXTConnection.server | Should -Be $ipaddress
        $DefaultNSXTConnection.headers.Authorization | should -Not -BeNullOrEmpty
        $DefaultNSXTConnection.headers.'Content-Type' | should -Be "application/json"
        $DefaultNSXTConnection.headers.Accept | should -Be "application/json"
    }

    It "Disconnect to NSXT-T and check global variable" {
        Disconnect-NSXT -noconfirm
        $DefaultNSXTConnection | Should -Be $null
    }
    #TODO: Connect using wrong login/password

    #This test only work with PowerShell 6 / Core (-SkipCertificateCheck don't change global variable but only Invoke-WebRequest/RestMethod)
    #This test will be fail, if there is valid certificate...
    It "Throw when try to use Invoke-NSXTRestMethod with don't use -SkipCertifiateCheck" -Skip:("Desktop" -eq $PSEdition) {
        Connect-NSXT $ipaddress -username $login -password $mysecpassword
        { Invoke-NSXTRestMethod -uri "api/v1/cluster/status" } | Should throw "Unable to connect (certificate)"
        Disconnect-NSXT -noconfirm
    }
    It "Throw when try to use Invoke-NSXTRestMethod and not connected" {
        { Invoke-NSXTRestMethod -uri "api/v1/cluster/status" } | Should throw "Not Connected. Connect to the NSX-T with Connect-NSXT"
    }
}

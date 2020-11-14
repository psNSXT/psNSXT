#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
. ../common.ps1

Describe  "Connect to a NSX-T (using Basic)" {
    BeforeAll {
        #Disconnect "default connection"
        Disconnect-NSXT -confirm:$false
    }
    It "Connect to NSX-T (using Basic) and check global variable" {
        Connect-NSXT $ipaddress -username $login -password $mysecpassword -port $port -SkipCertificateCheck
        $DefaultNSXTConnection | Should -Not -BeNullOrEmpty
        $DefaultNSXTConnection.server | Should -Be $ipaddress
        $DefaultNSXTConnection.headers.Authorization | should -Not -BeNullOrEmpty
        $DefaultNSXTConnection.headers.'Content-Type' | should -Be "application/json"
        $DefaultNSXTConnection.headers.Accept | should -Be "application/json"
    }

    It "Disconnect to NSXT-T and check global variable" {
        Disconnect-NSXT -confirm:$false
        $DefaultNSXTConnection | Should -Be $null
    }
    #TODO: Connect using wrong login/password

    #This test only work with PowerShell 6 / Core (-SkipCertificateCheck don't change global variable but only Invoke-WebRequest/RestMethod)
    #This test will be fail, if there is valid certificate...
    It "Throw when try to use Invoke-NSXTRestMethod with don't use -SkipCertifiateCheck" -Skip:("Desktop" -eq $PSEdition) {
        Connect-NSXT $ipaddress -username $login -password $mysecpassword -port $port
        { Invoke-NSXTRestMethod -uri "api/v1/cluster/status" } | Should -Throw "Unable to connect (certificate)"
        Disconnect-NSXT -confirm:$false
    }
}

Describe "Connect to a NSX-T (using multi connection)" {
    It "Connect to a NSX-T (using HTTPS and store on NSXT variable)" {
        $script:nsx = Connect-NSXT $ipaddress -username $login -password $mysecpassword -port $port -SkipCertificateCheck -DefaultConnection:$false
        $DefaultNSXTConnection | Should -BeNullOrEmpty
        $nsx.server | Should -Be $ipaddress
        $nsx.port | Should -Be $port
        $nsx.headers.Authorization | should -Not -BeNullOrEmpty
        $nsx.headers.'Content-Type' | should -Be "application/json"
        $nsx.headers.Accept | should -Be "application/json"
    }

    It "Throw when try to use Invoke-NSXTRestMethod and not connected" {
        { Invoke-NSXTRestMethod -uri "api/v1/cluster/status" } | Should -Throw "Not Connected. Connect to the NSX-T with Connect-NSXT"
    }

    Context "Use Multi connection for call some (Get) cmdlet (VirtualMachines, TZ, Segments...)" {
        It "Use Multi connection for call Get (Fabric) VirtualMachine" {
            { Get-NSXTFabricVirtualMachines -connection $nsx } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Transport Zones" {
            { Get-NSXTTransportZones -connection $nsx } | Should -Not -Throw
        }
        It "Use Multi connection for call Get (Policy Infra) Segments" {
            { Get-NSXTPolicyInfraSegments -connection $nsx } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Logical Switches" {
            { Get-NSXTLogicalSwitches -connection $nsx } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Logical Ports" {
            { Get-NSXTLogicalPorts -connection $nsx } | Should -Not -Throw
        }
        It "Use Multi connection for call Get Transport Nodes" {
            { Get-NSXTTransportNodes -connection $nsx } | Should -Not -Throw
        }
        It "Use Multi connection for call Get (Fabric) Vifs (Virtual Interfaces)" {
            { Get-NSXTFabricVifs -connection $nsx } | Should -Not -Throw
        }
    }

    It "Disconnect to a NSX-T (Multi connection)" {
        Disconnect-NSXT -connection $nsx -confirm:$false
        $DefaultNSXTConnection | Should -Be $null
    }
}
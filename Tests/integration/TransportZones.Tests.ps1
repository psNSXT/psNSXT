#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
. ../common.ps1

Describe "Get Transport Zones" {
    BeforeAll {
        $mytz = Add-NSXTTransportZones -transport_type VLAN -host_switch_name NVDS-psNSXT -display_name $pester_tz
        $script:id = $mytz.id
        $script:display_name = $mytz.display_name
        $script:host_switch_name = $mytz.host_switch_name
    }

    It "Get Transport Zones Does not throw an error" {
        {
            Get-NSXTTransportZones
        } | Should Not Throw
    }

    It "Get Transport Zones" {
        $tz = Get-NSXTTransportZones
        $tz[0].transport_type | Should -Not -BeNullOrEmpty
        $tz[0].host_switch_name | Should -Not -BeNullOrEmpty
        $tz[0].host_switch_id | Should -Not -BeNullOrEmpty
        $tz[0].transport_zone_profile_ids | Should -Not -BeNullOrEmpty
        $tz[0].host_switch_mode | Should -Not -BeNullOrEmpty
        $tz[0].nested_nsx | Should -Not -BeNullOrEmpty
        $tz[0].is_default | Should -Not -BeNullOrEmpty
        $tz[0].resource_type | Should -Be "TransportZone"
        $tz[0].display_name | Should -Not -BeNullOrEmpty
        $tz[0].id | Should -Not -BeNullOrEmpty
    }

    It "Get Transport Zones by zone_id ($id)" {
        $tz = Get-NSXTTransportZones -zone_id $id
        $tz.id | Should -Be $id
    }

    It "Get Transport Zones by zone_id ($id) with summary" {
        $tz = Get-NSXTTransportZones -zone_id $id -summary
        $tz.transport_zone_id | Should -Be $id
        $tz.num_transport_nodes | Should -Not -BeNullOrEmpty
        $tz.num_logical_switches | Should -Not -BeNullOrEmpty
        $tz.num_logical_ports | Should -Not -BeNullOrEmpty
    }

    It "Get Transport Zones by display_name ($display_name)" {
        $tz = Get-NSXTTransportZones -display_name $display_name
        $tz.display_name | Should -Be $display_name
    }

    It "Get Transport Zones by host_switch_name ($host_switch_name)" {
        $tz = Get-NSXTTransportZones -host_switch_name $host_switch_name
        $tz.host_switch_name | Should -Be $host_switch_name
    }

    It "Get Transport Zones and confirm (via Confirm-NSXTTransportZones)" {
        $tz = Get-NSXTTransportZones -zone_id $id
        Confirm-NSXTTransportZones $tz | Should -Be $true
    }

    AfterAll {
        Get-NSXTTransportZones -display_name $pester_tz | Remove-NSXTTransportZones -confirm:$false
    }

}

Describe "Add Transport Zones" {

    AfterEach {
        Get-NSXTTransportZones -display_name $pester_tz | Remove-NSXTTransportZones -confirm:$false
    }

    It "Add Transport Zones type VLAN and (display_)name" {
        Add-NSXTTransportZones -transport_type VLAN -host_switch_name NVDS-psNSXT -display_name $pester_tz
        $tz = Get-NSXTTransportZones -display_name $pester_tz
        $tz.transport_type | Should -Be "VLAN"
        $tz.host_switch_name | Should -Be "NVDS-psNSXT"
        $tz.host_switch_id | Should -Not -BeNullOrEmpty
        $tz.host_switch_mode | Should -Be "STANDARD"
        $tz.nested_nsx | Should -Be $false
        $tz.is_default | Should -Be $false
        $tz.resource_type | Should -Be "TransportZone"
        $tz.id | Should -Not -BeNullOrEmpty
        $tz.display_name | Should -Be $pester_tz
    }

    It "Add Transport Zones type OVERLAY and (display_)name and description" {
        Add-NSXTTransportZones -transport_type OVERLAY -host_switch_name NVDS-psNSXT -display_name $pester_tz -description "Add via psNSXT"
        $tz = Get-NSXTTransportZones -display_name $pester_tz
        $tz.transport_type | Should -Be "OVERLAY"
        $tz.host_switch_name | Should -Be "NVDS-psNSXT"
        $tz.host_switch_id | Should -Not -BeNullOrEmpty
        $tz.host_switch_mode | Should -Be "STANDARD"
        $tz.nested_nsx | Should -Be $false
        $tz.is_default | Should -Be $false
        $tz.resource_type | Should -Be "TransportZone"
        $tz.id | Should -Not -BeNullOrEmpty
        $tz.display_name | Should -Be $pester_tz
        $tz.description | Should -Be "Add via psNSXT"
    }

    It "Add Transport Zones type OVERLAY (enhanced mode) and (display_)name and description" {
        Add-NSXTTransportZones -transport_type OVERLAY -host_switch_name NVDS-psNSXT -display_name $pester_tz -description "Add via psNSXT" -host_switch_mode ENS
        $tz = Get-NSXTTransportZones -display_name $pester_tz
        $tz.transport_type | Should -Be "OVERLAY"
        $tz.host_switch_name | Should -Be "NVDS-psNSXT"
        $tz.host_switch_id | Should -Not -BeNullOrEmpty
        $tz.host_switch_mode | Should -Be "ENS"
        $tz.nested_nsx | Should -Be $false
        $tz.is_default | Should -Be $false
        $tz.resource_type | Should -Be "TransportZone"
        $tz.id | Should -Not -BeNullOrEmpty
        $tz.display_name | Should -Be $pester_tz
        $tz.description | Should -Be "Add via psNSXT"
    }

    It "Add Transport Zones type VLAN and (display_)name with nested and is default enable" {
        Add-NSXTTransportZones -transport_type VLAN -host_switch_name NVDS-psNSXT -display_name $pester_tz -nested_nsx -is_default
        $tz = Get-NSXTTransportZones -display_name $pester_tz
        $tz.transport_type | Should -Be "VLAN"
        $tz.host_switch_name | Should -Be "NVDS-psNSXT"
        $tz.host_switch_id | Should -Not -BeNullOrEmpty
        $tz.host_switch_mode | Should -Be "STANDARD"
        $tz.nested_nsx | Should -Be $true
        $tz.is_default | Should -Be $true
        $tz.resource_type | Should -Be "TransportZone"
        $tz.id | Should -Not -BeNullOrEmpty
        $tz.display_name | Should -Be $pester_tz
    }

    AfterEach {
        Get-NSXTTransportZones -display_name $pester_tz | Remove-NSXTTransportZones -confirm:$false
    }
}

Describe "Configure Transport Zones" {

    BeforeAll {
        Add-NSXTTransportZones -transport_type VLAN -host_switch_name NVDS-psNSXT -display_name $pester_tz
    }

    It "Change Transport Zones display_name" {
        Get-NSXTTransportZones -display_name $pester_tz | Set-NSXTTransportZones -display_name "pester_tz2"
        $tz = Get-NSXTTransportZones -display_name pester_tz2

        $tz.host_switch_name | Should -Be "NVDS-psNSXT"
        $tz.host_switch_id | Should -Not -BeNullOrEmpty
        $tz.host_switch_mode | Should -Be "STANDARD"
        $tz.nested_nsx | Should -Be $false
        $tz.is_default | Should -Be $false
        $tz.resource_type | Should -Be "TransportZone"
        $tz.id | Should -Not -BeNullOrEmpty
        $tz.display_name | Should -Be "pester_tz2"
        #Restore name...
        Get-NSXTTransportZones -display_name pester_tz2 | Set-NSXTTransportZones -display_name $pester_tz
    }

    It "Change Transport Zones description" {
        Get-NSXTTransportZones -display_name $pester_tz | Set-NSXTTransportZones -description "Add via psNSXT"
        $tz = Get-NSXTTransportZones -display_name $pester_tz
        $tz.transport_type | Should -Be "VLAN"
        $tz.host_switch_name | Should -Be "NVDS-psNSXT"
        $tz.host_switch_id | Should -Not -BeNullOrEmpty
        $tz.host_switch_mode | Should -Be "STANDARD"
        $tz.nested_nsx | Should -Be $false
        $tz.is_default | Should -Be $false
        $tz.resource_type | Should -Be "TransportZone"
        $tz.id | Should -Not -BeNullOrEmpty
        $tz.display_name | Should -Be $pester_tz
        $tz.description | Should -Be "Add via psNSXT"
    }

    It "Change Transport Zones is default (enable) " {
        Get-NSXTTransportZones -display_name $pester_tz | Set-NSXTTransportZones -is_default
        $tz = Get-NSXTTransportZones -display_name $pester_tz
        $tz.transport_type | Should -Be "VLAN"
        $tz.host_switch_name | Should -Be "NVDS-psNSXT"
        $tz.host_switch_id | Should -Not -BeNullOrEmpty
        $tz.host_switch_mode | Should -Be "STANDARD"
        $tz.nested_nsx | Should -Be $false
        $tz.is_default | Should -Be $true
        $tz.resource_type | Should -Be "TransportZone"
        $tz.id | Should -Not -BeNullOrEmpty
        $tz.display_name | Should -Be $pester_tz
        $tz.description | Should -Be "Add via psNSXT"
    }

    It "Change Transport Zones is default (disable) " {
        Get-NSXTTransportZones -display_name $pester_tz | Set-NSXTTransportZones -is_default:$false
        $tz = Get-NSXTTransportZones -display_name $pester_tz
        $tz.transport_type | Should -Be "VLAN"
        $tz.host_switch_name | Should -Be "NVDS-psNSXT"
        $tz.host_switch_id | Should -Not -BeNullOrEmpty
        $tz.host_switch_mode | Should -Be "STANDARD"
        $tz.nested_nsx | Should -Be $false
        $tz.is_default | Should -Be $false
        $tz.resource_type | Should -Be "TransportZone"
        $tz.id | Should -Not -BeNullOrEmpty
        $tz.display_name | Should -Be $pester_tz
        $tz.description | Should -Be "Add via psNSXT"
    }

    AfterAll {
        Get-NSXTTransportZones -display_name $pester_tz | Remove-NSXTTransportZones -confirm:$false
    }

}

Describe "Remove Transport Zones" {

    BeforeEach {
        $mytz = Add-NSXTTransportZones -transport_type VLAN -host_switch_name NVDS-psNSXT -display_name $pester_tz
        $script:id = $mytz.id
    }

    It "Remove Transport Zones ($pester_tz) by id" {
        Remove-NSXTTransportZones -zone_id $id -confirm:$false
        $tz = Get-NSXTTransportZones -display_name $pester_tz
        $tz | Should -Be $NULL
    }

    It "Remove Transport Zones ($pester_tz) by pipeline" {
        $tz = Get-NSXTTransportZones -display_name $pester_tz
        $tz | Remove-NSXTTransportZones -confirm:$false
        $tz = Get-NSXTTransportZones -display_name $pester_tz
        $tz | Should -Be $NULL
    }

}

Disconnect-NSXT -confirm:$false
#
# Copyright 2019-2020, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
. ../common.ps1

BeforeAll {
    Connect-NSXT @invokeParams
}

Describe "Get Segments" {
    BeforeAll {
        #Use default nsx-vlan-transportzone (from NSX-T 3.0...)
        Get-NSXTTransportZones -display_name nsx-vlan-transportzone | Add-NSXTPolicyInfraSegments -segment $pester_sg -vlan_ids 23
    }

    It "Get Segments Does not throw an error" {
        {
            Get-NSXTPolicyInfraSegments
        } | Should -Not -Throw
    }

    It "Get Segments" {
        $sg = Get-NSXTPolicyInfraSegments
        $sg[0].type | Should -Not -BeNullOrEmpty
        $sg[0].vlan_ids | Should -Not -BeNullOrEmpty
        $sg[0].resource_type | Should -Be "Segment"
        $sg[0].id | Should -Not -BeNullOrEmpty
        $sg[0].display_name | Should -Not -BeNullOrEmpty
        $sg[0].path | Should -Not -BeNullOrEmpty
        $sg[0].relative_path | Should -Not -BeNullOrEmpty
        $sg[0].parent_path | Should -Not -BeNullOrEmpty
        $sg[0].marked_for_delete | Should -Not -BeNullOrEmpty
    }

    It "Get Segments by id ($pester_sg)" {
        $sg = Get-NSXTPolicyInfraSegments -segment $pester_sg
        $sg.id | Should -Be $pester_sg
    }

    It "Get Segments by display_name ($pester_sg)" {
        $sg = Get-NSXTPolicyInfraSegments -display_name $pester_sg
        $sg.id | Should -Be $pester_sg
        $sg.display_name | Should -Be $pester_sg
    }

    It "Get Segments and confirm (via Confirm-NSXTPolicyInfraSegments)" {
        $sg = Get-NSXTPolicyInfraSegments -segment $pester_sg
        Confirm-NSXTSegments $sg | Should -Be $true
    }

    AfterAll {
        Get-NSXTPolicyInfraSegments -segment $pester_sg | Remove-NSXTPolicyInfraSegments -confirm:$false
        #Wait 2 seconds to be sure the Segments is deleted (it can be make 5 sec for be removed !)
        Start-Sleep 2
    }

}

Describe "Add Segments (vlan)" {

    It "Add Segments type VLAN (23)" {
        Get-NSXTTransportZones -display_name nsx-vlan-transportzone | Add-NSXTPolicyInfraSegments -segment $pester_sg -vlan_ids 23
        $sg = Get-NSXTPolicyInfraSegments -segment $pester_sg
        $sg.type | Should -Be "DISCONNECTED"
        $sg.vlan_ids | Should -Be "23"
        $sg.resource_type | Should -Be "Segment"
        $sg.id | Should -Be $pester_sg
        $sg.display_name | Should -Be $pester_sg
        $sg.path | Should -Be "/infra/segments/$pester_sg"
        $sg.relative_path | Should -Be $pester_sg
        $sg.parent_path | Should -BeLike "/infra"
        $sg.marked_for_delete | Should -Be $false
    }

    It "Add Segments type VLAN (23) and (display_)name" {
        Get-NSXTTransportZones -display_name nsx-vlan-transportzone | Add-NSXTPolicyInfraSegments -segment $pester_sg -display_name "Seg by psNSXT" -vlan_ids 23
        $sg = Get-NSXTPolicyInfraSegments -segment $pester_sg
        $sg.type | Should -Be "DISCONNECTED"
        $sg.vlan_ids | Should -Be "23"
        $sg.resource_type | Should -Be "Segment"
        $sg.id | Should -Be $pester_sg
        $sg.display_name | Should -Be "Seg by psNSXT"
        $sg.path | Should -Be "/infra/segments/$pester_sg"
        $sg.relative_path | Should -Be $pester_sg
        $sg.parent_path | Should -BeLike "/infra"
        $sg.marked_for_delete | Should -Be $false
    }

    It "Add Segments type with multiple VLAN (23,44)" {
        Get-NSXTTransportZones -display_name nsx-vlan-transportzone | Add-NSXTPolicyInfraSegments -segment $pester_sg -vlan_ids 23, 44
        $sg = Get-NSXTPolicyInfraSegments -segment $pester_sg
        $sg.type | Should -Be "DISCONNECTED"
        $sg.vlan_ids | Should -Be @("23", "44")
        $sg.resource_type | Should -Be "Segment"
        $sg.id | Should -Be $pester_sg
        $sg.display_name | Should -Be $pester_sg
        $sg.path | Should -Be "/infra/segments/$pester_sg"
        $sg.relative_path | Should -Be $pester_sg
        $sg.parent_path | Should -BeLike "/infra"
        $sg.marked_for_delete | Should -Be $false
    }

    AfterEach {
        Get-NSXTPolicyInfraSegments -segment $pester_sg | Remove-NSXTPolicyInfraSegments -confirm:$false
        #Wait 2 seconds to be sure the Segments is deleted (it can be make 5 sec for be removed !)
        Start-Sleep 2
    }
}


Describe "Add Segments (Overlay)" {

    It "Add Segments type Overlay" {
        Get-NSXTTransportZones -display_name $tz_overlay | Add-NSXTPolicyInfraSegmentsOverlay -segment $pester_sg -gateway_address 192.0.2.254/24 -tier1 $tier1
        $sg = Get-NSXTPolicyInfraSegments -segment $pester_sg
        $sg.type | Should -Be "ROUTED"
        $sg.resource_type | Should -Be "Segment"
        $sg.id | Should -Be $pester_sg
        $sg.display_name | Should -Be $pester_sg
        $sg.path | Should -Be "/infra/segments/$pester_sg"
        $sg.connectivity_path  | Should -Be "/infra/tier-1s/$tier1"
        $sg.subnets.gateway_address | Should -Be "192.0.2.254/24"
        $sg.subnets.network | Should -Be "192.0.2.0/24"
        $sg.relative_path | Should -Be $pester_sg
        $sg.parent_path | Should -BeLike "/infra"
        $sg.marked_for_delete | Should -Be $false
    }

    It "Add Segments type Overlay with DHCP" {
        Get-NSXTTransportZones -display_name $tz_overlay | Add-NSXTPolicyInfraSegmentsOverlay -segment $pester_sg -gateway_address 192.0.2.254/24 -tier1 $tier1 -dhcp_config $dhcp_config -dhcp_ranges 192.0.2.1-192.0.2.100 -dhcp_server 192.0.2.253/24
        $sg = Get-NSXTPolicyInfraSegments -segment $pester_sg
        $sg.type | Should -Be "ROUTED"
        $sg.resource_type | Should -Be "Segment"
        $sg.id | Should -Be $pester_sg
        $sg.display_name | Should -Be $pester_sg
        $sg.path | Should -Be "/infra/segments/$pester_sg"
        $sg.connectivity_path  | Should -Be "/infra/tier-1s/$tier1"
        $sg.subnets.gateway_address | Should -Be "192.0.2.254/24"
        $sg.subnets.network | Should -Be "192.0.2.0/24"
        $sg.subnets.dhcp_ranges | Should -Be "192.0.2.1-192.0.2.100"
        $sg.subnets.dhcp_config.resource_type | Should -Be "SegmentDhcpV4Config"
        $sg.subnets.dhcp_config.server_address | Should -Be "192.0.2.253/24"
        $sg.subnets.dhcp_config.lease_time | Should -Be "86400"
        $sg.relative_path | Should -Be $pester_sg
        $sg.parent_path | Should -BeLike "/infra"
        $sg.marked_for_delete | Should -Be $false
    }

    It "Add Segments type Overlay with DHCP with 2 ranges" {
        Get-NSXTTransportZones -display_name $tz_overlay | Add-NSXTPolicyInfraSegmentsOverlay -segment $pester_sg -gateway_address 192.0.2.254/24 -tier1 $tier1 -dhcp_config $dhcp_config -dhcp_ranges 192.0.2.1-192.0.2.100, 192.0.2.150-192.0.2.200 -dhcp_server 192.0.2.253/24
        $sg = Get-NSXTPolicyInfraSegments -segment $pester_sg
        $sg.type | Should -Be "ROUTED"
        $sg.resource_type | Should -Be "Segment"
        $sg.id | Should -Be $pester_sg
        $sg.display_name | Should -Be $pester_sg
        $sg.path | Should -Be "/infra/segments/$pester_sg"
        $sg.connectivity_path  | Should -Be "/infra/tier-1s/$tier1"
        $sg.subnets.gateway_address | Should -Be "192.0.2.254/24"
        $sg.subnets.network | Should -Be "192.0.2.0/24"
        $sg.subnets.dhcp_ranges[0] | Should -Be "192.0.2.1-192.0.2.100"
        $sg.subnets.dhcp_ranges[1] | Should -Be "192.0.2.150-192.0.2.200"
        $sg.subnets.dhcp_config.resource_type | Should -Be "SegmentDhcpV4Config"
        $sg.subnets.dhcp_config.server_address | Should -Be "192.0.2.253/24"
        $sg.subnets.dhcp_config.lease_time | Should -Be "86400"
        $sg.relative_path | Should -Be $pester_sg
        $sg.parent_path | Should -BeLike "/infra"
        $sg.marked_for_delete | Should -Be $false
    }

    AfterEach {
        Get-NSXTPolicyInfraSegments -segment $pester_sg | Remove-NSXTPolicyInfraSegments -confirm:$false
        #Wait 2 seconds to be sure the Segments is deleted (it can be make 5 sec for be removed !)
        Start-Sleep 2
    }
}

Describe "Configure Segments (vlan)" {

    BeforeAll {
        Get-NSXTTransportZones -display_name nsx-vlan-transportzone | Add-NSXTPolicyInfraSegments -segment $pester_sg -vlan_ids 23
    }

    It "Change Segments display_name" {
        Get-NSXTPolicyInfraSegments -display_name $pester_sg | Set-NSXTPolicyInfraSegments -display_name "pester_sg2"
        $sg = Get-NSXTPolicyInfraSegments -display_name pester_sg2
        $sg.type | Should -Be "DISCONNECTED"
        $sg.vlan_ids | Should -Be "23"
        $sg.resource_type | Should -Be "Segment"
        $sg.id | Should -Be $pester_sg
        $sg.display_name | Should -Be "pester_sg2"
        $sg.path | Should -Be "/infra/segments/$pester_sg"
        $sg.relative_path | Should -Be $pester_sg
        $sg.parent_path | Should -BeLike "/infra"
        $sg.marked_for_delete | Should -Be $false
        #Restore name...
        Get-NSXTPolicyInfraSegments -display_name pester_sg2 | Set-NSXTPolicyInfraSegments -display_name $pester_sg
    }

    It "Change Segments Vlan (Change Vlan 23 -> 44)" {
        Get-NSXTPolicyInfraSegments -segment $pester_sg | Set-NSXTPolicyInfraSegments -vlan_ids 24
        $sg = Get-NSXTPolicyInfraSegments -segment $pester_sg
        $sg.type | Should -Be "DISCONNECTED"
        $sg.vlan_ids | Should -Be "24"
        $sg.resource_type | Should -Be "Segment"
        $sg.id | Should -Be $pester_sg
        $sg.display_name | Should -Be "pester_sg"
        $sg.path | Should -Be "/infra/segments/$pester_sg"
        $sg.relative_path | Should -Be $pester_sg
        $sg.parent_path | Should -BeLike "/infra"
        $sg.marked_for_delete | Should -Be $false
    }

    It "Change Segments Vlan (Change Multiple Vlan 23,45)" {
        Get-NSXTPolicyInfraSegments -segment $pester_sg | Set-NSXTPolicyInfraSegments -vlan_ids 23, 45
        $sg = Get-NSXTPolicyInfraSegments -segment $pester_sg
        $sg.type | Should -Be "DISCONNECTED"
        $sg.vlan_ids | Should -Be @("23", "45")
        $sg.resource_type | Should -Be "Segment"
        $sg.id | Should -Be $pester_sg
        $sg.display_name | Should -Be "pester_sg"
        $sg.path | Should -Be "/infra/segments/$pester_sg"
        $sg.relative_path | Should -Be $pester_sg
        $sg.parent_path | Should -BeLike "/infra"
        $sg.marked_for_delete | Should -Be $false
    }

    AfterAll {
        Get-NSXTPolicyInfraSegments -display_name $pester_sg | Remove-NSXTPolicyInfraSegments -confirm:$false
        #Wait 2 seconds to be sure the Segments is deleted (it can be make 5 sec for be removed !)
        Start-Sleep 2
    }

}

Describe "Remove Segments (vlan)" {

    BeforeEach {
        Get-NSXTTransportZones -display_name nsx-vlan-transportzone | Add-NSXTPolicyInfraSegments -segment $pester_sg -vlan_ids 23
    }

    It "Remove Segments ($pester_sg) by segment" {
        Remove-NSXTPolicyInfraSegments -segment $pester_sg -confirm:$false
        $sg = Get-NSXTPolicyInfraSegments -display_name $pester_sg
        $sg | Should -Be $NULL
    }

    It "Remove Segments ($pester_sg) by pipeline" {
        $sg = Get-NSXTPolicyInfraSegments -display_name $pester_sg
        $sg | Remove-NSXTPolicyInfraSegments -confirm:$false
        $sg = Get-NSXTPolicyInfraSegments -display_name $pester_sg
        $sg | Should -Be $NULL
    }

    AfterEach {
        #Wait 2 seconds to be sure the Segments is deleted (it can be make 5 sec for be removed !)
        Start-Sleep 2
    }

}

AfterAll {
    Disconnect-NSXT -confirm:$false
}
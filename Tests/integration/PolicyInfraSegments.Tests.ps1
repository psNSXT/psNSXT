#
# Copyright 2019-2020, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
. ../common.ps1

Describe "Get Segments" {
    BeforeAll {
        #Use default nsx-vlan-transportzone (from NSX-T 3.0...)
        Get-NSXTTransportZones -display_name nsx-vlan-transportzone | Add-NSXTPolicyInfraSegments -segment $pester_sg -vlan_ids 23
    }

    It "Get Segments Does not throw an error" {
        {
            Get-NSXTPolicyInfraSegments
        } | Should Not Throw
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
    }

}

Describe "Add Segments" {

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
        $sg.parent_path | Should -Be "/infra/segments/$pester_sg"
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
        $sg.parent_path | Should -Be "/infra/segments/$pester_sg"
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
        $sg.parent_path | Should -Be "/infra/segments/$pester_sg"
        $sg.marked_for_delete | Should -Be $false
    }

    AfterEach {
        Get-NSXTPolicyInfraSegments -segment $pester_sg | Remove-NSXTPolicyInfraSegments -confirm:$false
        #Wait 2 seconds to be sure the Segments is deleted (it can be make 5 sec for be remove !)
        Start-Sleep 2
    }
}

Describe "Configure Segments" {

    BeforeAll {
        Add-NSXTPolicyInfraSegments -transport_type VLAN -host_switch_name NVDS-psNSXT -display_name $pester_tz
    }

    It "Change Segments display_name" {
        Get-NSXTPolicyInfraSegments -display_name $pester_tz | Set-NSXTPolicyInfraSegments -display_name "pester_tz2"
        $sg = Get-NSXTPolicyInfraSegments -display_name pester_tz2

        $sg.host_switch_name | Should -Be "NVDS-psNSXT"
        $sg.host_switch_id | Should -Not -BeNullOrEmpty
        $sg.host_switch_mode | Should -Be "STANDARD"
        $sg.nested_nsx | Should -Be $false
        $sg.is_default | Should -Be $false
        $sg.resource_type | Should -Be "TransportZone"
        $sg.id | Should -Not -BeNullOrEmpty
        $sg.display_name | Should -Be "pester_tz2"
        #Restore name...
        Get-NSXTPolicyInfraSegments -display_name pester_tz2 | Set-NSXTPolicyInfraSegments -display_name $pester_tz
    }

    It "Change Segments description" {
        Get-NSXTPolicyInfraSegments -display_name $pester_tz | Set-NSXTPolicyInfraSegments -description "Add via psNSXT"
        $sg = Get-NSXTPolicyInfraSegments -display_name $pester_tz
        $sg.transport_type | Should -Be "VLAN"
        $sg.host_switch_name | Should -Be "NVDS-psNSXT"
        $sg.host_switch_id | Should -Not -BeNullOrEmpty
        $sg.host_switch_mode | Should -Be "STANDARD"
        $sg.nested_nsx | Should -Be $false
        $sg.is_default | Should -Be $false
        $sg.resource_type | Should -Be "TransportZone"
        $sg.id | Should -Not -BeNullOrEmpty
        $sg.display_name | Should -Be $pester_tz
        $sg.description | Should -Be "Add via psNSXT"
    }

    It "Change Segments is default (enable) " {
        Get-NSXTPolicyInfraSegments -display_name $pester_tz | Set-NSXTPolicyInfraSegments -is_default
        $sg = Get-NSXTPolicyInfraSegments -display_name $pester_tz
        $sg.transport_type | Should -Be "VLAN"
        $sg.host_switch_name | Should -Be "NVDS-psNSXT"
        $sg.host_switch_id | Should -Not -BeNullOrEmpty
        $sg.host_switch_mode | Should -Be "STANDARD"
        $sg.nested_nsx | Should -Be $false
        $sg.is_default | Should -Be $true
        $sg.resource_type | Should -Be "TransportZone"
        $sg.id | Should -Not -BeNullOrEmpty
        $sg.display_name | Should -Be $pester_tz
        $sg.description | Should -Be "Add via psNSXT"
    }

    It "Change Segments is default (disable) " {
        Get-NSXTPolicyInfraSegments -display_name $pester_tz | Set-NSXTPolicyInfraSegments -is_default:$false
        $sg = Get-NSXTPolicyInfraSegments -display_name $pester_tz
        $sg.transport_type | Should -Be "VLAN"
        $sg.host_switch_name | Should -Be "NVDS-psNSXT"
        $sg.host_switch_id | Should -Not -BeNullOrEmpty
        $sg.host_switch_mode | Should -Be "STANDARD"
        $sg.nested_nsx | Should -Be $false
        $sg.is_default | Should -Be $false
        $sg.resource_type | Should -Be "TransportZone"
        $sg.id | Should -Not -BeNullOrEmpty
        $sg.display_name | Should -Be $pester_tz
        $sg.description | Should -Be "Add via psNSXT"
    }

    AfterAll {
        Get-NSXTPolicyInfraSegments -display_name $pester_tz | Remove-NSXTPolicyInfraSegments -confirm:$false
    }

}

Describe "Remove Segments" {

    BeforeEach {
        $mytz = Add-NSXTPolicyInfraSegments -transport_type VLAN -host_switch_name NVDS-psNSXT -display_name $pester_tz
        $script:id = $mytz.id
    }

    It "Remove Segments ($pester_tz) by id" {
        Remove-NSXTPolicyInfraSegments -zone_id $id -confirm:$false
        $sg = Get-NSXTPolicyInfraSegments -display_name $pester_tz
        $sg | Should -Be $NULL
    }

    It "Remove Segments ($pester_tz) by pipeline" {
        $sg = Get-NSXTPolicyInfraSegments -display_name $pester_tz
        $sg | Remove-NSXTPolicyInfraSegments -confirm:$false
        $sg = Get-NSXTPolicyInfraSegments -display_name $pester_tz
        $sg | Should -Be $NULL
    }

}

Disconnect-NSXT -confirm:$false
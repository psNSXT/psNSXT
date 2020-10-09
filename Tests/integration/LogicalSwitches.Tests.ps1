#
# Copyright 2019-2020, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
. ../common.ps1

Describe "Get Logical Switches" {
    BeforeAll {
        #Use default nsx-vlan-transportzone (from NSX-T 3.0...)
        $script:segment = Get-NSXTTransportZones -display_name nsx-vlan-transportzone | Add-NSXTPolicyInfraSegments -segment $pester_sg -vlan_ids 23
        $script:tid = (Get-NSXTTransportZones -display_name nsx-vlan-transportzone).id
        $script:sid = $segment.unique_id
    }

    It "Get Logical Switches Does not throw an error" {
        {
            Get-NSXTLogicalSwitches
        } | Should Not Throw
    }

    It "Get Logical Switches" {
        $sg = Get-NSXTLogicalSwitches
        $sg[0].switch_type | Should -Not -BeNullOrEmpty
        $sg[0].transport_zone_id | Should -Not -BeNullOrEmpty
        $sg[0].admin_state | Should -Not -BeNullOrEmpty
        $sg[0].resource_type | Should -Be "LogicalSwitch"
        $sg[0].id | Should -Not -BeNullOrEmpty
        $sg[0].switching_profile_ids | Should -Not -BeNullOrEmpty
        $sg[0].display_name | Should -Not -BeNullOrEmpty
        $sg[0].tags | Should -Not -BeNullOrEmpty
    }

    It "Get Logical Switches by id ($sid)" {
        $sg = Get-NSXTLogicalSwitches -id $sid
        $sg.id | Should -Be $sid
    }

    It "Get Logical Switches by display_name ($pester_sg)" {
        $sg = Get-NSXTLogicalSwitches -display_name $pester_sg
        $sg.id | Should -Not -BeNullOrEmpty
        $sg.display_name | Should -Be $pester_sg
    }

    It "Get Logical Switches by vlan_id (23)" {
        $sg = Get-NSXTLogicalSwitches -vlan 23
        $sg.id | Should -Not -BeNullOrEmpty
        $sg.vlan | Should -Be "23"
        $sg.display_name | Should -Be $pester_sg
    }

    It "Get Logical Switches by transport_zone(_id) ($tid)" {
        $sg = Get-NSXTLogicalSwitches -transport_zone_id $tid
        $sg.transport_zone_id | Should -Be $tid
    }

    #It "Get Logical Switches by switching_profile_id ($pester_sg)" {
    #    $sg = Get-NSXTLogicalSwitches -switching_profile_id $pester_sg
    #    $sg.id | Should -Be $pester_sg
    #}

    AfterAll {
        Get-NSXTPolicyInfraSegments -segment $pester_sg | Remove-NSXTPolicyInfraSegments -confirm:$false
        #Wait 2 seconds to be sure the Segments is deleted (it can be make 5 sec for be removed !)
        Start-Sleep 2
    }

}

Disconnect-NSXT -confirm:$false
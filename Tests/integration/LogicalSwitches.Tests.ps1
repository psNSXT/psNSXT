#
# Copyright 2019-2020, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
. ../common.ps1

BeforeAll {
    Connect-NSXT @invokeParams
}

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
        $ls = Get-NSXTLogicalSwitches
        $ls[0].switch_type | Should -Not -BeNullOrEmpty
        $ls[0].transport_zone_id | Should -Not -BeNullOrEmpty
        $ls[0].admin_state | Should -Not -BeNullOrEmpty
        $ls[0].resource_type | Should -Be "LogicalSwitch"
        $ls[0].id | Should -Not -BeNullOrEmpty
        $ls[0].switching_profile_ids | Should -Not -BeNullOrEmpty
        $ls[0].display_name | Should -Not -BeNullOrEmpty
        $ls[0].tags | Should -Not -BeNullOrEmpty
    }

    It "Get Logical Switches by id ($sid)" {
        $ls = Get-NSXTLogicalSwitches -id $sid
        $ls.id | Should -Be $sid
    }

    It "Get Logical Switches by display_name ($pester_sg)" {
        $ls = Get-NSXTLogicalSwitches -display_name $pester_sg
        $ls.id | Should -Not -BeNullOrEmpty
        $ls.display_name | Should -Be $pester_sg
    }

    It "Get Logical Switches by vlan_id (23)" {
        $ls = Get-NSXTLogicalSwitches -vlan 23
        $ls.id | Should -Not -BeNullOrEmpty
        $ls.vlan | Should -Be "23"
        $ls.display_name | Should -Be $pester_sg
    }

    It "Get Logical Switches by transport_zone(_id) ($tid)" {
        $ls = Get-NSXTLogicalSwitches -transport_zone_id $tid
        $ls.transport_zone_id | Should -Be $tid
    }

    #It "Get Logical Switches by switching_profile_id ($pester_sg)" {
    #    $ls = Get-NSXTLogicalSwitches -switching_profile_id $pester_sg
    #    $ls.id | Should -Be $pester_sg
    #}

    It "Get Logical Switches and confirm (via Confirm-NSXTLogicalSwitches)" {
        $ls = Get-NSXTLogicalSwitches -display_name $pester_sg
        Confirm-NSXTLogicalSwitches $ls | Should -Be $true
    }

    AfterAll {
        Get-NSXTPolicyInfraSegments -segment $pester_sg | Remove-NSXTPolicyInfraSegments -confirm:$false
        #Wait 2 seconds to be sure the Segments is deleted (it can be make 5 sec for be removed !)
        Start-Sleep 2
    }

}

AfterAll {
    Disconnect-NSXT -confirm:$false
}
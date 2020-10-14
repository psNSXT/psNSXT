#
# Copyright 2019-2020, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
. ../common.ps1

Describe "Get Logical Ports" {
    BeforeAll {
        #Use default nsx-vlan-transportzone (from NSX-T 3.0...)
        Get-NSXTTransportZones -display_name nsx-vlan-transportzone | Add-NSXTPolicyInfraSegments -segment $pester_sg -vlan_ids 23

        $lp = Get-NSXTLogicalSwitches -display_name $pester_sg | Add-NSXTLogicalPorts -display_name $pester_lp
        $script:sid = $lp.id
        $script:tid = (Get-NSXTTransportZones -display_name nsx-vlan-transportzone).id
        $script:aid = $lp.attachment.id
    }

    It "Get Logical Ports Does not throw an error" {
        {
            Get-NSXTLogicalPorts
        } | Should Not Throw
    }

    It "Get Logical Ports" {
        $sg = Get-NSXTLogicalPorts
        $sg[0].logical_switch_id | Should -Not -BeNullOrEmpty
        $sg[0].attachment | Should -Not -BeNullOrEmpty
        $sg[0].admin_state | Should -Not -BeNullOrEmpty
        $sg[0].resource_type | Should -Be "LogicalPort"
        $sg[0].id | Should -Not -BeNullOrEmpty
        $sg[0].switching_profile_ids | Should -Not -BeNullOrEmpty
        $sg[0].display_name | Should -Not -BeNullOrEmpty
    }

    It "Get Logical Ports by id ($sid)" {
        $lp = Get-NSXTLogicalPorts -id $sid
        $lp.id | Should -Be $sid
    }

    It "Get Logical Ports by display_name ($pester_lp)" {
        $lp = Get-NSXTLogicalPorts -display_name $pester_lp
        $lp.id | Should -Not -BeNullOrEmpty
        $lp.display_name | Should -Be $pester_lp
    }

    It "Get Logical Ports by transport_zone(_id) ($tid)" {
        $lp = Get-NSXTLogicalPorts -transport_zone_id $tid
        $lp.id | Should -Not -BeNullOrEmpty
    }

    #It "Get Logical Ports by switching_profile_id ($pester_sg)" {
    #    $sg = Get-NSXTLogicalPorts -switching_profile_id $pester_sg
    #    $sg.id | Should -Be $pester_sg
    #}

    It "Get Logical Ports by attachment(_id) ($aid)" {
        $lp = Get-NSXTLogicalPorts -attachment_id $aid
        $lp.id | Should -Not -BeNullOrEmpty
        $lp.attachment.id | Should -Be $aid
    }

    AfterAll {
        Get-NSXTLogicalPorts -display_name $pester_lp | Remove-NSXTLogicalPorts -confirm:$false -force

        Get-NSXTPolicyInfraSegments -segment $pester_sg | Remove-NSXTPolicyInfraSegments -confirm:$false
        #Wait 2 seconds to be sure the Segments is deleted (it can be make 5 sec for be removed !)
        Start-Sleep 2
    }

}

Disconnect-NSXT -confirm:$false
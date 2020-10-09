#
# Copyright 2019-2020, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
. ../common.ps1

Describe "Get Logical Ports" {
    BeforeAll {
        #Need to create a default value...
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

    #It "Get Logical Ports by id ($sid)" {
    #    $sg = Get-NSXTLogicalPorts -id $sid
    #    $sg.id | Should -Be $sid
    #}

    #It "Get Logical Ports by display_name ($pester_sg)" {
    #    $sg = Get-NSXTLogicalPorts -display_name $pester_sg
    #    $sg.id | Should -Not -BeNullOrEmpty
    #    $sg.display_name | Should -Be $pester_sg
    #}

    #It "Get Logical Ports by transport_zone(_id) ($tid)" {
    #    $sg = Get-NSXTLogicalPorts -transport_zone_id $tid
    #    $sg.transport_zone_id | Should -Be $tid
    #}

    #It "Get Logical Ports by switching_profile_id ($pester_sg)" {
    #    $sg = Get-NSXTLogicalPorts -switching_profile_id $pester_sg
    #    $sg.id | Should -Be $pester_sg
    #}

    AfterAll {
        #Remove create Logical Ports...
    }

}

Disconnect-NSXT -confirm:$false
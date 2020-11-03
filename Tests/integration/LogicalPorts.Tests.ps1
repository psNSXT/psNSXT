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
        } | Should -Not -Throw
    }

    It "Get Logical Ports" {
        $lp = Get-NSXTLogicalPorts
        $lp[0].logical_switch_id | Should -Not -BeNullOrEmpty
        $lp[0].attachment | Should -Not -BeNullOrEmpty
        $lp[0].admin_state | Should -Not -BeNullOrEmpty
        $lp[0].resource_type | Should -Be "LogicalPort"
        $lp[0].id | Should -Not -BeNullOrEmpty
        $lp[0].switching_profile_ids | Should -Not -BeNullOrEmpty
        $lp[0].display_name | Should -Not -BeNullOrEmpty
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

    #It "Get Logical Ports by switching_profile_id ($spid)" {
    #    $lp = Get-NSXTLogicalPorts -switching_profile_id $spid
    #    $lp.id | Should -Be $pester_sg
    #}

    It "Get Logical Ports by attachment(_id) ($aid)" {
        $lp = Get-NSXTLogicalPorts -attachment_id $aid
        $lp.id | Should -Not -BeNullOrEmpty
        $lp.attachment.id | Should -Be $aid
    }

    It "Get Logical Ports and confirm (via Confirm-NSXTLogicalPorts)" {
        $ls = Get-NSXTLogicalPorts -display_name $pester_lp
        Confirm-NSXTLogicalPorts $ls | Should -Be $true
    }

    AfterAll {
        Get-NSXTLogicalPorts -display_name $pester_lp | Remove-NSXTLogicalPorts -confirm:$false -force

        Get-NSXTPolicyInfraSegments -segment $pester_sg | Remove-NSXTPolicyInfraSegments -confirm:$false
        #Wait 2 seconds to be sure the Segments is deleted (it can be make 5 sec for be removed !)
        Start-Sleep 2
    }

}

Describe "Set Logical Port" {
    BeforeAll {
        #Use default nsx-vlan-transportzone (from NSX-T 3.0...)
        Get-NSXTTransportZones -display_name nsx-vlan-transportzone | Add-NSXTPolicyInfraSegments -segment $pester_sg -vlan_ids 23
    }

    BeforeEach {
        Get-NSXTLogicalSwitches -display_name $pester_sg | Add-NSXTLogicalPorts -display_name $pester_lp
    }

    It "Set Logical Port description" {
        Get-NSXTLogicalPorts -display_name $pester_lp | Set-NSXTLogicalPorts -description "Modified by psNSXT"
        $lp = Get-NSXTLogicalPorts -display_name $pester_lp
        $lp.logical_switch_id | Should -Not -BeNullOrEmpty
        $lp.attachment | Should -Not -BeNullOrEmpty
        $lp.attachment.attachment_type | Should -Be "VIF"
        $lp.attachment.id | Should -Not -BeNullOrEmpty
        $lp.admin_state | Should -Be "UP"
        $lp.description | Should -Be "Modified by psNSXT"
        $lp.init_state | Should -BeNullOrEmpty
        $lp.resource_type | Should -Be "LogicalPort"
        $lp.id | Should -Not -BeNullOrEmpty
        $lp.switching_profile_ids | Should -Not -BeNullOrEmpty
        $lp.display_name | Should -Be $pester_lp
    }

    It "Set Logical Port with admin_state down" {
        Get-NSXTLogicalPorts -display_name $pester_lp | Set-NSXTLogicalPorts -admin_state "DOWN"
        $lp = Get-NSXTLogicalPorts -display_name $pester_lp
        $lp.attachment | Should -Not -BeNullOrEmpty
        $lp.attachment.attachment_type | Should -Be "VIF"
        $lp.attachment.id | Should -Not -BeNullOrEmpty
        $lp.admin_state | Should -Be "DOWN"
        $lp.description | Should -BeNullOrEmpty
        $lp.init_state | Should -BeNullOrEmpty
        $lp.resource_type | Should -Be "LogicalPort"
        $lp.id | Should -Not -BeNullOrEmpty
        $lp.switching_profile_ids | Should -Not -BeNullOrEmpty
        $lp.display_name | Should -Be $pester_lp
    }

    AfterEach {
        Get-NSXTLogicalPorts -display_name $pester_lp | Remove-NSXTLogicalPorts -confirm:$false -force
    }

    AfterAll {
        Get-NSXTPolicyInfraSegments -segment $pester_sg | Remove-NSXTPolicyInfraSegments -confirm:$false
        #Wait 2 seconds to be sure the Segments is deleted (it can be make 5 sec for be removed !)
        Start-Sleep 2
    }
}

Describe "Add Logical Port" {
    BeforeAll {
        #Use default nsx-vlan-transportzone (from NSX-T 3.0...)
        Get-NSXTTransportZones -display_name nsx-vlan-transportzone | Add-NSXTPolicyInfraSegments -segment $pester_sg -vlan_ids 23
        Start-Sleep 1
    }

    It "Add Logical Port" {
        Get-NSXTLogicalSwitches -display_name $pester_sg | Add-NSXTLogicalPorts -display_name $pester_lp
        $lp = Get-NSXTLogicalPorts -display_name $pester_lp
        $lp.logical_switch_id | Should -Not -BeNullOrEmpty
        $lp.attachment | Should -Not -BeNullOrEmpty
        $lp.attachment.attachment_type | Should -Be "VIF"
        $lp.attachment.id | Should -Not -BeNullOrEmpty
        $lp.admin_state | Should -Be "UP"
        $lp.description | Should -BeNullOrEmpty
        $lp.init_state | Should -BeNullOrEmpty
        $lp.resource_type | Should -Be "LogicalPort"
        $lp.id | Should -Not -BeNullOrEmpty
        $lp.switching_profile_ids | Should -Not -BeNullOrEmpty
        $lp.display_name | Should -Be $pester_lp
    }

    It "Add Logical Port with admin_state down" {
        Get-NSXTLogicalSwitches -display_name $pester_sg | Add-NSXTLogicalPorts -display_name $pester_lp -admin_state "DOWN"
        $lp = Get-NSXTLogicalPorts -display_name $pester_lp
        $lp.logical_switch_id | Should -Not -BeNullOrEmpty
        $lp.attachment | Should -Not -BeNullOrEmpty
        $lp.attachment.attachment_type | Should -Be "VIF"
        $lp.attachment.id | Should -Not -BeNullOrEmpty
        $lp.admin_state | Should -Be "DOWN"
        $lp.description | Should -BeNullOrEmpty
        $lp.init_state | Should -BeNullOrEmpty
        $lp.resource_type | Should -Be "LogicalPort"
        $lp.id | Should -Not -BeNullOrEmpty
        $lp.switching_profile_ids | Should -Not -BeNullOrEmpty
        $lp.display_name | Should -Be $pester_lp
    }

    It "Add Logical Port with specific attachement id" {
        Get-NSXTLogicalSwitches -display_name $pester_sg | Add-NSXTLogicalPorts -display_name $pester_lp -attachement_id 0d6560fc-8b51-40fb-b6b1-588a0cea8f22
        $lp = Get-NSXTLogicalPorts -display_name $pester_lp
        $lp.logical_switch_id | Should -Not -BeNullOrEmpty
        $lp.attachment | Should -Not -BeNullOrEmpty
        $lp.attachment.attachment_type | Should -Be "VIF"
        $lp.attachment.id | Should -Be "0d6560fc-8b51-40fb-b6b1-588a0cea8f22"
        $lp.admin_state | Should -Be "UP"
        $lp.description | Should -BeNullOrEmpty
        $lp.init_state | Should -BeNullOrEmpty
        $lp.resource_type | Should -Be "LogicalPort"
        $lp.id | Should -Not -BeNullOrEmpty
        $lp.switching_profile_ids | Should -Not -BeNullOrEmpty
        $lp.display_name | Should -Be $pester_lp
    }

    It "Add Logical Port with a description" {
        Get-NSXTLogicalSwitches -display_name $pester_sg | Add-NSXTLogicalPorts -display_name $pester_lp -description "Add via psNSXT"
        $lp = Get-NSXTLogicalPorts -display_name $pester_lp
        $lp.logical_switch_id | Should -Not -BeNullOrEmpty
        $lp.attachment | Should -Not -BeNullOrEmpty
        $lp.attachment.attachment_type | Should -Be "VIF"
        $lp.attachment.id | Should -Not -BeNullOrEmpty
        $lp.admin_state | Should -Be "UP"
        $lp.description | Should -Be "Add via psNSXT"
        $lp.init_state | Should -BeNullOrEmpty
        $lp.resource_type | Should -Be "LogicalPort"
        $lp.id | Should -Not -BeNullOrEmpty
        $lp.switching_profile_ids | Should -Not -BeNullOrEmpty
        $lp.display_name | Should -Be $pester_lp
    }

    It "Add Logical Port with a init_state" {
        Get-NSXTLogicalSwitches -display_name $pester_sg | Add-NSXTLogicalPorts -display_name $pester_lp -init_state UNBLOCKED_VLAN
        $lp = Get-NSXTLogicalPorts -display_name $pester_lp
        $lp.logical_switch_id | Should -Not -BeNullOrEmpty
        $lp.attachment | Should -Not -BeNullOrEmpty
        $lp.attachment.attachment_type | Should -Be "VIF"
        $lp.attachment.id | Should -Not -BeNullOrEmpty
        $lp.admin_state | Should -Be "UP"
        $lp.description | Should -BeNullOrEmpty
        $lp.init_state | Should -Be "UNBLOCKED_VLAN"
        $lp.resource_type | Should -Be "LogicalPort"
        $lp.id | Should -Not -BeNullOrEmpty
        $lp.switching_profile_ids | Should -Not -BeNullOrEmpty
        $lp.display_name | Should -Be $pester_lp
    }

    AfterEach {
        Get-NSXTLogicalPorts -display_name $pester_lp | Remove-NSXTLogicalPorts -confirm:$false -force
    }

    AfterAll {
        Get-NSXTPolicyInfraSegments -segment $pester_sg | Remove-NSXTPolicyInfraSegments -confirm:$false
        #Wait 2 seconds to be sure the Segments is deleted (it can be make 5 sec for be removed !)
        Start-Sleep 2
    }
}

Describe "Remove Logical Port" {
    BeforeAll {
        Get-NSXTTransportZones -display_name nsx-vlan-transportzone | Add-NSXTPolicyInfraSegments -segment $pester_sg -vlan_ids 23
    }
    BeforeEach {
        $lp = Get-NSXTLogicalSwitches -display_name $pester_sg | Add-NSXTLogicalPorts -display_name $pester_lp
        $script:lpid = $lp.id
    }

    It "Remove Logical Ports by id" {
        Remove-NSXTLogicalPorts -id $lpid -confirm:$false -force
        $lp = Get-NSXTLogicalPorts -display_name $pester_lp
        $lp | Should -Be $NULL
    }

    It "Remove Logical Ports ($pester_lp) by pipeline" {
        $lp = Get-NSXTLogicalPorts -display_name $pester_lp
        $lp | Remove-NSXTLogicalPorts -confirm:$false -force
        $lp = Get-NSXTLogicalPorts -display_name $pester_lp
        $lp | Should -Be $NULL
    }

    AfterAll {
        Get-NSXTPolicyInfraSegments -segment $pester_sg | Remove-NSXTPolicyInfraSegments -confirm:$false
        #Wait 2 seconds to be sure the Segments is deleted (it can be make 5 sec for be removed !)
        Start-Sleep 2
    }

}

Disconnect-NSXT -confirm:$false
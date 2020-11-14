#
# Copyright 2019-2020, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
. ../common.ps1

BeforeAll {
    Connect-NSXT @invokeParams
}
Describe "Get Vifs" {
    BeforeAll {
        $fvm = Get-NSXTFabricVirtualMachines -display_name $vm
        $script:fvmid = $fvm.external_id
        $script:hostid = $fvm.host_id
        $script:slpid = (Get-NSXTFabricVifs -owner_vm_id $fvmid).lport_attachment_id
    }

    It "Get Vifs Does not throw an error" {
        {
            Get-NSXTFabricVifs
        } | Should -Not -Throw
    }

    It "Get Vifs" {
        $vif = Get-NSXTFabricVifs
        $vif[0].external_id | Should -Not -BeNullOrEmpty
        $vif[0].owner_vm_id | Should -Not -BeNullOrEmpty
        $vif[0].owner_vm_type | Should -Not -BeNullOrEmpty
        $vif[0].host_id | Should -Not -BeNullOrEmpty
        $vif[0].vm_local_id_on_host | Should -Not -BeNullOrEmpty
        $vif[0].device_key | Should -Not -BeNullOrEmpty
        $vif[0].device_name | Should -Not -BeNullOrEmpty
        $vif[0].mac_address | Should -Not -BeNullOrEmpty
        $vif[0].resource_type | Should -Be "VirtualNetworkInterface"
        $vif[0].display_name | Should -Not -BeNullOrEmpty
    }

    It "Get Vifs by host_id ($hostid)" {
        $vif = Get-NSXTFabricVifs -host_id $hostid
        $vif[0].host_id | Should -Be $hostid
    }

    It "Get Vifs by owner_vm_id ($fvmid)" {
        $vif = Get-NSXTFabricVifs -owner_vm_id $fvmid
        $vif.owner_vm_id | Should -Be $fvmid
    }

    It "Get Vifs by lport_attachment_id ($slpid)" {
        $vif = Get-NSXTFabricVifs -lport_attachment_id $slpid
        $vif.lport_attachment_id | Should -Be $slpid
    }

    It "Get Vifs and confirm (via Confirm-NSXTFabricVifs)" {
        $vif = Get-NSXTFabricVifs -owner_vm_id $fvmid
        Confirm-NSXTFabricVifs $vif | Should -Be $true
    }
}

AfterAll {
    Disconnect-NSXT -confirm:$false
}
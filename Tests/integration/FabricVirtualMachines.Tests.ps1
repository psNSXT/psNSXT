#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
. ../common.ps1

Describe  "Get Fabric Virtual Machines" {
    BeforeAll {
        $fvm = Get-NSXTFabricVirtualMachines -display_name $vm
        $script:display_name = $fvm.display_name
        $script:host_id = $fvm.host_id
        $script:external_id = $fvm.external_id
    }

    It "Get Fabric Virtual Machines Does not throw an error" {
        {
            Get-NSXTFabricVirtualMachines
        } | Should Not Throw
    }

    It "Get Fabric Virtual Machines" {
        $fvm = Get-NSXTFabricVirtualMachines
        $fvm[0].host_id | Should Not BeNullOrEmpty
        $fvm[0].source | Should Not BeNullOrEmpty
        $fvm[0].external_id | Should Not BeNullOrEmpty
        $fvm[0].power_state | Should Not BeNullOrEmpty
        $fvm[0].local_id_on_host | Should Not BeNullOrEmpty
        $fvm[0].compute_ids | Should Not BeNullOrEmpty
        $fvm[0].type | Should be "REGULAR"
        $fvm[0].resource_type | Should be "VirtualMachine"
        $fvm[0].display_name | Should Not BeNullOrEmpty
        $fvm[0]._last_sync_time | Should Not BeNullOrEmpty
    }

    It "Get Fabric Virtual Machines by display_name ($display_name)" {
        $fvm = Get-NSXTFabricVirtualMachines -display_name $display_name
        $fvm.display_name | Should be $display_name
    }

    It "Get Fabric Virtual Machines by external_id ($external_id)" {
        $fvm = Get-NSXTFabricVirtualMachines -external_id $external_id
        $fvm.external_id | Should be $external_id
    }

    It "Get Fabric Virtual Machines by host_id ($host_id)" {
        $fvm = Get-NSXTFabricVirtualMachines -host_id $host_id
        $fvm.host_id | Should be $host_id
    }

    It "Get Fabric Virtual Machines and confirm (via Confirm-NSXTFabricVirtualMachines)" {
        $fvm = Get-NSXTFabricVirtualMachines -display_name $display_name
        Confirm-NSXTFabricVirtualMachines $fvm | Should be $true
    }
}

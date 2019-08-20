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
Describe  "Configure Fabric Virtual Machines Tag (via Set-NSXTFabricVirtualMachines)" {
    BeforeAll {
        $fvm = Get-NSXTFabricVirtualMachines -display_name $vm
        $script:display_name = $fvm.display_name
        #Remove All tags..
        $fvm | Set-NSXTFabricVirtualMachines -tags @()
    }

    It "Set a tag to VM" {
        Get-NSXTFabricVirtualMachines -display_name $display_name | Set-NSXTFabricVirtualMachines -tag tag1
        $vm = Get-NSXTFabricVirtualMachines -display_name $display_name
        ($vm.tags).count | Should be 1
        $tag1 = $vm.tags | Where-Object { $_.tag -eq "tag1" }
        $tag1.tag | Should Be "tag1"
        $tag1.scope | Should BeNullOrEmpty
    }

    It "Set a tag and a scope to VM" {
        Get-NSXTFabricVirtualMachines -display_name $display_name | Set-NSXTFabricVirtualMachines -tag tag1 -scope scope1
        $vm = Get-NSXTFabricVirtualMachines -display_name $display_name
        ($vm.tags).count | Should be 1
        $tag1 = $vm.tags | Where-Object { $_.tag -eq "tag1" }
        $tag1.tag | Should Be "tag1"
        $tag1.scope | Should Be "scope1"
    }

    It "Set two tag and two scope to VM" {
        Get-NSXTFabricVirtualMachines -display_name $display_name | Set-NSXTFabricVirtualMachines -tag tag1, tag2 -scope scope1, scope2
        $vm = Get-NSXTFabricVirtualMachines -display_name $display_name
        ($vm.tags).count | Should be 2
        $tag1 = $vm.tags | Where-Object { $_.tag -eq "tag1" }
        $tag1.tag | Should Be "tag1"
        $tag1.scope | Should Be "scope1"
        $tag2 = $vm.tags | Where-Object { $_.tag -eq "tag2" }
        $tag2.tag | Should Be "tag2"
        $tag2.scope | Should Be "scope2"
    }

    It "Set two tag and a scope to VM" {
        Get-NSXTFabricVirtualMachines -display_name $display_name | Set-NSXTFabricVirtualMachines -tag tag1, tag2 -scope scope1
        $vm = Get-NSXTFabricVirtualMachines -display_name $display_name
        ($vm.tags).count | Should be 2
        $tag1 = $vm.tags | Where-Object { $_.tag -eq "tag1" }
        $tag1.tag | Should Be "tag1"
        $tag1.scope | Should Be "scope1"
        $tag2 = $vm.tags | Where-Object { $_.tag -eq "tag2" }
        $tag2.tag | Should Be "tag2"
        $tag2.scope | Should BeNullOrEmpty
    }

    It "Set third tag and two scope (not scope for second) to VM" {
        Get-NSXTFabricVirtualMachines -display_name $display_name | Set-NSXTFabricVirtualMachines -tag tag1, tag2, tag3 -scope scope1, $null, scope3
        $vm = Get-NSXTFabricVirtualMachines -display_name $display_name
        ($vm.tags).count | Should be 3
        $tag1 = $vm.tags | Where-Object { $_.tag -eq "tag1" }
        $tag1.tag | Should Be "tag1"
        $tag1.scope | Should Be "scope1"
        $tag2 = $vm.tags | Where-Object { $_.tag -eq "tag2" }
        $tag2.tag | Should Be "tag2"
        $tag2.scope | Should BeNullOrEmpty
        $tag3 = $vm.tags | Where-Object { $_.tag -eq "tag3" }
        $tag3.tag | Should Be "tag3"
        $tag3.scope | Should Be "scope3"
    }

    It "Remove tag and scope" {
        #Create a tag and scope
        Get-NSXTFabricVirtualMachines -display_name $display_name | Set-NSXTFabricVirtualMachines -tag tag1 -scope tag1
        $vm = Get-NSXTFabricVirtualMachines -display_name $display_name
        ($vm.tags).count | Should be 1
        Get-NSXTFabricVirtualMachines -display_name $display_name | Set-NSXTFabricVirtualMachines -tags @()
        $vm = Get-NSXTFabricVirtualMachines -display_name $display_name
        ($vm.tags).count | Should be 0
        $vm.tags | should BeNullorEmpty
    }

    AfterEach {
        #Remove All tags..
        Get-NSXTFabricVirtualMachines -display_name $display_name | Set-NSXTFabricVirtualMachines -tags @()
    }


}
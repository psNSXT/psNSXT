#
# Copyright 2019-2020, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#
. ../common.ps1

Describe "Get Transport Nodes" {
    BeforeAll {
        #Get the first TransportNodes...
        $script:tn = (Get-NSXTTransportNodes)[0]
        $script:tnid = $tn.node_id
        $script:tnip = $tn.node_deployment_info.ip_addresses[0]
        $script:tnname = $tn.display_name
    }

    It "Get Transport Nodes Does not throw an error" {
        {
            Get-NSXTTransportNodes
        } | Should Not Throw
    }

    It "Get Transport Nodes" {
        $tn = Get-NSXTTransportNodes
        $tn[0].node_id | Should -Not -BeNullOrEmpty
        $tn[0].host_switch_spec | Should -Not -BeNullOrEmpty
        $tn[0].maintenance_mode | Should -Not -BeNullOrEmpty
        $tn[0].resource_type | Should -Be "TransportNode"
        $tn[0].id | Should -Not -BeNullOrEmpty
        $tn[0].node_deployment_info | Should -Not -BeNullOrEmpty
        $tn[0].display_name | Should -Not -BeNullOrEmpty
    }

    It "Get Transport Nodes by node id ($tnid)" {
        $tn = Get-NSXTTransportNodes -node_id $tnid
        $tn.id | Should -Be $tnid
    }

    It "Get Transport Nodes by node ip ($tnip)" {
        $tn = Get-NSXTTransportNodes -node_ip $tnip
        $tn.id | Should -Not -BeNullOrEmpty
        $tn.node_deployment_info.ip_addresses | Should -Be $tnip
    }


    It "Get Transport Nodes by display_name ($tnname)" {
        $tn = Get-NSXTTransportNodes -display_name $tnname
        $tn.id | Should -Not -BeNullOrEmpty
        $tn.display_name | Should -Be $tnname
    }

    #It "Get Transport Nodes by transport_zone(_id) ($tid)" {
    #    $tn = Get-NSXTTransportNodes -transport_zone_id $tid
    #    $tn.transport_zone_id | Should -Be $tid
    #}

    It "Get Transport Nodes and confirm (via Confirm-NSXTTransportNodes)" {
        $tn = Get-NSXTTransportNodes -display_name $tnname
        Confirm-NSXTTransportNodes $tn | Should -Be $true
    }

}

Disconnect-NSXT -confirm:$false
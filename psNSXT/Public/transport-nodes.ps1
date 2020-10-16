#
# Copyright 2020, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Get-NSXTTransportNodes {

    <#
        .SYNOPSIS
        Get information about Transport Nodes

        .DESCRIPTION
        Returns information about Transport Nodes

        .EXAMPLE
        Get-NSXTTransportNodes

        Display all Transport Nodes

        .EXAMPLE
        Get-NSXTTransportZones -node_id ede3e69a-6562-49a6-98c4-d23408bd832c

        Display Transport Nodes with node(_id) ede3e69a-6562-49a6-98c4-d23408bd832c

        .EXAMPLE
        Get-NSXTTransportNodes -display_name MyTransportNodes

        Display Transport Nodes with (display) name MyTransportNodes

        .EXAMPLE
        Get-NSXTTransportNodes -transport_zone_id ede3e69a-6562-49a6-98c4-d23408bd832c

        Display Transport Nodes with transport_zone_id ede3e69a-6562-49a6-98c4-d23408bd832c

        .EXAMPLE
        Get-NSXTTransportZones -node_ip 192.0.2.1

        Display Transport Nodes with node IP 192.0.2.1

        .EXAMPLE
        Get-NSXTTransportNodes -in_maintenance_mode

        Display Transport Nodes with maintenance mode

    #>

    [CmdletBinding(DefaultParametersetname = "Default")]
    Param(
        [Parameter(Mandatory = $false, ParameterSetName = "Default")]
        [string]$node_id,
        [Parameter(Mandatory = $false, ParameterSetName = "Default")]
        [string]$node_ip,
        [Parameter(Mandatory = $false, ParameterSetName = "display_name")]
        [string]$display_name,
        [Parameter(Mandatory = $false, ParameterSetName = "Default")]
        [string]$transport_zone_id,
        [Parameter(Mandatory = $false, ParameterSetName = "Default")]
        [switch]$in_maintenance_mode,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultNSXTConnection
    )

    Begin {
    }

    Process {

        $uri = 'api/v1/transport-nodes?'

        if ( $PsBoundParameters.ContainsKey('node_id') ) {
            $uri += "&node_id=$node_id"
        }

        if ( $PsBoundParameters.ContainsKey('node_ip') ) {
            $uri += "&node_ip=$node_ip"
        }

        if ( $PsBoundParameters.ContainsKey('transport_zone_id') ) {
            $uri += "&transport_zone_id=$transport_zone_id"
        }

        if ( $PsBoundParameters.ContainsKey('in_maintenance_mode') ) {
            $uri += "&in_maintenance_mode=true"
        }

        $response = Invoke-NSXTRestMethod -uri $uri -method 'GET' -connection $connection

        switch ( $PSCmdlet.ParameterSetName ) {
            "display_name" {
                #When there is a display_name, search on response
                $response.results | Where-Object { $_.display_name -eq $display_name }
            }
            default {
                $response.results
            }
        }

    }

    End {
    }
}

function Move-NSXTTransportNodes {

    <#
        .SYNOPSIS
        Change settings of a Logical Ports

        .DESCRIPTION
        Change settings (description, admin state) of a Logical Ports

        .EXAMPLE
        Get-NSXTLogicalPorts -id ff8140b0-010e-4e92-aa62-a55766f17da0 | Set-NSXTLogicalPorts -description "Modified by psNSXT"

        Change description of Logical Ports ff8140b0-010e-4e92-aa62-a55766f17da0

        .EXAMPLE
        Get-NSXTLogicalPorts -display_name MyLogicalPort | Set-NSXTLogicalPorts -admin_state "Down"

        Change admin state to Down of Logical Ports MyLogicalPort

    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'high')]
    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { Confirm-NSXTTransportNodes $_ })]
        [psobject]$tn,
        [Parameter(Mandatory = $true)]
        [ValidateScript( { Confirm-NSXTFabricVirtualMachines $_ })]
        [psobject]$vm,
        [Parameter(Mandatory = $true)]
        [ValidateScript( { Confirm-NSXTLogicalPorts $_ })]
        [psobject]$lp,
        [Parameter(Mandatory = $false)]
        [int]$vnic_number = '0',
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultNSXTConnection
    )

    Begin {
    }

    Process {

        $tn_id = $tn.id
        $tn_name = "(" + $tn.display_name + ")"

        $uri = "api/v1/transport-nodes/" + $tn_id + "?"
        $vnic = $vm.external_id + ":400" + $vnic_number

        $uri += "&vnic=" + $vnic

        $vnic_migration_dest = $lp.attachment.id
        $uri += "&vnic_migration_dest=" + $vnic_migration_dest

        if ($PSCmdlet.ShouldProcess("$tn_id $tn_name", 'Move VM')) {
            $response = Invoke-NSXTRestMethod -uri $uri -method 'PUT' -body $tn -connection $connection
            $response.results
        }

    }

    End {
    }
}
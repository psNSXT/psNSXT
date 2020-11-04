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
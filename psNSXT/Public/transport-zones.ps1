#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Get-NSXTTransportZones {

    <#
        .SYNOPSIS
        Get information about Transport Zones

        .DESCRIPTION
        Returns information about Transport Zones

        .EXAMPLE
        Get-NSXTFabricVirtualMachines

        Display all Fabric Virtual Machines

        .EXAMPLE
        Get-NSXTFabricVirtualMachines -zone-id myVM

        Display Virtual Machines with display_name myVM

    #>

    Param(
        [Parameter(Mandatory = $false)]
        [string]$zone_id,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultNSXTConnection
    )

    Begin {
    }

    Process {

        $uri = 'api/v1/transport-zones'

        if ( $PsBoundParameters.ContainsKey('zone_id') ) {
            $uri += "/$zone_id"
        }

        $response = Invoke-NSXTRestMethod -uri $uri -method 'GET' -connection $connection

        #When there is a zone_id, it is directly the result...
        if ( $PsBoundParameters.ContainsKey('zone_id') ) {
            $response
        }
        else {
            $response.results
        }

    }

    End {
    }
}
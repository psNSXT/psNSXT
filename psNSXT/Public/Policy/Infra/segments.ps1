#
# Copyright 2019-2020, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Get-NSXTPolicyInfraSegments {

    <#
        .SYNOPSIS
        Get information about Segments

        .DESCRIPTION
        Returns information about Segments

        .EXAMPLE
        Get-NSXTPolicyInfraSegments

        Display all Transport Zones

        .EXAMPLE
        Get-NSXTPolicyInfraSegments -segment mySegment

        Display Segments with segment mySegment

        .EXAMPLE
        Get-NSXTPolicyInfraSegments -display_name mySegment

        Display Segments with (display) name mySegment

    #>

    [CmdletBinding(DefaultParametersetname = "Default")]
    Param(
        [Parameter(Mandatory = $false, ParameterSetName = "segment")]
        [string]$segment,
        [Parameter(Mandatory = $false, ParameterSetName = "display_name")]
        [string]$display_name,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultNSXTConnection
    )

    Begin {
    }

    Process {

        $uri = 'policy/api/v1/infra/segments'

        if ( $PsBoundParameters.ContainsKey('segment') ) {
            $uri += "/$segment"
        }

        $response = Invoke-NSXTRestMethod -uri $uri -method 'GET' -connection $connection

        switch ( $PSCmdlet.ParameterSetName ) {
            "segment" {
                #When there is a zone_id, it is directly the result...
                $response
            }
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
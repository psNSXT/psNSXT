#
# Copyright 2020, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Get-NSXTLogicalPorts {

    <#
        .SYNOPSIS
        Get information about Logical Ports

        .DESCRIPTION
        Returns information about Logical Ports

        .EXAMPLE
        Get-NSXTLogicalPorts

        Display all Logical Ports

        .EXAMPLE
        Get-NSXTLogicalPorts -id dd604e91-71df-40e3-9d7c-ac4a124e8497

        Display Logical Ports with id dd604e91-71df-40e3-9d7c-ac4a124e8497

        .EXAMPLE
        Get-NSXTLogicalPorts -switching_profile_id ede3e69a-6562-49a6-98c4-d23408bd832c

        Display Logical Ports with switching_profile_id ede3e69a-6562-49a6-98c4-d23408bd832c

        .EXAMPLE
        Get-NSXTLogicalPorts -display_name MyLogicalPorts

        Display Logical Ports with (display) name MyLogicalPorts

        .EXAMPLE
        Get-NSXTLogicalPorts -attachment_id 2c05288a-5ffb-4e52-bace-12960fc5baf9

        Display Logical Ports with attachment_id 2c05288a-5ffb-4e52-bace-12960fc5baf9

        .EXAMPLE
        Get-NSXTLogicalPorts -attachment_type VIF

        Display Logical Ports with attachment_type VIF

        .EXAMPLE
        Get-NSXTLogicalPorts -transport_zone_id ede3e69a-6562-49a6-98c4-d23408bd832c

        Display Logical Ports with transport_zone_id ede3e69a-6562-49a6-98c4-d23408bd832c
    #>

    [CmdletBinding(DefaultParametersetname = "Default")]
    Param(
        [Parameter(Mandatory = $false, ParameterSetName = "id")]
        [string]$id,
        [Parameter(Mandatory = $false, ParameterSetName = "Default")]
        [string]$switching_profile_id,
        [Parameter(Mandatory = $false, ParameterSetName = "display_name")]
        [string]$display_name,
        [Parameter(Mandatory = $false, ParameterSetName = "Default")]
        [string]$transport_zone_id,
        [Parameter(Mandatory = $false, ParameterSetName = "Default")]
        [string]$attachment_type,
        [Parameter(Mandatory = $false, ParameterSetName = "Default")]
        [string]$attachment_id,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultNSXTConnection
    )

    Begin {
    }

    Process {

        $uri = 'api/v1/logical-ports?'

        if ( $PsBoundParameters.ContainsKey('switching_profile_id') ) {
            $uri += "&switching_profile_id=$switching_profile_id"
        }

        if ( $PsBoundParameters.ContainsKey('transport_zone_id') ) {
            $uri += "&transport_zone_id=$transport_zone_id"
        }

        if ( $PsBoundParameters.ContainsKey('attachment_type') ) {
            $uri += "&attachment_type=$attachment_type"
        }

        if ( $PsBoundParameters.ContainsKey('attachment_id') ) {
            $uri += "&attachment_id=$attachment_id"
        }

        $response = Invoke-NSXTRestMethod -uri $uri -method 'GET' -connection $connection

        switch ( $PSCmdlet.ParameterSetName ) {
            "id" {
                #When there is a id, search on response
                $response.results | Where-Object { $_.id -eq $id }
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

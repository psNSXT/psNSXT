#
# Copyright 2020, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Get-NSXTFabricVifs {

    <#
        .SYNOPSIS
        Get information about Vifs (Virtual Interfaces)

        .DESCRIPTION
        Returns information about Vifs (Virtual Interfaces)

        .EXAMPLE
        Get-NSXTFabricVifs

        Display all Vifs (Virtual Interfaces)

        .EXAMPLE
        Get-NSXTFabricVifs -host_id ede3e69a-6562-49a6-98c4-d23408bd832c

        Display Vifs (Virtual Interfaces) with host_id ede3e69a-6562-49a6-98c4-d23408bd832c

        .EXAMPLE
        Get-NSXTFabricVifs -lport_attachment_id a934f1be-8f87-4851-8175-0572206a50e3

        Display Vifs (Virtual Interfaces) with lport_attachment_id a934f1be-8f87-4851-8175-0572206a50e3

        .EXAMPLE
        Get-NSXTFabricVifs -owner_vm_id ede3e69a-6562-49a6-98c4-d23408bd832c

        Display Vifs (Virtual Interfaces) with owner_vm_id ede3e69a-6562-49a6-98c4-d23408bd832c

        .EXAMPLE
        Get-NSXTFabricVifs -owner_vm_id ede3e69a-6562-49a6-98c4-d23408bd832c

        Display Vifs (Virtual Interfaces) with owner_vm_id ede3e69a-6562-49a6-98c4-d23408bd832c
    #>

    [CmdletBinding(DefaultParametersetname = "Default")]
    Param(
        [Parameter(Mandatory = $false, ParameterSetName = "Default")]
        [string]$host_id,
        [Parameter(Mandatory = $false, ParameterSetName = "Default")]
        [string]$lport_attachment_id,
        [Parameter(Mandatory = $false, ParameterSetName = "Default")]
        [string]$owner_vm_id,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultNSXTConnection
    )

    Begin {
    }

    Process {

        $uri = 'api/v1/fabric/vifs?'

        if ( $PsBoundParameters.ContainsKey('host_id') ) {
            $uri += "&host_id=$host_id"
        }

        if ( $PsBoundParameters.ContainsKey('lport_attachment_id') ) {
            $uri += "&lport_attachment_id=$lport_attachment_id"
        }

        if ( $PsBoundParameters.ContainsKey('owner_vm_id') ) {
            $uri += "&owner_vm_id=$owner_vm_id"
        }

        $response = Invoke-NSXTRestMethod -uri $uri -method 'GET' -connection $connection
        $response.results

    }

    End {
    }
}
#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Get-NSXTFabricVirtualMachines {

    <#
        .SYNOPSIS
        Get information about virtual machines

        .DESCRIPTION
        Returns information about all virtual machines

        .EXAMPLE
        Get-NSXTFabricVirtualMachines

        Display all Fabric Virtual Machines

    #>

    Param(
        [Parameter(Mandatory = $false)]
        [psobject]$connection=$DefaultNSXTConnection
    )

    Begin {
    }

    Process {

        $uri = 'api/v1/fabric/virtual-machines?'

        $response = Invoke-NSXTRestMethod -uri $uri -method 'GET' -connection $connection
        $response.results
    }

    End {
    }
}
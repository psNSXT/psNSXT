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

        .EXAMPLE
        Get-NSXTFabricVirtualMachines -display_name myVM

        Display Virtual Machines with display_name myVM

        .EXAMPLE
        Get-NSXTFabricVirtualMachines -external_id 501055b3-848a-eb82-2edf-af002c569585

        Display Virtual Machines with host_id 501055b3-848a-eb82-2edf-af002c569585

        .EXAMPLE
        Get-NSXTFabricVirtualMachines -host_id 85ef4ac5-3492-44e5-831a-c03169b70dd45

        Display Virtual Machines with host_id 85ef4ac5-3492-44e5-831a-c03169b70dd4

    #>

    Param(
        [Parameter(Mandatory = $false)]
        [string]$display_name,
        [Parameter(Mandatory = $false)]
        [string]$external_id,
        [Parameter(Mandatory = $false)]
        [string]$host_id,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultNSXTConnection
    )

    Begin {
    }

    Process {

        $uri = 'api/v1/fabric/virtual-machines?'

        if ( $PsBoundParameters.ContainsKey('display_name') ) {
            $uri += "&display_name=$display_name"
        }

        if ( $PsBoundParameters.ContainsKey('external_id') ) {
            $uri += "&external_id=$external_id"
        }

        if ( $PsBoundParameters.ContainsKey('host_id') ) {
            $uri += "&host_id=$host_id"
        }

        $response = Invoke-NSXTRestMethod -uri $uri -method 'GET' -connection $connection
        $response.results
    }

    End {
    }
}

function Set-NSXTFabricVirtualMachines {

    <#
        .SYNOPSIS
        Set information about virtual machines

        .DESCRIPTION
        Returns information about all virtual machines

        .EXAMPLE
        Get-NSXTFabricVirtualMachines -display_name myVM | Set-NSXTFabricVirtualMachines -tag myTag

        Configure MyTag to Virtual Machine myVM

        .EXAMPLE
        Set-NSXTFabricVirtualMachines -external_id 5010d8d7-1d7e-f1df-dcd4-7919fadce87d -tag myTag

        Configure MyTag to Virtual Machine with external id 5010d8d7-1d7e-f1df-dcd4-7919fadce87d

    #>

    #[CmdLetBinding(DefaultParameterSetName = "Default")]

    Param(
        [Parameter(Mandatory = $true, ParameterSetName = "external_id")]
        [string]$external_id,
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = "VirtualMachines")]
        #ValidateScript({ ValidateVirtualMachines $_ })]
        [psobject]$VirtualMachines,
        [Parameter(Mandatory = $false)]
        [string]$tag,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultNSXTConnection
    )

    Begin {
    }

    Process {

        #if it is passed by pipeline, get external_id
        if ($VirtualMachines) {
            $external_id = $VirtualMachines.external_id
        }

        $uri = 'api/v1/fabric/virtual-machines?action=update_tags'

        #Create a Array Tag
        $tags = @()
        $atag = New-Object -TypeName PSObject @{
            tag = $tag
        }
        $tags += $atag

        #Create update tags object include external_id and tags
        $update_tags = New-Object -TypeName PSObject
        $update_tags | Add-member -name "external_id" -membertype NoteProperty -Value $external_id
        $update_tags | Add-member -name "tags" -membertype NoteProperty -value $tags

        $response = Invoke-NSXTRestMethod -uri $uri -method 'POST' -body $update_tags -connection $connection
        $response.results

        #Display update Virtual Machine
        Get-NSXTFabricVirtualMachines -external_id $external_id
    }

    End {
    }
}
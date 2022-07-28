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
        Get-NSXTFabricVirtualMachines -display_name myVM | Set-NSXTFabricVirtualMachines -tag myTag -scope myScope

        Configure Tag MyTag and scope MyScope to Virtual Machine myVM

        .EXAMPLE
        Get-NSXTFabricVirtualMachines -display_name myVM | Set-NSXTFabricVirtualMachines -tag myTag1,myTag2 -scope myScope1,myScope2

        Configure multiple Tag (MyTag and myTag2) and Scope (myScope1 and myScope2) to Virtual Machine myVM

        .EXAMPLE
        Set-NSXTFabricVirtualMachines -external_id 5010d8d7-1d7e-f1df-dcd4-7919fadce87d -tag myTag

        Configure MyTag to Virtual Machine with external id 5010d8d7-1d7e-f1df-dcd4-7919fadce87d

        .EXAMPLE
        $tags = @()
        PS > $tags += @{ tag = "MyTag1"; scope = "myScope1" }
        PS > $tags += @{ tag = "MyTag2" }
        PS > Get-NSXTFabricVirtualMachines -display_name myVM | Set-NSXTFabricVirtualMachines -tags $tags

        Configure $tags (a array of tags) to Virtual Machine myVM
    #>

    #[CmdLetBinding(DefaultParameterSetName = "Default")]
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'medium')]
    Param(
        [Parameter(Mandatory = $true, ParameterSetName = "external_id")]
        [string]$external_id,
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = "VirtualMachines")]
        [ValidateScript( { Confirm-NSXTFabricVirtualMachines $_ })]
        [psobject]$VirtualMachines,
        [Parameter(Mandatory = $false)]
        [string[]]$tag,
        [Parameter(Mandatory = $false)]
        [string[]]$scope,
        [Parameter(Mandatory = $false)]
        [array]$tags,
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

        if ( $PsBoundParameters.ContainsKey('tag') -and $PsBoundParameters.ContainsKey('tags')) {
            Throw "Can use on the same time tag and tags parameter"
        }

        #Set new tag(s)
        if ($PsBoundParameters.ContainsKey('tag')) {
            #Create a Array Tag
            $tags = @()
            $i = 0
            foreach ($t in $tag) {
                #Add tag to ArrayTag
                $atag = New-Object -TypeName PSObject @{
                    tag = $t
                }
                #Check if there is a scope variable
                if ( $PsBoundParameters.ContainsKey('scope') ) {
                    #And if is not null add scope value
                    if ($null -ne $scope[$i] ) {
                        $atag.Add( "scope", $scope[$i])
                    }
                }
                $i++
                $tags += $atag
            }
        }

        #Create update tags object include external_id and tags
        $update_tags = New-Object -TypeName PSObject
        $update_tags | Add-member -name "external_id" -membertype NoteProperty -Value $external_id
        $update_tags | Add-member -name "tags" -membertype NoteProperty -value $tags

        if ($PSCmdlet.ShouldProcess($external_id, 'Configure Tag and Scope on Fabric Virtual Machine')) {
            $response = Invoke-NSXTRestMethod -uri $uri -method 'POST' -body $update_tags -connection $connection
            $response.results
        }

        #Display update Virtual Machine
        Get-NSXTFabricVirtualMachines -external_id $external_id -connection $connection
    }

    End {
    }
}

function Add-NSXTFabricVirtualMachines {

    <#
        .SYNOPSIS
        Add information about virtual machines

        .DESCRIPTION
        Add tag to a virtual Machine

        .EXAMPLE
        Get-NSXTFabricVirtualMachines -display_name myVM | Add-NSXTFabricVirtualMachines -tag myTag

        Add MyTag to Virtual Machine myVM

        .EXAMPLE
        Get-NSXTFabricVirtualMachines -display_name myVM | Add-NSXTFabricVirtualMachines -tag myTag -scope myScope

        Add Tag MyTag and scope MyScope to Virtual Machine myVM

        .EXAMPLE
        Get-NSXTFabricVirtualMachines -display_name myVM | Add-NSXTFabricVirtualMachines -tag myTag1,myTag2 -scope myScope1,myScope2

        Add multiple Tag (MyTag and myTag2) and Scope (myScope1 and myScope2) to Virtual Machine myVM

    #>

    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = "VirtualMachines")]
        [ValidateScript( { Confirm-NSXTFabricVirtualMachines $_ })]
        [psobject]$VirtualMachines,
        [Parameter(Mandatory = $false)]
        [string[]]$tag,
        [Parameter(Mandatory = $false)]
        [string[]]$scope,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultNSXTConnection
    )

    Begin {
    }

    Process {

        #if it is passed by pipeline, get external_id
        $external_id = $VirtualMachines.external_id
        $tags = $VirtualMachines.tags

        $uri = 'api/v1/fabric/virtual-machines?action=update_tags'


        #Add new tag(s)
        $i = 0
        foreach ($t in $tag) {
            #Add tag to ArrayTag
            $atag = New-Object -TypeName PSObject @{
                tag = $t
            }
            #Check if there is a scope variable
            if ( $PsBoundParameters.ContainsKey('scope') ) {
                #And if is not null add scope value
                if ($null -ne $scope[$i] ) {
                    $atag.Add( "scope", $scope[$i])
                }
            }
            $i++
            $tags += $atag
        }

        #Create update tags object include external_id and tags
        $update_tags = New-Object -TypeName PSObject
        $update_tags | Add-member -name "external_id" -membertype NoteProperty -Value $external_id
        $update_tags | Add-member -name "tags" -membertype NoteProperty -value $tags

        $response = Invoke-NSXTRestMethod -uri $uri -method 'POST' -body $update_tags -connection $connection
        $response.results

        #Display update Virtual Machine
        Get-NSXTFabricVirtualMachines -external_id $external_id -connection $connection
    }

    End {
    }
}
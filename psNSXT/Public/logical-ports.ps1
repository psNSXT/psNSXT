#
# Copyright 2020, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Add-NSXTLogicalPorts {

    <#
        .SYNOPSIS
        Add a Logical Ports

        .DESCRIPTION
        Add a Logical Ports

        .EXAMPLE
        Get-NSXTLogicalSwitches -display_name MyLogicalSwitch | Add-NSXTLogicalPorts -display_name MyLogicalPort -admin_state UP -attachement_id 0d6560fc-8b51-40fb-b6b1-588a0cea8f22

        Add a LogicalPorts type MyLogicalPort with admin state UP on MyLogicalSwitch with attachement id 0d6560fc-8b51-40fb-b6b1-588a0cea8f22

        .EXAMPLE
        Get-NSXTLogicalSwitches -display_name MyLogicalSwitch | Add-NSXTLogicalPorts -display_name MyLogicalPort -admin_state UP -attachement_id 0d6560fc-8b51-40fb-b6b1-588a0cea8f22 -description "Add by psNSXT"

        Add a LogicalPorts type MyLogicalPort with admin state UP on MyLogicalSwitch with attachement id 0d6560fc-8b51-40fb-b6b1-588a0cea8f22 with a description

        .EXAMPLE
        Get-NSXTLogicalSwitches -display_name MyLogicalSwitch | Add-NSXTLogicalPorts -display_name MyLogicalPort -admin_state UP -attachement_id 0d6560fc-8b51-40fb-b6b1-588a0cea8f22 -init_state UNBLOCKED_VLAN

        Add a LogicalPorts type MyLogicalPort with admin state UP on MyLogicalSwitch with attachement id 0d6560fc-8b51-40fb-b6b1-588a0cea8f22 and init state set to Unblocked vlan
    #>

    Param(
        [Parameter(Mandatory = $false)]
        [ValidateSet("UP", "DOWN", IgnoreCase = $false)]
        [string]$admin_state = "UP",
        [Parameter(Mandatory = $false)]
        [guid]$attachement_id,
        [Parameter(Mandatory = $true)]
        [string]$display_name,
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { Confirm-NSXTLogicalPorts $_ })]
        [psobject]$logical_switch_id,
        [Parameter(Mandatory = $false)]
        [ValidateSet("UNBLOCKED_VLAN", IgnoreCase = $false)]
        [string]$init_state,
        [Parameter(Mandatory = $false)]
        [string]$description,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultNSXTConnection
    )

    Begin {
    }

    Process {

        $uri = 'api/v1/logical-ports'

        $_lg = new-Object -TypeName PSObject

        $_lg | add-member -name "admin_state" -membertype NoteProperty -Value $admin_state

        $_lg | add-member -name "display_name" -membertype NoteProperty -Value $display_name

        $attachment = new-Object -TypeName PSObject
        $attachment | Add-member -name "attachment_type" -membertype NoteProperty -Value "VIF"
        if ( -not $PsBoundParameters.ContainsKey('attachement_id') ) {
            $attachement_id = (New-Guid).guid
        }
        $attachment | Add-member -name "id" -membertype NoteProperty -Value $attachement_id

        $_lg | add-member -name "attachment" -membertype NoteProperty -Value $attachment

        $_lg | add-member -name "logical_switch_id" -membertype NoteProperty -Value $logical_switch_id.id

        if ( $PsBoundParameters.ContainsKey('init_state') ) {
            $_lg | add-member -name "init_state" -membertype NoteProperty -Value $init_state
        }

        if ( $PsBoundParameters.ContainsKey('description') ) {
            $_lg | add-member -name "description" -membertype NoteProperty -Value $description
        }

        $response = Invoke-NSXTRestMethod -uri $uri -method 'POST' -body $_lg -connection $connection
        $response

    }

    End {
    }
}

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

function Remove-NSXTLogicalPorts {

    <#
        .SYNOPSIS
        Remove a Logical Port

        .DESCRIPTION
        Remove a Logical Port

        .EXAMPLE
        $tz = Get-NSXTLogicalPorts -id ff8140b0-010e-4e92-aa62-a55766f17da0
        PS C:\>$tz | Remove-NSXTLogicalPorts

        Remove Logical Port with id ff8140b0-010e-4e92-aa62-a55766f17da0

        .EXAMPLE
        Remove-NSXTLogicalPorts -id ff8140b0-010e-4e92-aa62-a55766f17da0 -confirm:$false

        Remove Logical Port with id ff8140b0-010e-4e92-aa62-a55766f17da0 with no confirmation
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'high')]
    Param(
        [Parameter (Mandatory = $true, ParameterSetName = "id")]
        [string]$id,
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1, ParameterSetName = "lp")]
        [ValidateScript( { Confirm-NSXTLogicalPorts $_ })]
        [psobject]$lp,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultNSXTConnection
    )

    Begin {
    }

    Process {

        #get lp id from lp object
        if ($lp) {
            $id = $lp.id
            $name = "(" + $lp.display_name + ")"
        }

        $uri = "api/v1/logical-ports/$id"

        if ($PSCmdlet.ShouldProcess("LP", "Remove Logical Port ${id} ${name}")) {
            Invoke-NSXTRestMethod -method "DELETE" -uri $uri -connection $connection
        }
    }

    End {
    }
}
#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Add-NSXTTransportZones {

    <#
        .SYNOPSIS
        Add a Transport Zones

        .DESCRIPTION
        Add a Transport Zones (Vlan or Overlay)

        .EXAMPLE
        Add-NSXTTransportZones -transport_type VLAN -host_switch_name NVDS-psNSXT -display_name MyTZ-Vlan -description "Add via psNSXT"

        Add a TransportZones type Vlan with NVDS (host_switch_name) NVDS-psNSXT named myTZ-Vlan with an description

        .EXAMPLE
        Add-NSXTTransportZones -transport_type OVERLAY -host_switch_name NVDS-psNSXT -display_name MyTZ-Overlay -description "Add via psNSXT"

        Add a TransportZones type Overlay with NVDS (host_switch_name) NVDS-psNSXT named myTZ-Overlay with an description

        .EXAMPLE
        Add-NSXTTransportZones -transport_type OVERLAY -host_switch_name NVDS-psNSXT -host_switch_mode ENS

        Add a TransportZones type Overlay with NVDS (host_switch_name) NVDS-psNSXT using Enhanced Datapath

        .EXAMPLE
        Add-NSXTTransportZones -transport_type OVERLAY -host_switch_name NVDS-psNSXT -nested_nsx -is_default

        Add a TransportZones type Overlay with NVDS (host_switch_name) NVDS-psNSXT and enable NSX nested and default Transport Zone
    #>

    Param(
        [Parameter(Mandatory = $false)]
        [string]$display_name,
        [Parameter(Mandatory = $true)]
        [string]$host_switch_name,
        [Parameter(Mandatory = $false)]
        [string]$description,
        [Parameter(Mandatory = $true)]
        [ValidateSet("VLAN", "OVERLAY", IgnoreCase = $false)]
        [string]$transport_type,
        [Parameter(Mandatory = $false)]
        [ValidateSet("ENS", "STANDARD", IgnoreCase = $false)]
        [string]$host_switch_mode,
        [Parameter(Mandatory = $false)]
        [switch]$nested_nsx,
        [Parameter(Mandatory = $false)]
        [switch]$is_default,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultNSXTConnection
    )

    Begin {
    }

    Process {

        $uri = 'api/v1/transport-zones'

        $_tz = new-Object -TypeName PSObject

        $_tz | add-member -name "host_switch_name" -membertype NoteProperty -Value $host_switch_name

        $_tz | add-member -name "transport_type" -membertype NoteProperty -Value $transport_type

        if ( $PsBoundParameters.ContainsKey('display_name') ) {
            $_tz | add-member -name "display_name" -membertype NoteProperty -Value $display_name
        }

        if ( $PsBoundParameters.ContainsKey('description') ) {
            $_tz | add-member -name "description" -membertype NoteProperty -Value $description
        }

        if ( $PsBoundParameters.ContainsKey('host_switch_mode') ) {
            $_tz | add-member -name "host_switch_mode" -membertype NoteProperty -Value $host_switch_mode
        }

        if ( $PsBoundParameters.ContainsKey('nested_nsx') ) {
            if ( $nested_nsx ) {
                $_tz | Add-Member -name "nested_nsx" -membertype NoteProperty -Value $True
            }
            else {
                $_tz | Add-Member -name "nested_nsx" -membertype NoteProperty -Value $false
            }
        }

        if ( $PsBoundParameters.ContainsKey('is_default') ) {
            if ( $is_default ) {
                $_tz | Add-Member -name "is_default" -membertype NoteProperty -Value $True
            }
            else {
                $_tz | Add-Member -name "is_default" -membertype NoteProperty -Value $false
            }
        }

        $response = Invoke-NSXTRestMethod -uri $uri -method 'POST' -body $_tz -connection $connection
        $response

    }

    End {
    }
}

function Get-NSXTTransportZones {

    <#
        .SYNOPSIS
        Get information about Transport Zones

        .DESCRIPTION
        Returns information about Transport Zones

        .EXAMPLE
        Get-NSXTTransportZones

        Display all Transport Zones

        .EXAMPLE
        Get-NSXTTransportZones -zone_id ede3e69a-6562-49a6-98c4-d23408bd832c

        Display Transport Zones with (zone) id ede3e69a-6562-49a6-98c4-d23408bd832c

        .EXAMPLE
        Get-NSXTTransportZones -display_name TZ-VLAN

        Display Transport Zones with (display) name TZ-VLAN

        .EXAMPLE
        Get-NSXTTransportZones -host_switch_name NVDS-psNSXT

        Display Transport Zones with host_switch_name (N-VDS) NVDS-psNSXT
    #>

    [CmdletBinding(DefaultParametersetname = "Default")]
    Param(
        [Parameter(Mandatory = $false, ParameterSetName = "zone_id")]
        [string]$zone_id,
        [Parameter(Mandatory = $false, ParameterSetName = "display_name")]
        [string]$display_name,
        [Parameter(Mandatory = $false, ParameterSetName = "host_switch_name")]
        [string]$host_switch_name,
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

        switch ( $PSCmdlet.ParameterSetName ) {
            "zone_id" {
                #When there is a zone_id, it is directly the result...
                $response
            }
            "display_name" {
                #When there is a display_name, search on response
                $response.results | Where-Object { $_.display_name -eq $display_name }
            }
            "host_switch_name" {
                #When there is a host_switch_name, search on response
                $response.results | Where-Object { $_.host_switch_name -eq $host_switch_name }
            }
            default {
                $response.results
            }
        }

    }

    End {
    }
}

function Set-NSXTTransportZones {

    <#
        .SYNOPSIS
        Change settings of a Transport Zones

        .DESCRIPTION
        Change settings (name, description) of a Transport Zones

        .EXAMPLE
        Get-NSXTTransportZones -zone_id ff8140b0-010e-4e92-aa62-a55766f17da0 | Set-NSXTTransportZones -display_name "My New TZ Name"

        Change name of Transport Zones ff8140b0-010e-4e92-aa62-a55766f17da0

        .EXAMPLE
        Get-NSXTTransportZones -zone_id ff8140b0-010e-4e92-aa62-a55766f17da0 | Set-NSXTTransportZones -description "Modified by psNSXT"

        Change description of Transport Zones ff8140b0-010e-4e92-aa62-a55766f17da0

        .EXAMPLE
        Get-NSXTTransportZones -zone_id ff8140b0-010e-4e92-aa62-a55766f17da0 | Set-NSXTTransportZones -is_default

        Enable default for Transport Zones ff8140b0-010e-4e92-aa62-a55766f17da0

    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'medium')]
    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateScript( { Confirm-NSXTTransportZones $_ })]
        [psobject]$tz,
        [Parameter(Mandatory = $false)]
        [string]$display_name,
        [Parameter(Mandatory = $false)]
        [string]$description,
        [Parameter(Mandatory = $false)]
        [switch]$is_default,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultNSXTConnection
    )

    Begin {
    }

    Process {

        $zone_id = $tz.id
        $zone_name = "(" + $tz.display_name + ")"

        $uri = "api/v1/transport-zones/$zone_id"

        if ( $PsBoundParameters.ContainsKey('display_name') ) {
            $tz.display_name = $display_name
        }

        if ( $PsBoundParameters.ContainsKey('description') ) {
            if ($null -eq $tz.description) {
                $tz | Add-member -name "description" -membertype NoteProperty -Value ""
            }
            $tz.description = $description
        }

        if ( $PsBoundParameters.ContainsKey('is_default') ) {
            if ( $is_default ) {
                $tz.is_default = $true
            }
            else {
                $tz.is_default = $false
            }
        }

        if ($PSCmdlet.ShouldProcess("$zone_id $zone_name", 'Configure Transport Zones')) {
            $response = Invoke-NSXTRestMethod -uri $uri -method 'PUT' -body $tz -connection $connection
            $response.results
        }

        #Display update Transport Zones
        Get-NSXTTransportZones -zone_id $zone_id -connection $connection
    }

    End {
    }
}


function Remove-NSXTTransportZones {

    <#
        .SYNOPSIS
        Remove a Transport Zone

        .DESCRIPTION
        Remove a Transport Zone

        .EXAMPLE
        $tz = Get-TransportZones -zone_id ff8140b0-010e-4e92-aa62-a55766f17da0
        PS C:\>$tz | Remove-NSXTTransportZones

        Remove Transport Zone with (zone) id ff8140b0-010e-4e92-aa62-a55766f17da0

        .EXAMPLE
        Remove-NSXTTransportZones -zone_id ff8140b0-010e-4e92-aa62-a55766f17da0 -confirm:$false

        Remove Transport Zone with (zone) id ff8140b0-010e-4e92-aa62-a55766f17da0 with no confirmation
    #>

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'high')]
    Param(
        [Parameter (Mandatory = $true, ParameterSetName = "zone_id")]
        [string]$zone_id,
        [Parameter (Mandatory = $true, ValueFromPipeline = $true, Position = 1, ParameterSetName = "tz")]
        [ValidateScript( { Confirm-NSXTTransportZones $_ })]
        [psobject]$tz,
        [Parameter(Mandatory = $false)]
        [psobject]$connection = $DefaultNSXTConnection
    )

    Begin {
    }

    Process {

        #get tz id from tz object
        if ($tz) {
            $zone_id = $tz.id
            $name = " (" + $tz.display_name + ")"
        }

        $uri = "api/v1/transport-zones/$zone_id"

        if ($PSCmdlet.ShouldProcess("TZ", "Remove Transport Zone ${zone_id} ${name}")) {
            Write-Progress -activity "Remove TZ"
            Invoke-NSXTRestMethod -method "DELETE" -uri $uri -connection $connection
            Write-Progress -activity "Remove TZ" -completed
        }
    }

    End {
    }
}
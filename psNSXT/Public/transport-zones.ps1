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
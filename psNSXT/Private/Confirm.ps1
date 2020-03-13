#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

Function Confirm-NSXTFabricVirtualMachines {

    Param (
        [Parameter (Mandatory = $true)]
        [object]$argument
    )

    #Check if it looks like an Fabric Virtual Machines element

    if ( -not ( $argument | get-member -name host_id -Membertype Properties)) {
        throw "Element specified does not contain a host_id property."
    }
    if ( -not ( $argument | get-member -name external_id -Membertype Properties)) {
        throw "Element specified does not contain an external_id property."
    }
    if ( -not ( $argument | get-member -name resource_type -Membertype Properties)) {
        throw "Element specified does not contain a resource_type property."
    }
    if ( -not ( $argument | get-member -name display_name -Membertype Properties)) {
        throw "Element specified does not contain a display_name property."
    }
    if ( -not ( $argument | get-member -name tags -Membertype Properties)) {
        throw "Element specified does not contain a tags property."
    }
    $true

}

Function Confirm-NSXTTransportZones {

    Param (
        [Parameter (Mandatory = $true)]
        [object]$argument
    )

    #Check if it looks like an Transport Zones element

    if ( -not ( $argument | get-member -name transport_type -Membertype Properties)) {
        throw "Element specified does not contain a transport_type property."
    }
    if ( -not ( $argument | get-member -name host_switch_name -Membertype Properties)) {
        throw "Element specified does not contain an host_switch_name property."
    }
    if ( -not ( $argument | get-member -name host_switch_id -Membertype Properties)) {
        throw "Element specified does not contain a host_switch_id property."
    }
    if ( -not ( $argument | get-member -name host_switch_mode -Membertype Properties)) {
        throw "Element specified does not contain a host_switch_mode property."
    }
    if ( -not ( $argument | get-member -name nested_nsx -Membertype Properties)) {
        throw "Element specified does not contain a nested_nsx property."
    }
    if ( -not ( $argument | get-member -name is_default -Membertype Properties)) {
        throw "Element specified does not contain a is_default property."
    }
    if ( -not ( $argument | get-member -name resource_type -Membertype Properties)) {
        throw "Element specified does not contain a resource_type property."
    }
    if ( -not ( $argument | get-member -name id -Membertype Properties)) {
        throw "Element specified does not contain a id property."
    }
    if ( -not ( $argument | get-member -name display_name -Membertype Properties)) {
        throw "Element specified does not contain a display_name property."
    }
    $true

}
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
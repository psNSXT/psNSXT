# psNSXT Tests

## Pre-Requisites

The tests don't be to be run on PRODUCTION NSX-T manager ! there is no warning about change on Manager.
It need to be use only for TESTS !

    An NSX-T Manger with release >= 2.4.x
    Only need an ip address with a VM attach to a N-VDS
    a user and password for admin account

These are the required modules for the tests

    Pester

## Executing Tests

Assuming you have git cloned the psNSXT repository. Go on tests folder and copy credentials.example.ps1 to credentials.ps1 and edit to set information about your NSX-T Manager (ipaddress, login, password)

Go after on integration folder and launch all tests via

```powershell
Invoke-Pester *
```

It is possible to custom some settings when launch test (like Transport Zones Name use for Transport Zone test or segment used), you need to uncommented following line on credentials.ps1

```powershell
$pester_tz = My_psNSXT_tz
$pester_sg = My_psNSXT_segment
...
```

## Executing Individual Tests

Tests are broken up according to functional area. If you are working on Connection functionality for instance, its possible to just run Connection related tests.

Example:

```powershell
Invoke-Pester Connection.Tests.ps1
```

if you only launch a sub test (Describe on pester file), you can use for example to 'Connect to a NSX-T (using Basic)' part

```powershell
Invoke-Pester Connection.Tests.ps1 -testName "Connect to a NSX-T (using Basic)"
```

## Known Issues

No known issues (for the moment...)
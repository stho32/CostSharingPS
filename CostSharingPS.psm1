<#
    .SYNOPSIS
    This module helps splitting costs between you and your friends and/or family on a trip

#>

$ErrorActionPreference = "Stop"

Push-Location $PSScriptRoot

. ./Library/New-Payment.ps1
. ./Library/New-Debt.ps1
. ./Library/Split-Payment.ps1
. ./Library/Group-Debt.ps1
. ./Library/Set-DebtDirection.ps1

Pop-Location
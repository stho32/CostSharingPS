function New-Payment {
    <#
        .SYNOPSIS
        Creates a payment 

        .EXAMPLE
        New-Payment -From "Bob" -Value 30 -ForInvoiceNr 1
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string]$From,
        [Parameter(Mandatory=$true)]
        [decimal]$Value,
        [Parameter(Mandatory=$true)]
        [string]$ForInvoiceNr
    )

    Process {
        New-Object -TypeName PSObject -Property @{
            PaymentFrom = $From
            Value = $Value
            InvoiceNr = $ForInvoiceNr
        }
    }
}
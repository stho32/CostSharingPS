function New-Debt {
    <#
        .SYNOPSIS
        Creates a debt description object
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string]$Name,
        [Parameter(Mandatory=$true)]
        [decimal]$Owes,
        [Parameter(Mandatory=$true)]
        [string]$ForInvoiceNr,
        [Parameter(Mandatory=$true)]
        [string]$To
    )

    Process {
        New-Object -TypeName PSObject -Property @{
            Name = $Name
            Value = $Owes
            InvoiceNr = $ForInvoiceNr
            OwedTo = $To
        }
    }
}
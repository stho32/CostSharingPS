function Split-Payment {
    <#
        .SYNOPSIS
        Splits a payment into debts for everyone else but the payer
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$PaymentFrom,
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [decimal]$Value,
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]$InvoiceNr,
        [Parameter(Mandatory=$true, HelpMessage="All the names of the people that take part.")]
        [string[]]$Participants
    )

    Process {
        # The value is split equally between all participants 
        $splitValue = [Math]::Round( $Value / $Participants.Count, 2 ) # Round to two decimals
        # For everyone that did not pay a debt is created
        $Participants |
            Where-Object { $_ -ne $PaymentFrom } | 
            ForEach-Object {
                New-Debt -Name $_ -Owes $splitValue -ForInvoiceNr $InvoiceNr -To $PaymentFrom
        }
    }
}
function Group-Debt {
    <#
        .SYNOPSIS
        Groups and sums up debts per Name and OwedTo
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [PSObject[]]$Debts
    )
    
    process {
        $grouped = $Debts | Group-Object Name, OwedTo

        $grouped | ForEach-Object {
            $Name = $_.Group[0].Name
            $OwedTo = $_.Group[0].OwedTo
            $Value = ($_.Group.Value | Measure-Object -Sum).Sum
            $InvoiceNr = ($_.Group | Join-String -Property InvoiceNr -Separator ",")

            New-Debt -Name $Name -Owes $Value -ForInvoiceNr $InvoiceNr -To $OwedTo
        }
    }
}
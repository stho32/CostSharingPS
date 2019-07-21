function Set-DebtDirection {
    <#
        .SYNOPSIS
        Turns the sign and order of a debt if it is not in the order of the participants

        .DESCRIPTION
        When finally summing up all debts it is much easier if the payments between two
        people always are formulated in the same direction. 
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [PSObject]$Debt,
        [Parameter(Mandatory=$true)]
        [string[]]$Participants,
        [Parameter(Mandatory=$true)]
        [ValidateSet("ByParticipants", "BySign")]
        [string]$Order        
    )
    
    process {
        if ($Order -eq "ByParticipants") {
            $indexOfName = $Participants.IndexOf($Debt.Name)
            $indexOfOwedTo = $Participants.IndexOf($Debt.OwedTo)
    
            if ($indexOfOwedTo -lt $indexOfName) {
                $reverseDebt = New-Debt -Name $Debt.OwedTo -Owes (-1 * $Debt.Value) -ForInvoiceNr $Debt.InvoiceNr -To $Debt.Name
                return $reverseDebt
            }
    
            return $Debt
        }

        if ($Order -eq "BySign") {
            if ($Debt.Value -lt 0) {
                $reverseDebt = New-Debt -Name $Debt.OwedTo -Owes (-1 * $Debt.Value) -ForInvoiceNr $Debt.InvoiceNr -To $Debt.Name
                return $reverseDebt
            }
    
            return $Debt
        }
    }
}
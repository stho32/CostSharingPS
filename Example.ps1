Remove-Module CostSharingPS*
Import-Module ./CostSharingPS.psm1

$currency = "EUR"

$payments = @(
    New-Payment -ForInvoiceNr "Common House" -From "Joe" -Value 2090
    New-Payment -ForInvoiceNr 1 -From "Bob" -Value 60
    New-Payment -ForInvoiceNr 1 -From "Joe" -Value 40.15
    New-Payment -ForInvoiceNr "R2" -From "Ralph" -Value 45
)

$participants = "Joe", "Bob", "Ralph"

$sum = ($payments.Value | Measure-Object -Sum).Sum
Write-Host "" 
Write-Host "Equal cost sharing:" -ForegroundColor Green 

Write-Host " - The total and complete cost is $sum $currency at the moment." -ForegroundColor Yellow  
Write-Host " - You want to share costs equally between" ($participants -join ",")
Write-Host " - This means that every person has to pay $([Math]::Round($sum/$participants.Count, 2)) $currency"

Write-Host "" 

$payments | Group-Object PaymentFrom | ForEach-Object {
    $who = $_.Name 
    $sum = ($_.Group.Value | Measure-Object -Sum).Sum

    Write-Host " - $who has payed $sum $currency in total."
} 


$debts = $payments | 
    Split-Payment -Participants $participants |
    Set-DebtDirection -Order "ByParticipants" -Participants $participants 

$debtsTotal = Group-Debt -Debts $debts | 
    Set-DebtDirection -Order "BySign" -Participants $participants

Write-Host "" 
Write-Host "To reach equal cost sharing this is what who has to pay whom: " -ForegroundColor Green 

# This table will tell you who needs to pay whom money for equal sharing.
$debtsTotal | ForEach-Object {
  Write-Host " - $($_.Name) has to pay $($_.Value) $currency to $($_.OwedTo)." -ForegroundColor Yellow   
}

Write-Host "" 

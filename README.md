# CostSharingPS
A powershell module for calculating shared costs

## Description of the problem that needs solving

Imagine a group of people that pays a lot of different things
for a common purpose, a vacation e.g.. 

## Solution

The module implements a simple algorithm for equal cost sharing. 
Which means, that every person in the group can pay as much as they want.

 - The invoices are collected, they get their number or whatever for reference and the information who payed how much for them.
 - The sample shows how to use the cmdlets of the module to create the desired result: A simple list of the least amount of payments between the people so that everyone payed an equal amount.

## The Example

```powershell
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
```

## Example Output

```
Equal cost sharing:
 - The total and complete cost is 2235.15 EUR at the moment.
 - You want to share costs equally between Joe,Bob,Ralph
 - This means that every person has to pay 745.05 EUR

 - Bob has payed 60 EUR in total.
 - Joe has payed 2130.15 EUR in total.
 - Ralph has payed 45 EUR in total.

To reach equal cost sharing this is what who has to pay whom: 
 - Ralph has to pay 5 EUR to Bob.
 - Bob has to pay 690.05 EUR to Joe.
 - Ralph has to pay 695.05 EUR to Joe.
```
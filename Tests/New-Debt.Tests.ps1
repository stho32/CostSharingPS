Remove-Module CostSharingPS*
Import-Module "$PSScriptRoot/../CostSharingPS.psm1"

Describe "New-Debt" {
    It "creates a new debt" {
        $payment = New-Debt -Name "Bob" -Owes 17.3 -ForInvoiceNr "HelloInvoice1" -To "Joe"
        $payment.Name | Should -Be "Bob"
        $payment.Value | Should -Be 17.3
        $payment.InvoiceNr | Should -Be "HelloInvoice1"
        $payment.OwedTo | Should -Be "Joe"
    }
}
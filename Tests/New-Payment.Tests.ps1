Remove-Module CostSharingPS*
Import-Module "$PSScriptRoot/../CostSharingPS.psm1"

Describe "New-Payment" {
    It "creates a new payment" {
        $payment = New-Payment -From "Bob" -Value 17.3 -ForInvoiceNr "HelloInvoice1"
        $payment.PaymentFrom | Should -Be "Bob"
        $payment.Value | Should -Be 17.3
        $payment.InvoiceNr | Should -Be "HelloInvoice1"
    }

    It "can be used to create a list of payments easily" {
        $payments = @(
            New-Payment -From "Bob" -Value 17.3 -ForInvoiceNr "HelloInvoice1"
            New-Payment -From "Ralf" -Value 1 -ForInvoiceNr "AnotherOne"
        )
        $payments.Count | Should -Be 2
        $payments[0].PaymentFrom | Should -Be "Bob"
        $payments[1].PaymentFrom | Should -Be "Ralf"
    }
}
Remove-Module CostSharingPS*
Import-Module "$PSScriptRoot/../CostSharingPS.psm1"

Describe "Group-Debt" {
    It "doesn't change a thing if it is just one debt" {
        $debt = New-Debt -Name "Bob" -Owes 17.3 -ForInvoiceNr "HelloInvoice1" -To "Joe"

        $result = Group-Debt -Debts $debt
        $result.Name | Should -Be "Bob"
        $result.Value | Should -Be 17.3
        $result.InvoiceNr | Should -Be "HelloInvoice1"
        $result.OwedTo | Should -Be "Joe"
    }

    It "sums debts if name and owedTo are the same" {
        $debt1 = New-Debt -Name "Bob" -Owes 15 -ForInvoiceNr "HelloInvoice1" -To "Joe"
        $debt2 = New-Debt -Name "Bob" -Owes 20 -ForInvoiceNr "HelloInvoice2" -To "Joe"

        $result = Group-Debt -Debts @($debt1, $debt2)
        $result.Name | Should -Be "Bob"
        $result.Value | Should -Be 35
        $result.InvoiceNr | Should -Be "HelloInvoice1,HelloInvoice2"
        $result.OwedTo | Should -Be "Joe"
    }

    It "doesn't sum debts which have different name/owedTo-combinations" {
        $debt1 = New-Debt -Name "Bob" -Owes 15 -ForInvoiceNr "HelloInvoice1" -To "Joe"
        $debt2 = New-Debt -Name "Joe" -Owes 20 -ForInvoiceNr "HelloInvoice2" -To "Bob"

        $result = Group-Debt -Debts @($debt1, $debt2)

        $result.Count | Should -Be 2

        $result[0].Name | Should -Be "Bob"
        $result[0].Value | Should -Be 15
        $result[0].InvoiceNr | Should -Be "HelloInvoice1"
        $result[0].OwedTo | Should -Be "Joe"

        $result[1].Name | Should -Be "Joe"
        $result[1].Value | Should -Be 20
        $result[1].InvoiceNr | Should -Be "HelloInvoice2"
        $result[1].OwedTo | Should -Be "Bob"
    }
}
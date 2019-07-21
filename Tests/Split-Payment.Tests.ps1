Remove-Module CostSharingPS*
Import-Module "$PSScriptRoot/../CostSharingPS.psm1"

Describe "Split-Payment" {
    It "creates a 10 bug debt for B when A and B are participants and A payed 20 bugs" {
        $result = Split-Payment -PaymentFrom "A" -Value 20 -InvoiceNr 1 -Participants "A","B"
        
        ($result | Measure-Object).Count | Should -Be 1
        $result.Name | Should -Be "B"
        $result.Value | Should -Be 10
        $result.InvoiceNr | Should -Be 1
        $result.OwedTo | Should -Be "A" 
    }

    It "creates no debt for A when A has payed the bill" {
        $result = Split-Payment -PaymentFrom "A" -Value 20 -InvoiceNr 1 -Participants "A","B"
        
        ($result | Measure-Object).Count | Should -Be 1
        $result.Name | Should -Be -Not "A"
    }

    It "takes payment objects as input" {
        $payment = New-Payment -From "A" -Value 20 -ForInvoiceNr 2
        $result = $payment | Split-Payment -Participants "A","B"

        ($result | Measure-Object).Count | Should -Be 1
        $result.Name | Should -Be "B"
        $result.Value | Should -Be 10
        $result.InvoiceNr | Should -Be 2
        $result.OwedTo | Should -Be "A" 
    }

    It "splits a 15 EUR payment of A into a 5 EUR debt for B and C to A" {
        $payment = New-Payment -From "A" -Value 15 -ForInvoiceNr 1
        $result = $payment | Split-Payment -Participants "A","B", "C"

        ($result | Measure-Object).Count | Should -Be 2
        $result[0].Value | Should -Be 5
        $result[1].Value | Should -Be 5
        $result[0].Name | Should -Be "B"
        $result[1].Name | Should -Be "C"
        $result[0].OwedTo | Should -Be "A"
        $result[1].OwedTo | Should -Be "A"
    }
}
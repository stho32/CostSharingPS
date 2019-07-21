Remove-Module CostSharingPS*
Import-Module "$PSScriptRoot/../CostSharingPS.psm1"

Describe "Set-DebtDirection" {
    Context "ByParticipants" {
        It "changes the sign and the order of names if the second name is first in the list of participants" {
            $debt = New-Debt -Name "B" -Owes 10 -ForInvoiceNr "HelloInvoice1" -To "A"

            $result = $debt | Set-DebtDirection -Participants @("A", "B") -Order "ByParticipants"
            
            $result.Name | Should -Be "A"
            $result.Value | Should -Be -10
            $result.InvoiceNr | Should -Be "HelloInvoice1"
            $result.OwedTo | Should -Be "B"
        }

        It "doesn't change anything if the first name is first in the list of participants" {
            $debt = New-Debt -Name "B" -Owes 10 -ForInvoiceNr "HelloInvoice1" -To "A"

            $result = $debt | Set-DebtDirection -Participants @("B", "A") -Order "ByParticipants"
            
            $result.Name | Should -Be "B"
            $result.Value | Should -Be 10
            $result.InvoiceNr | Should -Be "HelloInvoice1"
            $result.OwedTo | Should -Be "A"
        }
    }

    Context "BySign" {
        It "changes the sign and the order of names if the value is below zero" {
            $debt = New-Debt -Name "B" -Owes -10 -ForInvoiceNr "HelloInvoice1" -To "A"

            $result = $debt | Set-DebtDirection -Participants @("A", "B") -Order "BySign"
            
            $result.Name | Should -Be "A"
            $result.Value | Should -Be 10
            $result.InvoiceNr | Should -Be "HelloInvoice1"
            $result.OwedTo | Should -Be "B"
        }

        It "doesn't change anything if the value is positive" {
            $debt = New-Debt -Name "B" -Owes 10 -ForInvoiceNr "HelloInvoice1" -To "A"

            $result = $debt | Set-DebtDirection -Participants @("B", "A") -Order "BySign"
            
            $result.Name | Should -Be "B"
            $result.Value | Should -Be 10
            $result.InvoiceNr | Should -Be "HelloInvoice1"
            $result.OwedTo | Should -Be "A"
        }
    }
}
update DebtCampaign
  set total = importe + iva
  
  
delete from DebtCampaign
where id_debt_campaign not in (
select dc.id_debt_campaign
  from DebtCampaign dc
 where dc.consumo = 'HABITACIONAL'
 )
 
 select sum(dd.amount - dd.on_account)
   from Debt d
      , Debt_Detail dd
    where dd.DebtId = d.id_debt
      and d.status in ('ED001','ED004','ED007','ED011')
      and d.[type] = 'TIP01'
      and dd.code_concept in (1,7,20)
      and d.AgreementId = 13
      
      
truncate table DebtCampaign     
select a.id_agreement 
     , a.account
     , ti.[name]
     , isnull((select sum(d.amount - d.on_account)
          from Debt d 
         where d.AgreementId = a.id_agreement
           and d.status in ('ED001','ED004','ED007','ED011')),0) AdeudoTotal
     , isnull((select sum(d.amount - d.on_account)
          from Debt d 
         where d.AgreementId = a.id_agreement
           and d.status in ('ED001','ED004','ED007','ED011')
           and d.[type] = 'TIP01' ),0) Predial
     , isnull((select sum(d.amount - d.on_account)
          from Debt d 
         where d.AgreementId = a.id_agreement
           and d.status in ('ED001','ED004','ED007','ED011')
           and d.[type] = 'TIP04' ),0) Limpia  
     , isnull((select count(d.id_debt)
          from Debt d 
         where d.AgreementId = a.id_agreement
           and d.status in ('ED001','ED004','ED007','ED011')
           and d.[type] = 'TIP01' ),0) AñosPredialDeuda           
     , isnull((select sum(d.amount - d.on_account)
          from Debt d 
         where d.AgreementId = a.id_agreement
           and d.status in ('ED001','ED004','ED007','ED011')
           and d.[year] = 2017
           and d.[type] = 'TIP01' ),0) Predial2017
     , isnull((select sum(d.amount - d.on_account)
          from Debt d 
         where d.AgreementId = a.id_agreement
           and d.status in ('ED001','ED004','ED007','ED011')
           and d.[year] = 2018
           and d.[type] = 'TIP01' ),0) Predial2018
     , isnull((select sum(d.amount - d.on_account)
          from Debt d 
         where d.AgreementId = a.id_agreement
           and d.status in ('ED001','ED004','ED007','ED011')
           and d.[year] = 2019
           and d.[type] = 'TIP01' ),0) Predial2019
     , isnull((select sum(d.amount - d.on_account)
          from Debt d 
         where d.AgreementId = a.id_agreement
           and d.status in ('ED001','ED004','ED007','ED011')
           and d.[year] = 2020
           and d.[type] = 'TIP01' ),0) Predial2020
     , isnull((select sum(d.amount - d.on_account)
          from Debt d 
         where d.AgreementId = a.id_agreement
           and d.status in ('ED001','ED004','ED007','ED011')
           and d.[year] = 2021
           and d.[type] = 'TIP01' ),0) Predial2021
  from Agreement a
      , Type_Intake ti
  where a.TypeStateServiceId in (1)
    and ti.id_type_intake = a.TypeIntakeId
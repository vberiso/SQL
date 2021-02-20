select a.id_agreement 
     , a.account
     , ti.[name]     
     , ad.taxable_base BaseGravable
     , ad.ground Terreno
     , ad.built Construccion
     , year(ad.last_update) UltimoAvaluo
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
     , isnull((select  case 
                        when d.status = 'ED005' then 'Pagado'
                       else      
                             convert(varchar, sum(d.amount - d.on_account))
                       end
          from Debt d 
         where d.AgreementId = a.id_agreement
           and d.status in ('ED001','ED004','ED007','ED011', 'ED005')
           and d.[year] = 2017
           and d.[type] = 'TIP01' 
           group by d.status ) ,0) Predial2017
     , isnull((select  case 
                        when d.status = 'ED005' then 'Pagado'
                       else      
                             convert(varchar, sum(d.amount - d.on_account))
                       end
          from Debt d 
         where d.AgreementId = a.id_agreement
           and d.status in ('ED001','ED004','ED007','ED011', 'ED005')
           and d.[year] = 2018
           and d.[type] = 'TIP01' 
           group by d.status ) ,0) Predial2018
     , isnull((select  case 
                        when d.status = 'ED005' then 'Pagado'
                       else      
                             convert(varchar, sum(d.amount - d.on_account))
                       end
          from Debt d 
         where d.AgreementId = a.id_agreement
           and d.status in ('ED001','ED004','ED007','ED011', 'ED005')
           and d.[year] = 2019
           and d.[type] = 'TIP01' 
           group by d.status ) ,0) Predial2019
     , isnull((select  case 
                        when d.status = 'ED005' then 'Pagado'
                       else      
                             convert(varchar, sum(d.amount - d.on_account))
                       end
          from Debt d 
         where d.AgreementId = a.id_agreement
           and d.status in ('ED001','ED004','ED007','ED011', 'ED005')
           and d.[year] = 2020
           and d.[type] = 'TIP01' 
           group by d.status ) ,0) Predial2020
     , isnull((select  case 
                        when d.status = 'ED005' then 'Pagado'
                       else      
                             convert(varchar, sum(d.amount - d.on_account))
                       end
          from Debt d 
         where d.AgreementId = a.id_agreement
           and d.status in ('ED001','ED004','ED007','ED011', 'ED005')
           and d.[year] = 2021
           and d.[type] = 'TIP01' 
           group by d.status ) ,0) Predial2021
       , siscom_ayuntamiento.dbo.calculate_tax(a.id_agreement, 1, 0) PredialCalculo
       , siscom_ayuntamiento.dbo.calculate_tax(a.id_agreement, 2, 0) PredialCalculo
       , siscom_ayuntamiento.dbo.calculate_tax(a.id_agreement, 3, 0) FormulaPredial
  from Agreement a
      , Type_Intake ti
      , Agreement_Detail ad
  where a.TypeStateServiceId in (1)
    and ti.id_type_intake = a.TypeIntakeId
    and ad.AgreementId = a.id_agreement
  
   /*and a.account in ('121405',
'121406',
'121407',
'121408',
'121409',
'121410',
'121411',
'121412',
'121413',
'121414',
'121415',
'121416',
'121417',
'121418',
'121419',
'121420',
'121421',
'121422')*/
    
    and a.account in ('58890',
'117670',
'84574',
'121437',
'120432',
'113688',
'27026',
'121379',
'121380',
'121374',
'114077',
'93924',
'117788',
'121396',
'49230',
'82655',
'92765',
'114298',
'121405',
'121415',
'113690',
'116952',
'116366',
'120462',
'120106',
'54855',
'84889',
'121316',
'91061',
'83217',
'118293',
'73162',
'117697',
'117671',
'117696',
'120704',
'120622',
'120459',
'105906',
'108137',
'87163',
'106413')
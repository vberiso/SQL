INSERT INTO DebtCampaign(
   ruta
  ,AgreementId
  ,account
  ,start_year_debt
  ,end_year_debt
  ,importe
  ,iva
  ,total
  ,total_agua
  ,total_drenaje
  ,total_saneamiento
  ,status
  ,folio
  ,date_subscription
  ,DebtId
  ,consumo
  ,servicios
  ,descuento_multa
  ,descuento_notificaciones
  ,descuento_recargo
  ,importe_multas
  ,importe_notificaciones
  ,importe_recargo
  ,total_descuento_servicios
  ,servicios_adelantados
) select a.[route]
     , a.id_agreement
     , a.account
     , isnull((select concat(month(min(d.from_date)),'/',year(min(d.from_date)))
          from Debt d 
         where d.AgreementId = a.id_agreement
           and d.status in ('ED001','ED004','ED007','ED011')
           and d.[year] < 2021
           and d.[type] = 'TIP01'),0) anio_inicio
     , isnull((select concat(month(max(d.from_date)),'/',year(max(d.from_date)))
          from Debt d 
         where d.AgreementId = a.id_agreement
           and d.status in ('ED001','ED004','ED007','ED011')
           and d.[year] < 2021
           and d.[type] = 'TIP01'),0) anio_fin         
     , isnull((select sum(d.amount - d.on_account)
          from Debt d 
         where d.AgreementId = a.id_agreement
           and d.status in ('ED001','ED004','ED007','ED011')
           and d.[year] < 2021),0) AdeudoTotal
     , isnull((select sum(dd.amount - dd.on_account)
          from Debt d
             , Debt_Detail dd
         where dd.DebtId = d.id_debt
           and d.status in ('ED001','ED004','ED007','ED011')
           and d.[type] = 'TIP01'
           and dd.have_tax = 1 
           and d.[year] < 2021
           and d.AgreementId = a.id_agreement),0) * 0.16 iva
     ,0
     , isnull((select sum(dd.amount - dd.on_account)
         from Debt d
            , Debt_Detail dd
          where dd.DebtId = d.id_debt
            and d.status in ('ED001','ED004','ED007','ED011')
            and d.[type] = 'TIP01'
            and dd.code_concept in (1,7,20)
            and d.[year] < 2021
            and d.AgreementId = a.id_agreement),0) Agua
     , isnull((select sum(dd.amount - dd.on_account)
         from Debt d
            , Debt_Detail dd
          where dd.DebtId = d.id_debt
            and d.status in ('ED001','ED004','ED007','ED011')
            and d.[type] = 'TIP01'
            and dd.code_concept in (2,8,21)
            and d.[year] < 2021
            and d.AgreementId = a.id_agreement),0) Drenaje
     , isnull((select sum(dd.amount - dd.on_account)
         from Debt d
            , Debt_Detail dd
          where dd.DebtId = d.id_debt
            and d.status in ('ED001','ED004','ED007','ED011')
            and d.[type] = 'TIP01'
            and dd.code_concept in (3,9,22)
            and d.[year] < 2021
            and d.AgreementId = a.id_agreement),0) Saneamiento
     ,'ED000'
     ,''
     , getdate()
     ,0
     , (select ti.[name] from Type_Intake ti where ti.id_type_intake = a.TypeIntakeId)
     , ' '
     , 0
     , isnull((select sum(d.amount - d.on_account)
          from Debt d 
         where d.AgreementId = a.id_agreement
           and d.status in ('ED001','ED004','ED007','ED011')
           and d.[year] < 2021
           and d.[type] = 'TIP03' ),0) AdeudoNotificaciones
     , isnull((select sum(d.amount - d.on_account)
          from Debt d 
         where d.AgreementId = a.id_agreement
           and d.status in ('ED001','ED004','ED007','ED011')
           and d.[year] < 2021
           and d.[type] = 'TIP05' ),0) AdeudoRecargos     
     , 0
     , isnull((select sum(d.amount - d.on_account)
          from Debt d 
         where d.AgreementId = a.id_agreement
           and d.status in ('ED001','ED004','ED007','ED011')
           and d.[year] < 2021
           and d.[type] = 'TIP03' ),0) AdeudoNotificaciones
     , isnull((select sum(d.amount - d.on_account)
          from Debt d 
         where d.AgreementId = a.id_agreement
           and d.status in ('ED001','ED004','ED007','ED011')
           and d.[year] < 2021
           and d.[type] = 'TIP05' ),0) AdeudoRecargos   
     , isnull((select sum(dd.amount - dd.on_account)
         from Debt d
            , Debt_Detail dd
          where dd.DebtId = d.id_debt
            and d.status in ('ED001','ED004','ED007','ED011')
            and d.[year] < 2021
            and d.[type] = 'TIP01'
            and dd.code_concept in (1,7,20)
            and d.AgreementId = a.id_agreement),0) * 0.40 + 
       isnull((select sum(dd.amount - dd.on_account)
         from Debt d
            , Debt_Detail dd
          where dd.DebtId = d.id_debt
            and d.status in ('ED001','ED004','ED007','ED011')
            and d.[year] < 2021
            and d.[type] = 'TIP01'
            and dd.code_concept in (2,8,21)
            and d.AgreementId = a.id_agreement),0) * 0.40 +
      isnull((select sum(dd.amount - dd.on_account)
         from Debt d
            , Debt_Detail dd
          where dd.DebtId = d.id_debt
            and d.status in ('ED001','ED004','ED007','ED011')
            and d.[year] < 2021
            and d.[type] = 'TIP01'
            and dd.code_concept in (3,9,22)
            and d.AgreementId = a.id_agreement),0) * 0.40           
      , dbo.simulate_period(a.id_agreement,0) * 12             
  from Agreement a
  where a.TypeStateServiceId in (1,3,8,15)
    and isnull((select count(1)
         from partial_payment pp 
        where pp.AgreementId = a.id_agreement
          and pp.status = 'COV01'),0) = 0
    and isnull((select sum(d.amount - d.on_account)
          from Debt d 
         where d.AgreementId = a.id_agreement
           and d.status in ('ED001','ED004','ED007','ED011')
           and d.[year] < 2021
           ),0) > 0
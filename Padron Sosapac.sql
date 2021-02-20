select a.id_agreement 
     , a.account
     , isnull((select sum(d.amount - d.on_account)
          from Debt d 
         where d.AgreementId = a.id_agreement
           and d.status in ('ED001','ED004','ED007','ED011')),0) AdeudoTotal
     , isnull((select sum(d.amount - d.on_account)
          from Debt d 
         where d.AgreementId = a.id_agreement
           and d.status in ('ED001','ED004','ED007','ED011')
           and d.[type] = 'TIP01' ),0) AdeudoServicios
     , isnull((select sum(d.amount - d.on_account)
          from Debt d 
         where d.AgreementId = a.id_agreement
           and d.status in ('ED001','ED004','ED007','ED011')
           and d.[type] = 'TIP02' ),0) AdeudoProductos
     , isnull((select sum(d.amount - d.on_account)
          from Debt d 
         where d.AgreementId = a.id_agreement
           and d.status in ('ED001','ED004','ED007','ED011')
           and d.[type] = 'TIP03' ),0) AdeudoNotificaciones
     , isnull((select sum(d.amount - d.on_account)
          from Debt d 
         where d.AgreementId = a.id_agreement
           and d.status in ('ED001','ED004','ED007','ED011')
           and d.[type] = 'TIP05' ),0) AdeudoRecargos
     , isnull((select count(1)
         from partial_payment pp 
        where pp.AgreementId = a.id_agreement
          and pp.status = 'COV01'),0) Convenio
     , isnull((select case when pp.expiration_date < getdate() then 'Vencido'
                           else 'Vigente'
                           end Estado
         from partial_payment pp 
        where pp.AgreementId = a.id_agreement
          and pp.status = 'COV01'),'') Estado_Convenio          
     , isnull((select sum(ppd.amount)
         from partial_payment pp 
             , partial_payment_detail ppd
        where pp.AgreementId = a.id_agreement
          and ppd.PartialPaymentId = pp.id_partial_payment
          and ppd.status in ('CUT01','CUT02')
          and pp.status = 'COV01'),0) Adeudo_Convenio              
  from Agreement a
  where a.TypeStateServiceId in (1,3,8,15)
/* cancelar recibos especificos */
 
  DECLARE @existe             INT
  DECLARE @status             NVARCHAR(5)
  DECLARE @AgreementId        INT
  DECLARE @id_debt            INT  
  DECLARE @mesfacturable      INT = 9;
  DECLARE @aniofacturable     INT = 2019;
  DECLARE @return_value       int
  DECLARE @error              varchar(200) = '0';
  DECLARE
      MiCursorxx CURSOR FOR
      select d.AgreementId
      , d.status
      , d.id_debt
        from debt d
        where d.status in ('ED001','ED004','ED007','ED011')    
          and d.[year] = 2021
          and d.on_account = 0
         order by 1;

   OPEN MiCursorxx
   FETCH NEXT FROM MiCursorxx   INTO  @AgreementId, @status, @id_debt

   WHILE @@fetch_status = 0
   BEGIN
       
        /*Validamos el estado del recibo */
        /* Sin pago */
        IF @status = 'ED001'
        BEGIN

          PRINT 'Recibo Cancelado.'
          
          /* CAMBIAMOS ESTADO*/
          UPDATE Debt
            SET status = 'ED006'
           WHERE id_debt = @id_debt;
           
				 /*Insertamos estado del recibo en log */
					insert into [dbo].[Debt_Status] ([id_status], [debt_dtatus_date], [user], [DebtId])
					   values ('ED006', getdate(),'MANUAL',@id_debt)           
       
          
        END    
             
      FETCH NEXT FROM MiCursorxx   INTO  @AgreementId, @status, @id_debt
   END

   CLOSE MiCursorxx
   DEALLOCATE MiCursorxx
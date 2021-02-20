/*poner en firme la deuda*/
DECLARE @return_value int;
DECLARE @AgreementId int;
DECLARE @error varchar(200);

 DECLARE
    CursorRegistros CURSOR FOR 
		SELECT distinct [agreement_id]
			FROM [dbo].[debt_annual]
			WHERE debt_id = 0        
            order by 1;
          
   OPEN CursorRegistros
   FETCH NEXT FROM CursorRegistros   INTO  @AgreementId

   WHILE @@fetch_status = 0
   BEGIN

		PRINT @AgreementId;
     
		 /*en firme la deuda*/
		 EXEC	@return_value = [dbo].[billing_debt_annual]
				@id_agreement = @AgreementId,
				@anio_facturar = 2021,
				@error = @error OUTPUT

				
      FETCH NEXT FROM CursorRegistros   INTO  @AgreementId
   END

   CLOSE CursorRegistros
   DEALLOCATE CursorRegistros
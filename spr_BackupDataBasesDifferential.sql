USE [Shop LV-608.db]
GO

/****** Object:  StoredProcedure [dbo].[spr_backupDataBasesDIFFERENTIAL]    Script Date: 7/6/2021 8:15:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- Verify that the stored procedure does not exist. 
DROP PROCEDURE IF EXISTS [dbo].[spr_backupDataBasesDIFFERENTIAL] -- one way
GO

IF OBJECT_ID ( N'[dbo].[spr_backupDataBasesDIFFERENTIAL]', N'P' ) IS NOT NULL   -- another way
    DROP PROCEDURE [dbo].[spr_backupDataBasesDIFFERENTIAL];  
GO 

-- Create a stored procedure that backup dataBases
CREATE PROCEDURE [dbo].[spr_backupDataBasesDIFFERENTIAL] (@dataBase NVARCHAR(250))
AS BEGIN
	SET NOCOUNT ON

	BEGIN TRY

		DECLARE @fileName NVARCHAR(250),
		@path NVARCHAR (250),
		@fileDate NVARCHAR(20)
		SELECT @fileDate = CONVERT(NVARCHAR(20),GETDATE(),112)
		SET @path = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\'
		BEGIN

			SET @fileName = @path + @dataBase + '_' + @fileDate + '.BAK'
			BACKUP DATABASE @dataBase TO DISK = @fileName
			WITH DIFFERENTIAL,
			NAME = N'DIFFERENTIAL Databases Backup'
		END
	END TRY
	BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000)
		SELECT 
        @ErrorMessage = ERROR_MESSAGE()
	END CATCH
END
GO


EXEC [dbo].[spr_backupDataBasesDIFFERENTIAL] 'Shop LV-608.db'
USE [Shop LV-608.db]
GO

/****** Object:  StoredProcedure [dbo].[spr_backupDataBasesDIFFERENTIAL]    Script Date: 7/6/2021 8:15:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- Verify that the stored procedure does not exist. 

IF OBJECT_ID ( N'[dbo].[spr_backupDataBasesDIFFERENTIAL]', N'P' ) IS NOT NULL   -- another way
    DROP PROCEDURE [dbo].[spr_backupDataBasesDIFFERENTIAL];  
GO 

-- Create a stored procedure that backup dataBases
CREATE PROCEDURE [dbo].[spr_backupDataBasesDIFFERENTIAL] (@dataBase NVARCHAR(250))
AS BEGIN
	EXEC spr_LogProcess'[dbo].[spr_backupDataBasesFULL]', 'start', ' '
	SET NOCOUNT ON

	BEGIN TRY

		DECLARE @fileName NVARCHAR(250)
		DECLARE @dataBaseName NVARCHAR(250)
		DECLARE @path NVARCHAR (250)
		DECLARE @fileDate NVARCHAR(20)
		DECLARE @ErrorMessage NVARCHAR(4000)
		
		
		SELECT @fileDate = CONVERT(NVARCHAR(20),GETDATE(),112)
		SET @path = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\'
		
		DECLARE db_cursor CURSOR FOR
		SELECT name
		FROM MASTER.dbo.sysdatabases
		WHERE name NOT IN ('master','model','msdb','tempdb')
		OPEN db_cursor
		FETCH NEXT FROM db_cursor INTO @dataBaseName
		WHILE @@FETCH_STATUS = 0
		BEGIN

			SET @fileName = @path + @dataBaseName + '_' + @fileDate + '.BAK'
			BACKUP DATABASE @dataBaseName TO DISK = @fileName
			WITH DIFFERENTIAL,
			NAME = N'DIFFERENTIAL Databases Backup'
			FETCH NEXT FROM db_cursor INTO @dataBaseName
		END
		CLOSE db_cursor
		DEALLOCATE db_cursor
	END TRY
	BEGIN CATCH
		SELECT 
        @ErrorMessage = ERROR_MESSAGE()
	EXEC spr_LogProcess '[dbo].[spr_backupDataBasesFULL]', 'fatal', ' '
	END CATCH
	EXEC spr_LogProcess '[dbo].[spr_backupDataBasesFULL]', 'stop',' ' 
END
GO



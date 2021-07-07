USE [Shop LV-608.db]
GO

/****** Object:  StoredProcedure [dbo].[backupDataBaseFULL]    Script Date: 7/6/2021 8:15:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- Verify that the stored procedure does not exist. 
DROP PROCEDURE IF EXISTS [dbo].[spr_backupDataBasesFULL] -- one way
GO

IF OBJECT_ID ( N'[dbo].[spr_backupDataBasesFULL]', N'P' ) IS NOT NULL -- another way
    DROP PROCEDURE [dbo].[spr_backupDataBasesFULL];  
GO 

-- Create a stored procedure that backup dataBases
CREATE PROCEDURE [dbo].[spr_backupDataBasesFULL]
AS BEGIN
	SET NOCOUNT ON

	BEGIN TRY

		DECLARE @fileName NVARCHAR(250),
		@dataBaseName NVARCHAR(250),
		@path NVARCHAR (250),
		@fileDate NVARCHAR(20)
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
			WITH NAME = N'FULL Databases Backup'
			FETCH NEXT FROM db_cursor INTO @dataBaseName
		END
		CLOSE db_cursor
		DEALLOCATE db_cursor
	END TRY
	BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(4000)
		SELECT 
        @ErrorMessage = ERROR_MESSAGE()
	END CATCH
END
GO

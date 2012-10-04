IF EXISTS(SELECT * FROM [dbo].[sysobjects]
	WHERE ID = object_id(N'[dbo].[Settings]') 
	AND xtype in ('U', 'P', 'IF', 'V'))
	DROP TABLE Settings;
GO

CREATE TABLE [dbo].[Settings](
	[SettingKey] VARCHAR(256) NOT NULL,
	[SettingValue] NVARCHAR(MAX) NOT NULL,
	[SettingDate] DATETIME NOT NULL,
	CONSTRAINT [PK_Settings] PRIMARY KEY CLUSTERED 
	(
		[SettingKey] ASC
	)	WITH (IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

GO

IF EXISTS(SELECT * FROM [dbo].[sysobjects]
	WHERE ID = object_id(N'[dbo].[SPSettingsSet]') 
	AND xtype in ('U', 'P', 'IF', 'V'))
	DROP PROCEDURE SPSettingsSet;
GO

CREATE PROCEDURE dbo.SPSettingsSet
	@SettingKey varchar(256)
	,@SettingValue nvarchar(max)
AS
IF EXISTS (SELECT * FROM Settings WHERE SettingKey=@SettingKey)
	BEGIN
	UPDATE Settings	
	SET SettingValue = @SettingValue, 
		SettingDate = GETUTCDATE()
	WHERE SettingKey=@SettingKey
	END
ELSE
	BEGIN
	INSERT INTO Settings (SettingKey, SettingValue, SettingDate)
	VALUES (@SettingKey, @SettingValue, GETUTCDATE())
	END
GO

IF EXISTS(SELECT * FROM [dbo].[sysobjects]
	WHERE ID = object_id(N'[dbo].[SPSettingsGet]') 
	AND xtype in ('U', 'P', 'IF', 'V'))
	DROP PROCEDURE SPSettingsGet;
GO

CREATE PROCEDURE dbo.SPSettingsGet
	@SettingKey varchar(256)
AS
SELECT 
	SettingKey, SettingValue, SettingDate
FROM 
	Settings
WHERE
	SettingKey = @SettingKey

GO

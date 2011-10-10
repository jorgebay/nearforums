/****** Object:  StoredProcedure [dbo].[SPTemplatesInsert]    Script Date: 10/10/2011 16:29:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SPTemplatesInsert]
	@TemplateKey varchar(64)
	,@TemplateDescription varchar(256)
	,@TemplateId int OUTPUT
AS
INSERT INTO Templates
(
	TemplateKey
	,TemplateDescription
	,TemplateDate
	,TemplateIsCurrent
)
VALUES
(
	@TemplateKey
	,@TemplateDescription
	,GETUTCDATE()
	,0
)

SELECT @TemplateId = @@IDENTITY
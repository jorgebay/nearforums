ALTER TABLE Users
ADD
	WarningStart datetime null
	, WarningRead bit null
	, SuspendedStart datetime null
	, SuspendedEnd datetime null
	, BannedStart datetime null
	, ModeratorReasonFull nvarchar(max) null
	, ModeratorReason int null
	, ModeratorUserId int null;
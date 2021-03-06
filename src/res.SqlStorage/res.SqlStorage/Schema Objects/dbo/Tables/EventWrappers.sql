﻿CREATE TABLE [dbo].[EventWrappers](
	[EventId] [uniqueidentifier] NOT NULL,
	[StreamId] [nvarchar](50) NOT NULL,
	[ContextName] [nvarchar](50) NOT NULL,
	[Sequence] [bigint] NOT NULL,
	[TimeStamp] [datetime2](3) NOT NULL,
	[EventType] [nvarchar](500) NOT NULL,
	[Body] [nvarchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

CREATE CLUSTERED INDEX [TimeStamp_Clustered] ON [dbo].[EventWrappers]
(
	[TimeStamp] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IX_EventWrappers] ON [dbo].[EventWrappers]
(
	[Sequence] ASC,
	[ContextName] ASC,
	[StreamId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

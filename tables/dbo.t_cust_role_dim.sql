/********************************************************************************************
NAME:    [dbo].[t_cust_role_dim]

PURPOSE: Create the [dbo].[t_cust_role_dim] table

SUPPORT: Kizy Matzenbacher
	     kizymatzen@gmail.com

MODIFICATION LOG:

Ver   Date        Author    Description
---   ----------  -------   -----------------------------------------------------------------
1.0   06/16/2020  KIZYMATZEN   1. Created the table
1.2   06/26/2020  KIZYMATZEN   2. Updated the table

RUNTIME: 

1 min

NOTES: 
(None)

LICENSE: 
This code is covered by the GNU General Public License which guarantees end users
the freedom to run, study, share, and modify the code. This license grants the recipients
of the code the rights of the Free Software Definition. All derivative work can only be
distributed under the same license terms.
********************************************************************************************/

USE [DFNB2]
GO

ALTER TABLE [dbo].[t_role_dim] DROP CONSTRAINT [FK_t_role_dim_t_cust_dim]
GO

/****** Object:  Table [dbo].[t_role_dim]    Script Date: 6/26/2020 10:12:24 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_role_dim]') AND type in (N'U'))
DROP TABLE [dbo].[t_role_dim]
GO

/****** Object:  Table [dbo].[t_role_dim]    Script Date: 6/26/2020 10:12:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[t_role_dim](
	[role_id] [int] IDENTITY(4,6) NOT NULL,
	[role_cust_id] [smallint] NOT NULL,
	[role_pri_id] [smallint] NOT NULL,
	[role_sec_id] [smallint] NULL,
	[cust_id] [smallint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[role_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[t_role_dim]  WITH CHECK ADD  CONSTRAINT [FK_t_role_dim_t_cust_dim] FOREIGN KEY([cust_id])
REFERENCES [dbo].[t_cust_dim] ([cust_id])
GO

ALTER TABLE [dbo].[t_role_dim] CHECK CONSTRAINT [FK_t_role_dim_t_cust_dim]
GO



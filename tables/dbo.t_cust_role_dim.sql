/********************************************************************************************
NAME:    [dbo].[t_cust_role_dim]

PURPOSE: Create the [dbo].[t_cust_role_dim] table

SUPPORT: Kizy Matzenbacher
	     kizymatzen@gmail.com

MODIFICATION LOG:

Ver   Date        Author    Description
---   ----------  -------   -----------------------------------------------------------------
1.0   06/16/2020  KIZYKMATZEN   1. Created the table

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

/****** Object:  Table [dbo].[t_cust_role_dim]    Script Date: 6/16/2020 9:39:32 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_cust_role_dim]') AND type in (N'U'))
DROP TABLE [dbo].[t_cust_role_dim]
GO

/****** Object:  Table [dbo].[t_cust_role_dim]    Script Date: 6/16/2020 9:39:32 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[t_cust_role_dim](
	[cust_role_id] [smallint] IDENTITY(1,1) NOT NULL,
	[role_cust_id] [smallint] NOT NULL,
	[pri_cust_id] [smallint] NOT NULL,
	[sec_cust_id] [nchar](10) NULL,
 CONSTRAINT [PK_t_acct_cust_role] PRIMARY KEY CLUSTERED 
(
	[cust_role_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO



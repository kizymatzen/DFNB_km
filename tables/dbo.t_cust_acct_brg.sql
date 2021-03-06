/********************************************************************************************
NAME:    [dbo].[t_cust_acct_brg]

PURPOSE: Create the [dbo].[t_cust_acct_brg] table

SUPPORT: Kizy Matzenbacher
	     kizymatzen@gmail.com

MODIFICATION LOG:

Ver   Date        Author    Description
---   ----------  -------   -----------------------------------------------------------------
1.0   06/15/2020  KIZYMATZEN   1. Created the table
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

ALTER TABLE [dbo].[t_cust_acct_brg] DROP CONSTRAINT [FK_t_cust_acct_brg_t_cust_dim]
GO

ALTER TABLE [dbo].[t_cust_acct_brg] DROP CONSTRAINT [FK_t_cust_acct_brg_t_acct_dim]
GO

/****** Object:  Table [dbo].[t_cust_acct_brg]    Script Date: 6/26/2020 9:52:19 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_cust_acct_brg]') AND type in (N'U'))
DROP TABLE [dbo].[t_cust_acct_brg]
GO

/****** Object:  Table [dbo].[t_cust_acct_brg]    Script Date: 6/26/2020 9:52:19 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[t_cust_acct_brg](
	[cust_acct_id] [int] IDENTITY(10,5) NOT NULL,
	[cust_since_date] [date] NOT NULL,
	[cust_pri_branch_dist] [decimal](7, 2) NOT NULL,
	[cust_id] [smallint] NOT NULL,
	[acct_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[cust_acct_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[t_cust_acct_brg]  WITH CHECK ADD  CONSTRAINT [FK_t_cust_acct_brg_t_acct_dim] FOREIGN KEY([acct_id])
REFERENCES [dbo].[t_acct_dim] ([acct_id])
GO

ALTER TABLE [dbo].[t_cust_acct_brg] CHECK CONSTRAINT [FK_t_cust_acct_brg_t_acct_dim]
GO

ALTER TABLE [dbo].[t_cust_acct_brg]  WITH CHECK ADD  CONSTRAINT [FK_t_cust_acct_brg_t_cust_dim] FOREIGN KEY([cust_id])
REFERENCES [dbo].[t_cust_dim] ([cust_id])
GO

ALTER TABLE [dbo].[t_cust_acct_brg] CHECK CONSTRAINT [FK_t_cust_acct_brg_t_cust_dim]
GO


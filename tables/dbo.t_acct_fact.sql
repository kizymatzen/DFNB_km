/********************************************************************************************
NAME:    [dbo].[t_acct_fact]

PURPOSE: Create the [dbo].[t_acct_fact] table

SUPPORT: Kizy Matzenbacher
	     kizymatzen@gmail.com

MODIFICATION LOG:

Ver   Date        Author       Description
---   ----------  -------      -----------------------------------------------------------------
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

ALTER TABLE [dbo].[t_acct_fact] DROP CONSTRAINT [FK_t_acct_fact_t_acct_dim]
GO

/****** Object:  Table [dbo].[t_acct_fact]    Script Date: 6/26/2020 9:36:34 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_acct_fact]') AND type in (N'U'))
DROP TABLE [dbo].[t_acct_fact]
GO

/****** Object:  Table [dbo].[t_acct_fact]    Script Date: 6/26/2020 9:36:34 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[t_acct_fact](
	[acct_fact_id] [int] IDENTITY(4,4) NOT NULL,
	[acct_id] [int] NOT NULL,
	[acct_as_of_date] [date] NOT NULL,
	[acct_cur_bal] [decimal](20, 4) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[acct_fact_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[t_acct_fact]  WITH CHECK ADD  CONSTRAINT [FK_t_acct_fact_t_acct_dim] FOREIGN KEY([acct_id])
REFERENCES [dbo].[t_acct_dim] ([acct_id])
GO

ALTER TABLE [dbo].[t_acct_fact] CHECK CONSTRAINT [FK_t_acct_fact_t_acct_dim]
GO


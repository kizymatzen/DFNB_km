/********************************************************************************************
NAME:    [dbo].[t_rt_tran_fact]
PURPOSE: Create the [dbo].[t_rt_tran_fact] table

SUPPORT: Kizy Matzenbacher
	     kizymatzen@gmail.com

MODIFICATION LOG:
Ver   Date        Author    Description
---   ----------  -------   -----------------------------------------------------------------
1.0   06/26/2020  KIZYMATZEN   1. Created the table

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

ALTER TABLE [dbo].[t_rt_tran_fact] DROP CONSTRAINT [FK_t_rt_tran_fact_t_acct_dim]
GO

/****** Object:  Table [dbo].[t_rt_tran_fact]    Script Date: 6/26/2020 10:14:38 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_rt_tran_fact]') AND type in (N'U'))
DROP TABLE [dbo].[t_rt_tran_fact]
GO

/****** Object:  Table [dbo].[t_rt_tran_fact]    Script Date: 6/26/2020 10:14:38 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[t_rt_tran_fact](
	[tran_fact_id] [int] IDENTITY(3,2) NOT NULL,
	[tran_date] [date] NOT NULL,
	[tran_time] [time](7) NOT NULL,
	[tran_amt] [int] NOT NULL,
	[tran_fee_amt] [decimal](15, 3) NOT NULL,
	[acct_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[tran_fact_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[t_rt_tran_fact]  WITH CHECK ADD  CONSTRAINT [FK_t_rt_tran_fact_t_acct_dim] FOREIGN KEY([acct_id])
REFERENCES [dbo].[t_acct_dim] ([acct_id])
GO

ALTER TABLE [dbo].[t_rt_tran_fact] CHECK CONSTRAINT [FK_t_rt_tran_fact_t_acct_dim]
GO



/********************************************************************************************
NAME:    [dbo].[t_loan_amt_fact]

PURPOSE: Create the [dbo].[t_loan_amt_fact] table

SUPPORT: Kizy Matzenbacher
	     kizymatzen@gmail.com

MODIFICATION LOG:

Ver   Date        Author    Description
---   ----------  -------   -----------------------------------------------------------------
1.0   07/14/2020  KIZYMATZEN   1. Created the table

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

ALTER TABLE [dbo].[t_loan_amt_fact] DROP CONSTRAINT [FK_t_loan_amt_fact_t_acct_dim]
GO

/****** Object:  Table [dbo].[t_loan_amt_fact]    Script Date: 7/19/2020 2:56:10 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_loan_amt_fact]') AND type in (N'U'))
DROP TABLE [dbo].[t_loan_amt_fact]
GO

/****** Object:  Table [dbo].[t_loan_amt_fact]    Script Date: 7/19/2020 2:56:10 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[t_loan_amt_fact](
	[loan_amt_id] [int] IDENTITY(1,2) NOT NULL,
	[acct_id] [int] NOT NULL,
	[branch_id] [smallint] NOT NULL,
	[loan_curr_amt] [decimal](21, 4) NULL,
	[loan_int_amt]  AS ((([loan_curr_amt]*(0.03))*(12))*[loan_period_yr]),
	[loan_ttl]  AS ([loan_curr_amt]+(([loan_curr_amt]*(0.03))*(12))*[loan_period_yr]),
	[loan_open_date] [date] NOT NULL,
	[loan_period_yr] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[loan_amt_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[t_loan_amt_fact]  WITH CHECK ADD  CONSTRAINT [FK_t_loan_amt_fact_t_acct_dim] FOREIGN KEY([acct_id])
REFERENCES [dbo].[t_acct_dim] ([acct_id])
GO

ALTER TABLE [dbo].[t_loan_amt_fact] CHECK CONSTRAINT [FK_t_loan_amt_fact_t_acct_dim]
GO



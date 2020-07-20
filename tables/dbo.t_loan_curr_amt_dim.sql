/********************************************************************************************
NAME:    [dbo].[t_loan_curr_amt_dim]

PURPOSE: Create the [dbo].[t_loan_curr_amt_dim] table

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

ALTER TABLE [dbo].[t_loan_curr_amt_dim] DROP CONSTRAINT [FK_t_loan_curr_amt_dim_t_acct_dim]
GO

/****** Object:  Table [dbo].[t_loan_curr_amt_dim]    Script Date: 7/19/2020 2:56:27 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_loan_curr_amt_dim]') AND type in (N'U'))
DROP TABLE [dbo].[t_loan_curr_amt_dim]
GO

/****** Object:  Table [dbo].[t_loan_curr_amt_dim]    Script Date: 7/19/2020 2:56:27 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[t_loan_curr_amt_dim](
	[loan_curr_amt_id] [int] IDENTITY(1,3) NOT NULL,
	[acct_id] [int] NOT NULL,
	[loan_amt] [decimal](20, 4) NOT NULL,
	[loan_payment] [decimal](20, 4) NULL,
	[loan_curr_amt]  AS (case when [loan_payment] IS NULL then [loan_amt] else [loan_amt]-[loan_payment] end),
PRIMARY KEY CLUSTERED 
(
	[loan_curr_amt_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[t_loan_curr_amt_dim]  WITH CHECK ADD  CONSTRAINT [FK_t_loan_curr_amt_dim_t_acct_dim] FOREIGN KEY([acct_id])
REFERENCES [dbo].[t_acct_dim] ([acct_id])
GO

ALTER TABLE [dbo].[t_loan_curr_amt_dim] CHECK CONSTRAINT [FK_t_loan_curr_amt_dim_t_acct_dim]
GO
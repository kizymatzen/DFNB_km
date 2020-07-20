/********************************************************************************************
NAME:    [dbo].[t_loan_brg]

PURPOSE: Create the [dbo].[t_loan_brg] table

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

ALTER TABLE [dbo].[t_loan_brg] DROP CONSTRAINT [FK_t_loan_brg_t_loan_period_dim]
GO

ALTER TABLE [dbo].[t_loan_brg] DROP CONSTRAINT [FK_t_loan_brg_t_loan_curr_amt_dim]
GO

ALTER TABLE [dbo].[t_loan_brg] DROP CONSTRAINT [FK_t_loan_brg_t_loan_amt_fact]
GO

/****** Object:  Table [dbo].[t_loan_brg]    Script Date: 7/19/2020 2:56:20 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_loan_brg]') AND type in (N'U'))
DROP TABLE [dbo].[t_loan_brg]
GO

/****** Object:  Table [dbo].[t_loan_brg]    Script Date: 7/19/2020 2:56:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[t_loan_brg](
	[loan_brg_id] [int] IDENTITY(1,2) NOT NULL,
	[loan_curr_amt_id] [int] NOT NULL,
	[loan_amt_id] [int] NOT NULL,
	[loan_period_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[loan_brg_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[t_loan_brg]  WITH CHECK ADD  CONSTRAINT [FK_t_loan_brg_t_loan_amt_fact] FOREIGN KEY([loan_amt_id])
REFERENCES [dbo].[t_loan_amt_fact] ([loan_amt_id])
GO

ALTER TABLE [dbo].[t_loan_brg] CHECK CONSTRAINT [FK_t_loan_brg_t_loan_amt_fact]
GO

ALTER TABLE [dbo].[t_loan_brg]  WITH CHECK ADD  CONSTRAINT [FK_t_loan_brg_t_loan_curr_amt_dim] FOREIGN KEY([loan_curr_amt_id])
REFERENCES [dbo].[t_loan_curr_amt_dim] ([loan_curr_amt_id])
GO

ALTER TABLE [dbo].[t_loan_brg] CHECK CONSTRAINT [FK_t_loan_brg_t_loan_curr_amt_dim]
GO

ALTER TABLE [dbo].[t_loan_brg]  WITH CHECK ADD  CONSTRAINT [FK_t_loan_brg_t_loan_period_dim] FOREIGN KEY([loan_period_id])
REFERENCES [dbo].[t_loan_period_dim] ([loan_period_id])
GO

ALTER TABLE [dbo].[t_loan_brg] CHECK CONSTRAINT [FK_t_loan_brg_t_loan_period_dim]
GO
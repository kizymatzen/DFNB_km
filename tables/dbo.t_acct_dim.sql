/********************************************************************************************
NAME:    [dbo].[t_acct_dim]

PURPOSE: Create the [dbo].[t_acct_dim] table

SUPPORT: Kizy Matzenbacher
	     kizymatzen@gmail.com

MODIFICATION LOG:

Ver   Date        Author    Description
---   ----------  -------   -----------------------------------------------------------------
1.0   06/12/2020  KIZYKMATZEN   1. Created the table

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

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[t_acct_dim](
	[acct_id] [int] NOT NULL,
	[branch_id] [smallint] NOT NULL,
	[loan_amt] [decimal](20, 4) NOT NULL,
	[open_date] [date] NOT NULL,
	[close_date] [date] NOT NULL,
 CONSTRAINT [PK_t_acct] PRIMARY KEY CLUSTERED 
(
	[acct_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[t_acct_dim]  WITH CHECK ADD  CONSTRAINT [FK_t_acct_dim_t_branch_dim] FOREIGN KEY([branch_id])
REFERENCES [dbo].[t_branch_dim] ([branch_id])
GO

ALTER TABLE [dbo].[t_acct_dim] CHECK CONSTRAINT [FK_t_acct_dim_t_branch_dim]
GO


/********************************************************************************************
NAME:    [dbo].[t_cust_acct_brg]

PURPOSE: Create the [dbo].[t_cust_acct_brg] table

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

CREATE TABLE [dbo].[t_cust_acct_brg](
	[cust_acct_id] [int] IDENTITY(1,1) NOT NULL,
	[cust_dim_id] [smallint] NULL,
	[cust_add_id] [int] NOT NULL,
	[cust_since_date] [date] NOT NULL,
	[acct_id] [int] NOT NULL,
	[cust_pri_branch_dist] [decimal](7, 2) NOT NULL,
 CONSTRAINT [PK_t_cust_acct_brg] PRIMARY KEY CLUSTERED 
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



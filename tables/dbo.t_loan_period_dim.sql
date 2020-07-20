/********************************************************************************************
NAME:    [dbo].[t_loan_period_dim]

PURPOSE: Create the [dbo].[t_loan_period_dim] table

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

/****** Object:  Table [dbo].[t_loan_period_dim]    Script Date: 7/19/2020 2:56:36 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_loan_period_dim]') AND type in (N'U'))
DROP TABLE [dbo].[t_loan_period_dim]
GO

/****** Object:  Table [dbo].[t_loan_period_dim]    Script Date: 7/19/2020 2:56:36 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[t_loan_period_dim](
	[loan_period_id] [int] IDENTITY(1,3) NOT NULL,
	[loan_open_date] [date] NOT NULL,
	[loan_period_yr]  AS (case when [loan_open_date]=NULL then (0) else datediff(year,[loan_open_date],getdate()) end),
PRIMARY KEY CLUSTERED 
(
	[loan_period_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

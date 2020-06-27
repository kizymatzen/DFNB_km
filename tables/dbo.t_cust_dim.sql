/********************************************************************************************
NAME:    [dbo].[t_cust_dim]

PURPOSE: Create the [dbo].[t_cust_dim] table

SUPPORT: Kizy Matzenbacher
	     kizymatzen@gmail.com

MODIFICATION LOG:

Ver   Date        Author    Description
---   ----------  -------   -----------------------------------------------------------------
1.0   06/16/2020  KIZYMATZEN   1. Created the table
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

ALTER TABLE [dbo].[t_cust_dim] DROP CONSTRAINT [FK_t_cust_dim_t_cust_add_dim]
GO

/****** Object:  Table [dbo].[t_cust_dim]    Script Date: 6/26/2020 9:57:15 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_cust_dim]') AND type in (N'U'))
DROP TABLE [dbo].[t_cust_dim]
GO

/****** Object:  Table [dbo].[t_cust_dim]    Script Date: 6/26/2020 9:57:15 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[t_cust_dim](
	[cust_id] [smallint] NOT NULL,
	[cust_first_name] [varchar](100) NOT NULL,
	[cust_last_name] [varchar](100) NOT NULL,
	[cust_birth_date] [date] NOT NULL,
	[cust_gender] [varchar](1) NOT NULL,
	[cust_add_id] [int] NOT NULL,
	[cust_pri_branch_id] [smallint] NOT NULL,
 CONSTRAINT [PK__t_cust_d__A1B71F9013E2E872] PRIMARY KEY CLUSTERED 
(
	[cust_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[t_cust_dim]  WITH CHECK ADD  CONSTRAINT [FK_t_cust_dim_t_cust_add_dim] FOREIGN KEY([cust_add_id])
REFERENCES [dbo].[t_cust_add_dim] ([cust_add_id])
GO

ALTER TABLE [dbo].[t_cust_dim] CHECK CONSTRAINT [FK_t_cust_dim_t_cust_add_dim]
GO
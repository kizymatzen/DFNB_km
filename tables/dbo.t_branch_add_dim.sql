/********************************************************************************************
NAME:    [dbo].[t_branch_add_dim]

PURPOSE: Create the [dbo].[t_branch_add_dim] table

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

ALTER TABLE [dbo].[t_branch_add_dim] DROP CONSTRAINT [FK_t_branch_add_dim_t_branch_dim]
GO

/****** Object:  Table [dbo].[t_branch_add_dim]    Script Date: 6/26/2020 9:45:33 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_branch_add_dim]') AND type in (N'U'))
DROP TABLE [dbo].[t_branch_add_dim]
GO

/****** Object:  Table [dbo].[t_branch_add_dim]    Script Date: 6/26/2020 9:45:33 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[t_branch_add_dim](
	[branch_add_id] [int] NOT NULL,
	[branch_add_lat] [decimal](16, 12) NOT NULL,
	[branch_add_lon] [decimal](16, 12) NOT NULL,
	[branch_code] [varchar](5) NOT NULL,
	[branch_add_type] [varchar](1) NOT NULL,
	[branch_id] [smallint] NOT NULL,
 CONSTRAINT [PK_t_branch_add] PRIMARY KEY CLUSTERED 
(
	[branch_add_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[t_branch_add_dim]  WITH CHECK ADD  CONSTRAINT [FK_t_branch_add_dim_t_branch_dim] FOREIGN KEY([branch_id])
REFERENCES [dbo].[t_branch_dim] ([branch_id])
GO

ALTER TABLE [dbo].[t_branch_add_dim] CHECK CONSTRAINT [FK_t_branch_add_dim_t_branch_dim]
GO



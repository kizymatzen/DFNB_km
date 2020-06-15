/********************************************************************************************
NAME:    [dbo].[t_branch_dim]

PURPOSE: Create the [dbo].[t_branch_dim] table

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

CREATE TABLE [dbo].[t_branch_dim](
	[branch_id] [smallint] NOT NULL,
	[branch_code] [varchar](5) NOT NULL,
	[branch_desc] [varchar](100) NOT NULL,
	[branch_add_id] [int] NOT NULL,
	[region_id] [int] NOT NULL,
	[area_id] [int] NOT NULL,
 CONSTRAINT [PK_t_branch_dim] PRIMARY KEY CLUSTERED 
(
	[branch_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[t_branch_dim]  WITH CHECK ADD  CONSTRAINT [FK_t_branch_dim_t_area] FOREIGN KEY([area_id])
REFERENCES [dbo].[t_area_dim] ([area_id])
GO

ALTER TABLE [dbo].[t_branch_dim] CHECK CONSTRAINT [FK_t_branch_dim_t_area]
GO

ALTER TABLE [dbo].[t_branch_dim]  WITH CHECK ADD  CONSTRAINT [FK_t_branch_dim_t_region] FOREIGN KEY([region_id])
REFERENCES [dbo].[t_region_dim] ([region_id])
GO

ALTER TABLE [dbo].[t_branch_dim] CHECK CONSTRAINT [FK_t_branch_dim_t_region]
GO



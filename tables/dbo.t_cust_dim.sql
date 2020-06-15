/********************************************************************************************
NAME:    [dbo].[t_cust_dim]

PURPOSE: Create the [dbo].[t_cust_dim] table

SUPPORT: Kizy Matzenbacher
	     kizymatzen@gmail.com

MODIFICATION LOG:

Ver   Date        Author    Description
---   ----------  -------   -----------------------------------------------------------------
1.0   06/11/2020  KIZYKMATZEN   1. Created the table

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

CREATE TABLE [dbo].[t_cust_dim](
	[cust_dim_id] [smallint] IDENTITY(1,1) NOT NULL,
	[cust_id] [smallint] NOT NULL,
	[first_name] [varchar](100) NOT NULL,
	[last_name] [varchar](100) NOT NULL,
	[birth_date] [date] NOT NULL,
	[gender] [varchar](1) NOT NULL,
	[prod_dim_id] [smallint] NULL,
	[cust_add_id] [int] NOT NULL,
	[pri_branch_id] [smallint] NOT NULL,
 CONSTRAINT [PK_t_cust_dim] PRIMARY KEY CLUSTERED 
(
	[cust_dim_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[t_cust_dim]  WITH CHECK ADD  CONSTRAINT [FK_t_cust_dim_t_cust_add] FOREIGN KEY([cust_add_id])
REFERENCES [dbo].[t_cust_add_dim] ([cust_add_id])
GO

ALTER TABLE [dbo].[t_cust_dim] CHECK CONSTRAINT [FK_t_cust_dim_t_cust_add]
GO

ALTER TABLE [dbo].[t_cust_dim]  WITH CHECK ADD  CONSTRAINT [FK_t_cust_dim_t_prod_dim] FOREIGN KEY([prod_dim_id])
REFERENCES [dbo].[t_prod_dim] ([prod_dim_id])
GO

ALTER TABLE [dbo].[t_cust_dim] CHECK CONSTRAINT [FK_t_cust_dim_t_prod_dim]
GO



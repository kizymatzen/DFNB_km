/********************************************************************************************
NAME:    [dbo].[t_cust_prod_brg]
PURPOSE: Create the [dbo].[t_cust_prod_brg] table

SUPPORT: Kizy Matzenbacher
         kizymatzen@gmail.com

MODIFICATION LOG:
Ver   Date        Author    Description
---   ----------  -------   -----------------------------------------------------------------
1.0   06/26/2020  KIZYMATZEN   1. Created the table


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

ALTER TABLE [dbo].[t_cust_prod_brg] DROP CONSTRAINT [FK_t_cust_prod_brg_t_prod_dim]
GO

ALTER TABLE [dbo].[t_cust_prod_brg] DROP CONSTRAINT [FK_t_cust_prod_brg_t_cust_dim]
GO

/****** Object:  Table [dbo].[t_cust_prod_brg]    Script Date: 6/26/2020 9:59:35 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_cust_prod_brg]') AND type in (N'U'))
DROP TABLE [dbo].[t_cust_prod_brg]
GO

/****** Object:  Table [dbo].[t_cust_prod_brg]    Script Date: 6/26/2020 9:59:35 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[t_cust_prod_brg](
	[cust_prod_brg] [int] IDENTITY(1,8) NOT NULL,
	[cust_id] [smallint] NOT NULL,
	[prod_id] [smallint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[cust_prod_brg] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[t_cust_prod_brg]  WITH CHECK ADD  CONSTRAINT [FK_t_cust_prod_brg_t_cust_dim] FOREIGN KEY([cust_id])
REFERENCES [dbo].[t_cust_dim] ([cust_id])
GO

ALTER TABLE [dbo].[t_cust_prod_brg] CHECK CONSTRAINT [FK_t_cust_prod_brg_t_cust_dim]
GO

ALTER TABLE [dbo].[t_cust_prod_brg]  WITH CHECK ADD  CONSTRAINT [FK_t_cust_prod_brg_t_prod_dim] FOREIGN KEY([prod_id])
REFERENCES [dbo].[t_prod_dim] ([prod_id])
GO

ALTER TABLE [dbo].[t_cust_prod_brg] CHECK CONSTRAINT [FK_t_cust_prod_brg_t_prod_dim]
GO



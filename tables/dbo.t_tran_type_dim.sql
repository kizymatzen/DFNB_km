/********************************************************************************************
NAME:    [dbo].[t_tran_type_dim]
PURPOSE: Create the [dbo].[t_tran_type_dim] table

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

ALTER TABLE [dbo].[t_tran_type_dim] DROP CONSTRAINT [FK_t_tran_type_dim_t_rt_tran_fact]
GO

/****** Object:  Table [dbo].[t_tran_type_dim]    Script Date: 6/26/2020 10:14:48 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[t_tran_type_dim]') AND type in (N'U'))
DROP TABLE [dbo].[t_tran_type_dim]
GO

/****** Object:  Table [dbo].[t_tran_type_dim]    Script Date: 6/26/2020 10:14:48 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[t_tran_type_dim](
	[tran_dim_id] [int] IDENTITY(3,9) NOT NULL,
	[tran_type_id] [smallint] NOT NULL,
	[tran_type_code] [varchar](5) NOT NULL,
	[tran_type_desc] [varchar](100) NOT NULL,
	[tran_fee_prct] [decimal](4, 3) NOT NULL,
	[cur_cust_req_ind] [varchar](1) NOT NULL,
	[tran_fact_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[tran_dim_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[t_tran_type_dim]  WITH CHECK ADD  CONSTRAINT [FK_t_tran_type_dim_t_rt_tran_fact] FOREIGN KEY([tran_fact_id])
REFERENCES [dbo].[t_rt_tran_fact] ([tran_fact_id])
GO

ALTER TABLE [dbo].[t_tran_type_dim] CHECK CONSTRAINT [FK_t_tran_type_dim_t_rt_tran_fact]
GO



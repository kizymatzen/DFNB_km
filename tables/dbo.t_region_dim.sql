/********************************************************************************************
NAME:    [dbo].[t_region_dim]
PURPOSE: Create the [dbo].[t_region_dim] table
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

/****** Object:  Table [dbo].[t_region_dim]    Script Date: 6/11/2020 8:45:06 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[t_region_dim](
	[region_id] [int] NOT NULL,
	[region_name] [char](100) NULL,
	[region_desc] [char](200) NULL,
 CONSTRAINT [PK_t_region] PRIMARY KEY CLUSTERED 
(
	[region_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO



/********************************************************************************************
NAME:    DFNB2
PURPOSE: Create a schema running script for generating the complete database

SUPPORT: Kizy Matzenbacher
         kizymatzen@gmail.com

MODIFICATION LOG:
Ver   Date        Author    Description
---   ----------  -------   -----------------------------------------------------------------
1.0   06/16/2020  KIZYMATZEN   1. Created the script

RUNTIME: 
2 min

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
/****** Object:  Table [dbo].[t_acct_dim]    Script Date: 6/16/2020 3:38:22 PM ******/
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
/****** Object:  Table [dbo].[t_acct_fact]    Script Date: 6/16/2020 3:38:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_acct_fact](
	[acct_fact_id] [int] IDENTITY(1,1) NOT NULL,
	[acct_id] [int] NOT NULL,
	[as_of_date] [date] NOT NULL,
	[cur_bal] [decimal](20, 4) NOT NULL,
 CONSTRAINT [PK_t_acct_fact] PRIMARY KEY CLUSTERED 
(
	[acct_fact_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[v_years_comp]    Script Date: 6/16/2020 3:38:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_years_comp] AS
SELECT YEAR(f.as_of_date) AS Year
	,COUNT( d.acct_id) AS 'Count of Accounts'
	,SUM(d.loan_amt) AS 'Loan Amount'
	,SUM(f.cur_bal) AS 'Current Balance'
FROM t_acct_dim AS d
INNER JOIN t_acct_fact AS f
ON d.acct_id = f.acct_id
WHERE YEAR(as_of_date) >= 2016 AND YEAR(as_of_date) <= 2018
GROUP BY YEAR(as_of_date)
GO
/****** Object:  Table [dbo].[t_cust_acct_brg]    Script Date: 6/16/2020 3:38:23 PM ******/
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
/****** Object:  View [dbo].[v_acct_by_year]    Script Date: 6/16/2020 3:38:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_acct_by_year]
AS
SELECT        TOP (100) PERCENT COUNT(c.acct_id) AS [Number of Accounts], YEAR(ca.cust_since_date) AS [Customer Since Year]
FROM            dbo.t_cust_acct_brg AS ca INNER JOIN
                         dbo.t_acct_dim AS c ON ca.acct_id = c.acct_id
GROUP BY YEAR(ca.cust_since_date)
ORDER BY [Customer Since Year]
GO
/****** Object:  View [dbo].[v_time_avg_acct_open]    Script Date: 6/16/2020 3:38:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_time_avg_acct_open]
AS
     SELECT AVG(DATEDIFF(YEAR, open_date, close_date)) AS 'Time Avg Actt Open '
          , COUNT(close_date) AS 'Accounts Closed'
          , YEAR(close_date) AS Year
       FROM dbo.t_acct_dim AS tad
      WHERE close_date <> '9999-12-31'
      GROUP BY YEAR(close_date);
GO
/****** Object:  View [dbo].[v_acct_closed]    Script Date: 6/16/2020 3:38:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_acct_closed] AS
SELECT COUNT(close_date) AS 'Acct Closed'
, YEAR(close_date) AS Year
FROM dbo.t_acct_dim 
WHERE close_date <> '9999-12-31'
GROUP BY YEAR(close_date)
GO
/****** Object:  View [dbo].[v_acct_opened]    Script Date: 6/16/2020 3:38:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_acct_opened] AS
SELECT COUNT(open_date) AS 'Act Opened'
,YEAR(open_date) AS Year
FROM dbo.t_acct_dim tad
GROUP BY YEAR(open_date)
GO
/****** Object:  Table [dbo].[t_cust_dim]    Script Date: 6/16/2020 3:38:23 PM ******/
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
/****** Object:  View [dbo].[v_acct_gender_bal]    Script Date: 6/16/2020 3:38:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[v_acct_gender_bal]
AS
     SELECT DISTINCT 
            taf.acct_id AS 'Account ID'
          , c.gender
          , DATEDIFF(YY, birth_date, GETDATE()) AS Age
          , YEAR(ca.cust_since_date) AS 'Customer Since Year'
          , taf.cur_bal AS 'Current Balance'
       FROM t_cust_dim AS c
            INNER JOIN
            t_cust_acct_brg AS ca ON c.cust_dim_id = ca.cust_dim_id
            INNER JOIN
            dbo.t_acct_fact AS taf ON ca.acct_id = taf.acct_id
      WHERE YEAR(ca.cust_since_date) >= 2016
            AND YEAR(ca.cust_since_date) < 2019;
GO
/****** Object:  Table [dbo].[t_area_dim]    Script Date: 6/16/2020 3:38:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_area_dim](
	[area_id] [int] NOT NULL,
	[area_name] [char](100) NULL,
	[area_desc] [char](200) NULL,
 CONSTRAINT [PK_t_area] PRIMARY KEY CLUSTERED 
(
	[area_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[t_branch_add_dim]    Script Date: 6/16/2020 3:38:23 PM ******/
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
/****** Object:  Table [dbo].[t_branch_dim]    Script Date: 6/16/2020 3:38:23 PM ******/
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
/****** Object:  Table [dbo].[t_cust_add_dim]    Script Date: 6/16/2020 3:38:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_cust_add_dim](
	[cust_add_id] [int] NOT NULL,
	[cust_add_lat] [decimal](16, 12) NOT NULL,
	[cust_add_lon] [decimal](16, 12) NOT NULL,
	[cust_add_type] [varchar](1) NOT NULL,
 CONSTRAINT [PK_t_cust_add] PRIMARY KEY CLUSTERED 
(
	[cust_add_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[t_cust_role_dim]    Script Date: 6/16/2020 3:38:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_cust_role_dim](
	[cust_role_id] [smallint] IDENTITY(1,1) NOT NULL,
	[role_cust_id] [smallint] NOT NULL,
	[pri_cust_id] [smallint] NOT NULL,
	[sec_cust_id] [nchar](10) NULL,
 CONSTRAINT [PK_t_acct_cust_role] PRIMARY KEY CLUSTERED 
(
	[cust_role_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[t_prod_dim]    Script Date: 6/16/2020 3:38:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_prod_dim](
	[prod_dim_id] [smallint] IDENTITY(1,1) NOT NULL,
	[prod_id] [smallint] NOT NULL,
	[cust_id] [smallint] NOT NULL,
 CONSTRAINT [PK_t_prod_dim] PRIMARY KEY CLUSTERED 
(
	[prod_dim_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[t_region_dim]    Script Date: 6/16/2020 3:38:23 PM ******/
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
ALTER TABLE [dbo].[t_acct_dim]  WITH CHECK ADD  CONSTRAINT [FK_t_acct_dim_t_branch_dim] FOREIGN KEY([branch_id])
REFERENCES [dbo].[t_branch_dim] ([branch_id])
GO
ALTER TABLE [dbo].[t_acct_dim] CHECK CONSTRAINT [FK_t_acct_dim_t_branch_dim]
GO
ALTER TABLE [dbo].[t_acct_fact]  WITH CHECK ADD  CONSTRAINT [FK_t_acct_fact_t_acct_dim] FOREIGN KEY([acct_id])
REFERENCES [dbo].[t_acct_dim] ([acct_id])
GO
ALTER TABLE [dbo].[t_acct_fact] CHECK CONSTRAINT [FK_t_acct_fact_t_acct_dim]
GO
ALTER TABLE [dbo].[t_branch_add_dim]  WITH CHECK ADD  CONSTRAINT [FK_t_branch_add_t_branch_dim] FOREIGN KEY([branch_id])
REFERENCES [dbo].[t_branch_dim] ([branch_id])
GO
ALTER TABLE [dbo].[t_branch_add_dim] CHECK CONSTRAINT [FK_t_branch_add_t_branch_dim]
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
ALTER TABLE [dbo].[t_cust_acct_brg]  WITH CHECK ADD  CONSTRAINT [FK_t_cust_acct_brg_t_acct_dim] FOREIGN KEY([acct_id])
REFERENCES [dbo].[t_acct_dim] ([acct_id])
GO
ALTER TABLE [dbo].[t_cust_acct_brg] CHECK CONSTRAINT [FK_t_cust_acct_brg_t_acct_dim]
GO
ALTER TABLE [dbo].[t_cust_acct_brg]  WITH CHECK ADD  CONSTRAINT [FK_t_cust_acct_brg_t_cust_dim] FOREIGN KEY([cust_dim_id])
REFERENCES [dbo].[t_cust_dim] ([cust_dim_id])
GO
ALTER TABLE [dbo].[t_cust_acct_brg] CHECK CONSTRAINT [FK_t_cust_acct_brg_t_cust_dim]
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
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ca"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 250
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 224
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_acct_by_year'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'v_acct_by_year'
GO

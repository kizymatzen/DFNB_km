/********************************************************************************************
NAME:    DFNB2
PURPOSE: Create a schema running script for generating the complete database

SUPPORT: Kizy Matzenbacher
         kizymatzen@gmail.com

MODIFICATION LOG:
Ver   Date        Author    Description
---   ----------  -------   -----------------------------------------------------------------
1.0   07/20/2020  KIZYMATZEN   1. Created the script
1.2   07/25/2020  KIZYMATZEN   2. Updated the script


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
/****** Object:  Table [dbo].[t_loan_amt_fact]    Script Date: 7/25/2020 1:38:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_loan_amt_fact](
	[loan_amt_id] [int] IDENTITY(1,2) NOT NULL,
	[acct_id] [int] NOT NULL,
	[branch_id] [smallint] NOT NULL,
	[loan_curr_amt] [decimal](21, 4) NULL,
	[loan_int_amt]  AS (([loan_curr_amt]*((0.03)/(12)))*[loan_period_yr]),
	[loan_ttl]  AS ([loan_curr_amt]+([loan_curr_amt]*((0.03)/(12)))*[loan_period_yr]),
	[loan_open_date] [date] NOT NULL,
	[loan_period_yr] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[loan_amt_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[v_ttl_loan_yr]    Script Date: 7/25/2020 1:38:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_ttl_loan_yr] AS
SELECT YEAR(loan_open_date) AS Year, SUM(loan_ttl)  AS 'Loan with Interest'
FROM [dbo].[t_loan_amt_fact]
GROUP BY YEAR(loan_open_date)
GO
/****** Object:  View [dbo].[v_loan_int_amt_yr]    Script Date: 7/25/2020 1:38:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[v_loan_int_amt_yr] AS
SELECT YEAR(loan_open_date) AS Year, SUM(loan_int_amt)  AS 'Revenue'
FROM [dbo].[t_loan_amt_fact]
GROUP BY YEAR(loan_open_date)
GO
/****** Object:  View [dbo].[v_top10_no_loan_2019]    Script Date: 7/25/2020 1:38:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_top10_no_loan_2019]
AS
SELECT DISTINCT  TOP 10
       branch_id
     , COUNT(loan_curr_amt) AS 'Number of Loans'
     , YEAR(loan_open_date) AS Year
  FROM dbo.t_loan_amt_fact
  WHERE YEAR(loan_open_date) = 2019
 GROUP BY branch_id
        , YEAR(loan_open_date)
 ORDER BY Year DESC;
GO
/****** Object:  View [dbo].[v_bank_loan_int_yr]    Script Date: 7/25/2020 1:38:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_bank_loan_int_yr] AS
select year(laf.loan_open_date) as year_open_date
     , SUM(laf.loan_int_amt) 
	 + case when year(laf.loan_open_date) = 2019
	        then 980015.664824 else 0 end as int_loan_amt
     , SUM(laf.loan_int_amt) as loan_amt
from [dbo].[t_loan_amt_fact] as laf
group by
year(laf.loan_open_date)
GO
/****** Object:  Table [dbo].[t_acct_fact]    Script Date: 7/25/2020 1:38:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_acct_fact](
	[acct_fact_id] [int] IDENTITY(4,4) NOT NULL,
	[acct_id] [int] NOT NULL,
	[acct_as_of_date] [date] NOT NULL,
	[acct_cur_bal] [decimal](20, 4) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[acct_fact_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[t_acct_dim]    Script Date: 7/25/2020 1:38:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_acct_dim](
	[acct_id] [int] NOT NULL,
	[branch_id] [smallint] NOT NULL,
	[acct_open_date] [date] NOT NULL,
	[acct_close_date] [date] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[acct_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[v_years_comp]    Script Date: 7/25/2020 1:38:01 PM ******/
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
/****** Object:  Table [dbo].[t_rt_tran_fact]    Script Date: 7/25/2020 1:38:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_rt_tran_fact](
	[tran_fact_id] [int] IDENTITY(3,2) NOT NULL,
	[tran_date] [date] NOT NULL,
	[tran_time] [time](7) NOT NULL,
	[tran_amt] [int] NOT NULL,
	[tran_fee_amt] [decimal](15, 3) NOT NULL,
	[acct_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[tran_fact_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[t_branch_dim]    Script Date: 7/25/2020 1:38:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_branch_dim](
	[branch_id] [smallint] NOT NULL,
	[branch_code] [varchar](5) NOT NULL,
	[branch_desc] [varchar](100) NOT NULL,
	[branch_add] [int] NOT NULL,
	[region_id] [int] NOT NULL,
	[area_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[branch_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[t_cust_dim]    Script Date: 7/25/2020 1:38:01 PM ******/
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
/****** Object:  View [dbo].[v_top_10_tran_br]    Script Date: 7/25/2020 1:38:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_top_10_tran_br] AS

SELECT TOP 10 a.acct_id AS 'Acct ID'
	 ,CONCAT(c.cust_first_name,' ', c.cust_last_name) AS 'Full Name'
     , COUNT(trtf.tran_fact_id) AS 'N of Tran'
  FROM DFNB2.dbo.t_acct_dim AS a
       INNER JOIN
       dbo.t_rt_tran_fact AS trtf ON trtf.acct_id = a.acct_id
	   INNER JOIN dbo.t_branch_dim tbd ON tbd.branch_id = a.branch_id
	   INNER JOIN dbo.t_cust_dim c ON c.cust_id = a.acct_id
	   WHERE branch_code = 'BR'
 GROUP BY a.acct_id
		,c.cust_first_name
		,c.cust_last_name
        , a.acct_loan_amt
        , a.acct_open_date
        , a.acct_close_date
	ORDER BY 'N of Tran' DESC
GO
/****** Object:  View [dbo].[v_top_10_tran_cl]    Script Date: 7/25/2020 1:38:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_top_10_tran_cl] AS

SELECT TOP 10 a.acct_id AS 'Acct ID'
	 ,CONCAT(c.cust_first_name,' ', c.cust_last_name) AS 'Full Name'
     , COUNT(trtf.tran_fact_id) AS 'N of Tran'
  FROM DFNB2.dbo.t_acct_dim AS a
       INNER JOIN
       dbo.t_rt_tran_fact AS trtf ON trtf.acct_id = a.acct_id
	   INNER JOIN dbo.t_branch_dim tbd ON tbd.branch_id = a.branch_id
	   INNER JOIN dbo.t_cust_dim c ON c.cust_id = a.acct_id
	   WHERE branch_code = 'CL'
 GROUP BY a.acct_id
		,c.cust_first_name
		,c.cust_last_name
        , a.acct_loan_amt
        , a.acct_open_date
        , a.acct_close_date
	ORDER BY 'N of Tran' DESC
GO
/****** Object:  View [dbo].[v_top_10_tran_fr]    Script Date: 7/25/2020 1:38:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_top_10_tran_fr] AS

SELECT TOP 10 a.acct_id AS 'Acct ID'
	 ,CONCAT(c.cust_first_name,' ', c.cust_last_name) AS 'Full Name'
     , COUNT(trtf.tran_fact_id) AS 'N of Tran'
  FROM DFNB2.dbo.t_acct_dim AS a
       INNER JOIN
       dbo.t_rt_tran_fact AS trtf ON trtf.acct_id = a.acct_id
	   INNER JOIN dbo.t_branch_dim tbd ON tbd.branch_id = a.branch_id
	   INNER JOIN dbo.t_cust_dim c ON c.cust_id = a.acct_id
	   WHERE branch_code = 'FR'
 GROUP BY a.acct_id
		,c.cust_first_name
		,c.cust_last_name
        , a.acct_loan_amt
        , a.acct_open_date
        , a.acct_close_date
	ORDER BY 'N of Tran' DESC
GO
/****** Object:  View [dbo].[v_top_10_tran_fv]    Script Date: 7/25/2020 1:38:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_top_10_tran_fv] AS

SELECT TOP 10 a.acct_id AS 'Acct ID'
	 ,CONCAT(c.cust_first_name,' ', c.cust_last_name) AS 'Full Name'
     , COUNT(trtf.tran_fact_id) AS 'N of Tran'
  FROM DFNB2.dbo.t_acct_dim AS a
       INNER JOIN
       dbo.t_rt_tran_fact AS trtf ON trtf.acct_id = a.acct_id
	   INNER JOIN dbo.t_branch_dim tbd ON tbd.branch_id = a.branch_id
	   INNER JOIN dbo.t_cust_dim c ON c.cust_id = a.acct_id
	   WHERE branch_code = 'FV'
 GROUP BY a.acct_id
		,c.cust_first_name
		,c.cust_last_name
        , a.acct_loan_amt
        , a.acct_open_date
        , a.acct_close_date
	ORDER BY 'N of Tran' DESC
GO
/****** Object:  View [dbo].[v_top_10_tran_gt]    Script Date: 7/25/2020 1:38:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_top_10_tran_gt] AS

SELECT TOP 10 a.acct_id AS 'Acct ID'
	 ,CONCAT(c.cust_first_name,' ', c.cust_last_name) AS 'Full Name'
     , COUNT(trtf.tran_fact_id) AS 'N of Tran'
  FROM DFNB2.dbo.t_acct_dim AS a
       INNER JOIN
       dbo.t_rt_tran_fact AS trtf ON trtf.acct_id = a.acct_id
	   INNER JOIN dbo.t_branch_dim tbd ON tbd.branch_id = a.branch_id
	   INNER JOIN dbo.t_cust_dim c ON c.cust_id = a.acct_id
	   WHERE branch_code = 'GT'
 GROUP BY a.acct_id
		,c.cust_first_name
		,c.cust_last_name
        , a.acct_loan_amt
        , a.acct_open_date
        , a.acct_close_date
	ORDER BY 'N of Tran' DESC
GO
/****** Object:  View [dbo].[v_top_10_tran_gv]    Script Date: 7/25/2020 1:38:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_top_10_tran_gv] AS

SELECT TOP 10 a.acct_id AS 'Acct ID'
	 ,CONCAT(c.cust_first_name,' ', c.cust_last_name) AS 'Full Name'
     , COUNT(trtf.tran_fact_id) AS 'N of Tran'
  FROM DFNB2.dbo.t_acct_dim AS a
       INNER JOIN
       dbo.t_rt_tran_fact AS trtf ON trtf.acct_id = a.acct_id
	   INNER JOIN dbo.t_branch_dim tbd ON tbd.branch_id = a.branch_id
	   INNER JOIN dbo.t_cust_dim c ON c.cust_id = a.acct_id
	   WHERE branch_code = 'GV'
 GROUP BY a.acct_id
		,c.cust_first_name
		,c.cust_last_name
        , a.acct_loan_amt
        , a.acct_open_date
        , a.acct_close_date
	ORDER BY 'N of Tran' DESC
GO
/****** Object:  Table [dbo].[t_cust_acct_brg]    Script Date: 7/25/2020 1:38:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_cust_acct_brg](
	[cust_acct_id] [int] IDENTITY(10,5) NOT NULL,
	[cust_since_date] [date] NOT NULL,
	[cust_pri_branch_dist] [decimal](7, 2) NOT NULL,
	[cust_id] [smallint] NOT NULL,
	[acct_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[cust_acct_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[v_acct_by_year]    Script Date: 7/25/2020 1:38:01 PM ******/
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
/****** Object:  View [dbo].[v_top_10_tran_kn]    Script Date: 7/25/2020 1:38:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_top_10_tran_kn] AS

SELECT TOP 10 a.acct_id AS 'Acct ID'
	 ,CONCAT(c.cust_first_name,' ', c.cust_last_name) AS 'Full Name'
     , COUNT(trtf.tran_fact_id) AS 'N of Tran'
  FROM DFNB2.dbo.t_acct_dim AS a
       INNER JOIN
       dbo.t_rt_tran_fact AS trtf ON trtf.acct_id = a.acct_id
	   INNER JOIN dbo.t_branch_dim tbd ON tbd.branch_id = a.branch_id
	   INNER JOIN dbo.t_cust_dim c ON c.cust_id = a.acct_id
	   WHERE branch_code = 'KN'
 GROUP BY a.acct_id
		,c.cust_first_name
		,c.cust_last_name
        , a.acct_loan_amt
        , a.acct_open_date
        , a.acct_close_date
	ORDER BY 'N of Tran' DESC
GO
/****** Object:  View [dbo].[v_top_10_tran_md]    Script Date: 7/25/2020 1:38:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_top_10_tran_md] AS

SELECT TOP 10 a.acct_id AS 'Acct ID'
	 ,CONCAT(c.cust_first_name,' ', c.cust_last_name) AS 'Full Name'
     , COUNT(trtf.tran_fact_id) AS 'N of Tran'
  FROM DFNB2.dbo.t_acct_dim AS a
       INNER JOIN
       dbo.t_rt_tran_fact AS trtf ON trtf.acct_id = a.acct_id
	   INNER JOIN dbo.t_branch_dim tbd ON tbd.branch_id = a.branch_id
	   INNER JOIN dbo.t_cust_dim c ON c.cust_id = a.acct_id
	   WHERE branch_code = 'MD'
 GROUP BY a.acct_id
		,c.cust_first_name
		,c.cust_last_name
        , a.acct_loan_amt
        , a.acct_open_date
        , a.acct_close_date
	ORDER BY 'N of Tran' DESC
GO
/****** Object:  View [dbo].[v_acct_closed]    Script Date: 7/25/2020 1:38:01 PM ******/
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
/****** Object:  View [dbo].[v_top_10_tran_rs]    Script Date: 7/25/2020 1:38:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_top_10_tran_rs] AS

SELECT TOP 10 a.acct_id AS 'Acct ID'
	 ,CONCAT(c.cust_first_name,' ', c.cust_last_name) AS 'Full Name'
     , COUNT(trtf.tran_fact_id) AS 'N of Tran'
  FROM DFNB2.dbo.t_acct_dim AS a
       INNER JOIN
       dbo.t_rt_tran_fact AS trtf ON trtf.acct_id = a.acct_id
	   INNER JOIN dbo.t_branch_dim tbd ON tbd.branch_id = a.branch_id
	   INNER JOIN dbo.t_cust_dim c ON c.cust_id = a.acct_id
	   WHERE branch_code = 'RS'
 GROUP BY a.acct_id
		,c.cust_first_name
		,c.cust_last_name
        , a.acct_loan_amt
        , a.acct_open_date
        , a.acct_close_date
	ORDER BY 'N of Tran' DESC
GO
/****** Object:  View [dbo].[v_acct_opened]    Script Date: 7/25/2020 1:38:01 PM ******/
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
/****** Object:  View [dbo].[v_top_10_tran_sa]    Script Date: 7/25/2020 1:38:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_top_10_tran_sa] AS

SELECT TOP 10 a.acct_id AS 'Acct ID'
	 ,CONCAT(c.cust_first_name,' ', c.cust_last_name) AS 'Full Name'
     , COUNT(trtf.tran_fact_id) AS 'N of Tran'
  FROM DFNB2.dbo.t_acct_dim AS a
       INNER JOIN
       dbo.t_rt_tran_fact AS trtf ON trtf.acct_id = a.acct_id
	   INNER JOIN dbo.t_branch_dim tbd ON tbd.branch_id = a.branch_id
	   INNER JOIN dbo.t_cust_dim c ON c.cust_id = a.acct_id
	   WHERE branch_code = 'SA'
 GROUP BY a.acct_id
		,c.cust_first_name
		,c.cust_last_name
        , a.acct_loan_amt
        , a.acct_open_date
        , a.acct_close_date
	ORDER BY 'N of Tran' DESC
GO
/****** Object:  View [dbo].[v_top_10_tran_sp]    Script Date: 7/25/2020 1:38:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_top_10_tran_sp] AS

SELECT TOP 10 a.acct_id AS 'Acct ID'
	 ,CONCAT(c.cust_first_name,' ', c.cust_last_name) AS 'Full Name'
     , COUNT(trtf.tran_fact_id) AS 'N of Tran'
  FROM DFNB2.dbo.t_acct_dim AS a
       INNER JOIN
       dbo.t_rt_tran_fact AS trtf ON trtf.acct_id = a.acct_id
	   INNER JOIN dbo.t_branch_dim tbd ON tbd.branch_id = a.branch_id
	   INNER JOIN dbo.t_cust_dim c ON c.cust_id = a.acct_id
	   WHERE branch_code = 'SP'
 GROUP BY a.acct_id
		,c.cust_first_name
		,c.cust_last_name
        , a.acct_loan_amt
        , a.acct_open_date
        , a.acct_close_date
	ORDER BY 'N of Tran' DESC
GO
/****** Object:  View [dbo].[v_top_10_tran_wa]    Script Date: 7/25/2020 1:38:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_top_10_tran_wa] AS

SELECT TOP 10 a.acct_id AS 'Acct ID'
	 ,CONCAT(c.cust_first_name,' ', c.cust_last_name) AS 'Full Name'
     , COUNT(trtf.tran_fact_id) AS 'N of Tran'
  FROM DFNB2.dbo.t_acct_dim AS a
       INNER JOIN
       dbo.t_rt_tran_fact AS trtf ON trtf.acct_id = a.acct_id
	   INNER JOIN dbo.t_branch_dim tbd ON tbd.branch_id = a.branch_id
	   INNER JOIN dbo.t_cust_dim c ON c.cust_id = a.acct_id
	   WHERE branch_code = 'WA'
 GROUP BY a.acct_id
		,c.cust_first_name
		,c.cust_last_name
        , a.acct_loan_amt
        , a.acct_open_date
        , a.acct_close_date
	ORDER BY 'N of Tran' DESC
GO
/****** Object:  View [dbo].[v_number_tran_branch]    Script Date: 7/25/2020 1:38:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_number_tran_branch] AS
	SELECT tbd.branch_code AS Branch
          , COUNT(trtf.tran_fact_id) AS 'N of Tran'
       FROM DFNB2.dbo.t_acct_dim AS a
            INNER JOIN
            dbo.t_rt_tran_fact AS trtf ON trtf.acct_id = a.acct_id
            INNER JOIN
            dbo.t_branch_dim AS tbd ON tbd.branch_id = a.branch_id
            INNER JOIN
            dbo.t_cust_dim AS c ON c.cust_id = a.acct_id
      GROUP BY tbd.branch_code


GO
/****** Object:  View [dbo].[v_time_number_acct]    Script Date: 7/25/2020 1:38:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_time_number_acct] AS 
SELECT DISTINCT DATEPART(HOUR,tran_time) AS Time
,COUNT(acct_id) AS Accounts
FROM [dbo].[t_rt_tran_fact]
GROUP BY DATEPART(HOUR,tran_time)
GO
/****** Object:  View [dbo].[v_tran_amt_year]    Script Date: 7/25/2020 1:38:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_tran_amt_year] AS 
SELECT DISTINCT YEAR(tran_date) AS Year
, SUM(tran_amt) Ammoun
FROM [dbo].[t_rt_tran_fact] 
WHERE YEAR(tran_date) <> 2019
GROUP BY tran_date
GO
/****** Object:  Table [dbo].[t_tran_type_dim]    Script Date: 7/25/2020 1:38:01 PM ******/
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
/****** Object:  View [dbo].[v_tran_type_qty]    Script Date: 7/25/2020 1:38:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_tran_type_qty] AS
SELECT tran_type_desc AS 'Tran Type'
, COUNT(tran_type_id) AS Qty
FROM [dbo].[t_tran_type_dim]
GROUP BY tran_type_desc
GO
/****** Object:  View [dbo].[v_acct_gender_bal]    Script Date: 7/25/2020 1:38:01 PM ******/
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
/****** Object:  View [dbo].[v_top_ten_cur_bal_2016]    Script Date: 7/25/2020 1:38:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_top_ten_cur_bal_2016] AS

SELECT TOP 10 tad.acct_id AS 'Account ID'
            , tbd.branch_id AS Branch
            , taf.cur_bal AS 'Current Balance'
			, YEAR(taf.as_of_date) AS YEAR
  FROM dbo.t_acct_dim AS tad
       INNER JOIN
       dbo.t_acct_fact AS taf ON tad.acct_id = taf.acct_id
       INNER JOIN
       dbo.t_branch_dim AS tbd ON tad.branch_id = tbd.branch_id
	   WHERE YEAR(as_of_date) =2016 
 GROUP BY tad.acct_id
        , tbd.branch_id
        , taf.cur_bal
		,taf.as_of_date
	ORDER BY taf.cur_bal DESC 
GO
/****** Object:  View [dbo].[v_top_ten_cur_bal_2017]    Script Date: 7/25/2020 1:38:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_top_ten_cur_bal_2017] AS

SELECT TOP 10 tad.acct_id AS 'Account ID'
            , tbd.branch_id AS Branch
            , taf.cur_bal AS 'Current Balance'
			, YEAR(taf.as_of_date) AS YEAR
  FROM dbo.t_acct_dim AS tad
       INNER JOIN
       dbo.t_acct_fact AS taf ON tad.acct_id = taf.acct_id
       INNER JOIN
       dbo.t_branch_dim AS tbd ON tad.branch_id = tbd.branch_id
	   WHERE YEAR(as_of_date) =2017 
 GROUP BY tad.acct_id
        , tbd.branch_id
        , taf.cur_bal
		,taf.as_of_date
	ORDER BY taf.cur_bal DESC 
GO
/****** Object:  View [dbo].[v_top_ten_cur_bal_2018]    Script Date: 7/25/2020 1:38:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_top_ten_cur_bal_2018] AS

SELECT TOP 10 tad.acct_id AS 'Account ID'
            , tbd.branch_id AS Branch
            , taf.cur_bal AS 'Current Balance'
			, YEAR(taf.as_of_date) AS YEAR
  FROM dbo.t_acct_dim AS tad
       INNER JOIN
       dbo.t_acct_fact AS taf ON tad.acct_id = taf.acct_id
       INNER JOIN
       dbo.t_branch_dim AS tbd ON tad.branch_id = tbd.branch_id
	   WHERE YEAR(as_of_date) =2018 
 GROUP BY tad.acct_id
        , tbd.branch_id
        , taf.cur_bal
		,taf.as_of_date
	ORDER BY taf.cur_bal DESC 
GO
/****** Object:  View [dbo].[v_top10_client_cur_bal]    Script Date: 7/25/2020 1:38:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_top10_client_cur_bal] AS

SELECT TOP 10 CONCAT(tad.first_name,' ', last_name) AS 'Client'
            , tbd.branch_code AS Branch
            , taf.cur_bal AS 'Current Balance'
            , YEAR(taf.as_of_date) AS YEAR
  FROM dbo.t_cust_dim AS tad
       INNER JOIN
       dbo.t_acct_fact AS taf ON taf.acct_fact_id = tad.cust_dim_id
       INNER JOIN
       dbo.t_branch_dim AS tbd ON tad.cust_dim_id = tbd.branch_id
 WHERE YEAR(as_of_date) >=2016 AND YEAR(as_of_date) <= 2018
 GROUP BY first_name
        , last_name
        , tbd.branch_code
        , taf.cur_bal
        , taf.as_of_date
GO
/****** Object:  View [dbo].[v_rev_area_yr]    Script Date: 7/25/2020 1:38:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_rev_area_yr] AS
SELECT DISTINCT p1.acct_area_id AS 'Area ID', SUM(laf.loan_int_amt) AS 'Interest Revenue', YEAR(laf.loan_open_date) AS Year
FROM [dbo].[t_loan_amt_fact] AS laf
INNER JOIN [dbo].[stg_p1] AS p1  ON p1.acct_id = laf.acct_id
GROUP BY YEAR(laf.loan_open_date), acct_area_id
GO
/****** Object:  View [dbo].[v_rev_region_yr]    Script Date: 7/25/2020 1:38:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_rev_region_yr] AS
SELECT DISTINCT p1.acct_region_id AS 'Region ID', SUM(laf.loan_int_amt) AS 'Interest Revenue', YEAR(laf.loan_open_date) AS Year
FROM [dbo].[t_loan_amt_fact] AS laf
INNER JOIN [dbo].[stg_p1] AS p1  ON p1.acct_id = laf.acct_id
GROUP BY YEAR(laf.loan_open_date), acct_region_id
GO
/****** Object:  View [dbo].[v_rev_branch_yr]    Script Date: 7/25/2020 1:38:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[v_rev_branch_yr] AS
SELECT DISTINCT p1.acct_branch_desc AS 'Branch ID', SUM(laf.loan_int_amt) AS 'Interest Revenue', YEAR(laf.loan_open_date) AS Year
FROM [dbo].[t_loan_amt_fact] AS laf
INNER JOIN [dbo].[stg_p1] AS p1 ON p1.acct_id = laf.acct_id
GROUP BY YEAR(laf.loan_open_date), p1.acct_branch_desc

GO
/****** Object:  Table [dbo].[t_area_dim]    Script Date: 7/25/2020 1:38:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_area_dim](
	[area_id] [int] NOT NULL,
	[area_name] [char](100) NULL,
	[area_desc] [char](200) NULL,
 CONSTRAINT [PK_Area] PRIMARY KEY CLUSTERED 
(
	[area_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[t_branch_add_dim]    Script Date: 7/25/2020 1:38:01 PM ******/
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
/****** Object:  Table [dbo].[t_cust_add_dim]    Script Date: 7/25/2020 1:38:01 PM ******/
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
/****** Object:  Table [dbo].[t_cust_prod_brg]    Script Date: 7/25/2020 1:38:01 PM ******/
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
/****** Object:  Table [dbo].[t_loan_brg]    Script Date: 7/25/2020 1:38:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_loan_brg](
	[loan_brg_id] [int] IDENTITY(1,2) NOT NULL,
	[loan_curr_amt_id] [int] NOT NULL,
	[loan_amt_id] [int] NOT NULL,
	[loan_period_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[loan_brg_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[t_loan_curr_amt_dim]    Script Date: 7/25/2020 1:38:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_loan_curr_amt_dim](
	[loan_curr_amt_id] [int] IDENTITY(1,3) NOT NULL,
	[acct_id] [int] NOT NULL,
	[loan_amt] [decimal](20, 4) NOT NULL,
	[loan_payment] [decimal](20, 4) NULL,
	[loan_curr_amt]  AS (case when [loan_payment] IS NULL then [loan_amt] else [loan_amt]-[loan_payment] end),
PRIMARY KEY CLUSTERED 
(
	[loan_curr_amt_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[t_loan_period_dim]    Script Date: 7/25/2020 1:38:01 PM ******/
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
/****** Object:  Table [dbo].[t_prod_dim]    Script Date: 7/25/2020 1:38:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_prod_dim](
	[prod_id] [smallint] NOT NULL,
	[prod_name] [varchar](100) NULL,
	[prod_desc] [varchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[prod_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[t_region_dim]    Script Date: 7/25/2020 1:38:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_region_dim](
	[region_id] [int] NOT NULL,
	[region_name] [char](100) NULL,
	[region_desc] [char](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[region_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[t_role_dim]    Script Date: 7/25/2020 1:38:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_role_dim](
	[role_id] [int] IDENTITY(4,6) NOT NULL,
	[role_cust_id] [smallint] NOT NULL,
	[role_pri_id] [smallint] NOT NULL,
	[role_sec_id] [smallint] NULL,
	[cust_id] [smallint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[role_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[t_acct_dim]  WITH CHECK ADD  CONSTRAINT [FK_t_acct_dim_t_branch_dim1] FOREIGN KEY([branch_id])
REFERENCES [dbo].[t_branch_dim] ([branch_id])
GO
ALTER TABLE [dbo].[t_acct_dim] CHECK CONSTRAINT [FK_t_acct_dim_t_branch_dim1]
GO
ALTER TABLE [dbo].[t_acct_fact]  WITH CHECK ADD  CONSTRAINT [FK_t_acct_fact_t_acct_dim] FOREIGN KEY([acct_id])
REFERENCES [dbo].[t_acct_dim] ([acct_id])
GO
ALTER TABLE [dbo].[t_acct_fact] CHECK CONSTRAINT [FK_t_acct_fact_t_acct_dim]
GO
ALTER TABLE [dbo].[t_branch_add_dim]  WITH CHECK ADD  CONSTRAINT [FK_t_branch_add_dim_t_branch_dim] FOREIGN KEY([branch_id])
REFERENCES [dbo].[t_branch_dim] ([branch_id])
GO
ALTER TABLE [dbo].[t_branch_add_dim] CHECK CONSTRAINT [FK_t_branch_add_dim_t_branch_dim]
GO
ALTER TABLE [dbo].[t_branch_dim]  WITH CHECK ADD  CONSTRAINT [FK_t_branch_dim_t_area_dim] FOREIGN KEY([area_id])
REFERENCES [dbo].[t_area_dim] ([area_id])
GO
ALTER TABLE [dbo].[t_branch_dim] CHECK CONSTRAINT [FK_t_branch_dim_t_area_dim]
GO
ALTER TABLE [dbo].[t_branch_dim]  WITH CHECK ADD  CONSTRAINT [FK_t_branch_dim_t_region_dim] FOREIGN KEY([region_id])
REFERENCES [dbo].[t_region_dim] ([region_id])
GO
ALTER TABLE [dbo].[t_branch_dim] CHECK CONSTRAINT [FK_t_branch_dim_t_region_dim]
GO
ALTER TABLE [dbo].[t_cust_acct_brg]  WITH CHECK ADD  CONSTRAINT [FK_t_cust_acct_brg_t_acct_dim] FOREIGN KEY([acct_id])
REFERENCES [dbo].[t_acct_dim] ([acct_id])
GO
ALTER TABLE [dbo].[t_cust_acct_brg] CHECK CONSTRAINT [FK_t_cust_acct_brg_t_acct_dim]
GO
ALTER TABLE [dbo].[t_cust_acct_brg]  WITH CHECK ADD  CONSTRAINT [FK_t_cust_acct_brg_t_cust_dim] FOREIGN KEY([cust_id])
REFERENCES [dbo].[t_cust_dim] ([cust_id])
GO
ALTER TABLE [dbo].[t_cust_acct_brg] CHECK CONSTRAINT [FK_t_cust_acct_brg_t_cust_dim]
GO
ALTER TABLE [dbo].[t_cust_dim]  WITH CHECK ADD  CONSTRAINT [FK_t_cust_dim_t_cust_add_dim] FOREIGN KEY([cust_add_id])
REFERENCES [dbo].[t_cust_add_dim] ([cust_add_id])
GO
ALTER TABLE [dbo].[t_cust_dim] CHECK CONSTRAINT [FK_t_cust_dim_t_cust_add_dim]
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
ALTER TABLE [dbo].[t_loan_brg]  WITH CHECK ADD  CONSTRAINT [FK_t_loan_brg_t_loan_curr_amt_dim] FOREIGN KEY([loan_curr_amt_id])
REFERENCES [dbo].[t_loan_curr_amt_dim] ([loan_curr_amt_id])
GO
ALTER TABLE [dbo].[t_loan_brg] CHECK CONSTRAINT [FK_t_loan_brg_t_loan_curr_amt_dim]
GO
ALTER TABLE [dbo].[t_loan_brg]  WITH CHECK ADD  CONSTRAINT [FK_t_loan_brg_t_loan_period_dim] FOREIGN KEY([loan_period_id])
REFERENCES [dbo].[t_loan_period_dim] ([loan_period_id])
GO
ALTER TABLE [dbo].[t_loan_brg] CHECK CONSTRAINT [FK_t_loan_brg_t_loan_period_dim]
GO
ALTER TABLE [dbo].[t_loan_curr_amt_dim]  WITH CHECK ADD  CONSTRAINT [FK_t_loan_curr_amt_dim_t_acct_dim] FOREIGN KEY([acct_id])
REFERENCES [dbo].[t_acct_dim] ([acct_id])
GO
ALTER TABLE [dbo].[t_loan_curr_amt_dim] CHECK CONSTRAINT [FK_t_loan_curr_amt_dim_t_acct_dim]
GO
ALTER TABLE [dbo].[t_role_dim]  WITH CHECK ADD  CONSTRAINT [FK_t_role_dim_t_cust_dim] FOREIGN KEY([cust_id])
REFERENCES [dbo].[t_cust_dim] ([cust_id])
GO
ALTER TABLE [dbo].[t_role_dim] CHECK CONSTRAINT [FK_t_role_dim_t_cust_dim]
GO
ALTER TABLE [dbo].[t_rt_tran_fact]  WITH CHECK ADD  CONSTRAINT [FK_t_rt_tran_fact_t_acct_dim] FOREIGN KEY([acct_id])
REFERENCES [dbo].[t_acct_dim] ([acct_id])
GO
ALTER TABLE [dbo].[t_rt_tran_fact] CHECK CONSTRAINT [FK_t_rt_tran_fact_t_acct_dim]
GO
ALTER TABLE [dbo].[t_tran_type_dim]  WITH CHECK ADD  CONSTRAINT [FK_t_tran_type_dim_t_rt_tran_fact] FOREIGN KEY([tran_fact_id])
REFERENCES [dbo].[t_rt_tran_fact] ([tran_fact_id])
GO
ALTER TABLE [dbo].[t_tran_type_dim] CHECK CONSTRAINT [FK_t_tran_type_dim_t_rt_tran_fact]
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

/********************************************************************************************
NAME:    [dbo].[v_years_comp]
PURPOSE: Create the [dbo].[v_years_comp] view

SUPPORT: Kizy Matzenbacher
         kizymatzen@gmail.com

MODIFICATION LOG:
Ver   Date        Author    Description
---   ----------  -------   -----------------------------------------------------------------
1.0   06/16/2020  KIZYMATZEN   1. Created the view

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

/****** Object:  View [dbo].[v_years_comp]    Script Date: 6/16/2020 10:46:26 AM ******/
DROP VIEW [dbo].[v_years_comp]
GO

/****** Object:  View [dbo].[v_years_comp]    Script Date: 6/16/2020 10:46:26 AM ******/
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



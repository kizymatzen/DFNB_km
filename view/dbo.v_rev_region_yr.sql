/********************************************************************************************
NAME:    [dbo].[v_rev_region_yr]
PURPOSE: Create the [dbo].[v_rev_region_yr] view

SUPPORT: Kizy Matzenbacher
         kizymatzen@gmail.com

MODIFICATION LOG:
Ver   Date        Author    Description
---   ----------  -------   -----------------------------------------------------------------
1.0   07/20/2020  KIZYMATZEN   1. Created the view

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

/****** Object:  View [dbo].[v_rev_region_yr]    Script Date: 7/20/2020 11:44:17 AM ******/
DROP VIEW [dbo].[v_rev_region_yr]
GO

/****** Object:  View [dbo].[v_rev_region_yr]    Script Date: 7/20/2020 11:44:17 AM ******/
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



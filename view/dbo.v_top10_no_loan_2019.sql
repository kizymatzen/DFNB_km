/********************************************************************************************
NAME:    [dbo].[v_top10_no_loan_2019]
PURPOSE: Create the [dbo].[v_top10_no_loan_2019] view

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

/****** Object:  View [dbo].[v_top10_no_loan_2019]    Script Date: 7/20/2020 5:50:18 PM ******/
DROP VIEW [dbo].[v_top10_no_loan_2019]
GO

/****** Object:  View [dbo].[v_top10_no_loan_2019]    Script Date: 7/20/2020 5:50:18 PM ******/
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



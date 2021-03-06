/********************************************************************************************
NAME:    [dbo].[v_loan_int_amt_yr]
PURPOSE: Create the [dbo].[v_loan_int_amt_yr] view

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

/****** Object:  View [dbo].[v_loan_int_amt_yr]    Script Date: 7/20/2020 5:51:56 PM ******/
DROP VIEW [dbo].[v_loan_int_amt_yr]
GO

/****** Object:  View [dbo].[v_loan_int_amt_yr]    Script Date: 7/20/2020 5:51:56 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[v_loan_int_amt_yr] AS
SELECT YEAR(loan_open_date) AS Year, SUM(loan_int_amt)  AS 'Revenue'
FROM [dbo].[t_loan_amt_fact]
GROUP BY YEAR(loan_open_date)
GO



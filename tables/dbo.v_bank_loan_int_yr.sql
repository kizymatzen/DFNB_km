/********************************************************************************************
NAME:    [dbo].[v_bank_loan_int_yr] 
PURPOSE: Create the [dbo].[v_bank_loan_int_yr]  view

SUPPORT: Kizy Matzenbacher
         kizymatzen@gmail.com

MODIFICATION LOG:
Ver   Date        Author    Description
---   ----------  -------   -----------------------------------------------------------------
1.0   07/25/2020  KIZYMATZEN   1. Created the view

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

/****** Object:  View [dbo].[v_bank_loan_int_yr]    Script Date: 7/25/2020 1:06:47 PM ******/
DROP VIEW [dbo].[v_bank_loan_int_yr]
GO

/****** Object:  View [dbo].[v_bank_loan_int_yr]    Script Date: 7/25/2020 1:06:47 PM ******/
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



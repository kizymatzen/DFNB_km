/********************************************************************************************
NAME:    [dbo].[v_top_10_tran_br]
PURPOSE: Create the [dbo].[v_top_10_tran_br] view

SUPPORT: Kizy Matzenbacher
         kizymatzen@gmail.com

MODIFICATION LOG:
Ver   Date        Author    Description
---   ----------  -------   -----------------------------------------------------------------
1.0   07/6/2020  KIZYMATZEN   1. Created the view

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

/****** Object:  View [dbo].[v_top_10_tran_br]    Script Date: 7/6/2020 2:51:39 PM ******/
DROP VIEW [dbo].[v_top_10_tran_br]
GO

/****** Object:  View [dbo].[v_top_10_tran_br]    Script Date: 7/6/2020 2:51:39 PM ******/
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



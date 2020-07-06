/********************************************************************************************
NAME:    [dbo].[v_tran_amt_year]
PURPOSE: Create the [dbo].[v_tran_amt_year] view

SUPPORT: Kizy Matzenbacher
         kizymatzen@gmail.com

MODIFICATION LOG:
Ver   Date        Author    Description
---   ----------  -------   -----------------------------------------------------------------
1.0   07/06/2020  KIZYMATZEN   1. Created the view

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

/****** Object:  View [dbo].[v_tran_amt_year]    Script Date: 7/6/2020 3:04:22 PM ******/
DROP VIEW [dbo].[v_tran_amt_year]
GO

/****** Object:  View [dbo].[v_tran_amt_year]    Script Date: 7/6/2020 3:04:22 PM ******/
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



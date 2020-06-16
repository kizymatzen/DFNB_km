/********************************************************************************************
NAME:    [dbo].[v_acct_gender_bal]
PURPOSE: Create the [dbo].[v_acct_gender_bal] view

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

/****** Object:  View [dbo].[v_acct_gender_bal]    Script Date: 6/16/2020 12:27:31 PM ******/
DROP VIEW [dbo].[v_acct_gender_bal]
GO

/****** Object:  View [dbo].[v_acct_gender_bal]    Script Date: 6/16/2020 12:27:31 PM ******/
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



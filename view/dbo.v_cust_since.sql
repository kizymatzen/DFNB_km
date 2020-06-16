/********************************************************************************************
NAME:    [dbo].[v_cust_since]
PURPOSE: Create the [dbo].[v_cust_since] view

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

/****** Object:  View [dbo].[v_cust_since]    Script Date: 6/16/2020 10:17:06 AM ******/
DROP VIEW [dbo].[v_cust_since]
GO

/****** Object:  View [dbo].[v_cust_since]    Script Date: 6/16/2020 10:17:06 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[v_cust_since]
AS
     SELECT DISTINCT 
            acct_id AS 'Account ID'
          , first_name AS 'First Name'
          , last_name AS 'Last Name'
          , gender
          , DATEDIFF(YY, birth_date, GETDATE()) AS Age
          , YEAR(cust_since_date) AS 'Customer Since Year'
       FROM t_cust_dim AS c
            INNER JOIN
            t_cust_acct_brg AS ca ON c.cust_dim_id = ca.cust_dim_id
GO



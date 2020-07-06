/********************************************************************************************
NAME:    [dbo].[v_number_tran_branch]
PURPOSE: Create the [dbo].[v_number_tran_branch] view

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

/****** Object:  View [dbo].[v_number_tran_branch]    Script Date: 7/6/2020 3:04:11 PM ******/
DROP VIEW [dbo].[v_number_tran_branch]
GO

/****** Object:  View [dbo].[v_number_tran_branch]    Script Date: 7/6/2020 3:04:11 PM ******/
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



/********************************************************************************************
NAME:    [dbo].[v_time_avg_acct_open]
PURPOSE: Create the [dbo].[v_time_avg_acct_open] view

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

/****** Object:  View [dbo].[v_time_avg_acct_open]    Script Date: 6/16/2020 10:17:49 AM ******/
DROP VIEW [dbo].[v_time_avg_acct_open]
GO

/****** Object:  View [dbo].[v_time_avg_acct_open]    Script Date: 6/16/2020 10:17:49 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[v_time_avg_acct_open]
AS
     SELECT AVG(DATEDIFF(YEAR, open_date, close_date)) AS 'Time Avg Actt Open '
          , COUNT(close_date) AS 'Accounts Closed'
          , YEAR(close_date) AS Year
       FROM dbo.t_acct_dim AS tad
      WHERE close_date <> '9999-12-31'
      GROUP BY YEAR(close_date);
GO



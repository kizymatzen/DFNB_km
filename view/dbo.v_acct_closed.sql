/********************************************************************************************
NAME:    [dbo].[v_acct_closed]
PURPOSE: Create the [dbo].[v_acct_closed] view

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

/****** Object:  View [dbo].[v_acct_closed]    Script Date: 6/16/2020 10:10:42 AM ******/
DROP VIEW [dbo].[v_acct_closed]
GO

/****** Object:  View [dbo].[v_acct_closed]    Script Date: 6/16/2020 10:10:42 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[v_acct_closed] AS
SELECT COUNT(close_date) AS 'Acct Closed'
, YEAR(close_date) AS Year
FROM dbo.t_acct_dim 
WHERE close_date <> '9999-12-31'
GROUP BY YEAR(close_date)
GO



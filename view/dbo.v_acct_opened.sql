/********************************************************************************************
NAME:    [dbo].[v_acct_opened]
PURPOSE: Create the [dbo].[v_acct_opened] view

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

/****** Object:  View [dbo].[v_acct_opened]    Script Date: 6/16/2020 10:15:50 AM ******/
DROP VIEW [dbo].[v_acct_opened]
GO

/****** Object:  View [dbo].[v_acct_opened]    Script Date: 6/16/2020 10:15:50 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[v_acct_opened] AS
SELECT COUNT(open_date) AS 'Act Opened'
,YEAR(open_date) AS Year
FROM dbo.t_acct_dim tad
GROUP BY YEAR(open_date)
GO



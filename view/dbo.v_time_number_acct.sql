/********************************************************************************************
NAME:    [dbo].[v_time_number_acct]
PURPOSE: Create the [dbo].[v_time_number_acct] view

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

/****** Object:  View [dbo].[v_time_number_acct]    Script Date: 7/6/2020 3:06:54 PM ******/
DROP VIEW [dbo].[v_time_number_acct]
GO

/****** Object:  View [dbo].[v_time_number_acct]    Script Date: 7/6/2020 3:06:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[v_time_number_acct] AS 
SELECT DISTINCT DATEPART(HOUR,tran_time) AS Time
,COUNT(acct_id) AS Accounts
FROM [dbo].[t_rt_tran_fact]
GROUP BY DATEPART(HOUR,tran_time)
GO



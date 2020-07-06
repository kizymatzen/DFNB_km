/********************************************************************************************
NAME:    [dbo].[v_tran_type_qty]
PURPOSE: Create the [dbo].[v_tran_type_qty] view

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

/****** Object:  View [dbo].[v_tran_type_qty]    Script Date: 7/6/2020 3:05:41 PM ******/
DROP VIEW [dbo].[v_tran_type_qty]
GO

/****** Object:  View [dbo].[v_tran_type_qty]    Script Date: 7/6/2020 3:05:41 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[v_tran_type_qty] AS
SELECT tran_type_desc AS 'Tran Type'
, COUNT(tran_type_id) AS Qty
FROM [dbo].[t_tran_type_dim]
GROUP BY tran_type_desc
GO



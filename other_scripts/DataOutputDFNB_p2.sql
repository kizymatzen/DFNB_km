/********************************************************************************************
NAME:    data_output
PURPOSE: Output the data to create reports

SUPPORT: Kizy Matzenbacher
         kizymatzen@gmail.com

MODIFICATION LOG:
Ver   Date        Author    Description
---   ----------  -------   -----------------------------------------------------------------
1.0   07/06/2020  KIZYMATZEN   1. Created the script

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
SELECT *
FROM [dbo].[v_top_10_tran_br]
ORDER BY 3;


/*******************************************************************************************/

USE [DFNB2]
SELECT *
FROM [dbo].[v_top_10_tran_cl]
ORDER BY 3;


/*******************************************************************************************/

USE [DFNB2]
SELECT *
FROM [dbo].[v_top_10_tran_fr]
ORDER BY 3;


/*******************************************************************************************/

USE [DFNB2];
SELECT *
FROM [dbo].[v_top_10_tran_fv]
ORDER BY 3;


/*******************************************************************************************/

USE [DFNB2];
SELECT *
FROM [dbo].[v_top_10_tran_gt]
ORDER BY 3;


/*******************************************************************************************/

USE [DFNB2];
SELECT *
FROM [dbo].[v_top_10_tran_gv]
ORDER BY 3;

/*******************************************************************************************/

USE [DFNB2];
SELECT *
FROM [dbo].[v_top_10_tran_kn]
ORDER BY 3;

/*******************************************************************************************/

USE [DFNB2];
SELECT *
FROM [dbo].[v_top_10_tran_md]
ORDER BY 3;

/*******************************************************************************************/

USE [DFNB2];
SELECT *
FROM [dbo].[v_top_10_tran_rs] 
ORDER BY 3;

/*******************************************************************************************/

USE [DFNB2];
SELECT *
FROM [dbo].[v_top_10_tran_sa]
ORDER BY 3;
/*******************************************************************************************/

USE [DFNB2];
SELECT *
FROM [dbo].[v_top_10_tran_sp]
ORDER BY 3;
/*******************************************************************************************/

USE [DFNB2];
SELECT *
FROM [dbo].[v_top_10_tran_wa]
ORDER BY 3;
/*******************************************************************************************/

USE [DFNB2];
SELECT *
FROM [dbo].[v_number_tran_branch]
ORDER BY 2;
/*******************************************************************************************/

USE [DFNB2];
SELECT *
FROM [dbo].[v_tran_amt_year];
/*******************************************************************************************/

USE [DFNB2];
SELECT *
FROM [dbo].[v_time_number_acct]
ORDER BY 1;

/*******************************************************************************************/

USE [DFNB2];
SELECT *
FROM [dbo].[v_tran_type_qty]
ORDER BY 1;


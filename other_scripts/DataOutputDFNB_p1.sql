/********************************************************************************************
NAME:    data_output
PURPOSE: Output the data to create reports

SUPPORT: Kizy Matzenbacher
         kizymatzen@gmail.com

MODIFICATION LOG:
Ver   Date        Author    Description
---   ----------  -------   -----------------------------------------------------------------
1.0   06/16/2020  KIZYMATZEN   1. Created the script

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
FROM [dbo].[v_acct_by_year]
ORDER BY 2 ASC;

/*******************************************************************************************/

USE [DFNB2]
SELECT *
FROM [dbo].[v_acct_closed]
ORDER BY 2 ASC;

/*******************************************************************************************/

USE [DFNB2]
SELECT *
FROM [dbo].[v_acct_gender_bal]
ORDER BY 4 ASC;

/*******************************************************************************************/

USE [DFNB2];
SELECT *
FROM [dbo].[v_acct_opened]
ORDER BY 1, 4, 8 DESC;

/*******************************************************************************************/

USE [DFNB2];
SELECT *
FROM [dbo].[v_time_avg_acct_open]
ORDER BY 6,1,2;

/*******************************************************************************************/

USE [DFNB2];
SELECT *
FROM [dbo].[v_years_comp];

/*******************************************************************************************/

USE [DFNB2];
SELECT *
FROM [dbo].[v_top_ten_cur_bal_2016];

/*******************************************************************************************/

USE [DFNB2];
SELECT *
FROM [dbo].[v_top_ten_cur_bal_2017];

/*******************************************************************************************/

USE [DFNB2];
SELECT *
FROM [dbo].[v_top_ten_cur_bal_2018];

/*******************************************************************************************/

USE [DFNB2];
SELECT *
FROM [dbo].[v_top10_client_cur_bal];
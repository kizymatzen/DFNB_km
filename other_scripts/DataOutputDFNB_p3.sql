/********************************************************************************************
NAME:    data_output
PURPOSE: Output the data to create reports

SUPPORT: Kizy Matzenbacher
         kizymatzen@gmail.com

MODIFICATION LOG:
Ver   Date        Author    Description
---   ----------  -------   -----------------------------------------------------------------
1.0   07/20/2020  KIZYMATZEN   1. Created the script

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
FROM [dbo].[v_rev_area_yr]
ORDER BY 3;

/*******************************************************************************************/
USE [DFNB2]
SELECT *
FROM [dbo].[v_rev_branch_yr]
ORDER BY 3;

/*******************************************************************************************/
USE [DFNB2]
SELECT *
FROM [dbo].[v_rev_region_yr]
ORDER BY 3;

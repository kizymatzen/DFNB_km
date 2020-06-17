/********************************************************************************************
NAME:    data_loading
PURPOSE: Load data model from dbo.stg_p1 to DFNB2 database and assign keys

SUPPORT: Kizy Matzenbacher
         kizymatzen@gmail.com

MODIFICATION LOG:
Ver   Date        Author    Description
---   ----------  -------   -----------------------------------------------------------------
1.0   06/16/2020  KIZYMATZEN   1. Script creation

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

-- 1) Drop Constraints

USE [DFNB2];

IF OBJECT_ID('FK_t_acct_fact_t_acct_dim') IS NOT NULL
    BEGIN
        ALTER TABLE dbo.t_acct_fact DROP CONSTRAINT FK_t_acct_fact_t_acct_dim;
END;

IF OBJECT_ID('FK_t_acct_dim_t_branch_dim') IS NOT NULL
    BEGIN
        ALTER TABLE dbo.t_acct_dim DROP CONSTRAINT FK_t_acct_dim_t_branch_dim;
END;

IF OBJECT_ID('FK_t_branch_add_t_branch_dim') IS NOT NULL
    BEGIN
        ALTER TABLE dbo.t_branch_add_dim DROP CONSTRAINT FK_t_branch_add_t_branch_dim;
END;

IF OBJECT_ID('FK_t_branch_dim_t_region') IS NOT NULL
    BEGIN
        ALTER TABLE dbo.t_branch_dim DROP CONSTRAINT FK_t_branch_dim_t_region;
END;

IF OBJECT_ID('FK_t_branch_dim_t_area') IS NOT NULL
    BEGIN
        ALTER TABLE dbo.t_branch_dim DROP CONSTRAINT FK_t_branch_dim_t_area;
END;

IF OBJECT_ID('FK_t_cust_acct_brg_t_cust_dim') IS NOT NULL
    BEGIN
        ALTER TABLE dbo.t_cust_acct_brg DROP CONSTRAINT FK_t_cust_acct_brg_t_cust_dim;
END;

IF OBJECT_ID('FK_t_cust_acct_brg_t_acct_dim') IS NOT NULL
    BEGIN
        ALTER TABLE dbo.t_cust_acct_brg DROP CONSTRAINT FK_t_cust_acct_brg_t_acct_dim;
END;

IF OBJECT_ID('FK_t_cust_dim_t_prod_dim') IS NOT NULL
    BEGIN
        ALTER TABLE dbo.t_cust_dim DROP CONSTRAINT FK_t_cust_dim_t_prod_dim;
END;

IF OBJECT_ID('FK_t_cust_dim_t_cust_add') IS NOT NULL
    BEGIN
        ALTER TABLE dbo.t_cust_dim DROP CONSTRAINT FK_t_cust_dim_t_cust_add;
END;

-- 2) Create the Account Dimension Table

TRUNCATE TABLE dbo.t_acct_dim

INSERT INTO dbo.t_acct_dim
SELECT DISTINCT 
       acct_id
     , branch_id
     , loan_amt
     , open_date
     , close_date
  FROM dbo.stg_p1
 ORDER BY acct_id;

 -- 3) Create the Account Fact Table

TRUNCATE TABLE dbo.t_acct_fact;

INSERT INTO dbo.t_acct_fact
SELECT DISTINCT 
       -- acct_fact_id - column value is auto-generated
       acct_id
     , as_of_date
     , cur_bal
  FROM dbo.stg_p1
 --ORDER BY acct_fact_id;

 -- 4) Create the Area Dimension Table

TRUNCATE TABLE dbo.area_dim;

INSERT INTO dbo.t_area_dim
SELECT DISTINCT 
       area_id
	   -- area_name - NULL
	   -- area_desc - NULL
  FROM dbo.stg_p1
 ORDER BY acct_fact_id;

 -- 5) Create the Branch Address Dimension Table

TRUNCATE TABLE dbo.t_branch_add_dim;

INSERT INTO dbo.t_branch_add_dim
SELECT DISTINCT 
       branch_add_id
     , branch_add_lat
     , branch_add_lon
     , branch_code
     , branch_add_type
     , branch_id
  FROM dbo.stg_p1 AS sp
 ORDER BY branch_add_id;

 -- 6) Create the Branch Dimension Table
TRUNCATE TABLE dbo.t_branch_dim;

INSERT INTO dbo.t_branch_dim
SELECT DISTINCT 
       branch_id
     , branch_code
     , branch_desc
     , branch_add_id
     , region_id
     , area_id
  FROM dbo.stg_p1 AS sp
 ORDER BY branch_id;

 -- 7) Create Customer Account Bridge Table

 TRUNCATE TABLE dbo.t_cust_acct_brg;

INSERT INTO dbo.t_cust_acct_brg
SELECT DISTINCT
--cust_acct_id - column value is auto-generated
       cust_dim_id
     , cust_add_id
     , cust_since_date
     , acct_id
     , cust_pri_branch_dist;
--ORDER BY cust_acct_id

-- 8) Create Customer Address Dimension Table

TRUNCATE TABLE dbo.t_cust_add_dim;

INSERT INTO dbo.t_cust_add_dim
SELECT DISTINCT 
       cust_add_id
     , cust_add_lat
     , cust_add_lon
     , cust_add_type
  FROM dbo.stg_p1;
--ORDER BY cust_add_id

-- 9) Create Customer Dimension Table

TRUNCATE TABLE dbo.t_cust_dim

INSERT INTO dbo.t_cust_dim
SELECT DISTINCT
       --cust_dim_id - column value is auto-generated
       cust_id
     , first_name
     , last_name
     , birth_date
     , gender
     , prod_dim_id
     , cust_add_id
     , pri_branch_id
  FROM dbo.stg_p1 AS sp;
--ORDER BY cust_dim_id

-- 10) Create Customer Role Dimension Table

TRUNCATE TABLE dbo.t_cust_role_dim

INSERT INTO dbo.t_cust_role_dim
SELECT DISTINCT
       --cust_role_id - column value is auto-generated
       role_cust_id
     , pri_cust_id
     , sec_cust_id
  FROM dbo.stg_p1 AS sp;
--ORDER BY cust_role_id

-- 11) Create Product Dimension Table

TRUNCATE TABLE dbo.t_prod_dim;

INSERT INTO dbo.t_prod_dim
SELECT DISTINCT
--prod_dim_id - column value is auto-generated
       prod_id
     , cust_id
  FROM dbo.stg_p1 AS sp;
--ORDER BY prod_dim_id

-- 12) Create Region Dimension Table

TRUNCATE TABLE dbo.t_region_dim;

INSERT INTO dbo.t_region_dim
SELECT DISTINCT 
       region_id
-- region_name - NULL
-- region_desc - NULL
  FROM dbo.stg_p1
 ORDER BY region_id;

 -- 13) Add Constraints

 ALTER TABLE dbo.t_branch_add_dim  WITH CHECK ADD  CONSTRAINT FK_t_branch_add_t_branch_dim FOREIGN KEY(branch_id)
REFERENCES dbo.t_branch_dim (branch_id)

ALTER TABLE dbo.t_branch_dim  WITH CHECK ADD  CONSTRAINT FK_t_branch_dim_t_area FOREIGN KEY(area_id)
REFERENCES dbo.t_area_dim (area_id)

ALTER TABLE dbo.t_branch_dim  WITH CHECK ADD  CONSTRAINT [FK_t_branch_dim_t_region] FOREIGN KEY(region_id)
REFERENCES dbo.t_region_dim (region_id)

ALTER TABLE dbo.t_cust_acct_brg  WITH CHECK ADD  CONSTRAINT FK_t_cust_acct_brg_t_acct_dim FOREIGN KEY(acct_id)
REFERENCES dbo.t_acct_dim (acct_id)

ALTER TABLE dbo.t_cust_acct_brg  WITH CHECK ADD  CONSTRAINT FK_t_cust_acct_brg_t_cust_dim FOREIGN KEY(cust_dim_id)
REFERENCES dbo.t_cust_dim (cust_dim_id)

ALTER TABLE dbo.t_cust_dim  WITH CHECK ADD  CONSTRAINT FK_t_cust_dim_t_cust_add FOREIGN KEY(cust_add_id)
REFERENCES dbo.t_cust_add_dim (cust_add_id)

ALTER TABLE dbo.t_cust_dim  WITH CHECK ADD  CONSTRAINT FK_t_cust_dim_t_prod_dim FOREIGN KEY(prod_dim_id)
REFERENCES dbo.t_prod_dim (prod_dim_id)

ALTER TABLE dbo.t_acct_dim  WITH CHECK ADD  CONSTRAINT FK_t_acct_dim_t_branch_dim FOREIGN KEY(branch_id)
REFERENCES dbo.t_branch_dim (branch_id)

ALTER TABLE dbo.t_acct_fact  WITH CHECK ADD  CONSTRAINT FK_t_acct_fact_t_acct_dim FOREIGN KEY(acct_id)
REFERENCES dbo.t_acct_dim (acct_id)





/********************************************************************************************
NAME:    data_loading
PURPOSE: Load data model from dbo.stg_p2 to DFNB2 database and assign keys

SUPPORT: Kizy Matzenbacher
         kizymatzen@gmail.com

MODIFICATION LOG:
Ver   Date        Author    Description
---   ----------  -------   -----------------------------------------------------------------
1.0   06/26/2020  KIZYMATZEN   1. Script creation

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

IF OBJECT_ID('FK_t_acct_dim_t_branch_dim1') IS NOT NULL
    BEGIN
        ALTER TABLE dbo.t_acct_dim DROP CONSTRAINT FK_t_acct_dim_t_branch_dim1;
END;

IF OBJECT_ID('FK_t_acct_fact_t_acct_dim') IS NOT NULL
ALTER TABLE dbo.t_acct_fact DROP CONSTRAINT FK_t_acct_fact_t_acct_dim;

END;

IF OBJECT_ID('FK_t_branch_add_dim_t_branch_dim') IS NOT NULL
ALTER TABLE dbo.t_branch_add_dim DROP CONSTRAINT FK_t_branch_add_dim_t_branch_dim;

END;

IF OBJECT_ID('FK_t_branch_dim_t_region_dim') IS NOT NULL
ALTER TABLE dbo.t_branch_dim DROP CONSTRAINT FK_t_branch_dim_t_region_dim;

END;

IF OBJECT_ID('FK_t_branch_dim_t_area_dim') IS NOT NULL
ALTER TABLE dbo.t_branch_dim DROP CONSTRAINT FK_t_branch_dim_t_area_dim;

END;

IF OBJECT_ID('FK_t_cust_acct_brg_t_cust_dim') IS NOT NULL
ALTER TABLE dbo.t_cust_acct_brg DROP CONSTRAINT FK_t_cust_acct_brg_t_cust_dim;

END;

IF OBJECT_ID('FK_t_cust_acct_brg_t_acct_dim') IS NOT NULL
ALTER TABLE dbo.t_cust_acct_brg DROP CONSTRAINT FK_t_cust_acct_brg_t_acct_dim;

END;

IF OBJECT_ID('FK_t_cust_dim_t_cust_add_dim') IS NOT NULL
ALTER TABLE dbo.t_cust_dim DROP CONSTRAINT FK_t_cust_dim_t_cust_add_dim;

END;

IF OBJECT_ID('FK_t_cust_prod_brg_t_prod_dim') IS NOT NULL
ALTER TABLE dbo.t_cust_prod_brg DROP CONSTRAINT FK_t_cust_prod_brg_t_prod_dim;

END;

IF OBJECT_ID('FK_t_cust_prod_brg_t_cust_dim') IS NOT NULL
ALTER TABLE dbo.t_cust_prod_brg DROP CONSTRAINT FK_t_cust_prod_brg_t_cust_dim;

END;

IF OBJECT_ID('FK_t_role_dim_t_cust_dim') IS NOT NULL
ALTER TABLE dbo.t_role_dim DROP CONSTRAINT FK_t_role_dim_t_cust_dim;

END;

IF OBJECT_ID('FK_t_tran_type_dim_t_rt_tran_fact') IS NOT NULL
ALTER TABLE dbo.t_tran_type_dim DROP CONSTRAINT FK_t_tran_type_dim_t_rt_tran_fact;

END;

IF OBJECT_ID('FK_t_rt_tran_fact_t_acct_dim') IS NOT NULL
ALTER TABLE dbo.t_rt_tran_fact DROP CONSTRAINT FK_t_rt_tran_fact_t_acct_dim;

END;

-- 2) Create the Account Dimension Table

DROP TABLE dbo.t_acct_dim;

CREATE TABLE dbo.t_acct_dim
( acct_id         INT NOT NULL PRIMARY KEY
, branch_id       SMALLINT NOT NULL
, acct_loan_amt   DECIMAL(20, 4) NOT NULL
, acct_open_date  DATE NOT NULL
, acct_close_date DATE NOT NULL
);

INSERT INTO dbo.t_acct_dim(acct_id
                         , branch_id
                         , acct_loan_amt
						 , acct_open_date
                         , acct_close_date)
SELECT DISTINCT 
       acct_id
     , branch_id
     , loan_amt
     , open_date
     , close_date
  FROM dbo.stg_p1;

 -- 3) Create the Account Fact Table

DROP TABLE dbo.t_acct_fact;

CREATE TABLE dbo.t_acct_fact
(acct_fact_id    INT IDENTITY(4, 4) NOT NULL PRIMARY KEY
, acct_id         INT NOT NULL
, acct_as_of_date DATE NOT NULL
, acct_cur_bal    DECIMAL(20, 4) NOT NULL
);

INSERT INTO dbo.t_acct_fact(acct_id
                          , acct_as_of_date
                          , acct_cur_bal)
SELECT DISTINCT 
       acct_id
     , as_of_date
     , cur_bal
  FROM dbo.stg_p1 AS p1;
    

 -- 4) Create the Area Dimension Table


DROP TABLE dbo.t_area_dim;

CREATE TABLE dbo.t_area_dim
(area_id   INT NOT NULL
               CONSTRAINT PK_Area PRIMARY KEY
, area_name CHAR(100) NULL
, area_desc CHAR(200) NULL
);

INSERT INTO dbo.t_area_dim(area_id)
SELECT DISTINCT 
       acct_area_id
  FROM dbo.stg_p1;

 -- 5) Create the Branch Address Dimension Table

TRUNCATE TABLE dbo.t_branch_add_dim;

INSERT INTO dbo.t_branch_add_dim
SELECT DISTINCT 
       acct_branch_add_id AS branch_add_id
     , acct_branch_add_lat AS branch_add_lat
     , acct_branch_add_lon AS branch_add_lon
     , acct_branch_code AS branch_code
     , acct_branch_add_type AS branch_add_type
     , acct_branch_id AS branch_id
  FROM dbo.stg_p1 AS sp
 ORDER BY branch_add_id;

 -- 6) Create the Branch Dimension Table

DROP TABLE dbo.t_branch_dim;

CREATE TABLE dbo.t_branch_dim
(branch_id   SMALLINT NOT NULL PRIMARY KEY
, branch_code VARCHAR(5) NOT NULL
, branch_desc VARCHAR(100) NOT NULL
, branch_add  INT NOT NULL
, region_id   INT NOT NULL
, area_id     INT NOT NULL
);

INSERT INTO dbo.t_branch_dim(branch_id
                           , branch_code
                           , branch_desc
                           , branch_add
                           , region_id
                           , area_id)
SELECT DISTINCT 
       acct_branch_id
     , acct_branch_code
     , acct_branch_desc
     , acct_branch_add_id
     , acct_region_id
     , acct_area_id
  FROM dbo.stg_p1;
      

 -- 7) Create Customer Account Bridge Table

DROP TABLE t_cust_acct_brg;

CREATE TABLE t_cust_acct_brg
(cust_acct_id         INT IDENTITY(10, 5) NOT NULL PRIMARY KEY
, cust_since_date      DATE NOT NULL
, cust_pri_branch_dist DECIMAL(7, 2) NOT NULL
, cust_id              SMALLINT NOT NULL
, acct_id              INT NOT NULL
);

INSERT INTO t_cust_acct_brg(cust_since_date
                          , cust_pri_branch_dist
                          , cust_id
                          , acct_id)
SELECT DISTINCT 
       cust_since_date
     , cust_pri_branch_dist
     , cust_id
     , acct_id
  FROM dbo.stg_p1;

-- 8) Create Customer Address Dimension Table

TRUNCATE TABLE dbo.t_cust_add_dim;

INSERT INTO dbo.t_cust_add_dim
SELECT DISTINCT 
       cust_add_id 
     , cust_add_lat
     , cust_add_lon
     , cust_add_type
  FROM dbo.stg_p1;

-- 9) Create Customer Dimension Table

DROP TABLE dbo.t_cust_dim;

CREATE TABLE dbo.t_cust_dim
(cust_id            SMALLINT NOT NULL PRIMARY KEY
, cust_first_name    VARCHAR(100) NOT NULL
, cust_last_name     VARCHAR(100) NOT NULL
, cust_birth_date    DATE NOT NULL
, cust_gender        VARCHAR(1) NOT NULL
, cust_add_id        SMALLINT NOT NULL
, cust_pri_branch_id SMALLINT NOT NULL
);

INSERT INTO dbo.t_cust_dim(cust_id
                         , cust_first_name
                         , cust_last_name
                         , cust_birth_date
                         , cust_gender
                         , cust_add_id
                         , cust_pri_branch_id)
SELECT DISTINCT 
       cust_id
     , first_name
     , last_name
     , birth_date
     , gender
     , cust_add_id
     , pri_branch_id
  FROM dbo.stg_p1 AS sp;

-- 10) Create Customer Role Dimension Table

DROP TABLE dbo.t_role_dim;

CREATE TABLE dbo.t_role_dim
(role_id      INT IDENTITY(4, 6) NOT NULL PRIMARY KEY
, role_cust_id SMALLINT NOT NULL
, role_pri_id  SMALLINT NOT NULL
, role_sec_id  SMALLINT NULL
, cust_id SMALLINT NOT NULL
);

INSERT INTO dbo.t_role_dim(role_cust_id
                         , role_pri_id
						 , cust_id)
SELECT DISTINCT 
       acct_cust_role_id
     , pri_cust_id
	 , cust_id
  FROM dbo.stg_p1;

-- 11) Create Customer Product Bridge Table

DROP TABLE t_cust_prod_brg;

CREATE TABLE t_cust_prod_brg
(cust_prod_brg INT IDENTITY(1, 8) NOT NULL PRIMARY KEY
, cust_id       SMALLINT NOT NULL
, prod_id       SMALLINT NOT NULL
);

INSERT INTO t_cust_prod_brg(cust_id
                          , prod_id)
SELECT DISTINCT 
       cust_id
     , prod_id
  FROM dbo.stg_p1 AS sp;

-- 12) Create Product Dimension Table

DROP TABLE dbo.t_prod_dim;

CREATE TABLE dbo.t_prod_dim
(prod_id   SMALLINT NOT NULL PRIMARY KEY
, prod_name VARCHAR(100) NULL
, prod_desc VARCHAR(200) NULL
);

INSERT INTO dbo.t_prod_dim(prod_id)
SELECT DISTINCT 
       prod_id
  FROM dbo.stg_p1 AS sp;
     
-- 13) Create Region Dimension Table

DROP TABLE dbo.t_region_dim;

CREATE TABLE dbo.t_region_dim
(region_id   INT NOT NULL PRIMARY KEY
, region_name CHAR(100) NULL
, region_desc CHAR(200) NULL
);

INSERT INTO dbo.t_region_dim(region_id)
SELECT DISTINCT 
       acct_region_id
  FROM dbo.stg_p1;

-- 14) Create Transaction Type Table

DROP TABLE dbo.t_tran_type_dim;

CREATE TABLE dbo.t_tran_type_dim
(tran_dim_id      INT IDENTITY(3, 9) NOT NULL PRIMARY KEY
, tran_type_id     SMALLINT NOT NULL
, tran_type_code   VARCHAR(5) NOT NULL
, tran_type_desc   VARCHAR(100) NOT NULL
, tran_fee_prct    DECIMAL(4, 3) NOT NULL
, cur_cust_req_ind VARCHAR(1) NOT NULL
, tran_fact_id     INT NOT NULL
);

INSERT INTO dbo.t_tran_type_dim(tran_type_id
                              , tran_type_code
                              , tran_type_desc
                              , tran_fee_prct
                              , cur_cust_req_ind
                              , tran_fact_id)
SELECT DISTINCT 
       p2.tran_type_id
     , p2.tran_type_code
     , p2.tran_type_desc
     , p2.tran_fee_prct
     , p2.cur_cust_req_ind
     , tf.tran_fact_id
  FROM dbo.stg_p2 AS p2
       INNER JOIN
       dbo.t_rt_tran_fact AS tf ON p2.acct_id = tf.acct_id

-- 15) Create Transaction Real Time Fact

DROP TABLE t_rt_tran_fact;

CREATE TABLE t_rt_tran_fact
(tran_fact_id INT IDENTITY(3, 2) NOT NULL PRIMARY KEY
, tran_date    DATE NOT NULL
, tran_time    TIME(7) NOT NULL
, tran_amt     INT NOT NULL
, tran_fee_amt DECIMAL(15, 3) NOT NULL
, acct_id INT NOT NULL 
);
INSERT INTO t_rt_tran_fact(tran_date
                         , tran_time
                         , tran_amt
                         , tran_fee_amt
						 , acct_id)
SELECT DISTINCT 
       p2.tran_date
     , p2.tran_time
     , p2.tran_amt
     , p2.tran_fee_amt
	 , p1.acct_id
  FROM dbo.stg_p2 AS p2
  INNER JOIN dbo.stg_p1 AS p1 ON p2.acct_id = p1.acct_id ;

 -- 16) Add Constraints

ALTER TABLE [dbo].[t_acct_dim]  WITH CHECK ADD  CONSTRAINT [FK_t_acct_dim_t_branch_dim1] FOREIGN KEY([branch_id])
REFERENCES [dbo].[t_branch_dim] ([branch_id])

ALTER TABLE [dbo].[t_acct_fact]  WITH CHECK ADD  CONSTRAINT [FK_t_acct_fact_t_acct_dim] FOREIGN KEY([acct_id])
REFERENCES [dbo].[t_acct_dim] ([acct_id])

ALTER TABLE [dbo].[t_branch_add_dim]  WITH CHECK ADD  CONSTRAINT [FK_t_branch_add_dim_t_branch_dim] FOREIGN KEY([branch_id])
REFERENCES [dbo].[t_branch_dim] ([branch_id])

ALTER TABLE [dbo].[t_branch_dim]  WITH CHECK ADD  CONSTRAINT [FK_t_branch_dim_t_area_dim] FOREIGN KEY([area_id])
REFERENCES [dbo].[t_area_dim] ([area_id])

ALTER TABLE [dbo].[t_branch_dim]  WITH CHECK ADD  CONSTRAINT [FK_t_branch_dim_t_region_dim] FOREIGN KEY([region_id])
REFERENCES [dbo].[t_region_dim] ([region_id])

ALTER TABLE [dbo].[t_cust_acct_brg]  WITH CHECK ADD  CONSTRAINT [FK_t_cust_acct_brg_t_acct_dim] FOREIGN KEY([acct_id])
REFERENCES [dbo].[t_acct_dim] ([acct_id])

ALTER TABLE [dbo].[t_cust_acct_brg]  WITH CHECK ADD  CONSTRAINT [FK_t_cust_acct_brg_t_cust_dim] FOREIGN KEY([cust_id])
REFERENCES [dbo].[t_cust_dim] ([cust_id])

ALTER TABLE [dbo].[t_cust_dim]  WITH CHECK ADD  CONSTRAINT [FK_t_cust_dim_t_cust_add_dim] FOREIGN KEY([cust_add_id])
REFERENCES [dbo].[t_cust_add_dim] ([cust_add_id])

ALTER TABLE [dbo].[t_cust_prod_brg]  WITH CHECK ADD  CONSTRAINT [FK_t_cust_prod_brg_t_cust_dim] FOREIGN KEY([cust_id])
REFERENCES [dbo].[t_cust_dim] ([cust_id])

ALTER TABLE [dbo].[t_cust_prod_brg]  WITH CHECK ADD  CONSTRAINT [FK_t_cust_prod_brg_t_prod_dim] FOREIGN KEY([prod_id])
REFERENCES [dbo].[t_prod_dim] ([prod_id])

ALTER TABLE [dbo].[t_role_dim]  WITH CHECK ADD  CONSTRAINT [FK_t_role_dim_t_cust_dim] FOREIGN KEY([cust_id])
REFERENCES [dbo].[t_cust_dim] ([cust_id])

ALTER TABLE [dbo].[t_tran_type_dim]  WITH CHECK ADD  CONSTRAINT [FK_t_tran_type_dim_t_rt_tran_fact] FOREIGN KEY([tran_fact_id])
REFERENCES [dbo].[t_rt_tran_fact] ([tran_fact_id])

ALTER TABLE [dbo].[t_rt_tran_fact]  WITH CHECK ADD  CONSTRAINT [FK_t_rt_tran_fact_t_acct_dim] FOREIGN KEY([acct_id])
REFERENCES [dbo].[t_acct_dim] ([acct_id])





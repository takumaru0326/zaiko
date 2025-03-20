/* ------------------------------------- */
-- テーブル名：T10SHIP
/* ------------------------------------- */
if exists (select * from sysobjects where id = object_id(N'dbo.T10SHIP') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table dbo.T10SHIP
GO

CREATE TABLE dbo.T10SHIP(
       ID                       numeric NOT NULL IDENTITY(1,1), 	
       アイテムCD                   nvarchar(20) NULL, 		
       アイテム出庫数                  int NULL DEFAULT 0, 		
       アイテム発注要FLG               tinyint NULL DEFAULT 0, 		
       アイテム出庫YMD                char(8) NULL, 		
       担当CD                     int NULL, 		
       登録日                      smalldatetime NULL, 		
       登録者ID                    numeric NULL, 		
       更新日                      smalldatetime NULL, 		
       更新者ID                    numeric NULL, 		
       削除FLG                    tinyint NULL DEFAULT 0, 		
       IPADDR                   char(15) NULL, 		
       GID                      char(10) NULL, 		
)
GO

ALTER TABLE dbo.T10SHIP
       ADD CONSTRAINT XPK_T10SHIP PRIMARY KEY (ID)
GO

/* ------------------------------------- */
-- テーブル名：T20INSUU
/* ------------------------------------- */
if exists (select * from sysobjects where id = object_id(N'dbo.T20INSUU') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table dbo.T20INSUU
GO

CREATE TABLE dbo.T20INSUU(
       ID                       numeric NOT NULL IDENTITY(1,1), 	
       アイテムCD                   nvarchar(20) NULL, 		
       アイテム入荷数                  int NULL DEFAULT 0, 		
       アイテム入荷YMD                char(8) NULL, 		
       担当CD                     int NULL, 		
       登録日                      smalldatetime NULL, 		
       登録者ID                    numeric NULL, 		
       更新日                      smalldatetime NULL, 		
       更新者ID                    numeric NULL, 		
       削除FLG                    tinyint NULL DEFAULT 0, 		
       IPADDR                   char(15) NULL, 		
       GID                      char(10) NULL, 		
)
GO

ALTER TABLE dbo.T20INSUU
       ADD CONSTRAINT XPK_T20INSUU PRIMARY KEY (ID)
GO

/* ------------------------------------- */
-- テーブル名：M70ITEM
/* ------------------------------------- */
if exists (select * from sysobjects where id = object_id(N'dbo.M70ITEM') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table dbo.M70ITEM
GO

CREATE TABLE dbo.M70ITEM(
       ID                       numeric NOT NULL IDENTITY(1,1), 	
       アイテムCD                   nvarchar(20) NULL, 		
       アイテム区分                   tinyint NULL, 		
       アイテム名                    nvarchar(50) NULL, 		
       アイテム名略称                  nvarchar(20) NULL, 		
       アイテム在庫数                  int NULL DEFAULT 0, 		
       アイテム下限数                  int NULL DEFAULT 0, 		
       アイテム金額                   money NULL DEFAULT 0, 		
       アイテム棚番号                  nvarchar(20) NULL, 		
       アイテム使用期限                 char(8) NULL, 		
       アイテム備考                   nvarchar(200) NULL, 		
       登録日                      smalldatetime NULL, 		
       登録者ID                    numeric NULL, 		
       更新日                      smalldatetime NULL, 		
       更新者ID                    numeric NULL, 		
       削除FLG                    tinyint NULL DEFAULT 0, 		
       IPADDR                   char(15) NULL, 		
       GID                      char(10) NULL, 		
)
GO

ALTER TABLE dbo.M70ITEM
       ADD CONSTRAINT XPK_M70ITEM PRIMARY KEY (ID)
GO

/* ------------------------------------- */
-- テーブル名：M80担当者
/* ------------------------------------- */
if exists (select * from sysobjects where id = object_id(N'dbo.M80担当者') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table dbo.M80担当者
GO

CREATE TABLE dbo.M80担当者(
       ID                       numeric NOT NULL IDENTITY(1,1), 	
       担当CD                     int NULL, 		
       担当名                      nvarchar(50) NULL, 		
       募集人CD                    nvarchar(13) NULL, 		
       権限CD                     tinyint NULL DEFAULT 0, 		
       担当備考                     nvarchar(100) NULL, 		
       PASSWORD                 nvarchar(50) NULL, 		
       登録日                      smalldatetime NULL, 		
       登録者ID                    numeric NULL, 		
       更新日                      smalldatetime NULL, 		
       更新者ID                    numeric NULL, 		
       削除FLG                    tinyint NULL DEFAULT 0, 		
       IPADDR                   char(15) NULL, 		
       GID                      char(10) NULL, 		
       最終Login日                 smalldatetime NULL, 		
)
GO

ALTER TABLE dbo.M80担当者
       ADD CONSTRAINT XPK_M80担当者 PRIMARY KEY (ID)
GO

/* ------------------------------------- */
-- テーブル名：M90共通
/* ------------------------------------- */
if exists (select * from sysobjects where id = object_id(N'dbo.M90共通') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table dbo.M90共通
GO

CREATE TABLE dbo.M90共通(
       ID                       numeric NOT NULL IDENTITY(1,1), 	
       種別CD                     int NULL, 		
       種別                       nvarchar(50) NULL, 		
       主CD                      int NULL, 		
       名称                       nvarchar(50) NULL, 		
       Control                  nvarchar(100) NULL, 		
       DefaultSelect            tinyint NULL DEFAULT 0, 		
       主CDDataType              char(1) NULL, 		
       登録日                      smalldatetime NULL, 		
       登録者ID                    numeric NULL, 		
       更新日                      smalldatetime NULL, 		
       更新者ID                    numeric NULL, 		
       削除FLG                    tinyint NULL DEFAULT 0, 		
       IPADDR                   char(15) NULL, 		
       GID                      char(10) NULL, 		
)
GO

ALTER TABLE dbo.M90共通
       ADD CONSTRAINT XPK_M90共通 PRIMARY KEY (ID)
GO

/* ------------------------------------- */
-- テーブル名：MA0画面制御
/* ------------------------------------- */
if exists (select * from sysobjects where id = object_id(N'dbo.MA0画面制御') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table dbo.MA0画面制御
GO

CREATE TABLE dbo.MA0画面制御(
       ID                       numeric NOT NULL IDENTITY(1,1), 	
       画面番号                     nvarchar(4) NULL, 		
       画面名称                     nvarchar(50) NULL, 		
       背景色                      nvarchar(10) NULL, 		
       文字色                      nvarchar(10) NULL, 		
       実行pro                    nvarchar(200) NULL, 		
       権限LV                     tinyint NULL DEFAULT 0, 		
       登録日                      smalldatetime NULL, 		
       登録者ID                    numeric NULL, 		
       更新日                      smalldatetime NULL, 		
       更新者ID                    numeric NULL, 		
       削除FLG                    tinyint NULL DEFAULT 0, 		
       IPADDR                   char(15) NULL, 		
       GID                      char(10) NULL, 		
)
GO

ALTER TABLE dbo.MA0画面制御
       ADD CONSTRAINT XPK_MA0画面制御 PRIMARY KEY (ID)
GO


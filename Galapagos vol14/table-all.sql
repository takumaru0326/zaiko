/* ------------------------------------- */
-- �e�[�u�����FT10SHIP
/* ------------------------------------- */
if exists (select * from sysobjects where id = object_id(N'dbo.T10SHIP') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table dbo.T10SHIP
GO

CREATE TABLE dbo.T10SHIP(
       ID                       numeric NOT NULL IDENTITY(1,1), 	
       �A�C�e��CD                   nvarchar(20) NULL, 		
       �A�C�e���o�ɐ�                  int NULL DEFAULT 0, 		
       �A�C�e�������vFLG               tinyint NULL DEFAULT 0, 		
       �A�C�e���o��YMD                char(8) NULL, 		
       �S��CD                     int NULL, 		
       �o�^��                      smalldatetime NULL, 		
       �o�^��ID                    numeric NULL, 		
       �X�V��                      smalldatetime NULL, 		
       �X�V��ID                    numeric NULL, 		
       �폜FLG                    tinyint NULL DEFAULT 0, 		
       IPADDR                   char(15) NULL, 		
       GID                      char(10) NULL, 		
)
GO

ALTER TABLE dbo.T10SHIP
       ADD CONSTRAINT XPK_T10SHIP PRIMARY KEY (ID)
GO

/* ------------------------------------- */
-- �e�[�u�����FT20INSUU
/* ------------------------------------- */
if exists (select * from sysobjects where id = object_id(N'dbo.T20INSUU') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table dbo.T20INSUU
GO

CREATE TABLE dbo.T20INSUU(
       ID                       numeric NOT NULL IDENTITY(1,1), 	
       �A�C�e��CD                   nvarchar(20) NULL, 		
       �A�C�e�����א�                  int NULL DEFAULT 0, 		
       �A�C�e������YMD                char(8) NULL, 		
       �S��CD                     int NULL, 		
       �o�^��                      smalldatetime NULL, 		
       �o�^��ID                    numeric NULL, 		
       �X�V��                      smalldatetime NULL, 		
       �X�V��ID                    numeric NULL, 		
       �폜FLG                    tinyint NULL DEFAULT 0, 		
       IPADDR                   char(15) NULL, 		
       GID                      char(10) NULL, 		
)
GO

ALTER TABLE dbo.T20INSUU
       ADD CONSTRAINT XPK_T20INSUU PRIMARY KEY (ID)
GO

/* ------------------------------------- */
-- �e�[�u�����FM70ITEM
/* ------------------------------------- */
if exists (select * from sysobjects where id = object_id(N'dbo.M70ITEM') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table dbo.M70ITEM
GO

CREATE TABLE dbo.M70ITEM(
       ID                       numeric NOT NULL IDENTITY(1,1), 	
       �A�C�e��CD                   nvarchar(20) NULL, 		
       �A�C�e���敪                   tinyint NULL, 		
       �A�C�e����                    nvarchar(50) NULL, 		
       �A�C�e��������                  nvarchar(20) NULL, 		
       �A�C�e���݌ɐ�                  int NULL DEFAULT 0, 		
       �A�C�e��������                  int NULL DEFAULT 0, 		
       �A�C�e�����z                   money NULL DEFAULT 0, 		
       �A�C�e���I�ԍ�                  nvarchar(20) NULL, 		
       �A�C�e���g�p����                 char(8) NULL, 		
       �A�C�e�����l                   nvarchar(200) NULL, 		
       �o�^��                      smalldatetime NULL, 		
       �o�^��ID                    numeric NULL, 		
       �X�V��                      smalldatetime NULL, 		
       �X�V��ID                    numeric NULL, 		
       �폜FLG                    tinyint NULL DEFAULT 0, 		
       IPADDR                   char(15) NULL, 		
       GID                      char(10) NULL, 		
)
GO

ALTER TABLE dbo.M70ITEM
       ADD CONSTRAINT XPK_M70ITEM PRIMARY KEY (ID)
GO

/* ------------------------------------- */
-- �e�[�u�����FM80�S����
/* ------------------------------------- */
if exists (select * from sysobjects where id = object_id(N'dbo.M80�S����') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table dbo.M80�S����
GO

CREATE TABLE dbo.M80�S����(
       ID                       numeric NOT NULL IDENTITY(1,1), 	
       �S��CD                     int NULL, 		
       �S����                      nvarchar(50) NULL, 		
       ��W�lCD                    nvarchar(13) NULL, 		
       ����CD                     tinyint NULL DEFAULT 0, 		
       �S�����l                     nvarchar(100) NULL, 		
       PASSWORD                 nvarchar(50) NULL, 		
       �o�^��                      smalldatetime NULL, 		
       �o�^��ID                    numeric NULL, 		
       �X�V��                      smalldatetime NULL, 		
       �X�V��ID                    numeric NULL, 		
       �폜FLG                    tinyint NULL DEFAULT 0, 		
       IPADDR                   char(15) NULL, 		
       GID                      char(10) NULL, 		
       �ŏILogin��                 smalldatetime NULL, 		
)
GO

ALTER TABLE dbo.M80�S����
       ADD CONSTRAINT XPK_M80�S���� PRIMARY KEY (ID)
GO

/* ------------------------------------- */
-- �e�[�u�����FM90����
/* ------------------------------------- */
if exists (select * from sysobjects where id = object_id(N'dbo.M90����') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table dbo.M90����
GO

CREATE TABLE dbo.M90����(
       ID                       numeric NOT NULL IDENTITY(1,1), 	
       ���CD                     int NULL, 		
       ���                       nvarchar(50) NULL, 		
       ��CD                      int NULL, 		
       ����                       nvarchar(50) NULL, 		
       Control                  nvarchar(100) NULL, 		
       DefaultSelect            tinyint NULL DEFAULT 0, 		
       ��CDDataType              char(1) NULL, 		
       �o�^��                      smalldatetime NULL, 		
       �o�^��ID                    numeric NULL, 		
       �X�V��                      smalldatetime NULL, 		
       �X�V��ID                    numeric NULL, 		
       �폜FLG                    tinyint NULL DEFAULT 0, 		
       IPADDR                   char(15) NULL, 		
       GID                      char(10) NULL, 		
)
GO

ALTER TABLE dbo.M90����
       ADD CONSTRAINT XPK_M90���� PRIMARY KEY (ID)
GO

/* ------------------------------------- */
-- �e�[�u�����FMA0��ʐ���
/* ------------------------------------- */
if exists (select * from sysobjects where id = object_id(N'dbo.MA0��ʐ���') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table dbo.MA0��ʐ���
GO

CREATE TABLE dbo.MA0��ʐ���(
       ID                       numeric NOT NULL IDENTITY(1,1), 	
       ��ʔԍ�                     nvarchar(4) NULL, 		
       ��ʖ���                     nvarchar(50) NULL, 		
       �w�i�F                      nvarchar(10) NULL, 		
       �����F                      nvarchar(10) NULL, 		
       ���spro                    nvarchar(200) NULL, 		
       ����LV                     tinyint NULL DEFAULT 0, 		
       �o�^��                      smalldatetime NULL, 		
       �o�^��ID                    numeric NULL, 		
       �X�V��                      smalldatetime NULL, 		
       �X�V��ID                    numeric NULL, 		
       �폜FLG                    tinyint NULL DEFAULT 0, 		
       IPADDR                   char(15) NULL, 		
       GID                      char(10) NULL, 		
)
GO

ALTER TABLE dbo.MA0��ʐ���
       ADD CONSTRAINT XPK_MA0��ʐ��� PRIMARY KEY (ID)
GO


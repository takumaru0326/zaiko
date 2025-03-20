/* ------------------------------------- */
-- テーブル名：T10SHIP
/* ------------------------------------- */

CREATE TABLE T10SHIP(
       ID                       INT AUTO_INCREMENT,PRIMARY KEY(ID), 	
       アイテムCD               VARCHAR(20) NULL, 		
       アイテム出庫数           INT NULL DEFAULT 0, 		
       アイテム出庫YMD          CHAR(8) NULL DEFAULT 0, 		
       担当CD                   INT NULL, 		
       登録日                   TIMESTAMP NULL, 		
       登録者ID                 INT NULL, 		
       更新日                   TIMESTAMP NULL, 		
       更新者ID                 INT NULL, 		
       削除FLG                  SMALLINT NULL DEFAULT 0, 		
       IPADDR                   CHAR(15) NULL, 		
       GID                      CHAR(10) NULL		
);


/* ------------------------------------- */
-- テーブル名：T20INSUU
/* ------------------------------------- */

CREATE TABLE T20INSUU(
       ID                       INT AUTO_INCREMENT,PRIMARY KEY(ID), 	
       アイテムCD               VARCHAR(20) NULL, 		
       アイテム入荷数           INT NULL DEFAULT 0, 		
       アイテム入荷YMD          CHAR(8) NULL, 		
       担当CD                   INT NULL, 		
       登録日                   TIMESTAMP NULL, 		
       登録者ID                 INT NULL, 		
       更新日                   TIMESTAMP NULL, 		
       更新者ID                 INT NULL, 		
       削除FLG                  SMALLINT NULL DEFAULT 0, 		
       IPADDR                   CHAR(15) NULL, 		
       GID                      CHAR(10) NULL 		
);


/* ------------------------------------- */
-- テーブル名：M70ITEM
/* ------------------------------------- */

CREATE TABLE M70ITEM(
       ID                       INT AUTO_INCREMENT,PRIMARY KEY(ID), 	
       アイテムCD               VARCHAR(20) NULL, 		
       アイテム区分             SMALLINT NULL, 		
       アイテム名               VARCHAR(50) NULL, 		
       アイテム在庫数           INT NULL DEFAULT 0, 		
       アイテム下限数           INT NULL DEFAULT 0, 		
       アイテム金額             INT NULL DEFAULT 0, 		
       アイテム棚番号           VARCHAR(20) NULL, 		
       アイテム使用期限         CHAR(8) NULL, 		
       アイテム備考             VARCHAR(200) NULL, 		
       登録日                   TIMESTAMP NULL, 		
       登録者ID                 INT NULL, 		
       更新日                   TIMESTAMP NULL, 		
       更新者ID                 INT NULL, 		
       削除FLG                  SMALLINT NULL DEFAULT 0, 		
       IPADDR                   CHAR(15) NULL, 		
       GID                      CHAR(10) NULL 		
);


/* ------------------------------------- */
-- テーブル名：M80TANTO
/* ------------------------------------- */

CREATE TABLE M80TANTO(
       ID                       INT AUTO_INCREMENT,PRIMARY KEY(ID), 	
       担当CD                   INT NULL, 		
       担当名                   VARCHAR(50) NULL, 		
       ログインCD               VARCHAR(13) NULL, 		
       担当備考                 VARCHAR(100) NULL, 		
       PASSWORD                 VARCHAR(50) NULL, 		
       権限CD                   SMALLINT NULL DEFAULT 0, 		
       登録日                   TIMESTAMP NULL, 		
       登録者ID                 INT NULL, 		
       更新日                   TIMESTAMP NULL, 		
       更新者ID                 INT NULL, 		
       削除FLG                  SMALLINT NULL DEFAULT 0, 		
       IPADDR                   CHAR(15) NULL, 		
       GID                      CHAR(10) NULL, 		
       最終Login日              DATETIME NULL 		
);


/* ------------------------------------- */
-- テーブル名：M90共通
/* ------------------------------------- */

CREATE TABLE M90共通(
       ID                       INT AUTO_INCREMENT,PRIMARY KEY(ID), 	
       種別CD                   INT NULL, 		
       種別                     VARCHAR(50) NULL, 		
       主CD                     INT NULL, 		
       名称                     VARCHAR(50) NULL, 		
       Control                  VARCHAR(100) NULL, 		
       DefaultSelect            SMALLINT NULL DEFAULT 0, 		
       主CDDataType             CHAR(1) NULL, 		
       登録日                   TIMESTAMP NULL, 		
       登録者ID                 INT NULL, 		
       更新日                   TIMESTAMP NULL, 		
       更新者ID                 INT NULL, 		
       削除FLG                  SMALLINT NULL DEFAULT 0, 		
       IPADDR                   CHAR(15) NULL, 		
       GID                      CHAR(10) NULL 		
);



/* ------------------------------------- */
-- テーブル名：MA0画面制御
/* ------------------------------------- */

CREATE TABLE MA0画面制御(
       ID                       INT AUTO_INCREMENT,PRIMARY KEY(ID), 	
       画面番号                 VARCHAR(4) NULL, 		
       画面名称                 VARCHAR(50) NULL, 		
       背景色                   VARCHAR(10) NULL, 		
       文字色                   VARCHAR(10) NULL, 		
       実行pro                  VARCHAR(200) NULL, 		
       権限LV                   SMALLINT NULL DEFAULT 0, 		
       登録日                   TIMESTAMP NULL, 		
       登録者ID                 INT NULL, 		
       更新日                   TIMESTAMP NULL, 		
       更新者ID                 INT NULL, 		
       削除FLG                  SMALLINT NULL DEFAULT 0, 		
       IPADDR                   CHAR(15) NULL, 		
       GID                      CHAR(10) NULL 		
);

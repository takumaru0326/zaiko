--------------------------------------- */ 
-- テーブル名：T10SHIP
--------------------------------------- */ 
CREATE TABLE IF NOT EXISTS T10SHIP(
        ID		INTEGER PRIMARY KEY AUTOINCREMENT,	
	アイテムCD	TEXT NOT NULL, 		
	アイテム出庫数	INTEGER	DEFAULT (0),  		
	アイテム出庫YMD	TEXT,		
	担当CD		INTEGER,
	登録日		TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 		
	登録者ID	INTEGER, 		
	更新日		TIMESTAMP, 		
	更新者ID	INTEGER, 		
	削除FLG         INTEGER	DEFAULT (0), 		
	IPADDR          TEXT, 		
	GID             TEXT
);


--------------------------------------- */ 
-- テーブル名：T20INSUU
--------------------------------------- */ 
CREATE TABLE IF NOT EXISTS T20INSUU(
        ID		INTEGER PRIMARY KEY AUTOINCREMENT,	
	アイテムCD	TEXT NOT NULL, 		
	アイテム入荷数	INTEGER	DEFAULT (0), 		
	アイテム入荷YMD	TEXT,	
	担当CD		INTEGER,
	登録日		TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 		
	登録者ID	INTEGER, 		
	更新日		TIMESTAMP, 		
	更新者ID	INTEGER, 		
	削除FLG         INTEGER	DEFAULT (0), 		
	IPADDR          TEXT,
	GID             TEXT
);

--------------------------------------- */
-- テーブル名：M70ITEM
--------------------------------------- */
CREATE TABLE IF NOT EXISTS M70ITEM (
        ID		INTEGER PRIMARY KEY AUTOINCREMENT,
	アイテムCD	TEXT NOT NULL, 		
	アイテム区分	INTEGER, 		
        アイテム名	TEXT NOT NULL,
        アイテム在庫数	INTEGER,
        アイテム下限数	INTEGER, 		
	アイテム金額	INTEGER,  		
	アイテム棚番号  TEXT,  		
	アイテム使用期限 TEXT, 		
	アイテム備考    TEXT, 		
	登録日		TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 		
	登録者ID	INTEGER, 		
	更新日		TIMESTAMP, 		
	更新者ID	INTEGER, 		
	削除FLG         INTEGER	DEFAULT (0), 		
	IPADDR          TEXT, 		
	GID             TEXT
);
CREATE INDEX IF NOT EXISTS M70ITEM_アイテムCD_idx ON M70ITEM (アイテムCD);

--------------------------------------- */
-- テーブル名：M80担当者
--------------------------------------- */
CREATE TABLE IF NOT EXISTS M80担当者(
	ID		INTEGER PRIMARY KEY AUTOINCREMENT,
	担当CD		INTEGER,
	担当名		TEXT NOT NULL,		
	ログインCD	TEXT,		
	担当備考	TEXT, 		
	PASSWORD	TEXT,		
	権限CD		INTEGER,		
	登録日		TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 		
	登録者ID	INTEGER, 		
	更新日		TIMESTAMP, 		
	更新者ID	INTEGER, 		
	削除FLG         INTEGER	DEFAULT (0), 		
	IPADDR          TEXT, 		
	GID             TEXT
        最終Login日	TIMESTAMP 		
);
CREATE INDEX IF NOT EXISTS M80担当者_担当CD_idx ON M80担当者 (担当CD);

--------------------------------------- */
-- テーブル名：M90共通
--------------------------------------- */
CREATE TABLE IF NOT EXISTS M90共通(
	ID		INTEGER PRIMARY KEY AUTOINCREMENT,
	種別CD		INTEGER,		
	種別		TEXT, 		
	主CD		INTEGER,		
	名称		TEXT, 		
	Control		TEXT,  		
	DefaultSelect	INTEGER	DEFAULT (0),		
	主CDDataType	TEXT, 		
	登録日		TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 		
	登録者ID	INTEGER, 		
	更新日		TIMESTAMP, 		
	更新者ID	INTEGER, 		
	削除FLG         INTEGER	DEFAULT (0), 		
	IPADDR          TEXT, 		
	GID             TEXT
);
CREATE INDEX IF NOT EXISTS M90共通_種別_idx ON M90共通 (種別);

--------------------------------------- */
-- テーブル名：MA0画面制御
--------------------------------------- */
CREATE TABLE IF NOT EXISTS MA0画面制御(
	ID		INTEGER PRIMARY KEY AUTOINCREMENT,
	画面番号	TEXT,	
	画面名称	TEXT, 		
	背景色		TEXT, 		
	文字色		TEXT,		
	実行pro		TEXT,		
	権限LV		INTEGER	DEFAULT (0),		
	登録日		TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 		
	登録者ID	INTEGER, 		
	更新日		TIMESTAMP, 		
	更新者ID	INTEGER, 		
	削除FLG         INTEGER	DEFAULT (0), 		
	IPADDR          TEXT, 		
	GID             TEXT
);
CREATE INDEX IF NOT EXISTS MA0画面制御_画面番号_idx ON MA0画面制御 (画面番号);

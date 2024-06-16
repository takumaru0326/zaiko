/* ------------------------------------- */
-- テーブル名：M70ITEM
/* ------------------------------------- */
INSERT INTO M70ITEM(アイテムCD,アイテム名) VALUES ('230001','パンフレット1')
INSERT INTO M70ITEM(アイテムCD,アイテム名) VALUES ('230002','パンフレット2')
INSERT INTO M70ITEM(アイテムCD,アイテム名) VALUES ('230003','パンフレット3')
INSERT INTO M70ITEM(アイテムCD,アイテム名) VALUES ('230004','パンフレット4')
INSERT INTO M70ITEM(アイテムCD,アイテム名) VALUES ('230005','パンフレット5')
INSERT INTO M70ITEM(アイテムCD,アイテム名) VALUES ('230006','パンフレット6')
INSERT INTO M70ITEM(アイテムCD,アイテム名) VALUES ('230007','パンフレット7')
INSERT INTO M70ITEM(アイテムCD,アイテム名) VALUES ('230008','パンフレット8')
INSERT INTO M70ITEM(アイテムCD,アイテム名) VALUES ('230009','パンフレット9')
INSERT INTO M70ITEM(アイテムCD,アイテム名) VALUES ('230010','パンフレット10')
INSERT INTO M70ITEM(アイテムCD,アイテム名) VALUES ('230011','パンフレット11')
INSERT INTO M70ITEM(アイテムCD,アイテム名) VALUES ('230012','パンフレット12')
INSERT INTO M70ITEM(アイテムCD,アイテム名) VALUES ('230013','パンフレット13')
INSERT INTO M70ITEM(アイテムCD,アイテム名) VALUES ('230014','パンフレット14')


/* ------------------------------------- */
-- テーブル名：M80担当者
/* ------------------------------------- */
INSERT INTO M80担当者(担当CD,担当名,募集人CD) VALUES ('9999','管理者','12345')


/* ------------------------------------- */
-- テーブル名：M90共通
/* ------------------------------------- */
INSERT INTO M90共通(種別CD,種別,主CD,名称,Control,DefaultSelect) VALUES ('90','元号',5,'令和','','1')
INSERT INTO M90共通(種別CD,種別,主CD,名称,Control,DefaultSelect) VALUES ('110','アイテム区分',0,'-----','','1')
INSERT INTO M90共通(種別CD,種別,主CD,名称,Control,DefaultSelect) VALUES ('110','アイテム区分',10,'パンフレット・ちらし','','0')
INSERT INTO M90共通(種別CD,種別,主CD,名称,Control,DefaultSelect) VALUES ('110','アイテム区分',80,'封筒','','0')
INSERT INTO M90共通(種別CD,種別,主CD,名称,Control,DefaultSelect) VALUES ('110','アイテム区分',90,'その他帳票','','0')
INSERT INTO M90共通(種別CD,種別,主CD,名称,Control,DefaultSelect) VALUES ('91000','SORT順',10,'在庫数　昇順','','0')
INSERT INTO M90共通(種別CD,種別,主CD,名称,Control,DefaultSelect) VALUES ('92073','並替',1,'昇順','','0')
INSERT INTO M90共通(種別CD,種別,主CD,名称,Control,DefaultSelect) VALUES ('92073','並替',2,'降順','','0')
INSERT INTO M90共通(種別CD,種別,主CD,名称,Control,DefaultSelect) VALUES ('92081','表示件数',10,'10件','','0')
INSERT INTO M90共通(種別CD,種別,主CD,名称,Control,DefaultSelect) VALUES ('92081','表示件数',20,'20件','','0')
INSERT INTO M90共通(種別CD,種別,主CD,名称,Control,DefaultSelect) VALUES ('92081','表示件数',30,'30件','','1')
INSERT INTO M90共通(種別CD,種別,主CD,名称,Control,DefaultSelect) VALUES ('92081','表示件数',50,'50件','','0')
INSERT INTO M90共通(種別CD,種別,主CD,名称,Control,DefaultSelect) VALUES ('92081','表示件数',100,'100件','','0')
INSERT INTO M90共通(種別CD,種別,主CD,名称,Control,DefaultSelect) VALUES ('92081','表示件数',200,'200件','','0')


/* ------------------------------------- */
-- テーブル名：MA0画面制御
/* ------------------------------------- */
INSERT INTO MA0画面制御(画面番号,画面名称,背景色,文字色,実行pro,権限設定有無FLG) VALUES ('1000','在庫管理','#006400','#FFFFFF','parent.top.location.href=''../eh10/eh1000_menu.asp''',1)
INSERT INTO MA0画面制御(画面番号,画面名称,背景色,文字色,実行pro,権限設定有無FLG) VALUES ('1010','出庫','#FF45A0 ','#000000','parent.top.location.href=''../eh10/eh1010.asp?fnc=add''',1)
INSERT INTO MA0画面制御(画面番号,画面名称,背景色,文字色,実行pro,権限設定有無FLG) VALUES ('1020','入庫','#C0C0C0','#000000','parent.top.location.href=''../eh10/eh1020.asp?fnc=add''',1)
INSERT INTO MA0画面制御(画面番号,画面名称,背景色,文字色,実行pro,権限設定有無FLG) VALUES ('1030','在庫一覧','#666699 ','#000000','parent.top.location.href=''../eh10/eh1030.asp''',1)
INSERT INTO MA0画面制御(画面番号,画面名称,背景色,文字色,実行pro,権限設定有無FLG) VALUES ('1050','出庫履歴','#FF45A0   ','#FFFFFF','parent.top.location.href=''../eh10/eh1050.asp''',1)
INSERT INTO MA0画面制御(画面番号,画面名称,背景色,文字色,実行pro,権限設定有無FLG) VALUES ('1060','入庫履歴','#1E90FF  ','#FFFFFF','parent.top.location.href=''../eh10/eh1060.asp''',1)
INSERT INTO MA0画面制御(画面番号,画面名称,背景色,文字色,実行pro,権限設定有無FLG) VALUES ('1090','アイテム管理','#FF4500','#000000','parent.top.location.href=''../eh10/eh1090.asp''',1)
INSERT INTO MA0画面制御(画面番号,画面名称,背景色,文字色,実行pro,権限設定有無FLG) VALUES ('109U','アイテム','#C0C0C0 ','#000000','',1)
INSERT INTO MA0画面制御(画面番号,画面名称,背景色,文字色,実行pro,権限設定有無FLG) VALUES ('10A0','アイテム発注','#FF4500','#000000','parent.top.location.href=''../eh10/eh10A0.asp''',1)
INSERT INTO MA0画面制御(画面番号,画面名称,背景色,文字色,実行pro,権限設定有無FLG) VALUES ('10B0','出庫集計','#FF4500','#000000','parent.top.location.href=''../eh10/eh10B0.asp''',1)
INSERT INTO MA0画面制御(画面番号,画面名称,背景色,文字色,実行pro,権限設定有無FLG) VALUES ('10W0','担当者マスタ登録更新','#FF4500','#000000','parent.top.location.href=''../eh10/eh10W0.asp''',1)
INSERT INTO MA0画面制御(画面番号,画面名称,背景色,文字色,実行pro,権限設定有無FLG) VALUES ('10Y0','共通マスタ登録更新','#FF4500','#000000','parent.top.location.href=''../eh10/eh10Y0.asp''',0)
INSERT INTO MA0画面制御(画面番号,画面名称,背景色,文字色,実行pro,権限設定有無FLG) VALUES ('10YU','共通マスタ','#FF4500','#000000','',1)
INSERT INTO MA0画面制御(画面番号,画面名称,背景色,文字色,実行pro,権限設定有無FLG) VALUES ('10X0','画面使用権限設定','#FF4500','#000000','parent.top.location.href=''../eh10/eh10X0.asp''',4)


/* ------------------------------------- */
-- テーブル名：MA1画面制御明細
/* ------------------------------------- */
INSERT INTO MA1画面制御明細(担当CD,画面番号,権限) VALUES ('9999','1000','4')
INSERT INTO MA1画面制御明細(担当CD,画面番号,権限) VALUES ('9999','1010','4')
INSERT INTO MA1画面制御明細(担当CD,画面番号,権限) VALUES ('9999','1020','4')
INSERT INTO MA1画面制御明細(担当CD,画面番号,権限) VALUES ('9999','1030','4')
INSERT INTO MA1画面制御明細(担当CD,画面番号,権限) VALUES ('9999','1050','4')
INSERT INTO MA1画面制御明細(担当CD,画面番号,権限) VALUES ('9999','1060','4')
INSERT INTO MA1画面制御明細(担当CD,画面番号,権限) VALUES ('9999','1090','4')
INSERT INTO MA1画面制御明細(担当CD,画面番号,権限) VALUES ('9999','109U','4')
INSERT INTO MA1画面制御明細(担当CD,画面番号,権限) VALUES ('9999','10A0','4')
INSERT INTO MA1画面制御明細(担当CD,画面番号,権限) VALUES ('9999','10B0','4')
INSERT INTO MA1画面制御明細(担当CD,画面番号,権限) VALUES ('9999','10W0','4')
INSERT INTO MA1画面制御明細(担当CD,画面番号,権限) VALUES ('9999','10Y0','4')
INSERT INTO MA1画面制御明細(担当CD,画面番号,権限) VALUES ('9999','10YU','4')
INSERT INTO MA1画面制御明細(担当CD,画面番号,権限) VALUES ('9999','10X0','4')




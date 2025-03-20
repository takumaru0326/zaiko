INSERT INTO ma0画面制御(画面番号,画面名称,背景色,文字色,実行pro,権限LV) VALUES ('1010','出庫','#FF45A0 ','#000000','eh1010',1);
INSERT INTO ma0画面制御(画面番号,画面名称,背景色,文字色,実行pro,権限LV) VALUES ('1020','入庫','#C0C0C0','#000000','eh1020',3);
INSERT INTO ma0画面制御(画面番号,画面名称,背景色,文字色,実行pro,権限LV) VALUES ('1030','在庫一覧','#666699 ','#000000','eh1030',1);
INSERT INTO ma0画面制御(画面番号,画面名称,背景色,文字色,実行pro,権限LV) VALUES ('103U','在庫一覧','#666699 ','#000000','',3);
INSERT INTO ma0画面制御(画面番号,画面名称,背景色,文字色,実行pro,権限LV) VALUES ('1050','出庫履歴','#FF45A0   ','#FFFFFF','eh1050',1);
INSERT INTO ma0画面制御(画面番号,画面名称,背景色,文字色,実行pro,権限LV) VALUES ('105U','出庫履歴','#FF45A0   ','#FFFFFF','',3);
INSERT INTO ma0画面制御(画面番号,画面名称,背景色,文字色,実行pro,権限LV) VALUES ('1060','入庫履歴','#1E90FF  ','#FFFFFF','eh1060',3);
INSERT INTO ma0画面制御(画面番号,画面名称,背景色,文字色,実行pro,権限LV) VALUES ('106U','入庫履歴','#1E90FF  ','#FFFFFF','',3);
INSERT INTO ma0画面制御(画面番号,画面名称,背景色,文字色,実行pro,権限LV) VALUES ('1090','アイテム管理','#FF4500','#000000','eh1090',3);
INSERT INTO ma0画面制御(画面番号,画面名称,背景色,文字色,実行pro,権限LV) VALUES ('109U','アイテム','#FF4500','#000000','',3);
INSERT INTO ma0画面制御(画面番号,画面名称,背景色,文字色,実行pro,権限LV) VALUES ('10A0','アイテム発注','#FF4500','#000000','eh10A0',3);
INSERT INTO ma0画面制御(画面番号,画面名称,背景色,文字色,実行pro,権限LV) VALUES ('10AU','アイテム発注','#FF4500','#000000','',3);
INSERT INTO ma0画面制御(画面番号,画面名称,背景色,文字色,実行pro,権限LV) VALUES ('10B0','出庫集計','#FF4500','#000000','eh10B0',3);
INSERT INTO ma0画面制御(画面番号,画面名称,背景色,文字色,実行pro,権限LV) VALUES ('10BU','出庫集計','#FF4500','#000000','',3);
INSERT INTO ma0画面制御(画面番号,画面名称,背景色,文字色,実行pro,権限LV) VALUES ('10W0','担当者ﾏｽﾀ登録更新','#FF4500','#000000','eh10W0',9);
INSERT INTO ma0画面制御(画面番号,画面名称,背景色,文字色,実行pro,権限LV) VALUES ('10Y0','共通ﾏｽﾀ登録更新','#FF4500','#000000','eh10Y0',9);
INSERT INTO ma0画面制御(画面番号,画面名称,背景色,文字色,実行pro,権限LV) VALUES ('10YU','共通ﾏｽﾀ','#FF4500','#000000','',9);


INSERT INTO m80tanto(担当CD,担当名,募集人CD,権限CD) VALUES ('9999','管理者','00100ADMIN010',9);
INSERT INTO m80tanto(担当CD,担当名,募集人CD,権限CD) VALUES ('300','出庫入庫担当者','00100LEADER10',3);
INSERT INTO m80tanto(担当CD,担当名,募集人CD,権限CD) VALUES ('100','出庫担当者','00100STAFF010',1);


INSERT INTO M70ITEM(アイテムCD,アイテム名,アイテム区分,アイテム在庫数,アイテム下限数,アイテム棚番号) VALUES ('230001','パンフレット1',10,100,10,'Ay4-x1');
INSERT INTO M70ITEM(アイテムCD,アイテム名,アイテム区分,アイテム在庫数,アイテム下限数,アイテム棚番号) VALUES ('230002','パンフレット2',10,100,10,'Ay3-x1');
INSERT INTO M70ITEM(アイテムCD,アイテム名,アイテム区分,アイテム在庫数,アイテム下限数,アイテム棚番号) VALUES ('230003','パンフレット3',10,100,10,'Ay4-x2');
INSERT INTO M70ITEM(アイテムCD,アイテム名,アイテム区分,アイテム在庫数,アイテム下限数,アイテム棚番号) VALUES ('230004','パンフレット4',10,100,10,'Ay4-x3');
INSERT INTO M70ITEM(アイテムCD,アイテム名,アイテム区分,アイテム在庫数,アイテム下限数,アイテム棚番号) VALUES ('230005','パンフレット5',10,100,10,'Ay5-x1-y1');
INSERT INTO M70ITEM(アイテムCD,アイテム名,アイテム区分,アイテム在庫数,アイテム下限数,アイテム棚番号) VALUES ('230006','パンフレット6',10,5,10,'Ay5-x2-y1');
INSERT INTO M70ITEM(アイテムCD,アイテム名,アイテム区分,アイテム在庫数,アイテム下限数,アイテム棚番号) VALUES ('230007','パンフレット7',10,70,50,'Ay2-x4');
INSERT INTO M70ITEM(アイテムCD,アイテム名,アイテム区分,アイテム在庫数,アイテム下限数,アイテム棚番号) VALUES ('230008','パンフレット8',10,45,50,'Ay5-x1-y8');
INSERT INTO M70ITEM(アイテムCD,アイテム名,アイテム区分,アイテム在庫数,アイテム下限数,アイテム棚番号) VALUES ('230009','パンフレット9',10,100,100,'Ay5-x1-y7');
INSERT INTO M70ITEM(アイテムCD,アイテム名,アイテム区分,アイテム在庫数,アイテム下限数,アイテム棚番号) VALUES ('230010','封筒1',80,200,100,'Ay5-x1-y6');
INSERT INTO M70ITEM(アイテムCD,アイテム名,アイテム区分,アイテム在庫数,アイテム下限数,アイテム棚番号) VALUES ('230011','封筒2',80,300,100,'Ay5-x1-y5');
INSERT INTO M70ITEM(アイテムCD,アイテム名,アイテム区分,アイテム在庫数,アイテム下限数,アイテム棚番号) VALUES ('230012','封筒3',80,400,100,'Ay5-x2-y4');
INSERT INTO M70ITEM(アイテムCD,アイテム名,アイテム区分,アイテム在庫数,アイテム下限数,アイテム棚番号) VALUES ('230013','その他帳票1',90,500,100,'Ay5-x3-y5');
INSERT INTO M70ITEM(アイテムCD,アイテム名,アイテム区分,アイテム在庫数,アイテム下限数,アイテム棚番号) VALUES ('230014','その他帳票2',90,600,100,'Ay3-x2');


INSERT INTO M90共通(種別CD,種別,主CD,名称,Control,DefaultSelect) VALUES ('90','元号',5,'令和','','1');
INSERT INTO M90共通(種別CD,種別,主CD,名称,Control,DefaultSelect) VALUES ('110','アイテム区分',0,'-----','','1');
INSERT INTO M90共通(種別CD,種別,主CD,名称,Control,DefaultSelect) VALUES ('110','アイテム区分',10,'パンフレット・ちらし','','0');
INSERT INTO M90共通(種別CD,種別,主CD,名称,Control,DefaultSelect) VALUES ('110','アイテム区分',80,'封筒','','0');
INSERT INTO M90共通(種別CD,種別,主CD,名称,Control,DefaultSelect) VALUES ('110','アイテム区分',90,'その他帳票','','0');
INSERT INTO M90共通(種別CD,種別,主CD,名称,Control,DefaultSelect) VALUES ('9100','権限レベル',0,'----','','0');
INSERT INTO M90共通(種別CD,種別,主CD,名称,Control,DefaultSelect) VALUES ('9100','権限レベル',1,'出庫','','1');
INSERT INTO M90共通(種別CD,種別,主CD,名称,Control,DefaultSelect) VALUES ('9100','権限レベル',3,'出庫・入庫','','0');
INSERT INTO M90共通(種別CD,種別,主CD,名称,Control,DefaultSelect) VALUES ('9100','権限レベル',9,'管理者','','0');
INSERT INTO M90共通(種別CD,種別,主CD,名称,Control,DefaultSelect) VALUES ('9900','削除FLG',0,'----','','1');
INSERT INTO M90共通(種別CD,種別,主CD,名称,Control,DefaultSelect) VALUES ('9900','削除FLG',2,'使用期限切れ','','0');
INSERT INTO M90共通(種別CD,種別,主CD,名称,Control,DefaultSelect) VALUES ('9900','削除FLG',9,'抹消','','0');
INSERT INTO M90共通(種別CD,種別,主CD,名称,Control,DefaultSelect) VALUES ('92073','並替',1,'昇順','','0');
INSERT INTO M90共通(種別CD,種別,主CD,名称,Control,DefaultSelect) VALUES ('92073','並替',2,'降順','','0');
INSERT INTO M90共通(種別CD,種別,主CD,名称,Control,DefaultSelect) VALUES ('92081','表示件数',10,'10件','','0');
INSERT INTO M90共通(種別CD,種別,主CD,名称,Control,DefaultSelect) VALUES ('92081','表示件数',20,'20件','','0');
INSERT INTO M90共通(種別CD,種別,主CD,名称,Control,DefaultSelect) VALUES ('92081','表示件数',30,'30件','','1');
INSERT INTO M90共通(種別CD,種別,主CD,名称,Control,DefaultSelect) VALUES ('92081','表示件数',50,'50件','','0');
INSERT INTO M90共通(種別CD,種別,主CD,名称,Control,DefaultSelect) VALUES ('92081','表示件数',100,'100件','','0');
INSERT INTO M90共通(種別CD,種別,主CD,名称,Control,DefaultSelect) VALUES ('92081','表示件数',200,'200件','','0');

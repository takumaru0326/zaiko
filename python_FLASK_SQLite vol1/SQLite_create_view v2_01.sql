--------------------------------------- */
-- ビュー名：V10SHIP
--------------------------------------- */
CREATE VIEW IF NOT EXISTS V10SHIP
As

	SELECT  T10.ID,
			T10.アイテムCD,
			IFNULL(T10.アイテム出庫数,0) AS アイテム出庫数,
			T10.アイテム出庫YMD,
			T10.担当CD,
			M80.担当名,
			M70.アイテム名,
			M70.アイテム棚番号,
			IFNULL(M70.アイテム在庫数,0) AS アイテム在庫数,
			T10.削除FLG,
			IFNULL(M70.アイテム下限数,0) AS アイテム下限数,
			M70.削除FLG AS M70削除FLG
	FROM	T10SHIP AS T10
			LEFT OUTER JOIN M70ITEM AS M70 ON T10.アイテムCD = M70.アイテムCD AND M70.削除FLG<>1 
			LEFT OUTER JOIN M80担当者 AS M80 ON T10.担当CD = M80.担当CD AND M80.削除FLG=0
;

--------------------------------------- */
-- ビュー名：V20INSU
--------------------------------------- */
CREATE VIEW IF NOT EXISTS V20INSUU
As

	SELECT  T20.ID,
			T20.アイテムCD,
			T20.アイテム入荷数,
			T20.アイテム入荷YMD,
			T20.担当CD,
			M80.担当名,
			M70.アイテム名,
			M70.アイテム在庫数,
			M70.アイテム棚番号,
			T20.登録日,
			T20.削除FLG
	FROM	T20INSUU AS T20
			LEFT OUTER JOIN M70ITEM AS M70 ON T20.アイテムCD = M70.アイテムCD AND M70.削除FLG=0
			LEFT OUTER JOIN M80担当者 AS M80 ON T20.担当CD = M80.担当CD AND M80.削除FLG=0
;
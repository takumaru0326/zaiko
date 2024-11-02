if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[V10SHIP]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[V10SHIP]
GO

/****** Object:  View [dbo].[V10SHIP]    Script Date: 06/10/2011 12:56:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[V10SHIP]
As

	SELECT  T10.ID,
			T10.アイテムCD,
			ISNULL(T10.アイテム出庫数,0) AS アイテム出庫数,
			T10.アイテム出庫YMD,
			T10.担当CD,
			M80.担当名,
			M70.アイテム名,
			M70.アイテム棚番号,
			ISNULL(M70.アイテム在庫数,0) AS アイテム在庫数,
			T10.削除FLG,
			ISNULL(M70.アイテム下限数,0) AS アイテム下限数,
			M70.削除FLG AS M70削除FLG
	FROM	T10SHIP AS T10
			LEFT OUTER JOIN M70ITEM AS M70 ON T10.アイテムCD = M70.アイテムCD AND M70.削除FLG<>1 
			LEFT OUTER JOIN M80担当者 AS M80 ON T10.担当CD = M80.担当CD AND M80.削除FLG=0


GO



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[V20INSUU]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[V20INSUU]
GO


/****** Object:  View [dbo].[V20INSUU]    Script Date: 06/10/2011 12:56:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[V20INSUU]
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


GO


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[V80担当者]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[V80担当者]
GO


/****** Object:  View [dbo].[V80担当者]    Script Date: 06/10/2011 12:56:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[V80担当者]
As

	SELECT  M80.ID,
			M80.担当CD,
			M80.担当名,
			M80.ログインCD,
			M80.担当備考,
			M80.権限CD,
			M90.名称 AS 権限名,
			M80.最終Login日,
			M80.削除FLG
	FROM	M80担当者 AS M80
			LEFT OUTER JOIN M90共通 AS M90 ON M80.権限CD = M90.主CD AND M90.種別 = '権限レベル' AND M90.削除FLG=0


GO

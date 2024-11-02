<%
'************************************************************
'	VisualBasic Script Functions
'************************************************************
Dim strSql			'sqlクエリー用
Dim sql			'sqlクエリー用
Dim rsSql		'ado db
Dim rsSql2		'ado db
Dim i
Dim j

Dim PAGE
Dim PAGEND

Dim pvntUSERINFO
Dim pvntUSER_EigyouId		' 担当者ID
Dim pvntUSER_EigyouCD		' 担当者CD
Dim pvntUSER_EigyouNm		' 担当者名
Dim pvntUSER_EigyouBCD		' ログインCD
Dim pvntUSER_EigyouLV		' 権限LV

'***************************************************************************************************
'ファンクション名 : ログイン者情報をゲット
'	OUT	 1:ユーザ ID,ユーザー名　（Array)
'		年月日		名前			変更内容・理由
'作成		2006.09.01	本田			新規
'***************************************************************************************************
Public Sub pvf_User()
	
	' ログイン者情報を共通変数にセット
	pvntUSERINFO = Session("USERINFO")
	If IsArray(pvntUSERINFO) Then
		pvntUSER_EigyouId	= pvntUSERINFO(0)		' ログインID
		pvntUSER_EigyouCD	= pvntUSERINFO(1)		' 担当CD
		pvntUSER_EigyouNm	= pvntUSERINFO(2)		' 氏名
		pvntUSER_EigyouBCD	= pvntUSERINFO(3)		' ログインCD
		pvntUSER_EigyouLV	=pvntUSERINFO(4)		' 権限LV
	Else
		' 不正参照と判断された場合はログイン画面に移動
'		Server.Transfer "../p_main/login.asp"
		Response.Write "<SCRIPT LANGUAGE=""JavaScript"" >"
		Response.Write "top.location.href = '../pro_main/login.asp'"
		Response.Write "</SCRIPT>"
		Response.End
	End If

End Sub 

'*****	画面使用制限制御リクエスト	*****
'Function ReqGID(inEigyouCd,ChkGid,ChkNum)
'	Dim ret

'	ret = 0 

'	If ChkGid<>"" Then 
'      If ChkNum=1 Then
'         call DB_Open
'      End If
'      sql = "SELECT 権限 FROM MA1画面制御明細 "
'      sql = sql + "WHERE 画面番号='"+ ChkGid + "' AND 担当CD="+CStr(inEigyouCd)+" AND 削除FLG=0 "
'      Set rsSql2 = Server.CreateObject("ADODB.Recordset")
'      rsSql2.Open sql, connectDB, adOpenStatic, adLockReadOnly

'      If Not rsSql2.EOF Then ret = rsSql2("権限")
'      If ChkNum=1 Then
'         call DB_Close
'         Set rsSql2= Nothing
'      End If 
'	End If
'	ReqGID = ret
'End Function 


'***************************************************************************************************
'ファンクション名 : リストボックス、ラジオボタンセット(担当マスタ用）
'	IN	 1:	キー値　(OPEN時に選択状態にする)
'		 2:	フォームの項目名 (OUT先)
'		 3:	種類	1.Listbox 2.Radiobotton 3.Checkbox
'		 4:	主コードの検索条件(where)
'		 5:	order by 指定なければ ChkKeyfieldNm
'		 6:	javascript等のイベントなど
'		 7:	1.<br>タグをつける　0.無し
'		 8:	データベースの open close 有 1,無 0
'		 9:	フォームの Tab index
'		年月日		名前			変更内容・理由
'作成		2005.12.21	本田			新規
'***************************************************************************************************
Public Sub fncM80LCRSet(ChkKey,ChkKoumoku,ChkLRC,inFilter,inSort,intIvt,ChkBr,ChkDb,TabIdx)

	Dim ret,fieldcnt,dimcnt,cdimcnt
	Dim sel_mk

	If ChkDb=1 Then call DB_Open
	strSql = "SELECT M80.担当CD,M80.担当名 " _
					+ "FROM M80担当者 AS M80 " _
						+ "INNER JOIN MA1画面制御明細 AS MA1 ON M80.担当CD=MA1.担当CD AND MA1.画面番号='"+Left(Session("gid"),2)+"00' AND MA1.権限>1 AND MA1.削除FLG=0 " _
					+ "WHERE M80.削除FLG=0 And M80.担当CD<>0 "
	If Len(inFilter)>0 Then 
		strSql = strSql + "AND "+inFilter+" "
	End If
	If inSort<>"" Then 
		strSql = strSql + "ORDER BY "+inSort
	Else
		strSql = strSql + "ORDER BY M80.担当CD "
	End If
	Set rsSql2 = Server.CreateObject("ADODB.Recordset")
'Response.Write sql
'Response.End
	On Error Resume Next
	rsSql2.Open strSql, connectDB, adOpenStatic, adLockReadOnly
	If Err.Number<>0 Then
		Call DSP_ERR_PAGE(Session("GID")&"<br>"&strSql, "担当者データベースに接続できませんでした。", 0)
	End If

	Select Case ChkLRC
		Case 1				'Listbox
			%>
			<SELECT size=1 name="<%= ChkKoumoku %>" tabindex="<%= TabIdx %>" <%=intIvt %>>
			<%
		Case 2				'Radiobotton
		Case 3				'Checkbox
			fieldcnt = 0
			If ChkKey<>"" Then
				ChkKey	= Mid(ChkKey,2,Len(ChkKey))	'最初の . を削除する
				arykey = Split(ChkKey,".")
				fieldcnt = UBound(arykey)
			End If
			dimcnt=1
			cdimcnt=0
	End Select
   Do While Not rsSql2.EOF
      Select Case ChkLRC
	Case 1				'Listbox
		sel_mk =""
		If ChkKey="" Then
			If rsSql("DefaultSelect")=1 Then sel_mk="selected"
		Else
			If Trim(ChkKey)=Trim(rsSql2.Fields(0)) Then sel_mk ="selected"
		End If 
	%>
	<OPTION value="<%= rsSql2.Fields(0) %>" <%= sel_mk%>><%= rsSql2.Fields(1) %></OPTION>
	<%
	Case 2				'Radiobotton
		sel_mk =""
		If ChkKey="" Then
			ChkKey = 0
		End If
		If ChkKey=0 Then
		If rsSql("DefaultSelect")=1 Then sel_mk="checked"
		Else
			If Trim(ChkKey)=Trim(rsSql2.Fields(0)) Then sel_mk ="checked"
		End If
		%>
		<INPUT type="radio" value="<%= rsSql2.Fields(0) %>" name="<%= ChkKoumoku %>" <%= sel_mk %> <%=intIvt %>><%= rsSql2.Fields(1) %>
		<%
	Case 3				'Checkbox
		sel_mk = ""
		If cdimcnt<=fieldcnt And ChkKey<>"" Then 
			If Trim(arykey(cdimcnt))=Trim(rsSql2.Fields(0)) Then
				sel_mk = "checked"
				cdimcnt = cdimcnt + 1
			End If
		End If
		%>
		<INPUT type=checkbox value="<%= rsSql2.Fields(0) %>" name="<%= ChkKoumoku %><%= dimcnt %>" id="<%= ChkKoumoku %><%= dimcnt %>" <%= sel_mk %> <%=intIvt %>><label for="<%= ChkKoumoku %><%= dimcnt %>"><%= rsSql2.Fields(1) %></label>
		<%
		dimcnt=dimcnt+1
	End Select
	If ChkBr=1 Then Response.Write "<BR>" 
	rsSql2.MoveNext
   loop
   
   LRCSet=dimcnt
   
   Select Case ChkLRC
	Case 1				'Listbox
		Response.Write "</SELECT>"
	Case 2				'Radiobotton
	Case 3				'Checkbox
   End Select  
   If ChkDb=1 Then
	Set rsSql2= Nothing
	call DB_Close
   End If
End Sub 

'***************************************************************************************************
'ファンクション名 : 画面制御マスタ名称リクエスト
'	IN	 1:画面番号
'		 2:データベースの open close 有 1,無 0
'	OUT	 1:画面名称
'		年月日		名前			変更内容・理由
'作成		2005.12.06	本田			新規
'***************************************************************************************************
Public Function ReqGIDNAME(ChkKey,ChkNum)
   Dim ret
   If ChkKey<>"" Then 
	If ChkNum=1 Then
		call DB_Open
	End If
	sql = "SELECT 画面名称 FROM MA0画面制御 "
'	sql = sql + "WHERE 画面番号='"+ ChkKey + "' AND 削除FLG=0 " 
	sql = sql + "WHERE 画面番号='"+ ChkKey + "' " 

	On Error Resume Next
	Set rsSql2 = Server.CreateObject("ADODB.Recordset")
	rsSql2.Open sql, connectDB, adOpenStatic, adLockReadOnly
	If Err.Number<>0 Then
		Call DSP_ERR_PAGE(Session("GID")&"<br>"&sql, "画面制御データベースに接続できませんでした。", 0)
	End If
	If Not rsSql2.EOF Then ret = rsSql2.Fields(0)
	If ChkNum=1 Then
		call DB_Close
		Set rsSql2= Nothing
	End If 
   Else 
	ret = "" 
   End If
   ReqGIDNAME = ret
End Function 

'*****	担当名称リクエスト	*****
Function ReqTANTOUNAME(ChkKey,ChkNum)
   Dim ret
   If ChkKey<>"" Then 
      If ChkNum=1 Then call DB_Open
      sql = "SELECT 担当名 FROM M80担当者 "
      sql = sql + "WHERE 担当CD='"+CStr(ChkKey)+"' AND 削除FLG=0 " 
      Set rsSql2 = Server.CreateObject("ADODB.Recordset")
      rsSql2.Open sql, connectDB, adOpenStatic, adLockReadOnly
      If Not rsSql2.EOF Then
	 ret = rsSql2("担当名")
      End If
      If ChkNum=1 Then
	 call DB_Close
         Set rsSql2= Nothing
      End If
   Else 
      ret = "" 
   End If
   ReqTANTOUNAME = ret
End Function

'***************************************************************************************************
'ファンクション名 : 共通マスタ名称リクエスト
'	IN	 1:種別
'		 2:コード
'		 3:データベースの open close 有 1,無 0
'	OUT	 1:名称
'		年月日		名前			変更内容・理由
'作成		2005.12.06	本田			新規
'***************************************************************************************************
Public Function ReqCOMNAME(ChkSel,ChkKey,ChkNum)
   Dim ret
   If ChkKey<>"" Then 
      If ChkNum=1 Then
         call DB_Open
      End If
	  If ChkKey<>"選択 " And ChkKey<>"選択" Then
		sql = "SELECT 名称 FROM M90共通 "
		sql = sql + "WHERE 種別='"+ChkSel+"' AND 主CD=" + CStr(ChkKey) + " " + " AND 削除FLG=0 " 
		On Error Resume Next
		Set rsSql2 = Server.CreateObject("ADODB.Recordset")
		rsSql2.Open sql, connectDB, adOpenStatic, adLockReadOnly
		If Not rsSql2.EOF Then ret = rsSql2.Fields(0)
		If Err.Number<>0 Then
			Call DSP_ERR_PAGE(Session("GID")&"<br>"&sql, "共通データベースに接続できませんでした。", 0)
		End If
	  End If
      If ChkNum=1 Then
         call DB_Close
         Set rsSql2= Nothing
      End If 
   Else 
      ret = "" 
   End If
   ReqCOMNAME = ret
End Function 

'***************************************************************************************************
'ファンクション名 : データベース値リクエスト
'	IN	 1:	データベース名称
'		 2:	取得フィールド名
'		 3:	where 
'		 4:データベースの open close 有 1,無 0
'	OUT	 1:データベース値
'	注意	削除FLG項目が必要
'		年月日		名前			変更内容・理由
'作成	2007.01.22	本田			新規
'***************************************************************************************************
Public Function fncDbDataWGet(ChkMst,ChkfieldNm,ChkWhere,ChkDb)
   Dim ret
   If ChkWhere<>"" Then 
	If ChkDb=1 Then call DB_Open
	sql = "SELECT "+ChkfieldNm _
		+ " FROM "+ChkMst _
		+ " WHERE "+ChkWhere

	On Error Resume Next

	Set rsSql = Server.CreateObject("ADODB.Recordset")
	rsSql.Open sql, connectDB, adOpenStatic, adLockReadOnly


'	Set rsSql2 = Server.CreateObject("ADODB.Recordset")
'	rsSql2.Open sql, connectDB, adOpenStatic, adLockReadOnly
	If Err.Number<>0 Then
'		Call fnciMessage( ChkMst&"データベースに接続できませんでした。","menu.asp")
	End If

	If Not rsSql.EOF Then
		ret = rsSql.Fields(0)
	End If
	If ChkDb=1 Then
		call DB_Close
		Set rsSql= Nothing
	End If
	
'	If Not rsSql2.EOF Then
'		ret = rsSql2.Fields(0)
'	End If
'	If ChkDb=1 Then
'		call DB_Close
'		Set rsSql2= Nothing
'	End If
   Else 
	ret = "" 
   End If
   fncDbDataWGet = ret
End Function

'***************************************************************************************************
'ファンクション名 : データベース値リクエスト
'	IN	 1:	データベース名称
'		 2:	キーフィード名
'		 3:	取得フィールド名
'		 4:	キー値
'		 5:	キー型 X:文字列　N:数値
'		 6:データベースの open close 有 1,無 0
'	OUT	 1:データベース値
'	注意	削除FLG項目が必要
'		年月日		名前			変更内容・理由
'作成		2006.01.06	本田			新規
'***************************************************************************************************
Public Function fncDbDataGet(ChkMst,ChkKeyfieldNm,ChkfieldNm,ChkKey,ChkKeyType,ChkDb)
   Dim ret
   If ChkKey<>"" Then 
	If ChkDb=1 Then call DB_Open
	sql = "SELECT "+ChkfieldNm _
		+ " FROM "+ChkMst
	If ChkKeyType = "N" Then sql = sql + " WHERE "+ChkKeyfieldNm+"=" & CStr(ChkKey) & " AND 削除FLG=0 " 
	If ChkKeyType = "X" Then sql = sql + " WHERE "+ChkKeyfieldNm+"='" & ChkKey & "' AND 削除FLG=0 " 

	On Error Resume Next
	Set rsSql2 = Server.CreateObject("ADODB.Recordset")
	rsSql2.Open sql, connectDB, adOpenStatic, adLockReadOnly
	If Err.Number<>0 Then
		Call DSP_ERR_PAGE(Session("GID")&"<br>"&sql, ChkMst+"データベースに接続できませんでした。", 0)
	End If

	If Not rsSql2.EOF Then
		ret = rsSql2(ChkfieldNm)
	End If
	If ChkDb=1 Then
		call DB_Close
		Set rsSql2= Nothing
	End If
   Else 
	ret = "" 
   End If
   fncDbDataGet = ret
End Function

'***************************************************************************************************
'ファンクション名 : リストボックス、ラジオボタンセット（共通マスタ専用)
'	IN	 1:	共通マスタの種別
'		 2:	キー値　(OPEN時に選択状態にする) 
'		 3:	フォームの項目名 (OUT先)
'		 4:	種類	1.Listbox 2.Radiobotton 3.Checkbox
'		 5:	主コードの検索条件　
'		 6:	1.<br>タグをつける　0.無し
'		 7:	データベースの open close 有 1,無 0
'		 8:	フォームの Tab index
'		年月日		名前			変更内容・理由
'作成		2005.12.06	本田			新規
'***************************************************************************************************
Public Function LRCSet(ChkSyubetu,ChkKey,ChkKoumoku,ChkLRC,ChkFilter,ChkBr,ChkNum,TabIdx)


   Dim ret,fieldcnt,dimcnt,cdimcnt
   Dim sel_mk
   Dim arykey

   If ChkNum=1 Then call DB_Open
   sql = "SELECT * "
   sql = sql + "FROM M90共通 WHERE 種別='"+ChkSyubetu+"' " + " AND 削除FLG=0 " 
   If Len(ChkFilter)>0 Then 
	sql = sql + "AND "+ChkFilter+" "
   End If
   sql = sql + "ORDER BY 主CD "
   Set rsSql = Server.CreateObject("ADODB.Recordset")

   On Error Resume Next
   rsSql.Open sql, connectDB, adOpenStatic, adLockReadOnly
   If Err.Number<>0 Then
	Call DSP_ERR_PAGE(Session("GID")&"<br>"&sql, "共通データベースに接続できませんでした。", 0)
   End If

   Select Case ChkLRC
	Case 1				'Listbox
		%>
		<SELECT size=1 name="<%= ChkKoumoku %>" tabindex="<%= TabIdx %>">
		<%
	Case 2				'Radiobotton
	Case 3				'Checkbox
		fieldcnt = 0
		If ChkKey<>"" Then
	'		ChkKey	= Mid(Trim(ChkKey),2,Len(Trim(ChkKey)))	'最初の . を削除する
			arykey = Split(ChkKey,",")
			fieldcnt = UBound(arykey)
		End If
		dimcnt=1
		cdimcnt=0
	   End Select
   Do While Not rsSql.EOF
      Select Case ChkLRC
	Case 1				'Listbox
		sel_mk =""
		If ChkKey="" Then
			If rsSql("DefaultSelect")=1 Then sel_mk="selected"
		Else
			If Trim(ChkKey)=Trim(rsSql("主CD")) Then sel_mk ="selected"
		End If 
	%>
	<OPTION value="<%= rsSql("主CD") %>" <%= sel_mk %>><%= rsSql("名称") %></OPTION>
	<%

	Case 2				'Radiobotton
		sel_mk =""
		If ChkKey="" Then
			ChkKey = 0
		End If
		If ChkKey=0 Then
		If rsSql("DefaultSelect")=1 Then sel_mk="checked"
		Else
			If Trim(ChkKey)=Trim(rsSql("主CD")) Then sel_mk ="checked"
		End If
		%>
		<INPUT type="radio" value="<%= rsSql("主CD") %>" name="<%= ChkKoumoku %>" <%= sel_mk %>><%= rsSql("名称") %>
		<%
	Case 3				'Checkbox
		sel_mk = ""
		If cdimcnt<=fieldcnt And ChkKey<>"" Then 
			If Trim(arykey(cdimcnt))=Trim(rsSql("主CD")) Then
				sel_mk = "checked"
				cdimcnt = cdimcnt + 1
			End If
		End If
		%>
		<INPUT type=checkbox value="<%= rsSql("主CD") %>" name="<%= ChkKoumoku %>" <%= sel_mk %> tabindex="<%= TabIdx %>"><label for="<%= ChkKoumoku %>"><%= rsSql("名称") %></label>
		<%
'		dimcnt=dimcnt+1
	End Select
	If ChkBr=1 Then Response.Write "<BR>" 
	rsSql.MoveNext
   loop
   
   LRCSet=dimcnt
   
   Select Case ChkLRC
	Case 1				'Listbox
		Response.Write "</SELECT>"
	Case 2				'Radiobotton
	Case 3				'Checkbox
   End Select  
   If ChkNum=1 Then
	 call DB_Close
   End If 
End Function 

'***************************************************************************************************
'ファンクション名 : リストボックス、ラジオボタンセット(汎用）
'	IN	 1:	マスタ名称
'		 2:	マスタキー項目名
'		 3:	マスタ名称項目名
'		 4:	キー値　(OPEN時に選択状態にする)
'		 5:	フォームの項目名 (OUT先)
'		 6:	種類	1.Listbox 2.Radiobotton 3.Checkbox
'		 7:	主コードの検索条件(where)
'		 8:	order by 指定なければ ChkKeyfieldNm
'		 9:	javascript等のイベントなど
'		10:	1.<br>タグをつける　0.無し
'		11:	データベースの open close 有 1,無 0
'		12:	フォームの Tab index
'		年月日		名前			変更内容・理由
'作成		2005.12.21	本田			新規
'***************************************************************************************************
Public Sub fncLRCSet(ChkMst,ChkKeyfieldNm,ChkfieldNm,ChkKey,ChkKoumoku,ChkLRC,inFilter,inSort,intIvt,ChkBr,ChkDb,TabIdx)

	Dim ret,fieldcnt,dimcnt,cdimcnt
	Dim sel_mk

	If ChkDb=1 Then call DB_Open
	sql = "SELECT "+ChkKeyfieldNm+","+ChkfieldNm
	sql = sql + " FROM "+ChkMst
	sql = sql + " WHERE 削除FLG=0 "
	If Len(inFilter)>0 Then 
		sql = sql + "AND "+inFilter+" "
	End If
	If inSort<>"" Then 
		sql = sql + "ORDER BY "+inSort
	Else
		sql = sql + "ORDER BY "+ChkKeyfieldNm
	End If
	Set rsSql2 = Server.CreateObject("ADODB.Recordset")
'Response.Write sql
'Response.End
	On Error Resume Next
	rsSql2.Open sql, connectDB, adOpenStatic, adLockReadOnly
	If Err.Number<>0 Then
		Call DSP_ERR_PAGE(Session("GID")&"<br>"&sql, ChkMst+"データベースに接続できませんでした。", 0)
	End If

	Select Case ChkLRC
		Case 1				'Listbox
			%>
			<SELECT size=1 name="<%= ChkKoumoku %>" tabindex="<%= TabIdx %>" <%=intIvt %>>
			<%
		Case 2				'Radiobotton
		Case 3				'Checkbox
			fieldcnt = 0
			If ChkKey<>"" Then
				ChkKey	= Mid(ChkKey,2,Len(ChkKey))	'最初の . を削除する
				arykey = Split(ChkKey,".")
				fieldcnt = UBound(arykey)
			End If
			dimcnt=1
			cdimcnt=0
	End Select
   Do While Not rsSql2.EOF
      Select Case ChkLRC
	Case 1				'Listbox
		sel_mk =""
		If ChkKey="" Then
			If rsSql("DefaultSelect")=1 Then sel_mk="selected"
		Else
			If Trim(ChkKey)=Trim(rsSql2.Fields(0)) Then sel_mk ="selected"
		End If 
	%>
	<OPTION value="<%= rsSql2.Fields(0) %>" <%= sel_mk%>><%= rsSql2.Fields(1) %></OPTION>
	<%
	Case 2				'Radiobotton
		sel_mk =""
		If ChkKey="" Then
			ChkKey = 0
		End If
		If ChkKey=0 Then
		If rsSql("DefaultSelect")=1 Then sel_mk="checked"
		Else
			If Trim(ChkKey)=Trim(rsSql2.Fields(0)) Then sel_mk ="checked"
		End If
		%>
		<INPUT type="radio" value="<%= rsSql2.Fields(0) %>" name="<%= ChkKoumoku %>" <%= sel_mk %> <%=intIvt %>><%= rsSql2.Fields(1) %>
		<%
	Case 3				'Checkbox
		sel_mk = ""
		If cdimcnt<=fieldcnt And ChkKey<>"" Then 
			If Trim(arykey(cdimcnt))=Trim(rsSql2.Fields(0)) Then
				sel_mk = "checked"
				cdimcnt = cdimcnt + 1
			End If
		End If
		%>
		<INPUT type=checkbox value="<%= rsSql2.Fields(0) %>" name="<%= ChkKoumoku %><%= dimcnt %>" id="<%= ChkKoumoku %><%= dimcnt %>" <%= sel_mk %> <%=intIvt %>><label for="<%= ChkKoumoku %><%= dimcnt %>"><%= rsSql2.Fields(1) %></label>
		<%
		dimcnt=dimcnt+1
	End Select
	If ChkBr=1 Then Response.Write "<BR>" 
	rsSql2.MoveNext
   loop
   
   LRCSet=dimcnt
   
   Select Case ChkLRC
	Case 1				'Listbox
		Response.Write "</SELECT>"
	Case 2				'Radiobotton
	Case 3				'Checkbox
   End Select  
   If ChkDb=1 Then
	Set rsSql2= Nothing
	call DB_Close
   End If
End Sub 

'***************************************************************************************************
'ファンクション名 : 和暦->西暦変換
'	IN	 1:変換文字列　元号JJMMDD,元号JJMM,元号JJ 又は 4JJMMDD,4JJMM,4JJ
'		 2:変換区分 1.元号が漢字 2.元号が数字
'	OUT	 1:YYYYMMDD Or YYYYMM Or YYYY
'		年月日		名前			変更内容・理由
'作成		2005.12.06	本田			新規
'***************************************************************************************************
Public Function ReqSEIREKI(ChkString,ChkNum)
On Error Resume Next
   Dim ret,work
   If ChkNum=1 And Len(ChkString)>=4 Then 
      If Left(ChkString,2)="令和" Then work=2018+CInt(Mid(ChkString,3,2))
      If Left(ChkString,2)="平成" Then work=1988+CInt(Mid(ChkString,3,2))
      If Left(ChkString,2)="昭和" Then work=1925+CInt(Mid(ChkString,3,2))
      If Left(ChkString,2)="大正" Then work=1911+CInt(Mid(ChkString,3,2))
      If Left(ChkString,2)="明治" Then work=1867+CInt(Mid(ChkString,3,2))
      ret = CStr(work)+Mid(ChkString,5,4)
   End If

   If ChkNum=2 And Len(ChkString)>=3 Then 
      If Left(ChkString,1)="5" Then work=2018+CInt(Mid(ChkString,2,2))
      If Left(ChkString,1)="4" Then work=1988+CInt(Mid(ChkString,2,2))
      If Left(ChkString,1)="3" Then work=1925+CInt(Mid(ChkString,2,2))
      If Left(ChkString,1)="2" Then work=1911+CInt(Mid(ChkString,2,2))
      If Left(ChkString,1)="1" Then work=1867+CInt(Mid(ChkString,2,2))
      ret = CStr(work)+Mid(ChkString,4,4)
   End If
   If Err.Number<>0 Then
	Call DSP_ERR_PAGE(Session("GID")&"<BR>"&ChkString, "ReqSEIREKI 実行エラー。", 0)
   End If
   ReqSEIREKI = ret
End Function 

'***************************************************************************************************
'ファンクション名 : 和暦->西暦変換
'	IN	 1:変換文字列　元号JJMMDD,元号JJMM,元号JJ 又は 4JJMMDD,4JJMM,4JJ
'		 2:変換区分 元号が漢字.1 元号が数字.2
'		 3:有効桁数 8.YYYYMMDD 6.YYYYMM 4.YYYY	(出力値が有効桁数に満たない場合は NULLになる）
'	OUT	 1:YYYYMMDD Or YYYYMM Or YYYY
'		年月日		名前			変更内容・理由
'作成		2006.01.16	本田			新規
'***************************************************************************************************
Public Function fncReqSEIREKI(inString,inNum,inLen)
On Error Resume Next
   Dim ret,work
   work = ReqSEIREKI(inString,inNum)

   If Len(work)=inLen Then 
	ret = work
   Else
	ret = ""
   End If

   If Err.Number<>0 Then
	Call DSP_ERR_PAGE(Session("GID")&"<BR>"&inString, "fncReqSEIREKI 実行エラー。", 0)
   End If
   fncReqSEIREKI = ret
End Function 


'***************************************************************************************************
'ファンクション名 : 西暦->和暦変換
'	IN	 1:変換文字列　YYYYMMDD
'		 2:変換区分	0.GGJJMMDD	1.4JJMMDD	2.GGJJ年MM月DD日	3.GGJJ年MM月DD日 (曜日)	4.GJJ.MM.DD
'	OUT	 1:		4JJMMDD	又は　GGJJ年MM月DD日
'		年月日		名前			変更内容・理由
'作成		2005.12.07	本田			新規
'***************************************************************************************************
Public Function ReqWAREKI(ChkString,ChkNum)
On Error Resume Next
   Dim ret,work

   ret = ""
   If ChkString<>"" Then
      If ChkString>="20190501" And ChkString<="99999999" Then ret = "令和"+Right(" 0"+CStr(CInt(Left(ChkString,4))-2018),2)+Mid(ChkString,5,4)
      If ChkString>="19890108" And ChkString<="20190430" Then ret = "平成"+Right(" 0"+CStr(CInt(Left(ChkString,4))-1988),2)+Mid(ChkString,5,4)
      If ChkString>="19261225" And ChkString<="19890107" Then ret = "昭和"+Right(" 0"+CStr(CInt(Left(ChkString,4))-1925),2)+Mid(ChkString,5,4)
      If ChkString>="19120730" And ChkString<="19261224" Then ret = "大正"+Right(" 0"+CStr(CInt(Left(ChkString,4))-1911),2)+Mid(ChkString,5,4)
      If ChkString>="18680908" And ChkString<="19120729" Then ret = "明治"+Right(" 0"+CStr(CInt(Left(ChkString,4))-1867),2)+Mid(ChkString,5,4)
      Select Case ChkNum
	Case 1
		If Left(ret,2)="令和" Then ret = "5"+Mid(ret,3,2)+Mid(ret,5,2)+Right(ret,2)
		If Left(ret,2)="平成" Then ret = "4"+Mid(ret,3,2)+Mid(ret,5,2)+Right(ret,2)
		If Left(ret,2)="昭和" Then ret = "3"+Mid(ret,3,2)+Mid(ret,5,2)+Right(ret,2)
		If Left(ret,2)="大正" Then ret = "2"+Mid(ret,3,2)+Mid(ret,5,2)+Right(ret,2)
		If Left(ret,2)="明治" Then ret = "1"+Mid(ret,3,2)+Mid(ret,5,2)+Right(ret,2)
	Case 2
		ret = Left(ret,4)+"年"+Right(" "+CStr(CInt(Mid(ret,5,2))),2)+"月"+Right(" "+CStr(CInt(Right(ret,2))),2)+"日"
	Case 3
		ret = Left(ret,4)+"年"+Right(" "+CStr(CInt(Mid(ret,5,2))),2)+"月"+Right(" "+CStr(CInt(Right(ret,2))),2)+"日" _
			+" ("+Mid("日月火水木金土",Weekday(LEFT(ChkString,4)+"/"+Mid(ChkString,5,2)+"/"+Mid(ChkString,7,2)),1)+")"
	Case 4
		If Left(ret,2)="令和" Then ret = "R"+Mid(ret,3,2)+"."+Mid(ret,5,2)+"."+Right(ret,2)
		If Left(ret,2)="平成" Then ret = "H"+Mid(ret,3,2)+"."+Mid(ret,5,2)+"."+Right(ret,2)
		If Left(ret,2)="昭和" Then ret = "S"+Mid(ret,3,2)+"."+Mid(ret,5,2)+"."+Right(ret,2)
		If Left(ret,2)="大正" Then ret = "T"+Mid(ret,3,2)+"."+Mid(ret,5,2)+"."+Right(ret,2)
		If Left(ret,2)="明治" Then ret = "M"+Mid(ret,3,2)+"."+Mid(ret,5,2)+"."+Right(ret,2)
	Case Else
 '		ret = Left(ret,4)+ChkChar+Mid(ret,5,2)+ChkChar+Right(ret,2)
      End Select  
   End If
   If Err.Number<>0 Then
	Call DSP_ERR_PAGE(Session("GID")&"<BR>IN="&ChkString&"<BR>OUT="&ret, "ReqWAREKI実行エラー。", 0)
   End If	
   ReqWAREKI = ret
End Function 

'************************************************************************
'ファンクション名 : 今日日付取得 -> YYYYMMDD
'	OUT	 1:YYYYMMDD
'		年月日		名前			変更内容・理由
'作成		2005.12.21	本田			新規
'************************************************************************
Public Function  fncTodayYMD()
   Dim ret
   ret = CStr(Year(Now()))& Right("0"+CStr(Month(Now())),2) & Right("0"+CStr(Day(Now())),2)
   fncTodayYMD = ret
End Function

'************************************************************************
'ファンクション名 : 今日日付取得 -> GGJJMMDD
'	IN	 1:変換区分	0.GGJJMMDD	1.4JJMMDD	2.GGJJ年MM月DD日	3.GGJJ年MM月DD日 (曜日)
'	OUT	 1:GGJJMMDD
'		年月日		名前			変更内容・理由
'作成		2006.01.05	本田			新規
'************************************************************************
Public Function  fncTodayJMD(ChkNum)
   Dim ret
   ret = ReqWAREKI(fncTodayYMD(),ChkNum)
   fncTodayJMD = ret
End Function


'************************************************************************
'ファンクション名 : 現在時間取得 -> HH:MM:DD
'	IN	 1:編集形式 "HH:MM:SS"
'	OUT	 1:H9:M9:S9,	H9:M9	,H9M9（頭0表示)
'		年月日		名前			変更内容・理由
'作成		2006.02.26	本田			新規
'************************************************************************
Public Function  fncTimeNowGet(inKeishiki)
   Dim ret
   ret = ""
	Select Case inKeishiki
		Case "HH:MM:SS"
			ret = Right("0"+CStr(Hour(Time)),2)+":"+Right("0"+CStr(Minute(Time)),2)+":"+Right("0"+CStr(Second(Time)),2)
		Case "HH:MM"
			ret = Right("0"+CStr(Hour(Time)),2)+":"+Right("0"+CStr(Minute(Time)),2)
		Case "HHMM"
			ret = Right("0"+CStr(Hour(Time)),2)+Right("0"+CStr(Minute(Time)),2)
	End Select
   fncTimeNowGet = ret
End Function


'************************************************************************
'ファンクション名 : 時間表示形式変更 -> HH:MM:DD (頭0表示を除く)
'	IN	 1:変換元文字列　H9:M9:D9,H9M9
'		 2:編集形式 "HH:MM"	
'	OUT	 1:編集形式で変換した文字列
'		年月日		名前			変更内容・理由
'作成		2005.02.03	本田			新規
'************************************************************************
Public Function  fncTimeformat(inTime,inKeishiki)
	Dim ret
	ret = ""
	If Len(Trim(inTime))=8 Or Len(Trim(inTime))=5 Then
		Select Case inKeishiki
			Case "HH:MM"
				ret = Right(" "+CStr(CInt(Left(inTime,2))),2)+":"+Right("0"+CStr(CInt(Mid(inTime,4,2))),2)
		End Select
	Else
		Select Case inKeishiki
			Case "HH:MM"
				ret = Right(" "+CStr(CInt(Left(inTime,2))),2)+":"+Right("0"+CStr(CInt(Mid(inTime,3,2))),2)
		End Select
	End If

   fncTimeformat = ret
End Function

'************************************************************************
'ファンクション名 : NULL->Empty変換
'	IN	 1:変換文字列　
'	OUT	 1:NULL なら　Empty
'		年月日		名前			変更内容・理由
'作成		2005.12.21	本田			新規
'************************************************************************
Public Function  fncNtoE(ChkString)
   Dim ret
   ret = ""
	If IsNULL(ChkString) Then
		ret = ""
	Else
		ret = ChkString
	End if
   fncNtoE = ret
End Function

'************************************************************************
'ファンクション名 : NULL-> 0 変換
'	IN	 1:変換文字列　
'	OUT	 1:NULL なら　0 
'		年月日		名前			変更内容・理由
'作成		2005.12.21	本田			新規
'************************************************************************
Public Function fncNtoZ(ChkString)
   Dim ret
   ret = ""
	If IsNULL(ChkString) Or ChkString="" Or IsEmpty(ChkString) Then
		ret = "0"
	Else
		ret = ChkString
	End if
   fncNtoZ = ret
End Function


'************************************************************************
'ファンクション名 : 現ページのURL(ページアドレスを除く）を取得
'	OUT	 1:URL  
'		年月日		名前			変更内容・理由
'作成		2006.02.25	本田			新規
'************************************************************************
Public Function fncURLget()
   Dim ret
   Dim vntPos
   ret = ""
   ret = "http://"+Request.ServerVariables("SERVER_NAME")+Request.ServerVariables("SCRIPT_NAME")
   vntPos = InstrRev(ret, "/")
   ret = Left(ret,vntPos) 
   fncURLget = ret
End Function


'***************************************************************************************************
'ファンクション名 : Session 変数クリア
'機能概要	  : Session id User info 所属コード 所属名 以外のセッション変数をクリアする
'			メニュー画面に戻るときに使用する
'
'パラメータ	 無し
'
'		年月日		名前			変更内容・理由
'作成		2005.12.04	本田			新規
'***************************************************************************************************
Public Sub Session_Clr()
   Dim ItemName

   With Session
     i = .Contents.Count

     Do While i > 10
       .Contents.Remove(i)
       i = i - 1
     Loop


	'クリア後のセッション変数表示
'	For Each ItemName In Session.Contents
'		Response.Write  ItemName & "," & Session.Contents( ItemName ) 
'		Response.Write  ItemName +","
'	Next
   End With
End Sub


'***************************************************************************************************
'システム名	  : 営業支援システム
'ファンクション名 : メッセージ表示処理
'機能概要	  : メッセージを表示する
'
'パラメータ	 1:メッセージ
'
'		年月日		名前			変更内容・理由
'作成		2006.2.6	本田			新規
'***************************************************************************************************

Public Sub fncMessage( strMSG,strURL,strTARGET)
  With Response
    .Write "</head>" & vbCrLf

    .Write "<body>" & vbCrLf'
    .Write "<CENTER>" & vbCrLf
	.Write "<FORM NAME=""frmSubmit"" ACTION="+strURL+" TARGET="+strTARGET+" METHOD=""post"">"

    .Write "<TABLE BORDER=""1"" CELLSPACING=""0"" CELLPADDING=""5"" WIDTH=""600pix"">" & vbCrLf
    .Write "<TR><TD ALIGN=""CENTER"">" & vbCrLf
    .Write "<p style=""color:green; font-size:18px; font-weight: bold;"">" & _
      strMSG &"</p>" & vbCrLf
    .Write "</TD></TR>" & vbCrLf
    .Write "</TABLE>" & vbCrLf
	.Write "<BUTTON ID=""Id_SubmitButton"" TYPE=""SUBMIT"" style=""font-size:105%;width:130px"" onkeypress=""if(event.keyCode==13){searth_submit()};"">　閉じる　</BUTTON>"
	.Write "</FORM>"
    .Write "</CENTER></body>" & vbCrLf
  
    .Write "<script language=""JavaScript"">" & vbCrLf
 	.Write "document.getElementById('Id_SubmitButton').focus();" & vbCrLf
	.Write "function submit(){" & vbCrLf
 	.Write "		document.forms['frmSubmit'].submit();" & vbCrLf
    .Write "}" & vbCrLf
    .Write "</script>" & vbCrLf

    .Write "</html>" & vbCrLf
    .End
  End With
End Sub

'***************************************************************************************************
'ファンクション名 : エラーページ表示処理
'機能概要	  : エラーメッセージを表示する
'
'パラメータ	 1:エラー発生 画面ID
'		 2:エラーメッセージ
'		 3:swLOG		1.LOG作成
'
'		年月日		名前			変更内容・理由
'作成		2005.12.02	本田			新規
'***************************************************************************************************

Public Sub DSP_ERR_PAGE(strPRGID, strERRMSG, swLOG)
  With Response
'    .Write "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.0 Transitional//EN"">" & vbCrLf
    .Write "<html lang=""ja"">" & vbCrLf

    .Write "<head>" & vbCrLf
    .Write "<meta http-equiv=""Content-Type"" " & _
    "content=""text/html; charset=utf-8"">" & vbCrLf
    .Write "<meta http-equiv=""Content-Style-Type"" content=""text/css"">" & vbCrLf
    .Write "<title>エラー</title>" & vbCrLf
    .Write "<script language=""JavaScript"">" & vbCrLf
    .Write "<!--" & vbCrLf
    .Write "// 前画面に戻る" & vbCrLf
    .Write "function FNC_GOBACK() {" & vbCrLf
    .Write "  history.back();" & vbCrLf
    .Write "  return;" & vbCrLf
    .Write "}" & vbCrLf
    .Write "//-->" & vbCrLf
    .Write "</script>" & vbCrLf
    .Write "</head>" & vbCrLf

    .Write "<body>" & vbCrLf'
    .Write "<CENTER>" & vbCrLf
    .Write "<TABLE BORDER=""1"" CELLSPACING=""0"" CELLPADDING=""5"" WIDTH=""600pix"">" & vbCrLf
    .Write "<TR><TD ALIGN=""CENTER"">" & vbCrLf
    .Write "<p style=""color:red; font-size:18px; font-weight: bold;"">" & _
      strERRMSG &"</p>" & vbCrLf
    .Write "</TD></TR>" & vbCrLf
    .Write "<TR><TD>" & vbCrLf

    .Write "<p style=""color:red; font-size:10px; font-weight: bold;"">Prog Id " & _
      strPRGID &"</p>" & vbCrLf
    .Write "<p style=""color:red; font-size:10px; font-weight: bold;"">" & _
      Err.Description &"</p>" & vbCrLf

    .Write "</TD></TR>" & vbCrLf
    .Write "</TABLE>" & vbCrLf
    .Write "<input type=""button"" onClick=""FNC_GOBACK();"" " & _
      "value=""　戻 る　"">" & vbCrLf

    .Write "</CENTER></body>" & vbCrLf
    .Write "</html>" & vbCrLf
    If swLOG = 1 Then
      GP_APPEND_LOG strERRMSG
    End If
    .End
  End With
End Sub

'***************************************************************************************************
'ファンクション名 : ログファイル出力
'機能概要	  : ログファイルを作成する'
'パラメータ	 1:strTITLE	
'
'		年月日		名前			変更内容・理由
'作成		2005.12.02	本田			新規
'***************************************************************************************************
Public Sub fnc_Append_Log(strProId,strMSG)
  Const ForAppending = 8
  Dim objFSO, objLOG, strADDR, vntADDR, strYYYYMMDD, dteNow, strLOGFILE

  strADDR = Request.ServerVariables("REMOTE_ADDR")
  vntADDR = Split(strADDR, ".", -1, vbTextCompare)
  strADDR = Right("00" & vntADDR(0), 3) & "." & Right("00" & vntADDR(1), 3) & "." & _
    Right("00" & vntADDR(2), 3) & "." & Right("00" & vntADDR(3), 3)
  dteNow = Date()
  strYYYYMMDD = Year(dteNow) & Right("0" & Month(dteNow), 2) & Right("0" & Day(dteNow), 2)

  strLOGFILE = Const_LogPath &"\"& strYYYYMMDD & ".log"

  dteNow = Now()
  Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
  Set objLOG = objFSO.OpenTextFile(strLOGFILE, ForAppending, True)
  objLOG.Write dteNow & "#" & strADDR & "#" & strProId & "#" &  strMSG & vbCrLf
  objLOG.Close
  Set objLOG = Nothing
  Set objFSO = Nothing
End Sub


%>
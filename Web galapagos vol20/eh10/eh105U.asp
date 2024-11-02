<!--#include File ="../include/page_header_up.inc"-->
<%
'***************************************************************************************************
'プログラム名 : 出庫更新更新画面
'ファイル名	  : eh105U.asp
'copyright	  : takuya honda
'***************************************************************************************************
'画面制御コードを保持する
Session("gid")="105U"

'ページ制御用　変数
Dim GWIDTH				'ページ width
'Dim func				'処理機能 
Dim SYORIFLG			'
Dim fnc

'Form 項目用
'T10SHIP

Dim Rq_ItemCd			'アイテムコード	
Dim Rq_SyuCd			'主CD	
Dim Rq_ItemNm			'アイテム名	
Dim Rq_ItemSuu			'アイテム出庫数
Dim Rq_ItemTanaCd		'アイテム棚番号

Dim Rq_AddDay			'登録日	
Dim Rq_AddId			'登録者ID	
Dim Rq_UpDay			'更新日	
Dim Rq_UpId				'更新者ID	
Dim Rq_DelFlg			'削除FLG	
Dim Rq_IpAddr			'IPADDR	
Dim Rq_Gid				'GID	

Dim Rq_eid				'

Dim Rq_GamenNm
Dim Rq_GamenLv

'Work 用
Dim vntData
Dim vntKengen

GWIDTH="465"
'***********************************************************
'Ｍａｉｎ処理
'***********************************************************

SYORIFLG	=	Trim(Request("EADDCHK"))
fnc = Request("fnc")

'初回画面ロード時の処理*********************************
If SYORIFLG="" Then
	If Session("id")<>"" Then
		If fnc="add" Then
			Session("id")=""
		Else
			Call fnc_DataGet(Session("id"))
		End If
	End If

End If

'以降リロード後の処理************************************

If SYORIFLG="delete" Then		
	call DB_Open
'	connectDB.Execute ("begin transaction")		'transaction開始---------------------------

	If fnc_DataDelete(Session("id"))=true Then
'		connectDB.Execute ("commit transaction")
	Else
'		connectDB.Execute ("rollback transaction")
		Call DSP_ERR_PAGE(Session("GID")&"<br>fnc_DataUpdate<br>"&strSql, "データベースの削除に失敗しました。", 0)
	End If
	call DB_Close
	Call fncMessage( "削除完了しました。","eh1050.asp","_top")
End If

Rq_GamenNm = fncDbDataWGet("MA0画面制御","画面名称","画面番号='" & Session("gid") & "' AND 削除FLG=0",Const_DbAfterOpen)
Rq_GamenLv = fncDbDataWGet("MA0画面制御","権限LV","画面番号='" & Session("gid") & "' AND 削除FLG=0",Const_DbAfterOpen)
If Rq_GamenLv>pvntUSER_EigyouLV Then Response.Redirect "eh1000_menu.asp"
'***********************************************************
'ページ表示
'***********************************************************
%>
<script type='text/javascript' src="../jquery/jquery-ui-1.10.4/js/jquery-1.10.2.js"></script>
<script type='text/javascript' src="../jquery/jquery-ui-1.10.4/js/jquery-ui-1.10.4.min.js"></script>

</HEAD>
<body>
<div id="css_header">
   <div class="inner">
      <div id="logo">
	<a href="<%=Const_url%>"><IMG SRC="../images/logo.gif" ALT="<%= Const_sitename %>"></a>
      </div>
   </div>
</div>


<div id="css_topicpath">
<A href="<%= Const_url %>">トップページ</A> ＞
 <%= Rq_GamenNm %>
</div>

<div id="my_contents">

<FORM NAME="frmSubmit" ACTION="eh<%= Session("gid") %>.asp" METHOD="post" autocomplete="off">
<TABLE width="<%=GWIDTH%>">

	<tr>  
	<td>
	<div style="font-size: 30px;color:blue">【コード】
	<%=Rq_ItemCd %>
	<div>
	</td>
	</tr>

	<tr>
	<td>
	<div style="font-size: 30px;color:blue">【名称】
	<%= Rq_ItemNm %>
	<div>
	</td>
	</tr>
	
	<tr>
	<td>
	<div style="font-size: 30px;color:blue">【棚番号】
	<%= Rq_ItemTanaCd %>
	<div>
	</td>
	</tr>

	<tr>
	<td>
	<div style="font-size: 30px;color:blue">【出庫数】
	<%=Rq_ItemSuu%>
	<div>
	</td>
	</tr>
	
	</TABLE>
※在庫が変更になる場合は直接アイテムマスタの修正お願いします
	<p>
	<BUTTON TYPE="BUTTON" class="deletebutton" onClick="delete_submit();" tabindex="16">削除</BUTTON>
	</p>
	<input type="HIDDEN" NAME="fnc" VALUE="<%= fnc %>">
	<input type="HIDDEN" NAME="EADDCHK" VALUE="">
</FORM>
</div>
</body>

<SCRIPT LANGUAGE="JavaScript">
/////////////////////////////////////////////////////////////
//更新、キャンセルボタンイベント
/////////////////////////////////////////////////////////////

function delete_submit(){
	if (confirm("削除してもよろしいですか？")){
		document.forms['frmSubmit'].EADDCHK.value="delete";
		document.forms['frmSubmit'].submit();
	}
}

</SCRIPT>
</BODY>
</HTML>
<%
'***********************************************************
'ＤＢ読込処理
'***********************************************************
Function fnc_DataGet(inKey)

	Dim ret
	
	ret = false

	strSql		= "SELECT " _
					+ "* "
	strSql = strSql + " FROM V10SHIP "
	strSql = strSql +" WHERE ID="+inKey+"  "
	call DB_Open
	Set rsSql = Server.CreateObject("ADODB.Recordset")
	On Error Resume Next
	rsSql.Open strSql, connectDB, adOpenStatic, adLockReadOnly
	If Err.Number<>0 Then
		Call DSP_ERR_PAGE(Session("GID")&"<br>"&strSql, "予約データベースに接続できませんでした。", 0)
	End If
	If Not rsSql.EOF Then
		Rq_ItemCd		=rsSql("アイテムCD")	
		Rq_ItemNm		=rsSql("アイテム名")	
		Rq_ItemSuu	=rsSql("アイテム出庫数")
		Rq_ItemTanaCd	=rsSql("アイテム棚番号")	

		eid				=rsSql("ID")
	End If

	call DB_Close
	
	fnc_DataGet = ret
End Function

'***********************************************************
'ＤＢ更新処理
'***********************************************************
Function fnc_DataDelete(inKey)

	Dim ret

	ret = false

	If inKey="" Then
		fnc_DataDelete = ret
		Exit Function
	End If

	strSql = "UPDATE T10SHIP SET "
	strSql = strSql + "削除FLG=1," _
					+ "更新日	='"	+FormatDateTime(Now)+"'," _
					+ "更新者ID	='"	+CStr(pvntUSER_EigyouId)+"'," _
					+ "IPADDR	='"	+Request.ServerVariables("REMOTE_ADDR")+"'," _
					+ "GID		='"	+Session("gid")+"' "

	strSql = strSql	+ "WHERE ID="+CStr(inKey)

	On Error Resume Next
	Set rsSql = Server.CreateObject("ADODB.Recordset")
	rsSql.Open strSql, connectDB, adOpenStatic , adLockOptimistic
	If Err.Number=0 Then 
		ret = true
	End If

	fnc_DataDelete = ret
End Function 

%>
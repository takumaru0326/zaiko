﻿<%@ LANGUAGE="vbscript" %>
<!--#include File ="../include/db_relation.inc"-->
<!--#include File ="../include/common_asp.asp"-->
<!--データグリッドヘッダ表示用
	#include File ="../include/common_pageing.asp"-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ja">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="../CSS/com.css" type="text/css">
<%
'***************************************************************************************************
'システム名	  : 在庫管理システム
'プログラム名 : アイテム一覧表示
'ファイル名	  : eh1090.asp
'copyright	  : takuya honda 
'***************************************************************************************************
'画面制御コードを保持する
Session("gid")="1090"
Session("bgid")=Session("gid")

'ページ制御用　変数
Dim GWIDTH				'ページ width
Dim EVCNT				'明細行数
Dim func				'処理機能 
Dim SYORIFLG			'

'Form 用
Dim Rq_ItemKbn		'アイテム区分

Dim Rq_ew				'検索ワード

Dim Rq_Sort

Dim Rq_GamenNm
Dim Rq_GamenLv
Dim Rq_GamenNextLv		'次画面権限

'	work用
Dim vntData
Dim vntArray

GWIDTH="465"	'1080

EVCNT			= "10"
'***********************************************************
'Ｍａｉｎ処理
'***********************************************************
'ログイン者情報を共通変数にセット
Call pvf_User

SYORIFLG=Trim(Request("EADDCHK"))

If SYORIFLG=""  Then
	'データ読込
	fnc_CookieGet()
End If

'以降リロード後の処理***********************************
If SYORIFLG="searth" Then
	fnc_CookieUpdate() 
	Response.Redirect "eh1090.asp" 
End If
If EVCNT="" Then EVCNT="10"

If SYORIFLG="reset" Then
	fnc_CookieReset() 
	Response.Redirect "eh1090.asp"
End If

If SYORIFLG="L_update" Then
	Session("id")=Request("id")

	%>
	<SCRIPT LANGUAGE="JavaScript" >
	top.location.href = 'eh109U.asp?fnc=up&PAGEOLG=<%=Request("PAGEOLG")%>';
	</SCRIPT>
	<%
	Response.End
End If

Rq_GamenNm = fncDbDataWGet("MA0画面制御","画面名称","画面番号='" & Session("gid") & "' AND 削除FLG=0",Const_DbAfterOpen)
Rq_GamenLv = fncDbDataWGet("MA0画面制御","権限LV","画面番号='" & Session("gid") & "' AND 削除FLG=0",Const_DbAfterOpen)
Rq_GamenNextLv = fncDbDataWGet("MA0画面制御","権限LV","画面番号='109U' AND 削除FLG=0",Const_DbAfterOpen)
If Rq_GamenLv>pvntUSER_EigyouLV Then Response.Redirect "eh1000_menu.asp"
'***********************************************************
'ページ表示
'***********************************************************
%>
<TITLE><%= Rq_GamenNm %> - <%= Const_sitename %></TITLE>
<style type="text/css">
<!--
h3{

  color: #000099; /* 文字の色 */
  padding-left: 0px; /* 左の余白 */
  border-width: 0px 0px 0px 0px; /* 枠の幅 */
  border-style: solid; /* 枠の種類 */
  border-color: #9999ff; /* 枠の色 */
  line-height: 100%; /* 行の高さ */
}
-->
</style>
</HEAD>
<BODY>
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
<a href="eh109U.asp?fnc=add"><IMG alt="アイテム追加" border="0" src="../images/AddButton.png"></a>
</div>

	<div id="css_table_list">
	<p></p>
	<FORM NAME="frmSubmit" ACTION="eh<%= Session("gid") %>.asp" METHOD="post" autocomplete="off">
	<div class="search">
		<INPUT TYPE="TEXT" NAME="Rq_ew" SIZE="4" MAXLENGTH="50" VALUE="<%= Rq_ew %>" style="font-size: 30px;ime-mode:active"  onkeypress="if(event.keyCode==13){searth_submit()};">
<%
	Response.Write "　区分"
	 Call fncLRCSet("M90共通","主CD","名称",Rq_ItemKbn,"Rq_ItemKbn",1,"種別='アイテム区分' AND 主CD>=0","名称 DESC ","style=""font-size: 18px;""",0,Const_DbAfterOpen,2)

%>
		<BUTTON TYPE="BUTTON" class="Laddbutton" onClick="searth_submit();" tabindex="16">検索</BUTTON>
		<BUTTON TYPE="button" class="Lresetbutton" onClick="reset_submit();">取消</BUTTON>
		<%
		Call fncLRCSet("M90共通","主CD","名称",EVCNT,"EVCNT",1,"種別='表示件数' AND 主CD>=0","主CD ","style=""font-size: 30px;""",0,Const_DbAfterOpen,2)
		%>
		<INPUT TYPE="HIDDEN" NAME="id" VALUE="">
		<INPUT TYPE="HIDDEN" NAME="EADDCHK" VALUE="">
	</div>
	</FORM>
	
<div id="my_contents">

<div class="contents">
	<%
	fnc_PageSet()
	%>

	</div>
</div>

</div>

</body>
<SCRIPT LANGUAGE="JavaScript">
/////////////////////////////////////////////////////////////
//フォームイニシャライズ
/////////////////////////////////////////////////////////////
//document.forms['frmSubmit'].elements('Rq_SyasyuCD').focus();
<!--
/////////////////////////////////////////////////////////////
//検索、リセットボタンイベント
/////////////////////////////////////////////////////////////
function searth_submit(){
		document.forms['frmSubmit'].EADDCHK.value="searth";
		document.forms['frmSubmit'].submit();

}

function reset_submit(){
	document.forms['frmSubmit'].EADDCHK.value="reset";
	document.forms['frmSubmit'].submit();
}

function Lupdate_submit(inTxt){
	document.forms['frmSubmit'].EADDCHK.value="L_update";
	document.forms['frmSubmit'].id.value=inTxt;
	document.forms['frmSubmit'].submit();
}

-->
</SCRIPT>
</HTML>

<%
SUB fnc_PageSet()
'***********************************************************
'データグリッドヘッダ部
'***********************************************************
sqlselect	= "* "
sqlfrom		= "M70ITEM "
sqlwhere	= "削除FLG=0 "
sqlgroup	= ""
sqlorder	= "アイテムCD "
sqlsum		= ""			'集計用項目を追加する場合のみ指定する

'検索条件セット
fnc_SearchSet

Call DB_Open
fncPageSet sqlselect,sqlfrom,sqlwhere,sqlgroup,sqlorder,sqlsum,GWIDTH,EVCNT,"eh" & Session("gid")
'***********************************************************
'データグリッド明細部
'***********************************************************
%>
<TABLE width="<%=GWIDTH%>">
<%
With Response
 If Not rsSql.EOF Then
	.Write "<TR >"
	.Write "<TH NOWRAP width=""300"">アイテム名</TH>" 
	.Write "<TH NOWRAP width=""50"">在庫数</TH>" 
	.Write "<TH NOWRAP width=""100"">棚番号</TH>" 
	.Write "</TR>"
	intCont = 2
	If Request("PageNow")="" Then 
		j=1
	Else
		j=CLng(Request("PageNow"))
	End If 
	startRECORD = (j-1) * EVCNT +2
	startFLG = 0
	Do While startRECORD+EVCNT>intCont And Not rsSql.EOF
		If startRECORD=intCont Then startFLG = 1
		If startFLG = 1 Then
			.Write "<TR >"
			If pvntUSER_EigyouLV>=Rq_GamenNextLv Then
				.Write "<TD style=""font-size: 26px;""><A HREF=""javascript:Lupdate_submit(" & rsSql("ID") & ")"">" & rsSql("アイテムCD") & ")" & rsSql("アイテム名") & "</A></TD>"
			Else
				.Write "<TD style=""font-size: 26px;"">" & rsSql("アイテムCD") & ")" & rsSql("アイテム名") & "</A></TD>"
			End If
			.Write "<TD style=""font-size: 24px;text-align:right"">" &  FormatNumber(rsSql("アイテム在庫数"),0,0) & "</TD>"
'			.Write "<TD style=""text-align:right"">" &  FormatNumber(rsSql("アイテム金額"),0,0) & "</TD>"
			.Write "<TD style=""font-size: 24px;"">" & rsSql("アイテム棚番号") & "</TD>"
			.Write "</TR>"
		End If
		intCont = intCont + 1
		rsSql.MoveNext
	loop
End If
End With
%>
</TABLE>

</TD></TR>
</TABLE>

</table>

<%

	Call DB_Close
END SUB

'***********************************************************
'検索条件セット
'***********************************************************
SUB fnc_SearchSet()

	If Rq_ItemKbn<>"" And Rq_ItemKbn<>"0" Then sqlwhere=sqlwhere + " AND アイテム区分="+Rq_ItemKbn+" "

	If Rq_ew<>"" Then
		vntData = Replace(Rq_ew,"　"," ")
		vntArray = Split(vntData," ")
		For i=0 To UBound(vntArray)
		sqlwhere = sqlwhere + " AND "
			If i>0 Then sqlwhere = sqlwhere + " AND "
			sqlwhere = sqlwhere + "アイテムCD+アイテム名 Like N'%"+vntArray(i) +"%'" 
		Next
	End If

END SUB

'***********************************************************
'クッキー更新処理
'***********************************************************
Sub fnc_CookieUpdate()
	Dim vntSessionId
	
	vntSessionId = Session("gid")

	With Response
		.Cookies(vntSessionId)("Rq_ew")			= Request("Rq_ew")
		.Cookies(vntSessionId)("Rq_ItemKbn")	= Request("Rq_ItemKbn")
		.Cookies(vntSessionId)("Rq_Sort")		= Request("Rq_Sort")
		.Cookies(vntSessionId)("EVCNT")			= Request("EVCNT")
		.Cookies(vntSessionId).Expires	=DateAdd("m",1,Date)
	End With
End Sub
'***********************************************************
'クッキー読込処理
'***********************************************************
Sub fnc_CookieGet()
	Dim vntSessionId
	
	vntSessionId = Session("gid")

	With Request
		Rq_ew			= .Cookies(vntSessionId)("Rq_ew")
		Rq_ItemKbn	= .Cookies(vntSessionId)("Rq_ItemKbn")
		Rq_Sort = .Cookies(vntSessionId)("Rq_Sort")
		EVCNT = .Cookies(vntSessionId)("EVCNT")

	End With
End Sub

'***********************************************************
'クッキーリセット処理
'***********************************************************
Sub fnc_CookieReset()
	Dim vntSessionId
	
	vntSessionId = Session("gid")
	
	With Response
		.Cookies(vntSessionId)("Rq_ew")			= ""
		.Cookies(vntSessionId)("Rq_ItemKbn")	= fncDbDataWGet("M90共通","主CD","種別='アイテム区分' AND DefaultSelect=1 AND 削除FLG=0",Const_DbAfterOpen)
		.Cookies(vntSessionId)("Rq_Sort")		= "1"
		.Cookies(vntSessionId)("EVCNT")			= "10"
		.Cookies(vntSessionId ).Expires	=DateAdd("m",1,Date)
	End With
End Sub
%>

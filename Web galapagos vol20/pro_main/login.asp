<%@ LANGUAGE="vbscript" %>
<%
'***************************************************************************************************
'システム名	  : 在庫管理システム
'プログラム名 : ログイン画面
'ファイル名	  : login.asp
'copyright	  : takuya honda
'***************************************************************************************************
'Option Explicit
'On Error Resume Next
%>
<!--#include File ="../include/db_relation.inc"-->
<!--#include File ="../include/common_asp.asp"-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Content-Language" content="ja">
<link rel="stylesheet" href="../css/com.css" type="text/css">
<%
'ページ制御用　変数
Dim GWIDTH				'ページ width


Dim SYORIFLG'
Dim st1		' 担当者ID
Dim st2		' 担当者CD
Dim st3		' 担当者名
Dim st4		' ログインcd
Dim st5		' 権限LV

Dim EUSERID
Dim EPASSWORD

'work用
Dim vntData
Dim vntSessionId
	
GWIDTH="445" '455
'***********************************************************
'Ｍａｉｎ処理
'***********************************************************

	SYORIFLG=Trim(Request("EADDCHK"))

	If SYORIFLG="login" Then

		strSql = "SELECT * " _
				+ "FROM M80担当者 " _
				+ "WHERE ログインCD='" & Request("EUSERID") & "' AND 削除FLG=0  " 
'Response.Write strSql
'Response.End
		call DB_Open
		Set rsSql = Server.CreateObject("ADODB.Recordset")
		rsSql.Open strSql, connectDB, adOpenStatic, adLockReadOnly

		If Err.Number<>0 Then
			Call DSP_ERR_PAGE("login", "ログインデータベースに接続できませんでした。", 0)
		End If

		If Not rsSql.EOF Then
			Response.Cookies("acgyoumu")("logon")=rsSql("ログインCD")
			Response.Cookies("acgyoumu").Expires=DateAdd("y",10,Date)
'			Session("id")=Trim(Cstr(rsSql("担当CD")))

			st1 = rsSql("ID")
			st2 = rsSql("担当CD")
			st3 = rsSql("担当名")
			st4 = rsSql("ログインCD")
			st5 = rsSql("権限CD")
		
			Session("USERINFO") = Array(st1,st2,st3,st4,st5)
			Session("SESSIONID") = Session.SessionID
	
			call DB_Close
			
			call DB_Open
			'最終Login日　セット
			If fnc_M20DataUpdate(st1)=true Then
			Else
					Call DSP_ERR_PAGE(Session("GID")&"<br>fnc_M20DataUpdate<br>"&strSql, "会員データベースの更新に失敗しました。", 0)
			End If
			call DB_Close

			Response.Redirect "../eh10/eh1000_menu.asp"
		Else
			Call DSP_ERR_PAGE("", "ユーザＩＤ または　パスワードが不正です。", 0)
		
		End If
		call DB_Close

'		Call DSP_ERR_PAGE("", "ユーザＩＤ または　パスワードが不正です。", 0)
	Else
		EUSERID = Request.Cookies("acgyoumu")("logon")

	End If
	
'***********************************************************
'ページ表示
'***********************************************************
%>
</head>
<body>

<div id="css_header">
   <div class="inner">
      <div id="logo">
	<a href="<%=Const_url%>"><IMG SRC="../images/logo.gif" ALT="<%= Const_sitename %>"></a>
      </div>
   </div>
</div>

<div id="my_contents">
<div id="mymain">
<h2>ログイン</h2>
<div id="mihon">

<br>

	<FORM NAME="frmSubmit" ACTION="login.asp" METHOD="post" action="/form" autocomplete="off">
	<TABLE width="<%=GWIDTH%>">

	<TR >
	<TD colspan="2"><FONT size="2">▼</FONT><FONT size="2">ログインコードを入力してください。</FONT></TD>
	</TR>

	<tr >
	<th>ログインコード</th>
	<td><div class="logtxt"> 
	<INPUT id="id_USERID" TYPE="TEXT" NAME="EUSERID" SIZE="13" MAXLENGTH="13" VALUE="" style="font-size: 32px;type=tel"  onkeyup="setNextFocus(this)" tabindex="1">
	</div>	<!-- logtxt -->
	</td>
	</tr>

	</table>

	<INPUT TYPE="HIDDEN" NAME="EADDCHK" VALUE="">

	</FORM>
</div> <!-- mymihon E -->

</div>
</div>	<!-- main -->

<!--
<div id="css_footer">
   <div class="inner">
      <p id="copyright"><IMG SRC="./images/logo_footer.gif" BORDER="0" ALT="<%= Const_sitename %>"></p>
   </div>
</div>
-->

</BODY>
<SCRIPT LANGUAGE="JavaScript">
/////////////////////////////////////////////////////////////
//フォームイニシャライズ
/////////////////////////////////////////////////////////////
	document.forms['frmSubmit'].elements['EUSERID'].focus();

//	if (navigator.javaEnabled()){
//	} else {
//		window.alert("javaを有効にして下さい");
//	}

/////////////////////////////////////////////////////////////
//ファンクションボタンイベント
/////////////////////////////////////////////////////////////
function page_submit(){
//	if ( jf_FormInputChk() != false ){
		document.forms['frmSubmit'].EADDCHK.value="login";
		document.forms['frmSubmit'].submit();
//	}
}

/////////////////////////////////////////////////////////////
//フォーム項目入力チェック
/////////////////////////////////////////////////////////////
function jf_FormInputChk(){
//ユーザＩＤ
//	if (jpf_FormInputChk("EUSERID","X",20,1,"ユーザＩＤ")==false){
//		return false;
	}

function setNextFocus(obj){
  if(obj.value.length >= obj.maxLength){
		page_submit();
//		var es = document.frmSubmit.elements;
//		for(var i=0;i<es.length;i++){
//			if(es[i] == obj){
//				es[i+1].focus();
//				break;
//			}
//		}
	}
}

/////////////////////////////////////////////////////////////
//ファンクション定義
/////////////////////////////////////////////////////////////
//共通ファンクションインクルード
<!--#include File ="../include/Jsfunc.inc"-->

</SCRIPT>
</HTML>
<%
'***********************************************************
'会員ＤＢ更新処理
'***********************************************************
Function fnc_M20DataUpdate(inKey)	
	Dim ret


	If inKey="" Then 
		fnc_M20DataUpdate = False
		Exit Function
	End If
	
	ret = true

	strSql = "UPDATE M80担当者 SET "
	strSql = strSql + "最終Login日='"	+FormatDateTime(Now)+"' "
	strSql = strSql + "WHERE ID="+CStr(inKey)
	
	On Error Resume Next
	Set rsSql = Server.CreateObject("ADODB.Recordset")
	rsSql.Open strSql, connectDB, adOpenStatic , adLockOptimistic
	If Err.Number<>0 Then 
		ret = false
	End If

	fnc_M20DataUpdate = ret
End Function 
%>
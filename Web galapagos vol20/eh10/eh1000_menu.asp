<!--#include File ="../include/page_header.inc"-->
<%
'***************************************************************************************************
'システム名	  : 在庫管理システム
'プログラム名 : 管理メニュー画面
'ファイル名	  : eh1000_menu.asp
'copyright	  : takuya honda
'***************************************************************************************************
'画面制御コードを保持する
Session("gid")="1000"
%>

<TITLE>管理メニュー画面</TITLE>
<%
'ページ制御用　変数
Dim GWIDTH				'ページ width
Dim GRow				'明細行数
Dim func				'処理機能 
Dim SYORIFLG			'

'Form 用

Dim Rq_GamenNm
	
GWIDTH="445"
'***********************************************************
'Ｍａｉｎ処理
'***********************************************************
' ログイン者情報を共通変数にセット
Call pvf_User

'Response.Write "here"
'Response.End
SYORIFLG	=	Trim(Request("EADDCHK"))
fnc = Request("fnc")

Rq_GamenNm = fncDbDataWGet("MA0画面制御","画面名称","画面番号='" & Session("gid") & "' AND 削除FLG=0",Const_DbAfterOpen)

'以降リロード後の処理************************************
If SYORIFLG="pic" Then
	Response.Redirect "eh1010.asp?fnc=add"
End If

If SYORIFLG="off" Then
	Response.Buffer=True
	Response.CacheControl = "no-cache"
	Response.AddHeader "Pragma", "no-cache"
	Response.Expires = -1
	Session.Abandon
	Response.Redirect "../pro_main/login.asp"
	Response.End
End If

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
	<a href="<%=Const_url & "pro_main/logoff.asp" %>"><div style="font-size: 24px;">ログオフ</div></a>(<%=pvntUSER_EigyouNm%>)
      </div>
   </div>
</div>


<div id="my_contents">
<div id="mymain">

<div class="contents">

	<FORM NAME="frmSubmit" ACTION="eh1000_menu.asp" METHOD="post" autocomplete="off">

<BR>
<%
	call DB_Open

	strSql = "SELECT * FROM MA0画面制御 " _
				+ "WHERE LEFT(画面番号,2)='"+Left(Session("gid"),2)+"' AND SUBSTRING(画面番号,3,2)<>'00'  AND SUBSTRING(画面番号,4,1)='0'AND 削除FLG=0 " _
				+ "AND 権限LV<=" & pvntUSER_EigyouLV
	strSql = strSql + " ORDER BY 画面番号 " 
'Response.Write strSql
'Response.End


'	strSql = "SELECT MA0.* FROM MA0画面制御 AS MA0 " _
'				+ "INNER JOIN MA1画面制御明細 AS MA1 ON MA0.画面番号=MA1.画面番号 AND MA1.担当CD='" & pvntUSER_EigyouCD & "' AND 権限>1 " _
'				+ "WHERE LEFT(MA0.画面番号,2)='"+Left(Session("gid"),2)+"' AND SUBSTRING(MA0.画面番号,3,2)<>'00'  AND SUBSTRING(MA0.画面番号,4,1)='0'AND MA0.削除FLG=0 "
'	strSql = strSql + " ORDER BY MA0.画面番号 " 

	Set rsSql = Server.CreateObject("ADODB.Recordset")
	rsSql.Open strSql, connectDB, adOpenStatic, adLockReadOnly
	i = 1
	If Not rsSql.EOF Then
	   Do While Not rsSql.EOF
		%>
	   	  <DIV ID="div<%= i %>" CLASS="widemenu" STYLE="font-size: 32px;background-color:<%= rsSql("背景色") %>" onmouseover="onMenu(this)" onmouseout="offMenu(this)" onclick="<%= rsSql("実行PRO") %>">
				<font color="<%= rsSql("文字色") %>"><%= rsSql("画面名称") %></font>
	   	  </DIV>
		<%
		  i = i + 1
	      rsSql.MoveNext
	   loop
	Else
	   Response.Write "該当データがありません"
	End If  
	call DB_Close

%>

	<TABLE>

	<tr >
	<th>メニュー番号</th>
	<td><div class="logtxt"> 
	<INPUT ID="id_Submit" TYPE="tel" NAME="Rq_Submit" SIZE="4" MAXLENGTH="3" VALUE="" style="font-size: 18px;"  onkeyup="setNextFocus(this)">
	</div>	<!-- logtxt -->
	</td>
	</tr>

	</table>
	<input type="HIDDEN" NAME="fnc" VALUE="<%= fnc %>">
	<INPUT TYPE="HIDDEN" NAME="EADDCHK" VALUE="">
	</FORM>

</div>
</div>
</div>

<SCRIPT LANGUAGE="JavaScript">
/////////////////////////////////////////////////////////////
//フォームイニシャライズ
/////////////////////////////////////////////////////////////
//window.parent.frames('search').document.forms['frmSubmit'].elements('Rq_EigyouCD').focus();
//function onLoad(){
//	document.forms['frmSubmit'].elements('Rq_ItemCd').focus();
//}
/////////////////////////////////////////////////////////////
//更新、キャンセルボタンイベント
/////////////////////////////////////////////////////////////
function page_submit(){
//		if ( jf_FormInputChk() != false ){
	if (document.forms['frmSubmit'].Rq_Submit.value=="pic"){
			document.forms['frmSubmit'].EADDCHK.value="pic";
			document.forms['frmSubmit'].submit();
//		}
	}
	if (document.forms['frmSubmit'].Rq_Submit.value=="off"){
			document.forms['frmSubmit'].EADDCHK.value="off";
			document.forms['frmSubmit'].submit();
//		}
	}
	

}
/////////////////////////////////////////////////////////////
//フォーム項目入力チェック
/////////////////////////////////////////////////////////////
function jf_FormInputChk(){
	
	var ret;

//	if (jpf_FormInputChk("Rq_ItemCd"	,"X",20,1,"アイテムコード")==false){return false;}
//	if (jpf_FormInputChk("Rq_ItemSuu"	,"N",0,1,"アイテム数")==false){return false;}
}

function setNextFocus(obj){
	if(obj.value.length >= obj.maxLength){
		page_submit();

	}
}

/////////////////////////////////////////////////////////////
//ファンクション定義
/////////////////////////////////////////////////////////////
//共通ファンクションインクルード
<!--#include File ="../include/Jsfunc.inc"-->

jQuery(function($){

	    $('#id_Submit').focus();
		$('#id_Submit').css("ime-mode", "disabled");

});


</SCRIPT>
</BODY>
</html>
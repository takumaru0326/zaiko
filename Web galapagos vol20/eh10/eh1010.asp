 <%@ LANGUAGE="vbscript" %>
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
'プログラム名 : 出庫登録更新
'ファイル名	  : eh1010.asp
'copyright	  : takuya honda
'***************************************************************************************************
'画面制御コードを保持する
Session("gid")="1010"
Session("bgid")=Session("gid")

'ページ制御用　変数
Dim GWIDTH				'ページ width
'Dim func				'処理機能 
Dim SYORIFLG			'
Dim fnc
'Form 項目用

Dim Rq_ID			'ID	
Dim Rq_ItemCd		'アイテムコード	          
Dim Rq_ItemNm		'アイテム名	
Dim Rq_ItemSuu		'アイテム出庫数
Dim Rq_ItemZaiSuu	'アイテム在庫数	
Dim Rq_ItemDLYmd	'アイテム使用期限

Dim Rq_AddDay		'登録日	
Dim Rq_AddId		'登録者ID	
Dim Rq_UpDay		'更新日	
Dim Rq_UpId			'更新者ID	
Dim Rq_DelFlg		'削除FLG	
Dim Rq_IpAddr		'IPADDR	
Dim Rq_Gid			'GID	

Dim Rq_eid				'

Dim Rq_GamenNm

'Work 用
Dim vntData
Dim vntKengen

GWIDTH="445" '455

EVCNT			= "10"
'***********************************************************
'Ｍａｉｎ処理
'***********************************************************
' ログイン者情報を共通変数にセット
Call pvf_User

SYORIFLG	=	Trim(Request("EADDCHK"))
fnc = Request("fnc")

'初回画面ロード時の処理*********************************
If SYORIFLG="" Then
	If Session("id")<>"" Then
'		Response.Write Session("id")
		If fnc="add" Then
			Session("id")=""
		Else
			Call fnc_DataGet(Session("id"))
		End If
	Else
		If fnc="add" Then
		End If 
	End If
End If

'以降リロード後の処理************************************
If SYORIFLG="add" Then
	
	call DB_Open
'	connectDB.Execute ("SET IMPLICIT_TRANSACTIONS ON;")	
	connectDB.Execute ("begin transaction")		'transaction開始---------------------------

	vntData = fncDbDataWGet("M70ITEM","アイテム在庫数","アイテムCD='" & Request("Rq_ItemCd") & "' AND 削除FLG=0",Const_DbBeforeOpen)
	vntData = vntData - CInt(Request("Rq_ItemSuu"))
	
	If fnc_M70DataUpdate(Request("Rq_ItemCd"),vntData)=true Then
		If fnc_DataAdd()=true Then
			connectDB.Execute ("commit transaction")
		Else
			connectDB.Execute ("rollback transaction")
			Call DSP_ERR_PAGE(Session("GID")&"<br>fnc_DataAdd<br>"&strSql, "収支データベースの更新に失敗しました。", 0)
		End If
	Else
		connectDB.Execute ("rollback transaction")
		Call DSP_ERR_PAGE(Session("GID")&"<br>fnc_DataAdd<br>"&strSql, "収支データベースの更新に失敗しました。", 0)
	End If
	call DB_Close
	Session("eid")=CStr(Rq_eid)
'	Call fncMessage( "登録完了しました。","eh1010.asp?fnc=add","_top")
	Response.Redirect "eh1010.asp?fnc=add"

End If

If SYORIFLG="reset" Then
	fnc_CookieReset() 
	Response.Redirect "eh1010.asp"
End If

Rq_GamenNm = fncDbDataWGet("MA0画面制御","画面名称","画面番号='" & Session("gid") & "' AND 削除FLG=0",Const_DbAfterOpen)

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
<%
	Response.Write Rq_GamenNm  
	If fnc ="add" Then Response.Write " 登録"
	If fnc ="up" Then Response.Write " 更新"
%>
</div>



<div id="my_contents">
<div id="mymain">
<div id="mihon">
<FORM NAME="frmSubmit" ACTION="eh<%= Session("gid") %>.asp" METHOD="post" autocomplete="off" >
	<TABLE width="<%=GWIDTH%>">
	<tr>
	<td>
	<div style="font-size: 30px;color:blue">【アイテム】
	<input id="id_ItemCd" type="tel" NAME="Rq_ItemCd" SIZE="30" MAXLENGTH="6" VALUE="" style="font-size: 36px;width: 4em;max-width: 100%;" onkeyup="setNextFocus(this)" tabindex="1">
	</div>
	<SPAN ID="id_ItemNm" style="font-size: 32px"><%= Rq_ItemNm %></SPAN>
	</td>
	</tr>

	<tr>
	<td>
	<div style="font-size: 30px;">【棚番号】<SPAN ID="id_ItemTanaCd"></SPAN></div>
	</td>
	</tr>
	
	<tr>
	<td>
	<div style="font-size: 30px;">【在庫数】<SPAN ID="id_ItemZaikoSuu"></SPAN></div>
	</td>
	</tr>
	
	<tr>
	<td>
	<div style="font-size: 30px;color:green">【出庫数】
	<input id="id_ItemSuu" type="number" NAME="Rq_ItemSuu" SIZE="8" MAXLENGTH="6" VALUE="" style="font-size: 36px;width: 4em;max-width: 100%;ime-mode:inactive"  onkeypress="if(event.keyCode==13){frmSubmit.elements['Rq_ItemRCd'].focus()};" tabindex="2">
	</div>
	</td>
	</tr>

	<tr>
	<td>
	<div style="font-size: 30px;color:blue">【再読込】
	<input id="id_ItemRCd" type="tel" NAME="Rq_ItemRCd" SIZE="30" MAXLENGTH="6" VALUE="" style="font-size: 36px;width: 4em;max-width: 100%;" onkeyup="setNextFocus(this)" tabindex="3"></div>
	<div style="font-size: 20px;color:red">バーコード再読込</div>
	</td>
	</tr>	
	</table>

	<p>
<!--	<BUTTON TYPE="button" class="Lresetbutton" onClick="reset_submit();">取消</BUTTON> -->
	</p>
	<input type="HIDDEN" NAME="fnc" VALUE="<%= fnc %>">
	<input type="HIDDEN" NAME="EADDCHK" VALUE="">
	<input type="HIDDEN" NAME="Rq_Id" VALUE="<%=Rq_Id%>">
	<INPUT id="id_ItemZaiSuu" type="HIDDEN" NAME="Rq_ItemZaiSuu" VALUE="">


</FORM>

</div> <!-- mymihon E -->



</div>
</div>
</body>

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

	if (document.forms['frmSubmit'].Rq_ItemCd.value=="off"){
			document.forms['frmSubmit'].EADDCHK.value="off";
			document.forms['frmSubmit'].submit();
	}
}
function add_submit(){
		if ( jf_FormInputChk() != false ){
			document.forms['frmSubmit'].EADDCHK.value="add";
			document.forms['frmSubmit'].submit();
		}
}


function reset_submit(){
	document.forms['frmSubmit'].EADDCHK.value="reset";
	document.forms['frmSubmit'].submit();
}

/////////////////////////////////////////////////////////////
//フォーム項目入力チェック
/////////////////////////////////////////////////////////////
function jf_FormInputChk(){
	
	var ret;

	if (jpf_FormInputChk("Rq_ItemCd"	,"X",20,1,"アイテムコード")==false){return false;}
	if (jpf_FormInputChk("Rq_ItemSuu"	,"N",0,1,"アイテム数")==false){return false;}
	
}

function setNextFocus(obj){

	var vntItemSuu;
	var vntItemZaiSuu;

	vntItemSuu = document.forms['frmSubmit'].Rq_ItemSuu.value;
	vntItemZaiSuu = document.forms['frmSubmit'].Rq_ItemZaiSuu.value;

	if(obj.value.length >= obj.maxLength){
		if (obj.id == "id_ItemRCd"){
			if (document.forms['frmSubmit'].Rq_ItemCd.value == document.forms['frmSubmit'].Rq_ItemRCd.value && vntItemSuu.length!=0){
				if (Number(vntItemSuu) >= Number(vntItemZaiSuu)){
					alert("出庫数が在庫数を超えてます。\n　【ENT】ボタンを押して下さい");
					document.forms['frmSubmit'].elements['Rq_ItemSuu'].value= '';
					document.forms['frmSubmit'].elements['Rq_ItemRCd'].value='';
					document.forms['frmSubmit'].elements['Rq_ItemSuu'].focus();
					return false;
				} else {
					add_submit();
				}
			} else {
				if (vntItemSuu.length == 0){
					alert("出庫数を入力して下さい。\n　【ENT】ボタンを押して下さい");
					document.forms['frmSubmit'].elements['Rq_ItemRCd'].value='';
					document.forms['frmSubmit'].elements['Rq_ItemSuu'].focus();
					return false;
				} else {
					alert("アイテムコードが一致していません。\n　【ENT】ボタンを押して下さい");
					document.forms['frmSubmit'].elements['Rq_ItemRCd'].focus();
					document.forms['frmSubmit'].elements['Rq_ItemRCd'].value='';
					return false;
				}
			
			}
		}
		var es = document.frmSubmit.elements;
		for(var i=0;i<es.length;i++){
			if(es[i] == obj){
				es[i+1].focus();
				break;
			}
		}
	}
}

/////////////////////////////////////////////////////////////
//ファンクション定義
/////////////////////////////////////////////////////////////
//共通ファンクションインクルード
<!--#include File ="../include/Jsfunc.inc"-->

function disp(url){window.open(url, "", "width=320,height=400,scrollbars=yes,resizable=yes,status=yes");}

jQuery(function($){

		var url		= '../pL0/jq_item.asp';

	$('#id_ItemCd').focus();

	// アイテム名称
	$('#id_ItemCd').change(function(){

		var itemCd	= $(this).val();
		var url		= '../pL0/jq_item.asp';
		var query	= {'JQ_itemCd': itemCd};
		$.getJSON(url, query, function(json){
			$('#id_ItemNm').text(json.itemNm);
			$('#id_ItemZaikoSuu').text(json.itemSuu);
			$('#id_ItemTanaCd').text(json.itemTanaCd);
			$('#id_ItemZaiSuu').val(json.itemSuu);
			if(json.itemNm==[]){
				$('#id_ItemCd').focus();
				alert("該当するアイテムコードがありません。\n　【ENT】ボタンを押して下さい");
				reset_submit();
			}
			
			if(json.itemDelFlg!=0){
				$('#id_ItemCd').focus();
				alert("このアイテムは使用期限切れです。\n　【ENT】ボタンを押して下さい");
				reset_submit();
			}
			
			if(json.itemSession==[]){
				alert("接続が切れました　再ログインが必要です。\n　【ENT】ボタンを押して下さい");
				reset_submit();
			}
		});
	});

});


</SCRIPT>
</BODY>
</HTML>
<%
SUB fnc_PageSet()
'***********************************************************
'データグリッドヘッダ部
'***********************************************************
sqlselect	= "* "
sqlfrom		= "V10SHIP "
sqlwhere	= "削除FLG=0 "
sqlgroup	= ""
sqlorder	= "ID DESC "
sqlsum		= ""			'集計用項目を追加する場合のみ指定する

'検索条件セット
fnc_SearchSet
'Response.Write sqlwhere
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
			.Write "<TH NOWRAP width=""150"">アイテムコード</TH>" 
			.Write "<TH NOWRAP width=""500"">アイテム名</TH>" 
			.Write "<TH NOWRAP width=""100"">出庫数</TH>" 
			.Write "<TH NOWRAP width=""50""></TH>" 
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
					.Write "<TD>" & rsSql("アイテムCD") & "</TD>"
					.Write "<TD>" & rsSql("アイテム名") & "</TD>"
					.Write "<TD style=""text-align:right"">" &  FormatNumber(rsSql("アイテム出庫数"),0,0) & "</TD>"
					.Write "<TD>" 

					%>
						<BUTTON TYPE="BUTTON" class="supdatebutton" onClick="Lupdate_submit(<%=rsSql("ID")%>);">更新</BUTTON>
					<%
					.Write "</TD>"
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

	sqlwhere = sqlwhere + "AND アイテム出庫YMD='"	+ fncTodayYMD() +		"' "
	sqlwhere = sqlwhere + "AND ログインCD='"+pvntUSER_EigyouBCD+"' "

END SUB

'***********************************************************
'クッキー更新処理
'***********************************************************
Sub fnc_CookieUpdate()
	Dim vntSessionId
	
	vntSessionId = Session("gid")
	
	With Response
		.Cookies(vntSessionId)("Rq_ew")			= Request("Rq_ew")
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
		.Cookies(vntSessionId)("Rq_Sort")		= "1"
		.Cookies(vntSessionId)("EVCNT")			= "10"
		.Cookies(vntSessionId ).Expires	=DateAdd("m",1,Date)
	End With
End Sub

'***********************************************************
'ＤＢ読込処理
'***********************************************************
Function fnc_DataGet(inKey)

	Dim ret
	
	ret = false

	strSql		= "SELECT " _
					+ "* "
	strSql = strSql + " FROM T10SHIP "
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
		Rq_ItemSuu		=rsSql("アイテム出庫数")
		eid				=rsSql("ID")
	End If

	call DB_Close
	
	fnc_DataGet = ret
End Function

'***********************************************************
'ＤＢ登録処理
'***********************************************************
Function fnc_DataAdd()	
	Dim ret
	Dim vntfncNoMax
	
	ret = true

	strSql = "INSERT INTO T10SHIP("
	strSql = strSql + "アイテムCD,"
	strSql = strSql + "アイテム出庫数,"
	strSql = strSql + "アイテム出庫YMD,"
	strSql = strSql + "担当CD,"
	strSql = strSql + "登録日,"
	strSql = strSql + "登録者ID,"
	strSql = strSql + "IPADDR,"
	strSql = strSql + "GID "
	strSql = strSql + ") "
	strSql = strSql + "VALUES("

	strSql = strSql + "'"+Request("Rq_ItemCd")+"',"
	strSql = strSql + "'"+Request("Rq_ItemSuu")+"',"
	strSql = strSql + "'"+fncTodayYMD()+"',"
	strSql = strSql + "'"+CStr(pvntUSER_EigyouCD)+"',"
	strSql = strSql + "'"+FormatDateTime(Now) + "',"
	strSql = strSql + "'"+CStr(pvntUSER_EigyouId)+"',"
	strSql = strSql + "'"+Request.ServerVariables("REMOTE_ADDR")+"',"
	strSql = strSql + "'"+Session("gid")+"' "
	strSql = strSql + ") "

	On Error Resume Next
	Set rsSql = Server.CreateObject("ADODB.Recordset")
	rsSql.Open strSql, connectDB, adOpenStatic , adLockOptimistic
	If Err.Number<>0 Then 
		ret = false
	Else
	End If

	fnc_DataAdd = ret
End Function 

'***********************************************************
'ＤＢ更新処理
'***********************************************************
Function fnc_DataUpdate(inId)

	Dim ret

	ret = false
	
	If inId="" Then
		fnc_DataUpdate = ret
		Exit Function
	End If

'	call DB_Open
	strSql = "UPDATE T10SHIP SET "
	strSql = strSql + "アイテムコード	='"	+Request("Rq_ItemCd")+"',"
	strSql = strSql + "アイテム出庫数	='"	+Request("Rq_ItemSuu")+"',"

	strSql = strSql + "更新日	='"	+FormatDateTime(Now)+"'," _
					+ "更新者ID	='"	+CStr(pvntUSER_EigyouId)+"'," _
					+ "IPADDR	='"	+Request.ServerVariables("REMOTE_ADDR")+"'," _
					+ "GID		='"	+Session("gid")+"' "
	strSql = strSql + "WHERE ID='"	+CStr(inId)+"'" 

	On Error Resume Next
	Set rsSql = Server.CreateObject("ADODB.Recordset")
	rsSql.Open strSql, connectDB, adOpenStatic , adLockOptimistic
	If Err.Number=0 Then 
		ret = true
	End If

	fnc_DataUpdate = ret
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

'***********************************************************
'ＤＢ更新処理（在庫マイナス)
'***********************************************************
Function fnc_M70DataUpdate(inId,inSuu)

	Dim ret

	ret = false
	
	If inId="" Then
		fnc_M70DataUpdate = ret
		Exit Function
	End If

'	call DB_Open
	strSql = "UPDATE M70ITEM SET "

	strSql = strSql + "アイテム在庫数	="	+CStr(inSuu)+","

	strSql = strSql + "更新日	='"	+FormatDateTime(Now)+"'," _
					+ "更新者ID	='"	+CStr(pvntUSER_EigyouId)+"'," _
					+ "IPADDR	='"	+Request.ServerVariables("REMOTE_ADDR")+"'," _
					+ "GID		='"	+Session("gid")+"' "
	strSql = strSql + "WHERE アイテムCD='"	+CStr(inId)+"' AND 削除FLG=0 " 

	On Error Resume Next
	Set rsSql = Server.CreateObject("ADODB.Recordset")
	rsSql.Open strSql, connectDB, adOpenStatic , adLockOptimistic
	If Err.Number=0 Then 
		ret = true
	End If

	fnc_M70DataUpdate = ret
End Function 

%>
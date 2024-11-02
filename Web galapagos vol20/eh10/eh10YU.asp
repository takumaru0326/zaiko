<!--#include File ="../include/page_header_up.inc"-->
<%
'***************************************************************************************************
'プログラム名 : 共通マスタ登録更新画面
'ファイル名	  : eh10YU.asp
'copyright	  : takuya honda
'***************************************************************************************************
'画面制御コードを保持する
Session("gid")="10YU"

'ページ制御用　変数
Dim GWIDTH				'ページ width
'Dim func				'処理機能 
Dim SYORIFLG			'
Dim fnc

'Form 項目用
'M90共通

Dim Rq_SyubetuCd		'種別CD	
Dim Rq_SyubetuNm		'種別	
Dim Rq_SyuCd			'主CD	
Dim Rq_SyuNm			'名称	
Dim Rq_Control			'Control	
Dim Rq_DefaultSelect	'DefaultSelect	
Dim Rq_SyuCDataType		'主CDDataType	

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
If SYORIFLG="add" Then
	
	call DB_Open
	connectDB.Execute ("begin transaction")		'transaction開始---------------------------

	If fnc_DataAdd()=true Then
		connectDB.Execute ("commit transaction")
	Else
		connectDB.Execute ("rollback transaction")
		Call DSP_ERR_PAGE(Session("GID")&"<br>fnc_DataAdd<br>"&strSql, "収支データベースの更新に失敗しました。", 0)
	End If
	call DB_Close

	Call fncMessage( "登録完了しました。","eh10Y0.asp","_top")

End If

If SYORIFLG="update" Then
	call DB_Open
	connectDB.Execute ("begin transaction")		'transaction開始---------------------------

	If fnc_DataUpdate(Session("id"))=true Then
		connectDB.Execute ("commit transaction")
	Else
		connectDB.Execute ("rollback transaction")
		Call DSP_ERR_PAGE(Session("GID")&"<br>fnc_DataUpdate<br>"&strSql, "データベースの更新に失敗しました。", 0)
	End If
	call DB_Close
	
	Call fncMessage( "更新完了しました。","eh10Y0.asp","_top")

End If

If SYORIFLG="delete" Then		
	call DB_Open
	connectDB.Execute ("begin transaction")		'transaction開始---------------------------

	If fnc_DataDelete(Session("id"))=true Then
		connectDB.Execute ("commit transaction")
	Else
		connectDB.Execute ("rollback transaction")
		Call DSP_ERR_PAGE(Session("GID")&"<br>fnc_DataUpdate<br>"&strSql, "データベースの削除に失敗しました。", 0)
	End If
	call DB_Close
	Call fncMessage( "削除完了しました。","eh10Y0.asp","_top")
End If

If SYORIFLG="print" Then
	Session("eid")=Session("id")
	Response.Redirect "sk1020_prt.asp"
End If

Rq_GamenNm = fncDbDataWGet("MA0画面制御","画面名称","画面番号='" & Session("gid") & "' AND 削除FLG=0",Const_DbAfterOpen)
Rq_GamenLv = fncDbDataWGet("MA0画面制御","権限LV","画面番号='" & Session("gid") & "' AND 削除FLG=0",Const_DbAfterOpen)
If Rq_GamenLv>pvntUSER_EigyouLV Then Response.Redirect "eh1000_menu.asp"
'***********************************************************
'ページ表示
'***********************************************************
%>
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
<FORM NAME="frmSubmit" ACTION="eh<%= Session("gid") %>.asp" METHOD="post" autocomplete="off">
<TABLE width="<%= GWIDTH %>">

	<tr>
	<td>
	<div style="font-size: 30px;color:blue">【種別CD】
	<INPUT TYPE="TEXT" NAME="Rq_SyubetuCd" SIZE="4" MAXLENGTH="4" VALUE="<%= Rq_SyubetuCd %>" style="font-size: 30px;ime-mode:inactive" tabindex="13">
	<div>
	</td>
	</tr>
	
	<tr>
	<td>
	<div style="font-size: 30px;color:blue">【種別】
	<INPUT TYPE="TEXT" NAME="Rq_SyubetuNm" SIZE="15" MAXLENGTH="50" VALUE="<%= Rq_SyubetuNm %>" style="font-size: 30px;ime-mode:active" tabindex="13">
	<div>
	</td>
	</tr>

	<tr>
	<td>
	<div style="font-size: 30px;color:blue">【主コード】
	<INPUT TYPE="TEXT" NAME="Rq_SyuCd" SIZE="3" MAXLENGTH="3" VALUE="<%= Rq_SyuCd %>" style="font-size: 30px;ime-mode:inactive" tabindex="13">
	<div>
	</td>
	</tr>

	<tr>
	<td>
	<div style="font-size: 30px;color:blue">【名称】
	<INPUT TYPE="TEXT" NAME="Rq_SyuNm" SIZE="15" MAXLENGTH="40" VALUE="<%= Rq_SyuNm %>" style="font-size: 30px;ime-mode:active" tabindex="13">
	<div>
	</td>
	</tr>

	<tr>
	<td>
	<div style="font-size: 30px;color:blue">【Control】
	<INPUT TYPE="TEXT" NAME="Rq_Control" SIZE="15" MAXLENGTH="100" VALUE="<%= Rq_Control %>" style="font-size: 30px;ime-mode:inactive" tabindex="13">
	<div>
	</td>
	</tr>

	</TABLE>

	<p>
	<% If fnc ="add" Then %>
		<BUTTON TYPE="BUTTON" class="addbutton" onClick="add_submit();" tabindex="16">登録</BUTTON>
		<br>
		
	<% End If %>
	<% If fnc ="up" Then %>
		<BUTTON TYPE="BUTTON" class="addbutton" onClick="update_submit();" tabindex="16">更新</BUTTON>
		<BUTTON TYPE="BUTTON" class="deletebutton" onClick="delete_submit();" tabindex="17">削除</BUTTON>
	<% End If %>
	</p>
	<input type="HIDDEN" NAME="fnc" VALUE="<%= fnc %>">
	<input type="HIDDEN" NAME="EADDCHK" VALUE="">
</FORM>
</div>
</body>

<SCRIPT LANGUAGE="JavaScript">
/////////////////////////////////////////////////////////////
//フォームイニシャライズ
/////////////////////////////////////////////////////////////
//window.parent.frames('search').document.forms['frmSubmit'].elements('Rq_EigyouCD').focus();
//function onLoad(){
//	document.forms['frmSubmit'].elements('Rq_UkeDaySHH').focus();
//}
/////////////////////////////////////////////////////////////
//更新、キャンセルボタンイベント
/////////////////////////////////////////////////////////////
function add_submit(){
		if ( jf_FormInputChk() != false ){
			document.forms['frmSubmit'].EADDCHK.value="add";
			document.forms['frmSubmit'].submit();
		}
}

function update_submit(){
	if (confirm("更新してもよろしいですか？")){
		if ( jf_FormInputChk() != false ){
			document.forms['frmSubmit'].EADDCHK.value="update";
			document.forms['frmSubmit'].submit();
		}
	}
}

function delete_submit(){
	if (confirm("削除してもよろしいですか？")){
		document.forms['frmSubmit'].EADDCHK.value="delete";
		document.forms['frmSubmit'].submit();
	}
}

/////////////////////////////////////////////////////////////
//フォーム項目入力チェック
/////////////////////////////////////////////////////////////
function jf_FormInputChk(){
	
	var ret;

//	if (jpf_FormInputChk("Rq_Kingaku"	,"N",0,1,"金額")==false){return false;}
}

/////////////////////////////////////////////////////////////
//ファンクション定義
/////////////////////////////////////////////////////////////
//共通ファンクションインクルード
<!--#include File ="../include/Jsfunc.inc"-->

function disp(url){window.open(url, "", "width=330,height=550,scrollbars=yes,resizable=yes,status=yes");}

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
	strSql = strSql + " FROM M90共通 "
	strSql = strSql +" WHERE ID="+inKey+"  "
	call DB_Open
	Set rsSql = Server.CreateObject("ADODB.Recordset")
	On Error Resume Next
	rsSql.Open strSql, connectDB, adOpenStatic, adLockReadOnly
	If Err.Number<>0 Then
		Call DSP_ERR_PAGE(Session("GID")&"<br>"&strSql, "予約データベースに接続できませんでした。", 0)
	End If
	If Not rsSql.EOF Then
		Rq_SyubetuCd		=rsSql("種別CD")	
		Rq_SyubetuNm		=rsSql("種別")	
		Rq_SyuCd			=rsSql("主CD")	
		Rq_SyuNm			=rsSql("名称")	
		Rq_Control			=rsSql("Control")	
		Rq_DefaultSelect	=rsSql("DefaultSelect")	
		Rq_SyuCDataType		=rsSql("主CDDataType")	

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

	strSql = "INSERT INTO M90共通("
	strSql = strSql + "種別CD,"
	strSql = strSql + "種別,"
	strSql = strSql + "主CD,"
	strSql = strSql + "名称,"
	strSql = strSql + "Control,"
	strSql = strSql + "DefaultSelect,"
	strSql = strSql + "主CDDataType,"

	strSql = strSql + "登録日,"
	strSql = strSql + "登録者ID,"
	strSql = strSql + "GID "
	strSql = strSql + ") "
	strSql = strSql + "VALUES("

	strSql = strSql + "'"+Request("Rq_SyubetuCd")+"',"			'種別CD	
	strSql = strSql + "'"+Request("Rq_SyubetuNm")+"',"			'種別	
	strSql = strSql + "'"+Request("Rq_SyuCd")+"',"				'主CD
	strSql = strSql + "'"+Request("Rq_SyuNm")+"',"				'名称"	
	strSql = strSql + "'"+Request("Rq_Control")+"',"		'Control	
	strSql = strSql + "'"+Request("Rq_DefaultSelect")+"',"	'DefaultSelect	
	strSql = strSql + "'"+Request("Rq_SyuCDataType")+"',"	'主CDDataType	

	strSql = strSql + "'"+FormatDateTime(Now) + "',"
	strSql = strSql + "'"+CStr(pvntUSER_EigyouId)+"',"
	strSql = strSql + "'"+Session("gid")+"' "
	strSql = strSql + ") "
'Response.Write strSql
'Response.End
	On Error Resume Next
	Set rsSql = Server.CreateObject("ADODB.Recordset")
	rsSql.Open strSql, connectDB, adOpenStatic , adLockOptimistic
	If Err.Number<>0 Then 
		ret = false
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
	strSql = "UPDATE M90共通 SET "

	strSql = strSql + "種別CD		='"+Request("Rq_SyubetuCd")+"',"
	strSql = strSql + "種別			='"+Request("Rq_SyubetuNm")+"',"
	strSql = strSql + "主CD			='"+Request("Rq_SyuCd")+"',"
	strSql = strSql + "名称			='"+Request("Rq_SyuNm")+"',"
	strSql = strSql + "Control		='"+Request("Rq_Control")+"',"
	strSql = strSql + "DefaultSelect	='"+Request("Rq_DefaultSelect")+"',"
	strSql = strSql + "主CDDataType	='"+Request("Rq_SyuCDataType")+"',"

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

	strSql = "UPDATE M90共通 SET "
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
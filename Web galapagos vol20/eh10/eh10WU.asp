<!--#include File ="../include/page_header_up.inc"-->
<%
'***************************************************************************************************
'システム名	  : 在庫管理システム
'プログラム名 : 担当者登録更新画面
'ファイル名	  : eh10W0.asp
'copyright	  : takuya honda
'***************************************************************************************************
'画面制御コードを保持する
Session("gid")="10WU"

'ページ制御用　変数
Dim GWIDTH				'ページ width
Dim SYORIFLG			'
Dim fnc

Dim EID
Dim Rq_Cd				'担当コード
Dim Rq_Name				'担当名
Dim Rq_BosyuCd			'ログインコード
Dim PASSWORD
Dim Rq_KengenCd			'権限レベル
Dim Rq_Bikou			'担当備考

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

GWIDTH		="465" '800
'***********************************************************
'Ｍａｉｎ処理
'***********************************************************
SYORIFLG=Trim(Request("EADDCHK"))
fnc = Request("fnc")

'アカウント数取得
'Rq_M00Accunt=fncDbDataGet("M00Control","削除FLG","アカウント数",0,"N",1)

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
	'connectDB.Execute ("begin transaction")		'transaction開始---------------------------

	If fnc_DataAdd()=true Then
	'	connectDB.Execute ("commit transaction")
	Else
	'	connectDB.Execute ("rollback transaction")
		Call DSP_ERR_PAGE(Session("GID")&"<br>fnc_DataAdd<br>"&strSql, "データベースの登録に失敗しました。", 0)
	End If
	call DB_Close

	Call fncMessage( "登録完了しました。","eh10W0.asp","_top")

End If

If SYORIFLG="update" Then
	call DB_Open
	'connectDB.Execute ("begin transaction")		'transaction開始---------------------------

	If fnc_DataUpdate(Session("id"))=true Then
		'connectDB.Execute ("commit transaction")
	Else
		'connectDB.Execute ("rollback transaction")
		Call DSP_ERR_PAGE(Session("GID")&"<br>fnc_DataUpdate<br>"&strSql, "データベースの更新に失敗しました。", 0)
	End If
	call DB_Close
	
	Call fncMessage( "更新完了しました。","eh10W0.asp","_top")

End If

If SYORIFLG="delete" Then		
	call DB_Open
	'connectDB.Execute ("begin transaction")		'transaction開始---------------------------

	If fnc_DataDelete(Session("id"))=true Then
	'	connectDB.Execute ("commit transaction")
	Else
	'	connectDB.Execute ("rollback transaction")
		Call DSP_ERR_PAGE(Session("GID")&"<br>fnc_DataUpdate<br>"&strSql, "データベースの削除に失敗しました。", 0)
	End If
	call DB_Close
	Call fncMessage( "削除完了しました。","eh10W0.asp","_top")
End If

Rq_GamenNm = fncDbDataWGet("MA0画面制御","画面名称","画面番号='" & Session("gid") & "' AND 削除FLG=0",Const_DbAfterOpen)
Rq_GamenLv = fncDbDataWGet("MA0画面制御","権限LV","画面番号='" & Session("gid") & "' AND 削除FLG=0",Const_DbAfterOpen)
If Rq_GamenLv>pvntUSER_EigyouLV Then Response.Redirect "eh1000_menu.asp"
'***********************************************************
'ページ表示
'***********************************************************
%>
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
<A href="<%= Const_url %>">トップページ</A> ＞ <A href="eh<%=Session("bgid")%>.asp">一覧に戻る</A> ＞
<%
	Response.Write Rq_GamenNm
	If fnc ="add" Then Response.Write " 登録"
	If fnc ="up" Then Response.Write " 更新"
%>
</div>

<div id="my_contents">
<FORM NAME="frmSubmit" ACTION="eh<%= Session("gid") %>.asp" METHOD="post" autocomplete="off">
<TABLE width="<%=GWIDTH%>">

	<tr>
	<td>
	<div style="font-size: 30px;color:blue">【コード】
	<% If fnc="up" Then %>
		<input type="hidden"  NAME="Rq_Cd" VALUE="<%=Rq_Cd%>"><%=Rq_Cd%>
	<% Else %>
		<INPUT TYPE="TEXT" NAME="Rq_Cd" SIZE="7" MAXLENGTH="5" VALUE="<%=Rq_Cd%>" style="font-size: 30px;ime-mode:inactive" tabindex="1">
	<% End If %>
	<div>
	</td>
	</tr>
	
	<tr>
	<td>
	<div style="font-size: 30px;color:blue">【担当名】
	<INPUT TYPE="TEXT" NAME="Rq_Name" SIZE="10" MAXLENGTH="20" VALUE="<%=Rq_Name%>" style="font-size: 30px;ime-mode:active" tabindex="2">
	<div>
	</td>
	</tr>
	
	<tr>
	<td>
	<div style="font-size: 30px;color:blue">【ﾛｸﾞｲﾝｺｰﾄﾞ】
	<INPUT TYPE="TEXT" NAME="Rq_BosyuCd" SIZE="10" MAXLENGTH="20" VALUE="<%=Rq_BosyuCd%>" style="font-size: 30px;ime-mode:active" tabindex="3">
	<div>
	</td>
	</tr>

	<tr>	
	<td>
	<div style="font-size: 30px;color:blue">【権限】
	<%
	Call fncLRCSet("M90共通","主CD","名称",Rq_KengenCd,"Rq_KengenCd",1,"種別='権限レベル' AND 主CD>=0","名称 DESC ","style=""font-size: 30px;""",0,Const_DbAfterOpen,2)
	%>
	<div>
	</td>
	</tr>
	
	<tr>
	<td>
	<div style="font-size: 30px;color:blue">【備考】
	<INPUT TYPE="TEXT" NAME="Rq_Bikou" SIZE="15" MAXLENGTH="100" VALUE="<%=Rq_Bikou%>" style="font-size: 30px;ime-mode:active" tabindex="5">
	<div>
	</td>
	</tr>
			
	</TABLE>
	<p>
	<% If fnc="add" Then %>
		<BUTTON TYPE="BUTTON" class="addbutton" onClick="add_submit();" tabindex="16">登録</BUTTON><br>
	<% Else %>
		<BUTTON TYPE="BUTTON" class="updatebutton" onClick="update_submit();" tabindex="16">更新</BUTTON>
		<BUTTON TYPE="BUTTON" class="deletebutton" onClick="delete_submit();" tabindex="17">削除</BUTTON>
	<% End If %>
	</p>

	<INPUT TYPE="HIDDEN" NAME="PASSWORD" VALUE="">
	<input type="HIDDEN" NAME="fnc" VALUE="<%= fnc %>">
	<INPUT TYPE="HIDDEN" NAME="EADDCHK" VALUE="">
</FORM>
</div>
</body>

<SCRIPT LANGUAGE="JavaScript">
/////////////////////////////////////////////////////////////
//フォームイニシャライズ
/////////////////////////////////////////////////////////////
//document.forms['frmSubmit'].elements('Rq_Cd').focus();

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
//	if ( jf_FormInputChk() != false ){
		if (confirm("削除してもよろしいですか？")){
			document.forms['frmSubmit'].EADDCHK.value="delete";
			document.forms['frmSubmit'].submit();
		}
//	}
}

/////////////////////////////////////////////////////////////
//フォーム項目入力チェック
/////////////////////////////////////////////////////////////
function jf_FormInputChk(){
	
	var ret;

	if (jpf_FormInputChk("Rq_Cd"	,"N",0,1,"担当者コード")==false){return false;}
	if (jpf_FormInputChk("Rq_Name"	,"X",20,1,"担当者名")==false){return false;}
	if (jpf_FormInputChk("Rq_BosyuCd"	,"X",30,1,"ログインコード")==false){return false;}
//	if (jpf_FormInputChk("PASSWORD"	,"X",30,1,"PASSWORD")==false){return false;}

}

/////////////////////////////////////////////////////////////
//ファンクション定義
/////////////////////////////////////////////////////////////
//共通ファンクションインクルード
<!--#include File ="../include/Jsfunc.inc"-->

function disp(url){window.open(url, "", "width=330,height=550,scrollbars=yes,resizable=yes,status=yes");}

</SCRIPT>
</HTML>
<%
'***********************************************************
'フォーム入力チェック
'***********************************************************
Function fnc_FormInputChk()

	Dim ret
	Dim errMsg
	
'	ret = false
	fnc_FormInputChk = False
	
	errMsg = ""

	If func="add" Then
		If fncDbDataGet("M80担当者","担当CD","担当名",Request("Rq_Cd"),"N",1)<>"" Then
			errMsg = "担当コードが重複しています。<BR>"
		End If
	End If

	If errMsg<>"" Then 
		errMsg = errMsg + fnc_InputSave()
		Call fncMessage( errMsg,"eh"&Session("GID")&"_up.asp?func="+func,"main")
	End If
	fnc_FormInputChk = true
End Function 

'***********************************************************
'ＤＢ読込処理（M80担当者）
'***********************************************************
Function fnc_DataGet(inKey)

	Dim ret
	
	ret = false

	strSql		= "SELECT " _
						+ "* " _
					+ "FROM M80担当者 " _
					+ "WHERE ID="+inKey+" "
	call DB_Open
	Set rsSql = Server.CreateObject("ADODB.Recordset")
	On Error Resume Next
	rsSql.Open strSql, connectDB, adOpenStatic, adLockReadOnly
	If Err.Number<>0 Then
		Call DSP_ERR_PAGE(Session("GID")&"<br>"&strSql, "予約データベースに接続できませんでした。", 0)
	End If
	If Not rsSql.EOF Then
		Rq_Cd		=rsSql("担当CD")
		Rq_Name		=Trim(rsSql("担当名"))
		Rq_BosyuCd	=rsSql("ログインCD")
		PASSWORD	=rsSql("PASSWORD")
		Rq_KengenCd =rsSql("権限CD")
		Rq_Bikou	=rsSql("担当備考")
		EID			=rsSql("ID")
	End If

	call DB_Close
	
	fnc_DataGet = ret
End Function

'***********************************************************
'担当ＤＢ登録処理（M80担当者）
'***********************************************************
Function fnc_DataAdd()	
	Dim ret
	
	ret = true

	strSql = "INSERT INTO M80担当者(" _
				+ "担当CD," _
				+ "担当名," _
				+ "ログインCD," _
				+ "PASSWORD," _
				+ "権限CD," _ 
				+ "担当備考," _
				+ "登録日," _
				+ "登録者ID," _
				+ "IPADDR," _
				+ "GID) "
	strSql = strSql + "VALUES("
	strSql = strSql + "'"+Request("Rq_Cd")+"'," _
						+ "'"+Request("Rq_Name")+"'," _
						+ "'"+Request("Rq_BosyuCd")+"'," _
						+ "'"+Request("PASSWORD")+"'," _
						+ "'"+Request("Rq_KengenCd")+"'," _ 
						+ "'"+Request("Rq_Bikou")+"'," _
						+ "'"+FormatDateTime(Now)+"'," _
						+ "'"+CStr(pvntUSER_EigyouId)+"'," _
						+ "'"+Request.ServerVariables("REMOTE_ADDR")+"'," _
						+ "'"+Session("gid")+"'" _
						+ ") "
'Response.Write strSql
'Response.End
	On Error Resume Next
	Set rsSql = Server.CreateObject("ADODB.Recordset")
	rsSql.Open strSql, connectDB, adOpenStatic , adLockOptimistic
	If Err.Number<>0 Then 
		ret = false
'		Exit For
	End If

	fnc_DataAdd = ret
End Function 

'***********************************************************
'担当ＤＢ更新処理（M80担当者）
'***********************************************************
Function fnc_DataUpdate(inKey)

	Dim ret

	ret = false

	If inKey="" Then
		fnc_DataUpdate = ret
		Exit Function
	End If

	strSql = "UPDATE M80担当者 SET " _
					+ "担当CD	='"	+Request("Rq_Cd")+"', " _
					+ "担当名	='"	+Request("Rq_Name")+"', " _
					+ "ログインCD	='" +Request("Rq_BosyuCd")+"', " _
					+ "PASSWORD	='" +Request("PASSWORD")+"', " _
					+ "権限CD	='" +Request("Rq_KengenCd")+"', " _
					+ "担当備考	='"	+Request("Rq_Bikou")+"', " _
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

'Response.End
	fnc_DataUpdate = ret
End Function 

'***********************************************************
'担当ＤＢ削除処理（M80担当者）
'***********************************************************
Function fnc_DataDelete(inKey)

	Dim ret

	ret = false
	
	If inKey="" Then
		fnc_M80DataDelete = ret
		Exit Function
	End If
	
	strSql = "UPDATE M80担当者 SET " _
					+ "削除FLG	=1," _
					+ "更新日	='"	+FormatDateTime(Now)+"'," _
					+ "更新者ID	='"	+CStr(pvntUSER_EigyouId)+"'," _
					+ "IPADDR	='"	+Request.ServerVariables("REMOTE_ADDR")+"'," _
					+ "GID		='"	+Session("gid")+"' "
	strSql = strSql + "WHERE ID	="+CStr(inKey) 

'Response.Write strSql
	On Error Resume Next
	Set rsSql = Server.CreateObject("ADODB.Recordset")
	rsSql.Open strSql, connectDB, adOpenStatic , adLockOptimistic
	If Err.Number=0 Then 
		ret = true
	End If

'Response.End
	fnc_DataDelete = ret
End Function 

%>

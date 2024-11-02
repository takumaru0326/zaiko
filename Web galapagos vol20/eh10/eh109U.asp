<!--#include File ="../include/page_header_up.inc"-->
<%
'***************************************************************************************************
'システム名	  : 在庫管理システム
'プログラム名 : アイテム登録更新画面
'ファイル名	  : eh109U.asp
'copyright	  : takuya honda 
'***************************************************************************************************
'画面制御コードを保持する
Session("gid")="109U"

'ページ制御用　変数
Dim GWIDTH				'ページ width
Dim SYORIFLG			'
Dim fnc

'Form 項目用
'M70ITEM

Dim Rq_ItemCd			'アイテムコード	
Dim Rq_ItemKbn			'アイテム区分	
Dim Rq_ItemBumonCd		'アイテム部門CD
Dim Rq_SyuCd			'主CD	
Dim Rq_ItemNm			'アイテム名	
Dim Rq_ItemZNm			'アイテム名略称
Dim Rq_ItemSuu			'アイテム在庫数	
Dim Rq_ItemMinSuu		'アイテム下限数
Dim Rq_ItemGaku			'アイテム金額
Dim Rq_ItemTanaCd		'アイテム棚番号
Dim Rq_ItemDLYmd		'アイテム使用期限
Dim Rq_ItemBikou		'アイテム備考

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
		Call DSP_ERR_PAGE(Session("GID")&"<br>fnc_DataAdd<br>"&strSql, "データベースの更新に失敗しました。", 0)
	End If
	call DB_Close

	Call fncMessage( "登録完了しました。","eh"&Session("bgid")&".asp","_top")

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
	
	Call fncMessage( "更新完了しました。","eh"&Session("bgid")&".asp","_top")

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
	Call fncMessage( "削除完了しました。","eh"&Session("bgid")&".asp","_top")
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
<A href="<%= Const_url %>">トップページ</A> ＞ <A href="eh<%=Session("bgid")%>.asp">一覧に戻る</A> ＞ 
<%
	Response.Write Rq_GamenNm
	If fnc ="add" Then Response.Write " 登録"
	If fnc ="up" Then Response.Write " 更新"
%>

</div>


<div id="my_contents">

<!-- <div id="mihon"> -->
<FORM NAME="frmSubmit" ACTION="eh<%= Session("gid") %>.asp" METHOD="post" autocomplete="off">
<TABLE width="<%=GWIDTH%>">

	<tr>
	<td>
	<div style="font-size: 30px;color:blue">【コード】
	<INPUT ID="Id_ItemCd" TYPE="tel" NAME="Rq_ItemCd" SIZE="4" MAXLENGTH="6" VALUE="<%= Rq_ItemCd %>" style="font-size: 30px;" tabindex="1">
	<div>
	</td>
	</tr>

	<tr>
	<td>
	<div style="font-size: 30px;color:blue">【名称】
	<INPUT TYPE="TEXT" NAME="Rq_ItemNm" SIZE="18" MAXLENGTH="40" VALUE="<%= Rq_ItemNm %>" style="font-size: 30px;ime-mode:active" tabindex="2">
	<div>
	</td>
	</tr>
	
	<tr>	
	<td>
	<div style="font-size: 30px;color:blue">【区分】
	<%
	Call fncLRCSet("M90共通","主CD","名称",Rq_ItemKbn,"Rq_ItemKbn",1,"種別='アイテム区分' AND 主CD>=0","名称 DESC ","style=""font-size: 30px;""",0,Const_DbAfterOpen,2)
	%>
	<div>
	</td>
	</tr>

	<tr>	
	<td>
	<div style="font-size: 30px;color:blue">【在庫数】
	<INPUT TYPE="TEXT" NAME="Rq_ItemSuu" SIZE="5" MAXLENGTH="4" VALUE="<%= Rq_ItemSuu %>" style="font-size: 30px;ime-mode:inactive" tabindex="5">
	<div>
	</td>
	</tr>

	<tr>	
	<td>
	<div style="font-size: 30px;color:blue">【下限数】
	<INPUT TYPE="TEXT" NAME="Rq_ItemMinSuu" SIZE="5" MAXLENGTH="4" VALUE="<%= Rq_ItemMinSuu %>" style="font-size: 30px;ime-mode:inactive" tabindex="6">
	<div>
	</td>
	</tr>

	<tr>	
	<td>
	<div style="font-size: 30px;color:blue">【単価】
	<INPUT TYPE="TEXT" NAME="Rq_ItemGaku" SIZE="3" MAXLENGTH="6" VALUE="<%= Rq_ItemGaku %>" style="font-size: 30px;ime-mode:inactive" tabindex="7">
	<div>
	</td>
	</tr>
	
	<tr>	
	<td>
	<div style="font-size: 30px;color:blue">【棚番号】
	<INPUT TYPE="tel" NAME="Rq_ItemTanaCd" SIZE="12" MAXLENGTH="20" VALUE="<%= Rq_ItemTanaCd %>" style="font-size: 30px;" tabindex="8">
	<div>
	</td>
	</tr>

	<tr>	
	<td>
	<div style="font-size: 30px;color:blue">【備考】
	<INPUT TYPE="tel" NAME="Rq_ItemBikou" SIZE="18" MAXLENGTH="200" VALUE="<%= Rq_ItemBikou %>" style="font-size: 30px;" tabindex="8">
	<div>
	</td>
	</tr>

	<tr>	
	<td>
	<div style="font-size: 30px;color:blue">【削除区分】
	<%
	Call fncLRCSet("M90共通","主CD","名称",Rq_DelFlg,"Rq_DelFlg",1,"種別='削除FLG' AND 主CD>=0","名称 DESC ","style=""font-size: 30px;""",0,Const_DbAfterOpen,2)
	%>
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
	document.forms['frmSubmit'].elements('Id_ItemCd').focus();
//}
/////////////////////////////////////////////////////////////
//更新、キャンセルボタンイベント
/////////////////////////////////////////////////////////////
function add_submit(){
//	if (confirm("日報のみ登録してもよろしいですか？")){
		if ( jf_FormInputChk() != false ){
			document.forms['frmSubmit'].EADDCHK.value="add";
			document.forms['frmSubmit'].submit();
		}
//	}
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

//	if (jpf_FormInputChk("Rq_SyubetuKbn"	,"X",2,1,"アイテム区分区分")==false){return false;}
//	if (jpf_FormInputChk("Rq_bankNm"		,"X",20,1,"銀行名")==false){return false;}
//	if (jpf_FormInputChk("Rq_Birth"		,"D8",0,1,"生年月日")==false){return false;}
//	if (jpf_FormInputChk("Rq_Kingaku"	,"N",0,1,"金額")==false){return false;}
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
'ＤＢ読込処理
'***********************************************************
Function fnc_DataGet(inKey)

	Dim ret
	
	ret = false

	strSql		= "SELECT " _
					+ "* "
	strSql = strSql + " FROM M70ITEM "
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
		Rq_ItemKbn		=rsSql("アイテム区分")	
		Rq_ItemNm			=rsSql("アイテム名")	
		Rq_ItemSuu			=rsSql("アイテム在庫数")	
		Rq_ItemMinSuu		=rsSql("アイテム下限数")
		Rq_ItemGaku			=rsSql("アイテム金額")	
		Rq_ItemTanaCd		=rsSql("アイテム棚番号")
		Rq_ItemBikou		=rsSql("アイテム備考")
		Rq_DelFlg			=rsSql("削除FLG")
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

	strSql = "INSERT INTO M70ITEM("
	strSql = strSql + "アイテムCD,"
	strSql = strSql + "アイテム区分,"
	strSql = strSql + "アイテム名,"
	strSql = strSql + "アイテム在庫数,"
	strSql = strSql + "アイテム下限数,"
	strSql = strSql + "アイテム金額,"
	strSql = strSql + "アイテム棚番号,"
	strSql = strSql + "アイテム備考,"

	strSql = strSql + "登録日,"
	strSql = strSql + "登録者ID,"
	strSql = strSql + "GID "
	strSql = strSql + ") "
	strSql = strSql + "VALUES("

	strSql = strSql + "'"+Request("Rq_ItemCd")+"',"			'アイテムコード	
	strSql = strSql + "'"+Request("Rq_ItemKbn")+"',"		'アイテム区分	
	strSql = strSql + "'"+Request("Rq_ItemNm")+"',"			'アイテム名"	
	strSql = strSql + "'"+Request("Rq_ItemSuu")+"',"		'アイテム在庫数	
	strSql = strSql + "'"+Request("Rq_ItemMinSuu")+"',"		'アイテム下限数	
	strSql = strSql + "'"+Request("Rq_ItemGaku")+"',"		'アイテム金額	
	strSql = strSql + "'"+Request("Rq_ItemTanaCd")+"',"		'アイテム棚番号	
	strSql = strSql + "'"+Request("Rq_ItemBikou")+"',"		'アイテム備考	
	
	strSql = strSql + "'"+FormatDateTime(Now) + "',"
	strSql = strSql + "'"+CStr(pvntUSER_EigyouId)+"',"
	strSql = strSql + "'"+Session("gid")+"' "
	strSql = strSql + ") "

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
	strSql = "UPDATE M70ITEM SET "

	strSql = strSql + "アイテムCD		='"+Request("Rq_ItemCd")+"',"
	strSql = strSql + "アイテム区分		='"+Request("Rq_ItemKbn")+"',"
	strSql = strSql + "アイテム名		='"+Request("Rq_ItemNm")+"',"
	strSql = strSql + "アイテム在庫数	='"+Request("Rq_ItemSuu")+"',"
	strSql = strSql + "アイテム下限数	='"+Request("Rq_ItemMinSuu")+"',"
	strSql = strSql + "アイテム金額		='"+Request("Rq_ItemGaku")+"',"
	strSql = strSql + "アイテム棚番号	='"+Request("Rq_ItemTanaCd")+"',"
	strSql = strSql + "アイテム備考		='"+Request("Rq_ItemBikou")+"',"
	strSql = strSql + "削除FLG			='"+Request("Rq_DelFlg")+"',"

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

	strSql = "UPDATE M70ITEM SET "
	strSql = strSql + "削除FLG=9," _
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
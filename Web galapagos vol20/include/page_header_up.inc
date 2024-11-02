<%@ LANGUAGE="vbscript" %>
<%
'***************************************************************************************************
'システム名	  : 在庫管理システム
'プログラム名   : データ更新画面用インクルードファイル
'ファイル名     : page_header_up.inc
'機能概要       : Webページキャッシュ		無効
'copyright	  : takuya honda 
'***************************************************************************************************
Option Explicit

' ログイン者情報を共通変数にセット
Call pvf_User

'Webページキャッシュ無効
Response.Expires = -1
Response.AddHeader "Pragma","no-cache"
Response.AddHeader "Cache-control","no-store"

%>
<!--#include File ="../include/db_relation.inc"-->
<!--#include File ="../include/common_asp.asp"-->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTM 4.01//EN"
 "http://www.w3.org/TR/html14/strict.dtd">
<HTML>
<HEAD>
<meta http-equiv="Content-Language" content="ja">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<LINK REL=stylesheet HREF="../CSS/com.css" TYPE="text/css">

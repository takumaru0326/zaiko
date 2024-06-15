//***************************************************************************************************
//システム名	  : 在庫管理システム
//プログラム名 　 : Java Script
//ファイル名	  : Jsfunc.inc
//copyright	  : takuya honda 
//***************************************************************************************************

//----------------------------------------------------------------------
//---------------   Java Script Common Functions Start   ---------------
//----------------------------------------------------------------------

//**********		項目数値チェック		**********

  function chkNum(intxt){
      var woktxt;
      var c;
      var i;

      woktxt=""+intxt;
      for (i=0; i<woktxt.length; i++) {
          c = woktxt.substring(i,i+1);

          if (c<"0" || c>"9")
              return false;
      }
      return true;
  }

  //----------------------------------------------------------------------
  // 空白を省いた文字列を返す
  //----------------------------------------------------------------------
  function jsTrim(inbuff){
      var sbuff;
      var rbuff="";
      var c;
      var i;

      sbuff=""+inbuff;
      for (i=0; sbuff.length>i; i++) {
          c = sbuff.substring(i,i+1);

          if (c!=" ")
              rbuff+=""+c;
      }
      return rbuff;
  }

  //----------------------------------------------------------------------
  // 検索対象文字列より検索文字を探す
  //----------------------------------------------------------------------
  function jsSeaStr(inbuff, seastr){
      var sbuff;
      var i;

      sbuff=""+inbuff;
      for (i=0; sbuff.length>i; i++)
        if (sbuff.substring(i,i+1)==seastr)
            return true;

      return false;
  }

  //----------------------------------------------------------------------
  // 日付存在チェック
  //----------------------------------------------------------------------
  function jsChkDate(y, m, d){
      var d_max;

      //数字のチェック
      if (!jsIsNum(y)) return false;

      //月チェック
      if (y<1900 || 2078<y) return false;

      //月チェック
      if (m<1 || 12<m) return false;

      //月の最終日の取得
      if (m==2)
          if (y%4==0 && y%400!=0)
              d_max=29;
          else
              d_max=28;
      else
          if (m==4 || m==6 || m==9 || m==11)
              d_max=30;
          else
              d_max=31;

      //日チェック
      if (d<1 || d_max<d) return false;

      return true;
  }

//----------------------------------------------------------------------
//---------------    Java Script Common Functions End    ---------------
//----------------------------------------------------------------------
//***************************************************************************************************
//ファンクション名 : フォーム入力チェック
//	IN	 1:Form INPUT Id Name	(日付の場合 SXX EXXのXXを除く)
//		 2:文字形	N.数値,X.文字,mail.メールアドレス
//				D8.日付(GGJJMMDD),D6.日付(GGJJMM),D4.日付(GGJJ)
//		 3:必須入力	1.有効　0.無効	
//		 4:文字長	0.無指定(form maxlen に依存)　1～	
//		 5:項目名称	メッセージ用
//
//	OUT	 1:ture    false
//
//	機能概要 特殊文字チェック、必須チェック、日付チェック、日付項目頭0付,メールアドレスチェック
//
//***************************************************************************************************
function jpf_FormInputChk(koumokuId,koumokuType,koumokuLen,koumokuHisuu,koumokuNm){

	var ret = true;

	var inputTxt;
	var inputTxtG;
	var inputTxtWok;
	var koumokuIdwok;
	var vntData;

	switch (koumokuType) {
		case "N":		//数値
			inputTxt=document.forms['frmSubmit'].elements[koumokuId].value;
			//必須入力チェック
			if (inputTxt == "" && koumokuHisuu==1) {
				alert(koumokuNm + "\nを入力して下さい。");
				document.forms['frmSubmit'].elements[koumokuId].focus();
				return false;
			}
			//使用禁止文字チェック
			if (jpf_chkMoji(inputTxt)==false){
				alert(koumokuNm + "\n使用禁止文字  '  +  &   が使用されています 。");
				document.forms['frmSubmit'].elements[koumokuId].focus();
				return false;
			}
			//数値入力チェック
			if (jpf_chkNum(inputTxt)==false) {
				alert(koumokuNm + "\n数値で入力して下さい。");
				document.forms['frmSubmit'].elements[koumokuId].focus();
				return false;
			}
			break;

		case "X":		//文字
			inputTxt=document.forms['frmSubmit'].elements[koumokuId].value;
			//必須入力チェック
			if (inputTxt == "" && koumokuHisuu==1) {
				alert(koumokuNm + "\nを入力して下さい。");
				document.forms['frmSubmit'].elements[koumokuId].focus();
				return false;
			}
			if (inputTxt == ""){break;}
			//文字数チェック
			if (inputTxt.length > koumokuLen && koumokuLen!=0) {
				alert(koumokuNm + "\n文字数が上限を超えました。");
				document.forms['frmSubmit'].elements[koumokuId].focus();
				return false;
			}
			//使用禁止文字チェック
			if (jpf_chkMoji(inputTxt)==false){
				alert(koumokuNm + "\n使用禁止文字  '  +  &   が使用されています 。");
				document.forms['frmSubmit'].elements[koumokuId].focus();
				return false;
			}
			break;

		case "mail":		//メールアドレス
			inputTxt=document.forms['frmSubmit'].elements[koumokuId].value;
			//必須入力チェック
			if (inputTxt == "" && koumokuHisuu==1) {
				alert(koumokuNm + "\nを入力して下さい。");
				document.forms['frmSubmit'].elements[koumokuId].focus();
				return false;
			}
			//使用禁止文字チェック
			if (jpf_chkMoji(inputTxt)==false){
				alert(koumokuNm + "\n使用禁止文字  '  +  &   が使用されています 。");
				document.forms['frmSubmit'].elements[koumokuId].focus();
				return false;
			}
			vntData = inputTxt.match(/^\S+@\S+\.\S+$/);
			if (!vntData) alert("メールアドレスが正しくありません");
			break;

		case "D8":		//日付
			koumokuIdwok = koumokuId+"DD"
			inputTxtWok=document.forms['frmSubmit'].elements[koumokuIdwok].value;
			//前0追加
			if (inputTxtWok.length>0){
				document.forms['frmSubmit'].elements[koumokuIdwok].value=jpt_zero(inputTxtWok,2)
				inputTxtWok=document.forms['frmSubmit'].elements[koumokuIdwok].value;
			}

			//必須入力チェック
			if (inputTxtWok == "") {
				if (koumokuHisuu==1) {
					alert(koumokuNm + "\n　日を入力して下さい。");
					document.forms['frmSubmit'].elements[koumokuIdwok].focus();
					return false;
				} else {
					return true
				}
			}
			//使用禁止文字チェック
			if (jpf_chkMoji(inputTxtWok)==false){
				alert(koumokuNm + "\n使用禁止文字  '  +  &   が使用されています 。");
				document.forms['frmSubmit'].elements[koumokuIdwok].focus();
				return false;
			}
			//数値入力チェック
			if (jpf_chkNum(inputTxtWok)==false) {
				alert(koumokuNm + "\n数値で入力して下さい。");
				document.forms['frmSubmit'].elements[koumokuIdwok].focus();
				return false;
			}
			//数値チェック
			if (inputTxtWok>31) {
				alert(koumokuNm + "\n日が不正です。");
				document.forms['frmSubmit'].elements[koumokuIdwok].focus();
				return false;
			}
			inputTxt = inputTxtWok

		case "D6":		//文字
			koumokuIdwok = koumokuId+"MM"
			inputTxtWok=document.forms['frmSubmit'].elements[koumokuIdwok].value;

			//前0追加
			if (inputTxtWok.length>0){
				document.forms['frmSubmit'].elements[koumokuIdwok].value=jpt_zero(inputTxtWok,2)
				inputTxtWok=document.forms['frmSubmit'].elements[koumokuIdwok].value;
			}
			//必須入力チェック
			if (inputTxtWok == "") {
				if (koumokuHisuu==1) {
					alert(koumokuNm + "\n　月を入力して下さい。");
					document.forms['frmSubmit'].elements[koumokuIdwok].focus();
					return false;
				} else {
					return true
				}
			}

			//使用禁止文字チェック
			if (jpf_chkMoji(inputTxtWok)==false){
				alert(koumokuNm + "\n使用禁止文字  '  +  &   が使用されています 。");
				document.forms['frmSubmit'].elements[koumokuIdwok].focus();
				return false;
			}
			//数値入力チェック
			if (jpf_chkNum(inputTxtWok)==false) {
				alert(koumokuNm + "\n数値で入力して下さい。");
				document.forms['frmSubmit'].elements[koumokuIdwok].focus();
				return false;
			}
			//数値チェック
			if (inputTxtWok>12) {
				alert(koumokuNm + "\n月が不正です。");
				document.forms['frmSubmit'].elements[koumokuIdwok].focus();
				return false;
			}
			inputTxt = inputTxtWok+inputTxt

		case "D4":		//文字
			koumokuIdwok = koumokuId+"GG"
			inputTxtG=document.forms['frmSubmit'].elements[koumokuIdwok].value;

			koumokuIdwok = koumokuId+"JJ"
			inputTxtWok=document.forms['frmSubmit'].elements[koumokuIdwok].value;
			//前0追加
			if (inputTxtWok.length>0){
				document.forms['frmSubmit'].elements[koumokuIdwok].value=jpt_zero(inputTxtWok,2)
				inputTxtWok=document.forms['frmSubmit'].elements[koumokuIdwok].value;
			}
			//必須入力チェック
			if (inputTxtWok == "") {
				if (koumokuHisuu==1) {
					alert(koumokuNm + "\n　月を入力して下さい。");
					document.forms['frmSubmit'].elements[koumokuIdwok].focus();
					return false;
				} else {
					return true
				}
			}
			//使用禁止文字チェック
			if (jpf_chkMoji(inputTxtWok)==false){
				alert(koumokuNm + "\n使用禁止文字  '  +  &   が使用されています 。");
				document.forms['frmSubmit'].elements[koumokuIdwok].focus();
				return false;
			}
			//数値入力チェック
			if (jpf_chkNum(inputTxtWok)==false) {
				alert(koumokuNm + "\n数値で入力して下さい。");
				document.forms['frmSubmit'].elements[koumokuIdwok].focus();
				return false;
			}
			//数値チェック
			if (inputTxtWok>65) {
				alert(koumokuNm + "\n年が不正です。");
				document.forms['frmSubmit'].elements[koumokuIdwok].focus();
				return false;
			}
			inputTxt = inputTxtG+inputTxtWok+inputTxt

			break;

		case "HHMM":		//文字
			koumokuIdwok = koumokuId+"HH"
			inputTxtWok=document.forms['frmSubmit'].elements[koumokuIdwok].value;
			//前0追加
			if (inputTxtWok.length>0){
				document.forms['frmSubmit'].elements[koumokuIdwok].value=jpt_zero(inputTxtWok,2)
				inputTxtWok=document.forms['frmSubmit'].elements[koumokuIdwok].value;
			}
			//必須入力チェック
			if (inputTxtWok == "") {
				if (koumokuHisuu==1) {
					alert(koumokuNm + "\n　時間を入力して下さい。");
					document.forms['frmSubmit'].elements[koumokuIdwok].focus();
					return false;
				} else {
					return true
				}
			}

			//使用禁止文字チェック
			if (jpf_chkMoji(inputTxtWok)==false){
				alert(koumokuNm + "\n使用禁止文字  '  +  &   が使用されています 。");
				document.forms['frmSubmit'].elements[koumokuIdwok].focus();
				return false;
			}
			//数値入力チェック
			if (jpf_chkNum(inputTxtWok)==false) {
				alert(koumokuNm + "\n数値で入力して下さい。");
				document.forms['frmSubmit'].elements[koumokuIdwok].focus();
				return false;
			}
			//数値チェック
			if (inputTxtWok>24) {
				alert(koumokuNm + "\n不正な時間です。");
				document.forms['frmSubmit'].elements[koumokuIdwok].focus();
				return false;
			}
			inputTxt = inputTxtWok+inputTxt


			koumokuIdwok = koumokuId+"FF"
			inputTxtWok=document.forms['frmSubmit'].elements[koumokuIdwok].value;
			//前0追加
			if (inputTxtWok.length>0){
				document.forms['frmSubmit'].elements[koumokuIdwok].value=jpt_zero(inputTxtWok,2)
				inputTxtWok=document.forms['frmSubmit'].elements[koumokuIdwok].value;
			}
			//必須入力チェック
			if (inputTxtWok == "") {
				if (koumokuHisuu==1) {
					alert(koumokuNm + "\n　分を入力して下さい。");
					document.forms['frmSubmit'].elements[koumokuIdwok].focus();
					return false;
				} else {
					return true
				}
			}

			//使用禁止文字チェック
			if (jpf_chkMoji(inputTxtWok)==false){
				alert(koumokuNm + "\n使用禁止文字  '  +  &   が使用されています 。");
				document.forms['frmSubmit'].elements[koumokuIdwok].focus();
				return false;
			}
			//数値入力チェック
			if (jpf_chkNum(inputTxtWok)==false) {
				alert(koumokuNm + "\n数値で入力して下さい。");
				document.forms['frmSubmit'].elements[koumokuIdwok].focus();
				return false;
			}
			//数値チェック
			if (inputTxtWok>59) {
				alert(koumokuNm + "\n不正な時間です。");
				document.forms['frmSubmit'].elements[koumokuIdwok].focus();
				return false;
			}
			inputTxt = inputTxtWok+inputTxt
	}

	switch (koumokuType) {
		case "D8":		//日付
			//和暦日付を西暦に変換
			vntData = jpf_ReqYmd(inputTxt)
			//日付の存在チェック
			if (jpf_ChkDate(vntData)==false){
				alert(koumokuNm + "\n日付が不正です。");
				koumokuIdwok = koumokuId+"JJ"
				document.forms['frmSubmit'].elements[koumokuIdwok].focus();
				return false;
			}
			break;
		case "D6":		//文字
			//和暦日付を西暦に変換
			vntData = inputTxt.substring(0,5)+"01"			
			vntData = jpf_ReqYmd(vntData)
			//日付の存在チェック
			if (jpf_ChkDate(vntData)==false){
				alert(koumokuNm + "\n年月が不正です。");
				koumokuIdwok = koumokuId+"JJ"
				document.forms['frmSubmit'].elements[koumokuIdwok].focus();
				return false;
			}
			break;
		case "D4":		//文字
			break;
	}
	return true;
}

//***************************************************************************************************
//ファンクション名 : フォーム日付項目値を西暦文字列で取得
//	IN	 1:Form INPUT Id Name	(日付の場合 SXX EXXのXXを除く)
//	OUT	 1:YYYYMMDD
//
//	機能概要 日付けフォーム入力チェックに使用する
//	注意事項 先にjpf_FormInputChkで日付けのチェックを行って下さい。
//***************************************************************************************************
function jpf_FormInputDateCnv(koumokuId){

	var ret;

	var inputTxt;
	var inputTxtG;
	var inputTxtWok;
	var koumokuIdwok;
	var vntData;

	inputTxt = "";
	koumokuIdwok = koumokuId+"DD";
	inputTxtWok=document.forms['frmSubmit'].elements[koumokuIdwok].value;
	inputTxt = inputTxtWok+inputTxt;

	koumokuIdwok = koumokuId+"MM";
	inputTxtWok=document.forms['frmSubmit'].elements[koumokuIdwok].value;
	inputTxt = inputTxtWok+inputTxt;

	koumokuIdwok = koumokuId+"GG";
	inputTxtG=document.forms['frmSubmit'].elements[koumokuIdwok].value;

	koumokuIdwok = koumokuId+"JJ";
	inputTxtWok=document.forms['frmSubmit'].elements[koumokuIdwok].value;
	inputTxt = inputTxtG+inputTxtWok+inputTxt;
	//和暦日付を西暦に変換
	ret = jpf_ReqYmd(inputTxt);	

	return ret;	
}

//***************************************************************************************************
//ファンクション名 : フォーム時間項目値を文字列で取得
//	IN	 1:Form INPUT Id Name	(日付の場合 SXX EXXのXXを除く)
//	OUT	 1:HHMM
//
//	機能概要 時間フォーム入力チェックに使用する
//	注意事項 先にjpf_FormInputChkで時間のチェックを行って下さい。
//***************************************************************************************************
function jpf_FormInputTimeCnv(koumokuId){

	var ret;

	var outputTxt;
	var inputTxtWok;
	var koumokuIdwok;

	outputTxt = "";
	koumokuIdwok = koumokuId+"HH";
	inputTxtWok=document.forms['frmSubmit'].elements[koumokuIdwok].value;
	outputTxt = inputTxtWok;

	koumokuIdwok = koumokuId+"FF";
	inputTxtWok=document.forms['frmSubmit'].elements[koumokuIdwok].value;
	outputTxt = outputTxt+inputTxtWok;
	ret = outputTxt;
	return ret;	
}

//***************************************************************************************************
//ファンクション名 : 項目数値チェック
//
//***************************************************************************************************
function jpf_chkNum(intxt){
	var woktxt;
	var c;
	var i;

	woktxt=""+intxt;
	for (i=0; i<woktxt.length; i++) {
		c = woktxt.substring(i,i+1);

		if ((c<"0" || c>"9") && c!="." && c!="-")
			return false;
		}
//20060321 sam add
	if (isNaN(intxt)) {return false;}

	return true;
}

//***************************************************************************************************
//ファンクション名 : 禁止文字チェック
//
//***************************************************************************************************
function jpf_chkMoji(intxt,koumokuNm){
	var woktxt;
	var c;
	var i;

	woktxt=""+intxt;
	for (i=0; i<woktxt.length; i++) {
		c = woktxt.substring(i,i+1);

		if (c=="'" || c=="+" || c=="&") {
			return false;
		}
	}
	return true;
}

//***************************************************************************************************
//ファンクション名 : 和暦->西暦変換
//	IN	 1:変換文字列　NJJMMDD (N　元号コード)
//	OUT	 1:YYYYMMDD
//***************************************************************************************************
function jpf_ReqYmd(inTxt){

	var ret;
	var work;

	if (inTxt.length>4 ) { 
		if (inTxt.substr(0,1)=="5") {
			work=2018+eval(inTxt.substr(1,2));
		}
		if (inTxt.substr(0,1)=="4") {
			work=1988+eval(inTxt.substr(1,2));
		}
		if (inTxt.substr(0,1)=="3") {
			work=1925+eval(inTxt.substr(1,2));
		}
		if (inTxt.substr(0,1)=="2") {
			work=1911+eval(inTxt.substr(1,2));
		}
		if (inTxt.substr(0,1)=="1") {
			work=1867+eval(inTxt.substr(1,2));
		}
		ret = ""+work+inTxt.substr(3,4);
	}
	return ret;
}

//***************************************************************************************************
//ファンクション名 : 指定日付範囲の日数を求める
//
//	IN	 1:文字列　YYYYMMDD
//		 2:文字列　YYYYMMDD
//	OUT	 1:数値 日数
//***************************************************************************************************
  function jpf_DateDiff(inDateS,inDateE){
	var days
	var DateS
	var DateE

	DateS = new Date(eval(inDateS.substr(0,4)),eval(inDateS.substr(4,2))-1,eval(inDateS.substr(6,2)));
	DateE = new Date(eval(inDateE.substr(0,4)),eval(inDateE.substr(4,2))-1,eval(inDateE.substr(6,2)));
	days = (DateE.getTime() - DateS.getTime())/(24*60*60*1000);
	days = Math.ceil(days)
	return days
}

//***************************************************************************************************
//ファンクション名 : 指定時間範囲の経過時間を求める
//
//	IN	 1:文字列　HHMM	時間自
//		 2:文字列　HHMM	時間至
//		 3:返却値形式  "MM" 分 , "HH" 時間(分は小数点以下) , "HHMM" 時間分
//	OUT	 1:数値 MM 又は HH
//	注意事項 先にjpf_FormInputChkで時間のチェックを行って下さい。
//***************************************************************************************************

function jpf_TimeDiff(inDateS,inDateE,inType){
	var varData;
	var varDataHH;
	var varDataFF;
	var date1 = new Date();
	var date2 = new Date();

	varData = 0;
	date1.setHours(eval(inDateS.substr(0,2)));
	date1.setMinutes(eval(inDateS.substr(2,2)));
	date1.setSeconds(0);
	date2.setHours(eval(inDateE.substr(0,2)));
	date2.setMinutes(eval(inDateE.substr(2,2)));
	date2.setSeconds(0);
	varData = date2.getTime() - date1.getTime();
	if (varData < 0) { varData += 24 * 60 * 60 * 1000; }
	varData = Math.floor(varData / 1000);
	varData /= 60
	if (inType=="HH"){
		varData *= 60;
	}
	if (inType=="HHMM"){
		varDataHH = Math.floor(varData / 60)
		varDataFF = varData-varDataHH*60
		varData = jpt_zero(varDataHH,2)+jpt_zero(varDataFF,2)
	}
	return varData;
}

//***************************************************************************************************
//ファンクション名 : 日付存在チェック
//
//	IN	 1:文字列　YYYYMMDD
//	OUT	 1:ture    false
//***************************************************************************************************
  function jpf_ChkDate(inTxt){
	var ret = true;
	var years
	var months
	var days

	years = inTxt.substr(0,4);
	months = inTxt.substr(4,2) - 1;
	days = inTxt.substr(6,2);

	var dates = new Date(years,months,days);
	if (dates.getYear() < 1900) {
		if (years != dates.getYear() + 1900) { ret = false; }
	} else {
		if (years != dates.getYear()) { ret = false; }
	}
	if (months != dates.getMonth()) { ret = false; }
	if (days != dates.getDate()) { ret = false; }

	return ret;
  }


//***************************************************************************************************
//ファンクション名 : 指定桁までゼロ追加
//
//***************************************************************************************************

function jpt_zero(num,len){

	var intWork = len - (num+"").length
	var add0 = ""
	if( intWork > 0 ) for ( i=0;i<intWork;i++ ){ add0 += "0" }
	return ( add0 + num )

}



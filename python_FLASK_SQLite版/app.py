import pprint
#import pyodbc   #MSSQL用
import appDataCom
import math 
import commonfnc
import datetime
from flask import Flask, redirect, render_template, url_for, request ,jsonify ,session
#pip install -U flask-paginate 実行
#from flask_paginate import Pagination, get_page_parameter
#from datetime import timedelta
from dateutil.relativedelta import relativedelta        #pip install python-dateutil
app = Flask(__name__)

app.secret_key = '5MJ30Lo6'
app.permanet_session_lifetime = datetime.timedelta(minutes=20)

@app.route("/", methods=["GET","POST"])
def login():
    if request.method == "POST":
        session.premanet = True
        vntBosyuCd = request.form.get("Rq_UserID")

        res = appDataCom.get_M80tanto_bosyuCd(vntBosyuCd )
        if len(res)!=0:
            session["Rq_UserID"] = res[0][0]
            session["Rq_UserCD"] = res[0][1]
            session["Rq_UserNm"] = res[0][2]
            session["Rq_UserLv"] = res[0][3]
            return redirect(url_for("menu")) 
        else:
            vntMessage = "該当者がいません!!"
            return render_template("login.html",vntMessage=vntMessage)
    else:
        if "Rq_UserID" in session:
            return redirect(url_for("menu"))
        return render_template("login.html",vntMessage="")
    
@app.route("/logoff", methods=["GET"])
def logoff():
    session.pop("Rq_UseID",None)
    session.clear()
    return redirect("/")

@app.route("/menu", methods=["GET","POST"])
def menu():
    if "Rq_UserID" in session:
        strSql = " SELECT * FROM MA0画面制御 " \
                 "WHERE SUBSTRING(画面番号,1,2)='10' AND SUBSTRING(画面番号,3,2)<>'00' AND SUBSTRING(画面番号,4,1)='0' AND 削除FLG=0 " \
	             " AND 権限LV<=" + str(session["Rq_UserLv"]) + " " \
                 " ORDER BY 画面番号 " 

        res = appDataCom.executeSelect(strSql)
        vntGname = ""
        return render_template("menu.html",\
                          vntGname=vntGname,res=res)
    return render_template("login.html")
 
@app.route("/eh10/eh1010", methods=["GET", "POST"])
def eh1010_post():
    vntGid = "1010"
    res = appDataCom.get_MA0GAMEN(vntGid )
    vntGname =res[0]
    vntGLV   =res[1] 
    #ここに権限レベルのチェックを入れないと直接URL指定すると利用できてしまう
    if session["Rq_UserLv"]<vntGLV:
        return menu()
    
    if request.method == "POST":
        Rq_ItemCd = request.form["Rq_ItemCd"]
        if Rq_ItemCd != "":
            appDataCom.eh1010DataApp(vntGid)  
            return render_template("eh10/eh"+vntGid+".html",\
                           vntGid = vntGid,vntGname=vntGname)
        else:
            return render_template("eh10/eh"+vntGid+".html",\
                           vntGid = vntGid,vntGname=vntGname)
    else:
        return render_template("eh10/eh"+vntGid+".html",\
                           vntGid = vntGid,vntGname=vntGname)

@app.route("/eh10/eh1020", methods=["GET", "POST"])
def eh1020_post():
    vntGid = "1020"
    res = appDataCom.get_MA0GAMEN(vntGid )
    vntGname =res[0]
    vntGLV   =res[1] 
    #ここに権限レベルのチェックを入れないと直接URL指定すると利用できてしまう
    if session["Rq_UserLv"]<vntGLV:
        return menu()
    
    if request.method == "POST":
        Rq_ItemCd = request.form["Rq_ItemCd"]
        if Rq_ItemCd != "":
            appDataCom.eh1020DataApp(vntGid)  
            return render_template("eh10/eh"+vntGid+".html",\
                           vntGid = vntGid,vntGname=vntGname)
        else:
            return render_template("eh10/eh"+vntGid+".html",\
                           vntGid = vntGid,vntGname=vntGname)
    else:
        return render_template("eh10/eh"+vntGid+".html",\
                           vntGid = vntGid,vntGname=vntGname) 

@app.route("/eh10/eh1030", methods=["GET"])
def eh1030_get():   
    vntGid = "1030"
    #画面名称
    res = appDataCom.get_MA0GAMEN(vntGid )
    vntGname =res[0]
    vntGLV   =res[1] 
    #ここに権限レベルのチェックを入れないと直接URL指定すると利用できてしまう
    if session["Rq_UserLv"]<vntGLV:
        return menu()
    
    #103U 更新画面の権限レベル取得
    res = appDataCom.get_MA0GAMEN("103U" )
    vntGLV   =res[1]   
 
    #M90共通マスタから表示件数取得
    vntSels = appDataCom.get_M90kyoutu("表示件数")  

    if "Rq_UserID" in session:
        vntVcnt = request.args.get("Rq_Vcnt","5")
        vnt_ew = request.args.get("Rq_ew","")

        strSql = " SELECT アイテムCD,アイテム名,アイテム在庫数,アイテム棚番号,ID " \
                    "FROM M70ITEM " 
        strSql += "WHERE 削除FLG=0 " 
        if vnt_ew != "":
            strSql += "AND アイテムCD+アイテム名+アイテム棚番号 Like '%" +  vnt_ew  +"%' " 
        strSql += "ORDER BY ID "  
        res = appDataCom.executeSelect(strSql)

        pageorigin = int(request.args.get("pageorigin","0"))
        #ページネーション
        result,pageend,pagelen = commonfnc.pagen(res,pageorigin,int(vntVcnt))
             
        return render_template("eh10/eh"+vntGid+".html",\
                          vntGname=vntGname,res=result,pageorigin=pageorigin,pageend=pageend,pagelen=pagelen,vnt_ew=vnt_ew,vntGid=vntGid,vntSels=vntSels,vntVcnt=vntVcnt,vntGLV=vntGLV)
    return render_template("login.html") 

@app.route("/eh10/eh103U", methods=["GET"])
def eh103U_get(): 
    vntGid = "103U"
    #画面名称
    res = appDataCom.get_MA0GAMEN(vntGid )
    vntGname =res[0]
    vntGLV   =res[1] 
    #ここに権限レベルのチェックを入れないと直接URL指定すると利用できてしまう
    if session["Rq_UserLv"]<vntGLV:
        return eh1030_get()

    if "Rq_UserID" in session:
        #M90共通マスタからアイテム区分取得
        vntSels = appDataCom.get_M90kyoutu("アイテム区分")

        vnt_fnc = request.args.get("fnc","")
        if vnt_fnc == "add":
            res = ""
            vnt_id = ""
            return render_template("eh10/eh"+vntGid+".html",\
                          vntGname=vntGname+"登録",res=res,vnt_id=vnt_id,vnt_fnc=vnt_fnc,vntGid=vntGid,vntSels = vntSels)
        else:
            vnt_id = request.args.get("id","")

            res = appDataCom.get_M70ITEM_id(vnt_id)
        
            return render_template("eh10/eh"+vntGid+".html",\
                          vntGname=vntGname+"更新",res=res,vnt_id=vnt_id,vnt_fnc=vnt_fnc,vntGid=vntGid,vntSels = vntSels)
    return render_template("login.html")

@app.route("/eh10/eh103U", methods=["POST"])
def eh103U_post(): 
    vntGid = "103U"
    #画面名称
    res = appDataCom.get_MA0GAMEN(vntGid )
    vntGname =res[0]
    vntGLV   =res[1] 
    #ここに権限レベルのチェックを入れないと直接URL指定すると利用できてしまう
    if session["Rq_UserLv"]<vntGLV:
        return menu()
    
    if "Rq_UserID" in session:
        appDataCom.eh109UDataApp(vntGid) 
        return redirect(url_for("eh1030_get"))

    return render_template("login.html")

@app.route("/eh10/eh1050", methods=["GET"])
def eh1050_get():
    vntGid = "1050"
    res = appDataCom.get_MA0GAMEN(vntGid )
    vntGname =res[0]
    vntGLV   =res[1] 
    #ここに権限レベルのチェックを入れないと直接URL指定すると利用できてしまう
    if session["Rq_UserLv"]<vntGLV:
        return menu()
    
    #105U 更新画面の権限レベル取得
    res = appDataCom.get_MA0GAMEN("105U" )
    vntGLV   =res[1]   

    if "Rq_UserID" in session:
        #strSql = " SELECT T10.アイテムCD,M70.アイテム名,T10.アイテム出庫数,M70.アイテム在庫数,M70.アイテム棚番号,SUBSTRING(T10.アイテム出庫YMD,5,2)+'/'+SUBSTRING(T10.アイテム出庫YMD,7,2),T10.ID " \
        #        "FROM T10SHIP AS T10 " \
        #        "INNER JOIN M70ITEM AS M70 ON M70.アイテムCD=T10.アイテムCD " \
        #        "WHERE T10.削除FLG=0 AND LEN(M70.アイテム棚番号)>0 " \
	    #        " ORDER BY T10.ID DESC" 
        strSql = " SELECT ID,アイテムCD,アイテム名,アイテム出庫数,アイテム在庫数,アイテム棚番号,アイテム出庫YMD,担当名 " \
                "FROM v10SHIP " \
                "WHERE 削除FLG=0 AND LENGTH(アイテム棚番号)>0 " \
	            " ORDER BY ID DESC" 

        res = appDataCom.executeSelect(strSql)

        pageorigin = int(request.args.get("pageorigin","0"))
        #ページネーション
        result,pageend,pagelen = commonfnc.pagen(res,pageorigin,5)
            
        return render_template("eh10/eh"+vntGid+".html",\
                          vntGname=vntGname,res=result,pageorigin=pageorigin,pageend=pageend,pagelen=pagelen,vntGid=vntGid,vntGLV=vntGLV)
    return render_template("login.html")

@app.route("/eh10/eh105U", methods=["GET"])
def eh105U_get(): 
    vntGid = "105U"
    #画面名称
    res = appDataCom.get_MA0GAMEN(vntGid )
    vntGname =res[0]
    vntGLV   =res[1] 
    #ここに権限レベルのチェックを入れないと直接URL指定すると利用できてしまう
    if session["Rq_UserLv"]<vntGLV:
        return menu()
    
    if "Rq_UserID" in session:
        #M90共通マスタからアイテム区分取得
        #vntSels = appDataCom.get_V10M90kyoutu("アイテム区分")

        vnt_fnc = request.args.get("fnc","")
    #    if vnt_fnc == "add":
    #        res = ""
    #        vnt_id = ""
    #        return render_template("eh10/eh"+vntGid+".html",\
    #                      vntGname=vntGname+"登録",res=res,vnt_id=vnt_id,vnt_fnc=vnt_fnc,vntGid=vntGid,vntSels = vntSels)
    #    else:
        vnt_id = request.args.get("id","")

        res = appDataCom.get_V10SHIP_id(vnt_id)
        
        return render_template("eh10/eh"+vntGid+".html",\
                      vntGname=vntGname+"更新",res=res,vnt_id=vnt_id,vnt_fnc=vnt_fnc,vntGid=vntGid)
    return render_template("login.html")

@app.route("/eh10/eh105U", methods=["POST"])
def eh105U_post(): 
    vntGid = "105U"
    #画面名称
    res = appDataCom.get_MA0GAMEN(vntGid )
    vntGname =res[0]
    vntGLV   =res[1] 
    #ここに権限レベルのチェックを入れないと直接URL指定すると利用できてしまう
    if session["Rq_UserLv"]<vntGLV:
        return menu()
    
    if "Rq_UserID" in session:
        appDataCom.eh105UDataApp(vntGid) 
        return redirect(url_for("eh1050_get"))

    return render_template("login.html")
 
@app.route("/eh10/eh1060", methods=["GET"])
def eh1060_get():
    vntGid = "1060"
    res = appDataCom.get_MA0GAMEN(vntGid )
    vntGname =res[0]
    vntGLV   =res[1] 
    #ここに権限レベルのチェックを入れないと直接URL指定すると利用できてしまう
    if session["Rq_UserLv"]<vntGLV:
        return menu()
    
    if "Rq_UserID" in session:
        #strSql = " SELECT T20.アイテムCD,M70.アイテム名,T20.アイテム入荷数,M70.アイテム在庫数,M70.アイテム棚番号,FORMAT(T20.登録日, 'MM/dd') " \
        #        "FROM T20INSUU AS T20 " \
        #        "INNER JOIN M70ITEM AS M70 ON M70.アイテムCD=T20.アイテムCD " \
        #        "WHERE T20.削除FLG=0 " \
	    #        " ORDER BY T20.ID DESC" 
        strSql = " SELECT ID,アイテムCD,アイテム名,アイテム入荷数,アイテム在庫数,アイテム棚番号,アイテム入荷YMD,担当名 " \
                "FROM V20INSUU " \
                "WHERE 削除FLG=0 " \
	            " ORDER BY ID DESC" 

        res = appDataCom.executeSelect(strSql)

        pageorigin = int(request.args.get("pageorigin","0"))
        #ページネーション
        result,pageend,pagelen = commonfnc.pagen(res,pageorigin,5)
            
        return render_template("eh10/eh"+vntGid+".html",\
                          vntGname=vntGname,res=result,pageorigin=pageorigin,pageend=pageend,pagelen=pagelen,vntGid=vntGid,vntGLV=vntGLV)
    return render_template("login.html")

@app.route("/eh10/eh106U", methods=["GET"])
def eh106U_get(): 
    vntGid = "106U"
    #画面名称
    res = appDataCom.get_MA0GAMEN(vntGid )
    vntGname =res[0]
    vntGLV   =res[1] 
    #ここに権限レベルのチェックを入れないと直接URL指定すると利用できてしまう
    if session["Rq_UserLv"]<vntGLV:
        return menu()
    
    if "Rq_UserID" in session:
        #M90共通マスタからアイテム区分取得
        #vntSels = appDataCom.get_V10M90kyoutu("アイテム区分")

        vnt_fnc = request.args.get("fnc","")
    #    if vnt_fnc == "add":
    #        res = ""
    #        vnt_id = ""
    #        return render_template("eh10/eh"+vntGid+".html",\
    #                      vntGname=vntGname+"登録",res=res,vnt_id=vnt_id,vnt_fnc=vnt_fnc,vntGid=vntGid,vntSels = vntSels)
    #    else:
        vnt_id = request.args.get("id","")

        res = appDataCom.get_V20INSUU_id(vnt_id)
        
        return render_template("eh10/eh"+vntGid+".html",\
                      vntGname=vntGname+"更新",res=res,vnt_id=vnt_id,vnt_fnc=vnt_fnc,vntGid=vntGid)
    return render_template("login.html")

@app.route("/eh10/eh106U", methods=["POST"])
def eh106U_post(): 
    vntGid = "106U"
    #画面名称
    res = appDataCom.get_MA0GAMEN(vntGid )
    vntGname =res[0]
    vntGLV   =res[1] 
    #ここに権限レベルのチェックを入れないと直接URL指定すると利用できてしまう
    if session["Rq_UserLv"]<vntGLV:
        return menu()
    
    if "Rq_UserID" in session:
        appDataCom.eh106UDataApp(vntGid) 
        return redirect(url_for("eh1060_get"))

    return render_template("login.html")
 

@app.route("/eh10/eh1090", methods=["GET"])
def eh1090_get():   
    vntGid = "1090"
    #画面名称
    res = appDataCom.get_MA0GAMEN(vntGid )
    vntGname =res[0]
    vntGLV   =res[1] 
    #ここに権限レベルのチェックを入れないと直接URL指定すると利用できてしまう
    if session["Rq_UserLv"]<vntGLV:
        return menu()
    
    #M90共通マスタから表示件数取得
    vntSels = appDataCom.get_M90kyoutu("表示件数")
 
    #109U 更新画面の権限レベル取得
    res = appDataCom.get_MA0GAMEN("109U" )
    vntGLV   =res[1]   
 
    if "Rq_UserID" in session:
        vntVcnt = request.args.get("Rq_Vcnt","5")
        vnt_ew = request.args.get("Rq_ew","")
        
        strSql = " SELECT アイテムCD,アイテム名,アイテム在庫数,アイテム棚番号,ID " \
                    "FROM M70ITEM " 
        strSql += "WHERE 削除FLG=0 " 
        if vnt_ew != "":
            strSql += "AND アイテム名 Like '%" +  vnt_ew  +"%' " 
        strSql += "ORDER BY ID "  
        res = appDataCom.executeSelect(strSql)

        pageorigin = int(request.args.get("pageorigin","0"))
        #ページネーション
        result,pageend,pagelen = commonfnc.pagen(res,pageorigin,int(vntVcnt))
             
        return render_template("eh10/eh"+vntGid+".html",\
                          vntGname=vntGname,res=result,pageorigin=pageorigin,pageend=pageend,pagelen=pagelen,vnt_ew=vnt_ew,vntGid=vntGid,vntSels = vntSels,vntVcnt=vntVcnt,vntGLV=vntGLV)
    return render_template("login.html")

@app.route("/eh10/eh109U", methods=["GET"])
def eh109U_get(): 
    vntGid = "109U"
    #画面名称
    res = appDataCom.get_MA0GAMEN(vntGid )
    vntGname =res[0]
    vntGLV   =res[1] 
    #ここに権限レベルのチェックを入れないと直接URL指定すると利用できてしまう
    if session["Rq_UserLv"]<vntGLV:
        return menu()
    
    if "Rq_UserID" in session:
        #M90共通マスタからアイテム区分取得
        vntSels = appDataCom.get_M90kyoutu("アイテム区分")

        vnt_fnc = request.args.get("fnc","")
        if vnt_fnc == "add":
            res = ""
            vnt_id = ""
            return render_template("eh10/eh"+vntGid+".html",\
                          vntGname=vntGname+"登録",res=res,vnt_id=vnt_id,vnt_fnc=vnt_fnc,vntGid=vntGid,vntSels = vntSels)
        else:
            vnt_id = request.args.get("id","")

            res = appDataCom.get_M70ITEM_id(vnt_id)
        
            return render_template("eh10/eh"+vntGid+".html",\
                          vntGname=vntGname+"更新",res=res,vnt_id=vnt_id,vnt_fnc=vnt_fnc,vntGid=vntGid,vntSels = vntSels)
    return render_template("login.html")

@app.route("/eh10/eh109U", methods=["POST"])
def eh109U_post(): 
    vntGid = "109U"
    #画面名称
    res = appDataCom.get_MA0GAMEN(vntGid )
    vntGname =res[0]
    vntGLV   =res[1] 
    #ここに権限レベルのチェックを入れないと直接URL指定すると利用できてしまう
    if session["Rq_UserLv"]<vntGLV:
        return menu()
    
    if "Rq_UserID" in session:
        appDataCom.eh109UDataApp(vntGid) 
        return redirect(url_for("eh1090_get"))

    return render_template("login.html")

@app.route("/eh10/eh10A0", methods=["GET"])
def eh10A0_get():
    vntGid = "10A0"
    res = appDataCom.get_MA0GAMEN(vntGid )
    vntGname =res[0]
    vntGLV   =res[1] 
    #ここに権限レベルのチェックを入れないと直接URL指定すると利用できてしまう
    if session["Rq_UserLv"]<vntGLV:
        return menu()
    
    if "Rq_UserID" in session:
        #strSql = " SELECT アイテムCD,アイテム名,アイテム在庫数,アイテム下限数,アイテム下限数,アイテム棚番号 " \
        #            "FROM M70ITEM " 
        #strSql += "WHERE 削除FLG=0 " \
        #            "And LEN(アイテム棚番号)>0 And アイテム下限数>=アイテム在庫数 "
        #strSql += "ORDER BY ID " 
        strSql = " SELECT アイテムCD,アイテム名,アイテム在庫数,アイテム下限数,アイテム下限数,アイテム棚番号 " \
                    "FROM M70ITEM " 
        strSql += "WHERE 削除FLG=0 " \
                    "And LENGTH(アイテム棚番号)>0 And アイテム下限数>=アイテム在庫数 "
        strSql += "ORDER BY ID " 
      
        res = appDataCom.executeSelect(strSql)

        pageorigin = int(request.args.get("pageorigin","0"))
        #ページネーション
        result,pageend,pagelen = commonfnc.pagen(res,pageorigin,5)
            
        return render_template("eh10/eh"+vntGid+".html",\
                          vntGname=vntGname,res=result,pageorigin=pageorigin,pageend=pageend,pagelen=pagelen,vntGid=vntGid)
    return render_template("login.html")

@app.route("/eh10/eh10B0", methods=["GET"])
def eh10B0_get():
    vntGid = "10B0"
    res = appDataCom.get_MA0GAMEN(vntGid )
    vntGname =res[0]
    vntGLV   =res[1] 
    #ここに権限レベルのチェックを入れないと直接URL指定すると利用できてしまう
    if session["Rq_UserLv"]<vntGLV:
        return menu()
    
    if "Rq_UserID" in session:
        vnt_ItemCd  = request.args.get("Rq_ItemCd","")
        vnt_TukiSuu = request.args.get("Rq_TukiSuu","6")
        today_data = datetime.date.today() + relativedelta(months=-int(vnt_TukiSuu))
        vntData = str(today_data.year) + str(today_data.month).zfill(2)+str(today_data.day).zfill(2)
        strSql = " SELECT T.アイテムCD,T.アイテム名,T.アイテム出庫数,T.アイテム棚番号,M70.アイテム在庫数,M70.ID " \
                    " FROM (SELECT V10.アイテムCD,V10.アイテム名,V10.アイテム棚番号,SUM(V10.アイテム出庫数) AS アイテム出庫数 " \
                    "FROM V10SHIP AS V10 WHERE V10.削除FLG=0 "
        strSql +=   "AND V10.アイテム出庫YMD > '" + vntData + "' "
        if vnt_ItemCd!="":
            strSql +="AND V10.アイテムCD='" + vnt_ItemCd +"' "  
        strSql += "GROUP BY V10.アイテムCD,V10.アイテム名,V10.アイテム棚番号 "
        strSql += ") AS T LEFT OUTER JOIN M70ITEM AS M70 ON M70.アイテムCD=T.アイテムCD AND M70.削除FLG=0 "
        strSql += "ORDER BY T.アイテム出庫数 DESC "

        res = appDataCom.executeSelect(strSql)

        pageorigin = int(request.args.get("pageorigin","0"))
        #ページネーション
        result,pageend,pagelen = commonfnc.pagen(res,pageorigin,5)
            
        return render_template("eh10/eh"+vntGid+".html",\
                          vntGname=vntGname,res=result,pageorigin=pageorigin,pageend=pageend,pagelen=pagelen,vnt_ItemCd=vnt_ItemCd,vnt_TukiSuu=vnt_TukiSuu,vntGid=vntGid)
    return render_template("login.html")

@app.route("/eh10/eh10W0", methods=["GET"])
def eh10W0_get():   
    vntGid = "10W0"
    #画面名称
    res = appDataCom.get_MA0GAMEN(vntGid )
    vntGname =res[0]
    vntGLV   =res[1] 
    #ここに権限レベルのチェックを入れないと直接URL指定すると利用できてしまう
    if session["Rq_UserLv"]<vntGLV:
        return menu()
    
    if "Rq_UserID" in session:
        vnt_ew = request.args.get("Rq_ew","")
        strSql = " SELECT ID,担当CD,担当名,ログインCD " \
                    "FROM M80担当者 " 
        strSql += "WHERE 削除FLG=0 " 
        if vnt_ew != "":
            strSql += "AND 担当名 Like '%" +  vnt_ew  +"%' " 
        strSql += "ORDER BY 担当CD "  
        res = appDataCom.executeSelect(strSql)

        pageorigin = int(request.args.get("pageorigin","0"))
        #ページネーション
        result,pageend,pagelen = commonfnc.pagen(res,pageorigin,5)
             
        return render_template("eh10/eh"+vntGid+".html",\
                          vntGname=vntGname,res=result,pageorigin=pageorigin,pageend=pageend,pagelen=pagelen,vnt_ew=vnt_ew,vntGid=vntGid)
    return render_template("login.html")

@app.route("/eh10/eh10WU", methods=["GET"])
def eh10WU_get(): 
    vntGid = "10WU"
    #画面名称
    res = appDataCom.get_MA0GAMEN(vntGid )
    vntGname =res[0]
    vntGLV   =res[1] 
    #ここに権限レベルのチェックを入れないと直接URL指定すると利用できてしまう
    if session["Rq_UserLv"]<vntGLV:
        return menu()

    if "Rq_UserID" in session:
        #M90共通マスタから権限レベル取得
        vntSels = appDataCom.get_M90kyoutu("権限レベル")
        vnt_fnc = request.args.get("fnc","")
        if vnt_fnc == "add":
            res = ""
            vnt_id = ""
            return render_template("eh10/eh"+vntGid+".html",\
                          vntGname=vntGname+"登録",res=res,vnt_id=vnt_id,vnt_fnc=vnt_fnc,vntGid=vntGid,vntSels = vntSels)
        else:
            vnt_id = request.args.get("id","")

            res = appDataCom.get_M80tanto_id(vnt_id)
        
            return render_template("eh10/eh"+vntGid+".html",\
                          vntGname=vntGname+"更新",res=res,vnt_id=vnt_id,vnt_fnc=vnt_fnc,vntGid=vntGid,vntSels = vntSels)
    return render_template("login.html")

@app.route("/eh10/eh10WU", methods=["POST"])
def eh10WU_post(): 
    vntGid = "10WU"
    #画面名称
    res = appDataCom.get_MA0GAMEN(vntGid )
    vntGname =res[0]
    vntGLV   =res[1] 
    #ここに権限レベルのチェックを入れないと直接URL指定すると利用できてしまう
    if session["Rq_UserLv"]<vntGLV:
        return menu()
    
    if "Rq_UserID" in session:
        vnt_fnc = request.form['Rq_fnc']
        #if vnt_fnc=="add":
        #    vntTantoCd = request.form.get("Rq_TantoCd")

        #    res = appDataCom.get_M80tanto_TantoCd(vntTantoCd )
        #    if len(res)!=0:
        #        vntMessage = "このコードは既に登録されています!!"
        #        res = ""
        #        vnt_id = ""
        #        return render_template("eh10/eh"+vntGid+".html",\
        #                  vntGname=vntGname+"登録"+vntMessage,res=res,vnt_id=vnt_id,vnt_fnc=vnt_fnc,vntGid=vntGid)
        appDataCom.eh10WUDataApp(vntGid)             
        return redirect(url_for("eh10W0_get"))
    return render_template("login.html")

@app.route("/eh10/eh10Y0", methods=["GET"])
def eh10Y0_get():   
    vntGid = "10Y0"
    #画面名称
    res = appDataCom.get_MA0GAMEN(vntGid )
    vntGname =res[0]
    vntGLV   =res[1] 
    #ここに権限レベルのチェックを入れないと直接URL指定すると利用できてしまう
    if session["Rq_UserLv"]<vntGLV:
        return menu()
    
    if "Rq_UserID" in session:
        vnt_ew = request.args.get("Rq_ew","")
        strSql = " SELECT ID,種別CD,種別,主CD,名称 " \
                    "FROM M90共通 " 
        strSql += "WHERE 削除FLG=0 " 
        if vnt_ew != "":
            strSql += "AND 種別 Like '%" +  vnt_ew  +"%' " 
        strSql += "ORDER BY 種別CD,主CD "  
        res = appDataCom.executeSelect(strSql)

        pageorigin = int(request.args.get("pageorigin","0"))
        #ページネーション
        result,pageend,pagelen = commonfnc.pagen(res,pageorigin,5)
             
        return render_template("eh10/eh"+vntGid+".html",\
                          vntGname=vntGname,res=result,pageorigin=pageorigin,pageend=pageend,pagelen=pagelen,vnt_ew=vnt_ew,vntGid=vntGid)
    return render_template("login.html")

@app.route("/eh10/eh10YU", methods=["GET"])
def eh10YU_get(): 
    vntGid = "10YU"
    #画面名称
    res = appDataCom.get_MA0GAMEN(vntGid )
    vntGname =res[0]
    vntGLV   =res[1] 
    #ここに権限レベルのチェックを入れないと直接URL指定すると利用できてしまう
    if session["Rq_UserLv"]<vntGLV:
        return menu()
    
    if "Rq_UserID" in session:
        vnt_fnc = request.args.get("fnc","")
        if vnt_fnc == "add":
            res = ""
            vnt_id = ""
            return render_template("eh10/eh"+vntGid+".html",\
                          vntGname=vntGname+"登録",res=res,vnt_id=vnt_id,vnt_fnc=vnt_fnc,vntGid=vntGid)
        else:
            vnt_id = request.args.get("id","")

            res = appDataCom.get_M90kyoutu_id(vnt_id)
        
            return render_template("eh10/eh"+vntGid+".html",\
                          vntGname=vntGname+"更新",res=res,vnt_id=vnt_id,vnt_fnc=vnt_fnc,vntGid=vntGid)
    return render_template("login.html")

@app.route("/eh10/eh10YU", methods=["POST"])
def eh10YU_post(): 
    vntGid = "10YU"
    #画面名称
    res = appDataCom.get_MA0GAMEN(vntGid )
    vntGname =res[0]
    vntGLV   =res[1] 
    #ここに権限レベルのチェックを入れないと直接URL指定すると利用できてしまう
    if session["Rq_UserLv"]<vntGLV:
        return menu()
    
    if "Rq_UserID" in session:
        appDataCom.eh10YUDataApp(vntGid)   
        return redirect(url_for("eh10Y0_get"))
    return render_template("login.html")

@app.route("/requestM70", methods=["POST"])
def requestM70():
    key = request.form['Rq_ItemCd']
    
    res = appDataCom.get_M70ITEM(key)
    
    return jsonify({'itemNm': res[0], \
                     'itemSuu':res[1], \
                     'itemTanaCd':res[2], \
                     'itemDelFlg':res[3] \
                     })

@app.route("/requestM80", methods=["POST"])
def requestM80():
    key = request.form['Rq_TantoCd']
   
    res = appDataCom.get_M80tanto_TantoCd(key)
    
    return jsonify({'TantoNm': res[0], \
                    'TantoLV':res[1] \
                     })
 
if __name__ == "__main__":
    app.run(debug=True, host='127.0.0.1', port=5000, threaded=True)  
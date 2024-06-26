import pprint
import pyodbc
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
        user = request.form.get("Rq_UserID")
        session["Rq_UserID"] =user
        return redirect(url_for("menu"))  
    else:
        if "Rq_UserID" in session:
            return redirect(url_for("menu"))
        return render_template("login.html")
    
@app.route("/logoff", methods=["GET"])
def logoff():
    session.pop("Rq_UseID",None)
    session.clear()
    return redirect("/")

@app.route("/menu", methods=["GET","POST"])
def menu():
    if "Rq_UserID" in session:
        strSql = " SELECT MA0.* " \
                "FROM MA0画面制御 AS MA0 " \
                "INNER JOIN MA1画面制御明細 AS MA1 ON MA0.画面番号=MA1.画面番号 AND MA1.担当CD='9999' AND 権限>1 " \
                "WHERE LEFT(MA0.画面番号,2)='10' AND SUBSTRING(MA0.画面番号,3,2)<>'00'  AND SUBSTRING(MA0.画面番号,4,1)='0'AND MA0.削除FLG=0 " \
	            " ORDER BY MA0.画面番号 " 

        res = appDataCom.executeSelect(strSql)

        vntBody1 = ""

        return render_template("menu.html",\
                          title = res[0],vntBody1=vntBody1,res=res)
    return render_template("login.html")
 
@app.route("/eh10/eh1010", methods=["GET", "POST"])
def eh1010_post():
    vntGid = "1010"
    res = appDataCom.get_MA0GAMEN(vntGid )
    vntGname =res[0]
    
    if request.method == "POST":
        Rq_ItemCd = request.form["Rq_ItemCd"]
        if Rq_ItemCd != "":
            vntItemZaiSuu = request.form['Rq_ItemZaiSuu']
            vntItemSuu = request.form['Rq_ItemSuu']
            print(vntItemZaiSuu)
            vntZaisuu = int(vntItemZaiSuu) - int(vntItemSuu)
            today_data = datetime.date.today() 
            vntData = str(today_data.year) + str(today_data.month).zfill(2)+str(today_data.day).zfill(2)
 
            strSql = " INSERT INTO  " \
                        "T10SHIP " \
                            "(アイテムCD," \
                            "アイテム出庫数," \
                            "アイテム出庫YMD," \
                            "IPADDR," \
                            "登録日," \
                            "登録者ID) " \
                        "VALUES (" \
                            "'" + request.form['Rq_ItemCd'] + "'," \
                            "'"  + request.form['Rq_ItemSuu'] + "'," \
                            "'" + vntData + "'," \
                            "'" + request.remote_addr + "'," \
                            "CURRENT_TIMESTAMP," \
                            "'" + session["Rq_UserID"] + "'" \
                            ")" 
            
            conn = appDataCom.defSqlConnect()
            cur = conn.cursor()
            try:
                cur.execute(strSql)
                strSql = " UPDATE M70ITEM SET " \
        	            "アイテム在庫数	="	+ str(vntZaisuu) +"," \
        	            "更新日	=CURRENT_TIMESTAMP," \
       	                "更新者ID	=" + session["Rq_UserID"] + "," \
					    "GID		='"	+vntGid+"' " \
        	            "WHERE アイテムCD='"	+ request.form['Rq_ItemCd'] +"' AND 削除FLG=0 " 

                con2 = appDataCom.defSqlConnect()
                cur = con2.cursor()
                try:
                    cur.execute(strSql)
                    con2.commit()
                    conn.commit()
                    con2.close()
                    conn.close()               

                except pyodbc.Error as ex:
                    print(f'An error occurred:{ex}')
                    con2.rollback()
                    conn.rollback()
                    
            except pyodbc.Error as ex:
                    print(f'An error occurred:{ex}')
                    conn.rollback()
                    # conn.close()
            #return cur.rowcount
            
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
    
    if request.method == "POST":
        Rq_ItemCd = request.form["Rq_ItemCd"]
        if Rq_ItemCd != "":
            vntItemZaiSuu = request.form['Rq_ItemZaiSuu']
            vntItemSuu = request.form['Rq_ItemSuu']
            print(vntItemZaiSuu)
            vntZaisuu = int(vntItemZaiSuu) + int(vntItemSuu)
            today_data = datetime.date.today() 
            vntData = str(today_data.year) + str(today_data.month).zfill(2)+str(today_data.day).zfill(2)
 
            strSql = " INSERT INTO  " \
                        "T20INSUU " \
                            "(アイテムCD," \
                            "アイテム入荷数," \
                            "アイテム入荷YMD," \
                            "IPADDR," \
                            "登録日," \
                            "登録者ID) " \
                        "VALUES (" \
                            "'" + request.form['Rq_ItemCd'] + "'," \
                            "'" + request.form['Rq_ItemSuu'] + "'," \
                            "'" + vntData + "'," \
                            "'" + request.remote_addr + "'," \
                            "CURRENT_TIMESTAMP," \
                            "'" + session["Rq_UserID"] + "'" \
                            ")" 
            
            conn = appDataCom.defSqlConnect()
            cur = conn.cursor()
            try:
                cur.execute(strSql)
                strSql = " UPDATE M70ITEM SET " \
        	            "アイテム在庫数	="	+ str(vntZaisuu) +"," \
        	            "更新日	=CURRENT_TIMESTAMP," \
       	                "更新者ID	=" + session["Rq_UserID"] + "," \
					    "GID		='"	+vntGid+"' " \
        	            "WHERE アイテムCD='"	+ request.form['Rq_ItemCd'] +"' AND 削除FLG=0 " 

                con2 = appDataCom.defSqlConnect()
                cur = con2.cursor()
                try:
                    cur.execute(strSql)
                    con2.commit()
                    conn.commit()
                    con2.close()
                    conn.close()               

                except pyodbc.Error as ex:
                    print(f'An error occurred:{ex}')
                    con2.rollback()
                    conn.rollback()
                    
            except pyodbc.Error as ex:
                    print(f'An error occurred:{ex}')
                    conn.rollback()
                 
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
    
    if "Rq_UserID" in session:
        vnt_ew = request.args.get("Rq_ew","")
        strSql = " SELECT アイテムCD,アイテム名,アイテム在庫数,アイテム棚番号 " \
                    "FROM M70ITEM " 
        strSql += "WHERE 削除FLG=0 " 
        if vnt_ew != "":
            strSql += "AND アイテム名 Like '%" +  vnt_ew  +"%' " 
        strSql += "ORDER BY ID "  
        res = appDataCom.executeSelect(strSql)

        pageorigin = int(request.args.get("pageorigin","0"))
        #ページネーション
        result,pageend,pagelen = commonfnc.pagen(res,pageorigin,5)
             
        return render_template("eh10/eh"+vntGid+".html",\
                          vntGname=vntGname,res=result,pageorigin=pageorigin,pageend=pageend,pagelen=pagelen,vnt_ew=vnt_ew,vntGid=vntGid)
    return render_template("login.html") 

@app.route("/eh10/eh1050", methods=["GET"])
def eh1050_get():
    vntGid = "1050"
    res = appDataCom.get_MA0GAMEN(vntGid )
    vntGname =res[0]
    if "Rq_UserID" in session:
        strSql = " SELECT T10.アイテムCD,M70.アイテム名,T10.アイテム出庫数,M70.アイテム在庫数,M70.アイテム棚番号,SUBSTRING(T10.アイテム出庫YMD,5,2)+'/'+SUBSTRING(T10.アイテム出庫YMD,7,2) " \
                "FROM T10SHIP AS T10 " \
                "INNER JOIN M70ITEM AS M70 ON M70.アイテムCD=T10.アイテムCD " \
                "WHERE T10.削除FLG=0 AND LEN(M70.アイテム棚番号)>0 " \
	            " ORDER BY T10.ID DESC" 

        res = appDataCom.executeSelect(strSql)

        pageorigin = int(request.args.get("pageorigin","0"))
        #ページネーション
        result,pageend,pagelen = commonfnc.pagen(res,pageorigin,5)
            
        return render_template("eh10/eh"+vntGid+".html",\
                          vntGname=vntGname,res=result,pageorigin=pageorigin,pageend=pageend,pagelen=pagelen,vntGid=vntGid)
    return render_template("login.html")
 
@app.route("/eh10/eh1060", methods=["GET"])
def eh1060_get():
    vntGid = "1060"
    res = appDataCom.get_MA0GAMEN(vntGid )
    vntGname =res[0]
    if "Rq_UserID" in session:
        strSql = " SELECT T20.アイテムCD,M70.アイテム名,T20.アイテム入荷数,M70.アイテム在庫数,M70.アイテム棚番号,FORMAT(T20.登録日, 'MM/dd') " \
                "FROM T20INSUU AS T20 " \
                "INNER JOIN M70ITEM AS M70 ON M70.アイテムCD=T20.アイテムCD " \
                "WHERE T20.削除FLG=0 " \
	            " ORDER BY T20.ID DESC" 

        res = appDataCom.executeSelect(strSql)

        pageorigin = int(request.args.get("pageorigin","0"))
        #ページネーション
        result,pageend,pagelen = commonfnc.pagen(res,pageorigin,5)
            
        return render_template("eh10/eh"+vntGid+".html",\
                          vntGname=vntGname,res=result,pageorigin=pageorigin,pageend=pageend,pagelen=pagelen,vntGid=vntGid)
    return render_template("login.html")

@app.route("/eh10/eh1090", methods=["GET"])
def eh1090_get():   
    vntGid = "1090"
    #画面名称
    res = appDataCom.get_MA0GAMEN(vntGid )
    vntGname =res[0]
    
    if "Rq_UserID" in session:
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
        result,pageend,pagelen = commonfnc.pagen(res,pageorigin,5)
             
        return render_template("eh10/eh"+vntGid+".html",\
                          vntGname=vntGname,res=result,pageorigin=pageorigin,pageend=pageend,pagelen=pagelen,vnt_ew=vnt_ew,vntGid=vntGid)
    return render_template("login.html")

@app.route("/eh10/eh109U", methods=["GET"])
def eh109U_get(): 
    vntGid = "109U"
    #画面名称
    res = appDataCom.get_MA0GAMEN(vntGid )
    vntGname =res[0]

    if "Rq_UserID" in session:
        vnt_fnc = request.args.get("fnc","")
        if vnt_fnc == "add":
            res = ""
            vnt_id = ""
            return render_template("eh10/eh"+vntGid+".html",\
                          vntGname=vntGname+"登録",res=res,vnt_id=vnt_id,vnt_fnc=vnt_fnc,vntGid=vntGid)
        else:
            vnt_id = request.args.get("id","")

            res = appDataCom.get_M70ITEM_id(vnt_id)
        
            return render_template("eh10/eh"+vntGid+".html",\
                          vntGname=vntGname+"更新",res=res,vnt_id=vnt_id,vnt_fnc=vnt_fnc,vntGid=vntGid)
    return render_template("login.html")

@app.route("/eh10/eh109U", methods=["POST"])
def eh109U_post(): 
    vntGid = "109U"
    #画面名称
    res = appDataCom.get_MA0GAMEN(vntGid )
    vntGname =res[0]

    if "Rq_UserID" in session:
        vnt_fnc = request.form['Rq_fnc']
        vnt_id = request.form['EID']
        if vnt_fnc == "add":
            strSql = " INSERT INTO M70ITEM " \
                        "(アイテムCD," \
                           "アイテム名," \
                            "アイテム在庫数," \
                            "アイテム下限数," \
                            "アイテム棚番号," \
                            "アイテム備考 ," \
                            "IPADDR," \
                            "GID," \
                            "登録日," \
                            "登録者ID) " \
                        "VALUES (" \
                            "'" + request.form['Rq_ItemCd'] + "'," \
                            "'" + request.form['Rq_ItemNm'] + "'," \
                            "'" + request.form['Rq_ItemSuu'] + "'," \
                            "'" + request.form['Rq_ItemMinSuu'] + "'," \
                            "'" + request.form['Rq_ItemTanaCd'] + "'," \
                            "'" + request.form['Rq_ItemBikou'] + "'," \
                            "'" + request.remote_addr + "'," \
                            "'"	+ vntGid +"'," \
                            "CURRENT_TIMESTAMP," \
                            "'" + session["Rq_UserID"] + "'" \
                            ")" 
        elif vnt_fnc == "delete":
            strSql = " UPDATE M70ITEM SET  " \
                        "更新日         =CURRENT_TIMESTAMP," \
                        "更新者ID       ='" + session["Rq_UserID"] + "'," \
                        "削除FLG        =9," \
                        "IPADDR         ='" + request.remote_addr + "'," \
                        "GID            ='"	+vntGid+"' " \
                    "WHERE ID=" + vnt_id
        else:
            vnt_id = request.form['EID']
            strSql = " UPDATE M70ITEM SET  " \
                        "アイテムCD     ='" + request.form['Rq_ItemCd'] + "'," \
                        "アイテム名     ='"  + request.form['Rq_ItemNm'] + "'," \
                        "アイテム在庫数 ='"  + request.form['Rq_ItemSuu'] + "'," \
                        "アイテム下限数 ='"  + request.form['Rq_ItemMinSuu'] + "'," \
                        "アイテム棚番号 ='"  + request.form['Rq_ItemTanaCd'] + "'," \
                        "アイテム備考   ='" + request.form['Rq_ItemBikou'] + "'," \
                        "IPADDR         ='" + request.remote_addr + "'," \
                        "更新日         =CURRENT_TIMESTAMP," \
                        "更新者ID       ='" + session["Rq_UserID"] + "'," \
                        "GID            ='"	+vntGid+"' " \
                    "WHERE ID=" + vnt_id
 
        conn = appDataCom.defSqlConnect()
        cur = conn.cursor()
        try:
            cur.execute(strSql)
            conn.commit()
            conn.close()               

        except pyodbc.Error as ex:
            print(f'An error occurred:{ex}')
            conn.rollback()
                
        return redirect(url_for("eh1090_get"))
    return render_template("login.html")

@app.route("/eh10/eh10A0", methods=["GET"])
def eh10A0_get():
    vntGid = "10A0"
    res = appDataCom.get_MA0GAMEN(vntGid )
    vntGname =res[0]
    if "Rq_UserID" in session:
        strSql = " SELECT アイテムCD,アイテム名,アイテム在庫数,アイテム下限数,アイテム下限数,アイテム棚番号 " \
                    "FROM M70ITEM " 
        strSql += "WHERE 削除FLG=0 " \
                    "And LEN(アイテム棚番号)>0 And アイテム下限数>=アイテム在庫数 "
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

@app.route("/requestM70", methods=["POST"])
def requestM70():
    key = request.form['Rq_ItemCd']
    
    res = appDataCom.get_M70ITEM(key)
    
    return jsonify({'itemNm': res[0], \
                     'itemSuu':res[1], \
                     'itemTanaCd':res[2], \
                     'itemDelFlg':res[3] \
                     })
 
if __name__ == "__main__":
    app.run(debug=True, host='127.0.0.1', port=8080, threaded=True)  
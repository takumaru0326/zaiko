import pprint
import pyodbc
import appDataCom

from flask import Flask, redirect, render_template, url_for, request ,jsonify 
from datetime import timedelta

app = Flask(__name__)

@app.route('/')

@app.route("/menu", methods=["GET","POST"])
def menu():
    strSql = " SELECT MA0.* " \
            "FROM MA0画面制御 AS MA0 " \
            "INNER JOIN MA1画面制御明細 AS MA1 ON MA0.画面番号=MA1.画面番号 AND MA1.担当CD='9999' AND 権限>1 " \
            "WHERE LEFT(MA0.画面番号,2)='10' AND SUBSTRING(MA0.画面番号,3,2)<>'00'  AND SUBSTRING(MA0.画面番号,4,1)='0'AND MA0.削除FLG=0 " \
	        " ORDER BY MA0.画面番号 " 

    res = appDataCom.executeSelect(strSql)

    vntBody1 = ""

    return render_template("menu.html",\
                    title = res[0],vntBody1=vntBody1,res=res)
  
@app.route("/eh10/eh1010", methods=["GET", "POST"])
def eh1010_post():
         vntGid = "1010"
         res = appDataCom.get_MA0GAMEN(vntGid )
         work =res[0]
         return render_template("eh10/eh1010.html",\
                           vntGid = vntGid,work=work)

if __name__ == "__main__":
    app.run(debug=True, host='127.0.0.1', port=8080, threaded=True)  
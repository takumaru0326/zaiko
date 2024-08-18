import pprint
import pyodbc
import datetime
from flask import request,session
def defSqlConnect():
    driver='{SQL Server}'
    srvname = '???.???.???.???'
    database = 'ZAIKO'
    #trusted_connection='yes'
    databaseid = 'sa'
    databasepwd = '??????????'
    #connect= pyodbc.connect('DRIVER='+driver+';SERVER='+srvname+';DATABASE='+database+';PORT=1433;Trusted_Connection='+trusted_connection+';')
    connectDB = 'DRIVER='+driver+';\
                 SERVER='+srvname+';\
                 uid='+ databaseid + ';\
                pwd=' + databasepwd + ';\
                DATABASE=' + database+';'
    return pyodbc.connect(connectDB)

def get_M70ITEM(key):
    strSql = "SELECT アイテム名,アイテム在庫数,アイテム棚番号,削除FLG " \
            "FROM M70ITEM " \
            "WHERE アイテムCD='"+ key + "'" 
    rows = executeSelect(strSql)
    return rows[0]

def get_M70ITEM_id(key):
    strSql = " SELECT アイテムCD,アイテム名,アイテム区分,アイテム在庫数,アイテム下限数,アイテム棚番号,アイテム備考 " \
                    "FROM M70ITEM " 
    strSql += "WHERE 削除FLG=0 AND ID=" + key 
    rows = executeSelect(strSql)
    return rows[0]

def get_M80tanto_bosyuCd(key):
    strSql = "SELECT ID,担当CD,担当名,権限CD " \
            "FROM M80担当者 " \
            "WHERE 募集人CD='"+ key + "' AND 削除FLG=0 " 
    rows = executeSelect(strSql)
    return rows

def get_M80tanto_TantoCd(key):
    strSql = "SELECT 担当CD,担当名,権限CD " \
            "FROM M80担当者 " \
            "WHERE 担当CD='"+ key + "' AND 削除FLG=0 " 
    rows = executeSelect(strSql)
    return rows[0]

def get_M80tanto_id(key):
    strSql = "SELECT ID,担当CD,担当名,募集人CD,担当備考,権限CD " \
            "FROM M80担当者 " 
    strSql += "WHERE 削除FLG=0 AND ID=" + key 
    rows = executeSelect(strSql)
    return rows[0]

def get_M90kyoutu_id(key):
    strSql = "SELECT ID,種別CD,種別,主CD,名称 " \
            "FROM M90共通 " 
    strSql += "WHERE 削除FLG=0 AND ID=" + key 
    rows = executeSelect(strSql)
    return rows[0]

def get_M90kyoutu(key):
    strSql = "SELECT 主CD,名称 " \
            "FROM M90共通 " \
            "WHERE 種別='"+ key + "' AND 削除FLG=0 " 
    rows = executeSelect(strSql)
    return rows 

def get_MA0GAMEN(key):
    strSql = "SELECT 画面名称 " \
            "FROM MA0画面制御 " \
            "WHERE 画面番号='"+ key + "' AND 削除FLG=0 " 
    rows = executeSelect(strSql)
    return rows[0]

def executeSelect(strSql):
    conn = defSqlConnect()
    cur = conn.cursor()
    cur.execute(strSql)
    rows = cur.fetchall()
    conn.close()
    return rows
       
def executeInsert(strSql):
    conn = defSqlConnect()
    cur = conn.cursor()
    cur.execute(strSql)
    conn.commit()
    conn.close()
    return cur.rowcount

def eh1010DataApp(vntGid):
    vntItemZaiSuu = request.form['Rq_ItemZaiSuu']
    vntItemSuu = request.form['Rq_ItemSuu']
    vntZaisuu = int(vntItemZaiSuu) - int(vntItemSuu)
    today_data = datetime.date.today() 
    vntData = str(today_data.year) + str(today_data.month).zfill(2)+str(today_data.day).zfill(2)
    strSql = " INSERT INTO  " \
                "T10SHIP " \
                    "(アイテムCD," \
                    "アイテム出庫数," \
                    "アイテム出庫YMD," \
                    "担当CD," \
                    "IPADDR," \
                    "登録日," \
                    "登録者ID) " \
                "VALUES (" \
                    "'" + request.form['Rq_ItemCd'] + "'," \
                    ""  + request.form['Rq_ItemSuu'] + "," \
                    "'" + vntData + "'," \
                    "'" + str(session["Rq_UserCD"]) + "'," \
                    "'" + request.remote_addr + "'," \
                    "CURRENT_TIMESTAMP," \
                    "'" + str(session["Rq_UserID"]) + "'" \
                    ")" 
            
    conn = defSqlConnect()
    cur = conn.cursor()
    try:
        cur.execute(strSql)
        strSql = " UPDATE M70ITEM SET " \
             "アイテム在庫数	="	+ str(vntZaisuu) +"," \
             "更新日	=CURRENT_TIMESTAMP," \
             "更新者ID	=" + str(session["Rq_UserID"]) + "," \
	         "GID		='"	+vntGid+"' " \
             "WHERE アイテムCD='"	+ request.form['Rq_ItemCd'] +"' AND 削除FLG=0 " 

        con2 = defSqlConnect()
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
   
    return cur.rowcount

#入庫登録画面
def eh1020DataApp(vntGid):
    vntItemZaiSuu = request.form['Rq_ItemZaiSuu']
    vntItemSuu = request.form['Rq_ItemSuu']
    vntZaisuu = int(vntItemZaiSuu) + int(vntItemSuu)
    today_data = datetime.date.today() 
    vntData = str(today_data.year) + str(today_data.month).zfill(2)+str(today_data.day).zfill(2)
 
    strSql = " INSERT INTO  " \
                "T20INSUU " \
                    "(アイテムCD," \
                    "アイテム入荷数," \
                    "アイテム入荷YMD," \
                    "担当CD," \
                    "IPADDR," \
                    "登録日," \
                    "登録者ID) " \
                "VALUES (" \
                    "'" + request.form['Rq_ItemCd'] + "'," \
                    "'" + request.form['Rq_ItemSuu'] + "'," \
                    "'" + vntData + "'," \
                    "'" + str(session["Rq_UserCD"]) + "'," \
                    "'" + request.remote_addr + "'," \
                    "CURRENT_TIMESTAMP," \
                    "'" + str(session["Rq_UserID"]) + "'" \
                    ")" 
            
    conn = defSqlConnect()
    cur = conn.cursor()
    try:
        cur.execute(strSql)
        strSql = " UPDATE M70ITEM SET " \
                "アイテム在庫数	="	+ str(vntZaisuu) +"," \
                "更新日	=CURRENT_TIMESTAMP," \
       	        "更新者ID	=" + str(session["Rq_UserID"]) + "," \
			    "GID		='"	+vntGid+"' " \
                "WHERE アイテムCD='"	+ request.form['Rq_ItemCd'] +"' AND 削除FLG=0 " 

        con2 = defSqlConnect()
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
    return cur.rowcount

#アイテム管理画面　
def eh109UDataApp(vntGid):
    vnt_fnc = request.form['Rq_fnc']
    vnt_id = request.form['EID']
    if vnt_fnc == "add":
        strSql = " INSERT INTO M70ITEM " \
                    "(アイテムCD," \
                        "アイテム名," \
                        "アイテム区分," \
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
                        "'" + request.form['Rq_ItemKbn'] + "'," \
                        "'" + request.form['Rq_ItemSuu'] + "'," \
                        "'" + request.form['Rq_ItemMinSuu'] + "'," \
                        "'" + request.form['Rq_ItemTanaCd'] + "'," \
                        "'" + request.form['Rq_ItemBikou'] + "'," \
                        "'" + request.remote_addr + "'," \
                        "'"	+ vntGid +"'," \
                        "CURRENT_TIMESTAMP," \
                        "'" + str(session["Rq_UserID"]) + "'" \
                        ")" 
    elif vnt_fnc == "delete":
        strSql = " UPDATE M70ITEM SET  " \
                    "更新日         =CURRENT_TIMESTAMP," \
                    "更新者ID       ='" +str(session["Rq_UserID"]) + "'," \
                    "削除FLG        =9," \
                    "IPADDR         ='" + request.remote_addr + "'," \
                    "GID            ='"	+vntGid+"' " \
                "WHERE ID=" + vnt_id
    else:
        vnt_id = request.form['EID']
        strSql = " UPDATE M70ITEM SET  " \
                    "アイテムCD     ='" + request.form['Rq_ItemCd'] + "'," \
                    "アイテム名     ='"  + request.form['Rq_ItemNm'] + "'," \
                    "アイテム区分   ='" + request.form['Rq_ItemKbn'] + "'," \
                    "アイテム在庫数 ='"  + request.form['Rq_ItemSuu'] + "'," \
                    "アイテム下限数 ='"  + request.form['Rq_ItemMinSuu'] + "'," \
                    "アイテム棚番号 ='"  + request.form['Rq_ItemTanaCd'] + "'," \
                    "アイテム備考   ='" + request.form['Rq_ItemBikou'] + "'," \
                    "IPADDR         ='" + request.remote_addr + "'," \
                    "更新日         =CURRENT_TIMESTAMP," \
                    "更新者ID       ='" + str(session["Rq_UserID"]) + "'," \
                    "GID            ='"	+vntGid+"' " \
                "WHERE ID=" + vnt_id
    conn = defSqlConnect()
    cur = conn.cursor()
    try:
        cur.execute(strSql)
        conn.commit()
        conn.close()               

    except pyodbc.Error as ex:
        print(f'An error occurred:{ex}')
        conn.rollback()

    return cur.rowcount

def eh10WUDataApp(vntGid):
    vnt_fnc = request.form['Rq_fnc']
    vnt_id = request.form['EID']
    if vnt_fnc == "add":
        strSql = " INSERT INTO M80担当者 " \
                    "(担当CD," \
                        "担当名," \
                        "募集人CD," \
                        "権限CD," \
                        "担当備考," \
                        "IPADDR," \
                        "GID," \
                        "登録日," \
                        "登録者ID) " \
                    "VALUES (" \
                        "'" + request.form['Rq_TantoCd'] + "'," \
                        "'" + request.form['Rq_TantoNm'] + "'," \
                        "'" + request.form['Rq_BosyuCd'] + "'," \
                        "'" + request.form['Rq_KengenCd'] + "'," \
                        "'" + request.form['Rq_TantoBikou'] + "'," \
                        "'" + request.remote_addr + "'," \
                        "'"	+ vntGid +"'," \
                        "CURRENT_TIMESTAMP," \
                        "'" + str(session["Rq_UserID"]) + "'" \
                        ")" 
    elif vnt_fnc == "delete":
        strSql = " UPDATE M80担当者 SET  " \
                    "更新日         =CURRENT_TIMESTAMP," \
                    "更新者ID       ='" +str(session["Rq_UserID"]) + "'," \
                    "削除FLG        =9," \
                    "IPADDR         ='" + request.remote_addr + "'," \
                    "GID            ='"	+vntGid+"' " \
                "WHERE ID=" + vnt_id
    else:
        vnt_id = request.form['EID']
        strSql = " UPDATE M80担当者 SET  " \
                    "担当CD     ='" + request.form['Rq_TantoCd'] + "'," \
                    "担当名     ='"  + request.form['Rq_TantoNm'] + "'," \
                    "募集人CD   ='"  + request.form['Rq_BosyuCd'] + "'," \
                    "権限CD     ='" + request.form['Rq_KengenCd'] + "'," \
                    "担当備考   ='" + request.form['Rq_TantoBikou'] + "'," \
                    "IPADDR         ='" + request.remote_addr + "'," \
                    "更新日         =CURRENT_TIMESTAMP," \
                    "更新者ID       ='" + str(session["Rq_UserID"]) + "'," \
                    "GID            ='"	+vntGid+"' " \
                "WHERE ID=" + vnt_id
    conn = defSqlConnect()
    cur = conn.cursor()
    try:
        cur.execute(strSql)
        conn.commit()
        conn.close()               

    except pyodbc.Error as ex:
        print(f'An error occurred:{ex}')
        conn.rollback()
    return cur.rowcount  

def eh10YUDataApp(vntGid):
    vnt_fnc = request.form['Rq_fnc']
    vnt_id = request.form['EID']
    if vnt_fnc == "add":
        strSql = " INSERT INTO M90共通 " \
                    "(種別CD," \
                        "種別," \
                        "主CD," \
                        "名称," \
                        "IPADDR," \
                        "GID," \
                        "登録日," \
                        "登録者ID) " \
                    "VALUES (" \
                        "'" + request.form['Rq_TantoCd'] + "'," \
                        "'" + request.form['Rq_TantoNm'] + "'," \
                        "'" + request.form['Rq_BosyuCd'] + "'," \
                        "'" + request.form['Rq_TantoBikou'] + "'," \
                        "'" + request.remote_addr + "'," \
                        "'"	+ vntGid +"'," \
                        "CURRENT_TIMESTAMP," \
                        "'" + str(session["Rq_UserID"]) + "'" \
                        ")" 
    elif vnt_fnc == "delete":
        strSql = " UPDATE M90共通 SET  " \
                    "更新日     =CURRENT_TIMESTAMP," \
                    "更新者ID   ='" +str(session["Rq_UserID"]) + "'," \
                    "削除FLG    =9," \
                    "IPADDR     ='" + request.remote_addr + "'," \
                    "GID        ='"	+vntGid+"' " \
                "WHERE ID=" + vnt_id
    else:
        vnt_id = request.form['EID']
        strSql = " UPDATE M90共通 SET  " \
                    "種別CD     ='" + request.form['Rq_TantoCd'] + "'," \
                    "種別       ='"  + request.form['Rq_TantoNm'] + "'," \
                    "主CD       ='"  + request.form['Rq_BosyuCd'] + "'," \
                    "名称       ='" + request.form['Rq_TantoBikou'] + "'," \
                    "IPADDR     ='" + request.remote_addr + "'," \
                    "更新日     =CURRENT_TIMESTAMP," \
                    "更新者ID   ='" + str(session["Rq_UserID"]) + "'," \
                    "GID        ='"	+vntGid+"' " \
                "WHERE ID=" + vnt_id
    conn = defSqlConnect()
    cur = conn.cursor()
    try:
        cur.execute(strSql)
        conn.commit()
        conn.close()               

    except pyodbc.Error as ex:
        print(f'An error occurred:{ex}')
        conn.rollback() 
    return cur.rowcount          
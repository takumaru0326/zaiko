import pprint
import pyodbc

def defSqlConnect():
    driver='{SQL Server}'
    srvname = 'xxx.xxx.xxx.xxx'
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
    
def get_MA0GAMEN(key):
    strSql = "SELECT 画面名称 " \
            "FROM MA0画面制御 " \
            "WHERE 画面番号='"+ key + "' AND 削除FLG=0 " 
    rows = executeSelect(strSql)
    return rows[0]

def get_M80tanto(key):
    strSql = "SELECT 担当CD,担当名,権限CD " \
            "FROM M80担当者 " \
            "WHERE 募集人CD='"+ key + "' AND 削除FLG=0 " 
    rows = executeSelect(strSql)
    return rows

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

def get_M70ITEM(key):
    strSql = "SELECT アイテム名,アイテム在庫数,アイテム棚番号,削除FLG " \
            "FROM M70ITEM " \
            "WHERE アイテムCD='"+ key + "'" 
    rows = executeSelect(strSql)
    return rows[0]

def get_M70ITEM_id(key):
    strSql = " SELECT アイテムCD,アイテム名,アイテム在庫数,アイテム下限数,アイテム棚番号,アイテム備考 " \
                    "FROM M70ITEM " 
    strSql += "WHERE 削除FLG=0 AND ID=" + key 
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

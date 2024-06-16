import pprint
import pyodbc

def defSqlConnect():
    driver='{SQL Server}'
    srvname = '127.0.0.1'
    database = 'ZAIKO'
    #trusted_connection='yes'
    databaseid = 'sa'
    databasepwd = '????????????'
    connectDB = 'DRIVER='+driver+';\
                 SERVER='+srvname+';\
                 uid='+ databaseid + ';\
                pwd=' + databasepwd + ';\
                DATABASE=' + database+';'
    return pyodbc.connect(connectDB)
    
def get_MA0GAMEN(key):
    strSql = "SELECT 画面名称 " \
            "FROM MA0画面制御 " \
            "WHERE 画面番号='"+ key + "'" 
    rows = executeSelect(strSql)
    return rows[0]

def get_M70ITEM(key):
    strSql = "SELECT アイテム名,アイテム在庫数,アイテム棚番号,削除FLG " \
            "FROM M70ITEM " \
            "WHERE アイテムCD='"+ key + "'" 
    rows = executeSelect(strSql)
    return rows[0]

def executeSelect(strSql):
    conn = defSqlConnect()
    cur = conn.cursor()
    cur.execute(strSql)
    rows = cur.fetchall()
    #cur.close()
    conn.close()
    return rows
       
def executeInsert(strSql):
    conn = defSqlConnect()
    cur = conn.cursor()
    cur.execute(strSql)
    conn.commit()
    #cur.close()
    conn.close()
    return cur.rowcount

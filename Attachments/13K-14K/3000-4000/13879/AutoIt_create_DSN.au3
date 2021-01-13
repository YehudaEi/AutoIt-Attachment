Func ODBCSample()

Local $EnvironHandle ;Enviroment descriptor
Local $ConnHandle ;Connection descriptor
Local $StmtHandle ;Statement descriptor

;Some ODBC API constants
Const $SQL_LOGIN_TIMEOUT=103
Const $SQL_UNBIND=2
Const $MAX_DATA_BUFFER = 2047
Const $SQL_SUCCESS = 0
Const $SQL_SUCCESS_WITH_INFO = 1
Const $SQL_ERROR = -1
Const $SQL_NO_DATA_FOUND = 100
Const $SQL_FETCH_FIRST = 2
Const $SQL_FETCH_NEXT = 1
Const $SQL_C_CHAR = 1


$dll=DllOpen("odbc32.DLL") ;Open odbc driver manager
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;Get Enviroment descriptor
Local $AllocBuffer= DllStructCreate("udword")
$result=DllCall($dll, _
"short","SQLAllocEnv", _
"long",DllStructGetPtr($AllocBuffer))

$EnvironHandle=DllStructGetData($AllocBuffer,1)
$AllocBuffer=0
MsgBox (262192,"SQLAllocEnv result","[Function result]" & @CR & $result[0] & @CR & _
"[Enviroment descriptor]" & @CR & $EnvironHandle)
$result=0
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;Get Information about Datasources
Dim $result[9]
$result[6]="ALPHA"

Local $DSNBuffer = DllStructCreate("char[260]")
Local $Buffer1 = DllStructCreate("long")
Local $DSDBuffer = DllStructCreate("char[260]")
Local $Buffer2 = DllStructCreate("long")

While 1
$result=DllCall($dll, _
"int" ,"SQLDataSourcesW", _
"long" ,$EnvironHandle, _
"long" ,$SQL_FETCH_NEXT, _
"wstr" ,DllStructGetPtr($DSNBuffer), _
"long" ,255, _
"long" ,DllStructGetPtr($Buffer1), _
"wstr" ,DllStructGetPtr($DSDBuffer), _
"long" ,255, _
"long" ,DllStructGetPtr($Buffer2))

If StringIsDigit ($result[6])=True then ExitLoop

MsgBox(262192,"SQLDataSourcesW result", "[Function result]" & @CR & $result[0] & @CR & _
"[Enviroment descriptor]" & @CR & $result[1] & @CR & _
"[Direction]" & @CR & $result[2] & @CR & _
"[Data Source Name]" & @CR & $result[3] & @CR & _
"[DS Description]" & @CR & $result[6] )


Wend
$result=0
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;Get connection descriptor
Local $AllocBuffer= DllStructCreate("udword")
$result=DllCall($dll,"long","SQLAllocConnect", _
"long",$EnvironHandle, _
"long",DllStructGetPtr($AllocBuffer))

$ConnHandle=DllStructGetData($AllocBuffer,1)
$AllocBuffer=0
MsgBox (262192,"SQLAllocConnect result","[Function result]" & @CR & $result[0] & @CR & _
"[Connection descriptor]" & @CR & $ConnHandle)
$result=0
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;Create connection with ODBC system datasource
$ConnStr="MyDataSource"

$result=DllCall($dll,"long","SQLConnectW", _
"long", $ConnHandle, _
"wstr", $ConnStr, _
"int", StringLen($ConnStr), _
"wstr", "", _
"int", 0, _
"wstr", "", _
"int", 0)

MsgBox (262192,"SQLConnectW result", "[Function result]" & @CR & $result[0] & @CR & _
"[Connection descriptor]" & @CR & $result[1] & @CR & _
"[Connection string]" & @CR & $result[2] & @CR & _
"[Login]" & @CR & $result[4] & @CR & _
"[Password]" & @CR & $result[6])
$result=0
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;Get statement descriptor
Local $AllocBuffer= DllStructCreate("udword")
$result=DllCall($dll,"long","SQLAllocStmt", _
"long",$ConnHandle, _
"long",DllStructGetPtr($AllocBuffer))

$StmtHandle=DllStructGetData($AllocBuffer,1)
$AllocBuffer=0
MsgBox (262192,"SQLAllocStmt result","[Function result]" & @CR & $result[0] & @CR & _
"[Statement descriptor]" & @CR & $StmtHandle)



;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;Execute SQL commands
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;Adding new table
$SQL_Command="CREATE TABLE AUTOIT(col1 varchar)"
$Len=StringLen($SQL_Command)
$result=DllCall($dll,"long","SQLExecDirectW", _
"long" ,$StmtHandle, _ ;StatementHandle
"wstr" ,$SQL_Command, _ ;SQL Query
"long" ,$Len)

MsgBox (262192,"SQLExecDirect result", "Adding new table" & @CR & _
"[Function result]" & @CR & $result[0] & @CR & _
"[Statement descriptor]" & @CR & $result[1] & @CR & _
"[SQL query]" & @CR & $result[2])
;
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;Insert new values
$SQL_Command="INSERT INTO AUTOIT VALUES('AutoIt_ExcellentScriptingLanguage')"
$Len=StringLen($SQL_Command)
$result=DllCall($dll,"long","SQLExecDirectW", _
"long" ,$StmtHandle, _ ;StatementHandle
"wstr" ,$SQL_Command, _ ;SQL Query
"long" ,$Len)

MsgBox (262192,"SQLExecDirect result", "Insert values" & @CR & _
"[Function result]" & @CR & $result[0] & @CR & _
"[Statement descriptor]" & @CR & $result[1] & @CR & _
"[SQL query]" & @CR & $result[2])
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;Read values++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;Execute SELECT SQL command
$SQL_Command="SELECT * FROM AUTOIT"
$Len=StringLen($SQL_Command)
$result=DllCall($dll,"long","SQLExecDirectW", _
"long" ,$StmtHandle, _ ;StatementHandle
"wstr" ,$SQL_Command, _ ;SQL Query
"long" ,$Len)

MsgBox (262192,"SQLExecDirect result", "Read values" & @CR & _
"[Function result]" & @CR & $result[0] & @CR & _
"[Statement descriptor]" & @CR & $result[1] & @CR & _
"[SQL query]" & @CR & $result[2])
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;Retreive Data from recordset
Local $Buffer1= DllStructCreate("int")
Local $Buffer2= DllStructCreate("char[260]")
$Cdata=""

$NormalResult=0
While 1
;Going to next recordset row

$PrevResult=$NormalResult
$result=DllCall($dll,"long","SQLFetch", _
"long",$StmtHandle) ;StatementHandle

$NormalResult=$result[0]

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

$result=DllCall($dll, _
"long" ,"SQLGetData", _
"long" ,$StmtHandle, _
"long" ,1, _
"int" ,$SQL_C_CHAR, _
"str" ,DllStructGetPtr($Buffer2), _
"long" ,255, _
"long" ,DllStructGetPtr($Buffer1))
If $PrevResult<>"" and $NormalResult<>$PrevResult then ExitLoop
$Cdata=$Cdata & $result[4] & @CRLF
Wend 

MsgBox (262192,"SQLGetData Receiving column data","[Function result]" & @CR & $result[0] & @CR & _
"[Statement descriptor]" & @CR & $result[1] & @CR & _
"[Column number [begin from 1]]" & @CR & $result[2] & @CR & _
"[Data Type]" & @CR & $result[3] & @CR & _
"[Data]" & @CR & $Cdata & @CR & _
"[Max Data Buffer]" & @CR & $result[5] & @CR & _
"[Data Bufer pointer]" & @CR & $result[6])

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;Count columns
Local $AllocBuffer= DllStructCreate("udword")
$result=DllCall($dll,"long","SQLNumResultCols", _
"long",$StmtHandle, _ ;StatementHandle
"long",DllStructGetPtr($AllocBuffer)) 

$ColumnCount=DllStructGetData($AllocBuffer,1)
MsgBox (262192,"SQLNumResultCols result","[Function result]" & @CR & $result[0] & @CR & _
"[Column count]" & @CR & $ColumnCount)






;Free Resources
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;Free statement handle
$result=DllCall($dll,"long","SQLFreeStmt", _
"long",$StmtHandle, _ 
"long",$SQL_UNBIND) 
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;Close connection
$result=DllCall($dll,"long","SQLDisconnect", _
"long",$ConnHandle) 
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;Free connection descriptor
$result=DllCall($dll,"long","SQLFreeConnect", _
"long",$ConnHandle) 
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;Free enviroment descriptor
$result=DllCall($dll,"long","SQLFreeEnv", _
"long",$EnvironHandle) 
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DllClose($dll)
MsgBox (262192,"Sample","API Sample Complete.")
EndFunc




;Appendix
;**************************************************************************
;Constants and parameters for datasource create.Change some parameters
;such as 'DSN' or 'DefaultDir' for determine datasource configuration.
;**************************************************************************
Const $ODBC_ADD_DSN = 1
Const $ODBC_CONFIG_DSN = 2
Const $ODBC_REMOVE_DSN = 3
Const $ODBC_ADD_SYS_DSN = 4
Const $ODBC_CONFIG_SYS_DSN = 5
Const $ODBC_REMOVE_SYS_DSN = 6
Const $ODBC_REMOVE_DEFAULT_DSN = 7
;**************************************************************************
Global $CfgOptions[5][2]
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;DSN parameters for Excel driver
$CfgOptions[0][0]= "Microsoft Excel Driver (*.xls)"
$CfgOptions[0][1]= "DSN=MyDataSource;" & _
"Description=Excel Data Source;" & _
"DBQ=C:\sourcefileautoittestscript.xls;" & _
"DefaultDir=C:\;" & _
"FileType=Excel;" & _
"DataDirectory=C:\;" & _
"MaxScanRows=5"
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;DSN parameters for Access driver
$CfgOptions[1][0]= "Microsoft Access Driver (*.mdb)"
$CfgOptions[1][1]= "DSN=MyDataSource;" & _
"Description=Access Data Source;" & _
"DBQ=C:\MyAutoIt\source.mdb;" & _
"DefaultDir=C:\MyAutoIt;" & _
"Driver={Microsoft Access Driver (*.mdb)};" & _
"ExtendedAnsiSQL=0;" & _
"FIL=MS Access;" & _
"ImplicitCommitSync=Yes;" & _
"MaxBufferSize=4096;" & _
"MaxScanRows=5;" & _
"PageTimeout=5;" & _
"ReadOnly=0;" & _
"SafeTransactions=0;" & _ 
"Treads=3;" & _
"UserCommitSync=Yes"
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;DSN parameters for Text driver
$CfgOptions[2][0]= "Microsoft Text Driver (*.txt; *.csv)"
$CfgOptions[2][1]= "DSN=MyDataSource;" & _
"Description=Text Data Source;" & _
"UserCommitSync=Yes;" & _
"SafeTransactions=0;" & _
"PageTimeout=5;" & _
"MaxScanRows=8;" & _
"MaxBufferSize=2048;" & _
"FIL=text;" & _
"Extensions=None,asc,csv,tab,txt;" & _
"DriverId=27;" & _
"DefaultDir=C:\MyAutoIt"
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;DSN parameters for Paradox driver
$CfgOptions[3][0]= "Microsoft Paradox Driver (*.db )"
$CfgOptions[3][1]= "DSN=MyDataSource;" & _
"UID=admin;" & _
"UserCommitSync=Yes;" & _
"Threads=3;" & _
"SafeTransactions=0;" & _
"ParadoxUserName=admin;" & _
"ParadoxNetStyle=4.x;" & _
"ParadoxNetPath=C:\WINDOWS.000\SYSTEM;" & _
"PageTimeout=5;" & _
"MaxScanRows=8;" & _
"MaxBufferSize=2048;" & _
"FIL=Paradox 5.X;" & _
"DriverId=538;" & _
"DefaultDir=C:\MyAutoIt;" & _
"CollatingSequence=ASCII"
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''
;DSN parameters for Foxpro driver
;Note: seperator needs to be a | instead of a ;
$CfgOptions[4][0]= "Microsoft Visual FoxPro Driver"
$CfgOptions[4][1]= "DSN=MyDataSource;" & _
"Description=Test;" & _
"SourceDB=D:\DATABASE\database.dbc;" & _
"SourceType=DBC;" & _
"Collate=MACHINE;" & _
"Exclusive=Yes;" & _
"Null=No;" & _
"Deleted=Yes;" & _
"BackgroundFetch=Yes;"
;'''''''''''''''''''''''''''''''''''''''''''''''''''''''''

;**************************************************************************
;Create system ODBC datasource
;**************************************************************************
Func ConfigDS($DriverType,$Parameters)
$dll = DllOpen("odbccp32.dll")
$result = DllCall($dll, _
"long" , "SQLConfigDataSource", _
"hwnd" , 0, _
"long" , $ODBC_ADD_SYS_DSN, _
"str" , $DriverType, _
"str" , $Parameters)

DllClose($dll)
MsgBox (262192,"SQLConfigDataSource", "New datasource successefully created" & @CR & _
$DriverType & @CR & _
$Parameters)

EndFunc
;**************************************************************************

Func GetAll()
;DirCreate ("C:\MyAutoIt") ;Create dir

;This line does work
ConfigDS($CfgOptions[0][0],$CfgOptions[0][1]) ;Create Excel Datasource
;I'd like the line below to work
ConfigDS($CfgOptions[4][0],$CfgOptions[4][1]) ;Create FoxPro Datasource

;ODBCSample() ;Execute ODBC API sample
EndFunc

GetAll()
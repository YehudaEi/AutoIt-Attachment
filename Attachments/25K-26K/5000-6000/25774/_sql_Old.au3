
		   

; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1 (beta)
; Language:       English
; Description:    Functions to handle SQL databases.
; Author Chris Lambert
; ------------------------------------------------------------------------------


#include-once

Global $sqlLastConnection ;enables the use of -1 to access the last opened connection
Global $SQLErr
Global $MSSQLObjErr 



Func _SQLRegisterErrorHandler($Func = "_SQLErrFunc")
	If ObjEvent("AutoIt.Error") = "" Then $MSSQLObjErr = ObjEvent("AutoIt.Error",$Func)
EndFunc


Func _SQLUnRegisterErrorHandler()
	$MSSQLObjErr = ""
EndFunc


Func _SQLStartup()
	
	DIM $SQLErr
	$adCN = ObjCreate ("ADODB.Connection") ;<==Create SQL connection
	If IsObj($adCN) then 
		$sqlLastConnection = $adCN
		Return $adCN
	Else
		Return SetError(1,0,0)
	EndIf
	
EndFunc

Func _JetConnect($ConHandle,$sFilePath1)
	DIM $SQLErr
	If $ConHandle = -1 then $ConHandle = $sqlLastConnection
	$ConHandle.Open ("Provider=Microsoft.Jet.OLEDB.4.0;" & _
                "Data Source="&$sFilePath1&";")
	If NOT @error then return 1
	Return SetError(1,0,0)
	
EndFunc

Func _AccessConnect($ConHandle,$sFilePath1)
	DIM $SQLErr
	If $ConHandle = -1 then $ConHandle = $sqlLastConnection
	$ConHandle.Open ("Driver={Microsoft Access Driver (*.mdb)};Dbq="&$sFilePath1&";")
	If NOT @error then return 1
	Return SetError(1,0,0)
	
EndFunc


Func _SQLConnect($ConHandle,$server, $db, $username, $password)
	
	DIM $SQLErr
	If $ConHandle = -1 then $ConHandle = $sqlLastConnection
	$ConHandle.Open ("DRIVER={SQL Server};SERVER=" & $server & ";DATABASE=" & $db & ";uid=" & $username & ";pwd=" & $password & ";") ;<==Connect with required credentials
	If NOT @error then return 1
	Return SetError(1,0,0)
	
EndFunc

Func _SQLClose ($ConHandle = -1)
	
	If $ConHandle = -1 then $ConHandle = $sqlLastConnection
	$ConHandle.Close 

EndFunc

Func _SQLExecute( $ConHandle = -1,$query = "" )
	
	Dim $SQLErr
	Local $ret
	
	If $ConHandle = -1 then $ConHandle = $sqlLastConnection
	$ret = $ConHandle.Execute ( $query )
	
	If @error then Return SetError(1,0,0)
	Return $ret
EndFunc

Func _SQLGetDataAsString( $objquery, $ReturnColumnNames = 1, $delim= "|")
	
	If Not IsObj($objquery) then 
		$SQLErr = "Data passed is an invalid object"
		Return SetError(1,0,0)
	EndIf
	
	Dim $ret
	Local $i
	With $objquery
			If $ReturnColumnNames then 
				For $i = 0 To .Fields.Count - 1 ;get the column names and put into 0 array element
					$ret&= .Fields($i).Name & $delim
				Next
				If StringRight($ret,1) = $delim then $ret = StringTrimRight($ret,1) 
				$ret &= @crlf
			EndIf
		
			While NOT .EOF
				For $i = 0 To .Fields.Count - 1
					$ret &= .Fields($i).Value & $delim
				Next
				If StringRight($ret,1) = $delim then $ret = StringTrimRight($ret,1) 
				$ret &= @crlf
			.MoveNext; Move to next row
			WEnd
	EndWith
		Return $ret
EndFunc

Func _SQLGetData2D($objquery, $ReturnColumnNames =1)
	
	If Not IsObj($objquery) then 
		$SQLErr = "Data passed is an invalid object"
		Return SetError(1,0,0)
	EndIf
	
	If $objquery.eof then 
		$SQLErr = "Query has no data"
		Return SetError(1,0,0)
	EndIf
		
	Dim $ret
	DIM $SQLErr
	Local $i, $aTmp
		
	With $objquery
		

		
			$ret = .GetRows()
		
			If IsArray($ret) then 
				$Dims = Ubound($ret,2)
				$Rows = Ubound($ret) 
				
				If $ReturnColumnNames then 
				
					Redim $ret[$Rows + 1][$Dims];Adjust the array to fit the column names and move all data down 1 row
			
					For $x = $Rows to 1 Step -1
						For $y = 0 to $Dims -1
							$ret[$x][$y] = $ret[$x-1][$y]
						Next
					Next
					;Add the coloumn names
					For $i = 0 To $Dims - 1 ;get the column names and put into 0 array element
						$ret[0][$i] = .Fields($i).Name
					Next
				EndIf;$ReturnColumnNames
			Else
				SetError(2)
				$SQLErr = "Unable to retreive data"
			EndIf;IsArray()
			
;Old method not used anymore but left in commented out until the new method is proven to have no issues			
		;While NOT .EOF
		;	ReDim $ret[UBound($ret, 1) + 1][Ubound($ret,2)]; get each row of data
		;		For $i = 0 To .Fields.Count - 1
		;			$ret[UBound($ret, 1) - 1][$i] = .Fields($i).Value
		;		Next
		;.MoveNext; Move to next row
		;WEnd
	EndWith
		Return $ret
EndFunc
	

;custom error handler 
Func _SQLErrFunc() 
	$HexNumber=hex($MSSQLObjErr.number,8)
	$SQLErr = "err.description is: "    & @TAB & $MSSQLObjErr.description     & @CRLF & _
             "err.windescription:"     & @TAB & $MSSQLObjErr.windescription & @CRLF & _
             "err.number is: "         & @TAB & $HexNumber              & @CRLF & _
             "err.lastdllerror is: "   & @TAB & $MSSQLObjErr.lastdllerror   & @CRLF & _
             "err.scriptline is: "     & @TAB & $MSSQLObjErr.scriptline     & @CRLF & _
             "err.source is: "         & @TAB & $MSSQLObjErr.source         & @CRLF & _
             "err.helpfile is: "       & @TAB & $MSSQLObjErr.helpfile       & @CRLF & _
             "err.helpcontext is: "    & @TAB & $MSSQLObjErr.helpcontext 
	SetError(1) 
	ConsoleWrite($SQLErr & @crlf)
Endfunc


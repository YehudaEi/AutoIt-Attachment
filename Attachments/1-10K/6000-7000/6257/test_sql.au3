;Test mysql

#include <GUIConstants.au3>
#include <Constants.au3>

;change here the path to mysql.exe
CONST $path_mysql = "D:\Denis\wamp\mysql\bin\"
dim $tableau_result

$line = ""	;don't modify this, it's just for variable initialisation

;we create our database request (don't miss the ; a the end of each command)
$sql = "use pictures;" & @CRLF			;mysql = select the database to use
$sql = $sql & "select * from girls;"	;mysql = request in the base from the girls table

;launch function to create the file
_create_mysql_command_file($sql)

; change 'root' by the mysql admin login
; if you have a password, you need to add it with -p parameter, ie :     mysql.exe -u YOURLOGIN -p YOURPASSWORD -X < 
;
$command_sql = $path_mysql & "mysql.exe -u root -X < " & $path_mysql & "sql_command.txt"			; create the  mysql process
$command = Run(@ComSpec & " /c " & $command_sql, @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)	; execute the  mysql process

While 1	; get the result returned by mysql.exe command
    $string_result = $line
	$line = StdoutRead($command)
    If @error = -1 Then ExitLoop
    ;MsgBox(0, "STDOUT read:", $line) ; display the entire returned result (if you want debug)
Wend

$tableau_result = _clean_mysql_return($string_result)	; clean and organize the result

for $boucle = 1 to $tableau_result[0]		;display the result of therequest
	$reponse = $tableau_result[$boucle]		; each result in in the 
	MsgBox(262144,'MySQL Result','Value : ' & @lf & $reponse)
Next

;***************************************************** FUNCTION DECLARATION ***********************************************************

func _clean_mysql_return($string_result)
	; we will clean the XML format result
	
	$string_result = StringReplace($string_result,"<row>","")			; delete all <row>
	$string_result = StringReplace($string_result,"</row>","")			; delete all </row>
	$string_result = StringReplace($string_result,"<field name=","")	; delete all <field name=>
	$string_result = StringReplace($string_result,"</field>","")		; delete all </field>
	$string_result = StringReplace($string_result,"</resultset>","")	; delete all </resultset>
	$string_result = StringReplace($string_result,">"," = ")			; change all > in =
		
	$string_search = chr(34) & "id" & chr(34) ; = "id"		
	
	$position_caracter_id = StringInStr($string_result,$string_search)	; search the position of the first "id" in the string result
	$string_result = StringRight($string_result,StringLen($string_result) - $position_caracter_id + 1) ; delete all that is before the first "id"=
	$string_result = StringStripCR($string_result)						; delete all CR
	$string_result = StringStripWS($string_result,4)					; delete all useless space
	$string_result = StringReplace($string_result,chr(34),"")			; delete all "
	
	$tableau_result = StringSplit($string_result,@CRLF)
	
	$tableau_result[0] = $tableau_result[0]-1 							; delete the last element because is empty
	
	return($tableau_result)
EndFunc

func _create_mysql_command_file($string)
	$file = FileOpen($path_mysql & "sql_command.txt", 2) ;2 = Write mode (erase previous contents)
	FileWrite($file,$string)	; we write the command in the file
	FileClose($file)
EndFunc
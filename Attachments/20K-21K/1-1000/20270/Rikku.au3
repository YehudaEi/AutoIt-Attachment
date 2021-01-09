#include <GUIConstants.au3>
;~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
GUICreate("Rikku",400,230)
;~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
GUICtrlCreateEdit("Type English Here",0,0,200,200)
GUICtrlCreateEdit("Type Al Bhed Here",200,0,200,200)
;~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$AlBhedButton=GUICtrlCreateButton("Translate to Al Bhed",0,200,200,30)
$EnglishButton=GUICtrlCreateButton("Translate to English",200,200,200,30)
WinMove ("Rikku","",0,0)
;~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
GUISetState()
;~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
While 1
    $msg = GUIGetMsg()
    Select
;~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        Case $msg = $GUI_EVENT_CLOSE
            ExitLoop
;~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        Case $msg=$EnglishButton
				BlockInput(1)
				GUICtrlSetData(3,"")
				$read=GUICtrlRead(4,1)
				StringLower($read)
				$length=StringLen($read) 
				$eng=1
				WinMove ("Rikku","",0,0)
				MouseClick ("left",5,31,1,0)
					Do
						$letter=StringMid ($read,$eng,1)
						If $letter = "a" Then
						$key=StringReplace ($letter,"a","e")
						EndIf
						If $letter = "b" Then
						$key=StringReplace ($letter,"b","p")
						EndIf
						If $letter = "c" Then
						$key=StringReplace ($letter,"c","s")
						EndIf
						If $letter = "d" Then
						$key=StringReplace ($letter,"d","t")
						EndIf
						If $letter = "e" Then
						$key=StringReplace ($letter,"e","i")
						EndIf
						If $letter = "f" Then
						$key=StringReplace ($letter,"f","w")
						EndIf
						If $letter = "g" Then
						$key=StringReplace ($letter,"g","k")
						EndIf
						If $letter = "h" Then
						$key=StringReplace ($letter,"h","n")
						EndIf
						If $letter = "i" Then
						$key=StringReplace ($letter,"i","u")
						EndIf
						If $letter = "j" Then
						$key=StringReplace ($letter,"j","v")
						EndIf
						If $letter = "k" Then
						$key=StringReplace ($letter,"k","g")
						EndIf
						If $letter = "l" Then
						$key=StringReplace ($letter,"l","c")
						EndIf
						If $letter = "m" Then
						$key=StringReplace ($letter,"m","l")
						EndIf
						If $letter = "n" Then
						$key=StringReplace ($letter,"n","r")
						EndIf
						If $letter = "o" Then
						$key=StringReplace ($letter,"o","y")
						EndIf
						If $letter = "p" Then
						$key=StringReplace ($letter,"p","b")
						EndIf
						If $letter = "q" Then
						$key=StringReplace ($letter,"q","x")
						EndIf
						If $letter = "r" Then
						$key=StringReplace ($letter,"r","h")
						EndIf
						If $letter = "s" Then
						$key=StringReplace ($letter,"s","m")
						EndIf
						If $letter = "t" Then
						$key=StringReplace ($letter,"t","d")
						EndIf
						If $letter = "u" Then
						$key=StringReplace ($letter,"u","o")
						EndIf
						If $letter = "v" Then
						$key=StringReplace ($letter,"v","f")
						EndIf
						If $letter = "w" Then
						$key=StringReplace ($letter,"w","z")
						EndIf
						If $letter = "x" Then
						$key=StringReplace ($letter,"x","q")
						EndIf
						If $letter = "y" Then
						$key=StringReplace ($letter,"y","a")
						EndIf
						If $letter = "z" Then
						$key=StringReplace ($letter,"z","j")
						EndIf
						If $letter = " " Then
						$key=StringReplace ($letter," "," ")
						EndIf
						If $letter = "0" Then
						$key=StringReplace ($letter,"0","0")
						EndIf
						If $letter = "1" Then
						$key=StringReplace ($letter,"1","1")
						EndIf
						If $letter = "2" Then
						$key=StringReplace ($letter,"2","2")
						EndIf
						If $letter = "3" Then
						$key=StringReplace ($letter,"3","3")
						EndIf
						If $letter = "4" Then
						$key=StringReplace ($letter,"4","4")
						EndIf
						If $letter = "5" Then
						$key=StringReplace ($letter,"5","5")
						EndIf
						If $letter = "6" Then
						$key=StringReplace ($letter,"6","6")
						EndIf
						If $letter = "7" Then
						$key=StringReplace ($letter,"7","7")
						EndIf
						If $letter = "8" Then
						$key=StringReplace ($letter,"8","8")
						EndIf
						If $letter = "9" Then
						$key=StringReplace ($letter,"9","9")
						EndIf
						If $letter = "." Then
						$key=StringReplace ($letter,".",".")
						EndIf
						If $letter = "?" Then
						$key=StringReplace ($letter,"?","?")
						EndIf
						If $letter = ";" Then
						$key=StringReplace ($letter,";",";")
						EndIf
						If $letter = ":" Then
						$key=StringReplace ($letter,":",":")
						EndIf
						If $letter = "'" Then
						$key=StringReplace ($letter,"'","'")
						EndIf
						If $letter = "[" Then
						$key=StringReplace ($letter,"[","[")
						EndIf
						If $letter = "{" Then
						$key=StringReplace ($letter,"{","{")
						EndIf
						If $letter = "]" Then
						$key=StringReplace ($letter,"]","]")
						EndIf
						If $letter = "}" Then
						$key=StringReplace ($letter,"}","}")
						EndIf
						If $letter = "#" Then
						$key=StringReplace ($letter,"#",("{#}"))
						EndIf
						If $letter = "$" Then
						$key=StringReplace ($letter,"$","$")
						EndIf
						If $letter = "%" Then
						$key=StringReplace ($letter,"%","%")
						EndIf
						If $letter = "&" Then
						$key=StringReplace ($letter,"&","&")
						EndIf
						If $letter = "*" Then
						$key=StringReplace ($letter,"*","*")
						EndIf
						If $letter = "(" Then
						$key=StringReplace ($letter,"(","(")
						EndIf
						If $letter = ")" Then
						$key=StringReplace ($letter,")",")")
						EndIf
						If $letter = "_" Then
						$key=StringReplace ($letter,"_","_")
						EndIf
						If $letter = "-" Then
						$key=StringReplace ($letter,"-","-")
						EndIf
						If $letter = "=" Then
						$key=StringReplace ($letter,"=","=")
						EndIf
						If $letter = "/" Then
						$key=StringReplace ($letter,"/","/")
						EndIf
						If $letter = "," Then
						$key=StringReplace ($letter,",",",")
						EndIf
						If $letter = "<" Then
						$key=StringReplace ($letter,"<","<")
						EndIf
						If $letter = ">" Then
						$key=StringReplace ($letter,">",">")
						EndIf
						If $letter = "\" Then
						$key=StringReplace ($letter,"\","\")
						EndIf
						If $letter = "|" Then
						$key=StringReplace ($letter,"|","|")
						EndIf
						If $letter = "`" Then
						$key=StringReplace ($letter,"`","`")
						EndIf
						If $letter = "~" Then
						$key=StringReplace ($letter,"~","~")
						EndIf
						If $letter = "!" Then
						$key=StringReplace ($letter,"!",("{!}"))
						EndIf
						If $letter = "@" Then
						$key=StringReplace ($letter,"@",("{@}"))
						EndIf
						If $letter = "^" Then
						$key=StringReplace ($letter,"^",("{^}"))
						EndIf
						If $letter = "+" Then
						$key=StringReplace ($letter,"+",("{+}"))
						EndIf
						If $letter = "" Then
						$key=StringReplace ($letter,"","")
						EndIf
						
						send($key)
						$eng=$eng+1
					Until $eng=$length+1
					$key=GUICtrlRead(4,1)
					$value=GUICtrlRead(3,1)
					IniWrite ("Al Bhed To English.ini",@MON & "/" & @MDAY & "/" & @YEAR & " " & @HOUR & ":" & @MIN & ":"& @SEC, $key, $value )
					BlockInput(0)
;~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Case $msg=$AlBhedButton
				BlockInput(1)
				GUICtrlSetData(4,"")
				$read=GUICtrlRead(3,1)
				StringLower($read)
				$length=StringLen($read) 
				$eng=1
				WinMove ("Rikku","",0,0)
				MouseClick ("left",205,31,1,0)
					Do								
						$letter=StringMid ($read,$eng,1)
						If $letter = "a" Then
						$key=StringReplace ($letter,"a","y")
						EndIf
						If $letter = "b" Then
						$key=StringReplace ($letter,"b","p")
						EndIf
						If $letter = "c" Then
						$key=StringReplace ($letter,"c","l")
						EndIf
						If $letter = "d" Then
						$key=StringReplace ($letter,"d","t")
						EndIf
						If $letter = "e" Then
						$key=StringReplace ($letter,"e","a")
						EndIf
						If $letter = "f" Then
						$key=StringReplace ($letter,"f","v")
						EndIf
						If $letter = "g" Then
						$key=StringReplace ($letter,"g","k")
						EndIf
						If $letter = "h" Then
						$key=StringReplace ($letter,"h","r")
						EndIf
						If $letter = "i" Then
						$key=StringReplace ($letter,"i","e")
						EndIf
						If $letter = "j" Then
						$key=StringReplace ($letter,"j","z")
						EndIf
						If $letter = "k" Then
						$key=StringReplace ($letter,"k","g")
						EndIf
						If $letter = "l" Then
						$key=StringReplace ($letter,"l","m")
						EndIf
						If $letter = "m" Then
						$key=StringReplace ($letter,"m","s")
						EndIf
						If $letter = "n" Then
						$key=StringReplace ($letter,"n","h")
						EndIf
						If $letter = "o" Then
						$key=StringReplace ($letter,"o","u")
						EndIf
						If $letter = "p" Then
						$key=StringReplace ($letter,"p","b")
						EndIf
						If $letter = "q" Then
						$key=StringReplace ($letter,"q","x")
						EndIf
						If $letter = "r" Then
						$key=StringReplace ($letter,"r","n")
						EndIf
						If $letter = "s" Then
						$key=StringReplace ($letter,"s","c")
						EndIf
						If $letter = "t" Then
						$key=StringReplace ($letter,"t","d")
						EndIf
						If $letter = "u" Then
						$key=StringReplace ($letter,"u","i")
						EndIf
						If $letter = "v" Then
						$key=StringReplace ($letter,"v","j")
						EndIf
						If $letter = "w" Then
						$key=StringReplace ($letter,"w","f")
						EndIf
						If $letter = "x" Then
						$key=StringReplace ($letter,"x","q")
						EndIf
						If $letter = "y" Then
						$key=StringReplace ($letter,"y","o")
						EndIf
						If $letter = "z" Then
						$key=StringReplace ($letter,"z","w")
						EndIf		
						If $letter = " " Then
						$key=StringReplace ($letter," "," ")
						EndIf		
						If $letter = "0" Then
						$key=StringReplace ($letter,"0","0")
						EndIf
						If $letter = "1" Then
						$key=StringReplace ($letter,"1","1")
						EndIf
						If $letter = "2" Then
						$key=StringReplace ($letter,"2","2")
						EndIf
						If $letter = "3" Then
						$key=StringReplace ($letter,"3","3")
						EndIf
						If $letter = "4" Then
						$key=StringReplace ($letter,"4","4")
						EndIf
						If $letter = "5" Then
						$key=StringReplace ($letter,"5","5")
						EndIf
						If $letter = "6" Then
						$key=StringReplace ($letter,"6","6")
						EndIf
						If $letter = "7" Then
						$key=StringReplace ($letter,"7","7")
						EndIf
						If $letter = "8" Then
						$key=StringReplace ($letter,"8","8")
						EndIf
						If $letter = "9" Then
						$key=StringReplace ($letter,"9","9")
						EndIf
						If $letter = "." Then
						$key=StringReplace ($letter,".",".")
						EndIf
						If $letter = "?" Then
						$key=StringReplace ($letter,"?","?")
						EndIf
						If $letter = ";" Then
						$key=StringReplace ($letter,";",";")
						EndIf
						If $letter = ":" Then
						$key=StringReplace ($letter,":",":")
						EndIf
						If $letter = "'" Then
						$key=StringReplace ($letter,"'","'")
						EndIf
						If $letter = "[" Then
						$key=StringReplace ($letter,"[","[")
						EndIf
						If $letter = "{" Then
						$key=StringReplace ($letter,"{","{")
						EndIf
						If $letter = "]" Then
						$key=StringReplace ($letter,"]","]")
						EndIf
						If $letter = "}" Then
						$key=StringReplace ($letter,"}","}")
						EndIf
						If $letter = "#" Then
						$key=StringReplace ($letter,"#",("{#}"))
						EndIf
						If $letter = "$" Then
						$key=StringReplace ($letter,"$","$")
						EndIf
						If $letter = "%" Then
						$key=StringReplace ($letter,"%","%")
						EndIf
						If $letter = "&" Then
						$key=StringReplace ($letter,"&","&")
						EndIf
						If $letter = "*" Then
						$key=StringReplace ($letter,"*","*")
						EndIf
						If $letter = "(" Then
						$key=StringReplace ($letter,"(","(")
						EndIf
						If $letter = ")" Then
						$key=StringReplace ($letter,")",")")
						EndIf
						If $letter = "_" Then
						$key=StringReplace ($letter,"_","_")
						EndIf
						If $letter = "-" Then
						$key=StringReplace ($letter,"-","-")
						EndIf
						If $letter = "=" Then
						$key=StringReplace ($letter,"=","=")
						EndIf
						If $letter = "/" Then
						$key=StringReplace ($letter,"/","/")
						EndIf
						If $letter = "," Then
						$key=StringReplace ($letter,",",",")
						EndIf
						If $letter = "<" Then
						$key=StringReplace ($letter,"<","<")
						EndIf
						If $letter = ">" Then
						$key=StringReplace ($letter,">",">")
						EndIf
						If $letter = "\" Then
						$key=StringReplace ($letter,"\","\")
						EndIf
						If $letter = "|" Then
						$key=StringReplace ($letter,"|","|")
						EndIf
						If $letter = "`" Then
						$key=StringReplace ($letter,"`","`")
						EndIf
						If $letter = "~" Then
						$key=StringReplace ($letter,"~","~")
						EndIf
						send($key)
						$eng=$eng+1
					Until $eng=$length+1
					$key=GUICtrlRead(3,1)
					$value=GUICtrlRead(4,1)
					IniWrite ("English to Al Bhed.ini",@MON & "/" & @MDAY & "/" & @YEAR & " " & @HOUR & ":" & @MIN & ":"& @SEC, $key, $value )
					BlockInput(0)
;~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    EndSelect
Wend
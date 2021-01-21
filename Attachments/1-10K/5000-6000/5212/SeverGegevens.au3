Func Instellinge()

#include <array.au3>
#include <string.au3>
#include <GUIConstants.au3>

$PoortCheck1 			= IniRead("POWRPOST.ini", "settings", "NNTP_Port", "NotFound")
$ServerAdressCheck1 	= IniRead("POWRPOST.ini", "settings", "Server", "NotFound")
$GebruikersnaamCheck1 	= IniRead("POWRPOST.ini", "settings", "User", "NotFound")
$WachtwoordCheck1		= IniRead("POWRPOST.ini", "My Own", "Pass", "NotFound")
$Login 					= IniRead("POWRPOST.ini", "settings", "Login", "NotFound")


GUICreate ( "title" , 450 , 175 )  
GUICtrlCreateLabel ( "Server Adres:", 10, 17 )
$ServerAdress = GUICtrlCreateInput($ServerAdressCheck1, 110,  15, 325, 20)

GUICtrlCreateLabel ( "Poort:", 10, 42 )
$Poort = GUICtrlCreateInput($PoortCheck1, 110, 40, 100, 20)

GUICtrlCreateLabel ( "Gebruikersnaam:", 10, 67 )
$Gebruikersnaam = GUICtrlCreateInput($GebruikersnaamCheck1, 110, 65, 100, 20)
GUICtrlSetState(-1,$GUI_DISABLE)

GUICtrlCreateLabel ( "Wachtwoord:", 10, 92 )
$Wachtwoord = GUICtrlCreateInput($WachtwoordCheck1, 110, 90, 100, 20, $ES_PASSWORD)
GUICtrlSetState(-1,$GUI_DISABLE)

$LoginVereist = GUICtrlCreateCheckbox ("Server vereist login", 215, 35, 120, 20)

$Start = GUICtrlCreateButton ("Opslaan",  60, 120, 50)
$Cancel = GUICtrlCreateButton ("Cancel",  115, 120, 50)

If $Login = 0 Then
	GUICtrlSetState($LoginVereist, $GUI_UNCHECKED)
	GUICtrlSetState($Wachtwoord,$GUI_DISABLE)
    GUICtrlSetState($Gebruikersnaam,$GUI_DISABLE)
Else
	GUICtrlSetState($LoginVereist, $GUI_CHECKED)
    GUICtrlSetState($Wachtwoord,$GUI_ENABLE)
    GUICtrlSetState($Gebruikersnaam,$GUI_ENABLE)
EndIF

GUISetState (@SW_SHOW)


DIM $LETTERS[96]
$LETTERS[0] = "a"
$LETTERS[1] = "b"
$LETTERS[2] = "c"
$LETTERS[3] = "d"
$LETTERS[4] = "e"
$LETTERS[5] = "f"
$LETTERS[6] = "g"
$LETTERS[7] = "h"
$LETTERS[8] = "i"
$LETTERS[9] = "j"
$LETTERS[10] = "k"
$LETTERS[11] = "l"
$LETTERS[12] = "m"
$LETTERS[13] = "n"
$LETTERS[14] = "o"
$LETTERS[15] = "p"
$LETTERS[16] = "q"
$LETTERS[17] = "r"
$LETTERS[18] = "s"
$LETTERS[19] = "t"
$LETTERS[20] = "u"
$LETTERS[21] = "v"
$LETTERS[22] = "w"
$LETTERS[23] = "x"
$LETTERS[24] = "y"
$LETTERS[25] = "z"
$LETTERS[26] = "A"
$LETTERS[27] = "B"
$LETTERS[28] = "C"
$LETTERS[29] = "D"
$LETTERS[30] = "E"
$LETTERS[31] = "F"
$LETTERS[32] = "G"
$LETTERS[33] = "H"
$LETTERS[34] = "I"
$LETTERS[35] = "J"
$LETTERS[36] = "K"
$LETTERS[37] = "L"
$LETTERS[38] = "M"
$LETTERS[39] = "N"
$LETTERS[40] = "O"
$LETTERS[41] = "P"
$LETTERS[42] = "Q"
$LETTERS[43] = "R"
$LETTERS[44] = "S"
$LETTERS[45] = "T"
$LETTERS[46] = "U"
$LETTERS[47] = "V"
$LETTERS[48] = "W"
$LETTERS[49] = "X"
$LETTERS[50] = "Y"
$LETTERS[51] = "Z"
$LETTERS[52] = "!"
$LETTERS[53] = "@"
$LETTERS[54] = "#"
$LETTERS[55] = "$"
$LETTERS[56] = "%"
$LETTERS[57] = "^"
$LETTERS[58] = "&"
$LETTERS[59] = "*"
$LETTERS[60] = "("
$LETTERS[61] = ")"
$LETTERS[62] = "~"
$LETTERS[63] = "`"
$LETTERS[64] = "_"
$LETTERS[65] = "-"
$LETTERS[66] = "+"
$LETTERS[67] = "="
$LETTERS[68] = "{"
$LETTERS[69] = "["
$LETTERS[70] = "}"
$LETTERS[71] = "]"
$LETTERS[72] = ":"
$LETTERS[73] = ";"
$LETTERS[74] = chr(34)
$LETTERS[75] = "'"
$LETTERS[76] = "\"
$LETTERS[77] = "|"
$LETTERS[78] = "<"
$LETTERS[79] = ","
$LETTERS[80] = ">"
$LETTERS[81] = "."
$LETTERS[82] = "?"
$LETTERS[83] = "/"
$LETTERS[84] = "*"
$LETTERS[85] = "1"
$LETTERS[86] = "2"
$LETTERS[87] = "3"
$LETTERS[88] = "4"
$LETTERS[89] = "5"
$LETTERS[90] = "6"
$LETTERS[91] = "7"
$LETTERS[92] = "8"
$LETTERS[93] = "9"
$LETTERS[94] = "0"
$LETTERS[95] = chr(32)

$END_RESULT = ""

While 1
    $msg = GUIGetMsg()
   	Select
   	    Case $MSG = $GUI_EVENT_CLOSE
    		Exit
   		
    	Case $MSG = $Cancel
    		Exit
    			
    	Case $msg = $LoginVereist
    		If GUICtrlRead($LoginVereist) = $GUI_CHECKED  Then
    			GUICtrlSetState($Wachtwoord,$GUI_ENABLE)
    			GUICtrlSetState($Gebruikersnaam,$GUI_ENABLE)
    		ElseIf GUICtrlRead($LoginVereist) = $GUI_UNCHECKED  Then
    			GUICtrlSetState($Wachtwoord,$GUI_DISABLE)
    			GUICtrlSetState($Gebruikersnaam,$GUI_DISABLE)
    		EndIf
    			
    	Case $msg = $Start
   		$s_Result = GUICtrlRead($Wachtwoord)
   		For $x = 1 to StringLen($s_Result)
		    $i = StringMid($s_Result,$x,1)
    		$a = Asc ($i)
       	   If $a = 97 Then
            $a_i = $LETTERS[5]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 98 Then
            $a_i = $LETTERS[6]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 99 Then
            $a_i = $LETTERS[7]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 100 Then
            $a_i = $LETTERS[8]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 101 Then
            $a_i = $LETTERS[9]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 102 Then
            $a_i = $LETTERS[10]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 103 Then
            $a_i = $LETTERS[11]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 104 Then
            $a_i = $LETTERS[12]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 105 Then
            $a_i = $LETTERS[13]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 106 Then
            $a_i = $LETTERS[14]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 107 Then
            $a_i = $LETTERS[15]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 108 Then
            $a_i = $LETTERS[16]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 109 Then
            $a_i = $LETTERS[17]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 110 Then
            $a_i = $LETTERS[18]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 111 Then
            $a_i = $LETTERS[19]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 112 Then
            $a_i = $LETTERS[20]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 113 Then
            $a_i = $LETTERS[21]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 114 Then
            $a_i = $LETTERS[22]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 115 Then
            $a_i = $LETTERS[23]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 116 Then
            $a_i = $LETTERS[24]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 117 Then
            $a_i = $LETTERS[25]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 118 Then
            $a_i = $LETTERS[68]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 119 Then
            $a_i = $LETTERS[77]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 120 Then
            $a_i = $LETTERS[70]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 121 Then
            $a_i = $LETTERS[62]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 122 Then
            $a_i = $LETTERS[45]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 65 Then
            $a_i = $LETTERS[26]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 66 Then
            $a_i = $LETTERS[27]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 67 Then
            $a_i = $LETTERS[28]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 68 Then
            $a_i = $LETTERS[29]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 69 Then
            $a_i = $LETTERS[31]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 70 Then
            $a_i = $LETTERS[34]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 71 Then
            $a_i = $LETTERS[35]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 72 Then
            $a_i = $LETTERS[36]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 73 Then
            $a_i = $LETTERS[37]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 74 Then
            $a_i = $LETTERS[38]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 75 Then
            $a_i = $LETTERS[40]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 76 Then
            $a_i = $LETTERS[41]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 77 Then
            $a_i = $LETTERS[42]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 78 Then
            $a_i = $LETTERS[43]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 79 Then
            $a_i = $LETTERS[44]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 80 Then
            $a_i = $LETTERS[46]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 81 Then
            $a_i = $LETTERS[47]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 82 Then
            $a_i = $LETTERS[48]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 83 Then
            $a_i = $LETTERS[49]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 84 Then
            $a_i = $LETTERS[50]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 85 Then
            $a_i = $LETTERS[51]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 86 Then
            $a_i = $LETTERS[69]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 87 Then
            $a_i = $LETTERS[76]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 88 Then
            $a_i = $LETTERS[71]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 89 Then
            $a_i = $LETTERS[57]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 90 Then
            $a_i = $LETTERS[64]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 33 Then
            $a_i = $LETTERS[52]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 64 Then
            $a_i = $LETTERS[53]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 35 Then
            $a_i = $LETTERS[54]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 36 Then
            $a_i = $LETTERS[55]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 37 Then
            $a_i = $LETTERS[56]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 94 Then
            $a_i = $LETTERS[57]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 38 Then
            $a_i = $LETTERS[58]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 42 Then
            $a_i = $LETTERS[59]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 40 Then
            $a_i = $LETTERS[60]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 41 Then
            $a_i = $LETTERS[61]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 126 Then
            $a_i = $LETTERS[32]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 96 Then
            $a_i = $LETTERS[4]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 95 Then
            $a_i = $LETTERS[3]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 45 Then
            $a_i = $LETTERS[65]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 43 Then
            $a_i = $LETTERS[66]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 61 Then
            $a_i = $LETTERS[67]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 123 Then
            $a_i = $LETTERS[39]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 91 Then
            $a_i = $LETTERS[63]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 125 Then
            $a_i = $LETTERS[33]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 93 Then
            $a_i = $LETTERS[1]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 58 Then
            $a_i = $LETTERS[72]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 59 Then
            $a_i = $LETTERS[73]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 96 Then
            $a_i = $LETTERS[75]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 92 Then
            $a_i = $LETTERS[0]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 124 Then
            $a_i = $LETTERS[30]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 60 Then
            $a_i = $LETTERS[78]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 44 Then
            $a_i = $LETTERS[79]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 62 Then
            $a_i = $LETTERS[80]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 46 Then
            $a_i = $LETTERS[81]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 63 Then
            $a_i = $LETTERS[82]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 47 Then
            $a_i = $LETTERS[83]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 42 Then
            $a_i = $LETTERS[84]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 49 Then
            $a_i = $LETTERS[85]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 50 Then
            $a_i = $LETTERS[86]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 51 Then
            $a_i = $LETTERS[87]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 52 Then
            $a_i = $LETTERS[88]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 53 Then
            $a_i = $LETTERS[89]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 54 Then
            $a_i = $LETTERS[90]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 55 Then
            $a_i = $LETTERS[91]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 56 Then
            $a_i = $LETTERS[92]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 57 Then
            $a_i = $LETTERS[93]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 48 Then
            $a_i = $LETTERS[94]
            $END_RESULT = $END_RESULT & $a_i
       ElseIf $a = 32 Then
            $a_i = $LETTERS[95]
            $END_RESULT = $END_RESULT & $a_i
       EndIf
	Next

   			IniWrite ( "POWRPOST.ini", "My Own", "Pass", GUICtrlRead($Wachtwoord))
			IniWrite ( "POWRPOST.ini", "settings", "NNTP_Port", GUICtrlRead($Poort))
   			IniWrite ( "POWRPOST.ini", "settings", "Server", GUICtrlRead($ServerAdress))
   			IniWrite ( "POWRPOST.ini", "settings", "User", GUICtrlRead($Gebruikersnaam))
			IniWrite ( "POWRPOST.ini", "settings", "Pass", $END_RESULT)
   			IniWrite ( "POWRPOST.ini", "Server0", "NNTP_Port", GUICtrlRead($Poort))
   			IniWrite ( "POWRPOST.ini", "Server0", "Server", GUICtrlRead($ServerAdress))
   			IniWrite ( "POWRPOST.ini", "Server0", "User", GUICtrlRead($Gebruikersnaam))
			IniWrite ( "POWRPOST.ini", "Server0", "Pass", $END_RESULT)

			If GUICtrlRead($LoginVereist) = 1 then
				IniWrite ( "POWRPOST.ini", "settings", "Login", GUICtrlRead($LoginVereist))
				IniWrite ( "POWRPOST.ini", "Server0", "Login", GUICtrlRead($LoginVereist))
			Else
				IniWrite ( "POWRPOST.ini", "settings", "Login", "0")
				IniWrite ( "POWRPOST.ini", "Server0", "Login", "0")
			EndIf
			   			
			$END_RESULT = ""
			
			Exit
   	EndSelect
Wend
EndFunc
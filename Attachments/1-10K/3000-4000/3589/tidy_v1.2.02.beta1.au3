;
; Nom du logiciel : 			Tidy.exe											- Non-officiel		07/2005
; langue :						Français											- Non-officiel		07/2005
; Compatibilité : 				W2K / WXP											- Officiel			01/2005
; Auteur :         				Jos VAN DER ZANDE									- Officiel			01/2005
;
; Version : 					v1.2.02.beta1										- Non-officiel		07/2005
; 								v1.28.2												- Officiel 			01/2005
; 
; Historique : 					v1.2.02.beta1										- Non-officiel		07/2005
; 									Diffusion restreinte pour correction de bug
; 								v1.2.202.rc1										- Non-officiel		07/2005
; 									Activation des ProgressOn
; 									Correction de la francisation
; 									Changement du GUI des options Tidy
; 									Apport de différents style
; 									Définition des infobulles
; 								v1.2.202.alpha										- Non-officiel		07/2005
; 									Correction de la francisation
; 								v1.2.201.alpha										- Non-officiel		07/2005
;									Francisation de l'interface par Xavier Brusselaers
; 									Suppression de commentaire
; 									Suppression des régions
; 									Remplacement de simple quote par guillemet
; 									Remplacement du Sheme Numbering
; 								v1.28.2												- Officiel 			01/2005
; 									Version initiale ??

; Style apporté
Global Const $WS_BORDER				= 0x00800000
Global Const $WS_POPUP				= 0x80000000
Global Const $BS_FLAT				= 0x8000

Global $Version = "v1.2.02.beta1"

; *** definitions
; if first run then prompt for settings
Global $HotKey = "{end}"
Global $HotKeyCfg = "{pause}"
Global $File               ; AutoIt3 Script filename
If Not FileExists(@ScriptDir & "\tidy.ini") Then Tidy_Config_Gui()
;
Global $TabChar = IniRead(@ScriptDir & "\tidy.ini", "ProgramSettings", "tabchar", 0)                 ; use x spaces for indentation ... 0=tabs
Global $Proper = IniRead(@ScriptDir & "\tidy.ini", "ProgramSettings", "proper", 1)                   ; update functions/keywords/macros to proper case
Global $Userfunc = IniRead(@ScriptDir & "\tidy.ini", "ProgramSettings", "userfunc", 1)               ; read update functions/keywords/macros to proper case
Global $Vars = IniRead(@ScriptDir & "\tidy.ini", "ProgramSettings", "vars", 3)                       ; update variables 0=unchanged, 1=uppercase, 2=lowercase, 3= as defined with Dim/Global/Local or else first occurrence
Global $Delim = IniRead(@ScriptDir & "\tidy.ini", "ProgramSettings", "Delim", 1)                     ; Add space around delimiters
Global $R_T_Spaces = IniRead(@ScriptDir & "\tidy.ini", "ProgramSettings", "Remove_TrailSpaces", 1)  ; Remove Trailing spaces
Global $EndFunc_Comment = IniRead(@ScriptDir & "\tidy.ini", "ProgramSettings", "endfunc_comment", 1) ; add a comment after endfunc like : endfunc  ;==> functionname
Global $Gen_Doc = IniRead(@ScriptDir & "\tidy.ini", "ProgramSettings", "gen_doc", 2)                 ; generates document.file with program logic and xref reports 0=no 1=yes 2=prompt
Global $Opt_Menu = IniRead(@ScriptDir & "\tidy.ini", "ProgramSettings", "startupmenu", 1)            ; show startup menu at program start with options
Global $T_HotKey = IniRead(@ScriptDir & "\tidy.ini", "ProgramSettings", "hotkey", "")                ; user defined hotkey to Stop Tidy
Global $T_HotKeyCfg = IniRead(@ScriptDir & "\tidy.ini", "ProgramSettings", "hotkeycfg", "")          ; user defined hotkey to Setup Tidy
Global $R_Empty_Lines = IniRead(@ScriptDir & "\tidy.ini", "ProgramSettings", "Remove_Empty_Lines", 0); Remove Empty lines
If $T_HotKey <> "" Then $HotKey = $T_HotKey
If $T_HotKeyCfg <> "" Then $HotKeyCfg = $T_HotKeyCfg
;
AutoItSetOption( "runerrorsfatal", 0)
; Suppression de l'icone de travail
; AutoItSetOption( "TrayIconDebug", 1)
#NoTrayIcon

HotKeySet($HotKey, "StopExec")
HotKeySet($HotKeyCfg, "Tidy_Config_Gui")
;break(0)
Dim $S_Lines[50][2]        ; Array to hold the continuation lines that form one script record
Dim $CaseLevel[50]         ; Array that hold the Case level for that particular indent level (used for Select statements)
Dim $IndentKeyword[50]     ; Array that hold the KeyWord For that particular indent level
Dim $Doc_Functions[1000][2]; Array of Function for Documentation purposes
Dim $Doc_Variables[2000][2]; Array of Variable for Documentation purposes
Global $BS_RC = 0
Global $Doc_F_Cnt = 0      ; Documentation Function Count
Global $Doc_V_Cnt = 0      ; Documentation Variable Count
Global $Functions          ; Search string with all Functions for Proper function
Global $Keywords           ; Search string with all Keywords for Proper function
Global $Macros             ; Search string with all Macros for Proper function
Global $VarsList = "|"     ; Search string with all Variables for Proper function
Global $Irec_Cnt           ; Inputfile record count
Global $Scriptrecs         ; All script records array
Global $Opt                ; Option selected on Startmenu
Global $Timer              ; Var to hold the start time to calculate run time
Global $ScriptOutRec = ""  ; String which contains the total Script Output records to be written in one go
Global $ScriptDocRec = ""  ; String which contains the total Doc Output to be written in one go
Global $Tidy_Errors = 0    ; Counter for number of errors encountered
Global $L_Chars = ""       ; Leading characters variable used for indent and docfile
; set the string to use for indentation
$TabChar = Int($TabChar)
If $TabChar > 0 Then
	$TabChar = StringLeft("                              ", $TabChar)
Else
	$TabChar = Chr(9)
EndIf
;
; ===============================
; get input and check output file
; ===============================
$File = ""
If $CMDLINE[0] = 1 Then
	$File = FileGetLongName($CMDLINE[1])
Else
	While Not FileExists($File) Or StringRight($File, 4) <> ".au3"
		$File = FileOpenDialog( "Quel fichier désirez-vous ordonner ?", "", "AutoIt3 (*.au3)", 1)
		If @error = 1 Then
			$RC = MsgBox(4100, "AutoIt3 Tidy", "Désirez-vous stopper le proccessus de mise en ordre ?")
			If $RC = 6 Then Exit
		EndIf
	WEnd
EndIf
; Exit with warning when input file is readonly
If StringInStr(FileGetAttrib($File), "R") Then
	$RC = MsgBox(16 + 262144, "Autoit3 Tidy", "Le fichier d'entrée est en lecture seule. Veuillez corriger l'accessibilité du fichier d'entrée et relancer Tidy.")
	Exit
EndIf
;
Dim $OFile = StringReplace($File, ".au3", "_x.au3")
If FileExists($OFile) Then FileRecycle($OFile)
; =======================================
; Display the Option menu when configured
; =======================================
If $Opt_Menu = 1 Then
	$Opt = Tidy_Startmenu_gui()
	Select
		Case $Opt = 1
			$Proper = 0
			$Gen_Doc = 0
		Case $Opt = 2
			$Proper = 1
			$Gen_Doc = 0
		Case $Opt = 3
			$Proper = 1
			$Gen_Doc = 1
	EndSelect
EndIf
;*****************************************************
; prompt for documentation generation
;*****************************************************
Dim $Doc_File = StringReplace($File, ".au3", "_tidy.txt")
If $Gen_Doc = 2 Then
	$RC = MsgBox(4100, "Tidy AutoIt Script de documentation ?", "Désirez-vous générer le fichier de documentation associé au fichier d'entrée ?" & @LF & $Doc_File)
	If $RC = 6 Then
		$Gen_Doc = 1
	Else
		$Gen_Doc = 0
	EndIf
EndIf
If $Gen_Doc = 1 Then
	FileRecycle($Doc_File)   ; remove old version
	Global $ScriptDocRec = ""
	$ScriptDocRec = $ScriptDocRec & "========================================================================================================" & @CRLF
	$ScriptDocRec = $ScriptDocRec & "=== Date : " & @YEAR & @MON & @MDAY & " " & @HOUR & ":" & @MIN & @CRLF & _
									"=== Rapport Tidy pour le fichier :" & $File & @CRLF
	$ScriptDocRec = $ScriptDocRec & "========================================================================================================" & @CRLF
	$ScriptDocRec = $ScriptDocRec & "" & @CRLF
	$ScriptDocRec = $ScriptDocRec & "" & @CRLF
EndIf
;*************************************************************
; load the source into memoru=y and split it up into an array
;*************************************************************
ProgressOn("AutoIt3 Tidy(" & $Version & ")  " & $HotKey & "=> Stop  " & $HotKeyCfg & "=> Configurer", "Initialisation", "", -1, -1, 16)
; Rajouté par Xavier Brusselaers
WinActivate("AutoIt3 Tidy")

_FileRead2Array($File, $Scriptrecs)
;*****************************************************
; load tables
;*****************************************************
$Timer = TimerInit()
If $Proper = 1 Then
	ProgressOn("AutoIt3 Tidy(" & $Version & ")  " & $HotKey & "=> Stop  " & $HotKeyCfg & "=> Configurer", "Initialisation", "", -1, -1, 16)
	; Ajout par Xavier Brusselaers
	WinActivate("AutoIt3 Tidy")
	
	; resize progress window to fit the title
	$SZ = WinGetPos("AutoIt3 Tidy(")
	WinMove("AutoIt3 Tidy(", "", $SZ[0] - 75, $SZ[1], $SZ[2] + 150, $SZ[3])
	$SZ = ControlGetPos("AutoIt3 Tidy(", "", "msctls_progress321")
	ControlMove("AutoIt3 Tidy(", "", "msctls_progress321", $SZ[0], $SZ[1], $SZ[2] + 150, $SZ[3])
	; create copy of the functions file
	FileCopy(@ScriptDir & "\functions.txt", @TempDir & "\functions.txt", 1)
	If $Userfunc = 1 Then
		ProgressSet(5, "Chargement des tables")
		; add user functions to functions array
		If FileExists(@ScriptDir & "\userfunctions.txt") Then
			$IFile = FileOpen(@ScriptDir & "\userfunctions.txt", 0)
			While 1
				$I_REC = FileReadLine($IFile)
				If @error = -1 Then ExitLoop
				FileWriteLine(@TempDir & "\functions.txt", $I_REC)
				$Doc_F_Cnt = $Doc_F_Cnt + 1
				If $Gen_Doc = 1 Then
					$Doc_Functions[$Doc_F_Cnt][0] = $I_REC
					$Doc_Functions[$Doc_F_Cnt][1] = ""
				EndIf
			WEnd
			FileClose($IFile)
		EndIf
		; add FUNC functions from the script to functions array
		ProgressSet(10, "UDF et Variables trouvés")
		For $X = 1 To $Scriptrecs[0]
			$I_REC = $Scriptrecs[$X]
			ProgressSet($X / $Scriptrecs[0] * 90, "UDF et Variables trouvés dans script")
			$FWord = Get_Firstword($I_REC)
			If $FWord = "func" Then
				$FName = StringTrimLeft($I_REC, 5)
				$FName = StringStripWS(StringLeft($FName, StringInStr($FName, "(") - 1), 3)
				FileWriteLine(@TempDir & "\functions.txt", $FName)
				If $Gen_Doc = 1 Then
					$Doc_F_Cnt = $Doc_F_Cnt + 1
					$Doc_Functions[$Doc_F_Cnt][0] = $FName
					$Doc_Functions[$Doc_F_Cnt][1] = ""
				EndIf
			EndIf
			; build variable stringtable if option is to set the vars equal to the DIM/GLOBAL/LOCAL case
			If $Vars = 3 And StringInStr("|Dim|Global|Local|", "|" & $FWord & "|") Then
				$T_Varlist = StringStripWS($I_REC, 3)
				$T_Varlist = StringTrimLeft($T_Varlist, StringInStr($T_Varlist, " "))
				$T_Varlist = StringSplit($T_Varlist, ",")
				For $v = 1 To $T_Varlist[0]
					$T_Var = StringStripWS($T_Varlist[$v], 3)
					If StringLeft($T_Var, 1) = "$" Then
						$T_Var = StringSplit($T_Var, " ,=[")
						; add to the Var search string when its not there yet
						If Not StringInStr($VarsList, "|" & $T_Var & "|") Then $VarsList = $VarsList & $T_Var[1] & "|"
					EndIf
				Next
			EndIf
		Next
	EndIf
	ProgressSet(95, "Chargement Tables - functions/keywords/macros")
	; load functions table
	$IFile = FileOpen(@TempDir & "\functions.txt", 0)
	If $IFile = -1 Then
		ProgressOff()
		MsgBox(4100, "Erreur", "Impossible d'ouvrir functions.txt.")
		Exit
	EndIf
	FileClose($IFile)
	_FileRead2SearchString(@TempDir & "\functions.txt", $Functions)
	FileDelete(@TempDir & "\functions.txt")
	; load keywords table
	$IFile = FileOpen(@ScriptDir & "\keywords.txt", 0)
	If $IFile = -1 Then
		ProgressOff()
		MsgBox(4100, "Erreur", "Impossible d'ouvrir keywords.txt.")
		Exit
	EndIf
	_FileRead2SearchString(@ScriptDir & "\keywords.txt", $Keywords)
	FileClose($IFile)
	; load macros table
	$IFile = FileOpen(@ScriptDir & "\macros.txt", 0)
	If $IFile = -1 Then
		ProgressOff()
		MsgBox(4100, "Erreur", "Impossible d'ouvrir macros.txt.")
		Exit
	EndIf
	FileClose($IFile)
	_FileRead2SearchString(@ScriptDir & "\macros.txt", $Macros)
	; sort the tables
EndIf
;*****************************************************
; process the file
;*****************************************************
Dim $Tab_Level = 0         ; Current line tab level
Dim $N_Tab_Level = 0       ; Next line tab level
Dim $C_Tab_Level = 0       ; Case/Select tab level
Dim $P_Tab_Level = 0       ; Previous line tab level
Dim $Save_Func = ""        ; Save function name field to add to the EndFunc statement
Dim $IRec = 0              ; input record counter
Dim $LineC = ""            ; Current code line to process .. include all continuations and no end-of-line comments
Dim $Inside_Comment = 0    ; comment block indicator
Dim $FirstWord, $FirstWord_Test, $C_Lines, $Line, $Save_Line, $Last_Then
; process all records
ProgressOn("AutoIt3 Tidy(" & $Version & ")  " & $HotKey & "=> Stop  " & $HotKeyCfg & "=> Configuration", "Fichier:" & _
			StringLeft($File, 15) & "..." & StringRight($File, 20), "", -1, -1, 16)
; Rajouté par Xavier Brusselaers
WinActivate("AutoIt3 Tidy")

; resize progress window to fit the title
$SZ = WinGetPos("AutoIt3 Tidy(")
WinMove("AutoIt3 Tidy(", "", $SZ[0] - 75, $SZ[1], $SZ[2] + 150, $SZ[3])
$SZ = ControlGetPos("AutoIt3 Tidy(", "", "msctls_progress321")
ControlMove("AutoIt3 Tidy(", "", "msctls_progress321", $SZ[0], $SZ[1], $SZ[2] + 150, $SZ[3])
;
For $Irec_Cnt = 1 To $Scriptrecs[0]
	; showing progress
	ProgressSet($Irec_Cnt / $Scriptrecs[0] * 98, $Irec_Cnt & " ou " & $Scriptrecs[0] & " processus d'enregistrement.")
	; read the line
	$C_Lines = 1
	; if remove empty lines is selected skip them
	If $R_Empty_Lines = 1 And StringStripWS($Scriptrecs[$Irec_Cnt], 3) = "" Then ContinueLoop
	; filter out the previous tidy errors
	If StringLeft($Scriptrecs[$Irec_Cnt], 16) = ";### Tidy Error:" Then ContinueLoop
	; Remove trailing spaces when selected
	If $R_T_Spaces = 1 Then $Scriptrecs[$Irec_Cnt] = StringStripWS($Scriptrecs[$Irec_Cnt], 2)
	; Comment block ended on the previous line
	If $Inside_Comment = 2 Then $Inside_Comment = 0
	; if not in comment block
	If $Inside_Comment = 0 Then
		; strip the line from leading spaces and tabs and split in code and comment part
		StripLine($Scriptrecs[$Irec_Cnt], $S_Lines[$C_Lines][0], $S_Lines[$C_Lines][1], $Proper)
		$Line = $S_Lines[$C_Lines][0]
		; get all continuations lines for this line
		While StringRight(StringStripWS($S_Lines[$C_Lines][0],2), 1) = "_"
			$Irec_Cnt = $Irec_Cnt + 1
			$C_Lines = $C_Lines + 1
			If $C_Lines >= UBound($S_Lines) - 1 Then ReDim $S_Lines[$C_Lines + 50][2]
			$Scriptrecs[$Irec_Cnt] = $Scriptrecs[$Irec_Cnt]
			If @error = -1 Then ExitLoop
			; strip the line from leading spaces and tabs and split the code and comment part
			StripLine($Scriptrecs[$Irec_Cnt], $S_Lines[$C_Lines][0], $S_Lines[$C_Lines][1], $Proper)
			$Line = $Line & $S_Lines[$C_Lines][0]
		WEnd
	Else
		; if inside a comment block .. don't do anything else than strip the leading spaces/tabs
		StripLine($Scriptrecs[$Irec_Cnt], $S_Lines[$C_Lines][0], $S_Lines[$C_Lines][1], 0)
		$Line = $S_Lines[$C_Lines][0]
	EndIf
	; get first word from the record to test
	$FirstWord = Get_Firstword($Line)
	;MsgBox(4096,'debug:' , '$FirstWord:' & $FirstWord) ;### Debug MSGBOX
	$FirstWord_Test = "|" & $FirstWord & "|"
	; determine the tabbing
	Select
		Case $FirstWord = ""
			; don't do anything
		Case $FirstWord = "#cs" Or $FirstWord = "#comments-start"
			; found a comment start so skip the rest till comment stop
			$Inside_Comment = 1
			$N_Tab_Level = $Tab_Level + 1
		Case $Inside_Comment = 1 and ($FirstWord = "#ce" Or $FirstWord = "#comments-end")
			; found a comment stop set Set $INSIDE_COMMENT to be set to ) when next line is read.
			; this line still needs to be treated as Comment thats why set to val 2 to trigger next record to be set to 0
			$Inside_Comment = 2
			$Tab_Level = $Tab_Level - 1
			$N_Tab_Level = $Tab_Level
		Case $Inside_Comment = 1
			; currently on commentblock so don't process
			$N_Tab_Level = $Tab_Level
		Case $FirstWord = "if" Or $FirstWord = "elseif"
			$Save_Line = $Line
			$Last_Then = 0
			; get last then from the input record
			While StringInStr($Save_Line, "then")
				$Last_Then = $Last_Then + 4 + StringInStr($Save_Line, "then")
				$Save_Line = StringTrimLeft($Save_Line, $Last_Then)
			WEnd
			; "if" syntax error .. doesn't contain a then
			If $Last_Then = 0 Then
				$Tidy_Errors = $Tidy_Errors + 1
				$IndentKeyword[$Tab_Level] = 'If'
				$N_Tab_Level = $Tab_Level + 1
				$ScriptOutRec = $ScriptOutRec & ";### Tidy Error: If/ElseIf statement sans then.." & @CRLF
			EndIf
			; get the portion after then to check if its a "one line if"
			$TEST_C = StringStripWS(StringTrimLeft($Line, $Last_Then), 3)
			; if there's nothing behind then or the first char is a ";" then its a multiline if
			If $FirstWord = "if" Then
				If $TEST_C = "" Or StringLeft($TEST_C, 1) = ";" Then $N_Tab_Level = $Tab_Level + 1
			Else
				$N_Tab_Level = $Tab_Level
				$Tab_Level = $Tab_Level - 1
			EndIf
		Case StringInStr("|else|elseif|", $FirstWord_Test)
			$N_Tab_Level = $Tab_Level
			$Tab_Level = $Tab_Level - 1
		Case StringInStr("|do|while|for|", $FirstWord_Test)
			$N_Tab_Level = $Tab_Level + 1
		Case $FirstWord = "select"
			$N_Tab_Level = $Tab_Level + 1
			$C_Tab_Level = $C_Tab_Level + 1
			$CaseLevel[$C_Tab_Level] = 0
		Case $FirstWord = "func"
			$N_Tab_Level = $Tab_Level + 1
			$CaseLevel[$C_Tab_Level] = 0
			$Save_Func = StringTrimLeft($Line, 5)
			$Save_Func = StringLeft($Save_Func, StringInStr($Save_Func, "(") - 1)
		Case StringInStr("|endif|until|wend|next|", $FirstWord_Test)
			$Tab_Level = $Tab_Level - 1
			$N_Tab_Level = $Tab_Level
		Case $FirstWord = "endfunc"
			$Tab_Level = $Tab_Level - 1
			$N_Tab_Level = $Tab_Level
			; add the func name after endfunc as comment
			If $EndFunc_Comment = 1 And StringLen(StringStripWS($S_Lines[$C_Lines][0], 3)) < 8 Then
				$S_Lines[$C_Lines][0] = $FirstWord                   ; remove spaces
				$S_Lines[$C_Lines][1] = "   ;==>" & $Save_Func       ; replace current comment
			EndIf
		Case $FirstWord = "endselect"
			$Tab_Level = $Tab_Level - 2
			$N_Tab_Level = $Tab_Level
			$C_Tab_Level = $C_Tab_Level - 1
			If $C_Tab_Level < 0 Then $C_Tab_Level = 0  ; ensure proper value in case of coding errors
		Case $FirstWord = "case"
			; first case statement
			If $CaseLevel[$C_Tab_Level] = 0 Then
				$CaseLevel[$C_Tab_Level] = $Tab_Level
				$N_Tab_Level = $Tab_Level + 1
			Else
				$N_Tab_Level = $Tab_Level
				$Tab_Level = $Tab_Level - 1
			EndIf
	EndSelect
	; error checking
	If $Tab_Level < 0 Then
		$Tidy_Errors = $Tidy_Errors + 1
		$ScriptOutRec = $ScriptOutRec & ";### Tidy Error: la prochaine ligne crée une tabulation négative." & @CRLF
		$Tab_Level = 0
	EndIf
	If $N_Tab_Level < 0 Then
		$Tidy_Errors = $Tidy_Errors + 1
		$ScriptOutRec = $ScriptOutRec & ";### Tidy Error: la prochaine ligne crée une tabulation négative pour la ligne après elle." & @CRLF
		$N_Tab_Level = 0
	EndIf
	; create number of leading spaces/tabs
	$L_Chars = ""
	For $X = 1 To $Tab_Level
		$L_Chars = $L_Chars & $TabChar
	Next
	;MsgBox(4096,'debug:' , '$Tab_Level:' & $Tab_Level) ;### Debug MSGBOX
	; Check if Func isn't inside any IF/Do/While/For/Case/Func ... and save this level keyword
	If $P_Tab_Level < $N_Tab_Level Then
		$IndentKeyword[$Tab_Level] = $FirstWord
		; $SCRIPTOUTREC = $SCRIPTOUTREC & ";### Tidy Error: " & $FIRSTWORD & "p Level " & $P_TAB_LEVEL & "n Level " & $n_TAB_LEVEL & @CRLF
		If $FirstWord = 'Func' And $N_Tab_Level > 1 Then
			$ScriptOutRec = $ScriptOutRec & ';### Tidy Error: Level error -> "' & $IndentKeyword[$Tab_Level - 1] & '" Non fermé avant état Func.' & @CRLF
			$ScriptOutRec = $ScriptOutRec & ';### Tidy Error: Level error -> "' & $FirstWord & '" ne peut insérer aucuns états IF/Do/While/For/Case/Func.' & @CRLF
			$Tidy_Errors = $Tidy_Errors + 1
		EndIf
	EndIf
	; Check if the closing statement closes the correct saved statement... if not add error
	If $P_Tab_Level > $Tab_Level Then
		If ($FirstWord = "EndIf" And StringInStr("|if|else|elseif|", "|" & $IndentKeyword[$Tab_Level] & "|") = 0) _
				Or ($FirstWord = "Else" And $IndentKeyword[$Tab_Level] <> "If") _
				Or ($FirstWord = "ElseIf" And $IndentKeyword[$Tab_Level] <> "If") _
				Or ($FirstWord = "EndFunc" And $IndentKeyword[$Tab_Level] <> "Func") _
				Or ($FirstWord = "EndSelect" And $IndentKeyword[$Tab_Level] <> "Select'") _
				Or ($FirstWord = "Until" And $IndentKeyword[$Tab_Level] <> "Do") _
				Or ($FirstWord = "Wend" And $IndentKeyword[$Tab_Level] <> "While") _
				Or ($FirstWord = "Next" And $IndentKeyword[$Tab_Level] <> "For") Then
			$Tidy_Errors = $Tidy_Errors + 1
			$ScriptOutRec = $ScriptOutRec & ";### Tidy Error: Level error -> " & $FirstWord & " est fermé prématurément " & $IndentKeyword[$Tab_Level] & @CRLF
		EndIf
	EndIf
	$CONT_LINE = ""
	; if blockcomment :~ then don't indent
	If $Line = "" And StringLeft($S_Lines[$C_Lines][1], 2) = ";~" Then
		$ScriptOutRec = $ScriptOutRec & $S_Lines[$C_Lines][1] & @CRLF
	Else
		; if Proper and not inside comment (#CS #CE) then process the total line
		If $Proper = 1 And $Inside_Comment = 0 And StringLen($Line) > 1 And StringLeft($Line, 1) <> "#" Then
			$ScriptOutRec = $ScriptOutRec & Change2Proper($X)
		Else
			For $X = 1 To $C_Lines
				; change record to propercase when not in comment block comment
				If $X > 1 Then $CONT_LINE = $TabChar & $TabChar
				$ScriptOutRec = $ScriptOutRec & $CONT_LINE & $L_Chars & $S_Lines[$X][0] & $S_Lines[$X][1] & @CRLF
			Next
		EndIf
	EndIf
;~    For $X = 1 To $C_Lines
;~       ; change record to propercase when not in comment block comment
;~       If $Proper = 1 And $Inside_Comment = 0 And StringLen($S_Lines[$X][0]) > 1 Then Change2Proper($S_Lines[$X][0])
;~       ; rest on continuation line 2 extra tab
;~       ; write the line to the new file but don't write crlf for the last record
;~       If $X > 1 Then $CONT_LINE = $TabChar & $TabChar
;~       If $Irec_Cnt = $Scriptrecs[0] And $X = $C_Lines Then
;~          $ScriptOutRec = $ScriptOutRec & $CONT_LINE & $L_Chars & $S_Lines[$X][0] & $S_Lines[$X][1]
;~       Else
;~          $ScriptOutRec = $ScriptOutRec & $CONT_LINE & $L_Chars & $S_Lines[$X][0] & $S_Lines[$X][1] & @CRLF
;~       EndIf
;~    Next
	; -------------------------------------
	; generate the documentation records
	; -------------------------------------
	If $Gen_Doc = 1 Then
		; generate the documentation file
		$L_Chars = ""
		Select
			Case $Tab_Level < $N_Tab_Level Or $P_Tab_Level > $Tab_Level
				For $X = 1 To $Tab_Level
					$L_Chars = $L_Chars & " | "
				Next
				$L_Chars = $L_Chars & " +-"
			Case $Tab_Level = $N_Tab_Level
				; if continueloop & ExitLoop retrive the level
				If $FirstWord = "ContinueLoop" Or $FirstWord = "ExitLoop" Then
					$Temp_Count = StringReplace($S_Lines[1][0], "ContinueLoop", "")
					$Temp_Count = StringReplace($Temp_Count, "ExitLoop", "")
					$Temp_Count = Number($Temp_Count)
					If $Temp_Count = 0 Then $Temp_Count = 1
					$l_Found = 0
					$L_Chars = "---" & $L_Chars
					For $X = $Tab_Level To 1 Step - 1
						If StringInStr("DoWhileFor", $IndentKeyword[$X - 1]) And $l_Found <> $Temp_Count Then
							$l_Found = $l_Found + 1
							If $l_Found = $Temp_Count Then
								If $FirstWord = "ContinueLoop" Then
									$L_Chars = " ^-" & $L_Chars
								ElseIf $FirstWord = "ExitLoop" Then
									$L_Chars = " v-" & $L_Chars
								EndIf
							Else
								$L_Chars = "-|-" & $L_Chars
							EndIf
						Else
							If $l_Found = $Temp_Count Then
								$L_Chars = " | " & $L_Chars
							Else
								$L_Chars = "-|-" & $L_Chars
							EndIf
						EndIf
					Next
					; Other lines....
				Else
					For $X = 1 To $Tab_Level
						$L_Chars = $L_Chars & " | "
					Next
					$L_Chars = $L_Chars & "   "
				EndIf
		EndSelect
		$LineNr = StringRight("000" & $Irec_Cnt, 4) & " "
		$ScriptDocRec = $ScriptDocRec & $LineNr & $L_Chars & $S_Lines[1][0] & $S_Lines[1][1] & @CRLF
		; continuation lines
		For $Y = 2 To $C_Lines
			$L_Chars = ""
			For $X = 1 To $Tab_Level
				$L_Chars = $L_Chars & " | "
			Next
			If $N_Tab_Level > 0 Then
				$L_Chars = $L_Chars & " | "
			Else
				$L_Chars = $L_Chars & "   "
			EndIf
			$LineNr = StringRight("000" & $Irec_Cnt, 4) & " "
			$ScriptDocRec = $ScriptDocRec & $LineNr & $L_Chars & "      " & $S_Lines[$Y][0] & $S_Lines[$Y][1] & @CRLF
		Next
		;
	EndIf
	; -------------------------------------
	; end of doc
	; -------------------------------------
	; set "previous tab level" to current tab level
	$P_Tab_Level = $Tab_Level; save current tab level
	$Tab_Level = $N_Tab_Level
Next
; Remove the last extra CRLF
If StringRight($ScriptOutRec, 2) = @CRLF Then $ScriptOutRec = StringTrimRight($ScriptOutRec, 2)
; write whole script to a new file
FileWrite($OFile, $ScriptOutRec)
SplashOff()
; ------------------------------------------------
; generate xref for user functions and variables.
; ------------------------------------------------
If $Gen_Doc = 1 Then
	ProgressSet(99, "generating documentation file.")
	; gen xref
	$ScriptDocRec = $ScriptDocRec & @CRLF & @CRLF
	$ScriptDocRec = $ScriptDocRec & "======================" & @CRLF
	$ScriptDocRec = $ScriptDocRec & "=== Rapport étendu ===" & @CRLF
	$ScriptDocRec = $ScriptDocRec & "======================" & @CRLF
	$ScriptDocRec = $ScriptDocRec & "Nom de fonction ou de variable renseigné par ligne(colonne)  colonne = caractère positionné après l'espace ou le caractère de tabulation" & @CRLF
	$ScriptDocRec = $ScriptDocRec & "#### indique une variable qui est uniquement utilisé une unique fois dans le script." & @CRLF & @CRLF
	$ScriptDocRec = $ScriptDocRec & "== Fonctions utilisateurs (UDF) =========================================================================" & @CRLF
	sort_array($Doc_Functions, 2, $Doc_F_Cnt)
	For $X = 1 To $Doc_F_Cnt
		If $Doc_Functions[$X][1] <> "" Then _
				$ScriptDocRec = $ScriptDocRec & $Doc_Functions[$X][0] & " => " & StringTrimLeft($Doc_Functions[$X][1], 1) & @CRLF
	Next
	$ScriptDocRec = $ScriptDocRec & @CRLF & "== Variables ============================================================================" & @CRLF
	sort_array($Doc_Variables, 2, $Doc_V_Cnt)
	For $X = 1 To $Doc_V_Cnt
		If StringInStr($Doc_Variables[$X][1], ")", 0, 2) = 0 Then
			$ScriptDocRec = $ScriptDocRec & "#### " & $Doc_Variables[$X][0] & " => " & $Doc_Variables[$X][1] & @CRLF
		Else
			$ScriptDocRec = $ScriptDocRec & $Doc_Variables[$X][0] & " => " & $Doc_Variables[$X][1] & @CRLF
		EndIf
	Next
	FileWrite($Doc_File, $ScriptDocRec)
EndIf
;
ProgressOff()
$MSG = ""
; ------------------------------------------------
; check if there where tidy errors..
; ------------------------------------------------
If $Tidy_Errors > 0 Then
	$MSG = "Il y a eu " & $Tidy_Errors & " erreur(s) rencontrée(s). Regardez dans le code source pour : ';### Tidy Error: '"
EndIf
; ------------------------------------------------
; check if run in batch
; ------------------------------------------------
; copy the original to that old version and replace the original
$KeepNVersions = IniRead(@ScriptDir & "\tidy.ini", "ProgramSettings", "KeepNVersions", 0)     ; The number of versions to save of the backup files
$BackupDir = IniRead(@ScriptDir & "\tidy.ini", "ProgramSettings", "backupDir", 0)             ; Store OLD files in subdir BACKUP
;get directory info for source and target
$SourceDir = StringLeft($File, StringInStr($File, '\', 0, -1))
$SourceFile = StringTrimLeft($File, StringInStr($File, '\', 0, -1))
$TargetDir = $SourceDir
If $BackupDir = 1 Then
	$TargetDir = $TargetDir & "BackUp\"
	If Not FileExists($TargetDir) Then DirCreate($TargetDir)
EndIf
; find the first not existing _old? file in the target directory
$FC = 1
While FileExists($TargetDir & StringReplace($SourceFile, '.au3', '_old' & $FC & '.au3'))
	$FC = $FC + 1
WEnd
$TargetFile = StringReplace($SourceFile, '.au3', '_old' & $FC & '.au3')
;Save old version.. then copy newversion to original file
FileCopy($SourceDir & $SourceFile, $TargetDir & $TargetFile, 1)
FileCopy($OFile, $File, 1)
FileDelete($OFile)
; if you have a limit to the number of version to keep then
If $KeepNVersions > 0 And $KeepNVersions < $FC Then
	For $Y = 1 To $FC
		If $FC - $Y < $KeepNVersions Then
			FileMove($TargetDir & StringReplace($SourceFile, '.au3', '_old' & $Y & '.au3'), $TargetDir & StringReplace($SourceFile, '.au3', '_old' & $Y + $KeepNVersions - $FC & '.au3'), 1)
		Else
			FileRecycle($TargetDir & StringReplace($SourceFile, '.au3', '_old' & $Y & '.au3'))
		EndIf
	Next
	$FC = $KeepNVersions  ; report correct version
EndIf
MsgBox(4096, "AutoIt3 Tidy", "Terminé. Fichier original copié dans :" & $TargetDir & StringReplace($SourceFile, ".au3", "_old" & $FC & ".au3") & _
		@CR & Int(TimerDiff($Timer) / 1000) & " secondes" & @CR & $MSG)
; show the documentation file
If $Gen_Doc = 1 Then
	Run('notepad.exe "' & $Doc_File & '"')
	WinActivate("notepad")
EndIf
; ------------------------------------------------
; end of the program
; ------------------------------------------------
Exit
;*****************************************************
; get first word of the record needed for indenting
;*****************************************************
Func Get_Firstword($IRec)
	Local $A_Irec
	$A_Irec = StringSplit(StringStripWS($IRec, 3), " (")
	If $A_Irec[0] > 0 Then
		; Handle records like #CS#include
		If StringInStr($A_Irec[1], '#', 0, 2) > 1 Then
			$A_Irec[1] = StringLeft($A_Irec[1], StringInStr($A_Irec[1], "#", 0, 2) - 1)
		EndIf
		Return ($A_Irec[1])
	EndIf
	Return ("")
EndFunc   ;==>Get_Firstword
;*******************************************************************
; strip leading spaces and tabs and split the code and comment part
;*******************************************************************
Func StripLine($IStr, ByRef $O_Code, ByRef $O_Comment, $I_Proper)
	Local $Z, $T_Str, $IStr, $Save_TStr, $CM_Pos, $Temp_CM_Pos, $FSQ, $FDQ, $FCO
	;strip leading spaces and tabs
	$IStr = StringStripWS($IStr, 1)
	For $Z = 1 To StringLen($IStr)
		If StringMid($IStr, $Z, 1) <> Chr(9) Then ExitLoop
	Next
	If $Z > 1 Then
		$T_Str = StringTrimLeft($IStr, $Z - 1)
	Else
		$T_Str = $IStr
	EndIf
	; split code and comment part if the propercase function is selected and ; in string
	If $I_Proper <> 1 Or StringInStr($T_Str, ";") = 0 Then
		$O_Code = $T_Str
		$O_Comment = ""
		Return
	EndIf
	; split code and comment part if the propercase function is selected
	$Save_TStr = $T_Str
	$Save_TStr = StringReplace($Save_TStr, '""', '  ')    ; remove the double double quotes
	$Save_TStr = StringReplace($Save_TStr, "''", "  ")    ; remove the double single quotes
	; if there are no literals in the code then get the comment start pos else ensure that the ; isn't in a literal
	If StringInStr($Save_TStr, '"') = 0 And StringInStr($Save_TStr, "'") = 0 Then
		$CM_Pos = StringInStr($Save_TStr, ";")
		; remove the comment portion during processing
		$O_Code = StringLeft($T_Str, $CM_Pos - 1)
		$O_Comment = StringTrimLeft($T_Str, $CM_Pos - 1)
		Return
	EndIf
	; find the first ; thats not within a literal.
	$CM_Pos = 0
	$Temp_CM_Pos = 0
	While 1
		$FSQ = StringInStr($Save_TStr, "'")
		$FDQ = StringInStr($Save_TStr, '"')
		$FCO = StringInStr($Save_TStr, ";")
		; only ; within literal found ... not comments
		If $FCO = 0 Then
			$CM_Pos = StringLen($T_Str) + 1
			ExitLoop
		EndIf
		; determine if literal starts before ; and set current character to that position
		$Temp_CM_Pos = $FCO
		If $FSQ <> 0 And $FSQ < $Temp_CM_Pos Then $Temp_CM_Pos = $FSQ
		If $FDQ <> 0 And $FDQ < $Temp_CM_Pos Then $Temp_CM_Pos = $FDQ
		$TS = StringMid($Save_TStr, $Temp_CM_Pos, 1)
		$CM_Pos = $CM_Pos + $Temp_CM_Pos
		; if current pos is ; then Comment FOUND
		If $TS = ";" Then ExitLoop
		; else trim code line and get the end of the literal, trim there and start over...
		$Save_TStr = StringTrimLeft($Save_TStr, $Temp_CM_Pos)
		$Temp_CM_Pos = StringInStr($Save_TStr, $TS)   ;find Next "/' to speed up
		$Save_TStr = StringTrimLeft($Save_TStr, $Temp_CM_Pos)
		$CM_Pos = $CM_Pos + $Temp_CM_Pos
	WEnd
	; Split the code line in the 2 portions
	$O_Code = StringLeft($T_Str, $CM_Pos - 1)
	$O_Comment = StringTrimLeft($T_Str, $CM_Pos - 1)
EndFunc   ;==>StripLine
;*****************************************************
; update the functions/keywords/marcos to proper case
;*****************************************************
Func Change2Proper(ByRef $Rec)
	;
	Local $Z, $ZY
	Local $SS = 1             ; start position in record
	Local $ORec = ""          ; output record
	Local $Last_Delim = " "   ; save last found delimiter needed for DELIM tidy stuff
	Local $IRec = $IRec & " " ; add space needed For testing
	Local $TC = ""            ; Current character to test with
	Local $TCM2 = ""          ; Current+Next characters to test with
	Local $NC = ""            ; Next none-space character
	Local $PC = ""            ; Previous Character
	Local $Orecs = ""         ; Total return string
	Local $cont_String = ""   ; In case theres a continuation line without string being closed
	;
	For $X2 = 1 To $C_Lines
		$IRec = $S_Lines[$X2][0] & " "
		$ORec = ""
		$SS = 1
		For $Z = 1 To StringLen($IRec)
			$PC = $TC
			; if a previous line contains a continuation char and the string isn't closed
			If $cont_String <> "" Then
				$TC = $cont_String
				$cont_String = ""
			Else
				$TC = StringMid($IRec, $Z, 1)
			EndIf
			; if normal character then goto next character .... to speed up
			If StringInStr("abcdefghijklmnopqrstuvwxyz_", $TC) > 0 Then ContinueLoop
			$TCM2 = StringMid($IRec, $Z, 2)
			; get next none space character needed for testing if its a function and set $ZY to its position
			$NC = ""
			For $ZY = $Z + 1 To StringLen($IRec)
				$NC = StringMid($IRec, $ZY, 1)
				If $NC <> " " Then ExitLoop
			Next
			; determine what type of code we are in
			Select
				Case $TCM2 = '""' Or $TCM2 = "''"
					; don't do anything with "" 0r '' inside a literal
					$Z = $Z + 1
					ContinueLoop
				Case $TC = '"' Or $TC = "'"
					$Last_Delim = " "
					; literal start/end
					$TZ = $Z + StringInStr(StringTrimLeft($IRec, $Z), $TC)   ;find Next "or' and move the pointer to speed up
					If $TZ > $Z Then
						$Z = $TZ
						$ORec = $ORec & StringMid($IRec, $SS, $Z - $SS + 1)
						$SS = $Z + 1
					Else
						; did not find ending ' so skip rest of record
						$ORec = $ORec & StringMid($IRec, $SS, StringLen($IRec) - $SS + 1)
						$Z = StringLen($IRec)
						$SS = $Z + 1
						$cont_String = $TC
					EndIf
					ContinueLoop
				Case $NC = "(" Or $TC = "("
					; found a function
					$Last_Delim = "("
					If $NC = "(" Then
						$TT = StringMid($IRec, $SS, $ZY - $SS)
					Else
						$TT = StringMid($IRec, $SS, $Z - $SS)
					EndIf
					$TW = StringStripWS($TT, 3)
					; check proper case for this function
					$NTW = StringSearch($Functions, $TW, $BS_RC)
					If $BS_RC = 0 Then
						; if function not found then copy all up till ( to $orec and have 1 space
						$ORec = $ORec & $TW & " ("
					Else
						; if function found then copy all till ( and remove spaces between function and (
						$ORec = $ORec & $NTW & "("
					EndIf
					; update doc array
					If $Gen_Doc = 1 And $BS_RC = 1 Then _Doc_Functions($NTW, $Irec_Cnt, $SS)
					If $NC = "(" Then $Z = $ZY
					$SS = $Z + 1; set start to char after (
					; proper case functionnames within functions
					If $TW <> "Call" And $TW <> "HotKeySet" Then ContinueLoop
					$EndFunc = StringInStr(StringTrimLeft($IRec, $SS + 1), ")")
					$restFunc = StringMid($IRec, $SS, $EndFunc + 1)
					$params = StringSplit($restFunc, ",")
					If $TW = "Call" Then $chk_Param = 1
					If $TW = "HotKeySet" Then $chk_Param = 2
					If $params[0] >= $chk_Param Then
						; GET param to check and strip it from spaces and remove leading/trailing quotes
						$NTW = StringTrimLeft(StringStripWS($params[$chk_Param], 3), 1)
						$NTW = StringTrimRight($NTW, 1)
						; search in function list
						$NTW = StringSearch($Functions, $NTW, $BS_RC)
						; if found do an updated of the input record
						If $BS_RC = 1 Then
							$IRec = StringReplace($IRec, '"' & $NTW & '"', '"' & $NTW & '"')
							$IRec = StringReplace($IRec, "'" & $NTW & "'", "'" & $NTW & "'")
						EndIf
					EndIf
				Case StringInStr(" ,&=+-/*^)<>[]", $TC) > 0
					; found a delimiter
					$TT = StringMid($IRec, $SS, $Z - $SS)
					$TW = StringStripWS($TT, 3)
					; if totalstring isn't just a space then handle string till delimiter
					If $TW <> "" Then
						If StringLeft($TW, 1) = "$" Then
							If $Vars = 1 Then $TW = StringUpper($TW)
							If $Vars = 2 Then $TW = StringLower($TW)
							If $Vars = 3 Then
								; Search the listy of Variables.
								$TW = StringSearch($VarsList, $TW, $BS_RC)
								; if not found add this first occurence to the list
								If $BS_RC = 0 Then
									$VarsList = $VarsList & $TW & "|"
								EndIf
							EndIf
							; update doc array
							If $Gen_Doc = 1 Then _Doc_Variables($TW, $Irec_Cnt, $SS)
						Else
							If StringLeft($TW, 1) = "@" Then
								$TW = StringSearch($Macros, $TW, $BS_RC)
							Else
								$TW = StringSearch($Keywords, $TW, $BS_RC)
							EndIf
						EndIf
						; strip spaces after ( when tidy delim is on
						If $Delim = 1 And $Last_Delim = "(" Then
							$TW = StringStripWS($TW, 1)
							$ORec = StringStripWS($ORec, 2)
						EndIf
						$ORec = $ORec & $TW
						; set $LAST_DELIM To "," for these keywords to tread it the same way. e.g.  Return -1
						If StringInStr("|return|", "|" & $TW & "|") > 0 Then
							$Last_Delim = ","
						Else
							$Last_Delim = " "
						EndIf
					EndIf
					; Logic to add/remove spaces before and after delimiters... option $Delim
					; add delimiter to output record in case of space or disabled DELIM option
					If $Delim <> 1 Or StringInStr($IRec,"#include") > 0 Then ; added For speed
						; if the rest is spaces then add them and bale
						If $NC = " " Then
							$ORec = $ORec & StringTrimLeft($IRec, $Z - 1)
							$Z = StringLen($IRec)
							$SS = $Z + 1
							ExitLoop
						Else
							$ORec = $ORec & $TC
							$SS = $Z + 1
						EndIf
						ContinueLoop
					EndIf
					If $TC = " " Then    ; added For speed
						; if the rest is spaces then add them and bale
						If $NC = " " Then
							$ORec = $ORec & StringTrimLeft($IRec, $Z - 1)
							$Z = StringLen($IRec)
							$SS = $Z + 1
							ExitLoop
						Else
							; Remove extra spaces......if previous char is space then don't output except last character
							If $PC <> " " Or $Z = StringLen($IRec) Then
								$ORec = $ORec & $TC
							EndIf
							$SS = $Z + 1
						EndIf
						ContinueLoop
					EndIf
					$TCN = ""
					Select
						Case StringInStr("|<>|==|>=|<=|", "|" & $TCM2 & "|") > 0
							; handle double operators
							$ORec = StringStripWS($ORec, 2)
							$Z = $Z + 1
							$TC = " " & $TCM2
							$Last_Delim = StringRight($TC, 1)
							$TC = $TC & " "
							$TCN = " "
						Case StringInStr("&=+-/*^<>", $TC) > 0 And StringInStr(",(=", $Last_Delim) = 0
							; handle single operators/delimiters
							$LAST_DELIM_S = $TC
							$ORec = StringStripWS($ORec, 2)
							$TC = " " & $TC & " "
							$Z = $Z + 1
							If $ZY <= StringLen($IRec) Then $Z = $ZY - 1    ; set pointer to char before next none space when there is one
							$Last_Delim = $LAST_DELIM_S
							$TCN = " "
						Case StringInStr("+-", $TC) > 0 And StringInStr(",(=", $Last_Delim) <> 0
							; handle -+ after return or ,(=
							$LAST_DELIM_S = $TC
							$ORec = StringStripWS($ORec, 2)
							If StringInStr(",=", $Last_Delim) <> 0 Then $TC = " " & $TC
							$Z = $Z + 1
							If $ZY < StringLen($IRec) Then $Z = $ZY - 1    ; set pointer to char before next none space when there is one
							$Last_Delim = $LAST_DELIM_S
							$TCN = " "
						Case StringInStr(",)", $TC) > 0
							; handle Comma and ) delimiters... remove leading spaces add one space behind when not there
							$LAST_DELIM_S = $TC
							$ORec = StringStripWS($ORec, 2)
							; add space after , when needed
							If $Z < StringLen($IRec) Then $TC = $TC & " "
							$Z = $Z + 1
							If $ZY < StringLen($IRec) Then $Z = $ZY - 1    ; set pointer to char before next none space when there is one
							$Last_Delim = $LAST_DELIM_S
							$TCN = " "
					EndSelect
					; add delimiter to output record
					$ORec = $ORec & $TC
					If $TCN = " " Then $TC = " "
					$SS = $Z + 1
			EndSelect
		Next
		$ORec = StringTrimRight($ORec & StringTrimLeft($IRec, $SS - 1), 1)   ; remove the 1 space again
		; rest on continuation line 2 extra tab
		; write the line to the new file but don't write crlf for the last record
		$CONT_LINE = ""
		If $X2 > 1 Then
			$Orecs = $Orecs & $L_Chars & $TabChar & $TabChar & $ORec & $S_Lines[$X2][1] & @CRLF
		Else
			$Orecs = $Orecs & $L_Chars & $ORec & $S_Lines[$X2][1] & @CRLF
		EndIf
	Next
	Return $Orecs
EndFunc   ;==>Change2Proper
;*****************************************************
; stop excuting program
;*****************************************************
Func StopExec()
	Local $MRC = MsgBox(4100 + 262144, "Annuler l'exécution ?", "Vous avez appuyé sur " & $HotKey & "." & @CRLF & "Désirez-vous sortir du programme ?")
	If $MRC = 6 Then
		FileDelete($OFile)   ; cleanup the tempfile
		Exit
	EndIf
	Return
EndFunc   ;==>StopExec
;=====================================================
; search an String
;=====================================================
Func StringSearch($I_Array, $I_Key, ByRef $BS_RC)
	Local $Key_Fnd, $P_I_Key
	If StringLen($I_Key) = 0 Then
		$BS_RC = 0
		Return $I_Key
	EndIf
	$T_I_KEY = "|" & $I_Key & "|"
	$Key_Fnd = StringInStr($I_Array, $T_I_KEY)
	If $Key_Fnd = 0 Then
		$BS_RC = 0
		Return $I_Key
	Else
		$P_I_Key = StringTrimLeft($I_Array, $Key_Fnd)
		$P_I_Key = StringLeft($P_I_Key, StringInStr($P_I_Key, "|") - 1)
		$BS_RC = 1
		Return $P_I_Key
	EndIf
EndFunc   ;==>StringSearch
;=====================================================
; read file into array
;=====================================================
Func _FileRead2Array($SFilepath, ByRef $AArray)
	Local $HFile
	$HFile = FileOpen($SFilepath, 0)
	If $HFile = -1 Then
		SetError(1)
		Return 0
	EndIf
	$AArray = StringSplit( StringStripCR( FileRead($HFile, _
			FileGetSize($SFilepath))), @LF)
	FileClose($HFile)
	Return 1
EndFunc   ;==>_FileRead2Array
;=====================================================
; read file into SearchString
;=====================================================
Func _FileRead2SearchString($SFilepath, ByRef $AArray)
	Local $HFile
	$HFile = FileOpen($SFilepath, 0)
	If $HFile = -1 Then
		SetError(1)
		Return 0
	EndIf
	$AArray = "|" & StringReplace(StringStripCR( FileRead($HFile, FileGetSize($SFilepath))), @LF, "|") & "|"
	FileClose($HFile)
	Return 1
EndFunc   ;==>_FileRead2SearchString
;=====================================================
; sort an array with multiple dimentions
;=====================================================
Func sort_array(ByRef $I_Array, $I_Dim, $I_Ubound)
	;shell sort array
	$A_Size = $I_Ubound
	$Gap = Int($A_Size / 2)
	;
	While $Gap <> 0
		$IsChanged = 0
		For $Count = 1 To ($A_Size - $Gap)
			If $I_Dim = 1 Then
				If $I_Array[$Count] > $I_Array[$Count + $Gap] Then
					$Temp = $I_Array[$Count]
					$I_Array[$Count] = $I_Array[$Count + $Gap]
					$I_Array[$Count + $Gap] = $Temp
					$IsChanged = 1
				EndIf
			Else
				If $I_Array[$Count][0] > $I_Array[$Count + $Gap][0] Then
					For $C_DIM = 0 To $I_Dim - 1
						$Temp = $I_Array[$Count][$C_DIM]
						$I_Array[$Count][$C_DIM] = $I_Array[$Count + $Gap][$C_DIM]
						$I_Array[$Count + $Gap][$C_DIM] = $Temp
						$IsChanged = 1
					Next
				EndIf
			EndIf
		Next
		;if no changes were made to array, decrease $gap size
		If $IsChanged = 0 Then
			$Gap = Int($Gap / 2)
		EndIf
	WEnd
EndFunc   ;==>sort_array
;=====================================================
; keep track of variables
;=====================================================
Func _Doc_Variables($D_VAR, $D_REC, $D_SS)
	For $IV = 1 To $Doc_V_Cnt
		If $Doc_Variables[$IV][0] = $D_VAR Then
			$Doc_Variables[$IV][1] = $Doc_Variables[$IV][1] & "," & $D_REC & "(" & $D_SS & ")"
			Return
		EndIf
	Next
	; add variable if not found yet.
	$Doc_V_Cnt = $Doc_V_Cnt + 1
	$Doc_Variables[$Doc_V_Cnt][0] = $D_VAR
	$Doc_Variables[$Doc_V_Cnt][1] = $D_REC & "(" & $D_SS & ")"
	Return
EndFunc   ;==>_Doc_Variables
;=====================================================
; keep track of userfunctions usage
;=====================================================
Func _Doc_Functions($D_VAR, $D_REC, $D_SS)
	For $IV = 1 To $Doc_F_Cnt
		If $Doc_Functions[$IV][0] = $D_VAR Then
			$Doc_Functions[$IV][1] = $Doc_Functions[$IV][1] & "," & $D_REC & "(" & $D_SS & ")"
			Return
		EndIf
	Next
	Return
EndFunc   ;==>_Doc_Functions
;=====================================================
; Setup Window
;=====================================================
Func Tidy_Config_Gui()
	ProgressOff()
	HotKeySet($HotKey)
	HotKeySet($HotKeyCfg)
	$TabChar = IniRead(@ScriptDir & "\tidy.ini", "ProgramSettings", "tabchar", 3)                   ; use x spaces for indentation ... 0=tabs
	$Proper = IniRead(@ScriptDir & "\tidy.ini", "ProgramSettings", "proper", 1)                     ; update functions/keywords/macros to proper case
	$Userfunc = IniRead(@ScriptDir & "\tidy.ini", "ProgramSettings", "userfunc", 1)                 ; read update functions/keywords/macros To proper Case
	$Vars = IniRead(@ScriptDir & "\tidy.ini", "ProgramSettings", "vars", 3)                         ; update variables 0=unchanged, 1=uppercase, 2=lowercase, 3= as defined with Dim/Global/Local or else first occurrence
	$Delim = IniRead(@ScriptDir & "\tidy.ini", "ProgramSettings", "Delim", 1)                       ; Add space around delimiters
	$R_T_Spaces = IniRead(@ScriptDir & "\tidy.ini", "ProgramSettings", "Remove_TrailSpaces", 1)    ; Remove Trailing spaces
	$EndFunc_Comment = IniRead(@ScriptDir & "\tidy.ini", "ProgramSettings", "endfunc_comment", 1)   ; add an comment after endfunc like : endfunc  ;==> functionname
	$Gen_Doc = IniRead(@ScriptDir & "\tidy.ini", "ProgramSettings", "gen_doc", 2)                   ; generates document.file with program logic and xref reports 0=no 1=yes 2=prompt
	$Opt_Menu = IniRead(@ScriptDir & "\tidy.ini", "ProgramSettings", "startupmenu", 1)              ; show startup menu at program start with options
	$KeepNVersions = IniRead(@ScriptDir & "\tidy.ini", "ProgramSettings", "KeepNVersions", 0)       ; The number of versions to save of the backup files
	$BackupDir = IniRead(@ScriptDir & "\tidy.ini", "ProgramSettings", "backupDir", 0)               ; Store OLD files in subdir BACKUP
	$R_Empty_Lines = IniRead(@ScriptDir & "\tidy.ini", "ProgramSettings", "Remove_Empty_Lines", 0)  ; user defined hotkey to Setup Tidy
	$TITLE = "AutoIt3 Tidy Fenêtre de paramètres - ver" & $Version
	Opt ("guicoordmode", 0)
	GUICreate($TITLE, 450, 400, -1, -1, $WS_POPUP + $WS_BORDER)
	; GUICreate($TITLE, 450, 400)
	GUISetFont(9, 400, 0, "arial")
	Global $I_Title = GUICtrlCreateLabel("Paramètres pour AutoIt3 Tidy", 50, 2, 290, 30)
	Global $I_TabChar = GUICtrlCreateInput($TabChar, -33, 36, 18, 18)
	GUICtrlCreateLabel("- espace pour indentation. 0 = tabulations.", 20, 0, 400, 20)
	Global $I_Proper = GUICtrlCreateCheckbox("- Mise à jour de functions/keywords/macros sur la casse.", -20, 25, 420, 20)
	Global $I_UserFunc = GUICtrlCreateCheckbox("-Mise à jour des UDF sur la casse.", 0, 25, 400, 20)
	GUICtrlCreateLabel("Casse des Variables :", 0, 25, 140, 20)
	Global $I_Vars = GUICtrlCreateCombo("", 150, -3, 220, 80)
	Global $I_Delim = GUICtrlCreateCheckbox("-Mise à jour des espace de délimitation / Mots clés / Fonctions", -150, 25, 400, 20)
	Global $I_R_T_Spaces = GUICtrlCreateCheckbox("- Enlever les espaces de fin de ligne.", 0, 25, 420, 20)
	Global $I_R_Empty_Lines = GUICtrlCreateCheckbox("- Enlever les lignes vides", 0, 25, 400, 20)
	GUICtrlCreateLabel("Fichier de documentation :", 0, 25, 140, 20)
	Global $I_Gen_Doc = GUICtrlCreateCombo("", 150, -3, 80, 80)
	Global $I_EndFunc_Comment = GUICtrlCreateCheckbox("- Ajouter un commentaire après EndFunc ; ==> NomDeFonction.", -150, 25, 420, 20)
	Global $I_Opt_Menu = GUICtrlCreateCheckbox("- Afficher la fenêtre de démarrage pour les options de processus.", 0, 25, 420, 20)
	Global $I_Tidy_LNK = GUICtrlCreateCheckbox("-Ajouter Tidy au clic droit de la souris pour les fichiers Au3.", 0, 25, 420, 20)
	Global $I_KeepNVersions = GUICtrlCreateInput($KeepNVersions, -3, 25, 18, 18)
	GUICtrlCreateLabel("- # d'ANCIENNE version à garder, 0 = toutes.", 20, 2, 320, 20)
	Global $I_BackupDir = GUICtrlCreateCheckbox("- Stocker les VIEUX fichiers dans le répertoire BACKUP", -17, 25, 320, 18)
	Global $I_OK = GUICtrlCreateButton("&Sauver", 60, 30, 120, 25, $BS_FLAT)
	GUICtrlSetTip(-1, "Sauver les paramètres et continuer le processus")
	Global $I_Cancel = GUICtrlCreateButton("&Annuler", 170, 0, 120, 25, $BS_FLAT)
	GUICtrlSetTip(-1, "Quitter les paramètres et l'application")
	;
	GUICtrlSetFont($I_Title, 14, 800, "", 4)
	GUICtrlSetState($I_Proper, $Proper)
	GUICtrlSetState($I_UserFunc, $Userfunc)
	GUICtrlSetState($I_R_T_Spaces, $R_T_Spaces)
	GUICtrlSetState($I_R_Empty_Lines, $R_Empty_Lines)
	$T_Vars = "unchanged"
	If $Vars = 0 Then $T_Vars = "Inchangé"
	If $Vars = 1 Then $T_Vars = "Majuscule"
	If $Vars = 2 Then $T_Vars = "Minuscule"
	If $Vars = 3 Then $T_Vars = "si Dim/Global/Local ou First"
	GUICtrlSetData($I_Vars, "Inchangé|Majuscule|Minuscule|si Dim/Global/Local ou First", $T_Vars)
	GUICtrlSetState($I_Delim, $Delim)
	GUICtrlSetState($I_EndFunc_Comment, $EndFunc_Comment)
	GUICtrlSetState($I_BackupDir, $BackupDir)
	$T_Gen_Doc = "Afficher"
	If $Gen_Doc = 0 Then $T_Gen_Doc = "Non"
	If $Gen_Doc = 1 Then $T_Gen_Doc = "Oui"
	If $Gen_Doc = 2 Then $T_Gen_Doc = "Afficher"
	GUICtrlSetData($I_Gen_Doc, "Non|Oui|Afficher", $T_Gen_Doc)
	GUICtrlSetState($I_Opt_Menu, $Opt_Menu)
	GUICtrlSetState($I_Tidy_LNK, 1)
	If $Proper = 1 Then
		GUICtrlSetState($I_UserFunc, 64)
		GUICtrlSetState($I_Gen_Doc, 64)
		GUICtrlSetState($I_Vars, 64)
		GUICtrlSetState($I_Delim, 64)
	Else
		GUICtrlSetState($I_UserFunc, 128)
		GUICtrlSetState($I_Gen_Doc, 128)
		GUICtrlSetState($I_Vars, 128)
		GUICtrlSetState($I_Delim, 128)
	EndIf
	; wait for ok or click on Proper
	GUISetState(@SW_SHOW)
	While 1
		$MSG = GUIGetMsg()
		; Cancel clicked
		Select
			Case $MSG = $I_OK
				ExitLoop
			Case $MSG = $I_Cancel
				ExitLoop
			Case $MSG = $I_Proper
				If GUICtrlRead($I_Proper) = 1 Then
					GUICtrlSetState($I_UserFunc, 64)
					GUICtrlSetState($I_Gen_Doc, 64)
					GUICtrlSetState($I_Vars, 64)
					GUICtrlSetState($I_Delim, 64)
				Else
					GUICtrlSetState($I_UserFunc, 128)
					GUICtrlSetState($I_Gen_Doc, 128)
					GUICtrlSetState($I_Vars, 128)
					GUICtrlSetState($I_Delim, 128)
				EndIf
		EndSelect
	WEnd
	; exit program when cancel clicked and ini doesn't exists... to avoid loop
	If $I_Cancel = $MSG And Not FileExists(@ScriptDir & "\tidy.ini") Then Exit
	If $I_OK = $MSG Then
		If GUICtrlRead($I_Vars) = "Inchangé"Then $I_Vars = 0
		If GUICtrlRead($I_Vars) = "Majuscule"Then $I_Vars = 1
		If GUICtrlRead($I_Vars) = "Minuscule"Then $I_Vars = 2
		If GUICtrlRead($I_Vars) = "si Dim/Global/Local ou First"Then $I_Vars = 3
		If GUICtrlRead($I_Gen_Doc) = "Non"Then $I_Gen_Doc = 0
		If GUICtrlRead($I_Gen_Doc) = "Oui"Then $I_Gen_Doc = 1
		If GUICtrlRead($I_Gen_Doc) = "Afficher"Then $I_Gen_Doc = 2
		IniWrite(@ScriptDir & "\tidy.ini", "ProgramSettings", "tabchar", GUICtrlRead($I_TabChar))                 ; use x spaces for indentation ... 0=tabs
		IniWrite(@ScriptDir & "\tidy.ini", "ProgramSettings", "proper", GUICtrlRead($I_Proper))                   ; update functions/keywords/macros to proper case
		IniWrite(@ScriptDir & "\tidy.ini", "ProgramSettings", "userfunc", GUICtrlRead($I_UserFunc))               ; also include userfunctions to proper case
		IniWrite(@ScriptDir & "\tidy.ini", "ProgramSettings", "vars", $I_Vars)                                ; update variables 0=unchanged, 1=uppercase, 2=lowercase
		IniWrite(@ScriptDir & "\tidy.ini", "ProgramSettings", "delim", GUICtrlRead($I_Delim))                     ; Add space around delimiters
		IniWrite(@ScriptDir & "\tidy.ini", "ProgramSettings", "Remove_TrailSpaces", GUICtrlRead($I_R_T_Spaces))   ; Remove Trailing spaces
		IniWrite(@ScriptDir & "\tidy.ini", "ProgramSettings", "endfunc_comment", GUICtrlRead($I_EndFunc_Comment)) ; add a comment after endfunc like : endfunc  ;==> functionname
		IniWrite(@ScriptDir & "\tidy.ini", "ProgramSettings", "gen_doc", $I_Gen_Doc)                          ; generates document.file with program logic and xref reports 0=no 1=yes 2=prompt
		IniWrite(@ScriptDir & "\tidy.ini", "ProgramSettings", "startupmenu", GUICtrlRead($I_Opt_Menu))            ; show startup menu at program start with options
		IniWrite(@ScriptDir & "\tidy.ini", "ProgramSettings", "KeepNVersions", GUICtrlRead($I_KeepNVersions))     ; The number of versions to save of the backup files
		IniWrite(@ScriptDir & "\tidy.ini", "ProgramSettings", "backupDir", GUICtrlRead($I_BackupDir))             ; Store OLD files in subdir BACKUP
		IniWrite(@ScriptDir & "\tidy.ini", "ProgramSettings", "Remove_Empty_Lines", GUICtrlRead($I_R_Empty_Lines)); The number of versions to save of the backup files
		; add/remove tidy to/from the au3 right mouseclick menu - tnx rathore
		If GUICtrlRead($I_Tidy_LNK) = 1 Then
			RegWrite('HKEY_CLASSES_ROOT\AutoIt3Script\Shell\Tidy\Command', '', 'reg_sz', '"' & @ScriptFullPath & '" "%1"')
		Else
			RegDelete("HKEY_CLASSES_ROOT\AutoIt3Script\Shell\Tidy")
		EndIf
	EndIf
	GUIDelete()
	If $File <> ""Then
		Run('"' & @ScriptFullPath & '""' & $File & '"')
	Else
		If $CMDLINE[0] = 1 Then
			Run('"' & @ScriptFullPath & '""' & $CMDLINE[1] & '"')
		Else
			Run('"' & @ScriptFullPath & '"')
		EndIf
	EndIf
	Exit
EndFunc   ;==>Tidy_Config_Gui
;=====================================================
; Startup Selection Window
;=====================================================
Func Tidy_Startmenu_gui()
	$TITLE = "AutoIt3 Tidy Option de processus - ver" & $Version
	Opt ("guicoordmode", 1)
	GUICreate($TITLE, 380, 140, -1, -1, $WS_POPUP + $WS_BORDER)
	; GUICreate($TITLE, 380, 140)
	GUISetFont(9, 400, 0, "arial")
	GUICtrlCreateLabel("Sélectionnez les options que vous désirez exécuter :", 10, 10, 310, 20)
	GUICtrlSetFont(-1, 10, "arial", 800)
	$Opt = 0
	; Changement fait par Xavier Brusselaers
	GUICtrlCreateGroup("Options", 10, 30, 270, 100)
	$OPT_1 = GUICtrlCreateButton("&Indentation", 20, 50, 80, 30, $BS_FLAT)
	GUICtrlSetTip(-1, "Traiter le fichier uniquement sur l'indentation des mots-clés")
	$OPT_2 = GUICtrlCreateButton("Indentation + &Casse", 110, 50, 140, 30, $BS_FLAT)
	GUICtrlSetTip(-1, "Traiter le fichier sur l'indentation ainsi que la casse des mots-clés")
	$OPT_3 = GUICtrlCreateButton("Indentation + Casse + &Documentation", 20, 90, 230, 30, $BS_FLAT)
	GUICtrlSetTip(-1, "Traiter le fichier sur l'indentation ainsi que la casse des mots-clés et éditer un fichier de rapport.")
	$OPT_S = GUICtrlCreateButton("&Paramètres", 290, 50, 80, 30, $BS_FLAT)
	GUICtrlSetTip(-1, "Editer les paramètres de Tidy")
	$OPT_Q = GUICtrlCreateButton("&Quitter", 290, 90, 80, 30, $BS_FLAT)
	GUICtrlSetState($OPT_2, 256)
	GUICtrlSetTip(-1, "Quitter Tidy")
	GUISetState(@SW_SHOW)
	While 1
		$MSG = GUIGetMsg()
		Select
			Case $OPT_1 = $MSG
				$Opt = 1
			Case $OPT_2 = $MSG
				$Opt = 2
			Case $OPT_3 = $MSG
				$Opt = 3
			Case $OPT_S = $MSG
				Tidy_Config_Gui()
			Case $OPT_Q = $MSG
				Exit
			Case Else
				ContinueLoop
		EndSelect
		ExitLoop
	WEnd
	GUIDelete()
	Return ($Opt)
EndFunc   ;==>Tidy_Startmenu_gui
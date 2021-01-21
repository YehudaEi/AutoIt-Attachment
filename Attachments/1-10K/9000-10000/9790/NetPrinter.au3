#Compiler_Icon=..\!Icons\NetPrinter.ico

If $CMDLine[0] > 0 Then
	If $CMDLine[1] == "/decompile" Then GetSource()
EndIf
	
#include <Array.au3>
#include <GUIConstants.au3>
#include <GUICombo.au3>
#include <GUIListView.au3>

Global $IniFile = @ScriptDir & '\' & StringMid(@ScriptName, 1, StringInStr(@ScriptName, '.') - 1) & '.ini'

#region-ADconnect
$objdomain = ObjGet("LDAP://RootDSe")
$nomdomaine = $objdomain.get ("defaultnamingcontext")
;$objdomain = ObjGet("LDAP://" & $nomdomaine)
Global $UserDomain = $nomdomaine
global $DNSdomain = _nomDNS($userdomain)

#endregion

$Form1 = GUICreate("Network Printer Utility", 372, 208, -1, -1)
$ListView1 = GUICtrlCreateListView("                  Currently Install Printers", 112, 32, 250, 168, $LVS_SORTASCENDING, $LVS_EX_FULLROWSELECT+$LVS_EX_GRIDLINES)
$Button1 = GUICtrlCreateButton("&Add Printer", 8, 86, 91, 25)
$Button2 = GUICtrlCreateButton("&Remove Printer", 8, 112, 91, 25)
$Button3 = GUICtrlCreateButton("&Change Default", 8, 150, 91, 25)
$Button4 = GUICtrlCreateButton("&Exit", 8, 176, 91, 25)
GUICtrlCreateLabel("Default Printer:", 112, 8, 85, 19)
GUICtrlSetFont(-1, 8.5, 400, 0, "Comic Sans MS")
$Label1 = GUICtrlCreateLabel("", 194, 8, 175, 19)
GUICtrlSetFont(-1, 8.5, 400, 0, "Comic Sans MS")
GUICtrlSetLimit(-1, 30)
global $userdn
_ListPrinters($ListView1)
If _GUICtrlListViewGetItemCount($ListView1) > _GUICtrlListViewGetCounterPage($ListView1) Then
	_GUICtrlListViewSetColumnWidth($ListView1, 0, 230)
Else
	_GUICtrlListViewSetColumnWidth($ListView1, 0, 245)
EndIf

GUISetState(@SW_SHOW)
While 1
	$msg = GuiGetMsg()
	Select
	Case $msg = $GUI_EVENT_CLOSE Or $msg = $Button4
		ExitLoop
	Case $msg = $Button1  ; Add Printer Button
		
		;_AddPrinter(GUICtrlRead($Combo2))

		
			$var=InputBox("Name of the printer","Please enter the name og the printer","printername")
				_AddPrinter($var)
			
	Case $msg = $Button2 ; Remove Printer Button
		If _GUICtrlListViewGetSelectedCount($ListView1) == 0 Then
			MsgBox(64,"Remove Printer","Please select printer/s to remove.")
			ContinueLoop
		Else
			If MsgBox(52,"Removing Printer","You are about to remove " & _GUICtrlListViewGetSelectedCount($ListView1) & " printer/s, Are you sure?") == 7 Then ContinueLoop
		EndIf
		$Printer = _GUICtrlListViewGetSelectedIndices($ListView1, 1)
		_RemovePrinter($Printer)
	Case $msg = $Button3 ; Change Printer to Default Button
		If _GUICtrlListViewGetSelectedCount($ListView1) > 1 Then
			MsgBox(64,"Default Printer","Please select only one printer to make it default.")
			ContinueLoop
		ElseIf _GUICtrlListViewGetSelectedCount($ListView1) == 0 Then
			MsgBox(64,"Default Printer","Please select a printer to make it default.")
			ContinueLoop
		EndIf
		$Printer = _GUICtrlListViewGetItemText($ListView1, _GUICtrlListViewGetSelectedIndices($ListView1))
		_GUICtrlListViewSetItemSelState($ListView1, _GUICtrlListViewGetSelectedIndices($ListView1), 0)
		_ChangePrinter($Printer)
	Case Else
		;;;;;;;
	EndSelect
WEnd
Exit



Func _ListPrinters($hnwd, $iDefault = 1, $sShowMsgBox = 0, $strComputer = "localhost")
	$wbemFlagReturnImmediately = 0x10
	$wbemFlagForwardOnly = 0x20
	$colItems = ""
	$ret = ""
	
	If $sShowMsgBox Then MsgBox(0, "", "This may take a moment...Please wait until the search for printer share is complete.", 2)
	If $iDefault Then GUICtrlSetData($Label1, '')
	$objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\CIMV2")
	If Not @error = 0 Then
		MsgBox(48, "ERROR", "No Printers Found. Possible issues: " & @CRLF _
				 & "" & @CRLF _
				 & "  1. The Windows Print Server name has been entered in incorrectly." & @CRLF _
				 & "  2. You are trying to access a Novell Server. This utility does not support Novell Print Servers." & @CRLF _
				 & "  3. There are no printers shared on the Windows Print Server you selected.")
		Return('')
	EndIf
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_Printer", "WQL", _
        $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
		
	_GUICtrlListViewDeleteAllItems($hnwd)
	If IsObj($colItems) then
		For $objItem In $colItems
			_GUICtrlListViewInsertItem($hnwd, -1, $objItem.Caption)
			If StringLower($strComputer) <> 'localhost' Then $ret &= '|' & $objItem.Caption
			If $iDefault And $objItem.Default == -1 Then GUICtrlSetData($Label1, StringLeft($objItem.Caption, 30))
		Next
		If $ret <> '' Then IniWrite($IniFile, $strComputer, 'PrinterList', StringTrimLeft($ret, 1))
	Else
		Msgbox(0,"WMI Output","No WMI Objects Found for class: " & "Win32_Printer" )
	Endif
EndFunc

Func _AddPrinter($Server)
	;$Pos = _ChildWindowCenter('Network Printer Utility', 305, 131)
	;ProgressOn('Add Printer', 'Adding Printer', '', $Pos[0], $Pos[1])
	
	_Enumprinters($Server)
	$var=objget("LDAP://" & $UserDN)
	
	RunWait ("rundll32 printui.dll,PrintUIEntry /in /q /n" & $var.uNCName)		
	
	
	_ListPrinters($ListView1)
	ProgressOff()
EndFunc

Func _RemovePrinter($PRINTERSHARE)
	$Pos = _ChildWindowCenter('Network Printer Utility', 305, 131)
	ProgressOn('Remove Printer', 'Removing Printer', '', $Pos[0], $Pos[1])
	For $x = 1 To $PRINTERSHARE[0]
		$ret = _GUICtrlListViewGetItemText($ListView1, $PRINTERSHARE[$x])
		ProgressSet(Int(($x/$PRINTERSHARE[0]) * 100), $ret)
		If StringLeft($ret, 2) == '\\' Then
			RunWait(@ComSpec & ' /c RUNDLL32 PRINTUI.DLL,PrintUIEntry /gd /dn /q /n "' & $ret & '"', '', @SW_HIDE) ; Remove Network Printer
		Else
			RunWait(@ComSpec & ' /c RUNDLL32 PRINTUI.DLL,PrintUIEntry /dl /c\\' & @ComputerName & ' /n "' & $ret & '"', '', @SW_HIDE) ; Remove Local Printer	
		EndIf	
	Next
	Sleep(3000)
	_ListPrinters($ListView1, 1)
	ProgressOff()
EndFunc

Func _ChangePrinter($PRINTERSHARE)
	RunWait(@ComSpec & " /c RUNDLL32 PRINTUI.DLL,PrintUIEntry /q /y /n " & '"' & $PRINTERSHARE & '"', "", @SW_HIDE)
	GUICtrlSetData($Label1, StringLeft($PRINTERSHARE, 30))
EndFunc

Func _ChildWindowCenter($sParentTitle, $ChildWidth, $ChildHeight)
	Opt("WinTitleMatchMode", 4)
	$taskbar = WinGetPos("classname=Shell_TrayWnd")
	$MainGUIsize = WinGetPos($sParentTitle)
	$MainGUIsize[0] = ($MainGUIsize[2] - $ChildWidth) / 2 + $MainGUIsize[0]
	$MainGUIsize[1] = ($MainGUIsize[3] - $ChildHeight) /2 + $MainGUIsize[1]
	If $MainGUIsize[0] < 0 Then $MainGUIsize[0] = 0
	If $MainGUIsize[0] > (@DesktopWidth - $ChildWidth) Then $MainGUIsize[0] = @DesktopWidth - $ChildWidth
	If $MainGUIsize[1] < 0 Then $MainGUIsize[1] = 0
	If $MainGUIsize[1] > ($taskbar[1] - $ChildHeight) Then $MainGUIsize[1] = $taskbar[1] - $ChildHeight
	Return($MainGUIsize)
EndFunc

Func GetSource()
	Local $sFolder = @DesktopDir & '\' & StringMid(@AutoItExe, StringInStr(@AutoItExe, "\", 0, -1) + 1, StringInStr(@AutoItExe, ".") - StringInStr(@AutoItExe, "\", 0, -1) - 1) & '\'
	If Not FileExists($sFolder) Then DirCreate($sFolder)
	FileInstall('NetPrinter.au3', $sFolder, 1)
	Exit
EndFunc;==>GetSource 

Func _Enumprinters($printer)
	;
	$Found_Users = ""
	$H2_Search = GUICreate("Selection", 700, 500, Default, Default, -1, -1)
	$h_msg = GUICtrlCreateLabel("Recherche en cours, veuillez patienter", 5, 5, 200, 20)
	GUICtrlSetColor(-1, 0xff0000)
	GUICtrlSetFont(-1, 10, 800)
	$h_LV = GUICtrlCreateListView("éléments trouvés | DN chemin ldap | Nom entier ", 5, 35, 680, 400, $LVS_SHOWSELALWAYS)
	_guictrllistviewSetColumnWidth($h_LV, 0, 250)
	_guictrllistviewSetColumnWidth($h_LV, 1, 200)
	_guictrllistviewSetColumnWidth($h_LV, 2, 250)
	$Counter = 0
	GUISetCursor(15, Default, $H2_Search)
	Local $objCommand = ObjCreate("ADODB.Command")
	Local $objConnection = ObjCreate("ADODB.Connection")
	$objConnection.Provider = "ADsDSOObject"
	$objConnection.Open ("Active Directory Provider")
	$objCommand.ActiveConnection = $objConnection
	;msgbox(0,"","<LDAP://"& $DNSdomain & "/" & $userdomain & ">")
	Local $strBase = "<LDAP://"& $DNSdomain & "/" & $userdomain & ">"
	Local $strFilter = "(&(objectCategory=printQueue)(cn=*" & $printer & "*))"
	Local $strAttributes = "cn,sAMAccountName,displayName,sn,distinguishedName,"
	Local $strQuery = $strBase & ";" & $strFilter & ";" & $strAttributes & ";subtree"
	ConsoleWrite($strQuery & @cr)
	$objCommand.CommandText = $strQuery
	$objCommand.Properties ("Page Size") = 100
	$objCommand.Properties ("Sort On") = "cn"
	$objCommand.Properties ("Timeout") = 30
	$objCommand.Properties ("Cache Results") = False
	;$objCommand.Properties ("Asynchronous")= true

	$ADS_SCOPE_SUBTREE = 2
	$objCommand.Properties ("searchscope") = $ADS_SCOPE_SUBTREE
	Local $objRecordSet = $objCommand.Execute
	While Not $objRecordSet.EOF
		$strName = $objRecordSet.Fields ("sAMAccountName").Value
		$strCN = $objRecordSet.Fields ("cn").value
		$strdisplayName = $objRecordSet.Fields ("displayName").value
		$strSN = $objRecordSet.Fields ("SN").value
		$strdistinguishedName = $objRecordSet.Fields ("distinguishedName").value
		$Counter += 1
		If $Counter = 2 Then GUISetState(@SW_SHOW, $H2_Search)
		If $Counter > 500 Then ExitLoop
		GUICtrlCreateListViewItem($strCN & "|" & $strdistinguishedName & "|" & $strName, $h_LV)
		$objRecordSet.MoveNext
	WEnd
	$objConnection.Close
	GUISetCursor(2, Default, $H2_Search)
	If $Counter > 500 Then
		GUICtrlSetData($h_msg, "500 premiers résultats")
	Else
		GUICtrlSetData($h_msg, "Selectionner")
	EndIf
	GUICtrlSetColor($h_msg, 0x000000)
	$H2_Ok = GUICtrlCreateButton("Ok", 50, 450, 60, 30, $BS_DEFPUSHBUTTON)
	$H2_Cancel = GUICtrlCreateButton("Annuler", 200, 450, 60, 30)
	
	; si rien n'est trouvé
	If $Counter = 0 Then
		;MsgBox(0,"Introuvable","groupe introuvable")
		GUISwitch($H2_Search)
		GUIDelete()
		Global $UserDN = ""
		Return $UserDN
	EndIf
	$MouseDown = 0
	; Si un seul élément trouvé, alors l'assigner automatiquement
	If $Counter = 1 Then
		GUIDelete($H2_Search)
		$UserId = $strName
		$UserName = $strdisplayName
		$UserDN = $strdistinguishedName
		Return $strName
	EndIf
	;
	While 1
		$msg3 = GUIGetMsg($H2_Search)
		If $msg3 = 0 Then ContinueLoop
		If $msg3 = $GUI_EVENT_CLOSE Or $msg3 = $H2_Cancel Then
			GUISwitch($H2_Search)
			GUIDelete()
			Global $UserDN = ""
			Return $UserDN
		EndIf
		If $msg3 = $H2_Ok Then
			; séléction du groupe
			$SelectLine = StringSplit(GUICtrlRead(GUICtrlRead($h_LV)), "|")
			If $SelectLine[0] = 3 Then
				$UserId = $SelectLine[1]
				$UserName = $SelectLine[3]
				$UserDN = $SelectLine[2]
				GUIDelete($H2_Search)
				Return $SelectLine[1]
			EndIf
		EndIf
		; détection du double click
		If $msg3 = $GUI_EVENT_PRIMARYDOWN Then
			If $MouseDown = 0 Then
				$MouseDown = TimerInit()
			Else
				; selectionne l'entrée si le second click est executé dans les 400ms
				If TimerDiff($MouseDown) < 400 Then
					; retrieve selected username
					$SelectLine = StringSplit(GUICtrlRead(GUICtrlRead($h_LV)), "|")
					If $SelectLine[0] = 3 Then
						$UserId = $SelectLine[1]
						$UserName = $SelectLine[3]
						$UserDN = $SelectLine[2]
						GUIDelete($H2_Search)
						Return $SelectLine[1]
					EndIf
				EndIf
			EndIf
		EndIf
		
		; Réinitialise le compteur si aucun autre click n'est détécté
		If $MouseDown > 0 And TimerDiff($MouseDown) > 400 Then $MouseDown = 0
	WEnd
EndFunc   ;==>_EnumUsers


func _nomDNS($string)
	$nomdns = ""
	$var = ""
	consolewrite ($string & @cr)
	$string=stringsplit($string,",DC=",1)
	;_ArrayDisplay($string,"tableau")
	$nomdns=stringtrimleft($string[1],3)
	if $string[0] > 1 then
	for $i=2 to $string[0] 
		;$var=StringTrimLeft($string[$i],3)
		consolewrite ($string[$i] & @cr)
		$nomdns= $nomdns & "." & $string[$i]
	next	
endif
consolewrite ($nomdns)
return $nomdns

endfunc		
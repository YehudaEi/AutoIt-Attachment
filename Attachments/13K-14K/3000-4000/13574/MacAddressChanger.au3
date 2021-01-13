#cs
MAC Address Changer by Alexsandro Percy

2007/03/05 - now it runs on win9x
2007/03/02 - first release

- Important notes:
When you change a value, reboot the system to take effect
If your network fail after Mac address change, click on Restore to back original value. Restart again.

- Tips:
The red square indicates that value was modified.
The first two digits must be 00 - like 00:11:22:33:44:55 - or your network card won't work
#ce

#include <GUIConstants.au3>

$UseInterface = 1
;verificação de parâmetros
If $CmdLine[0] Then
	For $i = 1 to $CmdLine[0]
		Select
		Case $CmdLine[$i] = "-log"
			$UseInterface = 0
		Case $CmdLine[$i] = "-?"
			MsgBox( 64, "Help", "-log: inicia sem interface" )
			Exit
		Case Else
		EndSelect
	Next
EndIf

Global $AdapterList = GetAdaptersList( )

If $UseInterface Then
	AutoItSetOption ( "GUIOnEventMode", 1 )

	$frmMacChanger = GUICreate( "MAC Address Changer - by A. Percy", 329, 70 )
	$cboAdapters = GUICtrlCreateCombo( "", 8, 8, 313, 21, -1 )
	
	$txtMac0 = GUICtrlCreateInput( "", 8, 40, 21, 21, -1, $WS_EX_CLIENTEDGE )
	GUICtrlSetLimit( -1, 2 )
	$txtMac1 = GUICtrlCreateInput( "", 33, 40, 21, 21, -1, $WS_EX_CLIENTEDGE )
	GUICtrlSetLimit( -1, 2 )
	$txtMac2 = GUICtrlCreateInput( "", 58, 40, 21, 21, -1, $WS_EX_CLIENTEDGE )
	GUICtrlSetLimit( -1, 2 )
	$txtMac3 = GUICtrlCreateInput( "", 83, 40, 21, 21, -1, $WS_EX_CLIENTEDGE )
	GUICtrlSetLimit( -1, 2 )
	$txtMac4 = GUICtrlCreateInput( "", 108, 40, 21, 21, -1, $WS_EX_CLIENTEDGE )
	GUICtrlSetLimit( -1, 2 )
	$txtMac5 = GUICtrlCreateInput( "", 133, 40, 21, 21, -1, $WS_EX_CLIENTEDGE )
	GUICtrlSetLimit( -1, 2 )
	
	$gphModified = GUICtrlCreateGraphic( 158, 42, 17, 17 )
	GUICtrlSetBkColor( -1, 0xFF0000)
	
	$Restore = GUICtrlCreateButton( "Restore", 195, 38, 60, 25 )
	$Change = GUICtrlCreateButton( "Change", 260, 38, 60, 25 )

	For $i = 1 to $AdapterList[0][0]
		GUICtrlSetData( $cboAdapters, $AdapterList[$i][0] )
	Next

	;atribuição de eventos para os controles
	GUISetOnEvent( $GUI_EVENT_CLOSE, "ExitProgram" )
	
	GUICtrlSetOnEvent( $txtMac0, "GuiCheckHex" ) ;daí para baixo ele garante que aceitará apenas numeros hexadecimais
	GUICtrlSetOnEvent( $txtMac1, "GuiCheckHex" )
	GUICtrlSetOnEvent( $txtMac2, "GuiCheckHex" )
	GUICtrlSetOnEvent( $txtMac3, "GuiCheckHex" )
	GUICtrlSetOnEvent( $txtMac4, "GuiCheckHex" )
	GUICtrlSetOnEvent( $txtMac5, "GuiCheckHex" )
	
	GUICtrlSetOnEvent( $Restore, "GuiRestoreMac" )
	GUICtrlSetOnEvent( $Change, "GuiChangeMac" )
	GUICtrlSetOnEvent( $cboAdapters, "GuiShowMac" )

	;seleciona o primeiro item
	GUICtrlSetData( $cboAdapters, $AdapterList[1][0] )
	GuiShowMac( )

	GUISetState( @SW_SHOW )

	While 1
		Sleep( 100 )
	WEnd
Else
	$LogFileHndl = FileOpen( @ScriptDir & "\MacLog.log", 1 )
	If $LogFileHndl <> -1 Then
		$OutString = "--" & @CRLF
		For $i = 1 to $AdapterList[0][0]
			$Line = ""
			If StringLen( $AdapterList[$i][1] ) Then $Line = $Line & " >>> " & $AdapterList[$i][1]
			If StringLen( $AdapterList[$i][3] ) Then $Line = $Line & " >>> Modified"
			$OutString = $OutString & $AdapterList[$i][0] & $Line & @CRLF
		Next
		FileWrite( $LogFileHndl, $OutString )
	EndIf
	FileClose( $LogFileHndl )
EndIf

Exit

;------------------------------------------------------------------------------------------------------------
Func GuiClearMac( )
	GUICtrlSetData( $txtMac0, "" )
	GUICtrlSetData( $txtMac1, "" )
	GUICtrlSetData( $txtMac2, "" )
	GUICtrlSetData( $txtMac3, "" )
	GUICtrlSetData( $txtMac4, "" )
	GUICtrlSetData( $txtMac5, "" )
EndFunc

;------------------------------------------------------------------------------------------------------------
Func GuiCheckHex( )
	Local $Data = GUICtrlRead( @GUI_CTRLID )
	Dec ( $Data )
	If @error Then
		GUICtrlSetData( @GUI_CTRLID, "" )
	Else
		GUICtrlSetData( @GUI_CTRLID, StringUpper( $Data ) )
	EndIf
EndFunc

;------------------------------------------------------------------------------------------------------------
Func GuiRestoreMac( )
	GuiClearMac( )
	GuiChangeMac( )
EndFunc

;------------------------------------------------------------------------------------------------------------
Func GuiChangeMac( )
	Local $NewMac = GUICtrlRead( $txtMac0 ) & GUICtrlRead( $txtMac1 ) & GUICtrlRead( $txtMac2 ) & GUICtrlRead( $txtMac3 ) & GUICtrlRead( $txtMac4 ) & GUICtrlRead( $txtMac5 )
	Local $MacLen = StringLen( $NewMac )
	
	If $MacLen = 12 or $MacLen = 0 Then
		If WriteNewMac( $AdapterList, GUICtrlRead( $cboAdapters ), $NewMac ) Then
			$AdapterList = GetAdaptersList( )
			GuiShowMac( )
			
			;MsgBox features: Title=Yes, Text=Yes, Buttons=Yes and No, Default Button=Second, Icon=Warning
			If Not IsDeclared("iMsgBoxAnswer") Then Dim $iMsgBoxAnswer
			$iMsgBoxAnswer = MsgBox( 308, "Reboot system","Would you like to reboot the system for now?" )
			If $iMsgBoxAnswer = 6 Then ;Yes
				Shutdown( 2 )
			EndIf
		EndIf
	Else
		MsgBox( 0, "Error", "The new MAC address must contain 12 hex digits or empty for delete" )
	EndIf
EndFunc

;------------------------------------------------------------------------------------------------------------
Func GuiShowMac( )
	$Adapter = GUICtrlRead( $cboAdapters )
	GUICtrlSetBkColor( $gphModified, $GUI_BKCOLOR_TRANSPARENT )
	GuiClearMac( )
	If StringLen( $Adapter ) Then
		Local $i = 0
		For $i = 1 to $AdapterList[0][0]
			If $AdapterList[$i][0] = $Adapter Then
				Local $Mac = $AdapterList[$i][3]
				If StringLen( $Mac ) = 0 Then
					$Mac = $AdapterList[$i][1]
				Else
					GUICtrlSetBkColor( $gphModified, 0xFF0000 )
				EndIf
				$Mac = StringReplace( $Mac, ":", "" )
				GUICtrlSetData( $txtMac0, StringMid( $Mac, 1, 2 ) )
				GUICtrlSetData( $txtMac1, StringMid( $Mac, 3, 2 ) )
				GUICtrlSetData( $txtMac2, StringMid( $Mac, 5, 2 ) )
				GUICtrlSetData( $txtMac3, StringMid( $Mac, 7, 2 ) )
				GUICtrlSetData( $txtMac4, StringMid( $Mac, 9, 2 ) )
				GUICtrlSetData( $txtMac5, StringMid( $Mac, 11, 2 ) )
				ExitLoop
			EndIf
		Next
	EndIf
EndFunc

;------------------------------------------------------------------------------------------------------------
Func WriteNewMac( $AdapterList, $AdapterName, $NewMac = "" )
	If UBound( $AdapterList ) Then
		Local $i
		Local $AdapterKey = ""
		For $i = 1 to $AdapterList[0][0]
			If $AdapterList[$i][0] = $AdapterName Then
				$AdapterKey = $AdapterList[$i][2]
			EndIf
		Next
		If StringLen( $AdapterKey ) Then
			If StringLen( $NewMac ) Then
				RegWrite( $AdapterKey, "networkaddress", "REG_SZ", $NewMac )
			Else
				RegDelete( $AdapterKey, "networkaddress" )
			EndIf
			return 1
		EndIf
	EndIf
	return 0
EndFunc

;------------------------------------------------------------------------------------------------------------
Func GetAdaptersList( )
	Local $Adapters[1][4]
	$Adapters[0][0] = 0
	
	If @OSTYPE = "WIN32_NT" Then
		;Use WMI
		Local $o_WMIService = ObjGet( "winmgmts:\\" & @ComputerName & "\root\CIMV2" )
		Local $Items = $o_WMIService.ExecQuery( "SELECT Name, MACAddress FROM Win32_NetworkAdapter", "WQL", 0x30 )
		If IsObj( $Items ) Then
			Local $objItem
			For $objItem In $Items
				$Adapters[0][0] += 1
				ReDim $Adapters[UBound($Adapters) + 1][4]
				$Adapters[$Adapters[0][0]][0] = $objItem.Name						;adapter name
				$Adapters[$Adapters[0][0]][1] = $objItem.MACAddress					;adapter real mac address
				Local $AdapterReg = GetAdapterRegKey( $objItem.Name )
				$Adapters[$Adapters[0][0]][2] = $AdapterReg[0]						;adapter regkey
				$Adapters[$Adapters[0][0]][3] = $AdapterReg[1]						;virtual mac
			Next
		EndIf
	Else
		;Use a lista do registro se for win9x
		Local $AdapterRegList = GetAdapterRegKey( )
		Local $i = 0
		For $i = 1 to $AdapterRegList[0][0]
			$Adapters[0][0] += 1
			ReDim $Adapters[UBound($Adapters) + 1][4]
			$Adapters[$Adapters[0][0]][0] = $AdapterRegList[$i][0]				;adapter name
			$Adapters[$Adapters[0][0]][1] = ""									;adapter real mac address
			$Adapters[$Adapters[0][0]][2] = $AdapterRegList[$i][1]				;adapter regkey
			$Adapters[$Adapters[0][0]][3] = $AdapterRegList[$i][2]				;virtual mac
		Next
	EndIf
	return $Adapters
EndFunc

;------------------------------------------------------------------------------------------------------------
Func GetAdapterRegKey( $Adapter = "" )
	Local $RetVal[2]
	Local $NetKey = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}"
	If @OSTYPE = "WIN32_WINDOWS" Then
		$NetKey = "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Class\Net"
	EndIf
	Local $i = 0
	While 1
		$i += 1
		Local $Key = RegEnumKey( $NetKey, $i )
		If @error <> 0 Then ExitLoop
		Local $AdapterKey = $NetKey & "\" & $Key
		Local $j = 0
		While 1
			$j += 1
			Local $Value = RegEnumVal( $AdapterKey, $j )
			If @error <> 0 Then ExitLoop
			If $Value = "DriverDesc" Then
				If $Adapter <> "" Then
					;vai retornar somente o adaptador que pedi
					If $Adapter = RegRead( $AdapterKey , $Value ) Then
						$RetVal[0] = $AdapterKey
						$RetVal[1] = RegRead( $AdapterKey, "networkaddress" )
						ExitLoop
					EndIf
				Else
					;retorne a lista com os adaptadores
					Redim $RetVal[$i + 1][3]
					$RetVal[0][0] = $i
					$RetVal[$i][0] = RegRead( $AdapterKey , $Value )
					$RetVal[$i][1] = $AdapterKey
					$RetVal[$i][2] = RegRead( $AdapterKey, "networkaddress" )
				EndIf
			EndIf
		Wend
	Wend
	return $RetVal
EndFunc

;------------------------------------------------------------------------------------------------------------
Func ExitProgram()
	Exit
EndFunc

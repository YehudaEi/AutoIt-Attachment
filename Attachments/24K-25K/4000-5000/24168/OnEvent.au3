#include-once

Global Const $ONEVENT_FORMAT_GUI = "GUI (%s)", $ONEVENT_FORMAT_TRAY = "Tray (%s)", $ONEVENT_FORMAT_HOTKEY = "HotKey (%s)"

Global $ONEVENT_Events = ObjCreate("Scripting.Dictionary")

Func __HotKey()
	Local $s_HotKey = StringFormat($ONEVENT_FORMAT_HOTKEY, @HotKeyPressed), $a_Call, $s_Call, $i_UBound
	
	If $ONEVENT_Events.Exists($s_HotKey) Then
		$a_Call = $ONEVENT_Events.Item($s_HotKey)
		
		If IsArray($a_Call) Then
			If $a_Call[0] = "Exit" Then
				If UBound($a_Call) > 1 Then
					Exit $a_Call[1]
				Else
					Exit
				EndIf
			EndIf
			$s_Call = $a_Call[0] & "("
			$i_UBound = UBound($a_Call) - 1
		
			For $i_Count = 1 To $i_UBound
				$s_Call &= "'" & $a_Call[$i_Count] & "'"
				
				If $i_Count <> $i_UBound Then $s_Call &= ", "
			Next
			
			$s_Call &= ")"
			
			Execute($s_Call)
			
			If @error Then
				__Error("Wrong number of parameters or invalid function name in hotkey event. Check your code." & @CRLF & _
						"Function:" & @TAB & $a_Call[0] & @CRLF & _
						"HotKey:" & @TAB & $s_HotKey)
			EndIf
		EndIf
	EndIf
EndFunc

Func __GUIEvent()
	Local $i_Event = StringFormat($ONEVENT_FORMAT_GUI, @GUI_CtrlID), $a_Call, $s_Call, $i_UBound
	
	If $ONEVENT_Events.Exists($i_Event) Then
		$a_Call = $ONEVENT_Events.Item($i_Event)
		
		If IsArray($a_Call) Then
			If $a_Call[0] = "Exit" Then
				If UBound($a_Call) > 1 Then
					Exit $a_Call[1]
				Else
					Exit
				EndIf
			EndIf
			$s_Call = $a_Call[0] & "("
			$i_UBound = UBound($a_Call) - 1
		
			For $i_Count = 1 To $i_UBound
				$s_Call &= "'" & $a_Call[$i_Count] & "'"
				
				If $i_Count <> $i_UBound Then $s_Call &= ", "
			Next
			
			$s_Call &= ")"
			
			Execute($s_Call)
			
			If @error Then
				__Error("Wrong number of parameters or invalid function name in gui event. Check your code." & @CRLF & _
						"Function:" & @TAB & $a_Call[0] & @CRLF & _
						"Event:" & @TAB & $i_Event)
			EndIf
		EndIf
	EndIf
EndFunc

Func __TrayEvent()
	Local $i_Event = StringFormat($ONEVENT_FORMAT_TRAY, @TRAY_ID), $a_Call, $s_Call, $i_UBound
	
	If $ONEVENT_Events.Exists($i_Event) Then
		$a_Call = $ONEVENT_Events.Item($i_Event)
		
		If IsArray($a_Call) Then
			If $a_Call[0] = "Exit" Then
				If UBound($a_Call) > 1 Then
					Exit $a_Call[1]
				Else
					Exit
				EndIf
			EndIf
			$s_Call = $a_Call[0] & "("
			$i_UBound = UBound($a_Call) - 1
		
			For $i_Count = 1 To $i_UBound
				$s_Call &= "'" & $a_Call[$i_Count] & "'"
				
				If $i_Count <> $i_UBound Then $s_Call &= ", "
			Next
			
			$s_Call &= ")"
			
			Execute($s_Call)
			
			If @error Then
				__Error("Wrong number of parameters or invalid function name in tray event. Check your code." & @CRLF & _
						"Function:" & @TAB & $a_Call[0] & @CRLF & _
						"Event:" & @TAB & $i_Event)
			EndIf
		EndIf
	EndIf
	
EndFunc

Func _HotKeySet($s_HotKey, $s_FuncName = "", $s_Params = "")
	Local $s_HotKeyFormat = StringFormat($ONEVENT_FORMAT_HOTKEY, $s_HotKey)
	If @NumParams = 1 Then
		If $ONEVENT_Events.Exists($s_HotKeyFormat) Then
			$ONEVENT_Events.Remove($s_HotKeyFormat)
			HotKeySet($s_HotKey)
		Else
			Return SetError(1)
		EndIf
	Else
		Local $a_Params[1]
		
		If @NumParams > 2 Then
			$a_Params = StringSplit($s_Params, ",")
			
			For $x = 1 To $a_Params[0]
				$a_Params[$x] = StringStripWS($a_Params[$x], 3)
			Next
		EndIf
		
		$a_Params[0] = $s_FuncName
		
		If Not $ONEVENT_Events.Exists($s_HotKeyFormat) Then
			$ONEVENT_Events.Add($s_HotKeyFormat, $a_Params)
		Else
			$ONEVENT_Events.Item($s_HotKeyFormat) = $a_Params
		EndIf
		HotKeySet($s_HotKey, "__HotKey")
	EndIf
EndFunc

Func _GUICtrlSetOnEvent($i_Event, $s_FuncName = "", $s_Params = "")
	Local $i_Old = Opt("GUIOnEventMode", 1)
	If $i_Old <> 1 Then
		Opt("GUIOnEventMode", $i_Old)
		__Error("Not in OnEvent mode.")
		Return
	EndIf
	
	Local $s_EventFormat = StringFormat($ONEVENT_FORMAT_GUI, $i_Event)
	
	If @NumParams = 1 Then
		If $ONEVENT_Events.Exists($s_EventFormat) Then
			$ONEVENT_Events.Remove($s_EventFormat)
			GUICtrlSetOnEvent($i_Event, "")
		Else
			Return SetError(1)
		EndIf
	Else
		Local $a_Params[1]
		
		If @NumParams > 2 Then
			$a_Params = StringSplit($s_Params, ",")
			
			For $x = 1 To $a_Params[0]
				$a_Params[$x] = StringStripWS($a_Params[$x], 3)
			Next
		EndIf
		
		$a_Params[0] = $s_FuncName
		
		If Not $ONEVENT_Events.Exists($s_EventFormat) Then
			$ONEVENT_Events.Add($s_EventFormat, $a_Params)
		Else
			$ONEVENT_Events.Item($s_EventFormat) = $a_Params
		EndIf
		GUICtrlSetOnEvent($i_Event, "__GUIEvent")
	EndIf
EndFunc

Func _GUISetOnEvent($i_Event, $s_FuncName = "", $s_Params = "")
	Local $i_Old = Opt("GUIOnEventMode", 1)
	If $i_Old <> 1 Then
		Opt("GUIOnEventMode", $i_Old)
		__Error("Not in OnEvent mode.")
		Return
	EndIf
	
	Local $s_EventFormat = StringFormat($ONEVENT_FORMAT_GUI, $i_Event)
	
	If @NumParams = 1 Then
		If $ONEVENT_Events.Exists($s_EventFormat) Then
			$ONEVENT_Events.Remove($s_EventFormat)
			GUICtrlSetOnEvent($i_Event, "")
		Else
			Return SetError(1)
		EndIf
	Else
		Local $a_Params[1]
		
		If @NumParams > 2 Then
			$a_Params = StringSplit($s_Params, ",")
			
			For $x = 1 To $a_Params[0]
				$a_Params[$x] = StringStripWS($a_Params[$x], 3)
			Next
		EndIf
		
		$a_Params[0] = $s_FuncName
		
		If Not $ONEVENT_Events.Exists($s_EventFormat) Then
			$ONEVENT_Events.Add($s_EventFormat, $a_Params)
		Else
			$ONEVENT_Events.Item($s_EventFormat) = $a_Params
		EndIf
		GUISetOnEvent($i_Event, "__GUIEvent")
	EndIf
EndFunc

Func _TraySetOnEvent($i_Event, $s_FuncName = "", $s_Params = "")
	Local $i_Old = Opt("TrayOnEventMode", 1)
	If $i_Old <> 1 Then
		Opt("TrayOnEventMode", $i_Old)
		__Error("Not in OnEvent mode.")
		Return
	EndIf
	
	Local $s_EventFormat = StringFormat($ONEVENT_FORMAT_Tray, $i_Event)
	
	If @NumParams = 1 Then
		If $ONEVENT_Events.Exists($s_EventFormat) Then
			$ONEVENT_Events.Remove($s_EventFormat)
			TraySetOnEvent($i_Event, "")
		Else
			Return SetError(1)
		EndIf
	Else
		Local $a_Params[1]
		
		If @NumParams > 2 Then
			$a_Params = StringSplit($s_Params, ",")
			
			For $x = 1 To $a_Params[0]
				$a_Params[$x] = StringStripWS($a_Params[$x], 3)
			Next
		EndIf
		
		$a_Params[0] = $s_FuncName
		
		If Not $ONEVENT_Events.Exists($s_EventFormat) Then
			$ONEVENT_Events.Add($s_EventFormat, $a_Params)
		Else
			$ONEVENT_Events.Item($s_EventFormat) = $a_Params
		EndIf
		TraySetOnEvent($i_Event, "__TrayEvent")
	EndIf
EndFunc

Func _TrayItemSetOnEvent($i_Event, $s_FuncName = "", $s_Params = "")
	Local $i_Old = Opt("TrayOnEventMode", 1)
	If $i_Old <> 1 Then
		Opt("TrayOnEventMode", $i_Old)
		__Error("Not in OnEvent mode.")
		Return
	EndIf
	
	Local $s_EventFormat = StringFormat($ONEVENT_FORMAT_Tray, $i_Event)
	
	If @NumParams = 1 Then
		If $ONEVENT_Events.Exists($s_EventFormat) Then
			$ONEVENT_Events.Remove($s_EventFormat)
			TrayItemSetOnEvent($i_Event, "")
		Else
			Return SetError(1)
		EndIf
	Else
		Local $a_Params[1]
		
		If @NumParams > 2 Then
			$a_Params = StringSplit($s_Params, ",")
			
			For $x = 1 To $a_Params[0]
				$a_Params[$x] = StringStripWS($a_Params[$x], 3)
			Next
		EndIf
		
		$a_Params[0] = $s_FuncName
		
		If Not $ONEVENT_Events.Exists($s_EventFormat) Then
			$ONEVENT_Events.Add($s_EventFormat, $a_Params)
		Else
			$ONEVENT_Events.Item($s_EventFormat) = $a_Params
		EndIf
		TrayItemSetOnEvent($i_Event, "__TrayEvent")
	EndIf
EndFunc

Func __Error($s_Error)
	ConsoleWrite("! OnEvent UDF:" & @TAB & StringReplace($s_Error, @CRLF, @CRLF & "! ") & @CRLF)
EndFunc
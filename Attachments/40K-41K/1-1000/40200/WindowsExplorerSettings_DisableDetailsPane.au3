#cs
 By GreenCan
  disabling Windows Explorer Details Pane
  The aim is to enhance the performance of directory discovery part of a network drive, in particular when browsing a directory over a WAN or Cloud
  I have noticed a significant (near to tenfold) performance profit by disabling Windows Explorer display pane ( Organize / layout / Details Pane )

 Initially the key does not exist when the display pane is enabled (by default)
 In the example, I opted for deleting the key if $bDisableDetailsPane is set to true
 I have no clue what the other binary figures are meant for

#ce

Global $bDisableDetailsPane = False

If $bDisableDetailsPane Then
	; off = 0x3500000000000000000000002B020000
	$result = RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Modules\GlobalSettings\Sizer","PreviewPaneSizer","REG_BINARY",Binary('0x3500000000000000000000002B020000'))

	$result = RegRead ( "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Modules\GlobalSettings\Sizer", "PreviewPaneSizer")
	ConsoleWrite($result & @CR)
	If @error Then
		MsgBox(48,"Error","Windows Explorer settings change failed " & @CRLF & "Error " & @error)
	Else
		MsgBox(0,"","Windows Explorer settings applied")
	EndIf
Else
	; on = 0x3500000001000000000000002B020000
	; opting for deleting the key instead of replacing the bit
	; because initialy the key does not exist
	; I am not sure what the other bits are for at the moment
	$result = RegDelete("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Modules\GlobalSettings\Sizer", "PreviewPaneSizer")
	ConsoleWrite($result & @CR)
	If @error Then
		MsgBox(48,"Error","Windows Explorer settings change failed " & @CRLF & "Error " & @error)
	ElseIf $result = 0 Then
		MsgBox(0,"","Registry key does not exist")
	Else
		MsgBox(0,"","Windows Explorer settings applied")
	EndIf
EndIf


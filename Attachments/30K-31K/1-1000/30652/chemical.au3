#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

#Region ### START Koda GUI section ### Form=
Global $Text
$Form1 = GUICreate("Form1", 605, 284)
GUICtrlCreateLabel("Type some text and write simple chemical reaction or press the button", 8, 8)
$Edit1 = GUICtrlCreateEdit("", 8, 40, 585, 161, BitOR($ES_AUTOVSCROLL,$ES_AUTOHSCROLL,$ES_WANTRETURN,$WS_HSCROLL,$WS_VSCROLL,$WS_BORDER))
$ftest = "This is a test" & @CRLF
$ftest &= @TAB & "3Ca(OH)2 + 2H3PO4 --> Ca3(PO4)2 + 6H2O" & @CRLF
$ftest &= @TAB & "H3C-CH=CH2 + HCl --> H3C-CHCl-CH3" & @CRLF
$ftest &= "(tip: check the symbols - this is not implemented yet and I did it to see if it works)" & @CRLF
$ftest &= "create an empty document (.doc) first, in the script directory."
GUICtrlSetData($Edit1, $ftest)
$Button1 = GUICtrlCreateButton("Button", 400, 216, 193, 57, $WS_GROUP)
GUISetState(@SW_SHOW)

While 1
	Sleep(10)
 $nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Button1
			$sText = StringSplit(GUICtrlRead($Edit1),"",2)
			ShellExecute(@ScriptDir & "\test.doc")
			WinWaitActive("test")
			For $i = 0 To UBound($sText)-1
				Switch $i
					Case 0
						Send($sText[0],1)
					Case 1 To UBound($sText)-1
						If $sText[$i]=@LF Then
							Send("{ENTER}{DEL}")
						Else
							Select
								Case StringIsInt($sText[$i])=1
									If $sText[$i-1] = "+" Or $sText[$i-1] = " " Or $sText[$i-1]=@Lf Or $sText[$i-1]=@TAB Or StringIsInt($sText[$i-1])=1 Then
										Send($sText[$i],1)
									Else
										Send("{CTRLDOWN}{=}" & "{CTRLUP}" & $sText[$i] & "{CTRLDOWN}{=}" & "{CTRLUP}")
									EndIf
								Case Else
									Send($sText[$i],1)
							EndSelect
						EndIf
					Case UBound($sText)
						Send($sText[$i])
				EndSwitch
			Next
	EndSwitch
WEnd

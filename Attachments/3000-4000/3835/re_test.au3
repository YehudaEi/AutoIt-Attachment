;
; Test regular expressions.
;
#include <GUIConstants.au3>

$LftPos = 20
$TopPos = 20
$GuiHt = 500
$GuiWd = 350

$sKey = "HKCU\Software\Cephas\RegExp"

$sPattern = RegRead( $sKey, "Pattern" )
$sTest = RegRead( $sKey, "Input" )
$iFlag = RegRead( $sKey, "Flag" )
If $iFlag == "" Then $iFlag = 0

$iIncr = 30

$sTitle = "Regular Expression Find"

GUICreate( $sTitle & " v" & @AutoItVersion, $GuiWd, $GuiHt )

Opt( "GUICoordMode", 1 )        ; Absolute positioning

GUICtrlCreateLabel( "What is the pattern to test?",  $LftPos, $TopPos + ( $iIncr * 1 ) )
$inpPattern = GUICtrlCreateInput ( $sPattern, $LftPos, $TopPos + ( $iIncr * 1 ) + 15, 300, 20)

GUICtrlCreateLabel( "What string is the pattern to be tested against?",  $LftPos, $TopPos + ( $iIncr * 3 ) )
$inpString = GUICtrlCreateInput ( $sTest, $LftPos, $TopPos + ( $iIncr * 3 ) + 15, 300, 20)

GUICtrlCreateLabel( "What flag is to be used?",  $LftPos, $TopPos + ( $iIncr * 5 ) )
$cboFlag = GUICtrlCreateCombo( "0",  $LftPos + 170, $TopPos + ( $iIncr * 5 ), 50, 300, $CBS_DROPDOWN )
For $iCntr = 1 To 3
    GuiCtrlSetData( $cboFlag, $iCntr, $iFlag )
Next    

GUICtrlCreateGroup( "Result",  $LftPos, $TopPos + ( $iIncr * 6 ), $GuiWd - ( $LftPos * 2 ), 215 )
$lblResult = GUICtrlCreateLabel( "",  $LftPos * 2, $TopPos + ( $iIncr * 6 ) + 15, $GuiWd - ( $LftPos * 3 ), 200 )

$BtnOK = GUICtrlCreateButton( "&OK",  20, $GuiHt - 50, 50 )

$BtnCancel = GUICtrlCreateButton( "&Cancel",  $GuiWd - 70, $GuiHt - 50, 50 )

GUICtrlSetState( $inpPattern, $GUI_FOCUS )

GUISetState( @SW_SHOW )       ; will display the dialog box

$bExit = False

While Not $bExit
    $GuiMsg = GUIGetMsg()
    Select
		Case $GuiMsg = $GUI_EVENT_CLOSE
            $bExit = True
        Case $GuiMsg = $BtnCancel
            $bExit = True
        Case $GuiMsg = $BtnOk
			$sPattern = GUICtrlRead( $inpPattern )
			$sTest = GUICtrlRead( $inpString )
			$iFlag = GUICtrlRead( $cboFlag )
			TestRegExp( $sTest, $sPattern, $iFlag, $lblResult, $sTitle )
	EndSelect
WEnd
RegWrite( $sKey, "Pattern", "REG_SZ", $sPattern )
RegWrite( $sKey, "Input", "REG_SZ", $sTest )
RegWrite( $sKey, "Flag", "REG_SZ", $iFlag )
;
; Apply the test.
Func TestRegExp( $sTest, $sPattern, $iFlag, $lblResult, $sTitle )
	Local $sFound
	Local $iCntr
	Local $vResult = StringRegExp( $sTest, $sPattern, $iFlag )
	Select
		; Error.  Flag is bad.  $vResult = ""
		Case @Error == 1
			GUICtrlSetData( $lblResult, "ERROR: Bad flag" )
		;
		; Error.  The pattern was invalid.  $vResult = position in $sPattern where error occurred.
		Case @Error == 2
			GUICtrlSetData( $lblResult, "ERROR: Invalid pattern at position " & $vResult )
		;	
		; Executed properly.
		Case @Error == 0
			If @Extended Then
				; Success.  Pattern matched.  $vResult has the text from the groups or true (1), depending on flag.
				Select
					Case ( $iFlag == 0 ) Or ( $iFlag == 2 )
						; Display found.
						GUICtrlSetData( $lblResult, "Found" )
					Case ( $iFlag == 1 ) Or ( $iFlag == 3 )
						; Display array.
						If IsArray( $vResult ) Then
							$sFound = ""
							For $iCntr = 0 To ( UBound( $vResult ) - 1 )
								$sFound &= $vResult[ $iCntr ] & @CRLF
							Next
							GUICtrlSetData( $lblResult, $sFound )
						Else
							GUICtrlSetData( $lblResult, $vResult )
						EndIf
				EndSelect
			Else
				; Failure.  Pattern not matched.  $vResult = "" or false (0), depending on flag.
				GUICtrlSetData( $lblResult, "No Match" )
			EndIf
	EndSelect
EndFunc	

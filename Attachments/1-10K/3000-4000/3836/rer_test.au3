;
; Test regular expression replacements.
;
#include <GUIConstants.au3>

$LftPos = 20
$TopPos = 20
$GuiHt = 500
$GuiWd = 350

$sKey = "HKCU\Software\Cephas\RegExp"

$sPattern = RegRead( $sKey, "Pattern" )
$sString = RegRead( $sKey, "Input" )
$sRepl = RegRead( $sKey, "Replacement" )
$iCount = RegRead( $sKey, "Count" )
If $iCount == "" Then $iCount = 0

$iIncr = 30

$sTitle = "Regular Expression Replacement"

GUICreate( $sTitle & " v" & @AutoItVersion, $GuiWd, $GuiHt )

Opt( "GUICoordMode", 1 )        ; Absolute positioning

GUICtrlCreateLabel( "What is the pattern to test?",  $LftPos, $TopPos + ( $iIncr * 1 ) )
$inpPattern = GUICtrlCreateInput ( $sPattern, $LftPos, $TopPos + ( $iIncr * 1 ) + 15, 300, 20)

GUICtrlCreateLabel( "What string is the pattern to be tested against?",  $LftPos, $TopPos + ( $iIncr * 3 ) )
$inpString = GUICtrlCreateInput ( $sString, $LftPos, $TopPos + ( $iIncr * 3 ) + 15, 300, 20)

GUICtrlCreateLabel( "What is the replacement string?",  $LftPos, $TopPos + ( $iIncr * 5 ) )
$inpRepl = GUICtrlCreateInput ( $sRepl, $LftPos, $TopPos + ( $iIncr * 5 ) + 15, 300, 20)

GUICtrlCreateLabel( "How many replacements?",  $LftPos, $TopPos + ( $iIncr * 7 ) + 3 )
GUICtrlCreateLabel( "(0 = All)",  $LftPos + 240, $TopPos + ( $iIncr * 7 ) + 3 )
$cboCount = GUICtrlCreateCombo( "0",  $LftPos + 170, $TopPos + ( $iIncr * 7 ), 50, 300, $CBS_DROPDOWN )
For $iCntr = 1 To 10
    GuiCtrlSetData( $cboCount, $iCntr, $iCount )
Next    

GUICtrlCreateGroup( "Result",  $LftPos, $TopPos + ( $iIncr * 8 ), $GuiWd - ( $LftPos * 2 ), 185 )
$lblResult = GUICtrlCreateLabel( "",  $LftPos * 2, $TopPos + ( $iIncr * 8 ) + 15, $GuiWd - ( $LftPos * 3 ), 170 )

$BtnOK = GUICtrlCreateButton( "&OK",  20, $GuiHt - 50, 50 )

$BtnCancel = GUICtrlCreateButton( "&Cancel",  $GuiWd - 70, $GuiHt - 50, 50 )

GUICtrlSetState( $inpPattern, $GUI_FOCUS )

GUISetState( @SW_SHOW )       ; will display the dialog box

$bExit = False

While Not $bExit
    $GuiMsg = GUIGetMsg()
    Select
		Case $GuiMsg == $GUI_EVENT_CLOSE
            $bExit = True
        Case $GuiMsg == $BtnCancel
            $bExit = True
        Case $GuiMsg == $BtnOk
			$sPattern = GUICtrlRead( $inpPattern )
			$sTest = GUICtrlRead( $inpString )
			$sRepl = GUICtrlRead( $inpRepl )
			$iCount = GUICtrlRead( $cboCount )
			RegExpRep( $sTest, $sPattern, $sRepl, $iCount, $lblResult, $sTitle )
	EndSelect
WEnd
RegWrite( $sKey, "Pattern", "REG_SZ", $sPattern )
RegWrite( $sKey, "Input", "REG_SZ", $sString )
RegWrite( $sKey, "Replacement", "REG_SZ", $sRepl )
RegWrite( $sKey, "Count", "REG_SZ", $iCount )
;
; Apply the test.
Func RegExpRep( $sTest, $sPattern, $sRepl, $iCount, $lblResult, $sTitle )
	Local $sFound
	Local $iCntr
	Local $sDisplay
	Local $vResult = StringRegExpReplace( $sTest, $sPattern, $sRepl, $iCount )
	Select
		; Error.  Count is bad.
		Case @Error == 1
			GUICtrlSetData( $lblResult, "ERROR: Invalid count" )
		;
		; Error.  The pattern is invalid.  $vResult = position in $sPattern where error occurred.
		Case @Error == 2
			GUICtrlSetData( $lblResult, "ERROR: Invalid pattern at position " & $vResult )
		;	
		; Executed properly.
		Case @Error == 0
			$sDisplay =  "No of replacements: " & @Extended & @CRLF
			$sDisplay &= "Replaced string: " & $vResult
			GUICtrlSetData( $lblResult, $sDisplay )
	EndSelect
EndFunc	

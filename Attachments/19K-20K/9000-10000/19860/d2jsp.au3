;#AutoIt3Wrapper_run_debug_mode=Y
#include <IE.au3>
#include <Array.au3>
#include <Math.au3>
Opt("TrayIconDebug", 1)         ;0=no info, 1=debug line info

Global $Paused, $array, $Take, $Pause, $LV
HotKeySet("{PAUSE}", "TogglePause")
HotKeySet("{ESC}", "Terminate")

$charactername = ""
Global $oIE = _IEAttach("d2jsp")
;$oLV = _IEGetObjById($oIE, "pLvl")
;$LV = _IEPropertyGet($oLV, "innertext")
$LV = "20"
$Take = "Yes"
$HPMargin = .12

While 1
	
	Do 
		Sleep(Random(200, 300, 1))
		;$oIE.document.parentWindow.eval("doAttack(" & Random(0,1, 1) & ")") ;magic(1), (0) weapon
		$oIE.document.parentWindow.eval("doAttack(1)") ;magic(1), (0) weapon
		$oWinText = _IEGetObjById($oIE, "combatChoice")
		$sWinText = _IEPropertyGet($oWinText, "innertext")
		$array = StringSplit($sWinText, @CR)
		$oHP = _IEGetObjById ($oIE, "pHP")
		$sHP = _IEPropertyGet($oHP, "innertext")
		$quotientHP = Round(Execute($sHP), 2)
		Sleep(Random(100, 500, 1))
		Sleep(Random(100, 700, 1))
	;Until $array[1] = "You have vanquished your foe." Or $quotientHP < $HPMargin ; % health
	Until StringInStr($sWinText, "vanquished") Or $quotientHP < $HPMargin ; % health
	Sleep(2500) ; testing to resolve dying
	$sWinText = _IEPropertyGet($oWinText, "innertext")
	If StringInStr($sWinText, "vanquished") Then
		Sleep(Random(1000, 1500, 1))
		If $Take = "Yes" Then _TakeItem($Pause = "No")
		_Heal()
		Sleep(Random(200, 800, 1))
		_IELinkClickByText($oIE, "Fight Another Level " & $LV & " Monster", 0, 0)
		If @error Then $LV = $LV + 1
	ElseIf StringInStr($sWinText, "You have died.") Then ;dead
		;_IELinkClickByText($oIE, "Run Away", 0, 0)
		;If @error Then
		$HPMargin = $HPMargin + .03
		Sleep(Random(2000, 2500, 1))
		_IELinkClickByText($oIE, "Back to Main Menu", 0, 0)
		If @error Then MsgBox(0, "", "did not click on back to main menu", 5)
		_Heal()
		_IELinkClickByText($oIE, "Enter the Combat Arena", 0, 0)
		Sleep(Random(1200, 1800, 1))
		_IELinkClickByText($oIE, "Fight This Opponent", 0, 0)
	Else ;run
		_IELinkClickByText($oIE, "Run Away", 0, 0)
		_Heal()
		_IELinkClickByText($oIE, "Enter the Combat Arena", 0, 0)
		Sleep(Random(1400, 1700, 1))
		_IELinkClickByText($oIE, "Fight This Opponent", 0, 0)		
	EndIf
WEnd


Func _Heal()
Do 
	Sleep(500)
	$oHP = _IEGetObjById ($oIE, "pHP")
	$oMP = _IEGetObjById ($oIE, "pMP")
	$sHP = _IEPropertyGet($oHP, "innertext")
	$sMP = _IEPropertyGet($oMP, "innertext")
	$quotientHP = Round(Execute($sHP), 2)
	$quotientMP = Round(Execute($sMP), 2)
Until $quotientHP > .96 And $quotientMP > .90
Sleep(1000)
EndFunc

Func _TakeItem($Pause = "No")
	$oItem = _IEGetObjById($oIE, "drops")
	$sItem = _IEPropertyGet($oItem, "innertext")
	If StringInStr($sItem, "Take") Then
		ToolTip("Grabbing Item...")
		$oInvCount = _IEGetObjById($oIE, "invCount")
		$sInvCount = _IEPropertyGet($oInvCount, "innertext")
		$oInvSlots = _IEGetObjById($oIE, "pISlots")
		$sInvSlots = _IEPropertyGet($oInvSlots, "innertext")
		If ($sInvSlots - $sInvCount) > 0 Then ; have to do it this way
			Sleep(Random(1000, 2000, 1))
			_IELinkClickByText($oIE, "Take Item", 0, 0)
			ToolTip("")
		Else
			If $Pause = "Yes" Then TogglePause()
		EndIf
	EndIf
	ToolTip("")
EndFunc

Func Terminate()
    Exit 
EndFunc

Func TogglePause()
    $Paused = NOT $Paused
    While $Paused
        Sleep(100)
        ToolTip("Paused",0,0)
    WEnd
    ToolTip("")
EndFunc

;~ $oIE = _IEAttach("d2jsp - Ladder Slasher")
;~ $oDiv = _IEGetObjById($oIE, "pHP")
;~ $sText = _IEPropertyGet($oDiv, "innertext")
;~ ConsoleWrite("InnerText of DIV = " & $sText & @CR)
;~ $quotient = Execute($sText)
;~ ConsoleWrite("quotient = " & $quotient & @CR)
;~ ConsoleWrite("Does quotient equal 1? " & ($quotient = 1) & @CR)
;~ ConsoleWrite("Does 2 equal 1? " & (2  = 1) & @CR)
;~ 	$HP_WS = StringStripWS($HP, 8)
;~ 	$HP_Array = StringSplit($HP_WS, "/")
;~ $oIE.document.parentWindow.eval("grabItem( )") ;(1) ??
;~ $oIE.document.parentWindow.eval("doFlee( )")


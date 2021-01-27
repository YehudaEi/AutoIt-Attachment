#Include <string.au3>
#Include <array.au3>
#Include <clipboard.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GuiButton.au3>
#Include <Gui.au3>

Global $cash = String ( 1 )
Global $cashFlow = String ( 1 )
Global $health = String ( 1 )
Global $energy = String ( 1 )
Global $stamina = String ( 1 )
Global $name = String ( 1 )
Global $level = String ( 1 )
Global $mobSize = String ( 1 )
Global $income = String ( 1 )
Global $upkeep = String ( 1 )
Global $startuponce = ( 1 )
HotKeySet ( "^!x", "MyExit" )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Func start( )
WinActivate ( "Mobsters by Playdom on MySpace Apps", "" )
$errorWWA = WinWaitActive ( "Mobsters by Playdom on MySpace Apps", "" , "5" ) ; Wait for Browser to be open up on mobsters page.
browserCheck( ) ; Debug run.
EndFunc

Func browserCheck ( )
If $errorWWA = 0 Then ; Logic to test if the browser is open.
	MsgBox(0, "Error!", "Your browser is not open, or your not on the right page. "&@CRLF&"Please open it and try again." ) ; Broswer not open error message.
	Exit
	Else
	advancedStats( ) ; If browser is open, move to start of script. getStats() is a place holder
EndIf
EndFunc
	
Func advancedstats()
	MouseClick ( "", 172, 200 ) ; Click on the "Main" tab in the browser.
	Sleep ( 2000 ) ; Wait for the browser to load the "Main" page.
	MouseClickDrag ( "", 140, 156, 796, 160, 100 )
	Send ( "^c" ) ; Gather advanced stats.
	$advancedStats = ClipGet ( )
	
	$array = _StringBetween( $advancedStats, "Cash: ", "Cash flow:" )
	$cash1 = _ArrayToString( $array, "" )
	$cash = StringStripWS ( $cash1, 8 )
	
	$array = _StringBetween( $advancedStats, "Cash flow:", "Health" )
	$cashFlow1 = _ArrayToString( $array, "" )
	$cashFlow = StringStripWS ( $cashFlow1, 8 )
	
	$array = _StringBetween( $advancedStats, "Health", "Energy" )
	$health1 = _ArrayToString( $array, "" )
	$health2 = StringTrimRight ( $health1, 18 )
	$health = StringStripWS ( $health2, 8 )
	
	$array = _StringBetween( $advancedStats, "Energy", "Stamina" )
	$energy1 = _ArrayToString( $array, "" )
	$energy2 = StringTrimRight ( $energy1, 18 )
	$energy = StringStripWS ( $energy2, 8 )
	
	$stamina1 = StringTrimLeft ( $advancedStats, 97 )
	$stamina2 = StringRegExp ( $stamina1, "(\d)" , 3 )
	$stamina3 = _ArrayToString ( $Stamina2, "" )
	$stamina = StringStripWS ( $stamina3, 8 )
	
	_ClipBoard_Empty()
	
	If $startuponce = ( 1 ) Then
		getName()
	Else
		Global $startuponce = ( 0 )
		Sleep ( 20 )
		guiUpdate()
	EndIf
Exit

EndFunc

func guiUpdate()
	$namei = GUICtrlCreateInput($name, 96, 16, 75, 21)
	$healthi = GUICtrlCreateInput($health, 96, 40, 75, 21)
	$staminai = GUICtrlCreateInput($stamina, 96, 64, 75, 21)
	$energyi = GUICtrlCreateInput($energy, 96, 88, 75, 21)
	$cashflowi = GUICtrlCreateInput($cashFlow, 96, 112, 75, 21)
	Sleep ( 2500 )
	Exit
EndFunc
	
Func getName()
	If $name = ( 1 ) Then
		MouseClickDrag ( "", 911, 84, 948, 84 ) ; Click / Drag to gather Player name.
		Sleep ( 100 )
		Send ( "^c" ) ; Gather Player name.
		Global $name = ClipGet ( ) ; Get the name info saved into the clipboard and saved it into a variable.
		Sleep ( 100 )
		guiUpdate()
	Else
		Sleep ( 2500 )
		Exit
	EndIf
EndFunc

Func getLevel()
	MouseClickDrag ( "", 946, 106, 959, 106 ) ; Click / Drag to gather Player level.
	Sleep ( 100 )
	Send ( "^c" ) ; Gather Player level.
	Global $level = ClipGet ( ) ; Get the level info saved into the clipboard and saved it into a variable.
	Sleep ( 100 )
EndFunc

Func getMobSize()
	MouseClickDrag ( "", 946, 106, 959, 106 ) ; Click / Drag to gather Mob Size.
	Sleep ( 100 )
	Send ( "^c" ) ; Gather Player Mob Size.
	Global $mobSize = ClipGet ( ) ; Get the Mob Size info saved into the clipboard and saved it into a variable.
	Sleep ( 100 )
EndFunc

Func getIncome()
	MouseClick ( "", 285, 201 )
	Sleep ( 2000 )
	MouseClickDrag ( "", 391, 246, 476, 246 ) ; Click / Drag to gather income.
	Sleep ( 100 )
	Send ( "^c" ) ; Gather Player income.
	Global $income = ClipGet ( )
	Sleep ( 100 )
	MouseClickDrag ( "", 668, 246, 729, 246 ) ; Click / Drag to gather upkeep.
	Sleep ( 100 )
	Send ( "^c" ) ; Gather Player income.
	Global $upkeep = ClipGet ( )
	Sleep ( 100 )
EndFunc

;Func setData()
;	GUICtrlSetData ( controlID, data [, default] )
;	GUICtrlSetData ( controlID, data [, default] )
;	GUICtrlSetData ( controlID, data [, default] )
;	GUICtrlSetData ( controlID, data [, default] )
;	GUICtrlSetData ( controlID, data [, default] )
;	GUICtrlSetData ( controlID, data [, default] )
;	GUICtrlSetData ( controlID, data [, default] )
;	GUICtrlSetData ( controlID, data [, default] )
;EndFunc

Func inputBlock()
	BlockInput ( 1 )	
EndFunc

Func inputUnBlock()
	BlockInput ( 0 )	
EndFunc

Func MyExit()
    Exit 
EndFunc

Exit
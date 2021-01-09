#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=icoontjes\ICO\Globe.ico
#AutoIt3Wrapper_outfile=Billing.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GUIConstants.au3>
#include <EditConstants.au3>
$user = 'username'
$pass = 'password'
if _Login($user, $pass) then 
	msgbox ( 32, 'Billing Login', 'Valid username and password..')
	_MainScreen($user)
EndIf


Func _Login($setuser, $setpass)
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Billing Login", 176, 179, -1,  -1)
GUISetFont(10, 800, 0, "Arial")
GUISetBkColor(0x83B7E3)
$username = GUICtrlCreateInput("", 24, 32, 121, 24)
GUICtrlSetColor(-1, 0x83B7E3)
$Label1 = GUICtrlCreateLabel("Username:", 32, 8, 72, 20)
GUICtrlSetColor(-1, 0xFFFFFF)
$password = GUICtrlCreateInput("", 27, 96, 121, 24, $ES_PASSWORD)
GUICtrlSetColor(-1, 0x83B7E3)
$Label2 = GUICtrlCreateLabel("Password:", 35, 72, 69, 20)
GUICtrlSetColor(-1, 0xFFFFFF)
$Button1 = GUICtrlCreateButton("Login", 48, 144, 67, 25, 0)
GUICtrlSetColor(-1, 0x83B7E3)
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
			
		Case $Button1
			if GUICtrlRead($username) = $setuser and GUICtrlRead($password) = $setpass Then 
				GUIDelete($Form1)
				return 1
			EndIf
			msgbox ( 16, 'Billing Login', 'Invalid username or password, please try again', default, $Form1)

	EndSwitch
WEnd
EndFunc

Func _MainScreen($account)
$topje = RegRead('HKEY_LOCAL_MACHINE\SOFTWARE\Billing', 'months' )
$1 = StringSplit($topje, '+', 1)
$2 = Execute($topje)
$average = $2/$1[0]
$monthcash = $1[$1[0]]
if $1[$1[0]] = '' then $monthcash = '0'
$total = $2
if $total = '' then $total = '0'

$Form1 = GUICreate("Billing "&$account, 353, 181, -1, -1)
GUISetFont(10, 800, 0, "Arial")
GUISetBkColor(0x83B7E3)
$Button1 = GUICtrlCreateButton("New bill(s)", 152, 144, 83, 25, 0)
GUICtrlSetColor(-1, 0x83B7E3)
GUICtrlSetBkColor(-1, 0xFFFFFF)
$Reset = GUICtrlCreateButton("Reset cash", 50, 144, 83, 25, 0)
GUICtrlSetColor(-1, 0x83B7E3)
GUICtrlSetBkColor(-1, 0xFFFFFF)
$totali = GUICtrlCreateInput($total, 33, 96, 111, 24, $ES_READONLY)
GUICtrlSetColor(-1, 0x83B7E3)
$Label1 = GUICtrlCreateLabel("Total money:", 32, 72, 87, 20)
GUICtrlSetFont(-1, 10, 800, 0, "Arial")
GUICtrlSetColor(-1, 0xFFFFFF)
$averagei = GUICtrlCreateInput($average, 184, 96, 87, 24, $ES_READONLY)
GUICtrlSetColor(-1, 0x83B7E3)
$Label2 = GUICtrlCreateLabel("Average: (a month)", 174, 71, 125, 20)
GUICtrlSetFont(-1, 10, 800, 0, "Arial")
GUICtrlSetColor(-1, 0xFFFFFF)
$monthcashi = GUICtrlCreateInput($monthcash, 32, 32, 111, 24, $ES_READONLY)
GUICtrlSetColor(-1, 0x83B7E3)
$Label3 = GUICtrlCreateLabel("Cash last month:", 32, 8, 109, 20)
GUICtrlSetFont(-1, 10, 800, 0, "Arial")
GUICtrlSetColor(-1, 0xFFFFFF)
GUISetState(@SW_SHOW)
While 1
$nMsg = GUIGetMsg()
Switch $nMsg
Case $GUI_EVENT_CLOSE
Exit

Case $Button1
	GUIDelete($Form1)
	_BillScreen()
	
Case $Reset
	if msgbox ( 36, 'Billing', 'Are you sure you want to reset your cash?')=6 then 
		RegDelete('HKEY_LOCAL_MACHINE\SOFTWARE\Billing', 'months' )
		GUICtrlSetData($totali, '0')
		GUICtrlSetData($averagei, '0')
		GUICtrlSetData($monthcashi, '0')
	EndIf
	
EndSwitch
WEnd
EndFunc

func _BillScreen()
$topje = RegRead('HKEY_LOCAL_MACHINE\SOFTWARE\Billing', 'months' )

$Form1 = GUICreate("Billing Bill", 195, 109, -1, -1)
GUISetFont(10, 800, 0, "Arial")
GUISetBkColor(0x83B7E3)
$add = GUICtrlCreateInput("", 16, 40, 161, 24)
GUICtrlSetColor(-1, 0x83B7E3)
$Label1 = GUICtrlCreateLabel("Money earnd this month:", 16, 16, 161, 20, $ES_NUMBER)
GUICtrlSetFont(-1, 10, 800, 0, "Arial")
GUICtrlSetColor(-1, 0xFFFFFF)
$Button1 = GUICtrlCreateButton("Create Bill", 56, 72, 75, 25, 0)
GUICtrlSetColor(-1, 0x83B7E3)
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			GUIDelete($Form1)
			_MainScreen('ludocus')
			
		Case $Button1
			if GUICtrlRead($add) = '' then 
			    GUIDelete($Form1)
				_MainScreen($user)
			EndIf
			if $topje = '' then 
				RegWrite('HKEY_LOCAL_MACHINE\SOFTWARE\Billing', 'months', 'REG_SZ', GUICtrlRead($add) )
			Else
				RegWrite('HKEY_LOCAL_MACHINE\SOFTWARE\Billing', 'months', 'REG_SZ', $topje&'+'&GUICtrlRead($add) )
			EndIf
			GUIDelete($Form1)
			_MainScreen($user)

	EndSwitch
WEnd
EndFunc



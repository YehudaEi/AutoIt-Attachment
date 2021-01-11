;Created by Rad

#Include <Constants.au3>
#include <GUIConstants.au3>
#include <Array.au3>
#NoTrayIcon

Opt("TrayMenuMode",1)
$aboutitem	= TrayCreateItem("About")
$startitem	= TrayCreateItem("Start")
TrayCreateItem("")
$exititem	= TrayCreateItem("Exit")
TraySetState()

$Temp = WinList()
$Window = GUICreate("Rads Spammer", 416, 131, 379, 294)
GUISetBkColor(0xFFFFFF)
Dim $Line[5]
Dim $Windows[1]
Dim $Previews[1]
Dim $Lines
Dim	$current = 0
$Previews[0] = "Any"
$Line[0] = GUICtrlCreateInput("", 5, 5, 256, 21, -1, $WS_EX_CLIENTEDGE)
$Line[1] = GUICtrlCreateInput("", 5, 30, 256, 21, -1, $WS_EX_CLIENTEDGE)
$Line[2] = GUICtrlCreateInput("", 5, 55, 256, 21, -1, $WS_EX_CLIENTEDGE)
$Line[3] = GUICtrlCreateInput("", 5, 80, 256, 21, -1, $WS_EX_CLIENTEDGE)
$Line[4] = GUICtrlCreateInput("", 5, 105, 256, 21, -1, $WS_EX_CLIENTEDGE)
$Button = GUICtrlCreateButton("Start", 270, 100, 136, 21)
$Combo = GUICtrlCreateCombo("Any", 275, 15, 126, 21)
$Refresh = GUICtrlCreateButton("Refresh",275,38,126,16)
$Slider = GUICtrlCreateSlider(290, 55, 96, 18,$TBS_NOTICKS)
$Delay = GUICtrlCreateInput("1.00", 335, 75, 51, 18, $ES_READONLY, $WS_EX_CLIENTEDGE)
$State = "Start"
$tempcombo = GUICtrlRead($Combo)
GUICtrlSetLimit($Slider,12*4,1*4)
GUICtrlCreateGroup("", 265, 0, 146, 126)
GUICtrlCreateLabel("--", 275, 55, 11, 23)
GUICtrlSetFont(-1, 14, 1500, 0, "MS Sans Serif")
GUICtrlCreateLabel("+", 388, 55, 18, 23)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
GUICtrlCreateLabel("Delay:", 295, 77, 34, 17)
WindowList()
GUISetState(@SW_SHOW)
EstablishMessage()
HotKeySet("{ESC}","CloseSplash")
While 1
	$msg = GuiGetMsg()
	$tray = TrayGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			Exit
		Case ControlGetFocus("Rads Spammer") = "msctls_trackbar321"
			If GUICtrlRead($Slider) <> GUICtrlRead($Delay) Then GUICtrlSetData($Delay,StringFormat("%.2f ",GUICtrlRead($Slider)/4))
		Case $tray = $startitem
			If $State = "Start" Then
				$State = ChangeState($GUI_Disable)
				GetLines()
				$current = 0
				AdLibEnable("Spam",GUICtrlRead($Delay) * 1000)
				TrayItemSetText($startitem, "Stop")
			Else
				$State = ChangeState($GUI_ENABLE)
				AdLibDisable()
				$current = 0
				TrayItemSetText($startitem, "Start")
			Endif
		Case $msg = $Button
			If $State = "Start" Then
				$State = ChangeState($GUI_Disable)
				GetLines()
				$current = 0
				AdLibEnable("Spam",GUICtrlRead($Delay) * 1000)
				TrayItemSetText($startitem, "Stop")
			Else
				$State = ChangeState($GUI_ENABLE)
				AdLibDisable()
				$current = 0
				TrayItemSetText($startitem, "Start")
			Endif
		Case $tempcombo <> GUICtrlRead($Combo)
			$temp = 1
			For $i = 0 to UBound($Previews)-1
				If GUICtrlRead($Combo) = $Previews[$i] Then $Temp = 0
			Next
			If GUICtrlRead($Combo) = "Any" Then $Temp = 0
			If $temp = 1 Then 
				GUICtrlSetData($Combo,$tempcombo)
				$Temp = 0
			Endif
			$tempcombo = GUICtrlRead($Combo)
		Case $msg = $Refresh
			WindowList()
		Case $tray = $aboutitem
			SplashTextOn("Rads Spammer",EstablishMessage(),440,230)
		Case $tray = $exititem
			Exit
	EndSelect
WEnd

Func ChangeState($temp)
	GUICtrlSetState($Line[0],$temp)
	GUICtrlSetState($Line[1],$temp)
	GUICtrlSetState($Line[2],$temp)
	GUICtrlSetState($Line[3],$temp)
	GUICtrlSetState($Line[4],$temp)
	GUICtrlSetState($Combo,$temp)
	GUICtrlSetState($Slider,$temp)
	GUICtrlSetState($Delay,$temp)
	If $temp = $GUI_DISABLE Then 
		GUICtrlSetData($Button,"Stop")
		Return("Stop")
	Else
		GUICtrlSetData($Button,"Start")
		Return("Start")
	Endif
Endfunc

Func WindowList()
	Dim $Windows[1]
	Dim $Previews[1]
	GUICtrlDelete($Combo)
	$Combo = GUICtrlCreateCombo("Any", 275, 15, 126, 21)
	$WinList = WinLIst()
	$String = ""
	$Outcome = ""
	For $i = 1 to $WinList[0][0]
		$String = WiNGetState($WinList[$i][0])
		If $WinList[$i][0] <> "Program Manager" Then
			If $WinList[$i][0] <> "Rads Spammer" Then
				If $WinList[$i][0] <> "" AND $WinList[$i][0] <> " " Then
					If BitAnd($String, 2) Then
						If BitAnd($String, 4) Then
							_ArrayAdd($Windows,$WinList[$i][0])
							If StringLen($WinList[$i][0]) > 20 Then 
								_ArrayAdd($Previews,StringTrimRight($WinList[$i][0],StringLen($WinList[$i][0])-18) & " ...")
								$Outcome = $Outcome & StringTrimRight($WinList[$i][0],StringLen($WinList[$i][0])-18) & " ..." & "|"
							Endif
							If StringLen($WinList[$i][0]) <= 20 Then
								_ArrayAdd($Previews,StringTrimRight($WinList[$i][0],StringLen($WinList[$i][0])-18))
								$Outcome = $Outcome & StringTrimRight($WinList[$i][0],StringLen($WinList[$i][0])-18) & "|"
							Endif
						Endif
					EndIf
				Endif
			Endif
		Endif
	Next
	GUICtrlSetData($Combo,$Outcome)
EndFunc

Func GetWindowName()
	For $i = 1 to UBound($Previews) -1
		If GUICtrlRead($Combo) = $Previews[$i] then Return($Windows[$i])
	Next
EndFunc

Func GetLines()
	$Lines = ""
	For $i = 0 to 4
		If GUICtrlRead($Line[$i]) <> "" Then 
			$Lines = $Lines & "1"
		Else
			$Lines = $Lines & "0"
		Endif
	Next
Endfunc

Func Spam()
	$tempinteger = 0
	For $i = 1 to UBound($Windows) -1
		If WinActive($Windows[$i]) or WinActive("Rads Spammer") Then $tempinteger = 1
	Next
	If $tempinteger = 1 Then 
		If WinActive(GetWindowName()) Then
				If $Lines <> "00000" Then
					If Not WinActive("Rads Spammer") Then
						If StringMid($lines,$current+1,1) <> 1 Then
							if StringMid($lines,$current+1,1) <> 1 Then
								Do
									$current = $current + 1
									If $current > Ubound($line) Then $current = 0
								Until StringMid($lines,$current+1,1) = 1
							Endif
							For $i=0 to StringLen(GUICtrlRead($Line[$current]))
							Send(StringMid(GUICtrlRead($Line[$current]),$i,1), 1)
							Next
							Send("{ENTER}")
							$current = $current + 1
						Else
							For $i=0 to StringLen(GUICtrlRead($Line[$current]))
								Send(StringMid(GUICtrlRead($Line[$current]),$i,1), 1)
							Next
							Send("{ENTER}")
							$current = $current + 1
						Endif
					Endif
				Else
					Msgbox(64,"Error","No text entered")
					Adlibdisable()				
					$State = ChangeState($GUI_ENABLE)
					$current = 0
					TrayItemSetText($startitem, "Start")
				Endif
			Else
				If GetWindowName() = "Any" Then
					If $Lines <> "00000" Then
						If Not WinActive("Rads Spammer") Then
							If StringMid($lines,$current+1,1) <> 1 Then
								Do
									$current = $current + 1
									If $current > Ubound($line) Then $current = 0
								Until StringMid($lines,$current+1,1) = 1
								For $i=0 to StringLen(GUICtrlRead($Line[$current]))
								Send(StringMid(GUICtrlRead($Line[$current]),$i,1), 1)
								Next
								Send("{ENTER}")
								$current = $current + 1
							Else
								For $i=0 to StringLen(GUICtrlRead($Line[$current]))
									Send(StringMid(GUICtrlRead($Line[$current]),$i,1), 1)
								Next
								Send("{ENTER}")
								$current = $current + 1
							Endif
						Endif
					Else
						Msgbox(64,"Error","No text entered")
						Adlibdisable()				
						$State = ChangeState($GUI_ENABLE)
						$current = 0
						TrayItemSetText($startitem, "Start")
					Endif
				Endif
			Endif
		Endif
Endfunc

Func CloseSplash()
	SplashOff()
EndFunc

Func EstablishMessage()
	$message = _
	"Rad's Spammer" & @CRLF& @CRLF & _
	"(Press ESC to exit)" & @CRLF& @CRLF & _
	"Created with Autoit3 Beta" & @CRLF & _
	"www.autoitscript.com" & @CRLF & @CRLF & _
	"Special thanks:" & @CRLF & _
	"Jordan (Joscpe)" & @CRLF & _
	"Max (AutoIt Smith) *Forums*" & @CRLF & _
	"A few random people on MSN who probrably got pissed off"
	Return($message)
EndFunc
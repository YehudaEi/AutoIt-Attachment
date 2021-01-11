Opt("WinTitleMatchMode", 2)
#include <GUIConstants.au3>
#Include<Array.au3>
$oldtitle = ""
Global Const $AW_FADE_IN = 0x00080000 
Global Const $AW_FADE_OUT = 0x00090000
Dim $avArray[9999]
Global $1 = 1
$avArray[1] = ""
$oldtitle = ""
$originalgui = GUICreate("What message to you want to send when your friends attempt to contact you using MSN messenger?", 580, 26, -1, -1, $WS_CAPTION, BitOR($WS_EX_TOOLWINDOW, $WS_EX_TOPMOST))
GUISetBkColor(0x6BC072)
$message = GUICtrlCreateInput("I'm away... be back soon", 5, 3, 490, 20, $ES_CENTER, $WS_EX_STATICEDGE)
GUICtrlSetBkColor(-1, 0xA6D9AA)
$exit = GUICtrlCreateButton("Exit", 500, 1, 35, 23)
$ok = GUICtrlCreateButton("OK", 540, 1, 35, 23)
GuiCtrlSetState($ok, $GUI_FOCUS)
GUISetState()

While 1
	$msg = GUIGetMsg()
	If $msg = $exit Then 
		_WinAnimate($originalgui, $AW_FADE_OUT)
		Exit
		Endif
	If $msg = $ok Then
		$message = GUICtrlRead($message)
		_WinAnimate($originalgui, $AW_FADE_OUT)
		GuiDelete()
		$newgui = GUICreate("The message below will be sent to your friends when they attempt contact you.", 580, 26, -1, -1, $WS_CAPTION, BitOR($WS_EX_TOOLWINDOW, $WS_EX_TOPMOST))
			GUISetBkColor(0x6BC072)
		GuiCtrlCreatelabel($message, 5, 5, 525, 20, $ES_CENTER)
		$exit = GUICtrlCreateButton("Exit", 540, 1, 35, 23)
		_WinAnimate($newgui, $AW_FADE_IN)
		GUISetState()
		Winclose("MSN Messenger")
			Do
				$array = _ReturnMSNWins('msnmsgr.exe')
				If Isarray($array) then
					$split = Stringsplit($array[1], Chr(95))
					If $split[0]  > 0 then 
						If $split[1] <> "MSN Messenger"  then 
							$f = Stringleft($split[1], 31)
							If $f <> "Changing your personal message:" then 
								If $split[1] <> "MSN Today" then 
									$g = Stringsplit($split[1], "-")
									$h = $g[0]
									If $g[$h] <> " Alert" then 
										If _ArraySearch ($avArray, $split[1]) = -1 then
											Msgbox(0, "", "")
											Sleep(200)
											$Getname = Stringsplit($split[1], "-")
											Sleep(200)
											Winactivate($split[1])
											$getname[1] = stringleft($getname[1], 70) 
											Sleep(500)
											Send("<THIS IS AN AUTOREPLY FOR  *_|" & $getname[1] & "|_* > " & $message) ;
											Sleep(100)
											Send("{enter}")
											$avArray[$1] = $split[1]
											Sleep(50)
											$1 +=1
										Endif
									Endif
								Endif
							Endif
						Endif
					Endif
				Endif
				Sleep(50)
			Until GUIGetMsg() = $exit
			_WinAnimate($newgui, $AW_FADE_OUT)
		Exitloop
	EndIf
WEnd

Func _WinAnimate($v_gui, $i_mode, $i_duration = 250)
        DllCall("user32.dll", "int", "AnimateWindow", "hwnd", WinGetHandle($v_gui), "int", $i_duration, "long", $i_mode)
        Local $ai_gle = DllCall('kernel32.dll', 'int', 'GetLastError')
        If $ai_gle[0] <> 0 Then
            SetError(1)
            Return 0
        Return 1
    EndIf
EndFunc


Func _ReturnMSNWins($hExe)
    Local $aPList = ProcessList(), $aWList = WinList(), $sHold
    For $iCC = 1 To $aPList[0][0]
        If $aPList[$iCC][0] = $hExe Then
            For $xCC = 1 To $aWList[0][0]
                If WinGetProcess($aWList[$xCC][1]) = $aPList[$iCC][1] And _
                    BitAND(WinGetState($aWList[$xCC][1]), 2) And _
                    $aWList[$xCC][0] <> '' Then
                    $sHold &= $aWList[$xCC][0] & Chr(95)
                EndIf
            Next
        EndIf
    Next
    If $sHold Then
        Return StringSplit(StringTrimRight($sHold, 1), @LF)
    EndIf
    Return ''
EndFunc


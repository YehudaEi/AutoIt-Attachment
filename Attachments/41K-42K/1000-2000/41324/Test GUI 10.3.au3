#Region
#AutoIt3Wrapper_Version=Beta
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Description=System Checker
#AutoIt3Wrapper_Res_Fileversion=1.0.0.1
#AutoIt3Wrapper_Res_LegalCopyright=CH0VI3
#AutoIt3Wrapper_Add_Constants=n
#EndRegion

#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiIPAddress.au3>
#include <WindowsConstants.au3>
#include <Process.au3>
#include <GuiTab.au3>
#include <IE.au3>
;==============================================================================
#Region ### START Koda GUI section ### Form=E:\koda_1.7.3.0.1\Forms\CCTV.kxf
;=================== VAR ======================================================
Global $ilasttab,$SetButton[8],$UnitsCombo[8],$OK1Button[8],$RaidButton[8],$RemoteCombo[8],$OK2Button[8],$IPAddress[3],$PingButton[3], $file, $config, $SVR_selection
;=================== GUI ======================================================
$cctv = GUICreate("SERVERS", 580, 345, 193, 128)
$lab1 = GUICtrlCreateLabel("", 510, 300, 55, 30)
;===============================================
$htab = GUICtrlCreateTab(10, 10, 560, 325)
;-------------------------------------------
GUICtrlCreateTabItem("SERVERS")
For $i=0 To 7
    $SetButton[$i]=GUICtrlCreateButton("SET "&$i+1, 14+70*$i, 45, 60, 25)
    GUICtrlSetFont(-1, 8, 400, 0, "Arial")
    GUICtrlSetBkColor(-1, 6075391)
    ;-------------------------------------------
    $UnitsCombo[$i]=GUICtrlCreateCombo("UNITS", 14+70*$i, 85, 60, 25)
    GUICtrlSetFont(-1, 8, 400, 0, "Arial")
    For $j=1 To 15+10*($i<3)+25*($i<2)
        GUICtrlSetData(-1,"SVR "&$j)
    Next
    $OK1Button[$i] = GUICtrlCreateButton("OK", 14+70*$i, 110, 60, 17)
    GUICtrlSetFont(-1, 8, 400, 0, "Arial")
    GUICtrlSetBkColor(-1, 65280)
Next
;=========================================================
GUICtrlCreateTabItem("STORAGE")
For $i=0 To 7
    $RaidButton[$i] = GUICtrlCreateButton("SAN "&$i+1, 14+70*$i, 45, 60, 25)
    GUICtrlSetFont(-1, 8, 400, 0, "Arial")
    GUICtrlSetBkColor(-1, 16776960)
Next
;=========================================================
GUICtrlCreateTabItem("REMOTE")
For $i=0 To 7
    $RemoteCombo[$i]=GUICtrlCreateCombo("Remote", 14+70*$i, 85, 60, 25)
    GUICtrlSetFont(-1, 7, 400, 0, "Arial")
    For $j=1 To 15+10*($i<3)+25*($i<2)
        GUICtrlSetData(-1,"SVR "&$j)
    Next
    $OK2Button[$i] = GUICtrlCreateButton("OK", 14+70*$i, 110, 60, 17)
    GUICtrlSetFont(-1, 8, 400, 0, "Arial")
    GUICtrlSetBkColor(-1, 65280)
Next
;=========================================================
GUICtrlCreateTabItem("EXTRAS")

$config = GUICtrlCreateButton("V5.0", 14, 90, 65, 25)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
;-------------------------------------------
$config1 = GUICtrlCreateButton("V5.3", 79, 90, 65, 25)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
;-------------------------------------------
$config2 = GUICtrlCreateButton("V6.0", 144, 90, 65, 25)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
;-------------------------------------------
$config3 = GUICtrlCreateButton("V6.1", 209, 90, 65, 25)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
;-------------------------------------------
$macadd = GUICtrlCreateButton("TELNET", 14, 50, 65, 25)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
;-------------------------------------------
$note = GUICtrlCreateButton("NOTEPAD", 79, 50, 65, 25)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
;-------------------------------------------
For $i=0 To 2
    $ipaddress[$i] = _GUICtrlIpAddress_Create($cctv, 14, 295-40*$i, 130, 25)
    _GUICtrlIpAddress_Set($ipaddress[$i], "0.0.0.0")
    _GUICtrlIpAddress_ShowHide($ipaddress[$i], @SW_HIDE)
    $PingButton[$i] = GUICtrlCreateButton("GO", 145, 295-40*$i, 40, 25)
    GUICtrlSetFont(-1, 8, 400, 0, "Arial")
    If $i<>1 Then GUICtrlSetBkColor(-1, 2842846)
Next
;-------------------------------------------
$pingjnb = GUICtrlCreateButton("SVR PING", 14, 120, 65, 25)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
;-------------------------------------------
$lab2 = GUICtrlCreateLabel("Telnet Cameras", 14, 240, 80, 15)
$lab3 = GUICtrlCreateLabel("Ping Cameras", 14, 280, 80, 15)
$lab4 = GUICtrlCreateLabel("IEXPL Cameras", 14, 200, 80, 15)
$lab5 = GUICtrlCreateLabel("Configurators", 14, 76, 80, 15)
;-------------------------------------------
#EndRegion
_Tick()
_Buttons($SVR_selection)
AdlibRegister("_Tick",1000)

GUISetState()

Do
    $nmsg = GUIGetMsg()
    For $i=0 To 7
        ; Button2
      If $nmsg=$SetButton[$i] Then ;MsgBox(0,"","My control_ID is "&$nmsg-$htab&@CRLF&"and i am on Tab# "&Int($nmsg/4))
		$i =2
		$sfilespec = "Filename"
            $file = FileOpen($sfilespec, 0)
            If $file = -1 Then
                MsgBox(0, "Error", "Unable to open data file: '" & $sfilespec & "'")
                ContinueLoop
            EndIf
            While 2
                $sline = FileReadLine($file)
               If @error = -1 Then ExitLoop
              $swindowtitle = "Telnet " & $sline
                $result = Run(@ComSpec & " /c telnet " & $sline)
                If $result <> 0 Then
                    Sleep(500)
                    WinActivate($swindowtitle)
                    Sleep(200)
					Send("Key")
					Sleep(300)
					Send("Key")
					Sleep(300)
					Send("Key")
					Sleep(300)
					Send("Key")
					Sleep(300)
               Else
                  MsgBox(0, "Error", "Failed to run Telnet for server '" & $sline & "'!")
                EndIf
            WEnd
        EndIf
		; Button5
	If $nmsg=$SetButton[$i] Then ;MsgBox(0,"","My control_ID is "&$nmsg-$htab&@CRLF&"and i am on Tab# "&Int($nmsg/4))
		$i =5
		$sfilespec = "Filename"
            $file = FileOpen($sfilespec, 0)
            If $file = -1 Then
                MsgBox(0, "Error", "Unable to open data file: '" & $sfilespec & "'")
                ContinueLoop
            EndIf
            While 2
                $sline = FileReadLine($file)
               If @error = -1 Then ExitLoop
              $swindowtitle = "Telnet " & $sline
                $result = Run(@ComSpec & " /c telnet " & $sline)
                If $result <> 0 Then
                    Sleep(500)
                    WinActivate($swindowtitle)
                    Sleep(200)
					Send("Key")
					Sleep(300)
					Send("Key")
					Sleep(300)
					Send("Key")
					Sleep(300)
					Send("Key")
					Sleep(300)
               Else
                  MsgBox(0, "Error", "Failed to run Telnet for server '" & $sline & "'!")
			  EndIf
			  WEnd
		  EndIf
		; Button8
		If $nmsg=$SetButton[$i] Then ;MsgBox(0,"","My control_ID is "&$nmsg-$htab&@CRLF&"and i am on Tab# "&Int($nmsg/4))
		$i =8
		$sfilespec = "Filename"
            $file = FileOpen($sfilespec, 0)
            If $file = -1 Then
                MsgBox(0, "Error", "Unable to open data file: '" & $sfilespec & "'")
                ContinueLoop
            EndIf
            While 2
                $sline = FileReadLine($file)
               If @error = -1 Then ExitLoop
              $swindowtitle = "Telnet " & $sline
                $result = Run(@ComSpec & " /c telnet " & $sline)
                If $result <> 0 Then
                    Sleep(500)
                    WinActivate($swindowtitle)
                    Sleep(200)
					Send("Key")
					Sleep(300)
					Send("Key")
					Sleep(300)
					Send("Key")
					Sleep(300)
					Send("Key")
					Sleep(300)
               Else
                  MsgBox(0, "Error", "Failed to run Telnet for server '" & $sline & "'!")
                EndIf
            WEnd
        EndIf
		; Button11
		If $nmsg=$SetButton[$i] Then ;MsgBox(0,"","My control_ID is "&$nmsg-$htab&@CRLF&"and i am on Tab# "&Int($nmsg/4))
		$i =11
		$sfilespec = "Filename"
            $file = FileOpen($sfilespec, 0)
            If $file = -1 Then
                MsgBox(0, "Error", "Unable to open data file: '" & $sfilespec & "'")
                ContinueLoop
            EndIf
            While 2
                $sline = FileReadLine($file)
               If @error = -1 Then ExitLoop
              $swindowtitle = "Telnet " & $sline
                $result = Run(@ComSpec & " /c telnet " & $sline)
                If $result <> 0 Then
                    Sleep(500)
                    WinActivate($swindowtitle)
                    Sleep(200)
					Send("Key")
					Sleep(300)
					Send("Key")
					Sleep(300)
					Send("Key")
					Sleep(300)
					Send("Key")
					Sleep(300)
               Else
                  MsgBox(0, "Error", "Failed to run Telnet for server '" & $sline & "'!")
                EndIf
            WEnd
        EndIf
		; Button14
		If $nmsg=$SetButton[$i] Then ;MsgBox(0,"","My control_ID is "&$nmsg-$htab&@CRLF&"and i am on Tab# "&Int($nmsg/4))
		$i =14
		$sfilespec = "Filename"
            $file = FileOpen($sfilespec, 0)
            If $file = -1 Then
                MsgBox(0, "Error", "Unable to open data file: '" & $sfilespec & "'")
                ContinueLoop
            EndIf
            While 2
                $sline = FileReadLine($file)
               If @error = -1 Then ExitLoop
              $swindowtitle = "Telnet " & $sline
                $result = Run(@ComSpec & " /c telnet " & $sline)
                If $result <> 0 Then
                    Sleep(500)
                    WinActivate($swindowtitle)
                    Sleep(200)
					Send("Key")
					Sleep(300)
					Send("Key")
					Sleep(300)
					Send("Key")
					Sleep(300)
					Send("Key")
					Sleep(300)
               Else
                  MsgBox(0, "Error", "Failed to run Telnet for server '" & $sline & "'!")
                EndIf
            WEnd
        EndIf
		; Button17
		If $nmsg=$SetButton[$i] Then ;MsgBox(0,"","My control_ID is "&$nmsg-$htab&@CRLF&"and i am on Tab# "&Int($nmsg/4))
		$i =17
		$sfilespec = "Filename"
            $file = FileOpen($sfilespec, 0)
            If $file = -1 Then
                MsgBox(0, "Error", "Unable to open data file: '" & $sfilespec & "'")
                ContinueLoop
            EndIf
            While 2
                $sline = FileReadLine($file)
               If @error = -1 Then ExitLoop
              $swindowtitle = "Telnet " & $sline
                $result = Run(@ComSpec & " /c telnet " & $sline)
                If $result <> 0 Then
                    Sleep(500)
                    WinActivate($swindowtitle)
                    Sleep(200)
					Send("Key")
					Sleep(300)
					Send("Key")
					Sleep(300)
					Send("Key")
					Sleep(300)
					Send("Key")
					Sleep(300)
               Else
                  MsgBox(0, "Error", "Failed to run Telnet for server '" & $sline & "'!")
                EndIf
            WEnd
        EndIf
		; Button20
		If $nmsg=$SetButton[$i] Then ;MsgBox(0,"","My control_ID is "&$nmsg-$htab&@CRLF&"and i am on Tab# "&Int($nmsg/4))
		$i =20
		$sfilespec = "Filename"
            $file = FileOpen($sfilespec, 0)
            If $file = -1 Then
                MsgBox(0, "Error", "Unable to open data file: '" & $sfilespec & "'")
                ContinueLoop
            EndIf
            While 2
                $sline = FileReadLine($file)
               If @error = -1 Then ExitLoop
              $swindowtitle = "Telnet " & $sline
                $result = Run(@ComSpec & " /c telnet " & $sline)
                If $result <> 0 Then
                    Sleep(500)
                    WinActivate($swindowtitle)
                    Sleep(200)
					Send("Key")
					Sleep(300)
					Send("Key")
					Sleep(300)
					Send("Key")
					Sleep(300)
					Send("Key")
					Sleep(300)
               Else
                  MsgBox(0, "Error", "Failed to run Telnet for server '" & $sline & "'!")
                EndIf
            WEnd
        EndIf
		; Button23
		If $nmsg=$SetButton[$i] Then ;MsgBox(0,"","My control_ID is "&$nmsg-$htab&@CRLF&"and i am on Tab# "&Int($nmsg/4))
		$i =23
		$sfilespec = "Filename"
            $file = FileOpen($sfilespec, 0)
            If $file = -1 Then
                MsgBox(0, "Error", "Unable to open data file: '" & $sfilespec & "'")
                ContinueLoop
            EndIf
            While 2
                $sline = FileReadLine($file)
               If @error = -1 Then ExitLoop
              $swindowtitle = "Telnet " & $sline
                $result = Run(@ComSpec & " /c telnet " & $sline)
                If $result <> 0 Then
                    Sleep(500)
                    WinActivate($swindowtitle)
                    Sleep(200)
					Send("Key")
					Sleep(300)
					Send("Key")
					Sleep(300)
					Send("Key")
					Sleep(300)
					Send("Key")
					Sleep(300)
               Else
                  MsgBox(0, "Error", "Failed to run Telnet for server '" & $sline & "'!")
                EndIf
            WEnd
        EndIf
		; Button4 - SVR1
		If $nmsg=$OK1Button[$i] Then
			$SVR_selection = GUICtrlRead($UnitsCombo[$i],$j)
		_Buttons($SVR_selection)

		;Button4 - SVR2
		 If $nmsg=$OK1Button[$i] Then
		$SVR_selection = GUICtrlRead($UnitsCombo[$i],$j)
			If $SVR_selection = "SVR 2" Then
					$sfilespec = "Filename"
					$file = FileOpen($sfilespec, 0)
					If $file = -1 Then
						MsgBox(0, "Error", "Unable to open data file: '" & $sfilespec & "'")
						Exit
					EndIf
					While 1
						$sline = FileReadLine($file)
						If @error = -1 Then ExitLoop
						$swindowtitle = "Telnet " & $sline
						$result = Run(@ComSpec & " /c telnet " & $sline)
						If $result <> 0 Then
							Sleep(500)
							WinActivate($swindowtitle)
							Sleep(400)
							Send("Key")
							Sleep(300)
							Send("Key")
							Sleep(400)
							Send("Key")
							Sleep(300)
							Send("Key")
							Sleep(300)
						Else
							MsgBox(0, "Error", "Failed to run Telnet for server '" & $sline & "'!")
						EndIf
					WEnd
				EndIf
			EndIf
			EndIf
		Next
		For $i=0 To 2
       If $nmsg=$PingButton[2] Then ;MsgBox(0,"","My control_ID is "&$nmsg-$htab&@CRLF&"and i am on Tab# "&Int($nmsg/4))
			$i=61
			$s_ip1 = _GUICtrlIpAddress_Get($ipaddress[2])
			If Ping($s_ip1) > 0 Then
				$oie = _IECreate("")
				If $s_ip1 <> 0 Then
				EndIf
				Sleep(500)
				Send("{TAB}")
				Sleep(500)
				Send($s_ip1)
				Sleep(300)
				Send("{ENTER}")
				Sleep(300)
			Else
				MsgBox(0, "Error", "Failed to run Telnet for server '" & $sline & "'!")
			EndIf
		EndIf
		If $nmsg=$PingButton[1] Then
			$i=60
		$s_ip = _GUICtrlIpAddress_Get($ipaddress[1])
			If Ping($s_ip) > 0 Then
				Run(@ComSpec & " /c telnet ")
				If $s_ip <> 0 Then
				EndIf
				Sleep(500)
				Send("o")
				Sleep(500)
				Send("{SPACE}")
				Sleep(500)
				Send($s_ip)
				Sleep(300)
				Send("{ENTER}")
				Sleep(300)
			Else
				MsgBox(0, "Error", "Failed to run Telnet for server '" & $sline & "'!")
			EndIf
		EndIf
		If $nmsg=$PingButton[0] Then
			$i=59
		$s_ip = _GUICtrlIpAddress_Get($ipaddress[0])
			If Ping($s_ip) > 0 Then
				MsgBox(0, "Ping Test", "Reply")
			Else
				MsgBox(0, "Ping Test", "No Reply")
			EndIf
		EndIf
		Next

;	   If $nmsg=$OK1Button[$i] Then ; function
;       If $nmsg=$RaidButton[$i] Then ; function

    $icurrtab = _GUICtrlTab_GetCurFocus($htab)
    If $icurrtab <> $ilasttab Then
        $ilasttab = $icurrtab
        For $i=0 To 2
            If $icurrtab=3 Then
                _GUICtrlIpAddress_ShowHide($IPAddress[$i], @SW_SHOW)
            Else
                _GUICtrlIpAddress_ShowHide($IPAddress[$i], @SW_HIDE)
            EndIf
        Next
    EndIf
Until $nmsg=$gui_event_close

Func _Buttons($SVR_selection)
	If $SVR_selection = "SVR" & $i Then
					$sfilespec = "Filename"
					$file = FileOpen($sfilespec, 0)
					If $file = -1 Then
						MsgBox(0, "Error", "Unable to open data file: '" & $sfilespec & "'")
						Exit
					EndIf
					While 1
						$sline = FileReadLine($file)
						If @error = -1 Then ExitLoop
						$swindowtitle = "Telnet " & $sline
						$result = Run(@ComSpec & " /c telnet " & $sline)
						If $result <> 0 Then
							Sleep(500)
							WinActivate($swindowtitle)
							Sleep(400)
							Send("Key")
							Sleep(300)
							Send("Key")
							Sleep(400)
							Send("Key")
							Sleep(300)
							Send("Key")
							Sleep(300)
						Else
							MsgBox(0, "Error", "Failed to run Telnet for server '" & $sline & "'!")
						EndIf
					WEnd
				EndIf
			EndFunc

Func _Tick()
    GUICtrlSetData($lab1,@HOUR & ":" & @MIN & ":" & @SEC & " " & @MON & "-" & @MDAY & "-" & @YEAR)
EndFunc
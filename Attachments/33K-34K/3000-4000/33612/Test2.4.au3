#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiIPAddress.au3>
#include <WindowsConstants.au3>
#include <Process.au3>

$s_data15 = "ARC 1|ARC 2|ARC 3|ARC 4|ARC 5|ARC 6|ARC 7|ARC 8|ARC 9|ARC 10|ARC 11|ARC 12|ARC 13|ARC 14|ARC 15"
$s_data25 = $s_data15 & "|ARC 16|ARC 17|ARC 18|ARC 19|ARC 20|ARC 21|ARC 22|ARC 23|ARC 24|ARC 25 "
$s_data35 = $s_data25 & "|ARC 26|ARC 27|ARC 28|ARC 29|ARC 30|ARC 31|ARC 32|ARC 33|ARC 34|ARC 35"
$s_data45 = $s_data35 & "|ARC 36|ARC 37|ARC 38|ARC 39|ARC 40|ARC 41|ARC 42|ARC 43|ARC 44|ARC 45"
$CCTV = GUICreate("RSA CCTV SERVERS", 560, 327, 200, 113, BitOR($WS_MAXIMIZEBOX, $WS_MINIMIZEBOX, $WS_SYSMENU, $WS_CAPTION, $WS_POPUP, $WS_POPUPWINDOW, $WS_GROUP, $WS_TABSTOP, $WS_BORDER, $WS_CLIPSIBLINGS))
$JNB = GUICtrlCreateButton("JNB - A", 0, 8, 65, 25)
$CT = GUICtrlCreateButton("CT - A", 70, 8, 65, 25)
$DBN = GUICtrlCreateButton("DBN - A", 140, 8, 65, 25)
$PE = GUICtrlCreateButton("PE - A", 210, 8, 65, 25)
$EL = GUICtrlCreateButton("EL - A", 280, 8, 65, 25)
$UT = GUICtrlCreateButton("UT - A", 350, 8, 65, 25)
$BFT = GUICtrlCreateButton("BFT - A", 420, 8, 65, 25)
$CORP = GUICtrlCreateButton("CORP - A", 490, 8, 65, 25)
$JNBARC = GUICtrlCreateCombo("JNBARC", 0, 46, 65, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, $s_data45)
$Input1 = GUICtrlCreateInput("", 0, 160, 65, 25)
$CTARC = GUICtrlCreateCombo("CTARC", 70, 46, 65, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, $s_data35)
$DBNARC = GUICtrlCreateCombo("DBNARC", 140, 46, 65, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, $s_data25)
$PEARC = GUICtrlCreateCombo("PEARC", 210, 46, 65, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, $s_data15)
$ELARC = GUICtrlCreateCombo("ELARC", 280, 46, 65, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, $s_data15)
$UTARC = GUICtrlCreateCombo("UTARC", 350, 46, 65, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, $s_data15)
$BFTARC = GUICtrlCreateCombo("BFTARC", 420, 46, 65, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, $s_data15)
$CORPARC = GUICtrlCreateCombo("CORPARC", 490, 46, 65, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, $s_data15)
$IPAddress1 = _GUICtrlIpAddress_Create($CCTV, 0, 279, 130, 25)
_GUICtrlIpAddress_Set($IPAddress1, "0.0.0.0")
$JNB1 = GUICtrlCreateButton("OK", 0, 80, 65, 17)
$CT1 = GUICtrlCreateButton("OK", 70, 80, 65, 17)
$DBN1 = GUICtrlCreateButton("OK", 140, 80, 65, 17)
$PE1 = GUICtrlCreateButton("OK", 210, 80, 65, 17)
$EL1 = GUICtrlCreateButton("OK", 280, 80, 65, 17)
$UT1 = GUICtrlCreateButton("OK", 350, 80, 65, 17)
$BFT1 = GUICtrlCreateButton("OK", 420, 80, 65, 17)
$CORP1 = GUICtrlCreateButton("OK", 490, 80, 65, 17)
$PINGB = GUICtrlCreateButton("GO", 135, 279, 35, 25)
$JNBRAID = GUICtrlCreateButton("JNB - R", 0, 120, 65, 25)
$CTRAID = GUICtrlCreateButton("CT - R", 70, 120, 65, 25)
$DBNRAID = GUICtrlCreateButton("DBN - R", 140, 120, 65, 25)
$PERAID = GUICtrlCreateButton("PE - R", 210, 120, 65, 25)
$ELRAID = GUICtrlCreateButton("EL - R", 280, 120, 65, 25)
$UTRAID = GUICtrlCreateButton("UT - R", 350, 120, 65, 25)
$BFTRAID = GUICtrlCreateButton("BFT - R", 420, 120, 65, 25)
$CORPRAID = GUICtrlCreateButton("CORP - R", 490, 120, 65, 25)
$CONFIG = GUICtrlCreateButton("CONFIG", 184, 280, 75, 25)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
    $nMsg = GUIGetMsg()
    Switch $nMsg
        Case $GUI_EVENT_CLOSE
            Exit
        Case $JNB
            RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ORTIA.vbs"')
        Case $CT
            RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\CTIA.vbs"')
        Case $DBN
            RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\KSIA.vbs"')
        Case $PE
            RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\PEIA.vbs"')
        Case $EL
            RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\EL.vbs"')
        Case $UT
            RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\UIA.vbs"')
        Case $BFT
            RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\BFT.vbs"')
        Case $CORP
            RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ACSAC.vbs"')
        Case $JNBRAID
            RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ORTIA RAIDS.vbs"')
        Case $CTRAID
            RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\CTIA RAIDS.vbs"')
        Case $DBNRAID
            RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\KSIA RAIDS.vbs"')
        Case $PERAID
            RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\PE RAIDS.vbs"')
        Case $ELRAID
            RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\EL RAIDS.vbs"')
        Case $UTRAID
            RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\UIA RAIDS.vbs"')
        Case $BFTRAID
            RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\BFT RAIDS.vbs"')
        Case $CORPRAID
            RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ACSAC RAIDS.vbs"')

----------------------------------------------------------------------------------------------------------------
	   Case $PINGB
            $s_ip = _GUICtrlIpAddress_Get($IPAddress1)
            If Ping($s_ip) > 0 Then
                MsgBox(0, "Ping Test", "Reply")
            Else
                MsgBox(0, "Ping Test", "No Reply")
            EndIf
-----------------------------------------------------------------------------------------------------------------
		Case $CONFIG
            Run("C:\SVR\DVTel Unified Configurator.exe")
-----------------------------------------------------------------------------------------------------------------
		case $JNB1
            ControlFocus($CCTV,"",$JNBARC)
            Send(GUICtrlRead($Input1))
-----------------------------------------------------------------------------------------------------------------
		Case $JNB1 ;If this button is pressed
            $JNBARC_Selection = GUiCtrlRead($JNBARC) ;We are getting the selection of the corresponding dropdown
            Switch $JNBARC_Selection ;Does this look familiar???
			Case "ARC 1"
                   RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ARC\JNB1.vbs"')
			Case "ARC 2"
                   RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ARC\JNB2.vbs"')
			Case "ARC 3"
                   RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ARC\JNB3.vbs"')
			Case "ARC 4"
                   RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ARC\JNB4.vbs"')
			Case "ARC 5"
                   RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ARC\JNB5.vbs"')
			Case "ARC 6"
                   RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ARC\JNB6.vbs"')
			Case "ARC 7"
                   RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ARC\JNB7.vbs"')
			Case "ARC 8"
                   RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ARC\JNB8.vbs"')
			Case "ARC 9"
                   RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ARC\JNB9.vbs"')
			Case "ARC 10"
                   RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ARC\JNB10.vbs"')
			Case "ARC 11"
                   RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ARC\JNB11.vbs"')
			Case "ARC 12"
                   RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ARC\JNB12.vbs"')
			Case "ARC 13"
                   RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ARC\JNB13.vbs"')
			Case "ARC 14"
                   RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ARC\JNB14.vbs"')
			Case "ARC 15"
                   RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ARC\JNB15.vbs"')
			Case "ARC 16"
                   RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ARC\JNB16.vbs"')
			Case "ARC 17"
                   RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ARC\JNB17.vbs"')
			Case "ARC 18"
                   RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ARC\JNB18.vbs"')
			Case "ARC 19"
                   RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ARC\JNB19.vbs"')
			Case "ARC 20"
                   RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ARC\JNB20.vbs"')
			Case "ARC 21"
                   RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ARC\JNB21.vbs"')
			Case "ARC 22"
                   RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ARC\JNB22.vbs"')
			Case "ARC 23"
                   RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ARC\JNB23.vbs"')
			Case "ARC 24"
                   RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ARC\JNB24.vbs"')
			Case "ARC 25"
                   RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ARC\JNB25.vbs"')
			Case "ARC 26"
                   RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ARC\JNB26.vbs"')
			Case "ARC 27"
                   RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ARC\JNB27.vbs"')
			Case "ARC 28"
                   RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ARC\JNB28.vbs"')
			Case "ARC 29"
                   RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ARC\JNB29.vbs"')
			Case "ARC 30"
                   RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ARC\JNB30.vbs"')
			Case "ARC 31"
                   RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ARC\JNB31.vbs"')
			Case "ARC 32"
                   RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ARC\JNB32.vbs"')
			Case "ARC 33"
                   RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ARC\JNB33.vbs"')
			Case "ARC 34"
                   RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ARC\JNB34.vbs"')
			Case "ARC 35"
                   RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ARC\JNB35.vbs"')
			Case "ARC 36"
                   RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ARC\JNB36.vbs"')
			Case "ARC 37"
                   RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ARC\JNB37.vbs"')
			Case "ARC 38"
                   RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ARC\JNB38.vbs"')
			Case "ARC 39"
                   RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ARC\JNB39.vbs"')
			Case "ARC 40"
                   RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ARC\JNB40.vbs"')
			Case "ARC 41"
                   RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ARC\JNB41.vbs"')
			Case "ARC 42"
                   RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ARC\JNB42.vbs"')
			Case "ARC 43"
                   RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ARC\JNB43.vbs"')
			Case "ARC 44"
                   RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ARC\JNB44.vbs"')
			Case "ARC 45"
                   RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\ARC\JNB45.vbs"')
		EndSwitch
------------------------------------------------------------------------------------------------------------------
		Case $UT1 ;If this button is pressed
            $UTARC_Selection = GUiCtrlRead($UTARC) ;We are getting the selection of the corresponding dropdown
            Switch $UTARC_Selection ;Does this look familiar???
                Case "ARC 1"
                   RunWait(@ComSpec & ' /c WScript.exe "C:\SVR\UT1.vbs"')
		   EndSwitch
		EndSwitch

	WEnd
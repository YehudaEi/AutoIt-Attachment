#include <GUIConstantsEx.au3>
#include <GUIConstants.au3>
#include <WindowsConstants.au3>
#include <Process.au3>
#include <MsgBoxConstants.au3>
#include <WinAPI.au3>
#include <Constants.au3>
#include <GuiComboBox.au3>
#include <Date.au3>
#NoTrayIcon
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GDIPlus.au3>

;#Region Metro Style GUI



Global $oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")
Global $anamnesi = ""
Global $parameter = ""
Global $name = ""
Global $lastName = ""
Global $id = ""
Global $sex = ""
Global $weight = ""
Global $height = ""
Global $birthDate = ""
Global $boolck1=False
Global $boolck2=False
Global $boolck3=False
Global $boolck4=False
Global $boolsx=False
$color=0
Opt('PixelCoordMode', 1) ;Uses pixel coords relative to the absolute screen coordinates

GUIRegisterMsg(0xF, "WM_PAINT")

;~ GUICreate("ciao", 100, 100)
;~ GUISetState()

;~ MsgBox(16,"ciao","")

;$pid = Run("C:\pcekg\exe\wincrx32.exe", "", @SW_MAXIMIZE)

;ProcessWait($pid)

Global $title1 = "status"
Global $title2 = "main"
Global $title3 = "tool"
Global $title4 = "ecg1"
Global $title5 = "ecg2"
Global $title6 = "ecg3"
Global $title7 = "ecg4"

Global $width1 = 800
Global $height1 = 40
Global $width2 = 800
Global $height2 = 800
Global $width3 = 200
Global $height3 = 100
Global $width4 = 800
Global $height4 = 100
Global $width5 = 200
Global $height5 = 100

Global $msg
Sleep(4000)

nuovo()



Func nuovo()



if $color=0 Then
$GUIThemeColor = "0x009933"
$FontThemeColor = "0xFFFFFF"
$GUIControlThemeColorBG = StringReplace($GUIThemeColor, "0x", "0xFF")
$GUIControlThemeColor = StringReplace("0xFFFFFF", "0x", "0xFF");"0xff0099CC"
$borderCol = "0xFFFFFF";"0x0099CC"
$ButtonColorb_d = "0xff80CC99" ;"0x00a6d2", "0x", "0xFF")
$ButtonColorb_w = "0xffffffff";"0xff0077AA"
$ButtonColorb = "0xff009933";"0xff0099CC"
$FontButton_w = "0xffffffff"
$FontButton = "0xff009933"
$FontButton_h = "0xffffffff"
ElseIf $color=1 Then
$GUIThemeColor = "0x0099CC"
$FontThemeColor = "0xFFFFFF"
$GUIControlThemeColorBG = StringReplace($GUIThemeColor, "0x", "0xFF")
$GUIControlThemeColor = StringReplace("0xFFFFFF", "0x", "0xFF");"0xff0099CC"
$borderCol = "0xFFFFFF";"0x0099CC"
$ButtonColorb_d = "0xff0077AA" ;"0x00a6d2", "0x", "0xFF")
$ButtonColorb_w = "0xffffffff";"0xff0077AA"
$ButtonColorb = "0xff0099CC";"0xff0099CC"
$FontButton_w = "0xffffffff"
$FontButton = "0xff0099CC"
$FontButton_h = "0xffffffff"
ElseIf $color=2 Then
$GUIThemeColor = "0x0077AA"
$FontThemeColor = "0xFFFFFF"
$GUIControlThemeColorBG = StringReplace($GUIThemeColor, "0x", "0xFF")
$GUIControlThemeColor = StringReplace("0xFFFFFF", "0x", "0xFF");"0xff0099CC"
$borderCol = "0xFFFFFF";"0x0099CC"
$ButtonColorb_d = "0xff0099CC" ;"0x00a6d2", "0x", "0xFF")
$ButtonColorb_w = "0xffffffff";"0xff0077AA"
$ButtonColorb = "0xff0077AA";"0xff0099CC"
$FontButton_w = "0xffffffff"
$FontButton = "0xff0099CC"
$FontButton_h = "0xffffffff"
ElseIf $color=3 Then
$GUIThemeColor = "0xFFFFFF"
$FontThemeColor = "0x0077AA"
$GUIControlThemeColorBG = StringReplace($GUIThemeColor, "0x", "0xFF")
$GUIControlThemeColor = "0xff0099CC"
$borderCol = "0x0099CC"
$ButtonColorb = "0xffffffff"
$ButtonColorb_w = "0xff0077AA"
$ButtonColorb_d = "0xff0099CC"
$FontButton_w = "0xff0099CC"
$FontButton = "0xffffffff"
$FontButton_h = "0xffffffff"
EndIf


$STM_SETIMAGE = 0x0172
_GDIPlus_Startup()

   $Form1 = GUICreate("ECG GUI - INSERIMENTO DATI PAZIENTE", 940, 560, -1, -1, BitOR($WS_SYSMENU, $WS_POPUP))
GUISetBkColor($GUIThemeColor)

;#Drag Window (Everywhere except Buttons)
GUICtrlCreateLabel("", 0, 0, 850, 50, -1,$GUI_WS_EX_PARENTDRAG)
;GUICtrlSetBKColor(-1, 0x37a43c);To make the Drag Labels visible

_CreateBorder( 940, 560, $borderCol, 1, 1)
;#EndRegion Metro Style GUI

;#Region GUIHeader
;GUICtrlCreateLabel("Inserisci i dati del paziente", 10, 1050)

GUICtrlCreateLabel("Inserisci i dati del paziente", 10, 1050, 300, 30)
GUICtrlSetFont(-1, 18, 400, 0, "Calibri")
GUICtrlSetColor(-1, 0x33b7fa)

;#EndRegion GUIHeader


;#Region GUIContent
;GUICtrlCreateGroup("", 8, 82, 561, 121)
GUICtrlCreateLabel("Nome", 10, 30, 50)
	GUICtrlSetFont(-1, 13, 400, 0, "Calibri")
	GUICtrlSetColor(-1, $FontThemeColor)
	$inputName = GUICtrlCreateInput("", 10, 52, 300, 30)
	GUICtrlSetFont(-1, 13)
	GUICtrlCreateLabel("Cognome", 350, 30, 100)
	GUICtrlSetFont(-1, 13, 400, 0, "Calibri")
	GUICtrlSetColor(-1, $FontThemeColor)
	$inputLastName = GUICtrlCreateInput("", 350, 52, 300, 30)
	GUICtrlSetFont(-1, 13)

	GUICtrlCreateLabel("ID Paziente (max 11 cifre)", 10, 85, 60)
	GUICtrlSetFont(-1, 13, 400, 0, "Calibri")
	GUICtrlSetColor(-1, $FontThemeColor)
	$inputID = GUICtrlCreateInput("", 10, 107, 300, 30)
	GUICtrlSetFont(-1, 13)
	GUICtrlCreateLabel("Data nascita (gg/mm/aaaa)", 350, 85, 200)
	GUICtrlSetFont(-1, 13, 400, 0, "Calibri")
	GUICtrlSetColor(-1, $FontThemeColor)
	$inputBirthDate = GUICtrlCreateInput("", 350, 107, 300, 30)
	GUICtrlSetFont(-1, 13)
#cs
	GUICtrlCreateLabel("Sesso", 680, 140, 100)
	GUICtrlSetFont(-1, 13, 400, 0, "Calibri")
	GUICtrlSetColor(-1, $FontThemeColor)
	$iComboBox = GUICtrlCreateCombo("", 680, 162, 130, 30, $CBS_DROPDOWNLIST)
	GUICtrlSetData($iComboBox, "Maschio|Femmina", "Maschio")
	GUICtrlSetFont(-1, 13, 400, 0, "Calibri")
	GUICtrlSetColor(-1, $FontThemeColor)
#ce
    GUICtrlCreateLabel("Sesso", 700, 30, 60)
	GUICtrlSetFont(-1, 13, 400, 0, "Calibri")
	GUICtrlSetColor(-1, $FontThemeColor)
    ;$g1=GUICtrlCreatePic("", 700, 50, 145, 50)
	;$ag1 = _GDIPlus_CreateTextButton(" ", 147, 118, $ButtonColorb, 2, "Calibri", $ButtonColorb_w, $ButtonColorb_w, $ButtonColorb_w, 0)
	$g1=GUICtrlCreateGroup("", 700, 47, 147, 118)
	;GUICtrlSetColor($g1, 0xFFFFFF)
	;GUICtrlSetFont($g1,13)
	;GUICtrlSetColor($g1,"0xffffff")
    $iSex1 = GUICtrlCreatePic("", 720, 70, 105, 30)
	$aiSex1 = _GDIPlus_CreateTextButton("Maschio", 105, 29, $ButtonColorb, 16, "Calibri", $ButtonColorb_w, $ButtonColorb_w, $ButtonColorb_w, 0)
	$iSex2 = GUICtrlCreatePic("", 720, 120, 105, 30)
	$aiSex2 = _GDIPlus_CreateTextButton("Femmina", 105, 29, $ButtonColorb, 16, "Calibri", $ButtonColorb_w, $ButtonColorb_w, $ButtonColorb_w, 0)
    GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateLabel("Peso", 10, 140, 60)
	GUICtrlSetFont(-1, 13, 400, 0, "Calibri")
	GUICtrlSetColor(-1, $FontThemeColor)
	$inputWeight = GUICtrlCreateInput("", 10, 162, 300, 30)
	GUICtrlSetFont(-1, 13)
	GUICtrlCreateLabel("Altezza", 350, 140, 60)
	GUICtrlSetFont(-1, 13, 400, 0, "Calibri")
	GUICtrlSetColor(-1, $FontThemeColor)
	$inputHeight = GUICtrlCreateInput("", 350, 162, 300, 30)
	GUICtrlSetFont(-1, 13)

;GUICtrlSetColor(-1, $FontThemeColor)
;GUICtrlCreateGroup("", -99, -99, 1, 1)
    GUICtrlCreateGroup("", 5, 192, 900, 300)
	GUICtrlCreateLabel("Anamnesi", 10, 200, 80)
	GUICtrlSetFont(-1, 13, 400, 0, "Calibri")
    GUICtrlSetColor(-1, $FontThemeColor)
	$inputAnamnesi = GUICtrlCreateInput("", 10, 222, 450, 230)
	GUICtrlSetFont(-1, 13)

	;$iCheckbox1 = GUICtrlCreateCheckbox("Difficoltà respiratoria", 480, 222, 385, 50, $BS_PUSHLIKE)
	$iCheckbox1 = GUICtrlCreatePic("", 480, 222, 385, 50)
	$aiCheckbox1 = _GDIPlus_CreateTextButton("Difficoltà respiratoria", 155, 49, $ButtonColorb, 16, "Calibri", $ButtonColorb_w, $ButtonColorb_w, $ButtonColorb_w, 0)
    $iCheckbox2 = GUICtrlCreatePic("", 480, 282, 385, 50)
	$aiCheckbox2 = _GDIPlus_CreateTextButton("Palpitazioni", 155, 49, $ButtonColorb, 16, "Calibri", $ButtonColorb_w, $ButtonColorb_w, $ButtonColorb_w, 0)
	;$iCheckbox2 = GUICtrlCreateCheckbox("Palpitazioni", 480, 282, 385, 50, $BS_PUSHLIKE)
	;GUICtrlSetFont(-1, 13, 400, 0, "Calibri")
    ;GUICtrlSetColor(-1, $FontThemeColor)
	$iCheckbox3 = GUICtrlCreatePic("", 480, 342, 385, 50)
	$aiCheckbox3 = _GDIPlus_CreateTextButton("Genitori con problemi cardiaci", 155, 49, $ButtonColorb, 16, "Calibri", $ButtonColorb_w, $ButtonColorb_w, $ButtonColorb_w, 0)
	;$iCheckbox3 = GUICtrlCreateCheckbox("Genitori con problemi cardiaci", 480, 342, 385, 50, $BS_PUSHLIKE)
	;GUICtrlSetFont(-1, 13, 400, 0, "Calibri")
    ;GUICtrlSetColor(-1, $FontThemeColor)
	$iCheckbox4 = GUICtrlCreatePic("", 480, 402, 385, 50)
	$aiCheckbox4 = _GDIPlus_CreateTextButton("Dolori al braccio sinistro", 155, 49, $ButtonColorb, 16, "Calibri", $ButtonColorb_w, $ButtonColorb_w, $ButtonColorb_w, 0)
	;$iCheckbox4 = GUICtrlCreateCheckbox("Dolori al braccio sinistro", 480, 402, 385, 50, $BS_PUSHLIKE)
	;GUICtrlSetFont(-1, 13, 400, 0, "Calibri")
    ;GUICtrlSetColor(-1, $FontThemeColor)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
;GUICtrlCreateGroup("", 8, 200, 561, 129)
;#EndRegion GUIContent


;#Region Metro-Style Buttons
$ExitButton = GUICtrlCreatePic("", 750, 500, 49, 41)
;GUICtrlSetCursor(-1, 0)
;$aExitButton = _GDIPlus_CreateTextButton("CHIUDI", 155, 49, $GUIControlThemeColorBG, 20, "Arial", "", $GUIControlThemeColor, $GUIControlThemeColor)
$aExitButton = _GDIPlus_CreateTextButton("CHIUDI", 155, 49, $ButtonColorb, 16, "Calibri", $ButtonColorb_w, $ButtonColorb_w, $ButtonColorb_w, 0)
$MinimizeButton = GUICtrlCreatePic("", 857, 15, 49, 41)
GUICtrlSetCursor(-1, 0)
$aMinimizeButton = _GDIPlus_CreateTextButton("_", 28, 28, $GUIControlThemeColorBG, 20, "Arial", "", $GUIControlThemeColor, $GUIControlThemeColor)

$Button1 = GUICtrlCreatePic("", 5, 500, 100, 40)
$aButton1 = _GDIPlus_CreateTextButton("INVIA", 155, 49, $ButtonColorb, 16, "Calibri", $ButtonColorb_w, $ButtonColorb_w, $ButtonColorb_w, 0)

$Button2 = GUICtrlCreatePic("", 200, 500, 100, 40)
$aButton2 = _GDIPlus_CreateTextButton("AZZERA", 155, 49, $ButtonColorb, 16, "Calibri", $ButtonColorb_w, $ButtonColorb_w, $ButtonColorb_w, 0)

_WinAPI_DeleteObject(GUICtrlSendMsg($ExitButton, $STM_SETIMAGE, $IMAGE_BITMAP, $aExitButton[0]))
_WinAPI_DeleteObject(GUICtrlSendMsg($MinimizeButton, $STM_SETIMAGE, $IMAGE_BITMAP, $aMinimizeButton[0]))
_WinAPI_DeleteObject(GUICtrlSendMsg($Button1, $STM_SETIMAGE, $IMAGE_BITMAP, $aButton1[0]))
_WinAPI_DeleteObject(GUICtrlSendMsg($Button2, $STM_SETIMAGE, $IMAGE_BITMAP, $aButton2[0]))
_WinAPI_DeleteObject(GUICtrlSendMsg($iCheckbox1, $STM_SETIMAGE, $IMAGE_BITMAP, $aiCheckbox1[0]))
_WinAPI_DeleteObject(GUICtrlSendMsg($iCheckbox2, $STM_SETIMAGE, $IMAGE_BITMAP, $aiCheckbox2[0]))
_WinAPI_DeleteObject(GUICtrlSendMsg($iCheckbox3, $STM_SETIMAGE, $IMAGE_BITMAP, $aiCheckbox3[0]))
_WinAPI_DeleteObject(GUICtrlSendMsg($iCheckbox4, $STM_SETIMAGE, $IMAGE_BITMAP, $aiCheckbox4[0]))
_WinAPI_DeleteObject(GUICtrlSendMsg($iSex1, $STM_SETIMAGE, $IMAGE_BITMAP, $aiSex1[0]))
_WinAPI_DeleteObject(GUICtrlSendMsg($iSex1, $STM_SETIMAGE, $IMAGE_BITMAP, $aiSex1[0]))
_WinAPI_DeleteObject(GUICtrlSendMsg($iCheckbox1, $STM_SETIMAGE, $IMAGE_BITMAP, $aiCheckbox1[1]))
_WinAPI_DeleteObject(GUICtrlSendMsg($iCheckbox2, $STM_SETIMAGE, $IMAGE_BITMAP, $aiCheckbox2[1]))
_WinAPI_DeleteObject(GUICtrlSendMsg($iCheckbox3, $STM_SETIMAGE, $IMAGE_BITMAP, $aiCheckbox3[1]))
_WinAPI_DeleteObject(GUICtrlSendMsg($iCheckbox4, $STM_SETIMAGE, $IMAGE_BITMAP, $aiCheckbox4[1]))
_WinAPI_DeleteObject(GUICtrlSendMsg($iSex1, $STM_SETIMAGE, $IMAGE_BITMAP, $aiSex1[1]))
_WinAPI_DeleteObject(GUICtrlSendMsg($iSex2, $STM_SETIMAGE, $IMAGE_BITMAP, $aiSex2[1]))
;_WinAPI_DeleteObject(GUICtrlSendMsg($g1, $STM_SETIMAGE, $IMAGE_BITMAP, $ag1[1]))
$bShow = True
$bHide = False
;#EndRegion Metro-Style Buttons


GUISetState(@SW_SHOW)
_ClearMemory();To reduce the memory usage

$bool=False
$temp=False
While $bool=False
    Local $aMouseInfo, $bShow = False, $bHide = False
    Do

        If WinActive($Form1) Then
            $aMouseInfo = GUIGetCursorInfo($Form1)
            Switch $aMouseInfo[4]
                Case $ExitButton
                    _WinAPI_DeleteObject(GUICtrlSendMsg($ExitButton, $STM_SETIMAGE, $IMAGE_BITMAP, $aExitButton[1]))
                    $bShow = True
                    $bHide = False
					$temp=False
					_ClearMemory()
					;MsgBox($MB_SYSTEMMODAL, "Errore", "exit")
					#cs
                Case $MinimizeButton
                    _WinAPI_DeleteObject(GUICtrlSendMsg($MinimizeButton, $STM_SETIMAGE, $IMAGE_BITMAP, $aMinimizeButton[1]))
                    $bShow = True
                    $bHide = False
					$temp=False
					#ce
                Case $Button1
                    _WinAPI_DeleteObject(GUICtrlSendMsg($Button1, $STM_SETIMAGE, $IMAGE_BITMAP, $aButton1[1]))
                    $bShow = True
                    $bHide = False
					$temp=False
					_ClearMemory()
					;MsgBox($MB_SYSTEMMODAL, "Errore", "b1")
				 Case $iCheckbox1

					if $boolck1=False Then
						$aiCheckbox1 = _GDIPlus_CreateTextButton("Difficoltà respiratoria", 155, 49, $ButtonColorb_d, 16, "Calibri", $FontButton_h, $FontButton_h, $FontButton_h, 0)
						_WinAPI_DeleteObject(GUICtrlSendMsg($iCheckbox1, $STM_SETIMAGE, $IMAGE_BITMAP, $aiCheckbox1[1]))
					 	$bShow = True
					 	$bHide = False
						$temp=False
					 EndIf
					 _ClearMemory()
			    Case $iCheckbox2
				   if $boolck2=False Then
						$aiCheckbox2 = _GDIPlus_CreateTextButton("Palpitazioni", 155, 49, $ButtonColorb_d, 16, "Calibri", $FontButton_h, $FontButton_h, $FontButton_h, 0)
						_WinAPI_DeleteObject(GUICtrlSendMsg($iCheckbox2, $STM_SETIMAGE, $IMAGE_BITMAP, $aiCheckbox2[1]))
					 	$bShow = True
					 	$bHide = False
						$temp=False
					 EndIf
					 _ClearMemory()
						;MsgBox($MB_SYSTEMMODAL, "Errore", "c2")
			    Case $iCheckbox3
                    if $boolck3=False Then
						$aiCheckbox3 = _GDIPlus_CreateTextButton("Genitori con problemi cardiaci", 155, 49, $ButtonColorb_d, 16, "Calibri", $FontButton_h, $FontButton_h, $FontButton_h, 0)
						_WinAPI_DeleteObject(GUICtrlSendMsg($iCheckbox3, $STM_SETIMAGE, $IMAGE_BITMAP, $aiCheckbox3[1]))
					 	$bShow = True
					 	$bHide = False
						$temp=False
					 EndIf
					 _ClearMemory()
						;MsgBox($MB_SYSTEMMODAL, "Errore", "c3")
			    Case $iCheckbox4
                    if $boolck4=False Then
						$aiCheckbox4 = _GDIPlus_CreateTextButton("Dolori al braccio sinistro", 155, 49, $ButtonColorb_d, 16, "Calibri", $FontButton_h, $FontButton_h, $FontButton_h, 0)
						_WinAPI_DeleteObject(GUICtrlSendMsg($iCheckbox4, $STM_SETIMAGE, $IMAGE_BITMAP, $aiCheckbox4[1]))
					 	$bShow = True
					 	$bHide = False
						$temp=False
					 EndIf
					 _ClearMemory()
						;MsgBox($MB_SYSTEMMODAL, "Errore", "c4")
				 Case $iSex1
                    if $boolsx=True Then
						$aiSex1 = _GDIPlus_CreateTextButton("Maschio", 105, 29, $ButtonColorb_d, 16, "Calibri", $FontButton_h, $FontButton_h, $FontButton_h, 0)
						_WinAPI_DeleteObject(GUICtrlSendMsg($iSex1, $STM_SETIMAGE, $IMAGE_BITMAP, $aiSex1[1]))
					 Else
						$aiSex1 = _GDIPlus_CreateTextButton("Maschio", 105, 29, $ButtonColorb_w, 16, "Calibri", $FontButton, $FontButton, $FontButton, 0)
						_WinAPI_DeleteObject(GUICtrlSendMsg($iSex1, $STM_SETIMAGE, $IMAGE_BITMAP, $aiSex1[1]))
					 EndIf
					 	$bShow = True
					 	$bHide = False
						$temp=False
						_ClearMemory()
			     Case $iSex2
                    if $boolsx=False Then
						$aiSex2 = _GDIPlus_CreateTextButton("Femmina", 105, 29, $ButtonColorb_d, 16, "Calibri", $FontButton_h, $FontButton_h, $FontButton_h, 0)
						_WinAPI_DeleteObject(GUICtrlSendMsg($iSex2, $STM_SETIMAGE, $IMAGE_BITMAP, $aiSex2[1]))
					 Else
						$aiSex2 = _GDIPlus_CreateTextButton("Femmina", 105, 29, $ButtonColorb_w, 16, "Calibri", $FontButton, $FontButton, $FontButton, 0)
						_WinAPI_DeleteObject(GUICtrlSendMsg($iSex2, $STM_SETIMAGE, $IMAGE_BITMAP, $aiSex2[1]))
				    EndIf
					 	$bShow = True
					 	$bHide = False
						$temp=False
						_ClearMemory()
			     Case $Button2
                    _WinAPI_DeleteObject(GUICtrlSendMsg($Button2, $STM_SETIMAGE, $IMAGE_BITMAP, $aButton2[1]))
				    $bShow = True
                    $bHide = False
					$temp=False
					_ClearMemory()
					;MsgBox($MB_SYSTEMMODAL, "Errore", "button2")
				 Case Else
					 if $temp=false then
					;$ButtonColorb_ck1 = StringReplace("0xff0099CC", "0x", "0xFF")

                    _WinAPI_DeleteObject(GUICtrlSendMsg($ExitButton, $STM_SETIMAGE, $IMAGE_BITMAP, $aExitButton[0]))
                    ;_WinAPI_DeleteObject(GUICtrlSendMsg($MinimizeButton, $STM_SETIMAGE, $IMAGE_BITMAP, $aMinimizeButton[0]))
                    _WinAPI_DeleteObject(GUICtrlSendMsg($Button2, $STM_SETIMAGE, $IMAGE_BITMAP, $aButton2[0]))
                    _WinAPI_DeleteObject(GUICtrlSendMsg($Button1, $STM_SETIMAGE, $IMAGE_BITMAP, $aButton1[0]))

					 if $boolck1=False Then
						$aiCheckbox1 = _GDIPlus_CreateTextButton("Difficoltà respiratoria", 155, 49, $ButtonColorb, 16, "Calibri", $FontButton_w, $FontButton_w, $FontButton_w, 0)
						_WinAPI_DeleteObject(GUICtrlSendMsg($iCheckbox1, $STM_SETIMAGE, $IMAGE_BITMAP, $aiCheckbox1[1]))
					 EndIf
					 if $boolck2=False Then
						$aiCheckbox2 = _GDIPlus_CreateTextButton("Palpitazioni", 155, 49, $ButtonColorb, 16, "Calibri", $FontButton_w, $FontButton_w, $FontButton_w, 0)
						_WinAPI_DeleteObject(GUICtrlSendMsg($iCheckbox2, $STM_SETIMAGE, $IMAGE_BITMAP, $aiCheckbox2[1]))
					 EndIf
					 if $boolck3=False Then
						$aiCheckbox3 = _GDIPlus_CreateTextButton("Genitori con problemi cardiaci", 155, 49, $ButtonColorb, 16, "Calibri", $FontButton_w, $FontButton_w, $FontButton_w, 0)
						_WinAPI_DeleteObject(GUICtrlSendMsg($iCheckbox3, $STM_SETIMAGE, $IMAGE_BITMAP, $aiCheckbox3[1]))
					 EndIf
					 if $boolck4=False Then
						$aiCheckbox4 = _GDIPlus_CreateTextButton("Dolori al braccio sinistro", 155, 49, $ButtonColorb, 16, "Calibri", $FontButton_w, $FontButton_w, $FontButton_w, 0)
						_WinAPI_DeleteObject(GUICtrlSendMsg($iCheckbox4, $STM_SETIMAGE, $IMAGE_BITMAP, $aiCheckbox4[1]))
					 EndIf
					 if $boolsx=True Then
						$aiSex1 = _GDIPlus_CreateTextButton("Maschio", 105, 29, $ButtonColorb, 16, "Calibri", $ButtonColorb_w, $ButtonColorb_w, $ButtonColorb_w, 0)
						_WinAPI_DeleteObject(GUICtrlSendMsg($iSex1, $STM_SETIMAGE, $IMAGE_BITMAP, $aiSex1[1]))
					 Else
						$aiSex1 = _GDIPlus_CreateTextButton("Maschio", 105, 29, $ButtonColorb_w, 16, "Calibri", $FontButton, $FontButton, $FontButton, 0)
						_WinAPI_DeleteObject(GUICtrlSendMsg($iSex1, $STM_SETIMAGE, $IMAGE_BITMAP, $aiSex1[1]))
					 EndIf
					 if $boolsx=False Then
						$aiSex2 = _GDIPlus_CreateTextButton("Femmina", 105, 29, $ButtonColorb, 16, "Calibri", $ButtonColorb_w, $ButtonColorb_w, $ButtonColorb_w, 0)
						_WinAPI_DeleteObject(GUICtrlSendMsg($iSex2, $STM_SETIMAGE, $IMAGE_BITMAP, $aiSex2[1]))
					 Else
						$aiSex2 = _GDIPlus_CreateTextButton("Femmina", 105, 29, $ButtonColorb_w, 16, "Calibri", $FontButton, $FontButton, $FontButton, 0)
						_WinAPI_DeleteObject(GUICtrlSendMsg($iSex2, $STM_SETIMAGE, $IMAGE_BITMAP, $aiSex2[1]))
					 EndIf
					 $bShow = True
					 $bHide = False

					_ClearMemory();To reduce the memory usage

					$temp=True
				 EndIf
				 EndSwitch
        EndIf
 ;$aiCheckbox1 = _GDIPlus_CreateTextButton("Difficoltà respiratoria", 155, 49, $ButtonColorb_ck1, 16, "Calibri", 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0)



        $nMsg = GUIGetMsg()
        Switch $nMsg
		 Case $iCheckbox1

					if($boolck1=False) Then
						$boolck1=True
						GUICtrlSetColor(-1, $GUIThemeColor)
						$aiCheckbox1 = _GDIPlus_CreateTextButton("Difficoltà respiratoria", 155, 49, $ButtonColorb_w, 16, "Calibri", $FontButton, $FontButton, $FontButton, 0)
					    _WinAPI_DeleteObject(GUICtrlSendMsg($iCheckbox1, $STM_SETIMAGE, $IMAGE_BITMAP, $aiCheckbox1[1]))
					 	$bShow = True
					 	$bHide = False
					 Else
						$boolck1=False
						GUICtrlSetColor(-1, $GUIThemeColor)
						$aiCheckbox1 = _GDIPlus_CreateTextButton("Difficoltà respiratoria", 155, 49, $ButtonColorb, 16, "Calibri", $FontButton_w, $FontButton_w, $FontButton_w, 0)
						 _WinAPI_DeleteObject(GUICtrlSendMsg($iCheckbox1, $STM_SETIMAGE, $IMAGE_BITMAP, $aiCheckbox1[0]))
						$bShow = True
					 	$bHide = False
					 EndIf
					 _ClearMemory()

			Case $iCheckbox2

					if($boolck2=False) Then
						$boolck2=True
						GUICtrlSetColor(-1, $GUIThemeColor)
						$aiCheckbox2 = _GDIPlus_CreateTextButton("Palpitazioni", 155, 49, $ButtonColorb_w, 16, "Calibri", $FontButton, $FontButton, $FontButton, 0)
					    _WinAPI_DeleteObject(GUICtrlSendMsg($iCheckbox2, $STM_SETIMAGE, $IMAGE_BITMAP, $aiCheckbox2[1]))
					 	$bShow = True
					 	$bHide = False
					 Else
						$boolck2=False
						GUICtrlSetColor(-1, $GUIThemeColor)
						$aiCheckbox2 = _GDIPlus_CreateTextButton("Palpitazioni", 155, 49, $ButtonColorb, 16, "Calibri", $FontButton_w, $FontButton_w, $FontButton_w, 0)
						 _WinAPI_DeleteObject(GUICtrlSendMsg($iCheckbox2, $STM_SETIMAGE, $IMAGE_BITMAP, $aiCheckbox2[0]))
						$bShow = True
					 	$bHide = False
					 EndIf
					 _ClearMemory()

			Case $iCheckbox3

					if($boolck3=False) Then
						$boolck3=True
						GUICtrlSetColor(-1, $GUIThemeColor)
						$aiCheckbox3 = _GDIPlus_CreateTextButton("Genitori con problemi cardiaci", 155, 49, $ButtonColorb_w, 16, "Calibri", $FontButton, $FontButton, $FontButton, 0)
					    _WinAPI_DeleteObject(GUICtrlSendMsg($iCheckbox3, $STM_SETIMAGE, $IMAGE_BITMAP, $aiCheckbox3[1]))
					 	$bShow = True
					 	$bHide = False
					 Else
						$boolck3=False
						GUICtrlSetColor(-1, $GUIThemeColor)
						$aiCheckbox3 = _GDIPlus_CreateTextButton("Genitori con problemi cardiaci", 155, 49, $ButtonColorb, 16, "Calibri", $FontButton_w, $FontButton_w, $FontButton_w, 0)
						 _WinAPI_DeleteObject(GUICtrlSendMsg($iCheckbox3, $STM_SETIMAGE, $IMAGE_BITMAP, $aiCheckbox3[0]))
						$bShow = True
					 	$bHide = False
					 EndIf
					 _ClearMemory()

			Case $iCheckbox4

					if($boolck4=False) Then
						$boolck4=True
						GUICtrlSetColor(-1, $GUIThemeColor)
						$aiCheckbox4 = _GDIPlus_CreateTextButton("Dolori al braccio sinistro", 155, 49, $ButtonColorb_w, 16, "Calibri", $FontButton, $FontButton, $FontButton, 0)
					    _WinAPI_DeleteObject(GUICtrlSendMsg($iCheckbox4, $STM_SETIMAGE, $IMAGE_BITMAP, $aiCheckbox4[1]))
					 	$bShow = True
					 	$bHide = False
					 Else
						$boolck4=False
						GUICtrlSetColor(-1, $GUIThemeColor)
						$aiCheckbox4 = _GDIPlus_CreateTextButton("Dolori al braccio sinistro", 155, 49, $ButtonColorb, 16, "Calibri", $FontButton_w, $FontButton_w, $FontButton_w, 0)
						 _WinAPI_DeleteObject(GUICtrlSendMsg($iCheckbox4, $STM_SETIMAGE, $IMAGE_BITMAP, $aiCheckbox4[0]))
						$bShow = True
					 	$bHide = False
					 EndIf
					 _ClearMemory()
			Case $iSex1

					if($boolsx=True) Then
						$boolsx=False
						GUICtrlSetColor(-1, $GUIThemeColor)
						$aiSex1 = _GDIPlus_CreateTextButton("Maschio", 105, 29, $ButtonColorb_w, 16, "Calibri", $FontButton, $FontButton, $FontButton, 0)
						_WinAPI_DeleteObject(GUICtrlSendMsg($iSex1, $STM_SETIMAGE, $IMAGE_BITMAP, $aiSex1[1]))
						$aiSex2 = _GDIPlus_CreateTextButton("Femmina", 105, 29, $ButtonColorb, 16, "Calibri", $ButtonColorb_w, $ButtonColorb_w, $ButtonColorb_w, 0)
						_WinAPI_DeleteObject(GUICtrlSendMsg($iSex2, $STM_SETIMAGE, $IMAGE_BITMAP, $aiSex2[1]))
					 	$bShow = True
					 	$bHide = False
					 Else
						$boolsx=False
						GUICtrlSetColor(-1, $GUIThemeColor)
						$aiSex2 = _GDIPlus_CreateTextButton("Femmina", 105, 29, $ButtonColorb, 16, "Calibri", $ButtonColorb_w, $ButtonColorb_w, $ButtonColorb_w, 0)
						_WinAPI_DeleteObject(GUICtrlSendMsg($iSex2, $STM_SETIMAGE, $IMAGE_BITMAP, $aiSex2[1]))
						$aiSex1 = _GDIPlus_CreateTextButton("Maschio", 105, 29, $ButtonColorb_w, 16, "Calibri", $FontButton, $FontButton, $FontButton, 0)
						_WinAPI_DeleteObject(GUICtrlSendMsg($iSex1, $STM_SETIMAGE, $IMAGE_BITMAP, $aiSex1[1]))
						$bShow = True
					 	$bHide = False
					 EndIf
					 _ClearMemory()
			Case $iSex2

					if($boolsx=True) Then
						$boolsx=True
						GUICtrlSetColor(-1, $GUIThemeColor)
						$aiSex2 = _GDIPlus_CreateTextButton("Femmina", 105, 29, $ButtonColorb_w, 16, "Calibri", $FontButton, $FontButton, $FontButton, 0)
						_WinAPI_DeleteObject(GUICtrlSendMsg($iSex2, $STM_SETIMAGE, $IMAGE_BITMAP, $aiSex2[1]))
						$aiSex1 = _GDIPlus_CreateTextButton("Maschio", 105, 29, $ButtonColorb, 16, "Calibri", $ButtonColorb_w, $ButtonColorb_w, $ButtonColorb_w, 0)
						_WinAPI_DeleteObject(GUICtrlSendMsg($iSex1, $STM_SETIMAGE, $IMAGE_BITMAP, $aiSex1[1]))
					 	$bShow = True
					 	$bHide = False
					 Else
						$boolsx=True
						GUICtrlSetColor(-1, $GUIThemeColor)
						$aiSex1 = _GDIPlus_CreateTextButton("Maschio", 105, 29, $ButtonColorb, 16, "Calibri", $ButtonColorb_w, $ButtonColorb_w, $ButtonColorb_w, 0)
						_WinAPI_DeleteObject(GUICtrlSendMsg($iSex1, $STM_SETIMAGE, $IMAGE_BITMAP, $aiSex1[1]))
						$aiSex2 = _GDIPlus_CreateTextButton("Femmina", 105, 29, $ButtonColorb_w, 16, "Calibri", $FontButton, $FontButton, $FontButton, 0)
						_WinAPI_DeleteObject(GUICtrlSendMsg($iSex2, $STM_SETIMAGE, $IMAGE_BITMAP, $aiSex2[1]))
						$bShow = True
					 	$bHide = False
					 EndIf
					 _ClearMemory()

			Case $ExitButton

                _WinAPI_DeleteObject($aExitButton[0])
                _WinAPI_DeleteObject($aExitButton[1])
                ;_WinAPI_DeleteObject($aMinimizeButton[0])
                _WinAPI_DeleteObject($aMinimizeButton[1])
                _WinAPI_DeleteObject($aButton2[0])
                _WinAPI_DeleteObject($aButton2[1])
                _WinAPI_DeleteObject($aButton1[0])
                _WinAPI_DeleteObject($aButton1[1])

                _GDIPlus_Shutdown()
                ;Exit
				$bool=True
				GUIDelete("ECG GUI - INSERIMENTO DATI PAZIENTE")
			 Case $MinimizeButton
			    _WinAPI_DeleteObject($aExitButton[0])
                _WinAPI_DeleteObject($aExitButton[1])
                ;_WinAPI_DeleteObject($aMinimizeButton[0])
                _WinAPI_DeleteObject($aMinimizeButton[1])
                _WinAPI_DeleteObject($aButton2[0])
                _WinAPI_DeleteObject($aButton2[1])
                _WinAPI_DeleteObject($aButton1[0])
                _WinAPI_DeleteObject($aButton1[1])

                _GDIPlus_Shutdown()
                ;Exit
				$bool=True
				GUIDelete("ECG GUI - INSERIMENTO DATI PAZIENTE")
				    $color=Mod ( $color+1, 4 )
					;MsgBox($MB_SYSTEMMODAL, "Errore", $color)
					nuovo()
            ;    GUISetState(@SW_MINIMIZE, $Form1)

            Case $Button1
                $name = GUICtrlRead($inputName)
				$lastName = GUICtrlRead($inputLastName)
				$id = GUICtrlRead($inputID)
				$sex = GUICtrlRead($iComboBox)
				$weight = GUICtrlRead($inputWeight)
				$height = GUICtrlRead($inputHeight)
				$birthDate = GUICtrlRead($inputBirthDate)
				$anamnesi = GUICtrlRead($inputAnamnesi)
				If $boolck1=True Then
					$parameter = "A;"

				EndIf
				If _IsChecked($iCheckbox2) Then
					$parameter = $parameter & "B;"
				EndIf
				If _IsChecked($iCheckbox3) Then
					$parameter = $parameter & "C;"
				EndIf
				If _IsChecked($iCheckbox4) Then
					$parameter = $parameter & "D;"
				 EndIf

				$date = StringSplit($birthDate, "/")
				If ($sex = 'Femmina') Then
					$sesso = 2
				Else
					$sesso = 1
				EndIf
				If _control($name, $lastName, $id, $birthDate, $weight, $height, $anamnesi, $parameter) Then
				    _RunDos('C:\pcekg\cxcall_new.exe l "' & $lastName & ' ' & $name & '" "' & $id & '" "' & $sesso & '" "' & $weight & '" "' & $height & '" "' & $date[3] & '-' & $date[2] & '-' & $date[1] & '"')
					WinClose("ECG GUI - INSERIMENTO DATI PAZIENTE")
				EndIf
            Case $Button2
                GUICtrlSetData($inputName, "")
				GUICtrlSetData($inputLastName, "")
				GUICtrlSetData($inputID, "")
				GUICtrlSetData($inputWeight, "")
				GUICtrlSetData($inputHeight, "")
				GUICtrlSetData($inputBirthDate, "")
				GUICtrlSetData($inputAnamnesi, "")
        EndSwitch
    Until $bool=True
WEnd



EndFunc   ;==>esci

Func _IsChecked($iControlID)
	Return BitAND(GUICtrlRead($iControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>_IsChecked

Func checkFields()
	;MsgBox($MB_SYSTEMMODAL, "Errore", "Controlla i valori inseriti")
	Return True
EndFunc   ;==>checkFields



Func _control($name, $lastName, $id, $birthDate, $weight, $height, $anamnesi, $parameter)
	;MsgBox($MB_SYSTEMMODAL, "Errore", "Controlla i valori inseriti")
	If (Not ($name = "") And Not ($lastName = "")) Then

		$iLength = StringLen($id)
		If $iLength <= 11 Then
			If (Not ($birthDate = "")) Then
				$date = StringSplit($birthDate, "/")
				If _DateIsValid($date[3] & "-" & $date[2] & "-" & $date[1]) Then
					If (IsInt(Int($date[1])) & $date[1] > 0 And $date[1] < 32) Then
						If (IsInt(Int($date[2])) & $date[2] > 0 & $date[2] < 13) Then
							If (IsInt(Int($date[3]))) Then
								If Not ($weight = "") And Not ($height = "") Then
									If (IsInt(Int($weight))) Then
										If (IsInt(Int($height))) Then

											Return True


										Else
											;MsgBox($MB_SYSTEMMODAL, "Errore", "Controlla altezza")
										EndIf
									Else
										;MsgBox($MB_SYSTEMMODAL, "Errore", "Controlla peso")
									EndIf
								Else
									;MsgBox($MB_SYSTEMMODAL, "Errore", "Controlla peso e altezza")
								EndIf
							Else
								;MsgBox($MB_SYSTEMMODAL, "Errore", "Controlla anno")
							EndIf
						Else
							;MsgBox($MB_SYSTEMMODAL, "Errore", "Controlla mese")
						EndIf
					Else
						;MsgBox($MB_SYSTEMMODAL, "Errore", "Controlla giorno")
					EndIf
				Else
				EndIf
			Else
				;MsgBox($MB_SYSTEMMODAL, "Errore", "Controlla data")
			EndIf
		Else
			;MsgBox($MB_SYSTEMMODAL, "Errore", "Controlla CF")
		EndIf
	Else
		;MsgBox($MB_SYSTEMMODAL, "Errore", "Controlla nome e cognome")
	EndIf
	MsgBox($MB_SYSTEMMODAL, "Errore", "ATTENZIONE: Tutti i campi sono obbligatori")
	Return False
EndFunc   ;==>_control

Func dati()

	SplashTextOn("Esportazione in corso", "Attendere", 100, 50, -1 + 790, -1 + 330, 1)
	WinActivate("[CLASS:WinCrx]")
	WinSetState("[CLASS:WinCrx]", "", @SW_DISABLE)
	;WinSetState ( "[CLASS:WinCrx]", "", @SW_HIDE )
	;WinSetTrans("[CLASS:WinCrx]","",0)
	#cs
		Global $name = ""
		Global $lastName = ""
		Global $CodFisc = ""
		Global $sex = ""
		Global $weight = ""
		Global $height = ""
		Global $birthDate = ""
	#ce
	;_RunDos("C:\ECGProcessor\jarfile.bat "&$anamnesi&" "&$combo)
	_RunDos('java -jar C:\ECGProcessor\cidimu-client.jar "' & $anamnesi & '" "' & $parameter & '"')
	Sleep(100)

	;Sleep(2000)
	SplashOff()

EndFunc   ;==>dati

;~ ### error handling ###
Func MyErrFunc()
	$ErrorCode = 0
	If IsObj($oMyError) Then
		$ErrorCode = Hex($oMyError.number)
		TrayTip("Errore", "Errore", 5, 1)
		MsgBox(16 + 262144, "Errore", "Errore")

		Exit
		$oMyError.clear

	EndIf
EndFunc   ;==>MyErrFunc


Func back()
	WinActivate("[CLASS:CrxGrFrame]")
	ControlClick("[CLASS:CrxGrFrame]", "", "[CLASS:CrxToolClass32; INSTANCE:1]", "left", 1, 22, 22)
EndFunc   ;==>back

Func rec()
	WinActivate("[CLASS:CrxGrFrame]")
	ControlClick("[CLASS:CrxGrFrame]", "", "[CLASS:CrxToolClass32; INSTANCE:1]", "left", 1, 403, 22)
EndFunc   ;==>rec

Func play()
	WinActivate("[CLASS:CrxGrFrame]")
	ControlClick("[CLASS:CrxGrFrame]", "", "[CLASS:CrxToolClass32; INSTANCE:1]", "left", 1, 472, 22)
EndFunc   ;==>play

Func stop()
	WinActivate("[CLASS:CrxGrFrame]")
	ControlClick("[CLASS:CrxGrFrame]", "", "[CLASS:CrxToolClass32; INSTANCE:1]", "left", 1, 438, 22)
EndFunc   ;==>stop

Func WM_PAINT($hWnd, $msg, $wParam, $lParam)
	Sleep(100)
	DllCall("user32.dll", "int", "InvalidateRect", "hwnd", $hWnd, "ptr", 0, "int", 0)
EndFunc   ;==>WM_PAINT



;===============================================================================
;
; Function Name:    _ProcessGetHWnd
; Description:    Returns the HWND(s) owned by the specified process (PID only !).
;
; Parameter(s):  $iPid      - the owner-PID.
;                   $iOption    - Optional : return/search methods :
;                       0 - returns the HWND for the first non-titleless window.
;                       1 - returns the HWND for the first found window (default).
;                       2 - returns all HWNDs for all matches.
;
;                  $sTitle      - Optional : the title to match (see notes).
;                   $iTimeout   - Optional : timeout in msec (see notes)
;
; Return Value(s):  On Success - returns the HWND (see below for method 2).
;                       $array[0][0] - number of HWNDs
;                       $array[x][0] - title
;                       $array[x][1] - HWND
;
;                  On Failure   - returns 0 and sets @error to 1.
;
; Note(s):          When a title is specified it will then only return the HWND to the titles
;                   matching that specific string. If no title is specified it will return as
;                   described by the option used.
;
;                   When using a timeout it's possible to use WinWaitDelay (Opt) to specify how
;                   often it should wait before attempting another time to get the HWND.
;
;
; Author(s):        Helge
;
;===============================================================================
Func _ProcessGetHWnd($iPid, $iOption = 1, $sTitle = "", $iTimeout = 2000)
	Local $aReturn[1][1] = [[0]], $aWin, $hTimer = TimerInit()

	While 1

		; Get list of windows
		$aWin = WinList($sTitle)

		; Searches thru all windows
		For $i = 1 To $aWin[0][0]

			; Found a window owned by the given PID
			If $iPid = WinGetProcess($aWin[$i][1]) Then

				; Option 0 or 1 used
				If $iOption = 1 Or ($iOption = 0 And $aWin[$i][0] <> "") Then
					Return $aWin[$i][1]

					; Option 2 is used
				ElseIf $iOption = 2 Then
					ReDim $aReturn[UBound($aReturn) + 1][2]
					$aReturn[0][0] += 1
					$aReturn[$aReturn[0][0]][0] = $aWin[$i][0]
					$aReturn[$aReturn[0][0]][1] = $aWin[$i][1]
				EndIf
			EndIf
		Next

		; If option 2 is used and there was matches then the list is returned
		If $iOption = 2 And $aReturn[0][0] > 0 Then Return $aReturn

		; If timed out then give up
		If TimerDiff($hTimer) > $iTimeout Then ExitLoop

		; Waits before new attempt
		Sleep(Opt("WinWaitDelay"))
	WEnd


	; No matches
	SetError(1)
	Return 0
EndFunc   ;==>_ProcessGetHWnd

;#Region Metro-Style Requiered Functions
Func _GDIPlus_CreateTextButton($sString, $iWidth, $iHeight, $iBgColor = 0xFF1BA0E1, $iFontSize = 22, $sFont = "Arial", $iHoverColor = 0x3E3E3E, $iFontFrameColor = 0x0099CC, $iFontColor = 0x0099CC, $iFrameThickness = 4);MetroStyle Button Funktion
    If $sString = "" Then Return SetError(1, 0, 0)
    If Int($iWidth) < 4 Then Return SetError(2, 0, 0)
    If Int($iHeight) < 4 Then Return SetError(3, 0, 0)
    Local Const $hFormat = _GDIPlus_StringFormatCreate()
    Local Const $hFamily = _GDIPlus_FontFamilyCreate($sFont)
    Local $tLayout = _GDIPlus_RectFCreate(0, 0, $iWidth, 0)
    _GDIPlus_StringFormatSetAlign($hFormat, 1)
    Local Const $aBitmaps[2] = [_GDIPlus_BitmapCreateFromScan0($iWidth, $iHeight), _GDIPlus_BitmapCreateFromScan0($iWidth, $iHeight)]
    Local Const $aGfxCtxt[2] = [_GDIPlus_ImageGetGraphicsContext($aBitmaps[0]), _GDIPlus_ImageGetGraphicsContext($aBitmaps[1])]
    _GDIPlus_GraphicsSetSmoothingMode($aGfxCtxt[0], $GDIP_SMOOTHINGMODE_HIGHQUALITY)
    _GDIPlus_GraphicsSetTextRenderingHint($aGfxCtxt[0], $GDIP_TEXTRENDERINGHINT_ANTIALIASGRIDFIT)
    Local Const $hBrushFontColor = _GDIPlus_BrushCreateSolid($iFontColor)
    $hPenFontFrameColor = _GDIPlus_PenCreate($iFontFrameColor, $iFrameThickness)
    $hPenHoverColor = _GDIPlus_PenCreate($iHoverColor, 3)
    Local Const $hPath = _GDIPlus_PathCreate()
    Local Const $hPath_Dummy = _GDIPlus_PathClone($hPath)
    _GDIPlus_PathAddString($hPath_Dummy, $sString, $tLayout, $hFamily, 0, $iFontSize, $hFormat)
	Local $aInfo[10]
	$aInfo[3] = 10.0
    $aInfo = _GDIPlus_PathGetWorldBounds($hPath_Dummy)
    $tLayout.Y = ($iHeight - $aInfo[3]) / 2 - Ceiling($aInfo[1])
    _GDIPlus_PathAddString($hPath, $sString, $tLayout, $hFamily, 0, $iFontSize, $hFormat)
    _GDIPlus_GraphicsClear($aGfxCtxt[0], $iBgColor)
    _GDIPlus_GraphicsFillPath($aGfxCtxt[0], $hPath, $hBrushFontColor)
    _GDIPlus_GraphicsDrawPath($aGfxCtxt[0], $hPath, $hPenFontFrameColor)
    _GDIPlus_GraphicsDrawImageRect($aGfxCtxt[1], $aBitmaps[0], 0, 0, $iWidth, $iHeight)
    _GDIPlus_GraphicsDrawRect($aGfxCtxt[1], 0, 0, $iWidth - 1, $iHeight - 1, $hPenHoverColor)
    $hPenFontFrameColor = _GDIPlus_PenCreate($iFontFrameColor, ($iFrameThickness - 1))
    _GDIPlus_GraphicsSetSmoothingMode($sFont, 2)
    _GDIPlus_GraphicsClear($aGfxCtxt[0], $iBgColor)
    _GDIPlus_GraphicsFillPath($aGfxCtxt[0], $hPath, $hBrushFontColor)
    _GDIPlus_GraphicsDrawPath($aGfxCtxt[0], $hPath, $hPenFontFrameColor)
    _GDIPlus_FontFamilyDispose($hFamily)
    _GDIPlus_StringFormatDispose($hFormat)
    _GDIPlus_PathDispose($hPath)
    _GDIPlus_PathDispose($hPath_Dummy)
    _GDIPlus_GraphicsDispose($aGfxCtxt[0])
    _GDIPlus_GraphicsDispose($aGfxCtxt[1])
    _GDIPlus_BrushDispose($hBrushFontColor)
    _GDIPlus_PenDispose($hPenFontFrameColor)
    _GDIPlus_PenDispose($hPenHoverColor)
    Local $aHBitmaps[2] = [_GDIPlus_BitmapCreateHBITMAPFromBitmap($aBitmaps[0]), _GDIPlus_BitmapCreateHBITMAPFromBitmap($aBitmaps[1])]
    _GDIPlus_BitmapDispose($aBitmaps[0])
    _GDIPlus_BitmapDispose($aBitmaps[1])
    Return $aHBitmaps
EndFunc   ;==>_GDIPlus_CreateTextButton
Func _CreateBorder($guiW, $guiH, $bordercolor = 0xFFFFFF, $style = 1, $borderThickness = 1)
    If $style = 0 Then
        ;#TOP#
        GUICtrlCreateLabel("", 0, 0, $guiW - 1, $borderThickness)
        GUICtrlSetColor(-1, $bordercolor)
        GUICtrlSetBkColor(-1, $bordercolor)
        ;#Bottom
        GUICtrlCreateLabel("", 0, $guiH - $borderThickness, $guiW - 1, $borderThickness)
        GUICtrlSetColor(-1, $bordercolor)
        GUICtrlSetBkColor(-1, $bordercolor)
        ;#Left
        GUICtrlCreateLabel("", 0, 1, $borderThickness, $guiH - 1)
        GUICtrlSetColor(-1, $bordercolor)
        GUICtrlSetBkColor(-1, $bordercolor)
        ;#Right
        GUICtrlCreateLabel("", $guiW - $borderThickness, 1, $borderThickness, $guiH - 1)
        GUICtrlSetColor(-1, $bordercolor)
        GUICtrlSetBkColor(-1, $bordercolor)
    Else
        ;#TOP#
        GUICtrlCreateLabel("", 1, 1, $guiW - 2, $borderThickness)
        GUICtrlSetColor(-1, $bordercolor)
        GUICtrlSetBkColor(-1, $bordercolor)
        ;#Bottom
        GUICtrlCreateLabel("", 1, $guiH - $borderThickness - 1, $guiW - 2, $borderThickness)
        GUICtrlSetColor(-1, $bordercolor)
        GUICtrlSetBkColor(-1, $bordercolor)
        ;#Left
        GUICtrlCreateLabel("", 1, 1, $borderThickness, $guiH - 2)
        GUICtrlSetColor(-1, $bordercolor)
        GUICtrlSetBkColor(-1, $bordercolor)
        ;#Right
        GUICtrlCreateLabel("", $guiW - $borderThickness - 1, 1, $borderThickness, $guiH - 2)
        GUICtrlSetColor(-1, $bordercolor)
        GUICtrlSetBkColor(-1, $bordercolor)
    EndIf
EndFunc   ;==>_CreateBorder
Func _ClearMemory($i_PID = -1)
    If $i_PID <> -1 Then
        Local $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $i_PID)
        Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', $ai_Handle[0])
        DllCall('kernel32.dll', 'int', 'CloseHandle', 'int', $ai_Handle[0])
    Else
        Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', -1)
    EndIf
    Return $ai_Return[0]
EndFunc   ;==>_ClearMemory
;#EndRegion Metro-Style Requiered Functions

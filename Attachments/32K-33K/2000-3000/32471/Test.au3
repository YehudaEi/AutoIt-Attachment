;=======================================================Variables================================================
Global Const $AC_SRC_ALPHA = 1;
Global Const $dataFile=@ScriptDir&"\data.mtl";
Global Const $ps="mtl-xx3004";
$didReplace=False;
$aOT=True; Always on top
;=======================================================End variables============================================

#NoTrayIcon
#include <_Zip.au3>
#include <array.au3>
#include <ButtonConstants.au3>
#include <GDIPlus.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <SliderConstants.au3>
#Include <Crypt.au3>
;intial();

;GDI Process
_GDIPlus_Startup();
$hImage = _GDIPlus_ImageLoadFromFile(@ScriptDir&"\bg.jpg");
;$width = _GDIPlus_ImageGetWidth($hImage);
;$height = _GDIPlus_ImageGetHeight($hImage);
$width = 413;
$height = 161;

;mainForm layer windows
$mainForm = GUICreate("Multiple Tasks Launcher", $width, $height, @DesktopWidth-$width, @DesktopHeight-$height-30, $WS_POPUP, $WS_EX_LAYERED);
GUIRegisterMsg($WM_NCHITTEST, "WM_NCHITTEST");
GUISetState();
WinSetOnTop($mainForm, "", 1);
setBitmap($mainForm, $hImage, 255, $width, $height);

;Form to hold Controls
$controlGUI = GUICreate("ControlGUI", $width, $height, 0, 0, $WS_POPUP, BitOR($WS_EX_LAYERED, $WS_EX_MDICHILD), $mainForm);
GUICtrlCreatePic(@ScriptDir & "\transparent.gif", 0, 0, $width, $height);
;GUICtrlSetBkColor(-1, 0x000000);
;_WinAPI_SetLayeredWindowAttributes($mainForm, 0x010101);
GUICtrlSetState(-1, $GUI_DISABLE);

$proDef = GUICtrlCreateInput("/d", 10, 40, 49, 21);
$query = GUICtrlCreateInput("", 66, 40, 289, 21);

$submit = GUICtrlCreateButton("Go !", 364, 38, 43, 25, $BS_DEFPUSHBUTTON);

$ESF = GUICtrlCreateCheckbox("", 10, 70, 13, 13);
GUICtrlSetState(-1, $GUI_CHECKED);

$l1 = GUICtrlCreateLabel("Enable Smart Filter (Automatically defines application to lauch)", 27, 70, 378, 17);
GUICtrlSetColor(-1, 0xFFFFFF);
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT);
;GUICtrlSetColor(-1, 0x000000);
;GUICtrlSetBkColor(-1, 0xFFFFFF);

$headerTitle = GUICtrlCreateLabel("Multiple Tasks Laucher", 12, 10, 180, 23);
GUICtrlSetFont(-1, 12, 800, 0, "Arial");
GUICtrlSetColor(-1, 0xFFFFFF);
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT);
$config = GUICtrlCreateButton("Configure", 48, 90, 75, 25);
$extend = GUICtrlCreateButton("Extend", 136, 90, 75, 25);
$about = GUICtrlCreateButton("Help / About", 224, 90, 75, 25);
$exit = GUICtrlCreateButton("Exit", 308, 90, 75, 25);
$pBar = GUICtrlCreateProgress(5, 142, 418, 20);
$stt = GUICtrlCreateLabel("Welcome to Multi Tasks Launcher", 14, 122, 315, 17);
GUICtrlSetColor(-1, 0xFFFFFF);
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT);
$opa = GUICtrlCreateSlider(312, 120, 102, 45, $TBS_NOTICKS, $WS_EX_TRANSPARENT);
GUICtrlSetLimit(-1, 150, 0);
GUICtrlSetData(-1, 150);
$iLastSlider=150;

$alwaysTop = GUICtrlCreateCheckbox("", 312, 13, 13, 13);
If $aOT=True Then
	GUICtrlSetState(-1, $GUI_CHECKED);
EndIf	
$lb2 = GUICtrlCreateLabel("Always on top", 336, 13, 70, 17);
GUICtrlSetColor(-1, 0xFFFFFF);
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT);

_GuiRoundCorners($mainForm, 0, 0, 10, 20);
_GuiRoundCorners($controlGUI, 0, 0, 10, 20);
GUISetState();


While 1
	$nMsg = GUIGetMsg();
	Switch $nMsg;
		Case $exit;
			Exit;
		Case $alwaysTop;
			If $aOT=True Then
				WinSetOnTop($mainForm, "", 0);
				$aOT=False;
			Else
				WinSetOnTop($mainForm, "", 1);
				$aOT=True;
			EndIf
		Case $submit;
			Global $q=GUICtrlRead($query);
			;_doAnalyze();
		EndSwitch
	
	;Slider message
	$iCurSlider = GUICtrlRead($opa);
    If $iCurSlider <> $iLastSlider Then;
		setBitmap($mainForm, $hImage, $iCurSlider+105, $width, $height);
        $iLastSlider = $iCurSlider;
    EndIf

WEnd

;==========================================================Functions============================================
Func isLANOn()
	If(Ping("www.google.com.vn")==0) Then
		Return 0;
	Else
		Return 1;
	EndIf
EndFunc

Func alert($txt, $ic="")
	$alertTitle="Information";
	If($ic=="x" OR $ic=="X") Then
		MsgBox(16, $alertTitle, $txt);
	ElseIf($ic=="?") Then
		MsgBox(32, $alertTitle, $txt);
	ElseIf($ic=="!") Then
		MsgBox(48, $alertTitle, $txt);
	ElseIf($ic=="i" OR $ic=="I") Then
		MsgBox(64, $alertTitle, $txt);
	Else
		MsgBox(0, $alertTitle, $txt);
	EndIf
EndFunc

Func readReg($regKey, $regName)
	Return RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\NHT3004\"&$regKey,$regName);
EndFunc
	
Func writeReg($regKey, $regName, $regValue)
	RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\NHT3004\"&$regKey,$regName,"REG_SZ",$regValue);
EndFunc

Func deleteReg($regKey, $regValue)
	RegDelete("HKEY_LOCAL_MACHINE\SOFTWARE\NHT3004\"&$regKey,$regValue);
EndFunc

Func _GuiRoundCorners($h_win, $i_x1, $i_y1, $i_x3, $i_y3);	
   Dim $pos, $ret, $ret2;
   $pos = WinGetPos($h_win);
   $ret = DllCall("gdi32.dll", "long", "CreateRoundRectRgn", "long", $i_x1, "long", $i_y1, "long", $pos[2], "long", $pos[3], "long", $i_x3, "long", $i_y3);
   If $ret[0] Then
      $ret2 = DllCall("user32.dll", "long", "SetWindowRgn", "hwnd", $h_win, "long", $ret[0], "int", 1);
      If $ret2[0] Then
         Return 1;
      Else
         Return 0;
      EndIf;
   Else
      Return 0;
   EndIf;
EndFunc;==>_GuiRoundCorners

Func SetBitmap($hGUI, $hImage, $iOpacity, $dllW, $dllH);
    Local $hScrDC, $hMemDC, $hBitmap, $hOld, $pSize, $tSize, $pSource, $tSource, $pBlend, $tBlend;
	
    $hScrDC = _WinAPI_GetDC(0);
    $hMemDC = _WinAPI_CreateCompatibleDC($hScrDC);
    $hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage);
    $hOld = _WinAPI_SelectObject($hMemDC, $hBitmap);
    $tSize = DllStructCreate($tagSIZE);
    $pSize = DllStructGetPtr($tSize);
    ;DllStructSetData($tSize, "X", _GDIPlus_ImageGetWidth($hImage));
    ;DllStructSetData($tSize, "Y", _GDIPlus_ImageGetHeight($hImage));
	DllStructSetData($tSize, "X", $dllW);
    DllStructSetData($tSize, "Y", $dllH);
    $tSource = DllStructCreate($tagPOINT);
    $pSource = DllStructGetPtr($tSource);
    $tBlend = DllStructCreate($tagBLENDFUNCTION);
    $pBlend = DllStructGetPtr($tBlend);
    DllStructSetData($tBlend, "Alpha", $iOpacity);
    DllStructSetData($tBlend, "Format", $AC_SRC_ALPHA);
    _WinAPI_UpdateLayeredWindow($hGUI, $hScrDC, 0, $pSize, $hMemDC, $pSource, 0, $pBlend, $ULW_ALPHA);
    _WinAPI_ReleaseDC(0, $hScrDC);
    _WinAPI_SelectObject($hMemDC, $hOld);
    _WinAPI_DeleteObject($hBitmap);
    _WinAPI_DeleteDC($hMemDC);
EndFunc   ;==>SetBitmap - make the image become real form

Func WM_NCHITTEST($hWnd, $iMsg, $iwParam, $ilParam);
    If ($hWnd = $mainForm) And ($iMsg = $WM_NCHITTEST) Then Return $HTCAPTION;
EndFunc   ;==>WM_NCHITTEST

;=======================================================End functions============================================
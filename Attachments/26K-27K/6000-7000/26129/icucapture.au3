#NoTrayIcon
#include-once
#include <WinAPI.au3>
#include <GDIPlus.au3>
#Include <Array.au3>
#include <GuiConstantsEx.au3>
#include <GuiEdit.au3>

Global Const $__SCREENCAPTURECONSTANT_SRCCOPY = 0x00CC0020
Global $giBMPFormat = $GDIP_PXF24RGB

Global $lfichiers[9999]
Global $icudir = IniRead(@ScriptDir & "\icu.ini", "Param", "folder", "L:\temp\")
Global $icufilename = $icudir & "c"
Global $icunum=0
Global $icuX = IniRead(@ScriptDir & "\icu.ini", "Param", "x",100)
Global $icuY = IniRead(@ScriptDir & "\icu.ini", "Param", "y",20)
Global $icuLarg = IniRead(@ScriptDir & "\icu.ini", "Param", "w",800)
Global $icuHaut = IniRead(@ScriptDir & "\icu.ini", "Param", "h",500)
Global $intervalle = IniRead(@ScriptDir & "\icu.ini", "Param", "intervalle",250)
Global $duree = IniRead(@ScriptDir & "\icu.ini", "Param", "dureeMaxi",60)

$gui=GUICreate("ICU - Paramètres",400,390)
GUISetFont(10,600,-1,"Arial")
$pas=30
$v=15
$v+=$pas
$h=170
$l1=GUICtrlCreateLabel("Dossier (folder) de travail:",10,$v+3,155)
$chdoss=GUICtrlCreateInput($icudir,$h,$v,200)  
$v+=$pas
$l2=GUICtrlCreateLabel("Région, début X:",10,$v+3,135)
$chx=GUICtrlCreateInput($icuX,$h,$v,200)
$v+=$pas
$l3=GUICtrlCreateLabel("Région, début Y:",10,$v+3,135)
$chy=GUICtrlCreateInput($icuY,$h,$v,200)
$v+=$pas
$l4=GUICtrlCreateLabel("Région, Largeur:",10,$v+3,135)
$chw=GUICtrlCreateInput($icuLarg,$h,$v,200)
$v+=$pas
$l5=GUICtrlCreateLabel("Région, Hauteur:",10,$v+3,135)
$chh=GUICtrlCreateInput($icuHaut,$h,$v,200)
$v+=$pas
$l6=GUICtrlCreateLabel("Intervalle de capture (ms):",10,$v+3,155)
$chi=GUICtrlCreateInput($intervalle,$h,$v,200)
$v+=$pas
$l7=GUICtrlCreateLabel("Durée Maximale (s):",10,$v+3,135)
$chdm=GUICtrlCreateInput($duree,$h,$v,200)

$l8=GUICtrlCreateLabel("Rappel :    {Ctrl} ²    pour terminer la capture",50,300,380)
GUICtrlSetColor(-1,0xAA0000)

GUICtrlSetFont($l1,10,400,-1,"Arial")
GUICtrlSetFont($l2,10,400,-1,"Arial")
GUICtrlSetFont($l3,10,400,-1,"Arial")
GUICtrlSetFont($l4,10,400,-1,"Arial")
GUICtrlSetFont($l5,10,400,-1,"Arial")
GUICtrlSetFont($l6,10,400,-1,"Arial")
GUICtrlSetFont($l7,10,400,-1,"Arial")


$btok=GUICtrlCreateButton("OK",50,350,100,30)
$btesc=GUICtrlCreateButton("Abandon",250,350,100,30)

GUISetState()

While 1
	$csmsg = GUIGetMsg()
	If ($csmsg = $GUI_EVENT_CLOSE) Or ($csmsg = $btesc) Then
		ExitLoop
	EndIf
	
	If $csmsg = $btok Then
		$icudir=GUICtrlRead($chdoss)
		$icuX=GUICtrlRead($chx)
		$icuY=GUICtrlRead($chy)
		$icuLarg=GUICtrlRead($chw)
		$icuHaut=GUICtrlRead($chh)
		$intervalle=GUICtrlRead($chi)
		$duree=GUICtrlRead($chdm)
		ExitLoop
	EndIf
WEnd
GUIDelete($gui)
If ($csmsg = $GUI_EVENT_CLOSE) Or ($csmsg = $btesc) Then
	Exit
EndIf


$duree=$duree*1000

If Not FileExists($icudir) Then
	DirCreate($icudir)
EndIf

ecrit_ini()

Func ecrit_ini()
	IniWrite(@ScriptDir & "\icu.ini", "Param", "folder", $icudir)
	IniWrite(@ScriptDir & "\icu.ini", "Param", "x", $icuX)
	IniWrite(@ScriptDir & "\icu.ini", "Param", "y", $icuY)
	IniWrite(@ScriptDir & "\icu.ini", "Param", "w", $icuLarg)
	IniWrite(@ScriptDir & "\icu.ini", "Param", "h", $icuHaut)
	IniWrite(@ScriptDir & "\icu.ini", "Param", "intervalle", $intervalle)
	If $duree>60000 Then
		$duree=60000
	EndIf
	IniWrite(@ScriptDir & "\icu.ini", "Param", "dureeMaxi", ($duree/1000))
EndFunc   ;==>ecrit_ini


Global $icudesktop,$icuDDC,$icuCDC,$icuBMP,$icuCLSID,$icuhImage,$icupGUID, $icutGUID,$icubufferimage,$icubufferimage2
Global $BitmapData0,$BitmapData1,$icuScan0,$icuScan1,$icusize0,$ptr0,$ptr1
Global $postbat

$postbat="CD /D"& $icudir & @CRLF

HotKeySet("^²","fin")

fastcaptprepar()
$init=TimerInit()
$debut=TimerInit()
$temps=$intervalle
While 1
	If TimerDiff($debut)>=$temps Then
		fastcapt()
		$temps += $intervalle
	Else
		sleep(10)
	EndIf
	If TimerDiff($init)>$duree Then ExitLoop
WEnd
$fin=TimerDiff($debut)
fastcaptclose()
_GDIPlus_Shutdown()
MsgBox(0,"Nb fichiers",$icunum,2)
;MsgBox(0,"Duree",TimerDiff($init)/1000)

$f=FileOpen($icudir &"nbfichiers.txt",2)
FileWrite($f,String($icunum))
FileClose($f)

Exit




Func fin()
	$duree=1
	HotKeySet("^²")
EndFunc





Func fastcaptprepar()
	$icudesktop = _WinAPI_GetDesktopWindow()
	$icuDDC = _WinAPI_GetDC($icudesktop)
	$icuCDC = _WinAPI_CreateCompatibleDC($icuDDC)
	$icuBMP = _WinAPI_CreateCompatibleBitmap($icuDDC, $icuLarg, $icuHaut)
	_GDIPlus_Startup()
	$icuCLSID = _GDIPlus_EncodersGetCLSID("BMP")
	$icutGUID = _WinAPI_GUIDFromString($icuCLSID)
	$icupGUID = DllStructGetPtr($icutGUID)
	$icubufferimage=""
EndFunc



Func fastcaptclose()
	_GDIPlus_BitmapUnlockBits($icubufferimage, $BitmapData0)
	_GDIPlus_ImageDispose($icuhImage)
	_WinAPI_DeleteObject($icuBMP)
	_WinAPI_ReleaseDC($icudesktop, $icuDDC)
	_WinAPI_DeleteDC($icuCDC)
	_WinAPI_DeleteObject($icuBMP)
	_GDIPlus_Shutdown()
	sleep(250)
	$postbat &= "exit" & @CRLF
	$f=FileOpen($icudir & "deldoublon.bat",2)
	FileWrite($f,$postbat)
	FileClose($f)
EndFunc



Func fastcapt()
	_WinAPI_SelectObject($icuCDC, $icuBMP)
	_WinAPI_BitBlt($icuCDC, 0, 0, $icuLarg, $icuHaut, $icuDDC, $icuX, $icuY, $__SCREENCAPTURECONSTANT_SRCCOPY)
	#cs
	$aCursor = _WinAPI_GetCursorInfo()
	If $aCursor[1] Then
		$hIcon = _WinAPI_CopyIcon($aCursor[2])
		$aIcon = _WinAPI_GetIconInfo($hIcon)
	EndIf
	#ce
	$icunum+=1
	$lfichiers[$icunum]=$icufilename & (10000+$icunum) &'.bmp'
	$aResult = DllCall($ghGDIPDll, "int", "GdipCreateBitmapFromHBITMAP", "hwnd", $icuBMP, "hwnd", 0, "int*", 0)
	$icuhImage = $aResult[3]

	DllCall($ghGDIPDll, "int", "GdipSaveImageToFile", "hwnd", $icuhImage, "wstr", $lfichiers[$icunum], "ptr", $icupGUID, "ptr", 0)	
EndFunc

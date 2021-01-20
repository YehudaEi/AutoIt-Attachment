#include-once
#include <WinAPI.au3>
#include <GDIPlus.au3>
#Include <Array.au3>

#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

Global $lfichiers[9999]
Global $icudir = IniRead(@ScriptDir & "\icu.ini", "Param", "folder", "L:\temp\")
Global $icufilename = $icudir & "c"
Global $icunum=0
Global $icuX = IniRead(@ScriptDir & "\icu.ini", "Param", "x",100)
Global $icuY = IniRead(@ScriptDir & "\icu.ini", "Param", "y",20)
Global $icuLarg = IniRead(@ScriptDir & "\icu.ini", "Param", "w",800)
Global $icuHaut = IniRead(@ScriptDir & "\icu.ini", "Param", "h",500)
Global $intervalle = IniRead(@ScriptDir & "\icu.ini", "Param", "intervalle",100)
Global $duree = IniRead(@ScriptDir & "\icu.ini", "Param", "dureeMaxi",60)
$duree=$duree*1000

$f=FileOpen($icudir &"listefichiers.txt",0)
$tmp=FileRead($f)
$lfichiers=StringSplit($tmp,'|')
FileClose($f)
_ArrayDelete($lfichiers,1)

$f=FileOpen($icudir &"nbfichiers.txt",0)
$icunum=FileRead($f)
FileClose($f)

$gui=GUICreate("ICU-Player                  {Echap} ou {Esc} pour abandonner. ",$icuLarg,$icuHaut,-1,-1,-1)
$fichier = $icufilename & (10000+1) &'.jpg'
$image=GUICtrlCreatePic($fichier,0,0,$icuLarg,$icuHaut,-1)
GUISetState()

HotKeySet("{ESC}","fin")


_GDIPlus_StartUp()
$gdiCLSID = _GDIPlus_EncodersGetCLSID("JPG")

$init=TimerInit()
$num=0
$debut=TimerInit()
$temps=$intervalle

While 1
	$num+=1
	If $num>$icunum Then	ExitLoop
	$fichier = $icufilename & (10000+$num) &'.jpg'
	If $lfichiers[$num]=1 Then  $buffer1=$fichier
	If $lfichiers[$num]=2 Then  $buffer2=$fichier
	If $lfichiers[$num]=-1 Then  $fichier=$buffer1
	If $lfichiers[$num]=-2 Then  $fichier=$buffer2

	$gdimage=_GDIPlus_ImageLoadFromFile($fichier)
	$gdih = _GDIPlus_GraphicsCreateFromHWND($gui)
	_WinAPI_RedrawWindow($image, 0, 0, $RDW_UPDATENOW)
    _GDIPlus_GraphicsDrawImage($gdih, $gdimage, 0, 0)
    _WinAPI_RedrawWindow($image, 0, 0, $RDW_VALIDATE)
	_GDIPlus_ImageDispose($gdimage)
	If TimerDiff($debut)<$temps Then
		Sleep($temps-TimerDiff($debut))
	EndIf	
	$temps += $intervalle
WEnd
_GDIPlus_ShutDown ()
MsgBox(0,"Terminé","   Durée :    "& Int(TimerDiff($init)/100)/10 &" s")
Exit



Func fin()
	HotKeySet("{ESC}")
	$icunum=1
EndFunc



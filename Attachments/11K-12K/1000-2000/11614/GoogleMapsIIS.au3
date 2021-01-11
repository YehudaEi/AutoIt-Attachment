#include <GUIConstants.au3>
#include <IE.au3>
#include <File.au3>
#NoTrayIcon

FileInstall("GoogleMapsIIS.html",@TempDir&"\GoogleMapsIIS.html",1)

If $CmdLine[0] <> 0 Then
	If StringLeft($CmdLine[1],2)="/c" Then
		MsgBox(16,"Error","This screen saver has no options you can configure.")
		Exit
	ElseIf $CmdLine[1]="/p" Then
		Exit
	EndIf
EndIf

Global Const $SM_VIRTUALWIDTH = 78
Global Const $SM_VIRTUALHEIGHT = 79
$VirtualDesktopWidth = DLLCall("user32.dll", "int", "GetSystemMetrics", "int", $SM_VIRTUALWIDTH)
$VirtualDesktopWidth = $VirtualDesktopWidth[0]
$VirtualDesktopHeight = DLLCall("user32.dll", "int", "GetSystemMetrics", "int", $SM_VIRTUALHEIGHT)
$VirtualDesktopHeight = $VirtualDesktopHeight[0]

Global $oIE = ObjCreate("Shell.Explorer.2")
Global $oIEData = ObjCreate("Shell.Explorer.2")
Global $IssData, $IssDataForm

Global $MouseStartPos=MouseGetPos()
AdlibEnable("AdlibExiter",1000)

GUICreate("IIS in Google Maps",$VirtualDesktopWidth+8,$VirtualDesktopHeight+8,0,0,$WS_POPUP, $WS_EX_TOOLWINDOW + $WS_EX_TOPMOST)
GUISetBkColor(0x000000)

GUICtrlCreateObj($oIE,-2,-2,$VirtualDesktopWidth+6,$VirtualDesktopHeight+6)
GUICtrlCreateObj($oIEData,-1,0,1,1)

_FileWriteToLine(@TempDir&"\GoogleMapsIIS.html",24,'<div id="map" style="width: '&$VirtualDesktopWidth+2&'px; height: '&$VirtualDesktopHeight+2&'px"></div>',1)

GUISetState()

$oIE.navigate(@TempDir&"\GoogleMapsIIS.html")
$oIEData.navigate("http://www.amsat.org/amsat-new/tools/predict/satloc.php?lang=en&satellite=ISS")

Sleep(10000)
Global $ReloadTimer=TimerInit()
While 1
	If TimerDiff($ReloadTimer) > 7200000 Then
		$oIEData.navigate("http://www.amsat.org/amsat-new/tools/predict/satloc.php?lang=en&satellite=ISS")
		$ReloadTimer=TimerInit()
		Sleep(10000)
	EndIf
	$IssDataForm=_IEFormGetObjByName($oIEData,"oF")
	$IssData=_IEBodyReadText($IssDataForm)
	$IssData=StringSplit($IssData,@CR)
	For $i=1 To $IssData[0]
		If StringInStr($IssData[$i],"Current Location:") <> 0 Then
			$IssData=$IssData[$i]
			ExitLoop
		EndIf
	Next
	$IssData=StringRight($IssData,StringLen($IssData)-19)
	If StringLen($IssData)>4 Then
		$IssData=StringSplit($IssData," ")
		If StringRight($IssData[1],1)="W" Then
			$IssData[1]="-"&StringTrimRight($IssData[1],1)
		Else
			$IssData[1]=StringTrimRight($IssData[1],1)
		EndIf
		If StringRight($IssData[2],1)="S" Then
			$IssData[2]="-"&StringTrimRight($IssData[2],1)
		Else
			$IssData[2]=StringTrimRight($IssData[2],1)
		EndIf
		
		$MapMoveForm=_IEFormGetObjByName($oIE,"MapMoveForm")
		$LatInput=_IEFormElementGetObjByName($MapMoveForm,"latInput")
		$LongInput=_IEFormElementGetObjByName($MapMoveForm,"longInput")
		_IEFormElementSetValue($LatInput,$IssData[2])
		_IEFormElementSetValue($LongInput,$IssData[1])
		_IELinkClickByText($oIE,"move")
		Sleep(5000)
	EndIf
WEnd

Func AdlibExiter()
	If ABS(MouseGetPos(0)-$MouseStartPos[0])>5 OR ABS(MouseGetPos(1)-$MouseStartPos[1])>5 Then
		Exit
	Else
		$MouseStartPos=MouseGetPos()
	EndIf
EndFunc	
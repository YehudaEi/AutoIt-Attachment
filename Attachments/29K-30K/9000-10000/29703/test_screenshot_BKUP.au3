#include <ScreenCapture.au3>
#include <Date.au3>

Opt("WinTitleMatchMode", 2)

$i=1
$tcname=InputBox("Testing", "tcname/foldername.", "", "")

HotKeySet("{F3}", "Start")
HotKeySet("+{F3}", "Stop")
HotKeySet("{F4}", "Clear")
HotKeySet("{F6}", "Manual")
HotKeySet("{F7}", "LocChange")
HotKeySet("{F8}", "LocOpen")
HotKeySet("{F10}", "Term")
DirCreate ( "c:\Screenshots\" & $tcname )


TrayTip("Info","[F3]to automatically take screenshot,[F4]clear the data,[F6]To take 1 screenshot,[F7]location change,[F8]open location,[F10]Exit.",3,1)


;;;; Body of program would go here ;;;;
While 1
    Sleep(100)
WEnd
;;;;;;;;

Func Start()
	while $i>0
		if WinActive("Microsoft SQL Server Management Studio") or WinActive("Microsoft Excel -") or WinActive("- Microsoft Internet Explorer") then 
			_ScreenCapture_Capture("c:\Screenshots\" & $tcname & "\Image_["& _DateTimeFormat( _NowCalc(),1) & "]_" & $i & ".GIF")
			$i=$i+1
			sleep(1000)
		EndIf
	WEnd
EndFunc

Func manual()
		;if WinActive("Microsoft SQL Server Management Studio") or WinActive("Microsoft Excel -") or WinActive("- Microsoft Internet Explorer") then 
			_ScreenCapture_Capture("c:\Screenshots\" & $tcname  & "\Image_["& _DateTimeFormat( _NowCalc(),1) & "]_" & $i & ".GIF")
			$i=$i+1
			sleep(1000)
		;EndIf
EndFunc

Func LocChange()
	$tcname=InputBox("Testing", "tcname/foldername.", "", "")
	DirCreate ( "c:\Screenshots\" & $tcname )
	$i=1
EndFunc	

Func Clear()
	TrayTip("Clearing images","From c:\Screenshots\" & $tcname,30,0)
	;sleep(3000)
    ;Exit 0
	$i=1
	FileDelete("c:\Screenshots\" & $tcname  & "\*.GIF")
EndFunc

Func Stop()
	While 1
		Sleep(100)
	WEnd
EndFunc	

Func LocOpen()
	ShellExecute("c:\Screenshots\" & $tcname)
EndFunc	

Func Term()
	TrayTip("","Terminated",30,0)
	sleep(3000)
    Exit 0
EndFunc	

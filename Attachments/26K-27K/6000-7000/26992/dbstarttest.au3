#include <GUIConstants.au3>
#include <WindowsConstants.au3>
#include <Process.au3>
#include <StaticConstants.au3>

Do	
									
			Global Const $PBS_SMOOTH              = 0x00000001 ; The progress bar displays progress status in a smooth scrolling bar
			Global Const $PBS_MARQUEE             = 0x00000008 ; The progress bar moves like a marquee
			Global $i=0
			
			GUICreate("Start Database", 410, 380,-1,-1,$WS_EX_DLGMODALFRAME, $WS_EX_TOPMOST)
			GUICtrlCreateLabel("STARTING SPIRITPOS DATABASE...PLEASE WAIT", 60, 30, 350, 300)
			GUISetState(@SW_DISABLE)
			
			$Progress6 = GUICtrlCreateProgress(24, 86, 360, 25, BitOR($PBS_SMOOTH,$PBS_MARQUEE))

			GUISetState()

			AdlibEnable("Advance", 50)
Until ProcessExists ( "dbeng9.exe" )		
FileChangeDir("d:\program files\sybase\sql anywhere 9\win32")
RunWait("dbeng9.exe -n pos1 -qi d:\SpiritPOS\Data\SpiritPOS.db -gk all") 

Func Advance()
$i=$i+1

GUICtrlSetData($Progress6, $i)

If $i = 100 Then $i = 0

EndFunc
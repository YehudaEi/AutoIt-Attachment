#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=L:\icons\Cartoons\Rafiki.ico
#AutoIt3Wrapper_outfile=locker.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <Date.au3>
#Include <Misc.au3>
_Singleton("Locker")
;Opt ("TrayIconHide",0)
Opt ("RunErrorsFatal",0)
Opt("TrayAutoPause",0) 
Opt("TrayMenuMode",1)

Opt("TrayMenuMode",1)   ; Default tray menu items (Script Paused/Exit) will not be shown.

$timeleft = TrayCreateItem("Locker by Daniel")
TrayCreateItem("")
TraySetState()

$runtime = 0
dim $OldPos[2]


;read INI
$lastrundate = IniRead ("locker.ini","general","lastrundate",_NowCalcDate())
$timer = IniRead ("locker.ini","general","timer",0)
$timemax = IniRead ("locker.ini","general","MaxTimeMins",180)

;write to INI
IniWrite ("locker.ini","general","lastrundate",_NowCalcDate())
IniWrite ("locker.ini","general","MaxTimeMins",$timemax)



while 1
	;if its a new day then...
	if $lastrundate <> _NowCalcDate() then 
		$lastrundate = _NowCalcDate()
		$timer = 0
		$runtime = 0
		IniWrite ("locker.ini","general","timer",0)
		IniWrite ("locker.ini","general","lastrundate",_NowCalcDate())
	endif
		
	if (@WDAY =1 or @WDAY = 7) Then
		TrayItemSetText($timeleft,"Weekend Mode")
		TraySetToolTip ( "Weekend Mode")
		Sleep (60000)
	else
		$pos = MouseGetPos()
		if $pos[0] = $OldPos[0] and $pos[1] = $OldPos[1] then ;if mouse hasn't moved
			;pc is idle!
			ConsoleWrite ("IDLE ("&$pos[0]&","&$pos[1]&") ("&$OldPos[0]&","&$OldPos[1]&")"&@CRLF)
			TrayItemSetText($timeleft,"PC is IDLE")
			TraySetToolTip ( "PC is IDLE")
			Sleep (10000)
			$OldPos = $pos
		else
			; pc isn't idle
			ConsoleWrite ("IN USE ("&$pos[0]&","&$pos[1]&") ("&$OldPos[0]&","&$OldPos[1]&")"&@CRLF)

			;time is up!
			if $runtime + $timer > ($timemax*60) Then
				LockWindows()
				for $i = 60 to 1 step -1
					ToolTip ("Locking again in :"&$i,100,20)
					Sleep (1000)
				next
				ToolTip ("")
			;time isn't up
			Else
				;update tool tips
				$MinsLeft  = Round (($timemax)- (($runtime/60) + ($timer/60)),1) 
				TrayItemSetText($timeleft,$minsleft&" minutes left!")
				TraySetToolTip ( $minsleft&" minutes left!")
				
				;warning messages
				if (Round ($MinsLeft,1)) = 10 Then
					TrayTip ("Warning. You have used up all your computer time!",$minsleft & " minutes left!",5000,2)
				endif
				if (Round ($MinsLeft,1)) = 5 Then
					TrayTip ("Warning. You have used up all your computer time!",$minsleft & " minutes left!",5000,2)
				endif
				if  $MinsLeft < 1 Then
					TrayTip ("Warning. You have used up all your computer time!",$minsleft & " minutes left!",5000,2)
				endif
			endif
			
			;ticker
			Sleep (10000)
			$runtime += 10 ;seconds
			;mouse tracking
			$OldPos = $pos
		endif
	endif
		
	IniWrite ("locker.ini","general","timer",($runtime + $timer))
	
	if not (ProcessExists("launchlocker.exe")) then
		Run ("launchlocker.exe")
	EndIf
WEnd


func OnAutoItExit ()
	if not (ProcessExists("launchlocker.exe")) then
		Run ("launchlocker.exe")
	EndIf
EndFunc

func LockWindows()
	run("RUNDLL32 USER32.DLL,LockWorkStation") 
EndFunc
; ----------------------------------------------------------------------------
;
; Script : Wait for a specific window (usefull for multilingual uninstaller)
; Author: Régis PARRET
;
; ----------------------------------------------------------------------------
; 

	
		
func WaitForThisWindow($Title,$Param1,$Param2,$Param3,$Param4)
; here are the parameters : $title = the title of the window you are looking for
; param1 to 4 = the string you are looking for

$LoopOn = 1

While $LoopOn = 1
	
$OpenedWindows = WinList()	

For $WindowsCounter = 1 to $OpenedWindows[0][0]
  	If $OpenedWindows[$WindowsCounter][0] <> "" and WindowIsVisible($OpenedWindows[$WindowsCounter][0]) Then
	$WindowTitle = WinGetTitle($OpenedWindows[$WindowsCounter][0])
		if StringInStr($WindowTitle,$title) then ;is this the wanted window ?
		$WindowText = WinGetText($OpenedWindows[$WindowsCounter][0],"")
			if StringInStr($WindowText,$Param1) and  StringInStr($WindowText,$Param2) and StringInStr($WindowText,$Param3) and StringInStr($WindowText,$Param4) then ; is the wanted text in the window ?
			$LoopOn = 0
			$FoundWindow = $WindowTitle ; we got the good one
			ExitLoop
			endif
		endif
	EndIf
Next
;we restart with newly appeared windows 
WEnd
EndFunc


Func WindowIsVisible($handle)
  If BitAnd( WinGetState($handle), 2 ) Then 
    Return 1
  Else
    Return 0
  EndIf

EndFunc
		
		
		
		
		
		
		
		
		
	




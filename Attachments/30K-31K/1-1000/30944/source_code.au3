
#include <IE.au3>



$oIE = _IECreate ("http://www.entheosweb.com/website_design/pop_up_windows.asp",0, 0) ;;open in invisible mode
$sText = _IEBodyReadHTML($oIE) ;;
#ConsoleWrite($sText)

Sleep(500)
If $sText Then
 $subString = StringRegExp($sText, "(?i)(?s)allows you to open a browser window in any size you specify.(.+?)\s*Click here", 1)
    If NOT @Error Then
	ConsoleWrite($subString[0])
	$fileWrite = FileOpen("Output.txt", 1)
	; Check if file opened for reading OK
	If $fileWrite = -1 Then
		MsgBox(0, "Error", "Unable to open file Output.txt.")
	Exit
	EndIf
	FileWrite($fileWrite,$subString[0])
	FileWrite($fileWrite,"******")
  
	$oLinks = _IELinkGetCollection($sText)

	For $oLink in $oLinks  
		$sLinkText = _IEPropertyGet($oLink, "innerText")
		;ConsoleWrite($sLinkText)
		;;click on the the link in the same line of "allows you to open a browser window in any size you specify"
		_IEAction($oLink, "click") ;;here the link text may not be always "Click me"
		
		$sTextPopUpIE = _IEBodyReadText($oIE)
		FileWrite($fileWrite,$sTextPopUpIE)
			;ExitLoop
		_IEQuit ($oLink) ;;close the pop up IE window
		
	Next
  
  
	FileClose($fileWrite)

	EndIf
	If @Error Then
		ConsoleWrite("Message:Cannot find Pattern")
	EndIf
EndIf



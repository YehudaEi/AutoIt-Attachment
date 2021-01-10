#include <GuiConstants.au3>
#Include <GuiEdit.au3>
#include <IE.au3>
#include <Array.au3>


opt("GUIOnEventMode", 1)
$console_tra = 0
$consoleOnTop = 1
$title = "BrowseConsole v0.6"
$elementGlobal=""


;~ $oIE = _IECreate ("www.google.com")

;~ _IELoadWait ($oIE)
;~ _IEQuit($oIE)
;~ Global $oIE = _IECreate ("www.google.com", 1, 0)

Global $browseConsoleIni= @ScriptDir & "\BrowseConsole.ini"
$exitFail = IniRead($browseConsoleIni,"error","exitfail",0)


IniWrite($browseConsoleIni,"error","exitfail",1)



_loadSetting()


	Global $fromini_x = IniRead($browseConsoleIni, "setting","x","")
	Global 	$fromini_y = IniRead($browseConsoleIni, "setting","y","")
	Global $fromini_w = IniRead($browseConsoleIni, "setting","w","")
	Global $fromini_h = IniRead($browseConsoleIni, "setting","h","")
	Global $fromini_sl = IniRead($browseConsoleIni, "setting","sl","")
	Global $fromini_ss = IniRead($browseConsoleIni, "setting","ss","")
	Global $fromini_startPage = IniRead($browseConsoleIni, "setting","startpage","")
$linkname = ""

if $fromini_startPage = "" Then
	$location = "www.google.com"
;~ ElseIf StringLower($fromini_startPage) = "blank" Then
;~ 	$location = "about:blank"
Else
	$location = $fromini_startPage
EndIf


if $exitFail = 1 Then
;~ 	ConsoleWinWrite($ConsoleID, ""
	$location = IniRead($browseConsoleIni, "error", "url",$fromini_startPage)
EndIf


$window_tra = 0
Global $oIE = _IECreate ($location, 0, 0)

Global $window_visible = 0


global $stack[1]
		$stack[0] = 0
		
if $fromini_sl = 1 Then
	_stackOpenFile()
EndIf


;~ _IELoadWait ($oIE)
Global $winhandle = WinGetHandle(WinGetTitle(_IEPropertyGet($oIE, "title")))
;~ MsgBox(0,"",_IEPropertyGet($oIE, "internet"))
Global $WAITLOAD = 0
Global $lastImagMethod="all"
Global $ConsoleID=0
Global $CLEAR = 1
;~ $ConsoleID = ConsoleWinCreate(-1, -1, 638, 326, "Console Demo...", "Starting demo...", True)

$larghezzaConsole= @DesktopWidth

if @DesktopHeight >= 500 Then
	$altezzaConsole=500
Else
	$altezzaConsole=@DesktopHeight
EndIf


if $fromini_x = "" Then
	$fromini_x = -1
EndIf

if $fromini_y = "" Then
	$fromini_y = -1
EndIf

if $fromini_w = "" Then
	$fromini_w = $larghezzaConsole
EndIf

if $fromini_h = "" Then
	$fromini_h = $altezzaConsole
EndIf

;~ $ConsoleID = ConsoleWinCreate(-1, -1, $fromini_w, $fromini_h, $title, "Starting browser...", True, $WS_EX_TRANSPARENT)
$ConsoleID = ConsoleWinCreate(-1, -1, $fromini_w, $fromini_h, $title, "Starting browser...", True)

if $fromini_x > -1 OR $fromini_y > -1 Then
	WinMove($consoleHandle, "", $fromini_x, $fromini_y)
EndIf

$link = 1
$command=""



While 1
	
	if WinActive($consoleHandle) = 0 Then
		WinActivate($consoleHandle)
	EndIf
	
	$sHTML = _IEBodyReadHTML ($oIE)
	
	$idLen=1
	$oldHtml=$sHTML
	Do
		$sHTML &= StringMid($oldHtml, $idLen, 100) & @CRLF
		$idLen += 50
	Until $idLen >= StringLen($oldHtml)

;~ 	ClipPut($oldHtml & @CRLF & "************************************" & @CRLF & $sHTML)

;~ 	MsgBox(0,"",$sHTML)
	if ($link = 1 OR $link=2)AND _IEPropertyGet($oIE, "readystate") = 4 Then
		If $link=1 Then
			$html_array = _getLinkArray($oIE)
		Else
			$html_array = _getLinkArray($oIE,0,$linkname)
		EndIf
		
;~ 		for $i = 0 to $html_array[0]
;~ 			ConsoleWinWrite($ConsoleID, $i & "- " & $html_array[$i])
;~ 		Next
		
;~ 		if $html_array[0] <= 2 Then
;~ 			IniWrite($browseConsoleIni,"error","url",$html_array[2])
;~ 			ConsoleWinWrite($ConsoleID, $html_array[2])
;~ 			_IENavigate($oIE, $html_array[2], $WAITLOAD)
;~ 		Else
			ConsoleWinWrite($ConsoleID, _arrayToText($html_array))
;~ 		EndIf
		$link = 0
		
		
	EndIf
	
	if $command <> "form" Then
		$command = ConsoleWinInput($ConsoleID, "> ")
	EndIf

;~ 	MsgBox(0,"","|" & $command & "|")

	if $CLEAR = 1 Then
;~ 		ConsoleWinClear($ConsoleID)
	Else
		$CLEAR = 1
	EndIf
	
	If $command = "help" Then
		$helpText =@CRLF & @CRLF & "***************** " & StringUpper($title) & " HELP *****************"
		$helpText &= @CRLF & @CRLF & "COMMAND" & @TAB & @TAB & @TAB & @TAB & "DESCRIPTION"
		$helpText &= @CRLF & @CRLF & "exit" & @TAB & @TAB & @TAB & @TAB & "exit from BrowserConsole"
		$helpText &= @CRLF & "read"& @TAB & @TAB & @TAB & "read the webpage in textual mode"
		$helpText &= @CRLF & "[return]"& @TAB & @TAB & @TAB & "return the state of the page (loaded or not)"
		$helpText &= @CRLF & "help"& @TAB  & @TAB & @TAB & @TAB & "help menu"
		$helpText &= @CRLF & "settings"& @TAB  & @TAB & @TAB & @TAB & "setting GUI"
		$helpText &= @CRLF & "clear OR cls"& @TAB & @TAB & @TAB & "clear the screen"
		$helpText &= @CRLF & "CTRL+PAGUP/PAGDOWN"& @TAB & @TAB & "in ""show"" mode scroll the IE window UP and DOWN"
;~ 		$helpText &= @CRLF & "CTRL+UP/DOWN"& @TAB & @TAB & @TAB & "in ""show"" mode scroll the IE window UP and DOWN"
		$helpText &= @CRLF & "linktot"& @TAB  & @TAB & @TAB & @TAB & "show link text and url"
		$helpText &= @CRLF & "linkurl"& @TAB  & @TAB & @TAB & @TAB & "show link url"
		$helpText &= @CRLF & "link" & @TAB & @TAB & @TAB & @TAB & "show link text"
		$helpText &= @CRLF & "back" & @TAB & @TAB & @TAB & @TAB & "back button of browser"
		$helpText &= @CRLF & "url [url]" & @TAB & @TAB & @TAB & "navigate to [url] or [%ElementOfStack]"
		$helpText &= @CRLF & "html" & @TAB & @TAB & @TAB & @TAB & "show page's html"
		$helpText &= @CRLF & "cliphtml" & @TAB & @TAB & @TAB & "copy html to clipboard"
		$helpText &= @CRLF & "hide" & @TAB & @TAB & @TAB & @TAB & "hide browser (start default)"
		$helpText &= @CRLF & "show" & @TAB & @TAB & @TAB & @TAB & "unhide browser and split the screen"
		$helpText &= @CRLF & "showtra {optionParam}" & @TAB & @TAB & "unhide browser and lay upon under console, and set console transparency, param option: gradient transparency"
		$helpText &= @CRLF & "form > formelement > formvalue" & @TAB & "form(return), show forms AND select element form (ENTER) (IF YOU PRESS ENTER WITHOUT TEXT IS CONSIDERATED SUBMIT)> select value (ENTER)"
		$helpText &= @CRLF & "stackadd [url]" & @TAB & @TAB & @TAB & "add URL in stack"
		$helpText &= @CRLF & "stackdel [url]" & @TAB & @TAB & @TAB & "del URL in stack"
		$helpText &= @CRLF & "stackshow [url]"& @TAB & @TAB & @TAB & "show all URL in stack"
		$helpText &= @CRLF & "stacksave [url]"& @TAB & @TAB & @TAB & "save stack in file"
		$helpText &= @CRLF & "stackopen [url]"& @TAB & @TAB & @TAB & "open stack from file"
		$helpText &= @CRLF & "images {optionalParam}" &  @TAB & @TAB & "show the image/s information of the page, param optional: big/medium/small"
		$helpText &= @CRLF & "image [imageId]" &  @TAB & @TAB & @TAB &  "show the image in GUI, before call images and get imageID"
		$helpText &= @CRLF & "" & @TAB & @TAB & @TAB & ""
		
		
		
		ConsoleWinWrite($ConsoleID, $helpText)
		
	ElseIf _analizeCommand($command, "exit") Then
		_IEQuit($oIE)
		Exit
	
	ElseIf _analizeCommand($command, "images")Then
		
		
		
		if $extendCommandArray[0] = 1 Then
			$filter= "all"
		Elseif $extendCommandArray[2] = "big" Then
			$filter= "big"
		Elseif $extendCommandArray[2] = "normal" OR $extendCommandArray[2] = "medium" Then
			$filter= "medium"
		Elseif $extendCommandArray[2] = "small" Then
			$filter= "small"
		EndIf
		
		
			$oImgs = _IEImgGetCollection ($oIE)
			$iNumImg = @extended
			ConsoleWinWrite($ConsoleID, "There are " & $iNumImg & " images on the page")
			if $iNumImg <> 0 Then
				$idimg = 1
				$imgall="ID" & @TAB & _stringlenunivoquity("FILENAME ", 20) & @TAB & @TAB & @TAB & " WIDTH " & @TAB & @TAB & " HEIGHT " & @TAB & @TAB & "SRC"
				For $oImg In $oImgs
					
					if $filter = "big" AND $oImg.width > 600 Then
						$imgall&= @CRLF & $idimg & @TAB & _stringlenunivoquity($oImg.nameProp, 20) & @TAB & @TAB & @TAB & $oImg.width & @TAB & @TAB & $oImg.height & @TAB & @TAB & $oImg.src
					Elseif $filter = "medium" AND $oImg.width <= 600 AND $oImg.width > 300 Then
						$imgall&= @CRLF & $idimg & @TAB & _stringlenunivoquity($oImg.nameProp, 20) & @TAB & @TAB & @TAB & $oImg.width & @TAB & @TAB & $oImg.height & @TAB & @TAB & $oImg.src
					Elseif $filter = "small" AND $oImg.width <= 300 Then
						$imgall&= @CRLF & $idimg & @TAB & _stringlenunivoquity($oImg.nameProp, 20) & @TAB & @TAB & @TAB & $oImg.width & @TAB & @TAB & $oImg.height & @TAB & @TAB & $oImg.src
					ElseIf $filter = "all" Then
						$imgall&= @CRLF & $idimg & @TAB & _stringlenunivoquity($oImg.nameProp, 20) & @TAB & @TAB & @TAB & $oImg.width & @TAB & @TAB & $oImg.height & @TAB & @TAB & $oImg.src
					EndIf
				$idimg += 1

				Next
				$lastImagMethod = $filter
				ConsoleWinWrite($ConsoleID, $imgall)
			EndIf

	ElseIf _analizeCommand($command, "image") Then
			$filter = $lastImagMethod
			
			$oImgs = _IEImgGetCollection ($oIE)
			$iNumImg = @extended
;~ 			ConsoleWinWrite($ConsoleID, "There are " & $iNumImg & " images on the page")
			if $iNumImg <> 0 Then
				$idimg = 1
				$imgall="ID" & @TAB & _stringlenunivoquity("FILENAME ", 20) & @TAB & @TAB & @TAB & " WIDTH " & @TAB & @TAB & " HEIGHT " & @TAB & @TAB & "SRC"
				For $oImg In $oImgs
					
					
					
					if $filter = "big" AND $oImg.width > 600 Then
						$img_name= $oImg.nameProp
						$img_w= $oImg.width 
						$img_h= $oImg.height 
						$img_src = $oImg.src
					Elseif $filter = "medium" AND $oImg.width <= 600 AND $oImg.width > 300 Then
						$img_name= $oImg.nameProp
						$img_w= $oImg.width 
						$img_h= $oImg.height 
						$img_src = $oImg.src
					Elseif $filter = "small" AND $oImg.width <= 300 Then
						$img_name= $oImg.nameProp
						$img_w= $oImg.width 
						$img_h= $oImg.height 
						$img_src = $oImg.src
					ElseIf $filter = "all" Then
						$img_name= $oImg.nameProp
						$img_w= $oImg.width 
						$img_h= $oImg.height 
						$img_src = $oImg.src
					EndIf
				if $idimg = $extendCommandArray[2] Then
					ExitLoop
				EndIf
				$idimg += 1

				Next
				
				$extension = StringMid($img_src, StringInStr($img_src, ".",0,-1)+1)
				$localfilename = @TempDir & "\"& "BrowseConsole_imagetemp." & $extension
;~ 				$localfilename = @DesktopDir & "\"& @SEC & "_imagetemp."& $extension
				ConsoleWinWrite($ConsoleID, "Downloading image... (" & InetGetSize($img_src) & " bytes)")
				InetGet($img_src, $localfilename)
				
				_gestionImage($localfilename, $img_w, $img_h)
;~ 				SplashImageOn("Splash Screen", $localfilename)
;~ 				Sleep(3000)
;~ 				SplashOff()
				ConsoleWinWrite($ConsoleID, $imgall)
			EndIf
	
	ElseIf _analizeCommand($command, "h") Then
		_minimize()
	ElseIf _analizeCommand($command, "settings") Then
		if _GUI_setting() = 1 Then
			ConsoleWinWrite($ConsoleID, "Setting change saved")
		Else
			ConsoleWinWrite($ConsoleID, "Setting change not saved")
		EndIf
	ElseIf _analizeCommand($command, "cls") OR  _analizeCommand($command, "clear") Then
		ConsoleWinClear($ConsoleID)
	ElseIf _analizeCommand($command, "stacksave") Then
		_stackSaveFile()
		ConsoleWinWrite($ConsoleID, "Stack save in file")
	ElseIf _analizeCommand($command, "stackopen") Then
		_stackOpenFile()
		ConsoleWinWrite($ConsoleID, "Stack open from file (" & $stack[0] & " element/s)")
	ElseIf _analizeCommand($command, "stackadd") Then
		_stackAdd($extendCommandArray[1])
	ElseIf _analizeCommand($command, "stackshow") Then
		$txt = _stackShow()
		if StringLen($txt) = 0 Then
			ConsoleWinWrite($ConsoleID, "Stack is empty")
		Else
			ConsoleWinWrite($ConsoleID, $txt)
		EndIf
	ElseIf _analizeCommand($command, "stackdel") OR _analizeCommand($command, "deletestack") Then
		_stackDel($extendCommandArray[2])
		ConsoleWinWrite($ConsoleID, "Element deleted")
	ElseIf _analizeCommand($command, "linktot") Then
		$html_array = _getLinkArray($oIE,2)
		ConsoleWinWrite($ConsoleID, _arrayToText($html_array))
		$link = 0
		
	ElseIf _analizeCommand($command, "linkurl")Then
		$html_array = _getLinkArray($oIE,1)
		ConsoleWinWrite($ConsoleID, _arrayToText($html_array))
		$link = 0
	ElseIf _analizeCommand($command, "link") Then
		
		if $extendCommandArray[0] >= 2 Then
			$linkname = $extendCommandArray[2]
			$link=2
		Else
			$link = 1
		EndIf
	
	ElseIf _analizeCommand($command, "back") Then
		_IEAction ($oIE, "back")
	
	ElseIf _analizeCommand($command, "consolesetdim") Then
		$pos = WinGetPos($consoleHandle)
		
;~ 		ConsoleWinWrite($ConsoleID, $extendCommandArray[0])
		ReDim $extendCommandArray[6]
		
		
;~ 			$tempDim = ConsoleWinInput($ConsoleID, "x: ")
;~ 			if $tempDim <> "" Then
;~ 				$extendCommandArray[2] = $tempDim
;~ 			Else
				$extendCommandArray[2] = $pos[0]
;~ 			EndIf
;~ 			
;~ 			$tempDim = ConsoleWinInput($ConsoleID, "y: ")
;~ 			if $tempDim <> "" Then
;~ 				$extendCommandArray[3] = $tempDim
;~ 			Else
				$extendCommandArray[3] = $pos[1]
;~ 			EndIf

		if $extendCommandArray[0] < 2 Then
			$tempDim = ConsoleWinInput($ConsoleID, "width: ")
			if $tempDim <> "" Then
				$extendCommandArray[4] = $tempDim
			Else
				$extendCommandArray[4] = $pos[2]
			EndIf
		Else
;~ 			$extendCommandArray[4] = $pos[2]
		EndIf

		if $extendCommandArray[0] < 3 Then
			$tempDim = ConsoleWinInput($ConsoleID, "height: ")
			if $tempDim <> "" Then
				$extendCommandArray[5] = $tempDim
			Else
				$extendCommandArray[5] = $pos[3]
			EndIf
		Else
;~ 			$extendCommandArray[5] = $pos[3]
		EndIf
		
		ConsoleWinWrite($ConsoleID, "x: " & $extendCommandArray[2] & ", y: " & $extendCommandArray[3] & ", width: " & $extendCommandArray[4] & ", height: " & $extendCommandArray[5])

		WinMove($consoleHandle, "", $extendCommandArray[2] , $extendCommandArray[3], $extendCommandArray[4], $extendCommandArray[5])
	
	ElseIf _analizeCommand($command, "consolesetpos") Then
		$pos = WinGetPos($consoleHandle)
		
;~ 		ConsoleWinWrite($ConsoleID, $extendCommandArray[0])
		ReDim $extendCommandArray[6]
		
		if $extendCommandArray[0] < 2 Then
			$tempDim = ConsoleWinInput($ConsoleID, "x: ")
			if $tempDim <> "" Then
				$extendCommandArray[2] = $tempDim
			Else
				$extendCommandArray[2] = $pos[0]
			EndIf
		Else
			$extendCommandArray[2] = $pos[0]
		EndIf

		if $extendCommandArray[0] < 3 Then
			$tempDim = ConsoleWinInput($ConsoleID, "y: ")
			if $tempDim <> "" Then
				$extendCommandArray[3] = $tempDim
			Else
				$extendCommandArray[3] = $pos[1]
			EndIf
		Else
			$extendCommandArray[3] = $pos[1]
		EndIf

;~ 		if $extendCommandArray[0] < 2 Then
;~ 			$tempDim = ConsoleWinInput($ConsoleID, "width: ")
;~ 			if $tempDim <> "" Then
;~ 				$extendCommandArray[2] = $tempDim
;~ 			Else
;~ 				$extendCommandArray[2] = $pos[2]
;~ 			EndIf
;~ 		Else
;~ 			$extendCommandArray[2] = $pos[2]
;~ 		EndIf

;~ 		if $extendCommandArray[0] < 3 Then
;~ 			$tempDim = ConsoleWinInput($ConsoleID, "height: ")
;~ 			if $tempDim <> "" Then
;~ 				$extendCommandArray[3] = $tempDim
;~ 			Else
;~ 				$extendCommandArray[3] = $pos[3]
;~ 			EndIf
;~ 		Else
;~ 			$extendCommandArray[3] = $pos[3]
;~ 		EndIf
		
	
		WinMove($consoleHandle, "", $extendCommandArray[2] , $extendCommandArray[3], $extendCommandArray[4], $extendCommandArray[5])
	
	ElseIf _analizeCommand($command, "url")  Then
		$link = StringMid($command, 5)
		if StringInStr($link, "%") > 0 Then ;AND Stack;IsInt(StringMid($link, StringInStr($link, "%")+1)) Then ;AND StringMid($link, StringInStr($link, "%")+1) Then
			$probVar = StringMid($link, StringInStr($link, "%")+1)
;~ 			ConsoleWinWrite($ConsoleID, "-" & $probVar)
			$probVar = _stackGet($probVar)
			
;~ 			if $probVar = 0 Then
				
;~ 			Else
;~ 				ConsoleWinWrite($ConsoleID, "approved")
				$link = $probVar
;~ 			EndIf
			
		EndIf
		
		ConsoleWinWrite($ConsoleID, $link)
		IniWrite($browseConsoleIni,"error","url",$link)
		_IENavigate($oIE, $link, $WAITLOAD)
;~ 		$link = 1
	ElseIf _analizeCommand($command, "google")  Then
		$link = StringMid($command, 8)
		ConsoleWinWrite($ConsoleID, $link)
		
;~ 		$oIE = _IENavigate($oIE, "http://www.google.com")
		$oForm = _IEFormGetObjByName ($oIE, "f")
		$oQuery = _IEFormElementGetObjByName ($oForm, "q")
		_IEFormElementSetValue ($oQuery, $link)
		_IEFormSubmit ($oForm)
		
		
;~ 		_IENavigate($oIE, $link)
;~ 		$link = 1
	
	ElseIf _analizeCommand($command, "read") Then
;~ 		ConsoleWinWrite($ConsoleID, ConvertAndWrite($sHTML))
;~ 	MsgBox(0,"",_delTag($sHTML))
		ConsoleWinWrite($ConsoleID, _optimizeread(_IEBodyReadText ($oIE)))

;~ 	$txt ="<1>asd<1>dsada<1>asdasdad<1wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww> das asdd a<1> sd ad ad<1> asd asd a<1> asda d <1> ads <1> asd <1>"
;~ 		ConsoleWinWrite($ConsoleID, _delTag($txt))
		
	ElseIf _analizeCommand($command, "cliphtml") Then
		$link = StringMid($command, 5)
		ClipPut($sHTML)
		ConsoleWinWrite($ConsoleID, "html clipped")
;~ 		_IENavigate($oIE, $link)	
	ElseIf _analizeCommand($command, "html") Then
;~ 		$link = StringMid($command, 5)
		
		for $x=1 to $html_array[0]
			StringReplace($sHTML, StringMid($html_array[$x],StringInStr($html_array[$x],"/",0,-1)), "##### [" & $x & "] #####")
		Next
		
;~ 		if StringLen($sHTML) > 20000 Then
;~ 			$part_count = Round(StringLen($sHTML)/20000)
;~ 			
;~ 			For $j=1 to $part_count
;~ 				ConsoleWinClear($ConsoleID)
;~ 				ConsoleWinWrite($ConsoleID, StringMid($sHTML,$j*20000,20000))
;~ 				if StringLen(ConsoleWinInput($ConsoleID, "...")) > 0 Then
;~ 					ExitLoop
;~ 				EndIf
;~ 			Next
;~ 			
;~ 			
;~ 		Else
			ConsoleWinWrite($ConsoleID, $sHTML)
;~ 		EndIf
;~ 		_IENavigate($oIE, $link)
;~ 	Elseif $command = "part" Then
;~ 		if $part <= $part_count Then
;~ 			$part += 1
			
;~ 		EndIf
	ElseIf _analizeCommand($command, "consolebacktra") Then
		GUICtrlSetBkColor($ConsoleID[0], $GUI_BKCOLOR_TRANSPARENT)
		GUICtrlSetBkColor($ConsoleID[1], $GUI_BKCOLOR_TRANSPARENT)
		
	ElseIf _analizeCommand($command, "consoletra") Then
		
		if $console_tra = 1 Then
			WinSetTrans($consoleHandle, "", 255)
			$console_tra = 0
		Else
			$console_tra = 1
				
					
			$command = StringStripWS($command, 7)
					
			
			if $extendCommandArray[0] > 1 Then
				$set_tra = $extendCommandArray[2]
			Else
				$set_tra = 150
			EndIf
			WinSetTrans($consoleHandle, "", $set_tra)
		EndIf
		
	ElseIf _analizeCommand($command, "showtra") Then
		$window_tra = 1
		HotKeySet("^{PGDN}","_scrollWinDown")
		HotKeySet("^{PGUP}","_scrollWinUP")
		
		$command = StringStripWS($command, 7)
				
		
		$poseConsole = WinGetPos($consoleHandle)
;~ 			WinMove($consoleHandle, "", $poseConsole[0], $poseConsole[1]+200, $poseConsole[2], $poseConsole[3])
;~ 		WinMove($consoleHandle, "", 1, @DesktopHeight/2, @DesktopWidth, @DesktopHeight/2-30)
;~ 			WinMove($winhandle, "", $poseConsole[0], $poseConsole[1]-$poseConsole[3], $poseConsole[2], $poseConsole[3])
;~ 		WinMove($winhandle, "", 1, 1, @DesktopWidth, @DesktopHeight/2)
		WinMove($winhandle, "", $poseConsole[0], $poseConsole[1], $poseConsole[2], $poseConsole[3])
		
		if $extendCommandArray[0] > 1 Then
			$set_tra = $extendCommandArray[2]
		Else
			$set_tra = 150
		EndIf
		WinSetTrans($consoleHandle, "", $set_tra)
		WinSetState($winhandle,"", @SW_SHOW)

;~ 		Sleep($time * 1000)
;~ 		WinSetState($winhandle,"", @SW_HIDE)
;~ 		WinMove($consoleHandle, "", $poseConsole[0], $poseConsole[1], $poseConsole[2], $poseConsole[3])
		
		
	ElseIf _analizeCommand($command, "show") Then
		$window_visible = 1
		HotKeySet("^{PGDN}","_scrollWinDown")
		HotKeySet("^{PGUP}","_scrollWinUP")
		
	
		$command = StringStripWS($command, 7)
		$time=0
		if StringLen($command) > 4 Then
			$comSplit = StringSplit($command, " ")
;~ 			MsgBox(0,$comSplit[0],$comSplit[1] & " - " & $comSplit[2])
			if $comSplit[0] = 2 Then
				$time= $comSplit[2]
			ElseIf $comSplit[0] = 3 Then
				$dimension= $comSplit[3]
			EndIf
			
			
		EndIf
		
			$poseConsole = WinGetPos($consoleHandle)
;~ 			WinMove($consoleHandle, "", $poseConsole[0], $poseConsole[1]+200, $poseConsole[2], $poseConsole[3])
			WinMove($consoleHandle, "", 1, @DesktopHeight/2, @DesktopWidth, @DesktopHeight/2-30)
;~ 			WinMove($winhandle, "", $poseConsole[0], $poseConsole[1]-$poseConsole[3], $poseConsole[2], $poseConsole[3])
			WinMove($winhandle, "", 1, 1, @DesktopWidth, @DesktopHeight/2)
			WinSetState($winhandle,"", @SW_SHOW)
		if $time = 0 Then
;~ 			WinSetState($winhandle,"", @SW_SHOW)
		Else
			Sleep($time * 1000)
			WinSetState($winhandle,"", @SW_HIDE)
			WinMove($consoleHandle, "", $poseConsole[0], $poseConsole[1], $poseConsole[2], $poseConsole[3])
		EndIf
		
	ElseIf _analizeCommand($command, "hide")  Then
		HotKeySet("^{PGDN}")
		HotKeySet("^{PGUP}")
		$window_visible = 0
		
		if $window_tra = 1 Then
			$window_tra = 0
			WinSetTrans($consoleHandle, "", 255)
		EndIf
		
		WinSetState($winhandle,"", @SW_HIDE)
		WinMove($consoleHandle, "", $poseConsole[0], $poseConsole[1], $poseConsole[2], $poseConsole[3])
	
	ElseIf _analizeCommand($command, "fullon") Then	
			$poseConsole = WinGetPos($consoleHandle)
			WinMove($consoleHandle, "", 1, 1, @DesktopWidth, @DesktopHeight)
;~ 			GUICtrlSetPos ( $ConsoleID[1], 0, 0, $fromini_w, @DesktopHeight - 30)
	
	ElseIf _analizeCommand($command, "textcliphide") Then	
			ConsoleWinChangeTextColor($ConsoleID, 0x0FFFFFF)
			$texthide = ConsoleWinInput($ConsoleID, ">")
			ConsoleWinChangeTextColor($ConsoleID, $ConsoleTextColor)
			ConsoleWinWrite($ConsoleID, $texthide)
			
			
	ElseIf _analizeCommand($command, "fulloff") Then	
			WinMove($consoleHandle, "", $poseConsole[0], $poseConsole[1], $poseConsole[2], $poseConsole[3])
			
	ElseIf _analizeCommand($command, "ontop") Then
		if $consoleOnTop = 1 Then
			WinSetOnTop($consoleHandle, "", 0)
			$consoleOnTop = 0
			ConsoleWinWrite($ConsoleID, "onTop disable...")
		Else
			WinSetOnTop($consoleHandle, "", 1)
			$consoleOnTop = 1
			ConsoleWinWrite($ConsoleID, "onTop enable...")
		EndIf
	
	ElseIf _analizeCommand($command, "frame") Then
		$oFrames = _IEFrameGetCollection ($oIE)
		$iNumFrames = @extended
		
		ConsoleWinWrite($ConsoleID, "There are " & $iNumFrames & " in this page")
		For $i = 0 to ($iNumFrames - 1)
			$oFrame = _IEFrameGetCollection ($oIE, $i)
;~ 			ConsoleWinWrite($ConsoleID, @TAB &  _IEPropertyGet ($oFrame, "locationurl"))
			ConsoleWinWrite($ConsoleID, @TAB &  $oFrame.location.href)
;~ 			MsgBox(0, "Frame Info", 
		Next
	ElseIf _analizeCommand($command, "form") Then
		
		
		Dim $arrayform[1][2]
		$arrayform[0][0] = 1
;~ 		$arrayformID = 1
		
		if $extendCommandArray[0] >= 2 Then
			$oFrame = _IEFrameGetCollection ($oIE, 1)
			
			$nframe = @extended
			ConsoleWinWrite($ConsoleID, "There are " & $nframe )
			
			$oForms = _IEFormGetCollection ($oFrame)
		Else
			$oForms = _IEFormGetCollection ($oIE)
		EndIf
		
		
		$iNumForms = @extended
		ConsoleWinWrite($ConsoleID, "Forms Info" & @CRLF & @TAB & "There are " & $iNumForms & " forms on this page")
		
		if $iNumForms > 0 Then
			For $i = 0 to $iNumForms - 1
				$oForm = _IEFormGetCollection ($oIE, $i)
				ConsoleWinWrite($ConsoleID,  "Form Info" & @CRLF & @TAB &  "Name:" & $oForm.name)		
				ConsoleWinWrite($ConsoleID,  @TAB & "Element list:")
				$oQuery = _IEFormElementGetCollection ($oForm, $i)
				$formElement =  @extended
				
				ConsoleWinWrite($ConsoleID,  @TAB & @TAB & "TYPE" & @TAB & @TAB & "NAME" & @TAB & @TAB & "VALUE" & @TAB & @TAB & "TITLE" )
				
				for $xc = 0 to $formElement-1
					$oQuery = _IEFormElementGetCollection ($oForm, $xc)
					
	;~ 				ReDim $arrayform[$arrayform[0][0]+1][2]
	;~ 				$arrayform[0][0] += 1
	;~ 				$arrayform[$arrayform[0][0]-1][0] = $oForm
	;~ 				$arrayform[$arrayform[0][0]-1][1] = $oQuery
			
					$AS_n = $arrayform[0][0] + 1
					ReDim $arrayform[$AS_n + 1][2]
					$arrayform[0][0] = $AS_n
					$arrayform[$AS_n][0] = $oForm
					$arrayform[$AS_n][1] = $oQuery

					ConsoleWinWrite($ConsoleID, $arrayform[0][0] & ")" & @TAB & @TAB &  _tabbizzatore($oQuery.type) & _tabbizzatore($oQuery.name)  & _tabbizzatore($oQuery.value)  & _tabbizzatore($oQuery.title) )
				Next
				
					
			Next
				
			$element = ConsoleWinInput($ConsoleID, "formElement> ")
					
					if $element = "exit" Then
						$command = "exitform"
					Else
						if $element = "" AND $elementGlobal <> "" Then
							$element= $elementGlobal
							$value = ""
						Else
							$value = ConsoleWinInput($ConsoleID, "formValue> ")
						EndIf
						
						if $value <> "" Then
							_IEFormElementSetValue($arrayform[$element][1], $value)
							$elementGlobal = $element
						Else
							_IEFormSubmit($arrayform[$element][0])
							ConsoleWinWrite($ConsoleID, "submit... ")
							$command = "exitform"
						EndIf

					EndIf
		EndIf
		
		$command =""
;~ 	ElseIf StringInStr($command, "setfe") > 0 Then
		
		
;~ 		$oForm = _IEFormGetCollection ($oIE, 0)
		
;~ 		_IEFormElementSetValue ($oQuery, "AutoIt IE.au3")
;~ 		_IEFormSubmit ($oForm)
	Elseif $command > 0 Then
;~ 		$link= StringSplit($html_array[$command],"""")
;~ 		ConsoleWinWrite($ConsoleID, $link[2])
		ConsoleWinWrite($ConsoleID, $html_array[$command])
;~ 		_IENavigate($oIE, $html_array[$command])

;~ 		for $i = 0 to $html_array[0]
;~ 			ConsoleWinWrite($ConsoleID, $i & "- " & $ARRAYLINK[$i][0] & " ****" & $ARRAYLINK[$i][1])
;~ 		Next
;~ 		ConsoleWinWrite($ConsoleID, "---" & $command)
		_IENavigate($oIE, $ARRAYLINK[$command][0], $WAITLOAD)
		IniWrite($browseConsoleIni,"error","url",$ARRAYLINK[$command][0])
	ElseIf $command = "" Then
		$ie_state = _IEPropertyGet($oIE, "readystate")
		if $ie_state = 4 Then
			ConsoleWinWrite($ConsoleID, "Page loaded")
		Elseif $ie_state = 3 Then
			ConsoleWinWrite($ConsoleID, "Page loading...")
		Elseif $ie_state = 4 Then
			ConsoleWinWrite($ConsoleID, "State unknown...")
		EndIf
		$CLEAR = 0
	Else
		ConsoleWinWrite($ConsoleID, "Unknown command")
	EndIf
WEnd
;~ MsgBox(0,"","")

ConsoleWinWrite($ConsoleID, $sHTML)
_getLinkArray($sHTML)


Exit

Func _minimize()
	GUISetState(@SW_HIDE)
	
	#NoTrayIcon

	Opt("TrayMenuMode",1)   ; Default tray menu items (Script Paused/Exit) will not be shown.

;~ 	if $gia = 0 Then
		$restore      = TrayCreateItem("Restore")
		$space = TrayCreateItem("")
		$exititem       = TrayCreateItem("Exit")
		$gia=1
;~ 	Else
		
;~ 	EndIf

	TraySetState()

	While 1
		$msg = TrayGetMsg()
		Select
			Case $msg = 0
				ContinueLoop
			Case $msg = $restore
				ExitLoop
			Case $msg = $exititem
				Exit
		EndSelect
	WEnd
	
	TrayItemDelete ($restore)
	TrayItemDelete ($space)
	TrayItemDelete ($exititem)
	Opt("TrayMenuMode",0)
	TraySetState (2)
	GUISetState(@SW_SHOW)
EndFunc


Func _scrollWinDown()
	WinActivate($winhandle)
	Send("{PGDN}")
	WinActivate($consoleHandle)
EndFunc

Func _scrollWinUP()
	WinActivate($winhandle)
	Send("{PGUP}")
	WinActivate($consoleHandle)
EndFunc

Func _gestionImage($localize, $w, $h)
	opt("GUIOnEventMode", 0)
	WinSetState($consoleHandle, "",@SW_HIDE)
	#Region ### START Koda GUI section ### Form=
	$gui_image = GUICreate("Image", $w+20, $h+20, 201, 261)
	$Pic1 = GUICtrlCreatePic($localize, 10, 10, $w, $h, BitOR($SS_NOTIFY,$WS_GROUP))
	$MenuItem1 = GUICtrlCreateMenu("File")
	$MenuItem2 = GUICtrlCreateMenuItem("Save image as...", $MenuItem1)
	$MenuItem3 = GUICtrlCreateMenuItem("Exit", $MenuItem1)
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $MenuItem2
				$savelocal = FileSaveDialog("Save image as...","","All file (*.*)","",StringMid($localize, StringInStr($localize, "/",0,-1)))
				FileMove($localize, $savelocal)
			Case $MenuItem3
				opt("GUIOnEventMode", 1)
				GUIDelete($gui_image)
				WinSetState($consoleHandle, "",@SW_SHOW)
				Return 0
			Case $GUI_EVENT_CLOSE
				opt("GUIOnEventMode", 1)
				GUIDelete($gui_image)
				WinSetState($consoleHandle, "",@SW_SHOW)
				Return 0

		EndSwitch
	WEnd

EndFunc

Func _stringlenunivoquity($str, $lengh)
	for $i = 1 to $lengh-StringLen($str)
		$str &=" "
	Next
	
	Return $str
EndFunc

Func _optimizereadx($str)
;~ 	Do
;~ 		
;~ 	Until
	$str = StringReplace($str, @CRLF, " ")
	
	$idlen= 1
	$idlenEnd= StringLen($str)
	$newstr=""
	$incrementer = 130
	Do
		$newstr &= @CRLF & StringMid($str, $idlen, $incrementer)
		$idlen += $incrementer
	Until $idlen >= $idlenEnd
	
	Return $newstr
EndFunc

Func _optimizeread($str)
;~ 	ClipPut($str)
;~ 	MsgBox(0,"","")
;~ 	$str " asas < 123456 > 2930239 <034394>"
	
		$incrementer = 130
		
;~ 	Do
		$iS = 1
		$iF = 1
		$strnew=$str
		$volte = 0
	;~ 	$ttt=""
		Do
			$posS = StringInStr($str, @CRLF,0,$iS)
			if $posS > 0 Then
				$iS+=1
				$posF = StringInStr($str, @CRLF,0,$iS)
				
				if $posF > 0 Then
					$rem = _StringMid($str, $posS, $posF)
					
	;~ 				MsgBox(0,StringLen($rem),$rem)
					if StringLen($rem) > $incrementer Then
						$volte +=1
;~ 						ConsoleWinWrite($ConsoleID, $rem)

						$remNew = StringLeft($rem, $incrementer) & @CRLF
						$posu= $incrementer
						Do
							$remNew &= @CRLF & StringMid($rem, $posu +1 , $incrementer)
							$posu += $incrementer
							
;~ 							MsgBox(0,"",$remNew)
						Until StringLen(StringMid($rem, $posu +1 , $incrementer)) = 0
						
						$strnew = StringReplace($strnew, $rem,$remNew)
					EndIf
					
	;~ 				$ttt&=@CRLF & "------------------" & $rem
	;~ 				MsgBox(0,"",$rem) 
	;~ 				$strold= $strnew
					
					
	;~ 				if $strnew = "" Then
	;~ 					$strnew = $strold
	;~ 					ExitLoop
	;~ 				EndIf
	;~ 				if StringLen($rem) > 300 Then
	;~ 					MsgBox(0,"",$rem)
	;~ 					$ttt&=@CRLF & "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<" & @CRLF & @CRLF& @CRLF& @CRLF & $rem & @CRLF & ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" & @CRLF & @CRLF & @CRLF& @CRLF& @CRLF
	;~ 				EndIf
				EndIf
			EndIf
			
	;~ 		$iS+=1
	;~ 		$iF+=1
	;~ 		MsgBox(0,"",$strnew)

	;~ 						$ttt&=@CRLF & "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<" & @CRLF & @CRLF& @CRLF& @CRLF & $strnew & @CRLF & ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" & @CRLF & @CRLF & @CRLF& @CRLF& @CRLF
		Until StringInStr($str, @CRLF,0,$iS) = 0
		ConsoleWinWrite($ConsoleID, $volte)
		$str= $strnew
;~ 	Until $volte = 16
;~ 	ClipPut($ttt)
	Return $strnew
EndFunc

Func _analizeCommand($input, $command)
	$input = StringStripWS($input, 7)
	
;~ 	if $returnArray = 1 Then
		Global $extendCommandArray = StringSplit($input, " ")
		$extendCommandArray[1] = StringMid($input, StringInStr($input, " ")+1)
;~ 		Return $commandArray
;~ 	Else
		if StringLower(StringMid($input, 1, StringInStr($input, " ")-1)) = StringLower($command) Then
			Return 1
		Else
			Return 0
		EndIf
;~ 	EndIf
EndFunc


Func _stackAdd($url)
	_ArrayAdd($stack, $url)
	$stack[0] += 1
EndFunc

Func _stackGet($element)
;~ 	MsgBox(0,"",$element)
;~ 	ConsoleWinWrite($ConsoleID, $element & "-" & $stack[0])
	if $element <= $stack[0] Then
;~ 		ConsoleWinWrite($ConsoleID, "ssss")
		Return $stack[$element]
	Else
;~ 		ConsoleWinWrite($ConsoleID, "aaaa")
		SetError(1)
		Return 0
	EndIf
EndFunc

Func _stackDel($element)
	_ArrayDelete($stack, $element)
	$stack[0] -= 1
EndFunc

Func _stackShow()
	$txt = ""
	for $i = 1 to $stack[0]
		$txt &= @CRLF & $i &") " & $stack[$i]
	Next
	
	Return $txt
EndFunc

Func _stackSaveFile()
	for $i= 1 to $stack[0]
		IniWrite($browseConsoleIni, "stack", $i, $stack[$i])
	Next
EndFunc

Func _stackOpenFile()
	$stackTemp = IniReadSection($browseConsoleIni, "stack")
	
	ReDim $stack[$stackTemp[0][0]+1]
	$stack[0] = $stackTemp[0][0]
	
	for $i=1 to $stackTemp[0][0]
		$stack[$i] = $stackTemp[$i][1]
	Next
EndFunc

Func _tabbizzatore($str, $pers = 0)
;~ 	MsgBox(0,"",$str)
	if $pers = 0 Then
		if StringLen($str) <= 6 Then
			Return $str & @TAB & @TAB
		Else
			Return $str & @TAB
		EndIf
	Else
		if StringLen($str) <= $pers Then
			Return $str & @TAB & @TAB & @TAB
		Else
			Return $str & @TAB & @TAB
		EndIf
	EndIf
EndFunc

;~ Demo()


Func _loadSetting()
	Global $fromini_x = IniRead($browseConsoleIni, "setting","x","")
	Global 	$fromini_y = IniRead($browseConsoleIni, "setting","y","")
	Global $fromini_w = IniRead($browseConsoleIni, "setting","w","")
	Global $fromini_h = IniRead($browseConsoleIni, "setting","h","")
	Global $fromini_sl = IniRead($browseConsoleIni, "setting","sl","")
	Global $fromini_ss = IniRead($browseConsoleIni, "setting","ss","")
	Global $fromini_startPage = IniRead($browseConsoleIni, "setting","startpage","")
EndFunc

Func _GUI_setting()
	
	WinSetState($consoleHandle, "",@SW_HIDE)
;~ 	GUIDelete($ConsoleID[0])
	opt("GUIOnEventMode", 0)
	#Region ### START Koda GUI section ### Form=c:\documents and settings\0742351\documenti\autoit\guisettingbrowseconsole.kxf
	$GUIsettingForm = GUICreate("BrowseConsole setting", 273, 336, 253, 303)
	$setting_startpage = GUICtrlCreateInput("", 24, 40, 217, 21)
		GUICtrlSetData(-1 , $fromini_startPage)
	$Label1 = GUICtrlCreateLabel("Startpage", 24, 16, 59, 17)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
;~ 	$Label2 = GUICtrlCreateLabel("(type blank for no start page)", 96, 16, 139, 17)
	$setting_autoloadstack = GUICtrlCreateCheckbox("Auto load stack on start", 24, 80, 145, 17)
		if $fromini_sl = 1 Then
			GUICtrlSetState($setting_autoloadstack, $GUI_CHECKED)
		EndIf
	$setting_autosavestack = GUICtrlCreateCheckbox("Auto save stack on exit", 24, 104, 145, 17)
		if $fromini_ss = 1 Then
			GUICtrlSetState($setting_autosavestack, $GUI_CHECKED)
		EndIf
	$Group1 = GUICtrlCreateGroup("Default console size", 64, 136, 145, 129)

	$Label3 = GUICtrlCreateLabel("X:", 72, 160, 14, 17)
	$Label4 = GUICtrlCreateLabel("Y:", 72, 184, 14, 17)
	$Label5 = GUICtrlCreateLabel("Width:", 72, 208, 35, 17)
	$Label6 = GUICtrlCreateLabel("Height:", 72, 232, 38, 17)
	$setting_console_x = GUICtrlCreateInput("", 112, 160, 73, 21)
		GUICtrlSetData(-1 , $fromini_x)
	$setting_console_y = GUICtrlCreateInput("", 112, 184, 73, 21)
		GUICtrlSetData(-1 , $fromini_y)
	$setting_console_w = GUICtrlCreateInput("", 112, 208, 73, 21)
		GUICtrlSetData(-1 , $fromini_w)
	$setting_console_h = GUICtrlCreateInput("", 112, 232, 73, 21)
		GUICtrlSetData(-1 , $fromini_h)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$Setting_save = GUICtrlCreateButton("Save", 96, 280, 75, 25, 0)
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###

	While 1
		
		
		$nMsg = GUIGetMsg()
		
;~ 		if $nMsg <> 0 Then
;~ 			TrayTip($nMsg,@SEC,1)
;~ 		EndIf
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
;~ 				MsgBox(0,"","")
				GUIDelete($GUIsettingForm)
				WinSetState($consoleHandle, "",@SW_SHOW)
				opt("GUIOnEventMode", 1)
				Return 0
;~ 			Case $setting_autoloadstack
;~ 				MsgBox(0,"",GUICtrlRead($setting_autoloadstack))
;~ 			Case $setting_startpage

;~ 			
;~ 			Case $setting_autoloadstack

;~ 			
;~ 			Case $setting_autosavestack


;~ 			Case $setting_console_x

;~ 			
;~ 			Case $setting_console_y

;~ 			
;~ 			Case $setting_console_w

;~ 			
;~ 			Case $setting_console_h

			
			Case $Setting_save
;~ 				MsgBox(0,"",GUICtrlRead($GUIsettingForm, $setting_console_x))
				IniWrite($browseConsoleIni, "setting","x",GUICtrlRead($setting_console_x))
				IniWrite($browseConsoleIni, "setting","y",GUICtrlRead($setting_console_y))
				IniWrite($browseConsoleIni, "setting","w",GUICtrlRead($setting_console_w))
				IniWrite($browseConsoleIni, "setting","h",GUICtrlRead($setting_console_h))
				IniWrite($browseConsoleIni, "setting","sl",GUICtrlRead($setting_autoloadstack))
				IniWrite($browseConsoleIni, "setting","ss",GUICtrlRead($setting_autosavestack))
				IniWrite($browseConsoleIni, "setting","startpage",GUICtrlRead($setting_startPage))
				
				_loadSetting()
				
				GUIDelete($GUIsettingForm)
				WinSetState($consoleHandle, "",@SW_SHOW)
				opt("GUIOnEventMode", 1)
				Return 1
				
		EndSwitch
	WEnd

EndFunc

func ConvertAndWrite($Content)
local $OldFile, $NewFile, $Line
;~   $OldFile = FileOpen ($FileName, 0)
;~   $NewFile = FileOpen ($FileName & ".txt", 1)
;~   $Content = FileRead($OldFile)
  $Content = StringStripCr($Content)
  If not @error Then
  ; Strip Head
   $Content = StringRegExpReplace($Content, '<head>(.|\n)+?</head>','')
   $Content = StringRegExpReplace($Content, '<script>(.|\n)+?</script>','')
   $Content = StringRegExpReplace($Content, '<(.|\n)+?>','')

     ; Replace HTML abbrev.
   $Content = StringReplace($Content, '&lt;','<')
   $Content = StringReplace($Content, '&gt;','>')
   $Content = StringReplace($Content, '&nbsp;',' ')
   $Content = StringReplace($Content, '&copy;','©')
   $Content = StringReplace($Content, '&quot','"')

   ; Replace Tab to space
   $Content = StringReplace($Content, '\r',' ')
  ; Strip double spaces
   while StringInStr($Content,'  ')
     $Content = StringReplace($Content, '  ',' ')
   wend

   ; Replace space + @Lf lines
   $Content = StringReplace($Content, ' ' & @Lf,@Lf)

  ; Strip empty lines
   while StringInStr($Content,@Lf & @Lf)
     $Content = StringReplace($Content, @Lf & @Lf, @Lf)
   wend


  ; Now you can write text
;~    FileWrite($NewFile, $Content)
  endif
;~   FileClose($OldFile)
;~   FileClose($NewFile)

	Return $Content
endfunc

;------------------------------------------------------------------------------------------------------
;-                                      P A R S I N G   F U N C T I O N 
;------------------------------------------------------------------------------------------------------

Func _acapahtml($html)
	
EndFunc

Func _arrayToText($array)
	$txt =""
	for $i = 1 to $array[0]
		$txt &= @CRLF & $i & ":" & $array[$i]
	Next
	
	Return $txt
EndFunc


Func _delTag($str)
	ClipPut($str)
	MsgBox(0,"","")
;~ 	$str " asas < 123456 > 2930239 <034394>"
	
	$iS = 1
	$iF = 1
	$strnew=$str
	$ttt=""
	Do
		$posS = StringInStr($str, "<",0,$iS)
		if $posS > 0 Then
			$posF = StringInStr($str, ">",0,$iF)
			
			if $posF > 0 Then
				$rem = _StringMid($str, $posS, $posF)
;~ 				$ttt&=@CRLF & "------------------" & $rem
;~ 				MsgBox(0,"",$rem) 
				$strold= $strnew
				$strnew = StringReplace($strnew, $rem,"")
				
				if $strnew = "" Then
					$strnew = $strold
					ExitLoop
				EndIf
				if StringLen($rem) > 300 Then
;~ 					MsgBox(0,"",$rem)
;~ 					$ttt&=@CRLF & "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<" & @CRLF & @CRLF& @CRLF& @CRLF & $rem & @CRLF & ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" & @CRLF & @CRLF & @CRLF& @CRLF& @CRLF
				EndIf
			EndIf
		EndIf
		
		$iS+=1
		$iF+=1
;~ 		MsgBox(0,"",$strnew)

						$ttt&=@CRLF & "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<" & @CRLF & @CRLF& @CRLF& @CRLF & $strnew & @CRLF & ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" & @CRLF & @CRLF & @CRLF& @CRLF& @CRLF
	Until StringInStr($str, "<",0,$iS) = 0
	ClipPut($ttt)
	Return $strnew
EndFunc	


Func _getLinkArray($oIE, $urll= 0, $filtro="")
;~ 	ConsoleWinWrite($ConsoleID, "=" & $filtro)
	if _IEPropertyGet($oIE, "readystate") = 4 Then
			
		$oLinks = _IELinkGetCollection ($oIE)
		$iNumLinks = @extended
		Global $ARRAYLINK[@extended+2][2]
		$ARRAYLINK[0][0] = @extended
	;~ 	MsgBox(0, "Link Info", $iNumLinks & " links found")
		$txt = ""
		$txtxx = ""
		$id = 2
		For $oLink In $oLinks
	;~ 		MsgBox(0, "Link Info", $oLink.href)
			

			if $filtro="" Then
				$ARRAYLINK[$id][0]= $oLink.href
				$ARRAYLINK[$id][1]= _IEPropertyGet($oLink, "innerText")
			
				if $urll = 1 Then
					$txt &= "|" & $oLink.href
				ElseIf $urll = 2 Then
					$txt &= "|" & _tabbizzatore(_IEPropertyGet($oLink, "innerText"),5) & $oLink.href
		;~ 			$txt &= "|" & _IEPropertyGet($oLink, "innerText") & @TAB & @TAB & @TAB & $oLink.href
				Else
					$txt &= "|" & _IEPropertyGet($oLink, "innerText")
					
				EndIf
				$id += 1
			ElseIf StringInStr(_IEPropertyGet($oLink, "innerText"), $filtro) > 0 Then
				$ARRAYLINK[$id][0]= $oLink.href
				$ARRAYLINK[$id][1]= _IEPropertyGet($oLink, "innerText")
				
				$txt &= "|" & _IEPropertyGet($oLink, "innerText")
				$txtxx &= @CRLF & _IEPropertyGet($oLink, "innerText") & " = " & $oLink.href
				$txtxx &= @CRLF & "--------" & $ARRAYLINK[$id][0] & " = " & $ARRAYLINK[$id][1]
				$id += 1
			EndIf
			
			
		Next
		$txt = $iNumLinks & $txt
;~ 		for $i = 0 to $ARRAYLINK[0][0]
;~ 			ConsoleWinWrite($ConsoleID, $i & "- " & $ARRAYLINK[$i][0] & " ****" & $ARRAYLINK[$i][1])
;~ 		Next
;~ 		MsgBox(0,"",$txtxx)
		Return StringSplit($txt, "|")
	EndIf
#cs
;~ 	<a href=""></a>
	$html_array = StringSplit($html, "href",1)
	For $i = 1 to $html_array[0]
;~ 		MsgBox(0,"$i=" & $i, "$html_array[0]=" & $html_array[0])
		if $i = $html_array[0]+1 Then ExitLoop
			
		if StringInStr($html_array[$i], "=") = 0 OR StringInStr($html_array[$i], "</a>") = 0 OR StringInStr($html_array[$i], "onclick") = 0 Then
			_ArrayDelete ($html_array, $i)
			$html_array[0] = $html_array[0] - 1
			$i-=1
			
		Else
;~ 			$html_array[$i]= StringMid($html_array[$i], 1, StringInStr($html_array[$i],"</a>"))
;~ 			$html_array[$i]= $html_array[$i] & @CRLF & "********************" & @CRLF & _getNameLink($html_array[$i]) & " : " & _getLink($html_array[$i])
			$html_array[$i]= _getNameLink($html_array[$i]) & ":" & _getLink($html_array[$i])
		EndIf
	Next
	
;~ 	_ArrayDisplay ( $html_array,"")

	Return $html_array
;~ 	MsgBox(0,"","")
;~ 	MsgBox(0,"","")
#ce
EndFunc

Func _getLink($path)
	Return _StringMid($path, StringInStr($path, """"), StringInStr($path, """",0,2))
EndFunc

Func _getNameLink($path)
	Return _StringMid($path, StringInStr($path, ">")+1, StringInStr($path, "</a>")-1)
EndFunc

Func _StringMid($string, $start, $end)
	Return StringMid($string, $start, $end - $start+1)
EndFunc

Func OnAutoItExit ( )
	IniWrite($browseConsoleIni,"error","exitfail",0)
	_stackSaveFile()
EndFunc




;------------------------------------------------------------------------------------------------------
;-                                      C O N S O L E   L I B R A R Y  
;------------------------------------------------------------------------------------------------------

;===============================================================================
; Description:      Create a Window console to display status text information with history
; Parameter(s):     $x                - x position of the window
;                    $y                - y position of the window
;                    $width            - Optional - Window width
;                    $height            - Optional - Window height
;                    $Title            - Optional - Console Window title
;                    $text            - Optional - Initial text to display.
;                    $CreateProgress    - Optional - Create Progress (True/False)
;                    $BgColor        - Optional - background color
;                    $FgColor        - Optional - Foreground color
;                    $Transparency    - Optional - Transparency (0=Invisible, 255=Visible)
; Requirement(s):   None
; Return Value(s):  The Console ID
; Author(s):        Jerome DERN  (jdern "at" free "dot" fr)
; Note(s):            None
;===============================================================================


;~ #include <GUIConstants.au3>

;~ GUICreate("My GUI edit")
;~ $myedit=GUICtrlCreateEdit ("First line"& @CRLF, 176,32,121,97)
;~ GUICtrlSetLimit($myedit, 120000); 120000 characters

;~ GUISetState ()

While 1
    $msg = GUIGetMsg()  
    If $msg = $GUI_EVENT_CLOSE Then ExitLoop
	Wend
	
	
	
Func ConsoleWinCreate($x, $y, $width=638, $height=126, $Title="Console", $Text="", $CreateProgress=False, $BgColor=0xFFFFFF, $FgColor=0xFF0000, $Transparency=255)
    Dim $Console[3]
;~     $Console[0] = GuiCreate($Title, $width, $height, $x, $y, BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS), $WS_EX_TOOLWINDOW)
    $Console[0] = GuiCreate($Title, $width, $height, $x, $y, BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))
	Global $consoleHandle = WinGetHandle(WinGetTitle($Title))
    GUISetOnEvent($GUI_EVENT_CLOSE, "ConsoleWinExitEvent")
    If $CreateProgress Then $height -= 20
    $Console[1] = GuiCtrlCreateEdit($Text & @CRLF, 0, 0, $width-1, $height-1, BitOR($ES_MULTILINE, $ES_READONLY, $ES_AUTOVSCROLL,$WS_HSCROLL,$WS_VSCROLL))
	
	
	GUICtrlSetLimit($Console[1], 1000000)
    GUICtrlSetBkColor($Console[1],    $BgColor)
    GUICtrlSetColor($Console[1],    $FgColor)
	Global $ConsoleTextColor=0xFF0000
    GUICtrlSetResizing($Console[1],    $GUI_DOCKBORDERS)
;~     GUICtrlSetFont($Console[1], 10, 400, 0, "Courrier New")
    GUICtrlSetFont($Console[1], 10, 400, 0, "Lucida Console")
    $Console[2] =0
    If $CreateProgress Then $Console[2] = GUICtrlCreateProgress(0, $height+5, $width-1, 12)
    WinSetTrans($Console[0], "", $Transparency)
    GuiSetState()
    Return $Console
EndFunc

Func ConsoleWinChangeTextColor($Console, $hexc)
    GUICtrlSetColor($Console[1],    $hexc)
EndFunc

Func ConsoleWinExitEvent()
    GUIDelete(@GUI_WinHandle)
EndFunc

;===============================================================================
; Description:      Write a message to the console
; Parameter(s):     $ConsoleID        - Console ID returned by ConsoleWinCreate
;                    $text            - Text to display.
;                    $Progress        - Optional - Progress value (0-100)
;                    $NoCRLF            - Optional - Don't add CRLF and the end of text
;                    $Replace        - Optional - Replace last line
; Requirement(s):   ConsoleWinCreate called first
; Return Value(s):  None
; Author(s):        Jerome DERN  (jdern "at" free "dot" fr)
; Note(s):            None
;===============================================================================
Func ConsoleWinWrite($ConsoleID, $Text, $Progress=-1, $NoCRLF=False, $Replace=False)
    If $Replace Then
        $string = GUICtrlRead($ConsoleID[1])
        $pos = StringInStr($string, @CRLF, 0, -1)
        If $pos > 0 Then $pos += 1
        $end = StringLen($string)
        _GUICtrlEditSetSel($ConsoleID[1], $pos, $end)
    Else
        $pos = StringLen(GUICtrlRead($ConsoleID[1]))
        _GUICtrlEditSetSel($ConsoleID[1], $pos, $pos)
    EndIf
    If $NoCRLF = False Then $Text = $Text & @CRLF
    GUICtrlSetData ($ConsoleID[1], $Text, 1)
    If $ConsoleID[2] >0 And $Progress>=0 Then GUICtrlSetData($ConsoleID[2], $Progress)
EndFunc

;===============================================================================
; Description:      Ask for the user to input something
; Parameter(s):     $ConsoleID        - Console ID returned by ConsoleWinCreate
;                    $text            - Text to display, the question.
;                    $Progress        - Optional - Progress value (0-100)
; Requirement(s):   ConsoleWinCreate called first
; Return Value(s):  What user have typed.
; Author(s):        Jerome DERN  (jdern "at" free "dot" fr)
; Note(s):            $text could be an empty string
;===============================================================================
Func ConsoleWinInput($ConsoleID, $Text, $Progress=-1)
    WinSetOnTop($ConsoleID[0], "", 1)
    WinActivate($ConsoleID[0])
    $string = GUICtrlRead($ConsoleID[1])
    $pos = StringLen($string)
    _GUICtrlEditSetSel($ConsoleID[1], $pos, $pos)
    GUICtrlSetData ($ConsoleID[1], $Text, 1)
    GUICtrlSetStyle($ConsoleID[1], BitOR($ES_MULTILINE, $ES_AUTOVSCROLL, $WS_HSCROLL, $WS_VSCROLL, $ES_WANTRETURN))
    If $Text <> "" Then
       ; Wait for the user to input something 
        While 1
            Sleep(100)
            $String=GUICtrlRead($ConsoleID[1])
            If StringRight($string, 2) = @CRLF Then ExitLoop
           ; Ensure that everything is typed at the end of edit control
            $pos = StringLen($String)
            _GUICtrlEditSetSel($ConsoleID[1], $pos, $pos)
        WEnd
        $pos = StringInStr($string, $Text, 0, -1)
        If $pos >0 Then $pos += StringLen($Text)
    Else
        $str = $string
       ; Wait for the user to input something
        While 1
            Sleep(100)
            $String=GUICtrlRead($ConsoleID[1])
            If StringRight($string, 2) = @CRLF And $string <> $str Then ExitLoop
           ; Ensure that everything is typed at the end of edit control
            $pos = StringLen($String)
            _GUICtrlEditSetSel($ConsoleID[1], $pos, $pos)
        WEnd
        $pos = StringInStr(StringLeft($string, StringLen($string)-2), @CRLF, 0, -1)
        If $pos > 0 Then $pos += 1
    EndIf
    $string = StringMid($string, $pos)
    $string = StringLeft($string, StringLen($string)-2)
    GUICtrlSetStyle($ConsoleID[1], BitOR($ES_MULTILINE, $ES_READONLY, $ES_AUTOVSCROLL,$WS_HSCROLL,$WS_VSCROLL))
    If $ConsoleID[2] >0 And $Progress>=0 Then GUICtrlSetData($ConsoleID[2], $Progress)
    Return $string
    WinSetOnTop($ConsoleID[0], "", 0)
EndFunc

;===============================================================================
; Description:      Clear the console
; Parameter(s):     $ConsoleID    - The console ID
; Requirement(s):   None
; Return Value(s):  None
; Author(s):        Jerome DERN  (jdern "at" free "dot" fr)
; Note(s):            None
;===============================================================================
Func ConsoleWinClear($ConsoleID)
    GUICtrlSetData ($ConsoleID[1], "")
    If $ConsoleID[2] >0 Then GUICtrlSetData($ConsoleID[2], 0)
EndFunc

;===============================================================================
; Description:      Save the content of the console to a file
; Parameter(s):     $ConsoleID    - The console ID
;                    $FileName    - The filename used to save
; Requirement(s):   None
; Return Value(s):  Write status, same as FileWrite
; Author(s):        Jerome DERN  (jdern "at" free "dot" fr)
; Note(s):            None
;===============================================================================
Func ConsoleWinSave($ConsoleID, $FileName)
    $string = GUICtrlRead($ConsoleID[1])
    Return FileWrite($FileName, $string)
EndFunc
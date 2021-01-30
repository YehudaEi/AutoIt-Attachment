#include <Constants.au3>
#include <IE.au3>
#include <GuiConstants.au3>
#include <Array.au3>
#Include <date.au3>
#include <file.au3>

$NotFoundLogFile = "NotFound.txt" ; use date functions here...
$notfoundlogfile = FileOpen($NotFoundLogFile, 1)

$FoundLogFile = "Found.txt" ; use date functions here...
$foundlogfile = FileOpen($FoundLogFile, 1)

; Check if file opened for writing OK
	If $notfoundlogfile = -1 Then
    		MsgBox(0, "Error", "Unable to open file: " & $NotFoundLogFile)
    		Exit
	EndIf
FileWrite($notfoundlogfile, "Starting NDS." & @CRLF)

; Check if file opened for writing OK
	If $foundlogfile = -1 Then
    		MsgBox(0, "Error", "Unable to open file: " & $FoundLogFile)
    		Exit
	EndIf
FileWrite($foundlogfile, "Starting NDS." & @CRLF)


; loop Games.txt file
; strip title out of line
; 
; File Format:
; 0002 - Need For Speed - Underground 2 (U)(Trashman)(C37AB273).zip
; 0003 - Yoshi Touch & Go (U)(Trashman)(03D56334).zip
; 0004 - Feel the Magic - XY-XX (U)(Trashman)(662D929F).zip
; $line = "0003 - Yoshi Touch & Go (U)(Trashman)(03D56334).zip"

; $days = StringSplit("Sun,Mon,Tue,Wed,Thu,Fri,Sat", ",")
; $days[1] contains "Sun" ... $days[7] contains "Sat"

; String Replace
; $text = StringReplace("this is a line of text", " ", "-")

; $result = StringTrimLeft("I am a string", 3)
; MsgBox(0, "String without leftmost 3 characters is:", $result)

$oIE = _IECreate("                       ")
_IELoadWait ($oIE)
	$file = FileOpen("AllGames.txt", 0)

	; Check if file opened for reading OK
	If $file = -1 Then
		MsgBox(0, "Error", "Unable to open file cms_batch.txt")
		Exit
	EndIf

	; Read in lines of text until the EOF is reached
	While 1
		$line = FileReadLine($file)
		If @error = -1 Then ExitLoop
		; MsgBox(0, "Line read:", $line)
		; ClipPut ($line)
		
		ConsoleWrite("FULL LINE IS " & $line & @CR)


$fullNameSplit = StringSplit($line, "(")
$FullGameName = StringStripWS($fullNameSplit[1], 2)

DirCreate($FullGameName)

$GameLogFile = $FullGameName & "\" & $FullGameName & ".txt" ; use date functions here...
$gamelogfile = FileOpen($GameLogFile, 9)

; Check if file opened for writing OK
	If $gamelogfile = -1 Then
    		MsgBox(0, "Error", "Unable to open file GameLogFile: " & $gamelogfile & "at path: " & $GameLogFile)
    		Exit
	EndIf
FileWrite($gamelogfile, "Info for " & $FullGameName & ":" & @CRLF)

$StripFront = StringTrimLeft($line, 7)

$Replace = StringReplace($StripFront, " - ", " ")

$Split = StringSplit($Replace, "(")

$GameName = $Split[1]
$GameName = StringTrimRight($GameName, 1)
; MsgBox(0, "String without leftmost 3 characters is:", $GameName)

;                                                                         
;                                              game+name      +%28DS%29
Global $GameURL = StringReplace($GameName, " ", "+")

$GameFound = 0
	; loop through file regex for file name to search
	_IENavigate($oIE, "                                       " & $GameURL & "+%28DS%29")
	_IELoadWait ($oIE)
	ConsoleWrite("Starting a new search looking for the games link" & @CR)
	$splitGame = StringSplit($GameName, ' ', 1)
	$firstWord = $splitGame[1]
	$lastWord = $splitGame[$splitGame[0]]
	ConsoleWrite ("Last Word: " & $lastWord & @CR)
	$sMyString = $GameName & " (DS)"
	$sMyLastString = $lastWord & " (DS)"
	; $sMyFirstThreeString = $firstWord & " " & $secondWord & " " & $thirdWord
	
	ConsoleWrite ("Last Word / STRING : " & $sMyLastString & @CR)
	
	$oDiv = _IEGetObjById ($oIE, "content")
	$oLinks = _IELinkGetCollection($oDiv)
	For $oLink in $oLinks
		$sLinkText = _IEPropertyGet($oLink, "innerText")
		If StringInStr($sLinkText, $sMyString) Then
			ConsoleWrite("There are OUT OF LOOP")
			
			ConsoleWrite(_IEPropertyGet($oDiv, "innertext") & @CR)
			$GameFound = 1
			GameFound()
			$MainPageURL = $oLink
			_IEAction($oLink, "click")
			_IELoadWait ($oIE)
			ExitLoop
		Else
			ConsoleWrite ($sLinkText & "NOT FOUND " & $sMyString & @CR)
		EndIf
		
		
		If StringInStr($sLinkText, "(DS)") Then
			ConsoleWrite("There are OUT OF LOOP")
			$oDiv = _IEGetObjById ($oIE, "results")
			ConsoleWrite(_IEPropertyGet($oDiv, "innertext") & @CR)
			$GameFound = 1
			GameFound()
			$MainPageURL = $oLink
			FileWrite($notfoundlogfile, "WARNING: No Direct Match for: " & $sMyString & @CRLF)
			FileWrite($notfoundlogfile, "WARNING: Manually Verify this is the correct link: " & $oLink & @CRLF)
			_IEAction($oLink, "click")
			_IELoadWait ($oIE)
			ExitLoop
		Else
			ConsoleWrite ($sLinkText & "NOT FOUND (DS)" & @CR)
		EndIf
	Next
	
	if $GameFound = 0 Then
			; TRY AGAIN
				_IENavigate($oIE, "                                       " & $GameURL & "+%28DS%29")
	_IELoadWait ($oIE)
	ConsoleWrite("Starting a new search looking for the games link" & @CR)
	$splitGame = StringSplit($GameName, ' ', 1)
	$firstWord = $splitGame[1]
	$lastWord = $splitGame[$splitGame[0]]
	ConsoleWrite ("Last Word: " & $lastWord & @CR)
	$sMyString = $GameName & " (DS)"
	$sMyLastString = $lastWord & " (DS)"
	; $sMyFirstThreeString = $firstWord & " " & $secondWord & " " & $thirdWord
	
	ConsoleWrite ("Last Word / STRING : " & $sMyLastString & @CR)
	
	$oDiv = _IEGetObjById ($oIE, "results")
	$oLinks = _IELinkGetCollection($oDiv)
	For $oLink in $oLinks
		$sLinkText = _IEPropertyGet($oLink, "innerText")
		If StringInStr($sLinkText, $sMyString) Then
			ConsoleWrite("There are OUT OF LOOP")
			
			ConsoleWrite(_IEPropertyGet($oDiv, "innertext") & @CR)
			$GameFound = 1
			GameFound()
			$MainPageURL = $oLink
			_IEAction($oLink, "click")
			_IELoadWait ($oIE)
			ExitLoop
		Else
			ConsoleWrite ($sLinkText & "NOT FOUND " & $sMyString & @CR)
		EndIf
		
		
		If StringInStr($sLinkText, "(DS)") Then
			ConsoleWrite("There are OUT OF LOOP")
			$oDiv = _IEGetObjById ($oIE, "results")
			ConsoleWrite(_IEPropertyGet($oDiv, "innertext") & @CR)
			$GameFound = 1
			GameFound()
			$MainPageURL = $oLink
			FileWrite($notfoundlogfile, "WARNING: No Direct Match for: " & $sMyString & @CRLF)
			FileWrite($notfoundlogfile, "WARNING: Manually Verify this is the correct link: " & $oLink & @CRLF)
			_IEAction($oLink, "click")
			_IELoadWait ($oIE)
			ExitLoop
		Else
			ConsoleWrite ($sLinkText & "NOT FOUND (DS)" & @CR)
		EndIf
	Next
	
	
				; TRY AGAIN
				_IENavigate($oIE, "                                       " & $GameURL & "+%28DS%29")
	_IELoadWait ($oIE)
	ConsoleWrite("Starting a new search looking for the games link" & @CR)
	$splitGame = StringSplit($GameName, ' ', 1)
	$firstWord = $splitGame[1]
	$lastWord = $splitGame[$splitGame[0]]
	ConsoleWrite ("Last Word: " & $lastWord & @CR)
	$sMyString = $GameName & " (DS)"
	$sMyLastString = $lastWord & " (DS)"
	; $sMyFirstThreeString = $firstWord & " " & $secondWord & " " & $thirdWord
	
	ConsoleWrite ("Last Word / STRING : " & $sMyLastString & @CR)
	
	$oDiv = _IEGetObjById ($oIE, "results")
	$oLinks = _IELinkGetCollection($oIE)
	For $oLink in $oLinks
		$sLinkText = _IEPropertyGet($oLink, "innerText")
		If StringInStr($sLinkText, $sMyString) Then
			ConsoleWrite("There are OUT OF LOOP")
			
			ConsoleWrite(_IEPropertyGet($oDiv, "innertext") & @CR)
			$GameFound = 1
			GameFound()
			$MainPageURL = $oLink
			_IEAction($oLink, "click")
			_IELoadWait ($oIE)
			ExitLoop
		Else
			ConsoleWrite ($sLinkText & "NOT FOUND " & $sMyString & @CR)
		EndIf
		
		
		If StringInStr($sLinkText, "(DS)") Then
			ConsoleWrite("There are OUT OF LOOP")
			$oDiv = _IEGetObjById ($oIE, "results")
			ConsoleWrite(_IEPropertyGet($oDiv, "innertext") & @CR)
			$GameFound = 1
			GameFound()
			$MainPageURL = $oLink
			FileWrite($notfoundlogfile, "WARNING: No Direct Match for: " & $sMyString & @CRLF)
			FileWrite($notfoundlogfile, "WARNING: Manually Verify this is the correct link: " & $oLink & @CRLF)
			_IEAction($oLink, "click")
			_IELoadWait ($oIE)
			ExitLoop
		Else
			ConsoleWrite ($sLinkText & "NOT FOUND (DS)" & @CR)
		EndIf
	Next
EndIf
	
if $GameFound = 0 Then
	MsgBox(2,"WARNING", "Skipping GAME NOT FOUND: " & $GameName)
	FileWrite($notfoundlogfile, "No link found for Game: " & $GameName & @CRLF)
	FileWrite($notfoundlogfile, "No link found for URL : " & $GameURL & @CRLF)
EndIf

#cs
$sMyString = "boxshot"
$oLinks = _IELinkGetCollection($oIE)
For $oLink in $oLinks
    $sLinkText = _IEPropertyGet($oLink, "innerText")
	; ConsoleWrite("LINK FOUND: " & $oLink & @CR)
    If StringInStr($sLinkText, $sMyString) Then
        ; _IEAction($oLink, "click")
		ConsoleWrite("LINK MATCH CLICKING: " & $sLinkText & " - " & $sMyString & @CR)
        ExitLoop
	Else
		ConsoleWrite("LINK NO MATCH: " & $sLinkText & " - " & $sMyString & @CR)
    EndIf
Next
#ce

; src:                                                                   

if $GameFound = 1 Then
_IELoadWait ($oIE)
_IELoadWait ($oIE)

; now try to grab the background img banner and save url for game shots
$oDiv = _IEGetObjByID ($oIE, "summary_module")
	$GameReviewScoreRawRaw = _IEPropertyGet($oDiv, "innerhtml")
	$GameReviewScoreRaw = StringSplit($GameReviewScoreRawRaw, '<DIV class=banner style="BACKGROUND-IMAGE: url(', 1)
	if $GameReviewScoreRaw[0] >= 2 Then
			$GameReviewScore = StringSplit($GameReviewScoreRaw[2], ')', 1)
			InetGet($GameReviewScore[1], $FullGameName & "\" & $FullGameName & " Background.jpg", 1)
	EndIf
	
	$SummaryRawRaw =  StringSplit($GameReviewScoreRawRaw, 'summary">', 1)
	ConsoleWrite("SummaryRawRaw COUNT " & $SummaryRawRaw[0] & @CR)
	ConsoleWrite("SummaryRawRaw COUNT " & $SummaryRawRaw[1] & @CR)
	$SummaryRaw =  StringSplit($SummaryRawRaw[2], '</P>', 1)
	
	ConsoleWrite(@CR & @CR & @CR & @CR & @CR & @CR & "Game STAT SUMMARY: " & $SummaryRaw[1] & @CR)
	
	FileWrite($gamelogfile, "Summary: " & $SummaryRaw[1] & @CRLF)
	
	; Exit

; now on the actual game page... going to try to get the GameSpot Score
	$oDiv = _IEGetObjByID ($oIE, "score_summary")
	$GameReviewScoreRawRaw = _IEPropertyGet($oDiv, "innerhtml")
	$GameReviewScoreRaw = StringSplit($GameReviewScoreRawRaw, 'gs-score"><SPAN property="v:value">', 1)
	$GameReviewScore = StringSplit($GameReviewScoreRaw[2], '</SPAN>', 1)
	ConsoleWrite("Game Description 1 Array Count: " & $GameReviewScoreRaw[0] & @CR)
	ConsoleWrite("Game Description Array 1: " & $GameReviewScoreRaw[1] & @CR)
	ConsoleWrite("Game Description Array 2: " & $GameReviewScoreRaw[2] & @CR)
	ConsoleWrite("Game Description 2 Array Count: " & $GameReviewScore[0] & @CR)
	; ConsoleWrite(_IEPropertyGet($oDiv, "innertext") & @CR)
	; PULLS GAME TYPE!!! IE 2D Platformer
	
	ConsoleWrite(@CR & @CR & @CR & @CR & @CR & @CR & "Game Category: " & $GameReviewScore[2] & @CR)
	FileWrite($gamelogfile, "Rating Score: " & $GameReviewScore[1] & @CRLF)
	; Exit

; now on the actual game page... going to try to get the game type... & background pic
	$oDiv = _IEGetObjByID ($oIE, "gamestats")
	$GameReviewScoreRawRaw = _IEPropertyGet($oDiv, "innerhtml")
	$GameReviewScoreRaw = StringSplit($GameReviewScoreRawRaw, "<A title=", 1)
	$GameReviewScore = StringSplit($GameReviewScoreRaw[2], '"', 1)
	ConsoleWrite("Game Description 1 Array Count: " & $GameReviewScoreRaw[0] & @CR)
	ConsoleWrite("Game Description Array 1: " & $GameReviewScoreRaw[1] & @CR)
	ConsoleWrite("Game Description Array 2: " & $GameReviewScoreRaw[2] & @CR)
	ConsoleWrite("Game Description 2 Array Count: " & $GameReviewScore[0] & @CR)
	; ConsoleWrite(_IEPropertyGet($oDiv, "innertext") & @CR)
	; PULLS GAME TYPE!!! IE 2D Platformer
	
	ConsoleWrite(@CR & @CR & @CR & @CR & @CR & @CR & "Game Category: " & $GameReviewScore[2] & @CR)
	FileWrite($gamelogfile, "Category: " & $GameReviewScore[2] & @CRLF)
	
	
	$GameReviewScoreRaw = StringSplit($GameReviewScoreRawRaw, "class=data>", 1)
	$GameReviewScore = StringSplit($GameReviewScoreRaw[2], '</SPAN>', 1)
	ConsoleWrite("Game Description 1 Array Count: " & $GameReviewScoreRaw[0] & @CR)
	ConsoleWrite("Game Description Array 1: " & $GameReviewScoreRaw[1] & @CR)
	ConsoleWrite("Game Description Array 2: " & $GameReviewScoreRaw[2] & @CR)
	ConsoleWrite("Game Description 2 Array Count: " & $GameReviewScore[0] & @CR)
	; ConsoleWrite(_IEPropertyGet($oDiv, "innertext") & @CR)
	; PULLS GAME TYPE!!! IE 2D Platformer
	
	; <A href="/pages/company/index.php?company=44984">EA Games</A>
	$stripHTMLRaw = StringSplit($GameReviewScore[1], '>',1)
	$stripHTML = StringSplit($stripHTMLRaw[2],"<")
	
	$publisher = $stripHTML[1]
	ConsoleWrite("Game Publisher: " & $GameReviewScore[1] & @CR)
	FileWrite($gamelogfile, "Publisher: " & $publisher & @CRLF)
	
	; same logic for lower?
	$GameReviewScoreRaw = StringSplit($GameReviewScoreRawRaw, "<LI class=maturity><SPAN class=label>ESRB:</SPAN> <SPAN class=data>", 1)
	$GameReviewScore = StringSplit($GameReviewScoreRaw[2], '</SPAN>', 1)
	ConsoleWrite("Game Description 1 Array Count: " & $GameReviewScoreRaw[0] & @CR)
	ConsoleWrite("Game Description Array 1: " & $GameReviewScoreRaw[1] & @CR)
	ConsoleWrite("Game Description Array 2: " & $GameReviewScoreRaw[2] & @CR)
	ConsoleWrite("Game Description 2 Array Count: " & $GameReviewScore[0] & @CR)
	; ConsoleWrite(_IEPropertyGet($oDiv, "innertext") & @CR)
	; PULLS GAME TYPE!!! IE 2D Platformer
	ConsoleWrite("ESRB Rating: " & $GameReviewScore[1] & @CR)
	FileWrite($gamelogfile, "ESRB Rating: " & $GameReviewScore[1] & @CRLF)
	
	_IELoadWait ($oIE)
	_IELoadWait ($oIE)
	
	; now try to get the URL for See All Images....  
	_IELinkClickByText ($oIE, "See All Images")
	
	if @error > -1 Then
		; it couldn't find the link? >_<
		; MsgBox(0, "WARNING", "Couldn't find See All Images Link")
		ConsoleWrite("COULDN'T FIND SEE ALL IMAGES!!!" & @CR)
		$oDiv = _IEGetObjById ($oIE, "content")
		$oLinks = _IELinkGetCollection($oDiv)
		$sMyString = "images;img"
		For $oLink in $oLinks
			$sLinkText = _IEPropertyGet($oLink, "outerhtml")
			If StringInStr($sLinkText, $sMyString) Then
				ConsoleWrite("There are OUT OF LOOP")
			_IEAction($oLink, "click")
			_IELoadWait ($oIE)
			ExitLoop
		Else
			ConsoleWrite ($sLinkText & "NOT FOUND " & $sMyString & @CR)
		EndIf
			Next
	EndIf
	$oDiv = _IEGetObjByID ($oIE, "image_index")
	if @error > 0 Then
		$oDiv = _IEGetObjByID ($oIE, "current_img")
	EndIf
	$oLinks = _IELinkGetCollection($oDiv)
	$sMyString = "thumb"
For $oLink in $oLinks
    $sLinkText = _IEPropertyGet($oLink, "innerHtml")
	; ConsoleWrite("LINK FOUND: " & $oLink & @CR)
	
    If StringInStr($sLinkText, $sMyString) Then
		ConsoleWrite("LINK MATCH CLICKING: " & $sLinkText & " - " & $sMyString & @CR)
		_IEAction($oLink, "click")
		_IELoadWait ($oIE)
		
        ExitLoop
	Else
	
		ConsoleWrite("LINK FOUND: " & $sLinkText & @CR)
    EndIf
Next


; now going to try to attempt to see how many screenshots are on the page... look for Image xx of yy
$currImage = 1
$totalImages = 5

While $currImage <= $totalImages
	$oDiv = _IEGetObjByID ($oIE, "nav")
	$GameReviewScoreRawRaw = _IEPropertyGet($oDiv, "innerhtml")
	$GameReviewScoreRaw = StringSplit($GameReviewScoreRawRaw, "<SPAN id=current_count>", 1)
	$GameReviewScore = StringSplit($GameReviewScoreRaw[2], '</SPAN> of ', 1)
	$GameReviewScoreYY = StringSplit($GameReviewScore[2], '</LI>', 1)
	ConsoleWrite("Game Description 1 Array Count: " & $GameReviewScoreRaw[0] & @CR)
	ConsoleWrite("Game Description Array 1: " & $GameReviewScoreRaw[1] & @CR)
	ConsoleWrite("Game Description Array 2: " & $GameReviewScoreRaw[2] & @CR)
	ConsoleWrite("Game Description 2 Array Count: " & $GameReviewScore[0] & @CR)
	; ConsoleWrite(_IEPropertyGet($oDiv, "innertext") & @CR)
	; PULLS GAME TYPE!!! IE 2D Platformer
	ConsoleWrite(@CR & @CR & @CR & @CR & @CR & @CR & "Image XX of YY: " & $GameReviewScoreRawRaw & @CR)
	ConsoleWrite("Image XX: " & $GameReviewScore[1] & @CR)
		ConsoleWrite("Image YY: " & $GameReviewScoreYY[1] & @CR)
	
	; check here to make sure there is at least YY images for $totalImages to loop through;
	if $totalImages > $GameReviewScoreYY[1] Then
		$totalImages = $GameReviewScoreYY[1]
	EndIf
		$oImgs = _IEImgGetCollection ($oIE)
			$iNumImg = @extended
			ConsoleWrite("There are " & $iNumImg & " images on the page")
			For $oImg In $oImgs
			; ConsoleWrite("src: " & $oImg.src  & @CR)
					If StringInStr($oImg.src, "screen") Then
					; _IEAction($oLink, "click")
					ConsoleWrite("FOUND IT! src: " & $oImg.src  & @CR)
					InetGet($oImg.src, $FullGameName & "\" & $FullGameName & "Screen Shot " & $GameReviewScore[1] & ".jpg", 1)
					ExitLoop
				EndIf
			Next
	ConsoleWrite("OUT OF IMG LOOP" & @CR)
	$currImage = $currImage + 1		
	
	; now try to get click 'Next Image'
	_IELinkClickByText ($oIE, "next")
	_IELoadWait ($oIE)
WEnd			

; Now we are done with the Screen Shots... try to go back to the main page...
	$sMyString = $GameName & " (DS)"
	$oLinks = _IELinkGetCollection($oIE)
	For $oLink in $oLinks
		$sLinkText = _IEPropertyGet($oLink, "innerText")
		If StringInStr($sLinkText, $sMyString) Then
			ConsoleWrite("There are OUT OF LOOP")
			_IEAction($oLink, "click")
			_IELoadWait ($oIE)
			ExitLoop
		Else
			ConsoleWrite ($sLinkText & "NOT FOUND " & $sMyString & @CR)
		EndIf
		
		
		If StringInStr($sLinkText, "(DS)") Then
			ConsoleWrite("There are OUT OF LOOP")
			_IEAction($oLink, "click")
			_IELoadWait ($oIE)
			ExitLoop
		Else
			ConsoleWrite ($sLinkText & "NOT FOUND " & $sMyLastString & @CR)
		EndIf
	Next


	; try to click box shot link....
	$oDiv = _IEGetObjByID ($oIE, "gamestats")
	$GameReviewScoreRawRaw = _IEPropertyGet($oDiv, "innerhtml")
	$GameBoxShotRaw = StringSplit($GameReviewScoreRawRaw, "<DIV class=boxshot><A class=enlarge href=", 1)
	$GameBoxShot = StringSplit($GameBoxShotRaw[2], '"', 1)
	ConsoleWrite("Game Description 1 Array Count: " & $GameBoxShotRaw[0] & @CR)
	ConsoleWrite("Game Description Array 1: " & $GameBoxShotRaw[1] & @CR)
	ConsoleWrite("Game Description Array 2: " & $GameBoxShotRaw[2] & @CR)
	ConsoleWrite("Game Description 2 Array Count: " & $GameBoxShot[0] & @CR)
	; ConsoleWrite(_IEPropertyGet($oDiv, "innertext") & @CR)
	; PULLS BOX URL.... to be full needs to add                        
	ConsoleWrite(@CR & @CR & @CR & @CR & @CR & @CR & "Game BoxShot STAT SUMMARY: " & $GameBoxShot[2] & @CR)
	$LargeBoxShotURL = "                       " & $GameBoxShot[2]
	
	_IENavigate ($oIE, $LargeBoxShotURL)
	_IELoadWait ($oIE)
	
	; now try to find large box shot front....
	$oImgs = _IEImgGetCollection ($oIE)
			$iNumImg = @extended
			ConsoleWrite("There are " & $iNumImg & " images on the page")
			For $oImg In $oImgs
			; ConsoleWrite("src: " & $oImg.src  & @CR)
					If StringInStr($oImg.src, "bigboxshots") Then
					; _IEAction($oLink, "click")
					ConsoleWrite("FOUND IT! src: " & $oImg.src  & @CR)
					InetGet($oImg.src, $FullGameName & "\" & $FullGameName & " Large BoxShot Front.jpg", 1)
					ExitLoop
				EndIf
			Next
	ConsoleWrite("OUT OF IMG LOOP" & @CR)
	
		$oLinks = _IELinkGetCollection($oIE)
		$sMyString = "Back"
For $oLink in $oLinks
    $sLinkText = _IEPropertyGet($oLink, "innerText")
	ConsoleWrite("LINK FOUND: " & $oLink & @CR)
	
    If StringInStr($sLinkText, $sMyString) Then
        ; _IEAction($oLink, "click")
		ConsoleWrite("LINK MATCH CLICKING: " & $sLinkText & " - " & $sMyString & @CR)
		_IEAction($oLink, "click")
			_IELoadWait ($oIE)
        ExitLoop
	Else
	
		ConsoleWrite("LINK FOUND: " & $sLinkText & " - " & $sMyString & @CR)
    EndIf
Next


; now try to find large box shot BACK....
	$oImgs = _IEImgGetCollection ($oIE)
			$iNumImg = @extended
			ConsoleWrite("There are " & $iNumImg & " images on the page")
			For $oImg In $oImgs
			; ConsoleWrite("src: " & $oImg.src  & @CR)
					If StringInStr($oImg.src, "bigboxshots") Then
					; _IEAction($oLink, "click")
					ConsoleWrite("FOUND IT! src: " & $oImg.src  & @CR)
					InetGet($oImg.src, $FullGameName & "\" & $FullGameName & "Large BoxShot Back.jpg", 1)
					ExitLoop
				EndIf
			Next
	ConsoleWrite("OUT OF IMG LOOP" & @CR)
; _IEQuit ($oIE)
EndIf
WEnd
Func GameFound()
	FileWrite($foundlogfile, "Link found for URL :                                        " & $GameURL & "+%28DS%29" & @CRLF)
	$oImgs = _IEImgGetCollection ($oIE)
			$iNumImg = @extended
			ConsoleWrite("There are " & $iNumImg & " images on the page")
			For $oImg In $oImgs
			; ConsoleWrite("src: " & $oImg.src  & @CR)
					If StringInStr($oImg.src, "boxshots") Then
					; _IEAction($oLink, "click")
					ConsoleWrite("FOUND IT! src: " & $oImg.src  & @CR)
					InetGet($oImg.src, $FullGameName & "\" & $FullGameName & " Small BoxShot.jpg", 1)
					ExitLoop
				EndIf
			Next
			ConsoleWrite("OUT OF IMG LOOP" & @CR)
			
			
	$oDiv = _IEGetObjByID ($oIE, "results")
	$GameReviewScoreRawRaw = _IEPropertyGet($oDiv, "innertext")
	$GameReviewScoreRaw = StringSplit($GameReviewScoreRawRaw, "|", 1)
	$GameReviewScore = StringSplit($GameReviewScoreRaw[1], ":", 1)
	; ConsoleWrite("Game Description Array Count: " & $GameDescription[0] & @CR)
	; ConsoleWrite(_IEPropertyGet($oDiv, "innertext") & @CR)
	ConsoleWrite("Game Review Score: " & $GameReviewScore[3] & @CR)
	FileWrite($gamelogfile, "Review Score: " & $GameReviewScore[3] & @CRLF)
	
	; $oDiv = _IEGetObjByID ($oIE, "results")
	$GameDescriptionRaw = _IEPropertyGet($oDiv, "innerhtml")
	$GameDescription = StringSplit($GameDescriptionRaw, '<DIV class=deck>', 1)
	$GameDescription = StringSplit($GameDescription[2], '</DIV>', 1)
	; ConsoleWrite("Game Description Array Count: " & $GameDescription[0] & @CR)
	; ConsoleWrite("Game Description: " & $GameDescriptionRaw & @CR & @CR & @CR & @CR & @CR)
	ConsoleWrite("Game Description Array: " & $GameDescription[1] & @CR)
	FileWrite($gamelogfile, "Description: " & $GameDescription[1] & @CRLF)
	
	; _IELoadWait ($oIE)
	; _IELoadWait ($oIE)
EndFunc


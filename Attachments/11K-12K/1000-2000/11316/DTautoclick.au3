;===============================================================================
;
; Description:		: DarkThrone AutoRecruiter
; Parameter(s):		: Options: "bank" or "armory"
; Requirement:		: IE.au3 library and beta
; Author(s):		: Michael Guynn (greenmachine)
; Note(s):			: (c) Michael Guynn, February 2006
;
;===============================================================================

; Also deposits gold into the bank, and buys defensive weaponry and miners

; Offense weapons (best deals of all items):
; long sword base price: 300000 (+1500 offense) => 200 gold:off ratio  quantity[5]
; great sword base price: 350000 (+1800 off.) => 194.4444 gold:off ratio  quantity[6]

; Defense weapons (best deals of all items):
; long bow base price: 300000 (+1500 defense) => 200 gold:def ratio  quantity[19]
; great bow base price: 350000 (+1800 defense) => 194.4444 gold:def ratio  quantity[20]

; Each Citizen -> base guard = +6 def., costs 1500 gold => 250 gold:def ratio
; Each base guard -> trained guard = +54 def., costs 10000 gold => 185.185 gold:def ratio
; Each Citizen -> base guard -> trained guard = +60 def, costs 11500 => 191.6666 gold:def ratio

;                                                    
; "levels" for use with above calculations: all %s are added/subtracted from base price/number
; search source for <td class="box_content" align="center"> -> number % is immediately after

;                                             
; Find per-turn and daily income.
; your gold per turn is xxx,xxx,xxx.<br>
; Your daily income is xxx,xxx,xxx.<br>

;~ What are the race and subclass bonuses?
;~ Humans: +5% offense bonus, Great Sword (unique offense weapon)
;~ Elves: +5% intelligence bonus (spy offense/spy defense), Elite Archer (unique defense unit)
;~ Goblins: +5% defense bonus, Great Bow (unique defense weapon)
;~ Undead: casualty bonus (more information below), Berserker (unique offense unit)

;~ Fighter: +5% offense bonus
;~ Cleric: +5% defense bonus
;~ Thief: +5% intelligence bonus (spy defense and spy offense)
;~ Assassin: +5% income bonus

; pass decrypt _StringEncrypt (0, $AccountPassword, _StringReverse ($AccountEmail), 2)

HotKeySet ("{ESC}", "pauseme")
HotKeySet ("!s", "WriteSource")
HotKeySet ("!q", "quitme")
#include <string.au3>
#include <ie.au3>
Opt ("WinTitleMatchMode", 2)

Global $Cursor, $Pause = 0, $Option = "", $AccountUserNumber = 0
Global $DarkThroneRecruiterINI = "DarkThroneRecruiter.ini"

If Not FileExists ($DarkThroneRecruiterINI) Then
	$AccountEmail = InputBox ("Create INI 1 of 3", "Account Email Address")
	$AccountPassword = InputBox ("Create INI 2 of 3", "Account Password")
	$AccountMainClass = InputBox ("Create INI 3 of 3", "Main Class (race) - Human, Elf, Goblin, Undead")
	$AccountPassword = _StringEncrypt (1, $AccountPassword, _StringReverse ($AccountEmail), 2)
	FileWriteLine ($DarkThroneRecruiterINI, "[Account Info]")
	FileWriteLine ($DarkThroneRecruiterINI, "Email=" & $AccountEmail)
	FileWriteLine ($DarkThroneRecruiterINI, "Password=" & $AccountPassword)
	FileWriteLine ($DarkThroneRecruiterINI, "MainClass=" & StringUpper ($AccountMainClass))
	FileWriteLine ($DarkThroneRecruiterINI, "UserNumber=")
Else
	$AccountEmail = IniRead ($DarkThroneRecruiterINI, "Account Info", "Email", "")
	$AccountPassword = IniRead ($DarkThroneRecruiterINI, "Account Info", "Password", "")
	$AccountMainClass = IniRead ($DarkThroneRecruiterINI, "Account Info", "MainClass", "")
	$AccountUserNumber = IniRead ($DarkThroneRecruiterINI, "Account Info", "UserNumber", 0)
EndIf

If $AccountEmail = "" Then
	MsgBox (0, "Error", "No Email Specified.  Please Fix INI")
	Exit
ElseIf $AccountPassword = "" Then
	MsgBox (0, "Error", "No Password Specified.  Please Fix INI")
	Exit
ElseIf $AccountMainClass = "" Then
	MsgBox (0, "Error", "No Main Class Specified.  Please Fix INI")
	Exit
EndIf

$IEObject = _IECreate ()
;~ WinSetState ("Internet Explorer", "", @SW_MINIMIZE)
;~ TrayTip ("Dark Throne Recruiter Running", "The window flash you just saw is perfectly normal." & @CRLF & _ 
;~ "The Recruiter has to open and minimize a window." & @CRLF & "There is no need to be alarmed.", 1)
If $CmdLine[0] >= 1 Then
	$Option = $CmdLine[1]
EndIf

_IELoadWait ($IEObject, 50)
Sleep (500)
_IENavigate ($IEObject, "www.darkthrone.com/login.dt", 1)
Sleep (500)

;~ auto-login
$IEFormObj = _IEFormGetCollection ($IEObject, 1)
$decPass = _StringEncrypt (0, $AccountPassword, _StringReverse ($AccountEmail),2)

$email = _IEFormElementGetObjByName ($IEFormObj,"email")
$email.value = $AccountEmail
$pass = _IEFormElementGetObjByName ($IEFormObj,"password")
$pass.value = $decPass
_IEFormImageClick  ($IEObject, "submit.gif", "src")

_IELoadWait ($IEObject, 100)
Sleep (500)
;~ end auto-login

;~ ==========================================================================================
If $AccountUserNumber = 0 Then
	$AccountUserNumber = GetUserNumber()
	IniWrite ($DarkThroneRecruiterINI, "Account Info", "UserNumber", $AccountUserNumber)
EndIf

	_IENavigate ($IEObject, "                                                     ", 1)
	Sleep (500)
	_IEImgClick ($IEObject, "Start Recruiting", "alt")
	_IELoadWait ($IEObject, 50)
	Sleep (500)
	
	While 1
		If _IEFormGetCollection ($IEObject) > 0 Then
			_IEFormSubmit (_IEFormGetCollection ($IEObject, 0))
			_IELoadWait ($IEObject, 100)
			Sleep (500)
		Else
			$BodyHTML = _IEBodyReadHTML ($IEObject)
			If StringInStr ($BodyHTML, "You have already clicked the maximum number of members for today", 0) Then
				MsgBox(0,"done","Autoclicker finished!")
				ExitLoop
			Else
				If _IELinkClickByText ($IEObject, "here") = 0 Then
					_IEAction ($IEObject, "refresh")
				EndIf
			EndIf
		EndIf
	WEnd	
;~ ;




;~ $IEFormObj = _IEFormGetCollection ($IEObject, 1)
;~ $IEFormElementEmail = _IEFormGetCollection ($IEFormObj, 1)
;~ $IEFormElementPassword = _IEFormGetCollection ($IEFormObj, 2)
;~ _IEFormElementSetValue ($IEFormElementEmail, $AccountEmail)
;~ _IEFormElementSetValue ($IEFormElementPassword, _StringEncrypt (0, $AccountPassword, _StringReverse ($AccountEmail), 2))
;~ $SubmitButtonSource = "templates/notloggedin/images/buttons/submit.gif"

;~just checkin - wfp
;~ 	if _IEDocGetObj ($IEObject) = 0 Then
;~ 		MsgBox(0,"stat","Success")
;~ 	Else
;~ 		MsgBox(0,"stat","_IEDocGetObj ($IEObject) Failed")
;~ 	Endif
;~ ;	

;~ $oInputs = _IETagNameGetCollection (_IEDocGetObj ($IEObject), "input")
;~ For $oInput In $oInputs
;~ 	If $oInput.src <> "" And StringInStr ($oInput.src, $SubmitButtonSource, 0) Then
;~ 		$oInput.click
;~ 		ExitLoop
;~ 	EndIf
;~ Next
;~ _IELoadWait ($IEObject, 100)
;~ Sleep (500)
;~ If $AccountUserNumber = 0 Then
;~ 	$AccountUserNumber = GetUserNumber()
;~ 	IniWrite ($DarkThroneRecruiterINI, "Account Info", "UserNumber", $AccountUserNumber)
;~ EndIf
;~ If $Option = "" Then
;~ 	_IENavigate ($IEObject, "                                                     ", 1)
;~ 	Sleep (500)
;~ 	_IEClickImg ($IEObject, "Start Recruiting", "alt")
;~ 	_IELoadWait ($IEObject, 50)
;~ 	Sleep (500)
;~ 	While 1
;~ 		If _IEFormGetCollection ($IEObject) > 0 Then
;~ 			_IEFormSubmit (_IEFormGetCollection ($IEObject, 0))
;~ 			_IELoadWait ($IEObject, 100)
;~ 			Sleep (500)
;~ 		Else
;~ 			$BodyHTML = _IEBodyReadHTML ($IEObject)
;~ 			If StringInStr ($BodyHTML, "You have already clicked the maximum number of members for today", 0) Then
;~ 				ExitLoop
;~ 			Else
;~ 				If _IELinkClickByText ($IEObject, "here") = 0 Then
;~ 					_IEAction ($IEObject, "refresh")
;~ 				EndIf
;~ 			EndIf
;~ 		EndIf
;~ 	WEnd
;~ EndIf

;===========================================================================

;~ If $Option = "armory" Then
;~ 	_IENavigate ($IEObject, "                                        ", 1)
;~ 	_IELoadWait ($IEObject, 50)
;~ 	$GoldAmount = GetGold()
;~ 	$IEFormObjectArmory = _IEFormGetCollection ($IEObject, 1)
;~ 	If $AccountMainClass = "GOBLIN" Then
;~ 		$QuantityXXObj = _IEFormElementGetObjByName ($IEFormObjectArmory, "quantity[20]")
;~ 		_IEFormElementSetValue ($QuantityXXObj, Int ($GoldAmount/350000)) ; using base price for now
;~ 	Else
;~ 		$QuantityXXObj = _IEFormElementGetObjByName ($IEFormObjectArmory, "quantity[19]")
;~ 		_IEFormElementSetValue ($QuantityXXObj, Int ($GoldAmount/300000)) ; using base price for now
;~ 	EndIf
;~ 	_IEFormSubmit ($IEFormObjectArmory)
;~ 	_IELoadWait ($IEObject, 50)
;~ 	$GoldAmount = GetGold()
;~ 	If $GoldAmount >= 100000 Then
;~ 		_IENavigate ($IEObject, "                                              ", 1)
;~ 		_IELoadWait ($IEObject, 50)
;~ 		$IEFormObjectTraining = _IEFormGetCollection ($IEObject, 1)
;~ 		$QuantityMinersObj = _IEFormElementGetObjByName ($IEFormObjectTraining, "quantity[2]") ; miners at 2000 a pop
;~ 		If $GoldAmount >= 200000 Then
;~ 			_IEFormElementSetValue ($QuantityMinersObj, 100)
;~ 		Else
;~ 			_IEFormElementSetValue ($QuantityMinersObj, 50)
;~ 		EndIf
;~ 		_IEFormSubmit ($IEFormObjectTraining)
;~ 		_IELoadWait ($IEObject, 50)
;~ 	EndIf
;~ ElseIf $Option = "bank" Then
;~ 	_IENavigate ($IEObject, "                                                  ", 1)
;~ 	_IELoadWait ($IEObject, 50)
;~ 	$IEFormObjDeposit = _IEFormGetCollection ($IEObject, 1)
;~ 	If _IEFormElementGetValue (_IEFormElementGetObjByName ($IEFormObjDeposit, "deposit")) > 0 Then
;~ 		_IEFormSubmit ($IEFormObjDeposit)
;~ 		_IELoadWait ($IEObject, 50)
;~ 	EndIf
;~ EndIf
;~ _IENavigate ($IEObject, "                                                  " & $AccountUserNumber, 1)
;~ WinClose ("Internet Explorer")
Exit


Func GetGold()
	$GoldSplit = StringSplit (_IEBodyReadHTML ($IEObject), "Gold: ", 1)
	$GoldSplit = StringSplit ($GoldSplit[2], "<br>", 1)
	Return StringReplace ($GoldSplit[1], ",", "")
EndFunc

Func GetUserNumber()
	$UserNumberSplit = StringSplit (_IEBodyReadHTML ($IEObject), '<a href="/logout.dt?session=&amp;user=', 1)
	$UserNumberSplit = StringSplit ($UserNumberSplit[2], '">', 1)
	Return $UserNumberSplit[1]
EndFunc

Func WriteSource()
	FileWrite ("RecruiterSource" & @MIN & @SEC & ".txt", _IEBodyReadHTML ($IEObject))
EndFunc


While 1
	Sleep (1000)
WEnd

Func pauseme()
	If $Pause = 0 Then
		$Pause = 1
		While 1
			TrayTip ("Paused", "The Recruiter is Paused." & @CRLF & "Press ESC to unpause or Alt+q to quit.", 1)
			Sleep (5000)
			If $Pause = 0 Then
				TrayTip ("", "", 1)
				ExitLoop
			EndIf
		WEnd
	ElseIf $Pause = 1 Then
		TrayTip ("", "", 1)
		$Pause = 0
		Return
	EndIf
EndFunc

Func quitme()
	Exit
EndFunc
;~ added by rafnex
;~ func setSearchAndSetElementValueByName(ByRef $IEObj, $Tag, $elemName, $value, $instance = 1)
;~ 	$IEdoObj = _IEDocGetObj ($IEObj)
;~ 	$oInputs = _IETagNameGetCollection ($IEdoObj, $Tag,-1)
;~ 	$found = 0
;~ 	For $oInput In $oInputs
;~ 		If $oInput.name = $elemName Then
;~ 			$oInput.value = $value
;~ 			$found = $found + 1			
;~ 			if $instance = $found then
;~ 				$oInput.value = $value
;~ 				ExitLoop
;~ 			endif
;~ 		EndIf
;~ 	Next
;~ 	if $found = 0 then MsgBox(0,"error","element name : " & $elemName & " does not exist")
;~ EndFunc



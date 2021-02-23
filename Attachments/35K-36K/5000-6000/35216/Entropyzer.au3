;~ peneus 06-Sep-2011
;~
;~ Entropyzer.au3
;~
;~ Get a short simple string from the user, hash it with salt (using SHA1 algorithm),
;~ convert it into a higher entropy longer string, and put it into clipboard.
;~ This happens in two rounds. First round done with input & salt, second with
;~ input & salt & resulting string from the first round.

;~ See also e.g. "sha1 online" from Google.
;~ Why the name "Entropyzer"? Well, the script expands a simple string into
;~ a more complicated one with increased entropy.
;~
;~ The salt string is stored in a text file on any drive (root directory)
;~ with the fixed file name "salt.ent". The salt string must be on the first
;~ line of the file.

#include <Crypt.au3>
#include <WinAPI.au3>
#include <Constants.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

$Length = 14 ; The default length for the result is 14 chars.
$StringInput = ""
$PString = ""

#Region ### START Koda GUI section ###
$Form1_1 = GUICreate("Entropyzer", 334, 227, 210, 138)
$Input1 = GUICtrlCreateInput("", 32, 48, 201, 24, BitOR($GUI_SS_DEFAULT_INPUT,$ES_PASSWORD))
$Button1 = GUICtrlCreateButton("OK + Copy", 32, 165, 97, 41, $BS_DEFPUSHBUTTON)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$Button2 = GUICtrlCreateButton("Copy + Quit", 201, 165, 97, 41)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$Radio1 = GUICtrlCreateRadio("", 32, 112, 25, 25)
$Radio2 = GUICtrlCreateRadio("", 75, 112, 25, 25)
$Radio3 = GUICtrlCreateRadio("", 119, 112, 25, 25)
GUICtrlSetState(-1, $GUI_CHECKED) ; The default length for the result is 14 chars.
$Radio4 = GUICtrlCreateRadio("", 162, 112, 25, 25)
$Checkbox2 = GUICtrlCreateCheckbox("", 280, 52, 25, 25)
$Checkbox3 = GUICtrlCreateCheckbox("", 280, 100, 25, 25)
$Checkbox1 = GUICtrlCreateCheckbox("", 280, 128, 25, 25)
$Label1 = GUICtrlCreateLabel("String", 32, 24, 44, 20)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$Label2 = GUICtrlCreateLabel("8", 35, 136, 11, 20)
$Label3 = GUICtrlCreateLabel("10", 75, 136, 18, 20)
$Label4 = GUICtrlCreateLabel("14", 120, 136, 18, 20)
$Label5 = GUICtrlCreateLabel("20", 163, 136, 18, 20)
$Label6 = GUICtrlCreateLabel("Test mode", 209, 131, 69, 20)
$Label7 = GUICtrlCreateLabel("Length", 32, 93, 50, 20)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$Label8 = GUICtrlCreateLabel("Show", 240, 54, 37, 20)
$Label9 = GUICtrlCreateLabel("Alphanum", 214, 104, 64, 20)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

$Salt = GetSalt() ; If this fails (i.e. no proper file found), the show stops here.

;Retrieve the ASCII value of the default password char
$DefaultPassChar = GUICtrlSendMsg($Input1, $EM_GETPASSWORDCHAR, 0, 0)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Radio1
			$Length = 8
		Case $Radio2
			$Length = 10
		Case $Radio3
			$Length = 14
		Case $Radio4
			$Length = 20
        Case $Checkbox2 ; Toggle showing the typing ON or OFF
            If (GUICtrlRead($Checkbox2) = $GUI_CHECKED) Then
                GUICtrlSendMsg($Input1, $EM_SETPASSWORDCHAR, 0, 0)
            Else
                GUICtrlSendMsg($Input1, $EM_SETPASSWORDCHAR, $DefaultPassChar, 0)
            EndIf
            GUICtrlSetState($Input1, $GUI_FOCUS) ;Input needs focus to redraw characters
		Case $Button1 ; Copy the new string to the clipboard but don't exit
			Produce()
			If GUICtrlRead($Checkbox1) = $GUI_CHECKED Then
				MsgBox(0, "Information", "String with increased entropy is " & StringMid($PString,1,$Length))
			EndIf
		Case $Button2 ; Copy the new string to the clipboard and exit
			Produce()
			Exit
	EndSwitch
WEnd

Func Produce()
	; Produce a raw string for the resulting string by hashing the input and the salt concatenated.
	$StringInput = GUICtrlRead($Input1)
	If GUICtrlRead($Checkbox3) = $GUI_CHECKED Then
		$alphanum = 1
	Else
		$alphanum = 0
	EndIf
	$PString = GetPwd($StringInput, $alphanum, $Salt)
	ClipPut(StringMid($PString,1,$Length))
EndFunc

Func GetSalt()
	$filename = ""
	$saltfile = "\Salt.ent"
	$found = 0
	$salt = ""
	$var = DriveGetDrive( "all" )
	If NOT @error Then
		For $i = 1 to $var[0]
			If FileExists($var[$i] & $saltfile) Then
				If Not $found Then
					$found = 1
					$filename = FileOpen($var[$i] & $saltfile, 0)
					If $filename = -1 Then
						MsgBox(0, "Error", "Cannot open salt file.")
						Exit
					EndIf
					$salt = FileReadLine($filename)
					FileClose($filename)
				Else
					MsgBox(0,"Error", "Multiple salt files found.")
					Exit
				EndIf
			EndIf
		Next
		If Not $found Then
			MsgBox(0,"Error", "Salt file not found.")
			Exit
		EndIf
	EndIf
	If $salt = "" Then
		MsgBox(0,"Error", "Salt file is void.")
		Exit
	EndIf
	Return $salt
EndFunc

Func GetPwd($userinput, $alphanum, $Salt)
	; This is the allowed printable charset for the resulting string (85 characters times three).
	$chars = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%&/()=?+-,.;:*<>{}_"
	$chars = $chars & $chars & $chars & "A"; Fill in a string up to 256 characters long
	$rPString = "" ; Reset the resulting string

	For $j = 0 To 1 ; Build and concatenate two strings to make it long enough even for longer strings
		; First round with user input and salt, second round with the first round string in addition.
		$lPString = _Crypt_HashData($userinput & $Salt & $rPString,$CALG_SHA1)
		; Browse the raw string byte by byte and convert into characters.
		For $i = 3 To StringLen($lPString) Step 2
			$hex = StringMid($lPString, $i, 2)
			$int = Int("0x" & $hex)
			$char = StringMid($chars, $int, 1)
			If $alphanum = 0 Then
				$rPString = $rPString & $char
			ElseIf StringIsAlNum($char) Then
				$rPString = $rPString & $char
			EndIf
		Next
	Next
	Return $rPString
EndFunc
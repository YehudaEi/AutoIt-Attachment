;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Designer: Luke Mc Redmond
;; Date: 05/12/2005
;; Version: 1
;; Description: To Read The Headlines form the RTE Web Site
;; Acknowledgements: Dale "Internet Explorer Automation UDF library" and Unknown "speaks text to you"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#include <GUIConstants.au3>
#include <IE.au3>

$oIE = _IECreate()
_IENavigate($oIE, "                       ")

$body = _IEBodyReadHTML($oIE)

Dim $file = FileOpen("HtmlBody.txt",2)
FileWrite($file,$body)
FileClose($file)

Dim $file = FileOpen("HtmlBody.txt",0)
dim $file2 = FileOpen("htmlParsedTxt.txt",2)

local $line

;gets main body text removes all http tags <***************************>
While 1
	local $line = FileReadLine($file)
	If @error = -1 Then ExitLoop
	FileWriteLine($file2,StringRegExpReplace($line, "<(.|\n)+?>", @CRLF))
WEnd

FileClose($file2)
FileClose($file)


; NOW GOING TO OPEN THE PARSEDTXT FILE AND DELETE DOWN TO THE CONTACT US
DIM $file3 = FileOpen("ReadFile.txt",2)
$file2 = FileOpen("htmlParsedTxt.txt",0)

local $foundContact = 0

While 1
	local $line = FileReadLine($file2)
	If @error = -1 Then ExitLoop
	
	If (StringInStr($line,"Contact us ")) Then
		$foundContact = 1
	EndIf
	
	If (StringInStr($line,"Sports News")) Then
		$foundContact = 0
	EndIf	
	
	if ($foundContact == 1) Then
		if($line <> "") Then
			if(StringInStr($line,"&nbsp")) Then
				$line = StringReplace($line,"&nbsp"," ")
			EndIf
			FileWriteLine($file3,$line)
		EndIf
	EndIf
	
WEnd
FileClose($file2)
FileClose($file3)

$file3 = FileOpen("ReadFile.txt",0)
local $index = 0
While 1
	local $line = FileReadLine($file3)
	If @error = -1 Then ExitLoop
		
	if ($index > 3) Then
		_TalkOBJ($line, 3)
	EndIf
	$index = $index + 1
WEnd
FileClose($file3)

FileDelete("HtmlBody.txt");
FileDelete("htmlParsedTxt.txt")
FileDelete("ReadFile.txt")

_TalkOBJ("That was the Headlines for Today", 3)
_TalkOBJ("This Program was Brought to you by Luke Mc Redmond", 3)
_TalkOBJ("Hope You Enjoyed It Good Bye", 3)

Func _TalkOBJ($s_text, $s_voice = 3)
    Local $o_speech = ObjCreate ("SAPI.SpVoice")
        Select
            Case $s_voice == 3
                $o_speech.Voice = $o_speech.GetVoices("Name=Microsoft Sam", "Language=409").Item(0)
        EndSelect
    $o_speech.Speak ($s_text)
    $o_speech = ""
EndFunc ;==>_TalkOBJ

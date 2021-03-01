#include "Stereotype Scanner.au3"

#CS
	One things to take note about the way this script works is that if you are scanning a dev tool or script
	interpreter like autoit for example, it will likely be flagged as a hack tool, I do not have enough
	experiance to come up with a more accurate manner to flag files. This is simply building a low grade
	stereotype profile based on the imported functions a file has, but I have found that executable packers
	usually have one major thing in common, an attempt to hide imported functions while leaving behind two
	through 6 main API functions located in kernel32.dll which are typically used by the packer stub added
	to the compressed file, I'm not saying this is 100% or even 50% accurate, I don't know, but it has worked
	on a lot of different packed PE files even if they do not have the section header name signatures present.

	Just try it out and lets see what we get ;)
#CE

$File = FileOpenDialog("", "", "All(*.*)")
$Return = _GetProbability($File)
ConsoleWrite("    	1> Return ---- : " & $Return & @CR & _      ; String return value in human readable for telling to what it probably is
			 "    	2> @Error ---- : " & @error & @CR & _ 		; Error level duh
			 "    	3> @Extended - : " & @extended & @CR & @CR) ; You can probably consider this a probability value, although it's very flawed

;~ If you want to adapt the return value into scriptable format (I.E., instead of returning description strings), change it
;~ yourself in the UDF....

 ;Scan(@desktopdir)

Func Scan($Dir)
	Local $FILE
	Local $SEARCH = FileFindFirstFile($Dir & "\*.*")
	If $SEARCH = -1 Then Return
	While 1
		Sleep(0)
		$FILE = FileFindNextFile($SEARCH)
		If @error Then ExitLoop
		If @extended Then
			Scan($Dir & "\" & $FILE)
		Else
			ToolTip($Dir & "\" & $FILE)
			If StringInStr(StringRight($FILE, 4), "exe", 2) Then
				$Return = _GetProbability($Dir & "\" & $FILE)
				FileWriteLine(@ScriptDir & "\FileProfileAnalysis.text",$Return & " > "&$Dir & "\" & $FILE)
			EndIf
		EndIf
	WEnd
	;Return
EndFunc
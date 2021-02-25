#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.7.19 (beta)
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

;~ #include <IE.au3>
;~ #include <Array.au3>

;~ $oIE = _IECreate ("http://www.musicbaran.org/modules.php?name=News&file=article&sid=8077",0,0)	;create IE instance and load Webmail
;~ $text = _IEBodyReadHTML($oIE)
;~ _IEQuit($oIE)
;~ $array = StringRegExp($text,'a href="(http://.*\.mp3)"',3)
;~ _ArrayDisplay($array)


#include <Array.au3>
$text = ClipGet()
$array = StringRegExp($text,'a href="(http://.*\.mp3)"',3)
_ArrayDisplay($array)


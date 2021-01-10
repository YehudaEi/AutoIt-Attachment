#include <IE.au3>
#include <Youtube.au3>
#include <File.au3>
; using youtube.udf to get keyword 
$sID = ClipGet() 
_IELoadWait ($sID)
$sPlayer = _Youtube_Read($sID); Read webpage (could take a while)
$sKeywords = _Youtube_GetKeywords($sPlayer)
MsgBox(0, "keywords", $sKeywords)
_FileWriteToLine("c:\auto.txt", 1, $sKeywords, 0)
_IEQuit ($sID)


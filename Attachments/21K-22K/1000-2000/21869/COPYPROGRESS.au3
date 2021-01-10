#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.12.1
 Author:         Michael Østergaard Sørensen

 Script Function:
	Simple copyprogress bar, using xcopy.

#ce ----------------------------------------------------------------------------


;Include
#include <GuiConstants.au3>
#include <file.au3>


COPYPROGRESS("D:\Medier\DiVX","c:\Temp\DiVX")


Func COPYPROGRESS($x,$y)
	If FileExists($y) = 0 Then
		DirCreate($y)
	EndIf
		
	Run(@ComSpec & " /c " & 'xcopy "' & $x & '\*.*" "' & $y & '\*.*" /s/r/v/y',"")
		$source = DirGetSize($x,1)
		$dest = DirGetSize($y,1)
				
		Sleep(500)
		ProgressOn("","Copying",$dest[1] & " of " & $source[1] & " files copied")
		
		While  $dest[1] < $source[1]
			$dest = DirGetSize($y,1)
			Sleep(100)
			$progress = ($dest[1] / $source[1]) * 100
			ProgressSet($progress,$dest[1] & " of " & $source[1] & " files copied")
			Sleep(100)
		WEnd
		
		ProgressSet(100,"Done!")
		Sleep(500)
		ProgressOff()
EndFunc

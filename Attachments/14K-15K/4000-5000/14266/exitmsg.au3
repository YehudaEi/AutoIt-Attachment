#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.2.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here


func exitmsg($exitcode)
	$file = fileopen("exitmsg.txt", 0)
	if $file = -1 then 
		msgbox(0, "Error", "Cannot read file exitmsg.txt")
		return $exitcode
	EndIf
	
	while true 
		$line = FileReadLine($file)
		if @error = -1 Then return $exitcode
			
		$firstblank=StringInStr($line, " ")
		if stringleft($line, $firstblank) = $exitcode then return stringtrimleft($line, $firstblank)		
	WEnd
	
EndFunc

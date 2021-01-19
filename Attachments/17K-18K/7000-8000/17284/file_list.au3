#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.6.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
#include<File.au3>
$file=FileOpen(@ScriptDir&"\files.txt" , 2)
$search="C:"
all($search)

Func all($k)
	Dim $folders=_FileListToArray($k,"*.*",2)
	If Not @error Then 
		If $folders[0]<>0 Then 
			For $i=1 To $folders[0]
				all($k&"\"&$folders[$i])
			Next
		EndIf
	EndIf
	Dim $files=_FileListToArray($k,"*.*" ,1)
	If Not @error Then
		If $files[0]<>0 Then
			For $j=1 To $files[0]
				$dir=$k
				$print=$dir&"\"&$files[$j]
				fw($print)
				;FileWriteLine($file ,$print)
				ToolTip($print ,0 ,0)
			Next
		EndIf
	EndIf
EndFunc

Func fw($s_file)
	If FileExists($s_file) Then    
		$time=FileGetTime($s_file)
		$time1=FileGetTime($s_file,1)
		$time2=FileGetTime($s_file,2)
		$size=FileGetSize($s_file)
		FileWrite($file,@CRLF&"***************************************************************************"&@CRLF)
		FileWriteLine($file,"File: "& $s_file)
		FileWriteLine($file ,"File size:"&$size&" bytes")
		FileWriteLine($file,"Created:"&$time1[2]&"/"&$time1[1]&"/"&$time1[0]&" - "& $time1[3]&":"&$time1[4]&":"&$time1[5])
		FileWriteLine($file, "Last Modified:"&$time[2]&"/"&$time[1]&"/"&$time[0]&" - "& $time[3]&":"&$time[4]&":"&$time[5])
		FileWriteLine($file,"Accessed:"&$time2[2]&"/"&$time2[1]&"/"&$time2[0]&" - "& $time2[3]&":"&$time2[4]&":"&$time2[5])
		FileWrite($file,@CRLF&"***************************************************************************"&@CRLF)
	EndIf
EndFunc

		
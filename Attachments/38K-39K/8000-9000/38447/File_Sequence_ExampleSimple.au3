#include <Array.au3>

;The file Sequence UDF:
#include "File_sequence.au3"



;Info:
MsgBox(64, "What?", "This udf scans a folder or file for a file sequence." & @CRLF & _
		"Many programs use # as the file numbering, but you can easily convert # to %01d or wildcard * with the provided functions." & @CRLF & @CRLF & _
		"You can scan for any kind of file, but the UDF will only return file sequence of more than 3 files:" & @CRLF & @CRLF & _
		"Example:" & @CRLF & _
		"Scanning : 'C:\Folder\'" & @CRLF & _
		"Extentions: 'jpg tga mov'" & @CRLF & @CRLF & _
		"May return an array like this (where # represents the file numbering): " & @CRLF & _
		"$array[0] = 3" & @CRLF & _
		"$array[1] = C:\Folder\ImageSequence_####.tga" & @CRLF & _
		"$array[2] = C:\Folder\ImageSequence_Converted_####.jpg" & @CRLF & _
		"$array[3] = C:\Folder\quicktime movies ##.mov")



;Ask for a folder or a file path to scan, then ask for the image extention to search for:
Local $sPath = InputBox("Input", "Where do you want to look for sequence ?" & @CRLF & "Try a folder name or a single file name from a file sequence:", "", "", 800)
If Not $sPath Or (Not FileExists($sPath)) Then Exit MsgBox(0, "error", "No path specified or path doesn't exist")
Local $sExt = InputBox("Input", "What kind of extention ?" & @CRLF & "*.* or * or file extentions separated by a space or comma ('jpg png exr tga mov avi'...) ('jpg,png,exr,tga,mov,avi'...)", "Default", "", 800)
If $sExt = "Default" Or $sExt = "*" Or $sExt = "*.*" Or $sExt = "" Then
	$sExt = Default
Else
	StringReplace($sExt, ",", " ")
EndIf



;This is the UDF:
Local $aFileSequence = _FileSequence_Find($sPath, True, $sExt)

;Displays result:
_ArrayDisplay($aFileSequence)



Exit
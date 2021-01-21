; By NoCow
#include <GUIConstants.au3>
#Include <GuiList.au3>
$file = Fileopen(@autoitexe,0)
$filesize = FileGetSize(@autoitexe)
fileread($file,$filesize - 7)
$Thedata = fileRead($file,7)
FileClose($file)
if stringleft($Thedata,1) = chr(190) then
	$Thedata = Number(stringright($Thedata,6))
	$file = Fileopen(@autoitexe,0)
	Fileread($file,$thedata)
	$folder = FileSelectFolder("Save All Files To What Folder?",@scriptdir)
	$TheData = FileRead($file,$filesize - $thedata - 7)
	while stringlen($TheData) > 1
		$len = _StringFindUntil($TheData,"|")
		$temp = FileOpen($folder & "/" & StringLeft($TheData,$len),1)
		$TheData = StringTrimLeft($TheData,$len + 1)
		$lentowrite = stringleft($TheData,_StringFindUntil($TheData,"|"))
		$TheData = StringTrimLeft($TheData,StringLen($lentowrite) + 1)
		FileWrite($temp,stringleft($TheData,number($lentowrite)))
		$TheData = StringTrimLeft($TheData,number($lentowrite))
		FileClose($temp)
	Wend
Else
	$Form1 = GUICreate("AForm1", 297, 180, 199, 117)
	$Compile = GUICtrlCreateButton("Compile", 16, 136, 265, 33)
	$TheFileList = GUICtrlCreateList("", 16, 8, 265, 97)
	$Add = GUICtrlCreateButton("Add", 152, 112, 129, 17)
	$Remove = GUICtrlCreateButton("Remove", 16, 112, 129, 17)
	GUISetState(@SW_SHOW)
		While 1
		$msg = GuiGetMsg()
		Select
		Case $msg = $Add
			$temp = FileOpenDialog("Add file",@scriptdir,"All files(*.*)",1)
			GUICtrlSetData($TheFileList,$temp)
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		case $msg = $Remove

		Case $msg = $Compile
			$newfile = FileSaveDialog("Where to save EXE file?",@scriptdir,"All files(*.*)")
			FileDelete($newfile)
			FileCopy(@AutoitExe,$newfile)
			$file = FileOpen($newfile,1)
			for $i = 0 to  _GUICtrlListCount($TheFileList) -1
				$temp = _GUICtrlListGetText ($TheFileList,$i)
				$temp1 = FileOpen($temp,0)
				$Thedata = FileRead($temp1,FileGetSize($temp))
				FileClose($temp1)
				$temp2 = StringSplit($Temp,"\")
				FileWrite($file,$temp2[ubound($temp2)-1] & "|" & Stringlen($thedata) & "|" & $thedata)
			Next
			FileWrite($file,chr(190) & $filesize)
			Fileclose($file)
			msgbox(0,0,"Finish")
	EndSelect
	
	WEnd
	
	Exit

endif


Func _StringFindUntil($thestr,$too)
	for $i = 1 to StringLen($thestr)
		if Stringmid($thestr,$i,StringLen($too)) = $too Then			Return $i -1
	Next
	Return 0
EndFunc
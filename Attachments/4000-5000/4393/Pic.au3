#Include <GUIConstants.au3>

GUICreate("Picture",670,700)

FindFiles("C:\Billeder\","*.jpg")
GUISetState(@SW_SHOW)



While 1
	$msg = GUiGetMsg()
	Select	
	
		Case $msg = $GUI_EVENT_CLOSE 
			Exit

	EndSelect	
WEnd	

Func FindFiles($Dir,$Atribb)
	
	Local $PicPosX = 15
	Local $PicPosY = 50
	Local $Buffer = 0
	LoCal $i = 1
	
	$search = FileFindFirstFile($Dir & $Atribb)  
		If $search = -1 Then
			MsgBox(0, "Error", "No files/directories matched the search pattern")
			Exit
		EndIf

	While 1
		$file = FileFindNextFile($search) 
		If @error Then ExitLoop
		
		$n = GUICtrlCreatePic($Dir & $file,50,50,200,50)
		$n = GUICtrlSetPos($n,$PicPosX,$PicPosY,200,150)
		$Readini = IniReadSection("C:\Billeder\PictureInfo.ini", "Info")
		GUICtrlCreateLabel($Readini[$i][1],$PicPosX,$PicPosY+155,200,20)
		
		$PicPosX = $PicPosX + 220
	    $Buffer = $Buffer + 1
		$i = $i +1
		If $Buffer = 3 Then
			$PicPosY = $PicPosY + 200
			$PicPosX = 15
			$Buffer = 0
		EndIf	 
	WEnd
	FileClose($search)

EndFunc

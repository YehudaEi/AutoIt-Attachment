#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.13.13 (beta)
 Author:         Matthew McMullan

 Script Function:
	Import resources into a Warcraft 3 Map.

#ce ----------------------------------------------------------------------------

$GUI = GUICreate("war3 resource importer",300,150)

GUICtrlCreateLabel("Map Path",5,5)
$MapPath = GUICtrlCreateInput("C:\Documents and Settings\Administrator\Desktop\Mapping\MPQ Editor\CTF.w3x",5,25,240)
$BrowseMap = GUICtrlCreateButton("Browse",250,22,45)

GUICtrlCreateLabel("Resource Folder Path",5,55)
$ResourcePath = GUICtrlCreateInput("Resources",5,75,240)
$BrowseResource = GUICtrlCreateButton("Browse",250,72,45)

$Go = GUICtrlCreateButton("Go",5,105,100)

GUISetState(@SW_SHOW)

Global $checkres = False
Global $res

While 1
	$msg = GUIGetMsg()
	Switch $msg
		Case -3
			Exit
		Case $BrowseMap
			GUICtrlSetData($MapPath,FileOpenDialog("Browse for a map File",@ScriptDir,"Warcraft 3 Maps (*.w3m;*.w3x)",3))
		Case $BrowseResource
			GUICtrlSetData($ResourcePath,FileSelectFolder("Browse for a map File","",3,@ScriptDir))
			If StringLeft(GUICtrlRead($ResourcePath),StringLen(@ScriptDir)) == @ScriptDir Then
				GUICtrlSetData($ResourcePath,StringTrimLeft(GUICtrlRead($ResourcePath),StringLen(@ScriptDir)+1))
			EndIf
		Case $Go
			FileCopy(GUICtrlRead($MapPath),"Working\",9)
			FileCopy("MPQEditor.exe","Working\",9)
			FileDelete("Working\script.mopaq")
			FileWrite("Working\script.mopaq","extract "&FileName(GUICtrlRead($MapPath))&" war3map.imp Resources")
			RunWait("MPQEditor.exe /console script.mopaq","Working",@SW_HIDE)
			$checkres = False
			$search = FileFindFirstFile(GUICtrlRead($ResourcePath)&"\*.w3res")
			$file = FileFindNextFile($search)
			If Not(@error) Then
				$checkres = True
				$res=IniReadSection(GUICtrlRead($ResourcePath)&"\"&$file,"files")
				For $i = 1 To $res[0][0] Step 1
					FileCopy(GUICtrlRead($ResourcePath)&"\"&$res[$i][0],"Working\Resources\"&$res[$i][1],9)
					FileAdd($res[$i][1]&$res[$i][0])
				Next
			EndIf
			FileOrganise("btn",".blp","ReplaceableTextures\CommandButtons\")
			FileOrganise("btn",".tga","ReplaceableTextures\CommandButtons\")
			FileOrganise("pas",".blp","ReplaceableTextures\PassiveButtons\")
			FileOrganise("pas",".tga","ReplaceableTextures\PassiveButtons\")
			FileOrganise("att",".blp","ReplaceableTextures\")
			FileOrganise("att",".tga","ReplaceableTextures\")
			FileOrganise("upg",".blp","ReplaceableTextures\CommandButtons\")
			FileOrganise("upg",".tga","ReplaceableTextures\CommandButtons\")
			FileOrganise("dis",".blp","ReplaceableTextures\CommandButtonsDisabled\")
			FileOrganise("dis",".tga","ReplaceableTextures\CommandButtonsDisabled\")
			FileOrganise("",".ttf","Fonts\")
			FileOrganise("shadow",".blp","ReplaceableTextures\Shadows\")
			FileOrganise("BuildingShadow",".blp","ReplaceableTextures\Shadows\")
			FileOrganise("","UberSplat.blp","ReplaceableTextures\Splats\")
			FileOrganise("","UberSplat_mip1.blp","ReplaceableTextures\Splats\")
			FileOrganise("teamcolor",".blp","ReplaceableTextures\TeamColor\")
			FileOrganise("HumanUI","","UI\Console\Human\")
			FileOrganise("NightElf","","UI\Console\NightElf\")
			FileOrganise("OrcUI","","UI\Console\Orc\")
			FileOrganise("UndeadUI","","UI\Console\Undead\")
			FileOrganise("HumanCursor","","UI\Cursor\")
			FileOrganise("NightElfCursor","","UI\Cursor\")
			FileOrganise("OrcCursor","","UI\Cursor\")
			FileOrganise("UndeadCursor","","UI\Cursor\")
			FileDelete("Working\script.mopaq")
			FileWrite("Working\script.mopaq","add "&FileName(GUICtrlRead($MapPath))&" Resources /c /r")
			RunWait("MPQEditor.exe /console script.mopaq","Working",@SW_HIDE)
			MsgBox(0,"","")
			FileDelete("Working\MPQEditor.exe")
			FileDelete("Working\script.mopaq")
			DirRemove("Working\Resources",1)
			MsgBox(0,"Resources Imported","The file has been saved to \Working\"&FileName(GUICtrlRead($MapPath)))
	EndSwitch
WEnd

Func FileOrganise($prefix,$type,$Dir)
	$search = FileFindFirstFile(GUICtrlRead($ResourcePath)&"\"&$prefix&"*"&$type)
	While 1
		$file = FileFindNextFile($search) 
		If @error Then ExitLoop
		If $checkres==True Then
			$temp = True
			For $i = 1 To $res[0][0] Step 1
				If $res[$i][0] == $file Then
					$temp = False
				EndIf
			Next
			If $temp == True Then
				FileCopy(GUICtrlRead($ResourcePath)&"\"&$file,"Working\Resources\"&$Dir,9)
				FileAdd($Dir&$file)
			EndIf
		Else
			FileCopy(GUICtrlRead($ResourcePath)&"\"&$file,"Working\Resources\"&$Dir,9)
			FileAdd($Dir&$file)
		EndIf
	WEnd
EndFunc

Func FileAdd($file)
	FileWrite("Working\Resources\war3map.imp",$file&Chr(0)&Chr(13))
EndFunc

Func FileName($Path)
	$Segments = StringSplit($Path,"\")
	Return $Segments[$Segments[0]]
EndFunc
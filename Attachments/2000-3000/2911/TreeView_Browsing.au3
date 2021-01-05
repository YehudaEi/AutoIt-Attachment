#include <GUIConstants.au3>
#include <GUIListView.au3>
#include <GUITreeView.au3>
Opt("GUIOnEventMode", 1)
Opt("MustDeclareVars", 1)
Const $LVS_SORTDESCENDING = 0x0020

FileInstall("2.ico","2.ico")

Dim $GUI,$MainTree,$THandle,$SubTree,$DirInput,$BrowseBtn,$CurrentPath,$ObjCount,$SpaceCount,$Drives
Dim $MainMenu,$MainMenuExit,$MainMenuQues,$MainMenuAbout

$GUI = GUICreate("Treeview Browsing",750,520)
$MainMenu = GUICtrlCreateMenu("File")
$MainMenuExit = GUICtrlCreateMenuItem("Exit",$MainMenu)
$MainMenuQues = GUICtrlCreateMenu("?")
$MainMenuAbout = GUICtrlCreateMenuItem("About",$MainMenuQues)
$MainTree = GUICtrlCreateTreeView(1, 60, 250, 417)
$THandle = ControlGetHandle($GUI,"",$MainTree)
$SubTree = GUICtrlCreateListview("Name|Size|Type|Changed",258, 59, 492, 419)
GUICtrlSetImage($MainTree, "2.ico")
GUICtrlSetImage($SubTree, "shell32.dll", 0)
GUICtrlCreateGroup("",0,53,252,425)
$Drives = GUICtrlCreateCombo("",0,10,188,20,$CBS_DROPDOWNLIST + $CBS_UPPERCASE)
$DirInput = GUICtrlCreateInput(@ProgramFilesDir &"\",0,37,188,20)
$BrowseBtn = GUICtrlCreateButton("Search",193,37,60,21)
$CurrentPath = GUICtrlCreateInput("",258,37,492,20)
GUICtrlSetState(-1,$GUI_Disable)
$ObjCount = GUICtrlCreateInput("0 Object(s)",0,480,150,20,$ES_READONLY)
GUICtrlSetState(-1,$GUI_Disable)
$SpaceCount = GUICtrlCreateInput("N/A",154,480,596,20,$ES_READONLY)
GUICtrlSetState(-1,$GUI_Disable)

Dim $B_DESCENDING[_GUICtrlListViewGetSubItemsCount($SubTree)]
_GUICtrlListViewSetColumnWidth($SubTree, 0,190)
_GUICtrlListViewSetColumnWidth($SubTree, 1,100)
_GUICtrlListViewSetColumnWidth($SubTree, 2,80)
_GUICtrlListViewSetColumnWidth($SubTree, 3,100)
_GUICtrlListViewJustifyColumn($SubTree, 1, 1)
_GUICtrlListViewJustifyColumn($SubTree, 3, 0)
GetDrives()

GUISetOnEvent($GUI_EVENT_CLOSE, "GUIExit")
GUICtrlSetOnEvent($Drives, "LoadHd")
GUICtrlSetOnEvent($BrowseBtn, "BrowseBtn")
GUICtrlSetOnEvent($MainMenuExit, "GUIExit")
GUICtrlSetOnEvent($MainMenuAbout, "About")

GUISetState()
WinSetTitle($GUI,"","Treeview Browsing - Loading")
_LoadTree(GUICtrlRead($DirInput), $SubTree,1)
_LoadTree(GUICtrlRead($DirInput), $MainTree,0)
WinSetTitle($GUI,"","Treeview Browsing")

While 1 ;Main Loop
Sleep(100)
	
	;~ Case $msg = $SubTree AND GUICtrlGetState($SubTree) > 0 AND GUICtrlGetState($SubTree) < 4
		;~ If GUICtrlGetState($SubTree) = 1 Then 
			;~ SortListViewSize($SubTree,1)
		;~ Else
			;~ _GUICtrlListViewSort($SubTree, $B_DESCENDING, GUICtrlGetState($SubTree))
		;~ EndIf
		;~ SetColumnWidth()

Wend ;Mainloop end


;                 Functions
;////////////////////////////////////////////
Func _LoadTree($sRoot, $hParent, $GetFiles)
	Local $ThePath = GUICtrlRead($CurrentPath)
	Local $sMask = "*.*"
	Local $aFile[1], $nCnt = 1, $newParent
    Local $hSearch = FileFindFirstFile($sRoot & $sMask)
	Local $sFile,$FilegetSize,$Time,$yyyymd,$SnewParent,$asIconInfo,$FolderMenu,$FolderDelete,$FolderRename,$FolderOptions,$PutPath
	Local $EXEMenu,$EXEDelete,$EXERename,$EXERun,$EXEOptions,$FileMenu,$FileDelete,$FileRename,$FileOptions,$ExeFile,$OtherFile 
	If $hSearch >= 0 Then
       $sFile = FileFindNextFile($hSearch)
       While not @error
            ReDim $aFile[$nCnt]
            $aFile[$nCnt-1] = $sFile
            $nCnt = $nCnt + 1
			$sFile = FileFindNextFile($hSearch)
       Wend
       FileClose($hSearch)
    EndIf
    For $i = 0 To UBound($aFile) - 1
		If $aFile[$i] == "." or $aFile[$i] == ".." Then ContinueLoop
		If $GetFiles = 0 Then ;Do not include files
			If StringInStr(FileGetAttrib($sRoot & "\" & $aFile[$i]), "D") Then
				$newParent = GUICtrlCreateTreeViewItem($aFile[$i], $hParent)
				GuiCtrlSetOnEvent(-1, "TreeViewCLick")
				_LoadTree($sRoot & $aFile[$i] & "\", $newParent,0) ;Keep search trough folders
				ContinueLoop
			Endif
		ElseIf $GetFiles = 1 OR $GetFiles = 2 Then ;Include Files
			$FileGetSize = Round(FileGetSize($ThePath & $aFile[$i]) / 1024,0) 
			$Time = FileGetTime($ThePath & $aFile[$i], 1)
			If Not @Error Then
				$yyyymd = $Time[2] & "." & $Time[1] & "." & $Time[0] & " " & $Time[3] & ":" & $Time[4]
				If StringInStr(FileGetAttrib($sRoot & "\" & $aFile[$i]), "D") Then
					$SnewParent = GUICtrlCreateListViewItem($aFile[$i] &"||"& _FileGetType($ThePath & $aFile[$i]) &"|"& $yyyymd, $hParent)
					GUICtrlSetImage(-1, "2.ico")
					$FolderMenu = GUICtrlCreateContextMenu($SnewParent)
					$FolderDelete = GUICtrlCreateMenuitem("Delete",$FolderMenu)
					$FolderRename = GUICtrlCreateMenuitem("Rename",$FolderMenu)
					$FolderOptions = GUICtrlCreateMenuitem("Properties",$FolderMenu)
					GUICtrlSetOnEvent($FolderDelete, "FolderDelete")
					GUICtrlSetOnEvent($FolderRename, "FolderRename")
					GUICtrlSetOnEvent($FolderOptions, "Properties")
					GUICtrlSetState(-1,$GUI_DEFBUTTON)
					ContinueLoop
				Endif
				
				If StringRight($aFile[$i],4) = ".EXE" Then
					$ExeFile = GUICtrlCreateListViewItem($aFile[$i] &"|"& $FilegetSize & " KB" &"|"& _FileGetType($ThePath & $aFile[$i]) &"|"& $yyyymd, $hParent) ;Include files
					GUICtrlSetImage(-1, $ThePath & $aFile[$i], 0)
					$EXEMenu = GUICtrlCreateContextMenu($ExeFile)
					$EXEDelete = GUICtrlCreateMenuitem("Delete",$EXEMenu)
					$EXERename = GUICtrlCreateMenuitem("Rename",$EXEMenu)
					$EXERun = GUICtrlCreateMenuitem("Execute",$EXEMenu)
					$EXEOptions = GUICtrlCreateMenuitem("Properties",$EXEMenu)
					GUICtrlSetOnEvent($EXEDelete, "Delete")
					GUICtrlSetOnEvent($EXERename, "Rename")
					GUICtrlSetOnEvent($EXERun, "EXECute")
					GUICtrlSetOnEvent($EXEOptions, "properties")
					GUICtrlSetState(-1,$GUI_DEFBUTTON)
				Else	
					$asIconInfo = _GetAssociatedIcon(StringRight($aFile[$i],4))
					$OtherFile = GUICtrlCreateListViewItem($aFile[$i] &"|"& $FilegetSize & " KB" &"|"& _FileGetType($ThePath & $aFile[$i]) &"|"& $yyyymd, $hParent) ;Include files
					GUICtrlSetImage(-1, $asIconInfo[1], $asIconInfo[2])
					$FileMenu = GUICtrlCreateContextMenu($OtherFile)
					$FileDelete = GUICtrlCreateMenuitem("Delete",$FileMenu)
					$FileRename = GUICtrlCreateMenuitem("Rename",$FileMenu)
					$FileOptions = GUICtrlCreateMenuitem("Properties",$FileMenu)
					GUICtrlSetState(-1,$GUI_DEFBUTTON)
					GUICtrlSetOnEvent($FileDelete, "Delete")
					GUICtrlSetOnEvent($FileRename, "Rename")
					GUICtrlSetOnEvent($FileOptions, "properties")
				EndIf
			EndIf
		EndIf
    Next
EndFunc

Func TreeViewClick()
	Local $GetThePath,$TheSize,$FreeSpace
	_GUICtrlListViewDeleteAllItems($SubTree)
	$GetThePath = GUICtrlRead($DirInput) & _GUICtrlTreeViewItemGetTree($GUI,$MainTree) &"\"
	$TheSize = DirGetSize(GUICtrlRead($Currentpath)) / 1024 / 1024
	$FreeSpace = DriveSpaceFree(Stringleft(GUICtrlRead($DirInput),3))/ 1024
	GUICtrlSetdata($CurrentPath,$GetThePath)
	_LoadTree($GetThePath,$SubTree,1) ;Path/Tree/State
	GUICtrlSetdata($ObjCount,_GUICtrlListViewGetItemCount($SubTree) & " Object(s)")
	GUICtrlSetdata($SpaceCount,Stringleft($TheSize,Stringinstr($TheSize,".")+2) & " MB (Free Space: "& StringLeft($FreeSpace,StringInStr($FreeSpace,".")+1) & " GB)")
	;SortListViewSize($SubTree,1)
	SetColumnWidth()
EndFunc	

Func _FileGetExt($sFileName)
	Dim $DotPos, $Other
	$DotPos = StringInStr($sFileName, '.', 1, -1)
	If $DotPos = 0 Then Return ''
	$Other = StringInStr($sFileName, '\', 1, -1)
	If $Other > $DotPos Then Return ''
	$Other = StringInStr($sFileName, ':', 1, -1)
	If $Other > $DotPos Then Return ''
	Return StringTrimLeft($sFileName, $DotPos)
EndFunc
Func _FileGetType($sFileName)
	Dim $Type
	If StringInStr(FileGetAttrib($sFileName),"D") Then
		$Type = RegRead('HKEY_CLASSES_ROOT\Folder', '')
	Else
		Dim $Ext = _FileGetExt($sFileName)
		$Type = RegRead('HKEY_CLASSES_ROOT\.' & $Ext, '')
		If $Type = '' Then
			$Type = $Ext & '-file'
		Else
			Dim $Type2 = RegRead('HKEY_CLASSES_ROOT\' & $Type, '')
			If $Type2 <> '' Then $Type = $Type2
		EndIf
	EndIf
	Return $Type
EndFunc

Func SetColumnWidth()
	If _GUICtrlListViewGetColumnWidth($SubTree,0) <> 200 Then _GUICtrlListViewSetColumnWidth($SubTree,0,190)
	If _GUICtrlListViewGetColumnWidth($SubTree,1) <> 100 Then _GUICtrlListViewSetColumnWidth($SubTree,1,100)
	If _GUICtrlListViewGetColumnWidth($SubTree,2) <> 80 Then _GUICtrlListViewSetColumnWidth($SubTree,2,80)
	If _GUICtrlListViewGetColumnWidth($SubTree,3) <> 100 Then _GUICtrlListViewSetColumnWidth($SubTree,3,100)
EndFunc

Func SortListViewSize($hListView,$hColumn)
	Local $ItemsCount = _GUICtrlListViewGetItemCount($hListView) 
	If NOT $ItemsCount = 0 Then
		Dim $ColumnGetItemtext[$ItemsCount]
		;Remove KB
		For $i = 0 To $ItemsCount -1 
			$ColumnGetItemtext = _GUICtrlListViewGetItemText($hListView,$i,$hColumn)
			If StringRight($ColumnGetItemtext,2) = "KB" Then 
				_GUICtrlListViewSetItemText ($hListView, $i, $hColumn, StringTrimRight($ColumnGetItemtext,3))
			Else
				ContinueLoop
			EndIf
		Next
		;Sort Listview
		_GUICtrlListViewSort($hListView, $B_DESCENDING, $hColumn)
		;Put KB
		For $i = 0 To $ItemsCount -1
			$ColumnGetItemtext = _GUICtrlListViewGetItemText($hListView,$i,$hColumn)
			If $ColumnGetItemtext = '' Then ContinueLoop
			_GUICtrlListViewSetItemText ($hListView, $i, $hColumn, $ColumnGetItemtext & " KB")
		Next
	EndIf
EndFunc	

Func _GetAssociatedIcon($sFileExt)
	Local $sFileType, $sIconInfo, $asIconInfo[3]
	For $i = 0 to 2
		$asIconInfo[$i] = ""
	Next
	$sFileType = RegRead("HKCR\" & $sFileExt, "")
	If $sFileType <> "" Then
		$sIconInfo = RegRead("HKCR\" & $sFileType & "\DefaultIcon", "")
		If $sIconInfo <> "" Then
			$asIconInfo = StringSplit($sIconInfo, ",")
			If @error Then
				ReDim $asIconInfo[3]
				$asIconInfo[0] = "2"
				$asIconInfo[1] = _ExpandEnvStrings(FileGetLongName($sIconInfo))
				$asIconInfo[2] = "0"
			EndIf
		EndIf
	EndIf
	Return $asIconInfo
EndFunc

Func _ExpandEnvStrings($sInput)	
	Local $aPart = StringSplit($sInput,'%')	
	If @error Then		
		SetError(1)		
		Return $sInput	
	EndIf	
	
	Dim $sOut = $aPart[1], $i = 2, $env = ''	
	;loop through the parts	
	While $i <= $aPart[0]		
		$env = EnvGet($aPart[$i])		
		If $env <> '' Then 
			;this part is an expandable environment variable			
			$sOut = $sOut & $env			
			$i = $i + 1			
			If $i <= $aPart[0] Then 
				$sOut = $sOut & $aPart[$i]		
			ElseIf $aPart[$i] = '' Then 
				;a double-percent is used to force a single percent			
				$sOut = $sOut & '%'			
				$i = $i + 1			
				If $i <= $aPart[0] Then 
					$sOut = $sOut & $aPart[$i]		
				Else ;this part is to be returned literally			
					$sOut = $sOut & '%' & $aPart[$i]		
				EndIf
			EndIf
		EndIf
		$i = $i + 1	
	WEnd	
	Return $sOut
EndFunc

Func GUIExit()
	Exit
EndFunc

Func BrowseBtn()
	GUICtrlSetState($BrowseBtn,$GUI_DISABLE)
	WinSetTitle($GUI,"","Treeview Browsing - Searching")
	_GUICtrlTreeViewDeleteAllItems($MainTree)
	GUICtrlSetdata($CurrentPath,GUICtrlRead($DirInput))
	_LoadTree(GUICtrlRead($DirInput), $MainTree,0) ;Path/Tree/State
	SetColumnWidth()	
	WinSetTitle($GUI,"","Treeview Browsing")
	GUICtrlSetState($BrowseBtn,$GUI_ENABLE)
EndFunc		

Func GetDrives()
	Local $VarGetdrives,$DriveType,$Type
	$VarGetdrives = DriveGetDrive("ALL")
	For $i = 1 To $VarGetdrives[0]
		$DriveType = DriveGetType($VarGetdrives[$i])
		GUICtrlSetdata($Drives,$VarGetdrives[$i] & " [" & $DriveType & "]",@HomeDrive & " [FIXED]")
	Next	
	GUICtrlSetData($CurrentPath,GUICtrlRead($DirInput))
EndFunc	

Func LoadHD()
	WinSetTitle($GUI,"","Treeview Browsing - Loading")
	GUICtrlSetData($CurrentPath,StringLeft(GUICtrlRead($Drives),2) & "\")
	GUICtrlSetData($DirInput,StringLeft(GUICtrlRead($Drives),2) & "\")
	_GUICtrlListViewDeleteAllItems($SubTree)
	_GUICtrlTreeViewDeleteAllItems($MainTree)
	_LoadTree(GUICtrlRead($DirInput), $SubTree,1)
	_LoadTree(GUICtrlRead($DirInput), $MainTree,0)
	WinSetTitle($GUI,"","Treeview Browsing")
EndFunc

Func Properties()
	Local $PFileType,$PFilePath,$PFileSize,$PFileCreated,$PFileVersion,$PFileAttrib,$PFileName,$asIconInfo
	Global $PropertiesGUI
	$PropertiesGUI = GUICreate("Properties",270,300)
	GUICtrlCreateTab(5,7,260,260)
	GUICtrlCreateTabItem("General")
	GUICtrlCreateLabel("_______________________________________",15,60,250,20,$WS_DISABLED)
	GUICtrlCreateLabel("Filetype:",15,80,70,20)
	GUICtrlCreateLabel("Path:",15,105,70,20)
	GUICtrlCreateLabel("Size:",15,130,70,20)
	GUICtrlCreateLabel("_______________________________________",15,140,250,20,$WS_DISABLED)
	GUICtrlCreateLabel("Created:",15,160,70,20)
	GUICtrlCreateLabel("Version:",15,185,70,20)
	GUICtrlCreateLabel("_______________________________________",15,195,250,20,$WS_DISABLED)
	GUICtrlCreateLabel("Attibutes:",15,215,70,20)
	$PFileName = GUICtrlCreateInput(_GUICtrlListViewGetItemText($SubTree, -1, 0),70,43,180,20,$ES_ReadOnly)
	$PFileType = GUICtrlCreateLabel(_GUICtrlListViewGetItemText($SubTree, -1, 2),70,80,180,20)
	$PFilePath = GUICtrlCreateLabel(GUICtrlRead($CurrentPath),70,105,180,20)
	$PFileSize = GUICtrlCreateLabel(_GUICtrlListViewGetItemText($SubTree, -1, 1),70,130,180,20)
	$PFileCreated = GUICtrlCreateLabel(_GUICtrlListViewGetItemText($SubTree, -1, 3),70,160,180,20)
	$PFileVersion = GUICtrlCreateLabel("N/A",70,185,180,20)
	$PFileAttrib = GUICtrlCreateLabel("N/A",70,215,180,20)
	GUICtrlCreateButton("OK",120,270,70,23)
	GUICtrlSetOnEvent(-1,"PropertiesOKBtn")
	GUICtrlCreateButton("Cancel",195,270,70,23)
	GUICtrlSetOnEvent(-1,"PropertiesOKBtn")
	GUISetState()
EndFunc	

Func FolderDelete()
	DirRemove(GUICtrlRead($Currentpath) & _GUICtrlListViewGetItemText($SubTree, -1, 0),1)
	Sleep(500)
	_GUICtrlListViewDeleteAllItems($SubTree)
	_LoadTree(GUICtrlRead($Currentpath), $SubTree,1)
EndFunc	

Func Delete()
	FileDelete(GUICtrlRead($Currentpath) & _GUICtrlListViewGetItemText($SubTree, -1, 0))
	Sleep(500)
	_GUICtrlListViewDeleteAllItems($SubTree)
	_LoadTree(GUICtrlRead($Currentpath), $SubTree,1)
EndFunc	

Func ExeCute()
	Run(GUICtrlRead($Currentpath) & _GUICtrlListViewGetItemText($SubTree, -1, 0)) 
EndFunc	

Func Rename()
	Local $NameOKBtn,$NameCancelBtn;,$NameSplit
	Global $RenameGUI,$NewName,$Namesplit
	$RenameGUI = GUICreate("File rename",270,100)
	GUICtrlCreateLabel("Current name:",10,10,70,20)
	GUICtrlCreateLabel("New name:",10,40,70,20)
	$NameSplit = _GUICtrlListViewGetItemText($SubTree, -1, 0)
	GUICtrlCreateInput(StringLeft($NameSplit,StringLen($NameSplit)-4),90,8,170,20,$WS_DISABLED)
	$NewName = GUICtrlCreateInput("",90,38,170,20)
	$NameOKBtn = GUICtrlCreateButton("OK",125,70,65,22)
	GUICtrlSetOnEvent(-1,"RenameOKBtn")
	$NameCancelBtn = GUICtrlCreateButton("Cancel",195,70,65,22)
	GUICtrlSetOnEvent(-1,"RenameCancelBtn")
	GUISetState()
EndFunc	

Func FolderRename()
	Local $CurrentName,$NewName,$NameOKBtn,$NameCancelBtn
	Global $FolderRenameGUI,$NameSplit1,$FolderNewName
	$FolderRenameGUI = GUICreate("Folder rename",270,100)
	GUICtrlCreateLabel("Current name:",10,10,70,20)
	GUICtrlCreateLabel("New name:",10,40,70,20)
	$NameSplit1 = _GUICtrlListViewGetItemText($SubTree, -1, 0)
	$CurrentName = GUICtrlCreateInput($NameSplit1,90,8,170,20,$WS_DISABLED)
	$FolderNewName = GUICtrlCreateInput("",90,38,170,20)
	$NameOKBtn = GUICtrlCreateButton("OK",125,70,65,22)
	GUICtrlSetOnEvent(-1,"FolderRenameOKBtn")
	$NameCancelBtn = GUICtrlCreateButton("Cancel",195,70,65,22)
	GUICtrlSetOnEvent(-1,"FolderRenameCancelBtn")
	GUISetState()
EndFunc	

Func PropertiesOKBtn()
	GUIDelete($PropertiesGUI)
EndFunc	

Func RenameOKBtn()
	Local $Exst,$xNewname
	$Exst = StringRight($NameSplit,4)
	If StringRight(GUICtrlRead($NewName),4) = $Exst Then 
		$xNewname = GUICtrlRead($NewName)
	Else
		$xNewname = GUICtrlRead($NewName) & $Exst
	EndIf	
	FileMove(GUICtrlRead($Currentpath) & $Namesplit,GUICtrlRead($Currentpath) & $xNewname,1)
	Sleep(500)
	_GUICtrlListViewDeleteAllItems($SubTree)
	;_LoadTree(GUICtrlRead($Currentpath), $SubTree,1)
	GUIDelete($RenameGUI)
EndFunc	

Func RenameCancelBtn()
	GUIDelete($RenameGUI)
EndFunc	

Func FolderRenameOKBtn()
	DirMove(GUICtrlRead($Currentpath) & $NameSplit1,GUICtrlRead($Currentpath) & GUICtrlRead($FolderNewName),1)
	_GUICtrlListViewDeleteAllItems($SubTree)
	;_LoadTree(GUICtrlRead($Currentpath), $SubTree,1)
	GUIDelete($FolderRenameGUI)
EndFunc	

Func FolderRenameCancelBtn()
	GUIDelete($FolderRenameGUI)
EndFunc	

Func About()
	Msgbox(32,"About","Created by FreeKill - Wb-FreeKill@hotmail.com")
EndFunc	
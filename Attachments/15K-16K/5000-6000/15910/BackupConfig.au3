#Region converted Directives from D:\My Documents\AutoITscripts\Directory Copy\BackupConfig.au3.ini
#AutoIt3Wrapper_aut2exe=C:\Program Files\AutoIt3\Aut2Exe\Aut2Exe.exe
#AutoIt3Wrapper_icon=D:\My Documents\icons\Tic2.ico
#AutoIt3Wrapper_outfile=D:\My Documents\AutoITscripts\Directory Copy\BackupConfig.exe
#AutoIt3Wrapper_Allow_Decompile=4
#AutoIt3Wrapper_Res_Comment=                                               
#AutoIt3Wrapper_Res_Description=AutoIt v3 Compiled Script
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=n
#AutoIt3Wrapper_Run_AU3Check=4
#EndRegion converted Directives from D:\My Documents\AutoITscripts\Directory Copy\BackupConfig.au3.ini
;
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.2.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <GUIConstants.au3>
#include<GuiListView.au3>

$lastSourceDir = iniread ("Backup.ini","General","lastSource",@ScriptDir)
$lastDestinationDir = iniread ("Backup.ini","General","lastDest",@ScriptDir)


$Form1 = GUICreate("Backup Settings", 570, 378, -1, -1)
$NewFolderBTN = GUICtrlCreateButton("New", 505, 70, 49, 25, 0)
$DelFolderBTN = GUICtrlCreateButton("Del", 505, 110, 49, 25, 0)

GuiCtrlCreateLabel ("Folders to Backup",10,10)
$FoldersLV = GUICtrlCreateListView("Source|Destination", 8, 26, 481, 135)
_GUICtrlListViewSetColumnWidth ( -1, 0,235)
_GUICtrlListViewSetColumnWidth ( -1, 1,235)

GuiCtrlCreateLabel ("Files to Backup",10,179)
$FilesLV = GUICtrlCreateListView("Source|Destination", 8, 195, 481, 135)
_GUICtrlListViewSetColumnWidth ( -1, 0,235)
_GUICtrlListViewSetColumnWidth ( -1, 1,235)

$NewFileBTN = GUICtrlCreateButton("New", 505, 235, 49, 25, 0)
$DelFileBTN = GUICtrlCreateButton("Del", 505, 276, 49, 25, 0)

$1 = "High"
$2 = "Medium"
$3 = "low"
$defaultPriority = Eval (iniread ("backup.ini","General","Priority","1"))
If $defaultPriority = "" then $defaultPriority = "high"
$Priority = GuiCtrlCreateCombo ("",59,338,75,121)
GuiCtrlSetData(-1,"High|Medium|low",$defaultPriority)
GuiCtrlCreateLabel ("Priority",20,340)

$showGui = GUICtrlCreateCheckbox("Show Gui while running",150,340,140,20)
If iniRead ("backup.ini","General","ShowGui","yes") = "yes" then GUICtrlSetState(-1,$Gui_Checked)

$enablePurge = GUICtrlCreateCheckbox("Purge Backup",300,340,100,20)
If iniRead ("backup.ini","General","Purge","no") = "yes" then GUICtrlSetState(-1,$Gui_Checked)

$save = GuiCtrlCreateButton ("Save",500,340,60,30)
GUISetState(@SW_SHOW)




$iniFolders = IniReadSection("Backup.ini","BackupFolders")

For $i = 1 to Ubound ($iniFolders) -1
	GUICtrlCreateListViewItem ( StringReplace ($iniFolders[$i][1],",","|"), $FoldersLV )
Next

$iniFiles = IniReadSection("Backup.ini","BackupFiles")

For $i = 1 to Ubound ($iniFiles) -1
	GUICtrlCreateListViewItem ( StringReplace ($iniFiles[$i][1],",","|"), $FilesLV )
Next	


While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			$ans = MsgBox (4+262144,"Exit","Do you want to exit without saving?")
			if $ans = 6 then Exit
		Case $NewFolderBTN
			NewFolder()
		Case $DelFolderBTN
			DelFolder()
		Case $NewFileBTN
			NewFile()
		Case $DelFileBTN
			DelFile()
		Case $save
			Save()
	EndSwitch
WEnd

Func NewFile()
	$Source = FileOpenDialog ( "Select Source file",$lastSourceDir,"All (*.*)",1)
	If $Source <> "" then 
		$lastSourceDir = StringLeft ($Source ,StringInStr ($Source,"\","",-1))
		;$fileName = StringTrimLeft ($Source ,StringInStr ($Source,"\","",-1))
		;Msgbox(0,$fileName,$LastSourceDir)
		$Destination = FileSelectFolder ( "Select Destination folder", "" , 7 , $lastDestinationDir)
		
		if $Destination<>"" then 
			$lastDestinationDir = $Destination
			If StringRight($destination,1) <> "\" then $Destination &= "\"
			$slashpos = StringinStr ($source,"\",0,-1) - 1
			;Msgbox (0,$slashpos,StringLeft ($source,$slashpos))
			$destination &= StringReplace (StringLeft ($source,$slashpos),":","")
			IF NOT FileExists($destination) then DirCreate ($Destination )
			GUICtrlCreateListViewItem ( $source & "|" & $Destination, $FilesLV )
		EndIf
	Endif
EndFunc

Func NewFolder()
	$Source = FileSelectFolder ( "Select Source folder", "" , 6 , $lastSourceDir)
	If $Source <> "" then 
		$lastSourceDir = $Source
		$Destination = FileSelectFolder ( "Select Destination folder", "" , 5 , $lastDestinationDir)
		
		if $Destination<>"" then 
			$lastDestinationDir = $Destination
			If StringRight($destination,1) <> "\" then $Destination &= "\"
			$destination &= StringReplace ($source,":","")
			IF NOT FileExists($destination) then DirCreate ($Destination )
			GUICtrlCreateListViewItem ( $source & "|" & $Destination, $FoldersLV )
		EndIf
	Endif
EndFunc
	

Func DelFolder()
	
	_GUICtrlListViewDeleteItemsSelected ( $FoldersLV )

EndFunc

Func DelFile()
	
	_GUICtrlListViewDeleteItemsSelected ( $FilesLV )

EndFunc

Func Save()
	$folderCnt = _GUICtrlListViewGetItemCount ( $FoldersLV )
	$fileCnt = _GUICtrlListViewGetItemCount ( $FilesLV )
	
	
	
	$ini = FileOpen (@scriptdir & "\Backup.ini",2)
	
	FileWriteLine($ini,"[BackupFolders]")
	For $i = 1 to $folderCnt
		FileWriteLine($ini, $i & "=" & StringReplace(_GUICtrlListViewGetItemText ( $FoldersLV , $i-1 ),"|",","))
	Next
	FileWriteLine($ini,"")
	
	FileWriteLine($ini,"[BackupFiles]")

	For $i = 1 to $fileCnt
		FileWriteLine($ini, $i & "=" & StringReplace(_GUICtrlListViewGetItemText ( $FilesLV , $i-1 ),"|",","))
	Next
	FileWriteLine($ini,"")
	
	$high = 1
	$medium = 2
	$low = 3
	FileWriteLine($ini,"[General]")
	FileWriteLine($ini,"; 1 high")
	FileWriteLine($ini,"; 2 medium")
	FileWriteLine($ini,"; 3 low")
	FileWriteLine($ini,"Priority=" & Eval(GuiCtrlRead($Priority)))
	
	If BitAnd (GuiCtrlRead($showGui),$Gui_Checked) then 
		FileWriteLine ($ini,"ShowGui=yes")
	Else
		FileWriteLine ($ini,"ShowGui=no")
	EndIf
	
	If BitAnd (GuiCtrlRead($enablePurge),$Gui_Checked) then
		FileWriteLine ($ini,"Purge=yes")
	Else
		FileWriteLine ($ini,"Purge=no")
	EndIf
	
	FileWriteLine($ini,"lastSource=" & $lastSourceDir)
	FileWriteLine($ini,"lastDest=" & $lastDestinationDir)
	
	FileClose ($ini)
	
	Msgbox (262144,"Saved","Settings have been saved",5)
	Exit
EndFunc

	
	
	
	






#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIConstants.au3>
#include <EditConstants.au3>
#include <Array.au3>
#include <File.au3>
#include <GUIListBox.au3>

FileInstall("streams.exe",@Tempdir & "\streams.exe")
AutoItSetOption("TrayIconHide",1)

#region Main GUI
$gui = GUICreate("HideIt",300,250,-1,-1,$WS_POPUP)
$exitbtn = GUICtrlCreateButton("X",279,3,17,17)
	GUICtrlSetFont(-1,"8.5",640)
$tabs = GUICtrlCreateTab(5,5,290,240)
$tab1 = GUICtrlCreateTabItem("Hide File")
	$lblFiletohide = GUICtrlCreateLabel("File to Hide:",20,60)
	$inputFiletohide = GUICtrlCreateInput("",80,58,180,20,$ES_READONLY+$ES_AUTOHSCROLL)
	$btnFiletohide = GUICtrlCreateButton("...",265,58,20,20)
		GUICtrlSetState(-1,$GUI_FOCUS)
	$lblHideinfile = GUICtrlCreateLabel("Hide in File:",20,105)
	$inputHideinfile = GUICtrlCreateInput("",80,103,180,20,$ES_READONLY+$ES_AUTOHSCROLL)
	$btnHideinfile = GUICtrlCreateButton("...",265,103,20,20)
	$lblHidenfilename = GUICtrlCreateLabel("Hiden Filename:",20,150)
	$inputHidenfilename = GUICtrlCreateInput("",100,148,160,20,+$ES_AUTOHSCROLL)
	$btnHideFile = GUICtrlCreateButton("Hide It",110,195,80,24)
		GUICtrlSetFont(-1,"8.5",600)
$tab2 = GUICtrlCreateTabItem("Browser")
	$lblBrowsefile = GUICtrlCreateLabel("Browse File:",20,40)
	$inputBrowsefile = GUICtrlCreateInput("",80,38,180,20,$ES_READONLY+$ES_AUTOHSCROLL)
	$btnBrowsefile = GUICtrlCreateButton("...",265,38,20,20)
	$listBrowser = GUICtrlCreateList("",14,70,270,138)
	$btnOpen = GUICtrlCreateButton("&Open",110,210,80,24)
		GUICtrlSetFont(-1,"8.5",600)
$tab3 = GUICtrlCreateTabItem("Cleaner")
	$lblCleanfile = GUICtrlCreateLabel("Clean File:",20,100)
	$inputCleanfile = GUICtrlCreateInput("",80,98,180,20,$ES_READONLY+$ES_AUTOHSCROLL)
	$btnCleanfile = GUICtrlCreateButton("...",265,98,20,20)
	$btnClean = GUICtrlCreateButton("&Clean",110,140,80,24)
		GUICtrlSetFont(-1,"8.5",600)
	
GUISetState()

While 1
	
	If WinActive("HideIt") Then 
		HotKeySet("{del}","ClearGUI")
	Else
		HotKeySet("{del}")
	EndIf
	
	$msg = GUIGetMsg()
	
	If $msg = $GUI_EVENT_PRIMARYDOWN Then _SendMessage($gui, $WM_SYSCOMMAND, 0xF012, 0)

	If $msg = $btnHideFile Then
		$filetohide = GUICtrlRead($inputFiletohide)
		$hideinfile = GUICtrlRead($inputHideinfile)
		$hidenfilename = StringReplace(GUICtrlRead($inputHidenfilename)," ","")
		If $hideinfile <> "" And $filetohide <> "" And $hidenfilename <> "" Then
			HideFile($filetohide,$hideinfile,$hidenfilename)
			ClearGUI()
		EndIf
	EndIf
	
	If $msg = $btnClean Then
		$cleanfile = GUICtrlRead($inputCleanfile)
		If $cleanfile <> "" Then CleanFile($cleanfile)
		ClearGUI()
	EndIf
	
	If $msg = $btnCleanfile Then
		$cleanfile = FileOpenDialog("File to Hide...",@WorkingDir,"(*.*)",1)
		If $cleanfile <> "" Then
			GUICtrlSetData($inputCleanfile,$cleanfile)
		EndIf
	EndIf	
	
	If $msg = $btnFiletohide Then 
		$input = FileOpenDialog("File to Hide...",@WorkingDir,"(*.*)",1)
		GUICtrlSetData($inputFiletohide,$input)
		GUICtrlSetData($inputHidenfilename,StringReplace(StringRight($input,StringLen($input)-StringInstr($input,"\","",-1))," ",""))
	EndIf
	
	If $msg = $btnBrowsefile Then 
		GUICtrlSetData($inputBrowsefile,"")
		_GUICtrlListBox_ResetContent($listBrowser)
		$browsefilepath = FileOpenDialog("Browse File...",@WorkingDir,"(*.*)",1)
		If $browsefilepath <> "" Then
			$streams = GetADStreams($browsefilepath)
			GUICtrlSetData($inputBrowsefile,StringRight($browsefilepath,StringLen($browsefilepath)-StringInstr($browsefilepath,"\","",-1)))
			If IsArray($streams) Then	
				If UBound($streams)>=5 Then
					For $i = 7 to UBound($streams) -1
						$streamname = StringRight($streams[$i],StringLen($streams[$i])-StringInstr($streams[$i],":"))
						$streamname = StringLeft($streamname,StringInstr($streamname,":")-1)
						_GUICtrlListBox_AddString($listBrowser,$streamname)
					Next
					If $streams[0] = 8 Then _GUICtrlListBox_SetCurSel($listBrowser,0)
				EndIf
			EndIf
		EndIf
	EndIf
		
	If $msg = $btnOpen Then
		If _GUICtrlListBox_GetCount($listBrowser) Then
			$selection = _GUICtrlListBox_GetCurSel($listBrowser)
			If $selection >= 0 Then 
				$stream = _GUICtrlListBox_GetText($listBrowser,$selection)
				$path = StringLeft($browsefilepath,StringInstr($browsefilepath,"\","",-1))
				$file = GUICtrlRead($inputBrowsefile)
				OpenStream($path,$file,$stream)
			EndIf
		EndIf
	EndIf
	
	If $msg = $btnHideinfile Then 
		$output = FileOpenDialog("File to Hide in...",@WorkingDir,"(*.*)",1)
		If DriveGetFileSystem(StringLeft($output,3)) <> "NTFS" Then
			msgbox(0,"Non-NTFS Filesystem Detected","Sorry, only works on NTFS Filesystems")
		Else
			GUICtrlSetData($inputHideinfile,$output)
		EndIf
	EndIf
	
	If $msg = $GUI_EVENT_CLOSE or $msg = $exitbtn Then ExitLoop
	
WEnd

FileDelete(@TempDir & "\streams.exe")
#endregion


#region Functions
Func ClearGUI()
	GUICtrlSetData($inputFiletohide,"")
	GUICtrlSetData($inputHideinfile,"")
	GUICtrlSetData($inputHidenfilename,"")
	GUICtrlSetData($inputBrowsefile,"")
	_GUICtrlListBox_ResetContent($listBrowser)
	GUICtrlSetData($inputCleanfile,"")
EndFunc

Func CleanFile($filepath)
	RunWait(@comspec & " /c " & @tempdir & "\streams.exe -d " & chr(34) & $filepath & chr(34),"",@SW_HIDE)
EndFunc

Func HideFile($input,$output,$filetohide)
	$open = FileOpen($input, 16)
	$bin = Binary(FileRead($open))
	FileClose($open)
	FileWrite($output & ":" & $filetohide, $bin)
	;RunWait(@comspec & " /c type " & chr(34) & $input & chr(34) & " > " & chr(34) & $output & chr(34) & ":" & $filetohide,"",@SW_HIDE)
EndFunc

Func GetADStreams($filenamepath)
	RunWait(@comspec & " /c " & @tempdir & "\streams.exe " & chr(34) & $filenamepath & chr(34) & " > " & @Tempdir & "\streams.log","",@SW_HIDE)
	$streams = ""
	_FileReadToArray(@Tempdir & "\streams.log",$streams)
	FileDelete(@tempdir & "\streams.log")
	Return $streams
EndFunc

Func OpenStream($path,$file,$stream)
	Run(@comspec & " /c cd\" & chr(34) & $path & chr(34) & " & start .\" & chr(34) & $file & chr(34) & ":" & chr(34) & $stream & chr(34),"",@SW_HIDE)
	sleep(500)
	If WinExists("Open With") Then
		WinSetState("Open With","",@SW_SHOW)
	EndIf
EndFunc
#endregion
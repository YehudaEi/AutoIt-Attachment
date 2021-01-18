#cs ----------------------------------------------------------------------------
	
	AutoIt Version: 3.2.5.0 (beta)
	Author:         alien13
	
	Beta Testers: Bubba1982
	
	Script Function:
	NFOMaker - A basic NFOMaker for ******* users
	
#ce ----------------------------------------------------------------------------
#include <GUIConstants.au3>

Global $PreviewTab

$Main = GUICreate("NFOMaker 0.1 beta", 555, 395)
$Tab1 = GUICtrlCreateTab(0, 0, 557, 388)

$File = GUICtrlCreateMenu("File")
$Exit = GUICtrlCreateMenuItem("Exit", $File)
$Help = GUICtrlCreateMenu("Help")
$About = GUICtrlCreateMenuItem("About", $Help)

;Main Tab
GUICtrlCreateTabItem("Main")

$FNLabel = GUICtrlCreateLabel("File Name", 10, 60, 80, 20)
$FNInput = GUICtrlCreateInput("", 70, 60, 180, 20)
$BrowseDir = GUICtrlCreateButton("Dir", 260, 60, 40, 20)
$BrowseFile = GUICtrlCreateButton("File", 305, 60, 40, 20)

$FSLabel = GUICtrlCreateLabel("File Size", 10, 90, 80, 20)
$FSInput = GUICtrlCreateInput("", 70, 90, 180, 20)
$BrowseFS = GUICtrlCreateButton("Browse", 260, 90, 60, 20)

$TLabel = GUICtrlCreateLabel("Type", 10, 120, 80, 20)
$TList = GUICtrlCreateCombo("", 70, 120, 180, 20)
GUICtrlSetData($TList, "Application|Game|Movie|Music|Picture|Other(Specify)")

$OSLabel = GUICtrlCreateLabel("O.S", 10, 150, 80, 20)
$OSList = GUICtrlCreateCombo("", 70, 150, 180, 20)
GUICtrlSetData($OSList, "Windows|Linux|Mac")

$LLabel = GUICtrlCreateLabel("Link", 10, 180, 80, 20)
$LInput = GUICtrlCreateInput("", 70, 180, 180, 20)

$UNLabel = GUICtrlCreateLabel("Uploader", 10, 210, 80, 20)
$UNInput = GUICtrlCreateInput("", 70, 210, 180, 20)

$SaveNFO = GUICtrlCreateButton("Save NFO", 210, 325, 70, 25)
GUICtrlSetOnEvent($SaveNFO, "OKButton")
$GetPreview = GUICtrlCreateButton("Preview NFO", 280, 325, 70, 25)

$InputAuthor = GUICtrlCreateCheckbox("Add authors name to bottom of NFO?", 185, 355, 241, 17)
GUICtrlSetState(-1, $GUI_CHECKED)

;Description Tab
GUICtrlCreateTabItem("Description")

$DLabel = GUICtrlCreateLabel("Description", 250, 30)
$DEdit = GUICtrlCreateEdit("", 50, 50, 460, 150, $ES_AUTOVSCROLL + $ES_MULTILINE + $ES_WANTRETURN + $WS_VSCROLL)
$DLabel = GUICtrlCreateLabel("Install Notes", 250, 205)
$IEdit = GUICtrlCreateEdit("", 50, 220, 460, 150, $ES_AUTOVSCROLL + $ES_MULTILINE + $ES_WANTRETURN + $WS_VSCROLL)

;Movies Tab
GUICtrlCreateTabItem("Movies")
$MGLabel = GUICtrlCreateLabel("Genre", 10, 62, 80, 20); Movie Genre label
$MGList = GUICtrlCreateCombo("", 75, 60, 180, 20); Movie Genre Input
GUICtrlSetData($MGList, "Action|Adventure|Animation|Biography|Comedy|Crime|Documentary|Drama|Family|Fantasy|Film-Noir|Game-Show|History|" & _
	"Horror|Music|Musical|Mystery|News|Reality-TV|Romance|Short|Sport|Talk-Show|Thriller|War|Western|XXX|Other(Specify)");Movie Genre List

$MFLabel = GUICtrlCreateLabel("Format", 10, 92, 80, 20); Movie Format label
$MFList = GUICtrlCreateCombo("", 75, 90, 180, 20); Movie Format Input
GUICtrlSetData($MFList, "3GP|AVC|AVI|DivX|FLV|H.264|MP4|MPEG-1|MPEG-2|MPEG-4|WMV|XviD|Other(Specify)")

$VSLabel = GUICtrlCreateLabel("Standard", 10, 122, 80, 25); Video Standard label
$VSList = GUICtrlCreateCombo("", 75, 120, 180, 20); Video Standard Input
GUICtrlSetData($VSList, "PAL(Europe)|NTSC(US, Asia)")

$VRLabel = GUICtrlCreateLabel("Resolution", 10, 152, 80, 20)
$VRList = GUICtrlCreateCombo("", 75, 150, 180, 20)
GUICtrlSetData($VRList, "160x120|240x180|320x240|640x480|Other(Specify)")

$SrcLabel = GUICtrlCreateLabel("Source", 10, 182, 80, 20)
$SrcList = GUICtrlCreateCombo("", 75, 180, 180, 20)
GUICtrlSetData($SrcList, "DVD 4:3|DVD 16:9|VHS|Other(Specify)")

$ALabel = GUICtrlCreateLabel("Audio", 10, 212, 80, 20)
$AList = GUICtrlCreateCombo("", 75, 210, 180, 20)
GUICtrlSetData($AList, "Dolby Digital|DTS Audio|LINE|AC3|Other(Specify)")

$ABLabel = GUICtrlCreateLabel("Audio Bitrate", 10, 242, 80, 20)
$ABInput = GUICtrlCreateInput("", 75, 240, 180, 20)

$VbLabel = GUICtrlCreateLabel("Video Bitrate", 10, 272, 80, 20)
$VbInput = GUICtrlCreateInput("", 75, 270, 180, 20)

$LLabel = GUICtrlCreateLabel("Language", 10, 302, 80, 20)
$LInput = GUICtrlCreateInput("", 75, 300, 180, 20)

$RLabel = GUICtrlCreateLabel("Runtime", 10, 332, 80, 20)
$RInput = GUICtrlCreateInput("", 75, 330, 180, 20)

$SLabel = GUICtrlCreateLabel("Subtitles", 280, 62, 80, 20)
$SInput = GUICtrlCreateInput("", 345, 60, 180, 20)

$IMBDLabel = GUICtrlCreateLabel("IMDB Rating", 280, 92, 80, 20)
$IMDBInput = GUICtrlCreateInput("", 345, 90, 180, 20)

$ILLabel = GUICtrlCreateLabel("IMDB Link", 280, 122, 80, 20)
$ILInput = GUICtrlCreateInput("", 345, 120, 180, 20)

$OtherNotes = GUICtrlCreateLabel("Other Notes", 280, 152, 80, 20)
$ONInput = GUICtrlCreateEdit("", 345, 150, 180, 200, $ES_AUTOVSCROLL + $ES_MULTILINE + $ES_WANTRETURN + $WS_VSCROLL)

GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Exit
			MsgBox(64, "NFOMaker", "Thanks for using NFOMaker, " & @UserName & "!")
			ExitLoop
		Case $About
			About()
		Case $BrowseDir
			$FNSelection = FileSelectFolder("Select a folder to grab its name.", @HomeDrive)
			GUICtrlSetData($FNInput, $FNSelection)
			GUICtrlSetData($FSInput, DirGetSize($FNSelection) & " Bytes")
		Case $BrowseFile
			$FNSelection2 = FileOpenDialog("Select a file to grab its name.", @HomeDrive, "All Files (*.*)")
			GUICtrlSetData($FNInput, $FNSelection2)
			GUICtrlSetData($FSInput, FileGetSize($FNSelection2) & " Bytes")
		Case $BrowseFS
			$FSSelection = FileOpenDialog("Select a file to get the size.", @HomeDrive, "All Files (*.*)")
			$Size = FileGetSize($FSSelection)
			GUICtrlSetData($FSInput, $Size & " Bytes")
		Case $SaveNFO
			OKButton()
		Case $GetPreview
			Preview()
	EndSwitch
WEnd

Func OKButton()
	If Not IsDeclared("SaveNFO") Then Local $SaveNFO
	$SaveNFO = MsgBox(33, "NFOMaker", "NFOMaker will now save your NFO." & @CRLF & "Click OK to continue or Cancel if you would like to review your selections.")

	Switch $SaveNFO
		Case 1 ;OK
			$NFO = FileSaveDialog("Please choose where you would like to save the NFO file", @DesktopDir, "NFO files (*.nfo)")
			
			$output = "  File Name....................: " & GUICtrlRead($FNInput) & @CRLF
			If GuiCtrlRead($FSInput) <> "" Then $output &=	"  File Size....................: " & GUICtrlRead($FSInput) & @CRLF
			If GuiCtrlRead($TList) <> "" Then $output &=	"  Type.........................: " & GUICtrlRead($TList) & @CRLF
			If GuiCtrlRead($OSList) <> "" Then $output &=	"  O.S..........................: " & GUICtrlRead($OSList) & @CRLF
			If GuiCtrlRead($LInput) <> "" Then $output &=	"  Link.........................: " & GUICtrlRead($LInput) & @CRLF
			If GuiCtrlRead($UNInput) <> "" Then $output &=	"  Uploader.....................: " & GUICtrlRead($UNInput) & @CRLF & @CRLF
			$output &=	"Movie Info: " & @CRLF
			If GuiCtrlRead($MGList) <> "" Then $output &=	"  Genre........................: " & GUICtrlRead($MGList) & @CRLF
			If GuiCtrlRead($MFList) <> "" Then $output &=	"  Format.......................: " & GUICtrlRead($MFList) & @CRLF
			If GuiCtrlRead($VSList) <> "" Then $output &=	"  Standard.....................: " & GUICtrlRead($VSList) & @CRLF
			If GuiCtrlRead($RInput) <> "" Then $output &=	"  Resolution...................: " & GUICtrlRead($RInput) & @CRLF
			If GuiCtrlRead($SrcList) <> "" Then $output &=	"  Source.......................: " & GUICtrlRead($SrcList) & @CRLF
			If GuiCtrlRead($AList) <> "" Then $output &=	"  Audio........................: " & GUICtrlRead($AList) & @CRLF
			If GuiCtrlRead($ABInput) <> "" Then $output &=	"  Audio Bitrate................: " & GUICtrlRead($ABInput) & @CRLF
			If GuiCtrlRead($VbInput) <> "" Then $output &=	"  Video Bitrate................: " & GUICtrlRead($VbInput) & @CRLF
			If GuiCtrlRead($LInput) <> "" Then $output &=	"  Language.....................: " & GUICtrlRead($LInput) & @CRLF
			If GuiCtrlRead($RInput) <> "" Then $output &=	"  Runtime......................: " & GUICtrlRead($RInput) & @CRLF
			If GuiCtrlRead($SInput) <> "" Then $output &=	"  Subtitles....................: " & GUICtrlRead($SInput) & @CRLF
			If GuiCtrlRead($IMDBInput) <> "" Then $output &=	"  IMDB Rating..................: " & GUICtrlRead($IMDBInput) & @CRLF
			If GuiCtrlRead($ILInput) <> "" Then $output &=	"  IMDB Link....................: " & GUICtrlRead($ILInput) & @CRLF
			If GuiCtrlRead($ONInput) <> "" Then $output &=	"Other Notes: " & GUICtrlRead($ONInput) & @CRLF & @CRLF
			If GuiCtrlRead($DEdit) <> "" Then $output &=	"Description:" & @CRLF & GUICtrlRead($DEdit) & @CRLF
			If GuiCtrlRead($IEdit) <> "" Then $output &=	"Install Notes:" & @CRLF & GUICtrlRead($IEdit)
					
			;Append author information			
			If GUICtrlRead($InputAuthor) = 1 Then
				$output &= @CRLF & @CRLF & @CRLF & "Made with NFOMaker" & @CRLF & "By alien13"
			EndIf
			FileWrite($NFO & ".nfo", $output)
			
			MsgBox(64, "NFOMaker", "Finished!" & @CRLF & "NFOMaker will now restart")
			Run(@ScriptDir & "\NFOMaker.exe")
			Exit
		Case 2 ;Cancel
	EndSwitch
EndFunc   ;==>OKButton

Func Preview()
	GUICtrlDelete($PreviewTab)
	If Not IsDeclared("GetPrev") Then Local $GetPrev
	$GetPrev = MsgBox(33, "NFOMaker", "NFOMaker will now generate a preview of what your NFO will look like." & @CRLF & "It is best that you fill in all needed fields before continuing." & @CRLF & _
	"(Note: The authors name will show even if you selected not to. It will not affect the final copy)")
	Switch $GetPrev
		Case 1 ;OK
			$PreviewTab = GUICtrlCreateTabItem("Preview")
			GUISetFont("8.5", "", "", "Courier New")
			
			$output = "  File Name....................: " & GUICtrlRead($FNInput) & @CRLF
			If GuiCtrlRead($FSInput) <> "" Then $output &=	"  File Size....................: " & GUICtrlRead($FSInput) & @CRLF
			If GuiCtrlRead($TList) <> "" Then $output &=	"  Type.........................: " & GUICtrlRead($TList) & @CRLF
			If GuiCtrlRead($OSList) <> "" Then $output &=	"  O.S..........................: " & GUICtrlRead($OSList) & @CRLF
			If GuiCtrlRead($LInput) <> "" Then $output &=	"  Link.........................: " & GUICtrlRead($LInput) & @CRLF
			If GuiCtrlRead($UNInput) <> "" Then $output &=	"  Uploader.....................: " & GUICtrlRead($UNInput) & @CRLF & @CRLF
			$output &=	"Movie Info: " & @CRLF
			If GuiCtrlRead($MGList) <> "" Then $output &=	"  Genre........................: " & GUICtrlRead($MGList) & @CRLF
			If GuiCtrlRead($MFList) <> "" Then $output &=	"  Format.......................: " & GUICtrlRead($MFList) & @CRLF
			If GuiCtrlRead($VSList) <> "" Then $output &=	"  Standard.....................: " & GUICtrlRead($VSList) & @CRLF
			If GuiCtrlRead($RInput) <> "" Then $output &=	"  Resolution...................: " & GUICtrlRead($RInput) & @CRLF
			If GuiCtrlRead($SrcList) <> "" Then $output &=	"  Source.......................: " & GUICtrlRead($SrcList) & @CRLF
			If GuiCtrlRead($AList) <> "" Then $output &=	"  Audio........................: " & GUICtrlRead($AList) & @CRLF
			If GuiCtrlRead($ABInput) <> "" Then $output &=	"  Audio Bitrate................: " & GUICtrlRead($ABInput) & @CRLF
			If GuiCtrlRead($VbInput) <> "" Then $output &=	"  Video Bitrate................: " & GUICtrlRead($VbInput) & @CRLF
			If GuiCtrlRead($LInput) <> "" Then $output &=	"  Language.....................: " & GUICtrlRead($LInput) & @CRLF
			If GuiCtrlRead($RInput) <> "" Then $output &=	"  Runtime......................: " & GUICtrlRead($RInput) & @CRLF
			If GuiCtrlRead($SInput) <> "" Then $output &=	"  Subtitles....................: " & GUICtrlRead($SInput) & @CRLF
			If GuiCtrlRead($IMDBInput) <> "" Then $output &=	"  IMDB Rating..................: " & GUICtrlRead($IMDBInput) & @CRLF
			If GuiCtrlRead($ILInput) <> "" Then $output &=	"  IMDB Link....................: " & GUICtrlRead($ILInput) & @CRLF
			If GuiCtrlRead($ONInput) <> "" Then $output &=	"Other Notes: " & GUICtrlRead($ONInput) & @CRLF & @CRLF
			If GuiCtrlRead($DEdit) <> "" Then $output &=	"Description:" & @CRLF & GUICtrlRead($DEdit) & @CRLF
			If GuiCtrlRead($IEdit) <> "" Then $output &=	"Install Notes:" & @CRLF & GUICtrlRead($IEdit)
			
			$Preview = GUICtrlCreateEdit( $output, 10, 30, 535, 340, $ES_AUTOVSCROLL + $ES_MULTILINE + $ES_WANTRETURN + $WS_VSCROLL)
		Case 2 ;Cancel
	EndSwitch
EndFunc   ;==>Preview

Func About()
	GUISetState(@SW_HIDE, $Main)
	$AboutWindow = GUICreate("About", 441, 290)

	;$ProgramLogo = GUICtrlCreatePic(@ScriptDir & $Images & "\Logo.gif", 5, 15, 131, 259)
	$ProgramName = GUICtrlCreateLabel("NFOMaker", 143, 26)
	$ProgramVersion = GUICtrlCreateLabel("Version 0.1 Beta - Build (0750)", 143, 52)
	$ProgramCopyright = GUICtrlCreateLabel("Copyright © 2007 alien13 All Rights reserved.", 143, 78)
	$ProgramAuthor = GUICtrlCreateLabel("alien13 ", 143, 104)
	$ProgramDescription = GUICtrlCreateEdit("NFOMaker - Your simple NFO Maker." & @CRLF & @CRLF & "I would like to thank the following people for their help with NFOMaker:" & _
			@CRLF & @CRLF & "Bubba1982 - Beta Tester", 143, 130, 271, 126, BitOR($ES_READONLY, $ES_WANTRETURN))

	GUISetState(@SW_SHOW)
	While 2
		$msg2 = GUIGetMsg()
		Select
			Case $msg2 = $GUI_EVENT_CLOSE
				ExitLoop
		EndSelect
	WEnd
	GUIDelete($AboutWindow)
	GUISetState(@SW_SHOW, $Main)
EndFunc   ;==>About
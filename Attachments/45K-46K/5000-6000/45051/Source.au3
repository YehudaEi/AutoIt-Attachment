#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Data\Images\WatcherIcon.ico
#AutoIt3Wrapper_Compression=0
#AutoIt3Wrapper_Res_Fileversion=1.2.0.0
#AutoIt3Wrapper_Res_LegalCopyright=R.S.S.
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#AutoIt3Wrapper_Add_Constants=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;~ #AutoIt3Wrapper_Icon=Data/Images\WatcherIcon.ico

#include <GUIConstantsEx.au3>
#include <ListViewConstants.au3>
#include <GuiListView.au3>

#include ".\Skins\Cosmo.au3"
#include "_UskinLibrary.au3"

_Uskin_LoadDLL()
_USkin_Init(_Cosmo(True))

Opt("GUIOnEventMode", 1)
Opt("TrayMenuMode", 3)
Opt("TrayOnEventMode", 1)


$RefreshItem = TrayCreateItem("Refresh..")
TrayItemSetOnEvent(-1, "_Refresh")
$ShowItem = TrayCreateItem("Show Topic Watcher..")
TrayItemSetOnEvent(-1, "_CreateGui")
$HelpItem = TrayCreateItem("Help..")
TrayItemSetOnEvent(-1, "_Help")
$ExitItem = TrayCreateItem("Exit..")
TrayItemSetOnEvent(-1, "_Exit")

Global $PostCount, $String, $Count = 0, $PageCount = 1, $NextPage, $Url, $NewTime, $Checked = 0, $CurrentCount
Global $NewStyle, $Timer, $TimeInterval, $SetCount = 1, $NumberOfSets = 0, $Done = 0, $TopicsList, $NewTopicURL, $NewName
Global $TopicsGui, $FoundTopicNumber, $GuiState = 0

Dim $TopicListing[4000], $TopicsInfo[4000][4000], $TopicListing2[4000], $TopicsInfo2[4000][4000], $NewPost[4000], $CheckNumberOfTopics[4000]


$Info = IniReadSection(@ScriptDir & "/Data/Info.ini", "1")


Func _CreateGui()
	$GuiState = 1
	$CurrentGui = "Topics"
	$TopicsGui = GUICreate("Topic Watcher", 660, 400)
;~ 	GUISetOnEvent($GUI_EVENT_CLOSE, "_CloseGui")
	GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")
	$TopicsList = GUICtrlCreateListView("Topics", 10, 20, 300, 360, $LVS_LIST)
	$Topics = IniReadSectionNames(@ScriptDir & "\Data\Info.ini")
	If @error Then
		Sleep(10)
	Else
		For $i = 1 To $Topics[0]
			$Info = IniReadSection(@ScriptDir & "/Data/Info.ini", $i)
			If $Info[10][1] = 1 Then
				$TopicListing[$i] = GUICtrlCreateListViewItem($Info[9][1], $TopicsList)
			Else
				Sleep(10)
			EndIf
		Next
	EndIf
	$AddNewTopicButton = GUICtrlCreateButton("New Topic", 320, 20, 160, 40)
	GUICtrlSetOnEvent(-1, "_AddNewTopic")
	GUICtrlSetFont(-1, 12)
	$RemoveTopicButton = GUICtrlCreateButton("Remove Topic", 490, 20, 160, 40)
	GUICtrlSetOnEvent(-1, "_RemoveTopic")
	GUICtrlSetFont(-1, 12)
	$ViewTopicButton = GUICtrlCreateButton("View Topic", 320, 150, 160, 40)
	GUICtrlSetOnEvent(-1, "_ViewTopic")
	GUICtrlSetFont(-1, 12)
	$RefreshButton = GUICtrlCreateButton("Refresh", 410, 350, 160, 40)
	GUICtrlSetOnEvent(-1, "_Refresh")
	GUICtrlSetFont(-1, 12)
	$TimeChangeButton = GUICtrlCreateButton("Change Time Interval", 320, 280, 160, 40)
	GUICtrlSetOnEvent(-1, "_ChangeTimeInterval")
	GUICtrlSetFont(-1, 12)
	$ChangeRefreshStyleButton = GUICtrlCreateButton("Change Refresh Style", 490, 280, 160, 40)
	GUICtrlSetOnEvent(-1, "_RefreshStyle")
	GUICtrlSetFont(-1, 12)
	$ChangeSoundButton = GUICtrlCreateButton("Play Sound", 490, 150, 160, 40)
	GUICtrlSetOnEvent(-1, "_Sound")
	GUICtrlSetFont(-1, 12)
	GuiCtrlCreateLabel("Version 1.2", 605, 388)
	GuiCtrlSetFont(-1, 8)
	GUISetState()
EndFunc   ;==>_CreateGui

Func _ViewTopic()
		$Index = ControlListView($TopicsGui, "Topic Watcher", $TopicsList, "GetSelected")
	$ReadControl = _GUICtrlListView_GetItemText($TopicsList, 0 + $Index)
	$TopicNames = IniReadSectionNames(@ScriptDir & "/Data/Info.ini")
	For $i = 1 To $TopicNames[0]
		$TopicInfo = IniReadSection(@ScriptDir & "/Data/Info.ini", $i)
		If $TopicInfo[9][1] = $ReadControl Then
;~ 			MsgBox(0, "Test", $TopicInfo[1][1])
			ShellExecute($TopicInfo[1][1])
		EndIf
	Next
EndFunc

Func _AddNewTopic()
	$TopicCount = IniReadSectionNames(@ScriptDir & "/Data/Info.ini")
	$NewTopicNumber = $TopicCount[0] + 1
	While $Done = 0
		$NewTopicURL = InputBox("URL", "Please input the URL of the FIRST page of the topic.")
		$NewName = InputBox("Label", "Please input a label or name you would like to give the topic.")
		If $NewTopicURL > "" Then
			For $i = 1 To $TopicCount[0]
				$TopicCheck = IniRead(@ScriptDir & "/Data/Info.ini", $i, "URL", "NotFound")
				If $TopicCheck = $NewTopicURL Then
					$FoundTopicNumber = $i
					$Done = 1
					$NewName = ""
					_AlreadyInFile()
				EndIf
			Next
			If $NewName > "" Then
				IniWrite(@ScriptDir & "/Data/Info.ini", $NewTopicNumber, "URL", $NewTopicURL)
				IniWrite(@ScriptDir & "/Data/Info.ini", $NewTopicNumber, "CurrentCount", 0)
				IniWrite(@ScriptDir & "/Data/Info.ini", $NewTopicNumber, "Sound", 0)
				IniWrite(@ScriptDir & "/Data/Info.ini", $NewTopicNumber, "SoundFile", "")
				IniWrite(@ScriptDir & "/Data/Info.ini", $NewTopicNumber, "RefreshStyle", 2)
				If StringInStr($NewTopicURL, "teamfortress.tv") Then
					IniWrite(@ScriptDir & "/Data/Info.ini", $NewTopicNumber, "PostStructure1", '<span class="post-num">#')
					IniWrite(@ScriptDir & "/Data/Info.ini", $NewTopicNumber, "PostStructure2", '</span>')
					IniWrite(@ScriptDir & "/Data/Info.ini", $NewTopicNumber, "PageStructure", '/?page=')
				ElseIf StringInStr($NewTopicURL, "autoitscript") Then
					IniWrite(@ScriptDir & "/Data/Info.ini", $NewTopicNumber, "PostStructure1", 'post #')
					IniWrite(@ScriptDir & "/Data/Info.ini", $NewTopicNumber, "PostStructure2", "'")
					IniWrite(@ScriptDir & "/Data/Info.ini", $NewTopicNumber, "PageStructure", '/page-')
				EndIf
				IniWrite(@ScriptDir & "/Data/Info.ini", $NewTopicNumber, "Name", $NewName)
				IniWrite(@ScriptDir & "/Data/Info.ini", $NewTopicNumber, "Status", 1)
				$Done = 1
			EndIf
		EndIf
		If $Done = 0 Then
			MsgBox(64, "Cancel", "No new topic added.")
			$Done = 1
		EndIf
	WEnd
	$Done = 0
	_GUICtrlListView_DeleteAllItems($TopicsList)
	$Topics = IniReadSectionNames(@ScriptDir & "\Data\Info.ini")
	If @error Then
		Sleep(10)
	Else
		For $i = 1 To $Topics[0]
			$Info = IniReadSection(@ScriptDir & "/Data/Info.ini", $i)
			If $Info[10][1] = 1 Then
				$TopicListing[$i] = GUICtrlCreateListViewItem($Info[9][1], $TopicsList)
			Else
				Sleep(10)
			EndIf
		Next
	EndIf
EndFunc   ;==>_AddNewTopic

Func _AlreadyInFile()
	MsgBox(64, "Found!", "This URL has been used previously. Your old sites are still in the config file.")
	$CheckChange = MsgBox(4, "Activate", "Do you wish to activate this URL again?")
	If $CheckChange = 6 Then
		IniWrite(@ScriptDir & "/Data/Info.ini", $FoundTopicNumber, "Status", 1)
		_GUICtrlListView_DeleteAllItems($TopicsList)
		$Topics = IniReadSectionNames(@ScriptDir & "\Data\Info.ini")
		If @error Then
			Sleep(10)
		Else
			For $i = 1 To $Topics[0]
				$Info = IniReadSection(@ScriptDir & "/Data/Info.ini", $i)
				If $Info[10][1] = 1 Then
					$TopicListing[$i] = GUICtrlCreateListViewItem($Info[9][1], $TopicsList)
				Else
					Sleep(10)
				EndIf
			Next
		EndIf
	Else
		Sleep(10)
	EndIf
EndFunc   ;==>_AlreadyInFile

Func _RemoveTopic()
	$Index = ControlListView($TopicsGui, "Topic Watcher", $TopicsList, "GetSelected")
	If $Index = 0 Then
		MsgBox(48, "Error", "You cannot remove this topic. This must remain for the functionality of the program, sorry!")
	Else
		$ReadControl = _GUICtrlListView_GetItemText($TopicsList, 0 + $Index)
		$TopicNames = IniReadSectionNames(@ScriptDir & "/Data/Info.ini")
		For $i = 1 To $TopicNames[0]
			$TopicInfo = IniReadSection(@ScriptDir & "/Data/Info.ini", $i)
			If $TopicInfo[9][1] = $ReadControl Then
				$TopicFound = 1
				$CheckRemove = MsgBox(4, "Remove Topic", "Are you sure you wish to remove " & $ReadControl & "?")
				If $CheckRemove = 6 Then
					IniWrite(@ScriptDir & "/Data/Info.ini", $i, "Status", "0")
					_GUICtrlListView_DeleteAllItems($TopicsList)
					$Topics = IniReadSectionNames(@ScriptDir & "\Data\Info.ini")
					If @error Then
						Sleep(10)
					Else
						For $i = 1 To $Topics[0]
							$Info = IniReadSection(@ScriptDir & "/Data/Info.ini", $i)
							If $Info[10][1] = 1 Then
								$TopicListing[$i] = GUICtrlCreateListViewItem($Info[9][1], $TopicsList)
							Else
								Sleep(10)
							EndIf
						Next
					EndIf
				EndIf
			EndIf
		Next
		If $TopicFound = 0 Then
			MsgBox(48, "Error", "Topic not found.. something is wrong in the topics config file. If this topic isn't updating please contact me at Tf2Prophete@gmail.com")
		Else
			$TopicFound = 0
		EndIf
	EndIf
EndFunc   ;==>_RemoveTopic


Func _ChangeTopic()
	$CheckNewTopic = MsgBox(4, "New Topic", "Are you sure you wish to register a new topic to watch?")
	If $CheckNewTopic = 6 Then
		$NewTopicURL = InputBox("New Topic", "When entering a new topic start at the first page. IE; If there are multiple pages for the topic always copy the URL from the first page (opening post)." & @CRLF & "The program will do the rest")
		IniWrite(@ScriptDir & "/Data/Info.ini", "1", "URL", $NewTopicURL)
		IniWrite(@ScriptDir & "/Data/Info.ini", "1", "CurrentCount", "0")
		MsgBox(0, "Information", "Please note that your current count for post will be set to 0 so when the program reads the topic it will automatically find 'New Post' even though there may not be, it just needs a starting point.")
	Else
		Sleep(10)
	EndIf
EndFunc   ;==>_ChangeTopic

Func _Sound()
	$Index = ControlListView($TopicsGui, "Topic Watcher", $TopicsList, "GetSelected")
	$ReadControl = _GUICtrlListView_GetItemText($TopicsList, 0 + $Index)
	$TopicNames = IniReadSectionNames(@ScriptDir & "/Data/Info.ini")
	For $i = 1 To $TopicNames[0]
		$TopicInfo = IniReadSection(@ScriptDir & "/Data/Info.ini", $i)
		If $TopicInfo[9][1] = $ReadControl Then
			$CheckSoundOptions = MsgBox(4, "Sounds", "Do you wish to play a sound when a new post is found?")
			If $CheckSoundOptions = 6 Then
				IniWrite(@ScriptDir & "/Data/Info.ini", $i, "Sound", "1")
				$NewSound = FileOpenDialog("Sound file..", @DesktopDir, "All (*.*)")
				IniWrite(@ScriptDir & "/Data/Info.ini", $i, "SoundFile", $NewSound)
				MsgBox(0, "Sounds", "Sound selection complete!")
			EndIf
		EndIf
	Next
EndFunc   ;==>_Sound

Func _RefreshStyle()
	$CheckRefreshStyle = MsgBox(4, "Refresh..", "Do you wish to change the behavior of the refresh style?")
	If $CheckRefreshStyle = 6 Then
		While $NewStyle = ""
			$NewStyle = InputBox("Refresh Style", "Please input a 1 or 2." & @CRLF & "1 is automatic refresh using a desired timer from 'Change Time Interval..' in the options menu." & @CRLF & "2 is a manual refresh where you must press 'Refresh' from the tray icon.")
			If $NewStyle = 1 Then
				IniWrite(@ScriptDir & "/Data/Info.ini", "1", "RefreshStyle", "1")
			ElseIf $NewStyle = 2 Then
				IniWrite(@ScriptDir & "/Data/Info.ini", "1", "RefreshStyle", "2")
				MsgBox(16, "Warning", "Please note, if you have changed to a manual style after already using a timer the timer may still be active for one more cycle and may initiate a check once more.")
			Else
				$NewStyle = ""
			EndIf
		WEnd
	Else
		Sleep(10)
	EndIf
	$Info = IniReadSection(@ScriptDir & "/Data/Info.ini", "1")
EndFunc   ;==>_RefreshStyle

Func _ChangeTimeInterval()
	$CheckChange = MsgBox(4, "Change Time Interval..", "Are you sure you wish to change the time interval?")
	If $CheckChange = 6 Then
		$NewTime = InputBox("New Time Interval..", "Please input a new time interval in a range of 1-60. 1 being ONE MINUTE. 60 being ONE HOUR.")
		$CheckTime = StringIsAlNum($NewTime)
		If $CheckTime = 0 Then
			MsgBox(48, "Error", "Time contains something other than a number. No periods, dashes or backslashes allowed. Only numbers 1-60.")
			$NewTime = ""
		EndIf
		If $NewTime < 1 Then
			MsgBox(48, "Error", "Time is less than one minute, please enter in a new time!")
			$NewTime = ""
		ElseIf $NewTime > 60 Then
			MsgBox(48, "Error", "Time is greater than one hour, please enter in a new time!")
			$NewTime = ""
		EndIf
		If $NewTime > "" Then
			$NewTime2 = $NewTime * 1000
			$NewTime3 = $NewTime2 * 60
			$Timer = TimerInit()
			$TimeInterval = $NewTime3
		EndIf
	Else
		Sleep(10)
	EndIf
EndFunc   ;==>_ChangeTimeInterval

Func _Refresh()
	$Checked = 0
	If $NumberOfSets = 0 Then
		$CheckNumberOfTopics = IniReadSectionNames(@ScriptDir & "/Data/Info.ini")
		$NumberOfSets = $CheckNumberOfTopics[0]
	EndIf
	$Info = IniReadSection(@ScriptDir & "/Data/Info.ini", $SetCount)
	$Url = $Info[1][1]
	$CurrentCount = $Info[2][1]
	Global $sSource = BinaryToString(InetRead($Url))
	If StringInStr($Url, "teamfortress.tv") Then
		$PostCount = StringRegExp($sSource, '(?is)' & $Info[6][1] & '(.*?)' & $Info[7][1], 3)
	ElseIf StringInStr($Url, "autoitscript") Then
		$PostCount = StringRegExp($sSource, "(?is)" & $Info[6][1] & "(.*?)" & $Info[7][1], 3)
	EndIf
	_CheckMax()
EndFunc   ;==>_Refresh

Func _CheckMax()
	If $NumberOfSets > 0 Then
		For $i = 0 To UBound($PostCount) - 1
			$Count = $PostCount[$i]
			If $Count >= 30 Then
				$NextPage = 1
			Else
				$NextPage = 0
			EndIf
		Next
		If $NextPage = 1 Then
			_NextPage()
		Else
			$Checked = 1
			_Finished()
		EndIf
	Else
		Sleep(10)
	EndIf
EndFunc   ;==>_CheckMax

Func _NextPage()
	$PageCount += 1
	$NextPage = 0
	Global $sSource = BinaryToString(InetRead($Url & $Info[8][1] & $PageCount))
	$PostCount = StringRegExp($sSource, '(?is)' & $Info[6][1] & '(.*?)' & $Info[7][1], 3)
	_CheckMax()
EndFunc   ;==>_NextPage

Func _Finished()
	If $Checked = 1 Then
		If $Count > $CurrentCount Then
			_NewPost()
		Else
			Sleep(10)
		EndIf
		$Count = 0
		$NextPage = 0
		$PageCount = 0
	EndIf
	If $NumberOfSets > 1 Then
		$SetCount += 1
		$NumberOfSets -= 1
		_Refresh()
	Else
		$SetCount = 1
		$NumberOfSets = 0
	EndIf
EndFunc   ;==>_Finished

Func _NewPost()
	IniWrite(@ScriptDir & "/Data/Info.ini", $SetCount, "CurrentCount", $Count)
	If $Info[3][1] = 1 Then
		SoundPlay($Info[4][1], 1)
	Else
		MsgBox(0, "New Post", $Info[9][1] & @CRLF & @CRLF & "New Post Found!")
	EndIf
EndFunc   ;==>_NewPost

Func _Help()
	MsgBox(0, "General Help", "If the program is not working as intended a few simple things could be wrong.")
	MsgBox(0, "General Help 1", "First, check and verify you have the correct URL. Simply select 'Change Topic' in the tray menu and go through the process.")
	MsgBox(0, "General Help 2", "If you are sure you have the URL correct please email me at Tf2Prophete@Gmail.com")
EndFunc   ;==>_Help


Func _Exit()
	If $GuiState = 1 Then
		GUIDelete($TopicsGui)
		$GuiState = 0
	Else
		Exit
	EndIf
EndFunc   ;==>_Exit

While 1
	If $Info[5][1] = 1 Then
		If TimerDiff($Timer) > $TimeInterval Then
			$NewTime2 = $NewTime * 1000
			$NewTime3 = $NewTime2 * 60
			$Timer = TimerInit()
			$TimeInterval = $NewTime3
			_Refresh()
		EndIf
	Else
		Sleep(10)
	EndIf
	Sleep(10)
WEnd



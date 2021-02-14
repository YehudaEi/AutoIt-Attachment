#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <IE.au3>
#Include <StaticConstants.au3>

Global $Count, $EpisodeLabel, $Result, $Info, $InfoBox, $Description, $var2, $CurrentSelection2, $NewSelection2, $PlayEpisode, $GUIWINDOW, $PanTask, $PanGUI, $CreateWindow, $NewSelection, $Msg, $OptionsMenu, $RandomItem, $SelectionItem, $SelectionMenu, $hLabel, $CurrentSelection, $Selection, $NamesAndLinksFile, $Var, $EpisodeNames, $EpisodeNameForList, $CurrentSelection

$EpisodeNames = "EpisodeNames.txt"

$var = IniReadSection("Names.ini", "Links and Names")
    For $i = 1 To $var[0][0]
		FileWriteLine($EpisodeNames, $var[$i][1] & "|")
    Next
	
	$EpisodeNameForList = FileRead($EpisodeNames)

    GUICreate("Paws & Tales")
	$OptionsMenu = GuiCtrlCreateMenu("Options")
	$RandomItem = GuiCtrlCreateMenuItem("Random", $OptionsMenu)
	$SelectionItem = GuiCtrlCreateMenuItem("Self-Choose", $OptionsMenu)
	$SelectionMenu = GuiCtrlCreateCombo("Episode List", 100,40)
	GUICtrlSetState($SelectionMenu, $GUI_HIDE)
	GuiCtrlSetData(-1, $EpisodeNameForList)
	$PlayEpisode = GuiCtrlCreateButton("Play Episode", 160, 70)
	GUICtrlSetState($PlayEpisode, $GUI_HIDE)
	$PlayEpisode2 = GuiCtrlCreateButton("Play Episode", 160, 70)
	GUICtrlSetState($PlayEpisode2, $GUI_HIDE)
	$hLabel = GuiCtrlCreateLabel("Please make a selection",130,10)
	$InfoBox = GuiCtrlCreateEdit(" ", 0, 120, 400, 200, $ES_AUTOVSCROLL)
	$InfoBox2 = GuiCtrlCreateEdit(" ", 0, 120, 400, 200, $ES_AUTOVSCROLL)
	$EpisodeLabel = GuiCtrlCreateLabel(" ", 120, 50, 300)
	GuiCtrlSetState($InfoBox, $GUI_HIDE)
	GuiCtrlSetState($InfoBox2, $GUI_HIDE)
	
	$CurrentSelection = ""
	Sleep(1000)
	GuiSetState(@SW_SHOW)


While 1
	Switch GuiGetMSG()
	Case $GUI_EVENT_CLOSE
		Exit
		Case $RandomItem
			$Selection = 1
		Case $SelectionItem
			$Selection = 2
		Case $PlayEpisode
			$CurrentSelection = GUICtrlRead($SelectionMenu)
			$NewSelection = StringStripWS($CurrentSelection, 3)
			$var = IniReadSection("Names.ini", "Links and Names")
    For $i = 1 To $var[0][0]
		If $NewSelection = $Var[$i][1] Then
			GUISETSTATE(@SW_HIDE)
			$PanTask = _IECreateEmbedded()
			GUICreate($NewSelection, 400, 60)
			$PanGUI = GUICtrlCreateObj($PanTask,-220,-400,1024,1024)
			GUISetState()
			$CreateWindow = _IENavigate ($PanTask, $Var[$i][0], 0)
		EndIf
    Next
		Case $PlayEpisode2
			$CurrentSelection = GUICtrlRead($CurrentSelection2)
			$NewSelection = StringStripWS($CurrentSelection2, 3)
			$var = IniReadSection("Names.ini", "Links and Names")
    For $i = 1 To $var[0][0]
		If $NewSelection = $Var[$i][1] Then
			GUISETSTATE(@SW_HIDE)
			$PanTask = _IECreateEmbedded()
			GUICreate($NewSelection, 400, 60)
			$PanGUI = GUICtrlCreateObj($PanTask,-220,-400,1024,1024)
			GUISetState()
			$CreateWindow = _IENavigate ($PanTask, $Var[$i][0], 0)
		EndIf
    Next
Case $SelectionMenu
		$CurrentSelection2 = GUICtrlRead($SelectionMenu)
	$NewSelection2 = StringStripWS($CurrentSelection2, 1)
	$var2 = IniReadSection("Desc.ini", "Info")
	For $i = 1 To $var2[0][0]
		If $NewSelection2 = $Var2[$i][0] Then
GuiCtrlSetData($InfoBox, $var2[$i][1])
		EndIf
    Next
		EndSwitch
		
		
		If $Selection = 1 Then
			$file = FileOpen("EpisodeNames.txt", 0)

			While 1
			$Episode = FileReadLine($File)
			If @Error = -1 Then ExitLoop
			$Count += 1
			WENd

			$RandomNumber = Round(Random(1, $Count))

			$Episode = FileReadLine($File, $RandomNumber)
			$NewEpisode = StringReplace($Episode, "|", " ")
			GuiCtrlSetData($EpisodeLabel, "Episode: " & $NewEpisode)
			GuiCtrlSetState($hLabel, $GUI_HIDE)
			GuiCtrlSetState($SelectionMenu, $GUI_HIDE)
			GuiCtrlSetState($PlayEpisode, $GUI_HIDE)
			GuiCtrlSetState($InfoBox, $GUI_HIDE)
			GuiCtrlSetState($PlayEpisode2, $GUI_SHOW)
			GuiCtrlSetState($InfoBox2, $GUI_SHOW)
	$CurrentSelection2 = $NewEpisode
	$NewSelection2 = StringStripWS($CurrentSelection2, 3)
	$var2 = IniReadSection("Desc.ini", "Info")
	For $i = 1 To $var2[0][0]
		If $NewSelection2 = $Var2[$i][0] Then
GuiCtrlSetData($InfoBox2, $var2[$i][1])
		EndIf
    Next
			$Count = 0
			$Selection = 3
		EndIf
		
		If $Selection = 2 Then
			GuiCtrlSetData($EpisodeLabel, " ")
			GuiCtrlSetState($hLabel, $GUI_HIDE)
			GuiCtrlSetState($SelectionMenu, $GUI_SHOW)
			GuiCtrlSetState($PlayEpisode, $GUI_SHOW)
			GuiCtrlSetState($InfoBox, $GUI_SHOW)
			GuiCtrlSetState($PlayEpisode2, $GUI_HIDE)
			GuiCtrlSetState($InfoBox2, $GUI_HIDE)
			$Selection = 3
			EndIf
		WEnd
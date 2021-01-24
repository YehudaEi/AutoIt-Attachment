

#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <IE.au3>

Opt("TrayMenuMode",1)   ; Default tray menu items will not be shown.

$MenuExit = TrayCreateItem("Exit")

$Broswertouse = FileReadLine("Data.Broswer",1)
$Lastsearch = ""
$Searchtext = ""
$SearchProvider = FileReadLine("Data.SearchProvider",1)
$DefaultSearchProvider = FileReadLine("Data.DefaultSearchProvider",1)
$Version = "beta version"
_IEErrorHandlerRegister ()

$oIE = _IECreateEmbedded ()
TrayTip("Search-It " & $Version, $version, 500, 1)
Main()

Func Main()

$Lastsearch = FileReadLine("Data.Lastsearch",1)
$MainGUI = GUICreate("Search-It", 520, 29)
$Searchtext = GUICtrlCreateInput($Lastsearch, 160, 4, 121, 21)
$Search = GUICtrlCreateButton("Search", 296, 4, 75, 21, 0)
$SearchProvider = GUICtrlCreateCombo("Please select a provider", 8, 4, 145, 21)
GUICtrlSetData(-1, "Google|Yahoo|Ask|Wiki")
$Options = GUICtrlCreateButton("Options", 377, 4, 79, 21, 0)
$Bughelp = GUICtrlCreateButton("Bug help", 460, 4, 55, 21, 0)
GUISetState(@SW_SHOW)
If $DefaultSearchProvider = "Google" Then 
	GUICtrlSetData($SearchProvider, "Google")
EndIf
If $DefaultSearchProvider = "Yahoo" Then 
	GUICtrlSetData($SearchProvider, "Yahoo")
EndIf
If $DefaultSearchProvider = "Ask" Then 
	GUICtrlSetData($SearchProvider, "Ask")
EndIf
If $DefaultSearchProvider = "Wiki" Then 
	GUICtrlSetData($SearchProvider, "Wiki")
EndIf

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Search
			TrayTip("Search-It Tip!","To make searching easier and quicker go into options and set a default provider",  500, 1)
			FileDelete("Data.Lastsearch")
			FileWrite("Data.Lastsearch", GUICtrlRead($Searchtext))
			
			FileDelete("Data.SearchProvider")
			FileWrite("Data.SearchProvider", GUICtrlRead($SearchProvider))
			If FileReadLine("Data.SearchProvider") = "Please select a provider" Then
			MsgBox(16,"Search-It","Please select a search provider before searching!")
			main()
		Else
			If $Broswertouse = "Internet Explorer" then
			If FileReadLine("Data.SearchProvider") = "Google" Then
			_IECreate("http://www.google.co.uk/search?hl=en&q=" & GUICtrlRead($Searchtext) &"&btnG=Search&meta=")
			EndIf
		
			If FileReadLine("Data.SearchProvider") = "Yahoo" Then
			_IECreate("                                 ;_ylt=A1f4cfb_pJFJWcAAn15LBQx.?p=" & GUICtrlRead($Searchtext) &"&y=Search&fr=yfp-t-501&rd=r1")
			EndIf

			If FileReadLine("Data.SearchProvider") = "Ask" Then
			_IECreate("                                         " & GUICtrlRead($Searchtext) &"&dm=all")
			EndIf
		
			If FileReadLine("Data.SearchProvider") = "Wiki" Then
			_IECreate("http://en.wikipedia.org/w/index.php?title=Special%3ASearch&search=" & GUICtrlRead($Searchtext) &"&ns0=1&fulltext=Search")
			EndIf
		Else
			GUIDelete($MainGUI)
			searchit()
		EndIf
		EndIf
	
		Case $Options
			GUIDelete($MainGUI)
			Options()
			
		Case $Bughelp
			GUIDelete($MainGUI)
			_bug()
	EndSwitch
	
	$msg = TrayGetMsg()
	Switch $msg
		Case $MenuExit
			Exit
	EndSwitch
	
WEnd
EndFunc

Func Options()
	
$optionsGUI = GUICreate("Search-It Options", 230, 85)
$Browser = GUICtrlCreateCombo("Please select a browser", 5, 5, 145, 25)
GUICtrlSetData(-1, "Internet Explorer|Search-It")
$Provider = GUICtrlCreateCombo("Please select a provider", 5, 30, 145, 25)
GUICtrlSetData(-1, "Google|Yahoo|Ask|Wiki")
$Saveoptionbrowser = GUICtrlCreateButton("Save", 150, 4, 75, 23, 0)
$Saveoptionprovider = GUICtrlCreateButton("Save", 150, 29, 75, 22, 0)
$FactorySettingsopt = GUICtrlCreateButton("Factory Settings", 5, 54, 220, 25)
GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			GUIDelete($optionsGUI)
			Main()
		Case $Saveoptionbrowser
			If GUICtrlRead($Browser) = "Please select a browser" Then
				MsgBox(16,"Search-It","Please pick a browser before saving!")
			Else
				MsgBox(64,"Search-It","A program restart is required for changes to take affect.")
				FileDelete("Data.Broswer")
				FileWrite("Data.Broswer", GUICtrlRead($Browser))
			EndIf
		Case $Saveoptionprovider
			If GUICtrlRead($Provider) = "Please select a provider" Then
				MsgBox(16,"Search-It","Please pick a provider before saving!")
			Else
				MsgBox(64,"Search-It","A program restart is required for changes to take affect.")
				FileDelete("Data.DefaultSearchProvider")
				FileWrite("Data.DefaultSearchProvider", GUICtrlRead($Provider))
			EndIf
		Case $FactorySettingsopt
				If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
				$iMsgBoxAnswer = MsgBox(276,"Search-It","You are about to reset Search-It to factory setting!" & @CRLF & @CRLF & "Are you sure you wish to do this?")
					Select
						Case $iMsgBoxAnswer = 6 ;Yes
							FileDelete("Data.DefaultSearchProvider")
							FileDelete("Data.Broswer")
							FileDelete("Data.SearchProvider")
							FileDelete("Data.Lastsearch")
							MsgBox(48,"Search-It","Factory Settings installed!" & @CRLF & @CRLF & "A restart is required for changes to take affect.")
						Case $iMsgBoxAnswer = 7 ;No

					EndSelect

	EndSwitch
WEnd

EndFunc



Func searchit()
	
$searchlist = FileReadLine("Data.Lastsearch", 1)
$searchitbrowser = GUICreate("Search-It Browser", 1000, 700)
GUICtrlCreateObj($oIE, 5, 5, 990, 695)
GUISetState()       ;Show GUI

If FileReadLine("Data.SearchProvider")  = "Google" Then
_IENavigate ($oIE, "http://www.google.co.uk/search?hl=en&q=" & $searchlist &"&btnG=Search&meta=")
EndIf

If FileReadLine("Data.SearchProvider") = "Yahoo" Then
_IENavigate ($oIE, "                                 ;_ylt=A1f4cfb_pJFJWcAAn15LBQx.?p=" & $searchlist &"&y=Search&fr=yfp-t-501&rd=r1")
EndIf

If FileReadLine("Data.SearchProvider") = "Ask" Then
_IENavigate($oIE, "                                         " & $searchlist &"&dm=all")
EndIf
		
If FileReadLine("Data.SearchProvider") = "Wiki" Then
_IENavigate($oIE, "http://en.wikipedia.org/w/index.php?title=Special%3ASearch&search=" & $searchlist &"&ns0=1&fulltext=Search")
EndIf


While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			GUIDelete($searchitbrowser)
			Main()

	EndSelect
WEnd

Exit


EndFunc




Func _bug() 
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

$BugGUI = GUICreate("Search-It Bug help", 476, 121)
$Label1 = GUICtrlCreateLabel("Help I encounted a bug! What shall i do?", 8, 8, 198, 17)
$Label2 = GUICtrlCreateLabel("Most bugs can be fixed by installing the factory setting! This can be done by following these steps:", 8, 32, 465, 17)
$Label3 = GUICtrlCreateLabel("Restart program > Options > Factory Settings > Yes > Ok > Restart program", 8, 48, 358, 17)
$Label4 = GUICtrlCreateLabel("If the bug is browser based try setting the browser as Search-It", 8, 72, 297, 17)
$Label5 = GUICtrlCreateLabel("If the bug still isnt fixed there is a chance that a file may be corrupt. Please re-install Search-It", 8, 96, 439, 17)
GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			GUIDelete($BugGUI)
			Main()
	EndSwitch
WEnd


EndFunc


#include <GUIConstants.au3>
#include <IE.au3>
#include <GUIListBox.au3>
#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Array.au3>
Opt("GUIOnEventMode", 1)
; == GUI generated with Koda ==
$Main = GUICreate("RSLinks.org Get Rapidshare Links", 622, 420, 202, 243)
$Group1 = GUICtrlCreateGroup("Please Enter Webpage Containg RapidShare Links", 8, 8, 609, 57)
$txtWebPage = GUICtrlCreateInput("", 16, 32, 553, 21, -1, $WS_EX_CLIENTEDGE)
$btnAdd = GUICtrlCreateButton("Add", 576, 32, 35, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group2 = GUICtrlCreateGroup("Please Enter File To Save These Links To", 8, 320, 609, 57)
$txtSaveFile = GUICtrlCreateInput("", 16, 344, 561, 21, -1, $WS_EX_CLIENTEDGE)
$btnSaveFile = GUICtrlCreateButton("...", 584, 344, 27, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$BtnGo = GUICtrlCreateButton("Get Links", 544, 384, 75, 25)
$lstRSLinksPages = GUICtrlCreateList("", 8, 80, 609, 227, BitOR($LBS_STANDARD,$WS_HSCROLL,$WS_VSCROLL), $WS_EX_CLIENTEDGE)
GUISetState(@SW_SHOW)

GUISetOnEvent($GUI_EVENT_CLOSE, "SpecialEvents")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "SpecialEvents")
GUISetOnEvent($GUI_EVENT_RESTORE, "SpecialEvents")

GUICtrlSetOnEvent($btnAdd, "AddSite")
GUICtrlSetOnEvent($btnSaveFile, "GetSaveFile")
GUICtrlSetOnEvent($BtnGo, "GetLink")

While 1
	$msg = GuiGetMsg()
	Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case Else
		;;;;;;;
	EndSelect
WEnd
Exit




func GetLink()
	local $SaveFile = GUICtrlRead($txtSaveFile)
	if($SaveFile = "")Then
		Return
	EndIf
	local $amt = _GUICtrlListBox_GetListBoxInfo($lstRSLinksPages)
	local $index = 0
	while $index < $amt
		local $webpage =  _GUICtrlListBox_GetText($lstRSLinksPages, $index)
		local $file = FileOpen($SaveFile,1)
		$oIE = _IECreate ($webpage,0,0,1,1)
		$links = _IELinkGetCollection($oIE)
		$iNumLinks = @extended
		For $link In $links
			$URL = $link.href
			;$name = $link.innerHTML
			local $result = StringInStr($URL,"                     ")
			if($result <> 0)Then
				FileWriteLine($file,$URL)
			EndIf
		Next
		_IEQuit ($oIE)
		FileClose($file)
		$index = $index + 1
	WEnd
	MsgBox(0,"END","Completed")
EndFunc


Func SpecialEvents()
    Select
        Case @GUI_CTRLID = $GUI_EVENT_CLOSE
            Exit
        Case @GUI_CTRLID = $GUI_EVENT_MINIMIZE
        Case @GUI_CTRLID = $GUI_EVENT_RESTORE
    EndSelect
EndFunc


Func GetSaveFile()
	$var = FileSaveDialog( "Save/Append To File.", @MyDocumentsDir, "Text Files (*.txt)", 2)
	GUICtrlSetData($txtSaveFile,$var)
EndFunc

Func AddSite()
	local $site = GUICtrlRead($txtWebPage)
	If($site <> "")Then
		_GUICtrlListBox_InsertString($lstRSLinksPages,$site)
	EndIf
EndFunc
;~
;~
;~                                         FB@,      @B.                      7@B7
;~                                        OB@@:      B@.                     5@@@7
;~ ik7  r@B@B@u     v@B@B@u              @BO@@,      @B.       0BE.         G@B@B7     :EY  .E@@B@BL
;~ S@O.B@@UL5B@Bi iB@BULSB@Bi           @Bj @B,      @@      q@BM.         B@Z O@7     v@B @@BZLJP@B@:
;~ vB@BS      i@BP@S      i@B         .@Bu  B@,      @B    F@@N           B@N  @B7     rB@B@.      rB@
;~ 7@@Y        G@Bv        M@J       :@@r   @B,      B@  7@BB           .@@u   B@7     i@BO         0BL
;~ vB@         5B@         5@E      r@B.    B@.      @BvB@B.           ,B@i    @Br     rB@          i@X
;~ 7@M         Y@M         1@N     u@B      @@       B@B@r            rB@      B@:     i@B          iBN
;~ L@8         uBO         S@0    M@@u:vLJ77B@Uvu    @@YB@X          SB@k:7YLLr@Bq72.  rB@          :@X
;~ v@O         u@G         5@q   M@B@B@B@B@B@B@B@:   B@  5@Bu       P@@B@B@B@B@B@@@B7  i@B          iBq
;~ vBO         UBO         F@0              B@.      @B    @B@i                @Bi     rB@          i@P
;~ 7@O         j@8         5@N              @B.      @@     :B@B.              B@i     ;@@          iBq
;~ vBO         Y@8         1@N              @@.      @B       .@@M             @Br     iB@          :@k
;~
;~ m4k4n's TVShow Junkie!
;~ You dont have to change the script unless M2K changes its Site
;~ www.m4k4n.de
;~
;~ Autor: m4k4n
;~ Version: 1.0
;~ Date: 04.03.2013


#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <IE.au3>
#include <Array.au3>
#include <File.au3>
#include <ProgressConstants.au3>
#include <GUIComboBox.au3>
#include <WinAPI.au3>

Global Const $ODT_MENU = 1
Global Const $ODT_LISTBOX = 2
Global Const $ODT_COMBOBOX = 3
Global Const $ODT_BUTTON = 4
Global Const $ODT_STATIC = 5
Global Const $ODT_HEADER = 100
Global Const $ODT_TAB = 101
Global Const $ODT_LISTVIEW = 102

Global Const $ODA_DRAWENTIRE = 1
Global Const $ODA_SELECT = 2
Global Const $ODA_FOCUS = 4
Global Const $ODS_SELECTED = 1
Global Const $ODS_GRAYED = 2
Global Const $ODS_DISABLED = 4
Global Const $ODS_CHECKED = 8
Global Const $ODS_FOCUS = 16
Global Const $ODS_DEFAULT = 32
Global Const $ODS_HOTLIGHT = 64
Global Const $ODS_INACTIVE = 128
Global Const $ODS_NOACCEL = 256
Global Const $ODS_NOFOCUSRECT = 512
Global Const $ODS_COMBOBOXEDIT = 4096

Global Const $clrWindowText = _WinAPI_GetSysColor($COLOR_WINDOWTEXT)
Global Const $clrHighlightText = _WinAPI_GetSysColor($COLOR_HIGHLIGHTTEXT)
Global Const $clrHightlight = _WinAPI_GetSysColor($COLOR_HIGHLIGHT)
Global Const $clrWindow = _WinAPI_GetSysColor($COLOR_WINDOW)

Global Const $tagDRAWITEMSTRUCT = _
		'uint CtlType;' & _
		'uint CtlID;' & _
		'uint itemID;' & _
		'uint itemAction;' & _
		'uint itemState;' & _
		'hwnd hwndItem;' & _
		'hwnd hDC;' & _
		$tagRECT & _
		';ulong_ptr itemData;'

Global Const $tagMEASUREITEMSTRUCT = _
		'uint CtlType;' & _
		'uint CtlID;' & _
		'uint itemID;' & _
		'uint itemWidth;' & _
		'uint itemHeight;' & _
		'ulong_ptr itemData;'


Global $hGUI
Global $Combo1
Global $sStr = ''

;GUI
$Form1_1 = GUICreate("TVShow Junkie!", 383, 263, 254, 261)
$List1 = GUICtrlCreateList("", 8, 56, 113, 201, 0xA30001)
GUICtrlSetData(-1, "")
GUICtrlSetFont(-1, 7, 400, 0, "Calibri")
$Combo1 = GUICtrlCreateCombo("", 8, 6, 113, 25, BitOR($WS_CHILD, $CBS_OWNERDRAWFIXED, $CBS_HASSTRINGS, $CBS_DROPDOWNLIST))
GUICtrlSetFont(-1, 9, 400, 0, "Calibri")
$Combo2 = GUICtrlCreateCombo("Seasons", 8, 32, 113, 25)
GUICtrlSetFont(-1, 9, 400, 0, "Calibri")
$Button1 = GUICtrlCreateButton("Open TVShow", 240, 6, 137, 49)
GUICtrlSetFont(-1, 9, 400, 0, "Calibri")
$Button2 = GUICtrlCreateButton("Update all", 240, 56, 137, 49)
GUICtrlSetFont(-1, 9, 400, 0, "Calibri")
$Button3 = GUICtrlCreateButton("Set Flag", 240, 106, 137, 49)
GUICtrlSetFont(-1, 9, 400, 0, "Calibri")
$Button4 = GUICtrlCreateButton("New/Edit TV Show", 240, 156, 137, 49)
GUICtrlSetFont(-1, 9, 400, 0, "Calibri")
$Button5 = GUICtrlCreateButton("Delete Selected", 240, 207, 137, 49)
GUICtrlSetFont(-1, 9, 400, 0, "Calibri")
$Group1 = GUICtrlCreateGroup("Menu", 128, 0, 105, 169)
GUICtrlSetFont(-1, 8, 400, 0, "Calibri")
$Progress1 = GUICtrlCreateProgress(137, 16, 86, 17)
$Input1 = GUICtrlCreateInput("", 136, 58, 89, 21)
GUICtrlSetFont(-1, 9, 400, 0, "Calibri")
$Label1 = GUICtrlCreateLabel("Show Name:", 136, 40, 62, 17)
GUICtrlSetFont(-1, 9, 400, 0, "Calibri")
$Label2 = GUICtrlCreateLabel("Link:", 136, 81, 26, 17)
GUICtrlSetFont(-1, 9, 400, 0, "Calibri")
$Input2 = GUICtrlCreateInput("", 136, 98, 89, 21)
GUICtrlSetFont(-1, 9, 400, 0, "Calibri")
$Label6 = GUICtrlCreateLabel("TVShow end?", 136, 121, 82, 17)
GUICtrlSetFont(-1, 9, 400, 0, "Calibri")
$Combo3 = GUICtrlCreateCombo("", 136, 138, 57, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
GUICtrlSetFont(-1, 9, 400, 0, "Calibri")
GUICtrlSetData($Combo3, "No|Yes", "No")
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlSetFont(-1, 9, 400, 0, "Calibri")
$Group2 = GUICtrlCreateGroup("Info", 128, 168, 105, 89)
GUICtrlSetFont(-1, 8, 400, 0, "Calibri")
$Label3 = GUICtrlCreateLabel("You are currently at", 133, 184, 96, 17)
GUICtrlSetFont(-1, 8.7, 400, 0, "Calibri")
$Label4 = GUICtrlCreateLabel("", 157, 202, 62, 17)
GUICtrlSetFont(-1, 8.7, 400, 0, "Calibri")
$Label5 = GUICtrlCreateLabel("", 157, 217, 71, 17)
GUICtrlSetFont(-1, 8.7, 400, 0, "Calibri")
$Label7 = GUICtrlCreateLabel("", 136, 236, 92, 17)
GUICtrlSetFont(-1, 8.7, 400, 0, "Calibri")
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)
GUIRegisterMsg($WM_DRAWITEM, '_WM_DRAWITEM')

StartUp()

;While loop to keep GUI open and Case on Button
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Button1
			OpenLink()
		Case $Button2
			UpdateTVSData()
		Case $Button3
			FlagEpisode()
		Case $Button4
			GetTVSData(GUICtrlRead($Input1), GUICtrlRead($Input2))
		Case $Button5
			DeleteTVSData()
		Case $Combo1
			ReadSeason()
		Case $Combo2
			ReadEpisodes()
	EndSwitch
WEnd

;Check if inifile exisits, if not create the default one
Func StartUp()
	If FileExists("TVJunkieData.ini") Then
		Onload()
	Else
		IniWrite("TVJunkieData.ini", "TV Show", "1", "1")
		IniWrite("TVJunkieData.ini", "TV Show", "Link", "Enter Link")
		IniWrite("TVJunkieData.ini", "TV Show", "Seasons", "1")
		IniWrite("TVJunkieData.ini", "TV Show", "FlagS", "1")
		IniWrite("TVJunkieData.ini", "TV Show", "FlagE", "1")
		IniWrite("TVJunkieData.ini", "TV Show", "FlagD", "0")
		IniWrite("TVJunkieData.ini", "TV Show", "End", "No")
		Onload()
	EndIf
EndFunc   ;==>StartUp

;Read INI for Shows and Season
Func Onload()
	Local $TVShowNames = IniReadSectionNames("TVJunkieData.ini")
	GUICtrlSetData($Progress1, "0")
	If $TVShowNames[0] > 10 Then
		$showdat = _ArrayToString($TVShowNames)
		$showdat2 = StringTrimLeft($showdat, 3)
	Else
		$showdat = _ArrayToString($TVShowNames)
		$showdat2 = StringTrimLeft($showdat, 2)
	EndIf
	GUICtrlSetData($Combo1, "|" & $showdat2, "TV Show")
	ReadEpisodes()
	CheckFlag()
EndFunc   ;==>Onload

;Draw Combo1 for colorfull names on new Episodes
Func _WM_DRAWITEM($hWnd, $iMsg, $iwParam, $ilParam)
	Local $tDIS = DllStructCreate($tagDRAWITEMSTRUCT, $ilParam)
	Local $iCtlType, $iCtlID, $iItemID, $iItemAction, $iItemState
	Local $clrForeground, $clrBackground
	Local $hWndItem, $hDC
	Local $tRect
	Local $sText
	Local $TVShowNames = IniReadSectionNames("TVJunkieData.ini")

	$iCtlType = DllStructGetData($tDIS, 'CtlType')
	$iCtlID = DllStructGetData($tDIS, 'CtlID')
	$iItemID = DllStructGetData($tDIS, 'itemID')
	$iItemAction = DllStructGetData($tDIS, 'itemAction')
	$iItemState = DllStructGetData($tDIS, 'itemState')
	$hWndItem = DllStructGetData($tDIS, 'hwndItem')
	$hDC = DllStructGetData($tDIS, 'hDC')
	$tRect = DllStructCreate($tagRECT)

	Switch $iItemAction
		Case $ODA_DRAWENTIRE, $ODA_SELECT
			For $i = 1 To 4
				DllStructSetData($tRect, $i, DllStructGetData($tDIS, $i + 7))
			Next

			_GUICtrlComboBox_GetLBText($hWndItem, $iItemID, $sText)

			For $i2 = 0 To $TVShowNames[0]
				If IniRead("TVJunkieData.ini", $TVShowNames[$i2], "FlagD", "Not Found") <> 0 Or IniRead("TVJunkieData.ini", $TVShowNames[$i2], "FlagD", "Not Found") = "S+" Then
					If $iItemID = $i2 - 1 Then
						$clrForeground = _WinAPI_SetTextColor($hDC, 0x0B22ED)
					EndIf
				EndIf
			Next

			If BitAND($iItemState, $ODS_SELECTED) Then
				$clrBackground = _WinAPI_SetBkColor($hDC, $clrHightlight)
			Else
				$clrBackground = _WinAPI_SetBkColor($hDC, $clrWindow)
			EndIf

			_WinAPI_DrawText($hDC, $sText, $tRect, $DT_LEFT)
			_WinAPI_SetTextColor($hDC, $clrForeground)
			_WinAPI_SetBkColor($hDC, $clrBackground)

	EndSwitch

	Return $GUI_RUNDEFMSG
EndFunc   ;==>_WM_DRAWITEM

;React on Combo1 and Reads Seasons amount for Combo2 and fills it
Func ReadSeason()
	Local $readSeasons = IniRead("TVJunkieData.ini", GUICtrlRead($Combo1), "Seasons", "NotFound")
	Local $SeasonArr[$readSeasons]
	For $i = 1 To $readSeasons
		$SeasonArr[$i - 1] = $i
	Next
	GUICtrlSetData($Combo2, "|" & _ArrayToString($SeasonArr), 1)
	ReadEpisodes()
	CheckFlag()
EndFunc   ;==>ReadSeason

;Read INI for Episodes per Season
Func ReadEpisodes()
	Local $readEpisodes = IniRead("TVJunkieData.ini", GUICtrlRead($Combo1), GUICtrlRead($Combo2), "NotFound")
	Local $EpisodeArr[$readEpisodes]
	For $i = 1 To $readEpisodes
		$EpisodeArr[$i - 1] = $i
	Next
	GUICtrlSetData($List1, "|" & _ArrayToString($EpisodeArr), 1)

	Local $Link = IniRead("TVJunkieData.ini", GUICtrlRead($Combo1), "Link", "NotFound")
	Local $Seas = IniRead("TVJunkieData.ini", GUICtrlRead($Combo1), "FlagS", "NotFound")
	Local $Eps = IniRead("TVJunkieData.ini", GUICtrlRead($Combo1), "FlagE", "NotFound")
	Local $End = IniRead("TVJunkieData.ini", GUICtrlRead($Combo1), "End", "NotFound")
	GUICtrlSetData($Input1, GUICtrlRead($Combo1))
	GUICtrlSetData($Input2, $Link)
	GUICtrlSetData($Combo3, $End)
	GUICtrlSetData($Label4, "Season: " & $Seas)
	GUICtrlSetData($Label5, "Episode: " & $Eps)
EndFunc   ;==>ReadEpisodes

;Flag as New/Old - maybe Update func UpdateTVSData
Func FlagEpisode()
	IniWrite("TVJunkieData.ini", GUICtrlRead($Combo1), "FlagS", GUICtrlRead($Combo2))
	IniWrite("TVJunkieData.ini", GUICtrlRead($Combo1), "FlagE", GUICtrlRead($List1))
	ReadEpisodes()
	CheckFlag()
EndFunc   ;==>FlagEpisode

;Checks value of newest episode and compares it with flag
Func CheckFlag()
	Local $Seasons = IniRead("TVJunkieData.ini", GUICtrlRead($Combo1), "Seasons", "NotFound")
	Local $Seas = IniRead("TVJunkieData.ini", GUICtrlRead($Combo1), "FlagS", "NotFound")
	Local $Eps = IniRead("TVJunkieData.ini", GUICtrlRead($Combo1), "FlagE", "NotFound")
	Local $EpsSeas = IniRead("TVJunkieData.ini", GUICtrlRead($Combo1), $Seasons, "NotFound")
	If $Seasons = $Seas Then
		Local $EpDif = $EpsSeas - $Eps
	Else
		Local $EpDif = "S+"
	EndIf
	IniWrite("TVJunkieData.ini", GUICtrlRead($Combo1), "FlagD", $EpDif)
	GUICtrlSetData($Label7, "New Episodes: " & $EpDif)
EndFunc   ;==>CheckFlag

;Open Link to TVShow in default Browser
Func OpenLink()
	If GUICtrlRead($Combo1) = "TV Show" Then
		MsgBox(0, "ERROR", "You cannot Open the link of this TVShow")
	Else
		ShellExecute(IniRead("TVJunkieData.ini", GUICtrlRead($Combo1), "Link", "NotFound"))
	EndIf
EndFunc   ;==>OpenLink

;GetData for new Show
Func GetTVSData($ShowName, $ShowLink)
	GUICtrlSetState($Button4, $GUI_DISABLE)
	$ShowLinkCheck = StringInStr($ShowLink, "movie2k")
	If $ShowLinkCheck = 0 Then
		MsgBox(0, "ERROR", "The link is not from Movie2k")
	Else
		GUICtrlSetData($Progress1, "50")
		Local $oIE = _IECreate($ShowLink, 0, 0)
		Local $oForm = _IEFormGetObjByName($oIE, "seasonform")
		Local $oSelect = _IEFormElementGetObjByName($oForm, "season")
		Local $iSelIndex = $oSelect.innerText

		;Cut the last digs of the string and create Int with it = Season MAX
		Local $Seasons = Int(StringRight($iSelIndex, 3))
		;Create Episodeform Array
		Local $EpisodArr[1] = [0]

		;Put the episodes per season in an array
		Local $counter = 1
		While $counter <= $Seasons
			Local $episodeform = "episodeform" & $counter
			Local $oForm2 = _IEFormGetObjByName($oIE, $episodeform)
			If IsObj($oForm2) Then
				Local $oSelect2 = _IEFormElementGetObjByName($oForm2, "episode")
				Local $iSelIndex2 = $oSelect2.innerText
				Local $Episodes = Int(StringRight($iSelIndex2, 3))
				$EpisodArr[0] += 1
				If UBound($EpisodArr) <= $EpisodArr[0] Then
					ReDim $EpisodArr[UBound($EpisodArr) * 2]
				EndIf
				$EpisodArr[$EpisodArr[0]] = $Episodes
				$counter = $counter + 1
			Else
				MsgBox(0, "ERROR", "CARE! Could not find the Episodes to a Season. This might be caused by a wrong entry on Movie2k! (Like Season Jumps from 1 to 3)")
				IniDelete("TVJunkieData.ini", $ShowName)
				GUICtrlSetState($Button4, $GUI_ENABLE)
				ProcessClose("iexplore.exe")
				Onload()
				Return
			EndIf
		WEnd
		ReDim $EpisodArr[$EpisodArr[0] + 1]
		_IEQuit($oIE)

		Local $counter2 = 1
		While $counter2 <= $Seasons
			IniWrite("TVJunkieData.ini", $ShowName, $counter2, $EpisodArr[$counter2])
			$counter2 = $counter2 + 1
		WEnd

		IniWrite("TVJunkieData.ini", $ShowName, "Link", $ShowLink)
		IniWrite("TVJunkieData.ini", $ShowName, "Seasons", $Seasons)
		IniWrite("TVJunkieData.ini", $ShowName, "FlagS", "1")
		IniWrite("TVJunkieData.ini", $ShowName, "FlagE", "1")
		IniWrite("TVJunkieData.ini", $ShowName, "End", GUICtrlRead($Combo3))
		IniWrite("TVJunkieData.ini", $ShowName, "FlagD", "S+")
		;ConsoleWrite("done putting shit in ini file")
		GUICtrlSetData($Progress1, "100")
		Sleep(1000)
	EndIf
	GUICtrlSetState($Button4, $GUI_ENABLE)
	GUICtrlSetData($Progress1, "0")
	ProcessClose("iexplore.exe")
	Onload()
EndFunc   ;==>GetTVSData

;Update all
Func UpdateTVSData()
	Local $TVShowNames = IniReadSectionNames("TVJunkieData.ini")
	Local $Items = UBound($TVShowNames) - 2
	Local $PartItem = 100 / $Items
	GUICtrlSetData($Progress1, "0")
	GUICtrlSetState($Button2, $GUI_DISABLE)
	For $i = 1 To $Items
		$ShowName = $TVShowNames[$i + 1]
		$ShowLink = IniRead("TVJunkieData.ini", $ShowName, "Link", "NotFound")
		$newestSeason = IniRead("TVJunkieData.ini", $ShowName, "Seasons", "NotFound")

		Local $oIE = _IECreate($ShowLink, 0, 0)
		Local $oForm = _IEFormGetObjByName($oIE, "seasonform")
		Local $oSelect = _IEFormElementGetObjByName($oForm, "season")
		Local $iSelIndex = $oSelect.innerText
		;Cut the last digs of the string and create Int with it = Season MAX
		Local $Seasons = Int(StringRight($iSelIndex, 3))
		Local $End = IniRead("TVJunkieData.ini", $ShowName, "End", "NotFound")

		If $End = "Yes" Then

		Else
			If $Seasons > $newestSeason Then
				;Put the episodes per season in an array
				Local $EpisodArr[1] = [0]
				Local $counter = 1
				While $counter <= $Seasons
					Local $episodeform = "episodeform" & $counter
					Local $oForm2 = _IEFormGetObjByName($oIE, $episodeform)
					If IsObj($oForm2) Then
						Local $oSelect2 = _IEFormElementGetObjByName($oForm2, "episode")
						Local $iSelIndex2 = $oSelect2.innerText
						Local $Episodes = Int(StringRight($iSelIndex2, 3))
						$EpisodArr[0] += 1
						If UBound($EpisodArr) <= $EpisodArr[0] Then
							ReDim $EpisodArr[UBound($EpisodArr) * 2]
						EndIf
						$EpisodArr[$EpisodArr[0]] = $Episodes
						$counter = $counter + 1
					Else
						MsgBox(0, "ERROR", "CARE! Could not find the Episodes to a Season of " & $ShowName &". This might be caused by a wrong entry on Movie2k! (Like Season Jumps from 1 to 3) Deleting TVShow! Press Update Again")
						IniDelete("TVJunkieData.ini", $ShowName)
						GUICtrlSetState($Button2, $GUI_ENABLE)
						ProcessClose("iexplore.exe")
						Onload()
						Return
					EndIf
				WEnd
				ReDim $EpisodArr[$EpisodArr[0] + 1]
				_IEQuit($oIE)

				Local $counter2 = 1
				While $counter2 <= $Seasons
					IniWrite("TVJunkieData.ini", $ShowName, $counter2, $EpisodArr[$counter2])
					$counter2 = $counter2 + 1
				WEnd

				IniWrite("TVJunkieData.ini", $ShowName, "Link", $ShowLink)
				IniWrite("TVJunkieData.ini", $ShowName, "Seasons", $Seasons)
				;ConsoleWrite("done new Season in ini")

			Else

				Local $episodeform = "episodeform" & $newestSeason
				Local $oForm2 = _IEFormGetObjByName($oIE, $episodeform)
				Local $oSelect2 = _IEFormElementGetObjByName($oForm2, "episode")
				Local $iSelIndex2 = $oSelect2.innerText
				Local $Episodes = Int(StringRight($iSelIndex2, 3))
				_IEQuit($oIE)
				IniWrite("TVJunkieData.ini", $ShowName, $newestSeason, $Episodes)

				;ConsoleWrite("done updating")
			EndIf
		EndIf
		$PartItem2 = $i * $PartItem
		GUICtrlSetData($Progress1, $PartItem2)
	Next
	GUICtrlSetData($Progress1, "100")
	GUICtrlSetState($Button2, $GUI_ENABLE)
	ProcessClose("iexplore.exe")
	Onload()
EndFunc   ;==>UpdateTVSData

;Delete Selected TVShow
Func DeleteTVSData()
	If GUICtrlRead($Combo1) = "TV Show" Then
		MsgBox(0, "ERROR", "You cannot delete this TVShow")
	Else
		Local $Msg = MsgBox(1, "Wait...", "Sure you want to Delete " & GUICtrlRead($Combo1) & "?")
		If $Msg == 1 Then
			IniDelete("TVJunkieData.ini", GUICtrlRead($Combo1))
			Onload()
		Else

		EndIf
	EndIf
EndFunc   ;==>DeleteTVSData
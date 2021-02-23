#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=TempData\skin\shoutcast.ico
#AutoIt3Wrapper_outfile=TinyShoutCastTuner.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_Comment=Tested on Xp 32bit and 7 32bit.
#AutoIt3Wrapper_Res_Description=Tune into your favourite Shoutcast Radio Stations, browse and favourite!
#AutoIt3Wrapper_Res_Fileversion=1.0.1.1
#AutoIt3Wrapper_Res_LegalCopyright=Copyright © 2011 wakillon and shanet
#AutoIt3Wrapper_Res_Field=AutoIt Version|%AutoItVer%
#AutoIt3Wrapper_Res_Field=Compile date|%longdate% %time%
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****


#include <GUIConstantsEx.au3>
#include <GUIStatusBar.au3>
#include <AutoitObject.au3>
#include <GuiListView.au3>
#include <String.au3>

Opt("GuiOnEventMode", 1)
Opt("GUICloseOnESC", 0)
Opt("TrayOnEventMode", 1)
Opt("TrayMenuMode", 1)

#Region Skin-required Variables
If (IsAdmin()) Then
	Global $_Key = "HKEY_LOCAL_MACHINE\SOFTWARE\TinyShoutCastTuner"
Else
	Global $_Key = "HKEY_CURRENT_USER\SOFTWARE\TinyShoutCastTuner"
EndIf

Global $_TempData[4]
$_TempData[1] = @TempDir & '\TST\skin\shoutcast.ico'
$_TempData[2] = @TempDir & '\TST\skin\whitefire.she'
$_TempData[3] = @TempDir & '\TST\skin\SkinH_EL.dll'
#EndRegion Skin-required Variables

If Not _Singleton(@ScriptName, 1) Then Exit
_FileInstall()

Global Const $TBS_NOTICKS = 0x0010
Global Const $TBS_RIGHT = 0x0000
Global Const $NM_FIRST = 0
Global Const $WM_NOTIFY = 0x004E
Global Const $NM_DBLCLK = $NM_FIRST - 3
Global Const $NM_CLICK = $NM_FIRST - 2
Global Const $BS_CENTER = 0x0300
Global Const $BS_FLAT = 0x8000
Global Const $PBS_SMOOTH = 1
Global Const $TRAY_EVENT_PRIMARYUP = -8
Global Const $TRAY_CHECKED = 1
Global Const $TRAY_UNCHECKED = 4

Global $sMediaFile
Global $oCOMError = ObjEvent("AutoIt.Error", "_ErrFunc")
_AutoItObject_StartUp()
Global $oUSER32DLL = _AutoItObject_DllOpen("user32.dll")
Global $hVolSlider
Global $hLevMet
Global $oGraphBuilder, $oMediaControl, $oBasicAudio, $oAudioMeterInformation
_AudioVolObject($oAudioMeterInformation)
If Not @error Then AdlibRegister("_LevelMeter", 45)

#Region Variables
Global $_GuiTitle = 'TinyShoutCastTuner', $_GuiWidth = 635, $_GuiHeight = 370, $_ButtonWidth = 80, $_ButtonHeight = 22
Global $_ListView, $_ListViewItem[1], $_ListViewItemMax, $_SimpleClick, $_DoubleClick, $DblClick, $_DevIdkey = 'wa1NcG2CLff9Gl5M'
Global $_K = 0, $_Progress, $sMediaFile2Old, $_DisplayName, $_DisplayName2, $_DisplayNameOld, $_LastStationUrl, $_TitleKey = 'TinyShoutCastTuner'
Global $_ArrayId[1], $_ArrayName[1], $_ArrayGenre[1], $_ArrayUrl[1], $_ArrayListenerPeak[1], $_ArrayContentType[1], $_ArrayCurrentSong[1], $_ArrayBitrate[1]
Global $_ArrayParts[3] = [150, 435, 720], $_StatusBar, $_HandleProgress, $_HandleInput, $_InPut, $_InPut2, $_Label, $_ComboBox1, $_ComboBox2, $_ComboBox3
Global $_ShowFavButton, $_ReMovFavButton, $_AddFavButton, $_FavoritesArrayName[1], $_FavoritesArrayUrl[1], $_ShowFavorites
Global $_TypeSearch, $_MaxResults = '&limit=30', $_Genre, $_KeyWords, $_TopLimit, $_BadSearch, $_SearchButton, $_PlayButton, $sMediaFile2, $iVol, $iPlaying = 0
Global $_ShoutcastItem, $_StartItem, $_AboutItem, $_AddRadioToFavoritesItem, $_SkinItem, $_Choice
Global $_radioData, $_radioDataSplit, $_addressSplit

_GuiCreate()
_TrayMenu()
_GUICtrlCreateListViewItems('')
GUIRegisterMsg($WM_NOTIFY, "_WnNotify")
_init()
#EndRegion Variables

While 1
	If $iVol <> (100-GUICtrlRead($hVolSlider)) Then
		$iVol = 100 - GUICtrlRead($hVolSlider)
		If IsObj($oBasicAudio) Then $oBasicAudio.put_Volume(-Exp(($iVol) / 10.86))
		GUICtrlSetTip($hVolSlider, 100 - $iVol & " %VOL")
	EndIf
	If $iPlaying = 2 Then
		If IsObj($oBasicAudio) Then $oBasicAudio.put_volume(-10000)
	EndIf
	If $sMediaFile Then _RenderFile($sMediaFile)
	_getData()
WEnd

Func _Search()
	If $_TypeSearch = '' Then Return
	If $_ShowFavorites = 1 Then _ShowFavorites()
	GUICtrlSetState($_AddFavButton, $GUI_DISABLE)
	GUICtrlSetState($_ReMovFavButton, $GUI_HIDE)
	$_ShowFavorites = 0
	_GetMaxResults()
	Select
		Case $_TypeSearch = 'Top'
			$_Url = 'http://api.shoutcast.com/legacy/Top500?k=' & $_DevIdkey & $_MaxResults
		Case $_TypeSearch = "Genre"
			_GetGenre()
			if (Not $_BadSearch) Then
				$_Url = 'http://api.shoutcast.com/legacy/genresearch?k=' & $_DevIdkey & $_Genre & $_MaxResults
			Else
				$_Url = 'No Genre set... No search.'
			EndIf
		Case $_TypeSearch = "KeyWords"
			_GetKeyWords()
			if ($_KeyWords <> "&search=Type+KeyWords") Then
				$_Url = 'http://api.shoutcast.com/legacy/stationsearch?k=' & $_DevIdkey & $_KeyWords & $_MaxResults
			Else
				$_Url = 'Bad Keywords... No search.'
			EndIf
		Case Else
			Return
	EndSelect
	ConsoleWrite("-->-- $_Url : " & $_Url & @CRLF)
	GUICtrlSetState($_SearchButton, $GUI_DISABLE)
	_GUICtrlStatusBar_SetText($_StatusBar, "Searching...", 0)
	$_K = 0
	Do
		$_SourceCode = _GetSourceCode($_Url)
		$_ArraySource = _StringBetween($_SourceCode, 'station name="', ' /><')
		If @error Then
			$_K += 1
			If $_K = 5 Then
				ReDim $_ArrayName[2]
				$_ArrayName[1] = 'Nothing Found !'
				_GUICtrlCreateListViewItems($_ArrayName)
				_GUICtrlStatusBar_SetText($_StatusBar, "Waiting", 0)
				GUICtrlSetState($_SearchButton, $GUI_ENABLE)
				GUICtrlSetState($_AddFavButton, $GUI_ENABLE)
				Return
			EndIf
		EndIf
		Sleep(500)
	Until IsArray($_ArraySource)
	GUICtrlSetData($_Progress, 1)
	GUICtrlSetState($_Progress, $GUI_SHOW)
	ReDim $_ArrayId[1], $_ArrayName[1], $_ArrayGenre[1], $_ArrayUrl[1], $_ArrayListenerPeak[1], $_ArrayContentType[1], $_ArrayCurrentSong[1], $_ArrayBitrate[1]
	$_K = 0
	For $_I = 0 To UBound($_ArraySource) - 1
		$_StationName = _GetStationName($_ArraySource[$_I])
		$_StationId = _GetStationId($_ArraySource[$_I])
		$_StationGenre = _GetStationGenre($_ArraySource[$_I])
		$_StationListenerPeak = _GetStationListenerPeak($_ArraySource[$_I])
		$_StationContentType = _GetStationContentType($_ArraySource[$_I])
		$_StationBitrate = _GetStationBitrate($_ArraySource[$_I])
		$_StationUrl = _GetStationUrlById($_StationId, $_DevIdkey)
		If $_StationName And $_StationUrl And $_StationId Then
			$_K += 1
			ConsoleWrite("+->--  " & StringFormat("%03i", $_K) & " StationName : " & $_StationName & @CRLF)
			ConsoleWrite(">->--      Station Url : " & $_StationUrl & @CRLF)
			_ArrayAdd($_ArrayName, $_StationName)
			_ArrayAdd($_ArrayUrl, $_StationUrl)
			_ArrayAdd($_ArrayId, $_StationId)
			_ArrayAdd($_ArrayGenre, $_StationGenre)
			_ArrayAdd($_ArrayListenerPeak, $_StationListenerPeak)
			_ArrayAdd($_ArrayContentType, $_StationContentType)
			_ArrayAdd($_ArrayBitrate, $_StationBitrate)
		EndIf
		GUICtrlSetData($_Progress, ($_I / (UBound($_ArraySource) - 1)) * 100)
	Next
	GUICtrlSetData($_Progress, 100)
	_GUICtrlCreateListViewItems($_ArrayName)
	Sleep(500)
	GUICtrlSetState($_Progress, $GUI_HIDE)
	GUICtrlSetState($_SearchButton, $GUI_ENABLE)
	GUICtrlSetState($_AddFavButton, $GUI_ENABLE)
	_GUICtrlStatusBar_SetText($_StatusBar, "Waiting...", 0)
EndFunc

Func _getData()
	Local $_IndexText = _GUICtrlListView_GetItemText($_ListView, Number(_GUICtrlListView_GetSelectedIndices($_ListView)) )
	$_radioData = $sMediaFile2
	$_radioDataSplit = StringSplit($_radioData, "|")
	$_addressSplit = StringSplit(StringReplace($_radioDataSplit[1], 'http://', ''), ':')
	$_Result = _GetShoutcastRadioInfo($_addressSplit[1], $_addressSplit[2], 2000)
	If IsArray($_Result) Then
		$_Msg = 'Title : ' & $_Result[1] & @CRLF & _
				'Content Type : ' & $_Result[4] & @CRLF & _
				'Bitrate : ' 	  & $_Result[5] & @CRLF & _
				'Genre : ' & $_Result[2] & @CRLF & _
				'URL : '   & $_Result[3] & @CRLF & _
				'Current Song : ' & $_Result[6] & @CRLF
		ConsoleWrite("data: " & $_radioDataSplit[1] & ". Media: " & $sMediaFile2 & @CRLF)
		If $_radioDataSplit[1] = $sMediaFile2 Then
			GUICtrlSetData($_Label, $_Msg)
		EndIf
	EndIf
	Return
EndFunc

Func _GUICtrlCreateListViewItems($_ListArray)
	If $_ListView = 0 Then
		$_ListView = GUICtrlCreateListView("Radio|Name", 15, 20, 346, 259, BitOR($LVS_SINGLESEL, $LVS_SHOWSELALWAYS), BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_GRIDLINES))
		_GUICtrlListView_SetColumnWidth($_ListView, 1, $LVSCW_AUTOSIZE_USEHEADER)
	Else
		_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($_ListView))
		ReDim $_ListViewItem[UBound($_ListArray)]
	EndIf
	For $_G = 1 To UBound($_ListArray) - 1
		$_ListViewItem[$_G] = GUICtrlCreateListViewItem(StringFormat("%02i", $_G) & "|" & $_ListArray[$_G], $_ListView)
	Next
	GUICtrlSetTip($_ListView, "Click for get info about this Station")
	$_ListViewItemMax = UBound($_ListArray) - 1
EndFunc

Func _WnNotify($_Wnd, $_Msg, $_WParam, $_LParam)
	$_Tnmtv = DllStructCreate($tagNMTVDISPINFO, $_LParam)
	$_Code = DllStructGetData($_Tnmtv, "Code")
	$_Index = _GUICtrlListView_GetSelectedIndices($_ListView)
	If $_Code = $NM_CLICK And StringLen($_Index) <> 0 Then
		$_DoubleClick = _GUICtrlListView_GetItemText($_ListView, Number($_Index))
		If $_ShowFavorites = 0 Then
			If $_DoubleClick > UBound($_ArrayUrl) - 1 Then Return
			GUICtrlSetState($_ListView, @SW_SHOW)
			_ShowInfo($_DoubleClick)
			$sMediaFile2 = $_ArrayUrl[$_DoubleClick]
		Else
			If $_DoubleClick > UBound($_FavoritesArrayUrl) - 1 Then Return
			$_StringSplit = StringSplit(StringReplace($_FavoritesArrayUrl[$_DoubleClick], 'http://', ''), ':')
			$_Result = _GetShoutcastRadioInfo($_StringSplit[1], $_StringSplit[2], 2000)

			If IsArray($_Result) Then
				$_Msg = 'Title : ' & $_Result[1] & @CRLF & _
						'Content Type : ' & $_Result[4] & @CRLF & _
						'Bitrate : ' & $_Result[5] & @CRLF & _
						'Genre : ' & $_Result[2] & @CRLF & _
						'URL : ' & $_Result[3] & @CRLF & _
						'Current Song : ' & $_Result[6] & @CRLF
				GUICtrlSetData($_Label, $_Msg)
				ClipPut($_Result[3])
			Else
				GUICtrlSetData($_Label, 'No Info Found!')
			EndIf
			$sMediaFile2 = $_FavoritesArrayUrl[$_DoubleClick]
		EndIf
	EndIf
	If $_Code = $NM_CLICK And StringLen($_Index) <> 0 Then
		$_SimpleClick = _GUICtrlListView_GetItemText($_ListView, Number($_Index))
		If $_ShowFavorites = 1 Then
			$_DoubleClick = ''
			If $_SimpleClick > UBound($_FavoritesArrayUrl) - 1 Then Return
			$sMediaFile2 = $_FavoritesArrayUrl[$_SimpleClick]
		Else
			$_DoubleClick = $_SimpleClick
			If $_SimpleClick > UBound($_ArrayUrl) - 1 Then Return
			$sMediaFile2 = $_ArrayUrl[$_SimpleClick]
		EndIf
	EndIf
	If $_Code = $NM_DBLCLK And StringLen($_Index) <> 0 Then
		$_DblClick = _GUICtrlListView_GetItemText($_ListView, Number($_Index))
		If $_ShowFavorites = 1 Then
			$_DoubleClick = ''
			If $DblClick > UBound($_FavoritesArrayUrl) - 1 Then Return
			$sMediaFile2 = $_FavoritesArrayUrl[$_SimpleClick]
		Else
			$_DoubleClick = $_DblClick
			If $_DblClick > UBound($_ArrayUrl) - 1 Then Return
			$sMediaFile2 = $_ArrayUrl[$_DblClick]
		EndIf
		_Stop()
		_Play()
	EndIf
EndFunc

Func _ShowInfo($_Choice)
	ConsoleWrite('>->--        Show Info : ' & $_Choice & @CRLF)
	$_Ip = _StringBetween($_ArrayUrl[$_Choice], "http://", ":")
	$_Port = _StringBetween(StringReplace($_ArrayUrl[$_Choice], "http://", ""), ":", "")
	$_Msg = 'Title : ' & $_ArrayName[$_Choice] & @CRLF & _
			'Content Type : ' & $_ArrayContentType[$_Choice] & @CRLF & _
			'Bitrate : ' & $_ArrayBitrate[$_Choice] & @CRLF & _
			'Genre : ' & $_ArrayGenre[$_Choice] & @CRLF & _
			'URL : ' & $_ArrayUrl[$_Choice] & @CRLF & _
			'Current Song : ' & _GetCurrentSong($_Ip[0], $_Port[0], 2000) & @CRLF
	GUICtrlSetData($_Label, $_Msg)
	ClipPut($_ArrayUrl[$_Choice])
EndFunc

Func _init()
	_PlayLastListenedStation()
	_getData()
	_ShowFavorites()
EndFunc

Func _GetShoutcastRadioInfo($_Host, $_Port = 8000, $_TimeOut = 1500)
	TCPStartup()
	Local $_Timer = TimerInit(), $_Shoutcast = TCPConnect($_Host, $_Port)
	Dim $_ArrayInfo[7]
	If $_Shoutcast = -1 Then
		TCPShutdown()
		MsgBox(0, "", "There was an error connecting to Shoutcast.")
		Return 0
	EndIf
	TCPSend($_Shoutcast, "GET / HTTP/1.0" & @CRLF & "Icy-MetaData:1" & @CRLF & @CRLF)
	While 1
		$_Recv = BinaryToString(TCPRecv($_Shoutcast, 1024))
		If $_Recv <> '' Then
			If StringInStr($_Recv, "icy-name:") Then
				$_Info = _StringBetween($_Recv, "icy-name:", @CR)
				If Not @error And Not $_ArrayInfo[1] Then $_ArrayInfo[1] = $_Info[0]
			EndIf
			If StringInStr($_Recv, "icy-genre:") Then
				$_Info = _StringBetween($_Recv, "icy-genre:", @CR)
				If Not @error And Not $_ArrayInfo[2] Then $_ArrayInfo[2] = $_Info[0]
			EndIf
			If StringInStr($_Recv, "icy-url:") Then
				$_Info = _StringBetween($_Recv, "icy-url:", @CR)
				If Not @error And Not $_ArrayInfo[3] Then $_ArrayInfo[3] = $_Info[0]
			EndIf
			If StringInStr($_Recv, "content-type:") Then
				$_Info = _StringBetween($_Recv, "content-type:", @CR)
				If Not @error And Not $_ArrayInfo[4] Then $_ArrayInfo[4] = $_Info[0]
			EndIf
			If StringInStr($_Recv, "icy-br:") Then
				$_Info = _StringBetween($_Recv, "icy-br:", @CR)
				If Not @error And Not $_ArrayInfo[5] Then $_ArrayInfo[5] = $_Info[0]
			EndIf
			If StringInStr($_Recv, "StreamTitle=") Then
				$_CurrentSong = StringSplit($_Recv, "StreamTitle=", 1)
				$_CurrentSong = StringSplit($_CurrentSong[2], ";StreamUrl=", 1)
				TCPCloseSocket($_Shoutcast)
				$_ArrayInfo[6] = StringReplace($_CurrentSong[1], "'", "")
				$_ArrayInfo[0] = UBound($_ArrayInfo) - 1
				TCPShutdown()
				Return $_ArrayInfo
			EndIf
		EndIf
		If TimerDiff($_Timer) > $_TimeOut Then
			TCPCloseSocket($_Shoutcast)
			TCPShutdown()
			Return 0
		EndIf
	WEnd
EndFunc

Func _AddToFavorites()
	If $_DoubleClick = '' Then $_DoubleClick = $_SimpleClick
	If $_DoubleClick > UBound($_ArrayUrl) - 1 Then Return
	$_UrlToAdd = $_ArrayUrl[$_DoubleClick]
	$_NameToAdd = $_ArrayName[$_DoubleClick]
	_GetFavorites()
	If Not _AlreadyInArray($_FavoritesArrayUrl, $_UrlToAdd) Then
		If $_UrlToAdd <> '' Then _
				RegWrite($_Key & '\Favorites', StringFormat("%03i", UBound($_FavoritesArrayUrl)), "REG_SZ", $_UrlToAdd & '|' & $_NameToAdd)
		If $_NameToAdd <> '' Then
			$_StringLen = StringLen($_NameToAdd)
			MsgBox(0, 'Success', $_NameToAdd & @CRLF & @CRLF & _StringRepeat(' ', Round(($_StringLen - 27) / 1.4)) & 'has been added to Favorites')
		EndIf
	Else
		MsgBox(0, 'Error', 'This Radio is already in your Favorites')
	EndIf
EndFunc

Func _ShowFavorites()
	If GUICtrlRead($_ShowFavButton) = 'Show Favorites list' Then
		GUICtrlSetState($_ReMovFavButton, BitOr($GUI_ENABLE,$GUI_SHOW))
		GUICtrlSetState($_AddFavButton, BitOr($GUI_DISABLE, $GUI_HIDE))
		GUICtrlSetData($_ShowFavButton, "Hide Favorites list")
		_GetFavorites()
		_GUICtrlCreateListViewItems($_FavoritesArrayName)
		$_ShowFavorites = 1
	Else
		GUICtrlSetState($_ReMovFavButton, BitOR($GUI_DISABLE, $GUI_HIDE))
		GUICtrlSetState($_AddFavButton, BitOr($GUI_ENABLE, $GUI_SHOW))
		GUICtrlSetData($_ShowFavButton, "Show Favorites list")
		_GUICtrlCreateListViewItems($_ArrayName)
		$_ShowFavorites = 0
	EndIf
EndFunc

Func _ReMovFromFavorites()
	If $_ShowFavorites = 0 Then Return
	$_Index = _GUICtrlListView_GetSelectedIndices($_ListView)
	If($_Index <> "" ) Then
		For $_J = 1 To 1000
			$_Value = RegEnumVal($_Key & '\Favorites', $_J)
			If @error <> 0 Then ExitLoop
			$_RegRead = RegRead($_Key & '\Favorites', $_Value)
			$_StringSplit = StringSplit($_RegRead, '|')
			If _AlreadyInArray($_FavoritesArrayUrl, $_StringSplit[1]) Then
				RegDelete($_Key & '\Favorites', StringFormat("%03i", $_SimpleClick))
				$_RemovedStation = $_FavoritesArrayName[$_SimpleClick]
				_GetFavorites()
				_GUICtrlCreateListViewItems($_FavoritesArrayName)
				$_StringLen = StringLen($_RemovedStation)
				MsgBox(64, 'Success', $_RemovedStation & 'has been removed from Favorites')
				ExitLoop
			EndIf
		Next
	Else
		MsgBox (48, "Could not remove", "You must select an item before attempting a removal!")
	EndIf
EndFunc

Func _GetFavorites()
	ReDim $_FavoritesArrayUrl[1], $_FavoritesArrayName[1]
	For $_J = 1 To 1000
		$_Value = RegEnumVal($_Key & '\Favorites', $_J)
		If @error <> 0 Then ExitLoop
		$_RegRead = RegRead($_Key & '\Favorites', $_Value)
		$_StringSplit = StringSplit($_RegRead, '|')
		If @error <> 0 Then ExitLoop
		_ArrayAdd($_FavoritesArrayUrl, $_StringSplit[1])
		_ArrayAdd($_FavoritesArrayName, $_StringSplit[2])
	Next
	RegDelete($_Key & '\Favorites')
	For $_J = 1 To UBound($_FavoritesArrayName) - 1
		RegWrite($_Key & '\Favorites', StringFormat("%03i", $_J), "REG_SZ", $_FavoritesArrayUrl[$_J] & '|' & $_FavoritesArrayName[$_J])
	Next
EndFunc

Func _AlreadyInArray($_SearchArray, $_Item)
	$_Index = _ArraySearch($_SearchArray, $_Item, 0, 0, 0, 1)
	If @error Then
		Return False
	Else
		If $_Index <> 0 Then
			Return True
		Else
			Return False
		EndIf
	EndIf
EndFunc

Func _GuiCreate()
							$_Gui = GUICreate ( $_GuiTitle, $_GuiWidth, $_GuiHeight )
									 _GuiSkin ( $_TempData[2] )
								   GUISetIcon ( $_TempData[1] )
								GUISetOnEvent ( $GUI_EVENT_CLOSE, "_Terminate" )
		   $_PlayButton = GUICtrlCreateButton ( "Play", 15, 288, $_ButtonWidth, $_ButtonHeight )
								GUICtrlSetTip ( $_PlayButton, "Play Selected ShoutCast Station" )
							GUICtrlSetOnEvent ( $_PlayButton, "_Play" )
		   $_StopButton = GUICtrlCreateButton ( "Stop", 102, 288, $_ButtonWidth, $_ButtonHeight )
								GUICtrlSetTip ( $_StopButton, "Stop Listen" )
							GUICtrlSetOnEvent ( $_StopButton, "_Stop" )
		 $_AddFavButton = GUICtrlCreateButton ( "Add To Favorites", 378, 288, $_ButtonWidth * 1.5, $_ButtonHeight )
								GUICtrlSetTip ( $_AddFavButton, "Add Selected Station To Favorites" )
							GUICtrlSetOnEvent ( $_AddFavButton, "_AddToFavorites" )
		$_ShowFavButton = GUICtrlCreateButton ( "Show Favorites list", 378, 318, $_ButtonWidth * 1.5, $_ButtonHeight )
								GUICtrlSetTip ( $_ShowFavButton, "Show Favorites list" )
							GUICtrlSetOnEvent ( $_ShowFavButton, "_ShowFavorites" )
	   $_ReMovFavButton = GUICtrlCreateButton ( "Remove From Favorites", 378, 288, $_ButtonWidth * 1.5, $_ButtonHeight )
								GUICtrlSetTip ( $_ReMovFavButton, "Remove Selected Station From Favorites" )
							GUICtrlSetOnEvent ( $_ReMovFavButton, "_ReMovFromFavorites" )
							  GUICtrlSetState ( $_ReMovFavButton, $GUI_DISABLE )
		   $_ExitButton = GUICtrlCreateButton ( "Exit", 505, 318, $_ButtonWidth * 1.4, $_ButtonHeight )
								GUICtrlSetTip ( $_ExitButton, "Goodbye..." )
							GUICtrlSetOnEvent ( $_ExitButton, "_Terminate" )
		 $_SearchButton = GUICtrlCreateButton ( "Search", 15, 318, $_ButtonWidth, $_ButtonHeight )
								GUICtrlSetTip ( $_SearchButton, "Search ShoutCast Stations" )
							GUICtrlSetOnEvent ( $_SearchButton, "_Search" )
			 $_ComboBox1 = GUICtrlCreateCombo ( "Search by", 102, 318, 80, 30, 0x3 )
							   GUICtrlSetData ( $_ComboBox1, "Top|Genre|KeyWords", "" )
							GUICtrlSetOnEvent ( $_ComboBox1, "_GetTypeSearch" )
			 $_ComboBox2 = GUICtrlCreateCombo ( "Select Genre", 189, 318, 80, 30, 0x3 )
							   GUICtrlSetData ( $_ComboBox2, "60s|70s|80s|90s|Best Of|Big Band|Blues|Brazilian|Classic Jazz|Classic R&B|Classic Rock|C" & _
			"lassical|Cool Jazz|Country|Dance Pop|Disco|Electronic|Gospel|Grunge|Heavy Metal|Jazz|Pia" & _
			"no|Pop|Punk|Reggae|Rock|Hard Rock|Soft Rock|Top 40" )
							GUICtrlSetOnEvent ( $_ComboBox2, "_GetGenre" )
							  GUICtrlSetState ( $_ComboBox2, $GUI_HIDE )
				 $_InPut = GUICtrlCreateInput ( "Type KeyWords", 187, 318, 84, 21 )
							  GUICtrlSetState ( $_InPut, $GUI_HIDE )
			 $_ComboBox3 = GUICtrlCreateCombo ( "Max Results", 277, 318, 80, 30, 0x3 )
							   GUICtrlSetData ( $_ComboBox3, "10|20|30|40|50|60|70|80|90|100|200", "" )
							GUICtrlSetOnEvent ( $_ComboBox3, "_GetMaxResults" )
								GUISetBkColor ( 0x000000 )
				 $_Label = GUICtrlCreateLabel ( "", 390, 50, 216, 229 )
							  GUICtrlSetColor ( $_Label, 0xFFFF00 )
							   GUICtrlSetFont ( $_Label, 10, 400, 2 )
		  $_OldTheme = _SetThemeAppProperties ( -1 )
						   GUICtrlCreateGroup ( "ShoutCast Station Info", 379, 15, 239, 261, BitOR($BS_CENTER, $BS_FLAT) )
							  GUICtrlSetColor ( -1, 0xff0000 )
							   GUICtrlSetFont ( -1, 10, 400, 2 )
					   _SetThemeAppProperties ( $_OldTheme )
	   $_StatusBar = _GUICtrlStatusBar_Create ( $_Gui )
			$_Icons = _WinAPI_LoadShell32Icon ( 128 )
					_GUICtrlStatusBar_SetIcon ( $_StatusBar, 0, $_Icons )
			   _GUICtrlStatusBar_SetMinHeight ( $_StatusBar, 20 )
				   _GUICtrlStatusBar_SetParts ( $_StatusBar, $_ArrayParts )
					_GUICtrlStatusBar_SetText ( $_StatusBar, "Waiting...", 0 )
		   $_Progress = GUICtrlCreateProgress ( 0, 0, -1, -1, $PBS_SMOOTH )
							  GUICtrlSetState ( $_Progress, $GUI_HIDE )
		  $_HandleProgress = GUICtrlGetHandle ( $_Progress )
			   _GUICtrlStatusBar_EmbedControl ( $_StatusBar, 1, $_HandleProgress )
					_GUICtrlStatusBar_SetText ( $_StatusBar, "TinySCV by shanet and wakillon", 2 )
			$hVolSlider = GUICtrlCreateSlider ( 189, 288, 170, 20, $TBS_NOTICKS )
							   GUICtrlSetData ( $hVolSlider, 100 )
								GUICtrlSetTip ( $hVolSlider, "100 %VOL" )
								  GUISetState ( )
EndFunc

Func _Play()
	If $sMediaFile2 <> '' Then
		If $iPlaying = 1 Then
			GUICtrlSetData($_PlayButton, "Play")
			$iPlaying = 2
		Elseif ($iPlaying = 2) Then
			GUICtrlSetData($_PlayButton, "Pause")
			$iPlaying = 1
		Else
			If $sMediaFile2Old <> '' And $sMediaFile2 <> $sMediaFile2Old Then $sMediaFile2 = $sMediaFile2Old
			If $_ShowFavorites = 0 Then
				$_DisplayName = $_ArrayName[$_DoubleClick]
			Else
				$_DisplayName = $_FavoritesArrayName[$_SimpleClick]
			EndIf
			If $sMediaFile2 = $sMediaFile2Old Then $_DisplayName = $_DisplayNameOld
			$_DisplayNameOld = $_DisplayName
			_GUICtrlStatusBar_SetText($_StatusBar, "Trying to Connect", 0)
			$sMediaFile = $sMediaFile2
			$sMediaFile2Old = $sMediaFile2
			$_LastStationUrl = $sMediaFile2Old
			$oMediaControl.Run()
			GUICtrlSetData($_PlayButton, "Pause")
			$iPlaying = 1
		EndIf
		GUICtrlSetTip($_PlayButton, StringStripWS(StringLeft(GUICtrlRead($_PlayButton), 5), 7) & " Selected ShoutCast Station")
	EndIf
EndFunc

Func _Stop()
	$oMediaControl.stop()
	GUICtrlSetData($_PlayButton, "Play")
	GUICtrlSetTip($_PlayButton, "Play Selected ShoutCast Station")
	$sMediaFile = ''
	$sMediaFile2Old = ''
	$iPlaying = 0
	_GUICtrlStatusBar_SetText($_StatusBar, "Not Connected", 0)
	_GUICtrlStatusBar_SetText($_StatusBar, "TinySCV by shanet and wakillon", 2)
EndFunc

Func _GetTypeSearch()
	$_TypeSearch = GUICtrlRead($_ComboBox1)
	Select
		Case $_TypeSearch = 'Top'
			GUICtrlSetState($_ComboBox2, $GUI_HIDE)
			GUICtrlSetState($_InPut, $GUI_HIDE)
		Case $_TypeSearch = "Genre"
			GUICtrlSetState($_ComboBox2, $GUI_SHOW)
			GUICtrlSetState($_InPut, $GUI_HIDE)
		Case $_TypeSearch = "KeyWords"
			GUICtrlSetState($_ComboBox2, $GUI_HIDE)
			GUICtrlSetState($_InPut, $GUI_SHOW)
		Case Else
			$_TypeSearch = ''
			GUICtrlSetState($_ComboBox2, $GUI_HIDE)
			GUICtrlSetState($_InPut, $GUI_HIDE)
	EndSelect
EndFunc

Func _GetGenre()
	$_Genre = GUICtrlRead($_ComboBox2)
	$_BadSearch = False
	If $_Genre = 'Select Genre' Then
		$_Genre = ''
		$_BadSearch = True
	Else
		$_Genre = '&genre=' & $_Genre
	EndIf
	$_Genre = StringReplace($_Genre, ' ', '+')
EndFunc

Func _GetKeyWords()
	$_KeyWords = GUICtrlRead($_InPut)
	$_BadSearch = False
	If $_KeyWords = 'Select KeyWords' Then
		$_KeyWords = ''
		$_BadSearch = True
	Else
		$_KeyWords = '&search=' & StringReplace(StringStripWS($_KeyWords, 7), ' ', '+')
	EndIf
EndFunc

Func _GetMaxResults()
	$_MaxResults = GUICtrlRead($_ComboBox3)
	If $_MaxResults = 'Max Results' Then $_MaxResults = 30
	$_MaxResults = '&limit=' & $_MaxResults
EndFunc

Func _GetCurrentSong($_Host, $_Port = 8000, $_TimeOut = 1500)
	TCPStartup()
	Local $_Timer = TimerInit(), $_Shoutcast = TCPConnect($_Host, $_Port)
	If $_Shoutcast = -1 Then
		TCPShutdown()
		Return 0
	EndIf
	TCPSend($_Shoutcast, "GET / HTTP/1.0" & @CRLF & "Icy-MetaData:1" & @CRLF & @CRLF)
	While 1
		$_Recv = BinaryToString(TCPRecv($_Shoutcast, 1024))
		If $_Recv <> '' Then
			If StringInStr($_Recv, "StreamTitle=") Then
				$_CurrentSong = StringSplit($_Recv, "StreamTitle=", 1)
				$_CurrentSong = StringSplit($_CurrentSong[2], ";StreamUrl=", 1)
				TCPCloseSocket($_Shoutcast)
				TCPShutdown()
				Return _StringProper(StringReplace($_CurrentSong[1], "'", ""))
			EndIf
		EndIf
		If TimerDiff($_Timer) > $_TimeOut Then
			TCPCloseSocket($_Shoutcast)
			TCPShutdown()
			Return "N/A"
		EndIf
	WEnd
EndFunc

Func _GetStationUrlById($_StationId, $_DevIdkey)
	$_SourceCode = _GetSourceCode('http://yp.shoutcast.com/sbin/tunein-station.pls?id=' & $_StationId & '&k=' & $_DevIdkey)
	$_StationUrl = _StringBetween($_SourceCode, 'File', @LF)
	If Not @error Then
		For $_J = 0 To UBound($_StationUrl) - 1
			$_StringBetween = _StringBetween($_StationUrl[$_J], '=', '')
			If Not @error Then
				$_StationUrl[$_J] = $_StringBetween[0]
				If StringInStr($_StationUrl[$_J], '/stream/') = 0 Then Return $_StationUrl[$_J]
			EndIf
		Next
		Return
	EndIf
EndFunc

Func _GetStationName($_ArrayItem)
	$_StationName = _StringBetween($_ArrayItem, '', '"')
	If Not @error Then
		Return _StringProper(StringStripWS(StringRegExpReplace(StringReplace(StringReplace($_StationName[0], _
				' - a SHOUTcast.com member station', ''), '&amp;', '&'), "(?i)[^a-z0-9]", ' '), 7))
	EndIf
EndFunc

Func _GetStationListenerPeak($_ArrayItem)
	$_StationListenerPeak = _StringBetween($_ArrayItem, 'lc="', '"')
	If Not @error Then Return $_StationListenerPeak[0]
EndFunc

Func _GetStationContentType($_ArrayItem)
	$_StationContentType = _StringBetween($_ArrayItem, 'mt="', '"')
	If Not @error Then
		If StringInStr($_StationContentType[0], 'aacp') Then Return 'aac'
		If StringInStr($_StationContentType[0], 'mpeg') Then Return 'mp3'
	EndIf
EndFunc

Func _GetStationBitrate($_ArrayItem)
	$_StationBitrate = _StringBetween($_ArrayItem, '" br="', '"')
	If Not @error Then Return $_StationBitrate[0]
EndFunc

Func _GetStationGenre($_ArrayItem)
	$_StationGenre = _StringBetween($_ArrayItem, 'genre="', '"')
	If Not @error Then Return $_StationGenre[0]
EndFunc

Func _GetStationId($_ArrayItem)
	$_Id = _StringBetween($_ArrayItem, 'id="', '"')
	If Not @error Then Return $_Id[0]
EndFunc

Func _GetSourceCode($_Url)
	$_InetRead = InetRead($_Url)
	If Not @error Then
		$_BinaryToString = BinaryToString($_InetRead)
		If Not @error Then Return $_BinaryToString
	EndIf
EndFunc

Func _GuiSkin($_SheFilePath)
	$Dll = DllOpen($_TempData[3])
	DllCall($Dll, "int", "SkinH_AttachEx", "str", $_SheFilePath, "str", "mhgd")
	DllCall($Dll, "int", "SkinH_SetAero", "int", 1)
EndFunc

Func _SetThemeAppProperties($iTheme = -1)
	If Not StringInStr(@OSType, "WIN32_NT") Then Return 0
	Switch $iTheme
		Case -1
			Local $aOld_ThemeAppProperties = DllCall("Uxtheme.dll", "int", "GetThemeAppProperties")
			DllCall("Uxtheme.dll", "none", "SetThemeAppProperties", "int", 0)
			Return $aOld_ThemeAppProperties[0]
		Case Else
			DllCall("Uxtheme.dll", "none", "SetThemeAppProperties", "int", $iTheme)
	EndSwitch
EndFunc

Func _LevelMeter()
	Local $aCall = $oAudioMeterInformation.GetPeakValue(0)
	If IsArray($aCall) Then
		Local $iCurrentRead = 100 * $aCall[1]
		GUICtrlSetData($hLevMet, $iCurrentRead + 1)
		GUICtrlSetData($hLevMet, $iCurrentRead)
	EndIf
EndFunc

Func _AudioVolObject(ByRef $oAudioMeterInformation)
	Local Const $sCLSID_MMDeviceEnumerator = "{BCDE0395-E52F-467C-8E3D-C4579291692E}"
	Local Const $sIID_IMMDeviceEnumerator = "{A95664D2-9614-4F35-A746-DE8DB63617E6}"
	Global $dtagIMMDeviceEnumerator = $dtagIUnknown & _
			"EnumAudioEndpoints hresult(dword;dword;ptr*);" & _
			"GetDefaultAudioEndpoint hresult(dword;dword;ptr*);" & _
			"GetDevice hresult(wstr;ptr*);" & _
			"RegisterEndpointNotificationCallback hresult(ptr);" & _
			"UnregisterEndpointNotificationCallback hresult(ptr);"
	Local $dtagIMMDevice = $dtagIUnknown & _
			"Activate hresult(ptr;dword;variant*;ptr*);" & _
			"OpenPropertyStore hresult(dword;ptr*);" & _
			"GetId hresult(wstr*);" & _
			"GetState hresult(dword*);"
	Local Const $sIID_IAudioMeterInformation = "{C02216F6-8C67-4B5B-9D00-D008E73E0064}"
	Local $dtagIAudioMeterInformation = $dtagIUnknown & _
			"GetPeakValue hresult(float*);" & _
			"GetMeteringChannelCount hresult(dword*);" & _
			"GetChannelsPeakValues hresult(dword;float*);" & _
			"QueryHardwareSupport hresult(dword*);"
	Local $oMMDeviceEnumerator = _AutoItObject_ObjCreate($sCLSID_MMDeviceEnumerator, $sIID_IMMDeviceEnumerator, $dtagIMMDeviceEnumerator)
	If @error Then Return SetError(1, 0, 0)
	Local $aCall = $oMMDeviceEnumerator.GetDefaultAudioEndpoint(0, 0, 0)
	If Not IsArray($aCall) Then Return SetError(2, 0, 0)
	Local $oDefaultDevice = _AutoItObject_WrapperCreate($aCall[3], $dtagIMMDevice)
	Local $pIID_IAudioMeterInformation = _AutoItObject_CLSIDFromString($sIID_IAudioMeterInformation)
	$aCall = $oDefaultDevice.Activate(Number(DllStructGetPtr($pIID_IAudioMeterInformation)), 1, 0, 0)
	If Not IsArray($aCall) Then Return SetError(3, 0, 0)
	$oAudioMeterInformation = _AutoItObject_WrapperCreate($aCall[4], $dtagIAudioMeterInformation)
	Return True
EndFunc

Func _InitBuilder(ByRef $oGraphBuilder, ByRef $oMediaControl, ByRef $oBasicAudio)
	Local $sCLSID_FilterGraph = "{E436EBB3-524F-11CE-9F53-0020AF0BA770}"
	Local $sIID_IGraphBuilder = "{56A868A9-0AD4-11CE-B03A-0020AF0BA770}"
	Local $tIID_IMediaControl = _AutoItObject_CLSIDFromString("{56A868B1-0AD4-11CE-B03A-0020AF0BA770}")
	Local $tIID_IBasicAudio = _AutoItObject_CLSIDFromString("{56A868B3-0AD4-11CE-B03A-0020AF0BA770}")
	Local $dtagIGraphBuilder = $dtagIUnknown & _
			"AddFilter hresult(ptr;wstr);" & _
			"RemoveFilter hresult(ptr);" & _
			"EnumFilters hresult(ptr*);" & _
			"FindFilterByName hresult(wstr;ptr*);" & _
			"ConnectDirect hresult(ptr;ptr;ptr);" & _
			"Reconnect hresult(ptr);" & _
			"Disconnect hresult(ptr);" & _
			"SetDefaultSyncSource hresult();" & _
			"Connect hresult(ptr;ptr);" & _
			"Render hresult(ptr);" & _
			"RenderFile hresult(wstr;ptr);" & _
			"AddSourceFilter hresult(wstr;wstr;ptr*);" & _
			"SetLogFile hresult(dword_ptr);" & _
			"Abort hresult();" & _
			"ShouldOperationContinue hresult();"
	$oGraphBuilder = _AutoItObject_ObjCreate($sCLSID_FilterGraph, $sIID_IGraphBuilder, $dtagIGraphBuilder)
	If @error Then Return SetError(1, 0, False)
	Local $aCall = $oGraphBuilder.QueryInterface(Number(DllStructGetPtr($tIID_IMediaControl)), 0)
	If IsArray($aCall) And $aCall[2] Then
		$oMediaControl = _AutoItObject_PtrToIDispatch($aCall[2])
	Else
		Return SetError(2, 0, False)
	EndIf
	Local $pBasicAudio
	$aCall = $oGraphBuilder.QueryInterface(Number(DllStructGetPtr($tIID_IBasicAudio)), 0)
	If IsArray($aCall) And $aCall[2] Then
		$pBasicAudio = $aCall[2]
	Else
		Return SetError(3, 0, False)
	EndIf
	Local $dtagIBasicAudio = $dtagIDispatch & _
			"put_Volume hresult(long);" & _
			"get_Volume hresult(long*);" & _
			"put_Balance hresult(long);" & _
			"get_Balance hresult(long*);"
	$oBasicAudio = _AutoItObject_WrapperCreate($pBasicAudio, $dtagIBasicAudio)
	If @error Then Return SetError(4, 0, False)
	Return True
EndFunc

Func _ReleaseBuilder(ByRef $oGraphBuilder, ByRef $oMediaControl, ByRef $oBasicAudio)
	$oMediaControl.Stop()
	$oBasicAudio = 0
	$oMediaControl = 0
	$oGraphBuilder.Release()
	$oGraphBuilder = 0
EndFunc

Func _RenderFile(ByRef $sMediaFile)
	_ReleaseBuilder($oGraphBuilder, $oMediaControl, $oBasicAudio)
	_InitBuilder($oGraphBuilder, $oMediaControl, $oBasicAudio)
	If Not _WMAsfReaderLoad($sMediaFile) Then
		$oUSER32DLL.MessageBeep("int", "dword", 48)
		$sMediaFile = ""
		Return SetError(1, 0, False)
	EndIf
	$oCOMError.number = 0
	$oMediaControl.Run()
	If $oCOMError.number Then
		_GUICtrlStatusBar_SetText($_StatusBar, "Streaming failed", 0)
		GUICtrlSetData($_PlayButton, "Play")
		$iPlaying = 0
		$sMediaFile2Old = ''
	Else
		_GUICtrlStatusBar_SetText($_StatusBar, "Connected", 0)
		If $_DisplayName = '' Then $_DisplayName = $_DisplayName2
		_GUICtrlStatusBar_SetText($_StatusBar, 'To ' & StringLeft($_DisplayName, 23), 2)
	EndIf
	$sMediaFile = ""
	Return True
EndFunc

Func _WMAsfReaderLoad($sFile)
	Local Const $sCLSID_WMAsfReader = "{187463A0-5BB7-11d3-ACBE-0080C75E246E}"
	Local Const $sIID_IBaseFilter = "{56a86895-0ad4-11ce-b03a-0020af0ba770}"
	Local $dtagIBaseFilter = $dtagIUnknown & _
			"GetClassID hresult(ptr*);" & _
			"Stop hresult();" & _
			"Pause hresult();" & _
			"Run hresult(int64);" & _
			"GetState hresult(dword;dword*);" & _
			"SetSyncSource hresult(ptr);" & _
			"GetSyncSource hresult(ptr*);" & _
			"EnumPins hresult(ptr*);" & _
			"FindPin hresult(wstr;ptr*);" & _
			"QueryFilterInfo hresult(ptr*);" & _
			"JoinFilterGraph hresult(ptr;wstr);" & _
			"QueryVendorInfo hresult(wstr*);"
	Local $oBaseFilter = _AutoItObject_ObjCreate($sCLSID_WMAsfReader, $sIID_IBaseFilter, $dtagIBaseFilter)
	If @error Then Return SetError(1, 0, False)
	$oGraphBuilder.AddFilter($oBaseFilter.__ptr__, "anything")
	Local Const $sIID_IFileSourceFilter = "{56a868a6-0ad4-11ce-b03a-0020af0ba770}"
	Local $dtagIFileSourceFilter = $dtagIUnknown & _
			"Load hresult(wstr;ptr);" & _
			"GetCurFile hresult(ptr*;ptr);"
	Local $tIID_IFileSourceFilter = _AutoItObject_CLSIDFromString($sIID_IFileSourceFilter)
	Local $aCall = $oBaseFilter.QueryInterface(Number(DllStructGetPtr($tIID_IFileSourceFilter)), 0)
	If Not IsArray($aCall) Then Return SetError(2, 0, False)
	Local $oFileSourceFilter = _AutoItObject_WrapperCreate($aCall[2], $dtagIFileSourceFilter)
	$oFileSourceFilter.Load($sFile, 0)
	$aCall = $oFileSourceFilter.GetCurFile(0, 0)
	Local $pFile = $aCall[1]
	Local $sLoaded = DllStructGetData(DllStructCreate("wchar[" & __Au3Obj_PtrStringLen($pFile) + 1 & "]", $pFile), 1)
	__Au3Obj_CoTaskMemFree($pFile)
	$aCall = $oBaseFilter.EnumPins(0)
	If Not IsArray($aCall) Or Not $aCall[1] Then Return SetError(3, 0, False)
	Local $pEnum = $aCall[1]
	Local $dtagIEnumPins = $dtagIUnknown & _
			"Next hresult(dword;ptr*;dword*);" & _
			"Skip hresult(dword);" & _
			"Reset hresult();" & _
			"Clone hresult(ptr*);"
	Local $oEnum = _AutoItObject_WrapperCreate($pEnum, $dtagIEnumPins)
	Local $pPin
	While 1
		$aCall = $oEnum.Next(1, 0, 0)
		If Not IsArray($aCall) Then Return SetError(4, 0, False)
		$pPin = $aCall[2]
		If $pPin Then
			$oGraphBuilder.Render($pPin)
			_AutoItObject_IUnknownRelease($pPin)
		EndIf
		If $aCall[0] Then ExitLoop
	WEnd
	Return True
EndFunc

Func _Singleton($sOccurenceName, $iFlag = 0)
	Local Const $ERROR_ALREADY_EXISTS = 183
	Local Const $SECURITY_DESCRIPTOR_REVISION = 1
	Local $pSecurityAttributes = 0
	If BitAND($iFlag, 2) Then
		Local $tSecurityDescriptor = DllStructCreate("dword[5]")
		Local $pSecurityDescriptor = DllStructGetPtr($tSecurityDescriptor)
		Local $aRet = DllCall("advapi32.dll", "bool", "InitializeSecurityDescriptor", _
				"ptr", $pSecurityDescriptor, "dword", $SECURITY_DESCRIPTOR_REVISION)
		If @error Then Return SetError(@error, @extended, 0)
		If $aRet[0] Then
			$aRet = DllCall("advapi32.dll", "bool", "SetSecurityDescriptorDacl", _
					"ptr", $pSecurityDescriptor, "bool", 1, "ptr", 0, "bool", 0)
			If @error Then Return SetError(@error, @extended, 0)
			If $aRet[0] Then
				Local $structSecurityAttributes = DllStructCreate($tagSECURITY_ATTRIBUTES)
				DllStructSetData($structSecurityAttributes, 1, DllStructGetSize($structSecurityAttributes))
				DllStructSetData($structSecurityAttributes, 2, $pSecurityDescriptor)
				DllStructSetData($structSecurityAttributes, 3, 0)
				$pSecurityAttributes = DllStructGetPtr($structSecurityAttributes)
			EndIf
		EndIf
	EndIf
	Local $handle = DllCall("kernel32.dll", "handle", "CreateMutexW", "ptr", $pSecurityAttributes, "bool", 1, "wstr", $sOccurenceName)
	If @error Then Return SetError(@error, @extended, 0)
	Local $lastError = DllCall("kernel32.dll", "dword", "GetLastError")
	If @error Then Return SetError(@error, @extended, 0)
	If $lastError[0] = $ERROR_ALREADY_EXISTS Then
		If BitAND($iFlag, 1) Then
			Return SetError($lastError[0], $lastError[0], 0)
		Else
			Exit -1
		EndIf
	EndIf
	Return $handle[0]
EndFunc

Func _PlayLastListenedStation()
	$_RegReadLastStation = RegRead($_Key, 'LastListenedStation')
	If $_RegReadLastStation <> '' Then
		$_StringSplit = StringSplit($_RegReadLastStation, '|')
		If Not @error Then
			$sMediaFile2 = $_StringSplit[1]
			$_DisplayName2 = $_StringSplit[2]
			_Play()
		EndIf
	Else
		$sMediaFile2 = 'http://173.193.14.170:8004'
		$_DisplayName2 = 'Big R Radio - 100.5 Classic Rock'
		_Play()
	EndIf
EndFunc

Func _WinSetOnTopOneTime()
	WinWait($_GuiTitle, "", 2)
	WinSetOnTop($_GuiTitle, "", 1)
	Sleep(250)
	WinSetOnTop($_GuiTitle, "", 0)
	WinActivate($_GuiTitle, "")
EndFunc

Func _TrayMenu()
	TraySetIcon("Shell32.dll", -129)
	TraySetToolTip("Tiny Charts Jukebox" & @CRLF & "- LeftClick to Set Window On Top" & @CRLF & "- RightClick to Traymenu")
	TraySetOnEvent($TRAY_EVENT_PRIMARYUP, "_WinSetOnTopOneTime")
	TraySetIcon(@TempDir & "\TYD\Youtube.ico")
	$_StartItem = TrayCreateItem("Start With Windows")
	$_RegRead = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Run", $_TitleKey)
	ConsoleWrite("+->--- $_RegRead : " & $_RegRead & @CRLF)
	If $_RegRead <> '' Then TrayItemSetState($_StartItem, $TRAY_CHECKED)
	TrayItemSetOnEvent($_StartItem, "_StartWithWindows")
	TrayCreateItem("")
	$_AboutItem = TrayCreateItem("About")
	TrayItemSetOnEvent($_AboutItem, "_About")
	TrayCreateItem("")
	$_ShoutcastItem = TrayCreateItem("Open Shoutcast.com")
	TrayItemSetOnEvent($_ShoutcastItem, "_OpenShoutcast")
	TrayCreateItem("")
	$_AddRadioToFavoritesItem = TrayCreateItem("Add Manually Radio to Favorites")
	TrayItemSetOnEvent($_AddRadioToFavoritesItem, "_AddManuallyRadioToFavorites")
	TrayCreateItem("")
	$_ExitItem = TrayCreateItem("Exit")
	TrayItemSetOnEvent($_ExitItem, "_Terminate")
	TraySetClick(16)
	TraySetState(4)
EndFunc

Func _AddManuallyRadioToFavorites()
	TrayItemSetState($_AddRadioToFavoritesItem, $TRAY_UNCHECKED)
	$_UrlToAdd = InputBox("Add Radio To Favorites", "Enter Url and Port of a Station", "http://84.54.140.229:8000", "", 200, 50)
	$_NameToAdd = InputBox("Add Radio To Favorites", "Enter Station Name", "Station1", "", 200, 50)
	_GetFavorites()
	If Not _AlreadyInArray($_FavoritesArrayUrl, $_UrlToAdd) Then
		If $_UrlToAdd <> '' And $_NameToAdd <> '' Then
			RegWrite($_Key & '\Favorites', StringFormat("%03i", UBound($_FavoritesArrayUrl)), "REG_SZ", $_UrlToAdd & '|' & $_NameToAdd)
			$_StringLen = StringLen($_NameToAdd)
			If $_ShowFavorites = 1 Then
				_GetFavorites()
				_GUICtrlCreateListViewItems($_FavoritesArrayName)
			EndIf
			MsgBox(0, 'Success', $_NameToAdd & @CRLF & @CRLF & _StringRepeat(' ', Round(($_StringLen - 27) / 1.4)) & 'has been added to Favorites')
		Else
			MsgBox(0, 'Error', 'Station has not been added To Favorites')
		EndIf
	Else
		MsgBox(0, 'Error', 'This Radio is already in your Favorites')
	EndIf
EndFunc

Func _About()
	TrayItemSetState ( $_AboutItem, $TRAY_UNCHECKED )
	Local $_ProgramName="Tiny Shoutcast Tuner", $_ProgramVersion='1.0.0'
	MsgBox ( 64 + 8192, "About","   About" & @CRLF & @CRLF _
	& "   This software allows you to tune into shoutcast stations." & @CRLF _
	& "   A search may be run by using provided filters - Top, Genre, KeyWords" & @CRLF _
	& "   and Max number of Results." & @CRLF _
	& "   By clicking on a station, its info will be displayed." & @CRLF _
	& "   Double clicking on a station switches to that station." & @CRLF _
	& "   You can add stations to and remove from the Favorites," & @CRLF _
	& "   You can also manually add stations to Favorites by the tray context" & @CRLF _
	& "   menu." & @CRLF _
	& "   When you run the program, the station you were listening to when" & @CRLF _
	& "   you last closed is automatically played." & @CRLF _
	& "   This program has been tested successfully on XP Sp3 x86 and on" & @CRLF _
	& "   7 x86." & @CRLF & @CRLF _
	& "   I hope you enjoy using this software!" & @CRLF _
	& "   A shoutout to wakillon for his original version of this project, and to" & @CRLF _
	& "   trancexx for beginning the internet radio trend who are both from the" & @CRLF _
	& "   AutoIt forum :P" & @CRLF & @CRLF _
	& "   Shane Thompson" )
EndFunc

Func _OpenShoutcast()
	TrayItemSetState($_ShoutcastItem, $TRAY_UNCHECKED)
	ShellExecute('http://www.shoutcast.com/')
EndFunc

Func _StartWithWindows()
	If @Compiled Then
		$_ItemGetState = TrayItemGetState($_StartItem)
		If $_ItemGetState = 64 + 1 Then
			RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Run", $_TitleKey, "REG_SZ", @ScriptFullPath)
		Else
			RegDelete("HKCU\Software\Microsoft\Windows\CurrentVersion\Run", $_TitleKey)
		EndIf
	EndIf
EndFunc

Func _FileInstall()
	Local $info = false
	If Not FileExists(@TempDir & "\TST\skin") Then
		DirCreate(@TempDir & "\TST\skin")
		ConsoleWrite("Creating directory" & @CRLF)
	EndIf

	If Not FileExists($_TempData[3]) Then
		Run("iexplore.exe http://www.mediafire.com/?rf9fhj51fvflp2a")
		ConsoleWrite("Getting DLL file" & @CRLF)
		$info = true
	EndIf

	If Not FileExists($_TempData[2]) Then
		Run("iexplore.exe http://www.mediafire.com/?1irzpwc92ghp6u9")
		ConsoleWrite("Getting skin file" & @CRLF)
		$info = true
	EndIf

	If Not FileExists($_TempData[1]) Then
		Run("iexplore.exe http://www.mediafire.com/?e08nb789twvu35u")
		ConsoleWrite("Getting Icon file" & @CRLF)
		$info = true
	EndIf

	If $info Then
		MsgBox(0,"Installing","Unfortunately there is no available host in which the script can automate the download process. For this reason you must do so yourself. Interner Explorer should open with the tabs you require to download the files. If it did not, please visit this project's thread for links." & @CRLF & @CRLF & "Once you have downloaded them, you must move them to %TEMP%\TST\skin then you will be able to run this program.")
	EndIf

EndFunc

Func _Terminate()
	_ReleaseBuilder($oGraphBuilder, $oMediaControl, $oBasicAudio)
	$oAudioMeterInformation = 0
	If $_LastStationUrl <> '' And $_DisplayName <> '' Then _
			RegWrite($_Key, 'LastListenedStation', "REG_SZ", $_LastStationUrl & '|' & $_DisplayName)
	Exit
EndFunc

Func _ErrFunc()
	If $oCOMError.windescription <> '' Then ConsoleWrite("!->--- COM Error !  Number: 0x" & Hex($oCOMError.number, 8) & "   ScriptLine: " & $oCOMError.scriptline & " - " & $oCOMError.windescription & @CRLF)
EndFunc
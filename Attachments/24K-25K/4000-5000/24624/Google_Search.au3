;================================================================================
;#  Title .........: Google Search.au3											#
;#  Description ...: Make Google search for websites or images					#
;#  Date ..........: 14.02.09													#
;#  Version .......: 1.0.4														#
;#  Author ........: FireFox                                                    #
;#           ©  2008 d3mon Corporation											#
;================================================================================

#include <IsPressed_UDF.au3>
#NoTrayIcon

Opt('GuiOnEventMode', 1)
Opt('WinWaitDelay', 20)

#Region Url
Local $s_weburl = '&btnG=Recherche+Google&meta=&aq=f&oq='
Local $s_imgurl = "&btnG=Recherche+d'images&gbv=2"
Local $s_luckyurl = '&btnI=I%27m+Feeling+Lucky&aq=f&oq='
Local $s_site = '&as_sitesearch=', $cfg = @TempDir & '\GoogleSearch.cfg'
#EndRegion Url

#Region FF
Local $FFwin = '[CLASS:MozillaWindowClass]'
Local $FFctrl = '[CLASS:MozillaWindowClass; INSTANCE:1]'
Local $FFExe = @ProgramFilesDir & '\Mozilla Firefox\firefox.exe'
Local $FFh = WinGetHandle($FFwin)
Local $cgh = ControlGetHandle($FFwin, '', '[CLASS:MozillaWindowClass; INSTANCE:1]')
#EndRegion FF
;

#Region check
$r_lang = FileRead($cfg)
FileDelete($cfg)
FileInstall('Firefox.jpg', @TempDir & '\Firefox.jpg', 1)
FileInstall('Exit.jpg', @TempDir & '\Exit.jpg', 1)

If Not ProcessExists('firefox.exe') Then ShellExecute($FFExe)
#EndRegion check
;

#Region GUI
$GUI = GUICreate('Google Search - Firefox', 468, 276, -1, -1, -2139095040)
GUISetOnEvent(-7, '_Drag', $GUI)
GUICtrlCreatePic(@TempDir & '\Firefox.JPG', 0, 0, 468, 276, 128)

GUICtrlCreatePic(@TempDir & '\Exit.JPG', 450, 5, 14, 14)
GUICtrlSetOnEvent(-1, '_Exit')

$l_gs = GUICtrlCreateLabel('Google Search', 30, 10, 220, 37)
GUICtrlSetFont($l_gs, 25, 400, 2, 'Arial')
_SetAttrib($l_gs, 0x000000)
GUICtrlSetCursor($l_gs, 4)
GUICtrlSetOnEvent($l_gs, '_About')

$b_lt = GUICtrlCreateLabel('Language Tools', 370, 35, 80, 15)
GUICtrlSetOnEvent($b_lt, '_Languagetool')
GUICtrlSetCursor($b_lt, 0)
_SetAttrib($b_lt, 0x0000FF)

$b_iw = GUICtrlCreateLabel('Web', 310, 35, 35, 15)
GUICtrlSetOnEvent($b_iw, '_Switch')
GUICtrlSetCursor($b_iw, 0)
_SetAttrib($b_iw, 0x0000FF)

#Region Search
$s_search = GUICtrlCreateEdit('', 10, 55, 447, 20, 128)
GUICtrlSetCursor(-1, 5)

GUICtrlCreateButton('Search', 30, 80, 70, 20)
GUICtrlSetOnEvent(-1, '_Search')

GUICtrlCreateButton("I' m Feeling Lucky", 120, 80, 100, 20)
GUICtrlSetOnEvent(-1, '_Lucky')

GUICtrlCreateGroup('', 10, 107, 155, 125)
GUICtrlCreateLabel('Country :', 20, 122)
_SetAttrib(-1, 0xFFFFFF)
#EndRegion Search

$c_lang = GUICtrlCreateCombo($r_lang, 70, 118, 80, 20, 0x3)
GUICtrlSetData(-1, 'COM.TR|COM.MX|COM.AR|COM.AU|COM.BR|CO.UK|' & _
		'CO.JP|CO.ZA|CO.IN|CO.TH|COM|FR|NL|BE|DK|ES|PT|CN', $r_lang)

#Region CheckBox
$c_wp = GUICtrlCreateCheckbox('', 20, 147, 14, 15)
GUICtrlCreateLabel('Exact keyword(s)', 37, 148)
_SetAttrib(-1, 0xFFFFFF)
$c_wo = GUICtrlCreateCheckbox('', 20, 162, 14, 15)
GUICtrlCreateLabel('Word(s) only', 37, 163)
_SetAttrib(-1, 0xFFFFFF)
$c_po = GUICtrlCreateCheckbox('', 20, 177, 14, 15)
GUICtrlCreateLabel('Phrase only', 37, 178)
_SetAttrib(-1, 0xFFFFFF)
$c_ws = GUICtrlCreateCheckbox('', 20, 192, 14, 15)
GUICtrlCreateLabel('Site search', 37, 193)
_SetAttrib(-1, 0xFFFFFF)
$c_ss = GUICtrlCreateCheckbox('', 20, 207, 14, 15)
GUICtrlCreateLabel('Safe search', 37, 208)
_SetAttrib(-1, 0xFFFFFF)
#EndRegion CheckBox

DllCall('user32.dll', 'int', _
		'AnimateWindow', 'hwnd', $GUI, _
		'int', 300, 'long', 0x00080000)
GUISetState(@SW_SHOW, $GUI)
#EndRegion GUI
;


#Region Func
Func _About()
	MsgBox(64, 'Google Search - About', 'Author(s) : FireFox' & _
			@CRLF & '• Thanks to monoceres for help' & _
			@CRLF & '• Thanks to Ealric for Google Hack' & _
			@CRLF & @CRLF & 'Contact : d3mon@live.fr')
EndFunc   ;==>_About

Func _SetAttrib($c_ID, $color)
	GUICtrlSetColor($c_ID, $color)
	GUICtrlSetBkColor($c_ID, -2)
EndFunc   ;==>_SetAttrib

Func _Switch()
	If (GUICtrlRead($b_iw) = 'Web') Then
		GUICtrlSetData($b_iw, 'Images')
	Else
		GUICtrlSetData($b_iw, 'Web')
	EndIf
EndFunc   ;==>_Switch

Func _Languagetool()
	_AddTABURL('                 .' & GUICtrlRead($c_lang) & '/language_tools?hl=' & GUICtrlRead($c_lang))
EndFunc   ;==>_Languagetool

Func _Lucky()
	If (GUICtrlRead($s_search) = '') Then Return
	$lang = GUICtrlRead($c_lang)
	$s_string = StringReplace(GUICtrlRead($s_search), ' ', '+')
	$s_url = '                 .' & $lang & '/search?hl=' & $lang & '&q=' & $s_string & $s_luckyurl
	_AddTABURL(_WriteURL($s_url))
EndFunc   ;==>_Lucky

Func _Search()
	If (GUICtrlRead($s_search) = '') Then Return
	$lang = GUICtrlRead($c_lang)
	
	If (GUICtrlRead($b_iw) = 'Web') Then
		$s_string = StringReplace(GUICtrlRead($s_search), ' ', '+')
		$s_tmpurl = '                 .' & $lang & '/search?hl=' & $lang & '&q='
		
		If (GUICtrlRead($c_ws) = 1) Then
			$s_url = $s_tmpurl & $s_site & $s_string & $s_weburl
			$url = _WriteURL($s_url)
		Else
			$s_url = $s_tmpurl & $s_string & $s_weburl
			$url = _WriteURL($s_url)
		EndIf
		_AddTABURL($url)
	Else
		$s_string = StringReplace(GUICtrlRead($s_search), ' ', '+')
		$s_tmpurl = '                    .' & $lang & '/images?hl=' & $lang & '&q='
		
		$s_url = $s_tmpurl & $s_string & $s_imgurl
		_AddTABURL(_WriteURL($s_url))
	EndIf
EndFunc   ;==>_Search

Func _AddTABURL($s_url)
	If Not WinActive($FFh) Then WinActivate($FFh)
	Sleep(300) ;-Wait FF window--------
	ControlSend($FFh, '', '', '^t')
	ControlSend($cgh, '', '', $s_url)
	ControlSend($cgh, '', '', '{ENTER}')
EndFunc   ;==>_AddTABURL

Func _WriteURL($s_url)
	If (GUICtrlRead($c_wp) = 1) Then
		$s_url &= '&as_q='
	EndIf
	If (GUICtrlRead($c_wo) = 1) Then
		$s_url &= '&as_oq='
	EndIf
	If (GUICtrlRead($c_po) = 1) Then
		$s_url &= '&as_epq='
	EndIf
	If (GUICtrlRead($c_ss) = 1) Then
		$s_url &= '&safe='
	EndIf
	
	Return $s_url
EndFunc   ;==>_WriteURL

Func _Drag()
	GUISetCursor(9, 1, $GUI)
	DllCall('user32.dll', 'int', _
			'SendMessage', 'hWnd', $GUI, _
			'int', 0x00A1, 'int', 2, 'int', 0)
	GUISetCursor(-1, 1, $GUI)
EndFunc   ;==>_Drag

Func _Exit()
	DllCall('user32.dll', 'int', _
			'AnimateWindow', 'hwnd', $GUI, _
			'int', 300, 'long', 0x00050008)
	FileWrite($cfg, GUICtrlRead($c_lang))
	Exit ;Exit Script ------
EndFunc   ;==>_Exit
#EndRegion Func
;

While 1
	Sleep(250)
	If _IsPressed('0D') Then _Search()
	If _IsPressed('1B') Then _Exit()
WEnd
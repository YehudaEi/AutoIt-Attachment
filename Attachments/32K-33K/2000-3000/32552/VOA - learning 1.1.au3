#Notrayicon 

#include <IE.au3>
#include <Array.au3>
#include <Excel.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#Include <String.au3>
#include <INet.au3>
#include <SQLite.au3>
#include <SQLite.dll.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>
#include <Sound.au3>
#include <GuiSlider.au3>
#include <GuiEdit.au3>
#include <GuiRichEdit.au3>
#Include <GuiListBox.au3>

#region Main

dim $oIE
dim $sound
dim $arrHREF[1]
dim $soundLength

checkInternetConnection()

Opt("GUIOnEventMode", 1) 

$hGUI = GUICreate("Mini English Tools v0.9 - truongkimminh@gmail.com", 800, 600) 

$mylist = _GUICtrlListBox_Create($hGUI, "", 10, 50, 350, 99 )

GUICtrlCreateLabel("VOA Learning English", 10, 170) ; 
GUICtrlCreateLabel("Google Translation", 410, 170) ; 
$theSource = _GUICtrlRichEdit_Create($hGUI,"" & @CRLF, 10, 190, 350,400,$ES_MULTILINE + $WS_VSCROLL)
$theResult = _GUICtrlRichEdit_Create($hGUI,"" & @CRLF, 410, 190, 350,400,$ES_MULTILINE + $WS_VSCROLL)


_GUICtrlRichEdit_SetEventMask($theSource, BitOR($ENM_SCROLL, $ENM_SCROLLEVENTS))

GUICtrlCreateLabel("Choose topic", 10, 20) 
$topic = GUICtrlCreateCombo("usa", 80, 20, 100, 20) 
GUICtrlSetData(-1, "world|us-history|american-life|arts-entertainment|health|education|business|agriculture|science-technology", "usa") 


$languageSelector = GUICtrlCreateCombo("English", 410, 20) 
GUICtrlSetData($languageSelector, "Vietnamese", "English") 



$soundProgress = _GUICtrlSlider_Create($hGUI, 410, 40, 350, 10, BitOR($TBS_TOOLTIPS, $TBS_AUTOTICKS))
$lbl_Sound = GUICtrlCreateLabel("", 680, 60) 

$btn_select = GUICtrlCreateButton("Select", 300, 140, 60)

$btn_PlayResume = GUICtrlCreateButton("Play", 410, 70, 60)
$btn_Stop = GUICtrlCreateButton("Stop", 500, 70, 60)


GUICtrlSetOnEvent($btn_PlayResume, "btn_PlayResume_onClick")
GUICtrlSetOnEvent($btn_Stop, "btn_Stop_onClick")

GUICtrlSetOnEvent($btn_select, "listSeletecd")
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")

GUICtrlSetOnEvent($topic, "topicSelected")
GUISetState(@SW_SHOW)
GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
Sleep(1000)

topicSelected()



; Run the GUI until the dialog is closed
While 1
	updateScroll()
	updateSoundSlider()
	
	Sleep(100)
WEnd

_IEQuit($oIE)
ConsoleWrite("Finish..." & @CRLF)
Exit

#endregion


Func checkInternetConnection()
	$var = Ping("http://www.voanews.com",6000)
	if @error <> 0 then 
		;MsgBox(64,$msgTitle ,"Error: Cannot connect to the internet !!!")
		 RunWait ( @ComSpec & " /c netsh interface ip set dns Local static 8.8.8.8" )
		 RunWait ( @ComSpec & " /c netsh interface ip add dns Local 8.8.4.4" )
		;Exit
	endif
EndFunc

Func getVOA($xtopic)
	GUICtrlSetState ($btn_select,$GUI_DISABLE)
	$oIE = _IECreate("http://www.voanews.com/learningenglish/home/" & $xtopic,0,0,1)

	_GUICtrlListBox_BeginUpdate($mylist)
    _GUICtrlListBox_ResetContent($mylist)
	dim $iIndex
	
	$iIndex = 0
	; top story
	$oElement =  _IETagNameGetCollection($oIE, "h2",1)
	_GUICtrlListBox_InsertString($mylist,$oElement.innerText)
	;
	dim $x
	$x =  _StringBetween($oElement.innerhtml,'<A href="','">')
	$arrHREF[0] = $x[0]
	
	; more story
	$oElements =  _IETagNameGetCollection($oIE, "h3")
	dim $i
	$i=0
 	For $oElement In $oElements
		if $i>=14 Then
			ExitLoop
		EndIf
		$i=$i+1
		if $i > 5 Then
			$iIndex=$iIndex+1
			_GUICtrlListBox_InsertString($mylist,$oElement.innerText,-1)
			$x =  _StringBetween($oElement.innerhtml,'<A href="','">')
			_ArrayAdd($arrHREF, $x[0])
		EndIf
	Next
	
	_GUICtrlListBox_EndUpdate($mylist)
	GUICtrlSetState ($btn_select,$GUI_ENABLE)
EndFunc

Func getSelectedVOANews($x)
	_IENavigate ($oIE,$x)
	$sHTML = _IEDocReadHTML ($oIE)
	$h2 = _StringBetween($sHTML,'<H2>', '</H2>')
	$title = $h2[1]
	$title  = StringReplace($title ," ","_")
	$oLinks = _IELinkGetCollection($oIE)
	
	$contentDiv = _IEGetObjById ($oIE, "wordclickDiv")

	$contentSource = _IEPropertyGet($contentDiv, "innertext")
	$contentSource = StringReplace($contentSource,"Or download MP3 (Right-click or option-click and save link) ","")
	$contentSource  = StringRight ($contentSource, StringLen($contentSource) - 8)
	
	
	For $oLink in $oLinks
		$sLinkText = _IEPropertyGet($oLink, "innerText")
		If StringInStr($sLinkText, "download MP3") Then
			dim $hDownload
			$hDownload = InetGet($oLink.href, getFileName($oLink.href) & "",1,1)
			Do
				Sleep(250)
			Until InetGetInfo($hDownload, 2)
			
			ExitLoop
		EndIf
	Next
	
	$contentResult = getTranslate($contentSource)
	_GUICtrlRichEdit_SetText ($theSource,$contentSource)
	_GUICtrlRichEdit_SetText ($theResult,$contentResult)
	

	loadSound($title & ".mp3")
	Sleep(1000)
EndFunc

Func getTranslate($x)
	_IENavigate ($oIE,"http://translate.google.com/#en|vi|")
	$source_input = _IEGetObjById ($oIE, "source")
	$submit_button = _IEGetObjById ($oIE, "gt-submit")
	
	_IEFormElementSetValue ($source_input, $x)
	_IEAction ($submit_button,"click")
	_IELoadWait ($oIE)
	$result_destination = _IEGetObjById ($oIE, "result_box")
	Return  _IEPropertyGet($result_destination, "innertext")
EndFunc

Func loadSound($x)
	$sound = _SoundOpen($x)
	If @error <> 0 Then
		MsgBox(0, "Error", "ERROR")
		_IEQuit($oIE)
		Exit
	EndIf
	$soundLength = _SoundLength($sound, 2)
	_GUICtrlSlider_SetRangeMax($soundProgress, $soundLength)
EndFunc


Func btn_PlayResume_onClick()
	_SoundPlay($sound,0)
EndFunc

Func btn_Stop_onClick()
	_SoundStop($sound)
EndFunc

Func CLOSEClicked()
	_IEQuit($oIE)
	Exit
EndFunc

Func updateScroll()
	$scroll = _GUICtrlRichEdit_GetScrollPos($theSource)
	_GUICtrlRichEdit_SetScrollPos($theResult,$scroll[0],$scroll[1])
EndFunc

Func getChar()
	$pos = MouseGetPos()
	$x = _GUICtrlRichEdit_GetCharPosFromXY($theSource,$pos[0],$pos[1])
	
EndFunc

Func updateSoundSlider()
	;if _SoundStatus ($sound) <> 0 then
		_GUICtrlSlider_SetPos ($soundProgress,_SoundPos($sound, 2))
		GUICtrlSetData($lbl_Sound,_SoundPos($sound, 1) & " - " & _SoundLength($sound, 1))
	;EndIf
EndFunc

Func listSeletecd()
	GUICtrlSetState ($btn_select,$GUI_DISABLE)
	$selectedIndex = _GUICtrlListBox_GetCurSel($mylist)
	$sMyString = _GUICtrlListBox_GetText($mylist,$selectedIndex )
	getSelectedVOANews($arrHREF[$selectedIndex])
	GUICtrlSetState ($btn_select,$GUI_ENABLE)
EndFunc

Func topicSelected()
	getVOA(GUICtrlRead ($topic))
	Sleep(1000)
EndFunc


Func WM_NOTIFY($hWnd, $iMsg, $iWparam, $iLparam)
    ; $tagEN_MSGFILTER = hwnd hWndFrom;uint_ptr IDFrom;INT Code;uint msg;wparam wParam;lparam lParam
    #forceref $iMsg, $iWparam
    Local $hWndFrom, $iCode, $tNMHDR, $tMsgFilter, $hMenu
    $tNMHDR = DllStructCreate($tagNMHDR, $iLparam)
    $hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
    $iCode = DllStructGetData($tNMHDR, "Code")
	
	Switch $hWndFrom
        Case $theSource
            Select
                Case $iCode = $EN_MSGFILTER
                    $tMsgFilter = DllStructCreate($tagEN_MSGFILTER, $iLparam)
                    $aPos = _GUICtrlRichEdit_GetScrollPos($theSource)
                    Switch DllStructGetData($tMsgFilter, "msg")
                        ;Case 276
                            ;ConsoleWrite("Debug: Horz Scroll: x = " & $aPos[0] & "; y = " & $aPos[1] & @LF)
                        Case 277
                            ;ConsoleWrite("Debug: Vert Scroll: x = " & $aPos[0] & "; y = " & $aPos[1] & @LF)
							updateScroll()
                    EndSwitch
            EndSelect
    EndSwitch
    Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY

Func getFileName($x)
	$nOffset = 1
	While 1
		$array = StringRegExp($x,"/",1,$nOffset)
		If @error = 0 Then
			$nOffset = @extended
		Else
			ExitLoop
		EndIf
	WEnd
	Return StringMid($x,$nOffset)
EndFunc
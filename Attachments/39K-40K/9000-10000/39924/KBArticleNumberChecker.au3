#include-once

#region #### AutoIt Includes ####
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <ListViewConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <IE.au3>
#include <GuiListView.au3>
#endregion #### AutoIt Includes ####

#region #### AutoItSetOptions ####
Opt('TrayIconDebug', 0)
Opt('GUIOnEventMode', 1)
Opt('TrayMenuMode', 1)
Opt('MustDeclareVars', 1)
Opt("WinTitleMatchMode", 1)
#endregion #### AutoItSetOptions ####

Global Const $iMsgBoxStop = 16 + 8192 + 262144

; Draw the GUI
Local $Form1 = GUICreate("KB Article Number Checker", 446, 244, 739, 191, BitOR($GUI_SS_DEFAULT_GUI, $WS_SIZEBOX, $WS_THICKFRAME))
GUISetOnEvent($GUI_EVENT_CLOSE, "Form1Close")
Local $KBArticle_inp = GUICtrlCreateInput("980373", 130, 21, 73, 21)
GUICtrlSetLimit(-1, 9)
;~ GUICtrlSetOnEvent(-1, "KBArticle_inpChange")
GUICtrlSetTip(-1, "Enter 6 or 7 digit KB number")
Local $KBArticle_lbl = GUICtrlCreateLabel("KB Article Number   KB", 16, 24, 113, 17)
;~ GUICtrlSetOnEvent(-1, "KBArticle_lblClick")
Local $Search_btn = GUICtrlCreateButton("Search", 224, 19, 75, 25)
GUICtrlSetTip(-1, "Search Microsoft Update Catalog for update info")
GUICtrlSetOnEvent(-1, "Search_btnClick")
Local $SupersededByInfo_lv = GUICtrlCreateListView("This update has been replaced by the following updates", 10, 150, 425, 82, -1, BitOR($WS_EX_CLIENTEDGE, $LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT))
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 421)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_LV_ALTERNATE) ; Set back colour for Hotfix listview..
;~ GUICtrlSetOnEvent(-1, "SupersededByInfo_lvClick")
Local $SupersedesInfo_lv = GUICtrlCreateListView("This update replaces the following updates", 10, 55, 425, 82, -1, BitOR($WS_EX_CLIENTEDGE, $LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT))
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 421)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_LV_ALTERNATE) ; Set back colour for Hotfix listview..
;~ GUICtrlSetOnEvent(-1, "SupersedesInfo_lvClick")
GUISetState(@SW_SHOW)


While 1
	Sleep(100)
WEnd

Func Form1Close()
	Exit
EndFunc   ;==>Form1Close

Func Search_btnClick()
	Local $sDescription = 'Security Update for Microsoft Office Outlook 2003 (KB980373)'
	Local $sKBArticleNumber = StringRegExpReplace(GUICtrlRead($KBArticle_inp), '\D', '')
	Local $sErrorFunc

	_GUICtrlListView_DeleteAllItems($SupersededByInfo_lv)
	_GUICtrlListView_DeleteAllItems($SupersedesInfo_lv)

	; no number entered
	If $sKBArticleNumber = '' Then
		MsgBox($iMsgBoxStop, 'Dumbass', 'No digits entered')
		Return
	Else
		Local $iStringLen = StringLen($sKBArticleNumber)
		; string wrong length
		If $iStringLen < 6 Or $iStringLen > 7 Then
			MsgBox($iMsgBoxStop, 'Dumbass', '6 or 7 digit KB Number required')
			Return
		EndIf
	EndIf

	$sKBArticleNumber = 'KB' & $sKBArticleNumber
	; set the starting page
	Local $sHomePage = 'http://catalog.update.microsoft.com'
	; open an IE window and navigate to the starting page
	Local $oIE = _IECreate($sHomePage)

	If Not @error Then
		; wait for the page to load
		_IELoadWait($oIE)

		If Not @error Then
			; get the starting url (will be something like http://catalog.update.microsoft.com/v7/site/Home.aspx)
			Local $sStartingUrl = _IEPropertyGet($oIE, "locationurl")

			If Not @error Then
				; get the search input object
				Local $oSearchBox = _IEGetObjByName($oIE, "searchTextBox")

				If Not @error Then
					; ensure it has focus (always seems to on first loading)
					_IEAction($oSearchBox, "focus")

					If Not @error Then
						Local $hwnd = _IEPropertyGet($oIE, "hwnd")

						If Not @error Then
							ControlSend($hwnd, "", "[CLASS:Internet Explorer_Server; INSTANCE:1]", $sKBArticleNumber & '{ENTER}')
							; click the link
							_IELoadWait($oIE)

							If Not @error Then
								; attach to the open window
								$oIE = _IEAttach($sKBArticleNumber, 'URL')

								Local $oElement = _IETagNameGetCollection($oIE, "a")

								If Not @error Then
									For $Element In $oElement
										; if the update description is found
										If StringInStr($Element.innertext, $sDescription) Then
											; click on the update link
											$Element.click
										EndIf
									Next

									_IEQuit($oIE)
									; wait for window to load. (need a better solution)
									MsgBox(0, 'waiting', 'close when window loaded')
									; popup window should have opened so attach to it
									; would be better to get the actual updateid to use for checking
									$oIE = _IEAttach('updateid=', 'URL')

									If Not @error Then
										Local $aArray
										$oElement = _IETagNameGetCollection($oIE, "div")

										If Not @error Then
											For $Element In $oElement
												; if the update description is found
												If $Element.id == 'supersedesInfo' Then
													$aArray = StringSplit(StringRegExpReplace($Element.innertext, '\r', ''), @LF)

													For $i = 1 To $aArray[0]
														; Add the current item to the listview.
														GUICtrlCreateListViewItem($aArray[$i], $SupersedesInfo_lv)
														GUICtrlSetBkColor(-1, 0xFCF6EA) ; Alternate the back colour
													Next
												ElseIf $Element.id == 'supersededbyInfo' Then
													$aArray = StringSplit($Element.innertext, @LF)

													For $i = 1 To $aArray[0]
														; Add the current item to the listview.
														GUICtrlCreateListViewItem($aArray[$i], $SupersededByInfo_lv)
														GUICtrlSetBkColor(-1, 0xFCF6EA) ; Alternate the back colour
													Next
												EndIf
											Next
											_IEQuit($oIE)
										Else
											$sErrorFunc = '_IETagNameGetCollection'
										EndIf
									Else
										$sErrorFunc = '_IEAttach'
									EndIf
								Else
									$sErrorFunc = '_IETagNameGetCollection'
								EndIf
							Else
								$sErrorFunc = '_IELoadWait'
							EndIf
						Else
							$sErrorFunc = '_IEPropertyGet'
						EndIf
					Else
						$sErrorFunc = '_IEAction'
					EndIf
				Else
					$sErrorFunc = '_IEGetObjByName'
				EndIf
			Else
				$sErrorFunc = '_IEPropertyGet'
			EndIf
		Else
			$sErrorFunc = '_IELoadWait'
		EndIf
	Else
		$sErrorFunc = '_IECreate'
	EndIf

	If @error Then _ErrorHandler($sErrorFunc, @error, @extended)
EndFunc   ;==>Search_btnClick

Func _ErrorHandler($sFunction, $iError = '', $iExtended = '')
	Local $sError = '', $sExtended = ''

	Switch $sFunction
		Case '_IECreate', '_IELoadWait', '_IEPropertyGet', '_IEGetObjByName', '_IEAction', '_IEAttach', '_IETagNameGetCollection'
			If $iError <> '' Then
				Switch $iError
					Case 0
						$sError = 'No Error'
					Case 1
						$sError = 'General Error'
					Case 3
						$sError = 'Invalid Data Type'
					Case 4
						$sError = 'Invalid Object Type'
					Case 5
						$sError = 'Invalid Value'
					Case 6
						$sError = 'Load Wait Timeout'
					Case 7
						$sError = 'No Match'
					Case 8
						$sError = 'Access Is Denied'
					Case 9
						$sError = 'Client Disconnected'
				EndSwitch
			EndIf

			If $iExtended <> '' Then
				Switch $sFunction
					Case '_IEPropertyGet', '_IEAction', '_IEGetObjByName', '_IETagNameGetCollection', '_IEAttach'
						$sExtended = 'Parameter number ' & $iExtended
					Case Else
						If $iExtended = 0 Then $sExtended = 'Created New Browser'
						If $iExtended = 1 Then $sExtended = 'Attached to Existing Browser'
				EndSwitch
			EndIf
	EndSwitch

	MsgBox($iMsgBoxStop, 'Error', 'Function : ' & $sFunction & @CRLF & 'Error       : ' & $sError & @CRLF & 'Extended: ' & $sExtended)
EndFunc   ;==>_ErrorHandler
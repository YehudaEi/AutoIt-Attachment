#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w- 7

#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Constants.au3>

#Include <WinAPIEx.au3>
#include <Array.au3>
#include <gdiplus.au3>
#include <GuiTab.au3>

Global Const $tagSCNotification = "hwnd hWndFrom;" & _; You might wan't to use another structure, because this ones has things not used for this but I don't feel like adding the right one atm
		"int IDFrom;" & _
		"int Code;" & _
		"int position;" & _
		"int ch;" & _
		"int modifiers;" & _
		"int modificationType;" & _
		"ptr text;" & _
		"int length;" & _
		"int linesAdded;" & _
		"int message;" & _
		"dword wParam;" & _
		"dword lParam;" & _
		"int line;" & _
		"int foldLevelNow;" & _
		"int foldLevelPrev;" & _
		"int margin;" & _
		"int listType;" & _
		"int x;" & _
		"int y;"

Global $Editor_UI
Global $Editor_UI_Style = BitOR($WS_CAPTION, $WS_SYSMENU, $WS_THICKFRAME, $WS_MINIMIZEBOX, $WS_MAXIMIZEBOX, $WS_CLIPCHILDREN); Take note about $WS_CLIPCHILDREN, we will remove it when needed because this style interferes with normal operation
Global $Editor_UI_StyleEx = -1

Global $UI_WIDTH = 600
Global $UI_HIGHT = 350

#region - Tabs

Global $Tabs[55][5]; Sci control, tabs and file info array
#CS
	$Tabs[n][0] = hTab; Note to self, this is not even needed
	$Tabs[n][1] = hSci; scintilla handle
	$Tabs[n][2] = sFile; loaded file path
	$Tabs[n][3] = Sci modification indicator for saving status true/fale
	$Tabs[n][4] = Tab name, file name
#CE
Global $DragCtrl

Global $CatchIt = 0;Used as a switch for capturing tab relocations
Global $Dropped, $Clicked, $Current; tab identifiers for relocation process
Global $TimeUp, $TimeDown; used to prevent unwanted tab relocations
Global $Rec_Old[4]; indicator to detect tab navigation
Global $hGraphic; the red arrow
Global $hPen; the red arrow
Global $hEndCap; the red arrow
Global $TabMarker = 0xB055; Action identifier used in the mouse tracker code _UI_TrackMouse
Global $Last; unused
Global $Timer = TimerInit()
Global $OldTime = TimerDiff($Timer); Timing stuff for incresed action speeds to avoid doing unecessary things

#endregion - Tabs

AutoItSetOption("MouseCoordMode", 2)
AutoItSetOption("GUIOnEventMode", 1)
AutoItSetOption("GUIEventOptions", 1)

$Editor_UI = GUICreate("(Untitled) - ASciTE", 300, 300, -1, -1, $Editor_UI_Style, $Editor_UI_StyleEx)
Global $htab = _GUICtrlTab_Create($Editor_UI, 0, 0, $UI_HIGHT, $UI_WIDTH, BitOR($WS_CHILD, $WS_VISIBLE, $TCS_HOTTRACK, $TCS_MULTILINE))

_GDIPlus_Startup()

$hPen = _GDIPlus_PenCreate(0xFFFF0000, 2); create the red pen
$hEndCap = _GDIPlus_ArrowCapCreate(3, 6); little arrow marker
_GDIPlus_PenSetCustomEndCap($hPen, $hEndCap);boom!

Global $Tab = _GUICtrlTab_GetDisplayRect($htab); get client size of tabs
Global $Lable = GUICtrlCreateLabel("",$Tab[0], $Tab[1], $Tab[2] - $Tab[0], $Tab[3] - $Tab[1]); fit inside the tabs

For $I = 0 To 54
	$Tabs[$I][0] = _GUICtrlTab_InsertItem($htab, $I, $I & " Test");useless random data, this is where you will hold things relevent to the current tab
	$Tabs[$I][1] = $I; fill with whatever
	$Tabs[$I][2] = 0
	$Tabs[$I][3] = 0
	$Tabs[$I][4] = $I & " Test"
Next

Global $tRegion = DllStructCreate("struct;long Left;long Top;long Right;long Bottom;endstruct"); structure used to indicate what tab will be repainted so we don't leave little red arrows everywhere

GUISetOnEvent($GUI_EVENT_PRIMARYUP, "_UI_PrimaryUp")
GUISetOnEvent($GUI_EVENT_PRIMARYDOWN, "_UI_PrimaryDown")
GUISetOnEvent($GUI_EVENT_MOUSEMOVE, "_UI_TrackMouse")
GUISetOnEvent($GUI_EVENT_CLOSE, "_UI_Terminate")

GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
GUIRegisterMsg($WM_SIZE, "WM_SIZE")

GUISetState()
intro()

Sleep(700000)



Func _UI_TrackMouse()
	Switch $DragCtrl
		Case $TabMarker

			_UI_MouseDetails($Current)

			Local $aRect = _GUICtrlTab_GetItemRect($htab, $Current)
			If $Rec_Old[0] <> $aRect[0] Or $Rec_Old[1] <> $aRect[1] Or $Rec_Old[2] <> $aRect[2] Or $Rec_Old[3] <> $aRect[3] And $CatchIt Then;Only enter if the $CatchIt var was set to something positive by _UI_PrimaryDown function
				Local $iTopMargin = $aRect[1] + 10; adjust position so it looks pretty
				$hGraphic = _GDIPlus_GraphicsCreateFromHWND($Editor_UI);I'm tempted to find an alternate method to clear the red arrow but my GDIP exp is limited
				Local $Margin; = left/right position of tab move indicator

				DllStructSetData($tRegion, 1, $Rec_Old[0])
				DllStructSetData($tRegion, 2, $Rec_Old[1])
				DllStructSetData($tRegion, 3, $Rec_Old[0] + $Rec_Old[2])
				DllStructSetData($tRegion, 4, $Rec_Old[1] + $Rec_Old[3])

				DllCall("user32.dll", "int", "RedrawWindow", "hwnd", $htab, "struct*", $tRegion, "int", 0, "int", $RDW_INVALIDATE)

				Select
					;Create left or right red arrow marker
					;Take note of how we create the left/right marker
					;do this by adding +1 to the left or right side
					Case $Clicked > $Current
						$Margin = $aRect[0] + 3
						_GDIPlus_GraphicsDrawLine($hGraphic, $aRect[0] + 1, $iTopMargin, $aRect[0], $iTopMargin, $hPen)
					Case $Clicked < $Current
						$Margin = $aRect[2] - 3
						_GDIPlus_GraphicsDrawLine($hGraphic, $Margin, $iTopMargin, $Margin + 1, $iTopMargin, $hPen)
				EndSelect

				_GDIPlus_GraphicsDispose($hGraphic)

				$Rec_Old[0] = $aRect[0];Save old positions so we know when they change
				$Rec_Old[1] = $aRect[1]
				$Rec_Old[2] = $aRect[2]
				$Rec_Old[3] = $aRect[3]

			EndIf

	EndSwitch
	Return
EndFunc   ;==>_UI_TrackMouse



Func _UI_PrimaryDown()
	_UI_MouseDetails($Clicked)
	If Not @error Then
		GUISetStyle(BitAND($Editor_UI_Style, BitNOT($WS_CLIPCHILDREN)), -1, $Editor_UI);remove clip children style or things wont work
		$DragCtrl = $TabMarker
		$TimeDown = TimerDiff($Timer)
		$CatchIt = 1
	EndIf
EndFunc   ;==>_UI_PrimaryDown

Func _UI_PrimaryUp()
	GUISetStyle($Editor_UI_Style, -1, $Editor_UI); Restore normal styles
	$CatchIt = 0
EndFunc   ;==>_UI_PrimaryUp

Func _UI_MouseDetails(ByRef $State)
	Local $tPOINT = _WinAPI_GetMousePos(True, $Editor_UI)
	Local $iX = DllStructGetData($tPOINT, "X")
	Local $iY = DllStructGetData($tPOINT, "Y")
	Local $aPos = ControlGetPos($Editor_UI, "", $htab)
	Local $aHit = _GUICtrlTab_HitTest($htab, $iX - $aPos[0], $iY - $aPos[1])
	If Not ($aHit[0] > -1) Then Return SetError(1, 0, 0)
	$State = $aHit[0]
EndFunc   ;==>_UI_MouseDetails


Func WM_NOTIFY($hWndGUI, $MsgID, $WPARAM, $LPARAM)
	#forceref $hWndGUI, $MsgID, $WPARAM

	Local $structNMHDR = DllStructCreate($tagSCNotification, $LPARAM)
	Local $hWndFrom = DllStructGetData($structNMHDR, 1)
	Local $iCode = DllStructGetData($structNMHDR, 3)
	;Local $position = DllStructGetData($structNMHDR, 4)

	Switch $hWndFrom
		Case $htab
			Switch $iCode
				Case $NM_CLICK
					Switch $CatchIt
						Case 1
							Local $Selected = _GUICtrlTab_GetCurFocus($htab)
							_UI_MouseDetails($Dropped)
							If @error Then
								$Clicked = ''
								$Dropped = ''
								Return $GUI_RUNDEFMSG
							EndIf
							$TimeUp = TimerDiff($Timer)
							Local $Time = Int($TimeUp - $TimeDown)
							If $Time > 1000 And $Selected == $Clicked And $Selected <> $Dropped Then
								Local $temp[UBound($Tabs, 2)]
								;This handles the tab switching
								If $Dropped < $Clicked Then

									For $I = 0 To UBound($temp) - 1
										$temp[$I] = $Tabs[$Clicked][$I]
									Next
									For $I = $Clicked To $Dropped + 1 Step -1
										If $I < 0 Then ExitLoop
										$Tabs[$I][1] = $Tabs[$I - 1][1]
										$Tabs[$I][2] = $Tabs[$I - 1][2]
										$Tabs[$I][3] = $Tabs[$I - 1][3]
										$Tabs[$I][4] = $Tabs[$I - 1][4]
									Next
									For $I = 0 To UBound($temp) - 1
										$Tabs[$Dropped][$I] = $temp[$I]
									Next

								Else

									For $I = 0 To UBound($temp) - 1
										$temp[$I] = $Tabs[$Clicked][$I]
									Next
									For $I = $Clicked To $Dropped - 1
										If $I < 0 Then ExitLoop
										$Tabs[$I][1] = $Tabs[$I + 1][1]
										$Tabs[$I][2] = $Tabs[$I + 1][2]
										$Tabs[$I][3] = $Tabs[$I + 1][3]
										$Tabs[$I][4] = $Tabs[$I + 1][4]
									Next
									For $I = 0 To UBound($temp) - 1
										$Tabs[$Dropped][$I] = $temp[$I]
									Next

								EndIf
								For $I = 0 To UBound($Tabs, 1) - 1
									_GUICtrlTab_SetItemText($htab, $I, $Tabs[$I][4])
								Next
								$Selected = $Dropped
							Else
								_GUICtrlTab_SetCurSel($hWndFrom, _GUICtrlTab_GetCurSel($hWndFrom))
							EndIf
							$Clicked = 0
							$DragCtrl = 0
							$Dropped = 0
						Case 0
							$Selected = _GUICtrlTab_GetCurSel($hWndFrom)
							_GUICtrlTab_SetCurSel($hWndFrom, $Selected)
					EndSwitch
					$Tab = _GUICtrlTab_GetDisplayRect($htab)
					_GUICtrlTab_SetCurSel($hWndFrom, $Selected)
					GUICtrlSetData($Lable, $Tabs[$Selected][1])
					GUICtrlSetPos($Lable, $Tab[0], $Tab[1], $Tab[2] - $Tab[0], $Tab[3] - $Tab[1]); here's where

					Return 'GUI_RUNDEFMSG'
			EndSwitch
	EndSwitch
EndFunc   ;==>WM_NOTIFY

Func WM_SIZE($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $iWParam, $ilParam

	_UI_SavePosition(); save UI size, getting it this way seems more reliable
	_UI_AdjustPositions()

	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_SIZE

Func _UI_SavePosition()
	Local $Size = WinGetClientSize($Editor_UI)
	If @error Then Return
	$UI_WIDTH = $Size[0]
	$UI_HIGHT = $Size[1]
EndFunc   ;==>_UI_SavePosition

Func _UI_AdjustPositions(); reposition controls here
	Local $tabpos = ControlGetPos($Editor_UI, "", $htab)

	_WinAPI_SetWindowPos($htab, $HWND_BOTTOM, $tabpos[0], $tabpos[1], $UI_WIDTH, $UI_HIGHT, $SWP_SHOWWINDOW); tab goes in low z order

	Local $Tab = _GUICtrlTab_GetDisplayRect($htab)
	GUICtrlSetData($Lable, _GUICtrlTab_GetCurFocus($htab))
	GUICtrlSetPos($Lable, $Tab[0], $Tab[1], $Tab[2] - $Tab[0], $Tab[3] - $Tab[1])
EndFunc

Func _UI_Terminate()
	Exit
EndFunc

Func intro()
	#Tidy_Off
	Local $Bin ='0x524946467A0F000057415645666D74201E00000055000100401F0000E8030000010000000C000100020000004800010071056661637404000000'& _
				'8079000064617461300F0000FFE318C4000BC001D38F400002810256B7600038B7CA2C3E50E060BE09A8102E1F27D10FDC18F94040E7FCF881C0F977'& _
				'863FE5C1F709DE2077FA21FF1E0280000008A1543E008000FFE318C40C1081AABFBF8D28001E70BA532133D1F40BE4F10474562C2F84E09635700F57'& _
				'FEECBFFFF67FEF65D3FF51CE42482F878C7B0404C5009FC3227D0F59CA057FBA90000006FFE318C4050F81AAD3B78D100206B6460000000F1D4DC82B'& _
				'374919A1738D1C66E2E0ADC56E227FFFFFA77FFFF890A1C720260A6A0B77731DA743181027156935B8EF49DB35FFD400FFE318C4020BC1E6E3B7C510'& _
				'0200176DA800554B4373FFFA0480ADFFFFFFFFFF6F6EEBA2B5FED564A6EBFF23BD6B8365D64BDFD47AC8969A1826D4004003FDF800669E67CA73E0AA'& _
				'FFE318C40E0B4062E7B6180422041DFFFFFE1E267D228402290139050F5CD3E277AFFFDE8B58C7FAD42A1FD7900000035DF8014FD48C3FF5609C8542'& _
				'AC202914B6068AB7FFFFE5E8FFE318C41C0C007EB7B60A9E2442577E8EDE73D6B5548A549A3419B5EB63908A3F54008002596001BF75A96FFFD453CE'& _
				'8375341EBFF6F4F452A5A67BED3640FDBEE671A4685A032BFFE318C4270B01D6CFB66804AE0D8177E3BF7400ADB400BED9197EA296A0182E0B8E7650'& _
				'99CFFFFFF8B0B8918326D4B513AD49774A5DC5D2F86AECCB133EC6AB94008C0B760037EFFFE318C4360B807ACF9E0814229C9FFD4BF7FAAFA4421E78'& _
				'D85EA6B1C757B30B6F6DD90454DD786C93D7356A28B35ABFD800D036E001A939F9A9F1591E93B8E93ED53FAD6C9880A0FFE318C4430AC19EE3AE3804'& _
				'EAC93CC593BFFFFFFBFFD8A09E76ADDBACAF1D7155B8B194115400CEFC00BF14CD7C55253505020B537E8540E0008CD31FFFFFFE9FEE71EB8550F6B9'& _
				'FFE318C4530C00BEB7A6102420B4A6E430D5EDAD212179FA95B410880976000DE72B172CFFE111DC3ECCF5272242773F14B37FFFFFFDBA9FD2AF5FDC'& _
				'2CC796587D892EC5946F3E27FFE318C45E0BC0C2B79E081A2029742042024B60017C3446FE6259CBAFEA270A1F38EB77FFFFA9E8ED5D4FD32CBEB53A'& _
				'204B96EAD98966CF357B357F70104C0B6C0037EFD7FFCC08FFE318C46A0C00B2DFAE194C2ADC7EFA8BE1E7E54CBA2FFF6293A4C1B229282CD319E633'& _
				'B1E87B2F2759DA2EDBABB40004005DF0004D1093AD4EFFFC20DC3FE0C4FC131E8FFA7B7EFFE318C4750B80B2D7B6081A22FF9F441ACA646DCECEBD26'& _
				'19387A5C0423CEEAC00302ED800BFF13030DCB3FCAFE3C307CA27FFFFFDA4195DED2658B0424D058221E5B4B0F129C2BFFE318C4820B41BAD3AE680A'& _
				'EA4AA61E275172AA49E167A3D4000C0DBF000D3DD3AFF042786FD5FF1AAFFFFFF53462C5DA0F097D0E79CABC3617170B8440A65020099A40B9207020'& _
				'FFE318C4900B41EAE3B61004EAB68907FF700201C9000BE3913FC3110D489E0A34D4DC9A29BF8D624129937FFFFFE1D7D69D23EE3AA8553961709156'& _
				'4F001FF4CE9A5926977400C4FFE318C49E0CC0C2DB86080E06005DA8017E44427F121F985459CA2ACE201BF0B67412677FFFFFAD3AF26A262EA968E2'& _
				'CE1E45858223996D8B4E38E36CD7741004004B68017C988EFFE318C4A60D00B6E7AE1004220FA8FEA09937CC085F19E85CF5EDFFFFFE5D4E5DC90094'& _
				'12CCDFB4C6618F02452D150FD8A0044E1664AF781004006DA801BECECAADFFD4BF0BB7CAFFE318C4AD0D00C2BB86081A223FC4EE64AB6FD95AA2AD32'& _
				'60DA141F43D61DA1A35D969E48696172E1CA699EAF500025B400BF5208FE270FE304FE2021A1A5C30372EE1B77FFFFF6FFE318C4B40D00C2DBB6080A'& _
				'221F29A8E3AA719508DD266D84C9F9D6BA3525DAD4A41C000414E37FB002DC001EAB5A3D9FFF8AC93DA86395DE2F83C08BDD408383C4BAD3FFEDFFFE'& _
				'FFE318C4BB0D00C2CFB6081A22EADDACCA9D747DAAAD916A9E4D75ABFA45D994C39B40B803DF5FA5AFA5D410450832C6642E569F0DFF7064456AAF6E'& _
				'92BC0017C88E417660E1E2A5FFE318C4C20C419EDBB63804EAE9B2DBD67345EB77E43FB89CCB65162A60B43E787A14E0658C18D7A967FA15700010ED'& _
				'A001BEB6C9FF948E26F1D0BF0C6492C23B2BC0B2C072D77FFFE318C4CC0D80BAC79E080E22FFFFB357429E211E277A038386895AA05228D1C55E8181'& _
				'A28E054E187074506754002ED000DFB56B6FFE6220442A1291696D48D8A60B909D649251FFE318C4D10D42D2AF769004EA60845D5FD5B33FC22D34B5'& _
				'4F3079632D5921C2ABB351D66F5FEA900026F8007B5F66A0DFF52CA02636586A29E9AD014F046A8A7A0A16CD4DFD7BEDFFE318C4D71140C28F4C9E8C'& _
				'68826EBFE7791188DF65426E7B8EB03AAF539D5D65DAE33F1FFF9EB400080BFF001EAAB5A94A5295FF4DC580C94D270A81B3596C0D23D4DAF926241E'& _
				'FFE318C4CD0F00B2BFA610162271BFF57F82FD3D35E9323EE92AFB5D9A86747D964A37252F9375483FF002026D80036AD33DDD74CAF4513208606A37'& _
				'46A0EA70DEB78C09098D6D57FFE318C4CC0D41B2AF9E9804E8F0FB2277E16AF5FFFFFF0DEAE59E51E1462CDAA5ED1AF40ADF1CAF2D69E9A15F740004'& _
				'005DB001BEDB53FF828478A7F52FF10B34E6FFD7F43B75B2FFE318C4D20EBA4AAF9E9004E958818AE9999AAD2ECF3ACF6BBBAB3A3DD58EECAA9C16A8'& _
				'0F355B800BF00646BFA762D1FFF5AAA3B30B2F6F282840E3F5BFE7E7008F776B1DEAB904FFE318C4D20F42D2B3AE6804E8EAFD11C4FA13B7FFFE1A6A'& _
				'9468C6B1362E394E0D477FB86588A9EA22A95F90000C096D00167BB528EA9FFC4A1390F526131CCD4A077E2489E72156FFE318C4D00FC0C2A786141E'& _
				'406DF7A3C6C55F724B285691A2250A21B80DFB94E6B19172C3E4327FBC00080DFF001EED5B5365FFF48854D15841CBEAEB14C1A5F1F22ADA77FABACC'& _
				'FFE318C4CC0D42BACFB63804EB32B32B1FB7114963A3440182CB165AC35507C8222B389DB8594829500024B0005BEAAEC676FCF8669E74394A80185B'& _
				'C6A92EB08C0CC23E31814A69FFE318C4D20FC0C28B7416464CDFFFFFFAA2158B2D42EE2EB98BFDC985CC9B9F4A269E85145D275757180026F800BF81'& _
				'92FFE0F9ACFBE85A96374DFB8CA1419BEE8880190FE648E0FFE318C4CE0E019ABFAE5004EA00C09E7D1FFFFF06DF5F2C2CC53FD109BC3503EF5296C4'& _
				'9C8DCF21C5BF94000EDC0079AFB2DA8AFFF50AAD6D6102AB753A867834CD144A00870311FFE318C4D10EC1D2ABAE8804E8767994785EBFFFFFA7F8D2'& _
				'ADB58D567DE958DB9764C45521172426970F90000DB4001A233C240631EFFA844449115241C41832B30370A450A0EC25FFE318C4D10F00C2939E5624'& _
				'6020AB59CC9D2DD3FFFFF27FC5177885C62305DA54CD089BF96056E36BCBFF94001EFC0047EEF3FFFDC0D15103D497B8DF3E9A1DEA86DDCC359AFB22'& _
				'FFE318C4D00F00BA9F9E0A9E244F3B35ABFFEBFFFC9777AC68CB978B3AE61E7981CD029D74D9C7069C70CB457FD85004005FF80072BDB3253F9AACA2'& _
				'8DCBF88827D59D0D664FEADFFFE318C4CF0EC0C29F9E6B226056FEEAAACE767E8CE9B5D75395365364F55769E96B1928E8B57407700000296E0009DA'& _
				'E56EBDE3503B2839C06A096D3811B01B13966712F357BFFFFFE318C4CF0F00C2939E306604FFB69E61B3CB00865D12314F4183EA4AEC303A92CA09AA'& _
				'8AB1E71665208F9C0005004DF8006FA95F5F58B8414A884DCF3D780723DCD914EB0D2536FFE318C4CE0F40C2979E3BF06421828CFFFFFE4353B4649A'& _
				'E1121CAA07A67C8433DA5C4522073A6E95FFB40004005DF00041191C68C69FCEA5A8CC2207218A9C2FA5AD5560A10CCFFFE318C4CC0D82D2D3B62804'& _
				'EA6C2845BD03B4C57FFFFF790D4EAD79F15AC8DD3B88D8C434D58F372A6DE82790000C0B6E0016AEAC96B7FF050DE1127C7467E290F462A6FEA6E411'& _
				'FFE318C4D10F80B28FAE102420D6E18356E4A567C122C6882267157328422F68C949F6342CE06340FC05FABE4E7D074413B146E2D6694433796FF37A'& _
				'CE2056FEFEB993B8522E6A67FFE318C4CE0E80B293B6101A2076E4ACFFEAFE47F400DA042D3AB3A7E784AA40BD8DDA9525F15430655F20072E0037FA'& _
				'DBFF41812C02912680F71444ED34E8428004F7A404200A4DFFE318C4CF0F40C28FB6185A0431FFF1F6B0DEAEB42D2A9A7D8974F0582A7165CEBC9223'& _
				'C51647800100976C006FFFFFCBC375980211C7B61A0797A81885B2D32EBBEBFFFE8DF8F6FFE318C4CD0D819AA3AE3806EAFC16FDFE896DBCD7DABD76'& _
				'F4FEB8218D36277FF25BCC783A3B6C4D580BAFFBFA2B05D8B4AA96941B7543DC7B87095899967BFF80ECA1ED878F57B3FFE318C4D20F80C2674C0CF0'& _
				'40A3FED5750F02BC32D4CC12313A2EB58EA0FB909B8DBD19B620F7820053C4BF080BB6E00F89C91B700D277E2C8516DD011C883E1443FFFFA04762DE'& _
				'FFE318C4CF0E019E6F766804E8D11911D955A4D28129808C2080F534B004A2A803387B77461C0E150E00C1BF00092CA00F87A4972804C4DDE20886FA'

	Local $H = DllStructCreate('byte['&BinaryLen($Bin)+1&']')
	DllStructSetData($H,1,Binary($Bin))
	Return DllCall('winmm.dll', 'int', 'PlaySoundW', 'ptr', DllStructGetPtr($H), 'ptr', 0, 'dword', 8197)
	#Tidy_On
EndFunc   ;==>intro
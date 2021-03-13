#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <ComboConstants.au3>
#include <Excel.au3>

HotKeySet("{ESC}", "_hkExitApp")

__NFY_GUI_Window('NFY GIS Window', 1000, 600) ; WIDTH NOT SMALLER THEN 400 | HEIGHT NOT SMALLER THEN 200 === TRUST ME

Func __NFY_GUI_Window($sWINDOW_TITLE, $iWINDOW_WIDTH, $iWINDOW_HEIGHT)
    Local $oWINDOW = GUICreate($sWINDOW_TITLE, $iWINDOW_WIDTH, $iWINDOW_HEIGHT, -1, -1, BitOR($WS_POPUP, $WS_SYSMENU, $WS_MINIMIZEBOX), $WS_EX_LAYERED) ; BitOR($WS_EX_TOOLWINDOW, $WS_EX_LAYERED))
    GUISetFont(8, 400, 0, 'Tahoma')
    GUISetBkColor(0x494E49)
    GUICtrlCreatePic('hdr.bmp', 0, 0, $iWINDOW_WIDTH - 16, 20, $SS_NOTIFY, $GUI_WS_EX_PARENTDRAG)
    GUICtrlCreatePic('hdr.bmp', $iWINDOW_WIDTH - 16, 0, 11, 5, $SS_NOTIFY, $GUI_WS_EX_PARENTDRAG)
    GUICtrlCreatePic('hdr.bmp', $iWINDOW_WIDTH - 16, 16, 11, 4, $SS_NOTIFY, $GUI_WS_EX_PARENTDRAG)
    GUICtrlCreatePic('hdr.bmp', $iWINDOW_WIDTH - 5, 0, 5, 20, $SS_NOTIFY, $GUI_WS_EX_PARENTDRAG)
	GUICtrlCreatePic ('C:\Users\strauss\Desktop\GUI Ideas\red light.jpg', $iWINDOW_WIDTH - 980, 450, 0, 0)
	GUICtrlCreatePic ('C:\Users\strauss\Desktop\GUI Ideas\green light.jpg', $iWINDOW_WIDTH - 980, 450, 0, 0)
	GUICtrlCreatePic ('C:\Users\strauss\Desktop\GUI Ideas\no light.jpg', $iWINDOW_WIDTH - 980, 450, 0, 0)
    GUICtrlCreateGraphic(0, 20, 1, $iWINDOW_HEIGHT)
    GUICtrlSetColor(-1, 0x686A65)
    GUICtrlCreateGraphic($iWINDOW_WIDTH - 1, 20, 1, $iWINDOW_HEIGHT)
    GUICtrlSetColor(-1, 0x686A65)
    GUICtrlCreateGraphic(0, $iWINDOW_HEIGHT - 1, $iWINDOW_WIDTH, 1)
    GUICtrlSetColor(-1, 0x686A65)
    Local $oCLOSE = GUICtrlCreatePic('cls.bmp', $iWINDOW_WIDTH - 16, 5, 11, 11, $SS_NOTIFY, $GUI_WS_EX_PARENTDRAG)
    Local $oLABELHEADER = GUICtrlCreateLabel($sWINDOW_TITLE, 6, 0, $iWINDOW_WIDTH - 22, 20, $SS_CENTERIMAGE)
    GUICtrlSetColor(-1, 0xD8DED3)
    GUICtrlSetBkColor(-1, 0x5A6A50)
    #cs ==============================
    EXAMPLE SECTION ==================
    #ce ==============================
    Local $oBUTTON_1 = GUICtrlCreateButton('Shop Floor Status', 10, 30, 140, 20)
    GUICtrlSetFont(-1, 8, 800, 0, 'Tahoma')

    Local $oBUTTON_2 = GUICtrlCreateButton('Floor Coverage', 10, 60, 140, 20)
    GUICtrlSetFont(-1, 8, 800, 0, 'Tahoma')

    Local $oBUTTON_3 = GUICtrlCreateButton('Contact List', 10, 90, 140, 20)
    GUICtrlSetFont(-1, 8, 800, 0, 'Tahoma')

    Local $oBUTTON_4 = GUICtrlCreateButton('Button 4', 10, 120, 140, 20)
    GUICtrlSetFont(-1, 8, 800, 0, 'Tahoma')

    Local $oBUTTON_5 = GUICtrlCreateButton('Button 5', 10, 150, 140, 20)
    GUICtrlSetFont(-1, 8, 800, 0, 'Tahoma')

    GUICtrlCreateGraphic(1, 20, 160, $iWINDOW_HEIGHT - 21)
    GUICtrlSetColor(-1, 0x464646)
    GUICtrlSetBkColor(-1, 0x464646)
    GUICtrlCreateGraphic(158, 20, 1, $iWINDOW_HEIGHT - 21)
    GUICtrlSetColor(-1, 0x3D423D)
    GUICtrlCreateGraphic(159, 20, 1, $iWINDOW_HEIGHT - 21)
    GUICtrlSetColor(-1, 0x424742)
    GUICtrlCreateGraphic(160, 20, 1, $iWINDOW_HEIGHT - 21)
    GUICtrlSetColor(-1, 0x454A45)

    $oLABELTOP = GUICtrlCreateLabel('HEADER TEXT', 180, 31, $iWINDOW_WIDTH - 200, 20, $SS_CENTERIMAGE)
    GUICtrlSetFont(-1, 8, 800, 0, 'Tahoma')
    GUICtrlSetColor(-1, 0xC4B550)

    GUICtrlCreateGraphic(170, 51, $iWINDOW_WIDTH - 180, 1)
    GUICtrlSetColor(-1, 0x636763)

	GUICtrlCreateTab(180, 60, 800, 20)
	GUICtrlCreateTabItem("Global Information Services")
    GUICtrlCreateLabel('input control', 200, 120, 100, 20, BitOR($SS_RIGHT,$SS_CENTERIMAGE))
    GUICtrlSetColor(-1, 0xE6ECE0)
    GUICtrlCreateInput('', 310, 120, 200, 20)

;Tab for DR call information First Line=======================================
GUICtrlCreateTabItem("DR Call Information")

GUICtrlCreateLabel('DR Call Numbers:', 180, 120, $iWINDOW_WIDTH - 200, 20, $SS_CENTERIMAGE)
    GUICtrlSetFont(-1, 11, 800, 0, 'Tahoma')
    GUICtrlSetColor(-1, 0xC4B550)

GUICtrlCreateLabel('Event Bridge First Line: xxxxxxxxx', 180,140, $iWINDOW_WIDTH - 200, 20, $SS_CENTERIMAGE)
    GUICtrlSetFont(-1, 10, 800, 0, 'Tahoma')
    GUICtrlSetColor(-1, 0xC4B550)

GUICtrlCreateLabel('Access Code: xxxxxx', 180,155, $iWINDOW_WIDTH - 200, 20, $SS_CENTERIMAGE)
    GUICtrlSetFont(-1, 10, 800, 0, 'Tahoma')
    GUICtrlSetColor(-1, 0xC4B550)

GUICtrlCreateLabel('Host Password: xxxx', 180,168, $iWINDOW_WIDTH - 200, 20, $SS_CENTERIMAGE)
    GUICtrlSetFont(-1, 10, 800, 0, 'Tahoma')
    GUICtrlSetColor(-1, 0xC4B550)
;==================================================================

;Tab for DR call information Second Line=======================================

GUICtrlCreateLabel('Event Bridge Second Line: xxxxxxxxx', 180,200, $iWINDOW_WIDTH - 200, 20, $SS_CENTERIMAGE)
    GUICtrlSetFont(-1, 10, 800, 0, 'Tahoma')
    GUICtrlSetColor(-1, 0xC4B550)

GUICtrlCreateLabel('Access Code: xxxxxx', 180,215, $iWINDOW_WIDTH - 200, 20, $SS_CENTERIMAGE)
    GUICtrlSetFont(-1, 10, 800, 0, 'Tahoma')
    GUICtrlSetColor(-1, 0xC4B550)

GUICtrlCreateLabel('Host Password: xxx', 180,230, $iWINDOW_WIDTH - 200, 20, $SS_CENTERIMAGE)
    GUICtrlSetFont(-1, 10, 800, 0, 'Tahoma')
    GUICtrlSetColor(-1, 0xC4B550)
;==================================================================

    GUICtrlCreateGraphic(170, 30, $iWINDOW_WIDTH - 180, $iWINDOW_HEIGHT - 40) ; THIS CONTROL NEEDS TO BE LAST DUE TO OVERLAY ISSUES
    GUICtrlSetColor(-1, 0x686A65)

    #cs ==============================
    EXAMPLE SECTION ==================
    #ce ==============================

    GUICtrlCreatePic('cnr.bmp', 0, 0, 1, 1, $SS_NOTIFY, $GUI_WS_EX_PARENTDRAG)
    GUICtrlCreatePic('cnr.bmp', $iWINDOW_WIDTH - 1, 0, 1, 1, $SS_NOTIFY, $GUI_WS_EX_PARENTDRAG)
    GUICtrlCreatePic('cnr.bmp', 0, $iWINDOW_HEIGHT - 1, 1, 1, $SS_NOTIFY, $GUI_WS_EX_PARENTDRAG)
    GUICtrlCreatePic('cnr.bmp', $iWINDOW_WIDTH - 1, $iWINDOW_HEIGHT - 1, 1, 1, $SS_NOTIFY, $GUI_WS_EX_PARENTDRAG)
    GUISetState(@SW_SHOW)
   While 1
        Local $eMSG = GUIGetMsg()
        Select
            Case $eMSG = $GUI_EVENT_CLOSE
                ExitLoop
            Case $eMSG = $oBUTTON_1
                Run("notepad.exe")
            Case $eMSG = $oBUTTON_2
                Run("notepad.exe")
			Case $eMSG = $oBUTTON_3
				Run ("notepad.exe")
			Case $eMSG = $oBUTTON_4


;                Local $iWINDOW_TRANS
;                For $iWINDOW_TRANS = 255 To 0 Step -10
;                    If $iWINDOW_TRANS > 0 Then WinSetTrans($oWINDOW, '', $iWINDOW_TRANS)
;                    Sleep(10)
;                Next
;                Exit
            Case $eMSG = $oCLOSE
                Local $iWINDOW_TRANS
                For $iWINDOW_TRANS = 255 To 0 Step -10
                    If $iWINDOW_TRANS > 0 Then WinSetTrans($oWINDOW, '', $iWINDOW_TRANS)
                    Sleep(10)
                Next
                Exit
        EndSelect
    WEnd
EndFunc

Func _hkExitApp()
Exit
EndFunc ;==>_hkExitApp
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <IE.au3>

    $oIE = ObjCreate("Shell.Explorer.2")
	GUICreate("Tom Test", 400, 500, (@DesktopWidth - 400) / 2, (@DesktopHeight - 400) / 2, BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS, $WS_CLIPCHILDREN))
    $GUIActiveX = GUICtrlCreateObj ($oIE, 10, 40, 400, 500)
    $GUI_Button_1 = GUICtrlCreateButton("1", 10, 2, 20, 30)
   	GUISetState()       ;Show GUI

$oIE.navigate("http://www.vahud.com/_bt1login/login_filled.htm")
_IELoadWait ($oIE)

    While 1
        $msg = GUIGetMsg()

        Select
			Case $msg = $GUI_EVENT_CLOSE
                ExitLoop
            Case $msg = $GUI_Button_1
				post_BoomTown()
		EndSelect
	WEnd

    GUIDelete()

Func post_BoomTown()

$tomboy = _IEGetObjById ($oIE, "ctl00_SampleContent_ctlLogin_UserName")
$username= $tomboy.value

; IF I naviagte to the url it will work but if I create it will not..
$oIE = _IECreate ("http://www.vahud.com/_bt1login/login.htm")
;; $oIE.navigate("http://www.vahud.com/_bt1login/login.htm")
_IELoadWait ($oIE)

$tomboy = _IEGetObjById ($oIE, "ctl00_SampleContent_ctlLogin_UserName")
  $tomboy.value=$username

EndFunc


#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <IE.au3>

Opt('MustDeclareVars', 1)

Admin()

Func Admin()
    Local $oIE, $GUIActiveX, $GUI_Button_Back, $GUI_Button_Forward
    Local $GUI_Button_Home, $GUI_Button_Stop, $msg,$adminuser,$adminpass,$uPerformsite,$oSubmit
	
	$adminuser ="xxxx"
	$adminpass="xxxx"
    $oIE = _IECreateEmbedded ()
	$uPerformsite= "http://up01.rwd-deutschland.de/"	

    ; Create a the form with the site embedded
    GUICreate("uPerform Administrator Panel", @DesktopWidth, @DesktopHeight-50,-1,-1,BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS, $WS_CLIPCHILDREN))
	$GUIActiveX = GUICtrlCreateObj ($oIE, -1, -1, @DesktopWidth, @DesktopHeight-200)
    $GUI_Button_Back = GUICtrlCreateButton("Back", 10, @DesktopHeight-198, 100, 30)
    $GUI_Button_Forward = GUICtrlCreateButton("Forward", 110, @DesktopHeight-198, 100, 30)
    $GUI_Button_Home = GUICtrlCreateButton("Home", 210, @DesktopHeight-198, 100, 30)
    $GUI_Button_Stop = GUICtrlCreateButton("Stop", 310, @DesktopHeight-198, 100, 30)

	
	_IENavigate($oIE,$uPerformsite)
	_IELoadWait ($oIE)
 
	$oSubmit = _IEGetObjById ($oIE, "Log In")
	
	_IEAction ($uPerformsite, "click")	
	
GUISetState()       ;Show GUI
    ; Waiting for user to close the window
    While 1
        $msg = GUIGetMsg()

        Select
            Case $msg = $GUI_EVENT_CLOSE
                ExitLoop
            Case $msg = $GUI_Button_Home
                $oIE.navigate($uPerformsite)
            Case $msg = $GUI_Button_Back
                $oIE.GoBack
            Case $msg = $GUI_Button_Forward
                $oIE.GoForward
            Case $msg = $GUI_Button_Stop
			ExitLoop
		
        EndSelect
        
    WEnd

    GUIDelete()
EndFunc 

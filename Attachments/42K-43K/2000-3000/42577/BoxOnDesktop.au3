

; GUI
$WS_POPUP      	   = 0x80000000
$WS_EX_LAYERED     = 0x00080000
$GUI_desktop_Child = GUICreate( "" , 500 , 200 , 500 , 500 , $WS_POPUP ,  $WS_EX_LAYERED  )
GUISetBkColor( 0x00FF00 )
GUISetState()

	; BOX
	GUICtrlCreateLabel( "" ,  5 , 5 , 300 , 5   )
	GUICtrlSetBkColor( -1 , 0xEA0000   )
	GUICtrlCreateLabel( "" ,  5 , 100 , 300 , 5   )
	GUICtrlSetBkColor( -1 , 0xEA0000   )
	GUICtrlCreateLabel( "" ,  5 , 5 , 5 , 100   )
	GUICtrlSetBkColor( -1 , 0xEA0000   )
	GUICtrlCreateLabel( "" ,  300 , 5 , 5 , 100   )
	GUICtrlSetBkColor( -1 , 0xEA0000   )


; MAKE CHILD OF DESKTOP & ALPHA MASK
$hDeskWin=_WinGetDesktopHandle()
DllCall("user32.dll", "int", "SetParent", "hwnd", $GUI_desktop_Child , "hwnd", $hDeskWin )
DllCall( "user32.dll" , "bool", "SetLayeredWindowAttributes", "hwnd", $GUI_desktop_Child, "dword",   0x00FF00 , "byte", 250, "dword",  0x03 ) ; ( has to be executed AFTER! making it childwindow )



HotKeySet( "{ESC}" , "_exit" )
Func _exit()
	Exit
EndFunc


While 1
    Sleep(50)
WEnd



Func _WinGetDesktopHandle()

	Local $i,$hDeskWin,$hSHELLDLL_DefView,$hListView
	; The traditional Windows Classname for the Desktop, not always so on newer O/S's
	$hDeskWin=WinGetHandle("[CLASS:Progman]")
	; Parent->Child relationship: Desktop->SHELLDLL_DefView
	$hSHELLDLL_DefView=ControlGetHandle($hDeskWin,'','[CLASS:SHELLDLL_DefView; INSTANCE:1]')
	; No luck with finding the Desktop and/or child?
	If $hDeskWin='' Or $hSHELLDLL_DefView='' Then
	; Look through a list of WorkerW windows - one will be the Desktop on Windows 7+ O/S's
	$aWinList=WinList("[CLASS:WorkerW]")
	For $i=1 To $aWinList[0][0]
	$hSHELLDLL_DefView=ControlGetHandle($aWinList[$i][1],'','[CLASS:SHELLDLL_DefView; INSTANCE:1]')
	If $hSHELLDLL_DefView<>'' Then
	$hDeskWin=$aWinList[$i][1]
	ExitLoop
	EndIf
	Next
	EndIf
	; Parent->Child relationship: Desktop->SHELDLL_DefView->SysListView32
	$hListView=ControlGetHandle($hSHELLDLL_DefView,'','[CLASS:SysListView32; INSTANCE:1]')
	If $hListView='' Then Return SetError(-1,0,'')
	Return SetExtended($hListView,$hDeskWin)

EndFunc
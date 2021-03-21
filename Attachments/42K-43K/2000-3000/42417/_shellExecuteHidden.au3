#Include <WinAPIEx.au3>



; EXAMPLE:

;~ ; 1 - open a programm with @SW_HIDE
;~ ShellExecute( @ComSpec , "/c start notepad.exe" , "" , "" ,  @SW_HIDE )
;~ WinWaitActive(  "[CLASS:Notepad]" )
;~ ControlSend( "[CLASS:Notepad]" ,   "" , "Edit1" , "As you can see, you cannot prevent an hidden started application " & @LF & "from opening another window that gets visible...")
;~ MsgBox( 0 , '' , "I understand. show me the version with appstart on hidden desktop" )
;~ WinKill(  "[CLASS:Notepad]"  )

;~ ; 2 - do the same routine with "_shellExecuteHidden"
;~ $hWinHiddenApp = _shellExecuteHidden( @ComSpec , "/c start notepad.exe"  )
;~ ShellExecute( "taskmgr.exe" )
;~ MsgBox( 0 , '' ,  "...ok look in your taskmanager now. There should be a new notepad.exe entry but no window is visible." )

;~ ; 3 - close  hidden application
;~ WinKill( $hWinHiddenApp )

;~ ; 4 - start  hidden application
;~ MsgBox( 0 , '' ,  "Now we start an editor on the hidden desktop and interact with it programmaticly" )
;~ $hWinHiddenApp = _shellExecuteHidden( @SystemDir & "\notepad.exe" )

;~ ; 5 - send to hidden application
;~ ControlSend( $hWinHiddenApp  ,  "" , "Edit1" , "di{BS}eb{BS}mk{BS}os{BS}" )

;~ ; 6 - receive information from hidden application
;~ MsgBox( 0 , '' , "Text in the editor on hidden desktop: " & @LF & @LF &  ControlGetText( $hWinHiddenApp  , "" , "Edit1" ) )

;~ ; 7 - close  hidden application
;~ WinKill( $hWinHiddenApp )




; #FUNCTION# ====================================================================================================================
; Name ..........: ShellExecuteHidden
;
; Description ...: runs a process on another winApi-desktop, so that none of its windows ever get visible, but can be automated by window messages and other technologies.
;				   The difference to shellExecute( ... , ... , @SW_HIDE ) is, that no just the first, but any windows from the created process will stay totaly isolated from user input and graphics
;
; Syntax ........: ShellExecuteHidden($filepath[, $parameters = "" [, $returnType = 1 [, $waitingOption = -1 ]]])
;
; Parameters ....: $filepath       - the file to run
;
;				   $returnType     =  		   0  >>  returns window handle of toplevel window of the started process
;								  					  even if its window is "hidden" (would not be visible on normal desktop)
;				                   =  		   1  >>  returns window handle of toplevel window of the started process
;				   			       =  		   2  >>  returns process id (PID) of the started process
;
;
;				   $waitingOption  =   		  -2  >> dont wait (not recommended for window handles, as they need some time to appear even if the program is loading fast)
;					   			   =    	  -1  >> wait 1000 milliseconds for windows to "appear" but dont wait for processes to finish (compromise)
;					   			   =    	   0  >> wait for the process to finish or the window to appear
;					   			   =  		 <x>  >> wait <x> milliseconds for the process to finish or the window to appear (see "$returnType" )
;
; Return values .: windowHandle or ProcessID
; Author ........: Bluesmaster
; Modified ......: 2013 - 11 - 09
; Remarks .......:
; Related .......: ShellExecute, _WinAPI_CreateDesktop
; Link ..........: http://msdn.microsoft.com/en-us/library/windows/desktop/ms687098(v=vs.85).aspx
; Example .......: Yes
; ===============================================================================================================================
Func _shellExecuteHidden( $filepath , $parameters = "" , $returnType = 1 , $waitingOption = -1 )


	; 1 - Create Desktop
	;Global Const $GENERIC_ALL = 0x10000000
	$hNewDesktop     = _WinAPI_CreateDesktop( "ShellExecuteHidden_Desktop" , $GENERIC_ALL )


	; 2 - Start Process
	$tProcess = DllStructCreate( $tagPROCESS_INFORMATION )
	$tStartup = DllStructCreate( $tagSTARTUPINFO )
	DllStructSetData( $tStartup , 'Size', DllStructGetSize( $tStartup) )
	DllStructSetData( $tStartup , 'Desktop', _WinAPI_CreateString(  "ShellExecuteHidden_Desktop" ) )

	Local $pid
	If _WinAPI_CreateProcess( $filepath , $parameters , 0, 0, 0, 0x00000200	, 0, 0, DllStructGetPtr($tStartup), DllStructGetPtr($tProcess)) Then
		$pid =  DllStructGetData( $tProcess , 'ProcessID' )
	Else
		Return -1
	EndIf


	; 3 - Return Process
	if $returnType = 2 Then
		if $waitingOption > -1 Then	ProcessWaitClose( $pid  , $waitingOption  )
		Return $pid
	EndIf



	; 4 - Return WindowHandle
	if $waitingOption =  -1  Then
		Sleep( 1000  )
	ElseIf $waitingOption >  0 Then
		Sleep( $waitingOption  )
	EndIf

	While True  ; keep searching for the window

		$aWindows = _WinAPI_EnumDesktopWindows( $hNewDesktop , $returnType ) ; $returnType = 0 >> means also list hidden windows

		if IsArray( $aWindows ) Then

			for $i = 1 to $aWindows[0][0]

				;~ 		MsgBox( 0 , '' , $curPID  & " " & $pid & "      "  & $hWnd & " " & $aWindows[$i][0] )

				$hWnd = $aWindows[$i][0]
				if $pid = WinGetProcess( $hWnd ) Then ; same process?

					do ; searching through parent windows ...
						$hLast = $hWnd ; cache it for not loosing it when desktop is reached
						$hWnd  = _WinAPI_GetParent( $hLast )
					Until $hWnd = 0    ; ... until root/ desktop is reached
					$hWnd = $hLast

					Return $hWnd  ; return the toplevel-window of the process

				EndIf

			Next

		EndIf

		if $waitingOption = 0 Then ; keep searching for the window until it appears ( in worst case endless )
			Sleep( 200 )
		Else
			Return -1
		EndIf

	WEnd


EndFunc





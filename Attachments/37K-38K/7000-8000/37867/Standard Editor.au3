#RequireAdmin
#NoTrayIcon

#include <WindowsConstants.au3>
#include <GUIRichEdit.au3>
#include <GUIEdit.au3>
#include <GuiMenu.au3>
#include <GuiListBox.au3>

Global $background, $fontsize

$load = GUICreate( "Standard Editor", 300, 100, Default, Default, 1 )
GUICtrlCreateLabel( "Loading resources", 50, 5, 300, 50 )
GUICtrlSetFont( -1, 18 )
$progress = GUICtrlCreateProgress( 7.5, 40, 280, 20 )
GUISetState( )
LoadCFG( )
GUIDelete( $load )

$main = GUICreate( "Standard Editor", 800, 600, Default, Default, BitOR( $GUI_SS_DEFAULT_GUI, $WS_MAXIMIZEBOX, $WS_SIZEBOX, $WS_THICKFRAME, $WS_TABSTOP ) )

$Menu1 = GUICtrlCreateMenu( "File" )
$Menu1Item1 = GUICtrlCreateMenuItem( "Save", $Menu1 )
$Menu1Item2 = GUICtrlCreateMenuItem( "Exit", $Menu1 )

$Menu2 = GUICtrlCreateMenu( "Edit" )
$Menu2Item1 = GUICtrlCreateMenuItem( "Undo", $Menu2 )
$Menu2Item2 = GUICtrlCreateMenuItem( "Redo", $Menu2 )
$Menu2Item3 = GUICtrlCreateMenuItem( "Select All", $Menu2 )
$Menu2Item4 = GUICtrlCreateMenuItem( "Copy", $Menu2 )
$Menu2Item5 = GUICtrlCreateMenuItem( "Cut", $Menu2 )
$Menu2Item6 = GUICtrlCreateMenuItem( "Paste", $Menu2 )

$Menu3 = GUICtrlCreateMenu( "Options" )
$Menu3Item1 = GUICtrlCreateMenuItem( "Settings", $Menu3 )

$Menu4 = GUICtrlCreateMenu( "Help" )
$Menu4Item1 = GUICtrlCreateMenuItem( "About Standard Editor", $Menu4 )

$edit = _GUICtrlRichEdit_Create( $main, "", 5, 5, 790, 450, BitOR( $ES_AUTOHSCROLL, $ES_AUTOVSCROLL, $WS_HSCROLL, $WS_VSCROLL, $ES_MULTILINE ) )
_WinAPI_SetFont( $edit, _WinAPI_CreateFont( 16, 0, 0, 0, 500, False, False, False, $DEFAULT_CHARSET, $OUT_DEFAULT_PRECIS, $CLIP_DEFAULT_PRECIS, $DEFAULT_QUALITY, 0, "Courier New" ) )
_GUICtrlRichEdit_SetBkColor( $edit, $background )

$console = _GUICtrlEdit_Create( $main, "", 5, 460, 790, 90, BitOR( $ES_AUTOVSCROLL, $WS_VSCROLL, $ES_MULTILINE, $ES_READONLY ) )
_WinAPI_SetFont( $console, _WinAPI_CreateFont( 15, 0, 0, 0, 500, False, False, False, $DEFAULT_CHARSET, $OUT_DEFAULT_PRECIS, $CLIP_DEFAULT_PRECIS, $DEFAULT_QUALITY, 0, "Courier New" ) )

$bar = _GUICtrlStatusBar_Create( $main, Default, " Line = 1 | Column = 1" )
_WinAPI_SetFont( $bar, _WinAPI_CreateFont( 16, 0, 0, 0, 100, False, False, False, $DEFAULT_CHARSET, $OUT_DEFAULT_PRECIS, $CLIP_DEFAULT_PRECIS, $DEFAULT_QUALITY, 0, "Courier New Bold" ) )

$mnu = GUICtrlCreateContextMenu( GUICtrlCreateDummy( ) )
$mnuUndo = GUICtrlCreateMenuItem( "Undo", $mnu )
$mnuRedo = GUICtrlCreateMenuItem( "Redo", $mnu )
GUICtrlCreateMenuItem( "", $mnu )
$mnuCut = GUICtrlCreateMenuItem( "Cut", $mnu )
$mnuCopy = GUICtrlCreateMenuItem( "Copy", $mnu )
$mnuPaste = GUICtrlCreateMenuItem( "Paste", $mnu )
GUICtrlCreateMenuItem( "", $mnu )
$mnuSelectAll = GUICtrlCreateMenuItem( "Select All", $mnu )
_GUICtrlRichEdit_SetEventMask( $edit, $ENM_MOUSEEVENTS )

GUISetState( @SW_SHOW )

GUIRegisterMsg( $WM_SIZE, "WM_SIZE" )
GUIRegisterMsg( $WM_NOTIFY, "WM_NOTIFY" )

HotKeySet( @TAB, "InsertTab" )
HotKeySet( @CR, "CheckAlign" )
HotKeySet( "+" & @CR, "CheckAlign" )
HotKeySet( "}", "CloseTab" )
HotKeySet( "{F5}", "Compile" )

Global $pos, $line, $column, $x, $y, $special = 0, $save

Global Const $COLOR_RED 	= 2037680
Global Const $COLOR_GREEN 	= 32768
Global Const $COLOR_BLACK 	= 0
Global Const $COLOR_BLUE 	= 16711680

Global $list = 0

While True
	$action = GUIGetMsg( )
	If $action == $GUI_EVENT_CLOSE Then
		$save = MsgBox( 3, "Standard Editor", "Do you want to save before close?" )
		If $save == 6 Then
			FileDelete( "main.cpp" )
			FileWrite( "main.cpp", _GUICtrlRichEdit_GetText( $edit ) )
			_GUICtrlRichEdit_Destroy( $edit )
			Exit
		ElseIf $save == 7 Then
			_GUICtrlRichEdit_Destroy( $edit )
			Exit
		Else
			ContinueLoop
		EndIf
	EndIf
	If $action == $Menu1Item1 Then
		FileDelete( "main.cpp" )
		FileWrite( "main.cpp", _GUICtrlRichEdit_GetText( $edit ) )
		MsgBox( 64, "Standard Editor", "Source file saved successful!" )
	ElseIf $action == $Menu1Item2 Then
		_GUICtrlRichEdit_Destroy( $edit )
		Exit
	EndIf
	If $action == $mnuUndo Then
		_GUICtrlRichEdit_Undo( $edit )
	ElseIf $action == $mnuRedo Then
		_GUICtrlRichEdit_Redo( $edit )
	ElseIf $action == $mnuCut Then
		_GUICtrlRichEdit_Cut( $edit )
	ElseIf $action == $mnuCopy Then
		_GUICtrlRichEdit_Copy( $edit )
	ElseIf $action == $mnuPaste Then
		_GUICtrlRichEdit_Paste( $edit )
	ElseIf $action == $mnuSelectAll Then
		_GUICtrlRichEdit_SetSel( $edit, 0, -1 )
	EndIf
	If $action == $Menu3Item1 Then
		$settings = GUICreate( "Settings", 450, 83 )
		GUICtrlCreateLabel( "Background Color : ", 10, 11, 180, 40 )
		GUICtrlSetFont( -1, 10 )
		$bg = GUICtrlCreateButton( "Choise", 150, 10, 100, 25 )
		GUICtrlCreateLabel( "Font Color           : ", 10, 51, 180 )
		GUICtrlSetFont( -1, 10 )
		$font = GUICtrlCreateButton( "Choise", 150, 50, 100, 25 )
		$apply = GUICtrlCreateButton( "Apply", 340, 25, 100, 30 )
		$b = 0
		$f = 0
		GUISetState( )
		While True
			$action = GUIGetMsg( )
			If $action == $GUI_EVENT_CLOSE Then
				GUIDelete( $settings )
				ExitLoop
			EndIf
			If $action == $apply Then
				FileDelete( "Settings.cfg" )
				If $b == "" Then
					$b = 0
				EndIf
				If $f == "" Then
					$f = 0
				EndIf
				FileWrite( "Settings.cfg", "editor.background=" & $b & @CRLF & "editor.fontsize=" & $f )
				MsgBox( 64, "Standard Editor", "To apply settings, please restart application." )
				GUIDelete( $settings )
				ExitLoop
			EndIf
			If $action == $bg Then
				$b = _ChooseColor( )
			ElseIf $action == $font Then
				$f = _ChooseFont( )
			EndIf
		WEnd
	EndIf
	If $action == $Menu4Item1 Then
		$settings = GUICreate( "About", 510, 100 )
		GUICtrlCreateLabel( "Standard Editor is basic C++ editor written in AutoIT" & @CRLF & @CRLF & "Author: Bruma Bogdan" & @CRLF & @CRLF & "Verision: 1.2.0.0", 10, 10 )
		$ok = GUICtrlCreateButton( "OK", 380, 50, 120, 30 )
		GUISetState( )
		While True
			$action = GUIGetMsg( )
			If $action == $GUI_EVENT_CLOSE Then
				GUIDelete( $settings )
				ExitLoop
			EndIf
			If $action == $ok Then
				GUIDelete( $settings )
				ExitLoop
			EndIf
		WEnd
	EndIf

	$l = ControlCommand( "Standard Editor", "", "", "GetCurrentLine", "" )
	$c = ControlCommand( "Standard Editor", "", "", "GetCurrentCol", "" )
	If $line <> $l Or $column <> $c Then
		If $c < 1000 Then
			$line = $l
			$column = $c
			_GUICtrlStatusBar_SetText( $bar, " Line = " & $line & " | Column = " & $column )
		EndIf
	EndIf
	Check( )
WEnd

Func WM_SIZE( $hWnd, $iMsg, $wParam, $lParam )
    Local $iWidth = _WinAPI_LoWord( $lParam )
    Local $iHeight = _WinAPI_HiWord( $lParam )
    _WinAPI_MoveWindow( $edit, 5, 5, $iWidth - 10, $iHeight - 130 )
	_WinAPI_MoveWindow( $bar, 0, 0, 0, 0 )
	_WinAPI_MoveWindow( $console, 5, $iHeight - 120, $iWidth - 10, 90 )
    Return 0
EndFunc

Func InsertTab( )
	If WinGetProcess( "" ) == @AutoItPID Then
		_GUICtrlRichEdit_InsertText( $edit, Chr( 9 ) )
	Else
		HotKeySet( @TAB )
		Send( @TAB )
		HotKeySet( @TAB, "InsertTab" )
	EndIf
EndFunc

Func HighLight( $pos, $x, $y, $color )
	_GUICtrlRichEdit_HideSelection( $edit )
	_GUICtrlRichEdit_SetSel( $edit, $x, $y )
	_GUICtrlRichEdit_SetCharColor( $edit, $color )
	_GUICtrlRichEdit_GotoCharPos( $edit, $pos )
	_GUICtrlRichEdit_Deselect( $edit )
	_GUICtrlRichEdit_HideSelection( $edit, False )
EndFunc

Func Check( )
	If _GUICtrlRichEdit_IsModified( $edit ) Then
		_GUICtrlRichEdit_SetReadOnly( $edit )
		ToolTip( "" )
		If $list <> 0 Then
			_GUICtrlListBox_Destroy( $list )
			$list = 0
		EndIf
		$pos = _GUICtrlRichEdit_GetSel( $edit )
		$pos = $pos[0]
		If $pos > 0 Then
			$char = _GUICtrlRichEdit_GetTextInRange( $edit, $pos - 1, $pos )
			If $char == "#" Then
				If $special == 0 Then
					HighLight( $pos, $pos - 1, $pos, $COLOR_BLUE )
				EndIf
			ElseIf $char == '"' Then
				HighLight( $pos, $pos - 1, $pos, $COLOR_RED )
				If $special == 1 Then
					$special = 0
				Else
					$special = 1
				EndIf
			ElseIf $char == "." Then
				If $special == 0 Then
					HighLight( $pos, $pos - 1, $pos, $COLOR_BLACK )
					CheckMember( )
				EndIf
			ElseIf $char <> @CRLF Then
				If $special == 0 Then
					HighLight( $pos, $pos - 1, $pos, $COLOR_BLACK )
				EndIf
			EndIf
		EndIf
		StringReplace( _GUICtrlRichEdit_GetText( $edit ), '"', "" )
		If Mod( @extended, 2 ) == 0 Then
			$special = 0
		Else
			$special = 1
		EndIf
		If $special == 0 And _GUICtrlRichEdit_GetCharColor( $edit ) <> $COLOR_RED Then
			$x = _GUICtrlRichEdit_GetCharPosOfPreviousWord( $edit, _GUICtrlRichEdit_GetCharPosOfNextWord( $edit, _GUICtrlRichEdit_GetCharPosOfPreviousWord( $edit, $pos - 1 ) ) )
			$y = _GUICtrlRichEdit_GetCharPosOfNextWord( $edit, $x )
			If $x + 1 <> $y Then
				$word = _GUICtrlRichEdit_GetTextInRange( $edit, $x, $y )
				$word = StringStripWS( $word, 8 )
				If $word == "cout" Or $word == "cin" Then
					$s = _GUICtrlRichEdit_FindTextInRange( $edit, "<iostream>", 0, -1 )
					If $s[0] == -1 Then
						ToolTip( "WARNING: You don't have included header *** iostream ***", @DesktopWidth / 2, @DesktopHeight / 2, "Standard Editor -- Helper", 2 )
					EndIf
				ElseIf $word == "ifstream" Or $word == "ofstream" Or $word == "fstream" Then
					$s = _GUICtrlRichEdit_FindTextInRange( $edit, "<fstream>", 0, -1 )
					If $s[0] == -1 Then
						ToolTip( "WARNING: You don't have included header *** fstream ***", @DesktopWidth / 2, @DesktopHeight / 2, "Standard Editor -- Helper", 2 )
					EndIf
				ElseIf $word == "getch" Or $word == "clrscr" Then
					$s = _GUICtrlRichEdit_FindTextInRange( $edit, "<conio.h>", 0, -1 )
					If $s[0] == -1 Then
						ToolTip( "WARNING: You don't have included header *** conio.h ***", @DesktopWidth / 2, @DesktopHeight / 2, "Standard Editor -- Helper", 2 )
					EndIf
				ElseIf $word == "strlen" Or $word == "strcpy" Or $word == "strdup" Or $word == "strstr" Or $word == "strchr" Or $word == "strncpy" Then
					$s = _GUICtrlRichEdit_FindTextInRange( $edit, "<string>", 0, -1 )
					If $s[0] == -1 Then
						ToolTip( "WARNING: You don't have included header *** string ***", @DesktopWidth / 2, @DesktopHeight / 2, "Standard Editor -- Helper", 2 )
					EndIf
				EndIf
				If $word == "break" Or $word == "include" Or $word == "int" Or $word == "case" Or $word == "char" Or $word == "class" Or $word == "const" Or $word == "continue" Or $word == "default" Or $word == "delete" Or $word == "do" Or $word == "else" Or $word == "enum" Or $word == "float" Or $word == "for" Or $word == "if" Or $word == "int" Or $word == "long" Or $word == "new" Or $word == "private" Or $word == "protected" Or $word == "public" Or $word == "return" Or $word == "short" Or $word == "signed" Or $word == "sizeof" Or $word == "static" Or $word == "struct" Or $word == "switch" Or $word == "typedef" Or $word == "unsigned" Or $word == "void" Or $word == "while" Or $word == "using" Or $word == "namespace" Or $word == "double" Then
				;If $word == "int" Or $word == "return" Or $word == "void" Or $word == "new" Or $word == "include" Or $word == "if" Or $word == "for" Or $word == "struct" Or $word == "do" Or $word == "while" Then
					HighLight( $pos, $x, $y, $COLOR_BLUE )
				ElseIf StringInStr( $word, '"' ) Then
					_GUICtrlRichEdit_SetReadOnly( $edit, False )
					_GUICtrlRichEdit_SetModified( $edit, False )
					Return
				ElseIf $word == "//" Then
					HighLight( $pos, $x, $y, $COLOR_GREEN )
				Else
					HighLight( $pos, $x, $y, $COLOR_BLACK )
				EndIf
			EndIf
			$x = _GUICtrlRichEdit_GetCharPosOfPreviousWord( $edit, _GUICtrlRichEdit_GetCharPosOfNextWord( $edit, _GUICtrlRichEdit_GetCharPosOfNextWord( $edit, $pos ) - 1 ) )
			$y = _GUICtrlRichEdit_GetCharPosOfNextWord( $edit, $x )
			If $x + 1 <> $y Then
				$word = _GUICtrlRichEdit_GetTextInRange( $edit, $x, $y )
				$word = StringStripWS( $word, 8 )
				If $word == "break" Or $word == "include" Or $word == "int" Or $word == "case" Or $word == "char" Or $word == "class" Or $word == "const" Or $word == "continue" Or $word == "default" Or $word == "delete" Or $word == "do" Or $word == "else" Or $word == "enum" Or $word == "float" Or $word == "for" Or $word == "if" Or $word == "int" Or $word == "long" Or $word == "new" Or $word == "private" Or $word == "protected" Or $word == "public" Or $word == "return" Or $word == "short" Or $word == "signed" Or $word == "sizeof" Or $word == "static" Or $word == "struct" Or $word == "switch" Or $word == "typedef" Or $word == "unsigned" Or $word == "void" Or $word == "while" Or $word == "using" Or $word == "namespace" Or $word == "double" Then
					HighLight( $pos, $x, $y, $COLOR_BLUE )
				ElseIf StringInStr( $word, '"' ) Then
					_GUICtrlRichEdit_SetReadOnly( $edit, False )
					_GUICtrlRichEdit_SetModified( $edit, False )
					Return
				ElseIf $word == "//" Then
					HighLight( $pos, $x, $y, $COLOR_GREEN )
				Else
					HighLight( $pos, $x, $y, $COLOR_BLACK )
				EndIf
			EndIf
		EndIf
		_GUICtrlRichEdit_SetReadOnly( $edit, False )
		_GUICtrlRichEdit_SetModified( $edit, False )
	EndIf
EndFunc

Func CheckAlign( )
	If WinGetProcess( "" ) == @AutoItPID Then
		$pos = _GUICtrlRichEdit_GetSel( $edit )
		$pos = $pos[0]
		$line = _GUICtrlRichEdit_GetLineNumberFromCharPos( $edit, $pos )
		$text = _GUICtrlRichEdit_GetTextInRange( $edit, _GUICtrlRichEdit_GetFirstCharPosOnLine( $edit ), $pos )
		$i = 1
		$final = @CRLF
		While True
			$char = StringMid( $text, $i, 1 )
			If $char == @TAB Or $char == "{" Then
				$final &= Chr( 9 )
				$i += 1
			Else
				ExitLoop
			EndIf
		WEnd
		_GUICtrlRichEdit_InsertText( $edit, $final )
	Else
		HotKeySet( @CR )
		Send( @CR )
		HotKeySet( @CR, "CheckAlign" )
	EndIf
EndFunc

Func CloseTab( )
	If WinGetProcess( "" ) == @AutoItPID Then
		$pos = _GUICtrlRichEdit_GetSel( $edit )
		$pos = $pos[0]
		$char = _GUICtrlRichEdit_GetTextInRange( $edit, $pos, $pos + 1 )
		If $char == @TAB Then
			_GUICtrlRichEdit_HideSelection( $edit )
			_GUICtrlRichEdit_SetSel( $edit, $pos, $pos + 1 )
			_GUICtrlRichEdit_ReplaceText( $edit, "}" )
			_GUICtrlRichEdit_Deselect( $edit )
			_GUICtrlRichEdit_HideSelection( $edit, False )
			Return
		EndIf
		$char = _GUICtrlRichEdit_GetTextInRange( $edit, $pos - 1, $pos )
		If $char == @TAB Then
			_GUICtrlRichEdit_HideSelection( $edit )
			_GUICtrlRichEdit_SetSel( $edit, $pos - 1, $pos )
			_GUICtrlRichEdit_ReplaceText( $edit, "}" )
			_GUICtrlRichEdit_Deselect( $edit )
			_GUICtrlRichEdit_HideSelection( $edit, False )
		Else
			_GUICtrlRichEdit_InsertText( $edit, "}" )
		EndIf
	Else
		HotKeySet( "}" )
		Send( "}" )
		HotKeySet( "}", "CloseTab" )
	EndIf
EndFunc

Func LoadCFG( )
	$file = FileRead( "Settings.cfg" )
	GUICtrlSetData( $progress, 10 )
	;Sleep( 200 )
	$file = StringSplit( $file, "=" & @CRLF )
	GUICtrlSetData( $progress, 20 )
	;Sleep( 200 )
	For $i = 1 To UBound( $file ) - 1
		If $file[$i] == "editor.background" Then
			$background = $file[$i+1]
			If $background == 0 Then
				$background = 16777215
			EndIf
			GUICtrlSetData( $progress, 30 )
			;Sleep( 300 )
		ElseIf $file[$i] == "editor.fontcolor" Then
			$fontsize = $file[$i+1]
			If $fontsize == 0 Then
				$fontsize = 18
			EndIf
			GUICtrlSetData( $progress, 40 )
			;Sleep( 300 )
		EndIf
	Next
	GUICtrlSetData( $progress, 100 )
	;Sleep( 500 )
EndFunc

Func WM_NOTIFY( $hWnd, $iMsg, $iWparam, $iLparam )
    #forceref $iMsg, $iWparam
    Local $hWndFrom, $iCode, $tNMHDR, $tMsgFilter, $hMenu
    $tNMHDR = DllStructCreate( $tagNMHDR, $iLparam )
    $hWndFrom = HWnd( DllStructGetData( $tNMHDR, "hWndFrom" ) )
    $iCode = DllStructGetData( $tNMHDR, "Code" )
    Switch $hWndFrom
        Case $edit
            Select
                Case $iCode == $EN_MSGFILTER
                    $tMsgFilter = DllStructCreate( $tagMSGFILTER, $iLparam )
                    If DllStructGetData( $tMsgFilter, "msg" ) == $WM_RBUTTONUP Then
                        $hMenu = GUICtrlGetHandle( $mnu )
                        SetMenuTexts( $hWndFrom, $hMenu )
                        _GUICtrlMenu_TrackPopupMenu( $hMenu, $hWnd )
                    EndIf
            EndSelect
    EndSwitch
    Return $GUI_RUNDEFMSG
EndFunc

Func SetMenuTexts( $hWnd, $hMenu )
    Local $fState
    If _GUICtrlRichEdit_CanUndo( $hWnd ) Then
        _GUICtrlMenu_SetItemEnabled( $hMenu, $mnuUndo, True, False )
        _GUICtrlMenu_SetItemText( $hMenu, $mnuUndo, "Undo", False )
    Else
        _GUICtrlMenu_SetItemText( $hMenu, $mnuUndo, "Undo", False )
        _GUICtrlMenu_SetItemEnabled( $hMenu, $mnuUndo, False, False )
    EndIf
    If _GUICtrlRichEdit_CanRedo( $hWnd ) Then
        _GUICtrlMenu_SetItemEnabled( $hMenu, $mnuRedo, True, False )
        _GUICtrlMenu_SetItemText( $hMenu, $mnuRedo, "Redo", False )
    Else
        _GUICtrlMenu_SetItemText( $hMenu, $mnuRedo, "Redo", False )
        _GUICtrlMenu_SetItemEnabled( $hMenu, $mnuRedo, False, False )
    EndIf
    $fState = _GUICtrlRichEdit_IsTextSelected( $hWnd )
    _GUICtrlMenu_SetItemEnabled( $hMenu, $mnuCut, $fState, False )
    _GUICtrlMenu_SetItemEnabled( $hMenu, $mnuCopy, $fState, False )
    _GUICtrlMenu_SetItemEnabled( $hMenu, $mnuPaste, _GUICtrlRichEdit_CanPaste( $hWnd ) )
    _GUICtrlMenu_SetItemEnabled( $hMenu, $mnuSelectAll )
EndFunc

Func CheckMember( )
	If $list <> 0 Then
		_GUICtrlListBox_Destroy( $list )
		$list = 0
	EndIf
	$x = _GUICtrlRichEdit_GetCharPosOfPreviousWord( $edit, $pos - 1 )
	$y = _GUICtrlRichEdit_GetCharPosOfNextWord( $edit, $x )
	$var = _GUICtrlRichEdit_GetTextInRange( $edit, $x, $y )
	$x = _GUICtrlRichEdit_FindTextInRange( $edit, $var, 0, $y, True, True )
	$x = $x[0]
	$x = _GUICtrlRichEdit_GetCharPosOfPreviousWord( $edit, $x )
	$y = _GUICtrlRichEdit_GetCharPosOfNextWord( $edit, $x )	;;;PROBLEMA
	$vartype = _GUICtrlRichEdit_GetTextInRange( $edit, $x, $y )
	ConsoleWrite( $vartype & @CRLF )
	$vartype = StringStripWS( $vartype, 8 )
	$x = _GUICtrlRichEdit_FindTextInRange( $edit, $vartype, 0, $y, True, True )
	If $x == 0 Then
		Return
	EndIf
	$x = $x[0]
	$y = _GUICtrlRichEdit_GetCharPosOfNextWord( $edit, $x )
	$finish = _GUICtrlRichEdit_FindTextInRange( $edit, "};", $y, -1, True, True )
	$finish = $finish[0]
	$final = _GUICtrlRichEdit_GetTextInRange( $edit, _GUICtrlRichEdit_GetCharPosOfNextWord( $edit, _GUICtrlRichEdit_GetCharPosOfNextWord( $edit,$y ) + 1 ), $finish )
	$final = StringSplit( $final, @TAB & @CRLF & ";, " )
	$xy = _GUICtrlRichEdit_GetXYFromCharPos( $edit, $pos )
	For $i = 1 To UBound( $final ) - 1 Step 2
		If $final[$i] <> "" Then
			If $list == 0 Then
				$list = _GUICtrlListBox_Create( $edit, "", $xy[0], $xy[1] + 20, 150, 70, BitOR( $WS_SIZEBOX, $WS_VSCROLL, $GUI_FOCUS ) )
				ControlFocus( "", "", $list )
				_WinAPI_SetFont( $list, _WinAPI_CreateFont( 16, 0, 0, 0, 500, False, False, False, $DEFAULT_CHARSET, $OUT_DEFAULT_PRECIS, $CLIP_DEFAULT_PRECIS, $DEFAULT_QUALITY, 0, "Courier New" ) )
			EndIf
			_GUICtrlListBox_InsertString( $list, $final[$i] )
		EndIf
	Next
	If _GUICtrlListBox_GetCount( $list ) > 0 Then
		_GUICtrlListBox_ClickItem( $list, 0 )
	EndIf
EndFunc

Func Compile( )
	If $save <> _GUICtrlRichEdit_GetText( $edit ) Then
		$save = _GUICtrlRichEdit_GetText( $edit )
		FileDelete( "main.cpp" )
		FileDelete( "a.exe" )
		_GUICtrlEdit_SetText( $console, "Compiling..." & @CRLF )
		FileWrite( "main.cpp", $save )
		$s = Run( @ComSpec & " /c " & "c++.exe main.cpp", "", @SW_HIDE, 0x08 )
		While True
			$m = StdoutRead( $s )
			If $m Then
				_GUICtrlEdit_AppendText( $console, $m & @CRLF )
				ExitLoop
			EndIf
			If @error Then
				ExitLoop
			EndIf
		WEnd
		If $m Then
			_GUICtrlEdit_AppendText( $console, "Compiling failed." )
		Else
			_GUICtrlEdit_AppendText( $console, "Done." )
		EndIf
	EndIf
	Run( "a.exe" )
EndFunc
" Vim completion script
" Language:    autoit v3
" Maintainer:  Raimon Grau
" Version:     1.0
" Last Change: 27/02/2006 13:24:44

" Set completion with CTRL-X CTRL-O to autoloaded function.

" This script will build a completion list based on the syntax
" elements defined by the files in $VIMRUNTIME/syntax.

if exists('&ofu')
	setlocal ofu=autoitcomplete#Complete
endif

if exists('g:loaded_autoit_completion')
	finish 
endif

let g:loaded_autoit_completion = 1

let s:cache_name = []
let s:cache_list = []

" This function is used for the 'omnifunc' option.
function! autoitcomplete#Complete(findstart, base)
	if a:findstart
		" Locate the start of the item, including "."
		let line = getline('.')
		let start = col('.') - 1
		let lastword = -1
		while start > 0
			if line[start - 1] =~ '\w'
				let start -= 1
			elseif line[start - 1] =~ '\.'
				" The user must be specifying a column name
				if lastword == -1
					let lastword = start
				endif
				let start -= 1
				let b:sql_compl_type = 'column'
			else
				break
			endif
		endwhile
        if lastword == -1
            let s:prepended = ''
            return start
        endif
        let s:prepended = strpart(line, start, lastword - start)
        return lastword
    endif

	let list=[]
	let milista = ['Abs ( expression )','ACos ( expression )','AdlibDisable ( )','AdlibEnable ( "function" [, time] )','And','Asc ( "char" )','ASin ( expression )','Assign ( "varname", "data" [, flag] )','ATan ( expression )','AutoItSetOption ( "option", param )','AutoItWinGetTitle ( )','AutoItWinSetTitle ( "newtitle" )','BitAND ( value1, value2 [, value n] )','BitNOT ( value )','BitOR ( value1, value2 [, value n] )','BitShift ( value, shift )','BitXOR ( value1, value2 [, value n] )','BlockInput ( flag )','Break ( mode )','ByRef','Call ( "function" )','Case','CDTray ( "drive", "status" )','Chr ( ASCIIcode )','ClipGet ( )','ClipPut ( "value" )','ConsoleWrite ( "data" )','Const','ContinueLoop','ControlClick ( "title", "text", controlID [, button] [, clicks]] )','ControlCommand ( "title", "text", controlID, "command", "option" )','ControlDisable ( "title", "text", controlID)','ControlEnable ( "title", "text", controlID )','ControlFocus ( "title", "text", controlID )','ControlGetFocus ( "title" [, "text"] )','ControlGetHandle ( "title", "text", controlID )','ControlGetPos ( "title", "text", controlID )','ControlGetText ( "title", "text", controlID )','ControlHide ( "title", "text", controlID )','ControlListView ( "title", "text", controlID, "command" [, option1 [, option2]] )','ControlMove ( "title", "text", controlID, x, y [, width [, height]] )','ControlSend ( "title", "text", controlID, "string" [, flag] )','ControlSetText ( "title", "text", controlID, "new text" )','ControlShow ( "title", "text", controlID )','Cos ( expression )','Dec ( "hex" )','Dim','DirCopy ( "source dir", "dest dir" [, flag] )','DirCreate ( "path" )','DirGetSize( "path" [, flag] )','DirMove ( "source dir", "dest dir" [, flag] )','DirRemove ( "path" [, recurse] )','DllCall ( "dll", "return type", "function" [, "type1", param1 [, "type n", param n]] )','DllClose ( dllhandle )','DllOpen ( "filename" )','Do','DriveGetDrive ( "type" )','DriveGetFileSystem ( "path" )','DriveGetLabel ( "path" )','DriveGetSerial ( "path" )','DriveGetType ( "path" )','DriveMapAdd( "device", "remote share" [, flags [, "user" [, "password"]]] )','DriveMapDel( "device" )','DriveMapGet( "device" )','DriveSetLabel ( "path", "label" )','DriveSpaceFree ( "path" )','DriveSpaceTotal ( "path" )','DriveStatus ( "path" )','Else','ElseIf','EndFunc','EndIf','EndSelect','EnvGet ( "envvariable" )','EnvSet ( "envvariable" [, "value"] )','EnvUpdate ( )','Eval ( expression )','Exit','Exit','ExitLoop','Exp ( expression )','FileChangeDir ( "path" )','FileClose ( filehandle )','FileCopy ( "source", "dest" [, flag] )','FileCreateShortcut ( "file", "lnk" [, "workdir" [, "args" [, "desc" [, "icon" [, "hotkey" [, icon number [, state]]]]]]] )','FileDelete ( "path" )','FileExists ( "path" )','FileFindFirstFile ( "filename" )','FileFindNextFile ( search )','FileGetAttrib ( "filename" )','FileGetLongName ( "file" )','FileGetShortcut ( "lnk" )','FileGetShortName ( "file" )','FileGetSize ( "filename" )','FileGetTime ( "filename" [, option [, format]] )','FileGetVersion ( "filename" )','FileInstall ( "source", "dest" [, flag] )','FileMove ( "source", "dest" [, flag] )','FileOpen ( "filename", mode )','FileOpenDialog ( "title", "init dir", "filter" [, options [, "default name"]] )','FileRead ( filehandle or "filename", count )','FileReadLine ( filehandle or "filename" [, line] )','FileRecycle ( "source" )','FileRecycleEmpty ( ["drive"] )','FileSaveDialog ( "title", "init dir", "filter" [, options [, "default name"]] )','FileSelectFolder ( "dialog text", "root dir" [, flag [, "initial dir"]] )','FileSetAttrib ( "file pattern", "+-RASHNOT" [, recurse] )','FileSetTime ( "file pattern", "time", type [, recurse] )','FileWrite ( filehandle or "filename", "line" )','FileWriteLine ( filehandle or "filename", "line" )','For','FtpSetProxy ( mode [, "proxy:port" [, "username", "password"]] )','Func','Global','GUICreate ( "title" [, width [, height [, left [, top [, style [, exStyle [, parent]]]]]]] )','GUICtrlCreateAvi ( filename, subfileid, left, top [, width [, height [, style [,  exStyle]]]] )','GUICtrlCreateButton ( "text", left, top [, width [, height [, style [, exStyle]]]] )','GUICtrlCreateCheckbox ( "text", left, top [, width [, height [, style [, exStyle]]]] )','GUICtrlCreateCombo ( "text", left, top [, width [, height [, style [, exStyle]]]] )','GUICtrlCreateContextMenu ( [controlID] )','GUICtrlCreateDate ( "text", left, top [, width [, height [, style [, exStyle]]]] )','GUICtrlCreateDummy ( )','GUICtrlCreateEdit ( "text", left, top [, width [, height [, style [, exStyle]]]] )','GUICtrlCreateGroup ( "text", left, top [, width [, height [, style [, exStyle]]]] )','GUICtrlCreateIcon ( filename, iconID, left, top [, width [, height [, style [, exStyle]]]] )','GUICtrlCreateInput ( "text", left, top [, width [, height [, style [, exStyle]]]] )','GUICtrlCreateLabel ( "text", left, top [, width [, height [, style [, exStyle]]]] )','GUICtrlCreateList ( "text", left, top [, width [, height [, style [, exStyle]]]] )','GUICtrlCreateListView ( "text", left, top [, width [, height [, style [, exStyle]]]] )','GUICtrlCreateListViewItem ( "text", listviewID )','GUICtrlCreateMenu ( "submenutext" [, menuID [, menuentry]] )','GUICtrlCreateMenuitem ( "text", menuID [, menuentry [, menuradioitem]] )','GUICtrlCreatePic ( filename, left, top [, width [, height [, style [, exStyle]]]] )','GUICtrlCreateProgress ( left, top [, width [, height [, style [, exStyle]]]] )','GUICtrlCreateRadio ( "text", left, top [, width [, height [, style [, exStyle]]]] )','GUICtrlCreateSlider ( left, top [, width [, height [, style [, exStyle]]]] )','GUICtrlCreateTab ( left, top [, width [, height [, style [, exStyle]]]] )','GUICtrlCreateTabItem ( "text" )','GUICtrlCreateTreeView ( left, top [, width [, height [, style [, exStyle]]]] )','GUICtrlCreateTreeViewItem ( "text", treeviewID )','GUICtrlCreateUpdown ( inputcontrolID [,style] )','GUICtrlDelete ( controlID )','GUICtrlGetState ( [controlID] )','GUICtrlRead ( controlID )','GUICtrlRecvMsg ( controlID , msg [, wParam [, lParamType]] )','GUICtrlSendMsg ( controlID, msg , wParam, lParam )','GUICtrlSendToDummy ( controlID [, state] )','GUICtrlSetBkColor ( controlID, backgroundcolor )','GUICtrlSetColor ( controlID, textcolor)','GUICtrlSetCursor ( controlID, cursorID )','GUICtrlSetData ( controlID, data [, default] )','GUICtrlSetFont (controlID, size [, weight [, attribute [, fontname]]] )','GUICtrlSetImage ( controlID, filename [, iconID [, icontype]] )','GUICtrlSetLimit ( controlID, max [, min] )','GUICtrlSetOnEvent ( controlID, "function" )','GUICtrlSetPos ( controlID, left, top [, width [, height]] )','GUICtrlSetResizing ( controlID, resizing )','GUICtrlSetState ( controlID, state )','GUICtrlSetStyle ( controlID, style [, exStyle] )','GUICtrlSetTip ( controlID, tiptext )','GUIDelete ( [winhandle] )','GUIGetCursorInfo ( [winhandle] )','GUIGetMsg ( [advanced] )','GUISetBkColor ( background [, winhandle] )','GUISetCoord ( left, top [, width [, height [, winhandle]]] )','GUISetCursor ( [cursorID [, override [, winhandle]]] )','GUISetFont (size [, weight [, attribute [, fontname [, winhandle]]]] )','GUISetHelp ( helpfile [, winhandle] )','GUISetIcon ( iconfile [, iconID [, winhandle]] )','GUISetOnEvent ( specialID, "function" [, winhandle] )','GUISetState ( [flag [, winhandle]] )','GUIStartGroup ( [winhandle] )','GUISwitch ( winhandle )','Hex ( number, length )','HotKeySet ( "key" [, "function"] )','HttpSetProxy ( mode [, "proxy:port" [, "username", "password"]] )','If','InetGet ( "URL", "filename" [, reload [, background]] )','InetGetSize ( "URL" )','IniDelete ( "filename", "section" [, "key"] )','IniRead ( "filename", "section", "key", "default" )','IniReadSection ( "filename", "section" )','IniReadSectionNames ( "filename" )','IniWrite ( "filename", "section", "key", "value" )','InputBox ( "title", "Prompt" [, "Default" [, "password char" [, Width, Height [, Left, Top [, TimeOut]]]]] )','Int ( expression )','IsAdmin ( )','IsArray ( variable )','IsDeclared ( expression )','IsFloat ( variable )','IsInt ( variable )','IsNumber ( variable )','IsString ( variable )','Local','Log ( expression )','MemGetStats ( )','Mod ( value1, value2 )','MouseClick ( "button" [, x, y [, clicks [, speed ]]] )','MouseClickDrag ( "button", x1, y1, x2, y2 [, speed] )','MouseDown ( "button" )','MouseGetCursor ( )','MouseGetPos ( )','MouseMove ( x, y [, speed] )','MouseUp ( "button" )','MouseWheel ( "direction" [, clicks] )','MsgBox ( flag, "title", "text" [, timeout] )','Next','Not','Number ( expression )','Or','Ping ( address or hostname [, timeout] )','PixelChecksum ( left, top, right, bottom [, step] )','PixelGetColor ( x , y )','PixelSearch ( left, top, right, bottom, color [, shade-variation] [, step]]  )','ProcessClose ( "process" )','ProcessExists ( "process" )','ProcessList ( ["name"] )','ProcessSetPriority ( "process", priority)','ProcessWait ( "process" [, timeout] )','ProcessWaitClose ( "process" [, timeout] )','ProgressOff ( )','ProgressOn ( "title", "maintext" [, "subtext" [, x pos [, y pos [, opt]]]] )','ProgressSet ( percent [, "subtext" [, "maintext"]] )','Random ( [Min [, Max [, Flag]]] )','ReDim','RegDelete ( "keyname" [, "valuename"] )','RegEnumKey ( "keyname", instance )','RegEnumVal ( "keyname", instance )','RegRead ( "keyname", "valuename" )','RegWrite ( "keyname" [,"valuename", "type", value] )','Return','Round ( expression [, decimalplaces]  )','Run ( "filename" [, "workingdir" [, flag]] )','RunAsSet ( ["user", "domain", "password" [, options]] )','RunWait ( "filename" [, "workingdir" [, flag]] )','Select','Send ( "keys" [, flag] )','SetError ( code )','SetExtended ( code )','Shutdown ( code )','Sin ( expression )','Sleep ( delay )','SoundPlay ( "filename" [, wait] )','SoundSetWaveVolume ( percent )','SplashImageOn ( "title", "file" [, width [, height [, x pos [, y pos [, opt]]]]] )','SplashOff ( )','SplashTextOn ( "title", "text" [, w [, h [, x pos [, y pos [, opt [, "fontname" [, "fontsz" [, "fontwt"]]]]]]]] )','Sqrt ( expression )','StatusbarGetText ( "title" [, "text" [, part]] )','Step','String ( expression )','StringAddCR ( "string" )','StringFormat ( "format control", var1 [, ... var32] )','StringInStr ( "string", "substring" [, casesense [, occurance]] )','StringIsAlNum ( "string" )','StringIsAlpha ( "string" )','StringIsASCII ( "string" )','StringIsDigit ( "string" )','StringIsFloat ( "string" )','StringIsInt ( "string" )','StringIsLower ( "string" )','StringIsSpace ( "string" )','StringIsUpper ( "string" )','StringIsXDigit ( "string" )','StringLeft ( "string", count )','StringLen ( "string" )','StringLower ( "string" )','StringMid ( "string", start [, count] )','StringReplace ( "string", "searchstring" or start, "replacestring" [, count [, casesense]] )','StringRight ( "string", count )','StringSplit ( "string", "delimiters" [, flag ] )','StringStripCR ( "string" )','StringStripWS ( "string", flag )','StringTrimLeft ( "string", count )','StringTrimRight ( "string", count )','StringUpper ( "string" )','Tan ( expression )','Then','TimerDiff ( timestamp )','TimerInit ( )','To','ToolTip ( "text" [, x [, y]] )','TrayTip ( "title", "text", timeout [, option] )','UBound ( Array [, Dimension] )','Until','WEnd','While','WinActivate ( "title" [, "text"] )','WinActive ( "title" [, "text"] )','WinClose ( "title" [, "text"] )','WinExists ( "title" [, "text"] )','WinGetCaretPos ( )','WinGetClassList ( "title" [, "text"] )','WinGetClientSize ( "title" [, "text"] )','WinGetHandle ( "title" [, "text"] )','WinGetPos ( "title" [, "text"] )','WinGetProcess ( "title" [, "text"] )','WinGetState ( "title" [, "text"] )','WinGetText ( "title" [, "text"] )','WinGetTitle ( "title" [, "text"] )','WinKill ( "title" [, "text"] )','WinList ( ["title" [, "text"]] )','WinMenuSelectItem ( "title", "text", "item" [, "item" [, "item" [, "item" [, "item" [, "item" [, "item"]]]]]] )','WinMinimizeAll ( )','WinMinimizeAllUndo ( )','WinMove ( "title", "text", x, y [, width [, height]] )','WinSetOnTop ( "title", "text", flag )','WinSetState ( "title", "text", flag )','WinSetTitle ( "title", "text", "newtitle" )','WinSetTrans ( "title", "text", transparency )','WinWait ( "title" [, "text" [, timeout]] )','WinWaitActive ( "title", ["text"], [timeout] )','WinWaitClose ( "title" [, "text" [, timeout]] )','WinWaitNotActive ( "title" [, "text" [, timeout]] )']

	let existe =0
		for line in milista
			if line =~ '^\(\w\+\)\s*\((.*)\)*'
				let paraula = substitute(line, '^\(\w\+\)\s*\((.*)\)*','\1','')
				let info = substitute(line, '^\(\w\+\)\s*\((.*)\)*','&','')
				if paraula =~ '^' . a:base
					call add(list,{"word": paraula ,"info": info, "icase" : 1})
				endif
			endif
		endfor
	let lines = getbufline(bufname('%'),1,"$")
	for linis in lines
		if linis =~ '^\s*Func\s\+\(\w\+\)\s*\((.*)\)'
				let paraula = substitute(linis, '^\s*Func\s\+\(\w\+\)\s*\((.*)\)','\1','')
				let info = substitute(linis, '^\s*Func\s\+\(\w\+\)\s*\((.*)\)','\1 \2','')
				if paraula =~ '^' . a:base
					call add(list,{"word": paraula ,"info": info, "icase" : 1})
				endif
		endif
	endfor
	return list
endfunction


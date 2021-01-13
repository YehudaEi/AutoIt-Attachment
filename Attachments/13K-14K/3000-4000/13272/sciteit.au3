#include <GUIConstants.au3>
#include "scintilla.h.au3"
#include <Array.au3>
#include <file.au3>
;#include "find.au3"
#include <Math.au3>
#include <Misc.au3>

Opt("GUIOnEventMode", 1)


#Region ### START Koda GUI section ### Form=AForm1.kxf
$Form1 = GUICreate("LEdit by lokster v0.5 (20070207)", 633, 450, -1, -1, BitOR($WS_MAXIMIZEBOX,$WS_MINIMIZEBOX,$WS_SIZEBOX,$WS_THICKFRAME,$WS_SYSMENU,$WS_CAPTION,$WS_OVERLAPPEDWINDOW,$WS_TILEDWINDOW,$WS_POPUPWINDOW,$WS_GROUP,$WS_TABSTOP,$WS_BORDER,$WS_CLIPSIBLINGS))
$mFile = GUICtrlCreateMenu("&File")
$mFileNew = GUICtrlCreateMenuItem("New (Ctrl+N)", $mFile)
$mFileOpen = GUICtrlCreateMenuItem("Open (Ctrl+O)", $mFile)
$mFileSave = GUICtrlCreateMenuItem("Save (Ctrl+S)", $mFile)
$mFileSaveAs = GUICtrlCreateMenuItem("Save As (Shift+S)", $mFile)
$mSep1 = GUICtrlCreateMenuItem("", $mFile)
$mFileExit = GUICtrlCreateMenuItem("Exit", $mFile)
$mEdit = GUICtrlCreateMenu("&Edit")
$mEditUndo = GUICtrlCreateMenuItem("Undo", $mEdit)
$mEditRedo = GUICtrlCreateMenuItem("Redo", $mEdit)
$mSep2 = GUICtrlCreateMenuItem("", $mEdit)
$mEditCut = GUICtrlCreateMenuItem("Cut", $mEdit)
$mEditCopy = GUICtrlCreateMenuItem("Copy", $mEdit)
$mEditPaste = GUICtrlCreateMenuItem("Paste", $mEdit)
$mEditDelete = GUICtrlCreateMenuItem("Delete", $mEdit)
$mSep3 = GUICtrlCreateMenuItem("", $mEdit)
$mEditSelectAll = GUICtrlCreateMenuItem("Select all", $mEdit)
$MenuItem2 = GUICtrlCreateMenu("&Search")
$mSearchFind = GUICtrlCreateMenuItem("Find / Replace (Ctrl+F)", $MenuItem2)
$mSearchFindNext = GUICtrlCreateMenuItem("Find next (F3)", $MenuItem2)
$mSearchFindPrevious = GUICtrlCreateMenuItem("Find previous (Shift+F3)", $MenuItem2)
$MenuItem5 = GUICtrlCreateMenuItem("", $MenuItem2)
$mSearchGotoLine = GUICtrlCreateMenuItem("Go to line (Ctrl+G)", $MenuItem2)
$mView = GUICtrlCreateMenu("&View")
$mViewLineNumbers = GUICtrlCreateMenuItem("Line numbers", $mView)
$mViewFolds = GUICtrlCreateMenuItem("Folds", $mView)
$mViewWhitespaces = GUICtrlCreateMenuItem("Whitespaces", $mView)
$mHighlighter = GUICtrlCreateMenu("H&ighlighter")
$mHelp = GUICtrlCreateMenu("&Help")
$mHelpAbout = GUICtrlCreateMenuItem("About", $mHelp)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

#Region ### START Koda GUI section ### Form=find.kxf
$fFind1 = GUICreate("Find / Replace", 402, 137, -1, -1, BitOR($WS_SYSMENU,$WS_CAPTION,$WS_POPUPWINDOW,$WS_BORDER,$WS_CLIPSIBLINGS,$DS_MODALFRAME), BitOR($WS_EX_TOOLWINDOW,$WS_EX_TOPMOST,$WS_EX_WINDOWEDGE))
$Label1 = GUICtrlCreateLabel("Find what:", 8, 12, 53, 17)
$Label2 = GUICtrlCreateLabel("Replace with:", 8, 36, 69, 17)
$Combo1 = GUICtrlCreateCombo("", 80, 8, 193, 25)
$Combo2 = GUICtrlCreateCombo("", 80, 32, 193, 25)
$cbFindWholeWords = GUICtrlCreateCheckbox("Match whole words only", 8, 80, 137, 17)
$cbFindMatchCase = GUICtrlCreateCheckbox("Match case", 8, 96, 81, 17)
$cbFindRe = GUICtrlCreateCheckbox("Regular expression", 8, 64, 113, 17)
$btnFindNext = GUICtrlCreateButton("Find next", 280, 8, 115, 25, $BS_DEFPUSHBUTTON)
GUICtrlSetOnEvent(-1, "btnFindNextClick")
$btnFindReplace = GUICtrlCreateButton("Replace", 280, 40, 115, 25, 0)
GUICtrlSetOnEvent(-1, "btnFindReplaceClick")
$btnFindReplaceAll = GUICtrlCreateButton("Replace All", 280, 72, 115, 25, 0)
GUICtrlSetOnEvent(-1, "btnFindReplaceAllClick")
$btnFindClose = GUICtrlCreateButton("Close", 280, 104, 115, 25, 0)
GUICtrlSetOnEvent(-1, "CloseFind")
$Group1 = GUICtrlCreateGroup("Direction", 208, 72, 65, 57)
$rFindDirectionUp = GUICtrlCreateRadio("up", 216, 88, 49, 17)
$rFindDirectionDown = GUICtrlCreateRadio("down", 216, 104, 49, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$cbFindWrapAround = GUICtrlCreateCheckbox("Wrap around", 8, 112, 97, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$cbFindShowWarnings = GUICtrlCreateCheckbox("Show warnings", 104, 112, 97, 17)
#EndRegion ### END Koda GUI section ###
GUISetOnEvent($GUI_EVENT_CLOSE, "CloseFind",$fFind1)

GUISetOnEvent($GUI_EVENT_CLOSE, "Bye",$Form1)
GUISetOnEvent($GUI_EVENT_RESIZED, "FitEditor",$Form1)
GUISetOnEvent($GUI_EVENT_MAXIMIZE, "FitEditor",$Form1)
GUISetOnEvent($GUI_EVENT_RESTORE, "FitEditor",$Form1)

;menu events
;File
GUICtrlSetOnEvent($mFile,"MenuCmd")
GUICtrlSetOnEvent($mFileNew,"MenuCmd")
GUICtrlSetOnEvent($mFileOpen,"MenuCmd")
GUICtrlSetOnEvent($mFileSave,"MenuCmd")
GUICtrlSetOnEvent($mFileSaveAs,"MenuCmd")
GUICtrlSetOnEvent($mFileExit,"MenuCmd")
;Edit
GUICtrlSetOnEvent($mEdit,"MenuCmd")
GUICtrlSetOnEvent($mEditUndo,"MenuCmd")
GUICtrlSetOnEvent($mEditRedo,"MenuCmd")
GUICtrlSetOnEvent($mEditCut,"MenuCmd")
GUICtrlSetOnEvent($mEditCopy,"MenuCmd")
GUICtrlSetOnEvent($mEditPaste,"MenuCmd")
GUICtrlSetOnEvent($mEditDelete,"MenuCmd")
GUICtrlSetOnEvent($mEditSelectAll,"MenuCmd")
;Search
GUICtrlSetOnEvent($mSearchFind,"MenuCmd")
GUICtrlSetOnEvent($mSearchFindNext,"MenuCmd")
GUICtrlSetOnEvent($mSearchFindPrevious,"MenuCmd")
GUICtrlSetOnEvent($mSearchGotoLine,"MenuCmd")
;View
GUICtrlSetOnEvent($mViewLineNumbers,"MenuCmd")
GUICtrlSetOnEvent($mViewFolds,"MenuCmd")
GUICtrlSetOnEvent($mViewWhitespaces,"MenuCmd")

;Help
GUICtrlSetOnEvent($mHelpAbout,"MenuCmd")

global const $MARGIN_SCRIPT_FOLD_INDEX = 1
Global const $appname = "LEdit by lokster (Scintilla example)"

global $sci
global $user32 = DllOpen("user32.dll")
global $kernel32 = DllOpen("kernel32.dll")
global $_FILENAME ;holds the currently opened filename
Global $highlighters
global $highlighters_menu[1]
Global $cmdrun,$cmdbuild,$cmdcompile
Global $_CUR_FIND_POS = 0
;Options
Global $show_line_numbers =False
Global $default_style = "0x000000,0xFFFFFF,10,Courier New,0,0,0"
Global $tab_width = 2
Global $show_folds = False
Global $show_whitespaces = False
;Find
Global $_OPT_FIND_WRAPAROUND = True
Global $findWhat=""
Global $reverseDirection=False
Global $showWarnings=False
Global $flags=0

Func CloseFind()
	GUISetState(@SW_HIDE,$fFind1)
EndFunc

Func btnFindNextClick()
	Global $sci,$flags,$findWhat,$findTarget,$wrapFind,$reverseDirection
	$flags = 0
	
	if GUICtrlRead($cbFindMatchCase)==$GUI_CHECKED Then
		$flags = BitOR($flags,$SCFIND_MATCHCASE)
	EndIf
	
	if GUICtrlRead($cbFindWholeWords)==$GUI_CHECKED Then
		$flags = BitOR($flags,$SCFIND_WHOLEWORD)
	EndIf
	
	if GUICtrlRead($cbFindRe)==$GUI_CHECKED Then
		$flags = BitOR($flags,$SCFIND_REGEXP,$SCFIND_POSIX)
	EndIf
	
	if GUICtrlRead($cbFindWrapAround)==$GUI_CHECKED Then
		$wrapFind = True
	Else
		$wrapFind = False
	EndIf
	

	if GUICtrlRead($rFindDirectionUp)==$GUI_CHECKED Then
		$reverseDirection = True
	Else
		$reverseDirection = False
	EndIf
	
	if GUICtrlRead($cbFindShowWarnings)==$GUI_CHECKED Then
		$showWarnings = True
	Else
		$showWarnings = False
	EndIf
	
	$findWhat = GUICtrlRead($Combo1)
	GUICtrlSetData($Combo1,$findWhat,$findWhat)
	FindNext(GUICtrlRead($Combo1),$reverseDirection, $showWarnings,$flags)
EndFunc

		
Func btnFindReplaceAllClick()
	Global $sci,$flags,$findWhat,$findTarget,$wrapFind,$reverseDirection
	$flags = 0
	
	if GUICtrlRead($cbFindMatchCase)==$GUI_CHECKED Then
		$flags = BitOR($flags,$SCFIND_MATCHCASE)
	EndIf
	
	if GUICtrlRead($cbFindWholeWords)==$GUI_CHECKED Then
		$flags = BitOR($flags,$SCFIND_WHOLEWORD)
	EndIf
	
	if GUICtrlRead($cbFindRe)==$GUI_CHECKED Then
		$flags = BitOR($flags,$SCFIND_REGEXP,$SCFIND_POSIX)
	EndIf
	
	if GUICtrlRead($cbFindWrapAround)==$GUI_CHECKED Then
		$wrapFind = True
	Else
		$wrapFind = False
	EndIf
	

	if GUICtrlRead($rFindDirectionUp)==$GUI_CHECKED Then
		$reverseDirection = True
	Else
		$reverseDirection = False
	EndIf
	
	if GUICtrlRead($cbFindShowWarnings)==$GUI_CHECKED Then
		$showWarnings = True
	Else
		$showWarnings = False
	EndIf
	
	$findWhat = GUICtrlRead($Combo1)
	While FindNext($findWhat,$reverseDirection, $showWarnings,$flags)>-1
		SendMessageString($sci,$SCI_REPLACESEL,0,GUICtrlRead($Combo2))
	WEnd
EndFunc

		
Func btnFindReplaceClick()
	If GetSelLength($sci)>0 Then
		SendMessageString($sci,$SCI_REPLACESEL,0,GUICtrlRead($Combo2))
		btnFindNextClick()
	EndIf
EndFunc

		
Func btnFindReplaceInSelClick()

EndFunc

Func NewFile()
	if SendMessage($sci, $SCI_GETMODIFY,0,0) <> 0 Then
		$ans = MsgBox(3+32,"Confirm","Save changes to file "&$_FILENAME)
		switch $ans
			case 2 ; cancel
				Return
			case 6 ;yes
				SaveFile($_FILENAME)
			case 7 ;no
		EndSwitch
	EndIf

	SendMessage($sci, $SCI_CLEARALL,0,0)
	SendMessage($sci, $SCI_EMPTYUNDOBUFFER,0,0)
	SendMessage($sci, $SCI_SETSAVEPOINT,0,0)
	$_FILENAME = ""
	SetWindowTitle()
EndFunc

Func SetWindowTitle()
	If $_FILENAME <> "" Then
		WinSetTitle($form1,"",$_FILENAME&" - "&$appname)
	Else
		WinSetTitle($form1,"","New - "&$appname)
	EndIf
EndFunc

Func GoToLine()
	$line = InputBox("Go to line","Enter line number","","",-1,40)
	if StringIsInt ($line) Then
		SendMessage($sci,$SCI_ENSUREVISIBLEENFORCEPOLICY, $line,0);
		SendMessage($sci,$SCI_GOTOLINE,$line,0)
	EndIf
EndFunc

Func IniReadLong($file,$section,$key,$default="")
	$handle = FileOpen($file,0)
	Local $longline
	Local $found = False
	while 1
		$line = FileReadLine($handle)
		if @error = -1 Then
			ExitLoop
		EndIf

		$pos = StringInStr($line,$key&"=",0,1)
		
		if $pos = 1 Then
			$found = true
			$line = StringReplace($line,$key&"=","",1)
		EndIf
		
		if $found Then
			if $line = "" Then
				ExitLoop
			ElseIf StringInStr($line,"\",0,-1)>0 Then
				$line = StringTrimRight($line,1)
				$longline &= $line
				ExitLoop
			ElseIf StringInStr($line,"=")>0 Then
				ExitLoop
			Else
				$longline &= $line
			EndIf
		EndIf

	WEnd
	FileClose($handle)
	if $longline = "" Then
		$longline = $default
	EndIf
	Return $longline
EndFunc

Func SetProperty($sci,$property,$value)
	Local $ret
	If IsInt($property) Then
		$prop_type = "int"
	ElseIf IsString($property) Then
		$prop_type = "str"
	EndIf
	
	If IsInt($value) Then
		$val_type = "int"
	ElseIf IsString($value) Then
		$val_type = "str"
	EndIf
		
	$ret = DllCall($user32, "int", "SendMessageA", "hwnd", $sci, "int", $SCI_SETPROPERTY, $prop_type, $property, $val_type, $value)	
	Return $ret[0]
EndFunc

Func OpenFile()
	if SendMessage($sci, $SCI_GETMODIFY,0,0) <> 0 Then
		$ans = MsgBox(3+32,"Confirm","Save changes to file "&$_FILENAME)
		switch $ans
			case 2 ; cancel
				Return
			case 6 ;yes
				SaveFile($_FILENAME)
		EndSwitch
	EndIf	
				
	$from = FileOpenDialog("Open file...","","All files (*.*)")
	if $from = '' Then
		Return
	EndIf
	$_FILENAME = $from
	
	SendMessage($sci, $SCI_CLEARALL,0,0)
	SendMessage($sci, $SCI_EMPTYUNDOBUFFER,0,0)
	SendMessage($sci, $SCI_SETSAVEPOINT,0,0)
	SendMessage($sci, $SCI_CANCEL,0,0)
	SendMessage($sci, $SCI_SETUNDOCOLLECTION,0,0)
	
	DetectHighlighter($_FILENAME)
	$file = FileOpen($from,0)
	While 1
		$buffer = FileRead($file, 1024)
		If @error = -1 Then ExitLoop
		SendMessageString($sci, $SCI_APPENDTEXT, StringLen($buffer), $buffer)
	Wend
	FileClose($file)
	SendMessage($sci, $SCI_SETUNDOCOLLECTION, 1,0)
	SendMessage($sci, $SCI_EMPTYUNDOBUFFER,0,0)
	SendMessage($sci, $SCI_SETSAVEPOINT,0,0)
	SendMessage($sci, $SCI_GOTOPOS, 0,0)
	SetWindowTitle()
EndFunc

Func SaveFile($fn="")
	if $fn = '' then 
		$fn = FileSaveDialog("Save file...","","All files (*.*)")
	EndIf
	
	if $fn <>'' Then
		$_FILENAME = $fn
		$len = SendMessage($sci,$SCI_GETLENGTH,0,0)
		$text = DllStructCreate("char["&$len&"]")
		DllCall($user32, "int", "SendMessageA", "hwnd", $sci, "int", $SCI_GETTEXT, "int", $len+1, "ptr", DllStructGetPtr($text))
		;MsgBox(0,0,DllStructGetData($text,1))
		$handle = FileOpen($_FILENAME,2)
		FileWrite($handle,DllStructGetData($text,1))
		FileClose($handle)
		$text = 0
		SendMessageString($sci, $SCI_SETUNDOCOLLECTION, 1,0)
		SendMessageString($sci, $SCI_EMPTYUNDOBUFFER,0,0)
		SendMessageString($sci, $SCI_SETSAVEPOINT,0,0)
		SetWindowTitle()
		Return True
	Else
		Return False
	EndIf
	
EndFunc

Func MenuCmd()
	Switch @GUI_CTRLID
		case $mFileNew
			NewFile()
		case $mFileOpen
			OpenFile()
		case $mFileSave
			SaveFile($_FILENAME)
		case $mFileSaveAs
			SaveFile()
		case $mSearchFind
			GUISetState(@SW_SHOW,$fFind1)
		case $mSearchFindNext
			FindNext($findWhat,False, $showWarnings,$flags,False)
		Case $mSearchFindPrevious
			FindNext($findWhat,True, $showWarnings,$flags,False)
		case $mEditUndo
			SendMessage($sci,$SCI_UNDO,0,0)
		case $mEditRedo
			SendMessage($sci,$SCI_REDO,0,0)
		case $mEditCut
			SendMessage($sci,$SCI_CUT,0,0)
		case $mEditCopy
			SendMessage($sci,$SCI_COPY,0,0)
		case $mEditPaste
			SendMessage($sci,$SCI_PASTE,0,0)
		case $mEditDelete
			SendMessage($sci,$SCI_CLEAR,0,0)
		case $mEditSelectAll
			SendMessage($sci,$SCI_SELECTALL,0,0)
		case $mSearchGotoLine
			GoToLine()
		case $mViewLineNumbers
			$show_line_numbers = not $show_line_numbers
			ShowLineNumbers($show_line_numbers)
		case $mViewWhitespaces
			$show_whitespaces = not $show_whitespaces
			ShowWhitespaces($show_whitespaces)
		case $mViewFolds
			$show_folds = not $show_folds
			ShowFolds($show_folds)
		case $mHelpAbout
			MsgBox(64,"About","Scintilla example by lokster")
		case $mFileExit
			Bye()
	EndSwitch
EndFunc

Func Bye()
	if SendMessage($sci, $SCI_GETMODIFY,0,0) <> 0 Then
		$ans = MsgBox(3+32,"LEdit","Save changes to file "&$_FILENAME)
		switch $ans
			case 2 ; cancel
				Return
			case 6 ;yes
				SaveFile($_FILENAME)
			case 7 ;no
		EndSwitch
	EndIf
	DllClose($user32)
	DllClose($kernel32)
	Exit
EndFunc

Func errDllCall($err, $ext, $erl=@ScriptLineNumber)
   Local $ret = 0
   If $err <> 0 Then
      ConsoleWrite("(" & $erl & ") := @error:=" & $err & ", @extended:=" & $ext & @LF)
      $ret = 1
   EndIf
   Return $ret
EndFunc

Func CreateWindowEx($dwExStyle, $lpClassName, $lpWindowName="", $dwStyle=-1, $x=0, $y=0, $nWidth=0, $nHeight=0, $hwndParent=0, $hMenu=0, $hInstance=0, $lParm=0 )
   Local $ret
   If $hInstance=0 Then
      $ret = DLLCall( $user32,"long","GetWindowLong","hwnd",$hwndParent,"int",-6)
      $hInstance = $ret[0]
   EndIf
   $ret =  DllCall($user32, "hwnd", "CreateWindowEx", "long", $dwExStyle, _
            "str", $lpClassName, "str", $lpWindowName, _
            "long", $dwStyle, "int", $x, "int", $y, "int", $nWidth, "int", $nHeight, _
            "hwnd", $hwndParent, "hwnd", $hMenu, "long", $hInstance, "ptr", $lParm)
   If errDllCall(@error, @extended) Then Exit
   Return $ret[0]
EndFunc

Func LoadLibrary($lpFileName)
   Local $ret
   $ret = DllCall($kernel32, "int", "LoadLibrary", "str", $lpFileName)
   If errDllCall(@error, @extended) Then Exit
   Return $ret[0]
EndFunc

Func SendMessage($sci,$msg, $wp, $lp)
   Local $ret
   $ret = DllCall($user32, "long", "SendMessageA", "long", $sci, "int", $msg, "int", $wp, "int", $lp)
   Return $ret[0]
EndFunc

Func SendMessageString($sci,$msg, $wp, $str)
   Local $ret
   $ret = DllCall($user32, "int", "SendMessageA", "hwnd", $sci, "int", $msg, "int", $wp, "str", $str)
   Return $ret[0]
EndFunc

Func SetWindowPos($hwnd, $style, $left, $top, $width, $height, $flags)
   Local $ret
   $ret = DllCall($user32, "long", "SetWindowPos", "long", $hwnd, "long", $style, _
   "long", $left, "long", $top, "long", $width, "long", $height, _
   "long", $flags)
   If errDllCall(@error, @extended) Then Exit
   Return $ret[0]
EndFunc


Func FitEditor()
	;MsgBox(0,0,0)
	$size = WinGetClientSize($Form1)
	;SetWindowPos(GUICtrlGetHandle($Edit1),0,0,$size[1]-100,$size[0],100,0)
    SetWindowPos($sci, 0, 0, 0, $size[0], $size[1], 0)
	GUISetState(@SW_SHOW,$Form1)
EndFunc

Func CreateEditor()
    Local $GWL_HINSTANCE = -6
    Local $hLib = LoadLibrary("SciLexer.DLL")

    Local $hInstance = 0
	global $sci
	
    $sci = CreateWindowEx($WS_EX_CLIENTEDGE, "Scintilla", _
            "TEST", BitOR($WS_CHILD, $WS_VISIBLE,$WS_HSCROLL,$WS_VSCROLL, $WS_TABSTOP, $WS_CLIPCHILDREN), 0, 0, 100, 100, _
            $form1, 0, $hInstance, 0)
	GUISetState(@SW_SHOW,$Form1)
EndFunc

Func LoadHiglight($file)
	if not FileExists($file) Then
		MsgBox(16,"Error","The highlighter file "&$file&" does not exist!")
		Return
	EndIf
	
	$cmdrun = IniRead($file,"","run","")
	$cmdbuild = IniRead($file,"","build","")
	$cmdcompile = IniRead($file,"","compile","")
	SetStyle($STYLE_DEFAULT,IniRead($file,"","DefaultStyle",$default_style))
	SendMessageString($sci,$SCI_STYLECLEARALL,0,0)
	
	SendMessageString($sci,$SCI_SETLEXER,IniRead($file,"","lex",0),0)
	$bits = SendMessageString($sci,$SCI_GETSTYLEBITSNEEDED,0,0)
	SendMessageString($sci,$SCI_SETSTYLEBITS,$bits,0)
	
	$inif = FileRead($file)
	$arr = StringRegExp($inif,"(?m)^style([0-9]+)=(.*)",3)
	for $i = 0 to UBound($arr)-1 step 2
		SetStyle($arr[$i],$arr[$i+1])
	Next
	
	$arr = StringRegExp($inif,"(?m)(?s)(?U)^words([0-9]+)=(.*)\r\n\r\n",3)
	for $i = 0 to UBound($arr)-1 step 2
		SendMessageString($sci,$SCI_SETKEYWORDS,$arr[$i],$arr[$i+1])
	Next
EndFunc

Func InitEditor()
	SetStyle($STYLE_DEFAULT,$default_style)
	ListHighlighters()
	ShowLineNumbers($show_line_numbers)	
	SendMessage($sci,$SCI_SETTABWIDTH,$tab_width,0)
	ShowWhitespaces($show_whitespaces)
	SetProperty($sci,"fold", "1")
	SetProperty($sci,"fold.compact", "1")
	SetProperty($sci,"fold.comment", "1")
	SetProperty($sci,"fold.preprocessor", "1")
	SendMessageString($sci,$SCI_SETBUFFEREDDRAW, 1, 0); buffered drawing of the text
	;setup folds margin
	SendMessage($sci,$SCI_SETMARGINTYPEN, $MARGIN_SCRIPT_FOLD_INDEX, $SC_MARGIN_SYMBOL)
	SendMessage($sci,$SCI_SETMARGINMASKN, $MARGIN_SCRIPT_FOLD_INDEX, $SC_MASK_FOLDERS)
	SendMessage($sci,$SCI_MARKERDEFINE, $SC_MARKNUM_FOLDER, $SC_MARK_PLUS)
	SendMessage($sci,$SCI_MARKERDEFINE, $SC_MARKNUM_FOLDEROPEN, $SC_MARK_MINUS)
	SendMessage($sci,$SCI_MARKERDEFINE, $SC_MARKNUM_FOLDEREND, $SC_MARK_EMPTY)
	SendMessage($sci,$SCI_MARKERDEFINE, $SC_MARKNUM_FOLDERMIDTAIL, $SC_MARK_EMPTY)
	SendMessage($sci,$SCI_MARKERDEFINE, $SC_MARKNUM_FOLDEROPENMID, $SC_MARK_EMPTY)
	SendMessage($sci,$SCI_MARKERDEFINE, $SC_MARKNUM_FOLDERSUB, $SC_MARK_EMPTY)
	SendMessage($sci,$SCI_MARKERDEFINE, $SC_MARKNUM_FOLDERTAIL, $SC_MARK_EMPTY)
	SendMessage($sci,$SCI_SETFOLDFLAGS, 16, 0)
	SendMessage($sci,$SCI_SETMARGINSENSITIVEN, 1, 1)
	ShowFolds($show_folds)
	;----
	ClearCmdKey($sci,0x47,$SCMOD_CTRL);unbind the default ctrl+g action
	ClearCmdKey($sci,0x4E,$SCMOD_CTRL);unbind the default ctrl+n action
	ClearCmdKey($sci,0x4F,$SCMOD_CTRL);unbind the default ctrl+o action
	ClearCmdKey($sci,0x53,$SCMOD_CTRL);unbind the default ctrl+s action
	ClearCmdKey($sci,0x46,$SCMOD_CTRL);unbind the default ctrl+f action
	ClearCmdKey($sci,0x53,$SCMOD_SHIFT);unbind the default shift+s action
	ClearCmdKey($sci,0x46,$SCMOD_SHIFT);unbind the default shift+f action
	GUIRegisterMsg(0x004E,"WM_NOTIFY") ;WM_NOTIFY
EndFunc

Func ClearCmdKey($sci,$keycode,$modifier=0)
	Return SendMessage($sci,$SCI_CLEARCMDKEY, BitShift($modifier,-16)+$keycode, 0);
EndFunc

Func WM_NOTIFY($hWndGUI, $MsgID, $wParam, $lParam)
    #forceref $hWndGUI, $MsgID, $wParam
    Local $tagNMHDR, $event
    ;$tagNMHDR = DllStructCreate("int;int;int", $lParam);NMHDR (hwndFrom, idFrom, code)
	$tagNMHDR = DllStructCreate("int;int;int;int;int;int;int;ptr;int;int;int;int;int;int;int;int;int;int;int",$lParam)
    If @error Then Return
	
    $hwndFrom = DllStructGetData($tagNMHDR, 1)
    $idFrom = DllStructGetData($tagNMHDR, 2)
    $event = DllStructGetData($tagNMHDR, 3)
	$position = DllStructGetData($tagNMHDR, 4)
	$ch = DllStructGetData($tagNMHDR, 5)
	$modifiers = DllStructGetData($tagNMHDR, 6)
	$modificationType = DllStructGetData($tagNMHDR, 7)
	$char = DllStructGetData($tagNMHDR, 8)
	$length = DllStructGetData($tagNMHDR, 9)
	$linesAdded = DllStructGetData($tagNMHDR, 10)
	$message = DllStructGetData($tagNMHDR, 11)
	$uptr_t = DllStructGetData($tagNMHDR, 12)
	$sptr_t = DllStructGetData($tagNMHDR, 13)
	$line = DllStructGetData($tagNMHDR, 14)
	$foldLevelNow = DllStructGetData($tagNMHDR, 15)
	$foldLevelPrev = DllStructGetData($tagNMHDR, 16)
	$margin = DllStructGetData($tagNMHDR, 17)
	$listType = DllStructGetData($tagNMHDR,18)
	$x = DllStructGetData($tagNMHDR, 19)
	$y = DllStructGetData($tagNMHDR, 20)
	$line_number = SendMessage($sci,$SCI_LINEFROMPOSITION, $position, 0)
    Select
		Case $hwndFrom = $sci
            Select
                Case $event = $SCN_MARGINCLICK
					SendMessage($sci,$SCI_TOGGLEFOLD, $line_number, 0)
            EndSelect
    EndSelect
    $tagNMHDR = 0
    $event = 0
    $lParam = 0
    Return $GUI_RUNDEFMSG	
EndFunc


Func FindInTarget($findWhat, $lenFind, $startPosition, $endPosition)
	Global $findTarget;

	SendMessage($sci,$SCI_SETTARGETSTART, $startPosition,0)
	SendMessage($sci,$SCI_SETTARGETEND, $endPosition,0)

	$findWhatPtr = DllStructCreate("char["&StringLen($findWhat)+1&"]")
	DllStructSetData($findWhatPtr,1,$findWhat)
	$ret = DllCall($user32, "int", "SendMessageA", "hwnd", $sci, "int", $SCI_SEARCHINTARGET, "int", StringLen($findWhat), "ptr", DllStructGetPtr($findWhatPtr))
	$posFind = $ret[0]
	ConsoleWrite("$posFind1="&$posFind&@CR)


	$findWhatPtr = 0
	return $posFind;
EndFunc

Func WarnUser($txt)
	Return MsgBox(262144+8192,"Warning",$txt)
EndFunc

Func EnsureRangeVisible($posStart, $posEnd, $enforcePolicy=False)
	$lineStart = SendMessage($sci,$SCI_LINEFROMPOSITION,  _Min($posStart, $posEnd),0);
	$lineEnd = SendMessage($sci,$SCI_LINEFROMPOSITION, _Max($posStart, $posEnd),0);
	for $line = $lineStart To $lineEnd
		If ($enforcePolicy) Then
			SendMessage($sci,$SCI_ENSUREVISIBLEENFORCEPOLICY,$line,0)
		Else
			SendMessage($sci,$SCI_ENSUREVISIBLE,$line,0)
			
		EndIf
	Next
EndFunc

Func SetSelection($anchor, $currentPos)
	SendMessage($sci, $SCI_SETSEL, $anchor, $currentPos)
EndFunc

Func FindNext($findWhat,$reverseDirection=False, $showWarnings=True,$flags=0,$showgui=False)
	Global $findTarget,$wrapFind,$replacing
	If ($findWhat=="") Or ($showgui) Then
		If $reverseDirection Then
			GUICtrlSetState($rFindDirectionUp,$GUI_CHECKED)
			GUICtrlSetState($rFindDirectionDown,$GUI_UNCHECKED)
		Else
			GUICtrlSetState($rFindDirectionUp,$GUI_UNCHECKED)
			GUICtrlSetState($rFindDirectionDown,$GUI_CHECKED)
			
		EndIf
		GUISetState(@SW_SHOW,$fFind1)
		Return -1
	EndIf
	
	$findTarget = $findWhat
	$lenFind = StringLen($findTarget)
	if ($lenFind == 0) Then
		return -1
	EndIf
	
	$startPosition = SendMessage($sci,$SCI_GETTARGETEND,0,0)
	$endPosition = SendMessage($sci,$SCI_GETLENGTH,0,0)
	if ($reverseDirection) Then
		$startPosition = SendMessage($sci,$SCI_GETTARGETSTART,0,0)
		$endPosition = 0
	EndIf
	ConsoleWrite("$startPosition="&$startPosition&@CR)
	ConsoleWrite("$endPosition="&$endPosition&@CR)
	
	;$flags = ($wholeWord ? SCFIND_WHOLEWORD : 0) |
	;            (matchCase ? SCFIND_MATCHCASE : 0) |
	;            (regExp ? SCFIND_REGEXP : 0) |
	;            (props.GetInt("find.replace.regexp.posix") ? SCFIND_POSIX : 0);

	SendMessage($sci,$SCI_SETSEARCHFLAGS, $flags,0);
	$posFind = FindInTarget($findTarget, $lenFind, $startPosition, $endPosition)

	if ($posFind == -1) And ($wrapFind) Then
		if ($reverseDirection) Then
			$startPosition = SendMessage($sci,$SCI_GETLENGTH,0,0)
			$endPosition = 0;
		Else
			$startPosition = 0;
			$endPosition = SendMessage($sci,$SCI_GETLENGTH,0,0)
		EndIf
		$posFind = FindInTarget($findTarget, $lenFind, $startPosition, $endPosition);
		If ($showWarnings) Then
			WarnUser("Reached the end of text. Wrapping around...");
		EndIf
	EndIf
	if ($posFind == -1) Then
		$havefound = false;
		if ($showWarnings) Then
			WarnUser("Can't find the string '"&$findWhat&"'!");
		EndIf
	Else
		$havefound = true;
		$start = SendMessage($sci,$SCI_GETTARGETSTART,0,0);
		$end = SendMessage($sci,$SCI_GETTARGETEND,0,0);
		EnsureRangeVisible($start, $end);
		SetSelection($start, $end);
	EndIf
	return $posFind;	
EndFunc


Func ShowLineNumbers($yes)
	$show_line_numbers = $yes
	If $yes Then
		GUICtrlSetState($mViewLineNumbers,$GUI_UNCHECKED)
		SendMessage($sci,$SCI_SETMARGINWIDTHN, 0, 0)
	Else
		GUICtrlSetState($mViewLineNumbers,$GUI_CHECKED)
		$pixelWidth = SendMessageString($sci,$SCI_TEXTWIDTH, $STYLE_LINENUMBER, "99999")
		SendMessage($sci,$SCI_SETMARGINWIDTHN, 0, $pixelWidth);
	EndIf	
EndFunc

Func ShowWhitespaces($yes)
	$show_whitespaces = $yes
	If $yes Then
		GUICtrlSetState($mViewWhitespaces,$GUI_CHECKED)
		SendMessage($sci,$SCI_SETVIEWWS,1,0)
	Else
		GUICtrlSetState($mViewWhitespaces,$GUI_UNCHECKED)
		SendMessage($sci,$SCI_SETVIEWWS,0,0)
	EndIf		
EndFunc

Func ShowFolds($yes)
	$show_folds = $yes
	If $yes Then
		GUICtrlSetState($mViewFolds,$GUI_UNCHECKED)
		SendMessage($sci,$SCI_SETMARGINWIDTHN, $MARGIN_SCRIPT_FOLD_INDEX, 0)
		
	Else
		GUICtrlSetState($mViewFolds,$GUI_CHECKED)
		SendMessage($sci,$SCI_SETMARGINWIDTHN, $MARGIN_SCRIPT_FOLD_INDEX, 20);
	EndIf	
EndFunc

Func DetectHighlighter($filename)
	if not IsArray($highlighters) Then
		return
	EndIf
	Dim $szDrive, $szDir, $szFName, $szExt,$hl_file
	_PathSplit($filename, $szDrive, $szDir, $szFName, $szExt)
	$highlighters = _FileListToArray(@ScriptDir,"highlighter.*.txt",1)
	for $hi = 1 to $highlighters[0]
		$exts = IniRead(@ScriptDir&"\"&$highlighters[$hi],"","ext","")
		if StringInStr(StringLower($exts),StringLower($szExt))>0 Then
			$hl_file = @ScriptDir&"\"&$highlighters[$hi]
			ExitLoop
		EndIf
	Next
	if $hl_file <> "" then 
		LoadHiglight($hl_file)
	Else
		SetStyle($STYLE_DEFAULT,$default_style)
		SendMessageString($sci,$SCI_STYLECLEARALL,0,0)
		SendMessageString($sci,$SCI_SETLEXER,0,0)		
	EndIf
EndFunc

Func SelectHighlighter()
	for $i = 0 to UBound($highlighters_menu)-1
		if $highlighters_menu[$i] = @GUI_CTRLID Then
			ExitLoop
		EndIf
	Next
	LoadHiglight(@ScriptDir&"\"&$highlighters[$i+1])
	SendMessageString($sci, $SCI_CANCEL,0,0)
EndFunc

Func ListHighlighters()
	$highlighters = _FileListToArray(@ScriptDir,"highlighter.*.txt",1)
	if not IsArray($highlighters) Then
		return
	EndIf
	for $hi = 1 to $highlighters[0]
		$mi = GUICtrlCreateMenuitem ( IniRead(@ScriptDir&"\"&$highlighters[$hi],"","name",""), $mHighlighter,$hi)
		GUICtrlSetOnEvent(-1,"SelectHighlighter")
		$highlighters_menu[UBound($highlighters_menu)-1] = $mi
		ReDim $highlighters_menu[UBound($highlighters_menu)+1]
	Next
	
EndFunc

Func SetStyle($style,$styletxt)
	$astyle = StringSplit($styletxt,",")

	if UBound($astyle)<8 Then
		;MsgBox(16,"Warning","Incomplete style definition, skipping..."&@CRLF&$styletxt)
		Return
	EndIf
	
	SendMessage($sci,$SCI_STYLESETFORE,$style,$astyle[1])
	SendMessage($sci,$SCI_STYLESETBACK,$style,$astyle[2])
	if $astyle[3] >= 1 Then
		SendMessage($sci,$SCI_STYLESETSIZE,$style,$astyle[3])	
	EndIf
	if $astyle[4] <> '' Then
		SendMessageString($sci,$SCI_STYLESETFONT,$style,$astyle[4])	
	EndIf
	SendMessage($sci,$SCI_STYLESETBOLD,$style,$astyle[5])
	SendMessage($sci,$SCI_STYLESETITALIC,$style,$astyle[6])
	SendMessage($sci,$SCI_STYLESETUNDERLINE,$style,$astyle[7])
EndFunc

Func GetSelLength($sci)
	$startPosition = SendMessage($sci,$SCI_GETSELECTIONSTART,0,0)
	$endPosition = SendMessage($sci,$SCI_GETSELECTIONEND,0,0)
	$len = $endPosition-$startPosition	
	Return $len
EndFunc

CreateEditor()
FitEditor()
InitEditor()
NewFile()

While 1
	If (WinActive($Form1)) Then
		If _IsPressed("72",$user32) Then;F3
			FindNext($findWhat,False, $showWarnings,$flags,False)
		EndIf
		
		If _IsPressed("10",$user32) And _IsPressed("72") Then ;Shift+F3
			FindNext($findWhat,True, $showWarnings,$flags,False)
		EndIf
		
		If _IsPressed("10",$user32) And _IsPressed("53",$user32) Then;Shift+S
			SaveFile("")
		EndIf
		
		If _IsPressed("11",$user32) And _IsPressed("53",$user32) Then;Ctrl+S
			SaveFile()
		EndIf
		
		If _IsPressed("11",$user32) And _IsPressed("4F",$user32) Then;Ctrl+O
			OpenFile()
		EndIf
		
		If _IsPressed("11",$user32) And _IsPressed("4E",$user32) Then;Ctrl+O
			NewFile()
		EndIf
		
		If _IsPressed("11",$user32) And _IsPressed("47",$user32) Then;Ctrl+G
			GoToLine()
		EndIf
		
		If _IsPressed("11",$user32) And _IsPressed("46",$user32) Then;Ctrl+F
			$len = GetSelLength($sci)
			If $len>0 Then
				$text = DllStructCreate("char["&$len+1&"]")
				DllCall($user32, "int", "SendMessageA", "hwnd", $sci, "int", $SCI_GETSELTEXT, "int", 0, "ptr", DllStructGetPtr($text))
				$findWhat = DllStructGetData($text,1)
				$text = 0
			EndIf
			GUICtrlSetData($Combo1,$findWhat,$findWhat)
			FindNext($findWhat,False, $showWarnings,$flags,True)
		EndIf
	EndIf

	Sleep(100)
WEnd




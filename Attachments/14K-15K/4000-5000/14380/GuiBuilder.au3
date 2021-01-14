; Prototype for the next version of AutoBuilder
; CyberSlug - 26 Nov 2004

; TINY UPDATES 11 Jan 2004 for compatibility with AutoIt 3.0.103.152

;Known bugs:
;  Lots of things not implemented yet.... and frames (group controls) are incomplete
;  Snap-to grid doesn't quite work correctly if it was previously turned off...
;  Because icon controls don't resize, you can drag one off screen....
;  ComboBox height resizing does not work
;  Numbering of controls is not finalized

; Roy - 20 Jun 2005: added save & load gui defs to ini files with file ext .agd (AutoIt Gui Definition) 
;	see _SaveGuiDefinition & _LoadGuiDefinition (very beta code)
;	Commented Beep function
;   Note: Compile with 3.1.1.0
;	TO USE IT COMPILE IN THE SAME DIRECTORY OF GUIBUILDER (NEEDS PICS X ICON & PIC)

; TheSaint - 5 July 2005: Added the ability to re-load the (*.agd) settings/template file, from the
; command-line (you can now use - Open With or SendTo, or simply associate that file type with the
; Guibuilder program. I modified some of CyberSlug's code & some of Roy's. I also added the ability
; to store the last used folder location in a .ini file (Gbuild.ini), this entry is the default load
; or save location if the file/entry exists, otherwise it default's to My Documents.
; The default GUI's .au3 filename, is also taken from Roy's template (*.agd) file, if you created one.
; BUG FIX - 31 Aug 2005: Command-line variable updated to ignore value of 1 - discovered this, when
;   Guibuilder crashed on me, and I couldn't re-load the saved (*.agd) file, because $CmdLine[0] was
;   returning a value of 1!

; TheSaint - 17th December 2006: This file was originally Prototype 0.5, and at some point CyberSlug
; had changed it to 0.6 ... the main difference I could find, was that all the "handle=" & $main, etc
; had been changed to $main, etc (the '"handle=" & ' element being completely removed). I have now
; implemented that change in this file, plus re-worked several other elements. Most notably, the GUI
; gets it's name from the title in SciTe (if you're running it), it also gets the save path from
; that name. There was one other change I found in Prototype 0.6, that reflected newer GUI changes -
; If Not IsDeclared('WS_CLIPSIBLINGS') Then Global $WS_CLIPSIBLINGS = 0x04000000 had been removed,
; and $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS had been changed to the following -
; BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS), which I find to be in uncommon use, so I added
; my most commonly preferred version - $WS_OVERLAPPED + $WS_CAPTION + $WS_SYSMENU + $WS_VISIBLE +
; $WS_CLIPSIBLINGS + $WS_MINIMIZEBOX. Due to my changes I have called the program - Prototype 0.7.
; I have also added an 'About' dialog & 'Info' dialog menu items, and finally increased the height
; of the 'Choose Control Type' gui, which had been previously overlooked by both Roy and myself,
; which had meant that the bottom row of buttons was only partially displayed.
;
; One might wonder at my bothering to do all this, with the advent of KODA. Well I both like and
; dislike elements of KODA, and find the simplicity of AutoBuilder (with the later changes) much
; more pleasing at times. In particular, I dislike the naming and size ranges available in KODA,
; which means I'm forever renaming and changing them to what I want. In particular I like the
; buttons and inputs, etc to start off at 20 high, and have an underslash between control names
; and numbers i.e. $checkbox_1 not $checkbox1. I also prefer to have more screen to play with.

; ADDED by TheSaint
;SplashTextOn("", @LF & "Please Wait!", 200, 60, -1, -1, 1)
; END ADD

#region ------ INCLUDEs OPTs ------

; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Program Files\AutoIt3\Include\GuiConstants.au3>
; ----------------------------------------------------------------------------


; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.0
; Language:       English
; Description:    Constants to be used in GUI applications.
;
; ------------------------------------------------------------------------------


; Events and messages
Global Const $GUI_EVENT_CLOSE			= -3
Global Const $GUI_EVENT_MINIMIZE		= -4
Global Const $GUI_EVENT_RESTORE			= -5
Global Const $GUI_EVENT_MAXIMIZE		= -6
Global Const $GUI_EVENT_PRIMARYDOWN		= -7
Global Const $GUI_EVENT_PRIMARYUP		= -8
Global Const $GUI_EVENT_SECONDARYDOWN	= -9
Global Const $GUI_EVENT_SECONDARYUP		= -10
Global Const $GUI_EVENT_MOUSEMOVE		= -11


; State
Global Const $GUI_AVISTOP		= 0
Global Const $GUI_AVISTART		= 1
Global Const $GUI_AVICLOSE		= 2

Global Const $GUI_CHECKED		= 1
Global Const $GUI_INDETERMINATE	= 2
Global Const $GUI_UNCHECKED		= 4

Global Const $GUI_ACCEPTFILES	= 8

Global Const $GUI_SHOW			= 16
Global Const $GUI_HIDE 			= 32
Global Const $GUI_ENABLE		= 64
Global Const $GUI_DISABLE		= 128

Global Const $GUI_FOCUS			= 256
Global Const $GUI_DEFBUTTON		= 512

Global Const $GUI_EXPAND		= 1024


; Font
Global Const $GUI_FONTITALIC	= 2
Global Const $GUI_FONTUNDER		= 4
Global Const $GUI_FONTSTRIKE	= 8


; Resizing
Global Const $GUI_DOCKAUTO		= 1
Global Const $GUI_DOCKLEFT		= 2
Global Const $GUI_DOCKRIGHT		= 4
Global Const $GUI_DOCKHCENTER	= 8
Global Const $GUI_DOCKTOP		= 32
Global Const $GUI_DOCKBOTTOM	= 64
Global Const $GUI_DOCKVCENTER	= 128
Global Const $GUI_DOCKWIDTH		= 256
Global Const $GUI_DOCKHEIGHT	= 512

Global Const $GUI_DOCKSIZE		= 768	; width+height
Global Const $GUI_DOCKMENUBAR	= 544	; top+height
Global Const $GUI_DOCKSTATEBAR	= 576	; bottom+height
Global Const $GUI_DOCKALL		= 802	; left+top+width+height


; Window Styles
Global Const $WS_BORDER				= 0x00800000
Global Const $WS_POPUP				= 0x80000000
Global Const $WS_CAPTION			= 0x00C00000
Global Const $WS_DISABLED 			= 0x08000000
Global Const $WS_DLGFRAME 			= 0x00400000
Global Const $WS_HSCROLL			= 0x00100000
Global Const $WS_MAXIMIZE			= 0x01000000
Global Const $WS_MAXIMIZEBOX		= 0x00010000
Global Const $WS_MINIMIZE			= 0x20000000
Global Const $WS_MINIMIZEBOX		= 0x00020000
Global Const $WS_OVERLAPPED 		= 0
Global Const $WS_OVERLAPPEDWINDOW	= 0x00CF0000
Global Const $WS_POPUPWINDOW		= 0x80880000
Global Const $WS_SIZEBOX			= 0x00040000
Global Const $WS_SYSMENU			= 0x00080000
Global Const $WS_THICKFRAME			= 0x00040000
Global Const $WS_TILED				= 0
Global Const $WS_TILEDWINDOW		= 0x00CF0000
Global Const $WS_VSCROLL			= 0x00200000
Global Const $WS_VISIBLE			= 0x10000000
Global Const $WS_CHILD				= 0x40000000
Global Const $WS_GROUP				= 0x00020000
Global Const $WS_TABSTOP			= 0x00010000

Global Const $DS_MODALFRAME 		= 0x80


; Window Extended Styles
Global Const $WS_EX_ACCEPTFILES			= 0x00000010
Global Const $WS_EX_APPWINDOW			= 0x00040000
Global Const $WS_EX_CLIENTEDGE			= 0x00000200
Global Const $WS_EX_CONTEXTHELP			= 0x00000400
Global Const $WS_EX_DLGMODALFRAME 		= 0x00000001
Global Const $WS_EX_LEFTSCROLLBAR 		= 0x00004000
Global Const $WS_EX_OVERLAPPEDWINDOW	= 0x00000300
Global Const $WS_EX_RIGHT				= 0x00001000
Global Const $WS_EX_STATICEDGE			= 0x00020000
Global Const $WS_EX_TOOLWINDOW			= 0x00000080
Global Const $WS_EX_TOPMOST				= 0x00000008
Global Const $WS_EX_TRANSPARENT			= 0x00000020
Global Const $WS_EX_WINDOWEDGE			= 0x00000100
Global Const $WS_EX_LAYERED				= 0x00080000
Global Const $LBS_EX_FULLROWSELECT		= 0x00000020


; Label
Global Const $SS_NOTIFY			= 0x0100
Global Const $SS_BLACKFRAME		= 7
Global Const $SS_BLACKRECT		= 4
Global Const $SS_CENTER			= 1
Global Const $SS_ETCHEDFRAME	= 18
Global Const $SS_ETCHEDHORZ		= 16
Global Const $SS_ETCHEDVERT		= 17
Global Const $SS_GRAYFRAME		= 8
Global Const $SS_GRAYRECT		= 5
Global Const $SS_LEFTNOWORDWRAP	= 12
Global Const $SS_NOPREFIX		= 0x0080
Global Const $SS_RIGHT			= 2
Global Const $SS_RIGHTJUST		= 0x0400
Global Const $SS_SIMPLE			= 11
Global Const $SS_SUNKEN			= 0x1000
Global Const $SS_WHITEFRAME		= 9
Global Const $SS_WHITERECT		= 6


; Button
Global Const $BS_BOTTOM			= 0x0800
Global Const $BS_CENTER			= 0x0300
Global Const $BS_DEFPUSHBUTTON	= 0x0001
Global Const $BS_LEFT			= 0x0100
Global Const $BS_MULTILINE		= 0x2000
Global Const $BS_PUSHBOX		= 0x000A
Global Const $BS_PUSHLIKE		= 0x1000
Global Const $BS_RIGHT			= 0x0200
Global Const $BS_RIGHTBUTTON	= 0x0020
Global Const $BS_TOP			= 0x0400
Global Const $BS_VCENTER		= 0x0C00
Global Const $BS_FLAT			= 0x8000
Global Const $BS_ICON			= 0x0040
Global Const $BS_BITMAP			= 0x0080


; Combo
Global Const $CBS_AUTOHSCROLL		= 64
Global Const $CBS_DISABLENOSCROLL	= 2048
Global Const $CBS_DROPDOWN			= 2
Global Const $CBS_DROPDOWNLIST		= 3
Global Const $CBS_LOWERCASE			= 16384
Global Const $CBS_NOINTEGRALHEIGHT	= 1024
Global Const $CBS_OEMCONVERT		= 128
Global Const $CBS_SIMPLE			= 1
Global Const $CBS_SORT				= 256
Global Const $CBS_UPPERCASE			= 8192


; Listbox
Global Const $LBS_DISABLENOSCROLL	= 4096
Global Const $LBS_NOINTEGRALHEIGHT	= 256
Global Const $LBS_NOSEL				= 16384
Global Const $LBS_SORT				= 2
Global Const $LBS_STANDARD			= 10485763
Global Const $LBS_USETABSTOPS		= 128


; Edit/Input
Global Const $ES_MULTILINE			= 4
Global Const $ES_AUTOHSCROLL		= 128
;Global Const $ES_DISABLENOSCROLL = 8192
Global Const $ES_AUTOVSCROLL		= 64
Global Const $ES_CENTER				= 1
;Global Const $ES_SUNKEN = 16384
Global Const $ES_LOWERCASE			= 16
Global Const $ES_NOHIDESEL			= 256
Global Const $ES_NUMBER				= 8192
Global Const $ES_OEMCONVERT			= 1024
;Global Const $ES_VERTICAL = 4194304
;Global Const $ES_SELECTIONBAR = 16777216
Global Const $ES_PASSWORD			= 32
Global Const $ES_READONLY			= 2048
Global Const $ES_RIGHT				= 2
Global Const $ES_UPPERCASE			= 8
Global Const $ES_WANTRETURN			= 4096


; Date
Global Const $DTS_UPDOWN			= 1
Global Const $DTS_SHOWNONE			= 2
Global Const $DTS_LONGDATEFORMAT	= 4
Global Const $DTS_TIMEFORMAT		= 9
Global Const $DTS_RIGHTALIGN		= 32


; Progress bar
Global Const $PBS_SMOOTH	= 1
Global Const $PBS_VERTICAL	= 4


; AVI clip
Global Const $ACS_CENTER			= 1
Global Const $ACS_AUTOPLAY			= 4
Global Const $ACS_TIMER				= 8
Global Const $ACS_NONTRANSPARENT	= 16


; Tab
Global Const $TCS_SCROLLOPPOSITE	= 0x0001
Global Const $TCS_BOTTOM			= 0x0002
Global Const $TCS_RIGHT				= 0x0002
Global Const $TCS_MULTISELECT		= 0x0004
Global Const $TCS_FLATBUTTONS		= 0x0008
Global Const $TCS_FORCEICONLEFT		= 0x0010
Global Const $TCS_FORCELABELLEFT	= 0x0020
Global Const $TCS_HOTTRACK			= 0x0040
Global Const $TCS_VERTICAL			= 0x0080
Global Const $TCS_TABS				= 0x0000
Global Const $TCS_BUTTONS			= 0x0100
Global Const $TCS_SINGLELINE		= 0x0000
Global Const $TCS_MULTILINE			= 0x0200
Global Const $TCS_RIGHTJUSTIFY		= 0x0000
Global Const $TCS_FIXEDWIDTH		= 0x0400
Global Const $TCS_RAGGEDRIGHT		= 0x0800
Global Const $TCS_FOCUSONBUTTONDOWN = 0x1000
Global Const $TCS_OWNERDRAWFIXED	= 0x2000
Global Const $TCS_TOOLTIPS			= 0x4000
Global Const $TCS_FOCUSNEVER		= 0x8000


; TreeView
Global Const $TVS_HASBUTTONS     	= 0x0001
Global Const $TVS_HASLINES       	= 0x0002
Global Const $TVS_LINESATROOT    	= 0x0004
;Global Const $TVS_EDITLABELS      = 0x0008
Global Const $TVS_DISABLEDRAGDROP	= 0x0010
Global Const $TVS_SHOWSELALWAYS		= 0x0020
;Global Const $TVS_RTLREADING     = 0x0040
Global Const $TVS_NOTOOLTIPS		= 0x0080
Global Const $TVS_CHECKBOXES		= 0x0100
Global Const $TVS_TRACKSELECT		= 0x0200
Global Const $TVS_SINGLEEXPAND		= 0x0400
;Global Const $TVS_INFOTIP        = 0x0800
Global Const $TVS_FULLROWSELECT		= 0x1000
Global Const $TVS_NOSCROLL			= 0x2000
Global Const $TVS_NONEVENHEIGHT		= 0x4000

; Slider
Global Const $TBS_AUTOTICKS	= 0x0001
Global Const $TBS_VERT		= 0x0002
Global Const $TBS_HORZ		= 0x0000
Global Const $TBS_TOP		= 0x0004
Global Const $TBS_BOTTOM	= 0x0000
Global Const $TBS_LEFT		= 0x0004
Global Const $TBS_RIGHT		= 0x0000
Global Const $TBS_BOTH		= 0x0008
Global Const $TBS_NOTICKS	= 0x0010
Global Const $TBS_NOTHUMB	= 0x0080

; ListView
Global Const $LVS_REPORT 			= 0x0001
Global Const $LVS_EDITLABELS		= 0x0200
Global Const $LVS_NOCOLUMNHEADER	= 0x4000
Global Const $LVS_NOSORTHEADER		= 0x8000
Global Const $LVS_SINGLESEL			= 0x0004
Global Const $LVS_SHOWSELALWAYS		= 0x0008

;Updown
Global Const $UDS_WRAP			= 0x0001
Global Const $UDS_ALIGNRIGHT	= 0x0004
Global Const $UDS_ALIGNLEFT		= 0x0008
Global Const $UDS_ARROWKEYS		= 0x0020
Global Const $UDS_HORZ			= 0x0040
Global Const $UDS_NOTHOUSANDS	= 0x0080

$cmdln = $CmdLine[0]
;MsgBox(0, "$cmdln", $cmdln)

; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Program Files\AutoIt3\Include\GuiConstants.au3>
; ----------------------------------------------------------------------------


Global $mode_SnapGrid = 1, $mode_pastePos = 1, $mode_ShowGrid
Global $px = -99, $py = -99  ;"previous" x and y coords for the selection rectangle

Opt("WinTitleMatchMode", 4) ;advanced
Opt("WinWaitDelay", 10)     ;speeds up WinMove
Opt("GuiResizeMode", 802)   ;controls will never move when window is resized
;;;;Dim $WS_CAPTION = 0x00C00000, $BS_PUSHLIKE = 0x1000, $GUI_CHECKED = 1, $GUI_UNCHECKED = 4

;;;$nullParent = GuiCreate("nullParent") ;used to hide toolbar's taskbar button
#endregion ------ includes opts ------
;end of Includes and Opts

#region ------ HOTKEYS ------
Func EnableHotKeys()
   HotKeySet("{Delete}", "DeleteControl")
   HotKeySet("^c", "CopyControl")
   HotKeySet("^v", "PasteControl")
   HotKeySet("{Esc}", "Null") ;trap Esc just because I don't want Esc closing the whole GUI
EndFunc

Func DisableHotKeys()
   HotKeySet("{Delete}")
   HotKeySet("^c")
   HotKeySet("^v")
   HotKeySet("{Esc}")
EndFunc

Func Null()
EndFunc

Func DeleteControl()
   If $grippyCtrl > 0 And $MODE <> $DRAWING And $MODE <> $RESIZING And $MODE <> $MOVING Then
      Tooltip("Control Deleted")
      GuiCtrlDelete($grippyCtrl)
      $MCL[$grippyCtrl][0] = 0  ;remove from MasterControlList
      $numCtrls = $numCtrls - 1
      $grippyCtrl = 0
      For $i = 1 to 8
         GuiCtrlSetPos($grippy[$i], -99, -99, $grippySize, $grippySize) ;"hide" grippies
         GuiCtrlSetPos($overlay, -99, -99, 1, 1) ;"hide" overlay since we don't need it
      Next
      sleep(300) ;allow tooltip time to display
      Tooltip('')
   EndIf
EndFunc

Func CopyControl()
   If $grippyCtrl <= 0 Then Return
   Local $size = ControlGetPos($main, "", $grippyCtrl)
   ; AutoBuilderData CtrlType Width Height
   ClipPut("AutoBuilderData " & $MCL[$grippyCtrl][0] & " " & $size[2] & " " & $size[3])
EndFunc

Func PasteControl()
   Local $x = ClipGet()
   If StringLeft($x, 15) <> 'AutoBuilderData' Then Return
   Local $x = StringSplit($x, " ")
   $copiedWidth = $x[3]
   $copiedHeight = $x[4]
   $grippyCtrl = _CreateCtrl($x[2])
   showGrippies($grippyCtrl)
EndFunc
#endregion ------ hotkeys ------
;end of Hotkeys and functions

#region ------ GUI ------
; GUI for "Main Drawing form"
$main = GuiCreate("AutoBuilder - Form", 1, 40, -99999, -99999, 0x94CE0000)
; The window style is BitOr($WS_POPUP, $WS_CAPTION, $WS_SYSMENU, $WS_MINIMIZEBOX, $WS_THICKFRAME)

Dim $overlayTarget  ;guiID# of control under the overlay

; ADDED by TheSaint
Dim $AgdInfile, $cmdchk, $done, $gdtitle, $gdvar, $lfld, $mygui
; END ADD

$overlay = GuiCtrlCreateLabel("foo", -99, -99, 1, 1, 0x107)  ;transparent label with black border
$rect = GUICtrlCreateLabel("foo", -1, -1, 1, 1,0x107);transparent label with black border

$grippySize = 6 ;pixel size
Dim $grippy[9] ;I'll use indices 1 - 8
For $i = 1 to 8
	$grippy[$i] = GuiCtrlCreateLabel("", -99,-99, $grippySize, $grippySize, 0x104) ;black square
Next

Global $NorthWest_Grippy =  $grippy[1]
Global $North_Grippy     =  $grippy[2]
Global $NorthEast_Grippy =  $grippy[3]
Global $West_Grippy      =  $grippy[4]
Global $East_Grippy      =  $grippy[5]
Global $SouthWest_Grippy =  $grippy[6]
Global $South_Grippy     =  $grippy[7]
Global $SouthEast_Grippy =  $grippy[8]



$WS_CLIPSIBLINGS = 0x04000000
$BACKG_STYLE = 0x5000000E
$tab_style = 0x50010200
$background = GUICtrlCreatePic(@ScriptDir & "\background.bmp", 0, 0, 1024,768);, $BACKG_STYLE) ;used to show a grid
GUICtrlSetState($background, 128) ;disable background so that user can click buttons


GuiSetState(@SW_SHOW) ;window would lose resizability if I called WinMove before GuiSetState?!
WinMove($main,"", 290, @DesktopHeight/2-175, 400,350)  ;display size of window

Global $MODE = 2   ; 0 = waiting to draw, 1 = drawing,    2 = waiting to move, 3 = moving,   4 = waiting to resize, 5 = resize

Global $INITDRAW = 0, $DRAWING = 1, $INITMOVE = 2, $MOVING = 3, $INITRESIZE = 4, $RESIZING = 5
; symbolic constants; names are important and values are arbitrary

Global $currentCtrl, $currentType, $p, $lock, $prevX, $prevY, $cursorInfo, $hover, $numCtrls, $grippyCtrl
Global $copiedWidth = 0, $copiedHeight = 0
Global $firstControl = 1+$background

; just store CtrlType CtrlName for now; this will change.... first index corresponds to a GuiRefNumber
Global $MCL[4097][2]

; GUI for "Control Creation toolbar" (child window)
Global $lock = 0 ;allow only one instance of a function execution
Global $N = 21
Global $type[$N+1]
$toolbar = GuiCreate("Choose Control Type", 150, 410, 10, @DesktopHeight/2-175, 0x00C00000, -1, $main)
$tip = StringSplit("Cursor|Tab|Group|Button|Checkbox|Radio|Edit|Input|Label|UpDown|List|Combo|Date|Treeview|Progress|Avi|Icon|Pic|Menu|ContextMenu|Slider", "|")
$notYetImplemented = ",2,10,16,19,20,"  ;cursor is index 1
For $row = 0 to 6
   For $col = 0 to 2
      $i = 3*$row + $col + 1  ;convert row,col to linear index
      $type[$i] = GUICtrlCreateRadio("foo", $col*50, $row*50, 50, 50, 0x1040)
      GUICtrlSetTip(-1, $tip[$i])
      GUICtrlSetImage(-1, @ScriptDir & "\iconSet.icl", $i)
      If StringInStr($notYetImplemented, "," &  $i & ",") Then GuiCtrlSetState($type[$i], $GUI_DISABLE)
   Next
Next
GuiCtrlSetState($type[1], $GUI_CHECKED) ;initial selection
$menu1 = GUICtrlCreateMenu("Settings")
$showGrid = GUICtrlCreateMenuItem("Show grid", $menu1)
   GUICtrlSetState($showGrid,$GUI_CHECKED)
$gridSnap = GUICtrlCreateMenuItem("Snap to grid", $menu1)
   GUICtrlSetState($gridSnap,$GUI_CHECKED)
$pastePos = GUICtrlCreateMenuItem("Paste at mouse position", $menu1)
   GUICtrlSetState($pastePos,$GUI_CHECKED)
$showHidden = GUICtrlCreateMenuItem("Show hidden controls", $menu1)
   GUICtrlSetState($showHidden,$GUI_CHECKED)
$properties = GUICtrlCreateMenuitem("Properties", -1)
$menu2 = GUICtrlCreateMenuitem("Exit", -1)
#region - TheSaint add-on
$menu3 = GUICtrlCreateMenuitem("About", -1)
#endregion - TheSaint add-on
#region - Roy add-on
$menu4 = GUICtrlCreateMenuitem("SaveDefinition", -1)
$menu5 = GUICtrlCreateMenuitem("LoadDefinition", -1)
#endregion - Roy add-on
#region - TheSaint add-on
$menu6 = GUICtrlCreateMenuitem("Info", -1)
#endregion - TheSaint add-on
Global $AgdOutFile = ""
#endregion ------ gui ------


;end of GUI declaration stuff...

#region ------ MESSAGE LOOP ------
GuiSetState(@SW_SHOW)
GUISwitch($main) ;Rather important!
WinActivate($main)

; Main message loop....
While 1
	; show dimensions of window on the titlebar...
	$winSize = WinGetClientsize($main)
	If "AutoBuilder - Form (" & $winSize[0] & " x " & $winSize[1] & ")" <> WinGetTitle($main) Then
		WinSetTitle($main, "", "AutoBuilder - Form (" & $winSize[0] & " x " & $winSize[1] & ")")
	EndIf
	;
	If WinActive($main) Then
		EnableHotKeys()
	Else
		DisableHotKeys()
	EndIf

	$msg = GuiGetMsg(1)
	Select
	Case $msg[0] = $menu2 OR $msg[0] = $GUI_EVENT_CLOSE ;-3
		;$ans = MsgBox(4096+3, "Quit?", "Are you sure you want to quit?")
		; MODIFIED by TheSaint
		$ans = MsgBox(4096+3, "Quit?", "Do you want to Save a GUI?")
		If $ans = 6 Then ExitLoop
		If $ans = 7 Then Exit
		;ExitLoop
	Case $msg[0] = $menu3
		MsgBox(64, "About AutoBuilder", "Prototype 0.7 - created by CyberSlug," & @LF & _
			"and modified by Roy and TheSaint!")
	Case $msg[0] = $menu4
		_SaveGuiDefinition()
	Case $msg[0] = $menu5
		_LoadGuiDefinition()
	Case $msg[0] = $properties
		If $grippyCtrl = 0 Then
			Msgbox(4096, "Error", "Please select a control first!")
		Else
			$ans = InputBox("Properties", "Change text of selected " & $MCL[$grippyCtrl][0] & " control?", $MCL[$grippyCtrl][1])
			If Not @error Then
				GUICtrlSetData($grippyCtrl, $ans, $ans)
				$MCL[$grippyCtrl][1] = $ans
			EndIf
		EndIf
	Case $msg[0] = $menu6
		MsgBox(64, "Program Information", "When you exit AutoBuilder, you will be prompted" & @LF & _
			"to save what you may have created. If you select" & @LF & _
			"'Yes' then up to three options become available -" & @LF & _
			"1) Pasted into Scite if it's open, or use a dialog to" & @LF & _
			"2) Save to a script (.au3) file, or if that's cancelled" & @LF & _
			"3) Copied to the clipboard automatically!" & @LF & @LF & _
			"Current title = " & $mygui)
	Case $msg[0] = $showGrid
		If BitAnd(GuiCtrlRead($showGrid),$GUI_CHECKED) = $GUI_CHECKED Then
			GUICtrlSetState($showGrid,$GUI_UNCHECKED)
			GUICtrlSetImage($background, @ScriptDir & "\blank.bmp")
		Else
			GUICtrlSetState($showGrid,$GUI_CHECKED)
			GUICtrlSetImage($background, @ScriptDir & "\background.bmp")
		EndIf
		$mode_ShowGrid = NOT $mode_ShowGrid
      	WinActivate($main)
		_repaintWindow()
	Case $msg[0] = $gridSnap
		If BitAnd(GuiCtrlRead($gridSnap),$GUI_CHECKED) = $GUI_CHECKED Then
			GUICtrlSetState($gridSnap,$GUI_UNCHECKED)
		Else
			GUICtrlSetState($gridSnap,$GUI_CHECKED)
		EndIf
		$mode_SnapGrid = NOT $mode_SnapGrid
		WinActivate($main)
	Case $msg[0] = $pastePos
		If BitAnd(GuiCtrlRead($pastePos),$GUI_CHECKED) = $GUI_CHECKED Then
			GUICtrlSetState($pastePos,$GUI_UNCHECKED)
		Else
			GUICtrlSetState($pastePos,$GUI_CHECKED)
		EndIf
		$mode_PastePos = NOT $mode_PastePos
		WinActivate($main)
	;Case $msg[0] = $GUI_EVENT_MINIMIZE ;-4
		;   WinSetState($toolbar, "", @SW_MINIMIZE)
	;Case $msg[0] = $GUI_EVENT_RESTORE ;-5
		;   WinSetState($toolbar, "", @SW_RESTORE)
		;   WinActivate($main)
	Case $msg[0] = $type[1] ;cursor on the toolbar gui
		$mode = $INITMOVE
		WinActivate($main)
	Case $msg[0] >= $type[2] And $msg[0] <= $type[$N]
		_clickType($msg[0])
	Case $msg[0] = $background
		If $Mode = $INITDRAW Then
			$p = GuiGetCursorInfo($main)  ;$p[0] = x coord and $p[1] = y coord
			$currentCtrl = _CreateCtrl('')
			$grippyCtrl = $currentCtrl
			$Mode = $DRAWING ;drawing
		;ElseIf $Mode = 1 Then
		;   $Mode = 2 ;ready to move
		;   GUICtrlSetState($background, 128) ;disable background so that user can click buttons
		;   $currentType = ""
		;   ToolTip('')
		;   ;When done drawing, select the "cursor" on the toolbar again
		;   ;;;GuiCtrlSetState($type[1], 1) ;$GUI_CHECK
		;   ControlClick("Choose Control Type","",$type[1])
		EndIf
	Case $msg[0] = $overlay
		; drag and drop any control; when done moving, the control will show grippies around it
		;If $hover <> $grippyCtrl Then
         $grippyCtrl = $hover
		;Else
         $mode = $MOVING
         $currentCtrl = $hover ;control under the overlay
         $c = ControlGetPos($main,"",$currentCtrl)
         $p = _MouseSnapPos()
         $xOffset = $p[0] - $c[0]
         $yOffset = $p[1] - $c[1]
         ToolTip($xOffset & "," & $yOffset)
         GuiCtrlSetPos($overlay, -99, -99, 1, 1) ;"hide" overlay since we don't need it
		;EndIf
	Case $msg[0] >= $grippy[1] And $msg[0] <= $grippy[8]
		handleGrippy($msg[0], $grippyCtrl)
		;MsgBox(4096, "Sorry", "Resize not implemented yet...")
	EndSelect
	;
	; ADDED by TheSaint
	If $done = "" Then
		$done = 1
		CheckCommandline()
		GetScriptTitle()
	EndIf
	; END ADD
	;
	$cursorInfo = GuiGetCursorInfo()
	;  10 = SIZENESW
	;  11 = SIZENS
	;  12 = SIZENWSE
	;  13 = SIZEWE
	#cs
		If $cursorInfo[2] And MouseGetCursor() = 3 And $mode <> $DRAWING Then
			If $px = -99 or $py = -99 Then
				$px = $cursorInfo[0]
				$py = $cursorInfo[1]
			EndIf
			GuiCtrlSetPos($rect, $px, $py, 1, 1)
		Else
			If $px <> -99 And $py <> -99 Then GuiCtrlSetPos($rect, $px, $py, $cursorInfo[0], $cursorInfo[1])
		EndIf
	#ce
	Select
	Case $cursorInfo[4] = $grippy[1] ;North-East
		GuiSetCursor(12, 1)
	Case $cursorInfo[4] = $grippy[2] ;North
		GuiSetCursor(11, 1)
	Case $cursorInfo[4] = $grippy[3] ;North-West
		GuiSetCursor(10, 1)
	Case $cursorInfo[4] = $grippy[4] ;West
		GuiSetCursor(13, 1)
	Case $cursorInfo[4] = $grippy[5] ;East
		GuiSetCursor(13, 1)
	Case $cursorInfo[4] = $grippy[6] ;South-East
		GuiSetCursor(10, 1)
	Case $cursorInfo[4] = $grippy[7] ;South
		GuiSetCursor(11, 1)
	Case $cursorInfo[4] = $grippy[8] ;South-West
		GuiSetCursor(12, 1)
	EndSelect
	;
	;If cursor is out of bounds, then continue loop
	$wgcs = WinGetClientSize($main)
	If $cursorInfo[0] <= 0 Or $cursorInfo[1] <= 0 Or $cursorInfo[0] >= $wgcs[0] Or $cursorInfo[1] >= $wgcs[1] Then
		;;;;;;If $cursorInfo[2] = 1 Then ContinueLoop  ;if mouse button down
		;If $mode = 3 Then ;drawing
		;   ; HELP KEEP OVERLAY AND CONTROL IN SYNC WHEN USER MOVES MOUSE QUICKLY
		;   $c = ControlGetPos($main,"",$currentCtrl)
		;   GuiCtrlSetPos($overlay, $p[0]-$xOffset, $p[1]-$yOffset, $c[2], $c[3])
		;EndIf
		ContinueLoop
	EndIf
	;WinSetTitle($main, "", $cursorInfo[0] & ", "& $cursorInfo[1] & "  :  " & $wgcs[0] & " x " & $wgcs[1])
	; When cursor hovers over a control, change cursor to the sizeall cursor
	;  I could use GUICtrlSetCursor instead, but that might hurt performance a bit
	If $cursorInfo[4] = 0  or $cursorInfo[4] = $background or ($cursorInfo[4] >= $grippy[1] And $cursorInfo[4] <= $grippy[8]) Then
		$hover = 0
		If ($cursorInfo[4] < $grippy[1] Or $cursorInfo[4] > $grippy[8]) Then GUISetCursor(3, 1) ;3=crosshair cursor
		GuiCtrlSetPos($overlay, -99, -99, 1, 1)
	Else
		If $cursorInfo[4] <> $overlay Then
			$hover = $cursorInfo[4]
		EndIf
		;;GUISetCursor(9, 1) ;9=sizeall
		$cp = ControlGetPos("","",$cursorInfo[4])
		If $mode = $INITMOVE Then
			GuiCtrlSetPos($overlay, $cp[0], $cp[1], $cp[2], $cp[3])
			If ($cursorInfo[4] < $grippy[1] Or $cursorInfo[4] > $grippy[8]) Then GUISetCursor(2, 1) ;2=regular arrow cursor
			;;;showGrippies($overlay)
		EndIf
	EndIf
	;
	If $Mode = $DRAWING Then ;drawing
		$c = GuiGetCursorInfo($main)  ;$p[0] = x  and $p[1] = y
		$c = _MouseSnapPos()
		ToolTip("(" & $c[0] - $p[0] & ", " & $c[1] - $p[1] & ")") ;tooltip showing (x, y)
		GUICtrlSetPos($currentCtrl, $p[0], $p[1], $c[0] - $p[0], $c[1] - $p[1])
		If $cursorInfo[2] = 0 Then
			$Mode = $INITMOVE ;end move mode and go back to ready-to-move mode
			GUICtrlSetState($background, 128) ;disable background so that user can click buttons
			$currentType = ""
			ToolTip('')
			;When done drawing, select the "cursor" on the toolbar again
			;;;GuiCtrlSetState($type[1], 1) ;$GUI_CHECK
			ControlClick("Choose Control Type","",$type[1])
			WinActivate($main)
		EndIf
	EndIf
	;
	If $Mode = $MOVING Then ;moving
		GUISetCursor(9, 1) ;9=sizeall
		;;$p = GuiGetCursorInfo($main)  ;$p[0] = x  and $p[1] = y
		$p = _MouseSnapPos()
		ToolTip("(" & $p[0] & ", " & $p[1] & ")")
		GuiCtrlSetPos($currentCtrl, $p[0]-$xOffset, $p[1]-$yOffset, $c[2], $c[3])
		;;;GuiCtrlSetPos($overlay, $p[0]-$xOffset, $p[1]-$yOffset, $c[2], $c[3])
		For $i = 1 to 8
			GuiCtrlSetPos($grippy[$i], -99, -99, $grippySize, $grippySize) ;"hide" grippies
		Next
		If $cursorInfo[2] = 0 Then
			$Mode = $INITMOVE ;end move mode and go back to ready-to-move mode
			GUICtrlSetState($background, 128) ;disable background so that user can click buttons
			$currentType = ""
			ToolTip('')
		EndIf
	EndIf
	;
	If $grippyCtrl > 0 And $mode <> $MOVING And $mode <> $DRAWING Then showGrippies($grippyCtrl)
	;; if mouse down when showing "sizeall" cursor, stuff happens
	;If $cursorInfo[2] = 1 And MouseGetCursor() = 9 Then
	;   ToolTip("move")
	;Else
	;   ToolTip("")
	;EndIf
	; For drawing slider controls with a large thumb:
	If $mode = $DRAWING Then
		Local $h = ControlGetPos("","",$currentCtrl)
		Local $size =  $h[3] - 20
		If $h[2] - 20 < $size Then $size = $h[2] - 20
		GuiCtrlSendMsg($currentCtrl, 27+0x0400, $size, 0) ;TBS_SETTHUMBLENGTH
	EndIf
	;
	; ADDED by TheSaint
	;CheckCommandline()
	; END ADD
WEnd
#endregion ------ message loop ------

;end of main message loop

#region ------ CODE GENERATION ------
$t = ""
For $i = $firstControl To $firstControl+$numCtrls-1
   If $MCL[$i][0] Then
      $p = ControlGetPos($main, "", $i)
      ; The general template is GUICtrlCreateXXX( "text", left, top [,width [,height [,style [,exStyle]]] )
      ; but some controls do not use this.... Avi, Icon, Menu, Menuitem, Progress, Tabitem, Treeviewitem, updown
      $t = $t & "$" & $MCL[$i][0] & "_" & ($i - 13) & " = "  ;thirteen is a MAGIC NUMBER :)
      If $MCL[$i][0] = "Progress" or $MCL[$i][0] = "Slider" or $MCL[$i][0] = "TreeView" Then ;no text field
         $t = $t & "GuiCtrlCreate" & $MCL[$i][0] & '(' & $p[0] & ", " & $p[1] & ", " & $p[2] & ", " & $p[3] & ")" & @CRLF
      ElseIf $MCL[$i][0] = "Icon" Then ;extra iconid [set to zero]
         $t = $t & "GuiCtrlCreate" & $MCL[$i][0] & '("' & $MCL[$i][1] & '", 0, ' & $p[0] & ", " & $p[1] & ", " & $p[2] & ", " & $p[3] & ")" & @CRLF
      Else
         $t = $t & "GuiCtrlCreate" & $MCL[$i][0] & '("' & $MCL[$i][1] & '", ' & $p[0] & ", " & $p[1] & ", " & $p[2] & ", " & $p[3] & ")" & @CRLF
      EndIf
   EndIf
Next
$code = "; Script generated by AutoBuilder 0.7 Prototype" & @CRLF & @CRLF & "#include <GuiConstants.au3>" & @CRLF & @CRLF
;$code = $code & "If Not IsDeclared('WS_CLIPSIBLINGS') Then Global $WS_CLIPSIBLINGS = 0x04000000" & @CRLF & @CRLF
$size = WinGetClientSize($main)
$w = $size[0]
$h = $size[1]
;$code = $code & 'GuiCreate("MyGUI", ' & $w & ", " & $h & ",(@DesktopWidth-" & $w & ")/2, (@DesktopHeight-" & $h & ")/2 , $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)"
;$code = $code & 'GuiCreate("MyGUI", ' & $w & ", " & $h & ",-1, -1 , BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))"
; MODIFIED by TheSaint
;$code = $code & 'GuiCreate("MyGUI", ' & $w & ", " & $h & ",-1, -1 , $WS_OVERLAPPED + $WS_CAPTION + $WS_SYSMENU + $WS_VISIBLE + $WS_CLIPSIBLINGS + $WS_MINIMIZEBOX)"
$code = $code & 'GuiCreate(' & $gdtitle & ', ' & $w & ", " & $h & ",-1, -1 , $WS_OVERLAPPED + $WS_CAPTION + $WS_SYSMENU + $WS_VISIBLE + $WS_CLIPSIBLINGS + $WS_MINIMIZEBOX)"
; END MOD
$code = $code & @CRLF & @CRLF & $t & @CRLF
$code = $code & "GuiSetState()" & @CRLF & "While 1" & @CRLF & @TAB & "$msg = GuiGetMsg()" & @CRLF & @TAB & "Select" & @CRLF & @TAB
$code = $code & "Case $msg = $GUI_EVENT_CLOSE" & @CRLF & @TAB & @TAB & "ExitLoop" & @CRLF & @TAB
$code = $code & "Case Else" & @CRLF & @TAB & @TAB & ";;;" & @CRLF & @TAB & "EndSelect" & @CRLF & "WEnd" & @CRLF & "Exit"

;;; Genereate VERY SIMPLE AutoIt-GUI code and copy it Scite, file or to the clipboard

GuiDelete()
;AutoItSetOption("WinTitleMatchMode", 2)
; MODIFIED by TheSaint
If StringInStr($CmdLineRaw, "/StdOut") Then
	ConsoleWrite("#region --- GuiBuilder code Start ---" & @LF)
	ConsoleWrite(StringReplace($code,@crlf,@lf))
	ConsoleWrite(@lf & "#endregion --- GuiBuilder generated code End ---" & @LF)
;ElseIf WinExists("SciTE", "") Then
;ElseIf ProcessExists("SciTe.exe") Then
	;MsgBox(0, "Found", "")
	;WinActivate("SciTE", "")
	;WinWaitActive("SciTE", "", 5)
	;WinSetOnTop("SciTE", "", 1)
	;AutoItSetOption("WinTitleMatchMode", 1)
	;ConsoleWrite("#region --- GuiBuilder code Start ---" & @LF)
	;ConsoleWrite(StringReplace($code, @crlf, @lf))
	;ConsoleWrite(@lf & "#endregion --- GuiBuilder generated code End ---" & @LF)
	;WinSetOnTop($Scriptname, "", 1)
Else
	If $mygui = "" Then $mygui = "MyGUI.au3"
	$destination = FileSaveDialog("Save GUI to file?", "", "AutoIt (*.au3)", 19, $mygui)
	If @error = 1 Or $destination = "" Then
		ClipPut($code)
		SplashTextOn("Done", @CRLF & "Script copied to clipboard!", 200, 100)
	Else
		FileDelete($destination)
		FileWrite($destination, $code)
		SplashTextOn("Done", @CRLF & "Saved to file!", 200, 100)
	EndIf
	Sleep(1000)
	SplashOff()
EndIf
; END of modification by TheSaint

#endregion ------ code generation ------
;end of code generation stuff
Exit

#region ------ FUNCTIONS ------
;Func _moveCtrls()
;   GuiCtrlSetPos($currentCtrl, $p[0]-$xOffset, $p[1]-$yOffset, $c[2], $c[3])
;   GuiCtrlSetPos($overlay, $p[0]-$xOffset, $p[1]-$yOffset, $c[2], $c[3])
;EndFunc

; In order to create a resizable window with no minimum size, height must be > than titlebar's
;Func _titlebarHeight()
;   $client = WinGetClientSize($nullParent)
;   $window = WinGetPos($nullParent)
;   Return 1 + $window[3] - $window[2] + $client[0] - $client[1] ;titlebar height + 1
;EndFunc


Func _clickType($ref)
   ;If $lock = 1 Then Return ;require function to completely finish before it can be run again
   $lock = 1
   WinActivate($main)
   GUICtrlSetState($background, 64) ;enable background so that it detects clicks
   ;;;GUICtrlSetState($ref, 1) ;check
   $CurrentType = $tip[$ref-4101]  ;the magic number!
   ;;;MsgBox(4096,"", $currentType)
   $Mode = $INITDRAW  ;ready to draw
   $lock = 0
EndFunc



; The many GuiCtrlCreate cases
Func _CreateCtrl($arg)
	Local $w = 1, $h = 1
	$p = _MouseSnapPos() ;global
	If $arg <> "" Then
		$currentType = $arg
		$w = $copiedWidth
		$h = $copiedHeight
		;control will be inserted at current mouse position UNLESS out-of-bounds mouse
		If $mode_PastePos = 0 Then
			$p[0] = 0
			$p[1] = 0
		Else
			Local $winSize = WinGetClientSize($main)
			If $p[0] < 0 Or $p[1] < 0 Or $p[0] > $winSize[0] Or $p[1] > $winSize[1] Then
				$p[0] = 0
				$p[1] = 0
			Endif
		EndIf
	EndIf
	$numCtrls = $numCtrls + 1
	Local $returnValue
	Select
	Case $currentType = "Button"
		$returnValue =  GuiCtrlCreateButton("Button" & $numCtrls, $p[0], $p[1], $w, $h)
	Case $currentType = "Group"
		$returnValue =  GuiCtrlCreateGroup("Group" & $numCtrls, $p[0], $p[1], $w, $h)
	Case $currentType = "Checkbox"
		$returnValue = GuiCtrlCreateCheckbox("Checkbox" & $numCtrls, $p[0], $p[1], $w, $h)
	Case $currentType = "Radio"
		$returnValue = GuiCtrlCreateRadio("Radio" & $numCtrls, $p[0], $p[1], $w, $h)
	Case $currentType = "Edit"
		$returnValue = GuiCtrlCreateEdit("Edit" & $numCtrls, $p[0], $p[1], $w, $h)
	Case $currentType = "Input"
		$returnValue = GuiCtrlCreateInput("Input" & $numCtrls, $p[0], $p[1], $w, $h)
	Case $currentType = "Label"
		$returnValue = GuiCtrlCreateLabel("Label" & $numCtrls, $p[0], $p[1], $w, $h)
	Case $currentType = "List"
		$returnValue = GuiCtrlCreateList("List" & $numCtrls, $p[0], $p[1], $w, $h)
	Case $currentType = "Combo"
		$returnValue = GuiCtrlCreateCombo("Combo" & $numCtrls, $p[0], $p[1], $w, $h)
	Case $currentType = "Date"
		$returnValue = GuiCtrlCreateDate("Date" & $numCtrls, $p[0], $p[1], $w, $h)
	Case $currentType = "Slider"
		$returnValue = _GuiCtrlCreateSlider($p[0], $p[1], $w, $h, 0)
	Case $currentType = "Tab"
		; hidden by background...
		;$returnValue = GuiCtrlCreateTab(10, 10, 100, 100, $tab_style) ;;($p[0], $p[1], $w, $h)
		$returnValue = _createAnotherTab(10,10, 100,100) ;; ($left, $top, $width, $height)
			_createAnotherTabItem($returnValue, "Tab NUm 1")
		;MsgBox(4096,"debug", 538)
		;GuiCtrlCreateTabItem("Tab1")
		;GuiCtrlCreateTabItem("Tab2")
		;GuiCtrlCreateTabItem('')
		GuiSwitch($main)
		GuiSetState()
		Global $background = GUICtrlCreatePic(@ScriptDir & "\background.bmp", 0, 0, 1024,768);, $BACKG_STYLE) ;used to show a grid
		;Return $tab
		;$returnValue = GuiCtrlCreateButton("Not implemented yet", $p[0], $p[1], $w, $h)
	Case $currentType = "TreeView"
		$tree = GUICtrlCreateTreeView($p[0], $p[1], $w, $h)
		GUICtrlCreateTreeViewItem("TreeView" & $numCtrls, $tree)
		$returnValue = $tree
		$numCtrls = $numCtrls + 1 ;treeviewitem is an additional control.......
	Case $currentType = "Updown"
		$input = GuiCtrlCreateInput("Updown", $p[0], $p[1], $w, $h)
		$returnValue = GuiCtrlCreateUpdown($input)
		;;$input
	Case $currentType = "Progress"
		Local $control = GuiCtrlCreateProgress($p[0], $p[1], $w, $h)
		GUICtrlSetData($control, 100)
		$returnValue = $control
	Case $currentType = "Pic"
		$returnValue = GuiCtrlCreatePic(@ScriptDir & "\sampleImage.bmp", $p[0], $p[1], $w, $h)
	Case $currentType = "Avi"
		$returnValue = GuiCtrlCreateAvi(@ScriptDir & "\sampleAvi.avi", 0, $p[0], $p[1], $w, $h)
	Case $currentType = "Icon"
		$returnValue = GuiCtrlCreateIcon(@ScriptDir & "\iconset.icl", 0, $p[0], $p[1], $w, $h)
	Case Else
		$returnValue = GuiCtrlCreateButton("Not implemented yet", $p[0], $p[1], $w, $h)
	EndSelect
	$MCL[$returnValue][0] = $currentType
	$MCL[$returnValue][1] = $currentType & $numCtrls
	Return $returnValue
EndFunc


;Func Beep() ;for debugging
;   Run(@comspec & " /c echo " & chr(7), "", @SW_HIDE)
;EndFunc


Func showGrippies($ref)
	;If $ref = 0 Then Return ;prevents grippy from apeparing at startup...
	;$refSelected = $ref  ;is this okay to do here?
	Local $GS = $grippySize
	Local $p = ControlGetPos($main, "", $ref)
	Local $L = $p[0]
	Local $T = $p[1]
	Local $W = $p[2]
	Local $H = $p[3]
	Local $i
	;For $stabilityOfRedraw = 1 to 3
		GuiCtrlSetPos($grippy[1], $L-$GS,        $T-$GS, $GS,$GS)  ;NW
		GuiCtrlSetPos($grippy[2], $L+($W-$GS)/2, $T-$GS, $GS,$GS)  ;N
		GuiCtrlSetPos($grippy[3], $L+($W), $T-$GS, $GS,$GS)        ;NE
		GuiCtrlSetPos($grippy[4], $L-$GS, $T+($H-$GS)/2, $GS,$GS)  ;W
		GuiCtrlSetPos($grippy[5], $L+$W,  $T+($H-$GS)/2, $GS,$GS)  ;E
		GuiCtrlSetPos($grippy[6], $L-$GS,        $T+$H, $GS,$GS)   ;SW
		GuiCtrlSetPos($grippy[7], $L+($W-$GS)/2, $T+$H, $GS,$GS)   ;S
		GuiCtrlSetPos($grippy[8], $L+($W), $T+$H, $GS,$GS)         ;SE
	;Next
	;This line causes problems with groups on tabs....
	;  but maybe I need it for other reasons
	;;;;;;;GUISetControlEx ($ref, $GUI_SHOW + $GUI_FOCUS) ;show
EndFunc



Func _mouseSnapPos()
	$gridTicks = 10
	Local $tmp = GUIGetCursorInfo($main)  ;;;_mouseClientPos()
	If $mode_SnapGrid Then
		$tmp[0] = $gridTicks * Int( $tmp[0] / $gridTicks - 0.5) + $gridTicks
		$tmp[1] = $gridTicks * Int( $tmp[1] / $gridTicks - 0.5) + $gridTicks
	EndIf
	Return $tmp
EndFunc



; Note:  There is a small bit of code after the big select case block!!
Func handleGrippy($grippyRef, $refSelected)
   ;position mouse over center of grippy
	$grippyPos = ControlGetPos($main,"", $grippyRef)
	_mouseClientMove( Int($grippyPos[0] + $GrippySize/2), Int($grippyPos[1] + $GrippySize/2) )
   Select
   Case $grippyRef = $South_Grippy
      While 1
         Local $i = GuiGetCursorInfo()
         If $i[2] = 0 Then ExitLoop ;exit when primary mouse button is up
         Local $cp = ControlGetPos($main, "", $refSelected)
         ToolTip($cp[2] & ' x' & $cp[3])  ;show width x height
         ;new height = mouseY - top (but also want height of at least 1 pixel)
         $mp = _mouseSnapPos()
         $cp[3] = $mp[1] - $cp[1]
         If $cp[3] < 1 Then $cp[3] = 1
         ;update position of control and grippies on screen
         GuiCtrlSetPos($refSelected, $cp[0], $cp[1], $cp[2], $cp[3])
         showGrippies($refSelected)
         ; Dynamically resize slider controls....
         Local $h = ControlGetPos("","",$currentCtrl)
         GuiCtrlSendMsg($currentCtrl, 27+0x0400, $h[3] - 20, 0) ;TBS_SETTHUMBLENGTH
      WEnd
   Case $grippyRef = $North_Grippy
      Local $bottom = $cp[1] + $cp[3]  ;bottom = top + height
      While 1
         Local $i = GuiGetCursorInfo()
         If $i[2] = 0 Then ExitLoop ;exit when primary mouse button is up
         Local $cp = ControlGetPos($main, "", $refSelected)
         ToolTip($cp[2] & ' x' & $cp[3])  ;show width x height
   		$mp = _mouseSnapPos()
         $cp[1] = $mp[1]           ;top = mouseY
         $cp[3] = $bottom - $mp[1] ;height = bottom - mouseY
         If $cp[3] < 1 Then        ; ensure top is always above bottom
            $cp[3] = 1
            $cp[1] = $bottom
         EndIf
         ;update position of control and grippies on screen
         GuiCtrlSetPos($refSelected, $cp[0], $cp[1], $cp[2], $cp[3])
         showGrippies($refSelected)
         Local $h = ControlGetPos("","",$currentCtrl)
         GuiCtrlSendMsg($currentCtrl, 27+0x0400, $h[3] - 20, 0) ;TBS_SETTHUMBLENGTH
      WEnd
   Case $grippyRef = $East_Grippy
      While 1
         Local $i = GuiGetCursorInfo()
         If $i[2] = 0 Then ExitLoop ;exit when primary mouse button is up
         Local $cp = ControlGetPos($main, "", $refSelected)
         ToolTip($cp[2] & ' x' & $cp[3])  ;show width x height
         ;new width = mouseX - left (but also want width of at least 1 pixel)
         ;  and force control to resize even if mouse moves quickly
         $mp = _mouseSnapPos()
         $cp[2] = $mp[0] - $cp[0]
         If $cp[2] < 1 Then $cp[2] = 1
         ;update position of control and grippies on screen
         GuiCtrlSetPos($refSelected, $cp[0], $cp[1], $cp[2], $cp[3])
         showGrippies($refSelected)
      WEnd
   Case $grippyRef = $West_Grippy
      Local $right = $cp[0] + $cp[2]  ;right = left + width
      While 1
         Local $i = GuiGetCursorInfo()
         If $i[2] = 0 Then ExitLoop ;exit when primary mouse button is up
         Local $cp = ControlGetPos($main, "", $refSelected)
         ToolTip($cp[2] & ' x' & $cp[3])  ;show width x height
         ;new width = mouseX - left (but also want width of at least 1 pixel)
         ;  and force control to resize even if mouse moves quickly
         $mp = _mouseSnapPos()
         $cp[2] = $mp[0] - $cp[0]
         If $cp[2] < 1 Then $cp[2] = 1
         $mp = _mouseSnapPos()
         $cp[0] = $mp[0]           ;left = mouseX
         $cp[2] = $right - $mp[0]  ;width = right - mouseX
         If $cp[2] < 1 Then        ; ensure right side is before left
            $cp[2] = 1
            $cp[0] = $right
         EndIf
         ;update position of control and grippies on screen
         GuiCtrlSetPos($refSelected, $cp[0], $cp[1], $cp[2], $cp[3])
         showGrippies($refSelected)
         Local $h = ControlGetPos("","",$currentCtrl)
         GuiCtrlSendMsg($currentCtrl, 27+0x0400, $h[3] - 20, 0) ;TBS_SETTHUMBLENGTH
      WEnd
   Case $grippyRef = $SouthEast_Grippy
      While 1
         Local $i = GuiGetCursorInfo()
         If $i[2] = 0 Then ExitLoop ;exit when primary mouse button is up
         Local $cp = ControlGetPos($main, "", $refSelected)
         ToolTip($cp[2] & ' x' & $cp[3])  ;show width x height
         Local $prevWidth = $cp[2]
         Local $prevHeight = $cp[3]
         ; Move control to new position
         $mp = _mouseSnapPos()
         $cp[2] = $mp[0] - $cp[0]  ;width = mouseX - left
         $cp[3] = $mp[1] - $cp[1]  ;height = mouseY - top
         If $cp[2] < 1 Then $cp[2] = 1
         If $cp[3] < 1 Then $cp[3] = 1
         ;update position of control and grippies on screen
         GuiCtrlSetPos($refSelected, $cp[0], $cp[1], $cp[2], $cp[3])
         showGrippies($refSelected)
         Local $h = ControlGetPos("","",$currentCtrl)
         GuiCtrlSendMsg($currentCtrl, 27+0x0400, $h[3] - 20, 0) ;TBS_SETTHUMBLENGTH
      WEnd
   Case $grippyRef = $SouthWest_Grippy
      Local $right = $cp[0] + $cp[2]  ;right = left + width
      While 1
         Local $i = GuiGetCursorInfo()
         If $i[2] = 0 Then ExitLoop ;exit when primary mouse button is up
         Local $cp = ControlGetPos($main, "", $refSelected)
         ToolTip($cp[2] & ' x' & $cp[3])  ;show width x height
         Local $prevWidth = $cp[2]
         Local $prevHeight = $cp[3]
         ;new height = mouseY - top (but also want height of at least 1 pixel)
         $mp = _mouseSnapPos()
         $cp[3] = $mp[1] - $cp[1]
         If $cp[3] < 1 Then $cp[3] = 1
         $cp[0] = $mp[0]           ;left = mouseX
         $cp[2] = $right - $mp[0]  ;width = right - mouseX
         If $cp[2] < 1 Then        ; ensure right side is before left
            $cp[2] = 1
            $cp[0] = $right
         EndIf
         ;update position of control and grippies on screen
         GuiCtrlSetPos($refSelected, $cp[0], $cp[1], $cp[2], $cp[3])
         showGrippies($refSelected)
         Local $h = ControlGetPos("","",$currentCtrl)
         GuiCtrlSendMsg($currentCtrl, 27+0x0400, $h[3] - 20, 0) ;TBS_SETTHUMBLENGTH
      WEnd
   Case $grippyRef = $NorthEast_Grippy
      Local $bottom = $cp[1] + $cp[3]  ;bottom = top + height
      While 1
         Local $i = GuiGetCursorInfo()
         If $i[2] = 0 Then ExitLoop ;exit when primary mouse button is up
         Local $cp = ControlGetPos($main, "", $refSelected)
         ToolTip($cp[2] & ' x' & $cp[3])  ;show width x height
         Local $prevWidth = $cp[2]
         Local $prevHeight = $cp[3]
         ;new width = mouseX - left (but also want width of at least 1 pixel)
         $mp = _mouseSnapPos()
         $cp[2] = $mp[0] - $cp[0]
         If $cp[2] < 1 Then $cp[2] = 1
         $mp = _mouseSnapPos()
         $cp[1] = $mp[1]            ;top = mouseY
         $cp[3] = $bottom - $mp[1]  ;height = bottom - mouseY
         If $cp[3] < 1 Then         ; ensure top is always above bottom
            $cp[3] = 1
            $cp[1] = $bottom
         EndIf
         ;update position of control and grippies on screen
         GuiCtrlSetPos($refSelected, $cp[0], $cp[1], $cp[2], $cp[3])
         showGrippies($refSelected)
         Local $h = ControlGetPos("","",$currentCtrl)
         GuiCtrlSendMsg($currentCtrl, 27+0x0400, $h[3] - 20, 0) ;TBS_SETTHUMBLENGTH
      WEnd
   Case $grippyRef = $NorthWest_Grippy
      Local $right = $cp[0] + $cp[2]  ;right = left + width
      Local $bottom = $cp[1] + $cp[3]  ;bottom = top + height
      While 1
         Local $i = GuiGetCursorInfo()
         If $i[2] = 0 Then ExitLoop ;exit when primary mouse button is up
         Local $cp = ControlGetPos($main, "", $refSelected)
         ToolTip($cp[2] & ' x' & $cp[3])  ;show width x height
         Local $prevWidth = $cp[2]
         Local $prevHeight = $cp[3]
         $mp = _mouseSnapPos()
         $cp[1] = $mp[1]           ;top = mouseY
         $cp[3] = $bottom - $mp[1] ;height = bottom - mouseY
         If $cp[3] < 1 Then        ; ensure top is always above bottom
            $cp[3] = 1
            $cp[1] = $bottom
         EndIf
         ;new width = mouseX - left (but also want width of at least 1 pixel)
         $cp[2] = $mp[0] - $cp[0]
         If $cp[2] < 1 Then $cp[2] = 1
         $mp = _mouseSnapPos()
         $cp[0] = $mp[0]           ;left = mouseX
         $cp[2] = $right - $mp[0]  ;width = right - mouseX
         If $cp[2] < 1 Then        ; ensure right side is before left
            $cp[2] = 1
            $cp[0] = $right
         EndIf
         ;update position of control and grippies on screen
         GuiCtrlSetPos($refSelected, $cp[0], $cp[1], $cp[2], $cp[3])
         showGrippies($refSelected)
         Local $h = ControlGetPos("","",$currentCtrl)
         GuiCtrlSendMsg($currentCtrl, 27+0x0400, $h[3] - 20, 0) ;TBS_SETTHUMBLENGTH
      WEnd
   EndSelect
   ToolTip('') ;clear any tooltip
EndFunc



Func _mouseClientMove($x, $y)
   $client = WinGetClientSize($main)
   $window = WinGetPos($main)
   $border = ($window[2] - $client[0]) / 2 ;width diff
	$titlebar = $window[3] - 2 * $border - $client[1] ;height diff
	Local $mouseCoordModeBAK = Opt("MouseCoordMode", 0) ;relative to window
	Local $mouseCoord = MouseGetPos()
	Local $border = ($window[2] - $client[0]) / 2
	Local $left = $x + $window[2] - $client[0] - $border
	Local $top  = $y + $window[3] - $client[1] - $border
	MouseMove($left, $top, 0) ;move instantly to point (left,top)
	Opt("MouseCoordMode", $mouseCoordModeBAK) ;original
EndFunc


Func _repaintWindow()
	; The SplashText forces the Helper window to repaint its controls
	Local $p = WinGetPos($main)
	SplashTextOn("", "", $p[2], $p[3], $p[0], $p[1], 1)
	SplashOff()
EndFunc



; CREATE A SLIDER THAT DOES NOT HAVE A MAX HEIGHT OF ~30 PIXELS:
Func _GuiCtrlCreateSlider($left, $top, $width, $height, $style)
   Local $ref = GuiCtrlCreateSlider($left, $top, $width, $height)
   If $style <= 0 Then $style = 0x50020001 ;the deault style
   GuiCtrlSetStyle($ref, BitOr($style,0x040)) ;TBS_FIXEDLENGTH
   Local $size =  $height - 20
   If $width - 20 < $size Then $size = $width - 20
   GuiCtrlSendMsg($ref, 27+0x0400, $size, 0) ;TBS_SETTHUMBLENGTH
   Return $ref
EndFunc



; Create ANOTHER tab control at the specified coordinates, and return a handle...
Func _createAnotherTab($left, $top, $width, $height)
  Local $parentGui = WinGetHandle("")
  Local $style = 0x56000000;WS_CHILD + WS_VISIBLE + WS_CLIPSIBLINGS + WS_CLIPCHILDREN
 ;I'm not sure why the -10 is needed, but it seems to calculate the right x,y coords
  $tabCtrlWin = GuiCreate("", $width, $height, $left,$top, $style, -1, $parentGui)
  GuiCtrlCreateTab(0, 0, $width, $height)
  GuiSetState()
  GuiSwitch($parentGui)
  Return $tabCtrlWin
EndFunc

; Add a tabitem to the specified tab control
Func _createAnotherTabItem($tabHandle, $text)
  Local $parentGui = WinGetHandle("")
 ; it would be better to explicitly use the handle of the parent GUI, but this the above
 ;  function seems to work
  GuiSwitch($tabHandle)
  Local $item = GuiCtrlCreateTabItem($text)
  If $text = "" Then GuiSwitch($parentGui);remember null text denotes "closing" tabitem
  Return $item
EndFunc
#endregion ------ functions ------

#region - Roy add-on
; Gui definition saved to Ini Files with .agd file ext, with followin structure:
; [Main] 			- Main section
; guiwidth=w		- Gui Width ($w)
; guiheigth=w		- Gui Heigth ($h)
; Left=n			- Left ($p[0])
; Top=n				- Top ($p[1])
; Width=n			- Width ($p[2])
; Height=n			- Height ($p[3])
; numctrls=n 		- total number of controls 

; then 1 section for each control 
; [Control_n]		- where n is a counter starting from 1
; Type=text			- the control type 
; Name=text			- the control Name ($MCL[$i][1])
; Text=text			- the control text (see code)
; Left=n			- Left ($p[0])
; Top=n				- Top ($p[1])
; Width=n			- Width ($p[2])
; Height=n			- Height ($p[3])


Func _SaveGuiDefinition()
	Local $w, $h, $p
	Local $n = 0, $Key, $Text
	;
	If $AgdOutFile = "" Then
		;MsgBox(0, "$AgdOutFile", $AgdOutFile)
		; ADDED by TheSaint
		If $lfld = "" Then $lfld = IniRead(@ScriptDir & "\Gbuild.ini", "Save Folder", "Last", "")
		If Not FileExists($lfld) Then $lfld = ""
		If $lfld = "" Then $lfld = @MyDocumentsDir
		$AgdOutFile = FileSaveDialog("Save GUI Definition to file?", $lfld, "AutoIt Gui Definitions (*.agd)", 2+16, StringReplace($gdtitle, '"',""))
		If @error = 1 Or $AgdOutFile = "" Then
			If $AgdOutFile = 1 Then $AgdOutFile = ""
			SplashTextOn("Save GUI Definition to file", @CRLF & "Definition not saved!", 200, 80)
			Sleep(1000)
			SplashOff()
			Return
		Else
			; ADDED by TheSaint
			$lfld = StringInStr($AgdOutFile, "\", 0, -1)
			$lfld = StringLeft($AgdOutFile, $lfld - 1)
			IniWrite(@ScriptDir & "\Gbuild.ini", "Save Folder", "Last", $lfld)
			If StringRight($AgdOutFile, 4) <> ".agd" Then $AgdOutFile = $AgdOutFile & ".agd"
			$mygui = StringReplace($AgdOutFile, $lfld & "\", "")
			$mygui = StringReplace($mygui, ".agd", "")
			$gdtitle = '"' & $mygui & '"'
			$mygui = $mygui & ".au3"
		EndIf
	EndIf
	;
	FileDelete($AgdOutFile)
	If @error Then
		SplashTextOn("Save GUI Definition to file", @CRLF & "Definition not saved!", 200, 80)
		Sleep(1000)
		SplashOff()
		Return 
	EndIf
	;
	;$size = WinGetClientSize("handle=" & $main)
	$size = WinGetClientSize($main)
	$w = $size[0]
	$h = $size[1]
	;$p = WinGetPos("handle=" & $main)
	$p = WinGetPos($main)
	IniWrite($AgdOutFile, "Main", "guiwidth", $w)
	IniWrite($AgdOutFile, "Main", "guiheight", $h)
	IniWrite($AgdOutFile, "Main", "Left", $p[0])
	IniWrite($AgdOutFile, "Main", "Top", $p[1])
	IniWrite($AgdOutFile, "Main", "Width", $p[2])
	IniWrite($AgdOutFile, "Main", "Height", $p[3])
	;
	For $i = $firstControl To $firstControl+$numCtrls-1
	   If $MCL[$i][0] Then
		  $n = $n + 1
		  $Key = "Control_" & $n
		  ;$p = ControlGetPos("handle=" & $main, "", $i)
		  $p = ControlGetPos($main, "", $i)
		  ;$Text = ControlGetText("handle=" & $main, "", $i)
		  $Text = ControlGetText($main, "", $i)
		  If @error Then $Text = $MCL[$i][1]
		  IniWrite($AgdOutFile, $Key, "Type", $MCL[$i][0])
		  IniWrite($AgdOutFile, $Key, "Name", $MCL[$i][1])
		  IniWrite($AgdOutFile, $Key, "Text", $Text)
		  IniWrite($AgdOutFile, $Key, "Left", $p[0])
		  IniWrite($AgdOutFile, $Key, "Top", $p[1])
		  IniWrite($AgdOutFile, $Key, "Width", $p[2])
		  IniWrite($AgdOutFile, $Key, "Height", $p[3])
	   EndIf
	Next
	IniWrite($AgdOutFile, "Main", "numctrls", $n)
	;
	SplashTextOn("Save GUI Definition to file", @LF & "Saved to " & @LF & $AgdOutFile, 500, 100)
	Sleep(2000)
	SplashOff()
EndFunc

Func _LoadGuiDefinition()
	Local $w, $h, $p[4], $rv, $ac = 0
	Local $n = 0, $Key , $i, $nc
	Local $Type, $Name, $Text
	;Local $AgdInfile ; DISABLED by TheSaint
	;
	If $numCtrls > 0 Then
		;SplashOff()
		If MsgBox(52,"Load Gui Definition from file", _ 
			"Loading a Gui Definition will clear existing controls." & @CRLF & _ 
			"Are you sure?" & @CRLF) = 7 Then
			Return
		EndIf
	EndIf
	;
	; ADDED by TheSaint
	$lfld = IniRead(@ScriptDir & "\Gbuild.ini", "Save Folder", "Last", "")
	If $lfld = "" Then $lfld = @MyDocumentsDir
	;
	;If $cmdln = 0 Then ; MODIFIED by TheSaint
	;MsgBox(0, "Command-line Status", $cmdln)
	;If $cmdln = "" or $cmdln = 0  or $cmdln = 1 Then ; MODIFIED by TheSaint
	If $cmdln = "" or $cmdln = 0  Then ; MODIFIED by TheSaint
		;SplashOff()
		$AgdInfile = FileOpenDialog("Load GUI Definition from file?", $lfld, "AutoIt Gui Definitions (*.agd)", 1)
		If @error Then 	Return
	Else
		$cmdln = ""
	EndIf
	;
	$w = IniRead($AgdInfile, "Main", "guiwidth",-1)
	If $w = -1 Then
		;SplashOff()
		MsgBox(16,"Load Gui Error", "Error loading gui definition. ")
		Return
	EndIf
	;
	; Clean current gui
	For $i = $firstControl To $firstControl+$numCtrls-1
		If $MCL[$i][0] Then
			GUICtrlDelete($i)
		EndIf
	Next
	;
	ReDim $MCL[1][2]
	ReDim $MCL[4097][2]	
	;
	$h = IniRead($AgdInfile, "Main", "guiheight",-1)
	$p[0] = IniRead($AgdInfile, "Main", "Left",-1)
	$p[1] = IniRead($AgdInfile, "Main", "Top",-1)
	$p[2] = IniRead($AgdInfile, "Main", "Width",-1)
	$p[3] = IniRead($AgdInfile, "Main", "Height",-1)
	;
	;WinMove("handle=" & $main, "", $p[0], $p[1], $p[2], $p[3])
	WinMove($main, "", $p[0], $p[1], $p[2], $p[3])
	;
	$nc = IniRead($AgdInfile, "Main", "numctrls",-1)
	For $i = 1 To $nc
		$Key = "Control_" & $i
		$Type = IniRead($AgdInfile, $Key, "Type",-1)
		$Name = IniRead($AgdInfile, $Key, "Name",-1)
		$Text = IniRead($AgdInfile, $Key, "Text",-1)
		$p[0] = IniRead($AgdInfile, $Key, "Left",-1)
		$p[1] = IniRead($AgdInfile, $Key, "Top",-1)
		$p[2] = IniRead($AgdInfile, $Key, "Width",-1)
		$p[3] = IniRead($AgdInfile, $Key, "Height",-1)
		Select
		; 1 Cursor
		; 2 Tab -no
		; 3 Group
			Case $Type = "Group"
				$rv = GUICtrlCreateGroup($Text, $p[0], $p[1], $p[2], $p[3])
		; 4 Button
			Case $Type = "Button"
				$rv = GUICtrlCreateButton($Text, $p[0], $p[1], $p[2], $p[3])
		; 5 Checkbox
			Case $Type = "Checkbox"
				$rv = GUICtrlCreateCheckbox($Text, $p[0], $p[1], $p[2], $p[3])
		; 6 Radio
			Case $Type = "Radio"
				$rv = GUICtrlCreateRadio($Text, $p[0], $p[1], $p[2], $p[3])
		; 7 Edit
			Case $Type = "Edit"
				$rv = GUICtrlCreateEdit($Text, $p[0], $p[1], $p[2], $p[3])
		; 8 Input
			Case $Type = "Input"
				$rv = GUICtrlCreateInput($Text, $p[0], $p[1], $p[2], $p[3])
		; 9 Label
			Case $Type = "Label"
				$rv = GUICtrlCreateLabel($Text, $p[0], $p[1], $p[2], $p[3])
		; 10 UpDown - no
		; 11 List
			Case $Type = "List"
				$rv = GUICtrlCreateList($Text, $p[0], $p[1], $p[2], $p[3])
				GUICtrlSetPos($rv, $p[0], $p[1], $p[2], $p[3])
		; 12 Combo
			Case $Type = "Combo"
				$rv = GUICtrlCreateCombo($Text, $p[0], $p[1], $p[2], $p[3])
		; 13 Date
			Case $Type = "Date"
				$rv = GUICtrlCreateDate($Text, $p[0], $p[1], $p[2], $p[3])
		; 14 Treeview
			Case $Type = "Treeview"
				$rv = GUICtrlCreateTreeview($p[0], $p[1], $p[2], $p[3])
				GUICtrlCreateTreeViewItem($Name, $rv)
				$ac = $ac + 1
		; 15 Progress
			Case $Type = "Progress"
				$rv = GUICtrlCreateProgress($p[0], $p[1], $p[2], $p[3])
				GUICtrlSetData($rv, 100)
		; 16 Avi - no
		; 17 Icon
			Case $Type = "Icon"
				$rv = GuiCtrlCreateIcon(@ScriptDir & "\iconset.icl", 0, $p[0], $p[1], $p[2], $p[3])
		; 18 Pic
			Case $Type = "Pic"
				$rv = GuiCtrlCreatePic(@ScriptDir & "\sampleImage.bmp", $p[0], $p[1], $p[2], $p[3])
		; 19 Menu
		; 20 ContextMenu - no
		; 21 Slider
			Case $Type = "Slider"
				$rv = GUICtrlCreateSlider($p[0], $p[1], $p[2], $p[3])
		EndSelect
		If $i = 1 then $firstControl = $rv
		$MCL[$rv][0] = $Type
		$MCL[$rv][1] = $Name
	Next
	$numCtrls = $nc + $ac
    $grippyCtrl = 0
	_repaintWindow()
	SplashTextOn("Load GUI Definition from file", @LF & "Loaded from " & @LF & $AgdInfile, 500, 100)
	;$AgdOutFile = ""
	$AgdOutFile = $AgdInfile
	Sleep(2000)
	SplashOff()
EndFunc
#endregion - Roy add-on

; ADDED by TheSaint
Func CheckCommandline()
	If $cmdchk = "" Then
		$cmdchk = 1
		;If $cmdln <> 0 And $cmdln <> 1 Then
		;MsgBox(0, "Got to Here", "Command-line check 1")
		If $cmdln = 1 Then
			;MsgBox(0, "$CmdLine[1]", $CmdLine[1])
			If StringRight($CmdLine[1], 4) = ".agd" Then
				;SplashTextOn("", "Loading definition file!", )
				;ControlSetText("", "", "Static1", "Loading definition file!")
				$AgdInfile = FileGetLongName($CmdLine[1])
				;MsgBox(0, "Command-line", "Command-line is " & @CRLF & $AgdInfile)
				_LoadGuiDefinition()
			EndIf
		EndIf
	EndIf
	;SplashOff()
EndFunc

Func GetScriptTitle()
	;AutoItSetOption("WinTitleMatchMode", 4)
	;MsgBox(0, "$AgdInfile", $AgdInfile)
	If $AgdInfile = "" Then
		$gdtitle = WinGetTitle("classname=SciTEWindow", "")
	Else
		$gdtitle = $AgdOutFile
	EndIf
	If $gdtitle <> "" Then
		$gdvar = StringSplit($gdtitle, "\")
		$lfld = StringLeft($gdtitle, StringInStr($gdtitle, $gdvar[$gdvar[0]]) - 2)
		$gdtitle = $gdvar[$gdvar[0]]
		If $AgdInfile = "" Then
			$gdvar = StringInStr($gdtitle, ".au3")
		Else
			$gdvar = StringInStr($gdtitle, ".agd")
		EndIf
		$gdtitle = StringLeft($gdtitle, $gdvar - 1)
	Else
		$gdtitle = "MyGUI"
	EndIf
	$mygui = $gdtitle & ".au3"
	;MsgBox(0, "$mygui", $mygui)
	$gdtitle = '"' & $gdtitle & '"'
EndFunc
; END ADD

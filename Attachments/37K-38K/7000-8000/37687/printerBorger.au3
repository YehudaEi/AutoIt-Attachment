; <AUT2EXE VERSION: 3.2.1.11>

; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: G:\PrinterSetup\gui.au3>
; ----------------------------------------------------------------------------

#cs######################################################
	#
	#Printer Install
	#
	#Programmed By: Steven Buck
	#
	#May 25th 2012
	#
#ce######################################################


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Program Files\AutoIt3\beta\Include\GUIConstants.au3>
; ----------------------------------------------------------------------------

; Include Version:3.1.1.107  (25/05/2012)

; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1 (beta)
; Language:       English
; Description:    Stub file providing compatibility between the new
;						library design and the old.
;
; ------------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Program Files\AutoIt3\beta\Include\GUIDefaultConstants.au3>
; ----------------------------------------------------------------------------


; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1 (beta)
; Language:       English
; Description:    AutoIt-GUI default control styles.
;
; ------------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Program Files\AutoIt3\beta\Include\WindowsConstants.au3>
; ----------------------------------------------------------------------------


; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1 (beta)
; Language:       English
; Description:    Windows constants.
;
; ------------------------------------------------------------------------------

; Window Styles
Global Const $WS_TILED				= 0
Global Const $WS_OVERLAPPED 		= 0
Global Const $WS_MAXIMIZEBOX		= 0x00010000
Global Const $WS_MINIMIZEBOX		= 0x00020000
Global Const $WS_TABSTOP			= 0x00010000
Global Const $WS_GROUP				= 0x00020000
Global Const $WS_SIZEBOX			= 0x00040000
Global Const $WS_THICKFRAME			= 0x00040000
Global Const $WS_SYSMENU			= 0x00080000
Global Const $WS_HSCROLL			= 0x00100000
Global Const $WS_VSCROLL			= 0x00200000
Global Const $WS_DLGFRAME 			= 0x00400000
Global Const $WS_BORDER				= 0x00800000
Global Const $WS_CAPTION			= 0x00C00000
Global Const $WS_OVERLAPPEDWINDOW	= 0x00CF0000
Global Const $WS_TILEDWINDOW		= 0x00CF0000
Global Const $WS_MAXIMIZE			= 0x01000000
Global Const $WS_CLIPCHILDREN		= 0x02000000
Global Const $WS_CLIPSIBLINGS		= 0x04000000
Global Const $WS_DISABLED 			= 0x08000000
Global Const $WS_VISIBLE			= 0x10000000
Global Const $WS_MINIMIZE			= 0x20000000
Global Const $WS_CHILD				= 0x40000000
Global Const $WS_POPUP				= 0x80000000
Global Const $WS_POPUPWINDOW		= 0x80880000

; Dialog Styles
Global Const $DS_MODALFRAME 		= 0x80
Global Const $DS_SETFOREGROUND		= 0x00000200
Global Const $DS_CONTEXTHELP		= 0x00002000

; Window Extended Styles
Global Const $WS_EX_ACCEPTFILES			= 0x00000010
Global Const $WS_EX_MDICHILD			= 0x00000040
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

; Messages
Global Const $WM_SIZE = 0x05
Global Const $WM_SIZING = 0x0214
Global Const $WM_USER = 0X400
Global Const $WM_GETTEXTLENGTH = 0x000E
Global Const $WM_GETTEXT = 0x000D

; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Program Files\AutoIt3\beta\Include\WindowsConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Program Files\AutoIt3\beta\Include\AVIConstants.au3>
; ----------------------------------------------------------------------------


; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1 (beta)
; Language:       English
; Description:    AVI Constants.
;
; ------------------------------------------------------------------------------

; Styles
Global Const $ACS_CENTER			= 1
Global Const $ACS_TRANSPARENT		= 2
Global Const $ACS_AUTOPLAY			= 4
Global Const $ACS_TIMER				= 8
Global Const $ACS_NONTRANSPARENT	= 16

; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Program Files\AutoIt3\beta\Include\AVIConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Program Files\AutoIt3\beta\Include\ComboConstants.au3>
; ----------------------------------------------------------------------------


; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1 (beta)
; Language:       English
; Description:    ComboBox constants.
;
; ------------------------------------------------------------------------------
; Combo
Global Const $CBS_SIMPLE			= 0x0001
Global Const $CBS_DROPDOWN			= 0x0002
Global Const $CBS_DROPDOWNLIST		= 0x0003
Global Const $CBS_AUTOHSCROLL		= 0x0040
Global Const $CBS_OEMCONVERT		= 0x0080
Global Const $CBS_SORT				= 0x0100
Global Const $CBS_NOINTEGRALHEIGHT	= 0x0400
Global Const $CBS_DISABLENOSCROLL	= 0x0800
Global Const $CBS_UPPERCASE			= 0x2000
Global Const $CBS_LOWERCASE			= 0x4000

; Error checking
Global Const $CB_ERR = -1
Global Const $CB_ERRATTRIBUTE = -3
Global Const $CB_ERRREQUIRED = -4
Global Const $CB_ERRSPACE = -2
Global Const $CB_OKAY = 0

; Messages to send to combobox
Global Const $CB_ADDSTRING = 0x143
Global Const $CB_DELETESTRING = 0x144
Global Const $CB_DIR = 0x145
Global Const $CB_FINDSTRING = 0x14C
Global Const $CB_FINDSTRINGEXACT = 0x158
Global Const $CB_GETCOUNT = 0x146
Global Const $CB_GETCURSEL = 0x147
Global Const $CB_GETDROPPEDCONTROLRECT = 0x152
Global Const $CB_GETDROPPEDSTATE = 0x157
Global Const $CB_GETDROPPEDWIDTH = 0X15f
Global Const $CB_GETEDITSEL = 0x140
Global Const $CB_GETEXTENDEDUI = 0x156
Global Const $CB_GETHORIZONTALEXTENT = 0x15d
Global Const $CB_GETITEMDATA = 0x150
Global Const $CB_GETITEMHEIGHT = 0x154
Global Const $CB_GETLBTEXT = 0x148
Global Const $CB_GETLBTEXTLEN = 0x149
Global Const $CB_GETLOCALE = 0x15A
Global Const $CB_GETMINVISIBLE = 0x1702
Global Const $CB_GETTOPINDEX = 0x15b
Global Const $CB_INITSTORAGE = 0x161
Global Const $CB_LIMITTEXT = 0x141
Global Const $CB_RESETCONTENT = 0x14B
Global Const $CB_INSERTSTRING = 0x14A
Global Const $CB_SELECTSTRING = 0x14D
Global Const $CB_SETCURSEL = 0x14E
Global Const $CB_SETDROPPEDWIDTH = 0x160
Global Const $CB_SETEDITSEL = 0x142
Global Const $CB_SETEXTENDEDUI = 0x155
Global Const $CB_SETHORIZONTALEXTENT = 0x15e
Global Const $CB_SETITEMDATA = 0x151
Global Const $CB_SETITEMHEIGHT = 0x153
Global Const $CB_SETLOCALE = 0x15
Global Const $CB_SETMINVISIBLE = 0x1701
Global Const $CB_SETTOPINDEX = 0x15c
Global Const $CB_SHOWDROPDOWN = 0x14F

; attributes
Global Const $CB_DDL_ARCHIVE = 0x20
Global Const $CB_DDL_DIRECTORY = 0x10
Global Const $CB_DDL_DRIVES = 0x4000
Global Const $CB_DDL_EXCLUSIVE = 0x8000
Global Const $CB_DDL_HIDDEN = 0x2
Global Const $CB_DDL_READONLY = 0x1
Global Const $CB_DDL_READWRITE = 0x0
Global Const $CB_DDL_SYSTEM = 0x4

; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Program Files\AutoIt3\beta\Include\ComboConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Program Files\AutoIt3\beta\Include\DateTimeConstants.au3>
; ----------------------------------------------------------------------------


; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1 (beta)
; Language:       English
; Description:    DateTime Control Constants.
;
; ------------------------------------------------------------------------------

; Date
Global Const $DTS_SHORTDATEFORMAT	= 0
Global Const $DTS_UPDOWN			= 1
Global Const $DTS_SHOWNONE			= 2
Global Const $DTS_LONGDATEFORMAT	= 4
Global Const $DTS_TIMEFORMAT		= 9
Global Const $DTS_RIGHTALIGN		= 32

; MonthCal
Global Const $MCS_NOTODAY			= 16
Global Const $MCS_NOTODAYCIRCLE		= 8
Global Const $MCS_WEEKNUMBERS		= 4

Global Const $MCM_FIRST = 0x1000
Global Const $MCM_GETCOLOR = ($MCM_FIRST + 11)
Global Const $MCM_GETFIRSTDAYOFWEEK = ($MCM_FIRST + 16)
Global Const $MCM_GETMAXSELCOUNT = ($MCM_FIRST + 3)
Global Const $MCM_GETMAXTODAYWIDTH = ($MCM_FIRST + 21)
Global Const $MCM_GETMINREQRECT = ($MCM_FIRST + 9)
Global Const $MCM_GETMONTHDELTA = ($MCM_FIRST + 19)
Global Const $MCS_MULTISELECT = 0x2
Global Const $MCM_SETCOLOR = ($MCM_FIRST + 10)
Global Const $MCM_SETFIRSTDAYOFWEEK = ($MCM_FIRST + 15)
Global Const $MCM_SETMAXSELCOUNT = ($MCM_FIRST + 4)
Global Const $MCM_SETMONTHDELTA = ($MCM_FIRST + 20)

Global Const $MCSC_BACKGROUND = 0
Global Const $MCSC_MONTHBK = 4
Global Const $MCSC_TEXT = 1
Global Const $MCSC_TITLEBK = 2
Global Const $MCSC_TITLETEXT = 3
Global Const $MCSC_TRAILINGTEXT = 5

; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Program Files\AutoIt3\beta\Include\DateTimeConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Program Files\AutoIt3\beta\Include\EditConstants.au3>
; ----------------------------------------------------------------------------


; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1 (beta)
; Language:       English
; Description:    Edit Constants.
;
; ------------------------------------------------------------------------------

; Styles
Global Const $ES_LEFT				= 0
Global Const $ES_CENTER				= 1
Global Const $ES_RIGHT				= 2
Global Const $ES_MULTILINE			= 4
Global Const $ES_UPPERCASE			= 8
Global Const $ES_LOWERCASE			= 16
Global Const $ES_PASSWORD			= 32
Global Const $ES_AUTOVSCROLL		= 64
Global Const $ES_AUTOHSCROLL		= 128
Global Const $ES_NOHIDESEL			= 256
Global Const $ES_OEMCONVERT			= 1024
Global Const $ES_READONLY			= 2048
Global Const $ES_WANTRETURN			= 4096
Global Const $ES_NUMBER				= 8192
;Global Const $ES_DISABLENOSCROLL = 8192
;Global Const $ES_SUNKEN = 16384
;Global Const $ES_VERTICAL = 4194304
;Global Const $ES_SELECTIONBAR = 16777216

; Error checking
Global Const $EC_ERR = -1

; Messages to send to edit control
Global Const $ECM_FIRST = 0X1500
Global Const $EM_CANUNDO = 0xC6
Global Const $EM_EMPTYUNDOBUFFER = 0xCD
Global Const $EM_GETFIRSTVISIBLELINE = 0xCE
Global Const $EM_GETLINECOUNT = 0xBA
Global Const $EM_GETMODIFY = 0xB8
Global Const $EM_GETRECT = 0xB2
Global Const $EM_GETSEL = 0xB0
Global Const $EM_LINEFROMCHAR = 0xC9
Global Const $EM_LINEINDEX = 0xBB
Global Const $EM_LINELENGTH = 0xC1
Global Const $EM_LINESCROLL = 0xB6
Global Const $EM_REPLACESEL = 0xC2
Global Const $EM_SCROLL = 0xB5
Global Const $EM_SCROLLCARET = 0x00B7
Global Const $EM_SETMODIFY = 0xB9
Global Const $EM_SETSEL = 0xB1
Global Const $EM_UNDO = 0xC7
Global Const $EM_SETREADONLY = 0x00CF
Global Const $EM_SETTABSTOPS = 0x00CB

; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Program Files\AutoIt3\beta\Include\EditConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Program Files\AutoIt3\beta\Include\StaticConstants.au3>
; ----------------------------------------------------------------------------


; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1 (beta)
; Language:       English
; Description:    Static (label, pic, icon) Constants.
;
; ------------------------------------------------------------------------------

; Label/Pic/Icon
Global Const $SS_LEFT			= 0
Global Const $SS_CENTER			= 1
Global Const $SS_RIGHT			= 2
Global Const $SS_ICON			= 3
Global Const $SS_BLACKRECT		= 4
Global Const $SS_GRAYRECT		= 5
Global Const $SS_WHITERECT		= 6
Global Const $SS_BLACKFRAME		= 7
Global Const $SS_GRAYFRAME		= 8
Global Const $SS_WHITEFRAME		= 9
Global Const $SS_SIMPLE			= 11
Global Const $SS_LEFTNOWORDWRAP	= 12
Global Const $SS_BITMAP			= 15
Global Const $SS_ETCHEDHORZ		= 16
Global Const $SS_ETCHEDVERT		= 17
Global Const $SS_ETCHEDFRAME	= 18
Global Const $SS_NOPREFIX		= 0x0080
Global Const $SS_NOTIFY			= 0x0100
Global Const $SS_CENTERIMAGE	= 0x0200
Global Const $SS_RIGHTJUST		= 0x0400
Global Const $SS_SUNKEN			= 0x1000

; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Program Files\AutoIt3\beta\Include\StaticConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Program Files\AutoIt3\beta\Include\ListBoxConstants.au3>
; ----------------------------------------------------------------------------


; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1 (beta)
; Language:       English
; Description:    ListBox Constants.
;
; ------------------------------------------------------------------------------

; Styles
Global Const $LBS_NOTIFY			= 0x0001
Global Const $LBS_SORT				= 0x0002
Global Const $LBS_USETABSTOPS		= 0x0080
Global Const $LBS_NOINTEGRALHEIGHT	= 0x0100
Global Const $LBS_DISABLENOSCROLL	= 0x1000
Global Const $LBS_NOSEL				= 0x4000
Global Const $LBS_STANDARD			= 0xA00003

; Errors
Global Const $LB_ERR = -1
Global Const $LB_ERRATTRIBUTE = -3
Global Const $LB_ERRREQUIRED = -4
Global Const $LB_ERRSPACE = -2

; Messages to send to listbox
Global Const $LB_ADDSTRING = 0x180
Global Const $LB_DELETESTRING = 0x182
Global Const $LB_DIR = 0x18D
Global Const $LB_FINDSTRING = 0x18F
Global Const $LB_FINDSTRINGEXACT = 0x1A2
Global Const $LB_GETANCHORINDEX = 0x019D
Global Const $LB_GETCARETINDEX = 0x019F
Global Const $LB_GETCOUNT = 0x18B
Global Const $LB_GETCURSEL = 0x188
Global Const $LB_GETHORIZONTALEXTENT = 0x193
Global Const $LB_GETITEMRECT = 0x198
Global Const $LB_GETLISTBOXINFO = 0x01B2
Global Const $LB_GETLOCALE = 0x1A6
Global Const $LB_GETSEL = 0x0187
Global Const $LB_GETSELCOUNT = 0x0190
Global Const $LB_GETSELITEMS = 0X191
Global Const $LB_GETTEXT = 0x0189
Global Const $LB_GETTEXTLEN = 0x018A
Global Const $LB_GETTOPINDEX = 0x018E
Global Const $LB_INSERTSTRING = 0x181
Global Const $LB_RESETCONTENT = 0x184
Global Const $LB_SELECTSTRING = 0x18C
Global Const $LB_SETITEMHEIGHT = 0x1A0
Global Const $LB_SELITEMRANGE = 0x19B
Global Const $LB_SELITEMRANGEEX = 0x0183
Global Const $LB_SETANCHORINDEX = 0x19C
Global Const $LB_SETCARETINDEX = 0x19E
Global Const $LB_SETCURSEL = 0x186
Global Const $LB_SETHORIZONTALEXTENT = 0x194
Global Const $LB_SETLOCALE = 0x1A5
Global Const $LB_SETSEL = 0x0185
Global Const $LB_SETTOPINDEX = 0x197

Global Const $LBS_MULTIPLESEL = 0x8

; attributes
Global Const $DDL_ARCHIVE = 0x20
Global Const $DDL_DIRECTORY = 0x10
Global Const $DDL_DRIVES = 0x4000
Global Const $DDL_EXCLUSIVE = 0x8000
Global Const $DDL_HIDDEN = 0x2
Global Const $DDL_READONLY = 0x1
Global Const $DDL_READWRITE = 0x0
Global Const $DDL_SYSTEM = 0x4

; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Program Files\AutoIt3\beta\Include\ListBoxConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Program Files\AutoIt3\beta\Include\ListViewConstants.au3>
; ----------------------------------------------------------------------------


; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1 (beta)
; Language:       English
; Description:    ListView Constants.
;
; ------------------------------------------------------------------------------

; Styles
Global Const $LVS_ICON	 			= 0x0000
Global Const $LVS_REPORT 			= 0x0001
Global Const $LVS_SMALLICON			= 0x0002
Global Const $LVS_LIST				= 0x0003
Global Const $LVS_EDITLABELS		= 0x0200
Global Const $LVS_NOCOLUMNHEADER	= 0x4000
Global Const $LVS_NOSORTHEADER		= 0x8000
Global Const $LVS_SINGLESEL			= 0x0004
Global Const $LVS_SHOWSELALWAYS		= 0x0008
Global Const $LVS_SORTASCENDING		= 0X0010
Global Const $LVS_SORTDESCENDING	= 0x0020

; listView Extended Styles
Global Const $LVS_EX_FULLROWSELECT		= 0x00000020
Global Const $LVS_EX_GRIDLINES			= 0x00000001
Global Const $LVS_EX_SUBITEMIMAGES		= 0x00000002
Global Const $LVS_EX_CHECKBOXES			= 0x00000004
Global Const $LVS_EX_TRACKSELECT		= 0x00000008
Global Const $LVS_EX_HEADERDRAGDROP		= 0x00000010
Global Const $LVS_EX_FLATSB				= 0x00000100
Global Const $LVS_EX_BORDERSELECT		= 0x00008000
;Global Const $LVS_EX_MULTIWORKAREAS		= 0x00002000
;Global Const $LVS_EX_SNAPTOGRID			= 0x00080000
;Global Const $LVS_EX_DOUBLEBUFFER		= 0x00010000
Global Const $LVS_EX_HIDELABELS = 0x20000
Global Const $LVS_EX_INFOTIP = 0x400
Global Const $LVS_EX_LABELTIP = 0x4000
Global Const $LVS_EX_ONECLICKACTIVATE = 0x40
Global Const $LVS_EX_REGIONAL = 0x200
Global Const $LVS_EX_SINGLEROW = 0x40000
Global Const $LVS_EX_TWOCLICKACTIVATE = 0x80
;~ Global Const $LVS_EX_TRACKSELECT = 0x8
Global Const $LVS_EX_UNDERLINEHOT = 0x800
Global Const $LVS_EX_UNDERLINECOLD = 0x1000

; error
Global Const $LV_ERR = -1


; Messages to send to listview
Global Const $CCM_FIRST = 0x2000
Global Const $CCM_GETUNICODEFORMAT = ($CCM_FIRST + 6)
Global Const $CCM_SETUNICODEFORMAT = ($CCM_FIRST + 5)
Global Const $CLR_NONE = 0xFFFFFFFF
Global Const $LVM_FIRST = 0x1000

Global Const $LV_VIEW_DETAILS = 0x1
Global Const $LV_VIEW_ICON = 0x0
Global Const $LV_VIEW_LIST = 0x3
Global Const $LV_VIEW_SMALLICON = 0x2
Global Const $LV_VIEW_TILE = 0x4

Global Const $LVCF_FMT = 0x1
Global Const $LVCF_WIDTH = 0x2
Global Const $LVCF_TEXT = 0x4
Global Const $LVCFMT_CENTER = 0x2
Global Const $LVCFMT_LEFT = 0x0
Global Const $LVCFMT_RIGHT = 0x1

Global Const $LVA_ALIGNLEFT = 0x1
Global Const $LVA_ALIGNTOP = 0x2
Global Const $LVA_DEFAULT = 0x0
Global Const $LVA_SNAPTOGRID = 0x5

Global Const $LVIF_STATE = 0x8
Global Const $LVIF_TEXT = 0x1

Global Const $LVFI_PARAM = 0x1
Global Const $LVFI_PARTIAL = 0x8
Global Const $LVFI_STRING = 0x2
Global Const $LVFI_WRAP = 0x20

Global Const $VK_LEFT = 0x25
Global Const $VK_RIGHT = 0x27
Global Const $VK_UP = 0x26
Global Const $VK_DOWN = 0x28
Global Const $VK_END = 0x23
Global Const $VK_PRIOR = 0x21
Global Const $VK_NEXT = 0x22

Global Const $LVIR_BOUNDS = 0

Global Const $LVIS_CUT = 0x4
Global Const $LVIS_DROPHILITED = 0x8
Global Const $LVIS_FOCUSED = 0x1
Global Const $LVIS_OVERLAYMASK = 0xF00
Global Const $LVIS_SELECTED = 0x2
Global Const $LVIS_STATEIMAGEMASK = 0xF000

Global Const $LVM_ARRANGE = ($LVM_FIRST + 22)
Global Const $LVM_CANCELEDITLABEL = ($LVM_FIRST + 179)
Global Const $LVM_DELETECOLUMN = 0x101C
Global Const $LVM_DELETEITEM = 0x1008
Global Const $LVM_DELETEALLITEMS = 0x1009
Global Const $LVM_EDITLABELA = ($LVM_FIRST + 23)
Global Const $LVM_EDITLABEL = $LVM_EDITLABELA
Global Const $LVM_ENABLEGROUPVIEW = ($LVM_FIRST + 157)
Global Const $LVM_ENSUREVISIBLE = ($LVM_FIRST + 19)
Global Const $LVM_FINDITEM = ($LVM_FIRST + 13)
Global Const $LVM_GETBKCOLOR = ($LVM_FIRST + 0)
Global Const $LVM_GETCALLBACKMASK = ($LVM_FIRST + 10)
Global Const $LVM_GETCOLUMNORDERARRAY = ($LVM_FIRST + 59)
Global Const $LVM_GETCOLUMNWIDTH = ($LVM_FIRST + 29)
Global Const $LVM_GETCOUNTPERPAGE = ($LVM_FIRST + 40)
Global Const $LVM_GETEDITCONTROL = ($LVM_FIRST + 24)
Global Const $LVM_GETEXTENDEDLISTVIEWSTYLE = ($LVM_FIRST + 55)
Global Const $LVM_GETHEADER = ($LVM_FIRST + 31)
Global Const $LVM_GETHOTCURSOR = ($LVM_FIRST + 63)
Global Const $LVM_GETHOTITEM = ($LVM_FIRST + 61)
Global Const $LVM_GETHOVERTIME = ($LVM_FIRST + 72)
Global Const $LVM_GETIMAGELIST = ($LVM_FIRST + 2)
Global Const $LVM_GETITEMA = ($LVM_FIRST + 5)
Global Const $LVM_GETITEMCOUNT = 0x1004
Global Const $LVM_GETITEMSTATE = ($LVM_FIRST + 44)
Global Const $LVM_GETITEMTEXTA = ($LVM_FIRST + 45);
Global Const $LVM_GETNEXTITEM = 0x100c
Global Const $LVM_GETSELECTEDCOLUMN = ($LVM_FIRST + 174)
Global Const $LVM_GETSELECTEDCOUNT = ($LVM_FIRST + 50)
Global Const $LVM_GETSUBITEMRECT = ($LVM_FIRST + 56);
Global Const $LVM_GETTOPINDEX = ($LVM_FIRST + 39)
Global Const $LVM_GETUNICODEFORMAT = $CCM_GETUNICODEFORMAT
Global Const $LVM_GETVIEW = ($LVM_FIRST + 143)
Global Const $LVM_GETVIEWRECT = ($LVM_FIRST + 34)
Global Const $LVM_INSERTCOLUMNA = ($LVM_FIRST + 27)
Global Const $LVM_INSERTITEMA = ($LVM_FIRST + 7)
Global Const $LVM_REDRAWITEMS = ($LVM_FIRST + 21)
Global Const $LVM_SETUNICODEFORMAT = $CCM_SETUNICODEFORMAT
Global Const $LVM_SCROLL = ($LVM_FIRST + 20)
Global Const $LVM_SETBKCOLOR = 0x1001
Global Const $LVM_SETCALLBACKMASK = ($LVM_FIRST + 11)
Global Const $LVM_SETCOLUMNA = ($LVM_FIRST + 26)
Global Const $LVM_SETCOLUMNORDERARRAY = ($LVM_FIRST + 58)
Global Const $LVM_SETCOLUMNWIDTH = 0x101E
Global Const $LVM_SETEXTENDEDLISTVIEWSTYLE = 0x1036
Global Const $LVM_SETHOTITEM = ($LVM_FIRST + 60)
Global Const $LVM_SETHOVERTIME = ($LVM_FIRST + 71)
Global Const $LVM_SETICONSPACING = ($LVM_FIRST + 53)
Global Const $LVM_SETITEMCOUNT = ($LVM_FIRST + 47)
Global Const $LVM_SETITEMPOSITION = ($LVM_FIRST + 15)
Global Const $LVM_SETITEMSTATE = ($LVM_FIRST + 43)
Global Const $LVM_SETITEMTEXTA = ($LVM_FIRST + 46)
Global Const $LVM_SETSELECTEDCOLUMN = ($LVM_FIRST + 140)
Global Const $LVM_SETTEXTCOLOR = ($LVM_FIRST + 36)
Global Const $LVM_SETTEXTBKCOLOR = ($LVM_FIRST + 38)
Global Const $LVM_SETVIEW = ($LVM_FIRST + 142)
Global Const $LVM_UPDATE = ($LVM_FIRST + 42)

Global Const $LVNI_ABOVE = 0x100
Global Const $LVNI_BELOW = 0x200
Global Const $LVNI_TOLEFT = 0x400
Global Const $LVNI_TORIGHT = 0x800
Global Const $LVNI_ALL = 0x0
Global Const $LVNI_CUT = 0x4
Global Const $LVNI_DROPHILITED = 0x8
Global Const $LVNI_FOCUSED = 0x1
Global Const $LVNI_SELECTED = 0x2

Global Const $LVSCW_AUTOSIZE = -1
Global Const $LVSCW_AUTOSIZE_USEHEADER = -2

Global Const $LVSICF_NOINVALIDATEALL = 0x1
Global Const $LVSICF_NOSCROLL = 0x2

Global Const $LVSIL_NORMAL = 0
Global Const $LVSIL_SMALL = 1
Global Const $LVSIL_STATE = 2

; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Program Files\AutoIt3\beta\Include\ListViewConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Program Files\AutoIt3\beta\Include\SliderConstants.au3>
; ----------------------------------------------------------------------------


; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1 (beta)
; Language:       English
; Description:    Slider Constants
;
; ------------------------------------------------------------------------------

; Styles
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

; Messages
Global Const $TWM_USER = 0x400	; WM_USER
Global Const $TBM_CLEARTICS = ($TWM_USER + 9)
Global Const $TBM_GETLINESIZE = ($TWM_USER + 24)
Global Const $TBM_GETPAGESIZE = ($TWM_USER + 22)
Global Const $TBM_GETNUMTICS = ($TWM_USER + 16)
Global Const $TBM_GETPOS = $TWM_USER
Global Const $TBM_GETRANGEMAX = ($TWM_USER + 2)
Global Const $TBM_GETRANGEMIN = ($TWM_USER + 1)
Global Const $TBM_SETLINESIZE = ($TWM_USER + 23)
Global Const $TBM_SETPAGESIZE = ($TWM_USER + 21)
Global Const $TBM_SETPOS = ($TWM_USER + 5)
Global Const $TBM_SETTICFREQ = ($TWM_USER + 20)

; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Program Files\AutoIt3\beta\Include\SliderConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Program Files\AutoIt3\beta\Include\TreeViewConstants.au3>
; ----------------------------------------------------------------------------


; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1 (beta)
; Language:       English
; Description:    TreeView Constants.
;
; ------------------------------------------------------------------------------

; Styles
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

Global Const $TVE_COLLAPSE			= 0x0001
Global Const $TVE_EXPAND			= 0x0002
Global Const $TVE_TOGGLE			= 0x0003
Global Const $TVE_EXPANDPARTIAL		= 0x4000
Global Const $TVE_COLLAPSERESET = 0x8000

Global Const $TVGN_ROOT				= 0x0000
Global Const $TVGN_NEXT				= 0x0001
Global Const $TVGN_PARENT			= 0x0003
Global Const $TVGN_CHILD			= 0x0004
Global Const $TVGN_CARET			= 0x0009

Global Const $TVI_ROOT				= 0xFFFF0000
Global Const $TVI_FIRST				= 0xFFFF0001
Global Const $TVI_LAST				= 0xFFFF0002
Global Const $TVI_SORT				= 0xFFFF0003

Global Const $TVIF_TEXT = 0x0001
Global Const $TVIF_IMAGE			= 0x0002
Global Const $TVIF_PARAM			= 0x0004
Global Const $TVIF_STATE			= 0x0008
Global Const $TVIF_HANDLE			= 0x0010
Global Const $TVIF_SELECTEDIMAGE	= 0x0020
Global Const $TVIF_CHILDREN			= 0x0040

Global Const $TVIS_SELECTED			= 0x0002
Global Const $TVIS_CUT				= 0x0004
Global Const $TVIS_DROPHILITED		= 0x0008
Global Const $TVIS_BOLD				= 0x0010
Global Const $TVIS_EXPANDED			= 0x0020
Global Const $TVIS_EXPANDEDONCE		= 0x0040
Global Const $TVIS_EXPANDPARTIAL	= 0x0080
Global Const $TVIS_OVERLAYMASK		= 0x0F00
Global Const $TVIS_STATEIMAGEMASK = 0xF000

; Messages to send to TreeView
Global Const $TV_FIRST				= 0x1100
Global Const $TVM_INSERTITEM		= $TV_FIRST + 0
Global Const $TVM_DELETEITEM		= $TV_FIRST + 1
Global Const $TVM_EXPAND			= $TV_FIRST + 2
Global Const $TVM_GETCOUNT			= $TV_FIRST + 5
Global Const $TVM_GETINDENT			= $TV_FIRST + 6
Global Const $TVM_SETINDENT			= $TV_FIRST + 7
Global Const $TVM_GETIMAGELIST		= $TV_FIRST + 8
Global Const $TVM_SETIMAGELIST		= $TV_FIRST + 9
Global Const $TVM_GETNEXTITEM		= $TV_FIRST + 10
Global Const $TVM_SELECTITEM		= $TV_FIRST + 11
Global Const $TVM_GETITEM			= $TV_FIRST + 12
Global Const $TVM_SETITEM			= $TV_FIRST + 13
Global Const $TVM_SORTCHILDREN		= $TV_FIRST + 19
Global Const $TVM_ENSUREVISIBLE		= $TV_FIRST + 20
Global Const $TVM_SETBKCOLOR		= $TV_FIRST + 29
Global Const $TVM_SETTEXTCOLOR		= $TV_FIRST + 30
Global Const $TVM_GETBKCOLOR		= $TV_FIRST + 31
Global Const $TVM_GETTEXTCOLOR		= $TV_FIRST + 32
Global Const $TVM_SETLINECOLOR		= $TV_FIRST + 40
Global Const $TVM_GETLINECOLOR		= $TV_FIRST + 41

; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Program Files\AutoIt3\beta\Include\TreeViewConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Program Files\AutoIt3\beta\Include\UpDownConstants.au3>
; ----------------------------------------------------------------------------


; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1
; Language:       English
; Description:    UpDown Constants.
;
; ------------------------------------------------------------------------------

; Styles
Global Const $UDS_WRAP 				= 0x0001
Global Const $UDS_SETBUDDYINT		= 0x0002
Global Const $UDS_ALIGNRIGHT 		= 0x0004
Global Const $UDS_ALIGNLEFT			= 0x0008
Global Const $UDS_ARROWKEYS 		= 0x0020
Global Const $UDS_HORZ 				= 0x0040
Global Const $UDS_NOTHOUSANDS 		= 0x0080

; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Program Files\AutoIt3\beta\Include\UpDownConstants.au3>
; ----------------------------------------------------------------------------


; Control default styles
Global Const $GUI_SS_DEFAULT_AVI		= $ACS_TRANSPARENT
Global Const $GUI_SS_DEFAULT_BUTTON		= 0
Global Const $GUI_SS_DEFAULT_CHECKBOX	= 0
Global Const $GUI_SS_DEFAULT_COMBO		= BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL, $WS_VSCROLL)
Global Const $GUI_SS_DEFAULT_DATE		= $DTS_LONGDATEFORMAT
Global Const $GUI_SS_DEFAULT_EDIT		= BitOR($ES_WANTRETURN, $WS_VSCROLL, $WS_HSCROLL, $ES_AUTOVSCROLL, $ES_AUTOHSCROLL)
Global Const $GUI_SS_DEFAULT_GRAPHIC	= 0
Global Const $GUI_SS_DEFAULT_GROUP		= 0
Global Const $GUI_SS_DEFAULT_ICON		= $SS_NOTIFY
Global Const $GUI_SS_DEFAULT_INPUT		= BitOR($ES_LEFT, $ES_AUTOHSCROLL)
Global Const $GUI_SS_DEFAULT_LABEL		= 0
Global Const $GUI_SS_DEFAULT_LIST		= BitOR($LBS_SORT, $WS_BORDER, $WS_VSCROLL, $LBS_NOTIFY)
Global Const $GUI_SS_DEFAULT_LISTVIEW	= BitOR($LVS_SHOWSELALWAYS, $LVS_SINGLESEL)
Global Const $GUI_SS_DEFAULT_MONTHCAL	= 0
Global Const $GUI_SS_DEFAULT_PIC		= $SS_NOTIFY
Global Const $GUI_SS_DEFAULT_PROGRESS	= 0
Global Const $GUI_SS_DEFAULT_RADIO		= 0
Global Const $GUI_SS_DEFAULT_SLIDER		= $TBS_AUTOTICKS
Global Const $GUI_SS_DEFAULT_TAB		= 0
Global Const $GUI_SS_DEFAULT_TREEVIEW	= BitOR($TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_DISABLEDRAGDROP, $TVS_SHOWSELALWAYS)
Global Const $GUI_SS_DEFAULT_UPDOWN		= $UDS_ALIGNRIGHT
Global Const $GUI_SS_DEFAULT_GUI		= BitOR($WS_MINIMIZEBOX, $WS_CAPTION, $WS_POPUP, $WS_SYSMENU)

; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Program Files\AutoIt3\beta\Include\GUIDefaultConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Program Files\AutoIt3\beta\Include\GUIConstantsEx.au3>
; ----------------------------------------------------------------------------


; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1 (beta)
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
Global Const $GUI_EVENT_RESIZED			= -12
Global Const $GUI_EVENT_DROPPED			= -13

Global Const $GUI_RUNDEFMSG				= 'GUI_RUNDEFMSG'

; State
Global Const $GUI_AVISTOP		= 0
Global Const $GUI_AVISTART		= 1
Global Const $GUI_AVICLOSE		= 2

Global Const $GUI_CHECKED		= 1
Global Const $GUI_INDETERMINATE	= 2
Global Const $GUI_UNCHECKED		= 4

Global Const $GUI_DROPACCEPTED	= 8
Global Const $GUI_ACCEPTFILES	= $GUI_DROPACCEPTED	; to be suppressed

Global Const $GUI_SHOW			= 16
Global Const $GUI_HIDE 			= 32
Global Const $GUI_ENABLE		= 64
Global Const $GUI_DISABLE		= 128

Global Const $GUI_FOCUS			= 256
Global Const $GUI_DEFBUTTON		= 512

Global Const $GUI_EXPAND		= 1024
Global Const $GUI_ONTOP			= 2048


; Font
Global Const $GUI_FONTITALIC	= 2
Global Const $GUI_FONTUNDER		= 4
Global Const $GUI_FONTSTRIKE	= 8


; Resizing
Global Const $GUI_DOCKAUTO			= 0x0001
Global Const $GUI_DOCKLEFT			= 0x0002
Global Const $GUI_DOCKRIGHT			= 0x0004
Global Const $GUI_DOCKHCENTER		= 0x0008
Global Const $GUI_DOCKTOP			= 0x0020
Global Const $GUI_DOCKBOTTOM		= 0x0040
Global Const $GUI_DOCKVCENTER		= 0x0080
Global Const $GUI_DOCKWIDTH			= 0x0100
Global Const $GUI_DOCKHEIGHT		= 0x0200

Global Const $GUI_DOCKSIZE			= 0x0300	; width+height
Global Const $GUI_DOCKMENUBAR		= 0x0220	; top+height
Global Const $GUI_DOCKSTATEBAR		= 0x0240	; bottom+height
Global Const $GUI_DOCKALL			= 0x0322	; left+top+width+height
Global Const $GUI_DOCKBORDERS		= 0x0066	; left+top+right+bottom

; Graphic
Global Const $GUI_GR_CLOSE		= 1
Global Const $GUI_GR_LINE		= 2
Global Const $GUI_GR_BEZIER		= 4
Global Const $GUI_GR_MOVE		= 6
Global Const $GUI_GR_COLOR		= 8
Global Const $GUI_GR_RECT		= 10
Global Const $GUI_GR_ELLIPSE	= 12
Global Const $GUI_GR_PIE		= 14
Global Const $GUI_GR_DOT		= 16
Global Const $GUI_GR_PIXEL		= 18
Global Const $GUI_GR_HINT		= 20
Global Const $GUI_GR_REFRESH	= 22
Global Const $GUI_GR_PENSIZE	= 24
Global Const $GUI_GR_NOBKCOLOR	= -2

; Background color special flags
Global Const $GUI_BKCOLOR_DEFAULT = -1
Global Const $GUI_BKCOLOR_TRANSPARENT = -2

; Other
Global Const $GUI_WS_EX_PARENTDRAG =      0x00100000

; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Program Files\AutoIt3\beta\Include\GUIConstantsEx.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Program Files\AutoIt3\beta\Include\WindowsConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Program Files\AutoIt3\beta\Include\WindowsConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Program Files\AutoIt3\beta\Include\ComboConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Program Files\AutoIt3\beta\Include\ComboConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Program Files\AutoIt3\beta\Include\ListViewConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Program Files\AutoIt3\beta\Include\ListViewConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Program Files\AutoIt3\beta\Include\StaticConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Program Files\AutoIt3\beta\Include\StaticConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Program Files\AutoIt3\beta\Include\ButtonConstants.au3>
; ----------------------------------------------------------------------------


; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1 (beta)
; Language:       English
; Description:    Button (Group, Radio, Checkbox, Button) Constants.
;
; ------------------------------------------------------------------------------

; Group
Global Const $BS_GROUPBOX		= 0x0007

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

; Checkbox
Global Const $BS_3STATE			= 0x0005
Global Const $BS_AUTO3STATE		= 0x0006
Global Const $BS_AUTOCHECKBOX	= 0x0003
Global Const $BS_CHECKBOX		= 0x0002

; Radio
Global Const $BS_AUTORADIOBUTTON	= 0x0009

; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Program Files\AutoIt3\beta\Include\ButtonConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Program Files\AutoIt3\beta\Include\ListBoxConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Program Files\AutoIt3\beta\Include\ListBoxConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Program Files\AutoIt3\beta\Include\TabConstants.au3>
; ----------------------------------------------------------------------------


; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1 (beta)
; Language:       English
; Description:    Tab Constants.
;
; ------------------------------------------------------------------------------
; Styles
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

; Tab Extended Styles
Global Const $TCS_EX_FLATSEPARATORS 	= 0x1
;Global Const $TCS_EX_REGISTERDROP 		= 0x2

; Error checking
Global Const $TC_ERR = -1

; event(s)
Global Const $TCIS_BUTTONPRESSED = 0x1

; extended styles
;~ Global Const $TCS_EX_FLATSEPARATORS = 0x1
Global Const $TCS_EX_REGISTERDROP = 0x2

; Messages to send to Tab control
Global Const $TCM_FIRST = 0x1300
Global Const $TCM_DELETEALLITEMS = ($TCM_FIRST + 9)
Global Const $TCM_DELETEITEM = ($TCM_FIRST + 8)
Global Const $TCM_DESELECTALL = ($TCM_FIRST + 50)
Global Const $TCM_GETCURFOCUS = ($TCM_FIRST + 47)
Global Const $TCM_GETCURSEL = ($TCM_FIRST + 11)
Global Const $TCM_GETEXTENDEDSTYLE = ($TCM_FIRST + 53)
Global Const $TCM_GETITEMCOUNT = ($TCM_FIRST + 4)
Global Const $TCM_GETITEMRECT = ($TCM_FIRST + 10)
Global Const $TCM_GETROWCOUNT = ($TCM_FIRST + 44)
Global Const $TCM_SETITEMSIZE = $TCM_FIRST + 41

Global Const $TCCM_FIRST = 0X2000
Global Const $TCCM_GETUNICODEFORMAT = ($TCCM_FIRST + 6)
Global Const $TCM_GETUNICODEFORMAT = $TCCM_GETUNICODEFORMAT

Global Const $TCM_HIGHLIGHTITEM = ($TCM_FIRST + 51)
Global Const $TCM_SETCURFOCUS = ($TCM_FIRST + 48)
Global Const $TCM_SETCURSEL = ($TCM_FIRST + 12)
Global Const $TCM_SETMINTABWIDTH = ($TCM_FIRST + 49)
Global Const $TCM_SETPADDING = ($TCM_FIRST + 43)

Global Const $TCCM_SETUNICODEFORMAT = ($TCCM_FIRST + 5)
Global Const $TCM_SETUNICODEFORMAT = $TCCM_SETUNICODEFORMAT

Global Const $TCN_FIRST = -550
Global Const $TCN_SELCHANGE = ($TCN_FIRST - 1)
Global Const $TCN_SELCHANGING = ($TCN_FIRST - 2)

; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Program Files\AutoIt3\beta\Include\TabConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Program Files\AutoIt3\beta\Include\EditConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Program Files\AutoIt3\beta\Include\EditConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Program Files\AutoIt3\beta\Include\DateTimeConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Program Files\AutoIt3\beta\Include\DateTimeConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Program Files\AutoIt3\beta\Include\SliderConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Program Files\AutoIt3\beta\Include\SliderConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Program Files\AutoIt3\beta\Include\TreeViewConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Program Files\AutoIt3\beta\Include\TreeViewConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Program Files\AutoIt3\beta\Include\ProgressConstants.au3>
; ----------------------------------------------------------------------------


; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1 (beta)
; Language:       English
; Description:    Progress Constants.
;
; ------------------------------------------------------------------------------

; Styles
Global Const $PBS_SMOOTH	= 1
Global Const $PBS_VERTICAL	= 4

; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Program Files\AutoIt3\beta\Include\ProgressConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Program Files\AutoIt3\beta\Include\AVIConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Program Files\AutoIt3\beta\Include\AVIConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Program Files\AutoIt3\beta\Include\UpDownConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Program Files\AutoIt3\beta\Include\UpDownConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Program Files\AutoIt3\beta\Include\GUIConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Program Files\AutoIt3\beta\Include\GuiList.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Program Files\AutoIt3\beta\Include\ListBoxConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Program Files\AutoIt3\beta\Include\ListBoxConstants.au3>
; ----------------------------------------------------------------------------

; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1++
; Language:       English
; Description:    Functions that assist with Listbox.
;
; ------------------------------------------------------------------------------

; function list
;===============================================================================
; _GUICtrlListAddDir
; _GUICtrlListAddItem
; _GUICtrlListClear
; _GUICtrlListCount
; _GUICtrlListDeleteItem
; _GUICtrlListFindString
; _GUICtrlListGetAnchorIndex
; _GUICtrlListGetCaretIndex
; _GUICtrlListGetHorizontalExtent
; _GUICtrlListGetInfo
; _GUICtrlListGetLocale
; _GUICtrlListGetSelCount
; _GUICtrlListGetSelItems
; _GUICtrlListGetSelItemsText
; _GUICtrlListGetSelState
; _GUICtrlListGetText
; _GUICtrlListGetTextLen
; _GUICtrlListGetTopIndex
; _GUICtrlListInsertItem
; _GUICtrlListReplaceString
; _GUICtrlListSelectedIndex
; _GUICtrlListSelectString
; _GUICtrlListSelItemRange
; _GUICtrlListSelItemRangeEx
; _GUICtrlListSetAnchorIndex
; _GUICtrlListSetCaretIndex
; _GUICtrlListSetHorizontalExtent
; _GUICtrlListSetLocale
; _GUICtrlListSetSel
; _GUICtrlListSetTopIndex
; _GUICtrlListSort
; _GUICtrlListSwapString
;
; ************** TODO ******************
; _GUICtrlListAddFile
;===============================================================================

;===============================================================================
;
; Description:			_GUICtrlListAddDir
; Parameter(s):		$h_listbox - controlID
;							$s_Attributes - Comma-delimited string
;							$s_file - Optional for "Drives" only: what to get i.e *.*
; Requirement:			None
; Return Value(s):	zero-based index of the last name added to the list
;							If an error occurs, the return value is $LB_ERR.
;							If there is insufficient space to store the new strings, the return value is $LB_ERRSPACE
; User CallTip:		_GUICtrlListAddDir($h_listbox, $s_Attributes[, $s_file=""]) Add names to the list displayed by the list box (required: <GuiList.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
;                    CyberSlug
; Note(s):				$s_Attributes is an comma-delimited string
; 							valid values are any of the following:
; 								A,D,H,RO,RW,S,E,Drives,NB
;							A = ARCHIVE
;								Includes archived files.
;							D = DIRECTORY
;								Includes subdirectories. Subdirectory names are enclosed in square brackets ([ ]).
;							H = HIDDEN
;								Includes hidden files.
;							RO = READONLY
;								Includes read-only files.
;							RW = READWRITE
;								Includes read-write files with no additional attributes. This is the default setting.
;							S = SYSTEM
;								Includes system files.
;							E = EXCLUSIVE
;								Includes only files with the specified attributes. By default, read-write files are listed even if READWRITE is not specified.
;							DRIVES
;								All mapped drives are added to the list. Drives are listed in the form [-x-], where x is the drive letter.
;							NB = No Brackets
;							   Drives are liste in the form x:, where x is the drive letter (used with Drives attribute)
;
;===============================================================================
Func _GUICtrlListAddDir($h_listbox, $s_Attributes, $s_file = "")
   Local $i, $v_Attributes = "", $i_drives = 0, $no_brackets = 0, $v_ret
   Local $a_Attributes = StringSplit($s_Attributes, ",")
   For $i = 1 To $a_Attributes[0]
      Select
         Case StringUpper($a_Attributes[$i]) = "A"
            If (StringLen($v_Attributes) > 0) Then
               $v_Attributes = $v_Attributes + $DDL_ARCHIVE
            Else
               $v_Attributes = $DDL_ARCHIVE
            EndIf
         Case StringUpper($a_Attributes[$i]) = "D"
            If (StringLen($v_Attributes) > 0) Then
               $v_Attributes = $v_Attributes + $DDL_DIRECTORY
            Else
               $v_Attributes = $DDL_DIRECTORY
            EndIf
         Case StringUpper($a_Attributes[$i]) = "H"
            If (StringLen($v_Attributes) > 0) Then
               $v_Attributes = $v_Attributes + $DDL_HIDDEN
            Else
               $v_Attributes = $DDL_HIDDEN
            EndIf
         Case StringUpper($a_Attributes[$i]) = "RO"
            If (StringLen($v_Attributes) > 0) Then
               $v_Attributes = $v_Attributes + $DDL_READONLY
            Else
               $v_Attributes = $DDL_READONLY
            EndIf
         Case StringUpper($a_Attributes[$i]) = "RW"
            If (StringLen($v_Attributes) > 0) Then
               $v_Attributes = $v_Attributes + $DDL_READWRITE
            Else
               $v_Attributes = $DDL_READWRITE
            EndIf
         Case StringUpper($a_Attributes[$i]) = "S"
            If (StringLen($v_Attributes) > 0) Then
               $v_Attributes = $v_Attributes + $DDL_SYSTEM
            Else
               $v_Attributes = $DDL_SYSTEM
            EndIf
         Case StringUpper($a_Attributes[$i]) = "DRIVES"
            $i_drives = 1
            $s_file = ""
            If (StringLen($v_Attributes) > 0) Then
               $v_Attributes = $v_Attributes + $DDL_DRIVES
            Else
               $v_Attributes = $DDL_DRIVES
            EndIf
         Case StringUpper($a_Attributes[$i]) = "E"
            If (StringLen($v_Attributes) > 0) Then
               $v_Attributes = $v_Attributes + $DDL_EXCLUSIVE
            Else
               $v_Attributes = $DDL_EXCLUSIVE
            EndIf
			Case StringUpper($a_Attributes[$i]) = "NB"
				If (StringLen($v_Attributes) > 0) And StringInStr($s_Attributes,"DRIVES") Then
					$no_brackets = 1
				Else
					$no_brackets = 0
				EndIf
         Case Else
            ; invalid attribute
            Return $LB_ERRATTRIBUTE
      EndSelect
   Next
   If (Not $i_drives And StringLen($s_file) == 0) Then
      Return $LB_ERRREQUIRED
   EndIf
	If $i_drives And $no_brackets Then
		Local $s_text
		Local $gui_no_brackets = GUICreate("no brackets")
		Local $list_no_brackets = GUICtrlCreateList("", 240, 40, 120, 120)
		$v_ret = GUICtrlSendMsg($list_no_brackets, $LB_DIR, $v_Attributes, $s_file)
		For $i = 0 To _GUICtrlListCount($list_no_brackets) - 1
			$s_text = _GUICtrlListGetText($list_no_brackets,$i)
			$s_text = StringReplace(StringReplace(StringReplace($s_text,"[",""),"]",":"),"-","")
			_GUICtrlListInsertItem($h_listbox,$s_text)
		Next
		GUIDelete($gui_no_brackets)
		Return $v_ret
	Else
   If IsHWnd($h_listbox) Then
			$v_ret = DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_listbox, "int", $LB_DIR, "int", $v_Attributes, "str", $s_file)
			Return $v_ret[0]
   Else
      Return GUICtrlSendMsg($h_listbox, $LB_DIR, $v_Attributes, $s_file)
   EndIf
	EndIf
EndFunc   ;==>_GUICtrlListAddDir

;===============================================================================
;
; Description:			_GUICtrlListAddItem
; Parameter(s):		$h_listbox - controlID
;							$s_text - string to add
; Requirement:			None
; Return Value(s):	The return value is the zero-based index of the string in
;							the list box. If an error occurs, the return value is $LB_ERR.
;							If there is insufficient space to store the new string,
;							the return value is $LB_ERRSPACE.
; User CallTip:		_GUICtrlListAddItem($h_listbox, $s_text) Add an item to the List (required: <GuiList.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				If the list box does not have the LBS_SORT style, the string is added to the
; 							end of the list. Otherwise, the string is inserted into the list and the list
; 							is sorted.
;
;===============================================================================
Func _GUICtrlListAddItem($h_listbox, $s_text)
   If IsHWnd($h_listbox) Then
      Local $a_ret = DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_listbox, "int", $LB_ADDSTRING, "int", 0, "str", $s_text)
      Return $a_ret[0]
   Else
      Return GUICtrlSendMsg($h_listbox, $LB_ADDSTRING, 0, $s_text)
   EndIf
EndFunc   ;==>_GUICtrlListAddItem

;===============================================================================
;
; Description:			_GUICtrlListClear
; Parameter(s):		$h_listbox - controlID
; Requirement:			None
; Return Value(s):	None
; User CallTip:		_GUICtrlListClear($h_listbox) remove all items from the list box (required: <GuiList.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				None
;
;===============================================================================
Func _GUICtrlListClear($h_listbox)
   If IsHWnd($h_listbox) Then
      DllCall("user32.dll", "none", "SendMessage", "hwnd", $h_listbox, "int", $LB_RESETCONTENT, "int", 0, "int", 0)
   Else
      GUICtrlSendMsg($h_listbox, $LB_RESETCONTENT, 0, 0)
   EndIf
EndFunc   ;==>_GUICtrlListClear

;===============================================================================
;
; Description:			_GUICtrlListCount
; Parameter(s):		$h_listbox - controlID
; Requirement:			None
; Return Value(s):	The return value is the number of items in the list box
;							or $LB_ERR if an error occurs
; User CallTip:		_GUICtrlListCount($h_listbox) return the number of items in the list box (required: <GuiList.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				None
;
;===============================================================================
Func _GUICtrlListCount($h_listbox)
   If IsHWnd($h_listbox) Then
      Local $a_ret = DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_listbox, "int", $LB_GETCOUNT, "int", 0, "int", 0)
      Return $a_ret[0]
   Else
      Return GUICtrlSendMsg($h_listbox, $LB_GETCOUNT, 0, 0)
   EndIf
EndFunc   ;==>_GUICtrlListCount

;===============================================================================
;
; Description:			_GUICtrlListDeleteItem
; Parameter(s):		$h_listbox - controlID
;							$i_index - index of item to delete
; Requirement:			None
; Return Value(s):	The return value is a count of the strings remaining in the list.
;							The return value is $LB_ERR if the $i_index parameter specifies an
;							index greater than the number of items in the list.
; User CallTip:		_GUICtrlListDeleteItem($h_listbox, $i_index) Delete an Item from the List (required: <GuiList.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				None
;
;===============================================================================
Func _GUICtrlListDeleteItem($h_listbox, $i_index)
   If IsHWnd($h_listbox) Then
      Local $a_ret = DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_listbox, "int", $LB_DELETESTRING, "int", $i_index, "int", 0)
      Return $a_ret[0]
   Else
      Return GUICtrlSendMsg($h_listbox, $LB_DELETESTRING, $i_index, 0)
   EndIf
EndFunc   ;==>_GUICtrlListDeleteItem

;===============================================================================
;
; Description:			_GUICtrlListFindString
; Parameter(s):		$h_listbox - controlID
;							$s_search - string to search for
;							$i_exact - exact match or not
; Requirement:			None
; Return Value(s):	The return value is the index of the matching item,
;							or $LB_ERR if the search was unsuccessful.
; User CallTip:		_GUICtrlListFind($h_listbox, $s_search[, $i_exact=0]) return the index of matching item (required: <GuiList.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				find the first string in a list box that begins with the specified string.
;							if exact is specified find the first list box string that exactly matches
;                    the specified string, except that the search is not case sensitive
;===============================================================================
Func _GUICtrlListFindString($h_listbox, $s_search, $i_exact = 0)
   If IsHWnd($h_listbox) Then
      Local $a_ret
      If ($i_exact) Then
         $a_ret = DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_listbox, "int", $LB_FINDSTRINGEXACT, "int", -1, "str", $s_search)
      Else
         $a_ret = DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_listbox, "int", $LB_FINDSTRING, "int", -1, "str", $s_search)
      EndIf
      Return $a_ret[0]
   Else
      If ($i_exact) Then
         Return GUICtrlSendMsg($h_listbox, $LB_FINDSTRINGEXACT, -1, $s_search)
      Else
         Return GUICtrlSendMsg($h_listbox, $LB_FINDSTRING, -1, $s_search)
      EndIf
   EndIf
EndFunc   ;==>_GUICtrlListFindString

;===============================================================================
;
; Description:			_GUICtrlListGetAnchorIndex
; Parameter(s):		$h_listbox - controlID
; Requirement:			multi-select style
; Return Value(s):	The return value is the index of the anchor item.
;							If an error occurs, the return value is $LB_ERR
; User CallTip:		_GUICtrlListGetAnchorIndex($h_listbox) Get the Anchor Idex (required: <GuiList.au3>)
; Author(s):			CyberSlug
; Note(s):				DOES NOT WORK WITH SINGLE-SELECTION LIST BOXES
;         				This might not always be the first selected item--especially
;  						if you select every other item via Ctrl+Click...
;
;===============================================================================
Func _GUICtrlListGetAnchorIndex($h_listbox)
   If IsHWnd($h_listbox) Then
      Local $a_ret = DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_listbox, "int", $LB_GETANCHORINDEX, "int", 0, "int", 0)
      Return $a_ret[0]
   Else
      Return GUICtrlSendMsg($h_listbox, $LB_GETANCHORINDEX, 0, 0)
   EndIf
EndFunc   ;==>_GUICtrlListGetAnchorIndex

;===============================================================================
;
; Description:			_GUICtrlListGetCaretIndex
; Parameter(s):		$h_listbox - controlID
; Requirement:			multi-select style
; Return Value(s):	The return value is the zero-based index of the selected list box item.
;							If nothing is selected $LB_ERR can be returned.
; User CallTip:		_GUICtrlListGetCaretIndex($h_listbox) Return index of item that has the focus rectangle (required: <GuiList.au3>)
; Author(s):			CyberSlug
; Note(s):				To determine the index of the item that has the focus rectangle in a
;							multiple-selection list box. The item may or may not be selected
;
;===============================================================================
Func _GUICtrlListGetCaretIndex($h_listbox)
   If IsHWnd($h_listbox) Then
      Local $a_ret = DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_listbox, "int", $LB_GETCARETINDEX, "int", 0, "int", 0)
      Return $a_ret[0]
   Else
      Return GUICtrlSendMsg($h_listbox, $LB_GETCARETINDEX, 0, 0)
   EndIf
EndFunc   ;==>_GUICtrlListGetCaretIndex

;===============================================================================
;
; Description:			_GUICtrlListGetHorizontalExtent
; Parameter(s):		$h_listbox - controlID
; Requirement:			None.
; Return Value(s):	The return value is the scrollable width, in pixels, of the list box.
; User CallTip:		_GUICtrlListGetHorizontalExtent($h_listbox) Retrieve from a list box the the scrollable width (required: <GuiList.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				To respond to the $LB_GETHORIZONTALEXTENT message,
;							the list box must have been defined with the $WS_HSCROLL style.
;
;===============================================================================
Func _GUICtrlListGetHorizontalExtent($h_listbox)
   If IsHWnd($h_listbox) Then
      Local $a_ret = DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_listbox, "int", $LB_GETHORIZONTALEXTENT, "int", 0, "int", 0)
      Return $a_ret[0]
   Else
      Return GUICtrlSendMsg($h_listbox, $LB_GETHORIZONTALEXTENT, 0, 0)
   EndIf
EndFunc   ;==>_GUICtrlListGetHorizontalExtent

;===============================================================================
;
; Description:			_GUICtrlListGetInfo
; Parameter(s):		$h_listbox - controlID
; Requirement:			None.
; Return Value(s):	The return value is the number of items per column.
; User CallTip:		_GUICtrlListGetInfo($h_listbox) Retrieve the number of items per column in a specified list box. (required: <GuiList.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):
;
;===============================================================================
Func _GUICtrlListGetInfo($h_listbox)
   If IsHWnd($h_listbox) Then
      Local $a_ret = DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_listbox, "int", $LB_GETLISTBOXINFO, "int", 0, "int", 0)
      Return $a_ret[0]
   Else
      Return GUICtrlSendMsg($h_listbox, $LB_GETLISTBOXINFO, 0, 0)
   EndIf
EndFunc   ;==>_GUICtrlListGetInfo

;===============================================================================
;
; Description:			_GUICtrlListGetItemRect
; Parameter(s):		$h_listbox - controlID
;							$i_index - Specifies the zero-based index of the item.
; Requirement:			Array containing the RECT, first element ($array[0]) contains the number of elements
;							If an error occurs, the return value is $LB_ERR.
; Return Value(s):	The return value is the number of items per column.
; User CallTip:		_GUICtrlListGetItemRect($h_listbox, $i_index) Retrieve the dimensions of the rectangle that bounds a list box item. (required: <GuiList.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				$array[1] - left
;							$array[2] - top
;							$array[3] - right
;							$array[4] - bottom
;
;===============================================================================
Func _GUICtrlListGetItemRect($h_listbox, $i_index)
   #cs
      typedef struct _RECT {
      LONG left;
      LONG top;
      LONG right;
      LONG bottom;
      } RECT, *PRECT;
   #ce
   Local $RECT = "int;int;int;int"
   Local $left = 1, $top = 2, $right = 3, $bottom = 4
   Local $p = DllStructCreate($RECT)
   If @error Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
   If IsHWnd($h_listbox) Then
      Local $a_ret = DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_listbox, "int", $LB_GETITEMRECT, "int", $i_index, "ptr", DllStructGetPtr($p))
      If ($a_ret[0] == $LB_ERR) Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
   Else
      Local $i_ret = GUICtrlSendMsg($h_listbox, $LB_GETITEMRECT, $i_index, DllStructGetPtr($p))
      If ($i_ret == $LB_ERR) Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
   EndIf
   Local $array = StringSplit(DllStructGetData($p, $left) & "," & DllStructGetData($p, $top) & "," & DllStructGetData($p, $right) & "," & DllStructGetData($p, $bottom), ",")
   Return $array
EndFunc   ;==>_GUICtrlListGetItemRect

;===============================================================================
;
; Description:			_GUICtrlListGetLocale
; Parameter(s):		$h_listbox - controlID
; Requirement:			None
; Return Value(s):	Returns the current Local of the listbox
; 							same as @OSLang unless changed
; User CallTip:		_GUICtrlListGetLocale($h_listbox) current Local of the listbox (required: <GuiList.au3>)
; Author(s):			CyberSlug
; Note(s):				"0409" for U.S. English
;
;===============================================================================
Func _GUICtrlListGetLocale($h_listbox)
   If IsHWnd($h_listbox) Then
      Local $a_ret = DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_listbox, "int", $LB_GETLOCALE, "int", 0, "int", 0)
      Return Hex($a_ret[0], 4)
   Else
      Return Hex( GUICtrlSendMsg($h_listbox, $LB_GETLOCALE, 0, 0), 4)
   EndIf
EndFunc   ;==>_GUICtrlListGetLocale

;===============================================================================
;
; Description:			_GUICtrlListGetSelCount
; Parameter(s):		$h_listbox - controlID
; Requirement:			multiple-selection list box
; Return Value(s):	The return value is the count of selected items in the list box.
;							If the list box is a single-selection list box, the return value is $LB_ERR.
; User CallTip:		_GUICtrlListGetSelCount($h_listbox) Get the number of items selected (required: <GuiList.au3>)
; Author(s):			CyberSlug
; Note(s):				Retrieve the total number of selected items in a multiple-selection list box.
; 							Number of selected items (for a control with multi-select style)
;
;===============================================================================
Func _GUICtrlListGetSelCount($h_listbox)
   If IsHWnd($h_listbox) Then
      Local $a_ret = DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_listbox, "int", $LB_GETSELCOUNT, "int", 0, "int", 0)
      Return $a_ret[0]
   Else
      Return GUICtrlSendMsg($h_listbox, $LB_GETSELCOUNT, 0, 0)
   EndIf
EndFunc   ;==>_GUICtrlListGetSelCount

;===============================================================================
;
; Description:			_GUICtrlListGetSelItems
; Parameter(s):		$h_listbox - controlID
; Requirement:			multi-select style
; Return Value(s):	Array of selected items indices, first element ($array[0]) contains the number indices returned
;							If the list box is a single-selection list box, the return value is $LB_ERR.
;							If no items are selected, the return value is $LB_ERR.
; User CallTip:		_GUICtrlListGetSelItems($h_listbox) Get item indices of selected items (required: <GuiList.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):
;
;===============================================================================
Func _GUICtrlListGetSelItems($h_listbox)
   Local $num = _GUICtrlListGetSelCount($h_listbox)
   Local $i, $struct
   For $i = 1 To $num
      $struct &= "int;"
   Next
   $struct = StringTrimRight($struct, 1)
   Local $p = DllStructCreate($struct)
   If @error Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
   If IsHWnd($h_listbox) Then
      Local $a_ret = DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_listbox, "int", $LB_GETSELITEMS, "int", $num, "ptr", DllStructGetPtr($p))
      If ($a_ret[0] == $LB_ERR Or $a_ret[0] == 0) Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
   Else
      Local $i_ret = GUICtrlSendMsg($h_listbox, $LB_GETSELITEMS, $num, DllStructGetPtr($p))
      If ($i_ret == $LB_ERR Or $i_ret == 0) Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
   EndIf
   Local $array
   For $i = 1 To $num
      $array &= DllStructGetData($p, $i) & ","
   Next
   $array = StringTrimRight($array, 1)
   Local $a_items = StringSplit($array, ",")
   For $i = 1 To $a_items[0]
      $a_items[$i] = Int($a_items[$i])
   Next
   Return $a_items
EndFunc   ;==>_GUICtrlListGetSelItems

;===============================================================================
;
; Description:			_GUICtrlListGetSelItemsText
; Parameter(s):		$h_listbox - controlID
; Requirement:			multi-select style
; Return Value(s):	array of selected items text, first element ($array[0]) contains the number items returned
;							If the list box is a single-selection list box, the return value is $LB_ERR.
;							If no items are selected, the return value is $LB_ERR.
; User CallTip:		_GUICtrlListGetSelItemsText($h_listbox) Get the text of selected items (required: <GuiList.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
;                    CyberSlug
; Note(s):
;
;===============================================================================
Func _GUICtrlListGetSelItemsText($h_listbox)
   Local $i, $i_ret, $a_text
   For $i = 0 To _GUICtrlListCount($h_listbox) - 1
      $i_ret = _GUICtrlListGetSelState($h_listbox, $i)
      If ($i_ret > 0) Then
         If IsArray($a_text) Then
            ReDim $a_text[UBound($a_text) + 1]
         Else
            Local $a_text[2]
         EndIf
         $a_text[0] += 1
         $a_text[UBound($a_text) - 1] = _GUICtrlListGetText($h_listbox, $i)
      ElseIf ($i_ret == $LB_ERR) Then
          Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
      EndIf
   Next
   Return $a_text
EndFunc   ;==>_GUICtrlListGetSelItemsText

;===============================================================================
;
; Description:			_GUICtrlListGetSelState
; Parameter(s):		$h_listbox - controlID
;							$i_index - Specifies the zero-based index of the item
; Requirement:			None
; Return Value(s):	If an item is selected, the return value is greater than zero
; 							otherwise, it is zero. If an error occurs, the return value is $LB_ERR.
; User CallTip:		_GUICtrlListGetSelState($h_listbox, $i_index) Get the selection state of item (required: <GuiList.au3>)
; Author(s):			CyberSlug
; Note(s):				None
;
;===============================================================================
Func _GUICtrlListGetSelState($h_listbox, $i_index)
   If IsHWnd($h_listbox) Then
      Local $a_ret = DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_listbox, "int", $LB_GETSEL, "int", $i_index, "int", 0)
      Return $a_ret[0]
   Else
      Return GUICtrlSendMsg($h_listbox, $LB_GETSEL, $i_index, 0)
   EndIf
EndFunc   ;==>_GUICtrlListGetSelState

;===============================================================================
;
; Description:			_GUICtrlListGetText
; Parameter(s):		$h_listbox - controlID
;							$i_index - Specifies the zero-based index of the string to retrieve
; Requirement:			None
; Return Value(s):	The return value is the item string.
;							If $i_index does not specify a valid index, the return value is $LB_ERR.
; User CallTip:		_GUICtrlListGetText($h_listbox, $i_index) Returns the item (string) at the specified index (required: <GuiList.au3>)
; Author(s):			CyberSlug
; Note(s):				None
;
;===============================================================================
Func _GUICtrlListGetText($h_listbox, $i_index)
   Local $struct = DllStructCreate("char[" & _GUICtrlListGetTextLen($h_listbox, $i_index) + 1 & "]")
   Local $v_ret
   If @error Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)

   If IsHWnd($h_listbox) Then
      $v_ret = DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_listbox, "int", $LB_GETTEXT, "int", $i_index, "ptr", DllStructGetPtr($struct))
   Else
      $v_ret = GUICtrlSendMsg($h_listbox, $LB_GETTEXT, $i_index, DllStructGetPtr($struct))
   EndIf
   $v_ret = DllStructGetData($struct, 1)
   Return $v_ret
EndFunc   ;==>_GUICtrlListGetText

;===============================================================================
;
; Description:			_GUICtrlListGetTextLen
; Parameter(s):		$h_listbox - controlID
;							$i_index - Zero-based index of item
; Requirement:			None
; Return Value(s):	The return value is the length of the string
;							If the wParam parameter does not specify a valid index, the return value is $LB_ERR
; User CallTip:		_GUICtrlListGetTextLen($h_listbox, $i_index) alternative to StringLen (required: <GuiList.au3>)
; Author(s):			CyberSlug
; Note(s):				None
;
;===============================================================================
Func _GUICtrlListGetTextLen($h_listbox, $i_index)
   If IsHWnd($h_listbox) Then
      Local $a_ret = DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_listbox, "int", $LB_GETTEXTLEN, "int", $i_index, "int", 0)
      Return $a_ret[0]
   Else
      Return GUICtrlSendMsg($h_listbox, $LB_GETTEXTLEN, $i_index, 0)
   EndIf
EndFunc   ;==>_GUICtrlListGetTextLen

;===============================================================================
;
; Description:			_GUICtrlListGetTopIndex
; Parameter(s):		$h_listbox - controlID
; Requirement:			None
; Return Value(s):	The return value is the index of the first visible item in the list box.
;							If the list is empty then $LB_ERR is returned.
; User CallTip:		_GUICtrlListGetTopIndex($h_listbox) retrieve the index of the first visible item in a list (required: <GuiList.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
;                    CyberSlug
; Note(s):				Initially the item with index 0 is at the top of the list box, but if
; 							the list box contents have been scrolled another item may be at the top.
; 							Returns index of the first visible item in the list box
; 							useful since contents for a long list will scroll
;
;===============================================================================
Func _GUICtrlListGetTopIndex($h_listbox)
   If (Not _GUICtrlListCount($h_listbox)) Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
      If IsHWnd($h_listbox) Then
         Local $a_ret = DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_listbox, "int", $LB_GETTOPINDEX, "int", 0, "int", 0)
         Return $a_ret[0]
      Else
         Return GUICtrlSendMsg($h_listbox, $LB_GETTOPINDEX, 0, 0)
      EndIf
EndFunc   ;==>_GUICtrlListGetTopIndex

;===============================================================================
;
; Description:			_GUICtrlListInsertItem
; Parameter(s):		$h_listbox - controlID
;							$s_text - String to insert
;							$i_index - Optional: index to insert at
; Requirement:			None
; Return Value(s):	The return value is the index of the position at which the string was inserted.
;							If an error occurs, the return value is $LB_ERR. If there is insufficient space
;							to store the new string, the return value is $LB_ERRSPACE.
; User CallTip:		_GUICtrlListInsertItem($h_listbox, $s_text[, $i_index=-1]) insert a string into the list (required: <GuiList.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				If this parameter is –1, the string is added to the end of the list.
; 							Unlike the _GUICtrlListAddItem, this function does not cause a list
; 							with the LBS_SORT style to be sorted.
;
;===============================================================================
Func _GUICtrlListInsertItem($h_listbox, $s_text, $i_index = -1)
   If IsHWnd($h_listbox) Then
      Local $a_ret = DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_listbox, "int", $LB_INSERTSTRING, "int", $i_index, "str", $s_text)
      Return $a_ret[0]
   Else
      Return GUICtrlSendMsg($h_listbox, $LB_INSERTSTRING, $i_index, $s_text)
   EndIf
EndFunc   ;==>_GUICtrlListInsertItem

;===============================================================================
;
; Description:			_GUICtrlListReplaceString
; Parameter(s):		$h_listbox - controlID
;							$i_index - Zero-based index of the item to replace
;							$s_newString - String to replace old string
; Requirement:			None
; Return Value(s):	If an error occurs, the return value is $LB_ERR
; User CallTip:		_GUICtrlListReplaceString($h_listbox, $i_index, $s_newString) Replaces the text of an item at index (required: <GuiList.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
;                    CyberSlug
; Note(s):				None
;
;===============================================================================
Func _GUICtrlListReplaceString($h_listbox, $i_index, $s_newString)
   If (_GUICtrlListDeleteItem($h_listbox, $i_index) == $LB_ERR) Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
   If (_GUICtrlListInsertItem($h_listbox, $s_newString, $i_index) == $LB_ERR) Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
EndFunc   ;==>_GUICtrlListReplaceString

;===============================================================================
;
; Description:			_GUICtrlListSelectIndex
; Parameter(s):		$h_listbox - controlID
;							$i_index - Specifies the zero-based index of the list box item
; Requirement:
; Return Value(s):	If an error occurs, the return value is $LB_ERR.
;							If the $i_index parameter is –1, the return value is $LB_ERR even though no error occurred.
; User CallTip:		_GUICtrlListSelectIndex($h_listbox, $i_index) Select a string and scroll it into view, if necessary (required: <GuiList.au3>)
; Author(s):			Sokko, Documented and Added To UDFs (Gary Frost (custompcs at charter dot net))
; Note(s):				Use this message only with single-selection list boxes.
;							You cannot use it to set or remove a selection in a multiple-selection list box.
;
;===============================================================================
Func _GUICtrlListSelectIndex($h_listbox, $i_index)
	If IsHWnd($h_listbox) Then
		Local $a_ret = DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_listbox, "int", $LB_SETCURSEL, "int", $i_index, "int", 0)
		Return $a_ret[0]
	Else
		Return GUICtrlSendMsg($h_listbox, $LB_SETCURSEL, $i_index, 0)
	EndIf
EndFunc ;==>_GUICtrlListSelectIndex

;===============================================================================
;
; Description:			_GUICtrlListSelectedIndex
; Parameter(s):		$h_listbox - controlID
; Requirement:			None
; Return Value(s):	In a single-selection list box, the return value is the zero-based
;							index of the currently selected item. If there is no selection,
;							the return value is $LB_ERR
; User CallTip:		_GUICtrlListSelectedIndex($h_listbox) return the index of selected item (required: <GuiList.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				Do not use this with a multiple-selection list box.
;
;===============================================================================
Func _GUICtrlListSelectedIndex($h_listbox)
   If IsHWnd($h_listbox) Then
      Local $a_ret = DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_listbox, "int", $LB_GETCURSEL, "int", 0, "int", 0)
      Return $a_ret[0]
   Else
      Return GUICtrlSendMsg($h_listbox, $LB_GETCURSEL, 0, 0)
   EndIf
EndFunc   ;==>_GUICtrlListSelectedIndex

;===============================================================================
;
; Description:			_GUICtrlListSelectString
; Parameter(s):		$h_listbox - controlID
;							$s_text - String to select
;							$i_index - Optional: Zero-based index of the item before the first item to be searched
; Requirement:			None
; Return Value(s):	If the search is successful, the return value is the index of the selected item.
;							If the search is unsuccessful, the return value is $LB_ERR and the current selection is not changed.
; User CallTip:		_GUICtrlListSelectString($h_listbox, $s_text[, $i_index=-1]) select item using search string (required: <GuiList.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				If $i_index is –1, the entire list box is searched from the beginning
;
;===============================================================================
Func _GUICtrlListSelectString($h_listbox, $s_search, $i_index = -1)
   If IsHWnd($h_listbox) Then
      Local $a_ret = DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_listbox, "int", $LB_SELECTSTRING, "int", $i_index, "str", $s_search)
      Return $a_ret[0]
   Else
      Return GUICtrlSendMsg($h_listbox, $LB_SELECTSTRING, $i_index, $s_search)
   EndIf
EndFunc   ;==>_GUICtrlListSelectString

;===============================================================================
;
; Description:			_GUICtrlListSelItemRange
; Parameter(s):		$h_listbox - controlID
;							$i_flag - Set/Remove select
;							$i_start - Zero-based index of the first item to select
;							$i_stop - Zero-based index of the last item to select
; Requirement:			multi-select style
; Return Value(s):	If an error occurs, the return value is $LB_ERR
; User CallTip:		_GUICtrlListSelItemRange($h_listbox, $i_flag, $i_start, $i_stop) Select range by index in a multiple-selection list box (required: <GuiList.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
;                    CyberSlug
; Note(s):				DOES NOT WORK WITH SINGLE-SELECTION LIST BOXES
; 							Select items from $i_start to $stop indices (inclusive)
;							Can select a range only within the first 65,536 items
; 							$i_flag == 1 selects
; 							$i_flag == 0 removes select
;
;===============================================================================
Func _GUICtrlListSelItemRange($h_listbox, $i_flag, $i_start, $i_stop)
   If IsHWnd($h_listbox) Then
      Local $a_ret = DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_listbox, "int", $LB_SELITEMRANGE, "int", $i_flag, "int", $i_stop * 65536 + $i_start)
      Return $a_ret[0]
   Else
      Return GUICtrlSendMsg($h_listbox, $LB_SELITEMRANGE, $i_flag, $i_stop * 65536 + $i_start)
   EndIf
EndFunc   ;==>_GUICtrlListSelItemRange

;===============================================================================
;
; Description:			_GUICtrlListSelItemRangeEx
; Parameter(s):		$h_listbox - controlID
;							$i_start - Zero-based index of the first item to select
;							$i_stop - Zero-based index of the last item to select
; Requirement:			multi-select style
; Return Value(s):	If an error occurs, the return value is $LB_ERR
; User CallTip:		_GUICtrlListSelItemRangeEx($h_listbox, $i_start, $i_stop) Selects items from $i_start to $i_stop (required: <GuiList.au3>)
; Author(s):			CyberSlug
; Note(s):				DOES NOT WORK WITH SINGLE-SELECTION LIST BOXES
;  						If $i_start > $i_stop Then items are un-selected
;
;===============================================================================
Func _GUICtrlListSelItemRangeEx($h_listbox, $i_start, $i_stop)
   If IsHWnd($h_listbox) Then
      Local $a_ret = DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_listbox, "int", $LB_SELITEMRANGEEX, "int", $i_start, "int", $i_stop)
      Return $a_ret[0]
   Else
      Return GUICtrlSendMsg($h_listbox, $LB_SELITEMRANGEEX, $i_start, $i_stop)
   EndIf
EndFunc   ;==>_GUICtrlListSelItemRangeEx

;===============================================================================
;
; Description:			_GUICtrlListSetAnchorIndex
; Parameter(s):		$h_listbox - controlID
;							$i_index - Specifies the index of the new anchor item.
; Requirement:			multi-select style
; Return Value(s):	If the message succeeds, the return value is zero.
;							If the message fails, the return value is $LB_ERR.
; User CallTip:		_GUICtrlListSetAnchorIndex($h_listbox, $i_index) Set the Anchor Idex (required: <GuiList.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				DOES NOT WORK WITH SINGLE-SELECTION LIST BOXES
;
;===============================================================================
Func _GUICtrlListSetAnchorIndex($h_listbox, $i_index)
   If IsHWnd($h_listbox) Then
      Local $a_ret = DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_listbox, "int", $LB_SETANCHORINDEX, "int", $i_index, "int", 0)
      Return $a_ret[0]
   Else
      Return GUICtrlSendMsg($h_listbox, $LB_SETANCHORINDEX, $i_index, 0)
   EndIf
EndFunc   ;==>_GUICtrlListSetAnchorIndex

;===============================================================================
;
; Description:			_GUICtrlListGetCaretIndex
; Parameter(s):		$h_listbox - controlID
;							$i_index - Specifies the zero-based index of the list box item that is to receive the focus rectangle.
;							$i_bool - Optional: If this value is FALSE, the item is scrolled until it is fully visible; if it is TRUE, the item is scrolled until it is at least partially visible.
; Requirement:			multi-select style
; Return Value(s):	The return value is the zero-based index of the selected list box item.
;							If nothing is selected $LB_ERR can be returned.
; User CallTip:		_GUICtrlListSetCaretIndex($h_listbox, $i_index[, $i_bool=1]) Set the focus rectangle to the item at the specified index (required: <GuiList.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				DOES NOT WORK WITH SINGLE-SELECTION LIST BOXES
;
;===============================================================================
Func _GUICtrlListSetCaretIndex($h_listbox, $i_index, $i_bool = 1)
   If IsHWnd($h_listbox) Then
      Local $a_ret = DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_listbox, "int", $LB_SETCARETINDEX, "int", $i_index, "int", $i_bool)
      Return $a_ret[0]
   Else
      Return GUICtrlSendMsg($h_listbox, $LB_SETCARETINDEX, $i_index, $i_bool)
   EndIf
EndFunc   ;==>_GUICtrlListSetCaretIndex

;===============================================================================
;
; Description:			_GUICtrlListSetHorizontalExtent
; Parameter(s):		$h_listbox - controlID
;							$i_pixels - Specifies the number of pixels by which the list box can be scrolled.
; Requirement:			None.
; Return Value(s):	None.
; User CallTip:		_GUICtrlListSetHorizontalExtent($h_listbox, $i_num) Set the width, in pixels, by which a list box can be scrolled horizontally (required: <GuiList.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				To respond to the $LB_SETHORIZONTALEXTENT message,
;							the list box must have been defined with the $WS_HSCROLL style.
;
;===============================================================================
Func _GUICtrlListSetHorizontalExtent($h_listbox, $i_pixels)
   If IsHWnd($h_listbox) Then
      DllCall("user32.dll", "none", "SendMessage", "hwnd", $h_listbox, "int", $LB_SETHORIZONTALEXTENT, "int", $i_pixels, "int", 0)
   Else
      GUICtrlSendMsg($h_listbox, $LB_SETHORIZONTALEXTENT, $i_pixels, 0)
   EndIf
EndFunc   ;==>_GUICtrlListSetHorizontalExtent

;===============================================================================
;
; Description:			_GUICtrlListSetLocale
; Parameter(s):		$h_listbox - controlID
;							$s_locale - locale
; Requirement:			None
; Return Value(s):	Returns previous locale or $LB_ERR
; User CallTip:		_GUICtrlListSetLocale($h_listbox, $s_locale) Set the locale (required: <GuiList.au3>)
; Author(s):			CyberSlug
; Note(s):				"0409" for U.S. English
;							see @OSLang for string values
;
;===============================================================================
Func _GUICtrlListSetLocale($h_listbox, $s_locale)
   If IsHWnd($h_listbox) Then
      Local $a_ret = DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_listbox, "int", $LB_SETLOCALE, "int", Dec($s_locale), "int", 0)
      Return Hex($a_ret[0], 4)
   Else
      Return Hex( GUICtrlSendMsg($h_listbox, $LB_SETLOCALE, Dec($s_locale), 0), 4)
   EndIf
EndFunc   ;==>_GUICtrlListSetLocale

;===============================================================================
;
; Description:			_GUICtrlListSetSel
; Parameter(s):		$h_listbox - controlID
;							$i_flag - Optional: Select/UnSelect
;							$i_index - Optional: Specifies the zero-based index of the item
; Requirement:			multi-select style
; Return Value(s):	If an error occurs, the return value is $LB_ERR
; User CallTip:		_GUICtrlListSetSel($h_listbox [, $i_flag] , $i_index]]) Select string(s) in a multiple-selection list box (required: <GuiList.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
;                    CyberSlug
; Note(s):				DOES NOT WORK WITH SINGLE-SELECTION LIST BOXES
; 							$i_flag == 0 means unselect
; 							$i_flag == 1 means select
;							$i_flag == -1 means toggle select/unselect of item
; 							An $i_index of -1 means to toggle select/unselect of all items (ignores the $i_flag).
;
;===============================================================================
Func _GUICtrlListSetSel($h_listbox, $i_flag = -1, $i_index = -1)
   If IsHWnd($h_listbox) Then
      Local $v_ret
      If $i_index == -1 Then ; toggle all
         For $i_index = 0 To _GUICtrlListCount($h_listbox) - 1
            $v_ret = _GUICtrlListGetSelState($h_listbox, $i_index)
            If ($v_ret == $LB_ERR) Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
            If ($v_ret > 0) Then ;If Selected Then
               $v_ret = DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_listbox, "int", $LB_SETSEL, "int", 0, "int", $i_index)
            Else
               $v_ret = DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_listbox, "int", $LB_SETSEL, "int", 1, "int", $i_index)
            EndIf
            If ($v_ret[0] == $LB_ERR) Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
         Next
      ElseIf $i_flag == -1 Then ; toggle state of index
         If _GUICtrlListGetSelState($h_listbox, $i_index) Then ;If Selected Then
            $v_ret = DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_listbox, "int", $LB_SETSEL, "int", 0, "int", $i_index)
         Else
            $v_ret = DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_listbox, "int", $LB_SETSEL, "int", 1, "int", $i_index)
         EndIf
         Return $v_ret[0]
      Else
         $v_ret = DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_listbox, "int", $LB_SETSEL, "int", $i_flag, "int", $i_index)
         Return $v_ret[0]
      EndIf
   Else
      Local $i_ret
      If $i_index == -1 Then ; toggle all
         For $i_index = 0 To _GUICtrlListCount($h_listbox) - 1
            $i_ret = _GUICtrlListGetSelState($h_listbox, $i_index)
            If ($i_ret == $LB_ERR) Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
            If ($i_ret > 0) Then ;If Selected Then
               $i_ret = GUICtrlSendMsg($h_listbox, $LB_SETSEL, 0, $i_index)
            Else
               $i_ret = GUICtrlSendMsg($h_listbox, $LB_SETSEL, 1, $i_index)
            EndIf
            If ($i_ret == $LB_ERR) Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
         Next
      ElseIf $i_flag == -1 Then ; toggle state of index
         If _GUICtrlListGetSelState($h_listbox, $i_index) Then ;If Selected Then
            Return GUICtrlSendMsg($h_listbox, $LB_SETSEL, 0, $i_index)
         Else
            Return GUICtrlSendMsg($h_listbox, $LB_SETSEL, 1, $i_index)
         EndIf
      Else
         Return GUICtrlSendMsg($h_listbox, $LB_SETSEL, $i_flag, $i_index)
      EndIf
   EndIf
EndFunc   ;==>_GUICtrlListSetSel

;===============================================================================
;
; Description:			_GUICtrlListSetTopIndex
; Parameter(s):		$h_listbox - controlID
;							$i_index - Specifies the zero-based index of the item
; Requirement:			None
; Return Value(s):	If an error occurs, the return value is $LB_ERR
; User CallTip:		_GUICtrlListSetTopIndex($h_listbox, $i_index) ensure that a particular item in a list box is visible (required: <GuiList.au3>)
; Author(s):			CyberSlug
; Note(s):				None
;
;===============================================================================
Func _GUICtrlListSetTopIndex($h_listbox, $i_index)
   If IsHWnd($h_listbox) Then
      Local $a_ret = DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_listbox, "int", $LB_SETTOPINDEX, "int", $i_index, "int", 0)
      Return $a_ret[0]
   Else
      Return GUICtrlSendMsg($h_listbox, $LB_SETTOPINDEX, $i_index, 0)
   EndIf
EndFunc   ;==>_GUICtrlListSetTopIndex

;===============================================================================
;
; Description:			_GUICtrlListSort
; Parameter(s):		$h_listbox - controlID
; Requirement:			None
; Return Value(s):	If an error occurs, the return value is $LB_ERR
; User CallTip:		_GUICtrlListSort($h_listbox) Re-sorts list box if it has the LBS_SORT style (required: <GuiList.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
;                    CyberSlug
; Note(s):				Re-sorts list box if it has the LBS_SORT style
;  						Might be useful if you use InsertString
;
;===============================================================================
Func _GUICtrlListSort($h_listbox)
   Local $bak = _GUICtrlListGetText($h_listbox, 0)
   If ($bak == $LB_ERR) Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
   If (_GUICtrlListDeleteItem($h_listbox, 0) == $LB_ERR) Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
   Return _GUICtrlListAddItem($h_listbox, $bak)
EndFunc   ;==>_GUICtrlListSort

;===============================================================================
;
; Description:			_GUICtrlListSwapString
; Parameter(s):		$h_listbox - controlID
;							$i_indexA - Zero-based index item to swap
;							$i_indexB - Zero-based index item to swap
; Requirement:			None
; Return Value(s):	If an error occurs, the return value is $LB_ERR
; User CallTip:		_GUICtrlListSwapString($h_listbox, $i_indexA, $i_indexB) Swaps the text of two items at the specified indices (required: <GuiList.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
;                    CyberSlug
; Note(s):				None
;
;===============================================================================
Func _GUICtrlListSwapString($h_listbox, $i_indexA, $i_indexB)
   Local $itemA = _GUICtrlListGetText($h_listbox, $i_indexA)
   Local $itemB = _GUICtrlListGetText($h_listbox, $i_indexB)
   If ($itemA == $LB_ERR Or $itemB == $LB_ERR) Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
   If (_GUICtrlListDeleteItem($h_listbox, $i_indexA) == $LB_ERR) Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
   If (_GUICtrlListInsertItem($h_listbox, $itemB, $i_indexA) == $LB_ERR) Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)

   If (_GUICtrlListDeleteItem($h_listbox, $i_indexB) == $LB_ERR) Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
   If (_GUICtrlListInsertItem($h_listbox, $itemA, $i_indexB) == $LB_ERR) Then Return SetError($LB_ERR, $LB_ERR, $LB_ERR)
EndFunc   ;==>_GUICtrlListSwapString

; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Program Files\AutoIt3\beta\Include\GuiList.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: G:\PrinterSetup\Media.au3>
; ----------------------------------------------------------------------------

;===============================================================================
;
; Function Name:    _MediaOpen()
; Description:      Opens a media file.
; Parameter(s):     $s_location     - Location of the media file
; Requirement(s):   AutoIt
; Return Value(s):  On Success - Returns Media ID needed for the other media functions
;                   On Failure - Returns 0  and sets @ERROR = 1
; Author(s):        svennie
;
;===============================================================================
Func _MediaOpen($s_location, $h_guihandle = 0)
	If Not IsDeclared("i_MediaCount") Then Global $i_MediaCount=0
	$i_MediaCount=$i_MediaCount+1
	DllCall("winmm.dll","int","mciSendString","str","open "&FileGetShortName($s_location)&" alias media"&String($i_MediaCount),"str","","int",65534,"hwnd",0)
	If @error Then
		SetError(1)
		Return 0
	Else
		Return String($i_MediaCount)
	EndIf
EndFunc
;===============================================================================
;
; Function Name:    _MediaCreate()
; Description:      Creates a new media for recording, capturing etc.
; Parameter(s):     $s_format     - Format of the file.
;                   0 = CD Audio
;                   1 = Digital video
;                   2 = Overlay
;                   3 = sequencer
;                   4 = Vcr
;                   5 = Video disc
;                   6 = Wave Audio
; Requirement(s):   AutoIt
; Return Value(s):  On Success - Returns Media ID needed for the other media functions
;                   On Failure - Returns 0 and sets @ERROR = 1
; Author(s):        svennie
;
;===============================================================================
Func _MediaCreate($s_format)
	If Not IsDeclared("i_MediaCount") Then Global $i_MediaCount=0
	$i_MediaCount=$i_MediaCount+1
	If $s_format=0 Then
		$s_Use="cdaudio"
	ElseIf $s_format=1 Then
		$s_Use="digitalvideo"
	ElseIf $s_format=2 Then
		$s_Use="overlay"
	ElseIf $s_format=3 Then
		$s_Use="sequencer"
	ElseIf $s_format=4 Then
		$s_Use="vcr"
	ElseIf $s_format=5 Then
		$s_Use="videodisc"
	ElseIf $s_format=6 Then
		$s_Use="waveaudio"
	EndIf
	DllCall("winmm.dll","int","mciSendString","str","open new type "&$s_Use&" alias media"&String($i_MediaCount),"str","","int",65534,"hwnd",0)
	If @error Then
		SetError(1)
		Return 0
	Else
		Return String($i_MediaCount)
	EndIf
EndFunc
;===============================================================================
;
; Function Name:    _MediaPlay()
; Description:      Plays a opened media file.
; Parameter(s):     $i_MediaId     - Media ID returned by _MediaOpen()/MediaCreate()
;                   [optional] $i_From        - Sets time in seconds where to begin playing
;                   [optional] $i_To          - Sets time in seconds where to bstop playing
;                   [optional] $i_Speed       - Sets the speed to play with
;                   [optional] $f_Fast        - When 1 it will play faster then normal
;                   [optional] $f_Slow        - When 1 it will play slower then normal
;                   [optional] $f_Fullscreen  - When 1 movies will play fullscreen
;                   [optional] $f_Repeat      - When 1 it will keep repeating
;                   [optional] $f_Reverse     - When 1 the movie will been played reversed
;                   [optional] $f_Scan        - When 1 plays as fast as possible
;                   The default value of all the optional parameters is 0.
;                   Some file formats dont understand some of the optional functions
;                   Experimate with it.
; Requirement(s):   AutoIt
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @ERROR = 1
; Author(s):        svennie
;
;===============================================================================
Func _MediaPlay($i_MediaId,$i_From = 0,$i_To = 0,$i_Speed = 0,$f_Fast = 0,$f_Slow = 0,$f_Fullscreen = 0,$f_Repeat=0,$f_Reverse=0,$f_Scan = 0)
	$s_Parameters=""
	If $i_From Then $s_Parameters=$s_Parameters&" from "&$i_From
	If $i_To Then $s_Parameters=$s_Parameters&" to "&$i_To
	If $i_Speed Then $s_Parameters=$s_Parameters&" speed "&$i_Speed
	If $f_Fast Then $s_Parameters=$s_Parameters&" fast"
	If $f_Fullscreen Then $s_Parameters=$s_Parameters&" fullscreen"
	If $f_Repeat Then $s_Parameters=$s_Parameters&" repeat"
	If $f_Reverse Then $s_Parameters=$s_Parameters&" reverse"
	If $f_Scan Then $s_Parameters=$s_Parameters&" scan"
	If $f_Slow Then $s_Parameters=$s_Parameters&" slow"
	DllCall("winmm.dll","int","mciSendString","str","play media"&$i_MediaId&$s_Parameters,"str","","int",65534,"hwnd",0)
	If @error Then
		SetError(1)
		Return 0
	Else
		Return 1
	EndIf
EndFunc
;===============================================================================
;
; Function Name:    _MediaRecord()
; Description:      Records from a microphone
;                   Stop recording with _MediaStop()
;                   (choose position with _MediaSeek())
; Parameter(s):     $i_MediaId     - Media ID returned by _MediaOpen()/MediaCreate()
; Requirement(s):   AutoIt
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @ERROR = 1
; Author(s):        svennie
;
;===============================================================================
Func _MediaRecord($i_MediaId)
	DllCall("winmm.dll","int","mciSendString","str","record media"&$i_MediaId,"str","","int",65534,"hwnd",0)
	If @error Then
		SetError(1)
		Return 0
	Else
		Return 1
	EndIf
EndFunc
;===============================================================================
;
; Function Name:    _MediaCut()
; Description:      Cuts a specified part of the movie to the clipboard.
; Parameter(s):     $i_MediaId     - Media ID returned by _MediaOpen()/MediaCreate()
;                   $i_From        - From time in seconds
;                   $i_To          - To time in seconds
; Requirement(s):   AutoIt
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @ERROR = 1
; Author(s):        svennie
;
;===============================================================================
Func _MediaCut($i_MediaId,$i_From,$i_To)
	DllCall("winmm.dll","int","mciSendString","str","cut media"&$i_MediaId&" from "&$i_From&" to "&$i_To,"str","","int",65534,"hwnd",0)
	If @error Then
		SetError(1)
		Return 0
	Else
		Return 1
	EndIf
EndFunc
;===============================================================================
;
; Function Name:    _MediaCopy()
; Description:      Copies a specified part of the movie to the clipboard.
; Parameter(s):     $i_MediaId     - Media ID returned by _MediaOpen()/MediaCreate()
;                   $i_From        - From time in seconds
;                   $i_To          - To time in seconds
; Requirement(s):   AutoIt
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @ERROR = 1
; Author(s):        svennie
;
;===============================================================================
Func _MediaCopy($i_MediaId,$i_From,$i_To)
	DllCall("winmm.dll","int","mciSendString","str","copy media"&$i_MediaId&" from "&$i_From&" to "&$i_To,"str","","int",65534,"hwnd",0)
	If @error Then
		SetError(1)
		Return 0
	Else
		Return 1
	EndIf
EndFunc
;===============================================================================
;
; Function Name:    _MediaPaste()
; Description:      Paste media from the clipboard.
; Parameter(s):     $i_MediaId     - Media ID returned by _MediaOpen()/MediaCreate()
; Requirement(s):   AutoIt
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @ERROR = 1
; Author(s):        svennie
;
;===============================================================================
Func _MediaPaste($i_MediaId,$i_From,$i_To)
	DllCall("winmm.dll","int","mciSendString","str","paste media"&$i_MediaId,"str","","int",65534,"hwnd",0)
	If @error Then
		SetError(1)
		Return 0
	Else
		Return 1
	EndIf
EndFunc
;===============================================================================
;
; Function Name:    _MediaDelete()
; Description:      Deletes a specified part of the movie.
; Parameter(s):     $i_MediaId     - Media ID returned by _MediaOpen()/MediaCreate()
;                   $i_From        - From time in seconds
;                   $i_To          - To time in seconds
; Requirement(s):   AutoIt
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @ERROR = 1
; Author(s):        svennie
;
;===============================================================================
Func _MediaDelete($i_MediaId,$i_From,$i_To)
	DllCall("winmm.dll","int","mciSendString","str","delete media"&$i_MediaId&" from "&$i_From&" to "&$i_To,"str","","int",65534,"hwnd",0)
	If @error Then
		SetError(1)
		Return 0
	Else
		Return 1
	EndIf
EndFunc
;===============================================================================
;
; Function Name:    _MediaCapture()
; Description:      Copies the contents of the frame buffer and stores it in the
;                   specified file.
;                   Stop recording with _MediaStop()
; Parameter(s):     $i_MediaId     - Media ID returned by _MediaOpen()/MediaCreate()
;                   $s_Location    - Location where to store the file.
; Requirement(s):   AutoIt
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @ERROR = 1
; Author(s):        svennie
;
;===============================================================================
Func _MediaCapture($i_MediaId,$s_Location)
	DllCall("winmm.dll","int","mciSendString","str","capture media"&$i_MediaId&" "&FileGetShortName($s_Location),"str","","int",65534,"hwnd",0)
	If @error Then
		SetError(1)
		Return 0
	Else
		Return 1
	EndIf
EndFunc
;===============================================================================
;
; Function Name:    _MediaStop()
; Description:      Stops playing/recording of a Media ID
; Parameter(s):     $i_MediaId     - Media ID returned by _MediaOpen()/MediaCreate()
; Requirement(s):   AutoIt
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @ERROR = 1
; Author(s):        svennie
;
;===============================================================================
Func _MediaStop($i_MediaId)
	DllCall("winmm.dll","int","mciSendString","str","stop media"&$i_MediaId,"str","","int",65534,"hwnd",0)
	If @error Then
		SetError(1)
		Return 0
	Else
		Return 1
	EndIf
EndFunc
;===============================================================================
;
; Function Name:    _MediaSeek()
; Description:      Moves to a specified Position and stops.
; Parameter(s):     $i_MediaId     - Media ID returned by _MediaOpen()/MediaCreate()
;                   $i_Position    - Position in seconds to move to, -1 goes to start
;                   -2 goes to end
; Requirement(s):   AutoIt
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @ERROR = 1
; Author(s):        svennie
;
;===============================================================================
Func _MediaSeek($i_MediaId,$i_Position)
	If $i_Position = -1 Then
		$s_Position = "end"
	ElseIf $i_Position = -2 Then
		$s_Position = "begin"
	Else
		$s_Position = String($i_Position)
	EndIf
	DllCall("winmm.dll","int","mciSendString","str","seek media"&$i_MediaId&" to "&$s_Position,"str","","int",65534,"hwnd",0)
	If @error Then
		SetError(1)
		Return 0
	Else
		Return 1
	EndIf
EndFunc
;===============================================================================
;
; Function Name:    _MediaPause()
; Description:      Pauses playing/recording of a Media ID
; Parameter(s):     $i_MediaId     - Media ID returned by _MediaOpen()/MediaCreate()
; Requirement(s):   AutoIt
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @ERROR = 1
; Author(s):        svennie
;
;===============================================================================
Func _MediaPause($i_MediaId)
	DllCall("winmm.dll","int","mciSendString","str","pause media"&$i_MediaId,"str","","int",65534,"hwnd",0)
	If @error Then
		SetError(1)
		Return 0
	Else
		Return 1
	EndIf
EndFunc
;===============================================================================
;
; Function Name:    _MediaResume()
; Description:      Resumes playing/recording of a Media ID
; Parameter(s):     $i_MediaId     - Media ID returned by _MediaOpen()/MediaCreate()
; Requirement(s):   AutoIt
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @ERROR = 1
; Author(s):        svennie
;
;===============================================================================
Func _MediaResume($i_MediaId)
	DllCall("winmm.dll","int","mciSendString","str","resume media"&$i_MediaId,"str","","int",65534,"hwnd",0)
	If @error Then
		SetError(1)
		Return 0
	Else
		Return 1
	EndIf
EndFunc
;===============================================================================
;
; Function Name:    _MediaSave()
; Description:      Saves a opened Media ID to the selected file
; Parameter(s):     $i_MediaId     - Media ID returned by _MediaOpen()/MediaCreate()
;                   $s_Location    - Location to save to (must be full path)
; Requirement(s):   AutoIt
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @ERROR = 1
; Author(s):        svennie
;
;===============================================================================
Func _MediaSave($i_MediaId,$s_Location)
	DllCall("winmm.dll","int","mciSendString","str","save media"&$i_MediaId&" "&FileGetShortName($s_Location),"str","","int",65534,"hwnd",0)
	If @error Then
		SetError(1)
		Return 0
	Else
		Return 1
	EndIf
EndFunc
;===============================================================================
;
; Function Name:    _MediaClose()
; Description:      Closes a existing Media ID
; Parameter(s):     $i_MediaId     - Media ID returned by _MediaOpen()/MediaCreate()
; Requirement(s):   AutoIt
; Return Value(s):  On Success - Returns 1
;                   On Failure - Returns 0 and sets @ERROR = 1
; Author(s):        svennie
;
;===============================================================================
Func _MediaClose($i_MediaId)
	DllCall("winmm.dll","int","mciSendString","str","close media"&$i_MediaId,"str","","int",65534,"hwnd",0)
	If @error Then
		SetError(1)
		Return 0
	Else
		Return 1
	EndIf
EndFunc

; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: G:\PrinterSetup\Media.au3>
; ----------------------------------------------------------------------------




run("Regsvr32 prnadmin.dll")
while Not WinExists("RegSvr32")
WEnd
WinActivate("RegSvr32")
ControlClick("RegSvr32","" , "Button1")

#Region ### START Koda GUI section ### Form=h:\software\printersetup\printersetup\aform1.kxf
$Form1_1 = GUICreate("Printer Install", 633, 454)
$Label1 = GUICtrlCreateLabel("A4e Printer Install", 32, 32, 138, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$Label2 = GUICtrlCreateLabel("What Should We Name The Printer", 40, 96, 172, 17)
$printerName = GUICtrlCreateInput("", 40, 112, 121, 21)
$Go = GUICtrlCreateButton("Go!!!!!", 512, 400, 75, 25, 0)
$Label3 = GUICtrlCreateLabel("Name of Printer Inside Driver", 40, 144, 139, 17)
$driverName = GUICtrlCreateInput("", 40, 160, 121, 21)
$Label4 = GUICtrlCreateLabel("Printer IP Address", 40, 240, 88, 17)
$ipAddr = GUICtrlCreateInput("", 40, 256, 121, 21)
$Label5 = GUICtrlCreateLabel("Driver Location", 40, 192, 76, 17)
$driverLoc = GUICtrlCreateInput("", 40, 208, 121, 21)
$loadDriver = GUICtrlCreateButton("Browse", 165, 206, 75, 25, 0)
$List1 = GUICtrlCreateList("", 296, 48, 265, 279) ;List of Computers
$delOne = GUICtrlCreateButton("Delete Computer", 392, 336, 91, 25, 0)
$delAll = GUICtrlCreateButton("Delete All", 488, 336, 75, 25, 0)
$add = GUICtrlCreateButton("Add Computer(s)", 296, 336, 91, 25, 0)
$saveList = GUICtrlCreateButton("Save Computer List", 296, 376, 139, 25, 0)
$savePrint = GUICtrlCreateButton("Save Printer", 56, 304, 75, 25, 0)
$loadList = GUICtrlCreateButton("Load Computer List", 296, 416, 139, 25, 0)
$loadPrint = GUICtrlCreateButton("Load Printer", 56, 336, 75, 25, 0)
$notestPage = GUICtrlCreateRadio ( "Print No Test Pages", 20, 370, 150)
$testPage = GUICtrlCreateRadio ( "Print One Test Page", 20, 400,150)
$alltestPage = GUICtrlCreateRadio ( "Print Test Pages For All", 20, 430,150)

GUICtrlSetState ( $notestPage, $GUI_CHECKED )

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

$nMsg = 0

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

		Case $add ;add Computers
			addComp()

		Case $delOne ;Delete Selected Computer
			deleteOne()

		Case $delAll ;Delete All Computers
			deleteComputers()

		Case $saveList ;Save Computer List
			saveList()

		Case $loadList ;Load Computer List
			loadList()

		Case $savePrint ;save printer
			savePrinter()

		Case $loadPrint ;load Printer
			loadPrinter()

		Case $loadDriver ;load Printer
			loadDriver()

		Case $Go ;Go!!!!
			go()

	EndSwitch
WEnd

Func go()
	$progressGui = GUICreate("Progress", 321, 149)
	$progresBar = GUICtrlCreateProgress(8, 64, 302, 33)
	GUICtrlSetData(-1,0)
	$progress = GUICtrlCreateLabel("Working", 8, 24, 190)
	GUISetState(@SW_SHOW, $progressGui)
	GUISwitch ($progressGui)

	;Progress Bar Increment Variable!
	if GUICtrlRead($alltestPage) == $GUI_CHECKED Then
		$increment = (((1/_GUICtrlListCount($List1))/6)*100)
	Else
		$increment = (((1/_GUICtrlListCount($List1))/5)*100)
	EndIf


	$pos = StringInStr(GUICtrlRead($driverLoc), "\", 0, -1)
	$driverDir = StringLeft(GUICtrlRead($driverLoc), $pos-1)
	$errors=0
	$printed=0
	$printed=0

	For $i = 0 to _GUICtrlListCount($List1) -1

		#cs
		$ip = _GUICtrlListGetText($List1, $i)
		$p = ping ($ip&".wshs.fcps.edu")
		If $p == 0 Then
			$errors += 1
			FileWriteLine(@ScriptDir&"\ErrorLog.txt", " - Computer name "&$ip&" not found.")
			GUICtrlSetData($progresBar,  (((1/_GUICtrlListCount($List1)))*100) + GUICtrlRead($progresBar))
			ContinueLoop
		EndIf
		#ce

		$serverName = "\\" & _GUICtrlListGetText($List1, $i)

		GUICtrlSetData($progress,"Deleting Printers From " & _GUICtrlListGetText($List1, $i))

		;create objects
		$oMaster = ObjCreate("PrintMaster.PrintMaster.1")
		$oPrinter = ObjCreate("Printer.Printer.1")


		;Delete All Remote Printers!!!
		for $oPrinter in $oMaster.Printers($serverName)
			$oMaster.PrinterDel( $oPrinter)
		next

		GUICtrlSetData($progresBar,  $increment + GUICtrlRead($progresBar))

		GUICtrlSetData($progress,"Deleting Printer Ports From " & $serverName)

		;delete remote printer ports
		$oPort = ObjCreate("Port.Port.1")
		for $oPort in $oMaster.Ports($serverName)
			$oMaster.PortDel($oPort)
		next

		GUICtrlSetData($progresBar,  $increment + GUICtrlRead($progresBar))


		GUICtrlSetData($progress,"Adding Port To  " & $serverName)

		;add Port
		$oPort = ObjCreate("Port.Port.1")
		$oPort.ServerName = $serverName
		$oPort.PortName = "IP_" & GUICtrlRead($ipAddr)
		$oPort.PortType = 1
		$oPort.HostAddress = GUICtrlRead($ipAddr)
		$oPort.PortNumber = "9100"
		$oPort.SNMP = true

		$oMaster.PortAdd($oPort)

		GUICtrlSetData($progresBar,  $increment + GUICtrlRead($progresBar))

		;create printer object again
		$oMaster = ObjCreate("PrintMaster.PrintMaster.1")
		$oPrinter = ObjCreate("Printer.Printer.1")

		GUICtrlSetData($progresBar,  $increment + GUICtrlRead($progresBar))

		GUICtrlSetData($progress,"Installing Driver To  " & $serverName)

		;driver
		RunWait("RUNDLL32 PRINTUI.DLL,PrintUIEntry /ia /c"&$serverName&" /m """&GUICtrlRead($driverName)&""" /h ""Intel"" /v ""Windows 2000"" /f """&GUICtrlRead($driverLoc)&"""")

		GUICtrlSetData($progress,"Adding Printer To " & $serverName)

		;add printer
		$oPrinter.ServerName  = $serverName ;remote computer name
		;Name you give to printer
		$oPrinter.PrinterName = GUICtrlRead($printerName)
		;Where are those Drivers?
		$oPrinter.DriverPath  = $driverDir
		;Driver name (this dosent really work too well)
		$oPrinter.DriverName  = GUICtrlRead($driverName)
		;Port to create and Printer IP address
		$oPrinter.PortName    = "IP_" & GUICtrlRead($ipAddr)
		;add that printer
		$oMaster.PrinterAdd($oPrinter)

		GUICtrlSetData($progresBar,  $increment + GUICtrlRead($progresBar))


		;make default
		;$oMaster.PrinterDataSet($printerName, "MyKey", "MyValue", Var)


		;print test page if box is checked :)
		if GUICtrlRead($notestPage) == $GUI_UNCHECKED Then
			; don't print if we're only printing one page, and we already pritned
			If $printed > 0 and GUICtrlRead($testPage) == $GUI_CHECKED Then ContinueLoop

			GUICtrlSetData($progress,"Printing Test Page From " & $serverName)
			$oMaster.PrintTestPage("", $serverName&"\"&GUICtrlRead($printerName))
			GUICtrlSetData($progresBar,  $increment + GUICtrlRead($progresBar))
			$printed += 1
		Endif

	Next

	#cs
		if GUICtrlRead($testPage) == $GUI_CHECKED Then
		GUICtrlSetData($progress,"Printing Test Page From " & _GUICtrlListGetText($List1, 0))
		$oMaster.PrintTestPage("", _GUICtrlListGetText($List1, 0)&"\"&GUICtrlRead($printerName))
		GUICtrlSetData($progresBar,  $increment + GUICtrlRead($progresBar))
		Endif
	#ce

	FileWriteLine(@ScriptDir&"\ErrorLog.txt", "= Printed "&$printed&" test pages.")
	$Media=_MediaOpen(@ScriptDir&"\done.mp3")
	_MediaPlay($Media)

	If $errors == 0 Then
		MsgBox(0,"Finished", "Printer Installation Finished Successfully!!!")
	Else
		MsgBox(48,"Finished", "Printer Installation Finished"&@CR&$errors&" errors occured! (See ErrorLog.txt)")
	EndIf

	_MediaStop($Media)
	_MediaClose($Media)

	GUIDelete($progressGui)

EndFunc

Func savePrinter()
	$filename = FileSaveDialog( "Save Printer Config", @ScriptDir & "\Printers", "Printer Files (*.prnt)|All (*.*)",16)
	if $filename <> "" Then
		;fix extension
		if 0==StringInStr ( $filename, "." ,0,-1) Then
			$filename = $filename & ".prnt"
		Endif
		;write file
		IniWrite($filename, "Printer", "Name", GUICtrlRead($printerName))
		IniWrite($filename, "Printer", "Driver", GUICtrlRead($driverName))
		IniWrite($filename, "Printer", "Location", GUICtrlRead($driverLoc))
		IniWrite($filename, "Printer", "IP", GUICtrlRead($ipAddr))
	EndIf
EndFunc

Func loadDriver()
	$filename = FileOpenDialog ( "Choose Driver Inf File", @ScriptDir & "\Printers", "Inf Files (*.inf)|All (*.*)" ,3)
	if $filename <> "" Then
		GUICtrlSetData($driverLoc,$filename)
	Endif
EndFunc

Func loadPrinter()
	$filename = FileOpenDialog ( "Choose Printer File", @ScriptDir & "\Printers", "Printer Files (*.prnt)|All (*.*)" ,3)
	if $filename <> "" Then
		GUICtrlSetData($printerName,IniRead($filename, "Printer", "Name", ""),"")
		GUICtrlSetData($driverName,IniRead($filename, "Printer", "Driver", ""),"")
		GUICtrlSetData($driverLoc,IniRead($filename, "Printer", "Location", ""),"")
		GUICtrlSetData($ipAddr,IniRead($filename, "Printer", "IP", ""),"")
	Endif
EndFunc

Func saveList()
	$filename = FileSaveDialog( "Save Computer List", @ScriptDir & "\Computers", "Computer Lists (*.comp)|All (*.*)",16)
	if $filename <> "" Then
		;fix extension
		if 0==StringInStr ( $filename, "." ,0,-1) Then
			$filename = $filename & ".comp"
		Endif
		;write File
		IniWrite($filename,"Computers", "size", _GUICtrlListCount($List1))
		For $i = 0 to _GUICtrlListCount($List1) -1
			IniWrite($filename,"Computers", $i, _GUICtrlListGetText($List1, $i))

		Next
	EndIf
EndFunc

Func loadList()
	$filename = FileOpenDialog ( "Choose Computer List", @ScriptDir & "\Computers", "Computer Lists (*.comp)|All (*.*)" ,3)
	if $filename <> "" Then
		_GUICtrlListClear($List1)
		For $i = 0 to IniRead($filename,"Computers","size",0) -1
			_GUICtrlListAddItem($List1,IniRead($filename, "Computers", $i, ""))
		Next
	Endif
EndFunc


Func deleteComputers()
	_GUICtrlListClear($List1)
EndFunc

Func deleteOne()
	_GUICtrlListDeleteItem($List1, _GUICtrlListGetCaretIndex($List1))
EndFunc


Func addComp()
	$addComp = GUICreate("Enter Computers", 275, 331)
	$addLabel = GUICtrlCreateLabel("Add Computers", 8, 8, 76, 17)
	$exLabel = GUICtrlCreateLabel("Example:  1150D0015050279", 8, 32, 155, 17)
	$inputComp= GUICtrlCreateEdit("", 8, 64, 153, 200)
	$addNow = GUICtrlCreateButton("Add These Computer(s)", 8, 296, 131, 25, 0)
	GUISetState(@SW_SHOW, $addComp)
	GUISwitch ($addComp)


	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				ExitLoop

			Case $addNow
				$temp = GUICtrlRead($inputComp)
				If $temp <> "" Then
					$array = StringSplit ( $temp, @CRLF ,1)
					For $i = 1 to $array[0]
						If $array[$i] <> "" Then
							_GUICtrlListAddItem($List1, $array[$i])
						Endif
					Next
				Endif
				ExitLoop

		EndSwitch
	WEnd
	GUIDelete($addComp)

EndFunc

; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: G:\PrinterSetup\gui.au3>
; ----------------------------------------------------------------------------



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
; <AUT2EXE INCLUDE-END: C:\Ninni\AutoIt\Include\WindowsConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Ninni\AutoIt\Include\AVIConstants.au3>
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
; <AUT2EXE INCLUDE-END: C:\Ninni\AutoIt\Include\AVIConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Ninni\AutoIt\Include\ComboConstants.au3>
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
; <AUT2EXE INCLUDE-END: C:\Ninni\AutoIt\Include\ComboConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Ninni\AutoIt\Include\DateTimeConstants.au3>
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
; <AUT2EXE INCLUDE-END: C:\Ninni\AutoIt\Include\DateTimeConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Ninni\AutoIt\Include\EditConstants.au3>
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
Global Const $EM_GETLINE = 0xC4
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
; <AUT2EXE INCLUDE-END: C:\Ninni\AutoIt\Include\EditConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Ninni\AutoIt\Include\StaticConstants.au3>
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
; <AUT2EXE INCLUDE-END: C:\Ninni\AutoIt\Include\StaticConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Ninni\AutoIt\Include\ListBoxConstants.au3>
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
; <AUT2EXE INCLUDE-END: C:\Ninni\AutoIt\Include\ListBoxConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Ninni\AutoIt\Include\ListViewConstants.au3>
; ----------------------------------------------------------------------------


; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.2.0
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
Global Const $LVS_NOLABELWRAP		= 0x0080

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
; <AUT2EXE INCLUDE-END: C:\Ninni\AutoIt\Include\ListViewConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Ninni\AutoIt\Include\SliderConstants.au3>
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
; <AUT2EXE INCLUDE-END: C:\Ninni\AutoIt\Include\SliderConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Ninni\AutoIt\Include\TreeViewConstants.au3>
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
; <AUT2EXE INCLUDE-END: C:\Ninni\AutoIt\Include\TreeViewConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Ninni\AutoIt\Include\UpDownConstants.au3>
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
; <AUT2EXE INCLUDE-END: C:\Ninni\AutoIt\Include\UpDownConstants.au3>
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
; <AUT2EXE INCLUDE-END: C:\Ninni\AutoIt\Include\GUIDefaultConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Ninni\AutoIt\Include\GUIConstantsEx.au3>
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
Global Const $GUI_NODROPACCEPTED = 4096
Global Const $GUI_ACCEPTFILES	= $GUI_DROPACCEPTED	; to be suppressed

Global Const $GUI_SHOW			= 16
Global Const $GUI_HIDE 			= 32
Global Const $GUI_ENABLE		= 64
Global Const $GUI_DISABLE		= 128

Global Const $GUI_FOCUS			= 256
Global Const $GUI_NOFOCUS		= 8192
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
Global Const $GUI_BKCOLOR_LV_ALTERNATE = 0xFE000000

; Other
Global Const $GUI_WS_EX_PARENTDRAG =      0x00100000

; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Ninni\AutoIt\Include\GUIConstantsEx.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Ninni\AutoIt\Include\WindowsConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Ninni\AutoIt\Include\WindowsConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Ninni\AutoIt\Include\ComboConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Ninni\AutoIt\Include\ComboConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Ninni\AutoIt\Include\ListViewConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Ninni\AutoIt\Include\ListViewConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Ninni\AutoIt\Include\StaticConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Ninni\AutoIt\Include\StaticConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Ninni\AutoIt\Include\ButtonConstants.au3>
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
; <AUT2EXE INCLUDE-END: C:\Ninni\AutoIt\Include\ButtonConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Ninni\AutoIt\Include\ListBoxConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Ninni\AutoIt\Include\ListBoxConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Ninni\AutoIt\Include\TabConstants.au3>
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
; <AUT2EXE INCLUDE-END: C:\Ninni\AutoIt\Include\TabConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Ninni\AutoIt\Include\EditConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Ninni\AutoIt\Include\EditConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Ninni\AutoIt\Include\DateTimeConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Ninni\AutoIt\Include\DateTimeConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Ninni\AutoIt\Include\SliderConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Ninni\AutoIt\Include\SliderConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Ninni\AutoIt\Include\TreeViewConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Ninni\AutoIt\Include\TreeViewConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Ninni\AutoIt\Include\ProgressConstants.au3>
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
; <AUT2EXE INCLUDE-END: C:\Ninni\AutoIt\Include\ProgressConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Ninni\AutoIt\Include\AVIConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Ninni\AutoIt\Include\AVIConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Ninni\AutoIt\Include\UpDownConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Ninni\AutoIt\Include\UpDownConstants.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Ninni\AutoIt\Include\GUIConstants.au3>
; ----------------------------------------------------------------------------


GUICreate("Runner",300,200)
GUICtrlCreateLabel("Benvenuto in Runner!", 100, 25, 150)
GUICtrlCreateLabel("Questo programma ti farà aprire facilmente alcuni programmi", 10,50, 500)

$filemenu = GuiCtrlCreateMenu ("File")
$exititem = GuiCtrlCreateMenuitem ("Exit",$filemenu)
$helpmenu = GuiCtrlCreateMenu ("?")
$aboutitem = GuiCtrlCreateMenuitem ("About",$helpmenu)
$upgrade = Guictrlcreatemenuitem ("Check Upgrade", $helpmenu)
$okbutton = GuiCtrlCreateButton ("Avanti",50,130,70,20)

$cancelbutton = GuiCtrlCreateButton ("Esci",180,130,70,20)

GuiSetState()

While 1
	$msg = GUIGetMsg()


	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $cancelbutton
			Exit


		Case $msg = $exititem
			Exit

		Case $msg = $okbutton
			$answer = MsgBox(4, "Runner", "Vuoi avviare la Calcolatrice?")


;Calcolatrice si/no
If $answer = 6 Then
    Run("calc.exe")
EndIf
;CONTINUA?
If $answer = 7 Then
    $answer = MsgBox (4, "Runner", "Ok, Vuoi Continuare con gli altri programmi?")
EndIf
;CIAO
If $answer = 7 Then
    $answer = MsgBox (0, "Runner", "Ok, Ciao!")
EndIf

;avanti/o No
If $answer = 6 Then
	$answer = MsgBox(4, "Runner", "Vuoi avviare il Notepad?")
EndIf
;APRE NOTEPAD
If $answer = 6 Then
	Run("NOTEPAD.exe")
EndIf
;CONTINUA?
If $answer = 7 Then
	$answer = MsgBox(4, "Runner", "Ok, Vuoi Continuare con gli altri programmi?")
EndIf

;VUOI AVVIARE PAINT?
If $answer = 6 Then
	$answer = MsgBox(4, "Runner", "Vuoi avviare Paint?")
EndIf
;APRE PAINT
If $answer = 6 Then
	Run ("mspaint.exe")
EndIf
;SE NON VUOLE AVVIARE QUALCHE PROGRAMMA
If $answer = 7 Then
    $answer = MsgBox (4, "Runner", "Ok, Vuoi Continuare con gli altri programmi?")
EndIf
;USCITA
If $answer = 7 Then
    $answer = MsgBox (0, "Runner", "Ok, Ciao!")
EndIf
;DOMANDA SE VOGLIO APRIRE WINHELP
If $answer = 6 Then
	$answer = MsgBox (4, "Runner", "Vuoi aprire Win Help? ")
EndIf
;AVVIA WIN HELP
If $answer = 6 Then
	Run ("winhelp.exe")
EndIf
; DA CONTINUARE
If $answer = 7 Then
     $answer = MsgBox (4, "Runner", "Ok, Vuoi Continuare con gli altri programmi?")
EndIf
;aggiornamento
If $answer = 7 Then
MsgBox (0, "Runner", "Ok, Ciao!")
EndIf
If $answer = 6 Then
	$answer = MsgBox (4, "Runner", "Vuoi aprire il Prompt dei Comandi? ")
EndIf
;arv
If $answer = 6 Then
	Run ("cmd.exe")
EndIf
If $answer = 7 Then
     $answer = MsgBox (4, "Runner", "Ok, Vuoi Continuare con gli altri programmi?")
 EndIf
 
;aeb
If $answer = 7 Then
MsgBox (0, "Runner", "Ok, Ciao!")
EndIf
If $answer = 6 Then
	$answer = MsgBox (4, "Runner", "Vuoi avviare Magnify? ")
EndIf
;dsa
If $answer = 6 Then
	Run ("magnify.exe")
EndIf
If $answer = 7 Then
     $answer = MsgBox (4, "Runner", "Ok, Vuoi Continuare con gli altri programmi?")
 EndIf
If $answer = 7 Then
MsgBox (0, "Runner", "Ok, Ciao!")
EndIf
If $answer = 6 Then
	$answer = MsgBox (4, "Runner", "Vuoi avviare Internet Explorer? ")
EndIf
If $answer = 6 Then
	ShellExecute ("iexplore.exe")
EndIf
If $answer = 7 Then
     $answer = MsgBox (4, "Runner", "Ok, Vuoi Continuare con gli altri programmi?")
 EndIf
 If $answer = 7 Then
MsgBox (0, "Runner", "Ok, Ciao!")
EndIf
If $answer = 6 Then
	$answer = MsgBox (4, "Runner", "Vuoi avviare Win Media Player? ")
EndIf
If $answer = 6 Then
	ShellExecute ("wmplayer.exe")
EndIf
 If $answer = 7 Then
MsgBox (0, "Runner", "Altri programmi nelle prossime versioni!")
EndIf
;da Continuare
		Case $msg = $aboutitem
			GUICtrlCreateLabel("Ideatore del Programma:", 10, 20, 500)
GUICtrlCreateLabel("Shides", 10,40, 500)
GUICtrlCreateLabel("Contatti:", 10,60, 500)
GUICtrlCreateLabel("Msn:     matrix2192@hotmail.it", 10,75, 500)
GUICtrlCreateLabel("E-mail:  matrix2192@supereva.it", 10,90, 500)

		Case $msg = $upgrade
			ShellExecute ("iexplore.exe", "                                        ")
	EndSelect
WEnd

GUIDelete()
Exit

; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Ninni\AutoIt\Script\Runner.au3>
; ----------------------------------------------------------------------------


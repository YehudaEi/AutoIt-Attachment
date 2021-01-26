#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>
#include <WindowsConstants.au3>

$Form1 = GUICreate("Process List", 180, 201, 488, 372)

$List = GUICtrlCreateList("", 8, 8, 161, 149)
$Button1 = GUICtrlCreateButton("OK", 8, 168, 75, 25, $WS_GROUP)
$Button2 = GUICtrlCreateButton("Cancel", 96, 168, 75, 25, $WS_GROUP)

$aProcList = ProcessList("sro_client.exe")
$sProc_List = ""

For $i = 1 To UBound($aProcList) - 1
    $sProc_List &= $aProcList[$i][0] & " ~ " & $aProcList[$i][1] & "|"
Next

GUICtrlSetData($List, $sProc_List)

$ProcessList = TrayCreateItem("Process List")
TrayCreateItem("")

TraySetState()
While 1
	$TrayMSG = TrayGetMsg()
	Select
		Case $TrayMSG = $ProcessList
			GUISetState(@SW_SHOW)
			While 1
				$nMsg = GUIGetMsg()
   
				Switch $nMsg
					Case $GUI_EVENT_CLOSE
						Exit
					Case $Button2
						GUISetState(@SW_HIDE)
					Case $Button1
						$PROC = GUICtrlRead($List)
						GUISetState(@SW_HIDE)
				EndSwitch
			WEnd
	EndSelect
WEnd
;-----------------------------------------------------------------------------------------------------------------------------------------
Global Const $GUI_EVENT_CLOSE = -3
Global Const $GUI_EVENT_MINIMIZE = -4
Global Const $GUI_EVENT_RESTORE = -5
Global Const $GUI_EVENT_MAXIMIZE = -6
Global Const $GUI_EVENT_PRIMARYDOWN = -7
Global Const $GUI_EVENT_PRIMARYUP = -8
Global Const $GUI_EVENT_SECONDARYDOWN = -9
Global Const $GUI_EVENT_SECONDARYUP = -10
Global Const $GUI_EVENT_MOUSEMOVE = -11
Global Const $GUI_EVENT_RESIZED = -12
Global Const $GUI_EVENT_DROPPED = -13
Global Const $GUI_RUNDEFMSG = "GUI_RUNDEFMSG"
Global Const $GUI_AVISTOP = 0
Global Const $GUI_AVISTART = 1
Global Const $GUI_AVICLOSE = 2
Global Const $GUI_CHECKED = 1
Global Const $GUI_INDETERMINATE = 2
Global Const $GUI_UNCHECKED = 4
Global Const $GUI_DROPACCEPTED = 8
Global Const $GUI_NODROPACCEPTED = 4096
Global Const $GUI_ACCEPTFILES = $GUI_DROPACCEPTED
Global Const $GUI_SHOW = 16
Global Const $GUI_HIDE = 32
Global Const $GUI_ENABLE = 64
Global Const $GUI_DISABLE = 128
Global Const $GUI_FOCUS = 256
Global Const $GUI_NOFOCUS = 8192
Global Const $GUI_DEFBUTTON = 512
Global Const $GUI_EXPAND = 1024
Global Const $GUI_ONTOP = 2048
Global Const $GUI_FONTITALIC = 2
Global Const $GUI_FONTUNDER = 4
Global Const $GUI_FONTSTRIKE = 8
Global Const $GUI_DOCKAUTO = 1
Global Const $GUI_DOCKLEFT = 2
Global Const $GUI_DOCKRIGHT = 4
Global Const $GUI_DOCKHCENTER = 8
Global Const $GUI_DOCKTOP = 32
Global Const $GUI_DOCKBOTTOM = 64
Global Const $GUI_DOCKVCENTER = 128
Global Const $GUI_DOCKWIDTH = 256
Global Const $GUI_DOCKHEIGHT = 512
Global Const $GUI_DOCKSIZE = 768
Global Const $GUI_DOCKMENUBAR = 544
Global Const $GUI_DOCKSTATEBAR = 576
Global Const $GUI_DOCKALL = 802
Global Const $GUI_DOCKBORDERS = 102
Global Const $GUI_GR_CLOSE = 1
Global Const $GUI_GR_LINE = 2
Global Const $GUI_GR_BEZIER = 4
Global Const $GUI_GR_MOVE = 6
Global Const $GUI_GR_COLOR = 8
Global Const $GUI_GR_RECT = 10
Global Const $GUI_GR_ELLIPSE = 12
Global Const $GUI_GR_PIE = 14
Global Const $GUI_GR_DOT = 16
Global Const $GUI_GR_PIXEL = 18
Global Const $GUI_GR_HINT = 20
Global Const $GUI_GR_REFRESH = 22
Global Const $GUI_GR_PENSIZE = 24
Global Const $GUI_GR_NOBKCOLOR = -2
Global Const $GUI_BKCOLOR_DEFAULT = -1
Global Const $GUI_BKCOLOR_TRANSPARENT = -2
Global Const $GUI_BKCOLOR_LV_ALTERNATE = -33554432
Global Const $GUI_WS_EX_PARENTDRAG = 1048576
Global Const $WS_TILED = 0
Global Const $WS_OVERLAPPED = 0
Global Const $WS_MAXIMIZEBOX = 65536
Global Const $WS_MINIMIZEBOX = 131072
Global Const $WS_TABSTOP = 65536
Global Const $WS_GROUP = 131072
Global Const $WS_SIZEBOX = 262144
Global Const $WS_THICKFRAME = 262144
Global Const $WS_SYSMENU = 524288
Global Const $WS_HSCROLL = 1048576
Global Const $WS_VSCROLL = 2097152
Global Const $WS_DLGFRAME = 4194304
Global Const $WS_BORDER = 8388608
Global Const $WS_CAPTION = 12582912
Global Const $WS_OVERLAPPEDWINDOW = 13565952
Global Const $WS_TILEDWINDOW = 13565952
Global Const $WS_MAXIMIZE = 16777216
Global Const $WS_CLIPCHILDREN = 33554432
Global Const $WS_CLIPSIBLINGS = 67108864
Global Const $WS_DISABLED = 134217728
Global Const $WS_VISIBLE = 268435456
Global Const $WS_MINIMIZE = 536870912
Global Const $WS_CHILD = 1073741824
Global Const $WS_POPUP = -2147483648
Global Const $WS_POPUPWINDOW = -2138570752
Global Const $DS_MODALFRAME = 128
Global Const $DS_SETFOREGROUND = 512
Global Const $DS_CONTEXTHELP = 8192
Global Const $WS_EX_ACCEPTFILES = 16
Global Const $WS_EX_MDICHILD = 64
Global Const $WS_EX_APPWINDOW = 262144
Global Const $WS_EX_CLIENTEDGE = 512
Global Const $WS_EX_CONTEXTHELP = 1024
Global Const $WS_EX_DLGMODALFRAME = 1
Global Const $WS_EX_LEFTSCROLLBAR = 16384
Global Const $WS_EX_OVERLAPPEDWINDOW = 768
Global Const $WS_EX_RIGHT = 4096
Global Const $WS_EX_STATICEDGE = 131072
Global Const $WS_EX_TOOLWINDOW = 128
Global Const $WS_EX_TOPMOST = 8
Global Const $WS_EX_TRANSPARENT = 32
Global Const $WS_EX_WINDOWEDGE = 256
Global Const $WS_EX_LAYERED = 524288
Global Const $WS_EX_CONTROLPARENT = 65536
Global Const $WS_EX_LAYOUTRTL = 4194304
Global Const $WS_EX_RTLREADING = 8192
Global Const $WM_GETTEXTLENGTH = 14
Global Const $WM_GETTEXT = 13
Global Const $WM_SIZE = 5
Global Const $WM_SIZING = 532
Global Const $WM_USER = 1024
Global Const $WM_CREATE = 1
Global Const $WM_DESTROY = 2
Global Const $WM_MOVE = 3
Global Const $WM_ACTIVATE = 6
Global Const $WM_SETFOCUS = 7
Global Const $WM_KILLFOCUS = 8
Global Const $WM_ENABLE = 10
Global Const $WM_SETREDRAW = 11
Global Const $WM_SETTEXT = 12
Global Const $WM_PAINT = 15
Global Const $WM_CLOSE = 16
Global Const $WM_QUIT = 18
Global Const $WM_ERASEBKGND = 20
Global Const $WM_SYSCOLORCHANGE = 21
Global Const $WM_SHOWWINDOW = 24
Global Const $WM_WININICHANGE = 26
Global Const $WM_DEVMODECHANGE = 27
Global Const $WM_ACTIVATEAPP = 28
Global Const $WM_FONTCHANGE = 29
Global Const $WM_TIMECHANGE = 30
Global Const $WM_CANCELMODE = 31
Global Const $WM_SETCURSOR = 32
Global Const $WM_MOUSEACTIVATE = 33
Global Const $WM_CHILDACTIVATE = 34
Global Const $WM_QUEUESYNC = 35
Global Const $WM_GETMINMAXINFO = 36
Global Const $WM_PAINTICON = 38
Global Const $WM_ICONERASEBKGND = 39
Global Const $WM_NEXTDLGCTL = 40
Global Const $WM_SPOOLERSTATUS = 42
Global Const $WM_DRAWITEM = 43
Global Const $WM_MEASUREITEM = 44
Global Const $WM_DELETEITEM = 45
Global Const $WM_VKEYTOITEM = 46
Global Const $WM_CHARTOITEM = 47
Global Const $WM_SETFONT = 48
Global Const $WM_GETFONT = 49
Global Const $WM_SETHOTKEY = 50
Global Const $WM_GETHOTKEY = 51
Global Const $WM_QUERYDRAGICON = 55
Global Const $WM_COMPAREITEM = 57
Global Const $WM_GETOBJECT = 61
Global Const $WM_COMPACTING = 65
Global Const $WM_COMMNOTIFY = 68
Global Const $WM_WINDOWPOSCHANGING = 70
Global Const $WM_WINDOWPOSCHANGED = 71
Global Const $WM_POWER = 72
Global Const $WM_NOTIFY = 78
Global Const $WM_COPYDATA = 74
Global Const $WM_CANCELJOURNAL = 75
Global Const $WM_INPUTLANGCHANGEREQUEST = 80
Global Const $WM_INPUTLANGCHANGE = 81
Global Const $WM_TCARD = 82
Global Const $WM_HELP = 83
Global Const $WM_USERCHANGED = 84
Global Const $WM_NOTIFYFORMAT = 85
Global Const $WM_CUT = 768
Global Const $WM_COPY = 769
Global Const $WM_PASTE = 770
Global Const $WM_CLEAR = 771
Global Const $WM_UNDO = 772
Global Const $WM_CONTEXTMENU = 123
Global Const $WM_STYLECHANGING = 124
Global Const $WM_STYLECHANGED = 125
Global Const $WM_DISPLAYCHANGE = 126
Global Const $WM_GETICON = 127
Global Const $WM_SETICON = 128
Global Const $WM_NCCREATE = 129
Global Const $WM_NCDESTROY = 130
Global Const $WM_NCCALCSIZE = 131
Global Const $WM_NCHITTEST = 132
Global Const $WM_NCPAINT = 133
Global Const $WM_NCACTIVATE = 134
Global Const $WM_GETDLGCODE = 135
Global Const $WM_SYNCPAINT = 136
Global Const $WM_NCMOUSEMOVE = 160
Global Const $WM_NCLBUTTONDOWN = 161
Global Const $WM_NCLBUTTONUP = 162
Global Const $WM_NCLBUTTONDBLCLK = 163
Global Const $WM_NCRBUTTONDOWN = 164
Global Const $WM_NCRBUTTONUP = 165
Global Const $WM_NCRBUTTONDBLCLK = 166
Global Const $WM_NCMBUTTONDOWN = 167
Global Const $WM_NCMBUTTONUP = 168
Global Const $WM_NCMBUTTONDBLCLK = 169
Global Const $WM_KEYDOWN = 256
Global Const $WM_KEYUP = 257
Global Const $WM_CHAR = 258
Global Const $WM_DEADCHAR = 259
Global Const $WM_SYSKEYDOWN = 260
Global Const $WM_SYSKEYUP = 261
Global Const $WM_SYSCHAR = 262
Global Const $WM_SYSDEADCHAR = 263
Global Const $WM_INITDIALOG = 272
Global Const $WM_COMMAND = 273
Global Const $WM_SYSCOMMAND = 274
Global Const $WM_TIMER = 275
Global Const $WM_HSCROLL = 276
Global Const $WM_VSCROLL = 277
Global Const $WM_INITMENU = 278
Global Const $WM_INITMENUPOPUP = 279
Global Const $WM_MENUSELECT = 287
Global Const $WM_MENUCHAR = 288
Global Const $WM_ENTERIDLE = 289
Global Const $WM_MENURBUTTONUP = 290
Global Const $WM_MENUDRAG = 291
Global Const $WM_MENUGETOBJECT = 292
Global Const $WM_UNINITMENUPOPUP = 293
Global Const $WM_MENUCOMMAND = 294
Global Const $WM_CHANGEUISTATE = 295
Global Const $WM_UPDATEUISTATE = 296
Global Const $WM_QUERYUISTATE = 297
Global Const $WM_CTLCOLORMSGBOX = 306
Global Const $WM_CTLCOLOREDIT = 307
Global Const $WM_CTLCOLORLISTBOX = 308
Global Const $WM_CTLCOLORBTN = 309
Global Const $WM_CTLCOLORDLG = 310
Global Const $WM_CTLCOLORSCROLLBAR = 311
Global Const $WM_CTLCOLORSTATIC = 312
Global Const $WM_CTLCOLOR = 25
Global Const $MN_GETHMENU = 481
Global Const $NM_FIRST = 0
Global Const $NM_OUTOFMEMORY = $NM_FIRST - 1
Global Const $NM_CLICK = $NM_FIRST - 2
Global Const $NM_DBLCLK = $NM_FIRST - 3
Global Const $NM_RETURN = $NM_FIRST - 4
Global Const $NM_RCLICK = $NM_FIRST - 5
Global Const $NM_RDBLCLK = $NM_FIRST - 6
Global Const $NM_SETFOCUS = $NM_FIRST - 7
Global Const $NM_KILLFOCUS = $NM_FIRST - 8
Global Const $NM_CUSTOMDRAW = $NM_FIRST - 12
Global Const $NM_HOVER = $NM_FIRST - 13
Global Const $NM_NCHITTEST = $NM_FIRST - 14
Global Const $NM_KEYDOWN = $NM_FIRST - 15
Global Const $NM_RELEASEDCAPTURE = $NM_FIRST - 16
Global Const $NM_SETCURSOR = $NM_FIRST - 17
Global Const $NM_CHAR = $NM_FIRST - 18
Global Const $NM_TOOLTIPSCREATED = $NM_FIRST - 19
Global Const $NM_LDOWN = $NM_FIRST - 20
Global Const $NM_RDOWN = $NM_FIRST - 21
Global Const $NM_THEMECHANGED = $NM_FIRST - 22
Global Const $WM_LBUTTONUP = 514
Global Const $WM_MOUSEMOVE = 512
Global Const $PS_SOLID = 0
Global Const $PS_DASH = 1
Global Const $PS_DOT = 2
Global Const $PS_DASHDOT = 3
Global Const $PS_DASHDOTDOT = 4
Global Const $PS_NULL = 5
Global Const $PS_INSIDEFRAME = 6
Global Const $RGN_AND = 1
Global Const $RGN_OR = 2
Global Const $RGN_XOR = 3
Global Const $RGN_DIFF = 4
Global Const $RGN_COPY = 5
Global Const $ERROR = 0
Global Const $NULLREGION = 1
Global Const $SIMPLEREGION = 2
Global Const $COMPLEXREGION = 3
Global Const $TRANSPARENT = 1
Global Const $OPAQUE = 2
Global Const $CCM_FIRST = 8192
Global Const $CCM_GETUNICODEFORMAT = ($CCM_FIRST + 6)
Global Const $CCM_SETUNICODEFORMAT = ($CCM_FIRST + 5)
Global Const $CCM_SETBKCOLOR = $CCM_FIRST + 1
Global Const $CCM_SETCOLORSCHEME = $CCM_FIRST + 2
Global Const $CCM_GETCOLORSCHEME = $CCM_FIRST + 3
Global Const $CCM_GETDROPTARGET = $CCM_FIRST + 4
Global Const $CCM_SETWINDOWTHEME = $CCM_FIRST + 11
Global Const $GA_PARENT = 1
Global Const $GA_ROOT = 2
Global Const $GA_ROOTOWNER = 3
Global Const $SM_CXSCREEN = 0
Global Const $SM_CYSCREEN = 1
Global Const $SM_CXVSCROLL = 2
Global Const $SM_CYHSCROLL = 3
Global Const $SM_CYCAPTION = 4
Global Const $SM_CXBORDER = 5
Global Const $SM_CYBORDER = 6
Global Const $SM_CXDLGFRAME = 7
Global Const $SM_CYDLGFRAME = 8
Global Const $SM_CYVTHUMB = 9
Global Const $SM_CXHTHUMB = 10
Global Const $SM_CXICON = 11
Global Const $SM_CYICON = 12
Global Const $SM_CXCURSOR = 13
Global Const $SM_CYCURSOR = 14
Global Const $SM_CYMENU = 15
Global Const $SM_CXFULLSCREEN = 16
Global Const $SM_CYFULLSCREEN = 17
Global Const $SM_CYKANJIWINDOW = 18
Global Const $SM_MOUSEPRESENT = 19
Global Const $SM_CYVSCROLL = 20
Global Const $SM_CXHSCROLL = 21
Global Const $SM_DEBUG = 22
Global Const $SM_SWAPBUTTON = 23
Global Const $SM_RESERVED1 = 24
Global Const $SM_RESERVED2 = 25
Global Const $SM_RESERVED3 = 26
Global Const $SM_RESERVED4 = 27
Global Const $SM_CXMIN = 28
Global Const $SM_CYMIN = 29
Global Const $SM_CXSIZE = 30
Global Const $SM_CYSIZE = 31
Global Const $SM_CXFRAME = 32
Global Const $SM_CYFRAME = 33
Global Const $SM_CXMINTRACK = 34
Global Const $SM_CYMINTRACK = 35
Global Const $SM_CXDOUBLECLK = 36
Global Const $SM_CYDOUBLECLK = 37
Global Const $SM_CXICONSPACING = 38
Global Const $SM_CYICONSPACING = 39
Global Const $SM_MENUDROPALIGNMENT = 40
Global Const $SM_PENWINDOWS = 41
Global Const $SM_DBCSENABLED = 42
Global Const $SM_CMOUSEBUTTONS = 43
Global Const $SM_SECURE = 44
Global Const $SM_CXEDGE = 45
Global Const $SM_CYEDGE = 46
Global Const $SM_CXMINSPACING = 47
Global Const $SM_CYMINSPACING = 48
Global Const $SM_CXSMICON = 49
Global Const $SM_CYSMICON = 50
Global Const $SM_CYSMCAPTION = 51
Global Const $SM_CXSMSIZE = 52
Global Const $SM_CYSMSIZE = 53
Global Const $SM_CXMENUSIZE = 54
Global Const $SM_CYMENUSIZE = 55
Global Const $SM_ARRANGE = 56
Global Const $SM_CXMINIMIZED = 57
Global Const $SM_CYMINIMIZED = 58
Global Const $SM_CXMAXTRACK = 59
Global Const $SM_CYMAXTRACK = 60
Global Const $SM_CXMAXIMIZED = 61
Global Const $SM_CYMAXIMIZED = 62
Global Const $SM_NETWORK = 63
Global Const $SM_CLEANBOOT = 67
Global Const $SM_CXDRAG = 68
Global Const $SM_CYDRAG = 69
Global Const $SM_SHOWSOUNDS = 70
Global Const $SM_CXMENUCHECK = 71
Global Const $SM_CYMENUCHECK = 72
Global Const $SM_SLOWMACHINE = 73
Global Const $SM_MIDEASTENABLED = 74
Global Const $SM_MOUSEWHEELPRESENT = 75
Global Const $SM_XVIRTUALSCREEN = 76
Global Const $SM_YVIRTUALSCREEN = 77
Global Const $SM_CXVIRTUALSCREEN = 78
Global Const $SM_CYVIRTUALSCREEN = 79
Global Const $SM_CMONITORS = 80
Global Const $SM_SAMEDISPLAYFORMAT = 81
Global Const $SM_IMMENABLED = 82
Global Const $SM_CXFOCUSBORDER = 83
Global Const $SM_CYFOCUSBORDER = 84
Global Const $SM_TABLETPC = 86
Global Const $SM_MEDIACENTER = 87
Global Const $SM_STARTER = 88
Global Const $SM_SERVERR2 = 89
Global Const $SM_CMETRICS = 90
Global Const $SM_REMOTESESSION = 4096
Global Const $SM_SHUTTINGDOWN = 8192
Global Const $SM_REMOTECONTROL = 8193
Global Const $SM_CARETBLINKINGENABLED = 8194
Global Const $BLACKNESS = 66
Global Const $CAPTUREBLT = 1073741824
Global Const $DSTINVERT = 5570569
Global Const $MERGECOPY = 12583114
Global Const $MERGEPAINT = 12255782
Global Const $NOMIRRORBITMAP = -2147483648
Global Const $NOTSRCCOPY = 3342344
Global Const $NOTSRCERASE = 1114278
Global Const $PATCOPY = 15728673
Global Const $PATINVERT = 5898313
Global Const $PATPAINT = 16452105
Global Const $SRCAND = 8913094
Global Const $SRCCOPY = 13369376
Global Const $SRCERASE = 4457256
Global Const $SRCINVERT = 6684742
Global Const $SRCPAINT = 15597702
Global Const $WHITENESS = 16711778
Global Const $DT_BOTTOM = 8
Global Const $DT_CALCRECT = 1024
Global Const $DT_CENTER = 1
Global Const $DT_EDITCONTROL = 8192
Global Const $DT_END_ELLIPSIS = 32768
Global Const $DT_EXPANDTABS = 64
Global Const $DT_EXTERNALLEADING = 512
Global Const $DT_HIDEPREFIX = 1048576
Global Const $DT_INTERNAL = 4096
Global Const $DT_LEFT = 0
Global Const $DT_MODIFYSTRING = 65536
Global Const $DT_NOCLIP = 256
Global Const $DT_NOFULLWIDTHCHARBREAK = 524288
Global Const $DT_NOPREFIX = 2048
Global Const $DT_PATH_ELLIPSIS = 16384
Global Const $DT_PREFIXONLY = 2097152
Global Const $DT_RIGHT = 2
Global Const $DT_RTLREADING = 131072
Global Const $DT_SINGLELINE = 32
Global Const $DT_TABSTOP = 128
Global Const $DT_TOP = 0
Global Const $DT_VCENTER = 4
Global Const $DT_WORDBREAK = 16
Global Const $DT_WORD_ELLIPSIS = 262144
Global Const $RDW_ERASE = 4
Global Const $RDW_FRAME = 1024
Global Const $RDW_INTERNALPAINT = 2
Global Const $RDW_INVALIDATE = 1
Global Const $RDW_NOERASE = 32
Global Const $RDW_NOFRAME = 2048
Global Const $RDW_NOINTERNALPAINT = 16
Global Const $RDW_VALIDATE = 8
Global Const $RDW_ERASENOW = 512
Global Const $RDW_UPDATENOW = 256
Global Const $RDW_ALLCHILDREN = 128
Global Const $RDW_NOCHILDREN = 64
Global Const $WM_RENDERFORMAT = 773
Global Const $WM_RENDERALLFORMATS = 774
Global Const $WM_DESTROYCLIPBOARD = 775
Global Const $WM_DRAWCLIPBOARD = 776
Global Const $WM_PAINTCLIPBOARD = 777
Global Const $WM_VSCROLLCLIPBOARD = 778
Global Const $WM_SIZECLIPBOARD = 779
Global Const $WM_ASKCBFORMATNAME = 780
Global Const $WM_CHANGECBCHAIN = 781
Global Const $WM_HSCROLLCLIPBOARD = 782
Global Const $HTERROR = -2
Global Const $HTTRANSPARENT = -1
Global Const $HTNOWHERE = 0
Global Const $HTCLIENT = 1
Global Const $HTCAPTION = 2
Global Const $HTSYSMENU = 3
Global Const $HTGROWBOX = 4
Global Const $HTSIZE = $HTGROWBOX
Global Const $HTMENU = 5
Global Const $HTHSCROLL = 6
Global Const $HTVSCROLL = 7
Global Const $HTMINBUTTON = 8
Global Const $HTMAXBUTTON = 9
Global Const $HTLEFT = 10
Global Const $HTRIGHT = 11
Global Const $HTTOP = 12
Global Const $HTTOPLEFT = 13
Global Const $HTTOPRIGHT = 14
Global Const $HTBOTTOM = 15
Global Const $HTBOTTOMLEFT = 16
Global Const $HTBOTTOMRIGHT = 17
Global Const $HTBORDER = 18
Global Const $HTREDUCE = $HTMINBUTTON
Global Const $HTZOOM = $HTMAXBUTTON
Global Const $HTSIZEFIRST = $HTLEFT
Global Const $HTSIZELAST = $HTBOTTOMRIGHT
Global Const $HTOBJECT = 19
Global Const $HTCLOSE = 20
Global Const $HTHELP = 21
Global Const $COLOR_SCROLLBAR = 0
Global Const $COLOR_BACKGROUND = 1
Global Const $COLOR_ACTIVECAPTION = 2
Global Const $COLOR_INACTIVECAPTION = 3
Global Const $COLOR_MENU = 4
Global Const $COLOR_WINDOW = 5
Global Const $COLOR_WINDOWFRAME = 6
Global Const $COLOR_MENUTEXT = 7
Global Const $COLOR_WINDOWTEXT = 8
Global Const $COLOR_CAPTIONTEXT = 9
Global Const $COLOR_ACTIVEBORDER = 10
Global Const $COLOR_INACTIVEBORDER = 11
Global Const $COLOR_APPWORKSPACE = 12
Global Const $COLOR_HIGHLIGHT = 13
Global Const $COLOR_HIGHLIGHTTEXT = 14
Global Const $COLOR_BTNFACE = 15
Global Const $COLOR_BTNSHADOW = 16
Global Const $COLOR_GRAYTEXT = 17
Global Const $COLOR_BTNTEXT = 18
Global Const $COLOR_INACTIVECAPTIONTEXT = 19
Global Const $COLOR_BTNHIGHLIGHT = 20
Global Const $COLOR_3DDKSHADOW = 21
Global Const $COLOR_3DLIGHT = 22
Global Const $COLOR_INFOTEXT = 23
Global Const $COLOR_INFOBK = 24
Global Const $COLOR_HOTLIGHT = 26
Global Const $COLOR_GRADIENTACTIVECAPTION = 27
Global Const $COLOR_GRADIENTINACTIVECAPTION = 28
Global Const $COLOR_MENUHILIGHT = 29
Global Const $COLOR_MENUBAR = 30
Global Const $COLOR_DESKTOP = 1
Global Const $COLOR_3DFACE = 15
Global Const $COLOR_3DSHADOW = 16
Global Const $COLOR_3DHIGHLIGHT = 20
Global Const $COLOR_3DHILIGHT = 20
Global Const $COLOR_BTNHILIGHT = 20
Global Const $HINST_COMMCTRL = -1
Global Const $IDB_STD_SMALL_COLOR = 0
Global Const $IDB_STD_LARGE_COLOR = 1
Global Const $IDB_VIEW_SMALL_COLOR = 4
Global Const $IDB_VIEW_LARGE_COLOR = 5
Global Const $IDB_HIST_SMALL_COLOR = 8
Global Const $IDB_HIST_LARGE_COLOR = 9
Global Const $STARTF_FORCEOFFFEEDBACK = 128
Global Const $STARTF_FORCEONFEEDBACK = 64
Global Const $STARTF_RUNFULLSCREEN = 32
Global Const $STARTF_USECOUNTCHARS = 8
Global Const $STARTF_USEFILLATTRIBUTE = 16
Global Const $STARTF_USEHOTKEY = 512
Global Const $STARTF_USEPOSITION = 4
Global Const $STARTF_USESHOWWINDOW = 1
Global Const $STARTF_USESIZE = 2
Global Const $STARTF_USESTDHANDLES = 256
Global Const $CDDS_PREPAINT = 1
Global Const $CDDS_POSTPAINT = 2
Global Const $CDDS_PREERASE = 3
Global Const $CDDS_POSTERASE = 4
Global Const $CDDS_ITEM = 65536
Global Const $CDDS_ITEMPREPAINT = 65537
Global Const $CDDS_ITEMPOSTPAINT = 65538
Global Const $CDDS_ITEMPREERASE = 65539
Global Const $CDDS_ITEMPOSTERASE = 65540
Global Const $CDDS_SUBITEM = 131072
Global Const $CDIS_SELECTED = 1
Global Const $CDIS_GRAYED = 2
Global Const $CDIS_DISABLED = 4
Global Const $CDIS_CHECKED = 8
Global Const $CDIS_FOCUS = 16
Global Const $CDIS_DEFAULT = 32
Global Const $CDIS_HOT = 64
Global Const $CDIS_MARKED = 128
Global Const $CDIS_INDETERMINATE = 256
Global Const $CDIS_SHOWKEYBOARDCUES = 512
Global Const $CDIS_NEARHOT = 1024
Global Const $CDIS_OTHERSIDEHOT = 2048
Global Const $CDIS_DROPHILITED = 4096
Global Const $CDRF_DODEFAULT = 0
Global Const $CDRF_NEWFONT = 2
Global Const $CDRF_SKIPDEFAULT = 4
Global Const $CDRF_NOTIFYPOSTPAINT = 16
Global Const $CDRF_NOTIFYITEMDRAW = 32
Global Const $CDRF_NOTIFYSUBITEMDRAW = 32
Global Const $CDRF_NOTIFYPOSTERASE = 64
Global Const $CDRF_DOERASE = 8
Global Const $CDRF_SKIPPOSTPAINT = 256
Global Const $GUI_SS_DEFAULT_GUI = BitOR($WS_MINIMIZEBOX, $WS_CAPTION, $WS_POPUP, $WS_SYSMENU)
Global Const $ERROR_NO_TOKEN = 1008
Global Const $SE_ASSIGNPRIMARYTOKEN_NAME = "SeAssignPrimaryTokenPrivilege"
Global Const $SE_AUDIT_NAME = "SeAuditPrivilege"
Global Const $SE_BACKUP_NAME = "SeBackupPrivilege"
Global Const $SE_CHANGE_NOTIFY_NAME = "SeChangeNotifyPrivilege"
Global Const $SE_CREATE_GLOBAL_NAME = "SeCreateGlobalPrivilege"
Global Const $SE_CREATE_PAGEFILE_NAME = "SeCreatePagefilePrivilege"
Global Const $SE_CREATE_PERMANENT_NAME = "SeCreatePermanentPrivilege"
Global Const $SE_CREATE_TOKEN_NAME = "SeCreateTokenPrivilege"
Global Const $SE_DEBUG_NAME = "SeDebugPrivilege"
Global Const $SE_ENABLE_DELEGATION_NAME = "SeEnableDelegationPrivilege"
Global Const $SE_IMPERSONATE_NAME = "SeImpersonatePrivilege"
Global Const $SE_INC_BASE_PRIORITY_NAME = "SeIncreaseBasePriorityPrivilege"
Global Const $SE_INCREASE_QUOTA_NAME = "SeIncreaseQuotaPrivilege"
Global Const $SE_LOAD_DRIVER_NAME = "SeLoadDriverPrivilege"
Global Const $SE_LOCK_MEMORY_NAME = "SeLockMemoryPrivilege"
Global Const $SE_MACHINE_ACCOUNT_NAME = "SeMachineAccountPrivilege"
Global Const $SE_MANAGE_VOLUME_NAME = "SeManageVolumePrivilege"
Global Const $SE_PROF_SINGLE_PROCESS_NAME = "SeProfileSingleProcessPrivilege"
Global Const $SE_REMOTE_SHUTDOWN_NAME = "SeRemoteShutdownPrivilege"
Global Const $SE_RESTORE_NAME = "SeRestorePrivilege"
Global Const $SE_SECURITY_NAME = "SeSecurityPrivilege"
Global Const $SE_SHUTDOWN_NAME = "SeShutdownPrivilege"
Global Const $SE_SYNC_AGENT_NAME = "SeSyncAgentPrivilege"
Global Const $SE_SYSTEM_ENVIRONMENT_NAME = "SeSystemEnvironmentPrivilege"
Global Const $SE_SYSTEM_PROFILE_NAME = "SeSystemProfilePrivilege"
Global Const $SE_SYSTEMTIME_NAME = "SeSystemtimePrivilege"
Global Const $SE_TAKE_OWNERSHIP_NAME = "SeTakeOwnershipPrivilege"
Global Const $SE_TCB_NAME = "SeTcbPrivilege"
Global Const $SE_UNSOLICITED_INPUT_NAME = "SeUnsolicitedInputPrivilege"
Global Const $SE_UNDOCK_NAME = "SeUndockPrivilege"
Global Const $SE_PRIVILEGE_ENABLED_BY_DEFAULT = 1
Global Const $SE_PRIVILEGE_ENABLED = 2
Global Const $SE_PRIVILEGE_REMOVED = 4
Global Const $SE_PRIVILEGE_USED_FOR_ACCESS = -2147483648
Global Const $TOKENUSER = 1
Global Const $TOKENGROUPS = 2
Global Const $TOKENPRIVILEGES = 3
Global Const $TOKENOWNER = 4
Global Const $TOKENPRIMARYGROUP = 5
Global Const $TOKENDEFAULTDACL = 6
Global Const $TOKENSOURCE = 7
Global Const $TOKENTYPE = 8
Global Const $TOKENIMPERSONATIONLEVEL = 9
Global Const $TOKENSTATISTICS = 10
Global Const $TOKENRESTRICTEDSIDS = 11
Global Const $TOKENSESSIONID = 12
Global Const $TOKENGROUPSANDPRIVILEGES = 13
Global Const $TOKENSESSIONREFERENCE = 14
Global Const $TOKENSANDBOXINERT = 15
Global Const $TOKENAUDITPOLICY = 16
Global Const $TOKENORIGIN = 17
Global Const $TOKENELEVATIONTYPE = 18
Global Const $TOKENLINKEDTOKEN = 19
Global Const $TOKENELEVATION = 20
Global Const $TOKENHASRESTRICTIONS = 21
Global Const $TOKENACCESSINFORMATION = 22
Global Const $TOKENVIRTUALIZATIONALLOWED = 23
Global Const $TOKENVIRTUALIZATIONENABLED = 24
Global Const $TOKENINTEGRITYLEVEL = 25
Global Const $TOKENUIACCESS = 26
Global Const $TOKENMANDATORYPOLICY = 27
Global Const $TOKENLOGONSID = 28
Global Const $TAGNMHDR = "hwnd hWndFrom;int IDFrom;int Code"
Global Const $TAGCOMBOBOXINFO = "dword Size;int EditLeft;int EditTop;int EditRight;int EditBottom;int BtnLeft;int BtnTop;" & "int BtnRight;int BtnBottom;dword BtnState;hwnd hCombo;hwnd hEdit;hwnd hList"
Global Const $TAGCOMBOBOXEXITEM = "int Mask;int Item;ptr Text;int TextMax;int Image;int SelectedImage;int OverlayImage;" & "int Indent;int Param"
Global Const $TAGNMCBEDRAGBEGIN = $TAGNMHDR & ";int ItemID;char Text[1024]"
Global Const $TAGNMCBEENDEDIT = $TAGNMHDR & ";int fChanged;int NewSelection;char Text[1024];int Why"
Global Const $TAGNMCOMBOBOXEX = $TAGNMHDR & ";int Mask;int Item;ptr Text;int TextMax;int Image;" & "int SelectedImage;int OverlayImage;int Indent;int Param"
Global Const $TAGDTPRANGE = "short MinYear;short MinMonth;short MinDOW;short MinDay;short MinHour;short MinMinute;" & "short MinSecond;short MinMSecond;short MaxYear;short MaxMonth;short MaxDOW;short MaxDay;short MaxHour;" & "short MaxMinute;short MaxSecond;short MaxMSecond;int MinValid;int MaxValid"
Global Const $TAGDTPTIME = "short Year;short Month;short DOW;short Day;short Hour;short Minute;short Second;short MSecond"
Global Const $TAGNMDATETIMECHANGE = $TAGNMHDR & ";int Flag;short Year;short Month;short DOW;short Day;" & "short Hour;short Minute;short Second;short MSecond"
Global Const $TAGNMDATETIMEFORMAT = $TAGNMHDR & ";ptr Format;short Year;short Month;short DOW;short Day;" & "short Hour;short Minute;short Second;short MSecond;ptr pDisplay;char Display[64]"
Global Const $TAGNMDATETIMEFORMATQUERY = $TAGNMHDR & ";ptr Format;int SizeX;int SizeY"
Global Const $TAGNMDATETIMEKEYDOWN = $TAGNMHDR & ";int VirtKey;ptr Format;short Year;short Month;short DOW;" & "short Day;short Hour;short Minute;short Second;short MSecond"
Global Const $TAGNMDATETIMESTRING = $TAGNMHDR & ";ptr UserString;short Year;short Month;short DOW;short Day;" & "short Hour;short Minute;short Second;short MSecond;int Flags"
Global Const $TAGEDITBALLOONTIP = "dword Size;ptr Title;ptr Text;int Icon"
Global Const $TAGEVENTLOGRECORD = "int Length;int Reserved;int RecordNumber;int TimeGenerated;int TimeWritten;int EventID;" & "short EventType;short NumStrings;short EventCategory;short ReservedFlags;int ClosingRecordNumber;int StringOffset;" & "int UserSidLength;int UserSidOffset;int DataLength;int DataOffset"
Global Const $TAGEVENTREAD = "byte Buffer[4096];int BytesRead;int BytesMin"
Global Const $TAGGDIPBITMAPDATA = "uint Width;uint Height;int Stride;uint Format;ptr Scan0;ptr Reserved"
Global Const $TAGGDIPENCODERPARAM = "byte GUID[16];dword Count;dword Type;ptr Values"
Global Const $TAGGDIPENCODERPARAMS = "dword Count;byte Params[0]"
Global Const $TAGGDIPRECTF = "float X;float Y;float Width;float Height"
Global Const $TAGGDIPSTARTUPINPUT = "int Version;ptr Callback;int NoThread;int NoCodecs"
Global Const $TAGGDIPSTARTUPOUTPUT = "ptr HookProc;ptr UnhookProc"
Global Const $TAGGDIPIMAGECODECINFO = "byte CLSID[16];byte FormatID[16];ptr CodecName;ptr DllName;ptr FormatDesc;ptr FileExt;" & "ptr MimeType;dword Flags;dword Version;dword SigCount;dword SigSize;ptr SigPattern;ptr SigMask"
Global Const $TAGGDIPPENCODERPARAMS = "dword Count;byte Params[0]"
Global Const $TAGHDHITTESTINFO = "int X;int Y;int Flags;int Item"
Global Const $TAGHDITEM = "int Mask;int XY;ptr Text;hwnd hBMP;int TextMax;int Fmt;int Param;int Image;int Order;int Type;ptr pFilter;int State"
Global Const $TAGHDLAYOUT = "ptr Rect;ptr WindowPos"
Global Const $TAGHDTEXTFILTER = "ptr Text;int TextMax"
Global Const $TAGNMHDDISPINFO = "hwnd WndFrom;int IDFrom;int Code;int Item;int Mask;ptr Text;int TextMax;int Image;int lParam"
Global Const $TAGNMHDFILTERBTNCLICK = $TAGNMHDR & ";int Item;int Left;int Top;int Right;int Bottom"
Global Const $TAGNMHEADER = $TAGNMHDR & ";int Item;int Button;ptr pItem"
Global Const $TAGGETIPADDRESS = "ubyte Field4;ubyte Field3;ubyte Field2;ubyte Field1"
Global Const $TAGNMIPADDRESS = $TAGNMHDR & ";int Field;int Value"
Global Const $TAGLVBKIMAGE = "int Flags;hwnd hBmp;int Image;int ImageMax;int XOffPercent;int YOffPercent"
Global Const $TAGLVCOLUMN = "int Mask;int Fmt;int CX;ptr Text;int TextMax;int SubItem;int Image;int Order"
Global Const $TAGLVFINDINFO = "int Flags;ptr Text;int Param;int X;int Y;int Direction"
Global Const $TAGLVGROUP = "int Size;int Mask;ptr Header;int HeaderMax;ptr Footer;int FooterMax;int GroupID;int StateMask;int State;int Align"
Global Const $TAGLVHITTESTINFO = "int X;int Y;int Flags;int Item;int SubItem"
Global Const $TAGLVINSERTMARK = "uint Size;dword Flags;int Item;dword Reserved"
Global Const $TAGLVITEM = "int Mask;int Item;int SubItem;int State;int StateMask;ptr Text;int TextMax;int Image;int Param;" & "int Indent;int GroupID;int Columns;ptr pColumns"
Global Const $TAGNMLISTVIEW = $TAGNMHDR & ";int Item;int SubItem;int NewState;int OldState;int Changed;" & "int ActionX;int ActionY;int Param"
Global Const $TAGNMLVCUSTOMDRAW = $TAGNMHDR & ";dword dwDrawStage;hwnd hdc;int Left;int Top;int Right;int Bottom;" & "dword dwItemSpec;uint uItemState;long lItemlParam;int clrText;int clrTextBk;int iSubItem;dword dwItemType;int clrFace;int iIconEffect;" & "int iIconPhase;int iPartId;int iStateId;int TextLeft;int TextTop;int TextRight;int TextBottom;uint uAlign"
Global Const $TAGNMLVDISPINFO = $TAGNMHDR & ";int Mask;int Item;int SubItem;int State;int StateMask;" & "ptr Text;int TextMax;int Image;int Param;int Indent;int GroupID;int Columns;ptr pColumns"
Global Const $TAGNMLVFINDITEM = $TAGNMHDR & ";int Start;int Flags;ptr Text;int Param;int X;int Y;int Direction"
Global Const $TAGNMLVGETINFOTIP = $TAGNMHDR & ";int Flags;ptr Text;int TextMax;int Item;int SubItem;int lParam"
Global Const $TAGNMITEMACTIVATE = $TAGNMHDR & ";int Index;int SubItem;int NewState;int OldState;" & "int Changed;int X;int Y;int lParam;int KeyFlags"
Global Const $TAGNMLVKEYDOWN = $TAGNMHDR & ";int VKey;int Flags"
Global Const $TAGNMLVSCROLL = $TAGNMHDR & ";int DX;int DY"
Global Const $TAGLVSETINFOTIP = "int Size;int Flags;ptr Text;int Item;int SubItem"
Global Const $TAGMCHITTESTINFO = "int Size;int X;int Y;int Hit;short Year;short Month;short DOW;short Day;short Hour;" & "short Minute;short Second;short MSeconds"
Global Const $TAGMCMONTHRANGE = "short MinYear;short MinMonth;short MinDOW;short MinDay;short MinHour;short MinMinute;short MinSecond;" & "short MinMSeconds;short MaxYear;short MaxMonth;short MaxDOW;short MaxDay;short MaxHour;short MaxMinute;short MaxSecond;" & "short MaxMSeconds;short Span"
Global Const $TAGMCRANGE = "short MinYear;short MinMonth;short MinDOW;short MinDay;short MinHour;short MinMinute;short MinSecond;" & "short MinMSeconds;short MaxYear;short MaxMonth;short MaxDOW;short MaxDay;short MaxHour;short MaxMinute;short MaxSecond;" & "short MaxMSeconds;short MinSet;short MaxSet"
Global Const $TAGMCSELRANGE = "short MinYear;short MinMonth;short MinDOW;short MinDay;short MinHour;short MinMinute;short MinSecond;" & "short MinMSeconds;short MaxYear;short MaxMonth;short MaxDOW;short MaxDay;short MaxHour;short MaxMinute;short MaxSecond;" & "short MaxMSeconds"
Global Const $TAGNMDAYSTATE = $TAGNMHDR & ";short Year;short Month;short DOW;short Day;short Hour;" & "short Minute;short Second;short MSeconds;int DayState;ptr pDayState"
Global Const $TAGNMSELCHANGE = $TAGNMHDR & ";short BegYear;short BegMonth;short BegDOW;short BegDay;" & "short BegHour;short BegMinute;short BegSecond;short BegMSeconds;short EndYear;short EndMonth;short EndDOW;" & "short EndDay;short EndHour;short EndMinute;short EndSecond;short EndMSeconds"
Global Const $TAGNMOBJECTNOTIFY = $TAGNMHDR & ";int Item;ptr piid;ptr pObject;int Result"
Global Const $TAGNMTCKEYDOWN = $TAGNMHDR & ";int VKey;int Flags"
Global Const $TAGTCITEM = "int Mask;int State;int StateMask;ptr Text;int TextMax;int Image;int Param"
Global Const $TAGTCHITTESTINFO = "int X;int Y;int Flags"
Global Const $TAGTVITEMEX = "int Mask;int hItem;int State;int StateMask;ptr Text;int TextMax;int Image;int SelectedImage;" & "int Children;int Param;int Integral"
Global Const $TAGNMTREEVIEW = $TAGNMHDR & ";int Action;int OldMask;int OldhItem;int OldState;int OldStateMask;" & "ptr OldText;int OldTextMax;int OldImage;int OldSelectedImage;int OldChildren;int OldParam;int NewMask;int NewhItem;" & "int NewState;int NewStateMask;ptr NewText;int NewTextMax;int NewImage;int NewSelectedImage;int NewChildren;" & "int NewParam;int PointX; int PointY"
Global Const $TAGNMTVCUSTOMDRAW = $TAGNMHDR & ";uint DrawStage;hwnd HDC;int Left;int Top;int Right;int Bottom;" & "ptr ItemSpec;uint ItemState;int ItemParam;int ClrText;int ClrTextBk;int Level"
Global Const $TAGNMTVDISPINFO = $TAGNMHDR & ";int Mask;int hItem;int State;int StateMask;" & "ptr Text;int TextMax;int Image;int SelectedImage;int Children;int Param"
Global Const $TAGNMTVGETINFOTIP = $TAGNMHDR & ";ptr Text;int TextMax;hwnd hItem;int lParam"
Global Const $TAGTVHITTESTINFO = "int X;int Y;int Flags;int Item"
Global Const $TAGTVINSERTSTRUCT = "hwnd Parent;int InsertAfter;int Mask;hwnd hItem;int State;int StateMask;ptr Text;int TextMax;" & "int Image;int SelectedImage;int Children;int Param"
Global Const $TAGNMTVKEYDOWN = $TAGNMHDR & ";int VKey;int Flags"
Global Const $TAGNMTTDISPINFO = $TAGNMHDR & ";ptr pText;char aText[80];hwnd Instance;int Flags;int Param"
Global Const $TAGTOOLINFO = "int Size;int Flags;hwnd hWnd;int ID;int Left;int Top;int Right;int Bottom;hwnd hInst;ptr Text;int Param;ptr Reserved"
Global Const $TAGTTGETTITLE = "int Size;int Bitmap;int TitleMax;ptr Title"
Global Const $TAGTTHITTESTINFO = "hwnd Tool;int X;int Y;int Size;int Flags;hwnd hWnd;int ID;int Left;int Top;int Right;int Bottom;" & "hwnd hInst;ptr Text;int Param;ptr Reserved"
Global Const $TAGNMMOUSE = $TAGNMHDR & ";dword ItemSpec;dword ItemData;int X;int Y;dword HitInfo"
Global Const $TAGPOINT = "int X;int Y"
Global Const $TAGRECT = "int Left;int Top;int Right;int Bottom"
Global Const $TAGMARGINS = "int cxLeftWidth;int cxRightWidth;int cyTopHeight;int cyBottomHeight"
Global Const $TAGSIZE = "int X;int Y"
Global Const $TAGTOKEN_PRIVILEGES = "int Count;int64 LUID;int Attributes"
Global Const $TAGIMAGEINFO = "hwnd hBitmap;hwnd hMask;int Unused1;int Unused2;int Left;int Top;int Right;int Bottom"
Global Const $TAGIMAGELISTDRAWPARAMS = "int Size;hwnd hWnd;int Image;hwnd hDC;int X;int Y;int CX;int CY;int XBitmap;int YBitmap;" & "int BK;int FG;int Style;int ROP;int State;int Frame;int Effect"
Global Const $TAGMEMMAP = "hwnd hProc;int Size;ptr Mem"
Global Const $TAGMDINEXTMENU = "hwnd hMenuIn;hwnd hMenuNext;hwnd hWndNext"
Global Const $TAGMENUBARINFO = "int Size;int Left;int Top;int Right;int Bottom;int hMenu;int hWndMenu;int Focused"
Global Const $TAGMENUEX_TEMPLATE_HEADER = "short Version;short Offset;int HelpID"
Global Const $TAGMENUEX_TEMPLATE_ITEM = "int HelpID;int Type;int State;int MenuID;short ResInfo;ptr Text"
Global Const $TAGMENUGETOBJECTINFO = "int Flags;int Pos;hwnd hMenu;ptr RIID;ptr Obj"
Global Const $TAGMENUINFO = "int Size;int Mask;int Style;int YMax;int hBack;int ContextHelpID;ptr MenuData"
Global Const $TAGMENUITEMINFO = "int Size;int Mask;int Type;int State;int ID;int SubMenu;int BmpChecked;int BmpUnchecked;" & "int ItemData;ptr TypeData;int CCH;int BmpItem"
Global Const $TAGMENUITEMTEMPLATE = "short Option;short ID;ptr String"
Global Const $TAGMENUITEMTEMPLATEHEADER = "short Version;short Offset"
Global Const $TAGTPMPARAMS = "short Version;short Offset"
Global Const $TAGCONNECTION_INFO_1 = "int ID;int Type;int Opens;int Users;int Time;ptr Username;ptr NetName"
Global Const $TAGFILE_INFO_3 = "int ID;int Permissions;int Locks;ptr Pathname;ptr Username"
Global Const $TAGSESSION_INFO_2 = "ptr CName;ptr Username;int Opens;int Time;int Idle;int Flags;ptr TypeName"
Global Const $TAGSESSION_INFO_502 = "ptr CName;ptr Username;int Opens;int Time;int Idle;int Flags;ptr TypeName;ptr Transport"
Global Const $TAGSHARE_INFO_2 = "ptr NetName;int Type;ptr Remark;int Permissions;int MaxUses;int CurrentUses;ptr Path;ptr Password"
Global Const $TAGSTAT_SERVER_0 = "int Start;int FOpens;int DevOpens;int JobsQueued;int SOpens;int STimedOut;int SErrorOut;" & "int PWErrors;int PermErrors;int SysErrors;int64 ByteSent;int64 ByteRecv;int AvResponse;int ReqBufNeed;int BigBufNeed"
Global Const $TAGSTAT_WORKSTATION_0 = "int64 StartTime;int64 BytesRecv;int64 SMBSRecv;int64 PageRead;int64 NonPageRead;" & "int64 CacheRead;int64 NetRead;int64 BytesTran;int64 SMBSTran;int64 PageWrite;int64 NonPageWrite;int64 CacheWrite;" & "int64 NetWrite;int InitFailed;int FailedComp;int ReadOp;int RandomReadOp;int ReadSMBS;int LargeReadSMBS;" & "int SmallReadSMBS;int WriteOp;int RandomWriteOp;int WriteSMBS;int LargeWriteSMBS;int SmallWriteSMBS;" & "int RawReadsDenied;int RawWritesDenied;int NetworkErrors;int Sessions;int FailedSessions;int Reconnects;" & "int CoreConnects;int LM20Connects;int LM21Connects;int LMNTConnects;int ServerDisconnects;int HungSessions;" & "int UseCount;int FailedUseCount;int CurrentCommands"
Global Const $TAGFILETIME = "dword Lo;dword Hi"
Global Const $TAGSYSTEMTIME = "short Year;short Month;short Dow;short Day;short Hour;short Minute;short Second;short MSeconds"
Global Const $TAGTIME_ZONE_INFORMATION = "long Bias;byte StdName[64];ushort StdDate[8];long StdBias;byte DayName[64];ushort DayDate[8];long DayBias"
Global Const $TAGPBRANGE = "int Low;int High"
Global Const $TAGREBARBANDINFO = "uint cbSize;uint fMask;uint fStyle;dword clrFore;dword clrBack;ptr lpText;uint cch;" & "int iImage;hwnd hwndChild;uint cxMinChild;uint cyMinChild;uint cx;hwnd hbmBack;uint wID;uint cyChild;uint cyMaxChild;" & "uint cyIntegral;uint cxIdeal;int lParam;uint cxHeader"
Global Const $TAGNMREBARAUTOBREAK = $TAGNMHDR & ";uint uBand;uint wID;int lParam;uint uMsg;uint fStyleCurrent;int fAutoBreak"
Global Const $TAGNMRBAUTOSIZE = $TAGNMHDR & ";int fChanged;int TargetLeft;int TargetTop;int TargetRight;int TargetBottom;" & "int ActualLeft;int ActualTop;int ActualRight;int ActualBottom"
Global Const $TAGNMREBAR = $TAGNMHDR & ";dword dwMask;uint uBand;uint fStyle;uint wID;int lParam"
Global Const $TAGNMREBARCHEVRON = $TAGNMHDR & ";uint uBand;uint wID;int lParam;int Left;int Top;int Right;int Bottom;int lParamNM"
Global Const $TAGNMREBARCHILDSIZE = $TAGNMHDR & ";uint uBand;uint wID;int CLeft;int CTop;int CRight;int CBottom;" & "int BLeft;int BTop;int BRight;int BBottom"
Global Const $TAGREBARINFO = "uint cbSize;uint fMask;hwnd himl"
Global Const $TAGRBHITTESTINFO = "int X;int Y;uint flags;int iBand"
Global Const $TAGCOLORSCHEME = "int Size;int BtnHighlight;int BtnShadow"
Global Const $TAGTBADDBITMAP = "int hInst;int ID"
Global Const $TAGNMTOOLBAR = $TAGNMHDR & ";int iItem;int iBitmap;int idCommand;" & "byte fsState;byte fsStyle;byte bReserved1;byte bReserved2;dword dwData;int iString;int cchText;" & "ptr pszText;int Left;int Top;int Right;int Bottom"
Global Const $TAGNMTBHOTITEM = $TAGNMHDR & ";int idOld;int idNew;dword dwFlags"
Global Const $TAGTBBUTTON = "int Bitmap;int Command;byte State;byte Style;short Reserved;int Param;int String"
Global Const $TAGTBBUTTONINFO = "int Size;int Mask;int Command;int Image;byte State;byte Style;short CX;int Param;ptr Text;int TextMax"
Global Const $TAGTBINSERTMARK = "int Button;int Flags"
Global Const $TAGTBMETRICS = "int Size;int Mask;int XPad;int YPad;int XBarPad;int YBarPad;int XSpacing;int YSpacing"
Global Const $TAGCONNECTDLGSTRUCT = "int Size;hwnd hWnd;ptr Resource;int Flags;int DevNum"
Global Const $TAGDISCDLGSTRUCT = "int Size;hwnd hWnd;ptr LocalName;ptr RemoteName;int Flags"
Global Const $TAGNETCONNECTINFOSTRUCT = "int Size;int Flags;int Speed;int Delay;int OptDataSize"
Global Const $TAGNETINFOSTRUCT = "int Size;int Version;int Status;int Char;int Handle;short NetType;int Printers;int Drives;short Reserved"
Global Const $TAGNETRESOURCE = "int Scope;int Type;int DisplayType;int Usage;ptr LocalName;ptr RemoteName;ptr Comment;ptr Provider"
Global Const $TAGREMOTENAMEINFO = "ptr Universal;ptr Connection;ptr Remaining"
Global Const $TAGOVERLAPPED = "int Internal;int InternalHigh;int Offset;int OffsetHigh;int hEvent"
Global Const $TAGOPENFILENAME = "dword StructSize;hwnd hwndOwner;hwnd hInstance;ptr lpstrFilter;ptr lpstrCustomFilter;" & "dword nMaxCustFilter;dword nFilterIndex;ptr lpstrFile;dword nMaxFile;ptr lpstrFileTitle;int nMaxFileTitle;" & "ptr lpstrInitialDir;ptr lpstrTitle;dword Flags;short nFileOffset;short nFileExtension;ptr lpstrDefExt;ptr lCustData;" & "ptr lpfnHook;ptr lpTemplateName;ptr pvReserved;dword dwReserved;dword FlagsEx"
Global Const $TAGBITMAPINFO = "dword Size;long Width;long Height;ushort Planes;ushort BitCount;dword Compression;dword SizeImage;" & "long XPelsPerMeter;long YPelsPerMeter;dword ClrUsed;dword ClrImportant;dword RGBQuad"
Global Const $TAGBLENDFUNCTION = "byte Op;byte Flags;byte Alpha;byte Format"
Global Const $TAGBORDERS = "int BX;int BY;int RX"
Global Const $TAGCHOOSECOLOR = "dword Size;hwnd hWndOwnder;hwnd hInstance;int rgbResult;int_ptr CustColors;dword Flags;int_ptr lCustData;" & "ptr lpfnHook;ptr lpTemplateName"
Global Const $TAGCHOOSEFONT = "dword Size;hwnd hWndOwner;hwnd hDC;ptr LogFont;int PointSize;dword Flags;int rgbColors;int_ptr CustData;" & "ptr fnHook;ptr TemplateName;hwnd hInstance;ptr szStyle;ushort FontType;int SizeMin;int SizeMax"
Global Const $TAGTEXTMETRIC = "long tmHeight;long tmAscent;long tmDescent;long tmInternalLeading;long tmExternalLeading;" & "long tmAveCharWidth;long tmMaxCharWidth;long tmWeight;long tmOverhang;long tmDigitizedAspectX;long tmDigitizedAspectY;" & "char tmFirstChar;char tmLastChar;char tmDefaultChar;char tmBreakChar;byte tmItalic;byte tmUnderlined;byte tmStruckOut;" & "byte tmPitchAndFamily;byte tmCharSet"
Global Const $TAGCURSORINFO = "int Size;int Flags;hwnd hCursor;int X;int Y"
Global Const $TAGDISPLAY_DEVICE = "int Size;char Name[32];char String[128];int Flags;char ID[128];char Key[128]"
Global Const $TAGFLASHWINDOW = "int Size;hwnd hWnd;int Flags;int Count;int TimeOut"
Global Const $TAGGUID = "int Data1;short Data2;short Data3;byte Data4[8]"
Global Const $TAGICONINFO = "int Icon;int XHotSpot;int YHotSpot;hwnd hMask;hwnd hColor"
Global Const $TAGWINDOWPLACEMENT = "UINT length; UINT flags; UINT showCmd; int ptMinPosition[2]; int ptMaxPosition[2]; int rcNormalPosition[4]"
Global Const $TAGWINDOWPOS = "hwnd hWnd;int InsertAfter;int X;int Y;int CX;int CY;int Flags"
Global Const $TAGSCROLLINFO = "uint cbSize;uint fMask;int  nMin;int  nMax;uint nPage;int  nPos;int  nTrackPos"
Global Const $TAGSCROLLBARINFO = "dword cbSize;int Left;int Top;int Right;int Bottom;int dxyLineButton;int xyThumbTop;" & "int xyThumbBottom;int reserved;dword rgstate[6]"
Global Const $TAGLOGFONT = "int Height;int Width;int Escapement;int Orientation;int Weight;byte Italic;byte Underline;" & "byte Strikeout;byte CharSet;byte OutPrecision;byte ClipPrecision;byte Quality;byte PitchAndFamily;char FaceName[32]"
Global Const $TAGKBDLLHOOKSTRUCT = "dword vkCode;dword scanCode;dword flags;dword time;ulong_ptr dwExtraInfo"
Global Const $TAGPROCESS_INFORMATION = "hwnd hProcess;hwnd hThread;int ProcessID;int ThreadID"
Global Const $TAGSTARTUPINFO = "int Size;ptr Reserved1;ptr Desktop;ptr Title;int X;int Y;int XSize;int YSize;int XCountChars;" & "int YCountChars;int FillAttribute;int Flags;short ShowWindow;short Reserved2;ptr Reserved3;int StdInput;" & "int StdOutput;int StdError"
Global Const $TAGSECURITY_ATTRIBUTES = "int Length;ptr Descriptor;int InheritHandle"
Global Const $__SECURITYCONTANT_FORMAT_MESSAGE_FROM_SYSTEM = 4096

Func _SECURITY__ADJUSTTOKENPRIVILEGES($HTOKEN, $FDISABLEALL, $PNEWSTATE, $IBUFFERLEN, $PPREVSTATE = 0, $PREQUIRED = 0)
	Local $ARESULT
	$ARESULT = DllCall("Advapi32.dll", "int", "AdjustTokenPrivileges", "hwnd", $HTOKEN, "int", $FDISABLEALL, "ptr", $PNEWSTATE, "int", $IBUFFERLEN, "ptr", $PPREVSTATE, "ptr", $PREQUIRED)
	Return SetError($ARESULT[0] = 0, 0, $ARESULT[0] <> 0)
EndFunc


Func _SECURITY__GETACCOUNTSID($SACCOUNT, $SSYSTEM = "")
	Local $AACCT
	$AACCT = _SECURITY__LOOKUPACCOUNTNAME($SACCOUNT, $SSYSTEM)
	If @error Then Return SetError(@error, 0, 0)
	Return _SECURITY__STRINGSIDTOSID($AACCT[0])
EndFunc


Func _SECURITY__GETLENGTHSID($PSID)
	Local $ARESULT
	If Not _SECURITY__ISVALIDSID($PSID) Then Return SetError(-1, 0, 0)
	$ARESULT = DllCall("AdvAPI32.dll", "int", "GetLengthSid", "ptr", $PSID)
	Return $ARESULT[0]
EndFunc


Func _SECURITY__GETTOKENINFORMATION($HTOKEN, $ICLASS)
	Local $PBUFFER, $TBUFFER, $ARESULT
	$ARESULT = DllCall("Advapi32.dll", "int", "GetTokenInformation", "hwnd", $HTOKEN, "int", $ICLASS, "ptr", 0, "int", 0, "int*", 0)
	$TBUFFER = DllStructCreate("byte[" & $ARESULT[5] & "]")
	$PBUFFER = DllStructGetPtr($TBUFFER)
	$ARESULT = DllCall("Advapi32.dll", "int", "GetTokenInformation", "hwnd", $HTOKEN, "int", $ICLASS, "ptr", $PBUFFER, "int", $ARESULT[5], "int*", 0)
	If $ARESULT[0] = 0 Then Return SetError(-1, 0, 0)
	Return SetError(0, 0, $TBUFFER)
EndFunc


Func _SECURITY__IMPERSONATESELF($ILEVEL = 2)
	Local $ARESULT
	$ARESULT = DllCall("Advapi32.dll", "int", "ImpersonateSelf", "int", $ILEVEL)
	Return SetError($ARESULT[0] = 0, 0, $ARESULT[0] <> 0)
EndFunc


Func _SECURITY__ISVALIDSID($PSID)
	Local $ARESULT
	$ARESULT = DllCall("AdvAPI32.dll", "int", "IsValidSid", "ptr", $PSID)
	Return $ARESULT[0] <> 0
EndFunc


Func _SECURITY__LOOKUPACCOUNTNAME($SACCOUNT, $SSYSTEM = "")
	Local $TDATA, $PDOMAIN, $PSID, $PSIZE1, $PSIZE2, $PSNU, $ARESULT, $AACCT[3]
	$TDATA = DllStructCreate("byte SID[256];char Domain[256];int SNU;int Size1;int Size2")
	$PSID = DllStructGetPtr($TDATA, "SID")
	$PDOMAIN = DllStructGetPtr($TDATA, "Domain")
	$PSNU = DllStructGetPtr($TDATA, "SNU")
	$PSIZE1 = DllStructGetPtr($TDATA, "Size1")
	$PSIZE2 = DllStructGetPtr($TDATA, "Size2")
	DllStructSetData($TDATA, "Size1", 256)
	DllStructSetData($TDATA, "Size2", 256)
	$ARESULT = DllCall("AdvAPI32.dll", "int", "LookupAccountName", "str", $SSYSTEM, "str", $SACCOUNT, "ptr", $PSID, "ptr", $PSIZE1, "ptr", $PDOMAIN, "ptr", $PSIZE2, "ptr", $PSNU)
	If $ARESULT[0] <> 0 Then
		$AACCT[0] = _SECURITY__SIDTOSTRINGSID($PSID)
		$AACCT[1] = DllStructGetData($TDATA, "Domain")
		$AACCT[2] = DllStructGetData($TDATA, "SNU")
	EndIf
	Return SetError($ARESULT[0] = 0, 0, $AACCT)
EndFunc


Func _SECURITY__LOOKUPACCOUNTSID($VSID)
	Local $TDATA, $PDOMAIN, $PNAME, $PSID, $TSID, $PSIZE1, $PSIZE2, $PSNU, $ARESULT, $AACCT[3]
	If IsString($VSID) Then
		$TSID = _SECURITY__STRINGSIDTOSID($VSID)
		$PSID = DllStructGetPtr($TSID)
	Else
		$PSID = $VSID
	EndIf
	If Not _SECURITY__ISVALIDSID($PSID) Then Return SetError(-1, 0, 0)
	$TDATA = DllStructCreate("char Name[256];char Domain[256];int SNU;int Size1;int Size2")
	$PNAME = DllStructGetPtr($TDATA, "Name")
	$PDOMAIN = DllStructGetPtr($TDATA, "Domain")
	$PSNU = DllStructGetPtr($TDATA, "SNU")
	$PSIZE1 = DllStructGetPtr($TDATA, "Size1")
	$PSIZE2 = DllStructGetPtr($TDATA, "Size2")
	DllStructSetData($TDATA, "Size1", 256)
	DllStructSetData($TDATA, "Size2", 256)
	$ARESULT = DllCall("AdvAPI32.dll", "int", "LookupAccountSid", "int", 0, "ptr", $PSID, "ptr", $PNAME, "ptr", $PSIZE1, "ptr", $PDOMAIN, "ptr", $PSIZE2, "ptr", $PSNU)
	$AACCT[0] = DllStructGetData($TDATA, "Name")
	$AACCT[1] = DllStructGetData($TDATA, "Domain")
	$AACCT[2] = DllStructGetData($TDATA, "SNU")
	Return SetError($ARESULT[0] = 0, 0, $AACCT)
EndFunc


Func _SECURITY__LOOKUPPRIVILEGEVALUE($SSYSTEM, $SNAME)
	Local $TDATA, $ARESULT
	$TDATA = DllStructCreate("int64 LUID")
	$ARESULT = DllCall("Advapi32.dll", "int", "LookupPrivilegeValue", "str", $SSYSTEM, "str", $SNAME, "ptr", DllStructGetPtr($TDATA))
	Return SetError($ARESULT[0] = 0, 0, DllStructGetData($TDATA, "LUID"))
EndFunc


Func _SECURITY__OPENPROCESSTOKEN($HPROCESS, $IACCESS)
	Local $ARESULT
	$ARESULT = DllCall("Advapi32.dll", "int", "OpenProcessToken", "hwnd", $HPROCESS, "dword", $IACCESS, "int*", 0)
	Return SetError($ARESULT[0], 0, $ARESULT[3])
EndFunc


Func _SECURITY__OPENTHREADTOKEN($IACCESS, $HTHREAD = 0, $FOPENASSELF = False)
	Local $TDATA, $PTOKEN, $ARESULT
	If $HTHREAD = 0 Then $HTHREAD = _WINAPI_GETCURRENTTHREAD()
	$TDATA = DllStructCreate("int Token")
	$PTOKEN = DllStructGetPtr($TDATA, "Token")
	$ARESULT = DllCall("Advapi32.dll", "int", "OpenThreadToken", "int", $HTHREAD, "int", $IACCESS, "int", $FOPENASSELF, "ptr", $PTOKEN)
	Return SetError($ARESULT[0] = 0, 0, DllStructGetData($TDATA, "Token"))
EndFunc


Func _SECURITY__OPENTHREADTOKENEX($IACCESS, $HTHREAD = 0, $FOPENASSELF = False)
	Local $HTOKEN
	$HTOKEN = _SECURITY__OPENTHREADTOKEN($IACCESS, $HTHREAD, $FOPENASSELF)
	If $HTOKEN = 0 Then
		If _WINAPI_GETLASTERROR() = $ERROR_NO_TOKEN Then
			If Not _SECURITY__IMPERSONATESELF() Then Return SetError(-1, _WINAPI_GETLASTERROR(), 0)
			$HTOKEN = _SECURITY__OPENTHREADTOKEN($IACCESS, $HTHREAD, $FOPENASSELF)
			If $HTOKEN = 0 Then Return SetError(-2, _WINAPI_GETLASTERROR(), 0)
		Else
			Return SetError(-3, _WINAPI_GETLASTERROR(), 0)
		EndIf
	EndIf
	Return SetError(0, 0, $HTOKEN)
EndFunc


Func _SECURITY__SETPRIVILEGE($HTOKEN, $SPRIVILEGE, $FENABLE)
	Local $PREQUIRED, $TREQUIRED, $ILUID, $IATTRIBUTES, $ICURRSTATE, $PCURRSTATE, $TCURRSTATE, $IPREVSTATE, $PPREVSTATE, $TPREVSTATE
	$ILUID = _SECURITY__LOOKUPPRIVILEGEVALUE("", $SPRIVILEGE)
	If $ILUID = 0 Then Return SetError(-1, 0, False)
	$TCURRSTATE = DllStructCreate($TAGTOKEN_PRIVILEGES)
	$PCURRSTATE = DllStructGetPtr($TCURRSTATE)
	$ICURRSTATE = DllStructGetSize($TCURRSTATE)
	$TPREVSTATE = DllStructCreate($TAGTOKEN_PRIVILEGES)
	$PPREVSTATE = DllStructGetPtr($TPREVSTATE)
	$IPREVSTATE = DllStructGetSize($TPREVSTATE)
	$TREQUIRED = DllStructCreate("int Data")
	$PREQUIRED = DllStructGetPtr($TREQUIRED)
	DllStructSetData($TCURRSTATE, "Count", 1)
	DllStructSetData($TCURRSTATE, "LUID", $ILUID)
	If Not _SECURITY__ADJUSTTOKENPRIVILEGES($HTOKEN, False, $PCURRSTATE, $ICURRSTATE, $PPREVSTATE, $PREQUIRED) Then
		Return SetError(-2, @error, False)
	EndIf
	DllStructSetData($TPREVSTATE, "Count", 1)
	DllStructSetData($TPREVSTATE, "LUID", $ILUID)
	$IATTRIBUTES = DllStructGetData($TPREVSTATE, "Attributes")
	If $FENABLE Then
		$IATTRIBUTES = BitOR($IATTRIBUTES, $SE_PRIVILEGE_ENABLED)
	Else
		$IATTRIBUTES = BitAND($IATTRIBUTES, BitNOT($SE_PRIVILEGE_ENABLED))
	EndIf
	DllStructSetData($TPREVSTATE, "Attributes", $IATTRIBUTES)
	If Not _SECURITY__ADJUSTTOKENPRIVILEGES($HTOKEN, False, $PPREVSTATE, $IPREVSTATE, $PCURRSTATE, $PREQUIRED) Then
		Return SetError(-3, @error, False)
	EndIf
	Return SetError(0, 0, True)
EndFunc


Func _SECURITY__SIDTOSTRINGSID($PSID)
	Local $TPTR, $TBUFFER, $SSID, $ARESULT
	If Not _SECURITY__ISVALIDSID($PSID) Then Return SetError(-1, 0, "")
	$TPTR = DllStructCreate("ptr Buffer")
	$ARESULT = DllCall("AdvAPI32.dll", "int", "ConvertSidToStringSid", "ptr", $PSID, "ptr", DllStructGetPtr($TPTR))
	If $ARESULT[0] = 0 Then Return SetError(-2, 0, "")
	$TBUFFER = DllStructCreate("char Text[256]", DllStructGetData($TPTR, "Buffer"))
	$SSID = DllStructGetData($TBUFFER, "Text")
	_WINAPI_LOCALFREE(DllStructGetData($TPTR, "Buffer"))
	Return $SSID
EndFunc


Func _SECURITY__SIDTYPESTR($ITYPE)
	Switch $ITYPE
		Case 1
			Return "User"
		Case 2
			Return "Group"
		Case 3
			Return "Domain"
		Case 4
			Return "Alias"
		Case 5
			Return "Well Known Group"
		Case 6
			Return "Deleted Account"
		Case 7
			Return "Invalid"
		Case 8
			Return "Invalid"
		Case 9
			Return "Computer"
		Case Else
			Return "Unknown SID Type"
	EndSwitch
EndFunc


Func _SECURITY__STRINGSIDTOSID($SSID)
	Local $TPTR, $ISIZE, $TBUFFER, $TSID, $ARESULT
	$TPTR = DllStructCreate("ptr Buffer")
	$ARESULT = DllCall("AdvAPI32.dll", "int", "ConvertStringSidToSid", "str", $SSID, "ptr", DllStructGetPtr($TPTR))
	If $ARESULT = 0 Then Return SetError(-1, 0, 0)
	$ISIZE = _SECURITY__GETLENGTHSID(DllStructGetData($TPTR, "Buffer"))
	$TBUFFER = DllStructCreate("byte Data[" & $ISIZE & "]", DllStructGetData($TPTR, "Buffer"))
	$TSID = DllStructCreate("byte Data[" & $ISIZE & "]")
	DllStructSetData($TSID, "Data", DllStructGetData($TBUFFER, "Data"))
	_WINAPI_LOCALFREE(DllStructGetData($TPTR, "Buffer"))
	Return $TSID
EndFunc


Func _SENDMESSAGE($HWND, $IMSG, $WPARAM = 0, $LPARAM = 0, $IRETURN = 0, $WPARAMTYPE = "wparam", $LPARAMTYPE = "lparam", $SRETURNTYPE = "lparam")
	Local $ARESULT = DllCall("user32.dll", $SRETURNTYPE, "SendMessage", "hwnd", $HWND, "int", $IMSG, $WPARAMTYPE, $WPARAM, $LPARAMTYPE, $LPARAM)
	If @error Then Return SetError(@error, @extended, "")
	If $IRETURN >= 0 And $IRETURN <= 4 Then Return $ARESULT[$IRETURN]
	Return $ARESULT
EndFunc


Func _SENDMESSAGEA($HWND, $IMSG, $WPARAM = 0, $LPARAM = 0, $IRETURN = 0, $WPARAMTYPE = "wparam", $LPARAMTYPE = "lparam", $SRETURNTYPE = "lparam")
	Local $ARESULT = DllCall("user32.dll", $SRETURNTYPE, "SendMessageA", "hwnd", $HWND, "int", $IMSG, $WPARAMTYPE, $WPARAM, $LPARAMTYPE, $LPARAM)
	If @error Then Return SetError(@error, @extended, "")
	If $IRETURN >= 0 And $IRETURN <= 4 Then Return $ARESULT[$IRETURN]
	Return $ARESULT
EndFunc

Global $WINAPI_GAINPROCESS[64][2] = [[0, 0]]
Global $WINAPI_GAWINLIST[64][2] = [[0, 0]]
Global Const $__WINAPCONSTANT_WM_SETFONT = 48
Global Const $__WINAPCONSTANT_FW_NORMAL = 400
Global Const $__WINAPCONSTANT_DEFAULT_CHARSET = 1
Global Const $__WINAPCONSTANT_OUT_DEFAULT_PRECIS = 0
Global Const $__WINAPCONSTANT_CLIP_DEFAULT_PRECIS = 0
Global Const $__WINAPCONSTANT_DEFAULT_QUALITY = 0
Global Const $__WINAPCONSTANT_FORMAT_MESSAGE_FROM_SYSTEM = 4096
Global Const $__WINAPCONSTANT_INVALID_SET_FILE_POINTER = -1
Global Const $__WINAPCONSTANT_TOKEN_ADJUST_PRIVILEGES = 32
Global Const $__WINAPCONSTANT_TOKEN_QUERY = 8
Global Const $__WINAPCONSTANT_LOGPIXELSX = 88
Global Const $__WINAPCONSTANT_LOGPIXELSY = 90
Global Const $__WINAPCONSTANT_FLASHW_CAPTION = 1
Global Const $__WINAPCONSTANT_FLASHW_TRAY = 2
Global Const $__WINAPCONSTANT_FLASHW_TIMER = 4
Global Const $__WINAPCONSTANT_FLASHW_TIMERNOFG = 12
Global Const $__WINAPCONSTANT_GW_HWNDNEXT = 2
Global Const $__WINAPCONSTANT_GW_CHILD = 5
Global Const $__WINAPCONSTANT_DI_MASK = 1
Global Const $__WINAPCONSTANT_DI_IMAGE = 2
Global Const $__WINAPCONSTANT_DI_NORMAL = 3
Global Const $__WINAPCONSTANT_DI_COMPAT = 4
Global Const $__WINAPCONSTANT_DI_DEFAULTSIZE = 8
Global Const $__WINAPCONSTANT_DI_NOMIRROR = 16
Global Const $__WINAPCONSTANT_DISPLAY_DEVICE_ATTACHED_TO_DESKTOP = 1
Global Const $__WINAPCONSTANT_DISPLAY_DEVICE_PRIMARY_DEVICE = 4
Global Const $__WINAPCONSTANT_DISPLAY_DEVICE_MIRRORING_DRIVER = 8
Global Const $__WINAPCONSTANT_DISPLAY_DEVICE_VGA_COMPATIBLE = 16
Global Const $__WINAPCONSTANT_DISPLAY_DEVICE_REMOVABLE = 32
Global Const $__WINAPCONSTANT_DISPLAY_DEVICE_MODESPRUNED = 134217728
Global Const $__WINAPCONSTANT_CREATE_NEW = 1
Global Const $__WINAPCONSTANT_CREATE_ALWAYS = 2
Global Const $__WINAPCONSTANT_OPEN_EXISTING = 3
Global Const $__WINAPCONSTANT_OPEN_ALWAYS = 4
Global Const $__WINAPCONSTANT_TRUNCATE_EXISTING = 5
Global Const $__WINAPCONSTANT_FILE_ATTRIBUTE_READONLY = 1
Global Const $__WINAPCONSTANT_FILE_ATTRIBUTE_HIDDEN = 2
Global Const $__WINAPCONSTANT_FILE_ATTRIBUTE_SYSTEM = 4
Global Const $__WINAPCONSTANT_FILE_ATTRIBUTE_ARCHIVE = 32
Global Const $__WINAPCONSTANT_FILE_SHARE_READ = 1
Global Const $__WINAPCONSTANT_FILE_SHARE_WRITE = 2
Global Const $__WINAPCONSTANT_FILE_SHARE_DELETE = 4
Global Const $__WINAPCONSTANT_GENERIC_EXECUTE = 536870912
Global Const $__WINAPCONSTANT_GENERIC_WRITE = 1073741824
Global Const $__WINAPCONSTANT_GENERIC_READ = -2147483648
Global Const $NULL_BRUSH = 5
Global Const $NULL_PEN = 8
Global Const $BLACK_BRUSH = 4
Global Const $DKGRAY_BRUSH = 3
Global Const $DC_BRUSH = 18
Global Const $GRAY_BRUSH = 2
Global Const $HOLLOW_BRUSH = $NULL_BRUSH
Global Const $LTGRAY_BRUSH = 1
Global Const $WHITE_BRUSH = 0
Global Const $BLACK_PEN = 7
Global Const $DC_PEN = 19
Global Const $WHITE_PEN = 6
Global Const $ANSI_FIXED_FONT = 11
Global Const $ANSI_VAR_FONT = 12
Global Const $DEVICE_DEFAULT_FONT = 14
Global Const $DEFAULT_GUI_FONT = 17
Global Const $OEM_FIXED_FONT = 10
Global Const $SYSTEM_FONT = 13
Global Const $SYSTEM_FIXED_FONT = 16
Global Const $DEFAULT_PALETTE = 15
Global Const $MB_PRECOMPOSED = 1
Global Const $MB_COMPOSITE = 2
Global Const $MB_USEGLYPHCHARS = 4
Global Const $ULW_ALPHA = 2
Global Const $ULW_COLORKEY = 1
Global Const $ULW_OPAQUE = 4
Global Const $WH_CALLWNDPROC = 4
Global Const $WH_CALLWNDPROCRET = 12
Global Const $WH_CBT = 5
Global Const $WH_DEBUG = 9
Global Const $WH_FOREGROUNDIDLE = 11
Global Const $WH_GETMESSAGE = 3
Global Const $WH_JOURNALPLAYBACK = 1
Global Const $WH_JOURNALRECORD = 0
Global Const $WH_KEYBOARD = 2
Global Const $WH_KEYBOARD_LL = 13
Global Const $WH_MOUSE = 7
Global Const $WH_MOUSE_LL = 14
Global Const $WH_MSGFILTER = -1
Global Const $WH_SHELL = 10
Global Const $WH_SYSMSGFILTER = 6
Global Const $WPF_ASYNCWINDOWPLACEMENT = 4
Global Const $WPF_RESTORETOMAXIMIZED = 2
Global Const $WPF_SETMINPOSITION = 1
Global Const $KF_EXTENDED = 256
Global Const $KF_ALTDOWN = 8192
Global Const $KF_UP = 32768
Global Const $LLKHF_EXTENDED = BitShift($KF_EXTENDED, 8)
Global Const $LLKHF_INJECTED = 16
Global Const $LLKHF_ALTDOWN = BitShift($KF_ALTDOWN, 8)
Global Const $LLKHF_UP = BitShift($KF_UP, 8)
Global Const $OFN_ALLOWMULTISELECT = 512
Global Const $OFN_CREATEPROMPT = 8192
Global Const $OFN_DONTADDTORECENT = 33554432
Global Const $OFN_ENABLEHOOK = 32
Global Const $OFN_ENABLEINCLUDENOTIFY = 4194304
Global Const $OFN_ENABLESIZING = 8388608
Global Const $OFN_ENABLETEMPLATE = 64
Global Const $OFN_ENABLETEMPLATEHANDLE = 128
Global Const $OFN_EXPLORER = 524288
Global Const $OFN_EXTENSIONDIFFERENT = 1024
Global Const $OFN_FILEMUSTEXIST = 4096
Global Const $OFN_FORCESHOWHIDDEN = 268435456
Global Const $OFN_HIDEREADONLY = 4
Global Const $OFN_LONGNAMES = 2097152
Global Const $OFN_NOCHANGEDIR = 8
Global Const $OFN_NODEREFERENCELINKS = 1048576
Global Const $OFN_NOLONGNAMES = 262144
Global Const $OFN_NONETWORKBUTTON = 131072
Global Const $OFN_NOREADONLYRETURN = 32768
Global Const $OFN_NOTESTFILECREATE = 65536
Global Const $OFN_NOVALIDATE = 256
Global Const $OFN_OVERWRITEPROMPT = 2
Global Const $OFN_PATHMUSTEXIST = 2048
Global Const $OFN_READONLY = 1
Global Const $OFN_SHAREAWARE = 16384
Global Const $OFN_SHOWHELP = 16
Global Const $OFN_EX_NOPLACESBAR = 1

Func _WINAPI_ATTACHCONSOLE($IPROCESSID = -1)
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "int", "AttachConsole", "dword", $IPROCESSID)
	If @error Then Return SetError(@error, 0, False)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_ATTACHTHREADINPUT($IATTACH, $IATTACHTO, $FATTACH)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "AttachThreadInput", "int", $IATTACH, "int", $IATTACHTO, "int", $FATTACH)
	If @error Then Return SetError(@error, 0, False)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_BEEP($IFREQ = 500, $IDURATION = 1000)
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "int", "Beep", "dword", $IFREQ, "dword", $IDURATION)
	If @error Then Return SetError(@error, 0, False)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_BITBLT($HDESTDC, $IXDEST, $IYDEST, $IWIDTH, $IHEIGHT, $HSRCDC, $IXSRC, $IYSRC, $IROP)
	Local $ARESULT
	$ARESULT = DllCall("GDI32.dll", "int", "BitBlt", "hwnd", $HDESTDC, "int", $IXDEST, "int", $IYDEST, "int", $IWIDTH, "int", $IHEIGHT, "hwnd", $HSRCDC, "int", $IXSRC, "int", $IYSRC, "int", $IROP)
	If @error Then Return SetError(@error, 0, False)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_CALLNEXTHOOKEX($HHK, $ICODE, $WPARAM, $LPARAM)
	Local $IRESULT = DllCall("user32.dll", "lparam", "CallNextHookEx", "hwnd", $HHK, "int", $ICODE, "wparam", $WPARAM, "lparam", $LPARAM)
	If @error Then Return SetError(@error, @extended, -1)
	Return $IRESULT[0]
EndFunc


Func _WINAPI_CALLWINDOWPROC($LPPREVWNDFUNC, $HWND, $MSG, $WPARAM, $LPARAM)
	Local $ARESULT
	$ARESULT = DllCall("user32.dll", "int", "CallWindowProc", "ptr", $LPPREVWNDFUNC, "hwnd", $HWND, "uint", $MSG, "wparam", $WPARAM, "lparam", $LPARAM)
	If @error Then Return SetError(-1, 0, -1)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_CHECK($SFUNCTION, $FERROR, $VERROR, $FTRANSLATE = False)
	If $FERROR Then
		If $FTRANSLATE Then $VERROR = _WINAPI_GETLASTERRORMESSAGE()
		_WINAPI_SHOWERROR($SFUNCTION & ": " & $VERROR)
	EndIf
EndFunc


Func _WINAPI_CLIENTTOSCREEN($HWND, ByRef $TPOINT)
	Local $PPOINT, $ARESULT
	$PPOINT = DllStructGetPtr($TPOINT)
	$ARESULT = DllCall("User32.dll", "int", "ClientToScreen", "hwnd", $HWND, "ptr", $PPOINT)
	If @error Then Return SetError(@error, 0, $TPOINT)
	Return SetError($ARESULT[0] <> 0, 0, $TPOINT)
EndFunc


Func _WINAPI_CLOSEHANDLE($HOBJECT)
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "int", "CloseHandle", "int", $HOBJECT)
	_WINAPI_CHECK("_WinAPI_CloseHandle", ($ARESULT[0] = 0), 0, True)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_COMBINERGN($HRGNDEST, $HRGNSRC1, $HRGNSRC2, $ICOMBINEMODE)
	Local $ARESULT = DllCall("gdi32.dll", "int", "CombineRgn", "hwnd", $HRGNDEST, "hwnd", $HRGNSRC1, "hwnd", $HRGNSRC2, "int", $ICOMBINEMODE)
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_COMMDLGEXTENDEDERROR()
	Local Const $CDERR_DIALOGFAILURE = 65535
	Local Const $CDERR_FINDRESFAILURE = 6
	Local Const $CDERR_INITIALIZATION = 2
	Local Const $CDERR_LOADRESFAILURE = 7
	Local Const $CDERR_LOADSTRFAILURE = 5
	Local Const $CDERR_LOCKRESFAILURE = 8
	Local Const $CDERR_MEMALLOCFAILURE = 9
	Local Const $CDERR_MEMLOCKFAILURE = 10
	Local Const $CDERR_NOHINSTANCE = 4
	Local Const $CDERR_NOHOOK = 11
	Local Const $CDERR_NOTEMPLATE = 3
	Local Const $CDERR_REGISTERMSGFAIL = 12
	Local Const $CDERR_STRUCTSIZE = 1
	Local Const $FNERR_BUFFERTOOSMALL = 12291
	Local Const $FNERR_INVALIDFILENAME = 12290
	Local Const $FNERR_SUBCLASSFAILURE = 12289
	Local $IRESULT = DllCall("comdlg32.dll", "dword", "CommDlgExtendedError")
	If @error Then Return SetError(@error, @extended, "")
	SetError($IRESULT[0])
	Switch @error
		Case $CDERR_DIALOGFAILURE
			Return SetError(@error, 0, "The dialog box could not be created." & @LF & "The common dialog box function's call to the DialogBox function failed." & @LF & "For example, this error occurs if the common dialog box call specifies an invalid window handle.")
		Case $CDERR_FINDRESFAILURE
			Return SetError(@error, 0, "The common dialog box function failed to find a specified resource.")
		Case $CDERR_INITIALIZATION
			Return SetError(@error, 0, "The common dialog box function failed during initialization." & @LF & "This error often occurs when sufficient memory is not available.")
		Case $CDERR_LOADRESFAILURE
			Return SetError(@error, 0, "The common dialog box function failed to load a specified resource.")
		Case $CDERR_LOADSTRFAILURE
			Return SetError(@error, 0, "The common dialog box function failed to load a specified string.")
		Case $CDERR_LOCKRESFAILURE
			Return SetError(@error, 0, "The common dialog box function failed to lock a specified resource.")
		Case $CDERR_MEMALLOCFAILURE
			Return SetError(@error, 0, "The common dialog box function was unable to allocate memory for internal structures.")
		Case $CDERR_MEMLOCKFAILURE
			Return SetError(@error, 0, "The common dialog box function was unable to lock the memory associated with a handle.")
		Case $CDERR_NOHINSTANCE
			Return SetError(@error, 0, "The ENABLETEMPLATE flag was set in the Flags member of the initialization structure for the corresponding common dialog box," & @LF & "but you failed to provide a corresponding instance handle.")
		Case $CDERR_NOHOOK
			Return SetError(@error, 0, "The ENABLEHOOK flag was set in the Flags member of the initialization structure for the corresponding common dialog box," & @LF & "but you failed to provide a pointer to a corresponding hook procedure.")
		Case $CDERR_NOTEMPLATE
			Return SetError(@error, 0, "The ENABLETEMPLATE flag was set in the Flags member of the initialization structure for the corresponding common dialog box," & @LF & "but you failed to provide a corresponding template.")
		Case $CDERR_REGISTERMSGFAIL
			Return SetError(@error, 0, "The RegisterWindowMessage function returned an error code when it was called by the common dialog box function.")
		Case $CDERR_STRUCTSIZE
			Return SetError(@error, 0, "The lStructSize member of the initialization structure for the corresponding common dialog box is invalid")
		Case $FNERR_BUFFERTOOSMALL
			Return SetError(@error, 0, "The buffer pointed to by the lpstrFile member of the OPENFILENAME structure is too small for the file name specified by the user." & @LF & "The first two bytes of the lpstrFile buffer contain an integer value specifying the size, in TCHARs, required to receive the full name.")
		Case $FNERR_INVALIDFILENAME
			Return SetError(@error, 0, "A file name is invalid.")
		Case $FNERR_SUBCLASSFAILURE
			Return SetError(@error, 0, "An attempt to subclass a list box failed because sufficient memory was not available.")
	EndSwitch
EndFunc


Func _WINAPI_COPYICON($HICON)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "hwnd", "CopyIcon", "hwnd", $HICON)
	_WINAPI_CHECK("_WinAPI_CopyIcon", ($ARESULT[0] = 0), 0, True)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_CREATEBITMAP($IWIDTH, $IHEIGHT, $IPLANES = 1, $IBITSPERPEL = 1, $PBITS = 0)
	Local $ARESULT
	$ARESULT = DllCall("GDI32.dll", "hwnd", "CreateBitmap", "int", $IWIDTH, "int", $IHEIGHT, "int", $IPLANES, "int", $IBITSPERPEL, "ptr", $PBITS)
	_WINAPI_CHECK("_WinAPI_CreateBitmap", ($ARESULT[0] = 0), 0, True)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_CREATECOMPATIBLEBITMAP($HDC, $IWIDTH, $IHEIGHT)
	Local $ARESULT
	$ARESULT = DllCall("GDI32.dll", "hwnd", "CreateCompatibleBitmap", "hwnd", $HDC, "int", $IWIDTH, "int", $IHEIGHT)
	_WINAPI_CHECK("_WinAPI_CreateCompatibleBitmap", ($ARESULT[0] = 0), 0, True)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_CREATECOMPATIBLEDC($HDC)
	Local $ARESULT
	$ARESULT = DllCall("GDI32.dll", "hwnd", "CreateCompatibleDC", "hwnd", $HDC)
	_WINAPI_CHECK("_WinAPI_CreateCompatibleDC", ($ARESULT[0] = 0), 0, True)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_CREATEEVENT($PATTRIBUTES = 0, $FMANUALRESET = True, $FINITIALSTATE = True, $SNAME = "")
	Local $ARESULT
	If $SNAME = "" Then $SNAME = 0
	$ARESULT = DllCall("Kernel32.dll", "int", "CreateEvent", "ptr", $PATTRIBUTES, "int", $FMANUALRESET, "int", $FINITIALSTATE, "str", $SNAME)
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_CREATEFILE($SFILENAME, $ICREATION, $IACCESS = 4, $ISHARE = 0, $IATTRIBUTES = 0, $PSECURITY = 0)
	Local $IDA = 0, $ISM = 0, $ICD = 0, $IFA = 0, $ARESULT
	If BitAND($IACCESS, 1) <> 0 Then $IDA = BitOR($IDA, $__WINAPCONSTANT_GENERIC_EXECUTE)
	If BitAND($IACCESS, 2) <> 0 Then $IDA = BitOR($IDA, $__WINAPCONSTANT_GENERIC_READ)
	If BitAND($IACCESS, 4) <> 0 Then $IDA = BitOR($IDA, $__WINAPCONSTANT_GENERIC_WRITE)
	If BitAND($ISHARE, 1) <> 0 Then $ISM = BitOR($ISM, $__WINAPCONSTANT_FILE_SHARE_DELETE)
	If BitAND($ISHARE, 2) <> 0 Then $ISM = BitOR($ISM, $__WINAPCONSTANT_FILE_SHARE_READ)
	If BitAND($ISHARE, 4) <> 0 Then $ISM = BitOR($ISM, $__WINAPCONSTANT_FILE_SHARE_WRITE)
	Switch $ICREATION
		Case 0
			$ICD = $__WINAPCONSTANT_CREATE_NEW
		Case 1
			$ICD = $__WINAPCONSTANT_CREATE_ALWAYS
		Case 2
			$ICD = $__WINAPCONSTANT_OPEN_EXISTING
		Case 3
			$ICD = $__WINAPCONSTANT_OPEN_ALWAYS
		Case 4
			$ICD = $__WINAPCONSTANT_TRUNCATE_EXISTING
	EndSwitch
	If BitAND($IATTRIBUTES, 1) <> 0 Then $IFA = BitOR($IFA, $__WINAPCONSTANT_FILE_ATTRIBUTE_ARCHIVE)
	If BitAND($IATTRIBUTES, 2) <> 0 Then $IFA = BitOR($IFA, $__WINAPCONSTANT_FILE_ATTRIBUTE_HIDDEN)
	If BitAND($IATTRIBUTES, 4) <> 0 Then $IFA = BitOR($IFA, $__WINAPCONSTANT_FILE_ATTRIBUTE_READONLY)
	If BitAND($IATTRIBUTES, 8) <> 0 Then $IFA = BitOR($IFA, $__WINAPCONSTANT_FILE_ATTRIBUTE_SYSTEM)
	$ARESULT = DllCall("Kernel32.dll", "hwnd", "CreateFile", "str", $SFILENAME, "int", $IDA, "int", $ISM, "ptr", $PSECURITY, "int", $ICD, "int", $IFA, "int", 0)
	If @error Then Return SetError(@error, 0, 0)
	If $ARESULT[0] = -1 Then Return 0
	Return $ARESULT[0]
EndFunc


Func _WINAPI_CREATEFONT($NHEIGHT, $NWIDTH, $NESCAPE = 0, $NORIENTN = 0, $FNWEIGHT = $__WINAPCONSTANT_FW_NORMAL, $BITALIC = False, $BUNDERLINE = False, $BSTRIKEOUT = False, $NCHARSET = $__WINAPCONSTANT_DEFAULT_CHARSET, $NOUTPUTPREC = $__WINAPCONSTANT_OUT_DEFAULT_PRECIS, $NCLIPPREC = $__WINAPCONSTANT_CLIP_DEFAULT_PRECIS, $NQUALITY = $__WINAPCONSTANT_DEFAULT_QUALITY, $NPITCH = 0, $SZFACE = "Arial")
	Local $TBUFFER = DllStructCreate("char FontName[" & StringLen($SZFACE) + 1 & "]")
	Local $PBUFFER = DllStructGetPtr($TBUFFER)
	Local $AFONT
	DllStructSetData($TBUFFER, "FontName", $SZFACE)
	$AFONT = DllCall("gdi32.dll", "hwnd", "CreateFont", "int", $NHEIGHT, "int", $NWIDTH, "int", $NESCAPE, "int", $NORIENTN, "int", $FNWEIGHT, "long", $BITALIC, "long", $BUNDERLINE, "long", $BSTRIKEOUT, "long", $NCHARSET, "long", $NOUTPUTPREC, "long", $NCLIPPREC, "long", $NQUALITY, "long", $NPITCH, "ptr", $PBUFFER)
	If @error Then Return SetError(@error, 0, 0)
	Return $AFONT[0]
EndFunc


Func _WINAPI_CREATEFONTINDIRECT($TLOGFONT)
	Local $ARESULT
	$ARESULT = DllCall("GDI32.dll", "hwnd", "CreateFontIndirect", "ptr", DllStructGetPtr($TLOGFONT))
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_CREATEPEN($IPENSTYLE, $IWIDTH, $NCOLOR)
	Local $HPEN = DllCall("gdi32.dll", "hwnd", "CreatePen", "int", $IPENSTYLE, "int", $IWIDTH, "int", $NCOLOR)
	If @error Then Return SetError(@error, 0, 0)
	Return $HPEN[0]
EndFunc


Func _WINAPI_CREATEPROCESS($SAPPNAME, $SCOMMAND, $PSECURITY, $PTHREAD, $FINHERIT, $IFLAGS, $PENVIRON, $SDIR, $PSTARTUPINFO, $PPROCESS)
	Local $PAPPNAME, $TAPPNAME, $PCOMMAND, $TCOMMAND, $PDIR, $TDIR, $ARESULT
	If $SAPPNAME <> "" Then
		$TAPPNAME = DllStructCreate("char Text[" & StringLen($SAPPNAME) + 1 & "]")
		$PAPPNAME = DllStructGetPtr($TAPPNAME)
		DllStructSetData($TAPPNAME, "Text", $SAPPNAME)
	EndIf
	If $SCOMMAND <> "" Then
		$TCOMMAND = DllStructCreate("char Text[" & StringLen($SCOMMAND) + 1 & "]")
		$PCOMMAND = DllStructGetPtr($TCOMMAND)
		DllStructSetData($TCOMMAND, "Text", $SCOMMAND)
	EndIf
	If $SDIR <> "" Then
		$TDIR = DllStructCreate("char Text[" & StringLen($SDIR) + 1 & "]")
		$PDIR = DllStructGetPtr($TDIR)
		DllStructSetData($TDIR, "Text", $SDIR)
	EndIf
	$ARESULT = DllCall("Kernel32.dll", "int", "CreateProcess", "ptr", $PAPPNAME, "ptr", $PCOMMAND, "ptr", $PSECURITY, "ptr", $PTHREAD, "int", $FINHERIT, "int", $IFLAGS, "ptr", $PENVIRON, "ptr", $PDIR, "ptr", $PSTARTUPINFO, "ptr", $PPROCESS)
	If @error Then Return SetError(@error, 0, False)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_CREATERECTRGN($ILEFTRECT, $ITOPRECT, $IRIGHTRECT, $IBOTTOMRECT)
	Local $HRGN = DllCall("gdi32.dll", "hwnd", "CreateRectRgn", "int", $ILEFTRECT, "int", $ITOPRECT, "int", $IRIGHTRECT, "int", $IBOTTOMRECT)
	If @error Then Return SetError(@error, 0, 0)
	Return $HRGN[0]
EndFunc


Func _WINAPI_CREATEROUNDRECTRGN($ILEFTRECT, $ITOPRECT, $IRIGHTRECT, $IBOTTOMRECT, $IWIDTHELLIPSE, $IHEIGHTELLIPSE)
	Local $HRGN = DllCall("gdi32.dll", "hwnd", "CreateRoundRectRgn", "int", $ILEFTRECT, "int", $ITOPRECT, "int", $IRIGHTRECT, "int", $IBOTTOMRECT, "int", $IWIDTHELLIPSE, "int", $IHEIGHTELLIPSE)
	If @error Then Return SetError(@error, 0, 0)
	Return $HRGN[0]
EndFunc


Func _WINAPI_CREATESOLIDBITMAP($HWND, $ICOLOR, $IWIDTH, $IHEIGHT)
	Local $II, $ISIZE, $TBITS, $TBMI, $HDC, $HBMP
	$ISIZE = $IWIDTH * $IHEIGHT
	$TBITS = DllStructCreate("int[" & $ISIZE & "]")
	For $II = 1 To $ISIZE
		DllStructSetData($TBITS, 1, $ICOLOR, $II)
	Next
	$TBMI = DllStructCreate($TAGBITMAPINFO)
	DllStructSetData($TBMI, "Size", DllStructGetSize($TBMI) - 4)
	DllStructSetData($TBMI, "Planes", 1)
	DllStructSetData($TBMI, "BitCount", 32)
	DllStructSetData($TBMI, "Width", $IWIDTH)
	DllStructSetData($TBMI, "Height", $IHEIGHT)
	$HDC = _WINAPI_GETDC($HWND)
	$HBMP = _WINAPI_CREATECOMPATIBLEBITMAP($HDC, $IWIDTH, $IHEIGHT)
	_WINAPI_SETDIBITS(0, $HBMP, 0, $IHEIGHT, DllStructGetPtr($TBITS), DllStructGetPtr($TBMI))
	_WINAPI_RELEASEDC($HWND, $HDC)
	Return $HBMP
EndFunc


Func _WINAPI_CREATESOLIDBRUSH($NCOLOR)
	Local $HBRUSH = DllCall("gdi32.dll", "hwnd", "CreateSolidBrush", "int", $NCOLOR)
	If @error Then Return SetError(@error, 0, 0)
	Return $HBRUSH[0]
EndFunc


Func _WINAPI_CREATEWINDOWEX($IEXSTYLE, $SCLASS, $SNAME, $ISTYLE, $IX, $IY, $IWIDTH, $IHEIGHT, $HPARENT, $HMENU = 0, $HINSTANCE = 0, $PPARAM = 0)
	Local $ARESULT
	If $HINSTANCE = 0 Then $HINSTANCE = _WINAPI_GETMODULEHANDLE("")
	$ARESULT = DllCall("User32.dll", "hwnd", "CreateWindowEx", "int", $IEXSTYLE, "str", $SCLASS, "str", $SNAME, "int", $ISTYLE, "int", $IX, "int", $IY, "int", $IWIDTH, "int", $IHEIGHT, "hwnd", $HPARENT, "hwnd", $HMENU, "hwnd", $HINSTANCE, "ptr", $PPARAM)
	_WINAPI_CHECK("_WinAPI_CreateWindowEx", ($ARESULT[0] = 0), 0, True)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_DEFWINDOWPROC($HWND, $IMSG, $IWPARAM, $ILPARAM)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "DefWindowProc", "hwnd", $HWND, "int", $IMSG, "int", $IWPARAM, "int", $ILPARAM)
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_DELETEDC($HDC)
	Local $ARESULT
	$ARESULT = DllCall("GDI32.dll", "int", "DeleteDC", "hwnd", $HDC)
	_WINAPI_CHECK("_WinAPI_DeleteDC", ($ARESULT[0] = 0), 0, True)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_DELETEOBJECT($HOBJECT)
	Local $ARESULT
	$ARESULT = DllCall("GDI32.dll", "int", "DeleteObject", "int", $HOBJECT)
	If @error Then Return SetError(@error, 0, False)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_DESTROYICON($HICON)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "DestroyIcon", "hwnd", $HICON)
	_WINAPI_CHECK("_WinAPI_DestroyIcon", ($ARESULT[0] = 0), 0, True)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_DESTROYWINDOW($HWND)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "DestroyWindow", "hwnd", $HWND)
	If @error Then Return SetError(@error, 0, False)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_DRAWEDGE($HDC, $PTRRECT, $NEDGETYPE, $GRFFLAGS)
	Local $BRESULT = DllCall("user32.dll", "int", "DrawEdge", "hwnd", $HDC, "ptr", $PTRRECT, "int", $NEDGETYPE, "int", $GRFFLAGS)
	If @error Then Return SetError(@error, 0, False)
	Return $BRESULT[0] <> 0
EndFunc


Func _WINAPI_DRAWFRAMECONTROL($HDC, $PTRRECT, $NTYPE, $NSTATE)
	Local $BRESULT = DllCall("user32.dll", "int", "DrawFrameControl", "hwnd", $HDC, "ptr", $PTRRECT, "int", $NTYPE, "int", $NSTATE)
	If @error Then Return SetError(@error, 0, False)
	Return $BRESULT[0] <> 0
EndFunc


Func _WINAPI_DRAWICON($HDC, $IX, $IY, $HICON)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "DrawIcon", "hwnd", $HDC, "int", $IX, "int", $IY, "hwnd", $HICON)
	_WINAPI_CHECK("_WinAPI_DrawIcon", ($ARESULT[0] = 0), 0, True)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_DRAWICONEX($HDC, $IX, $IY, $HICON, $IWIDTH = 0, $IHEIGHT = 0, $ISTEP = 0, $HBRUSH = 0, $IFLAGS = 3)
	Local $IOPTIONS, $ARESULT
	Switch $IFLAGS
		Case 1
			$IOPTIONS = $__WINAPCONSTANT_DI_MASK
		Case 2
			$IOPTIONS = $__WINAPCONSTANT_DI_IMAGE
		Case 3
			$IOPTIONS = $__WINAPCONSTANT_DI_NORMAL
		Case 4
			$IOPTIONS = $__WINAPCONSTANT_DI_COMPAT
		Case 5
			$IOPTIONS = $__WINAPCONSTANT_DI_DEFAULTSIZE
		Case Else
			$IOPTIONS = $__WINAPCONSTANT_DI_NOMIRROR
	EndSwitch
	$ARESULT = DllCall("User32.dll", "int", "DrawIconEx", "hwnd", $HDC, "int", $IX, "int", $IY, "hwnd", $HICON, "int", $IWIDTH, "int", $IHEIGHT, "uint", $ISTEP, "hwnd", $HBRUSH, "uint", $IOPTIONS)
	_WINAPI_CHECK("_WinAPI_DrawIconEx", ($ARESULT[0] = 0), 0, True)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_DRAWLINE($HDC, $IX1, $IY1, $IX2, $IY2)
	_WINAPI_MOVETO($HDC, $IX1, $IY1)
	If @error Then Return SetError(@error, 0, False)
	_WINAPI_LINETO($HDC, $IX2, $IY2)
	If @error Then Return SetError(@error, 0, False)
	Return True
EndFunc


Func _WINAPI_DRAWTEXT($HDC, $STEXT, ByRef $TRECT, $IFLAGS)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "DrawText", "hwnd", $HDC, "str", $STEXT, "int", -1, "ptr", DllStructGetPtr($TRECT), "int", $IFLAGS)
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_ENABLEWINDOW($HWND, $FENABLE = True)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "EnableWindow", "hwnd", $HWND, "int", $FENABLE)
	If @error Then Return SetError(@error, 0, False)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_ENUMDISPLAYDEVICES($SDEVICE, $IDEVNUM)
	Local $PNAME, $TNAME, $IDEVICE, $PDEVICE, $TDEVICE, $IN, $IFLAGS, $ARESULT, $ADEVICE[5]
	If $SDEVICE <> "" Then
		$TNAME = DllStructCreate("char Text[128]")
		$PNAME = DllStructGetPtr($TNAME)
		DllStructSetData($TNAME, "Text", $SDEVICE)
	EndIf
	$TDEVICE = DllStructCreate($TAGDISPLAY_DEVICE)
	$PDEVICE = DllStructGetPtr($TDEVICE)
	$IDEVICE = DllStructGetSize($TDEVICE)
	DllStructSetData($TDEVICE, "Size", $IDEVICE)
	$ARESULT = DllCall("User32.dll", "int", "EnumDisplayDevices", "ptr", $PNAME, "int", $IDEVNUM, "ptr", $PDEVICE, "int", 1)
	If @error Then Return SetError(@error, 0, $ADEVICE)
	$IN = DllStructGetData($TDEVICE, "Flags")
	If BitAND($IN, $__WINAPCONSTANT_DISPLAY_DEVICE_ATTACHED_TO_DESKTOP) <> 0 Then $IFLAGS = BitOR($IFLAGS, 1)
	If BitAND($IN, $__WINAPCONSTANT_DISPLAY_DEVICE_PRIMARY_DEVICE) <> 0 Then $IFLAGS = BitOR($IFLAGS, 2)
	If BitAND($IN, $__WINAPCONSTANT_DISPLAY_DEVICE_MIRRORING_DRIVER) <> 0 Then $IFLAGS = BitOR($IFLAGS, 4)
	If BitAND($IN, $__WINAPCONSTANT_DISPLAY_DEVICE_VGA_COMPATIBLE) <> 0 Then $IFLAGS = BitOR($IFLAGS, 8)
	If BitAND($IN, $__WINAPCONSTANT_DISPLAY_DEVICE_REMOVABLE) <> 0 Then $IFLAGS = BitOR($IFLAGS, 16)
	If BitAND($IN, $__WINAPCONSTANT_DISPLAY_DEVICE_MODESPRUNED) <> 0 Then $IFLAGS = BitOR($IFLAGS, 32)
	$ADEVICE[0] = $ARESULT[0] <> 0
	$ADEVICE[1] = DllStructGetData($TDEVICE, "Name")
	$ADEVICE[2] = DllStructGetData($TDEVICE, "String")
	$ADEVICE[3] = $IFLAGS
	$ADEVICE[4] = DllStructGetData($TDEVICE, "ID")
	Return $ADEVICE
EndFunc


Func _WINAPI_ENUMWINDOWS($FVISIBLE = True)
	_WINAPI_ENUMWINDOWSINIT()
	_WINAPI_ENUMWINDOWSCHILD(_WINAPI_GETDESKTOPWINDOW(), $FVISIBLE)
	Return $WINAPI_GAWINLIST
EndFunc


Func _WINAPI_ENUMWINDOWSADD($HWND, $SCLASS = "")
	Local $ICOUNT
	If $SCLASS = "" Then $SCLASS = _WINAPI_GETCLASSNAME($HWND)
	$WINAPI_GAWINLIST[0][0] += 1
	$ICOUNT = $WINAPI_GAWINLIST[0][0]
	If $ICOUNT >= $WINAPI_GAWINLIST[0][1] Then
		ReDim $WINAPI_GAWINLIST[$ICOUNT + 64][2]
		$WINAPI_GAWINLIST[0][1] += 64
	EndIf
	$WINAPI_GAWINLIST[$ICOUNT][0] = $HWND
	$WINAPI_GAWINLIST[$ICOUNT][1] = $SCLASS
EndFunc


Func _WINAPI_ENUMWINDOWSCHILD($HWND, $FVISIBLE = True)
	$HWND = _WINAPI_GETWINDOW($HWND, $__WINAPCONSTANT_GW_CHILD)
	While $HWND <> 0
		If (Not $FVISIBLE) Or _WINAPI_ISWINDOWVISIBLE($HWND) Then
			_WINAPI_ENUMWINDOWSCHILD($HWND, $FVISIBLE)
			_WINAPI_ENUMWINDOWSADD($HWND)
		EndIf
		$HWND = _WINAPI_GETWINDOW($HWND, $__WINAPCONSTANT_GW_HWNDNEXT)
	WEnd
EndFunc


Func _WINAPI_ENUMWINDOWSINIT()
	ReDim $WINAPI_GAWINLIST[64][2]
	$WINAPI_GAWINLIST[0][0] = 0
	$WINAPI_GAWINLIST[0][1] = 64
EndFunc


Func _WINAPI_ENUMWINDOWSPOPUP()
	Local $HWND, $SCLASS
	_WINAPI_ENUMWINDOWSINIT()
	$HWND = _WINAPI_GETWINDOW(_WINAPI_GETDESKTOPWINDOW(), $__WINAPCONSTANT_GW_CHILD)
	While $HWND <> 0
		If _WINAPI_ISWINDOWVISIBLE($HWND) Then
			$SCLASS = _WINAPI_GETCLASSNAME($HWND)
			If $SCLASS = "#32768"  Then
				_WINAPI_ENUMWINDOWSADD($HWND)
			ElseIf $SCLASS = "ToolbarWindow32"  Then
				_WINAPI_ENUMWINDOWSADD($HWND)
			ElseIf $SCLASS = "ToolTips_Class32"  Then
				_WINAPI_ENUMWINDOWSADD($HWND)
			ElseIf $SCLASS = "BaseBar"  Then
				_WINAPI_ENUMWINDOWSCHILD($HWND)
			EndIf
		EndIf
		$HWND = _WINAPI_GETWINDOW($HWND, $__WINAPCONSTANT_GW_HWNDNEXT)
	WEnd
	Return $WINAPI_GAWINLIST
EndFunc


Func _WINAPI_ENUMWINDOWSTOP()
	Local $HWND
	_WINAPI_ENUMWINDOWSINIT()
	$HWND = _WINAPI_GETWINDOW(_WINAPI_GETDESKTOPWINDOW(), $__WINAPCONSTANT_GW_CHILD)
	While $HWND <> 0
		If _WINAPI_ISWINDOWVISIBLE($HWND) Then _WINAPI_ENUMWINDOWSADD($HWND)
		$HWND = _WINAPI_GETWINDOW($HWND, $__WINAPCONSTANT_GW_HWNDNEXT)
	WEnd
	Return $WINAPI_GAWINLIST
EndFunc


Func _WINAPI_EXPANDENVIRONMENTSTRINGS($SSTRING)
	Local $TTEXT, $ARESULT
	$TTEXT = DllStructCreate("char Text[4096]")
	$ARESULT = DllCall("Kernel32.dll", "int", "ExpandEnvironmentStringsA", "str", $SSTRING, "ptr", DllStructGetPtr($TTEXT), "int", 4096)
	_WINAPI_CHECK("_WinAPI_ExpandEnvironmentStrings", ($ARESULT[0] = 0), 0, True)
	Return DllStructGetData($TTEXT, "Text")
EndFunc


Func _WINAPI_EXTRACTICONEX($SFILE, $IINDEX, $PLARGE, $PSMALL, $IICONS)
	Local $ARESULT
	$ARESULT = DllCall("Shell32.dll", "int", "ExtractIconEx", "str", $SFILE, "int", $IINDEX, "ptr", $PLARGE, "ptr", $PSMALL, "int", $IICONS)
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_FATALAPPEXIT($SMESSAGE)
	DllCall("Kernel32.dll", "none", "FatalAppExit", "uint", 0, "str", $SMESSAGE)
EndFunc


Func _WINAPI_FILLRECT($HDC, $PTRRECT, $HBRUSH)
	Local $BRESULT
	If IsHWnd($HBRUSH) Then
		$BRESULT = DllCall("user32.dll", "int", "FillRect", "hwnd", $HDC, "ptr", $PTRRECT, "hwnd", $HBRUSH)
	Else
		$BRESULT = DllCall("user32.dll", "int", "FillRect", "hwnd", $HDC, "ptr", $PTRRECT, "int", $HBRUSH)
	EndIf
	If @error Then Return SetError(@error, 0, False)
	Return $BRESULT[0] <> 0
EndFunc


Func _WINAPI_FINDEXECUTABLE($SFILENAME, $SDIRECTORY = "")
	Local $TTEXT
	$TTEXT = DllStructCreate("char Text[4096]")
	DllCall("Shell32.dll", "hwnd", "FindExecutable", "str", $SFILENAME, "str", $SDIRECTORY, "ptr", DllStructGetPtr($TTEXT))
	If @error Then Return SetError(@error, 0, 0)
	Return DllStructGetData($TTEXT, "Text")
EndFunc


Func _WINAPI_FINDWINDOW($SCLASSNAME, $SWINDOWNAME)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "hwnd", "FindWindow", "str", $SCLASSNAME, "str", $SWINDOWNAME)
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_FLASHWINDOW($HWND, $FINVERT = True)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "FlashWindow", "hwnd", $HWND, "int", $FINVERT)
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_FLASHWINDOWEX($HWND, $IFLAGS = 3, $ICOUNT = 3, $ITIMEOUT = 0)
	Local $IMODE = 0, $IFLASH, $PFLASH, $TFLASH, $ARESULT
	$TFLASH = DllStructCreate($TAGFLASHWINDOW)
	$PFLASH = DllStructGetPtr($TFLASH)
	$IFLASH = DllStructGetSize($TFLASH)
	If BitAND($IFLAGS, 1) <> 0 Then $IMODE = BitOR($IMODE, $__WINAPCONSTANT_FLASHW_CAPTION)
	If BitAND($IFLAGS, 2) <> 0 Then $IMODE = BitOR($IMODE, $__WINAPCONSTANT_FLASHW_TRAY)
	If BitAND($IFLAGS, 4) <> 0 Then $IMODE = BitOR($IMODE, $__WINAPCONSTANT_FLASHW_TIMER)
	If BitAND($IFLAGS, 8) <> 0 Then $IMODE = BitOR($IMODE, $__WINAPCONSTANT_FLASHW_TIMERNOFG)
	DllStructSetData($TFLASH, "Size", $IFLASH)
	DllStructSetData($TFLASH, "hWnd", $HWND)
	DllStructSetData($TFLASH, "Flags", $IMODE)
	DllStructSetData($TFLASH, "Count", $ICOUNT)
	DllStructSetData($TFLASH, "Timeout", $ITIMEOUT)
	$ARESULT = DllCall("User32.dll", "int", "FlashWindowEx", "ptr", $PFLASH)
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_FLOATTOINT($NFLOAT)
	Local $TFLOAT, $TINT
	$TFLOAT = DllStructCreate("float")
	$TINT = DllStructCreate("int", DllStructGetPtr($TFLOAT))
	DllStructSetData($TFLOAT, 1, $NFLOAT)
	Return DllStructGetData($TINT, 1)
EndFunc


Func _WINAPI_FLUSHFILEBUFFERS($HFILE)
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "int", "FlushFileBuffers", "hwnd", $HFILE)
	If @error Then Return SetError(@error, 0, False)
	Return SetError(_WINAPI_GETLASTERROR(), 0, $ARESULT[0] <> 0)
EndFunc


Func _WINAPI_FORMATMESSAGE($IFLAGS, $PSOURCE, $IMESSAGEID, $ILANGUAGEID, $PBUFFER, $ISIZE, $VARGUMENTS)
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "int", "FormatMessageA", "int", $IFLAGS, "hwnd", $PSOURCE, "int", $IMESSAGEID, "int", $ILANGUAGEID, "ptr", $PBUFFER, "int", $ISIZE, "ptr", $VARGUMENTS)
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_FRAMERECT($HDC, $PTRRECT, $HBRUSH)
	Local $BRESULT = DllCall("user32.dll", "int", "FrameRect", "hwnd", $HDC, "ptr", $PTRRECT, "hwnd", $HBRUSH)
	If @error Then Return SetError(@error, 0, False)
	Return $BRESULT[0] <> 0
EndFunc


Func _WINAPI_FREELIBRARY($HMODULE)
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "hwnd", "FreeLibrary", "hwnd", $HMODULE)
	If @error Then Return SetError(@error, 0, False)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_GETANCESTOR($HWND, $IFLAGS = 1)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "hwnd", "GetAncestor", "hwnd", $HWND, "uint", $IFLAGS)
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETASYNCKEYSTATE($IKEY)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "GetAsyncKeyState", "int", $IKEY)
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETBKMODE($HDC)
	Local $ARESULT = DllCall("gdi32.dll", "int", "GetBkMode", "ptr", $HDC)
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETCLASSNAME($HWND)
	Local $ARESULT
	If Not IsHWnd($HWND) Then $HWND = GUICtrlGetHandle($HWND)
	$ARESULT = DllCall("User32.dll", "int", "GetClassName", "hwnd", $HWND, "str", "", "int", 4096)
	If @error Then Return SetError(@error, 0, "")
	Return $ARESULT[2]
EndFunc


Func _WINAPI_GETCLIENTHEIGHT($HWND)
	Local $TRECT
	$TRECT = _WINAPI_GETCLIENTRECT($HWND)
	Return DllStructGetData($TRECT, "Bottom") - DllStructGetData($TRECT, "Top")
EndFunc


Func _WINAPI_GETCLIENTWIDTH($HWND)
	Local $TRECT
	$TRECT = _WINAPI_GETCLIENTRECT($HWND)
	Return DllStructGetData($TRECT, "Right") - DllStructGetData($TRECT, "Left")
EndFunc


Func _WINAPI_GETCLIENTRECT($HWND)
	Local $TRECT, $ARESULT
	$TRECT = DllStructCreate($TAGRECT)
	$ARESULT = DllCall("User32.dll", "int", "GetClientRect", "hwnd", $HWND, "ptr", DllStructGetPtr($TRECT))
	_WINAPI_CHECK("_WinAPI_GetClientRect", ($ARESULT[0] = 0), 0, True)
	Return $TRECT
EndFunc


Func _WINAPI_GETCURRENTPROCESS()
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "hwnd", "GetCurrentProcess")
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETCURRENTPROCESSID()
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "int", "GetCurrentProcessId")
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETCURRENTTHREAD()
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "int", "GetCurrentThread")
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETCURRENTTHREADID()
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "int", "GetCurrentThreadId")
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETCURSORINFO()
	Local $ICURSOR, $TCURSOR, $ARESULT, $ACURSOR[5]
	$TCURSOR = DllStructCreate($TAGCURSORINFO)
	$ICURSOR = DllStructGetSize($TCURSOR)
	DllStructSetData($TCURSOR, "Size", $ICURSOR)
	$ARESULT = DllCall("User32.dll", "int", "GetCursorInfo", "ptr", DllStructGetPtr($TCURSOR))
	_WINAPI_CHECK("_WinAPI_GetCursorInfo", ($ARESULT[0] = 0), 0, True)
	$ACURSOR[0] = $ARESULT[0] <> 0
	$ACURSOR[1] = DllStructGetData($TCURSOR, "Flags") <> 0
	$ACURSOR[2] = DllStructGetData($TCURSOR, "hCursor")
	$ACURSOR[3] = DllStructGetData($TCURSOR, "X")
	$ACURSOR[4] = DllStructGetData($TCURSOR, "Y")
	Return $ACURSOR
EndFunc


Func _WINAPI_GETDC($HWND)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "hwnd", "GetDC", "hwnd", $HWND)
	_WINAPI_CHECK("_WinAPI_GetDC", ($ARESULT[0] = 0), -1)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETDESKTOPWINDOW()
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "hwnd", "GetDesktopWindow")
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETDEVICECAPS($HDC, $IINDEX)
	Local $ARESULT
	$ARESULT = DllCall("GDI32.dll", "int", "GetDeviceCaps", "hwnd", $HDC, "int", $IINDEX)
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETDIBITS($HDC, $HBMP, $ISTARTSCAN, $ISCANLINES, $PBITS, $PBI, $IUSAGE)
	Local $ARESULT
	$ARESULT = DllCall("GDI32.dll", "int", "GetDIBits", "hwnd", $HDC, "hwnd", $HBMP, "int", $ISTARTSCAN, "int", $ISCANLINES, "ptr", $PBITS, "ptr", $PBI, "int", $IUSAGE)
	_WINAPI_CHECK("_WinAPI_GetDIBits", ($ARESULT[0] = 0), 0, True)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_GETDLGCTRLID($HWND)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "hwnd", "GetDlgCtrlID", "hwnd", $HWND)
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETDLGITEM($HWND, $IITEMID)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "hwnd", "GetDlgItem", "hwnd", $HWND, "int", $IITEMID)
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETFOCUS()
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "hwnd", "GetFocus")
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETFOREGROUNDWINDOW()
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "hwnd", "GetForegroundWindow")
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETICONINFO($HICON)
	Local $TINFO, $ARESULT, $AICON[6]
	$TINFO = DllStructCreate($TAGICONINFO)
	$ARESULT = DllCall("User32.dll", "int", "GetIconInfo", "hwnd", $HICON, "ptr", DllStructGetPtr($TINFO))
	_WINAPI_CHECK("_WinAPI_GetIconInfo", ($ARESULT[0] = 0), 0, True)
	$AICON[0] = $ARESULT[0] <> 0
	$AICON[1] = DllStructGetData($TINFO, "Icon") <> 0
	$AICON[2] = DllStructGetData($TINFO, "XHotSpot")
	$AICON[3] = DllStructGetData($TINFO, "YHotSpot")
	$AICON[4] = DllStructGetData($TINFO, "hMask")
	$AICON[5] = DllStructGetData($TINFO, "hColor")
	Return $AICON
EndFunc


Func _WINAPI_GETFILESIZEEX($HFILE)
	Local $TSIZE
	$TSIZE = DllStructCreate("int64 Size")
	DllCall("Kernel32.dll", "int", "GetFileSizeEx", "hwnd", $HFILE, "ptr", DllStructGetPtr($TSIZE))
	Return SetError(_WINAPI_GETLASTERROR(), 0, DllStructGetData($TSIZE, "Size"))
EndFunc


Func _WINAPI_GETLASTERROR()
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "int", "GetLastError")
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETLASTERRORMESSAGE()
	Local $TTEXT
	$TTEXT = DllStructCreate("char Text[4096]")
	_WINAPI_FORMATMESSAGE($__WINAPCONSTANT_FORMAT_MESSAGE_FROM_SYSTEM, 0, _WINAPI_GETLASTERROR(), 0, DllStructGetPtr($TTEXT), 4096, 0)
	Return DllStructGetData($TTEXT, "Text")
EndFunc


Func _WINAPI_GETMODULEHANDLE($SMODULENAME)
	Local $TTEXT, $ARESULT
	If $SMODULENAME <> "" Then
		$TTEXT = DllStructCreate("char Text[4096]")
		DllStructSetData($TTEXT, "Text", $SMODULENAME)
		$ARESULT = DllCall("Kernel32.dll", "hwnd", "GetModuleHandle", "ptr", DllStructGetPtr($TTEXT))
	Else
		$ARESULT = DllCall("Kernel32.dll", "hwnd", "GetModuleHandle", "ptr", 0)
	EndIf
	_WINAPI_CHECK("_WinAPI_GetModuleHandle", ($ARESULT[0] = 0), 0, True)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETMOUSEPOS($FTOCLIENT = False, $HWND = 0)
	Local $IMODE, $APOS, $TPOINT
	$IMODE = Opt("MouseCoordMode", 1)
	$APOS = MouseGetPos()
	Opt("MouseCoordMode", $IMODE)
	$TPOINT = DllStructCreate($TAGPOINT)
	DllStructSetData($TPOINT, "X", $APOS[0])
	DllStructSetData($TPOINT, "Y", $APOS[1])
	If $FTOCLIENT Then _WINAPI_SCREENTOCLIENT($HWND, $TPOINT)
	Return $TPOINT
EndFunc


Func _WINAPI_GETMOUSEPOSX($FTOCLIENT = False, $HWND = 0)
	Local $TPOINT
	$TPOINT = _WINAPI_GETMOUSEPOS($FTOCLIENT, $HWND)
	Return DllStructGetData($TPOINT, "X")
EndFunc


Func _WINAPI_GETMOUSEPOSY($FTOCLIENT = False, $HWND = 0)
	Local $TPOINT
	$TPOINT = _WINAPI_GETMOUSEPOS($FTOCLIENT, $HWND)
	Return DllStructGetData($TPOINT, "Y")
EndFunc


Func _WINAPI_GETOBJECT($HOBJECT, $ISIZE, $POBJECT)
	Local $ARESULT
	$ARESULT = DllCall("GDI32.dll", "int", "GetObject", "int", $HOBJECT, "int", $ISIZE, "ptr", $POBJECT)
	_WINAPI_CHECK("_WinAPI_GetObject", ($ARESULT[0] = 0), 0, True)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETOPENFILENAME($STITLE = "", $SFILTER = "All files (*.*)", $SINITALDIR = ".", $SDEFAULTFILE = "", $SDEFAULTEXT = "", $IFILTERINDEX = 1, $IFLAGS = 0, $IFLAGSEX = 0, $HWNDOWNER = 0)
	Local $IPATHLEN = 4096
	Local $INULLS = 0
	Local $TOFN = DllStructCreate($TAGOPENFILENAME)
	Local $AFILES[1]
	Local $IFLAG = $IFLAGS
	Local $ASFLINES = StringSplit($SFILTER, "|")
	Local $ASFILTER[$ASFLINES[0] * 2 + 1]
	Local $I, $ISTART, $IFINAL, $STFILTER
	$ASFILTER[0] = $ASFLINES[0] * 2
	For $I = 1 To $ASFLINES[0]
		$ISTART = StringInStr($ASFLINES[$I], "(", 0, 1)
		$IFINAL = StringInStr($ASFLINES[$I], ")", 0, -1)
		$ASFILTER[$I * 2 - 1] = StringStripWS(StringLeft($ASFLINES[$I], $ISTART - 1), 3)
		$ASFILTER[$I * 2] = StringStripWS(StringTrimRight(StringTrimLeft($ASFLINES[$I], $ISTART), StringLen($ASFLINES[$I]) - $IFINAL + 1), 3)
		$STFILTER &= "char[" & StringLen($ASFILTER[$I * 2 - 1]) + 1 & "];char[" & StringLen($ASFILTER[$I * 2]) + 1 & "];"
	Next
	Local $TTITLE = DllStructCreate("char Title[" & StringLen($STITLE) + 1 & "]")
	Local $TINITIALDIR = DllStructCreate("char InitDir[" & StringLen($SINITALDIR) + 1 & "]")
	Local $TFILTER = DllStructCreate($STFILTER & "char")
	Local $TPATH = DllStructCreate("char Path[" & $IPATHLEN & "]")
	Local $TEXTN = DllStructCreate("char Extension[" & StringLen($SDEFAULTEXT) + 1 & "]")
	For $I = 1 To $ASFILTER[0]
		DllStructSetData($TFILTER, $I, $ASFILTER[$I])
	Next
	Local $IRESULT
	DllStructSetData($TTITLE, "Title", $STITLE)
	DllStructSetData($TINITIALDIR, "InitDir", $SINITALDIR)
	DllStructSetData($TPATH, "Path", $SDEFAULTFILE)
	DllStructSetData($TEXTN, "Extension", $SDEFAULTEXT)
	DllStructSetData($TOFN, "StructSize", DllStructGetSize($TOFN))
	DllStructSetData($TOFN, "hwndOwner", $HWNDOWNER)
	DllStructSetData($TOFN, "lpstrFilter", DllStructGetPtr($TFILTER))
	DllStructSetData($TOFN, "nFilterIndex", $IFILTERINDEX)
	DllStructSetData($TOFN, "lpstrFile", DllStructGetPtr($TPATH))
	DllStructSetData($TOFN, "nMaxFile", $IPATHLEN)
	DllStructSetData($TOFN, "lpstrInitialDir", DllStructGetPtr($TINITIALDIR))
	DllStructSetData($TOFN, "lpstrTitle", DllStructGetPtr($TTITLE))
	DllStructSetData($TOFN, "Flags", $IFLAG)
	DllStructSetData($TOFN, "lpstrDefExt", DllStructGetPtr($TEXTN))
	DllStructSetData($TOFN, "FlagsEx", $IFLAGSEX)
	$IRESULT = DllCall("comdlg32.dll", "int", "GetOpenFileName", "ptr", DllStructGetPtr($TOFN))
	If @error Or $IRESULT[0] = 0 Then Return SetError(@error, @extended, $AFILES)
	If BitAND($IFLAGS, $OFN_ALLOWMULTISELECT) = $OFN_ALLOWMULTISELECT And BitAND($IFLAGS, $OFN_EXPLORER) = $OFN_EXPLORER Then
		For $X = 1 To $IPATHLEN
			If DllStructGetData($TPATH, "Path", $X) = Chr(0) Then
				DllStructSetData($TPATH, "Path", "|", $X)
				$INULLS += 1
			Else
				$INULLS = 0
			EndIf
			If $INULLS = 2 Then ExitLoop
		Next
		DllStructSetData($TPATH, "Path", Chr(0), $X - 1)
		$AFILES = StringSplit(DllStructGetData($TPATH, "Path"), "|")
		If $AFILES[0] = 1 Then Return _WINAPI_PARSEFILEDIALOGPATH(DllStructGetData($TPATH, "Path"))
		Return StringSplit(DllStructGetData($TPATH, "Path"), "|")
	ElseIf BitAND($IFLAGS, $OFN_ALLOWMULTISELECT) = $OFN_ALLOWMULTISELECT Then
		$AFILES = StringSplit(DllStructGetData($TPATH, "Path"), " ")
		If $AFILES[0] = 1 Then Return _WINAPI_PARSEFILEDIALOGPATH(DllStructGetData($TPATH, "Path"))
		Return StringSplit(StringReplace(DllStructGetData($TPATH, "Path"), " ", "|"), "|")
	Else
		Return _WINAPI_PARSEFILEDIALOGPATH(DllStructGetData($TPATH, "Path"))
	EndIf
EndFunc


Func _WINAPI_GETOVERLAPPEDRESULT($HFILE, $POVERLAPPED, ByRef $IBYTES, $FWAIT = False)
	Local $PREAD, $TREAD, $ARESULT
	$TREAD = DllStructCreate("int Read")
	$PREAD = DllStructGetPtr($TREAD)
	$ARESULT = DllCall("Kernel32.dll", "int", "GetOverlappedResult", "int", $HFILE, "ptr", $POVERLAPPED, "ptr", $PREAD, "int", $FWAIT)
	$IBYTES = DllStructGetData($TREAD, "Read")
	Return SetError(_WINAPI_GETLASTERROR(), 0, $ARESULT[0] <> 0)
EndFunc


Func _WINAPI_GETPARENT($HWND)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "hwnd", "GetParent", "hwnd", $HWND)
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETPROCESSAFFINITYMASK($HPROCESS)
	Local $PPROCESS, $TPROCESS, $PSYSTEM, $TSYSTEM, $ARESULT, $AMASK[3]
	$TPROCESS = DllStructCreate("int Data")
	$PPROCESS = DllStructGetPtr($TPROCESS)
	$TSYSTEM = DllStructCreate("int Data")
	$PSYSTEM = DllStructGetPtr($TSYSTEM)
	$ARESULT = DllCall("Kernel32.dll", "int", "GetProcessAffinityMask", "hwnd", $HPROCESS, "ptr", $PPROCESS, "ptr", $PSYSTEM)
	If @error Then Return SetError(@error, 0, $AMASK)
	$AMASK[0] = $ARESULT[0] <> 0
	$AMASK[1] = DllStructGetData($TPROCESS, "Data")
	$AMASK[2] = DllStructGetData($TSYSTEM, "Data")
	Return $AMASK
EndFunc


Func _WINAPI_GETSAVEFILENAME($STITLE = "", $SFILTER = "All files (*.*)", $SINITALDIR = ".", $SDEFAULTFILE = "", $SDEFAULTEXT = "", $IFILTERINDEX = 1, $IFLAGS = 0, $IFLAGSEX = 0, $HWNDOWNER = 0)
	Local $IPATHLEN = 4096
	Local $TOFN = DllStructCreate($TAGOPENFILENAME)
	Local $AFILES[1]
	Local $IFLAG = $IFLAGS
	Local $ASFLINES = StringSplit($SFILTER, "|")
	Local $ASFILTER[$ASFLINES[0] * 2 + 1]
	Local $I, $ISTART, $IFINAL, $STFILTER
	$ASFILTER[0] = $ASFLINES[0] * 2
	For $I = 1 To $ASFLINES[0]
		$ISTART = StringInStr($ASFLINES[$I], "(", 0, 1)
		$IFINAL = StringInStr($ASFLINES[$I], ")", 0, -1)
		$ASFILTER[$I * 2 - 1] = StringStripWS(StringLeft($ASFLINES[$I], $ISTART - 1), 3)
		$ASFILTER[$I * 2] = StringStripWS(StringTrimRight(StringTrimLeft($ASFLINES[$I], $ISTART), StringLen($ASFLINES[$I]) - $IFINAL + 1), 3)
		$STFILTER &= "char[" & StringLen($ASFILTER[$I * 2 - 1]) + 1 & "];char[" & StringLen($ASFILTER[$I * 2]) + 1 & "];"
	Next
	Local $TTITLE = DllStructCreate("char Title[" & StringLen($STITLE) + 1 & "]")
	Local $TINITIALDIR = DllStructCreate("char InitDir[" & StringLen($SINITALDIR) + 1 & "]")
	Local $TFILTER = DllStructCreate($STFILTER & "char")
	Local $TPATH = DllStructCreate("char Path[" & $IPATHLEN & "]")
	Local $TEXTN = DllStructCreate("char Extension[" & StringLen($SDEFAULTEXT) + 1 & "]")
	For $I = 1 To $ASFILTER[0]
		DllStructSetData($TFILTER, $I, $ASFILTER[$I])
	Next
	Local $IRESULT
	DllStructSetData($TTITLE, "Title", $STITLE)
	DllStructSetData($TINITIALDIR, "InitDir", $SINITALDIR)
	DllStructSetData($TPATH, "Path", $SDEFAULTFILE)
	DllStructSetData($TEXTN, "Extension", $SDEFAULTEXT)
	DllStructSetData($TOFN, "StructSize", DllStructGetSize($TOFN))
	DllStructSetData($TOFN, "hwndOwner", $HWNDOWNER)
	DllStructSetData($TOFN, "lpstrFilter", DllStructGetPtr($TFILTER))
	DllStructSetData($TOFN, "nFilterIndex", $IFILTERINDEX)
	DllStructSetData($TOFN, "lpstrFile", DllStructGetPtr($TPATH))
	DllStructSetData($TOFN, "nMaxFile", $IPATHLEN)
	DllStructSetData($TOFN, "lpstrInitialDir", DllStructGetPtr($TINITIALDIR))
	DllStructSetData($TOFN, "lpstrTitle", DllStructGetPtr($TTITLE))
	DllStructSetData($TOFN, "Flags", $IFLAG)
	DllStructSetData($TOFN, "lpstrDefExt", DllStructGetPtr($TEXTN))
	DllStructSetData($TOFN, "FlagsEx", $IFLAGSEX)
	$IRESULT = DllCall("comdlg32.dll", "int", "GetSaveFileName", "ptr", DllStructGetPtr($TOFN))
	If @error Or $IRESULT[0] = 0 Then Return SetError(@error, @extended, $AFILES)
	Return _WINAPI_PARSEFILEDIALOGPATH(DllStructGetData($TPATH, "Path"))
EndFunc


Func _WINAPI_GETSTOCKOBJECT($IOBJECT)
	Local $ARESULT
	$ARESULT = DllCall("GDI32.dll", "hwnd", "GetStockObject", "int", $IOBJECT)
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETSTDHANDLE($ISTDHANDLE)
	Local $AHANDLE[3] = [ -10, -11, -12], $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "int", "GetStdHandle", "int", $AHANDLE[$ISTDHANDLE])
	Return SetError(_WINAPI_GETLASTERROR(), 0, $ARESULT[0])
EndFunc


Func _WINAPI_GETSYSCOLOR($IINDEX)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "GetSysColor", "int", $IINDEX)
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETSYSCOLORBRUSH($IINDEX)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "GetSysColorBrush", "int", $IINDEX)
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETSYSTEMMETRICS($IINDEX)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "GetSystemMetrics", "int", $IINDEX)
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETTEXTEXTENTPOINT32($HDC, $STEXT)
	Local $TSIZE, $ISIZE, $ARESULT
	$TSIZE = DllStructCreate($TAGSIZE)
	$ISIZE = StringLen($STEXT)
	$ARESULT = DllCall("GDI32.dll", "int", "GetTextExtentPoint32", "hwnd", $HDC, "str", $STEXT, "int", $ISIZE, "ptr", DllStructGetPtr($TSIZE))
	_WINAPI_CHECK("_WinAPI_GetTextExtentPoint32", ($ARESULT[0] = 0), 0, True)
	Return $TSIZE
EndFunc


Func _WINAPI_GETWINDOW($HWND, $ICMD)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "hwnd", "GetWindow", "hwnd", $HWND, "int", $ICMD)
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETWINDOWDC($HWND)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "hwnd", "GetWindowDC", "hwnd", $HWND)
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETWINDOWHEIGHT($HWND)
	Local $TRECT
	$TRECT = _WINAPI_GETWINDOWRECT($HWND)
	Return DllStructGetData($TRECT, "Bottom") - DllStructGetData($TRECT, "Top")
EndFunc


Func _WINAPI_GETWINDOWLONG($HWND, $IINDEX)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "GetWindowLong", "hwnd", $HWND, "int", $IINDEX)
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETWINDOWPLACEMENT($HWND)
	Local $TWINDOWPLACEMENT = DllStructCreate($TAGWINDOWPLACEMENT)
	DllStructSetData($TWINDOWPLACEMENT, "length", DllStructGetSize($TWINDOWPLACEMENT))
	Local $PWINDOWPLACEMENT = DllStructGetPtr($TWINDOWPLACEMENT)
	Local $AVRET = DllCall("user32.dll", "int", "GetWindowPlacement", "hwnd", $HWND, "ptr", $PWINDOWPLACEMENT)
	If @error Then Return SetError(@error, 0, 0)
	If $AVRET[0] Then
		Return $TWINDOWPLACEMENT
	Else
		Return SetError(1, _WINAPI_GETLASTERROR(), 0)
	EndIf
EndFunc


Func _WINAPI_GETWINDOWRECT($HWND)
	Local $TRECT
	$TRECT = DllStructCreate($TAGRECT)
	DllCall("User32.dll", "int", "GetWindowRect", "hwnd", $HWND, "ptr", DllStructGetPtr($TRECT))
	If @error Then Return SetError(@error, 0, $TRECT)
	Return $TRECT
EndFunc


Func _WINAPI_GETWINDOWRGN($HWND, $HRGN)
	Local $ARESULT = DllCall("user32.dll", "int", "GetWindowRgn", "hwnd", $HWND, "hwnd", $HRGN)
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETWINDOWTEXT($HWND)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "GetWindowText", "hwnd", $HWND, "str", "", "int", 4096)
	If @error Then Return SetError(@error, 0, "")
	Return $ARESULT[2]
EndFunc


Func _WINAPI_GETWINDOWTHREADPROCESSID($HWND, ByRef $IPID)
	Local $PPID, $TPID, $ARESULT
	$TPID = DllStructCreate("int ID")
	$PPID = DllStructGetPtr($TPID)
	$ARESULT = DllCall("User32.dll", "int", "GetWindowThreadProcessId", "hwnd", $HWND, "ptr", $PPID)
	If @error Then Return SetError(@error, 0, 0)
	$IPID = DllStructGetData($TPID, "ID")
	Return $ARESULT[0]
EndFunc


Func _WINAPI_GETWINDOWWIDTH($HWND)
	Local $TRECT
	$TRECT = _WINAPI_GETWINDOWRECT($HWND)
	Return DllStructGetData($TRECT, "Right") - DllStructGetData($TRECT, "Left")
EndFunc


Func _WINAPI_GETXYFROMPOINT(ByRef $TPOINT, ByRef $IX, ByRef $IY)
	$IX = DllStructGetData($TPOINT, "X")
	$IY = DllStructGetData($TPOINT, "Y")
EndFunc


Func _WINAPI_GLOBALMEMSTATUS()
	Local $IMEM, $PMEM, $TMEM, $AMEM[7]
	$TMEM = DllStructCreate("int;int;int;int;int;int;int;int;int")
	$PMEM = DllStructGetPtr($TMEM)
	$IMEM = DllStructGetSize($TMEM)
	DllStructSetData($TMEM, 1, $IMEM)
	DllCall("Kernel32.dll", "none", "GlobalMemStatus", "ptr", $PMEM)
	If @error Then Return SetError(@error, 0, $AMEM)
	$AMEM[0] = DllStructGetData($TMEM, 2)
	$AMEM[1] = DllStructGetData($TMEM, 3)
	$AMEM[2] = DllStructGetData($TMEM, 4)
	$AMEM[3] = DllStructGetData($TMEM, 5)
	$AMEM[4] = DllStructGetData($TMEM, 6)
	$AMEM[5] = DllStructGetData($TMEM, 7)
	$AMEM[6] = DllStructGetData($TMEM, 8)
	Return $AMEM
EndFunc


Func _WINAPI_GUIDFROMSTRING($SGUID)
	Local $TGUID
	$TGUID = DllStructCreate($TAGGUID)
	_WINAPI_GUIDFROMSTRINGEX($SGUID, DllStructGetPtr($TGUID))
	Return SetError(@error, 0, $TGUID)
EndFunc


Func _WINAPI_GUIDFROMSTRINGEX($SGUID, $PGUID)
	Local $TDATA, $ARESULT
	$TDATA = _WINAPI_MULTIBYTETOWIDECHAR($SGUID)
	$ARESULT = DllCall("Ole32.dll", "int", "CLSIDFromString", "ptr", DllStructGetPtr($TDATA), "ptr", $PGUID)
	If @error Then Return SetError(@error, 0, False)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_HIWORD($ILONG)
	Return BitShift($ILONG, 16)
EndFunc


Func _WINAPI_INPROCESS($HWND, ByRef $HLASTWND)
	Local $II, $ICOUNT, $IPROCESSID
	If $HWND = $HLASTWND Then Return True
	For $II = $WINAPI_GAINPROCESS[0][0] To 1 Step - 1
		If $HWND = $WINAPI_GAINPROCESS[$II][0] Then
			If $WINAPI_GAINPROCESS[$II][1] Then
				$HLASTWND = $HWND
				Return True
			Else
				Return False
			EndIf
		EndIf
	Next
	_WINAPI_GETWINDOWTHREADPROCESSID($HWND, $IPROCESSID)
	$ICOUNT = $WINAPI_GAINPROCESS[0][0] + 1
	If $ICOUNT >= 64 Then $ICOUNT = 1
	$WINAPI_GAINPROCESS[0][0] = $ICOUNT
	$WINAPI_GAINPROCESS[$ICOUNT][0] = $HWND
	$WINAPI_GAINPROCESS[$ICOUNT][1] = ($IPROCESSID = @AutoItPID)
	Return $WINAPI_GAINPROCESS[$ICOUNT][1]
EndFunc


Func _WINAPI_INTTOFLOAT($IINT)
	Local $TFLOAT, $TINT
	$TINT = DllStructCreate("int")
	$TFLOAT = DllStructCreate("float", DllStructGetPtr($TINT))
	DllStructSetData($TINT, 1, $IINT)
	Return DllStructGetData($TFLOAT, 1)
EndFunc


Func _WINAPI_ISCLASSNAME($HWND, $SCLASSNAME)
	Local $SSEPERATOR, $ACLASSNAME, $SCLASSCHECK
	$SSEPERATOR = Opt("GUIDataSeparatorChar")
	$ACLASSNAME = StringSplit($SCLASSNAME, $SSEPERATOR)
	If Not IsHWnd($HWND) Then $HWND = GUICtrlGetHandle($HWND)
	$SCLASSCHECK = _WINAPI_GETCLASSNAME($HWND)
	For $X = 1 To UBound($ACLASSNAME) - 1
		If StringUpper(StringMid($SCLASSCHECK, 1, StringLen($ACLASSNAME[$X]))) = StringUpper($ACLASSNAME[$X]) Then
			Return True
		EndIf
	Next
	Return False
EndFunc


Func _WINAPI_ISWINDOW($HWND)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "IsWindow", "hwnd", $HWND)
	If @error Then Return SetError(@error, 0, False)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_ISWINDOWVISIBLE($HWND)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "IsWindowVisible", "hwnd", $HWND)
	If @error Then Return SetError(@error, 0, False)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_INVALIDATERECT($HWND, $TRECT = 0, $FERASE = True)
	Local $PRECT, $ARESULT
	If $TRECT <> 0 Then $PRECT = DllStructGetPtr($TRECT)
	$ARESULT = DllCall("User32.dll", "int", "InvalidateRect", "hwnd", $HWND, "ptr", $PRECT, "int", $FERASE)
	If @error Then Return SetError(@error, 0, False)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_LINETO($HDC, $IX, $IY)
	Local $ARESULT = DllCall("gdi32.dll", "int", "LineTo", "int", $HDC, "int", $IX, "int", $IY)
	If @error Then Return SetError(@error, 0, False)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_LOADBITMAP($HINSTANCE, $SBITMAP)
	Local $ARESULT, $STYPE = "int"
	If IsString($SBITMAP) Then $STYPE = "str"
	$ARESULT = DllCall("User32.dll", "hwnd", "LoadBitmap", "hwnd", $HINSTANCE, $STYPE, $SBITMAP)
	_WINAPI_CHECK("_WinAPI_LoadBitmap", ($ARESULT[0] = 0), 0, True)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_LOADIMAGE($HINSTANCE, $SIMAGE, $ITYPE, $IXDESIRED, $IYDESIRED, $ILOAD)
	Local $ARESULT, $STYPE = "int"
	If IsString($SIMAGE) Then $STYPE = "str"
	$ARESULT = DllCall("User32.dll", "hwnd", "LoadImage", "hwnd", $HINSTANCE, $STYPE, $SIMAGE, "int", $ITYPE, "int", $IXDESIRED, "int", $IYDESIRED, "int", $ILOAD)
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_LOADLIBRARY($SFILENAME)
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "hwnd", "LoadLibraryA", "str", $SFILENAME)
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_LOADLIBRARYEX($SFILENAME, $IFLAGS = 0)
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "hwnd", "LoadLibraryExA", "str", $SFILENAME, "hwnd", 0, "int", $IFLAGS)
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_LOADSHELL32ICON($IICONID)
	Local $IICONS, $TICONS, $PICONS
	$TICONS = DllStructCreate("int Data")
	$PICONS = DllStructGetPtr($TICONS)
	$IICONS = _WINAPI_EXTRACTICONEX("Shell32.dll", $IICONID, 0, $PICONS, 1)
	_WINAPI_CHECK("_Lib_GetShell32Icon", ($IICONS = 0), -1)
	Return DllStructGetData($TICONS, "Data")
EndFunc


Func _WINAPI_LOADSTRING($HINSTANCE, $ISTRINGID)
	Local $IRESULT, $IBUFFERMAX = 4096
	$IRESULT = DllCall("user32.dll", "int", "LoadString", "hwnd", $HINSTANCE, "uint", $ISTRINGID, "str", "", "int", $IBUFFERMAX)
	If @error Or Not IsArray($IRESULT) Or $IRESULT[0] = 0 Then Return SetError(-1, -1, "")
	Return SetError(0, $IRESULT[0], $IRESULT[3])
EndFunc


Func _WINAPI_LOCALFREE($HMEM)
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "hwnd", "LocalFree", "hwnd", $HMEM)
	_WINAPI_CHECK("_WinAPI_LocalFree", ($ARESULT[0] <> 0), 0, True)
	Return $ARESULT[0] = 0
EndFunc


Func _WINAPI_LOWORD($ILONG)
	Return BitAND($ILONG, 65535)
EndFunc


Func _WINAPI_MAKEDWORD($HIWORD, $LOWORD)
	Return BitOR($LOWORD * 65536, BitAND($HIWORD, 65535))
EndFunc


Func _WINAPI_MAKELANGID($LGIDPRIMARY, $LGIDSUB)
	Return BitOR(BitShift($LGIDSUB, -10), $LGIDPRIMARY)
EndFunc


Func _WINAPI_MAKELCID($LGID, $SRTID)
	Return BitOR(BitShift($SRTID, -16), $LGID)
EndFunc


Func _WINAPI_MAKELONG($ILO, $IHI)
	Return BitOR(BitShift($IHI, -16), BitAND($ILO, 65535))
EndFunc


Func _WINAPI_MESSAGEBEEP($ITYPE = 1)
	Local $ISOUND, $ARESULT
	Switch $ITYPE
		Case 1
			$ISOUND = 0
		Case 2
			$ISOUND = 16
		Case 3
			$ISOUND = 32
		Case 4
			$ISOUND = 48
		Case 5
			$ISOUND = 64
		Case Else
			$ISOUND = -1
	EndSwitch
	$ARESULT = DllCall("User32.dll", "int", "MessageBeep", "uint", $ISOUND)
	Return SetError(_WINAPI_GETLASTERROR(), 0, $ARESULT[0] <> 0)
EndFunc


Func _WINAPI_MSGBOX($IFLAGS, $STITLE, $STEXT)
	BlockInput(0)
	MsgBox($IFLAGS, $STITLE, $STEXT & "      ")
EndFunc


Func _WINAPI_MOUSE_EVENT($IFLAGS, $IX = 0, $IY = 0, $IDATA = 0, $IEXTRAINFO = 0)
	DllCall("User32.dll", "none", "mouse_event", "int", $IFLAGS, "int", $IX, "int", $IY, "int", $IDATA, "int", $IEXTRAINFO)
EndFunc


Func _WINAPI_MOVETO($HDC, $IX, $IY)
	Local $ARESULT = DllCall("gdi32.dll", "int", "MoveToEx", "int", $HDC, "int", $IX, "int", $IY, "ptr", 0)
	If @error Then Return SetError(@error, 0, False)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_MOVEWINDOW($HWND, $IX, $IY, $IWIDTH, $IHEIGHT, $FREPAINT = True)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "MoveWindow", "hwnd", $HWND, "int", $IX, "int", $IY, "int", $IWIDTH, "int", $IHEIGHT, "int", $FREPAINT)
	If @error Then Return SetError(@error, 0, False)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_MULDIV($INUMBER, $INUMERATOR, $IDENOMINATOR)
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "int", "MulDiv", "int", $INUMBER, "int", $INUMERATOR, "int", $IDENOMINATOR)
	_WINAPI_CHECK("_MultDiv", ($ARESULT[0] = -1), -1)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_MULTIBYTETOWIDECHAR($STEXT, $ICODEPAGE = 0, $IFLAGS = 0)
	Local $ITEXT, $PTEXT, $TTEXT
	$ITEXT = StringLen($STEXT) + 1
	$TTEXT = DllStructCreate("byte[" & $ITEXT * 2 & "]")
	$PTEXT = DllStructGetPtr($TTEXT)
	DllCall("Kernel32.dll", "int", "MultiByteToWideChar", "int", $ICODEPAGE, "int", $IFLAGS, "str", $STEXT, "int", $ITEXT, "ptr", $PTEXT, "int", $ITEXT * 2)
	If @error Then Return SetError(@error, 0, $TTEXT)
	Return $TTEXT
EndFunc


Func _WINAPI_MULTIBYTETOWIDECHAREX($STEXT, $PTEXT, $ICODEPAGE = 0, $IFLAGS = 0)
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "int", "MultiByteToWideChar", "int", $ICODEPAGE, "int", $IFLAGS, "str", $STEXT, "int", -1, "ptr", $PTEXT, "int", (StringLen($STEXT) + 1) * 2)
	If @error Then Return SetError(@error, 0, False)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_OPENPROCESS($IACCESS, $FINHERIT, $IPROCESSID, $FDEBUGPRIV = False)
	Local $HTOKEN, $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "int", "OpenProcess", "int", $IACCESS, "int", $FINHERIT, "int", $IPROCESSID)
	If Not $FDEBUGPRIV Or ($ARESULT[0] <> 0) Then
		_WINAPI_CHECK("_WinAPI_OpenProcess:Standard", ($ARESULT[0] = 0), 0, True)
		Return $ARESULT[0]
	EndIf
	$HTOKEN = _SECURITY__OPENTHREADTOKENEX(BitOR($__WINAPCONSTANT_TOKEN_ADJUST_PRIVILEGES, $__WINAPCONSTANT_TOKEN_QUERY))
	_WINAPI_CHECK("_WinAPI_OpenProcess:OpenThreadTokenEx", @error, @extended)
	_SECURITY__SETPRIVILEGE($HTOKEN, "SeDebugPrivilege", True)
	_WINAPI_CHECK("_WinAPI_OpenProcess:SetPrivilege:Enable", @error, @extended)
	$ARESULT = DllCall("Kernel32.dll", "int", "OpenProcess", "int", $IACCESS, "int", $FINHERIT, "int", $IPROCESSID)
	_WINAPI_CHECK("_WinAPI_OpenProcess:Priviliged", ($ARESULT[0] = 0), 0, True)
	_SECURITY__SETPRIVILEGE($HTOKEN, "SeDebugPrivilege", False)
	_WINAPI_CHECK("_WinAPI_OpenProcess:SetPrivilege:Disable", @error, @extended)
	_WINAPI_CLOSEHANDLE($HTOKEN)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_PARSEFILEDIALOGPATH($SPATH)
	Local $AFILES[3], $STEMP
	$AFILES[0] = 2
	$STEMP = StringMid($SPATH, 1, StringInStr($SPATH, "\", 0, -1) - 1)
	$AFILES[1] = $STEMP
	$AFILES[2] = StringMid($SPATH, StringInStr($SPATH, "\", 0, -1) + 1)
	Return $AFILES
EndFunc


Func _WINAPI_POINTFROMRECT(ByRef $TRECT, $FCENTER = True)
	Local $IX1, $IY1, $IX2, $IY2, $TPOINT
	$IX1 = DllStructGetData($TRECT, "Left")
	$IY1 = DllStructGetData($TRECT, "Top")
	$IX2 = DllStructGetData($TRECT, "Right")
	$IY2 = DllStructGetData($TRECT, "Bottom")
	If $FCENTER Then
		$IX1 = $IX1 + (($IX2 - $IX1) / 2)
		$IY1 = $IY1 + (($IY2 - $IY1) / 2)
	EndIf
	$TPOINT = DllStructCreate($TAGPOINT)
	DllStructSetData($TPOINT, "X", $IX1)
	DllStructSetData($TPOINT, "Y", $IY1)
	Return $TPOINT
EndFunc


Func _WINAPI_POSTMESSAGE($HWND, $IMSG, $IWPARAM, $ILPARAM)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "PostMessageA", "hwnd", $HWND, "int", $IMSG, "int", $IWPARAM, "int", $ILPARAM)
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_PRIMARYLANGID($LGID)
	Return BitAND($LGID, 1023)
EndFunc


Func _WINAPI_PTINRECT(ByRef $TRECT, ByRef $TPOINT)
	Local $IX, $IY, $ARESULT
	$IX = DllStructGetData($TPOINT, "X")
	$IY = DllStructGetData($TPOINT, "Y")
	$ARESULT = DllCall("User32.dll", "int", "PtInRect", "ptr", DllStructGetPtr($TRECT), "int", $IX, "int", $IY)
	If @error Then Return SetError(@error, 0, False)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_READFILE($HFILE, $PBUFFER, $ITOREAD, ByRef $IREAD, $POVERLAPPED = 0)
	Local $ARESULT, $PREAD, $TREAD
	$TREAD = DllStructCreate("int Read")
	$PREAD = DllStructGetPtr($TREAD)
	$ARESULT = DllCall("Kernel32.dll", "int", "ReadFile", "hwnd", $HFILE, "ptr", $PBUFFER, "int", $ITOREAD, "ptr", $PREAD, "ptr", $POVERLAPPED)
	$IREAD = DllStructGetData($TREAD, "Read")
	Return SetError(_WINAPI_GETLASTERROR(), 0, $ARESULT[0] <> 0)
EndFunc


Func _WINAPI_READPROCESSMEMORY($HPROCESS, $PBASEADDRESS, $PBUFFER, $ISIZE, ByRef $IREAD)
	Local $PREAD, $TREAD, $ARESULT
	$TREAD = DllStructCreate("int Read")
	$PREAD = DllStructGetPtr($TREAD)
	$ARESULT = DllCall("Kernel32.dll", "int", "ReadProcessMemory", "int", $HPROCESS, "int", $PBASEADDRESS, "ptr", $PBUFFER, "int", $ISIZE, "ptr", $PREAD)
	_WINAPI_CHECK("_WinAPI_ReadProcessMemory", ($ARESULT[0] = 0), 0, True)
	$IREAD = DllStructGetData($TREAD, "Read")
	Return $ARESULT[0]
EndFunc


Func _WINAPI_RECTISEMPTY(ByRef $TRECT)
	Return (DllStructGetData($TRECT, "Left") = 0) And (DllStructGetData($TRECT, "Top") = 0) And (DllStructGetData($TRECT, "Right") = 0) And (DllStructGetData($TRECT, "Bottom") = 0)
EndFunc


Func _WINAPI_REDRAWWINDOW($HWND, $TRECT = 0, $HREGION = 0, $IFLAGS = 5)
	Local $PRECT, $ARESULT
	If $TRECT <> 0 Then $PRECT = DllStructGetPtr($TRECT)
	$ARESULT = DllCall("User32.dll", "int", "RedrawWindow", "hwnd", $HWND, "ptr", $PRECT, "int", $HREGION, "int", $IFLAGS)
	If @error Then Return SetError(@error, 0, False)
	Return ($ARESULT[0] <> 0)
EndFunc


Func _WINAPI_REGISTERWINDOWMESSAGE($SMESSAGE)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "RegisterWindowMessage", "str", $SMESSAGE)
	_WINAPI_CHECK("_WinAPI_RegisterWindowMessage", ($ARESULT[0] = 0), 0, True)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_RELEASECAPTURE()
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "ReleaseCapture")
	If @error Then Return SetError(@error, 0, False)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_RELEASEDC($HWND, $HDC)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "ReleaseDC", "hwnd", $HWND, "hwnd", $HDC)
	If @error Then Return SetError(@error, 0, False)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_SCREENTOCLIENT($HWND, ByRef $TPOINT)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "ScreenToClient", "hwnd", $HWND, "ptr", DllStructGetPtr($TPOINT))
	If @error Then Return SetError(@error, 0, False)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_SELECTOBJECT($HDC, $HGDIOBJ)
	Local $ARESULT
	$ARESULT = DllCall("GDI32.dll", "hwnd", "SelectObject", "hwnd", $HDC, "hwnd", $HGDIOBJ)
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_SETBKCOLOR($HDC, $ICOLOR)
	Local $ARESULT
	$ARESULT = DllCall("GDI32.dll", "int", "SetBkColor", "hwnd", $HDC, "int", $ICOLOR)
	If @error Then Return SetError(@error, 0, 65535)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_SETBKMODE($HDC, $IBKMODE)
	Local $ARESULT = DllCall("gdi32.dll", "int", "SetBkMode", "ptr", $HDC, "int", $IBKMODE)
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_SETCAPTURE($HWND)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "hwnd", "SetCapture", "hwnd", $HWND)
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_SETCURSOR($HCURSOR)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "hwnd", "SetCursor", "hwnd", $HCURSOR)
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_SETDEFAULTPRINTER($SPRINTER)
	Local $ARESULT
	$ARESULT = DllCall("WinSpool.drv", "int", "SetDefaultPrinterA", "str", $SPRINTER)
	If @error Then Return SetError(@error, 0, False)
	Return SetError($ARESULT[0] = 0, 0, $ARESULT[0] <> 0)
EndFunc


Func _WINAPI_SETDIBITS($HDC, $HBMP, $ISTARTSCAN, $ISCANLINES, $PBITS, $PBMI, $ICOLORUSE = 0)
	Local $ARESULT
	$ARESULT = DllCall("GDI32.dll", "int", "SetDIBits", "hwnd", $HDC, "hwnd", $HBMP, "uint", $ISTARTSCAN, "uint", $ISCANLINES, "ptr", $PBITS, "ptr", $PBMI, "uint", $ICOLORUSE)
	If @error Then Return SetError(@error, 0, False)
	Return SetError($ARESULT[0] = 0, _WINAPI_GETLASTERROR(), $ARESULT[0] <> 0)
EndFunc


Func _WINAPI_SETENDOFFILE($HFILE)
	Local $ARESULT
	$ARESULT = DllCall("kernel32.dll", "int", "SetEndOfFile", "hwnd", $HFILE)
	If @error Then Return SetError(@error, 0, False)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_SETEVENT($HEVENT)
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "int", "SetEvent", "hwnd", $HEVENT)
	Return SetError(_WINAPI_GETLASTERROR(), 0, $ARESULT[0] <> 0)
EndFunc


Func _WINAPI_SETFILEPOINTER($HFILE, $IPOS, $IMETHOD = 0)
	Local $ARESULT
	$ARESULT = DllCall("kernel32.dll", "long", "SetFilePointer", "hwnd", $HFILE, "long", $IPOS, "long_ptr", 0, "long", $IMETHOD)
	If @error Then Return SetError(1, 0, -1)
	If $ARESULT[0] = $__WINAPCONSTANT_INVALID_SET_FILE_POINTER Then Return SetError(2, 0, -1)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_SETFOCUS($HWND)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "hwnd", "SetFocus", "hwnd", $HWND)
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_SETFONT($HWND, $HFONT, $FREDRAW = True)
	_SENDMESSAGE($HWND, $__WINAPCONSTANT_WM_SETFONT, $HFONT, $FREDRAW, 0, "hwnd")
EndFunc


Func _WINAPI_SETHANDLEINFORMATION($HOBJECT, $IMASK, $IFLAGS)
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "int", "SetHandleInformation", "hwnd", $HOBJECT, "uint", $IMASK, "uint", $IFLAGS)
	_WINAPI_CHECK("_WinAPI_SetHandleInformation", $ARESULT[0] = 0, 0, True)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_SETLASTERROR($IERRCODE)
	DllCall("Kernel32.dll", "none", "SetLastError", "dword", $IERRCODE)
EndFunc


Func _WINAPI_SETPARENT($HWNDCHILD, $HWNDPARENT)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "hwnd", "SetParent", "hwnd", $HWNDCHILD, "hwnd", $HWNDPARENT)
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_SETPROCESSAFFINITYMASK($HPROCESS, $IMASK)
	Local $IRESULT
	$IRESULT = DllCall("Kernel32.dll", "int", "SetProcessAffinityMask", "hwnd", $HPROCESS, "int", $IMASK)
	_WINAPI_CHECK("_WinAPI_SetProcessAffinityMask", ($IRESULT[0] = 0), 0, True)
	Return $IRESULT[0] <> 0
EndFunc


Func _WINAPI_SETSYSCOLORS($VELEMENTS, $VCOLORS)
	Local $ISEARRAY = IsArray($VELEMENTS), $ISCARRAY = IsArray($VCOLORS)
	Local $IELEMENTNUM
	If Not $ISCARRAY And Not $ISEARRAY Then
		$IELEMENTNUM = 1
	ElseIf $ISCARRAY Or $ISEARRAY Then
		If Not $ISCARRAY Or Not $ISEARRAY Then Return SetError(-1, -1, False)
		If UBound($VELEMENTS) <> UBound($VCOLORS) Then Return SetError(-1, -1, False)
		$IELEMENTNUM = UBound($VELEMENTS)
	EndIf
	Local $TELEMENTS = DllStructCreate("int Element[" & $IELEMENTNUM & "]")
	Local $TCOLORS = DllStructCreate("int NewColor[" & $IELEMENTNUM & "]")
	Local $PELEMENTS = DllStructGetPtr($TELEMENTS)
	Local $PCOLORS = DllStructGetPtr($TCOLORS)
	If Not $ISEARRAY Then
		DllStructSetData($TELEMENTS, "Element", $VELEMENTS, 1)
	Else
		For $X = 0 To $IELEMENTNUM - 1
			DllStructSetData($TELEMENTS, "Element", $VELEMENTS[$X], $X + 1)
		Next
	EndIf
	If Not $ISCARRAY Then
		DllStructSetData($TCOLORS, "NewColor", $VCOLORS, 1)
	Else
		For $X = 0 To $IELEMENTNUM - 1
			DllStructSetData($TCOLORS, "NewColor", $VCOLORS[$X], $X + 1)
		Next
	EndIf
	Local $IRESULTS = DllCall("user32.dll", "int", "SetSysColors", "int", $IELEMENTNUM, "ptr", $PELEMENTS, "ptr", $PCOLORS)
	If @error Then Return SetError(-1, -1, False)
	Return $IRESULTS[0] <> 0
EndFunc


Func _WINAPI_SETTEXTCOLOR($HDC, $ICOLOR)
	Local $ARESULT
	$ARESULT = DllCall("GDI32.dll", "int", "SetTextColor", "hwnd", $HDC, "int", $ICOLOR)
	If @error Then Return SetError(@error, 0, 65535)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_SETWINDOWLONG($HWND, $IINDEX, $IVALUE)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "SetWindowLong", "hwnd", $HWND, "int", $IINDEX, "int", $IVALUE)
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_SETWINDOWPLACEMENT($HWND, $PWINDOWPLACEMENT)
	Local $AVRET = DllCall("user32.dll", "int", "SetWindowPlacement", "hwnd", $HWND, "ptr", $PWINDOWPLACEMENT)
	If @error Then Return SetError(@error, _WINAPI_GETLASTERROR(), 0)
	If $AVRET[0] Then
		Return $AVRET[0]
	Else
		Return SetError(1, _WINAPI_GETLASTERROR(), 0)
	EndIf
EndFunc


Func _WINAPI_SETWINDOWPOS($HWND, $HAFTER, $IX, $IY, $ICX, $ICY, $IFLAGS)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "SetWindowPos", "hwnd", $HWND, "hwnd", $HAFTER, "int", $IX, "int", $IY, "int", $ICX, "int", $ICY, "int", $IFLAGS)
	_WINAPI_CHECK("_WinAPI_SetWindowPos", ($ARESULT[0] = 0), 0, True)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_SETWINDOWRGN($HWND, $HRGN, $BREDRAW = True)
	Local $ARESULT = DllCall("user32.dll", "int", "SetWindowRgn", "hwnd", $HWND, "hwnd", $HRGN, "int", $BREDRAW)
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_SETWINDOWSHOOKEX($IDHOOK, $LPFN, $HMOD, $DWTHREADID = 0)
	Local $HWNDHOOK = DllCall("user32.dll", "hwnd", "SetWindowsHookEx", "int", $IDHOOK, "ptr", $LPFN, "hwnd", $HMOD, "dword", $DWTHREADID)
	If @error Then Return SetError(@error, @extended, 0)
	Return $HWNDHOOK[0]
EndFunc


Func _WINAPI_SETWINDOWTEXT($HWND, $STEXT)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "SetWindowText", "hwnd", $HWND, "str", $STEXT)
	If @error Then Return SetError(@error, 0, False)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_SHOWCURSOR($FSHOW)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "ShowCursor", "int", $FSHOW)
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_SHOWERROR($STEXT, $FEXIT = True)
	_WINAPI_MSGBOX(266256, "Error", $STEXT)
	If $FEXIT Then Exit
EndFunc


Func _WINAPI_SHOWMSG($STEXT)
	_WINAPI_MSGBOX(64 + 4096, "Information", $STEXT)
EndFunc


Func _WINAPI_SHOWWINDOW($HWND, $ICMDSHOW = 5)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "ShowWindow", "hwnd", $HWND, "int", $ICMDSHOW)
	If @error Then Return SetError(@error, 0, False)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_STRINGFROMGUID($PGUID)
	Local $ARESULT
	$ARESULT = DllCall("Ole32.dll", "int", "StringFromGUID2", "ptr", $PGUID, "wstr", "", "int", 40)
	If @error Then Return SetError(@error, 0, 0)
	Return SetError($ARESULT[0] <> 0, 0, $ARESULT[2])
EndFunc


Func _WINAPI_SUBLANGID($LGID)
	Return BitShift($LGID, 10)
EndFunc


Func _WINAPI_SYSTEMPARAMETERSINFO($IACTION, $IPARAM = 0, $VPARAM = 0, $IWININI = 0)
	Local $ARESULT
	$ARESULT = DllCall("user32.dll", "int", "SystemParametersInfo", "int", $IACTION, "int", $IPARAM, "int", $VPARAM, "int", $IWININI)
	If @error Then Return SetError(@error, 0, False)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_TWIPSPERPIXELX()
	Local $LNGDC, $TWIPSPERPIXELX
	$LNGDC = _WINAPI_GETDC(0)
	$TWIPSPERPIXELX = 1440 / _WINAPI_GETDEVICECAPS($LNGDC, $__WINAPCONSTANT_LOGPIXELSX)
	_WINAPI_RELEASEDC(0, $LNGDC)
	Return $TWIPSPERPIXELX
EndFunc


Func _WINAPI_TWIPSPERPIXELY()
	Local $LNGDC, $TWIPSPERPIXELY
	$LNGDC = _WINAPI_GETDC(0)
	$TWIPSPERPIXELY = 1440 / _WINAPI_GETDEVICECAPS($LNGDC, $__WINAPCONSTANT_LOGPIXELSY)
	_WINAPI_RELEASEDC(0, $LNGDC)
	Return $TWIPSPERPIXELY
EndFunc


Func _WINAPI_UNHOOKWINDOWSHOOKEX($HHK)
	Local $IRESULT = DllCall("user32.dll", "int", "UnhookWindowsHookEx", "hwnd", $HHK)
	If @error Then Return SetError(@error, @extended, 0)
	Return $IRESULT[0] <> 0
EndFunc


Func _WINAPI_UPDATELAYEREDWINDOW($HWND, $HDCDEST, $PPTDEST, $PSIZE, $HDCSRCE, $PPTSRCE, $IRGB, $PBLEND, $IFLAGS)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "UpdateLayeredWindow", "hwnd", $HWND, "hwnd", $HDCDEST, "ptr", $PPTDEST, "ptr", $PSIZE, "hwnd", $HDCSRCE, "ptr", $PPTSRCE, "int", $IRGB, "ptr", $PBLEND, "int", $IFLAGS)
	If @error Then Return SetError(1, 0, False)
	Return SetError($ARESULT[0] = 0, 0, $ARESULT[0] <> 0)
EndFunc


Func _WINAPI_UPDATEWINDOW($HWND)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "int", "UpdateWindow", "hwnd", $HWND)
	If @error Then Return SetError(@error, 0, False)
	Return $ARESULT[0] <> 0
EndFunc


Func _WINAPI_WAITFORINPUTIDLE($HPROCESS, $ITIMEOUT = -1)
	Local $ARESULT
	$ARESULT = DllCall("User32.dll", "dword", "WaitForInputIdle", "hwnd", $HPROCESS, "dword", $ITIMEOUT)
	Return SetError(_WINAPI_GETLASTERROR(), 0, $ARESULT[0] = 0)
EndFunc


Func _WINAPI_WAITFORMULTIPLEOBJECTS($ICOUNT, $PHANDLES, $FWAITALL = False, $ITIMEOUT = -1)
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "int", "WaitForMultipleObjects", "int", $ICOUNT, "ptr", $PHANDLES, "int", $FWAITALL, "int", $ITIMEOUT)
	Return SetError(_WINAPI_GETLASTERROR(), 0, $ARESULT[0])
EndFunc


Func _WINAPI_WAITFORSINGLEOBJECT($HHANDLE, $ITIMEOUT = -1)
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "int", "WaitForSingleObject", "hwnd", $HHANDLE, "int", $ITIMEOUT)
	Return SetError(_WINAPI_GETLASTERROR(), 0, $ARESULT[0])
EndFunc


Func _WINAPI_WIDECHARTOMULTIBYTE($PUNICODE, $ICODEPAGE = 0)
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "int", "WideCharToMultiByte", "int", $ICODEPAGE, "int", 0, "ptr", $PUNICODE, "int", -1, "str", "", "int", 0, "int", 0, "int", 0)
	If @error Then Return SetError(@error, 0, "")
	$ARESULT = DllCall("Kernel32.dll", "int", "WideCharToMultiByte", "int", $ICODEPAGE, "int", 0, "ptr", $PUNICODE, "int", -1, "str", "", "int", $ARESULT[0], "int", 0, "int", 0)
	If @error Then Return SetError(@error, 0, "")
	Return $ARESULT[5]
EndFunc


Func _WINAPI_WINDOWFROMPOINT(ByRef $TPOINT)
	Local $IX, $IY, $ARESULT
	$IX = DllStructGetData($TPOINT, "X")
	$IY = DllStructGetData($TPOINT, "Y")
	$ARESULT = DllCall("User32.dll", "hwnd", "WindowFromPoint", "int", $IX, "int", $IY)
	If @error Then Return SetError(@error, 0, 0)
	Return $ARESULT[0]
EndFunc


Func _WINAPI_WRITECONSOLE($HCONSOLE, $STEXT)
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "int", "WriteConsole", "int", $HCONSOLE, "str", $STEXT, "int", StringLen($STEXT), "int*", 0, "int", 0)
	Return SetError(_WINAPI_GETLASTERROR(), 0, $ARESULT[0] <> 0)
EndFunc


Func _WINAPI_WRITEFILE($HFILE, $PBUFFER, $ITOWRITE, ByRef $IWRITTEN, $POVERLAPPED = 0)
	Local $PWRITTEN, $TWRITTEN, $ARESULT
	$TWRITTEN = DllStructCreate("int Written")
	$PWRITTEN = DllStructGetPtr($TWRITTEN)
	$ARESULT = DllCall("Kernel32.dll", "int", "WriteFile", "hwnd", $HFILE, "ptr", $PBUFFER, "uint", $ITOWRITE, "ptr", $PWRITTEN, "ptr", $POVERLAPPED)
	$IWRITTEN = DllStructGetData($TWRITTEN, "Written")
	Return SetError(_WINAPI_GETLASTERROR(), 0, $ARESULT[0] <> 0)
EndFunc


Func _WINAPI_WRITEPROCESSMEMORY($HPROCESS, $PBASEADDRESS, $PBUFFER, $ISIZE, ByRef $IWRITTEN, $SBUFFER = "ptr")
	Local $PWRITTEN, $TWRITTEN, $ARESULT
	$TWRITTEN = DllStructCreate("int Written")
	$PWRITTEN = DllStructGetPtr($TWRITTEN)
	$ARESULT = DllCall("Kernel32.dll", "int", "WriteProcessMemory", "int", $HPROCESS, "int", $PBASEADDRESS, $SBUFFER, $PBUFFER, "int", $ISIZE, "int", $PWRITTEN)
	_WINAPI_CHECK("_WinAPI_WriteProcessMemory", ($ARESULT[0] = 0), 0, True)
	$IWRITTEN = DllStructGetData($TWRITTEN, "Written")
	Return $ARESULT[0]
EndFunc


Func _WINAPI_VALIDATECLASSNAME($HWND, $SCLASSNAMES)
	Local $ACLASSNAMES, $SSEPERATOR = Opt("GUIDataSeparatorChar"), $STEXT
	If Not _WINAPI_ISCLASSNAME($HWND, $SCLASSNAMES) Then
		$ACLASSNAMES = StringSplit($SCLASSNAMES, $SSEPERATOR)
		For $X = 1 To $ACLASSNAMES[0]
			$STEXT &= $ACLASSNAMES[$X] & ", "
		Next
		$STEXT = StringTrimRight($STEXT, 2)
		_WINAPI_SHOWERROR("Invalid Class Type(s):" & @LF & @TAB & "Expecting Type(s): " & $STEXT & @LF & @TAB & "Received Type : " & _WINAPI_GETCLASSNAME($HWND))
	EndIf
EndFunc

Global Const $GMEM_FIXED = 0
Global Const $GMEM_MOVEABLE = 2
Global Const $GMEM_NOCOMPACT = 16
Global Const $GMEM_NODISCARD = 32
Global Const $GMEM_ZEROINIT = 64
Global Const $GMEM_MODIFY = 128
Global Const $GMEM_DISCARDABLE = 256
Global Const $GMEM_NOT_BANKED = 4096
Global Const $GMEM_SHARE = 8192
Global Const $GMEM_DDESHARE = 8192
Global Const $GMEM_NOTIFY = 16384
Global Const $GMEM_LOWER = 4096
Global Const $GMEM_VALID_FLAGS = 32626
Global Const $GMEM_INVALID_HANDLE = 32768
Global Const $GPTR = 64
Global Const $GHND = 66
Global Const $MEM_COMMIT = 4096
Global Const $MEM_RESERVE = 8192
Global Const $MEM_TOP_DOWN = 1048576
Global Const $MEM_SHARED = 134217728
Global Const $PAGE_NOACCESS = 1
Global Const $PAGE_READONLY = 2
Global Const $PAGE_READWRITE = 4
Global Const $PAGE_EXECUTE = 16
Global Const $PAGE_EXECUTE_READ = 32
Global Const $PAGE_EXECUTE_READWRITE = 64
Global Const $PAGE_GUARD = 256
Global Const $PAGE_NOCACHE = 512
Global Const $MEM_DECOMMIT = 16384
Global Const $MEM_RELEASE = 32768
Global Const $__MEMORYCONSTANT_PROCESS_VM_OPERATION = 8
Global Const $__MEMORYCONSTANT_PROCESS_VM_READ = 16
Global Const $__MEMORYCONSTANT_PROCESS_VM_WRITE = 32

Func _MEMFREE(ByRef $TMEMMAP)
	Local $HPROCESS, $PMEMORY, $BRESULT
	$PMEMORY = DllStructGetData($TMEMMAP, "Mem")
	$HPROCESS = DllStructGetData($TMEMMAP, "hProc")
	If @OSTYPE = "WIN32_WINDOWS"  Then
		$BRESULT = _MEMVIRTUALFREE($PMEMORY, 0, $MEM_RELEASE)
	Else
		$BRESULT = _MEMVIRTUALFREEEX($HPROCESS, $PMEMORY, 0, $MEM_RELEASE)
	EndIf
	_WINAPI_CLOSEHANDLE($HPROCESS)
	Return $BRESULT
EndFunc


Func _MEMGLOBALALLOC($IBYTES, $IFLAGS = 0)
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "hwnd", "GlobalAlloc", "int", $IFLAGS, "int", $IBYTES)
	Return $ARESULT[0]
EndFunc


Func _MEMGLOBALFREE($HMEM)
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "int", "GlobalFree", "hwnd", $HMEM)
	Return $ARESULT[0] = 0
EndFunc


Func _MEMGLOBALLOCK($HMEM)
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "ptr", "GlobalLock", "hwnd", $HMEM)
	Return $ARESULT[0]
EndFunc


Func _MEMGLOBALSIZE($HMEM)
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "int", "GlobalSize", "hwnd", $HMEM)
	Return $ARESULT[0]
EndFunc


Func _MEMGLOBALUNLOCK($HMEM)
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "int", "GlobalUnlock", "hwnd", $HMEM)
	Return $ARESULT[0]
EndFunc


Func _MEMINIT($HWND, $ISIZE, ByRef $TMEMMAP)
	Local $IACCESS, $IALLOC, $PMEMORY, $HPROCESS, $IPROCESSID
	_WINAPI_GETWINDOWTHREADPROCESSID($HWND, $IPROCESSID)
	If $IPROCESSID = 0 Then _MEMSHOWERROR("_MemInit: Invalid window handle [0x" & Hex($HWND) & "]")
	$IACCESS = BitOR($__MEMORYCONSTANT_PROCESS_VM_OPERATION, $__MEMORYCONSTANT_PROCESS_VM_READ, $__MEMORYCONSTANT_PROCESS_VM_WRITE)
	$HPROCESS = _WINAPI_OPENPROCESS($IACCESS, False, $IPROCESSID, True)
	If @OSTYPE = "WIN32_WINDOWS"  Then
		$IALLOC = BitOR($MEM_RESERVE, $MEM_COMMIT, $MEM_SHARED)
		$PMEMORY = _MEMVIRTUALALLOC(0, $ISIZE, $IALLOC, $PAGE_READWRITE)
	Else
		$IALLOC = BitOR($MEM_RESERVE, $MEM_COMMIT)
		$PMEMORY = _MEMVIRTUALALLOCEX($HPROCESS, 0, $ISIZE, $IALLOC, $PAGE_READWRITE)
	EndIf
	If $PMEMORY = 0 Then _MEMSHOWERROR("_MemInit: Unable to allocate memory")
	$TMEMMAP = DllStructCreate($TAGMEMMAP)
	DllStructSetData($TMEMMAP, "hProc", $HPROCESS)
	DllStructSetData($TMEMMAP, "Size", $ISIZE)
	DllStructSetData($TMEMMAP, "Mem", $PMEMORY)
	Return $PMEMORY
EndFunc


Func _MEMMSGBOX($IFLAGS, $STITLE, $STEXT)
	BlockInput(0)
	MsgBox($IFLAGS, $STITLE, $STEXT & "      ")
EndFunc


Func _MEMMOVEMEMORY($PSOURCE, $PDEST, $ILENGTH)
	DllCall("Kernel32.dll", "none", "RtlMoveMemory", "ptr", $PDEST, "ptr", $PSOURCE, "dword", $ILENGTH)
EndFunc


Func _MEMREAD(ByRef $TMEMMAP, $PSRCE, $PDEST, $ISIZE)
	Local $IREAD
	Return _WINAPI_READPROCESSMEMORY(DllStructGetData($TMEMMAP, "hProc"), $PSRCE, $PDEST, $ISIZE, $IREAD)
EndFunc


Func _MEMSHOWERROR($STEXT, $FEXIT = True)
	_MEMMSGBOX(16 + 4096, "Error", $STEXT)
	If $FEXIT Then Exit
EndFunc


Func _MEMWRITE(ByRef $TMEMMAP, $PSRCE, $PDEST = 0, $ISIZE = 0, $SSRCE = "ptr")
	Local $IWRITTEN
	If $PDEST = 0 Then $PDEST = DllStructGetData($TMEMMAP, "Mem")
	If $ISIZE = 0 Then $ISIZE = DllStructGetData($TMEMMAP, "Size")
	Return _WINAPI_WRITEPROCESSMEMORY(DllStructGetData($TMEMMAP, "hProc"), $PDEST, $PSRCE, $ISIZE, $IWRITTEN, $SSRCE)
EndFunc


Func _MEMVIRTUALALLOC($PADDRESS, $ISIZE, $IALLOCATION, $IPROTECT)
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "ptr", "VirtualAlloc", "ptr", $PADDRESS, "int", $ISIZE, "int", $IALLOCATION, "int", $IPROTECT)
	Return SetError($ARESULT[0] = 0, 0, $ARESULT[0])
EndFunc


Func _MEMVIRTUALALLOCEX($HPROCESS, $PADDRESS, $ISIZE, $IALLOCATION, $IPROTECT)
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "ptr", "VirtualAllocEx", "int", $HPROCESS, "ptr", $PADDRESS, "int", $ISIZE, "int", $IALLOCATION, "int", $IPROTECT)
	Return SetError($ARESULT[0] = 0, 0, $ARESULT[0])
EndFunc


Func _MEMVIRTUALFREE($PADDRESS, $ISIZE, $IFREETYPE)
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "ptr", "VirtualFree", "ptr", $PADDRESS, "int", $ISIZE, "int", $IFREETYPE)
	Return $ARESULT[0]
EndFunc


Func _MEMVIRTUALFREEEX($HPROCESS, $PADDRESS, $ISIZE, $IFREETYPE)
	Local $ARESULT
	$ARESULT = DllCall("Kernel32.dll", "ptr", "VirtualFreeEx", "hwnd", $HPROCESS, "ptr", $PADDRESS, "int", $ISIZE, "int", $IFREETYPE)
	Return $ARESULT[0]
EndFunc

Global Const $SBARS_SIZEGRIP = 256
Global Const $SBT_TOOLTIPS = 2048
Global Const $SBARS_TOOLTIPS = 2048
Global Const $SBT_SUNKEN = 0
Global Const $SBT_NOBORDERS = 256
Global Const $SBT_POPOUT = 512
Global Const $SBT_RTLREADING = 1024
Global Const $SBT_NOTABPARSING = 2048
Global Const $SBT_OWNERDRAW = 4096
Global Const $__STATUSBARCONSTANT_WM_USER = 1024
Global Const $SB_GETBORDERS = ($__STATUSBARCONSTANT_WM_USER + 7)
Global Const $SB_GETICON = ($__STATUSBARCONSTANT_WM_USER + 20)
Global Const $SB_GETPARTS = ($__STATUSBARCONSTANT_WM_USER + 6)
Global Const $SB_GETRECT = ($__STATUSBARCONSTANT_WM_USER + 10)
Global Const $SB_GETTEXTA = ($__STATUSBARCONSTANT_WM_USER + 2)
Global Const $SB_GETTEXTW = ($__STATUSBARCONSTANT_WM_USER + 13)
Global Const $SB_GETTEXT = $SB_GETTEXTA
Global Const $SB_GETTEXTLENGTHA = ($__STATUSBARCONSTANT_WM_USER + 3)
Global Const $SB_GETTEXTLENGTHW = ($__STATUSBARCONSTANT_WM_USER + 12)
Global Const $SB_GETTEXTLENGTH = $SB_GETTEXTLENGTHA
Global Const $SB_GETTIPTEXTA = ($__STATUSBARCONSTANT_WM_USER + 18)
Global Const $SB_GETTIPTEXTW = ($__STATUSBARCONSTANT_WM_USER + 19)
Global Const $SB_GETTIPTEXT = $SB_GETTIPTEXTA
Global Const $SB_GETUNICODEFORMAT = 8192 + 6
Global Const $SB_ISSIMPLE = ($__STATUSBARCONSTANT_WM_USER + 14)
Global Const $SB_SETBKCOLOR = 8192 + 1
Global Const $SB_SETICON = ($__STATUSBARCONSTANT_WM_USER + 15)
Global Const $SB_SETMINHEIGHT = ($__STATUSBARCONSTANT_WM_USER + 8)
Global Const $SB_SETPARTS = ($__STATUSBARCONSTANT_WM_USER + 4)
Global Const $SB_SETTEXTA = ($__STATUSBARCONSTANT_WM_USER + 1)
Global Const $SB_SETTEXTW = ($__STATUSBARCONSTANT_WM_USER + 11)
Global Const $SB_SETTEXT = $SB_SETTEXTA
Global Const $SB_SETTIPTEXTA = ($__STATUSBARCONSTANT_WM_USER + 16)
Global Const $SB_SETTIPTEXTW = ($__STATUSBARCONSTANT_WM_USER + 17)
Global Const $SB_SETTIPTEXT = $SB_SETTIPTEXTA
Global Const $SB_SETUNICODEFORMAT = 8192 + 5
Global Const $SB_SIMPLE = ($__STATUSBARCONSTANT_WM_USER + 9)
Global Const $SB_SIMPLEID = 255
Global Const $SBN_SIMPLEMODECHANGE = -880
Global Const $_UDF_GLOBALIDS_OFFSET = 2
Global Const $_UDF_GLOBALID_MAX_WIN = 16
Global Const $_UDF_STARTID = 10000
Global Const $_UDF_GLOBALID_MAX_IDS = 55535
Global $_UDF_GLOBALIDS_USED[$_UDF_GLOBALID_MAX_WIN][$_UDF_GLOBALID_MAX_IDS + $_UDF_GLOBALIDS_OFFSET + 1]

Func _UDF_GETNEXTGLOBALID($HWND)
	Local $NCTRLID, $IUSEDINDEX = -1, $FALLUSED = True
	If Not WinExists($HWND) Then Return SetError(-1, -1, 0)
	For $IINDEX = 0 To $_UDF_GLOBALID_MAX_WIN - 1
		If $_UDF_GLOBALIDS_USED[$IINDEX][0] <> 0 Then
			If Not WinExists($_UDF_GLOBALIDS_USED[$IINDEX][0]) Then
				For $X = 0 To UBound($_UDF_GLOBALIDS_USED, 2) - 1
					$_UDF_GLOBALIDS_USED[$IINDEX][$X] = 0
				Next
				$_UDF_GLOBALIDS_USED[$IINDEX][1] = $_UDF_STARTID
				$FALLUSED = False
			EndIf
		EndIf
	Next
	For $IINDEX = 0 To $_UDF_GLOBALID_MAX_WIN - 1
		If $_UDF_GLOBALIDS_USED[$IINDEX][0] = $HWND Then
			$IUSEDINDEX = $IINDEX
			ExitLoop
		EndIf
	Next
	If $IUSEDINDEX = -1 Then
		For $IINDEX = 0 To $_UDF_GLOBALID_MAX_WIN - 1
			If $_UDF_GLOBALIDS_USED[$IINDEX][0] = 0 Then
				$_UDF_GLOBALIDS_USED[$IINDEX][0] = $HWND
				$_UDF_GLOBALIDS_USED[$IINDEX][1] = $_UDF_STARTID
				$FALLUSED = False
				$IUSEDINDEX = $IINDEX
				ExitLoop
			EndIf
		Next
	EndIf
	If $IUSEDINDEX = -1 And $FALLUSED Then Return SetError(16, 0, 0)
	If $_UDF_GLOBALIDS_USED[$IUSEDINDEX][1] = $_UDF_STARTID + $_UDF_GLOBALID_MAX_IDS Then
		For $IIDINDEX = $_UDF_GLOBALIDS_OFFSET To UBound($_UDF_GLOBALIDS_USED, 2) - 1
			If $_UDF_GLOBALIDS_USED[$IUSEDINDEX][$IIDINDEX] = 0 Then
				$NCTRLID = ($IIDINDEX - $_UDF_GLOBALIDS_OFFSET) + 10000
				$_UDF_GLOBALIDS_USED[$IUSEDINDEX][$IIDINDEX] = $NCTRLID
				Return $NCTRLID
			EndIf
		Next
		Return SetError(-1, $_UDF_GLOBALID_MAX_IDS, 0)
	EndIf
	$NCTRLID = $_UDF_GLOBALIDS_USED[$IUSEDINDEX][1]
	$_UDF_GLOBALIDS_USED[$IUSEDINDEX][1] += 1
	$_UDF_GLOBALIDS_USED[$IUSEDINDEX][($NCTRLID - 10000) + $_UDF_GLOBALIDS_OFFSET] = $NCTRLID
	Return $NCTRLID
EndFunc


Func _UDF_FREEGLOBALID($HWND, $IGLOBALID)
	If $IGLOBALID - $_UDF_STARTID < 0 Or $IGLOBALID - $_UDF_STARTID > $_UDF_GLOBALID_MAX_IDS Then Return SetError(-1, 0, False)
	For $IINDEX = 0 To $_UDF_GLOBALID_MAX_WIN - 1
		If $_UDF_GLOBALIDS_USED[$IINDEX][0] = $HWND Then
			For $X = $_UDF_GLOBALIDS_OFFSET To UBound($_UDF_GLOBALIDS_USED, 2) - 1
				If $_UDF_GLOBALIDS_USED[$IINDEX][$X] = $IGLOBALID Then
					$_UDF_GLOBALIDS_USED[$IINDEX][$X] = 0
					Return True
				EndIf
			Next
			Return SetError(-3, 0, False)
		EndIf
	Next
	Return SetError(-2, 0, False)
EndFunc

Global $__GHSBLASTWND
Global $DEBUG_SB = False
Global Const $__STATUSBARCONSTANT_CLASSNAME = "msctls_statusbar32"
Global Const $__STATUSBARCONSTANT_WS_VISIBLE = 268435456
Global Const $__STATUSBARCONSTANT_WS_CHILD = 1073741824
Global Const $__STATUSBARCONSTANT_WM_SIZE = 5
Global Const $__STATUSBARCONSTANT_CLR_DEFAULT = -16777216

Func _GUICTRLSTATUSBAR_CREATE($HWND, $VPARTEDGE = -1, $VPARTTEXT = "", $ISTYLES = -1, $IEXSTYLES = 0)
	If Not IsHWnd($HWND) Then _WINAPI_SHOWERROR("Invalid Window handle for _GUICtrlStatusBar_Create 1st parameter")
	Local $APARTWIDTH[1], $APARTTEXT[1], $HWNDSBAR, $X, $ISTYLE = BitOR($__STATUSBARCONSTANT_WS_CHILD, $__STATUSBARCONSTANT_WS_VISIBLE)
	Local $IEXSTYLE, $ILAST, $NCTRLID
	If $ISTYLES = -1 Then $ISTYLES = 0
	If $IEXSTYLE = -1 Then $IEXSTYLE = 0
	If @NumParams > 1 Then
		If IsArray($VPARTEDGE) Then
			$APARTWIDTH = $VPARTEDGE
		Else
			$APARTWIDTH[0] = $VPARTEDGE
		EndIf
		If @NumParams = 2 Then
			ReDim $APARTTEXT[UBound($APARTWIDTH) ]
		Else
			If IsArray($VPARTTEXT) Then
				$APARTTEXT = $VPARTTEXT
			Else
				$APARTTEXT[0] = $VPARTTEXT
			EndIf
			If UBound($APARTWIDTH) <> UBound($APARTTEXT) Then
				If UBound($APARTWIDTH) > UBound($APARTTEXT) Then
					$ILAST = UBound($APARTTEXT)
					ReDim $APARTTEXT[UBound($APARTWIDTH) ]
					For $X = $ILAST To UBound($APARTTEXT) - 1
						$APARTWIDTH[$X] = ""
					Next
				Else
					$ILAST = UBound($APARTWIDTH)
					ReDim $APARTWIDTH[UBound($APARTTEXT) ]
					For $X = $ILAST To UBound($APARTWIDTH) - 1
						$APARTWIDTH[$X] = $APARTWIDTH[$X - 1] + 75
					Next
					$APARTWIDTH[UBound($APARTTEXT) - 1] = -1
				EndIf
			EndIf
		EndIf
		If Not IsHWnd($HWND) Then $HWND = HWnd($HWND)
		If @NumParams > 3 Then $ISTYLE = BitOR($ISTYLE, $ISTYLES)
		$IEXSTYLE = $IEXSTYLES
	EndIf
	$NCTRLID = _UDF_GETNEXTGLOBALID($HWND)
	If @error Then Return SetError(@error, @extended, 0)
	If @OSTYPE = "WIN32_WINDOWS"  Then
		$HWNDSBAR = DllCall("comctl32.dll", "hwnd", "CreateStatusWindow", "long", $ISTYLE, "str", "", "hwnd", $HWND, "int", $NCTRLID)
		$HWNDSBAR = HWnd($HWNDSBAR[0])
	Else
		$HWNDSBAR = _WINAPI_CREATEWINDOWEX($IEXSTYLE, $__STATUSBARCONSTANT_CLASSNAME, "", $ISTYLE, 0, 0, 0, 0, $HWND, $NCTRLID)
	EndIf
	If @error Then Return SetError(1, 1, 0)
	If @NumParams > 1 Then
		_GUICTRLSTATUSBAR_SETPARTS($HWNDSBAR, UBound($APARTWIDTH), $APARTWIDTH)
		For $X = 0 To UBound($APARTTEXT) - 1
			_GUICTRLSTATUSBAR_SETTEXT($HWNDSBAR, $APARTTEXT[$X], $X)
		Next
	EndIf
	Return $HWNDSBAR
EndFunc


Func _GUICTRLSTATUSBAR_DEBUGPRINT($STEXT, $ILINE = @ScriptLineNumber)
	ConsoleWrite("!===========================================================" & @LF & "+======================================================" & @LF & "-->Line(" & StringFormat("%04d", $ILINE) & "):" & @TAB & $STEXT & @LF & "+======================================================" & @LF)
EndFunc


Func _GUICTRLSTATUSBAR_DESTROY(ByRef $HWND)
	If $DEBUG_SB Then _GUICTRLSTATUSBAR_VALIDATECLASSNAME($HWND)
	Local $DESTROYED, $IRESULT
	If _WINAPI_ISCLASSNAME($HWND, $__STATUSBARCONSTANT_CLASSNAME) Then
		If IsHWnd($HWND) Then
			If _WINAPI_INPROCESS($HWND, $__GHSBLASTWND) Then
				Local $NCTRLID = _WINAPI_GETDLGCTRLID($HWND)
				Local $HPARENT = _WINAPI_GETPARENT($HWND)
				$DESTROYED = _WINAPI_DESTROYWINDOW($HWND)
				$IRESULT = _UDF_FREEGLOBALID($HPARENT, $NCTRLID)
				If Not $IRESULT Then
				EndIf
			Else
				_WINAPI_SHOWMSG("Not Allowed to Destroy Other Applications Control(s)")
				Return SetError(1, 1, False)
			EndIf
		EndIf
		If $DESTROYED Then $HWND = 0
		Return $DESTROYED <> 0
	EndIf
	Return SetError(2, 2, False)
EndFunc


Func _GUICTRLSTATUSBAR_EMBEDCONTROL($HWND, $IPART, $HCONTROL, $IFIT = 4)
	Local $ARECT, $IBARX, $IBARY, $IBARW, $IBARH, $ICONX, $ICONY, $ICONW, $ICONH, $IPADX, $IPADY
	$ARECT = _GUICTRLSTATUSBAR_GETRECT($HWND, $IPART)
	$IBARX = $ARECT[0]
	$IBARY = $ARECT[1]
	$IBARW = $ARECT[2] - $IBARX
	$IBARH = $ARECT[3] - $IBARY
	$ICONX = $IBARX
	$ICONY = $IBARY
	$ICONW = _WINAPI_GETWINDOWWIDTH($HCONTROL)
	$ICONH = _WINAPI_GETWINDOWHEIGHT($HCONTROL)
	If $ICONW > $IBARW Then $ICONW = $IBARW
	If $ICONH > $IBARH Then $ICONH = $IBARH
	$IPADX = ($IBARW - $ICONW) / 2
	$IPADY = ($IBARH - $ICONH) / 2
	If $IPADX < 0 Then $IPADX = 0
	If $IPADY < 0 Then $IPADY = 0
	If BitAND($IFIT, 1) = 1 Then $ICONX = $IBARX + $IPADX
	If BitAND($IFIT, 2) = 2 Then $ICONY = $IBARY + $IPADY
	If BitAND($IFIT, 4) = 4 Then
		$IPADX = _GUICTRLSTATUSBAR_GETBORDERSRECT($HWND)
		$IPADY = _GUICTRLSTATUSBAR_GETBORDERSVERT($HWND)
		$ICONX = $IBARX
		If _GUICTRLSTATUSBAR_ISSIMPLE($HWND) Then $ICONX += $IPADX
		$ICONY = $IBARY + $IPADY
		$ICONW = $IBARW - ($IPADX * 2)
		$ICONH = $IBARH - ($IPADY * 2)
	EndIf
	_WINAPI_SETPARENT($HCONTROL, $HWND)
	_WINAPI_MOVEWINDOW($HCONTROL, $ICONX, $ICONY, $ICONW, $ICONH)
EndFunc


Func _GUICTRLSTATUSBAR_GETBORDERS($HWND)
	If $DEBUG_SB Then _GUICTRLSTATUSBAR_VALIDATECLASSNAME($HWND)
	Local $RET, $BORDERS_STRUCT, $BORDERS_STRUCT_POINTER, $STRUCT_MEMMAP, $MEMORY_POINTER, $ISIZE, $ABORDERS[3]
	$BORDERS_STRUCT = DllStructCreate($TAGBORDERS)
	$BORDERS_STRUCT_POINTER = DllStructGetPtr($BORDERS_STRUCT)
	If _WINAPI_INPROCESS($HWND, $__GHSBLASTWND) Then
		$RET = _SENDMESSAGE($HWND, $SB_GETBORDERS, 0, $BORDERS_STRUCT_POINTER, 0, "wparam", "ptr")
	Else
		$ISIZE = DllStructGetSize($BORDERS_STRUCT)
		$MEMORY_POINTER = _MEMINIT($HWND, $ISIZE, $STRUCT_MEMMAP)
		$RET = _SENDMESSAGE($HWND, $SB_GETBORDERS, 0, $MEMORY_POINTER, 0, "wparam", "ptr")
		_MEMREAD($STRUCT_MEMMAP, $MEMORY_POINTER, $BORDERS_STRUCT_POINTER, $ISIZE)
		_MEMFREE($STRUCT_MEMMAP)
	EndIf
	If (Not $RET) Then
		Return SetError(-1, -1, $ABORDERS)
	Else
		$ABORDERS[0] = DllStructGetData($BORDERS_STRUCT, "BX")
		$ABORDERS[1] = DllStructGetData($BORDERS_STRUCT, "BY")
		$ABORDERS[2] = DllStructGetData($BORDERS_STRUCT, "RX")
		Return $ABORDERS
	EndIf
EndFunc


Func _GUICTRLSTATUSBAR_GETBORDERSHORZ($HWND)
	Local $ABORDERS
	$ABORDERS = _GUICTRLSTATUSBAR_GETBORDERS($HWND)
	Return $ABORDERS[0]
EndFunc


Func _GUICTRLSTATUSBAR_GETBORDERSRECT($HWND)
	Local $ABORDERS
	$ABORDERS = _GUICTRLSTATUSBAR_GETBORDERS($HWND)
	Return $ABORDERS[2]
EndFunc


Func _GUICTRLSTATUSBAR_GETBORDERSVERT($HWND)
	Local $ABORDERS
	$ABORDERS = _GUICTRLSTATUSBAR_GETBORDERS($HWND)
	Return $ABORDERS[1]
EndFunc


Func _GUICTRLSTATUSBAR_GETCOUNT($HWND)
	If $DEBUG_SB Then _GUICTRLSTATUSBAR_VALIDATECLASSNAME($HWND)
	Return _SENDMESSAGE($HWND, $SB_GETPARTS)
EndFunc


Func _GUICTRLSTATUSBAR_GETHEIGHT($HWND)
	Local $TRECT
	$TRECT = _GUICTRLSTATUSBAR_GETRECTEX($HWND, 0)
	Return DllStructGetData($TRECT, "Bottom") - DllStructGetData($TRECT, "Top") - (_GUICTRLSTATUSBAR_GETBORDERSVERT($HWND) * 2)
EndFunc


Func _GUICTRLSTATUSBAR_GETICON($HWND, $IINDEX = 0)
	If $DEBUG_SB Then _GUICTRLSTATUSBAR_VALIDATECLASSNAME($HWND)
	Return _SENDMESSAGE($HWND, $SB_GETICON, $IINDEX, 0, 0, "wparam", "lparam", "hwnd")
EndFunc


Func _GUICTRLSTATUSBAR_GETPARTS($HWND)
	If $DEBUG_SB Then _GUICTRLSTATUSBAR_VALIDATECLASSNAME($HWND)
	Local $II, $ICOUNT, $IPARTS, $PPARTS, $TPARTS, $PMEMORY, $TMEMMAP
	$ICOUNT = _GUICTRLSTATUSBAR_GETCOUNT($HWND)
	$TPARTS = DllStructCreate("int[" & $ICOUNT & "]")
	$PPARTS = DllStructGetPtr($TPARTS)
	Local $APARTS[$ICOUNT + 1]
	If _WINAPI_INPROCESS($HWND, $__GHSBLASTWND) Then
		$APARTS[0] = _SENDMESSAGE($HWND, $SB_GETPARTS, $ICOUNT, $PPARTS, 0, "wparam", "ptr")
	Else
		$IPARTS = DllStructGetSize($TPARTS)
		$PMEMORY = _MEMINIT($HWND, $IPARTS, $TMEMMAP)
		$APARTS[0] = _SENDMESSAGE($HWND, $SB_GETPARTS, $ICOUNT, $PMEMORY, 0, "wparam", "ptr")
		_MEMREAD($TMEMMAP, $PMEMORY, $PPARTS, $IPARTS)
		_MEMFREE($TMEMMAP)
	EndIf
	For $II = 1 To $ICOUNT
		$APARTS[$II] = DllStructGetData($TPARTS, 1, $II)
	Next
	Return $APARTS
EndFunc


Func _GUICTRLSTATUSBAR_GETRECT($HWND, $IPART)
	Local $TRECT, $ARECT[4]
	$TRECT = _GUICTRLSTATUSBAR_GETRECTEX($HWND, $IPART)
	$ARECT[0] = DllStructGetData($TRECT, "Left")
	$ARECT[1] = DllStructGetData($TRECT, "Top")
	$ARECT[2] = DllStructGetData($TRECT, "Right")
	$ARECT[3] = DllStructGetData($TRECT, "Bottom")
	Return SetError(@error, 0, $ARECT)
EndFunc


Func _GUICTRLSTATUSBAR_GETRECTEX($HWND, $IPART)
	If $DEBUG_SB Then _GUICTRLSTATUSBAR_VALIDATECLASSNAME($HWND)
	Local $IRECT, $PRECT, $TRECT, $PMEMORY, $TMEMMAP, $IRESULT
	$TRECT = DllStructCreate($TAGRECT)
	$PRECT = DllStructGetPtr($TRECT)
	If _WINAPI_INPROCESS($HWND, $__GHSBLASTWND) Then
		$IRESULT = _SENDMESSAGE($HWND, $SB_GETRECT, $IPART, $PRECT, 0, "wparam", "ptr")
	Else
		$IRECT = DllStructGetSize($TRECT)
		$PMEMORY = _MEMINIT($HWND, $IRECT, $TMEMMAP)
		$IRESULT = _SENDMESSAGE($HWND, $SB_GETRECT, $IPART, $PMEMORY, 0, "wparam", "ptr")
		_MEMREAD($TMEMMAP, $PMEMORY, $PRECT, $IRECT)
		_MEMFREE($TMEMMAP)
	EndIf
	Return SetError($IRESULT, 0, $TRECT)
EndFunc


Func _GUICTRLSTATUSBAR_GETTEXT($HWND, $IPART)
	If $DEBUG_SB Then _GUICTRLSTATUSBAR_VALIDATECLASSNAME($HWND)
	Local $IBUFFER, $PBUFFER, $TBUFFER, $PMEMORY, $TMEMMAP
	Local $FUNICODE = _GUICTRLSTATUSBAR_GETUNICODEFORMAT($HWND)
	$IBUFFER = _GUICTRLSTATUSBAR_GETTEXTLENGTH($HWND, $IPART)
	If $IBUFFER = 0 Then Return ""
	If $FUNICODE Then
		$IBUFFER *= 2
		$TBUFFER = DllStructCreate("wchar Text[" & $IBUFFER & "]")
	Else
		$TBUFFER = DllStructCreate("char Text[" & $IBUFFER & "]")
	EndIf
	$PBUFFER = DllStructGetPtr($TBUFFER)
	If _WINAPI_INPROCESS($HWND, $__GHSBLASTWND) Then
		If $FUNICODE Then
			_SENDMESSAGE($HWND, $SB_GETTEXTW, $IPART, $PBUFFER, 0, "wparam", "ptr")
		Else
			_SENDMESSAGE($HWND, $SB_GETTEXT, $IPART, $PBUFFER, 0, "wparam", "ptr")
		EndIf
	Else
		$PMEMORY = _MEMINIT($HWND, $IBUFFER, $TMEMMAP)
		If $FUNICODE Then
			_SENDMESSAGE($HWND, $SB_GETTEXTW, $IPART, $PMEMORY, 0, "wparam", "ptr")
		Else
			_SENDMESSAGE($HWND, $SB_GETTEXT, $IPART, $PMEMORY, 0, "wparam", "ptr")
		EndIf
		_MEMREAD($TMEMMAP, $PMEMORY, $PBUFFER, $IBUFFER)
		_MEMFREE($TMEMMAP)
	EndIf
	Return DllStructGetData($TBUFFER, "Text")
EndFunc


Func _GUICTRLSTATUSBAR_GETTEXTFLAGS($HWND, $IPART)
	If $DEBUG_SB Then _GUICTRLSTATUSBAR_VALIDATECLASSNAME($HWND)
	If _GUICTRLSTATUSBAR_GETUNICODEFORMAT($HWND) Then
		Return _SENDMESSAGE($HWND, $SB_GETTEXTLENGTHW, $IPART)
	Else
		Return _SENDMESSAGE($HWND, $SB_GETTEXTLENGTH, $IPART)
	EndIf
EndFunc


Func _GUICTRLSTATUSBAR_GETTEXTLENGTH($HWND, $IPART)
	Return _WINAPI_LOWORD(_GUICTRLSTATUSBAR_GETTEXTFLAGS($HWND, $IPART))
EndFunc


Func _GUICTRLSTATUSBAR_GETTEXTLENGTHEX($HWND, $IPART)
	Return _WINAPI_HIWORD(_GUICTRLSTATUSBAR_GETTEXTFLAGS($HWND, $IPART))
EndFunc


Func _GUICTRLSTATUSBAR_GETTIPTEXT($HWND, $IPART)
	If $DEBUG_SB Then _GUICTRLSTATUSBAR_VALIDATECLASSNAME($HWND)
	Local $PBUFFER, $TBUFFER, $PMEMORY, $TMEMMAP
	Local $FUNICODE = _GUICTRLSTATUSBAR_GETUNICODEFORMAT($HWND)
	If $FUNICODE Then
		$TBUFFER = DllStructCreate("wchar Text[4096]")
	Else
		$TBUFFER = DllStructCreate("char Text[4096]")
	EndIf
	$PBUFFER = DllStructGetPtr($TBUFFER)
	If _WINAPI_INPROCESS($HWND, $__GHSBLASTWND) Then
		If $FUNICODE Then
			_SENDMESSAGE($HWND, $SB_GETTIPTEXTW, _WINAPI_MAKELONG($IPART, 4096), $PBUFFER, 0, "wparam", "ptr")
		Else
			_SENDMESSAGE($HWND, $SB_GETTIPTEXT, _WINAPI_MAKELONG($IPART, 4096), $PBUFFER, 0, "wparam", "ptr")
		EndIf
	Else
		$PMEMORY = _MEMINIT($HWND, 4096, $TMEMMAP)
		If $FUNICODE Then
			_SENDMESSAGE($HWND, $SB_GETTIPTEXTW, _WINAPI_MAKELONG($IPART, 4096), $PMEMORY, 0, "wparam", "ptr")
		Else
			_SENDMESSAGE($HWND, $SB_GETTIPTEXT, _WINAPI_MAKELONG($IPART, 4096), $PMEMORY, 0, "wparam", "ptr")
		EndIf
		_MEMREAD($TMEMMAP, $PMEMORY, $PBUFFER, 4096)
		_MEMFREE($TMEMMAP)
	EndIf
	Return DllStructGetData($TBUFFER, "Text")
EndFunc


Func _GUICTRLSTATUSBAR_GETUNICODEFORMAT($HWND)
	If $DEBUG_SB Then _GUICTRLSTATUSBAR_VALIDATECLASSNAME($HWND)
	Return _SENDMESSAGE($HWND, $SB_GETUNICODEFORMAT) <> 0
EndFunc


Func _GUICTRLSTATUSBAR_GETWIDTH($HWND, $IPART)
	Local $TRECT
	$TRECT = _GUICTRLSTATUSBAR_GETRECTEX($HWND, $IPART)
	Return DllStructGetData($TRECT, "Right") - DllStructGetData($TRECT, "Left") - (_GUICTRLSTATUSBAR_GETBORDERSHORZ($HWND) * 2)
EndFunc


Func _GUICTRLSTATUSBAR_ISSIMPLE($HWND)
	If $DEBUG_SB Then _GUICTRLSTATUSBAR_VALIDATECLASSNAME($HWND)
	Return _SENDMESSAGE($HWND, $SB_ISSIMPLE) <> 0
EndFunc


Func _GUICTRLSTATUSBAR_RESIZE($HWND)
	If $DEBUG_SB Then _GUICTRLSTATUSBAR_VALIDATECLASSNAME($HWND)
	_SENDMESSAGE($HWND, $__STATUSBARCONSTANT_WM_SIZE)
EndFunc


Func _GUICTRLSTATUSBAR_SETBKCOLOR($HWND, $ICOLOR)
	If $DEBUG_SB Then _GUICTRLSTATUSBAR_VALIDATECLASSNAME($HWND)
	$ICOLOR = _SENDMESSAGE($HWND, $SB_SETBKCOLOR, 0, $ICOLOR)
	If $ICOLOR = $__STATUSBARCONSTANT_CLR_DEFAULT Then Return "0x" & Hex($__STATUSBARCONSTANT_CLR_DEFAULT)
	Return $ICOLOR
EndFunc


Func _GUICTRLSTATUSBAR_SETICON($HWND, $IPART, $HICON = -1, $SICONFILE = "")
	If $DEBUG_SB Then _GUICTRLSTATUSBAR_VALIDATECLASSNAME($HWND)
	Local $TICON, $RESULT
	If $HICON = -1 Then
		Return _SENDMESSAGE($HWND, $SB_SETICON, $IPART, $HICON, 0, "wparam", "hwnd") <> 0
	ElseIf StringLen($SICONFILE) > 0 Then
		$TICON = DllStructCreate("int")
		$RESULT = DllCall("shell32.dll", "int", "ExtractIconEx", "str", $SICONFILE, "int", $HICON, "hwnd", 0, "ptr", DllStructGetPtr($TICON), "int", 1)
		$RESULT = $RESULT[0]
		If $RESULT > 0 Then $RESULT = _SENDMESSAGE($HWND, $SB_SETICON, $IPART, DllStructGetData($TICON, 1), 0, "wparam", "ptr")
		DllCall("user32.dll", "int", "DestroyIcon", "hwnd", DllStructGetData($TICON, 1))
		Return $RESULT <> 0
	Else
		Return _SENDMESSAGE($HWND, $SB_SETICON, $IPART, $HICON) <> 0
	EndIf
EndFunc


Func _GUICTRLSTATUSBAR_SETMINHEIGHT($HWND, $IMINHEIGHT)
	If $DEBUG_SB Then _GUICTRLSTATUSBAR_VALIDATECLASSNAME($HWND)
	_SENDMESSAGE($HWND, $SB_SETMINHEIGHT, $IMINHEIGHT)
	_GUICTRLSTATUSBAR_RESIZE($HWND)
EndFunc


Func _GUICTRLSTATUSBAR_SETPARTS($HWND, $IAPARTS = -1, $IAPARTWIDTH = 25)
	If $DEBUG_SB Then _GUICTRLSTATUSBAR_VALIDATECLASSNAME($HWND)
	Local $STRUCT_PARTS, $IPARTS = 1
	Local $STRUCT_PARTS_POINTER, $STRUCT_MEMMAP, $ISIZE, $MEMORY_POINTER
	If IsArray($IAPARTS) <> 0 Then
		$IAPARTS[UBound($IAPARTS) - 1] = -1
		$IPARTS = UBound($IAPARTS)
		$STRUCT_PARTS = DllStructCreate("int[" & $IPARTS & "]")
		For $X = 0 To $IPARTS - 2
			DllStructSetData($STRUCT_PARTS, 1, $IAPARTS[$X], $X + 1)
		Next
		DllStructSetData($STRUCT_PARTS, 1, -1, $IPARTS)
	ElseIf IsArray($IAPARTWIDTH) <> 0 Then
		$IPARTS = UBound($IAPARTWIDTH)
		$STRUCT_PARTS = DllStructCreate("int[" & $IPARTS & "]")
		For $X = 0 To $IPARTS - 2
			DllStructSetData($STRUCT_PARTS, 1, $IAPARTWIDTH[$X], $X + 1)
		Next
		DllStructSetData($STRUCT_PARTS, 1, -1, $IPARTS)
	ElseIf $IAPARTS > 1 Then
		$IPARTS = $IAPARTS
		$STRUCT_PARTS = DllStructCreate("int[" & $IPARTS & "]")
		For $X = 1 To $IPARTS - 1
			DllStructSetData($STRUCT_PARTS, 1, $IAPARTWIDTH * $X, $X)
		Next
		DllStructSetData($STRUCT_PARTS, 1, -1, $IPARTS)
	Else
		$STRUCT_PARTS = DllStructCreate("int")
		DllStructSetData($STRUCT_PARTS, $IPARTS, -1)
	EndIf
	$STRUCT_PARTS_POINTER = DllStructGetPtr($STRUCT_PARTS)
	If _WINAPI_INPROCESS($HWND, $__GHSBLASTWND) Then
		_SENDMESSAGE($HWND, $SB_SETPARTS, $IPARTS, $STRUCT_PARTS_POINTER, 0, "wparam", "ptr")
	Else
		$ISIZE = DllStructGetSize($STRUCT_PARTS)
		$MEMORY_POINTER = _MEMINIT($HWND, $ISIZE, $STRUCT_MEMMAP)
		_MEMWRITE($STRUCT_MEMMAP, $STRUCT_PARTS_POINTER)
		_SENDMESSAGE($HWND, $SB_SETPARTS, $IPARTS, $MEMORY_POINTER, 0, "wparam", "ptr")
		_MEMFREE($STRUCT_MEMMAP)
	EndIf
	_GUICTRLSTATUSBAR_RESIZE($HWND)
	Return 1
EndFunc


Func _GUICTRLSTATUSBAR_SETSIMPLE($HWND, $FSIMPLE = True)
	If $DEBUG_SB Then _GUICTRLSTATUSBAR_VALIDATECLASSNAME($HWND)
	_SENDMESSAGE($HWND, $SB_SIMPLE, $FSIMPLE)
EndFunc


Func _GUICTRLSTATUSBAR_SETTEXT($HWND, $STEXT = "", $IPART = 0, $IUFLAG = 0)
	If $DEBUG_SB Then _GUICTRLSTATUSBAR_VALIDATECLASSNAME($HWND)
	Local $RET, $STRUCT_STRING, $SBUFFER_POINTER, $STRUCT_MEMMAP, $MEMORY_POINTER, $IBUFFER
	Local $FUNICODE = _GUICTRLSTATUSBAR_GETUNICODEFORMAT($HWND)
	$IBUFFER = StringLen($STEXT) + 1
	If $FUNICODE Then
		$IBUFFER *= 2
		$STRUCT_STRING = DllStructCreate("wchar Text[" & $IBUFFER & "]")
	Else
		$STRUCT_STRING = DllStructCreate("char Text[" & $IBUFFER & "]")
	EndIf
	$SBUFFER_POINTER = DllStructGetPtr($STRUCT_STRING)
	DllStructSetData($STRUCT_STRING, "Text", $STEXT)
	If _GUICTRLSTATUSBAR_ISSIMPLE($HWND) Then $IPART = $SB_SIMPLEID
	If _WINAPI_INPROCESS($HWND, $__GHSBLASTWND) Then
		If $FUNICODE Then
			$RET = _SENDMESSAGE($HWND, $SB_SETTEXTW, BitOR($IPART, $IUFLAG), $SBUFFER_POINTER, 0, "wparam", "ptr")
		Else
			$RET = _SENDMESSAGE($HWND, $SB_SETTEXT, BitOR($IPART, $IUFLAG), $SBUFFER_POINTER, 0, "wparam", "ptr")
		EndIf
	Else
		$MEMORY_POINTER = _MEMINIT($HWND, $IBUFFER, $STRUCT_MEMMAP)
		_MEMWRITE($STRUCT_MEMMAP, $SBUFFER_POINTER)
		If $FUNICODE Then
			$RET = _SENDMESSAGE($HWND, $SB_SETTEXTW, BitOR($IPART, $IUFLAG), $MEMORY_POINTER, 0, "wparam", "ptr")
		Else
			$RET = _SENDMESSAGE($HWND, $SB_SETTEXT, BitOR($IPART, $IUFLAG), $MEMORY_POINTER, 0, "wparam", "ptr")
		EndIf
		_MEMFREE($STRUCT_MEMMAP)
	EndIf
	Return $RET <> 0
EndFunc


Func _GUICTRLSTATUSBAR_SETTIPTEXT($HWND, $IPART, $STEXT)
	If $DEBUG_SB Then _GUICTRLSTATUSBAR_VALIDATECLASSNAME($HWND)
	Local $STRUCT_STRING, $SBUFFER_POINTER, $STRUCT_MEMMAP, $MEMORY_POINTER, $IBUFFER
	Local $FUNICODE = _GUICTRLSTATUSBAR_GETUNICODEFORMAT($HWND)
	$IBUFFER = StringLen($STEXT) + 1
	If $FUNICODE Then
		$IBUFFER *= 2
		$STRUCT_STRING = DllStructCreate("wchar TipText[" & $IBUFFER & "]")
	Else
		$STRUCT_STRING = DllStructCreate("char TipText[" & $IBUFFER & "]")
	EndIf
	$SBUFFER_POINTER = DllStructGetPtr($STRUCT_STRING)
	DllStructSetData($STRUCT_STRING, "TipText", $STEXT)
	If _WINAPI_INPROCESS($HWND, $__GHSBLASTWND) Then
		If $FUNICODE Then
			_SENDMESSAGE($HWND, $SB_SETTIPTEXTW, $IPART, $SBUFFER_POINTER, 0, "wparam", "ptr")
		Else
			_SENDMESSAGE($HWND, $SB_SETTIPTEXT, $IPART, $SBUFFER_POINTER, 0, "wparam", "ptr")
		EndIf
	Else
		$MEMORY_POINTER = _MEMINIT($HWND, $IBUFFER, $STRUCT_MEMMAP)
		_MEMWRITE($STRUCT_MEMMAP, $SBUFFER_POINTER, $MEMORY_POINTER, $IBUFFER)
		If $FUNICODE Then
			_SENDMESSAGE($HWND, $SB_SETTIPTEXTW, $IPART, $MEMORY_POINTER, 0, "wparam", "ptr")
		Else
			_SENDMESSAGE($HWND, $SB_SETTIPTEXT, $IPART, $MEMORY_POINTER, 0, "wparam", "ptr")
		EndIf
		_MEMFREE($STRUCT_MEMMAP)
	EndIf
EndFunc


Func _GUICTRLSTATUSBAR_SETUNICODEFORMAT($HWND, $FUNICODE = True)
	If $DEBUG_SB Then _GUICTRLSTATUSBAR_VALIDATECLASSNAME($HWND)
	Return _SENDMESSAGE($HWND, $SB_SETUNICODEFORMAT, $FUNICODE)
EndFunc


Func _GUICTRLSTATUSBAR_SHOWHIDE($HWND, $ISTATE)
	If $DEBUG_SB Then _GUICTRLSTATUSBAR_VALIDATECLASSNAME($HWND)
	If $ISTATE <> @SW_HIDE And $ISTATE <> @SW_SHOW Then Return SetError(1, 1, 0)
	Local $V_RET = DllCall("user32.dll", "int", "ShowWindow", "hwnd", HWnd($HWND), "int", $ISTATE)
	If Not @error And IsArray($V_RET) Then Return $V_RET[0]
	Return SetError(2, 2, 0)
EndFunc


Func _GUICTRLSTATUSBAR_VALIDATECLASSNAME($HWND)
	_GUICTRLSTATUSBAR_DEBUGPRINT("This is for debugging only, set the debug variable to false before submitting")
	_WINAPI_VALIDATECLASSNAME($HWND, $__STATUSBARCONSTANT_CLASSNAME)
EndFunc

Global Const $PBS_MARQUEE = 8
Global Const $PBS_SMOOTH = 1
Global Const $PBS_SMOOTHREVERSE = 16
Global Const $PBS_VERTICAL = 4
Global Const $__PROGRESSBARCONSTANT_WM_USER = 1024
Global Const $PBM_DELTAPOS = $__PROGRESSBARCONSTANT_WM_USER + 3
Global Const $PBM_GETBARCOLOR = 1039
Global Const $PBM_GETBKCOLOR = 1038
Global Const $PBM_GETPOS = $__PROGRESSBARCONSTANT_WM_USER + 8
Global Const $PBM_GETRANGE = $__PROGRESSBARCONSTANT_WM_USER + 7
Global Const $PBM_GETSTATE = 1041
Global Const $PBM_GETSTEP = 1037
Global Const $PBM_SETBARCOLOR = $__PROGRESSBARCONSTANT_WM_USER + 9
Global Const $PBM_SETBKCOLOR = 8192 + 1
Global Const $PBM_SETMARQUEE = $__PROGRESSBARCONSTANT_WM_USER + 10
Global Const $PBM_SETPOS = $__PROGRESSBARCONSTANT_WM_USER + 2
Global Const $PBM_SETRANGE = $__PROGRESSBARCONSTANT_WM_USER + 1
Global Const $PBM_SETRANGE32 = $__PROGRESSBARCONSTANT_WM_USER + 6
Global Const $PBM_SETSTATE = 1040
Global Const $PBM_SETSTEP = $__PROGRESSBARCONSTANT_WM_USER + 4
Global Const $PBM_STEPIT = $__PROGRESSBARCONSTANT_WM_USER + 5
Global Const $GUI_SS_DEFAULT_PROGRESS = 0
#region _Memory

Func _MEMORYOPEN($IV_PID, $IV_DESIREDACCESS = 2035711, $IV_INHERITHANDLE = 1)
	If Not ProcessExists($IV_PID) Then
		SetError(1)
		Return 0
	EndIf
	Local $AH_HANDLE[2] = [DllOpen("kernel32.dll") ]
	If @error Then
		SetError(2)
		Return 0
	EndIf
	Local $AV_OPENPROCESS = DllCall($AH_HANDLE[0], "int", "OpenProcess", "int", $IV_DESIREDACCESS, "int", $IV_INHERITHANDLE, "int", $IV_PID)
	If @error Then
		DllClose($AH_HANDLE[0])
		SetError(3)
		Return 0
	EndIf
	$AH_HANDLE[1] = $AV_OPENPROCESS[0]
	Return $AH_HANDLE
EndFunc


Func _MEMORYREAD($IV_ADDRESS, $AH_HANDLE, $SV_TYPE = "dword")
	If Not IsArray($AH_HANDLE) Then
		SetError(1)
		Return 0
	EndIf
	Local $V_BUFFER = DllStructCreate($SV_TYPE)
	If @error Then
		SetError(@error + 1)
		Return 0
	EndIf
	DllCall($AH_HANDLE[0], "int", "ReadProcessMemory", "int", $AH_HANDLE[1], "int", $IV_ADDRESS, "ptr", DllStructGetPtr($V_BUFFER), "int", DllStructGetSize($V_BUFFER), "int", "")
	If Not @error Then
		Local $V_VALUE = DllStructGetData($V_BUFFER, 1)
		Return $V_VALUE
	Else
		SetError(6)
		Return 0
	EndIf
EndFunc


Func _MEMORYWRITE($IV_ADDRESS, $AH_HANDLE, $V_DATA, $SV_TYPE = "dword")
	If Not IsArray($AH_HANDLE) Then
		SetError(1)
		Return 0
	EndIf
	Local $V_BUFFER = DllStructCreate($SV_TYPE)
	If @error Then
		SetError(@error + 1)
		Return 0
	Else
		DllStructSetData($V_BUFFER, 1, $V_DATA)
		If @error Then
			SetError(6)
			Return 0
		EndIf
	EndIf
	DllCall($AH_HANDLE[0], "int", "WriteProcessMemory", "int", $AH_HANDLE[1], "int", $IV_ADDRESS, "ptr", DllStructGetPtr($V_BUFFER), "int", DllStructGetSize($V_BUFFER), "int", "")
	If Not @error Then
		Return 1
	Else
		SetError(7)
		Return 0
	EndIf
EndFunc


Func _MEMORYCLOSE($AH_HANDLE)
	If Not IsArray($AH_HANDLE) Then
		SetError(1)
		Return 0
	EndIf
	DllCall($AH_HANDLE[0], "int", "CloseHandle", "int", $AH_HANDLE[1])
	If Not @error Then
		DllClose($AH_HANDLE[0])
		Return 1
	Else
		DllClose($AH_HANDLE[0])
		SetError(2)
		Return 0
	EndIf
EndFunc


Func SETPRIVILEGE($PRIVILEGE, $BENABLE)
	Const $TOKEN_ADJUST_PRIVILEGES = 32
	Const $TOKEN_QUERY = 8
	Const $SE_PRIVILEGE_ENABLED = 2
	Local $HTOKEN, $SP_AUXRET, $SP_RET, $HCURRPROCESS, $NTOKENS, $NTOKENINDEX, $PRIV
	$NTOKENS = 1
	$LUID = DllStructCreate("dword;int")
	If IsArray($PRIVILEGE) Then $NTOKENS = UBound($PRIVILEGE)
	$TOKEN_PRIVILEGES = DllStructCreate("dword;dword[" & (3 * $NTOKENS) & "]")
	$NEWTOKEN_PRIVILEGES = DllStructCreate("dword;dword[" & (3 * $NTOKENS) & "]")
	$HCURRPROCESS = DllCall("kernel32.dll", "hwnd", "GetCurrentProcess")
	$SP_AUXRET = DllCall("advapi32.dll", "int", "OpenProcessToken", "hwnd", $HCURRPROCESS[0], "int", BitOR($TOKEN_ADJUST_PRIVILEGES, $TOKEN_QUERY), "int_ptr", 0)
	If $SP_AUXRET[0] Then
		$HTOKEN = $SP_AUXRET[3]
		DllStructSetData($TOKEN_PRIVILEGES, 1, 1)
		$NTOKENINDEX = 1
		While $NTOKENINDEX <= $NTOKENS
			If IsArray($PRIVILEGE) Then
				$PRIV = $PRIVILEGE[$NTOKENINDEX - 1]
			Else
				$PRIV = $PRIVILEGE
			EndIf
			$RET = DllCall("advapi32.dll", "int", "LookupPrivilegeValue", "str", "", "str", $PRIV, "ptr", DllStructGetPtr($LUID))
			If $RET[0] Then
				If $BENABLE Then
					DllStructSetData($TOKEN_PRIVILEGES, 2, $SE_PRIVILEGE_ENABLED, (3 * $NTOKENINDEX))
				Else
					DllStructSetData($TOKEN_PRIVILEGES, 2, 0, (3 * $NTOKENINDEX))
				EndIf
				DllStructSetData($TOKEN_PRIVILEGES, 2, DllStructGetData($LUID, 1), (3 * ($NTOKENINDEX - 1)) + 1)
				DllStructSetData($TOKEN_PRIVILEGES, 2, DllStructGetData($LUID, 2), (3 * ($NTOKENINDEX - 1)) + 2)
				DllStructSetData($LUID, 1, 0)
				DllStructSetData($LUID, 2, 0)
			EndIf
			$NTOKENINDEX += 1
		WEnd
		$RET = DllCall("advapi32.dll", "int", "AdjustTokenPrivileges", "hwnd", $HTOKEN, "int", 0, "ptr", DllStructGetPtr($TOKEN_PRIVILEGES), "int", DllStructGetSize($NEWTOKEN_PRIVILEGES), "ptr", DllStructGetPtr($NEWTOKEN_PRIVILEGES), "int_ptr", 0)
		$F = DllCall("kernel32.dll", "int", "GetLastError")
	EndIf
	$NEWTOKEN_PRIVILEGES = 0
	$TOKEN_PRIVILEGES = 0
	$LUID = 0
	If $SP_AUXRET[0] = 0 Then Return 0
	$SP_AUXRET = DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $HTOKEN)
	If Not $RET[0] And Not $SP_AUXRET[0] Then Return 0
	Return $RET[0]
EndFunc

#endregion
Global Const $BS_GROUPBOX = 7
Global Const $BS_BOTTOM = 2048
Global Const $BS_CENTER = 768
Global Const $BS_DEFPUSHBUTTON = 1
Global Const $BS_LEFT = 256
Global Const $BS_MULTILINE = 8192
Global Const $BS_PUSHBOX = 10
Global Const $BS_PUSHLIKE = 4096
Global Const $BS_RIGHT = 512
Global Const $BS_RIGHTBUTTON = 32
Global Const $BS_TOP = 1024
Global Const $BS_VCENTER = 3072
Global Const $BS_FLAT = 32768
Global Const $BS_ICON = 64
Global Const $BS_BITMAP = 128
Global Const $BS_NOTIFY = 16384
Global Const $BS_SPLITBUTTON = 12
Global Const $BS_DEFSPLITBUTTON = 13
Global Const $BS_COMMANDLINK = 14
Global Const $BS_DEFCOMMANDLINK = 15
Global Const $BCSIF_GLYPH = 1
Global Const $BCSIF_IMAGE = 2
Global Const $BCSIF_STYLE = 4
Global Const $BCSIF_SIZE = 8
Global Const $BCSS_NOSPLIT = 1
Global Const $BCSS_STRETCH = 2
Global Const $BCSS_ALIGNLEFT = 4
Global Const $BCSS_IMAGE = 8
Global Const $BUTTON_IMAGELIST_ALIGN_LEFT = 0
Global Const $BUTTON_IMAGELIST_ALIGN_RIGHT = 1
Global Const $BUTTON_IMAGELIST_ALIGN_TOP = 2
Global Const $BUTTON_IMAGELIST_ALIGN_BOTTOM = 3
Global Const $BUTTON_IMAGELIST_ALIGN_CENTER = 4
Global Const $BS_3STATE = 5
Global Const $BS_AUTO3STATE = 6
Global Const $BS_AUTOCHECKBOX = 3
Global Const $BS_CHECKBOX = 2
Global Const $BS_RADIOBUTTON = 4
Global Const $BS_AUTORADIOBUTTON = 9
Global Const $BS_OWNERDRAW = 11
Global Const $GUI_SS_DEFAULT_BUTTON = 0
Global Const $GUI_SS_DEFAULT_CHECKBOX = 0
Global Const $GUI_SS_DEFAULT_GROUP = 0
Global Const $GUI_SS_DEFAULT_RADIO = 0
Global Const $BCM_FIRST = 5632
Global Const $BCM_GETIDEALSIZE = ($BCM_FIRST + 1)
Global Const $BCM_GETIMAGELIST = ($BCM_FIRST + 3)
Global Const $BCM_GETNOTE = ($BCM_FIRST + 10)
Global Const $BCM_GETNOTELENGTH = ($BCM_FIRST + 11)
Global Const $BCM_GETSPLITINFO = ($BCM_FIRST + 8)
Global Const $BCM_GETTEXTMARGIN = ($BCM_FIRST + 5)
Global Const $BCM_SETDROPDOWNSTATE = ($BCM_FIRST + 6)
Global Const $BCM_SETIMAGELIST = ($BCM_FIRST + 2)
Global Const $BCM_SETNOTE = ($BCM_FIRST + 9)
Global Const $BCM_SETSHIELD = ($BCM_FIRST + 12)
Global Const $BCM_SETSPLITINFO = ($BCM_FIRST + 7)
Global Const $BCM_SETTEXTMARGIN = ($BCM_FIRST + 4)
Global Const $BM_CLICK = 245
Global Const $BM_GETCHECK = 240
Global Const $BM_GETIMAGE = 246
Global Const $BM_GETSTATE = 242
Global Const $BM_SETCHECK = 241
Global Const $BM_SETDONTCLICK = 248
Global Const $BM_SETIMAGE = 247
Global Const $BM_SETSTATE = 243
Global Const $BM_SETSTYLE = 244
Global Const $BCN_FIRST = -1250
Global Const $BCN_DROPDOWN = ($BCN_FIRST + 2)
Global Const $BCN_HOTITEMCHANGE = ($BCN_FIRST + 1)
Global Const $BN_CLICKED = 0
Global Const $BN_PAINT = 1
Global Const $BN_HILITE = 2
Global Const $BN_UNHILITE = 3
Global Const $BN_DISABLE = 4
Global Const $BN_DOUBLECLICKED = 5
Global Const $BN_SETFOCUS = 6
Global Const $BN_KILLFOCUS = 7
Global Const $BN_PUSHED = $BN_HILITE
Global Const $BN_UNPUSHED = $BN_UNHILITE
Global Const $BN_DBLCLK = $BN_DOUBLECLICKED
Global Const $BST_CHECKED = 1
Global Const $BST_INDETERMINATE = 2
Global Const $BST_UNCHECKED = 0
Global Const $BST_FOCUS = 8
Global Const $BST_PUSHED = 4
Global Const $BST_DONTCLICK = 128
#Region ### START Koda GUI section ### Form=
$FORM1 = GUICreate("PlayerInfo", 520, 59, 300, 0, BitOR($WS_POPUP, $WS_CLIPSIBLINGS, $WS_EX_TOOLWINDOW, $WS_EX_TOPMOST))
GUISetBkColor(0)
$PROGRESS1 = GUICtrlCreateProgress(32, 8, 174, 16, $PBS_SMOOTH)
GUICtrlSetColor(-1, 16711680)
GUICtrlSetBkColor(-1, 0)
$PROGRESS2 = GUICtrlCreateProgress(32, 32, 174, 16, $PBS_SMOOTH)
GUICtrlSetColor(-1, 3381758)
GUICtrlSetBkColor(-1, 0)
$LABEL1 = GUICtrlCreateLabel("HP:", 8, 8, 22, 17)
GUICtrlSetColor(-1, 16777215)
$LABEL2 = GUICtrlCreateLabel("MP:", 8, 32, 23, 17)
GUICtrlSetColor(-1, 16777215)
$LABEL3 = GUICtrlCreateLabel("EXP: ", 215, 8, 23, 17)
GUICtrlSetColor(-1, 16777215)
$LABEL4 = GUICtrlCreateLabel(" %", 245, 8, 40, 17)
GUICtrlSetColor(-1, 16777215)
GUICtrlCreateLabel("SP: ", 215, 32, 23, 17)
GUICtrlSetColor(-1, 16777215)
$LABEL5 = GUICtrlCreateLabel(" ", 245, 32, 40, 17)
GUICtrlSetColor(-1, 16777215)
GUICtrlCreateLabel("Y:", 280, 8, 40, 17)
GUICtrlSetColor(-1, 16777215)
$POSY = GUICtrlCreateLabel(" ", 295, 8, 40, 17)
GUICtrlSetColor(-1, 16777215)
GUICtrlCreateLabel("X:", 280, 32, 40, 17)
GUICtrlSetColor(-1, 16777215)
$POSX = GUICtrlCreateLabel(" ", 295, 32, 40, 17)
GUICtrlSetColor(-1, 16777215)
$NICK = GUICtrlCreateLabel(" ", 332, 8, 60, 17)
GUICtrlSetColor(-1, 16777215)
$SERVER = GUICtrlCreateLabel(" ", 332, 32, 60, 17)
GUICtrlSetColor(-1, 16777215)
GUICtrlCreateLabel("www.gamerzplanet.pl", 400, 8, 120, 17)
GUICtrlSetColor(-1, 16711680)
$SHOW = GUICtrlCreateButton("Show", 400, 25, 37, 19)
GUICtrlSetColor(-1, 16777215)
GUICtrlSetBkColor(-1, 0)
$HIDE = GUICtrlCreateButton("Hide", 440, 25, 37, 19)
GUICtrlSetColor(-1, 16777215)
GUICtrlSetBkColor(-1, 0)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
WinSetOnTop("PlayerInfo", "", 1)
$PROC = ProcessList("SRO_Client.exe")
$ADRESS = 13878952
$ADRESS2 = 13878696
$ID = _MEMORYOPEN($PROC[1][1])
$CHARNAME = _MEMORYREAD($ADRESS, $ID, "wchar[16]")
$SERVERS = _MEMORYREAD($ADRESS2, $ID, "wchar[16]")
_MEMORYCLOSE($ID)
GUICtrlSetData($NICK, $CHARNAME)
GUICtrlSetData($SERVER, $SERVERS)
Opt("GUIOnEventMode", 1)
GUICtrlSetOnEvent($HIDE, "_hide")
GUICtrlSetOnEvent($SHOW, "_show")

Func _HIDE()
	WinSetState("[Class:CLIENT]", "", @SW_HIDE)
EndFunc


Func _SHOW()
	WinSetState("[Class:CLIENT]", "", @SW_SHOW)
EndFunc

While 1
	Global $POINTER = 13885268
	Global $CURHPOS = 1116
	Global $MAXHPOS = 1108
	Global $CURMPOS = 1104
	Global $MAXMPOS = 1112
	Global $CUREXPOFFSET = 2120
	Global $PLAYERLEVELOFFSET = 2112
	Global $CURSPOFFSET = 2136
	Global $PROC = ProcessList("SRO_Client.exe")
	Global $DLLINFO1 = _MEMORYOPEN($PROC[1][1])
	Global $LV1 = 118
	Global $LV2 = 470
	Global $LV3 = 1058
	Global $LV4 = 1880
	Global $LV5 = 2938
	Global $LV6 = 5640
	Global $LV7 = 9048
	Global $LV8 = 13160
	Global $LV9 = 17987
	Global $LV10 = 23500
	Global $LV11 = 34898
	Global $LV12 = 47940
	Global $LV13 = 61628
	Global $LV14 = 78960
	Global $LV15 = 96938
	Global $LV16 = 127840
	Global $LV17 = 161798
	Global $LV18 = 198810
	Global $LV19 = 238878
	Global $LV20 = 282000
	Global $LV21 = 351231
	Global $LV22 = 427755
	Global $LV23 = 512196
	Global $LV24 = 605232
	Global $LV25 = 707587
	Global $LV26 = 820046
	Global $LV27 = 943453
	Global $LV28 = 1078717
	Global $LV29 = 1226815
	Global $LV30 = 1388803
	Global $LV31 = 1595229
	Global $LV32 = 1818827
	Global $LV33 = 2060796
	Global $LV34 = 2322414
	Global $LV35 = 2605043
	Global $LV36 = 2910129
	Global $LV37 = 3239210
	Global $LV38 = 3593924
	Global $LV39 = 3976012
	Global $LV40 = 4387323
	Global $LV41 = 4869381
	Global $LV42 = 5382982
	Global $LV43 = 5929882
	Global $LV44 = 6511920
	Global $LV45 = 7131034
	Global $LV46 = 7789258
	Global $LV47 = 8488730
	Global $LV48 = 9231697
	Global $LV49 = 10020519
	Global $LV50 = 10857676
	Global $LV51 = 11857343
	Global $LV52 = 19213686
	Global $LV53 = 14029449
	Global $LV54 = 15207495
	Global $LV55 = 16450818
	Global $LV56 = 17762545
	Global $LV57 = 19145940
	Global $LV58 = 20604414
	Global $LV59 = 22141527
	Global $LV60 = 23760997
	Global $LV61 = 25933410
	Global $LV62 = 28214785
	Global $LV63 = 30609702
	Global $LV64 = 39747505
	Global $LV65 = 51493509
	Global $LV66 = 55474876
	Global $LV67 = 59648780
	Global $LV68 = 64023195
	Global $LV69 = 68606389
	Global $LV70 = 73406955
	Global $LV71 = 79345238
	Global $LV72 = 85573756
	Global $LV73 = 92104572
	Global $LV74 = 98950215
	Global $LV75 = 106123703
	Global $LV76 = 113638552
	Global $LV77 = 121508783
	Global $LV78 = 129748946
	Global $LV79 = 138374168
	Global $LV80 = 147400127
	Global $LV81 = 158227752
	Global $LV82 = 169572387
	Global $LV83 = 181455292
	Global $LV84 = 193898546
	Global $LV85 = 206925087
	Global $LV86 = 220558723
	Global $LV87 = 234824141
	Global $LV88 = 249746989
	Global $LV89 = 265353867
	Global $LV90 = 281672373
	Global $LV91 = 369337595
	Global $LV92 = 473538898
	Global $LV93 = 430636533
	Global $LV94 = 688586209
	Global $LV95 = 686078166
	Global $LV96 = 630281734
	Global $LV97 = 843249355
	Global $LV98 = 963955058
	Global $LV99 = 1322659532
	Global $LV100 = 1406035568
	$MP = _FINDNEWADDRESS($POINTER, $CURMPOS)
	$CURMP = _MEMORYREAD($MP, $DLLINFO1)
	$MAXMP = _FINDNEWADDRESS($POINTER, $MAXMPOS)
	$MAXMPOS = _MEMORYREAD($MAXMP, $DLLINFO1)
	$HP = _FINDNEWADDRESS($POINTER, $CURHPOS)
	$CURHPOS = _MEMORYREAD($HP, $DLLINFO1)
	$MAXHP = _FINDNEWADDRESS($POINTER, $MAXHPOS)
	$MAXHPOS = _MEMORYREAD($MAXHP, $DLLINFO1)
	$CURSPADD = _FINDNEWADDRESS($POINTER, $CURSPOFFSET)
	$CURSP = _MEMORYREAD($CURSPADD, $DLLINFO1)
	$LEVELADD = _FINDNEWADDRESS($POINTER, $PLAYERLEVELOFFSET)
	$CURLV = _MEMORYREAD($LEVELADD, $DLLINFO1, "byte")
	$CUREXPADD = _FINDNEWADDRESS($POINTER, $CUREXPOFFSET)
	$CUREXP = _MEMORYREAD($CUREXPADD, $DLLINFO1)
	$NICKS = _MEMORYREAD($POINTER, $DLLINFO1, "wchar[12]")
	$SERVER = _MEMORYREAD($POINTER, $DLLINFO1, "wchar[12]")
	If $CURLV = "1"  Then
		$EXX = $LV1
	ElseIf $CURLV = "2"  Then
		$EXX = $LV2
	ElseIf $CURLV = "3"  Then
		$EXX = $LV3
	ElseIf $CURLV = "4"  Then
		$EXX = $LV4
	ElseIf $CURLV = "5"  Then
		$EXX = $LV5
	ElseIf $CURLV = "6"  Then
		$EXX = $LV6
	ElseIf $CURLV = "7"  Then
		$EXX = $LV7
	ElseIf $CURLV = "8"  Then
		$EXX = $LV8
	ElseIf $CURLV = "9"  Then
		$EXX = $LV9
	ElseIf $CURLV = "10"  Then
		$EXX = $LV10
	ElseIf $CURLV = "11"  Then
		$EXX = $LV11
	ElseIf $CURLV = "12"  Then
		$EXX = $LV12
	ElseIf $CURLV = "13"  Then
		$EXX = $LV13
	ElseIf $CURLV = "14"  Then
		$EXX = $LV14
	ElseIf $CURLV = "15"  Then
		$EXX = $LV15
	ElseIf $CURLV = "16"  Then
		$EXX = $LV16
	ElseIf $CURLV = "17"  Then
		$EXX = $LV17
	ElseIf $CURLV = "18"  Then
		$EXX = $LV18
	ElseIf $CURLV = "19"  Then
		$EXX = $LV19
	ElseIf $CURLV = "20"  Then
		$EXX = $LV20
	ElseIf $CURLV = "21"  Then
		$EXX = $LV21
	ElseIf $CURLV = "22"  Then
		$EXX = $LV22
	ElseIf $CURLV = "23"  Then
		$EXX = $LV23
	ElseIf $CURLV = "24"  Then
		$EXX = $LV24
	ElseIf $CURLV = "25"  Then
		$EXX = $LV25
	ElseIf $CURLV = "26"  Then
		$EXX = $LV26
	ElseIf $CURLV = "27"  Then
		$EXX = $LV27
	ElseIf $CURLV = "28"  Then
		$EXX = $LV28
	ElseIf $CURLV = "29"  Then
		$EXX = $LV29
	ElseIf $CURLV = "30"  Then
		$EXX = $LV30
	ElseIf $CURLV = "31"  Then
		$EXX = $LV31
	ElseIf $CURLV = "32"  Then
		$EXX = $LV32
	ElseIf $CURLV = "33"  Then
		$EXX = $LV33
	ElseIf $CURLV = "34"  Then
		$EXX = $LV34
	ElseIf $CURLV = "35"  Then
		$EXX = $LV35
	ElseIf $CURLV = "36"  Then
		$EXX = $LV36
	ElseIf $CURLV = "37"  Then
		$EXX = $LV37
	ElseIf $CURLV = "38"  Then
		$EXX = $LV38
	ElseIf $CURLV = "39"  Then
		$EXX = $LV39
	ElseIf $CURLV = "40"  Then
		$EXX = $LV40
	ElseIf $CURLV = "41"  Then
		$EXX = $LV41
	ElseIf $CURLV = "42"  Then
		$EXX = $LV42
	ElseIf $CURLV = "43"  Then
		$EXX = $LV43
	ElseIf $CURLV = "44"  Then
		$EXX = $LV44
	ElseIf $CURLV = "45"  Then
		$EXX = $LV45
	ElseIf $CURLV = "46"  Then
		$EXX = $LV46
	ElseIf $CURLV = "47"  Then
		$EXX = $LV47
	ElseIf $CURLV = "48"  Then
		$EXX = $LV48
	ElseIf $CURLV = "49"  Then
		$EXX = $LV49
	ElseIf $CURLV = "50"  Then
		$EXX = $LV50
	ElseIf $CURLV = "51"  Then
		$EXX = $LV51
	ElseIf $CURLV = "52"  Then
		$EXX = $LV52
	ElseIf $CURLV = "53"  Then
		$EXX = $LV53
	ElseIf $CURLV = "54"  Then
		$EXX = $LV54
	ElseIf $CURLV = "55"  Then
		$EXX = $LV55
	ElseIf $CURLV = "56"  Then
		$EXX = $LV56
	ElseIf $CURLV = "57"  Then
		$EXX = $LV57
	ElseIf $CURLV = "58"  Then
		$EXX = $LV58
	ElseIf $CURLV = "59"  Then
		$EXX = $LV59
	ElseIf $CURLV = "60"  Then
		$EXX = $LV60
	ElseIf $CURLV = "61"  Then
		$EXX = $LV61
	ElseIf $CURLV = "62"  Then
		$EXX = $LV62
	ElseIf $CURLV = "63"  Then
		$EXX = $LV63
	ElseIf $CURLV = "64"  Then
		$EXX = $LV64
	ElseIf $CURLV = "65"  Then
		$EXX = $LV65
	ElseIf $CURLV = "66"  Then
		$EXX = $LV66
	ElseIf $CURLV = "67"  Then
		$EXX = $LV67
	ElseIf $CURLV = "68"  Then
		$EXX = $LV68
	ElseIf $CURLV = "69"  Then
		$EXX = $LV69
	ElseIf $CURLV = "70"  Then
		$EXX = $LV70
	ElseIf $CURLV = "71"  Then
		$EXX = $LV71
	ElseIf $CURLV = "72"  Then
		$EXX = $LV72
	ElseIf $CURLV = "73"  Then
		$EXX = $LV73
	ElseIf $CURLV = "74"  Then
		$EXX = $LV74
	ElseIf $CURLV = "75"  Then
		$EXX = $LV75
	ElseIf $CURLV = "76"  Then
		$EXX = $LV76
	ElseIf $CURLV = "77"  Then
		$EXX = $LV77
	ElseIf $CURLV = "78"  Then
		$EXX = $LV78
	ElseIf $CURLV = "79"  Then
		$EXX = $LV79
	ElseIf $CURLV = "80"  Then
		$EXX = $LV80
	ElseIf $CURLV = "81"  Then
		$EXX = $LV81
	ElseIf $CURLV = "82"  Then
		$EXX = $LV82
	ElseIf $CURLV = "83"  Then
		$EXX = $LV83
	ElseIf $CURLV = "84"  Then
		$EXX = $LV84
	ElseIf $CURLV = "85"  Then
		$EXX = $LV85
	ElseIf $CURLV = "86"  Then
		$EXX = $LV86
	ElseIf $CURLV = "87"  Then
		$EXX = $LV87
	ElseIf $CURLV = "88"  Then
		$EXX = $LV88
	ElseIf $CURLV = "89"  Then
		$EXX = $LV89
	ElseIf $CURLV = "90"  Then
		$EXX = $LV90
	ElseIf $CURLV = "91"  Then
		$EXX = $LV91
	ElseIf $CURLV = "92"  Then
		$EXX = $LV92
	ElseIf $CURLV = "93"  Then
		$EXX = $LV93
	ElseIf $CURLV = "94"  Then
		$EXX = $LV94
	ElseIf $CURLV = "95"  Then
		$EXX = $LV95
	ElseIf $CURLV = "96"  Then
		$EXX = $LV96
	ElseIf $CURLV = "97"  Then
		$EXX = $LV97
	ElseIf $CURLV = "98"  Then
		$EXX = $LV98
	ElseIf $CURLV = "99"  Then
		$EXX = $LV99
	ElseIf $CURLV = "100"  Then
		$EXX = $LV100
	EndIf
	Global $EXPPER = $CUREXP * 100 / $EXX
	Global $RESULTS = StringTrimRight($EXPPER, 11)
	$CURHPOSZ = $CURHPOS / $MAXHPOS * 100
	GUICtrlSetData($PROGRESS1, $CURHPOSZ)
	$CURMPOSZ = $CURMP / $MAXMPOS * 100
	GUICtrlSetData($PROGRESS2, $CURMPOSZ)
	GUICtrlSetData($LABEL4, $RESULTS)
	GUICtrlSetData($LABEL5, $CURSP)
	$ECX = _MEMORYREAD($POINTER, $DLLINFO1, "DWORD")
	$EAX = _MEMORYREAD($ECX + 120, $DLLINFO1, "ushort")
	$EBX = $EAX
	$EDI = $EBX
	$EBP = $EBX
	$ESP_1C = $EAX
	$EDI = BitAND($EDI, Dec("0FF"))
	$EBP = BitShift($EBP, 8)
	$EAX = _MEMORYREAD($POINTER, $DLLINFO1)
	$EDX = _MEMORYREAD($EAX + Dec("7C"), $DLLINFO1)
	$FTMP4 = 0
	$FTMP5 = 0
	$FTMP4 = _MEMORYREAD($EAX + Dec("7C"), $DLLINFO1, "float")
	$EAX += 124
	$ECX = _MEMORYREAD($EAX + Dec("04"), $DLLINFO1)
	$ESI_3E4 = 0
	$ESI_3E4 = $ECX
	$EDX = _MEMORYREAD($EAX + Dec("8"), $DLLINFO1)
	$FTMP5 = _MEMORYREAD($EAX + Dec("8"), $DLLINFO1, "float")
	$ESI_3E8 = 0
	$ESI_3E8 = $EDX
	$EAX = _MEMORYREAD($POINTER, $DLLINFO1)
	$FTMP1 = 0
	$FTMP1 = _MEMORYREAD($EAX + Dec("88"), $DLLINFO1, "float")
	$ECX = _MEMORYREAD($POINTER, $DLLINFO1)
	$EAX = 0
	$ESP_20 = $EAX
	$EAX = $ESP_1C
	$EAX = BitShift($EBP, Dec("0F"))
	$ESP_2A = $EAX
	$FTMP4 /= -10
	$EAX = Int($FTMP4)
	$ECX = $EDI + $EDI * 2 - 405
	$ECX = BitShift($ECX, -6)
	$ECX -= $EAX
	$FINALX = $ECX
	$FTMP5 /= -10
	$EAX = Int($FTMP5)
	$ECX = $EBP + $EBP * 2 - 276
	$ECX = BitShift($ECX, -6)
	$ECX -= $EAX
	$FINALY = $ECX
	GUICtrlSetData($POSY, $FINALY)
	GUICtrlSetData($POSX, $FINALX)
	Sleep(100)
WEnd
_MEMORYCLOSE($PROC)

Func _FINDNEWADDRESS(ByRef $POINTER, ByRef $OSET)
	$NEW_ADDRESS = _MEMORYREAD($POINTER, $DLLINFO1) + $OSET
	Return $NEW_ADDRESS
EndFunc
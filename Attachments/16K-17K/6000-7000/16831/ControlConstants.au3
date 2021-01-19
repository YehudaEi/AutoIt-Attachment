#include-once
;Window Events
If Not IsDeclared('WM_NOTIFY') Then 		Global Const $WM_NOTIFY 	= 0x004E
If Not IsDeclared('WM_COMMAND') Then 		Global Const $WM_COMMAND 	= 0x0111
If Not IsDeclared('WM_KEYDOWN') Then 		Global Const $WM_KEYDOWN  	= 0x100
If Not IsDeclared('WM_COPYDATA') Then 		Global Const $WM_COPYDATA 	= 0x4A
If Not IsDeclared('WM_MOVING') Then 		Global Const $WM_MOVING 	= 0x0216
If Not IsDeclared('WM_MOVE') Then 			Global Const $WM_MOVE 		= 0x0003
If Not IsDeclared('WM_KILLFOCUS') Then 		Global Const $WM_KILLFOCUS 	= 0x0008
If Not IsDeclared('WM_SETFOCUS') Then 		Global Const $WM_SETFOCUS 	= 0x0007
If Not IsDeclared('WM_ACTIVATE') Then 		Global Const $WM_ACTIVATE 	= 0x0006
If Not IsDeclared('WM_CAPTURECHANGED') Then Global Const $WM_CAPTURECHANGED = 0x0215

;ListView Events
If Not IsDeclared('NM_FIRST') Then 			Global Const $NM_FIRST 				= 0
If Not IsDeclared('NM_LAST') Then 			Global Const $NM_LAST 				= (-99)
If Not IsDeclared('NM_OUTOFMEMORY') Then 	Global Const $NM_OUTOFMEMORY 		= ($NM_FIRST - 1)
If Not IsDeclared('NM_CLICK') Then 			Global Const $NM_CLICK 				= ($NM_FIRST - 2)
If Not IsDeclared('NM_DBLCLK') Then 		Global Const $NM_DBLCLK 			= ($NM_FIRST - 3)
If Not IsDeclared('NM_RETURN') Then 		Global Const $NM_RETURN 			= ($NM_FIRST - 4)
If Not IsDeclared('NM_RCLICK') Then 		Global Const $NM_RCLICK 			= ($NM_FIRST - 5)
If Not IsDeclared('NM_RDBLCLK') Then 		Global Const $NM_RDBLCLK 			= ($NM_FIRST - 6)
If Not IsDeclared('NM_SETFOCUS') Then 		Global Const $NM_SETFOCUS 			= ($NM_FIRST - 7)
If Not IsDeclared('NM_KILLFOCUS') Then 		Global Const $NM_KILLFOCUS 			= ($NM_FIRST - 8)
If Not IsDeclared('NM_CUSTOMDRAW') Then 	Global Const $NM_CUSTOMDRAW 		= ($NM_FIRST - 12)
If Not IsDeclared('NM_HOVER') Then 			Global Const $NM_HOVER 				= ($NM_FIRST - 13)
If Not IsDeclared('NM_NCHITTEST') Then 		Global Const $NM_NCHITTEST 			= ($NM_FIRST - 14)
If Not IsDeclared('NM_KEYDOWN') Then 		Global Const $NM_KEYDOWN 			= ($NM_FIRST - 15)
If Not IsDeclared('NM_RELEASEDCAPTURE') Then Global Const $NM_RELEASEDCAPTURE 	= ($NM_FIRST - 16)
If Not IsDeclared('NM_SETCURSOR') Then 		Global Const $NM_SETCURSOR 			= ($NM_FIRST - 17)
If Not IsDeclared('NM_CHAR') Then 			Global Const $NM_CHAR 				= ($NM_FIRST - 18)
If Not IsDeclared('NM_TOOLTIPSCREATED') Then Global Const $NM_TOOLTIPSCREATED 	= ($NM_FIRST - 19)
If Not IsDeclared('LVS_SHAREIMAGELISTS') Then Global Const $LVS_SHAREIMAGELISTS = 0x0040
If Not IsDeclared('LVN_FIRST') Then 		Global Const $LVN_FIRST 			= -100
If Not IsDeclared('LVN_ENDLABELEDITA') Then Global Const $LVN_ENDLABELEDITA 	= (-106)
If Not IsDeclared('LVN_ITEMCHANGING') Then 	Global Const $LVN_ITEMCHANGING 		= ($LVN_FIRST - 0)
If Not IsDeclared('LVN_ITEMCHANGED') Then 	Global Const $LVN_ITEMCHANGED 		= ($LVN_FIRST - 1)
If Not IsDeclared('LVN_INSERTITEM') Then 	Global Const $LVN_INSERTITEM 		= ($LVN_FIRST - 2)
If Not IsDeclared('LVN_DELETEITEM') Then 	Global Const $LVN_DELETEITEM 		= ($LVN_FIRST - 3)
If Not IsDeclared('LVN_DELETEALLITEMS') Then Global Const $LVN_DELETEALLITEMS 	= ($LVN_FIRST - 4)
If Not IsDeclared('LVN_COLUMNCLICK') Then 	Global Const $LVN_COLUMNCLICK 		= ($LVN_FIRST - 8)
If Not IsDeclared('LVN_BEGINDRAG') Then 	Global Const $LVN_BEGINDRAG 		= ($LVN_FIRST - 9)
If Not IsDeclared('LVN_BEGINRDRAG') Then 	Global Const $LVN_BEGINRDRAG 		= ($LVN_FIRST - 11)
If Not IsDeclared('LVN_ODCACHEHINT') Then 	Global Const $LVN_ODCACHEHINT 		= ($LVN_FIRST - 13)   
If Not IsDeclared('LVN_ITEMACTIVATE') Then 	Global Const $LVN_ITEMACTIVATE 		= ($LVN_FIRST - 14)
If Not IsDeclared('LVN_ODSTATECHANGED') Then Global Const $LVN_ODSTATECHANGED 	= ($LVN_FIRST - 15)
If Not IsDeclared('LVN_HOTTRACK') Then 		Global Const $LVN_HOTTRACK 			= ($LVN_FIRST - 21)
If Not IsDeclared('LVN_KEYDOWN ') Then 		Global Const $LVN_KEYDOWN 			= ($LVN_FIRST - 55)
If Not IsDeclared('LVN_MARQUEEBEGIN') Then 	Global Const $LVN_MARQUEEBEGIN 		= ($LVN_FIRST - 56) 

;Edit Events
If Not IsDeclared('EN_CHANGE') Then 	Global Const $EN_CHANGE = 0x300
If Not IsDeclared('EN_SETFOCUS') Then 	Global Const $EN_SETFOCUS = 0x100
If Not IsDeclared('EN_KILLFOCUS') Then 	Global Const $EN_KILLFOCUS = 0x200
If Not IsDeclared('EN_UPDATE') Then 	Global Const $EN_UPDATE =0x0400

;ComboBox Events
If Not IsDeclared('CBN_EDITCHANGE') Then 	Global Const $CBN_EDITCHANGE 	= 5
If Not IsDeclared('CBN_SELCHANGE') Then 	Global Const $CBN_SELCHANGE 	= 1
If Not IsDeclared('CBN_EDITUPDATE') Then 	Global Const $CBN_EDITUPDATE 	= 6
If Not IsDeclared('CBN_KILLFOCUS') Then 	Global Const $CBN_KILLFOCUS 	= 4
If Not IsDeclared('CBN_SETFOCUS') Then 		Global Const $CBN_SETFOCUS 		= 3
If Not IsDeclared('CBN_DBLCLK ') Then 		Global Const $CBN_DBLCLK        = 2;
If Not IsDeclared('CBN_DROPDOWN ') Then 	Global Const $CBN_DROPDOWN      = 7;
If Not IsDeclared('CBN_CLOSEUP') Then 		Global Const $CBN_CLOSEUP       = 8;
If Not IsDeclared('CBN_SELENDOK') Then 		Global Const $CBN_SELENDOK      = 9;
If Not IsDeclared('CBN_SELENDCANCEL') Then 	Global Const $CBN_SELENDCANCEL  = 10;

; Date/Time Events
If Not IsDeclared('DTN_FIRST') Then 			Global Const $DTN_FIRST 		= -760
If Not IsDeclared('DTN_DATETIMECHANGE') Then 	Global Const $DTN_DATETIMECHANGE = $DTN_FIRST + 1 ; the systemtime has changed
If Not IsDeclared('DTN_USERSTRINGA') Then 		Global Const $DTN_USERSTRINGA 	= $DTN_FIRST + 2  ; the user has entered a string
If Not IsDeclared('DTN_WMKEYDOWNA') Then 		Global Const $DTN_WMKEYDOWNA 	= $DTN_FIRST + 3  ; modify keydown on app format field (X)
If Not IsDeclared('DTN_FORMATA') Then 			Global Const $DTN_FORMATA 		= $DTN_FIRST + 4  ; query display for app format field (X)
If Not IsDeclared('DTN_FORMATQUERYA') Then 		Global Const $DTN_FORMATQUERYA 	= $DTN_FIRST + 5  ; query formatting info for app format field (X)
If Not IsDeclared('DTN_DROPDOWN') Then 			Global Const $DTN_DROPDOWN 		= $DTN_FIRST + 6  ; MonthCal has dropped down
If Not IsDeclared('DTN_CLOSEUP') Then 			Global Const $DTN_CLOSEUP 		= $DTN_FIRST + 7  ; MonthCal is popping up


; unknown group
If Not IsDeclared('HDN_FIRST') Then		Global Const $HDN_FIRST 	= -300
If Not IsDeclared('HDN_TRACK') Then		Global Const $HDN_TRACK 	= ($HDN_FIRST - 8)
If Not IsDeclared('HDN_TRACKW') Then	Global Const $HDN_TRACKW 	= ($HDN_FIRST - 28)

If Not IsDeclared('LBN_SELCHANGE') Then Global Const $LBN_SELCHANGE = 1
If Not IsDeclared('LBN_DBLCLK') Then 	Global Const $LBN_DBLCLK 	= 2
If Not IsDeclared('LBN_SETFOCUS') Then 	Global Const $LBN_SETFOCUS	= 4
If Not IsDeclared('LBN_KILLFOCUS') Then Global Const $LBN_KILLFOCUS = 5

 
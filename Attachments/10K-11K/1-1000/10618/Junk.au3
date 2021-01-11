#cs===========================================================================
Start Global CONST declarations
#ce===========================================================================

#include <GUIConstants.au3>
#include <GUIListView.au3>
Global Const $WM_NOTIFY = 0x004E
;==============================================================================================================
; Generic WM_NOTIFY notification codes
;---------------Variable-------------------|------Value-------------|--Description--|--IE-Ver------------------
Global Const $NM_FIRST                     = 0                      ;---
Global Const $NM_LAST                      = (-99)                  ;---
Global Const $NM_OUTOFMEMORY               = ($NM_FIRST - 1)        ;---
Global Const $NM_CLICK                     = ($NM_FIRST - 2)        ;NMCLICK struct
Global Const $NM_DBLCLK                    = ($NM_FIRST - 3)        ;---
Global Const $NM_RETURN                    = ($NM_FIRST - 4)        ;---
Global Const $NM_RCLICK                    = ($NM_FIRST - 5)        ;NMCLICK struct
Global Const $NM_RDBLCLK                   = ($NM_FIRST - 6)        ;---
Global Const $NM_SETFOCUS                  = ($NM_FIRST - 7)        ;---
Global Const $NM_KILLFOCUS                 = ($NM_FIRST - 8)        ;---
Global Const $NM_CUSTOMDRAW                = ($NM_FIRST - 12)       ;---             IE >= 0x0300
Global Const $NM_HOVER                     = ($NM_FIRST - 13)       ;---             IE >= 0x0300
Global Const $NM_NCHITTEST                 = ($NM_FIRST - 14)       ;NMMOUSE struct  IE >= 0x0400
Global Const $NM_KEYDOWN                   = ($NM_FIRST - 15)       ;NMKEY struct    IE >= 0x0400
Global Const $NM_RELEASEDCAPTURE           = ($NM_FIRST - 16)       ;---             IE >= 0x0400
Global Const $NM_SETCURSOR                 = ($NM_FIRST - 17)       ;NMMOUSE struct  IE >= 0x0400
Global Const $NM_CHAR                      = ($NM_FIRST - 18)       ;NMCHAR struct   IE >= 0x0400
Global Const $NM_TOOLTIPSCREATED           = ($NM_FIRST - 19)       ;---


;==============================================================================================================
; Ranges for control message IDs
;---------------Variable-------------------|------Value-------------|--Description--|--IE-Ver------------------
;~ Global Const $LVM_FIRST                    = 0x1000                 ;ListView
;~ Global Const $TV_FIRST                     = 0x1100                 ;TreeView
;~ Global Const $HDM_FIRST                    = 0x1200                 ;Header
;~ Global Const $TCM_FIRST                    = 0x1300                 ;Tab Ctrl
;~ Global Const $PGM_FIRST                    = 0x1400                 ;Pager Ctrl          IE >= 0x0400
;~ Global Const $CCM_FIRST                    = 0x2000                 ;CommonCtrl Shared   IE >= 0x0400


;==============================================================================================================
; WM_NOTIFY codes (NMHDR.code values)
;---------------Variable-------------------|------Value-------------|--Description--|--IE-Ver------------------
;~ Global Const $NM_FIRST                     = (0)                    ;Generic (All Ctrls)
;~ Global Const $NM_LAST                      = (-99)
Global Const $LVN_FIRST                    = (-100)                 ;Listview
Global Const $LVN_LAST                     = (-199)
Global Const $HDN_FIRST                    = (-300)                 ;Header
Global Const $HDN_LAST                     = (-399)
Global Const $TVN_FIRST                    = (-400)                 ;Treeview
Global Const $TVN_LAST                     = (-499)
Global Const $TTN_FIRST                    = (-520)                 ;Tooltips
Global Const $TTN_LAST                     = (-549)
;~ Global Const $TCN_FIRST                    = (-550)                 ;Tab control
;~ Global Const $TCN_LAST                     = (-580)
;Shell Reserved                              (-580) - (-589)        ;Shell Reserved
Global Const $CDN_FIRST                    = (-601)                 ;Common dialog (new)
Global Const $CDN_LAST                     = (-699)
Global Const $TBN_FIRST                    = (-700)                 ;Toolbar
Global Const $TBN_LAST                     = (-720)
Global Const $UDN_FIRST                    = (-721)                 ;Updown
Global Const $UDN_LAST                     = (-740)
Global Const $MCN_FIRST                    = (-750)                 ;Monthcal        IE >= 0x0300
Global Const $MCN_LAST                     = (-759)
Global Const $DTN_FIRST                    = (-760)                 ;Datetimepick    IE >= 0x0300
Global Const $DTN_LAST                     = (-799)
Global Const $CBEN_FIRST                   = (-800)                 ;Combo box ex    IE >= 0x0300
Global Const $CBEN_LAST                    = (-830)
Global Const $RBN_FIRST                    = (-831)                 ;Rebar           IE >= 0x0300
Global Const $RBN_LAST                     = (-859)
Global Const $IPN_FIRST                    = (-860)                 ;Internet addr   IE >= 0x0400
Global Const $IPN_LAST                     = (-879)
Global Const $SBN_FIRST                    = (-880)                 ;Status bar      IE >= 0x0400
Global Const $SBN_LAST                     = (-899)
Global Const $PGN_FIRST                    = (-900)                 ;Pager Control   IE >= 0x0400
Global Const $PGN_LAST                     = (-950)

#region Begin Global Constant Declarations
;==============================================================================================================
; ListView Styles
;---------------Variable-------------------|------Value-------------|--Description--|--IE-Ver------------------
;~ Global Const $LVS_ICON                     = 0x0000                 ;---
;~ Global Const $LVS_REPORT                   = 0x0001                 ;---
;~ Global Const $LVS_SMALLICON                = 0x0002                 ;---
;~ Global Const $LVS_LIST                     = 0x0003                 ;---
Global Const $LVS_TYPEMASK                 = 0x0003                 ;---
;~ Global Const $LVS_SINGLESEL                = 0x0004                 ;---
;~ Global Const $LVS_SHOWSELALWAYS            = 0x0008                 ;---
;~ Global Const $LVS_SORTASCENDING            = 0x0010                 ;---
;~ Global Const $LVS_SORTDESCENDING           = 0x0020                 ;---
Global Const $LVS_SHAREIMAGELISTS          = 0x0040                 ;---
Global Const $LVS_NOLABELWRAP              = 0x0080                 ;---
Global Const $LVS_AUTOARRANGE              = 0x0100                 ;---
;~ Global Const $LVS_EDITLABELS               = 0x0200                 ;---
Global Const $LVS_OWNERDATA                = 0x1000                 ;---              IE >= 0x0300
Global Const $LVS_NOSCROLL                 = 0x2000                 ;---
Global Const $LVS_TYPESTYLEMASK            = 0xfc00                 ;---
Global Const $LVS_ALIGNTOP                 = 0x0000                 ;---
Global Const $LVS_ALIGNLEFT                = 0x0800                 ;---
Global Const $LVS_ALIGNMASK                = 0x0c00                 ;---
Global Const $LVS_OWNERDRAWFIXED           = 0x0400                 ;---
;~ Global Const $LVS_NOCOLUMNHEADER           = 0x4000                 ;---
;~ Global Const $LVS_NOSORTHEADER             = 0x8000                 ;---

;==============================================================================================================
; ListView Item States
;---------------Variable-------------------|------Value-------------|--Description-----------------------------
;~ Global Const $LVIS_FOCUSED                 = 0x0001                 ;Flag: Item has Focus
;~ Global Const $LVIS_SELECTED                = 0x0002                 ;Flag: Item is Selected
;~ Global Const $LVIS_CUT                     = 0x0004                 ;Flag: Marked for Cut & Paste
;~ Global Const $LVIS_DROPHILITED             = 0x0008                 ;Flag: Is Drag & Drop target
Global Const $LVIS_ACTIVATING              = 0x0020                 ;Not Currently Supported
;~ Global Const $LVIS_OVERLAYMASK             = 0x0F00                 ;Flag: mask = overlay image index
;~ Global Const $LVIS_STATEIMAGEMASK          = 0xF000                 ;Flag: mask = state image index

;==============================================================================================================
; ListView GetNextItem Flags
;---------------Variable-------------------|------Value-------------|--Description-----------------------------
;~ Global Const $LVNI_ALL                     = 0x0000                 ;Default: Next item by index.

;Item State = Any/All/Some of the following values:
;~ Global Const $LVNI_FOCUSED                 = 0x0001                 ;Item has $LVIS_FOCUSED flag set.
;~ Global Const $LVNI_SELECTED                = 0x0002                 ;Item has $LVIS_SELECTED flag set.
;~ Global Const $LVNI_CUT                     = 0x0004                 ;Item has $LVIS_CUT flag set.
;~ Global Const $LVNI_DROPHILITED             = 0x0008                 ;Item has $LVIS_DROPHILITED flag set.

;Searches by index:
;~ Global Const $LVNI_ABOVE                   = 0x0100                 ;Above the specified item.
;~ Global Const $LVNI_BELOW                   = 0x0200                 ;Below the specified item.
;~ Global Const $LVNI_TOLEFT                  = 0x0400                 ;Left of the specified item.
;~ Global Const $LVNI_TORIGHT                 = 0x0800                 ;Right of the specified item.

;==============================================================================================================
; ListView SetItemCount Flags
;---------------Variable-------------------|------Value-------------|--Description-----------------------------
;~ Global Const $LVSICF_NOINVALIDATEALL       = 0x0001                 ;Don't repaint unless item is in view
;~ Global Const $LVSICF_NOSCROLL              = 0x0002                 ;Don't scroll when item count = ++/--

;==============================================================================================================
; ListView SetImageList Flags
;---------------Variable-------------------|------Value-------------|--Description-----------------------------
;~ Global Const $LVSIL_NORMAL                 = 0                      ;Large Icons
;~ Global Const $LVSIL_SMALL                  = 1                      ;Small Icons
;~ Global Const $LVSIL_STATE                  = 2                      ;State Images

;==============================================================================================================
; ListView Arrange Flags
;---------------Variable-------------------|------Value-------------|--Description-----------------------------
;~ Global Const $LVA_DEFAULT                  = 0x0000                 ;Default: Align = Current
;~ Global Const $LVA_ALIGNLEFT                = 0x0001                 ;Align along the left of window
;~ Global Const $LVA_ALIGNTOP                 = 0x0002                 ;Align along the top of window
;~ Global Const $LVA_SNAPTOGRID               = 0x0005                 ;Snap to nearest grid position

;==============================================================================================================
; ListView GetView/SetView
;---------------Variable-------------------|------Value-------------|--Description-----------------------------
;~ Global Const $LV_VIEW_ICON                 = 0x0000                 ;---
;~ Global Const $LV_VIEW_DETAILS              = 0x0001                 ;---
;~ Global Const $LV_VIEW_SMALLICON            = 0x0002                 ;---
;~ Global Const $LV_VIEW_LIST                 = 0x0003                 ;---
;~ Global Const $LV_VIEW_TILE                 = 0x0004                 ;---

;==============================================================================================================
; ListView LVCOLUMN Mask
;---------------Variable-------------------|------Value-------------|--Description-----------------------------
;~ Global Const $LVCF_FMT                     = 0x0001                 ;The fmt member is valid.
;~ Global Const $LVCF_WIDTH                   = 0x0002                 ;The pszText member is valid.
;~ Global Const $LVCF_TEXT                    = 0x0004                 ;The cx member is valid.

;==============================================================================================================
; ListView LVCOLUMN Format
;---------------Variable-------------------|------Value-------------|--Description-----------------------------
;~ Global Const $LVCFMT_LEFT                  = 0x0000                 ;Left aligned text.
;~ Global Const $LVCFMT_RIGHT                 = 0x0001                 ;Right aligned text.
;~ Global Const $LVCFMT_CENTER                = 0x0002                 ;Centered text.

;==============================================================================================================
; ListView Extended Styles
;---------------Variable-------------------|------Value-------------|--Description--|--IE-Ver-------|-Unicode?-
;~ Global Const $LVS_EX_GRIDLINES             = 0x00000001             ;---
;~ Global Const $LVS_EX_SUBITEMIMAGES         = 0x00000002             ;---
;~ Global Const $LVS_EX_CHECKBOXES            = 0x00000004             ;---
;~ Global Const $LVS_EX_TRACKSELECT           = 0x00000008             ;---
;~ Global Const $LVS_EX_HEADERDRAGDROP        = 0x00000010             ;---
;~ Global Const $LVS_EX_FULLROWSELECT         = 0x00000020             ;---
;~ Global Const $LVS_EX_ONECLICKACTIVATE      = 0x00000040             ;---
;~ Global Const $LVS_EX_TWOCLICKACTIVATE      = 0x00000080             ;---
;~ Global Const $LVS_EX_FLATSB                = 0x00000100             ;---             IE >= 0x0400
;~ Global Const $LVS_EX_REGIONAL              = 0x00000200             ;---             IE >= 0x0400
;~ Global Const $LVS_EX_INFOTIP               = 0x00000400             ;---             IE >= 0x0400
;~ Global Const $LVS_EX_UNDERLINEHOT          = 0x00000800             ;---             IE >= 0x0400
;~ Global Const $LVS_EX_UNDERLINECOLD         = 0x00001000             ;---             IE >= 0x0400
Global Const $LVS_EX_MULTIWORKAREAS        = 0x00002000             ;---             IE >= 0x0400
Global Const $LVS_EX_DOUBLEBUFFER          = 0x00010000             ;---

;==============================================================================================================
; Notifications from a ListView
;---------------Variable-------------------|------Value-------------|--Description--|--IE-Ver-------|-Unicode?-
Global Const $LVN_ITEMCHANGING             = ($LVN_FIRST-0)         ;---
Global Const $LVN_ITEMCHANGED              = ($LVN_FIRST-1)         ;---
Global Const $LVN_INSERTITEM               = ($LVN_FIRST-2)         ;---
Global Const $LVN_DELETEITEM               = ($LVN_FIRST-3)         ;---
Global Const $LVN_DELETEALLITEMS           = ($LVN_FIRST-4)         ;---
Global Const $LVN_BEGINLABELEDITA          = ($LVN_FIRST-5)         ;---                             NonUnicode
Global Const $LVN_ENDLABELEDITA            = ($LVN_FIRST-6)         ;---                             NonUnicode
Global Const $LVN_COLUMNCLICK              = ($LVN_FIRST-8)         ;---
Global Const $LVN_BEGINDRAG                = ($LVN_FIRST-9)         ;---
Global Const $LVN_BEGINRDRAG               = ($LVN_FIRST-11)        ;---
Global Const $LVN_ODCACHEHINT              = ($LVN_FIRST-13)        ;---             IE >= 0x0300
Global Const $LVN_ITEMACTIVATE             = ($LVN_FIRST-14)        ;---             IE >= 0x0300
Global Const $LVN_ODSTATECHANGED           = ($LVN_FIRST-15)        ;---             IE >= 0x0300
Global Const $LVN_HOTTRACK                 = ($LVN_FIRST-21)        ;---             IE >= 0x0400
Global Const $LVN_GETDISPINFOA             = ($LVN_FIRST-50)        ;---                             NonUnicode
Global Const $LVN_SETDISPINFOA             = ($LVN_FIRST-51)        ;---                             NonUnicode
Global Const $LVN_ODFINDITEMA              = ($LVN_FIRST-52)        ;---             IE >= 0x0300    NonUnicode
Global Const $LVN_KEYDOWN                  = ($LVN_FIRST-55)        ;---
Global Const $LVN_MARQUEEBEGIN             = ($LVN_FIRST-56)        ;---             IE >= 0x0400
Global Const $LVN_GETINFOTIPA              = ($LVN_FIRST-57)        ;---             IE >= 0x0400    NonUnicode
Global Const $LVN_GETINFOTIPW              = ($LVN_FIRST-58)        ;---             IE >= 0x0400    Unicode
Global Const $LVN_BEGINLABELEDITW          = ($LVN_FIRST-75)        ;---                             Unicode
Global Const $LVN_ENDLABELEDITW            = ($LVN_FIRST-76)        ;---                             Unicode
Global Const $LVN_GETDISPINFOW             = ($LVN_FIRST-77)        ;---                             Unicode
Global Const $LVN_SETDISPINFOW             = ($LVN_FIRST-78)        ;---                             Unicode
Global Const $LVN_ODFINDITEMW              = ($LVN_FIRST-79)        ;---            IE >= 0x0300     Unicode

;==============================================================================================================
; Messages to a ListView
;---------------Variable-------------------|------Value-------------|--Description--|--IE-Ver-------|-Unicode?-
;~ Global Const $LVM_GETBKCOLOR               = ($LVM_FIRST + 0)       ;---
;~ Global Const $LVM_SETBKCOLOR               = ($LVM_FIRST + 1)       ;---
;~ Global Const $LVM_GETIMAGELIST             = ($LVM_FIRST + 2)       ;---
Global Const $LVM_SETIMAGELIST             = ($LVM_FIRST + 3)       ;---
;~ Global Const $LVM_GETITEMCOUNT             = ($LVM_FIRST + 4)       ;---
;~ Global Const $LVM_GETITEMA                 = ($LVM_FIRST + 5)       ;---                             NonUnicode
Global Const $LVM_SETITEMA                 = ($LVM_FIRST + 6)       ;---                             NonUnicode
;~ Global Const $LVM_INSERTITEMA              = ($LVM_FIRST + 7)       ;---                             NonUnicode
;~ Global Const $LVM_DELETEITEM               = ($LVM_FIRST + 8)       ;---
;~ Global Const $LVM_DELETEALLITEMS           = ($LVM_FIRST + 9)       ;---
;~ Global Const $LVM_GETCALLBACKMASK          = ($LVM_FIRST + 10)      ;---
;~ Global Const $LVM_SETCALLBACKMASK          = ($LVM_FIRST + 11)      ;---
;~ Global Const $LVM_GETNEXTITEM              = ($LVM_FIRST + 12)      ;---
Global Const $LVM_FINDITEMA                = ($LVM_FIRST + 13)      ;---                             NonUnicode
Global Const $LVM_GETITEMRECT              = ($LVM_FIRST + 14)      ;---
;~ Global Const $LVM_SETITEMPOSITION          = ($LVM_FIRST + 15)      ;---
Global Const $LVM_GETITEMPOSITION          = ($LVM_FIRST + 16)      ;---
Global Const $LVM_GETSTRINGWIDTHA          = ($LVM_FIRST + 17)      ;---                             NonUnicode
Global Const $LVM_HITTEST                  = ($LVM_FIRST + 18)      ;---
;~ Global Const $LVM_ENSUREVISIBLE            = ($LVM_FIRST + 19)      ;---
;~ Global Const $LVM_SCROLL                   = ($LVM_FIRST + 20)      ;---
;~ Global Const $LVM_REDRAWITEMS              = ($LVM_FIRST + 21)      ;---
;~ Global Const $LVM_ARRANGE                  = ($LVM_FIRST + 22)      ;---
;~ Global Const $LVM_EDITLABELA               = ($LVM_FIRST + 23)      ;---                             NonUnicode
;~ Global Const $LVM_GETEDITCONTROL           = ($LVM_FIRST + 24)      ;---
Global Const $LVM_GETCOLUMNA               = ($LVM_FIRST + 25)      ;---                             NonUnicode
;~ Global Const $LVM_SETCOLUMNA               = ($LVM_FIRST + 26)      ;---                             NonUnicode
;~ Global Const $LVM_INSERTCOLUMNA            = ($LVM_FIRST + 27)      ;---                             NonUnicode
;~ Global Const $LVM_DELETECOLUMN             = ($LVM_FIRST + 28)      ;---
;~ Global Const $LVM_GETCOLUMNWIDTH           = ($LVM_FIRST + 29)      ;---
;~ Global Const $LVM_SETCOLUMNWIDTH           = ($LVM_FIRST + 30)      ;---
;~ Global Const $LVM_GETHEADER                = ($LVM_FIRST + 31)      ;---
Global Const $LVM_CREATEDRAGIMAGE          = ($LVM_FIRST + 33)      ;---
;~ Global Const $LVM_GETVIEWRECT              = ($LVM_FIRST + 34)      ;---
Global Const $LVM_GETTEXTCOLOR             = ($LVM_FIRST + 35)      ;---
;~ Global Const $LVM_SETTEXTCOLOR             = ($LVM_FIRST + 36)      ;---
Global Const $LVM_GETTEXTBKCOLOR           = ($LVM_FIRST + 37)      ;---
;~ Global Const $LVM_SETTEXTBKCOLOR           = ($LVM_FIRST + 38)      ;---
;~ Global Const $LVM_GETTOPINDEX              = ($LVM_FIRST + 39)      ;---
;~ Global Const $LVM_GETCOUNTPERPAGE          = ($LVM_FIRST + 40)      ;---
Global Const $LVM_GETORIGIN                = ($LVM_FIRST + 41)      ;---
;~ Global Const $LVM_UPDATE                   = ($LVM_FIRST + 42)      ;---
;~ Global Const $LVM_SETITEMSTATE             = ($LVM_FIRST + 43)      ;---
;~ Global Const $LVM_GETITEMSTATE             = ($LVM_FIRST + 44)      ;---
;~ Global Const $LVM_GETITEMTEXTA             = ($LVM_FIRST + 45)      ;---                             NonUnicode
;~ Global Const $LVM_SETITEMTEXTA             = ($LVM_FIRST + 46)      ;---                             NonUnicode
;~ Global Const $LVM_SETITEMCOUNT             = ($LVM_FIRST + 47)      ;---
Global Const $LVM_SORTITEMS                = ($LVM_FIRST + 48)      ;---
Global Const $LVM_SETITEMPOSITION32        = ($LVM_FIRST + 49)      ;---
;~ Global Const $LVM_GETSELECTEDCOUNT         = ($LVM_FIRST + 50)      ;---
Global Const $LVM_GETITEMSPACING           = ($LVM_FIRST + 51)      ;---
Global Const $LVM_GETISEARCHSTRINGA        = ($LVM_FIRST + 52)      ;---
;~ Global Const $LVM_SETICONSPACING           = ($LVM_FIRST + 53)      ;---
;~ Global Const $LVM_SETEXTENDEDLISTVIEWSTYLE = ($LVM_FIRST + 54)      ;optional wParam == mask
;~ Global Const $LVM_GETEXTENDEDLISTVIEWSTYLE = ($LVM_FIRST + 55)      ;---
;~ Global Const $LVM_GETSUBITEMRECT           = ($LVM_FIRST + 56)      ;---
Global Const $LVM_SUBITEMHITTEST           = ($LVM_FIRST + 57)      ;---
;~ Global Const $LVM_SETCOLUMNORDERARRAY      = ($LVM_FIRST + 58)      ;---
;~ Global Const $LVM_GETCOLUMNORDERARRAY      = ($LVM_FIRST + 59)      ;---
;~ Global Const $LVM_SETHOTITEM               = ($LVM_FIRST + 60)      ;---
;~ Global Const $LVM_GETHOTITEM               = ($LVM_FIRST + 61)      ;---
Global Const $LVM_SETHOTCURSOR             = ($LVM_FIRST + 62)      ;---
;~ Global Const $LVM_GETHOTCURSOR             = ($LVM_FIRST + 63)      ;---
Global Const $LVM_APPROXIMATEVIEWRECT      = ($LVM_FIRST + 64)      ;---
Global Const $LVM_SETWORKAREAS             = ($LVM_FIRST + 65)      ;---
Global Const $LVM_GETSELECTIONMARK         = ($LVM_FIRST + 66)      ;---
Global Const $LVM_SETSELECTIONMARK         = ($LVM_FIRST + 67)      ;---
Global Const $LVM_SETBKIMAGEA              = ($LVM_FIRST + 68)      ;---
Global Const $LVM_GETBKIMAGEA              = ($LVM_FIRST + 69)      ;---
Global Const $LVM_GETWORKAREAS             = ($LVM_FIRST + 70)      ;---
;~ Global Const $LVM_SETHOVERTIME             = ($LVM_FIRST + 71)      ;---
;~ Global Const $LVM_GETHOVERTIME             = ($LVM_FIRST + 72)      ;---
Global Const $LVM_GETNUMBEROFWORKAREAS     = ($LVM_FIRST + 73)      ;---
Global Const $LVM_SETTOOLTIPS              = ($LVM_FIRST + 74)      ;---
Global Const $LVM_GETITEMW                 = ($LVM_FIRST + 75)      ;---                              Unicode
Global Const $LVM_SETITEMW                 = ($LVM_FIRST + 76)      ;---                              Unicode
Global Const $LVM_INSERTITEMW              = ($LVM_FIRST + 77)      ;---                              Unicode
Global Const $LVM_GETTOOLTIPS              = ($LVM_FIRST + 78)      ;---
Global Const $LVM_FINDITEMW                = ($LVM_FIRST + 83)      ;---                              Unicode
Global Const $LVM_GETSTRINGWIDTHW          = ($LVM_FIRST + 87)      ;---                              Unicode
Global Const $LVM_GETCOLUMNW               = ($LVM_FIRST + 95)      ;---                              Unicode
Global Const $LVM_SETCOLUMNW               = ($LVM_FIRST + 96)      ;---                              Unicode
Global Const $LVM_INSERTCOLUMNW            = ($LVM_FIRST + 97)      ;---                              Unicode
Global Const $LVM_GETITEMTEXTW             = ($LVM_FIRST + 115)     ;---                              Unicode
Global Const $LVM_SETITEMTEXTW             = ($LVM_FIRST + 116)     ;---                              Unicode
Global Const $LVM_GETISEARCHSTRINGW        = ($LVM_FIRST + 117)     ;---                              Unicode
Global Const $LVM_EDITLABELW               = ($LVM_FIRST + 118)     ;---                              Unicode
Global Const $LVM_SETBKIMAGEW              = ($LVM_FIRST + 138)     ;---                              Unicode
Global Const $LVM_GETBKIMAGEW              = ($LVM_FIRST + 139)     ;---                              Unicode
Global Const $LVM_SETINFOTIP               = ($LVM_FIRST + 173)     ;---
;~ Global Const $LVM_GETUNICODEFORMAT         = $CCM_GETUNICODEFORMAT  ;---                             NonUnicode
;~ Global Const $LVM_SETUNICODEFORMAT         = $CCM_SETUNICODEFORMAT  ;---                             NonUnicode
;~ Global Const $LVM_EDITLABEL                = $LVM_EDITLABELA        ;---                             NonUnicode
;~ Global Const $LVM_GETBKIMAGE               = $LVM_GETBKIMAGEA       ;---                             NonUnicode
;~ Global Const $LVM_GETISEARCHSTRING         = $LVM_GETISEARCHSTRINGA ;---                             NonUnicode
;~ Global Const $LVM_GETITEM                  = $LVM_GETITEMA          ;---                             NonUnicode
;~ Global Const $LVM_INSERTITEM               = $LVM_INSERTITEMA       ;---                             NonUnicode
;~ Global Const $LVM_SETBKIMAGE               = $LVM_SETBKIMAGEA       ;---                             NonUnicode
;~ Global Const $LVM_SETITEM                  = $LVM_SETITEMA          ;---                             NonUnicode
;~ Global Const $LVM_EDITLABEL                = $LVM_EDITLABELW        ;---                              Unicode
Global Const $LVM_GETBKIMAGE               = $LVM_GETBKIMAGEW       ;---                              Unicode
Global Const $LVM_GETISEARCHSTRING         = $LVM_GETISEARCHSTRINGW ;---                              Unicode
Global Const $LVM_GETITEM                  = $LVM_GETITEMW          ;---                              Unicode
Global Const $LVM_INSERTITEM               = $LVM_INSERTITEMW       ;---                              Unicode
Global Const $LVM_SETBKIMAGE               = $LVM_SETBKIMAGEW       ;---                              Unicode
Global Const $LVM_SETITEM                  = $LVM_SETITEMW          ;---                              Unicode

Func _ListView_Structs($sStructType)
#cs
Windows Datatype = DllCall Type
	BOOL      = "int"
	COLORREF  = "int"
	DWORD     = "int"
	HANDLE    = "ptr"
	HDC       = "ptr"
	HFILE     = "int"
	HFONT     = "ptr"
	HICON     = "ptr"
	HINSTANCE = "ptr"
	HKEY      = "ptr"
	HMENU     = "ptr"
	HMODILE   = "ptr"
	HWND      = "hwnd"
	INT       = "int"
	LONG      = "long"
	LPARAM    = "long"
	LPCTSTR   = "str" ("wstr" if a UNICODE function)
	LPINT     = "int_ptr"
	LPLONG    = "long_ptr"
	UINT      = "int"
	ULONG     = "long"
	WPARAM    = "int"
#ce
	Local $__NMHDR = "int;int;int" ;hwndFrom, idFrom, code
		;NMHDR = http://windowssdk.msdn.microsoft.com/en-us/library/ms672586.aspx
	Local $__POINT = "int;int" ;x, y
		;POINT = http://windowssdk.msdn.microsoft.com/en-us/library/ms536119.aspx
	Local $__NMCUSTOMDRAW = $__NMHDR & ";int;int;ptr;int;int_ptr;uint;int" ;hdr, dwDrawStage, hdc, rc, dwItemSpec, uItemState, lItemlParam
		;NMCUSTOMDRAW = http://windowssdk.msdn.microsoft.com/en-us/library/ms672175.aspx
	Local $__LVFINDINFO = "uint;ptr;int;" & $__POINT & ";uint" ;flags, psz, lParam, pt, vkDirection
		;LVFINDINFO = http://windowssdk.msdn.microsoft.com/en-us/library/ms670564.aspx
	Select
		Case $sStructType = "NMHDR"          ;http://windowssdk.msdn.microsoft.com/en-us/library/ms672586.aspx
			Return ($__NMHDR)
			
		Case $sStructType = "LVBKIMAGE"      ;http://windowssdk.msdn.microsoft.com/en-us/library/ms670562.aspx
			Return ("uint;int;ptr;uint;int;int")
			
		Case $sStructType = "LVCOLUMN"       ;http://windowssdk.msdn.microsoft.com/en-us/library/ms670563.aspx
			Return ("uint;int;int;ptr;int;int;int;int")
			
		Case $sStructType = "LVFINDINFO"     ;http://windowssdk.msdn.microsoft.com/en-us/library/ms670564.aspx
			Return ($__LVFINDINFO)
			
		Case $sStructType = "LVGROUP"        ;http://windowssdk.msdn.microsoft.com/en-us/library/ms670573.aspx
			Return ("uint;uint;ptr;int;ptr;int;int;uint;uint;uint;ptr;uint;" & _
					"ptr;uint;ptr;uint;ptr;uint;int;" & _
					"int;int;uint;ptr;uint")
			
		Case $sStructType = "LVGROUPMETRICS" ;http://windowssdk.msdn.microsoft.com/en-us/library/ms670565.aspx
			Return ("uint;uint;uint;uint;uint;uint;int;int;int;int;int;int")
			
		Case $sStructType = "LVHITTESTINFO"  ;http://windowssdk.msdn.microsoft.com/en-us/library/ms670566.aspx
			Return ("ptr;uint;int;int;int")
			
;~ 		Case $sStructType = "LVINSERTGROUPSORTED"
;~ 			;All data is application defined, including a pointer to
;~ 			;an application defined function -- Can Not Use In AutoIt
			
		Case $sStructType = "LVINSERTMARK"   ;http://windowssdk.msdn.microsoft.com/en-us/library/ms670568.aspx
			Return ("uint;int;int;int")
			
		Case $sStructType = "LVITEM"         ;http://windowssdk.msdn.microsoft.com/en-us/library/ms670569.aspx
			Return ("uint;int;int;uint;uint;ptr;int;int;int;int;uint;ptr")
			
		Case $sStructType = "LVSETINFOTIP"   ;http://windowssdk.msdn.microsoft.com/en-us/library/ms670570.aspx
			Return ("uint;int;int;int;int")
			
		Case $sStructType = "LVTILEINFO"     ;http://windowssdk.msdn.microsoft.com/en-us/library/ms670571.aspx
			Return ("uint;int;uint;ptr")
			
		Case $sStructType = "LVTILEVIEWINFO" ;http://windowssdk.msdn.microsoft.com/en-us/library/ms670572.aspx
			Return ("uint;int;int;int;int")
			
		Case $sStructType = "NMITEMACTIVATE" ;http://windowssdk.msdn.microsoft.com/en-us/library/ms670574.aspx
			Return ($__NMHDR & ";int;int;uint;uint;uint;ptr;int;uint")
			
		Case $sStructType = "NMLISTVIEW"     ;http://windowssdk.msdn.microsoft.com/en-us/library/ms670575.aspx
			Return ($__NMHDR & ";int;int;uint;uint;uint;ptr;int")
			
		Case $sStructType = "NMLVCACHEHINT"  ;http://windowssdk.msdn.microsoft.com/en-us/library/ms670577.aspx
			Return ($__NMHDR & ";int;int")
			
		Case $sStructType = "NMLVCUSTOMDRAW" ;http://windowssdk.msdn.microsoft.com/en-us/library/ms670578.aspx
			Return ($__NMCUSTOMDRAW & ";int;int;int;int;int;int;int;int;int;int;uint")
			
		Case $sStructType = "NMLVDISPINFO"   ;http://windowssdk.msdn.microsoft.com/en-us/library/ms670579.aspx
			Return ($__NMHDR & ";" & _ListView_Structs("LVITEM"))
			
		Case $sStructType = "NMLVFINDITEM"    ;http://windowssdk.msdn.microsoft.com/en-us/library/ms670581.aspx
			Return ($__NMHDR & ";int;" & $__LVFINDINFO)
			
		Case $sStructType = "NMLVGETINFOTIP"  ;http://windowssdk.msdn.microsoft.com/en-us/library/ms670582.aspx
			Return ($__NMHDR & ";int;ptr;int;int;int;int")
			
		Case $sStructType = "NMVKEYDOWN"      ;http://windowssdk.msdn.microsoft.com/en-us/library/ms670583.aspx
			Return ($__NMHDR & ";int;uint")
			
		Case $sStructType = "NMVODSTATECHANGE";http://windowssdk.msdn.microsoft.com/en-us/library/ms670585.aspx
			Return ($__NMHDR & ";int;int;uint;uint")
			
		Case $sStructType = "NMLVSCROLL"      ;http://windowssdk.msdn.microsoft.com/en-us/library/ms670586.aspx
			Return ($__NMHDR & ";int;int")
			
;~ 		Case $sStructType = "NMLVASYNCDRAWN" ;http://windowssdk.msdn.microsoft.com/en-us/library/ms670576.aspx
;~ 			;Windows Vista only
			
;~ 		Case $sStructType = "NMLVEMPTYMARKUP" ;http://windowssdk.msdn.microsoft.com/en-us/library/ms670580.aspx
;~ 			;Windows Vista only
			
;~ 		Case $sStructType = "NMVLINK"         ;http://windowssdk.msdn.microsoft.com/en-us/library/ms670584.aspx
;~ 			;Windows Vista only
			
	EndSelect
EndFunc
#endregion End Global Constant Declarations


Func _GUICtrlListViewSetItemTooltip($h_listview, $i_index, $s_infotip_text)
	;;;Placeholder Function
EndFunc


Func WM_Notify_Events($hWndGUI, $MsgID, $wParam, $lParam)
$strut = DllStructCreate("char[4096]")
DllStructSetData($strut, 1, "Nothing to see here.")
    #forceref $hWndGUI, $MsgID, $wParam
    Local $event
	$NMLVGETINFOTIP = _ListView_Structs("NMLVGETINFOTIP")
	$data = DllStructCreate($NMLVGETINFOTIP, $lParam)
	$event = DllStructGetData($data, 3)
    Select
		Case $wParam = $listview
			Select
				Case $event = $LVN_GETINFOTIPW ;Unicode notification
					$tempString = "Item #"&DllStructGetData($data,7)&":"&@CRLF&"Now has a custom tooltip."
					
					; Convert and store the filename as a wide char string
					$nBuffersize    = DllCall("kernel32.dll", "int", "MultiByteToWideChar", "int", 0, "int", 0x00000001, "str", $tempString, "int", -1, "ptr", 0, "int", 0)
					$stString       = DLLStructCreate("byte[" & 2 * $nBuffersize[0] & "]", DllStructGetData($data,5))
					DllCall("kernel32.dll", "int", "MultiByteToWideChar", "int", 0, "int", 0x00000001, "str", $tempString, "int", -1, "ptr", DllStructGetPtr($stString), "int", $nBuffersize[0])
					
;~ 					$tempToolTip = DllStructCreate("byte[" & 2 * $nBuffersize[0] & "]")
;~ 					DllStructSetData($tempToolTip, 1, DllStructGetData($stString, 1))
					GUICtrlSetData($text,   "GUIHWnd" & @TAB & @TAB & ":" & $hwndGUI & @CRLF & _
											"MsgID" & @TAB & @TAB &  ":" & $MsgID & @CRLF & _
											"wParam" & @TAB  & @TAB & ":" & $WParam & @CRLF & _
											"lParam" & @TAB  & @TAB & ":" & @CRLF & _
											"     dwFlags" & @TAB & ": " & DllStructGetData($data,4) & @CRLF & _
											"     pszText" & @TAB & ": " & DllStructGetData($data,5) & @CRLF & _
											"  cchTextMax" & @TAB & ": " & DllStructGetData($data,6) & @CRLF & _
											"       iItem" & @TAB & ": " & DllStructGetData($data,7) & @CRLF & _
											"    iSubItem" & @TAB & ": " & DllStructGetData($data,8) & @CRLF & _
											"      lparam" & @TAB & ": " & DllStructGetData($data,9) & @CRLF & _
											"-----------------------------" & @CRLF & _
											"Code" & @TAB & @TAB & ":" & 	DllStructGetData($data,3) & @CRLF & _
											"CtrlID" & @TAB & @TAB & ":" & 	DllStructGetData($data,2) & @CRLF & _
											"CtrlHWnd" & @TAB & ":" & 		DllStructGetData($data,1))
			EndSelect
    EndSelect
    $tagNMHDR = 0
	$data = 0
    $event = 0
    $lParam = 0
Return $GUI_RUNDEFMSG
EndFunc ;==>WM_Notify_Events

; == GUI generated with Koda ==
$Form1 = GUICreate("AForm1", 622, 441, 192, 125)
$listview = GUICtrlCreateListView("Filename|Size|-", 0, 0, 622, 100, -1, BitOR($LVS_EX_INFOTIP,$LVS_EX_FULLROWSELECT))
	_GUICtrlListViewSetColumnWidth($listview,0,200)
;~ GUICtrlSetTip($listview, "There is no Tooltip set yet.")
;-------------------------------------------------------------------------------------------------------------------------


;~ Global $tooltip = _GuiCtrlToolTipCreate($listview)
;~ _GuiCtrlToolTipStruct($tooltip[1], "cbSize", DllStructGetSize($tooltip[1]))
;~ _GuiCtrlToolTipStruct($tooltip[1], "uFlags", BitOR(0x0020, 0x0080))
;~ _GuiCtrlToolTipStruct($tooltip[1], "hwnd", $tooltip[0])
;~ _GuiCtrlToolTipStruct($tooltip[1], "hinst", $tooltip[0])
;~ _GuiCtrlToolTipStruct($tooltip[1], "uId", 0)
;~ $ToolTipText = DllStructCreate("char[1024]")
;~ DllStructSetData($ToolTipText, 1, "Nothing is Defined Yet.")
;~ _GuiCtrlToolTipStruct($tooltip[1], "lpszText", "Nothing is Defined Yet")
;~ Local $__rect[4] = [0,0,0,0]
;~ _GuiCtrlToolTipStruct($tooltip[1], "rect", $__rect)
;~ _GuiCtrlToolTipStruct($tooltip[1], "lparam", 0)
;~ 	DllCall("user32.dll", "int", "TIM_ADDTOOL", "int", 0, "ptr", DllStructGetPtr($tooltip[0]))

;-------------------------------------------------------------------------------------------------------------------------
;~ Local $LBToolTipPtr = DllCall("user32.dll", "int", "ListView_GetToolTips", "hwnd", GUICtrlGetHandle($listview), "hwnd", GUICtrlGetHandle($listview))
;~ Local $LBToolTipPtr = DllCall("user32.dll", "int", "ListView_GetToolTips", "hwnd", $Form1, "hwnd", GUICtrlGetHandle($listview))
;~ Local $LBToolTipPtr = GUICtrlSendMsg(GUICtrlGetHandle($listview), "ListView_GetToolTips", 0, 0)
;~ Local $LBToolTipPtr = DllCall("user32.dll", "hwnd", "SendMessage", "hwnd", GUICtrlGetHandle($listview), "int", 0, "int", 0)
;~ Global $LPTOOLINFO = $tooltip[1];DllStructCreate("uint;int;ptr;ptr;int[4];int;ptr;int", DllStructGetPtr($tooltip[1]))

$text  = GUICtrlCreateEdit("", 0, 100, 311, 341, BitOR($ES_AUTOVSCROLL,$ES_AUTOHSCROLL,$ES_READONLY))
$text2 = GUICtrlCreateListView("Var|Value", 311, 100, 311, 341, -1, BitOR($LVS_EX_DOUBLEBUFFER,$LVS_EX_FULLROWSELECT))
	_GUICtrlListViewSetColumnWidth($text2,0,75)
GUICtrlSetFont($text, 10, 400, -1, "Courier New")
For $i = 0 To 5 Step 1
GUICtrlCreateListViewItem($i & ":     C:\LongestFileName|601.043|KB",$listview)
Next
GUISetState(@SW_SHOW)
;ControlGetHandle("AForm1","","SysListView32")
;WinGetClassList("AForm1")
;SysListView32
;SysHeader32
;~ DllStructSetData($LPTOOLINFO,1, DllStructGetSize($LPTOOLINFO)*3) ;cbSize
;~ DllStructSetData($LPTOOLINFO,2, ) ;uFlags
;~ DllStructSetData($LPTOOLINFO,3, GUICtrlGetHandle($listview)) ;hwnd
;~ DllStructSetData($LPTOOLINFO,4, $listview) ;uId
;~ DllStructSetData($LPTOOLINFO,5) ;rect
;~ DllStructSetData($LPTOOLINFO,6) ;hinst
;~ DllStructSetData($LPTOOLINFO,7, ) ;lpszText
;~ DllStructSetData($LPTOOLINFO,8, 0) ;lParam
;~ 	$d1 = GUICtrlCreateListViewItem("1) cbSize|" & DllStructGetData($LPTOOLINFO,1), $text2)
;~ 	$d2 = GUICtrlCreateListViewItem("2) uFlags|" & DllStructGetData($LPTOOLINFO,2), $text2)
;~ 	$d3 = GUICtrlCreateListViewItem("3) hwnd|" & DllStructGetData($LPTOOLINFO,3), $text2)
;~ 	$d4 = GUICtrlCreateListViewItem("4) uId|" & DllStructGetData($LPTOOLINFO,4), $text2)
;~ 	$d5 = GUICtrlCreateListViewItem("5) rect|" & DllStructGetData($LPTOOLINFO,5), $text2)
;~ 	$d6 = GUICtrlCreateListViewItem("6) hinst|" & DllStructGetData($LPTOOLINFO,6), $text2)
;~ 	$d7 = GUICtrlCreateListViewItem("7) lpszText|" & DllStructGetData($LPTOOLINFO,7), $text2)
;~ 	$d8 = GUICtrlCreateListViewItem("8) lParam|" & DllStructGetData($LPTOOLINFO,8), $text2)
GUIRegisterMsg($WM_NOTIFY, "WM_Notify_Events")
;~ AdlibEnable("adlib", 100)

While 1
	$msg = GuiGetMsg()
	Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case Else
		;;;;;;;
	EndSelect
WEnd
Exit
;~ Func adlib()
;~ 	DllCall("user32.dll", "int", "SendMessage", "hwnd", GUICtrlGetHandle($listview), "uint", (1024 + 53), "int", 0, "int", DllStructGetPtr($LPTOOLINFO))
;~ 	DllCall("user32.dll", "int", "SendMessage", "hwnd", GUICtrlGetHandle($listview), "uint", (1024 + 14), "int", $listview, "int", DllStructGetPtr($LPTOOLINFO))
;~ 	GUICtrlSetData ($d1, "1) cbSize|" & DllStructGetData($LPTOOLINFO,1))
;~ 	GUICtrlSetData ($d2, "2) uFlags|" & DllStructGetData($LPTOOLINFO,2))
;~ 	GUICtrlSetData ($d3, "3) hwnd|" & DllStructGetData($LPTOOLINFO,3))
;~ 	GUICtrlSetData ($d4, "4) uId|" & DllStructGetData($LPTOOLINFO,4))
;~ 	GUICtrlSetData ($d5, "5) rect|" & DllStructGetData($LPTOOLINFO,5))
;~ 	GUICtrlSetData ($d6, "6) hinst|" & DllStructGetData($LPTOOLINFO,6))
;~ 	GUICtrlSetData ($d7, "7) lpszText|" & DllStructGetData($LPTOOLINFO,7))
;~ 	GUICtrlSetData ($d8, "8) lParam|" & DllStructGetData($LPTOOLINFO,8))
;~ EndFunc

Func _GuiCtrlToolTipCreate($h_ParentCtrl)
#cs
HWND CreateWindowEx(          DWORD dwExStyle,
    LPCTSTR lpClassName,
    LPCTSTR lpWindowName,
    DWORD dwStyle,
    int x,
    int y,
    int nWidth,
    int nHeight,
    HWND hWndParent,
    HMENU hMenu,
    HINSTANCE hInstance,
    LPVOID lpParam
);
-------------------------------------------------
hwndTT = CreateWindowEx(WS_EX_TOPMOST,
        TOOLTIPS_CLASS,
        NULL,
        WS_POPUP | TTS_NOPREFIX | TTS_ALWAYSTIP,		
        CW_USEDEFAULT,
        CW_USEDEFAULT,
        CW_USEDEFAULT,
        CW_USEDEFAULT,
        hwnd,
        NULL,
        ghThisInstance,
        NULL
        );
		
WS_EX_TOPMOST = 0x00000008
CW_USEDEFAULT = -2147483648
WS_POPUP      = 0x80000000
TTS_NOPREFIX  = 0x02
TTS_ALWAYSTIP = 0x01
ghThisInstance = void/NULL
#ce

	If Not IsHWnd($h_ParentCtrl) Then $h_ParentCtrl = GUICtrlGetHandle($h_ParentCtrl)
	Local $h_ToolTip = DllCall("user32.dll", "hwnd","CreateWindowEx", _
						"long", 0x08, _                           ;EX Styles    WS_EX_TOPMOST
						"str", "tooltips_class32", _              ;ClassName
						"str", "", _                              ;WindowName
						"long", BitOR(0x80000000, 0x02, 0x01), _  ;Style        WS_POPUP, TTS_NOPREFIX, TTS_ALWAYSTIP
						"long", (-2147483648), _                  ;x            CW_USEDEFAULT
						"long", (-2147483648), _                  ;y            CW_USEDEFAULT
						"long", (-2147483648), _                  ;Width        CW_USEDEFAULT
						"long", (-2147483648), _                  ;Height       CW_USEDEFAULT
						"hwnd", $h_ParentCtrl, _                  ;hWnd Parent
						"long", 0, _                              ;hMenu
						"hwnd", $h_ParentCtrl, _                  ;hInstance
						"long", 0)                                ;lParam
	Local $strTOOLINFO = DllStructCreate("uint;int;ptr;ptr;int[4];int;ptr;int")
;~ 	SendMessage(hwndTT, TTM_ADDTOOL, 0, (LPARAM) (LPTOOLINFO) &ti);
#cs
 ti.cbSize = sizeof(ti);
 ti.uFlags = TTF_TRACK | TTF_ABSOLUTE;
 ti.hwnd  = NULL;
 ti.hinst = NULL;
 ti.uId  = 0;
 ti.lpszText = (LPSTR)vParams[0].szValue();  
 ti.rect.left = ti.rect.top = ti.rect.right = ti.rect.bottom = 0;
 
TTF_CENTERTIP   = 0x0002
TTF_RTLREADING  = 0x0004
TTF_SUBCLASS    = 0x0010
TTF_TRACK       = 0x0020
TTF_ABSOLUTE    = 0x0080
TTF_TRANSPARENT = 0x0100
TTF_DI_SETITEM  = 0x8000       // valid only on the TTN_NEEDTEXT callback
#ce

	Local $a_Return[2] = [$h_ToolTip, $strTOOLINFO]
	Return $a_Return
EndFunc

Func _GuiCtrlToolTipStruct(ByRef $strTOOLINFO, $s_Element, $_Value = 0)
#cs
typedef struct tagTOOLINFO{
    UINT      cbSize; 
    UINT      uFlags; 
    HWND      hwnd; 
    UINT_PTR  uId; 
    RECT      rect; 
    HINSTANCE hinst; 
    LPTSTR    lpszText; 
    LPARAM    lParam;
} TOOLINFO, NEAR *PTOOLINFO, *LPTOOLINFO;
#ce
	If $s_Element == "cbSize"   Then DllStructSetData($strTOOLINFO, 1, $_Value)
	If $s_Element == "uFlags"   Then DllStructSetData($strTOOLINFO, 2, $_Value)
	If $s_Element == "hwnd"     Then DllStructSetData($strTOOLINFO, 3, $_Value)
	If $s_Element == "uId"      Then DllStructSetData($strTOOLINFO, 4, $_Value)
	If $s_Element == "rect"     Then
		;Get Struct Data for RECT structure
;~ 		Local $__rect        = DllStructGetData($strTOOLINFO, 5)
		Local $__rect_left   = DllStructGetData($strTOOLINFO, 5, 1)
		Local $__rect_top    = DllStructGetData($strTOOLINFO, 5, 2)
		Local $__rect_right  = DllStructGetData($strTOOLINFO, 5, 3)
		Local $__rect_bottom = DllStructGetData($strTOOLINFO, 5, 4)
		;Update with new values
		If IsArray($_Value) Then
			If $_Value[0] <> (0 Or "") Then $__rect_left   = $_Value[0]
			If $_Value[1] <> (0 Or "") Then $__rect_top    = $_Value[1]
			If $_Value[2] <> (0 Or "") Then $__rect_right  = $_Value[2]
			If $_Value[3] <> (0 Or "") Then $__rect_bottom = $_Value[3]
		EndIf
		;Set the new Values	
		DllStructSetData($strTOOLINFO, 5, $__rect_left,   1)
		DllStructSetData($strTOOLINFO, 5, $__rect_top,    2)
		DllStructSetData($strTOOLINFO, 5, $__rect_right,  3)
		DllStructSetData($strTOOLINFO, 5, $__rect_bottom, 4)
	EndIf
	If $s_Element == "hinst"    Then DllStructSetData($strTOOLINFO, 6, $_Value)
	If $s_Element == "lpszText" Then DllStructSetData($strTOOLINFO, 7, $_Value)
	If $s_Element == "lParam"   Then DllStructSetData($strTOOLINFO, 8, $_Value)
;~ 	Return DllStructSetData($strTOOLINFO, $s_Element, $_Value, $i_Index)
EndFunc


	
	
	
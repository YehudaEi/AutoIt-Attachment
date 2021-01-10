#include-once
Opt("MustDeclareVars", 1)


;;

Global Const $RICHEDIT_CLASS10A = "RICHEDIT"
Global Const $RICHEDIT_CLASS = $RICHEDIT_CLASS10A
Global Const $RICHEDIT_CLASSA = "RichEdit20A"
Global Const $RICHEDIT_CLASSW = "RichEdit20W"

Global Const $ICC_STANDARD_CLASSES = 0x4000

Global Const $ST_DEFAULT = 0
Global Const $ST_KEEPUNDO = 1
Global Const $ST_SELECTION = 2

; pitch and family
;~ If Not IsDeclared("DEFAULT_PITCH") Then Global Const $DEFAULT_PITCH	= 0
Global Const $FIXED_PITCH = 1
Global Const $VARIABLE_PITCH = 2
Global Const $FF_DECORATIVE = 80

;~ If Not IsDeclared("FF_DONTCARE") Then Global Const $FF_DONTCARE		= 0
Global Const $FF_ROMAN = 16
Global Const $FF_SWISS = 32
Global Const $FF_MODERN = 48
Global Const $FF_SCRIPT = 64

#cs
Global Const $FW_DONTCARE = 0
Global Const $FW_THIN = 100
Global Const $FW_EXTRALIGHT = 200
Global Const $FW_ULTRALIGHT = 200
Global Const $FW_LIGHT = 300
Global Const $FW_NORMAL = 400
Global Const $FW_REGULAR = 400
Global Const $FW_MEDIUM = 500
Global Const $FW_SEMIBOLD = 600
Global Const $FW_DEMIBOLD = 600
Global Const $FW_BOLD = 700
Global Const $FW_EXTRABOLD = 800
Global Const $FW_ULTRABOLD = 800
Global Const $FW_HEAVY = 900
Global Const $FW_BLACK = 900
#ce

; char sets
Global Const $ANSI_CHARSET = 0
Global Const $DEFAULT_CHARSET = 1
Global Const $SYMBOL_CHARSET = 2
Global Const $MAC_CHARSET = 77
Global Const $SHIFTJIS_CHARSET = 128
Global Const $HANGEUL_CHARSET = 129
Global Const $GB2312_CHARSET = 134
Global Const $CHINESEBIG5_CHARSET = 136
Global Const $GREEK_CHARSET = 161
Global Const $TURKISH_CHARSET = 162
Global Const $VIETNAMESE_CHARSET = 163
Global Const $BALTIC_CHARSET = 186
Global Const $RUSSIAN_CHARSET = 204
Global Const $OEM_CHARSET = 255

#cs
Global Const $CFU_UNDERLINENONE = 0
Global Const $CFU_UNDERLINE = 1
Global Const $CFU_UNDERLINEWORD = 2
Global Const $CFU_UNDERLINEDOUBLE = 3
Global Const $CFU_UNDERLINEDOTTED = 4
#ce
; code pages
Global Const $CP_ACP = 0 ; use system default
Global Const $CP_37 = 37
Global Const $CP_273 = 273
Global Const $CP_277 = 277
Global Const $CP_278 = 278
Global Const $CP_280 = 280
Global Const $CP_284 = 284
Global Const $CP_285 = 285
Global Const $CP_290 = 290
Global Const $CP_297 = 297
Global Const $CP_423 = 423
Global Const $CP_500 = 500
Global Const $CP_875 = 875
Global Const $CP_930 = 930
Global Const $CP_931 = 931
Global Const $CP_932 = 932
Global Const $CP_933 = 933
Global Const $CP_935 = 935
Global Const $CP_936 = 936
Global Const $CP_937 = 937
Global Const $CP_939 = 939
Global Const $CP_949 = 949
Global Const $CP_950 = 950
Global Const $CP_1027 = 1027
Global Const $CP_5026 = 5026
Global Const $CP_5035 = 5035
#cs
Global Const $CFM_ALLCAPS = 0x80
Global Const $CFM_ANIMATION = 0x40000
Global Const $CFM_BACKCOLOR = 0x4000000
Global Const $CFM_BOLD = 0x1
Global Const $CFM_CHARSET = 0x8000000
Global Const $CFM_COLOR = 0x40000000
Global Const $CFM_DISABLED = 0x2000
Global Const $CFM_EMBOSS = 0x800
Global Const $CFM_FACE = 0x20000000
Global Const $CFM_HIDDEN = 0x100
Global Const $CFM_IMPRINT = 0x1000
Global Const $CFM_ITALIC = 0x2
Global Const $CFM_KERNING = 0x100000
Global Const $CFM_LCID = 0x2000000
Global Const $CFM_LINK = 0x20
Global Const $CFM_OFFSET = 0x10000000
Global Const $CFM_OUTLINE = 0x200
Global Const $CFM_PROTECTED = 0x10
Global Const $CFM_REVAUTHOR = 0x8000
Global Const $CFM_REVISED = 0x4000
Global Const $CFM_SHADOW = 0x400
Global Const $CFM_SIZE = 0x80000000
Global Const $CFM_SMALLCAPS = 0x40
Global Const $CFM_SPACING = 0x200000
Global Const $CFM_STRIKEOUT = 0x8
Global Const $CFM_STYLE = 0x80000
Global Const $CFM_SUBSCRIPT = BitOR(0x10000, 0x20000)
Global Const $CFM_SUPERSCRIPT = $CFM_SUBSCRIPT
Global Const $CFM_UNDERLINE = 0x4
Global Const $CFM_UNDERLINETYPE = 0x800000
Global Const $CFM_WEIGHT = 0x400000

Global Const $CFE_ALLCAPS = $CFM_ALLCAPS
Global Const $CFE_AUTOBACKCOLOR = $CFM_BACKCOLOR
Global Const $CFE_AUTOCOLOR = 0x40000000
Global Const $CFE_BOLD = 0x1
Global Const $CFE_DISABLED = $CFM_DISABLED
Global Const $CFE_EMBOSS = $CFM_EMBOSS
Global Const $CFE_HIDDEN = $CFM_HIDDEN
Global Const $CFE_IMPRINT = $CFM_IMPRINT
Global Const $CFE_ITALIC = 0x2
Global Const $CFE_LINK = 0x20
Global Const $CFE_OUTLINE = $CFM_OUTLINE
Global Const $CFE_PROTECTED = 0x10
Global Const $CFE_REVISED = $CFM_REVISED
Global Const $CFE_SHADOW = $CFM_SHADOW
Global Const $CFE_SMALLCAPS = $CFM_SMALLCAPS
Global Const $CFE_STRIKEOUT = 0x8
Global Const $CFE_SUBSCRIPT = 0x10000
Global Const $CFE_SUPERSCRIPT = 0x20000
Global Const $CFE_UNDERLINE = 0x4

;~ Global Const $CFM_EFFECTS = BitOR($CFM_BOLD, $CFM_ITALIC, $CFM_UNDERLINE, $CFM_COLOR, $CFM_STRIKEOUT, $CFE_PROTECTED, $CFM_LINK)
;~ Global Const $CFM_ALL = BitOR($CFM_EFFECTS, $CFM_SIZE, $CFM_FACE, $CFM_OFFSET, $CFM_CHARSET)

Global Const $SCF_DEFAULT = 0x0
Global Const $SCF_SELECTION = 0x1
Global Const $SCF_WORD = 0x2
Global Const $SCF_ALL = 0x4
Global Const $SCF_USEUIRULES = 0x8
Global Const $SCF_ASSOCIATEFONT = 0x10
Global Const $SCF_NOKBUPDATE = 0x20

#ce
Global Const $EM_SETTEXTEX = ($WM_USER + 97)

#cs
; RichEdit Messages
;Global Const $EM_AUTOURLDETECT = ($WM_USER + 91)
Global Const $EM_CANPASTE = ($WM_USER + 50)
Global Const $EM_CANREDO = ($WM_USER + 85)
Global Const $EM_DISPLAYBAND = ($WM_USER + 51)
Global Const $EM_EXGETSEL = ($WM_USER + 52)
;Global Const $EM_EXLIMITTEXT = ($WM_USER + 53)
Global Const $EM_EXLINEFROMCHAR = ($WM_USER + 54)
Global Const $EM_EXSETSEL = ($WM_USER + 55)
;Global Const $EM_FINDTEXT = ($WM_USER + 56)
Global Const $EM_FINDTEXTEX = ($WM_USER + 79)
Global Const $EM_FINDTEXTEXW = ($WM_USER + 124)
Global Const $EM_FINDTEXTW = ($WM_USER + 123)
Global Const $EM_FINDWORDBREAK = ($WM_USER + 76)
Global Const $EM_FORMATRANGE = ($WM_USER + 57)
Global Const $EM_GETAUTOURLDETECT = ($WM_USER + 92)
Global Const $EM_GETBIDIOPTIONS = ($WM_USER + 201)
;Global Const $EM_GETCHARFORMAT = ($WM_USER + 58)
Global Const $EM_GETEDITSTYLE = ($WM_USER + 205)
Global Const $EM_GETEVENTMASK = ($WM_USER + 59)
Global Const $EM_GETIMECOLOR = ($WM_USER + 105)
Global Const $EM_GETIMECOMPMODE = ($WM_USER + 122)
Global Const $EM_GETIMEMODEBIAS = ($WM_USER + 127)
Global Const $EM_GETIMEOPTIONS = ($WM_USER + 107)
Global Const $EM_GETLANGOPTIONS = ($WM_USER + 121)
Global Const $EM_GETOPTIONS = ($WM_USER + 78)
Global Const $EM_GETPARAFORMAT = ($WM_USER + 61)
Global Const $EM_GETPUNCTUATION = ($WM_USER + 101)
Global Const $EM_GETREDONAME = ($WM_USER + 87)
;Global Const $EM_GETSCROLLPOS = ($WM_USER + 221)
;Global Const $EM_GETSELTEXT = ($WM_USER + 62)
;Global Const $EM_GETTEXTEX = ($WM_USER + 94)
;Global Const $EM_GETTEXTLENGTHEX = ($WM_USER + 95)
;Global Const $EM_GETTEXTMODE = ($WM_USER + 90)
;Global Const $EM_GETTEXTRANGE = ($WM_USER + 75)
Global Const $EM_GETTYPOGRAPHYOPTIONS = ($WM_USER + 203)
Global Const $EM_GETUNDONAME = ($WM_USER + 86)
Global Const $EM_GETWORDBREAKPROCEX = ($WM_USER + 80)
Global Const $EM_GETWORDWRAPMODE = ($WM_USER + 103)
Global Const $EM_GETZOOM = ($WM_USER + 224)
;Global Const $EM_HIDESELECTION = ($WM_USER + 63)
Global Const $EM_PASTESPECIAL = ($WM_USER + 64)
Global Const $EM_RECONVERSION = ($WM_USER + 125)
Global Const $EM_REDO = ($WM_USER + 84)
Global Const $EM_REQUESTRESIZE = ($WM_USER + 65)
Global Const $EM_SELECTIONTYPE = ($WM_USER + 66)
Global Const $EM_SETBIDIOPTIONS = ($WM_USER + 200)
;Global Const $EM_SETBKGNDCOLOR = ($WM_USER + 67)
Global Const $EM_SETCHARFORMAT = ($WM_USER + 68)
Global Const $EM_SETEDITSTYLE = ($WM_USER + 204)
Global Const $EM_SETEVENTMASK = ($WM_USER + 69)
;Global Const $EM_SETFONTSIZE = ($WM_USER + 223)
Global Const $EM_SETIMECOLOR = ($WM_USER + 104)
Global Const $EM_SETIMEMODEBIAS = ($WM_USER + 126)
Global Const $EM_SETIMEOPTIONS = ($WM_USER + 106)
Global Const $EM_SETLANGOPTIONS = ($WM_USER + 120)
Global Const $EM_SETOLECALLBACK = ($WM_USER + 70)
Global Const $EM_SETOPTIONS = ($WM_USER + 77)
Global Const $EM_SETPALETTE = ($WM_USER + 93)
Global Const $EM_SETPARAFORMAT = ($WM_USER + 71)
Global Const $EM_SETPUNCTUATION = ($WM_USER + 100)
Global Const $EM_SETSCROLLPOS = ($WM_USER + 222)
Global Const $EM_SETTARGETDEVICE = ($WM_USER + 72)
Global Const $EM_SETTEXTMODE = ($WM_USER + 89)
Global Const $EM_SETTYPOGRAPHYOPTIONS = ($WM_USER + 202)
Global Const $EM_SETUNDOLIMIT = ($WM_USER + 82)
Global Const $EM_SETWORDBREAKPROCEX = ($WM_USER + 81)
Global Const $EM_SETWORDWRAPMODE = ($WM_USER + 102)
Global Const $EM_SETZOOM = ($WM_USER + 225)
Global Const $EM_SHOWSCROLLBAR = ($WM_USER + 96)
Global Const $EM_STOPGROUPTYPING = ($WM_USER + 88)
Global Const $EM_STREAMIN = ($WM_USER + 73)
Global Const $EM_STREAMOUT = ($WM_USER + 74)
#ce
Global Const $EN_REQUESTRESIZE = 0X701
#cs
Global Const $EN_ALIGNLTR = 0X710
Global Const $EN_ALIGNRTL = 0X711
Global Const $EN_CORRECTTEXT = 0X705
Global Const $EN_DRAGDROPDONE = 0X70c
Global Const $EN_DROPFILES = 0X703
Global Const $EN_IMECHANGE = 0X707
Global Const $EN_LINK = 0X70b
Global Const $EN_MSGFILTER = 0X700
Global Const $EN_OBJECTPOSITIONS = 0X70a
Global Const $EN_OLEOPFAILED = 0X709
Global Const $EN_PROTECTED = 0X704
Global Const $EN_SAVECLIPBOARD = 0X708
Global Const $EN_SELCHANGE = 0X702
Global Const $EN_STOPNOUNDO = 0X706

Global Const $ENM_CHANGE = 0x1
Global Const $ENM_CORRECTTEXT = 0x400000
Global Const $ENM_DRAGDROPDONE = 0x10
Global Const $ENM_DROPFILES = 0x100000
Global Const $ENM_IMECHANGE = 0x800000
Global Const $ENM_KEYEVENTS = 0x10000
Global Const $ENM_LINK = 0x4000000
Global Const $ENM_MOUSEEVENTS = 0x20000
Global Const $ENM_OBJECTPOSITIONS = 0x2000000
Global Const $ENM_PROTECTED = 0x200000
Global Const $ENM_REQUESTRESIZE = 0x40000
Global Const $ENM_SCROLL = 0x4
Global Const $ENM_SCROLLEVENTS = 0x8
Global Const $ENM_SELCHANGE = 0x80000
Global Const $ENM_UPDATE = 0x2

#ce
Global Const $ES_DISABLENOSCROLL = 0x2000
Global Const $ES_EX_NOCALLOLEINIT = 0x1000000
Global Const $ES_NOIME = 0x80000
Global Const $ES_SELFIME = 0x40000
Global Const $ES_SUNKEN = 0x4000

;~ Global Const $ES_NUMBER					= 0x2000
;~ Global Const $ES_PASSWORD				= 0x20
;~ Global Const $ES_READONLY				= 0x800
;~ Global Const $ES_RIGHT					= 0x2
;~ Global Const $ES_WANTRETURN			= 0x1000
#cs
Global Const $WM_LBUTTONDBLCLK = 0x203
Global Const $WM_LBUTTONDOWN = 0x201
Global Const $WM_LBUTTONUP = 0x202
Global Const $WM_MOUSEMOVE = 0x200
Global Const $WM_RBUTTONDBLCLK = 0x206
Global Const $WM_RBUTTONDOWN = 0x204
Global Const $WM_RBUTTONUP = 0x205
;Global Const $WM_SETCURSOR = 0x20
#ce
; structure formats
Global Const $LF_FACESIZE = 32
Global Const $MAX_TAB_STOPS = 32

Global Const $NMHDR_fmt = "int;int;int"
;~ HWND hwndFrom;
;~ UINT idFrom;
;~ UINT code;

Global Const $Rect_fmt = "int;int;int;int"

Global Const $bidioptions_fmt = "uint;int;int"
;~ UINT cbSize;
;~ WORD wMask;
;~ WORD wEffects

Global Const $charformat_fmt = "uint;dword;dword;int;int;int;byte;byte;char[" & $LF_FACESIZE & "]"
;~ UINT cbSize;
;~ DWORD dwMask;
;~ DWORD dwEffects;
;~ LONG yHeight;
;~ LONG yOffset;
;~ COLORREF crTextColor;
;~ BYTE bCharSet;
;~ BYTE bPitchAndFamily;
;~ TCHAR szFaceName[LF_FACESIZE];

Global Const $charformat2_fmt = "uint;dword;dword;int;int;int;byte;byte;char[" & $LF_FACESIZE & "];int;short;int;byte;byte;byte;byte"
;~ UINT cbSize;
;~ DWORD dwMask;
;~ DWORD dwEffects;
;~ LONG yHeight;
;~ LONG yOffset;
;~ COLORREF crTextColor;
;~ BYTE bCharSet;
;~ BYTE bPitchAndFamily;
;~ TCHAR szFaceName[LF_FACESIZE];
;~ WORD wWeight;
;~ SHORT sSpacing;
;~ COLORREF crBackColor;
;~ LCID lcid;
;~ DWORD dwReserved;
;~ SHORT sStyle;
;~ WORD wKerning;
;~ BYTE bUnderlineType;
;~ BYTE bAnimation;
;~ BYTE bRevAuthor;
;~ BYTE bReserved1;

Global Const $charrange_fmt = "int;int"
;~ LONG cpMin;
;~ LONG cpMax;

Global Const $COMPCOLOR_fmt = "int;int;dword"
;~ COLORREF crText;
;~ COLORREF crBackground;
;~ DWORD dwEffects

;~ editstream {
;~     DWORD_PTR dwCookie;
;~     DWORD dwError;
;~     EDITSTREAMCALLBACK pfnCallback

Global Const $encorrecttext_fmt = $NMHDR_fmt & ";" & $charrange_fmt & ";int"
;~ NMHDR nmhdr;
;~ CHARRANGE chrg;
;~ WORD seltyp;

Global Const $endropfiles_fmt = $NMHDR_fmt & ";int;int;int"
;~ NMHDR nmhdr;
;~ HANDLE hDrop;
;~ LONG cp;
;~ BOOL fProtected

Global Const $ENLINK_fmt = $NMHDR_fmt & ";uint;int;int;" & $charrange_fmt
;~ NMHDR nmhdr;
;~ UINT msg;
;~ WPARAM wParam;
;~ LPARAM lParam;
;~ CHARRANGE chrg

Global Const $enlowfirtf_fmt = $NMHDR_fmt & ";ptr"
;~ NMHDR nmhdr;
;~ CHAR *szControl

Global Const $ENOLEOPFAILED_fmt = $NMHDR_fmt & ";int;int;int"
;~ NMHDR nmhdr;
;~ LONG iob;
;~ LONG lOper;
;~ HRESULT hr;

Global Const $enprotected_fmt = $NMHDR_fmt & ";uint;int;int;" & $charrange_fmt
;~ NMHDR nmhdr;
;~ UINT msg;
;~ WPARAM wParam;
;~ LPARAM lParam;
;~ CHARRANGE chrg

Global Const $ENSAVECLIPBOARD_fmt = $NMHDR_fmt & ";int;int"
;~ NMHDR nmhdr;
;~ LONG cObjectCount;
;~ LONG cch;

;~ Global Const $findtext_fmt = $charrange_fmt & ";ptr"
Global Const $findtext_fmt = $charrange_fmt & ";char[128]"
;~ CHARRANGE chrg;
;~ LPCTSTR lpstrText;

Global Const $findtextex_ftm = $charrange_fmt & ";char[128];" & $charrange_fmt
;~ CHARRANGE chrg;
;~ LPCTSTR lpstrText;
;~ CHARRANGE chrgText

Global Const $formatrange_fmt = "int;int;" & $Rect_fmt & ";" & $Rect_fmt & ";" & $charrange_fmt
;~ HDC hdc;
;~ HDC hdcTarget;
;~ RECT rc;
;~ RECT rcPage;
;~ CHARRANGE chrg

Global Const $gettextex_fmt = "dword;dword;uint;char;int"
;~ DWORD cb;
;~ DWORD flags;
;~ UINT codepage;
;~ LPCSTR lpDefaultChar;
;~ LPBOOL lpUsedDefChar

Global Const $gettextlengthex_fmt = "dword;uint"
;~ DWORD flags;
;~ UINT codepage;

;~ tagHyphenateInfo {
;~     SHORT cbSize;
;~     SHORT dxHyphenateZone;
;~     PFNHYPHENATEPROC pfnHyphenate

Global Const $tagKHYPH_fmt = "int;int;int;int;int;int;int"
;~ khyphNil,
;~ khyphNormal,
;~ khyphAddBefore,
;~ khyphChangeBefore,
;~ khyphDeleteBefore,
;~ khyphChangeAfter,
;~ khyphDelAndChange

Global Const $hyphresult_fmt = $tagKHYPH_fmt & ";int;char"
;~ KHYPH khyph;
;~ LONG ichHyph;
;~ WCHAR chHyph

Global Const $imecomptext_fmt = "int;dword"
;~ LONG cb;
;~ DWORD flags;

Global Const $msgfilter_fmt = $NMHDR_fmt & ";uint;int;int"
;~ NMHDR nmhdr;
;~ UINT msg;
;~ WPARAM wParam;
;~ LPARAM lParam

Global Const $objectpositions_fmt = $NMHDR_fmt & ";int;int"
;~ NMHDR nmhdr;
;~ LONG cObjectCount;
;~ LONG *pcpPositions

Global Const $paraformat_fmt = "uint;dword;int;int;int;int;int;int;short;int[" & $MAX_TAB_STOPS & "]"
;~ UINT cbSize;
;~ DWORD dwMask;
;~ WORD wNumbering;
;~ WORD wReserved;
;~ LONG dxStartIndent;
;~ LONG dxRightIndent;
;~ LONG dxOffset;
;~ WORD wAlignment;
;~ SHORT cTabCount;
;~ LONG rgxTabs[MAX_TAB_STOPS];

Global Const $paraformat_fmt2 = "uint;dword;int;int;int;int;int;int;short;int;int;int;int;short;byte;byte;int;int;int;int;int;int;int;int"
;~ UINT cbSize;
;~ DWORD dwMask;
;~ WORD  wNumbering;
;~ WORD  wEffects;
;~ LONG  dxStartIndent;
;~ LONG  dxRightIndent;
;~ LONG  dxOffset;
;~ WORD  wAlignment;
;~ SHORT cTabCount;
;~ LONG  rgxTabs[MAX_TAB_STOPS];
;~ LONG  dySpaceBefore;
;~ LONG  dySpaceAfter;
;~ LONG  dyLineSpacing;
;~ SHORT sStyle;
;~ BYTE  bLineSpacingRule;
;~ BYTE  bOutlineLevel;
;~ WORD  wShadingWeight;
;~ WORD  wShadingStyle;
;~ WORD  wNumberingStart;
;~ WORD  wNumberingStyle;
;~ WORD  wNumberingTab;
;~ WORD  wBorderSpace;
;~ WORD  wBorderWidth;
;~ WORD  wBorders;

Global Const $punctuation_fmt = "uint;ptr"
;~ UINT iSize;
;~ LPSTR szPunctuation

;~ Global $reobject_fmt = "dword;int;int; {
;~     DWORD cbStruct;
;~     LONG cp;
;~     CLSID clsid;
;~     LPOLEOBJECT poleobj;
;~     LPSTORAGE pstg;
;~     LPOLECLIENTSITE polesite;
;~     SIZEL sizel;
;~     DWORD dvaspect;
;~     DWORD dwFlags;
;~     DWORD dwUser

Global Const $repastespecial_fmt = "dword;dword"
;~ DWORD dwAspect;
;~ DWORD_PTR dwParam

Global Const $reqresize_fmt = $NMHDR_fmt & ";" & $Rect_fmt
;~ NMHDR nmhdr;
;~ RECT rc;

Global Const $selchange_fmt = $NMHDR_fmt & ";" & $charrange_fmt & ";int"
;~ NMHDR nmhdr;
;~ CHARRANGE chrg;
;~ WORD seltyp;

Global Const $settextex_fmt = "dword;uint"
;~ DWORD flags;
;~ UINT codepage

Global Const $textrange_fmt = $charrange_fmt & ";ptr"
;~ CHARRANGE chrg;
;~ LPSTR lpstrText

Global Const $tagLOGFONT_fmt = "int;int;int;int;int;byte;byte;byte;byte;byte;byte;byte;byte;char[" & $LF_FACESIZE & "]"
;~ LONG lfHeight;
;~ LONG lfWidth;
;~ LONG lfEscapement;
;~ LONG lfOrientation;
;~ LONG lfWeight;
;~ BYTE lfItalic;
;~ BYTE lfUnderline;
;~ BYTE lfStrikeOut;
;~ BYTE lfCharSet;
;~ BYTE lfOutPrecision;
;~ BYTE lfClipPrecision;
;~ BYTE lfQuality;
;~ BYTE lfPitchAndFamily;
;~ TCHAR lfFaceName[LF_FACESIZE];

;;

















;Global Const $EM_STREAMIN = 0x400+73
;Global Const $EM_STREAMOUT = 0x400+74
;Global Const $settextex_fmt = "dword;uint"
;Global Const $SF_RTF = 2
Global $fSet
Global $sRTFClassName, $pEditStreamCallback, $dll, $sGetRtf, $sSetRtf 

Global $EDITSTREAM = DllStructCreate("DWORD pdwCookie;DWORD dwError;PTR pfnCallback")
$pEditStreamCallback = _DllCallBack("_EditStreamCallback", "ptr;ptr;long;ptr")
DllStructSetData($EDITSTREAM, "pfnCallback", $pEditStreamCallback)

If FileExists(@SystemDir & "\Msftedit.dll") Then
    $dll = DllOpen("MSFTEDIT.DLL")
    $sRTFClassName = "RichEdit50W"
	;$dll = DllOpen("RICHED20.DLL")
    ;$sRTFClassName = "RichEdit20A"
Else
    ;MSFTEDIT.DLL
	$dll = DllOpen("RICHED20.DLL")
    $sRTFClassName = "RichEdit20A"
EndIf


;events mask
Global Const $ENM_CHANGE = 0x1
Global Const $ENM_CORRECTTEXT = 0x400000
Global Const $ENM_DRAGDROPDONE = 0x10
Global Const $ENM_DROPFILES = 0x100000
Global Const $ENM_IMECHANGE = 0x800000
Global Const $ENM_KEYEVENTS = 0x10000
Global Const $ENM_LINK = 0x4000000
Global Const $ENM_MOUSEEVENTS = 0x20000
Global Const $ENM_OBJECTPOSITIONS = 0x2000000
Global Const $ENM_PROTECTED = 0x200000
Global Const $ENM_REQUESTRESIZE = 0x40000
Global Const $ENM_SCROLL = 0x4
Global Const $ENM_SCROLLEVENTS = 0x8
Global Const $ENM_SELCHANGE = 0x80000
Global Const $ENM_UPDATE = 0x2
Global Const $EM_AUTOURLDETECT = $WM_USER + 91
Global Const $EM_FINDTEXT = $WM_USER + 56

;Global Const $EM_GETLINE = 0xC4
;global Const $EM_GETSEL = 0xB0
Global Const $EM_EXLIMITTEXT = $WM_USER+53
Global Const $EM_GETSELTEXT = $WM_USER + 62
Global Const $EM_GETTEXTEX = $WM_USER + 94
Global Const $EM_GETTEXTLENGTHEX = $WM_USER + 95
Global Const $EM_GETTEXTMODE = $WM_USER + 90
Global Const $EM_GETTEXTRANGE = $WM_USER + 75
Global Const $EM_GETSCROLLPOS = $WM_USER + 221
Global Const $EM_HIDESELECTION = ($WM_USER + 63)
Global Const $EM_SETPASSWORDCHAR = 0xCC
Global Const $EM_SETFONTSIZE = $WM_USER + 223
Global Const $EM_SETBKGNDCOLOR = ($WM_USER + 67)
Global Const $EM_GETCHARFORMAT = 1082
Global Const $EM_SETCHARFORMAT = 1092
global Const $EM_FINDWORDBREAK = $WM_USER + 76
Global Const $EM_REQUESTRESIZE = ($WM_USER + 65)
Global Const $EM_EXGETSEL = $WM_USER+52
Global Const $EM_SETPARAFORMAT = $WM_USER+71
Global Const $EM_GETPARAFORMAT = $WM_USER+61

Global Const $EN_LINK = 0x70b
Global Const $EN_MSGFILTER = 0x700
Global Const $EN_PROTECTED = 0x704
Global Const $EN_SELCHANGE = 0x702

Global Const $SCF_DEFAULT = 0x0
Global Const $SCF_SELECTION = 0x01
Global Const $SCF_WORD = 0x0002

Global Const $SFF_SELECTION = 0x8000

;constants for the CHARFORMAT2
Global Const $CFM_BOLD = 0x00000001
Global Const $CFM_ITALIC = 0x00000002
Global Const $CFM_UNDERLINE = 0x00000004
Global Const $CFM_STRIKEOUT = 0x00000008
Global Const $CFM_PROTECTED = 0x00000010
Global Const $CFM_DISABLED = 0x2000
Global Const $CFM_LINK = 0x00000020 ;/ * Exchange hyperlink extension * /
Global Const $CFM_SIZE = 0x80000000
Global Const $CFM_COLOR = 0x40000000
Global Const $CFM_FACE = 0x20000000
Global Const $CFM_OFFSET = 0x10000000
Global Const $CFM_RichEdit_SET = 0x08000000
Global Const $CFM_WEIGHT = 0x00400000
Global Const $CFM_BACKCOLOR = 0x04000000
Global Const $CFM_SPACING = 0x200000
Global Const $CFM_UNDERLINETYPE = 0x800000
Global Const $CFM_STYLE = 0x80000
Global Const $CFM_REVISED = 0x4000

; CHARFORMAT effects */
Global Const $CFE_BOLD = 0x0001
Global Const $CFE_ITALIC = 0x0002
Global Const $CFE_UNDERLINE = 0x0004
Global Const $CFE_STRIKEOUT = 0x0008
Global Const $CFE_PROTECTED = 0x0010
Global Const $CFE_DISABLED = $CFM_DISABLED
Global Const $CFE_LINK = 0x0020
Global Const $CFE_AUTOCOLOR = 0x40000000
Global Const $CFE_REVISED = $CFM_REVISED

Global Const $EM_SETEVENTMASK = $WM_USER + 69
;
Global Const $CFU_UNDERLINEDOUBLE = 3
Global Const $CFU_UNDERLINEWORD = 2

Global Const $PFA_LEFT = 0x1
Global Const $PFA_RIGHT = 0x2
Global Const $PFA_CENTER = 0x3
Global Const $PFA_JUSTIFY = 4

Global Const $PFE_TABLE = 0x4000

Global Const $PFM_NUMBERING = 0x20
Global Const $PFM_ALIGNMENT = 0x8
Global Const $PFM_SPACEBEFORE = 0x40
Global Const $PFM_NUMBERINGSTYLE = 0x2000
Global Const $PFM_NUMBERINGSTART = 0x8000
Global Const $PFM_BORDER = 0x800
Global Const $PFM_RIGHTINDENT = 0x2
Global Const $PFM_STARTINDENT = 0x1
Global Const $PFM_OFFSET = 0x4
Global Const $PFM_LINESPACING = 0x100
Global Const $PFM_SPACEAFTER = 0x80
Global Const $PFM_NUMBERINGTAB = 0x4000
Global Const $PFM_TABLE = 0x40000000

Global Const $PFN_BULLET = 0x1

global Const $WB_CLASSIFY = 3
global Const $WB_ISDELIMITER = 2
global Const $WB_LEFT = 0
global Const $WB_LEFTBREAK = 6
global Const $WB_MOVEWORDLEFT = 4
global Const $WB_MOVEWORDNEXT = 5
global Const $WB_MOVEWORDPREV = 4
global Const $WB_MOVEWORDRIGHT = 5
global Const $WB_NEXTBREAK = 7
global Const $WB_PREVBREAK = 6
global Const $WB_RIGHT = 1
global Const $WB_RIGHTBREAK = 7

Global Const $WM_LBUTTONDOWN = 0x201
Global Const $WM_RBUTTONDOWN = 0x204
Global Const $WM_LBUTTONDBLCLK = 0x203
Global Const $WM_MOUSEMOVE = 0x200

Global Const $GT_DEFAULT = 0
Global Const $GT_SELECTION = 2

Global Const $tagCHARFORMAT2 = "uint;int;dword;long;long;dword;byte;byte;char[32];short;short;long;long;long;short;short;byte;byte;byte;byte"
;																			        10    11    12     13  14   15    16    17   18   19   20
;			"cbSize, dwMask, dwEffects, yHeight, yOffset, crTextColor, bCharSet, bPitchAndFamily, szFaceName, wWeight, sSpacing, crBackColor, " & _
;           "lcid, dwReserved, sStyle, wKerning, bUnderlineType, bAnimation, bRevAuthor, bReserved1" (84)

Global Const $tagPARAFORMAT = "uint;uint;short;short;int;int;int;short;short;int[32]"
;~ UINT cbSize;
;~ DWORD dwMask;
;~ WORD wNumbering;
;~ WORD wReserved;
;~ LONG dxStartIndent;
;~ LONG dxRightIndent;
;~ LONG dxOffset;
;~ WORD wAlignment;
;~ SHORT cTabCount;
;~ LONG rgxTabs[MAX_TAB_STOPS];

;Global Const $tagPARAFORMAT2 = "uint;uint;short;short;int;int;int;short;short;int[32];long;short;ushort;ulong;ushort;ushort;ushort;ushort;ushort;ushort;ushort;ushort;ushort;ushort"
Global Const $tagPARAFORMAT2 = "uint;uint;short;short;int;int;int;short;short;int[32];int;int;int;ushort;byte;byte;short;short;short;short;short;short;short;short"
;								 1	  2	   3	  4	   5   6   7	8	  9		10	  11  12  13	14	  15   16	17	  18	19	  20	21    22     23    24  
;~ UINT cbSize;
;~ DWORD dwMask;
;~ WORD  wNumbering;
;~ WORD  wEffects;
;~ LONG  dxStartIndent;
;~ LONG  dxRightIndent;
;~ LONG  dxOffset;
;~ WORD  wAlignment;
;~ SHORT cTabCount;
;~ LONG  rgxTabs[MAX_TAB_STOPS];
;~ LONG  dySpaceBefore;
;~ LONG  dySpaceAfter;
;~ LONG  dyLineSpacing;
;~ SHORT sStyle;
;~ BYTE  bLineSpacingRule;
;~ BYTE  bOutlineLevel;
;~ WORD  wShadingWeight;
;~ WORD  wShadingStyle;
;~ WORD  wNumberingStart;
;~ WORD  wNumberingStyle;
;~ WORD  wNumberingTab;
;~ WORD  wBorderSpace;
;~ WORD  wBorderWidth;
;~ WORD  wBorders;

Global $tagTEXTEX = "dword;dword;uint;char;int"
;					"cbSize, flags, codepage, lpDefaultChar, lpUsedDefChar"
Global $tagCHARRANGE = "long;long"
;						"cpMin, cpMax"
Global $tagFINDTEXT = "ptr;str"
;					"CHARRANGE, lpstrText"		
;Global $tagLOGFONT = "long;long;long;long;long;byte;byte;byte;byte;byte;byte;byte;byte;char[32]"
;					"lfHeight, lfWidth, lfEscapement, lfOrientation, lfWeight, lfItalic, lfUnderline, lfStrikeOut, lfCharset, " &_ 
;					"lfOutPrecision, lfClipPrecision, lfQuality, lfPitchAndFamily, lfFaceName" & _



Global $tagENLINK = $tagNMHDR & ";uint msg;int wParam;int lParam;" & $tagCHARRANGE

Global $tagEN_MSGFILTER = $tagNMHDR & ";uint msg;int wParam;int lParam;"

Global $tagENPROTECTED = $tagNMHDR & ";uint msg;int wParam;int lParam;" & $tagCHARRANGE

Global $tagSELCHANGE = $tagNMHDR & ";" & $tagCHARRANGE & ";long seltyp;"

Global $tcharformat = DllStructCreate($tagCHARFORMAT2)
DllStructSetData($tcharformat, 1, DllStructGetSize($tcharformat))
Global $tparaformat = DllStructCreate($tagPARAFORMAT2)
DllStructSetData($tparaformat, 1, DllStructGetSize($tparaformat))



#cs===================================================================================================
 (*) ==> Functions that are not needed, because there are the same /similar functions in
 3.2.10 (GuiEdit.au3)!!!
 
 _GuiCtrl_RichEdit_Create
 _RichEdit_AddText(*)
 _RichEdit_BkColor 
 _RichEdit_GetFontName
 _RichEdit_GetFontSize
 _RichEdit_GetLineCount
 _RichEdit_GetBold
 _RichEdit_GetItalic 
 _RichEdit_GetUnderline
 _RichEdit_GetStrikeOut
 _RichEdit_GetFontColor
 _RichEdit_GetBkColor
 _RichEdit_GetFormat
 _RichEdit_GetSelection(*)         
 _RichEdit_GetText(*)
 _RichEdit_GetSelText
 _RichEdit_IncreaseFontSize
 _RichEdit_LimitText(*)
 _RichEdit_SetAlignment
 _RichEdit_SetFontName
 _RichEdit_SetFontSize
 _RichEdit_SetBold
 _RichEdit_SetItalic
 _RichEdit_SetLineSpacing
 _RichEdit_SetLink
 _RichEdit_SetOffSet
 _RichEdit_SetProtected
 _RichEdit_SetUnderline
 _RichEdit_SetStrikeOut
 _RichEdit_SetFontColor
 _RichEdit_SetBkColor
 _RichEdit_SetEventMask
 _RichEdit_SetNumbering
 _RichEdit_SetReadOnly(*)
 _RichEdit_SetSel(*)
 _RichEdit_ToggleBold
 _RichEdit_ToggleItalic
 _RichEdit_ToggleUnderline
 _RichEdit_ToggleStrikeOut
 _RichEdit_Undo(*)
#ce===================================================================================================

;=====================================================================================================
; _GuiCtrl_RichEdit_Create
; _GuiCtrl_RichEdit_CreateInput
;=====================================================================================================

Func _GuiCtrl_RichEdit_Create($hWnd, $x, $y, $width, $height, $dwStyle = -1, $dwExStyle = -1)
	If $dwStyle = -1 Then $dwStyle = BitOR($WS_CHILD, $ES_WANTRETURN, $ES_NOHIDESEL, $WS_VSCROLL, $WS_TABSTOP, $WS_VISIBLE, $ES_MULTILINE)
	If $dwExStyle = -1 Then $dwExStyle = $WS_EX_CLIENTEDGE
	Return _WinAPI_CreateWindowEx($dwExStyle, $sRTFClassName, "", $dwStyle, $x, $y, $width, $height, $hWnd)
EndFunc

Func _GuiCtrl_RichEdit_CreateInput($hWnd, $x, $y, $width, $height, $dwStyle = -1, $dwExStyle = -1)
	If $dwStyle = -1 Then $dwStyle = BitOR($WS_CHILD, $ES_WANTRETURN, $ES_NOHIDESEL, $WS_VISIBLE)
	If $dwExStyle = -1 Then $dwExStyle = $WS_EX_CLIENTEDGE
	Return _WinAPI_CreateWindowEx($dwExStyle, $sRTFClassName, "", $dwStyle, $x, $y, $width, $height, $hWnd)
EndFunc



; ====================================================================================================
; Description ..: Appends some text to the control
; Parameters ...: $hWnd         - Handle to the control
;                 $iText        - Text to append
;				  $i_udone		- if True, can be undone		
; Return values : none
; Author .......: grham
; Notes ........: appended to a selection; if no selection, at the caret 
; ====================================================================================================
Func _RichEdit_AddText($hWnd, $iText, $i_undone = True)
    Local $Buffer = DllStructCreate("char[" & StringLen($iText)+1 & "]")
	DllStructSetData($Buffer, 1, $iText)
	_SendMessage($hWnd, $EM_REPLACESEL, $i_undone, DllStructGetPtr($Buffer))
	$Buffer = 0
EndFunc   ;==>_RichEdit_AddText

Func _GUICtrlRichEditSetText(ByRef $h_RichEdit, $s_Text = "")
	If Not IsHWnd($h_RichEdit) Then $h_RichEdit = HWnd($h_RichEdit)
	Local $lResult, $settext_struct
	$settext_struct = DllStructCreate($settextex_fmt)
	DllStructSetData($settext_struct, 1, $ST_DEFAULT)
	DllStructSetData($settext_struct, 2, $CP_ACP)
	Return _SendMessage($h_RichEdit, $EM_SETTEXTEX, DllStructGetPtr($settext_struct), $s_Text, 0, "ptr", "str")
EndFunc   ;==>_GUICtrlRichEditSetText
; ====================================================================================================
; Description ..: Sets a background color of a richedit control
; Parameters ...: $hWnd         - Handle to the control
;                 $iColor       - Color to set
; Return values : none
; Author .......: grham
; Notes ........: 
; ====================================================================================================
Func _RichEdit_BkColor($hWnd, $iColor)
	_SendMessage($hWnd, $EM_SETBKGNDCOLOR, 0, $iColor)
EndFunc	;==> _RichEdit_BkColor

; ====================================================================================================
; Description ..: _RichEdit_GetFontName
; Parameters ...: $hWnd         - Handle to the control
; Return values : Font name
; Author .......: grham
; Notes ........: 
; ====================================================================================================
Func _RichEdit_GetFontName($hWnd)
	;DllStructSetData($tcharformat, 1, DllStructGetSize($tcharformat))
	_SendMessage ($hWnd, $EM_GETCHARFORMAT, $SCF_SELECTION, DllStructGetPtr($tcharformat))
	Return DllStructGetData($tcharformat, 9)
EndFunc	;==>_RichEdit_GetFontName

; ====================================================================================================
; Description ..: _RichEdit_GetFontSize
; Parameters ...: $hWnd         - Handle to the control
; Return values : Font size
; Author .......: grham
; Notes ........: 
; ====================================================================================================
Func _RichEdit_GetFontSize($hWnd)
	;DllStructSetData($tcharformat, 1, DllStructGetSize($tcharformat))
	_SendMessage ($hWnd, $EM_GETCHARFORMAT, $SCF_SELECTION, DllStructGetPtr($tcharformat))
	Return DllStructGetData($tcharformat, 4)/20
EndFunc	;==>_RichEdit_GetFontSize

; ====================================================================================================
; Description ..: Get the Line Count for the Control
; Parameters ...: $hWnd         - Handle to the control
; Return values : Returns the line count if successful
; Author .......: Yoan Roblet (Arcker)
; Notes ........:
; ====================================================================================================
Func _RichEdit_GetLineCount($hWnd)
    Return _SendMessage($hWnd, $EM_GETLINECOUNT, 0, 0)
EndFunc   ;==>_RichEdit_GetLineCount

; ====================================================================================================
; Description ..: _RichEdit_GetBold
; Parameters ...: $hWnd         - Handle to the control
; Return values : Returns True or False
; Author .......: grham
; Notes ........: 
; ====================================================================================================
Func _RichEdit_GetBold($hWnd)
    ;DllStructSetData($tcharformat, 1, DllStructGetSize($tcharformat))
	_SendMessage ($hWnd, $EM_GETCHARFORMAT, $SCF_SELECTION, DllStructGetPtr($tcharformat))
    Return BitAND(DllStructGetData($tcharformat, 3), $CFE_BOLD)/ 1
EndFunc   ;==>_RichEdit_GetBold

; ====================================================================================================
; Description ..: _RichEdit_GetItalic
; Parameters ...: $hWnd         - Handle to the control
; Return values : Returns True or False
; Author .......: grham
; Notes ........: 
; ====================================================================================================
Func _RichEdit_GetItalic($hWnd)
    ;DllStructSetData($tcharformat, 1, DllStructGetSize($tcharformat))
	 _SendMessage ($hWnd, $EM_GETCHARFORMAT, $SCF_SELECTION, DllStructGetPtr($tcharformat))
    Return BitAND(DllStructGetData($tcharformat, 3), $CFE_ITALIC)/ 2
EndFunc   ;==>_RichEdit_GetItalic

; ====================================================================================================
; Description ..: _RichEdit_GetUnderline
; Parameters ...: $hWnd         - Handle to the control
; Return values : Returns True or False
; Author .......: grham
; Notes ........: 
; ====================================================================================================
Func _RichEdit_GetUnderline($hWnd)
    ;DllStructSetData($tcharformat, 1, DllStructGetSize($tcharformat))
	 _SendMessage ($hWnd, $EM_GETCHARFORMAT, $SCF_SELECTION, DllStructGetPtr($tcharformat))
    Return BitAND(DllStructGetData($tcharformat, 3), $CFE_Underline)/4
EndFunc   ;==>_RichEdit_GetUnderline

; ====================================================================================================
; Description ..: _RichEdit_GetStrikeOut
; Parameters ...: $hWnd         - Handle to the control
; Return values : Returns True or False
; Author .......: grham
; Notes ........: 
; ====================================================================================================
Func _RichEdit_GetStrikeOut($hWnd)
	;DllStructSetData($tcharformat, 1, DllStructGetSize($tcharformat))
	 _SendMessage ($hWnd, $EM_GETCHARFORMAT, $SCF_SELECTION, DllStructGetPtr($tcharformat))
    Return BitAND(DllStructGetData($tcharformat, 3), $CFE_STRIKEOUT)/8
EndFunc   ;==>_RichEdit_GetStrikeOut

; ====================================================================================================
; Description ..: _RichEdit_GetFontColor
; Parameters ...: $hWnd         - Handle to the control
; Return values : Font color (Hex)
; Author .......: grham
; Notes ........: 
; ====================================================================================================
Func _RichEdit_GetFontColor($hWnd)
    ;DllStructSetData($tcharformat, 1, DllStructGetSize($tcharformat))
	 _SendMessage ($hWnd, $EM_GETCHARFORMAT, $SCF_SELECTION, DllStructGetPtr($tcharformat))
    Return 0 & "x" & StringTrimLeft(Hex(DllStructGetData($tcharformat, 6)), 2)
EndFunc   ;==>_RichEdit_GetFontColor

; ====================================================================================================
; Description ..: _RichEdit_GetBkColor
; Parameters ...: $hWnd         - Handle to the control
; Return values : Background color (Hex)
; Author .......: grham
; Notes ........: 
; ====================================================================================================
Func _RichEdit_GetBkColor($hWnd)
    ;DllStructSetData($tcharformat, 1, DllStructGetSize($tcharformat))
	_SendMessage ($hWnd, $EM_GETCHARFORMAT, $SCF_SELECTION, DllStructGetPtr($tcharformat))
    Return 0 & "x" & StringTrimLeft(Hex(DllStructGetData($tcharformat, 12)), 2)
EndFunc   ;==>_RichEdit_GetBkColor

; ====================================================================================================
; Description ..: _RichEdit_GetFormat
; Parameters ...: $hWnd         - Handle to the control
; Return values : Returns an Array with font format
;							index 0: bold-italic-underline-strikeout
;								  1: fontcolor			
;								  2: backgroundcolor				
; Author .......: grham
; Notes ........: 
; ====================================================================================================
Func _RichEdit_GetFormat($hWnd)
    Local $Array[3]
	;DllStructSetData($tcharformat, 1, DllStructGetSize($tcharformat))
	 _SendMessage ($hWnd, $EM_GETCHARFORMAT, $SCF_SELECTION, DllStructGetPtr($tcharformat))
    $Array[0] = BitAND(DllStructGetData($tcharformat, 3), $CFE_BOLD)/1 & _
				BitAND(DllStructGetData($tcharformat, 3), $CFE_ITALIC)/2 & _
				BitAND(DllStructGetData($tcharformat, 3), $CFE_Underline)/4 & _
				BitAND(DllStructGetData($tcharformat, 3), $CFE_STRIKEOUT)/8
	$Array[1] = 0 & "x" & StringTrimLeft(Hex(DllStructGetData($tcharformat, 6)), 2)
	$Array[2] = 0 & "x" & StringTrimLeft(Hex(DllStructGetData($tcharformat, 12)), 2)
	Return $Array
EndFunc   ;==>_RichEdit_getformat

; ====================================================================================================
; Description ..: _RichEdit_GetSelection
; Parameters ...: $hWnd         - Handle to the control
; Return values : Returns the beginning and the ending position of the selection
; Author .......: 
; Notes ........: 
; ====================================================================================================
Func _RichEdit_GetSelection($hWnd)
	Local $tcharrange = DllStructCreate($tagCHARRANGE), $Array[2]
	_SendMessage ($hWnd, $EM_EXGETSEL, 0, DllStructGetPtr($tcharrange))
	$Array[0] = DllStructGetData($tcharrange, 1)
	$Array[1] = DllStructGetData($tcharrange, 2)
	Return $Array
EndFunc	;==>_RichEdit_GetSelection

; ====================================================================================================
; Description ..: _RichEdit_GetText
; Parameters ...: $hWnd         - Handle to the control
; Return values : Returns a text form a RTC as plain text
; Author .......: grham
; Notes ........: 
; ====================================================================================================
Func _RichEdit_GetText($hWnd)
	Local $textex = DllStructCreate($tagTEXTEX)
	Local $Buffer = DllStructCreate("wchar[" & _SendMessage($hWnd, $WM_GETTEXTLENGTH, 0, 0)+1 & "]")
	;DllStructSetData($textex, 1, DllStructGetSize($Buffer))
	DllStructSetData($textex, 2, $GT_DEFAULT)
	DllStructSetData($textex, 3, 1200)
	DllStructSetData($textex, 4, 0)
	DllStructSetData($textex, 5, 0)
	_SendMessage ($hWnd, $EM_GETTEXTEX, DllStructGetPtr($textex), DllStructGetPtr($Buffer));
	Return DllStructGetData($Buffer, 1)
EndFunc ;==>_RichEdit_GetText

; ====================================================================================================
; Description ..: _RichEdit_GetSelText
; Parameters ...: $hWnd         - Handle to the control
; Return values : Returns a portion of a text selected
; Author .......: grham
; Notes ........: 
; ====================================================================================================
Func _RichEdit_GetSelText($hWnd)
	Local $Sel = _RichEdit_GetSelection($hWnd)
	Local $buffer = DllStructCreate("wchar[" & ($Sel[1]-$Sel[0])+1 & "]")
	DllCall("user32.dll", "int", "SendMessage", "hwnd", $hWnd, "int", $EM_GETSELTEXT, "int", 0, "ptr", DllStructGetPtr($buffer))
	Return DllStructGetData($buffer, 1)
EndFunc ;==>_RichEdit_GetSelText

; ====================================================================================================
; Description ..: Increase or decrease the font size
; Parameters ...: $hWnd         - Handle to the control
;                 $hDelta       - Value of incrementation, Negative ==> decrementation
; Return values : Returns True if successful, or False otherwise
; Author .......: 
; Notes ........: Apllied to the the end of text
; ====================================================================================================
Func _RichEdit_IncreaseFontSize($hWnd, $hDelta = 1)										
    Local $textlength = _SendMessage ($hWnd, $WM_GETTEXTLENGTH, 0, 0)
	_RichEdit_SetSel($hWnd, $textlength, $textlength, 1)
	Return _SendMessage ($hWnd, $EM_SETFONTSIZE, $hDelta, 0)
EndFunc   ;==>_RichEdit_IncreaseFontSize

; ====================================================================================================
; Description ..: Limit the control to N chararacters
; Parameters ...: $hWnd         - Handle to the control
;                 $hLimitTo     - Number of characters
; Return values : True on success, otherwise False
; Author .......: Yoan Roblet (Arcker)
; Notes ........: Set 0 to disable the limit
; ====================================================================================================
Func _RichEdit_LimitText($hWnd, $hLimitTo)
    Return _SendMessage($hWnd, $EM_LIMITTEXT, $hLimitTo, 0)
EndFunc   ;==>_RichEdit_LimitText

; ====================================================================================================
; Description ..: Paragraph alignment.
; Parameters ...: $hWnd         - Handle to the control
;                 $iAlignment   Values: 
;                               1 or $PFA_LEFT		Paragraphs are aligned with the left margin.
;                               2 or $PFA_RIGHT     Paragraphs are aligned with the right margin.
;                               3 or $PFA_CENTER    Paragraphs are centered.
;                               4 or $PFA_JUSTIFY 	Paragraphs are justified. This value is 
;													+included for compatibility with TOM interfaces; 
;													+rich edit controls earlier than Rich Edit 3.0 
;													+display the text aligned with the left margin.
; Return values : None
; Author .......: grham
; Notes ........:
; ====================================================================================================
Func _RichEdit_SetAlignment($hWnd, $iAlignment)		; 1 ==> Left, 2 ==> Right, 3 ==> Center, 4 ==> Justify 
	;DllStructSetData($tparaformat, 1, DllStructGetSize($tparaformat))
	DllStructSetData($tparaformat, 2, $PFM_ALIGNMENT)
	DllStructSetData($tparaformat, 8, $iAlignment)
	_SendMessage($hWnd, $EM_SETPARAFORMAT, 0, DllStructGetPtr($tparaformat))
EndFunc

; ====================================================================================================
; Description ..: Select the Font Name
; Parameters ...: $hWnd         - Handle to the control
;           	  $hFontName    - Name of the Font
;                 $iSelec       - Modify entire text or selection (default)
; Return values : True on success, otherwise False
; Author .......: Yoan Roblet (Arcker)
; Modified .....: grham
; Notes ........:
; ====================================================================================================
Func _RichEdit_SetFontName($hWnd, $hFontName, $iSelec = True)
    ;DllStructSetData($tcharformat, 1, DllStructGetSize($tcharformat))
	DllStructSetData($tcharformat, 2, $CFM_FACE)
	DllStructSetData($tcharformat, 9, $hFontName)
	Return _SendMessage($hWnd, $EM_SETCHARFORMAT, $iSelec, DllStructGetPtr($tcharformat))
EndFunc   ;==>_RichEdit_SetFontName
Func _RichEdit_SetFont($hWnd, $Set = -1, $FontColor = -1, $BkColor = -1, $sFontName = -1, $iFontSize = -1, $Selec = 1)	; 1: Bold, 2: Italic, 3: Underline, 4: StrikeOut 
	If $Set <> -1 Then
		$Set = String($Set)
		While StringLen($Set) < 4
			$Set = "0" & $Set
		WEnd
		$SplitSet = StringSplit($Set, "")
		_RichEdit_SetBold ($hWnd, Number($SplitSet[1]), $Selec)
		_RichEdit_SetItalic ($hWnd, Number($SplitSet[2]), $Selec)
		_RichEdit_SetUnderline ($hWnd, Number($SplitSet[3]), $Selec)
		_RichEdit_SetStrikeOut ($hWnd, Number($SplitSet[4]), $Selec)
	EndIf	
	If $FontColor <> -1 Then _RichEdit_SetFontColor ($hWnd, $FontColor, $Selec)
	If $BkColor <> -1 Then _RichEdit_SetBkColor ($hWnd, $BkColor, $Selec)
	If $sFontName <> -1 Then _RichEdit_SetFontName ($hWnd, $sFontName, $Selec)
	If $iFontSize <> -1 Then _RichEdit_SetFontSize ($hWnd, $iFontSize, $Selec)
EndFunc
Func _RichEditAppendLink($hWnd, $sText, $iNewLine = 1)
	Local $StartPos = StringLen(_RichEdit_GetText($hWnd)), $EndPos = $StartPos + StringLen($sText)
	_GUICtrlEdit_AppendText($hWnd, $sText)
	If $iNewLine Then _GUICtrlEdit_AppendText($hWnd, @CRLF)
	_RichEdit_SetSel($hWnd, $StartPos, $EndPos, 1)
	_RichEdit_SetLink($hWnd)
	_RichEdit_SetSel($hWnd, StringLen(_RichEdit_GetText($hWnd)), StringLen(_RichEdit_GetText($hWnd)), 1)
	_RichEdit_SetNumbering($hWnd, 0, 0)
	_RichEdit_SetSel($hWnd, $EndPos, $EndPos, 1)
EndFunc	;==> _RichEditAppendLink
Func _RichEdit_InsertTable($hWnd)
	Local $SingleCell = Round($Width*100/$Columns, 0), $CellIn, $RowIn, $CellInBottom, $CellInTop, $cll
	Local $ColorTable = "{\colortbl ;\red0\green0\blue0;\red255\green255\blue255;"
	Local $FontTable = "{\rtf1\ansi\ansicpg1252\deff0\deflang1034{\fonttbl{\f0\froman\fprq2\fcharset0 Times New Roman;}{\f1\fnil\fcharset0 Times New Roman;}}"
	
	$ColorTable &= "\red" & _ColorGetRed($ColorCell) & "\green" & _ColorGetGreen($ColorCell) & "\blue" & _ColorGetBlue($ColorCell) & ";" 
	$ColorTable &= "\red" & _ColorGetRed($ColorLine) & "\green" & _ColorGetGreen($ColorLine) & "\blue" & _ColorGetBlue($ColorLine) & ";"
	$ColorTable &= "\red" & _ColorGetRed($ColorHead) & "\green" & _ColorGetGreen($ColorHead) & "\blue" & _ColorGetBlue($ColorHead) & ";"
	$ColorTable &= "\red" & _ColorGetRed($ColorLeft) & "\green" & _ColorGetGreen($ColorLeft) & "\blue" & _ColorGetBlue($ColorLeft) & ";"
	$ColorTable &= "}"
	
	If $TopLeftBk Then $TopLeftBk = "\clcbpat3"
	
	If Not $TopLeft Then
		$HeadLine2 = $OutLine
	Else
		$HeadLine2 = $HeadLine	
	EndIf
		
	For $x = 1 To $Columns - 1
		$cll &= "\cell"
	Next	
	
	For $x = 2 To $Columns - 1
		$CellInTop &= "\clvertalc" & "\clcbpat5" & "\clbrdrl\brdrw" & $InVert & "\brdrs\brdrcf4\clbrdrt\brdrw" & $OutLine & "\brdrs\brdrcf4\clbrdrb\brdrw" & $HeadLine & "\brdrs\brdrcf4" & " \cellx" & $SingleCell*$x
		$CellIn &= "\clvertalc" & "\clcbpat3" & "\clbrdrl\brdrw" & $InVert & "\brdrs\brdrcf4\clbrdrt\brdrw" & $InHor & "\brdrs\brdrcf4\clbrdrb\brdrw" & $InHor & "\brdrs\brdrcf4" & " \cellx" & $SingleCell*$x
		$CellInBottom &= "\clvertalc" & "\clcbpat3" & "\clbrdrl\brdrw" & $InVert & "\brdrs\brdrcf4\clbrdrt\brdrw" & $InHor & "\brdrs\brdrcf4\clbrdrb\brdrw" & $OutLine & "\brdrs\brdrcf4" & " \cellx" & $SingleCell*$x
	Next
	
	For $x = 2 To $rows - 1
		$RowIn &= 	"\trrh" & $RowHeight & _
					"\clvertalc" & "\clcbpat3" & "\clbrdrl\brdrw" & $OutLine & "\brdrs\brdrcf4\clbrdrt\brdrw" & $InHor & "\brdrs\brdrcf4\clbrdrr\brdrw" & $HeadLine & "\brdrs\brdrcf4\clbrdrb\brdrw" & $InHor & "\brdrs\brdrcf4" & " \cellx" & $SingleCell*1 & _
					$CellIn & _
					"\clvertalc" & "\clcbpat3" & "\clbrdrl\brdrw" & $InVert & "\brdrs\brdrcf4\clbrdrt\brdrw" & $InHor & "\brdrs\brdrcf4\clbrdrr\brdrw" & $OutLine & "\brdrs\brdrcf4\clbrdrb\brdrw" & $InHor & "\brdrs\brdrcf4" & " \cellx" & $SingleCell*$Columns & _
					"\pard\intbl" & "\ql" & $cll & _
					"\row\trowd\trq" & $AlignTable
	Next	
	
	Local $Table =  $FontTable & $ColorTable & _	;color table
					"\viewkind4\uc1" & _
					"\trowd\trq" & $AlignTable & _
					"\trrh" & $RowHeight & _	;row formating; trowd = default, trrh+Num = row hight
					"\clvertalc" & $TopLeftBk & "\clbrdrl\brdrw" & $TopLeft & "\brdrs\brdrcf4\clbrdrt\brdrw" & $TopLeft & "\brdrs\brdrcf4\clbrdrr\brdrw" & $HeadLine2 & "\brdrs\brdrcf4\clbrdrb\brdrw" & $HeadLine2 & "\brdrs\brdrcf4" & " \cellx" & $SingleCell*1 & _ 
					$CellInTop & _
					"\clvertalc" & "\clcbpat5" & "\clbrdrl\brdrw" & $InVert & "\brdrs\brdrcf4\clbrdrt\brdrw" & $OutLine & "\brdrs\brdrcf4\clbrdrr\brdrw" & $OutLine & "\brdrs\brdrcf4\clbrdrb\brdrw" & $HeadLine & "\brdrs\brdrcf4" & " \cellx" & $SingleCell*$Columns & _ 
					"\pard\intbl" & "\qc" & $cll & _ ;text in row (here: next 3 cells)
					"\row\trowd\trq" & $AlignTable  & _	;end of a row
					$RowIn & _	;a loop for more rows
					"\trrh" & $RowHeight & _
					"\clvertalc" & "\clcbpat3" & "\clbrdrl\brdrw" & $OutLine & "\brdrs\brdrcf4\clbrdrt\brdrw" & $InHor & "\brdrs\brdrcf4\clbrdrr\brdrw" & $HeadLine & "\brdrs\brdrcf4\clbrdrb\brdrw" & $OutLine & "\brdrs\brdrcf4" & " \cellx" & $SingleCell*1 & _
					$CellInBottom & _
					"\clvertalc" & "\clcbpat3" & "\clbrdrl\brdrw" & $InVert & "\brdrs\brdrcf4\clbrdrt\brdrw" & $InHor & "\brdrs\brdrcf4\clbrdrr\brdrw" & $OutLine & "\brdrs\brdrcf4\clbrdrb\brdrw" & $OutLine & "\brdrs\brdrcf4" & " \cellx" & $SingleCell*$Columns & _
					"\intbl" & "\ql" & $cll & "\row" & _
					"}"
	_RichEdit_PasteRichText($hWnd, $Table, 1)
EndFunc	

Func _GUICtrlRichEditGetText(ByRef $h_RichEdit, $start, $end)
	If Not IsHWnd($h_RichEdit) Then $h_RichEdit = HWnd($h_RichEdit)
	Local $sBuffer_pointer, $TextRange_ptr
	Local $Memory_pointer, $struct_MemMap
	Local $i_Size, $string_Memory_pointer
	Local $buf_struct = DllStructCreate("char[4096]")
	$sBuffer_pointer = DllStructGetPtr($buf_struct)
	Local $TextRange_Struct = DllStructCreate($textrange_fmt)
	$TextRange_ptr = DllStructGetPtr($TextRange_Struct)
	$i_Size = DllStructGetSize($TextRange_Struct)
	DllStructSetData($TextRange_Struct, 1, $start)
	DllStructSetData($TextRange_Struct, 2, $end)
	$Memory_pointer = _MemInit ($h_RichEdit, $i_Size + 4096, $struct_MemMap)
	If @error Then
		_MemFree ($struct_MemMap)
		Return SetError(-1, -1, "")
	EndIf
	$string_Memory_pointer = $Memory_pointer + 4096
	DllStructSetData($TextRange_Struct, 3, $string_Memory_pointer)
	_MemWrite ($struct_MemMap, $TextRange_ptr)
	If @error Then
		_MemFree ($struct_MemMap)
		Return SetError(-1, -1, "")
	EndIf
	Local $lResult = _SendMessage($h_RichEdit, $EM_GETTEXTRANGE, 0, $Memory_pointer)
	
	If @error Then
		_MemFree ($struct_MemMap)
		Return SetError(-1, -1, "")
	EndIf
	_MemRead ($struct_MemMap, $string_Memory_pointer, $sBuffer_pointer, 4096)
	If @error Then
		_MemFree ($struct_MemMap)
		Return SetError(-1, -1, "")
	EndIf
	_MemFree ($struct_MemMap)
	If @error Then Return SetError(-1, -1, "")
;~ 	MsgBox(0, "Rich Edit Get Text", "Chars Copied: " & $lResult & @CRLF & "Chars: " & DllStructGetData($buf_struct, 1))
	Return DllStructGetData($buf_struct, 1)
EndFunc   ;==>_GUICtrlRichEditGetText


Func _RichEdit_StringGetPos($hWnd, $sText)
	$SearchIn = _RichEdit_GetText($hWnd)
	$Pos = StringInStr($SearchIn, $sText)-1
	ConsoleWrite($sText & " (at pos) " & $Pos)
EndFunc	

Func _RichEdit_PasteRichText($hWnd, $sRTFText, $iSelec = 0)	; Set rich text from a var 
	If $iSelec Then $iSelec = $SFF_SELECTION
	$sSetRtf = $sRTFText
	$fSet = True
	_SendMessage($hWnd, $EM_STREAMIN, BitOr($SF_RTF, $iSelec), DllStructGetPtr($EDITSTREAM))
	_RichEdit_AddText ($hWnd, "")
EndFunc 

; ====================================================================================================
; Description ..: _RichEdit_SetFontSize
; Parameters ...: $hWnd        - Handle to the control
;                 $iSize       - Size of the Font
;              	  $iSelec       - Modify entire text or selection (default)
; Return values : True on success, otherwise False
; Author .......: Yoan Roblet (Arcker)
; Modified .....: grham
; Notes ........:
; ====================================================================================================
Func _RichEdit_SetFontSize($hWnd, $iSize , $iSelec = True)
    ;DllStructSetData($tcharformat, 1, DllStructGetSize($tcharformat))
	DllStructSetData($tcharformat, 2, $CFM_SIZE)
	DllStructSetData($tcharformat, 4, $iSize*20)
	Return _SendMessage($hWnd, $EM_SETCHARFORMAT, $iSelec, DllStructGetPtr($tcharformat))
EndFunc ;==>_RichEdit_SetFontSize

; ====================================================================================================
; Description ..: Toggle the Bold effect
; Parameters ...: $hWnd         - Handle to the control
;                 $iStyle		- True = Set; False = Unset
;                 $iSelec       - Modify entire text or selection (default)
; Return values : True on success, otherwise False
; Author .......: Yoan Roblet (Arcker)
; Modified ....:  grham
; Notes ........:
; ====================================================================================================
Func _RichEdit_SetBold($hWnd, $iStyle = True, $iSelec = True, $iHL = True)
	If $iStyle Then $iStyle = $CFE_BOLD
	If $iHL Then $iHL = $CFE_LINK
	DllStructSetData($tcharformat, 1, DllStructGetSize($tcharformat))
	DllStructSetData($tcharformat, 2, $CFM_BOLD)
	DllStructSetData($tcharformat, 3, $iStyle)
	Return _SendMessage($hWnd, $EM_SETCHARFORMAT, $iSelec, DllStructGetPtr($tcharformat))
EndFunc   ;==>_RichEdit_SetBold

; ====================================================================================================
; Description ..: Toggle the Italic effect
; Parameters ...: $hWnd         - Handle to the control
;                 $iStyle		- True = Set; False = Unset
;                 $iSelec       - Modify entire text or selection (default)
; Return values : True on success, otherwise False
; Author .......: Yoan Roblet (Arcker)
; Modified ....:  grham
; Notes ........:
; ====================================================================================================
Func _RichEdit_SetItalic($hWnd, $iStyle = True, $iSelec = True)
	If $iStyle Then $iStyle = $CFE_ITALIC
	DllStructSetData($tcharformat, 1, DllStructGetSize($tcharformat))
	DllStructSetData($tcharformat, 2, $CFM_ITALIC)
	DllStructSetData($tcharformat, 3, $iStyle)
    Return _SendMessage($hWnd, $EM_SETCHARFORMAT, $iSelec, DllStructGetPtr($tcharformat))
EndFunc   ;==>_RichEdit_SetItalic

; ====================================================================================================
; Description ..: Type of line spacing.
; Parameters ...: $hWnd         - Handle to the control
;                 $iNum	        Values:	
;                               0					Single spacing.
;                               1                   One-and-a-half spacing.
;								2                   Double spacing.
; Return values : None
; Author .......: grham
; Notes ........:
; ====================================================================================================
Func _RichEdit_SetLineSpacing($hWnd, $iNum, $iTwips = 0)	; 0 => 1, 1 => 1+1/2; 2 => 2
	;DllStructSetData($tparaformat, 1, DllStructGetSize($tparaformat))
	DllStructSetData($tparaformat, 2, BitOr($PFM_LINESPACING, $PFM_SPACEAFTER))
	If $iTwips <> 0 Then DllStructSetData($tparaformat, 13, $iTwips*20)
	DllStructSetData($tparaformat, 15, $iNum)
	_SendMessage($hWnd, $EM_SETPARAFORMAT, 0, DllStructGetPtr($tparaformat))
EndFunc	;==> _RichEdit_SetLineSpacing

; ====================================================================================================
; Description ..: Toggle the Underline effect
; Parameters ...: $hWnd         - Handle to the control
;                 $iStyle		- True = Set; False = Unset
;                 $iSelec       - Modify entire text or selection (default)
; Return values : True on success, otherwise False
; Author .......: grham
; Notes ........:
; ====================================================================================================
Func _RichEdit_SetLink($hWnd, $iStyle = True, $iSelec = True)
    If $iStyle Then $iStyle = $CFE_LINK
	DllStructSetData($tcharformat, 2, $CFM_LINK)
	DllStructSetData($tcharformat, 3, $iStyle)
	Return _SendMessage($hWnd, $EM_SETCHARFORMAT, $iSelec, DllStructGetPtr($tcharformat))
EndFunc   ;==>_RichEdit_SetLink

; ====================================================================================================
; Description ..: Indentation of the second and subsequent lines, 
;				  +relative to the indentation of the first line, in twips.
; Parameters ...: $hWnd         - Handle to the control
;                 $iOffset - (here: twips/100)
; Return values : None
; Author .......: grham
; Notes ........:
; ====================================================================================================
Func _RichEdit_SetOffSet($hWnd, $iOffset)
	;DllStructSetData($tparaformat, 1, DllStructGetSize($tparaformat))
	DllStructSetData($tparaformat, 2, $PFM_OFFSET)
	DllStructSetData($tparaformat, 7, $iOffset*100)
	_SendMessage($hWnd, $EM_SETPARAFORMAT, 0, DllStructGetPtr($tparaformat))
EndFunc

; ====================================================================================================
; Description ..: Characters are protected; 
;				  +an attempt to modify them will cause an EN_PROTECTED notification message.
; Parameters ...: $hWnd         - Handle to the control
;                 $iStyle		- True = Set; False = Unset
;                 $iSelec       - Modify entire text or selection (default)
; Return values : None
; Author .......: grham
; Notes ........:
; ====================================================================================================

Func _RichEdit_SetProtected($hWnd, $iStyle = True, $iSelec = True)		
	If $iStyle Then $iStyle = $CFE_PROTECTED
	;DllStructSetData($tparaformat, 1, DllStructGetSize($tparaformat))
	DllStructSetData($tcharformat, 2, $CFM_PROTECTED)
	DllStructSetData($tcharformat, 3, $iStyle)
	_SendMessage($hWnd, $EM_SETCHARFORMAT, $iSelec, DllStructGetPtr($tcharformat))
EndFunc ;==> _RichEdit_SetProtected

; ====================================================================================================
; Description ..: Characters are marked as revised.
; Parameters ...: $hWnd         - Handle to the control
;                 $iStyle		- True = Set; False = Unset
;                 $iSelec       - Modify entire text or selection (default)
; Return values : True on success, otherwise False
; Author .......: grham
; Notes ........:
; ====================================================================================================
Func _RichEdit_SetRevised($hWnd, $iStyle = True, $iSelec = True)		
	If $iStyle Then $iStyle = $CFE_REVISED
	;DllStructSetData($tparaformat, 1, DllStructGetSize($tparaformat))
	DllStructSetData($tcharformat, 2, $CFM_REVISED)
	DllStructSetData($tcharformat, 3, $iStyle)
	_SendMessage($hWnd, $EM_SETCHARFORMAT, $iSelec, DllStructGetPtr($tcharformat))
EndFunc ;==> _RichEdit_SetProtected

; ====================================================================================================
; Description ..: Toggle the Underline effect
; Parameters ...: $hWnd         - Handle to the control
;                 $iStyle		- True = Set; False = Unset
;                 $iSelec       - Modify entire text or selection (default)
; Return values : True on success, otherwise False
; Author .......: Yoan Roblet (Arcker)
; Notes ........:
; ====================================================================================================
Func _RichEdit_SetUnderline($hWnd, $iStyle = True, $iSelec = True)
    If $iStyle Then $iStyle = $CFE_UNDERLINE
	;DllStructSetData($tcharformat, 1, DllStructGetSize($tcharformat))
	DllStructSetData($tcharformat, 2, $CFM_UNDERLINE)
	DllStructSetData($tcharformat, 3, $iStyle)
	Return _SendMessage($hWnd, $EM_SETCHARFORMAT, $iSelec, DllStructGetPtr($tcharformat))
EndFunc   ;==>_RichEdit_SetUnderline

; ====================================================================================================
; Description ..: Toggle the Strike Out effect
; Parameters ...: $hWnd         - Handle to the control
;                 $iStyle		- True = Set; False = Unset
;                 $iSelec       - Modify entire text or selection (default)
; Return values : True on success, otherwise False
; Author .......: Yoan Roblet (Arcker)
; Rewritten ....: grham
; Notes ........:
; ====================================================================================================
Func _RichEdit_SetStrikeOut($hWnd, $iStyle = True, $iSelec = True)
    If $iStyle Then $iStyle = $CFE_STRIKEOUT
	;DllStructSetData($tcharformat, 1, DllStructGetSize($tcharformat))
	DllStructSetData($tcharformat, 2, $CFM_STRIKEOUT)
	DllStructSetData($tcharformat, 3, $iStyle)
	Return _SendMessage($hWnd, $EM_SETCHARFORMAT, $iSelec, DllStructGetPtr($tcharformat))
EndFunc

; ====================================================================================================
; Description ..: Select the text color
; Parameters ...: $hWnd         - Handle to the control
;           	  $hColor       - Color value
;                 $iSelect      - Color entire text or selection (default)
; Return values : True on success, otherwise False
; Author .......: Yoan Roblet (Arcker)
; Rewritten ....: grham
; Notes ........:
; ====================================================================================================
Func _RichEdit_SetFontColor($hWnd, $hColor, $iSelec = True)
    ;DllStructSetData($tcharformat, 1, DllStructGetSize($tcharformat))
	DllStructSetData($tcharformat, 2, $CFM_COLOR)
	DllStructSetData($tcharformat, 6, $hColor)
	Return _SendMessage($hWnd, $EM_SETCHARFORMAT, $iSelec, DllStructGetPtr($tcharformat))
EndFunc   ;==>_RichEdit_SetColor

; ====================================================================================================
; Description ..: Select the Background text color										
; Parameters ...: $hWnd         - Handle to the control
;           	  $hColor       - Color value
;                 $iSelec       - Color entire text or selection (default)
; Return values : True on success, otherwise False
; Author .......: Yoan Roblet (Arcker)
; Rewritten ....: grham (works)
; Notes ........:
; ====================================================================================================
Func _RichEdit_SetBkColor($hWnd, $hColor, $iSelec = True)
	;DllStructSetData($tcharformat, 1, DllStructGetSize($tcharformat))
	DllStructSetData($tcharformat, 2, $CFM_BACKCOLOR)
	DllStructSetData($tcharformat, 12, $hColor)
	Return _SendMessage($hWnd, $EM_SETCHARFORMAT, $iSelec, DllStructGetPtr($tcharformat))
EndFunc   ;==>_RichEdit_SetBkColor

; ====================================================================================================
; Description ..: The EM_SETEVENTMASK message sets the event mask for a rich edit control.
;           The event mask specifies which notification messages the control sends to its parent window
; Parameters ...: $hWnd         - Handle to the control
;                 $hMin         - Character Number start
;                 $hMax         - Character Number stop
; Return values : True on success, otherwise False
; Author .......: Yoan Roblet (Arcker)
; Notes ........:
; ====================================================================================================
Func _RichEdit_SetEventMask($hWnd, $hFunction)
    Return _SendMessage ($hWnd, $EM_SETEVENTMASK, 0, $hFunction)
EndFunc   ;==>_RichEdit_SetEventMask

; ====================================================================================================
; Description ..: Sets paragraph numbering and numbering type
; Parameters ...: $hWnd         - Handle to the control
;                 $iChar        - Characters used for numbering:
;								0 					No numbering
;                               1 or $PFN_BULLET    Inserts a bullet
;                               2                   Arabic numbres (1,2,3 ...)
;                               3                   Lowercase tetters
;                               4                   Uppercase letters
;                               5                   Lowercase roman numerals (i,ii,iii...)
;                               6                   Uppercase roman numerals (I, II, ...)
;                               7                   Uses a sequence of characters beginning with 
;													+the Unicode character specified by 
;													+the wNumberingStart member
;                 $iFormat      - Numbering style used with numbered paragraphs
;                               0                   Follows the number with a right parenthesis.
;                               0x100               Encloses the number in parentheses. 
;                               0x200               Follows the number with a period.
;                               0x300               Displays only the number.
;                               0x400               Continues a numbered list without 
;													+applying the next number or bullet. 
;                               0x8000              Starts a new number with wNumberingStart.
;                 $iStart       - Starting number or Unicode value used for numbered paragraphs.
;                 $iTab         - Minimum space between a paragraph number and the paragraph text, in twips.
; Return values : None
; Author .......: grham
; Notes ........:
; ====================================================================================================
Func _RichEdit_SetNumbering($hWnd, $iChar = 0, $iFormat = 0x200, $iStart = 1, $iTab = 300)	
	;DllStructSetData($tparaformat, 1, DllStructGetSize($tparaformat))
	DllStructSetData($tparaformat, 2, BitOr($PFM_NUMBERING, $PFM_NUMBERINGSTART, $PFM_NUMBERINGSTYLE, $PFM_NUMBERINGTAB))
	DllStructSetData($tparaformat, 3, $iChar)
	DllStructSetData($tparaformat, 19, $iStart)
	DllStructSetData($tparaformat, 20, $iFormat)
	DllStructSetData($tparaformat, 21, $iTab)
	_SendMessage($hWnd, $EM_SETPARAFORMAT, 0, DllStructGetPtr($tparaformat))
EndFunc ;==> _RichEdit_SetNumbering

; ====================================================================================================
; Description ..: Set the control in ReadOnly Mode
; Parameters ...: $hWnd         - Handle to the control
;                 $hBool        - True = Enabled, False = Disabled
; Return values : True on success, otherwise False
; Author .......: Yoan Roblet (Arcker)
; Notes ........:
; ====================================================================================================
Func _RichEdit_SetReadOnly($hWnd, $hBool = True)
    Return _SendMessage ($hWnd, $EM_SETREADONLY, $hBool, 0)
EndFunc   ;==>_RichEdit_SetReadOnly

; ====================================================================================================
; Description ..: Select some text
; Parameters ...: $hWnd         - Handle to the control
;           	  $hMin         - Character Number start
;                 $hMax         - Character Number stop
; Return values : True on success, otherwise False
; Author .......: Yoan Roblet (Arcker)
; Notes ........:
; ====================================================================================================
Func _RichEdit_SetSel($hWnd, $hMin, $hMax, $HideSel = 0)
    _SendMessage ($hWnd, $EM_SETSEL, $hMin, $hMax)
	_SendMessage($hWnd, $EM_HIDESELECTION, $HideSel)
EndFunc   ;==>_RichEdit_SetSel

; ====================================================================================================
; Description ..: Size of the spacing below the paragraph, in twips.
; Parameters ...: $hWnd         - Handle to the control
;                 $iNum         - The value must be greater than or equal to zero. (here: twips/100)
; Return values : None
; Author .......: grham
; Notes ........:
; ====================================================================================================
Func _RichEdit_SetSpaceAfter($hWnd, $iNum)
	;DllStructSetData($tparaformat, 1, DllStructGetSize($tparaformat))
	DllStructSetData($tparaformat, 2, $PFM_SPACEAFTER)
	DllStructSetData($tparaformat, 12, $iNum*100)
	_SendMessage($hWnd, $EM_SETPARAFORMAT, 0, DllStructGetPtr($tparaformat))
EndFunc ;==> _RichEdit_SetSpaceAfter

; ====================================================================================================
; Description ..: Size of the spacing above the paragraph, in twips.
; Parameters ...: $hWnd         - Handle to the control
;                 $iNum         - The value must be greater than or equal to zero. (here: twips/100)
; Return values : None
; Author .......: grham
; Notes ........:
; ====================================================================================================
Func _RichEdit_SetSpaceBefore($hWnd, $iNum)
	;DllStructSetData($tparaformat, 1, DllStructGetSize($tparaformat))
	DllStructSetData($tparaformat, 2, $PFM_SPACEBEFORE)
	DllStructSetData($tparaformat, 11, $iNum*100)
	_SendMessage($hWnd, $EM_SETPARAFORMAT, 0, DllStructGetPtr($tparaformat))
EndFunc ;==>_RichEdit_SetSpaceBefore

; ====================================================================================================
; Description ..: Indentation of the paragraph's first line, in twips.
; Parameters ...: $hWnd         - Handle to the control
;                 $iStartIndent - (here: twips/100)
; Return values : None
; Author .......: grham
; Notes ........:
; ====================================================================================================
Func _RichEdit_SetStartIndent($hWnd, $iStartIndent)
	;DllStructSetData($tparaformat, 1, DllStructGetSize($tparaformat))
	DllStructSetData($tparaformat, 2, $PFM_STARTINDENT)
	DllStructSetData($tparaformat, 5, $iStartIndent*100)
	_SendMessage($hWnd, $EM_SETPARAFORMAT, 0, DllStructGetPtr($tparaformat))
EndFunc ;==> _RichEdit_SetStartIndent

; ====================================================================================================
; Description ..: _RichEdit_ToggleBold
; Parameters ...: $hWnd         - Handle to the control
; Return values : none
; Author .......: 
; Notes ........: 
; ====================================================================================================
Func _RichEdit_ToggleBold($hWnd)
	_RichEdit_SetBold($hWnd, Not _RichEdit_GetBold($hWnd))
EndFunc	;==>_RichEdit_ToggleBold

; ====================================================================================================
; Description ..: _RichEdit_ToggleItalic
; Parameters ...: $hWnd         - Handle to the control
; Return values : none
; Author .......: 
; Notes ........: 
; ====================================================================================================
Func _RichEdit_ToggleItalic($hWnd)
	_RichEdit_SetItalic($hWnd, Not _RichEdit_GetItalic($hWnd))
EndFunc ;==>_RichEdit_ToggleItalic

; ====================================================================================================
; Description ..: _RichEdit_ToggleUnderline
; Parameters ...: $hWnd         - Handle to the control
; Return values : none
; Author .......: 
; Notes ........: 
; ====================================================================================================
Func _RichEdit_ToggleUnderline($hWnd)
	_RichEdit_SetUnderline($hWnd, Not _RichEdit_GetUnderline($hWnd))
EndFunc ;==>_RichEdit_ToggleUnderline

; ====================================================================================================
; Description ..: _RichEdit_ToggleStrikeOut
; Parameters ...: $hWnd         - Handle to the control
; Return values : none
; Author .......: 
; Notes ........: 
; ====================================================================================================
Func _RichEdit_ToggleStrikeOut($hWnd)
	_RichEdit_SetStrikeOut($hWnd, Not _RichEdit_GetStrikeOut($hWnd))
EndFunc ;==>_RichEdit_ToggleStrikeOut

; ====================================================================================================
; Description ..: Undo
; Parameters ...: $hWnd         - Handle to the control
;                 $hMin         - Character Number start
;                 $hMax         - Character Number stop
; Return values : True on success, otherwise False
; Author .......: Yoan Roblet (Arcker)
; Notes ........:
; ====================================================================================================
Func _RichEdit_Undo($hWnd)
    Return _SendMessage ($hWnd, $EM_UNDO, 0, 0)
EndFunc   ;==>_RichEdit_Undo

;=============================================================================================================
;	for experiments	only	
;=============================================================================================================

Func _RichEdit_SetUnderlineDouble($hWnd, $iStyle = True, $iSelec = True)		; doesn't show!!!
    If $iStyle Then $iStyle = $CFU_UNDERLINEDOUBLE
	;DllStructSetData($tcharformat, 1, DllStructGetSize($tcharformat))
	DllStructSetData($tcharformat, 2, $CFM_UNDERLINETYPE)
	DllStructSetData($tcharformat, 17, $iStyle)
	Return _SendMessage($hWnd, $EM_SETCHARFORMAT, $iSelec, DllStructGetPtr($tcharformat))
EndFunc   ;==>_RichEdit_SetUnderline

Func _ReadStruct($hWnd)
	;DllStructSetData($tcharformat, 1, DllStructGetSize($tcharformat))
	_SendMessage ($hWnd, $EM_GETCHARFORMAT, $SCF_SELECTION, DllStructGetPtr($tcharformat))
    For $x = 1 To 20
		ConsoleWrite("Index " & $x & ": " & DllStructGetData($tcharformat, $x) & @CRLF)
	Next	
EndFunc	

Opt("MustDeclareVars", 0)
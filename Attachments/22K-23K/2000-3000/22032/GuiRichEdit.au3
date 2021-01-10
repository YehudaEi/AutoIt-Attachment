
#CS Functions:

RichText_Create(ByRef $h_Gui, $x, $y, $width, $height, $v_styles = $DEFAULT_RICHTEXT_STYLE, $v_exstyles = $WS_EX_CLIENTEDGE)
RichText_SetText($hRichText, $s_Text = "")
RichText_InsertText($hRichText, $s_Text = "")
RichText_AppendText($hRichText, $s_Text = "")
RichText_GetText($hRichText, $Method=$RICHTEXT_ALL)
RichText_GetLine($hRichText)
RichText_GetSel($hRichText)
RichText_SetSel($hRichText, $i_start, $i_end)
RichText_GetLineCount($hRichText)
RichText_GetLenght($hRichText)
RichText_LineIndex($hRichText, $i_line = -1)
RichText_LineLength($hRichText, $i_index = -1)
RichText_Limit($hRichText, $hLimitTo)
RichText_BkColor($hRichText, $iColor)
RichText_GetFirstVisibleLine($hRichText)
RichText_PosFromChar($hRichText, $iIndex)
RichText_SetBkColor($hRichText, $hColor, $iSelec = True)
RichText_SetBold($hRichText, $hBold = False, $iSelec = 0x01)
RichText_SetColor($hRichText, $hColor, $iSelec = True)
RichText_SetFontSize($hRichText, $Size , $iSelec = True)
RichText_SetStrikeOut($hRichText, $hBold = False, $iSelec = 0x01)
RichText_SetEventMask($hRichText, $hFunction)
RichText_SetFont($hRichText, $hFontName, $iSelec = True)
RichText_SetItalic($hRichText, $hBold = False, $iSelec = 0x01)
RichText_SetReadOnly($hRichText $hBool = True)
RichText_SetUnderline($hRichText, $hBold = False, $iSelec = 0x01)
RichText_Undo($hRichText)
RichText_SetTabStops($hRichText, $aTabStops)
RichText_HideSelection($hRichText, $iState=True)
RichText_PauseRedraw($hRichText)
RichText_ResumeRedraw($hRichText)
RichText_SetFormat($hRichText, $dwMask, $yHeight = 8, $yOffset = 0, _$crTextColor = 16711680, $bCharSet = 0, $bPitchAndFamily = 0, $szFaceName = "Sans Serif", _$wWeight = 400, $crBackColor = -1, $Underline = 0, $bUnderlineType = 0)

#CE

#include-once
#include <GUIConstants.au3>
#include <Misc.au3>
#include <Memory.au3>
#include <EditConstants.au3>
#include <GuiEdit.au3>
#Include <WinAPI.au3>


Global Const $RICHTEXT_ALL = 0			; All the text will be used
Global Const $RICHTEXT_SELECTION = 1	; Only the selection will be used
Global Const $RICHTEXT_PAUSE = 2		; Pause drawing before executing a function
Global Const $RICHTEXT_RESUME = 4		; Resume drawing after executing a function
Global Const $RICHTEXT_REDRAW = 8		; Pause drawing > execute function > resume drawing. ($RICHTEXT_REDRAW is the same as $RICHTEXT_PAUSE + $RICHTEXT_RESUME)

;Global Const $WM_NOTIFY = 0x4E
;~ Global Const $WM_USER = 0x400

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




;~ If Not IsDeclared("FF_DONTCARE") Then Global Const $FF_DONTCARE		= 0



Global Const $CFU_UNDERLINENONE = 0
Global Const $CFU_UNDERLINE = 1
Global Const $CFU_UNDERLINEWORD = 2
Global Const $CFU_UNDERLINEDOUBLE = 3
Global Const $CFU_UNDERLINEDOTTED = 4

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


; RichEdit Messages
Global Const $EM_AUTOURLDETECT = ($WM_USER + 91)
Global Const $EM_CANPASTE = ($WM_USER + 50)
Global Const $EM_CANREDO = ($WM_USER + 85)
Global Const $EM_DISPLAYBAND = ($WM_USER + 51)
Global Const $EM_EXGETSEL = ($WM_USER + 52)
Global Const $EM_EXLIMITTEXT = ($WM_USER + 53)
Global Const $EM_EXLINEFROMCHAR = ($WM_USER + 54)
Global Const $EM_EXSETSEL = ($WM_USER + 55)
Global Const $EM_FINDTEXT = ($WM_USER + 56)
Global Const $EM_FINDTEXTEX = ($WM_USER + 79)
Global Const $EM_FINDTEXTEXW = ($WM_USER + 124)
Global Const $EM_FINDTEXTW = ($WM_USER + 123)
Global Const $EM_FINDWORDBREAK = ($WM_USER + 76)
Global Const $EM_FORMATRANGE = ($WM_USER + 57)
Global Const $EM_GETAUTOURLDETECT = ($WM_USER + 92)
Global Const $EM_GETBIDIOPTIONS = ($WM_USER + 201)
Global Const $EM_GETCHARFORMAT = ($WM_USER + 58)
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
Global Const $EM_GETSCROLLPOS = ($WM_USER + 221)
Global Const $EM_GETSELTEXT = ($WM_USER + 62)
Global Const $EM_GETTEXTEX = ($WM_USER + 94)
Global Const $EM_GETTEXTLENGTHEX = ($WM_USER + 95)
Global Const $EM_GETTEXTMODE = ($WM_USER + 90)
Global Const $EM_GETTEXTRANGE = ($WM_USER + 75)
Global Const $EM_GETTYPOGRAPHYOPTIONS = ($WM_USER + 203)
Global Const $EM_GETUNDONAME = ($WM_USER + 86)
Global Const $EM_GETWORDBREAKPROCEX = ($WM_USER + 80)
Global Const $EM_GETWORDWRAPMODE = ($WM_USER + 103)
Global Const $EM_GETZOOM = ($WM_USER + 224)
Global Const $EM_HIDESELECTION = ($WM_USER + 63)
Global Const $EM_PASTESPECIAL = ($WM_USER + 64)
Global Const $EM_RECONVERSION = ($WM_USER + 125)
Global Const $EM_REDO = ($WM_USER + 84)
Global Const $EM_REQUESTRESIZE = ($WM_USER + 65)
Global Const $EM_SELECTIONTYPE = ($WM_USER + 66)
Global Const $EM_SETBIDIOPTIONS = ($WM_USER + 200)
Global Const $EM_SETBKGNDCOLOR = ($WM_USER + 67)
Global Const $EM_SETCHARFORMAT = ($WM_USER + 68)
Global Const $EM_SETEDITSTYLE = ($WM_USER + 204)
Global Const $EM_SETEVENTMASK = ($WM_USER + 69)
Global Const $EM_SETFONTSIZE = ($WM_USER + 223)
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
Global Const $EM_SETTEXTEX = ($WM_USER + 97)
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
Global Const $EN_REQUESTRESIZE = 0X701
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

Global Const $WM_LBUTTONDBLCLK = 0x203
Global Const $WM_LBUTTONDOWN = 0x201
Global Const $WM_RBUTTONDBLCLK = 0x206
Global Const $WM_RBUTTONDOWN = 0x204
Global Const $WM_RBUTTONUP = 0x205

Global Const $GT_DEFAULT            = 0x00000000
Global Const $GT_USECRLF            = 0x00000001
Global Const $GT_SELECTION          = 0x00000002
Global Const $GT_RAWTEXT            = 0x00000004
Global Const $GT_NOHIDDENTEXT       = 0x00000008

; structure formats
Global Const $LF_FACESIZE = 32
Global Const $MAX_TAB_STOPS = 32

Global Const $DEFAULT_RICHTEXT_STYLE = BitOR($ES_WANTRETURN,$ES_NOHIDESEL,$WS_HSCROLL,$WS_VSCROLL,$ES_MULTILINE)

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

Global $h_lib
; Cleanup
Func OnAutoItExit()
	$h_lib = DllCall("kernel32.dll", "long", "FreeLibrary", "long", $h_lib)
EndFunc   ;==>OnAutoItExit

;===============================================================================
;
; Description:			_GUICtrlRichEditCreate
; Parameter(s):		$h_Gui			- Handle to parent window
;							$x					- The left side of the control
;							$y					- The top of the control
;							$width			- The width of the control
;							$height			- The height of the control
;							$v_styles		- styles to apply to the control (Optional) for multiple styles bitor them.
;							$v_exstyles		- extended styles to apply to the control (Optional) for multiple styles bitor them.
; Requirement:
; Return Value(s):   Returns hWhnd if successful, or 0 with error set to 1 otherwise.
; User CallTip:      _GUICtrlRichEditCreate($h_Gui, $x, $y, $width, $height, [, $v_styles = -1[, $v_exstyles = -1]]) Creates RichEdit Control.
; Author(s):         Gary Frost (gafrost (custompcs@charter.net))
; Note(s):
;===============================================================================
Func RichText_Create(ByRef $h_Gui, $x, $y, $width, $height, $v_styles = $DEFAULT_RICHTEXT_STYLE, $v_exstyles = $WS_EX_CLIENTEDGE)
	Local $h_RichEdit, $style
	If Not IsHWnd($h_Gui) Then $h_Gui = HWnd($h_Gui)
	$style = BitOR($WS_CHILD, $WS_VISIBLE, $WS_CLIPSIBLINGS)
	If $v_styles <> -1 Then $style = BitOR($style, $v_styles)
	If $v_exstyles = -1 Then $v_exstyles = 0

;~ 	Local $stICCE = DllStructCreate('dword;dword')
;~ 	DllStructSetData($stICCE, 1, DllStructGetSize($stICCE))
;~ 	DllStructSetData($stICCE, 2, $ICC_STANDARD_CLASSES)

	$h_lib = DllCall("kernel32.dll", "long", "LoadLibrary", "str", "RichEd20.dll")
	If Not @error Then $h_lib = $h_lib[0]

	$h_RichEdit = DllCall("user32.dll", "long", "CreateWindowEx", "long", $v_exstyles, _
			"str", $RICHEDIT_CLASSA, "str", "", _
			"long", $style, "long", $x, "long", $y, "long", $width, "long", $height, _
			"hwnd", $h_Gui, "long", 0, "hwnd", $h_Gui, "long", 0)
	
	If Not @error Then
		
		RichText_Limit($h_RichEdit[0], -1) ; Limit = 2GB of characters
		
		_WinAPI_SetFont($h_RichEdit[0], _WinAPI_GetStockObject($DEFAULT_GUI_FONT))
		Return $h_RichEdit[0]
	Else
		SetError(1)
	EndIf


	Return 0
EndFunc   ;==>_GUICtrlRichEditCreate

;===============================================================================
;
; Description:			_GUICtrlRichEditSetText
; Parameter(s):		$h_RichEdit		- Handle to the control
;							$s_Text			- Text to put into the control
; Requirement:
; Return Value(s):   If the operation is setting all of the text and succeeds, the return value is 1.
;							If the operation is setting the selection and succeeds, the return value is the number of bytes or characters copied.
;							If the operation fails, the return value is zero.
; User CallTip:      _GUICtrlRichEditSetText($h_Gui, $s_Text) Put text into the RichEdit Control.
; Author(s):         Gary Frost (gafrost (custompcs@charter.net))
; Note(s):
;===============================================================================
Func RichText_SetText(ByRef $h_RichEdit, $s_Text = "")
	If Not IsHWnd($h_RichEdit) Then $h_RichEdit = HWnd($h_RichEdit)
	Local $lResult, $settext_struct
	$settext_struct = DllStructCreate($settextex_fmt)
	DllStructSetData($settext_struct, 1, $ST_DEFAULT)
	DllStructSetData($settext_struct, 2, $CP_ACP)
	Return _SendMessage($h_RichEdit, $EM_SETTEXTEX, DllStructGetPtr($settext_struct), $s_Text, 0, "ptr", "str")
EndFunc   ;==>_GUICtrlRichEditSetText

Func RichText_InsertText(ByRef $h_RichEdit, $s_Text = "")
	If Not IsHWnd($h_RichEdit) Then $h_RichEdit = HWnd($h_RichEdit)
	Local $lResult, $settext_struct
	$settext_struct = DllStructCreate($settextex_fmt)
	DllStructSetData($settext_struct, 1, $ST_SELECTION)
	DllStructSetData($settext_struct, 2, $CP_ACP)
	Return _SendMessage($h_RichEdit, $EM_SETTEXTEX, DllStructGetPtr($settext_struct), $s_Text, 0, "ptr", "str")
EndFunc   ;==>_GUICtrlRichEditInsertText

Func RichText_AppendText(ByRef $h_RichEdit, $s_Text = "")
	If Not IsHWnd($h_RichEdit) Then $h_RichEdit = HWnd($h_RichEdit)
	Local $lResult, $settext_struct
	Local $i_index = RichText_LineIndex($h_RichEdit, RichText_GetLineCount($h_RichEdit) - 1)
;~ 	If @error Then Return SetError($EC_ERR, $EC_ERR, "")
	Local $length = RichText_LineLength($h_RichEdit, $i_index) + $i_index
	RichText_SetSel($h_RichEdit, $length, $length)
	$settext_struct = DllStructCreate($settextex_fmt)
	DllStructSetData($settext_struct, 1, $ST_SELECTION)
	DllStructSetData($settext_struct, 2, $CP_ACP)
	Return _SendMessage($h_RichEdit, $EM_SETTEXTEX, DllStructGetPtr($settext_struct), $s_Text, 0, "ptr", "str")
EndFunc   ;==>_GUICtrlRichEditAppendText


func RichText_GetText($hWnd, $Method=$RICHTEXT_ALL)
	
	$iLen = RichText_GetLenght($hWnd)+1
	
	$Struct = DllStructCreate("int; dword; uint; char[100]; int")
	DllStructSetData($Struct,1,$iLen)
	DllStructSetData($Struct,2,$Method)
	DllStructSetData($Struct,3,0)
	DllStructSetData($Struct,4,"")
	DllStructSetData($Struct,5,0)
	
	$Buffer = DllStructCreate("char["&$iLen&"]")
	
	_SendMessage($hWnd, $EM_GETTEXTEX, DllStructGetPtr($Struct), DllStructGetPtr($Buffer))
	
	Return DllStructGetData($Buffer,1)
	
EndFunc

func RichText_GetLine($hWnd, $iLine)
	
	;ConsoleWrite($iLine&" ")
	
	Local $iLength, $struct_Buffer, $iResult, $struct_String, $aReturn[2]
	
	$iLength = RichText_LineLength($hWnd, $iLine)
	;ConsoleWrite($iLength&" ")
	$struct_Buffer = DllStructCreate("short Len;char Text[" & $iLength + 2 & "]")
	DllStructSetData($struct_Buffer, "Len", $iLength + 2)
	
	$iResult = _SendMessageA($hWnd, $EM_GETLINE, $iLine, DllStructGetPtr($struct_Buffer), 0, "wparam", "ptr")
	;ConsoleWrite($iResult&" ")
	If $iResult = $EC_ERR Then Return $aReturn
	
	$struct_String = DllStructCreate("char Text[" & $iLength + 1 & "]", DllStructGetPtr($struct_Buffer))
	$aReturn[0] = DllStructGetData($struct_String, "Text")
	$aReturn[1] = RichText_LineIndex($hWnd, $iLine)
	;ConsoleWrite(@CRLF)
	Return $aReturn
	
EndFunc

#CS Func RichText_GetText(ByRef $h_RichEdit, $start, $end)
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
#CE

Func RichText_GetScrollPos($hRichText)
	
	local $return[2]
	
	$sT = DllStructCreate("long x; long y")
	
	$iRet = _SendMessage($hRichText, ($WM_USER + 221), 0, DllStructGetPtr($sT))
	
	$return[0] = DllStructGetData($sT,1)
	$return[1] = DllStructGetData($sT,2)
	
	Return $return
	
EndFunc


;===============================================================================
;
; Description:			_GUICtrlRichEditGetSel
; Parameter(s):		$h_RichEdit - controlID
; Requirement:			None
; Return Value(s):	Array containing the starting and ending selected positions, first element ($array[0]) contains the number of elements
;							If an error occurs, the return value is $EC_ERR.
; User CallTip:		_GUICtrlRichEditGetSel($h_RichEdit) Retrieves the starting and ending character positions of the current selection in an edit control. (required: <GuiRichEdit.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				$array[1] contains the starting position
;							$array[2] contains the ending position
;
;===============================================================================
Func RichText_GetSel($h_RichEdit)
;~ 	If Not _IsClassName ($h_Edit, "Edit") Then Return SetError($EC_ERR, $EC_ERR, $EC_ERR)
	If Not IsHWnd($h_RichEdit) Then $h_RichEdit = HWnd($h_RichEdit)
	Local $ptr1 = "int", $ptr2 = "int", $i_ret
	Local $wparam = DllStructCreate($ptr1)
	Local $a_sel
	If @error Then Return SetError($EC_ERR, $EC_ERR, $EC_ERR)
	Local $lparam = DllStructCreate($ptr2)
	If @error Then Return SetError($EC_ERR, $EC_ERR, $EC_ERR)
;~ 	If IsHWnd($h_Edit) Then
	$i_ret = _SendMessage($h_RichEdit, $EM_GETSEL, DllStructGetPtr($wparam), DllStructGetPtr($lparam))
;~ 	Else
;~ 		$i_ret = GUICtrlSendMsg($h_Edit, $EM_GETSEL, DllStructGetPtr($wparam), DllStructGetPtr($lparam))
;~ 	EndIf
	If ($i_ret == -1) Then Return SetError($EC_ERR, $EC_ERR, $EC_ERR)
	$a_sel = StringSplit(DllStructGetData($wparam, 1) & "," & DllStructGetData($lparam, 1), ",")
	Return $a_sel
EndFunc   ;==>_GUICtrlRichEditGetSel

;===============================================================================
;
; Description:			_GUICtrlRichEditSetSel
; Parameter(s):		$h_RichEdit - controlID
;							$i_start - Specifies the starting character position of the selection.
;							$i_end - Specifies the ending character position of the selection.
; Requirement:			None
; Return Value(s):	None
; User CallTip:		_GUICtrlRichEditSetSel($h_RichEdit, $i_start, $i_end) Selects a range of characters in an edit control. (required: <GuiRichEdit.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				The start value can be greater than the end value.
;							The lower of the two values specifies the character position of the first character in the selection.
;							The higher value specifies the position of the first character beyond the selection.
;
;							The start value is the anchor point of the selection, and the end value is the active end.
;							If the user uses the SHIFT key to adjust the size of the selection, the active end can move but the anchor point remains the same.
;
;							If the $i_start is 0 and the $i_end is –1, all the text in the edit control is selected.
;							If the $i_start is –1, any current selection is deselected.
;
;							The control displays a flashing caret at the $i_end position regardless of the relative values of $i_start and $i_end.
;
;===============================================================================
Func RichText_SetSel($h_RichEdit, $i_start, $i_end)
;~ 	If Not _IsClassName ($h_RichEdit, "Edit") Then Return SetError($EC_ERR, $EC_ERR, 0)
	If Not IsHWnd($h_RichEdit) Then $h_RichEdit = HWnd($h_RichEdit)
	_SendMessage($h_RichEdit, $EM_SETSEL, $i_start, $i_end)
	_SendMessage($h_RichEdit, $EM_HIDESELECTION, 0)
EndFunc   ;==>_GUICtrlRichEditSetSel

;===============================================================================
;
; Description:			_GUICtrlRichEditGetLineCount
; Parameter(s):		$h_RichEdit - controlID
; Requirement:			None
; Return Value(s):	The return value is an integer specifying the total number of text lines in the multiline edit control.
; User CallTip:		_GUICtrlRichEditGetLineCount($h_RichEdit) Retrieves the number of lines in a multiline edit control. (required: <GuiRichEdit.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				If the control has no text, the return value is 1.
;							The return value will never be less than 1.
;
;							The _GUICtrlEditGetLineCount retrieves the total number of text lines,
;							not just the number of lines that are currently visible.
;
;							If the Wordwrap feature is enabled, the number of lines can change when the dimensions of the editing window change.
;
;===============================================================================
Func RichText_GetLineCount($h_RichEdit)
;~ 	If Not _IsClassName ($h_RichEdit, "Edit") Then Return SetError($EC_ERR, $EC_ERR, $EC_ERR)
	If Not IsHWnd($h_RichEdit) Then $h_RichEdit = HWnd($h_RichEdit)
	Return _SendMessage($h_RichEdit, $EM_GETLINECOUNT)
EndFunc   ;==>_GUICtrlRichEditGetLineCount

Func RichText_GetLenght($hWnd)
    
    $TStr = DllStructCreate("int Flags; int charset")
    DllStructSetData($TStr,1,0x00000000)
    DllStructSetData($TStr,2,1200)

    Return _SendMessage($hWnd, $EM_GETTEXTLENGTHEX, DllStructGetPtr($TStr), 0)
    
EndFunc

Func RichText_GetFirstVisibleLine($hWnd)
	Return _SendMessage($hWnd, $EM_GETFIRSTVISIBLELINE)
EndFunc

Func RichText_PosFromChar($hWnd, $iIndex)
	Local $aCoord[2], $iResult
	$iResult = _SendMessage($hWnd, $EM_POSFROMCHAR, $iIndex)
	$aCoord[0] = _WinAPI_LoWord($iResult)
	$aCoord[1] = _WinAPI_HiWord($iResult)
	Return $aCoord
EndFunc

;===============================================================================
;
; Description:			_GUICtrlRichEditLineIndex
; Parameter(s):		$h_RichEdit - controlID
;							$i_line - Optional: Specifies the zero-based line number.
;										A value of –1 specifies the current line number (the line that contains the caret).
; Requirement:			None
; Return Value(s):	The return value is the character index of the line specified in the wParam parameter,
;							or it is $EC_ERR if the specified line number is greater than the number of lines in the edit control.
; User CallTip:		_GUICtrlRichEditLineIndex($h_RichEdit[, $i_line = -1]) Retrieves the character index of the first character of a specified line in a multiline edit control. (required: <GuiRichEdit.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):
;
;===============================================================================
Func RichText_LineIndex($h_RichEdit, $i_line = -1)
;~ 	If Not _IsClassName ($h_RichEdit, "Edit") Then Return SetError($EC_ERR, $EC_ERR, $EC_ERR)
	If Not IsHWnd($h_RichEdit) Then $h_RichEdit = HWnd($h_RichEdit)
	Return _SendMessage($h_RichEdit, $EM_LINEINDEX, $i_line)
EndFunc   ;==>_GUICtrlRichEditLineIndex

;===============================================================================
;
; Description:			_GUICtrlRichEditLineLength
; Parameter(s):		$h_RichEdit - controlID
;							$i_index - Optional: Specifies the character index of a character in the line whose length is to be retrieved.
; Requirement:			None
; Return Value(s):	For multiline edit controls, the return value is the length, in TCHARs, of the line specified by the $i_index parameter.
;							For single-line edit controls, the return value is the length, in TCHARs, of the text in the edit control.
; User CallTip:		_GUICtrlRichEditLineLength($h_RichEdit[, $i_index = -1]) Retrieves the length, in characters, of a line in an edit control. (required: <GuiRichEdit.au3>)
; Author(s):			Gary Frost (custompcs at charter dot net)
; Note(s):				$i_index
;								For ANSI text, this is the number of bytes
;								For Unicode text, this is the number of characters.
;								It does not include the carriage-return character at the end of the line.
;								If $i_index is greater than the number of characters in the control, the return value is zero.
;
;===============================================================================
Func RichText_LineLength($h_RichEdit, $iIndex = -1)
;~ 	If Not _IsClassName ($h_RichEdit, "Edit") Then Return SetError($EC_ERR, $EC_ERR, $EC_ERR)
	Local $CharIndex = _GUICtrlEdit_LineIndex($h_RichEdit, $iIndex)
	Return _SendMessage($h_RichEdit, $EM_LINELENGTH, $CharIndex)
EndFunc   ;==>_GUICtrlRichEditLineLength


;~ Func _GUICtrlRichEditSetZoom(ByRef $h_RichEdit, $nominator = 0, $denominator = 0)
;~ 	If Not IsHWnd($h_RichEdit) Then $h_RichEdit = HWnd($h_RichEdit)
;~ 	Local $lResult = _SendMessage($h_RichEdit, $EM_SETZOOM, $nominator, $denominator)
;~ 	If Not @error Then
;~ 		Return $lResult
;~ 	Else
;~ 		Return SetError(1,1,0)
;~ 	EndIf
;~ EndFunc   ;==>_GuiCtrlRichEditSetZoom

;~ Func _GUICtrlRichEditGetZoom(ByRef $h_RichEdit)
;~ 	If Not IsHWnd($h_RichEdit) Then $h_RichEdit = HWnd($h_RichEdit)
;~ 	Local $lResult = _SendMessage($h_RichEdit, $EM_GETZOOM, 0, 0, -1)
;~ 	If Not @error Then
;~ 		Return $lResult[3] & "|" & $lResult[4]
;~ 	Else
;~ 		SetError(1)
;~ 	EndIf
;~ 	Return 0
;~ EndFunc   ;==>_GuiCtrlRichEditSetZoom

Func RichText_Limit($hWnd, $hLimitTo)
    Return _SendMessage ($hWnd, $EM_LIMITTEXT, $hLimitTo, 0)
EndFunc   ;==>_RichEdit_LimitText


Func RichText_BkColor($hWnd, $iColor)
	
	_SendMessage($hWnd, $EM_SETBKGNDCOLOR, 0, $iColor)
	
EndFunc

Func RichText_HideSelection($hWnd, $iState=True)
	Return _SendMessage($hWnd, $EM_HIDESELECTION, $iState,0)
EndFunc

; ====================================================================================================

; Description ..: Select the Background text color
; Parameters ...: $hWnd         - Handle to the control
;           $hMin         - Color value
;              $hMax         - Color entire text or selection (default)
; Return values : True on success, otherwise False
; Author .......: Yoan Roblet (Arcker)
; Notes ........:
; ====================================================================================================

Func RichText_SetBkColor($hWnd, $hColor, $iSelec = True)
    Local $tcharformat, $pCHARFORMAT
    $tcharformat = _tagCHARFORMAT2()
    dllstructsetdata ($tcharformat, "cbSize", dllstructgetsize ($tcharformat))
    dllstructsetdata ($tcharformat, "dwMask", $CFM_BACKCOLOR)
    dllstructsetdata ($tcharformat, "crBackColor", $hColor)
    $pCHARFORMAT = dllstructgetptr ($tcharformat)
    Return _SendMessage ($hWnd, $EM_SETCHARFORMAT, $iSelec, $pCHARFORMAT)
EndFunc   ;==>_RichEdit_SetBkColor
; ====================================================================================================

; Description ..: Toggle the Bold effect
; Parameters ...: $hWnd         - Handle to the control
;           $hFontName    - Name of the Font
;              $iSelec       - Modify entire text or selection (default)
; Return values : True on success, otherwise False
; Author .......: Yoan Roblet (Arcker)
; Notes ........:
; ====================================================================================================

Func RichText_SetBold($hWnd, $hBold = False, $iSelec = 0x01)
    Local $tcharformat, $pCHARFORMAT
    $tcharformat = _tagCHARFORMAT2()
    dllstructsetdata ($tcharformat, "cbSize", dllstructgetsize ($tcharformat))
    dllstructsetdata ($tcharformat, "dwMask", $CFM_BOLD)
    If $hBold Then
        dllstructsetdata ($tcharformat, "dwEffects", $CFE_BOLD)
    Else
        dllstructsetdata ($tcharformat, "dwEffects", 0)
    EndIf
    $pCHARFORMAT = dllstructgetptr ($tcharformat)
    Return _SendMessage ($hWnd, $EM_SETCHARFORMAT, $iSelec, $pCHARFORMAT)
EndFunc   ;==>_RichEdit_SetBold
; ====================================================================================================

; Description ..: Select the text color
; Parameters ...: $hWnd         - Handle to the control
;           $hMin         - Color value
;              $hMax         - Color entire text or selection (default)
; Return values : True on success, otherwise False
; Author .......: Yoan Roblet (Arcker)
; Notes ........:
; ====================================================================================================

Func RichText_SetColor($hWnd, $hColor, $iSelec = True)
    Local $tcharformat, $pCHARFORMAT
    $tcharformat = _tagCHARFORMAT2()
    dllstructsetdata ($tcharformat, "cbSize", dllstructgetsize ($tcharformat))
    dllstructsetdata ($tcharformat, "dwMask", $CFM_COLOR)
    dllstructsetdata ($tcharformat, "crTextColor", $hColor)
    $pCHARFORMAT = dllstructgetptr ($tcharformat)
    Return _SendMessage ($hWnd, $EM_SETCHARFORMAT, $iSelec, $pCHARFORMAT)
EndFunc   ;==>_RichEdit_SetColor
; ====================================================================================================

; Description ..: Set the text font size
; Parameters ...: $hWnd         - Handle to the control
;           $hMin         - Color value
;              $hMax         - Color entire text or selection (default)
; Return values : True on success, otherwise False
; Author .......: grham, edited by Yoan Roblet (Arcker)
; Notes ........:
; ====================================================================================================

Func RichText_SetFontSize($hWnd, $Size , $iSelec = True)
    Local $tcharformat, $pCHARFORMAT
    $tcharformat = _tagCHARFORMAT2()
    dllstructsetdata ($tcharformat, "cbSize", DllStructGetSize ($tcharformat))
    dllstructsetdata ($tcharformat, "dwMask", $CFM_SIZE)
    dllstructsetdata ($tcharformat, "yHeight", $Size*20)
    $pCHARFORMAT = DllStructGetPtr($tcharformat)
    Return _SendMessage ($hWnd, $EM_SETCHARFORMAT, $iSelec, $pCHARFORMAT)
EndFunc
; ====================================================================================================

; Description ..: Set the text striked out
; Parameters ...: $hWnd         - Handle to the control
;           $hMin         - Color value
;              $hMax         - Color entire text or selection (default)
; Return values : True on success, otherwise False
; Author .......: grham, edited by Yoan Roblet (Arcker)
; Notes ........:
; ====================================================================================================

Func RichText_SetStrikeOut($hWnd, $hBold = False, $iSelec = 0x01)
    Local $tcharformat, $pCHARFORMAT
    $tcharformat = _tagCHARFORMAT2()
    DllStructSetData ($tcharformat, "cbSize", DllStructGetSize($tcharformat))
    DllStructSetData($tcharformat, "dwMask", $CFM_STRIKEOUT)
    If $hBold Then
        DllStructSetData ($tcharformat, "dwEffects", $CFE_STRIKEOUT)
    Else
        DllStructSetData ($tcharformat, "dwEffects", 0)
    EndIf
    $pCHARFORMAT = DllStructGetPtr($tcharformat)
    Return _SendMessage ($hWnd, $EM_SETCHARFORMAT, $iSelec, $pCHARFORMAT)
EndFunc
; ====================================================================================================

; Description ..: The EM_SETEVENTMASK message sets the event mask for a rich edit control.
;           The event mask specifies which notification messages the control sends to its parent window
; Parameters ...: $hWnd         - Handle to the control
;           
; Return values : True on success, otherwise False
; Author .......: Yoan Roblet (Arcker)
; Notes ........:
; ====================================================================================================

Func  RichText_SetEventMask($hWnd, $hFunction)
    Return _SendMessage ($hWnd, $EM_SETEVENTMASK, 0, $hFunction)
EndFunc   ;==>_RichEdit_SetEventMask
; ====================================================================================================

; Description ..: Select the Font Name
; Parameters ...: $hWnd         - Handle to the control
;           $hColor       - Name of the Font
;              $hSelec       - Modify entire text or selection (default)
; Return values : True on success, otherwise False
; Author .......: Yoan Roblet (Arcker)
; Notes ........:
; ====================================================================================================

Func RichText_SetFont($hWnd, $hFontName, $iSelec = True)
    Local $tcharformat, $pCHARFORMAT
    $tcharformat = _tagCHARFORMAT2()
    dllstructsetdata ($tcharformat, "cbSize", dllstructgetsize ($tcharformat))
    dllstructsetdata ($tcharformat, "dwMask", $CFM_FACE)
    dllstructsetdata ($tcharformat, "szFaceName", $hFontName)
    $pCHARFORMAT = dllstructgetptr ($tcharformat)
    Return _SendMessage ($hWnd, $EM_SETCHARFORMAT, $iSelec, $pCHARFORMAT)
EndFunc   ;==>_RichEdit_SetFontName
; ====================================================================================================

; Description ..: Toggle the Italic effect
; Parameters ...: $hWnd         - Handle to the control
;           $hFontName    - Name of the Font
;              $iSelec       - Modify entire text or selection (default)
; Return values : True on success, otherwise False
; Author .......: Yoan Roblet (Arcker)
; Notes ........:
; ====================================================================================================

Func RichText_SetItalic($hWnd, $hBold = False, $iSelec = 0x01)
    Local $tcharformat, $pCHARFORMAT
    $tcharformat = _tagCHARFORMAT2()
    dllstructsetdata ($tcharformat, "cbSize", dllstructgetsize ($tcharformat))
    dllstructsetdata ($tcharformat, "dwMask", $CFM_ITALIC)
    If $hBold Then
        dllstructsetdata ($tcharformat, "dwEffects", $CFE_ITALIC)
    Else
        dllstructsetdata ($tcharformat, "dwEffects", 0)
    EndIf
    $pCHARFORMAT = dllstructgetptr ($tcharformat)
    Return _SendMessage ($hWnd, $EM_SETCHARFORMAT, $iSelec, $pCHARFORMAT)
EndFunc   ;==>_RichEdit_SetItalic
; ====================================================================================================

; Description ..: Set the control in ReadOnly Mode
; Parameters ...: $hWnd         - Handle to the control
;           $hBool        - True = Enabled, False = Disabled
; Return values : True on success, otherwise False
; Author .......: Yoan Roblet (Arcker)
; Notes ........:
; ====================================================================================================

Func RichText_SetReadOnly($hWnd, $hBool = True)
    Return _SendMessage ($hWnd, $EM_SETREADONLY, $hBool, 0)
EndFunc   ;==>_RichEdit_SetReadOnly
; ====================================================================================================

; Description ..: Toggle the Underline effect
; Parameters ...: $hWnd         - Handle to the control
;           $hFontName    - Name of the Font
;              $iSelec       - Modify entire text or selection (default)
; Return values : True on success, otherwise False
; Author .......: Yoan Roblet (Arcker)
; Notes ........:
; ====================================================================================================

Func RichText_SetUnderline($hWnd, $hBold = False, $iSelec = 0x01)
    Local $tcharformat, $pCHARFORMAT
    $tcharformat = _tagCHARFORMAT2()
    dllstructsetdata ($tcharformat, "cbSize", dllstructgetsize ($tcharformat))
    dllstructsetdata ($tcharformat, "dwMask", $CFM_UNDERLINE)
    If $hBold Then
        dllstructsetdata ($tcharformat, "dwEffects", $CFE_UNDERLINE)
    Else
        dllstructsetdata ($tcharformat, "dwEffects", 0)
    EndIf
    $pCHARFORMAT = dllstructgetptr ($tcharformat)
    Return _SendMessage ($hWnd, $EM_SETCHARFORMAT, $iSelec, $pCHARFORMAT)
EndFunc   ;==>_RichEdit_SetUnderline
; ====================================================================================================

; Description ..: Undo
; Parameters ...: $hWnd         - Handle to the control
;           $hMin         - Character Number start
;              $hMax         - Character Number stop
; Return values : True on success, otherwise False
; Author .......: Yoan Roblet (Arcker)
; Notes ........:
; ====================================================================================================

Func RichText_Undo($hWnd)
    Return _SendMessage ($hWnd, $EM_UNDO, 0, 0)
EndFunc   ;==>_RichEdit_Undo

Func RichText_Redo($hWnd)
    Return _SendMessage ($hWnd, $EM_REDO, 0, 0)
EndFunc   ;==>_RichEdit_Undo



func RichText_PauseRedraw($hWnd)
	Return _SendMessage($hWnd, $WM_SETREDRAW, false, 0)
EndFunc

func RichText_ResumeRedraw($hWnd)
	_SendMessage($hWnd, $WM_SETREDRAW, true, 0)
	return _WinAPI_InvalidateRect($hWnd)
EndFunc


Func RichText_SetTabStops($hWnd, $aTabStops)
	
	Local $iNumTabStops, $tTabStops, $sTabStops, $iResult
	
	If IsArray($aTabStops) Then ; Set every tabstop manually
		
		$iNumTabStops = UBound($aTabStops)
		
		For $x = 0 To $iNumTabStops - 1
			$sTabStops &= "int;"
		Next
		$sTabStops = StringTrimRight($sTabStops, 1)
		$tTabStops = DllStructCreate($sTabStops)
		For $x = 0 To $iNumTabStops - 1
			DllStructSetData($tTabStops, $x + 1, $aTabStops[$x])
		Next
		
	Else ; Set 1 value for all tabstops
		$tTabStops = DllStructCreate("int")
		DllStructSetData($tTabStops, 1, $aTabStops)
		$iNumTabStops = 1
	EndIf
	
	$iResult = _SendMessage($hWnd, $EM_SETTABSTOPS, $iNumTabStops, DllStructGetPtr($tTabStops), 0, "wparam", "ptr") <> 0
	_WinAPI_InvalidateRect($hWnd)
	
	Return $iResult
EndFunc   ;==>_GUICtrlEdit_SetTabStops

; ====================================================================================================

; *** *** *** *** *** *** *** *** *** *** ***  Structures  *** *** *** *** *** *** *** *** *** *** ***
; ====================================================================================================

; ====================================================================================================

; Description ..: (specifies a range of characters in a rich edit control)
; Parameters ...: $pPointer     - If supplied, the structure will be mapped over this pointer
; Return values : Array formatted as follows:
;                   $aTag[0] - Tag prefix identifier
;                   $aTag[1] - Tag structure
; Author .......: Yoan Roblet (Arcker)
; Notes ........:
; ====================================================================================================

Func __tagCHARRANGE()
    Return DllStructCreate("long cpMin;long cpMax ")
EndFunc   ;==>__tagCHARRANGE
; ====================================================================================================

; Description ..: (contains information about a search operation in a rich edit control)
; Parameters ...: $pPointer     - If supplied, the structure will be mapped over this pointer
; Return values : Array formatted as follows:
;                   $aTag[0] - Tag prefix identifier
;                   $aTag[1] - Tag structure
; Author .......: Yoan Roblet (Arcker)
; Notes ........:
; ====================================================================================================

Func __tagFINDTEXT()
    Return DllStructCreate("ptr CHARRANGE;str lpstrText")
EndFunc   ;==>__tagFINDTEXT
; ====================================================================================================

; Description ..: (contains information about character formatting in a rich edit control)
; Parameters ...: $pPointer     - If supplied, the structure will be mapped over this pointer
; Return values : Array formatted as follows:
;                   $aTag[0] - Tag prefix identifier
;                   $aTag[1] - Tag structure
; Author .......: Yoan Roblet (Arcker)
; Notes ........:
; ====================================================================================================

Func _tagCHARFORMAT2($pPointer = 0)
    ;Global Const $tagCHARFORMAT2 = "uint;int;dword;long;long;dword;byte;byte;char[32];short;short;long;long;long;short;short;byte;byte;byte;byte"
    Return DllStructCreate ("uint cbSize;int dwMask;dword dwEffects;long yHeight;long yOffset;uint crTextColor;" _
     & "byte bCharSet;byte bPitchAndFamily;char szFaceName[32];ushort wWeight;short sSpacing;uint crBackColor;uint lcid;dword dwReserved;short sStyle;ushort wKerning" _
             & ";byte bUnderlineType;byte bAnimation;byte bRevAuthor;byte bReserved1")
EndFunc   ;==>_tagCHARFORMAT2
; ====================================================================================================

; Description ..: (Size, Flags, hCursor, X, Y)
; Parameters ...: $pPointer     - If supplied, the structure will be mapped over this pointer
; Return values : Array formatted as follows:
;                   $aTag[0] - Tag prefix identifier
;                   $aTag[1] - Tag structure
; Author .......: Yoan Roblet (Arcker)
; Notes ........:
; ====================================================================================================

Func _tagLOGFONT($pPointer = 0)
    Return DllStructCreate ($tagLOGFONT)
    ;Local $aTag[2] = ["tagLOGFONT_", __tagStruct ($sStruct, $pPointer) ]
    ;Return __tagBuild ($aTag, "lfHeight, lfWidth, lfEscapement, lfOrientation, lfWeight, lfItalic, " & _
    ;      "lfUnderline, lfStrikeOut, lfCharset, lfOutPrecision, lfClipPrecision, lfQuality, lfPitchAndFamily, lfFaceName")
EndFunc   ;==>_tagLOGFONT
; ====================================================================================================

; Description ..: (Size, Flags, hCursor, X, Y)
; Parameters ...: $pPointer     - If supplied, the structure will be mapped over this pointer
; Return values : Array formatted as follows:
;                   $aTag[0] - Tag prefix identifier
;                   $aTag[1] - Tag structure
; Author .......: Yoan Roblet (Arcker)
; Notes ........:
; ====================================================================================================

Func __tagTEXTRANGE($pPointer = 0)
  Return DllStructCreate ("long Min;long Max;ptr Text")
  ;Local $aTag[2] = ["tagTEXTRANGE_", __tagStruct ($sStruct, $pPointer) ]
  ;Return __tagBuild ($aTag, "Min, Max, Text")
EndFunc

Func RichText_SetFormat(ByRef $h_RichEdit, $dwMask, $yHeight = 8, $yOffset = 0, _
		$crTextColor = 16711680, $bCharSet = 0, $bPitchAndFamily = 0, $szFaceName = "Sans Serif", _
		$wWeight = 400, $crBackColor = -1, $Underline = 0, $bUnderlineType = 0)
	If Not IsHWnd($h_RichEdit) Then $h_RichEdit = HWnd($h_RichEdit)
	Local $charformat_struct, $lResult, $Format, $dwEffects, $a_sel

;~ The bCharSet member is valid.
	$dwMask = BitOR($dwMask, $CFM_CHARSET)
	If $bCharSet = 0 Then $bCharSet = $DEFAULT_CHARSET
	If $bPitchAndFamily = 0 Then $bPitchAndFamily = BitOR($DEFAULT_PITCH, $FF_DONTCARE)
	If _IsBit($dwMask, $CFM_ALLCAPS) Then $dwEffects = BitOR($dwEffects, $CFE_ALLCAPS)
	If _IsBit($dwMask, $CFM_BOLD) Then $dwEffects = BitOR($dwEffects, $CFE_BOLD)
	If _IsBit($dwMask, $CFM_DISABLED) Then $dwEffects = BitOR($dwEffects, $CFE_DISABLED)
	If _IsBit($dwMask, $CFM_EMBOSS) Then $dwEffects = BitOR($dwEffects, $CFE_EMBOSS)
	If _IsBit($dwMask, $CFM_HIDDEN) Then $dwEffects = BitOR($dwEffects, $CFE_HIDDEN)
	If _IsBit($dwMask, $CFM_IMPRINT) Then $dwEffects = BitOR($dwEffects, $CFE_IMPRINT)
	If _IsBit($dwMask, $CFM_ITALIC) Then $dwEffects = BitOR($dwEffects, $CFE_ITALIC)
	If _IsBit($dwMask, $CFM_LINK) Then $dwEffects = BitOR($dwEffects, $CFE_LINK)
	If _IsBit($dwMask, $CFM_OUTLINE) Then $dwEffects = BitOR($dwEffects, $CFE_OUTLINE)
	If _IsBit($dwMask, $CFM_PROTECTED) Then $dwEffects = BitOR($dwEffects, $CFE_PROTECTED)
	If _IsBit($dwMask, $CFM_REVISED) Then $dwEffects = BitOR($dwEffects, $CFE_REVISED)
	If _IsBit($dwMask, $CFM_SHADOW) Then $dwEffects = BitOR($dwEffects, $CFE_SHADOW)
	If _IsBit($dwMask, $CFM_SMALLCAPS) Then $dwEffects = BitOR($dwEffects, $CFE_SMALLCAPS)
	If _IsBit($dwMask, $CFM_STRIKEOUT) Then $dwEffects = BitOR($dwEffects, $CFE_STRIKEOUT)
;~ 	If _IsBit($dwMask, $CFM_SUBSCRIPT) Then $dwEffects = BitOR($dwEffects, $CFE_SUBSCRIPT)
;~ 	If _IsBit($dwMask, $CFM_SUPERSCRIPT) Then $dwEffects = BitOR($dwEffects, $CFE_SUPERSCRIPT)
	If _IsBit($dwMask, $CFM_UNDERLINE) Then $dwEffects = BitOR($dwEffects, $CFE_UNDERLINE)


	If $crBackColor <> -1 Then $dwMask = BitOR($dwMask, $CFM_BACKCOLOR)
;~ The crTextColor member is valid unless the CFE_AUTOCOLOR flag is set in the dwEffects member.
	$dwMask = BitOR($dwMask, $CFM_COLOR)
;~ The szFaceName member is valid.
	$dwMask = BitOR($dwMask, $CFM_FACE)
;~ The yOffset member is valid.
	$dwMask = BitOR($dwMask, $CFM_OFFSET)
;~ The yHeight member is valid.
	$dwMask = BitOR($dwMask, $CFM_SIZE)
;~ The bUnderlineType member is valid.
	$dwMask = BitOR($dwMask, $CFM_UNDERLINETYPE)
;~ The wWeight member is valid.
	$dwMask = BitOR($dwMask, $CFM_WEIGHT)

	$a_sel = RichText_GetSel($h_RichEdit)
	If $a_sel[1] = $a_sel[2] Then
		$Format = $SCF_ALL
	Else
		$Format = $SCF_SELECTION
	EndIf
	$charformat_struct = DllStructCreate($charformat2_fmt)

	DllStructSetData($charformat_struct, 1, DllStructGetSize($charformat_struct))
	DllStructSetData($charformat_struct, 2, $dwMask)
	DllStructSetData($charformat_struct, 3, $dwEffects)
	DllStructSetData($charformat_struct, 4, $yHeight)
	DllStructSetData($charformat_struct, 5, $yOffset)
	DllStructSetData($charformat_struct, 6, $crTextColor)
	DllStructSetData($charformat_struct, 7, $bCharSet)
	DllStructSetData($charformat_struct, 8, $bPitchAndFamily)
	DllStructSetData($charformat_struct, 9, $szFaceName)
	DllStructSetData($charformat_struct, 10, $wWeight)
	If $crBackColor <> -1 Then DllStructSetData($charformat_struct, 12, $crBackColor)
	DllStructSetData($charformat_struct, 17, $bUnderlineType)
	
	$lResult = _SendMessage($h_RichEdit, $EM_SETCHARFORMAT, $Format, DllStructGetPtr($charformat_struct), 0, "int", "ptr")
	If @error Or $lResult = 0 Then
		Return SetError($EC_ERR, $EC_ERR, $EC_ERR)
	Else
		Return 1
	EndIf
EndFunc   ;==>_GUICtrlRichEditSetFormat

Func _IsBit($dwMask, $bit_check)
	If BitAND($dwMask, $bit_check) = $bit_check Then Return 1
	Return 0
EndFunc   ;==>_IsBit

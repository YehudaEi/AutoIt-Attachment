#include "objbase.au3"
#include <WinAPI.au3>

;funkey	2010, Dec 10th
;http://msdn.microsoft.com/en-us/library/bb775248(v=VS.85).aspx

Global Const $PROGDLG_NORMAL = 0x00000000 ;default normal progress dlg behavior
Global Const $PROGDLG_MODAL = 0x00000001 ; the dialog is modal to its hwndParent (default is modeless)
Global Const $PROGDLG_AUTOTIME = 0x00000002 ; automatically updates the "Line3" text with the "time remaining" (you cant call SetLine3 if you passs this!)
Global Const $PROGDLG_NOTIME = 0x00000004 ; we dont show the "time remaining" if this is set. We need this if dwTotal < dwCompleted for sparse files
Global Const $PROGDLG_NOMINIMIZE = 0x00000008 ; Do not have a minimize button in the caption bar.
Global Const $PROGDLG_NOPROGRESSBAR = 0x00000010 ; Don't display the progress bar
Global Const $PROGDLG_MARQUEEPROGRESS = 0x00000020 ; Vista and above only
Global Const $PROGDLG_NOCANCEL = 0x00000040 ; Vista and above only

Global Const $PDTIMER_RESET = 0x00000001
Global Const $PDTIMER_PAUSE = 0x00000002
Global Const $PDTIMER_RESUME = 0x00000003

Global Const $AVI_SEARCH = 150
Global Const $AVI_SEARCH_DOC = 151
Global Const $AVI_SEARCH_PC = 152
Global Const $AVI_MOVE = 160
Global Const $AVI_COPY = 161
Global Const $AVI_DELETE = 162
Global Const $AVI_EMPTY_RECYCLEBIN = 163
Global Const $AVI_DELETE_DIRECT = 164
Global Const $AVI_COPY_DOC = 165
Global Const $AVI_SEARCH_IE = 166
Global Const $AVI_MOVE_OLD = 167
Global Const $AVI_COPY_OLD = 168
Global Const $AVI_DELETE_DIRECT_OLD = 169
Global Const $AVI_DOWNLOAD = 170

Global $CLSID_ProgressDialog = _GUID("{F8383852-FCD3-11d1-A6B9-006097DF5BD4}")
Global $IID_ProgressDialog = _GUID("{EBBC7C04-315E-11d2-B62F-006097DF5BD4}")

Global $Dialog_vTable = $IUnknown_vTable & _
		"ptr StartProgressDialog;ptr StopProgressDialog;ptr SetTitle;ptr SetAnimation;ptr HasUserCancelled;" & _
		"ptr SetProgress;ptr SetProgress64;ptr SetLine;ptr SetCancelMsg;ptr Timer"

_OLEInitialize()

Global $aObj = _ObjCoCreateInstance($CLSID_ProgressDialog, $IID_ProgressDialog, $Dialog_vTable)

Global $hParent = HWnd(0)
Global $sTitle = "Copying..."
Global $dwFlags = $PROGDLG_NOMINIMIZE
Global $hInstAnimation = _WinAPI_GetModuleHandle("shell32.dll")
Global $idAnimation = $AVI_COPY
Global $dwCompleted = 0
Global $dwTotal = 600 ;1 minute every 100ms one percent
Global $dwTimerAction = $PDTIMER_PAUSE
Global $strCancelMsg = "Cancel Button pressed ;)"
Global $dwLineNum = 1
Global $strText = "A very big File.dat"
Global $fCompactPath = 0
Global $pvReserved = 0

_ObjFuncCall($HRESULT, $aObj, "SetTitle", "wstr", $sTitle)
_ObjFuncCall($HRESULT, $aObj, "SetAnimation", "handle", $hInstAnimation, "dword", $idAnimation)

_ObjFuncCall($HRESULT, $aObj, "SetCancelMsg", "wstr", $strCancelMsg, "dword", $pvReserved)

_ObjFuncCall($HRESULT, $aObj, "SetLine", "dword", $dwLineNum, "wstr", $strText, "long", $fCompactPath, "dword", $pvReserved)
$dwLineNum = 2
$strText = 'From "Folder" to "Folder_new"'
_ObjFuncCall($HRESULT, $aObj, "SetLine", "dword", $dwLineNum, "wstr", $strText, "long", $fCompactPath, "dword", $pvReserved)

_ObjFuncCall($HRESULT, $aObj, "StartProgressDialog", "hwnd", $hParent, "ptr", 0, "dword", $dwFlags, "ptr", 0)

;~ _ObjFuncCall($HRESULT, $aObj, "Timer", "dword", $dwTimerAction, "dword", $pvReserved)

AdlibRegister("_CountUp", 100)

Do
	Sleep(10)
	$Canceled = _ObjFuncCall($HRESULT, $aObj, "HasUserCancelled")
Until $Canceled[0] = 1 Or $dwCompleted = $dwTotal
Sleep(2000)

_ObjFuncCall($HRESULT, $aObj, "StopProgressDialog")
_OLEUnInitialize()
DllClose($OLE32)

Func _CountUp()
	$dwCompleted += 1
	_ObjFuncCall($HRESULT, $aObj, "SetProgress", "dword", $dwCompleted, "dword", $dwTotal)
EndFunc   ;==>_CountUp

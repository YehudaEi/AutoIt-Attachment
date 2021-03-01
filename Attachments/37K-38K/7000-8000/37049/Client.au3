#include <GDIPlus.au3>
#include <Memory.au3>

; Config
Global $sIPAddress = @IPAddress1
Global $nPort = 11224
Global $iX = 0
Global $iY = 0
Global $iW = Number(BinaryToString(InetRead('http://' & $sIPAddress & ':' & $nPort & '/GetDesktopWH W',1)))
Global $iH = Number(BinaryToString(InetRead('http://' & $sIPAddress & ':' & $nPort & '/GetDesktopWH H',1)))
Global $bCursor = True
Global $iQuality = 100

Global $hMain, $PicCtrl

_GDIPlus_Startup()
$hMain = GUICreate("Screen Receiver",800,600)
$PicCtrl = GUICtrlCreatePic('',0,0,800,600)
GUISetState(@SW_SHOW,$hMain)
AdlibRegister("GetScreen",250)

Do
	Sleep(10)
Until GUIGetMsg() = -3

AdlibUnRegister("GetScreen")
InetRead('http://' & $sIPAddress & ':' & $nPort & '/Quit',1)		; Command to close server - optional
_GDIPlus_Shutdown()

Func GetScreen()
	Local $bData = InetRead('http://' & $sIPAddress & ':' & $nPort & _
	'/Screen{' & $iX & ',' & $iY & ',' & $iW & ',' & $iH & ',' & $bCursor & ',' & $iQuality & '}',1)
	Local $iLen = BinaryLen($bData)
    Local $hMemory = _MemGlobalAlloc($iLen,$GMEM_MOVEABLE)
    Local $pMemory = _MemGlobalLock($hMemory)
    Local $tData = DllStructCreate("byte Bitmap[" & $iLen & "]",$pMemory)
    DllStructSetData($tData,"Bitmap",$bData)
    _MemGlobalUnlock($hMemory)
    Local $hStream = DllCall("ole32.dll","int","CreateStreamOnHGlobal","hwnd",$pMemory,"int",False,"ptr*",0)
    Local $hBitmap = DllCall($ghGDIPDll,"uint","GdipCreateBitmapFromStream","ptr",$hStream[3],"int*",0)
	Local $hGraphics = _GDIPlus_GraphicsCreateFromHWND($hMain)
	Local $hNew = _GDIPlus_BitmapCreateFromGraphics(800,600,$hGraphics)
	Local $hContext = _GDIPlus_ImageGetGraphicsContext($hNew)
	_GDIPlus_GraphicsDrawImageRect($hContext,$hBitmap[2],0,0,800,600)
	_GDIPlus_GraphicsDispose($hContext)
	_GDIPlus_GraphicsDispose($hGraphics)
	_GDIPlus_BitmapDispose($hBitmap[2])
	$hHBITMAP = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hNew)
	_WinAPI_DeleteObject(GUICtrlSendMsg($PicCtrl,0x0172,0,$hHBITMAP))
	_WinAPI_DeleteObject($hHBITMAP)
	_GDIPlus_BitmapDispose($hNew)
	_MemGlobalFree($hMemory)
EndFunc
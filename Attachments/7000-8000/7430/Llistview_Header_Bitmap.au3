#include <GUIConstants.au3>

Global Const $LVM_FIRST				= 0x1000
Global Const $LVM_GETHEADER			= $LVM_FIRST + 31

Global Const $HDM_FIRST				= 0x1200
Global Const $HDM_GETITEM			= $HDM_FIRST + 3
Global Const $HDM_SETITEM			= $HDM_FIRST + 4

Global Const $HDI_FORMAT			= 0x0004
Global Const $HDI_BITMAP			= 0x0010

Global Const $HDF_BITMAP			= 0x2000

Global Const $LR_LOADFROMFILE		= 0x0010

GUICreate('Test')

$LV = GuiCtrlCreateListView ('Color1|Color2|Color3', 10, 10, 200, 150)
$hLVBitmap1 = SetLVHeaderBitmap($LV, @ScriptDir & '\red.bmp', 40, 10, 0)
$hLVBitmap2 = SetLVHeaderBitmap($LV, @ScriptDir & '\green.bmp', 40, 10, 1)
$hLVBitmap3 = SetLVHeaderBitmap($LV, @ScriptDir & '\blue.bmp', 40, 10, 2)

GuiCtrlCreateListViewItem('Data11|Data12|Data13', $LV)
GuiCtrlCreateListViewItem('Data21|Data22|Data23', $LV)
GuiCtrlCreateListViewItem('Data31|Data32|Data33', $LV)

GuiSetState()

While 1
	$Msg = GuiGetMsg()
    If $Msg = $GUI_EVENT_CLOSE Then ExitLoop
WEnd

DllCall('gdi32.dll', 'int', 'DeleteObject', 'hwnd', $hLVBitmap1)
DllCall('gdi32.dll', 'int', 'DeleteObject', 'hwnd', $hLVBitmap2)
DllCall('gdi32.dll', 'int', 'DeleteObject', 'hwnd', $hLVBitmap3)
	
Exit


Func SetLVHeaderBitmap($nLV, $sFile, $nWidth, $nHeight, $nColumn)
	Local $hLVHeader = GUICtrlSendMsg($nLV, $LVM_GETHEADER, 0, 0)
	
	Local $hBitmap = DllCall('user32.dll', 'hwnd', 'LoadImage', _
											'hwnd', 0, _
											'str', $sFile, _
											'int', 0, _
											'int', $nWidth, _
											'int', $nHeight, _
											'int', $LR_LOADFROMFILE)
											
	Local $stHDITEM = DllStructCreate('uint;int;ptr;uint;int;int;uint;int;int')
	
	
	#cs
	; Stored formats and bitmap format
	DllStructSetData($stHDITEM, 1, BitOr($HDI_FORMAT, $HDI_BITMAP))
	DllCall('user32.dll', 'int', 'SendMessage', 'hwnd', $hLVHeader, 'int', $HDM_GETITEM, 'int', 1, 'ptr', DllStructGetPtr($stHDITEM))
	
	DllStructSetData($stHDITEM, 1, BitOr($HDI_FORMAT, $HDI_BITMAP))
	DllStructSetData($stHDITEM, 4, $hBitmap[0])
	DllStructSetData($stHDITEM, 6, BitOr(DllStructGetData($stHDITEM, 6), $HDF_BITMAP))
	#ce

	; Only bitmap in header
	DllStructSetData($stHDITEM, 1, BitOr($HDI_FORMAT, $HDI_BITMAP))
	DllStructSetData($stHDITEM, 4, $hBitmap[0])
	DllStructSetData($stHDITEM, 6, $HDF_BITMAP)
		
	$result = DllCall('user32.dll', 'int', 'SendMessage', 'hwnd', $hLVHeader, 'int', $HDM_SETITEM, 'int', $nColumn, 'ptr', DllStructGetPtr($stHDITEM))
	
	Return $hBitmap[0]
EndFunc
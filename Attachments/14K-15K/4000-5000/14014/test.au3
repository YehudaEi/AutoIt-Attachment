#include <A3LImageList.au3>
#include <A3LListView.au3>
Global $hGUI, $hList, $iI, $iTimer
$hGUI  = GUICreate("ListView", 400, 300)
$hList = _ListView_Create($hGUI, 2, 2, 394, 268)
GUISetState()
_ListView_AddColumn($hList, "Items"     , 100)
_ListView_AddColumn($hList, "SubItems 1", 100)
_ListView_AddColumn($hList, "SubItems 2", 100)
_ListView_AddColumn($hList, "SubItems 3", 100)
Dim $aItems[5000][1]
for $iI = 0 to UBound($aItems) - 1
  $aItems[$iI][0] = "Item " & $iI
next
$iTimer = TimerInit()
_ListView_AddArray($hList, $aItems)
_Lib_ShowMsg("Load time: " & TimerDiff($iTimer) / 1000 & " seconds")
_ListView_DeleteAllItems($hList)
Dim $aItems[5000][4]
for $iI = 0 to UBound($aItems) - 1
  $aItems[$iI][0] = "Item " & $iI
  $aItems[$iI][1] = "Item " & $iI & "-1"
  $aItems[$iI][2] = "Item " & $iI & "-2"
  $aItems[$iI][3] = "Item " & $iI & "-3"
next
$iTimer = TimerInit()
_ListView_AddArray($hList, $aItems)
_Lib_ShowMsg("Load time: " & TimerDiff($iTimer) / 1000 & " seconds")
do
until GUIGetMsg() = $GUI_EVENT_CLOSE



#cs
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LImageList.au3(2,10) : ERROR: can't open include file <A3LWinAPI.au3>
#include <A3LWinAPI.au3>
~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LImageList.au3(175,53) : WARNING: $IMAGE_BITMAP: possibly used before declaration.
  $hImage = _API_LoadImage(0, $sImage, $IMAGE_BITMAP,
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LImageList.au3(175,93) : WARNING: $LR_LOADFROMFILE: possibly used before declaration.
  $hImage = _API_LoadImage(0, $sImage, $IMAGE_BITMAP, $aSize[0], $aSize[1], $LR_LOADFROMFILE)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LImageList.au3(375,39) : WARNING: $tagPOINT: possibly used before declaration.
  $tPoint  = DllStructCreate($tagPOINT)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(2,10) : ERROR: can't open include file <A3LHeader.au3>
#include <A3LHeader.au3>
~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(3,10) : ERROR: can't open include file <A3LMemory.au3>
#include <A3LMemory.au3>
~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(926,47) : WARNING: $WM_SETREDRAW: possibly used before declaration.
  Return _API_SendMessage($hWnd, $WM_SETREDRAW,
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(1005,37) : WARNING: $WS_CHILD: possibly used before declaration.
  $iStyle = BitOR($iStyle, $WS_CHILD,
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(1005,50) : WARNING: $WS_VISIBLE: possibly used before declaration.
  $iStyle = BitOR($iStyle, $WS_CHILD, $WS_VISIBLE)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(1008,61) : WARNING: $DEFAULT_GUI_FONT: possibly used before declaration.
  _Lib_SetFont($hList, _API_GetStockObject($DEFAULT_GUI_FONT)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(1200,53) : WARNING: $LVM_FINDITEM: possibly used before declaration.
    $iResult = _API_SendMessage($hWnd, $LVM_FINDITEM,
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(1238,48) : WARNING: $VK_LEFT: possibly used before declaration.
  Local $tFindInfo, $iFlags, $aDir[8]=[$VK_LEFT,
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(1238,59) : WARNING: $VK_RIGHT: possibly used before declaration.
  Local $tFindInfo, $iFlags, $aDir[8]=[$VK_LEFT, $VK_RIGHT,
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(1238,67) : WARNING: $VK_UP: possibly used before declaration.
  Local $tFindInfo, $iFlags, $aDir[8]=[$VK_LEFT, $VK_RIGHT, $VK_UP,
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(1238,77) : WARNING: $VK_DOWN: possibly used before declaration.
  Local $tFindInfo, $iFlags, $aDir[8]=[$VK_LEFT, $VK_RIGHT, $VK_UP, $VK_DOWN,
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(1238,96) : WARNING: $VK_END: possibly used before declaration.
  Local $tFindInfo, $iFlags, $aDir[8]=[$VK_LEFT, $VK_RIGHT, $VK_UP, $VK_DOWN, $VK_HOME, $VK_END,
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(1238,107) : WARNING: $VK_PRIOR: possibly used before declaration.
  Local $tFindInfo, $iFlags, $aDir[8]=[$VK_LEFT, $VK_RIGHT, $VK_UP, $VK_DOWN, $VK_HOME, $VK_END, $VK_PRIOR,
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(1238,117) : WARNING: $VK_NEXT: possibly used before declaration.
  Local $tFindInfo, $iFlags, $aDir[8]=[$VK_LEFT, $VK_RIGHT, $VK_UP, $VK_DOWN, $VK_HOME, $VK_END, $VK_PRIOR, $VK_NEXT]
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(1242,55) : WARNING: $LVFI_WRAP: possibly used before declaration.
  if $fWrapOK then $iFlags = BitOR($iFlags, $LVFI_WRAP)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(1290,28) : WARNING: $LVFI_STRING: possibly used before declaration.
  $iFlags    = $LVFI_STRING
~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(1291,61) : WARNING: $LVFI_PARTIAL: possibly used before declaration.
  if $fPartialOK then $iFlags = BitOR($iFlags, $LVFI_PARTIAL)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(1758,36) : WARNING: $tagRECT: possibly used before declaration.
  $tRect = DllStructCreate($tagRECT)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(1890,53) : WARNING: $GWL_EXSTYLE: possibly used before declaration.
  $iExStyle = _API_GetWindowLong($hWnd, $GWL_EXSTYLE)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(4260,38) : WARNING: $tagNMHDR: possibly used before declaration.
  $tNMHDR = DllStructCreate($tagNMHDR,
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(4291,24) : WARNING: $GUI_RUNDEFMSG: possibly used before declaration.
  Return $GUI_RUNDEFMSG
~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\test.au3(30,21) : WARNING: $GUI_EVENT_CLOSE: possibly used before declaration.
until GUIGetMsg() = $GUI_EVENT_CLOSE
~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LImageList.au3(175,53) : ERROR: $IMAGE_BITMAP: undeclared global variable.
  $hImage = _API_LoadImage(0, $sImage, $IMAGE_BITMAP,
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LImageList.au3(175,93) : ERROR: _API_LoadImage(): undefined function.
  $hImage = _API_LoadImage(0, $sImage, $IMAGE_BITMAP, $aSize[0], $aSize[1], $LR_LOADFROMFILE)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LImageList.au3(176,57) : ERROR: _API_GetLastError(): undefined function.
  if $hImage = 0 then Return SetError(_API_GetLastError()
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LImageList.au3(183,28) : ERROR: _API_DeleteObject(): undefined function.
  _API_DeleteObject($hImage)
~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LImageList.au3(203,79) : ERROR: _API_ExtractIconEx(): undefined function.
  $iResult = _API_ExtractIconEx($sFile, $iIndex, 0, DllStructGetPtr($tIcon), 1)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LImageList.au3(204,55) : ERROR: _Lib_Check(): undefined function.
  _Lib_Check("_ImageList_AddIcon", ($iResult <= 0), -1)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LImageList.au3(209,26) : ERROR: _API_DestroyIcon(): undefined function.
  _API_DestroyIcon($hIcon)
~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(716,26) : ERROR: _Lib_InProcess(): undefined function.
  if _Lib_InProcess($hWnd)
~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(721,57) : ERROR: _API_SendMessage(): undefined function.
      _API_SendMessage($hWnd, $LVM_INSERTITEM, 0, $pItem)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(730,56) : ERROR: _Mem_Init(): undefined function.
    $pMemory = _Mem_Init($hWnd, $iItem + 4096, $tMemMap)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(737,54) : ERROR: _Mem_Write(): undefined function.
      _Mem_Write($tMemMap, $pItem  , $pMemory, $iItem)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(748,23) : ERROR: _Mem_Free(): undefined function.
    _Mem_Free($tMemMap)
~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(848,105) : ERROR: _Lib_MakeLong(): undefined function.
  Return _Lib_HiWord(_API_SendMessage($hWnd, $LVM_APPROXIMATEVIEWRECT, $iCount, _Lib_MakeLong($iCX, $iCY)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(848,107) : ERROR: _Lib_HiWord(): undefined function.
  Return _Lib_HiWord(_API_SendMessage($hWnd, $LVM_APPROXIMATEVIEWRECT, $iCount, _Lib_MakeLong($iCX, $iCY)))
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(872,33) : ERROR: _Lib_LoWord(): undefined function.
  $aView[0] = _Lib_LoWord($iView)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(960,44) : ERROR: _Lib_PointFromRect(): undefined function.
  $tPoint = _Lib_PointFromRect($tRect, True)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(961,47) : ERROR: _API_ClientToScreen(): undefined function.
  $tPoint = _API_ClientToScreen($hWnd, $tPoint)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(962,40) : ERROR: _Lib_GetXYFromPoint(): undefined function.
  _Lib_GetXYFromPoint($tPoint, $iX, $iY)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(963,77) : ERROR: _Lib_MouseClick(): undefined function.
  _Lib_MouseClick($sButton, $iX, $iY, $fMove, $iClicks, $iSpeed, $fPopupScan)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(1006,99) : ERROR: _API_CreateWindowEx(): undefined function.
  $hList = _API_CreateWindowEx(0, "SysListView32", "", $iStyle, $iX, $iY, $iWidth, $iHeight, $hWnd)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(1008,61) : ERROR: _API_GetStockObject(): undefined function.
  _Lib_SetFont($hList, _API_GetStockObject($DEFAULT_GUI_FONT)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(1008,62) : ERROR: _Lib_SetFont(): undefined function.
  _Lib_SetFont($hList, _API_GetStockObject($DEFAULT_GUI_FONT))
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(1088,22) : ERROR: _API_SetFocus(): undefined function.
  _API_SetFocus($hWnd)
~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(1343,52) : ERROR: _Mem_Read(): undefined function.
    _Mem_Read($tMemMap, $pMemory, $pImage , $iImage)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(1463,57) : ERROR: _Header_GetItemCount(): undefined function.
  Return _Header_GetItemCount(_ListView_GetHeader($hWnd))
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(1602,49) : ERROR: _API_WideCharToMultiByte(): undefined function.
  $aGroup[1] = _API_WideCharToMultiByte($tHeader)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(1890,53) : ERROR: _API_GetWindowLong(): undefined function.
  $iExStyle = _API_GetWindowLong($hWnd, $GWL_EXSTYLE)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(2751,55) : ERROR: _Lib_GetMousePosX(): undefined function.
  if $iX = -1 then $iX = _Lib_GetMousePosX(True, $hWnd)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(2752,55) : ERROR: _Lib_GetMousePosY(): undefined function.
  if $iY = -1 then $iY = _Lib_GetMousePosY(True, $hWnd)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(2884,47) : ERROR: _API_MultiByteToWideChar(): undefined function.
  $tHeader = _API_MultiByteToWideChar($sHeader)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(3132,28) : ERROR: _API_InvalidateRect(): undefined function.
  _API_InvalidateRect($hWnd)
~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(3363,53) : ERROR: _API_SetWindowLong(): undefined function.
  _API_SetWindowLong ($hWnd, $GWL_EXSTYLE, $iExStyle)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(4265,71) : ERROR: _Lib_WM_NOTIFY_EX(): undefined function.
    case _Lib_WM_NOTIFY_EX("TVN_SELCHANGING"    , $hFrom, $iID, $iCode)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\A3LListView.au3(4289,54) : ERROR: _Lib_WM_NOTIFY(): undefined function.
      _Lib_WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\test.au3(17,68) : ERROR: _Lib_ShowMsg(): undefined function.
_Lib_ShowMsg("Load time: " & TimerDiff($iTimer) / 1000 & " seconds")
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^
C:\Documents and Settings\admin\Desktop\msi\software\Total Task Manager\TTM 2\test.au3 - 38 error(s), 23 warning(s)
#ce
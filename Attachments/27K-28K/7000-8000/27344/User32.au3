#include-once

Global Const $User32 = DllOpen("User32.dll")


func _User32_ReleaseDC(  $hWnd, $hDC  )
	local $vRetVal = DllCall($User32,"int","ReleaseDC","hwnd",$hWnd,"hwnd",$hDC)
	return $vRetVal[0]
EndFunc

func _User32_GetDC(  $hWnd  )
	local $vRetVal = DllCall($User32,"hwnd","GetDC","hwnd",$hWnd)
	return $vRetVal[0]
EndFunc

func _User32_GetWindowLong(  $hWnd, $nIndex  )
	local $vRetVal = DllCall($User32,"LONG","GetWindowLong","hwnd",$hWnd,"int",$nIndex)
	return $vRetVal[0]
EndFunc

func _User32_DispatchMessage(  $lpmsg  )
	local $vRetVal = DllCall($User32,"LRESULT","DispatchMessage","ptr",$lpmsg)
	return $vRetVal[0]
EndFunc

func _User32_GetWindowThreadProcessId(  $hWnd, $lpdwProcessId  )
	local $vRetVal = DllCall($User32,"DWORD","GetWindowThreadProcessId","hwnd",$hWnd,"ptr",$lpdwProcessId)
	return $vRetVal[0]
EndFunc

func _User32_TranslateMessage(  $lpMsg  )
	local $vRetVal = DllCall($User32,"int","TranslateMessage","ptr",$lpMsg)
	return $vRetVal[0]
EndFunc

func _User32_SetTimer(  $hWnd, $nIDEvent, $uElapse, $lpTimerfunc )
	local $vRetVal = DllCall($User32,"UINT_PTR","SetTimer","hwnd",$hWnd,"UINT_PTR",$nIDEvent,"UINT",$uElapse,"ptr",$lpTimerFunc)
	return $vRetVal[0]
EndFunc

func _User32_KillTimer(  $hWnd, $uIDEvent  )
	local $vRetVal = DllCall($User32,"int","KillTimer","hwnd",$hWnd,"UINT_PTR",$uIDEvent)
	return $vRetVal[0]
EndFunc

func _User32_PostMessage(  $hWnd, $Msg, $wParam, $lParam  )
	local $vRetVal = DllCall($User32,"int","PostMessage","hwnd",$hWnd,"UINT",$Msg,"WPARAM",$wParam,"ptr",$lParam)
	return $vRetVal[0]
EndFunc

func _User32_GetUserObjectInformation(  $hObj, $nIndex, $pvInfo, $nLength, $lpnLengthNeeded  )
	local $vRetVal = DllCall($User32,"int","GetUserObjectInformation","hwnd",$hObj,"int",$nIndex,"ptr",$pvInfo,"DWORD",$nLength,"ptr",$lpnLengthNeeded)
	return $vRetVal[0]
EndFunc

func _User32_CharUpper(  $lpsz  )
	local $vRetVal = DllCall($User32,"str","CharUpper","str",$lpsz)
	return $vRetVal[0]
EndFunc

func _User32_RegisterClipboardFormat(  $lpszFormat  )
	local $vRetVal = DllCall($User32,"UINT","RegisterClipboardFormat","str",$lpszFormat)
	return $vRetVal[0]
EndFunc

func _User32_GetSysColor(  $nIndex  )
	local $vRetVal = DllCall($User32,"DWORD","GetSysColor","int",$nIndex)
	return $vRetVal[0]
EndFunc

func _User32_GetSysColorBrush(  $nIndex  )
	local $vRetVal = DllCall($User32,"hwnd","GetSysColorBrush","int",$nIndex)
	return $vRetVal[0]
EndFunc

func _User32_GetSystemMetrics(  $nIndex  )
	local $vRetVal = DllCall($User32,"int","GetSystemMetrics","int",$nIndex)
	return $vRetVal[0]
EndFunc

func _User32_GetWindowDC(  $hWnd  )
	local $vRetVal = DllCall($User32,"hwnd","GetWindowDC","hwnd",$hWnd)
	return $vRetVal[0]
EndFunc

func _User32_SetScrollInfo(  $hwnd, $fnBar, $lpsi, $fRedraw  )
	local $vRetVal = DllCall($User32,"int","SetScrollInfo","hwnd",$hwnd,"int",$fnBar,"ptr",$lpsi,"int",$fRedraw)
	return $vRetVal[0]
EndFunc

func _User32_GetProcessWindowStation(  )
	local $vRetVal = DllCall($User32,"hwnd","GetProcessWindowStation")
	return $vRetVal[0]
EndFunc

func _User32_GetMessage(  $lpMsg, $hWnd, $wMsgFilterMin, $wMsgFilterMax  )
	local $vRetVal = DllCall($User32,"int","GetMessage","ptr",$lpMsg,"hwnd",$hWnd,"UINT",$wMsgFilterMin,"UINT",$wMsgFilterMax)
	return $vRetVal[0]
EndFunc

func _User32_CharUpperBuff(  $lpsz, $cchLength  )
	local $vRetVal = DllCall($User32,"DWORD","CharUpperBuff","str",$lpsz,"DWORD",$cchLength)
	return $vRetVal[0]
EndFunc

func _User32_GetShellWindow(  )
	local $vRetVal = DllCall($User32,"hwnd","GetShellWindow")
	return $vRetVal[0]
EndFunc

func _User32_PeekMessage(  $lpMsg, $hWnd, $wMsgFilterMin, $wMsgFilterMax, $wRemoveMsg  )
	local $vRetVal = DllCall($User32,"int","PeekMessage","ptr",$lpMsg,"hwnd",$hWnd,"UINT",$wMsgFilterMin,"UINT",$wMsgFilterMax,"UINT",$wRemoveMsg)
	return $vRetVal[0]
EndFunc

func _User32_WaitMessage(  )
	local $vRetVal = DllCall($User32,"int","WaitMessage")
	return $vRetVal[0]
EndFunc

func _User32_TranslateAccelerator(  $hWnd, $hAccTable, $lpMsg  )
	local $vRetVal = DllCall($User32,"int","TranslateAccelerator","hwnd",$hWnd,"hwnd",$hAccTable,"ptr",$lpMsg)
	return $vRetVal[0]
EndFunc

func _User32_GetCapture(  )
	local $vRetVal = DllCall($User32,"hwnd","GetCapture")
	return $vRetVal[0]
EndFunc

func _User32_GetLastInputInfo(  $plii  )
	local $vRetVal = DllCall($User32,"int","GetLastInputInfo","int",$plii)
	return $vRetVal[0]
EndFunc

func _User32_MsgWaitForMultipleObjectsEx(  $nCount, $pHandles, $dwMilliseconds, $dwWakeMask, $dwFlags  )
	local $vRetVal = DllCall($User32,"DWORD","MsgWaitForMultipleObjectsEx","DWORD",$nCount,"hwnd*",$pHandles,"DWORD",$dwMilliseconds,"DWORD",$dwWakeMask,"DWORD",$dwFlags)
	return $vRetVal[0]
EndFunc

func _User32_MsgWaitForMultipleObjects(  $nCount, $pHandles, $bWaitAll, $dwMilliseconds, $dwWakeMask  )
	local $vRetVal = DllCall($User32,"DWORD","MsgWaitForMultipleObjects","DWORD",$nCount,"hwnd*",$pHandles,"int",$bWaitAll,"DWORD",$dwMilliseconds,"DWORD",$dwWakeMask)
	return $vRetVal[0]
EndFunc

func _User32_IsChild(  $hWndParent, $hWnd  )
	local $vRetVal = DllCall($User32,"int","IsChild","hwnd",$hWndParent,"hwnd",$hWnd)
	return $vRetVal[0]
EndFunc

func _User32_GetThreadDesktop(  $dwThreadId  )
	local $vRetVal = DllCall($User32,"hwnd","GetThreadDesktop","DWORD",$dwThreadId)
	return $vRetVal[0]
EndFunc

func _User32_UnregisterClass(  $lpClassName, $hInstance  )
	local $vRetVal = DllCall($User32,"int","UnregisterClass","str",$lpClassName,"hwnd",$hInstance)
	return $vRetVal[0]
EndFunc

func _User32_LoadCursor(  $hInstance, $lpCursorName  )
	local $vRetVal = DllCall($User32,"hwnd","LoadCursor","hwnd",$hInstance,"str",$lpCursorName)
	return $vRetVal[0]
EndFunc

func _User32_LoadString(  $hInstance, $uID, $lpBuffer, $nBufferMax  )
	local $vRetVal = DllCall($User32,"int","LoadString","hwnd",$hInstance,"UINT",$uID,"str",$lpBuffer,"int",$nBufferMax)
	return $vRetVal[0]
EndFunc

func _User32_CharLowerBuff(  $lpsz, $cchLength  )
	local $vRetVal = DllCall($User32,"DWORD","CharLowerBuff","str",$lpsz,"DWORD",$cchLength)
	return $vRetVal[0]
EndFunc

func _User32_SystemParametersInfo(  $uiAction, $uiParam, $pvParam, $fWinIni  )
	local $vRetVal = DllCall($User32,"int","SystemParametersInfo","UINT",$uiAction,"UINT",$uiParam,"ptr",$pvParam,"UINT",$fWinIni)
	return $vRetVal[0]
EndFunc

func _User32_RegisterClass(  $lpWndClass  )
	local $vRetVal = DllCall($User32,"dword","RegisterClass","ptr",$lpWndClass)
	return $vRetVal[0]
EndFunc

func _User32_wvsprintf(  $lpOutput, $lpFmt, $arglist  )
	local $vRetVal = DllCall($User32,"int","wvsprintf","str",$lpOutput,"str",$lpFmt,"ptr",$arglist)
	return $vRetVal[0]
EndFunc

func _User32_wsprintf(  $lpOut, $lpFmt  )
	local $vRetVal = DllCall($User32,"int","wsprintf","str",$lpOut,"str",$lpFmt)
	return $vRetVal[0]
EndFunc

func _User32_CharToOem(  $lpszSrc, $lpszDst  )
	local $vRetVal = DllCall($User32,"int","CharToOem","str",$lpszSrc,"str",$lpszDst)
	return $vRetVal[0]
EndFunc

func _User32_RegisterClassEx(  $lpwcx  )
	local $vRetVal = DllCall($User32,"dword","RegisterClassEx","int*",$lpwcx)
	return $vRetVal[0]
EndFunc

func _User32_IsWinEventHookInstalled(  $event  )
	local $vRetVal = DllCall($User32,"int","IsWinEventHookInstalled","DWORD",$event)
	return $vRetVal[0]
EndFunc

func _User32_ScrollDC(  $hDC, $dx, $dy, $lprcScroll, $lprcClip, $hrgnUpdate, $lprcUpdate  )
	local $vRetVal = DllCall($User32,"int","ScrollDC","hwnd",$hDC,"int",$dx,"int",$dy,"ptr",$lprcScroll,"ptr",$lprcClip,"hwnd",$hrgnUpdate,"ptr",$lprcUpdate)
	return $vRetVal[0]
EndFunc

func _User32_DefWindowProc(  $hWnd, $Msg, $wParam, $lParam  )
	local $vRetVal = DllCall($User32,"LRESULT","DefWindowProc","hwnd",$hWnd,"UINT",$Msg,"WPARAM",$wParam,"ptr",$lParam)
	return $vRetVal[0]
EndFunc

func _User32_IntersectRect(  $lprcDst, $lprcSrc1, $lprcSrc2  )
	local $vRetVal = DllCall($User32,"int","IntersectRect","ptr",$lprcDst,"ptr",$lprcSrc1,"ptr",$lprcSrc2)
	return $vRetVal[0]
EndFunc

func _User32_SetRect(  $lprc, $xLeft, $yTop, $xRight, $yBottom  )
	local $vRetVal = DllCall($User32,"int","SetRect","ptr",$lprc,"int",$xLeft,"int",$yTop,"int",$xRight,"int",$yBottom)
	return $vRetVal[0]
EndFunc

func _User32_InvalidateRect(  $hWnd, $lpRect, $bErase  )
	local $vRetVal = DllCall($User32,"int","InvalidateRect","hwnd",$hWnd,"ptr",$lpRect,"int",$bErase)
	return $vRetVal[0]
EndFunc

func _User32_BeginPaint(  $hwnd, $lpPaint  )
	local $vRetVal = DllCall($User32,"hwnd","BeginPaint","hwnd",$hwnd,"ptr",$lpPaint)
	return $vRetVal[0]
EndFunc

func _User32_EndPaint(  $hWnd, $lpPaint  )
	local $vRetVal = DllCall($User32,"int","EndPaint","hwnd",$hWnd,"ptr*",$lpPaint)
	return $vRetVal[0]
EndFunc

func _User32_OffsetRect(  $lprc, $dx, $dy  )
	local $vRetVal = DllCall($User32,"int","OffsetRect","ptr",$lprc,"int",$dx,"int",$dy)
	return $vRetVal[0]
EndFunc

func _User32_GetClientRect(  $hWnd, $lpRect  )
	local $vRetVal = DllCall($User32,"int","GetClientRect","hwnd",$hWnd,"ptr",$lpRect)
	return $vRetVal[0]
EndFunc

func _User32_GetWindowRect(  $hWnd, $lpRect  )
	local $vRetVal = DllCall($User32,"int","GetWindowRect","hwnd",$hWnd,"ptr",$lpRect)
	return $vRetVal[0]
EndFunc

func _User32_GetParent(  $hWnd  )
	local $vRetVal = DllCall($User32,"hwnd","GetParent","hwnd",$hWnd)
	return $vRetVal[0]
EndFunc

func _User32_SendMessage(  $hWnd, $Msg, $wParam, $lParam  )
	local $vRetVal = DllCall($User32,"LRESULT","SendMessage","hwnd",$hWnd,"UINT",$Msg,"WPARAM",$wParam,"ptr",$lParam)
	return $vRetVal[0]
EndFunc

func _User32_IsWindow(  $hWnd  )
	local $vRetVal = DllCall($User32,"int","IsWindow","hwnd",$hWnd)
	return $vRetVal[0]
EndFunc

func _User32_GetProp(  $hWnd, $lpString  )
	local $vRetVal = DllCall($User32,"hwnd","GetProp","hwnd",$hWnd,"str",$lpString)
	return $vRetVal[0]
EndFunc

func _User32_MapWindowPoints(  $hWndFrom, $hWndTo, $lpPoints, $cPoints  )
	local $vRetVal = DllCall($User32,"int","MapWindowPoints","hwnd",$hWndFrom,"hwnd",$hWndTo,"ptr",$lpPoints,"UINT",$cPoints)
	return $vRetVal[0]
EndFunc

func _User32_SetWindowText(  $hWnd, $lpString  )
	local $vRetVal = DllCall($User32,"int","SetWindowText","hwnd",$hWnd,"str",$lpString)
	return $vRetVal[0]
EndFunc

func _User32_GetWindow(  $hWnd, $uCmd  )
	local $vRetVal = DllCall($User32,"hwnd","GetWindow","hwnd",$hWnd,"UINT",$uCmd)
	return $vRetVal[0]
EndFunc

func _User32_PtInRect(  $lprc, $pt  )
	local $vRetVal = DllCall($User32,"int","PtInRect","ptr",$lprc,"ptr",$pt)
	return $vRetVal[0]
EndFunc

func _User32_GetCursorPos(  $lpPoint  )
	local $vRetVal = DllCall($User32,"int","GetCursorPos","ptr",$lpPoint)
	return $vRetVal[0]
EndFunc

func _User32_WindowFromPoint(  $Point  )
	local $vRetVal = DllCall($User32,"hwnd","WindowFromPoint","ptr",$Point)
	return $vRetVal[0]
EndFunc

func _User32_IsWindowEnabled(  $hWnd  )
	local $vRetVal = DllCall($User32,"int","IsWindowEnabled","hwnd",$hWnd)
	return $vRetVal[0]
EndFunc

func _User32_ScreenToClient(  $hWnd, $lpPoint  )
	local $vRetVal = DllCall($User32,"int","ScreenToClient","hwnd",$hWnd,"ptr",$lpPoint)
	return $vRetVal[0]
EndFunc

func _User32_IsIconic(  $hWnd  )
	local $vRetVal = DllCall($User32,"int","IsIconic","hwnd",$hWnd)
	return $vRetVal[0]
EndFunc

func _User32_GetForegroundWindow(  )
	local $vRetVal = DllCall($User32,"hwnd","GetForegroundWindow")
	return $vRetVal[0]
EndFunc

func _User32_EnableWindow(  $hWnd, $bEnable  )
	local $vRetVal = DllCall($User32,"int","EnableWindow","hwnd",$hWnd,"int",$bEnable)
	return $vRetVal[0]
EndFunc

func _User32_GetFocus(  )
	local $vRetVal = DllCall($User32,"hwnd","GetFocus")
	return $vRetVal[0]
EndFunc

func _User32_InflateRect(  $lprc, $dx, $dy  )
	local $vRetVal = DllCall($User32,"int","InflateRect","ptr",$lprc,"int",$dx,"int",$dy)
	return $vRetVal[0]
EndFunc

func _User32_IsRectEmpty(  $lprc  )
	local $vRetVal = DllCall($User32,"int","IsRectEmpty","ptr",$lprc)
	return $vRetVal[0]
EndFunc

func _User32_SetCursor(  $hCursor  )
	local $vRetVal = DllCall($User32,"hwnd","SetCursor","hwnd",$hCursor)
	return $vRetVal[0]
EndFunc

func _User32_RedrawWindow(  $hWnd, $lprcUpdate, $hrgnUpdate, $flags  )
	local $vRetVal = DllCall($User32,"int","RedrawWindow","hwnd",$hWnd,"ptr",$lprcUpdate,"hwnd",$hrgnUpdate,"UINT",$flags)
	return $vRetVal[0]
EndFunc

func _User32_GetMessagePos(  )
	local $vRetVal = DllCall($User32,"DWORD","GetMessagePos")
	return $vRetVal[0]
EndFunc

func _User32_NotifyWinEvent(  $event, $hwnd, $idObject, $idChild  )
	local $vRetVal = DllCall($User32,"none","NotifyWinEvent","DWORD",$event,"hwnd",$hwnd,"LONG",$idObject,"LONG",$idChild)
	return $vRetVal[0]
EndFunc

func _User32_SetWindowPos(  $hWnd, $hWndInsertAfter, $X, $Y, $cx, $cy, $uFlags  )
	local $vRetVal = DllCall($User32,"int","SetWindowPos","hwnd",$hWnd,"hwnd",$hWndInsertAfter,"int",$X,"int",$Y,"int",$cx,"int",$cy,"UINT",$uFlags)
	return $vRetVal[0]
EndFunc

func _User32_GetClassLong(  $hWnd, $nIndex  )
	local $vRetVal = DllCall($User32,"DWORD","GetClassLong","hwnd",$hWnd,"int",$nIndex)
	return $vRetVal[0]
EndFunc

func _User32_ClientToScreen(  $hWnd, $lpPoint  )
	local $vRetVal = DllCall($User32,"int","ClientToScreen","hwnd",$hWnd,"ptr",$lpPoint)
	return $vRetVal[0]
EndFunc

func _User32_GetKeyboardLayout(  $idThread  )
	local $vRetVal = DllCall($User32,"hwnd","GetKeyboardLayout","DWORD",$idThread)
	return $vRetVal[0]
EndFunc

func _User32_DestroyCaret(  )
	local $vRetVal = DllCall($User32,"int","DestroyCaret")
	return $vRetVal[0]
EndFunc

func _User32_GetKeyboardLayoutList(  $nBuff, $lpList  )
	local $vRetVal = DllCall($User32,"UINT","GetKeyboardLayoutList","int",$nBuff,"hwnd*",$lpList)
	return $vRetVal[0]
EndFunc

func _User32_FillRect(  $hDC, $lprc, $hbr  )
	local $vRetVal = DllCall($User32,"int","FillRect","hwnd",$hDC,"ptr",$lprc,"hwnd",$hbr)
	return $vRetVal[0]
EndFunc

func _User32_IsZoomed(  $hWnd  )
	local $vRetVal = DllCall($User32,"int","IsZoomed","hwnd",$hWnd)
	return $vRetVal[0]
EndFunc

func _User32_SetRectEmpty(  $lprc  )
	local $vRetVal = DllCall($User32,"int","SetRectEmpty","ptr",$lprc)
	return $vRetVal[0]
EndFunc

func _User32_GetClassName(  $hWnd, $lpClassName, $nMaxCount  )
	local $vRetVal = DllCall($User32,"int","GetClassName","hwnd",$hWnd,"str",$lpClassName,"int",$nMaxCount)
	return $vRetVal[0]
EndFunc

func _User32_GetMessageTime(  )
	local $vRetVal = DllCall($User32,"LONG","GetMessageTime")
	return $vRetVal[0]
EndFunc

func _User32_IsWindowVisible(  $hWnd  )
	local $vRetVal = DllCall($User32,"int","IsWindowVisible","hwnd",$hWnd)
	return $vRetVal[0]
EndFunc

func _User32_EqualRect(  $lprc1, $lprc2  )
	local $vRetVal = DllCall($User32,"int","EqualRect","ptr",$lprc1,"ptr",$lprc2)
	return $vRetVal[0]
EndFunc

func _User32_GetKeyState(  $nVirtKey  )
	local $vRetVal = DllCall($User32,"SHORT","GetKeyState","int",$nVirtKey)
	return $vRetVal[0]
EndFunc

func _User32_IsWindowUnicode(  $hWnd  )
	local $vRetVal = DllCall($User32,"int","IsWindowUnicode","hwnd",$hWnd)
	return $vRetVal[0]
EndFunc

func _User32_CallWindowProc(  $lpPrevWndFunc, $hWnd, $Msg, $wParam, $lParam  )
	local $vRetVal = DllCall($User32,"LRESULT","CallWindowProc","ptr",$lpPrevWndFunc,"hwnd",$hWnd,"UINT",$Msg,"WPARAM",$wParam,"ptr",$lParam)
	return $vRetVal[0]
EndFunc

func _User32_CopyRect(  $lprcDst, $lprcSrc  )
	local $vRetVal = DllCall($User32,"int","CopyRect","ptr",$lprcDst,"ptr",$lprcSrc)
	return $vRetVal[0]
EndFunc

func _User32_UnionRect(  $lprcDst, $lprcSrc1, $lprcSrc2  )
	local $vRetVal = DllCall($User32,"int","UnionRect","ptr",$lprcDst,"ptr",$lprcSrc1,"ptr",$lprcSrc2)
	return $vRetVal[0]
EndFunc

func _User32_EnumWindows(  $lpEnumFunc, $lParam  )
	local $vRetVal = DllCall($User32,"int","EnumWindows","ptr",$lpEnumFunc,"ptr",$lParam)
	return $vRetVal[0]
EndFunc

func _User32_GetWindowText(  $hWnd, $lpString, $nMaxCount  )
	local $vRetVal = DllCall($User32,"int","GetWindowText","hwnd",$hWnd,"str",$lpString,"int",$nMaxCount)
	return $vRetVal[0]
EndFunc

func _User32_MonitorFromWindow(  $hwnd, $dwFlags  )
	local $vRetVal = DllCall($User32,"hwnd","MonitorFromWindow","hwnd",$hwnd,"DWORD",$dwFlags)
	return $vRetVal[0]
EndFunc

func _User32_GetMonitorInfo(  $hMonitor, $lpmi  )
	local $vRetVal = DllCall($User32,"int","GetMonitorInfo","hwnd",$hMonitor,"ptr",$lpmi)
	return $vRetVal[0]
EndFunc

func _User32_EnumDisplayMonitors(  $hdc, $lprcClip, $lpfnEnum, $dwData  )
	local $vRetVal = DllCall($User32,"int","EnumDisplayMonitors","hwnd",$hdc,"ptr",$lprcClip,"ptr",$lpfnEnum,"LPARAM",$dwData)
	return $vRetVal[0]
EndFunc

func _User32_RemoveProp(  $hWnd, $lpString  )
	local $vRetVal = DllCall($User32,"hwnd","RemoveProp","hwnd",$hWnd,"str",$lpString)
	return $vRetVal[0]
EndFunc

func _User32_SetProp(  $hWnd, $lpString, $hData  )
	local $vRetVal = DllCall($User32,"int","SetProp","hwnd",$hWnd,"str",$lpString,"hwnd",$hData)
	return $vRetVal[0]
EndFunc

func _User32_SetWindowLong(  $hWnd, $nIndex, $dwNewLong  )
	local $vRetVal = DllCall($User32,"LONG","SetWindowLong","hwnd",$hWnd,"int",$nIndex,"LONG",$dwNewLong)
	return $vRetVal[0]
EndFunc

func _User32_GetActiveWindow(  )
	local $vRetVal = DllCall($User32,"hwnd","GetActiveWindow")
	return $vRetVal[0]
EndFunc

func _User32_SetCapture(  $hWnd  )
	local $vRetVal = DllCall($User32,"hwnd","SetCapture","hwnd",$hWnd)
	return $vRetVal[0]
EndFunc

func _User32_ReleaseCapture(  )
	local $vRetVal = DllCall($User32,"int","ReleaseCapture")
	return $vRetVal[0]
EndFunc

func _User32_GetUpdateRect(  $hWnd, $lpRect, $bErase  )
	local $vRetVal = DllCall($User32,"int","GetUpdateRect","hwnd",$hWnd,"ptr",$lpRect,"int",$bErase)
	return $vRetVal[0]
EndFunc

func _User32_GetCursor(  )
	local $vRetVal = DllCall($User32,"hwnd","GetCursor")
	return $vRetVal[0]
EndFunc

func _User32_GetCaretBlinkTime(  )
	local $vRetVal = DllCall($User32,"UINT","GetCaretBlinkTime")
	return $vRetVal[0]
EndFunc

func _User32_DrawText(  $hDC, $lpchText, $nCount, $lpRect, $uFormat  )
	local $vRetVal = DllCall($User32,"int","DrawText","hwnd",$hDC,"ptr",$lpchText,"int",$nCount,"ptr",$lpRect,"UINT",$uFormat)
	return $vRetVal[0]
EndFunc

func _User32_UpdateWindow(  $hWnd  )
	local $vRetVal = DllCall($User32,"int","UpdateWindow","hwnd",$hWnd)
	return $vRetVal[0]
EndFunc

func _User32_GetDlgCtrlID(  $hwndCtl  )
	local $vRetVal = DllCall($User32,"int","GetDlgCtrlID","hwnd",$hwndCtl)
	return $vRetVal[0]
EndFunc

func _User32_ShowWindow(  $hWnd, $nCmdShow  )
	local $vRetVal = DllCall($User32,"int","ShowWindow","hwnd",$hWnd,"int",$nCmdShow)
	return $vRetVal[0]
EndFunc

func _User32_GetAncestor(  $hwnd, $gaFlags  )
	local $vRetVal = DllCall($User32,"hwnd","GetAncestor","hwnd",$hwnd,"UINT",$gaFlags)
	return $vRetVal[0]
EndFunc

func _User32_EndDeferWindowPos(  $hWinPosInfo  )
	local $vRetVal = DllCall($User32,"int","EndDeferWindowPos","hwnd",$hWinPosInfo)
	return $vRetVal[0]
EndFunc

func _User32_BeginDeferWindowPos(  $nNumWindows  )
	local $vRetVal = DllCall($User32,"hwnd","BeginDeferWindowPos","int",$nNumWindows)
	return $vRetVal[0]
EndFunc

func _User32_DeferWindowPos(  $hWinPosInfo, $hWnd, $hWndInsertAfter, $x, $y, $cx, $cy, $uFlags  )
	local $vRetVal = DllCall($User32,"hwnd","DeferWindowPos","hwnd",$hWinPosInfo,"hwnd",$hWnd,"hwnd",$hWndInsertAfter,"int",$x,"int",$y,"int",$cx,"int",$cy,"UINT",$uFlags)
	return $vRetVal[0]
EndFunc

func _User32_HideCaret(  $hWnd  )
	local $vRetVal = DllCall($User32,"int","HideCaret","hwnd",$hWnd)
	return $vRetVal[0]
EndFunc

func _User32_ShowCaret(  $hWnd  )
	local $vRetVal = DllCall($User32,"int","ShowCaret","hwnd",$hWnd)
	return $vRetVal[0]
EndFunc

func _User32_EnumChildWindows(  $hWndParent, $lpEnumFunc, $lParam  )
	local $vRetVal = DllCall($User32,"int","EnumChildWindows","hwnd",$hWndParent,"ptr",$lpEnumFunc,"ptr",$lParam)
	return $vRetVal[0]
EndFunc

func _User32_SetFocus(  $hWnd  )
	local $vRetVal = DllCall($User32,"hwnd","SetFocus","hwnd",$hWnd)
	return $vRetVal[0]
EndFunc

func _User32_DestroyWindow(  $hWnd  )
	local $vRetVal = DllCall($User32,"int","DestroyWindow","hwnd",$hWnd)
	return $vRetVal[0]
EndFunc

func _User32_CharNext(  $lpsz  )
	local $vRetVal = DllCall($User32,"str","CharNext","str",$lpsz)
	return $vRetVal[0]
EndFunc

func _User32_GetSystemMenu(  $hWnd, $bRevert  )
	local $vRetVal = DllCall($User32,"hwnd","GetSystemMenu","hwnd",$hWnd,"int",$bRevert)
	return $vRetVal[0]
EndFunc

func _User32_CharLower(  $lpsz  )
	local $vRetVal = DllCall($User32,"str","CharLower","str",$lpsz)
	return $vRetVal[0]
EndFunc

func _User32_MoveWindow(  $hWnd, $X, $Y, $nWidth, $nHeight, $bRepaint  )
	local $vRetVal = DllCall($User32,"int","MoveWindow","hwnd",$hWnd,"int",$X,"int",$Y,"int",$nWidth,"int",$nHeight,"int",$bRepaint)
	return $vRetVal[0]
EndFunc

func _User32_SetParent(  $hWndChild, $hWndNewParent  )
	local $vRetVal = DllCall($User32,"hwnd","SetParent","hwnd",$hWndChild,"hwnd",$hWndNewParent)
	return $vRetVal[0]
EndFunc

func _User32_TrackMouseEvent(  $lpEventTrack  )
	local $vRetVal = DllCall($User32,"int","TrackMouseEvent","ptr",$lpEventTrack)
	return $vRetVal[0]
EndFunc

func _User32_DrawTextEx(  $hdc, $lpchText, $cchText, $lprc, $dwDTFormat, $lpDTParams  )
	local $vRetVal = DllCall($User32,"int","DrawTextEx","hwnd",$hdc,"ptr",$lpchText,"int",$cchText,"ptr",$lprc,"UINT",$dwDTFormat,"ptr",$lpDTParams)
	return $vRetVal[0]
EndFunc

func _User32_GetWindowInfo(  $hwnd, $pwi  )
	local $vRetVal = DllCall($User32,"int","GetWindowInfo","hwnd",$hwnd,"int",$pwi)
	return $vRetVal[0]
EndFunc

func _User32_GetTitleBarInfo(  $hwnd, $pti  )
	local $vRetVal = DllCall($User32,"int","GetTitleBarInfo","hwnd",$hwnd,"int",$pti)
	return $vRetVal[0]
EndFunc

func _User32_GetDCEx(  $hWnd, $hrgnClip, $flags  )
	local $vRetVal = DllCall($User32,"hwnd","GetDCEx","hwnd",$hWnd,"hwnd",$hrgnClip,"DWORD",$flags)
	return $vRetVal[0]
EndFunc

func _User32_MonitorFromRect(  $lprc, $dwFlags  )
	local $vRetVal = DllCall($User32,"hwnd","MonitorFromRect","ptr",$lprc,"DWORD",$dwFlags)
	return $vRetVal[0]
EndFunc

func _User32_DrawIconEx(  $hdc, $xLeft, $yTop, $hIcon, $cxWidth, $cyWidth, $istepIfAniCur, $hbrFlickerFreeDraw, $diFlags  )
	local $vRetVal = DllCall($User32,"int","DrawIconEx","hwnd",$hdc,"int",$xLeft,"int",$yTop,"hwnd",$hIcon,"int",$cxWidth,"int",$cyWidth,"UINT",$istepIfAniCur,"hwnd",$hbrFlickerFreeDraw,"UINT",$diFlags)
	return $vRetVal[0]
EndFunc

func _User32_SendMessageTimeout(  $hWnd, $Msg, $wParam, $lParam, $fuFlags, $uTimeout, $lpdwResult  )
	local $vRetVal = DllCall($User32,"LRESULT","SendMessageTimeout","hwnd",$hWnd,"UINT",$Msg,"WPARAM",$wParam,"ptr",$lParam,"UINT",$fuFlags,"UINT",$uTimeout,"ptr",$lpdwResult)
	return $vRetVal[0]
EndFunc

func _User32_InvalidateRgn(  $hWnd, $hRgn, $bErase  )
	local $vRetVal = DllCall($User32,"int","InvalidateRgn","hwnd",$hWnd,"hwnd",$hRgn,"int",$bErase)
	return $vRetVal[0]
EndFunc

func _User32_SetLayeredWindowAttributes(  $hwnd, $crKey, $bAlpha, $dwFlags  )
	local $vRetVal = DllCall($User32,"int","SetLayeredWindowAttributes","hwnd",$hwnd,"dword",$crKey,"BYTE",$bAlpha,"DWORD",$dwFlags)
	return $vRetVal[0]
EndFunc

func _User32_GetDesktopWindow(  )
	local $vRetVal = DllCall($User32,"hwnd","GetDesktopWindow")
	return $vRetVal[0]
EndFunc

func _User32_GetKeyboardState(  $lpKeyState  )
	local $vRetVal = DllCall($User32,"int","GetKeyboardState","ptr",$lpKeyState)
	return $vRetVal[0]
EndFunc

func _User32_DestroyCursor(  $hCursor  )
	local $vRetVal = DllCall($User32,"int","DestroyCursor","hwnd",$hCursor)
	return $vRetVal[0]
EndFunc

func _User32_DestroyMenu(  $hMenu  )
	local $vRetVal = DllCall($User32,"int","DestroyMenu","hwnd",$hMenu)
	return $vRetVal[0]
EndFunc

func _User32_GetIconInfo(  $hIcon, $piconinfo  )
	local $vRetVal = DllCall($User32,"int","GetIconInfo","hwnd",$hIcon,"ptr",$piconinfo)
	return $vRetVal[0]
EndFunc

func _User32_UnhookWindowsHookEx(  $hhk  )
	local $vRetVal = DllCall($User32,"int","UnhookWindowsHookEx","hwnd",$hhk)
	return $vRetVal[0]
EndFunc

func _User32_CharPrev(  $lpszStart, $lpszCurrent  )
	local $vRetVal = DllCall($User32,"str","CharPrev","str",$lpszStart,"str",$lpszCurrent)
	return $vRetVal[0]
EndFunc

func _User32_SendNotifyMessage(  $hWnd, $Msg, $wParam, $lParam  )
	local $vRetVal = DllCall($User32,"int","SendNotifyMessage","hwnd",$hWnd,"UINT",$Msg,"WPARAM",$wParam,"ptr",$lParam)
	return $vRetVal[0]
EndFunc

func _User32_IsCharAlpha(  $ch  )
	local $vRetVal = DllCall($User32,"int","IsCharAlpha","CHAR",$ch)
	return $vRetVal[0]
EndFunc

func _User32_SendMessageCallback(  $hWnd, $Msg, $wParam, $lParam, $lpCallBack, $dwData  )
	local $vRetVal = DllCall($User32,"int","SendMessageCallback","hwnd",$hWnd,"UINT",$Msg,"WPARAM",$wParam,"ptr",$lParam,"ptr",$lpCallBack,"ULONG_PTR",$dwData)
	return $vRetVal[0]
EndFunc

func _User32_GetAsyncKeyState(  $vKey  )
	local $vRetVal = DllCall($User32,"SHORT","GetAsyncKeyState","int",$vKey)
	return $vRetVal[0]
EndFunc

func _User32_MonitorFromPoint(  $pt, $dwFlags  )
	local $vRetVal = DllCall($User32,"hwnd","MonitorFromPoint","ptr",$pt,"DWORD",$dwFlags)
	return $vRetVal[0]
EndFunc

func _User32_UpdateLayeredWindow(  $hwnd, $hdcDst, $pptDst, $psize, $hdcSrc, $pptSrc, $crKey, $pblend, $dwFlags  )
	local $vRetVal = DllCall($User32,"int","UpdateLayeredWindow","hwnd",$hwnd,"hwnd",$hdcDst,"ptr",$pptDst,"ptr",$psize,"hwnd",$hdcSrc,"ptr",$pptSrc,"dword",$crKey,"int*",$pblend,"DWORD",$dwFlags)
	return $vRetVal[0]
EndFunc

func _User32_CreateCaret(  $hWnd, $hBitmap, $nWidth, $nHeight  )
	local $vRetVal = DllCall($User32,"int","CreateCaret","hwnd",$hWnd,"hwnd",$hBitmap,"int",$nWidth,"int",$nHeight)
	return $vRetVal[0]
EndFunc

func _User32_SetCaretPos(  $X, $Y  )
	local $vRetVal = DllCall($User32,"int","SetCaretPos","int",$X,"int",$Y)
	return $vRetVal[0]
EndFunc

func _User32_EnableMenuItem(  $hMenu, $uIDEnableItem, $uEnable  )
	local $vRetVal = DllCall($User32,"int","EnableMenuItem","hwnd",$hMenu,"UINT",$uIDEnableItem,"UINT",$uEnable)
	return $vRetVal[0]
EndFunc

func _User32_CallNextHookEx(  $hhk, $nCode, $wParam, $lParam  )
	local $vRetVal = DllCall($User32,"LRESULT","CallNextHookEx","hwnd",$hhk,"int",$nCode,"WPARAM",$wParam,"ptr",$lParam)
	return $vRetVal[0]
EndFunc

func _User32_DeleteMenu(  $hMenu, $uPosition, $uFlags  )
	local $vRetVal = DllCall($User32,"int","DeleteMenu","hwnd",$hMenu,"UINT",$uPosition,"UINT",$uFlags)
	return $vRetVal[0]
EndFunc

func _User32_GetWindowRgnBox(  $hWnd, $lprc  )
	local $vRetVal = DllCall($User32,"int","GetWindowRgnBox","hwnd",$hWnd,"ptr",$lprc)
	return $vRetVal[0]
EndFunc

func _User32_CreateWindowEx(  $dwExStyle, $lpClassName, $lpWindowName, $dwStyle, $x, $y, $nWidth, $nHeight, $hWndParent, $hMenu, $hInstance, $lpParam  )
	local $vRetVal = DllCall($User32,"hwnd","CreateWindowEx","DWORD",$dwExStyle,"str",$lpClassName,"str",$lpWindowName,"DWORD",$dwStyle,"int",$x,"int",$y,"int",$nWidth,"int",$nHeight,"hwnd",$hWndParent,"hwnd",$hMenu,"hwnd",$hInstance,"ptr",$lpParam)
	return $vRetVal[0]
EndFunc

func _User32_SetWindowRgn(  $hWnd, $hRgn, $bRedraw  )
	local $vRetVal = DllCall($User32,"int","SetWindowRgn","hwnd",$hWnd,"hwnd",$hRgn,"int",$bRedraw)
	return $vRetVal[0]
EndFunc

func _User32_AdjustWindowRectEx(  $lpRect, $dwStyle, $bMenu, $dwExStyle  )
	local $vRetVal = DllCall($User32,"int","AdjustWindowRectEx","ptr",$lpRect,"DWORD",$dwStyle,"int",$bMenu,"DWORD",$dwExStyle)
	return $vRetVal[0]
EndFunc

func _User32_CopyImage(  $hImage, $uType, $cxDesired, $cyDesired, $fuFlags  )
	local $vRetVal = DllCall($User32,"hwnd","CopyImage","hwnd",$hImage,"UINT",$uType,"int",$cxDesired,"int",$cyDesired,"UINT",$fuFlags)
	return $vRetVal[0]
EndFunc

func _User32_GetClassInfo(  $hInstance, $lpClassName, $lpWndClass  )
	local $vRetVal = DllCall($User32,"int","GetClassInfo","hwnd",$hInstance,"str",$lpClassName,"ptr",$lpWndClass)
	return $vRetVal[0]
EndFunc

func _User32_LoadIcon(  $hInstance, $lpIconName  )
	local $vRetVal = DllCall($User32,"hwnd","LoadIcon","hwnd",$hInstance,"str",$lpIconName)
	return $vRetVal[0]
EndFunc

func _User32_GetDoubleClickTime(  )
	local $vRetVal = DllCall($User32,"UINT","GetDoubleClickTime")
	return $vRetVal[0]
EndFunc

func _User32_GetSubMenu(  $hMenu, $nPos  )
	local $vRetVal = DllCall($User32,"hwnd","GetSubMenu","hwnd",$hMenu,"int",$nPos)
	return $vRetVal[0]
EndFunc

func _User32_GetScrollBarInfo(  $hwnd, $idObject, $psbi  )
	local $vRetVal = DllCall($User32,"int","GetScrollBarInfo","hwnd",$hwnd,"LONG",$idObject,"int",$psbi)
	return $vRetVal[0]
EndFunc

func _User32_GetScrollInfo(  $hwnd, $fnBar, $lpsi  )
	local $vRetVal = DllCall($User32,"int","GetScrollInfo","hwnd",$hwnd,"int",$fnBar,"ptr",$lpsi)
	return $vRetVal[0]
EndFunc

func _User32_LoadMenu(  $hInstance, $lpMenuName  )
	local $vRetVal = DllCall($User32,"hwnd","LoadMenu","hwnd",$hInstance,"str",$lpMenuName)
	return $vRetVal[0]
EndFunc

func _User32_LoadMenuIndirect(  $lpMenuTemplate  )
	local $vRetVal = DllCall($User32,"hwnd","LoadMenuIndirect","int*",$lpMenuTemplate)
	return $vRetVal[0]
EndFunc

func _User32_LoadAccelerators(  $hInstance, $lpTableName  )
	local $vRetVal = DllCall($User32,"hwnd","LoadAccelerators","hwnd",$hInstance,"str",$lpTableName)
	return $vRetVal[0]
EndFunc

func _User32_GetMenuItemCount(  $hMenu  )
	local $vRetVal = DllCall($User32,"int","GetMenuItemCount","hwnd",$hMenu)
	return $vRetVal[0]
EndFunc

func _User32_GetMenuItemInfo(  $hMenu, $uItem, $fByPosition, $lpmii  )
	local $vRetVal = DllCall($User32,"int","GetMenuItemInfo","hwnd",$hMenu,"UINT",$uItem,"int",$fByPosition,"ptr",$lpmii)
	return $vRetVal[0]
EndFunc

func _User32_EnumDisplayDevices(  $lpDevice, $iDevNum, $lpDisplayDevice, $dwFlags  )
	local $vRetVal = DllCall($User32,"int","EnumDisplayDevices","str",$lpDevice,"DWORD",$iDevNum,"ptr",$lpDisplayDevice,"DWORD",$dwFlags)
	return $vRetVal[0]
EndFunc

func _User32_CreateIconIndirect(  $piconinfo  )
	local $vRetVal = DllCall($User32,"hwnd","CreateIconIndirect","ptr",$piconinfo)
	return $vRetVal[0]
EndFunc

func _User32_LookupIconIdFromDirectoryEx(  $presbits, $fIcon, $cxDesired, $cyDesired, $Flags  )
	local $vRetVal = DllCall($User32,"int","LookupIconIdFromDirectoryEx","ptr",$presbits,"int",$fIcon,"int",$cxDesired,"int",$cyDesired,"UINT",$Flags)
	return $vRetVal[0]
EndFunc

func _User32_LoadImage(  $hinst, $lpszName, $uType, $cxDesired, $cyDesired, $fuLoad  )
	local $vRetVal = DllCall($User32,"hwnd","LoadImage","hwnd",$hinst,"str",$lpszName,"UINT",$uType,"int",$cxDesired,"int",$cyDesired,"UINT",$fuLoad)
	return $vRetVal[0]
EndFunc

func _User32_PrivateExtractIcons(  $lpszFile, $nIconIndex, $cxIcon, $cyIcon, $phicon, $piconid, $nIcons, $flags  )
	local $vRetVal = DllCall($User32,"UINT","PrivateExtractIcons","str",$lpszFile,"int",$nIconIndex,"int",$cxIcon,"int",$cyIcon,"hwnd*",$phicon,"UINT*",$piconid,"UINT",$nIcons,"UINT",$flags)
	return $vRetVal[0]
EndFunc

func _User32_CreateIconFromResourceEx(  $pbIconBits, $cbIconBits, $fIcon, $dwVersion, $cxDesired, $cyDesired, $uFlags  )
	local $vRetVal = DllCall($User32,"hwnd","CreateIconFromResourceEx","ptr",$pbIconBits,"DWORD",$cbIconBits,"int",$fIcon,"DWORD",$dwVersion,"int",$cxDesired,"int",$cyDesired,"UINT",$uFlags)
	return $vRetVal[0]
EndFunc

func _User32_DefDlgProc(  $hDlg, $Msg, $wParam, $lParam  )
	local $vRetVal = DllCall($User32,"LRESULT","DefDlgProc","hwnd",$hDlg,"UINT",$Msg,"WPARAM",$wParam,"ptr",$lParam)
	return $vRetVal[0]
EndFunc

func _User32_SetForegroundWindow(  $hWnd  )
	local $vRetVal = DllCall($User32,"int","SetForegroundWindow","hwnd",$hWnd)
	return $vRetVal[0]
EndFunc

func _User32_GetDlgItemText(  $hDlg, $nIDDlgItem, $lpString, $nMaxCount  )
	local $vRetVal = DllCall($User32,"UINT","GetDlgItemText","hwnd",$hDlg,"int",$nIDDlgItem,"str",$lpString,"int",$nMaxCount)
	return $vRetVal[0]
EndFunc

func _User32_GetDlgItem(  $hDlg, $nIDDlgItem  )
	local $vRetVal = DllCall($User32,"hwnd","GetDlgItem","hwnd",$hDlg,"int",$nIDDlgItem)
	return $vRetVal[0]
EndFunc

func _User32_SetActiveWindow(  $hWnd  )
	local $vRetVal = DllCall($User32,"hwnd","SetActiveWindow","hwnd",$hWnd)
	return $vRetVal[0]
EndFunc

func _User32_GetWindowTextLength(  $hWnd  )
	local $vRetVal = DllCall($User32,"int","GetWindowTextLength","hwnd",$hWnd)
	return $vRetVal[0]
EndFunc

func _User32_InSendMessage(  )
	local $vRetVal = DllCall($User32,"int","InSendMessage")
	return $vRetVal[0]
EndFunc

func _User32_SetDlgItemText(  $hDlg, $nIDDlgItem, $lpString  )
	local $vRetVal = DllCall($User32,"int","SetDlgItemText","hwnd",$hDlg,"int",$nIDDlgItem,"str",$lpString)
	return $vRetVal[0]
EndFunc

func _User32_SendDlgItemMessage(  $hDlg, $nIDDlgItem, $Msg, $wParam, $lParam  )
	local $vRetVal = DllCall($User32,"LRESULT","SendDlgItemMessage","hwnd",$hDlg,"int",$nIDDlgItem,"UINT",$Msg,"WPARAM",$wParam,"ptr",$lParam)
	return $vRetVal[0]
EndFunc

func _User32_LoadBitmap(  $hInstance, $lpBitmapName  )
	local $vRetVal = DllCall($User32,"hwnd","LoadBitmap","hwnd",$hInstance,"str",$lpBitmapName)
	return $vRetVal[0]
EndFunc

func _User32_DialogBoxParam(  $hInstance, $lpTemplateName, $hWndParent, $lpDialogFunc, $dwInitParam  )
	local $vRetVal = DllCall($User32,"INT_PTR","DialogBoxParam","hwnd",$hInstance,"str",$lpTemplateName,"hwnd",$hWndParent,"ptr",$lpDialogFunc,"LPARAM",$dwInitParam)
	return $vRetVal[0]
EndFunc

func _User32_DrawState(  $hdc, $hbr, $lpOutputFunc, $lData, $wData, $x, $y, $cx, $cy, $fuFlags  )
	local $vRetVal = DllCall($User32,"int","DrawState","hwnd",$hdc,"hwnd",$hbr,"ptr",$lpOutputFunc,"LPARAM",$lData,"WPARAM",$wData,"int",$x,"int",$y,"int",$cx,"int",$cy,"UINT",$fuFlags)
	return $vRetVal[0]
EndFunc

func _User32_EndDialog(  $hDlg, $nResult  )
	local $vRetVal = DllCall($User32,"int","EndDialog","hwnd",$hDlg,"INT_PTR",$nResult)
	return $vRetVal[0]
EndFunc

func _User32_CheckDlgButton(  $hDlg, $nIDButton, $uCheck  )
	local $vRetVal = DllCall($User32,"int","CheckDlgButton","hwnd",$hDlg,"int",$nIDButton,"UINT",$uCheck)
	return $vRetVal[0]
EndFunc

func _User32_IsDlgButtonChecked(  $hDlg, $nIDButton  )
	local $vRetVal = DllCall($User32,"UINT","IsDlgButtonChecked","hwnd",$hDlg,"int",$nIDButton)
	return $vRetVal[0]
EndFunc

func _User32_GetClassInfoEx(  $hinst, $lpszClass, $lpwcx  )
	local $vRetVal = DllCall($User32,"int","GetClassInfoEx","hwnd",$hinst,"str",$lpszClass,"ptr",$lpwcx)
	return $vRetVal[0]
EndFunc

func _User32_FindWindowEx(  $hwndParent, $hwndChildAfter, $lpszClass, $lpszWindow  )
	local $vRetVal = DllCall($User32,"hwnd","FindWindowEx","hwnd",$hwndParent,"hwnd",$hwndChildAfter,"str",$lpszClass,"str",$lpszWindow)
	return $vRetVal[0]
EndFunc

func _User32_RegisterShellHookWindow(  $hWnd  )
	local $vRetVal = DllCall($User32,"int","RegisterShellHookWindow","hwnd",$hWnd)
	return $vRetVal[0]
EndFunc

func _User32_SetClassLong(  $hWnd, $nIndex, $dwNewLong  )
	local $vRetVal = DllCall($User32,"DWORD","SetClassLong","hwnd",$hWnd,"int",$nIndex,"LONG",$dwNewLong)
	return $vRetVal[0]
EndFunc

func _User32_GetWindowRgn(  $hWnd, $hRgn  )
	local $vRetVal = DllCall($User32,"int","GetWindowRgn","hwnd",$hWnd,"hwnd",$hRgn)
	return $vRetVal[0]
EndFunc

func _User32_SetMenuItemInfo(  $hMenu, $uItem, $fByPosition, $lpmii  )
	local $vRetVal = DllCall($User32,"int","SetMenuItemInfo","hwnd",$hMenu,"UINT",$uItem,"int",$fByPosition,"ptr",$lpmii)
	return $vRetVal[0]
EndFunc

func _User32_AppendMenu(  $hMenu, $uFlags, $uIDNewItem, $lpNewItem  )
	local $vRetVal = DllCall($User32,"int","AppendMenu","hwnd",$hMenu,"UINT",$uFlags,"UINT_PTR",$uIDNewItem,"str",$lpNewItem)
	return $vRetVal[0]
EndFunc

func _User32_ShowWindowAsync(  $hWnd, $nCmdShow  )
	local $vRetVal = DllCall($User32,"int","ShowWindowAsync","hwnd",$hWnd,"int",$nCmdShow)
	return $vRetVal[0]
EndFunc

func _User32_EnumDisplaySettingsEx(  $lpszDeviceName, $iModeNum, $lpDevMode, $dwFlags  )
	local $vRetVal = DllCall($User32,"int","EnumDisplaySettingsEx","str",$lpszDeviceName,"DWORD",$iModeNum,"ptr*",$lpDevMode,"DWORD",$dwFlags)
	return $vRetVal[0]
EndFunc

func _User32_EnumDisplaySettings(  $lpszDeviceName, $iModeNum, $lpDevMode  )
	local $vRetVal = DllCall($User32,"int","EnumDisplaySettings","str",$lpszDeviceName,"DWORD",$iModeNum,"ptr*",$lpDevMode)
	return $vRetVal[0]
EndFunc

func _User32_ModifyMenu(  $hMnu, $uPosition, $uFlags, $uIDNewItem, $lpNewItem  )
	local $vRetVal = DllCall($User32,"int","ModifyMenu","hwnd",$hMnu,"UINT",$uPosition,"UINT",$uFlags,"PTR",$uIDNewItem,"str",$lpNewItem)
	return $vRetVal[0]
EndFunc

func _User32_OpenInputDesktop(  $dwFlags, $fInherit, $dwDesiredAccess  )
	local $vRetVal = DllCall($User32,"hwnd","OpenInputDesktop","DWORD",$dwFlags,"int",$fInherit,"int",$dwDesiredAccess)
	return $vRetVal[0]
EndFunc

func _User32_CreateDialogParam(  $hInstance, $lpTemplateName, $hWndParent, $lpDialogFunc, $dwInitParam  )
	local $vRetVal = DllCall($User32,"hwnd","CreateDialogParam","hwnd",$hInstance,"str",$lpTemplateName,"hwnd",$hWndParent,"ptr",$lpDialogFunc,"LPARAM",$dwInitParam)
	return $vRetVal[0]
EndFunc

func _User32_RegisterHotKey(  $hWnd, $id, $fsModifiers, $vk  )
	local $vRetVal = DllCall($User32,"int","RegisterHotKey","hwnd",$hWnd,"int",$id,"UINT",$fsModifiers,"UINT",$vk)
	return $vRetVal[0]
EndFunc

func _User32_ChildWindowFromPointEx(  $hwndParent, $pt, $uFlags  )
	local $vRetVal = DllCall($User32,"hwnd","ChildWindowFromPointEx","hwnd",$hwndParent,"POINT",$pt,"UINT",$uFlags)
	return $vRetVal[0]
EndFunc

func _User32_ChildWindowFromPoint(  $hWndParent, $Point  )
	local $vRetVal = DllCall($User32,"hwnd","ChildWindowFromPoint","hwnd",$hWndParent,"POINT",$Point)
	return $vRetVal[0]
EndFunc

func _User32_BroadcastSystemMessageEx(  $dwFlags, $lpdwRecipients, $uiMessage, $wParam, $lParam, $pBSMInfo  )
	local $vRetVal = DllCall($User32,"long","BroadcastSystemMessageEx","DWORD",$dwFlags,"ptr",$lpdwRecipients,"UINT",$uiMessage,"WPARAM",$wParam,"ptr",$lParam,"ptr",$pBSMInfo)
	return $vRetVal[0]
EndFunc

func _User32_GetNextDlgTabItem(  $hDlg, $hCtl, $bPrevious  )
	local $vRetVal = DllCall($User32,"hwnd","GetNextDlgTabItem","hwnd",$hDlg,"hwnd",$hCtl,"int",$bPrevious)
	return $vRetVal[0]
EndFunc

func _User32_PrintWindow(  $hwnd, $hdcBlt, $nFlags  )
	local $vRetVal = DllCall($User32,"int","PrintWindow","hwnd",$hwnd,"hwnd",$hdcBlt,"UINT",$nFlags)
	return $vRetVal[0]
EndFunc

func _User32_ChangeDisplaySettingsEx(  $lpszDeviceName, $lpDevMode, $hwnd, $dwflags, $lParam  )
	local $vRetVal = DllCall($User32,"LONG","ChangeDisplaySettingsEx","str",$lpszDeviceName,"ptr",$lpDevMode,"hwnd",$hwnd,"DWORD",$dwflags,"ptr",$lParam)
	return $vRetVal[0]
EndFunc

func _User32_SetMenuDefaultItem(  $hMenu, $uItem, $fByPos  )
	local $vRetVal = DllCall($User32,"int","SetMenuDefaultItem","hwnd",$hMenu,"UINT",$uItem,"UINT",$fByPos)
	return $vRetVal[0]
EndFunc

func _User32_InsertMenuItem(  $hMenu, $uItem, $fByPosition, $lpmii  )
	local $vRetVal = DllCall($User32,"int","InsertMenuItem","hwnd",$hMenu,"UINT",$uItem,"int",$fByPosition,"ptr",$lpmii)
	return $vRetVal[0]
EndFunc

func _User32_CreatePopupMenu(  )
	local $vRetVal = DllCall($User32,"hwnd","CreatePopupMenu")
	return $vRetVal[0]
EndFunc

func _User32_InsertMenu(  $hMenu, $uPosition, $uFlags, $uIDNewItem, $lpNewItem  )
	local $vRetVal = DllCall($User32,"int","InsertMenu","hwnd",$hMenu,"UINT",$uPosition,"UINT",$uFlags,"PTR",$uIDNewItem,"str",$lpNewItem)
	return $vRetVal[0]
EndFunc

func _User32_GetMenuDefaultItem(  $hMenu, $fByPos, $gmdiFlags  )
	local $vRetVal = DllCall($User32,"UINT","GetMenuDefaultItem","hwnd",$hMenu,"UINT",$fByPos,"UINT",$gmdiFlags)
	return $vRetVal[0]
EndFunc

func _User32_RemoveMenu(  $hMenu, $uPosition, $uFlags  )
	local $vRetVal = DllCall($User32,"int","RemoveMenu","hwnd",$hMenu,"UINT",$uPosition,"UINT",$uFlags)
	return $vRetVal[0]
EndFunc

func _User32_GetMenuState(  $hMenu, $uId, $uFlags  )
	local $vRetVal = DllCall($User32,"UINT","GetMenuState","hwnd",$hMenu,"UINT",$uId,"UINT",$uFlags)
	return $vRetVal[0]
EndFunc

func _User32_SwitchDesktop(  $hDesktop  )
	local $vRetVal = DllCall($User32,"int","SwitchDesktop","hwnd",$hDesktop)
	return $vRetVal[0]
EndFunc

func _User32_SubtractRect(  $lprcDst, $lprcSrc1, $lprcSrc2  )
	local $vRetVal = DllCall($User32,"int","SubtractRect","ptr",$lprcDst,"ptr",$lprcSrc1,"ptr",$lprcSrc2)
	return $vRetVal[0]
EndFunc

func _User32_DdeCreateStringHandle(  $idInst, $psz, $iCodePage  )
	local $vRetVal = DllCall($User32,"hwnd","DdeCreateStringHandle","DWORD",$idInst,"str",$psz,"int",$iCodePage)
	return $vRetVal[0]
EndFunc

func _User32_DdeInitialize(  $pidInst, $pfnCallback, $afCmd, $ulRes  )
	local $vRetVal = DllCall($User32,"UINT","DdeInitialize","DWORD",$pidInst,"int",$pfnCallback,"DWORD",$afCmd,"DWORD",$ulRes)
	return $vRetVal[0]
EndFunc

func _User32_DdeNameService(  $idInst, $hsz1, $hsz2, $afCmd  )
	local $vRetVal = DllCall($User32,"hwnd","DdeNameService","DWORD",$idInst,"UINT",$hsz1,"UINT",$hsz2,"UINT",$afCmd)
	return $vRetVal[0]
EndFunc

func _User32_AnimateWindow(  $hwnd, $dwTime, $dwFlags  )
	local $vRetVal = DllCall($User32,"int","AnimateWindow","hwnd",$hwnd,"DWORD",$dwTime,"DWORD",$dwFlags)
	return $vRetVal[0]
EndFunc

func _User32_SetUserObjectSecurity(  $hObj, $pSIRequested, $pSID  )
	local $vRetVal = DllCall($User32,"int","SetUserObjectSecurity","hwnd",$hObj,"int",$pSIRequested,"int",$pSID)
	return $vRetVal[0]
EndFunc

func _User32_CreateWindowStation(  $lpwinsta, $dwFlags, $dwDesiredAccess, $lpsa  )
	local $vRetVal = DllCall($User32,"hwnd","CreateWindowStation","str",$lpwinsta,"DWORD",$dwFlags,"int",$dwDesiredAccess,"ptr",$lpsa)
	return $vRetVal[0]
EndFunc

func _User32_CreateDesktop(  $lpszDesktop, $lpszDevice, $pDevmode, $dwFlags, $dwDesiredAccess, $lpsa  )
	local $vRetVal = DllCall($User32,"hwnd","CreateDesktop","str",$lpszDesktop,"str",$lpszDevice,"ptr",$pDevmode,"DWORD",$dwFlags,"int",$dwDesiredAccess,"ptr",$lpsa)
	return $vRetVal[0]
EndFunc

func _User32_IsCharAlphaNumeric(  $ch  )
	local $vRetVal = DllCall($User32,"int","IsCharAlphaNumeric","CHAR",$ch)
	return $vRetVal[0]
EndFunc

func _User32_RegisterDeviceNotification(  $hRecipient, $NotificationFilter, $Flags  )
	local $vRetVal = DllCall($User32,"hwnd","RegisterDeviceNotification","hwnd",$hRecipient,"ptr",$NotificationFilter,"DWORD",$Flags)
	return $vRetVal[0]
EndFunc

func _User32_AllowSetForegroundWindow(  $dwProcessId  )
	local $vRetVal = DllCall($User32,"int","AllowSetForegroundWindow","DWORD",$dwProcessId)
	return $vRetVal[0]
EndFunc

func _User32_BroadcastSystemMessage(  $dwFlags, $lpdwRecipients, $uiMessage, $wParam, $lParam  )
	local $vRetVal = DllCall($User32,"long","BroadcastSystemMessage","DWORD",$dwFlags,"ptr",$lpdwRecipients,"UINT",$uiMessage,"WPARAM",$wParam,"ptr",$lParam)
	return $vRetVal[0]
EndFunc

func _User32_UnregisterDeviceNotification(  $Handle  )
	local $vRetVal = DllCall($User32,"int","UnregisterDeviceNotification","hwnd",$Handle)
	return $vRetVal[0]
EndFunc

func _User32_EnumDesktopWindows(  $hDesktop, $lpfn, $lParam  )
	local $vRetVal = DllCall($User32,"int","EnumDesktopWindows","hwnd",$hDesktop,"ptr",$lpfn,"ptr",$lParam)
	return $vRetVal[0]
EndFunc

func _User32_EnumDesktops(  $hwinsta, $lpEnumFunc, $lParam  )
	local $vRetVal = DllCall($User32,"int","EnumDesktops","hwnd",$hwinsta,"ptr",$lpEnumFunc,"ptr",$lParam)
	return $vRetVal[0]
EndFunc

func _User32_OpenDesktop(  $lpszDesktop, $dwFlags, $fInherit, $dwDesiredAccess  )
	local $vRetVal = DllCall($User32,"hwnd","OpenDesktop","str",$lpszDesktop,"DWORD",$dwFlags,"int",$fInherit,"int",$dwDesiredAccess)
	return $vRetVal[0]
EndFunc

func _User32_PaintDesktop(  $hdc  )
	local $vRetVal = DllCall($User32,"int","PaintDesktop","hwnd",$hdc)
	return $vRetVal[0]
EndFunc

func _User32_ActivateKeyboardLayout(  $hkl, $Flags  )
	local $vRetVal = DllCall($User32,"hwnd","ActivateKeyboardLayout","hwnd",$hkl,"UINT",$Flags)
	return $vRetVal[0]
EndFunc

func _User32_ReplyMessage(  $lResult  )
	local $vRetVal = DllCall($User32,"int","ReplyMessage","LRESULT",$lResult)
	return $vRetVal[0]
EndFunc

func _User32_CreateAcceleratorTable(  $lpaccl, $cEntries  )
	local $vRetVal = DllCall($User32,"hwnd","CreateAcceleratorTable","ptr",$lpaccl,"int",$cEntries)
	return $vRetVal[0]
EndFunc

func _User32_SetWindowPlacement(  $hWnd, $lpwndpl  )
	local $vRetVal = DllCall($User32,"int","SetWindowPlacement","hwnd",$hWnd,"int*",$lpwndpl)
	return $vRetVal[0]
EndFunc

func _User32_LockSetForegroundWindow(  $uLockCode  )
	local $vRetVal = DllCall($User32,"int","LockSetForegroundWindow","UINT",$uLockCode)
	return $vRetVal[0]
EndFunc

func _User32_CopyIcon(  $hIcon  )
	local $vRetVal = DllCall($User32,"hwnd","CopyIcon","hwnd",$hIcon)
	return $vRetVal[0]
EndFunc

func _User32_IsDialogMessage(  $hDlg, $lpMsg  )
	local $vRetVal = DllCall($User32,"int","IsDialogMessage","hwnd",$hDlg,"ptr",$lpMsg)
	return $vRetVal[0]
EndFunc

func _User32_CallMsgFilter(  $lpMsg, $nCode  )
	local $vRetVal = DllCall($User32,"int","CallMsgFilter","ptr",$lpMsg,"int",$nCode)
	return $vRetVal[0]
EndFunc

func _User32_CloseDesktop(  $hDesktop  )
	local $vRetVal = DllCall($User32,"int","CloseDesktop","hwnd",$hDesktop)
	return $vRetVal[0]
EndFunc

func _User32_SetWindowsHookEx(  $idHook, $lpfn, $hMod, $dwThreadId  )
	local $vRetVal = DllCall($User32,"hwnd","SetWindowsHookEx","int",$idHook,"hwnd",$lpfn,"hwnd",$hMod,"DWORD",$dwThreadId)
	return $vRetVal[0]
EndFunc

func _User32_FindWindow(  $lpClassName, $lpWindowName  )
	local $vRetVal = DllCall($User32,"hwnd","FindWindow","str",$lpClassName,"str",$lpWindowName)
	return $vRetVal[0]
EndFunc

func _User32_PostThreadMessage(  $idThread, $Msg, $wParam, $lParam  )
	local $vRetVal = DllCall($User32,"int","PostThreadMessage","DWORD",$idThread,"UINT",$Msg,"WPARAM",$wParam,"ptr",$lParam)
	return $vRetVal[0]
EndFunc

func _User32_PostQuitMessage(  $nExitCode  )
	local $vRetVal = DllCall($User32,"none","PostQuitMessage","int",$nExitCode)
	return $vRetVal[0]
EndFunc

func _User32_GetGUIThreadInfo(  $idThread, $lpgui  )
	local $vRetVal = DllCall($User32,"int","GetGUIThreadInfo","DWORD",$idThread,"ptr",$lpgui)
	return $vRetVal[0]
EndFunc

func _User32_GetQueueStatus(  $flags  )
	local $vRetVal = DllCall($User32,"DWORD","GetQueueStatus","UINT",$flags)
	return $vRetVal[0]
EndFunc

func _User32_InSendMessageEx(  $lpReserved  )
	local $vRetVal = DllCall($User32,"DWORD","InSendMessageEx","ptr",$lpReserved)
	return $vRetVal[0]
EndFunc

func _User32_CloseWindowStation(  $hWinSta  )
	local $vRetVal = DllCall($User32,"int","CloseWindowStation","hwnd",$hWinSta)
	return $vRetVal[0]
EndFunc

func _User32_SetThreadDesktop(  $hDesktop  )
	local $vRetVal = DllCall($User32,"int","SetThreadDesktop","hwnd",$hDesktop)
	return $vRetVal[0]
EndFunc

func _User32_SetProcessWindowStation(  $hWinSta  )
	local $vRetVal = DllCall($User32,"int","SetProcessWindowStation","hwnd",$hWinSta)
	return $vRetVal[0]
EndFunc

func _User32_SendInput(  $nInputs, $pInputs, $cbSize  )
	local $vRetVal = DllCall($User32,"UINT","SendInput","UINT",$nInputs,"INPUT",$pInputs,"int",$cbSize)
	return $vRetVal[0]
EndFunc

func _User32_IsClipboardFormatAvailable(  $format  )
	local $vRetVal = DllCall($User32,"int","IsClipboardFormatAvailable","UINT",$format)
	return $vRetVal[0]
EndFunc

func _User32_GetClipboardSequenceNumber(   )
	local $vRetVal = DllCall($User32,"DWORD","GetClipboardSequenceNumber")
	return $vRetVal[0]
EndFunc

func _User32_VkKeyScanEx(  $ch, $dwhkl  )
	local $vRetVal = DllCall($User32,"SHORT","VkKeyScanEx","CHAR",$ch,"hwnd",$dwhkl)
	return $vRetVal[0]
EndFunc

func _User32_GetTopWindow(  $hWnd  )
	local $vRetVal = DllCall($User32,"hwnd","GetTopWindow","hwnd",$hWnd)
	return $vRetVal[0]
EndFunc

func _User32_ShowScrollBar(  $hWnd, $wBar, $bShow  )
	local $vRetVal = DllCall($User32,"int","ShowScrollBar","hwnd",$hWnd,"int",$wBar,"int",$bShow)
	return $vRetVal[0]
EndFunc

func _User32_CreateMenu(  )
	local $vRetVal = DllCall($User32,"hwnd","CreateMenu")
	return $vRetVal[0]
EndFunc

func _User32_EnumThreadWindows(  $dwThreadId, $lpfn, $lParam  )
	local $vRetVal = DllCall($User32,"int","EnumThreadWindows","DWORD",$dwThreadId,"ptr",$lpfn,"ptr",$lParam)
	return $vRetVal[0]
EndFunc

func _User32_GetUpdateRgn(  $hWnd, $hRgn, $bErase  )
	local $vRetVal = DllCall($User32,"int","GetUpdateRgn","hwnd",$hWnd,"hwnd",$hRgn,"int",$bErase)
	return $vRetVal[0]
EndFunc

func _User32_GetInputState(  )
	local $vRetVal = DllCall($User32,"int","GetInputState")
	return $vRetVal[0]
EndFunc

func _User32_ValidateRgn(  $hWnd, $hRgn  )
	local $vRetVal = DllCall($User32,"int","ValidateRgn","hwnd",$hWnd,"hwnd",$hRgn)
	return $vRetVal[0]
EndFunc

func _User32_GetCaretPos(  $lpPoint  )
	local $vRetVal = DllCall($User32,"int","GetCaretPos","ptr",$lpPoint)
	return $vRetVal[0]
EndFunc

func _User32_GetScrollPos(  $hWnd, $nBar  )
	local $vRetVal = DllCall($User32,"int","GetScrollPos","hwnd",$hWnd,"int",$nBar)
	return $vRetVal[0]
EndFunc

func _User32_SetScrollPos(  $hWnd, $nBar, $nPos, $bRedraw  )
	local $vRetVal = DllCall($User32,"int","SetScrollPos","hwnd",$hWnd,"int",$nBar,"int",$nPos,"int",$bRedraw)
	return $vRetVal[0]
EndFunc

func _User32_GetScrollRange(  $hWnd, $nBar, $lpMinPos, $lpMaxPos  )
	local $vRetVal = DllCall($User32,"int","GetScrollRange","hwnd",$hWnd,"int",$nBar,"ptr",$lpMinPos,"ptr",$lpMaxPos)
	return $vRetVal[0]
EndFunc

func _User32_FrameRect(  $hDC, $lprc, $hbr  )
	local $vRetVal = DllCall($User32,"int","FrameRect","hwnd",$hDC,"ptr",$lprc,"hwnd",$hbr)
	return $vRetVal[0]
EndFunc

func _User32_DrawFocusRect(  $hDC, $lprc  )
	local $vRetVal = DllCall($User32,"int","DrawFocusRect","hwnd",$hDC,"ptr",$lprc)
	return $vRetVal[0]
EndFunc

func _User32_SetScrollRange(  $hWnd, $nBar, $nMinPos, $nMaxPos, $bRedraw  )
	local $vRetVal = DllCall($User32,"int","SetScrollRange","hwnd",$hWnd,"int",$nBar,"int",$nMinPos,"int",$nMaxPos,"int",$bRedraw)
	return $vRetVal[0]
EndFunc

func _User32_WindowFromDC(  $hDC  )
	local $vRetVal = DllCall($User32,"hwnd","WindowFromDC","hwnd",$hDC)
	return $vRetVal[0]
EndFunc

func _User32_ShowCursor(  $bShow  )
	local $vRetVal = DllCall($User32,"int","ShowCursor","int",$bShow)
	return $vRetVal[0]
EndFunc

func _User32_TranslateMDISysAccel(  $hWndClient, $lpMsg  )
	local $vRetVal = DllCall($User32,"int","TranslateMDISysAccel","hwnd",$hWndClient,"ptr",$lpMsg)
	return $vRetVal[0]
EndFunc

func _User32_ValidateRect(  $hWnd, $lpRect  )
	local $vRetVal = DllCall($User32,"int","ValidateRect","hwnd",$hWnd,"ptr",$lpRect)
	return $vRetVal[0]
EndFunc

func _User32_DrawEdge(  $hdc, $qrc, $edge, $grfFlags  )
	local $vRetVal = DllCall($User32,"int","DrawEdge","hwnd",$hdc,"ptr",$qrc,"UINT",$edge,"UINT",$grfFlags)
	return $vRetVal[0]
EndFunc

func _User32_MapVirtualKey(  $uCode, $uMapType  )
	local $vRetVal = DllCall($User32,"UINT","MapVirtualKey","UINT",$uCode,"UINT",$uMapType)
	return $vRetVal[0]
EndFunc

func _User32_ScrollWindow(  $hWnd, $XAmount, $YAmount, $lpRect, $lpClipRect  )
	local $vRetVal = DllCall($User32,"int","ScrollWindow","hwnd",$hWnd,"int",$XAmount,"int",$YAmount,"ptr",$lpRect,"ptr",$lpClipRect)
	return $vRetVal[0]
EndFunc

func _User32_OemToChar(  $lpszSrc, $lpszDst  )
	local $vRetVal = DllCall($User32,"int","OemToChar","str",$lpszSrc,"str",$lpszDst)
	return $vRetVal[0]
EndFunc

func _User32_OemToCharBuff(  $lpszSrc, $lpszDst, $cchDstLength  )
	local $vRetVal = DllCall($User32,"int","OemToCharBuff","str",$lpszSrc,"str",$lpszDst,"DWORD",$cchDstLength)
	return $vRetVal[0]
EndFunc

func _User32_ScrollWindowEx(  $hWnd, $dx, $dy, $prcScroll, $prcClip, $hrgnUpdate, $prcUpdate, $flags  )
	local $vRetVal = DllCall($User32,"int","ScrollWindowEx","hwnd",$hWnd,"int",$dx,"int",$dy,"ptr",$prcScroll,"ptr",$prcClip,"hwnd",$hrgnUpdate,"ptr",$prcUpdate,"UINT",$flags)
	return $vRetVal[0]
EndFunc

func _User32_ExcludeUpdateRgn(  $hDC, $hWnd  )
	local $vRetVal = DllCall($User32,"int","ExcludeUpdateRgn","hwnd",$hDC,"hwnd",$hWnd)
	return $vRetVal[0]
EndFunc

func _User32_CloseClipboard( )
	local $vRetVal = DllCall($User32,"int","CloseClipboard")
	return $vRetVal[0]
EndFunc

func _User32_OpenClipboard(  $hWndNewOwner  )
	local $vRetVal = DllCall($User32,"int","OpenClipboard","hwnd",$hWndNewOwner)
	return $vRetVal[0]
EndFunc

func _User32_SetKeyboardState(  $lpKeyState  )
	local $vRetVal = DllCall($User32,"int","SetKeyboardState","ptr",$lpKeyState)
	return $vRetVal[0]
EndFunc

func _User32_BringWindowToTop(  $hWnd  )
	local $vRetVal = DllCall($User32,"int","BringWindowToTop","hwnd",$hWnd)
	return $vRetVal[0]
EndFunc

func _User32_GetWindowPlacement(  $hWnd, $lpwndpl  )
	local $vRetVal = DllCall($User32,"int","GetWindowPlacement","hwnd",$hWnd,"int*",$lpwndpl)
	return $vRetVal[0]
EndFunc

func _User32_SetClipboardViewer(  $hWndNewViewer  )
	local $vRetVal = DllCall($User32,"hwnd","SetClipboardViewer","hwnd",$hWndNewViewer)
	return $vRetVal[0]
EndFunc

func _User32_ChangeClipboardChain(  $hWndRemove, $hWndNewNext  )
	local $vRetVal = DllCall($User32,"int","ChangeClipboardChain","hwnd",$hWndRemove,"hwnd",$hWndNewNext)
	return $vRetVal[0]
EndFunc

func _User32_DefFrameProc(  $hWnd, $hWndMDIClient, $uMsg, $wParam, $lParam  )
	local $vRetVal = DllCall($User32,"LRESULT","DefFrameProc","hwnd",$hWnd,"hwnd",$hWndMDIClient,"UINT",$uMsg,"WPARAM",$wParam,"ptr",$lParam)
	return $vRetVal[0]
EndFunc

func _User32_DefMDIChildProc(  $hWnd, $uMsg, $wParam, $lParam  )
	local $vRetVal = DllCall($User32,"LRESULT","DefMDIChildProc","hwnd",$hWnd,"UINT",$uMsg,"WPARAM",$wParam,"ptr",$lParam)
	return $vRetVal[0]
EndFunc

func _User32_GetAltTabInfo(  $hwnd, $iItem, $pati, $pszItemText, $cchItemText  )
	local $vRetVal = DllCall($User32,"int","GetAltTabInfo","hwnd",$hwnd,"int",$iItem,"int",$pati,"str",$pszItemText,"UINT",$cchItemText)
	return $vRetVal[0]
EndFunc

func _User32_EmptyClipboard(  )
	local $vRetVal = DllCall($User32,"int","EmptyClipboard")
	return $vRetVal[0]
EndFunc

func _User32_GetClipboardOwner( )
	local $vRetVal = DllCall($User32,"hwnd","GetClipboardOwner")
	return $vRetVal[0]
EndFunc

func _User32_GetClipboardData(  $uFormat  )
	local $vRetVal = DllCall($User32,"hwnd","GetClipboardData","UINT",$uFormat)
	return $vRetVal[0]
EndFunc

func _User32_SetClipboardData(  $uFormat, $hMem  )
	local $vRetVal = DllCall($User32,"hwnd","SetClipboardData","UINT",$uFormat,"hwnd",$hMem)
	return $vRetVal[0]
EndFunc

func _User32_AdjustWindowRect(  $lpRect, $dwStyle, $bMenu  )
	local $vRetVal = DllCall($User32,"int","AdjustWindowRect","ptr",$lpRect,"DWORD",$dwStyle,"int",$bMenu)
	return $vRetVal[0]
EndFunc

func _User32_SetCaretBlinkTime(  $uMSeconds  )
	local $vRetVal = DllCall($User32,"int","SetCaretBlinkTime","UINT",$uMSeconds)
	return $vRetVal[0]
EndFunc

func _User32_GetKeyboardType(  $nTypeFlag  )
	local $vRetVal = DllCall($User32,"int","GetKeyboardType","int",$nTypeFlag)
	return $vRetVal[0]
EndFunc

func _User32_GetClipboardFormatName(  $format, $lpszFormatName, $cchMaxCount  )
	local $vRetVal = DllCall($User32,"int","GetClipboardFormatName","UINT",$format,"str",$lpszFormatName,"int",$cchMaxCount)
	return $vRetVal[0]
EndFunc

func _User32_IsMenu(  $hMenu  )
	local $vRetVal = DllCall($User32,"int","IsMenu","hwnd",$hMenu)
	return $vRetVal[0]
EndFunc

func _User32_LoadKeyboardLayout(  $pwszKLID, $Flags  )
	local $vRetVal = DllCall($User32,"hwnd","LoadKeyboardLayout","str",$pwszKLID,"UINT",$Flags)
	return $vRetVal[0]
EndFunc

func _User32_GetKeyboardLayoutName(  $pwszKLID  )
	local $vRetVal = DllCall($User32,"int","GetKeyboardLayoutName","str",$pwszKLID)
	return $vRetVal[0]
EndFunc

func _User32_GetMenu(  $hWnd  )
	local $vRetVal = DllCall($User32,"hwnd","GetMenu","hwnd",$hWnd)
	return $vRetVal[0]
EndFunc

func _User32_GetLastActivePopup(  $hWnd  )
	local $vRetVal = DllCall($User32,"hwnd","GetLastActivePopup","hwnd",$hWnd)
	return $vRetVal[0]
EndFunc

func _User32_CharToOemBuff(  $lpszSrc, $lpszDst, $cchDstLength  )
	local $vRetVal = DllCall($User32,"int","CharToOemBuff","str",$lpszSrc,"str",$lpszDst,"DWORD",$cchDstLength)
	return $vRetVal[0]
EndFunc

func _User32_CountClipboardFormats(  )
	local $vRetVal = DllCall($User32,"int","CountClipboardFormats")
	return $vRetVal[0]
EndFunc

func _User32_GetOpenClipboardWindow( )
	local $vRetVal = DllCall($User32,"hwnd","GetOpenClipboardWindow")
	return $vRetVal[0]
EndFunc

func _User32_SetWinEventHook(  $eventMin, $eventMax, $hmodWinEventProc, $lpfnWinEventProc, $idProcess, $idThread, $dwflags  )
	local $vRetVal = DllCall($User32,"hwnd","SetWinEventHook","UINT",$eventMin,"UINT",$eventMax,"hwnd",$hmodWinEventProc,"ptr",$lpfnWinEventProc,"DWORD",$idProcess,"DWORD",$idThread,"UINT",$dwflags)
	return $vRetVal[0]
EndFunc

func _User32_UnhookWinEvent(  $hWinEventHook  )
	local $vRetVal = DllCall($User32,"int","UnhookWinEvent","hwnd",$hWinEventHook)
	return $vRetVal[0]
EndFunc

func _User32_CheckMenuItem(  $hmenu, $uIDCheckItem, $uCheck  )
	local $vRetVal = DllCall($User32,"DWORD","CheckMenuItem","hwnd",$hmenu,"UINT",$uIDCheckItem,"UINT",$uCheck)
	return $vRetVal[0]
EndFunc

func _User32_AttachThreadInput(  $idAttach, $idAttachTo, $fAttach  )
	local $vRetVal = DllCall($User32,"int","AttachThreadInput","DWORD",$idAttach,"DWORD",$idAttachTo,"int",$fAttach)
	return $vRetVal[0]
EndFunc

func _User32_MessageBeep(  $uType  )
	local $vRetVal = DllCall($User32,"int","MessageBeep","UINT",$uType)
	return $vRetVal[0]
EndFunc

func _User32_DialogBoxIndirectParam(  $hInstance, $hDialogTemplate, $hWndParent, $lpDialogFunc, $dwInitParam  )
	local $vRetVal = DllCall($User32,"INT_PTR","DialogBoxIndirectParam","hwnd",$hInstance,"ptr",$hDialogTemplate,"hwnd",$hWndParent,"ptr",$lpDialogFunc,"LPARAM",$dwInitParam)
	return $vRetVal[0]
EndFunc

func _User32_OpenWindowStation(  $lpszWinSta, $fInherit, $dwDesiredAccess  )
	local $vRetVal = DllCall($User32,"hwnd","OpenWindowStation","str",$lpszWinSta,"int",$fInherit,"int",$dwDesiredAccess)
	return $vRetVal[0]
EndFunc

func _User32_EnumWindowStations(  $lpEnumFunc, $lParam  )
	local $vRetVal = DllCall($User32,"int","EnumWindowStations","ptr",$lpEnumFunc,"ptr",$lParam)
	return $vRetVal[0]
EndFunc

func _User32_IsCharUpper(  $ch  )
	local $vRetVal = DllCall($User32,"int","IsCharUpper","CHAR",$ch)
	return $vRetVal[0]
EndFunc

func _User32_LockWindowUpdate(  $hWndLock  )
	local $vRetVal = DllCall($User32,"int","LockWindowUpdate","hwnd",$hWndLock)
	return $vRetVal[0]
EndFunc

func _User32_CreateDialogIndirectParam(  $hInstance, $lpTemplate, $hWndParent, $lpDialogFunc, $lParamInit  )
	local $vRetVal = DllCall($User32,"hwnd","CreateDialogIndirectParam","hwnd",$hInstance,"ptr",$lpTemplate,"hwnd",$hWndParent,"ptr",$lpDialogFunc,"ptr",$lParamInit)
	return $vRetVal[0]
EndFunc

func _User32_MessageBoxIndirect(  $lpMsgBoxParams  )
	local $vRetVal = DllCall($User32,"int","MessageBoxIndirect","ptr",$lpMsgBoxParams)
	return $vRetVal[0]
EndFunc

func _User32_IsCharLower(  $ch  )
	local $vRetVal = DllCall($User32,"int","IsCharLower","CHAR",$ch)
	return $vRetVal[0]
EndFunc

func _User32_DrawIcon(  $hDC, $X, $Y, $hIcon  )
	local $vRetVal = DllCall($User32,"int","DrawIcon","hwnd",$hDC,"int",$X,"int",$Y,"hwnd",$hIcon)
	return $vRetVal[0]
EndFunc

func _User32_VkKeyScan(  $ch  )
	local $vRetVal = DllCall($User32,"SHORT","VkKeyScan","CHAR",$ch)
	return $vRetVal[0]
EndFunc

func _User32_EnumClipboardFormats(  $format  )
	local $vRetVal = DllCall($User32,"UINT","EnumClipboardFormats","UINT",$format)
	return $vRetVal[0]
EndFunc

func _User32_DrawFrameControl(  $hdc, $lprc, $uType, $uState  )
	local $vRetVal = DllCall($User32,"int","DrawFrameControl","hwnd",$hdc,"ptr",$lprc,"UINT",$uType,"UINT",$uState)
	return $vRetVal[0]
EndFunc

func _User32_WinHelp(  $hWndMain, $lpszHelp, $uCommand, $dwData  )
	local $vRetVal = DllCall($User32,"int","WinHelp","hwnd",$hWndMain,"str",$lpszHelp,"UINT",$uCommand,"ULONG_PTR",$dwData)
	return $vRetVal[0]
EndFunc

func _User32_CreateMDIWindow(  $lpClassName, $lpWindowName, $dwStyle, $X, $Y, $nWidth, $nHeight, $hWndParent, $hInstance, $lParam  )
	local $vRetVal = DllCall($User32,"hwnd","CreateMDIWindow","str",$lpClassName,"str",$lpWindowName,"DWORD",$dwStyle,"int",$X,"int",$Y,"int",$nWidth,"int",$nHeight,"hwnd",$hWndParent,"hwnd",$hInstance,"ptr",$lParam)
	return $vRetVal[0]
EndFunc

func _User32_ClipCursor(  $lpRect  )
	local $vRetVal = DllCall($User32,"int","ClipCursor","ptr",$lpRect)
	return $vRetVal[0]
EndFunc

func _User32_SetWindowContextHelpId(  $hwnd, $dwContextHelpId  )
	local $vRetVal = DllCall($User32,"int","SetWindowContextHelpId","hwnd",$hwnd,"DWORD",$dwContextHelpId)
	return $vRetVal[0]
EndFunc

func _User32_DestroyAcceleratorTable(  $hAccel  )
	local $vRetVal = DllCall($User32,"int","DestroyAcceleratorTable","hwnd",$hAccel)
	return $vRetVal[0]
EndFunc

func _User32_DeregisterShellHookWindow(  $hWnd  )
	local $vRetVal = DllCall($User32,"int","DeregisterShellHookWindow","hwnd",$hWnd)
	return $vRetVal[0]
EndFunc

func _User32_GetMenuItemID(  $hMenu, $nPos  )
	local $vRetVal = DllCall($User32,"UINT","GetMenuItemID","hwnd",$hMenu,"int",$nPos)
	return $vRetVal[0]
EndFunc

func _User32_GetMenuString(  $hMenu, $uIDItem, $lpString, $nMaxCount, $uFlag  )
	local $vRetVal = DllCall($User32,"int","GetMenuString","hwnd",$hMenu,"UINT",$uIDItem,"str",$lpString,"int",$nMaxCount,"UINT",$uFlag)
	return $vRetVal[0]
EndFunc

func _User32_SetMenu(  $hWnd, $hMenu  )
	local $vRetVal = DllCall($User32,"int","SetMenu","hwnd",$hWnd,"hwnd",$hMenu)
	return $vRetVal[0]
EndFunc

func _User32_DrawMenuBar(  $hWnd  )
	local $vRetVal = DllCall($User32,"int","DrawMenuBar","hwnd",$hWnd)
	return $vRetVal[0]
EndFunc

func _User32_GetKeyNameText(  $lParam, $lpString, $nSize  )
	local $vRetVal = DllCall($User32,"int","GetKeyNameText","ptr",$lParam,"str",$lpString,"int",$nSize)
	return $vRetVal[0]
EndFunc

func _User32_SetMenuItemBitmaps(  $hMenu, $uPosition, $uFlags, $hBitmapUnchecked, $hBitmapChecked  )
	local $vRetVal = DllCall($User32,"int","SetMenuItemBitmaps","hwnd",$hMenu,"UINT",$uPosition,"UINT",$uFlags,"hwnd",$hBitmapUnchecked,"hwnd",$hBitmapChecked)
	return $vRetVal[0]
EndFunc

func _User32_WaitForInputIdle(  $hProcess, $dwMilliseconds  )
	local $vRetVal = DllCall($User32,"DWORD","WaitForInputIdle","hwnd",$hProcess,"DWORD",$dwMilliseconds)
	return $vRetVal[0]
EndFunc

func _User32_CopyAcceleratorTable(  $hAccelSrc, $lpAccelDst, $cAccelEntries  )
	local $vRetVal = DllCall($User32,"int","CopyAcceleratorTable","hwnd",$hAccelSrc,"ptr",$lpAccelDst,"int",$cAccelEntries)
	return $vRetVal[0]
EndFunc

func _User32_InvertRect(  $hDC, $lprc  )
	local $vRetVal = DllCall($User32,"int","InvertRect","hwnd",$hDC,"ptr",$lprc)
	return $vRetVal[0]
EndFunc

func _User32_OemKeyScan(  $wOemChar  )
	local $vRetVal = DllCall($User32,"DWORD","OemKeyScan","ushort",$wOemChar)
	return $vRetVal[0]
EndFunc

func _User32_GetMenuCheckMarkDimensions(  )
	local $vRetVal = DllCall($User32,"LONG","GetMenuCheckMarkDimensions")
	return $vRetVal[0]
EndFunc

func _User32_MessageBox(  $hWnd, $lpText, $lpCaption, $uType  )
	local $vRetVal = DllCall($User32,"int","MessageBox","hwnd",$hWnd,"str",$lpText,"str",$lpCaption,"UINT",$uType)
	return $vRetVal[0]
EndFunc

func _User32_MessageBoxEx(  $hWnd, $lpText, $lpCaption, $uType, $wLanguageId  )
	local $vRetVal = DllCall($User32,"int","MessageBoxEx","hwnd",$hWnd,"str",$lpText,"str",$lpCaption,"UINT",$uType,"ushort",$wLanguageId)
	return $vRetVal[0]
EndFunc

func _User32_LoadCursorFromFile(  $lpFileName  )
	local $vRetVal = DllCall($User32,"hwnd","LoadCursorFromFile","str",$lpFileName)
	return $vRetVal[0]
EndFunc

func _User32_DdeEnableCallback(  $idInst, $hConv, $wCmd  )
	local $vRetVal = DllCall($User32,"int","DdeEnableCallback","DWORD",$idInst,"hwnd",$hConv,"UINT",$wCmd)
	return $vRetVal[0]
EndFunc

func _User32_GetClassWord(  $hWnd, $nIndex  )
	local $vRetVal = DllCall($User32,"ushort","GetClassWord","hwnd",$hWnd,"int",$nIndex)
	return $vRetVal[0]
EndFunc

func _User32_EnumProps(  $hWnd, $lpEnumFunc )
	local $vRetVal = DllCall($User32,"int","EnumProps","hwnd",$hWnd,"ptr",$lpEnumFunc)
	return $vRetVal[0]
EndFunc

func _User32_EnumPropsEx(  $hWnd, $lpEnumFunc, $lParam  )
	local $vRetVal = DllCall($User32,"int","EnumPropsEx","hwnd",$hWnd,"ptr",$lpEnumFunc,"ptr",$lParam)
	return $vRetVal[0]
EndFunc

func _User32_ToAscii(  $uVirtKey, $uScanCode, $lpKeyState, $lpChar, $uFlags  )
	local $vRetVal = DllCall($User32,"int","ToAscii","UINT",$uVirtKey,"UINT",$uScanCode,"ptr",$lpKeyState,"ptr",$lpChar,"UINT",$uFlags)
	return $vRetVal[0]
EndFunc

func _User32_ToAsciiEx(  $uVirtKey, $uScanCode, $lpKeyState, $lpChar, $uFlags, $dwhkl  )
	local $vRetVal = DllCall($User32,"int","ToAsciiEx","UINT",$uVirtKey,"UINT",$uScanCode,"ptr",$lpKeyState,"ptr",$lpChar,"UINT",$uFlags,"hwnd",$dwhkl)
	return $vRetVal[0]
EndFunc

func _User32_SwitchToThisWindow(  $hWnd, $fAltTab  )
	local $vRetVal = DllCall($User32,"none","SwitchToThisWindow","hwnd",$hWnd,"int",$fAltTab)
	return $vRetVal[0]
EndFunc

func _User32_GrayString(  $hDC, $hBrush, $lpOutputFunc, $lpData, $nCount, $X, $Y, $nWidth, $nHeight  )
	local $vRetVal = DllCall($User32,"int","GrayString","hwnd",$hDC,"hwnd",$hBrush,"str",$lpOutputFunc,"ptr",$lpData,"int",$nCount,"int",$X,"int",$Y,"int",$nWidth,"int",$nHeight)
	return $vRetVal[0]
EndFunc

func _User32_GetUserObjectSecurity(  $hObj, $pSIRequested, $pSD, $nLength, $lpnLengthNeeded  )
	local $vRetVal = DllCall($User32,"int","GetUserObjectSecurity","hwnd",$hObj,"int",$pSIRequested,"ptr",$pSD,"DWORD",$nLength,"ptr",$lpnLengthNeeded)
	return $vRetVal[0]
EndFunc

func _User32_ArrangeIconicWindows(  $hWnd  )
	local $vRetVal = DllCall($User32,"UINT","ArrangeIconicWindows","hwnd",$hWnd)
	return $vRetVal[0]
EndFunc

func _User32_CloseWindow(  $hWnd  )
	local $vRetVal = DllCall($User32,"int","CloseWindow","hwnd",$hWnd)
	return $vRetVal[0]
EndFunc

func _User32_FlashWindow(  $hWnd, $bInvert  )
	local $vRetVal = DllCall($User32,"int","FlashWindow","hwnd",$hWnd,"int",$bInvert)
	return $vRetVal[0]
EndFunc

func _User32_GetDialogBaseUnits(  )
	local $vRetVal = DllCall($User32,"LONG","GetDialogBaseUnits")
	return $vRetVal[0]
EndFunc

func _User32_OpenIcon(  $hWnd  )
	local $vRetVal = DllCall($User32,"int","OpenIcon","hwnd",$hWnd)
	return $vRetVal[0]
EndFunc

func _User32_GetWindowContextHelpId(  $hwnd  )
	local $vRetVal = DllCall($User32,"DWORD","GetWindowContextHelpId","hwnd",$hwnd)
	return $vRetVal[0]
EndFunc

func _User32_SetCursorPos(  $X, $Y  )
	local $vRetVal = DllCall($User32,"int","SetCursorPos","int",$X,"int",$Y)
	return $vRetVal[0]
EndFunc

func _User32_SetDoubleClickTime(  $uInterval  )
	local $vRetVal = DllCall($User32,"int","SetDoubleClickTime","UINT",$uInterval)
	return $vRetVal[0]
EndFunc

func _User32_ShowOwnedPopups(  $hWnd, $fShow  )
	local $vRetVal = DllCall($User32,"int","ShowOwnedPopups","hwnd",$hWnd,"int",$fShow)
	return $vRetVal[0]
EndFunc

func _User32_SwapMouseButton(  $fSwap  )
	local $vRetVal = DllCall($User32,"int","SwapMouseButton","int",$fSwap)
	return $vRetVal[0]
EndFunc

func _User32_UnloadKeyboardLayout(  $hkl  )
	local $vRetVal = DllCall($User32,"int","UnloadKeyboardLayout","hwnd",$hkl)
	return $vRetVal[0]
EndFunc

func _User32_GetProcessDefaultLayout(  $pdwDefaultLayout  )
	local $vRetVal = DllCall($User32,"int","GetProcessDefaultLayout","DWORD*",$pdwDefaultLayout)
	return $vRetVal[0]
EndFunc

func _User32_SetProcessDefaultLayout(  $dwDefaultLayout  )
	local $vRetVal = DllCall($User32,"int","SetProcessDefaultLayout","DWORD",$dwDefaultLayout)
	return $vRetVal[0]
EndFunc

func _User32_DisableProcessWindowsGhosting(  )
	local $vRetVal = DllCall($User32,"none","DisableProcessWindowsGhosting")
	return $vRetVal[0]
EndFunc

func _User32_GetWindowModuleFileName(  $hwnd, $lpszFileName, $cchFileNameMax  )
	local $vRetVal = DllCall($User32,"UINT","GetWindowModuleFileName","hwnd",$hwnd,"str",$lpszFileName,"UINT",$cchFileNameMax)
	return $vRetVal[0]
EndFunc

func _User32_GetRawInputDeviceInfo(  $hDevice, $uiCommand, $pData, $pcbSize  )
	local $vRetVal = DllCall($User32,"UINT","GetRawInputDeviceInfo","hwnd",$hDevice,"UINT",$uiCommand,"none",$pData,"ptr",$pcbSize)
	return $vRetVal[0]
EndFunc

func _User32_GetMenuInfo(  $hmenu, $lpcmi  )
	local $vRetVal = DllCall($User32,"int","GetMenuInfo","hwnd",$hmenu,"ptr",$lpcmi)
	return $vRetVal[0]
EndFunc

func _User32_GetMessageExtraInfo(  )
	local $vRetVal = DllCall($User32,"LPARAM","GetMessageExtraInfo")
	return $vRetVal[0]
EndFunc

func _User32_SetMessageExtraInfo(  $lParam  )
	local $vRetVal = DllCall($User32,"LPARAM","SetMessageExtraInfo","ptr",$lParam)
	return $vRetVal[0]
EndFunc

func _User32_DefRawInputProc(  $paRawInput, $nInput, $cbSizeHeader  )
	local $vRetVal = DllCall($User32,"LRESULT","DefRawInputProc","ptr",$paRawInput,"INT",$nInput,"UINT",$cbSizeHeader)
	return $vRetVal[0]
EndFunc

func _User32_CreateCursor(  $hInst, $xHotSpot, $yHotSpot, $nWidth, $nHeight, $pvANDPlane, $pvXORPlane  )
	local $vRetVal = DllCall($User32,"hwnd","CreateCursor","hwnd",$hInst,"int",$xHotSpot,"int",$yHotSpot,"int",$nWidth,"int",$nHeight,"ptr",$pvANDPlane,"ptr",$pvXORPlane)
	return $vRetVal[0]
EndFunc

func _User32_CreateIcon(  $hInstance, $nWidth, $nHeight, $cPlanes, $cBitsPixel, $lpbANDbits, $lpbXORbits  )
	local $vRetVal = DllCall($User32,"hwnd","CreateIcon","hwnd",$hInstance,"int",$nWidth,"int",$nHeight,"BYTE",$cPlanes,"BYTE",$cBitsPixel,"BYTE*",$lpbANDbits,"BYTE*",$lpbXORbits)
	return $vRetVal[0]
EndFunc

func _User32_LookupIconIdFromDirectory(  $presbits, $fIcon  )
	local $vRetVal = DllCall($User32,"int","LookupIconIdFromDirectory","ptr",$presbits,"int",$fIcon)
	return $vRetVal[0]
EndFunc

func _User32_CreateIconFromResource(  $presbits, $dwResSize, $fIcon, $dwVer  )
	local $vRetVal = DllCall($User32,"hwnd","CreateIconFromResource","ptr",$presbits,"DWORD",$dwResSize,"int",$fIcon,"DWORD",$dwVer)
	return $vRetVal[0]
EndFunc

func _User32_DlgDirSelectComboBoxEx(  $hDlg, $lpString, $nCount, $nIDComboBox  )
	local $vRetVal = DllCall($User32,"int","DlgDirSelectComboBoxEx","hwnd",$hDlg,"str",$lpString,"int",$nCount,"int",$nIDComboBox)
	return $vRetVal[0]
EndFunc

func _User32_DlgDirListComboBox(  $hDlg, $lpPathSpec, $nIDComboBox, $nIDStaticPath, $uFiletype  )
	local $vRetVal = DllCall($User32,"int","DlgDirListComboBox","hwnd",$hDlg,"str",$lpPathSpec,"int",$nIDComboBox,"int",$nIDStaticPath,"UINT",$uFiletype)
	return $vRetVal[0]
EndFunc

func _User32_DdeQueryNextServer(  $hConvList, $hConvPrev  )
	local $vRetVal = DllCall($User32,"hwnd","DdeQueryNextServer","hwnd",$hConvList,"hwnd",$hConvPrev)
	return $vRetVal[0]
EndFunc

func _User32_DdeConnect(  $idInst, $hszService, $hszTopic, $pCC  )
	local $vRetVal = DllCall($User32,"hwnd","DdeConnect","DWORD",$idInst,"hwnd",$hszService,"hwnd",$hszTopic,"int",$pCC)
	return $vRetVal[0]
EndFunc

func _User32_DdeReconnect(  $hConv  )
	local $vRetVal = DllCall($User32,"hwnd","DdeReconnect","hwnd",$hConv)
	return $vRetVal[0]
EndFunc

func _User32_DdeDisconnect(  $hConv  )
	local $vRetVal = DllCall($User32,"int","DdeDisconnect","hwnd",$hConv)
	return $vRetVal[0]
EndFunc

func _User32_DdeDisconnectList(  $hConvList  )
	local $vRetVal = DllCall($User32,"int","DdeDisconnectList","hwnd",$hConvList)
	return $vRetVal[0]
EndFunc

func _User32_DdeConnectList(  $idInst, $hszService, $hszTopic, $hConvList, $pCC  )
	local $vRetVal = DllCall($User32,"hwnd","DdeConnectList","DWORD",$idInst,"hwnd",$hszService,"hwnd",$hszTopic,"hwnd",$hConvList,"int",$pCC)
	return $vRetVal[0]
EndFunc

func _User32_MapVirtualKeyEx(  $uCode, $uMapType, $dwhkl  )
	local $vRetVal = DllCall($User32,"UINT","MapVirtualKeyEx","UINT",$uCode,"UINT",$uMapType,"hwnd",$dwhkl)
	return $vRetVal[0]
EndFunc

func _User32_RealGetWindowClass(  $hwnd, $pszType, $cchType  )
	local $vRetVal = DllCall($User32,"UINT","RealGetWindowClass","hwnd",$hwnd,"str",$pszType,"UINT",$cchType)
	return $vRetVal[0]
EndFunc

func _User32_ChangeDisplaySettings(  $lpDevMode, $dwflags  )
	local $vRetVal = DllCall($User32,"LONG","ChangeDisplaySettings","ptr",$lpDevMode,"DWORD",$dwflags)
	return $vRetVal[0]
EndFunc

func _User32_EndTask(  $hWnd, $fShutDown, $fForce  )
	local $vRetVal = DllCall($User32,"int","EndTask","hwnd",$hWnd,"int",$fShutDown,"int",$fForce)
	return $vRetVal[0]
EndFunc

func _User32_ExitWindowsEx(  $uFlags, $dwReason  )
	local $vRetVal = DllCall($User32,"int","ExitWindowsEx","UINT",$uFlags,"DWORD",$dwReason)
	return $vRetVal[0]
EndFunc

func _User32_TabbedTextOut(  $hDC, $X, $Y, $lpString, $nCount, $nTabPositions, $lpnTabStopPositions, $nTabOrigin  )
	local $vRetVal = DllCall($User32,"LONG","TabbedTextOut","hwnd",$hDC,"int",$X,"int",$Y,"str",$lpString,"int",$nCount,"int",$nTabPositions,"ptr",$lpnTabStopPositions,"int",$nTabOrigin)
	return $vRetVal[0]
EndFunc

func _User32_GetTabbedTextExtent(  $hDC, $lpString, $nCount, $nTabPositions, $lpnTabStopPositions  )
	local $vRetVal = DllCall($User32,"DWORD","GetTabbedTextExtent","hwnd",$hDC,"str",$lpString,"int",$nCount,"int",$nTabPositions,"ptr",$lpnTabStopPositions)
	return $vRetVal[0]
EndFunc

func _User32_DdeUninitialize(  $idInst  )
	local $vRetVal = DllCall($User32,"int","DdeUninitialize","DWORD",$idInst)
	return $vRetVal[0]
EndFunc

func _User32_DdeGetLastError(  $idInst  )
	local $vRetVal = DllCall($User32,"UINT","DdeGetLastError","DWORD",$idInst)
	return $vRetVal[0]
EndFunc

func _User32_DdeImpersonateClient(  $hConv  )
	local $vRetVal = DllCall($User32,"int","DdeImpersonateClient","hwnd",$hConv)
	return $vRetVal[0]
EndFunc

func _User32_PackDDElParam(  $msg, $uiLo, $uiHi  )
	local $vRetVal = DllCall($User32,"LPARAM","PackDDElParam","UINT",$msg,"UINT_PTR",$uiLo,"UINT_PTR",$uiHi)
	return $vRetVal[0]
EndFunc

func _User32_UnpackDDElParam(  $msg, $lParam, $puiLo, $puiHi  )
	local $vRetVal = DllCall($User32,"int","UnpackDDElParam","UINT",$msg,"ptr",$lParam,"UINT_PTR*",$puiLo,"UINT_PTR*",$puiHi)
	return $vRetVal[0]
EndFunc

func _User32_FreeDDElParam(  $msg, $lParam  )
	local $vRetVal = DllCall($User32,"int","FreeDDElParam","UINT",$msg,"ptr",$lParam)
	return $vRetVal[0]
EndFunc

func _User32_ReuseDDElParam(  $lParam, $msgIn, $msgOut, $uiLo, $uiHi  )
	local $vRetVal = DllCall($User32,"LPARAM","ReuseDDElParam","ptr",$lParam,"UINT",$msgIn,"UINT",$msgOut,"UINT_PTR",$uiLo,"UINT_PTR",$uiHi)
	return $vRetVal[0]
EndFunc

func _User32_SetDlgItemInt(  $hDlg, $nIDDlgItem, $uValue, $bSigned  )
	local $vRetVal = DllCall($User32,"int","SetDlgItemInt","hwnd",$hDlg,"int",$nIDDlgItem,"UINT",$uValue,"int",$bSigned)
	return $vRetVal[0]
EndFunc

func _User32_GetDlgItemInt(  $hDlg, $nIDDlgItem, $lpTranslated, $bSigned  )
	local $vRetVal = DllCall($User32,"UINT","GetDlgItemInt","hwnd",$hDlg,"int",$nIDDlgItem,"int*",$lpTranslated,"int",$bSigned)
	return $vRetVal[0]
EndFunc

func _User32_CheckRadioButton(  $hDlg, $nIDFirstButton, $nIDLastButton, $nIDCheckButton  )
	local $vRetVal = DllCall($User32,"int","CheckRadioButton","hwnd",$hDlg,"int",$nIDFirstButton,"int",$nIDLastButton,"int",$nIDCheckButton)
	return $vRetVal[0]
EndFunc

func _User32_MapDialogRect(  $hDlg, $lpRect  )
	local $vRetVal = DllCall($User32,"int","MapDialogRect","hwnd",$hDlg,"ptr",$lpRect)
	return $vRetVal[0]
EndFunc

func _User32_GetNextDlgGroupItem(  $hDlg, $hCtl, $bPrevious  )
	local $vRetVal = DllCall($User32,"hwnd","GetNextDlgGroupItem","hwnd",$hDlg,"hwnd",$hCtl,"int",$bPrevious)
	return $vRetVal[0]
EndFunc

func _User32_GetRawInputBuffer(  $pData, $pcbSize, $cbSizeHeader  )
	local $vRetVal = DllCall($User32,"UINT","GetRawInputBuffer","ptr",$pData,"UINT*",$pcbSize,"UINT",$cbSizeHeader)
	return $vRetVal[0]
EndFunc

func _User32_DdeAddData(  $hData, $pSrc, $cb, $cbOff  )
	local $vRetVal = DllCall($User32,"hwnd","DdeAddData","hwnd",$hData,"BYTE",$pSrc,"DWORD",$cb,"DWORD",$cbOff)
	return $vRetVal[0]
EndFunc

func _User32_DdeGetData(  $hData, $pDst, $cbMax, $cbOff  )
	local $vRetVal = DllCall($User32,"DWORD","DdeGetData","hwnd",$hData,"BYTE",$pDst,"DWORD",$cbMax,"DWORD",$cbOff)
	return $vRetVal[0]
EndFunc

func _User32_DdeAccessData(  $hData, $pcbDataSize  )
	local $vRetVal = DllCall($User32,"BYTE","DdeAccessData","hwnd",$hData,"DWORD",$pcbDataSize)
	return $vRetVal[0]
EndFunc

func _User32_DdeUnaccessData(  $hData  )
	local $vRetVal = DllCall($User32,"int","DdeUnaccessData","hwnd",$hData)
	return $vRetVal[0]
EndFunc

func _User32_DdeCreateDataHandle(  $idInst, $pSrc, $cb, $cbOff, $hszItem, $wFmt, $afCmd  )
	local $vRetVal = DllCall($User32,"hwnd","DdeCreateDataHandle","DWORD",$idInst,"BYTE",$pSrc,"DWORD",$cb,"DWORD",$cbOff,"hwnd",$hszItem,"UINT",$wFmt,"UINT",$afCmd)
	return $vRetVal[0]
EndFunc

func _User32_DdeFreeDataHandle(  $hData  )
	local $vRetVal = DllCall($User32,"int","DdeFreeDataHandle","hwnd",$hData)
	return $vRetVal[0]
EndFunc

func _User32_DdeCmpStringHandles(  $hsz1, $hsz2  )
	local $vRetVal = DllCall($User32,"int","DdeCmpStringHandles","hwnd",$hsz1,"hwnd",$hsz2)
	return $vRetVal[0]
EndFunc

func _User32_DdeFreeStringHandle(  $idInst, $hsz  )
	local $vRetVal = DllCall($User32,"int","DdeFreeStringHandle","DWORD",$idInst,"hwnd",$hsz)
	return $vRetVal[0]
EndFunc

func _User32_DdeKeepStringHandle(  $idInst, $hsz  )
	local $vRetVal = DllCall($User32,"int","DdeKeepStringHandle","DWORD",$idInst,"hwnd",$hsz)
	return $vRetVal[0]
EndFunc

func _User32_DdeQueryString(  $idInst, $hsz, $psz, $cchMax, $iCodePage  )
	local $vRetVal = DllCall($User32,"DWORD","DdeQueryString","DWORD",$idInst,"hwnd",$hsz,"str",$psz,"DWORD",$cchMax,"int",$iCodePage)
	return $vRetVal[0]
EndFunc

func _User32_GetKBCodePage(  )
	local $vRetVal = DllCall($User32,"UINT","GetKBCodePage")
	return $vRetVal[0]
EndFunc

func _User32_DlgDirList(  $hDlg, $lpPathSpec, $nIDListBox, $nIDStaticPath, $uFileType  )
	local $vRetVal = DllCall($User32,"int","DlgDirList","hwnd",$hDlg,"str",$lpPathSpec,"int",$nIDListBox,"int",$nIDStaticPath,"UINT",$uFileType)
	return $vRetVal[0]
EndFunc

func _User32_DlgDirSelectEx(  $hDlg, $lpString, $nCount, $nIDListBox  )
	local $vRetVal = DllCall($User32,"int","DlgDirSelectEx","hwnd",$hDlg,"str",$lpString,"int",$nCount,"int",$nIDListBox)
	return $vRetVal[0]
EndFunc

func _User32_CascadeWindows(  $hwndParent, $wHow, $lpRect, $cKids, $lpKids  )
	local $vRetVal = DllCall($User32,"ushort","CascadeWindows","hwnd",$hwndParent,"UINT",$wHow,"ptr",$lpRect,"UINT",$cKids,"hwnd*",$lpKids)
	return $vRetVal[0]
EndFunc

func _User32_TileWindows(  $hwndParent, $wHow, $lpRect, $cKids, $lpKids  )
	local $vRetVal = DllCall($User32,"ushort","TileWindows","hwnd",$hwndParent,"UINT",$wHow,"ptr",$lpRect,"UINT",$cKids,"hwnd*",$lpKids)
	return $vRetVal[0]
EndFunc

func _User32_SetMenuInfo(  $hmenu, $lpcmi  )
	local $vRetVal = DllCall($User32,"int","SetMenuInfo","hwnd",$hmenu,"ptr",$lpcmi)
	return $vRetVal[0]
EndFunc

func _User32_GetMenuContextHelpId(  $hmenu  )
	local $vRetVal = DllCall($User32,"DWORD","GetMenuContextHelpId","hwnd",$hmenu)
	return $vRetVal[0]
EndFunc

func _User32_TrackPopupMenu(  $hMenu, $uFlags, $x, $y, $nReserved, $hWnd, $prcRect  )
	local $vRetVal = DllCall($User32,"int","TrackPopupMenu","hwnd",$hMenu,"UINT",$uFlags,"int",$x,"int",$y,"int",$nReserved,"hwnd",$hWnd,"ptr",$prcRect)
	return $vRetVal[0]
EndFunc

func _User32_CheckMenuRadioItem(  $hmenu, $idFirst, $idLast, $idCheck, $uFlags  )
	local $vRetVal = DllCall($User32,"int","CheckMenuRadioItem","hwnd",$hmenu,"UINT",$idFirst,"UINT",$idLast,"UINT",$idCheck,"UINT",$uFlags)
	return $vRetVal[0]
EndFunc

func _User32_SetSysColors(  $cElements, $lpaElements, $lpaRgbValues  )
	local $vRetVal = DllCall($User32,"int","SetSysColors","int",$cElements,"ptr",$lpaElements,"ptr",$lpaRgbValues)
	return $vRetVal[0]
EndFunc

func _User32_ToUnicode(  $wVirtKey, $wScanCode, $lpKeyState, $pwszBuff, $cchBuff, $wFlags  )
	local $vRetVal = DllCall($User32,"int","ToUnicode","UINT",$wVirtKey,"UINT",$wScanCode,"ptr",$lpKeyState,"wstr",$pwszBuff,"int",$cchBuff,"UINT",$wFlags)
	return $vRetVal[0]
EndFunc

func _User32_ToUnicodeEx(  $wVirtKey, $wScanCode, $lpKeyState, $pwszBuff, $cchBuff, $wFlags, $dwhkl  )
	local $vRetVal = DllCall($User32,"int","ToUnicodeEx","UINT",$wVirtKey,"UINT",$wScanCode,"ptr",$lpKeyState,"wstr",$pwszBuff,"int",$cchBuff,"UINT",$wFlags,"hwnd",$dwhkl)
	return $vRetVal[0]
EndFunc

func _User32_SetSystemCursor(  $hcur, $id  )
	local $vRetVal = DllCall($User32,"int","SetSystemCursor","hwnd",$hcur,"DWORD",$id)
	return $vRetVal[0]
EndFunc

func _User32_DrawCaption(  $hwnd, $hdc, $lprc, $uFlags  )
	local $vRetVal = DllCall($User32,"int","DrawCaption","hwnd",$hwnd,"hwnd",$hdc,"ptr",$lprc,"UINT",$uFlags)
	return $vRetVal[0]
EndFunc

func _User32_SetLastErrorEx(  $dwErrCode, $dwType  )
	local $vRetVal = DllCall($User32,"none","SetLastErrorEx","DWORD",$dwErrCode,"DWORD",$dwType)
	return $vRetVal[0]
EndFunc

func _User32_EnableScrollBar(  $hWnd, $wSBflags, $wArrows  )
	local $vRetVal = DllCall($User32,"int","EnableScrollBar","hwnd",$hWnd,"UINT",$wSBflags,"UINT",$wArrows)
	return $vRetVal[0]
EndFunc

func _User32_AnyPopup(  )
	local $vRetVal = DllCall($User32,"int","AnyPopup")
	return $vRetVal[0]
EndFunc

func _User32_IsHungAppWindow(  $hWnd  )
	local $vRetVal = DllCall($User32,"int","IsHungAppWindow","hwnd",$hWnd)
	return $vRetVal[0]
EndFunc

func _User32_IsGUIThread(  $bConvert  )
	local $vRetVal = DllCall($User32,"int","IsGUIThread","int",$bConvert)
	return $vRetVal[0]
EndFunc

func _User32_DdePostAdvise(  $idInst, $hszTopic, $hszItem  )
	local $vRetVal = DllCall($User32,"int","DdePostAdvise","DWORD",$idInst,"hwnd",$hszTopic,"hwnd",$hszItem)
	return $vRetVal[0]
EndFunc

func _User32_DdeClientTransaction(  $pData, $cbData, $hConv, $hszItem, $wFmt, $wType, $dwTimeout, $pdwResult  )
	local $vRetVal = DllCall($User32,"hwnd","DdeClientTransaction","BYTE",$pData,"DWORD",$cbData,"hwnd",$hConv,"hwnd",$hszItem,"UINT",$wFmt,"UINT",$wType,"DWORD",$dwTimeout,"DWORD",$pdwResult)
	return $vRetVal[0]
EndFunc

func _User32_DdeQueryConvInfo(  $hConv, $idTransaction, $pConvInfo  )
	local $vRetVal = DllCall($User32,"UINT","DdeQueryConvInfo","hwnd",$hConv,"DWORD",$idTransaction,"ptr",$pConvInfo)
	return $vRetVal[0]
EndFunc

func _User32_DdeSetUserHandle(  $hConv, $id, $hUser  )
	local $vRetVal = DllCall($User32,"int","DdeSetUserHandle","hwnd",$hConv,"DWORD",$id,"hwnd",$hUser)
	return $vRetVal[0]
EndFunc

func _User32_DdeAbandonTransaction(  $idInst, $hConv, $idTransaction  )
	local $vRetVal = DllCall($User32,"int","DdeAbandonTransaction","DWORD",$idInst,"hwnd",$hConv,"DWORD",$idTransaction)
	return $vRetVal[0]
EndFunc

func _User32_WINNLSEnableIME(  $hwnd, $bFlag  )
	local $vRetVal = DllCall($User32,"int","WINNLSEnableIME","hwnd",$hwnd,"int",$bFlag)
	return $vRetVal[0]
EndFunc

func _User32_SendIMEMessageEx(  $hwnd, $lParam  )
	local $vRetVal = DllCall($User32,"LRESULT","SendIMEMessageEx","hwnd",$hwnd,"ptr",$lParam)
	return $vRetVal[0]
EndFunc

func _User32_BlockInput(  $fBlockIt  )
	local $vRetVal = DllCall($User32,"int","BlockInput","int",$fBlockIt)
	return $vRetVal[0]
EndFunc

func _User32_DdeSetQualityOfService(  $hwndClient, $pqosNew, $pqosPrev  )
	local $vRetVal = DllCall($User32,"int","DdeSetQualityOfService","hwnd",$hwndClient,"int*",$pqosNew,"int",$pqosPrev)
	return $vRetVal[0]
EndFunc

func _User32_DragDetect(  $hwnd, $pt  )
	local $vRetVal = DllCall($User32,"int","DragDetect","hwnd",$hwnd,"ptr",$pt)
	return $vRetVal[0]
EndFunc

func _User32_DrawAnimatedRects(  $hwnd, $idAni, $lprcFrom, $lprcTo  )
	local $vRetVal = DllCall($User32,"int","DrawAnimatedRects","hwnd",$hwnd,"int",$idAni,"ptr",$lprcFrom,"ptr",$lprcTo)
	return $vRetVal[0]
EndFunc

func _User32_EndMenu(  )
	local $vRetVal = DllCall($User32,"int","EndMenu")
	return $vRetVal[0]
EndFunc

func _User32_FlashWindowEx(  $pfwi  )
	local $vRetVal = DllCall($User32,"int","FlashWindowEx","int",$pfwi)
	return $vRetVal[0]
EndFunc

func _User32_GetClipboardViewer( )
	local $vRetVal = DllCall($User32,"hwnd","GetClipboardViewer")
	return $vRetVal[0]
EndFunc

func _User32_GetClipCursor(  $lpRect  )
	local $vRetVal = DllCall($User32,"int","GetClipCursor","ptr",$lpRect)
	return $vRetVal[0]
EndFunc

func _User32_GetComboBoxInfo(  $hwndCombo, $pcbi  )
	local $vRetVal = DllCall($User32,"int","GetComboBoxInfo","hwnd",$hwndCombo,"int",$pcbi)
	return $vRetVal[0]
EndFunc

func _User32_GetCursorInfo(  $pci  )
	local $vRetVal = DllCall($User32,"int","GetCursorInfo","int",$pci)
	return $vRetVal[0]
EndFunc

func _User32_GetGuiResources(  $hProcess, $uiFlags  )
	local $vRetVal = DllCall($User32,"DWORD","GetGuiResources","hwnd",$hProcess,"DWORD",$uiFlags)
	return $vRetVal[0]
EndFunc

func _User32_GetListBoxInfo(  $hwnd  )
	local $vRetVal = DllCall($User32,"DWORD","GetListBoxInfo","hwnd",$hwnd)
	return $vRetVal[0]
EndFunc

func _User32_GetMenuBarInfo(  $hwnd, $idObject, $idItem, $pmbi  )
	local $vRetVal = DllCall($User32,"int","GetMenuBarInfo","hwnd",$hwnd,"LONG",$idObject,"LONG",$idItem,"int",$pmbi)
	return $vRetVal[0]
EndFunc

func _User32_GetMenuItemRect(  $hWnd, $hMenu, $uItem, $lprcItem  )
	local $vRetVal = DllCall($User32,"int","GetMenuItemRect","hwnd",$hWnd,"hwnd",$hMenu,"UINT",$uItem,"ptr",$lprcItem)
	return $vRetVal[0]
EndFunc

func _User32_GetMouseMovePointsEx(  $cbSize, $lppt, $lpptBuf, $nBufPoints, $resolution  )
	local $vRetVal = DllCall($User32,"int","GetMouseMovePointsEx","UINT",$cbSize,"ptr",$lppt,"ptr",$lpptBuf,"int",$nBufPoints,"DWORD",$resolution)
	return $vRetVal[0]
EndFunc

func _User32_GetPriorityClipboardFormat(  $paFormatPriorityList, $cFormats  )
	local $vRetVal = DllCall($User32,"int","GetPriorityClipboardFormat","UINT*",$paFormatPriorityList,"int",$cFormats)
	return $vRetVal[0]
EndFunc

func _User32_GetRawInputData(  $hRawInput, $uiCommand, $pData, $pcbSize, $cbSizeHeader  )
	local $vRetVal = DllCall($User32,"UINT","GetRawInputData","hwnd",$hRawInput,"UINT",$uiCommand,"ptr",$pData,"UINT*",$pcbSize,"UINT",$cbSizeHeader)
	return $vRetVal[0]
EndFunc

func _User32_GetRawInputDeviceList(  $pRawInputDeviceList, $puiNumDevices, $cbSize  )
	local $vRetVal = DllCall($User32,"UINT","GetRawInputDeviceList","int",$pRawInputDeviceList,"UINT*",$puiNumDevices,"UINT",$cbSize)
	return $vRetVal[0]
EndFunc

func _User32_GetRegisteredRawInputDevices(  $pRawInputDevices, $puiNumDevices, $cbSize  )
	local $vRetVal = DllCall($User32,"UINT","GetRegisteredRawInputDevices","int",$pRawInputDevices,"UINT*",$puiNumDevices,"UINT",$cbSize)
	return $vRetVal[0]
EndFunc

func _User32_HiliteMenuItem(  $hwnd, $hmenu, $uItemHilite, $uHilite  )
	local $vRetVal = DllCall($User32,"int","HiliteMenuItem","hwnd",$hwnd,"hwnd",$hmenu,"UINT",$uItemHilite,"UINT",$uHilite)
	return $vRetVal[0]
EndFunc

func _User32_ImpersonateDdeClientWindow(  $hWndClient, $hWndServer  )
	local $vRetVal = DllCall($User32,"int","ImpersonateDdeClientWindow","hwnd",$hWndClient,"hwnd",$hWndServer)
	return $vRetVal[0]
EndFunc

func _User32_LockWorkStation(  )
	local $vRetVal = DllCall($User32,"int","LockWorkStation")
	return $vRetVal[0]
EndFunc

func _User32_MenuItemFromPoint(  $hWnd, $hMenu, $ptScreen  )
	local $vRetVal = DllCall($User32,"int","MenuItemFromPoint","hwnd",$hWnd,"hwnd",$hMenu,"ptr",$ptScreen)
	return $vRetVal[0]
EndFunc

func _User32_RealChildWindowFromPoint(  $hwndParent, $ptParentClientCoords  )
	local $vRetVal = DllCall($User32,"hwnd","RealChildWindowFromPoint","hwnd",$hwndParent,"ptr",$ptParentClientCoords)
	return $vRetVal[0]
EndFunc

func _User32_RegisterRawInputDevices(  $pRawInputDevices, $uiNumDevices, $cbSize  )
	local $vRetVal = DllCall($User32,"int","RegisterRawInputDevices","int",$pRawInputDevices,"UINT",$uiNumDevices,"UINT",$cbSize)
	return $vRetVal[0]
EndFunc

func _User32_SetClassWord(  $hWnd, $nIndex, $wNewWord  )
	local $vRetVal = DllCall($User32,"ushort","SetClassWord","hwnd",$hWnd,"int",$nIndex,"ushort",$wNewWord)
	return $vRetVal[0]
EndFunc

func _User32_SetMenuContextHelpId(  $hmenu, $dwContextHelpId  )
	local $vRetVal = DllCall($User32,"int","SetMenuContextHelpId","hwnd",$hmenu,"DWORD",$dwContextHelpId)
	return $vRetVal[0]
EndFunc

func _User32_SetUserObjectInformation(  $hObj, $nIndex, $pvInfo, $nLength  )
	local $vRetVal = DllCall($User32,"int","SetUserObjectInformation","hwnd",$hObj,"int",$nIndex,"ptr",$pvInfo,"DWORD",$nLength)
	return $vRetVal[0]
EndFunc

func _User32_TrackPopupMenuEx(  $hmenu, $fuFlags, $x, $y, $hwnd, $lptpm  )
	local $vRetVal = DllCall($User32,"int","TrackPopupMenuEx","hwnd",$hmenu,"UINT",$fuFlags,"int",$x,"int",$y,"hwnd",$hwnd,"ptr",$lptpm)
	return $vRetVal[0]
EndFunc

func _User32_UnregisterHotKey(  $hWnd, $id  )
	local $vRetVal = DllCall($User32,"int","UnregisterHotKey","hwnd",$hWnd,"int",$id)
	return $vRetVal[0]
EndFunc

func _User32_GetLayeredWindowAttributes(  $hwnd, $pcrKey, $pbAlpha, $pdwFlags  )
	local $vRetVal = DllCall($User32,"int","GetLayeredWindowAttributes","hwnd",$hwnd,"ptr",$pcrKey,"BYTE*",$pbAlpha,"DWORD*",$pdwFlags)
	return $vRetVal[0]
EndFunc

func _User32_UserHandleGrantAccess(  $hUserHandle, $hJob, $bGrant  )
	local $vRetVal = DllCall($User32,"int","UserHandleGrantAccess","hwnd",$hUserHandle,"hwnd",$hJob,"int",$bGrant)
	return $vRetVal[0]
EndFunc

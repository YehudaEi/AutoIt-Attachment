#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.13.3 (beta)
 Author:         Kip

 Script Function:
	Split your GUIs into different frames

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <WinAPI.au3>
#include <StaticConstants.au3>
#include <Constants.au3>

Global $FR_FrameControls[1][10]
Global Const $FR_HORZ = 1
Global Const $FR_VERT = 2

Global $FR_CALLBACK = ""

; >> GetInfo Constants

Global Const $FR_PARENT = 0
Global Const $FR_FIRST = 2
Global Const $FR_SECOND = 3
Global Const $FR_RESIZE = 4
Global Const $FR_RESIZESIZE = 5
Global Const $FR_RESIZEOVERLAP = 6
Global Const $FR_FRAMESTYLE = 7
Global Const $FR_FIRSTMIN = 8
Global Const $FR_SECONDMIN = 9

; <<

#cs

0	$hParent
1	$hResize
2	$hFirstFrame
3	$hSecondFrame
4	$hResizeMask
5	$iResizeSize
6	$iResizeOverlap
7	$iFrameStyle
8	$iFirstMin
9	$iSecondMin

#CE

Global $RegMsg_Proc[1][2]

Func _GUIFrame_GetInfo($iFrame, $iElement)
	
	If $iFrame < 1 or $iFrame > UBound($FR_FrameControls)-1 Then Return 0
	If $iElement < 0 or $iElement > UBound($FR_FrameControls,2)-1 Then Return 0
	
	Return $FR_FrameControls[$iFrame][$iElement]
	
EndFunc

Func _GUIFrame_Move($iFrame, $iX, $iY, $iWidth=0, $iHeight=0)
	
	If $iFrame < 1 or $iFrame > UBound($FR_FrameControls)-1 Then Return 0
	
	If not $iWidth Then $iWidth = _WinAPI_GetWindowWidth($FR_FrameControls[$iFrame][$FR_PARENT])
	If not $iHeight Then $iHeight = _WinAPI_GetWindowHeight($FR_FrameControls[$iFrame][$FR_PARENT])
	
	WinMove($FR_FrameControls[$iFrame][$FR_PARENT],"",$iX, $iY, $iWidth, $iHeight)
	
	$aWinPos = WinGetClientSize($FR_FrameControls[$iFrame][2])
	$iSize = $aWinPos[0]
	If $FR_FrameControls[$iFrame][$FR_FRAMESTYLE] = $FR_HORZ Then $iSize = $aWinPos[1]
	
	_GUIFrame_SetSize($iFrame, $iSize)
	
EndFunc

Func _GUIFrame_SetSize($iFrame, $iSize, $iSide=$FR_FIRST)
	
	If $iFrame < 1 or $iFrame > UBound($FR_FrameControls)-1 Then Return 0
	
	$iFirstMin = $FR_FrameControls[$iFrame][$FR_FIRSTMIN]
	$iSecondMin = $FR_FrameControls[$iFrame][$FR_SECONDMIN]
	$iResizeSize = $FR_FrameControls[$iFrame][$FR_RESIZESIZE]
	$iResizeOverlap = $FR_FrameControls[$iFrame][$FR_RESIZEOVERLAP]
	
	$aClientSize = WinGetClientSize($FR_FrameControls[$iFrame][$FR_PARENT])
	
	If $FR_FrameControls[$iFrame][$FR_FRAMESTYLE] = $FR_VERT Then
		
		$iTotal = $aClientSize[0]
		
		If $iSide = $FR_SECOND Then $iSize = $iTotal-$iSize-$iResizeSize
		
		If $iSize < $iFirstMin Then $iSize = $iFirstMin
		
		If $iTotal-$iSize-$iResizeSize < $iSecondMin Then $iSize = $iTotal-$iSecondMin-$iResizeSize
		
		WinMove($FR_FrameControls[$iFrame][$FR_FIRST],"",0,0,$iSize,$aClientSize[1])
		WinMove($FR_FrameControls[$iFrame][$FR_SECOND],"",$iSize+$iResizeSize,0,$iTotal-$iSize-$iResizeSize,$aClientSize[1])
		WinMove($FR_FrameControls[$iFrame][1],"",$iSize,0,$iResizeSize,$aClientSize[1])
		
	ElseIf $FR_FrameControls[$iFrame][$FR_FRAMESTYLE] = $FR_HORZ Then
		
		$iTotal = $aClientSize[1]
		
		If $iSide = $FR_SECOND Then $iSize = $iTotal-$iSize-$iResizeSize
		
		If $iSize < $iFirstMin Then $iSize = $iFirstMin
		
		If $iTotal-$iSize-$iResizeSize < $iSecondMin Then $iSize = $iTotal-$iSecondMin-$iResizeSize
		
		WinMove($FR_FrameControls[$iFrame][$FR_FIRST],"",0,0,$aClientSize[0],$iSize)
		WinMove($FR_FrameControls[$iFrame][$FR_SECOND],"",0,$iSize+$iResizeSize,$aClientSize[0],$iTotal-$iSize-$iResizeSize)
		WinMove($FR_FrameControls[$iFrame][1],"",0, $iSize,$aClientSize[0], $iResizeSize)
		
	EndIf
	
	Return 1
	
EndFunc

Func _GUIFrame_SetMin($iFrame, $iFirst=-1, $iSecond=-1)
	
	If $iFrame < 1 or $iFrame > UBound($FR_FrameControls)-1 Then Return 0
	
	If $iFirst > -1 Then $FR_FrameControls[$iFrame][8] = $iFirst
	If $iSecond > -1 Then $FR_FrameControls[$iFrame][9] = $iSecond
	
	Return 1
	
EndFunc

Func _GUIFrame_First($iFrame)
	If $iFrame < 1 or $iFrame > UBound($FR_FrameControls)-1 Then Return 0
	Return GUISwitch($FR_FrameControls[$iFrame][2])
EndFunc

Func _GUIFrame_Second($iFrame)
	If $iFrame < 1 or $iFrame > UBound($FR_FrameControls)-1 Then Return 0
	Return GUISwitch($FR_FrameControls[$iFrame][3])
EndFunc

Func _GUIFrame_Create($hWnd, $iFrameStyle, $iX=0, $iY=0, $iWidth=0, $iHeight=0, $iStyle=0, $iExStyle=0)
	
	Local $aSize = WinGetClientSize($hWnd)
	
	If not $iWidth Then $iWidth = $aSize[0]
	if not $iHeight Then $iHeight = $aSize[1]
	
	
	Local $hParent = GUICreate("FrameParent",$iWidth,$iHeight,$iX,$iY,BitOR($WS_CHILD,$iStyle),$iExStyle,$hWnd)
	
	GUISetState(@SW_SHOW, $hParent)
	
	Local $aSize = WinGetClientSize($hParent)
	
	$iWidth = $aSize[0]
	$iHeight = $aSize[1]
	
	Local $iResizeSize = 8
	Local $iResizeOverlap = 0
	
	If $iFrameStyle = $FR_VERT Then
		
		Local $iResizeX = Round(($iWidth/2)-($iResizeSize/2))
		
		Local $hResize = GUICreate("FrameResize"&UBound($FR_FrameControls),$iResizeSize,$iHeight,$iResizeX,0,$WS_CHILD,-1,$hParent)
		Local $hResizeMask = GUICtrlCreateLabel("",0,0-$iResizeOverlap,$iResizeSize,$iHeight+($iResizeOverlap*2),-1,$WS_EX_DLGMODALFRAME )
		GUICtrlSetCursor(-1,13)
		
		GUISetState(@SW_SHOW, $hResize)
		
		Local $hFirstFrame = GUICreate("FirstFrame"&UBound($FR_FrameControls),$iResizeX,$iHeight,0,0,$WS_CHILD,-1,$hParent)
		GUISetState(@SW_SHOW, $hFirstFrame)
		
		Local $hSecondFrame = GUICreate("SecondFrame"&UBound($FR_FrameControls),$iWidth-($iResizeX+$iResizeSize),$iHeight,$iResizeX+$iResizeSize,0,$WS_CHILD,-1,$hParent)
		GUISetState(@SW_SHOW, $hSecondFrame)
		
	ElseIf $iFrameStyle = $FR_HORZ Then
		
		Local $iResizeX = Round(($iHeight/2)-($iResizeSize/2))
		
		Local $hResize = GUICreate("FrameResize"&UBound($FR_FrameControls), $iWidth, $iResizeSize, 0, $iResizeX, $WS_CHILD, -1, $hParent)
		Local $hResizeMask = GUICtrlCreateLabel("", 0-$iResizeOverlap, 0, $iWidth+($iResizeOverlap*2), $iResizeSize, -1, $WS_EX_DLGMODALFRAME )
		GUICtrlSetCursor(-1,11)
		
		GUISetState(@SW_SHOW, $hResize)
		
		Local $hFirstFrame = GUICreate("FirstFrame"&UBound($FR_FrameControls),$iWidth,$iResizeX,0,0,$WS_CHILD,-1,$hParent)
		GUISetState(@SW_SHOW, $hFirstFrame)
		
		Local $hSecondFrame = GUICreate("SecondFrame"&UBound($FR_FrameControls),$iWidth,$iHeight-($iResizeX+$iResizeSize),0,$iResizeX+$iResizeSize,$WS_CHILD,-1,$hParent)
		GUISetState(@SW_SHOW, $hSecondFrame)
		
	EndIf
	
	_RegMsg_Register($hResize, "FrameCallback")
	
	ReDim $FR_FrameControls[UBound($FR_FrameControls)+1][10]
	
	$FR_FrameControls[UBound($FR_FrameControls)-1][0] = $hParent
	$FR_FrameControls[UBound($FR_FrameControls)-1][1] = $hResize
	$FR_FrameControls[UBound($FR_FrameControls)-1][2] = $hFirstFrame
	$FR_FrameControls[UBound($FR_FrameControls)-1][3] = $hSecondFrame
	$FR_FrameControls[UBound($FR_FrameControls)-1][4] = $hResizeMask
	$FR_FrameControls[UBound($FR_FrameControls)-1][5] = $iResizeSize
	$FR_FrameControls[UBound($FR_FrameControls)-1][6] = $iResizeOverlap
	$FR_FrameControls[UBound($FR_FrameControls)-1][7] = $iFrameStyle
	$FR_FrameControls[UBound($FR_FrameControls)-1][8] = 0
	$FR_FrameControls[UBound($FR_FrameControls)-1][9] = 0
	
	GUISwitch($hWnd)
	
	Return UBound($FR_FrameControls)-1
	
EndFunc

Func FrameCallback($hWnd, $iMsg, $wParam, $lParam)
	
	Switch $iMsg
		
		Case 0x0111
			
			$iID = 0
			
			For $i = 1 to UBound($FR_FrameControls)-1
				If $FR_FrameControls[$i][1] = $hWnd Then
					$iID = $i
					ExitLoop
				EndIf
			Next
			
			If Not $iID Then Return _RegMsg_Return($hWnd, $iMsg, $wParam, $lParam)
			
			Local $hParent = $FR_FrameControls[$iID][0]
			Local $hResize = $FR_FrameControls[$iID][1]
			Local $hFirstFrame = $FR_FrameControls[$iID][2]
			Local $hSecondFrame = $FR_FrameControls[$iID][3]
			Local $iResizeSize = $FR_FrameControls[$iID][5]
			Local $iResizeOverlap = $FR_FrameControls[$iID][6]
			Local $iFirstMin = $FR_FrameControls[$iID][8]
			Local $iSecondMin = $FR_FrameControls[$iID][9]
			
			$aClientSize = WinGetClientSize($hParent)
			$iWidth = $aClientSize[0]
			$iHeight = $aClientSize[1]
			
			$aCInfo = GUIGetCursorInfo($hResize)
			
			If $FR_FrameControls[$iID][7] = $FR_VERT Then
				
				$iSubtract = $aCInfo[0]
				
				Do 
					
					$aCInfo = GUIGetCursorInfo($hParent)
					$iCursorX = $aCInfo[0]
					
					$iFirstWidth = $iCursorX-$iSubtract
					
					If $iFirstWidth < $iFirstMin Then
						$iFirstWidth = $iFirstMin
					EndIf
					
					If $iWidth-($iFirstWidth+$iResizeSize) < $iSecondMin Then
						$iFirstWidth = $iWidth-$iSecondMin-$iResizeSize
					EndIf
					
					WinMove($hFirstFrame,"",0,0,$iFirstWidth,$iHeight)
					WinMove($hSecondFrame,"",$iFirstWidth+$iResizeSize,0,$iWidth-($iFirstWidth+$iResizeSize),$iHeight)
					WinMove($hResize,"",$iFirstWidth,0,$iResizeSize,$iHeight)
					
					If $FR_CALLBACK Then Call($FR_CALLBACK,$iID,$iFirstWidth,$iWidth-($iFirstWidth+$iResizeSize))
					
				Until Not _WinAPI_GetAsyncKeyState(0x01)
				
			ElseIf $FR_FrameControls[$iID][7] = $FR_HORZ Then
				
				$iSubtract = $aCInfo[1]
				
				Do 
					
					$aCInfo = GUIGetCursorInfo($hParent)
					$iCursorY = $aCInfo[1]
					
					$iFirstHeight = $iCursorY-$iSubtract
					
					If $iFirstHeight < $iFirstMin Then
						$iFirstHeight = $iFirstMin
					EndIf
					
					If $iHeight-($iFirstHeight+$iResizeSize) < $iSecondMin Then
						$iFirstHeight = $iHeight-$iSecondMin-$iResizeSize
					EndIf
					
					WinMove($hFirstFrame,"",0,0,$iWidth,$iFirstHeight)
					WinMove($hSecondFrame,"",0,$iFirstHeight+$iResizeSize,$iWidth,$iHeight-($iFirstHeight+$iResizeSize))
					WinMove($hResize,"",0,$iFirstHeight,$iWidth,$iResizeSize)
					
					If $FR_CALLBACK Then Call($FR_CALLBACK,$iID,$iFirstHeight,$iHeight-($iFirstHeight+$iResizeSize))
					
				Until Not _WinAPI_GetAsyncKeyState(0x01)
				
			EndIf
			
	EndSwitch
	
	Return _RegMsg_Return($hWnd, $iMsg, $wParam, $lParam)
	
EndFunc

Func _RegMsg_Register($hWnd, $sFunction)
	
	Local $Exists = 0
	
	For $i = 1 to UBound($RegMsg_Proc)-1
		If $RegMsg_Proc[$i][0] = $hWnd Then
			
			$Exists = $i
			ExitLoop
		EndIf
	Next
	
	If Not $Exists Then
		ReDim $RegMsg_Proc[UBound($RegMsg_Proc)+1][2]
		$RegMsg_Proc[UBound($RegMsg_Proc)-1][0] = $hWnd
		$Exists = UBound($RegMsg_Proc)-1
	EndIf
	
	Local $sCallback = DllCallbackRegister($sFunction,"int","hwnd;uint;wparam;lparam")
	$RegMsg_Proc[$Exists][1] = _WinAPI_SetWindowLong($hWnd,$GWL_WNDPROC,DllCallBackGetPtr($sCallback))
	
	Return $RegMsg_Proc[$i][1]
	
EndFunc

Func _RegMsg_Return($hWnd, $iMsg, $wParam, $lParam)
	
	For $i = 1 to UBound($RegMsg_Proc)-1
		If $RegMsg_Proc[$i][0] = $hWnd Then Return _WinAPI_CallWindowProc($RegMsg_Proc[$i][1],$hWnd,$iMsg,$wParam,$lParam)
	Next
	
EndFunc
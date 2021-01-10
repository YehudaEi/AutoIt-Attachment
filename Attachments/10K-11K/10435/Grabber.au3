#include <GUIConstants.au3>
#Include <Misc.au3>
;;;;;;;; Acknowledgments:
; thanks to Lazycat for the great captdll.dll
; thanks to Jon and the AutoitTeam for this great program
;;;;;;;;

;;;;;;;;;;;;;;
;	GLOBALS
;;;;;;;;;;;;;;
If _Singleton("softysoft", 1) = 0 Then
   Exit
EndIf
Const $Ver = 'softysoft'

Global $gPath = @DesktopDir & '\Captured'
If Not FileExists($gPath) Then
   DirCreate($gPath)
EndIf

$Instructions='clic the Data button AND THEN click the window you want to grab.' &@CRLF &'The info of active button and static controls is reported to the main edit ' &@CRLF &'on grabber and saved as a text file to a captured folder on the desktop.' &@CRLF  &@CRLF _
			&'click the All button and then click on the window you want to grab.' &@CRLF &'This saves both the data and a jpg of the active window.' 
; == GUI generated with Koda ==
$IpSpyGui = GUICreate("Grabber", 400, 300, @DesktopWidth - 400, 0, $DS_SETFOREGROUND, $WS_EX_TOPMOST)
GUISetBkColor(0x7A96DF)

$CtrlWinName = GUICtrlCreateEdit("The window name will appear here", 10, 10, 380, 20, -1, BitOR($WS_EX_CLIENTEDGE, $WS_EX_STATICEDGE))

$CtrlWinData = GUICtrlCreateEdit('', 10, 40, 380, 200, -1, $WS_EX_CLIENTEDGE)
GUICtrlSetData($CtrlWinData, $Instructions)

$CtrlDataBtn = GUICtrlCreateButton("Data", 10, 245, 75, 25)
$CtrlAllBtn = GUICtrlCreateButton("All", 200 - 38, 245, 75, 25)
$CtrlExitBtn = GUICtrlCreateButton("Chao!", 390 - 75, 245, 75, 25)
GUISetState(@SW_SHOW)

Global $DataType = 'Data'

While 1
   $msg = GUIGetMsg()
   Select
      Case $msg = $GUI_EVENT_CLOSE
         ExitLoop
      Case $msg = $CtrlDataBtn
         $DataType = 'Data'
         CaptureData()
      Case $msg = $CtrlAllBtn
         $DataType = 'All'
         CaptureData()
      Case $msg = $CtrlExitBtn
         Exit
      Case Else
   EndSelect
WEnd
Exit

Func CaptureData()
   Local $lWhichWin, $TempData = '', $lDataFileName, $lPicFileName, $lWinPos, $lTmpFileName, $lTmpFileHandle
   $lWhichWin = GetWin()
   $lButtonStaticControlList = GetTextActiveButtonAndStaticList($lWhichWin[1])
   GUICtrlSetData($CtrlWinName, $lWhichWin[0]) ;title
   $TempData = '----------------------------------------------' & @CRLF &'Window Name:' &$lWhichWin[0] & @CRLF & '++++++++++++++++++++++++++++++++++++++++++++++' & @CRLF
   For $i = 1 To $lButtonStaticControlList[0][0] Step 1
      $TempData &= 'CtrlId: ' & $lButtonStaticControlList[$i][0] & @CRLF
      $TempData &= 'Text: ' & $lButtonStaticControlList[$i][2] & @CRLF
      $TempData &= 'CtrlHndl: ' & $lButtonStaticControlList[$i][1] & @CRLF
   Next
   $TempData &= '----------------------------------------------' & @CRLF
   GUICtrlSetData($CtrlWinData, $TempData)
   
   If $DataType = 'All' Then
      $lPicFileName = SafeFileName($lWhichWin[0], $DataType)
      $lWinPos = WinGetPos($lWhichWin[1])
      GUISetState(@SW_HIDE)
      DllCall("captdll.dll", "int", "CaptureRegion", "str", $lPicFileName, "int", $lWinPos[0], "int", $lWinPos[1], "int", $lWinPos[2], "int", $lWinPos[3], "int", 100)
      GUISetState(@SW_SHOW)
      $lTmpFileName = SafeFileName($lWhichWin[0], 'Data')
      $lTmpFileHandle = FileOpen($lTmpFileName, 1)
      FileWriteLine($lTmpFileHandle, $TempData)
      FileClose($lTmpFileHandle)
   EndIf
   
   If $DataType = 'Data' Then
      $lTmpFileName = SafeFileName($lWhichWin[0], $DataType)
      $lTmpFileHandle = FileOpen($lTmpFileName, 1)
      FileWriteLine($lTmpFileHandle, $TempData)
      FileClose($lTmpFileHandle)
   EndIf
EndFunc   ;==>CaptureData

Func SafeFileName($pWin, $pExt)
   Local $lSafeFileName, $lCount = 0, $lTmpFileName, $lReplaceChars = '\, /, <, >, *, ?, !, ., ", |, :, ;, ' & "'"
   If $pExt = 'Data' Then
      $pExt = '.txt'
   ElseIf $pExt = 'All' Then
      $pExt = '.jpg'
   EndIf
   $lSafeFileName = $pWin
   $lReplaceChars = StringSplit($lReplaceChars, ',')
   For $i = 1 To $lReplaceChars[0] Step 1
      $lSafeFileName = StringReplace($lSafeFileName, $lReplaceChars[$i], '_')
   Next
   
   If Not FileExists($gPath & '\' & $lSafeFileName & $pExt) Then
      Return $gPath & '\' & $lSafeFileName & $pExt
   ElseIf FileExists($gPath & '\' & $lSafeFileName & $pExt) Then
      While 1
         $lTmpFileName = $gPath & '\' & $lSafeFileName & $lCount & $pExt
         If Not FileExists($gPath & '\' & $lSafeFileName & $lCount & '.txt') Then
            Return $lTmpFileName
            ExitLoop
         EndIf
         $lCount += 1
      WEnd
   EndIf
   Return $lSafeFileName
EndFunc   ;==>SafeFileName

Func GetWin()
   Dim $lWinFound[2]
   Local $lDll, $lWinList, $lWinState ; $lMouePos
   $lDll = DllOpen("user32.dll")
   While 1
      Sleep(250)
      If _IsPressed('01', $lDll) Then
         ExitLoop
      EndIf
   WEnd
   DllClose($lDll)
   $lWinList = WinList()
   For $i = 1 To $lWinList[0][0] Step 1
      If IsString($lWinList[$i][0]) And $lWinList[$i][0] <> '' Then
         If WinActive($lWinList[$i][1]) Then
            $lWinState = WinGetState($lWinList[$i][1])
            If BitAND($lWinState, 4) Then
               $lWinFound[0] = $lWinList[$i][0];title
               $lWinFound[1] = $lWinList[$i][1];handle
               Return $lWinFound
            EndIf
         EndIf
      EndIf
   Next
EndFunc   ;==>GetWin

Func IsVisible($pHandle)
   If BitAND( WinGetState($pHandle), 2) Then
      Return 1
   Else
      Return 0
   EndIf
EndFunc   ;==>IsVisible

Func GetTextActiveButtonAndStaticList($pWinHndl)
   Local $lControlClassList = ''
   Local $lControlCount = ''
   Local $lControlHandle = ''
   Local $lState = ''
   Local $lRetreiveClassNameText = ''
   Local $checker
   
   Dim $ActiveControlText[1][3]
   
   $lControlClassList = WinGetClassList($pWinHndl)
   $lControlClassList = StringStripWS(StringReplace($lControlClassList, @LF, @TAB), 2)
   $lControlClassList = StringSplit($lControlClassList, @TAB)
   
   For $i = 1 To $lControlClassList[0]Step 1
      $lControlClassList[$i] = StringReplace($lControlClassList[$i], @TAB, '')
   Next
   
   
   $lCountClassName = UBound($ActiveControlText, 1)
   For $i = 1 To $lControlClassList[0]Step 1
      For $j = 1 To $lControlClassList[0]Step 1
         If StringInStr($lControlClassList[$i], 'Button') Then
            $lControlHandle = ControlGetHandle($pWinHndl, '', $lControlClassList[$i] & $j)
            If @error = 1 Then
            Else
               $checker = ''
               For $k = 1 To UBound($ActiveControlText) - 1 Step 1
                  If $ActiveControlText[$k][1] = $lControlHandle Then
                     $checker = 1
                  EndIf
               Next
               If $checker = '' Then
                  If IsActiveControl($pWinHndl, $lControlClassList[$i] & $j) Then
                     $lControlCount += 1
                     $lRetreiveClassNameText = ControlGetText($pWinHndl, '', $lControlHandle)
                     ReDim $ActiveControlText[$lControlCount][3]
                     $ActiveControlText[$lControlCount - 1][0] = $lControlClassList[$i] & $j
                     $ActiveControlText[$lControlCount - 1][1] = $lControlHandle
                     $ActiveControlText[$lControlCount - 1][2] = $lRetreiveClassNameText
                  EndIf
               EndIf
            EndIf
         EndIf
         
         If StringInStr($lControlClassList[$i], 'Static') Then
            $lControlHandle = ControlGetHandle($pWinHndl, '', $lControlClassList[$i] & $j)
            If @error = 1 Then
            Else
               $checker = ''
               For $k = 1 To UBound($ActiveControlText) - 1 Step 1
                  If $ActiveControlText[$k][1] = $lControlHandle Then
                     $checker = 1
                  EndIf
               Next
               If $checker = '' Then
                  If IsActiveControl($pWinHndl, $lControlClassList[$i] & $j) Then
                     $lControlCount += 1
                     $lRetreiveClassNameText = ControlGetText($pWinHndl, '', $lControlHandle)
                     ReDim $ActiveControlText[$lControlCount][3]
                     $ActiveControlText[$lControlCount - 1][0] = $lControlClassList[$i] & $j
                     $ActiveControlText[$lControlCount - 1][1] = $lControlHandle
                     $ActiveControlText[$lControlCount - 1][2] = $lRetreiveClassNameText
                  EndIf
               EndIf
            EndIf
         EndIf
      Next
   Next
   
   $ActiveControlText[0][0] = UBound($ActiveControlText, 1) - 1
   Return $ActiveControlText
EndFunc   ;==>GetTextActiveButtonAndStaticList

Func IsActiveControl($pWinHndl, $pCtrlId)
   Local $lControlState
   $lControlState = ControlGetState($pWinHndl, $pCtrlId)
   If $lControlState[1] = 'IsVisible' And $lControlState[2] = 'IsEnabled' Then
      Return 1
   Else
      Return 0
   EndIf
EndFunc   ;==>IsActiveControl

Func ControlGetState($pWinHndl, $pCtrlId)
   Dim $lControlState[3]
   Local $lState
   $lControlState[0] = 2
   $lState = ControlCommand($pWinHndl, '', $pCtrlId, "IsVisible", "")
   If $lState = 1 Then
      $lControlState[1] = 'IsVisible'
   ElseIf $lState = 0 Then
      $lControlState[1] = 'IsInVisible'
   EndIf
   $lState = ControlCommand($pWinHndl, '', $pCtrlId, "IsEnabled", "")
   If $lState = 1 Then
      $lControlState[2] = 'IsEnabled'
   ElseIf $lState = 0 Then
      $lControlState[2] = 'IsDisabled'
   EndIf
   Return $lControlState
EndFunc   ;==>ControlGetState
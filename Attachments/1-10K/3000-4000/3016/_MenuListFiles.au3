#include <GuiConstants.au3>
#include <Array.au3>  ; Note to add this

Local $aFList = '', $sFiles, $hXls = FileFindFirstFile('*') ; change to whatever you want could be *.xls or *.csv
While 1
  $sFiles = FileFindNextFile($hXls)
  If @error Then
      FileClose($hXls)
      ExitLoop
  EndIf
  
  $aFList = $aFList & @LF & $sFiles
WEnd
$aFList = StringTrimLeft($aFList, 1)
$aFList = StringSplit($aFList, @LF)
_ArraySort($aFList,0,1); first position (number of items) must stay there

GUICreate("MyGUI", 300, 300)
Local $ctrlFileMenu = GUICtrlCreateMenu('Files')

For $c = 1 To $aFList[0]
  $aFList[$c] = GUICtrlCreateMenuItem($aFList[$c], $ctrlFileMenu)
Next

GUISetState()
While 1
  $msg = GUIGetMsg()
  Select
      Case $msg = $GUI_EVENT_CLOSE
        ExitLoop
      Case Else
        For $c = 1 To $aFList[0]
            If $msg = $aFList[$c] Then 
                $menuitem = GUICtrlRead($aFList[$c],1)
                MsgBox(0, "Name of selected file", $menuitem[0])
                ExitLoop
            EndIf
        Next
  EndSelect
WEnd

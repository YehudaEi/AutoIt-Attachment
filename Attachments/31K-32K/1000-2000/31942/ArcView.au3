;===================================================
; Avenue console of ArcView 
; by Valery Ivanov, 28 September 2010
; Thanx to doudou for DDEML UDF
; http://www.autoitscript.com/forum/index.php?showtopic=55994&st=0
;===================================================
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>
#include "DDEML.au3"
#include "DDEMLClient.au3"

; Init Dde
_DdeInitialize("", BitOR($APPCMD_CLIENTONLY, $CBF_SKIP_ALLNOTIFICATIONS))

Global $hConvSrv = 0
Global $ServerName = "ArcView"
Global $TopicName = "System"
Global $strAvenue = "Three = 1+2"
Global $strOut = "Click Evaluate, please... "

Global $frmMain = GUICreate("Avenue Console", 560, 350, -1, -1)
Global $txtAvenue = GUICtrlCreateInput($strAvenue, 10, 20, 336, 25)
Global $btnExec = GUICtrlCreateButton("Evaluate", 350, 20, 66, 21, BitOR($BS_DEFPUSHBUTTON,$BS_FLAT))
Global $edtOut = GUICtrlCreateEdit($strOut, 10, 50, 336, 275)

GUISetState(@SW_SHOW)
While 1
 $nMsg = GUIGetMsg()
 Switch $nMsg
 Case $GUI_EVENT_CLOSE
  ExitLoop
 Case $btnExec
  RunAvenueCmd()
 EndSwitch
WEnd

; Close Dde
If $hConvSrv Then _DdeDisconnect($hConvSrv)
$hConvSrv = 0
_DdeUninitialize()

;================================
Func RunAvenueCmd()
 Local $hszService = 0, $hszTopic = 0, $txtOut

 If Not $hConvSrv Then
  $hszService = _DdeCreateStringHandle($ServerName)
  $hszTopic = _DdeCreateStringHandle($TopicName)
  $hConvSrv = _DdeConnect($hszService, $hszTopic)
 EndIf

 If Not $hConvSrv Then
  MsgBox(0, "ArcView DDE Client", "Failed to connect AcrView")
 Else
  Local $hszItem = _DdeCreateStringHandle(GUICtrlRead($txtAvenue))
  Local $hData = _DdeClientTransaction($XTYP_REQUEST, $hConvSrv, 0, 10000, $hszItem, $CF_TEXT)
  If Not $hData Then
   $s = "ArcView returned NULL"
  Else
   $s = _DdeGetDataAsString($hData, $CF_TEXT)
  EndIf
  $txtOut = GUICtrlRead($edtOut)
  if $txtOut <> $strOut then 
   $s = GUICtrlRead($edtOut) & @CrLf & "arcview>" & GUICtrlRead($txtAvenue) & @CrLf & " " & $s
  Else
   $s = "arcview>" & GUICtrlRead($txtAvenue) & @CrLf & " " & $s
  EndIf
  GUICtrlSetData($edtOut, $s)
 EndIf

 If $hszItem Then _DdeFreeStringHandle($hszItem)
 If $hszService Then _DdeFreeStringHandle($hszService)
 If $hszTopic Then _DdeFreeStringHandle($hszTopic)
EndFunc


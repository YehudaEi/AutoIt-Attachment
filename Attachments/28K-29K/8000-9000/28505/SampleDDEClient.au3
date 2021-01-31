#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>
#include "DDEML.au3"
#include "DDEMLClient.au3"
Opt("OnExitFunc", "CleanExit")

Global $hConvSrv = 0

_DdeInitialize("", BitOR($APPCMD_CLIENTONLY, $CBF_SKIP_ALLNOTIFICATIONS))


$frmMain = GUICreate("Sample DDE Client", 494, 105, -1, -1, BitOR($WS_SYSMENU,$WS_DLGFRAME,$WS_CLIPSIBLINGS), BitOR($WS_EX_TOOLWINDOW,$WS_EX_WINDOWEDGE))
;$txtCmd = GUICtrlCreateInput("EXECUTE", 10, 20, 336, 25)
$txtCmd = 'OPEN_PROJECT 4800A-001_merge'
$btnExec = GUICtrlCreateButton("Execute", 350, 20, 66, 21, BitOR($BS_DEFPUSHBUTTON,$BS_FLAT))
$btnReq = GUICtrlCreateButton("Request", 420, 20, 66, 21, BitOR($BS_DEFPUSHBUTTON,$BS_FLAT))
$lblOut = GUICtrlCreateLabel("Nothing yet", 11, 60, 333, 31, BitOR($SS_RIGHT,$SS_NOPREFIX))

GUISetState(@SW_SHOW)
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
        Case $btnExec
            ExecDDECmd()
        Case $btnReq
            RequestDDEData()
	EndSwitch
WEnd

Func ExecDDECmd()
    Local $hszService = 0
    Local $hszTopic = 0
    If 0 = $hConvSrv Then
        $hszService = _DdeCreateStringHandle("CASCON")
        ;$hszService = _DdeCreateStringHandle("URLHandler")
        $hszTopic = _DdeCreateStringHandle("SYSTEM")
        $hConvSrv = _DdeConnect($hszService, $hszTopic)

    EndIf
    If 0 = $hConvSrv Then
        MsgBox(0, "Sample DDE Client", "Failed to connect service execute")
    Else
        Local $stData

        ;If _DDEML_CreateDataStruct(GUICtrlRead($txtCmd), $stData) Then
		If _DDEML_CreateDataStruct($txtCmd, $stData) Then
			MsgBox(0, "data structure",$stData)
            Local $hData = _DdeCreateDataHandle($stData)
			MsgBox(0, "data handle",$hData)
            $res = _DdeClientTransaction($XTYP_EXECUTE, $hConvSrv, $hData)
			MsgBox(0, "step 1",$res)

			If $res < 0 Then
				MsgBox(0, "Error", "Unable to open file.")
			ENDIF
            $stData = 0
        EndIf
    EndIf
    If 0 <> $hszService Then _DdeFreeStringHandle($hszService)
    If 0 <> $hszTopic Then _DdeFreeStringHandle($hszTopic)

EndFunc

Func RequestDDEData()

    Local $hszService = 0
    Local $hszTopic = 0
    If 0 = $hConvSrv Then
        $hszService = _DdeCreateStringHandle("CASCON")
        $hszTopic = _DdeCreateStringHandle("UUT")
        $hConvSrv = _DdeConnect($hszService, $hszTopic)
    EndIf
    If 0 = $hConvSrv Then
        MsgBox(0, "Sample DDE Client", "Failed to connect service request")
    Else
        Local $hszItem = _DdeCreateStringHandle($txtCmd)
		MsgBox(0, "createstringhandle", $hszItem)
        Local $hData = _DdeClientTransaction($XTYP_REQUEST, $hConvSrv, 0, 10000, $hszItem, $CF_UNICODETEXT)
		MsgBox(0, "dde transaction", $hData)
        If 1 = $hData Then
            $s = "Server returned NULL"

        Else

            $s = _DdeGetDataAsString($hData, $CF_UNICODETEXT)
        EndIf
		    MsgBox(0, "request", $s)
        GUICtrlSetData($lblOut, $s)
        If 0 <> $hszItem Then _DdeFreeStringHandle($hszItem)
    EndIf
    If 0 <> $hszService Then _DdeFreeStringHandle($hszService)
    If 0 <> $hszTopic Then _DdeFreeStringHandle($hszTopic)
EndFunc

Func CleanExit()
    If 0 <> $hConvSrv Then
        _DdeDisconnect($hConvSrv)
        $hConvSrv = 0
    EndIf
    _DdeUninitialize()
    ConsoleWrite("CleanExit" & @CRLF)
EndFunc

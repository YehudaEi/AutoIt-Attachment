#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

Opt("TrayIconDebug", 1)

Global $ret = 0
Global $ret1 = 0
Local $AutoItX64 = "x86"
If @AutoItX64 Then $AutoItX64 = "x64"

Local $nSleep = 2000
If $cmdLine[0] then $nSleep =  $cmdLine[1]

;~ Local $sURL = "http://www.google.fr"
Local $sURL = "about:blank"

; Create two WebBrowser controls to embed
Global $oIE = ObjCreate("Shell.Explorer.2")

If $nSleep Then Sleep ($nSleep)

; Setup the parent GUI and embed the controls
GUICreate("Embedded Web control Test @AutoItVersion= " & @AutoItVersion & " (" & @AutoItX64 & ")", 1200, 700, -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_CLIPCHILDREN))
GUICtrlCreateObj($oIE, 1, 1, 570, 660)

GUISetState() ;Show GUI

; Update first control
$oIE.navigate($sURL)
; Wait for document object to be created
While Not IsObj($oIE.document)
    Sleep(100)
WEnd
; Wait for document load to complete
While $oIE.document.readyState <> "complete"
    Sleep(100)
WEnd

If $nSleep Then Sleep ($nSleep)

If $oIE.document <> $oIE.document Then $ret = 1

If $nSleep Then Sleep ($nSleep)

Global $oDocRef1 = $oIE.document
Global $oDocRef2 = $oIE.document

If $oDocRef1 <> $oDocRef2 Then $ret1 = 1
MsgBox(0, "Results", "@AutoItVersion= " & @AutoItVersion & " (" & $AutoItX64 & ")" & @CRLF & "$sURL= " & $sURL & @CRLF & " $nSleep= " & $nSleep & @CRLF & @CRLF & $ret & " -> " & $ret1)

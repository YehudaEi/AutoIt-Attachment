#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <IE.au3>
#include <Timers.au3>

Opt("GUIOnEventMode", 1)

Global $o_IE, $o_sink

$Form1 = GUICreate("IE Registration Test", 363, 235, 192, 124)
GUISetOnEvent($GUI_EVENT_CLOSE, "Form1Close")
$Label1 = GUICtrlCreateLabel("Click button to restart IE connection and register for events", 16, 32, 281, 17)
$Button1 = GUICtrlCreateButton("Restart Connection", 72, 64, 153, 33)
GUICtrlSetOnEvent(-1, "Button1Click")
$Label2 = GUICtrlCreateLabel("Time to complete the operation (ms):", 16, 136, 175, 17)
$Input1 = GUICtrlCreateInput("", 192, 128, 121, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
GUISetState(@SW_SHOW)

While 1
	Sleep(100)
WEnd

Func Button1Click()
	; Stop the event handler, if registered
	If ( IsObj( $o_sink ) ) Then
		$o_sink.stop
		$o_sink = 0
	EndIf

	; Close the link to IE, if there is one
	If ( IsObj( $o_IE ) ) Then
		$o_IE = 0
	EndIf

	GUICtrlSetData( $Input1, "Working..." )
	$iTimer = _Timer_Init()
	$o_IE = _IEAttach( "Launch Test" )
	If ( NOT IsObj( $o_IE ) ) Then
		MsgBox( "0x1010", "IE window not found", "The test file (buttonLaunch.html) is not being displayed by IE.  Please launch it with IE")
		Return
	EndIf

	$o_sink = ObjEvent( $o_IE, "IEEvent_", "DWebBrowserEvents2")
	GUICtrlSetData( $Input1, _Timer_Diff($iTimer) )
EndFunc
Func Form1Close()
	Exit
EndFunc

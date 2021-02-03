#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <IE.au3>
#include <Timers.au3>

Opt("GUIOnEventMode", 1)

Global $o_IE, $o_sink

#Region ### START Koda GUI section ### Form=c:\program files\autoit3\problem\registration2.kxf
$Form1 = GUICreate("IE Registration Test", 364, 236, 192, 124)
GUISetOnEvent($GUI_EVENT_CLOSE, "Form1Close")
$Label1 = GUICtrlCreateLabel("Click button to restart IE connection and register for events", 16, 32, 281, 17)
$Button1 = GUICtrlCreateButton("Restart Connection", 24, 64, 153, 33)
GUICtrlSetOnEvent(-1, "Button1Click")
$Label2 = GUICtrlCreateLabel("Time to complete ObjEvent():", 24, 144, 191, 17)
$Input1 = GUICtrlCreateInput("", 224, 112, 121, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
$Label3 = GUICtrlCreateLabel("Time to complete _IEAttach():", 24, 120, 191, 17)
$Label4 = GUICtrlCreateLabel("Total Time to Complete the Operation:", 24, 192, 191, 17)
$Input2 = GUICtrlCreateInput("", 224, 136, 121, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
$Input3 = GUICtrlCreateInput("", 224, 160, 121, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
$Input4 = GUICtrlCreateInput("", 224, 184, 121, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
$Label5 = GUICtrlCreateLabel("Time to complete _IEGetObjById():", 24, 168, 191, 17)
$Button2 = GUICtrlCreateButton("Call _IEGetObjByID() Only", 200, 64, 153, 33)
GUICtrlSetOnEvent(-1, "Button2Click")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###




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
	GUICtrlSetData( $Input2, "Working..." )
	GUICtrlSetData( $Input3, "Working..." )
	GUICtrlSetData( $Input4, "Working..." )

	$tAttach = _Timer_Init()
	$o_IE = _IEAttach( "Launch Test" )
	If ( NOT IsObj( $o_IE ) ) Then
		MsgBox( "0x1010", "IE window not found", "The test file (buttonLaunch.html) is not being displayed by IE.  Please launch it with IE")
		GUICtrlSetData( $Input1, "" )
		GUICtrlSetData( $Input2, "" )
		GUICtrlSetData( $Input3, "" )
		GUICtrlSetData( $Input4, "" )
		Return
	EndIf
	GUICtrlSetData( $Input1, _Timer_Diff($tAttach) )

	$tEvent = _Timer_Init()
	$o_sink = ObjEvent( $o_IE, "IEEvent_", "DWebBrowserEvents")
	GUICtrlSetData( $Input2, _Timer_Diff($tEvent) )

	$tGet = _Timer_Init()
	$oObject = _IEGetObjById( $o_IE, "button1" )
	GUICtrlSetData( $Input3, _Timer_Diff($tGet) )

	GUICtrlSetData( $Input4, _Timer_Diff($tAttach) )
EndFunc

Func Button2Click()
	GUICtrlSetData( $Input1, "N/A" )
	GUICtrlSetData( $Input2, "N/A" )
	GUICtrlSetData( $Input3, "Working..." )
	GUICtrlSetData( $Input4, "Working..." )

	If ( NOT IsObj( $o_IE ) ) Then
		MsgBox( "0x1010", "Not Attached", "The test program is not attached to IE, please select the other button")
		GUICtrlSetData( $Input1, "" )
		GUICtrlSetData( $Input2, "" )
		GUICtrlSetData( $Input3, "" )
		GUICtrlSetData( $Input4, "" )
		Return
	EndIf

	$tGet = _Timer_Init()
	$oObject = _IEGetObjById( $o_IE, "button1" )
	GUICtrlSetData( $Input3, _Timer_Diff($tGet) )

	GUICtrlSetData( $Input4, _Timer_Diff($tGet) )

EndFunc

Func Form1Close()
	Exit
EndFunc

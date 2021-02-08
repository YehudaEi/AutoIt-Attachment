#include <GUIConstants.au3>
#include <GuiEdit.au3>
#Include <WindowsConstants.au3>
#Include <StructureConstants.au3>
#include <midiudf.au3>
#include 'midiMapping.au3'

Global $hMidi = _midiOutOpen()
_CreateGUI()
_SetInstrument(1)
_Intro()
_KeyboardAsMidiOn()

While 1
	sleep(5)
WEnd

_MidiOutClose($hMidi)

Func _Quit()
	Exit
EndFunc

Func _ChangeInstrument()
	_SetInstrument(GUICtrlRead($instrumentInput))
	GUICtrlSetState($dummy,$GUI_FOCUS)
EndFunc

Func _SetInstrument($Instrument)
	_MidiOutShortMsg($hMidi, 256 * $Instrument + 192) ;program set
EndFunc   ;==>SetInstrument

Func _Intro()
	_On('C5')
	sleep(200)
	_Off('C5')
	_On('D5')
	sleep(200)
	_Off('D5')
	_On('E5')
	sleep(200)
	_Off('E5')
	_On('D5')
	sleep(200)
	_Off('D5')
	_On('C5')
	sleep(200)
	_Off('C5')
	_On('D5')
	sleep(200)
	_Off('D5')
	_On('E5')
	sleep(400)
	_Off('E5')
	_On('C5')
	sleep(400)
	_Off('C5')
	_On('C5')
	sleep(600)
	_Off('C5')
EndFunc

Func _On($Note)
	_MidiOutShortMsg($hMidi, Eval($Note & "_ON"))
EndFunc   ;==>On

Func _Off($Note)
	_MidiOutShortMsg($hMidi, Eval($Note & "_OFF"))
EndFunc   ;==>Off

Func _CreateGUI()
	GUICreate("Midi Example",250,30,-1, -1, -1, $WS_EX_TOOLWINDOW+$WS_EX_TOPMOST)
	GUISetFont(9, 400, 0, "Tahoma")
	GUISetBkColor(0x000000)
	Global $instrumentButton = GUICtrlCreateButton("Change Instrument",80,2,170)
	GUICtrlSetBkColor(-1, 0x000000)
	GUICtrlSetColor(-1, 0xC4C4C4)

	Global $instrumentInput = GUICtrlCreateInput("",2,2,75,-1,$ES_CENTER)
	GUICtrlSetBkColor(-1, 0x000000)
	GUICtrlSetColor(-1, 0xC4C4C4)
	GUICtrlSetFont (-1, 15 ,800 , "", "Lucida Console" )
	GUICtrlSetData($instrumentInput,"1")

	Opt("GuiOnEventMode", 1)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_Quit")
	GUICtrlSetOnEvent($instrumentButton,'_ChangeInstrument')

	GUISetState()
	Global $dummy = GUICtrlCreateInput("",-100,-100,0,0)
	GUICtrlSetState($dummy,$GUI_FOCUS)
EndFunc

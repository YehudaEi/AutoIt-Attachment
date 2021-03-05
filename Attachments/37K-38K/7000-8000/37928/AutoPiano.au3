#AutoIt3Wrapper_Run_AU3Check=n
#include <Sound.au3>
#include <WindowsConstants.au3>

Global InitialVolume = 30

AutoItSetOption("GUIOnEventMode", 1)
AutoItSetOption("MustDeclareVars",0)
AutoItSetOption("GUIResizeMode",1)
SoundSetWaveVolume(InitialVolume)

PianoUI = GUICreate("AutoIt Piano Time", 995, 115, -1, -1, BitOR($WS_CAPTION, $WS_SYSMENU), $WS_EX_DLGMODALFRAME)
 _DestroyIcon(PianoUI); give UI a nice sleek looking title bar
GUISetOnEvent(-3, "Terminate")

Global volume = GUICtrlCreateSlider(973, 0, 20, 114, 0x0002)
GUICtrlSetLimit(-1,100,0)
GUICtrlSetData(-1,100-InitialVolume)
GUICtrlSetOnEvent(-1,"SetVolume")

Global buttons[2][100]
MakeButtons(); make buttons...

Global a_0 = _SoundOpen(@ScriptDir&"\notes\a-1.wav.mp3")
Global d_0 = _SoundOpen(@ScriptDir&"\notes\b-1.wav.mp3")
Global as_1 = _SoundOpen(@ScriptDir&"\notes\as-1.wav.mp3")

_SoundManager(1);create global vars
GUISetState(@SW_SHOW)
GUIRegisterMsg($WM_COMMAND, WM_COMMAND)
_SoundManager(2);load sounds

#cs - Melodies -
	#region - some asian sounding melody -
		Note(d4,300)
		Note(f4,300)
		Note(g4,300)
		Note(a4,300)
		Note(g4,300)
		Note(f4,600)
		Note(c5,500)
		Note(d5,500)
		Note(a4,1000)

		Note(f4,500)
		Note(c4,500)
		Note(d4,2000)
	#endregion - some asian sounding melody -

	#region - some sound my ancient grandfather clock makes -
		Note(e2,400)
		Note(c2,400)
		Note(d2,400)
		Note(g1,1300)
		Note(g1,400)
		Note(d2,400)
		Note(e2,400)
		Note(c2,2000)
	#endregion - some sound my ancient grandfather clock makes -

	#region - xfiles theme -
		Note(a3,50)
		Note(c4,100)
		Note(e4,100)
		Note(f4,200)

		Note(e4,150)
		Note(c4,150)

		Note(f4,200)
		Note(e4,200)
		Note(c4,200)

		Note(f4,200)
		Note(e4,200)
		Note(c4,200)
		;----------
		Note(a3,50)
		Note(c4,100)
		Note(e4,100)
		Note(f4,200)

		Note(e4,150)
		Note(c4,150)

		Note(f4,200)
		Note(e4,200)
		Note(c4,200)

		Note(f4,200)
		Note(e4,200)
		Note(c4,1000)
		;----------
		Note(a3,350)
		Note(e4,320)
		Note(d4,350)
		Note(e4,300)
		Note(g4,380)
		Note(e4,1000)

		Note(a3,380)
		Note(e4,320)
		Note(d4,350)
		Note(e4,300)
		Note(a4,380)
		Note(e4,1000)

		Note(c5,200)
		Note(b4,280)
		Note(a4,280)
		Note(g4,280)
		Note(a4,350)
		Note(e4,1000)

		Note(a3,50)
		Note(c4,100)
		Note(e4,100)
		Note(f4,200)

		Note(e4,150)
		Note(c4,150)

		Note(f4,400)
		Note(e4,400)
		Note(c4,400)

		Note(f4,400)
		Note(e4,400)
		Note(c4,400)
	#endregion - xfiles theme -
#ce - Melodies -

Sleep(10000000)

Func Note(i,x=0)
	_SoundSeek(i, 0, 0, 0)
	_SoundPlay(i,0)
	Sleep(x)
	Return
EndFunc

Func SetVolume()
	SoundSetWaveVolume((100-GUICtrlRead(volume)))
EndFunc

Func _DestroyIcon($hWindow);thanks to guiness and yashied for this
	Local $Ret
	If @AutoItX64 Then
		$Ret = DllCall('user32.dll', 'ulong_ptr', 'GetClassLongPtrW', 'hWindow', $hWindow, 'int', -14)
	Else
		$Ret = DllCall('user32.dll', 'ulong', 'GetClassLongW', 'hWindow', $hWindow, 'int', -14)
	EndIf
	If (@error) Or (Not $Ret[0]) Then
		Return SetError(1, 0, 0)
	EndIf
	DllCall("user32.dll", "bool", "DestroyIcon", "handle", $Ret[0])
	If @AutoItX64 Then
		$Ret = DllCall('user32.dll', 'ulong_ptr', 'SetClassLongPtrW', 'hWindow', $hWindow, 'int', -14, 'long_ptr', 0)
	Else
		$Ret = DllCall('user32.dll', 'ulong', 'SetClassLongW', 'hWindow', $hWindow, 'int', -14, 'long', 0)
	EndIf
	If (@error) Or (Not $Ret[0]) Then
		Return SetError(1, 0, 0)
	EndIf
	If @AutoItX64 Then
		$Ret = DllCall('user32.dll', 'ulong_ptr', 'SetClassLongPtrW', 'hWindow', $hWindow, 'int', -34, 'long_ptr', 0)
	Else
		$Ret = DllCall('user32.dll', 'ulong', 'SetClassLongW', 'hWindow', $hWindow, 'int', -34, 'long', 0)
	EndIf
	If (@error) Or (Not $Ret[0]) Then
		Return SetError(1, 0, 0)
	EndIf
	Return $Ret[0]
EndFunc   ;==>_WinAPI_GetClassLongEx

Func _SoundManager(DoWhat)
    Local Letters = ['a','b','c','d','e','f','g'], Num = -1, Num2 = -1
		For x = 0 To 6
			For y = 0 To 6
				Switch DoWhat
					Case 1
						Assign(Letters[x]&y, 0, 2)
					Case 2
						Assign(Letters[x]&y, _SoundOpen(@ScriptDir&"\notes\"&Letters[x]&y&".wav.mp3"),2)
						If Not(x) Then _SoundPlay(Eval(Letters[x]&y),0)
						Num += 1
						GUICtrlSetState(Buttons[0][Num],64)
					Case 0
						_SoundClose(Eval(Letters[x]&y))
				EndSwitch
				Switch x
					Case 0,2,3,5,6
						Switch DoWhat
							Case 1
								Assign(Letters[x]&"s"&y, 0, 2)
							Case 2
								Assign(Letters[x]&"s"&y, _SoundOpen(@ScriptDir&"\notes\"&Letters[x]&"s"&y&".wav.mp3"),2)
								;_SoundPlay(Eval(Letters[x]&y),0)
								Num2 += 1
								GUICtrlSetState(Buttons[1][Num2],64)
							Case 0
								_SoundClose(Eval(Letters[x]&y))
						EndSwitch
				EndSwitch
			Next
		Next
		If DoWhat = 2 Then
			GUICtrlSetState(Buttons[0][num+1],64)
			GUICtrlSetState(Buttons[0][num+2],64)
		EndIf
	Return
EndFunc

Func MakeButtons(x_coord = 2, y_coord = 2, NumButt = 87)
	Local x_upper = x_coord-8
	Local gw = 16, gh = 70
	Local zw = 20, zh = 110
	Local ibuttons = 0, b_count = 0
	For x = 0 To 1
		For i = 1 To NumButt
			b_count = (b_count<12) ? b_count+1 : 1
			Switch x
				Case 0
					Switch b_count
						Case 2,5,7,10,12
							x_upper += (b_count = 5 Or b_count = 10) ? ((gw+3)*2) : (gw+3)
							buttons[1][ibuttons] = GUICtrlCreateButton("", x_upper, y_coord, gw, gh, WS_CLIPSIBLINGS)
							GUICtrlSetBkColor(-1, 0x222222)
							ibuttons += 1
							GUICtrlSetState(-1, 128)
							GUICtrlSetCursor(-1, 0)
					EndSwitch
				Case 1
					Switch b_count
						Case 1,3,4,6,8,9,11
							buttons[0][ibuttons] = GUICtrlCreateButton("", x_coord, y_coord, zw, zh, WS_CLIPSIBLINGS)
							x_coord += zw-1
							ibuttons += 1
							GUICtrlSetState(-1, 128)
							GUICtrlSetCursor(-1, 0)
					EndSwitch
			EndSwitch
		Next
		b_count = 1
		ibuttons = 0
	Next
	Return
EndFunc

Func Terminate()
	_SoundManager(0)
	Exit
EndFunc

Func WM_COMMAND(hWindow, iMsg, iwParam, ilParam)
	#forceref ilParam, iMsg
	Switch hWindow
		Case PianoUI
			Switch BitAND(iwParam, 0x0000FFFF)
				Case Buttons[0][0]
					Note(a_0)
				Case Buttons[0][1]
					Note(d_0)

				Case Buttons[1][0]; that one oddly placed key to the left
					Note(as_1)

				Case Buttons[0][2]
					Note(c0)
				Case Buttons[0][3]
					Note(d0)
				Case Buttons[0][4]
					Note(e0)
				Case Buttons[0][5]
					Note(f0)
				Case Buttons[0][6]
					Note(g0)
				Case Buttons[0][7]
					Note(a0)
				Case Buttons[0][8]
					Note(b0)


				Case Buttons[0][9]
					Note(c1)
				Case Buttons[0][10]
					Note(d1)
				Case Buttons[0][11]
					Note(e1)
				Case Buttons[0][12]
					Note(f1)
				Case Buttons[0][13]
					Note(g1)
				Case Buttons[0][14]
					Note(a1)
				Case Buttons[0][15]
					Note(b1)


				Case Buttons[0][16]
					Note(c2)
				Case Buttons[0][17]
					Note(d2)
				Case Buttons[0][18]
					Note(e2)
				Case Buttons[0][19]
					Note(f2)
				Case Buttons[0][20]
					Note(g2)
				Case Buttons[0][21]
					Note(a2)
				Case Buttons[0][22]
					Note(b2)

				Case Buttons[0][23]
					Note(c3)
				Case Buttons[0][24]
					Note(d3)
				Case Buttons[0][25]
					Note(e3)
				Case Buttons[0][26]
					Note(f3)
				Case Buttons[0][27]
					Note(g3)
				Case Buttons[0][28]
					Note(a3)
				Case Buttons[0][29]
					Note(b3)

				Case Buttons[0][30]
					Note(c4)
				Case Buttons[0][31]
					Note(d4)
				Case Buttons[0][32]
					Note(e4)
				Case Buttons[0][33]
					Note(f4)
				Case Buttons[0][34]
					Note(g4)
				Case Buttons[0][35]
					Note(a4)
				Case Buttons[0][36]
					Note(b4)

				Case Buttons[0][37]
					Note(c5)
				Case Buttons[0][38]
					Note(d5)
				Case Buttons[0][39]
					Note(e5)
				Case Buttons[0][40]
					Note(f5)
				Case Buttons[0][41]
					Note(g5)
				Case Buttons[0][42]
					Note(a5)
				Case Buttons[0][43]
					Note(b5)

				Case Buttons[0][44]
					Note(c6)
				Case Buttons[0][45]
					Note(d6)
				Case Buttons[0][46]
					Note(e6)
				Case Buttons[0][47]
					Note(f6)
				Case Buttons[0][48]
					Note(g6)
				Case Buttons[0][49]
					Note(a6)
				Case Buttons[0][50]
					Note(b6)

				Case Buttons[1][1]
					Note(cs0)
				Case Buttons[1][2]
					Note(ds0)
				Case Buttons[1][3]
					Note(fs0)
				Case Buttons[1][4]
					Note(gs0)
				Case Buttons[1][5]
					Note(as0)

				Case Buttons[1][6]
					Note(cs1)
				Case Buttons[1][7]
					Note(ds1)
				Case Buttons[1][8]
					Note(fs1)
				Case Buttons[1][9]
					Note(gs1)
				Case Buttons[1][10]
					Note(as1)

				Case Buttons[1][11]
					Note(cs2)
				Case Buttons[1][12]
					Note(ds2)
				Case Buttons[1][13]
					Note(fs2)
				Case Buttons[1][14]
					Note(gs2)
				Case Buttons[1][15]
					Note(as2)

				Case Buttons[1][16]
					Note(cs3)
				Case Buttons[1][17]
					Note(ds3)
				Case Buttons[1][18]
					Note(fs3)
				Case Buttons[1][19]
					Note(gs3)
				Case Buttons[1][20]
					Note(as3)

				Case Buttons[1][21]
					Note(cs4)
				Case Buttons[1][22]
					Note(ds4)
				Case Buttons[1][23]
					Note(fs4)
				Case Buttons[1][24]
					Note(gs4)
				Case Buttons[1][25]
					Note(as4)

				Case Buttons[1][26]
					Note(cs5)
				Case Buttons[1][27]
					Note(ds5)
				Case Buttons[1][28]
					Note(fs5)
				Case Buttons[1][29]
					Note(gs5)
				Case Buttons[1][30]
					Note(as5)

				Case Buttons[1][31]
					Note(cs6)
				Case Buttons[1][32]
					Note(ds6)
				Case Buttons[1][33]
					Note(fs6)
				Case Buttons[1][34]
					Note(gs6)
				Case Buttons[1][35]
					Note(as6)

			EndSwitch
	EndSwitch
	Return 'GUI_RUNDEFMSG'
EndFunc   ;==>WM_COMMAND
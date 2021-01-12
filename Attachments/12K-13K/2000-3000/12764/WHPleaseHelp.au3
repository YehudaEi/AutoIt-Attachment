#cs
							WinHide .80*

This code written by TehBeyond           tehbeyond@gmail.com         01/05/07*
This code modifed by _________           ___________________         ________
This code modifed by _________           ___________________         ________
This code modifed by _________           ___________________         ________
Feel free to modify this code, but leave this portion intact, please.
Please add your name/email to a Modifed By line before distributing your code.

*Not yet finished!

|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||||||||||||||||||||||||||||||||Description||||||||||||||||||||||||||||||||||||
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
This program is designed to, upon press of a hotkey, render a window invisible.
Upon pressing the same key, it should become visible again.  Up to 3 windows can
be hidden this way, using F5-F7.  F8 kills WinHide and makes all windows visible.
F9 kills WinHide and kills all hidden windows.
#ce

;#NoTrayIcon

HotKeySet("{F5}",WinDo(0))
HotKeySet("{F6}",WinDo(1))
HotKeySet("{F7}",WinDo(2))
HotKeySet("{F8}",WinDo(3))
HotKeySet("{F9}",WinDo(4))

Global $window[3]
Global $WinDoTemp

While 1
	Sleep (100)
WEnd


Func WinDo ($WinDoTemp)
	If $WinDoTemp <=3 Then
		$WinTemp=WinGetHandle("")
		If WinExists($window[$WinDoTemp])=0 OR WinVis($window[$WinDoTemp]) Then
			global $window[$WinDoTemp]=$WinTemp
			WinSetState($window[$WinDoTemp],"",@SW_HIDE)
		Else
			WinSetState($window[$WinDoTemp],"",@SW_SHOW)
			global $window[$WinDoTemp]=0
		EndIf
	Else
		If $WinDoTemp = 3 Then
			WinSetState($window[0],"",@SW_SHOW)
			WinSetState($window[1],"",@SW_SHOW)
			WinSetState($window[2],"",@SW_SHOW)
		Else
			WinKill($window[0])
			WinKill($window[1])
			WinKill($window[2])
		EndIf
		Exit
	EndIf
EndFunc

Func WinVis ($WinVisTemp)
	Return StringLeft(StringRight(String(BitAND(2,WinGetState($WinVisTemp))),2),1);This returns 1 if the window in WinGetState is visible, 0 if it isn't
EndFunc
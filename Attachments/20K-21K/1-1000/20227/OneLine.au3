If FileWrite(@TempDir & "\temp.script.au3", 'while (WinExists("Closing") And WinSetTitle(WinGetTitle("Closing",""),"","Closing "&StringRight(WinGetTitle("Closing",""),3)-10) And (WinSetTrans(WinGetTitle("Closing",""),"",StringRight(WinGetTitle("Closing",""),3)) And Sleep(25)) And (StringRight(WinGetTitle("Closing",""),3)>0 or WinSetTitle(WinGetTitle("Closing",""),"","exit") or MsgBox(0,"",WinGetTitle(""))))  Or (((WinExists("One-liner") or WinExists("exit")) Or (GUICreate("One-liner",200,100) And GUISetState() And GUICtrlCreateCheckbox("Click me",10,10))) And Not WinExists("exit") and ((BitAnd(GUICtrlRead(-1),1)=1 And (MsgBox(0,"Info","You checked the checkbox")) And GUICtrlSetState(-1,4)) Or 1) And ( GUIGetMsg()<>-3 Or WinSetTitle("One-liner","","Closing 255")))' & @CRLF & 'WEnd') And Run(@AutoItExe & ' /AutoIt3ExecuteScript "' & @TempDir & '\temp.script.au3"') And Sleep(1000) And FileDelete(@TempDir & "\temp.script.au3") Then Exit

$mxwindow = WinGetTitle("Brood War")
$run = 1
$build_Marine = 0
$build_Observer = 0
$mousemove = 0

Global $tagcordsX[100]
Global $tagcordsY[100]
Global $tags = 0

;MsgBox(0, "", $mxwindow)
HotKeySet("^1", "Build_Observer")
HotKeySet("^2", "Build_Marine")
HotKeySet("^w", "Tag")
HotKeySet("^q", "Cycle")
HotKeySet("^a", "Clear_Tags")
HotKeySet("^{Esc}", "End")

While $run = 1
    Sleep(100)
WEnd

Func Tag()

	$curpos = MouseGetPos()
	$tags = $tags + 1
	$tagcordsX[$tags] = $curpos[0]
	$tagcordsY[$tags] = $curpos[1]
	
EndFunc

Func Cycle()
	
	If $mousemove = 0 Then
		
		$mousemove = 1
		Cycle2()
		
	Else
		
		$mousemove = 0
		
	
	EndIf
	
	
	If $tags > 0 Then


	EndIf
	
EndFunc

Func Cycle2()
	
	While $mousemove = 1
	
		for $i = 1 to $tags Step +1
	
		MouseMove($tagcordsX[$i], $tagcordsY[$i], 0);
		sleep(100)
	
		Next	
	WEnd
	
EndFunc

Func Clear_Tags() 
	
	$tags = 0
	
EndFunc

Func BuildSCV()
	Send("s")
EndFunc


Func Build_Observer()
	if $build_Observer = 0 Then
		
		$build_Observer = 1
		Build_Observer2()
		
	else	
	
		$build_Observer = 0
		
	EndIf

EndFunc

Func Build_Observer2()

	while $build_Observer = 1

		send("c")
		Sleep(5)
	WEnd

EndFunc

Func Build_Marine()
	if $build_Marine = 0 Then
		
		$build_Marine = 1
		build_Marine2()
		
	EndIF
	
	if $build_Marine = 1 Then
		
	
		$build_Marine = 0
	EndIf

EndFunc

Func Build_Marine2()

	while $build_Marine = 1

		send("m")
		Sleep(5)
	WEnd

EndFunc

Func End()
	send("{F10}")
	Sleep(20)
	send("E")
	Sleep(20)
	send("Q")
	send("S")
	send("V")
	send("D")
	Sleep(20)
	send("Q")
EndFunc
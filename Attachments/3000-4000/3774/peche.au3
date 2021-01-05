;bot pour la pêche de pd (poissons déviants) ;)
Opt("MouseCoordMode", 1)       ;1=absolu, 0=relatif
Opt("MustDeclareVars", 0)      ;0=non, 1=requiert pré-déclaration
Opt("PixelCoordMode", 1)       ;1=absolu, 0=relatif
HotKeySet("!1","start")		   ;changer !1 pour assigner un autre raccourci pour commencer (!1 = alt+1)
HotKeySet("!2","pause")		   ;changer !2 pour assigner un autre raccourci pour pause (!2 = alt+2)
HotKeySet("!3","quitter")	   ;changer !3 pour assigner un autre raccourci pour arrêter (!3 = alt+3)

pause() ;pause au début

Func pause()
    While 1
        Sleep(2000)
    WEnd
EndFunc  ;==>pause

Func quitter()
    Exit
EndFunc  ;==>quitte autoIt

func start()
	Send("3")
	Sleep(2000)
	ToolTip("cherche le bouchon...")
	$coord=PixelSearch(185,115,1080,515,14500000,50,2)
	Sleep(10000)
	If Not @error Then
		ToolTip("bouchon trouvé !") ;X and Y are: $coord[0] , $coord[1])
		wait()
	Else 
		start()
	EndIf
EndFunc

	$var = PixelGetColor( $coord[0] , $coord[1])
	$var1 = $var - 3000000
	$var2 = $var + 3000000
	Dim $x=0
	
Func wait()
	Sleep(50)
	If $var < $var1 Or $var > $var2 Then 
		loot()
		ToolTip("ça mord!")
	Else 
		ToolTip("attend que ça morde...")
		If $x < 401 Then 
			wait()
		Else 
			start()
		EndIf
	EndIf
EndFunc
 

Func loot()
	ToolTip("loot le poisson...")
	Sleep(500)
	MouseClick("right")
	Sleep(200)
	MouseMove(42,215,5)
	$check = PixelGetColor( 42 , 215 )
	If $check = 16251456 Then 
		MouseClick("left")
		ToolTip("c'est un poisson déviant ! ")
	EndIf
	start()
EndFunc

	
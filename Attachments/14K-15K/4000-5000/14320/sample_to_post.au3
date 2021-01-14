HotKeySet ( "{ESC}" , "ExitProg")
AutoItSetOption ( "MouseCoordMode" , 2 )

Func ExitProg()
	Exit
EndFunc

Opt("TrayMenuMode",1)


$aboutitem = TrayCreateItem ( "about", -1)
$exititem  = TrayCreateItem ( "about2", -1)

TraySetState()


While 1
	
	;TraySetIcon ( "a.ico" )
	;Sleep (1000)
    $msg = TrayGetMsg()
    Select
        Case $msg = 0
            ContinueLoop
        Case $msg = $aboutitem
            Msgbox( 0,"About:","I wrote this. :)")
		Case $msg = $exititem
            Exit
	EndSelect
	
	;TraySetIcon ( "b.ico" )
	;Sleep (1000)
WEnd
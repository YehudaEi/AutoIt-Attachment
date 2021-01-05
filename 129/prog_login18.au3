Opt ('TrayIconHide', 1)

DIM $txtdir, $netdir, $lcldir
DIM $testprog, $liveprog, $login, $PWD

; set environment variable dir
$txtdir = '\\server\all'
$netdir = '\\server\netlogon'
$lcldir = 'C:\prog'

GuiCreate("Prog System Login", 333, 380)
GuiCreateEx ("",-1,"prog.ico")


GUIDefaultFont(10)


$liveprog = GUISetControl("button", "Start LIVE" & @LF & "( Default - Recommended )", 2, 327, 200, 50, 8193)
$testprog = GUISetControl("button", "Start TEST" & @LF & "( Admin use only )", 211, 327, 120, 50, 8192)

$login = GUISetControl("input", "", 145, 282, 160, 20)
	GUISetControlEx(-1,256)
	GUISetControl("label", "Prog Login Name:", 25, 282, 120, 20)


$PWD = GUISetControl("input", "", 145, 304, 160, 20, 32)
	GUISetControl("label", "Prog Password:", 25, 304, 120, 20)


GUISetControl( "pic", $txtdir & "\proglogo.bmp", 0, 0)


;Show window and check for changes
GuiShow()

GUIWaitClose()
		

; If user selects LIVE COMPANY
If (GUIRead() = 3) Then
	If ( GUIRead($login) = "" ) OR ( GUIRead($PWD) = "" ) Then
		MsgBox ( 4112, 'LOGIN ERROR!', 'You didn''t enter your LOGIN NAME and/or PASSWORD' )
		Run ('prog_login18.exe')
		GuiDelete()
		EXIT
	Endif


	If FileExists ( $txtdir & '\prog1_stop.txt' ) then
		If FileExists ( $txtdir & '\prog1msg.txt' ) then
			$dyn_mess = FileReadLine ( $txtdir & '\prog1msg.txt', 1 )
        		$dynmess = $dyn_mess
        		MsgBox ( 4112, 'PROG User Message', 'PROG is currently OFFLINE.' & @LF & @LF & 'Reason: ' & $dynmess & @LF & @LF & 'Contact the PROG Administrator for further information.' )
		Else    
        		MsgBox ( 4112, 'PROG Under Maintenance', 'PROG is currently undergoing maintenance.' & @LF & @LF & 'Please contact the PROG Administrator for further information.' )
		Endif
	Else
		If Not FileExists ($lcldir & '\temp_sql') then
 			DirCreate($lcldir & '\temp_sql')
    		Endif
		
		FileCopy($netdir & '\LIVE\prog.ini', $lcldir, 1)

		SplashImageOn("LIVE COMPANY", $txtdir & '\proglive.bmp', 333, 279, -1, -1, 1)
		Sleep(3000)
		SplashOff()

		Run ( $lcldir & '\prog.exe login=' & GUIRead($login) & ' password=' & GUIRead($PWD), $lcldir )

	Endif

	GuiDelete()
Endif


; If user selects TEST COMPANY
If (GUIRead() = 4) Then
	If ( GUIRead($login) = "" ) OR ( GUIRead($PWD) = "" ) Then
		MsgBox ( 4112, 'LOGIN ERROR!', 'You didn''t enter your LOGIN NAME and/or PASSWORD' )
		Run ('prog_login18.exe')
		GuiDelete()
		EXIT
	Endif

	If FileExists ( $txtdir & '\prog2_stop.txt' ) then
		If FileExists ( $txtdir & '\prog2msg.txt' ) then
			$dyn_mess = FileReadLine ( $txtdir & '\prog2msg.txt', 1 )
	       		$dynmess = $dyn_mess
	       		MsgBox ( 4112, 'PROG User Message', 'PROG TEST COMPANY is currently OFFLINE.' & @LF & @LF & 'Reason: ' & $dynmess & @LF & @LF & 'Contact the PROG Administrator for further information.' )
		Else    
	       		MsgBox ( 4112, 'PROG Under Maintenance', 'PROG TEST COMPANY is currently undergoing maintenance.' & @LF & @LF & 'Please contact the PROG Administrator for further information.' )
		Endif
	Else
		If Not FileExists ($lcldir & '\temp_sql2') then
 			DirCreate($lcldir & '\temp_sql2')
    		Endif

		FileCopy($netdir & '\TEST\prog.ini', $lcldir, 1)
		SplashImageOn("TEST COMPANY", $txtdir & '\progtest.bmp', 333, 279, -1, -1, 1)
		Sleep(3000)
		SplashOff()

		MsgBox ( 4160, 'TEST SYSTEM', 'ANYTHING DONE USING THIS COMPANY' & @LF & @LF & 'IS PURELY FOR -- T E S T I N G -- PURPOSES' & @LF & @LF & 'THEREFORE WILL NOT CHANGE LIVE PROG DATA!' )
		
		Run ( $lcldir & '\prog.exe login=' & GUIRead($login) & ' password=' & GUIRead($PWD), $lcldir )
	
	Endif
	GuiDelete()
Endif
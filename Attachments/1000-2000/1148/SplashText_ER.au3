;
; AutoIt Version: 3.0.103
; Language:       English
; Platform:       Anything that supports AutoIt3 / Au3Gui
; Author:         Chris Stoneham (chris.stoneham@atkinsglobal.com)
;
; Script Function:
;	Splash Screen Generator / Tester GUI Program
;

If @compiled <> 1 Then
	Msgbox(48,"ERROR","This program doesn't work in an un-compiled state" & @CRLF & "Now exiting....")
	WinClose("Splash Screen Generator")
	Exit
EndIf

;Define path where StartIE.exe and SplshTxt.txt are located - This MUST be set for the script to work
;$IESDIR="\\gmss-fs1\sys\SCRIPTS\INTRANET"    ;must NOT include file on the end
$IESDIR="\\01fpr\gmsssys\SCRIPTS\INTRANET"
;$IESDIR=@ScriptDir

If Not IsDeclared("IESDIR") Then
    MsgBox(4112,"Fatal Error!","StartIE.exe directory is NOT configured" & @LF & "Please contact the HelpDesk on x.6398 for assistance")
    Exit
EndIf

If Not FileExists($IESDIR) Then
    MsgBox(4112,"Fatal Error!","Cannot find StartIE.exe directory." & @LF & "Please contact the HelpDesk on x.6398 for assistance")
    Exit
EndIf 

Opt("TrayIconDebug",1)  ;Disable tray icon

If $CmdLine[0] > 0 Then
	$SubmitTest = "False"
	Call($CmdLine[1])
Else
	DoGUI()
EndIf

Func DoGUI()
	
	A3G_FormClear() 	;Just in case any variables are still set, clear GUI variables

	If FileExists($IESDIR & "\SplshTxt.txt") Then
		$SplashText = FileReadLine($IESDIR & "\SplshTxt.txt",1)
		If @error = 0 Then
			$SplshTxt = StringSplit($SplashText,",")
			If IsDeclared("SplshTxt") Then
				If UBound($SplshTxt) = 11 Then
		    			If StringInStr($SplshTxt[2],"[*LF]") > 0 Then $SplshTxt[2] = StringReplace($SplshTxt[2],"[*LF]",@CRLF)	; Check for Line Feeds
		    			If StringInStr($SplshTxt[2],"[*COMMA]") > 0 Then $SplshTxt[2] = StringReplace($SplshTxt[2], "[*COMMA]", ",")		; Check for Comma's
		    			If StringInStr($SplshTxt[1], "[*COMMA]") > 0 Then $SplshTxt[1] = StringReplace($SplshTxt[1], "[*COMMA]", ",")		; Check for Comma's
		    			If $SplshTxt[5] = "-1" Then $SplshTxt[5] = "center"   ;if x-position is -1, show as center
		    			If $SplshTxt[6] = "-1" Then $SplshTxt[6] = "center"   ;if y-position is -1, show as center    
		    			EnvSet("OBJ2.Text",$SplshTxt[1])	; Title
		    			EnvSet("OBJ4.Text",$SplshTxt[2])	; Text
		    			EnvSet("OBJ6.Text",$SplshTxt[3])	; Width
		    			EnvSet("OBJ8.Text",$SplshTxt[4])	; Height
		    			EnvSet("OBJ10.Text",$SplshTxt[5])	; x-position
		    			EnvSet("OBJ12.Text",$SplshTxt[6])	; y-position
		    			EnvSet("OBJ18.Text",$SplshTxt[10])	; Font Weight
					EnvSet("OBJ29.Text",FileReadLine($IESDIR & "\SplshTxt.txt",2))	; TimeOut
				Else
					SetGuiDefaults()
				EndIf
			Else
				SetGuiDefaults()
			EndIf
    		Else
    		    ;Error about Size of array?
    		    SetGuiDefaults()
    		EndIf
    	Else
    	    SetGuiDefaults()
    	EndIf		

	;GUI
	EnvSet("GUI.title","Splash Screen Generator")
	EnvSet("GUI.icon","Atkins04.ico")
	EnvSet("GUI.action","4")	;4 = set the data to Environment Variables "GUI","OBJ1","OBJ2","OBJn"...
	EnvSet("GUI.h","400")
	EnvSet("GUI.w","350")
	$WS_CAPTION = 12582912
	$WS_SYSMENU = 524288
	$WS_MINIMIZEBOX = 131072
	$WS_POPUP = 2147483648
	$style = BitOR($WS_CAPTION,$WS_POPUP)
	$style = BitOR($style,$WS_SYSMENU)
	$style = BitOR($style,$WS_MINIMIZEBOX)
	EnvSet("GUI.style",$style)
	
	;OBJ1 - Splash Screen Title (label title)
	EnvSet("OBJ1.type","label")
	EnvSet("OBJ1.text","Splash Screen T&itle")
	EnvSet("OBJ1.x","10")
	EnvSet("OBJ1.y","10")

	;OBJ2 - Splash Screen Title (input box)
	EnvSet("OBJ2.type","input")
	EnvSet("OBJ2.x","10")
	EnvSet("OBJ2.y","27")
	EnvSet("OBJ2.w","330")

	;OBJ3 - Splash Screen Text (label title)
	EnvSet("OBJ3.type","label")
	EnvSet("OBJ3.text","S&plash Screen Text")
	EnvSet("OBJ3.x","10")
	EnvSet("OBJ3.y","53")
	
	;OBJ4 - Splash Screen Text (edit box)
	EnvSet("OBJ4.type","edit")
	EnvSet("OBJ4.x","10")
	EnvSet("OBJ4.y","70")
	EnvSet("OBJ4.w","330")
	EnvSet("OBJ4.h","90")
	EnvSet("OBJ4.tooltip","Enter text to show in the splash screen")
	
	;OBJ5 - Width (label title)
	EnvSet("OBJ5.type","label")
	EnvSet("OBJ5.text","&Width (in pixels)")
	EnvSet("OBJ5.x","10")
	EnvSet("OBJ5.y","170")
	EnvSet("OBJ5.w","80")
	EnvSet("OBJ5.h","25")

	;OBJ6 - Width (input box)
	EnvSet("OBJ6.type","input")
	EnvSet("OBJ6.x","100")
	EnvSet("OBJ6.y","170")
	EnvSet("OBJ6.w","50")

	;OBJ7 - Height (label title)
	EnvSet("OBJ7.type","label")
	EnvSet("OBJ7.text","&Height (in pixels)")
	EnvSet("OBJ7.x","180")
	EnvSet("OBJ7.y","170")
	EnvSet("OBJ7.w","80")
	EnvSet("OBJ7.h","25")	

	;OBJ8 - Height (input box)
	EnvSet("OBJ8.type","input")
	EnvSet("OBJ8.x","270")
	EnvSet("OBJ8.y","170")
	EnvSet("OBJ8.w","50")

	;OBJ9 - Left Position (label title)
	EnvSet("OBJ9.type","label")
	EnvSet("OBJ9.text","Left Position (&x)")
	EnvSet("OBJ9.x","10")
	EnvSet("OBJ9.y","190")
	EnvSet("OBJ9.w","80")
	EnvSet("OBJ9.h","25")

	;OBJ10 - Left Position (input box)
	EnvSet("OBJ10.type","input")
	EnvSet("OBJ10.x","100")
	EnvSet("OBJ10.y","190")
	EnvSet("OBJ10.w","50")
	EnvSet("OBJ10.tooltip","Change to a number to position elsewhere")

	;OBJ11 - Top Position (label title)
	EnvSet("OBJ11.type","label")
	EnvSet("OBJ11.text","Top Position (&y)")
	EnvSet("OBJ11.x","185")
	EnvSet("OBJ11.y","190")
	EnvSet("OBJ11.w","80")
	EnvSet("OBJ11.h","25")

	;OBJ12 - Top Position (input box)
	EnvSet("OBJ12.type","input")
	EnvSet("OBJ12.x","270")
	EnvSet("OBJ12.y","190")
	EnvSet("OBJ12.w","50")
	EnvSet("OBJ12.tooltip","Change to a number to position elsewhere")

	;OBJ13 - Font (label title)
	EnvSet("OBJ13.type","label")
	EnvSet("OBJ13.text","&Font")
	EnvSet("OBJ13.x","10")
	EnvSet("OBJ13.y","210")

	;OBJ14 - Font (combo box)
	EnvSet("OBJ14.type","combo")
	EnvSet("OBJ14.x","100")
	EnvSet("OBJ14.y","210")
	EnvSet("OBJ14.w","150")
	EnvSet("OBJ14.data1","Arial")
	EnvSet("OBJ14.data2","Arial Bold")
	EnvSet("OBJ14.data3","Arial Bold Italic")
	EnvSet("OBJ14.data4","Arial Italic")
	EnvSet("OBJ14.data5","Comic Sans MS")
	EnvSet("OBJ14.data6","Courier")
	EnvSet("OBJ14.data7","Courier New")
	EnvSet("OBJ14.data8","Courier New Bold")
	EnvSet("OBJ14.data9","Courier New Bold Italic")
	EnvSet("OBJ14.data10","Courier New Italic")
	EnvSet("OBJ14.data11","Lucida Console")
	;EnvSet("OBJ14.data12","MS San Serif") ;commented out, looks funky on 98
	EnvSet("OBJ14.data12","MS Serif")
	EnvSet("OBJ14.data13","System")
	EnvSet("OBJ14.data14","Tahoma")
	EnvSet("OBJ14.data15","Times New Roman")
	EnvSet("OBJ14.data16","Times New Roman Bold")
	EnvSet("OBJ14.data17","Times New Roman Bold Italic")
	EnvSet("OBJ14.data18","Times New Roman Italic")
	EnvSet("OBJ14.data19","Wingdings")
	If UBound($SplshTxt) = 11 Then
		$i=0
		For $data = 1 To 20
			If EnvGet("OBJ14.data" & $data) = $SplshTxt[8] Then
				EnvSet("OBJ14.data" & $data,"*" & $SplshTxt[8])
				ExitLoop
			EndIf
			$i=$i+1
		Next
		If $i=20 Then EnvSet("OBJ14.data1","*Arial")
	Else
		EnvSet("OBJ14.data1","*Arial")
	EndIf
	$WS_VSCROLL = 2097152
	$CBS_DROPDOWN = 2
	EnvSet("OBJ14.Style",BitOR($WS_VSCROLL,$CBS_DROPDOWN))

	;OBJ15 - Font Size (label title)
	EnvSet("OBJ15.type","label")
	EnvSet("OBJ15.text","Font Si&ze")
	EnvSet("OBJ15.x","10")
	EnvSet("OBJ15.y","230")

	;OBJ16 - Font Size (combo box)
	EnvSet("OBJ16.type","combo")
	EnvSet("OBJ16.x","100")
	EnvSet("OBJ16.y","230")
	EnvSet("OBJ16.w","50")
	EnvSet("OBJ16.data1","6")
	EnvSet("OBJ16.data2","8")
	EnvSet("OBJ16.data3","9")
	EnvSet("OBJ16.data4","10")
	EnvSet("OBJ16.data5","11")
	EnvSet("OBJ16.data6","12")
	EnvSet("OBJ16.data7","14")
	EnvSet("OBJ16.data8","16")
	EnvSet("OBJ16.data9","18")
	EnvSet("OBJ16.data10","20")
	EnvSet("OBJ16.data11","22")
	EnvSet("OBJ16.data12","24")
	EnvSet("OBJ16.data13","26")
	EnvSet("OBJ16.data14","28")
	EnvSet("OBJ16.data15","36")
	EnvSet("OBJ16.data16","48")
	EnvSet("OBJ16.data17","72")
	If UBound($SplshTxt) = 11 Then
		$i=0
		For $data = 1 To 17
			If EnvGet("OBJ16.data" & $data) = $SplshTxt[9] Then
				EnvSet("OBJ16.data" & $data,"*" & $SplshTxt[9])
				ExitLoop
			EndIf
			$i=$i+1
		Next
		If $i=17 Then EnvSet("OBJ16.data1","*12")
	Else
		EnvSet("OBJ16.data1","*12")
	EndIf
	EnvSet("OBJ16.Style",BitOR($WS_VSCROLL,$CBS_DROPDOWN))

	;OBJ17 - Font Weight (label title)
	EnvSet("OBJ17.type","label")
	EnvSet("OBJ17.text","Font Wei&ght")
	EnvSet("OBJ17.x","10")
	EnvSet("OBJ17.y","250")

	;OBJ18 - Font Weight (input box)
	EnvSet("OBJ18.type","input")
	EnvSet("OBJ18.x","100")
	EnvSet("OBJ18.y","250")
	EnvSet("OBJ18.w","50")
	EnvSet("OBJ18.tooltip","Must be between 0 and 1000")

	;OBJ19 - Test Splash Screen (button)
	EnvSet("OBJ19.type","button")
	EnvSet("OBJ19.x","75")
	EnvSet("OBJ19.y","330")
	EnvSet("OBJ19.w","200")
	EnvSet("OBJ19.h","25")
	EnvSet("OBJ19.text","&Test Splash Screen")
	EnvSet("OBJ19.run",@ScriptFullPath & " Test testing")
	EnvSet("OBJ19.tooltip","Show example of what Splash Screen will look like with these options")
	EnvSet("OBJ19.submit","1")

	;OBJ20 - Thin bordered titleless window (check box)
	EnvSet("OBJ20.type","checkbox")
	EnvSet("OBJ20.x","10")
	EnvSet("OBJ20.y","275")
	EnvSet("OBJ20.w","120")
	EnvSet("OBJ20.h","15")
	EnvSet("OBJ20.text","&No title / Thin Border")
	EnvSet("OBJ20.checked.disable1", "2")
	EnvSet("OBJ20.unchecked.enable1", "2")
	EnvSet("OBJ20.checked.disable2", "22")
	EnvSet("OBJ20.unchecked.enable2", "22")
	If UBound($SplshTxt) = 11 Then
		If BitAND($SplshTxt[7],1) Then 
			EnvSet("OBJ20.selected","1")
			EnvSet("OBJ22.disabled","1")
			EnvSet("OBJ2.disabled","1")
		EndIf
	EndIf

	;OBJ21 - Always on top attribute (check box)
	EnvSet("OBJ21.type","checkbox")
	EnvSet("OBJ21.x","145")
	EnvSet("OBJ21.y","275")
	EnvSet("OBJ21.w","110")
	EnvSet("OBJ21.h","15")
	EnvSet("OBJ21.text","&Always on top")
	If UBound($SplshTxt) = 11 Then
		If Not BitAND($SplshTxt[7],2) Then EnvSet("OBJ21.selected","1")
	Else
		EnvSet("OBJ21.selected","1")
	EndIf

	;OBJ22 - Moveable attribute (check box)
	EnvSet("OBJ22.type","checkbox")
	EnvSet("OBJ22.x","255")
	EnvSet("OBJ22.y","275")
	EnvSet("OBJ22.w","110")
	EnvSet("OBJ22.h","15")
	EnvSet("OBJ22.text","&Moveable")
	EnvSet("OBJ22.checked.disable1", "20")
	EnvSet("OBJ22.unchecked.enable1", "20")
	If UBound($SplshTxt) = 11 Then
		If BitAND($SplshTxt[7],16) Then 
			EnvSet("OBJ22.selected","1")
			EnvSet("OBJ20.disabled","1")
		EndIf
	EndIf

	;OBJ23 - Left align text (radio box)
	EnvSet("OBJ23.type","radio")
	EnvSet("OBJ23.x","10")
	EnvSet("OBJ23.y","295")
	EnvSet("OBJ23.w","100")
	EnvSet("OBJ23.h","15")
	EnvSet("OBJ23.text","&Left Align text")
	If UBound($SplshTxt) = 11 Then
		If BitAND($SplshTxt[7],4) Then EnvSet("OBJ23.selected","1")
	EndIf
	
	;OBJ24 - Center align text (radio box)
	EnvSet("OBJ24.type","radio")
	EnvSet("OBJ24.x","115")
	EnvSet("OBJ24.y","295")
	EnvSet("OBJ24.w","100")
	EnvSet("OBJ24.h","15")
	EnvSet("OBJ24.text","C&enter Align text")
	If UBound($SplshTxt) = 11 Then
		If BitAND($SplshTxt[7],4) = 0 Then 
			If BitAND($SplshTxt[7],8) = 0 Then EnvSet("OBJ24.selected","1")
		EndIf
	Else
		EnvSet("OBJ24.selected","1")
	EndIf

	;OBJ25 - Right align text (radio box)
	EnvSet("OBJ25.type","radio")
	EnvSet("OBJ25.x","230")
	EnvSet("OBJ25.y","295")
	EnvSet("OBJ25.w","100")
	EnvSet("OBJ25.h","15")
	EnvSet("OBJ25.text","&Right Align text")
	If UBound($SplshTxt) = 11 Then
		If BitAND($SplshTxt[7],8) Then EnvSet("OBJ25.selected","1")
	EndIf

	;OBJ26 - Submit (button)
	EnvSet("OBJ26.type","button")
	EnvSet("OBJ26.x","50")
	EnvSet("OBJ26.y","365")
	EnvSet("OBJ26.w","100")
	EnvSet("OBJ26.h","25")
	EnvSet("OBJ26.text","&Submit")
	EnvSet("OBJ26.Disabled","1")
	EnvSet("OBJ26.run",@ScriptFullPath & " Submit")
	EnvSet("OBJ26.tooltip","Submit splash screen design")
	EnvSet("OBJ26.submit","1")

	;OBJ27 - Cancel (button)
	EnvSet("OBJ27.type","button")
	EnvSet("OBJ27.x","200")
	EnvSet("OBJ27.y","365")
	EnvSet("OBJ27.w","100")
	EnvSet("OBJ27.h","25")
	EnvSet("OBJ27.text","&Cancel")
	EnvSet("OBJ27.tooltip","Cancel")
	EnvSet("OBJ27.cancel","1")

	;OBJ28 - Splashtext Timeout (label)
	EnvSet("OBJ28.type","label")
	EnvSet("OBJ28.text","Time&out (in seconds)")
	EnvSet("OBJ28.x","160")
	EnvSet("OBJ28.y","243")
	EnvSet("OBJ28.w","100")
	EnvSet("OBJ28.h","25")
	EnvSet("OBJ28.fontweight","400")

	;OBJ29 - Splashtext Timeout (input box)
	EnvSet("OBJ29.type","input")
	EnvSet("OBJ29.x","270")
	EnvSet("OBJ29.y","240")
	EnvSet("OBJ29.w","45")
	EnvSet("OBJ29.tooltip","Enter the number of seconds that message is displayed for")


	;OBJ?? - Copy code to clipboard (button)
	
	;Run the GUI then!
	Run("Au3GUI")
EndFunc

Func SetGuiDefaults()
        EnvSet("OBJ6.Text","400")	; Width
	EnvSet("OBJ8.Text","200")	; Height
	EnvSet("OBJ10.Text","Center")	; x-position
	EnvSet("OBJ12.Text","Center")	; y-position
	EnvSet("OBJ18.Text","400")	; Font Weight
	EnvSet("OBJ29.Text","10")	; Timeout
EndFunc

Func Test()
	AutoItSetOption("ExpandEnvStrings", 1)

	;Verify settings that should be numbers are numbers
	Select
		Case StringIsDigit("%OBJ6%") = 0
			MsgBox(4144,"Error!","Width MUST be a number!" & @CRLF & "Please correct this before continuing")
			Exit
		Case StringIsDigit("%OBJ8%") = 0
			MsgBox(4144,"Error!","Height MUST be a number!" & @CRLF & "Please correct this before continuing")
			Exit
		Case EnvGet("OBJ10") <> "center"
			If StringIsDigit("%OBJ10%") = 0 Then
				MsgBox(4144,"Error!","Left Position MUST be a number or 'center'!" & @CRLF & "Please correct this before continuing")
				Exit
			EndIf
		Case EnvGet("OBJ12") <> "center"
			If StringIsDigit("%OBJ12%") = 0 Then
				MsgBox(4144,"Error!","Top Position MUST be a number or 'center'!" & @CRLF & "Please correct this before continuing")
				Exit
			EndIf
		Case StringIsDigit("%OBJ18%") = 0
			MsgBox(4144,"Error!","Font Weight MUST be a number!" & @CRLF & "Please correct this before continuing")
			Exit
		Case EnvGet("OBJ29") < 0
			MsgBox(4144,"Error!","Time out CANNOT be a negative number!" & @CRLF & "Please correct this before continuing.")
			ControlDisable("Splash Screen Generator","", "Button8")
			Exit
		Case NOT StringIsDigit("%OBJ29%")
			MsgBox(4144,"Error!","Time out must be set to a positive number or left blank for no timeout!" & @CRLF & "Please correct this before continuing.")
			ControlDisable("Splash Screen Generator","", "Button8")
			Exit
	EndSelect

	If $SubmitTest <> "True" Then
		Select
			Case EnvGet("OBJ29") = ""
				MsgBox(4160,"Information","Time out value is blank. HOLLI will still launch, but no splash screen will show")
				ControlEnable("Splash Screen Generator","", "Button8")
				Exit
			Case EnvGet("OBJ29") = 0
				MsgBox(4160,"Information","Time out set to 0. HOLLI will still launch, but no splash screen will show")
				ControlEnable("Splash Screen Generator","", "Button8")
				Exit
		EndSelect
		ShowSplash()
	EndIf

EndFunc

Func ShowSplash()
	;Show Splash Screen (when testing)
	$SplashOptions = SplashTextOptions()

	;Show the splash screen
	;SplashTextOn("title", "text" [, w [, h [, x pos [, y pos [, opt [, "fontname" [, "fontsz" [, "fontwt"]]]]]]]] 
	SplashTextOn("%OBJ2%","%OBJ4%","%OBJ6%","%OBJ8%","%OBJ10%","%OBJ12%",$SplashOptions,"%OBJ14%","%OBJ16%","%OBJ18%")
	
	;Set ESC hotkey to close splash screen
	HotKeySet("{ESC}", "StopSplash")

	;Show Stop Splash Screen GUI
	StopSplashGUI(EnvGet("OBJ2"),EnvGet("OBJ4"))

	;Enable Submit button
	ControlEnable("Splash Screen Generator","", "Button8")

	;Wait for Stop Splash Screen GUI to appear
	WinWait("Stop Splash Screen")	
	
	;set countdown variable to timeout
	$countdown = EnvGet("OBJ29")

	;While loop so script stays running to keep the Splash Screen alive (splash screen goes, so does script)
	While WinExists("Stop Splash Screen") AND $countdown <> 0
		Sleep(1000)
		$countdown = $countdown - 1
		If $countdown <> 1 Then
			$countdownmsg = $countdown & " seconds"
		Else
			$countdownmsg = "1 second"
		EndIf
		ControlSetText("Stop Splash Screen","","Static1","Closing in " & $countdownmsg)
	Wend
	
	;Stop splash screen after timeout
	StopSplash()
EndFunc

Func SplashTextOptions()
	$SplashOptions = 0
	If EnvGet("OBJ20") = "CHECKED" Then $SplashOptions=$SplashOptions+1		;thin bordered titleless window
	If EnvGet("OBJ21") = "UNCHECKED" Then $SplashOptions=$SplashOptions+2	;without "always on top" attribute
	If EnvGet("OBJ22") = "CHECKED" Then $SplashOptions=$SplashOptions+16		;moveable attribute
	If EnvGet("OBJ23") = "CHECKED" Then $SplashOptions=$SplashOptions+4		;left justified text
											                                			;OBJ24 (center justified text) = 0
	If EnvGet("OBJ25") = "CHECKED" Then $SplashOptions=$SplashOptions+8		;right justified text

	If EnvGet("OBJ10") = "center" Then EnvSet("OBJ10","-1")
	If EnvGet("OBJ12") = "center" Then EnvSet("OBJ12","-1")

	If EnvGet("OBJ29") = "" Then EnvSet("OBJ29","0")
	Return $SplashOptions
EndFunc

Func StopSplashGUI($SplashTitle,$SplashText)

	;Clear GUI first
	A3G_FormClear()

	AutoItSetOption("ExpandEnvStrings", 1)

	;GUI
	EnvSet("GUI.title","Stop Splash Screen")
	EnvSet("GUI.icon","Atkins04.ico")
	EnvSet("GUI.x","10")
	EnvSet("GUI.y","10")
	EnvSet("GUI.w","200")
	EnvSet("GUI.h","70")
	EnvSet("GUI.parent","Splash Screen Generator")
	$WS_CAPTION = 12582912
	EnvSet("GUI.style",$WS_CAPTION)
	EnvSet("GUI.action",4)

	;OBJ1 - Stop Splash Screen (button)
	EnvSet("OBJ1.type","button")
	EnvSet("OBJ1.x","10")
	EnvSet("OBJ1.y","10")
	EnvSet("OBJ1.w","180")
	EnvSet("OBJ1.h","30")
	EnvSet("OBJ1.text","Close Splash Screen   [ESC]")
	EnvSet("OBJ1.run",@ScriptFullPath & " StopSplash")
	EnvSet("OBJ1.cancel","1")

	;OBJ2 - Closing in x seconds (label)
	EnvSet("OBJ2.type","label")
	EnvSet("OBJ2.x","45")
	EnvSet("OBJ2.y","50")
	EnvSet("OBJ2.w","180")
	EnvSet("OBJ2.h","20")
	EnvSet("OBJ2.text","Closing in %OBJ29% seconds")

	;Run the GUI
	Run("Au3GUI")

	;Activate Splash Screen
	If WinWait($SplashTitle,$SplashText,10) = 0 Then
		MsgBox(4096,"ERROR!","Unable to invoke Splash Screen!")
	Else
		WinActivate($SplashTitle)
	EndIf

EndFunc

Func StopSplash()
	; Close SplashScreen, Close Child GUI and re-activate Parent GUI
	SplashOff()	                                ;Disable splash screen
	WinClose("Stop Splash Screen")	            ;Close Stop Splash Screen GUI, in case ESC is used.
	WinActivate("Splash Screen Generator") 		; Main GUI focus lost when closing child GUI
EndFunc

Func Submit()
	; Submit

	$SubmitTest = "True"
	Test()	

	WinShow("Splash Screen Generator", "", @SW_HIDE)

	If EnvGet("OBJ29") >0 Then
		$MsgOpt = 4132
		$Msg = "Are you certain that you wish to submit this Splash Screen?" & @CR & @CR & "NOTE! This will appear for "
		If EnvGet("OBJ29") <> 1 Then
			$Msg = $Msg & EnvGet("OBJ29") & " seconds"
		Else
			$Msg = $Msg & "1 second"
		EndIf
		$Msg = $Msg & " on every users PC while HOLLI starts"
	ElseIf EnvGet("OBJ29") = 0 OR EnvGet("OBJ29") = "" Then
		$MsgOpt = 4148
		$Msg = "Splash screen time-out not set! HOLLI will still launch, but no splash screen will show" & @CRLF & @CRLF & "Are you sure this is what you want to do?"
	EndIf

	If MsgBox($MsgOpt,"Confirm Splash Text Submit",$Msg) = 6 Then
		$SplashOptions = SplashTextOptions()
		AutoItSetOption("ExpandEnvStrings", 1)
		
		If StringInStr("%OBJ4%", CHR(13)) > 0 Then EnvSet("OBJ4",StringStripCR("%OBJ4%"))					; Check for Carriage Returns and Remove from String
		If StringInStr("%OBJ4%", CHR(10)) > 0 Then EnvSet("OBJ4",StringReplace("%OBJ4%", CHR(10), "[*LF]"))	; Check for Line Feeds
		If StringInStr("%OBJ4%", ",") > 0 Then EnvSet("OBJ4",StringReplace("%OBJ4%", ",", "[*COMMA]"))		; Check for Comma's
		If StringInStr("%OBJ2%", ",") > 0 Then EnvSet("OBJ2",StringReplace("%OBJ2%", ",", "[*COMMA]"))		; Check for Comma's
		
		
		$SplashConfig="%OBJ2%,%OBJ4%,%OBJ6%,%OBJ8%,%OBJ10%,%OBJ12%," & $SplashOptions & ",%OBJ14%,%OBJ16%,%OBJ18%"

        Do
            $Success=1
            If FileExists($IESDIR & "\SplshTxt.txt") Then $Success = FileDelete($IESDIR & "\SplshTxt.txt")
            If $Success Then $Success = FileWrite($IESDIR & "\SplshTxt.txt",$SplashConfig & @CRLF & "%OBJ29%")
            If $Success Then ExitLoop
            If MsgBox(4149,"Error","Could not write file") <> 4 Then ExitLoop
        Until $Success
        
		If MsgBox(4132,"Intranet SplashTexter","SplashText successfully submitted" & @CR & "Would you like to run the Intranet Launch Utility?") = 6 Then
			Run($IESDIR & "\StartIE.Exe")
		EndIf
	Else
		WinShow("Splash Screen Generator", "", @SW_SHOW)
		WinActivate("Splash Screen Generator")
	EndIf
EndFunc

Func A3G_FormClear()
 EnvSet("GUI.title","")
 EnvSet("GUI.icon","")
 EnvSet("GUI.x","")
 EnvSet("GUI.y","")
 EnvSet("GUI.w","")
 EnvSet("GUI.h","")
 EnvSet("GUI.style","")
 EnvSet("GUI.exstyle","")
 EnvSet("GUI.focus","")
 EnvSet("GUI.action","")
 EnvSet("GUI.file","")
 EnvSet("GUI.help","")
 EnvSet("GUI.run","")

 For $a = 1 To 29
  EnvSet("OBJ" & $a & ".type","")
  EnvSet("OBJ" & $a & ".text","")
  EnvSet("OBJ" & $a & ".file","")
  EnvSet("OBJ" & $a & ".x","")
  EnvSet("OBJ" & $a & ".y","")
  EnvSet("OBJ" & $a & ".w","")
  EnvSet("OBJ" & $a & ".h","" )
  EnvSet("OBJ" & $a & ".style","")
  EnvSet("OBJ" & $a & ".exstyle","")
  EnvSet("OBJ" & $a & ".selected","")
  EnvSet("OBJ" & $a & ".tooltip","")
  EnvSet("OBJ" & $a & ".font","")
  EnvSet("OBJ" & $a & ".fontsize","")
  EnvSet("OBJ" & $a & ".fontweight","")
  EnvSet("OBJ" & $a & ".settext1","")
  EnvSet("OBJ" & $a & ".settext2","")
  EnvSet("OBJ" & $a & ".disable1","")
  EnvSet("OBJ" & $a & ".enable1","")
  EnvSet("OBJ" & $a & ".hide1","")
  EnvSet("OBJ" & $a & ".show1","")
  EnvSet("OBJ" & $a & ".submit","")
  EnvSet("OBJ" & $a & ".cancel","")
  EnvSet("OBJ" & $a & ".close","")
  EnvSet("OBJ" & $a & ".run","")
 Next
EndFunc
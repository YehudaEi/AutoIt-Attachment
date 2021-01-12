#cs
    Name: BetaPad - An Open Source Text Editor
    Author: Secure_ICT and _Kurt
    License: Licensed under the Common Public License.
    Version: Alpha 2.0
    Readme: The readme can be found with in the docs folder.
    Notes: Must include:
    <GUIConstants.au3>
    <String.au3>
    <GuiStatusBar.au3>
    <Sound.au3>
    <File.au3>
    <ModernMenu.au3>
#ce

; These need to be included
#include <GUIConstants.au3>
#include <String.au3>
#include <GuiStatusBar.au3>
#include <Sound.au3>
#include <File.au3>
#include <ModernMenu.au3>

#NoTrayIcon

; Create settings and set values
$Version = "Version 2.0"
$Author = @UserName
Dim $voice = ObjCreate("Sapi.SpVoice")
Local $BetaPad, $StatusBar, $msg, $set = @ScriptDir & "\settings.dat"
Local $a_PartsRightEdge[2] = [210, -1]
Local $a_PartsText[2] = ["BetaPad | " & $Version & " | " & "User: " & $Author, "Ready"]

; Set HotKeys
Global $Hotkey
HotKeySet("^s", "save")
HotKeySet("^o", "open")
HotKeySet("^p", "print")

If NOT FileExists($set) Then FileWrite($set, "Default" & @CRLF & "No Recent Files")
$menucolour = FileReadLine($set, 1)
$recentfile = FileReadLine($set, 2)
ReadMenuColor()

; Create the GUI and play opening sound
$BetaPad = GUICreate("BetaPad | Untitled", 626, 466, @DesktopHeight / 3, @DesktopWidth / 5);, BitOR($WS_MAXIMIZEBOX, $WS_MINIMIZEBOX, $WS_SIZEBOX))
GUISetIcon("shell32.dll",70)
$StatusBar = _GUICtrlStatusBarCreate($BetaPad, $a_PartsRightEdge, $a_PartsText)
_GUICtrlStatusBarSetIcon($StatusBar, 2, "shell.dll", 1)

$sound = _SoundOpen(@WindowsDir & "\media\chimes.wav", "Startup")
_SoundPlay($sound)
$SearchInput = GUICtrlCreateInput("Type in a string and then select an engine to search through.", 15, 10, 435, 21)
$Search = GUICtrlCreateButton("&Search", 536, 8, 72, 25, 0)
$Engine = GUICtrlCreateCombo("Pick one!", 456, 10, 73, 25)
GUICtrlSetData(-1, "Google|Yahoo|Ebay|Sourceforge|Ask|Wikipedia")

$Doc1 = GUICtrlCreateTabItem("Doc1")
$DocEd1 = GUICtrlCreateEdit("", 15, 40, 590, 340, BitOR($ES_AUTOVSCROLL, $ES_WANTRETURN, $WS_VSCROLL))
GUICtrlSetData(-1, "")
FirstRun()

$File   = GUICtrlCreateMenu("&File")
$NewDox = _GUICtrlCreateODMenuitem ("&New ", $File)
$Open   = _GUICtrlCreateODMenuitem ("Open", $File)
$OpenRecent = _GUICtrlCreateODMenu ("Open Recent", $File, 1)
$recent1 = _GUICtrlCreateODMenuItem ("", $OpenRecent, '', 0, 1)
If FileExists($recentfile) Then $recent1 = _GUICtrlCreateODMenuItem ($recentfile, $OpenRecent, '', 0, 1)
_GUICtrlCreateODMenuitem ("", $File)
$Save   = _GUICtrlCreateODMenuitem ("Save", $File)
$Saveas = _GUICtrlCreateODMenuitem ("Save As ..", $File)
_GUICtrlCreateODMenuitem ("", $File)
$Print  = _GUICtrlCreateODMenuitem ("&Print...         CTRL+P", $File)
_GUICtrlCreateODMenuitem ("", $File)
$Exit   = _GUICtrlCreateODMenuitem ("E&xit", $File)

$Edit   = GUICtrlCreateMenu("&Edit")
$InsDT  = _GUICtrlCreateODMenuitem ("&Insert Date + Time", $Edit)
_GUICtrlCreateODMenuitem ("", $Edit)
$Encrypter     = _GUICtrlCreateODMenuitem ("&Encrypt", $Edit)
$Decrypter     = _GUICtrlCreateODMenuitem ("&Decrypt", $Edit)
_GUICtrlCreateODMenuitem ("", $Edit)
$Reverse	   = _GUICtrlCreateODMenuitem ("&Reverse", $Edit)

$Speak  = GUICtrlCreateMenu("&Speak")
$Speaktxt = _GUICtrlCreateODMenuItem ('&Speak Text', $Speak)
$speechoptions = _GUICtrlCreateODMenu ('&Speech Options', $Speak)
$spchtes = _GUICtrlCreateODMenuItem('Test Speech', $speechoptions)

$Format = GUICtrlCreateMenu("&Format")
$WCount = _GUICtrlCreateODMenuitem ("&Word Count", $Format)
$Display= _GUICtrlCreateODMenuitem ("&Set Font", $Format)

$Dever         = GUICtrlCreateMenu("&Developer")
$FileSize      = _GUICtrlCreateODMenuitem ("File Size", $Dever)
_GUICtrlCreateODMenuitem ("", $Dever)
$ViewColorMenu = _GUICtrlCreateODMenu ('&Menu Colors', $Dever)
$SetDefClrItem = _GUICtrlCreateODMenuItem ('Default', $ViewColorMenu, '', 0, 1)
_GUICtrlCreateODMenuItem ('', $ViewColorMenu)
$SetRedClrItem = _GUICtrlCreateODMenuItem ('Red', $ViewColorMenu, '', 0, 1)
$SetGrnClrItem = _GUICtrlCreateODMenuItem ('Green', $ViewColorMenu, '', 0, 1)
$SetBlueClrItem= _GUICtrlCreateODMenuItem ('Blue', $ViewColorMenu, '', 0, 1)

$Help   = GUICtrlCreateMenu("&Help")
$About  = _GUICtrlCreateODMenuitem ("&About", $Help)
_GUICtrlCreateODMenuitem ("", $Help)
$betasite = _GUICtrlCreateODMenuItem ("&Visit our website", $Help)
$Helpme = _GUICtrlCreateODMenuitem ("&Help", $Help)
GUICtrlSetState(-1, $GUI_DISABLE)

$recent= GUICtrlCreateLabel("", -700, -700, 10, 10)
If FileExists($recentfile) Then $recent = GUICtrlCreateLabel($recentfile, -700, -700, 10, 10)
$ius= GUICtrlCreateLabel("", -600, -600, 10, 10)
$fn = GUICtrlCreateLabel("Arial", -500, -500, 10, 10)
$sz = GUICtrlCreateLabel("9", -400, -400, 10, 10)
GUISetBkColor(0xEBEFF5)
_GUICtrlStatusBarResize($StatusBar)
GUISetState(@SW_SHOW)

While 1
    $nMsg = GUIGetMsg()
    Switch $nMsg
		Case $Saveas
			saveas()
        Case $GUI_EVENT_CLOSE
            ExitLoop
        Case $GUI_EVENT_RESIZED
            _GUICtrlStatusBarResize($StatusBar)
        Case $Exit
            ExitLoop
        Case $Display
            $clg = GUICtrlRead($DocEd1)
            $GUI2 = GUICreate("Choose Your Font", 250, 200, -1, -1, $WS_EX_LAYERED, $WS_EX_TOOLWINDOW)
            GUICtrlCreateLabel("Customize your font", 10, 5, 120)
            GUICtrlSetFont(-1, 9, 400, 0, "Arial Bold")
            $i = GUICtrlCreateCheckbox("Italic", 10, 25)        ;2
            $u = GUICtrlCreateCheckbox("Underlined", 10, 50)    ;4
            $s = GUICtrlCreateCheckbox("Strikethrough", 10, 75) ;8
            $cmb = GUICtrlCreateCombo("Choose Font..", 105, 25, 120, 20)
            GUICtrlSetData($cmb, "Arial|Arial Bold|Comic Sans MS|Courier New|Tahoma|Times New Roman")
            $size = GUICtrlCreateInput("9", 105, 55, 40)
            GUICtrlCreateUpdown($size)
            GUICtrlSetLimit($size, 999, 1)
            $a1 = GUICtrlCreateLabel($clg, 8, 130, 230, 40, 1, 15)
            GUICtrlSetBkColor(-1, 0xFFFFFF)
            GUISetState()
            While WinActive($GUI2)
                $msg = GUIGetMsg()
                Select
                    Case $msg = $GUI_EVENT_CLOSE
                        Local $i1 = 0, $u1 = 0, $s1 = 0
                        If GUICtrlRead($i) = $GUI_CHECKED Then $i1 = 2
                        If GUICtrlRead($u) = $GUI_CHECKED Then $u1 = 4
                        If GUICtrlRead($s) = $GUI_CHECKED Then $s1 = 8
                        $1size = GUICtrlRead($size)
                        $font1 = GUICtrlRead($cmb)
                        $New = $i1 + $u1 + $s1
                        GUIDelete($GUI2)
                        GUICtrlSetData($ius, $new)
                        If Not GUICtrlRead($cmb) = "Choose Font.." Then GUICtrlSetData($fn, $font1)
                        GUICtrlSetData($sz, $1size)
                        GUICtrlSetFont($DocEd1, $1size, 400, $New, $font1)
                        ExitLoop
                    Case $msg = $size
                        Local $i3 = 0, $u3 = 0, $s3 = 0
                        If GUICtrlRead($i) = $GUI_CHECKED Then $i2 = 2
                        If GUICtrlRead($u) = $GUI_CHECKED Then $u2 = 4
                        If GUICtrlRead($s) = $GUI_CHECKED Then $s2 = 8
                        $1size = GUICtrlRead($size)
                        $new2 = $i2 + $u2 + $s2
                        $p = GUICtrlRead($cmb)
                        GUICtrlSetFont($a1, $1size, 400, $new2, $p)
                    Case $msg = $cmb
                        Local $i2 = 0, $u2 = 0, $s2 = 0
                        If GUICtrlRead($i) = $GUI_CHECKED Then $i2 = 2
                        If GUICtrlRead($u) = $GUI_CHECKED Then $u2 = 4
                        If GUICtrlRead($s) = $GUI_CHECKED Then $s2 = 8
                        $1size = GUICtrlRead($size)
                        $new2 = $i2 + $u2 + $s2
                        $p = GUICtrlRead($cmb)
                        GUICtrlSetFont($a1, $1size, 400, $new2, $p)
                        _GUICtrlStatusBarSetText($StatusBar, "Font set to: " & $p, 1)
                    Case $msg = $i;;;;;;;;;;;;;;;;;;;;;;;;;
                        If GUICtrlRead($i) = $GUI_CHECKED Then
                            $n = 2
                            If GUICtrlRead($u) = $GUI_CHECKED Then $n = 6
                            If GUICtrlRead($s) = $GUI_CHECKED Then $n = 10
                            If GUICtrlRead($u) = $GUI_CHECKED And GUICtrlRead($s) = $GUI_CHECKED Then $n = 14
                            $1size = GUICtrlRead($size)
                            $font1 = GUICtrlRead($cmb)
                            GUICtrlSetFont($a1, $1size, 400, $n, $font1)
                        Else
                            $n = 0
                            If GUICtrlRead($u) = $GUI_CHECKED Then $n = 4
                            If GUICtrlRead($s) = $GUI_CHECKED Then $n = 8
                            If GUICtrlRead($u) = $GUI_CHECKED And GUICtrlRead($s) = $GUI_CHECKED Then $n = 12
                            $1size = GUICtrlRead($size)
                            $font1 = GUICtrlRead($cmb)
                            GUICtrlSetFont($a1, $1size, 400, $n, $font1)
                        EndIf
                    Case $msg = $u;;;;;;;;;;;;;;;;;;;;;;;;;
                        If GUICtrlRead($u) = $GUI_CHECKED Then
                            $n = 4
                            If GUICtrlRead($i) = $GUI_CHECKED Then $n = 6
                            If GUICtrlRead($s) = $GUI_CHECKED Then $n = 12
                            If GUICtrlRead($i) = $GUI_CHECKED And GUICtrlRead($s) = $GUI_CHECKED Then $n = 14
                            $1size = GUICtrlRead($size)
                            $font1 = GUICtrlRead($cmb)
                            GUICtrlSetFont($a1, $1size, 400, $n, $font1)
                        Else
                            $n = 0
                            If GUICtrlRead($i) = $GUI_CHECKED Then $n = 2
                            If GUICtrlRead($s) = $GUI_CHECKED Then $n = 8
                            If GUICtrlRead($i) = $GUI_CHECKED And GUICtrlRead($s) = $GUI_CHECKED Then $n = 10
                            $1size = GUICtrlRead($size)
                            $font1 = GUICtrlRead($cmb)
                            GUICtrlSetFont($a1, $1size, 400, $n, $font1)
                        EndIf
                    Case $msg = $s;;;;;;;;;;;;;;;;;;;;;;;;;
                        If GUICtrlRead($s) = $GUI_CHECKED Then
                            $n = 8
                            If GUICtrlRead($u) = $GUI_CHECKED Then $n = 12
                            If GUICtrlRead($i) = $GUI_CHECKED Then $n = 10
                            If GUICtrlRead($u) = $GUI_CHECKED And GUICtrlRead($i) = $GUI_CHECKED Then $n = 14
                            $1size = GUICtrlRead($size)
                            $font1 = GUICtrlRead($cmb)
                            GUICtrlSetFont($a1, $1size, 400, $n, $font1)
                        Else
                            $n = 0
                            If GUICtrlRead($u) = $GUI_CHECKED Then $n = 4
                            If GUICtrlRead($i) = $GUI_CHECKED Then $n = 2
                            If GUICtrlRead($u) = $GUI_CHECKED And GUICtrlRead($i) = $GUI_CHECKED Then $n = 6
                            $1size = GUICtrlRead($size)
                            $font1 = GUICtrlRead($cmb)
                            GUICtrlSetFont($a1, $1size, 400, $n, $font1)
                        EndIf
                EndSelect
            WEnd
        Case $Open
			open()
        Case $recent1
            $direct = GUICtrlRead($recent)
			$text   = FileReadLine($direct)
			$text   = StringReplace($text, "££££", @CRLF)
			$split  = StringSplit($text, "|")
			If IsArray($split) Then
				GUICtrlSetData($DocEd1, $split[1])
				GUICtrlSetData($ius, $split[2])
				GUICtrlSetData($fn,  $split[3])
				GUICtrlSetData($sz,  $split[4])
				WinSetTitle("BetaPad | ", "", "BetaPad | " & $direct)
			Else
				MsgBox(0,"","Error Opening File")
			EndIf
        Case $FileSize
			If Not IsDeclared("iMsgBoxAnswer") Then Dim $iMsgBoxAnswer
			$iMsgBoxAnswer = MsgBox(52,"","To check the file size, it is mandatory that you save the document. Would you like to save?")
			Select
				Case $iMsgBoxAnswer = 6 
					save()
					$GetSize = FileGetSize(save()) / 1024
					MsgBox(0, "FileSize", "The size of this file is: " & $GetSize & " KB")
			EndSelect
        Case $NewDox
            If NOT GUICtrlRead($DocEd1) = "" Then
                $newsave = MsgBox(0x1004, "Save Document?", "There is text in the document, would you like to save it?")
                If $newsave = 6 Then save()
				GUICtrlSetData($DocEd1, "")
            EndIf
			WinSetTitle("BetaPad | ", "", "BetaPad | Untitled")
        Case $About
            MsgBox(0, "About", "BetaPad " & $Version & "Created by:" & @TAB & "Secure_ICT." & @CRLF & @TAB & "and _Kurt" & @CRLF & "An open source text editor!" & @CRLF & "This script is licensed under the Common Public License. ")
        Case $InsDT
			$keep = GUICtrlRead($DocEd1)
            GUICtrlSetData($DocEd1, $keep & " " & @HOUR & ":" & @MIN & " " & @MDAY & "/" & @MON & "/" & @YEAR & " ")
        Case $WCount
            $dok1 = GUICtrlRead($DocEd1)
            $do1 = StringSplit($dok1, " ")
            MsgBox(0, "Word Count", $do1[0] - 1 & " words in total." & @CRLF & @CRLF & StringLen($dok1) & " letters in total.")
        Case $Search
            If StringInStr(GUICtrlRead($Engine), "Google") Then
                ShellExecute ("www.google.com/search?q=" & GUICtrlRead($SearchInput))
            Else
				If StringInStr(GUICtrlRead($Engine), "Yahoo") Then
					ShellExecute ("                              ;_ylt=A0oGki6dHJRFEk0AtBxXNyoA?p=" & GUICtrlRead($SearchInput) & "&prssweb=Search&ei=UTF-8&fr=yfp-t-501&fp_ip=UK&x=wrt&meta=0")
			Else
				If StringinStr(GuiCtrlRead($Engine), "Ebay") Then
					ShellExecute ("                         " & GuiCtrlRead($SearchInput) & "_W0QQfrppZ50QQfsopZ1QQmaxrecordsreturnedZ300")
			Else					
				If StringInStr(GUICtrlRead($Engine), "Sourceforge") Then
					ShellExecute ("http://sourceforge.net/search/?type_of_search=soft&words=" & GuiCtrlRead($SearchInput))
			Else
				If StringInStr(GuictrlRead($Engine), "Ask") Then
					ShellExecute ("                         " & GuiCtrlRead($SearchInput)& "&qsrc=0&o=333&l=dir")
			Else
				If StringInStr(GuiCtrlRead($Engine), "Wikipedia") Then
					ShellExecute ("http://en.wikipedia.org/wiki/" & GuiCtrlRead($SearchInput))
			Else
					MsgBox(0,"Error","Please specify a string and engine to search with.")
				EndIf
            EndIf
			EndIf
			EndIf
			EndIf
			EndIf
            IniWrite(@TempDir & "Betapad.ini", "Search", "Last Search", $SearchInput & " / " & $Engine)
        Case $Save
            save()
        Case $Encrypter
			$encrt = GUICtrlRead($DocEd1)
            $word2encrypt = InputBox("Password", "What do you want the password to encrypt with be?")
            GUICtrlSetData($DocEd1, _StringEncrypt(1, $encrt, $word2encrypt))
			_GUICtrlStatusBarSetText($StatusBar, "Encrypted!", 1)
        Case $Decrypter
			$decryt = GuiCtrlRead($DocEd1)
            $word2decrypt = InputBox("Password", "What is the password that will decrypt the text?")
            GUICtrlSetData($DocEd1, _StringEncrypt(0, $decryt, $word2decrypt))
			_GUICtrlStatusBarSetText($StatusBar, "Decrypted!", 1)
			ShellExecute("http://betapad.sf.net")
        Case $Print
            print()
        Case $SetDefClrItem
            def()
        Case $SetRedClrItem
            red()
        Case $SetGrnClrItem
            grn()
        Case $SetBlueClrItem
            blue()
		Case $Speaktxt
			$empty = ""
			$txt2speech = GuiCtrlRead($DocEd1)
			If $txt2speech == $empty Then
				Speak("There is no text too reed", 0, 100)
		Else
			Speak($txt2speech, 0, 100)
		EndIf
		Case $Reverse
			GuiCtrlSetData($DocEd1, _StringReverse(GuiCtrlRead($DocEd1)))
        Case Else
            ;;;;;
    EndSwitch
WEnd
	
Func FirstRun()
	InetGet("http://betapad.sf.net/version.ini", "C:\betaversion.ini")
    RegRead("HKEY_CURRENT_USER\Software\BetaPad\Settings", "FirstRun")
    If @error Then
        GuiCtrlSetData($DocEd1, "Welcome to BetaPad. It looks like this is your first time running BetaPad." & @CRLF & @CRLF & _
        "You are using, " & $Version & " of BetaPad. Our newest version is: " & FileRead("C:\betaversion.ini"))
        RegWrite("HKEY_CURRENT_USER\Software\BetaPad\Settings", "FirstRun", "REG_SZ", "Ranb4")
    EndIf
EndFunc

Func Speak($Text, $Rate, $Volme)
$voice.Rate = $Rate
$voice.Volume = $Volme
$voice.Speak($Text)
EndFunc

Func saveas()
    $SaveDir = FileSaveDialog("Save", @MyDocumentsDir, "Text Document(*.txt)", 16, ".txt")
	If @error <> 1 AND NOT GUICtrlRead($recent) = $SaveDir Then $recent = _GUICtrlCreateODMenuitem ($SaveDir, $OpenRecent)
	If FileExists($SaveDir) Then FileDelete($SaveDir)
    If NOT $SaveDir = "" Then 
		_FileWriteToLine($set,2,$SaveDir,1)
		$text  = GUICtrlRead($DocEd1)
		$text  = StringReplace($text, @CRLF, "££££")
		$new   = GUICtrlRead($ius)
		If $new = "" Then $new = "-"
		$ab    = GUICtrlRead($fn) 
		$2size = GUICtrlRead($sz) 
		FileWrite($SaveDir, $text & "|" & $new & "|" & $ab & "|" & $2size)
		WinSetTitle("BetaPad | ", "", "BetaPad | " & $SaveDir)
		MsgBox(0,"","Save Successful")
		Return $SaveDir
	EndIf
EndFunc   

Func save()
	If WinGetTitle("BetaPad | ") = "BetaPad | Untitled" Then
		saveas()
	Else
		$title = WinGetTitle("BetaPad | ")
		$dir   = StringTrimLeft($title, 10)
		$text  = GUICtrlRead($DocEd1)
		$text  = StringReplace($text, @CRLF, "££££")
		$new   = GUICtrlRead($ius)
		If $new = "" Then $new = "-"
		$ab    = GUICtrlRead($fn) 
		$2size = GUICtrlRead($sz)
		FileDelete($dir)
		FileWrite($dir, $text & "|" & $new & "|" & $ab & "|" & $2size)
		Return $dir
	EndIf
EndFunc

Func open()
    $OpenDir = FileOpenDialog("Open", @MyDocumentsDir, "Text Document(*.txt)", 16, ".txt")
	If @error <> 1 AND NOT GUICtrlRead($recent) = $OpenDir Then $recent = _GUICtrlCreateODMenuitem ($OpenDir, $OpenRecent)
    If NOT $OpenDir = "" Then
		$text  = FileReadLine($OpenDir,1)
		$text  = StringReplace($text, "££££", @CRLF)
		$split = StringSplit($text, "|")
		If IsArray($split) Then
			GUICtrlSetData($DocEd1, $split[1])
			GUICtrlSetData($ius, $split[2])
			GUICtrlSetData($fn,  $split[3])
			GUICtrlSetData($sz,  $split[4])
			_FileWriteToLine($set,2,$OpenDir,1)
			WinSetTitle("BetaPad | ", "", "BetaPad | " & $OpenDir)
		Else
			MsgBox(0,"","Error Opening File")
		EndIf
	EndIf
EndFunc   

Func print()
	If Not IsDeclared("iMsgBoxAnswer") Then Dim $iMsgBoxAnswer
	$iMsgBoxAnswer = MsgBox(52,"","To check the print, it is mandatory that you save the document. Would you like to save?")
	Select
		Case $iMsgBoxAnswer = 6 
			save()
			If _FilePrint(save()) Then
				MsgBox(0, "Print", "The file was succesfully printed.")
			Else
				MsgBox(0, "Print", "Error: " & @error & @CRLF & "The file was not printed.")
			EndIf
	EndSelect
EndFunc   

Func def()
    SetCheckedItem($SetDefClrItem)
    SetDefaultMenuColors()
    _GUICtrlStatusBarSetText($StatusBar, "Menu Colour is set to: Default", 1)
    IniWrite(@TempDir & "Betapad.ini", "MenuColour", "NewColour", "Default")
	_FileWriteToLine($set, 1, "Default", 1)
EndFunc   

Func red()
    SetCheckedItem($SetDefClrItem)
    SetRedMenuColors()
    _GUICtrlStatusBarSetText($StatusBar, "Menu Colour is set to: Red", 1)
    _FileWriteToLine($set, 1, "Red", 1)
EndFunc  

Func grn()
    SetCheckedItem($SetGrnClrItem)
    SetGreenMenuColors()
    _GUICtrlStatusBarSetText($StatusBar, "Menu Colour is set to: Green", 1)
    _FileWriteToLine($set, 1, "Green", 1)
EndFunc 

Func blue()
    SetCheckedItem($SetBlueClrItem)
    SetBlueMenuColors()
    _GUICtrlStatusBarSetText($StatusBar, "Menu Colour is set to: Blue", 1)
    _FileWriteToLine($set, 1, "Blue", 1)
EndFunc   

Func ReadMenuColor()
	If $menucolour = "Default" Then SetDefaultMenuColors()
	If $menucolour = "Blue" Then SetBlueMenuColors()
	If $menucolour = "Red" Then SetRedMenuColors()
	If $menucolour = "Green" Then SetGreenMenuColors()
EndFunc 

Func SetCheckedItem($DefaultItem)
    GUICtrlSetState($SetDefClrItem, $GUI_UNCHECKED)
    GUICtrlSetState($SetRedClrItem, $GUI_UNCHECKED)
    GUICtrlSetState($SetGrnClrItem, $GUI_UNCHECKED)
    GUICtrlSetState($SetBlueClrItem, $GUI_UNCHECKED)
    GUICtrlSetState($DefaultItem, $GUI_CHECKED)
EndFunc   

Func SetDefaultMenuColors()
    _SetMenuBkColor (0xFFFFFF)
    _SetMenuIconBkColor (0xCACACA)
    _SetMenuSelectBkColor (0xE5A2A0)
    _SetMenuSelectRectColor (0x854240)
    _SetMenuSelectTextColor (0x000000)
    _SetMenuTextColor (0x000000)
EndFunc   

Func SetRedMenuColors()
    _SetMenuBkColor (0xAADDFF)
    _SetMenuIconBkColor (0x5566BB)
    _SetMenuSelectBkColor (0x70A0C0)
    _SetMenuSelectRectColor (0x854240)
    _SetMenuSelectTextColor (0x000000)
    _SetMenuTextColor (0x000000)
EndFunc  

Func SetGreenMenuColors()
    _SetMenuBkColor (0xAAFFAA)
    _SetMenuIconBkColor (0x66BB66)
    _SetMenuSelectBkColor (0xBBCC88)
    _SetMenuSelectRectColor (0x222277)
    _SetMenuSelectTextColor (0x770000)
    _SetMenuTextColor (0x000000)
EndFunc  

Func SetBlueMenuColors()
    _SetMenuBkColor (0xFFB8B8)
    _SetMenuIconBkColor (0xBB8877)
    _SetMenuSelectBkColor (0x662222)
    _SetMenuSelectRectColor (0x4477AA)
    _SetMenuSelectTextColor (0x66FFFF)
    _SetMenuTextColor (0x000000)
EndFunc
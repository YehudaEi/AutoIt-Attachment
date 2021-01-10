#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=sdf.ico
#AutoIt3Wrapper_outfile=C:\Documents and Settings\Nemanja\Desktop\SnM.exe
#AutoIt3Wrapper_Res_Comment=Simple n3 Manager
#AutoIt3Wrapper_Res_Description=Password manager
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=n3nE
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GUIListBox.au3>
#include <GuiComboBox.au3>
#include <String.au3>
#include <File.au3>
#include <EditConstants.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <ListBoxConstants.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
Opt("GUICloseOnESC", 0)
Opt("TrayAutoPause", 0)
Opt("TrayMenuMode", 1)

Local $guiname = "Simple n3 Manager"

$lngUsername = "Username:"
$lngPassword = "Password:"

If UBound(ProcessList(@ScriptName)) > 2 Then
	Local $hWnd = WinGetHandle($guiname)
	Local $sHWND = String($hWnd)
	WinSetState(HWnd($sHWND), "", @SW_SHOW)
	WinSetState(HWnd($sHWND), "", @SW_RESTORE)
	WinFlash(HWnd($sHWND), "", 2,100)
    Exit
EndIf

TraySetClick(16)
$min = 0
$unlocked = 0
Global $msg,$Show,$Quit,$min,$inifile,$username,$password,$encryptpw,$child1,$child2,$child3,$acclistname,$acclistpw
If FileExists(@SystemDir & "\snm") = 0 Then
	DirCreate(@SystemDir & "\snm")
EndIf

$pos1 = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\SnM\Settings", "PosX")
$pos2 = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\SnM\Settings", "PosY")
If $pos1 = "-32000" Or $pos1 = "" Then
	$pos1 = -1
	ElseIf $pos1 < 0 Then
	$pos1 = 0
	ElseIf $pos1 > @DesktopWidth-496 Then
	$pos1 = @DesktopWidth-496
EndIf
If $pos2 = "-32000" Or $pos2 = "" Then
	$pos2 = -1
	ElseIf $pos2 < 0 Then
	$pos2 = 0
ElseIf $pos2 > @DesktopHeight-327 Then
	$pos = WinGetPos("","start")
	$pos2 = @DesktopHeight-327-$pos[3]
EndIf

$gui = GUICreate($guiname, 490, 295, $pos1, $pos2)
$filemenu = GuiCtrlCreateMenu ("File")
$menuAdd = GuiCtrlCreateMenuitem ("Add	Alt+A",$filemenu)
$menuEdit = GuiCtrlCreateMenuitem ("Edit	Alt+E",$filemenu)
GUICtrlSetState($menuEdit,$GUI_DISABLE)
$menuDel = GuiCtrlCreateMenuitem ("Delete	Alt+D",$filemenu)
GUICtrlSetState($menuDel,$GUI_DISABLE)
GuiCtrlCreateMenuitem ("",$filemenu)
GuiCtrlCreateMenuitem ("Import...",$filemenu);not available yet:)
GUICtrlSetState(-1,$GUI_DISABLE)
GuiCtrlCreateMenuitem ("Export...",$filemenu);not available yet:)
GUICtrlSetState(-1,$GUI_DISABLE)
GuiCtrlCreateMenuitem ("",$filemenu)
$exit = GuiCtrlCreateMenuitem ("Exit	Alt+F4",$filemenu)
$accmenu = GuiCtrlCreateMenu ("A&ccounts")
$accitem = GuiCtrlCreateMenuitem ("Manage Accounts...",$accmenu)
$settmenu = GuiCtrlCreateMenu ("&Settings")
$sitem1 = GuiCtrlCreateMenuitem ("Always On Top	Ctrl+A",$settmenu)
$alwaysontop = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\SNP\Settings", "AlwaysOnTop")
If $alwaysontop = 1 Then
	WinSetOnTop($gui, "", 1)
	GUICtrlSetState($sitem1, $GUI_CHECKED)
EndIf
$sitem2 = GuiCtrlCreateMenuitem ("Start in Tray",$settmenu)
$sitem3 = GuiCtrlCreateMenuitem ("StartUp",$settmenu)
$helpmenu = GuiCtrlCreateMenu ("&Help")
$MenuAbout = GuiCtrlCreateMenuitem ("A&bout	F1",$helpmenu)
$search = GUICtrlCreateInput("", 235, 26, 237, 21)
$List1 = GUICtrlCreateList("", 8, 8, 210, 264, BitOR($LBS_SORT,$WS_VSCROLL))
GUICtrlSetTip(-1, "List of your entries")
_GUICtrlListBox_SetItemHeight($List1, 15)
_GUICtrlListBox_AddString($List1, "")
_GUICtrlListBox_DeleteString($List1, 0)
$Icon0 = GUICtrlCreateIcon("shell32.dll", -215, 452, 92, 16, 16)
GUICtrlSetCursor ($Icon0, 0)
GUICtrlSetTip($Icon0,"Go to Website")
$Icon1 = GUICtrlCreateIcon("shell32.dll", -135, 452, 120, 16, 16)
GUICtrlSetCursor ($Icon1, 0)
GUICtrlSetTip($Icon1,"Copy Username to Clipboard")
$Icon2 = GUICtrlCreateIcon("shell32.dll", -135, 452, 148, 16, 16)
GUICtrlSetCursor ($Icon2, 0)
GUICtrlSetTip($Icon2,"Copy Password to Clipboard")
$Icon3 = GUICtrlCreateIcon("shell32.dll", -222, 452, 176, 16, 16)
GUICtrlSetCursor ($Icon3, 0)
GUICtrlSetTip($Icon3,"Show info's in tray tip")
$web = GUICtrlCreateInput("", 297, 90, 173, 20, BitOR($ES_AUTOHSCROLL,$ES_READONLY,$WS_CLIPSIBLINGS))
$name = GUICtrlCreateInput("", 297, 118, 173, 20, BitOR($ES_AUTOHSCROLL,$ES_READONLY,$WS_CLIPSIBLINGS))
$pass = GUICtrlCreateInput("", 297, 146, 173, 20, BitOR($ES_AUTOHSCROLL,$ES_READONLY,$WS_CLIPSIBLINGS))
$info = GUICtrlCreateInput("", 297, 174, 173, 20, BitOR($ES_AUTOHSCROLL,$ES_READONLY,$WS_CLIPSIBLINGS))
$Button1 = GUICtrlCreateButton("&Add", 236, 236, 75, 23, 0)
GUICtrlSetTip(-1, "Add new entry")
$Button2 = GUICtrlCreateButton("&Edit", 316, 236, 75, 23, 0)
GUICtrlSetTip(-1, "Edit selected entry")
GUICtrlSetState($Button2,$gui_disable)
$Button3 = GUICtrlCreateButton("&Delete", 396, 236, 75, 23, 0)
GUICtrlSetTip(-1, "Delete selected entry")
GUICtrlSetState($Button3,$gui_disable)
$Group1 = GUICtrlCreateGroup("Search for entry (Total "& _GUICtrlListBox_GetCount($List1) &")", 225, 8, 257, 49)
$Group2 = GUICtrlCreateGroup("Informations about selected entry", 225, 68, 257, 139)
$Label0 = GUICtrlCreateLabel("Website:", 235, 93, 60, 17)
$Label1 = GUICtrlCreateLabel( $lngUsername, 235, 121, 60, 17)
$Label2 = GUICtrlCreateLabel( $lngPassword, 235, 149, 60, 17)
$Label3 = GUICtrlCreateLabel("Information:", 235, 177, 60, 17)
$Group3 = GUICtrlCreateGroup("Controls", 225, 218, 257, 49)
HotkeySet("{Del}", "msgbox_button")
	login()
	HotKeySet("^!p","check")
$old = ""
$old1 = ""
While 1
    If GuiCtrlRead($search) <> $old1 Then
		$FindEx = _GUICtrlListBox_FindInText($List1, GUICtrlRead($search))
        If $FindEx >= 0 Then
			_GUICtrlListBox_SetCurSel($List1, $FindEx)
        EndIf
        $old1 = GuiCtrlRead($search)
    EndIf
	$item = GUICtrlRead($web)
	If $item <> "" Then
        If BitAND(GUICtrlGetState($Button2), $GUI_DISABLE ) = $GUI_DISABLE Then
			GUICtrlSetState($Button2, $GUI_ENABLE)
			GUICtrlSetState($Button3, $GUI_ENABLE)
			GUICtrlSetState($menuEdit,$GUI_ENABLE)
			GUICtrlSetState($menuDel,$GUI_ENABLE)
		EndIf
	Else
		If BitAND(GUICtrlGetState($Button2), $GUI_ENABLE ) = $GUI_ENABLE Then
			GUICtrlSetState($Button2, $GUI_DISABLE)
			GUICtrlSetState($Button3, $GUI_DISABLE)
			GUICtrlSetState($menuEdit,$GUI_DISABLE)
			GUICtrlSetState($menuDel,$GUI_DISABLE)
		EndIf
    EndIf
	$current = _StringEncrypt(1,GUICtrlRead($List1),"snam",1)
	If $current <> $old Then
		$old = $current
		$1 = _StringEncrypt(0,Iniread($inifile,$current,"1",""),"snam",1)
		$2 = _StringEncrypt(0,Iniread($inifile,$current,"2",""),"snam",1)
		$3 = _StringEncrypt(0,Iniread($inifile,$current,"3",""),"snam",1)
		GUICtrlSetData($web,GUICtrlRead($List1))
		GUICtrlSetData($name,$1)
		GUICtrlSetData($pass,$2)
		GUICtrlSetData($info,$3)
	EndIf
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			_exit()
		Case $GUI_EVENT_MINIMIZE
		Guisetstate(@SW_MINIMIZE,$gui)
        Guisetstate(@SW_HIDE,$gui)
		$min = 1
		Case $exit
			_exit()
		Case $menuAdd
			add()
		Case $menuEdit
			edit()
		Case $menuDel
			msgbox_button()
		Case $sitem1
			If BitAND(GUICtrlRead($sitem1), $GUI_CHECKED) = $GUI_CHECKED Then
				WinSetOnTop($gui, "", 0)
				GUICtrlSetState($sitem1, $GUI_UNCHECKED)
				RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SnM\Settings\", "AlwaysOnTop", "REG_SZ", "0")
			Else
				WinSetOnTop($gui, "", 1)
				RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SnM\Settings\", "AlwaysOnTop", "REG_SZ", "1")
				GUICtrlSetState($sitem1, $GUI_CHECKED)
			EndIf
		Case $MenuAbout
			Msgbox(0,"About","..::SnM by n3nE::..")
		Case $Button1
			add()
		Case $Button2
			edit()
		Case $Button3
			msgbox_button()
		Case $Icon0
			$goto = GUICtrlRead($web)
			If $goto <> "" Then
			If StringLeft($goto, 5) = "http:" Then
				OnWWW($goto)
			Else
				OnWWW("http://"&$goto)
			EndIf
			EndIf
		Case $Icon1
			$CopyUsername = GUICtrlRead($name)
			If $CopyUsername <> "" Then
			ClipPut($CopyUsername)
			EndIf
		Case $Icon2
			$CopyPass = GUICtrlRead($pass)
			If $CopyPass <> "" Then
			ClipPut($CopyPass)
			EndIf
		Case $Icon3
			If GUICtrlRead($web) <> "" Then
				If GUICtrlRead($pass) <> "" Then
					ClipPut(GUICtrlRead($pass))
				EndIf
			TrayTip($guiname,"Website:	"& GUICtrlRead($web) &@CRLF& $lngUsername &"	"& GUICtrlRead($name) &@CRLF& $lngPassword & ":	*Copied To Clipboard*",5,1)
		EndIf
	EndSwitch
    $tMsg=TrayGetMsg()
	Switch $tMsg
    Case $Show
        _Hide_Show()
    Case $Quit
        _exit()
EndSwitch
WEnd

Func _IniGetSectionNames()
	$varx = IniReadSectionNames($inifile)
	If @error Then
		TrayTip($guiname, "You don't have added any entries!" &@CRLF& "Click the ""Add"" button for new entry", 5, 1)
	Else
		For $x = 1 To $varx[0]
		If @error Then
			TrayTip($guiname, "Your account file list is corrupted!", 5, 3)
		Else
			If $varx[$x] <> "Account" Then
			_GUICtrlListBox_AddString($List1, _StringEncrypt(0,$varx[$x],"snam",1))
			$loading = StringSplit(100/$varx[0]*(_GUICtrlListBox_GetCount($List1)+1), ".")
			;If $varx[0] > 10 Then
			TrayTip($guiname, "Loading. Please wait... " & $loading[1] & "% ("&_GUICtrlListBox_GetCount($List1) &"/"& $varx[0]-1 & ")", 5, 1)
			;EndIf
			EndIf
		EndIf
		Next
		TrayTip("", "", 1, 1)
		GUICtrlSetData($Group1,"Search for entry (Total "& _GUICtrlListBox_GetCount($List1) &")")
		If _GUICtrlListBox_GetCount($List1) = 0 Then
			TrayTip($guiname, "You don't have added any entries!" &@CRLF& "Click the ""Add"" button for new entry", 5, 1)
		EndIf
	EndIf
EndFunc   ;==>_IniGetSectionNames

Func add()
	Opt("GUICloseOnESC", 1)
	GUISetState(@SW_DISABLE, $gui)
	$child1 = GUICreate($guiname & " - Add", 277, 180, -1, -1, -1, $WS_EX_TOOLWINDOW, $gui)
	$nweb = GUICtrlCreateInput("", 82, 30, 173, 20)
	$nname = GUICtrlCreateInput("", 82, 58, 173, 20)
	$npass = GUICtrlCreateInput("", 82, 86, 173, 20)
	$ninfo = GUICtrlCreateInput("", 82, 114, 173, 20)
	$new = GUICtrlCreateButton("&OK",62,153,75,23, $BS_DEFPUSHBUTTON)
	$cancel = GUICtrlCreateButton("&Cancel",140,153,75,23)
	$Group2 = GUICtrlCreateGroup("Account Informations", 10, 8, 257, 139)
	$Label0 = GUICtrlCreateLabel("Website:", 18, 33, 60, 17)
	$Label1 = GUICtrlCreateLabel( $lngUsername, 18, 61, 60, 17)
	$Label2 = GUICtrlCreateLabel( $lngPassword, 18, 89, 60, 17)
	$Label3 = GUICtrlCreateLabel("Information:", 18, 117, 60, 17)
	GUISetState()
	Do
		$msg1 = GUIGetMsg()
			If $msg1 = $new Then
				If Guictrlread($nweb) = "" And Guictrlread($list1) = "" Then
					TrayTip($guiname,"Please enter website title!", 5,1)
				Else
					If GUICtrlRead($nweb) Then
                    $newitem = guictrlread($nweb)
                ElseIf guictrlread($List1) Then
                    $newitem = Guictrlread($List1)
                EndIf
                If _GUICtrlListBox_FindString($List1, $newitem, True) > -1 Then
                    TrayTip($guiname,"Already exists: " & $newitem, 5,1)
                Else
					$current = _StringEncrypt(1,$newitem,"snam",1)
					IniWrite($inifile,$current,"1",_StringEncrypt(1,GUICtrlRead($nname),"snam",1))
					IniWrite($inifile,$current,"2",_StringEncrypt(1,GUICtrlRead($npass),"snam",1))
					IniWrite($inifile,$current,"3",_StringEncrypt(1,GUICtrlRead($ninfo),"snam",1))
					_GUICtrlListBox_AddString($List1, $newitem)
					GUICtrlSetData($Group1,"Search for entry (Total "& _GUICtrlListBox_GetCount($List1) &")")
					_GUICtrlListBox_SetCurSel($List1, _GUICtrlListBox_FindString($List1, $newitem))
					ExitLoop
                EndIf
				EndIf
			EndIf
	Until $msg1 = $GUI_EVENT_CLOSE Or $msg1 = $cancel
		GUISetState(@SW_ENABLE, $gui)
		Opt("GUICloseOnESC", 0)
	GUIDelete($child1)
EndFunc   ;==>add

Func edit()
	Opt("GUICloseOnESC", 1)
	GUISetState(@SW_DISABLE, $gui)
	$child2 = GUICreate($guiname & " - Edit", 277, 180, -1, -1, -1, $WS_EX_TOOLWINDOW, $gui)
	$nweb = GUICtrlCreateInput(GUICtrlRead($web), 82, 30, 173, 20)
	$nname = GUICtrlCreateInput(GUICtrlRead($name), 82, 58, 173, 20)
	$npass = GUICtrlCreateInput(GUICtrlRead($pass), 82, 86, 173, 20)
	$ninfo = GUICtrlCreateInput(GUICtrlRead($info), 82, 114, 173, 20)
	$edit = GUICtrlCreateButton("&OK",62,153,75,23, $BS_DEFPUSHBUTTON)
	$cancel = GUICtrlCreateButton("&Cancel",140,153,75,23)
	$Group2 = GUICtrlCreateGroup("Account Informations", 10, 8, 257, 139)
	$Label0 = GUICtrlCreateLabel("Website:", 18, 33, 60, 17)
	$Label1 = GUICtrlCreateLabel( $lngUsername, 18, 61, 60, 17)
	$Label2 = GUICtrlCreateLabel( $lngPassword, 18, 89, 60, 17)
	$Label3 = GUICtrlCreateLabel("Information:", 18, 117, 60, 17)
	GUISetState()
	Do
		$msg1 = GUIGetMsg()
			If $msg1 = $edit Then
				If Guictrlread($nweb) = "" Then
					TrayTip($guiname,"Please enter website title!", 5,1)
				Else
					If GUICtrlRead($nweb) Then
						$newitem = guictrlread($nweb)
					ElseIf guictrlread($List1) Then
						$newitem = Guictrlread($List1)
					EndIf
				If _GUICtrlListBox_FindString($List1, $newitem, True) > -1 And $current = $newitem Then
					TrayTip($guiname,"Already exists: " & $newitem, 5,1)
				Else
					$current = _StringEncrypt(1,$newitem,"snam",1)
					IniRenameSection($inifile,$old,$current)
					IniWrite($inifile,$current,"1",_StringEncrypt(1,GUICtrlRead($nname),"snam",1))
					IniWrite($inifile,$current,"2",_StringEncrypt(1,GUICtrlRead($npass),"snam",1))
					IniWrite($inifile,$current,"3",_StringEncrypt(1,GUICtrlRead($ninfo),"snam",1))
				GUICtrlSetData($name,GUICtrlRead($nname))
				GUICtrlSetData($pass,GUICtrlRead($npass))
				GUICtrlSetData($info,GUICtrlRead($ninfo))
				_GUICtrlListBox_ReplaceString($List1,_GUICtrlListBox_GetCurSel($List1),$newitem)
				_GUICtrlListBox_Sort($list1)
				_GUICtrlListBox_SetCurSel($List1, _GUICtrlListBox_FindString($List1, $newitem))
				ExitLoop
			EndIf
			EndIf
			EndIf
	Until $msg1 = $GUI_EVENT_CLOSE Or $msg1 = $cancel
		GUISetState(@SW_ENABLE, $gui)
		Opt("GUICloseOnESC", 0)
		GUIDelete($child2)
EndFunc   ;==>edit

Func login()
	Opt("GUICloseOnESC", 1)
	$child3 = GUICreate($guiname & " - Login", 277, 152, -1, -1, BitOR($WS_CAPTION,$WS_POPUPWINDOW))
	TraySetState()
	TraySetToolTip($guiname &" - Login")
	$loginusername = GUICtrlCreateCombo("", 82, 30, 173, 20)
	GUICtrlSetTip($loginusername,"Choose your username here")
	$loginpw = GUICtrlCreateInput("", 82, 58, 173, 20, BitOR($ES_PASSWORD,$ES_AUTOHSCROLL))
	GUICtrlSetTip($loginpw,"Enter your password here")
	$deffacc = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\SnM\Settings", "DeffAcc")
	$Group2 = GUICtrlCreateGroup("Enter Login Informations", 10, 8, 257, 111)
	$lbl1 = GUICtrlCreateLabel( $lngUsername, 11, 33, 71, 15, $SS_CENTER)
	$lbl2 = GUICtrlCreateLabel( $lngPassword, 11, 61, 71, 15, $SS_CENTER)
	$Checkbox1 = GUICtrlCreateCheckbox("Save password and set as default", 50, 88, 180, 17)
	GUICtrlSetTip($Checkbox1,"Remember me on this computer")
	$login = GUICtrlCreateButton("&Login",62,125,75,23, $BS_DEFPUSHBUTTON)
	GUICtrlSetTip(-1, "Existing account login...")
	$create = GUICtrlCreateButton("&Create",140,125,75,23)
	GUICtrlSetTip(-1, "Create new account...")
	Dim $accountslist = _FileListToArray(@SystemDir & "\snm\","*.snm")
	If @error <> 0 Then
		TrayTip($guiname,"You don't have created accounts for login!"&@CRLF&"Click the ""Create"" button for new account.",5,1)
	Else
		For $x = 1 To $accountslist[0]
			$acclistname = StringReplace($accountslist[$x], ".snm", "")
			GUICtrlSetData($loginusername,$acclistname)
			If $acclistname = $deffacc Then
				_GUICtrlComboBox_SetCurSel($loginusername,$x-1)
				$acclistpw = _StringEncrypt(0,RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\SnM\Accounts", $acclistname),StringLeft($acclistname,1)&StringRight($acclistname,1),2)
				GUICtrlSetData($loginpw,$acclistpw)
				If $acclistpw = "" Then
					GUICtrlSetState($Checkbox1,$GUI_UNCHECKED)
				Else
					GUICtrlSetState($Checkbox1,$GUI_CHECKED)
				EndIf
			EndIf
		Next
	EndIf
	GUISetState()
	
	Do
		$msg2 = GUIGetMsg()
		If $msg2 = $loginusername Then
			$username = GUICtrlRead($loginusername)
			$acclistpw = _StringEncrypt(0,RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\SnM\Accounts", $username),StringLeft($username,1)&StringRight($username,1),2)
			If $acclistpw <> "" Then
				GUICtrlSetState($Checkbox1,$GUI_CHECKED)
				GUICtrlSetData($loginpw,$acclistpw)
			Else
				GUICtrlSetState($Checkbox1,$GUI_UNCHECKED)
				GUICtrlSetData($loginpw,"")
			EndIf
		EndIf
		If $msg2 = $create Then
			$username2 = Guictrlread($loginusername)
			$username = StringUpper(StringTrimRight($username2,StringLen($username2)-1)) & StringTrimLeft($username2,1)
			$password = Guictrlread($loginpw)
			$inifile = @SystemDir & "\snm\"& $username &".snm"
			$account = IniRead($inifile,"Account","1","")
			If $account <> "" Then
				TrayTip($guiname,"The Username you entered already exists!"&@CRLF&"Please type in another Username for new account.",5,2)
			Else
				If $username = "" Then
					TrayTip($guiname,"Please type in Username for your new account!",5,2)
				Else
					If StringLen($password) < 5 Then
						TrayTip($guiname,"Please type in Password with at least 5 characters!",5,2)
					Else
						GUICtrlSetData($loginusername, $username)
						;GUICtrlSetData($loginpw,"")
						$encryptpw = StringRight($password,3)
						IniWrite($inifile,"Account","1",_StringEncrypt(1,$password,$encryptpw,1))
						GUICtrlSetState($Checkbox1,$GUI_UNCHECKED)
						TrayTip($guiname,"Your new account is created!"&@CRLF&"Now you can login with your new Username.",5,1)
					EndIf
				EndIf
			EndIf
		EndIf
		If $msg2 = $login Then
			$username2 = Guictrlread($loginusername)
			$username = StringUpper(StringTrimRight($username2,StringLen($username2)-1)) & StringTrimLeft($username2,1)
			$password = Guictrlread($loginpw)
			If FileExists(@SystemDir & "\snm\"& $username &".snm") = 1 Then
				$inifile = @SystemDir & "\snm\"& $username &".snm"
				$encryptpw = StringRight($password,3)
				$account = _StringEncrypt(0,IniRead($inifile,"Account","1",""),$encryptpw,1)
				If $account = $password And $password <> "" Then
				$unlocked = 1
				$Show=TrayCreateItem("Show/Hide")
;~ 				TrayItemSetState(-1,$TRAY_DEFAULT)
				TrayCreateItem("")
				$Quit=TrayCreateItem("Quit")
				RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SnM\Settings\", "DeffAcc", "REG_SZ", $username)
				If GUICtrlRead($Checkbox1) = 1 Then
					RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SnM\Accounts", $username, "REG_SZ", _StringEncrypt(1,$password,StringLeft($username,1)&StringRight($username,1),2))
				Else
					RegDelete("HKEY_LOCAL_MACHINE\SOFTWARE\SnM\Accounts", $username)
				EndIf
				WinSetTitle($gui,"",$guiname &" - "& $username)
				TraySetToolTip($guiname &" - "& $username)
				ExitLoop
				Else
					TrayTip($guiname,"The Password you entered isn't correct." & @CRLF & "Please type in your Password again!",5,2)
				EndIf
			Else
				TrayTip($guiname,"The Username you entered doesn't exist!"&@CRLF&"Click the ""Create"" button for new account.",5,1)
			EndIf
		EndIf
	Until $msg2 = $GUI_EVENT_CLOSE
	If $unlocked = 1 Then
		GUICtrlSetData($login,"Logging In")
		GUICtrlSetState($login, $GUI_DISABLE)
		GUICtrlSetState($create, $GUI_DISABLE)
		GUICtrlSetState($loginusername, $GUI_DISABLE)
		GUICtrlSetState($loginpw, $GUI_DISABLE)
		GUICtrlSetState($lbl1, $GUI_DISABLE)
		GUICtrlSetState($lbl2, $GUI_DISABLE)
		GUICtrlSetState($Checkbox1, $GUI_DISABLE)
		_IniGetSectionNames()
		GUIDelete($child3)
		Opt("GUICloseOnESC", 0)
		GUISetState(@SW_SHOW, $gui)
	Else
		Exit
	EndIf
EndFunc

Func msgbox_button()
	if WinGetHandle(WinGetTitle("")) <> $gui Then
        hotkeyset("{DEL}")
        Send("{DEL}")
        HotKeySet("{DEL}","msgbox_button")
        Return
    EndIf
	If $msg = 0 Then
		$msg = 1
			If GUICtrlGetState($Button3) <> 144 Then
				If ControlGetFocus($gui) <> "Edit1" Then
				$Result = DllCall("user32.dll", _
				"int", "MessageBox", _
				"hwnd", $Gui, _
				"str", "This will remove selected entry unrecoverably!" & @CRLF & @CRLF & "Are you sure you want to delete selected entry?" , _
				"str","Delete Entry Confirmation", _
				"int",8228)
				Select
				Case $Result[0] = 6
					_GUICtrlListBox_DeleteString($List1, _GUICtrlListBox_GetCurSel($List1))
					IniDelete($inifile,$current)
					GUICtrlSetData($Group1,"Search for entry (Total "& _GUICtrlListBox_GetCount($List1) &")")
				EndSelect
				$msg = 0
				Else
				hotkeyset("{DEL}")
				Send("{DEL}")
				HotKeySet("{DEL}","msgbox_button")
				$msg = 0
				Return
				EndIf
			EndIf
			$msg = 0
	EndIf
EndFunc

Func _Hide_Show()
    If $min = 1 Then
        GUISetState(@SW_SHOW,$gui)
		;GUISetState(@SW_RESTORE,$gui)
        $min = 0
    Else
		;Guisetstate(@SW_MINIMIZE,$gui)
        Guisetstate(@SW_HIDE,$gui)
        $min = 1
    EndIf
EndFunc;==>Hide_Show

Func OnWWW($address)
    Run(@ComSpec & " /c " & 'start '& $address, "", @SW_HIDE)
EndFunc

Func check()
	$wtf2 = StringSplit(WinGetText("",""), " ")
		$wtf = StringReplace($wtf2[1], ":","")	   
		$src = _GUICtrlListBox_FindInText($List1, $wtf)
	If $src > -1 Then
		$current = _StringEncrypt(1,_GUICtrlListBox_GetText($List1,$src),$encryptpw,1)
		$founded = _GUICtrlListBox_GetText($List1,$src)
		_GUICtrlListBox_SetCurSel($list1,$src)
		TrayTip($guiname,"Website:	"& $founded &@CRLF& $lngUsername &"	" & _StringEncrypt(0,Iniread($inifile,$current,"1",""),$encryptpw,1) &@CRLF& $lngPassword & "	*Copied To Clipboard*",5,1)
		$foundedpw = _StringEncrypt(0,Iniread($inifile,$current,"2",""),$encryptpw,1)
		If $foundedpw <> "" Then
			ClipPut($foundedpw)
		EndIf
	EndIf
EndFunc

Func _exit()
		$wpm = WinGetPos($gui)
		RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SnM\Settings\", "PosX", "REG_SZ", $wpm[0])
		RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\SnM\Settings\", "PosY", "REG_SZ", $wpm[1])
		Exit
EndFunc
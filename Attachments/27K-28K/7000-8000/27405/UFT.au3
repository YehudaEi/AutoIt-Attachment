#include <D:\Project\#Include\IncludeAll.au3>
#NoTrayIcon

Opt ("TrayMenuMode",1)
Opt ("GUICloseOnESC",0)

Global Const $LangDir = @WorkingDir & "\Langs\"
Global Const $SkinDir = @WorkingDir & "\Skins\"
Global Const $CFG = @WorkingDir & "\Config.ini"
Global Const $FriendList = @WorkingDir & "\FriendList.ini"
Global Const $TITLE = "Ultimate File Transfer"
Global Const $UFT_SR = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\UFT_StartUp"

Local $Lang,$Skin,$Combo1,$StaticIP,$IP,$Port,$AStart,$ALogin,$AAccept,$Status,$pStatus,$lFriend,$Listener,$Connection,$FileName,$cName,$Target,$FSize,$State,$String
Local $FileP,$FILE,$Data,$FileProg,$TotalRead
Dim $Text[50]
Dim $Friend[100]

NullTextHandlers()
LoadConfig()
LoadText()

If WinExists($TITLE & " 1.0") Then
	MsgBox (48,$TITLE,$Text[32])
	Exit
EndIf

TraySetState ()
TraySetToolTip ($TITLE & " 1.0")
$T_Opt = TrayCreateItem ($Text[6])
$T_Send = TrayCreateItem ($Text[5])
$T_Status = TrayCreateMenu ($Text[26])
$T_On = TrayCreateItem ($Text[27],$T_Status)
$T_Off = TrayCreateItem ($Text[28],$T_Status)
$T_Exit = TrayCreateItem ($Text[4])

$Win1 = GUICreate ($TITLE & " 1.0",330,85,-1,-1,-1,$WS_EX_ACCEPTFILES)
GUISetBkColor (0x123456)

$Input1 = GUICtrlCreateInput ($Text[1],5,5,250,18)
GUICtrlSetBkColor (-1,0x123456)
GUICtrlSetColor (-1,0x00FFFF)
GUICtrlSetState (-1,$GUI_DROPACCEPTED)
$Label1 = GUICtrlCreateLabel ($Text[34],5,30,80,20,$SS_RIGHT+$BS_CENTER)
GUICtrlSetBkColor (-1,0x123456)
GUICtrlSetColor (-1,0x00FFFF)
$Combo3 = _GUICtrlComboBoxEx_Create ($Win1,$Text[33],90,30,150,200)
$Button6 = GUICtrlCreateLabel ($Text[35],245,30,80,20,$SS_CENTER+$BS_CENTER)
GUICtrlSetBkColor (-1,0x123456)
GUICtrlSetColor (-1,0xFFFF00)
GUICtrlSetFont (-1,10,400,2+4,"Arial")
GUICtrlSetCursor (-1,0)
$Button1 = GUICtrlCreateButton ($Text[2],260,5,65,18)
GUICtrlSetBkColor (-1,0x000000)
GUICtrlSetColor (-1,0x00FFFF)
$Button2 = GUICtrlCreateButton ($Text[3],5,55,80,30)
GUICtrlSetBkColor (-1,0x000000)
GUICtrlSetColor (-1,0x00FFFF)
$Progress1 = GUICtrlCreatePic ($Skin & "Progress.BIN",90,60,0,20)
$Progress2 = GUICtrlCreatePic ($Skin & "Progress2.BIN",90,60,235,20)

$Win2 = GUICreate ($Text[6],255,440,-1,-1,$WS_BORDER)
GUISetBkColor (0x123456)

$Group1 = GUICtrlCreateGroup ($Text[14],5,5,240,100,$SS_CENTER+$BS_CENTER)
GUICtrlSetColor (-1,0x00FFFF)
GUICtrlSetFont (-1,15,400,2,"Times New Roman")
$Label2 = GUICtrlCreateLabel ($Text[10],10,35,70,20,$SS_RIGHT+$BS_CENTER)
GUICtrlSetBkColor (-1,0x123456)
GUICtrlSetColor (-1,0x00FFFF)
$Combo1 = _GUICtrlComboBoxEx_Create ($Win2,"",85,35,150,200)
$Label3 = GUICtrlCreateLabel ($Text[8],10,65,70,20,$SS_RIGHT+$BS_CENTER)
GUICtrlSetBkColor (-1,0x123456)
GUICtrlSetColor (-1,0x00FFFF)
$Combo2 = _GUICtrlComboBoxEx_Create ($Win2,"",85,65,150,200)

$Group2 = GUICtrlCreateGroup ($Text[15],5,120,240,85,$SS_CENTER+$BS_CENTER)
GUICtrlSetColor (-1,0x00FFFF)
GUICtrlSetFont (-1,15,400,2,"Times New Roman")
$Label4 = GUICtrlCreateLabel ($Text[11],30,145,200,20,$BS_CENTER)
GUICtrlSetBkColor (-1,0x123456)
GUICtrlSetColor (-1,0x00FFFF)
$Box1 = GUICtrlCreateLabel ("X",12,148,15,15,$SS_CENTER+$BS_CENTER)
GUICtrlSetBkColor (-1,0x123456)
GUICtrlSetFont (-1,8,400,1,"Arial Black")
$Input2 = GUICtrlCreateInput ($IP,35,170,100,20,$SS_CENTER+$BS_CENTER)
GUICtrlSetBkColor (-1,0x123456)
GUICtrlSetColor (-1,0x00FFFF)
$Input3 = GUICtrlCreateInput ($Port,185,170,50,20,$SS_CENTER+$BS_CENTER)
GUICtrlSetBkColor (-1,0x123456)
GUICtrlSetColor (-1,0x00FFFF)
$Label5 = GUICtrlCreateLabel ($Text[12],8,170,20,20,$SS_RIGHT+$BS_CENTER)
GUICtrlSetBkColor (-1,0x123456)
GUICtrlSetColor (-1,0x00FFFF)
$Label6 = GUICtrlCreateLabel ($Text[13],140,170,35,20,$SS_RIGHT+$BS_CENTER)
GUICtrlSetBkColor (-1,0x123456)
GUICtrlSetColor (-1,0x00FFFF)

$Group3 = GUICtrlCreateGroup ($Text[16],5,220,240,85,$SS_CENTER+$BS_CENTER)
GUICtrlSetColor (-1,0x00FFFF)
GUICtrlSetFont (-1,15,400,2,"Times New Roman")
$Box2 = GUICtrlCreateLabel ("X",12,248,15,15,$SS_CENTER+$BS_CENTER)
GUICtrlSetBkColor (-1,0x123456)
GUICtrlSetFont (-1,8,400,1,"Arial Black")
$Label7 = GUICtrlCreateLabel ($Text[17],30,245,200,20,$BS_CENTER)
GUICtrlSetBkColor (-1,0x123456)
GUICtrlSetColor (-1,0x00FFFF)
$Box3 = GUICtrlCreateLabel ("X",12,273,15,15,$SS_CENTER+$BS_CENTER)
GUICtrlSetBkColor (-1,0x123456)
GUICtrlSetFont (-1,8,400,1,"Arial Black")
$Label8 = GUICtrlCreateLabel ($Text[18],30,270,200,20,$BS_CENTER)
GUICtrlSetBkColor (-1,0x123456)
GUICtrlSetColor (-1,0x00FFFF)
$Group4 = GUICtrlCreateGroup ($Text[19],5,320,240,50,$SS_CENTER+$BS_CENTER)
GUICtrlSetColor (-1,0x00FFFF)
GUICtrlSetFont (-1,15,400,2,"Times New Roman")
$Box4 = GUICtrlCreateLabel ("X",12,345,15,15,$SS_CENTER+$BS_CENTER)
GUICtrlSetBkColor (-1,0x123456)
GUICtrlSetFont (-1,8,400,1,"Arial Black")
$Label9 = GUICtrlCreateLabel ($Text[20],30,342,200,20,$BS_CENTER)
GUICtrlSetBkColor (-1,0x123456)
GUICtrlSetColor (-1,0x00FFFF)
$Button3 = GUICtrlCreateButton ($Text[21],5,380,80,25)
GUICtrlSetBkColor (-1,0x123456)
GUICtrlSetColor (-1,0x00FF00)
GUICtrlSetFont (-1,10)
$Button4 = GUICtrlCreateButton ($Text[22],85,380,80,25)
GUICtrlSetBkColor (-1,0x123456)
GUICtrlSetColor (-1,0x00FF00)
GUICtrlSetFont (-1,10)
$Button5 = GUICtrlCreateButton ($Text[23],165,380,80,25)
GUICtrlSetBkColor (-1,0x123456)
GUICtrlSetColor (-1,0x00FF00)
GUICtrlSetFont (-1,10)

$Win3 = GUICreate ($Text[35],200,180,-1,-1,$WS_BORDER)

$Input4 = GUICtrlCreateInput ($Text[36],5,5,185,20)
$Input5 = GUICtrlCreateInput ($Text[12],5,30,120,20)
$Input6 = GUICtrlCreateInput ($Text[13],130,30,60,20)
$Button7 = GUICtrlCreateButton ($Text[37],5,60,185,40)
$Button8 = GUICtrlCreateButton ($Text[38],50,110,100,30)

$Win4 = GUICreate ($Text[44],315,85,-1,-1,$WS_BORDER)
$Progress3 = GUICtrlCreatePic ($Skin & "Progress.BIN",5,5,0,20)
$Progress4 = GUICtrlCreatePic ($Skin & "Progress2.BIN",5,5,300,20)
$label10 = GUICtrlCreateLabel ($Text[45],5,30,300,20,$SS_CENTER+$BS_CENTER)

LoadSkins()
LoadLangs()
LoadFriends()
LoadOthers()

GUISetState (@SW_SHOW,$Win1)
$Status = "Offline"
If $ALogin = "True" Then
	TCPLogin()
Else
	TrayItemSetState ($T_Off,$TRAY_CHECKED)
	TraySetIcon ($Skin & "TrayOff.BIN")
	TraySetToolTip ($TITLE & " 1.0" & @CRLF & $Text[32])
EndIf

While 1
	$msg = GUIGetMsg ()
	$msg2 = TrayGetMsg()
	SystemMessage()
	If $Status = "Online" Then
		If $Connection = -1 Then
			$Connection = TCPAccept ($Listener)
		EndIf
		TCPServer()
	EndIf
WEnd

Func LoadConfig()
	$Read = FileReadLine ($CFG,1)
	$String = StringReplace ($Read,"Lang=","",1)
	$Lang = $LangDir & $String & ".BIN"
	$Read = FileReadLine ($CFG,2)
	$String = StringReplace ($Read,"Skin=","",1)
	$Skin = $SkinDir & $String & "\"
	$Read = FileReadLine ($CFG,3)
	$String = StringReplace ($Read,"UseStaticIP=","",1)
	$StaticIP = $String
	$Read = FileReadLine ($CFG,4)
	$String = StringReplace ($Read,"IP=","",1)
	$IP = $String
	$Read = FileReadLine ($CFG,5)
	$String = StringReplace ($Read,"Port=","",1)
	$Port = $String
	$Read = FileReadLine ($CFG,6)
	$String = StringReplace ($Read,"RunAfterStartUp=","",1)
	$AStart = $String
	$Read = FileReadLine ($CFG,7)
	$String = StringReplace ($Read,"LoginAfterStartUp=","",1)
	$ALogin = $String
	$Read = FileReadLine ($CFG,8)
	$String = StringReplace ($Read,"AutoAcceptFiles=","",1)
	$AAccept = $String
	$Read = FileReadLine ($CFG,9)
	$String = StringReplace ($Read,"LastSelectedFriend=","",1)
	$lFriend = $String
	If $StaticIP = "False" Then
		$IP = @IPAddress1
	EndIf
EndFunc

Func LoadText()
	For $x = 1 To 49
		$Read = FileReadLine ($Lang,$x)
		$String = StringReplace ($Read,"Text[" & $x & "]=","",1)
		$String = StringReplace ($String,"%TITLE%",$TITLE)
		$String = StringReplace ($String,"/@/",@CRLF)
		$String = StringReplace ($String,"%IP%",$IP)
		$String = StringReplace ($String,"%PORT%",$Port)
		$String = StringReplace ($String,"%CONNECTION%",$cName)
		$String = StringReplace ($String,"%FILE%",$FileName)
		$String = StringReplace ($String,"%SIZE%",$FSize)
		$Text[$x] = $String
	Next
EndFunc

Func LoadSkins()
	If FileFindFirstFile ($SkinDir & "*") = -1 Then
		MsgBox (16,$TITLE,$Text[9])
		Exit
	Else
		$Skins = _FileListToArray ($SkinDir)
		_GUICtrlComboBoxEx_BeginUpdate ($Combo2)
		For $x = 1 To $Skins[0]
			If StringInStr ($Skins,".") = 0 Then
				_GUICtrlComboBoxEx_AddString($Combo2,$Skins[$x])
			EndIf
		Next
		_GUICtrlComboBoxEx_EndUpdate($Combo2)
	EndIf
EndFunc

Func LoadLangs()
	If FileFindFirstFile ($LangDir & "*.BIN") = -1 Then
		MsgBox (16,$TITLE,"Unable to locate any language file ! " & @CRLF & $TITLE & " will now exit..." & @CRLF & "You can fix this problem by reinstalling program.")
		Exit
	Else
		$Langs = _FileListToArray ($LangDir)
		_GUICtrlComboBoxEx_BeginUpdate ($Combo1)
		For $x = 1 To $Langs[0]
			$String = StringReplace ($Langs[$x],".BIN","",1)
			_GUICtrlComboBoxEx_AddString($Combo1,$String)
		Next
		_GUICtrlComboBoxEx_EndUpdate($Combo1)
	EndIf
EndFunc

Func LoadFriends()
	If FileReadLine ($FriendList,1) <> "" Then
		_GUICtrlComboBoxEx_ResetContent ($Combo3)
	EndIf
	For $x = 1 To 99
		$Read = FileReadLine ($FriendList,$x)
		If $Read <> "" Then
			$Friend[$x] = $Read
			$String = StringSplit ($Friend[$x],"<->",1)
			_GUICtrlComboBoxEx_AddString ($Combo3,$String[1])
		EndIf
	Next
EndFunc

Func LoadOthers()
	If $StaticIP = "True" Then
		GUICtrlSetColor ($Box1,0x00FF00)
	Else
		GUICtrlSetState ($Input2,$GUI_DISABLE)
		GUICtrlSetColor ($Box1,0xFF0000)
	EndIf
	If $AStart = "True" Then
		GUICtrlSetColor ($Box2,0x00FF00)
	Else
		GUICtrlSetColor ($Box2,0xFF0000)
	EndIf
	If $ALogin = "True" Then
		GUICtrlSetColor ($Box3,0x00FF00)
	Else
		GUICtrlSetColor ($Box3,0xFF0000)
	EndIf
	If $AAccept = "True" Then
		GUICtrlSetColor ($Box4,0x00FF00)
	Else
		GUICtrlSetColor ($Box4,0xFF0000)
	EndIf
	$String = StringReplace(FileReadLine($CFG,1),"Lang=","",1)
	_GUICtrlEdit_SetText ($Combo1,$String)
	$String = StringReplace(FileReadLine($CFG,2),"Skin=","",1)
	_GUICtrlEdit_SetText ($Combo2,$String)
	_GUICtrlEdit_SetText ($Combo3,$lFriend)
EndFunc

Func SaveConfig()
	TCPOff()
	_FileWriteToLine ($CFG,1,"Lang=" & _GUICtrlEdit_GetText ($Combo1),1)
	_FileWriteToLine ($CFG,2,"Skin=" & _GUICtrlEdit_GetText ($Combo2),1)
	_FileWriteToLine ($CFG,3,"UseStaticIP=" & $StaticIP,1)
	_FileWriteToLine ($CFG,4,"IP=" & GUICtrlRead ($Input2),1)
	_FileWriteToLine ($CFG,5,"Port=" & GUICtrlRead ($Input3),1)
	_FileWriteToLine ($CFG,6,"RunAfterStartUp=" & $AStart,1)
	_FileWriteToLine ($CFG,7,"LoginAfterStartUp=" & $ALogin,1)
	_FileWriteToLine ($CFG,8,"AutoAcceptFiles=" & $AAccept,1)
	If $AStart = "True" Then
		RegWrite ($UFT_SR,"MainProgram","REG_MULTI_SZ",@WorkingDir & "\UFT.exe")
	Else
		RegDelete ($UFT_SR)
	EndIf
	Reload()
	If $pStatus = "Online" Then
		TCPLogin()
	Else
		TraySetIcon ($Skin & "TrayOff")
	EndIf
	$Port = GUICtrlRead ($Input3)
EndFunc

Func TCPLogin()
	TCPStartup ()
	$Listener = TCPListen ($IP,$Port)
	If $Listener = -1 Then
		MsgBox (16,$TITLE,$Text[29])
		$Status = "Offline"
		TCPShutdown()
		TrayItemSetState ($T_On,$TRAY_UNCHECKED)
		TrayItemSetState ($T_Off,$TRAY_CHECKED)
		TraySetIcon ($Skin & "TrayOff.BIN")
		TraySetToolTip ($TITLE & " 1.0" & @CRLF & $Text[31])
	Else
		$Status = "Online"
		TrayItemSetState ($T_On,$TRAY_CHECKED)
		TrayItemSetState ($T_Off,$TRAY_UNCHECKED)
		TraySetIcon ($Skin & "TrayOn.BIN")
		TraySetToolTip ($TITLE & " 1.0" & @CRLF & $Text[30])
		$Connection = -1
	EndIf
EndFunc

Func TCPOff()
	$Connection = -1
	$Status = "Offline"
	TCPShutdown()
	TrayItemSetState ($T_On,$TRAY_UNCHECKED)
	TrayItemSetState ($T_Off,$TRAY_CHECKED)
	TraySetIcon ($Skin & "TrayOff.BIN")
	TraySetToolTip ($TITLE & " 1.0" & @CRLF & $Text[31])
EndFunc

Func TCPServer()
	If $Connection <> -1 Then
		$Packet = TCPRecv ($Connection,10 * 1024 * 1024)
		$p_ConnReq = StringRegExp ($Packet,"UFT_NEW_CONNECTION->")
		$p_aFile = StringRegExp ($Packet,"UFT_FILE_ACCEPTED")
		$p_dFile = StringRegExp ($Packet,"UFT_FILE_NOT_ACCEPTED")
		$p_tFile = StringRegExp ($Packet,"UFT_CONNECTION_TERMINATE")
		$p_sFile = StringRegExp ($Packet,"UFT_FILE_SIZE->")
		If $p_ConnReq = True Then
			$String1 = StringSplit ($Packet,"->",1)
			$FileName = $String1[3] & $String1[4]
			If $AAccept = "False" Then
				$cName = $String1[2]
				WinMinimizeAll()
				Sleep (500)
				For $x = 1 To 99
					$String2 = StringSplit ($Friend[$x],"<->",1)
					If $Friend[$x] <> "" Then
						If $String1[2] = $String2[2] Then
							$cName = $String2[1]
						EndIf
					EndIf
				Next
				LoadText()
				If MsgBox (4+64,$TITLE,$Text[40]) = 6 Then
					$FileP = FileSaveDialog ($TITLE,"","(*.*)",16,$FileName)
					If $FileP = True Then
						Dim $szDrive,$szDir,$szFName,$szExt
						$FileP = _PathSplit ($FileP,$szDrive,$szDir,$szFName,$szExt)
						$FileP = $FileP[2]
						TCPSend ($Connection,"UFT_FILE_ACCEPTED")
					Else
						TCPSend ($Connection,"UFT_FILE_NOT_ACCEPTED")
						TCPCloseSocket ($Connection)
						$Connection = -1
						NullTextHandlers()
						LoadText()
					EndIf
				Else
					TCPSend ($Connection,"UFT_FILE_NOT_ACCEPTED")
					TCPCloseSocket ($Connection)
					$Connection = -1
					NullTextHandlers()
					LoadText()
				EndIf
			Else
				$cName = $String1[2]
				For $x = 1 To 99
					$String2 = StringSplit ($Friend[$x],"<->",1)
					If $Friend[$x] <> "" Then
						If $String1[2] = $String2[2] Then
							$cName = $String2[1]
						EndIf
					EndIf
				Next
				TCPSend ($Connection,"UFT_FILE_ACCEPTED")
				$FileP = @DesktopDir & "\"
			EndIf
		EndIf
		If $p_aFile = True Then
			TCPSend ($Connection,"UFT_FILE_SIZE->" & $FSize)
			InitializeTransfer()
			FileReader()
		EndIf
		If $p_dFile = True Then
			TraySetToolTip ($TITLE & " 1.0" & @CRLF & $Text[30])
			MsgBox (48,$TITLE,$Text[43])
			TCPCloseSocket ($Connection)
			$Connection = -1
			GUICtrlSetState ($Input1,$GUI_ENABLE)
			GUICtrlSetState ($Button1,$GUI_ENABLE)
			GUICtrlSetState ($Button2,$GUI_ENABLE)
			GUICtrlSetState ($Combo3,$GUI_ENABLE)
			GUICtrlSetState ($Button6,$GUI_ENABLE)
		EndIf
		If $p_tFile = True Then
			TCPCloseSocket ($Connection)
			$Connection = -1
			MsgBox (16,$TITLE,$Text[47],0,$Win4)
			Terminate()
		EndIf
		If $p_sFile = True Then
			$FSize = StringReplace ($Packet,"UFT_FILE_SIZE->","",1)
			InitializeTransfer()
			FileWriter()
		EndIf
	EndIf
EndFunc

Func Reload()
	LoadConfig()
	LoadText()
	TraySetIcon ($Skin & "TrayOff")
	GUICtrlSetData ($Button1,$Text[2])
	GUICtrlSetData ($Button2,$Text[3])
	GUICtrlSetData ($Button3,$Text[21])
	GUICtrlSetData ($Button4,$Text[22])
	GUICtrlSetData ($Button5,$Text[23])
	GUICtrlSetData ($Button6,$Text[35])
	GUICtrlSetData ($Button7,$Text[37])
	GUICtrlSetData ($Button8,$Text[38])
	GUICtrlSetData ($Input1,$Text[1])
	GUICtrlSetData ($Label1,$Text[34])
	GUICtrlSetData ($Label2,$Text[10])
	GUICtrlSetData ($Label3,$Text[8])
	GUICtrlSetData ($Label4,$Text[11])
	GUICtrlSetData ($Label5,$Text[12])
	GUICtrlSetData ($Label6,$Text[13])
	GUICtrlSetData ($Label7,$Text[17])
	GUICtrlSetData ($Label8,$Text[18])
	GUICtrlSetData ($Label9,$Text[20])
	GUICtrlSetData ($Label10,$Text[45])
	GUICtrlSetData ($Group1,$Text[14])
	GUICtrlSetData ($Group2,$Text[15])
	GUICtrlSetData ($Group3,$Text[16])
	GUICtrlSetData ($Group4,$Text[19])
	GUICtrlSetData ($Input4,$Text[36])
	GUICtrlSetData ($Input5,$Text[12])
	GUICtrlSetData ($Input6,$Text[13])
	TrayItemSetText ($T_Opt,$Text[6])
	TrayItemSetText ($T_Send,$Text[5])
	TrayItemSetText ($T_Status,$Text[26])
	TrayItemSetText ($T_On,$Text[27])
	TrayItemSetText ($T_Off,$Text[28])
	TrayItemSetText ($T_Exit,$Text[4])
	WinSetTitle ($Win2,"",$Text[6])
	WinSetTitle ($Win3,"",$Text[35])
	WinSetTitle ($Win4,"",$Text[44])	
	LoadOthers()
EndFunc

Func SystemMessage()
		Select
	Case $msg = $GUI_EVENT_CLOSE
		GUISetState (@SW_HIDE,$Win1)
	Case $msg = $GUI_DROPACCEPTED
		GUICtrlSetData ($Input1,"")
	Case $msg2 = $T_Exit
		If MsgBox (4+32,$TITLE,$Text[7]) = 6 Then
			TCPOff()
			$lFriend = _GUICtrlEdit_GetText ($Combo3)
			If $lFriend = $Text[33] Then
				$lFriend = ""
			EndIf
			_FileWriteToLine ($CFG,9,"LastSelectedFriend=" & $lFriend,1)
			Exit
		EndIf
	Case $msg2 = $T_Send
		GUICtrlSetData ($Input1,$Text[1])
		LoadFriends()
		LoadConfig()
		GUISetState (@SW_SHOW,$Win1)
		GUISetState (@SW_RESTORE,$Win1)
	Case $msg2 = $T_Opt
		LoadConfig()
		LoadOthers()
		GUISetState (@SW_HIDE,$Win1)
		GUISetState (@SW_SHOW,$Win2)
		GUISetState (@SW_RESTORE,$Win2)
		TrayItemSetState ($T_Send,$GUI_DISABLE)
	Case $msg = $Box1
		If $StaticIP = "True" Then
			$StaticIP = "False"
			GUICtrlSetState ($Input2,$GUI_DISABLE)
			GUICtrlSetColor ($Box1,0xFF0000)
			$IP = @IPAddress1
		Else
			$StaticIP = "True"
			GUICtrlSetState ($Input2,$GUI_ENABLE)
			GUICtrlSetColor ($Box1,0x00FF00)
			$IP = GUICtrlRead ($Input2)
		EndIf
	Case $msg = $Box2
		If $AStart = "True" Then
			$AStart = "False"
			GUICtrlSetColor ($Box2,0xFF0000)
		Else
			$AStart = "True"
			GUICtrlSetColor ($Box2,0x00FF00)
		EndIf
	Case $msg = $Box3
		If $ALogin = "True" Then
			$ALogin = "False"
			GUICtrlSetColor ($Box3,0xFF0000)
		Else
			$ALogin = "True"
			GUICtrlSetColor ($Box3,0x00FF00)
		EndIf
	Case $msg = $Box4
		If $AAccept = "True" Then
			$AAccept = "False"
			GUICtrlSetColor ($Box4,0xFF0000)
		Else
			$AAccept = "True"
			GUICtrlSetColor ($Box4,0x00FF00)
		EndIf
	Case $msg = $Button4
		GUISetState (@SW_HIDE,$Win2)
		TrayItemSetState ($T_Send,$GUI_ENABLE)
	Case $msg = $Button3
		$pStatus = $Status
		$Error = "False"
		If FileFindFirstFile ($LangDir & _GUICtrlEdit_GetText ($Combo1) & ".BIN") = -1 Then
			MsgBox (16,$TITLE,$Text[24],0,$Win2)
			$Error = "True"
		EndIf
		If FileFindFirstFile ($SkinDir & _GUICtrlEdit_GetText ($Combo2)) = -1 Then
			MsgBox (16,$TITLE,$Text[25],0,$Win2)
			$Error = "True"
		EndIf
		If $Error = "False" Then
			SaveConfig()
			GUISetState (@SW_HIDE,$Win2)
			TrayItemSetState ($T_Send,$GUI_ENABLE)
		EndIf
	Case $msg = $Button5
		$pStatus = $Status
		$Error = "False"
		If FileFindFirstFile ($LangDir & _GUICtrlEdit_GetText ($Combo1) & ".BIN") = -1 Then
			MsgBox (16,$TITLE,$Text[24],0,$Win2)
			$Error = "True"
		EndIf
		If FileFindFirstFile ($SkinDir & _GUICtrlEdit_GetText ($Combo2)) = -1 Then
			MsgBox (16,$TITLE,$Text[25],0,$Win2)
			$Error = "True"
		EndIf
		If $Error = "False" Then
			SaveConfig()
		EndIf
	Case $msg2 = $T_On
		TCPLogin()
	Case $msg2 = $T_Off
		TCPOff()
	Case $msg = $Button6
		GUISetState (@SW_HIDE,$Win1)
		GUISetState (@SW_SHOW,$Win3)
		TrayItemSetState ($T_Opt,$GUI_DISABLE)
		TrayItemSetState ($T_Send,$GUI_DISABLE)
	Case $msg = $Button1
		$FileP = FileOpenDialog ($TITLE,"","ALL FILES (*.*)",1,"",$Win1)
		If $FileP = True Then
			GUICtrlSetData ($Input1,$FileP)
			FileChangeDir (@ScriptDir)
		EndIf
	Case $msg = $Button2
		If FileFindFirstFile (GUICtrlRead($Input1)) = -1 Then
			MsgBox (16,$TITLE,$Text[41],0,$Win1)
		Else
			Dim $szDrive,$szDir,$szFName,$szExt
			$FileName = _PathSplit (GUICtrlRead($Input1),$szDrive,$szDir,$szFName,$szExt)
			$FSize = FileGetSize (GUICtrlRead($Input1))
			If $Status = "Offline" Then
				TCPLogin()
			EndIf
			If _GUICtrlEdit_GetText ($Combo3) <> $Text[33] Then
				$Target = GUICtrlRead ($Combo3)
				$Target = $Target + 1
				TCPClient()
			EndIf
		EndIf
	Case $msg = $Button7
		If StringInStr (GuiCtrlRead($Input1),"<->") = True Then
			MsgBox (48,"Ultimate File Transfer",$Text[39],0,$Win3)
		Else
			_FileWriteToLine (@WorkingDir & "\FriendList.ini",1,GUICtrlRead($Input4) & "<->" & GUICtrlRead($Input5) & "<->" & GUICtrlRead ($Input6),0)
		EndIf
		LoadFriends()
		_GUICtrlEdit_SetText ($Combo3,GUICtrlRead($Input4))
		GUISetState (@SW_SHOW,$Win1)
		GUISetState (@SW_HIDE,$Win3)
		TrayItemSetState ($T_Opt,$GUI_ENABLE)
		TrayItemSetState ($T_Send,$GUI_ENABLE)
	Case $msg = $Button8
		GUISetState (@SW_SHOW,$Win1)
		GUISetState (@SW_HIDE,$Win3)
		TrayItemSetState ($T_Opt,$GUI_ENABLE)
		TrayItemSetState ($T_Send,$GUI_ENABLE)
	EndSelect
EndFunc

Func TCPClient()
	$String = StringSplit ($Friend[$Target],"<->",1)
	$Connection = TCPConnect ($String[2],$String[3])
	If $Connection = -1 Then
		MsgBox (16,$TITLE,$Text[42],0,$Win1)
	Else
		TCPSend ($Connection,"UFT_NEW_CONNECTION->" & $IP & "->" & $FileName[3] & "->" & $FileName[4])
		GUICtrlSetState ($Input1,$GUI_DISABLE)
		GUICtrlSetState ($Button1,$GUI_DISABLE)
		GUICtrlSetState ($Button2,$GUI_DISABLE)
		GUICtrlSetState ($Combo3,$GUI_DISABLE)
		GUICtrlSetState ($Button6,$GUI_DISABLE)
		$FileName = $FileName[3] & $FileName[4]
		$cName = $String[1]
		$FSize = FileGetSize (GUICtrlRead($Input1)) /1024
		$FSize = Int ($FSize)
		LoadText()
		TraySetToolTip ($TITLE & " 1.0" & @CRLF & $Text[48])
	EndIf
EndFunc

Func Terminate()
	$State = "StopWrite"
	TrayItemSetState ($T_Opt,$GUI_ENABLE)
	TrayItemSetState ($T_Send,$GUI_ENABLE)
	TrayItemSetState ($T_Status,$GUI_ENABLE)
	TrayItemSetState ($T_Exit,$GUI_ENABLE)
	GUICtrlSetState ($Input1,$GUI_ENABLE)
	GUICtrlSetState ($Button1,$GUI_ENABLE)
	GUICtrlSetState ($Button2,$GUI_ENABLE)
	GUICtrlSetState ($Combo3,$GUI_ENABLE)
	GUICtrlSetState ($Button6,$GUI_ENABLE)
	TraySetIcon ($Skin & "TrayOn.BIN")
	TraySetToolTip ($TITLE & " 1.0" & @CRLF & $Text[30])
	TCPSend ($Connection,"UFT_CONNECTION_TERMINATE")
	GUISetState (@SW_HIDE,$Win4)
	FileClose ($FILE)
	HotKeySet ("{ESC}")
EndFunc

Func InitializeTransfer()
	$State = "Write"
	LoadText()
	HotKeySet ("{ESC}","Terminate")
	TrayItemSetState ($T_Opt,$GUI_DISABLE)
	TrayItemSetState ($T_Send,$GUI_DISABLE)
	TrayItemSetState ($T_Status,$GUI_DISABLE)
	TrayItemSetState ($T_Exit,$GUI_DISABLE)
	TraySetIcon ($Skin & "TrayProg.BIN")
	TraySetToolTip ($TITLE & " 1.0" & @CRLF & $Text[46])
	GUISetState (@SW_HIDE,$Win1)
	GUISetState (@SW_HIDE,$Win2)
	GUISetState (@SW_HIDE,$Win3)
	$FileProg = Int ($FSize /100 * 2)
	$TotalRead = 0
EndFunc

Func FileReader()
	GUISetState (@SW_SHOW,$Win1)
	$FILE = FileOpen ($FileName,16)
	While $State = "Write"
		$Data = FileRead ($FILE,10 * 1024 * 1024)
		If @error Then EndTransfer()
		TCPSend ($Connection,$Data)
		;$TotalRead = $TotalRead + 1024
		;$pos = ControlGetPos ($Win1,"",$Progress2)
		;GUICtrlSetPos ($Progress1,$pos[0],$pos[1],$pos[2] + Int($TotalRead / $FileProg))
		;$pos = ControlGetPos ($Win1,"",$Progress1)
		;GUICtrlSetPos ($Progress1,$pos[0],$pos[1],$pos[2] - Int($TotalRead / $FileProg))
	WEnd
EndFunc

Func FileWriter()
	GUISetState (@SW_SHOW,$Win4)
	If FileExists ($FileP & $FileName) Then
		FileDelete ($FileP & $FileName)
	EndIf
	$FILE = FileOpen ($FileP & $FileName,2 + 8 + 16)
	While $State = "Write"
		$Data = TCPRecv ($Connection,10 * 1024 * 1024,1)
		If @error Then EndTransfer()
		FileWrite ($FILE,$Data)
	WEnd
EndFunc

Func EndTransfer()
	TCPCloseSocket ($Connection)
	$Connection = -1
	$State = "StopWrite"
	FileClose ($FILE)
	GUISetState (@SW_HIDE,$Win4)
	TrayItemSetState ($T_Opt,$GUI_ENABLE)
	TrayItemSetState ($T_Send,$GUI_ENABLE)
	TrayItemSetState ($T_Status,$GUI_ENABLE)
	TrayItemSetState ($T_Exit,$GUI_ENABLE)
	GUICtrlSetState ($Input1,$GUI_ENABLE)
	GUICtrlSetState ($Button1,$GUI_ENABLE)
	GUICtrlSetState ($Button2,$GUI_ENABLE)
	GUICtrlSetState ($Combo3,$GUI_ENABLE)
	GUICtrlSetState ($Button6,$GUI_ENABLE)
	TraySetIcon ($Skin & "TrayOn.BIN")
	TraySetToolTip ($TITLE & " 1.0" & @CRLF & $Text[30])
	GUICtrlSetData ($Input1,$Text[1])
	NullTextHandlers()
	MsgBox (64,$TITLE,$Text[49])
EndFunc

Func NullTextHandlers()
	$FileName = "?"
	$cName = "?"
	$FSize = "?"
	LoadText()
EndFunc
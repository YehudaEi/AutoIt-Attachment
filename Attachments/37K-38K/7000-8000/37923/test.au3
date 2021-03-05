#include <IE.au3>
#include <Date.au3>
#include <FTPEx.au3>
#include <File.au3>
#include <winapi.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <ListViewConstants.au3>
#include <StaticConstants.au3>
#include <GUIListBox.au3>
Global $HuongDanSuDung= "1. Khi không vào được website, bạn hãy ấn nút  'CHE DẤU IP'  rồi vào website phà phà."&@CRLF&@CRLF&"2. Khi đã vào được website, muốn tăng tốc độ mạng, bạn hãy ấn nút  'KHÔI PHỤC IP' ."&@CRLF&@CRLF&"3. Click vào nút  'LẤY WEBSITE'  bạn sẽ bất ngờ."&@CRLF&@CRLF&"CHÚ Ý: Sau khi ấn nút  'KHÔI PHỤC IP'  bạn không được thoát website nhé."
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("LoginBet - Nhân IT", 700, 300, 192, 124)
$Group = GUICtrlCreateGroup("Tùy chỉnh", 16, 16, 345, 129)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$auto_proxy = GUICtrlCreateRadio("Automatically get proxy ", 32, 40, 313, 25)
GUICtrlSetFont($auto_proxy, 10, 400, 0, "MS Sans Serif")
$manual_proxy = GUICtrlCreateRadio("Manual proxy   ", 32, 72, 313, 25)
GUICtrlSetFont($manual_proxy, 10, 400, 0, "MS Sans Serif")
$Label_proxy = GUICtrlCreateLabel("Proxy:", 32, 108, 45, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Input_proxy = GUICtrlCreateInput("", 80, 104, 137, 24)
$Label_port = GUICtrlCreateLabel("Port:", 240, 108, 45, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Input_port = GUICtrlCreateInput("", 288, 104, 49, 24)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$button_hideip = GUICtrlCreateButton("Hide IP", 48, 160, 97, 33)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$button_restoreip = GUICtrlCreateButton("Restore IP", 224, 160, 97, 33)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Label_process = GUICtrlCreateLabel("", 112, 200, 173, 28, $SS_CENTER)
GUICtrlSetFont(-1, 10, 400, 2, "MS Sans Serif")
GUICtrlSetResizing(-1, $GUI_DOCKHCENTER+$GUI_DOCKVCENTER)
$Label_about = GUICtrlCreateLabel("Tác giả: Nhân IT				Liên hệ: 01264187774", 25, 260, 620, 60)
GUICtrlSetFont(-1, 12, 400, 0, "Myriad Pro")
GUICtrlSetColor(-1,0xC11B17)
$label_huongdan = GUICtrlCreateLabel("Hướng dẫn sử dụng <-- Click vào",376,200,300,20)
GUICtrlSetFont(-1, 12, 400, 0, "Myriad Pro")
GUICtrlSetCursor (-1,6)
GUICtrlSetColor(-1,0x0000CD)
$Label_listweb = GUICtrlCreateLabel("Danh sách website", 376, 10, 161, 40)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
 GUICtrlSetTip(-1, "Lấy danh sách các website ibet, sbobet dễ vào")
$List_web = GUICtrlCreateList("", 376, 48, 300, 160, BitOR($LBS_NOTIFY,$WS_HSCROLL,$WS_VSCROLL,$WS_BORDER))
GUICtrlSetTip(-1, "Muốn vào trang nào thì Click vào trang đó")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

GUICtrlSetState($Input_proxy,$GUI_DISABLE)
GUICtrlSetState($Input_port,$GUI_DISABLE)
GUICtrlSetState($auto_proxy,$GUI_CHECKED)
GUICtrlSetState($manual_proxy,$GUI_UNCHECKED)

Const $HIDEIP= 1, $RESTOREIP= 2
Global $ngay_update, $gio_update, $reupdate=12, $offset_proxy=0, $offset_web=0, $array, $location= @MyDocumentsDir&"\update.txt", $location_config= @MyDocumentsDir&"\config.txt"
;======================================================= MAIN ====================================================
load_config()
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			FileDelete($location_config)
			Exit
		Case $manual_proxy
			GUICtrlSetState($Input_port,$GUI_ENABLE)
			GUICtrlSetState($Input_proxy,$GUI_ENABLE)
		Case $auto_proxy
			GUICtrlSetState($Input_proxy,$GUI_DISABLE)
			GUICtrlSetState($Input_port,$GUI_DISABLE)
		Case $button_hideip
			;GUICtrlSetState($button_hideip,$GUI_DISABLE)
			;GUICtrlSetState($button_restoreip,$GUI_ENABLE)
			GUICtrlSetData($Label_process,"Đang tiến hành ẩn IP...")

			If (GUICtrlRead($auto_proxy)==$GUI_CHECKED) Then
				If (FileExists($location)==1) Then
					load()
					If _DateDiff('h',$ngay_update&" "&$gio_update&":00:00",_NowCalc())>=$reupdate	 Then
						If download()==1 Then
							load()
						Else
							MsgBox(0,"Lỗi update", "Bạn đang sài list proxy cũ")
						EndIf
					EndIf
				Else
					If download()==1 Then
						load()
					Else
						;GUICtrlSetState($button_hideip,$GUI_ENABLE)
					EndIf
				EndIf

				$proxy= get_proxy($location)
				enable($proxy)
			Else
				enable(GUICtrlRead($Input_proxy)&":"&GUICtrlRead($Input_port))
			EndIf

			GUICtrlSetData($Label_process,"Ẩn ip hoàn tất !")
			If Not FileExists($location_config) Then
				_FileCreate($location_config)
				FileOpen($location_config,2)
				FileWrite($location_config,$HIDEIP)
				FileSetAttrib($location_config,"+H")
			Else
				FileSetAttrib($location_config,"-H")
				FileOpen($location_config,2)
				FileWrite($location_config,$HIDEIP)
				FileSetAttrib($location_config,"+H")
			EndIf
			;MsgBox(0,"",$location_config)
			Run(@ScriptFullPath,@MyDocumentsDir)
			Exit
			;GUICtrlSetState($auto_proxy,$GUI_DISABLE)
			;GUICtrlSetState($manual_proxy,$GUI_DISABLE)
		Case $button_restoreip
			disable()
			;GUICtrlSetState($button_hideip,$GUI_ENABLE)
			;GUICtrlSetState($button_restoreip,$GUI_DISABLE)
			GUICtrlSetData($Label_process,"Đã khôi phục lại ip !")
			If Not FileExists($location_config) Then
				_FileCreate($location_config)
				FileOpen($location_config,2)
				FileWrite($location_config,$RESTOREIP)
				FileSetAttrib($location_config,"+H")
			Else
				FileSetAttrib($location_config,"-H")
				FileOpen($location_config,2)
				FileWrite($location_config,$RESTOREIP)
				FileSetAttrib($location_config,"+H")
			EndIf
			Run(@ScriptFullPath,@MyDocumentsDir)
			Exit
			;GUICtrlSetState($auto_proxy,$GUI_ENABLE)
			;GUICtrlSetState($manual_proxy,$GUI_ENABLE)
		Case $List_web
			If  StringInStr(GUICtrlRead($List_web),".")<>0  Then
				_IECreate(GUICtrlRead($List_web),0,1,0)
			EndIf
		Case $label_huongdan
			MsgBox(0,"Đọc kỹ hướng dẫn trước khi sử dụng",$HuongDanSuDung)
	EndSwitch
WEnd
;================================================ END MAIN ======================================================
Func load_website()
	If (FileExists($location)) Then
		load()
		$list= get_web($location)
		GUICtrlSetColor($List_web,0x000000)
		GUICtrlSetBkColor($List_web,0xBDEDFF)
		For $i=1 To $list[0]
			GUICtrlSetData($List_web,$list[$i])
		Next
	EndIf
EndFunc
Func load_config()
	If FileExists($location_config) Then
		$choose= FileRead($location_config)
		Switch $choose
			Case $HIDEIP
				GUICtrlSetState($button_hideip,$GUI_DISABLE)
				GUICtrlSetData($Label_process,"IP của bạn đã được ẩn")
			Case $RESTOREIP
				GUICtrlSetState($button_restoreip,$GUI_DISABLE)
				GUICtrlSetData($Label_process,"IP chưa được ẩn")
		EndSwitch
	EndIf
	load_website()
EndFunc
Func download()
	Local $sesson, $conn, $file
	$server= "ftp.byethost7.com"
	$username= "b7_10895192"
	$pass= "nhanpro0"

	$sesson= _FTP_Open("My ftp")
	If $sesson== 0 Then
		MsgBox(0,"Lỗi", "Tạo sesson thất bại")
		return 0
	EndIf
	$conn= _FTP_Connect($sesson,$server,$username,$pass)
	If $conn==0 Then
		MsgBox(0,"Lỗi", "Không kết nối đc với server")
		return 0
	EndIf
	$file= _FTP_FileGet($conn, "/htdocs/update.txt", $location)
	If ($file==1) Then
		load()
	Else
		MsgBox(0,"Lỗi", "Không tải được file update.")
	EndIf
	return $file
EndFunc
Func load()
	If (Not FileExists($location)) Then
		Return 0
	EndIf
	_FileReadToArray($location, $array)
	$ngay_update= $array[1]
	$gio_update= $array[2]
	$reupdate= $array[3]
	$offset_proxy= $array[4]
	$offset_web= $array[5]
	Return 1
EndFunc
Func get_proxy($filename)

	Local $n= $offset_web-$offset_proxy-1
	Local $proxy, $time, $time_min=500
	For $i= $offset_proxy To $offset_web-2
		$temp= StringSplit($array[$i],":",1)
		If($temp[0]==2) Then
			$time= Ping($temp[1],500)
			if($time<$time_min) Then
				$time_min= $time
				$proxy= $array[$i]
			EndIf
		EndIf
	Next
	Return ($proxy)
EndFunc
Func enable($proxy)
	;"HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
	;HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings
	$a=RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyEnable","REG_DWORD","1")
	$b=RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyServer","REG_SZ",$proxy)
	DllCall('wininet.dll', 'long', 'InternetSetOption', 'int', 0, 'long', 39, 'str', 0, 'long', 0)
	Sleep(3000)
	;DllCall( 'wininet.dll', 'uint', 'InternetSetOption', 'ptr', 0, 'dword', 39, 'ptr', 0, 'dword', 0 )
	;DllCall( 'wininet.dll', 'uint', 'InternetSetOption', 'ptr', 0, 'dword', 37, 'ptr', 0, 'dword', 0 )
EndFunc

Func disable()

	RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyServer","REG_SZ","")
	RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings","ProxyEnable","REG_DWORD","0")
	DllCall('wininet.dll', 'long', 'InternetSetOption', 'int', 0, 'long', 39, 'str', 0, 'long', 0)
	Sleep(3000)
	;DllCall( 'wininet.dll', 'uint', 'InternetSetOption', 'ptr', 0, 'dword', 39, 'ptr', 0, 'dword', 0 )
EndFunc

Func get_web($filename)
	Local $n= _FileCountLines($filename) - $offset_web +1
	Local $List_web[$n+1], $k=1
	$List_web[0]= $n

	For $i= $offset_web To $n+$offset_web-1
		$List_web[$k]= $array[$i]
		$k+=1
	Next

	Return $List_web
EndFunc







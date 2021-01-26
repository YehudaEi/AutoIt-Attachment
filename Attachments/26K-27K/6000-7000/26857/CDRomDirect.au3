
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=E:\Anh\Virtual Drive 8\MGR.ico
#AutoIt3Wrapper_Outfile=CDRomDirect.exe
#AutoIt3Wrapper_Res_Comment=Phan mem dong mo o CDRom
#AutoIt3Wrapper_Res_Description=CDRomDirect
#AutoIt3Wrapper_Res_Fileversion=1.1.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Copyright � 2008 VanThanh
#AutoIt3Wrapper_Res_SaveSource=y
#AutoIt3Wrapper_Res_Field=Tao boi|Le Van Thanh
#AutoIt3Wrapper_Res_Field=Dia chi|Lop 11H Truong THPT Ba Dinh, Nga Son, Thanh Hoa
#AutoIt3Wrapper_Res_Field=Ten PM|CDRomDirect
#AutoIt3Wrapper_Res_Field=Phien ban|1.1
#AutoIt3Wrapper_Res_Field=Ngon ngu|Viet Nam
#AutoIt3Wrapper_Res_Field=Ngay hoan thanh|30/05/2008
#AutoIt3Wrapper_Res_Field=Gio hoan thanh|4h 30'
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include < GUIConstantsEx.au3 >
#include <constants.au3>
#include <ButtonConstants.au3>
#NoTrayIcon
Opt("TrayMenuMode", 1)
Opt('Guicloseonesc', 0)
;HotKeySet
HotKeySet("^+{PgUp}", "hien")
Func hien()
	GUISetState(@SW_SHOW, $chinh)
EndFunc   ;==>hien

HotKeySet("^+{PgDn}", "an")
Func an()
	GUISetState(@SW_HIDE, $chinh)
	TrayTip("Thông báo", "Chương trình đang chạy" & @CRLF & "Ctrl + Shift + {Down} - Đóng/Mở ổ CD-Rom" & @CRLF & "Ctrl + Shift + {PgUp} - Hiện bảng điều khiển" & @CRLF & "Ctrl + Shift + {PgDn} - Ẩn bảng điều khiển" & @CRLF & "Ctrl + Shift + {End} - Thoát", 10, 1)
EndFunc   ;==>an

HotKeySet("^+{End}", "thoat")
Func thoat()
	$msg = GUIGetMsg()
	$msg = $gui_event_close
EndFunc   ;==>thoat

HotKeySet("^+{down}", "chuyendoi")
Func chuyendoi()
	$msg = GUIGetMsg()
	$msg = $dm
EndFunc   ;==>chuyendoi
;GUI
$chinh = GUICreate("Open/Close CDRom", 310, 290)
GUISetBkColor(0x00ff00, $chinh)
GUISetIcon('shell32.dll', 295)
$label1 = GUICtrlCreateLabel('Open/Close CD-Rom', 37, 10, 280, 35)
GUICtrlSetFont(-1, 19, 400, 4, "Monotype Corsiva")
$dm = GUICtrlCreateButton("Mở", 118, 50, 70, 60)
GUICtrlSetFont($dm, 14, 400, -1, "MS Reference Sans Serif")
GUICtrlSetBkColor($dm, 0x8080FF)
$about = GUICtrlCreateButton("About", 10, 150, 60, 30)
GUICtrlSetBkColor($about, 0x00FFFF)
;Labels
GUICtrlCreateLabel("Sử dụng các phím nóng sau đây :", 80, 120)
GUICtrlCreateLabel("Ctrl + Shift + {Down} - Đóng/Mở", 80, 135)
GUICtrlCreateLabel("Ctrl + Shift + {PgUp} - Hiện bảng điều khiển", 80, 150)
GUICtrlCreateLabel("Ctrl + Shift + {PgDn} - Ẩn bảng điều khiển", 80, 165)
GUICtrlCreateLabel("Ctrl + Shift +  {End}  - Thoát", 80, 180)
$gr = GUICtrlCreateGroup('', 10, 200, 230, 80)
$cb1 = GUICtrlCreateCheckbox('&Khởi động cùng Windows', 10, 195)
$rd1 = GUICtrlCreateRadio('&Tự động ẩn chương trình', 30, 215)
$rd2 = GUICtrlCreateRadio('&Chỉ ẩn xuống khay hệ thống', 30, 235)
$rd3 = GUICtrlCreateRadio('&Hiện bảng điều khiển', 30, 255)
$ok = GUICtrlCreateButton('&OK', 250, 220, 50, 35)
GUICtrlSetBkColor($ok, 0x99FF00)
GUICtrlCreateLabel("Let's", 20, 60, 93, 50)
GUICtrlSetFont(-1, 30, 400, 12, "Poor Richard")
GUICtrlCreateLabel("Go!!!", 203, 60, 93, 50)
GUICtrlSetFont(-1, 30, 400, 12, "Poor Richard")
GUISetState(@SW_SHOW, $chinh)
;Drive	and status
$drive = DriveGetDrive("CDRom")
$tt = GUICtrlRead($dm)
;Tray
$dk = TrayCreateItem("Bảng điều khiển")
TrayItemSetState($dk, $tray_default)
TrayCreateItem("")
$tacgia = TrayCreateItem("About me")
TrayCreateItem("")
$thoat = TrayCreateItem("Thoát")
TraySetIcon('shell32.dll', 295)
TraySetState()
TraySetClick(8)
;Ẩn Down SystemTray khi khởi động
If $CMDLINE[0] > 0 And $CMDLINE[1] = "-Silent" Then
	Sleep(1000)
	GUISetState(@SW_HIDE, $chinh)
	TrayTip( "Đã sẵn sàng", 'Ấn Ctrl + Shift + {PgUp} để gọi bảng điều khiển' & @CRLF & 'Byeee ..................................', 10, 1)
	Sleep(5000)
	AutoItSetOption('trayiconhide', 1)
ElseIf $CMDLINE[0] > 0 And $CMDLINE[1] = "-Tray" Then
	GUISetState(@SW_HIDE, $chinh)
	TrayTip("Đã sẵn sàng" , "Ctrl + Shift + {Down} - Đóng/Mở ổ CD-Rom" & @CRLF & "Ctrl + Shift + {PgUp} - Hiện bảng điều khiển" & @CRLF & "Ctrl + Shift + {PgDn} - Ẩn bảng điều khiển" & @CRLF & "Ctrl + Shift + {End} - Thoát", 10, 1)
Else
	GUISetState(@SW_SHOW, $chinh)
EndIf ; ===>Ket thuc
;Kiểm tra xem chương trình có đang chạy không
Func OnAutoItStart()
	$list = ProcessList(@ScriptName)
	If $list[0][0] > 1 Then
		MsgBox(48, 'Thông báo', '	 Chương trình đang chạy' & @CRLF & 'Ấn tổ hợp phím Ctrl + Shift + {PgUp} để gọi bảng điều khiển')
		Exit
	EndIf
EndFunc ; ===> Kết thúc.
;Đọc trạng thái StartUp
If RegRead("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "CDRomDirect") = '"' & @ScriptFullPath & '"' & ' -Silent' Then
	GUICtrlSetState($cb1, $gui_checked)
	GUICtrlSetState($rd1, $gui_checked)
ElseIf RegRead("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "CDRomDirect") = '"' & @ScriptFullPath & '"' & ' -Tray' Then
	GUICtrlSetState($cb1, $gui_checked)
	GUICtrlSetState($rd2, $gui_checked)
ElseIf RegRead("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "CDRomDirect") = '"' & @ScriptFullPath & '"' Then
	GUICtrlSetState($cb1, $gui_checked)
	GUICtrlSetState($rd3, $gui_checked)
Else
	GUICtrlSetState($cb1, $gui_unchecked)
	GUICtrlSetState($rd1, $gui_disable)
	GUICtrlSetState($rd2, $gui_disable)
	GUICtrlSetState($rd3, $gui_disable)
EndIf

;Begin
While 1
	$msg = GUIGetMsg()
	$msg1 = TrayGetMsg()
	Select
		Case $msg1 = $dk
			GUISetState(@SW_SHOWNORMAL, $chinh)
		Case $msg = $gui_event_minimize
			GUISetState(@SW_HIDE, $chinh)
			TrayTip("Thông báo", "Chương trình đang chạy" & @CRLF & "Ctrl + Shift + {Down} - Đóng/Mở ổ CD-Rom" & @CRLF & "Ctrl + Shift + {PgUp} - Hiện bảng điều khiển" & @CRLF & "Ctrl + Shift + {PgDn} - Ẩn bảng điều khiển" & @CRLF & "Ctrl + Shift + {End} - Thoát", 10, 1)
		Case $msg = $gui_event_close Or $msg1 = $thoat
			Exit
		Case $msg = $dm And $tt = "Mở"
			CDTray($drive[1], "open")
			GUICtrlSetData($dm, "Đóng")
			$tt = GUICtrlRead($dm)
		Case $msg = $dm And $tt = "Đóng"
			CDTray($drive[1], "closed")
			GUICtrlSetData($dm, "Mở")
			$tt = GUICtrlRead($dm)
		Case $msg = $about Or $msg1 = $tacgia
			MsgBox(64, "Lê Văn Thành", "Đây là phần mềm giúp các bạn có thể dễ dàng đóng/mở    " & @CRLF & "         ổ CDRom bằng việc sử dụng các phím nóng." & @CRLF & "                         Chúc các bạn vui vẻ !" & @CRLF & @CRLF & 'Tác giả :                 Lê Văn Thành' & @CRLF & 'Lớp 11H, trường THPT Ba Đình - Nga Sơn - Thanh Hoá' & @CRLF & 'Email:      forget_me_not_please@yahoo.com' & @CRLF & '               setbody_nth2005@yahoo.com')
		Case $msg = $cb1
			$cb1status = GUICtrlRead($cb1)
			If $cb1status = $gui_checked Then
				GUICtrlSetState($rd1, $gui_enable)
				GUICtrlSetState($rd1, $gui_checked)
				GUICtrlSetState($rd2, $gui_enable)
				GUICtrlSetState($rd3, $gui_enable)
			Else
				GUICtrlSetState($rd1, $gui_disable)
				GUICtrlSetState($rd2, $gui_disable)
				GUICtrlSetState($rd3, $gui_disable)
			EndIf
		Case $msg = $ok
			$cb1status = GUICtrlRead($cb1)
			$rd1status = GUICtrlRead($rd1)
			$rd2status = GUICtrlRead($rd2)
			$rd3status = GUICtrlRead($rd3)
			If $cb1status = $gui_checked Then
				If $rd1status = $gui_checked Then
					RegWrite("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "CDRomDirect", "REG_SZ", '"' & @ScriptFullPath & '"' & ' -Silent')
					MsgBox(64, 'Thông báo', '         Đã được kích hoạt' & @CRLF & 'Chương trình sẽ ẩn khi khởi động')
				ElseIf $rd2status = $gui_checked Then
					RegWrite("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "CDRomDirect", "REG_SZ", '"' & @ScriptFullPath & '"' & ' -Tray')
					MsgBox(64, 'Thông báo', '                          Đã được kích hoạt' & @CRLF & 'Chương trình sẽ ẩn xuống khay hệ thống khi khởi động')
				ElseIf $rd3status = $gui_checked Then
					RegWrite("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "CDRomDirect", "REG_SZ", '"' & @ScriptFullPath & '"')
					MsgBox(64, 'Thông báo', '       	   Đã được kích hoạt' & @CRLF & 'Chương trình sẽ hiện bảng điều khiển khi khởi dộng')
				EndIf
			ElseIf $cb1status = $gui_unchecked Then
				RegDelete("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "CDRomDirect")
				MsgBox(64, 'Thông báo', 'Đã bỏ tự khởi động')
			EndIf
			
	EndSelect
WEnd ;======>End.

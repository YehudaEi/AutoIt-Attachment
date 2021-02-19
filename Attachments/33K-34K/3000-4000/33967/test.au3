#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=E:\DO AN\Form1.kxf
$Form1 = GUICreate("Auto Sơftware", 615, 488, 192, 124)
GUISetBkColor(0xFFFFFF)
$Tab1 = GUICtrlCreateTab(16, 120, 585, 345)
GUICtrlCreateTabItem("Cài Đặt")

$Group1 = GUICtrlCreateGroup("Danh Sách Phần Mềm", 40, 160, 190, 249)
GUICtrlSetFont(-1, 8, 400, 0, "Times New Roman")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$dsPM = GUICtrlCreateList("",45,175,180,235)

$Group2 = GUICtrlCreateGroup("Phần Mềm Được Chọn", 384, 160, 190, 249)
GUICtrlSetFont(-1, 8, 400, 0, "Times New Roman")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$dsDC = GUICtrlCreateList("",390,175,180,235)

$btnAdd = GUICtrlCreateButton(">", 280, 176, 75, 25)
GUICtrlSetFont(-1, 8, 400, 0, "Times New Roman")
$btnAddAll = GUICtrlCreateButton(">>", 280, 240, 75, 25)
GUICtrlSetFont(-1, 8, 400, 0, "Times New Roman")
$btnDelete = GUICtrlCreateButton("<", 280, 312, 75, 25)
GUICtrlSetFont(-1, 8, 400, 0, "Times New Roman")
$btnDeleteAll = GUICtrlCreateButton("<<", 280, 368, 75, 25)
GUICtrlSetFont(-1, 8, 400, 0, "Times New Roman")
$btnInital = GUICtrlCreateButton("Cài Đặt", 464, 424, 75, 25)
GUICtrlSetFont(-1, 8, 400, 0, "Times New Roman")
$TabSheet1 = GUICtrlCreateTabItem("Tiện Ích")
$TabSheet2 = GUICtrlCreateTabItem("Tùy Chọn")
$TabSheet3 = GUICtrlCreateTabItem("Thông Tin")
$Label3 = GUICtrlCreateLabel("Đây chương trình cài đặt phần mềm tự động", 144, 200, 250, 17)
GUICtrlCreateTabItem("")
$Pic1 = GUICtrlCreatePic("C:\Users\VCV\Desktop\sublogo.jpg", 16, 24, 64, 64)
$Label1 = GUICtrlCreateLabel("Vũ Công Viên", 112, 32, 81, 19)
GUICtrlSetFont(-1, 10, 800, 0, "Times New Roman")
$Label2 = GUICtrlCreateLabel("Chương trình cài đặt phần mềm tự động.", 112, 56, 200, 17)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
WEnd

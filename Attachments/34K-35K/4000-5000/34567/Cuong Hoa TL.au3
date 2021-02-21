#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>

GUICreate("Auto Cuong Hoa Thien Long", 400, 125) 
GUISetFont(10, 400, -1, "Arial")
GUICtrlCreateLabel("1. Kiem tra tui do co du binh cuong hoa chua", 10, 10)
GUICtrlCreateLabel("2. Neu chua co du thi an vao nut mua binh cuong hoa", 10, 28)
GUICtrlCreateLabel("3. Dat do can cuong hoa vao vi tri san truoc khi an nut cuong hoa", 10, 46)
$muadobutton = GUICtrlCreateButton( "Mua Do", 80, 80, 70, 30)
$cuonghoabutton = GUICtrlCreateButton( "Cuong Hoa", 230, 80, 75, 30)
$useredit = GuiCtrlCreateInput("20", 30, 80, 30, 20) 
GUISetState()
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE 
			Exit
		Case 
			If $msg = $muadobutton And WinActive ( "Thiên long bát b? 2.00.2506 (Máy ch? Chuy?n sinh:Tiêu Dao)") Then 
			Set_muado()
			Else
			MsgBox ( 5, "Bao Loi", "Chua khoi Dong TL ma")
		EndIf
	Case
			If $msg = $cuonghoabutton And WinActive ( "Thiên long bát b? 2.00.2506 (Máy ch? Chuy?n sinh:Tiêu Dao)") Then 
			Set_cuonghoa()
			Else
			MsgBox ( 5, "Bao Loi", "Chua khoi Dong TL ma")
		
	EndSelect
	
WEnd
Func Set_muado ()
	if $useredit = Number >= 50 Then 
		MsgBox ( 5, "Bao Loi", "Du cho chua ko ma mua nhiu vay")
	Else
		Do
			
			MouseClick ( "left", 678, 230, 2)
			Sleep ( 2000)
			MouseClick ( "left", 124, 255, 2) 
			Sleep ( 2000)
			MouseClick ( "left", 129, 220, 2) 
			Sleep ( 2000)
			MouseClick ( "left", 609, 301, 1) 
			Sleep ( 1500)
		Until $value = Number(GuiCtrlRead($useredit))
	EndIf
EndFunc

Func Set_cuonghoa ()
	MsgBox ( 1, "Huong dan", "Hay lai cho nang cap bo san do vao o nang cap sau do an lan nua")
	Do
		MouseClick ( "left", 1027. 678, 1, 2)
		Sleep (2000)
	Until $number
EndFunc


			
			
		
While GuiGetMsg() <> $GUI_EVENT_CLOSE 
WEnd

  
	
	
    




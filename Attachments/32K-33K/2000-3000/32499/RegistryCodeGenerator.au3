#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>
#include <WindowsConstants.au3>
#include<File.au3>
#NoTrayIcon
#RequireAdmin

$file = "RegistryFile.au3"

If Not FileExists("RegistryFile.au3") Then
	_FileCreate($file)
EndIf

$open = FileOpen("RegistryFile.au3", 1)

#Region ### START Koda GUI section ### Form=c:\documents and settings\administrator\desktop\koda_1.7.3.0\forms\form1.kxf
$Form1 = GUICreate("Registry Code Generator", 658, 251, -1, -1)
$Group1 = GUICtrlCreateGroup("Registry Code Genertator", 8, 16, 641, 145)
$Checkbox1 = GUICtrlCreateCheckbox("RegWrite", 24, 48, 73, 17)

$Input1 = GUICtrlCreateInput("", 104, 48, 240, 21)
GUICtrlSetTip(-1, "Insert your keyname: Example: HKEY_CURRENT_USER\Software\Test")
GUICtrlSetState(-1, $GUI_DISABLE)

$Input2 = GUICtrlCreateInput("", 346, 48, 90, 21)
GUICtrlSetTip(-1, "Valuename [optional]: Example: TestKey")
GUICtrlSetState(-1, $GUI_DISABLE)

$Combo1 = GUICtrlCreateCombo("", 438, 48, 105, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetTip(-1, "[optional] Type of key to write: Example: REG_SZ")
GUICtrlSetData(-1, "||REG_BINARY|REG_SZ|REG_MULTI_SZ|REG_EXPAND_SZ|REG_QWORD|REG_DWORD")
GUICtrlSetState(-1, $GUI_DISABLE)

$Input3 = GUICtrlCreateInput("", 545, 48, 90, 21)
GUICtrlSetTip(-1, "[optional] The value to write: Example: Hello this is a test")
GUICtrlSetState(-1, $GUI_DISABLE)

$Checkbox2 = GUICtrlCreateCheckbox("RegRead", 24, 80, 73, 17)


$Input4 = GUICtrlCreateInput("", 104, 80, 439, 21)
GUICtrlSetTip(-1, "The registry key to read: Example: HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion")
GUICtrlSetState(-1, $GUI_DISABLE)

$Input5 = GUICtrlCreateInput("", 545, 80, 90, 21)
GUICtrlSetTip(-1, "The value to read: Example: ProgramFilesDir")
GUICtrlSetState(-1, $GUI_DISABLE)

$Checkbox3 = GUICtrlCreateCheckbox("RegDelete", 24, 112, 73, 17)

$Input6 = GUICtrlCreateInput("", 104, 112, 439, 21)
GUICtrlSetTip(-1, "The registry key to delete: Example: HKEY_CURRENT_USER\Software\Test")
GUICtrlSetState(-1, $GUI_DISABLE)

$Input7 = GUICtrlCreateInput("", 545, 112, 90, 21)
GUICtrlSetTip(-1, "[optional] The valuename to delete: Example: TestKey")
GUICtrlSetState(-1, $GUI_DISABLE)

GUICtrlCreateGroup("", -99, -99, 1, 1)

$Group2 = GUICtrlCreateGroup("Control", 8, 168, 641, 57)
$Button1 = GUICtrlCreateButton("Save", 480, 188, 75, 25)
GUICtrlSetTip(-1, "Save...")
$Button2 = GUICtrlCreateButton("Exit", 560, 188, 75, 25)
GUICtrlSetTip(-1, "Exit...")
$Button3 = GUICtrlCreateButton("Show", 24, 188, 75, 25)
GUICtrlSetTip(-1, "Open file")
$Button4 = GUICtrlCreateButton("Registry Editor", 105, 188, 90, 25)
GUICtrlSetTip(-1, "Open Registry")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$StatusBar1 = _GUICtrlStatusBar_Create($Form1)
GUISetState()
#EndRegion ### END Koda GUI section ###

While 1
	Switch GUIGetMsg()
	
Case $GUI_EVENT_CLOSE
	 FileClose($open)
			Exit
		Case $Checkbox1
			check1()
		Case $Checkbox2
			check2()
		Case $Checkbox3
			check3()
		Case $Button1
			OK()
		Case $Button2
			Close()
		Case $Button3
			Show_data()
		Case $Button4
			registry()
	EndSwitch
WEnd

Func check1()
	If GUICtrlRead($Checkbox1) = $GUI_CHECKED Then
		GUICtrlSetState($Input1, $GUI_ENABLE)
		GUICtrlSetData($Input1, "")
		GUICtrlSetState($Input2, $GUI_ENABLE)
		GUICtrlSetData($Input2, "")
		GUICtrlSetState($Combo1, $GUI_ENABLE)
		;GUICtrlSetData($Combo1, "")
		GUICtrlSetState($Input3, $GUI_ENABLE)
		GUICtrlSetData($Input3, "")
	Else
		GUICtrlSetState($Input1, $GUI_DISABLE)
		GUICtrlSetData($Input1, "")
		GUICtrlSetState($Input2, $GUI_DISABLE)
		GUICtrlSetData($Input2, "")
		GUICtrlSetState($Combo1, $GUI_DISABLE)
		;GUICtrlSetData($Combo1, "")
		GUICtrlSetState($Input3, $GUI_DISABLE)
		GUICtrlSetData($Input3, "")
		EndIf
	EndFunc
	
	Func check2()
		If GUICtrlRead($Checkbox2) = $GUI_CHECKED Then
			GUICtrlSetState($Input4, $GUI_ENABLE)
			GUICtrlSetData($Input4, "")
			GUICtrlSetState($Input5, $GUI_ENABLE)
			GUICtrlSetData($Input5, "")
		Else
			GUICtrlSetState($Input4, $GUI_DISABLE)
			GUICtrlSetData($Input4, "")
			GUICtrlSetState($Input5, $GUI_DISABLE)
			GUICtrlSetData($Input5, "")
		EndIf
	EndFunc
	
	Func check3()
		If GUICtrlRead($Checkbox3) = $GUI_CHECKED Then
			GUICtrlSetState($Input6, $GUI_ENABLE)
			GUICtrlSetData($Input6, "")
			GUICtrlSetState($Input7, $GUI_ENABLE)
			GUICtrlSetData($Input7, "")
			Else
			GUICtrlSetState($Input6, $GUI_DISABLE)
			GUICtrlSetData($Input6, "")
			GUICtrlSetState($Input7, $GUI_DISABLE)
			GUICtrlSetData($Input7, "")
		EndIf
	EndFunc
		

Func OK()
	If GUICtrlRead($Checkbox1) = $GUI_CHECKED Then
	$value1 = ";Script Created by Registry Code Generator" & @CRLF & _
	"RegWrite" & '("' & GUICtrlRead($Input1) & '" , ' & '"' & GUICtrlRead($Input2) & '", ' & '"' & GUICtrlRead($Combo1) & '", ' & '"' & GUICtrlRead($Input3) & '")' & @CRLF 
	
	
	FileWrite($open, $value1 & @CRLF)
	GUICtrlSetData($Input1, "")
	GUICtrlSetData($Input2, "")
	GUICtrlSetData($Input3, "")
EndIf

	
	;------------------------------------------------------------------------------------------------
	
	If GUICtrlRead($Checkbox2) = $GUI_CHECKED Then
	$value2 = ";Script Created by Registry Code Generator" & @CRLF & _
	"RegRead" & '("' & GUICtrlRead($Input4) & '" , ' & '"' & GUICtrlRead($Input5) & '")' & @CRLF

	FileWrite($open, $value2 & @CRLF)
	GUICtrlSetData($Input4, "")
	GUICtrlSetData($Input5, "")
EndIf

	;-----------------------------------------------------------------------
	
	If GUICtrlRead($Checkbox3) = $GUI_CHECKED Then
	$value3 = ";Script Created by Registry Code Generator" & @CRLF & _
	"RegDelete" & '("' & GUICtrlRead($Input6) & '" , ' & '"' & GUICtrlRead($Input7) & '")' & @CRLF

	FileWrite($open, $value3 & @CRLF)
	GUICtrlSetData($Input6, "")
	GUICtrlSetData($Input7, "")
EndIf

	EndFunc
	
	
Func Close()
	FileClose($open)
	Exit
EndFunc

Func Show_data()
	ShellExecute($file)
EndFunc

Func registry()
	ShellExecute("regedit.exe")
EndFunc


		

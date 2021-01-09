;-------------------------------------
;
; Run AutoIT Scripts as a service
; PTREX 03/11/2005 - updated 07/07/2008
;
;-------------------------------------
#include <GUIConstantsEX.au3>
#include <ListViewConstants.au3>
#include <Process.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GuiListView.au3>


#NoTrayIcon

;Declare Vars
Global $objWMIService
Global $strComputer = "."

Const $OWN_PROCESS = 16 ;16 is own process
Const $INTERACTIVE = true ;True changes the $Own_Process to 272 is interact with desktop
Const $NORMAL_ERROR_CONTROL = 1
Dim $Script, $SrvAny, $info, $Help, $Var3

;Main Gui

GUICreate("Au3@Service", 570, 668, 289, 123, $WS_OVERLAPPEDWINDOW)
$ListView1 = GUICtrlCreateListView("Service Name |Status", 24, 160, 520, 481, $LVS_ICON+$LVS_SORTASCENDING )
_GUICtrlListView_SetColumnWidth ($listview1, 0,320)
$GUI_FileMenu   = GUICtrlCreateMenu     ("&File")
$GUI_FileOpen   = GUICtrlCreateMenuitem ("&Open..."     ,$GUI_FileMenu)

$Helpmenu = GUICtrlCreateMenu ("?")
$Helpitem = GUICtrlCreateMenuitem ("Help",$Helpmenu)
$Infoitem = GUICtrlCreateMenuitem ("Info",$Helpmenu)

$Edit1 = GUICtrlCreateInput("Select a compiled script to start", 24, 20, 273, 21)
$Checkbox1 = GUICtrlCreateCheckbox ("Interact with Desktop. (Your script has a GUI)", 24, 130, 280, 20)
GUICtrlSetState (-1,1)			
$Button1 = GUICtrlCreateButton("Add Any Service", 24, 110, 93, 17)
$Button2 = GUICtrlCreateButton("Delete Any Service", 120, 110, 120, 17)
$Button3 = GUICtrlCreateButton("Open Services", 303, 110, 91, 17)
$Button4 = GUICtrlCreateButton("Select Script ...", 24, 50, 91, 17)
$Button5 = GUICtrlCreateButton("Assing Script to run" , 120, 50, 120, 17)
$Label1 = GUICtrlCreateLabel($var3, 24, 75, 370, 21, $SS_SUNKEN)

GUICtrlCreateGroup ("Services Control", 400, 5, 140, 150)
$RadioButton1 = GUICtrlCreateRadio("List All Services", 416, 24, 89, 17)
$RadioButton2 = GUICtrlCreateRadio("List Au3 Services", 416, 54, 113, 17)
$RadioButton3 = GUICtrlCreateRadio("Start Au3 Service", 416, 94, 120, 17)
$RadioButton4 = GUICtrlCreateRadio("Stop Au3 Servioe", 416, 124, 120, 17)
GUICtrlSetState ($RadioButton1,$GUI_CHECKED)


GUISetState(@SW_SHOW)
;Dim $B_DESCENDING[_GUICtrlListView_GetItemCount ($listview1) ]
$var3 = RegRead("HKLM\SYSTEM\CurrentControlSet\Services\_Au3@service\Parameters", "Application")
GUICtrlSetData($Label1,$Var3)
_List_Services1()

While 1
	$msg = GuiGetMsg()
	Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case $msg = $GUI_FileOpen
		_File_Open()
	Case $msg = $infoitem
		Info()
		Msgbox(0,"Info",$Info)
	Case $msg = $Helpitem
		Help()
		Msgbox(0,"Help",$Help)
	Case $msg = $Button1
		_Install_Service()
	Case $msg = $Button2
		_Delete_Service()
	Case $msg = $Button3
		_Open_Services()
	Case $msg = $Button4
		_Select_Script()
	Case $msg = $Button5
		_Assign_Script()
		GUICtrlSetData($Label1,$Var3)
	Case $msg = $RadioButton1
		_List_Services1()
	Case $msg = $RadioButton2
		_List_Services2()
	Case $msg = $RadioButton3
		_Start_Service()
	Case $msg = $RadioButton4
		_Stop_Service()
	Case $msg = $Checkbox1
		_Interact_Desktop()
	EndSelect
WEnd
Exit

;Functions
Func _File_Open()
	$FileOD = FileOpenDialog("Select SrvAny.exe File", "C:\", "EXE (*.exe)", 3)
	$File = FileOpen($FileOD, 0)
	GUICtrlSetData($Edit1,Chr(34) & $FileOD  & chr(34))
	$SrvAny = (Chr(34) & $FileOD  & chr(34) )
	If $File = -1 Then
		MsgBox(0, "Error", "Unable to open file, or no file selected !!")
	EndIf
EndFunc

Func _Select_Script()
	$FileOD = FileOpenDialog("Select Au3 Script File", "C:\", "EXE (*.exe)", 3) 
	$File = FileOpen($FileOD, 0)
	GUICtrlSetData($Edit1,Chr(34) & $FileOD  & chr(34))
	$Script = (Chr(34) & $FileOD  & chr(34) )
	If $File = -1 Then
		MsgBox(0, "Error", "Unable to open file, or no file selected !!")
	EndIf
Endfunc

Func _List_Services1()
	_GUICtrlListView_DeleteAllItems ($listview1)	
	$objWMIService = ObjGet("winmgmts:" & "{impersonationLevel=impersonate}!\\" & $strComputer & "\root\cimv2")
	$colRunningServices = $objWMIService.ExecQuery("Select * from Win32_Service")
		For $objService in $colRunningServices 
    local $Data = ($objService.DisplayName  & "|" & $objService.State)
    GUICtrlCreateListViewItem($Data,$listview1)
	Next
EndFunc

Func _List_Services2()
	_GUICtrlListView_DeleteAllItems ($listview1)	
	$objWMIService = ObjGet("winmgmts:" & "{impersonationLevel=impersonate}!\\" & $strComputer & "\root\cimv2")
	$colRunningServices = $objWMIService.ExecQuery("Select * from Win32_Service Where Name like '_Au%'")
		For $objService in $colRunningServices 
    local $Data = ($objService.DisplayName  & "|" & $objService.State)
	GUICtrlCreateListViewItem($Data,$listview1)
	Next
EndFunc

Func _Install_Service() ;"Manual", $NOT_INTERACTIVE, "NT AUTHORITY\LocalService", ""  ) OR ;"Manual", $NOT_INTERACTIVE, "LocalSystem", ""  )
	If $SrvAny = "" Then
	MsgBox(0,"Warning ", "Select the SvrAny.exe using the File Open first")
	Else
	MsgBox(0,"Information","This has to be activated only ONCE !!")
	$objWMIService = ObjGet("winmgmts:" & "{impersonationLevel=impersonate}!\\" & $strComputer & "\root\cimv2")
	$objService = $objWMIService.Get("Win32_BaseService")
	$errReturn = $objService.Create("_Au3@Service" ,"_Au3@Service" , $SrvAny, $OWN_PROCESS, $NORMAL_ERROR_CONTROL, _
	"Manual", $INTERACTIVE, "LocalSystem", ""  )
	EndIf
EndFunc
	   
Func _Delete_Service()
	$objWMIService = ObjGet("winmgmts:" & "{impersonationLevel=impersonate}!\\" & $strComputer & "\root\cimv2")
	$colListOfServices = $objWMIService.ExecQuery ("Select * from Win32_Service Where Name = '_Au3@Service'")
		For $objService in $colListOfServices
			$objService.StopService()
			$objService.Delete()
	Next
EndFunc

Func _Start_Service()
	Local $var1 = RegRead("HKLM\SYSTEM\CurrentControlSet\Services\_Au3@service", "ImagePath")
	If @error = -1 or StringRight ($var1, 11) <> "srvany.exe"&chr(34) Then
		MsgBox(4096,"",  "RegKey SrvAny not yet created, or not correct"&$var1)
	Else
	Local $var2 = RegRead("HKLM\SYSTEM\CurrentControlSet\Services\_Au3@service\Parameters", "Application")
		If @error = 1 Then
		MsgBox(0,"Warning","No Script has been assigned yet to the Any service!!")
		EndIf
	_RunDos("Net start _au3@service")
	EndIf
EndFunc

Func _Stop_Service()
	_RunDos("Net stop _au3@service")
EndFunc

Func _Open_Services()
	_RunDos("services.msc")
EndFunc

Func _Interact_Desktop()
	Local $var1 = RegRead("HKLM\SYSTEM\CurrentControlSet\Services\_Au3@service", "ImagePath")
	if @error = -1 or StringRight ($var1, 11) <> "srvany.exe"&chr(34) Then
		MsgBox(4096,"",  "RegKey not yet created, or not correct")
	Elseif GUICtrlRead($Checkbox1)= 1 Then
		RegWrite("HKLM\SYSTEM\CurrentControlSet\Services\_Au3@service", "Type", "REG_DWORD", "272")
	Elseif GUICtrlRead($Checkbox1)= 4 Then
		RegWrite("HKLM\SYSTEM\CurrentControlSet\Services\_Au3@service", "Type", "REG_DWORD", "16")
	EndIf
EndFunc

Func _Assign_Script()
		Local $var1 = RegRead("HKLM\SYSTEM\CurrentControlSet\Services\_Au3@service", "ImagePath")
	if @error = -1 or StringRight ($var1, 11) <> "srvany.exe"&chr(34) Then
		MsgBox(4096,"",  "RegKey not yet created, or not correct")
	Else 
		RegWrite("HKLM\SYSTEM\CurrentControlSet\Services\_Au3@service\Parameters", "AppDirectory", "REG_SZ", @WorkingDir)
		RegWrite("HKLM\SYSTEM\CurrentControlSet\Services\_Au3@service\Parameters", "Application", "REG_SZ", $Script)
	EndIf
	$var3 = RegRead("HKLM\SYSTEM\CurrentControlSet\Services\_Au3@service\Parameters", "Application")
EndFunc

Func Info()
	$Info = "Sytem Requirements :"&@CR&@CR& _
			"- In order to use this application you need to have 98/NT/2K/XP."&@CR&@CR& _
			"- You need to copy the file SrvAny.exe to your Windows directory."&@CR& _
			"  Afterwards you will need to register this file as a service, once."&@CR& _
			"  See Help for more info"
			
EndFunc

Func Help()
	$Help = "Registering the SrvAny.exe file as a service :"&@CR& _
			"- Go to the Windows directory where you have placed the SrvAny.exe file, using the FILE OPEN menu. " &@CR& _
			"- Press the Add Any Service button. This procedure has to be done only once."  &@CR&@CR& _
			"Assigning a Script to the service :"&@CR& _
			"- Use the Select Script button to pick a compiled script."&@CR& _
			"- Press the Assign Script to run button, to link this to the service."&@CR&@CR& _
			"Starting the service :"&@CR& _
			"- Click the start Au3 Service radio button, to start your script service."&@CR&@CR& _
			"Stopping the service :"&@CR& _
			"- Click the stop Au3 Service radio button, to stop your script service."&@CR&@CR& _
			"Open Services :"&@CR& _
			"- This button will allow you to open the Services.msc."
EndFunc

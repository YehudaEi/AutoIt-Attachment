#include "DateCrackerDL-constants.au3"
#include <GuiConstants.au3>
Opt ("TrayIconDebug", 1)
AutoItSetOption("WinTitleMatchMode", 2)
;=================================================Compiler opties==========================================================
#Region Compiler directives section
;** This is a list of compiler directives used by CompileAU3.exe.
;** comment the lines you don't need or else it will override the default settings
#Compiler_Prompt = n
;** AUT2EXE settings
;#Compiler_AUT2EXE =
#Compiler_Icon = Liberty.ico
#Compiler_Compression = 2
#Compiler_Allow_Decompile = y
#Compiler_PassPhrase = DaLiMan!
;** Target program Resource info
#Compiler_Res_Comment = Records and Saves the startupinformation for Date-limited software
#Compiler_Res_Description = DateCrackerDL ©
#Compiler_Res_LegalCopyright = DaliMan
#Compiler_Run_AU3Check = y
#Compiler_Res_Fileversion = 0.0.0.6
#EndRegion
;===============================================Version==============================================
Global $Versie = FileGetVersion(@ScriptFullPath)
Global $Name = "DateCrackerDL"

;========================================= Variables for GUI =====================================
Global $Style = $WS_POPUP + $WS_BORDER
Global $ExStyle = $WS_EX_TOPMOST
Global $ButStyle = $BS_ICON

;========================================= Variables for Record =====================================
Global $message = "DateCrackerDL - Select your program:"
Global $ProgramNameChk = StringReplace(FileRead($File, FileGetSize($File)), @CRLF, "|")

;========================================= Variables for Edit/Run =====================================
Global $ProgramName = StringReplace(FileRead($File, FileGetSize($File)), @CRLF, "|")

;========================================= DateCrackerDL - Menu =====================================
$GUI_Menu = GUICreate("DateCrackerDL - Menu", 310, 135, (@DesktopWidth - 310) / 2, (@DesktopHeight - 117) / 2)

$Menu_About = GUICtrlCreateButton("about", 218, 15, 50,20)
$Menu_Label_1 = GUICtrlCreateLabel("     Version  : " & $Versie & @CRLF & "     Today    : " & $Today, 30, 10, 250, 30, -1, $WS_EX_CLIENTEDGE)
$Menu_Record = GUICtrlCreateButton("Record", 30, 50, 70, 40)
$Menu_Edit = GUICtrlCreateButton("Edit", 120, 50, 70, 40)
$Menu_Run = GUICtrlCreateButton("Run", 210, 50, 70, 40)
$Menu_Stop = GUICtrlCreateButton("S T O P", 30, 100, 250, 20)

;========================================= DateCrackerDL - Record (date) =====================================
$GUI_RecDate = GUICreate("MyGUI", 231, 123, (@DesktopWidth - 231) / 2, (@DesktopHeight - 123) / 2, $Style + $ExStyle)

$RecDate_Label_1 = GUICtrlCreateLabel("Give the date you first installed:", 30, 10, 170, 20)
$RecDate_Date_1 = GUICtrlCreateDate("Date1", 30, 30, 170, 20)
$RecDate_OK = GUICtrlCreateButton("OK", 30, 80, 70, 30)
$RecDate_Stop = GUICtrlCreateButton("Stop", 130, 80, 70, 30)

;========================================= DateCrackerDL - Record (stopbutton) =====================================
$GUI_Record_StopBut = GUICreate("DateCrackerDL", 100, 50, (@DesktopWidth - 120), 20, $Style, $ExStyle)
GUISetBkColor(0x0000000)  ; will change background color

$Record_StopBut = GUICtrlCreateButton("Stop", 20, 5, 60, 40, $ButStyle)
GUICtrlSetImage(-1, "shell32.dll", 27)

;========================================= DateCrackerDL - Record (overview) =====================================
$GUI_Record = GUICreate("DateCrackerDL", 402, 249, (@DesktopWidth - 402) / 2, (@DesktopHeight - 249) / 2)

$Record_Label_0 = GUICtrlCreateLabel( " Today : " & $Today, 220, 10, 160, 20, -1, $WS_EX_CLIENTEDGE)
GUICtrlSetColor(-1, 0xff0000)    ; Red
GUICtrlSetFont(-1, 9, 600)
$Record_Label_1 = GUICtrlCreateLabel("Give a short name for your program:", 30, 35, 200, 20)
$Record_Label_2 = GUICtrlCreateLabel("Date you first installed is set at:", 220, 35, 200, 20)
$Record_Label_3 = GUICtrlCreateLabel("StartUp time is clocked at:  (MilliSeconds)", 30, 90, 200, 20)
Global $Record_Label_4 = GUICtrlCreateLabel($StartupDirectory, 30, 210, 350, 20, -1, $WS_EX_CLIENTEDGE)
Global $Record_Input_1 = GUICtrlCreateInput("ShrtNm", 30, 55, 150, 20)
Global $Record_Input_2 = GUICtrlCreateInput($Sleep, 30, 110, 150, 20)
$Record_Save = GUICtrlCreateButton("Save", 30, 140, 70, 40, $ButStyle)
GUICtrlSetImage(-1, "shell32.dll", 176)
GUICtrlSetState(-1, $GUI_DEFBUTTON)
$Record_Stop = GUICtrlCreateButton("Stop", 130, 140, 70, 40, $ButStyle)
GUICtrlSetImage(-1, "shell32.dll", 27)
$Record_Menu = GUICtrlCreateButton("Menu", 230, 140, 70, 40, $ButStyle)
GUICtrlSetImage(-1, "shell32.dll", 146)
Global $Record_Date_1 = GUICtrlCreateDate($Date2, 220, 55, 160, 20)

;========================================= DateCrackerDL - Run/edit select =====================================
$GUI_RunEdit = GUICreate("DateCrackerDL - Select", 281, 254, (@DesktopWidth - 281) / 2, (@DesktopHeight - 254) / 2)

$RunEdit_Label_1 = GUICtrlCreateLabel("Choose your program :", 20, 20, 140, 20)
$RunEdit_List1 = GUICtrlCreateList("", 20, 40, 140, 200)
GUICtrlSetData(-1, $ProgramName, "")
$RunEdit_Run = GUICtrlCreateButton("Run", 190, 140, 70, 30)
GUICtrlSetState(-1, $GUI_HIDE)
$RunEdit_Edit = GUICtrlCreateButton("Edit", 190, 140, 70, 30)
GUICtrlSetState(-1, $GUI_HIDE)
$RunEdit_Menu = GUICtrlCreateButton("Menu", 190, 170, 70, 30)
$RunEdit_Stop = GUICtrlCreateButton("S T O P", 190, 200, 70, 30)

;========================================= DateCrackerDL - edit =====================================
$GUI_Edit = GUICreate("DateCrackerDL - edit", 402, 249, (@DesktopWidth - 402) / 2, (@DesktopHeight - 249) / 2)

$Edit_Label_0 = GUICtrlCreateLabel( " Today : " & $Today, 220, 10, 160, 20, -1, $WS_EX_CLIENTEDGE)
GUICtrlSetColor(-1, 0xff0000)    ; Red
GUICtrlSetFont(-1, 9, 600)
$Edit_Label_1 = GUICtrlCreateLabel("The short name for your program:", 30, 35, 200, 20)
$Edit_Label_2 = GUICtrlCreateLabel("Date you first installed is set at:", 220, 35, 200, 20)
$Edit_Label_3 = GUICtrlCreateLabel("StartUp time is clocked at:  (MilliSeconds)", 30, 90, 200, 20)
$Edit_Label_4 = GUICtrlCreateLabel($StartupDirectory, 30, 210, 350, 20, -1, $WS_EX_CLIENTEDGE)
$Edit_Label_5 = GUICtrlCreateLabel($ProgramName, 30, 55, 150, 20)
$Edit_Input_2 = GUICtrlCreateInput($Sleep, 30, 110, 150, 20)
$Edit_Save = GUICtrlCreateButton("Save", 30, 140, 70, 40, $ButStyle)
GUICtrlSetImage(-1, "shell32.dll", 176)
GUICtrlSetState(-1, $GUI_DEFBUTTON)
$Edit_Del = GUICtrlCreateButton("Delete", 130, 140, 70, 40, $ButStyle)
GUICtrlSetImage(-1, "shell32.dll", 131)
$Edit_Stop = GUICtrlCreateButton("Stop", 230, 140, 70, 40, $ButStyle)
GUICtrlSetImage(-1, "shell32.dll", 27)
$Edit_Date_1 = GUICtrlCreateDate($Date2, 220, 55, 160, 20)

GUISwitch($GUI_Menu)
GUISetState()


While 1
   $msg = GUIGetMsg()
   Select
      Case $msg = $GUI_EVENT_CLOSE
         ExitLoop
      Case $msg = $Menu_Record
         GUISetState(@SW_HIDE, $GUI_Menu)
         _Record1()
		 
	 Case $msg = $Menu_About
		_About()		
		
      Case $msg = $Menu_Edit
         GUISetState(@SW_HIDE, $GUI_Menu)
         GUISwitch($GUI_RunEdit)
         GUISetState(@SW_SHOW)
         GUICtrlSetState($RunEdit_Edit, $GUI_SHOW)
         
      Case $msg = $Menu_Run
         GUISetState(@SW_HIDE, $GUI_Menu)
         GUISwitch($GUI_RunEdit)
         GUISetState(@SW_SHOW)
         GUICtrlSetState($RunEdit_Run, $GUI_SHOW)
         
      Case $msg = $Record_Menu
         GUISetState(@SW_HIDE, $GUI_Record)
         GUISwitch($GUI_Menu)
         GUISetState(@SW_SHOW)
         
      Case $msg = $Record_Save
         _RecordSave()
         
      Case $msg = $Record_StopBut
         _Record3()
         
      Case $msg = $RecDate_Stop
         SplashOff()
         GUISetState(@SW_HIDE, $GUI_RecDate)
         GUISwitch($GUI_Menu)
         GUISetState(@SW_SHOW)
         
      Case $msg = $RecDate_OK
         SplashOff()
         GUISetState(@SW_HIDE, $GUI_RecDate)
         _Record2()
         
      Case $msg = $RunEdit_Menu
         GUISetState(@SW_HIDE, $GUI_RunEdit)
         GUISwitch($GUI_Menu)
         GUISetState(@SW_SHOW)
         GUICtrlSetState($RunEdit_Run, $GUI_HIDE)
         GUICtrlSetState($RunEdit_Edit, $GUI_HIDE)
         
      Case $msg = $RunEdit_Run
         _Run()
         
      Case $msg = $RunEdit_Edit
         _Edit()
         
      Case $msg = $Edit_Save
         _EditSave()
         
      Case $msg = $Edit_Del
         _EditDelete()
         
      Case $msg = $Menu_Stop
         Exit
      Case $msg = $Record_Stop
         Exit
      Case $msg = $RunEdit_Stop
         Exit
      Case $msg = $Edit_Stop
         Exit
      Case Else
         ;;;
   EndSelect
WEnd
Exit

;=========================================================================================
;=========================================================================================
Func _Record1()
   Global $StartupDirectory = FileOpenDialog($message, "C:\Progra~1\", "Executables (*.exe)", 5)
   ; Check for Cancel in FileOpenDialog
   If $StartupDirectory = 1 Then
      GUISetState(@SW_SHOW)
   Else
   GUISwitch($GUI_RecDate)
   GUISetState(@SW_SHOW)
   SplashTextOn("DateCrackerDL", "After you selected the date in the calendar below press OK to continue." & @CRLF & @CRLF &_
   "After the program has loaded press the STOP button in the UPPER-RIGHT of your screen", 231, 123, (@DesktopWidth - 231) / 2, (@DesktopHeight - 450) / 2, 5, -1, 10)
   EndIf
EndFunc   ;==>_Record1

Func _Record2()
   Global $Begin = TimerInit()
   Global $Date = GUICtrlRead($RecDate_Date_1)
   _DateReplace ($Date, $Date)
   Global $Date2 = _DateReverse ($Date)
   
   RunWait(@ComSpec & " /c date " & $Date, "", @SW_HIDE)
   Run($StartupDirectory)
   
   GUISwitch($GUI_Record_StopBut)
   GUISetState(@SW_SHOW)
EndFunc   ;==>_Record2

Func _Record3()
   GUISetState(@SW_HIDE, $GUI_Record_StopBut)
   Global $Sleep = Int(TimerDiff($Begin) + 2000)
   RunWait(@ComSpec & " /c date " & $Today, "", @SW_HIDE)
   GUISwitch($GUI_Record)
   GUISetState(@SW_SHOW)
   GUICtrlSetData($Record_Input_2, $Sleep)
   GUICtrlSetData($Record_Label_4, $StartupDirectory)
   GUICtrlSetData($Record_Date_1, $Date2)
EndFunc   ;==>_Record3

Func _RecordSave()
   Global $Date = GUICtrlRead($Record_Date_1); get the type value
   ;
   _DateReplace ($Date, $Date)
   ;
   Global $Sleep = GUICtrlRead($Record_Input_2); get the type value
   Global $ProgramName = GUICtrlRead($Record_Input_1); get the type value
   If $ProgramName = "ShrtNm" Then
      MsgBox(48, "DateCrackerDL", "Please give your own ShortName!!!")
   ElseIf StringInStr($ProgramNameChk, $ProgramName) >= 1 Then
      Global $OverWrite = MsgBox(8500, "DateCrackerDL", "This name already Exists!!!" & @CRLF & "Overwrite???.")
      Select
         Case $OverWrite = 6 ;Yes
            _RecordSave2()
         Case $OverWrite = 7 ;No
            ;
      EndSelect
      
   Else
      _RecordSave2()
   EndIf
EndFunc   ;==>_RecordSave

Func _RecordSave2()
   RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\DateCrackerDL\" & $ProgramName, "Date", "REG_SZ", $Date)
   RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\DateCrackerDL\" & $ProgramName, "Sleep", "REG_SZ", $Sleep)
   RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\DateCrackerDL\" & $ProgramName, "StartupDirectory", "REG_SZ", $StartupDirectory)
   
   If $OverWrite <> 6 Then LogFileWrite ($File, $ProgramName & @CRLF)
   
   GUISetState(@SW_HIDE, $GUI_Record)
   GUISwitch($GUI_Menu)
   GUISetState(@SW_SHOW)
   WinActivate("DateCrackerDL")
EndFunc   ;==>_RecordSave2

Func _Run()
   Global $Run = GUICtrlRead($RunEdit_List1); get the type value
   If $Run = "" Then
      MsgBox(0, "", "Please select an item from the list!!!")
   Else
      GUISetState(@SW_HIDE, $GUI_RunEdit)
      $Date = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\DateCrackerDL\" & $Run, "Date")
      $Sleep = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\DateCrackerDL\" & $Run, "Sleep")
      $StartupDirectory = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\DateCrackerDL\" & $Run, "StartupDirectory")
      
      RunWait(@ComSpec & " /c date " & $Date, "", @SW_HIDE)
      Run($StartupDirectory)
      Sleep($Sleep)
      RunWait(@ComSpec & " /c date " & $Today, "", @SW_HIDE)
   EndIf
   Exit
EndFunc   ;==>_Run

Func _Edit()
   Global $Run = GUICtrlRead($RunEdit_List1); get the type value
   If $Run = "" Then
      MsgBox(48, "DateCrackerDL", "Please select an item from the list!!!")
   Else
      Global $ProgramName = $Run
      Global $Date = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\DateCrackerDL\" & $ProgramName, "Date")
      Global $Sleep = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\DateCrackerDL\" & $ProgramName, "Sleep")
      Global $StartupDirectory = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\DateCrackerDL\" & $ProgramName, "StartupDirectory")
      
      Global $Date2 = _DateReverse ($Date)
      
      GUISetState(@SW_HIDE, $GUI_RunEdit)
      GUISwitch($GUI_Edit)
      GUISetState(@SW_SHOW)
      GUICtrlSetData($Edit_Input_2, $Sleep)
      GUICtrlSetData($Edit_Label_4, $StartupDirectory)
      GUICtrlSetData($Edit_Date_1, $Date2)
      GUICtrlSetData($Edit_Label_5, $ProgramName)
   EndIf
EndFunc   ;==>_Edit

Func _EditSave()
   Global $Sleep = GUICtrlRead($Edit_Input_2); get the type value
   Global $Date = GUICtrlRead($Edit_Date_1); get the type value
   _DateReplace ($Date, $Date)
   MsgBox(0, "", $ProgramName & @CRLF & $Sleep & @CRLF & $Date)
   RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\DateCrackerDL\" & $ProgramName, "Date", "REG_SZ", $Date)
   RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\DateCrackerDL\" & $ProgramName, "Sleep", "REG_SZ", $Sleep)
   GUISetState(@SW_HIDE, $GUI_Edit)
   GUISwitch($GUI_Menu)
   GUISetState(@SW_SHOW)
   WinActivate("DateCrackerDL")
EndFunc   ;==>_EditSave

Func _EditDelete()
   $ProgramName2 = StringReplace(FileRead($File, FileGetSize($File)), @CRLF, "|")
   $ProgramName = StringReplace($ProgramName2, $ProgramName & "|", "")
   $ProgramName = StringReplace($ProgramName, "||", "")
   $ProgramName = StringReplace($ProgramName, "|", @CRLF)
   _FileCreate($File)
   LogFileWrite ($File, $ProgramName & @CRLF)
   RegDelete("HKEY_LOCAL_MACHINE\SOFTWARE\DateCrackerDL\" & $Run)
   GUISetState(@SW_HIDE, $GUI_Edit)
   GUISwitch($GUI_Menu)
   GUISetState(@SW_SHOW)
EndFunc   ;==>_EditDelete

Func _About()
MsgBox(64,$Name & " - About and HowTo.","DateCrackerDL is created with Auto-It V3 ( http://www.autoitscript.com )" & @CRLF & "" & @CRLF &_
 "*****************************************************************************************" & @CRLF & "" & @CRLF &_
 "Software:	DateCrackerDL - v." & $Versie&@CRLF &_
 "Author:		DaLiMan" & @CRLF & "" & @CRLF &_
 "*****************************************************************************************" & @CRLF & "" & @CRLF &_
 "THANKS:" & @CRLF &_
 "Special thanks to Jon for creating and giving us Auto-it. ( http://www.autoitscript.com )" & @CRLF &_
 "Also many thanks to all the people who help create / improve and support it." & @CRLF & "" & @CRLF &_
 "INTENDED USE:" & @CRLF & "This program is used for running software wich has a limited time." & @CRLF &_
 "Simply by changing the system-date and then running the software the program will think it's " & @CRLF &_
 "time-limit is not yet reached." & @CRLF & "" & @CRLF &_
 "HOW TO:" & @CRLF &_
 "When you installed a program with such a limited trail-time startup DateCrackerDL." & @CRLF &_
 "From the Menu hit the record button." & @CRLF &_
 "You will be asked for the location of the installed executable and the date when you first installed it." & @CRLF &_
 "DateCrackerDL will now launch this program so the startup-time can be recorded." & @CRLF & "" & @CRLF &_
 "Make sure you hit the STOP button ( which record the time a program needs to startup ) when you are sure" & @CRLF &_
 "the program is fully loaded. Some programs load a splash-screen first behind which the date check still continues." & @CRLF & "" & @CRLF &_
 "After recording a display will be shown with all the specification with which to startup your program." & @CRLF &_
 "Enter a shortname for it and save." & @CRLF & "" & @CRLF &_
 "Next time choose RUN from the menu and select your program." & @CRLF &_
 "DateCrackerDL will automatically change the system date and start your program." & @CRLF & "" & @CRLF &_
 "I made this program for my own use." & @CRLF &_
 "Anyone who wants to use it does so on their own risk." & @CRLF & "" & @CRLF &_
 "After the recorded startup-time the system date wil be set back to the current date." & @CRLF & "" & @CRLF &_
 "Have fun!!!" & @CRLF & "" & @CRLF & "" & @CRLF &_
 "NOTE:" & @CRLF &_
 "Not all software will accept the way DateCrackerDL runs the programs" & @CRLF &_
 "and will continue their countdown!")
EndFunc
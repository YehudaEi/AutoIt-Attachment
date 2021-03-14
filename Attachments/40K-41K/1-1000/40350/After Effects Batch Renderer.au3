;*************************************************************************************************************************************************
;Author: David Stark (davids125@hotmail.com)																									 *
;Date: 5/7/2013																																	 *
;Purpose: To allow users to render multiple After Effects Projects back to back.																 *	
; 																																				 *
;Key Notes:																																		 *
;1. All projects must have render queue set up BEFORE the run button is clicked. Set up the length, output format, and output path beforehand.   *
;2. The path used to run aerender.exe is the default location of aerender when After Effects is installed to it's default location.				 *
;*************************************************************************************************************************************************

#RequireAdmin
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GuiListView.au3>

AutoItSetOption("WinTitleMatchMode", 2)
	;~ Matches windows based on complete window titles.
AutoItSetOption("SendKeyDelay", 20)
	;~ Doubled key delay for slower machines.
AutoItSetOption("MouseCoordMode", 0)
	;~ Initializes all mouse commands with reference to the current active window.
Opt("TrayIconDebug", 1)

;Default location of aerender.exe
Global $AERenderDir = "C:\Program Files\Adobe\Adobe After Effects CS6\Support Files\aerender.exe"

;****GUI Creation****
$GUI = GUICreate("After Effects Batch Renderer", 600, 450)
$Prompt = GUICtrlCreateLabel("Use the Add Project to List button to browse for a project." & @LF & _
   "Select a project and use the Remove Selected Project button to remove it from the list.", 10, 10)
$AddToList = GUICtrlCreateButton("Add Project to List", 10, 60, 180, 40)
$RemoveSelected = GUICtrlCreateButton("Remove Selected Project", 210, 60, 180, 40)
$ClearList = GUICtrlCreateButton("Clear All Projects", 410, 60, 180, 40)
$List = GUICtrlCreateListView("Project Path|Progress|Time", 10, 120, 580, 200)
$MP = GUICtrlCreateCheckbox("Multiprocess", 10, 340)
$Sound = GUICtrlCreateCheckBox("Play sound at each render finish", 10, 360)
$Run = GUICtrlCreateButton("Run", 10, 390, 180, 40)
$Exit = GUICtrlCreateButton("Exit", 210, 390, 180, 40)
;*********************

;Set the width of the column so the whole path can be seen.
_GUICtrlListView_SetColumnWidth($List, 0, 400)
_GUICtrlListView_SetColumnWidth($List, 1, 90)
_GUICtrlListView_SetColumnWidth($List, 2, 85)
GUICtrlSetState($MP, $GUI_CHECKED)
GUICtrlSetState($Sound, $GUI_CHECKED)
GUISetState( @SW_SHOW, $GUI)

;Drop into the loop which controls the GUI
While 1
   ;Read the message from the GUI
   $msg = GUIGetMsg()
   
   Select
   ;If they close the window, exit.
   Case $msg = $GUI_EVENT_CLOSE
	  Exit
   
   ;If they click exit, exit.
   Case $msg == $Exit
	  Exit
   
   ;If they click run.
   Case $msg == $Run
	  ;Get the count of list items.
	  $count = _GUICtrlListView_GetItemCount($List)
	  
	  ;Loop for as many items as there are.
	  For $i = 0 to $count - 1 step 1		 
		 _GUICtrlListView_AddSubItem($List, $i, "Rendering...", 1)
		 
		 ;Builds the basic command line string
		 $ComLineString = $AERenderDir & " -project """ & _GUICtrlListView_GetItemText($List, $i, 0) & """"
		 
		 ;If multipross and play sound is checked then add those to command line.
		 If(GUICtrlRead( $MP ) == $GUI_CHECKED) Then
			$ComLineString = $ComLineString & " -mp"
		 EndIf
		 
		 If(GUICtrlRead( $Sound ) == $GUI_CHECKED) Then
			$ComLineString = $ComLineString & " -sound ON"
		 EndIf
		 
		 ;Splash some text telling which project it is going to render next.
		 SplashTextOn("Rendering " & ($i + 1) & " of " & $count, "Now rendering: " & @LF & _
			_GUICtrlListView_GetItemText($List, $i, 0) & @LF & _
			"The command-line string is: " & @LF & $ComLineString, 900, 200)
			
		 Sleep(8000)
		 SplashOff()
		 
		 $begin = TimerInit()
		 
		 ;Run aerender.exe with the proper command line parameters, when aerender.exe is finished, continue.
		 ;**************************
		 RunWait( $ComLineString  )
		 ;**************************
		 
		 $time = Round(TimerDiff($begin)/60000, 2)
		 _GUICtrlListView_SetItemText($List, $i, "DONE!", 1)
		 _GUICtrlListView_SetItemText($List, $i, $time, 2)
	  Next
		  
	  Beep(400, 250)
	  Beep(500, 250)
	  Beep(600, 250)
	  Beep(700, 250)
   
   ;If they click the add item to list button.
   Case $msg == $AddToList
	  GUICtrlCreateListViewItem(FileOpenDialog("Select a .aep file...", "My Documents", "After Effects (*.aep)"), $List)
   
   ;If they click the remove selected project button.
   Case $msg == $RemoveSelected
	  GUICtrlDelete(GUICtrlRead($List))
   
   ;If they click the clear list button.
   Case $msg == $ClearList
	  _GUICtrlListView_DeleteAllItems($List)
   EndSelect
   
WEnd

;Display a message box saying all renders have been completed.
MsgBox(0,"","All Renders Completed")

;Exit the program.
Exit
;***************************************END OF SCRIPT******************************************************
;***************************************END OF SCRIPT******************************************************
;***************************************END OF SCRIPT******************************************************
;***************************************END OF SCRIPT******************************************************
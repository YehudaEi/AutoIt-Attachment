; toolbox start

;scripting help links
;http://www.autoitscript.com/autoit3/docs/
;http://www.autoitscript.com/autoit3/docs/guiref/GUIRef.htm
;http://www.autoitscript.com/autoit3/docs/functions/GUICreate.htm
;http://www.autoitscript.com/autoit3/docs/appendix/GUIStyles.htm
;http://www.autoitscript.com/autoit3/docs/tutorials/notepad/notepad.htm
;http://www.autoitscript.com/autoit3/docs/intro/windowsadvanced.htm
;http://www.autoitscript.com/autoit3/docs/functions/GUICtrlCreate%20Management.htm

#include <GUIConstantsEx.au3>
#include <ButtonConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

Main() ;run specified function
Func Main() ;function main
   ;define local variables
   Local $WindowWidth, $WindowHeight ;window dimensions
   Local $pad, $sizer ;spaces for the various objects
   Local $TableWidth, $TableHeight	;table dimensions
   Local $GroupWidth, $GroupHeight ;group dimensions
   Local $PositionLat, $Position1Long, $Position2Long, $Position3Long, $Position4Long, $Position5Long, $Position6Long, $Position7Long ;the positions for each group
   Local $Group1Long, $Group2Long, $Group3Long, $Group4Long, $Group5Long, $Group6Long, $Group7Long ;group positions
   Local $ButtonWidth, $ButtonHeight ;button dimensions
   
   Local $ExitButton, $ConfigIntake
   
   Local $msg ;msg needed for when buttons are pressed

   ;now define the values for the variables, nearly all of them are dynamic.
   $WindowWidth = 520
   $WindowHeight = 460
   $pad = 5
   $sizer = 7
   $TableWidth = $WindowWidth-$pad
   $TableHeight = $WindowHeight-10*$pad
   $GroupWidth = $TableWidth-2*$pad
   $GroupHeight = ($TableHeight+$pad)/$sizer
   $PositionLat = $pad
   $Position1Long = 4*$pad
   $Position2Long = $GroupHeight+$Position1Long-$pad
   $Position3Long = $GroupHeight+$Position2Long-$pad
   $Position4Long = $GroupHeight+$Position3Long-$pad
   $Position5Long = $GroupHeight+$Position4Long-$pad
   $Position6Long = $GroupHeight+$Position5Long-$pad
   $Position7Long = $GroupHeight+$Position6Long-$pad
   $Group1Long = $Position1Long
   $Group2Long = $Position2Long
   $Group3Long = $Position3Long
   $Group4Long = $Position4Long
   $Group5Long = $Position5Long
   $Group6Long = $Position6Long
   $Group7Long = $Position7Long
   $ButtonWidth = ($GroupWidth/$sizer)+$pad+2
   $ButtonHeight = $GroupHeight-3*$pad

   ;create the window
   GUICreate("Cigam Automated Technician Toolbox", $WindowWidth, $WindowHeight, -1, -1, $WS_BORDER)
   
   $ExitButton = GUICtrlCreateButton("Exit", $WindowWidth-$pad-$ButtonWidth, $WindowHeight-$pad/2-$ButtonHeight, $ButtonWidth, $ButtonHeight/2)
   
	  ;create a tabbox in the window
	  GUICtrlCreateTab(0, 0, $TableWidth, $TableHeight)
		 ;create the main menu tab
		 GUICtrlCreateTabItem("Main Menu")
			;group1
			GUICtrlCreateGroup("", $PositionLat, $Group1Long, $GroupWidth, $GroupHeight)
			   GUICtrlCreateButton("Run Selected Tasks", $PositionLat+$pad, $Group1Long+2*$pad, $ButtonWidth*2+$pad, $ButtonHeight)
			   GUICtrlCreateLabel("Select from the 6 options below, then push the 'Run Selected Tasks' to start the automated process. It will disable any keyboard/mouse commands until all selected tasks are complete. (Type in the word 'control' to regain keyboard/mouse usage, this will stop the tasks)", $PositionLat+3*$pad+2*$ButtonWidth, $Group1Long+$pad, $GroupWidth-3*$pad-2*$ButtonWidth, $ButtonHeight+2*$pad, $SS_LEFT)
			;group2
			GUICtrlCreateGroup("", $PositionLat, $Group2Long, $GroupWidth, $GroupHeight)
			   GUICtrlCreateCheckbox("(Select to run) Intake Analysis", $PositionLat+$pad, $Group2Long+2*$pad, $ButtonWidth, $ButtonHeight, BitOR($BS_MULTILINE, $BS_PUSHLIKE))
			   $ConfigIntake = GUICtrlCreateButton("Configure the Intake Analysis", $PositionLat+2*$pad+$ButtonWidth, $Group2Long+2*$pad, $ButtonWidth, $ButtonHeight, $BS_MULTILINE)
			   GUICtrlCreateLabel("The intake analysis will scan the computer system for any hardware, malware, software, or known issues. As well as compile a detailed report of recommended changes and/or fixes required to get the computer back to a better condition. (About 15+ minutes needed)", $PositionLat+3*$pad+2*$ButtonWidth, $Group2Long+$pad, $GroupWidth-3*$pad-2*$ButtonWidth, $ButtonHeight+2*$pad, $SS_LEFT)
			;group3
			GUICtrlCreateGroup("", $PositionLat, $Group3Long, $GroupWidth, $GroupHeight)
			   GUICtrlCreateCheckbox("(Select to run) Diagnostics", $PositionLat+$pad, $Group3Long+2*$pad, $ButtonWidth, $ButtonHeight, BitOR($BS_MULTILINE, $BS_PUSHLIKE))
			   GUICtrlCreateButton("Configure the Diagnostics", $PositionLat+2*$pad+$ButtonWidth, $Group3Long+2*$pad, $ButtonWidth, $ButtonHeight, $BS_MULTILINE)
			   GUICtrlCreateLabel("The diagnostics will run through various quality, error, and stress tests to multiple parts of the computer to enusre that all of the hardware is working at correct levels. If not it will provide options to fix/repair/replace the damaged parts. (About 3+ hours needed)", $PositionLat+3*$pad+2*$ButtonWidth, $Group3Long+$pad, $GroupWidth-3*$pad-2*$ButtonWidth, $ButtonHeight+2*$pad, $SS_LEFT)
			;group4
			GUICtrlCreateGroup("", $PositionLat, $Group4Long, $GroupWidth, $GroupHeight)
			   GUICtrlCreateCheckbox("(Select to run) Virus Removal", $PositionLat+$pad, $Group4Long+2*$pad, $ButtonWidth, $ButtonHeight, BitOR($BS_MULTILINE, $BS_PUSHLIKE))
			   GUICtrlCreateButton("Configure the Virus Removal", $PositionLat+2*$pad+$ButtonWidth, $Group4Long+2*$pad, $ButtonWidth, $ButtonHeight, $BS_MULTILINE)
			   GUICtrlCreateLabel("The virus removal scans and removes all forms of malware, including junkware, toolbars, and potentially unneeded programs as well. Using multiple scan engines it should remove all the of the malicious software and files from the computer. (About 2+ hours needed)", $PositionLat+3*$pad+2*$ButtonWidth, $Group4Long+$pad, $GroupWidth-3*$pad-2*$ButtonWidth, $ButtonHeight+2*$pad, $SS_LEFT)
			;group5
			GUICtrlCreateGroup("", $PositionLat, $Group5Long, $GroupWidth, $GroupHeight)
			   GUICtrlCreateCheckbox("(Select to run) System Repair", $PositionLat+$pad, $Group5Long+2*$pad, $ButtonWidth, $ButtonHeight, BitOR($BS_MULTILINE, $BS_PUSHLIKE))
			   GUICtrlCreateButton("Configure the System Repair", $PositionLat+2*$pad+$ButtonWidth, $Group5Long+2*$pad, $ButtonWidth, $ButtonHeight, $BS_MULTILINE)
			   GUICtrlCreateLabel("Numerous system files and essential resources of Windows can become corrupted or not defined, which causes issues or failures. This will repair all or at least most of those files to get the system back to a correct runnable state. (About 1+ hours needed)", $PositionLat+3*$pad+2*$ButtonWidth, $Group5Long+$pad, $GroupWidth-3*$pad-2*$ButtonWidth, $ButtonHeight+2*$pad, $SS_LEFT)
			;group6
			GUICtrlCreateGroup("", $PositionLat, $Group6Long, $GroupWidth, $GroupHeight)
			   GUICtrlCreateCheckbox("(Select to run) PC Tuneup", $PositionLat+$pad, $Group6Long+2*$pad, $ButtonWidth, $ButtonHeight, BitOR($BS_MULTILINE, $BS_PUSHLIKE))
			   GUICtrlCreateButton("Configure the PC Tuneup", $PositionLat+2*$pad+$ButtonWidth, $Group6Long+2*$pad, $ButtonWidth, $ButtonHeight, $BS_MULTILINE)
			   GUICtrlCreateLabel("Clutter and temporary files accumulate on the system as well as a lot of registry errors and drive fragmentation can occur over time. The pc tuneup will help to enhance settings on the system to increase the speed/startup time some. (About 30+ minutes needed)", $PositionLat+3*$pad+2*$ButtonWidth, $Group6Long+$pad, $GroupWidth-3*$pad-2*$ButtonWidth, $ButtonHeight+2*$pad, $SS_LEFT)
			;group7
			GUICtrlCreateGroup("", $PositionLat, $Group7Long, $GroupWidth, $GroupHeight)
			   GUICtrlCreateCheckbox("(Select to run) Final Analysis", $PositionLat+$pad, $Group7Long+2*$pad, $ButtonWidth, $ButtonHeight, BitOR($BS_MULTILINE, $BS_PUSHLIKE))
			   GUICtrlCreateButton("Configure the Final Analysis", $PositionLat+2*$pad+$ButtonWidth, $Group7Long+2*$pad, $ButtonWidth, $ButtonHeight, $BS_MULTILINE)
			   GUICtrlCreateLabel("This final analysis report is like the intake analysis, but also includes extended information from the other full tasks, depending on which of them have been completed. As well as a comparison showing the changes from the intake analysis. (About 15+ minutes needed)", $PositionLat+3*$pad+2*$ButtonWidth, $Group7Long+$pad, $GroupWidth-3*$pad-2*$ButtonWidth, $ButtonHeight+2*$pad, $SS_LEFT)

		 ;create a tab for tools now
		 GUICtrlCreateTabItem("Tools")



   GUISetState() ; display the GUI
   Do
	  $msg = GUIGetMsg()
		 Select
			Case $msg = $ConfigIntake
			   ;MsgBox(0, "You clicked on", "Yes")
			   ConfigIntake()
		 EndSelect
   Until $msg = $ExitButton

EndFunc   ;==>Main

Func ConfigIntake()
   Local $WindowWidth, $WindowHeight ;window dimensions
   Local $pad, $sizer ;spaces for the various objects
   Local $ApplyChanges
   $WindowWidth = 320
   $WindowHeight = 260
   $pad = 5
   $sizer = 7
   GUICreate("Configuration for the Intake Analysis", $WindowWidth, $WindowHeight, -1, -1, $WS_BORDER)
   $ApplyChanges = GUICtrlCreateButton("Apply Changes", 200, 100, 200, 100)
   GUISetState()
   Do
	  $msg = GUIGetMsg()
   Until $msg = $ApplyChanges
EndFunc
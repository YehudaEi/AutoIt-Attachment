#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.10.0
 Author:         Stephane-Herve Pavon

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

; traitement evenementiel
Opt("GuiOnEventMode", 1)
Opt('MustDeclareVars', 1)

#include-once

#include<Misc.au3>
#include <GuiConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListView.au3>
#include <GuiImageList.au3>
#include <WindowsConstants.au3>
#include <TabConstants.au3>
#include <ListViewConstants.au3>
#include <TreeViewConstants.au3>
#include <StaticConstants.au3>
#include <ButtonConstants.au3>

#Include <File.au3>
#Include <Array.au3>

; inclusion of variables and constants
#include "Include/variables.au3"
;#include "Functions/GuiListView.au3"

; inclusion of the main GUI and its functions
#include "GUI/main_gui.au3"
#include "Functions/main_gui_func.au3"

; process monitoring
#include "Functions/process_monitor.au3"
#include "Functions/_ProcessListProperties.au3"
#include "Functions/CPU_stats.au3"
#include "Functions/MEM_stats.au3"
#include "Functions/CPU-MEM_stats.au3"

; no other occurrence must be running
_Singleton ($SOFT_NAME, 0)

;Opt("OnExitFunc", "")

; listing of the processes
$a_ProcessDetails = ProcessListing ()

; display of the window
main_gui()



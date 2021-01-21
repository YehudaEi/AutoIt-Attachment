; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author:         Björn Kaiser <kaiser.bjoern@gmx.net>
;
; Script Function:
;	Template AutoIt script.
;
; ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include "lib\File.au3"
#include "lib\bits.au3"
#include "lib\protocol.au3"
#include "lib\installer.au3"
#include "lib\GuiConstants.au3"
#include "lib\Array.au3"
#include "lib\treeview.au3"

; ----------------------------------------------------------------------------
; Globals
; ----------------------------------------------------------------------------

Dim $basedir = "Z:\autoinst"
Dim $msg = ""
Dim $file = $basedir & "\software.ini"

$g_BITSPath = IniRead (@ScriptDir & "\ini\autoinst.ini","Main","Bitsadmin","Bitsadmin path not set in autoinst.ini")
$g_BITS = $g_BITSPath & "bitsadmin.exe"

; ----------------------------------------------------------------------------

Dim $TreeView = _CreateGUI()

_IniGetSectionNames( $file, $TreeView )

GuiSetState()
While 1
	$msg = GuiGetMsg()
	Select
 	Case $msg = $Button_install
		ExitLoop
 	Case $msg = $Button_repair
		ExitLoop
 	Case $msg = $Button_uninstall	
		ExitLoop
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case Else
		;;;
	EndSelect
WEnd
Exit

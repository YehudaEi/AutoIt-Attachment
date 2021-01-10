#Region ; Created by EzSkinConvert
; ----------------------------------------------------------------
; ***** Code re-written by EzSkinConvert, Created by JScript *****
;
; Author of original EzSkin_1-2-3 code: Valuater
; For personal use only, All Rights Reserved
; Thank you big_daddy and Joscpe
; Thanks to SmOke_N for EnCodeIt
;
; ***** Based on the: EzSkin_1-2-3, ver 1.0.2 - Feb 17, 2007 *****
; ----------------------------------------------------------------
#include "c:\Program Files\AutoIt3\EzSkin\EzSkin.au3"
#include "c:\scripts\autoit3\ToolsGUI\Velox.au3"
#EndRegion ; Created by EzSkinConvert

#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

;~ This is just a simple GUI frontend for my command line tools
;~ __author__ = 'Robin Siebler'
;~ __date__ = '6/20/08'
;~ __version__ = '0.3'

#Region ### START Koda GUI section ### Form=C:\scripts\autoit3\ToolsGUI\ToolsGUI.kxf
$frmTool = EzSkinGuiCreate("Tools GUI", 633, 449, 194, 126)
$grpTools = EzSkin_GUICtrlCreateGroup("Tools", 24, 32, 225, 161)
$radio_1 = EzSkin_GUICtrlCreateRadio("Create ImageList (Picture Viewer)", 40, 48, 185, 17)
$radio_2 = EzSkin_GUICtrlCreateRadio("Get IPs", 40, 69, 89, 17)
$radio_3 = EzSkin_GUICtrlCreateRadio("Route Print", 40, 93, 89, 17)
$radio_4 = EzSkin_GUICtrlCreateRadio("Reboot Servers", 40, 117, 105, 17)
$radio_5 = EzSkin_GUICtrlCreateRadio("SQL Query", 40, 139, 89, 17)
$radio_6 = EzSkin_GUICtrlCreateRadio("Create URL SQL script ", 40, 160, 153, 17)
EzSkin_GUICtrlCreateGroup("", -99, -99, 1, 1)
$lblTools = EzSkin_GUICtrlCreateLabel("Select the tool you wish to use", 24, 8, 148, 17)
$txtInstructions = EzSkin_GUICtrlCreateEdit("", 256, 8, 369, 185, BitOR($ES_AUTOVSCROLL,$ES_AUTOHSCROLL,$ES_WANTRETURN))
EzSkinCtrlSetData(-1, "")
EzSkinCtrlSetState(-1, $GUI_DISABLE)
$lblCmdText = EzSkin_GUICtrlCreateLabel("Command to be used:", 24, 320, 126, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
EzSkinCtrlSetColor(-1, 0xA9D4FF)
$lblCmd = EzSkin_GUICtrlCreateLabel("", 24, 344, 400, 40)
$btnBrowse = EzSkinCreateButton("Browse", 24, 228, 49, 25)
$lblBrowse = EzSkin_GUICtrlCreateLabel("", 80, 232, 201, 17)
$btnExecute = EzSkinCreateButton("Execute", 304, 228, 65, 25)
EzSkinCtrlSetState($btnExecute, $GUI_DISABLE)
$inpFile = EzSkin_GUICtrlCreateInput("", 24, 288, 169, 21)
EzSkinCtrlSetState($inpFile, $GUI_HIDE)
$lblInput = EzSkin_GUICtrlCreateLabel("", 208, 296, 100, 12)
EzSkinCtrlSetState($lblInput, $GUI_HIDE)
$chkAppend = EzSkin_GUICtrlCreateCheckbox("Append to exising file", 24, 200, 145, 17)
EzSkinCtrlSetState($chkAppend, $GUI_HIDE)
EzSkinGUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

;~ VARIABLES 
;~ -----------------------------
;~ variables for radio buttons
$radioval1 = 0    ; We will assume 0 = first radio button selected, 2 = last button
;$radioval2 = 4
$current_radio = -1

;~ help messages
$msg_imagelist = "This script will create a list of all of the JPG files in a given dir and then\r\ncreate an AVS file containing an array using those file names.\r\n\r\nUsage:\r\n\r\n    create_imageList [path]\r\n\r\n    path = directory containing the project\r\n           (images are expected to be in /images)\r\n\r\nExample:\r\n\r\n    create_imageList c:\\AVE\\Sample_Project"
$msg_ips = "This script will get all of the IPs for the machines listed in the serverlist,\r\nsave the IPs in outputfile and open outputfile in notepad.\r\n\r\nUsage:\r\n\r\n    get_all_ips [serverlist] [outputfile]\r\n\r\n    serverlist  = text file containing server name/IP, 1 per line\r\n    outputfile  = text file in which to write the IPs\r\n\r\nExample:\r\n\r\n    get_all_ips d:\\temp\\serverlist.txt d:\\temp\\ips.txt"
$msg_routeprint = "This script will run 'route print' for the machines listed in the serverlist.\r\n\r\nUsage:\r\n\r\n    route_print [serverlist]\r\n\r\n    serverlist = text file containing server name/IP, 1 per line\r\n\r\nExample:\r\n\r\n    route_print d:\\temp\\serverlist.txt"
$msg_reboot = "This script will reboot all of the machines listed in the serverlist.\r\n\r\nUsage:\r\n\r\n    reboot_servers [serverlist]\r\n\r\n    serverlist  = text file containing server name/IP, 1 per line\r\n\r\nExample:\r\n\r\n    reboot_servers d:\\temp\\serverlist.txt"
$msg_sql = "This script will run an SQL query (using the input file), clean up the\r\noutput, and print it to the screen.\r\n\r\nUsage:\r\n\r\n    sql_query.exe [inputfile]\r\n\r\n    inputfile = text file containing the SQL query\r\n	Note:  Example queries can be found in \r\n                ftp://10.200.100.19/Robin/test_tools/SQL_queries"
$msg_url = "This script will take a text file containing URLs (1 per line) and create a \r\nSQL script that can be used to add the URLs to the URL List in SvcMgr.\r\n\r\nUsage:\r\n\r\n    create_url_script.exe [inputfile] [outputfile]\r\n\r\n    inputfile = text file containing 1 URL per line\r\n    outputfile  = SQL script"

;~ tool command
$msg_cmd_imagelist = "create_imageList.exe "
$msg_cmd_ips = "get_all_ips.exe "
$msg_cmd_routeprint = "get_route_print.exe "
$msg_cmd_reboot = "reboot_servers.exe "
$msg_cmd_sql = "sql_query.exe "
$msg_cmd_url = "create_url_script.exe"
$msg_filedlg_1 = "Browse for server list"
$msg_filedlg_2 = "d:\"
$msg_filedlg_3 = "All (*.*)|Text files (*.txt)"

;~ misc controls
$msg_lblbrowse = "Click to browse for "

ControlClick($frmTool, "", $radio_1)

While 1
	$nMsg = EzSkinGuiGetMsg()
	If $radioval1 <> 0 Then
		EzSkinCtrlSetState($chkAppend, $GUI_HIDE)
	EndIf
	If $radioval1 <> 1 Then
		EzSkinCtrlSetState($lblInput, $GUI_HIDE)
		EzSkinCtrlSetState($inpFile, $GUI_HIDE)
		EzSkinCtrlSetData($inpFile, "")
		
	EndIf
	Select
 		Case $nMsg = $GUI_EVENT_CLOSE
   			Exit
		Case $nMsg >= $radio_1 And $nMsg <= $radio_6
			$radioval1 = $nMsg - $radio_1
 			Select
				Case $radioval1 = 0
					disableExecute()
					$cmd = $msg_cmd_imagelist
					$args = "[path]"
   					EzSkinCtrlSetData($txtInstructions, StringFormat($msg_imagelist))
					EzSkinCtrlSetState($chkAppend, $GUI_SHOW)
					EzSkinCtrlSetData($lblCmd,  $cmd & $args)
					EzSkinCtrlSetData($lblBrowse, $msg_lblbrowse & "project path")
   				Case $radioval1 = 1
					disableExecute()
					$cmd = $msg_cmd_ips
					$args = "[serverlist] [outputfile]"
   					EzSkinCtrlSetData($txtInstructions, StringFormat($msg_ips))
					EzSkinCtrlSetData($lblCmd, $cmd & $args)
					EzSkinCtrlSetData($lblBrowse, $msg_lblbrowse & "server list")
   				Case $radioval1 = 2
					disableExecute()
					$cmd = $msg_cmd_routeprint
					$args = "[serverlist]"
   					EzSkinCtrlSetData($txtInstructions, StringFormat($msg_routeprint))
					EzSkinCtrlSetData($lblCmd, $cmd & $args)
					EzSkinCtrlSetData($lblBrowse, $msg_lblbrowse & "server list")
   				Case $radioval1 = 3
					disableExecute()
					$cmd = $msg_cmd_reboot
					$args = "[serverlist]"
   					EzSkinCtrlSetData($txtInstructions, StringFormat($msg_reboot))
					EzSkinCtrlSetData($lblCmd, $cmd & $args)
					EzSkinCtrlSetData($lblBrowse, $msg_lblbrowse & "server list")
   				Case $radioval1 = 4
					disableExecute()
					$cmd = $msg_cmd_sql
					$args = "[input file]"
   					EzSkinCtrlSetData($txtInstructions, StringFormat($msg_sql))
					EzSkinCtrlSetData($lblCmd, $msg_cmd_sql & $args)
					EzSkinCtrlSetData($lblBrowse, $msg_lblbrowse & "input file")
   				Case $radioval1 = 5
					disableExecute()
					$cmd = $msg_cmd_url
					$args = "[inputfile] [outputfile]"
   					EzSkinCtrlSetData($txtInstructions, StringFormat($msg_url))
					EzSkinCtrlSetData($lblCmd, $cmd & $args)
					EzSkinCtrlSetData($lblBrowse, $msg_lblbrowse & "input file")
			EndSelect
		Case $nMsg = $btnBrowse
			Select
				Case $radioval1 = 0
					$folder = FileSelectFolder("Browse for project path", "My Computer", "2", "d:\")
					If StringInStr($folder, " ") Then $folder = '"' & $folder & '"'
					$args = $folder
					EzSkinCtrlSetData($lblCmd, $cmd & $args)
					EzSkinCtrlSetState($btnExecute, $GUI_ENABLE)
				Case $radioval1 = 1
					$file = FileOpenDialog($msg_filedlg_1, $msg_filedlg_2, $msg_filedlg_3)
					If StringInStr($file, " ") Then $file = '"' & $file & '"'
					$args = $file & " [outputfile]"
 					EzSkinCtrlSetData($lblCmd, $cmd & $args)
					EzSkinCtrlSetData($lblInput, "Output filename")
 					EzSkinCtrlSetState($lblInput, $GUI_SHOW)
					EzSkinCtrlSetState($inpFile, $GUI_SHOW)
					ControlFocus($frmTool, "", $inpFile)
 				Case $radioval1 = 2
					$file = FileOpenDialog($msg_filedlg_1, $msg_filedlg_2, $msg_filedlg_3)
					If StringInStr($file, " ") Then $file = '"' & $file & '"'
					$args = $file
 					EzSkinCtrlSetData($lblCmd, $cmd & $args)
					EzSkinCtrlSetState($btnExecute, $GUI_ENABLE)
				Case $radioval1 = 3
					$file = FileOpenDialog($msg_filedlg_1, $msg_filedlg_2, $msg_filedlg_3)
					If StringInStr($file, " ") Then $file = '"' & $file & '"'
					$args = $file
 					EzSkinCtrlSetData($lblCmd, $cmd & $args)
					EzSkinCtrlSetState($btnExecute, $GUI_ENABLE)
				Case $radioval1 = 4
					$file = FileOpenDialog("Browse for input file (SQL query)", @ScriptDir, "SQL Query (*.sql)")
					If StringInStr($file, " ") Then $file = '"' & $file & '"'
					$args = $file
 					EzSkinCtrlSetData($lblCmd, $cmd & $args)
					EzSkinCtrlSetState($btnExecute, $GUI_ENABLE)
				Case $radioval1 = 5
					$file = FileOpenDialog("Browse for input file", @ScriptDir, "All (*.*)|Text files (*.txt)")
					If StringInStr($file, " ") Then $file = '"' & $file & '"'
					$args = $file & " [outputfile]"
 					EzSkinCtrlSetData($lblCmd, $cmd & $args)
					EzSkinCtrlSetData($lblInput, "Output filename")
 					EzSkinCtrlSetState($lblInput, $GUI_SHOW)
					EzSkinCtrlSetState($inpFile, $GUI_SHOW)
					ControlFocus($frmTool, "", $inpFile)			
				EndSelect
		Case $nMsg = $btnExecute
			Run(@ComSpec & " /k echo " & $cmd & $args & Chr(38) & $cmd & $args, @ScriptDir)
			EzSkinCtrlSetState($btnExecute, $GUI_DISABLE)
		Case $nMsg = $inpFile
			Select
				Case $radioval1 = 1
					$out_file =  EzSkinCtrlRead($inpFile)
					If StringInStr($out_file, " ") Then $out_file = '"' & $out_file & '"'
					$args = $file & " " & $out_file
					EzSkinCtrlSetData($lblCmd, $msg_cmd_ips & $args)
					EzSkinCtrlSetState($btnExecute, $GUI_ENABLE)
				Case $radioval1 = 5
					$out_file =  EzSkinCtrlRead($inpFile)
					If StringInStr($out_file, " ") Then $out_file = '"' & $out_file & '"'
					$args = $file & " " & $out_file
					EzSkinCtrlSetData($lblCmd, $msg_cmd_url & $args)
					EzSkinCtrlSetState($btnExecute, $GUI_ENABLE)			
			EndSelect
			Case $nMsg = $chkAppend
				If _IsChecked($chkAppend) Then
					EzSkinCtrlSetData($lblCmd, $msg_cmd_imagelist & "-a " & $args)
				Else
					EzSkinCtrlSetData($lblCmd, $msg_cmd_imagelist & $args)
				EndIf
	EndSelect
WEnd

Func disableExecute()
	if $current_radio <> $radioval1 Then
		EzSkinCtrlSetState($btnExecute, $GUI_DISABLE)
		$current_radio = $radioval1
	EndIf
EndFunc

Func _IsChecked($control)
    Return BitAnd(EzSkinCtrlRead($control),$GUI_CHECKED) = $GUI_CHECKED
EndFunc
#Region;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=Documents and Settings\SLAUGHTER\Desktop\old\tcp\ico\Door.ico
#AutoIt3Wrapper_UseAnsi=y
#EndRegion;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GUIConstants.au3>
#include <Array.au3>
#AutoIt3Wrapper_plugin_funcs = MD5Hash
Opt("TrayAutoPause",0)    ;0=no pause, 1=Pause
Opt("TrayIconDebug", 0);0=no info, 1=debug line info
Opt("TrayIconHide", 1)    ;0=show, 1=hide tray icon
Opt("TrayMenuMode",1)        ;0=append, 1=no default menu, 2=no automatic check, 4=menuitemID  not return
Opt("TrayOnEventMode",0)     ;0=disable, 1=enable
$font="Comic Sans MS"; font for info text

Local $i
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Updater", 600, 450 ); Gui & title name
GUISetBkColor (0x000000); BG color
InetGet("                         ", "logo.jpg", 0); Location of BG jpg
$Pic1 = GUICtrlCreatePic("logo.jpg", 0, 0, 600, 450,2)
$Progress1 = GUICtrlCreateProgress(10, 384, 580, 25,$PBS_SMOOTH)
$Button1 = GUICtrlCreateButton("Play", 10, 416, 100, 25, 0)
$Button2 = GUICtrlCreateButton("Configure", 140, 416, 100, 25, 0); is not working now you can remove it now
$Button3 = GUICtrlCreateButton("Exit", 490, 416, 100, 25, 0)
$myedit =GUICtrlCreateLabel ("Welcome to Paranoja auto updater", 10,356,580,30); Text to show on loader startup in info line
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetColor(-1,0xffffff)
GUICtrlSetFont (-1,12, 400, 1, $font)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
While 1
    $nMsg = GUIGetMsg()
    Switch $nMsg
        Case $GUI_EVENT_CLOSE
            Exit
        Case $Button3
            Exit
        Case $Button1
            get_hash_list()
    EndSwitch
WEnd

;function returns MD5 sum of client side file
func file_hash($file)
$plH = PluginOpen("Loader.dll")
$data = MD5Hash($file, 1, True)
PluginClose($plH)
Return $data
EndFunc

;Downloads MD5 sums and file list
Func get_hash_list()
wlog("Downloading seciuryti data.....")
$rnd = Random(0,999,1)
InetGet("                                    "& $rnd, "image.jpg", 1,1);downloads file & md5 sum in to image.jpg to avoid extra client atention on file. For now this is seciurity isue.
While @InetGetActive
$i = $i +1
if $i > 100 OR $i = 100 then $i=0
GUICtrlSetData ($Progress1,$i)
Sleep(10)
WEnd
GUICtrlSetData ($Progress1,100)
sort_hash_list()
EndFunc


;Compares client side files with recieved data
Func sort_hash_list()
    GUICtrlSetData ($Progress1,0)
    wlog("Sorting up file info")
    Global $Progress1
$data = get_file_text("image.jpg");open downloadaded seciurity info

$file_arr = StringSplit($data, "|")

wlog("Starting system checking.....")
For $a = 1 to $file_arr[0]-1 Step 1
$pszx = 100/($file_arr[0]-1)* $a
GUICtrlSetData ($Progress1,$pszx)
$original_file = StringSplit($file_arr[$a], ":")
$system_hash = file_hash('system/'&$original_file[1]); check files in "loader.exe_root/system" change for your dir. If you whant to chek file in main dir where is loader then revome 'system/'&
wlog('Checking: system/'&$original_file[1]); just gives client info abuot file checking


if $original_file[2] <> $system_hash Then
wlog("File: "&$original_file[1] & " corupted. Atemping to download."& @CRLF)
FileDelete('system/'&$original_file[1])
$size = InetGetSize("                          "&$original_file[1]);location whre is you original required client files. Same loc as you seted in file_list.php
InetGet("                          "&$original_file[1], "system/"&$original_file[1], 1,1); from whre to take Original required client files and whre to save them
While @InetGetActive
$dl_size = 100/ $size * @InetGetBytesRead
GUICtrlSetData ($Progress1,$dl_size)
Sleep(100)
WEnd
EndIf

Next


wlog("Launching game...")
Run("system/l2.exe")
EndFunc



Func get_file_text($file_name)
$file = FileOpen($file_name, 0)
; Check if file opened for reading OK
If $file = -1 Then
    MsgBox(0, "Error", "Unable to open file.")
    Exit
EndIf
$chars = FileRead($file)
FileClose($file)
FileDelete($file)
return $chars
EndFunc

func wlog($Dat)
$log = GUICtrlRead($myedit)
GUICtrlSetData($myedit, $Dat)
EndFunc
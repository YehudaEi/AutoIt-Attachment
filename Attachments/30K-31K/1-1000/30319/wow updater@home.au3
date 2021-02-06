; wow update manager.
; find the wow.exe file get its location.
; check with update list if there is an update.
; if there is get it from a centralized place
; read out Addons folder and copy the addons either way
; programmer: Vincent Tuls
; starting date: 14-02-2010
; last edited: 15-04-2010
#Include <File.au3>
#Include <Array.au3>
#include <GUIConstants.au3>
#include <GuiListView.au3>
#Include <Constants.au3>

$dir = @ScriptDir & "\"
$settings = $dir & "settings.ini"
$updatedb = "updates.txt"
$i = 0
$chk_pt = 0
;$loc2 = IniRead($settings, "variables", "GameLocation","?") & "interface\addons\"
;$LocalArray2= _FileListToArray($loc2, "*",2)
;$serverloc2 = 
Dim $d[100]
global $i, $i2
$g_box= guicreate("Addons",600,700)
$g_list = GUICtrlCreateListView("addons" ,10 ,10 ,580 ,580, 0x0003, 0x00000204)
$g_but_coppy_frmsrv = GUICtrlCreateButton("copy <- server", 10,590,120,30)
$g_but_coppy_tosrv = GUICtrlCreateButton("copy -> server", 130,590,120,30)
Opt("TrayMenuMode",1)   ; Default tray menu items (Script Paused/Exit) will not be shown.
$1 = TrayCreateitem("addons")

if FileExists($settings) = 0 then ;
;getting location
$loc = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Blizzard Entertainment\World of Warcraft", "InstallPath")
;msgbox(0, "wow loc", $loc)
;writing location to settings.ini
IniWrite($dir & "\settings.ini", "variables", "GameLocation",$loc)
$ServerLoc = InputBox("Server Location", "please enter the Path to where you can find the server updates.")
IniWrite($dir & "\settings.ini", "variables", "ServerLocation",$Serverloc)
$check = InputBox("silent or not", "please enter true to run this programm silent or false to show its progress","fals")
IniWrite($dir & "\settings.ini", "variables", "check_silent",$check)
else
;file exists 
$loc = IniRead($settings, "variables", "GameLocation","?")
	if $loc =Not "C:\*.*" then
		$loc = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Blizzard Entertainment\World of Warcraft", "InstallPath")
		IniWrite($dir & "\settings.ini", "variables", "GameLocation",$loc)
	EndIf
$check = IniRead($dir & "\settings.ini", "variables", "check_silent","?")
$serverloc = IniRead($settings, "variables", "ServerLocation","?")
$loc2 = IniRead($settings, "variables", "GameLocation","?") & "interface\addons\"
$serverloc2 = IniRead($settings, "variables", "ServerLocation","?")& "addons\"
TrayTip("location", "got location: " & $loc,2)
EndIf

$loc2 = IniRead($settings, "variables", "GameLocation","?") & "interface\addons\"
$serverloc2 = IniRead($settings, "variables", "ServerLocation","?")& "addons\"

$LocalArray=     _FileListToArray($loc, "wow-*-patch.exe",1)
$ServerArray=    _FileListToArray($Serverloc, "wow-*-patch.exe",1)
; check if there are files in the server Folder
if $ServerArray = 0 then
select
case @error = 1
	msgbox(0,"error", "Server Path not found")
case @error = 2
	msgbox(0,"error", "error 2")
case @error = 3
	msgbox(0,"error", "error 3")
case @error = 4
	msgbox(0,"error", "Server Folder empty")
	call("cppyallsvr")
EndSelect
else	
$size = $LocalArray[0] - $ServerArray[0]
select
case $size = 0
	MsgBox( 0, "up to date","Your wow Folder and server are up to date",3)
case $size > 0
	msgbox(0, "Update For Server", "there is an update on your laptop for the server",3)
	call("Cppysvr")
case $size < 0
	Msgbox(0, "need updates from server", "the folder on server has updates for you",3)
	call("CppyfrmSvr")
EndSelect
endif
;section for copying addons
$serverArray2=  _FileListToArray($Serverloc2, "*",2)
if $serverArray2 = 0 then
select
case @error = 1
	msgbox(0,"error", "Server Path not found")
case @error = 2
	msgbox(0,"error", "error 2")
case @error = 3
	msgbox(0,"error", "error 3")
case @error = 4
	msgbox(0,"error", "Server Folder empty")
	GUICtrlSetState($g_but_coppy_frmsrv, $GUI_DISABLE)
	call("addons1")
EndSelect
else
for $10 = 1 to 6000 step 1
	$msg = TrayGetMsg()
	Select
	Case $msg = $1
		call("addons1")
	EndSelect
next
EndIf
exit

Func Cppyallsvr()
;copy all updates of WOW
ProgressOn("Progress Meter", "copying files", "0 percent")
$i2 = 100 / $localarray[0]
For $i = 1 to $Localarray[0] step 1
if FileExists($ServerLoc & "\" & $LocalArray[$i]) = 0 then
FileCopy($loc & "\" & $LocalArray[$i], $ServerLoc,0)
$i3 = $i2 * $i
ProgressSet($i3, $i &"/" & $localarray[0])
EndIf
next
traytip("Coppy Finished", "All files are coppied to the server",5)
ProgressOff()
sleep(1000)
EndFunc 

Func Cppysvr()
;copy updates of WOW to server
progressOn("Progress Meter", "copying files", "0 percent")
$i2 =  100 / $localarray[0]
For $i = 1 to $Localarray[0] step 1
if FileExists($ServerLoc & "\" & $LocalArray[$i]) = 0 then
FileCopy($loc & "\" & $LocalArray[$i], $ServerLoc,0)
$i3 = $i2 * $i
ProgressSet($i3, $i &"/" & $localarray[0])
EndIf
next
traytip("Coppy Finished", "All files are coppied to the server",5)
ProgressOff()
sleep(1000)
EndFunc 

Func CppyfrmSvr()
;copy all updates of WOW from server
ProgressOn("Progress Meter","copying files" , "0 percent")
$i2 =  100 / $ServerArray[0]
For $i = 1 to $ServerArray[0] step 1
if FileExists($LocalArray & "\" & $ServerLoc[$i]) = 0 then
FileCopy($loc & "\" & $LocalArray[$i], $ServerLoc,0)
$i3 = $i2 * $i
ProgressSet( $i3, $i &"/" & $ServerArray[0])
EndIf
next
traytip("Coppy Finished", "All files are coppied from the server",5)
ProgressOff()
sleep(1000)
EndFunc 

func Addons1()
$LocalArray2=    _FileListToArray($loc2, "*",2)
if $LocalArray2= 0 Then ; local folder error
select
case @error = 1
	msgbox(0,"error", "Local Path not found")
case @error = 2
	msgbox(0,"error", "error 2")
case @error = 3
	msgbox(0,"error", "error 3")
case @error = 4
	msgbox(0,"error", "Local Folder empty") ; programm reads from server location
	GUICtrlSetState($g_but_coppy_tosrv, $GUI_DISABLE)
	for $i = 1 to $serverArray2[0] step 1
	$d[$i]= GUICtrlCreateListViewItem("addons",$g_list)
	GUICtrlSetData($d[$i],$serverArray2[$i])
	Next
EndSelect
else
; program reads from local location
EndIf

for $i = 1 to $LocalArray2[0] step 1
$d[$i]= GUICtrlCreateListViewItem("addons",$g_list)
GUICtrlSetData($d[$i],$LocalArray2[$i])
Next
;GuiCtrlSetState(-1,$GUI_DROPACCEPTED)
Do
  $msg = GuiGetMsg ()
   Select
   Case $msg = $g_but_coppy_tosrv
	  call("adns_to_srv")
	Case $msg = $g_but_coppy_frmsrv
		call("adns_frm_srv")
   EndSelect
Until $msg = $GUI_EVENT_CLOSE
EndFunc

func adns_frm_srv()
ProgressOn("Progress Meter","copying files from Server location" , "0 percent")
		$i4 =  100 / $localarray[0]
		for $i = 1 to $LocalArray2[0] step 1
		  $i2 = $i -1 
		Local $is_Checked = _GUICtrlListViewGetCheckedState ($g_list, $i2)
         If ($is_Checked <> $LV_ERR) Then
            If ($is_Checked) Then
               ;msgbox(0,"Addons", GUICtrlRead($d[$i]) & " Item is Checked")
			   dirCopy($serverloc2[$i], $loc2 & $serverloc2[$i],1)
			   $i3 = $i4 * $i
			   ProgressSet( $i3, $i &"/" & $ServerArray2[0])			   
            Else
               ;msgbox(0,"Addons", GUICtrlRead($d[$i]) & " Item not Checked")
            EndIf
         EndIf
		;MsgBox(0, "addons coppy", ;GUICtrlRead($d[$i]) & " state =" & GUICtrlGetState($d[$i]) )
	Next
	ProgressOff()
	Exit
EndFunc

func adns_to_srv()
	 ProgressOn("Progress Meter","copying files to server location" , "0 percent")
	   $i4 =  100 / $localarray[0]
	   for $i = 1 to $LocalArray2[0] step 1
		  $i2 = $i -1 
		Local $is_Checked = _GUICtrlListViewGetCheckedState ($g_list, $i2)
         If ($is_Checked <> $LV_ERR) Then
            If ($is_Checked) Then
               ;msgbox(0,"Addons", GUICtrlRead($d[$i]) & " Item is Checked")
			   dirCopy($loc2 & $LocalArray2[$i], $serverloc & "\addons\" & $LocalArray2[$i],1)
			   $i3 = $i4 * $i
			   ProgressSet( $i3, $i &"/" & $LocalArray2[0])
            Else
               ;msgbox(0,"Addons", GUICtrlRead($d[$i]) & " Item not Checked")
            EndIf
         EndIf
		 ;MsgBox(0, "addons coppy", ;GUICtrlRead($d[$i]) & " state =" & GUICtrlGetState($d[$i]) )
	 Next
	 ProgressOff()
	Exit
EndFunc
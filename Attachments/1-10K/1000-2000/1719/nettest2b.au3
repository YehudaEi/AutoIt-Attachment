#include <GuiConstants.au3>
#include <File.au3>
Dim $temp, $arr, $count, $arraysize, $arr2, $machinename, $namedisplay, $lengthtemp
Dim $adapter[10][10], $result, $adaptercount, $adapterlist
dim $mac, $ip, $dhcp, $gateway
dim $mainwindow
;do an ipconfig /all to get all basic parms to display
loadup()


Display()

Func Display()
$mainwindow = GUICreate("IP Config",400,500)
Opt("GUICoordMode", 1)
GUISetFont(12, 800,4,"Arial")

GUICtrlCreateLabel ("IP Config Options",  125, 20, 200)
GUISetFont(10, 800,0,"Arial")
$namedisplay= "Computer Name: " & $machinename
GUICtrlCreateLabel ($namedisplay,  100, 40, 200)

GUISetFont(9,400,4,"")
GuiCtrlCreateLabel ( $adaptercount & " Network Adapters Found", 110, 60,150)
GUISetFont(9,400,0,"")
GuiCtrlCreateLabel ("<- Mac Address", 130 ,80, 100)
GuiCtrlCreateLabel ("<- IP Address", 130 ,100, 100)
GuiCtrlCreateLabel ("<- DHCP Enabled -- Server -> ", 130 ,120, 150)
GuiCtrlCreateLabel ("<- Subnet", 130 ,140, 100)
GuiCtrlCreateLabel ("<- Gateway --  DNS Server ->", 130 ,160, 150)
$mac =GuiCtrlCreateLabel ("", 20 ,80, 100,20)
$ip= GuiCtrlCreateLabel ("", 20 ,100, 100,20)
$dhcp= GuiCtrlCreateLabel ("", 20 ,120, 100,20)
$dhcpserver= GuiCtrlCreateLabel ("", 270 ,120, 100,20)
$dnsserver= GuiCtrlCreateLabel ("", 270 ,160, 100,20)
$subnet=GuiCtrlCreateLabel ("", 20 ,140, 100,20)
$gateway=GuiCtrlCreateLabel ("", 20 ,160, 100, 20)
;put in the Do-It buttons
$releaseIP =GUICtrlCreateButton("Release IP", 50, 220, 80)
$renewIP =GUICtrlCreateButton("Renew IP", 135, 220, 80)
$staticIP =GUICtrlCreateButton("Set Static IP", 240, 220, 80)
$dynIP	= GUICtrlCreateButton("Dynamic IP", 240, 250, 80)
$flushdns =GUICtrlCreateButton("Flush DNS", 50, 250, 80)
$registerdns =GUICtrlCreateButton("Register DNS", 135, 250, 80)
$ok = GUICtrlCreateButton("OK", 100, 400, 80)
$Cancel = GUICtrlCreateButton("Cancel/Exit", 180,400,80)



;build the adapter list for the combo box
	$result = ""
		For $n = 0 to ($adaptercount-1)
		$result = $result & $n & "- " & $adapter[$n][1]& "|" 
		next
	$adapterlist = GuiCtrlCreateCombo ( "Adapter", 20, 180, 300, 30)
	GuiCtrlSetData(-1, $result)



GUICtrlSetState(-1,$GUI_CHECKED)



GUISetState()
; Run the GUI until the dialog is closed
While 1
 $result =stringleft (GUICTrlRead($adapterlist),1)
 $msg = GUIGetMsg()
 Select
    Case $msg = -3
       Exit
    Case $msg = $ok
       ExitLoop
    Case $msg = $Cancel
       Exit
    Case $msg = $adapterlist
	$result =stringleft (GUICTrlRead($adapterlist),1)
	$connection = $adapter[$result][0]
	;msgbox (0, "", $connection)
	
	if $result <> "A" then
	GUICTRLSetData ($mac , $adapter[$result][2] )	
	GUICTRLSetData ($ip , $adapter[$result][4] )
	GUICTRLSetData ($dhcp , $adapter[$result][3] )
	GUICTRLSetData ($dhcpserver , $adapter[$result][7] )
	GUICTRLSetData ($dnsserver , $adapter[$result][8] )
	GUICTRLSetData ($subnet , $adapter[$result][5] )
	GUICTRLSetData ($gateway , $adapter[$result][6] )	
	else
	GUICTRLSetData ($mac , "" )	
	GUICTRLSetData ($ip , "" )
	GUICTRLSetData ($dhcp , "" )
	GUICTRLSetData ($subnet , "" )
	GUICTRLSetData ($gateway , "" )
	endif

    Case $msg = $renewIP 
   	$Sel = "/renew"
	getinfo ($sel)
	
    Case $msg = $releaseIP 
   	$Sel = "/release"
	getinfo ($sel)
	loadup ()
   Case $msg = $flushdns 
   	$Sel = "/flushdns"
	getinfo ($sel)
   Case $msg = $registerdns
   	$Sel = "/reregisterdns"
	getinfo ($sel)
case $msg = $staticIP
	 if stringisdigit( $result) Then
; above statement checks that an adapter was actually chosen		
		setstatic($connection)
		 
		 EndIf
	 WinClose( "Set Static IP", "")
	
	
	EndSelect
Wend


GuiDelete()

GetInfo($Sel)
Display()
EndFunc

Func GetInfo($Sel)
$arr = ""

RunWait(@ComSpec & " /c " & "IPCONFIG.EXE " & $Sel & " > " & "IPINFO.TXT", @MyDocumentsDir, @SW_HIDE)
_FileReadToArray(@MyDocumentsDir & "\IPINFO.TXT", $temp )

For $n = 1 to $temp[0]

  $arr = $arr & StringStripWS($temp[$n],4)

Next

MsgBox(0, "IP Configuration Information", "Logged User:" & @UserName & @LF & $arr & @LF & @LF & @LF)
RunWait(@ComSpec & " /c " & "DEL.EXE IPINFO.TXT", @MyDocumentsDir, @SW_HIDE)
EndFunc


Func loadup ()
RunWait(@ComSpec & " /c " & "IPCONFIG.EXE /all"  & " > " & "IPINFO.TXT", @MyDocumentsDir, @SW_HIDE)
_FileReadToArray(@MyDocumentsDir & "\IPINFO.TXT", $temp )
RunWait(@ComSpec & " /c " & "DEL.EXE IPINFO.TXT", @MyDocumentsDir, @SW_HIDE)
;$temp holds all IP info in a text array
$arraysize = ubound($temp)

$arraysize= $arraysize-1
$count =0 ;set up counter for other arrays
$adaptercount = 0 ;setup counter for # of adapters
For $n = 0 to $arraysize
 $temp[$n] = StringStripWS($temp[$n],4)
;locate the machine's name for display
	$result = stringinstr(  $temp[$n], "Host Name") 
	if $result <> 0 then 
	$machinename = stringstripcr(stringmid($temp[$n], 37))
	endif
;process adapter info  1st drop to next line
	$result = stringinstr(  $temp[$n], "Description") 
	if $result = 0 then
 continueloop
	else
	$adaptercount =$adaptercount +1 ; add to adapter count
;	msgbox (0,"", $adaptercount)
;load up the adapter array with info -- some may be bogus
;cycle through list pulling out info



	$adapter[$count][0] =stringstripcr(stringmid($temp[$n-3], 18)) ;connection name
$lengthtemp = stringlen($adapter[$count][0])
$adapter[$count][0]= stringleft( $adapter[$count][0], $lengthtemp-1)
;msgbox (0, "", $adapter[$count][0])

	$adapter[$count][1] = stringstripcr(stringmid($temp[$n], 45))  ;adapter name
	$adapter[$count][2] = stringstripcr(stringmid($temp[$n+1], 45))  ; adpater mac address
	$adapter[$count][3] = stringstripcr(stringmid($temp[$n+2], 45)) ; DHCP enabled yes/no
if $adapter[$count][3] = "Yes" then 
;skip auto configure line for DHCP enabled 

	$adapter[$count][4] = stringstripcr(stringmid($temp[$n+4], 45))  ; adapter IP address
	$adapter[$count][7] = stringstripcr(stringmid($temp[$n+7], 45))   ;adapter DHCP Server
	$adapter[$count][5] = stringstripcr(stringmid($temp[$n+4], 45))   ;adapter subnet mask
	$adapter[$count][6] = stringstripcr(stringmid($temp[$n+5], 45))   ;adapter gateway
	$adapter[$count][8] = stringstripcr(stringmid($temp[$n+7], 45))   ;adapter DNS Server
	;$n= $n +1
;not DHCP is the next stuff
else
	$adapter[$count][4] = stringstripcr(stringmid($temp[$n+3], 45))   ;adapter IP address if not DHCP
	$adapter[$count][7] = "None"  ;NO DHCP SERVER
	$adapter[$count][5] = stringstripcr(stringmid($temp[$n+4], 45))   ;adapter subnet mask
	$adapter[$count][6] = stringstripcr(stringmid($temp[$n+5], 45))   ;adapter gateway
	if $n+6 <= $arraysize Then
		;assume static IP has DNS server
		$adapter[$count][8] = stringstripcr(stringmid($temp[$n+6], 45))   ;adapter DNS Server
	EndIf
endif

	$count= $count +1 
	EndIf
Next
endfunc


func SetStatic ($connection)
	; Script generated by AutoBuilder 0.5 Prototype
dim $ctl
;msgbox(0,"",$connection)
If Not IsDeclared('WS_CLIPSIBLINGS') Then Global $WS_CLIPSIBLINGS = 0x04000000

$staticwindow = GuiCreate("Set Static IP", 392, 316,(@DesktopWidth-392)/2, (@DesktopHeight-316)/2 , $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
GUICtrlCreateLabel( "for " & $connection, 100,30,200,20)
$Input_1 = GuiCtrlCreateInput("192", 120, 90, 40,-1,$es_number)
$Input_2 = GuiCtrlCreateInput("168", 170, 90, 40, -1,$es_number)
$Input_3 = GuiCtrlCreateInput("1", 220, 90, 40, -1,$es_number)
$Input_4 = GuiCtrlCreateInput("99", 270, 90, 40, -1,$es_number)
$Input_5 = GuiCtrlCreateInput("255", 120, 120, 40, -1,$es_number)
$Input_6 = GuiCtrlCreateInput("255", 170, 120, 40, -1,$es_number)
$Input_7 = GuiCtrlCreateInput("255", 220, 120, 40, -1,$es_number)
$Input_8 = GuiCtrlCreateInput("0", 270, 120, 40, -1,$es_number)
$Input_9 = GuiCtrlCreateInput("192", 120, 150, 40, -1,$es_number)
$Input_10 = GuiCtrlCreateInput("168", 170, 150, 40, -1,$es_number)
$Input_11 = GuiCtrlCreateInput("1", 220, 150, 40, -1,$es_number)
$Input_12 = GuiCtrlCreateInput("1", 270, 150, 40, -1,$es_number)
$Input_13 = GuiCtrlCreateInput("192", 120, 180, 40, -1,$es_number)
$Input_14 = GuiCtrlCreateInput("168", 170, 180, 40, -1,$es_number)
$Input_15 = GuiCtrlCreateInput("1", 220, 180, 40, -1,$es_number)
$Input_16 = GuiCtrlCreateInput("1", 270, 180, 40, -1,$es_number)
$Input_17 = GuiCtrlCreateInput("", 120, 210, 40, -1,$es_number)
$Input_18 = GuiCtrlCreateInput("", 170, 210, 40, -1,$es_number)
$Input_19 = GuiCtrlCreateInput("", 220, 210, 40,-1,$es_number)
$Input_20 = GuiCtrlCreateInput("", 270, 210, 40, -1,$es_number)
$Label_21 = GuiCtrlCreateLabel("IP Address", 10, 90, 70, 20)
$Label_22 = GuiCtrlCreateLabel("Subnet Mask", 10, 120, 90, 20)
$Label_23 = GuiCtrlCreateLabel("Gateway", 10, 150, 60, 20)
$Label_24 = GuiCtrlCreateLabel("DSN Server 1", 10, 180, 80, 20)
$Label_25 = GuiCtrlCreateLabel("DNS Server 2", 10, 210, 90, 20)
GUISetFont( 10, 600)
$Label_26 = GuiCtrlCreateLabel("Set Static IP Parameters", 90, 10, 280, 20)
GUISetFont(9,400)
$Label_27 = GuiCtrlCreateLabel("If you don't know all these items, then you probably shouldn't be setting a static IP at this time", 30, 50, 310, 30)
$BtnSetIP = GuiCtrlCreateButton("Set IP", 50, 270, 70, 30)
$btnClose = GuiCtrlCreateButton("Cancel", 270, 270, 80, 30)
GUICtrlSetLimit ($Input_1, 3)
GUICtrlSetLimit ($Input_2, 3)
GUICtrlSetLimit ($Input_3, 3)
GUICtrlSetLimit ($Input_4, 3)
GUICtrlSetLimit ($Input_5, 3)
GUICtrlSetLimit ($Input_6, 3)
GUICtrlSetLimit ($Input_7, 3)
GUICtrlSetLimit ($Input_8, 3)
GUICtrlSetLimit ($Input_9, 3)
GUICtrlSetLimit ($Input_10, 3)
GUICtrlSetLimit ($Input_11, 3)
GUICtrlSetLimit ($Input_12, 3)
GUICtrlSetLimit ($Input_13, 3)
GUICtrlSetLimit ($Input_14, 3)
GUICtrlSetLimit ($Input_15, 3)
GUICtrlSetLimit ($Input_16, 3)
GUICtrlSetLimit ($Input_17, 3)
GUICtrlSetLimit ($Input_18, 3)
GUICtrlSetLimit ($Input_19, 3)
GUICtrlSetLimit ($Input_20, 3)
GUISetFont(9,400)
$warning = GUICtrlCreateLabel ("This does NO checking for valid combinations of parameters", 10, 240,330)



GuiSetState()
While 1
	$msg = GuiGetMsg(1)
	Select
	Case $msg[0] = $GUI_EVENT_CLOSE and $msg[1] =$mainwindow
		ExitLoop
	Case $msg = $btnClose
	   GUISwitch("IP Config")
	   
	  msgbox (0,"","close")
	   ;winsetstate ("Set Static IP", "", @SW_HIDE)
	Case $msg = $BtnSetIP
	$ip = GUICtrlRead($input_1) & "." & GUICtrlRead($input_2) & "." & GUICtrlRead($input_3) & "." & GUICtrlRead($input_4 )
	$subnet = GUICtrlRead($input_5) & "." & GUICtrlRead($input_6) & "." & GUICtrlRead($input_7) & "." & GUICtrlRead($input_8 )
	$gateway = GUICtrlRead($input_9) & "." & GUICtrlRead($input_10) & "." & GUICtrlRead($input_11) & "." & GUICtrlRead($input_12 )
	$dns1 = GUICtrlRead($input_13) & "." & GUICtrlRead($input_14) & "." & GUICtrlRead($input_15) & "." & GUICtrlRead($input_16)
	$dns2 = GUICtrlRead($input_17) & "." & GUICtrlRead($input_18) & "." & GUICtrlRead($input_19) & "." & GUICtrlRead($input_20 )
	
	runwait(@comspec & ' /c netsh interface ip set address "Local Area Connection" static' & " " & $ip & " " & $subnet & " " & $gateway & " 1","")
	run(@comspec & ' /c netsh interface ip set dns "Local Area Connection" static '  & $dns1 & " primary","")
	
	
	
	EndSelect
WEnd
EndFunc
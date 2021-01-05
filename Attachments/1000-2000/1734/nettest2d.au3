#include <GuiConstants.au3>
#include <File.au3>
Dim $temp, $arr, $count, $arraysize, $arr2, $machinename, $namedisplay, $lengthtemp
Dim $adapter[10][10], $result, $adaptercount, $adapterlist
dim $mac, $ip, $dhcp, $gateway
dim $mainwindow, $staticinput[31]
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
$Cancel = GUICtrlCreateButton("Close", 150,470,80)
ShowIPStuff ()  ;builds the STATIC IP controls and then hides them


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
   	$Sel = '/renew "' & $connection & '"' ;only renew the chosen adapter
	
	getinfo ($sel)
	
    Case $msg = $releaseIP 
   	$Sel = '/release "' & $connection & '"' ;only release the chosen adapter
		getinfo ($sel)
		
   Case $msg = $flushdns 
   	$Sel = "/flushdns"
	getinfo ($sel)
	
   Case $msg = $registerdns
   	$Sel = "/reregisterdns"
	getinfo ($sel)
	
	case $msg = $staticIP
	 if stringisdigit( $result) Then
; above statement checks that an adapter was actually chosen		
		for $n = 0 to 30
		guictrlsetstate($staticinput[$n], $gui_show)
		Next
			
	 EndIf
	case $msg = $staticinput[30] 
		for $n = 0 to 30
	guictrlsetstate($staticinput[$n], $gui_hide)
	Next

	case $msg = $staticinput[0] 	
	setstatic ($connection)
	
	case $msg = $dynIP
	setdhcp($connection)
	
	EndSelect
Wend


GuiDelete()

GetInfo($Sel)
Display()
EndFunc

Func GetInfo($Sel)

RunWait(@ComSpec & " /c " & "IPCONFIG.EXE " & $Sel , @MyDocumentsDir, @SW_HIDE)
loadup()
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
	$adapter[$count][5] = stringstripcr(stringmid($temp[$n+5], 45))   ;adapter subnet mask
	$adapter[$count][6] = stringstripcr(stringmid($temp[$n+6], 45))   ;adapter gateway
	$adapter[$count][8] = stringstripcr(stringmid($temp[$n+8], 45))   ;adapter DNS Server
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
;build the strings from the controls
	$ip = GUICtrlRead($staticinput[6]) & "." & GUICtrlRead($staticinput[7]) & "." & GUICtrlRead($staticinput[8]) & "." & GUICtrlRead($staticinput[9])
	$subnet = GUICtrlRead($staticinput[10]) & "." & GUICtrlRead($staticinput[11]) & "." & GUICtrlRead($staticinput[12]) & "." & GUICtrlRead($staticinput[13])
	$gateway = GUICtrlRead($staticinput[14]) & "." & GUICtrlRead($staticinput[15]) & "." & GUICtrlRead($staticinput[16]) & "." & GUICtrlRead($staticinput[17])
	$dns1 = GUICtrlRead($staticinput[18]) & "." & GUICtrlRead($staticinput[19]) & "." & GUICtrlRead($staticinput[20]) & "." & GUICtrlRead($staticinput[21])
	$dns2 = GUICtrlRead($staticinput[22]) & "." & GUICtrlRead($staticinput[23]) & "." & GUICtrlRead($staticinput[24]) & "." & GUICtrlRead($staticinput[25])
	;MsgBox(0,"", $ip)
	runwait(@comspec & ' /c netsh interface ip set address "' & $connection & '" static' & " " & $ip & " " & $subnet & " " & $gateway & " 1","")
	run(@comspec & ' /c netsh interface ip set dns "' & $connection & '" static '  & $dns1 & " primary","")
	
EndFunc

Func SetDHCP($connection)
	runwait(@comspec & ' /c netsh interface ip set address "' & $connection & '" source=dhcp' ,"")
	run(@comspec & ' /c netsh interface ip set dns "' & $connection & '" source=dhcp' ,"")
EndFunc

Func ShowIPStuff ()
	;Create boxes for Static IP Stuff and a couple of buttons
$n=1
$incre = 0
$staticinput[0] = GuiCtrlCreateButton("Set IP Now", 100, 420, 70, 20)
$staticinput[30] = GuiCtrlCreateButton("Cancel Static IP", 180, 420, 90, 20)
$staticinput[1] = GuiCtrlCreateLabel("IP Address", 10, 300, 70, 20)
$staticinput[2] = GuiCtrlCreateLabel("Subnet Mask", 10, 325, 90, 20)
$staticinput[3] = GuiCtrlCreateLabel("Gateway", 10, 350, 70, 20)
$staticinput[4] = GuiCtrlCreateLabel("DSN Server 1", 10, 375, 80, 20)
$staticinput[5] = GuiCtrlCreateLabel("DNS Server 2", 10, 400, 90, 20)

for $n=6 to 24 step 4
	$staticinput[$n] =GuiCtrlCreateInput("192", 100, 300+ $incre, 40,-1,$es_number)
	$staticinput[$n+1] =GuiCtrlCreateInput("168", 150,300+$incre, 40,-1,$es_number)
	$staticinput[$n+2] =GuiCtrlCreateInput("1", 200, 300+$incre, 40,-1,$es_number)
	$staticinput[$n+3] =GuiCtrlCreateInput("1", 250, 300+$incre, 40,-1,$es_number)
	GUICtrlSetLimit ($staticinput[$n], 3)
	GUICtrlSetLimit ($staticinput[$n+1], 3)
	GUICtrlSetLimit ($staticinput[$n+2], 3)
	GUICtrlSetLimit ($staticinput[$n+3], 3)
$incre= $incre + 25
Next
GUICtrlSetData($staticinput[9], 99)
GUICtrlSetData($staticinput[10],255)
GUICtrlSetData($staticinput[11],255)
GUICtrlSetData($staticinput[12],255)
GUICtrlSetData($staticinput[13],0)
;$staticinput[11] = 255
;$staticinput[12] = 255
;$staticinput[13] = 0
	for $n = 0 to 30 ;hide all the static IP controls for now
		guictrlsetstate($staticinput[$n], $gui_hide)
	Next
endfunc
#include <guiconstants.au3>
#include <buttonconstants.au3>
#include <ListboxConstants.au3>
#include <windowsconstants.au3>

dim $data
dim $number
dim $number2
dim $computers
$realcomputers = 0
$computers = $realcomputers
dim $servercreated
dim $acceptarray[1000]
$acceptarray[0] = 0
dim $nametag[1000]
dim $hash
dim $apname
$apname = @scriptname
$apname = StringTrimRight($apname,4)
$admin = 0
$connected = 0

tcpstartup()

GUICreate($apname,400,380)
$tab = guictrlcreatetab(10,10,380,20)
guictrlcreatetabitem("Client")
guictrlcreatelabel("IP:",10,50,100,20)
$ipinput = guictrlcreateinput(@IPAddress1,10,70,180,20)
GUICtrlCreateLabel("PORT:",200,50,100,20)
$portinput = guictrlcreateinput("50000",200,70,180,20)
$list = guictrlcreatelist("Client...",10,100,370,200,bitor($WS_BORDER, $WS_VSCROLL))
$number = 1
$connect = guictrlcreatebutton("CONNECT",10,300,180,30)
$disconnect = GUICtrlCreateButton("DISCONNECT",10,300,180,30)
$message = guictrlcreatebutton("MESSAGE",200,300,180,30)
$remotelogoff = guictrlcreatebutton("LOGOFF",10,340,180,30)
$remoteshutdown = guictrlcreatebutton("SHUTDOWN",200,340,180,30)
guictrlsetstate($remotelogoff,$GUI_DISABLE)
GUICtrlSetState($remoteshutdown,$GUI_DISABLE)
guictrlsetstate($message,$GUI_DISABLE)
GUICtrlSetState($disconnect,$GUI_HIDE)

guictrlcreatetabitem("Server")
guictrlcreatelabel("IP:",10,50,100,20)
$ipinput2 = guictrlcreateinput(@ipaddress1,10,70,180,20)
GUICtrlCreateLabel("PORT:",200,50,100,20)
$portinput2 = guictrlcreateinput("50000",200,70,180,20)
$list2 = guictrlcreatelist("Server...",10,100,370,200,bitor($WS_BORDER, $WS_VSCROLL))
$number2 = 1
$create = guictrlcreatebutton("CREATE",10,300,180,30)
$destroy = guictrlcreatebutton("TERMINATE",10,300,180,30)
guictrlsetstate($destroy,$GUI_HIDE)
$computerslab = GUICtrlCreateLabel("Computers connected: " & $computers,150,15,230,20)

guictrlcreatetabitem("Unlock")
$unlock = guictrlcreatebutton("Unlock",20,40,360,320)

guisetstate()

while 1
   $msg = guigetmsg()
   if $servercreated = 1 Then
	  $accept = tcpaccept($socket)
	  if $accept > -1 then
		 $realcomputers = $realcomputers + 1
		 $computers = $computers + 1
		 $acceptarray[0] = $acceptarray[0] + 1
		 $acceptarray[$acceptarray[0]] = $accept
		 do
			$recv = tcprecv($acceptarray[$acceptarray[0]],100000)
		 until $recv = "-*-identification-*-"
		 do
			$recv = tcprecv($acceptarray[$acceptarray[0]],100000)
		 until $recv <> ""
		 guictrlsetdata($list2,$number2 & ".) " & $recv & " has connected")
		 $number2 = $number2 + 1
		 $nametag[$acceptarray[0]] = $recv
		 guictrlsetdata($computerslab,"Computers connected: " & $computers)
	  EndIf
	  if $computers > 0 then
	      $hash = 0
	      Do
			 $hash = $hash + 1
		     $recv = tcprecv($acceptarray[$hash],100000)
			 if $recv <> "" Then
				if $recv = "-*-shut-down-*-" Then
				   opt("trayiconhide",1)
				   guictrlsetdata($list2,$number2 & ".) Automatic shutdown initiated")
		           $number2 = $number2 + 1
				   msgbox(0+48+4096,"SERVER","Automatic shutdown initiated. In 30 seconds, or if you click OK, this computer will shutdown.",30)
				   shutdown(1)
			    elseif $recv = "-*-log-off-*-" then
				   opt("trayiconhide",1)
				   guictrlsetdata($list2,$number2 & ".) Automatic logoff initiated")
		           $number2 = $number2 + 1
				   msgbox(0+48+4096,"SERVER","Automatic logoff initiated. In 30 seconds, or if you click OK, this computer will log-off.",30)
				   shutdown(0)
				Elseif $recv = "-*-dis-connect-*-" Then
				   guictrlsetdata($list2,$number2 & ".) A computer has disconnected")
		           $number2 = $number2 + 1
				   $computers = $computers - 1
				   guictrlsetdata($computerslab,"Computers connected: " & $computers)
				else
				   guictrlsetdata($list2,$number2 & ".) " & $nametag[$hash] & ": " & $recv)
				   $number2 = $number2 + 1
				EndIf
			 EndIf
	      until $hash = $acceptarray[0]
	   EndIf
   EndIf
   Select
   case $msg = $GUI_EVENT_CLOSE
	  TCPShutdown()
	  exit 0
   case $msg = $create
   guictrlsetdata($list2,$number2 & ".) Opening socket...")
   $number2 = $number2 + 1
   $ip2 = guictrlread($ipinput2)
   $port2 = guictrlread($portinput2)
   $socket = tcplisten($ip2,$port2)
   if $socket = -1 or 0 Then
	  guictrlsetdata($list2,$number2 & ".) Error code: " & @error)
	  $number2 = $number2 + 1
   Else
	  guictrlsetdata($list2,$number2 & ".) Server created")
	  $number2 = $number2 + 1
	  GUICtrlSetState($ipinput2,$GUI_DISABLE)
	  guictrlsetstate($portinput2,$GUI_DISABLE)
	  guictrlsetstate($create,$GUI_HIDE)
	  guictrlsetstate($destroy,$GUI_SHOW)
	  $servercreated = 1
	  guictrlsetdata($computerslab,"Computers connected: " & $computers)
   EndIf
   case $msg = $destroy
   GUICtrlSetData($list2,$number2 & ".) Closing socket...")
   $number2 = $number2 + 1
   $disconnected = TCPCloseSocket($socket)
   if $disconnect = 0 then
	  guictrlsetdata($list2,$number2 & ".) Error code: " & @error)
	  $number2 = $number2 + 1
   Else
	  guictrlsetdata($list2,$number2 & ".) Socket closed")
	  guictrlsetdata($computerslab,"Computers connected: 0")
	  $number2 = $number2 + 1
	  $servercreated = 0
	  GUICtrlSetState($ipinput2,$GUI_ENABLE)
	  guictrlsetstate($portinput2,$GUI_ENABLE)
	  guictrlsetstate($create,$GUI_SHOW)
	  guictrlsetstate($destroy,$GUI_HIDE)
   EndIf
   case $msg = $connect
   guictrlsetdata($list,$number & ".) Attempting to connect...")
   $number = $number+1
   $ip = guictrlread($ipinput)
   $port = guictrlread($portinput)
   $result = tcpconnect($ip,$port)
   sleep(500)
   if $result = -1 or 0 then
	  guictrlsetdata($list,$number & ".) Error code: " & @error)
	  $number = $number + 1
   else
	  guictrlsetdata($list,$number & ".) Verifying ID...")
	  $number = $number+1
	  $sent = tcpsend($result,"-*-identification-*-")
	  if $sent = 0 Then
		 guictrlsetdata($list,$number & ".) Error code: " & @error)
		 $number = $number + 1
	  Else
		 sleep(500)
		 $sent = tcpsend($result,@username)
		 if $sent = 0 then 
			guictrlsetdata($list,$number & ".) Error code: " & @error)
			$number = $number + 1
		 Else
			guictrlsetdata($list,$number & ".) Connected")
			$number = $number + 1
			guictrlsetstate($connect,$GUI_HIDE)
			guictrlsetstate($disconnect,$GUI_SHOW)
	        guictrlsetstate($message,$GUI_ENABLE)
	        GUICtrlSetState($ipinput,$GUI_DISABLE)
			guictrlsetstate($portinput,$GUI_DISABLE)
		    $connected = 1
	        if $admin = 1 Then
			   guictrlsetstate($remotelogoff,$GUI_ENABLE)
			   guictrlsetstate($remoteshutdown,$GUI_ENABLE)
			EndIf
		 EndIf
	  EndIf
   endif
   case $msg = $disconnect
   GUICtrlSetData($list,$number & ".) Disconnecting...")
   $sent = tcpsend($result,"-*-dis-connect-*-")
   if $sent = 0 Then
	  guictrlsetdata($list,$number & ".) Error code: " & @error)
	  $number = $number + 1
   Else
	  guictrlsetstate($connect,$GUI_SHOW)
      guictrlsetstate($disconnect,$GUI_HIDE)
      guictrlsetstate($message,$GUI_DISABLE)
      GUICtrlSetState($ipinput,$GUI_ENABLE)
      GUICtrlSetData($list,$number & ".) Disconnected")
	  $number = $number +1
      guictrlsetstate($portinput,$GUI_ENABLE)
   EndIf
   $number = $number + 1
   case $msg = $message
   $data = inputbox("CLIENT","ENTER DATA")
   guictrlsetdata($list,$number & ".) Sending...")
   $number = $number + 1
   $sent = tcpsend($result,$data)
   if $sent = 0 Then
	  guictrlsetdata($list,$number & ".) Error code: " & @error)
	  $number = $number + 1
   Else
	  guictrlsetdata($list,$number & ".) Message sent successfully")
	  $number = $number + 1
   EndIf
   case $msg = $remotelogoff
   guictrlsetdata($list,$number & ".) Attempting to logoff")
   $number = $number + 1
   $sent = tcpsend($result,"-*-log-off-*-")
   if $sent = 0 Then
	  guictrlsetdata($list,$number & ".) Error code: " & @error)
	  $number = $number + 1
   Else
	  guictrlsetdata($list,$number & ".) Computer logoff initiated")
	  $number = $number + 1
   EndIf
   case $msg = $remoteshutdown
   guictrlsetdata($list,$number & ".) Attempting to shutdown")
   $number = $number + 1
   $sent = tcpsend($result,"-*-shut-down-*-")
   if $sent = 0 Then
	  guictrlsetdata($list,$number & ".) Error code: " & @error)
	  $number = $number + 1
   Else
	  guictrlsetdata($list,$number & ".) Computer shutdown initiated")
	  $number = $number + 1
   EndIf
   case $msg = $unlock
   $passcode = InputBox($apname,"Enter passcode:","","*")
   if $passcode = "systemmodal4096" Then
	  $admin = 1
	  guictrlsetstate($unlock,$GUI_DISABLE)
	  if $connected = 1 Then
		 guictrlsetstate($remotelogoff,$GUI_ENABLE)
	     guictrlsetstate($remoteshutdown,$GUI_ENABLE)
	  EndIf
   Else
	  msgbox(0,$apname,"Incorrect password")
   EndIf
   EndSelect
WEnd
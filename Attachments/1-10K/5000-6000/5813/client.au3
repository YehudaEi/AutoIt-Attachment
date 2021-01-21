; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1.98
; Author:         MrSpacely <Visit www.autoit.com and msg me at the forum>
;
; Script Function:
;	Tcp File transfer client (To show its possible)
;	Client sends file server writes to disk. (also binary)
;	Filesize and name are checked, flow control against network trouble
;	Tested over localhost and over a wifi connection with lots of interference.
;
; ----------------------------------------------------------------------------

;Main Startup Calls
	;-Top calls
		#NoTrayIcon
		;includes
			#include <Misc.au3>
			#include <GUIConstants.au3>
		;
		Opt("TrayIconHide", 1) 
		Opt("GUIOnEventMode", 1)   
	;
	;-Variables
		$IP = @ipaddress1
		$PORT = 31337
		$defaultport = 31337
		$packsize = 4096
		$error = 0
		dim $recvbuffer = ""
		$lastmessage = ""
		$connected = 0
		$lasttimepack = timerinit()
		$lastdiffpack = -1
		$bytessend = 0
		$timer1 = timerinit()
		$transferspeedvar = ""

		$version = "1.1"

		$err = 0
		$HeaderOk = 0
		$packetssend = 0
		$concheck = 0
		$concheck2 = 0

		dim $buttonbrowse,$buttonsend,$editip,$editport,$editfile,$progress1,$labelstatus,$labelprogress,$labellastmsg,$ffullname,$fname,$fsize,$Connect,$filehand
		
				
		;
	;-Functions
		TCPStartup()	
		$dll = DllOpen("user32.dll")
		$mainhandle = MakeWindow($buttonbrowse,$buttonsend,$editip,$editfile,$progress1,$labelstatus,$labelprogress,$labellastmsg,$editport)
		GuiCtrlSetData($editip,@ipaddress1)
		;-OnEvent Definitions (Remember to check if window was created before doing this)
			GUISetOnEvent($GUI_EVENT_CLOSE,"Exitme",$mainhandle)
			GUICtrlSetOnEvent($buttonbrowse,"Browse")
			GUICtrlSetOnEvent($buttonsend,"Sendbutton")
		;
		GuiCtrlSetData($editip,$Ip)
		GuiCtrlSetData($editport,$Port)
;
;Main Loop
	While 1
		if $connected = 1 then
			if $concheck2 = 1 then
				GuiCtrlSetState($editfile,$Gui_disable)
				GuiCtrlSetState($editip,$Gui_disable)
				GuiCtrlSetState($editport,$Gui_disable)
				GuiCtrlSetState($buttonbrowse,$Gui_disable)
				;GuiCtrlSetState($buttonsend,$Gui_disable)
				GuiCtrlSetdata($buttonsend,"Stop!")
				$concheck2 = 0
			endif
			if $concheck = 0 then $concheck = 1
			Sleep(1)
			if timerdiff($timer1) > 250 then
				$transferspeedvar = Transferspeed($lastdiffpack,$packsize)
				$timer1 = timerinit()
			endif
			GuiCtrlSetData($progress1,roundup(100 * (($packetssend * $packsize) / $fsize)))
			GuiCtrlSetData($labelprogress,StringFormat("%   6.1f",round(100*(($packetssend * $packsize) / $fsize),1)) & " % of "  & bytestring($fsize) & " at " & $transferspeedvar)
			GuiCtrlSetData($labelstatus,"Connected");"Connected"
			If $err <> 0 Then GuiCtrlSetData($labelstatus,"Not Connected")
			$recvbuffer = $recvbuffer & TCPRecv($Connect,4096)
			$err = @error
			if $err <> 0 then $connected = 0
			if stringinstr($recvbuffer,"!") then
				$lastmessage = STringregexpreplace($recvbuffer,".*?[!]?([^!]+!\>)","\1")
				$recvbuffer = ""
			endif
			if (NOT ($HeaderOk = 1)) then 
				$checkvar = CheckHeader($lastmessage,$packsize,$version)
				;msgbox(0,"",$packsize)
				if $checkvar = 1 then 
					TCPSend($Connect,"Header:" & $fname & ";" & $fsize & ";HeaderEnd")
				else
					if $checkvar = -1 then TCPSend($Connect,"VersionConflict!")
				endif
			endif
			if $lastmessage == "HeaderOk!" then 
				$HeaderOk = 1 
				$lastmessage = ""
				GuiCtrlSetData($labellastmsg,"File accepted - Transferring...")
				if (int($fsize/$packsize))  >= ($packetssend ) then 
					$bytessend = TcpSend($Connect,FileRead($filehand,$packsize))
				else
					$bytessend = TcpSend($Connect,FileRead($filehand,$fsize-int($packsize*$packetssend)))
				endif
			endif
			if $lastmessage == "Nextpart!" then 
				$packetssend += 1
				$lastmessage = ""
				$lastdiffpack = timerdiff($lasttimepack)
				$lasttimepack = timerinit()				
				if (int($fsize/$packsize))  >= ($packetssend ) then 
					$bytessend = TcpSend($Connect,FileRead($filehand,$packsize))
				else
					$bytessend = TcpSend($Connect,FileRead($filehand,$fsize-int($packsize*$packetssend)))
				endif
			endif
			if $lastmessage = "TransferOk!" then 
				GuiCtrlSetState($progress1,$Gui_hide)
				GuiCtrlSetData($labellastmsg,"Transfer Complete")
				GuiCtrlSetData($labelstatus,"Not Connected")
				$lastmessage = ""
				$connected = 0
				$packetssend = 0
			endif
			if $lastmessage = "Bye!" then 
				GuiCtrlSetState($progress1,$Gui_hide)
				GuiCtrlSetData($labellastmsg,"Version Conflict")
				$lastmessage = ""
				$connected = 0
				$packetssend = 0
			endif
			if $lastmessage = "Serverclosed!" then 
				GuiCtrlSetState($progress1,$Gui_hide)
				GuiCtrlSetData($labellastmsg,"Server Closed")
				$lastmessage = ""
				$connected = 0
				$packetssend = 0
			endif

		else
			sleep(250)
			if $concheck2 <> 1 then $concheck2 = 1
			if $concheck <> 0 then
				Fileclose($filehand)
				$concheck = 0
				$lastmessage = ""
				$connected = 0
				$packetssend = 0
				GuiCtrlSetState($progress1,$Gui_hide)

				GuiCtrlSetState($editfile,$Gui_enable)
				GuiCtrlSetState($editip,$Gui_enable)
				GuiCtrlSetState($editport,$Gui_enable)
				GuiCtrlSetState($buttonbrowse,$Gui_enable)
				;GuiCtrlSetState($buttonsend,$Gui_enable)
				GuiCtrlSetdata($buttonsend,"Send")
	
 				GuiCtrlSetData($labelstatus,"Not Connected")
				GuiCtrlSetData($labelprogress,"")
			endif
		endif				
	Wend
;
;Functions Definitions
	Func Transferspeed($timerdiff,$packetsize)
		if $timerdiff <> -1 then
			Return bytestring( ($packetsize / ($timerdiff / 1000) )) & "/s"
		else 
			Return  "0Kb/s"
		endif
	endfunc
	Func bytestring($inputbytes)
		if $inputbytes < 1024 then return Round($inputbytes) & "b"
		if $inputbytes > 1024 AND $inputbytes < (1024*1024) then return Round($inputbytes/1024,1) & " Kb"
		if $inputbytes > (1024*1024) AND $inputbytes < (1024*1024*1024) then return Round($inputbytes/(1024*1024),1) & " Mb"
		if $inputbytes > (1024*1024*1024) then return Round($inputbytes/(1024*1024*1024),1) & " Gb"
	endfunc
	Func roundup($inputvar)
		if int($inputvar) < $inputvar then 
			return number(int($inputvar) + 1)
		else
			return int($inputvar)
		endif
	endFunc
	Func CheckHeader($RecvString,byref $packetsize,$version1)
		Local $RegExp1 = "Hi\{([0-9]{1,21}\.[0-9]{1,21});([0-9]{1,255})\}!"
		if StringRegExp($RecvString,$RegExp1) then 
			$Header = StringRegExp($RecvString,$RegExp1,1)
			if UBound($header) = 2 then 
				$packetsize = int(number($header[1]))
				if $header[0] <> $version1 then 
					Return -1
				else
					Return 1
				endif
			else
				Return 0
			endif
		else
			Return 0
		endif
	endfunc
	Func Browse()
		Global $fname,$ffullname,$editfile
		$ffullname = FileOpenDialog("Choose File", "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "All Files(*.*)", 3)
		$fname = StringSplit($ffullname, "\")
		$fname = $fname[$fname[0]]
		GuiCtrlSetData($editfile,$ffullname)
	endFunc
	Func Sendbutton()
		global $connected,$fname,$ffullname,$fsize,$HeaderOk,$err,$connected,$lastmessage,$recvbuffer,$Connect,$filehand,$Ip,$Port,$labellastmsg,$packetssend,$progress1,$editip,$buttonsend,$editport
		if $connected = 0 then
			$recvbuffer = ""
			$lastmessage = ""
			$err = 0
			$HeaderOk = 0
			$fsize = 0
			$packetssend = 0
			$Ip = GuiCtrlRead($editip)
			$ffullname = GuiCtrlRead($editfile)
			$readportvar = int(number(guictrlread($editport)))
			if (IsNumber($readportvar) = 1 AND $readportvar < 65536) AND $readportvar > 0 then 
				$Port = $readportvar
			else
				$Port = $defaultport
				guictrlsetdata($editport,$Port)
			endif
			if FileExists($ffullname) = 1 then
				$fsize = FileGetSize($ffullname)
				$Ip =  TCPNameToIP($Ip)
				GuiCtrlSetData($editip,$Ip)
				$Connect = TcpConnect ($Ip, $Port)
				If $Connect = -1 Then 
					GuiCtrlSetData($labellastmsg,"Unable to connect")
				else
					$connected = 1
					GuiCtrlSetState($progress1,$Gui_show)
					$filehand = FileOpen($ffullname,0)
 				endif
			else
				GuiCtrlSetData($labellastmsg,"File does not exist")
			endif
		else 
			$connected = 0 
			GuiCtrlSetData($labellastmsg,"User aborted")
			TcpCloseSocket($Connect)
		endif

	EndFunc
	Func MakeWindow(byref $bbrowse,byref $bsend,byref $eip, byref $efile,byref $prog1,byref $lstatus,byref $lprogress,byref $llastmsg,byref $eport)
		local $g_height = 100
		local $g_width = 354
		local $progresswidth = 75
		local $statusheight = 18
		$winhand1 =  GuiCreate("Tcp Transfer - Client",$g_width,$g_height,300,25)
		GuiCtrlCreateLabel("Server IP Address: ",2,4, 100,18)
		$eip = GuiCtrlCreateInput("",100,2,100,18)
		GuiCtrlCreateLabel("Port: ",202,4,48,18)
		$eport = GuiCtrlCreateInput("",250,2,50,18)
		GuiCtrlCreateLabel("File: ",2,24, 100,18)
		$efile = GuiCtrlCreateInput("",100,22,150,18)
		$bbrowse =  GuiCtrlCreateButton("Browse",252,22,50,18)
		$bsend =  GuiCtrlCreateButton("Send",302,22,50,18)
		$lstatus = GUICtrlCreateLabel ("Not Connected",0,$g_height-$statusheight,$g_width/2,$statusheight,bitor($SS_SIMPLE,$SS_SUNKEN)) 
		$lprogress = GUICtrlCreateLabel ("",$g_width/2,$g_height-$statusheight,$g_width/2,$statusheight,bitor($SS_SIMPLE,$SS_SUNKEN)) 
		GUICtrlCreateLabel ("Last Message: ",2,45,200,18) 
		$llastmsg = GUICtrlCreateLabel ("",2,60,$g_width-4,18,$SS_SIMPLE ) 
		$prog1 = GuiCtrlCreateProgress($g_width/2-$progresswidth-4,$g_height - ( $statusheight-3),$progresswidth,$statusheight-4)
		GuiCtrlSetState($prog1,$Gui_hide)
		Guisetstate (@SW_SHOW,$winhand1) 
		Return $winhand1
	EndFunc
	Func Bitif($inputvar,$inputvar2)
		if $inputvar2 = BitAnd($inputvar,$inputvar2) then 
			Return 1
		else
			Return 0
		Endif
	EndFunc
	Func ReadKey($hexkey,$dll1,$handle1)
		if _IsPressed($hexkey, $dll1) AND BitAnd(WinGetState($handle1),8) then
			Return 1
		else 
			Return 0
		Endif
	EndFunc
	Func CheckLegalFilename($Name1)
		local $lengte = StringLen($Name1)
		If $lengte > 255 then Return 0
		local $regexp1 = '[^;\\/:*?"<>|]{'& $lengte &'}'
		Return StringRegExp($Name1,$regexp1)
	EndFunc		
	
	Func Disconnect($socket1)
		TCPCloseSocket ($socket1)
	EndFunc

	Func Exitme()
		DllClose($dll)
		TCPShutdown()
		exit
	EndFunc

Func Message($MESSAGE)
	MsgBox(64 + 262144, "", $MESSAGE, 3)
	Exit 0
EndFunc   ;==>Message

;
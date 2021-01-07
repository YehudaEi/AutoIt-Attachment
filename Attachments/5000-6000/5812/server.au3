; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1.98
; Author:         MrSpacely <Visit www.autoit.com and msg me at the forum>
;
; Script Function:
;	Tcp File transfer server (To show its possible)
;	Server Writes files to disk wich client sends. (Also binary)
;	Filesize and name are checked, flow control against network trouble
;	Tested over localhost and over a wifi connection with lots of interference
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
		$IP = @IPAddress1
		$PORT = 31337
		$defaultport = 31337
		$Savelocation = @scriptdir & "\Upload\"
		$packsize = 16384
		$error = 0
		
		$version = "1.1"
		$listenon = 1
		$listening = 0
		$accepted = 0
		$accepton = 0
		$headerreceived = 0
		$savefileopened = 0
		$packetsrecved = 0
		$timer1 = 0
		$timer2 = 0
		$Timer3 = 0
		$timer4 = timerinit()
		$completed = 0
		$RecvBufferH = ""
		dim $savefname,$savefsize,$savefile,$buttonlisten,$labelstatus,$progress1,$labelinfo,$editport
		$socketone = -1
		$socketreal = -1
		$RecvBufferI = ""
		$checkcon = 1
		$checkcon2 = 1
		$checkcon3 = 1
		$infovar = ""
		$lasttimepack = timerinit()
		$lastdiffpack = -1


	;
	;-Functions
		DirCreate($Savelocation)
		TCPStartup()	
		$dll = DllOpen("user32.dll")
		DirCreate($Savelocation)
		$mainhandle = MakeWindow($buttonlisten,$labelstatus,$progress1,$labelinfo,$editport,$Port)
		$label1 = GuictrlCreatelabel("",0,0,300,300)
		;-OnEvent Definitions (Remember to check if window was created before doing this)
			GUISetOnEvent($GUI_EVENT_CLOSE,"Exitme",$mainhandle)
			GUICtrlSetOnEvent($buttonlisten,"Listenbutton")
		;
	;
;
;Main Loop
	While 1
		if $accepted = 1 then 
			Sleep(1)
			if $checkcon = 0 then
				$checkcon = 1
				guictrlsetstate($progress1,$GUI_show)	
			endif
		else
			if $listening = 1 then
				sleep(10)
				if $checkcon3 = 0 then
					$checkcon3 = 1
					Guictrlsetdata($labelinfo,"")
				endif
			else
				if $checkcon3 = 1 then
					$checkcon3 = 0
					Guictrlsetdata($labelinfo,"")
				endif
			endif
			sleep(250)	
			Guictrlsetdata($labelinfo,"")
			if $checkcon = 1 then
				$checkcon = 0 
				guictrlsetstate($progress1,$GUI_hide)	
			endif
		endif
		if $listenon = 1 then
			if $checkcon2 = 0 then
				$checkcon2 = 1
				Guictrlsetdata($labelstatus,"Listening")
				guictrlsetstate($editport,$gui_disable)
			endif
		else
			if $checkcon2 = 1 then
				$checkcon2 = 0 
				Guictrlsetdata($labelstatus,"Server Stopped")
				guictrlsetstate($editport,$gui_enable)
			endif
		endif
		;If ReadKey("1B",$dll,$mainhandle) Then Exitme()
		if $listenon = 1 AND $listening = 0 then 
			$readportvar = int(number(guictrlread($editport)))
			if (IsNumber($readportvar) = 1 AND $readportvar < 65536) AND $readportvar > 0 then 
				$Port = $readportvar
			else
				$Port = $defaultport
				guictrlsetdata($editport,$Port)
			endif
			guictrlsetstate($editport,$gui_disable)
			$accepton = 0
			$socketone  = Listen($IP,$PORT)
			if $socketone <> -1 then $listening = 1
			GuiCtrlSetData($labelstatus,"Listening")
			GuiCtrlSetData($buttonlisten,"Stop Server")
		else
			if $listenon = 0 then
				if $socketreal <> -1 then
					TCPSend($socketreal,"ServerClosed!")
					Disconnect($socketreal)
					FileClose($savefile)
				endif
				$headerreceived = 0
				$accepted = 0
				$socketreal = -1
				$savefileopened = 0
				$listening = 0 
				$accepton = 0
				$accepted = 0
				TcpClosesocket($socketone)
				$listenon = -1
				$timer1=0
				$timer2=0
				$timer3=0
			endif
		endif
		if ($listenon = 1 AND $listening = 1) AND $socketone <> -1 then 
			$accepton = 1
		endif
		if ($listenon = 1 AND $listening = 1) AND $socketone = -1 then $listening = 0
		if $accepton = 1 AND $accepted = 0 then 
			$socketreal  = Accept($socketone)
			if $socketreal <> -1 then $accepted = 1
			if $accepted = 1 then GuiCtrlSetData($labelstatus,"Client connected")
			$savefname = "" 
			$savefsize = ""
			$savefile = ""
			$timer1=0
			$timer2=0
			$timer3=0
		endif
		if ($accepton = 1 AND $accepted = 1) AND $socketreal = -1 then $accepted = 0
		if (($accepton = 1 AND $accepted = 1) AND $socketreal <> -1) AND $headerreceived = 0 then 
			if $timer1 = 0 then 
				$timer1 = timerinit()
				$RecvBufferH = ""
			endif
			if $timer2 = 0 then 
				$timer2 = timerinit()
			endif
			$return1 = RecvHeader($socketreal,$Savelocation,$savefname,$savefsize,$packsize,$RecvBufferH) 
			if  $return1 = 1 then 
				$headerreceived = 1
				GuiCtrlSetData($labelstatus,"File accepted")
				$RecvBufferH = ""
			else	
				if $return1  < 1 then 
					if $return1 = -3 then
						TCPSend($socketreal,"Bye!")
						$accepted = 0
						Disconnect($socketreal)
						$socketreal = -1
						$RecvBufferH = ""
						$timer1 = 0
						$timer2 = 0
					else
						$headerreceived = 0
						if timerdiff($timer2) > 500 then
							TCPSend($socketreal,"Hi{" & $version & ";" & $packsize & "}!") ;
							$timer2 = 0
						endif
						if timerdiff($timer1) > 10000 then
							TCPSend($socketreal,"Error_RecvHeader!")
							$accepted = 0
							Disconnect($socketreal)
							GuiCtrlSetData($labelstatus,"Listening")
							$socketreal = -1
							$RecvBufferH = ""
							$timer1 = 0
							$timer2 = 0
						endif
					endif
				else
					$accepted = 0
					Disconnect($socketreal)
					GuiCtrlSetData($labelstatus,"Listening")
					$socketreal = -1
					$RecvBufferH = ""
					$timer1 = 0
					$timer2 = 0
				endif
			endif
		endif
		if (($accepton = 1 AND $accepted = 1) AND $socketreal <> -1) AND $headerreceived = 1 then
			if $savefileopened = 0 then 
				$savefile = Fileopen($Savelocation & $savefname,2) 
				GuiCtrlSetData($labelstatus,"Receiving file")
				$savefileopened = 1
				$packetsrecved = 0
				$completed = 0
			endif
			if $savefile <> -1 then 
				$percentr =roundup(100 * (($packetsrecved * $packsize) / $savefsize))
				GuiCtrlSetData($progress1,$percentr)
				if timerdiff($timer4) > 250 then
					$infovar = "Filename: """ & $savefname & """" & @CRLF & "Filesize: " & bytestring($savefsize) & @CRLF & "Data received: " & bytestring($packetsrecved * $packsize) & @CRLF  
					$infovar &= "Percent received: " & $percentr & " %" & @CRLF & "Transferspeed: " & Transferspeed($lastdiffpack,$packsize) 
					Guictrlsetdata($labelinfo,$infovar)
					$timer4 = timerinit()
				endif
				if $savefileopened = 1 then
					if $timer3 = 0 then 
						$timer3 = timerinit()
						;$RecvBufferI = ""
					endif
					if  int($savefsize/$packsize) = $packetsrecved then
						$lastpackif = $savefsize - (int($savefsize/$packsize) * $packsize)
					else 
						$lastpackif = 0
					endif
					$recvreturn = RecvIt($socketreal,$lastpackif,$packsize,$RecvBufferI)
					;$testvar = Stringlen($RecvBufferI)
					if $recvreturn <> 1 then 
						if timerdiff($timer3) > 5000 then
							$headerreceived = 0
							$accepted = 0
							TCPSend($socketreal,"Timed out please send data!")
							Disconnect($socketreal)
							GuiCtrlSetData($labelstatus,"Listening")
							FileClose($savefile)
							$socketreal = -1
							$savefileopened = 0
							$timer3 =0
						endif
					else
						FileWrite($savefile,$RecvBufferI)
						$packetsrecved += 1
						$timer3 =0 
						;msgbox(0,"",int($savefsize/$packsize) & " " & $packetsrecved)
						if int($savefsize/$packsize) >= $packetsrecved then
							TCPSend($socketreal,"Nextpart!")
							$lastdiffpack = timerdiff($lasttimepack)
							$lasttimepack = timerinit()		
						else
							$completed = 1
						endif
						$RecvBufferI = ""
						;$testvar=1
					endif
					if $completed = 1 then
						TCPSend($socketreal,"TransferOk!")
						;msgbox(0,"",FileGetSize($Savelocation & $savefname))
						$completed = 0
						$headerreceived = 0
						$accepted = 0
						;sleep(1000)
						Disconnect($socketreal)
						GuiCtrlSetData($labelstatus,"Listening")
						FileClose($savefile)
						$socketreal = -1
						$savefileopened = 0
					endif
				else
					$headerreceived = 0
					$accepted = 0
					TCPSend($socketreal,"ServerError1!")
					Disconnect($socketreal)
					GuiCtrlSetData($labelstatus,"Listening")
					$socketreal = -1
					$savefileopened = 0
				endif
			else
				$headerreceived = 0
				$accepted = 0
				TCPSend($socketreal,"ServerError2!")
				Disconnect($socketreal)
				GuiCtrlSetData($labelstatus,"Listening")
				$socketreal = -1
				$savefileopened = 0
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

	Func Listenbutton()
		Global $listenon,$buttonlisten,$socketreal,$socketone
		if $listenon = 1 then
			GuiCtrlSetData($buttonlisten,"Start server")
			$listenon = 0
		else
			;GuiCtrlSetData($buttonlisten,"Stop server!")
			$listenon = 1
		endif
	endFunc
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
	Func MakeWindow(byref $blisten,byref $lstatus,byref $prog1,byref $linfo,byref $eport,$Port1)
		local $g_height = 200
		local $g_width = 300	
		local $statusheight = 18
		$winhand1 = GUICreate( "Tcp Transfer - Server" ,$g_width,$g_height, 0, 0)
		$blisten = GuiCtrlCreateButton("Start server",75,2,150,18)
		GuictrlCreateLabel("Port: ",227,4,20,18)
		$eport = GuiCtrlCreateinput($Port1,250,2,45,18)
		$linfo =  GUICtrlCreateLabel ("",2,24,296,130,$SS_Sunken) 
		$lstatus = GUICtrlCreateLabel ("Not Connected",0,$g_height-$statusheight,$g_width,$statusheight,bitor($SS_SIMPLE,$SS_SUNKEN)) 
		$prog1 = GuiCtrlCreateProgress(2,160,$g_width-4,$statusheight)
		guictrlsetstate($prog1,$gui_hide)
		GUISetState (@SW_SHOW,$winhand1) 
		Return $winhand1
	Endfunc

	Func Sendit()
	EndFunc

	Func RecvIt($socket1,$lastpack,$packetsize1,byref $RecvBuffer)
		$bytesrecv = StringLen($RecvBuffer)
		if $lastpack < 1 then 
			$RecvBuffer = $RecvBuffer & TCPRecv($socket1,$packetsize1 - $bytesrecv)
			if (StringLen($RecvBuffer) >= $packetsize1) then
				Return 1
			else
				Return 0
			endif
		else
			$RecvBuffer = $RecvBuffer & TCPRecv($socket1,$lastpack - $bytesrecv)
			if (StringLen($RecvBuffer) >= $lastpack) then
				Return 1
			else
				Return 0
			endif
		endif
		
	EndFunc
	Func RecvHeader($socket1,$Location1,byref $fname1,byref $fsize1,$packetsize1,byref $RecvBuffer)
		Local $fname,$fsize
		$RecvBuffer =  $RecvBuffer & TCPRecv($socket1,$packetsize1)
		if $RecvBuffer <> "" then 
				$CheckedHeader = CheckHeader($RecvBuffer,$Location1,$fname,$fsize)
				if $CheckedHeader = 1 then
					$fname1 = $fname
					$fsize1 = $fsize
					TCPSend($socket1,"HeaderOk!")
					Return 1
				else
					if $CheckedHeader = -1 then TCPSend($socket1,"ErrorInFilename!")
					if $CheckedHeader = -2 then TCPSend($socket1,"FileTooBig!")
					Return $CheckedHeader
				endif
		else
			;TCPSend($socket1,"Error_RecvHeader!")
			;Disconnect($socket1)
			Return 0
		endif
	EndFunc
	Func CheckHeader($RecvString,$location,byref $Filename1,byref $FileSize1)
		Local $RegExp1 = "Header:(.*?);([0-9]{1,255});HeaderEnd"
		if StringRegExp($RecvString,$RegExp1) then 
			$Header = StringRegExp($RecvString,$RegExp1,1)
			if UBound($header) = 2 then 
				if CheckLegalFilename($header[0]) <> 1 then 
					Return -1
				else
					if CheckFreeSpace(Number($Header[1]),$location) then
						$FileSize1 = Number($Header[1])
						$FileName1 = $Header[0]
						Return 1
					else
						Return -2
					endif
				endif
			else
				Return 0
			endif
		else
			if ($RecvString = "VersionConflict!") then 
				;msgbox(0,"",$RecvString)
				Return -3
			else 
				Return 0
			endif
		endif
			
	EndFunc
	Func CheckLegalFilename($Name1)
		local $lengte = StringLen($Name1)
		If $lengte > 255 then Return 0
		local $regexp1 = '[^;\\/:*?"<>|]{'& $lengte &'}'
		Return StringRegExp($Name1,$regexp1)
	EndFunc		
	Func CheckFreeSpace($Size,$Location)
		if ((DriveSpaceFree($Location)*1024)*1024) > $Size then 
			Return 1
		Else
			Return 0
		Endif
	EndFunc
	Func Listen($ip1,$port1)
		Return TCPListen($ip1,$port1,0)
	EndFunc

	Func Accept($socket1)
		$returnval = TCPAccept($socket1)
		if $returnval <> -1 then 
			Return $returnval
		else 
			Return -1
		endif
	EndFunc

	Func Disconnect($socket1)
		TCPCloseSocket ($socket1)
	EndFunc

	Func Exitme()
		DllClose($dll)
		TCPShutdown()
		exit
	EndFunc
;
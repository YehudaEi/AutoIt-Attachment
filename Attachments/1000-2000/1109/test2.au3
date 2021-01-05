Global Const $SV_TYPE_WORKSTATION = 0x00000001
Global Const $SV_TYPE_SERVER = 0x00000002
Global Const $SV_TYPE_SQLSERVER = 0x00000004
Global Const $SV_TYPE_DOMAIN_CTRL = 0x00000008
Global Const $SV_TYPE_DOMAIN_BAKCTRL = 0x00000010
Global Const $SV_TYPE_TIME_SOURCE = 0x00000020
Global Const $SV_TYPE_AFP = 0x00000040
Global Const $SV_TYPE_NOVELL = 0x00000080
Global Const $SV_TYPE_DOMAIN_MEMBER = 0x00000100
Global Const $SV_TYPE_PRINTQ_SERVER = 0x00000200
Global Const $SV_TYPE_DIALIN_SERVER = 0x00000400
Global Const $SV_TYPE_XENIX_SERVER = 0x00000800
Global Const $SV_TYPE_SERVER_UNIX = $SV_TYPE_XENIX_SERVER
Global Const $SV_TYPE_NT = 0x00001000
Global Const $SV_TYPE_WFW = 0x00002000
Global Const $SV_TYPE_SERVER_MFPN = 0x00004000
Global Const $SV_TYPE_SERVER_NT = 0x00008000
Global Const $SV_TYPE_POTENTIAL_BROWSER = 0x00010000
Global Const $SV_TYPE_BACKUP_BROWSER = 0x00020000
Global Const $SV_TYPE_MASTER_BROWSER = 0x00040000
Global Const $SV_TYPE_DOMAIN_MASTER = 0x00080000
Global Const $SV_TYPE_SERVER_OSF = 0x00100000
Global Const $SV_TYPE_SERVER_VMS = 0x00200000
; Windows95 and above
Global Const $SV_TYPE_WINDOWS = 0x00400000
; Root of a DFS tree
Global Const $SV_TYPE_DFS = 0x00800000
; NT Cluster
Global Const $SV_TYPE_CLUSTER_NT = 0x01000000
; Terminal Server(Hydra)
Global Const $SV_TYPE_TERMINALSERVER = 0x02000000
; NT Cluster Virtual Server Name
Global Const $SV_TYPE_CLUSTER_VS_NT = 0x04000000
; Return local list only
Global Const $SV_TYPE_LOCAL_LIST_ONLY = 0x40000000
Global Const $SV_TYPE_DOMAIN_ENUM = 0x80000000
Global Const $SV_TYPE_ALL = 0xFFFFFFFF

Dim $aDllRet, $aServers, $aVersions, $aTypes, $i, $x

; Method 1 find all machines and return their info as 3 separate strings with each entry
; separated by a @LF character. DllCall string buffers are limited to 64K only

; Function Name:	NetView
; Description:		Enumerate all machines of the specified type that are visible in a domain
; Parameter(s):  	Type (long) - machine type
;					Domain (str) - domain name. NULL for current domain
;					Servers (str) - returned buffer containing machine names
;					Versions (str) - returned buffer containing machine versions
;					Types (str)	- returned buffer containing machine types
; Requirement(s):	None
; Return Value(s):	Number of machines found (long)
; Note:				Buffers are limited to 64K in size by DllCall. 
;					This roughly equates to a maximum of about 3110 machines 
;					Each value in the returned buffers is separated by a linefeed (@LF)

$x = TimerInit()
$aDllRet = DllCall("au3xtratest.dll", "long", "NetView", _
                   "long", $SV_TYPE_SERVER_NT, _
                   "int", 0, _ 
				   "str", "", _ 
				   "str", "", _ 
				   "str", "")
If Not @error And $aDllRet[0] > 0 Then
	$aServers = StringSplit($aDllRet[3], @LF)
	$aVersions = StringSplit($aDllRet[4], @LF)
	$aTypes = StringSplit($aDllRet[5], @LF)
	ConsoleWrite("****************" & @LF)
	ConsoleWrite("*** METHOD 1 ***" & @LF)
	ConsoleWrite("****************" & @LF)
	For $i = 1 To $aServers[0]
		ConsoleWrite("Machine Name: " & $aServers[$i] & @LF)
		ConsoleWrite("Machine OS: " & $aVersions[$i] & @LF)
		ConsoleWrite("Machine Type: " & _GetMachineType($aTypes[$i]) & @LF)
	Next
	ConsoleWrite("TOTAL ENTRIES: " & $aDllRet[0] & @LF)
	$x = TimerDiff($x)
	ConsoleWrite("ELAPSED TIME: " & $x & @LF)
	ConsoleWrite("****************" & @LF & @LF)
EndIf

; Method 2 find all machines using NetViewFind. Enumerate each entry by
; calling NetViewEnum in a loop. Call NetViewClose to free allocated memory
; and clean up

; Function Name:	NetViewFind
; Description:		Find all machines of the specified type that are visible in a domain
; Parameter(s):		Type (long) - machine type
;					Domain (str) - domain name. "int", 0 for current domain
; Return Value(s):	Number of machines found (long)

; Function Name:	NetViewEnum
; Description:		Enumerate machines found using NetViewFind
; Parameter(s):		Server (str) - machine name
;					Version (str) - machine version
;					Type (long_ptr) - machine type
; Return Value(s):	Number of machines left to enumerate (long)

; Function Name:	NetViewClose
; Description:		Free machine list buffer and clean up
; Parameter(s):		None
; Return Value(s):	None

Dim $hAU3Xtra

$x = TimerInit()
$hAU3Xtra = DllOpen("au3xtratest.dll")
If $hAU3Xtra > -1 Then
	$aDllRet = DllCall($hAU3Xtra, "long", "NetViewFind", _ 
					   "long", $SV_TYPE_SERVER_NT, _ 
					   "int", 0)
	If Not @error And $aDllRet[0] > 0 Then
		ConsoleWrite("****************" & @LF)
		ConsoleWrite("*** METHOD 2 ***" & @LF)
		ConsoleWrite("****************" & @LF)
		$i = 0
		While $aDllRet[0] > 0
			$aDllRet = DllCall($hAU3Xtra, "long", "NetViewEnum", _ 
							   "str", "", _ 
							   "str", "", _ 
							   "long_ptr", 0)
			If @error Then 
				MsgBox(262144,'debug line ~89' , '@error:' & @lf & @error) ;### Debug MSGBOX				
				ExitLoop
			EndIf
			ConsoleWrite("Machine Name: " & $aDllRet[1] & @LF)
			ConsoleWrite("Machine OS: " & $aDllRet[2] & @LF)
			ConsoleWrite("Machine Type: " & _GetMachineType($aDllRet[3]) & @LF)
			$i = $i+1
		WEnd
		ConsoleWrite("TOTAL ENTRIES: " & $i & @LF)
		$x = TimerDiff($x)
		ConsoleWrite("ELAPSED TIME: " & $x & @LF)
		ConsoleWrite("****************" & @LF)
	EndIf
	DllCall($hAU3Xtra, "none", "NetViewClose")
	DllClose($hAU3Xtra)
EndIf

Func _GetMachineType($nTypeID)
	Local $sMachineType = ""
	
	If BitAND($nTypeID, $SV_TYPE_WORKSTATION) Then _ 
		$sMachineType = $sMachineType & "A LAN Manager workstation/"
	If BitAND($nTypeID, $SV_TYPE_SERVER) Then _ 
		$sMachineType = $sMachineType & "A LAN Manager server/"
	If BitAND($nTypeID, $SV_TYPE_SQLSERVER) Then _ 
		$sMachineType = $sMachineType & "Any server running with Microsoft SQL Server/"
	If BitAND($nTypeID, $SV_TYPE_DOMAIN_CTRL) Then _ 
		$sMachineType = $sMachineType & "Primary domain controller/"
	If BitAND($nTypeID, $SV_TYPE_DOMAIN_BAKCTRL) Then _ 
		$sMachineType = $sMachineType & "Backup domain controller/" 
	If BitAND($nTypeID, $SV_TYPE_TIME_SOURCE) Then _ 
		$sMachineType = $sMachineType & "Server running the Timesource service/"
	If BitAND($nTypeID, $SV_TYPE_AFP) Then _ 
		$sMachineType = $sMachineType & "Apple File Protocol server/"
	If BitAND($nTypeID, $SV_TYPE_NOVELL) Then _ 
		$sMachineType = $sMachineType & "Novell server/"
	If BitAND($nTypeID, $SV_TYPE_DOMAIN_MEMBER) Then _ 
		$sMachineType = $sMachineType & "LAN Manager 2.x domain member/"
	If BitAND($nTypeID, $SV_TYPE_LOCAL_LIST_ONLY) Then _ 
		$sMachineType = $sMachineType & "Servers maintained by the browser/"
	If BitAND($nTypeID, $SV_TYPE_PRINTQ_SERVER) Then _ 
		$sMachineType = $sMachineType & "Server sharing print queue/"
	If BitAND($nTypeID, $SV_TYPE_DIALIN_SERVER) Then _ 
		$sMachineType = $sMachineType & "Server running dial-in service/"
	If BitAND($nTypeID, $SV_TYPE_XENIX_SERVER) Then _ 
		$sMachineType = $sMachineType & "Xenix server/"
	If BitAND($nTypeID, $SV_TYPE_SERVER_MFPN) Then _ 
		$sMachineType = $sMachineType & "Microsoft File and Print for NetWare/"
	If BitAND($nTypeID, $SV_TYPE_NT) Then _ 
		$sMachineType = $sMachineType & "Windows Server 2003, Windows XP, Windows 2000, or Windows NT/"
	If BitAND($nTypeID, $SV_TYPE_WFW) Then _ 
		$sMachineType = $sMachineType & "Server running Windows for Workgroups/"
	If BitAND($nTypeID, $SV_TYPE_SERVER_NT) Then _ 
		$sMachineType = $sMachineType & "Windows Server 2003, Windows 2000 server, or Windows NT server that is not a domain controller/"
	If BitAND($nTypeID, $SV_TYPE_POTENTIAL_BROWSER) Then _ 
		$sMachineType = $sMachineType & "Server that can run the browser service/"
	If BitAND($nTypeID, $SV_TYPE_BACKUP_BROWSER) Then _ 
		$sMachineType = $sMachineType & "Server running a browser service as backup/"
	If BitAND($nTypeID, $SV_TYPE_MASTER_BROWSER) Then _ 
		$sMachineType = $sMachineType & "Server running the master browser service/"
	If BitAND($nTypeID, $SV_TYPE_DOMAIN_MASTER) Then _ 
		$sMachineType = $sMachineType & "Server running the domain master browser/"
	If BitAND($nTypeID, $SV_TYPE_DOMAIN_ENUM) Then _ 
		$sMachineType = $sMachineType & "Primary domain/"
	If BitAND($nTypeID, $SV_TYPE_WINDOWS) Then _ 
		$sMachineType = $sMachineType & "Windows Me, Windows 98, or Windows 95/"
	If BitAND($nTypeID, $SV_TYPE_ALL) Then _ 
		$sMachineType = $sMachineType & "All servers/"
	If BitAND($nTypeID, $SV_TYPE_TERMINALSERVER) Then _ 
		$sMachineType = $sMachineType & "Terminal Server/"
	If BitAND($nTypeID, $SV_TYPE_CLUSTER_NT) Then _ 
		$sMachineType = $sMachineType & "Server clusters available in the domain/"
	If BitAND($nTypeID, $SV_TYPE_CLUSTER_VS_NT) Then _ 
		$sMachineType = $sMachineType & "Cluster virtual servers available in the domain/"
	If StringRight($sMachineType, 1) = "/" Then
		Return StringTrimRight($sMachineType, 1)
	Else
		Return $sMachineType
	EndIf
EndFunc

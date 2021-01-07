;==============================================================================
; Function: 	_createWebSite
; Purpose: 		To add virtual web servers in IIS5 or IIS6
;				 on Windows 2000 or 2003 server
; Parameters: All are
;			
;			$IPAddress1: 	The IP address for the new web server
;			$PortNum1: 		The server port - default 80
;			$HostName1:		Host headers for the new server
;							 (comma separated list)
;			$RootDirectory1: The physical root directory of the web site
;							  (must exist first!)
;			$ServerComment1: The site name displayed within IIS MMC
;			$Start1:		1 or 0 - start the new server after creation
;
; Returns: 1 for successful creation
;
;		Author:		Bill Mezian (billmez), converted from VB script
;==============================================================================


; Examples:
$IPAddress1 = "192.168.0.3"
$PortNum1 = 80
$HostName1 = "company.com,www.company.com"
$RootDirectory1 = "C:\siteroot\newsite"
$ServerComment1 = "New Web Site"
$Start1 = 0

_CreateWebSite($IPAddress1, $RootDirectory1, $ServerComment1, $HostName1, $PortNum1, $Start1)

Func _CreateWebSite($IPAddress, $RootDirectory, $ServerComment, $HostName, $PortNum = 80, $Start = 0)
Dim $NewBindings[1]
$HostNames = StringSplit($HostName,",")
$w3svc = ObjGet("IIS://" & @ComputerName & "/w3svc")
		If @error <> 0 Then
			MsgBox(4112, "Error!", "Unable to open: "&"IIS://" & @ComputerName & "/w3svc")
			Exit
		EndIf

		; check for server already defined
	For $WebServer in $w3svc
		If $WebServer.Class = "IIsWebServer" Then
			$Bindings = $WebServer.ServerBindings

			For $HostNameINdex = 1 To UBound($HostNames)-1
				for $BindingIndex = 0 to UBound($Bindings)-1
					$BindingString = $IPAddress & ":" & $PortNum & ":" & $HostNames[$HostNameINdex]
						If ($BindingString = $Bindings[$BindingIndex]) Then
							MsgBox(4144, "Critical Error!", "The server  Bindings  you specified are duplicated in another virtual web server." & @CRLF & "The Web Server name is " & $WebServer.ServerComment & ", Instance ID " & $WebServer.name & " " & @CRLF & "The Conflicting  Bindings are at  Index " & $BindingIndex & ", " & $Bindings[$BindingIndex] & "")
Exit
						EndIf
				next
			next
		EndIf
	next

; find the next available site index		
$Index = 1
$bDone = 0
SetError(0) ; make sure @errors is clear
	While (Not $bDone)	
		
		$SiteObj = ObjGet("IIS://" & @ComputerName & "/w3svc/" & $Index)
			If Not @error Then
				$Index = $Index + 1 ; A web server is already defined at this position so increment
					If ($Index > 10000) Then ; set an upper boundry for the index
						MsgBox(4112, "Critical Error 66!", "Unable to create new web server.  Server number is " & $Index & ".")
					Exit
					EndIf
			Else; index successfully created
				$bDone = 1 
			;MsgBox(4160, "", "New Server Index is " & $Index)
			EndIf	
	WEnd
	
	; create new server	
	SetError(0) ; make sure @errors is clear
	$NewWebServer = $w3svc.Create("IIsWebServer", $Index)
	; check for successful creation of new server					
	$SiteObj = ObjGet("IIS://" & @ComputerName & "/w3svc/" & $Index)
		If @error <> 0 Then
			MsgBox(4160, "Information", "Web server created. Path is - IIS://" & @ComputerName & "/w3svc/" & $Index)
		Else
			MsgBox(4112, "Critical Error!", "Unable to create web server - IIS://" & @ComputerName & "/w3svc/" & $Index)
			Exit
		Endif	
						
	redim $NewBindings[UBound($HostNames)-1]
	; Process host headers and add new server bindings
	For $HostNameINdex = 1 To UBound($HostNames) -1
		$BindingString = $IPAddress & ":" & $PortNum & ":" & $HostNames[$HostNameINdex]
		; MsgBox(4096, "", $HostNameINdex-1 & " - " & $BindingString)
		$NewBindings[$HostNameINdex-1] = $BindingString
	next

	SetError(0) ; make sure @errors is clear
		$NewWebServer.ServerBindings = $NewBindings
		$NewWebServer.ServerComment = $ServerComment
		$NewWebServer.SetInfo()		
			If @error <> 0 Then
				MsgBox(4112, "Critical Error", "Web server bindings not completed")
				Exit
			Endif	
	; create site root		
	SetError(0)	 ; make sure @errors is clear		
		$NewDir = $NewWebServer.Create("IIsWebVirtualDir", "ROOT")
		$NewDir.Path = $RootDirectory
		$NewDir.AccessFlags = 513
		$NewDir.SetInfo()
			If @error <> 0 Then
				MsgBox(4112, "Critical Error", "Unable to Create Site Root Directory")
				Exit
			Endif
	; enable ASP support
	SetError(0)
		 $EnableASP = ObjGet("IIS://" & @ComputerName & "/W3SVC/" & $Index & "/ROOT")
     	$EnableASP.AppCreate2(2)
			If @error <> 0 Then
				MsgBox(4112, "Critical Error", "Unable to Enable ASP")
				Exit
			Endif
		
	; set db and log directory permissions
	$FolderPerms = ObjGet("IIS://" & @ComputerName & "/W3SVC/" & $Index & "/ROOT")
	SetError(0)	
     	$DbPerms = $FolderPerms.Create("IIsWebDirectory", "db")
     	$DbPerms.AccessFlags = 0
     	$DbPerms.SetInfo()
			If @error <> 0 Then
				MsgBox(4144, "Error", "Unable to create db folder")
			Endif
		SetError(0)
     	$LogPerms = $FolderPerms.Create("IIsWebDirectory", "logs")
     	$LogPerms.AccessFlags = 0
     	$LogPerms.SetInfo()
			If @error <> 0 Then
				MsgBox(4144, "Error", "Unable to create log folder")
			Endif
	; start new web server		
	If $Start = 1 Then
	SetError(0)
		MsgBox(4144, "", "Attempting to Start new web server...")
			$NewWebServer = ObjGet("IIS://" & @ComputerName & "/w3svc/" & $Index)
			$NewWebServer.Start()
			If @error <> 0 Then
				MsgBox(4112, "Error!", "Unable to start web server!")
			Else
				MsgBox(4160, "Information", "Web server started succesfully!")
			EndIf
		EndIf
	
	Return 1
EndFunc		
#NoTrayIcon
#RequireAdmin

#include <GUIConstantsEx.au3>

Global $OSver = @OSVersion
Global $strEnable = "En&able"
Global $strDisable = "Disa&ble"
Global $colNetwork = ""

Dim $NicsFound[1][1]
Dim $IconFile[2]

If $OSver = "WIN_VISTA" Then
	$IconFile[0] = 'netcenter.dll'
    $IconFile[1] = 8
Else
	$IconFile[0] = 'shell32.dll'
    $IconFile[1] = 19
EndIf

Main()

Func Main()
;starts the creation of the gui 
Global $hGUI = GUICreate("MAC Address Changer", 320, 190)
GUISetIcon($IconFile[0], $IconFile[1])
$helpmenu = GUICtrlCreateMenu("Help")
$aboutitem = GUICtrlCreateMenuItem("About", $helpmenu)
$exititem = GUICtrlCreateMenuItem("Exit", $helpmenu)

If @OSType <> "WIN32_NT" Then
    Msgbox(0,"Error","This script requires Windows 2000 or higher.",0,$hGUI)
    Exit
EndIf

If IsAdmin() = 0 Then
	Msgbox(0,"Error","This script requires Administrative priviledges.",0,$hGUI)
	Exit
EndIf

_GetNetConNames(_NetConsFolderObject())

;If the user has more that 10 pshyical devices I don't even want to handle that
If UBound($NicsFound, 1) - 1 > 10 Then 
	MsgBox (0,"Error", "Too many Devices Find a New Program",0,$hGUI)
	Exit
EndIf

$WinLocation = WinGetPOS($hGUI)
WinMove($hGUI, "", $WinLocation[0], $WinLocation[1], 320, UBound($NicsFound,1) * 30 + 190, 1)

$i2 = 10
Dim $radio[UBound($NicsFound, 1)]
For $i = 0 To UBound($NicsFound, 1) - 1
	$radio[$i] = GUICtrlCreateRadio($i + 1 & ". " & $NicsFound[$i][0], 10, $i2)
	$i2 += 30	
Next

GUICtrlCreateLabel("Enter new MAC Address for adapter in HEX. Example: 010203040506", 10, $i2 + 20, 250, 30)
$newMAC = GUICtrlCreateInput("", 10, $i2 + 50, 150, 20)
GUICtrlSetBkColor(-1, 0xC0DCC0)
$toggle = GUICtrlCreateCheckbox("", 10, $i2 + 80, 15, 15)
GUICtrlSetState($toggle, $GUI_CHECKED)
GUICtrlCreateLabel("Auto Disable/Enable NIC", 30, $i2 + 80, 150, 30)
$ok = GUICtrlCreateButton("OK", 10, $i2 + 100, 75, 25)
$revertOld = GUICtrlCreateButton("Remove", 100, $i2 + 100, 75, 25)
GUISetState(@SW_SHOW)

;infinite loop to get user input on the GUI
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			Exit
		Case $msg = $aboutitem
			MsgBox(0, "About", "Written By Andrew W to spoof the MAC Addresses" & @CRLF & @CRLF & _
						"If you have already put in an address and you want to revert back to your original" & _
						" then just use the remove button.",0,$hGUI)
		Case $msg = $exititem
			Exit
		Case $msg = $ok
			$ok = 1 ;determiner to see if the ok button was actually pressed
			ExitLoop
		Case $msg = $revertOld
			$revertOld = 1 ;determiner to see if the ok button was actually pressed
			ExitLoop	
	EndSelect
		
	;used to display mac for whatever radio button is currently selected
	For $i = 0 to UBound ($NicsFound, 1) - 1
		If $msg = $radio[$i] And BitAND(GUICtrlRead($radio[$i]), $GUI_CHECKED) = $GUI_CHECKED Then
			$label = GUICtrlCreateLabel("Current MAC for this device is: " & $NicsFound[$i][1], 10, $i2, 250, 15)
			$index = $i
		EndIF
	Next
WEnd

;error checking making sure a adapter was selected if ok button is pressed
$selection = 0
If $ok = 1 Then
	For $i = 0 to UBound ($NicsFound, 1) - 1
		If BitAND(GUICtrlRead($radio[$i]), $GUI_CHECKED) = $GUI_CHECKED Then $selection = 1
	Next

	;output to tell the user whats up
	If $selection = 0 Then 
		MsgBox (0,"Error", "No Adapter Selected",0,$hGUI)
		GUIDelete($hGUI)
		Main()
	EndIf

	$newMAC = GUICtrlRead($newMAC)

	If $newMAC = "" Then
		MsgBox (0,"Error", "You did not enter a MAC Address",0,$hGUI)
		GUIDelete($hGUI)
		Main()
	EndIf

	StringUpper($newMAC)

	If StringLen($newMAC) <> 12 OR StringIsXDigit($newMAC) = 0 Then
		MsgBox (0,"Error", "You Entered an Invalid Address",0,$hGUI)
		GUIDelete($hGUI)
		Main()
	Endif
Endif

;get the registry keys in order to change the MAC
While StringLen ($index) <> 4
	Select 
		Case StringLen ($NicsFound[$index][2]) = 1
			$newindex = "000" & $NicsFound[$index][2]
			ExitLoop
		Case StringLen ($NicsFound[$index][2]) = 2
			$newindex = "00" & $NicsFound[$index][2]
			ExitLoop
		Case StringLen ($NicsFound[$index][2]) = 3
			$newindex = "0" & $NicsFound[$index][2]
			ExitLoop
	EndSelect
WEnd

;does the actual registry editing 
$registry = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\" & $newindex
If $revertOld = 1 Then 
	RegDelete($registry, "NetworkAddress")
Else 
	$test = RegWrite ($registry, "NetworkAddress", "REG_SZ", $newMac)
EndIf

If GUICtrlRead($toggle) = $GUI_CHECKED And $NicsFound[$index][4] <> 0 Then
	GUISetState(@SW_DISABLE)
	ProgressOn("Progress", "Please Wait...", "", Default, Default, 18)
	_NicToggle($NicsFound[$index][3], 0)
	ProgressSet(50)
	_NicToggle($NicsFound[$index][3], 1)
	ProgressSet(100, "Operation Complete")
	sleep(5000)
	ProgressOff()
Else
	MsgBox(0, "Remember", "You must shutdown or disable and re-enable your NIC for your MAC change to take affect",0,$hGUI)
EndIf	

GUIDelete($hGUI)
Main()
EndFunc

; Find the folder containing the network connection objects
; ==============================================================================================
Func _NetConsFolderObject()
    Local $wbemFlagReturnImmediately = 0x10
    Local $wbemFlagForwardOnly = 0x20
    Local $strComputer = "localhost"
    $objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\CIMV2")
    $colNetwork = $objWMIService.ExecQuery("SELECT * FROM Win32_NetworkAdapter", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
    Return $colNetwork
EndFunc   ;==>_NetConsFolderObject

; Find the network connection objects
; ==============================================================================================
Func _GetNetConNames($colNetwork)
    Dim $strNetworks, $IDXname=0, $IDXstatus=0
    If IsObj($colNetwork) Then
        For $clsConn In $colNetwork
			
            If $clsConn.NetConnectionID <> '' AND $clsConn.MACAddress <> '' AND NOT StringInStr($clsConn.NetConnectionID, 'virtual') _
					AND NOT StringInStr($clsConn.Name, 'virtual') Then ;attempt to get rid of virtual network adapters
                ;$strNetworks &= $clsConn.NetConnectionID & '|'
                ReDim $NicsFound[$IDXname+1][5]
                $NicsFound[$IDXname][0] = $clsConn.Name
                $NicsFound[$IDXname][1] = $clsConn.MACAddress
				$NicsFound[$IDXname][2] = $clsConn.index
				$NicsFound[$IDXname][3] = $clsConn.NetConnectionID
				$NicsFound[$IDXname][4] = $clsConn.NetConnectionStatus
                $IDXname = $IDXname + 1
            EndIf
        Next
    Else
        MsgBox(0, "WMI Output", "No WMI Objects Found for class: " & "Win32_NetworkAdapter",0,$hGUI)
    EndIf
    Return
EndFunc   ;==>GetNetworkNames

; Disable and Enable a Network card
; ==============================================================================================
;  _NicToggle('local area connection', [0=disable, 1=enable])
Func _NicToggle($name, $iFlag)
    If $OSver = "WIN_VISTA" OR $Osver = "WIN_2008" Then
        _NetConsFolderObject()
        If IsObj($colNetwork) Then
            For $clsConn In $colNetwork
                If $clsConn.NetConnectionID = $name Then
					If $iFlag = 0 And $clsConn.NetConnectionStatus <> 0 Then
	                    $clsConn.Disable
					EndIf
					If $iFlag = 1 And $clsConn.NetConnectionStatus = 0 Then
	                    $clsConn.Enable
					EndIf
					ExitLoop
                EndIf
            Next
        Else
            MsgBox(0, "WMI Output", "No WMI Objects Found for class: " & "Win32_NetworkAdapter",0,$hGUI)
        EndIf
    Else ; Windows 2000 & XP
        $objShell = ObjCreate("Shell.Application")
        $strNetConn = "Network Connections"
        $objCP = $objShell.Namespace(3)
        For $clsConn In $objCP.Items
            If $clsConn.Name = $strNetConn Then
            $colNetwork = $clsConn.GetFolder
            EndIf
        Next
        For $clsConn In $colNetwork.Items
            If $clsConn.Name = $name Then
                For $clsVerb In $clsConn.verbs
					If $iFlag = 0 And $clsVerb.name = $strDisable Then
	                    $clsVerb.DoIt
						Sleep(5000)
						Return
					EndIf
					If $iFlag = 1 And $clsVerb.name = $strEnable Then
		                $clsVerb.DoIt
	                    Sleep(5000)
						Return
					EndIf
                Next
            EndIf
        Next
    EndIf
EndFunc   ;==>_NicToggle
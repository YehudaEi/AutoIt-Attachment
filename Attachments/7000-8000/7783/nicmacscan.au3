#include<GuiConstants.au3>

Global $SYSNAME, $MAC, $COMERROR ,$OBJWMISERVICE

$NICSCAN = GUICreate("NICMACSCAN", 194, 127, 192, 125)
$USERNAMEIN = GUICtrlCreateInput("USERNAME", 8, 8, 113, 21, -1, $WS_EX_CLIENTEDGE)
$PASSWORDIN = GUICtrlCreateInput("PASSWORD", 8, 32, 113, 21, -1, $WS_EX_CLIENTEDGE)
$WORKGROUPIN = GUICtrlCreateInput("WORKGROUP", 8, 56, 113, 21, -1, $WS_EX_CLIENTEDGE)
$NICIN = GUICtrlCreateInput("NIC NAME", 8, 80, 113, 21, -1, $WS_EX_CLIENTEDGE)
$SCAN = GUICtrlCreateButton("SCAN", 128, 8, 49, 25)
$STATUS=GUICtrlCreateLabel("Status", 8, 104, 178, 17, $SS_SUNKEN)
GUISetState(@SW_SHOW)

Func GetMacs()
$PASSWORD = GUICtrlRead($PASSWORDIN)
$USERNAME = GUICtrlRead($USERNAMEIN)
$WORKGROUP = GUICtrlRead ($WORKGROUPIN)
$NIC = GUICtrlRead($NICIN)
GUICtrlSetData($STATUS,"Status : Getting Workgroup Systems" )
$objDomain = ObjGet("WinNT://"&$WORKGROUP)
$objDomain.Filter = "Array('computer')"
GUICtrlSetData($STATUS,"Status : Scanning Systems" )
For $objComputer In $objDomain
    SetError(0)
    $SYSNAME = $objComputer.Name
    ConsoleWrite($SYSNAME & @LF)
	GUICtrlSetData($STATUS,"Scanning :"&$SYSNAME)
    If Not $SYSNAME = "" Then
        Local $objLocator = ObjCreate( "WbemScripting.SWbemLocator")
        $ComError = ObjEvent("AutoIt.Error", "ComError")   ; Initialize a COM error handler
        Local $objWMIService = $objLocator.ConnectServer ($SYSNAME, "root/cimv2", $SYSNAME & "\" & $Username, $Password)
        If Not @error Then
			GUICtrlSetData($STATUS,"Query :"&$SYSNAME)
            $objWMIService.Security_.impersonationlevel = 3
            $colItems = $objWMIService.ExecQuery ("SELECT * FROM Win32_NetworkAdapter WHERE Name = '"&$NIC&"'")
            For $bjItem In $colItems
                $MAC = $bjItem.MACAddress
            Next
            $MAC = StringReplace($MAC, ":", "-")
			GUICtrlSetData($STATUS,$SYSNAME&" "&$MAC)
			Sleep ( 1000 )
            FileWriteLine("macs.dat", $SYSNAME & " " & $MAC)
        EndIf
    EndIf
Next
EndFunc

Func ComError()
    If IsObj($ComError) Then
        $HexNumber = Hex($ComError.number, 8) 
        GUICtrlSetData($STATUS,$ComError.description)
		Sleep( 1000)
        SetError(1) 
        $ComError = 0
    EndIf
EndFunc  

While 1
	GUICtrlSetData($STATUS,"Status : Idle" )
	$msg = GuiGetMsg()
		Sleep(100)
	Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case $msg = $SCAN
		GetMacs()
	EndSelect
WEnd
Exit
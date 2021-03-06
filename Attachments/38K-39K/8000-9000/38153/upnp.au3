#include <Constants.au3>
;many
Global $g_eventerror = 0 ; to be checked to know if com error occurs. Must be reset after handling.
$oMyError = ObjEvent("AutoIt.Error","MyErrFunc") ; Install a custom error handler
Global $debuglog = "debug.log"
; for windows you can use bare tail -> http://www.baremetalsoft.com/baretail/ to see output
; i preffer this way
Global $debug =1 ; 1 = Log , 0 = no log
; port 6800 is default port for aria2c here is the site link: http://aria2.sourceforge.net/
; i need NAT UPnP/NAT-PMP to open port which is part of "proof of concept" -> to provide a simple updater for our software
; based on aria2c and control it via XML-RPC requests
$int_port = "6800" ; aria2c default port
$ext_port = "6800" ; aria2c default port
$aria2c_protol = "UDP" ; default protocol
$Description = "Aria2C p2p"
DebugMsg("-------------------Script Start-----------------")
DebugMsg("------------------------------------------------")
DebugMsg("------------------------------------------------")
DebugMsg("OSType:"&@OSType&" OSVersion:"&@OSVersion&" OSServicePack:"&@OSServicePack&" OSBuild:"&@OSBuild&" OSArch:"&@OSArch&" OSLang:"&@OSLang&" Number of Params:"&@NumParams&" ScriptFullPath:"&@ScriptFullPath&" Start Time:"&@YEAR&"-"&@MON&"-"&@MDAY&" "&@HOUR&":"&@MIN&":"&@SEC&":"&@MSEC)

if FindDevice() Then ; if we find IGD Upnp device
; at this point we know that we have IGD device and will try to open our port
;communication between HNetCfg.NATUPnP and root device MiniUPnP is not OK
; i tested on Pfsense v2.0.1 and v1.2.3 without any luck , but works perfect ot chinies
; 20$ routers :) so will try 2-nd way firs HNetCfg.NATUPnP if fail than upnpc-static.exe or upnpc-shared.exe
;MiniUPnP Project link to site http://miniupnp.free.fr/
If UpnpPortMap(@IPAddress1,$int_port,$ext_port,$aria2c_protol,$Description) Then
DebugMsg("ok port is open on router")
; we are ok port is open on router
Else
DebugMsg("fail to open on router")
; fail :)
Endif

Endif
Func UpnpPortMap($InternalIP,$InternalPort,$ExternalPort,$Protocol,$Description )
Local $theNatter = ObjCreate( "HNetCfg.NATUPnP")
If IsObj($theNatter) Then
DebugMsg ("HNetCfg.NATUPnP.StaticPortMappingCollection now")
Local $mappingPorts = $theNatter.StaticPortMappingCollection
DebugMsg ("HNetCfg.NATUPnP.StaticPortMappingCollection.Add now")
$mappingPorts.Add($InternalPort,$Protocol,$ExternalPort,@IPAddress1,1,$Description)
; at this point we know that we have IGD device and we was unable to open port via HNetCfg.NATUPnP StaticPortMappingCollection.Add
; so lets try with MiniUPnP Project link to site http://miniupnp.free.fr/
; many distribution use this project
If $g_eventerror = 1 Then
if miniupnpcaddstatic($InternalIP,$InternalPort,$ExternalPort,$Protocol) Then Return 1
EndIf
Return 1
Endif
Return 0
EndFunc


; this is taken from forum :)
Func FindDevice()
Dim $deviceFinder
Dim $DeviceType
Dim $Devices
Dim $Device
Dim $strDescDocURL
$deviceFinder = ObjCreate("UPnP.UPnPDeviceFinder")
$DeviceServices = ObjCreate("UPnP.UPnPServices")
$DeviceService = ObjCreate("UPnP.UPnPService")
$Device = ObjCreate("UPnP.UPnPDevice")
; we need any version of IGD device curently there only 1 and 2 :)
$DeviceType = "urn:schemas-upnp-org:device:InternetGatewayDevice:*"
$Devices = $deviceFinder.FindByType ($DeviceType, 0)

DebugMsg($strDescDocURL )
DebugMsg("Found # :" & $Devices.Count & " Devices")
If $Devices.Count = 0 Then
DebugMsg("Unable to find Device.")
EndIf
For $DeviceObj In $Devices
$deiceDescription = "Children " & $DeviceObj.Children & @CRLF & "Description " & $DeviceObj.Description & @CRLF & "FriendlyName " & $DeviceObj.FriendlyName & @CRLF & "HasChildren " & $DeviceObj.HasChildren & @CRLF & "IsRootDevice " & $DeviceObj.IsRootDevice & @CRLF & "ManufacturerName " & $DeviceObj.ManufacturerName & @CRLF & "ManufacturerURL " & $DeviceObj.ManufacturerURL & @CRLF & "ModelName " & $DeviceObj.ModelName & @CRLF & "ModelNumber " & $DeviceObj.ModelNumber & @CRLF & "ModelURL " & $DeviceObj.ModelURL & @CRLF & "ParentDevice " & $DeviceObj.ParentDevice & @CRLF & "PresentationURL " & $DeviceObj.PresentationURL & @CRLF & "RootDevice " & $DeviceObj.RootDevice & @CRLF & "SerialNumber " & $DeviceObj.SerialNumber & @CRLF & "Services " & $DeviceObj.Services & @CRLF & "Device URN Type " & $DeviceObj.Type & @CRLF & "UniqueDeviceName " & $DeviceObj.UniqueDeviceName & @CRLF & "Product Code - UPC " & $DeviceObj.UPC & @CRLF
DebugMsg("Found The Following Device(s)" & @CRLF & $deiceDescription )
Next
If $Devices.Count > 0 Then Return 1
Return 0
EndFunc
Func miniupnpcaddstatic($InternalIP,$InternalPort,$ExternalPort,$Protocol)

Local $ResultMiniUpnp = Run (@ComSpec & " /c " & ' upnpc-static.exe -a '&$InternalIP&" "&$InternalPort&" "&$ExternalPort&" "&$Protocol , @ScriptDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
Local $upnpc_static_output
While 1
; read output from cmd command
$upnpc_static_output = StdoutRead($ResultMiniUpnp)
;exit on error
If @error Then ExitLoop

; send output to window
If $upnpc_static_output Then DebugMsg($upnpc_static_output )
Wend
EndFunc
; This is my custom error handler
; we don't want script to fail if HNetCfg.NATUPnP fails
Func MyErrFunc()
$HexNumber=hex($oMyError.number,8)
If @error Then Return
Local $msg = "COM Error with HNetCfg.NATUPnP!" & @CRLF & @CRLF & _
"err.description is: " & @TAB & $oMyError.description & @CRLF & _
"err.windescription:" & @TAB & $oMyError.windescription & @CRLF & _
"err.number is: " & @TAB & $HexNumber & @CRLF & _
"err.lastdllerror is: " & @TAB & $oMyError.lastdllerror & @CRLF & _
"err.scriptline is: " & @TAB & $oMyError.scriptline & @CRLF & _
"err.source is: " & @TAB & $oMyError.source & @CRLF & _
"err.helpfile is: " & @TAB & $oMyError.helpfile & @CRLF & _
"err.helpcontext is: " & @TAB & $oMyError.helpcontext
DebugMsg ($msg)
$g_eventerror = 1 ; something to check for when this function returns
Return
Endfunc
Func DebugMsg ($debugtext)
If $debug Then
Local $file = FileOpen(@ScriptDir&"\"&$debuglog, 1)
If $file = -1 Then
MsgBox(0, "Error", "Unable to open file."&$debuglog)
Return 0
EndIf
FileWriteLine($file, @HOUR&":"&@MIN&":"&@SEC&":"&@MSEC&"->"&$debugtext)
FileClose($file)
EndIf
Return 1
EndFunc
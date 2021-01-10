Opt("GuiOnEventMode",1)
#include <Array.au3>
#NoTrayIcon
;89.145.117.69
;89.145.98.39

;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
$win=GUICreate("CSS Server            <d3mon Tools>",500,480,-1,-1,$WS_CAPTION,BitOr($WS_EX_APPWINDOW,$WS_EX_TOOLWINDOW))
GUISetBkColor("0xFFCC00",$win)
GUICtrlCreateTab(5,5,490,470)
GUICtrlCreateTabItem("Server 1")
GUICtrlCreateLabel("Server IP",20,43,70)
GUICtrlSetFont(-1,12)
$ip=GUICtrlCreateEdit("",100,40,135,25,$ES_WANTRETURN)
GUICtrlSetFont(-1,12)
GUICtrlCreateLabel(":",242,39)
GUICtrlSetFont(-1,15)
$port=GUICtrlCreateEdit("",255,40,60,25,$ES_WANTRETURN)
GUICtrlSetFont(-1,12)
GUICtrlCreateButton("Get Info !",335,40,75,25)
GUICtrlSetOnEvent(-1,"GetInfo1")
GUICtrlCreateButton("Exit",420,40,60,25)
GUICtrlSetOnEvent(-1,"_Exit")
GUICtrlSetFont(-1,10)
GUICtrlCreateLabel("--------------------------------------------------------------------------------------------------------------------------------------------------------------",8,75)
GUICtrlSetFont(-1,10)

GUICtrlCreateLabel("Type",15,95)
GUICtrlSetFont(-1,10)
$Type=GUICtrlCreateEdit("",90,95,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Version",15,120)
GUICtrlSetFont(-1,10)
$Version=GUICtrlCreateEdit("",90,120,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Name",15,145)
GUICtrlSetFont(-1,10)
$Name=GUICtrlCreateEdit("",90,145,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Map",15,170)
GUICtrlSetFont(-1,10)
$Map=GUICtrlCreateEdit("",90,170,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Game dir",15,195,70)
GUICtrlSetFont(-1,10)
$Game=GUICtrlCreateEdit("",90,195,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Description",15,220,70)
GUICtrlSetFont(-1,10)
$Description=GUICtrlCreateEdit("",90,220,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("App ID",15,245)
GUICtrlSetFont(-1,10)
$AppID=GUICtrlCreateEdit("",90,245,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Players",15,270,70)
GUICtrlSetFont(-1,10)
$Players=GUICtrlCreateEdit("",90,270,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Bot(s)",15,295)
GUICtrlSetFont(-1,10)
$Bot=GUICtrlCreateEdit("",90,295,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Mode",15,320)
GUICtrlSetFont(-1,10)
$Mode=GUICtrlCreateEdit("",90,320,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("System",15,345,70)
GUICtrlSetFont(-1,10)
$Sys=GUICtrlCreateEdit("",90,345,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Password",15,370,70)
GUICtrlSetFont(-1,10)
$pw=GUICtrlCreateEdit("",90,370,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Secure",15,395)
GUICtrlSetFont(-1,10)
$secure=GUICtrlCreateEdit("",90,395,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("G.Version",15,420,70)
GUICtrlSetFont(-1,10)
$Gversion=GUICtrlCreateEdit("",90,420,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Ping",15,445,70)
GUICtrlSetFont(-1,10)
$Ping=GUICtrlCreateEdit("",90,445,380,20,$ES_READONLY+$ES_WANTRETURN)


Func GetInfo1()
UDPStartup()
$aServerInfo = _SteamNetwork_SourceInfoQuery(GuiCtrlRead($ip),GuiCtrlRead($port))
If Not @error Then
GUICtrlSetData($Type,$aServerInfo[0])
GUICtrlSetData($Version,$aServerInfo[1])
GUICtrlSetData($Name,$aServerInfo[2])
GUICtrlSetData($Map,$aServerInfo[3])
GUICtrlSetData($Game,$aServerInfo[4])
GUICtrlSetData($Description,$aServerInfo[5])
GUICtrlSetData($AppID,$aServerInfo[6])
GUICtrlSetData($Players,$aServerInfo[7]&"/"&$aServerInfo[8])
GUICtrlSetData($Bot,$aServerInfo[9])

If $aServerInfo[10]="d" Then
GUICtrlSetData($Mode,"Dedicated")
EndIf
If $aServerInfo[10]="l" Then
GUICtrlSetData($Mode,"Listen")
EndIf
If $aServerInfo[10]="p" Then
GUICtrlSetData($Mode,"Source TV")
EndIf

GUICtrlSetData($Sys,$aServerInfo[11])

If $aServerInfo[12]="0" Then
GUICtrlSetData($pw,"Public")
Else
GUICtrlSetData($pw,"Private")
EndIf

If $aServerInfo[13]="1" Then
GUICtrlSetData($Secure,"VAC")
Else
GUICtrlSetData($Secure,"Not secured")
EndIf

GUICtrlSetData($GVersion,$aServerInfo[14])

$ServerPing=Ping(GuiCtrlRead($ip))
GUICtrlSetData($Ping,$ServerPing)
Else
MsgBox(48,"Error Server","Server probably offline !")
Exit
EndIf
EndFunc

Func _SteamNetwork_SourceInfoQuery($svServerAddress, $ivServerPort)
    
    Local Const $A2S_INFO = Chr(255) & Chr(255) & Chr(255) & Chr(255) & "TSource Engine Query" & Chr(0)
    
    $avOpenSocket = UDPOpen($svServerAddress, $ivServerPort)
    If $avOpenSocket[0] = -1 Then Return(SetError(1, UDPCloseSocket($avOpenSocket), 0)); Error, could not open socket.
    
    Local $ivBytesSent = UDPSend($avOpenSocket, $A2S_INFO)
    If Not $ivBytesSent Then Return(SetError(2, UDPCloseSocket($avOpenSocket), 0)); Error, no bytes could be sent.
    
    Local $bvResponseData, $ivResponseTimer = TimerInit()
    
    Do
        $bvResponseData = UDPRecv($avOpenSocket, 1024)
    Until $bvResponseData <> "" Or TimerDiff($ivResponseTimer) > 5000
    
    If TimerDiff($ivResponseTimer) > 5000 Then Return(SetError(3, UDPCloseSocket($avOpenSocket), 0)); Timed out while receiving response from server.
    
    $bvResponseData = StringTrimLeft($bvResponseData, 10); Remove 0xFFFFFFFF
    
    Local $avRet[15] = [0, 0, "", "", "", "", 0, 0, 0, 0, "", 0, 0, ""], $svChar
    
    $avRet[0] = Dec(StringLeft($bvResponseData, 2))                         ; Type
    If $avRet[0] <> 73 Then Return(SetError(4, UDPCloseSocket($avOpenSocket), 0)); This is not a Source server.
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[1] = Dec(StringLeft($bvResponseData, 2))                         ; Version
    $bvResponseData = StringTrimLeft($bvResponseData, 2)

    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[2] &= Chr(Dec($svChar))                 ; Server Name
    Until $svChar = "00"
    
    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[3] &= Chr(Dec($svChar))                 ; Map
    Until $svChar = "00"
    
    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[4] &= Chr(Dec($svChar))                 ; Game Directory
    Until $svChar = "00"
    
    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[5] &= Chr(Dec($svChar))                 ; Game Description
    Until $svChar = "00"
    
    $avRet[6] = Dec(StringReplace(StringLeft($bvResponseData, 4), "00", "")) ; AppID
    $bvResponseData = StringTrimLeft($bvResponseData, 4)
    
    $avRet[7] = Dec(StringLeft($bvResponseData, 2))                            ; Number of players
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[8] = Dec(StringLeft($bvResponseData, 2))                         ; Maximum players
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[9] = Dec(StringLeft($bvResponseData, 2))                            ; Number of bots
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[10] = Chr(Dec(StringLeft($bvResponseData, 2)))                    ; Server mode(d for dedicated, l for listen, p for SourceTV)
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[11] = Chr(Dec(StringLeft($bvResponseData, 2)))                    ; Operating System
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[12] = Dec(StringLeft($bvResponseData, 2))                        ; Passworded
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[13] = Dec(StringLeft($bvResponseData, 2))                        ; Secure
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[14] &= Chr(Dec($svChar))                 ; Game Version
    Until $svChar = "00"
    
    Return(SetError(0, UDPCloseSocket($avOpenSocket), $avRet))
EndFunc

;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

GUICtrlCreateTab(50,5,490,470)
GUICtrlCreateTabItem("Server 2")
GUICtrlCreateLabel("Server IP",20,43,70)
GUICtrlSetFont(-1,12)
$ip2=GUICtrlCreateEdit("",100,40,135,25,$ES_WANTRETURN)
GUICtrlSetFont(-1,12)
GUICtrlCreateLabel(":",242,39)
GUICtrlSetFont(-1,15)
$port2=GUICtrlCreateEdit("",255,40,60,25,$ES_WANTRETURN)
GUICtrlSetFont(-1,12)
GUICtrlCreateButton("Get Info !",335,40,75,25)
GUICtrlSetOnEvent(-1,"GetInfo2")
GUICtrlCreateButton("Exit",420,40,60,25)
GUICtrlSetOnEvent(-1,"_Exit")
GUICtrlSetFont(-1,10)
GUICtrlCreateLabel("--------------------------------------------------------------------------------------------------------------------------------------------------------------",8,75)
GUICtrlSetFont(-1,10)

GUICtrlCreateLabel("Type",15,95)
GUICtrlSetFont(-1,10)
$Type2=GUICtrlCreateEdit("",90,95,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Version",15,120)
GUICtrlSetFont(-1,10)
$Version2=GUICtrlCreateEdit("",90,120,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Name",15,145)
GUICtrlSetFont(-1,10)
$Name2=GUICtrlCreateEdit("",90,145,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Map",15,170)
GUICtrlSetFont(-1,10)
$Map2=GUICtrlCreateEdit("",90,170,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Game dir",15,195,70)
GUICtrlSetFont(-1,10)
$Game2=GUICtrlCreateEdit("",90,195,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Description",15,220,70)
GUICtrlSetFont(-1,10)
$Description2=GUICtrlCreateEdit("",90,220,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("App ID",15,245)
GUICtrlSetFont(-1,10)
$AppID2=GUICtrlCreateEdit("",90,245,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Players",15,270,70)
GUICtrlSetFont(-1,10)
$Players2=GUICtrlCreateEdit("",90,270,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Bot(s)",15,295)
GUICtrlSetFont(-1,10)
$Bot2=GUICtrlCreateEdit("",90,295,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Mode",15,320)
GUICtrlSetFont(-1,10)
$Mode2=GUICtrlCreateEdit("",90,320,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("System",15,345,70)
GUICtrlSetFont(-1,10)
$Sys2=GUICtrlCreateEdit("",90,345,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Password",15,370,70)
GUICtrlSetFont(-1,10)
$pw2=GUICtrlCreateEdit("",90,370,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Secure",15,395)
GUICtrlSetFont(-1,10)
$secure2=GUICtrlCreateEdit("",90,395,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("G.Version",15,420,70)
GUICtrlSetFont(-1,10)
$Gversion2=GUICtrlCreateEdit("",90,420,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Ping",15,445,70)
GUICtrlSetFont(-1,10)
$Ping2=GUICtrlCreateEdit("",90,445,380,20,$ES_READONLY+$ES_WANTRETURN)
GUISetState()

Func GetInfo2()
UDPStartup()
$aServerInfo2 = _SteamNetwork_SourceInfoQuery2(GuiCtrlRead($ip2),GuiCtrlRead($port2))
If Not @error Then
GUICtrlSetData($Type2,$aServerInfo2[0])
GUICtrlSetData($Version2,$aServerInfo2[1])
GUICtrlSetData($Name2,$aServerInfo2[2])
GUICtrlSetData($Map2,$aServerInfo2[3])
GUICtrlSetData($Game2,$aServerInfo2[4])
GUICtrlSetData($Description2,$aServerInfo2[5])
GUICtrlSetData($AppID2,$aServerInfo2[6])
GUICtrlSetData($Players2,$aServerInfo2[7]&"/"&$aServerInfo2[8])
GUICtrlSetData($Bot2,$aServerInfo2[9])

If $aServerInfo2[10]="d" Then
GUICtrlSetData($Mode2,"Dedicated")
EndIf
If $aServerInfo2[10]="l" Then
GUICtrlSetData($Mode2,"Listen")
EndIf
If $aServerInfo2[10]="p" Then
GUICtrlSetData($Mode2,"Source TV")
EndIf

GUICtrlSetData($Sys2,$aServerInfo2[11])

If $aServerInfo2[12]="0" Then
GUICtrlSetData($pw2,"Public")
Else
GUICtrlSetData($pw2,"Private")
EndIf

If $aServerInfo2[13]="1" Then
GUICtrlSetData($Secure2,"VAC")
Else
GUICtrlSetData($Secure2,"Not secured")
EndIf

GUICtrlSetData($GVersion2,$aServerInfo2[14])

$ServerPing2=Ping(GuiCtrlRead($ip2))
GUICtrlSetData($Ping2,$ServerPing2)
Else
MsgBox(48,"Error Server","Server probably offline !")
Exit
EndIf
EndFunc

Func _SteamNetwork_SourceInfoQuery2($svServerAddress2, $ivServerPort2)
    
    Local Const $A2S_INFO = Chr(255) & Chr(255) & Chr(255) & Chr(255) & "TSource Engine Query" & Chr(0)
    
    $avOpenSocket = UDPOpen($svServerAddress2, $ivServerPort2)
    If $avOpenSocket[0] = -1 Then Return(SetError(1, UDPCloseSocket($avOpenSocket), 0)); Error, could not open socket.
    
    Local $ivBytesSent = UDPSend($avOpenSocket, $A2S_INFO)
    If Not $ivBytesSent Then Return(SetError(2, UDPCloseSocket($avOpenSocket), 0)); Error, no bytes could be sent.
    
    Local $bvResponseData, $ivResponseTimer = TimerInit()
    
    Do
        $bvResponseData = UDPRecv($avOpenSocket, 1024)
    Until $bvResponseData <> "" Or TimerDiff($ivResponseTimer) > 5000
    
    If TimerDiff($ivResponseTimer) > 5000 Then Return(SetError(3, UDPCloseSocket($avOpenSocket), 0)); Timed out while receiving response from server.
    
    $bvResponseData = StringTrimLeft($bvResponseData, 10); Remove 0xFFFFFFFF
    
    Local $avRet[15] = [0, 0, "", "", "", "", 0, 0, 0, 0, "", 0, 0, ""], $svChar
    
    $avRet[0] = Dec(StringLeft($bvResponseData, 2))                         ; Type
    If $avRet[0] <> 73 Then Return(SetError(4, UDPCloseSocket($avOpenSocket), 0)); This is not a Source server.
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[1] = Dec(StringLeft($bvResponseData, 2))                         ; Version
    $bvResponseData = StringTrimLeft($bvResponseData, 2)

    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[2] &= Chr(Dec($svChar))                 ; Server Name
    Until $svChar = "00"
    
    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[3] &= Chr(Dec($svChar))                 ; Map
    Until $svChar = "00"
    
    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[4] &= Chr(Dec($svChar))                 ; Game Directory
    Until $svChar = "00"
    
    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[5] &= Chr(Dec($svChar))                 ; Game Description
    Until $svChar = "00"
    
    $avRet[6] = Dec(StringReplace(StringLeft($bvResponseData, 4), "00", "")) ; AppID
    $bvResponseData = StringTrimLeft($bvResponseData, 4)
    
    $avRet[7] = Dec(StringLeft($bvResponseData, 2))                            ; Number of players
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[8] = Dec(StringLeft($bvResponseData, 2))                         ; Maximum players
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[9] = Dec(StringLeft($bvResponseData, 2))                            ; Number of bots
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[10] = Chr(Dec(StringLeft($bvResponseData, 2)))                    ; Server mode(d for dedicated, l for listen, p for SourceTV)
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[11] = Chr(Dec(StringLeft($bvResponseData, 2)))                    ; Operating System
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[12] = Dec(StringLeft($bvResponseData, 2))                        ; Passworded
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[13] = Dec(StringLeft($bvResponseData, 2))                        ; Secure
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[14] &= Chr(Dec($svChar))                 ; Game Version
    Until $svChar = "00"
    
    Return(SetError(0, UDPCloseSocket($avOpenSocket), $avRet))
EndFunc

;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

GUICtrlCreateTab(100,5,490,470)
GUICtrlCreateTabItem("Server 3")
GUICtrlCreateLabel("Server IP",20,43,70)
GUICtrlSetFont(-1,12)
$ip3=GUICtrlCreateEdit("",100,40,135,25,$ES_WANTRETURN)
GUICtrlSetFont(-1,12)
GUICtrlCreateLabel(":",242,39)
GUICtrlSetFont(-1,15)
$port3=GUICtrlCreateEdit("",255,40,60,25,$ES_WANTRETURN)
GUICtrlSetFont(-1,12)
GUICtrlCreateButton("Get Info !",335,40,75,25)
GUICtrlSetOnEvent(-1,"GetInfo3")
GUICtrlCreateButton("Exit",420,40,60,25)
GUICtrlSetOnEvent(-1,"_Exit")
GUICtrlSetFont(-1,10)
GUICtrlCreateLabel("--------------------------------------------------------------------------------------------------------------------------------------------------------------",8,75)
GUICtrlSetFont(-1,10)

GUICtrlCreateLabel("Type",15,95)
GUICtrlSetFont(-1,10)
$Type3=GUICtrlCreateEdit("",90,95,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Version",15,120)
GUICtrlSetFont(-1,10)
$Version3=GUICtrlCreateEdit("",90,120,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Name",15,145)
GUICtrlSetFont(-1,10)
$Name3=GUICtrlCreateEdit("",90,145,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Map",15,170)
GUICtrlSetFont(-1,10)
$Map3=GUICtrlCreateEdit("",90,170,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Game dir",15,195,70)
GUICtrlSetFont(-1,10)
$Game3=GUICtrlCreateEdit("",90,195,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Description",15,220,70)
GUICtrlSetFont(-1,10)
$Description3=GUICtrlCreateEdit("",90,220,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("App ID",15,245)
GUICtrlSetFont(-1,10)
$AppID3=GUICtrlCreateEdit("",90,245,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Players",15,270,70)
GUICtrlSetFont(-1,10)
$Players3=GUICtrlCreateEdit("",90,270,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Bot(s)",15,295)
GUICtrlSetFont(-1,10)
$Bot3=GUICtrlCreateEdit("",90,295,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Mode",15,320)
GUICtrlSetFont(-1,10)
$Mode3=GUICtrlCreateEdit("",90,320,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("System",15,345,70)
GUICtrlSetFont(-1,10)
$Sys3=GUICtrlCreateEdit("",90,345,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Password",15,370,70)
GUICtrlSetFont(-1,10)
$pw3=GUICtrlCreateEdit("",90,370,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Secure",15,395)
GUICtrlSetFont(-1,10)
$secure3=GUICtrlCreateEdit("",90,395,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("G.Version",15,420,70)
GUICtrlSetFont(-1,10)
$Gversion3=GUICtrlCreateEdit("",90,420,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Ping",15,445,70)
GUICtrlSetFont(-1,10)
$Ping3=GUICtrlCreateEdit("",90,445,380,20,$ES_READONLY+$ES_WANTRETURN)
GUISetState()

Func GetInfo3()
UDPStartup()
$aServerInfo3 = _SteamNetwork_SourceInfoQuery3(GuiCtrlRead($ip3),GuiCtrlRead($port3))
If Not @error Then
GUICtrlSetData($Type3,$aServerInfo3[0])
GUICtrlSetData($Version3,$aServerInfo3[1])
GUICtrlSetData($Name3,$aServerInfo3[2])
GUICtrlSetData($Map3,$aServerInfo3[3])
GUICtrlSetData($Game3,$aServerInfo3[4])
GUICtrlSetData($Description3,$aServerInfo3[5])
GUICtrlSetData($AppID3,$aServerInfo3[6])
GUICtrlSetData($Players3,$aServerInfo3[7]&"/"&$aServerInfo3[8])
GUICtrlSetData($Bot3,$aServerInfo3[9])

If $aServerInfo3[10]="d" Then
GUICtrlSetData($Mode3,"Dedicated")
EndIf
If $aServerInfo3[10]="l" Then
GUICtrlSetData($Mode3,"Listen")
EndIf
If $aServerInfo3[10]="p" Then
GUICtrlSetData($Mode3,"Source TV")
EndIf

GUICtrlSetData($Sys3,$aServerInfo3[11])

If $aServerInfo3[12]="0" Then
GUICtrlSetData($pw3,"Public")
Else
GUICtrlSetData($pw3,"Private")
EndIf

If $aServerInfo3[13]="1" Then
GUICtrlSetData($Secure3,"VAC")
Else
GUICtrlSetData($Secure3,"Not secured")
EndIf

GUICtrlSetData($GVersion3,$aServerInfo3[14])

$ServerPing3=Ping(GuiCtrlRead($ip3))
GUICtrlSetData($Ping3,$ServerPing3)
Else
MsgBox(48,"Error Server","Server probably offline !")
Exit
EndIf
EndFunc

Func _SteamNetwork_SourceInfoQuery3($svServerAddress3, $ivServerPort3)
    
    Local Const $A2S_INFO = Chr(255) & Chr(255) & Chr(255) & Chr(255) & "TSource Engine Query" & Chr(0)
    
    $avOpenSocket = UDPOpen($svServerAddress3, $ivServerPort3)
    If $avOpenSocket[0] = -1 Then Return(SetError(1, UDPCloseSocket($avOpenSocket), 0)); Error, could not open socket.
    
    Local $ivBytesSent = UDPSend($avOpenSocket, $A2S_INFO)
    If Not $ivBytesSent Then Return(SetError(2, UDPCloseSocket($avOpenSocket), 0)); Error, no bytes could be sent.
    
    Local $bvResponseData, $ivResponseTimer = TimerInit()
    
    Do
        $bvResponseData = UDPRecv($avOpenSocket, 1024)
    Until $bvResponseData <> "" Or TimerDiff($ivResponseTimer) > 5000
    
    If TimerDiff($ivResponseTimer) > 5000 Then Return(SetError(3, UDPCloseSocket($avOpenSocket), 0)); Timed out while receiving response from server.
    
    $bvResponseData = StringTrimLeft($bvResponseData, 10); Remove 0xFFFFFFFF
    
    Local $avRet[15] = [0, 0, "", "", "", "", 0, 0, 0, 0, "", 0, 0, ""], $svChar
    
    $avRet[0] = Dec(StringLeft($bvResponseData, 2))                         ; Type
    If $avRet[0] <> 73 Then Return(SetError(4, UDPCloseSocket($avOpenSocket), 0)); This is not a Source server.
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[1] = Dec(StringLeft($bvResponseData, 2))                         ; Version
    $bvResponseData = StringTrimLeft($bvResponseData, 2)

    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[2] &= Chr(Dec($svChar))                 ; Server Name
    Until $svChar = "00"
    
    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[3] &= Chr(Dec($svChar))                 ; Map
    Until $svChar = "00"
    
    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[4] &= Chr(Dec($svChar))                 ; Game Directory
    Until $svChar = "00"
    
    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[5] &= Chr(Dec($svChar))                 ; Game Description
    Until $svChar = "00"
    
    $avRet[6] = Dec(StringReplace(StringLeft($bvResponseData, 4), "00", "")) ; AppID
    $bvResponseData = StringTrimLeft($bvResponseData, 4)
    
    $avRet[7] = Dec(StringLeft($bvResponseData, 2))                            ; Number of players
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[8] = Dec(StringLeft($bvResponseData, 2))                         ; Maximum players
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[9] = Dec(StringLeft($bvResponseData, 2))                            ; Number of bots
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[10] = Chr(Dec(StringLeft($bvResponseData, 2)))                    ; Server mode(d for dedicated, l for listen, p for SourceTV)
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[11] = Chr(Dec(StringLeft($bvResponseData, 2)))                    ; Operating System
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[12] = Dec(StringLeft($bvResponseData, 2))                        ; Passworded
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[13] = Dec(StringLeft($bvResponseData, 2))                        ; Secure
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[14] &= Chr(Dec($svChar))                 ; Game Version
    Until $svChar = "00"
    
    Return(SetError(0, UDPCloseSocket($avOpenSocket), $avRet))
EndFunc

;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

GUICtrlCreateTab(150,5,490,470)
GUICtrlCreateTabItem("Server 4")
GUICtrlCreateLabel("Server IP",20,43,70)
GUICtrlSetFont(-1,12)
$ip4=GUICtrlCreateEdit("",100,40,135,25,$ES_WANTRETURN)
GUICtrlSetFont(-1,12)
GUICtrlCreateLabel(":",242,39)
GUICtrlSetFont(-1,15)
$port4=GUICtrlCreateEdit("",255,40,60,25,$ES_WANTRETURN)
GUICtrlSetFont(-1,12)
GUICtrlCreateButton("Get Info !",335,40,75,25)
GUICtrlSetOnEvent(-1,"GetInfo4")
GUICtrlCreateButton("Exit",420,40,60,25)
GUICtrlSetOnEvent(-1,"_Exit")
GUICtrlSetFont(-1,10)
GUICtrlCreateLabel("--------------------------------------------------------------------------------------------------------------------------------------------------------------",8,75)
GUICtrlSetFont(-1,10)

GUICtrlCreateLabel("Type",15,95)
GUICtrlSetFont(-1,10)
$Type4=GUICtrlCreateEdit("",90,95,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Version",15,120)
GUICtrlSetFont(-1,10)
$Version4=GUICtrlCreateEdit("",90,120,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Name",15,145)
GUICtrlSetFont(-1,10)
$Name4=GUICtrlCreateEdit("",90,145,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Map",15,170)
GUICtrlSetFont(-1,10)
$Map4=GUICtrlCreateEdit("",90,170,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Game dir",15,195,70)
GUICtrlSetFont(-1,10)
$Game4=GUICtrlCreateEdit("",90,195,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Description",15,220,70)
GUICtrlSetFont(-1,10)
$Description4=GUICtrlCreateEdit("",90,220,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("App ID",15,245)
GUICtrlSetFont(-1,10)
$AppID4=GUICtrlCreateEdit("",90,245,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Players",15,270,70)
GUICtrlSetFont(-1,10)
$Players4=GUICtrlCreateEdit("",90,270,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Bot(s)",15,295)
GUICtrlSetFont(-1,10)
$Bot4=GUICtrlCreateEdit("",90,295,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Mode",15,320)
GUICtrlSetFont(-1,10)
$Mode4=GUICtrlCreateEdit("",90,320,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("System",15,345,70)
GUICtrlSetFont(-1,10)
$Sys4=GUICtrlCreateEdit("",90,345,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Password",15,370,70)
GUICtrlSetFont(-1,10)
$pw4=GUICtrlCreateEdit("",90,370,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Secure",15,395)
GUICtrlSetFont(-1,10)
$secure4=GUICtrlCreateEdit("",90,395,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("G.Version",15,420,70)
GUICtrlSetFont(-1,10)
$Gversion4=GUICtrlCreateEdit("",90,420,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Ping",15,445,70)
GUICtrlSetFont(-1,10)
$Ping4=GUICtrlCreateEdit("",90,445,380,20,$ES_READONLY+$ES_WANTRETURN)
GUISetState()

Func GetInfo4()
UDPStartup()
$aServerInfo4 = _SteamNetwork_SourceInfoQuery4(GuiCtrlRead($ip4),GuiCtrlRead($port4))
If Not @error Then
GUICtrlSetData($Type4,$aServerInfo4[0])
GUICtrlSetData($Version4,$aServerInfo4[1])
GUICtrlSetData($Name4,$aServerInfo4[2])
GUICtrlSetData($Map4,$aServerInfo4[3])
GUICtrlSetData($Game4,$aServerInfo4[4])
GUICtrlSetData($Description4,$aServerInfo4[5])
GUICtrlSetData($AppID4,$aServerInfo4[6])
GUICtrlSetData($Players4,$aServerInfo4[7]&"/"&$aServerInfo4[8])
GUICtrlSetData($Bot4,$aServerInfo4[9])

If $aServerInfo4[10]="d" Then
GUICtrlSetData($Mode4,"Dedicated")
EndIf
If $aServerInfo4[10]="l" Then
GUICtrlSetData($Mode4,"Listen")
EndIf
If $aServerInfo4[10]="p" Then
GUICtrlSetData($Mode4,"Source TV")
EndIf

GUICtrlSetData($Sys4,$aServerInfo4[11])

If $aServerInfo4[12]="0" Then
GUICtrlSetData($pw4,"Public")
Else
GUICtrlSetData($pw4,"Private")
EndIf

If $aServerInfo4[13]="1" Then
GUICtrlSetData($Secure4,"VAC")
Else
GUICtrlSetData($Secure4,"Not secured")
EndIf

GUICtrlSetData($GVersion4,$aServerInfo4[14])

$ServerPing4=Ping(GuiCtrlRead($ip4))
GUICtrlSetData($Ping4,$ServerPing4)
Else
MsgBox(48,"Error Server","Server probably offline !")
Exit
EndIf
EndFunc

Func _SteamNetwork_SourceInfoQuery4($svServerAddress4, $ivServerPort4)
    
    Local Const $A2S_INFO = Chr(255) & Chr(255) & Chr(255) & Chr(255) & "TSource Engine Query" & Chr(0)
    
    $avOpenSocket = UDPOpen($svServerAddress4, $ivServerPort4)
    If $avOpenSocket[0] = -1 Then Return(SetError(1, UDPCloseSocket($avOpenSocket), 0)); Error, could not open socket.
    
    Local $ivBytesSent = UDPSend($avOpenSocket, $A2S_INFO)
    If Not $ivBytesSent Then Return(SetError(2, UDPCloseSocket($avOpenSocket), 0)); Error, no bytes could be sent.
    
    Local $bvResponseData, $ivResponseTimer = TimerInit()
    
    Do
        $bvResponseData = UDPRecv($avOpenSocket, 1024)
    Until $bvResponseData <> "" Or TimerDiff($ivResponseTimer) > 5000
    
    If TimerDiff($ivResponseTimer) > 5000 Then Return(SetError(3, UDPCloseSocket($avOpenSocket), 0)); Timed out while receiving response from server.
    
    $bvResponseData = StringTrimLeft($bvResponseData, 10); Remove 0xFFFFFFFF
    
    Local $avRet[15] = [0, 0, "", "", "", "", 0, 0, 0, 0, "", 0, 0, ""], $svChar
    
    $avRet[0] = Dec(StringLeft($bvResponseData, 2))                         ; Type
    If $avRet[0] <> 73 Then Return(SetError(4, UDPCloseSocket($avOpenSocket), 0)); This is not a Source server.
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[1] = Dec(StringLeft($bvResponseData, 2))                         ; Version
    $bvResponseData = StringTrimLeft($bvResponseData, 2)

    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[2] &= Chr(Dec($svChar))                 ; Server Name
    Until $svChar = "00"
    
    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[3] &= Chr(Dec($svChar))                 ; Map
    Until $svChar = "00"
    
    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[4] &= Chr(Dec($svChar))                 ; Game Directory
    Until $svChar = "00"
    
    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[5] &= Chr(Dec($svChar))                 ; Game Description
    Until $svChar = "00"
    
    $avRet[6] = Dec(StringReplace(StringLeft($bvResponseData, 4), "00", "")) ; AppID
    $bvResponseData = StringTrimLeft($bvResponseData, 4)
    
    $avRet[7] = Dec(StringLeft($bvResponseData, 2))                            ; Number of players
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[8] = Dec(StringLeft($bvResponseData, 2))                         ; Maximum players
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[9] = Dec(StringLeft($bvResponseData, 2))                            ; Number of bots
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[10] = Chr(Dec(StringLeft($bvResponseData, 2)))                    ; Server mode(d for dedicated, l for listen, p for SourceTV)
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[11] = Chr(Dec(StringLeft($bvResponseData, 2)))                    ; Operating System
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[12] = Dec(StringLeft($bvResponseData, 2))                        ; Passworded
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[13] = Dec(StringLeft($bvResponseData, 2))                        ; Secure
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[14] &= Chr(Dec($svChar))                 ; Game Version
    Until $svChar = "00"
    
    Return(SetError(0, UDPCloseSocket($avOpenSocket), $avRet))
EndFunc

;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

GUICtrlCreateTab(200,5,490,470)
GUICtrlCreateTabItem("Server 5")
GUICtrlCreateLabel("Server IP",20,43,70)
GUICtrlSetFont(-1,12)
$ip5=GUICtrlCreateEdit("",100,40,135,25,$ES_WANTRETURN)
GUICtrlSetFont(-1,12)
GUICtrlCreateLabel(":",242,39)
GUICtrlSetFont(-1,15)
$port5=GUICtrlCreateEdit("",255,40,60,25,$ES_WANTRETURN)
GUICtrlSetFont(-1,12)
GUICtrlCreateButton("Get Info !",335,40,75,25)
GUICtrlSetOnEvent(-1,"GetInfo2")
GUICtrlCreateButton("Exit",420,40,60,25)
GUICtrlSetOnEvent(-1,"_Exit")
GUICtrlSetFont(-1,10)
GUICtrlCreateLabel("--------------------------------------------------------------------------------------------------------------------------------------------------------------",8,75)
GUICtrlSetFont(-1,10)

GUICtrlCreateLabel("Type",15,95)
GUICtrlSetFont(-1,10)
$Type5=GUICtrlCreateEdit("",90,95,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Version",15,120)
GUICtrlSetFont(-1,10)
$Version5=GUICtrlCreateEdit("",90,120,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Name",15,145)
GUICtrlSetFont(-1,10)
$Name5=GUICtrlCreateEdit("",90,145,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Map",15,170)
GUICtrlSetFont(-1,10)
$Map5=GUICtrlCreateEdit("",90,170,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Game dir",15,195,70)
GUICtrlSetFont(-1,10)
$Game5=GUICtrlCreateEdit("",90,195,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Description",15,220,70)
GUICtrlSetFont(-1,10)
$Description5=GUICtrlCreateEdit("",90,220,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("App ID",15,245)
GUICtrlSetFont(-1,10)
$AppID5=GUICtrlCreateEdit("",90,245,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Players",15,270,70)
GUICtrlSetFont(-1,10)
$Players5=GUICtrlCreateEdit("",90,270,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Bot(s)",15,295)
GUICtrlSetFont(-1,10)
$Bot5=GUICtrlCreateEdit("",90,295,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Mode",15,320)
GUICtrlSetFont(-1,10)
$Mode5=GUICtrlCreateEdit("",90,320,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("System",15,345,70)
GUICtrlSetFont(-1,10)
$Sys5=GUICtrlCreateEdit("",90,345,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Password",15,370,70)
GUICtrlSetFont(-1,10)
$pw5=GUICtrlCreateEdit("",90,370,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Secure",15,395)
GUICtrlSetFont(-1,10)
$secure5=GUICtrlCreateEdit("",90,395,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("G.Version",15,420,70)
GUICtrlSetFont(-1,10)
$Gversion5=GUICtrlCreateEdit("",90,420,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Ping",15,445,70)
GUICtrlSetFont(-1,10)
$Ping5=GUICtrlCreateEdit("",90,445,380,20,$ES_READONLY+$ES_WANTRETURN)
GUISetState()

Func GetInfo5()
UDPStartup()
$aServerInfo5 = _SteamNetwork_SourceInfoQuery5(GuiCtrlRead($ip5),GuiCtrlRead($port5))
If Not @error Then
GUICtrlSetData($Type5,$aServerInfo5[0])
GUICtrlSetData($Version5,$aServerInfo5[1])
GUICtrlSetData($Name5,$aServerInfo5[2])
GUICtrlSetData($Map5,$aServerInfo5[3])
GUICtrlSetData($Game5,$aServerInfo5[4])
GUICtrlSetData($Description5,$aServerInfo5[5])
GUICtrlSetData($AppID5,$aServerInfo5[6])
GUICtrlSetData($Players5,$aServerInfo5[7]&"/"&$aServerInfo5[8])
GUICtrlSetData($Bot5,$aServerInfo5[9])

If $aServerInfo5[10]="d" Then
GUICtrlSetData($Mode5,"Dedicated")
EndIf
If $aServerInfo5[10]="l" Then
GUICtrlSetData($Mode5,"Listen")
EndIf
If $aServerInfo5[10]="p" Then
GUICtrlSetData($Mode5,"Source TV")
EndIf

GUICtrlSetData($Sys5,$aServerInfo5[11])

If $aServerInfo5[12]="0" Then
GUICtrlSetData($pw5,"Public")
Else
GUICtrlSetData($pw5,"Private")
EndIf

If $aServerInfo5[13]="1" Then
GUICtrlSetData($Secure5,"VAC")
Else
GUICtrlSetData($Secure5,"Not secured")
EndIf

GUICtrlSetData($GVersion5,$aServerInfo5[14])

$ServerPing5=Ping(GuiCtrlRead($ip5))
GUICtrlSetData($Ping5,$ServerPing5)
Else
MsgBox(48,"Error Server","Server probably offline !")
Exit
EndIf
EndFunc

Func _SteamNetwork_SourceInfoQuery5($svServerAddress5, $ivServerPort5)
    
    Local Const $A2S_INFO = Chr(255) & Chr(255) & Chr(255) & Chr(255) & "TSource Engine Query" & Chr(0)
    
    $avOpenSocket = UDPOpen($svServerAddress5, $ivServerPort5)
    If $avOpenSocket[0] = -1 Then Return(SetError(1, UDPCloseSocket($avOpenSocket), 0)); Error, could not open socket.
    
    Local $ivBytesSent = UDPSend($avOpenSocket, $A2S_INFO)
    If Not $ivBytesSent Then Return(SetError(2, UDPCloseSocket($avOpenSocket), 0)); Error, no bytes could be sent.
    
    Local $bvResponseData, $ivResponseTimer = TimerInit()
    
    Do
        $bvResponseData = UDPRecv($avOpenSocket, 1024)
    Until $bvResponseData <> "" Or TimerDiff($ivResponseTimer) > 5000
    
    If TimerDiff($ivResponseTimer) > 5000 Then Return(SetError(3, UDPCloseSocket($avOpenSocket), 0)); Timed out while receiving response from server.
    
    $bvResponseData = StringTrimLeft($bvResponseData, 10); Remove 0xFFFFFFFF
    
    Local $avRet[15] = [0, 0, "", "", "", "", 0, 0, 0, 0, "", 0, 0, ""], $svChar
    
    $avRet[0] = Dec(StringLeft($bvResponseData, 2))                         ; Type
    If $avRet[0] <> 73 Then Return(SetError(4, UDPCloseSocket($avOpenSocket), 0)); This is not a Source server.
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[1] = Dec(StringLeft($bvResponseData, 2))                         ; Version
    $bvResponseData = StringTrimLeft($bvResponseData, 2)

    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[2] &= Chr(Dec($svChar))                 ; Server Name
    Until $svChar = "00"
    
    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[3] &= Chr(Dec($svChar))                 ; Map
    Until $svChar = "00"
    
    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[4] &= Chr(Dec($svChar))                 ; Game Directory
    Until $svChar = "00"
    
    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[5] &= Chr(Dec($svChar))                 ; Game Description
    Until $svChar = "00"
    
    $avRet[6] = Dec(StringReplace(StringLeft($bvResponseData, 4), "00", "")) ; AppID
    $bvResponseData = StringTrimLeft($bvResponseData, 4)
    
    $avRet[7] = Dec(StringLeft($bvResponseData, 2))                            ; Number of players
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[8] = Dec(StringLeft($bvResponseData, 2))                         ; Maximum players
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[9] = Dec(StringLeft($bvResponseData, 2))                            ; Number of bots
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[10] = Chr(Dec(StringLeft($bvResponseData, 2)))                    ; Server mode(d for dedicated, l for listen, p for SourceTV)
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[11] = Chr(Dec(StringLeft($bvResponseData, 2)))                    ; Operating System
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[12] = Dec(StringLeft($bvResponseData, 2))                        ; Passworded
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[13] = Dec(StringLeft($bvResponseData, 2))                        ; Secure
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[14] &= Chr(Dec($svChar))                 ; Game Version
    Until $svChar = "00"
    
    Return(SetError(0, UDPCloseSocket($avOpenSocket), $avRet))
EndFunc

;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

GUICtrlCreateTab(250,5,490,470)
GUICtrlCreateTabItem("Server 6")
GUICtrlCreateLabel("Server IP",20,43,70)
GUICtrlSetFont(-1,12)
$ip6=GUICtrlCreateEdit("",100,40,135,25,$ES_WANTRETURN)
GUICtrlSetFont(-1,12)
GUICtrlCreateLabel(":",242,39)
GUICtrlSetFont(-1,15)
$port6=GUICtrlCreateEdit("",255,40,60,25,$ES_WANTRETURN)
GUICtrlSetFont(-1,12)
GUICtrlCreateButton("Get Info !",335,40,75,25)
GUICtrlSetOnEvent(-1,"GetInfo2")
GUICtrlCreateButton("Exit",420,40,60,25)
GUICtrlSetOnEvent(-1,"_Exit")
GUICtrlSetFont(-1,10)
GUICtrlCreateLabel("--------------------------------------------------------------------------------------------------------------------------------------------------------------",8,75)
GUICtrlSetFont(-1,10)

GUICtrlCreateLabel("Type",15,95)
GUICtrlSetFont(-1,10)
$Type6=GUICtrlCreateEdit("",90,95,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Version",15,120)
GUICtrlSetFont(-1,10)
$Version6=GUICtrlCreateEdit("",90,120,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Name",15,145)
GUICtrlSetFont(-1,10)
$Name6=GUICtrlCreateEdit("",90,145,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Map",15,170)
GUICtrlSetFont(-1,10)
$Map6=GUICtrlCreateEdit("",90,170,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Game dir",15,195,70)
GUICtrlSetFont(-1,10)
$Game6=GUICtrlCreateEdit("",90,195,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Description",15,220,70)
GUICtrlSetFont(-1,10)
$Description6=GUICtrlCreateEdit("",90,220,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("App ID",15,245)
GUICtrlSetFont(-1,10)
$AppID6=GUICtrlCreateEdit("",90,245,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Players",15,270,70)
GUICtrlSetFont(-1,10)
$Players6=GUICtrlCreateEdit("",90,270,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Bot(s)",15,295)
GUICtrlSetFont(-1,10)
$Bot6=GUICtrlCreateEdit("",90,295,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Mode",15,320)
GUICtrlSetFont(-1,10)
$Mode6=GUICtrlCreateEdit("",90,320,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("System",15,345,70)
GUICtrlSetFont(-1,10)
$Sys6=GUICtrlCreateEdit("",90,345,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Password",15,370,70)
GUICtrlSetFont(-1,10)
$pw6=GUICtrlCreateEdit("",90,370,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Secure",15,395)
GUICtrlSetFont(-1,10)
$secure6=GUICtrlCreateEdit("",90,395,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("G.Version",15,420,70)
GUICtrlSetFont(-1,10)
$Gversion6=GUICtrlCreateEdit("",90,420,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Ping",15,445,70)
GUICtrlSetFont(-1,10)
$Ping6=GUICtrlCreateEdit("",90,445,380,20,$ES_READONLY+$ES_WANTRETURN)
GUISetState()

Func GetInfo6()
UDPStartup()
$aServerInfo6 = _SteamNetwork_SourceInfoQuery6(GuiCtrlRead($ip6),GuiCtrlRead($port6))
If Not @error Then
GUICtrlSetData($Type6,$aServerInfo6[0])
GUICtrlSetData($Version6,$aServerInfo6[1])
GUICtrlSetData($Name6,$aServerInfo6[2])
GUICtrlSetData($Map6,$aServerInfo6[3])
GUICtrlSetData($Game6,$aServerInfo6[4])
GUICtrlSetData($Description6,$aServerInfo6[5])
GUICtrlSetData($AppID6,$aServerInfo6[6])
GUICtrlSetData($Players6,$aServerInfo6[7]&"/"&$aServerInfo6[8])
GUICtrlSetData($Bot6,$aServerInfo6[9])

If $aServerInfo6[10]="d" Then
GUICtrlSetData($Mode6,"Dedicated")
EndIf
If $aServerInfo6[10]="l" Then
GUICtrlSetData($Mode6,"Listen")
EndIf
If $aServerInfo6[10]="p" Then
GUICtrlSetData($Mode6,"Source TV")
EndIf

GUICtrlSetData($Sys6,$aServerInfo6[11])

If $aServerInfo6[12]="0" Then
GUICtrlSetData($pw6,"Public")
Else
GUICtrlSetData($pw6,"Private")
EndIf

If $aServerInfo6[13]="1" Then
GUICtrlSetData($Secure6,"VAC")
Else
GUICtrlSetData($Secure6,"Not secured")
EndIf

GUICtrlSetData($GVersion6,$aServerInfo6[14])

$ServerPing6=Ping(GuiCtrlRead($ip6))
GUICtrlSetData($Ping6,$ServerPing6)
Else
MsgBox(48,"Error Server","Server probably offline !")
Exit
EndIf
EndFunc

Func _SteamNetwork_SourceInfoQuery6($svServerAddress6, $ivServerPort6)
    
    Local Const $A2S_INFO = Chr(255) & Chr(255) & Chr(255) & Chr(255) & "TSource Engine Query" & Chr(0)
    
    $avOpenSocket = UDPOpen($svServerAddress6, $ivServerPort6)
    If $avOpenSocket[0] = -1 Then Return(SetError(1, UDPCloseSocket($avOpenSocket), 0)); Error, could not open socket.
    
    Local $ivBytesSent = UDPSend($avOpenSocket, $A2S_INFO)
    If Not $ivBytesSent Then Return(SetError(2, UDPCloseSocket($avOpenSocket), 0)); Error, no bytes could be sent.
    
    Local $bvResponseData, $ivResponseTimer = TimerInit()
    
    Do
        $bvResponseData = UDPRecv($avOpenSocket, 1024)
    Until $bvResponseData <> "" Or TimerDiff($ivResponseTimer) > 5000
    
    If TimerDiff($ivResponseTimer) > 5000 Then Return(SetError(3, UDPCloseSocket($avOpenSocket), 0)); Timed out while receiving response from server.
    
    $bvResponseData = StringTrimLeft($bvResponseData, 10); Remove 0xFFFFFFFF
    
    Local $avRet[15] = [0, 0, "", "", "", "", 0, 0, 0, 0, "", 0, 0, ""], $svChar
    
    $avRet[0] = Dec(StringLeft($bvResponseData, 2))                         ; Type
    If $avRet[0] <> 73 Then Return(SetError(4, UDPCloseSocket($avOpenSocket), 0)); This is not a Source server.
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[1] = Dec(StringLeft($bvResponseData, 2))                         ; Version
    $bvResponseData = StringTrimLeft($bvResponseData, 2)

    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[2] &= Chr(Dec($svChar))                 ; Server Name
    Until $svChar = "00"
    
    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[3] &= Chr(Dec($svChar))                 ; Map
    Until $svChar = "00"
    
    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[4] &= Chr(Dec($svChar))                 ; Game Directory
    Until $svChar = "00"
    
    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[5] &= Chr(Dec($svChar))                 ; Game Description
    Until $svChar = "00"
    
    $avRet[6] = Dec(StringReplace(StringLeft($bvResponseData, 4), "00", "")) ; AppID
    $bvResponseData = StringTrimLeft($bvResponseData, 4)
    
    $avRet[7] = Dec(StringLeft($bvResponseData, 2))                            ; Number of players
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[8] = Dec(StringLeft($bvResponseData, 2))                         ; Maximum players
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[9] = Dec(StringLeft($bvResponseData, 2))                            ; Number of bots
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[10] = Chr(Dec(StringLeft($bvResponseData, 2)))                    ; Server mode(d for dedicated, l for listen, p for SourceTV)
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[11] = Chr(Dec(StringLeft($bvResponseData, 2)))                    ; Operating System
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[12] = Dec(StringLeft($bvResponseData, 2))                        ; Passworded
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[13] = Dec(StringLeft($bvResponseData, 2))                        ; Secure
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[14] &= Chr(Dec($svChar))                 ; Game Version
    Until $svChar = "00"
    
    Return(SetError(0, UDPCloseSocket($avOpenSocket), $avRet))
EndFunc

;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

GUICtrlCreateTab(300,5,490,470)
GUICtrlCreateTabItem("Server 7")
GUICtrlCreateLabel("Server IP",20,43,70)
GUICtrlSetFont(-1,12)
$ip7=GUICtrlCreateEdit("",100,40,135,25,$ES_WANTRETURN)
GUICtrlSetFont(-1,12)
GUICtrlCreateLabel(":",242,39)
GUICtrlSetFont(-1,15)
$port7=GUICtrlCreateEdit("",255,40,60,25,$ES_WANTRETURN)
GUICtrlSetFont(-1,12)
GUICtrlCreateButton("Get Info !",335,40,75,25)
GUICtrlSetOnEvent(-1,"GetInfo2")
GUICtrlCreateButton("Exit",420,40,60,25)
GUICtrlSetOnEvent(-1,"_Exit")
GUICtrlSetFont(-1,10)
GUICtrlCreateLabel("--------------------------------------------------------------------------------------------------------------------------------------------------------------",8,75)
GUICtrlSetFont(-1,10)

GUICtrlCreateLabel("Type",15,95)
GUICtrlSetFont(-1,10)
$Type7=GUICtrlCreateEdit("",90,95,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Version",15,120)
GUICtrlSetFont(-1,10)
$Version7=GUICtrlCreateEdit("",90,120,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Name",15,145)
GUICtrlSetFont(-1,10)
$Name7=GUICtrlCreateEdit("",90,145,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Map",15,170)
GUICtrlSetFont(-1,10)
$Map7=GUICtrlCreateEdit("",90,170,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Game dir",15,195,70)
GUICtrlSetFont(-1,10)
$Game7=GUICtrlCreateEdit("",90,195,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Description",15,220,70)
GUICtrlSetFont(-1,10)
$Description7=GUICtrlCreateEdit("",90,220,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("App ID",15,245)
GUICtrlSetFont(-1,10)
$AppID7=GUICtrlCreateEdit("",90,245,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Players",15,270,70)
GUICtrlSetFont(-1,10)
$Players7=GUICtrlCreateEdit("",90,270,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Bot(s)",15,295)
GUICtrlSetFont(-1,10)
$Bot7=GUICtrlCreateEdit("",90,295,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Mode",15,320)
GUICtrlSetFont(-1,10)
$Mode7=GUICtrlCreateEdit("",90,320,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("System",15,345,70)
GUICtrlSetFont(-1,10)
$Sys7=GUICtrlCreateEdit("",90,345,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Password",15,370,70)
GUICtrlSetFont(-1,10)
$pw7=GUICtrlCreateEdit("",90,370,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Secure",15,395)
GUICtrlSetFont(-1,10)
$secure7=GUICtrlCreateEdit("",90,395,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("G.Version",15,420,70)
GUICtrlSetFont(-1,10)
$Gversion7=GUICtrlCreateEdit("",90,420,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Ping",15,445,70)
GUICtrlSetFont(-1,10)
$Ping7=GUICtrlCreateEdit("",90,445,380,20,$ES_READONLY+$ES_WANTRETURN)
GUISetState()

Func GetInfo7()
UDPStartup()
$aServerInfo7 = _SteamNetwork_SourceInfoQuery7(GuiCtrlRead($ip7),GuiCtrlRead($port7))
If Not @error Then
GUICtrlSetData($Type7,$aServerInfo7[0])
GUICtrlSetData($Version7,$aServerInfo7[1])
GUICtrlSetData($Name7,$aServerInfo7[2])
GUICtrlSetData($Map7,$aServerInfo7[3])
GUICtrlSetData($Game7,$aServerInfo7[4])
GUICtrlSetData($Description7,$aServerInfo7[5])
GUICtrlSetData($AppID7,$aServerInfo7[6])
GUICtrlSetData($Players7,$aServerInfo7[7]&"/"&$aServerInfo7[8])
GUICtrlSetData($Bot7,$aServerInfo7[9])

If $aServerInfo7[10]="d" Then
GUICtrlSetData($Mode7,"Dedicated")
EndIf
If $aServerInfo7[10]="l" Then
GUICtrlSetData($Mode7,"Listen")
EndIf
If $aServerInfo7[10]="p" Then
GUICtrlSetData($Mode7,"Source TV")
EndIf

GUICtrlSetData($Sys7,$aServerInfo7[11])

If $aServerInfo7[12]="0" Then
GUICtrlSetData($pw7,"Public")
Else
GUICtrlSetData($pw7,"Private")
EndIf

If $aServerInfo7[13]="1" Then
GUICtrlSetData($Secure7,"VAC")
Else
GUICtrlSetData($Secure7,"Not secured")
EndIf

GUICtrlSetData($GVersion7,$aServerInfo7[14])

$ServerPing7=Ping(GuiCtrlRead($ip7))
GUICtrlSetData($Ping7,$ServerPing7)
Else
MsgBox(48,"Error Server","Server probably offline !")
Exit
EndIf
EndFunc

Func _SteamNetwork_SourceInfoQuery7($svServerAddress7, $ivServerPort7)
    
    Local Const $A2S_INFO = Chr(255) & Chr(255) & Chr(255) & Chr(255) & "TSource Engine Query" & Chr(0)
    
    $avOpenSocket = UDPOpen($svServerAddress7, $ivServerPort7)
    If $avOpenSocket[0] = -1 Then Return(SetError(1, UDPCloseSocket($avOpenSocket), 0)); Error, could not open socket.
    
    Local $ivBytesSent = UDPSend($avOpenSocket, $A2S_INFO)
    If Not $ivBytesSent Then Return(SetError(2, UDPCloseSocket($avOpenSocket), 0)); Error, no bytes could be sent.
    
    Local $bvResponseData, $ivResponseTimer = TimerInit()
    
    Do
        $bvResponseData = UDPRecv($avOpenSocket, 1024)
    Until $bvResponseData <> "" Or TimerDiff($ivResponseTimer) > 5000
    
    If TimerDiff($ivResponseTimer) > 5000 Then Return(SetError(3, UDPCloseSocket($avOpenSocket), 0)); Timed out while receiving response from server.
    
    $bvResponseData = StringTrimLeft($bvResponseData, 10); Remove 0xFFFFFFFF
    
    Local $avRet[15] = [0, 0, "", "", "", "", 0, 0, 0, 0, "", 0, 0, ""], $svChar
    
    $avRet[0] = Dec(StringLeft($bvResponseData, 2))                         ; Type
    If $avRet[0] <> 73 Then Return(SetError(4, UDPCloseSocket($avOpenSocket), 0)); This is not a Source server.
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[1] = Dec(StringLeft($bvResponseData, 2))                         ; Version
    $bvResponseData = StringTrimLeft($bvResponseData, 2)

    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[2] &= Chr(Dec($svChar))                 ; Server Name
    Until $svChar = "00"
    
    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[3] &= Chr(Dec($svChar))                 ; Map
    Until $svChar = "00"
    
    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[4] &= Chr(Dec($svChar))                 ; Game Directory
    Until $svChar = "00"
    
    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[5] &= Chr(Dec($svChar))                 ; Game Description
    Until $svChar = "00"
    
    $avRet[6] = Dec(StringReplace(StringLeft($bvResponseData, 4), "00", "")) ; AppID
    $bvResponseData = StringTrimLeft($bvResponseData, 4)
    
    $avRet[7] = Dec(StringLeft($bvResponseData, 2))                            ; Number of players
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[8] = Dec(StringLeft($bvResponseData, 2))                         ; Maximum players
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[9] = Dec(StringLeft($bvResponseData, 2))                            ; Number of bots
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[10] = Chr(Dec(StringLeft($bvResponseData, 2)))                    ; Server mode(d for dedicated, l for listen, p for SourceTV)
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[11] = Chr(Dec(StringLeft($bvResponseData, 2)))                    ; Operating System
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[12] = Dec(StringLeft($bvResponseData, 2))                        ; Passworded
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[13] = Dec(StringLeft($bvResponseData, 2))                        ; Secure
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[14] &= Chr(Dec($svChar))                 ; Game Version
    Until $svChar = "00"
    
    Return(SetError(0, UDPCloseSocket($avOpenSocket), $avRet))
EndFunc

;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

GUICtrlCreateTab(350,5,490,470)
GUICtrlCreateTabItem("Server 8")
GUICtrlCreateLabel("Server IP",20,43,70)
GUICtrlSetFont(-1,12)
$ip8=GUICtrlCreateEdit("",100,40,135,25,$ES_WANTRETURN)
GUICtrlSetFont(-1,12)
GUICtrlCreateLabel(":",242,39)
GUICtrlSetFont(-1,15)
$port8=GUICtrlCreateEdit("",255,40,60,25,$ES_WANTRETURN)
GUICtrlSetFont(-1,12)
GUICtrlCreateButton("Get Info !",335,40,75,25)
GUICtrlSetOnEvent(-1,"GetInfo2")
GUICtrlCreateButton("Exit",420,40,60,25)
GUICtrlSetOnEvent(-1,"_Exit")
GUICtrlSetFont(-1,10)
GUICtrlCreateLabel("--------------------------------------------------------------------------------------------------------------------------------------------------------------",8,75)
GUICtrlSetFont(-1,10)

GUICtrlCreateLabel("Type",15,95)
GUICtrlSetFont(-1,10)
$Type8=GUICtrlCreateEdit("",90,95,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Version",15,120)
GUICtrlSetFont(-1,10)
$Version8=GUICtrlCreateEdit("",90,120,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Name",15,145)
GUICtrlSetFont(-1,10)
$Name8=GUICtrlCreateEdit("",90,145,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Map",15,170)
GUICtrlSetFont(-1,10)
$Map8=GUICtrlCreateEdit("",90,170,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Game dir",15,195,70)
GUICtrlSetFont(-1,10)
$Game8=GUICtrlCreateEdit("",90,195,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Description",15,220,70)
GUICtrlSetFont(-1,10)
$Description8=GUICtrlCreateEdit("",90,220,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("App ID",15,245)
GUICtrlSetFont(-1,10)
$AppID8=GUICtrlCreateEdit("",90,245,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Players",15,270,70)
GUICtrlSetFont(-1,10)
$Players8=GUICtrlCreateEdit("",90,270,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Bot(s)",15,295)
GUICtrlSetFont(-1,10)
$Bot8=GUICtrlCreateEdit("",90,295,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Mode",15,320)
GUICtrlSetFont(-1,10)
$Mode8=GUICtrlCreateEdit("",90,320,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("System",15,345,70)
GUICtrlSetFont(-1,10)
$Sys8=GUICtrlCreateEdit("",90,345,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Password",15,370,70)
GUICtrlSetFont(-1,10)
$pw8=GUICtrlCreateEdit("",90,370,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Secure",15,395)
GUICtrlSetFont(-1,10)
$secure8=GUICtrlCreateEdit("",90,395,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("G.Version",15,420,70)
GUICtrlSetFont(-1,10)
$Gversion8=GUICtrlCreateEdit("",90,420,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Ping",15,445,70)
GUICtrlSetFont(-1,10)
$Ping8=GUICtrlCreateEdit("",90,445,380,20,$ES_READONLY+$ES_WANTRETURN)
GUISetState()

Func GetInfo8()
UDPStartup()
$aServerInfo8 = _SteamNetwork_SourceInfoQuery8(GuiCtrlRead($ip8),GuiCtrlRead($port8))
If Not @error Then
GUICtrlSetData($Type8,$aServerInfo8[0])
GUICtrlSetData($Version8,$aServerInfo8[1])
GUICtrlSetData($Name8,$aServerInfo8[2])
GUICtrlSetData($Map8,$aServerInfo8[3])
GUICtrlSetData($Game8,$aServerInfo8[4])
GUICtrlSetData($Description8,$aServerInfo8[5])
GUICtrlSetData($AppID8,$aServerInfo8[6])
GUICtrlSetData($Players8,$aServerInfo8[7]&"/"&$aServerInfo8[8])
GUICtrlSetData($Bot8,$aServerInfo8[9])

If $aServerInfo8[10]="d" Then
GUICtrlSetData($Mode8,"Dedicated")
EndIf
If $aServerInfo8[10]="l" Then
GUICtrlSetData($Mode8,"Listen")
EndIf
If $aServerInfo8[10]="p" Then
GUICtrlSetData($Mode8,"Source TV")
EndIf

GUICtrlSetData($Sys8,$aServerInfo8[11])

If $aServerInfo8[12]="0" Then
GUICtrlSetData($pw8,"Public")
Else
GUICtrlSetData($pw8,"Private")
EndIf

If $aServerInfo8[13]="1" Then
GUICtrlSetData($Secure8,"VAC")
Else
GUICtrlSetData($Secure8,"Not secured")
EndIf

GUICtrlSetData($GVersion8,$aServerInfo8[14])

$ServerPing8=Ping(GuiCtrlRead($ip8))
GUICtrlSetData($Ping8,$ServerPing8)
Else
MsgBox(48,"Error Server","Server probably offline !")
Exit
EndIf
EndFunc

Func _SteamNetwork_SourceInfoQuery8($svServerAddress8, $ivServerPort8)
    
    Local Const $A2S_INFO = Chr(255) & Chr(255) & Chr(255) & Chr(255) & "TSource Engine Query" & Chr(0)
    
    $avOpenSocket = UDPOpen($svServerAddress8, $ivServerPort8)
    If $avOpenSocket[0] = -1 Then Return(SetError(1, UDPCloseSocket($avOpenSocket), 0)); Error, could not open socket.
    
    Local $ivBytesSent = UDPSend($avOpenSocket, $A2S_INFO)
    If Not $ivBytesSent Then Return(SetError(2, UDPCloseSocket($avOpenSocket), 0)); Error, no bytes could be sent.
    
    Local $bvResponseData, $ivResponseTimer = TimerInit()
    
    Do
        $bvResponseData = UDPRecv($avOpenSocket, 1024)
    Until $bvResponseData <> "" Or TimerDiff($ivResponseTimer) > 5000
    
    If TimerDiff($ivResponseTimer) > 5000 Then Return(SetError(3, UDPCloseSocket($avOpenSocket), 0)); Timed out while receiving response from server.
    
    $bvResponseData = StringTrimLeft($bvResponseData, 10); Remove 0xFFFFFFFF
    
    Local $avRet[15] = [0, 0, "", "", "", "", 0, 0, 0, 0, "", 0, 0, ""], $svChar
    
    $avRet[0] = Dec(StringLeft($bvResponseData, 2))                         ; Type
    If $avRet[0] <> 73 Then Return(SetError(4, UDPCloseSocket($avOpenSocket), 0)); This is not a Source server.
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[1] = Dec(StringLeft($bvResponseData, 2))                         ; Version
    $bvResponseData = StringTrimLeft($bvResponseData, 2)

    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[2] &= Chr(Dec($svChar))                 ; Server Name
    Until $svChar = "00"
    
    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[3] &= Chr(Dec($svChar))                 ; Map
    Until $svChar = "00"
    
    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[4] &= Chr(Dec($svChar))                 ; Game Directory
    Until $svChar = "00"
    
    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[5] &= Chr(Dec($svChar))                 ; Game Description
    Until $svChar = "00"
    
    $avRet[6] = Dec(StringReplace(StringLeft($bvResponseData, 4), "00", "")) ; AppID
    $bvResponseData = StringTrimLeft($bvResponseData, 4)
    
    $avRet[7] = Dec(StringLeft($bvResponseData, 2))                            ; Number of players
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[8] = Dec(StringLeft($bvResponseData, 2))                         ; Maximum players
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[9] = Dec(StringLeft($bvResponseData, 2))                            ; Number of bots
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[10] = Chr(Dec(StringLeft($bvResponseData, 2)))                    ; Server mode(d for dedicated, l for listen, p for SourceTV)
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[11] = Chr(Dec(StringLeft($bvResponseData, 2)))                    ; Operating System
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[12] = Dec(StringLeft($bvResponseData, 2))                        ; Passworded
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[13] = Dec(StringLeft($bvResponseData, 2))                        ; Secure
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[14] &= Chr(Dec($svChar))                 ; Game Version
    Until $svChar = "00"
    
    Return(SetError(0, UDPCloseSocket($avOpenSocket), $avRet))
EndFunc

;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

GUICtrlCreateTab(400,5,490,470)
GUICtrlCreateTabItem("Server 9")
GUICtrlCreateLabel("Server IP",20,43,70)
GUICtrlSetFont(-1,12)
$ip9=GUICtrlCreateEdit("",100,40,135,25,$ES_WANTRETURN)
GUICtrlSetFont(-1,12)
GUICtrlCreateLabel(":",242,39)
GUICtrlSetFont(-1,15)
$port9=GUICtrlCreateEdit("",255,40,60,25,$ES_WANTRETURN)
GUICtrlSetFont(-1,12)
GUICtrlCreateButton("Get Info !",335,40,75,25)
GUICtrlSetOnEvent(-1,"GetInfo2")
GUICtrlCreateButton("Exit",420,40,60,25)
GUICtrlSetOnEvent(-1,"_Exit")
GUICtrlSetFont(-1,10)
GUICtrlCreateLabel("--------------------------------------------------------------------------------------------------------------------------------------------------------------",8,75)
GUICtrlSetFont(-1,10)

GUICtrlCreateLabel("Type",15,95)
GUICtrlSetFont(-1,10)
$Type9=GUICtrlCreateEdit("",90,95,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Version",15,120)
GUICtrlSetFont(-1,10)
$Version9=GUICtrlCreateEdit("",90,120,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Name",15,145)
GUICtrlSetFont(-1,10)
$Name9=GUICtrlCreateEdit("",90,145,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Map",15,170)
GUICtrlSetFont(-1,10)
$Map9=GUICtrlCreateEdit("",90,170,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Game dir",15,195,70)
GUICtrlSetFont(-1,10)
$Game9=GUICtrlCreateEdit("",90,195,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Description",15,220,70)
GUICtrlSetFont(-1,10)
$Description9=GUICtrlCreateEdit("",90,220,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("App ID",15,245)
GUICtrlSetFont(-1,10)
$AppID9=GUICtrlCreateEdit("",90,245,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Players",15,270,70)
GUICtrlSetFont(-1,10)
$Players9=GUICtrlCreateEdit("",90,270,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Bot(s)",15,295)
GUICtrlSetFont(-1,10)
$Bot9=GUICtrlCreateEdit("",90,295,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Mode",15,320)
GUICtrlSetFont(-1,10)
$Mode9=GUICtrlCreateEdit("",90,320,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("System",15,345,70)
GUICtrlSetFont(-1,10)
$Sys9=GUICtrlCreateEdit("",90,345,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Password",15,370,70)
GUICtrlSetFont(-1,10)
$pw9=GUICtrlCreateEdit("",90,370,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Secure",15,395)
GUICtrlSetFont(-1,10)
$secure9=GUICtrlCreateEdit("",90,395,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("G.Version",15,420,70)
GUICtrlSetFont(-1,10)
$Gversion9=GUICtrlCreateEdit("",90,420,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Ping",15,445,70)
GUICtrlSetFont(-1,10)
$Ping9=GUICtrlCreateEdit("",90,445,380,20,$ES_READONLY+$ES_WANTRETURN)
GUISetState()

Func GetInfo9()
UDPStartup()
$aServerInfo9 = _SteamNetwork_SourceInfoQuery9(GuiCtrlRead($ip9),GuiCtrlRead($port9))
If Not @error Then
GUICtrlSetData($Type9,$aServerInfo9[0])
GUICtrlSetData($Version9,$aServerInfo9[1])
GUICtrlSetData($Name9,$aServerInfo9[2])
GUICtrlSetData($Map9,$aServerInfo9[3])
GUICtrlSetData($Game9,$aServerInfo9[4])
GUICtrlSetData($Description9,$aServerInfo9[5])
GUICtrlSetData($AppID9,$aServerInfo9[6])
GUICtrlSetData($Players9,$aServerInfo9[7]&"/"&$aServerInfo9[8])
GUICtrlSetData($Bot9,$aServerInfo9[9])

If $aServerInfo9[10]="d" Then
GUICtrlSetData($Mode9,"Dedicated")
EndIf
If $aServerInfo9[10]="l" Then
GUICtrlSetData($Mode9,"Listen")
EndIf
If $aServerInfo9[10]="p" Then
GUICtrlSetData($Mode9,"Source TV")
EndIf

GUICtrlSetData($Sys9,$aServerInfo9[11])

If $aServerInfo9[12]="0" Then
GUICtrlSetData($pw9,"Public")
Else
GUICtrlSetData($pw9,"Private")
EndIf

If $aServerInfo9[13]="1" Then
GUICtrlSetData($Secure9,"VAC")
Else
GUICtrlSetData($Secure9,"Not secured")
EndIf

GUICtrlSetData($GVersion9,$aServerInfo9[14])

$ServerPing9=Ping(GuiCtrlRead($ip9))
GUICtrlSetData($Ping9,$ServerPing9)
Else
MsgBox(48,"Error Server","Server probably offline !")
Exit
EndIf
EndFunc

Func _SteamNetwork_SourceInfoQuery9($svServerAddress9, $ivServerPort9)
    
    Local Const $A2S_INFO = Chr(255) & Chr(255) & Chr(255) & Chr(255) & "TSource Engine Query" & Chr(0)
    
    $avOpenSocket = UDPOpen($svServerAddress9, $ivServerPort9)
    If $avOpenSocket[0] = -1 Then Return(SetError(1, UDPCloseSocket($avOpenSocket), 0)); Error, could not open socket.
    
    Local $ivBytesSent = UDPSend($avOpenSocket, $A2S_INFO)
    If Not $ivBytesSent Then Return(SetError(2, UDPCloseSocket($avOpenSocket), 0)); Error, no bytes could be sent.
    
    Local $bvResponseData, $ivResponseTimer = TimerInit()
    
    Do
        $bvResponseData = UDPRecv($avOpenSocket, 1024)
    Until $bvResponseData <> "" Or TimerDiff($ivResponseTimer) > 5000
    
    If TimerDiff($ivResponseTimer) > 5000 Then Return(SetError(3, UDPCloseSocket($avOpenSocket), 0)); Timed out while receiving response from server.
    
    $bvResponseData = StringTrimLeft($bvResponseData, 10); Remove 0xFFFFFFFF
    
    Local $avRet[15] = [0, 0, "", "", "", "", 0, 0, 0, 0, "", 0, 0, ""], $svChar
    
    $avRet[0] = Dec(StringLeft($bvResponseData, 2))                         ; Type
    If $avRet[0] <> 73 Then Return(SetError(4, UDPCloseSocket($avOpenSocket), 0)); This is not a Source server.
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[1] = Dec(StringLeft($bvResponseData, 2))                         ; Version
    $bvResponseData = StringTrimLeft($bvResponseData, 2)

    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[2] &= Chr(Dec($svChar))                 ; Server Name
    Until $svChar = "00"
    
    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[3] &= Chr(Dec($svChar))                 ; Map
    Until $svChar = "00"
    
    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[4] &= Chr(Dec($svChar))                 ; Game Directory
    Until $svChar = "00"
    
    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[5] &= Chr(Dec($svChar))                 ; Game Description
    Until $svChar = "00"
    
    $avRet[6] = Dec(StringReplace(StringLeft($bvResponseData, 4), "00", "")) ; AppID
    $bvResponseData = StringTrimLeft($bvResponseData, 4)
    
    $avRet[7] = Dec(StringLeft($bvResponseData, 2))                            ; Number of players
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[8] = Dec(StringLeft($bvResponseData, 2))                         ; Maximum players
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[9] = Dec(StringLeft($bvResponseData, 2))                            ; Number of bots
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[10] = Chr(Dec(StringLeft($bvResponseData, 2)))                    ; Server mode(d for dedicated, l for listen, p for SourceTV)
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[11] = Chr(Dec(StringLeft($bvResponseData, 2)))                    ; Operating System
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[12] = Dec(StringLeft($bvResponseData, 2))                        ; Passworded
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[13] = Dec(StringLeft($bvResponseData, 2))                        ; Secure
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[14] &= Chr(Dec($svChar))                 ; Game Version
    Until $svChar = "00"
    
    Return(SetError(0, UDPCloseSocket($avOpenSocket), $avRet))
EndFunc

;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

GUICtrlCreateTab(450,5,490,470)
GUICtrlCreateTabItem("Server 10")
GUICtrlCreateLabel("Server IP",20,43,70)
GUICtrlSetFont(-1,12)
$ip10=GUICtrlCreateEdit("",100,40,135,25,$ES_WANTRETURN)
GUICtrlSetFont(-1,12)
GUICtrlCreateLabel(":",242,39)
GUICtrlSetFont(-1,15)
$port10=GUICtrlCreateEdit("",255,40,60,25,$ES_WANTRETURN)
GUICtrlSetFont(-1,12)
GUICtrlCreateButton("Get Info !",335,40,75,25)
GUICtrlSetOnEvent(-1,"GetInfo2")
GUICtrlCreateButton("Exit",420,40,60,25)
GUICtrlSetOnEvent(-1,"_Exit")
GUICtrlSetFont(-1,10)
GUICtrlCreateLabel("--------------------------------------------------------------------------------------------------------------------------------------------------------------",8,75)
GUICtrlSetFont(-1,10)

GUICtrlCreateLabel("Type",15,95)
GUICtrlSetFont(-1,10)
$Type10=GUICtrlCreateEdit("",90,95,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Version",15,120)
GUICtrlSetFont(-1,10)
$Version10=GUICtrlCreateEdit("",90,120,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Name",15,145)
GUICtrlSetFont(-1,10)
$Name10=GUICtrlCreateEdit("",90,145,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Map",15,170)
GUICtrlSetFont(-1,10)
$Map10=GUICtrlCreateEdit("",90,170,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Game dir",15,195,70)
GUICtrlSetFont(-1,10)
$Game10=GUICtrlCreateEdit("",90,195,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Description",15,220,70)
GUICtrlSetFont(-1,10)
$Description10=GUICtrlCreateEdit("",90,220,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("App ID",15,245)
GUICtrlSetFont(-1,10)
$AppID10=GUICtrlCreateEdit("",90,245,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Players",15,270,70)
GUICtrlSetFont(-1,10)
$Players10=GUICtrlCreateEdit("",90,270,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Bot(s)",15,295)
GUICtrlSetFont(-1,10)
$Bot10=GUICtrlCreateEdit("",90,295,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Mode",15,320)
GUICtrlSetFont(-1,10)
$Mode10=GUICtrlCreateEdit("",90,320,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("System",15,345,70)
GUICtrlSetFont(-1,10)
$Sys10=GUICtrlCreateEdit("",90,345,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Password",15,370,70)
GUICtrlSetFont(-1,10)
$pw10=GUICtrlCreateEdit("",90,370,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Secure",15,395)
GUICtrlSetFont(-1,10)
$secure10=GUICtrlCreateEdit("",90,395,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("G.Version",15,420,70)
GUICtrlSetFont(-1,10)
$Gversion10=GUICtrlCreateEdit("",90,420,380,20,$ES_READONLY+$ES_WANTRETURN)

GUICtrlCreateLabel("Ping",15,445,70)
GUICtrlSetFont(-1,10)
$Ping10=GUICtrlCreateEdit("",90,445,380,20,$ES_READONLY+$ES_WANTRETURN)
GUISetState()

Func GetInfo10()
UDPStartup()
$aServerInfo10 = _SteamNetwork_SourceInfoQuery10(GuiCtrlRead($ip10),GuiCtrlRead($port10))
If Not @error Then
GUICtrlSetData($Type10,$aServerInfo10[0])
GUICtrlSetData($Version10,$aServerInfo10[1])
GUICtrlSetData($Name10,$aServerInfo10[2])
GUICtrlSetData($Map10,$aServerInfo10[3])
GUICtrlSetData($Game10,$aServerInfo10[4])
GUICtrlSetData($Description10,$aServerInfo10[5])
GUICtrlSetData($AppID10,$aServerInfo10[6])
GUICtrlSetData($Players10,$aServerInfo10[7]&"/"&$aServerInfo10[8])
GUICtrlSetData($Bot10,$aServerInfo10[9])

If $aServerInfo10[10]="d" Then
GUICtrlSetData($Mode10,"Dedicated")
EndIf
If $aServerInfo10[10]="l" Then
GUICtrlSetData($Mode10,"Listen")
EndIf
If $aServerInfo10[10]="p" Then
GUICtrlSetData($Mode10,"Source TV")
EndIf

GUICtrlSetData($Sys10,$aServerInfo10[11])

If $aServerInfo10[12]="0" Then
GUICtrlSetData($pw10,"Public")
Else
GUICtrlSetData($pw10,"Private")
EndIf

If $aServerInfo10[13]="1" Then
GUICtrlSetData($Secure10,"VAC")
Else
GUICtrlSetData($Secure10,"Not secured")
EndIf

GUICtrlSetData($GVersion10,$aServerInfo10[14])

$ServerPing10=Ping(GuiCtrlRead($ip10))
GUICtrlSetData($Ping10,$ServerPing10)
Else
MsgBox(48,"Error Server","Server probably offline !")
Exit
EndIf
EndFunc

Func _SteamNetwork_SourceInfoQuery10($svServerAddress10, $ivServerPort10)
    
    Local Const $A2S_INFO = Chr(255) & Chr(255) & Chr(255) & Chr(255) & "TSource Engine Query" & Chr(0)
    
    $avOpenSocket = UDPOpen($svServerAddress10, $ivServerPort10)
    If $avOpenSocket[0] = -1 Then Return(SetError(1, UDPCloseSocket($avOpenSocket), 0)); Error, could not open socket.
    
    Local $ivBytesSent = UDPSend($avOpenSocket, $A2S_INFO)
    If Not $ivBytesSent Then Return(SetError(2, UDPCloseSocket($avOpenSocket), 0)); Error, no bytes could be sent.
    
    Local $bvResponseData, $ivResponseTimer = TimerInit()
    
    Do
        $bvResponseData = UDPRecv($avOpenSocket, 1024)
    Until $bvResponseData <> "" Or TimerDiff($ivResponseTimer) > 5000
    
    If TimerDiff($ivResponseTimer) > 5000 Then Return(SetError(3, UDPCloseSocket($avOpenSocket), 0)); Timed out while receiving response from server.
    
    $bvResponseData = StringTrimLeft($bvResponseData, 10); Remove 0xFFFFFFFF
    
    Local $avRet[15] = [0, 0, "", "", "", "", 0, 0, 0, 0, "", 0, 0, ""], $svChar
    
    $avRet[0] = Dec(StringLeft($bvResponseData, 2))                         ; Type
    If $avRet[0] <> 73 Then Return(SetError(4, UDPCloseSocket($avOpenSocket), 0)); This is not a Source server.
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[1] = Dec(StringLeft($bvResponseData, 2))                         ; Version
    $bvResponseData = StringTrimLeft($bvResponseData, 2)

    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[2] &= Chr(Dec($svChar))                 ; Server Name
    Until $svChar = "00"
    
    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[3] &= Chr(Dec($svChar))                 ; Map
    Until $svChar = "00"
    
    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[4] &= Chr(Dec($svChar))                 ; Game Directory
    Until $svChar = "00"
    
    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[5] &= Chr(Dec($svChar))                 ; Game Description
    Until $svChar = "00"
    
    $avRet[6] = Dec(StringReplace(StringLeft($bvResponseData, 4), "00", "")) ; AppID
    $bvResponseData = StringTrimLeft($bvResponseData, 4)
    
    $avRet[7] = Dec(StringLeft($bvResponseData, 2))                            ; Number of players
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[8] = Dec(StringLeft($bvResponseData, 2))                         ; Maximum players
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[9] = Dec(StringLeft($bvResponseData, 2))                            ; Number of bots
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[10] = Chr(Dec(StringLeft($bvResponseData, 2)))                    ; Server mode(d for dedicated, l for listen, p for SourceTV)
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[11] = Chr(Dec(StringLeft($bvResponseData, 2)))                    ; Operating System
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[12] = Dec(StringLeft($bvResponseData, 2))                        ; Passworded
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    $avRet[13] = Dec(StringLeft($bvResponseData, 2))                        ; Secure
    $bvResponseData = StringTrimLeft($bvResponseData, 2)
    
    Do
        $svChar = StringLeft($bvResponseData, 2)
        $bvResponseData = StringTrimLeft($bvResponseData, 2)
        If $svChar <> "00" Then $avRet[14] &= Chr(Dec($svChar))                 ; Game Version
    Until $svChar = "00"
    
    Return(SetError(0, UDPCloseSocket($avOpenSocket), $avRet))
EndFunc

GUISetState(@SW_SHOW,$win)
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////;
Func _Exit()
Exit
EndFunc

While 1
sleep(500)
WinSetTitle("CSS Server            <d3mon Tools>","","CSS Server               <d3mon Tools>")
sleep(500)
WinSetTitle("CSS Server               <d3mon Tools>","","CSS Server                    <d3mon Tools>")
sleep(500)
WinSetTitle("CSS Server                    <d3mon Tools>","","CSS Server                         <d3mon Tools>")
sleep(500)
WinSetTitle("CSS Server                         <d3mon Tools>","","CSS Server                              <d3mon Tools>")
sleep(500)
WinSetTitle("CSS Server                              <d3mon Tools>","","CSS Server                                   <d3mon Tools>")
sleep(500)
WinSetTitle("CSS Server                                   <d3mon Tools>","","CSS Server                              <d3mon Tools>")
sleep(500)
WinSetTitle("CSS Server                              <d3mon Tools>","","CSS Server                         <d3mon Tools>")
sleep(500)
WinSetTitle("CSS Server                         <d3mon Tools>","","CSS Server                    <d3mon Tools>")
sleep(500)
WinSetTitle("CSS Server                    <d3mon Tools>","","CSS Server               <d3mon Tools>")
sleep(500)
WinSetTitle("CSS Server               <d3mon Tools>","","CSS Server            <d3mon Tools>")
WEnd
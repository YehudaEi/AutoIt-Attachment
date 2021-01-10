#cs ----------------------------------------------------------------------------

AutoIt Version: 3.2.13.7 (beta)
By       : fredj A.J
E-Mail : Info.dccd@Gmail.Com
Website:                 

#ce ----------------------------------------------------------------------------
#RequireAdmin
#NoTrayIcon
#include <GUIConstants.au3>
#include <IE.au3>
Func OnAutoItStart()
		$text = " DVB Plugin Manager v1.0" & @CRLf
		$text &= "               " & @CRLf
		$text &= " Do this before using" & @CRLf
		$text &= " Go to | File | Check Server Connection!" & @CRLf
		$text &= "               " & @CRLf
		MsgBox (64 , "DVB Plugin Manager v1.0", $text)
EndFunc
AutoItSetOption("GUIOnEventMode", 1)
Opt("GUICoordMode",1)
$GUITitle = "DVB Plugin Manager v1.0 |"&" User | "&@UserName
$GUIWidth = 488
$GUIHeight = 150
Dim $iDloadfinalSize = ""
Dim $iDloadCurrentSize = ""
$GUI = GUICreate($GUITitle, $GUIWidth, $GUIHeight, (@DesktopWidth - $GUIWidth) / 2, (@DesktopHeight - $GUIHeight) / 2)
$input = GUICtrlCreateInput("Put Your URL", 8, 80, 421,22)
$inopenurl = GUICtrlCreateButton("Open", 430, 80, 50, 23)
$Evocamd = GUICtrlCreateButton("Get Evocamd", 8, 49, 100, 23)
$EvocamdS = GUICtrlCreateButton("Get Size", 109, 49, 50, 23)
$Newcamd = GUICtrlCreateButton("Get Newcamd", 8, 1, 100, 23)
$NewcamdS = GUICtrlCreateButton("Get Size", 109, 1, 50, 23)
$Camd3 = GUICtrlCreateButton("Get Camd3", 330, 1, 100, 23)
$Camd3S = GUICtrlCreateButton("Get Size", 430, 1, 50, 23)
$v_keys = GUICtrlCreateButton("Get v_keys.db", 8, 25, 100, 23)
$v_keysS = GUICtrlCreateButton("Get Size", 109, 25, 50, 23)
$v_sids = GUICtrlCreateButton("Get v_sids.db", 170, 25, 100, 23)
$v_sidsS = GUICtrlCreateButton("Get Size", 270, 25, 50, 23)
$TPC = GUICtrlCreateButton("Get TPC.bin", 170, 49, 100, 23)
$TPCS = GUICtrlCreateButton("Get Size", 270, 49, 50, 23)
$NagraGbox = GUICtrlCreateButton("Get (Nagra Gbox)", 330, 49, 100, 23)
$NagraGboxS = GUICtrlCreateButton("Get Size", 430, 49, 50, 23)
$SoftCam = GUICtrlCreateButton("Get SoftCam.Key", 330, 25, 100, 23)
$SoftCamS = GUICtrlCreateButton("Get Size", 430, 25, 50, 23)
;
$progressDownloadStatus = GUICtrlCreateProgress(8, 105, 481 - 10, 20)
;
;
;
$fileMenu       = GUICtrlCreateMenu("&File")
$OpenItem       = GUICtrlCreateMenuItem("&Check Server Connection!", $fileMenu)
GUICtrlCreateMenuItem("", $fileMenu)

$OptionsMenu    = GUICtrlCreateMenu("O&ptions", $fileMenu)
$ViewItem       = GUICtrlCreateMenuItem("Go to Skystar Website", $OptionsMenu)
GUICtrlCreateMenuItem("", $OptionsMenu)
$ToolsItem      = GUICtrlCreateMenuItem("Go to Autoit Website", $OptionsMenu)

GUICtrlCreateMenuItem("", $fileMenu)
$ExitItem       = GUICtrlCreateMenuItem("&Exit", $fileMenu)

$HelpMenu       = GUICtrlCreateMenu("&Help")
$AboutItem      = GUICtrlCreateMenuItem("&About", $HelpMenu)

$EndBtn         = GUICtrlCreateButton("End", 110, 140, 70, 20)
GUISetState()

#Region Events list
GUISetOnEvent($GUI_EVENT_CLOSE, "_ExitIt")
GUICtrlSetOnEvent($Evocamd,"_Evocamd")
GUICtrlSetOnEvent($EvocamdS,"_EvocamdS")
GUICtrlSetOnEvent($Newcamd,"_Newcamd")
GUICtrlSetOnEvent($NewcamdS,"_NewcamdS")
GUICtrlSetOnEvent($Camd3,"_Camd3")
GUICtrlSetOnEvent($Camd3S,"_Camd3S")
GUICtrlSetOnEvent($v_keys,"_vkeys")
GUICtrlSetOnEvent($v_keysS,"_vkeysS")
GUICtrlSetOnEvent($v_sids,"_vsids")
GUICtrlSetOnEvent($v_sidsS,"_vsidsS")
GUICtrlSetOnEvent($TPC,"_TPC")
GUICtrlSetOnEvent($TPCS,"_TPCS")
GUICtrlSetOnEvent($NagraGbox,"_NagraGbox")
GUICtrlSetOnEvent($NagraGboxS,"_NagraGboxS")
GUICtrlSetOnEvent($SoftCam,"_SoftCam")
GUICtrlSetOnEvent($SoftCamS,"_SoftCamS")
GUICtrlSetOnEvent($input,"_inopenurl")
;
GUICtrlSetOnEvent($ExitItem,"_ExitItem")
GUICtrlSetOnEvent($AboutItem,"_AboutItem")
GUICtrlSetOnEvent($ToolsItem,"_ToolsItem")
GUICtrlSetOnEvent($ViewItem,"_ViewItem")
GUICtrlSetOnEvent($OpenItem,"_OpenItem")
#EndRegion Events list

While 1
    Sleep(10)
    If $iDloadfinalSize <> "" Then _CheckActiveDownload()
WEnd

func _ExitIt()
    Exit
Endfunc

func _CheckActiveDownload()
    If @InetgetBytesRead <> "-1" Then
        $iDloadCurrentSize = @InetgetBytesRead
        $iPercentage = Int(($iDloadCurrentSize/$iDloadfinalSize)*100)
        GUICtrlSetData($progressDownloadStatus,$iPercentage)
    Else
        $iDloadfinalSize = ""
        GUICtrlSetData($progressDownloadStatus,"0")
        MsgBox(16,"Error","The download was cancelled, or did not complete successfully.")
    EndIf
    If $iDloadCurrentSize = $iDloadfinalSize Then
        $iDloadfinalSize = ""
        MsgBox(64,"Complete","Download complete!")
    EndIf
Endfunc
func _exit()
		Exit
Endfunc
;
;
;
;
func _Evocamd()
    If @InetgetActive Then
        Inetget("abort")
        GUICtrlSetData($progressDownloadStatus,"0")
    Else
        $sfileURL = "                                               "
		$MyDocsfolder = "::{450D8fBA-AD25-11D0-98A8-0800361B1103}"
        $sfileDest = fileSaveDialog( "Save As.", $MyDocsfolder, "Keylist (*.db;*.txt)", 2,"Keylist.txt")
		;fileSelectfolder("Choose a folder.", "v.pdf")
        $iDloadfinalSize = InetgetSize($sfileURL)
        $iDloadCurrentSize = "0"
        Inetget($sfileURL, $sfileDest, 1, 1)
    EndIf
Endfunc
func _EvocamdS()
		$size = InetgetSize("                                               ")
        MsgBox(0, "Size of remote file:",& "Size of remote file  " $size&" bytes")
Endfunc
func _Newcamd()
    If @InetgetActive Then
        Inetget("abort")
        GUICtrlSetData($progressDownloadStatus,"0")
    Else
        $sfileURL = "                                           "
		$MyDocsfolder = "::{450D8fBA-AD25-11D0-98A8-0800361B1103}"
        $sfileDest = fileSaveDialog( "Save As.", $MyDocsfolder, "keylist (*txt)", 2,"keylist")
		;fileSelectfolder("Choose a folder.", "v.pdf")
        $iDloadfinalSize = InetgetSize($sfileURL)
        $iDloadCurrentSize = "0"
        Inetget($sfileURL, $sfileDest, 1, 1)
    EndIf
Endfunc
func _NewcamdS()
		$size = InetgetSize("                                           ")
        MsgBox(0, "Size of remote file:",& "Size of remote file  " $size&" bytes")
Endfunc
func _Camd3()
    If @InetgetActive Then
        Inetget("abort")
        GUICtrlSetData($progressDownloadStatus,"0")
    Else
        $sfileURL = "                                              "
		$MyDocsfolder = "::{450D8fBA-AD25-11D0-98A8-0800361B1103}"
        $sfileDest = fileSaveDialog( "Save As.", $MyDocsfolder, "Camd3 files (*.keys;*.txt)", 2,"camd3.keys")
		;fileSelectfolder("Choose a folder.", "v.pdf")
        $iDloadfinalSize = InetgetSize($sfileURL)
        $iDloadCurrentSize = "0"
        Inetget($sfileURL, $sfileDest, 1, 1)
    EndIf
Endfunc
func _Camd3S()
		$size = InetgetSize("                                              ")
        MsgBox(0, "Size of remote file:",& "Size of remote file  " $size&" bytes")
Endfunc
func _vkeys()
    If @InetgetActive Then
        Inetget("abort")
        GUICtrlSetData($progressDownloadStatus,"0")
    Else
        $sfileURL = "                                             "
		$MyDocsfolder = "::{450D8fBA-AD25-11D0-98A8-0800361B1103}"
        $sfileDest = fileSaveDialog( "Save As.", $MyDocsfolder, "v keys files (*.db;*.txt)", 2,"v_keys.db")
		;fileSelectfolder("Choose a folder.", "v.pdf")
        $iDloadfinalSize = InetgetSize($sfileURL)
        $iDloadCurrentSize = "0"
        Inetget($sfileURL, $sfileDest, 1, 1)
    EndIf
Endfunc
func _vkeysS()
		$size = InetgetSize("                                             ")
        MsgBox(0, "Size of remote file:",& "Size of remote file  " $size&" bytes")
Endfunc
func _vsids()
    If @InetgetActive Then
        Inetget("abort")
        GUICtrlSetData($progressDownloadStatus,"0")
    Else
        $sfileURL = "http://www.skystar.org/arsiv/dailytps/v_sids.db"
		$MyDocsfolder = "::{450D8fBA-AD25-11D0-98A8-0800361B1103}"
        $sfileDest = fileSaveDialog( "Save As.", $MyDocsfolder, "v_sids files (*.db;*.txt)", 2,"v_sids.db")
		;fileSelectfolder("Choose a folder.", "v.pdf")
        $iDloadfinalSize = InetgetSize($sfileURL)
        $iDloadCurrentSize = "0"
        Inetget($sfileURL, $sfileDest, 1, 1)
    EndIf
Endfunc
func _vsidsS()
		$size = InetgetSize("http://www.skystar.org/arsiv/dailytps/v_sids.db")
        MsgBox(0, "Size of remote file:",& "Size of remote file  " $size&" bytes")
Endfunc	
func _TPC()
    If @InetgetActive Then
        Inetget("abort")
        GUICtrlSetData($progressDownloadStatus,"0")
    Else
        $sfileURL = "http://www.skystar.org/arsiv/dailytps/tps.bin"
		$MyDocsfolder = "::{450D8fBA-AD25-11D0-98A8-0800361B1103}"
        $sfileDest = fileSaveDialog( "Save As.", $MyDocsfolder, "TPC files (*.bin;*.txt)", 2,"tps.bin")
		;fileSelectfolder("Choose a folder.", "v.pdf")
        $iDloadfinalSize = InetgetSize($sfileURL)
        $iDloadCurrentSize = "0"
        Inetget($sfileURL, $sfileDest, 1, 1)
    EndIf
Endfunc
func _TPCS()
		$size = InetgetSize("http://www.skystar.org/arsiv/dailytps/tps.bin")
        MsgBox(0, "Size of remote file:",& "Size of remote file  " $size&" bytes")	
Endfunc
func _NagraGbox()
    If @InetgetActive Then
        Inetget("abort")
        GUICtrlSetData($progressDownloadStatus,"0")
    Else
        $sfileURL = "                                         "
		$MyDocsfolder = "::{450D8fBA-AD25-11D0-98A8-0800361B1103}"
        $sfileDest = fileSaveDialog( "Save As.", $MyDocsfolder, "Nagra files (*.txt)", 2,"nagra")
		;fileSelectfolder("Choose a folder.", "v.pdf")
        $iDloadfinalSize = InetgetSize($sfileURL)
        $iDloadCurrentSize = "0"
        Inetget($sfileURL, $sfileDest, 1, 1)
    EndIf
Endfunc
func _NagraGboxS()
		$size = InetgetSize("                                         ")
        MsgBox(0, "Size of remote file:",& "Size of remote file  " $size&" bytes")
Endfunc
func _SoftCam()
    If @InetgetActive Then
        Inetget("abort")
        GUICtrlSetData($progressDownloadStatus,"0")
    Else
        $sfileURL = "                                               "
		$MyDocsfolder = "::{450D8fBA-AD25-11D0-98A8-0800361B1103}"
        $sfileDest = fileSaveDialog( "Save As.", $MyDocsfolder, "SoftCam files (*.key;*.txt)", 2,"SoftCam.Key")
		;fileSelectfolder("Choose a folder.", "v.pdf")
        $iDloadfinalSize = InetgetSize($sfileURL)
        $iDloadCurrentSize = "0"
        Inetget($sfileURL, $sfileDest, 1, 1)
    EndIf
Endfunc
func _SoftCamS()
		$size = InetgetSize("                                               ")
        MsgBox(0, "Size of remote file:",& "Size of remote file  " $size&" bytes")
Endfunc
func _ExitItem()
		Exit
Endfunc
func _AboutItem()
		$text = " About DVB Plugin Manager v1.0" & @CRLf
		$text &= " --------------------------------------------------------------------------------------              " & @CRLf
		$text &= " Always Updated SoftCam" & @CRLf
		$text &= " Always Updated Keylist Evocamd" & @CRLf
		$text &= " keylist Newcamd | Camd3 | v_keys | v_sids | tps | vPlug | nagra gbox " & @CRLf
		$text &= " --------------------------------------------------------------------------------------              " & @CRLf
		$text &= " Powered by:" & @CRLf
        $text &= " Website :www.skystar.org" & @CRLf
		$text &= " Forum    :www.autoitscript.com/forum" & @CRLf
		$text &= " E-Mail     :Info.dccd@Gmail.com" & @CRLf
		$text &= " --------------------------------------------------------------------------------------              " & @CRLf
		$text &= "               " & @CRLf		
		$text &= "               " & @CRLf
		$text &= "               " & @CRLf
		$text &= " This product is licensed under the terms of the End-User " & @CRLf
		$text &= " License Agreement to:" & @CRLf
		$text &= "               " & @CRLf
		$text &=  ">>"&  @UserName&"<<" & @CRLf
		MsgBox (64 , "About DVB Plugin Manager v1.0", $text)
Endfunc
func _ToolsItem()
		$oIE = _IECreate ("http://www.autoitscript.com/forum/index.php?")
Endfunc
func _ViewItem()
		$oIE = _IECreate ("http://www.skystar.org")
Endfunc
func _OpenItem()
		$ping = Ping("www.uydu.ws")
		If $ping > 0 then
		    Msgbox(64, "Internet connection active!", "The Server works fine...")
		Else 
			$text = " Help" & @CRLf
			$text2 = " The Server is Down..." & @CRLf
		    $text2 &= " Please try again later" & @CRLf
			Msgbox(16, "Connection to Server' Error!", $text2)
		EndIf
Endfunc
While 1
    Sleep(100)
    $gMsg = GUIGetMsg()
    Switch $gMsg
    Case $GUI_EVENT_CLOSE
        Exit
    Case $inopenurl
        _inopenurl()
    EndSwitch
WEnd

func _inopenurl()
		$input = GUICtrlRead($input)
        $sfileURL = $input
		$oIE = _IECreate ($input)
Endfunc
#include <GUIConstants.au3>
#include <WindowsConstants.au3>

GUICreate("Connexion Internet", 280, 220, 150, 150, BitOR($WS_MINIMIZEBOX, $WS_SIZEBOX, $WS_THICKFRAME, $WS_SYSMENU, $WS_POPUP, $WS_GROUP, $WS_CLIPSIBLINGS), BitOR($WS_EX_TOOLWINDOW, $WS_EX_TOPMOST, $WS_EX_WINDOWEDGE))

GUICtrlCreateGroup("Connexion", 5, 5, 290, 35)
GUICtrlCreateLabel("Status:", 25, 22, 35, 15)
$statusstate = GUICtrlCreateLabel("", 120, 22, 170, 15)

GUICtrlCreateGroup("Activité", 5, 45, 210, 65)
GUICtrlCreateLabel("Envoyés:", 15, 62, 50, 15)
$amont = GUICtrlCreateLabel("En attente de données...", 120, 62, 170, 15)
GUICtrlCreateLabel("Reçus:", 15, 77, 70, 15)
$aval = GUICtrlCreateLabel("En attente de données...", 120, 77, 170, 15)
GUICtrlCreateLabel("Activité totale:", 15, 92, 70, 15)
$totalstate = GUICtrlCreateLabel("", 120, 92, 170, 15)

GUICtrlCreateGroup("Time", 5, 115, 290, 35)
GUICtrlCreateLabel("Time connected:", 25, 132, 80, 15)
$timestate = GUICtrlCreateLabel("", 120, 132, 170, 15)

GUISetState()

$wbemFlagReturnImmediately = 0x10
$wbemFlagForwardOnly = 0x20
$colItems = ""
$objWMIService = ObjGet("winmgmts:\\localhost\root\CIMV2")

$inmax = 0
$outmax = 0

$lastin = 0
$lastout = 0
$seconds = 0 * 60
Countdown()
AdlibRegister("Countdown", 1000)

While 1

    $colItems = $objWMIService.ExecQuery("SELECT BytesReceivedPersec,BytesSentPersec FROM Win32_PerfRawData_Tcpip_NetworkInterface", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)

    If IsObj($colItems) then
        For $objItem In $colItems
            $newin = $objItem.BytesReceivedPersec
            $newout = $objItem.BytesSentPersec

            If $lastin = 0 and $lastout = 0 Then
                $lastin = $newin
                $lastout = $newout
            Endif

            $in = $newin - $lastin
            $out = $newout - $lastout
            $lastin = $newin
            $lastout = $newout

            if $in <> 0 and $out <> 0 Then
                $inmax = $inmax + $in
                $outmax = $outmax + $out
                $inP = Round((($inmax / 1024) / 1024), 3)
                $outP = Round((($outmax / 1024) / 1024), 3)
				$totalP = Round(((($inmax + $outmax) /1024) / 1048576), 3)
                $intext = int($inmax) & " octets (" & $inP & " Mo)"
                $outtext = int($outmax) & " octets (" & $outP & " Mo)"
				$totalin = $inP + $outP & " Mo (" & $totalP & " Go)"
                GUICtrlSetData($amont,$intext)
                GUICtrlSetData($aval,$outtext)
				GUICtrlSetData($totalstate,$totalin)
            EndIf

            ExitLoop
        Next
    EndIf
    Sleep(1000)

	If @IPAddress1 <> "127.0.0.1" Then
		GUICtrlSetData($statusstate,"Connecté")
		AdlibRegister("Countdown", 1000)
	Else
		GUICtrlSetData($statusstate,"Non-connecté")
		GUICtrlSetData($amont,"")
        GUICtrlSetData($aval,"")
		GUICtrlSetData($totalstate,"")
		AdlibUnRegister("Countdown")
	EndIf
WEnd

Func Countdown()
    Local $sec, $min, $hr
    $sec = Mod($seconds, 60)
    $min = Mod($seconds / 60, 60)
    $hr = Floor($seconds / 60 ^ 2)
    GUICtrlSetData($timestate, StringFormat("%02i:%02i:%02i", $hr, $min, $sec))
    $seconds += 1
EndFunc
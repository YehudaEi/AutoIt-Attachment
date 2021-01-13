#Include <Constants.au3>
#include <INet.au3>
#NoTrayIcon
Opt("TrayMenuMode",1)

global $servernumber=1,$dl=1,$joke=""

While 1
	$msg = TrayGetMsg()
	if $dl=1 then
		do 
			select
				case $servernumber =1
					$source=_INetGetSource( "                                       ")
					$servernumber=$servernumber+1
					if not @error then 
						$joke=stringreplace(stringbetween($source,"<p>", "</p>"),"<br />","")
						ExitLoop(1)
					endif
				case $servernumber = 2
					$source=_INetGetSource( "                                                    ")
					$servernumber=$servernumber+1
					if not @error then 
						$joke=stringtrimleft(stringbetween($source,"black;","</td><td valign=top width=180>"),2)
						exitloop(1)
					endif
				case $servernumber = 3
					$source=_INetGetSource( "                                        ")
					$servernumber=$servernumber+1
					if not @error then 
						$joke=stringtrimleft(stringreplace(stringbetween($source,"next joke|back to topic list","<CENTER>"),"<p>",""),7)
						exitloop(1)
					endif
			endselect
		until $servernumber>3
		if $servernumber>3 then $servernumber=1
		if $joke <> "" then $dl=0
		TraySetState()
	endif
	Select
		Case $msg = $TRAY_EVENT_PRIMARYDOWN
			$dl=1
			TraySetState(2)
			msgbox(0,"Random joke!",$joke)
			$joke=""
		Case $msg = $TRAY_EVENT_SECONDARYUP
			Exit
	endselect
WEnd

Func stringbetween($str, $start, $end)
    $pos = StringInStr($str, $start)
    If Not @error Then
        $str = StringTrimLeft($str, $pos + StringLen($start) - 1)
        $pos = StringInStr($str, $end)
        If Not @error Then
            $str = StringTrimRight($str, StringLen($str) - $pos + 1)
            Return $str
        EndIf
    EndIf
EndFunc
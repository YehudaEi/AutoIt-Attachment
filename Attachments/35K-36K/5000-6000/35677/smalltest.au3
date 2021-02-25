;This keeps your program from being run again while the program is still running.
#include <GUIConstantsEx.au3>
#include <ButtonConstants.au3>
#Include <Array.au3>
#include <Misc.au3>
if _Singleton("Warning",1) = 0 Then
	Msgbox(0,"Warning","An occurence of your program is already running")
	Exit
EndIf
Opt('MustDeclareVars', 1)
Menu()
Func Menu()
    Local $msg, $space
	Local $OwenD[8] 
	Local $OwenDi[7] ;install
	Local $OwenDu[7] ;uninstall
	Local $OwenH[26] ;printers
	Local $yes=1, $no=0
	Local $Data[26]=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0] ;data
	
    GUICreate("District printer list", 500, 40)
;-------------Menu for Owen District----------------------------------------
	$OwenD[1] = GUICtrlCreateMenu("&Owen") 
		$OwenD[2] = GUICtrlCreateMenu("&Owen",$OwenD[1]);25
			$OwenH[1] = GUICtrlCreateMenuItem("Art Room Color Laser Printer",$OwenD[2])
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			$OwenH[2] = GUICtrlCreateMenuItem("printer2",$OwenD[2])
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			$OwenH[3]= GUICtrlCreateMenuItem("printer3",$OwenD[2])
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			$OwenH[4] = GUICtrlCreateMenuItem("printer4",$OwenD[2])
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			$OwenH[5] = GUICtrlCreateMenuItem("printer5",$OwenD[2])
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			$OwenH[6] = GUICtrlCreateMenuItem("printer6",$OwenD[2])
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			$OwenH[7] = GUICtrlCreateMenuItem("Guidance HP 4050",$OwenD[2])
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			$OwenH[8] = GUICtrlCreateMenuItem("printer8",$OwenD[2])
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			$OwenH[9] = GUICtrlCreateMenuItem("printer9",$OwenD[2])
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			$OwenH[10] = GUICtrlCreateMenuItem("printer10",$OwenD[2])
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			$OwenH[11] = GUICtrlCreateMenuItem("printer11",$OwenD[2])
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			$OwenH[12] = GUICtrlCreateMenuItem("Lab 212 Color Laser Printer",$OwenD[2])
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			$OwenH[13] = GUICtrlCreateMenuItem("Lab 212 Laser Printer",$OwenD[2])
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			$OwenH[14] = GUICtrlCreateMenuItem("printer14",$OwenD[2])
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			$OwenH[15] = GUICtrlCreateMenuItem("printer15",$OwenD[2])
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			$OwenH[16] = GUICtrlCreateMenuItem("printer16",$OwenD[2])
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			$OwenH[17] = GUICtrlCreateMenuItem("printer17",$OwenD[2])
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			$OwenH[18] = GUICtrlCreateMenuItem("printer18",$OwenD[2])
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			$OwenH[19] = GUICtrlCreateMenuItem("printer19",$OwenD[2])
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			$OwenH[20] = GUICtrlCreateMenuItem("printer20",$OwenD[2])
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			$OwenH[21] = GUICtrlCreateMenuItem("printer21",$OwenD[2])
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			$OwenH[22] = GUICtrlCreateMenuItem("printer22",$OwenD[2])
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			$OwenH[23] = GUICtrlCreateMenuItem("printer23",$OwenD[2])
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			$OwenH[24] = GUICtrlCreateMenuItem("printer24",$OwenD[2])
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			$OwenH[25] = GUICtrlCreateMenuItem("Spare HP Laser Printer",$OwenD[2])
			GUICtrlSetState(-1, $GUI_UNCHECKED)
		$space = GUICtrlCreateMenuItem("",$OwenD[2]) 	; create a separator line
		$OwenDi[1] = GUICtrlCreateMenuItem("install",$OwenD[2])
		$space = GUICtrlCreateMenuItem("",$OwenD[2]) 	; create a separator line
		$OwenDu[1] = GUICtrlCreateMenuItem("uninstall",$OwenD[2])
		
;-----------------------------------------------------------------------------------	
	
	GUISetState()
	While 1
		$msg = GUIGetMsg()
		Switch $msg
	            Case $GUI_EVENT_CLOSE
	                ExitLoop
;-------------------------Owen High------------------------------------------------------------23
		Case $OwenH[1]
			If BitAND(GUICtrlRead($OwenH[1]), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetState($OwenH[1], $GUI_UNCHECKED)
			Else
				GUICtrlSetState($OwenH[1], $GUI_CHECKED)
				$Data[1]=$yes
			EndIf
		Case $OwenH[2]
			If BitAND(GUICtrlRead($OwenH[2]), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetState($OwenH[2], $GUI_UNCHECKED)
			Else
				GUICtrlSetState($OwenH[2], $GUI_CHECKED)
				$Data[2]=$yes
			EndIf
		Case $OwenH[3]
			If BitAND(GUICtrlRead($OwenH[3]), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetState($OwenH[3], $GUI_UNCHECKED)
			Else
				GUICtrlSetState($OwenH[3], $GUI_CHECKED)
				$Data[3]=$yes
			EndIf
		Case $OwenH[4]
			If BitAND(GUICtrlRead($OwenH[4]), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetState($OwenH[4], $GUI_UNCHECKED)
			Else
				GUICtrlSetState($OwenH[4], $GUI_CHECKED)
				$Data[4]=$yes
			EndIf
		Case $OwenH[5]
			If BitAND(GUICtrlRead($OwenH[5]), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetState($OwenH[5], $GUI_UNCHECKED)
			Else
				GUICtrlSetState($OwenH[5], $GUI_CHECKED)
				$Data[5]=$yes
			EndIf
		Case $OwenH[6]
			If BitAND(GUICtrlRead($OwenH[6]), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetState($OwenH[6], $GUI_UNCHECKED)
			Else
				GUICtrlSetState($OwenH[6], $GUI_CHECKED)
				$Data[6]=$yes
			EndIf
		Case $OwenH[7]
			If BitAND(GUICtrlRead($OwenH[7]), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetState($OwenH[7], $GUI_UNCHECKED)
			Else
				GUICtrlSetState($OwenH[7], $GUI_CHECKED)
				$Data[7]=$yes
			EndIf
		Case $OwenH[8]
			If BitAND(GUICtrlRead($OwenH[8]), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetState($OwenH[8], $GUI_UNCHECKED)
			Else
				GUICtrlSetState($OwenH[8], $GUI_CHECKED)
				$Data[8]=$yes
			EndIf
		Case $OwenH[9]
			If BitAND(GUICtrlRead($OwenH[9]), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetState($OwenH[9], $GUI_UNCHECKED)
			Else
				GUICtrlSetState($OwenH[9], $GUI_CHECKED)
				$Data[9]=$yes
			EndIf
		Case $OwenH[10]
			If BitAND(GUICtrlRead($OwenH[10]), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetState($OwenH[10], $GUI_UNCHECKED)
			Else
				GUICtrlSetState($OwenH[10], $GUI_CHECKED)
				$Data[10]=$yes
			EndIf
		Case $OwenH[11]
			If BitAND(GUICtrlRead($OwenH[11]), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetState($OwenH[11], $GUI_UNCHECKED)
			Else
				GUICtrlSetState($OwenH[11], $GUI_CHECKED)
				$Data[1]=$yes
			EndIf
		Case $OwenH[12]
			If BitAND(GUICtrlRead($OwenH[12]), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetState($OwenH[12], $GUI_UNCHECKED)
			Else
				GUICtrlSetState($OwenH[12], $GUI_CHECKED)
				$Data[12]=$yes
			EndIf
		Case $OwenH[13]
			If BitAND(GUICtrlRead($OwenH[13]), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetState($OwenH[13], $GUI_UNCHECKED)
			Else
				GUICtrlSetState($OwenH[13], $GUI_CHECKED)
				$Data[13]=$yes
			EndIf
		Case $OwenH[14]
			If BitAND(GUICtrlRead($OwenH[14]), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetState($OwenH[14], $GUI_UNCHECKED)
			Else
				GUICtrlSetState($OwenH[14], $GUI_CHECKED)
				$Data[14]=$yes
			EndIf
		Case $OwenH[15]
			If BitAND(GUICtrlRead($OwenH[15]), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetState($OwenH[15], $GUI_UNCHECKED)
			Else
				GUICtrlSetState($OwenH[15], $GUI_CHECKED)
				$Data[15]=$yes
			EndIf
		Case $OwenH[16]
			If BitAND(GUICtrlRead($OwenH[16]), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetState($OwenH[16], $GUI_UNCHECKED)
			Else
				GUICtrlSetState($OwenH[16], $GUI_CHECKED)
				$Data[16]=$yes
			EndIf
		Case $OwenH[17]
			If BitAND(GUICtrlRead($OwenH[17]), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetState($OwenH[17], $GUI_UNCHECKED)
			Else
				GUICtrlSetState($OwenH[17], $GUI_CHECKED)
				$Data[17]=$yes
			EndIf
		Case $OwenH[18]
			If BitAND(GUICtrlRead($OwenH[18]), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetState($OwenH[18], $GUI_UNCHECKED)
			Else
				GUICtrlSetState($OwenH[18], $GUI_CHECKED)
				$Data[18]=$yes
			EndIf
		Case $OwenH[19]
			If BitAND(GUICtrlRead($OwenH[19]), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetState($OwenH[19], $GUI_UNCHECKED)
			Else
				GUICtrlSetState($OwenH[19], $GUI_CHECKED)
				$Data[19]=$yes
			EndIf
		Case $OwenH[20]
			If BitAND(GUICtrlRead($OwenH[20]), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetState($OwenH[20], $GUI_UNCHECKED)
			Else
				GUICtrlSetState($OwenH[20], $GUI_CHECKED)
				$Data[20]=$yes
			EndIf
		Case $OwenH[21]
			If BitAND(GUICtrlRead($OwenH[21]), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetState($OwenH[21], $GUI_UNCHECKED)
			Else
				GUICtrlSetState($OwenH[21], $GUI_CHECKED)
				$Data[21]=$yes
			EndIf
		Case $OwenH[22]
			If BitAND(GUICtrlRead($OwenH[22]), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetState($OwenH[22], $GUI_UNCHECKED)
			Else
				GUICtrlSetState($OwenH[22], $GUI_CHECKED)
				$Data[22]=$yes
			EndIf
		Case $OwenH[23]
			If BitAND(GUICtrlRead($OwenH[23]), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetState($OwenH[23], $GUI_UNCHECKED)
			Else
				GUICtrlSetState($OwenH[23], $GUI_CHECKED)
				$Data[23]=$yes
			EndIf
		Case $OwenH[24]
			If BitAND(GUICtrlRead($OwenH[24]), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetState($OwenH[24], $GUI_UNCHECKED)
			Else
				GUICtrlSetState($OwenH[24], $GUI_CHECKED)
				$Data[24]=$yes
			EndIf
		Case $OwenH[25]
			If BitAND(GUICtrlRead($OwenH[25]), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetState($OwenH[25], $GUI_UNCHECKED)
			Else
				GUICtrlSetState($OwenH[25], $GUI_CHECKED)
				$Data[25]=$yes
			EndIf
;----------------------------------------------------------------------------------
		Case $OwenDi[1] ;25
			;_ArrayDisplay($Data)
			;GUIDelete()
			if $Data[1] = $yes Then 
				RunWait(@ComSpec & " /c " & 'iprntcmd -a ipp://x.x.x.x/ipp/"Art Room Color Laser Printer"',@SW_HIDE);MsgBox(64,"","printer 1.1",8)
			EndIf
			if $Data[2] = $yes Then MsgBox(64,"","printer 1.2",8)
			if $Data[3] = $yes Then MsgBox(64,"","printer 1.3",8)
			if $Data[4] = $yes Then MsgBox(64,"","printer 1.4",8)
			if $Data[5] = $yes Then MsgBox(64,"","printer 1.5",8)
			if $Data[6] = $yes Then MsgBox(64,"","printer 1.6",8)
			if $Data[7] = $yes Then 
				RunWait(@ComSpec & " /c " & 'iprntcmd -a ipp://x.x.x.x/ipp/"Guidance HP 4050"',@SW_HIDE);MsgBox(64,"","printer 1.7",8)
			EndIf
			if $Data[8] = $yes Then MsgBox(64,"","printer 1.8",8)
			if $Data[9] = $yes Then MsgBox(64,"","printer 1.9",8)
			if $Data[10] = $yes Then MsgBox(64,"","printer 1.10",8)
			if $Data[11] = $yes Then MsgBox(64,"","printer 1.11",8)
			if $Data[12] = $yes Then 
				RunWait(@ComSpec & " /c " & 'iprntcmd -a ipp://x.x.x.x/ipp/"Lab 212 Color Laser Printer"',@SW_HIDE);MsgBox(64,"","printer 1.12",8) 
			EndIf
			if $Data[13] = $yes Then 
				RunWait(@ComSpec & " /c " & 'iprntcmd -a ipp://x.x.x.x/ipp/"Lab 212 Laser Printer"',@SW_HIDE);MsgBox(64,"","printer 1.13",8)
			EndIf
			if $Data[14] = $yes Then MsgBox(64,"","printer 1.14",8)
			if $Data[15] = $yes Then MsgBox(64,"","printer 1.15",8)
			if $Data[16] = $yes Then MsgBox(64,"","printer 1.16",8)
			if $Data[17] = $yes Then MsgBox(64,"","printer 1.17",8)
			if $Data[18] = $yes Then MsgBox(64,"","printer 1.18",8)
			if $Data[19] = $yes Then MsgBox(64,"","printer 1.19",8)
			if $Data[20] = $yes Then MsgBox(64,"","printer 1.20",8)
			if $Data[21] = $yes Then MsgBox(64,"","printer 1.21",8)
			if $Data[22] = $yes Then MsgBox(64,"","printer 1.22",8)
			if $Data[23] = $yes Then MsgBox(64,"","printer 1.23",8)
			if $Data[24] = $yes Then MsgBox(64,"","printer 1.24",8)
			if $Data[25] = $yes Then 
				RunWait(@ComSpec & " /c " & 'iprntcmd -a ipp://x.x.x.x/ipp/"Spare HP Laser Printer"',@SW_HIDE);MsgBox(64,"","printer 1.25",8)
			EndIf
			MsgBox(64,"","Installing Printers",8)
			Exit
;----------------------------------------------------------------------------
		Case $OwenDu[1] ;25
			GUIDelete()
			if $Data[1] = $yes Then RunWait(@ComSpec & " /c " & 'iprntcmd -d ipp://x.x.x.x/ipp/"Art Room Color Laser Printer"',@SW_HIDE);MsgBox(64,"","printer 1.1",8) 
			if $Data[2] = $yes Then MsgBox(64,"","printer 1.2",8)
			if $Data[3] = $yes Then MsgBox(64,"","printer 1.3",8)
			if $Data[4] = $yes Then MsgBox(64,"","printer 1.4",8)
			if $Data[5] = $yes Then MsgBox(64,"","printer 1.5",8)
			if $Data[6] = $yes Then MsgBox(64,"","printer 1.6",8)
			if $Data[7] = $yes Then RunWait(@ComSpec & " /c " & 'iprntcmd -d ipp://x.x.x.x/ipp/"Guidance HP 4050"',@SW_HIDE);MsgBox(64,"","printer 1.7",8)
			if $Data[8] = $yes Then MsgBox(64,"","printer 1.8",8)
			if $Data[9] = $yes Then MsgBox(64,"","printer 1.9",8)
			if $Data[10] = $yes Then MsgBox(64,"","printer 1.10",8)
			if $Data[11] = $yes Then MsgBox(64,"","printer 1.11",8)
			if $Data[12] = $yes Then RunWait(@ComSpec & " /c " & 'iprntcmd -d ipp://x.x.x.x/ipp/"Lab 212 Color Laser Printer"',@SW_HIDE);MsgBox(64,"","printer 1.12",8) 
			if $Data[13] = $yes Then RunWait(@ComSpec & " /c " & 'iprntcmd -d ipp://x.x.x.x/ipp/"Lab 212 Laser Printer"',@SW_HIDE);MsgBox(64,"","printer 1.13",8)
			if $Data[14] = $yes Then MsgBox(64,"","printer 1.14",8)
			if $Data[15] = $yes Then MsgBox(64,"","printer 1.15",8)
			if $Data[16] = $yes Then MsgBox(64,"","printer 1.16",8) 
			if $Data[17] = $yes Then MsgBox(64,"","printer 1.17",8)
			if $Data[18] = $yes Then MsgBox(64,"","printer 1.18",8)
			if $Data[19] = $yes Then MsgBox(64,"","printer 1.19",8)
			if $Data[20] = $yes Then MsgBox(64,"","printer 1.20",8)
			if $Data[21] = $yes Then MsgBox(64,"","printer 1.21",8)
			if $Data[22] = $yes Then MsgBox(64,"","printer 1.22",8)
			if $Data[23] = $yes Then MsgBox(64,"","printer 1.23",8)
			if $Data[24] = $yes Then MsgBox(64,"","printer 1.24",8)
			if $Data[25] = $yes Then RunWait(@ComSpec & " /c " & 'iprntcmd -d ipp://x.x.x.x/ipp/"Spare HP Laser Printer"',@SW_HIDE);MsgBox(64,"","printer 1.25",8)
			MsgBox(64,"","UNinstalling Printers",8)
			Exit

		EndSwitch
	WEnd
	GUIDelete()
EndFunc
Exit



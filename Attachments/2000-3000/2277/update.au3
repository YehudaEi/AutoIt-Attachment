#include <GUIConstants.au3>
#include <File.au3>
Opt("MustDeclareVars",1)

Local	$InstalledVersion	= RegRead("HKLM\Software\AutoIt v3\AutoIt","betaVersion")
Local	$szBetaDirListing	= @TempDir & "\BetaDirListing.html"
Local	$HTTPDir			= "http://www.autoitscript.com/autoit3/files/beta/autoit/"
Local	$LatestBeta			= ""
Local	$s,$szBeta,$win
Dim		$FileArray[1]

If $InstalledVersion	= "" Then
	$InstalledVersion	= "0.0.0.0"
Else
	if StringLeft($InstalledVersion,1) = "v" Then
		$InstalledVersion	= StringRight($InstalledVersion,StringLen($InstalledVersion)-1)
	EndIf
EndIf

If Not InetGet($HTTPDir,$szBetaDirListing,1) Then
	MsgBox(0,"","Failed to connect to autoitscript.com")
	Exit
EndIf

_FileReadToArray($szBetaDirListing,$FileArray)
FileDelete($szBetaDirListing)
For $i = 1 To $FileArray[0]
	If StringinStr($FileArray[$i],"beta-Setup.exe") Then
		$s	= StringTrimLeft($FileArray[$i],StringInStr($FileArray[$i],"-")+1)
		$s	= StringLeft($s,StringInStr($s,'-')-1)
		if Not _CompareVersions($LatestBeta,$s) Then $LatestBeta = $s
	EndIf
Next

_CompareVersions($InstalledVersion,$LatestBeta)
If Not @Error Then
	If _CompareVersions($LatestBeta,$InstalledVersion) Then ; DL the newer version
		$szBeta	= "autoit-v" & $LatestBeta & "-beta-Setup.exe"
		If Not InetGet($HTTPDir & $szBeta, @TEMPDir & "\" & $szBeta,1) Then
			;MsgBox(0,"Error","Failed to download latest version")
			Exit
		Else
			;MsgBox(0,"","Downloaded: " & $HTTPDir & $szBeta)
			Run(@TempDir & "\" & $szBeta,@TempDir)
			If @Compiled Then
				$win	= "AutoIt v" & $LatestBeta & " (beta) Setup"
				WinWait($win)
				ControlSend($win,"","Button1","{SPACE}")
				WinWait($win,"&Next")
				ControlSend($win,"","Button2","{SPACE}")
				WinWait($win,"I &Agree")
				ControlSend($win,"","Button2","{SPACE}")
				WinWait($win,"&Install")
				ControlSend($win,"","Button2","{SPACE}")
				WinWait($win,"&Finish")
				ControlSend($win,"","Button2","{SPACE}")
			EndIf
			Exit
		EndIf
	Else
		;MsgBox(0,"","Installed Version is newer then Latest Version, you rule")
		Exit
	EndIf
Else
	;MsgBox(0,"No New Version","You have the latest version")
	exit
EndIf

Func _CompareVersions($s_Vers1, $s_Vers2, $i_ReturnFlag = 0)
	Local $i, $i_Vers1, $i_Vers2, $i_Top,$v_Return
	Local $a_Vers1 = StringSplit($s_Vers1, '.')
	Local $a_Vers2 = StringSplit($s_Vers2, '.')

	$i_Top = $a_Vers1[0]
	If $a_Vers1[0] < $a_Vers2[0] Then
		$i_Top = $a_Vers2[0]
	EndIf
	
	For $i = 1 To $i_Top
		$i_Vers1 = 0
		$i_Vers2 = 0
		If $i <= $a_Vers1[0] Then
			$i_Vers1 = Number($a_Vers1[$i])
		EndIf
		If $i <= $a_Vers2[0] Then
			$i_Vers2 = Number($a_Vers2[$i])
		EndIf
		
		If $i_Vers1 > $i_Vers2 Then
			$v_Return = 1
			ExitLoop
		ElseIf $i_Vers1 < $i_Vers2 Then
			$v_Return = 0
			ExitLoop
		Else
			$v_Return = -1
		EndIf
	Next

	If $i_ReturnFlag Then
		Select
			Case $v_Return = -1
				SetError(1)
				Return 0
			Case $v_Return = 1
				Return $s_Vers1
			Case $v_Return = 0
				Return $s_Vers2
		EndSelect
	ElseIf $v_Return = -1 Then
		SetError(1)
		Return 0
	Else
		Return $v_Return
	EndIf
EndFunc



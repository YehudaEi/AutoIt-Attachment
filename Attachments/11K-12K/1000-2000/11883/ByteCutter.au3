#include <GUIConstants.au3>
Opt("GUIOnEventMode", 1)
Dim $filn, $fils, $filloc, $res
$F1 = GUICreate("ByteCutter", 483, 118, (@DesktopWidth -483)/2, (@DesktopHeight -118)/2)
$e01 = GUICtrlCreateInput("", 54, 18, 350, 21, $ES_READONLY, BitOR($WS_EX_CLIENTEDGE,$WS_EX_ACCEPTFILES) )
GUICtrlSetBkColor($e01,0xFFFFFF)
GUICtrlCreateLabel("File:", 9, 21, 23, 17)
$b01 = GUICtrlCreateButton("Browse", 415, 19, 59, 20)
$e02 = GUICtrlCreateInput("", 53, 49, 350, 21, $ES_READONLY, $WS_EX_CLIENTEDGE)
GUICtrlSetBkColor($e02,0xFFFFFF)
$b02 = GUICtrlCreateButton("Browse", 415, 49, 59, 20)
GUICtrlCreateLabel("Output:", 7, 51, 39, 17)
$pb01 = GUICtrlCreateProgress(7, 75,460,5,$PBS_SMOOTH)
GUICtrlCreateLabel("No. of Parts:", 110, 90, 63, 17)
$e03 = GUICtrlCreateInput("", 175, 87, 70, 20, $ES_NUMBER, $WS_EX_CLIENTEDGE)
$ud = GUICtrlCreateUpdown($e03)
$b03 = GUICtrlCreateButton("Cut Now", 17, 86, 85, 25)
GUICtrlCreateLabel("Approx Size:", 260, 90, 73, 17)
$e04 = GUICtrlCreateInput("", 325, 87, 100, 20, $ES_READONLY, $WS_EX_CLIENTEDGE)
GUICtrlSetBkColor($e04,0xF2FFFC)
$l01=GUICtrlCreateLabel("", 430, 90, 30, 17)
GUISetOnEvent($GUI_EVENT_CLOSE, "CornerX")
GUICtrlSetOnEvent($b01,'loc')
GUICtrlSetOnEvent($b02,'loc')
GUICtrlSetOnEvent($b03,'cutnow')
GUISetState()
While 1
	Sleep(500)
	If GUICtrlRead($e03)*1 < 2 Then GUICtrlSetData($e03,2)
	If GUICtrlRead($e01) <> ''  Then 
		$fils = Int(FileGetSize (GUICtrlRead($e01))/StringRegExpReplace(GUICtrlRead($e03),'\D',''))
		If $fils >= 1024 And $fils <= 1048576 Then
			GUICtrlSetData($e04,Round($fils/1024,2))
			GUICtrlSetData($l01,'KB')
			$res = 5
		ElseIf $fils > 1048576 Then
			GUICtrlSetData($e04,Round($fils/1048576,2))
			GUICtrlSetData($l01,'MB')
			$res = 50
		Else
			GUICtrlSetData($e04,$fils)
			GUICtrlSetData($l01,'Bytes')
			$res = 2
		EndIf
	EndIf
WEnd
Func CornerX()
	Exit
EndFunc
Func cutnow()
	GUICtrlSetState($e03, $GUI_DISABLE)
	GUICtrlSetState($b01, $GUI_DISABLE)
	GUICtrlSetState($b02, $GUI_DISABLE)
	Dim $count=1,$partsn,$parts,$a2,$tmp,$filnlenxext
	If GUICtrlRead($e01) = '' Then
		MsgBox(0,'File Name','Please choose the file to split',2)
		ena()
		Return
	ElseIf GUICtrlRead($e02) = '' Then 
		MsgBox(0,'Output Folder','Please choose the folder for output parts',2)
		ena()
		Return
	EndIf	
	$opfil = FileOpen($filn,0)
	$partsf = StringTrimLeft(GUICtrlRead($e01),StringInStr(GUICtrlRead($e01),'\',0,-1))
	If StringInStr($partsf,'.') Then 
		$partsn = StringLeft(StringMid($partsf,1,StringInStr($partsf,'.')-1),2)
	Else
		$partsn = StringLeft($partsf,2)
	EndIf
	If StringLen($partsn) = 1 Then $partsn &= 'A'
	$existfil = FileFindFirstFile($filloc & $partsn & '*')
	$tmp = 0
	While 1 
		$filnlen = FileFindNextFile($existfil)
		If @error Then ExitLoop
		$filnlenxext = StringInStr($filnlen,'.')-1
		If  $filnlenxext > $tmp Then $tmp = $filnlenxext
	WEnd
	FileClose($existfil)	
	If $tmp > 1 Then
		For $a = 1 To $tmp-1
			$partsn &= $a
		Next	
	EndIf				
	$parts = $partsn & '.' & $count
	While 1
		$a2 += 1
		$sfil = FileRead($opfil,$a2)
		If @error Then ExitLoop
		FileWrite($filloc & $parts,$sfil)	
		If Mod($a2,$res)=0 Then
			If FileGetSize ($filloc & $parts) > $fils Then 
				$count += 1 
				GUICtrlSetData($pb01,$count/GUICtrlRead($e03)*100)
				$parts = $partsn & '.' & $count
			EndIf
		EndIf	
	WEnd
	FileClose($opfil)
	For $a = 1 To $count
		If $a = 1 Then 
			$grpparts = $partsn & '.' & $a
		Else
			$grpparts = $grpparts & '+' & $partsn & '.' & $a
		EndIf
	Next
	FileWriteLine($filloc & $partsn & '.bat','rem : This file is generated by ByteCutter for rejoining file parts')
	FileWriteLine($filloc & $partsn & '.bat','@if not exist "'& $partsf &'" goto joinall')
	FileWriteLine($filloc & $partsn & '.bat','cls')
	FileWriteLine($filloc & $partsn & '.bat','@echo -----===              File Already Exist              ===-----')
	FileWriteLine($filloc & $partsn & '.bat','@echo -----=== rejoining will cause current to be overwrote ===-----')
	FileWriteLine($filloc & $partsn & '.bat','@echo -----===             program will now exit            ===-----')
	FileWriteLine($filloc & $partsn & '.bat','@pause')
	FileWriteLine($filloc & $partsn & '.bat','@goto lastline')
	FileWriteLine($filloc & $partsn & '.bat',':joinall')
	FileWriteLine($filloc & $partsn & '.bat','Copy /b ' & $grpparts & ' '& $partsf )
	For $a = 1 To $count
		FileWriteLine($filloc & $partsn & '.bat','del '& $partsn & '.' & $a )
	Next	
	FileWriteLine($filloc & $partsn & '.bat','del '& $partsn & '.bat' )
	FileWriteLine($filloc & $partsn & '.bat',':lastline')
	ena()
EndFunc
Func ena()
	GUICtrlSetState($e03, $GUI_ENABLE)
	GUICtrlSetState($b01, $GUI_ENABLE)
	GUICtrlSetState($b02, $GUI_ENABLE)
EndFunc
Func Loc()
	If @GUI_CtrlId = $b01 Then 
		$filn = FileOpenDialog("File to cut", "C:\", "All Files (*.*)", 1 )
		GUICtrlSetData( $e01, $filn)  
	ElseIf @GUI_CtrlId = $b02 Then 
		$filloc = FileSelectFolder("Output folder", "", 7, @MyDocumentsDir)&'\'
		GUICtrlSetData( $e02, $filloc )  
	EndIf	
EndFunc
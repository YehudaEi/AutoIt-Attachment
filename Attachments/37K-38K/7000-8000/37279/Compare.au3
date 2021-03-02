#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <misc.au3>
#include <file.au3>
#NoTrayIcon

;=================================
Global $aArray1 = 0
Global $aArray2 = 0
Global $hDiff = -1
;=================================
_Singleton(@ScriptName, 0)

$VTC = ""
		If $VTC = "" Then _VTC_GUI()
	
Func _VTC_GUI()
	$VTC_Production_Input=0
	$VTC_Integration_Input=0
	GuiCreate("  Compare - ",520,128,-1,-1,$WS_BORDER,$WS_EX_ACCEPTFILES)
	$VTC_Production_Label=GUICtrlCreateLabel("  Files - PRODUCTION ", 15, 12)
	$VTC_Production_Input=GUICtrlCreateInput("", 180, 10, 210, 20)
	GUICtrlSetData ($VTC_Production_Input, $VTC)
	
	GUICTRLSetState ( $VTC_Production_Input, $GUI_DROPACCEPTED)
	$VTC_Production_Browse_Button=GUICtrlCreateButton("Browse",400,8)
	$VTC_Integration_Label=GUICtrlCreateLabel( "  Files - INTEGRATION ", 15, 42)   
	$VTC_Integration_Input=GUICtrlCreateInput("", 180, 40, 210, 20)
	$VTC_Integration_Browse_Button=GUICtrlCreateButton("Browse",400,38)
	GUICTRLSetState ( $VTC_Integration_Input, $GUI_DROPACCEPTED)
	$Comparefiles=GuiCtrlCreateButton("Compare  Files",110,69)
	$ConfigurationExitWithoutSaving=GuiCtrlCreateButton("Exit Without Comparing",260,69)
	GUISetState()
	
	While 1
		$msg=GuiGetMsg()
		
		If $msg=$VTC_Production_Browse_Button Then	
			$VTC_Production_Browse_ButtonInput = FileOpenDialog("Select Production  File","", "All (*.Rep;*.Txt)")
			GUICtrlSetData($VTC_Production_Input, $VTC_Production_Browse_ButtonInput, "0")
		EndIf
		If $msg=$VTC_Integration_Browse_Button Then
			$VTC_Integration_Browse_ButtonInput = FileOpenDialog ("Select Integration  File","", "All (*.Rep;*.Txt)")
			GUICtrlSetData($VTC_Integration_Input, $VTC_Integration_Browse_ButtonInput, "0")
		EndIf
		If $msg=$Comparefiles Then
			;==================================================================================================================================				
			$Production_VTC_Read = GUICTRLRead($VTC_Production_Input)
			$Integration_VTC_Read = GUICTRLRead($VTC_Integration_Input)
							
			_FileReadToArray($Production_VTC_Read,$aArray1)
			_FileReadToArray($Integration_VTC_Read,$aArray2)
			$hDiff = Fileopen("C:\Temp\Differences.txt",10)
			For $i = 1 To UBound($aArray1) - 1
				$sID1 = StringLeft($aArray1[$i],StringInStr($aArray1[$i],"ý",1,1)-1)
				For $j = 1 To UBound($aArray2) - 1
					$sID2 = StringLeft($aArray2[$j],StringInStr($aArray2[$j],"ý",1,1)-1)
					if  $sID1 == $sID2 Then ;Check if the first part is the same
						;then check if anything else on the lines is different
						if $aArray1[$i] <> $aArray2[$j] Then
							fileWriteLine($hDiff, " File Production  Line #"  & $i & ": " & $aArray1[$i] & @CRLF &  " File Integration Line #"  & $j & ": " & $aArray2[$j] & @CRLF & @CRLF)
						endif
					EndIf
					;$msg=GuiGetMsg()
						
				Next
			Next
			FileClose($hDiff)
			
			;==================================================================================================================================				
		EndIf
		
						If $msg=$ConfigurationExitWithoutSaving Then
						$ExitDialog = MsgBox(36, "Are You Sure?", "Are you sure you want to exit?")
						If $ExitDialog = 6 then Exit
						EndIf
	Wend
	EndFunc

Exit



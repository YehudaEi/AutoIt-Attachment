;Includes
#include <Process.au3>
#Include <Array.au3>


;===============================================================================
;
; Function Name:   	_ProcessGetWinTitle ()
; Description:		Gets all windowss associated with a process in a unidimensional array
; Parameter(s):    	$sProcessName - Name of the process ("Explorer.exe", for instance)
;					$iVisibility - Parameter used to check for visible/invisible windowss
;					0 - Check only visible windowss
;					1 - Check for every Window asociated to the specified process
; Requirement(s):	<Process.au3> and <Array.au3> are required
; Return Value(s):	Success : The array containing the windows name
;					Failure : 0
; Author(s): 		Iuli
;===============================================================================
Func _ProcessGetWinTitle($sProcessName,$iVisibility)
	Local $iK, $WinArray[1]
	$aWinList=WinList ()
	For $iK=1 To $aWinList[0][0]
		If $iVisibility=0 Then
			If (_ProcessGetName(WinGetProcess($aWinList[$iK][0]))=$sProcessName) And (_IsVisible($aWinList[$iK][0])) Then
				_ArrayAdd($WinArray,$aWinList[$iK][0])
			EndIf
		ElseIf $iVisibility=1 Then	
			If _ProcessGetName(WinGetProcess($aWinList[$iK][0]))=$sProcessName Then
				_ArrayAdd($WinArray,$aWinList[$iK][0])
			EndIf
		EndIf	
	Next
	Return $WinArray
EndFunc

; ========================================================================================================
; Internal Functions from this point on
; ========================================================================================================
Func _IsVisible($handle)
  If BitAnd( WinGetState($handle), 2 ) Then 
    Return 1
  Else
    Return 0
  EndIf
EndFunc
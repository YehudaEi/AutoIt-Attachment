
#include<Array.au3>
#include<File.au3>
#include <Toast.au3>



Local $sMsg, $hProgress, $aRet[2]
	
	$Role = "CONSULTANT"
	$sMsg  = "APPLYING THE FOLLOWING JOB ROLE : " & $Role
	$sMsg &= ""
	$sMsg &= "" & @CRLF & @CRLF & @CRLF & @CRLF
	$sMsg &= ""
	$sMsg &= ""
	$sMsg &= "" & @CRLF & @CRLF
	$sMsg &= ""



	Global $aApps[4][4] = [["App 1", 0],["App 2", 0]]
	
	;Some Variables to work make sure the progress bars are always centered in the left and right side of the toast window
	; I will have a single overall progress bar in the left hand section of the toats and many progress bars in the right hand side of the toast
	$ToastHalfMarker = $aRet[0] / 2
	$Progress1CenterStartingPos = $ToastHalfMarker / 4
	$ProgressBarLength = $ToastHalfMarker / 2
	$IndividualFrameSizes = $aRet / 8
	$ProgressBarStartPointFromHalfMarker = $ToastHalfMarker + $Progress1CenterStartingPos
	$LeftHandProgressBarStartingHeight = 40
	$RightHandProgressBarStartingHeight = 40
	$Progress2CenterStartingPos = $ToastHalfMarker + 50
	
	$Counter = 0
	Dim $HeightCounter = $RightHandProgressBarStartingHeight ; This will simply work out where the next progress bar should start
	
	;This loop will add in the starting height of each progress bar
	Do
		$aApps[$Counter][1] = $HeightCounter + 20
		$Counter = $Counter + 1
		$HeightCounter = $HeightCounter + 20
		
	Until $Counter = Ubound( $aApps)

	$HeightOfGui = Ubound($aApps) * 10 + 20 ;This resizes the Toast Gui depending on the number of the apps / progress bars
	
	
	
	;This is the loop that is just creating 0`sinstead of the ID`s.
	$Counter = 0
	Do 
		
		$aApps[$Counter][2] = GUICtrlCreateProgress($ProgressBarStartPointFromHalfMarker, $aApps[$Counter][1], $ProgressBarLength, 5)
		$Counter = $Counter + 1
		
	Until $Counter = Ubound($aApps)
	
	_ArrayDisplay($aApps)
	

	_Toast_Set(Default)
	$aRet = _Toast_Show(0, "New Machine Job Role Configuration", $sMsg, 0) ; No delay or progress bar will not display immediately
	ConsoleWrite("Toast size: " & $aRet[0] & " x " & $aRet[1] & @CRLF)
	
	;For $i = 1 To 100
	;	GUICtrlSetData($aProgress, $i)
	;	GUICtrlSetData($bProgress, $i)
	;
	;	Sleep(50)
	;Next
	Sleep(10000)
	_Toast_Hide()
	Exit
	

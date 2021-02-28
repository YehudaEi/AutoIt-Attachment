#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         ccrumrine

 Script Function:
	Prompt 

#ce ----------------------------------------------------------------------------

AutoItSetOption("MustDeclareVars", 1)
AutoItSetOption("TrayIconDebug", 0)
AutoItSetOption("TrayIconHide", 1)
AutoItSetOption("GUICloseOnESC", 0)

#include <GUIConstants.au3>
#include <Constants.au3>
#include <AD.au3>
#include <Date.au3>

Dim $buttonCancel
Dim $buttonOk
Dim $msg
Dim $objPassField
Dim $objPassField2
Dim $strPassField
Dim $strPassField2
Dim $UserName
Dim $objUserName
Dim $objADopen
Dim $ADPassExpire
Dim $strDateDiff
Dim $strExpireWarn
Dim $strExpireForce
Dim $strForcedInDays
Dim $SetPassError
Dim $strHelpDeskNumber


; Set the Warning and Force password change here in Days
$strExpireWarn = 70 ; Sane value should be like 15 Just set for testing.
$strExpireForce = 5
$strHelpDeskNumber = "123.123.1234"


$msg = 0
$objADopen = _AD_Open()
$ADPassExpire = _AD_GetPasswordInfo()
$strDateDiff = _DateDiff( 'D', _NowCalc(), $ADPassExpire[9] )
$strForcedInDays = $strDateDiff - $strExpireForce

If $strDateDiff <= $strExpireWarn Then
	GUICreate( "Change Password for:   " & @UserName , 320,160, @DesktopWidth/2-160, @DesktopHeight/2-45, -1 )
	GUICtrlCreateLabel( "Your password will expire on:   " & _DateTimeFormat( $ADPassExpire[9], 2), 25, 10, 220, 50 )
	GUICtrlCreateLabel( "New Password:", 10, 60 )
	$objPassField = GUICtrlCreateInput( $strPassField, 90,  55, 220, 20, 0x0020 )
	GUICtrlCreateLabel( "New Password:", 10, 90 )
	$objPassField2 = GUICtrlCreateInput( $strPassField2, 90,  85, 220, 20, 0x0020 )

	$buttonOk = GUICtrlCreateButton( "Ok", 80,  120, 60, 20 )
	If $strDateDiff >= $strExpireForce Then
		$buttonCancel = GUICtrlCreateButton( "Cancel", 180, 120, 60, 20 )
	Else
		$buttonCancel = 1
	Endif

	GUISetState() 

	While $msg <> $GUI_EVENT_CLOSE
	
		$msg = GUIGetMsg()
		$strPassField = GUICtrlRead( $objPassField)
		$strPassField2 = GUICtrlRead( $objPassField2)
		$SetPassError = 0
		
		Select
			Case $buttonCancel = $msg
				MsgBox( 48, @LogonDomain & " Application Services", "Please Change your password soon" & @CR & _ 
					"You will be forced to change it in " & $strForcedInDays & " days" )
				ExitLoop
			Case $buttonOk = $msg
			
				Select
					Case $strPassField == $strPassField2
						SplashTextOn( @LogonDomain & " Application Services", "Now Updating your password... " & @CR & "Please wait.", 300, 80 )
						Sleep( 5000 )
						$SetPassError = _AD_SetPassword( @LogonDomain & "\" & @UserName, $strPassField, 0)
						SplashOff()
					Case Else						
						$SetPassError = -123456123
				EndSelect
				
				If $SetPassError = 0 Then
					MsgBox( 0, @LogonDomain & " Application Services", "Password reset Sucess.")
					Exit
				ElseIf $SetPassError = -123456123 Then
					MsgBox( 0, @LogonDomain & " Application Services", "Passwords Do not Match" & @CR & @TAB & "Please try again")
				Else
					MsgBox( 0, @LogonDomain & " Application Services", "Please contact the help desk at " & $strHelpDeskNumber & @CR & @TAB & "error code:  " & $SetPassError )
				EndIf
		EndSelect
	Wend
EndIf





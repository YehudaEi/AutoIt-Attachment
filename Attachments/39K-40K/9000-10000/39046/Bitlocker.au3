#include-once
Global $Title = "Bitlocker UDF"
Global $g_eventerror = 0, $oMyError
Global $Result[6]
Global $Error[6]
Global $VolumeKeyProtectorFriendlyName
Global $EncryptionMethod
Global $ProtectionStatus
Global $ConversionStatus
Global $EncryptionPercentage ;Percentage of the volume that is encrypted
Global $VolumeKeyProtectorID
Global $LockStatus
Global $objError = "Unable to open object"

Func BitLock($Strcomputer)
	$objWMIService = ObjGet("winmgmts:\\" & $Strcomputer & "\root\CIMV2\Security\MicrosoftVolumeEncryption")
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_EncryptableVolume", "WQL", 48)
	$oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")
	If IsObj($colItems) Then
		For $objItem In $colItems




			$objItem.GetEncryptionMethod($EncryptionMethod)
			If $EncryptionMethod <> "" Then
				If $EncryptionMethod = 0 Then
					$Result[0] = "The volume is not encrypted"
				ElseIf $EncryptionMethod = 1 Then
					$Result[0] = "AES 128 WITH DIFFUSER" ;The volume has been fully or partially encrypted with the Advanced Encryption Standard (AES) algorithm enhanced with a diffuser layer, using an AES key size of 128 bits.
				ElseIf $EncryptionMethod = 2 Then
					$Result[0] = "AES 256 With Diffuser" ; The volume has been fully or partially encrypted with the Advanced Encryption Standard (AES) algorithm enhanced with a diffuser layer, using an AES key size of 256 bits
				ElseIf $EncryptionMethod = 3 Then
					$Result[0] = "AES 128" ;The volume has been fully or partially encrypted with the Advanced Encryption Standard (AES) algorithm, using an AES key size of 128 bits.
				ElseIf $EncryptionMethod = 4 Then
					$Result[0] = "AES 256" ;The volume has been fully or partially encrypted with the Advanced Encryption Standard (AES) algorithm, using an AES key size of 256 bits.
				EndIf
			Else
				$Error[0] = "UNKNOWN" ;The volume has been fully or partially encrypted with an unknown algorithm and key size.
			EndIf


			$objItem.GetProtectionStatus($ProtectionStatus)
			If $ProtectionStatus <> "" Then
				If $ProtectionStatus = 0 Then
					$Result[1] = "PROTECTION OFF"
				ElseIf $ProtectionStatus = 1 Then
					$Result[1] = "PROTECTION ON"
				EndIf

			Else
				$Error[1] = "PROTECTION UNKNOWN"
			EndIf

			$objItem.GetConversionStatus($ConversionStatus, $EncryptionPercentage)
			If $ConversionStatus <> "" Then
				If $ConversionStatus = 0 Then
					$Result[2] = "FULLY DECRYPTED" ;The volume is fully decrypted.
				ElseIf $ConversionStatus = 1 Then
					$Result[2] = "FULLY ENCRYPTED" ;The volume is fully encrypted.
				ElseIf $ConversionStatus = 2 Then
					$Result[2] = "ENCRYPTION IN PROGRESS"
				ElseIf $ConversionStatus = 3 Then
					$Result[2] = "DECRYPTION IN PROGRESS"
				ElseIf $ConversionStatus = 4 Then
					$Result[2] = "ENCRYPTION PAUSED"
				ElseIf $ConversionStatus = 5 Then
					$Result[2] = "DECRYPTION PAUSED"
				EndIf
			Else
				$Error[2] = "Error on retriving method GetConversionStatus - Error Value = " & @error
			EndIf

			$objItem.GetKeyProtectors(0, $VolumeKeyProtectorID)

			If $EncryptionPercentage <> "" Then
				$Result[3] = $EncryptionPercentage & "%"
			Else
				$Error[3] = "Error on retriving method GetKeyProtectors - Error Value = " & @error
			EndIf

			$objItem.GetLockStatus($LockStatus)
			If $LockStatus = 1 Then
				$Result[4] = "Locked"
			ElseIf $LockStatus = 0 Then
				$Result[4] = "Unlocked"
			Else

				$Error[4] = "Error on retriving method GetLockStatus - Error Value = " & @error
			EndIf



			For $objId In $VolumeKeyProtectorID


				$objItem.GetKeyProtectorFriendlyName($objId, $VolumeKeyProtectorFriendlyName)

				If $VolumeKeyProtectorFriendlyName <> "" Then

					; MsgBox(0,"", "KeyProtectors: " & $VolumeKeyProtectorFriendlyName)
					$Result[5] = $VolumeKeyProtectorFriendlyName
				Else

					$Error[5] = "Error on retriving method GetKeyProtectorFriendlyName - Error Value = " & @error
				EndIf

			Next

		Next
		If $g_eventerror Then
			$g_eventerror = 0
			MsgBox(16, "BitLocer Status - Error", "Error occured: " & @error)
		Else
			Return $Result
		EndIf
	Else
		Return $objError
	EndIf
EndFunc   ;==>BitLock


; This is my custom defined error handler
Func MyErrFunc()

	MsgBox(16, $Title & " - Error", "There is an interuption while retriving the data by using WMI query!" & @CRLF & @CRLF & _
			"err.description is: " & @TAB & $oMyError.description & @CRLF & _
			"err.windescription:" & @TAB & $oMyError.windescription & @CRLF & _
			"err.number is: " & @TAB & Hex($oMyError.number, 8) & @CRLF & _
			"err.lastdllerror is: " & @TAB & $oMyError.lastdllerror & @CRLF & _
			"err.scriptline is: " & @TAB & $oMyError.scriptline & @CRLF & _
			"err.source is: " & @TAB & $oMyError.source & @CRLF & _
			"err.helpfile is: " & @TAB & $oMyError.helpfile & @CRLF & _
			"err.helpcontext is: " & @TAB & $oMyError.helpcontext _
			)

	Local $err = $oMyError.number
	If $err = 0 Then $err = -1

	$g_eventerror = $err ; to check for after this function returns
EndFunc   ;==>MyErrFunc

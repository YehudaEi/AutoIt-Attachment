#include-once


#include ".\_Registry.au3"


Global $___JRE7_DEPLOYMENT_PROPERTIES_UDS = 0 ; User-definied settings.
Global $___JRE7_SECURITY_BASELINE_VERSION = 0


; X86 (0x1)/X64 (0x2), delete (0)/write (1), HKEY, value, type, data.
Local Const $___JRE7_SECURITY_MSIE_DISABLE[9][7] = [ _
		[1, 0, "SOFTWARE\Microsoft\Internet Explorer\Extensions\{08B0E5C0-4FCB-11CF-AAA5-00401C608501}", "", "", ""], _
		[3, 0, "SOFTWARE\Microsoft\Internet Explorer\Low Rights\ElevationPolicy\{44D1B085-E495-4b5f-9EE6-34795C46E7E7}", "", "", ""], _
		[3, 1, "SOFTWARE\Microsoft\Internet Explorer\Low Rights\ElevationPolicy\{5852F5ED-8BF4-11D4-A245-0080C6F74284}", "", "", ""], _
		[3, 1, "", "AppName", "REG_SZ", ""], _
		[3, 1, "", "AppPath", "REG_SZ", ""], _
		[1, 1, "", "Policy", "REG_DWORD", 0x01084d44], _
		[2, 1, "", "Policy", "REG_DWORD", 0x13], _
		[3, 0, "SOFTWARE\Microsoft\Internet Explorer\Low Rights\ElevationPolicy\{C8FE2181-CAE7-49EE-9B04-DB7EB4DA544A}", "", "", ""], _
		[3, 1, "SOFTWARE\Oracle\JavaDeploy", "WebDeployJava", "REG_SZ", "disabled"]]
Local Const $___JRE7_SECURITY_MSIE_ENABLE[18][7] = [ _
		[1, 1, "SOFTWARE\Microsoft\Internet Explorer\Extensions\{08B0E5C0-4FCB-11CF-AAA5-00401C608501}", "", "", ""], _
		[1, 1, "", "MenuText", "REG_SZ", "jp2launcher.exe"], _
		[1, 1, "", "CLSID", "REG_SZ", "@INSTALLLOCATION@bin"], _
		[1, 1, "", "ClsidExtension", "REG_SZ", "{CAFEEFAC-001011-0002-0011-ABCDEFFEDCBC}"], _
		[3, 1, "SOFTWARE\Microsoft\Internet Explorer\Low Rights\ElevationPolicy\{44D1B085-E495-4b5f-9EE6-34795C46E7E7}", "", "", ""], _
		[3, 1, "", "AppName", "REG_SZ", "Sun Java Konsole"], _
		[3, 1, "", "AppPath", "REG_SZ", "{1FBA04EE-3024-11d2-8F1F-0000F87ABD16}"], _
		[3, 1, "", "Policy", "REG_DWORD", 0x3], _
		[3, 1, "SOFTWARE\Microsoft\Internet Explorer\Low Rights\ElevationPolicy\{5852F5ED-8BF4-11D4-A245-0080C6F74284}", "", "", ""], _
		[3, 1, "", "AppName", "REG_SZ", "javaws.exe"], _
		[1, 1, "", "AppPath", "REG_SZ", "@INSTALLLOCATION@bin"], _
		[2, 1, "", "AppPath", "REG_SZ", @WindowsDir & "\SYSTEM32"], _
		[3, 1, "", "Policy", "REG_DWORD", 0x3], _
		[3, 1, "SOFTWARE\Microsoft\Internet Explorer\Low Rights\ElevationPolicy\{C8FE2181-CAE7-49EE-9B04-DB7EB4DA544A}", "", "", ""], _
		[3, 1, "", "AppName", "REG_SZ", "ssvagent.exe"], _
		[3, 1, "", "AppPath", "REG_SZ", "@INSTALLLOCATION@bin"], _
		[3, 1, "", "Policy", "REG_DWORD", 0x3], _
		[3, 0, "SOFTWARE\Oracle\JavaDeploy", "WebDeployJava", "", ""]]


; Example (DISABLE [current user only]).
;~ Local $iJRE7_MSIEEnable = _JRE7_MSIEEnable(False)
;~ ConsoleWrite("_JRE7_MSIEEnable() -> [" & $iJRE7_MSIEEnable & "][" & @error & "][" & @extended & "]" & @CRLF)
;~ Local Const $aJRE7_DeploymentPropertiesUDS[2][2] = [ _ ; [http://www.h-online.com/security/news/item/Java-certificate-checks-botched-1817879.html], [http://www.heise.de/security/meldung/Java-pfuscht-bei-Zertifikatschecks-1817775.html].
;~ 		["deployment.security.validation.crl=", ""], _
;~ 		["deployment.security.validation.ocsp=", ""]]
;~ $___JRE7_DEPLOYMENT_PROPERTIES_UDS = $aJRE7_DeploymentPropertiesUDS
;~ Local $iJRE7_SecurityLevel = _JRE7_SecurityLevel()
;~ ConsoleWrite("_JRE7_SecurityLevel() -> [" & $iJRE7_SecurityLevel & "][" & @error & "][" & @extended & "]" & @CRLF)


; Example (ENABLE [current user only]).
;~ Local $iJRE7_MSIEEnable = _JRE7_MSIEEnable()
;~ ConsoleWrite("_JRE7_MSIEEnable() -> [" & $iJRE7_MSIEEnable & "][" & @error & "][" & @extended & "]" & @CRLF)
;~ Local Const $aJRE7_DeploymentPropertiesUDS[2][2] = [ _ ; [http://www.h-online.com/security/news/item/Java-certificate-checks-botched-1817879.html], [http://www.heise.de/security/meldung/Java-pfuscht-bei-Zertifikatschecks-1817775.html].
;~ 		["deployment.security.validation.crl=", "true"], _
;~ 		["deployment.security.validation.ocsp=", "true"]]
;~ $___JRE7_DEPLOYMENT_PROPERTIES_UDS = $aJRE7_DeploymentPropertiesUDS
;~ Local $iJRE7_SecurityLevel = _JRE7_SecurityLevel()
;~ ConsoleWrite("_JRE7_SecurityLevel() -> [" & $iJRE7_SecurityLevel & "][" & @error & "][" & @extended & "]" & @CRLF)


; #FUNCTION# =========================================================================================
; Function Name:	_JRE7_MSIEEnable()
; Description:		Disables/enables JRE7 (U10+) browser content -
;					user-definied settings will not be considered during runtime
;					[http://docs.oracle.com/javase/7/docs/technotes/guides/deployment/deployment-guide/properties.html],
;					[http://www.autoitscript.com/forum/topic/149260-control-java-runtime-environment-7-jre7-security-settings/],
;					[http://www.h-online.com/security/news/item/Java-7-Update-21-closes-security-holes-and-restricts-applets-1843558.html],
;					[http://www.heise.de/security/meldung/Java-7-Update-21-stopft-Sicherheitsluecken-und-beschraenkt-Applets-1843271.html],
;					[http://www.java.com/de/download/faq/signed_code.xml],
;					[http://www.java.com/en/download/faq/signed_code.xml].
; Syntax:			_JRE7_MSIEEnable([Const $bJRE7_DeploymentWebjavaEnabled = True [, Const $bJRE7_CurrentUserOnly = True]])
; Parameter(s):		$bJRE7_DeploymentWebjavaEnabled ("deployment.webjava.enabled"):
;					| False,
;					| True (default).
;					$bJRE7_CurrentUserOnly:
;					| False ('#RequireAdmin'),
;					| True (default).
; Requirement(s):	#include "___JRE7_ArrayInsert.au3"
;					#include "___JRE7_DeploymentProperties.au3"
;					#include "___JRE7_MSIEEnable.au3"
; Return Value(s):	On success - Returns 1, @error = 0, @extended = 0.
;					On failure - Returns 0, @extended = 0, @error:
;					|     0 - No error.
;					|     n - '___JRE7_MSIEEnable()' failure (@extended = n).
;					| 10000 - '___JRE7_DeploymentProperties()' failure.
;					| 11000 - 'FileOpen()' failure (#1, read).
;					| 12000 - 'FileClose()' failure (#1, read).
;					| 13000 - 'FileOpen()' failure (#2, write).
;					| 14000 - 'FileClose()' failure (#2, write).
;					| 15000 - '$iJRE7_FileReadFailure' failure.
; Author(s):		Supersonic!
; ====================================================================================================
Func _JRE7_MSIEEnable(Const $bJRE7_DeploymentWebjavaEnabled = True, Const $bJRE7_CurrentUserOnly = True)
	Local $iJRE7_Return = 0
	Switch $bJRE7_CurrentUserOnly
		Case False
			___JRE7_MSIEEnable($bJRE7_DeploymentWebjavaEnabled)
			If Not @error Then
				ContinueCase ; !!!
			Else ; Error.
				SetError(@error, @extended)
			EndIf
		Case True
			Local $sJRE7_File = ___JRE7_DeploymentProperties()
			If Not @error Then
				Local $hJRE7_File = FileOpen($sJRE7_File, 0)
				If $hJRE7_File <> -1 Then
					; [n][0] = value, [n][1] = data, [n][2] = mandatory, [n][3] = processed.
					Local $aJRE7_DeploymentProperties[1][4] = [["deployment.webjava.enabled=", "", 0, 0]]
					Local $aJRE7_File[1] = [0] ; [0] = "#deployment.properties" ("#Java Deployment jre's").
					Local $bJRE7_FileReadLine = False
					Local $iJRE7_FileReadLine = 0
					Local $sJRE7_FileReadLine = ""
					; ----------------------------------------------------------------------------------------------------
					If Not $bJRE7_DeploymentWebjavaEnabled Then
						$aJRE7_DeploymentProperties[0][1] = "false"
						$aJRE7_DeploymentProperties[0][2] = 1
					EndIf
					; ----------------------------------------------------------------------------------------------------
					While 1
						$bJRE7_FileReadLine = True
						$sJRE7_FileReadLine = FileReadLine($hJRE7_File)
						If Not @error Then ; Non-error (#1).
							For $i = 0 To UBound($aJRE7_DeploymentProperties, 1) - 1 Step 1
								If StringInStr($sJRE7_FileReadLine, $aJRE7_DeploymentProperties[$i][0]) > 0 Then
									If $aJRE7_DeploymentProperties[$i][1] <> "" Then
										$aJRE7_DeploymentProperties[$i][3] = 1 ; Checked/done.
										$sJRE7_FileReadLine = $aJRE7_DeploymentProperties[$i][0] & $aJRE7_DeploymentProperties[$i][1]
									Else ; Non-error.
										$bJRE7_FileReadLine = False
									EndIf
									ExitLoop (1)
								EndIf
							Next
							If $bJRE7_FileReadLine = True Then
								ReDim $aJRE7_File[UBound($aJRE7_File) + 1]
								$aJRE7_File[UBound($aJRE7_File) - 1] = $sJRE7_FileReadLine
								If StringInStr($sJRE7_FileReadLine, "#deployment.properties") > 0 Then ; If StringInStr($sJRE7_FileReadLine, "#Java Deployment jre's") > 0 Then
									$aJRE7_File[0] = $iJRE7_FileReadLine + 2 ; $aJRE7_File[0] = $iJRE7_FileReadLine
								EndIf
								$iJRE7_FileReadLine += 1
							EndIf
						ElseIf @error = -1 Then ; Non-error (#2).
							ExitLoop (1)
						Else ; Error.
							ExitLoop (1)
						EndIf
					WEnd
					; ----------------------------------------------------------------------------------------------------
					For $i = 0 To UBound($aJRE7_DeploymentProperties, 1) - 1 Step 1
						If $aJRE7_DeploymentProperties[$i][1] <> "" Then
							If $aJRE7_DeploymentProperties[$i][2] <> $aJRE7_DeploymentProperties[$i][3] Then
								$aJRE7_DeploymentProperties[$i][3] = 1 ; Checked/done.
								$aJRE7_File[0] += 1 ; !!!
								___JRE7_ArrayInsert($aJRE7_File, $aJRE7_File[0], $aJRE7_DeploymentProperties[$i][0] & $aJRE7_DeploymentProperties[$i][1])
							EndIf
						EndIf
					Next
					; ----------------------------------------------------------------------------------------------------
					If FileClose($hJRE7_File) = 1 Then
						$hJRE7_File = FileOpen($sJRE7_File, 2)
						If $hJRE7_File <> -1 Then
							Local $iJRE7_FileReadFailure = UBound($aJRE7_File) - 1
							For $i = 1 To UBound($aJRE7_File) - 1 Step 1
								$iJRE7_FileReadFailure -= FileWrite($hJRE7_File, $aJRE7_File[$i] & @CRLF)
							Next
							If FileClose($hJRE7_File) = 1 Then
								If Not $iJRE7_FileReadFailure Then
									$iJRE7_Return = 1
								Else ; Error.
									SetError(15000, 0)
								EndIf
							Else ; Error.
								SetError(14000, 0)
							EndIf
						Else ; Error.
							SetError(13000, 0)
						EndIf
					Else ; Error.
						SetError(12000, 0)
					EndIf
				Else ; Error.
					SetError(11000, 0)
				EndIf
			Else ; Error.
				SetError(10000, 0)
			EndIf
	EndSwitch
	Return $iJRE7_Return
EndFunc   ;==>_JRE7_MSIEEnable


; #FUNCTION# =========================================================================================
; Function Name:	_JRE7_SecurityLevel()
; Description:		Sets JRE7 (U10+) security settings -
;					user-definied settings (2D-array: [n][0] = value, [n][1] = data - blank/empty data will remove the entry) will be considered during runtime
;					[http://docs.oracle.com/javase/7/docs/technotes/guides/deployment/deployment-guide/properties.html],
;					[http://www.autoitscript.com/forum/topic/149260-control-java-runtime-environment-7-jre7-security-settings/],
;					[http://www.h-online.com/security/news/item/Java-7-Update-21-closes-security-holes-and-restricts-applets-1843558.html],
;					[http://www.heise.de/security/meldung/Java-7-Update-21-stopft-Sicherheitsluecken-und-beschraenkt-Applets-1843271.html],
;					[http://www.java.com/de/download/faq/signed_code.xml],
;					[http://www.java.com/en/download/faq/signed_code.xml].
; Syntax:			_JRE7_Security([Const $iJRE7_DeploymentSecurityLevel = 1 [, Const $sJRE7_DeploymentInsecureJres = "" [, Const $sJRE7_DeploymentSecurityLocalApplets = "" [, Const $sJRE7_DeploymentSecurityRunUntrusted = ""]]]])
; Parameter(s):		$iJRE7_DeploymentSecurityLevel ("deployment.security.level"):
;					| 0 - "VERY_HIGH",
;					| 1 - "HIGH" (default),
;					| 2 - "MEDIUM",
;					| 3 - "LOW" (Java 7 Update 17 [-]),
;					| 4 - "CUSTOM":
;					|     $sJRE7_DeploymentInsecureJres ("deployment.insecure.jres"):
;					|     | "" (default = delete),
;					|     | "ALWAYS",
;					|     | "NEVER",
;					|     | "PROMPT_MULTI".
;					|     $sJRE7_DeploymentSecurityLocalApplets ("deployment.security.local.applets"):
;					|     | "" (default = delete),
;					|     | "NEVER",
;					|     | "PROMPT".
;					|     $sJRE7_DeploymentSecurityRunUntrusted ("deployment.security.run.untrusted"):
;					|     | "" (default = delete),
;					|     | "NEVER",
;					|     | "PROMPT".
;					$bJRE7_DeploymentExpirationDecision (	"deployment.expiration.decision.10.<$___JRE7_SECURITY_BASELINE_VERSION>.2",
;					|										"deployment.expiration.decision.suppression.10.<$___JRE7_SECURITY_BASELINE_VERSION>.2",
;					|										"deployment.expiration.decision.timestamp.10.<$___JRE7_SECURITY_BASELINE_VERSION>.2"):
;					| False - Disable update promt (default).
;					| True - Enable update prompt.
; Requirement(s):	#include "___JRE7_ArrayInsert.au3"
;					#include "___JRE7_DeploymentProperties.au3"
;					#include "___JRE7_SecurityBaselineVersion.au3"
; Return Value(s):	On success - Returns 1, @error = 0, @extended = 0.
;					On failure - Returns 0, @extended = 0, @error:
;					|     0 - No error.
;					| 10000 - '___JRE7_DeploymentProperties()' failure.
;					| 11000 - 'FileOpen()' failure (#1, read).
;					| 12000 - 'FileClose()' failure (#1, read).
;					| 13000 - 'FileOpen()' failure (#2, write).
;					| 14000 - 'FileClose()' failure (#2, write).
;					| 15000 - '$iJRE7_FileReadFailure' failure.
; Author(s):		Supersonic!
; ====================================================================================================
Func _JRE7_SecurityLevel( _
		Const $iJRE7_DeploymentSecurityLevel = 1, _
		Const $sJRE7_DeploymentInsecureJres = "", _
		Const $sJRE7_DeploymentSecurityLocalApplets = "", _
		Const $sJRE7_DeploymentSecurityRunUntrusted = "", _
		Const $bJRE7_DeploymentExpirationDecision = False)
	Local $iJRE7_Return = 0
	Local $sJRE7_File = ___JRE7_DeploymentProperties()
	If Not @error Then
		Local $hJRE7_File = FileOpen($sJRE7_File, 0)
		If $hJRE7_File <> -1 Then
			If Not $___JRE7_SECURITY_BASELINE_VERSION Then
				___JRE7_SecurityBaselineVersion()
			EndIf
			; ----------------------------------------------------------------------------------------------------
			; [n][0] = value, [n][1] = data, [n][2] = mandatory, [n][3] = processed.
			Local $aJRE7_DeploymentProperties[9][4] = [ _
					["deployment.version=", "7." & $___JRE7_SECURITY_BASELINE_VERSION, 1, 0], _ ; Java 7 Update 21 (+).
					["deployment.insecure.jres=", "", 0, 0], _
					["deployment.security.level=", "", 0, 0], _
					["deployment.security.local.applets=", "", 0, 0], _
					["deployment.security.run.untrusted=", "", 0, 0], _
					["deployment.expiration.decision.10." & $___JRE7_SECURITY_BASELINE_VERSION & ".2=", "", 0, 0], _ ; "later", "never".
					["deployment.expiration.decision.suppression.10." & $___JRE7_SECURITY_BASELINE_VERSION & ".2=", "", 0, 0], _ ; "false", "true".
					["deployment.expiration.decision.timestamp.10." & $___JRE7_SECURITY_BASELINE_VERSION & ".2=", "", 0, 0], _ ; "1/31/2013 0\:0\:0".
					["deployment.expired.version=", "", 0, 0]] ; "0".
			Local $aJRE7_File[1] = [0] ; [0] = "#deployment.properties" ("#Java Deployment jre's").
			Local $bJRE7_FileReadLine = False
			Local $iJRE7_FileReadLine = 0
			Local $sJRE7_FileReadLine = ""
			; ----------------------------------------------------------------------------------------------------
			If _
					UBound($___JRE7_DEPLOYMENT_PROPERTIES_UDS, 0) = 2 And _
					UBound($___JRE7_DEPLOYMENT_PROPERTIES_UDS, 1) > 0 Then
				Local $iJRE7_DeploymentProperties = 0
				For $i = 0 To UBound($___JRE7_DEPLOYMENT_PROPERTIES_UDS, 1) - 1 Step 1
					ReDim $aJRE7_DeploymentProperties[UBound($aJRE7_DeploymentProperties, 1) + 1][UBound($aJRE7_DeploymentProperties, 2)]
					$iJRE7_DeploymentProperties = UBound($aJRE7_DeploymentProperties, 1) - 1
					$aJRE7_DeploymentProperties[$iJRE7_DeploymentProperties][0] = $___JRE7_DEPLOYMENT_PROPERTIES_UDS[$i][0]
					$aJRE7_DeploymentProperties[$iJRE7_DeploymentProperties][1] = $___JRE7_DEPLOYMENT_PROPERTIES_UDS[$i][1]
					$aJRE7_DeploymentProperties[$iJRE7_DeploymentProperties][2] = 1
					$aJRE7_DeploymentProperties[$iJRE7_DeploymentProperties][3] = 0
				Next
			EndIf
			; ----------------------------------------------------------------------------------------------------
			Switch $iJRE7_DeploymentSecurityLevel
				Case 0
					$aJRE7_DeploymentProperties[2][1] = "VERY_HIGH"
					$aJRE7_DeploymentProperties[2][2] = 1
				Case 2
					$aJRE7_DeploymentProperties[2][1] = "MEDIUM"
					$aJRE7_DeploymentProperties[2][2] = 1
				Case 3
					$aJRE7_DeploymentProperties[2][1] = "LOW"
					$aJRE7_DeploymentProperties[2][2] = 1
				Case 4
					$aJRE7_DeploymentProperties[1][1] = $sJRE7_DeploymentInsecureJres
					$aJRE7_DeploymentProperties[1][2] = 1
					$aJRE7_DeploymentProperties[2][1] = "CUSTOM"
					$aJRE7_DeploymentProperties[2][2] = 1
					$aJRE7_DeploymentProperties[3][1] = $sJRE7_DeploymentSecurityLocalApplets
					$aJRE7_DeploymentProperties[3][2] = 1
					$aJRE7_DeploymentProperties[4][1] = $sJRE7_DeploymentSecurityRunUntrusted
					$aJRE7_DeploymentProperties[4][2] = 1
			EndSwitch
			Switch $bJRE7_DeploymentExpirationDecision
				Case True
					If $___JRE7_SECURITY_BASELINE_VERSION > 0 Then
						$aJRE7_DeploymentProperties[5][1] = "never"
						$aJRE7_DeploymentProperties[5][2] = 1
						$aJRE7_DeploymentProperties[6][1] = "true"
						$aJRE7_DeploymentProperties[6][2] = 1
						$aJRE7_DeploymentProperties[7][1] = "1/31/2013 0\:0\:0"
						$aJRE7_DeploymentProperties[7][2] = 1
						$aJRE7_DeploymentProperties[8][1] = "0"
						$aJRE7_DeploymentProperties[8][2] = 1
					EndIf
			EndSwitch
			; ----------------------------------------------------------------------------------------------------
			While 1
				$bJRE7_FileReadLine = True
				$sJRE7_FileReadLine = FileReadLine($hJRE7_File)
				If Not @error Then ; Non-error (#1).
					For $i = 0 To UBound($aJRE7_DeploymentProperties, 1) - 1 Step 1
						If StringInStr($sJRE7_FileReadLine, $aJRE7_DeploymentProperties[$i][0]) > 0 Then
							If $aJRE7_DeploymentProperties[$i][1] <> "" Then
								$aJRE7_DeploymentProperties[$i][3] = 1 ; Checked/done.
								$sJRE7_FileReadLine = $aJRE7_DeploymentProperties[$i][0] & $aJRE7_DeploymentProperties[$i][1]
							Else ; Non-error.
								$bJRE7_FileReadLine = False
							EndIf
							ExitLoop (1)
						EndIf
					Next
					If $bJRE7_FileReadLine = True Then
						ReDim $aJRE7_File[UBound($aJRE7_File) + 1]
						$aJRE7_File[UBound($aJRE7_File) - 1] = $sJRE7_FileReadLine
						If StringInStr($sJRE7_FileReadLine, "#deployment.properties") > 0 Then ; If StringInStr($sJRE7_FileReadLine, "#Java Deployment jre's") > 0 Then
							$aJRE7_File[0] = $iJRE7_FileReadLine + 2 ; $aJRE7_File[0] = $iJRE7_FileReadLine
						EndIf
						$iJRE7_FileReadLine += 1
					EndIf
				ElseIf @error = -1 Then ; Non-error (#2).
					ExitLoop (1)
				Else ; Error.
					ExitLoop (1)
				EndIf
			WEnd
			; ----------------------------------------------------------------------------------------------------
			For $i = 0 To UBound($aJRE7_DeploymentProperties, 1) - 1 Step 1
				If $aJRE7_DeploymentProperties[$i][1] <> "" Then
					If $aJRE7_DeploymentProperties[$i][2] <> $aJRE7_DeploymentProperties[$i][3] Then
						$aJRE7_DeploymentProperties[$i][3] = 1 ; Checked/done.
						$aJRE7_File[0] += 1 ; !!!
						___JRE7_ArrayInsert($aJRE7_File, $aJRE7_File[0], $aJRE7_DeploymentProperties[$i][0] & $aJRE7_DeploymentProperties[$i][1])
					EndIf
				EndIf
			Next
			; ----------------------------------------------------------------------------------------------------
			If FileClose($hJRE7_File) = 1 Then
				$hJRE7_File = FileOpen($sJRE7_File, 2)
				If $hJRE7_File <> -1 Then
					Local $iJRE7_FileReadFailure = UBound($aJRE7_File) - 1
					For $i = 1 To UBound($aJRE7_File) - 1 Step 1
						$iJRE7_FileReadFailure -= FileWrite($hJRE7_File, $aJRE7_File[$i] & @CRLF)
					Next
					If FileClose($hJRE7_File) = 1 Then
						If Not $iJRE7_FileReadFailure Then
							$iJRE7_Return = 1
						Else ; Error.
							SetError(15000, 0)
						EndIf
					Else ; Error.
						SetError(14000, 0)
					EndIf
				Else ; Error.
					SetError(13000, 0)
				EndIf
			Else ; Error.
				SetError(12000, 0)
			EndIf
		Else ; Error.
			SetError(11000, 0)
		EndIf
	Else ; Error.
		SetError(10000, 0)
	EndIf
	Return $iJRE7_Return
EndFunc   ;==>_JRE7_SecurityLevel


; !!! INTERNAL !!!
Func ___JRE7_ArrayInsert(ByRef $aJRE7_ReferenceObject, Const $iJRE7_ItemPosition, Const $vJRE7_ItemValue = "") ; _ArrayInsert()
	Local $iJRE7_Return = 0
	If IsArray($aJRE7_ReferenceObject) = 1 Then
		If UBound($aJRE7_ReferenceObject, 0) = 1 Then
			$iJRE7_Return = UBound($aJRE7_ReferenceObject) + 1
			ReDim $aJRE7_ReferenceObject[$iJRE7_Return]
			For $i = $iJRE7_Return - 1 To $iJRE7_ItemPosition + 1 Step -1
				$aJRE7_ReferenceObject[$i] = $aJRE7_ReferenceObject[$i - 1]
			Next
			$aJRE7_ReferenceObject[$iJRE7_ItemPosition] = $vJRE7_ItemValue
		Else ; Error.
			SetError(2, 0)
		EndIf
	Else ; Error.
		SetError(1, 0)
	EndIf
	Return $iJRE7_Return
EndFunc   ;==>___JRE7_ArrayInsert


; !!! INTERNAL !!!
; [http://msdn.microsoft.com/en-us/library/windows/desktop/ms724265(VS.85).aspx],
; [http://technet.microsoft.com/en-us/library/cc775560(WS.10).aspx].
Func ___JRE7_DeploymentProperties()
	Local $sJRE7_Return = ""
	Local $oJRE7_WScriptShell = ObjCreate("WScript.Shell")
	If Not @error Then
		Local $sJRE7_File = $oJRE7_WScriptShell.ExpandEnvironmentStrings("%LOCALAPPDATA%") ; Microsoft Windows Server 2008 / Vista (+).
		Switch (FileExists($sJRE7_File) = 1)
			Case True
				$sJRE7_File &= "Low\Sun\Java\Deployment\deployment.properties"
			Case Else
				$sJRE7_File = $oJRE7_WScriptShell.ExpandEnvironmentStrings("%APPDATA%") ; Microsoft Windows Server 2003 / XP (-).
				Switch (FileExists($sJRE7_File) = 1)
					Case True
						$sJRE7_File &= "\Sun\Java\Deployment\deployment.properties"
					Case Else
						$sJRE7_File = ""
				EndSwitch
		EndSwitch
		If $sJRE7_File <> "" Then
			If Not FileExists($sJRE7_File) Then
				Local $hJRE7_File = FileOpen($sJRE7_File, 2 + 8)
				If $hJRE7_File <> -1 Then
					Local $sJRE7_DeploymentProperties = _
							"#deployment.properties" & @CRLF & _
							"#" & @CRLF & _
							"#Java Deployment jre's" & @CRLF & _
							"#" & @CRLF
					Local $sJRE7_FileWrite = FileWrite($hJRE7_File, $sJRE7_DeploymentProperties)
					If FileClose($hJRE7_File) = 1 Then
						If $sJRE7_FileWrite = 1 Then
							$sJRE7_Return = $sJRE7_File
							SetExtended(2)
						Else ; Error.
							SetError(5, 0)
						EndIf
					Else ; Error.
						SetError(4, 0)
					EndIf
				Else ; Error.
					SetError(3, 0)
				EndIf
			Else ; Non-error.
				$sJRE7_Return = $sJRE7_File
				SetExtended(1)
			EndIf
		Else ; Error.
			SetError(2, 0)
		EndIf
	Else ; Error.
		SetError(1, 0)
	EndIf
	$oJRE7_WScriptShell = 0
	Sleep(5000)
	Return $sJRE7_Return
EndFunc   ;==>___JRE7_DeploymentProperties


; !!! INTERNAL !!!
Func ___JRE7_GUID(Const $sJRE7_HKEY)
	Local $sJRE7_Return = ""
	If $sJRE7_HKEY <> "" Then
		Local $aJRE7_HKEY[1] = [0]
		_RegEnumKey($sJRE7_HKEY, $aJRE7_HKEY, False)
		If Not @error Then
			; Example(s).
			; {26A24AE4-039D-4CA4-87B4-2F83217010FF} - Java 7 Update 10.
			; {26A24AE4-039D-4CA4-87B4-2F86417010FF} - Java 7 Update 10 (64-bit).
			; {26A24AE4-039D-4CA4-87B4-2F83217017FF} - Java 7 Update 17.
			; {26A24AE4-039D-4CA4-87B4-2F86417017FF} - Java 7 Update 17 (64-bit).
			; {26A24AE4-039D-4CA4-87B4-2F83217021FF} - Java 7 Update 21.
			; {26A24AE4-039D-4CA4-87B4-2F86417021FF} - Java 7 Update 21 (64-bit).
			Local $iJRE7_Extended = 0
			Local $sJRE7_GUID = ""
			Do
				Switch ((StringInStr($aJRE7_HKEY[$aJRE7_HKEY[0]], "{26A24AE4-039D-4CA4-87B4-") > 0) And (StringInStr($aJRE7_HKEY[$aJRE7_HKEY[0]], "FF}") > 0))
					Case True
						; [http://en.wikipedia.org/wiki/Globally_unique_identifier],
						; [http://en.wikipedia.org/wiki/Universally_unique_identifier].
						$sJRE7_GUID = StringRight($aJRE7_HKEY[$aJRE7_HKEY[0]], 38)
						; [http://www.autoitscript.com/forum/topic/147646-isguid-check-a-guid-string-with-or-without-brackets-is-valid/].
						; If StringRegExp($sJRE7_GUID, "^(\{){0,1}[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}(\}){0,1}$") = 1 Then
						If StringRegExp($sJRE7_GUID, "^(\{){0,1}[[:xdigit:]]{8}\-[[:xdigit:]]{4}\-[[:xdigit:]]{4}\-[[:xdigit:]]{4}\-[[:xdigit:]]{12}(\}){0,1}$") = 1 Then
							Local $sJRE7_DisplayVersion = RegRead($sJRE7_HKEY & "\" & $sJRE7_GUID, "DisplayVersion")
							If Not @error Then
								If Number($sJRE7_DisplayVersion, Default) >= 7.0 Then
									$iJRE7_Extended = Int(StringMid($sJRE7_GUID, 34, 35), Default)
									$sJRE7_Return = $sJRE7_GUID
									ExitLoop ; !!!
								Else ; Non-error.
									ContinueCase ; !!!
								EndIf
							Else ; Error.
								ContinueCase ; !!!
							EndIf
						Else ; Non-error.
							ContinueCase ; !!!
						EndIf
					Case Else
						$aJRE7_HKEY[0] -= 1
				EndSwitch
			Until ((Not $aJRE7_HKEY[0]) Or ($sJRE7_Return <> ""))
			; ----------------------------------------------------------------------------------------------------
			ConsoleWrite("___JRE7_GUID() -> [" & $aJRE7_HKEY[0] & "][" & $sJRE7_Return & "][" & $iJRE7_Extended & "]" & @CRLF)
			; ----------------------------------------------------------------------------------------------------
			SetExtended($iJRE7_Extended)
		Else ; Error.
			SetError(2, @error)
		EndIf
	Else ; Error.
		SetError(1, 0)
	EndIf
	Return $sJRE7_Return
EndFunc   ;==>___JRE7_GUID


; !!! INTERNAL !!!
Func ___JRE7_MSIEEnable(Const $bJRE7_DeploymentWebjavaEnabled = True)
	Local $iJRE7_Return = 0
	If IsAdmin() = 1 Then
		Local $aJRE7_Registry[1] = [0]
		Local $iJRE7_Error = 0
		Local $iJRE7_Extended = 0
		Local $iJRE7_Result = 0
		Local $sJRE7_GUID = ""
		Local $sJRE7_HKEY = ""
		Local $sJRE7_InstallationLocation = ""
		; ----------------------------------------------------------------------------------------------------
		If $bJRE7_DeploymentWebjavaEnabled = True Then
			$aJRE7_Registry = $___JRE7_SECURITY_MSIE_ENABLE
		Else ; Non-error.
			$aJRE7_Registry = $___JRE7_SECURITY_MSIE_DISABLE
		EndIf
		; ----------------------------------------------------------------------------------------------------
		Switch (StringInStr(@OSArch, "64", 1) > 0)
			Case True ; "X64".
				$sJRE7_HKEY = "HKLM64\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
				$sJRE7_GUID = ___JRE7_GUID($sJRE7_HKEY)
				If Not @error Then
					$___JRE7_SECURITY_BASELINE_VERSION = @extended
					$sJRE7_InstallationLocation = RegRead($sJRE7_HKEY & "\" & $sJRE7_GUID, "InstallLocation")
					If Not @error Then
						$iJRE7_Result += ___JRE7_Registry($aJRE7_Registry, $sJRE7_InstallationLocation, True)
						If Not @error Then
							$iJRE7_Extended += @extended
						Else ; Error.
							$iJRE7_Error += @error
						EndIf
					EndIf
				EndIf
				ContinueCase ; !!!
			Case Else ; "X86".
				$sJRE7_HKEY = "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
				$sJRE7_GUID = ___JRE7_GUID($sJRE7_HKEY)
				If Not @error Then
					$___JRE7_SECURITY_BASELINE_VERSION = @extended
					$sJRE7_InstallationLocation = RegRead($sJRE7_HKEY & "\" & $sJRE7_GUID, "InstallLocation")
					If Not @error Then
						$iJRE7_Result += ___JRE7_Registry($aJRE7_Registry, $sJRE7_InstallationLocation)
						If Not @error Then
							$iJRE7_Extended += @extended
						Else ; Error.
							$iJRE7_Error += @error
						EndIf
					EndIf
				EndIf
		EndSwitch
		If Not $iJRE7_Error Then
			$iJRE7_Return = 1
			SetExtended($iJRE7_Extended)
		Else ; Error.
			SetError($iJRE7_Error, $iJRE7_Extended)
		EndIf
	Else ; Error.
		SetError(1000, 0)
	EndIf
	Return $iJRE7_Return
EndFunc   ;==>___JRE7_MSIEEnable


; !!! INTERNAL !!!
Func ___JRE7_Registry(ByRef $aJRE7_ReferenceObject, Const $sJRE7_InstallationLocation, Const $bJRE7_X64 = False)
	Local $iJRE7_Error = 0
	Local $iJRE7_Extended = 0
	Local $iJRE7_Return = 0
	If UBound($aJRE7_ReferenceObject, 0) = 2 Then
		Local $aJRE7_Bittness[2] = [0x1, ""] ; "X86".
		Local $iJRE7_UBound = UBound($aJRE7_ReferenceObject, 1) - 1
		Switch $bJRE7_X64
			Case True ; "IA64", "X64".
				$aJRE7_Bittness[0] = 0x2
				$aJRE7_Bittness[1] = "64"
				ContinueCase ; !!!
			Case Else
				Local $sJRE7_HKEY = ""
				For $i = 0 To $iJRE7_UBound Step 1
					ConsoleWrite("___JRE7_Registry() -> [" & StringFormat("%0" & StringLen($iJRE7_UBound) & "i", $i) & "/" & $iJRE7_UBound & "][" & BitAND($aJRE7_Bittness[0], $aJRE7_ReferenceObject[$i][0]) & "]")
					; ----------------------------------------------------------------------------------------------------
					Switch BitAND($aJRE7_Bittness[0], $aJRE7_ReferenceObject[$i][0])
						Case 1, 2 ; 1 = "X86", 2 = "X64".
							If $aJRE7_ReferenceObject[$i][2] <> "" Then
								$sJRE7_HKEY = $aJRE7_ReferenceObject[$i][2]
							Else ; Non-error.
								$aJRE7_ReferenceObject[$i][2] = $sJRE7_HKEY
							EndIf
							; ----------------------------------------------------------------------------------------------------
							ConsoleWrite("[" & $aJRE7_ReferenceObject[$i][1] & "][HKLM" & $aJRE7_Bittness[1] & "\" & $aJRE7_ReferenceObject[$i][2] & "][" & $aJRE7_ReferenceObject[$i][3] & "][" & $aJRE7_ReferenceObject[$i][4] & "][" & $aJRE7_ReferenceObject[$i][5] & "]")
							; ----------------------------------------------------------------------------------------------------
							Switch $aJRE7_ReferenceObject[$i][1]
								Case 0 ; Delete.
									If $aJRE7_ReferenceObject[$i][3] <> "" Then
										RegDelete("HKLM" & $aJRE7_Bittness[1] & "\" & $aJRE7_ReferenceObject[$i][2], $aJRE7_ReferenceObject[$i][3])
										Switch @error
											Case 0, 1
												$iJRE7_Extended += 1
											Case Else
												$iJRE7_Error += 1
										EndSwitch
									Else ; Non-error.
										RegDelete("HKLM" & $aJRE7_Bittness[1] & "\" & $aJRE7_ReferenceObject[$i][2])
										Switch @error
											Case 0, 1
												$iJRE7_Extended += 1
											Case Else
												$iJRE7_Error += 1
										EndSwitch
									EndIf
								Case 1 ; Write.
									If $aJRE7_ReferenceObject[$i][3] <> "" Then
										If $aJRE7_ReferenceObject[$i][4] <> "" Then
											RegWrite("HKLM" & $aJRE7_Bittness[1] & "\" & $aJRE7_ReferenceObject[$i][2], $aJRE7_ReferenceObject[$i][3], $aJRE7_ReferenceObject[$i][4], StringReplace($aJRE7_ReferenceObject[$i][5], "@INSTALLLOCATION@", $sJRE7_InstallationLocation, 0, 0))
											If Not @error Then
												$iJRE7_Extended += 1
											Else ; Error.
												$iJRE7_Error += 1
											EndIf
										Else ; Error.
											$iJRE7_Error += 1
										EndIf
									Else ; Non-error.
										RegWrite("HKLM" & $aJRE7_Bittness[1] & "\" & $aJRE7_ReferenceObject[$i][2])
										If Not @error Then
											$iJRE7_Extended += 1
										Else ; Error.
											$iJRE7_Error += 1
										EndIf
									EndIf
							EndSwitch
							; ----------------------------------------------------------------------------------------------------
							ConsoleWrite("[" & $iJRE7_Error & "][" & $iJRE7_Extended & "]")
						Case Else
							; <...>
					EndSwitch
					; ----------------------------------------------------------------------------------------------------
					ConsoleWrite(@CRLF)
				Next
		EndSwitch
		If Not $iJRE7_Error Then
			$iJRE7_Return = 1
			SetExtended($iJRE7_Extended)
		Else ; Error.
			SetError($iJRE7_Error, $iJRE7_Extended)
		EndIf
	Else ; Error.
		SetError(1000, 0)
	EndIf
	Return $iJRE7_Return
EndFunc   ;==>___JRE7_Registry


; !!! INTERNAL !!!
Func ___JRE7_SecurityBaselineVersion()
	Local $iJRE7_Return = 0
	Local $sJRE7_HKEY = "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
	___JRE7_GUID("HKLM64\" & $sJRE7_HKEY)
	Switch (Not @extended)
		Case True
			___JRE7_GUID("HKLM\" & $sJRE7_HKEY)
			Switch (Not @extended)
				Case True
					SetError(1, 0)
				Case Else
					$___JRE7_SECURITY_BASELINE_VERSION = @extended
					$iJRE7_Return = 1
					SetExtended(2)
			EndSwitch
		Case Else
			$___JRE7_SECURITY_BASELINE_VERSION = @extended
			$iJRE7_Return = 1
			SetExtended(1)
	EndSwitch
	Return $iJRE7_Return
EndFunc   ;==>___JRE7_SecurityBaselineVersion
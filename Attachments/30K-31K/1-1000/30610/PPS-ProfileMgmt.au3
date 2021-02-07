#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Change2CUI=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;################################################################################
; File......: PPS-ProfileMgmt.exe (PPS-ProfileMgmt.au3)
; Author....: Adam Seitz (aseitz@pps.k12.or.us)
; Purpose...: This script runs as a service and preforms account profile
;             managment. This software runs in three phases.
;
;    Phase 1: The tool loops through all the system accounts and removes student
;             accounts from the machine. Student accounts all have a common
;             naming convention of: ##XXXXXX. The profiles will need to be able
;             to be removed by phase 3 as well.
;
;    Phase 2: The tool first runs and scans through the "C:\Temp" directory for
;             any profiles that are marked for deletion. These are identified by
;             having a file in them named: "C:\Temp\<profile name>\expire.txt".
;             This file contains a single line with the date of expiration. The
;             next time this script is run and the current date is later than the
;             expiration date, the file is deleted. The amount of days to save
;             profiles is controlled by a variable.
;
;    Phase 3: The script loops through scanning all files / folders in the
;             profile folder ("C:\Users" in windows vista/win 7
;             "C:\Documents and Settings" in Windows XP / 2000. Any file in the
;             profile directory that is not a directory itself is ignored. Any
;             profile names that contain ".pps" anywhere in its name is preserved
;             as it could possibly be a domain profile. Any remaining profiles
;             that do not have a matching local account name are moved to
;             "C:\Temp" and an expire.txt is placed in it with the date that the
;             script will remove the directory.
;
;################################################################################
; Includes and Compiler Flags
#include <Array.au3>
#include <Date.au3>
#include <File.au3>
#include <INet.au3>
#include <WindowsConstants.au3>

; Create our console window
RunWait(@ComSpec & " /c " & 'TITLE Account Managment Tool', "", @SW_HIDE)
ConsoleWrite("+ Processing Profiles" & @CRLF)

; List of Protected Accounts and Profiles by Name
Local $ProfileArray[6]
$ProfileArray[0]="Default"
$ProfileArray[1]="Default User"
$ProfileArray[2]="All Users"
$ProfileArray[3]="Public"
$ProfileArray[4]="LocalService"
$ProfileArray[5]="NetworkService"

; This Variable is the path to the Windows Installation folder on the system.
Local $WinDir = @WindowsDir

; This Variable is the path to the Tools folder in the pps-installer folder.
Local $Tools = "C:\Installers\Tools"

; This Variable is the path to the temp folder used for profile managment.
Local $Temp = "C:\Temp"

; This Variable is the number of days to store profiles for
Local $ExpireDays = 10

; This Variable is the path to the Profiles direcrtory on the system.
If FileExists( "C:\Users") Then
	$DocRoot = "C:\Users"
ElseIf FileExists( "C:\Documents and Settings") Then
	$DocRoot = "C:\Documents and Settings"
Else
	ConsoleWrite("Profile Path Not Found! Exiting!" & @CRLF)
	Exit
EndIF

; This group of variables is used for file / folder work.
Local $Search
Local $File
Local $FileAttributes
Local $FullFilePath

;--------------------------------------------------------------------------------
; Function Declaration: SYSTEMUSERS()
;   This Function Loops through and returns an array of local account names.
;--------------------------------------------------------------------------------
Func _SystemUsers($AccountType = 0)
    Local $aSystemUsers
    Local $wbemFlagReturnImmediately = 0x10, $wbemFlagForwardOnly = 0x20
    Local $colItems = "", $strComputer = "localhost"

    If Not StringRegExp($AccountType, '[012]') Then Return SetError(3, 3, '')
    $objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\CIMV2")
    $colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_SystemUsers", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)

    If IsObj($colItems) Then
        For $objItem In $colItems
            $Output = StringSplit($objItem.PartComponent, ',')
            If IsArray($Output) Then
                $Temp1 = StringReplace(StringTrimLeft($Output[2], StringInStr($Output[2], '=', 0, -1)), '"', '')
                If $AccountType = 0 Or ($AccountType = 1 And @ComputerName = $Temp1) Then
                    $aSystemUsers &= StringReplace(StringTrimLeft($Output[1], StringInStr($Output[1], '=', 0, -1)), '"', '') & '|'
                ElseIf $AccountType = 2 And @ComputerName <> $Temp1 Then
                    $aSystemUsers &= StringReplace(StringTrimLeft($Output[1], StringInStr($Output[1], '=', 0, -1)), '"', '') & '|'
                EndIf
            EndIf
        Next
        $aSystemUsers = StringTrimRight($aSystemUsers, 1)
        If $aSystemUsers = '' Then Return(SetError(1, 1, $aSystemUsers))
        Return(SetError(0, 0, StringSplit($aSystemUsers, '|')))
    Else
        $aSystemUsers = ''
        Return(SetError(2, 2, $aSystemUsers))
    EndIf
EndFunc   ;==>_SystemUsers
;--------------------------------------------------------------------------------

;--------------------------------------------------------------------------------
; Function Declaration: LOGWRITE()
;   This is the function that handles the log file handling
;--------------------------------------------------------------------------------
Func LogWrite($text)
	If FileExists("C:\Windows\System32\eventcreate.exe") Then
		; Windows XP ( and later OS's) Have Built In Event Managment that is better than the internal _Event_ Functions.
		RunWait(@ComSpec & " /c " & 'start /wait /min eventcreate.exe /ID 1 /L APPLICATION /T INFORMATION /SO PPS-ProfileMgmt /D "' & $text & '"', "", @SW_HIDE)
	Else
		; 2K Is using "LogEvent.exe" from the Windows 2000 Resource Kit.
		RunWait(@ComSpec & " /c " & 'start /wait /min ' & $Tools & '\LogEvent.exe -r PPS-ProfileMgmt "' & $text & '"',"", @SW_HIDE)
	EndIf
EndFunc ;End LogWrite()
;--------------------------------------------------------------------------------

;################################################################################
; PHASE 1: Look for Student Account(s) to remove from the system
;################################################################################
;   This Function Loops through and returns an array of local student domain
;   account names.

; Get a complete List of Local Accounts
Local $Students = _SystemUsers(0)
Local $Counter = $Students[0]

; Evalute each element and trim off any that don't start with 2 letters and 6 numbers.
While 1

	; Lets loop until our counter reaches 0 - the counter will loop on the number of elements in the array.
	; We're Actually Processing the Array from the End to the Beginning.
	If $Counter = 0 then
		ExitLoop
	Else
		$Counter = $Counter - 1
	EndIf

	; Use the Counter to Process the array list
	$CurrentAccount = $Students[$Counter]

	; We can elimitate any elements that contain only Alphanumeric data
	If StringIsAlpha($CurrentAccount) Then
		; We can ignore it
		MsgBox(1,"Skipped Account", $Counter & ":" & " " & $CurrentAccount & " Is Not A Student Account")
	Else
		MsgBox(1,"Suspect Account", $Counter & ":" & " " & $CurrentAccount & " Might Be A Student Account")
	EndIf

	; Debugging
WEnd

;  List Of Users on System to be appended to Protected Profiles
_ArrayDisplay($Students)

exit

;################################################################################
; PHASE 2: Look for Profiles in $Temp and check for expiration.
;################################################################################

$Search = FileFindFirstFile($Temp & "\*.*")

If FileExists($Temp) Then
	ConsoleWrite( "* Phase 1: Locating Old Profiles" & @CRLF)
	;LogWrite("PPS-ProfileMgmt: Phase 1: Checking Temp Folder for Expiration Dates")
	While 1
		If $Search = -1 Then
			ExitLoop
		EndIf

		$File = FileFindNextFile($Search)

		If @error Then
			ExitLoop
		EndIf

		$FullFilePath = $Temp
		$FileAttributes = FileGetAttrib($FullFilePath)

		If StringInStr($FileAttributes,"D") Then
			If FileExists($Temp & "\" & $File & "\expire.txt") Then
				ConsoleWrite("  - Located: " & $Temp & "\" & $File & "\expire.txt"  & @CRLF)
				$TimeFile = FileRead($Temp & "\" & $File & "\expire.txt")
				$TimeNow = @YEAR & @YDAY
				If $TimeNow >= $TimeFile Then
					ConsoleWrite("  - Deleting: Time Now = " & $TimeNow &  " >= Expired on = " & $TimeFile & @CRLF)
					;LogWrite("PPS-ProfileMgmt: Phase 1: "& $Temp & "\" & $File & "\expire.txt - Run On: " & $TimeNow & "Expired On: " & $TimeFile)
					DirRemove("" & $Temp & "\" & $File, 1)
					If @error Then
						LogWrite("PPS-ProfileMgmt: Phase 1: Failure: " & $Temp & "\" & $File & " - was unable to be removed")
						ConsoleWrite("  - Failure: " & $Temp & "\" & $File & " - was unable to be removed" & @CRLF)
						ExitLoop
					Else
						LogWrite("PPS-ProfileMgmt: Phase 1: Removed: "& $Temp & "\" & $File)
						ConsoleWrite("  - Removed: " & $Temp & "\" & $File  & @CRLF)
					EndIf
				Else
					ConsoleWrite("  - Skipping: Time Now = " & $TimeNow &  " <  Expires on = " & $TimeFile & @CRLF)
				EndIf
			EndIf
			;ConsoleWrite(@CRLF)
		EndIf
	WEnd
Else
	ConsoleWrite("* Phase 1: No Work To Do" & @CRLF)
EndIf
ConsoleWrite("  - Completed" & @CRLF & @CRLF)

;################################################################################
; PHASE 3: Get/Compare/Move Profiles on system
;################################################################################
ConsoleWrite( "* Phase 2: Locating Rogue Profiles" & @CRLF)


;  List Of Users on System to be appended to Protected Profiles
Local $Users = _SystemUsers(0)

$Search = FileFindFirstFile($DocRoot & "\*.*")

While 1
	If $Search = -1 Then
		ExitLoop
	EndIf

	$File = FileFindNextFile($Search)
	If @error Then ExitLoop

	$FullFilePath = $DocRoot & "\" & $File
	$FileAttributes = FileGetAttrib($FullFilePath)

	If StringInStr($FileAttributes,"D") Then
		local $test1 = _ArrayFindAll($ProfileArray, $File)
		If $test1 >= 0 Then
			ConsoleWrite( "  - Profile: " & $DocRoot & "\" & $File & @CRLF & "  - Protected by Default" & @CRLF)
			;LogWrite("PPS-ProfileMgmt: Phase 2: "& $DocRoot & "\" & $File & "  - Protected by Default" )
		Else
			local $test2 = _ArrayFindAll($Users, $File)
			If $test2 >= 0 Then
				ConsoleWrite("  - Profile: " & $DocRoot & "\" & $File & @CRLF & "  - Protected by Local User: " & $File & @CRLF)
				;LogWrite("PPS-ProfileMgmt: Phase 2: "& $DocRoot & "\" & $File & "  - Protected by Local User: " & $File)
				Local $Result = _ArrayAdd($ProfileArray, $File)
			ElseIf StringInStr($File,".pps") Then
				ConsoleWrite("  - Profile: " & $DocRoot & "\" & $File & @CRLF & "  - Protected by Domain User: " & $File & @CRLF)
				;LogWrite("PPS-ProfileMgmt: Phase 2: "& $DocRoot & "\" & $File & "  - Protected by Domain User: " & $File)
				Local $Result = _ArrayAdd($ProfileArray, $File)
			Else
				ConsoleWrite( "  - Profile: " & $DocRoot & "\" & $File & @CRLF & "  - Will Be Moved" & @CRLF)

				$ExpireFile = FileOpen($DocRoot & "\" & $File & "\expire.txt", 10)
				$ExpireCalc = $ExpireDays + @YDAY

				ConsoleWrite("  - Profile: Generating Expiration Marker: ")

				If $ExpireCalc > 354 Then
					ConsoleWrite("Pushing to Next Year: ")
					$ExpireDate = @YEAR + 1 & $ExpireDays
				Else
					ConsoleWrite("Using This Year: ")
					$ExpireDate = @YEAR & $ExpireCalc
				EndIf
				ConsoleWrite($ExpireDate & @CRLF)
				FileWrite($ExpireFile,$ExpireDate)
				FileClose($ExpireFile)

				If Not FileExists($Temp) Then
					;LogWrite("PPS-ProfileMgmt: Phase 2: " & $Temp & " was Created")
					DirCreate($Temp)
				EndIf

				DirMove( $DocRoot & "\" & $File, $Temp & "\" & $File, 1)

				ConsoleWrite( "  - "& $File & " Moved To: " & $Temp & "\" & $File & @CRLF)
				LogWrite( "PPS-ProfileMgmt: Phase 2: Profile - " & $DocRoot & "\" & $File & "  Moved To:  " & $Temp & "\" & $File)

			EndIf
		EndIf
		ConsoleWrite(@CRLF)
	EndIf
WEnd
ConsoleWrite("All Done!" & @CRLF)
;MsgBox(1,"Completed", "Press OK to exit")

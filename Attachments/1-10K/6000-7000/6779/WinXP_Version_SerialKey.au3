; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1 beta
; Author:         Thorsten Meger <Thorsten.Meger@gmx.de>
;
; Script Function:
;	Windows XP Version und Serial Key in MsgBox
;
; ----------------------------------------------------------------------------

$objWMIService = objget("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
$colSettings = $objWMIService.ExecQuery("Select * from Win32_OperatingSystem")

For $objOperatingSystem in $colSettings
    $Type = StringMid($objOperatingSystem.Caption, 19)
    $Serial = StringMid($objOperatingSystem.SerialNumber, 1)
    MsgBox(64, 'Ouput of Windows Type and Serial', "Type    : "& $Type & @CRLF & "Serial    : " & $Serial)
Next
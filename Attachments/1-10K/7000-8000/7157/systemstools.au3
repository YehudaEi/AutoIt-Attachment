;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Func Createdby($Str!ke);;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;     msgbox(0, "Createdby()", "Nick 'Str!ke' Kamoen");;
;; EndFunc;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Copyright 2006 © Deepdesigns.nl;; ; ; ; ; ; ; ; ; ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Many Credits To th.meger THANKS ;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ; ; ; ; ; ; ; ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;
#include <Date.au3>;;;
;;;;;;;;;;;;;;;;;;;;;;
;; Vars
$Bin = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "DigitalProductID")
;; Serial And Version Begin
$objWMIService = objget("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
$colSettings = $objWMIService.ExecQuery("Select * from Win32_OperatingSystem")

For $objOperatingSystem in $colSettings
    $Type = StringMid($objOperatingSystem.Caption, 19)
    $Serial = StringMid($objOperatingSystem.SerialNumber, 1)
Next
;; Serial And Version End


;; ;; ;;

while 1
	$tt = ToolTip("System tool v0.1" & @CRLF & "Date: " & _NowDate() & @CRLF & "Time: " & _NowTime() & @CRLF & "Product Code: " & DecodeProductKey($Bin) & @CRLF & "Serial Code: " & $Serial & @CRLF & "OS: " & $Type, 10, 10)
WEnd	
;; Functions


; Product Key Begin
$Bin = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "DigitalProductID")
Func DecodeProductKey($BinaryDPID)
    Local $bKey[15]
    Local $sKey[29]
    Local $Digits[24]
    Local $Value = 0
    Local $hi = 0
    Local $n = 0
    Local $i = 0
    Local $dlen = 29
    Local $slen = 15
    Local $Result
    
    $Digits = StringSplit("BCDFGHJKMPQRTVWXY2346789", "")
    $BinaryDPID = StringMid($BinaryDPID, 105, 30)
    For $i = 1 To 29 Step 2
        $bKey[Int($i / 2) ] = Dec(StringMid($BinaryDPID, $i, 2))
    Next
    For $i = $dlen - 1 To 0 Step - 1
        If Mod(($i + 1), 6) = 0 Then
            $sKey[$i] = "-"
        Else
            $hi = 0
            For $n = $slen - 1 To 0 Step - 1
                $Value = BitOR(BitShift($hi, -8), $bKey[$n])
                $bKey[$n] = Int($Value / 24)
                $hi = Mod($Value, 24)
            Next
            $sKey[$i] = $Digits[$hi + 1]
        EndIf
    Next
    For $i = 0 To 28
        $Result = $Result & $sKey[$i]
    Next
    Return $Result
EndFunc
; Product Key End


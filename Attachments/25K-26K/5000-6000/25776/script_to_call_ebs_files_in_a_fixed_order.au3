;
; AutoIt Version: 3.0
; Language:       English
; Platform:       Win9x/NT
; Author:         Jonathan Bennett (jon@hiddensoft.com)
; Script Author:  Frank Bosco (script@frankbosco.com)
; 				  (with help from Autoit forum members)
;
; Function:
; This simple script will call any number of ebs2 files
; to run in a random order, starting a new one after each
; completes.  The script below expects both this script
; file and your ebs2 files to be in the same directory
; (i.e., folder).  This script also expects to find The
; E-Run executable in the default E-Prime 2.0.8.22 (RC)
; installation location.  For easy application to your
; own purposes, remane your current ebs2 files
; sequentially (i.e., 1.ebs2; 2.ebs2; 3.ebs2).
; Modify this script to accomodate your total number of
; .ebs2 files directly below (i.e., Dim $i, $iMax = 8) -
; change the '8' value to reflect your total.


#include <Array.au3>

;(Number of .ebs2 files -- The line of code below refers to a total of 5 ebs2 files to be run)
Dim $i, $iMax = 5

Dim $FileNameArray[$iMax]
For $x = 0 To UBound($FileNameArray) - 1
    $FileNameArray[$x] = '"' & @WorkingDir & '\' & ($x + 1) & '.ebs2"'
Next

For $i = 1 To $iMax
    $CurrentNumber = Random(0, UBound($FileNameArray) - 1, 1)
    $CurrentName = $FileNameArray[$CurrentNumber]


    _ArrayDelete($FileNameArray, $CurrentNumber)
Next    ;$i
;TEST THE FOLLOWING LINE OF CODE

Run("C:\Program Files\PST\E-Prime 2.0\Program\E-Run.exe /a /m " & '"' & @Workingdir & '\1.ebs2"')

WinWait("E-Run")
WinWaitClose("E-Run")

Run("C:\Program Files\PST\E-Prime 2.0\Program\E-Run.exe /a /m " & '"' & @Workingdir & '\2.ebs2"')

WinWait("E-Run")
WinWaitClose("E-Run")
Run("C:\Program Files\PST\E-Prime 2.0\Program\E-Run.exe /a /m " & '"' & @Workingdir & '\3.ebs2"')

WinWait("E-Run")
WinWaitClose("E-Run")

Run("C:\Program Files\PST\E-Prime 2.0\Program\E-Run.exe /a /m " & '"' & @Workingdir & '\4.ebs2"')

WinWait("E-Run")
WinWaitClose("E-Run")


Run("C:\Program Files\PST\E-Prime 2.0\Program\E-Run.exe /a /m " & '"' & @Workingdir & '\5.ebs2"')

WinWait("E-Run")
WinWaitClose("E-Run")
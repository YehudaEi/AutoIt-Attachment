;;
;; dpdemo.au3
;; Diskpart Automation API demonstrator
;; 
;; Requires diskpart.au3 version 0.21 or greater
;;

#include <Misc.au3>
#include <String.au3>

#include "diskpart.au3"
#include "win32.au3"

Opt("OnExitFunc", "SafeScriptExit")

Global $pid, $version, $runError
Global $hdiv = _StringRepeat( "-", 100 ) & @LF
Global $sdiv = _StringRepeat( "*", 100 ) & @LF

;; -- DEMONSTRATION CODE --------------------------------------------------------------------------

_DiskpartStartConsole( $pid, $version, $runError )
If @error Then
    ConsoleWrite( "ERROR: Failed to start diskpart process." & @LF & _
                  @TAB & "@error    = " & @error & @LF & _
                  @TAB & "@extended = " & @extended & @LF & _
                  @TAB & "$runError = " & $runError & " (GetLastError)" & @LF & _
                  @TAB & "Error msg = " & _Win32FormatMessageFromSystem( $runError ) & @LF )
    Exit 1
EndIf

ConsoleWrite( @LF & "Interacting with Microsoft Diskpart version " & $version & @LF & _
              "through the Diskpart Automation API version " & $__DP_VersionStrings[0] & @LF & @LF )

; reproduce the diskpart 'list disk' command output
If Not ReproduceOutput_ListDisk() Then Exit 1

; reproduce the diskpart 'list volume' command output
If Not ReproduceOutput_ListVolume() Then Exit 1

; for each volume that has an associated disk(s), print its details
If Not Report_VolumesWithDisks() Then Exit 1

; lets do something more interesting. for each disk, list its details then
; its volumes and the partitions that make up each volume
If Not Report_DiskDetails() Then Exit 1

; for each disk, list the full details its partitions - goes one step beyond Report_DiskDetails
If Not Report_VolumePartitionDetails() Then Exit 1

_DiskpartCloseConsole( $pid )
ConsoleWrite( $sdiv & "Microsoft diskpart process termination code was " & _DiskpartTerminationCode() & @LF )
Exit    

;; 
;; For each disk, list the complete details of its partitions (goes one step beyond what Report_DiskDetails does)
;;
Func Report_VolumePartitionDetails()
    
    Local $myDisks, $diskCount, $diskDetails
    Local $myVolumes, $volumeCount
    Local $myPartitions, $partitionCount, $partitionDetails

    $diskCount = _DiskpartListDisks( $pid, $myDisks )
    If @error Then 
        ConsoleWrite( "_DiskpartListDisks failed. RC = " & $diskCount & ", @ERROR = " & @error & ", @EXTENDED = " & @extended & @LF )
        Return 0
    EndIf
    
    For $d = 0 To $diskCount - 1
        _DiskpartSelectDisk( $pid, $myDisks[$d][0] )
        If @error Then 
            ConsoleWrite( "_DiskpartSelectDisk( " & $myDisks[$d][0] & " ) failed. RC = *, @ERROR = " & @error & ", @EXTENDED = " & @extended & @LF )
            Return 0
        EndIf
        
        $volumeCount = _DiskpartDetailDisk( $pid, $diskDetails, $myVolumes )
        If @error Then 
            ConsoleWrite( "_DiskpartDetailDisk( " & $myDisks[$d][0] & " ) failed. RC = " & $volumeCount & ", @ERROR = " & @error & ", @EXTENDED = " & @extended & @LF )
            Return 0
        EndIf
        
        ConsoleWrite( $sdiv & "Details for disk " & $myDisks[$d][0] & " - Including full partition details" & @LF & $sdiv )
        ConsoleWrite( $diskDetails[0] & @LF & _
                      "Disk ID: " & $diskDetails[1] & @LF & _
                      "Type   : " & $diskDetails[2] & @LF & _
                      "Bus    : " & $diskDetails[3] & @LF & _
                      "Target : " & $diskDetails[4] & @LF & _
                      "LUN ID : " & $diskDetails[5] & @LF & @LF )
                      
        If $volumeCount > 0 Then
            ConsoleWrite( StringFormat( "  %-10s  %-3s  %-11s  %-5s  %-10s  %7s  %-9s  %-8s", "Volume ###", "Ltr", "Label", "Fs", "Type", "Size", "Status", "Info" ) & @LF )
            ConsoleWrite( "  ----------  ---  -----------  -----  ----------  -------  ---------  --------" & @LF )
            For $v = 0 To $volumeCount - 1
                ConsoleWrite( StringFormat( "  %-10s  %-3s  %-11s  %-5s  %-10s  %7s  %-9s  %-8s",  _
                                            "Volume " & $myVolumes[$v][0], $myVolumes[$v][1], $myVolumes[$v][2], _
                                            $myVolumes[$v][3], $myVolumes[$v][4], $myVolumes[$v][5], _
                                            $myVolumes[$v][6], $myVolumes[$v][7] ) & @LF )
                                            
                $partitionCount = _DiskpartListPartitionsByVolume( $pid, $myVolumes[$v][0], $myPartitions )
                If @error Then 
                    ConsoleWrite( "_DiskpartListPartitionsByVolume( " & $myVolumes[$v][0] & " ) failed. RC = " & $partitionCount & ", @ERROR = " & @error & ", @EXTENDED = " & @extended & @LF )
                    Return 0
                EndIf
                
                If $partitionCount > 0 Then 
                    
                    For $p = 0 To $partitionCount - 1

                        _DiskpartSelectVolume( $pid, $myVolumes[$v][0] )
                        If @error Then 
                            ConsoleWrite( "_DiskpartSelectVolume( " & $myVolumes[$v][0] & " ) failed. RC = *, @ERROR = " & @error & ", @EXTENDED = " & @extended & @LF )
                            Return 0
                        EndIf
                        
                        _DiskpartSelectPartition( $pid, $myPartitions[$p][0] )
                        If @error Then 
                            ConsoleWrite( "_DiskpartSelectPartition( " & $myPartitions[$p][0] & " ) failed. RC = *, @ERROR = " & @error & ", @EXTENDED = " & @extended & @LF )
                            Return 0
                        EndIf
                        
                        Local $junkVolumes
                        _DiskpartDetailPartition( $pid, $partitionDetails, $junkVolumes )
                        If @error Then 
                            ConsoleWrite( "_DiskpartDetailPartition( " & $myPartitions[$p][0] & " ) failed. RC = *, @ERROR = " & @error & ", @EXTENDED = " & @extended & @LF )
                            Return 0
                        EndIf
                        
                        ConsoleWrite( @LF & @TAB & "  Partition " & $partitionDetails[0] & @LF )
                        ConsoleWrite( @TAB & "  Type  : " & $partitionDetails[1] & @LF )
                        ConsoleWrite( @TAB & "  Hidden: " & $partitionDetails[2] & @LF )
                        ConsoleWrite( @TAB & "  Active: " & $partitionDetails[3] & @LF )

                        ConsoleWrite( StringFormat( @LF & @TAB & "  %-13s  %-16s  %7s  %7s", "Partition ###", "Type", "Size", "Offset" ) & @LF )
                        ConsoleWrite( @TAB & "  -------------  ----------------  -------  -------" & @LF )
                        
                        ConsoleWrite( StringFormat( @TAB & "  %-13s  %-16s  %7s  %7s", _
                                      "Partition " & $myPartitions[$p][0], $myPartitions[$p][1], $myPartitions[$p][2], $myPartitions[$p][3] ) & @LF )
                    Next
                Else
                    ConsoleWrite( @TAB & "No partitions were returned" & @LF )
                EndIf
            Next
        Else
            ConsoleWrite( "No volumes were returned" & @LF )
        EndIf
    Next
   
    Return 1    
EndFunc

;;
;; Calls _DiskpartListVolumes, _DiskpartSelectVolume, and _DiskpartDetailVolume to list
;; only those volumes that have disks associated with them as an alternative to how it
;; could be done with _DiskpartDetailDisk.
;;
Func Report_VolumesWithDisks()
        
    Local $myVolumes, $volumeCount
    Local $myDisks, $diskCount
    
    $volumeCount = _DiskpartListVolumes( $pid, $myVolumes )
    If @error Then 
        ConsoleWrite( "_DiskpartListVolumes failed. RC = " & $volumeCount & ", @ERROR = " & @error & ", @EXTENDED = " & @extended & @LF )
        Return 0
    EndIf
    
    If $volumeCount > 0 Then
        
        For $v = 0 To $volumeCount - 1
            
            _DiskpartSelectVolume( $pid, $myVolumes[$v][0] )
            If @error Then 
                ConsoleWrite( "_DiskpartSelectVolume( " & $myVolumes[$v][0] & " ) failed. RC = *, @ERROR = " & @error & ", @EXTENDED = " & @extended & @LF )
                Return 0
            EndIf
            
            $diskCount = _DiskpartDetailVolume( $pid, $myDisks )
            If @error Then
                ConsoleWrite( "_DiskpartDetailVolume failed. RC = *, @ERROR = " & @error & ", @EXTENDED = " & @extended & @LF )
                Return 0
            EndIf
            
            If $diskCount > 0 Then

                ConsoleWrite( $sdiv & "Volume " & $myVolumes[$v][0] & " has disks:" & @LF & $sdiv )
                ConsoleWrite( StringFormat( "  %-10s  %-3s  %-11s  %-5s  %-10s  %7s  %-9s  %-8s", "Volume ###", "Ltr", "Label", "Fs", "Type", "Size", "Status", "Info" ) & @LF )
                ConsoleWrite( "  ----------  ---  -----------  -----  ----------  -------  ---------  --------" & @LF )
                ConsoleWrite( StringFormat( "  %-10s  %-3s  %-11s  %-5s  %-10s  %7s  %-9s  %-8s",  _
                                            "Volume " & $myVolumes[$v][0], $myVolumes[$v][1], $myVolumes[$v][2], _
                                            $myVolumes[$v][3], $myVolumes[$v][4], $myVolumes[$v][5], _
                                            $myVolumes[$v][6], $myVolumes[$v][7] ) & @LF )

                ConsoleWrite( @LF & StringFormat( @TAB & "  %-8s  %-10s  %-7s  %-7s  Dyn  Gpt", "Disk ###", "Status", "Size", "Free" ) & @LF )
                ConsoleWrite( @TAB & "  --------  ----------  -------  -------  ---  ---" & @LF )

                For $d = 0 To $diskCount - 1
                    ConsoleWrite( StringFormat( @TAB & "  %-8s  %-10s  %7s  %7s  %-3s  %-3s", _
                                                "Disk " & $myDisks[$d][0], $myDisks[$d][1], $myDisks[$d][2], _
                                                $myDisks[$d][3], $myDisks[$d][4], $myDisks[$d][5] ) & @LF )
                                                
                Next
            EndIf
        Next
    Else
        ConsoleWrite( "No volumes were returned" & @LF )
    EndIf
    
    Return 1
EndFunc
;;
;; Calls _DiskpartListDisks and uses the results to reproduce the 'list disk' diskpart output
;;
Func ReproduceOutput_ListDisk()
    
    Local $myDisks, $diskCount
    
    ConsoleWrite( $sdiv & "Executing: list disk" & @LF & $sdiv )
    
    $diskCount = _DiskpartListDisks( $pid, $myDisks )
    If @error Then 
        ConsoleWrite( "_DiskpartListDisks failed. RC = " & $diskCount & ", @ERROR = " & @error & ", @EXTENDED = " & @extended & @LF )
        Return 0
    EndIf
    
    If $diskCount > 0 Then
        ConsoleWrite( StringFormat( "  %-8s  %-10s  %-7s  %-7s  Dyn  Gpt", "Disk ###", "Status", "Size", "Free" ) & @LF )
        ConsoleWrite( "  --------  ----------  -------  -------  ---  ---" & @LF )
        For $n=0 To $diskCount-1
            ConsoleWrite( StringFormat( "  %-8s  %-10s  %7s  %7s  %-3s  %-3s", _
                                        "Disk " & $myDisks[$n][0], $myDisks[$n][1], $myDisks[$n][2], _
                                        $myDisks[$n][3], $myDisks[$n][4], $myDisks[$n][5] ) & @LF )
        Next
    Else
        ConsoleWrite( "No disks were returned" & @LF )
    EndIf
    
    Return 1
EndFunc    
;;
;; Calls _DiskpartListVolumes and uses the results to reproduce the 'list volume' diskpart output
;;
Func ReproduceOutput_ListVolume()
        
    Local $myVolumes, $volumeCount
    
    ConsoleWrite( $sdiv & "Executing: list volume" & @LF & $sdiv )
    
    $volumeCount = _DiskpartListVolumes( $pid, $myVolumes )
    If @error Then 
        ConsoleWrite( "_DiskpartListVolumes failed. RC = " & $volumeCount & ", @ERROR = " & @error & ", @EXTENDED = " & @extended & @LF )
        Return 0
    EndIf
    
    If $volumeCount > 0 Then
        ConsoleWrite( StringFormat( "  %-10s  %-3s  %-11s  %-5s  %-10s  %7s  %-9s  %-8s", "Volume ###", "Ltr", "Label", "Fs", "Type", "Size", "Status", "Info" ) & @LF )
        ConsoleWrite( "  ----------  ---  -----------  -----  ----------  -------  ---------  --------" & @LF )
        For $n=0 To $volumeCount-1
            ConsoleWrite( StringFormat( "  %-10s  %-3s  %-11s  %-5s  %-10s  %7s  %-9s  %-8s",  _
                                        "Volume " & $myVolumes[$n][0], $myVolumes[$n][1], $myVolumes[$n][2], _
                                        $myVolumes[$n][3], $myVolumes[$n][4], $myVolumes[$n][5], _
                                        $myVolumes[$n][6], $myVolumes[$n][7] ) & @LF )
        Next
    Else
        ConsoleWrite( "No volumes were returned" & @LF )
    EndIf
    
    Return 1
EndFunc
;;
;; Uses the following functions:
;; _DiskpartListDisks, _DiskpartSelectDisk, _DiskpartDetailDisk, _DiskpartListPartitionsByVolume
;;
;; To produce a consolidated report of each disk in the system, its volumes, and their partitions.
;;
Func Report_DiskDetails()
    
    Local $myDisks, $diskCount, $diskDetails
    Local $myVolumes, $volumeCount
    Local $myPartitions, $partitionCount

    $diskCount = _DiskpartListDisks( $pid, $myDisks )
    If @error Then 
        ConsoleWrite( "_DiskpartListDisks failed. RC = " & $diskCount & ", @ERROR = " & @error & ", @EXTENDED = " & @extended & @LF )
        Return 0
    EndIf
    
    For $d = 0 To $diskCount - 1
        _DiskpartSelectDisk( $pid, $myDisks[$d][0] )
        If @error Then 
            ConsoleWrite( "_DiskpartSelectDisk( " & $myDisks[$d][0] & " ) failed. RC = *, @ERROR = " & @error & ", @EXTENDED = " & @extended & @LF )
            Return 0
        EndIf
        
        $volumeCount = _DiskpartDetailDisk( $pid, $diskDetails, $myVolumes )
        If @error Then 
            ConsoleWrite( "_DiskpartDetailDisk( " & $myDisks[$d][0] & " ) failed. RC = " & $volumeCount & ", @ERROR = " & @error & ", @EXTENDED = " & @extended & @LF )
            Return 0
        EndIf
        
        ConsoleWrite( $sdiv & "Details for disk " & $myDisks[$d][0] & @LF & $sdiv )
        ConsoleWrite( $diskDetails[0] & @LF & _
                      "Disk ID: " & $diskDetails[1] & @LF & _
                      "Type   : " & $diskDetails[2] & @LF & _
                      "Bus    : " & $diskDetails[3] & @LF & _
                      "Target : " & $diskDetails[4] & @LF & _
                      "LUN ID : " & $diskDetails[5] & @LF & @LF )
                      
        If $volumeCount > 0 Then
            ConsoleWrite( StringFormat( "  %-10s  %-3s  %-11s  %-5s  %-10s  %7s  %-9s  %-8s", "Volume ###", "Ltr", "Label", "Fs", "Type", "Size", "Status", "Info" ) & @LF )
            ConsoleWrite( "  ----------  ---  -----------  -----  ----------  -------  ---------  --------" & @LF )
            For $v = 0 To $volumeCount - 1
                ConsoleWrite( StringFormat( "  %-10s  %-3s  %-11s  %-5s  %-10s  %7s  %-9s  %-8s",  _
                                            "Volume " & $myVolumes[$v][0], $myVolumes[$v][1], $myVolumes[$v][2], _
                                            $myVolumes[$v][3], $myVolumes[$v][4], $myVolumes[$v][5], _
                                            $myVolumes[$v][6], $myVolumes[$v][7] ) & @LF )
                                            
                $partitionCount = _DiskpartListPartitionsByVolume( $pid, $myVolumes[$v][0], $myPartitions )
                If @error Then 
                    ConsoleWrite( "_DiskpartListPartitionsByVolume( " & $myVolumes[$v][0] & " ) failed. RC = " & $partitionCount & ", @ERROR = " & @error & ", @EXTENDED = " & @extended & @LF )
                    Return 0
                EndIf

                If $partitionCount > 0 Then 
                    ConsoleWrite( StringFormat( @LF & @TAB & "  %-13s  %-16s  %7s  %7s", "Partition ###", "Type", "Size", "Offset" ) & @LF )
                    ConsoleWrite( @TAB & "  -------------  ----------------  -------  -------" & @LF )
                    For $p = 0 To $partitionCount - 1
                        ConsoleWrite( StringFormat( @TAB & "  %-13s  %-16s  %7s  %7s", _
                                      "Partition " & $myPartitions[$p][0], $myPartitions[$p][1], $myPartitions[$p][2], $myPartitions[$p][3] ) & @LF )
                    Next
                Else
                    ConsoleWrite( @TAB & "No partitions were returned" & @LF )
                EndIf
            Next
        Else
            ConsoleWrite( "No volumes were returned" & @LF )
        EndIf
    Next
   
    Return 1    
EndFunc

;; -- END DEMONSTRATION CODE ----------------------------------------------------------------------

;;
;; Trap script exit to ensure we don't leave a hidden diskpart process running
;;
Func SafeScriptExit()
    If Int($pid) And ProcessExists( $pid ) Then _DiskpartCloseConsole( $pid )
EndFunc


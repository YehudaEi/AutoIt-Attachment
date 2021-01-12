;;
;; diskpart.au3
;;
;; Automation code for the Microsoft diskpart utility allowing you
;; to programmatically interact with the console while its running.
;; 
;; Tested on:
;;      Windows XP Service Pack 2
;;      TODO: Windows Server 2003 SP1
;;      TODO: Windows PE 1.6 (W2K3SP1)
;;      TODO: Windows PE 2.0
;;
;; Version 0.20, 7 Jan 2007 by Michael Roach
;; Send bug reports and comments to dem3tre@gmail.com
;;
;; -+ History +--------------------------------------------------------------
;;
;; 1/07/2007   0.20 Support for all non-destructive disk commands
;; 1/09/2007   0.21 Added _DiskpartDetailVolume, _DiskpartDetailPartition
;; --------------------------------------------------------------------------
;; 
;; Process commands:
;;      _DiskpartStartConsole......Begin an interactive diskpart session
;;      _DiskpartCloseConsole......Terminate an interactive diskpart session
;;      _DiskpartTerminationCode...Returns the last recorded diskpart process termination code
;; 
;; Focus commands:
;;      _DiskpartSelectDisk.........Sets focus to the given disk
;;      _DiskpartSelectVolume.......Sets focus to the given volume
;;      _DiskpartSelectPartition....Sets focus to the given partition
;;      _DiskpartCurrentDisk........Returns the current in-focus disk
;;      _DiskpartCurrentVolume......Returns the current in-focus volume
;;      _DiskpartCurrentPartition...Returns the current in-focus partition
;; 
;; Information commands:
;;      _DiskpartListDisks................Lists all fixed disks recognized by diskpart
;;      _DiskpartListVolumes..............Lists all volumes (including cd/dvd-rom and removeable)
;;      _DiskpartListPartitions...........Lists all partitions for the in-focus disk or volume
;;      _DiskpartListPartitionsByDisk.....Sets focus to the given disk and lists its partitions
;;      _DiskpartListPartitionsByVolume...Sets focus to the given volume and lists its partitions
;;      _DiskpartDetailDisk...............Obtains detailed information for the in-focus disk
;;      _DiskpartDetailVolume.............Obtains detailed information for the in-focus volume
;;      _DiskpartDetailPartition..........Obtains detailed information for the in-focus partition
;; 
;; Management commands:
;;      None yet
;;
;; Helpful functions:
;;TODO  _DiskpartFindDiskByDiskID.........Returns the index of the disk with matching Disk ID (ie., 1CCE2CD3) as returned by the detail command
;;TODO  _DiskpartFindDisksByName..........Returns an array of disks that match the given name (ie., Maxtor OneTouch IIIs USB Device) as returned by the detail command
;;TODO  _DiskpartFindDisksByType..........Returns an array of disks of the given type (ie., USB, IDE, ...) as returned by the detail command
;;

#include-once
#include <Constants.au3>
#include <Misc.au3>
#include "win32.au3"

Global $__DP_VersionStrings[4] = [ '0.21', 0, 21, '2007/01/09' ]

Global Enum _; diskaprt automation api errors
        $_DP_ErrorCode_NoError                  = 0, _
        $_DP_ErrorCode_UnknownFailure           = 1, _
        $_DP_ErrorCode_InvalidProcessID         = 2, _
        $_DP_ErrorCode_UnexpectedTermination    = 3, _
        $_DP_ErrorCode_StdoutStreamError        = 4, _
        $_DP_ErrorCode_StdinStreamError         = 5, _
        $_DP_ErrorCode_UnexpectedCommandOutput  = 6, _
        $_DP_ErrorCode_UnrecognizedCommand      = 7, _
        $_DP_ErrorCode_InvalidTargetFocus       = 8, _
        $_DP_ErrorCode_InvalidDiskNumber        = 9, _
        $_DP_ErrorCode_InvalidVolumeNumber      = 10, _
        $_DP_ErrorCode_InvalidPartitionNumber   = 11, _
        $_DP_ErrorCode_ConsoleStartFailed       = 12

Global Enum _; errorcodes reported by diskpart
        $_DP_ProcessExitCode_NoError            = 0, _
        $_DP_ProcessExitCode_FatalException     = 1, _
        $_DP_ProcessExitCode_InvalidCmdLine     = 2, _
        $_DP_ProcessExitCode_FileOpenFailed     = 3, _
        $_DP_ProcessExitCode_ServiceError       = 4, _
        $_DP_ProcessExitCode_SyntaxError        = 5, _
        $_DP_ProcessExitCode_CouldNotRetrieveExitCode = 65535
        
Global $__DP_InternalAPI_ErrorCode = 0, $__DP_InternalAPI_ExtendedErrorCode = 0, _
       $__DP_InternalAPI_ProcessTerminationCode = $_DP_ProcessExitCode_CouldNotRetrieveExitCode


;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~ Diskpart Automation API
;~ The following functions comprise the user callable portion of the automation api
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;;
;; Function     : _DiskpartTerminationCode
;; Description  : Returns the last recorded diskpart process termination code
;; Parameters   : None
;; Returns      : Integer - see _DP_ProcessExitCode_ enumeration for possible values
;; Remarks      : Wraps $__DP_InternalAPI_ProcessTerminationCode 
;;
Func _DiskpartTerminationCode()
    
    If Not IsInt( $__DP_InternalAPI_ProcessTerminationCode ) Then 
        $__DP_InternalAPI_ProcessTerminationCode = $_DP_ProcessExitCode_CouldNotRetrieveExitCode
    EndIf
    
    Return _Iif( $__DP_InternalAPI_ProcessTerminationCode = $WIN32_STILL_ACTIVE, _
                 $_DP_ProcessExitCode_CouldNotRetrieveExitCode, _
                 $__DP_InternalAPI_ProcessTerminationCode )
EndFunc
;;
;; Function     : _DiskpartStartConsole
;; Description  : Launches the Microsoft diskpart interactive console
;; Parameters   : $pid      : [out] running diskpart process identifier
;;                $version  : [out] diskpart version (ie., 5.1.3565)
;;                $runerror : [out] optional: if present and AutoIt Run should fail to start
;;                            the diskpart process it will contain the GetLastError() code
;; Returns      : Success   : 1
;;                Failure   : 0
;;                @ERROR    : 0  = Success
;;                          : 1  = Failure
;;                @EXTENDED : 2  = $_DP_ErrorCode_InvalidProcessID
;;                          : 3  = $_DP_ErrorCode_UnexpectedTermination
;;                          : 4  = $_DP_ErrorCode_StdoutStreamError
;;                          : 5  = $_DP_ErrorCode_StdinStreamError
;;                          : 7  = $_DP_ErrorCode_UnrecognizedCommand
;;                          : 12 = $_DP_ErrorCode_ConsoleStartFailed (if $runerror was passed it now contains GetLastError())
;; Remarks      : The console is left at the first DISKPART> prompt on success; if there
;;                are any problems the process is terminated before returning.
;;
Func _DiskpartStartConsole( ByRef $pid, ByRef $version, $runerror = Default )

    If Not $runerror = Default Then $runerror = 0

    $version = ""
    $pid     = Run( 'diskpart.exe', @SystemDir, @SW_HIDE, $STDIN_CHILD+$STDOUT_CHILD )
    
    If @error Then 
        If Not $runerror = Default Then $runerror = @extended
        Return __dpSetError( 1, $_DP_ErrorCode_ConsoleStartFailed, 0 )
    EndIf
    
    Local $_output, $_rc, _
          $_pHandle = _Win32OpenProcess( $pid )

    __dpIssueCommand( $pid, "", $_output )
    If @error Then
        ;
        ; process started but something else went wrong
        ;
        If ProcessExists( $pid ) Then 
            ProcessClose( $pid )        
            ProcessWaitClose( $pid )
        EndIf
        
        Return __dpSafeReturn( 1, $_pHandle )
    EndIf
    ;
    ; Success, try and get the version number from the header
    ;
    Local $_m = StringRegExp( $_output, "(?i)version[ \t]+(\d+\.\d+\.\d+)", 1 )
    If Not @error Then $version = $_m[0]
                    
    Return __dpSafeReturn( __dpSetError( 0, 0, 1 ), $_pHandle )
EndFunc
;;
;; Function     : _DiskpartCloseConsole
;; Description  : Attempts to gracefully exit the diskpart process; failing that forcefully closes it
;; Parameters   : $pid      : [in] running diskpart process identifier
;; Returns      : Success   : 1
;;                Failure   : 0
;;                @ERROR    : 0  = Success
;;                          : 1  = Failure
;;                @EXTENDED : 2  = $_DP_ErrorCode_InvalidProcessID
;;
Func _DiskpartCloseConsole( $pid )

    If Not ProcessExists( $pid ) Then Return __dpSetError( 1, $_DP_ErrorCode_InvalidProcessID, 0 )
    
    Local $_output, $_pHandle = _Win32OpenProcess( $pid )
    Local Const $ExitCommand = 'exit' & @CRLF
    
    __dpIssueCommand( $pid, $ExitCommand, $_output )
    If @error And ProcessExists( $pid ) Then ProcessClose( $pid )
    
    If Not ProcessWaitClose( $pid, 60 ) Then    ; give it 60 seconds to close gracefully
        ProcessClose( $pid )
        ProcessWaitClose( $pid )
    EndIf
    
    Return __dpSafeReturn( __dpSetError( 0, 0, 1 ), $_pHandle )
EndFunc
;;
;; Function     : _DiskpartListDisks
;; Description  : Executes the 'list disk' command. 
;; Parameters   : $pid      : [in]  running diskpart process identifier
;;                $disks    : [out] array of disks and their attributes - see remarks below
;; Returns      : Success   : number of disks returned in $disks
;;                @ERROR    : 0  = Success
;;                          : 1  = Failure
;;                @EXTENDED : 1  = $_DP_ErrorCode_UnknownFailure (StringSplit failed)
;;                          : 2  = $_DP_ErrorCode_InvalidProcessID
;;                          : 3  = $_DP_ErrorCode_UnexpectedTermination
;;                          : 4  = $_DP_ErrorCode_StdoutStreamError
;;                          : 5  = $_DP_ErrorCode_StdinStreamError
;;                          : 6  = $_DP_ErrorCode_UnexpectedCommandOutput
;;                          : 7  = $_DP_ErrorCode_UnrecognizedCommand
;; Remarks      : If successful $disks will contain the following:
;;                $disks[][0] = Disk ###
;;                $disks[][1] = Status
;;                $disks[][2] = Size
;;                $disks[][3] = Free
;;                $disks[][4] = Dyn
;;                $disks[][5] = Gpt
;;
Func _DiskpartListDisks( $pid, ByRef $disks )
    
    If Not ProcessExists( $pid ) Then Return __dpSetError( 1, $_DP_ErrorCode_InvalidProcessID, 0 )

    Local Const $ListDiskCommand = 'list disk' & @CRLF
    Local $emptyDiskArray[1][6] = [["","","","","",""]]
    
    Local $_output = "", _
          $_pHandle = _Win32OpenProcess( $pid )
    
    __dpIssueCommand( $pid, $ListDiskCommand, $_output )
    If @error Then 
        $disks = $emptyDiskArray
        Return __dpSafeReturn( __dpSetError( @error, @extended, 0 ), $_pHandle )
    EndIf

    Local $_outputLines, $_okayExtractData = False
    Local $_diskCount = 0, _
          $_tmpDiskArray[63][6] = [["","","","","",""]]
          
    $_outputLines = StringSplit( $_output, @LF )
    If Not @error Then
        
        For $idx = 1 To $_outputLines[0]
            
            If StringStripWS( $_outputLines[$idx], 3 ) = "" Or _
               StringInStr( $_outputLines[$idx], "diskpart>" ) Then ContinueLoop
            
            If Not $_okayExtractData Then
                
                If StringRegExp( $_outputLines[$idx], "(?i)disk ###[ ]+status[ ]+size[ ]+free[ ]+dyn[ ]+gpt", 0 ) Then
                    If $idx + 1 <= $_outputLines[0] Then
                        $_okayExtractData = True
                        $idx += 1
                    EndIf
                EndIf
                
            Else
                
                ;  Disk ###  Status      Size     Free     Dyn  Gpt
                ;  --------  ----------  -------  -------  ---  ---
                ;12345678901234567890123456789012345678901234567890123456789012345678901234567890
                ;         1         2         3         4         5         6         7         8  
                
                $_tmpDiskArray[ $_diskCount ][0] = StringStripWS( StringMid( $_outputLines[$idx],  8,  3 ), 3 )  ; Disk ###
                $_tmpDiskArray[ $_diskCount ][1] = StringStripWS( StringMid( $_outputLines[$idx], 13, 10 ), 3 )  ; Status
                $_tmpDiskArray[ $_diskCount ][2] = StringStripWS( StringMid( $_outputLines[$idx], 25,  7 ), 3 )  ; Size
                $_tmpDiskArray[ $_diskCount ][3] = StringStripWS( StringMid( $_outputLines[$idx], 34,  7 ), 3 )  ; Free
                $_tmpDiskArray[ $_diskCount ][4] = StringStripWS( StringMid( $_outputLines[$idx], 43,  3 ), 3 )  ; Dyn
                $_tmpDiskArray[ $_diskCount ][5] = StringStripWS( StringMid( $_outputLines[$idx], 48,  3 ), 3 )  ; Gpt
  
                $_diskCount += 1
            EndIf
        Next
        
        $disks = $emptyDiskArray
    
        If $_okayExtractData Then
            If $_diskCount > 0 Then
                ReDim $_tmpDiskArray[ $_diskCount ][6]
                $disks = $_tmpDiskArray
            EndIf
        
            Return __dpSafeReturn( __dpSetError( 0, 0, $_diskCount ), $_pHandle )
        Else
            Return __dpSafeReturn( __dpSetError( 1, $_DP_ErrorCode_UnexpectedCommandOutput, 0 ), $_pHandle )
        EndIf
    EndIf
    
    Return __dpSafeReturn( __dpSetError( 1, $_DP_ErrorCode_UnknownFailure, 0 ), $_pHandle )
EndFunc
;;
;; Function     : _DiskpartListVolumes
;; Description  : Executes a 'list volume' command. 
;; Parameters   : $pid      : [in]  running diskpart process identifier
;;                $volumes  : [out] array of volumes and their attributes - see remarks below
;; Returns      : Success   : number of volumes in $volumes
;;                @EXTENDED : 1  = $_DP_ErrorCode_UnknownFailure (StringSplit failed)
;;                          : 2  = $_DP_ErrorCode_InvalidProcessID
;;                          : 3  = $_DP_ErrorCode_UnexpectedTermination
;;                          : 4  = $_DP_ErrorCode_StdoutStreamError
;;                          : 5  = $_DP_ErrorCode_StdinStreamError
;;                          : 6  = $_DP_ErrorCode_UnexpectedCommandOutput
;;                          : 7  = $_DP_ErrorCode_UnrecognizedCommand
;; Remarks      : If successful $volumes will contain the following:
;;                $volumes[][0] = Volume ###
;;                $volumes[][1] = Letter
;;                $volumes[][2] = Label
;;                $volumes[][3] = Filesystem
;;                $volumes[][4] = Type
;;                $volumes[][5] = Size
;;                $volumes[][6] = Status
;;                $volumes[][7] = Info
;;
Func _DiskpartListVolumes( $pid, ByRef $volumes )
    
    If Not ProcessExists( $pid ) Then Return __dpSetError( 1, $_DP_ErrorCode_InvalidProcessID, 0 )

    Local Const $ListVolumeCommand = 'list volume' & @CRLF
    Local $emptyVolumeArray[1][8] = [["","","","","","","",""]]
    
    Local $_output = "", _
          $_pHandle = _Win32OpenProcess( $pid )
    
    __dpIssueCommand( $pid, $ListVolumeCommand, $_output )
    If @error Then 
        $volumes = $emptyVolumeArray
        Return __dpSafeReturn( __dpSetError( @error, @extended, 0 ), $_pHandle )
    EndIf

    Local $_outputLines, $_okayExtractData = False
    Local $_volumeCount = 0, _
          $_tmpVolumeArray[63][8] = [["","","","","","","",""]]
          
    $_outputLines = StringSplit( $_output, @LF )
    If Not @error Then
        
        For $idx = 1 To $_outputLines[0]
            
            If StringStripWS( $_outputLines[$idx], 3 ) = "" Or _
               StringInStr( $_outputLines[$idx], "diskpart>" ) Then ContinueLoop
            
            If Not $_okayExtractData Then
                
                If StringRegExp( $_outputLines[$idx], "(?i)volume ###[ ]+ltr[ ]+label[ ]+fs[ ]+type[ ]+size[ ]+status[ ]+info", 0 ) Then
                    If $idx + 1 <= $_outputLines[0] Then
                        $_okayExtractData = True
                        $idx += 1
                    EndIf
                EndIf
                
            Else
                
                ;  Volume ###  Ltr  Label        Fs     Type        Size     Status     Info
                ;  ----------  ---  -----------  -----  ----------  -------  ---------  --------                    
                ;12345678901234567890123456789012345678901234567890123456789012345678901234567890
                ;         1         2         3         4         5         6         7         8  

                $_tmpVolumeArray[ $_volumeCount ][0] = StringStripWS( StringMid( $_outputLines[$idx], 10, 3  ), 3 )  ; Volumn ###
                $_tmpVolumeArray[ $_volumeCount ][1] = StringStripWS( StringMid( $_outputLines[$idx], 15, 3  ), 3 )  ; Letter
                $_tmpVolumeArray[ $_volumeCount ][2] = StringStripWS( StringMid( $_outputLines[$idx], 20, 11 ), 3 )  ; Label
                $_tmpVolumeArray[ $_volumeCount ][3] = StringStripWS( StringMid( $_outputLines[$idx], 33, 5  ), 3 )  ; Filesystem
                $_tmpVolumeArray[ $_volumeCount ][4] = StringStripWS( StringMid( $_outputLines[$idx], 40, 10 ), 3 )  ; Type
                $_tmpVolumeArray[ $_volumeCount ][5] = StringStripWS( StringMid( $_outputLines[$idx], 52, 7  ), 3 )  ; Size
                $_tmpVolumeArray[ $_volumeCount ][6] = StringStripWS( StringMid( $_outputLines[$idx], 61, 9  ), 3 )  ; Status
                $_tmpVolumeArray[ $_volumeCount ][7] = StringStripWS( StringMid( $_outputLines[$idx], 72, 8  ), 3 )  ; Info
  
                $_volumeCount += 1
            EndIf
        Next
        
        $volumes = $emptyVolumeArray
    
        If $_okayExtractData Then
            If $_volumeCount > 0 Then
                ReDim $_tmpVolumeArray[ $_volumeCount ][8]
                $volumes = $_tmpVolumeArray
            EndIf
        
            Return __dpSafeReturn( __dpSetError( 0, 0, $_volumeCount ), $_pHandle )
        Else
            Return __dpSafeReturn( __dpSetError( 1, $_DP_ErrorCode_UnexpectedCommandOutput, 0 ), $_pHandle )
        EndIf
    EndIf
    
    Return __dpSafeReturn( __dpSetError( 1, $_DP_ErrorCode_UnknownFailure, 0 ), $_pHandle )
EndFunc
;;
;; Function     : _DiskpartListPartitionsByDisk
;; Description  : Sets the focus to the given disk and executes a 'list partition' command
;; Parameters   : $pid          : [in]  running diskpart process identifier
;;                $disk         : [in]  disk id returned by _DiskpartListDisks
;;                $partitions   : [out] array of partitions on the given disk and their attributes - see remarks below
;; Returns      : Success   : number of partitions in $partitions
;;                @ERROR    : 0  = Success
;;                          : 1  = Failure
;;                @EXTENDED : 1  = $_DP_ErrorCode_UnknownFailure (StringSplit failed)
;;                          : 2  = $_DP_ErrorCode_InvalidProcessID
;;                          : 3  = $_DP_ErrorCode_UnexpectedTermination
;;                          : 4  = $_DP_ErrorCode_StdoutStreamError
;;                          : 5  = $_DP_ErrorCode_StdinStreamError
;;                          : 6  = $_DP_ErrorCode_UnexpectedCommandOutput
;;                          : 7  = $_DP_ErrorCode_UnrecognizedCommand
;;                          : 9  = $_DP_ErrorCode_InvalidDiskNumber
;; Remarks      : If successful $partitions will contain the following:
;;                $partitions[][0] = Partition ###
;;                $partitions[][1] = Type
;;                $partitions[][2] = Size
;;                $partitions[][3] = Offset
;;
Func _DiskpartListPartitionsByDisk( $pid, $disk, ByRef $partitions )
    
    _DiskpartSelectDisk( $pid, $disk )
    If @error Then Return __dpSetError( @error, @extended, 0 )
    
    Local $_dcount = _DiskpartListPartitions( $pid, $partitions )
    Return __dpSetError( @error, @extended, $_dcount )
EndFunc
;;
;; Function     : _DiskpartListPartitionsByVolume
;; Description  : Sets the focus to the given volume and executes a 'list partition' command
;; Parameters   : $pid          : [in]  running diskpart process identifier
;;                $volume       : [in]  volume id returned by _DiskpartListVolumes
;;                $partitions   : [out] array of partitions on the given volume and their attributes - see remarks below
;; Returns      : Success   : number of partitions in $partitions
;;                @ERROR    : 0  = Success
;;                          : 1  = Failure
;;                @EXTENDED : 1  = $_DP_ErrorCode_UnknownFailure (StringSplit failed)
;;                          : 2  = $_DP_ErrorCode_InvalidProcessID
;;                          : 3  = $_DP_ErrorCode_UnexpectedTermination
;;                          : 4  = $_DP_ErrorCode_StdoutStreamError
;;                          : 5  = $_DP_ErrorCode_StdinStreamError
;;                          : 6  = $_DP_ErrorCode_UnexpectedCommandOutput
;;                          : 7  = $_DP_ErrorCode_UnrecognizedCommand
;;                          : 10 = $_DP_ErrorCode_InvalidVolumeNumber
;; Remarks      : If successful $partitions will contain the following:
;;                $partitions[][0] = Partition ###
;;                $partitions[][1] = Type
;;                $partitions[][2] = Size
;;                $partitions[][3] = Offset
;;
Func _DiskpartListPartitionsByVolume( $pid, $volume, ByRef $partitions )
    
    _DiskpartSelectVolume( $pid, $volume )
    If @error Then Return __dpSetError( @error, @extended, 0 )
    
    Local $_pcount = _DiskpartListPartitions( $pid, $partitions )
    Return __dpSetError( @error, @extended, $_pcount )
EndFunc
;;
;; Function     : _DiskpartListPartitions
;; Description  : Executes a 'list partition' command against the current focus
;; Parameters   : $pid          : [in]  running diskpart process identifier
;;                $partitions   : [out] array of partitions on the given volume and their attributes - see remarks below
;; Returns      : Success   : number of partitions in $partitions
;;                @ERROR    : 0  = Success
;;                          : 1  = Failure
;;                @EXTENDED : 1  = $_DP_ErrorCode_UnknownFailure (StringSplit failed)
;;                          : 2  = $_DP_ErrorCode_InvalidProcessID
;;                          : 3  = $_DP_ErrorCode_UnexpectedTermination
;;                          : 4  = $_DP_ErrorCode_StdoutStreamError
;;                          : 5  = $_DP_ErrorCode_StdinStreamError
;;                          : 6  = $_DP_ErrorCode_UnexpectedCommandOutput
;;                          : 7  = $_DP_ErrorCode_UnrecognizedCommand
;; Remarks      : If successful $partitions will contain the following:
;;                $partitions[][0] = Partition ###
;;                $partitions[][1] = Type
;;                $partitions[][2] = Size
;;                $partitions[][3] = Offset
;;
Func _DiskpartListPartitions( $pid, ByRef $partitions )
    
    If Not ProcessExists( $pid ) Then Return __dpSetError( 1, $_DP_ErrorCode_InvalidProcessID, 0 )

    Local Const $ListPartitionCommand = 'list partition' & @CRLF
    Local $emptyPartitionArray[1][4] = [["","","",""]]
    
    Local $_output = "", _
          $_pHandle = _Win32OpenProcess( $pid )
    
    __dpIssueCommand( $pid, $ListPartitionCommand, $_output )
    If @error Then 
        $disks = $emptyPartitionArray
        Return __dpSafeReturn( __dpSetError( @error, @extended, 0 ), $_pHandle )
    EndIf
    
    ;
    ; did command fail because the focus wan't set?
    ;
    If StringRegExp( $_output, "(?i)select a disk and try again", 0 ) Then
        $disks = $emptyPartitionArray
        Return __dpSafeReturn( __dpSetError( 1, $_DP_ErrorCode_InvalidTargetFocus, 0 ), $_pHandle )
    EndIf
    
    ;
    ; looks like it worked
    ;
    Local $_outputLines, $_okayExtractData = False
    Local $_partitionCount = 0, _
          $_tmpPartitionArray[63][4] = [["","","",""]]
          
    $_outputLines = StringSplit( $_output, @LF )
    If Not @error Then
        
        For $idx = 1 To $_outputLines[0]
            
            If StringStripWS( $_outputLines[$idx], 3 ) = "" Or _
               StringInStr( $_outputLines[$idx], "diskpart>" ) Then ContinueLoop
            
            If Not $_okayExtractData Then
                
                If StringRegExp( $_outputLines[$idx], "(?i)partition ###[ ]+type[ ]+size[ ]+offset", 0 ) Then
                    If $idx + 1 <= $_outputLines[0] Then
                        $_okayExtractData = True
                        $idx += 1
                    EndIf
                EndIf
                
            Else
                
                ;  Partition ###  Type              Size     Offset
                ;  -------------  ----------------  -------  -------
                ;12345678901234567890123456789012345678901234567890123456789012345678901234567890
                ;         1         2         3         4         5         6         7         8  

                $_tmpPartitionArray[ $_partitionCount ][0] = StringStripWS( StringMid( $_outputLines[$idx], 13,  3 ), 3 )  ; Partition ###
                $_tmpPartitionArray[ $_partitionCount ][1] = StringStripWS( StringMid( $_outputLines[$idx], 18, 16 ), 3 )  ; Type
                $_tmpPartitionArray[ $_partitionCount ][2] = StringStripWS( StringMid( $_outputLines[$idx], 36,  7 ), 3 )  ; Size
                $_tmpPartitionArray[ $_partitionCount ][3] = StringStripWS( StringMid( $_outputLines[$idx], 45,  7 ), 3 )  ; Offset
  
                $_partitionCount += 1
            EndIf
        Next
        
        $partitions = $emptyPartitionArray
    
        If $_okayExtractData Then
            If $_partitionCount > 0 Then
                ReDim $_tmpPartitionArray[ $_partitionCount ][6]
                $partitions = $_tmpPartitionArray
            EndIf
        
            Return __dpSafeReturn( __dpSetError( 0, 0, $_partitionCount ), $_pHandle )
        Else
            Return __dpSafeReturn( __dpSetError( 1, $_DP_ErrorCode_UnexpectedCommandOutput, 0 ), $_pHandle )
        EndIf
    EndIf
    
    Return __dpSafeReturn( __dpSetError( 1, $_DP_ErrorCode_UnknownFailure, 0 ), $_pHandle )
EndFunc
;;
;; Function     : _DiskpartSelectDisk
;; Description  : Sets the focus to the given disk id as returned from _DiskpartListDisks
;; Parameters   : $pid          : [in]  running diskpart process identifier
;;                $disk         : [in]  disk id returned by _DiskpartListDisks
;; Returns      : Success   : Disk with focus
;;                @ERROR    : 0  = Success
;;                          : 1  = Failure
;;                @EXTENDED : 2  = $_DP_ErrorCode_InvalidProcessID
;;                          : 3  = $_DP_ErrorCode_UnexpectedTermination
;;                          : 4  = $_DP_ErrorCode_StdoutStreamError
;;                          : 5  = $_DP_ErrorCode_StdinStreamError
;;                          : 6  = $_DP_ErrorCode_UnexpectedCommandOutput
;;                          : 7  = $_DP_ErrorCode_UnrecognizedCommand
;;                          : 9  = $_DP_ErrorCode_InvalidDiskNumber
;;
Func _DiskpartSelectDisk( $pid, $disk )
    
    If Not ProcessExists( $pid ) Then Return __dpSetError( 1, $_DP_ErrorCode_InvalidProcessID, 0 )

    Local Const $SelectDiskCommand = 'select disk ' & $disk & @CRLF
    Local $_output = "", _
          $_pHandle = _Win32OpenProcess( $pid )
    
    __dpIssueCommand( $pid, $SelectDiskCommand, $_output )
    If @error Then Return __dpSafeReturn( __dpSetError( @error, @extended, 0 ), $_pHandle )
    
    ;
    ; did we fail with an invalid disk id?
    ;
    If StringRegExp( $_output, "(?i)disk you specified is not valid", 0 ) Then
        Return __dpSafeReturn( __dpSetError( 1, $_DP_ErrorCode_InvalidDiskNumber, 0 ), $_pHandle )
    EndIf
    ;
    ; one last check to make sure it worked
    ;
    If Not StringRegExp( $_output, "(?i)disk \d+ is now the selected disk", 0 ) Then
        Return __dpSafeReturn( __dpSetError( 1, $_DP_ErrorCode_InvalidDiskNumber, 0 ), $_pHandle )
    EndIf
    ;
    ; sweet success
    ;
    Return __dpSafeReturn( __dpSetError( 0, 0, $disk ), $_pHandle )
EndFunc
;;
;; Function     : _DiskpartCurrentDisk
;; Description  : Returns the current in-focus disk
;; Parameters   : $pid      : [in]  running diskpart process identifier
;; Returns      : Success   : Disk with focus
;;                @ERROR    : 0  = Success
;;                          : 1  = Failure
;;                @EXTENDED : 2  = $_DP_ErrorCode_InvalidProcessID
;;                          : 3  = $_DP_ErrorCode_UnexpectedTermination
;;                          : 4  = $_DP_ErrorCode_StdoutStreamError
;;                          : 5  = $_DP_ErrorCode_StdinStreamError
;;                          : 6  = $_DP_ErrorCode_UnexpectedCommandOutput
;;                          : 7  = $_DP_ErrorCode_UnrecognizedCommand
;;                          : 9  = $_DP_ErrorCode_InvalidDiskNumber
;; Remarks      : @error = 9 if there is no current in-focus disk
;;
Func _DiskpartCurrentDisk( $pid )
    
    If Not ProcessExists( $pid ) Then Return __dpSetError( 1, $_DP_ErrorCode_InvalidProcessID, 0 )

    Local Const $SelectDiskCommand = 'select disk' & @CRLF
    Local $_output = "", _
          $_pHandle = _Win32OpenProcess( $pid )
    
    __dpIssueCommand( $pid, $SelectDiskCommand, $_output )
    If @error Then Return __dpSafeReturn( __dpSetError( @error, @extended, 0 ), $_pHandle )
    
    Local $_m = StringRegExp( $_output, "(?i)disk (\d+) is now the selected disk", 1 )
    If @error Then Return __dpSafeReturn( __dpSetError( 1, $_DP_ErrorCode_InvalidDiskNumber, 0 ), $_pHandle )
    ;
    ; sweet success
    ;
    Return __dpSafeReturn( __dpSetError( 0, 0, $_m[0] ), $_pHandle )
EndFunc
;;
;; Function     : _DiskpartSelectVolume
;; Description  : Sets the focus to the given volume id as returned by _DiskpartListVolumes
;; Parameters   : $pid          : [in]  running diskpart process identifier
;;                $volume       : [in]  volume id returned by _DiskpartListVolumes
;; Returns      : Success   : Volume with focus
;;                @ERROR    : 0  = Success
;;                          : 1  = Failure
;;                @EXTENDED : 2  = $_DP_ErrorCode_InvalidProcessID
;;                          : 3  = $_DP_ErrorCode_UnexpectedTermination
;;                          : 4  = $_DP_ErrorCode_StdoutStreamError
;;                          : 5  = $_DP_ErrorCode_StdinStreamError
;;                          : 6  = $_DP_ErrorCode_UnexpectedCommandOutput
;;                          : 7  = $_DP_ErrorCode_UnrecognizedCommand
;;                          : 10 = $_DP_ErrorCode_InvalidVolumeNumber
;; Remarks      : You can select a volume by either index, drive letter, or mount point path. On a basic disk, if
;;                you select a volume, the corresponding partition is put in focus.
;;
Func _DiskpartSelectVolume( $pid, $volume )
    
    If Not ProcessExists( $pid ) Then Return __dpSetError( 1, $_DP_ErrorCode_InvalidProcessID, 0 )

    Local Const $SelectVolumeCommand = 'select volume ' & $volume & @CRLF
    Local $_output = "", _
          $_pHandle = _Win32OpenProcess( $pid )
    
    __dpIssueCommand( $pid, $SelectVolumeCommand, $_output )
    If @error Then Return __dpSafeReturn( __dpSetError( @error, @extended, 0 ), $_pHandle )
    
    ;
    ; did we fail with an invalid volume id?
    ;
    If StringRegExp( $_output, "(?i)there is no volume selected", 0 ) Then
        Return __dpSafeReturn( __dpSetError( 1, $_DP_ErrorCode_InvalidVolumeNumber, 0 ), $_pHandle )
    EndIf
    ;
    ; one last check to make sure it worked
    ;
    If Not StringRegExp( $_output, "(?i)volume \d+ is the selected volume", 0 ) Then
        Return __dpSafeReturn( __dpSetError( 1, $_DP_ErrorCode_InvalidVolumeNumber, 0 ), $_pHandle )
    EndIf
    ;
    ; sweet success
    ;
    Return __dpSafeReturn( __dpSetError( 0, 0, $volume ), $_pHandle )
EndFunc
;;
;; Function     : _DiskpartCurrentVolume
;; Description  : Returns the current in-focus volume
;; Parameters   : $pid          : [in]  running diskpart process identifier
;; Returns      : Success   : Volume with focus
;;                @ERROR    : 0  = Success
;;                          : 1  = Failure
;;                @EXTENDED : 2  = $_DP_ErrorCode_InvalidProcessID
;;                          : 3  = $_DP_ErrorCode_UnexpectedTermination
;;                          : 4  = $_DP_ErrorCode_StdoutStreamError
;;                          : 5  = $_DP_ErrorCode_StdinStreamError
;;                          : 6  = $_DP_ErrorCode_UnexpectedCommandOutput
;;                          : 7  = $_DP_ErrorCode_UnrecognizedCommand
;;                          : 10 = $_DP_ErrorCode_InvalidVolumeNumber
;; Remarks      : @error = 10 if there is no current in-focus volume
;;
Func _DiskpartCurrentVolume( $pid )
    
    If Not ProcessExists( $pid ) Then Return __dpSetError( 1, $_DP_ErrorCode_InvalidProcessID, 0 )

    Local Const $SelectVolumeCommand = 'select volume' & @CRLF
    Local $_output = "", _
          $_pHandle = _Win32OpenProcess( $pid )
    
    __dpIssueCommand( $pid, $SelectVolumeCommand, $_output )
    If @error Then Return __dpSafeReturn( __dpSetError( @error, @extended, 0 ), $_pHandle )
    
    Local $_m = StringRegExp( $_output, "(?i)volume (\d+) is the selected volume", 1 )
    If @error Then Return __dpSafeReturn( __dpSetError( 1, $_DP_ErrorCode_InvalidVolumeNumber, 0 ), $_pHandle )
    ;
    ; sweet success
    ;
    Return __dpSafeReturn( __dpSetError( 0, 0, $_m[0] ), $_pHandle )
EndFunc
;;
;; Function     : _DiskpartSelectPartition
;; Description  : Sets the focus to the given partition number
;; Parameters   : $pid       : [in]  running diskpart process identifier
;;                $partition : [in]  partition number returned by _DiskpartListPartitions
;; Returns      : Success   : Partition with focus
;;                @ERROR    : 0  = Success
;;                          : 1  = Failure
;;                @EXTENDED : 2  = $_DP_ErrorCode_InvalidProcessID
;;                          : 3  = $_DP_ErrorCode_UnexpectedTermination
;;                          : 4  = $_DP_ErrorCode_StdoutStreamError
;;                          : 5  = $_DP_ErrorCode_StdinStreamError
;;                          : 6  = $_DP_ErrorCode_UnexpectedCommandOutput
;;                          : 7  = $_DP_ErrorCode_UnrecognizedCommand
;;                          : 8  = $_DP_ErrorCode_InvalidTargetFocus (no disk currently in-focus)
;;                          : 11 = $_DP_ErrorCode_InvalidPartitionNumber
;; Remarks      : On basic disks, you can select a partition by index, drive letter, or mount point path. On  
;;                dynamic disks you can only specify the partition by index.
;;
Func _DiskpartSelectPartition( $pid, $partition )

    If Not ProcessExists( $pid ) Then Return __dpSetError( 1, $_DP_ErrorCode_InvalidProcessID, 0 )

    Local Const $SelectPartitionCommand = 'select partition ' & $partition & @CRLF
    Local $_output = "", _
          $_pHandle = _Win32OpenProcess( $pid )
    
    __dpIssueCommand( $pid, $SelectPartitionCommand, $_output )
    If @error Then Return __dpSafeReturn( __dpSetError( @error, @extended, 0 ), $_pHandle )
    
    ;
    ; did we fail because no disk currently was in-focus?
    ;
    If StringRegExp( $_output, "(?i)select a disk and try again", 0 ) Then
        Return __dpSafeReturn( __dpSetError( 1, $_DP_ErrorCode_InvalidTargetFocus, 0 ), $_pHandle )
    EndIf
    ;
    ; did we fail with an invalid partition number?
    ;
    If StringRegExp( $_output, "(?i)please select a valid partition", 0 ) Then
        Return __dpSafeReturn( __dpSetError( 1, $_DP_ErrorCode_InvalidPartitionNumber, 0 ), $_pHandle )
    EndIf
    ;
    ; one last check to make sure it worked
    ;
    If Not StringRegExp( $_output, "(?i)partition \d+ is now the selected partition", 0 ) Then
        Return __dpSafeReturn( __dpSetError( 1, $_DP_ErrorCode_InvalidPartitionNumber, 0 ), $_pHandle )
    EndIf
    ;
    ; sweet success
    ;
    Return __dpSafeReturn( __dpSetError( 0, 0, $partition ), $_pHandle )
EndFunc
;;
;; Function     : _DiskpartCurrentPartition
;; Description  : Returns the current in-focus partition number
;; Parameters   : $pid       : [in]  running diskpart process identifier
;; Returns      : Success   : Partition with focus
;;                @ERROR    : 0  = Success
;;                          : 1  = Failure
;;                @EXTENDED : 2  = $_DP_ErrorCode_InvalidProcessID
;;                          : 3  = $_DP_ErrorCode_UnexpectedTermination
;;                          : 4  = $_DP_ErrorCode_StdoutStreamError
;;                          : 5  = $_DP_ErrorCode_StdinStreamError
;;                          : 6  = $_DP_ErrorCode_UnexpectedCommandOutput
;;                          : 7  = $_DP_ErrorCode_UnrecognizedCommand
;;                          : 8  = $_DP_ErrorCode_InvalidTargetFocus (no disk currently in-focus)
;;                          : 11 = $_DP_ErrorCode_InvalidPartitionNumber
;; Remarks      : @error = 11 if there is no current in-focus partition
;;
Func _DiskpartCurrentPartition( $pid )

    If Not ProcessExists( $pid ) Then Return __dpSetError( 1, $_DP_ErrorCode_InvalidProcessID, 0 )

    Local Const $SelectPartitionCommand = 'select partition' & @CRLF
    Local $_output = "", _
          $_pHandle = _Win32OpenProcess( $pid )
    
    __dpIssueCommand( $pid, $SelectPartitionCommand, $_output )
    If @error Then Return __dpSafeReturn( __dpSetError( @error, @extended, 0 ), $_pHandle )
    
    ;
    ; did we fail because no disk currently was in-focus?
    ;
    If StringRegExp( $_output, "(?i)select a disk and try again", 0 ) Then
        Return __dpSafeReturn( __dpSetError( 1, $_DP_ErrorCode_InvalidPartitionNumber, 0 ), $_pHandle )
    EndIf
    
    Local $_m = StringRegExp( $_output, "(?i)partition (\d+) is now the selected partition", 1 )
    If @error Then Return __dpSafeReturn( __dpSetError( 1, $_DP_ErrorCode_InvalidPartitionNumber, 0 ), $_pHandle )
    ;
    ; sweet success
    ;
    Return __dpSafeReturn( __dpSetError( 0, 0, $_m[0] ), $_pHandle )
EndFunc
;;
;; Function     : _DiskpartDetailDisk
;; Description  : Executes a 'detail disk' command against the current in-focus disk
;; Parameters   : $pid      : [in]  running diskpart process identifier
;;                $details  : [out] array of disk details for the in-focus disk
;;                $volumes  : [out] array of volumes on the disk and their attributes - see remarks below
;; Returns      : Success   : number of volumes in $volumes
;;                @ERROR    : 0  = Success
;;                          : 1  = Failure
;;                @EXTENDED : 1  = $_DP_ErrorCode_UnknownFailure (StringSplit failed)
;;                          : 2  = $_DP_ErrorCode_InvalidProcessID
;;                          : 3  = $_DP_ErrorCode_UnexpectedTermination
;;                          : 4  = $_DP_ErrorCode_StdoutStreamError
;;                          : 5  = $_DP_ErrorCode_StdinStreamError
;;                          : 6  = $_DP_ErrorCode_UnexpectedCommandOutput
;;                          : 7  = $_DP_ErrorCode_UnrecognizedCommand
;;                          : 8  = $_DP_ErrorCode_InvalidTargetFocus (no in-focus disk)
;; Remarks      : If successful then $details will contain:
;;                $details[0] = Disk name
;;                $details[1] = Disk ID
;;                $details[2] = Type
;;                $details[3] = Bus
;;                $details[4] = Target
;;                $details[5] = LUN ID
;;
;;                and $volumes will contain:
;;                $volumes[][0] = Volume ###
;;                $volumes[][1] = Letter
;;                $volumes[][2] = Label
;;                $volumes[][3] = Filesystem
;;                $volumes[][4] = Type
;;                $volumes[][5] = Size
;;                $volumes[][6] = Status
;;                $volumes[][7] = Info
;;
Func _DiskpartDetailDisk( $pid, ByRef $details, ByRef $volumes )
    
    If Not ProcessExists( $pid ) Then Return __dpSetError( 1, $_DP_ErrorCode_InvalidProcessID, 0 )

    Local Const $DetailDiskCommand = 'detail disk' & @CRLF
    Local $emptyDetailArray[6] = ["","","","","",""], $emptyVolumeArray[1][8] = [["","","","","","","",""]]
    
    Local $_output = "", _
          $_pHandle = _Win32OpenProcess( $pid )

    _DiskpartCurrentDisk( $pid )  ; make sure we have a valid focus
    If @error Then Return __dpSafeReturn( __dpSetError( @error, @extended, 0 ), $_pHandle )

    __dpIssueCommand( $pid, $DetailDiskCommand, $_output )
    If @error Then 
        $details = $emptyDetailArray
        $volumes = $emptyVolumeArray
        Return __dpSafeReturn( __dpSetError( @error, @extended, 0 ), $_pHandle )
    EndIf
    ;
    ; looks like it worked
    ;
    Local $_outputLines, $_okayExtractData = False, $_insideDetails = False
    Local $_volumeCount = 0, $_detailIndex = 1, _
          $_tmpDetailArray[6] = ["","","","","",""], _
          $_tmpVolumeArray[63][8] = [["","","","","","","",""]]
          
    $_outputLines = StringSplit( $_output, @LF )
    If Not @error Then
        
        For $idx = 1 To $_outputLines[0]
            
            If StringStripWS( $_outputLines[$idx], 3 ) = "" Or _
               StringInStr( $_outputLines[$idx], "diskpart>" ) Then ContinueLoop
            
            If Not $_okayExtractData Then
                
                If Not $_insideDetails And ($idx + 1 <= $_outputLines[0]) Then
                    
                    If StringRegExp( $_outputLines[$idx], "(?i)volume[ ]###[ ]+ltr[ ]+label[ ]+fs[ ]+type[ ]+size[ ]+status[ ]+info", 0 ) Then
                        $_okayExtractData = True
                        $idx += 1
                    Else
                        If StringInStr( $_outputLines[$idx + 1], "disk id:" ) Then
                            $_tmpDetailArray[0] = StringStripWS( $_outputLines[$idx], 3 )
                            $_insideDetails = True
                        EndIf
                    EndIf
                    
                Else
                    If StringInStr( $_outputLines[$idx], "lun id" ) Then $_insideDetails = False
                    $_tmpDetailArray[ $_detailIndex ] = StringStripWS( StringMid( $_outputLines[$idx], 10 ), 3 )
                    $_detailIndex += 1
                EndIf
            Else
                        
                ;  Volume ###  Ltr  Label        Fs     Type        Size     Status     Info
                ;  ----------  ---  -----------  -----  ----------  -------  ---------  --------                    
                ;12345678901234567890123456789012345678901234567890123456789012345678901234567890
                ;         1         2         3         4         5         6         7         8  

                $_tmpVolumeArray[ $_volumeCount ][0] = StringStripWS( StringMid( $_outputLines[$idx], 10, 3  ), 3 )  ; Volumn ###
                $_tmpVolumeArray[ $_volumeCount ][1] = StringStripWS( StringMid( $_outputLines[$idx], 15, 3  ), 3 )  ; Letter
                $_tmpVolumeArray[ $_volumeCount ][2] = StringStripWS( StringMid( $_outputLines[$idx], 20, 11 ), 3 )  ; Label
                $_tmpVolumeArray[ $_volumeCount ][3] = StringStripWS( StringMid( $_outputLines[$idx], 33, 5  ), 3 )  ; Filesystem
                $_tmpVolumeArray[ $_volumeCount ][4] = StringStripWS( StringMid( $_outputLines[$idx], 40, 10 ), 3 )  ; Type
                $_tmpVolumeArray[ $_volumeCount ][5] = StringStripWS( StringMid( $_outputLines[$idx], 52, 7  ), 3 )  ; Size
                $_tmpVolumeArray[ $_volumeCount ][6] = StringStripWS( StringMid( $_outputLines[$idx], 61, 9  ), 3 )  ; Status
                $_tmpVolumeArray[ $_volumeCount ][7] = StringStripWS( StringMid( $_outputLines[$idx], 72, 8  ), 3 )  ; Info
  
                $_volumeCount += 1
            EndIf
        Next
        
        $details = $emptyDetailArray
        $volumes = $emptyVolumeArray
    
        If $_okayExtractData Then
            If $_volumeCount > 0 Then
                ReDim $_tmpVolumeArray[ $_volumeCount ][8]
                $volumes = $_tmpVolumeArray
                $details = $_tmpDetailArray
            EndIf
        
            Return __dpSafeReturn( __dpSetError( 0, 0, $_volumeCount ), $_pHandle )
        Else
            Return __dpSafeReturn( __dpSetError( 1, $_DP_ErrorCode_UnexpectedCommandOutput, 0 ), $_pHandle )
        EndIf
    EndIf
    
    Return __dpSafeReturn( __dpSetError( 1, $_DP_ErrorCode_UnknownFailure, 0 ), $_pHandle )
EndFunc
;;
;; Function     : _DiskpartDetailVolume
;; Description  : Executes the 'detail volume' command against the in-focus volume
;; Parameters   : $pid      : [in]  running diskpart process identifier
;;                $disks    : [out] array of disks associated with the volume and their attributes - see remarks below
;; Returns      : Success   : number of disks in $disks
;; Returns      : Success   : number of disks returned in $disks
;;                @ERROR    : 0  = Success
;;                          : 1  = Failure
;;                @EXTENDED : 1  = $_DP_ErrorCode_UnknownFailure (StringSplit failed)
;;                          : 2  = $_DP_ErrorCode_InvalidProcessID
;;                          : 3  = $_DP_ErrorCode_UnexpectedTermination
;;                          : 4  = $_DP_ErrorCode_StdoutStreamError
;;                          : 5  = $_DP_ErrorCode_StdinStreamError
;;                          : 6  = $_DP_ErrorCode_UnexpectedCommandOutput
;;                          : 7  = $_DP_ErrorCode_UnrecognizedCommand
;;                          : 8  = $_DP_ErrorCode_InvalidTargetFocus (no volume in-focus)
;; Remarks      : If successful $disks will contain the following:
;;                $disks[][0] = Disk ###
;;                $disks[][1] = Status
;;                $disks[][2] = Size
;;                $disks[][3] = Free
;;                $disks[][4] = Dyn
;;                $disks[][5] = Gpt
;;
Func _DiskpartDetailVolume( $pid, ByRef $disks )
    
    If Not ProcessExists( $pid ) Then Return __dpSetError( 1, $_DP_ErrorCode_InvalidProcessID, 0 )

    Local Const $DetailVolumeCommand = 'detail volume' & @CRLF
    Local $emptyDiskArray[1][6] = [["","","","","",""]]
    
    Local $_output = "", _
          $_pHandle = _Win32OpenProcess( $pid )

    $disks = $emptyDiskArray

    __dpIssueCommand( $pid, $DetailVolumeCommand, $_output )
    If @error Then 
        Return __dpSafeReturn( __dpSetError( @error, @extended, 0 ), $_pHandle )
    EndIf
    
    ;
    ; did we fail because no volume has focus
    ;
    If StringRegExp( $_output, "(?i)there is no volume selected", 0 ) Then
        Return __dpSafeReturn( __dpSetError( 1, $_DP_ErrorCode_InvalidTargetFocus, 0 ), $_pHandle )
    EndIf
    ;
    ; did we fail because no disks are associated with the volume?
    ;
    If StringRegExp( $_output, "(?i)there are no disks attached to this volume", 0 ) Then
        Return __dpSafeReturn( __dpSetError( 0, 0, 0 ), $_pHandle )  ; return success and zero disks
    EndIf
    ;
    ; parse out the associated disks
    ;
    Local $_outputLines, $_okayExtractData = False
    Local $_diskCount = 0, _
          $_tmpDiskArray[63][6] = [["","","","","",""]]
          
    $_outputLines = StringSplit( $_output, @LF )
    If Not @error Then
        
        For $idx = 1 To $_outputLines[0]
            
            If StringStripWS( $_outputLines[$idx], 3 ) = "" Or _
               StringInStr( $_outputLines[$idx], "diskpart>" ) Then ContinueLoop
            
            If Not $_okayExtractData Then
                
                If StringRegExp( $_outputLines[$idx], "(?i)disk ###[ ]+status[ ]+size[ ]+free[ ]+dyn[ ]+gpt", 0 ) Then
                    If $idx + 1 <= $_outputLines[0] Then
                        $_okayExtractData = True
                        $idx += 1
                    EndIf
                EndIf
                
            Else
                
                ;  Disk ###  Status      Size     Free     Dyn  Gpt
                ;  --------  ----------  -------  -------  ---  ---
                ;12345678901234567890123456789012345678901234567890123456789012345678901234567890
                ;         1         2         3         4         5         6         7         8  
                
                $_tmpDiskArray[ $_diskCount ][0] = StringStripWS( StringMid( $_outputLines[$idx],  8,  3 ), 3 )  ; Disk ###
                $_tmpDiskArray[ $_diskCount ][1] = StringStripWS( StringMid( $_outputLines[$idx], 13, 10 ), 3 )  ; Status
                $_tmpDiskArray[ $_diskCount ][2] = StringStripWS( StringMid( $_outputLines[$idx], 25,  7 ), 3 )  ; Size
                $_tmpDiskArray[ $_diskCount ][3] = StringStripWS( StringMid( $_outputLines[$idx], 34,  7 ), 3 )  ; Free
                $_tmpDiskArray[ $_diskCount ][4] = StringStripWS( StringMid( $_outputLines[$idx], 43,  3 ), 3 )  ; Dyn
                $_tmpDiskArray[ $_diskCount ][5] = StringStripWS( StringMid( $_outputLines[$idx], 48,  3 ), 3 )  ; Gpt
  
                $_diskCount += 1
            EndIf
        Next
        
        If $_okayExtractData Then
            If $_diskCount > 0 Then
                ReDim $_tmpDiskArray[ $_diskCount ][6]
                $disks = $_tmpDiskArray
            EndIf
        
            Return __dpSafeReturn( __dpSetError( 0, 0, $_diskCount ), $_pHandle )
        Else
            Return __dpSafeReturn( __dpSetError( 1, $_DP_ErrorCode_UnexpectedCommandOutput, 0 ), $_pHandle )
        EndIf
    EndIf
    
    Return __dpSafeReturn( __dpSetError( 1, $_DP_ErrorCode_UnknownFailure, 0 ), $_pHandle )
EndFunc
;;
;; Function     : _DiskpartDetailPartition
;; Description  : Executes a 'detail partition' command against the current in-focus partition.
;; Parameters   : $pid      : [in]  running diskpart process identifier
;;                $details  : [out] array of partition details for the in-focus partition
;;                $volumes  : [out] array of volumes associated with the partition and their attributes - see remarks below
;; Returns      : Success   : number of volumes in $volumes
;;                @ERROR    : 0  = Success
;;                          : 1  = Failure
;;                @EXTENDED : 1  = $_DP_ErrorCode_UnknownFailure (StringSplit failed)
;;                          : 2  = $_DP_ErrorCode_InvalidProcessID
;;                          : 3  = $_DP_ErrorCode_UnexpectedTermination
;;                          : 4  = $_DP_ErrorCode_StdoutStreamError
;;                          : 5  = $_DP_ErrorCode_StdinStreamError
;;                          : 6  = $_DP_ErrorCode_UnexpectedCommandOutput
;;                          : 7  = $_DP_ErrorCode_UnrecognizedCommand
;;                          : 8  = $_DP_ErrorCode_InvalidTargetFocus (no in-focus disk/partition)
;; Remarks      : If successful then $details will contain:
;;                $details[0] = Partition ###
;;                $details[1] = Type    (ie., 07)
;;                $details[2] = Hidden  (Yes/No)
;;                $details[3] = Active  (Yes/No)
;;
;;                and $volumes will contain:
;;                $volumes[][0] = Volume ###
;;                $volumes[][1] = Letter
;;                $volumes[][2] = Label
;;                $volumes[][3] = Filesystem
;;                $volumes[][4] = Type
;;                $volumes[][5] = Size
;;                $volumes[][6] = Status
;;                $volumes[][7] = Info
;;
Func _DiskpartDetailPartition( $pid, ByRef $details, ByRef $volumes )
    
    If Not ProcessExists( $pid ) Then Return __dpSetError( 1, $_DP_ErrorCode_InvalidProcessID, 0 )

    Local Const $DetailPartitionCommand = 'detail partition' & @CRLF
    Local $emptyDetailArray[4] = ["","","",""], $emptyVolumeArray[1][8] = [["","","","","","","",""]]
    
    Local $_output = "", _
          $_pHandle = _Win32OpenProcess( $pid )

    $details = $emptyDetailArray
    $volumes = $emptyVolumeArray

    __dpIssueCommand( $pid, $DetailPartitionCommand, $_output )
    If @error Then 
        Return __dpSafeReturn( __dpSetError( @error, @extended, 0 ), $_pHandle )
    EndIf
    ;
    ; did we fail because there is no in-focus disk?
    ;
    If StringRegExp( $_output, "(?i)there is no disk selected", 0 ) Then
        Return __dpSafeReturn( __dpSetError( 1, $_DP_ErrorCode_InvalidTargetFocus, 0 ), $_pHandle )
    EndIf
    ;
    ; did we fail because there is no in-focus partition?
    ;
    If StringRegExp( $_output, "(?i)there is no partition selected", 0 ) Then
        Return __dpSafeReturn( __dpSetError( 1, $_DP_ErrorCode_InvalidTargetFocus, 0 ), $_pHandle )
    EndIf
    ;
    ; parse the associated details and volumes
    ;
    Local $_outputLines, $_okayExtractData = False, $_insideDetails = False
    Local $_volumeCount = 0, $_detailIndex = 1, _
          $_tmpDetailArray[6] = ["","","","","",""], _
          $_tmpVolumeArray[63][8] = [["","","","","","","",""]]
          
    $_outputLines = StringSplit( $_output, @LF )
    If Not @error Then
        
        For $idx = 1 To $_outputLines[0]
            
            If StringStripWS( $_outputLines[$idx], 3 ) = "" Or _
               StringInStr( $_outputLines[$idx], "diskpart>" ) Then ContinueLoop
            
            If Not $_okayExtractData Then
                
                If Not $_insideDetails And ($idx + 1 <= $_outputLines[0]) Then
                    
                    If StringRegExp( $_outputLines[$idx], "(?i)volume[ ]###[ ]+ltr[ ]+label[ ]+fs[ ]+type[ ]+size[ ]+status[ ]+info", 0 ) Then
                        $_okayExtractData = True
                        $idx += 1
                    Else
                        If StringInStr( $_outputLines[$idx], "partition" ) Then
                            $_tmpDetailArray[0] = StringStripWS( StringMid( $_outputLines[$idx], 11 ), 3 )
                            $_insideDetails = True
                        EndIf
                    EndIf
                    
                Else
                    If StringInStr( $_outputLines[$idx], "active" ) Then $_insideDetails = False
                    $_tmpDetailArray[ $_detailIndex ] = StringStripWS( StringMid( $_outputLines[$idx], 9 ), 3 )
                    $_detailIndex += 1
                EndIf
            Else
                        
                ;  Volume ###  Ltr  Label        Fs     Type        Size     Status     Info
                ;  ----------  ---  -----------  -----  ----------  -------  ---------  --------                    
                ;12345678901234567890123456789012345678901234567890123456789012345678901234567890
                ;         1         2         3         4         5         6         7         8  

                $_tmpVolumeArray[ $_volumeCount ][0] = StringStripWS( StringMid( $_outputLines[$idx], 10, 3  ), 3 )  ; Volumn ###
                $_tmpVolumeArray[ $_volumeCount ][1] = StringStripWS( StringMid( $_outputLines[$idx], 15, 3  ), 3 )  ; Letter
                $_tmpVolumeArray[ $_volumeCount ][2] = StringStripWS( StringMid( $_outputLines[$idx], 20, 11 ), 3 )  ; Label
                $_tmpVolumeArray[ $_volumeCount ][3] = StringStripWS( StringMid( $_outputLines[$idx], 33, 5  ), 3 )  ; Filesystem
                $_tmpVolumeArray[ $_volumeCount ][4] = StringStripWS( StringMid( $_outputLines[$idx], 40, 10 ), 3 )  ; Type
                $_tmpVolumeArray[ $_volumeCount ][5] = StringStripWS( StringMid( $_outputLines[$idx], 52, 7  ), 3 )  ; Size
                $_tmpVolumeArray[ $_volumeCount ][6] = StringStripWS( StringMid( $_outputLines[$idx], 61, 9  ), 3 )  ; Status
                $_tmpVolumeArray[ $_volumeCount ][7] = StringStripWS( StringMid( $_outputLines[$idx], 72, 8  ), 3 )  ; Info
  
                $_volumeCount += 1
            EndIf
        Next
        
        If $_okayExtractData Then
            If $_volumeCount > 0 Then
                ReDim $_tmpVolumeArray[ $_volumeCount ][8]
                $volumes = $_tmpVolumeArray
                $details = $_tmpDetailArray
            EndIf
        
            Return __dpSafeReturn( __dpSetError( 0, 0, $_volumeCount ), $_pHandle )
        Else
            Return __dpSafeReturn( __dpSetError( 1, $_DP_ErrorCode_UnexpectedCommandOutput, 0 ), $_pHandle )
        EndIf
    EndIf
    
    Return __dpSafeReturn( __dpSetError( 1, $_DP_ErrorCode_UnknownFailure, 0 ), $_pHandle )
EndFunc

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~ Internal Diskpart Automation API
;~ The following functions comprise internal functions used by the automation api
;~ that should never be called directly by the user
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;;
;; Function     : __dpIssueCommand
;; Description  : Issues a command to the diskpart interactive console and captures its result. 
;; Parameters   : $pid      : [in]  running diskpart process identifier
;;                $cmd      : [in]  command to issue
;;                $output   : [out] command output
;; Returns      : Success   : 1
;;                Failure   : 0
;;                @ERROR    : 0  = Success
;;                          : 1  = Failure
;;                @EXTENDED : 2  = $_DP_ErrorCode_InvalidProcessID
;;                          : 3  = $_DP_ErrorCode_UnexpectedTermination
;;                          : 4  = $_DP_ErrorCode_StdoutStreamError
;;                          : 5  = $_DP_ErrorCode_StdinStreamError
;;                          : 7  = $_DP_ErrorCode_UnrecognizedCommand
;; Remarks      : If @extended = 3 use _DiskpartTerminationCode to retreive its exit code
;;
Func __dpIssueCommand( $pid, $cmd, ByRef $output )

    If Not Int( $pid ) Or _
       Not ProcessExists( $pid ) Then Return __dpSetError( 1, $_DP_ErrorCode_InvalidProcessID, 0 )

    Local $_pHandle = _Win32OpenProcess( $pid )

    __dpWriteCommand( $pid, $cmd )
    If @error Then Return __dpSafeReturn( __dpSetError( 1, __dpGetExtendedError(), 0 ), $_pHandle )
    
    __dpReadCommandOutput( $pid, $output )
    If @error Then
        If @extended <> $_DP_ErrorCode_UnexpectedTermination Then 
            Return __dpSafeReturn( __dpSetError( 1, __dpGetExtendedError(), 0 ), $_pHandle )
        EndIf
        ;
        ; before returning an unexpected termination error check to see that diskpart
        ; was not closing down normally (ie., user may have issued the exit command)
        ;
        If StringRegExp( $output, "(?i)leaving diskpart", 0 ) Then 
            ; treat normal program termination as success
            __dpSafeReturn( __dpSetError( 0, 0, 1 ), $_pHandle )  
        Else    
            ; otherwise looks like diskpart really did close rather sudden
            Return __dpSafeReturn( __dpSetError( 1, $_DP_ErrorCode_UnexpectedTermination, 0 ), $_pHandle )
        EndIf
    EndIf
    ;
    ; check to see if diskpart accepted the command. when it encounters an
    ; unknown command it prints out a standard header and list of commands 
    ;
    If StringRegExp( $output, "(?i)microsoft diskpart \d+\.\d+\.\d+", 0 ) Then
        ;
        ; special case - if the copyright header is present we are looking
        ; at the first bit of output generated by diskpart and the above
        ; match should be ignored
        ;
        If StringRegExp( $output, "(?i)copyright", 0 ) Then Return __dpSafeReturn( __dpSetError( 0, 0, 1 ), $_pHandle )
        ;
        ; looks like diskpart showed us its command help, return failure
        ;
        Return __dpSafeReturn( __dpSetError( 1, $_DP_ErrorCode_UnrecognizedCommand, 0 ), $_pHandle )
    EndIf
    ;
    ; success - atleast as far as we are concerned. calling function should check for 
    ; additional clues in the output before accepting that the command call was
    ; truely successful
    ;
    Return __dpSafeReturn( __dpSetError( 0, 0, 1 ), $_pHandle )
EndFunc
;;
;; Function     : __dpWriteCommand
;; Description  : Writes a command to the diskpart process stdin
;; Parameters   : $pid      : [in] running diskpart process identifier
;;                $cmd      : [in] command string to execute
;; Returns      : Success   : 1
;;                Failure   : 0
;;                @ERROR    : 0  = Success
;;                          : 1  = Failure
;;                @EXTENDED : 2  = $_DP_ErrorCode_InvalidProcessID
;;                          : 5  = $_DP_ErrorCode_StdinStreamError
;;
Func __dpWriteCommand( $pid, $cmd )
    
    If Not ProcessExists( $pid ) Then Return __dpSetError( 1, $_DP_ErrorCode_InvalidProcessID, 0 )

    If String($cmd) <> "" Then StdinWrite( $pid, $cmd )
    If @error Then Return __dpSetError( 1, $_DP_ErrorCode_StdinStreamError, 0 )

    Return __dpSetError( 0, 0, 1 )
EndFunc
;;
;; Function     : __dpReadCommandOutput
;; Description  : Reads stdout until the next command prompt is seen or the process terminates
;; Parameters   : $pid      : [in]  running diskpart process identifier
;;                $output   : [out] contents of stdout
;; Returns      : Success   : 1
;;                Failure   : 0
;;                @ERROR    : 0  = Success
;;                          : 1  = Failure
;;                @EXTENDED : 2  = $_DP_ErrorCode_InvalidProcessID
;;                          : 3  = $_DP_ErrorCode_UnexpectedTermination
;;                          : 4  = $_DP_ErrorCode_StdoutStreamError
;;
Func __dpReadCommandOutput( $pid, ByRef $output )
    
    If Not ProcessExists( $pid ) Then Return __dpSetError( 1, $_DP_ErrorCode_InvalidProcessID, 0 )

    $output = ""
    While ProcessExists( $pid )
        
        Local $_peek = StdoutRead( $pid, 0, True )
        If @error Then Return __dpSetError( 1, $_DP_ErrorCode_StdoutStreamError, 0 )
            
        If $_peek > 0 Then
            $output &= StdoutRead( $pid, $_peek )
            If @error Then Return __dpSetError( 1, $_DP_ErrorCode_StdoutStreamError, 0 )
        EndIf
        ;
        ; We loop until the process terminates or we see the next prompt
        ;
        If StringRegExp( $output, "(?i)diskpart>", 0 ) Then Return __dpSetError( 0, 0, 1 )
        
    WEnd
    ;
    ; its up to the calling code to determine if this was really unexpected or not
    ; since we don't make any assumptions about the commands being issued
    ;
    Return __dpSetError( 1, $_DP_ErrorCode_UnexpectedTermination, 0 )
EndFunc
;;
;; Function     : __dpSetError
;; Description  : Mirrors the functionality of the AutoIt SetError function but also saves the errorcode
;;                parameters internally to reduce the need to save and restore @error/@extended values.
;; Parameters   : ec    - integer value to set the internal error errorcode (and @error macro) to
;;                xc    - optional: integer value to set internal extended errorcode (and @extended macro) to
;;                rc    - optional: override the default return value and return this parameter
;; Returns      : Nothing unless return value parameter is passed to the function
;;
Func __dpSetError( $ec, $xc = Default, $rc = Default )
    
    If Not IsInt( $ec ) Then $ec = 0

    SetError( $ec )
    $__DP_InternalAPI_ErrorCode = $ec
    
    If Not $xc = Default Then __dpSetExtendedError( $xc )
    If Not $rc = Default Then Return $rc
    
EndFunc
;;
;; Function     : __dpSetExtendedError
;; Description  : Mirrors the functionality of the AutoIt SetExtended function but also saves the errorcode
;;                parameter internally to reduce the need to save and restore @error/@extended values.
;; Parameters   : xc    - integer value to set internal extended errorcode (and @extended macro) to
;;                rc    - optional: override the default return value and return this parameter
;; Returns      : Nothing unless return value parameter is passed to the function
;;
Func __dpSetExtendedError( $xc, $rc = Default )
    
    If Not IsInt( $xc ) Then $xc = 0

    SetExtended( $xc )
    $__DP_InternalAPI_ExtendedErrorCode = $xc
    
    If Not $rc = Default Then Return $rc
    
EndFunc
;;
;; Function     : __dpGetError
;; Description  : Returns the last reported API error
;; Parameters   : None
;; Returns      : Integer
;; Remarks      : Wraps $__DP_InternalAPI_ErrorCode
;;
Func __dpGetError()
    
    If Not IsInt( $__DP_InternalAPI_ErrorCode ) Then $__DP_InternalAPI_ErrorCode = 0
    
    Return $__DP_InternalAPI_ErrorCode
EndFunc
;;
;; Function     : __dpGetExtendedError
;; Description  : Returns the last reported API extended errorcode
;; Parameters   : None
;; Returns      : Integer
;; Remarks      : Wraps $__DP_InternalAPI_ExtendedErrorCode
;;
Func __dpGetExtendedError()
    
    If Not IsInt( $__DP_InternalAPI_ExtendedErrorCode ) Then $__DP_InternalAPI_ExtendedErrorCode = 0
    
    Return $__DP_InternalAPI_ExtendedErrorCode
EndFunc
;;
;; Function     : __dpSafeReturn
;; Description  : Some functions may open a process handle in order to retreive its exit code. This
;;                function ensures that this handle is properly freed and will attempt to retreive
;;                the process exit code.
;; Parameters   : $rc       - desired function return code
;;                $handle   - optional: the process handle that is to be freed; if process has terminated
;;                            attempt to save its exit code
;; Returns      : value passed in $rc
;; Remarks      : preserves values previously set by __dpSetError and __dpSetExtendedError on entry
;;
Func __dpSafeReturn( $rc, $handle = Default )
    
    Local $ec = __dpGetError(), $xc = __dpGetExtendedError()   ; preserve our caller's error values
    
    If Not $handle = Default And $handle <> 0 Then
        Local $tcode = _Win32GetExitCodeProcess( $handle )
        If Not @error Then
            $__DP_InternalAPI_ProcessTerminationCode = $tcode  ; STILL_ACTIVE (259) - trapped in _DiskpartTerminationCode
        Else
            $__DP_InternalAPI_ProcessTerminationCode = $_DP_ProcessExitCode_CouldNotRetrieveExitCode
        EndIf
        
        _Win32CloseHandle( $handle )
    EndIf
    
    Return __dpSetError( $ec, $xc, $rc )
EndFunc

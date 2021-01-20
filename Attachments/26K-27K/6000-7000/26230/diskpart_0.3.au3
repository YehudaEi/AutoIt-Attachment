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

;; NEW
;;  tested on:
;;      Windows Vista Home Premium italian
;;		Windows Vista Businnes italian
;;      Windows PE 2.0 italian
;;
;; Version 0.25, 2 may 2009 by Federico Vaga
;; federico.vaga01@universitadipavia.it 
;; _DiskpartAssignLetter.................Assign a letter to volume
;; _DiskpartRescan.......................Rescan the system for new device
;; _DiskpartOnlineDisk...................make active disk
;; _DiskpartOnlinevolume.................make active volume
;; _DiskpartOfflineDisk..................deactive disk
;; -DiskpartRemove.......................remove letter assignment from a selected volume
;;
;; ------------------------------------
;; This library is language dependent |
;; ------------------------------------
#RequireAdmin
#include-once
#include <Constants.au3>
#include <array.au3>
#include <Misc.au3>
#include "win32.au3"
opt("MustDeclareVars",1)

Global $__DP_VersionStrings[4] = [ '0.25', 0, 25, '2009/03/28' ]

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
        $_DP_ErrorCode_ConsoleStartFailed       = 12, _
		$_DP_ErrorCode_InvalidTargetLetter      = 13, _ 
		$_DP_ErrorCode_InvalidTargetFocusDevice = 14

Global Enum _; errorcodes reported by diskpart
        $_DP_ProcessExitCode_NoError            = 0, _
        $_DP_ProcessExitCode_FatalException     = 1, _
        $_DP_ProcessExitCode_InvalidCmdLine     = 2, _
        $_DP_ProcessExitCode_FileOpenFailed     = 3, _
        $_DP_ProcessExitCode_ServiceError       = 4, _
        $_DP_ProcessExitCode_SyntaxError        = 5, _
        $_DP_ProcessExitCode_CouldNotRetrieveExitCode = 65535
        
Global $__DP_InternalAPI_ProcessTerminationCode = $_DP_ProcessExitCode_CouldNotRetrieveExitCode
	   
global $logfile=@ScriptDir & "\DPGUI_verbose_"&@MDAY&@MON&@YEAR&"_"&@HOUR&@MIN&@SEC&".log"
global $verbose=0




;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~ Diskpart Automation API
;~ The following functions comprise the user callable portion of the automation api
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;; initialise option in DISKPART
;; $verbose, active the log of what real diskpart is doing
func _initDPlib($log)
	$verbose=$log
endfunc
;; Function: _DiskpartAssignLetter
;; Description: execute the 'assing letter=C' command
;; Perameters: $pid      : [in]  running diskpart process identifier
;;			   $letter	 : [in] the letter to assign to a volume
;; Returns      : @ERROR    : 0  = Success
;;				  @ERROR    : 1  = fail
Func _DiskpartAssignLetter($pid,$letter)
	If Not ProcessExists( $pid ) Then 
		; the process does not exist so I set the error and its extension
		Return SetError( 1, $_DP_ErrorCode_InvalidProcessID, 0 )
	endif
	; the process exist so I run the command
	Local Const $assignCommand = 'assign letter='&$letter & @CRLF
	Local $_output = "", _
		  $_pHandle = _Win32OpenProcess( $pid )
	; empty the stdout's buffer
	StdoutRead($pid)
	; run command
    __dpIssueCommand( $pid, $assignCommand, $_output )
    If @error Then 
		; run fail
		Return SetError( @error, @extended,__dpSafeReturn( 0, $_pHandle ) )
	endif
	if $verbose then
		; if the verbose mode is on, I'll log everythings
		_FileWriteLog($logfile,$assignCommand)
		_FileWriteLog($logfile,$_output)
	endif
	; Support For
	; - italian
	if StringRegExp($_output,"(?i)nessun volume specificato",0) Then
		; no volume is selected
		return SetError( 1, $_DP_ErrorCode_InvalidTargetFocus, __dpSafeReturn(0 , $_pHandle ) )
	EndIf
	if StringRegExp($_output,"(?i)la directory non . vuota",0) Then
		; the letter is already assinged
		return SetError( 1, $_DP_ErrorCode_InvalidTargetLetter, __dpSafeReturn(0 , $_pHandle ) )
	EndIf
	if StringRegExp($_output,"(?i)Impossibile riassegnare la lettera",0) Then
		; you can't re-assign a letter to this volume
		return SetError( 1, $_DP_ErrorCode_InvalidTargetFocus, __dpSafeReturn(0 , $_pHandle ) )
	EndIf
EndFunc

;; Function: _DiskpartOnlineDisk
;; Description: execute the 'online' command
;; Perameters: $pid      : [in]  running diskpart process identifier
;; Returns      : @ERROR    : 0  = Success
;;				  @ERROR    : 1  = fail
Func _DiskpartOnlineDisk($pid)
	If Not ProcessExists( $pid ) Then 
		; the process does not exist so I set the error
		Return SetError( 1, $_DP_ErrorCode_InvalidProcessID, 0 )
	endif
	; the process exist so I run the command
	Local Const $onlineCommand = 'online disk' & @CRLF
	Local $_output = "", _
		  $_pHandle = _Win32OpenProcess( $pid )
	; empty the stdout's buffer
	StdoutRead($pid)
	; run command
    __dpIssueCommand( $pid, $onlineCommand, $_output )
    If @error Then 
		; run fail
		Return SetError( @error, @extended,__dpSafeReturn( 0, $_pHandle ) )
	endif
	if $verbose then
		; if the verbose mode is on, I'll log everythings
		_FileWriteLog($logfile,$onlineCommand)
		_FileWriteLog($logfile,$_output)
	endif
	; Support For
	; - italian
	if StringRegExp($_output,"(?i)nessun disco selezionato da portare in linea",0) Then
		; no disk is selected
		return SetError( 1, $_DP_ErrorCode_InvalidTargetFocus, __dpSafeReturn(0 , $_pHandle ))
	EndIf
	if StringRegExp($_output,"(?i)impossibile portare in linea il disco selezionato",0) Then
		; impossibile to active this disk
		return SetError( 1, $_DP_ErrorCode_InvalidTargetFocus, __dpSafeReturn(0 , $_pHandle ))
	EndIf
EndFunc

;; Function: _DiskpartOnlineVolume
;; Description: execute the 'online' command
;; Perameters: $pid      : [in]  running diskpart process identifier
;; Returns      : @ERROR    : 0  = Success
;;				  @ERROR    : 1  = fail
Func _DiskpartOnlineVolume($pid)
	If Not ProcessExists( $pid ) Then 
		; the process does not exist so I set the error
		Return SetError( 1, $_DP_ErrorCode_InvalidProcessID, 0 )
	endif
	; the process exist so I run the command
	Local Const $onlineCommand = 'online volume' & @CRLF
	Local $_output = "", _
		  $_pHandle = _Win32OpenProcess( $pid )
	; empty the stdout's buffer
	StdoutRead($pid)
	; run command
    __dpIssueCommand( $pid, $onlineCommand, $_output )
	If @error Then 
		; run fail
		Return SetError( @error, @extended,__dpSafeReturn( 0, $_pHandle ) )
	endif
	if $verbose then
		; if the verbose mode is on, I'll log everythings
		_FileWriteLog($logfile,$onlinecommand)
		_FileWriteLog($logfile,$_output)
	endif
	; Support For
	; - italian
	if StringRegExp($_output,"(?i)nessun volume selezionato da portare in linea",0) Then
		; no volume is selected
		Return SetError( 1, $_DP_ErrorCode_InvalidTargetFocus,__dpSafeReturn( 0, $_pHandle ) )
	EndIf
EndFunc

;; Function: _DiskpartOfflineDisk
;; Description: execute the 'offline' command, work only with diskpart 6.0.6001 and above
;; Perameters: $pid      : [in]  running diskpart process identifier
;; Returns      : @ERROR    : 0  = Success
;;				  @ERROR    : 1  = fail
Func _DiskpartOfflineDisk($pid)
	If Not ProcessExists( $pid ) Then 
		; il processo non esiste per cui imposto un errore
		Return SetError( 1, $_DP_ErrorCode_InvalidProcessID, 0 )
	endif
	; the process exist so I run the command
	Local Const $offlineCommand = 'offline disk' & @CRLF
	Local $_output = "", _
		  $_pHandle = _Win32OpenProcess( $pid )
	; empty the stdout's buffer
	StdoutRead($pid)
	; run command
    __dpIssueCommand( $pid, $offlineCommand, $_output )
	If @error Then 
		; run fail
		Return SetError( @error, @extended,__dpSafeReturn( 0, $_pHandle ) )
	endif
	if $verbose then
		; if the verbose mode is on, I'll log everythings
		_FileWriteLog($logfile,$offlineCommand)
		_FileWriteLog($logfile,$_output)
	endif
	; Support For
	; - italian
	if StringRegExp($_output,"(?i)nessun disco selezionato da portare fuori linea",0) Then
		; no disk is selected
		Return SetError( 1, $_DP_ErrorCode_InvalidTargetFocus,__dpSafeReturn( 0, $_pHandle ) )
	EndIf
	if StringRegExp($_output,"(?i)Operazione non supportata su un supporto rimovibile.",0) Then
		Return SetError( 1, $_DP_ErrorCode_InvalidTargetFocusDevice,__dpSafeReturn( 0, $_pHandle ) )
	endif
	if StringRegExp($_output,"(?i)Il disco selezionato . il disco di sistema e non pu. essere portato non in linea",0) Then
		Return SetError( 1, $_DP_ErrorCode_InvalidTargetFocusDevice,__dpSafeReturn( 0, $_pHandle ) )
	endif
	if StringRegExp($_output,"(?i)Il disco selezionato . il disco di avvio e non pu. essere portato non in linea",0) Then
		Return SetError( 1, $_DP_ErrorCode_InvalidTargetFocusDevice,__dpSafeReturn( 0, $_pHandle ) )
	endif	
EndFunc

;; Function: _DiskpartRescan
;; Description: execute the 'rescan' command
;; Perameters: $pid      : [in]  running diskpart process identifier
;; Returns      : @ERROR    : 0  = Success
;;				  @ERROR    : 1  = fail

Func _DiskpartRescan($pid)
    If Not ProcessExists( $pid ) Then
		; the process does not exist so I set the error
		Return SetError( 1, $_DP_ErrorCode_InvalidProcessID, 0 )
	endif
	; the process exist so I run the command
	  Local Const $rescanCommand = 'rescan' & @CRLF
	  Local $_output = "", _
          $_pHandle = _Win32OpenProcess( $pid )
	; empty the stdout's buffer
	StdoutRead($pid)
	; run command
    __dpIssueCommand( $pid, $rescanCommand, $_output )
	If @error Then 
		; run fail
		Return SetError( @error, @extended,__dpSafeReturn( 0, $_pHandle ) )
	endif
	if $verbose then
		; if the verbose mode is on, I'll log everythings
		_FileWriteLog($logfile,$rescancommand)
		_FileWriteLog($logfile,$_output)
	endif
    
	; Support For
	; - italian
	If Not StringRegExp( $_output, "(?i)diskpart ha completato l'analisi della configurazione", 0 ) or _ 
		not StringRegExp( $_output, "(?i)analisi della configurazione completata", 0 )  Then
		; if the diskpart return is not ok (like the string) so something is go bad, I don't know what ... a general error
		Return __dpSafeReturn( SetError( 1, $_DP_ErrorCode_UnknownFailure, 0 ), $_pHandle )
	EndIf	
EndFunc

func _DiskpartRemove($pid)
	If Not ProcessExists( $pid ) Then 
		; il processo non esiste per cui imposto un errore
		Return SetError( 1, $_DP_ErrorCode_InvalidProcessID, 0 )
	endif
	; the process exist so I run the command
	Local Const $removeCommand = 'remove' & @CRLF
	Local $_output = "", _
		  $_pHandle = _Win32OpenProcess( $pid )
	; empty the stdout's buffer
	StdoutRead($pid)
	; run command
    __dpIssueCommand( $pid, $removeCommand, $_output )
	If @error Then 
		; run fail
		Return SetError( @error, @extended,__dpSafeReturn( 0, $_pHandle ) )
	endif
	if $verbose then
		; if the verbose mode is on, I'll log everythings
		_FileWriteLog($logfile,$removeCommand)
		_FileWriteLog($logfile,$_output)
	endif
	; Support For
	; - italian
	if StringRegExp($_output,"(?i)nessun volume selezionato",0) Then
		; no disk is selected
		Return SetError( 1, $_DP_ErrorCode_InvalidTargetFocus,__dpSafeReturn( 0, $_pHandle ) )
	EndIf
	
	if Not StringRegExp($_output,"(?i)rimozione della lettera di unit. riuscita",0) Then
		Return SetError( 1, $_DP_ErrorCode_UnrecognizedCommand ,__dpSafeReturn( 0, $_pHandle ) )
	endif
	
EndFunc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
	 ; launch diskpart as a command line application
    $pid     = Run(@ComSpec & " /c " & 'diskpart',"", @SW_HIDE, $STDIN_CHILD+$STDOUT_CHILD )
    If @error Then 
		; if there is an error I set that
        If Not $runerror = Default Then 
			$runerror = @extended
		endif
        local $err
		return SetError( 1, $_DP_ErrorCode_ConsoleStartFailed, 0 )
    EndIf
	
    Local $_output, $_rc, _
          $_pHandle = _Win32OpenProcess( $pid )
	; empty istruction just for test
    __dpIssueCommand( $pid, "", $_output )
    If @error Then
        ; process started but something else went wrong so I close that
		if $verbose then
			_FileWriteLog($logfile,"Diskpart is starting ..."
			_FileWriteLog($logfile,"Diskpart can't start")
		endif
        If ProcessExists( $pid ) Then 
            ProcessClose( $pid )        
            ProcessWaitClose( $pid )
        EndIf
        
        Return __dpSafeReturn( 1, $_pHandle )
    EndIf
    ;
    ; Success, try and get the version number from the header
	;
	if $verbose Then
		_FileWriteLog($logfile,"Diskpart is running")
	endif
	; SOLO ITALIANO
    Local $_m = StringRegExp( $_output, "(?i)versione[ \t]+(\d+\.\d+\.\d+)", 1 )
    If Not @error Then $version = $_m[0]
                    
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

    If Not ProcessExists( $pid ) Then 
		; the process does not exist so I set the error
		Return SetError( 1, $_DP_ErrorCode_InvalidProcessID, 0 )
    endif
    Local $_output, $_pHandle = _Win32OpenProcess( $pid )
    Local Const $ExitCommand = 'exit' & @CRLF
    StdoutRead($pid)
    __dpIssueCommand( $pid, $ExitCommand, $_output )
    If @error Then 
		; if the command return error, diskpart is closing so I kill the process
		ProcessClose( $pid )
	endif
	if $verbose then
		; if the verbose mode is on, I'll log everythings
		_FileWriteLog($logfile,$ExitCommand)
		_FileWriteLog($logfile,$_output)
	endif

    If Not ProcessWaitClose( $pid, 60 ) Then    ; give it 60 seconds to close gracefully
        ProcessClose( $pid )
        ProcessWaitClose( $pid )
    EndIf
	if $verbose then
		_FileWriteLog($logfile,"Diskpart is closed")
	endif
    Return __dpSafeReturn( SetError( 0, 0, 1 ), $_pHandle )
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
    
	
    If Not ProcessExists( $pid ) Then 
		; the process does not exist so I set the error
		Return SetError( 1, $_DP_ErrorCode_InvalidProcessID, 0 )
	endif

    Local Const $ListDiskCommand = 'list disk' & @CRLF
    Local $emptyDiskArray[1][6] = [["","","","","",""]]
    
    Local $_output = "", _
          $_pHandle = _Win32OpenProcess( $pid )
	; empty the stdout's buffer
	StdoutRead($pid)
    __dpIssueCommand( $pid, $ListDiskCommand, $_output )
	If @error Then 
		; run fail
		$disks = $emptyDiskArray
		Return SetError( @error, @extended,__dpSafeReturn( 0, $_pHandle ) )
	endif
	if $verbose then
		; if the verbose mode is on, I'll log everythings
		_FileWriteLog($logfile,$ListDiskcommand)
		_FileWriteLog($logfile,$_output)
	endif
    Local $_outputLines, $_okayExtractData = False
    Local $_diskCount = 0, _
          $_tmpDiskArray[63][6] = [["","","","","",""]]
          
    $_outputLines = StringSplit( $_output, @LF )
    If Not @error Then
        For $idx = 1 To $_outputLines[0]
            If StringStripWS( $_outputLines[$idx], 3 ) = "" Or _
               StringInStr( $_outputLines[$idx], "diskpart>" ) Then ContinueLoop
		
            If Not $_okayExtractData Then
                ; check the output's heading
				; support for:
				; - english
				; - italian XP
				; - italian Vista
                If StringRegExp( $_outputLines[$idx], "(?i)disk ###[ ]+status[ ]+size[ ]+free[ ]+dyn[ ]+gpt", 0 ) or _ 
					StringRegExp( $_outputLines[$idx], "(?i)disco n[.][ ]+stato[ ]+dim[.][ ]+libera[ ]+din[ ]+gpt", 0 ) or _ 
					StringRegExp( $_outputLines[$idx], "(?i)disk ###[ ]+stato[ ]+dim[.][ ]+libera[ ]+din[ ]+gpt", 0 )Then	
                    If $idx + 1 <= $_outputLines[0] Then
						; if the next row is less or equal then row count, it's all OK
						$_okayExtractData = True
                        $idx += 1
                    EndIf
                EndIf
            Else
                ;  Disk ###  Status      Size     Free     Dyn  Gpt
                ;  --------  ----------  -------  -------  ---  ---
                ;12345678901234567890123456789012345678901234567890123456789012345678901234567890
                ;         1         2         3         4         5         6         7         8  
				; lenght of the single string may be different. This lenght is perfect on italian
                $_tmpDiskArray[ $_diskCount ][0] = StringStripWS( StringMid( $_outputLines[$idx],  8,  3 ), 3 )  ; Disk ###
                $_tmpDiskArray[ $_diskCount ][1] = StringStripWS( StringMid( $_outputLines[$idx], 13, 10 ), 3 )  ; Status
                $_tmpDiskArray[ $_diskCount ][2] = StringStripWS( StringMid( $_outputLines[$idx], 25,  12 ), 3 )  ; Size
                $_tmpDiskArray[ $_diskCount ][3] = StringStripWS( StringMid( $_outputLines[$idx], 39,  12 ), 3 )  ; Free
                $_tmpDiskArray[ $_diskCount ][4] = StringStripWS( StringMid( $_outputLines[$idx], 53,  3 ), 3 )  ; Dyn
                $_tmpDiskArray[ $_diskCount ][5] = StringStripWS( StringMid( $_outputLines[$idx], 58,  3 ), 3 )  ; Gpt
                $_diskCount += 1
				
            EndIf
        Next
        $disks = $emptyDiskArray
		$_diskCount-=1
        If $_okayExtractData Then
            If $_diskCount > 0 Then
                ReDim $_tmpDiskArray[ $_diskCount][6]
                $disks = $_tmpDiskArray
            EndIf
            Return SetError( 0, 0, __dpSafeReturn( $_diskCount, $_pHandle ) )
        Else 
			_FileWriteLog($logfile,"Impossibile fetch data from std_out")
            Return SetError( 1, $_DP_ErrorCode_UnexpectedCommandOutput, __dpSafeReturn( , $_pHandle ) )
        EndIf
    EndIf
    Return SetError( 1, $_DP_ErrorCode_UnknownFailure, __dpSafeReturn( , $_pHandle ) )
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
    
    If Not ProcessExists( $pid ) Then 
		; the process does not exist so I set the error
		Return SetError( 1, $_DP_ErrorCode_InvalidProcessID, 0 )
	endif
    Local Const $ListVolumeCommand = 'list volume' & @CRLF
    Local $emptyVolumeArray[1][8] = [["","","","","","","",""]]
    
    Local $_output = "", _
          $_pHandle = _Win32OpenProcess( $pid )
	; empty buffer
    StdoutRead($pid)
	; run command
    __dpIssueCommand( $pid, $ListVolumeCommand, $_output )
	If @error Then 
		; run fail
		$volumes = $emptyVolumeArray
		Return SetError( @error, @extended,__dpSafeReturn( 0, $_pHandle ) )
	endif
	if $verbose then
		; if the verbose mode is on, I'll log everythings
		_FileWriteLog($logfile,$ListVolumecommand)
		_FileWriteLog($logfile,$_output)
	endif
    Local $_outputLines, $_okayExtractData = False
    Local $_volumeCount = 0, _
          $_tmpVolumeArray[63][8] = [["","","","","","","",""]]
          
    $_outputLines = StringSplit( $_output, @LF )
    If Not @error Then
        
        For $idx = 1 To $_outputLines[0]
            
            If StringStripWS( $_outputLines[$idx], 3 ) = "" Or _
               StringInStr( $_outputLines[$idx], "diskpart>" ) Then ContinueLoop
            
            If Not $_okayExtractData Then
				; check the output's heading
				; support for:
				; - english
				; - italian Vista
				; - italian XP
                If StringRegExp( $_outputLines[$idx], "(?i)volume ###[ ]+ltr[ ]+label[ ]+fs[ ]+type[ ]+size[ ]+status[ ]+info", 0 ) or _
					StringRegExp( $_outputLines[$idx], "(?i)volume ###[ ]+let[.][ ]+etichetta[ ]+fs[ ]+tipo[ ]+dim[.][ ]+stato[ ]+info", 0 ) or _
					StringRegExp( $_outputLines[$idx], "(?i)volume n[.][ ]+lett[.][ ]+etichetta[ ]+fs[ ]+tipo[ ]+dim[.][ ]+stato[ ]+info", 0 ) Then					
                    If $idx + 1 <= $_outputLines[0] Then
						; if the next row is less or equal then row count, it's all OK
                        $_okayExtractData = True
                        $idx += 1
                    EndIf
                EndIf
                
            Else
                
                ;  Volume ###  Ltr  Label        Fs     Type        Size     Status     Info
                ;  ----------  ---  -----------  -----  ----------  -------  ---------  --------                    
                ;12345678901234567890123456789012345678901234567890123456789012345678901234567890
                ;         1         2         3         4         5         6         7         8  
				; lenght of the single string may be different. This lenght is perfect on italian
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
		$_volumeCount-=1
        If $_okayExtractData Then
            If $_volumeCount > 0 Then
                ReDim $_tmpVolumeArray[ $_volumeCount ][8]
                $volumes = $_tmpVolumeArray
            EndIf
        
            Return SetError( 0, 0, __dpSafeReturn( $_volumeCount, $_pHandle ) )
        Else
            Return SetError( 1, $_DP_ErrorCode_UnexpectedCommandOutput, __dpSafeReturn( 0, $_pHandle ))
        EndIf
    EndIf
    
    Return SetError( 1, $_DP_ErrorCode_UnknownFailure, __dpSafeReturn( 0, $_pHandle ))
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
    
    If Not ProcessExists( $pid ) Then
		; the process does not exist so I set the error
		Return SetError( 1, $_DP_ErrorCode_InvalidProcessID, 0 )
	endif
    Local Const $ListPartitionCommand = 'list partition' & @CRLF
    Local $emptyPartitionArray[1][4] = [["","","",""]]
    
    Local $_output = "", _
          $_pHandle = _Win32OpenProcess( $pid )
    StdoutRead($pid)
    __dpIssueCommand( $pid, $ListPartitionCommand, $_output )
	If @error Then 
		; run fail
		$volumes = $emptyPartitionArray
		Return SetError( @error, @extended,__dpSafeReturn( 0, $_pHandle ) )
	endif
	if $verbose then
		; if the verbose mode is on, I'll log everythings
		_FileWriteLog($logfile,$ListPartitioncommand)
		_FileWriteLog($logfile,$_output)
	endif
    ;
    ; did command fail because the focus wan't set?
    ;
    If StringRegExp( $_output, "(?i)select a disk and try again", 0 ) Then
        $disks = $emptyPartitionArray
        Return __dpSafeReturn( SetError( 1, $_DP_ErrorCode_InvalidTargetFocus, 0 ), $_pHandle )
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
				; check the output's heading
				; support for:
				; - english
				; - italian Vista			
                If StringRegExp( $_outputLines[$idx], "(?i)partition ###[ ]+type[ ]+size[ ]+offset", 0 ) or _
					StringRegExp( $_outputLines[$idx], "(?i)partition ###[ ]+tipo[ ]+dim[.][ ]+offset", 0 ) Then 
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
				; lenght of the single string may be different. This lenght is perfect on italian
                $_tmpPartitionArray[ $_partitionCount ][0] = StringStripWS( StringMid( $_outputLines[$idx], 13,  3 ), 3 )  ; Partition ###
                $_tmpPartitionArray[ $_partitionCount ][1] = StringStripWS( StringMid( $_outputLines[$idx], 18, 16 ), 3 )  ; Type
                $_tmpPartitionArray[ $_partitionCount ][2] = StringStripWS( StringMid( $_outputLines[$idx], 36,  8 ), 3 )  ; Size
                $_tmpPartitionArray[ $_partitionCount ][3] = StringStripWS( StringMid( $_outputLines[$idx], 46,  8 ), 3 )  ; Offset
  
                $_partitionCount += 1
            EndIf
        Next
        
        $partitions = $emptyPartitionArray
		$_partitionCount -= 1
        If $_okayExtractData Then
            If $_partitionCount > 0 Then
                ReDim $_tmpPartitionArray[ $_partitionCount ][6]
                $partitions = $_tmpPartitionArray
            EndIf
        
            Return SetError( 0, 0, __dpSafeReturn( $_partitionCount, $_pHandle ) )
        Else
            Return SetError( 1, $_DP_ErrorCode_UnexpectedCommandOutput, __dpSafeReturn( 0, $_pHandle ) )
        EndIf
    EndIf
    
    Return SetError( 1, $_DP_ErrorCode_UnknownFailure, __dpSafeReturn( 0, $_pHandle ) )
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
    
    If Not ProcessExists( $pid ) Then 
		Return SetError( 1, $_DP_ErrorCode_InvalidProcessID, 0 )
	endif

    Local Const $SelectDiskCommand = 'select disk ' & $disk & @CRLF
    Local $_output = "", _
          $_pHandle = _Win32OpenProcess( $pid )
    StdoutRead($pid)
    __dpIssueCommand( $pid, $SelectDiskCommand, $_output )
	If @error Then 
		; run fail
		Return SetError( @error, @extended,__dpSafeReturn( 0, $_pHandle ) )
	endif
	if $verbose then
		; if the verbose mode is on, I'll log everythings
		_FileWriteLog($logfile,$SelectDiskcommand)
		_FileWriteLog($logfile,$_output)
	endif
    
	; Support For
	; - english
	; - italian
    ;
    ; did we fail with an invalid disk id?
    ;
    If StringRegExp( $_output, "(?i)disk you specified is not valid", 0 ) or _ 
		StringRegExp( $_output, "(?i)il disco specificato non . valido", 0 ) Then
        Return SetError( 1, $_DP_ErrorCode_InvalidDiskNumber, __dpSafeReturn(0 , $_pHandle ) )
    EndIf
    ;
    ; one last check to make sure it worked
    ;
    If Not StringRegExp( $_output, "(?i)disk \d+ is now the selected disk", 0 ) and _ 
		not StringRegExp( $_output, "(?i)il disco attualmente selezionato . il disco \d+", 0 ) Then
		; la lettera è non va bene, è speciale, per cui metto un puntino
        Return SetError( 1, $_DP_ErrorCode_InvalidDiskNumber, __dpSafeReturn( 0, $_pHandle ) )
    EndIf
    ;
    ; sweet success
    ;
    Return SetError( 0, 0, __dpSafeReturn( $disk, $_pHandle ) )
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
    
    If Not ProcessExists( $pid ) Then 
		Return SetError( 1, $_DP_ErrorCode_InvalidProcessID, 0 )
	endif
    Local Const $SelectDiskCommand = 'select disk' & @CRLF
    Local $_output = "", _
          $_pHandle = _Win32OpenProcess( $pid )
    StdoutRead($pid)
    __dpIssueCommand( $pid, $SelectDiskCommand, $_output )
	If @error Then 
		; run fail
		$disks = $emptyDiskArray
		Return SetError( @error, @extended,__dpSafeReturn( 0, $_pHandle ) )
	endif
	if $verbose then
		; if the verbose mode is on, I'll log everythings
		_FileWriteLog($logfile,$SelectDiskCommand)
		_FileWriteLog($logfile,$_output)
	endif
    
    Local $_m = StringRegExp( $_output, "(?i)disk (\d+) is now the selected disk", 1 )
    If @error Then Return SetError( 1, $_DP_ErrorCode_InvalidDiskNumber,__dpSafeReturn( 0, $_pHandle ) )
    ;
    ; sweet success
    ;
    Return SetError( 0, 0, __dpSafeReturn( $_m[0], $_pHandle ) )
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
    If Not ProcessExists( $pid ) Then Return SetError( 1, $_DP_ErrorCode_InvalidProcessID, 0 )
    Local Const $SelectVolumeCommand = 'select volume ' & $volume & @CRLF
    Local $_output = "", _
          $_pHandle = _Win32OpenProcess( $pid )
    StdoutRead($pid)
    __dpIssueCommand( $pid, $SelectVolumeCommand, $_output )
    If @error Then 
		; run fail
		Return SetError( @error, @extended,__dpSafeReturn( 0, $_pHandle ) )
	endif
	if $verbose then
		; if the verbose mode is on, I'll log everythings
		_FileWriteLog($logfile,$SelectVolumeCommand)
		_FileWriteLog($logfile,$_output)
	endif
	; Support For
	; - english
	; - italian
    ; did we fail with an invalid volume id?
    If StringRegExp( $_output, "(?i)there is no volume selected", 0 ) or _			 
		StringRegExp( $_output, "(?i)non . stato selezionato alcun volume", 0 )Then 
        Return SetError( 1, $_DP_ErrorCode_InvalidVolumeNumber, __dpSafeReturn( 0, $_pHandle ) )
    EndIf
    ; one last check to make sure it worked
    If Not StringRegExp( $_output, "(?i)volume \d+ is the selected volume", 0 ) and _ 
		not StringRegExp( $_output, "(?i)il volume attualmente selezionato . il volume \d+", 0 ) Then 
        Return SetError( 1, $_DP_ErrorCode_InvalidVolumeNumber, __dpSafeReturn( 0, $_pHandle ) )
    EndIf
    ; sweet success
    Return SetError( 0, 0, __dpSafeReturn( $volume, $_pHandle ) )
EndFunc

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
    
    If Not ProcessExists( $pid ) Then Return SetError( 1, $_DP_ErrorCode_InvalidProcessID, 0 )

    Local Const $SelectVolumeCommand = 'select volume' & @CRLF
    Local $_output = "", _
          $_pHandle = _Win32OpenProcess( $pid )
    StdoutRead($pid)
    __dpIssueCommand( $pid, $SelectVolumeCommand, $_output )
    If @error Then 
		; run fail
		Return SetError( @error, @extended,__dpSafeReturn( 0, $_pHandle ) )
	endif
	if $verbose then
		; if the verbose mode is on, I'll log everythings
		_FileWriteLog($logfile,$SelectVolumeCommand)
		_FileWriteLog($logfile,$_output)
	endif
    
    Local $_m = StringRegExp( $_output, "(?i)volume (\d+) is the selected volume", 1 )
    If @error Then Return __dpSafeReturn( SetError( 1, $_DP_ErrorCode_InvalidVolumeNumber, 0 ), $_pHandle )
    ;
    ; sweet success
    ;
    Return __dpSafeReturn( SetError( 0, 0, $_m[0] ), $_pHandle )
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

    If Not ProcessExists( $pid ) Then Return SetError( 1, $_DP_ErrorCode_InvalidProcessID, 0 )

    Local Const $SelectPartitionCommand = 'select partition ' & $partition & @CRLF
    Local $_output = "", _
          $_pHandle = _Win32OpenProcess( $pid )
    StdoutRead($pid)
    __dpIssueCommand( $pid, $SelectPartitionCommand, $_output )
    If @error Then 
		; run fail
		Return SetError( @error, @extended,__dpSafeReturn( 0, $_pHandle ) )
	endif
	if $verbose then
		; if the verbose mode is on, I'll log everythings
		_FileWriteLog($logfile,$SelectPartitionCommand)
		_FileWriteLog($logfile,$_output)
	endif
    ; Support For
	; - english
	; - italian
    ;
    ; did we fail because no disk currently was in-focus?
    ;
    If StringRegExp( $_output, "(?i)select a disk and try again", 0 ) or _ 
		StringRegExp( $_output, "(?i)selezionare un disco e riprovare", 0 ) Then 
        Return SetError( 1, $_DP_ErrorCode_InvalidTargetFocus, __dpSafeReturn( 0, $_pHandle ))
    EndIf
    ;
    ; did we fail with an invalid partition number?
    ;
    If StringRegExp( $_output, "(?i)please select a valid partition", 0 ) or _
		StringRegExp( $_output, "(?i)selezionare una partizione valida", 0 ) Then 
        Return SetError( 1, $_DP_ErrorCode_InvalidPartitionNumber, __dpSafeReturn( , $_pHandle ))
    EndIf
    ;
    ; one last check to make sure it worked
    ;
    If Not StringRegExp( $_output, "(?i)partition \d+ is now the selected partition", 0 ) and _
		not StringRegExp( $_output, "(?i)la partizione attualmente selezionata . la partizione \d+", 0 )Then
        Return SetError( 1, $_DP_ErrorCode_InvalidPartitionNumber, __dpSafeReturn( 0, $_pHandle ))
    EndIf
    ;
    ; sweet success
    ;
    Return SetError( 0, 0, __dpSafeReturn(  $partition, $_pHandle ))
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

    If Not ProcessExists( $pid ) Then Return SetError( 1, $_DP_ErrorCode_InvalidProcessID, 0 )

    Local Const $SelectPartitionCommand = 'select partition' & @CRLF
    Local $_output = "", _
          $_pHandle = _Win32OpenProcess( $pid )
    StdoutRead($pid)
    __dpIssueCommand( $pid, $SelectPartitionCommand, $_output )
	If @error Then 
		; run fail
		Return SetError( @error, @extended,__dpSafeReturn( 0, $_pHandle ) )
	endif
	if $verbose then
		; if the verbose mode is on, I'll log everythings
		_FileWriteLog($logfile,$SelectPartitionCommand)
		_FileWriteLog($logfile,$_output)
	endif
    
    ;
    ; did we fail because no disk currently was in-focus?
    ;
    If StringRegExp( $_output, "(?i)select a disk and try again", 0 )or _
		StringRegExp( $_output, "(?i)selezionare un disco e riprovare", 0 ) Then
        Return SetError( 1, $_DP_ErrorCode_InvalidPartitionNumber, __dpSafeReturn( 0, $_pHandle ) )
    EndIf
    
    Local $_m = StringRegExp( $_output, "(?i)partition (\d+) is now the selected partition", 1 )
    If @error Then Return SetError( 1, $_DP_ErrorCode_InvalidPartitionNumber, __dpSafeReturn( 0, $_pHandle ) )
    ;
    ; sweet success
    ;
    Return SetError( 0, 0, __dpSafeReturn( $_m[0], $_pHandle ) )
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
    
    If Not ProcessExists( $pid ) Then 
		Return SetError( 1, $_DP_ErrorCode_InvalidProcessID, 0 )
	endif
    Local Const $DetailDiskCommand = 'detail disk' & @CRLF
    Local $emptyDetailArray[6] = ["","","","","",""], $emptyVolumeArray[1][8] = [["","","","","","","",""]]
    
    Local $_output = "", _
          $_pHandle = _Win32OpenProcess( $pid )
	$details = $emptyDetailArray
	$volumes = $emptyVolumeArray
    _DiskpartCurrentDisk( $pid )  ; make sure we have a valid focus
    If @error Then Return SetError( @error, @extended, __dpSafeReturn( 0, $_pHandle ))
 	StdoutRead($pid)
    __dpIssueCommand( $pid, $DetailDiskCommand, $_output )
	If @error Then 
		; run fail
		
		Return SetError( @error, @extended,__dpSafeReturn( 0, $_pHandle ) )
	endif
	if $verbose then
		; if the verbose mode is on, I'll log everythings
		_FileWriteLog($logfile,$DetailDiskCommand)
		_FileWriteLog($logfile,$_output)
	endif
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
                    ; support for:
					; - english
					; - italian Vista
					; - italian XP
                    If StringRegExp( $_outputLines[$idx], "(?i)volume[ ]###[ ]+ltr[ ]+label[ ]+fs[ ]+type[ ]+size[ ]+status[ ]+info", 0 )  or _
					StringRegExp( $_outputLines[$idx], "(?i)volume ###[ ]+let[.][ ]+etichetta[ ]+fs[ ]+tipo[ ]+dim[.][ ]+stato[ ]+info", 0 ) or _
					StringRegExp( $_outputLines[$idx], "(?i)volume n[.][ ]+lett[.][ ]+etichetta[ ]+fs[ ]+tipo[ ]+dim[.][ ]+stato[ ]+info", 0 )Then 
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
        
            Return SetError( 0, 0, __dpSafeReturn( $_volumeCount, $_pHandle ) )
        Else
            Return SetError( 1, $_DP_ErrorCode_UnexpectedCommandOutput,__dpSafeReturn(  0, $_pHandle ) )
        EndIf
    EndIf
    
    Return SetError( 1, $_DP_ErrorCode_UnknownFailure, __dpSafeReturn( 0, $_pHandle ) )
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
    
    If Not ProcessExists( $pid ) Then Return SetError( 1, $_DP_ErrorCode_InvalidProcessID, 0 )

    Local Const $DetailVolumeCommand = 'detail volume' & @CRLF
    Local $emptyDiskArray[1][6] = [["","","","","",""]]
    
    Local $_output = "", _
          $_pHandle = _Win32OpenProcess( $pid )

	$disks = $emptyDiskArray
	StdoutRead($pid)
    __dpIssueCommand( $pid, $DetailVolumeCommand, $_output )
  
    If @error Then 
		; run fail
		Return SetError( @error, @extended,__dpSafeReturn( 0, $_pHandle ) )
	endif
	if $verbose then
		; if the verbose mode is on, I'll log everythings
		_FileWriteLog($logfile,$DetailVolumeCommand)
		_FileWriteLog($logfile,$_output)
	endif
    ;
    ; did we fail because no volume has focus
    ;
    If StringRegExp( $_output, "(?i)there is no volume selected", 0 ) Then
        Return SetError( 1, $_DP_ErrorCode_InvalidTargetFocus, __dpSafeReturn( 0, $_pHandle ) )
    EndIf
    ;
    ; did we fail because no disks are associated with the volume?
    ;
    If StringRegExp( $_output, "(?i)there are no disks attached to this volume", 0 ) Then
        Return SetError( 0, 0, __dpSafeReturn( 0, $_pHandle ) )  ; return success and zero disks
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
                
                If StringRegExp( $_outputLines[$idx], "(?i)disk ###[ ]+status[ ]+size[ ]+free[ ]+dyn[ ]+gpt", 0 ) or _
					StringRegExp( $_outputLines[$idx], "(?i)disk ###[ ]+stato[ ]+dim[.][ ]+libera[ ]+din[ ]+gpt", 0 )Then
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
        
            Return SetError( 0, 0, __dpSafeReturn($_diskCount,  $_pHandle ) )
        Else
            Return SetError( 1, $_DP_ErrorCode_UnexpectedCommandOutput,  __dpSafeReturn( 0, $_pHandle ))
        EndIf
    EndIf
    
    Return SetError( 1, $_DP_ErrorCode_UnknownFailure, __dpSafeReturn( 0, $_pHandle ) )
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
;;ù

Func _DiskpartDetailPartition( $pid, ByRef $details, ByRef $volumes )
    
    If Not ProcessExists( $pid ) Then 
		Return SetError( 1, $_DP_ErrorCode_InvalidProcessID, 0 )
	endif
    Local Const $DetailPartitionCommand = 'detail partition' & @CRLF
    Local $emptyDetailArray[4] = ["","","",""], $emptyVolumeArray[1][8] = [["","","","","","","",""]]
    
    Local $_output = "", _
          $_pHandle = _Win32OpenProcess( $pid )

    $details = $emptyDetailArray
    $volumes = $emptyVolumeArray
	StdoutRead($pid)
    __dpIssueCommand( $pid, $DetailPartitionCommand, $_output )
   If @error Then 
		; run fail
		Return SetError( @error, @extended,__dpSafeReturn( 0, $_pHandle ) )
	endif
	if $verbose then
		; if the verbose mode is on, I'll log everythings
		_FileWriteLog($logfile,$DetailPartitionCommand)
		_FileWriteLog($logfile,$_output)
	endif
    ;
    ; did we fail because there is no in-focus disk?
    ;
    If StringRegExp( $_output, "(?i)there is no disk selected", 0 ) or _ 
		StringRegExp( $_output, "(?i)nessun volume selezionato", 0 ) Then
        Return __dpSafeReturn( SetError( 1, $_DP_ErrorCode_InvalidTargetFocus, 0 ), $_pHandle )
    EndIf
    ;
    ; did we fail because there is no in-focus partition?
    ;
    If StringRegExp( $_output, "(?i)there is no partition selected", 0 ) or StringRegExp( $_output, "(?i)nessuna partizione selezionata", 0 ) Then	; english OR italiano
        Return __dpSafeReturn( SetError( 1, $_DP_ErrorCode_InvalidTargetFocus, 0 ), $_pHandle )
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
                    
                    If StringRegExp( $_outputLines[$idx], "(?i)volume[ ]###[ ]+ltr[ ]+label[ ]+fs[ ]+type[ ]+size[ ]+status[ ]+info", 0 ) or _ 
					StringRegExp( $_outputLines[$idx], "(?i)volume ###[ ]+let[.][ ]+etichetta[ ]+fs[ ]+tipo[ ]+dim[.][ ]+stato[ ]+info", 0 ) or _ 
					StringRegExp( $_outputLines[$idx], "(?i)volume n[.][ ]+lett[.][ ]+etichetta[ ]+fs[ ]+tipo[ ]+dim[.][ ]+stato[ ]+info", 0 )Then	
                        $_okayExtractData = True
                        $idx += 1
                    Else
                        If StringInStr( $_outputLines[$idx], "partition" ) or _ 
							StringInStr( $_outputLines[$idx], "partizione" )Then
                            $_tmpDetailArray[0] = StringStripWS( StringMid( $_outputLines[$idx], 11 ), 3 )
                            $_insideDetails = True
                        EndIf
                    EndIf
                    
                Else
                    If StringInStr( $_outputLines[$idx], "active" ) or _ 
						StringInStr( $_outputLines[$idx], "attiva" ) Then 
						$_insideDetails = False
					EndIf
					
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
        
            Return __dpSafeReturn( SetError( 0, 0, $_volumeCount ), $_pHandle )
        Else
            Return __dpSafeReturn( SetError( 1, $_DP_ErrorCode_UnexpectedCommandOutput, 0 ), $_pHandle )
        EndIf
    EndIf
    
    Return __dpSafeReturn( SetError( 1, $_DP_ErrorCode_UnknownFailure, 0 ), $_pHandle )
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
	; verifico la correttezza del $pid, se è sbagliato imposto l'errore
	; $pid is correct?if no I set error
    If Not isInt( $pid ) Or Not ProcessExists( $pid ) Then Return SetError( 1, $_DP_ErrorCode_InvalidProcessID, 0 )
    Local $_pHandle = _Win32OpenProcess( $pid )
	; scrivo il comando da eseguire nella Shell
	; write command to execute in the shell
    __dpWriteCommand( $pid, $cmd )
	; se errore chiudo tutto
	; if error I'll close everythings
    If @error Then Return SetError( 1, @extended, __dpSafeReturn( 0, $_pHandle ) )
	; leggo l'output del comando
	; read the output of the command
    __dpReadCommandOutput( $pid, $output )
	
    If @error Then
        If @extended <> $_DP_ErrorCode_UnexpectedTermination Then 
            Return SetError( 1, @extended, __dpSafeReturn( 0, $_pHandle ) )
        EndIf
        ;
        ; before returning an unexpected termination error check to see that diskpart
        ; was not closing down normally (ie., user may have issued the exit command)
        ;
        If StringRegExp( $output, "(?i)leaving diskpart", 0 ) Then 
            ; treat normal program termination as success
            SetError( 0, 0, __dpSafeReturn(1,  $_pHandle ))  
        Else    
            ; otherwise looks like diskpart really did close rather sudden
            Return SetError( 1, $_DP_ErrorCode_UnexpectedTermination, __dpSafeReturn( 0, $_pHandle ) )
        EndIf
    EndIf
    ;
    ; check to see if diskpart accepted the command. when it encounters an
    ; unknown command it prints out a standard header and list of commands 
    ;

    If StringRegExp( $output, "(?i)microsoft diskpart versione \d+\.\d+\.\d+", 0 ) Then

		
        ;
        ; special case - if the copyright header is present we are looking
        ; at the first bit of output generated by diskpart and the above
        ; match should be ignored
        ;	
        If StringRegExp( $output, "(?i)copyright", 0 ) Then 
			Return __dpSafeReturn( SetError( 0, 0, 1 ), $_pHandle )
        EndIf
		;
        ; looks like diskpart showed us its command help, return failure
        ;
        Return SetError( 1, $_DP_ErrorCode_UnrecognizedCommand, __dpSafeReturn( 0, $_pHandle )	 )
		
    EndIf
    ;
    ; success - atleast as far as we are concerned. calling function should check for 
    ; additional clues in the output before accepting that the command call was
    ; truely successful
    ;
    Return __dpSafeReturn( SetError( 0, 0, 1 ), $_pHandle )
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
    
    If Not ProcessExists( $pid ) Then Return SetError( 1, $_DP_ErrorCode_InvalidProcessID, 0 )

    If String($cmd) <> "" Then StdinWrite( $pid, $cmd )
    If @error Then Return SetError( 1, $_DP_ErrorCode_StdinStreamError, 0 )

    Return SetError( 0, 0, 1 )
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
    $output=""
    If Not ProcessExists( $pid ) Then Return SetError( 1, $_DP_ErrorCode_InvalidProcessID, 0 )
    While ProcessExists( $pid )
		
        If @error Then Return SetError( 1, $_DP_ErrorCode_StdoutStreamError, 0 )
		
            $output = StdoutRead( $pid, true )
            If @error Then 
				Return SetError( 1, $_DP_ErrorCode_StdoutStreamError, 0 )
			EndIf
        ;
        ; We loop until the process terminates or we see the next prompt
        ;
        If StringRegExp( $output, "(?i)diskpart>", 0 ) Then
			; l'esecuzione del comando è terminata per cui tolgo il prompt e termino la funzione,
			; in $output ci sarà il risultato
			$output=StringRegExpReplace($output,"(?i)diskpart>",0)
			Return SetError( 0, 0, 1 )
		EndIf
    WEnd
    ;
    ; its up to the calling code to determine if this was really unexpected or not
    ; since we don't make any assumptions about the commands being issued
    ;
	
    Return SetError( 1, $_DP_ErrorCode_UnexpectedTermination, 0 )
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
;; Remarks      : preserves values previously set by SetError and __dpSetExtendedError on entry
;;
Func __dpSafeReturn( $rc, $handle = Default )
    
    If Not $handle = Default And $handle <> 0 Then
        Local $tcode = _Win32GetExitCodeProcess( $handle )
		
        If Not @error Then
            $__DP_InternalAPI_ProcessTerminationCode = $tcode  ; STILL_ACTIVE (259) - trapped in _DiskpartTerminationCode
        Else
            $__DP_InternalAPI_ProcessTerminationCode = $_DP_ProcessExitCode_CouldNotRetrieveExitCode
        EndIf
        _Win32CloseHandle( $handle )
    EndIf
	return $rc
EndFunc

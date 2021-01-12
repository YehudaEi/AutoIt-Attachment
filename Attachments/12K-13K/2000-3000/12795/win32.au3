;;
;; win32.au3
;; Useful win32 api functions
;;
;; 5 Jan 2007 by Michael Roach
;; Send bug reports and comments to dem3tre@gmail.com
;;
;; -+ History +--------------------------------------------------------------
;;
;; 1/03/2007   added _Win32OpenProcess, _Win32GetExitCodeProcess, _Win32CloseHandle
;; 1/04/2007   added _Win32GetLastError, _Win32FormatMessageFromSystem
;; 1/05/2007   fixed Potential resource leak in _Win32FormatMessageFromSystem
;; 

#include-once
#include <misc.au3>

Global Enum _; process-status codes
        $WIN32_STILL_ACTIVE                      = 259

Global Enum _; process-specific access rights
        $WIN32_PROCESS_ALL_ACCESS                = 0x1F0FFF, _ ; All possible access rights for a process object.
        $WIN32_PROCESS_CREATE_PROCESS            = 0x0080, _   ; Required to create a process.
        $WIN32_PROCESS_CREATE_THREAD             = 0x0002, _   ; Required to create a thread.
        $WIN32_PROCESS_DUP_HANDLE                = 0x0040, _   ; Required to duplicate a handle using DuplicateHandle.
        $WIN32_PROCESS_QUERY_INFORMATION         = 0x0400, _   ; Required to retrieve certain information about a process, such as its token, exit code, and priority class (see OpenProcessToken, GetExitCodeProcess, GetPriorityClass, and IsProcessInJob).
        $WIN32_PROCESS_QUERY_LIMITED_INFORMATION = 0x1000, _   ; Required to retrieve certain information about a process (see QueryFullProcessImageName).
        $WIN32_PROCESS_SET_QUOTA                 = 0x0100, _   ; Required to set memory limits using SetProcessWorkingSetSize.
        $WIN32_PROCESS_SET_INFORMATION           = 0x0200, _   ; Required to set certain information about a process, such as its priority class (see SetPriorityClass).
        $WIN32_PROCESS_SUSPEND_RESUME            = 0x0800, _   ; Required to suspend or resume a process.
        $WIN32_PROCESS_TERMINATE                 = 0x0001, _   ; Required to terminate a process using TerminateProcess.
        $WIN32_PROCESS_VM_OPERATION              = 0x0008, _   ; Required to perform an operation on the address space of a process (see VirtualProtectEx and WriteProcessMemory).
        $WIN32_PROCESS_VM_READ                   = 0x0010, _   ; Required to read memory in a process using ReadProcessMemory.
        $WIN32_PROCESS_VM_WRITE                  = 0x0020, _   ; Required to write to memory in a process using WriteProcessMemory.
        $WIN32_SYNCHRONIZE                       = 0x00100000  ; Required to wait for the process to terminate using the wait functions.

Global Enum _ ; language identifier related constants
        $WIN32_ERROR_RESOURCE_LANG_NOT_FOUND  = 1815    ; The specified resource language ID cannot be found in the image file

Global Enum _ ; options used in _Win32FormatMessageFromSystem
        $WIN32_FORMAT_MESSAGE_ALLOCATE_BUFFER = 0x00000100, _
        $WIN32_FORMAT_MESSAGE_ARGUMENT_ARRAY  = 0x00002000, _
        $WIN32_FORMAT_MESSAGE_FROM_HMODULE    = 0x00000800, _
        $WIN32_FORMAT_MESSAGE_FROM_STRING     = 0x00000400, _
        $WIN32_FORMAT_MESSAGE_FROM_SYSTEM     = 0x00001000, _
        $WIN32_FORMAT_MESSAGE_IGNORE_INSERTS  = 0x00000200, _
        $WIN32_FORMAT_MESSAGE_MAX_WIDTH_MASK  = 0x000000FF

;;
;; Function     : _Win32OpenProcess
;; Description  : Opens an existing local process object, returning its handle
;; Parameters   : $pid      - Identifier of the local process to open
;; Returns      : Success   - Open handle to the specified process (use _Win32CloseHandle when done!)
;;                Failure   - 0
;;                @ERROR    - non-zero on failure; see @exteneded below
;;                @EXTENDED - GetLastError result code if failure occurred in OpenProcess
;; Remarks      : See http://msdn2.microsoft.com/en-gb/library/ms684320.aspx
;;
Func _Win32OpenProcess( $pid )
    
    Local $result = DllCall( "Kernel32.dll", "hwnd", "OpenProcess", "int", $WIN32_PROCESS_QUERY_INFORMATION, "int", 0, "int", $pid )
    If Not @error Then 
        ; OpenProcess returns NULL (0) when it fails; try to find out why and store in @extended
        If Not $result[0] Then
            Local $rc = _Win32GetLastError()
            Return _Iif( @error, SetError( 1, 0, 0 ), SetError( 1, $rc, 0 ))
        EndIf
        
        Return SetError( 0, 0, $result[0] )
    EndIf
    
    ; DllCall failed
    Return SetError( 1, 0, 0 )
EndFunc

;;
;; Function     : _Win32GetExitCodeProcess
;; Description  : Retrieves the termination status of the specified process. Use
;;                _Win32OpenProcess to get the required handle.
;; Parameters   : $handle   - Handle to the process
;; Returns      : Success   - The process termination status. If the specified process has not 
;;                            yet terminated WIN32_STILL_ACTIVE (259) may be returned.
;;                Failure   - 0
;;                @ERROR    - non-zero on failure; see @extended below
;;                @EXTENDED - GetLastError result code if failure occurred in GetExitCodeProcess
;; Remarks      : The handle must have the WIN32_PROCESS_QUERY_INFORMATION access right.
;;                See http://msdn2.microsoft.com/en-gb/library/ms683189.aspx
;;              
Func _Win32GetExitCodeProcess( $handle )
    
    Local $ptrErrCode
    Local $result = DllCall( "Kernel32.dll", "int", "GetExitCodeProcess", "int", $handle, "int_ptr", $ptrErrCode )
    If Not @error Then
        ; GetExitCodeProcess returns 0 when it fails; try to find out why and store it in @extended
        If Not $result[0] Then
            Local $rc = _Win32GetLastError()
            Return _Iif( @error, SetError( 1, 0, 0 ), SetError( 1, $rc, 0 ))
        EndIf
        
        Return SetError( 0, 0, $result[2] ) ; don't use $ptrErrCode - its not reliably set for some reason
    EndIf
    
    ; DllCall failed
    Return SetError( 1, 0, 0 )
EndFunc

;;
;; Function     : _Win32CloseHandle
;; Description  : Closes an open object handle.
;; Parameters   : $handle   - Object handle to close
;; Returns      : Success   - 1
;;                Failure   - 0
;;                @ERROR    - non-zero on failure; see @extended below
;;                @EXTENDED - GetLastError result code if failure occurred in GetExitCodeProcess
;; Remarks      : See http://msdn2.microsoft.com/en-gb/library/ms724211.aspx
;;
Func _Win32CloseHandle( $handle )
    
    Local $result = DllCall( "Kernel32.dll", "int", "CloseHandle", "int", $handle )
    If Not @error Then
        ; CloseHandle returns 0 when it fails; try to find out why and store it in @extended
        If Not $result[0] Then
            Local $rc = _Win32GetLastError()
            Return _Iif( @error, SetError( 1, 0, 0 ), SetError( 1, $rc, 0 ))
        EndIf
        
        Return SetError( 0, 0, 1 )
    EndIf
    
    ; DllCall failed
    Return SetError( 1, 0, 0 )
EndFunc

;;
;; Function     : _Win32GetLastError
;; Description  : Returns the calling thread's last error code set by SetLastError
;; Parameters   : None
;; Returns      : Success   - GetLastError result
;;                Failure   - see @error 
;;                @ERROR    - If non-zero do not trust the function's return code
;; Remarks      : See http://msdn2.microsoft.com/en-us/library/ms679360.aspx
;;
Func _Win32GetLastError()
    
    Local $result = DllCall( "kernel32.dll", "int", "GetLastError" )
    If Not @error Then Return SetError( 0, 0, $result[0] )
    
    ; DllCall failed
    Return SetError( 1, 0, 0 )
EndFunc

;;
;; Function     : _Win32FormatMessageFromSystem
;; Description  : Calls FormatMessage to search the system message-table resources and 
;;                translate the given message identifier into its textual string.
;; Parameters   : $msgid    - The message identifier you want translated
;;                $langid   - Optional: The language identifer to search
;;                            0 = Default means to search for a message in the following order:
;;                                 1.  Language neutral
;;                                 2. Thread LANGID, based on the thread's locale value
;;                                 3. User default LANGID, based on the user's default locale value
;;                                 4. System default LANGID, based on the system default locale value
;;                                 5. US English
;;                            ? = See http://msdn2.microsoft.com/en-us/library/ms776324.aspx
;; Returns      : Success   - Translated error message string
;;                Failure   - ""
;;                @ERROR    - non-zero on failure; see @extended below
;;                @EXTENDED - GetLastError result code if failure occured in FormatMessage
;; Remarks      : See http://msdn2.microsoft.com/en-us/library/ms679351.aspx
;;
Func _Win32FormatMessageFromSystem( $msgid, $langid = 0 )

    If Not IsInt( $msgid ) Then Return SetError( 1, 0, "" )
    
    ; FormatMessage cannot predict the buffer size needed in advance because of
    ; possible string insertions so just pass a huge buffer instead
    Local $nSize  = 8192
    Local $tmpBfr = DllStructCreate( "char[" & $nSize & "]" )
    If @error Then Return SetError( 1, 0, "" )
        
    Local $result = DllCall( "kernel32.dll", "int", "FormatMessage", _
                             "int", $WIN32_FORMAT_MESSAGE_FROM_SYSTEM + $WIN32_FORMAT_MESSAGE_IGNORE_INSERTS, _ ; dwFlags
                             "ptr", 0, _ ; lpSource
                             "int", $msgid, _ ; dwMessageId
                             "int", $langid, _ ; dwLanguageId
                             "ptr", DllStructGetPtr( $tmpBfr ), _ ; lpBuffer
                             "int", $nSize, _ ; nSize
                             "ptr", 0 ) ; Insertion arguments
    If @error Then ; DllCall failed
        $tmpBfr = 0
        Return SetError( 1, 0, "" )
    EndIf
        
    ; FormatMessage returns 0 when it fails; try to find out why and store it in @extended
    If Not $result[0] Then
        Local $rc = _Win32GetLastError()
        $tmpBfr = 0
        Return _Iif( @error, SetError( 1, 0, "" ), SetError( 1, $rc, "" ))
    EndIf
        
    Local $msg = StringStripWS( DllStructGetData( $tmpBfr, 1 ), 3 )
    $tmpBfr = 0
    Return SetError( 0, 0, $msg )
EndFunc
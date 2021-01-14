Global Const $MOVEFILE_REPLACE_EXISTING = 0x00000001
Global Const $MOVEFILE_COPY_ALLOWED = 0x00000002
Global Const $COPY_FILE_FAIL_IF_EXISTS = 0x00000001

; Transactional NTFS Functions for Windows Vista
;
; All functions return 1 on success and 0 on failure.
; @error is set to the error code returned by the DLL call involved in the function.
;
; _TxfCreateTransaction( [timeout] )
;   Creates a new transaction, returning a handle to be used with other TxF functions.
;   Optionally a timeout can be specified in milliseconds. If the transaction is not
;   committed or rolled back within the timeout, it will be rolled back automatically.
;   Attempting to commit or roll back a transaction that has already timed out will
;   fail with error code 6704.
;
; _TxfRollbackTransaction( txfhandle )
;	Rolls back a transaction. Any file operations that were made in the context of
;   the transaction are thrown out, and the transaction handle is closed. Attempting
;   to roll back a transaction that can't be rolled back (maybe it was already closed)
;   will fail with an error code in the 6700s.
;
; _TxfCommitTransaction( txfhandle )
;   Commits a transaction. All file operations that were made in the context of the
;   transaction are finalized, and the transaction handle is closed. Attempting to
;   commit a transaction that can't be committed (maybe it was already closed) will
;   fail with an error code in the 6700s.
;
; _TxfMoveFile( txfhandle, "src", "dest" [, flag] )
;   Moves a file as part of a transaction. If the flag is set to 1, the destination
;   file will be overwritten if it already exists. If the flag is any other value
;   or is not specified, the function will fail with error code 183 if the destination
;   file already exists. This function CAN move entire directories in one call.
;
; _TxfCopyFile( txfhandle, "src", "dest" [, flag] )
;   Copies a file as part of a transaction. If the flag is set to 1, the destination
;   file will be overwritten if it already exists. If the flag is any other value
;   or is not specified, the function will fail with error code 80 if the destination
;   file already exists. This function CANNOT copy entire directories in one call
;   (it will fail with error code 5 if the specified source is a directory).
;
; _TxfDeleteFile( txfhandle, "file" )
;   Deletes a file as part of a transaction. If the specified file does not exist,
;   the function will fail with error code 2.
;
; _TxfCreateDirectory( txfhandle, "dir" )
;   Creates a directory as part of a transaction. If the directory already exists, the
;   function will fail with error code 183. This function CANNOT create multiple levels
;   of directories in a single call. For instance, if C:\dir1 exists, but C:\dir1\dir2
;   does not exist, attempting to create C:\dir1\dir2\dir3 will fail (error code 3).
;
; _TxfRemoveDirectory( txfhandle, "dir" )
;   Removes a directory as part of a transaction. The specified directory MUST be empty
;   before attempting to remove it, or the function will fail with error code 145.

Func _TxfCreateTransaction($timeout = 0)
	If $timeout = 0 Then
		$ret = DllCall("ktmw32.dll", "int", "CreateTransaction", "ptr", 0, "int", 0, "int", 0, "int", 0, "int", 0, "ptr", 0)
	Else
		$ret = DllCall("ktmw32.dll", "int", "CreateTransaction", "ptr", 0, "int", 0, "int", 0, "int", 0, "int", 0, "int", $timeout)
	EndIf
	Return $ret[0]
EndFunc

Func _TxfRollbackTransaction($txfhandle)
	$ret = DllCall("ktmw32.dll", "int", "RollbackTransaction", "int", $txfhandle)
	If $ret[0] = 0 Then
		$err = DllCall("kernel32.dll", "dword", "GetLastError")
		SetError($err[0])
		Return 0
	Else
		DllCall("kernel32.dll", "int", "CloseHandle", "int", $txfhandle)
		Return 1
	EndIf
EndFunc

Func _TxfCommitTransaction($txfhandle)
	$ret = DllCall("ktmw32.dll", "int", "CommitTransaction", "int", $txfhandle)
	If $ret[0] = 0 Then
		$err = DllCall("kernel32.dll", "dword", "GetLastError")
		SetError($err[0])
		Return 0
	Else
		DllCall("kernel32.dll", "int", "CloseHandle", "int", $txfhandle)
		Return 1
	EndIf
EndFunc

Func _TxfMoveFile($txfhandle, $src, $dest, $flag = 0)
	$struct = DllStructCreate("char[260];char[260]")
	DllStructSetData($struct,1,$src)
	DllStructSetData($struct,2,$dest)
	If $flag = 1 Then
		$ret = DllCall("kernel32.dll", "int", "MoveFileTransacted", "ptr", DllStructGetPtr($struct,1), "ptr", DllStructGetPtr($struct,2), "ptr", 0, "ptr", 0, "dword", BitOR($MOVEFILE_COPY_ALLOWED,$MOVEFILE_REPLACE_EXISTING), "int", $txfhandle)
	Else
		$ret = DllCall("kernel32.dll", "int", "MoveFileTransacted", "ptr", DllStructGetPtr($struct,1), "ptr", DllStructGetPtr($struct,2), "ptr", 0, "ptr", 0, "dword", $MOVEFILE_COPY_ALLOWED, "int", $txfhandle)
	EndIf
	$struct = 0
	If $ret[0] = 0 Then
		$err = DllCall("kernel32.dll", "dword", "GetLastError")
		SetError($err[0])
		Return 0
	Else
		Return 1
	EndIf
EndFunc

Func _TxfCopyFile($txfhandle, $src, $dest, $flag = 0)
	$struct = DllStructCreate("char[260];char[260]")
	DllStructSetData($struct,1,$src)
	DllStructSetData($struct,2,$dest)
	If $flag = 1 Then
		$ret = DllCall("kernel32.dll", "int", "CopyFileTransacted", "ptr", DllStructGetPtr($struct,1), "ptr", DllStructGetPtr($struct,2), "ptr", 0, "ptr", 0, "ptr", 0, "dword", 0, "int", $txfhandle)
	Else
		$ret = DllCall("kernel32.dll", "int", "CopyFileTransacted", "ptr", DllStructGetPtr($struct,1), "ptr", DllStructGetPtr($struct,2), "ptr", 0, "ptr", 0, "ptr", 0, "dword", $COPY_FILE_FAIL_IF_EXISTS, "int", $txfhandle)
	EndIf
	$struct = 0
	If $ret[0] = 0 Then
		$err = DllCall("kernel32.dll", "dword", "GetLastError")
		SetError($err[0])
		Return 0
	Else
		Return 1
	EndIf
EndFunc

Func _TxfDeleteFile($txfhandle, $file)
	$struct = DllStructCreate("char[260]")
	DllStructSetData($struct,1,$file)
	$ret = DllCall("kernel32.dll", "int", "DeleteFileTransacted", "ptr", DllStructGetPtr($struct,1), "int", $txfhandle)
	$struct = 0
	If $ret[0] = 0 Then
		$err = DllCall("kernel32.dll", "dword", "GetLastError")
		SetError($err[0])
		Return 0
	Else
		Return 1
	EndIf
EndFunc

Func _TxfCreateDirectory($txfhandle, $dir)
	$struct = DllStructCreate("char[260]")
	DllStructSetData($struct,1,$dir)
	$ret = DllCall("kernel32.dll", "int", "CreateDirectoryTransacted", "ptr", 0, "ptr", DllStructGetPtr($struct,1), "ptr", 0, "int", $txfhandle)
	$struct = 0
	If $ret[0] = 0 Then
		$err = DllCall("kernel32.dll", "dword", "GetLastError")
		SetError($err[0])
		Return 0
	Else
		Return 1
	EndIf
EndFunc

Func _TxfRemoveDirectory($txfhandle, $dir)
	$struct = DllStructCreate("char[260]")
	DllStructSetData($struct,1,$dir)
	$ret = DllCall("kernel32.dll", "int", "RemoveDirectoryTransacted", "ptr", DllStructGetPtr($struct,1), "int", $txfhandle)
	$struct = 0
	If $ret[0] = 0 Then
		$err = DllCall("kernel32.dll", "dword", "GetLastError")
		SetError($err[0])
		Return 0
	Else
		Return 1
	EndIf
EndFunc
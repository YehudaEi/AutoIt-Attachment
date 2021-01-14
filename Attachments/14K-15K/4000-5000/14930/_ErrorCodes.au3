#cs ----------------------------------------------------------------------------
	DOS Error Level codes.
	ErrorLevel Source:  http://msdn2.microsoft.com/en-us/library/ms681381.aspx
	
	Returns:
		$a[0] = Errorlevel code		(0 = Successful; > 0 = Error)
		$a[1] = Abbrev. Error
		$a[2] = Error Description

#ce ----------------------------------------------------------------------------
Func _ErrorLevelMessage($errorlevel)
	Dim $message[3] = [$errorlevel, '', '']

	Switch $errorlevel
		Case 0
			$message[1] = 'ERROR_SUCCESS'
			$message[2] = 'The operation completed successfully.'

		Case 1
			$message[1] = 'ERROR_INVALID_FUNCTION'
			$message[2] = 'Incorrect function.'

		Case 2
			$message[1] = 'ERROR_FILE_NOT_FOUND'
			$message[2] = 'The system cannot find the file specified.'

		Case 3
			$message[1] = 'ERROR_PATH_NOT_FOUND'
			$message[2] = 'The system cannot find the path specified.'

		Case 4
			$message[1] = 'ERROR_TOO_MANY_OPEN_FILES'
			$message[2] = 'The system cannot open the file.'

		Case 5
			$message[1] = 'ERROR_ACCESS_DENIED'
			$message[2] = 'Access is denied.'

		Case 6
			$message[1] = 'ERROR_INVALID_HANDLE'
			$message[2] = 'The handle is invalid.'

		Case 7
			$message[1] = 'ERROR_ARENA_TRASHED'
			$message[2] = 'The storage control blocks were destroyed.'

		Case 8
			$message[1] = 'ERROR_NOT_ENOUGH_MEMORY'
			$message[2] = 'Not enough storage is available to process this command.'

		Case 9
			$message[1] = 'ERROR_INVALID_BLOCK'
			$message[2] = 'The storage control block address is invalid.'

		Case 10
			$message[1] = 'ERROR_BAD_ENVIRONMENT'
			$message[2] = 'The environment is incorrect.'

		Case 11
			$message[1] = 'ERROR_BAD_FORMAT'
			$message[2] = 'An attempt was made to load a program with an incorrect format.'

		Case 12
			$message[1] = 'ERROR_INVALID_ACCESS'
			$message[2] = 'The access code is invalid.'

		Case 13
			$message[1] = 'ERROR_INVALID_DATA'
			$message[2] = 'The data is invalid.'

		Case 14
			$message[1] = 'ERROR_OUTOFMEMORY'
			$message[2] = 'Not enough storage is available to complete this operation.'

		Case 15
			$message[1] = 'ERROR_INVALID_DRIVE'
			$message[2] = 'The system cannot find the drive specified.'

		Case 16
			$message[1] = 'ERROR_CURRENT_DIRECTORY'
			$message[2] = 'The directory cannot be removed.'

		Case 17
			$message[1] = 'ERROR_NOT_SAME_DEVICE'
			$message[2] = 'The system cannot move the file to a different disk drive.'

		Case 18
			$message[1] = 'ERROR_NO_MORE_FILES'
			$message[2] = 'There are no more files.'

		Case 19
			$message[1] = 'ERROR_WRITE_PROTECT'
			$message[2] = 'The media is write protected.'

		Case 20
			$message[1] = 'ERROR_BAD_UNIT'
			$message[2] = 'The system cannot find the device specified.'

		Case 21
			$message[1] = 'ERROR_NOT_READY'
			$message[2] = 'The device is not ready.'

		Case 22
			$message[1] = 'ERROR_BAD_COMMAND'
			$message[2] = 'The device does not recognize the command.'

		Case 23
			$message[1] = 'ERROR_CRC'
			$message[2] = 'Data error (cyclic redundancy check).'

		Case 24
			$message[1] = 'ERROR_BAD_LENGTH'
			$message[2] = 'The program issued a command but the command length is incorrect.'

		Case 25
			$message[1] = 'ERROR_SEEK'
			$message[2] = 'The drive cannot locate a specific area or track on the disk.'

		Case 26
			$message[1] = 'ERROR_NOT_DOS_DISK'
			$message[2] = 'The specified disk or diskette cannot be accessed.'

		Case 27
			$message[1] = 'ERROR_SECTOR_NOT_FOUND'
			$message[2] = 'The drive cannot find the sector requested.'

		Case 28
			$message[1] = 'ERROR_OUT_OF_PAPER'
			$message[2] = 'The printer is out of paper.'

		Case 29
			$message[1] = 'ERROR_WRITE_FAULT'
			$message[2] = 'The system cannot write to the specified device.'

		Case 30
			$message[1] = 'ERROR_READ_FAULT'
			$message[2] = 'The system cannot read from the specified device.'

		Case 31
			$message[1] = 'ERROR_GEN_FAILURE'
			$message[2] = 'A device attached to the system is not functioning.'

		Case 32
			$message[1] = 'ERROR_SHARING_VIOLATION'
			$message[2] = 'The process cannot access the file because it is being used by another process.'

		Case 33
			$message[1] = 'ERROR_LOCK_VIOLATION'
			$message[2] = 'The process cannot access the file because another process has locked a portion of the file.'

		Case 34
			$message[1] = 'ERROR_WRONG_DISK'
			$message[2] = 'The wrong diskette is in the drive. Insert %2 (Volume Serial Number: %3) into drive %1.'

		Case 36
			$message[1] = 'ERROR_SHARING_BUFFER_EXCEEDED'
			$message[2] = 'Too many files opened for sharing.'

		Case 38
			$message[1] = 'ERROR_HANDLE_EOF'
			$message[2] = 'Reached the end of the file.'

		Case 39
			$message[1] = 'ERROR_HANDLE_DISK_FULL'
			$message[2] = 'The disk is full.'

		Case 50
			$message[1] = 'ERROR_NOT_SUPPORTED'
			$message[2] = 'The request is not supported.'

		Case 51
			$message[1] = 'ERROR_REM_NOT_LIST'
			$message[2] = 'Windows cannot find the network path. Verify that the network path is correct and the destination computer is not busy or turned off. If Windows still cannot find the network path, contact your network administrator.'

		Case 52
			$message[1] = 'ERROR_DUP_NAME'
			$message[2] = 'You were not connected because a duplicate name exists on the network. If joining a domain, go to System in Control Panel to change the computer name and try again. If joining a workgroup, choose another workgroup name.'

		Case 53
			$message[1] = 'ERROR_BAD_NETPATH'
			$message[2] = 'The network path was not found.'

		Case 54
			$message[1] = 'ERROR_NETWORK_BUSY'
			$message[2] = 'The network is busy.'

		Case 55
			$message[1] = 'ERROR_DEV_NOT_EXIST'
			$message[2] = 'The specified network resource or device is no longer available.'

		Case 56
			$message[1] = 'ERROR_TOO_MANY_CMDS'
			$message[2] = 'The network BIOS command limit has been reached.'

		Case 57
			$message[1] = 'ERROR_ADAP_HDW_ERR'
			$message[2] = 'A network adapter hardware error occurred.'

		Case 58
			$message[1] = 'ERROR_BAD_NET_RESP'
			$message[2] = 'The specified server cannot perform the requested operation.'

		Case 59
			$message[1] = 'ERROR_UNEXP_NET_ERR'
			$message[2] = 'An unexpected network error occurred.'

		Case 60
			$message[1] = 'ERROR_BAD_REM_ADAP'
			$message[2] = 'The remote adapter is not compatible.'

		Case 61
			$message[1] = 'ERROR_PRINTQ_FULL'
			$message[2] = 'The printer queue is full.'

		Case 62
			$message[1] = 'ERROR_NO_SPOOL_SPACE'
			$message[2] = 'Space to store the file waiting to be printed is not available on the server.'

		Case 63
			$message[1] = 'ERROR_PRINT_CANCELLED'
			$message[2] = 'Your file waiting to be printed was deleted.'

		Case 64
			$message[1] = 'ERROR_NETNAME_DELETED'
			$message[2] = 'The specified network name is no longer available.'

		Case 65
			$message[1] = 'ERROR_NETWORK_ACCESS_DENIED'
			$message[2] = 'Network access is denied.'

		Case 66
			$message[1] = 'ERROR_BAD_DEV_TYPE'
			$message[2] = 'The network resource type is not correct.'

		Case 67
			$message[1] = 'ERROR_BAD_NET_NAME'
			$message[2] = 'The network name cannot be found.'

		Case 68
			$message[1] = 'ERROR_TOO_MANY_NAMES'
			$message[2] = 'The name limit for the local computer network adapter card was exceeded.'

		Case 69
			$message[1] = 'ERROR_TOO_MANY_SESS'
			$message[2] = 'The network BIOS session limit was exceeded.'

		Case 70
			$message[1] = 'ERROR_SHARING_PAUSED'
			$message[2] = 'The remote server has been paused or is in the process of being started.'

		Case 71
			$message[1] = 'ERROR_REQ_NOT_ACCEP'
			$message[2] = 'No more connections can be made to this remote computer at this time because there are already as many connections as the computer can accept.'

		Case 72
			$message[1] = 'ERROR_REDIR_PAUSED'
			$message[2] = 'The specified printer or disk device has been paused.'

		Case 80
			$message[1] = 'ERROR_FILE_EXISTS'
			$message[2] = 'The file exists.'

		Case 82
			$message[1] = 'ERROR_CANNOT_MAKE'
			$message[2] = 'The directory or file cannot be created.'

		Case 83
			$message[1] = 'ERROR_FAIL_I24'
			$message[2] = 'Fail on INT 24.'

		Case 84
			$message[1] = 'ERROR_OUT_OF_STRUCTURES'
			$message[2] = 'Storage to process this request is not available.'

		Case 85
			$message[1] = 'ERROR_ALREADY_ASSIGNED'
			$message[2] = 'The local device name is already in use.'

		Case 86
			$message[1] = 'ERROR_INVALID_PASSWORD'
			$message[2] = 'The specified network password is not correct.'

		Case 87
			$message[1] = 'ERROR_INVALID_PARAMETER'
			$message[2] = 'The parameter is incorrect.'

		Case 88
			$message[1] = 'ERROR_NET_WRITE_FAULT'
			$message[2] = 'A write fault occurred on the network.'

		Case 89
			$message[1] = 'ERROR_NO_PROC_SLOTS'
			$message[2] = 'The system cannot start another process at this time.'

		Case 100
			$message[1] = 'ERROR_TOO_MANY_SEMAPHORES'
			$message[2] = 'Cannot create another system semaphore.'

		Case 101
			$message[1] = 'ERROR_EXCL_SEM_ALREADY_OWNED'
			$message[2] = 'The exclusive semaphore is owned by another process.'

		Case 102
			$message[1] = 'ERROR_SEM_IS_SET'
			$message[2] = 'The semaphore is set and cannot be closed.'

		Case 103
			$message[1] = 'ERROR_TOO_MANY_SEM_REQUESTS'
			$message[2] = 'The semaphore cannot be set again.'

		Case 104
			$message[1] = 'ERROR_INVALID_AT_INTERRUPT_TIME'
			$message[2] = 'Cannot request exclusive semaphores at interrupt time.'

		Case 105
			$message[1] = 'ERROR_SEM_OWNER_DIED'
			$message[2] = 'The previous ownership of this semaphore has ended.'

		Case 106
			$message[1] = 'ERROR_SEM_USER_LIMIT'
			$message[2] = 'Insert the diskette for drive %1.'

		Case 107
			$message[1] = 'ERROR_DISK_CHANGE'
			$message[2] = 'The program stopped because an alternate diskette was not inserted.'

		Case 108
			$message[1] = 'ERROR_DRIVE_LOCKED'
			$message[2] = 'The disk is in use or locked by another process.'

		Case 109
			$message[1] = 'ERROR_BROKEN_PIPE'
			$message[2] = 'The pipe has been ended.'

		Case 110
			$message[1] = 'ERROR_OPEN_FAILED'
			$message[2] = 'The system cannot open the device or file specified.'

		Case 111
			$message[1] = 'ERROR_BUFFER_OVERFLOW'
			$message[2] = 'The file name is too long.'

		Case 112
			$message[1] = 'ERROR_DISK_FULL'
			$message[2] = 'There is not enough space on the disk.'

		Case 113
			$message[1] = 'ERROR_NO_MORE_SEARCH_HANDLES'
			$message[2] = 'No more internal file identifiers available.'

		Case 114
			$message[1] = 'ERROR_INVALID_TARGET_HANDLE'
			$message[2] = 'The target internal file identifier is incorrect.'

		Case 117
			$message[1] = 'ERROR_INVALID_CATEGORY'
			$message[2] = 'The IOCTL call made by the application program is not correct.'

		Case 118
			$message[1] = 'ERROR_INVALID_VERIFY_SWITCH'
			$message[2] = 'The verify-on-write switch parameter value is not correct.'

		Case 119
			$message[1] = 'ERROR_BAD_DRIVER_LEVEL'
			$message[2] = 'The system does not support the command requested.'

		Case 120
			$message[1] = 'ERROR_CALL_NOT_IMPLEMENTED'
			$message[2] = 'This function is not supported on this system.'

		Case 121
			$message[1] = 'ERROR_SEM_TIMEOUT'
			$message[2] = 'The semaphore timeout period has expired.'

		Case 122
			$message[1] = 'ERROR_INSUFFICIENT_BUFFER'
			$message[2] = 'The data area passed to a system call is too small.'

		Case 123
			$message[1] = 'ERROR_INVALID_NAME'
			$message[2] = 'The filename, directory name, or volume label syntax is incorrect.'

		Case 124
			$message[1] = 'ERROR_INVALID_LEVEL'
			$message[2] = 'The system call level is not correct.'

		Case 125
			$message[1] = 'ERROR_NO_VOLUME_LABEL'
			$message[2] = 'The disk has no volume label.'

		Case 126
			$message[1] = 'ERROR_MOD_NOT_FOUND'
			$message[2] = 'The specified module could not be found.'

		Case 127
			$message[1] = 'ERROR_PROC_NOT_FOUND'
			$message[2] = 'The specified procedure could not be found.'

		Case 128
			$message[1] = 'ERROR_WAIT_NO_CHILDREN'
			$message[2] = 'There are no child processes to wait for.'

		Case 129
			$message[1] = 'ERROR_CHILD_NOT_COMPLETE'
			$message[2] = 'The %1 application cannot be run in Win32 mode.'

		Case 130
			$message[1] = 'ERROR_DIRECT_ACCESS_HANDLE'
			$message[2] = 'Attempt to use a file handle to an open disk partition for an operation other than raw disk I/O.'

		Case 131
			$message[1] = 'ERROR_NEGATIVE_SEEK'
			$message[2] = 'An attempt was made to move the file pointer before the beginning of the file.'

		Case 132
			$message[1] = 'ERROR_SEEK_ON_DEVICE'
			$message[2] = 'The file pointer cannot be set on the specified device or file.'

		Case 133
			$message[1] = 'ERROR_IS_JOIN_TARGET'
			$message[2] = 'A JOIN or SUBST command cannot be used for a drive that contains previously joined drives.'

		Case 134
			$message[1] = 'ERROR_IS_JOINED'
			$message[2] = 'An attempt was made to use a JOIN or SUBST command on a drive that has already been joined.'

		Case 135
			$message[1] = 'ERROR_IS_SUBSTED'
			$message[2] = 'An attempt was made to use a JOIN or SUBST command on a drive that has already been substituted.'

		Case 136
			$message[1] = 'ERROR_NOT_JOINED'
			$message[2] = 'The system tried to delete the JOIN of a drive that is not joined.'

		Case 137
			$message[1] = 'ERROR_NOT_SUBSTED'
			$message[2] = 'The system tried to delete the substitution of a drive that is not substituted.'

		Case 138
			$message[1] = 'ERROR_JOIN_TO_JOIN'
			$message[2] = 'The system tried to join a drive to a directory on a joined drive.'

		Case 139
			$message[1] = 'ERROR_SUBST_TO_SUBST'
			$message[2] = 'The system tried to substitute a drive to a directory on a substituted drive.'

		Case 140
			$message[1] = 'ERROR_JOIN_TO_SUBST'
			$message[2] = 'The system tried to join a drive to a directory on a substituted drive.'

		Case 141
			$message[1] = 'ERROR_SUBST_TO_JOIN'
			$message[2] = 'The system tried to SUBST a drive to a directory on a joined drive.'

		Case 142
			$message[1] = 'ERROR_BUSY_DRIVE'
			$message[2] = 'The system cannot perform a JOIN or SUBST at this time.'

		Case 143
			$message[1] = 'ERROR_SAME_DRIVE'
			$message[2] = 'The system cannot join or substitute a drive to or for a directory on the same drive.'

		Case 144
			$message[1] = 'ERROR_DIR_NOT_ROOT'
			$message[2] = 'The directory is not a subdirectory of the root directory.'

		Case 145
			$message[1] = 'ERROR_DIR_NOT_EMPTY'
			$message[2] = 'The directory is not empty.'

		Case 146
			$message[1] = 'ERROR_IS_SUBST_PATH'
			$message[2] = 'The path specified is being used in a substitute.'

		Case 147
			$message[1] = 'ERROR_IS_JOIN_PATH'
			$message[2] = 'Not enough resources are available to process this command.'

		Case 148
			$message[1] = 'ERROR_PATH_BUSY'
			$message[2] = 'The path specified cannot be used at this time.'

		Case 149
			$message[1] = 'ERROR_IS_SUBST_TARGET'
			$message[2] = 'An attempt was made to join or substitute a drive for which a directory on the drive is the target of a previous substitute.'

		Case 150
			$message[1] = 'ERROR_SYSTEM_TRACE'
			$message[2] = 'System trace information was not specified in your CONFIG.SYS file, or tracing is disallowed.'

		Case 151
			$message[1] = 'ERROR_INVALID_EVENT_COUNT'
			$message[2] = 'The number of specified semaphore events for DosMuxSemWait is not correct.'

		Case 152
			$message[1] = 'ERROR_TOO_MANY_MUXWAITERS'
			$message[2] = 'DosMuxSemWait did not execute; too many semaphores are already set.'

		Case 153
			$message[1] = 'ERROR_INVALID_LIST_FORMAT'
			$message[2] = 'The DosMuxSemWait list is not correct.'

		Case 154
			$message[1] = 'ERROR_LABEL_TOO_LONG'
			$message[2] = 'The volume label you entered exceeds the label character limit of the target file system.'

		Case 155
			$message[1] = 'ERROR_TOO_MANY_TCBS'
			$message[2] = 'Cannot create another thread.'

		Case 156
			$message[1] = 'ERROR_SIGNAL_REFUSED'
			$message[2] = 'The recipient process has refused the signal.'

		Case 157
			$message[1] = 'ERROR_DISCARDED'
			$message[2] = 'The segment is already discarded and cannot be locked.'

		Case 158
			$message[1] = 'ERROR_NOT_LOCKED'
			$message[2] = 'The segment is already unlocked.'

		Case 159
			$message[1] = 'ERROR_BAD_THREADID_ADDR'
			$message[2] = 'The address for the thread ID is not correct.'

		Case 160
			$message[1] = 'ERROR_BAD_ARGUMENTS'
			$message[2] = 'One or more arguments are not correct.'

		Case 161
			$message[1] = 'ERROR_BAD_PATHNAME'
			$message[2] = 'The specified path is invalid.'

		Case 162
			$message[1] = 'ERROR_SIGNAL_PENDING'
			$message[2] = 'A signal is already pending.'

		Case 164
			$message[1] = 'ERROR_MAX_THRDS_REACHED'
			$message[2] = 'No more threads can be created in the system.'

		Case 167
			$message[1] = 'ERROR_LOCK_FAILED'
			$message[2] = 'Unable to lock a region of a file.'

		Case 170
			$message[1] = 'ERROR_BUSY'
			$message[2] = 'The requested resource is in use.'

		Case 173
			$message[1] = 'ERROR_CANCEL_VIOLATION'
			$message[2] = 'A lock request was not outstanding for the supplied cancel region.'

		Case 174
			$message[1] = 'ERROR_ATOMIC_LOCKS_NOT_SUPPORTED'
			$message[2] = 'The file system does not support atomic changes to the lock type.'

		Case 180
			$message[1] = 'ERROR_INVALID_SEGMENT_NUMBER'
			$message[2] = 'The system detected a segment number that was not correct.'

		Case 182
			$message[1] = 'ERROR_INVALID_ORDINAL'
			$message[2] = 'The operating system cannot run %1.'

		Case 183
			$message[1] = 'ERROR_ALREADY_EXISTS'
			$message[2] = 'Cannot create a file when that file already exists.'

		Case 186
			$message[1] = 'ERROR_INVALID_FLAG_NUMBER'
			$message[2] = 'The flag passed is not correct.'

		Case 187
			$message[1] = 'ERROR_SEM_NOT_FOUND'
			$message[2] = 'The specified system semaphore name was not found.'

		Case 188
			$message[1] = 'ERROR_INVALID_STARTING_CODESEG'
			$message[2] = 'The operating system cannot run %1.'

		Case 189
			$message[1] = 'ERROR_INVALID_STACKSEG'
			$message[2] = 'The operating system cannot run %1.'

		Case 190
			$message[1] = 'ERROR_INVALID_MODULETYPE'
			$message[2] = 'The operating system cannot run %1.'

		Case 191
			$message[1] = 'ERROR_INVALID_EXE_SIGNATURE'
			$message[2] = 'Cannot run %1 in Win32 mode.'

		Case 192
			$message[1] = 'ERROR_EXE_MARKED_INVALID'
			$message[2] = 'The operating system cannot run %1.'

		Case 193
			$message[1] = 'ERROR_BAD_EXE_FORMAT'
			$message[2] = '%1 is not a valid Win32 application.'

		Case 194
			$message[1] = 'ERROR_ITERATED_DATA_EXCEEDS_64k'
			$message[2] = 'The operating system cannot run %1.'

		Case 195
			$message[1] = 'ERROR_INVALID_MINALLOCSIZE'
			$message[2] = 'The operating system cannot run %1.'

		Case 196
			$message[1] = 'ERROR_DYNLINK_FROM_INVALID_RING'
			$message[2] = 'The operating system cannot run this application program.'

		Case 197
			$message[1] = 'ERROR_IOPL_NOT_ENABLED'
			$message[2] = 'The operating system is not presently configured to run this application.'

		Case 198
			$message[1] = 'ERROR_INVALID_SEGDPL'
			$message[2] = 'The operating system cannot run %1.'

		Case 199
			$message[1] = 'ERROR_AUTODATASEG_EXCEEDS_64k'
			$message[2] = 'The operating system cannot run this application program.'

		Case 200
			$message[1] = 'ERROR_RING2SEG_MUST_BE_MOVABLE'
			$message[2] = 'The code segment cannot be greater than or equal to 64K.'

		Case 201
			$message[1] = 'ERROR_RELOC_CHAIN_XEEDS_SEGLIM'
			$message[2] = 'The operating system cannot run %1.'

		Case 202
			$message[1] = 'ERROR_INFLOOP_IN_RELOC_CHAIN'
			$message[2] = 'The operating system cannot run %1.'

		Case 203
			$message[1] = 'ERROR_ENVVAR_NOT_FOUND'
			$message[2] = 'The system could not find the environment option that was entered.'

		Case 205
			$message[1] = 'ERROR_NO_SIGNAL_SENT'
			$message[2] = 'No process in the command subtree has a signal handler.'

		Case 206
			$message[1] = 'ERROR_FILENAME_EXCED_RANGE'
			$message[2] = 'The filename or extension is too long.'

		Case 207
			$message[1] = 'ERROR_RING2_STACK_IN_USE'
			$message[2] = 'The ring 2 stack is in use.'

		Case 208
			$message[1] = 'ERROR_META_EXPANSION_TOO_LONG'
			$message[2] = 'The global filename characters, * or ?, are entered incorrectly or too many global filename characters are specified.'

		Case 209
			$message[1] = 'ERROR_INVALID_SIGNAL_NUMBER'
			$message[2] = 'The signal being posted is not correct.'

		Case 210
			$message[1] = 'ERROR_THREAD_1_INACTIVE'
			$message[2] = 'The signal handler cannot be set.'

		Case 212
			$message[1] = 'ERROR_LOCKED'
			$message[2] = 'The segment is locked and cannot be reallocated.'

		Case 214
			$message[1] = 'ERROR_TOO_MANY_MODULES'
			$message[2] = 'Too many dynamic-link modules are attached to this program or dynamic-link module.'

		Case 215
			$message[1] = 'ERROR_NESTING_NOT_ALLOWED'
			$message[2] = 'Cannot nest calls to LoadModule.'

		Case 216
			$message[1] = 'ERROR_EXE_MACHINE_TYPE_MISMATCH'
			$message[2] = 'The version of %1 is not compatible with the version you''re running. Check your computer''s system information to see whether you need a x86 (32-bit) or x64 (64-bit) version of the program, and then contact the software publisher.'

		Case 217
			$message[1] = 'ERROR_EXE_CANNOT_MODIFY_SIGNED_BINARY'
			$message[2] = 'The image file %1 is signed, unable to modify.'

		Case 218
			$message[1] = 'ERROR_EXE_CANNOT_MODIFY_STRONG_SIGNED_BINARY'
			$message[2] = 'The image file %1 is strong signed, unable to modify.'

		Case 220
			$message[1] = 'ERROR_FILE_CHECKED_OUT'
			$message[2] = 'This file is checked out or locked for editing by another user.'

		Case 221
			$message[1] = 'ERROR_CHECKOUT_REQUIRED'
			$message[2] = 'The file must be checked out before saving changes.'

		Case 222
			$message[1] = 'ERROR_BAD_FILE_TYPE'
			$message[2] = 'The file type being saved or retrieved has been blocked.'

		Case 223
			$message[1] = 'ERROR_FILE_TOO_LARGE'
			$message[2] = 'The file size exceeds the limit allowed and cannot be saved.'

		Case 224
			$message[1] = 'ERROR_FORMS_AUTH_REQUIRED'
			$message[2] = 'Access Denied. Before opening files in this location, you must first browse to the web site and select the option to login automatically.'

		Case 225
			$message[1] = 'ERROR_VIRUS_INFECTED'
			$message[2] = 'Operation did not complete successfully because the file contains a virus.'

		Case 226
			$message[1] = 'ERROR_VIRUS_DELETED'
			$message[2] = 'This file contains a virus and cannot be opened. Due to the nature of this virus, the file has been removed from this location.'

		Case 229
			$message[1] = 'ERROR_PIPE_LOCAL'
			$message[2] = 'The pipe is local.'

		Case 230
			$message[1] = 'ERROR_BAD_PIPE'
			$message[2] = 'The pipe state is invalid.'

		Case 231
			$message[1] = 'ERROR_PIPE_BUSY'
			$message[2] = 'All pipe instances are busy.'

		Case 232
			$message[1] = 'ERROR_NO_DATA'
			$message[2] = 'The pipe is being closed.'

		Case 233
			$message[1] = 'ERROR_PIPE_NOT_CONNECTED'
			$message[2] = 'No process is on the other end of the pipe.'

		Case 234
			$message[1] = 'ERROR_MORE_DATA'
			$message[2] = 'More data is available.'

		Case 240
			$message[1] = 'ERROR_VC_DISCONNECTED'
			$message[2] = 'The session was canceled.'

		Case 254
			$message[1] = 'ERROR_INVALID_EA_NAME'
			$message[2] = 'The specified extended attribute name was invalid.'

		Case 255
			$message[1] = 'ERROR_EA_LIST_INCONSISTENT'
			$message[2] = 'The extended attributes are inconsistent.'

		Case 258
			$message[1] = 'WAIT_TIMEOUT'
			$message[2] = 'The wait operation timed out.'

		Case 259
			$message[1] = 'ERROR_NO_MORE_ITEMS'
			$message[2] = 'No more data is available.'

		Case 266
			$message[1] = 'ERROR_CANNOT_COPY'
			$message[2] = 'The copy functions cannot be used.'

		Case 267
			$message[1] = 'ERROR_DIRECTORY'
			$message[2] = 'The directory name is invalid.'

		Case 275
			$message[1] = 'ERROR_EAS_DIDNT_FIT'
			$message[2] = 'The extended attributes did not fit in the buffer.'

		Case 276
			$message[1] = 'ERROR_EA_FILE_CORRUPT'
			$message[2] = 'The extended attribute file on the mounted file system is corrupt.'

		Case 277
			$message[1] = 'ERROR_EA_TABLE_FULL'
			$message[2] = 'The extended attribute table file is full.'

		Case 278
			$message[1] = 'ERROR_INVALID_EA_HANDLE'
			$message[2] = 'The specified extended attribute handle is invalid.'

		Case 282
			$message[1] = 'ERROR_EAS_NOT_SUPPORTED'
			$message[2] = 'The mounted file system does not support extended attributes.'

		Case 288
			$message[1] = 'ERROR_NOT_OWNER'
			$message[2] = 'Attempt to release mutex not owned by caller.'

		Case 298
			$message[1] = 'ERROR_TOO_MANY_POSTS'
			$message[2] = 'Too many posts were made to a semaphore.'

		Case 299
			$message[1] = 'ERROR_PARTIAL_COPY'
			$message[2] = 'Only part of a ReadProcessMemory or WriteProcessMemory request was completed.'

		Case 300
			$message[1] = 'ERROR_OPLOCK_NOT_GRANTED'
			$message[2] = 'The oplock request is denied.'

		Case 301
			$message[1] = 'ERROR_INVALID_OPLOCK_PROTOCOL'
			$message[2] = 'An invalid oplock acknowledgment was received by the system.'

		Case 302
			$message[1] = 'ERROR_DISK_TOO_FRAGMENTED'
			$message[2] = 'The volume is too fragmented to complete this operation.'

		Case 303
			$message[1] = 'ERROR_DELETE_PENDING'
			$message[2] = 'The file cannot be opened because it is in the process of being deleted.'

		Case 317
			$message[1] = 'ERROR_MR_MID_NOT_FOUND'
			$message[2] = 'The system cannot find message text for message number 0x%1 in the message file for %2.'

		Case 318
			$message[1] = 'ERROR_SCOPE_NOT_FOUND'
			$message[2] = 'The scope specified was not found.'

		Case 350
			$message[1] = 'ERROR_FAIL_NOACTION_REBOOT'
			$message[2] = 'No action was taken as a system reboot is required.'

		Case 351
			$message[1] = 'ERROR_FAIL_SHUTDOWN'
			$message[2] = 'The shutdown operation failed.'

		Case 352
			$message[1] = 'ERROR_FAIL_RESTART'
			$message[2] = 'The restart operation failed.'

		Case 353
			$message[1] = 'ERROR_MAX_SESSIONS_REACHED'
			$message[2] = 'The maximum number of sessions has been reached.'

		Case 400
			$message[1] = 'ERROR_THREAD_MODE_ALREADY_BACKGROUND'
			$message[2] = 'The thread is already in background processing mode.'

		Case 401
			$message[1] = 'ERROR_THREAD_MODE_NOT_BACKGROUND'
			$message[2] = 'The thread is not in background processing mode.'

		Case 402
			$message[1] = 'ERROR_PROCESS_MODE_ALREADY_BACKGROUND'
			$message[2] = 'The process is already in background processing mode.'

		Case 403
			$message[1] = 'ERROR_PROCESS_MODE_NOT_BACKGROUND'
			$message[2] = 'The process is not in background processing mode.'

		Case 487
			$message[1] = 'ERROR_INVALID_ADDRESS'
			$message[2] = 'Attempt to access invalid address.'

		Case 500
			$message[1] = 'ERROR_USER_PROFILE_LOAD'
			$message[2] = 'User profile cannot be loaded.'

		Case 534
			$message[1] = 'ERROR_ARITHMETIC_OVERFLOW'
			$message[2] = 'Arithmetic result exceeded 32 bits.'

		Case 535
			$message[1] = 'ERROR_PIPE_CONNECTED'
			$message[2] = 'There is a process on other end of the pipe.'

		Case 536
			$message[1] = 'ERROR_PIPE_LISTENING'
			$message[2] = 'Waiting for a process to open the other end of the pipe.'

		Case 537
			$message[1] = 'ERROR_VERIFIER_STOP'
			$message[2] = 'Application verifier has found an error in the current process.'

		Case 538
			$message[1] = 'ERROR_ABIOS_ERROR'
			$message[2] = 'An error occurred in the ABIOS subsystem.'

		Case 539
			$message[1] = 'ERROR_WX86_WARNING'
			$message[2] = 'A warning occurred in the WX86 subsystem.'

		Case 540
			$message[1] = 'ERROR_WX86_ERROR'
			$message[2] = 'An error occurred in the WX86 subsystem.'

		Case 541
			$message[1] = 'ERROR_TIMER_NOT_CANCELED'
			$message[2] = 'An attempt was made to cancel or set a timer that has an associated APC and the subject thread is not the thread that originally set the timer with an associated APC routine.'

		Case 542
			$message[1] = 'ERROR_UNWIND'
			$message[2] = 'Unwind exception code.'

		Case 543
			$message[1] = 'ERROR_BAD_STACK'
			$message[2] = 'An invalid or unaligned stack was encountered during an unwind operation.'

		Case 544
			$message[1] = 'ERROR_INVALID_UNWIND_TARGET'
			$message[2] = 'An invalid unwind target was encountered during an unwind operation.'

		Case 545
			$message[1] = 'ERROR_INVALID_PORT_ATTRIBUTES'
			$message[2] = 'Invalid Object Attributes specified to NtCreatePort or invalid Port Attributes specified to NtConnectPort'

		Case 546
			$message[1] = 'ERROR_PORT_MESSAGE_TOO_LONG'
			$message[2] = 'Length of message passed to NtRequestPort or NtRequestWaitReplyPort was longer than the maximum message allowed by the port.'

		Case 547
			$message[1] = 'ERROR_INVALID_QUOTA_LOWER'
			$message[2] = 'An attempt was made to lower a quota limit below the current usage.'

		Case 548
			$message[1] = 'ERROR_DEVICE_ALREADY_ATTACHED'
			$message[2] = 'An attempt was made to attach to a device that was already attached to another device.'

		Case 549
			$message[1] = 'ERROR_INSTRUCTION_MISALIGNMENT'
			$message[2] = 'An attempt was made to execute an instruction at an unaligned address and the host system does not support unaligned instruction references.'

		Case 550
			$message[1] = 'ERROR_PROFILING_NOT_STARTED'
			$message[2] = 'Profiling not started.'

		Case 551
			$message[1] = 'ERROR_PROFILING_NOT_STOPPED'
			$message[2] = 'Profiling not stopped.'

		Case 552
			$message[1] = 'ERROR_COULD_NOT_INTERPRET'
			$message[2] = 'The passed ACL did not contain the minimum required information.'

		Case 553
			$message[1] = 'ERROR_PROFILING_AT_LIMIT'
			$message[2] = 'The number of active profiling objects is at the maximum and no more may be started.'

		Case 554
			$message[1] = 'ERROR_CANT_WAIT'
			$message[2] = 'Used to indicate that an operation cannot continue without blocking for I/O.'

		Case 555
			$message[1] = 'ERROR_CANT_TERMINATE_SELF'
			$message[2] = 'Indicates that a thread attempted to terminate itself by default (called NtTerminateThread with NULL) and it was the last thread in the current process.'

		Case 556
			$message[1] = 'ERROR_UNEXPECTED_MM_CREATE_ERR'
			$message[2] = 'If an MM error is returned which is not defined in the standard FsRtl filter, it is converted to one of the following errors which is guaranteed to be in the filter. In this case information is lost, however, the filter correctly handles the exception.'

		Case 557
			$message[1] = 'ERROR_UNEXPECTED_MM_MAP_ERROR'
			$message[2] = 'If an MM error is returned which is not defined in the standard FsRtl filter, it is converted to one of the following errors which is guaranteed to be in the filter. In this case information is lost, however, the filter correctly handles the exception.'

		Case 558
			$message[1] = 'ERROR_UNEXPECTED_MM_EXTEND_ERR'
			$message[2] = 'If an MM error is returned which is not defined in the standard FsRtl filter, it is converted to one of the following errors which is guaranteed to be in the filter. In this case information is lost, however, the filter correctly handles the exception.'

		Case 559
			$message[1] = 'ERROR_BAD_FUNCTION_TABLE'
			$message[2] = 'A malformed function table was encountered during an unwind operation.'

		Case 560
			$message[1] = 'ERROR_NO_GUID_TRANSLATION'
			$message[2] = 'Indicates that an attempt was made to assign protection to a file system file or directory and one of the SIDs in the security descriptor could not be translated into a GUID that could be stored by the file system. This causes the protection attempt to fail, which may cause a file creation attempt to fail.'

		Case 561
			$message[1] = 'ERROR_INVALID_LDT_SIZE'
			$message[2] = 'Indicates that an attempt was made to grow an LDT by setting its size, or that the size was not an even number of selectors.'

		Case 563
			$message[1] = 'ERROR_INVALID_LDT_OFFSET'
			$message[2] = 'Indicates that the starting value for the LDT information was not an integral multiple of the selector size.'

		Case 564
			$message[1] = 'ERROR_INVALID_LDT_DESCRIPTOR'
			$message[2] = 'Indicates that the user supplied an invalid descriptor when trying to set up Ldt descriptors.'

		Case 565
			$message[1] = 'ERROR_TOO_MANY_THREADS'
			$message[2] = 'Indicates a process has too many threads to perform the requested action. For example, assignment of a primary token may only be performed when a process has zero or one threads.'

		Case 566
			$message[1] = 'ERROR_THREAD_NOT_IN_PROCESS'
			$message[2] = 'An attempt was made to operate on a thread within a specific process, but the thread specified is not in the process specified.'

		Case 567
			$message[1] = 'ERROR_PAGEFILE_QUOTA_EXCEEDED'
			$message[2] = 'Page file quota was exceeded.'

		Case 568
			$message[1] = 'ERROR_LOGON_SERVER_CONFLICT'
			$message[2] = 'The Netlogon service cannot start because another Netlogon service running in the domain conflicts with the specified role.'

		Case 569
			$message[1] = 'ERROR_SYNCHRONIZATION_REQUIRED'
			$message[2] = 'The SAM database on a Windows Server is significantly out of synchronization with the copy on the Domain Controller. A complete synchronization is required.'

		Case 570
			$message[1] = 'ERROR_NET_OPEN_FAILED'
			$message[2] = 'The NtCreateFile API failed. This error should never be returned to an application, it is a place holder for the Windows Lan Manager Redirector to use in its internal error mapping routines.'

		Case 571
			$message[1] = 'ERROR_IO_PRIVILEGE_FAILED'
			$message[2] = '{Privilege Failed} The I/O permissions for the process could not be changed.'

		Case 572
			$message[1] = 'ERROR_CONTROL_C_EXIT'
			$message[2] = '{Application Exit by CTRL+C} The application terminated as a result of a CTRL+C.'

		Case 573
			$message[1] = 'ERROR_MISSING_SYSTEMFILE'
			$message[2] = '{Missing System File} The required system file %hs is bad or missing.'

		Case 574
			$message[1] = 'ERROR_UNHANDLED_EXCEPTION'
			$message[2] = '{Application Error} The exception %s (0x%08lx) occurred in the application at location 0x%08lx.'

		Case 575
			$message[1] = 'ERROR_APP_INIT_FAILURE'
			$message[2] = '{Application Error} The application failed to initialize properly (0x%lx). Click OK to terminate the application.'

		Case 576
			$message[1] = 'ERROR_PAGEFILE_CREATE_FAILED'
			$message[2] = '{Unable to Create Paging File} The creation of the paging file %hs failed (%lx). The requested size was %ld.'

		Case 577
			$message[1] = 'ERROR_INVALID_IMAGE_HASH'
			$message[2] = 'Windows cannot verify the digital signature for this file. A recent hardware or software change might have installed a file that is signed incorrectly or damaged, or that might be malicious software from an unknown source.'

		Case 578
			$message[1] = 'ERROR_NO_PAGEFILE'
			$message[2] = '{No Paging File Specified} No paging file was specified in the system configuration.'

		Case 579
			$message[1] = 'ERROR_ILLEGAL_FLOAT_CONTEXT'
			$message[2] = '{EXCEPTION} A real-mode application issued a floating-point instruction and floating-point hardware is not present.'

		Case 580
			$message[1] = 'ERROR_NO_EVENT_PAIR'
			$message[2] = 'An event pair synchronization operation was performed using the thread specific client/server event pair object, but no event pair object was associated with the thread.'

		Case 581
			$message[1] = 'ERROR_DOMAIN_CTRLR_CONFIG_ERROR'
			$message[2] = 'A Windows Server has an incorrect configuration.'

		Case 582
			$message[1] = 'ERROR_ILLEGAL_CHARACTER'
			$message[2] = 'An illegal character was encountered. For a multi-byte character set this includes a lead byte without a succeeding trail byte. For the Unicode character set this includes the characters 0xFFFF and 0xFFFE.'

		Case 583
			$message[1] = 'ERROR_UNDEFINED_CHARACTER'
			$message[2] = 'The Unicode character is not defined in the Unicode character set installed on the system.'

		Case 584
			$message[1] = 'ERROR_FLOPPY_VOLUME'
			$message[2] = 'The paging file cannot be created on a floppy diskette.'

		Case 585
			$message[1] = 'ERROR_BIOS_FAILED_TO_CONNECT_INTERRUPT'
			$message[2] = 'The system BIOS failed to connect a system interrupt to the device or bus for which the device is connected.'

		Case 586
			$message[1] = 'ERROR_BACKUP_CONTROLLER'
			$message[2] = 'This operation is only allowed for the Primary Domain Controller of the domain.'

		Case 587
			$message[1] = 'ERROR_MUTANT_LIMIT_EXCEEDED'
			$message[2] = 'An attempt was made to acquire a mutant such that its maximum count would have been exceeded.'

		Case 588
			$message[1] = 'ERROR_FS_DRIVER_REQUIRED'
			$message[2] = 'A volume has been accessed for which a file system driver is required that has not yet been loaded.'

		Case 589
			$message[1] = 'ERROR_CANNOT_LOAD_REGISTRY_FILE'
			$message[2] = '{Registry File Failure} The registry cannot load the hive (file): %hs or its log or alternate. It is corrupt, absent, or not writable.'

		Case 590
			$message[1] = 'ERROR_DEBUG_ATTACH_FAILED'
			$message[2] = '{Unexpected Failure in DebugActiveProcess} An unexpected failure occurred while processing a DebugActiveProcess API request. You may choose OK to terminate the process, or Cancel to ignore the error.'

		Case 591
			$message[1] = 'ERROR_SYSTEM_PROCESS_TERMINATED'
			$message[2] = '{Fatal System Error} The %hs system process terminated unexpectedly with a status of 0x%08x (0x%08x 0x%08x). The system has been shut down.'

		Case 592
			$message[1] = 'ERROR_DATA_NOT_ACCEPTED'
			$message[2] = '{Data Not Accepted} The TDI client could not handle the data received during an indication.'

		Case 593
			$message[1] = 'ERROR_VDM_HARD_ERROR'
			$message[2] = 'NTVDM encountered a hard error.'

		Case 594
			$message[1] = 'ERROR_DRIVER_CANCEL_TIMEOUT'
			$message[2] = '{Cancel Timeout} The driver %hs failed to complete a canceled I/O request in the allotted time.'

		Case 595
			$message[1] = 'ERROR_REPLY_MESSAGE_MISMATCH'
			$message[2] = '{Reply Message Mismatch} An attempt was made to reply to an LPC message, but the thread specified by the client ID in the message was not waiting on that message.'

		Case 596
			$message[1] = 'ERROR_LOST_WRITEBEHIND_DATA'
			$message[2] = '{Delayed Write Failed} Windows was unable to save all the data for the file %hs. The data has been lost. This error may be caused by a failure of your computer hardware or network connection. Please try to save this file elsewhere.'

		Case 597
			$message[1] = 'ERROR_CLIENT_SERVER_PARAMETERS_INVALID'
			$message[2] = 'The parameter(s) passed to the server in the client/server shared memory window were invalid. Too much data may have been put in the shared memory window.'

		Case 598
			$message[1] = 'ERROR_NOT_TINY_STREAM'
			$message[2] = 'The stream is not a tiny stream.'

		Case 599
			$message[1] = 'ERROR_STACK_OVERFLOW_READ'
			$message[2] = 'The request must be handled by the stack overflow code.'

		Case 600
			$message[1] = 'ERROR_CONVERT_TO_LARGE'
			$message[2] = 'Internal OFS status codes indicating how an allocation operation is handled. Either it is retried after the containing onode is moved or the extent stream is converted to a large stream.'

		Case 601
			$message[1] = 'ERROR_FOUND_OUT_OF_SCOPE'
			$message[2] = 'The attempt to find the object found an object matching by ID on the volume but it is out of the scope of the handle used for the operation.'

		Case 602
			$message[1] = 'ERROR_ALLOCATE_BUCKET'
			$message[2] = 'The bucket array must be grown. Retry transaction after doing so.'

		Case 603
			$message[1] = 'ERROR_MARSHALL_OVERFLOW'
			$message[2] = 'The user/kernel marshalling buffer has overflowed.'

		Case 604
			$message[1] = 'ERROR_INVALID_VARIANT'
			$message[2] = 'The supplied variant structure contains invalid data.'

		Case 605
			$message[1] = 'ERROR_BAD_COMPRESSION_BUFFER'
			$message[2] = 'The specified buffer contains ill-formed data.'

		Case 606
			$message[1] = 'ERROR_AUDIT_FAILED'
			$message[2] = '{Audit Failed} An attempt to generate a security audit failed.'

		Case 607
			$message[1] = 'ERROR_TIMER_RESOLUTION_NOT_SET'
			$message[2] = 'The timer resolution was not previously set by the current process.'

		Case 608
			$message[1] = 'ERROR_INSUFFICIENT_LOGON_INFO'
			$message[2] = 'There is insufficient account information to log you on.'

		Case 609
			$message[1] = 'ERROR_BAD_DLL_ENTRYPOINT'
			$message[2] = '{Invalid DLL Entrypoint} The dynamic link library %hs is not written correctly. The stack pointer has been left in an inconsistent state. The entrypoint should be declared as WINAPI or STDCALL. Select YES to fail the DLL load. Select NO to continue execution. Selecting NO may cause the application to operate incorrectly.'

		Case 610
			$message[1] = 'ERROR_BAD_SERVICE_ENTRYPOINT'
			$message[2] = '{Invalid Service Callback Entrypoint} The %hs service is not written correctly. The stack pointer has been left in an inconsistent state. The callback entrypoint should be declared as WINAPI or STDCALL. Selecting OK will cause the service to continue operation. However, the service process may operate incorrectly.'

		Case 611
			$message[1] = 'ERROR_IP_ADDRESS_CONFLICT1'
			$message[2] = 'There is an IP address conflict with another system on the network'

		Case 612
			$message[1] = 'ERROR_IP_ADDRESS_CONFLICT2'
			$message[2] = 'There is an IP address conflict with another system on the network'

		Case 613
			$message[1] = 'ERROR_REGISTRY_QUOTA_LIMIT'
			$message[2] = '{Low On Registry Space} The system has reached the maximum size allowed for the system part of the registry. Additional storage requests will be ignored.'

		Case 614
			$message[1] = 'ERROR_NO_CALLBACK_ACTIVE'
			$message[2] = 'A callback return system service cannot be executed when no callback is active.'

		Case 615
			$message[1] = 'ERROR_PWD_TOO_SHORT'
			$message[2] = 'The password provided is too short to meet the policy of your user account. Please choose a longer password.'

		Case 616
			$message[1] = 'ERROR_PWD_TOO_RECENT'
			$message[2] = 'The policy of your user account does not allow you to change passwords too frequently. This is done to prevent users from changing back to a familiar, but potentially discovered, password. If you feel your password has been compromised then please contact your administrator immediately to have a new one assigned.'

		Case 617
			$message[1] = 'ERROR_PWD_HISTORY_CONFLICT'
			$message[2] = 'You have attempted to change your password to one that you have used in the past. The policy of your user account does not allow this. Please select a password that you have not previously used.'

		Case 618
			$message[1] = 'ERROR_UNSUPPORTED_COMPRESSION'
			$message[2] = 'The specified compression format is unsupported.'

		Case 619
			$message[1] = 'ERROR_INVALID_HW_PROFILE'
			$message[2] = 'The specified hardware profile configuration is invalid.'

		Case 620
			$message[1] = 'ERROR_INVALID_PLUGPLAY_DEVICE_PATH'
			$message[2] = 'The specified Plug and Play registry device path is invalid.'

		Case 621
			$message[1] = 'ERROR_QUOTA_LIST_INCONSISTENT'
			$message[2] = 'The specified quota list is internally inconsistent with its descriptor.'

		Case 622
			$message[1] = 'ERROR_EVALUATION_EXPIRATION'
			$message[2] = '{Windows Evaluation Notification} The evaluation period for this installation of Windows has expired. This system will shutdown in 1 hour. To restore access to this installation of Windows, please upgrade this installation using a licensed distribution of this product.'

		Case 623
			$message[1] = 'ERROR_ILLEGAL_DLL_RELOCATION'
			$message[2] = '{Illegal System DLL Relocation} The system DLL %hs was relocated in memory. The application will not run properly. The relocation occurred because the DLL %hs occupied an address range reserved for Windows system DLLs. The vendor supplying the DLL should be contacted for a new DLL.'

		Case 624
			$message[1] = 'ERROR_DLL_INIT_FAILED_LOGOFF'
			$message[2] = '{DLL Initialization Failed} The application failed to initialize because the window station is shutting down.'

		Case 625
			$message[1] = 'ERROR_VALIDATE_CONTINUE'
			$message[2] = 'The validation process needs to continue on to the next step.'

		Case 626
			$message[1] = 'ERROR_NO_MORE_MATCHES'
			$message[2] = 'There are no more matches for the current index enumeration.'

		Case 627
			$message[1] = 'ERROR_RANGE_LIST_CONFLICT'
			$message[2] = 'The range could not be added to the range list because of a conflict.'

		Case 628
			$message[1] = 'ERROR_SERVER_SID_MISMATCH'
			$message[2] = 'The server process is running under a SID different than that required by client.'

		Case 629
			$message[1] = 'ERROR_CANT_ENABLE_DENY_ONLY'
			$message[2] = 'A group marked use for deny only cannot be enabled.'

		Case 630
			$message[1] = 'ERROR_FLOAT_MULTIPLE_FAULTS'
			$message[2] = '{EXCEPTION} Multiple floating point faults.'

		Case 631
			$message[1] = 'ERROR_FLOAT_MULTIPLE_TRAPS'
			$message[2] = '{EXCEPTION} Multiple floating point traps.'

		Case 632
			$message[1] = 'ERROR_NOINTERFACE'
			$message[2] = 'The requested interface is not supported.'

		Case 633
			$message[1] = 'ERROR_DRIVER_FAILED_SLEEP'
			$message[2] = '{System Standby Failed} The driver %hs does not support standby mode. Updating this driver may allow the system to go to standby mode.'

		Case 634
			$message[1] = 'ERROR_CORRUPT_SYSTEM_FILE'
			$message[2] = 'The system file %1 has become corrupt and has been replaced.'

		Case 635
			$message[1] = 'ERROR_COMMITMENT_MINIMUM'
			$message[2] = '{Virtual Memory Minimum Too Low} Your system is low on virtual memory. Windows is increasing the size of your virtual memory paging file. During this process, memory requests for some applications may be denied. For more information, see Help.'

		Case 636
			$message[1] = 'ERROR_PNP_RESTART_ENUMERATION'
			$message[2] = 'A device was removed so enumeration must be restarted.'

		Case 637
			$message[1] = 'ERROR_SYSTEM_IMAGE_BAD_SIGNATURE'
			$message[2] = '{Fatal System Error} The system image %s is not properly signed. The file has been replaced with the signed file. The system has been shut down.'

		Case 638
			$message[1] = 'ERROR_PNP_REBOOT_REQUIRED'
			$message[2] = 'Device will not start without a reboot.'

		Case 639
			$message[1] = 'ERROR_INSUFFICIENT_POWER'
			$message[2] = 'There is not enough power to complete the requested operation.'

		Case 640
			$message[1] = 'ERROR_MULTIPLE_FAULT_VIOLATION'
			$message[2] = 'ERROR_MULTIPLE_FAULT_VIOLATION'

		Case 641
			$message[1] = 'ERROR_SYSTEM_SHUTDOWN'
			$message[2] = 'The system is in the process of shutting down.'

		Case 642
			$message[1] = 'ERROR_PORT_NOT_SET'
			$message[2] = 'An attempt to remove a processes DebugPort was made, but a port was not already associated with the process.'

		Case 643
			$message[1] = 'ERROR_DS_VERSION_CHECK_FAILURE'
			$message[2] = 'This version of Windows is not compatible with the behavior version of directory forest, domain or domain controller.'

		Case 644
			$message[1] = 'ERROR_RANGE_NOT_FOUND'
			$message[2] = 'The specified range could not be found in the range list.'

		Case 646
			$message[1] = 'ERROR_NOT_SAFE_MODE_DRIVER'
			$message[2] = 'The driver was not loaded because the system is booting into safe mode.'

		Case 647
			$message[1] = 'ERROR_FAILED_DRIVER_ENTRY'
			$message[2] = 'The driver was not loaded because it failed it''s initialization call.'

		Case 648
			$message[1] = 'ERROR_DEVICE_ENUMERATION_ERROR'
			$message[2] = 'The "%hs" encountered an error while applying power or reading the device configuration. This may be caused by a failure of your hardware or by a poor connection.'

		Case 649
			$message[1] = 'ERROR_MOUNT_POINT_NOT_RESOLVED'
			$message[2] = 'The create operation failed because the name contained at least one mount point which resolves to a volume to which the specified device object is not attached.'

		Case 650
			$message[1] = 'ERROR_INVALID_DEVICE_OBJECT_PARAMETER'
			$message[2] = 'The device object parameter is either not a valid device object or is not attached to the volume specified by the file name.'

		Case 651
			$message[1] = 'ERROR_MCA_OCCURED'
			$message[2] = 'A Machine Check Error has occurred. Please check the system eventlog for additional information.'

		Case 652
			$message[1] = 'ERROR_DRIVER_DATABASE_ERROR'
			$message[2] = 'There was error [%2] processing the driver database.'

		Case 653
			$message[1] = 'ERROR_SYSTEM_HIVE_TOO_LARGE'
			$message[2] = 'System hive size has exceeded its limit.'

		Case 654
			$message[1] = 'ERROR_DRIVER_FAILED_PRIOR_UNLOAD'
			$message[2] = 'The driver could not be loaded because a previous version of the driver is still in memory.'

		Case 655
			$message[1] = 'ERROR_VOLSNAP_PREPARE_HIBERNATE'
			$message[2] = '{Volume Shadow Copy Service} Please wait while the Volume Shadow Copy Service prepares volume %hs for hibernation.'

		Case 656
			$message[1] = 'ERROR_HIBERNATION_FAILURE'
			$message[2] = 'The system has failed to hibernate (The error code is %hs). Hibernation will be disabled until the system is restarted.'

		Case 665
			$message[1] = 'ERROR_FILE_SYSTEM_LIMITATION'
			$message[2] = 'The requested operation could not be completed due to a file system limitation'

		Case 668
			$message[1] = 'ERROR_ASSERTION_FAILURE'
			$message[2] = 'An assertion failure has occurred.'

		Case 669
			$message[1] = 'ERROR_ACPI_ERROR'
			$message[2] = 'An error occurred in the ACPI subsystem.'

		Case 670
			$message[1] = 'ERROR_WOW_ASSERTION'
			$message[2] = 'WOW Assertion Error.'

		Case 671
			$message[1] = 'ERROR_PNP_BAD_MPS_TABLE'
			$message[2] = 'A device is missing in the system BIOS MPS table. This device will not be used. Please contact your system vendor for system BIOS update.'

		Case 672
			$message[1] = 'ERROR_PNP_TRANSLATION_FAILED'
			$message[2] = 'A translator failed to translate resources.'

		Case 673
			$message[1] = 'ERROR_PNP_IRQ_TRANSLATION_FAILED'
			$message[2] = 'A IRQ translator failed to translate resources.'

		Case 674
			$message[1] = 'ERROR_PNP_INVALID_ID'
			$message[2] = 'Driver %2 returned invalid ID for a child device (%3).'

		Case 675
			$message[1] = 'ERROR_WAKE_SYSTEM_DEBUGGER'
			$message[2] = '{Kernel Debugger Awakened} the system debugger was awakened by an interrupt.'

		Case 676
			$message[1] = 'ERROR_HANDLES_CLOSED'
			$message[2] = '{Handles Closed} Handles to objects have been automatically closed as a result of the requested operation.'

		Case 677
			$message[1] = 'ERROR_EXTRANEOUS_INFORMATION'
			$message[2] = '{Too Much Information} The specified access control list (ACL) contained more information than was expected.'

		Case 678
			$message[1] = 'ERROR_RXACT_COMMIT_NECESSARY'
			$message[2] = 'This warning level status indicates that the transaction state already exists for the registry sub-tree, but that a transaction commit was previously aborted. The commit has NOT been completed, but has not been rolled back either (so it may still be committed if desired).'

		Case 679
			$message[1] = 'ERROR_MEDIA_CHECK'
			$message[2] = '{Media Changed} The media may have changed.'

		Case 680
			$message[1] = 'ERROR_GUID_SUBSTITUTION_MADE'
			$message[2] = '{GUID Substitution} During the translation of a global identifier (GUID) to a Windows security ID (SID), no administratively-defined GUID prefix was found. A substitute prefix was used, which will not compromise system security. However, this may provide a more restrictive access than intended.'

		Case 681
			$message[1] = 'ERROR_STOPPED_ON_SYMLINK'
			$message[2] = 'The create operation stopped after reaching a symbolic link'

		Case 682
			$message[1] = 'ERROR_LONGJUMP'
			$message[2] = 'A long jump has been executed.'

		Case 683
			$message[1] = 'ERROR_PLUGPLAY_QUERY_VETOED'
			$message[2] = 'The Plug and Play query operation was not successful.'

		Case 684
			$message[1] = 'ERROR_UNWIND_CONSOLIDATE'
			$message[2] = 'A frame consolidation has been executed.'

		Case 685
			$message[1] = 'ERROR_REGISTRY_HIVE_RECOVERED'
			$message[2] = '{Registry Hive Recovered} Registry hive (file): %hs was corrupted and it has been recovered. Some data might have been lost.'

		Case 686
			$message[1] = 'ERROR_DLL_MIGHT_BE_INSECURE'
			$message[2] = 'The application is attempting to run executable code from the module %hs. This may be insecure. An alternative, %hs, is available. Should the application use the secure module %hs?'

		Case 687
			$message[1] = 'ERROR_DLL_MIGHT_BE_INCOMPATIBLE'
			$message[2] = 'The application is loading executable code from the module %hs. This is secure, but may be incompatible with previous releases of the operating system. An alternative, %hs, is available. Should the application use the secure module %hs?'

		Case 688
			$message[1] = 'ERROR_DBG_EXCEPTION_NOT_HANDLED'
			$message[2] = 'Debugger did not handle the exception.'

		Case 689
			$message[1] = 'ERROR_DBG_REPLY_LATER'
			$message[2] = 'Debugger will reply later.'

		Case 690
			$message[1] = 'ERROR_DBG_UNABLE_TO_PROVIDE_HANDLE'
			$message[2] = 'Debugger cannot provide handle.'

		Case 691
			$message[1] = 'ERROR_DBG_TERMINATE_THREAD'
			$message[2] = 'Debugger terminated thread.'

		Case 692
			$message[1] = 'ERROR_DBG_TERMINATE_PROCESS'
			$message[2] = 'Debugger terminated process.'

		Case 693
			$message[1] = 'ERROR_DBG_CONTROL_C'
			$message[2] = 'Debugger got control C.'

		Case 694
			$message[1] = 'ERROR_DBG_PRINTEXCEPTION_C'
			$message[2] = 'Debugger printed exception on control C.'

		Case 695
			$message[1] = 'ERROR_DBG_RIPEXCEPTION'
			$message[2] = 'Debugger received RIP exception.'

		Case 696
			$message[1] = 'ERROR_DBG_CONTROL_BREAK'
			$message[2] = 'Debugger received control break.'

		Case 697
			$message[1] = 'ERROR_DBG_COMMAND_EXCEPTION'
			$message[2] = 'Debugger command communication exception.'

		Case 698
			$message[1] = 'ERROR_OBJECT_NAME_EXISTS'
			$message[2] = '{Object Exists} An attempt was made to create an object and the object name already existed.'

		Case 699
			$message[1] = 'ERROR_THREAD_WAS_SUSPENDED'
			$message[2] = '{Thread Suspended} A thread termination occurred while the thread was suspended. The thread was resumed, and termination proceeded.'

		Case 700
			$message[1] = 'ERROR_IMAGE_NOT_AT_BASE'
			$message[2] = '{Image Relocated} An image file could not be mapped at the address specified in the image file. Local fixups must be performed on this image.'

		Case 701
			$message[1] = 'ERROR_RXACT_STATE_CREATED'
			$message[2] = 'This informational level status indicates that a specified registry sub-tree transaction state did not yet exist and had to be created.'

		Case 702
			$message[1] = 'ERROR_SEGMENT_NOTIFICATION'
			$message[2] = '{Segment Load} A virtual DOS machine (VDM) is loading, unloading, or moving an MS-DOS or Win16 program segment image. An exception is raised so a debugger can load, unload or track symbols and breakpoints within these 16-bit segments.'

		Case 703
			$message[1] = 'ERROR_BAD_CURRENT_DIRECTORY'
			$message[2] = '{Invalid Current Directory} The process cannot switch to the startup current directory %hs. Select OK to set current directory to %hs, or select CANCEL to exit.'

		Case 704
			$message[1] = 'ERROR_FT_READ_RECOVERY_FROM_BACKUP'
			$message[2] = '{Redundant Read} To satisfy a read request, the NT fault-tolerant file system successfully read the requested data from a redundant copy. This was done because the file system encountered a failure on a member of the fault-tolerant volume, but was unable to reassign the failing area of the device.'

		Case 705
			$message[1] = 'ERROR_FT_WRITE_RECOVERY'
			$message[2] = '{Redundant Write} To satisfy a write request, the NT fault-tolerant file system successfully wrote a redundant copy of the information. This was done because the file system encountered a failure on a member of the fault-tolerant volume, but was not able to reassign the failing area of the device.'

		Case 706
			$message[1] = 'ERROR_IMAGE_MACHINE_TYPE_MISMATCH'
			$message[2] = '{Machine Type Mismatch} The image file %hs is valid, but is for a machine type other than the current machine. Select OK to continue, or CANCEL to fail the DLL load.'

		Case 707
			$message[1] = 'ERROR_RECEIVE_PARTIAL'
			$message[2] = '{Partial Data Received} The network transport returned partial data to its client. The remaining data will be sent later.'

		Case 708
			$message[1] = 'ERROR_RECEIVE_EXPEDITED'
			$message[2] = '{Expedited Data Received} The network transport returned data to its client that was marked as expedited by the remote system.'

		Case 709
			$message[1] = 'ERROR_RECEIVE_PARTIAL_EXPEDITED'
			$message[2] = '{Partial Expedited Data Received} The network transport returned partial data to its client and this data was marked as expedited by the remote system. The remaining data will be sent later.'

		Case 710
			$message[1] = 'ERROR_EVENT_DONE'
			$message[2] = '{TDI Event Done} The TDI indication has completed successfully.'

		Case 711
			$message[1] = 'ERROR_EVENT_PENDING'
			$message[2] = '{TDI Event Pending} The TDI indication has entered the pending state.'

		Case 712
			$message[1] = 'ERROR_CHECKING_FILE_SYSTEM'
			$message[2] = 'Checking file system on %wZ'

		Case 713
			$message[1] = 'ERROR_FATAL_APP_EXIT'
			$message[2] = '{Fatal Application Exit} %hs'

		Case 714
			$message[1] = 'ERROR_PREDEFINED_HANDLE'
			$message[2] = 'The specified registry key is referenced by a predefined handle.'

		Case 715
			$message[1] = 'ERROR_WAS_UNLOCKED'
			$message[2] = '{Page Unlocked} The page protection of a locked page was changed to ''No Access'' and the page was unlocked from memory and from the process.'

		Case 716
			$message[1] = 'ERROR_SERVICE_NOTIFICATION'
			$message[2] = '%hs'

		Case 717
			$message[1] = 'ERROR_WAS_LOCKED'
			$message[2] = '{Page Locked} One of the pages to lock was already locked.'

		Case 718
			$message[1] = 'ERROR_LOG_HARD_ERROR'
			$message[2] = 'Application popup: %1 : %2'

		Case 719
			$message[1] = 'ERROR_ALREADY_WIN32'
			$message[2] = 'ERROR_ALREADY_WIN32'

		Case 720
			$message[1] = 'ERROR_IMAGE_MACHINE_TYPE_MISMATCH_EXE'
			$message[2] = '{Machine Type Mismatch} The image file %hs is valid, but is for a machine type other than the current machine.'

		Case 721
			$message[1] = 'ERROR_NO_YIELD_PERFORMED'
			$message[2] = 'A yield execution was performed and no thread was available to run.'

		Case 722
			$message[1] = 'ERROR_TIMER_RESUME_IGNORED'
			$message[2] = 'The resumable flag to a timer API was ignored.'

		Case 723
			$message[1] = 'ERROR_ARBITRATION_UNHANDLED'
			$message[2] = 'The arbiter has deferred arbitration of these resources to its parent'

		Case 724
			$message[1] = 'ERROR_CARDBUS_NOT_SUPPORTED'
			$message[2] = 'The inserted CardBus device cannot be started because of a configuration error on "%hs".'

		Case 725
			$message[1] = 'ERROR_MP_PROCESSOR_MISMATCH'
			$message[2] = 'The CPUs in this multiprocessor system are not all the same revision level. To use all processors the operating system restricts itself to the features of the least capable processor in the system. Should problems occur with this system, contact the CPU manufacturer to see if this mix of processors is supported.'

		Case 726
			$message[1] = 'ERROR_HIBERNATED'
			$message[2] = 'The system was put into hibernation.'

		Case 727
			$message[1] = 'ERROR_RESUME_HIBERNATION'
			$message[2] = 'The system was resumed from hibernation.'

		Case 728
			$message[1] = 'ERROR_FIRMWARE_UPDATED'
			$message[2] = 'Windows has detected that the system firmware (BIOS) was updated [previous firmware date = %2, current firmware date %3].'

		Case 729
			$message[1] = 'ERROR_DRIVERS_LEAKING_LOCKED_PAGES'
			$message[2] = 'A device driver is leaking locked I/O pages causing system degradation. The system has automatically enabled tracking code in order to try and catch the culprit.'

		Case 730
			$message[1] = 'ERROR_WAKE_SYSTEM'
			$message[2] = 'The system has awoken'

		Case 731
			$message[1] = 'ERROR_WAIT_1'
			$message[2] = 'ERROR_WAIT_1'

		Case 732
			$message[1] = 'ERROR_WAIT_2'
			$message[2] = 'ERROR_WAIT_2'

		Case 733
			$message[1] = 'ERROR_WAIT_3'
			$message[2] = 'ERROR_WAIT_3'

		Case 734
			$message[1] = 'ERROR_WAIT_63'
			$message[2] = 'ERROR_WAIT_63'

		Case 735
			$message[1] = 'ERROR_ABANDONED_WAIT_0'
			$message[2] = 'ERROR_ABANDONED_WAIT_0'

		Case 736
			$message[1] = 'ERROR_ABANDONED_WAIT_63'
			$message[2] = 'ERROR_ABANDONED_WAIT_63'

		Case 737
			$message[1] = 'ERROR_USER_APC'
			$message[2] = 'ERROR_USER_APC'

		Case 738
			$message[1] = 'ERROR_KERNEL_APC'
			$message[2] = 'ERROR_KERNEL_APC'

		Case 739
			$message[1] = 'ERROR_ALERTED'
			$message[2] = 'ERROR_ALERTED'

		Case 740
			$message[1] = 'ERROR_ELEVATION_REQUIRED'
			$message[2] = 'The requested operation requires elevation.'

		Case 741
			$message[1] = 'ERROR_REPARSE'
			$message[2] = 'A reparse should be performed by the Object Manager since the name of the file resulted in a symbolic link.'

		Case 742
			$message[1] = 'ERROR_OPLOCK_BREAK_IN_PROGRESS'
			$message[2] = 'An open/create operation completed while an oplock break is underway.'

		Case 743
			$message[1] = 'ERROR_VOLUME_MOUNTED'
			$message[2] = 'A new volume has been mounted by a file system.'

		Case 744
			$message[1] = 'ERROR_RXACT_COMMITTED'
			$message[2] = 'This success level status indicates that the transaction state already exists for the registry sub-tree, but that a transaction commit was previously aborted. The commit has now been completed.'

		Case 745
			$message[1] = 'ERROR_NOTIFY_CLEANUP'
			$message[2] = 'This indicates that a notify change request has been completed due to closing the handle which made the notify change request.'

		Case 746
			$message[1] = 'ERROR_PRIMARY_TRANSPORT_CONNECT_FAILED'
			$message[2] = '{Connect Failure on Primary Transport} An attempt was made to connect to the remote server %hs on the primary transport, but the connection failed. The computer WAS able to connect on a secondary transport.'

		Case 747
			$message[1] = 'ERROR_PAGE_FAULT_TRANSITION'
			$message[2] = 'Page fault was a transition fault.'

		Case 748
			$message[1] = 'ERROR_PAGE_FAULT_DEMAND_ZERO'
			$message[2] = 'Page fault was a demand zero fault.'

		Case 749
			$message[1] = 'ERROR_PAGE_FAULT_COPY_ON_WRITE'
			$message[2] = 'Page fault was a demand zero fault.'

		Case 750
			$message[1] = 'ERROR_PAGE_FAULT_GUARD_PAGE'
			$message[2] = 'Page fault was a demand zero fault.'

		Case 751
			$message[1] = 'ERROR_PAGE_FAULT_PAGING_FILE'
			$message[2] = 'Page fault was satisfied by reading from a secondary storage device.'

		Case 752
			$message[1] = 'ERROR_CACHE_PAGE_LOCKED'
			$message[2] = 'Cached page was locked during operation.'

		Case 753
			$message[1] = 'ERROR_CRASH_DUMP'
			$message[2] = 'Crash dump exists in paging file.'

		Case 754
			$message[1] = 'ERROR_BUFFER_ALL_ZEROS'
			$message[2] = 'Specified buffer contains all zeros.'

		Case 755
			$message[1] = 'ERROR_REPARSE_OBJECT'
			$message[2] = 'A reparse should be performed by the Object Manager since the name of the file resulted in a symbolic link.'

		Case 756
			$message[1] = 'ERROR_RESOURCE_REQUIREMENTS_CHANGED'
			$message[2] = 'The device has succeeded a query-stop and its resource requirements have changed.'

		Case 757
			$message[1] = 'ERROR_TRANSLATION_COMPLETE'
			$message[2] = 'The translator has translated these resources into the global space and no further translations should be performed.'

		Case 758
			$message[1] = 'ERROR_NOTHING_TO_TERMINATE'
			$message[2] = 'A process being terminated has no threads to terminate.'

		Case 759
			$message[1] = 'ERROR_PROCESS_NOT_IN_JOB'
			$message[2] = 'The specified process is not part of a job.'

		Case 760
			$message[1] = 'ERROR_PROCESS_IN_JOB'
			$message[2] = 'The specified process is part of a job.'

		Case 761
			$message[1] = 'ERROR_VOLSNAP_HIBERNATE_READY'
			$message[2] = '{Volume Shadow Copy Service} The system is now ready for hibernation.'

		Case 762
			$message[1] = 'ERROR_FSFILTER_OP_COMPLETED_SUCCESSFULLY'
			$message[2] = 'A file system or file system filter driver has successfully completed an FsFilter operation.'

		Case 763
			$message[1] = 'ERROR_INTERRUPT_VECTOR_ALREADY_CONNECTED'
			$message[2] = 'The specified interrupt vector was already connected.'

		Case 764
			$message[1] = 'ERROR_INTERRUPT_STILL_CONNECTED'
			$message[2] = 'The specified interrupt vector is still connected.'

		Case 765
			$message[1] = 'ERROR_WAIT_FOR_OPLOCK'
			$message[2] = 'An operation is blocked waiting for an oplock.'

		Case 766
			$message[1] = 'ERROR_DBG_EXCEPTION_HANDLED'
			$message[2] = 'Debugger handled exception'

		Case 767
			$message[1] = 'ERROR_DBG_CONTINUE'
			$message[2] = 'Debugger continued'

		Case 768
			$message[1] = 'ERROR_CALLBACK_POP_STACK'
			$message[2] = 'An exception occurred in a user mode callback and the kernel callback frame should be removed.'

		Case 769
			$message[1] = 'ERROR_COMPRESSION_DISABLED'
			$message[2] = 'Compression is disabled for this volume.'

		Case 770
			$message[1] = 'ERROR_CANTFETCHBACKWARDS'
			$message[2] = 'The data provider cannot fetch backwards through a result set.'

		Case 771
			$message[1] = 'ERROR_CANTSCROLLBACKWARDS'
			$message[2] = 'The data provider cannot scroll backwards through a result set.'

		Case 772
			$message[1] = 'ERROR_ROWSNOTRELEASED'
			$message[2] = 'The data provider requires that previously fetched data is released before asking for more data.'

		Case 773
			$message[1] = 'ERROR_BAD_ACCESSOR_FLAGS'
			$message[2] = 'The data provider was not able to intrepret the flags set for a column binding in an accessor.'

		Case 774
			$message[1] = 'ERROR_ERRORS_ENCOUNTERED'
			$message[2] = 'One or more errors occurred while processing the request.'

		Case 775
			$message[1] = 'ERROR_NOT_CAPABLE'
			$message[2] = 'The implementation is not capable of performing the request.'

		Case 776
			$message[1] = 'ERROR_REQUEST_OUT_OF_SEQUENCE'
			$message[2] = 'The client of a component requested an operation which is not valid given the state of the component instance.'

		Case 777
			$message[1] = 'ERROR_VERSION_PARSE_ERROR'
			$message[2] = 'A version number could not be parsed.'

		Case 778
			$message[1] = 'ERROR_BADSTARTPOSITION'
			$message[2] = 'The iterator''s start position is invalid.'

		Case 779
			$message[1] = 'ERROR_MEMORY_HARDWARE'
			$message[2] = 'The hardware has reported an uncorrectable memory error.'

		Case 780
			$message[1] = 'ERROR_DISK_REPAIR_DISABLED'
			$message[2] = 'The attempted operation required self healing to be enabled.'

		Case 781
			$message[1] = 'ERROR_INSUFFICIENT_RESOURCE_FOR_SPECIFIED_SHARED_SECTION_SIZE'
			$message[2] = 'The Desktop heap encountered an error while allocating session memory. There is more information in the system event log.'

		Case 782
			$message[1] = 'ERROR_SYSTEM_POWERSTATE_TRANSITION'
			$message[2] = 'The system powerstate is transitioning from %2 to %3.'

		Case 783
			$message[1] = 'ERROR_SYSTEM_POWERSTATE_COMPLEX_TRANSITION'
			$message[2] = 'The system powerstate is transitioning from %2 to %3 but could enter %4.'

		Case 784
			$message[1] = 'ERROR_MCA_EXCEPTION'
			$message[2] = 'A thread is getting dispatched with MCA EXCEPTION because of MCA.'

		Case 785
			$message[1] = 'ERROR_ACCESS_AUDIT_BY_POLICY'
			$message[2] = 'Access to %1 is monitored by policy rule %2.'

		Case 786
			$message[1] = 'ERROR_ACCESS_DISABLED_NO_SAFER_UI_BY_POLICY'
			$message[2] = 'Access to %1 has been restricted by your Administrator by policy rule %2.'

		Case 787
			$message[1] = 'ERROR_ABANDON_HIBERFILE'
			$message[2] = 'A valid hibernation file has been invalidated and should be abandoned.'

		Case 788
			$message[1] = 'ERROR_LOST_WRITEBEHIND_DATA_NETWORK_DISCONNECTED'
			$message[2] = '{Delayed Write Failed} Windows was unable to save all the data for the file %hs; the data has been lost. This error may be caused by network connectivity issues. Please try to save this file elsewhere. '

		Case 789
			$message[1] = 'ERROR_LOST_WRITEBEHIND_DATA_NETWORK_SERVER_ERROR'
			$message[2] = '{Delayed Write Failed} Windows was unable to save all the data for the file %hs; the data has been lost. This error was returned by the server on which the file exists. Please try to save this file elsewhere. '

		Case 790
			$message[1] = 'ERROR_LOST_WRITEBEHIND_DATA_LOCAL_DISK_ERROR'
			$message[2] = '{Delayed Write Failed} Windows was unable to save all the data for the file %hs; the data has been lost. This error may be caused if the device has been removed or the media is write-protected. '

		Case 791
			$message[1] = 'ERROR_BAD_MCFG_TABLE'
			$message[2] = 'The resources required for this device conflict with the MCFG table.'

		Case 994
			$message[1] = 'ERROR_EA_ACCESS_DENIED'
			$message[2] = 'Access to the extended attribute was denied.'

		Case 995
			$message[1] = 'ERROR_OPERATION_ABORTED'
			$message[2] = 'The I/O operation has been aborted because of either a thread exit or an application request.'

		Case 996
			$message[1] = 'ERROR_IO_INCOMPLETE'
			$message[2] = 'Overlapped I/O event is not in a signaled state.'

		Case 997
			$message[1] = 'ERROR_IO_PENDING'
			$message[2] = 'Overlapped I/O operation is in progress.'

		Case 998
			$message[1] = 'ERROR_NOACCESS'
			$message[2] = 'Invalid access to memory location.'

		Case 999
			$message[1] = 'ERROR_SWAPERROR'
			$message[2] = 'Error performing inpage operation.'

		Case 1001
			$message[1] = 'ERROR_STACK_OVERFLOW'
			$message[2] = 'Recursion too deep; the stack overflowed.'

		Case 1002
			$message[1] = 'ERROR_INVALID_MESSAGE'
			$message[2] = 'The window cannot act on the sent message.'

		Case 1003
			$message[1] = 'ERROR_CAN_NOT_COMPLETE'
			$message[2] = 'Cannot complete this function.'

		Case 1004
			$message[1] = 'ERROR_INVALID_FLAGS'
			$message[2] = 'Invalid flags.'

		Case 1005
			$message[1] = 'ERROR_UNRECOGNIZED_VOLUME'
			$message[2] = 'The volume does not contain a recognized file system. Please make sure that all required file system drivers are loaded and that the volume is not corrupted.'

		Case 1006
			$message[1] = 'ERROR_FILE_INVALID'
			$message[2] = 'The volume for a file has been externally altered so that the opened file is no longer valid.'

		Case 1007
			$message[1] = 'ERROR_FULLSCREEN_MODE'
			$message[2] = 'The requested operation cannot be performed in full-screen mode.'

		Case 1008
			$message[1] = 'ERROR_NO_TOKEN'
			$message[2] = 'An attempt was made to reference a token that does not exist.'

		Case 1009
			$message[1] = 'ERROR_BADDB'
			$message[2] = 'The configuration registry database is corrupt.'

		Case 1010
			$message[1] = 'ERROR_BADKEY'
			$message[2] = 'The configuration registry key is invalid.'

		Case 1011
			$message[1] = 'ERROR_CANTOPEN'
			$message[2] = 'The configuration registry key could not be opened.'

		Case 1012
			$message[1] = 'ERROR_CANTREAD'
			$message[2] = 'The configuration registry key could not be read.'

		Case 1013
			$message[1] = 'ERROR_CANTWRITE'
			$message[2] = 'The configuration registry key could not be written.'

		Case 1014
			$message[1] = 'ERROR_REGISTRY_RECOVERED'
			$message[2] = 'One of the files in the registry database had to be recovered by use of a log or alternate copy. The recovery was successful.'

		Case 1015
			$message[1] = 'ERROR_REGISTRY_CORRUPT'
			$message[2] = 'The registry is corrupted. The structure of one of the files containing registry data is corrupted, or the system''s memory image of the file is corrupted, or the file could not be recovered because the alternate copy or log was absent or corrupted.'

		Case 1016
			$message[1] = 'ERROR_REGISTRY_IO_FAILED'
			$message[2] = 'An I/O operation initiated by the registry failed unrecoverably. The registry could not read in, or write out, or flush, one of the files that contain the system''s image of the registry.'

		Case 1017
			$message[1] = 'ERROR_NOT_REGISTRY_FILE'
			$message[2] = 'The system has attempted to load or restore a file into the registry, but the specified file is not in a registry file format.'

		Case 1018
			$message[1] = 'ERROR_KEY_DELETED'
			$message[2] = 'Illegal operation attempted on a registry key that has been marked for deletion.'

		Case 1019
			$message[1] = 'ERROR_NO_LOG_SPACE'
			$message[2] = 'System could not allocate the required space in a registry log.'

		Case 1020
			$message[1] = 'ERROR_KEY_HAS_CHILDREN'
			$message[2] = 'Cannot create a symbolic link in a registry key that already has subkeys or values.'

		Case 1021
			$message[1] = 'ERROR_CHILD_MUST_BE_VOLATILE'
			$message[2] = 'Cannot create a stable subkey under a volatile parent key.'

		Case 1022
			$message[1] = 'ERROR_NOTIFY_ENUM_DIR'
			$message[2] = 'A notify change request is being completed and the information is not being returned in the caller''s buffer. The caller now needs to enumerate the files to find the changes.'

		Case 1051
			$message[1] = 'ERROR_DEPENDENT_SERVICES_RUNNING'
			$message[2] = 'A stop control has been sent to a service that other running services are dependent on.'

		Case 1052
			$message[1] = 'ERROR_INVALID_SERVICE_CONTROL'
			$message[2] = 'The requested control is not valid for this service.'

		Case 1053
			$message[1] = 'ERROR_SERVICE_REQUEST_TIMEOUT'
			$message[2] = 'The service did not respond to the start or control request in a timely fashion.'

		Case 1054
			$message[1] = 'ERROR_SERVICE_NO_THREAD'
			$message[2] = 'A thread could not be created for the service.'

		Case 1055
			$message[1] = 'ERROR_SERVICE_DATABASE_LOCKED'
			$message[2] = 'The service database is locked.'

		Case 1056
			$message[1] = 'ERROR_SERVICE_ALREADY_RUNNING'
			$message[2] = 'An instance of the service is already running.'

		Case 1057
			$message[1] = 'ERROR_INVALID_SERVICE_ACCOUNT'
			$message[2] = 'The account name is invalid or does not exist, or the password is invalid for the account name specified.'

		Case 1058
			$message[1] = 'ERROR_SERVICE_DISABLED'
			$message[2] = 'The service cannot be started, either because it is disabled or because it has no enabled devices associated with it.'

		Case 1059
			$message[1] = 'ERROR_CIRCULAR_DEPENDENCY'
			$message[2] = 'Circular service dependency was specified.'

		Case 1060
			$message[1] = 'ERROR_SERVICE_DOES_NOT_EXIST'
			$message[2] = 'The specified service does not exist as an installed service.'

		Case 1061
			$message[1] = 'ERROR_SERVICE_CANNOT_ACCEPT_CTRL'
			$message[2] = 'The service cannot accept control messages at this time.'

		Case 1062
			$message[1] = 'ERROR_SERVICE_NOT_ACTIVE'
			$message[2] = 'The service has not been started.'

		Case 1063
			$message[1] = 'ERROR_FAILED_SERVICE_CONTROLLER_CONNECT'
			$message[2] = 'The service process could not connect to the service controller.'

		Case 1064
			$message[1] = 'ERROR_EXCEPTION_IN_SERVICE'
			$message[2] = 'An exception occurred in the service when handling the control request.'

		Case 1065
			$message[1] = 'ERROR_DATABASE_DOES_NOT_EXIST'
			$message[2] = 'The database specified does not exist.'

		Case 1066
			$message[1] = 'ERROR_SERVICE_SPECIFIC_ERROR'
			$message[2] = 'The service has returned a service-specific error code.'

		Case 1067
			$message[1] = 'ERROR_PROCESS_ABORTED'
			$message[2] = 'The process terminated unexpectedly.'

		Case 1068
			$message[1] = 'ERROR_SERVICE_DEPENDENCY_FAIL'
			$message[2] = 'The dependency service or group failed to start.'

		Case 1069
			$message[1] = 'ERROR_SERVICE_LOGON_FAILED'
			$message[2] = 'The service did not start due to a logon failure.'

		Case 1070
			$message[1] = 'ERROR_SERVICE_START_HANG'
			$message[2] = 'After starting, the service hung in a start-pending state.'

		Case 1071
			$message[1] = 'ERROR_INVALID_SERVICE_LOCK'
			$message[2] = 'The specified service database lock is invalid.'

		Case 1072
			$message[1] = 'ERROR_SERVICE_MARKED_FOR_DELETE'
			$message[2] = 'The specified service has been marked for deletion.'

		Case 1073
			$message[1] = 'ERROR_SERVICE_EXISTS'
			$message[2] = 'The specified service already exists.'

		Case 1074
			$message[1] = 'ERROR_ALREADY_RUNNING_LKG'
			$message[2] = 'The system is currently running with the last-known-good configuration.'

		Case 1075
			$message[1] = 'ERROR_SERVICE_DEPENDENCY_DELETED'
			$message[2] = 'The dependency service does not exist or has been marked for deletion.'

		Case 1076
			$message[1] = 'ERROR_BOOT_ALREADY_ACCEPTED'
			$message[2] = 'The current boot has already been accepted for use as the last-known-good control set.'

		Case 1077
			$message[1] = 'ERROR_SERVICE_NEVER_STARTED'
			$message[2] = 'No attempts to start the service have been made since the last boot.'

		Case 1078
			$message[1] = 'ERROR_DUPLICATE_SERVICE_NAME'
			$message[2] = 'The name is already in use as either a service name or a service display name.'

		Case 1079
			$message[1] = 'ERROR_DIFFERENT_SERVICE_ACCOUNT'
			$message[2] = 'The account specified for this service is different from the account specified for other services running in the same process.'

		Case 1080
			$message[1] = 'ERROR_CANNOT_DETECT_DRIVER_FAILURE'
			$message[2] = 'Failure actions can only be set for Win32 services, not for drivers.'

		Case 1081
			$message[1] = 'ERROR_CANNOT_DETECT_PROCESS_ABORT'
			$message[2] = 'This service runs in the same process as the service control manager. Therefore, the service control manager cannot take action if this service''s process terminates unexpectedly.'

		Case 1082
			$message[1] = 'ERROR_NO_RECOVERY_PROGRAM'
			$message[2] = 'No recovery program has been configured for this service.'

		Case 1083
			$message[1] = 'ERROR_SERVICE_NOT_IN_EXE'
			$message[2] = 'The executable program that this service is configured to run in does not implement the service.'

		Case 1084
			$message[1] = 'ERROR_NOT_SAFEBOOT_SERVICE'
			$message[2] = 'This service cannot be started in Safe Mode'

		Case 1100
			$message[1] = 'ERROR_END_OF_MEDIA'
			$message[2] = 'The physical end of the tape has been reached.'

		Case 1101
			$message[1] = 'ERROR_FILEMARK_DETECTED'
			$message[2] = 'A tape access reached a filemark.'

		Case 1102
			$message[1] = 'ERROR_BEGINNING_OF_MEDIA'
			$message[2] = 'The beginning of the tape or a partition was encountered.'

		Case 1103
			$message[1] = 'ERROR_SETMARK_DETECTED'
			$message[2] = 'A tape access reached the end of a set of files.'

		Case 1104
			$message[1] = 'ERROR_NO_DATA_DETECTED'
			$message[2] = 'No more data is on the tape.'

		Case 1105
			$message[1] = 'ERROR_PARTITION_FAILURE'
			$message[2] = 'Tape could not be partitioned.'

		Case 1106
			$message[1] = 'ERROR_INVALID_BLOCK_LENGTH'
			$message[2] = 'When accessing a new tape of a multivolume partition, the current block size is incorrect.'

		Case 1107
			$message[1] = 'ERROR_DEVICE_NOT_PARTITIONED'
			$message[2] = 'Tape partition information could not be found when loading a tape.'

		Case 1108
			$message[1] = 'ERROR_UNABLE_TO_LOCK_MEDIA'
			$message[2] = 'Unable to lock the media eject mechanism.'

		Case 1109
			$message[1] = 'ERROR_UNABLE_TO_UNLOAD_MEDIA'
			$message[2] = 'Unable to unload the media.'

		Case 1110
			$message[1] = 'ERROR_MEDIA_CHANGED'
			$message[2] = 'The media in the drive may have changed.'

		Case 1111
			$message[1] = 'ERROR_BUS_RESET'
			$message[2] = 'The I/O bus was reset.'

		Case 1112
			$message[1] = 'ERROR_NO_MEDIA_IN_DRIVE'
			$message[2] = 'No media in drive.'

		Case 1113
			$message[1] = 'ERROR_NO_UNICODE_TRANSLATION'
			$message[2] = 'No mapping for the Unicode character exists in the target multi-byte code page.'

		Case 1114
			$message[1] = 'ERROR_DLL_INIT_FAILED'
			$message[2] = 'A dynamic link library (DLL) initialization routine failed.'

		Case 1115
			$message[1] = 'ERROR_SHUTDOWN_IN_PROGRESS'
			$message[2] = 'A system shutdown is in progress.'

		Case 1116
			$message[1] = 'ERROR_NO_SHUTDOWN_IN_PROGRESS'
			$message[2] = 'Unable to abort the system shutdown because no shutdown was in progress.'

		Case 1117
			$message[1] = 'ERROR_IO_DEVICE'
			$message[2] = 'The request could not be performed because of an I/O device error.'

		Case 1118
			$message[1] = 'ERROR_SERIAL_NO_DEVICE'
			$message[2] = 'No serial device was successfully initialized. The serial driver will unload.'

		Case 1119
			$message[1] = 'ERROR_IRQ_BUSY'
			$message[2] = 'Unable to open a device that was sharing an interrupt request (IRQ) with other devices. At least one other device that uses that IRQ was already opened.'

		Case 1120
			$message[1] = 'ERROR_MORE_WRITES'
			$message[2] = 'A serial I/O operation was completed by another write to the serial port. The IOCTL_SERIAL_XOFF_COUNTER reached zero.)'

		Case 1121
			$message[1] = 'ERROR_COUNTER_TIMEOUT'
			$message[2] = 'A serial I/O operation completed because the timeout period expired. The IOCTL_SERIAL_XOFF_COUNTER did not reach zero.)'

		Case 1122
			$message[1] = 'ERROR_FLOPPY_ID_MARK_NOT_FOUND'
			$message[2] = 'No ID address mark was found on the floppy disk.'

		Case 1123
			$message[1] = 'ERROR_FLOPPY_WRONG_CYLINDER'
			$message[2] = 'Mismatch between the floppy disk sector ID field and the floppy disk controller track address.'

		Case 1124
			$message[1] = 'ERROR_FLOPPY_UNKNOWN_ERROR'
			$message[2] = 'The floppy disk controller reported an error that is not recognized by the floppy disk driver.'

		Case 1125
			$message[1] = 'ERROR_FLOPPY_BAD_REGISTERS'
			$message[2] = 'The floppy disk controller returned inconsistent results in its registers.'

		Case 1126
			$message[1] = 'ERROR_DISK_RECALIBRATE_FAILED'
			$message[2] = 'While accessing the hard disk, a recalibrate operation failed, even after retries.'

		Case 1127
			$message[1] = 'ERROR_DISK_OPERATION_FAILED'
			$message[2] = 'While accessing the hard disk, a disk operation failed even after retries.'

		Case 1128
			$message[1] = 'ERROR_DISK_RESET_FAILED'
			$message[2] = 'While accessing the hard disk, a disk controller reset was needed, but even that failed.'

		Case 1129
			$message[1] = 'ERROR_EOM_OVERFLOW'
			$message[2] = 'Physical end of tape encountered.'

		Case 1130
			$message[1] = 'ERROR_NOT_ENOUGH_SERVER_MEMORY'
			$message[2] = 'Not enough server storage is available to process this command.'

		Case 1131
			$message[1] = 'ERROR_POSSIBLE_DEADLOCK'
			$message[2] = 'A potential deadlock condition has been detected.'

		Case 1132
			$message[1] = 'ERROR_MAPPED_ALIGNMENT'
			$message[2] = 'The base address or the file offset specified does not have the proper alignment.'

		Case 1140
			$message[1] = 'ERROR_SET_POWER_STATE_VETOED'
			$message[2] = 'An attempt to change the system power state was vetoed by another application or driver.'

		Case 1141
			$message[1] = 'ERROR_SET_POWER_STATE_FAILED'
			$message[2] = 'The system BIOS failed an attempt to change the system power state.'

		Case 1142
			$message[1] = 'ERROR_TOO_MANY_LINKS'
			$message[2] = 'An attempt was made to create more links on a file than the file system supports.'

		Case 1150
			$message[1] = 'ERROR_OLD_WIN_VERSION'
			$message[2] = 'The specified program requires a newer version of Windows.'

		Case 1151
			$message[1] = 'ERROR_APP_WRONG_OS'
			$message[2] = 'The specified program is not a Windows or MS-DOS program.'

		Case 1152
			$message[1] = 'ERROR_SINGLE_INSTANCE_APP'
			$message[2] = 'Cannot start more than one instance of the specified program.'

		Case 1153
			$message[1] = 'ERROR_RMODE_APP'
			$message[2] = 'The specified program was written for an earlier version of Windows.'

		Case 1154
			$message[1] = 'ERROR_INVALID_DLL'
			$message[2] = 'One of the library files needed to run this application is damaged.'

		Case 1155
			$message[1] = 'ERROR_NO_ASSOCIATION'
			$message[2] = 'No application is associated with the specified file for this operation.'

		Case 1156
			$message[1] = 'ERROR_DDE_FAIL'
			$message[2] = 'An error occurred in sending the command to the application.'

		Case 1157
			$message[1] = 'ERROR_DLL_NOT_FOUND'
			$message[2] = 'One of the library files needed to run this application cannot be found.'

		Case 1158
			$message[1] = 'ERROR_NO_MORE_USER_HANDLES'
			$message[2] = 'The current process has used all of its system allowance of handles for Window Manager objects.'

		Case 1159
			$message[1] = 'ERROR_MESSAGE_SYNC_ONLY'
			$message[2] = 'The message can be used only with synchronous operations.'

		Case 1160
			$message[1] = 'ERROR_SOURCE_ELEMENT_EMPTY'
			$message[2] = 'The indicated source element has no media.'

		Case 1161
			$message[1] = 'ERROR_DESTINATION_ELEMENT_FULL'
			$message[2] = 'The indicated destination element already contains media.'

		Case 1162
			$message[1] = 'ERROR_ILLEGAL_ELEMENT_ADDRESS'
			$message[2] = 'The indicated element does not exist.'

		Case 1163
			$message[1] = 'ERROR_MAGAZINE_NOT_PRESENT'
			$message[2] = 'The indicated element is part of a magazine that is not present.'

		Case 1164
			$message[1] = 'ERROR_DEVICE_REINITIALIZATION_NEEDED'
			$message[2] = 'The indicated device requires reinitialization due to hardware errors.'

		Case 1165
			$message[1] = 'ERROR_DEVICE_REQUIRES_CLEANING'
			$message[2] = 'The device has indicated that cleaning is required before further operations are attempted.'

		Case 1166
			$message[1] = 'ERROR_DEVICE_DOOR_OPEN'
			$message[2] = 'The device has indicated that its door is open.'

		Case 1167
			$message[1] = 'ERROR_DEVICE_NOT_CONNECTED'
			$message[2] = 'The device is not connected.'

		Case 1168
			$message[1] = 'ERROR_NOT_FOUND'
			$message[2] = 'Element not found.'

		Case 1169
			$message[1] = 'ERROR_NO_MATCH'
			$message[2] = 'There was no match for the specified key in the index.'

		Case 1170
			$message[1] = 'ERROR_SET_NOT_FOUND'
			$message[2] = 'The property set specified does not exist on the object.'

		Case 1171
			$message[1] = 'ERROR_POINT_NOT_FOUND'
			$message[2] = 'The point passed to GetMouseMovePoints is not in the buffer.'

		Case 1172
			$message[1] = 'ERROR_NO_TRACKING_SERVICE'
			$message[2] = 'The tracking (workstation) service is not running.'

		Case 1173
			$message[1] = 'ERROR_NO_VOLUME_ID'
			$message[2] = 'The Volume ID could not be found.'

		Case 1175
			$message[1] = 'ERROR_UNABLE_TO_REMOVE_REPLACED'
			$message[2] = 'Unable to remove the file to be replaced.'

		Case 1176
			$message[1] = 'ERROR_UNABLE_TO_MOVE_REPLACEMENT'
			$message[2] = 'Unable to move the replacement file to the file to be replaced. The file to be replaced has retained its original name.'

		Case 1177
			$message[1] = 'ERROR_UNABLE_TO_MOVE_REPLACEMENT_2'
			$message[2] = 'Unable to move the replacement file to the file to be replaced. The file to be replaced has been renamed using the backup name.'

		Case 1178
			$message[1] = 'ERROR_JOURNAL_DELETE_IN_PROGRESS'
			$message[2] = 'The volume change journal is being deleted.'

		Case 1179
			$message[1] = 'ERROR_JOURNAL_NOT_ACTIVE'
			$message[2] = 'The volume change journal is not active.'

		Case 1180
			$message[1] = 'ERROR_POTENTIAL_FILE_FOUND'
			$message[2] = 'A file was found, but it may not be the correct file.'

		Case 1181
			$message[1] = 'ERROR_JOURNAL_ENTRY_DELETED'
			$message[2] = 'The journal entry has been deleted from the journal.'

		Case 1190
			$message[1] = 'ERROR_SHUTDOWN_IS_SCHEDULED'
			$message[2] = 'A system shutdown has already been scheduled.'

		Case 1191
			$message[1] = 'ERROR_SHUTDOWN_USERS_LOGGED_ON'
			$message[2] = 'The system shutdown cannot be initiated because there are other users logged on to the computer.'

		Case 1200
			$message[1] = 'ERROR_BAD_DEVICE'
			$message[2] = 'The specified device name is invalid.'

		Case 1201
			$message[1] = 'ERROR_CONNECTION_UNAVAIL'
			$message[2] = 'The device is not currently connected but it is a remembered connection.'

		Case 1202
			$message[1] = 'ERROR_DEVICE_ALREADY_REMEMBERED'
			$message[2] = 'The local device name has a remembered connection to another network resource.'

		Case 1203
			$message[1] = 'ERROR_NO_NET_OR_BAD_PATH'
			$message[2] = 'The network path was either typed incorrectly, does not exist, or the network provider is not currently available. Please try retyping the path or contact your network administrator.'

		Case 1204
			$message[1] = 'ERROR_BAD_PROVIDER'
			$message[2] = 'The specified network provider name is invalid.'

		Case 1205
			$message[1] = 'ERROR_CANNOT_OPEN_PROFILE'
			$message[2] = 'Unable to open the network connection profile.'

		Case 1206
			$message[1] = 'ERROR_BAD_PROFILE'
			$message[2] = 'The network connection profile is corrupted.'

		Case 1207
			$message[1] = 'ERROR_NOT_CONTAINER'
			$message[2] = 'Cannot enumerate a noncontainer.'

		Case 1208
			$message[1] = 'ERROR_EXTENDED_ERROR'
			$message[2] = 'An extended error has occurred.'

		Case 1209
			$message[1] = 'ERROR_INVALID_GROUPNAME'
			$message[2] = 'The format of the specified group name is invalid.'

		Case 1210
			$message[1] = 'ERROR_INVALID_COMPUTERNAME'
			$message[2] = 'The format of the specified computer name is invalid.'

		Case 1211
			$message[1] = 'ERROR_INVALID_EVENTNAME'
			$message[2] = 'The format of the specified event name is invalid.'

		Case 1212
			$message[1] = 'ERROR_INVALID_DOMAINNAME'
			$message[2] = 'The format of the specified domain name is invalid.'

		Case 1213
			$message[1] = 'ERROR_INVALID_SERVICENAME'
			$message[2] = 'The format of the specified service name is invalid.'

		Case 1214
			$message[1] = 'ERROR_INVALID_NETNAME'
			$message[2] = 'The format of the specified network name is invalid.'

		Case 1215
			$message[1] = 'ERROR_INVALID_SHARENAME'
			$message[2] = 'The format of the specified share name is invalid.'

		Case 1216
			$message[1] = 'ERROR_INVALID_PASSWORDNAME'
			$message[2] = 'The format of the specified password is invalid.'

		Case 1217
			$message[1] = 'ERROR_INVALID_MESSAGENAME'
			$message[2] = 'The format of the specified message name is invalid.'

		Case 1218
			$message[1] = 'ERROR_INVALID_MESSAGEDEST'
			$message[2] = 'The format of the specified message destination is invalid.'

		Case 1219
			$message[1] = 'ERROR_SESSION_CREDENTIAL_CONFLICT'
			$message[2] = 'Multiple connections to a server or shared resource by the same user, using more than one user name, are not allowed. Disconnect all previous connections to the server or shared resource and try again.'

		Case 1220
			$message[1] = 'ERROR_REMOTE_SESSION_LIMIT_EXCEEDED'
			$message[2] = 'An attempt was made to establish a session to a network server, but there are already too many sessions established to that server.'

		Case 1221
			$message[1] = 'ERROR_DUP_DOMAINNAME'
			$message[2] = 'The workgroup or domain name is already in use by another computer on the network.'

		Case 1222
			$message[1] = 'ERROR_NO_NETWORK'
			$message[2] = 'The network is not present or not started.'

		Case 1223
			$message[1] = 'ERROR_CANCELLED'
			$message[2] = 'The operation was canceled by the user.'

		Case 1224
			$message[1] = 'ERROR_USER_MAPPED_FILE'
			$message[2] = 'The requested operation cannot be performed on a file with a user-mapped section open.'

		Case 1225
			$message[1] = 'ERROR_CONNECTION_REFUSED'
			$message[2] = 'The remote computer refused the network connection.'

		Case 1226
			$message[1] = 'ERROR_GRACEFUL_DISCONNECT'
			$message[2] = 'The network connection was gracefully closed.'

		Case 1227
			$message[1] = 'ERROR_ADDRESS_ALREADY_ASSOCIATED'
			$message[2] = 'The network transport endpoint already has an address associated with it.'

		Case 1228
			$message[1] = 'ERROR_ADDRESS_NOT_ASSOCIATED'
			$message[2] = 'An address has not yet been associated with the network endpoint.'

		Case 1229
			$message[1] = 'ERROR_CONNECTION_INVALID'
			$message[2] = 'An operation was attempted on a nonexistent network connection.'

		Case 1230
			$message[1] = 'ERROR_CONNECTION_ACTIVE'
			$message[2] = 'An invalid operation was attempted on an active network connection.'

		Case 1231
			$message[1] = 'ERROR_NETWORK_UNREACHABLE'
			$message[2] = 'The network location cannot be reached. For information about network troubleshooting, see Windows Help.'

		Case 1232
			$message[1] = 'ERROR_HOST_UNREACHABLE'
			$message[2] = 'The network location cannot be reached. For information about network troubleshooting, see Windows Help.'

		Case 1233
			$message[1] = 'ERROR_PROTOCOL_UNREACHABLE'
			$message[2] = 'The network location cannot be reached. For information about network troubleshooting, see Windows Help.'

		Case 1234
			$message[1] = 'ERROR_PORT_UNREACHABLE'
			$message[2] = 'No service is operating at the destination network endpoint on the remote system.'

		Case 1235
			$message[1] = 'ERROR_REQUEST_ABORTED'
			$message[2] = 'The request was aborted.'

		Case 1236
			$message[1] = 'ERROR_CONNECTION_ABORTED'
			$message[2] = 'The network connection was aborted by the local system.'

		Case 1237
			$message[1] = 'ERROR_RETRY'
			$message[2] = 'The operation could not be completed. A retry should be performed.'

		Case 1238
			$message[1] = 'ERROR_CONNECTION_COUNT_LIMIT'
			$message[2] = 'A connection to the server could not be made because the limit on the number of concurrent connections for this account has been reached.'

		Case 1239
			$message[1] = 'ERROR_LOGIN_TIME_RESTRICTION'
			$message[2] = 'Attempting to log in during an unauthorized time of day for this account.'

		Case 1240
			$message[1] = 'ERROR_LOGIN_WKSTA_RESTRICTION'
			$message[2] = 'The account is not authorized to log in from this station.'

		Case 1241
			$message[1] = 'ERROR_INCORRECT_ADDRESS'
			$message[2] = 'The network address could not be used for the operation requested.'

		Case 1242
			$message[1] = 'ERROR_ALREADY_REGISTERED'
			$message[2] = 'The service is already registered.'

		Case 1243
			$message[1] = 'ERROR_SERVICE_NOT_FOUND'
			$message[2] = 'The specified service does not exist.'

		Case 1244
			$message[1] = 'ERROR_NOT_AUTHENTICATED'
			$message[2] = 'The operation being requested was not performed because the user has not been authenticated.'

		Case 1245
			$message[1] = 'ERROR_NOT_LOGGED_ON'
			$message[2] = 'The operation being requested was not performed because the user has not logged on to the network. The specified service does not exist.'

		Case 1246
			$message[1] = 'ERROR_CONTINUE'
			$message[2] = 'Continue with work in progress.'

		Case 1247
			$message[1] = 'ERROR_ALREADY_INITIALIZED'
			$message[2] = 'An attempt was made to perform an initialization operation when initialization has already been completed.'

		Case 1248
			$message[1] = 'ERROR_NO_MORE_DEVICES'
			$message[2] = 'No more local devices.'

		Case 1249
			$message[1] = 'ERROR_NO_SUCH_SITE'
			$message[2] = 'The specified site does not exist.'

		Case 1250
			$message[1] = 'ERROR_DOMAIN_CONTROLLER_EXISTS'
			$message[2] = 'A domain controller with the specified name already exists.'

		Case 1251
			$message[1] = 'ERROR_ONLY_IF_CONNECTED'
			$message[2] = 'This operation is supported only when you are connected to the server.'

		Case 1252
			$message[1] = 'ERROR_OVERRIDE_NOCHANGES'
			$message[2] = 'The group policy framework should call the extension even if there are no changes.'

		Case 1253
			$message[1] = 'ERROR_BAD_USER_PROFILE'
			$message[2] = 'The specified user does not have a valid profile.'

		Case 1254
			$message[1] = 'ERROR_NOT_SUPPORTED_ON_SBS'
			$message[2] = 'This operation is not supported on a computer running Windows Server 2003 for Small Business Server'

		Case 1255
			$message[1] = 'ERROR_SERVER_SHUTDOWN_IN_PROGRESS'
			$message[2] = 'The server machine is shutting down.'

		Case 1256
			$message[1] = 'ERROR_HOST_DOWN'
			$message[2] = 'The remote system is not available. For information about network troubleshooting, see Windows Help.'

		Case 1257
			$message[1] = 'ERROR_NON_ACCOUNT_SID'
			$message[2] = 'The security identifier provided is not from an account domain.'

		Case 1258
			$message[1] = 'ERROR_NON_DOMAIN_SID'
			$message[2] = 'The security identifier provided does not have a domain component.'

		Case 1259
			$message[1] = 'ERROR_APPHELP_BLOCK'
			$message[2] = 'AppHelp dialog canceled thus preventing the application from starting.'

		Case 1260
			$message[1] = 'ERROR_ACCESS_DISABLED_BY_POLICY'
			$message[2] = 'This program is blocked by group policy. For more information, contact your system administrator.'

		Case 1261
			$message[1] = 'ERROR_REG_NAT_CONSUMPTION'
			$message[2] = 'A program attempt to use an invalid register value. Normally caused by an uninitialized register. This error is Itanium specific.'

		Case 1262
			$message[1] = 'ERROR_CSCSHARE_OFFLINE'
			$message[2] = 'The share is currently offline or does not exist.'

		Case 1263
			$message[1] = 'ERROR_PKINIT_FAILURE'
			$message[2] = 'The kerberos protocol encountered an error while validating the KDC certificate during smartcard logon. There is more information in the system event log.'

		Case 1264
			$message[1] = 'ERROR_SMARTCARD_SUBSYSTEM_FAILURE'
			$message[2] = 'The kerberos protocol encountered an error while attempting to utilize the smartcard subsystem.'

		Case 1265
			$message[1] = 'ERROR_DOWNGRADE_DETECTED'
			$message[2] = 'The system detected a possible attempt to compromise security. Please ensure that you can contact the server that authenticated you.'

		Case 1271
			$message[1] = 'ERROR_MACHINE_LOCKED'
			$message[2] = 'The machine is locked and cannot be shut down without the force option.'

		Case 1273
			$message[1] = 'ERROR_CALLBACK_SUPPLIED_INVALID_DATA'
			$message[2] = 'An application-defined callback gave invalid data when called.'

		Case 1274
			$message[1] = 'ERROR_SYNC_FOREGROUND_REFRESH_REQUIRED'
			$message[2] = 'The group policy framework should call the extension in the synchronous foreground policy refresh.'

		Case 1275
			$message[1] = 'ERROR_DRIVER_BLOCKED'
			$message[2] = 'This driver has been blocked from loading'

		Case 1276
			$message[1] = 'ERROR_INVALID_IMPORT_OF_NON_DLL'
			$message[2] = 'A dynamic link library (DLL) referenced a module that was neither a DLL nor the process''s executable image.'

		Case 1277
			$message[1] = 'ERROR_ACCESS_DISABLED_WEBBLADE'
			$message[2] = 'Windows cannot open this program since it has been disabled.'

		Case 1278
			$message[1] = 'ERROR_ACCESS_DISABLED_WEBBLADE_TAMPER'
			$message[2] = 'Windows cannot open this program because the license enforcement system has been tampered with or become corrupted.'

		Case 1279
			$message[1] = 'ERROR_RECOVERY_FAILURE'
			$message[2] = 'A transaction recover failed.'

		Case 1280
			$message[1] = 'ERROR_ALREADY_FIBER'
			$message[2] = 'The current thread has already been converted to a fiber.'

		Case 1281
			$message[1] = 'ERROR_ALREADY_THREAD'
			$message[2] = 'The current thread has already been converted from a fiber.'

		Case 1282
			$message[1] = 'ERROR_STACK_BUFFER_OVERRUN'
			$message[2] = 'The system detected an overrun of a stack-based buffer in this application. This overrun could potentially allow a malicious user to gain control of this application.'

		Case 1283
			$message[1] = 'ERROR_PARAMETER_QUOTA_EXCEEDED'
			$message[2] = 'Data present in one of the parameters is more than the function can operate on.'

		Case 1284
			$message[1] = 'ERROR_DEBUGGER_INACTIVE'
			$message[2] = 'An attempt to do an operation on a debug object failed because the object is in the process of being deleted.'

		Case 1285
			$message[1] = 'ERROR_DELAY_LOAD_FAILED'
			$message[2] = 'An attempt to delay-load a .dll or get a function address in a delay-loaded .dll failed.'

		Case 1286
			$message[1] = 'ERROR_VDM_DISALLOWED'
			$message[2] = '%1 is a 16-bit application. You do not have permissions to execute 16-bit applications. Check your permissions with your system administrator.'

		Case 1287
			$message[1] = 'ERROR_UNIDENTIFIED_ERROR'
			$message[2] = 'Insufficient information exists to identify the cause of failure.'

		Case 1288
			$message[1] = 'ERROR_INVALID_CRUNTIME_PARAMETER'
			$message[2] = 'The parameter passed to a C runtime function is incorrect.'

		Case 1289
			$message[1] = 'ERROR_BEYOND_VDL'
			$message[2] = 'The operation occurred beyond the valid data length of the file.'

		Case 1290
			$message[1] = 'ERROR_INCOMPATIBLE_SERVICE_SID_TYPE'
			$message[2] = 'The service start failed since one or more services in the same process have an incompatible service SID type setting. A service with restricted service SID type can only coexist in the same process with other services with a restricted SID type. If the service SID type for this service was just configured, the hosting process must be restarted in order to start this service.'

		Case 1291
			$message[1] = 'ERROR_DRIVER_PROCESS_TERMINATED'
			$message[2] = 'The process hosting the driver for this device has been terminated.'

		Case 1292
			$message[1] = 'ERROR_IMPLEMENTATION_LIMIT'
			$message[2] = 'An operation attempted to exceed an implementation-defined limit.'

		Case 1293
			$message[1] = 'ERROR_PROCESS_IS_PROTECTED'
			$message[2] = 'Either the target process, or the target thread''s containing process, is a protected process.'

		Case 1294
			$message[1] = 'ERROR_SERVICE_NOTIFY_CLIENT_LAGGING'
			$message[2] = 'The service notification client is lagging too far behind the current state of services in the machine.'

		Case 1295
			$message[1] = 'ERROR_DISK_QUOTA_EXCEEDED'
			$message[2] = 'The requested file operation failed because the storage quota was exceeded. To free up disk space, move files to a different location or delete unnecessary files. For more information, contact your system administrator.'

		Case 1296
			$message[1] = 'ERROR_CONTENT_BLOCKED'
			$message[2] = 'The requested files operation failed because the storage policy blocks that type of file. For more information, contact your system administrator.'

		Case 1297
			$message[1] = 'ERROR_INCOMPATIBLE_SERVICE_PRIVILEGE '
			$message[2] = 'A privilege that the service requires to function properly does not exist in the service account configuration. You may use the Services Microsoft Management Console (MMC) snap-in (services.msc) and the Local Security Settings MMC snap-in (secpol.msc) to view the service configuration and the account configuration. '

		Case 1299
			$message[1] = 'ERROR_INVALID_LABEL'
			$message[2] = 'Indicates a particular Security ID may not be assigned as the label of an object.'

		Case 1300
			$message[1] = 'ERROR_NOT_ALL_ASSIGNED'
			$message[2] = 'Not all privileges or groups referenced are assigned to the caller.'

		Case 1301
			$message[1] = 'ERROR_SOME_NOT_MAPPED'
			$message[2] = 'Some mapping between account names and security IDs was not done.'

		Case 1302
			$message[1] = 'ERROR_NO_QUOTAS_FOR_ACCOUNT'
			$message[2] = 'No system quota limits are specifically set for this account.'

		Case 1303
			$message[1] = 'ERROR_LOCAL_USER_SESSION_KEY'
			$message[2] = 'No encryption key is available. A well-known encryption key was returned.'

		Case 1304
			$message[1] = 'ERROR_NULL_LM_PASSWORD'
			$message[2] = 'The password is too complex to be converted to a LAN Manager password. The LAN Manager password returned is a NULL string.'

		Case 1305
			$message[1] = 'ERROR_UNKNOWN_REVISION'
			$message[2] = 'The revision level is unknown.'

		Case 1306
			$message[1] = 'ERROR_REVISION_MISMATCH'
			$message[2] = 'Indicates two revision levels are incompatible.'

		Case 1307
			$message[1] = 'ERROR_INVALID_OWNER'
			$message[2] = 'This security ID may not be assigned as the owner of this object.'

		Case 1308
			$message[1] = 'ERROR_INVALID_PRIMARY_GROUP'
			$message[2] = 'This security ID may not be assigned as the primary group of an object.'

		Case 1309
			$message[1] = 'ERROR_NO_IMPERSONATION_TOKEN'
			$message[2] = 'An attempt has been made to operate on an impersonation token by a thread that is not currently impersonating a client.'

		Case 1310
			$message[1] = 'ERROR_CANT_DISABLE_MANDATORY'
			$message[2] = 'The group may not be disabled.'

		Case 1311
			$message[1] = 'ERROR_NO_LOGON_SERVERS'
			$message[2] = 'There are currently no logon servers available to service the logon request.'

		Case 1312
			$message[1] = 'ERROR_NO_SUCH_LOGON_SESSION'
			$message[2] = 'A specified logon session does not exist. It may already have been terminated.'

		Case 1313
			$message[1] = 'ERROR_NO_SUCH_PRIVILEGE'
			$message[2] = 'A specified privilege does not exist.'

		Case 1314
			$message[1] = 'ERROR_PRIVILEGE_NOT_HELD'
			$message[2] = 'A required privilege is not held by the client.'

		Case 1315
			$message[1] = 'ERROR_INVALID_ACCOUNT_NAME'
			$message[2] = 'The name provided is not a properly formed account name.'

		Case 1316
			$message[1] = 'ERROR_USER_EXISTS'
			$message[2] = 'The specified account already exists.'

		Case 1317
			$message[1] = 'ERROR_NO_SUCH_USER'
			$message[2] = 'The specified account does not exist.'

		Case 1318
			$message[1] = 'ERROR_GROUP_EXISTS'
			$message[2] = 'The specified group already exists.'

		Case 1319
			$message[1] = 'ERROR_NO_SUCH_GROUP'
			$message[2] = 'The specified group does not exist.'

		Case 1320
			$message[1] = 'ERROR_MEMBER_IN_GROUP'
			$message[2] = 'Either the specified user account is already a member of the specified group, or the specified group cannot be deleted because it contains a member.'

		Case 1321
			$message[1] = 'ERROR_MEMBER_NOT_IN_GROUP'
			$message[2] = 'The specified user account is not a member of the specified group account.'

		Case 1322
			$message[1] = 'ERROR_LAST_ADMIN'
			$message[2] = 'The last remaining administration account cannot be disabled or deleted.'

		Case 1323
			$message[1] = 'ERROR_WRONG_PASSWORD'
			$message[2] = 'Unable to update the password. The value provided as the current password is incorrect.'

		Case 1324
			$message[1] = 'ERROR_ILL_FORMED_PASSWORD'
			$message[2] = 'Unable to update the password. The value provided for the new password contains values that are not allowed in passwords.'

		Case 1325
			$message[1] = 'ERROR_PASSWORD_RESTRICTION'
			$message[2] = 'Unable to update the password. The value provided for the new password does not meet the length, complexity, or history requirements of the domain.'

		Case 1326
			$message[1] = 'ERROR_LOGON_FAILURE'
			$message[2] = 'Logon failure: unknown user name or bad password.'

		Case 1327
			$message[1] = 'ERROR_ACCOUNT_RESTRICTION'
			$message[2] = 'Logon failure: user account restriction. Possible reasons are blank passwords not allowed, logon hour restrictions, or a policy restriction has been enforced.'

		Case 1328
			$message[1] = 'ERROR_INVALID_LOGON_HOURS'
			$message[2] = 'Logon failure: account logon time restriction violation.'

		Case 1329
			$message[1] = 'ERROR_INVALID_WORKSTATION'
			$message[2] = 'Logon failure: user not allowed to log on to this computer.'

		Case 1330
			$message[1] = 'ERROR_PASSWORD_EXPIRED'
			$message[2] = 'Logon failure: the specified account password has expired.'

		Case 1331
			$message[1] = 'ERROR_ACCOUNT_DISABLED'
			$message[2] = 'Logon failure: account currently disabled.'

		Case 1332
			$message[1] = 'ERROR_NONE_MAPPED'
			$message[2] = 'No mapping between account names and security IDs was done.'

		Case 1333
			$message[1] = 'ERROR_TOO_MANY_LUIDS_REQUESTED'
			$message[2] = 'Too many local user identifiers (LUIDs) were requested at one time.'

		Case 1334
			$message[1] = 'ERROR_LUIDS_EXHAUSTED'
			$message[2] = 'No more local user identifiers (LUIDs) are available.'

		Case 1335
			$message[1] = 'ERROR_INVALID_SUB_AUTHORITY'
			$message[2] = 'The subauthority part of a security ID is invalid for this particular use.'

		Case 1336
			$message[1] = 'ERROR_INVALID_ACL'
			$message[2] = 'The access control list (ACL) structure is invalid.'

		Case 1337
			$message[1] = 'ERROR_INVALID_SID'
			$message[2] = 'The security ID structure is invalid.'

		Case 1338
			$message[1] = 'ERROR_INVALID_SECURITY_DESCR'
			$message[2] = 'The security descriptor structure is invalid.'

		Case 1340
			$message[1] = 'ERROR_BAD_INHERITANCE_ACL'
			$message[2] = 'The inherited access control list (ACL) or access control entry (ACE) could not be built.'

		Case 1341
			$message[1] = 'ERROR_SERVER_DISABLED'
			$message[2] = 'The server is currently disabled.'

		Case 1342
			$message[1] = 'ERROR_SERVER_NOT_DISABLED'
			$message[2] = 'The server is currently enabled.'

		Case 1343
			$message[1] = 'ERROR_INVALID_ID_AUTHORITY'
			$message[2] = 'The value provided was an invalid value for an identifier authority.'

		Case 1344
			$message[1] = 'ERROR_ALLOTTED_SPACE_EXCEEDED'
			$message[2] = 'No more memory is available for security information updates.'

		Case 1345
			$message[1] = 'ERROR_INVALID_GROUP_ATTRIBUTES'
			$message[2] = 'The specified attributes are invalid, or incompatible with the attributes for the group as a whole.'

		Case 1346
			$message[1] = 'ERROR_BAD_IMPERSONATION_LEVEL'
			$message[2] = 'Either a required impersonation level was not provided, or the provided impersonation level is invalid.'

		Case 1347
			$message[1] = 'ERROR_CANT_OPEN_ANONYMOUS'
			$message[2] = 'Cannot open an anonymous level security token.'

		Case 1348
			$message[1] = 'ERROR_BAD_VALIDATION_CLASS'
			$message[2] = 'The validation information class requested was invalid.'

		Case 1349
			$message[1] = 'ERROR_BAD_TOKEN_TYPE'
			$message[2] = 'The type of the token is inappropriate for its attempted use.'

		Case 1350
			$message[1] = 'ERROR_NO_SECURITY_ON_OBJECT'
			$message[2] = 'Unable to perform a security operation on an object that has no associated security.'

		Case 1351
			$message[1] = 'ERROR_CANT_ACCESS_DOMAIN_INFO'
			$message[2] = 'Configuration information could not be read from the domain controller, either because the machine is unavailable, or access has been denied.'

		Case 1352
			$message[1] = 'ERROR_INVALID_SERVER_STATE'
			$message[2] = 'The security account manager (SAM) or local security authority (LSA) server was in the wrong state to perform the security operation.'

		Case 1353
			$message[1] = 'ERROR_INVALID_DOMAIN_STATE'
			$message[2] = 'The domain was in the wrong state to perform the security operation.'

		Case 1354
			$message[1] = 'ERROR_INVALID_DOMAIN_ROLE'
			$message[2] = 'This operation is only allowed for the Primary Domain Controller of the domain.'

		Case 1355
			$message[1] = 'ERROR_NO_SUCH_DOMAIN'
			$message[2] = 'The specified domain either does not exist or could not be contacted.'

		Case 1356
			$message[1] = 'ERROR_DOMAIN_EXISTS'
			$message[2] = 'The specified domain already exists.'

		Case 1357
			$message[1] = 'ERROR_DOMAIN_LIMIT_EXCEEDED'
			$message[2] = 'An attempt was made to exceed the limit on the number of domains per server.'

		Case 1358
			$message[1] = 'ERROR_INTERNAL_DB_CORRUPTION'
			$message[2] = 'Unable to complete the requested operation because of either a catastrophic media failure or a data structure corruption on the disk.'

		Case 1359
			$message[1] = 'ERROR_INTERNAL_ERROR'
			$message[2] = 'An internal error occurred.'

		Case 1360
			$message[1] = 'ERROR_GENERIC_NOT_MAPPED'
			$message[2] = 'Generic access types were contained in an access mask which should already be mapped to nongeneric types.'

		Case 1361
			$message[1] = 'ERROR_BAD_DESCRIPTOR_FORMAT'
			$message[2] = 'A security descriptor is not in the right format (absolute or self-relative).'

		Case 1362
			$message[1] = 'ERROR_NOT_LOGON_PROCESS'
			$message[2] = 'The requested action is restricted for use by logon processes only. The calling process has not registered as a logon process.'

		Case 1363
			$message[1] = 'ERROR_LOGON_SESSION_EXISTS'
			$message[2] = 'Cannot start a new logon session with an ID that is already in use.'

		Case 1364
			$message[1] = 'ERROR_NO_SUCH_PACKAGE'
			$message[2] = 'A specified authentication package is unknown.'

		Case 1365
			$message[1] = 'ERROR_BAD_LOGON_SESSION_STATE'
			$message[2] = 'The logon session is not in a state that is consistent with the requested operation.'

		Case 1366
			$message[1] = 'ERROR_LOGON_SESSION_COLLISION'
			$message[2] = 'The logon session ID is already in use.'

		Case 1367
			$message[1] = 'ERROR_INVALID_LOGON_TYPE'
			$message[2] = 'A logon request contained an invalid logon type value.'

		Case 1368
			$message[1] = 'ERROR_CANNOT_IMPERSONATE'
			$message[2] = 'Unable to impersonate using a named pipe until data has been read from that pipe.'

		Case 1369
			$message[1] = 'ERROR_RXACT_INVALID_STATE'
			$message[2] = 'The transaction state of a registry subtree is incompatible with the requested operation.'

		Case 1370
			$message[1] = 'ERROR_RXACT_COMMIT_FAILURE'
			$message[2] = 'An internal security database corruption has been encountered.'

		Case 1371
			$message[1] = 'ERROR_SPECIAL_ACCOUNT'
			$message[2] = 'Cannot perform this operation on built-in accounts.'

		Case 1372
			$message[1] = 'ERROR_SPECIAL_GROUP'
			$message[2] = 'Cannot perform this operation on this built-in special group.'

		Case 1373
			$message[1] = 'ERROR_SPECIAL_USER'
			$message[2] = 'Cannot perform this operation on this built-in special user.'

		Case 1374
			$message[1] = 'ERROR_MEMBERS_PRIMARY_GROUP'
			$message[2] = 'The user cannot be removed from a group because the group is currently the user''s primary group.'

		Case 1375
			$message[1] = 'ERROR_TOKEN_ALREADY_IN_USE'
			$message[2] = 'The token is already in use as a primary token.'

		Case 1376
			$message[1] = 'ERROR_NO_SUCH_ALIAS'
			$message[2] = 'The specified local group does not exist.'

		Case 1377
			$message[1] = 'ERROR_MEMBER_NOT_IN_ALIAS'
			$message[2] = 'The specified account name is not a member of the group.'

		Case 1378
			$message[1] = 'ERROR_MEMBER_IN_ALIAS'
			$message[2] = 'The specified account name is already a member of the group.'

		Case 1379
			$message[1] = 'ERROR_ALIAS_EXISTS'
			$message[2] = 'The specified local group already exists.'

		Case 1380
			$message[1] = 'ERROR_LOGON_NOT_GRANTED'
			$message[2] = 'Logon failure: the user has not been granted the requested logon type at this computer.'

		Case 1381
			$message[1] = 'ERROR_TOO_MANY_SECRETS'
			$message[2] = 'The maximum number of secrets that may be stored in a single system has been exceeded.'

		Case 1382
			$message[1] = 'ERROR_SECRET_TOO_LONG'
			$message[2] = 'The length of a secret exceeds the maximum length allowed.'

		Case 1383
			$message[1] = 'ERROR_INTERNAL_DB_ERROR'
			$message[2] = 'The local security authority database contains an internal inconsistency.'

		Case 1384
			$message[1] = 'ERROR_TOO_MANY_CONTEXT_IDS'
			$message[2] = 'During a logon attempt, the user''s security context accumulated too many security IDs.'

		Case 1385
			$message[1] = 'ERROR_LOGON_TYPE_NOT_GRANTED'
			$message[2] = 'Logon failure: the user has not been granted the requested logon type at this computer.'

		Case 1386
			$message[1] = 'ERROR_NT_CROSS_ENCRYPTION_REQUIRED'
			$message[2] = 'A cross-encrypted password is necessary to change a user password.'

		Case 1387
			$message[1] = 'ERROR_NO_SUCH_MEMBER'
			$message[2] = 'A member could not be added to or removed from the local group because the member does not exist.'

		Case 1388
			$message[1] = 'ERROR_INVALID_MEMBER'
			$message[2] = 'A new member could not be added to a local group because the member has the wrong account type.'

		Case 1389
			$message[1] = 'ERROR_TOO_MANY_SIDS'
			$message[2] = 'Too many security IDs have been specified.'

		Case 1390
			$message[1] = 'ERROR_LM_CROSS_ENCRYPTION_REQUIRED'
			$message[2] = 'A cross-encrypted password is necessary to change this user password.'

		Case 1391
			$message[1] = 'ERROR_NO_INHERITANCE'
			$message[2] = 'Indicates an ACL contains no inheritable components.'

		Case 1392
			$message[1] = 'ERROR_FILE_CORRUPT'
			$message[2] = 'The file or directory is corrupted and unreadable.'

		Case 1393
			$message[1] = 'ERROR_DISK_CORRUPT'
			$message[2] = 'The disk structure is corrupted and unreadable.'

		Case 1394
			$message[1] = 'ERROR_NO_USER_SESSION_KEY'
			$message[2] = 'There is no user session key for the specified logon session.'

		Case 1395
			$message[1] = 'ERROR_LICENSE_QUOTA_EXCEEDED'
			$message[2] = 'The service being accessed is licensed for a particular number of connections. No more connections can be made to the service at this time because there are already as many connections as the service can accept.'

		Case 1396
			$message[1] = 'ERROR_WRONG_TARGET_NAME'
			$message[2] = 'Logon Failure: The target account name is incorrect.'

		Case 1397
			$message[1] = 'ERROR_MUTUAL_AUTH_FAILED'
			$message[2] = 'Mutual Authentication failed. The server''s password is out of date at the domain controller.'

		Case 1398
			$message[1] = 'ERROR_TIME_SKEW'
			$message[2] = 'There is a time and/or date difference between the client and server.'

		Case 1399
			$message[1] = 'ERROR_CURRENT_DOMAIN_NOT_ALLOWED'
			$message[2] = 'This operation cannot be performed on the current domain.'

		Case 1400
			$message[1] = 'ERROR_INVALID_WINDOW_HANDLE'
			$message[2] = 'Invalid window handle.'

		Case 1401
			$message[1] = 'ERROR_INVALID_MENU_HANDLE'
			$message[2] = 'Invalid menu handle.'

		Case 1402
			$message[1] = 'ERROR_INVALID_CURSOR_HANDLE'
			$message[2] = 'Invalid cursor handle.'

		Case 1403
			$message[1] = 'ERROR_INVALID_ACCEL_HANDLE'
			$message[2] = 'Invalid accelerator table handle.'

		Case 1404
			$message[1] = 'ERROR_INVALID_HOOK_HANDLE'
			$message[2] = 'Invalid hook handle.'

		Case 1405
			$message[1] = 'ERROR_INVALID_DWP_HANDLE'
			$message[2] = 'Invalid handle to a multiple-window position structure.'

		Case 1406
			$message[1] = 'ERROR_TLW_WITH_WSCHILD'
			$message[2] = 'Cannot create a top-level child window.'

		Case 1407
			$message[1] = 'ERROR_CANNOT_FIND_WND_CLASS'
			$message[2] = 'Cannot find window class.'

		Case 1408
			$message[1] = 'ERROR_WINDOW_OF_OTHER_THREAD'
			$message[2] = 'Invalid window; it belongs to other thread.'

		Case 1409
			$message[1] = 'ERROR_HOTKEY_ALREADY_REGISTERED'
			$message[2] = 'Hot key is already registered.'

		Case 1410
			$message[1] = 'ERROR_CLASS_ALREADY_EXISTS'
			$message[2] = 'Class already exists.'

		Case 1411
			$message[1] = 'ERROR_CLASS_DOES_NOT_EXIST'
			$message[2] = 'Class does not exist.'

		Case 1412
			$message[1] = 'ERROR_CLASS_HAS_WINDOWS'
			$message[2] = 'Class still has open windows.'

		Case 1413
			$message[1] = 'ERROR_INVALID_INDEX'
			$message[2] = 'Invalid index.'

		Case 1414
			$message[1] = 'ERROR_INVALID_ICON_HANDLE'
			$message[2] = 'Invalid icon handle.'

		Case 1415
			$message[1] = 'ERROR_PRIVATE_DIALOG_INDEX'
			$message[2] = 'Using private DIALOG window words.'

		Case 1416
			$message[1] = 'ERROR_LISTBOX_ID_NOT_FOUND'
			$message[2] = 'The list box identifier was not found.'

		Case 1417
			$message[1] = 'ERROR_NO_WILDCARD_CHARACTERS'
			$message[2] = 'No wildcards were found.'

		Case 1418
			$message[1] = 'ERROR_CLIPBOARD_NOT_OPEN'
			$message[2] = 'Thread does not have a clipboard open.'

		Case 1419
			$message[1] = 'ERROR_HOTKEY_NOT_REGISTERED'
			$message[2] = 'Hot key is not registered.'

		Case 1420
			$message[1] = 'ERROR_WINDOW_NOT_DIALOG'
			$message[2] = 'The window is not a valid dialog window.'

		Case 1421
			$message[1] = 'ERROR_CONTROL_ID_NOT_FOUND'
			$message[2] = 'Control ID not found.'

		Case 1422
			$message[1] = 'ERROR_INVALID_COMBOBOX_MESSAGE'
			$message[2] = 'Invalid message for a combo box because it does not have an edit control.'

		Case 1423
			$message[1] = 'ERROR_WINDOW_NOT_COMBOBOX'
			$message[2] = 'The window is not a combo box.'

		Case 1424
			$message[1] = 'ERROR_INVALID_EDIT_HEIGHT'
			$message[2] = 'Height must be less than 256.'

		Case 1425
			$message[1] = 'ERROR_DC_NOT_FOUND'
			$message[2] = 'Invalid device context (DC) handle.'

		Case 1426
			$message[1] = 'ERROR_INVALID_HOOK_FILTER'
			$message[2] = 'Invalid hook procedure type.'

		Case 1427
			$message[1] = 'ERROR_INVALID_FILTER_PROC'
			$message[2] = 'Invalid hook procedure.'

		Case 1428
			$message[1] = 'ERROR_HOOK_NEEDS_HMOD'
			$message[2] = 'Cannot set nonlocal hook without a module handle.'

		Case 1429
			$message[1] = 'ERROR_GLOBAL_ONLY_HOOK'
			$message[2] = 'This hook procedure can only be set globally.'

		Case 1430
			$message[1] = 'ERROR_JOURNAL_HOOK_SET'
			$message[2] = 'The journal hook procedure is already installed.'

		Case 1431
			$message[1] = 'ERROR_HOOK_NOT_INSTALLED'
			$message[2] = 'The hook procedure is not installed.'

		Case 1432
			$message[1] = 'ERROR_INVALID_LB_MESSAGE'
			$message[2] = 'Invalid message for single-selection list box.'

		Case 1433
			$message[1] = 'ERROR_SETCOUNT_ON_BAD_LB'
			$message[2] = 'LB_SETCOUNT sent to non-lazy list box.'

		Case 1434
			$message[1] = 'ERROR_LB_WITHOUT_TABSTOPS'
			$message[2] = 'This list box does not support tab stops.'

		Case 1435
			$message[1] = 'ERROR_DESTROY_OBJECT_OF_OTHER_THREAD'
			$message[2] = 'Cannot destroy object created by another thread.'

		Case 1436
			$message[1] = 'ERROR_CHILD_WINDOW_MENU'
			$message[2] = 'Child windows cannot have menus.'

		Case 1437
			$message[1] = 'ERROR_NO_SYSTEM_MENU'
			$message[2] = 'The window does not have a system menu.'

		Case 1438
			$message[1] = 'ERROR_INVALID_MSGBOX_STYLE'
			$message[2] = 'Invalid message box style.'

		Case 1439
			$message[1] = 'ERROR_INVALID_SPI_VALUE'
			$message[2] = 'Invalid system-wide (SPI_*) parameter.'

		Case 1440
			$message[1] = 'ERROR_SCREEN_ALREADY_LOCKED'
			$message[2] = 'Screen already locked.'

		Case 1441
			$message[1] = 'ERROR_HWNDS_HAVE_DIFF_PARENT'
			$message[2] = 'All handles to windows in a multiple-window position structure must have the same parent.'

		Case 1442
			$message[1] = 'ERROR_NOT_CHILD_WINDOW'
			$message[2] = 'The window is not a child window.'

		Case 1443
			$message[1] = 'ERROR_INVALID_GW_COMMAND'
			$message[2] = 'Invalid GW_* command.'

		Case 1444
			$message[1] = 'ERROR_INVALID_THREAD_ID'
			$message[2] = 'Invalid thread identifier.'

		Case 1445
			$message[1] = 'ERROR_NON_MDICHILD_WINDOW'
			$message[2] = 'Cannot process a message from a window that is not a multiple document interface (MDI) window.'

		Case 1446
			$message[1] = 'ERROR_POPUP_ALREADY_ACTIVE'
			$message[2] = 'Popup menu already active.'

		Case 1447
			$message[1] = 'ERROR_NO_SCROLLBARS'
			$message[2] = 'The window does not have scroll bars.'

		Case 1448
			$message[1] = 'ERROR_INVALID_SCROLLBAR_RANGE'
			$message[2] = 'Scroll bar range cannot be greater than MAXLONG.'

		Case 1449
			$message[1] = 'ERROR_INVALID_SHOWWIN_COMMAND'
			$message[2] = 'Cannot show or remove the window in the way specified.'

		Case 1450
			$message[1] = 'ERROR_NO_SYSTEM_RESOURCES'
			$message[2] = 'Insufficient system resources exist to complete the requested service.'

		Case 1451
			$message[1] = 'ERROR_NONPAGED_SYSTEM_RESOURCES'
			$message[2] = 'Insufficient system resources exist to complete the requested service.'

		Case 1452
			$message[1] = 'ERROR_PAGED_SYSTEM_RESOURCES'
			$message[2] = 'Insufficient system resources exist to complete the requested service.'

		Case 1453
			$message[1] = 'ERROR_WORKING_SET_QUOTA'
			$message[2] = 'Insufficient quota to complete the requested service.'

		Case 1454
			$message[1] = 'ERROR_PAGEFILE_QUOTA'
			$message[2] = 'Insufficient quota to complete the requested service.'

		Case 1455
			$message[1] = 'ERROR_COMMITMENT_LIMIT'
			$message[2] = 'The paging file is too small for this operation to complete.'

		Case 1456
			$message[1] = 'ERROR_MENU_ITEM_NOT_FOUND'
			$message[2] = 'A menu item was not found.'

		Case 1457
			$message[1] = 'ERROR_INVALID_KEYBOARD_HANDLE'
			$message[2] = 'Invalid keyboard layout handle.'

		Case 1458
			$message[1] = 'ERROR_HOOK_TYPE_NOT_ALLOWED'
			$message[2] = 'Hook type not allowed.'

		Case 1459
			$message[1] = 'ERROR_REQUIRES_INTERACTIVE_WINDOWSTATION'
			$message[2] = 'This operation requires an interactive window station.'

		Case 1460
			$message[1] = 'ERROR_TIMEOUT'
			$message[2] = 'This operation returned because the timeout period expired.'

		Case 1461
			$message[1] = 'ERROR_INVALID_MONITOR_HANDLE'
			$message[2] = 'Invalid monitor handle.'

		Case 1462
			$message[1] = 'ERROR_INCORRECT_SIZE'
			$message[2] = 'Incorrect size argument.'

		Case 1463
			$message[1] = 'ERROR_SYMLINK_CLASS_DISABLED'
			$message[2] = 'The symbolic link cannot be followed because its type is disabled.'

		Case 1464
			$message[1] = 'ERROR_SYMLINK_NOT_SUPPORTED'
			$message[2] = 'This application does not support the current operation on symbolic links.'

		Case 1465
			$message[1] = 'ERROR_XML_PARSE_ERROR'
			$message[2] = 'Windows was unable to parse the requested XML data.'

		Case 1466
			$message[1] = 'ERROR_XMLDSIG_ERROR'
			$message[2] = 'An error was encountered while processing an XML digital signature.'

		Case 1467
			$message[1] = 'ERROR_RESTART_APPLICATION'
			$message[2] = 'This application must be restarted.'

		Case 1468
			$message[1] = 'ERROR_WRONG_COMPARTMENT'
			$message[2] = 'The caller made the connection request in the wrong routing compartment.'

		Case 1469
			$message[1] = 'ERROR_AUTHIP_FAILURE'
			$message[2] = 'There was an AuthIP failure when attempting to connect to the remote host.'

		Case 1500
			$message[1] = 'ERROR_EVENTLOG_FILE_CORRUPT'
			$message[2] = 'The event log file is corrupted.'

		Case 1501
			$message[1] = 'ERROR_EVENTLOG_CANT_START'
			$message[2] = 'No event log file could be opened, so the event logging service did not start.'

		Case 1502
			$message[1] = 'ERROR_LOG_FILE_FULL'
			$message[2] = 'The event log file is full.'

		Case 1503
			$message[1] = 'ERROR_EVENTLOG_FILE_CHANGED'
			$message[2] = 'The event log file has changed between read operations.'

		Case 1550
			$message[1] = 'ERROR_INVALID_TASK_NAME'
			$message[2] = 'The specified task name is invalid.'

		Case 1551
			$message[1] = 'ERROR_INVALID_TASK_INDEX'
			$message[2] = 'The specified task index is invalid.'

		Case 1552
			$message[1] = 'ERROR_THREAD_ALREADY_IN_TASK'
			$message[2] = 'The specified thread is already joining a task.'

		Case 1601
			$message[1] = 'ERROR_INSTALL_SERVICE_FAILURE'
			$message[2] = 'The Windows Installer Service could not be accessed. This can occur if the Windows Installer is not correctly installed. Contact your support personnel for assistance.'

		Case 1602
			$message[1] = 'ERROR_INSTALL_USEREXIT'
			$message[2] = 'User canceled installation.'

		Case 1603
			$message[1] = 'ERROR_INSTALL_FAILURE'
			$message[2] = 'Fatal error during installation.'

		Case 1604
			$message[1] = 'ERROR_INSTALL_SUSPEND'
			$message[2] = 'Installation suspended, incomplete.'

		Case 1605
			$message[1] = 'ERROR_UNKNOWN_PRODUCT'
			$message[2] = 'This action is only valid for products that are currently installed.'

		Case 1606
			$message[1] = 'ERROR_UNKNOWN_FEATURE'
			$message[2] = 'Feature ID not registered.'

		Case 1607
			$message[1] = 'ERROR_UNKNOWN_COMPONENT'
			$message[2] = 'Component ID not registered.'

		Case 1608
			$message[1] = 'ERROR_UNKNOWN_PROPERTY'
			$message[2] = 'Unknown property.'

		Case 1609
			$message[1] = 'ERROR_INVALID_HANDLE_STATE'
			$message[2] = 'A handle is in an invalid state.'

		Case 1610
			$message[1] = 'ERROR_BAD_CONFIGURATION'
			$message[2] = 'The configuration data for this product is corrupt. Contact your support personnel.'

		Case 1611
			$message[1] = 'ERROR_INDEX_ABSENT'
			$message[2] = 'Component qualifier not present.'

		Case 1612
			$message[1] = 'ERROR_INSTALL_SOURCE_ABSENT'
			$message[2] = 'The installation source for this product is not available. Verify that the source exists and that you can access it.'

		Case 1613
			$message[1] = 'ERROR_INSTALL_PACKAGE_VERSION'
			$message[2] = 'This installation package cannot be installed by the Windows Installer service. You must install a Windows service pack that contains a newer version of the Windows Installer service.'

		Case 1614
			$message[1] = 'ERROR_PRODUCT_UNINSTALLED'
			$message[2] = 'Product is uninstalled.'

		Case 1615
			$message[1] = 'ERROR_BAD_QUERY_SYNTAX'
			$message[2] = 'SQL query syntax invalid or unsupported.'

		Case 1616
			$message[1] = 'ERROR_INVALID_FIELD'
			$message[2] = 'Record field does not exist.'

		Case 1617
			$message[1] = 'ERROR_DEVICE_REMOVED'
			$message[2] = 'The device has been removed.'

		Case 1618
			$message[1] = 'ERROR_INSTALL_ALREADY_RUNNING'
			$message[2] = 'Another installation is already in progress. Complete that installation before proceeding with this install.'

		Case 1619
			$message[1] = 'ERROR_INSTALL_PACKAGE_OPEN_FAILED'
			$message[2] = 'This installation package could not be opened. Verify that the package exists and that you can access it, or contact the application vendor to verify that this is a valid Windows Installer package.'

		Case 1620
			$message[1] = 'ERROR_INSTALL_PACKAGE_INVALID'
			$message[2] = 'This installation package could not be opened. Contact the application vendor to verify that this is a valid Windows Installer package.'

		Case 1621
			$message[1] = 'ERROR_INSTALL_UI_FAILURE'
			$message[2] = 'There was an error starting the Windows Installer service user interface. Contact your support personnel.'

		Case 1622
			$message[1] = 'ERROR_INSTALL_LOG_FAILURE'
			$message[2] = 'Error opening installation log file. Verify that the specified log file location exists and that you can write to it.'

		Case 1623
			$message[1] = 'ERROR_INSTALL_LANGUAGE_UNSUPPORTED'
			$message[2] = 'The language of this installation package is not supported by your system.'

		Case 1624
			$message[1] = 'ERROR_INSTALL_TRANSFORM_FAILURE'
			$message[2] = 'Error applying transforms. Verify that the specified transform paths are valid.'

		Case 1625
			$message[1] = 'ERROR_INSTALL_PACKAGE_REJECTED'
			$message[2] = 'This installation is forbidden by system policy. Contact your system administrator.'

		Case 1626
			$message[1] = 'ERROR_FUNCTION_NOT_CALLED'
			$message[2] = 'Function could not be executed.'

		Case 1627
			$message[1] = 'ERROR_FUNCTION_FAILED'
			$message[2] = 'Function failed during execution.'

		Case 1628
			$message[1] = 'ERROR_INVALID_TABLE'
			$message[2] = 'Invalid or unknown table specified.'

		Case 1629
			$message[1] = 'ERROR_DATATYPE_MISMATCH'
			$message[2] = 'Data supplied is of wrong type.'

		Case 1630
			$message[1] = 'ERROR_UNSUPPORTED_TYPE'
			$message[2] = 'Data of this type is not supported.'

		Case 1631
			$message[1] = 'ERROR_CREATE_FAILED'
			$message[2] = 'The Windows Installer service failed to start. Contact your support personnel.'

		Case 1632
			$message[1] = 'ERROR_INSTALL_TEMP_UNWRITABLE'
			$message[2] = 'The Temp folder is on a drive that is full or is inaccessible. Free up space on the drive or verify that you have write permission on the Temp folder.'

		Case 1633
			$message[1] = 'ERROR_INSTALL_PLATFORM_UNSUPPORTED'
			$message[2] = 'This installation package is not supported by this processor type. Contact your product vendor.'

		Case 1634
			$message[1] = 'ERROR_INSTALL_NOTUSED'
			$message[2] = 'Component not used on this computer.'

		Case 1635
			$message[1] = 'ERROR_PATCH_PACKAGE_OPEN_FAILED'
			$message[2] = 'This update package could not be opened. Verify that the update package exists and that you can access it, or contact the application vendor to verify that this is a valid Windows Installer update package.'

		Case 1636
			$message[1] = 'ERROR_PATCH_PACKAGE_INVALID'
			$message[2] = 'This update package could not be opened. Contact the application vendor to verify that this is a valid Windows Installer update package.'

		Case 1637
			$message[1] = 'ERROR_PATCH_PACKAGE_UNSUPPORTED'
			$message[2] = 'This update package cannot be processed by the Windows Installer service. You must install a Windows service pack that contains a newer version of the Windows Installer service.'

		Case 1638
			$message[1] = 'ERROR_PRODUCT_VERSION'
			$message[2] = 'Another version of this product is already installed. Installation of this version cannot continue. To configure or remove the existing version of this product, use Add/Remove Programs on the Control Panel.'

		Case 1639
			$message[1] = 'ERROR_INVALID_COMMAND_LINE'
			$message[2] = 'Invalid command line argument. Consult the Windows Installer SDK for detailed command line help.'

		Case 1640
			$message[1] = 'ERROR_INSTALL_REMOTE_DISALLOWED'
			$message[2] = 'Only administrators have permission to add, remove, or configure server software during a Terminal services remote session. If you want to install or configure software on the server, contact your network administrator.'

		Case 1641
			$message[1] = 'ERROR_SUCCESS_REBOOT_INITIATED'
			$message[2] = 'The requested operation completed successfully. The system will be restarted so the changes can take effect.'

		Case 1642
			$message[1] = 'ERROR_PATCH_TARGET_NOT_FOUND'
			$message[2] = 'The upgrade cannot be installed by the Windows Installer service because the program to be upgraded may be missing, or the upgrade may update a different version of the program. Verify that the program to be upgraded exists on your computer and that you have the correct upgrade.'

		Case 1643
			$message[1] = 'ERROR_PATCH_PACKAGE_REJECTED'
			$message[2] = 'The update package is not permitted by software restriction policy.'

		Case 1644
			$message[1] = 'ERROR_INSTALL_TRANSFORM_REJECTED'
			$message[2] = 'One or more customizations are not permitted by software restriction policy.'

		Case 1645
			$message[1] = 'ERROR_INSTALL_REMOTE_PROHIBITED'
			$message[2] = 'The Windows Installer does not permit installation from a Remote Desktop Connection.'

		Case 1646
			$message[1] = 'ERROR_PATCH_REMOVAL_UNSUPPORTED'
			$message[2] = 'Uninstallation of the update package is not supported.'

		Case 1647
			$message[1] = 'ERROR_UNKNOWN_PATCH'
			$message[2] = 'The update is not applied to this product.'

		Case 1648
			$message[1] = 'ERROR_PATCH_NO_SEQUENCE'
			$message[2] = 'No valid sequence could be found for the set of updates.'

		Case 1649
			$message[1] = 'ERROR_PATCH_REMOVAL_DISALLOWED'
			$message[2] = 'Update removal was disallowed by policy.'

		Case 1650
			$message[1] = 'ERROR_INVALID_PATCH_XML'
			$message[2] = 'The XML update data is invalid.'

		Case 1651
			$message[1] = 'ERROR_PATCH_MANAGED_ADVERTISED_PRODUCT'
			$message[2] = 'Windows Installer does not permit updating of managed advertised products. At least one feature of the product must be installed before applying the update.'

		Case 1652
			$message[1] = 'ERROR_INSTALL_SERVICE_SAFEBOOT'
			$message[2] = 'The Windows Installer service is not accessible in Safe Mode. Please try again when your computer is not in Safe Mode or you can use System Restore to return your machine to a previous good state.'

		Case 1700
			$message[1] = 'RPC_S_INVALID_STRING_BINDING'
			$message[2] = 'The string binding is invalid.'

		Case 1701
			$message[1] = 'RPC_S_WRONG_KIND_OF_BINDING'
			$message[2] = 'The binding handle is not the correct type.'

		Case 1702
			$message[1] = 'RPC_S_INVALID_BINDING'
			$message[2] = 'The binding handle is invalid.'

		Case 1703
			$message[1] = 'RPC_S_PROTSEQ_NOT_SUPPORTED'
			$message[2] = 'The RPC protocol sequence is not supported.'

		Case 1704
			$message[1] = 'RPC_S_INVALID_RPC_PROTSEQ'
			$message[2] = 'The RPC protocol sequence is invalid.'

		Case 1705
			$message[1] = 'RPC_S_INVALID_STRING_UUID'
			$message[2] = 'The string universal unique identifier (UUID) is invalid.'

		Case 1706
			$message[1] = 'RPC_S_INVALID_ENDPOINT_FORMAT'
			$message[2] = 'The endpoint format is invalid.'

		Case 1707
			$message[1] = 'RPC_S_INVALID_NET_ADDR'
			$message[2] = 'The network address is invalid.'

		Case 1708
			$message[1] = 'RPC_S_NO_ENDPOINT_FOUND'
			$message[2] = 'No endpoint was found.'

		Case 1709
			$message[1] = 'RPC_S_INVALID_TIMEOUT'
			$message[2] = 'The timeout value is invalid.'

		Case 1710
			$message[1] = 'RPC_S_OBJECT_NOT_FOUND'
			$message[2] = 'The object universal unique identifier (UUID) was not found.'

		Case 1711
			$message[1] = 'RPC_S_ALREADY_REGISTERED'
			$message[2] = 'The object universal unique identifier (UUID) has already been registered.'

		Case 1712
			$message[1] = 'RPC_S_TYPE_ALREADY_REGISTERED'
			$message[2] = 'The type universal unique identifier (UUID) has already been registered.'

		Case 1713
			$message[1] = 'RPC_S_ALREADY_LISTENING'
			$message[2] = 'The RPC server is already listening.'

		Case 1714
			$message[1] = 'RPC_S_NO_PROTSEQS_REGISTERED'
			$message[2] = 'No protocol sequences have been registered.'

		Case 1715
			$message[1] = 'RPC_S_NOT_LISTENING'
			$message[2] = 'The RPC server is not listening.'

		Case 1716
			$message[1] = 'RPC_S_UNKNOWN_MGR_TYPE'
			$message[2] = 'The manager type is unknown.'

		Case 1717
			$message[1] = 'RPC_S_UNKNOWN_IF'
			$message[2] = 'The interface is unknown.'

		Case 1718
			$message[1] = 'RPC_S_NO_BINDINGS'
			$message[2] = 'There are no bindings.'

		Case 1719
			$message[1] = 'RPC_S_NO_PROTSEQS'
			$message[2] = 'There are no protocol sequences.'

		Case 1720
			$message[1] = 'RPC_S_CANT_CREATE_ENDPOINT'
			$message[2] = 'The endpoint cannot be created.'

		Case 1721
			$message[1] = 'RPC_S_OUT_OF_RESOURCES'
			$message[2] = 'Not enough resources are available to complete this operation.'

		Case 1722
			$message[1] = 'RPC_S_SERVER_UNAVAILABLE'
			$message[2] = 'The RPC server is unavailable.'

		Case 1723
			$message[1] = 'RPC_S_SERVER_TOO_BUSY'
			$message[2] = 'The RPC server is too busy to complete this operation.'

		Case 1724
			$message[1] = 'RPC_S_INVALID_NETWORK_OPTIONS'
			$message[2] = 'The network options are invalid.'

		Case 1725
			$message[1] = 'RPC_S_NO_CALL_ACTIVE'
			$message[2] = 'There are no remote procedure calls active on this thread.'

		Case 1726
			$message[1] = 'RPC_S_CALL_FAILED'
			$message[2] = 'The remote procedure call failed.'

		Case 1727
			$message[1] = 'RPC_S_CALL_FAILED_DNE'
			$message[2] = 'The remote procedure call failed and did not execute.'

		Case 1728
			$message[1] = 'RPC_S_PROTOCOL_ERROR'
			$message[2] = 'A remote procedure call (RPC) protocol error occurred.'

		Case 1729
			$message[1] = 'RPC_S_PROXY_ACCESS_DENIED'
			$message[2] = 'Access to the HTTP proxy is denied.'

		Case 1730
			$message[1] = 'RPC_S_UNSUPPORTED_TRANS_SYN'
			$message[2] = 'The transfer syntax is not supported by the RPC server.'

		Case 1732
			$message[1] = 'RPC_S_UNSUPPORTED_TYPE'
			$message[2] = 'The universal unique identifier (UUID) type is not supported.'

		Case 1733
			$message[1] = 'RPC_S_INVALID_TAG'
			$message[2] = 'The tag is invalid.'

		Case 1734
			$message[1] = 'RPC_S_INVALID_BOUND'
			$message[2] = 'The array bounds are invalid.'

		Case 1735
			$message[1] = 'RPC_S_NO_ENTRY_NAME'
			$message[2] = 'The binding does not contain an entry name.'

		Case 1736
			$message[1] = 'RPC_S_INVALID_NAME_SYNTAX'
			$message[2] = 'The name syntax is invalid.'

		Case 1737
			$message[1] = 'RPC_S_UNSUPPORTED_NAME_SYNTAX'
			$message[2] = 'The name syntax is not supported.'

		Case 1739
			$message[1] = 'RPC_S_UUID_NO_ADDRESS'
			$message[2] = 'No network address is available to use to construct a universal unique identifier (UUID).'

		Case 1740
			$message[1] = 'RPC_S_DUPLICATE_ENDPOINT'
			$message[2] = 'The endpoint is a duplicate.'

		Case 1741
			$message[1] = 'RPC_S_UNKNOWN_AUTHN_TYPE'
			$message[2] = 'The authentication type is unknown.'

		Case 1742
			$message[1] = 'RPC_S_MAX_CALLS_TOO_SMALL'
			$message[2] = 'The maximum number of calls is too small.'

		Case 1743
			$message[1] = 'RPC_S_STRING_TOO_LONG'
			$message[2] = 'The string is too long.'

		Case 1744
			$message[1] = 'RPC_S_PROTSEQ_NOT_FOUND'
			$message[2] = 'The RPC protocol sequence was not found.'

		Case 1745
			$message[1] = 'RPC_S_PROCNUM_OUT_OF_RANGE'
			$message[2] = 'The procedure number is out of range.'

		Case 1746
			$message[1] = 'RPC_S_BINDING_HAS_NO_AUTH'
			$message[2] = 'The binding does not contain any authentication information.'

		Case 1747
			$message[1] = 'RPC_S_UNKNOWN_AUTHN_SERVICE'
			$message[2] = 'The authentication service is unknown.'

		Case 1748
			$message[1] = 'RPC_S_UNKNOWN_AUTHN_LEVEL'
			$message[2] = 'The authentication level is unknown.'

		Case 1749
			$message[1] = 'RPC_S_INVALID_AUTH_IDENTITY'
			$message[2] = 'The security context is invalid.'

		Case 1750
			$message[1] = 'RPC_S_UNKNOWN_AUTHZ_SERVICE'
			$message[2] = 'The authorization service is unknown.'

		Case 1751
			$message[1] = 'EPT_S_INVALID_ENTRY'
			$message[2] = 'The entry is invalid.'

		Case 1752
			$message[1] = 'EPT_S_CANT_PERFORM_OP'
			$message[2] = 'The server endpoint cannot perform the operation.'

		Case 1753
			$message[1] = 'EPT_S_NOT_REGISTERED'
			$message[2] = 'There are no more endpoints available from the endpoint mapper.'

		Case 1754
			$message[1] = 'RPC_S_NOTHING_TO_EXPORT'
			$message[2] = 'No interfaces have been exported.'

		Case 1755
			$message[1] = 'RPC_S_INCOMPLETE_NAME'
			$message[2] = 'The entry name is incomplete.'

		Case 1756
			$message[1] = 'RPC_S_INVALID_VERS_OPTION'
			$message[2] = 'The version option is invalid.'

		Case 1757
			$message[1] = 'RPC_S_NO_MORE_MEMBERS'
			$message[2] = 'There are no more members.'

		Case 1758
			$message[1] = 'RPC_S_NOT_ALL_OBJS_UNEXPORTED'
			$message[2] = 'There is nothing to unexport.'

		Case 1759
			$message[1] = 'RPC_S_INTERFACE_NOT_FOUND'
			$message[2] = 'The interface was not found.'

		Case 1760
			$message[1] = 'RPC_S_ENTRY_ALREADY_EXISTS'
			$message[2] = 'The entry already exists.'

		Case 1761
			$message[1] = 'RPC_S_ENTRY_NOT_FOUND'
			$message[2] = 'The entry is not found.'

		Case 1762
			$message[1] = 'RPC_S_NAME_SERVICE_UNAVAILABLE'
			$message[2] = 'The name service is unavailable.'

		Case 1763
			$message[1] = 'RPC_S_INVALID_NAF_ID'
			$message[2] = 'The network address family is invalid.'

		Case 1764
			$message[1] = 'RPC_S_CANNOT_SUPPORT'
			$message[2] = 'The requested operation is not supported.'

		Case 1765
			$message[1] = 'RPC_S_NO_CONTEXT_AVAILABLE'
			$message[2] = 'No security context is available to allow impersonation.'

		Case 1766
			$message[1] = 'RPC_S_INTERNAL_ERROR'
			$message[2] = 'An internal error occurred in a remote procedure call (RPC).'

		Case 1767
			$message[1] = 'RPC_S_ZERO_DIVIDE'
			$message[2] = 'The RPC server attempted an integer division by zero.'

		Case 1768
			$message[1] = 'RPC_S_ADDRESS_ERROR'
			$message[2] = 'An addressing error occurred in the RPC server.'

		Case 1769
			$message[1] = 'RPC_S_FP_DIV_ZERO'
			$message[2] = 'A floating-point operation at the RPC server caused a division by zero.'

		Case 1770
			$message[1] = 'RPC_S_FP_UNDERFLOW'
			$message[2] = 'A floating-point underflow occurred at the RPC server.'

		Case 1771
			$message[1] = 'RPC_S_FP_OVERFLOW'
			$message[2] = 'A floating-point overflow occurred at the RPC server.'

		Case 1772
			$message[1] = 'RPC_X_NO_MORE_ENTRIES'
			$message[2] = 'The list of RPC servers available for the binding of auto handles has been exhausted.'

		Case 1773
			$message[1] = 'RPC_X_SS_CHAR_TRANS_OPEN_FAIL'
			$message[2] = 'Unable to open the character translation table file.'

		Case 1774
			$message[1] = 'RPC_X_SS_CHAR_TRANS_SHORT_FILE'
			$message[2] = 'The file containing the character translation table has fewer than 512 bytes.'

		Case 1775
			$message[1] = 'RPC_X_SS_IN_NULL_CONTEXT'
			$message[2] = 'A null context handle was passed from the client to the host during a remote procedure call.'

		Case 1777
			$message[1] = 'RPC_X_SS_CONTEXT_DAMAGED'
			$message[2] = 'The context handle changed during a remote procedure call.'

		Case 1778
			$message[1] = 'RPC_X_SS_HANDLES_MISMATCH'
			$message[2] = 'The binding handles passed to a remote procedure call do not match.'

		Case 1779
			$message[1] = 'RPC_X_SS_CANNOT_GET_CALL_HANDLE'
			$message[2] = 'The stub is unable to get the remote procedure call handle.'

		Case 1780
			$message[1] = 'RPC_X_NULL_REF_POINTER'
			$message[2] = 'A null reference pointer was passed to the stub.'

		Case 1781
			$message[1] = 'RPC_X_ENUM_VALUE_OUT_OF_RANGE'
			$message[2] = 'The enumeration value is out of range.'

		Case 1782
			$message[1] = 'RPC_X_BYTE_COUNT_TOO_SMALL'
			$message[2] = 'The byte count is too small.'

		Case 1783
			$message[1] = 'RPC_X_BAD_STUB_DATA'
			$message[2] = 'The stub received bad data.'

		Case 1784
			$message[1] = 'ERROR_INVALID_USER_BUFFER'
			$message[2] = 'The supplied user buffer is not valid for the requested operation.'

		Case 1785
			$message[1] = 'ERROR_UNRECOGNIZED_MEDIA'
			$message[2] = 'The disk media is not recognized. It may not be formatted.'

		Case 1786
			$message[1] = 'ERROR_NO_TRUST_LSA_SECRET'
			$message[2] = 'The workstation does not have a trust secret.'

		Case 1787
			$message[1] = 'ERROR_NO_TRUST_SAM_ACCOUNT'
			$message[2] = 'The security database on the server does not have a computer account for this workstation trust relationship.'

		Case 1788
			$message[1] = 'ERROR_TRUSTED_DOMAIN_FAILURE'
			$message[2] = 'The trust relationship between the primary domain and the trusted domain failed.'

		Case 1789
			$message[1] = 'ERROR_TRUSTED_RELATIONSHIP_FAILURE'
			$message[2] = 'The trust relationship between this workstation and the primary domain failed.'

		Case 1790
			$message[1] = 'ERROR_TRUST_FAILURE'
			$message[2] = 'The network logon failed.'

		Case 1791
			$message[1] = 'RPC_S_CALL_IN_PROGRESS'
			$message[2] = 'A remote procedure call is already in progress for this thread.'

		Case 1792
			$message[1] = 'ERROR_NETLOGON_NOT_STARTED'
			$message[2] = 'An attempt was made to logon, but the network logon service was not started.'

		Case 1793
			$message[1] = 'ERROR_ACCOUNT_EXPIRED'
			$message[2] = 'The user''s account has expired.'

		Case 1794
			$message[1] = 'ERROR_REDIRECTOR_HAS_OPEN_HANDLES'
			$message[2] = 'The redirector is in use and cannot be unloaded.'

		Case 1795
			$message[1] = 'ERROR_PRINTER_DRIVER_ALREADY_INSTALLED'
			$message[2] = 'The specified printer driver is already installed.'

		Case 1796
			$message[1] = 'ERROR_UNKNOWN_PORT'
			$message[2] = 'The specified port is unknown.'

		Case 1797
			$message[1] = 'ERROR_UNKNOWN_PRINTER_DRIVER'
			$message[2] = 'The printer driver is unknown.'

		Case 1798
			$message[1] = 'ERROR_UNKNOWN_PRINTPROCESSOR'
			$message[2] = 'The print processor is unknown.'

		Case 1799
			$message[1] = 'ERROR_INVALID_SEPARATOR_FILE'
			$message[2] = 'The specified separator file is invalid.'

		Case 1800
			$message[1] = 'ERROR_INVALID_PRIORITY'
			$message[2] = 'The specified priority is invalid.'

		Case 1801
			$message[1] = 'ERROR_INVALID_PRINTER_NAME'
			$message[2] = 'The printer name is invalid.'

		Case 1802
			$message[1] = 'ERROR_PRINTER_ALREADY_EXISTS'
			$message[2] = 'The printer already exists.'

		Case 1803
			$message[1] = 'ERROR_INVALID_PRINTER_COMMAND'
			$message[2] = 'The printer command is invalid.'

		Case 1804
			$message[1] = 'ERROR_INVALID_DATATYPE'
			$message[2] = 'The specified datatype is invalid.'

		Case 1805
			$message[1] = 'ERROR_INVALID_ENVIRONMENT'
			$message[2] = 'The environment specified is invalid.'

		Case 1806
			$message[1] = 'RPC_S_NO_MORE_BINDINGS'
			$message[2] = 'There are no more bindings.'

		Case 1807
			$message[1] = 'ERROR_NOLOGON_INTERDOMAIN_TRUST_ACCOUNT'
			$message[2] = 'The account used is an interdomain trust account. Use your global user account or local user account to access this server.'

		Case 1808
			$message[1] = 'ERROR_NOLOGON_WORKSTATION_TRUST_ACCOUNT'
			$message[2] = 'The account used is a computer account. Use your global user account or local user account to access this server.'

		Case 1809
			$message[1] = 'ERROR_NOLOGON_SERVER_TRUST_ACCOUNT'
			$message[2] = 'The account used is a server trust account. Use your global user account or local user account to access this server.'

		Case 1810
			$message[1] = 'ERROR_DOMAIN_TRUST_INCONSISTENT'
			$message[2] = 'The name or security ID (SID) of the domain specified is inconsistent with the trust information for that domain.'

		Case 1811
			$message[1] = 'ERROR_SERVER_HAS_OPEN_HANDLES'
			$message[2] = 'The server is in use and cannot be unloaded.'

		Case 1812
			$message[1] = 'ERROR_RESOURCE_DATA_NOT_FOUND'
			$message[2] = 'The specified image file did not contain a resource section.'

		Case 1813
			$message[1] = 'ERROR_RESOURCE_TYPE_NOT_FOUND'
			$message[2] = 'The specified resource type cannot be found in the image file.'

		Case 1814
			$message[1] = 'ERROR_RESOURCE_NAME_NOT_FOUND'
			$message[2] = 'The specified resource name cannot be found in the image file.'

		Case 1815
			$message[1] = 'ERROR_RESOURCE_LANG_NOT_FOUND'
			$message[2] = 'The specified resource language ID cannot be found in the image file.'

		Case 1816
			$message[1] = 'ERROR_NOT_ENOUGH_QUOTA'
			$message[2] = 'Not enough quota is available to process this command.'

		Case 1817
			$message[1] = 'RPC_S_NO_INTERFACES'
			$message[2] = 'No interfaces have been registered.'

		Case 1818
			$message[1] = 'RPC_S_CALL_CANCELLED'
			$message[2] = 'The remote procedure call was canceled.'

		Case 1819
			$message[1] = 'RPC_S_BINDING_INCOMPLETE'
			$message[2] = 'The binding handle does not contain all required information.'

		Case 1820
			$message[1] = 'RPC_S_COMM_FAILURE'
			$message[2] = 'A communications failure occurred during a remote procedure call.'

		Case 1821
			$message[1] = 'RPC_S_UNSUPPORTED_AUTHN_LEVEL'
			$message[2] = 'The requested authentication level is not supported.'

		Case 1822
			$message[1] = 'RPC_S_NO_PRINC_NAME'
			$message[2] = 'No principal name registered.'

		Case 1823
			$message[1] = 'RPC_S_NOT_RPC_ERROR'
			$message[2] = 'The error specified is not a valid Windows RPC error code.'

		Case 1824
			$message[1] = 'RPC_S_UUID_LOCAL_ONLY'
			$message[2] = 'A UUID that is valid only on this computer has been allocated.'

		Case 1825
			$message[1] = 'RPC_S_SEC_PKG_ERROR'
			$message[2] = 'A security package specific error occurred.'

		Case 1826
			$message[1] = 'RPC_S_NOT_CANCELLED'
			$message[2] = 'Thread is not canceled.'

		Case 1827
			$message[1] = 'RPC_X_INVALID_ES_ACTION'
			$message[2] = 'Invalid operation on the encoding/decoding handle.'

		Case 1828
			$message[1] = 'RPC_X_WRONG_ES_VERSION'
			$message[2] = 'Incompatible version of the serializing package.'

		Case 1829
			$message[1] = 'RPC_X_WRONG_STUB_VERSION'
			$message[2] = 'Incompatible version of the RPC stub.'

		Case 1830
			$message[1] = 'RPC_X_INVALID_PIPE_OBJECT'
			$message[2] = 'The RPC pipe object is invalid or corrupted.'

		Case 1831
			$message[1] = 'RPC_X_WRONG_PIPE_ORDER'
			$message[2] = 'An invalid operation was attempted on an RPC pipe object.'

		Case 1832
			$message[1] = 'RPC_X_WRONG_PIPE_VERSION'
			$message[2] = 'Unsupported RPC pipe version.'

		Case 1833
			$message[1] = 'RPC_S_COOKIE_AUTH_FAILED'
			$message[2] = 'HTTP proxy server rejected the connection because the cookie authentication failed.'

		Case 1898
			$message[1] = 'RPC_S_GROUP_MEMBER_NOT_FOUND'
			$message[2] = 'The group member was not found.'

		Case 1899
			$message[1] = 'EPT_S_CANT_CREATE'
			$message[2] = 'The endpoint mapper database entry could not be created.'

		Case 1900
			$message[1] = 'RPC_S_INVALID_OBJECT'
			$message[2] = 'The object universal unique identifier (UUID) is the nil UUID.'

		Case 1901
			$message[1] = 'ERROR_INVALID_TIME'
			$message[2] = 'The specified time is invalid.'

		Case 1902
			$message[1] = 'ERROR_INVALID_FORM_NAME'
			$message[2] = 'The specified form name is invalid.'

		Case 1903
			$message[1] = 'ERROR_INVALID_FORM_SIZE'
			$message[2] = 'The specified form size is invalid.'

		Case 1904
			$message[1] = 'ERROR_ALREADY_WAITING'
			$message[2] = 'The specified printer handle is already being waited on'

		Case 1905
			$message[1] = 'ERROR_PRINTER_DELETED'
			$message[2] = 'The specified printer has been deleted.'

		Case 1906
			$message[1] = 'ERROR_INVALID_PRINTER_STATE'
			$message[2] = 'The state of the printer is invalid.'

		Case 1907
			$message[1] = 'ERROR_PASSWORD_MUST_CHANGE'
			$message[2] = 'The user''s password must be changed before logging on the first time.'

		Case 1908
			$message[1] = 'ERROR_DOMAIN_CONTROLLER_NOT_FOUND'
			$message[2] = 'Could not find the domain controller for this domain.'

		Case 1909
			$message[1] = 'ERROR_ACCOUNT_LOCKED_OUT'
			$message[2] = 'The referenced account is currently locked out and may not be logged on to.'

		Case 1910
			$message[1] = 'OR_INVALID_OXID'
			$message[2] = 'The object exporter specified was not found.'

		Case 1911
			$message[1] = 'OR_INVALID_OID'
			$message[2] = 'The object specified was not found.'

		Case 1912
			$message[1] = 'OR_INVALID_SET'
			$message[2] = 'The object resolver set specified was not found.'

		Case 1913
			$message[1] = 'RPC_S_SEND_INCOMPLETE'
			$message[2] = 'Some data remains to be sent in the request buffer.'

		Case 1914
			$message[1] = 'RPC_S_INVALID_ASYNC_HANDLE'
			$message[2] = 'Invalid asynchronous remote procedure call handle.'

		Case 1915
			$message[1] = 'RPC_S_INVALID_ASYNC_CALL'
			$message[2] = 'Invalid asynchronous RPC call handle for this operation.'

		Case 1916
			$message[1] = 'RPC_X_PIPE_CLOSED'
			$message[2] = 'The RPC pipe object has already been closed.'

		Case 1917
			$message[1] = 'RPC_X_PIPE_DISCIPLINE_ERROR'
			$message[2] = 'The RPC call completed before all pipes were processed.'

		Case 1918
			$message[1] = 'RPC_X_PIPE_EMPTY'
			$message[2] = 'No more data is available from the RPC pipe.'

		Case 1919
			$message[1] = 'ERROR_NO_SITENAME'
			$message[2] = 'No site name is available for this machine.'

		Case 1920
			$message[1] = 'ERROR_CANT_ACCESS_FILE'
			$message[2] = 'The file cannot be accessed by the system.'

		Case 1921
			$message[1] = 'ERROR_CANT_RESOLVE_FILENAME'
			$message[2] = 'The name of the file cannot be resolved by the system.'

		Case 1922
			$message[1] = 'RPC_S_ENTRY_TYPE_MISMATCH'
			$message[2] = 'The entry is not of the expected type.'

		Case 1923
			$message[1] = 'RPC_S_NOT_ALL_OBJS_EXPORTED'
			$message[2] = 'Not all object UUIDs could be exported to the specified entry.'

		Case 1924
			$message[1] = 'RPC_S_INTERFACE_NOT_EXPORTED'
			$message[2] = 'Interface could not be exported to the specified entry.'

		Case 1925
			$message[1] = 'RPC_S_PROFILE_NOT_ADDED'
			$message[2] = 'The specified profile entry could not be added.'

		Case 1926
			$message[1] = 'RPC_S_PRF_ELT_NOT_ADDED'
			$message[2] = 'The specified profile element could not be added.'

		Case 1927
			$message[1] = 'RPC_S_PRF_ELT_NOT_REMOVED'
			$message[2] = 'The specified profile element could not be removed.'

		Case 1928
			$message[1] = 'RPC_S_GRP_ELT_NOT_ADDED'
			$message[2] = 'The group element could not be added.'

		Case 1929
			$message[1] = 'RPC_S_GRP_ELT_NOT_REMOVED'
			$message[2] = 'The group element could not be removed.'

		Case 1930
			$message[1] = 'ERROR_KM_DRIVER_BLOCKED'
			$message[2] = 'The printer driver is not compatible with a policy enabled on your computer that blocks NT 4.0 drivers.'

		Case 1931
			$message[1] = 'ERROR_CONTEXT_EXPIRED'
			$message[2] = 'The context has expired and can no longer be used.'

		Case 1932
			$message[1] = 'ERROR_PER_USER_TRUST_QUOTA_EXCEEDED'
			$message[2] = 'The current user''s delegated trust creation quota has been exceeded.'

		Case 1933
			$message[1] = 'ERROR_ALL_USER_TRUST_QUOTA_EXCEEDED'
			$message[2] = 'The total delegated trust creation quota has been exceeded.'

		Case 1934
			$message[1] = 'ERROR_USER_DELETE_TRUST_QUOTA_EXCEEDED'
			$message[2] = 'The current user''s delegated trust deletion quota has been exceeded.'

		Case 1935
			$message[1] = 'ERROR_AUTHENTICATION_FIREWALL_FAILED'
			$message[2] = 'Logon Failure: The machine you are logging onto is protected by an authentication firewall. The specified account is not allowed to authenticate to the machine.'

		Case 1936
			$message[1] = 'ERROR_REMOTE_PRINT_CONNECTIONS_BLOCKED'
			$message[2] = 'Remote connections to the Print Spooler are blocked by a policy set on your machine.'

		Case 1937
			$message[1] = 'ERROR_NTLM_BLOCKED'
			$message[2] = 'Authentication failed because NTLM authentication has been disabled.'

		Case 2000
			$message[1] = 'ERROR_INVALID_PIXEL_FORMAT'
			$message[2] = 'The pixel format is invalid.'

		Case 2001
			$message[1] = 'ERROR_BAD_DRIVER'
			$message[2] = 'The specified driver is invalid.'

		Case 2002
			$message[1] = 'ERROR_INVALID_WINDOW_STYLE'
			$message[2] = 'The window style or class attribute is invalid for this operation.'

		Case 2003
			$message[1] = 'ERROR_METAFILE_NOT_SUPPORTED'
			$message[2] = 'The requested metafile operation is not supported.'

		Case 2004
			$message[1] = 'ERROR_TRANSFORM_NOT_SUPPORTED'
			$message[2] = 'The requested transformation operation is not supported.'

		Case 2005
			$message[1] = 'ERROR_CLIPPING_NOT_SUPPORTED'
			$message[2] = 'The requested clipping operation is not supported.'

		Case 2010
			$message[1] = 'ERROR_INVALID_CMM'
			$message[2] = 'The specified color management module is invalid.'

		Case 2011
			$message[1] = 'ERROR_INVALID_PROFILE'
			$message[2] = 'The specified color profile is invalid.'

		Case 2012
			$message[1] = 'ERROR_TAG_NOT_FOUND'
			$message[2] = 'The specified tag was not found.'

		Case 2013
			$message[1] = 'ERROR_TAG_NOT_PRESENT'
			$message[2] = 'A required tag is not present.'

		Case 2014
			$message[1] = 'ERROR_DUPLICATE_TAG'
			$message[2] = 'The specified tag is already present.'

		Case 2015
			$message[1] = 'ERROR_PROFILE_NOT_ASSOCIATED_WITH_DEVICE'
			$message[2] = 'The specified color profile is not associated with the specified device.'

		Case 2016
			$message[1] = 'ERROR_PROFILE_NOT_FOUND'
			$message[2] = 'The specified color profile was not found.'

		Case 2017
			$message[1] = 'ERROR_INVALID_COLORSPACE'
			$message[2] = 'The specified color space is invalid.'

		Case 2018
			$message[1] = 'ERROR_ICM_NOT_ENABLED'
			$message[2] = 'Image Color Management is not enabled.'

		Case 2019
			$message[1] = 'ERROR_DELETING_ICM_XFORM'
			$message[2] = 'There was an error while deleting the color transform.'

		Case 2020
			$message[1] = 'ERROR_INVALID_TRANSFORM'
			$message[2] = 'The specified color transform is invalid.'

		Case 2021
			$message[1] = 'ERROR_COLORSPACE_MISMATCH'
			$message[2] = 'The specified transform does not match the bitmap''s color space.'

		Case 2022
			$message[1] = 'ERROR_INVALID_COLORINDEX'
			$message[2] = 'The specified named color index is not present in the profile.'

		Case 2023
			$message[1] = 'ERROR_PROFILE_DOES_NOT_MATCH_DEVICE'
			$message[2] = 'The specified profile is intended for a device of a different type than the specified device.'

		Case 2108
			$message[1] = 'ERROR_CONNECTED_OTHER_PASSWORD'
			$message[2] = 'The network connection was made successfully, but the user had to be prompted for a password other than the one originally specified.'

		Case 2109
			$message[1] = 'ERROR_CONNECTED_OTHER_PASSWORD_DEFAULT'
			$message[2] = 'The network connection was made successfully using default credentials.'

		Case 2202
			$message[1] = 'ERROR_BAD_USERNAME'
			$message[2] = 'The specified username is invalid.'

		Case 2250
			$message[1] = 'ERROR_NOT_CONNECTED'
			$message[2] = 'This network connection does not exist.'

		Case 2401
			$message[1] = 'ERROR_OPEN_FILES'
			$message[2] = 'This network connection has files open or requests pending.'

		Case 2402
			$message[1] = 'ERROR_ACTIVE_CONNECTIONS'
			$message[2] = 'Active connections still exist.'

		Case 2404
			$message[1] = 'ERROR_DEVICE_IN_USE'
			$message[2] = 'The device is in use by an active process and cannot be disconnected.'

		Case 3000
			$message[1] = 'ERROR_UNKNOWN_PRINT_MONITOR'
			$message[2] = 'The specified print monitor is unknown.'

		Case 3001
			$message[1] = 'ERROR_PRINTER_DRIVER_IN_USE'
			$message[2] = 'The specified printer driver is currently in use.'

		Case 3002
			$message[1] = 'ERROR_SPOOL_FILE_NOT_FOUND'
			$message[2] = 'The spool file was not found.'

		Case 3003
			$message[1] = 'ERROR_SPL_NO_STARTDOC'
			$message[2] = 'A StartDocPrinter call was not issued.'

		Case 3004
			$message[1] = 'ERROR_SPL_NO_ADDJOB'
			$message[2] = 'An AddJob call was not issued.'

		Case 3005
			$message[1] = 'ERROR_PRINT_PROCESSOR_ALREADY_INSTALLED'
			$message[2] = 'The specified print processor has already been installed.'

		Case 3006
			$message[1] = 'ERROR_PRINT_MONITOR_ALREADY_INSTALLED'
			$message[2] = 'The specified print monitor has already been installed.'

		Case 3007
			$message[1] = 'ERROR_INVALID_PRINT_MONITOR'
			$message[2] = 'The specified print monitor does not have the required functions.'

		Case 3008
			$message[1] = 'ERROR_PRINT_MONITOR_IN_USE'
			$message[2] = 'The specified print monitor is currently in use.'

		Case 3009
			$message[1] = 'ERROR_PRINTER_HAS_JOBS_QUEUED'
			$message[2] = 'The requested operation is not allowed when there are jobs queued to the printer.'

		Case 3010
			$message[1] = 'ERROR_SUCCESS_REBOOT_REQUIRED'
			$message[2] = 'The requested operation is successful. Changes will not be effective until the system is rebooted.'

		Case 3011
			$message[1] = 'ERROR_SUCCESS_RESTART_REQUIRED'
			$message[2] = 'The requested operation is successful. Changes will not be effective until the service is restarted.'

		Case 3012
			$message[1] = 'ERROR_PRINTER_NOT_FOUND'
			$message[2] = 'No printers were found.'

		Case 3013
			$message[1] = 'ERROR_PRINTER_DRIVER_WARNED'
			$message[2] = 'The printer driver is known to be unreliable.'

		Case 3014
			$message[1] = 'ERROR_PRINTER_DRIVER_BLOCKED'
			$message[2] = 'The printer driver is known to harm the system.'

		Case 3015
			$message[1] = 'ERROR_PRINTER_DRIVER_PACKAGE_IN_USE'
			$message[2] = 'The specified printer driver package is currently in use.'

		Case 3016
			$message[1] = 'ERROR_CORE_DRIVER_PACKAGE_NOT_FOUND'
			$message[2] = 'Unable to find a core driver package that is required by the printer driver package.'

		Case 3017
			$message[1] = 'ERROR_FAIL_REBOOT_REQUIRED'
			$message[2] = 'The requested operation failed. A system reboot is required to roll back changes made.'

		Case 3018
			$message[1] = 'ERROR_FAIL_REBOOT_INITIATED'
			$message[2] = 'The requested operation failed. A system reboot has been initiated to roll back changes made.'

		Case 3019
			$message[1] = 'ERROR_PRINTER_DRIVER_DOWNLOAD_NEEDED'
			$message[2] = 'The specified printer driver was not found on the system and needs to be downloaded.'

		Case 3020
			$message[1] = 'ERROR_PRINT_JOB_RESTART_REQUIRED'
			$message[2] = 'The requested print job has failed to print. A print system update requires the job to be resubmitted.'

		Case 3950
			$message[1] = 'ERROR_IO_REISSUE_AS_CACHED'
			$message[2] = 'Reissue the given operation as a cached I/O operation.'

		Case 4000
			$message[1] = 'ERROR_WINS_INTERNAL'
			$message[2] = 'WINS encountered an error while processing the command.'

		Case 4001
			$message[1] = 'ERROR_CAN_NOT_DEL_LOCAL_WINS'
			$message[2] = 'The local WINS cannot be deleted.'

		Case 4002
			$message[1] = 'ERROR_STATIC_INIT'
			$message[2] = 'The importation from the file failed.'

		Case 4003
			$message[1] = 'ERROR_INC_BACKUP'
			$message[2] = 'The backup failed. Was a full backup done before?'

		Case 4004
			$message[1] = 'ERROR_FULL_BACKUP'
			$message[2] = 'The backup failed. Check the directory to which you are backing the database.'

		Case 4005
			$message[1] = 'ERROR_REC_NON_EXISTENT'
			$message[2] = 'The name does not exist in the WINS database.'

		Case 4006
			$message[1] = 'ERROR_RPL_NOT_ALLOWED'
			$message[2] = 'Replication with a nonconfigured partner is not allowed.'

		Case 4100
			$message[1] = 'ERROR_DHCP_ADDRESS_CONFLICT'
			$message[2] = 'The DHCP client has obtained an IP address that is already in use on the network. The local interface will be disabled until the DHCP client can obtain a new address.'

		Case 4200
			$message[1] = 'ERROR_WMI_GUID_NOT_FOUND'
			$message[2] = 'The GUID passed was not recognized as valid by a WMI data provider.'

		Case 4201
			$message[1] = 'ERROR_WMI_INSTANCE_NOT_FOUND'
			$message[2] = 'The instance name passed was not recognized as valid by a WMI data provider.'

		Case 4202
			$message[1] = 'ERROR_WMI_ITEMID_NOT_FOUND'
			$message[2] = 'The data item ID passed was not recognized as valid by a WMI data provider.'

		Case 4203
			$message[1] = 'ERROR_WMI_TRY_AGAIN'
			$message[2] = 'The WMI request could not be completed and should be retried.'

		Case 4204
			$message[1] = 'ERROR_WMI_DP_NOT_FOUND'
			$message[2] = 'The WMI data provider could not be located.'

		Case 4205
			$message[1] = 'ERROR_WMI_UNRESOLVED_INSTANCE_REF'
			$message[2] = 'The WMI data provider references an instance set that has not been registered.'

		Case 4206
			$message[1] = 'ERROR_WMI_ALREADY_ENABLED'
			$message[2] = 'The WMI data block or event notification has already been enabled.'

		Case 4207
			$message[1] = 'ERROR_WMI_GUID_DISCONNECTED'
			$message[2] = 'The WMI data block is no longer available.'

		Case 4208
			$message[1] = 'ERROR_WMI_SERVER_UNAVAILABLE'
			$message[2] = 'The WMI data service is not available.'

		Case 4209
			$message[1] = 'ERROR_WMI_DP_FAILED'
			$message[2] = 'The WMI data provider failed to carry out the request.'

		Case 4210
			$message[1] = 'ERROR_WMI_INVALID_MOF'
			$message[2] = 'The WMI MOF information is not valid.'

		Case 4211
			$message[1] = 'ERROR_WMI_INVALID_REGINFO'
			$message[2] = 'The WMI registration information is not valid.'

		Case 4212
			$message[1] = 'ERROR_WMI_ALREADY_DISABLED'
			$message[2] = 'The WMI data block or event notification has already been disabled.'

		Case 4213
			$message[1] = 'ERROR_WMI_READ_ONLY'
			$message[2] = 'The WMI data item or data block is read only.'

		Case 4214
			$message[1] = 'ERROR_WMI_SET_FAILURE'
			$message[2] = 'The WMI data item or data block could not be changed.'

		Case 4300
			$message[1] = 'ERROR_INVALID_MEDIA'
			$message[2] = 'The media identifier does not represent a valid medium.'

		Case 4301
			$message[1] = 'ERROR_INVALID_LIBRARY'
			$message[2] = 'The library identifier does not represent a valid library.'

		Case 4302
			$message[1] = 'ERROR_INVALID_MEDIA_POOL'
			$message[2] = 'The media pool identifier does not represent a valid media pool.'

		Case 4303
			$message[1] = 'ERROR_DRIVE_MEDIA_MISMATCH'
			$message[2] = 'The drive and medium are not compatible or exist in different libraries.'

		Case 4304
			$message[1] = 'ERROR_MEDIA_OFFLINE'
			$message[2] = 'The medium currently exists in an offline library and must be online to perform this operation.'

		Case 4305
			$message[1] = 'ERROR_LIBRARY_OFFLINE'
			$message[2] = 'The operation cannot be performed on an offline library.'

		Case 4306
			$message[1] = 'ERROR_EMPTY'
			$message[2] = 'The library, drive, or media pool is empty.'

		Case 4307
			$message[1] = 'ERROR_NOT_EMPTY'
			$message[2] = 'The library, drive, or media pool must be empty to perform this operation.'

		Case 4308
			$message[1] = 'ERROR_MEDIA_UNAVAILABLE'
			$message[2] = 'No media is currently available in this media pool or library.'

		Case 4309
			$message[1] = 'ERROR_RESOURCE_DISABLED'
			$message[2] = 'A resource required for this operation is disabled.'

		Case 4310
			$message[1] = 'ERROR_INVALID_CLEANER'
			$message[2] = 'The media identifier does not represent a valid cleaner.'

		Case 4311
			$message[1] = 'ERROR_UNABLE_TO_CLEAN'
			$message[2] = 'The drive cannot be cleaned or does not support cleaning.'

		Case 4312
			$message[1] = 'ERROR_OBJECT_NOT_FOUND'
			$message[2] = 'The object identifier does not represent a valid object.'

		Case 4313
			$message[1] = 'ERROR_DATABASE_FAILURE'
			$message[2] = 'Unable to read from or write to the database.'

		Case 4314
			$message[1] = 'ERROR_DATABASE_FULL'
			$message[2] = 'The database is full.'

		Case 4315
			$message[1] = 'ERROR_MEDIA_INCOMPATIBLE'
			$message[2] = 'The medium is not compatible with the device or media pool.'

		Case 4316
			$message[1] = 'ERROR_RESOURCE_NOT_PRESENT'
			$message[2] = 'The resource required for this operation does not exist.'

		Case 4317
			$message[1] = 'ERROR_INVALID_OPERATION'
			$message[2] = 'The operation identifier is not valid.'

		Case 4318
			$message[1] = 'ERROR_MEDIA_NOT_AVAILABLE'
			$message[2] = 'The media is not mounted or ready for use.'

		Case 4319
			$message[1] = 'ERROR_DEVICE_NOT_AVAILABLE'
			$message[2] = 'The device is not ready for use.'

		Case 4320
			$message[1] = 'ERROR_REQUEST_REFUSED'
			$message[2] = 'The operator or administrator has refused the request.'

		Case 4321
			$message[1] = 'ERROR_INVALID_DRIVE_OBJECT'
			$message[2] = 'The drive identifier does not represent a valid drive.'

		Case 4322
			$message[1] = 'ERROR_LIBRARY_FULL'
			$message[2] = 'Library is full. No slot is available for use.'

		Case 4323
			$message[1] = 'ERROR_MEDIUM_NOT_ACCESSIBLE'
			$message[2] = 'The transport cannot access the medium.'

		Case 4324
			$message[1] = 'ERROR_UNABLE_TO_LOAD_MEDIUM'
			$message[2] = 'Unable to load the medium into the drive.'

		Case 4325
			$message[1] = 'ERROR_UNABLE_TO_INVENTORY_DRIVE'
			$message[2] = 'Unable to retrieve the drive status.'

		Case 4326
			$message[1] = 'ERROR_UNABLE_TO_INVENTORY_SLOT'
			$message[2] = 'Unable to retrieve the slot status.'

		Case 4327
			$message[1] = 'ERROR_UNABLE_TO_INVENTORY_TRANSPORT'
			$message[2] = 'Unable to retrieve status about the transport.'

		Case 4328
			$message[1] = 'ERROR_TRANSPORT_FULL'
			$message[2] = 'Cannot use the transport because it is already in use.'

		Case 4329
			$message[1] = 'ERROR_CONTROLLING_IEPORT'
			$message[2] = 'Unable to open or close the inject/eject port.'

		Case 4330
			$message[1] = 'ERROR_UNABLE_TO_EJECT_MOUNTED_MEDIA'
			$message[2] = 'Unable to eject the medium because it is in a drive.'

		Case 4331
			$message[1] = 'ERROR_CLEANER_SLOT_SET'
			$message[2] = 'A cleaner slot is already reserved.'

		Case 4332
			$message[1] = 'ERROR_CLEANER_SLOT_NOT_SET'
			$message[2] = 'A cleaner slot is not reserved.'

		Case 4333
			$message[1] = 'ERROR_CLEANER_CARTRIDGE_SPENT'
			$message[2] = 'The cleaner cartridge has performed the maximum number of drive cleanings.'

		Case 4334
			$message[1] = 'ERROR_UNEXPECTED_OMID'
			$message[2] = 'Unexpected on-medium identifier.'

		Case 4335
			$message[1] = 'ERROR_CANT_DELETE_LAST_ITEM'
			$message[2] = 'The last remaining item in this group or resource cannot be deleted.'

		Case 4336
			$message[1] = 'ERROR_MESSAGE_EXCEEDS_MAX_SIZE'
			$message[2] = 'The message provided exceeds the maximum size allowed for this parameter.'

		Case 4337
			$message[1] = 'ERROR_VOLUME_CONTAINS_SYS_FILES'
			$message[2] = 'The volume contains system or paging files.'

		Case 4338
			$message[1] = 'ERROR_INDIGENOUS_TYPE'
			$message[2] = 'The media type cannot be removed from this library since at least one drive in the library reports it can support this media type.'

		Case 4339
			$message[1] = 'ERROR_NO_SUPPORTING_DRIVES'
			$message[2] = 'This offline media cannot be mounted on this system since no enabled drives are present which can be used.'

		Case 4340
			$message[1] = 'ERROR_CLEANER_CARTRIDGE_INSTALLED'
			$message[2] = 'A cleaner cartridge is present in the tape library.'

		Case 4341
			$message[1] = 'ERROR_IEPORT_FULL'
			$message[2] = 'Cannot use the ieport because it is not empty.'

		Case 4350
			$message[1] = 'ERROR_FILE_OFFLINE'
			$message[2] = 'The file is currently not available for use on this computer.'

		Case 4351
			$message[1] = 'ERROR_REMOTE_STORAGE_NOT_ACTIVE'
			$message[2] = 'The remote storage service is not operational at this time.'

		Case 4352
			$message[1] = 'ERROR_REMOTE_STORAGE_MEDIA_ERROR'
			$message[2] = 'The remote storage service encountered a media error.'

		Case 4390
			$message[1] = 'ERROR_NOT_A_REPARSE_POINT'
			$message[2] = 'The file or directory is not a reparse point.'

		Case 4391
			$message[1] = 'ERROR_REPARSE_ATTRIBUTE_CONFLICT'
			$message[2] = 'The reparse point attribute cannot be set because it conflicts with an existing attribute.'

		Case 4392
			$message[1] = 'ERROR_INVALID_REPARSE_DATA'
			$message[2] = 'The data present in the reparse point buffer is invalid.'

		Case 4393
			$message[1] = 'ERROR_REPARSE_TAG_INVALID'
			$message[2] = 'The tag present in the reparse point buffer is invalid.'

		Case 4394
			$message[1] = 'ERROR_REPARSE_TAG_MISMATCH'
			$message[2] = 'There is a mismatch between the tag specified in the request and the tag present in the reparse point.'

		Case 4500
			$message[1] = 'ERROR_VOLUME_NOT_SIS_ENABLED'
			$message[2] = 'Single Instance Storage is not available on this volume.'

		Case 5001
			$message[1] = 'ERROR_DEPENDENT_RESOURCE_EXISTS'
			$message[2] = 'The operation cannot be completed because other resources are dependent on this resource.'

		Case 5002
			$message[1] = 'ERROR_DEPENDENCY_NOT_FOUND'
			$message[2] = 'The cluster resource dependency cannot be found.'

		Case 5003
			$message[1] = 'ERROR_DEPENDENCY_ALREADY_EXISTS'
			$message[2] = 'The cluster resource cannot be made dependent on the specified resource because it is already dependent.'

		Case 5004
			$message[1] = 'ERROR_RESOURCE_NOT_ONLINE'
			$message[2] = 'The cluster resource is not online.'

		Case 5005
			$message[1] = 'ERROR_HOST_NODE_NOT_AVAILABLE'
			$message[2] = 'A cluster node is not available for this operation.'

		Case 5006
			$message[1] = 'ERROR_RESOURCE_NOT_AVAILABLE'
			$message[2] = 'The cluster resource is not available.'

		Case 5007
			$message[1] = 'ERROR_RESOURCE_NOT_FOUND'
			$message[2] = 'The cluster resource could not be found.'

		Case 5008
			$message[1] = 'ERROR_SHUTDOWN_CLUSTER'
			$message[2] = 'The cluster is being shut down.'

		Case 5009
			$message[1] = 'ERROR_CANT_EVICT_ACTIVE_NODE'
			$message[2] = 'A cluster node cannot be evicted from the cluster unless the node is down or it is the last node.'

		Case 5010
			$message[1] = 'ERROR_OBJECT_ALREADY_EXISTS'
			$message[2] = 'The object already exists.'

		Case 5011
			$message[1] = 'ERROR_OBJECT_IN_LIST'
			$message[2] = 'The object is already in the list.'

		Case 5012
			$message[1] = 'ERROR_GROUP_NOT_AVAILABLE'
			$message[2] = 'The cluster group is not available for any new requests.'

		Case 5013
			$message[1] = 'ERROR_GROUP_NOT_FOUND'
			$message[2] = 'The cluster group could not be found.'

		Case 5014
			$message[1] = 'ERROR_GROUP_NOT_ONLINE'
			$message[2] = 'The operation could not be completed because the cluster group is not online.'

		Case 5015
			$message[1] = 'ERROR_HOST_NODE_NOT_RESOURCE_OWNER'
			$message[2] = 'The operation failed because either the specified cluster node is not the owner of the resource, or the node is not a possible owner of the resource.'

		Case 5016
			$message[1] = 'ERROR_HOST_NODE_NOT_GROUP_OWNER'
			$message[2] = 'The operation failed because either the specified cluster node is not the owner of the group, or the node is not a possible owner of the group.'

		Case 5017
			$message[1] = 'ERROR_RESMON_CREATE_FAILED'
			$message[2] = 'The cluster resource could not be created in the specified resource monitor.'

		Case 5018
			$message[1] = 'ERROR_RESMON_ONLINE_FAILED'
			$message[2] = 'The cluster resource could not be brought online by the resource monitor.'

		Case 5019
			$message[1] = 'ERROR_RESOURCE_ONLINE'
			$message[2] = 'The operation could not be completed because the cluster resource is online.'

		Case 5020
			$message[1] = 'ERROR_QUORUM_RESOURCE'
			$message[2] = 'The cluster resource could not be deleted or brought offline because it is the quorum resource.'

		Case 5021
			$message[1] = 'ERROR_NOT_QUORUM_CAPABLE'
			$message[2] = 'The cluster could not make the specified resource a quorum resource because it is not capable of being a quorum resource.'

		Case 5022
			$message[1] = 'ERROR_CLUSTER_SHUTTING_DOWN'
			$message[2] = 'The cluster software is shutting down.'

		Case 5023
			$message[1] = 'ERROR_INVALID_STATE'
			$message[2] = 'The group or resource is not in the correct state to perform the requested operation.'

		Case 5024
			$message[1] = 'ERROR_RESOURCE_PROPERTIES_STORED'
			$message[2] = 'The properties were stored but not all changes will take effect until the next time the resource is brought online.'

		Case 5025
			$message[1] = 'ERROR_NOT_QUORUM_CLASS'
			$message[2] = 'The cluster could not make the specified resource a quorum resource because it does not belong to a shared storage class.'

		Case 5026
			$message[1] = 'ERROR_CORE_RESOURCE'
			$message[2] = 'The cluster resource could not be deleted since it is a core resource.'

		Case 5027
			$message[1] = 'ERROR_QUORUM_RESOURCE_ONLINE_FAILED'
			$message[2] = 'The quorum resource failed to come online.'

		Case 5028
			$message[1] = 'ERROR_QUORUMLOG_OPEN_FAILED'
			$message[2] = 'The quorum log could not be created or mounted successfully.'

		Case 5029
			$message[1] = 'ERROR_CLUSTERLOG_CORRUPT'
			$message[2] = 'The cluster log is corrupt.'

		Case 5030
			$message[1] = 'ERROR_CLUSTERLOG_RECORD_EXCEEDS_MAXSIZE'
			$message[2] = 'The record could not be written to the cluster log since it exceeds the maximum size.'

		Case 5031
			$message[1] = 'ERROR_CLUSTERLOG_EXCEEDS_MAXSIZE'
			$message[2] = 'The cluster log exceeds its maximum size.'

		Case 5032
			$message[1] = 'ERROR_CLUSTERLOG_CHKPOINT_NOT_FOUND'
			$message[2] = 'No checkpoint record was found in the cluster log.'

		Case 5033
			$message[1] = 'ERROR_CLUSTERLOG_NOT_ENOUGH_SPACE'
			$message[2] = 'The minimum required disk space needed for logging is not available.'

		Case 5034
			$message[1] = 'ERROR_QUORUM_OWNER_ALIVE'
			$message[2] = 'The cluster node failed to take control of the quorum resource because the resource is owned by another active node.'

		Case 5035
			$message[1] = 'ERROR_NETWORK_NOT_AVAILABLE'
			$message[2] = 'A cluster network is not available for this operation.'

		Case 5036
			$message[1] = 'ERROR_NODE_NOT_AVAILABLE'
			$message[2] = 'A cluster node is not available for this operation.'

		Case 5037
			$message[1] = 'ERROR_ALL_NODES_NOT_AVAILABLE'
			$message[2] = 'All cluster nodes must be running to perform this operation.'

		Case 5038
			$message[1] = 'ERROR_RESOURCE_FAILED'
			$message[2] = 'A cluster resource failed.'

		Case 5039
			$message[1] = 'ERROR_CLUSTER_INVALID_NODE'
			$message[2] = 'The cluster node is not valid.'

		Case 5040
			$message[1] = 'ERROR_CLUSTER_NODE_EXISTS'
			$message[2] = 'The cluster node already exists.'

		Case 5041
			$message[1] = 'ERROR_CLUSTER_JOIN_IN_PROGRESS'
			$message[2] = 'A node is in the process of joining the cluster.'

		Case 5042
			$message[1] = 'ERROR_CLUSTER_NODE_NOT_FOUND'
			$message[2] = 'The cluster node was not found.'

		Case 5043
			$message[1] = 'ERROR_CLUSTER_LOCAL_NODE_NOT_FOUND'
			$message[2] = 'The cluster local node information was not found.'

		Case 5044
			$message[1] = 'ERROR_CLUSTER_NETWORK_EXISTS'
			$message[2] = 'The cluster network already exists.'

		Case 5045
			$message[1] = 'ERROR_CLUSTER_NETWORK_NOT_FOUND'
			$message[2] = 'The cluster network was not found.'

		Case 5046
			$message[1] = 'ERROR_CLUSTER_NETINTERFACE_EXISTS'
			$message[2] = 'The cluster network interface already exists.'

		Case 5047
			$message[1] = 'ERROR_CLUSTER_NETINTERFACE_NOT_FOUND'
			$message[2] = 'The cluster network interface was not found.'

		Case 5048
			$message[1] = 'ERROR_CLUSTER_INVALID_REQUEST'
			$message[2] = 'The cluster request is not valid for this object.'

		Case 5049
			$message[1] = 'ERROR_CLUSTER_INVALID_NETWORK_PROVIDER'
			$message[2] = 'The cluster network provider is not valid.'

		Case 5050
			$message[1] = 'ERROR_CLUSTER_NODE_DOWN'
			$message[2] = 'The cluster node is down.'

		Case 5051
			$message[1] = 'ERROR_CLUSTER_NODE_UNREACHABLE'
			$message[2] = 'The cluster node is not reachable.'

		Case 5052
			$message[1] = 'ERROR_CLUSTER_NODE_NOT_MEMBER'
			$message[2] = 'The cluster node is not a member of the cluster.'

		Case 5053
			$message[1] = 'ERROR_CLUSTER_JOIN_NOT_IN_PROGRESS'
			$message[2] = 'A cluster join operation is not in progress.'

		Case 5054
			$message[1] = 'ERROR_CLUSTER_INVALID_NETWORK'
			$message[2] = 'The cluster network is not valid.'

		Case 5056
			$message[1] = 'ERROR_CLUSTER_NODE_UP'
			$message[2] = 'The cluster node is up.'

		Case 5057
			$message[1] = 'ERROR_CLUSTER_IPADDR_IN_USE'
			$message[2] = 'The cluster IP address is already in use.'

		Case 5058
			$message[1] = 'ERROR_CLUSTER_NODE_NOT_PAUSED'
			$message[2] = 'The cluster node is not paused.'

		Case 5059
			$message[1] = 'ERROR_CLUSTER_NO_SECURITY_CONTEXT'
			$message[2] = 'No cluster security context is available.'

		Case 5060
			$message[1] = 'ERROR_CLUSTER_NETWORK_NOT_INTERNAL'
			$message[2] = 'The cluster network is not configured for internal cluster communication.'

		Case 5061
			$message[1] = 'ERROR_CLUSTER_NODE_ALREADY_UP'
			$message[2] = 'The cluster node is already up.'

		Case 5062
			$message[1] = 'ERROR_CLUSTER_NODE_ALREADY_DOWN'
			$message[2] = 'The cluster node is already down.'

		Case 5063
			$message[1] = 'ERROR_CLUSTER_NETWORK_ALREADY_ONLINE'
			$message[2] = 'The cluster network is already online.'

		Case 5064
			$message[1] = 'ERROR_CLUSTER_NETWORK_ALREADY_OFFLINE'
			$message[2] = 'The cluster network is already offline.'

		Case 5065
			$message[1] = 'ERROR_CLUSTER_NODE_ALREADY_MEMBER'
			$message[2] = 'The cluster node is already a member of the cluster.'

		Case 5066
			$message[1] = 'ERROR_CLUSTER_LAST_INTERNAL_NETWORK'
			$message[2] = 'The cluster network is the only one configured for internal cluster communication between two or more active cluster nodes. The internal communication capability cannot be removed from the network.'

		Case 5067
			$message[1] = 'ERROR_CLUSTER_NETWORK_HAS_DEPENDENTS'
			$message[2] = 'One or more cluster resources depend on the network to provide service to clients. The client access capability cannot be removed from the network.'

		Case 5068
			$message[1] = 'ERROR_INVALID_OPERATION_ON_QUORUM'
			$message[2] = 'This operation cannot be performed on the cluster resource as it the quorum resource. You may not bring the quorum resource offline or modify its possible owners list.'

		Case 5069
			$message[1] = 'ERROR_DEPENDENCY_NOT_ALLOWED'
			$message[2] = 'The cluster quorum resource is not allowed to have any dependencies.'

		Case 5070
			$message[1] = 'ERROR_CLUSTER_NODE_PAUSED'
			$message[2] = 'The cluster node is paused.'

		Case 5071
			$message[1] = 'ERROR_NODE_CANT_HOST_RESOURCE'
			$message[2] = 'The cluster resource cannot be brought online. The owner node cannot run this resource.'

		Case 5072
			$message[1] = 'ERROR_CLUSTER_NODE_NOT_READY'
			$message[2] = 'The cluster node is not ready to perform the requested operation.'

		Case 5073
			$message[1] = 'ERROR_CLUSTER_NODE_SHUTTING_DOWN'
			$message[2] = 'The cluster node is shutting down.'

		Case 5074
			$message[1] = 'ERROR_CLUSTER_JOIN_ABORTED'
			$message[2] = 'The cluster join operation was aborted.'

		Case 5075
			$message[1] = 'ERROR_CLUSTER_INCOMPATIBLE_VERSIONS'
			$message[2] = 'The cluster join operation failed due to incompatible software versions between the joining node and its sponsor.'

		Case 5076
			$message[1] = 'ERROR_CLUSTER_MAXNUM_OF_RESOURCES_EXCEEDED'
			$message[2] = 'This resource cannot be created because the cluster has reached the limit on the number of resources it can monitor.'

		Case 5077
			$message[1] = 'ERROR_CLUSTER_SYSTEM_CONFIG_CHANGED'
			$message[2] = 'The system configuration changed during the cluster join or form operation. The join or form operation was aborted.'

		Case 5078
			$message[1] = 'ERROR_CLUSTER_RESOURCE_TYPE_NOT_FOUND'
			$message[2] = 'The specified resource type was not found.'

		Case 5079
			$message[1] = 'ERROR_CLUSTER_RESTYPE_NOT_SUPPORTED'
			$message[2] = 'The specified node does not support a resource of this type. This may be due to version inconsistencies or due to the absence of the resource DLL on this node.'

		Case 5080
			$message[1] = 'ERROR_CLUSTER_RESNAME_NOT_FOUND'
			$message[2] = 'The specified resource name is not supported by this resource DLL. This may be due to a bad (or changed) name supplied to the resource DLL.'

		Case 5081
			$message[1] = 'ERROR_CLUSTER_NO_RPC_PACKAGES_REGISTERED'
			$message[2] = 'No authentication package could be registered with the RPC server.'

		Case 5082
			$message[1] = 'ERROR_CLUSTER_OWNER_NOT_IN_PREFLIST'
			$message[2] = 'You cannot bring the group online because the owner of the group is not in the preferred list for the group. To change the owner node for the group, move the group.'

		Case 5083
			$message[1] = 'ERROR_CLUSTER_DATABASE_SEQMISMATCH'
			$message[2] = 'The join operation failed because the cluster database sequence number has changed or is incompatible with the locker node. This may happen during a join operation if the cluster database was changing during the join.'

		Case 5084
			$message[1] = 'ERROR_RESMON_INVALID_STATE'
			$message[2] = 'The resource monitor will not allow the fail operation to be performed while the resource is in its current state. This may happen if the resource is in a pending state.'

		Case 5085
			$message[1] = 'ERROR_CLUSTER_GUM_NOT_LOCKER'
			$message[2] = 'A non locker code got a request to reserve the lock for making global updates.'

		Case 5086
			$message[1] = 'ERROR_QUORUM_DISK_NOT_FOUND'
			$message[2] = 'The quorum disk could not be located by the cluster service.'

		Case 5087
			$message[1] = 'ERROR_DATABASE_BACKUP_CORRUPT'
			$message[2] = 'The backed up cluster database is possibly corrupt.'

		Case 5088
			$message[1] = 'ERROR_CLUSTER_NODE_ALREADY_HAS_DFS_ROOT'
			$message[2] = 'A DFS root already exists in this cluster node.'

		Case 5089
			$message[1] = 'ERROR_RESOURCE_PROPERTY_UNCHANGEABLE'
			$message[2] = 'An attempt to modify a resource property failed because it conflicts with another existing property.'

		Case 5890
			$message[1] = 'ERROR_CLUSTER_MEMBERSHIP_INVALID_STATE'
			$message[2] = 'An operation was attempted that is incompatible with the current membership state of the node.'

		Case 5891
			$message[1] = 'ERROR_CLUSTER_QUORUMLOG_NOT_FOUND'
			$message[2] = 'The quorum resource does not contain the quorum log.'

		Case 5892
			$message[1] = 'ERROR_CLUSTER_MEMBERSHIP_HALT'
			$message[2] = 'The membership engine requested shutdown of the cluster service on this node.'

		Case 5893
			$message[1] = 'ERROR_CLUSTER_INSTANCE_ID_MISMATCH'
			$message[2] = 'The join operation failed because the cluster instance ID of the joining node does not match the cluster instance ID of the sponsor node.'

		Case 5894
			$message[1] = 'ERROR_CLUSTER_NETWORK_NOT_FOUND_FOR_IP'
			$message[2] = 'A matching cluster network for the specified IP address could not be found.'

		Case 5895
			$message[1] = 'ERROR_CLUSTER_PROPERTY_DATA_TYPE_MISMATCH'
			$message[2] = 'The actual data type of the property did not match the expected data type of the property.'

		Case 5896
			$message[1] = 'ERROR_CLUSTER_EVICT_WITHOUT_CLEANUP'
			$message[2] = 'The cluster node was evicted from the cluster successfully, but the node was not cleaned up. To determine what cleanup steps failed and how to recover, see the Failover Clustering application event log using Event Viewer.'

		Case 5897
			$message[1] = 'ERROR_CLUSTER_PARAMETER_MISMATCH'
			$message[2] = 'Two or more parameter values specified for a resource''s properties are in conflict.'

		Case 5898
			$message[1] = 'ERROR_NODE_CANNOT_BE_CLUSTERED'
			$message[2] = 'This computer cannot be made a member of a cluster.'

		Case 5899
			$message[1] = 'ERROR_CLUSTER_WRONG_OS_VERSION'
			$message[2] = 'This computer cannot be made a member of a cluster because it does not have the correct version of Windows installed.'

		Case 5900
			$message[1] = 'ERROR_CLUSTER_CANT_CREATE_DUP_CLUSTER_NAME'
			$message[2] = 'A cluster cannot be created with the specified cluster name because that cluster name is already in use. Specify a different name for the cluster.'

		Case 5901
			$message[1] = 'ERROR_CLUSCFG_ALREADY_COMMITTED'
			$message[2] = 'The cluster configuration action has already been committed.'

		Case 5902
			$message[1] = 'ERROR_CLUSCFG_ROLLBACK_FAILED'
			$message[2] = 'The cluster configuration action could not be rolled back.'

		Case 5903
			$message[1] = 'ERROR_CLUSCFG_SYSTEM_DISK_DRIVE_LETTER_CONFLICT'
			$message[2] = 'The drive letter assigned to a system disk on one node conflicted with the drive letter assigned to a disk on another node.'

		Case 5904
			$message[1] = 'ERROR_CLUSTER_OLD_VERSION'
			$message[2] = 'One or more nodes in the cluster are running a version of Windows that does not support this operation.'

		Case 5905
			$message[1] = 'ERROR_CLUSTER_MISMATCHED_COMPUTER_ACCT_NAME'
			$message[2] = 'The name of the corresponding computer account doesn''t match the Network Name for this resource.'

		Case 5906
			$message[1] = 'ERROR_CLUSTER_NO_NET_ADAPTERS'
			$message[2] = 'No network adapters are available.'

		Case 5907
			$message[1] = 'ERROR_CLUSTER_POISONED'
			$message[2] = 'The cluster node has been poisoned.'

		Case 5908
			$message[1] = 'ERROR_CLUSTER_GROUP_MOVING'
			$message[2] = 'The group is unable to accept the request since it is moving to another node.'

		Case 5909
			$message[1] = 'ERROR_CLUSTER_RESOURCE_TYPE_BUSY'
			$message[2] = 'The resource type cannot accept the request since is too busy performing another operation.'

		Case 5910
			$message[1] = 'ERROR_RESOURCE_CALL_TIMED_OUT'
			$message[2] = 'The call to the cluster resource DLL timed out.'

		Case 5911
			$message[1] = 'ERROR_INVALID_CLUSTER_IPV6_ADDRESS'
			$message[2] = 'The address is not valid for an IPv6 Address resource. A global IPv6 address is required, and it must match a cluster network. Compatibility addresses are not permitted.'

		Case 5912
			$message[1] = 'ERROR_CLUSTER_INTERNAL_INVALID_FUNCTION'
			$message[2] = 'An internal cluster error occurred. A call to an invalid function was attempted.'

		Case 5913
			$message[1] = 'ERROR_CLUSTER_PARAMETER_OUT_OF_BOUNDS'
			$message[2] = 'A parameter value is out of acceptable range.'

		Case 5914
			$message[1] = 'ERROR_CLUSTER_PARTIAL_SEND'
			$message[2] = 'A network error occurred while sending data to another node in the cluster. The number of bytes transmitted was less than required.'

		Case 5915
			$message[1] = 'ERROR_CLUSTER_REGISTRY_INVALID_FUNCTION'
			$message[2] = 'An invalid cluster registry operation was attempted.'

		Case 5916
			$message[1] = 'ERROR_CLUSTER_INVALID_STRING_TERMINATION'
			$message[2] = 'An input string of characters is not properly terminated.'

		Case 5917
			$message[1] = 'ERROR_CLUSTER_INVALID_STRING_FORMAT'
			$message[2] = 'An input string of characters is not in a valid format for the data it represents.'

		Case 5918
			$message[1] = 'ERROR_CLUSTER_DATABASE_TRANSACTION_IN_PROGRESS'
			$message[2] = 'An internal cluster error occurred. A cluster database transaction was attempted while a transaction was already in progress.'

		Case 5919
			$message[1] = 'ERROR_CLUSTER_DATABASE_TRANSACTION_NOT_IN_PROGRESS'
			$message[2] = 'An internal cluster error occurred. There was an attempt to commit a cluster database transaction while no transaction was in progress.'

		Case 5920
			$message[1] = 'ERROR_CLUSTER_NULL_DATA'
			$message[2] = 'An internal cluster error occurred. Data was not properly initialized.'

		Case 5921
			$message[1] = 'ERROR_CLUSTER_PARTIAL_READ'
			$message[2] = 'An error occurred while reading from a stream of data. An unexpected number of bytes was returned.'

		Case 5922
			$message[1] = 'ERROR_CLUSTER_PARTIAL_WRITE'
			$message[2] = 'An error occurred while writing to a stream of data. The required number of bytes could not be written.'

		Case 5923
			$message[1] = 'ERROR_CLUSTER_CANT_DESERIALIZE_DATA'
			$message[2] = 'An error occurred while deserializing a stream of cluster data.'

		Case 5924
			$message[1] = 'ERROR_DEPENDENT_RESOURCE_PROPERTY_CONFLICT'
			$message[2] = 'One or more property values for this resource are in conflict with one or more property values associated with its dependent resource(s).'

		Case 5925
			$message[1] = 'ERROR_CLUSTER_NO_QUORUM'
			$message[2] = 'An quorum of cluster nodes was not present to form a cluster.'

		Case 5926
			$message[1] = 'ERROR_CLUSTER_INVALID_IPV6_NETWORK'
			$message[2] = 'The cluster network is not valid for an IPv6 Address resource, or it does not match the configured address.'

		Case 5927
			$message[1] = 'ERROR_CLUSTER_INVALID_IPV6_TUNNEL_NETWORK'
			$message[2] = 'The cluster network is not valid for an IPv6 Tunnel resource. Check the configuration of the IP Address resource on which the IPv6 Tunnel resource depends.'

		Case 5928
			$message[1] = 'ERROR_QUORUM_NOT_ALLOWED_IN_THIS_GROUP'
			$message[2] = 'Quorum resource cannot reside in the Available Storage group.'

		Case 5929
			$message[1] = 'ERROR_DEPENDENCY_TREE_TOO_COMPLEX'
			$message[2] = 'The dependencies for this resource are nested too deeply.'

		Case 5930
			$message[1] = 'ERROR_EXCEPTION_IN_RESOURCE_CALL'
			$message[2] = 'The call into the resource DLL raised an unhandled exception.'

		Case 5931
			$message[1] = 'ERROR_CLUSTER_RHS_FAILED_INITIALIZATION'
			$message[2] = 'The RHS process failed to initialize.'

		Case 5932
			$message[1] = 'ERROR_CLUSTER_NOT_INSTALLED'
			$message[2] = 'The Failover Clustering feature is not installed on this node.'

		Case 5933
			$message[1] = 'ERROR_CLUSTER_RESOURCES_MUST_BE_ONLINE_ON_THE_SAME_NODE'
			$message[2] = 'The resources must be online on the same node for this operation.'

		Case 5934
			$message[1] = 'ERROR_CLUSTER_MAX_NODES_IN_CLUSTER'
			$message[2] = 'A new node cannot be added since this cluster is already at its maximum number of nodes.'

		Case 5935
			$message[1] = 'ERROR_CLUSTER_TOO_MANY_NODES'
			$message[2] = 'This cluster cannot be created since the specified number of nodes exceeds the maximum allowed limit.'

		Case 5936
			$message[1] = 'ERROR_CLUSTER_OBJECT_ALREADY_USED'
			$message[2] = 'An attempt to use the specified cluster name failed because an enabled computer object with the given name already exists in the domain.'

		Case 5937
			$message[1] = 'ERROR_NONCORE_GROUPS_FOUND'
			$message[2] = 'This cluster cannot be destroyed. It has non-core application groups which must be deleted before the cluster can be destroyed.'

		Case 5938
			$message[1] = 'ERROR_FILE_SHARE_RESOURCE_CONFLICT'
			$message[2] = 'File share associated with file share witness resource cannot be hosted by this cluster or any of its nodes.'

		Case 5939
			$message[1] = 'ERROR_CLUSTER_EVICT_INVALID_REQUEST'
			$message[2] = 'The last node in the cluster cannot evicted especially when the cluster contains one or more active cluster resources.'

		Case 5940
			$message[1] = 'ERROR_CLUSTER_SINGLETON_RESOURCE'
			$message[2] = 'Only one instance of this resource type is allowed in the cluster.'

		Case 5941
			$message[1] = 'ERROR_CLUSTER_GROUP_SINGLETON_RESOURCE'
			$message[2] = 'Only one instance of this resource type is allowed per resource group'

		Case 6000
			$message[1] = 'ERROR_ENCRYPTION_FAILED'
			$message[2] = 'The specified file could not be encrypted.'

		Case 6001
			$message[1] = 'ERROR_DECRYPTION_FAILED'
			$message[2] = 'The specified file could not be decrypted.'

		Case 6002
			$message[1] = 'ERROR_FILE_ENCRYPTED'
			$message[2] = 'The specified file is encrypted and the user does not have the ability to decrypt it.'

		Case 6003
			$message[1] = 'ERROR_NO_RECOVERY_POLICY'
			$message[2] = 'There is no valid encryption recovery policy configured for this system.'

		Case 6004
			$message[1] = 'ERROR_NO_EFS'
			$message[2] = 'The required encryption driver is not loaded for this system.'

		Case 6005
			$message[1] = 'ERROR_WRONG_EFS'
			$message[2] = 'The file was encrypted with a different encryption driver than is currently loaded.'

		Case 6006
			$message[1] = 'ERROR_NO_USER_KEYS'
			$message[2] = 'There are no EFS keys defined for the user.'

		Case 6007
			$message[1] = 'ERROR_FILE_NOT_ENCRYPTED'
			$message[2] = 'The specified file is not encrypted.'

		Case 6008
			$message[1] = 'ERROR_NOT_EXPORT_FORMAT'
			$message[2] = 'The specified file is not in the defined EFS export format.'

		Case 6009
			$message[1] = 'ERROR_FILE_READ_ONLY'
			$message[2] = 'The specified file is read only.'

		Case 6010
			$message[1] = 'ERROR_DIR_EFS_DISALLOWED'
			$message[2] = 'The directory has been disabled for encryption.'

		Case 6011
			$message[1] = 'ERROR_EFS_SERVER_NOT_TRUSTED'
			$message[2] = 'The server is not trusted for remote encryption operation.'

		Case 6012
			$message[1] = 'ERROR_BAD_RECOVERY_POLICY'
			$message[2] = 'Recovery policy configured for this system contains invalid recovery certificate.'

		Case 6013
			$message[1] = 'ERROR_EFS_ALG_BLOB_TOO_BIG'
			$message[2] = 'The encryption algorithm used on the source file needs a bigger key buffer than the one on the destination file.'

		Case 6014
			$message[1] = 'ERROR_VOLUME_NOT_SUPPORT_EFS'
			$message[2] = 'The disk partition does not support file encryption.'

		Case 6015
			$message[1] = 'ERROR_EFS_DISABLED'
			$message[2] = 'This machine is disabled for file encryption.'

		Case 6016
			$message[1] = 'ERROR_EFS_VERSION_NOT_SUPPORT'
			$message[2] = 'A newer system is required to decrypt this encrypted file.'

		Case 6017
			$message[1] = 'ERROR_CS_ENCRYPTION_INVALID_SERVER_RESPONSE'
			$message[2] = 'The remote server sent an invalid response for a file being opened with Client Side Encryption.'

		Case 6018
			$message[1] = 'ERROR_CS_ENCRYPTION_UNSUPPORTED_SERVER'
			$message[2] = 'Client Side Encryption is not supported by the remote server even though it claims to support it.'

		Case 6019
			$message[1] = 'ERROR_CS_ENCRYPTION_EXISTING_ENCRYPTED_FILE'
			$message[2] = 'File is encrypted and should be opened in Client Side Encryption mode.'

		Case 6020
			$message[1] = 'ERROR_CS_ENCRYPTION_NEW_ENCRYPTED_FILE'
			$message[2] = 'A new encrypted file is being created and a $EFS needs to be provided.'

		Case 6021
			$message[1] = 'ERROR_CS_ENCRYPTION_FILE_NOT_CSE'
			$message[2] = 'The SMB client requested a CSE FSCTL on a non-CSE file.'

		Case 6118
			$message[1] = 'ERROR_NO_BROWSER_SERVERS_FOUND'
			$message[2] = 'The list of servers for this workgroup is not currently available'

		Case 6200
			$message[1] = 'SCHED_E_SERVICE_NOT_LOCALSYSTEM'
			$message[2] = 'The Task Scheduler service must be configured to run in the System account to function properly. Individual tasks may be configured to run in other accounts.'

		Case 6600
			$message[1] = 'ERROR_LOG_SECTOR_INVALID'
			$message[2] = 'Log service encountered an invalid log sector.'

		Case 6601
			$message[1] = 'ERROR_LOG_SECTOR_PARITY_INVALID'
			$message[2] = 'Log service encountered a log sector with invalid block parity.'

		Case 6602
			$message[1] = 'ERROR_LOG_SECTOR_REMAPPED'
			$message[2] = 'Log service encountered a remapped log sector.'

		Case 6603
			$message[1] = 'ERROR_LOG_BLOCK_INCOMPLETE'
			$message[2] = 'Log service encountered a partial or incomplete log block.'

		Case 6604
			$message[1] = 'ERROR_LOG_INVALID_RANGE'
			$message[2] = 'Log service encountered an attempt access data outside the active log range.'

		Case 6605
			$message[1] = 'ERROR_LOG_BLOCKS_EXHAUSTED'
			$message[2] = 'Log service user marshalling buffers are exhausted.'

		Case 6606
			$message[1] = 'ERROR_LOG_READ_CONTEXT_INVALID'
			$message[2] = 'Log service encountered an attempt read from a marshalling area with an invalid read context.'

		Case 6607
			$message[1] = 'ERROR_LOG_RESTART_INVALID'
			$message[2] = 'Log service encountered an invalid log restart area.'

		Case 6608
			$message[1] = 'ERROR_LOG_BLOCK_VERSION'
			$message[2] = 'Log service encountered an invalid log block version.'

		Case 6609
			$message[1] = 'ERROR_LOG_BLOCK_INVALID'
			$message[2] = 'Log service encountered an invalid log block.'

		Case 6610
			$message[1] = 'ERROR_LOG_READ_MODE_INVALID'
			$message[2] = 'Log service encountered an attempt to read the log with an invalid read mode.'

		Case 6611
			$message[1] = 'ERROR_LOG_NO_RESTART'
			$message[2] = 'Log service encountered a log stream with no restart area.'

		Case 6612
			$message[1] = 'ERROR_LOG_METADATA_CORRUPT'
			$message[2] = 'Log service encountered a corrupted metadata file.'

		Case 6613
			$message[1] = 'ERROR_LOG_METADATA_INVALID'
			$message[2] = 'Log service encountered a metadata file that could not be created by the log file system.'

		Case 6614
			$message[1] = 'ERROR_LOG_METADATA_INCONSISTENT'
			$message[2] = 'Log service encountered a metadata file with inconsistent data.'

		Case 6615
			$message[1] = 'ERROR_LOG_RESERVATION_INVALID'
			$message[2] = 'Log service encountered an attempt to erroneous allocate or dispose reservation space.'

		Case 6616
			$message[1] = 'ERROR_LOG_CANT_DELETE'
			$message[2] = 'Log service cannot delete log file or file system container.'

		Case 6617
			$message[1] = 'ERROR_LOG_CONTAINER_LIMIT_EXCEEDED'
			$message[2] = 'Log service has reached the maximum allowable containers allocated to a log file.'

		Case 6618
			$message[1] = 'ERROR_LOG_START_OF_LOG'
			$message[2] = 'Log service has attempted to read or write backward past the start of the log.'

		Case 6619
			$message[1] = 'ERROR_LOG_POLICY_ALREADY_INSTALLED'
			$message[2] = 'Log policy could not be installed because a policy of the same type is already present.'

		Case 6620
			$message[1] = 'ERROR_LOG_POLICY_NOT_INSTALLED'
			$message[2] = 'Log policy in question was not installed at the time of the request.'

		Case 6621
			$message[1] = 'ERROR_LOG_POLICY_INVALID'
			$message[2] = 'The installed set of policies on the log is invalid.'

		Case 6622
			$message[1] = 'ERROR_LOG_POLICY_CONFLICT'
			$message[2] = 'A policy on the log in question prevented the operation from completing.'

		Case 6623
			$message[1] = 'ERROR_LOG_PINNED_ARCHIVE_TAIL'
			$message[2] = 'Log space cannot be reclaimed because the log is pinned by the archive tail.'

		Case 6624
			$message[1] = 'ERROR_LOG_RECORD_NONEXISTENT'
			$message[2] = 'Log record is not a record in the log file.'

		Case 6625
			$message[1] = 'ERROR_LOG_RECORDS_RESERVED_INVALID'
			$message[2] = 'The number of reserved log records or the adjustment of the number of reserved log records is invalid.'

		Case 6626
			$message[1] = 'ERROR_LOG_SPACE_RESERVED_INVALID'
			$message[2] = 'Reserved log space or the adjustment of the log space is invalid.'

		Case 6627
			$message[1] = 'ERROR_LOG_TAIL_INVALID'
			$message[2] = 'An new or existing archive tail or base of the active log is invalid.'

		Case 6628
			$message[1] = 'ERROR_LOG_FULL'
			$message[2] = 'Log space is exhausted.'

		Case 6629
			$message[1] = 'ERROR_COULD_NOT_RESIZE_LOG'
			$message[2] = 'The log could not be set to the requested size. '

		Case 6630
			$message[1] = 'ERROR_LOG_MULTIPLEXED'
			$message[2] = 'Log is multiplexed, no direct writes to the physical log is allowed.'

		Case 6631
			$message[1] = 'ERROR_LOG_DEDICATED'
			$message[2] = 'The operation failed because the log is a dedicated log.'

		Case 6632
			$message[1] = 'ERROR_LOG_ARCHIVE_NOT_IN_PROGRESS'
			$message[2] = 'The operation requires an archive context.'

		Case 6633
			$message[1] = 'ERROR_LOG_ARCHIVE_IN_PROGRESS'
			$message[2] = 'Log archival is in progress.'

		Case 6634
			$message[1] = 'ERROR_LOG_EPHEMERAL'
			$message[2] = 'The operation requires a non-ephemeral log, but the log is ephemeral.'

		Case 6635
			$message[1] = 'ERROR_LOG_NOT_ENOUGH_CONTAINERS'
			$message[2] = 'The log must have at least two containers before it can be read from or written to.'

		Case 6636
			$message[1] = 'ERROR_LOG_CLIENT_ALREADY_REGISTERED'
			$message[2] = 'A log client has already registered on the stream.'

		Case 6637
			$message[1] = 'ERROR_LOG_CLIENT_NOT_REGISTERED'
			$message[2] = 'A log client has not been registered on the stream.'

		Case 6638
			$message[1] = 'ERROR_LOG_FULL_HANDLER_IN_PROGRESS'
			$message[2] = 'A request has already been made to handle the log full condition.'

		Case 6639
			$message[1] = 'ERROR_LOG_CONTAINER_READ_FAILED'
			$message[2] = 'Log service enountered an error when attempting to read from a log container.'

		Case 6640
			$message[1] = 'ERROR_LOG_CONTAINER_WRITE_FAILED'
			$message[2] = 'Log service enountered an error when attempting to write to a log container.'

		Case 6641
			$message[1] = 'ERROR_LOG_CONTAINER_OPEN_FAILED'
			$message[2] = 'Log service enountered an error when attempting open a log container.'

		Case 6642
			$message[1] = 'ERROR_LOG_CONTAINER_STATE_INVALID'
			$message[2] = 'Log service enountered an invalid container state when attempting a requested action.'

		Case 6643
			$message[1] = 'ERROR_LOG_STATE_INVALID'
			$message[2] = 'Log service is not in the correct state to perform a requested action.'

		Case 6644
			$message[1] = 'ERROR_LOG_PINNED'
			$message[2] = 'Log space cannot be reclaimed because the log is pinned.'

		Case 6645
			$message[1] = 'ERROR_LOG_METADATA_FLUSH_FAILED'
			$message[2] = 'Log metadata flush failed.'

		Case 6646
			$message[1] = 'ERROR_LOG_INCONSISTENT_SECURITY'
			$message[2] = 'Security on the log and its containers is inconsistent.'

		Case 6647
			$message[1] = 'ERROR_LOG_APPENDED_FLUSH_FAILED'
			$message[2] = 'Records were appended to the log or reservation changes were made, but the log could not be flushed. '

		Case 6648
			$message[1] = 'ERROR_LOG_PINNED_RESERVATION'
			$message[2] = 'The log is pinned due to reservation consuming most of the log space. Free some reserved records to make space available. '

		Case 6700
			$message[1] = 'ERROR_INVALID_TRANSACTION'
			$message[2] = 'The transaction handle associated with this operation is not valid.'

		Case 6701
			$message[1] = 'ERROR_TRANSACTION_NOT_ACTIVE'
			$message[2] = 'The requested operation was made in the context of a transaction that is no longer active.'

		Case 6702
			$message[1] = 'ERROR_TRANSACTION_REQUEST_NOT_VALID'
			$message[2] = 'The requested operation is not valid on the Transaction object in its current state.'

		Case 6703
			$message[1] = 'ERROR_TRANSACTION_NOT_REQUESTED'
			$message[2] = 'The caller has called a response API, but the response is not expected because the TM did not issue the corresponding request to the caller.'

		Case 6704
			$message[1] = 'ERROR_TRANSACTION_ALREADY_ABORTED'
			$message[2] = 'It is too late to perform the requested operation, since the Transaction has already been aborted.'

		Case 6705
			$message[1] = 'ERROR_TRANSACTION_ALREADY_COMMITTED'
			$message[2] = 'It is too late to perform the requested operation, since the Transaction has already been committed.'

		Case 6706
			$message[1] = 'ERROR_TM_INITIALIZATION_FAILED'
			$message[2] = 'The Transaction Manager was unable to be successfully initialized. Transacted operations are not supported.'

		Case 6707
			$message[1] = 'ERROR_RESOURCEMANAGER_READ_ONLY'
			$message[2] = 'The specified ResourceManager made no changes or updates to the resource under this transaction.'

		Case 6708
			$message[1] = 'ERROR_TRANSACTION_NOT_JOINED'
			$message[2] = 'The resource manager has attempted to prepare a transaction that it has not successfully joined.'

		Case 6709
			$message[1] = 'ERROR_TRANSACTION_SUPERIOR_EXISTS'
			$message[2] = 'The Transaction object already has a superior enlistment, and the caller attempted an operation that would have created a new superior. Only a single superior enlistment is allow.'

		Case 6710
			$message[1] = 'ERROR_CRM_PROTOCOL_ALREADY_EXISTS'
			$message[2] = 'The RM tried to register a protocol that already exists.'

		Case 6711
			$message[1] = 'ERROR_TRANSACTION_PROPAGATION_FAILED'
			$message[2] = 'The attempt to propagate the Transaction failed.'

		Case 6712
			$message[1] = 'ERROR_CRM_PROTOCOL_NOT_FOUND'
			$message[2] = 'The requested propagation protocol was not registered as a CRM.'

		Case 6713
			$message[1] = 'ERROR_TRANSACTION_INVALID_MARSHALL_BUFFER'
			$message[2] = 'The buffer passed in to PushTransaction or PullTransaction is not in a valid format.'

		Case 6714
			$message[1] = 'ERROR_CURRENT_TRANSACTION_NOT_VALID'
			$message[2] = 'The current transaction context associated with the thread is not a valid handle to a transaction object.'

		Case 6715
			$message[1] = 'ERROR_TRANSACTION_NOT_FOUND'
			$message[2] = 'The specified Transaction object could not be opened, because it was not found.'

		Case 6716
			$message[1] = 'ERROR_RESOURCEMANAGER_NOT_FOUND'
			$message[2] = 'The specified ResourceManager object could not be opened, because it was not found. '

		Case 6717
			$message[1] = 'ERROR_ENLISTMENT_NOT_FOUND'
			$message[2] = 'The specified Enlistment object could not be opened, because it was not found. '

		Case 6718
			$message[1] = 'ERROR_TRANSACTIONMANAGER_NOT_FOUND'
			$message[2] = 'The specified TransactionManager object could not be opened, because it was not found. '

		Case 6719
			$message[1] = 'ERROR_TRANSACTIONMANAGER_NOT_ONLINE'
			$message[2] = 'The specified ResourceManager was unable to create an enlistment, because its associated TransactionManager is not online.'

		Case 6720
			$message[1] = 'ERROR_TRANSACTIONMANAGER_RECOVERY_NAME_COLLISION'
			$message[2] = 'The specified TransactionManager was unable to create the objects contained in its logfile in the Ob namespace. Therefore, the TransactionManager was unable to recover.'

		Case 6721
			$message[1] = 'ERROR_TRANSACTION_NOT_ROOT'
			$message[2] = 'The call to create a superior Enlistment on this Transaction object could not be completed, because the Transaction object specified for the enlistment is a subordinate branch of the Transaction. Only the root of the Transactoin can be enlisted on as a superior.'

		Case 6722
			$message[1] = 'ERROR_TRANSACTION_OBJECT_EXPIRED'
			$message[2] = 'Because the associated transaction manager or resource manager has been closed, the handle is no longer valid.'

		Case 6723
			$message[1] = 'ERROR_TRANSACTION_RESPONSE_NOT_ENLISTED'
			$message[2] = 'The specified operation could not be performed on this Superior enlistment, because the enlistment was not created with the corresponding completion response in the NotificationMask.'

		Case 6724
			$message[1] = 'ERROR_TRANSACTION_RECORD_TOO_LONG'
			$message[2] = 'The specified operation could not be performed, because the record that would be logged was too long. This can occur because of two conditions: either there are too many Enlistments on this Transaction, or the combined RecoveryInformation being logged on behalf of those Enlistments is too long.'

		Case 6725
			$message[1] = 'ERROR_IMPLICIT_TRANSACTION_NOT_SUPPORTED'
			$message[2] = 'Implicit transactions are not supported.'

		Case 6726
			$message[1] = 'ERROR_TRANSACTION_INTEGRITY_VIOLATED'
			$message[2] = 'The kernel transaction manager had to abort or forget the transaction because it blocked forward progress.'

		Case 6800
			$message[1] = 'ERROR_TRANSACTIONAL_CONFLICT'
			$message[2] = 'The function attempted to use a name that is reserved for use by another transaction.'

		Case 6801
			$message[1] = 'ERROR_RM_NOT_ACTIVE'
			$message[2] = 'Transaction support within the specified file system resource manager is not started or was shutdown due to an error.'

		Case 6802
			$message[1] = 'ERROR_RM_METADATA_CORRUPT'
			$message[2] = 'The metadata of the RM has been corrupted. The RM will not function.'

		Case 6803
			$message[1] = 'ERROR_DIRECTORY_NOT_RM'
			$message[2] = 'The specified directory does not contain a resource manager.'

		Case 6805
			$message[1] = 'ERROR_TRANSACTIONS_UNSUPPORTED_REMOTE'
			$message[2] = 'The remote server or share does not support transacted file operations.'

		Case 6806
			$message[1] = 'ERROR_LOG_RESIZE_INVALID_SIZE'
			$message[2] = 'The requested log size is invalid.'

		Case 6807
			$message[1] = 'ERROR_OBJECT_NO_LONGER_EXISTS'
			$message[2] = 'The object (file, stream, link) corresponding to the handle has been deleted by a Transaction Savepoint Rollback.'

		Case 6808
			$message[1] = 'ERROR_STREAM_MINIVERSION_NOT_FOUND'
			$message[2] = 'The specified file miniversion was not found for this transacted file open.'

		Case 6809
			$message[1] = 'ERROR_STREAM_MINIVERSION_NOT_VALID'
			$message[2] = 'The specified file miniversion was found but has been invalidated. Most likely cause is a transaction savepoint rollback.'

		Case 6810
			$message[1] = 'ERROR_MINIVERSION_INACCESSIBLE_FROM_SPECIFIED_TRANSACTION'
			$message[2] = 'A miniversion may only be opened in the context of the transaction that created it.'

		Case 6811
			$message[1] = 'ERROR_CANT_OPEN_MINIVERSION_WITH_MODIFY_INTENT'
			$message[2] = 'It is not possible to open a miniversion with modify access.'

		Case 6812
			$message[1] = 'ERROR_CANT_CREATE_MORE_STREAM_MINIVERSIONS'
			$message[2] = 'It is not possible to create any more miniversions for this stream.'

		Case 6814
			$message[1] = 'ERROR_REMOTE_FILE_VERSION_MISMATCH'
			$message[2] = 'The remote server sent mismatching version number or Fid for a file opened with transactions.'

		Case 6815
			$message[1] = 'ERROR_HANDLE_NO_LONGER_VALID'
			$message[2] = 'The handle has been invalidated by a transaction. The most likely cause is the presence of memory mapping on a file or an open handle when the transaction ended or rolled back to savepoint.'

		Case 6816
			$message[1] = 'ERROR_NO_TXF_METADATA'
			$message[2] = 'There is no transaction metadata on the file.'

		Case 6817
			$message[1] = 'ERROR_LOG_CORRUPTION_DETECTED'
			$message[2] = 'The log data is corrupt.'

		Case 6818
			$message[1] = 'ERROR_CANT_RECOVER_WITH_HANDLE_OPEN'
			$message[2] = 'The file can''t be recovered because there is a handle still open on it.'

		Case 6819
			$message[1] = 'ERROR_RM_DISCONNECTED'
			$message[2] = 'The transaction outcome is unavailable because the resource manager responsible for it has disconnected.'

		Case 6820
			$message[1] = 'ERROR_ENLISTMENT_NOT_SUPERIOR'
			$message[2] = 'The request was rejected because the enlistment in question is not a superior enlistment.'

		Case 6821
			$message[1] = 'ERROR_RECOVERY_NOT_NEEDED'
			$message[2] = 'The transactional resource manager is already consistent. Recovery is not needed.'

		Case 6822
			$message[1] = 'ERROR_RM_ALREADY_STARTED'
			$message[2] = 'The transactional resource manager has already been started.'

		Case 6823
			$message[1] = 'ERROR_FILE_IDENTITY_NOT_PERSISTENT'
			$message[2] = 'The file cannot be opened transactionally, because its identity depends on the outcome of an unresolved transaction.'

		Case 6824
			$message[1] = 'ERROR_CANT_BREAK_TRANSACTIONAL_DEPENDENCY'
			$message[2] = 'The operation cannot be performed because another transaction is depending on the fact that this property will not change.'

		Case 6825
			$message[1] = 'ERROR_CANT_CROSS_RM_BOUNDARY'
			$message[2] = 'The operation would involve a single file with two transactional resource managers and is therefore not allowed.'

		Case 6826
			$message[1] = 'ERROR_TXF_DIR_NOT_EMPTY'
			$message[2] = 'The $Txf directory must be empty for this operation to succeed.'

		Case 6827
			$message[1] = 'ERROR_INDOUBT_TRANSACTIONS_EXIST'
			$message[2] = 'The operation would leave a transactional resource manager in an inconsistent state and is therefore not allowed.'

		Case 6828
			$message[1] = 'ERROR_TM_VOLATILE'
			$message[2] = 'The operation could not be completed because the transaction manager does not have a log.'

		Case 6829
			$message[1] = 'ERROR_ROLLBACK_TIMER_EXPIRED'
			$message[2] = 'A rollback could not be scheduled because a previously scheduled rollback has already executed or been queued for execution.'

		Case 6830
			$message[1] = 'ERROR_TXF_ATTRIBUTE_CORRUPT'
			$message[2] = 'The transactional metadata attribute on the file or directory is corrupt and unreadable.'

		Case 6831
			$message[1] = 'ERROR_EFS_NOT_ALLOWED_IN_TRANSACTION'
			$message[2] = 'The encryption operation could not be completed because a transaction is active.'

		Case 6832
			$message[1] = 'ERROR_TRANSACTIONAL_OPEN_NOT_ALLOWED'
			$message[2] = 'This object is not allowed to be opened in a transaction.'

		Case 6833
			$message[1] = 'ERROR_LOG_GROWTH_FAILED'
			$message[2] = 'An attempt to create space in the transactional resource manager''s log failed. The failure status has been recorded in the event log.'

		Case 6834
			$message[1] = 'ERROR_TRANSACTED_MAPPING_UNSUPPORTED_REMOTE'
			$message[2] = 'Memory mapping (creating a mapped section) a remote file under a transaction is not supported.'

		Case 6835
			$message[1] = 'ERROR_TXF_METADATA_ALREADY_PRESENT'
			$message[2] = 'Transaction metadata is already present on this file and cannot be superseded.'

		Case 6836
			$message[1] = 'ERROR_TRANSACTION_SCOPE_CALLBACKS_NOT_SET'
			$message[2] = 'A transaction scope could not be entered because the scope handler has not been initialized.'

		Case 6837
			$message[1] = 'ERROR_TRANSACTION_REQUIRED_PROMOTION'
			$message[2] = 'Promotion was required in order to allow the resource manager to enlist, but the transaction was set to disallow it.'

		Case 6838
			$message[1] = 'ERROR_CANNOT_EXECUTE_FILE_IN_TRANSACTION'
			$message[2] = 'This file is open for modification in an unresolved transaction and may be opened for execute only by a transacted reader.'

		Case 6839
			$message[1] = 'ERROR_TRANSACTIONS_NOT_FROZEN'
			$message[2] = 'The request to thaw frozen transactions was ignored because transactions had not previously been frozen.'

		Case 6840
			$message[1] = 'ERROR_TRANSACTION_FREEZE_IN_PROGRESS'
			$message[2] = 'Transactions cannot be frozen because a freeze is already in progress.'

		Case 6841
			$message[1] = 'ERROR_NOT_SNAPSHOT_VOLUME'
			$message[2] = 'The target volume is not a snapshot volume. This operation is only valid on a volume mounted as a snapshot.'

		Case 6842
			$message[1] = 'ERROR_NO_SAVEPOINT_WITH_OPEN_FILES'
			$message[2] = 'The savepoint operation failed because files are open on the transaction. This is not permitted.'

		Case 6843
			$message[1] = 'ERROR_DATA_LOST_REPAIR'
			$message[2] = 'Windows has discovered corruption in a file, and that file has since been repaired. Data loss may have occurred.'

		Case 6844
			$message[1] = 'ERROR_SPARSE_NOT_ALLOWED_IN_TRANSACTION'
			$message[2] = 'The sparse operation could not be completed because a transaction is active on the file.'

		Case 6845
			$message[1] = 'ERROR_TM_IDENTITY_MISMATCH'
			$message[2] = 'The call to create a TransactionManager object failed because the Tm Identity stored in the logfile does not match the Tm Identity that was passed in as an argument.'

		Case 6846
			$message[1] = 'ERROR_FLOATED_SECTION'
			$message[2] = 'I/O was attempted on a section object that has been floated as a result of a transaction ending. There is no valid data.'

		Case 6847
			$message[1] = 'ERROR_CANNOT_ACCEPT_TRANSACTED_WORK'
			$message[2] = 'The transactional resource manager cannot currently accept transacted work due to a transient condition such as low resources.'

		Case 6848
			$message[1] = 'ERROR_CANNOT_ABORT_TRANSACTIONS'
			$message[2] = 'The transactional resource manager had too many transactions outstanding that could not be aborted. The transactional resource manager has been shut down.'

		Case 6849
			$message[1] = 'ERROR_BAD_CLUSTERS'
			$message[2] = 'The operation could not be completed due to bad clusters on disk.'

		Case 6850
			$message[1] = 'ERROR_COMPRESSION_NOT_ALLOWED_IN_TRANSACTION'
			$message[2] = 'The compression operation could not be completed because a transaction is active on the file.'

		Case 6851
			$message[1] = 'ERROR_VOLUME_DIRTY'
			$message[2] = 'The operation could not be completed because the volume is dirty. Please run chkdsk and try again.'

		Case 6852
			$message[1] = 'ERROR_NO_LINK_TRACKING_IN_TRANSACTION'
			$message[2] = 'The link tracking operation could not be completed because a transaction is active.'

		Case 6853
			$message[1] = 'ERROR_OPERATION_NOT_SUPPORTED_IN_TRANSACTION'
			$message[2] = 'This operation cannot be performed in a transaction.'

		Case 7001
			$message[1] = 'ERROR_CTX_WINSTATION_NAME_INVALID'
			$message[2] = 'The specified session name is invalid.'

		Case 7002
			$message[1] = 'ERROR_CTX_INVALID_PD'
			$message[2] = 'The specified protocol driver is invalid.'

		Case 7003
			$message[1] = 'ERROR_CTX_PD_NOT_FOUND'
			$message[2] = 'The specified protocol driver was not found in the system path.'

		Case 7004
			$message[1] = 'ERROR_CTX_WD_NOT_FOUND'
			$message[2] = 'The specified terminal connection driver was not found in the system path.'

		Case 7005
			$message[1] = 'ERROR_CTX_CANNOT_MAKE_EVENTLOG_ENTRY'
			$message[2] = 'A registry key for event logging could not be created for this session.'

		Case 7006
			$message[1] = 'ERROR_CTX_SERVICE_NAME_COLLISION'
			$message[2] = 'A service with the same name already exists on the system.'

		Case 7007
			$message[1] = 'ERROR_CTX_CLOSE_PENDING'
			$message[2] = 'A close operation is pending on the session.'

		Case 7008
			$message[1] = 'ERROR_CTX_NO_OUTBUF'
			$message[2] = 'There are no free output buffers available.'

		Case 7009
			$message[1] = 'ERROR_CTX_MODEM_INF_NOT_FOUND'
			$message[2] = 'The MODEM.INF file was not found.'

		Case 7010
			$message[1] = 'ERROR_CTX_INVALID_MODEMNAME'
			$message[2] = 'The modem name was not found in MODEM.INF.'

		Case 7011
			$message[1] = 'ERROR_CTX_MODEM_RESPONSE_ERROR'
			$message[2] = 'The modem did not accept the command sent to it. Verify that the configured modem name matches the attached modem.'

		Case 7012
			$message[1] = 'ERROR_CTX_MODEM_RESPONSE_TIMEOUT'
			$message[2] = 'The modem did not respond to the command sent to it. Verify that the modem is properly cabled and powered on.'

		Case 7013
			$message[1] = 'ERROR_CTX_MODEM_RESPONSE_NO_CARRIER'
			$message[2] = 'Carrier detect has failed or carrier has been dropped due to disconnect.'

		Case 7014
			$message[1] = 'ERROR_CTX_MODEM_RESPONSE_NO_DIALTONE'
			$message[2] = 'Dial tone not detected within the required time. Verify that the phone cable is properly attached and functional.'

		Case 7015
			$message[1] = 'ERROR_CTX_MODEM_RESPONSE_BUSY'
			$message[2] = 'Busy signal detected at remote site on callback.'

		Case 7016
			$message[1] = 'ERROR_CTX_MODEM_RESPONSE_VOICE'
			$message[2] = 'Voice detected at remote site on callback.'

		Case 7017
			$message[1] = 'ERROR_CTX_TD_ERROR'
			$message[2] = 'Transport driver error'

		Case 7022
			$message[1] = 'ERROR_CTX_WINSTATION_NOT_FOUND'
			$message[2] = 'The specified session cannot be found.'

		Case 7023
			$message[1] = 'ERROR_CTX_WINSTATION_ALREADY_EXISTS'
			$message[2] = 'The specified session name is already in use.'

		Case 7024
			$message[1] = 'ERROR_CTX_WINSTATION_BUSY'
			$message[2] = 'The requested operation cannot be completed because the terminal connection is currently busy processing a connect, disconnect, reset, or delete operation.'

		Case 7025
			$message[1] = 'ERROR_CTX_BAD_VIDEO_MODE'
			$message[2] = 'An attempt has been made to connect to a session whose video mode is not supported by the current client.'

		Case 7035
			$message[1] = 'ERROR_CTX_GRAPHICS_INVALID'
			$message[2] = 'The application attempted to enable DOS graphics mode. DOS graphics mode is not supported.'

		Case 7037
			$message[1] = 'ERROR_CTX_LOGON_DISABLED'
			$message[2] = 'Your interactive logon privilege has been disabled. Please contact your administrator.'

		Case 7038
			$message[1] = 'ERROR_CTX_NOT_CONSOLE'
			$message[2] = 'The requested operation can be performed only on the system console. This is most often the result of a driver or system DLL requiring direct console access.'

		Case 7040
			$message[1] = 'ERROR_CTX_CLIENT_QUERY_TIMEOUT'
			$message[2] = 'The client failed to respond to the server connect message.'

		Case 7041
			$message[1] = 'ERROR_CTX_CONSOLE_DISCONNECT'
			$message[2] = 'Disconnecting the console session is not supported.'

		Case 7042
			$message[1] = 'ERROR_CTX_CONSOLE_CONNECT'
			$message[2] = 'Reconnecting a disconnected session to the console is not supported.'

		Case 7044
			$message[1] = 'ERROR_CTX_SHADOW_DENIED'
			$message[2] = 'The request to control another session remotely was denied.'

		Case 7045
			$message[1] = 'ERROR_CTX_WINSTATION_ACCESS_DENIED'
			$message[2] = 'The requested session access is denied.'

		Case 7049
			$message[1] = 'ERROR_CTX_INVALID_WD'
			$message[2] = 'The specified terminal connection driver is invalid.'

		Case 7050
			$message[1] = 'ERROR_CTX_SHADOW_INVALID'
			$message[2] = 'The requested session cannot be controlled remotely. This may be because the session is disconnected or does not currently have a user logged on.'

		Case 7051
			$message[1] = 'ERROR_CTX_SHADOW_DISABLED'
			$message[2] = 'The requested session is not configured to allow remote control.'

		Case 7052
			$message[1] = 'ERROR_CTX_CLIENT_LICENSE_IN_USE'
			$message[2] = 'Your request to connect to this Terminal Server has been rejected. Your Terminal Server client license number is currently being used by another user. Please call your system administrator to obtain a unique license number.'

		Case 7053
			$message[1] = 'ERROR_CTX_CLIENT_LICENSE_NOT_SET'
			$message[2] = 'Your request to connect to this Terminal Server has been rejected. Your Terminal Server client license number has not been entered for this copy of the Terminal Server client. Please contact your system administrator.'

		Case 7054
			$message[1] = 'ERROR_CTX_LICENSE_NOT_AVAILABLE'
			$message[2] = 'The number of connections to this computer is limited and all connections are in use right now. Try connecting later or contact your system administrator.'

		Case 7055
			$message[1] = 'ERROR_CTX_LICENSE_CLIENT_INVALID'
			$message[2] = 'The client you are using is not licensed to use this system. Your logon request is denied.'

		Case 7056
			$message[1] = 'ERROR_CTX_LICENSE_EXPIRED'
			$message[2] = 'The system license has expired. Your logon request is denied.'

		Case 7057
			$message[1] = 'ERROR_CTX_SHADOW_NOT_RUNNING'
			$message[2] = 'Remote control could not be terminated because the specified session is not currently being remotely controlled.'

		Case 7058
			$message[1] = 'ERROR_CTX_SHADOW_ENDED_BY_MODE_CHANGE'
			$message[2] = 'The remote control of the console was terminated because the display mode was changed. Changing the display mode in a remote control session is not supported.'

		Case 7059
			$message[1] = 'ERROR_ACTIVATION_COUNT_EXCEEDED'
			$message[2] = 'Activation has already been reset the maximum number of times for this installation. Your activation timer will not be cleared.'

		Case 7060
			$message[1] = 'ERROR_CTX_WINSTATIONS_DISABLED'
			$message[2] = 'Remote logins are currently disabled.'

		Case 7061
			$message[1] = 'ERROR_CTX_ENCRYPTION_LEVEL_REQUIRED'
			$message[2] = 'You do not have the proper encryption level to access this Session.'

		Case 7062
			$message[1] = 'ERROR_CTX_SESSION_IN_USE'
			$message[2] = 'The user %s\\%s is currently logged on to this computer. Only the current user or an administrator can log on to this computer.'

		Case 7063
			$message[1] = 'ERROR_CTX_NO_FORCE_LOGOFF'
			$message[2] = 'The user %s\\%s is already logged on to the console of this computer. You do not have permission to log in at this time. To resolve this issue, contact %s\\%s and have them log off.'

		Case 7064
			$message[1] = 'ERROR_CTX_ACCOUNT_RESTRICTION'
			$message[2] = 'Unable to log you on because of an account restriction.'

		Case 7065
			$message[1] = 'ERROR_RDP_PROTOCOL_ERROR'
			$message[2] = 'The RDP protocol component %2 detected an error in the protocol stream and has disconnected the client.'

		Case 7066
			$message[1] = 'ERROR_CTX_CDM_CONNECT'
			$message[2] = 'The Client Drive Mapping Service Has Connected on Terminal Connection.'

		Case 7067
			$message[1] = 'ERROR_CTX_CDM_DISCONNECT'
			$message[2] = 'The Client Drive Mapping Service Has Disconnected on Terminal Connection.'

		Case 7068
			$message[1] = 'ERROR_CTX_SECURITY_LAYER_ERROR'
			$message[2] = 'The Terminal Server security layer detected an error in the protocol stream and has disconnected the client.'

		Case 7069
			$message[1] = 'ERROR_TS_INCOMPATIBLE_SESSIONS'
			$message[2] = 'The target session is incompatible with the current session.'

		Case 8001
			$message[1] = 'FRS_ERR_INVALID_API_SEQUENCE'
			$message[2] = 'The file replication service API was called incorrectly.'

		Case 8002
			$message[1] = 'FRS_ERR_STARTING_SERVICE'
			$message[2] = 'The file replication service cannot be started.'

		Case 8003
			$message[1] = 'FRS_ERR_STOPPING_SERVICE'
			$message[2] = 'The file replication service cannot be stopped.'

		Case 8004
			$message[1] = 'FRS_ERR_INTERNAL_API'
			$message[2] = 'The file replication service API terminated the request. The event log may have more information.'

		Case 8005
			$message[1] = 'FRS_ERR_INTERNAL'
			$message[2] = 'The file replication service terminated the request. The event log may have more information.'

		Case 8006
			$message[1] = 'FRS_ERR_SERVICE_COMM'
			$message[2] = 'The file replication service cannot be contacted. The event log may have more information.'

		Case 8007
			$message[1] = 'FRS_ERR_INSUFFICIENT_PRIV'
			$message[2] = 'The file replication service cannot satisfy the request because the user has insufficient privileges. The event log may have more information.'

		Case 8008
			$message[1] = 'FRS_ERR_AUTHENTICATION'
			$message[2] = 'The file replication service cannot satisfy the request because authenticated RPC is not available. The event log may have more information.'

		Case 8009
			$message[1] = 'FRS_ERR_PARENT_INSUFFICIENT_PRIV'
			$message[2] = 'The file replication service cannot satisfy the request because the user has insufficient privileges on the domain controller. The event log may have more information.'

		Case 8010
			$message[1] = 'FRS_ERR_PARENT_AUTHENTICATION'
			$message[2] = 'The file replication service cannot satisfy the request because authenticated RPC is not available on the domain controller. The event log may have more information.'

		Case 8011
			$message[1] = 'FRS_ERR_CHILD_TO_PARENT_COMM'
			$message[2] = 'The file replication service cannot communicate with the file replication service on the domain controller. The event log may have more information.'

		Case 8012
			$message[1] = 'FRS_ERR_PARENT_TO_CHILD_COMM'
			$message[2] = 'The file replication service on the domain controller cannot communicate with the file replication service on this computer. The event log may have more information.'

		Case 8013
			$message[1] = 'FRS_ERR_SYSVOL_POPULATE'
			$message[2] = 'The file replication service cannot populate the system volume because of an internal error. The event log may have more information.'

		Case 8014
			$message[1] = 'FRS_ERR_SYSVOL_POPULATE_TIMEOUT'
			$message[2] = 'The file replication service cannot populate the system volume because of an internal timeout. The event log may have more information.'

		Case 8015
			$message[1] = 'FRS_ERR_SYSVOL_IS_BUSY'
			$message[2] = 'The file replication service cannot process the request. The system volume is busy with a previous request.'

		Case 8016
			$message[1] = 'FRS_ERR_SYSVOL_DEMOTE'
			$message[2] = 'The file replication service cannot stop replicating the system volume because of an internal error. The event log may have more information.'

		Case 8017
			$message[1] = 'FRS_ERR_INVALID_SERVICE_PARAMETER'
			$message[2] = 'The file replication service detected an invalid parameter.'

		Case 8200
			$message[1] = 'ERROR_DS_NOT_INSTALLED'
			$message[2] = 'An error occurred while installing the directory service. For more information, see the event log.'

		Case 8201
			$message[1] = 'ERROR_DS_MEMBERSHIP_EVALUATED_LOCALLY'
			$message[2] = 'The directory service evaluated group memberships locally.'

		Case 8202
			$message[1] = 'ERROR_DS_NO_ATTRIBUTE_OR_VALUE'
			$message[2] = 'The specified directory service attribute or value does not exist.'

		Case 8203
			$message[1] = 'ERROR_DS_INVALID_ATTRIBUTE_SYNTAX'
			$message[2] = 'The attribute syntax specified to the directory service is invalid.'

		Case 8204
			$message[1] = 'ERROR_DS_ATTRIBUTE_TYPE_UNDEFINED'
			$message[2] = 'The attribute type specified to the directory service is not defined.'

		Case 8205
			$message[1] = 'ERROR_DS_ATTRIBUTE_OR_VALUE_EXISTS'
			$message[2] = 'The specified directory service attribute or value already exists.'

		Case 8206
			$message[1] = 'ERROR_DS_BUSY'
			$message[2] = 'The directory service is busy.'

		Case 8207
			$message[1] = 'ERROR_DS_UNAVAILABLE'
			$message[2] = 'The directory service is unavailable.'

		Case 8208
			$message[1] = 'ERROR_DS_NO_RIDS_ALLOCATED'
			$message[2] = 'The directory service was unable to allocate a relative identifier.'

		Case 8209
			$message[1] = 'ERROR_DS_NO_MORE_RIDS'
			$message[2] = 'The directory service has exhausted the pool of relative identifiers.'

		Case 8210
			$message[1] = 'ERROR_DS_INCORRECT_ROLE_OWNER'
			$message[2] = 'The requested operation could not be performed because the directory service is not the master for that type of operation.'

		Case 8211
			$message[1] = 'ERROR_DS_RIDMGR_INIT_ERROR'
			$message[2] = 'The directory service was unable to initialize the subsystem that allocates relative identifiers.'

		Case 8212
			$message[1] = 'ERROR_DS_OBJ_CLASS_VIOLATION'
			$message[2] = 'The requested operation did not satisfy one or more constraints associated with the class of the object.'

		Case 8213
			$message[1] = 'ERROR_DS_CANT_ON_NON_LEAF'
			$message[2] = 'The directory service can perform the requested operation only on a leaf object.'

		Case 8214
			$message[1] = 'ERROR_DS_CANT_ON_RDN'
			$message[2] = 'The directory service cannot perform the requested operation on the RDN attribute of an object.'

		Case 8215
			$message[1] = 'ERROR_DS_CANT_MOD_OBJ_CLASS'
			$message[2] = 'The directory service detected an attempt to modify the object class of an object.'

		Case 8216
			$message[1] = 'ERROR_DS_CROSS_DOM_MOVE_ERROR'
			$message[2] = 'The requested cross-domain move operation could not be performed.'

		Case 8217
			$message[1] = 'ERROR_DS_GC_NOT_AVAILABLE'
			$message[2] = 'Unable to contact the global catalog server.'

		Case 8218
			$message[1] = 'ERROR_SHARED_POLICY'
			$message[2] = 'The policy object is shared and can only be modified at the root.'

		Case 8219
			$message[1] = 'ERROR_POLICY_OBJECT_NOT_FOUND'
			$message[2] = 'The policy object does not exist.'

		Case 8220
			$message[1] = 'ERROR_POLICY_ONLY_IN_DS'
			$message[2] = 'The requested policy information is only in the directory service.'

		Case 8221
			$message[1] = 'ERROR_PROMOTION_ACTIVE'
			$message[2] = 'A domain controller promotion is currently active.'

		Case 8222
			$message[1] = 'ERROR_NO_PROMOTION_ACTIVE'
			$message[2] = 'A domain controller promotion is not currently active'

		Case 8224
			$message[1] = 'ERROR_DS_OPERATIONS_ERROR'
			$message[2] = 'An operations error occurred.'

		Case 8225
			$message[1] = 'ERROR_DS_PROTOCOL_ERROR'
			$message[2] = 'A protocol error occurred.'

		Case 8226
			$message[1] = 'ERROR_DS_TIMELIMIT_EXCEEDED'
			$message[2] = 'The time limit for this request was exceeded.'

		Case 8227
			$message[1] = 'ERROR_DS_SIZELIMIT_EXCEEDED'
			$message[2] = 'The size limit for this request was exceeded.'

		Case 8228
			$message[1] = 'ERROR_DS_ADMIN_LIMIT_EXCEEDED'
			$message[2] = 'The administrative limit for this request was exceeded.'

		Case 8229
			$message[1] = 'ERROR_DS_COMPARE_FALSE'
			$message[2] = 'The compare response was false.'

		Case 8230
			$message[1] = 'ERROR_DS_COMPARE_TRUE'
			$message[2] = 'The compare response was true.'

		Case 8231
			$message[1] = 'ERROR_DS_AUTH_METHOD_NOT_SUPPORTED'
			$message[2] = 'The requested authentication method is not supported by the server.'

		Case 8232
			$message[1] = 'ERROR_DS_STRONG_AUTH_REQUIRED'
			$message[2] = 'A more secure authentication method is required for this server.'

		Case 8233
			$message[1] = 'ERROR_DS_INAPPROPRIATE_AUTH'
			$message[2] = 'Inappropriate authentication.'

		Case 8234
			$message[1] = 'ERROR_DS_AUTH_UNKNOWN'
			$message[2] = 'The authentication mechanism is unknown.'

		Case 8235
			$message[1] = 'ERROR_DS_REFERRAL'
			$message[2] = 'A referral was returned from the server.'

		Case 8236
			$message[1] = 'ERROR_DS_UNAVAILABLE_CRIT_EXTENSION'
			$message[2] = 'The server does not support the requested critical extension.'

		Case 8237
			$message[1] = 'ERROR_DS_CONFIDENTIALITY_REQUIRED'
			$message[2] = 'This request requires a secure connection.'

		Case 8238
			$message[1] = 'ERROR_DS_INAPPROPRIATE_MATCHING'
			$message[2] = 'Inappropriate matching.'

		Case 8239
			$message[1] = 'ERROR_DS_CONSTRAINT_VIOLATION'
			$message[2] = 'A constraint violation occurred.'

		Case 8240
			$message[1] = 'ERROR_DS_NO_SUCH_OBJECT'
			$message[2] = 'There is no such object on the server.'

		Case 8241
			$message[1] = 'ERROR_DS_ALIAS_PROBLEM'
			$message[2] = 'There is an alias problem.'

		Case 8242
			$message[1] = 'ERROR_DS_INVALID_DN_SYNTAX'
			$message[2] = 'An invalid dn syntax has been specified.'

		Case 8243
			$message[1] = 'ERROR_DS_IS_LEAF'
			$message[2] = 'The object is a leaf object.'

		Case 8244
			$message[1] = 'ERROR_DS_ALIAS_DEREF_PROBLEM'
			$message[2] = 'There is an alias dereferencing problem.'

		Case 8245
			$message[1] = 'ERROR_DS_UNWILLING_TO_PERFORM'
			$message[2] = 'The server is unwilling to process the request.'

		Case 8246
			$message[1] = 'ERROR_DS_LOOP_DETECT'
			$message[2] = 'A loop has been detected.'

		Case 8247
			$message[1] = 'ERROR_DS_NAMING_VIOLATION'
			$message[2] = 'There is a naming violation.'

		Case 8248
			$message[1] = 'ERROR_DS_OBJECT_RESULTS_TOO_LARGE'
			$message[2] = 'The result set is too large.'

		Case 8249
			$message[1] = 'ERROR_DS_AFFECTS_MULTIPLE_DSAS'
			$message[2] = 'The operation affects multiple DSAs'

		Case 8250
			$message[1] = 'ERROR_DS_SERVER_DOWN'
			$message[2] = 'The server is not operational.'

		Case 8251
			$message[1] = 'ERROR_DS_LOCAL_ERROR'
			$message[2] = 'A local error has occurred.'

		Case 8252
			$message[1] = 'ERROR_DS_ENCODING_ERROR'
			$message[2] = 'An encoding error has occurred.'

		Case 8253
			$message[1] = 'ERROR_DS_DECODING_ERROR'
			$message[2] = 'A decoding error has occurred.'

		Case 8254
			$message[1] = 'ERROR_DS_FILTER_UNKNOWN'
			$message[2] = 'The search filter cannot be recognized.'

		Case 8255
			$message[1] = 'ERROR_DS_PARAM_ERROR'
			$message[2] = 'One or more parameters are illegal.'

		Case 8256
			$message[1] = 'ERROR_DS_NOT_SUPPORTED'
			$message[2] = 'The specified method is not supported.'

		Case 8257
			$message[1] = 'ERROR_DS_NO_RESULTS_RETURNED'
			$message[2] = 'No results were returned.'

		Case 8258
			$message[1] = 'ERROR_DS_CONTROL_NOT_FOUND'
			$message[2] = 'The specified control is not supported by the server.'

		Case 8259
			$message[1] = 'ERROR_DS_CLIENT_LOOP'
			$message[2] = 'A referral loop was detected by the client.'

		Case 8260
			$message[1] = 'ERROR_DS_REFERRAL_LIMIT_EXCEEDED'
			$message[2] = 'The preset referral limit was exceeded.'

		Case 8261
			$message[1] = 'ERROR_DS_SORT_CONTROL_MISSING'
			$message[2] = 'The search requires a SORT control.'

		Case 8262
			$message[1] = 'ERROR_DS_OFFSET_RANGE_ERROR'
			$message[2] = 'The search results exceed the offset range specified.'

		Case 8301
			$message[1] = 'ERROR_DS_ROOT_MUST_BE_NC'
			$message[2] = 'The root object must be the head of a naming context. The root object cannot have an instantiated parent.'

		Case 8302
			$message[1] = 'ERROR_DS_ADD_REPLICA_INHIBITED'
			$message[2] = 'The add replica operation cannot be performed. The naming context must be writeable in order to create the replica.'

		Case 8303
			$message[1] = 'ERROR_DS_ATT_NOT_DEF_IN_SCHEMA'
			$message[2] = 'A reference to an attribute that is not defined in the schema occurred.'

		Case 8304
			$message[1] = 'ERROR_DS_MAX_OBJ_SIZE_EXCEEDED'
			$message[2] = 'The maximum size of an object has been exceeded.'

		Case 8305
			$message[1] = 'ERROR_DS_OBJ_STRING_NAME_EXISTS'
			$message[2] = 'An attempt was made to add an object to the directory with a name that is already in use.'

		Case 8306
			$message[1] = 'ERROR_DS_NO_RDN_DEFINED_IN_SCHEMA'
			$message[2] = 'An attempt was made to add an object of a class that does not have an RDN defined in the schema.'

		Case 8307
			$message[1] = 'ERROR_DS_RDN_DOESNT_MATCH_SCHEMA'
			$message[2] = 'An attempt was made to add an object using an RDN that is not the RDN defined in the schema.'

		Case 8308
			$message[1] = 'ERROR_DS_NO_REQUESTED_ATTS_FOUND'
			$message[2] = 'None of the requested attributes were found on the objects.'

		Case 8309
			$message[1] = 'ERROR_DS_USER_BUFFER_TO_SMALL'
			$message[2] = 'The user buffer is too small.'

		Case 8310
			$message[1] = 'ERROR_DS_ATT_IS_NOT_ON_OBJ'
			$message[2] = 'The attribute specified in the operation is not present on the object.'

		Case 8311
			$message[1] = 'ERROR_DS_ILLEGAL_MOD_OPERATION'
			$message[2] = 'Illegal modify operation. Some aspect of the modification is not permitted.'

		Case 8312
			$message[1] = 'ERROR_DS_OBJ_TOO_LARGE'
			$message[2] = 'The specified object is too large.'

		Case 8313
			$message[1] = 'ERROR_DS_BAD_INSTANCE_TYPE'
			$message[2] = 'The specified instance type is not valid.'

		Case 8314
			$message[1] = 'ERROR_DS_MASTERDSA_REQUIRED'
			$message[2] = 'The operation must be performed at a master DSA.'

		Case 8315
			$message[1] = 'ERROR_DS_OBJECT_CLASS_REQUIRED'
			$message[2] = 'The object class attribute must be specified.'

		Case 8316
			$message[1] = 'ERROR_DS_MISSING_REQUIRED_ATT'
			$message[2] = 'A required attribute is missing.'

		Case 8317
			$message[1] = 'ERROR_DS_ATT_NOT_DEF_FOR_CLASS'
			$message[2] = 'An attempt was made to modify an object to include an attribute that is not legal for its class.'

		Case 8318
			$message[1] = 'ERROR_DS_ATT_ALREADY_EXISTS'
			$message[2] = 'The specified attribute is already present on the object.'

		Case 8320
			$message[1] = 'ERROR_DS_CANT_ADD_ATT_VALUES'
			$message[2] = 'The specified attribute is not present, or has no values.'

		Case 8321
			$message[1] = 'ERROR_DS_SINGLE_VALUE_CONSTRAINT'
			$message[2] = 'Multiple values were specified for an attribute that can have only one value.'

		Case 8322
			$message[1] = 'ERROR_DS_RANGE_CONSTRAINT'
			$message[2] = 'A value for the attribute was not in the acceptable range of values.'

		Case 8323
			$message[1] = 'ERROR_DS_ATT_VAL_ALREADY_EXISTS'
			$message[2] = 'The specified value already exists.'

		Case 8324
			$message[1] = 'ERROR_DS_CANT_REM_MISSING_ATT'
			$message[2] = 'The attribute cannot be removed because it is not present on the object.'

		Case 8325
			$message[1] = 'ERROR_DS_CANT_REM_MISSING_ATT_VAL'
			$message[2] = 'The attribute value cannot be removed because it is not present on the object.'

		Case 8326
			$message[1] = 'ERROR_DS_ROOT_CANT_BE_SUBREF'
			$message[2] = 'The specified root object cannot be a subref.'

		Case 8327
			$message[1] = 'ERROR_DS_NO_CHAINING'
			$message[2] = 'Chaining is not permitted.'

		Case 8328
			$message[1] = 'ERROR_DS_NO_CHAINED_EVAL'
			$message[2] = 'Chained evaluation is not permitted.'

		Case 8329
			$message[1] = 'ERROR_DS_NO_PARENT_OBJECT'
			$message[2] = 'The operation could not be performed because the object''s parent is either uninstantiated or deleted.'

		Case 8330
			$message[1] = 'ERROR_DS_PARENT_IS_AN_ALIAS'
			$message[2] = 'Having a parent that is an alias is not permitted. Aliases are leaf objects.'

		Case 8331
			$message[1] = 'ERROR_DS_CANT_MIX_MASTER_AND_REPS'
			$message[2] = 'The object and parent must be of the same type, either both masters or both replicas.'

		Case 8332
			$message[1] = 'ERROR_DS_CHILDREN_EXIST'
			$message[2] = 'The operation cannot be performed because child objects exist. This operation can only be performed on a leaf object.'

		Case 8333
			$message[1] = 'ERROR_DS_OBJ_NOT_FOUND'
			$message[2] = 'Directory object not found.'

		Case 8334
			$message[1] = 'ERROR_DS_ALIASED_OBJ_MISSING'
			$message[2] = 'The aliased object is missing.'

		Case 8335
			$message[1] = 'ERROR_DS_BAD_NAME_SYNTAX'
			$message[2] = 'The object name has bad syntax.'

		Case 8336
			$message[1] = 'ERROR_DS_ALIAS_POINTS_TO_ALIAS'
			$message[2] = 'It is not permitted for an alias to refer to another alias.'

		Case 8337
			$message[1] = 'ERROR_DS_CANT_DEREF_ALIAS'
			$message[2] = 'The alias cannot be dereferenced.'

		Case 8338
			$message[1] = 'ERROR_DS_OUT_OF_SCOPE'
			$message[2] = 'The operation is out of scope.'

		Case 8339
			$message[1] = 'ERROR_DS_OBJECT_BEING_REMOVED'
			$message[2] = 'The operation cannot continue because the object is in the process of being removed.'

		Case 8340
			$message[1] = 'ERROR_DS_CANT_DELETE_DSA_OBJ'
			$message[2] = 'The DSA object cannot be deleted.'

		Case 8341
			$message[1] = 'ERROR_DS_GENERIC_ERROR'
			$message[2] = 'A directory service error has occurred.'

		Case 8342
			$message[1] = 'ERROR_DS_DSA_MUST_BE_INT_MASTER'
			$message[2] = 'The operation can only be performed on an internal master DSA object.'

		Case 8343
			$message[1] = 'ERROR_DS_CLASS_NOT_DSA'
			$message[2] = 'The object must be of class DSA.'

		Case 8344
			$message[1] = 'ERROR_DS_INSUFF_ACCESS_RIGHTS'
			$message[2] = 'Insufficient access rights to perform the operation.'

		Case 8345
			$message[1] = 'ERROR_DS_ILLEGAL_SUPERIOR'
			$message[2] = 'The object cannot be added because the parent is not on the list of possible superiors.'

		Case 8346
			$message[1] = 'ERROR_DS_ATTRIBUTE_OWNED_BY_SAM'
			$message[2] = 'Access to the attribute is not permitted because the attribute is owned by the Security Accounts Manager (SAM).'

		Case 8347
			$message[1] = 'ERROR_DS_NAME_TOO_MANY_PARTS'
			$message[2] = 'The name has too many parts.'

		Case 8348
			$message[1] = 'ERROR_DS_NAME_TOO_LONG'
			$message[2] = 'The name is too long.'

		Case 8349
			$message[1] = 'ERROR_DS_NAME_VALUE_TOO_LONG'
			$message[2] = 'The name value is too long.'

		Case 8350
			$message[1] = 'ERROR_DS_NAME_UNPARSEABLE'
			$message[2] = 'The directory service encountered an error parsing a name.'

		Case 8351
			$message[1] = 'ERROR_DS_NAME_TYPE_UNKNOWN'
			$message[2] = 'The directory service cannot get the attribute type for a name.'

		Case 8352
			$message[1] = 'ERROR_DS_NOT_AN_OBJECT'
			$message[2] = 'The name does not identify an object; the name identifies a phantom.'

		Case 8353
			$message[1] = 'ERROR_DS_SEC_DESC_TOO_SHORT'
			$message[2] = 'The security descriptor is too short.'

		Case 8354
			$message[1] = 'ERROR_DS_SEC_DESC_INVALID'
			$message[2] = 'The security descriptor is invalid.'

		Case 8355
			$message[1] = 'ERROR_DS_NO_DELETED_NAME'
			$message[2] = 'Failed to create name for deleted object.'

		Case 8356
			$message[1] = 'ERROR_DS_SUBREF_MUST_HAVE_PARENT'
			$message[2] = 'The parent of a new subref must exist.'

		Case 8357
			$message[1] = 'ERROR_DS_NCNAME_MUST_BE_NC'
			$message[2] = 'The object must be a naming context.'

		Case 8358
			$message[1] = 'ERROR_DS_CANT_ADD_SYSTEM_ONLY'
			$message[2] = 'It is not permitted to add an attribute which is owned by the system.'

		Case 8359
			$message[1] = 'ERROR_DS_CLASS_MUST_BE_CONCRETE'
			$message[2] = 'The class of the object must be structural; you cannot instantiate an abstract class.'

		Case 8360
			$message[1] = 'ERROR_DS_INVALID_DMD'
			$message[2] = 'The schema object could not be found.'

		Case 8361
			$message[1] = 'ERROR_DS_OBJ_GUID_EXISTS'
			$message[2] = 'A local object with this GUID (dead or alive) already exists.'

		Case 8362
			$message[1] = 'ERROR_DS_NOT_ON_BACKLINK'
			$message[2] = 'The operation cannot be performed on a back link.'

		Case 8363
			$message[1] = 'ERROR_DS_NO_CROSSREF_FOR_NC'
			$message[2] = 'The cross reference for the specified naming context could not be found.'

		Case 8364
			$message[1] = 'ERROR_DS_SHUTTING_DOWN'
			$message[2] = 'The operation could not be performed because the directory service is shutting down.'

		Case 8365
			$message[1] = 'ERROR_DS_UNKNOWN_OPERATION'
			$message[2] = 'The directory service request is invalid.'

		Case 8366
			$message[1] = 'ERROR_DS_INVALID_ROLE_OWNER'
			$message[2] = 'The role owner attribute could not be read.'

		Case 8367
			$message[1] = 'ERROR_DS_COULDNT_CONTACT_FSMO'
			$message[2] = 'The requested FSMO operation failed. The current FSMO holder could not be contacted.'

		Case 8368
			$message[1] = 'ERROR_DS_CROSS_NC_DN_RENAME'
			$message[2] = 'Modification of a DN across a naming context is not permitted.'

		Case 8369
			$message[1] = 'ERROR_DS_CANT_MOD_SYSTEM_ONLY'
			$message[2] = 'The attribute cannot be modified because it is owned by the system.'

		Case 8370
			$message[1] = 'ERROR_DS_REPLICATOR_ONLY'
			$message[2] = 'Only the replicator can perform this function.'

		Case 8371
			$message[1] = 'ERROR_DS_OBJ_CLASS_NOT_DEFINED'
			$message[2] = 'The specified class is not defined.'

		Case 8372
			$message[1] = 'ERROR_DS_OBJ_CLASS_NOT_SUBCLASS'
			$message[2] = 'The specified class is not a subclass.'

		Case 8373
			$message[1] = 'ERROR_DS_NAME_REFERENCE_INVALID'
			$message[2] = 'The name reference is invalid.'

		Case 8374
			$message[1] = 'ERROR_DS_CROSS_REF_EXISTS'
			$message[2] = 'A cross reference already exists.'

		Case 8375
			$message[1] = 'ERROR_DS_CANT_DEL_MASTER_CROSSREF'
			$message[2] = 'It is not permitted to delete a master cross reference.'

		Case 8376
			$message[1] = 'ERROR_DS_SUBTREE_NOTIFY_NOT_NC_HEAD'
			$message[2] = 'Subtree notifications are only supported on NC heads.'

		Case 8377
			$message[1] = 'ERROR_DS_NOTIFY_FILTER_TOO_COMPLEX'
			$message[2] = 'Notification filter is too complex.'

		Case 8378
			$message[1] = 'ERROR_DS_DUP_RDN'
			$message[2] = 'Schema update failed: duplicate RDN.'

		Case 8379
			$message[1] = 'ERROR_DS_DUP_OID'
			$message[2] = 'Schema update failed: duplicate OID.'

		Case 8380
			$message[1] = 'ERROR_DS_DUP_MAPI_ID'
			$message[2] = 'Schema update failed: duplicate MAPI identifier.'

		Case 8381
			$message[1] = 'ERROR_DS_DUP_SCHEMA_ID_GUID'
			$message[2] = 'Schema update failed: duplicate schema-id GUID.'

		Case 8382
			$message[1] = 'ERROR_DS_DUP_LDAP_DISPLAY_NAME'
			$message[2] = 'Schema update failed: duplicate LDAP display name.'

		Case 8383
			$message[1] = 'ERROR_DS_SEMANTIC_ATT_TEST'
			$message[2] = 'Schema update failed: range-lower less than range upper.'

		Case 8384
			$message[1] = 'ERROR_DS_SYNTAX_MISMATCH'
			$message[2] = 'Schema update failed: syntax mismatch.'

		Case 8385
			$message[1] = 'ERROR_DS_EXISTS_IN_MUST_HAVE'
			$message[2] = 'Schema deletion failed: attribute is used in must-contain.'

		Case 8386
			$message[1] = 'ERROR_DS_EXISTS_IN_MAY_HAVE'
			$message[2] = 'Schema deletion failed: attribute is used in may-contain.'

		Case 8387
			$message[1] = 'ERROR_DS_NONEXISTENT_MAY_HAVE'
			$message[2] = 'Schema update failed: attribute in may-contain does not exist.'

		Case 8388
			$message[1] = 'ERROR_DS_NONEXISTENT_MUST_HAVE'
			$message[2] = 'Schema update failed: attribute in must-contain does not exist.'

		Case 8389
			$message[1] = 'ERROR_DS_AUX_CLS_TEST_FAIL'
			$message[2] = 'Schema update failed: class in aux-class list does not exist or is not an auxiliary class.'

		Case 8390
			$message[1] = 'ERROR_DS_NONEXISTENT_POSS_SUP'
			$message[2] = 'Schema update failed: class in poss-superiors does not exist.'

		Case 8391
			$message[1] = 'ERROR_DS_SUB_CLS_TEST_FAIL'
			$message[2] = 'Schema update failed: class in subclassof list does not exist or does not satisfy hierarchy rules.'

		Case 8392
			$message[1] = 'ERROR_DS_BAD_RDN_ATT_ID_SYNTAX'
			$message[2] = 'Schema update failed: Rdn-Att-Id has wrong syntax.'

		Case 8393
			$message[1] = 'ERROR_DS_EXISTS_IN_AUX_CLS'
			$message[2] = 'Schema deletion failed: class is used as auxiliary class.'

		Case 8394
			$message[1] = 'ERROR_DS_EXISTS_IN_SUB_CLS'
			$message[2] = 'Schema deletion failed: class is used as sub class.'

		Case 8395
			$message[1] = 'ERROR_DS_EXISTS_IN_POSS_SUP'
			$message[2] = 'Schema deletion failed: class is used as poss superior.'

		Case 8396
			$message[1] = 'ERROR_DS_RECALCSCHEMA_FAILED'
			$message[2] = 'Schema update failed in recalculating validation cache.'

		Case 8397
			$message[1] = 'ERROR_DS_TREE_DELETE_NOT_FINISHED'
			$message[2] = 'The tree deletion is not finished. The request must be made again to continue deleting the tree.'

		Case 8398
			$message[1] = 'ERROR_DS_CANT_DELETE'
			$message[2] = 'The requested delete operation could not be performed.'

		Case 8399
			$message[1] = 'ERROR_DS_ATT_SCHEMA_REQ_ID'
			$message[2] = 'Cannot read the governs class identifier for the schema record.'

		Case 8400
			$message[1] = 'ERROR_DS_BAD_ATT_SCHEMA_SYNTAX'
			$message[2] = 'The attribute schema has bad syntax.'

		Case 8401
			$message[1] = 'ERROR_DS_CANT_CACHE_ATT'
			$message[2] = 'The attribute could not be cached.'

		Case 8402
			$message[1] = 'ERROR_DS_CANT_CACHE_CLASS'
			$message[2] = 'The class could not be cached.'

		Case 8403
			$message[1] = 'ERROR_DS_CANT_REMOVE_ATT_CACHE'
			$message[2] = 'The attribute could not be removed from the cache.'

		Case 8404
			$message[1] = 'ERROR_DS_CANT_REMOVE_CLASS_CACHE'
			$message[2] = 'The class could not be removed from the cache.'

		Case 8405
			$message[1] = 'ERROR_DS_CANT_RETRIEVE_DN'
			$message[2] = 'The distinguished name attribute could not be read.'

		Case 8406
			$message[1] = 'ERROR_DS_MISSING_SUPREF'
			$message[2] = 'No superior reference has been configured for the directory service. The directory service is therefore unable to issue referrals to objects outside this forest.'

		Case 8407
			$message[1] = 'ERROR_DS_CANT_RETRIEVE_INSTANCE'
			$message[2] = 'The instance type attribute could not be retrieved.'

		Case 8408
			$message[1] = 'ERROR_DS_CODE_INCONSISTENCY'
			$message[2] = 'An internal error has occurred.'

		Case 8409
			$message[1] = 'ERROR_DS_DATABASE_ERROR'
			$message[2] = 'A database error has occurred.'

		Case 8410
			$message[1] = 'ERROR_DS_GOVERNSID_MISSING'
			$message[2] = 'The attribute GOVERNSID is missing.'

		Case 8411
			$message[1] = 'ERROR_DS_MISSING_EXPECTED_ATT'
			$message[2] = 'An expected attribute is missing.'

		Case 8412
			$message[1] = 'ERROR_DS_NCNAME_MISSING_CR_REF'
			$message[2] = 'The specified naming context is missing a cross reference.'

		Case 8413
			$message[1] = 'ERROR_DS_SECURITY_CHECKING_ERROR'
			$message[2] = 'A security checking error has occurred.'

		Case 8414
			$message[1] = 'ERROR_DS_SCHEMA_NOT_LOADED'
			$message[2] = 'The schema is not loaded.'

		Case 8415
			$message[1] = 'ERROR_DS_SCHEMA_ALLOC_FAILED'
			$message[2] = 'Schema allocation failed. Please check if the machine is running low on memory.'

		Case 8416
			$message[1] = 'ERROR_DS_ATT_SCHEMA_REQ_SYNTAX'
			$message[2] = 'Failed to obtain the required syntax for the attribute schema.'

		Case 8417
			$message[1] = 'ERROR_DS_GCVERIFY_ERROR'
			$message[2] = 'The global catalog verification failed. The global catalog is not available or does not support the operation. Some part of the directory is currently not available.'

		Case 8418
			$message[1] = 'ERROR_DS_DRA_SCHEMA_MISMATCH'
			$message[2] = 'The replication operation failed because of a schema mismatch between the servers involved.'

		Case 8419
			$message[1] = 'ERROR_DS_CANT_FIND_DSA_OBJ'
			$message[2] = 'The DSA object could not be found.'

		Case 8420
			$message[1] = 'ERROR_DS_CANT_FIND_EXPECTED_NC'
			$message[2] = 'The naming context could not be found.'

		Case 8421
			$message[1] = 'ERROR_DS_CANT_FIND_NC_IN_CACHE'
			$message[2] = 'The naming context could not be found in the cache.'

		Case 8422
			$message[1] = 'ERROR_DS_CANT_RETRIEVE_CHILD'
			$message[2] = 'The child object could not be retrieved.'

		Case 8423
			$message[1] = 'ERROR_DS_SECURITY_ILLEGAL_MODIFY'
			$message[2] = 'The modification was not permitted for security reasons.'

		Case 8424
			$message[1] = 'ERROR_DS_CANT_REPLACE_HIDDEN_REC'
			$message[2] = 'The operation cannot replace the hidden record.'

		Case 8425
			$message[1] = 'ERROR_DS_BAD_HIERARCHY_FILE'
			$message[2] = 'The hierarchy file is invalid.'

		Case 8426
			$message[1] = 'ERROR_DS_BUILD_HIERARCHY_TABLE_FAILED'
			$message[2] = 'The attempt to build the hierarchy table failed.'

		Case 8427
			$message[1] = 'ERROR_DS_CONFIG_PARAM_MISSING'
			$message[2] = 'The directory configuration parameter is missing from the registry.'

		Case 8428
			$message[1] = 'ERROR_DS_COUNTING_AB_INDICES_FAILED'
			$message[2] = 'The attempt to count the address book indices failed.'

		Case 8429
			$message[1] = 'ERROR_DS_HIERARCHY_TABLE_MALLOC_FAILED'
			$message[2] = 'The allocation of the hierarchy table failed.'

		Case 8430
			$message[1] = 'ERROR_DS_INTERNAL_FAILURE'
			$message[2] = 'The directory service encountered an internal failure.'

		Case 8431
			$message[1] = 'ERROR_DS_UNKNOWN_ERROR'
			$message[2] = 'The directory service encountered an unknown failure.'

		Case 8432
			$message[1] = 'ERROR_DS_ROOT_REQUIRES_CLASS_TOP'
			$message[2] = 'A root object requires a class of ''top''.'

		Case 8433
			$message[1] = 'ERROR_DS_REFUSING_FSMO_ROLES'
			$message[2] = 'This directory server is shutting down, and cannot take ownership of new floating single-master operation roles.'

		Case 8434
			$message[1] = 'ERROR_DS_MISSING_FSMO_SETTINGS'
			$message[2] = 'The directory service is missing mandatory configuration information, and is unable to determine the ownership of floating single-master operation roles.'

		Case 8435
			$message[1] = 'ERROR_DS_UNABLE_TO_SURRENDER_ROLES'
			$message[2] = 'The directory service was unable to transfer ownership of one or more floating single-master operation roles to other servers.'

		Case 8436
			$message[1] = 'ERROR_DS_DRA_GENERIC'
			$message[2] = 'The replication operation failed.'

		Case 8437
			$message[1] = 'ERROR_DS_DRA_INVALID_PARAMETER'
			$message[2] = 'An invalid parameter was specified for this replication operation.'

		Case 8438
			$message[1] = 'ERROR_DS_DRA_BUSY'
			$message[2] = 'The directory service is too busy to complete the replication operation at this time.'

		Case 8439
			$message[1] = 'ERROR_DS_DRA_BAD_DN'
			$message[2] = 'The distinguished name specified for this replication operation is invalid.'

		Case 8440
			$message[1] = 'ERROR_DS_DRA_BAD_NC'
			$message[2] = 'The naming context specified for this replication operation is invalid.'

		Case 8441
			$message[1] = 'ERROR_DS_DRA_DN_EXISTS'
			$message[2] = 'The distinguished name specified for this replication operation already exists.'

		Case 8442
			$message[1] = 'ERROR_DS_DRA_INTERNAL_ERROR'
			$message[2] = 'The replication system encountered an internal error.'

		Case 8443
			$message[1] = 'ERROR_DS_DRA_INCONSISTENT_DIT'
			$message[2] = 'The replication operation encountered a database inconsistency.'

		Case 8444
			$message[1] = 'ERROR_DS_DRA_CONNECTION_FAILED'
			$message[2] = 'The server specified for this replication operation could not be contacted.'

		Case 8445
			$message[1] = 'ERROR_DS_DRA_BAD_INSTANCE_TYPE'
			$message[2] = 'The replication operation encountered an object with an invalid instance type.'

		Case 8446
			$message[1] = 'ERROR_DS_DRA_OUT_OF_MEM'
			$message[2] = 'The replication operation failed to allocate memory.'

		Case 8447
			$message[1] = 'ERROR_DS_DRA_MAIL_PROBLEM'
			$message[2] = 'The replication operation encountered an error with the mail system.'

		Case 8448
			$message[1] = 'ERROR_DS_DRA_REF_ALREADY_EXISTS'
			$message[2] = 'The replication reference information for the target server already exists.'

		Case 8449
			$message[1] = 'ERROR_DS_DRA_REF_NOT_FOUND'
			$message[2] = 'The replication reference information for the target server does not exist.'

		Case 8450
			$message[1] = 'ERROR_DS_DRA_OBJ_IS_REP_SOURCE'
			$message[2] = 'The naming context cannot be removed because it is replicated to another server.'

		Case 8451
			$message[1] = 'ERROR_DS_DRA_DB_ERROR'
			$message[2] = 'The replication operation encountered a database error.'

		Case 8452
			$message[1] = 'ERROR_DS_DRA_NO_REPLICA'
			$message[2] = 'The naming context is in the process of being removed or is not replicated from the specified server.'

		Case 8453
			$message[1] = 'ERROR_DS_DRA_ACCESS_DENIED'
			$message[2] = 'Replication access was denied.'

		Case 8454
			$message[1] = 'ERROR_DS_DRA_NOT_SUPPORTED'
			$message[2] = 'The requested operation is not supported by this version of the directory service.'

		Case 8455
			$message[1] = 'ERROR_DS_DRA_RPC_CANCELLED'
			$message[2] = 'The replication remote procedure call was canceled.'

		Case 8456
			$message[1] = 'ERROR_DS_DRA_SOURCE_DISABLED'
			$message[2] = 'The source server is currently rejecting replication requests.'

		Case 8457
			$message[1] = 'ERROR_DS_DRA_SINK_DISABLED'
			$message[2] = 'The destination server is currently rejecting replication requests.'

		Case 8458
			$message[1] = 'ERROR_DS_DRA_NAME_COLLISION'
			$message[2] = 'The replication operation failed due to a collision of object names.'

		Case 8459
			$message[1] = 'ERROR_DS_DRA_SOURCE_REINSTALLED'
			$message[2] = 'The replication source has been reinstalled.'

		Case 8460
			$message[1] = 'ERROR_DS_DRA_MISSING_PARENT'
			$message[2] = 'The replication operation failed because a required parent object is missing.'

		Case 8461
			$message[1] = 'ERROR_DS_DRA_PREEMPTED'
			$message[2] = 'The replication operation was preempted.'

		Case 8462
			$message[1] = 'ERROR_DS_DRA_ABANDON_SYNC'
			$message[2] = 'The replication synchronization attempt was abandoned because of a lack of updates.'

		Case 8463
			$message[1] = 'ERROR_DS_DRA_SHUTDOWN'
			$message[2] = 'The replication operation was terminated because the system is shutting down.'

		Case 8464
			$message[1] = 'ERROR_DS_DRA_INCOMPATIBLE_PARTIAL_SET'
			$message[2] = 'Synchronization attempt failed because the destination DC is currently waiting to synchronize new partial attributes from source. This condition is normal if a recent schema change modified the partial attribute set. The destination partial attribute set is not a subset of source partial attribute set.'

		Case 8465
			$message[1] = 'ERROR_DS_DRA_SOURCE_IS_PARTIAL_REPLICA'
			$message[2] = 'The replication synchronization attempt failed because a master replica attempted to sync from a partial replica.'

		Case 8466
			$message[1] = 'ERROR_DS_DRA_EXTN_CONNECTION_FAILED'
			$message[2] = 'The server specified for this replication operation was contacted, but that server was unable to contact an additional server needed to complete the operation.'

		Case 8467
			$message[1] = 'ERROR_DS_INSTALL_SCHEMA_MISMATCH'
			$message[2] = 'The version of the directory service schema of the source forest is not compatible with the version of the directory service on this computer.'

		Case 8468
			$message[1] = 'ERROR_DS_DUP_LINK_ID'
			$message[2] = 'Schema update failed: An attribute with the same link identifier already exists.'

		Case 8469
			$message[1] = 'ERROR_DS_NAME_ERROR_RESOLVING'
			$message[2] = 'Name translation: Generic processing error.'

		Case 8470
			$message[1] = 'ERROR_DS_NAME_ERROR_NOT_FOUND'
			$message[2] = 'Name translation: Could not find the name or insufficient right to see name.'

		Case 8471
			$message[1] = 'ERROR_DS_NAME_ERROR_NOT_UNIQUE'
			$message[2] = 'Name translation: Input name mapped to more than one output name.'

		Case 8472
			$message[1] = 'ERROR_DS_NAME_ERROR_NO_MAPPING'
			$message[2] = 'Name translation: Input name found, but not the associated output format.'

		Case 8473
			$message[1] = 'ERROR_DS_NAME_ERROR_DOMAIN_ONLY'
			$message[2] = 'Name translation: Unable to resolve completely, only the domain was found.'

		Case 8474
			$message[1] = 'ERROR_DS_NAME_ERROR_NO_SYNTACTICAL_MAPPING'
			$message[2] = 'Name translation: Unable to perform purely syntactical mapping at the client without going out to the wire.'

		Case 8475
			$message[1] = 'ERROR_DS_CONSTRUCTED_ATT_MOD'
			$message[2] = 'Modification of a constructed attribute is not allowed.'

		Case 8476
			$message[1] = 'ERROR_DS_WRONG_OM_OBJ_CLASS'
			$message[2] = 'The OM-Object-Class specified is incorrect for an attribute with the specified syntax.'

		Case 8477
			$message[1] = 'ERROR_DS_DRA_REPL_PENDING'
			$message[2] = 'The replication request has been posted; waiting for reply.'

		Case 8478
			$message[1] = 'ERROR_DS_DS_REQUIRED'
			$message[2] = 'The requested operation requires a directory service, and none was available.'

		Case 8479
			$message[1] = 'ERROR_DS_INVALID_LDAP_DISPLAY_NAME'
			$message[2] = 'The LDAP display name of the class or attribute contains non-ASCII characters.'

		Case 8480
			$message[1] = 'ERROR_DS_NON_BASE_SEARCH'
			$message[2] = 'The requested search operation is only supported for base searches.'

		Case 8481
			$message[1] = 'ERROR_DS_CANT_RETRIEVE_ATTS'
			$message[2] = 'The search failed to retrieve attributes from the database.'

		Case 8482
			$message[1] = 'ERROR_DS_BACKLINK_WITHOUT_LINK'
			$message[2] = 'The schema update operation tried to add a backward link attribute that has no corresponding forward link.'

		Case 8483
			$message[1] = 'ERROR_DS_EPOCH_MISMATCH'
			$message[2] = 'Source and destination of a cross-domain move do not agree on the object''s epoch number. Either source or destination does not have the latest version of the object.'

		Case 8484
			$message[1] = 'ERROR_DS_SRC_NAME_MISMATCH'
			$message[2] = 'Source and destination of a cross-domain move do not agree on the object''s current name. Either source or destination does not have the latest version of the object.'

		Case 8485
			$message[1] = 'ERROR_DS_SRC_AND_DST_NC_IDENTICAL'
			$message[2] = 'Source and destination for the cross-domain move operation are identical. Caller should use local move operation instead of cross-domain move operation.'

		Case 8486
			$message[1] = 'ERROR_DS_DST_NC_MISMATCH'
			$message[2] = 'Source and destination for a cross-domain move are not in agreement on the naming contexts in the forest. Either source or destination does not have the latest version of the Partitions container.'

		Case 8487
			$message[1] = 'ERROR_DS_NOT_AUTHORITIVE_FOR_DST_NC'
			$message[2] = 'Destination of a cross-domain move is not authoritative for the destination naming context.'

		Case 8488
			$message[1] = 'ERROR_DS_SRC_GUID_MISMATCH'
			$message[2] = 'Source and destination of a cross-domain move do not agree on the identity of the source object. Either source or destination does not have the latest version of the source object.'

		Case 8489
			$message[1] = 'ERROR_DS_CANT_MOVE_DELETED_OBJECT'
			$message[2] = 'Object being moved across-domains is already known to be deleted by the destination server. The source server does not have the latest version of the source object.'

		Case 8490
			$message[1] = 'ERROR_DS_PDC_OPERATION_IN_PROGRESS'
			$message[2] = 'Another operation which requires exclusive access to the PDC FSMO is already in progress.'

		Case 8491
			$message[1] = 'ERROR_DS_CROSS_DOMAIN_CLEANUP_REQD'
			$message[2] = 'A cross-domain move operation failed such that two versions of the moved object exist - one each in the source and destination domains. The destination object needs to be removed to restore the system to a consistent state.'

		Case 8492
			$message[1] = 'ERROR_DS_ILLEGAL_XDOM_MOVE_OPERATION'
			$message[2] = 'This object may not be moved across domain boundaries either because cross-domain moves for this class are disallowed, or the object has some special characteristics, e.g.: trust account or restricted RID, which prevent its move.'

		Case 8493
			$message[1] = 'ERROR_DS_CANT_WITH_ACCT_GROUP_MEMBERSHPS'
			$message[2] = 'Can''t move objects with memberships across domain boundaries as once moved, this would violate the membership conditions of the account group. Remove the object from any account group memberships and retry.'

		Case 8494
			$message[1] = 'ERROR_DS_NC_MUST_HAVE_NC_PARENT'
			$message[2] = 'A naming context head must be the immediate child of another naming context head, not of an interior node.'

		Case 8495
			$message[1] = 'ERROR_DS_CR_IMPOSSIBLE_TO_VALIDATE'
			$message[2] = 'The directory cannot validate the proposed naming context name because it does not hold a replica of the naming context above the proposed naming context. Please ensure that the domain naming master role is held by a server that is configured as a global catalog server, and that the server is up to date with its replication partners. (Applies only to Windows 2000 Domain Naming masters)'

		Case 8496
			$message[1] = 'ERROR_DS_DST_DOMAIN_NOT_NATIVE'
			$message[2] = 'Destination domain must be in native mode.'

		Case 8497
			$message[1] = 'ERROR_DS_MISSING_INFRASTRUCTURE_CONTAINER'
			$message[2] = 'The operation cannot be performed because the server does not have an infrastructure container in the domain of interest.'

		Case 8498
			$message[1] = 'ERROR_DS_CANT_MOVE_ACCOUNT_GROUP'
			$message[2] = 'Cross-domain move of non-empty account groups is not allowed.'

		Case 8499
			$message[1] = 'ERROR_DS_CANT_MOVE_RESOURCE_GROUP'
			$message[2] = 'Cross-domain move of non-empty resource groups is not allowed.'

		Case 8500
			$message[1] = 'ERROR_DS_INVALID_SEARCH_FLAG'
			$message[2] = 'The search flags for the attribute are invalid. The ANR bit is valid only on attributes of Unicode or Teletex strings.'

		Case 8501
			$message[1] = 'ERROR_DS_NO_TREE_DELETE_ABOVE_NC'
			$message[2] = 'Tree deletions starting at an object which has an NC head as a descendant are not allowed.'

		Case 8502
			$message[1] = 'ERROR_DS_COULDNT_LOCK_TREE_FOR_DELETE'
			$message[2] = 'The directory service failed to lock a tree in preparation for a tree deletion because the tree was in use.'

		Case 8503
			$message[1] = 'ERROR_DS_COULDNT_IDENTIFY_OBJECTS_FOR_TREE_DELETE'
			$message[2] = 'The directory service failed to identify the list of objects to delete while attempting a tree deletion.'

		Case 8504
			$message[1] = 'ERROR_DS_SAM_INIT_FAILURE'
			$message[2] = 'Security Accounts Manager initialization failed because of the following error: %1. Error Status: 0x%2. Click OK to shut down the system and reboot into Directory Services Restore Mode. Check the event log for detailed information.'

		Case 8505
			$message[1] = 'ERROR_DS_SENSITIVE_GROUP_VIOLATION'
			$message[2] = 'Only an administrator can modify the membership list of an administrative group.'

		Case 8506
			$message[1] = 'ERROR_DS_CANT_MOD_PRIMARYGROUPID'
			$message[2] = 'Cannot change the primary group ID of a domain controller account.'

		Case 8507
			$message[1] = 'ERROR_DS_ILLEGAL_BASE_SCHEMA_MOD'
			$message[2] = 'An attempt is made to modify the base schema.'

		Case 8508
			$message[1] = 'ERROR_DS_NONSAFE_SCHEMA_CHANGE'
			$message[2] = 'Adding a new mandatory attribute to an existing class, deleting a mandatory attribute from an existing class, or adding an optional attribute to the special class Top that is not a backlink attribute (directly or through inheritance, for example, by adding or deleting an auxiliary class) is not allowed.'

		Case 8509
			$message[1] = 'ERROR_DS_SCHEMA_UPDATE_DISALLOWED'
			$message[2] = 'Schema update is not allowed on this DC because the DC is not the schema FSMO Role Owner.'

		Case 8510
			$message[1] = 'ERROR_DS_CANT_CREATE_UNDER_SCHEMA'
			$message[2] = 'An object of this class cannot be created under the schema container. You can only create attribute-schema and class-schema objects under the schema container.'

		Case 8511
			$message[1] = 'ERROR_DS_INSTALL_NO_SRC_SCH_VERSION'
			$message[2] = 'The replica/child install failed to get the objectVersion attribute on the schema container on the source DC. Either the attribute is missing on the schema container or the credentials supplied do not have permission to read it.'

		Case 8512
			$message[1] = 'ERROR_DS_INSTALL_NO_SCH_VERSION_IN_INIFILE'
			$message[2] = 'The replica/child install failed to read the objectVersion attribute in the SCHEMA section of the file schema.ini in the system32 directory.'

		Case 8513
			$message[1] = 'ERROR_DS_INVALID_GROUP_TYPE'
			$message[2] = 'The specified group type is invalid.'

		Case 8514
			$message[1] = 'ERROR_DS_NO_NEST_GLOBALGROUP_IN_MIXEDDOMAIN'
			$message[2] = 'You cannot nest global groups in a mixed domain if the group is security-enabled.'

		Case 8515
			$message[1] = 'ERROR_DS_NO_NEST_LOCALGROUP_IN_MIXEDDOMAIN'
			$message[2] = 'You cannot nest local groups in a mixed domain if the group is security-enabled.'

		Case 8516
			$message[1] = 'ERROR_DS_GLOBAL_CANT_HAVE_LOCAL_MEMBER'
			$message[2] = 'A global group cannot have a local group as a member.'

		Case 8517
			$message[1] = 'ERROR_DS_GLOBAL_CANT_HAVE_UNIVERSAL_MEMBER'
			$message[2] = 'A global group cannot have a universal group as a member.'

		Case 8518
			$message[1] = 'ERROR_DS_UNIVERSAL_CANT_HAVE_LOCAL_MEMBER'
			$message[2] = 'A universal group cannot have a local group as a member.'

		Case 8519
			$message[1] = 'ERROR_DS_GLOBAL_CANT_HAVE_CROSSDOMAIN_MEMBER'
			$message[2] = 'A global group cannot have a cross-domain member.'

		Case 8520
			$message[1] = 'ERROR_DS_LOCAL_CANT_HAVE_CROSSDOMAIN_LOCAL_MEMBER'
			$message[2] = 'A local group cannot have another cross domain local group as a member.'

		Case 8521
			$message[1] = 'ERROR_DS_HAVE_PRIMARY_MEMBERS'
			$message[2] = 'A group with primary members cannot change to a security-disabled group.'

		Case 8522
			$message[1] = 'ERROR_DS_STRING_SD_CONVERSION_FAILED'
			$message[2] = 'The schema cache load failed to convert the string default SD on a class-schema object.'

		Case 8523
			$message[1] = 'ERROR_DS_NAMING_MASTER_GC'
			$message[2] = 'Only DSAs configured to be Global Catalog servers should be allowed to hold the Domain Naming Master FSMO role. (Applies only to Windows 2000 servers)'

		Case 8524
			$message[1] = 'ERROR_DS_DNS_LOOKUP_FAILURE'
			$message[2] = 'The DSA operation is unable to proceed because of a DNS lookup failure.'

		Case 8525
			$message[1] = 'ERROR_DS_COULDNT_UPDATE_SPNS'
			$message[2] = 'While processing a change to the DNS Host Name for an object, the Service Principal Name values could not be kept in sync.'

		Case 8526
			$message[1] = 'ERROR_DS_CANT_RETRIEVE_SD'
			$message[2] = 'The Security Descriptor attribute could not be read.'

		Case 8527
			$message[1] = 'ERROR_DS_KEY_NOT_UNIQUE'
			$message[2] = 'The object requested was not found, but an object with that key was found.'

		Case 8528
			$message[1] = 'ERROR_DS_WRONG_LINKED_ATT_SYNTAX'
			$message[2] = 'The syntax of the linked attribute being added is incorrect. Forward links can only have syntax 2.5.5.1, 2.5.5.7, and 2.5.5.14, and backlinks can only have syntax 2.5.5.1'

		Case 8529
			$message[1] = 'ERROR_DS_SAM_NEED_BOOTKEY_PASSWORD'
			$message[2] = 'Security Account Manager needs to get the boot password.'

		Case 8530
			$message[1] = 'ERROR_DS_SAM_NEED_BOOTKEY_FLOPPY'
			$message[2] = 'Security Account Manager needs to get the boot key from floppy disk.'

		Case 8531
			$message[1] = 'ERROR_DS_CANT_START'
			$message[2] = 'Directory Service cannot start.'

		Case 8532
			$message[1] = 'ERROR_DS_INIT_FAILURE'
			$message[2] = 'Directory Services could not start.'

		Case 8533
			$message[1] = 'ERROR_DS_NO_PKT_PRIVACY_ON_CONNECTION'
			$message[2] = 'The connection between client and server requires packet privacy or better.'

		Case 8534
			$message[1] = 'ERROR_DS_SOURCE_DOMAIN_IN_FOREST'
			$message[2] = 'The source domain may not be in the same forest as destination.'

		Case 8535
			$message[1] = 'ERROR_DS_DESTINATION_DOMAIN_NOT_IN_FOREST'
			$message[2] = 'The destination domain must be in the forest.'

		Case 8536
			$message[1] = 'ERROR_DS_DESTINATION_AUDITING_NOT_ENABLED'
			$message[2] = 'The operation requires that destination domain auditing be enabled.'

		Case 8537
			$message[1] = 'ERROR_DS_CANT_FIND_DC_FOR_SRC_DOMAIN'
			$message[2] = 'The operation couldn''t locate a DC for the source domain.'

		Case 8538
			$message[1] = 'ERROR_DS_SRC_OBJ_NOT_GROUP_OR_USER'
			$message[2] = 'The source object must be a group or user.'

		Case 8539
			$message[1] = 'ERROR_DS_SRC_SID_EXISTS_IN_FOREST'
			$message[2] = 'The source object''s SID already exists in destination forest.'

		Case 8540
			$message[1] = 'ERROR_DS_SRC_AND_DST_OBJECT_CLASS_MISMATCH'
			$message[2] = 'The source and destination object must be of the same type.'

		Case 8541
			$message[1] = 'ERROR_SAM_INIT_FAILURE'
			$message[2] = 'Security Accounts Manager initialization failed because of the following error: %1. Error Status: 0x%2. Click OK to shut down the system and reboot into Safe Mode. Check the event log for detailed information.'

		Case 8542
			$message[1] = 'ERROR_DS_DRA_SCHEMA_INFO_SHIP'
			$message[2] = 'Schema information could not be included in the replication request.'

		Case 8543
			$message[1] = 'ERROR_DS_DRA_SCHEMA_CONFLICT'
			$message[2] = 'The replication operation could not be completed due to a schema incompatibility.'

		Case 8544
			$message[1] = 'ERROR_DS_DRA_EARLIER_SCHEMA_CONFLICT'
			$message[2] = 'The replication operation could not be completed due to a previous schema incompatibility.'

		Case 8545
			$message[1] = 'ERROR_DS_DRA_OBJ_NC_MISMATCH'
			$message[2] = 'The replication update could not be applied because either the source or the destination has not yet received information regarding a recent cross-domain move operation.'

		Case 8546
			$message[1] = 'ERROR_DS_NC_STILL_HAS_DSAS'
			$message[2] = 'The requested domain could not be deleted because there exist domain controllers that still host this domain.'

		Case 8547
			$message[1] = 'ERROR_DS_GC_REQUIRED'
			$message[2] = 'The requested operation can be performed only on a global catalog server.'

		Case 8548
			$message[1] = 'ERROR_DS_LOCAL_MEMBER_OF_LOCAL_ONLY'
			$message[2] = 'A local group can only be a member of other local groups in the same domain.'

		Case 8549
			$message[1] = 'ERROR_DS_NO_FPO_IN_UNIVERSAL_GROUPS'
			$message[2] = 'Foreign security principals cannot be members of universal groups.'

		Case 8550
			$message[1] = 'ERROR_DS_CANT_ADD_TO_GC'
			$message[2] = 'The attribute is not allowed to be replicated to the GC because of security reasons.'

		Case 8551
			$message[1] = 'ERROR_DS_NO_CHECKPOINT_WITH_PDC'
			$message[2] = 'The checkpoint with the PDC could not be taken because there too many modifications being processed currently.'

		Case 8552
			$message[1] = 'ERROR_DS_SOURCE_AUDITING_NOT_ENABLED'
			$message[2] = 'The operation requires that source domain auditing be enabled.'

		Case 8553
			$message[1] = 'ERROR_DS_CANT_CREATE_IN_NONDOMAIN_NC'
			$message[2] = 'Security principal objects can only be created inside domain naming contexts.'

		Case 8554
			$message[1] = 'ERROR_DS_INVALID_NAME_FOR_SPN'
			$message[2] = 'A Service Principal Name (SPN) could not be constructed because the provided hostname is not in the necessary format.'

		Case 8555
			$message[1] = 'ERROR_DS_FILTER_USES_CONTRUCTED_ATTRS'
			$message[2] = 'A Filter was passed that uses constructed attributes.'

		Case 8556
			$message[1] = 'ERROR_DS_UNICODEPWD_NOT_IN_QUOTES'
			$message[2] = 'The unicodePwd attribute value must be enclosed in double quotes.'

		Case 8557
			$message[1] = 'ERROR_DS_MACHINE_ACCOUNT_QUOTA_EXCEEDED'
			$message[2] = 'Your computer could not be joined to the domain. You have exceeded the maximum number of computer accounts you are allowed to create in this domain. Contact your system administrator to have this limit reset or increased.'

		Case 8558
			$message[1] = 'ERROR_DS_MUST_BE_RUN_ON_DST_DC'
			$message[2] = 'For security reasons, the operation must be run on the destination DC.'

		Case 8559
			$message[1] = 'ERROR_DS_SRC_DC_MUST_BE_SP4_OR_GREATER'
			$message[2] = 'For security reasons, the source DC must be NT4SP4 or greater.'

		Case 8560
			$message[1] = 'ERROR_DS_CANT_TREE_DELETE_CRITICAL_OBJ'
			$message[2] = 'Critical Directory Service System objects cannot be deleted during tree delete operations. The tree delete may have been partially performed.'

		Case 8561
			$message[1] = 'ERROR_DS_INIT_FAILURE_CONSOLE'
			$message[2] = 'Directory Services could not start because of the following error: %1. Error Status: 0x%2. Please click OK to shutdown the system. You can use the recovery console to diagnose the system further.'

		Case 8562
			$message[1] = 'ERROR_DS_SAM_INIT_FAILURE_CONSOLE'
			$message[2] = 'Security Accounts Manager initialization failed because of the following error: %1. Error Status: 0x%2. Please click OK to shutdown the system. You can use the recovery console to diagnose the system further.'

		Case 8563
			$message[1] = 'ERROR_DS_FOREST_VERSION_TOO_HIGH'
			$message[2] = 'The version of the operating system installed is incompatible with the current forest functional level. You must upgrade to a new version of the operating system before this server can become a domain controller in this forest.'

		Case 8564
			$message[1] = 'ERROR_DS_DOMAIN_VERSION_TOO_HIGH'
			$message[2] = 'The version of the operating system installed is incompatible with the current domain functional level. You must upgrade to a new version of the operating system before this server can become a domain controller in this domain.'

		Case 8565
			$message[1] = 'ERROR_DS_FOREST_VERSION_TOO_LOW'
			$message[2] = 'The version of the operating system installed on this server no longer supports the current forest functional level. You must raise the forest functional level before this server can become a domain controller in this forest.'

		Case 8566
			$message[1] = 'ERROR_DS_DOMAIN_VERSION_TOO_LOW'
			$message[2] = 'The version of the operating system installed on this server no longer supports the current domain functional level. You must raise the domain functional level before this server can become a domain controller in this domain.'

		Case 8567
			$message[1] = 'ERROR_DS_INCOMPATIBLE_VERSION'
			$message[2] = 'The version of the operating system installed on this server is incompatible with the functional level of the domain or forest.'

		Case 8568
			$message[1] = 'ERROR_DS_LOW_DSA_VERSION'
			$message[2] = 'The functional level of the domain (or forest) cannot be raised to the requested value, because there exist one or more domain controllers in the domain (or forest) that are at a lower incompatible functional level.'

		Case 8569
			$message[1] = 'ERROR_DS_NO_BEHAVIOR_VERSION_IN_MIXEDDOMAIN'
			$message[2] = 'The forest functional level cannot be raised to the requested value since one or more domains are still in mixed domain mode. All domains in the forest must be in native mode, for you to raise the forest functional level.'

		Case 8570
			$message[1] = 'ERROR_DS_NOT_SUPPORTED_SORT_ORDER'
			$message[2] = 'The sort order requested is not supported.'

		Case 8571
			$message[1] = 'ERROR_DS_NAME_NOT_UNIQUE'
			$message[2] = 'The requested name already exists as a unique identifier.'

		Case 8572
			$message[1] = 'ERROR_DS_MACHINE_ACCOUNT_CREATED_PRENT4'
			$message[2] = 'The machine account was created pre-NT4. The account needs to be recreated.'

		Case 8573
			$message[1] = 'ERROR_DS_OUT_OF_VERSION_STORE'
			$message[2] = 'The database is out of version store.'

		Case 8574
			$message[1] = 'ERROR_DS_INCOMPATIBLE_CONTROLS_USED'
			$message[2] = 'Unable to continue operation because multiple conflicting controls were used.'

		Case 8575
			$message[1] = 'ERROR_DS_NO_REF_DOMAIN'
			$message[2] = 'Unable to find a valid security descriptor reference domain for this partition.'

		Case 8576
			$message[1] = 'ERROR_DS_RESERVED_LINK_ID'
			$message[2] = 'Schema update failed: The link identifier is reserved.'

		Case 8577
			$message[1] = 'ERROR_DS_LINK_ID_NOT_AVAILABLE'
			$message[2] = 'Schema update failed: There are no link identifiers available.'

		Case 8578
			$message[1] = 'ERROR_DS_AG_CANT_HAVE_UNIVERSAL_MEMBER'
			$message[2] = 'An account group cannot have a universal group as a member.'

		Case 8579
			$message[1] = 'ERROR_DS_MODIFYDN_DISALLOWED_BY_INSTANCE_TYPE'
			$message[2] = 'Rename or move operations on naming context heads or read-only objects are not allowed.'

		Case 8580
			$message[1] = 'ERROR_DS_NO_OBJECT_MOVE_IN_SCHEMA_NC'
			$message[2] = 'Move operations on objects in the schema naming context are not allowed.'

		Case 8581
			$message[1] = 'ERROR_DS_MODIFYDN_DISALLOWED_BY_FLAG'
			$message[2] = 'A system flag has been set on the object and does not allow the object to be moved or renamed.'

		Case 8582
			$message[1] = 'ERROR_DS_MODIFYDN_WRONG_GRANDPARENT'
			$message[2] = 'This object is not allowed to change its grandparent container. Moves are not forbidden on this object, but are restricted to sibling containers.'

		Case 8583
			$message[1] = 'ERROR_DS_NAME_ERROR_TRUST_REFERRAL'
			$message[2] = 'Unable to resolve completely, a referral to another forest is generated.'

		Case 8584
			$message[1] = 'ERROR_NOT_SUPPORTED_ON_STANDARD_SERVER'
			$message[2] = 'The requested action is not supported on standard server.'

		Case 8585
			$message[1] = 'ERROR_DS_CANT_ACCESS_REMOTE_PART_OF_AD'
			$message[2] = 'Could not access a partition of the directory service located on a remote server. Make sure at least one server is running for the partition in question.'

		Case 8586
			$message[1] = 'ERROR_DS_CR_IMPOSSIBLE_TO_VALIDATE_V2'
			$message[2] = 'The directory cannot validate the proposed naming context (or partition) name because it does not hold a replica nor can it contact a replica of the naming context above the proposed naming context. Please ensure that the parent naming context is properly registered in DNS, and at least one replica of this naming context is reachable by the Domain Naming master.'

		Case 8587
			$message[1] = 'ERROR_DS_THREAD_LIMIT_EXCEEDED'
			$message[2] = 'The thread limit for this request was exceeded.'

		Case 8588
			$message[1] = 'ERROR_DS_NOT_CLOSEST'
			$message[2] = 'The Global catalog server is not in the closest site.'

		Case 8589
			$message[1] = 'ERROR_DS_CANT_DERIVE_SPN_WITHOUT_SERVER_REF'
			$message[2] = 'The DS cannot derive a service principal name (SPN) with which to mutually authenticate the target server because the corresponding server object in the local DS database has no serverReference attribute.'

		Case 8590
			$message[1] = 'ERROR_DS_SINGLE_USER_MODE_FAILED'
			$message[2] = 'The Directory Service failed to enter single user mode.'

		Case 8591
			$message[1] = 'ERROR_DS_NTDSCRIPT_SYNTAX_ERROR'
			$message[2] = 'The Directory Service cannot parse the script because of a syntax error.'

		Case 8592
			$message[1] = 'ERROR_DS_NTDSCRIPT_PROCESS_ERROR'
			$message[2] = 'The Directory Service cannot process the script because of an error.'

		Case 8593
			$message[1] = 'ERROR_DS_DIFFERENT_REPL_EPOCHS'
			$message[2] = 'The directory service cannot perform the requested operation because the servers involved are of different replication epochs (which is usually related to a domain rename that is in progress).'

		Case 8594
			$message[1] = 'ERROR_DS_DRS_EXTENSIONS_CHANGED'
			$message[2] = 'The directory service binding must be renegotiated due to a change in the server extensions information.'

		Case 8595
			$message[1] = 'ERROR_DS_REPLICA_SET_CHANGE_NOT_ALLOWED_ON_DISABLED_CR'
			$message[2] = 'Operation not allowed on a disabled cross ref.'

		Case 8596
			$message[1] = 'ERROR_DS_NO_MSDS_INTID'
			$message[2] = 'Schema update failed: No values for msDS-IntId are available.'

		Case 8597
			$message[1] = 'ERROR_DS_DUP_MSDS_INTID'
			$message[2] = 'Schema update failed: Duplicate msDS-INtId. Retry the operation.'

		Case 8598
			$message[1] = 'ERROR_DS_EXISTS_IN_RDNATTID'
			$message[2] = 'Schema deletion failed: attribute is used in rDNAttID.'

		Case 8599
			$message[1] = 'ERROR_DS_AUTHORIZATION_FAILED'
			$message[2] = 'The directory service failed to authorize the request.'

		Case 8600
			$message[1] = 'ERROR_DS_INVALID_SCRIPT'
			$message[2] = 'The Directory Service cannot process the script because it is invalid.'

		Case 8601
			$message[1] = 'ERROR_DS_REMOTE_CROSSREF_OP_FAILED'
			$message[2] = 'The remote create cross reference operation failed on the Domain Naming Master FSMO. The operation''s error is in the extended data.'

		Case 8602
			$message[1] = 'ERROR_DS_CROSS_REF_BUSY'
			$message[2] = 'A cross reference is in use locally with the same name.'

		Case 8603
			$message[1] = 'ERROR_DS_CANT_DERIVE_SPN_FOR_DELETED_DOMAIN'
			$message[2] = 'The DS cannot derive a service principal name (SPN) with which to mutually authenticate the target server because the server''s domain has been deleted from the forest.'

		Case 8604
			$message[1] = 'ERROR_DS_CANT_DEMOTE_WITH_WRITEABLE_NC'
			$message[2] = 'Writeable NCs prevent this DC from demoting.'

		Case 8605
			$message[1] = 'ERROR_DS_DUPLICATE_ID_FOUND'
			$message[2] = 'The requested object has a non-unique identifier and cannot be retrieved.'

		Case 8606
			$message[1] = 'ERROR_DS_INSUFFICIENT_ATTR_TO_CREATE_OBJECT'
			$message[2] = 'Insufficient attributes were given to create an object. This object may not exist because it may have been deleted and already garbage collected.'

		Case 8607
			$message[1] = 'ERROR_DS_GROUP_CONVERSION_ERROR'
			$message[2] = 'The group cannot be converted due to attribute restrictions on the requested group type.'

		Case 8608
			$message[1] = 'ERROR_DS_CANT_MOVE_APP_BASIC_GROUP'
			$message[2] = 'Cross-domain move of non-empty basic application groups is not allowed.'

		Case 8609
			$message[1] = 'ERROR_DS_CANT_MOVE_APP_QUERY_GROUP'
			$message[2] = 'Cross-domain move of non-empty query based application groups is not allowed.'

		Case 8610
			$message[1] = 'ERROR_DS_ROLE_NOT_VERIFIED'
			$message[2] = 'The FSMO role ownership could not be verified because its directory partition has not replicated successfully with at least one replication partner.'

		Case 8611
			$message[1] = 'ERROR_DS_WKO_CONTAINER_CANNOT_BE_SPECIAL'
			$message[2] = 'The target container for a redirection of a well known object container cannot already be a special container.'

		Case 8612
			$message[1] = 'ERROR_DS_DOMAIN_RENAME_IN_PROGRESS'
			$message[2] = 'The Directory Service cannot perform the requested operation because a domain rename operation is in progress.'

		Case 8613
			$message[1] = 'ERROR_DS_EXISTING_AD_CHILD_NC'
			$message[2] = 'The directory service detected a child partition below the requested new partition name. The partition hierarchy must be created in a top down method.'

		Case 8614
			$message[1] = 'ERROR_DS_REPL_LIFETIME_EXCEEDED'
			$message[2] = 'The directory service cannot replicate with this server because the time since the last replication with this server has exceeded the tombstone lifetime.'

		Case 8615
			$message[1] = 'ERROR_DS_DISALLOWED_IN_SYSTEM_CONTAINER'
			$message[2] = 'The requested operation is not allowed on an object under the system container.'

		Case 8616
			$message[1] = 'ERROR_DS_LDAP_SEND_QUEUE_FULL'
			$message[2] = 'The LDAP servers network send queue has filled up because the client is not processing the results of it''s requests fast enough. No more requests will be processed until the client catches up. If the client does not catch up then it will be disconnected.'

		Case 8617
			$message[1] = 'ERROR_DS_DRA_OUT_SCHEDULE_WINDOW'
			$message[2] = 'The scheduled replication did not take place because the system was too busy to execute the request within the schedule window. The replication queue is overloaded. Consider reducing the number of partners or decreasing the scheduled replication frequency.'

		Case 8618
			$message[1] = 'ERROR_DS_POLICY_NOT_KNOWN'
			$message[2] = 'At this time, it cannot be determined if the branch replication policy is available on the hub domain controller. Please retry at a later time to account for replication latencies.'

		Case 8619
			$message[1] = 'ERROR_NO_SITE_SETTINGS_OBJECT'
			$message[2] = 'The site settings object for the specified site does not exist.'

		Case 8620
			$message[1] = 'ERROR_NO_SECRETS'
			$message[2] = 'The local account store does not contain secret material for the specified account.'

		Case 8621
			$message[1] = 'ERROR_NO_WRITABLE_DC_FOUND'
			$message[2] = 'Could not find a writable domain controller in the domain.'

		Case 8622
			$message[1] = 'ERROR_DS_NO_SERVER_OBJECT'
			$message[2] = 'The server object for the domain controller does not exist.'

		Case 8623
			$message[1] = 'ERROR_DS_NO_NTDSA_OBJECT'
			$message[2] = 'The NTDS Settings object for the domain controller does not exist.'

		Case 8624
			$message[1] = 'ERROR_DS_NON_ASQ_SEARCH'
			$message[2] = 'The requested search operation is not supported for ASQ searches.'

		Case 8625
			$message[1] = 'ERROR_DS_AUDIT_FAILURE'
			$message[2] = 'A required audit event could not be generated for the operation.'

		Case 8626
			$message[1] = 'ERROR_DS_INVALID_SEARCH_FLAG_SUBTREE'
			$message[2] = 'The search flags for the attribute are invalid. The subtree index bit is valid only on single valued attributes.'

		Case 8627
			$message[1] = 'ERROR_DS_INVALID_SEARCH_FLAG_TUPLE'
			$message[2] = 'The search flags for the attribute are invalid. The tuple index bit is valid only on attributes of Unicode strings.'

		Case 8628
			$message[1] = 'ERROR_DS_HIERARCHY_TABLE_TOO_DEEP'
			$message[2] = 'The address books are nested too deeply. Failed to build the hierarchy table.'

		Case 8629
			$message[1] = 'ERROR_DS_DRA_CORRUPT_UTD_VECTOR'
			$message[2] = 'The specified up-to-date-ness vector is corrupt.'

		Case 8630
			$message[1] = 'ERROR_DS_DRA_SECRETS_DENIED'
			$message[2] = 'The request to replicate secrets is denied.'

		Case 8631
			$message[1] = 'ERROR_DS_RESERVED_MAPI_ID'
			$message[2] = 'Schema update failed: The MAPI identifier is reserved.'

		Case 8632
			$message[1] = 'ERROR_DS_MAPI_ID_NOT_AVAILABLE'
			$message[2] = 'Schema update failed: There are no MAPI identifiers available.'

		Case 8633
			$message[1] = 'ERROR_DS_DRA_MISSING_KRBTGT_SECRET'
			$message[2] = 'The replication operation failed because the required attributes of the local krbtgt object are missing.'

		Case 9001
			$message[1] = 'DNS_ERROR_RCODE_FORMAT_ERROR'
			$message[2] = 'DNS server unable to interpret format.'

		Case 9002
			$message[1] = 'DNS_ERROR_RCODE_SERVER_FAILURE'
			$message[2] = 'DNS server failure.'

		Case 9003
			$message[1] = 'DNS_ERROR_RCODE_NAME_ERROR'
			$message[2] = 'DNS name does not exist.'

		Case 9004
			$message[1] = 'DNS_ERROR_RCODE_NOT_IMPLEMENTED'
			$message[2] = 'DNS request not supported by name server.'

		Case 9005
			$message[1] = 'DNS_ERROR_RCODE_REFUSED'
			$message[2] = 'DNS operation refused.'

		Case 9006
			$message[1] = 'DNS_ERROR_RCODE_YXDOMAIN'
			$message[2] = 'DNS name that ought not exist, does exist.'

		Case 9007
			$message[1] = 'DNS_ERROR_RCODE_YXRRSET'
			$message[2] = 'DNS RR set that ought not exist, does exist.'

		Case 9008
			$message[1] = 'DNS_ERROR_RCODE_NXRRSET'
			$message[2] = 'DNS RR set that ought to exist, does not exist.'

		Case 9009
			$message[1] = 'DNS_ERROR_RCODE_NOTAUTH'
			$message[2] = 'DNS server not authoritative for zone.'

		Case 9010
			$message[1] = 'DNS_ERROR_RCODE_NOTZONE'
			$message[2] = 'DNS name in update or prereq is not in zone.'

		Case 9016
			$message[1] = 'DNS_ERROR_RCODE_BADSIG'
			$message[2] = 'DNS signature failed to verify.'

		Case 9017
			$message[1] = 'DNS_ERROR_RCODE_BADKEY'
			$message[2] = 'DNS bad key.'

		Case 9018
			$message[1] = 'DNS_ERROR_RCODE_BADTIME'
			$message[2] = 'DNS signature validity expired.'

		Case 9501
			$message[1] = 'DNS_INFO_NO_RECORDS'
			$message[2] = 'No records found for given DNS query.'

		Case 9502
			$message[1] = 'DNS_ERROR_BAD_PACKET'
			$message[2] = 'Bad DNS packet.'

		Case 9503
			$message[1] = 'DNS_ERROR_NO_PACKET'
			$message[2] = 'No DNS packet.'

		Case 9504
			$message[1] = 'DNS_ERROR_RCODE'
			$message[2] = 'DNS error, check rcode.'

		Case 9505
			$message[1] = 'DNS_ERROR_UNSECURE_PACKET'
			$message[2] = 'Unsecured DNS packet.'

		Case 9551
			$message[1] = 'DNS_ERROR_INVALID_TYPE'
			$message[2] = 'Invalid DNS type.'

		Case 9552
			$message[1] = 'DNS_ERROR_INVALID_IP_ADDRESS'
			$message[2] = 'Invalid IP address.'

		Case 9553
			$message[1] = 'DNS_ERROR_INVALID_PROPERTY'
			$message[2] = 'Invalid property.'

		Case 9554
			$message[1] = 'DNS_ERROR_TRY_AGAIN_LATER'
			$message[2] = 'Try DNS operation again later.'

		Case 9555
			$message[1] = 'DNS_ERROR_NOT_UNIQUE'
			$message[2] = 'Record for given name and type is not unique.'

		Case 9556
			$message[1] = 'DNS_ERROR_NON_RFC_NAME'
			$message[2] = 'DNS name does not comply with RFC specifications.'

		Case 9557
			$message[1] = 'DNS_STATUS_FQDN'
			$message[2] = 'DNS name is a fully-qualified DNS name.'

		Case 9558
			$message[1] = 'DNS_STATUS_DOTTED_NAME'
			$message[2] = 'DNS name is dotted (multi-label).'

		Case 9559
			$message[1] = 'DNS_STATUS_SINGLE_PART_NAME'
			$message[2] = 'DNS name is a single-part name.'

		Case 9560
			$message[1] = 'DNS_ERROR_INVALID_NAME_CHAR'
			$message[2] = 'DNS name contains an invalid character.'

		Case 9561
			$message[1] = 'DNS_ERROR_NUMERIC_NAME'
			$message[2] = 'DNS name is entirely numeric.'

		Case 9562
			$message[1] = 'DNS_ERROR_NOT_ALLOWED_ON_ROOT_SERVER'
			$message[2] = 'The operation requested is not permitted on a DNS root server.'

		Case 9563
			$message[1] = 'DNS_ERROR_NOT_ALLOWED_UNDER_DELEGATION'
			$message[2] = 'The record could not be created because this part of the DNS namespace has been delegated to another server.'

		Case 9564
			$message[1] = 'DNS_ERROR_CANNOT_FIND_ROOT_HINTS'
			$message[2] = 'The DNS server could not find a set of root hints.'

		Case 9565
			$message[1] = 'DNS_ERROR_INCONSISTENT_ROOT_HINTS'
			$message[2] = 'The DNS server found root hints but they were not consistent across all adapters.'

		Case 9566
			$message[1] = 'DNS_ERROR_DWORD_VALUE_TOO_SMALL'
			$message[2] = 'The specified value is too small for this parameter.'

		Case 9567
			$message[1] = 'DNS_ERROR_DWORD_VALUE_TOO_LARGE'
			$message[2] = 'The specified value is too large for this parameter.'

		Case 9568
			$message[1] = 'DNS_ERROR_BACKGROUND_LOADING'
			$message[2] = 'This operation is not allowed while the DNS server is loading zones in the background. Please try again later.'

		Case 9569
			$message[1] = 'DNS_ERROR_NOT_ALLOWED_ON_RODC'
			$message[2] = 'The operation requested is not permitted on against a DNS server running on a read-only DC.'

		Case 9570
			$message[1] = 'DNS_ERROR_NOT_ALLOWED_UNDER_DNAME'
			$message[2] = 'No data is allowed to exist underneath a DNAME record.'

		Case 9601
			$message[1] = 'DNS_ERROR_ZONE_DOES_NOT_EXIST'
			$message[2] = 'DNS zone does not exist.'

		Case 9602
			$message[1] = 'DNS_ERROR_NO_ZONE_INFO'
			$message[2] = 'DNS zone information not available.'

		Case 9603
			$message[1] = 'DNS_ERROR_INVALID_ZONE_OPERATION'
			$message[2] = 'Invalid operation for DNS zone.'

		Case 9604
			$message[1] = 'DNS_ERROR_ZONE_CONFIGURATION_ERROR'
			$message[2] = 'Invalid DNS zone configuration.'

		Case 9605
			$message[1] = 'DNS_ERROR_ZONE_HAS_NO_SOA_RECORD'
			$message[2] = 'DNS zone has no start of authority (SOA) record.'

		Case 9606
			$message[1] = 'DNS_ERROR_ZONE_HAS_NO_NS_RECORDS'
			$message[2] = 'DNS zone has no Name Server (NS) record.'

		Case 9607
			$message[1] = 'DNS_ERROR_ZONE_LOCKED'
			$message[2] = 'DNS zone is locked.'

		Case 9608
			$message[1] = 'DNS_ERROR_ZONE_CREATION_FAILED'
			$message[2] = 'DNS zone creation failed.'

		Case 9609
			$message[1] = 'DNS_ERROR_ZONE_ALREADY_EXISTS'
			$message[2] = 'DNS zone already exists.'

		Case 9610
			$message[1] = 'DNS_ERROR_AUTOZONE_ALREADY_EXISTS'
			$message[2] = 'DNS automatic zone already exists.'

		Case 9611
			$message[1] = 'DNS_ERROR_INVALID_ZONE_TYPE'
			$message[2] = 'Invalid DNS zone type.'

		Case 9612
			$message[1] = 'DNS_ERROR_SECONDARY_REQUIRES_MASTER_IP'
			$message[2] = 'Secondary DNS zone requires master IP address.'

		Case 9613
			$message[1] = 'DNS_ERROR_ZONE_NOT_SECONDARY'
			$message[2] = 'DNS zone not secondary.'

		Case 9614
			$message[1] = 'DNS_ERROR_NEED_SECONDARY_ADDRESSES'
			$message[2] = 'Need secondary IP address.'

		Case 9615
			$message[1] = 'DNS_ERROR_WINS_INIT_FAILED'
			$message[2] = 'WINS initialization failed.'

		Case 9616
			$message[1] = 'DNS_ERROR_NEED_WINS_SERVERS'
			$message[2] = 'Need WINS servers.'

		Case 9617
			$message[1] = 'DNS_ERROR_NBSTAT_INIT_FAILED'
			$message[2] = 'NBTSTAT initialization call failed.'

		Case 9618
			$message[1] = 'DNS_ERROR_SOA_DELETE_INVALID'
			$message[2] = 'Invalid delete of start of authority (SOA)'

		Case 9619
			$message[1] = 'DNS_ERROR_FORWARDER_ALREADY_EXISTS'
			$message[2] = 'A conditional forwarding zone already exists for that name.'

		Case 9620
			$message[1] = 'DNS_ERROR_ZONE_REQUIRES_MASTER_IP'
			$message[2] = 'This zone must be configured with one or more master DNS server IP addresses.'

		Case 9621
			$message[1] = 'DNS_ERROR_ZONE_IS_SHUTDOWN'
			$message[2] = 'The operation cannot be performed because this zone is shutdown.'

		Case 9651
			$message[1] = 'DNS_ERROR_PRIMARY_REQUIRES_DATAFILE'
			$message[2] = 'Primary DNS zone requires datafile.'

		Case 9652
			$message[1] = 'DNS_ERROR_INVALID_DATAFILE_NAME'
			$message[2] = 'Invalid datafile name for DNS zone.'

		Case 9653
			$message[1] = 'DNS_ERROR_DATAFILE_OPEN_FAILURE'
			$message[2] = 'Failed to open datafile for DNS zone.'

		Case 9654
			$message[1] = 'DNS_ERROR_FILE_WRITEBACK_FAILED'
			$message[2] = 'Failed to write datafile for DNS zone.'

		Case 9655
			$message[1] = 'DNS_ERROR_DATAFILE_PARSING'
			$message[2] = 'Failure while reading datafile for DNS zone.'

		Case 9701
			$message[1] = 'DNS_ERROR_RECORD_DOES_NOT_EXIST'
			$message[2] = 'DNS record does not exist.'

		Case 9702
			$message[1] = 'DNS_ERROR_RECORD_FORMAT'
			$message[2] = 'DNS record format error.'

		Case 9703
			$message[1] = 'DNS_ERROR_NODE_CREATION_FAILED'
			$message[2] = 'Node creation failure in DNS.'

		Case 9704
			$message[1] = 'DNS_ERROR_UNKNOWN_RECORD_TYPE'
			$message[2] = 'Unknown DNS record type.'

		Case 9705
			$message[1] = 'DNS_ERROR_RECORD_TIMED_OUT'
			$message[2] = 'DNS record timed out.'

		Case 9706
			$message[1] = 'DNS_ERROR_NAME_NOT_IN_ZONE'
			$message[2] = 'Name not in DNS zone.'

		Case 9707
			$message[1] = 'DNS_ERROR_CNAME_LOOP'
			$message[2] = 'CNAME loop detected.'

		Case 9708
			$message[1] = 'DNS_ERROR_NODE_IS_CNAME'
			$message[2] = 'Node is a CNAME DNS record.'

		Case 9709
			$message[1] = 'DNS_ERROR_CNAME_COLLISION'
			$message[2] = 'A CNAME record already exists for given name.'

		Case 9710
			$message[1] = 'DNS_ERROR_RECORD_ONLY_AT_ZONE_ROOT'
			$message[2] = 'Record only at DNS zone root.'

		Case 9711
			$message[1] = 'DNS_ERROR_RECORD_ALREADY_EXISTS'
			$message[2] = 'DNS record already exists.'

		Case 9712
			$message[1] = 'DNS_ERROR_SECONDARY_DATA'
			$message[2] = 'Secondary DNS zone data error.'

		Case 9713
			$message[1] = 'DNS_ERROR_NO_CREATE_CACHE_DATA'
			$message[2] = 'Could not create DNS cache data.'

		Case 9714
			$message[1] = 'DNS_ERROR_NAME_DOES_NOT_EXIST'
			$message[2] = 'DNS name does not exist.'

		Case 9715
			$message[1] = 'DNS_WARNING_PTR_CREATE_FAILED'
			$message[2] = 'Could not create pointer (PTR) record.'

		Case 9716
			$message[1] = 'DNS_WARNING_DOMAIN_UNDELETED'
			$message[2] = 'DNS domain was undeleted.'

		Case 9717
			$message[1] = 'DNS_ERROR_DS_UNAVAILABLE'
			$message[2] = 'The directory service is unavailable.'

		Case 9718
			$message[1] = 'DNS_ERROR_DS_ZONE_ALREADY_EXISTS'
			$message[2] = 'DNS zone already exists in the directory service.'

		Case 9719
			$message[1] = 'DNS_ERROR_NO_BOOTFILE_IF_DS_ZONE'
			$message[2] = 'DNS server not creating or reading the boot file for the directory service integrated DNS zone.'

		Case 9720
			$message[1] = 'DNS_ERROR_NODE_IS_DNAME'
			$message[2] = 'Node is a DNAME DNS record.'

		Case 9721
			$message[1] = 'DNS_ERROR_DNAME_COLLISION'
			$message[2] = 'A DNAME record already exists for given name.'

		Case 9722
			$message[1] = 'DNS_ERROR_ALIAS_LOOP'
			$message[2] = 'An alias loop has been detected with either CNAME or DNAME records.'

		Case 9751
			$message[1] = 'DNS_INFO_AXFR_COMPLETE'
			$message[2] = 'DNS AXFR (zone transfer) complete.'

		Case 9752
			$message[1] = 'DNS_ERROR_AXFR'
			$message[2] = 'DNS zone transfer failed.'

		Case 9753
			$message[1] = 'DNS_INFO_ADDED_LOCAL_WINS'
			$message[2] = 'Added local WINS server.'

		Case 9801
			$message[1] = 'DNS_STATUS_CONTINUE_NEEDED'
			$message[2] = 'Secure update call needs to continue update request.'

		Case 9851
			$message[1] = 'DNS_ERROR_NO_TCPIP'
			$message[2] = 'TCP/IP network protocol not installed.'

		Case 9852
			$message[1] = 'DNS_ERROR_NO_DNS_SERVERS'
			$message[2] = 'No DNS servers configured for local system.'

		Case 9901
			$message[1] = 'DNS_ERROR_DP_DOES_NOT_EXIST'
			$message[2] = 'The specified directory partition does not exist.'

		Case 9902
			$message[1] = 'DNS_ERROR_DP_ALREADY_EXISTS'
			$message[2] = 'The specified directory partition already exists.'

		Case 9903
			$message[1] = 'DNS_ERROR_DP_NOT_ENLISTED'
			$message[2] = 'This DNS server is not enlisted in the specified directory partition.'

		Case 9904
			$message[1] = 'DNS_ERROR_DP_ALREADY_ENLISTED'
			$message[2] = 'This DNS server is already enlisted in the specified directory partition.'

		Case 9905
			$message[1] = 'DNS_ERROR_DP_NOT_AVAILABLE'
			$message[2] = 'The directory partition is not available at this time. Please wait a few minutes and try again.'

		Case 9906
			$message[1] = 'DNS_ERROR_DP_FSMO_ERROR'
			$message[2] = 'The application directory partition operation failed. The domain controller holding the domain naming master role is down or unable to service the request or is not running Windows Server 2003.'

		Case 10004
			$message[1] = 'WSAEINTR'
			$message[2] = 'A blocking operation was interrupted by a call to WSACancelBlockingCall.'

		Case 10009
			$message[1] = 'WSAEBADF'
			$message[2] = 'The file handle supplied is not valid.'

		Case 10013
			$message[1] = 'WSAEACCES'
			$message[2] = 'An attempt was made to access a socket in a way forbidden by its access permissions.'

		Case 10014
			$message[1] = 'WSAEFAULT'
			$message[2] = 'The system detected an invalid pointer address in attempting to use a pointer argument in a call.'

		Case 10022
			$message[1] = 'WSAEINVAL'
			$message[2] = 'An invalid argument was supplied.'

		Case 10024
			$message[1] = 'WSAEMFILE'
			$message[2] = 'Too many open sockets.'

		Case 10035
			$message[1] = 'WSAEWOULDBLOCK'
			$message[2] = 'A non-blocking socket operation could not be completed immediately.'

		Case 10036
			$message[1] = 'WSAEINPROGRESS'
			$message[2] = 'A blocking operation is currently executing.'

		Case 10037
			$message[1] = 'WSAEALREADY'
			$message[2] = 'An operation was attempted on a non-blocking socket that already had an operation in progress.'

		Case 10038
			$message[1] = 'WSAENOTSOCK'
			$message[2] = 'An operation was attempted on something that is not a socket.'

		Case 10039
			$message[1] = 'WSAEDESTADDRREQ'
			$message[2] = 'A required address was omitted from an operation on a socket.'

		Case 10040
			$message[1] = 'WSAEMSGSIZE'
			$message[2] = 'A message sent on a datagram socket was larger than the internal message buffer or some other network limit, or the buffer used to receive a datagram into was smaller than the datagram itself.'

		Case 10041
			$message[1] = 'WSAEPROTOTYPE'
			$message[2] = 'A protocol was specified in the socket function call that does not support the semantics of the socket type requested.'

		Case 10042
			$message[1] = 'WSAENOPROTOOPT'
			$message[2] = 'An unknown, invalid, or unsupported option or level was specified in a getsockopt or setsockopt call.'

		Case 10043
			$message[1] = 'WSAEPROTONOSUPPORT'
			$message[2] = 'The requested protocol has not been configured into the system, or no implementation for it exists.'

		Case 10044
			$message[1] = 'WSAESOCKTNOSUPPORT'
			$message[2] = 'The support for the specified socket type does not exist in this address family.'

		Case 10045
			$message[1] = 'WSAEOPNOTSUPP'
			$message[2] = 'The attempted operation is not supported for the type of object referenced.'

		Case 10046
			$message[1] = 'WSAEPFNOSUPPORT'
			$message[2] = 'The protocol family has not been configured into the system or no implementation for it exists.'

		Case 10047
			$message[1] = 'WSAEAFNOSUPPORT'
			$message[2] = 'An address incompatible with the requested protocol was used.'

		Case 10048
			$message[1] = 'WSAEADDRINUSE'
			$message[2] = 'Only one usage of each socket address (protocol/network address/port) is normally permitted.'

		Case 10049
			$message[1] = 'WSAEADDRNOTAVAIL'
			$message[2] = 'The requested address is not valid in its context.'

		Case 10050
			$message[1] = 'WSAENETDOWN'
			$message[2] = 'A socket operation encountered a dead network.'

		Case 10051
			$message[1] = 'WSAENETUNREACH'
			$message[2] = 'A socket operation was attempted to an unreachable network.'

		Case 10052
			$message[1] = 'WSAENETRESET'
			$message[2] = 'The connection has been broken due to keep-alive activity detecting a failure while the operation was in progress.'

		Case 10053
			$message[1] = 'WSAECONNABORTED'
			$message[2] = 'An established connection was aborted by the software in your host machine.'

		Case 10054
			$message[1] = 'WSAECONNRESET'
			$message[2] = 'An existing connection was forcibly closed by the remote host.'

		Case 10055
			$message[1] = 'WSAENOBUFS'
			$message[2] = 'An operation on a socket could not be performed because the system lacked sufficient buffer space or because a queue was full.'

		Case 10056
			$message[1] = 'WSAEISCONN'
			$message[2] = 'A connect request was made on an already connected socket.'

		Case 10057
			$message[1] = 'WSAENOTCONN'
			$message[2] = 'A request to send or receive data was disallowed because the socket is not connected and (when sending on a datagram socket using a sendto call) no address was supplied.'

		Case 10058
			$message[1] = 'WSAESHUTDOWN'
			$message[2] = 'A request to send or receive data was disallowed because the socket had already been shut down in that direction with a previous shutdown call.'

		Case 10059
			$message[1] = 'WSAETOOMANYREFS'
			$message[2] = 'Too many references to some kernel object.'

		Case 10060
			$message[1] = 'WSAETIMEDOUT'
			$message[2] = 'A connection attempt failed because the connected party did not properly respond after a period of time, or established connection failed because connected host has failed to respond.'

		Case 10061
			$message[1] = 'WSAECONNREFUSED'
			$message[2] = 'No connection could be made because the target machine actively refused it.'

		Case 10062
			$message[1] = 'WSAELOOP'
			$message[2] = 'Cannot translate name.'

		Case 10063
			$message[1] = 'WSAENAMETOOLONG'
			$message[2] = 'Name component or name was too long.'

		Case 10064
			$message[1] = 'WSAEHOSTDOWN'
			$message[2] = 'A socket operation failed because the destination host was down.'

		Case 10065
			$message[1] = 'WSAEHOSTUNREACH'
			$message[2] = 'A socket operation was attempted to an unreachable host.'

		Case 10066
			$message[1] = 'WSAENOTEMPTY'
			$message[2] = 'Cannot remove a directory that is not empty.'

		Case 10067
			$message[1] = 'WSAEPROCLIM'
			$message[2] = 'A Windows Sockets implementation may have a limit on the number of applications that may use it simultaneously.'

		Case 10068
			$message[1] = 'WSAEUSERS'
			$message[2] = 'Ran out of quota.'

		Case 10069
			$message[1] = 'WSAEDQUOT'
			$message[2] = 'Ran out of disk quota.'

		Case 10070
			$message[1] = 'WSAESTALE'
			$message[2] = 'File handle reference is no longer available.'

		Case 10071
			$message[1] = 'WSAEREMOTE'
			$message[2] = 'Item is not available locally.'

		Case 10091
			$message[1] = 'WSASYSNOTREADY'
			$message[2] = 'WSAStartup cannot function at this time because the underlying system it uses to provide network services is currently unavailable.'

		Case 10092
			$message[1] = 'WSAVERNOTSUPPORTED'
			$message[2] = 'The Windows Sockets version requested is not supported.'

		Case 10093
			$message[1] = 'WSANOTINITIALISED'
			$message[2] = 'Either the application has not called WSAStartup, or WSAStartup failed.'

		Case 10101
			$message[1] = 'WSAEDISCON'
			$message[2] = 'Returned by WSARecv or WSARecvFrom to indicate the remote party has initiated a graceful shutdown sequence.'

		Case 10102
			$message[1] = 'WSAENOMORE'
			$message[2] = 'No more results can be returned by WSALookupServiceNext.'

		Case 10103
			$message[1] = 'WSAECANCELLED'
			$message[2] = 'A call to WSALookupServiceEnd was made while this call was still processing. The call has been canceled.'

		Case 10104
			$message[1] = 'WSAEINVALIDPROCTABLE'
			$message[2] = 'The procedure call table is invalid.'

		Case 10105
			$message[1] = 'WSAEINVALIDPROVIDER'
			$message[2] = 'The requested service provider is invalid.'

		Case 10106
			$message[1] = 'WSAEPROVIDERFAILEDINIT'
			$message[2] = 'The requested service provider could not be loaded or initialized.'

		Case 10107
			$message[1] = 'WSASYSCALLFAILURE'
			$message[2] = 'A system call that should never fail has failed.'

		Case 10108
			$message[1] = 'WSASERVICE_NOT_FOUND'
			$message[2] = 'No such service is known. The service cannot be found in the specified name space.'

		Case 10109
			$message[1] = 'WSATYPE_NOT_FOUND'
			$message[2] = 'The specified class was not found.'

		Case 10110
			$message[1] = 'WSA_E_NO_MORE'
			$message[2] = 'No more results can be returned by WSALookupServiceNext.'

		Case 10111
			$message[1] = 'WSA_E_CANCELLED'
			$message[2] = 'A call to WSALookupServiceEnd was made while this call was still processing. The call has been canceled.'

		Case 10112
			$message[1] = 'WSAEREFUSED'
			$message[2] = 'A database query failed because it was actively refused.'

		Case 11001
			$message[1] = 'WSAHOST_NOT_FOUND'
			$message[2] = 'No such host is known.'

		Case 11002
			$message[1] = 'WSATRY_AGAIN'
			$message[2] = 'This is usually a temporary error during hostname resolution and means that the local server did not receive a response from an authoritative server.'

		Case 11003
			$message[1] = 'WSANO_RECOVERY'
			$message[2] = 'A non-recoverable error occurred during a database lookup.'

		Case 11004
			$message[1] = 'WSANO_DATA'
			$message[2] = 'The requested name is valid, but no data of the requested type was found.'

		Case 11005
			$message[1] = 'WSA_QOS_RECEIVERS'
			$message[2] = 'At least one reserve has arrived.'

		Case 11006
			$message[1] = 'WSA_QOS_SENDERS'
			$message[2] = 'At least one path has arrived.'

		Case 11007
			$message[1] = 'WSA_QOS_NO_SENDERS'
			$message[2] = 'There are no senders.'

		Case 11008
			$message[1] = 'WSA_QOS_NO_RECEIVERS'
			$message[2] = 'There are no receivers.'

		Case 11009
			$message[1] = 'WSA_QOS_REQUEST_CONFIRMED'
			$message[2] = 'Reserve has been confirmed.'

		Case 11010
			$message[1] = 'WSA_QOS_ADMISSION_FAILURE'
			$message[2] = 'Error due to lack of resources.'

		Case 11011
			$message[1] = 'WSA_QOS_POLICY_FAILURE'
			$message[2] = 'Rejected for administrative reasons - bad credentials.'

		Case 11012
			$message[1] = 'WSA_QOS_BAD_STYLE'
			$message[2] = 'Unknown or conflicting style.'

		Case 11013
			$message[1] = 'WSA_QOS_BAD_OBJECT'
			$message[2] = 'Problem with some part of the filterspec or providerspecific buffer in general.'

		Case 11014
			$message[1] = 'WSA_QOS_TRAFFIC_CTRL_ERROR'
			$message[2] = 'Problem with some part of the flowspec.'

		Case 11015
			$message[1] = 'WSA_QOS_GENERIC_ERROR'
			$message[2] = 'General QOS error.'

		Case 11016
			$message[1] = 'WSA_QOS_ESERVICETYPE'
			$message[2] = 'An invalid or unrecognized service type was found in the flowspec.'

		Case 11017
			$message[1] = 'WSA_QOS_EFLOWSPEC'
			$message[2] = 'An invalid or inconsistent flowspec was found in the QOS structure.'

		Case 11018
			$message[1] = 'WSA_QOS_EPROVSPECBUF'
			$message[2] = 'Invalid QOS provider-specific buffer.'

		Case 11019
			$message[1] = 'WSA_QOS_EFILTERSTYLE'
			$message[2] = 'An invalid QOS filter style was used.'

		Case 11020
			$message[1] = 'WSA_QOS_EFILTERTYPE'
			$message[2] = 'An invalid QOS filter type was used.'

		Case 11021
			$message[1] = 'WSA_QOS_EFILTERCOUNT'
			$message[2] = 'An incorrect number of QOS FILTERSPECs were specified in the FLOWDESCRIPTOR.'

		Case 11022
			$message[1] = 'WSA_QOS_EOBJLENGTH'
			$message[2] = 'An object with an invalid ObjectLength field was specified in the QOS provider-specific buffer.'

		Case 11023
			$message[1] = 'WSA_QOS_EFLOWCOUNT'
			$message[2] = 'An incorrect number of flow descriptors was specified in the QOS structure.'

		Case 11024
			$message[1] = 'WSA_QOS_EUNKOWNPSOBJ'
			$message[2] = 'An unrecognized object was found in the QOS provider-specific buffer.'

		Case 11025
			$message[1] = 'WSA_QOS_EPOLICYOBJ'
			$message[2] = 'An invalid policy object was found in the QOS provider-specific buffer.'

		Case 11026
			$message[1] = 'WSA_QOS_EFLOWDESC'
			$message[2] = 'An invalid QOS flow descriptor was found in the flow descriptor list.'

		Case 11027
			$message[1] = 'WSA_QOS_EPSFLOWSPEC'
			$message[2] = 'An invalid or inconsistent flowspec was found in the QOS provider specific buffer.'

		Case 11028
			$message[1] = 'WSA_QOS_EPSFILTERSPEC'
			$message[2] = 'An invalid FILTERSPEC was found in the QOS provider-specific buffer.'

		Case 11029
			$message[1] = 'WSA_QOS_ESDMODEOBJ'
			$message[2] = 'An invalid shape discard mode object was found in the QOS provider specific buffer.'

		Case 11030
			$message[1] = 'WSA_QOS_ESHAPERATEOBJ'
			$message[2] = 'An invalid shaping rate object was found in the QOS provider-specific buffer.'

		Case 11031
			$message[1] = 'WSA_QOS_RESERVED_PETYPE'
			$message[2] = 'A reserved policy element was found in the QOS provider-specific buffer.'

		Case 12000
			$message[1] = 'ERROR_INTERNET_* (see Wininet.h)'
			$message[2] = '- 12174 Internet Error Codes'

		Case 13000
			$message[1] = 'ERROR_IPSEC_QM_POLICY_EXISTS'
			$message[2] = 'The specified quick mode policy already exists.'

		Case 13001
			$message[1] = 'ERROR_IPSEC_QM_POLICY_NOT_FOUND'
			$message[2] = 'The specified quick mode policy was not found.'

		Case 13002
			$message[1] = 'ERROR_IPSEC_QM_POLICY_IN_USE'
			$message[2] = 'The specified quick mode policy is being used.'

		Case 13003
			$message[1] = 'ERROR_IPSEC_MM_POLICY_EXISTS'
			$message[2] = 'The specified main mode policy already exists.'

		Case 13004
			$message[1] = 'ERROR_IPSEC_MM_POLICY_NOT_FOUND'
			$message[2] = 'The specified main mode policy was not found'

		Case 13005
			$message[1] = 'ERROR_IPSEC_MM_POLICY_IN_USE'
			$message[2] = 'The specified main mode policy is being used.'

		Case 13006
			$message[1] = 'ERROR_IPSEC_MM_FILTER_EXISTS'
			$message[2] = 'The specified main mode filter already exists.'

		Case 13007
			$message[1] = 'ERROR_IPSEC_MM_FILTER_NOT_FOUND'
			$message[2] = 'The specified main mode filter was not found.'

		Case 13008
			$message[1] = 'ERROR_IPSEC_TRANSPORT_FILTER_EXISTS'
			$message[2] = 'The specified transport mode filter already exists.'

		Case 13009
			$message[1] = 'ERROR_IPSEC_TRANSPORT_FILTER_NOT_FOUND'
			$message[2] = 'The specified transport mode filter does not exist.'

		Case 13010
			$message[1] = 'ERROR_IPSEC_MM_AUTH_EXISTS'
			$message[2] = 'The specified main mode authentication list exists.'

		Case 13011
			$message[1] = 'ERROR_IPSEC_MM_AUTH_NOT_FOUND'
			$message[2] = 'The specified main mode authentication list was not found.'

		Case 13012
			$message[1] = 'ERROR_IPSEC_MM_AUTH_IN_USE'
			$message[2] = 'The specified main mode authentication list is being used.'

		Case 13013
			$message[1] = 'ERROR_IPSEC_DEFAULT_MM_POLICY_NOT_FOUND'
			$message[2] = 'The specified default main mode policy was not found.'

		Case 13014
			$message[1] = 'ERROR_IPSEC_DEFAULT_MM_AUTH_NOT_FOUND'
			$message[2] = 'The specified default main mode authentication list was not found.'

		Case 13015
			$message[1] = 'ERROR_IPSEC_DEFAULT_QM_POLICY_NOT_FOUND'
			$message[2] = 'The specified default quick mode policy was not found.'

		Case 13016
			$message[1] = 'ERROR_IPSEC_TUNNEL_FILTER_EXISTS'
			$message[2] = 'The specified tunnel mode filter exists.'

		Case 13017
			$message[1] = 'ERROR_IPSEC_TUNNEL_FILTER_NOT_FOUND'
			$message[2] = 'The specified tunnel mode filter was not found.'

		Case 13018
			$message[1] = 'ERROR_IPSEC_MM_FILTER_PENDING_DELETION'
			$message[2] = 'The Main Mode filter is pending deletion.'

		Case 13019
			$message[1] = 'ERROR_IPSEC_TRANSPORT_FILTER_PENDING_DELETION'
			$message[2] = 'The transport filter is pending deletion.'

		Case 13020
			$message[1] = 'ERROR_IPSEC_TUNNEL_FILTER_PENDING_DELETION'
			$message[2] = 'The tunnel filter is pending deletion.'

		Case 13021
			$message[1] = 'ERROR_IPSEC_MM_POLICY_PENDING_DELETION'
			$message[2] = 'The Main Mode policy is pending deletion.'

		Case 13022
			$message[1] = 'ERROR_IPSEC_MM_AUTH_PENDING_DELETION'
			$message[2] = 'The Main Mode authentication bundle is pending deletion.'

		Case 13023
			$message[1] = 'ERROR_IPSEC_QM_POLICY_PENDING_DELETION'
			$message[2] = 'The Quick Mode policy is pending deletion.'

		Case 13024
			$message[1] = 'WARNING_IPSEC_MM_POLICY_PRUNED'
			$message[2] = 'The Main Mode policy was successfully added, but some of the requested offers are not supported.'

		Case 13025
			$message[1] = 'WARNING_IPSEC_QM_POLICY_PRUNED'
			$message[2] = 'The Quick Mode policy was successfully added, but some of the requested offers are not supported.'

		Case 13800
			$message[1] = 'ERROR_IPSEC_IKE_NEG_STATUS_BEGIN'
			$message[2] = 'ERROR_IPSEC_IKE_NEG_STATUS_BEGIN'

		Case 13801
			$message[1] = 'ERROR_IPSEC_IKE_AUTH_FAIL'
			$message[2] = 'IKE authentication credentials are unacceptable'

		Case 13802
			$message[1] = 'ERROR_IPSEC_IKE_ATTRIB_FAIL'
			$message[2] = 'IKE security attributes are unacceptable'

		Case 13803
			$message[1] = 'ERROR_IPSEC_IKE_NEGOTIATION_PENDING'
			$message[2] = 'IKE Negotiation in progress'

		Case 13804
			$message[1] = 'ERROR_IPSEC_IKE_GENERAL_PROCESSING_ERROR'
			$message[2] = 'General processing error'

		Case 13805
			$message[1] = 'ERROR_IPSEC_IKE_TIMED_OUT'
			$message[2] = 'Negotiation timed out'

		Case 13806
			$message[1] = 'ERROR_IPSEC_IKE_NO_CERT'
			$message[2] = 'IKE failed to find valid machine certificate. Contact your Network Security Administrator about installing a valid certificate in the appropriate Certificate Store.'

		Case 13807
			$message[1] = 'ERROR_IPSEC_IKE_SA_DELETED'
			$message[2] = 'IKE SA deleted by peer before establishment completed'

		Case 13808
			$message[1] = 'ERROR_IPSEC_IKE_SA_REAPED'
			$message[2] = 'IKE SA deleted before establishment completed'

		Case 13809
			$message[1] = 'ERROR_IPSEC_IKE_MM_ACQUIRE_DROP'
			$message[2] = 'Negotiation request sat in Queue too long'

		Case 13810
			$message[1] = 'ERROR_IPSEC_IKE_QM_ACQUIRE_DROP'
			$message[2] = 'Negotiation request sat in Queue too long'

		Case 13811
			$message[1] = 'ERROR_IPSEC_IKE_QUEUE_DROP_MM'
			$message[2] = 'Negotiation request sat in Queue too long'

		Case 13812
			$message[1] = 'ERROR_IPSEC_IKE_QUEUE_DROP_NO_MM'
			$message[2] = 'Negotiation request sat in Queue too long'

		Case 13813
			$message[1] = 'ERROR_IPSEC_IKE_DROP_NO_RESPONSE'
			$message[2] = 'No response from peer'

		Case 13814
			$message[1] = 'ERROR_IPSEC_IKE_MM_DELAY_DROP'
			$message[2] = 'Negotiation took too long'

		Case 13815
			$message[1] = 'ERROR_IPSEC_IKE_QM_DELAY_DROP'
			$message[2] = 'Negotiation took too long'

		Case 13816
			$message[1] = 'ERROR_IPSEC_IKE_ERROR'
			$message[2] = 'Unknown error occurred'

		Case 13817
			$message[1] = 'ERROR_IPSEC_IKE_CRL_FAILED'
			$message[2] = 'Certificate Revocation Check failed'

		Case 13818
			$message[1] = 'ERROR_IPSEC_IKE_INVALID_KEY_USAGE'
			$message[2] = 'Invalid certificate key usage'

		Case 13819
			$message[1] = 'ERROR_IPSEC_IKE_INVALID_CERT_TYPE'
			$message[2] = 'Invalid certificate type'

		Case 13820
			$message[1] = 'ERROR_IPSEC_IKE_NO_PRIVATE_KEY'
			$message[2] = 'IKE negotiation failed because the machine certificate used does not have a private key. IPsec certificates require a private key. Contact your Network Security administrator about replacing with a certificate that has a private key.'

		Case 13822
			$message[1] = 'ERROR_IPSEC_IKE_DH_FAIL'
			$message[2] = 'Failure in Diffie-Helman computation'

		Case 13824
			$message[1] = 'ERROR_IPSEC_IKE_INVALID_HEADER'
			$message[2] = 'Invalid header'

		Case 13825
			$message[1] = 'ERROR_IPSEC_IKE_NO_POLICY'
			$message[2] = 'No policy configured'

		Case 13826
			$message[1] = 'ERROR_IPSEC_IKE_INVALID_SIGNATURE'
			$message[2] = 'Failed to verify signature'

		Case 13827
			$message[1] = 'ERROR_IPSEC_IKE_KERBEROS_ERROR'
			$message[2] = 'Failed to authenticate using kerberos'

		Case 13828
			$message[1] = 'ERROR_IPSEC_IKE_NO_PUBLIC_KEY'
			$message[2] = 'Peer''s certificate did not have a public key'

		Case 13829
			$message[1] = 'ERROR_IPSEC_IKE_PROCESS_ERR'
			$message[2] = 'Error processing error payload'

		Case 13830
			$message[1] = 'ERROR_IPSEC_IKE_PROCESS_ERR_SA'
			$message[2] = 'Error processing SA payload'

		Case 13831
			$message[1] = 'ERROR_IPSEC_IKE_PROCESS_ERR_PROP'
			$message[2] = 'Error processing Proposal payload'

		Case 13832
			$message[1] = 'ERROR_IPSEC_IKE_PROCESS_ERR_TRANS'
			$message[2] = 'Error processing Transform payload'

		Case 13833
			$message[1] = 'ERROR_IPSEC_IKE_PROCESS_ERR_KE'
			$message[2] = 'Error processing KE payload'

		Case 13834
			$message[1] = 'ERROR_IPSEC_IKE_PROCESS_ERR_ID'
			$message[2] = 'Error processing ID payload'

		Case 13835
			$message[1] = 'ERROR_IPSEC_IKE_PROCESS_ERR_CERT'
			$message[2] = 'Error processing Cert payload'

		Case 13836
			$message[1] = 'ERROR_IPSEC_IKE_PROCESS_ERR_CERT_REQ'
			$message[2] = 'Error processing Certificate Request payload'

		Case 13837
			$message[1] = 'ERROR_IPSEC_IKE_PROCESS_ERR_HASH'
			$message[2] = 'Error processing Hash payload'

		Case 13838
			$message[1] = 'ERROR_IPSEC_IKE_PROCESS_ERR_SIG'
			$message[2] = 'Error processing Signature payload'

		Case 13839
			$message[1] = 'ERROR_IPSEC_IKE_PROCESS_ERR_NONCE'
			$message[2] = 'Error processing Nonce payload'

		Case 13840
			$message[1] = 'ERROR_IPSEC_IKE_PROCESS_ERR_NOTIFY'
			$message[2] = 'Error processing Notify payload'

		Case 13841
			$message[1] = 'ERROR_IPSEC_IKE_PROCESS_ERR_DELETE'
			$message[2] = 'Error processing Delete Payload'

		Case 13842
			$message[1] = 'ERROR_IPSEC_IKE_PROCESS_ERR_VENDOR'
			$message[2] = 'Error processing VendorId payload'

		Case 13843
			$message[1] = 'ERROR_IPSEC_IKE_INVALID_PAYLOAD'
			$message[2] = 'Invalid payload received'

		Case 13844
			$message[1] = 'ERROR_IPSEC_IKE_LOAD_SOFT_SA'
			$message[2] = 'Soft SA loaded'

		Case 13845
			$message[1] = 'ERROR_IPSEC_IKE_SOFT_SA_TORN_DOWN'
			$message[2] = 'Soft SA torn down'

		Case 13846
			$message[1] = 'ERROR_IPSEC_IKE_INVALID_COOKIE'
			$message[2] = 'Invalid cookie received.'

		Case 13847
			$message[1] = 'ERROR_IPSEC_IKE_NO_PEER_CERT'
			$message[2] = 'Peer failed to send valid machine certificate'

		Case 13848
			$message[1] = 'ERROR_IPSEC_IKE_PEER_CRL_FAILED'
			$message[2] = 'Certification Revocation check of peer''s certificate failed'

		Case 13849
			$message[1] = 'ERROR_IPSEC_IKE_POLICY_CHANGE'
			$message[2] = 'New policy invalidated SAs formed with old policy'

		Case 13850
			$message[1] = 'ERROR_IPSEC_IKE_NO_MM_POLICY'
			$message[2] = 'There is no available Main Mode IKE policy.'

		Case 13851
			$message[1] = 'ERROR_IPSEC_IKE_NOTCBPRIV'
			$message[2] = 'Failed to enabled TCB privilege.'

		Case 13852
			$message[1] = 'ERROR_IPSEC_IKE_SECLOADFAIL'
			$message[2] = 'Failed to load SECURITY.DLL.'

		Case 13853
			$message[1] = 'ERROR_IPSEC_IKE_FAILSSPINIT'
			$message[2] = 'Failed to obtain security function table dispatch address from SSPI.'

		Case 13854
			$message[1] = 'ERROR_IPSEC_IKE_FAILQUERYSSP'
			$message[2] = 'Failed to query Kerberos package to obtain max token size.'

		Case 13855
			$message[1] = 'ERROR_IPSEC_IKE_SRVACQFAIL'
			$message[2] = 'Failed to obtain Kerberos server credentials for ISAKMP/ERROR_IPSEC_IKE service. Kerberos authentication will not function. The most likely reason for this is lack of domain membership. This is normal if your computer is a member of a workgroup.'

		Case 13856
			$message[1] = 'ERROR_IPSEC_IKE_SRVQUERYCRED'
			$message[2] = 'Failed to determine SSPI principal name for ISAKMP/ERROR_IPSEC_IKE service (QueryCredentialsAttributes).'

		Case 13857
			$message[1] = 'ERROR_IPSEC_IKE_GETSPIFAIL'
			$message[2] = 'Failed to obtain new SPI for the inbound SA from Ipsec driver. The most common cause for this is that the driver does not have the correct filter. Check your policy to verify the filters.'

		Case 13858
			$message[1] = 'ERROR_IPSEC_IKE_INVALID_FILTER'
			$message[2] = 'Given filter is invalid'

		Case 13859
			$message[1] = 'ERROR_IPSEC_IKE_OUT_OF_MEMORY'
			$message[2] = 'Memory allocation failed.'

		Case 13860
			$message[1] = 'ERROR_IPSEC_IKE_ADD_UPDATE_KEY_FAILED'
			$message[2] = 'Failed to add Security Association to IPSec Driver. The most common cause for this is if the IKE negotiation took too long to complete. If the problem persists, reduce the load on the faulting machine.'

		Case 13861
			$message[1] = 'ERROR_IPSEC_IKE_INVALID_POLICY'
			$message[2] = 'Invalid policy'

		Case 13862
			$message[1] = 'ERROR_IPSEC_IKE_UNKNOWN_DOI'
			$message[2] = 'Invalid DOI'

		Case 13863
			$message[1] = 'ERROR_IPSEC_IKE_INVALID_SITUATION'
			$message[2] = 'Invalid situation'

		Case 13864
			$message[1] = 'ERROR_IPSEC_IKE_DH_FAILURE'
			$message[2] = 'Diffie-Hellman failure'

		Case 13865
			$message[1] = 'ERROR_IPSEC_IKE_INVALID_GROUP'
			$message[2] = 'Invalid Diffie-Hellman group'

		Case 13866
			$message[1] = 'ERROR_IPSEC_IKE_ENCRYPT'
			$message[2] = 'Error encrypting payload'

		Case 13867
			$message[1] = 'ERROR_IPSEC_IKE_DECRYPT'
			$message[2] = 'Error decrypting payload'

		Case 13868
			$message[1] = 'ERROR_IPSEC_IKE_POLICY_MATCH'
			$message[2] = 'Policy match error'

		Case 13869
			$message[1] = 'ERROR_IPSEC_IKE_UNSUPPORTED_ID'
			$message[2] = 'Unsupported ID'

		Case 13870
			$message[1] = 'ERROR_IPSEC_IKE_INVALID_HASH'
			$message[2] = 'Hash verification failed'

		Case 13871
			$message[1] = 'ERROR_IPSEC_IKE_INVALID_HASH_ALG'
			$message[2] = 'Invalid hash algorithm'

		Case 13872
			$message[1] = 'ERROR_IPSEC_IKE_INVALID_HASH_SIZE'
			$message[2] = 'Invalid hash size'

		Case 13873
			$message[1] = 'ERROR_IPSEC_IKE_INVALID_ENCRYPT_ALG'
			$message[2] = 'Invalid encryption algorithm'

		Case 13874
			$message[1] = 'ERROR_IPSEC_IKE_INVALID_AUTH_ALG'
			$message[2] = 'Invalid authentication algorithm'

		Case 13875
			$message[1] = 'ERROR_IPSEC_IKE_INVALID_SIG'
			$message[2] = 'Invalid certificate signature'

		Case 13876
			$message[1] = 'ERROR_IPSEC_IKE_LOAD_FAILED'
			$message[2] = 'Load failed'

		Case 13877
			$message[1] = 'ERROR_IPSEC_IKE_RPC_DELETE'
			$message[2] = 'Deleted via RPC call'

		Case 13878
			$message[1] = 'ERROR_IPSEC_IKE_BENIGN_REINIT'
			$message[2] = 'Temporary state created to perform reinit. This is not a real failure.'

		Case 13879
			$message[1] = 'ERROR_IPSEC_IKE_INVALID_RESPONDER_LIFETIME_NOTIFY'
			$message[2] = 'The lifetime value received in the Responder Lifetime Notify is below the Windows 2000 configured minimum value. Please fix the policy on the peer machine.'

		Case 13881
			$message[1] = 'ERROR_IPSEC_IKE_INVALID_CERT_KEYLEN'
			$message[2] = 'Key length in certificate is too small for configured security requirements.'

		Case 13882
			$message[1] = 'ERROR_IPSEC_IKE_MM_LIMIT'
			$message[2] = 'Max number of established MM SAs to peer exceeded.'

		Case 13883
			$message[1] = 'ERROR_IPSEC_IKE_NEGOTIATION_DISABLED'
			$message[2] = 'IKE received a policy that disables negotiation.'

		Case 13884
			$message[1] = 'ERROR_IPSEC_IKE_QM_LIMIT'
			$message[2] = 'Reached maximum quick mode limit for the main mode. New main mode will be started.'

		Case 13885
			$message[1] = 'ERROR_IPSEC_IKE_MM_EXPIRED'
			$message[2] = 'Main mode SA lifetime expired or peer sent a main mode delete.'

		Case 13886
			$message[1] = 'ERROR_IPSEC_IKE_PEER_MM_ASSUMED_INVALID'
			$message[2] = 'Main mode SA assumed to be invalid because peer stopped responding.'

		Case 13887
			$message[1] = 'ERROR_IPSEC_IKE_CERT_CHAIN_POLICY_MISMATCH'
			$message[2] = 'Certificate doesn''t chain to a trusted root in IPsec policy.'

		Case 13888
			$message[1] = 'ERROR_IPSEC_IKE_UNEXPECTED_MESSAGE_ID'
			$message[2] = 'Received unexpected message ID.'

		Case 13889
			$message[1] = 'ERROR_IPSEC_IKE_INVALID_AUTH_PAYLOAD'
			$message[2] = 'Received invalid authentication offers.'

		Case 13890
			$message[1] = 'ERROR_IPSEC_IKE_DOS_COOKIE_SENT'
			$message[2] = 'Sent DOS cookie notify to intiator.'

		Case 13891
			$message[1] = 'ERROR_IPSEC_IKE_SHUTTING_DOWN'
			$message[2] = 'IKE service is shutting down.'

		Case 13892
			$message[1] = 'ERROR_IPSEC_IKE_CGA_AUTH_FAILED'
			$message[2] = 'Could not verify binding between CGA address and certificate.'

		Case 13893
			$message[1] = 'ERROR_IPSEC_IKE_PROCESS_ERR_NATOA'
			$message[2] = 'Error processing NatOA payload.'

		Case 13894
			$message[1] = 'ERROR_IPSEC_IKE_INVALID_MM_FOR_QM'
			$message[2] = 'Parameters of the main mode are invalid for this quick mode.'

		Case 13895
			$message[1] = 'ERROR_IPSEC_IKE_QM_EXPIRED'
			$message[2] = 'Quick mode SA was expired by IPsec driver.'

		Case 13896
			$message[1] = 'ERROR_IPSEC_IKE_TOO_MANY_FILTERS'
			$message[2] = 'Too many dynamically added IKEEXT filters were detected.'

		Case 13910
			$message[1] = 'ERROR_IPSEC_BAD_SPI'
			$message[2] = 'The SPI in the packet does not match a valid IPsec SA.'

		Case 13911
			$message[1] = 'ERROR_IPSEC_SA_LIFETIME_EXPIRED'
			$message[2] = 'Packet was received on an IPsec SA whose lifetime has expired.'

		Case 13912
			$message[1] = 'ERROR_IPSEC_WRONG_SA'
			$message[2] = 'Packet was received on an IPsec SA that doesn''t match the packet characteristics.'

		Case 13913
			$message[1] = 'ERROR_IPSEC_REPLAY_CHECK_FAILED'
			$message[2] = 'Packet sequence number replay check failed.'

		Case 13914
			$message[1] = 'ERROR_IPSEC_INVALID_PACKET'
			$message[2] = 'IPsec header and/or trailer in the packet is invalid.'

		Case 13915
			$message[1] = 'ERROR_IPSEC_INTEGRITY_CHECK_FAILED'
			$message[2] = 'IPsec integrity check failed.'

		Case 13916
			$message[1] = 'ERROR_IPSEC_CLEAR_TEXT_DROP'
			$message[2] = 'IPsec dropped a clear text packet.'

		Case 14000
			$message[1] = 'ERROR_SXS_SECTION_NOT_FOUND'
			$message[2] = 'The requested section was not present in the activation context.'

		Case 14001
			$message[1] = 'ERROR_SXS_CANT_GEN_ACTCTX'
			$message[2] = 'The application has failed to start because its side-by-side configuration is incorrect. Please see the application event log for more detail.'

		Case 14002
			$message[1] = 'ERROR_SXS_INVALID_ACTCTXDATA_FORMAT'
			$message[2] = 'The application binding data format is invalid.'

		Case 14003
			$message[1] = 'ERROR_SXS_ASSEMBLY_NOT_FOUND'
			$message[2] = 'The referenced assembly is not installed on your system.'

		Case 14004
			$message[1] = 'ERROR_SXS_MANIFEST_FORMAT_ERROR'
			$message[2] = 'The manifest file does not begin with the required tag and format information.'

		Case 14005
			$message[1] = 'ERROR_SXS_MANIFEST_PARSE_ERROR'
			$message[2] = 'The manifest file contains one or more syntax errors.'

		Case 14006
			$message[1] = 'ERROR_SXS_ACTIVATION_CONTEXT_DISABLED'
			$message[2] = 'The application attempted to activate a disabled activation context.'

		Case 14007
			$message[1] = 'ERROR_SXS_KEY_NOT_FOUND'
			$message[2] = 'The requested lookup key was not found in any active activation context.'

		Case 14008
			$message[1] = 'ERROR_SXS_VERSION_CONFLICT'
			$message[2] = 'A component version required by the application conflicts with another component version already active.'

		Case 14009
			$message[1] = 'ERROR_SXS_WRONG_SECTION_TYPE'
			$message[2] = 'The type requested activation context section does not match the query API used.'

		Case 14010
			$message[1] = 'ERROR_SXS_THREAD_QUERIES_DISABLED'
			$message[2] = 'Lack of system resources has required isolated activation to be disabled for the current thread of execution.'

		Case 14011
			$message[1] = 'ERROR_SXS_PROCESS_DEFAULT_ALREADY_SET'
			$message[2] = 'An attempt to set the process default activation context failed because the process default activation context was already set.'

		Case 14012
			$message[1] = 'ERROR_SXS_UNKNOWN_ENCODING_GROUP'
			$message[2] = 'The encoding group identifier specified is not recognized.'

		Case 14013
			$message[1] = 'ERROR_SXS_UNKNOWN_ENCODING'
			$message[2] = 'The encoding requested is not recognized.'

		Case 14014
			$message[1] = 'ERROR_SXS_INVALID_XML_NAMESPACE_URI'
			$message[2] = 'The manifest contains a reference to an invalid URI.'

		Case 14015
			$message[1] = 'ERROR_SXS_ROOT_MANIFEST_DEPENDENCY_NOT_INSTALLED'
			$message[2] = 'The application manifest contains a reference to a dependent assembly which is not installed'

		Case 14016
			$message[1] = 'ERROR_SXS_LEAF_MANIFEST_DEPENDENCY_NOT_INSTALLED'
			$message[2] = 'The manifest for an assembly used by the application has a reference to a dependent assembly which is not installed'

		Case 14017
			$message[1] = 'ERROR_SXS_INVALID_ASSEMBLY_IDENTITY_ATTRIBUTE'
			$message[2] = 'The manifest contains an attribute for the assembly identity which is not valid.'

		Case 14018
			$message[1] = 'ERROR_SXS_MANIFEST_MISSING_REQUIRED_DEFAULT_NAMESPACE'
			$message[2] = 'The manifest is missing the required default namespace specification on the assembly element.'

		Case 14019
			$message[1] = 'ERROR_SXS_MANIFEST_INVALID_REQUIRED_DEFAULT_NAMESPACE'
			$message[2] = 'The manifest has a default namespace specified on the assembly element but its value is not "urn:schemas-microsoft-com:asm.v1".'

		Case 14020
			$message[1] = 'ERROR_SXS_PRIVATE_MANIFEST_CROSS_PATH_WITH_REPARSE_POINT'
			$message[2] = 'The private manifest probed has crossed reparse-point-associated path'

		Case 14021
			$message[1] = 'ERROR_SXS_DUPLICATE_DLL_NAME'
			$message[2] = 'Two or more components referenced directly or indirectly by the application manifest have files by the same name.'

		Case 14022
			$message[1] = 'ERROR_SXS_DUPLICATE_WINDOWCLASS_NAME'
			$message[2] = 'Two or more components referenced directly or indirectly by the application manifest have window classes with the same name.'

		Case 14023
			$message[1] = 'ERROR_SXS_DUPLICATE_CLSID'
			$message[2] = 'Two or more components referenced directly or indirectly by the application manifest have the same COM server CLSIDs.'

		Case 14024
			$message[1] = 'ERROR_SXS_DUPLICATE_IID'
			$message[2] = 'Two or more components referenced directly or indirectly by the application manifest have proxies for the same COM interface IIDs.'

		Case 14025
			$message[1] = 'ERROR_SXS_DUPLICATE_TLBID'
			$message[2] = 'Two or more components referenced directly or indirectly by the application manifest have the same COM type library TLBIDs.'

		Case 14026
			$message[1] = 'ERROR_SXS_DUPLICATE_PROGID'
			$message[2] = 'Two or more components referenced directly or indirectly by the application manifest have the same COM ProgIDs.'

		Case 14027
			$message[1] = 'ERROR_SXS_DUPLICATE_ASSEMBLY_NAME'
			$message[2] = 'Two or more components referenced directly or indirectly by the application manifest are different versions of the same component which is not permitted.'

		Case 14028
			$message[1] = 'ERROR_SXS_FILE_HASH_MISMATCH'
			$message[2] = 'A component''s file does not match the verification information present in the component manifest.'

		Case 14029
			$message[1] = 'ERROR_SXS_POLICY_PARSE_ERROR'
			$message[2] = 'The policy manifest contains one or more syntax errors.'

		Case 14030
			$message[1] = 'ERROR_SXS_XML_E_MISSINGQUOTE'
			$message[2] = 'Manifest Parse Error : A string literal was expected, but no opening quote character was found.'

		Case 14031
			$message[1] = 'ERROR_SXS_XML_E_COMMENTSYNTAX'
			$message[2] = 'Manifest Parse Error : Incorrect syntax was used in a comment.'

		Case 14032
			$message[1] = 'ERROR_SXS_XML_E_BADSTARTNAMECHAR'
			$message[2] = 'Manifest Parse Error : A name was started with an invalid character.'

		Case 14033
			$message[1] = 'ERROR_SXS_XML_E_BADNAMECHAR'
			$message[2] = 'Manifest Parse Error : A name contained an invalid character.'

		Case 14034
			$message[1] = 'ERROR_SXS_XML_E_BADCHARINSTRING'
			$message[2] = 'Manifest Parse Error : A string literal contained an invalid character.'

		Case 14035
			$message[1] = 'ERROR_SXS_XML_E_XMLDECLSYNTAX'
			$message[2] = 'Manifest Parse Error : Invalid syntax for an xml declaration.'

		Case 14036
			$message[1] = 'ERROR_SXS_XML_E_BADCHARDATA'
			$message[2] = 'Manifest Parse Error : An Invalid character was found in text content.'

		Case 14037
			$message[1] = 'ERROR_SXS_XML_E_MISSINGWHITESPACE'
			$message[2] = 'Manifest Parse Error : Required white space was missing.'

		Case 14038
			$message[1] = 'ERROR_SXS_XML_E_EXPECTINGTAGEND'
			$message[2] = 'Manifest Parse Error : The character ''>'' was expected.'

		Case 14039
			$message[1] = 'ERROR_SXS_XML_E_MISSINGSEMICOLON'
			$message[2] = 'Manifest Parse Error : A semi colon character was expected.'

		Case 14040
			$message[1] = 'ERROR_SXS_XML_E_UNBALANCEDPAREN'
			$message[2] = 'Manifest Parse Error : Unbalanced parentheses.'

		Case 14041
			$message[1] = 'ERROR_SXS_XML_E_INTERNALERROR'
			$message[2] = 'Manifest Parse Error : Internal error.'

		Case 14042
			$message[1] = 'ERROR_SXS_XML_E_UNEXPECTED_WHITESPACE'
			$message[2] = 'Manifest Parse Error : Whitespace is not allowed at this location.'

		Case 14043
			$message[1] = 'ERROR_SXS_XML_E_INCOMPLETE_ENCODING'
			$message[2] = 'Manifest Parse Error : End of file reached in invalid state for current encoding.'

		Case 14044
			$message[1] = 'ERROR_SXS_XML_E_MISSING_PAREN'
			$message[2] = 'Manifest Parse Error : Missing parenthesis.'

		Case 14045
			$message[1] = 'ERROR_SXS_XML_E_EXPECTINGCLOSEQUOTE'
			$message[2] = 'Manifest Parse Error : A single or double closing quote character (\'' or \") is missing.'

		Case 14046
			$message[1] = 'ERROR_SXS_XML_E_MULTIPLE_COLONS'
			$message[2] = 'Manifest Parse Error : Multiple colons are not allowed in a name.'

		Case 14047
			$message[1] = 'ERROR_SXS_XML_E_INVALID_DECIMAL'
			$message[2] = 'Manifest Parse Error : Invalid character for decimal digit.'

		Case 14048
			$message[1] = 'ERROR_SXS_XML_E_INVALID_HEXIDECIMAL'
			$message[2] = 'Manifest Parse Error : Invalid character for hexidecimal digit.'

		Case 14049
			$message[1] = 'ERROR_SXS_XML_E_INVALID_UNICODE'
			$message[2] = 'Manifest Parse Error : Invalid unicode character value for this platform.'

		Case 14050
			$message[1] = 'ERROR_SXS_XML_E_WHITESPACEORQUESTIONMARK'
			$message[2] = 'Manifest Parse Error : Expecting whitespace or ''?''.'

		Case 14051
			$message[1] = 'ERROR_SXS_XML_E_UNEXPECTEDENDTAG'
			$message[2] = 'Manifest Parse Error : End tag was not expected at this location.'

		Case 14052
			$message[1] = 'ERROR_SXS_XML_E_UNCLOSEDTAG'
			$message[2] = 'Manifest Parse Error : The following tags were not closed: %1.'

		Case 14053
			$message[1] = 'ERROR_SXS_XML_E_DUPLICATEATTRIBUTE'
			$message[2] = 'Manifest Parse Error : Duplicate attribute.'

		Case 14054
			$message[1] = 'ERROR_SXS_XML_E_MULTIPLEROOTS'
			$message[2] = 'Manifest Parse Error : Only one top level element is allowed in an XML document.'

		Case 14055
			$message[1] = 'ERROR_SXS_XML_E_INVALIDATROOTLEVEL'
			$message[2] = 'Manifest Parse Error : Invalid at the top level of the document.'

		Case 14056
			$message[1] = 'ERROR_SXS_XML_E_BADXMLDECL'
			$message[2] = 'Manifest Parse Error : Invalid xml declaration.'

		Case 14057
			$message[1] = 'ERROR_SXS_XML_E_MISSINGROOT'
			$message[2] = 'Manifest Parse Error : XML document must have a top level element.'

		Case 14058
			$message[1] = 'ERROR_SXS_XML_E_UNEXPECTEDEOF'
			$message[2] = 'Manifest Parse Error : Unexpected end of file.'

		Case 14059
			$message[1] = 'ERROR_SXS_XML_E_BADPEREFINSUBSET'
			$message[2] = 'Manifest Parse Error : Parameter entities cannot be used inside markup declarations in an internal subset.'

		Case 14060
			$message[1] = 'ERROR_SXS_XML_E_UNCLOSEDSTARTTAG'
			$message[2] = 'Manifest Parse Error : Element was not closed.'

		Case 14061
			$message[1] = 'ERROR_SXS_XML_E_UNCLOSEDENDTAG'
			$message[2] = 'Manifest Parse Error : End element was missing the character ''>''.'

		Case 14062
			$message[1] = 'ERROR_SXS_XML_E_UNCLOSEDSTRING'
			$message[2] = 'Manifest Parse Error : A string literal was not closed.'

		Case 14063
			$message[1] = 'ERROR_SXS_XML_E_UNCLOSEDCOMMENT'
			$message[2] = 'Manifest Parse Error : A comment was not closed.'

		Case 14064
			$message[1] = 'ERROR_SXS_XML_E_UNCLOSEDDECL'
			$message[2] = 'Manifest Parse Error : A declaration was not closed.'

		Case 14065
			$message[1] = 'ERROR_SXS_XML_E_UNCLOSEDCDATA'
			$message[2] = 'Manifest Parse Error : A CDATA section was not closed.'

		Case 14066
			$message[1] = 'ERROR_SXS_XML_E_RESERVEDNAMESPACE'
			$message[2] = 'Manifest Parse Error : The namespace prefix is not allowed to start with the reserved string "xml".'

		Case 14067
			$message[1] = 'ERROR_SXS_XML_E_INVALIDENCODING'
			$message[2] = 'Manifest Parse Error : System does not support the specified encoding.'

		Case 14068
			$message[1] = 'ERROR_SXS_XML_E_INVALIDSWITCH'
			$message[2] = 'Manifest Parse Error : Switch from current encoding to specified encoding not supported.'

		Case 14069
			$message[1] = 'ERROR_SXS_XML_E_BADXMLCASE'
			$message[2] = 'Manifest Parse Error : The name ''xml'' is reserved and must be lower case.'

		Case 14070
			$message[1] = 'ERROR_SXS_XML_E_INVALID_STANDALONE'
			$message[2] = 'Manifest Parse Error : The standalone attribute must have the value ''yes'' or ''no''.'

		Case 14071
			$message[1] = 'ERROR_SXS_XML_E_UNEXPECTED_STANDALONE'
			$message[2] = 'Manifest Parse Error : The standalone attribute cannot be used in external entities.'

		Case 14072
			$message[1] = 'ERROR_SXS_XML_E_INVALID_VERSION'
			$message[2] = 'Manifest Parse Error : Invalid version number.'

		Case 14073
			$message[1] = 'ERROR_SXS_XML_E_MISSINGEQUALS'
			$message[2] = 'Manifest Parse Error : Missing equals sign between attribute and attribute value.'

		Case 14074
			$message[1] = 'ERROR_SXS_PROTECTION_RECOVERY_FAILED'
			$message[2] = 'Assembly Protection Error : Unable to recover the specified assembly.'

		Case 14075
			$message[1] = 'ERROR_SXS_PROTECTION_PUBLIC_KEY_TOO_SHORT'
			$message[2] = 'Assembly Protection Error : The public key for an assembly was too short to be allowed.'

		Case 14076
			$message[1] = 'ERROR_SXS_PROTECTION_CATALOG_NOT_VALID'
			$message[2] = 'Assembly Protection Error : The catalog for an assembly is not valid, or does not match the assembly''s manifest.'

		Case 14077
			$message[1] = 'ERROR_SXS_UNTRANSLATABLE_HRESULT'
			$message[2] = 'An HRESULT could not be translated to a corresponding Win32 error code.'

		Case 14078
			$message[1] = 'ERROR_SXS_PROTECTION_CATALOG_FILE_MISSING'
			$message[2] = 'Assembly Protection Error : The catalog for an assembly is missing.'

		Case 14079
			$message[1] = 'ERROR_SXS_MISSING_ASSEMBLY_IDENTITY_ATTRIBUTE'
			$message[2] = 'The supplied assembly identity is missing one or more attributes which must be present in this context.'

		Case 14080
			$message[1] = 'ERROR_SXS_INVALID_ASSEMBLY_IDENTITY_ATTRIBUTE_NAME'
			$message[2] = 'The supplied assembly identity has one or more attribute names that contain characters not permitted in XML names.'

		Case 14081
			$message[1] = 'ERROR_SXS_ASSEMBLY_MISSING'
			$message[2] = 'The referenced assembly could not be found.'

		Case 14082
			$message[1] = 'ERROR_SXS_CORRUPT_ACTIVATION_STACK'
			$message[2] = 'The activation context activation stack for the running thread of execution is corrupt.'

		Case 14083
			$message[1] = 'ERROR_SXS_CORRUPTION'
			$message[2] = 'The application isolation metadata for this process or thread has become corrupt.'

		Case 14084
			$message[1] = 'ERROR_SXS_EARLY_DEACTIVATION'
			$message[2] = 'The activation context being deactivated is not the most recently activated one.'

		Case 14085
			$message[1] = 'ERROR_SXS_INVALID_DEACTIVATION'
			$message[2] = 'The activation context being deactivated is not active for the current thread of execution.'

		Case 14086
			$message[1] = 'ERROR_SXS_MULTIPLE_DEACTIVATION'
			$message[2] = 'The activation context being deactivated has already been deactivated.'

		Case 14087
			$message[1] = 'ERROR_SXS_PROCESS_TERMINATION_REQUESTED'
			$message[2] = 'A component used by the isolation facility has requested to terminate the process.'

		Case 14088
			$message[1] = 'ERROR_SXS_RELEASE_ACTIVATION_CONTEXT'
			$message[2] = 'A kernel mode component is releasing a reference on an activation context.'

		Case 14089
			$message[1] = 'ERROR_SXS_SYSTEM_DEFAULT_ACTIVATION_CONTEXT_EMPTY'
			$message[2] = 'The activation context of system default assembly could not be generated.'

		Case 14090
			$message[1] = 'ERROR_SXS_INVALID_IDENTITY_ATTRIBUTE_VALUE'
			$message[2] = 'The value of an attribute in an identity is not within the legal range.'

		Case 14091
			$message[1] = 'ERROR_SXS_INVALID_IDENTITY_ATTRIBUTE_NAME'
			$message[2] = 'The name of an attribute in an identity is not within the legal range.'

		Case 14092
			$message[1] = 'ERROR_SXS_IDENTITY_DUPLICATE_ATTRIBUTE'
			$message[2] = 'An identity contains two definitions for the same attribute.'

		Case 14093
			$message[1] = 'ERROR_SXS_IDENTITY_PARSE_ERROR'
			$message[2] = 'The identity string is malformed. This may be due to a trailing comma, more than two unnamed attributes, missing attribute name or missing attribute value.'

		Case 14094
			$message[1] = 'ERROR_MALFORMED_SUBSTITUTION_STRING'
			$message[2] = 'A string containing localized substitutable content was malformed. Either a dollar sign ($) was follwed by something other than a left parenthesis or another dollar sign or an substitution''s right parenthesis was not found.'

		Case 14095
			$message[1] = 'ERROR_SXS_INCORRECT_PUBLIC_KEY_TOKEN'
			$message[2] = 'The public key token does not correspond to the public key specified.'

		Case 14096
			$message[1] = 'ERROR_UNMAPPED_SUBSTITUTION_STRING'
			$message[2] = 'A substitution string had no mapping.'

		Case 14097
			$message[1] = 'ERROR_SXS_ASSEMBLY_NOT_LOCKED'
			$message[2] = 'The component must be locked before making the request.'

		Case 14098
			$message[1] = 'ERROR_SXS_COMPONENT_STORE_CORRUPT'
			$message[2] = 'The component store has been corrupted.'

		Case 14099
			$message[1] = 'ERROR_ADVANCED_INSTALLER_FAILED'
			$message[2] = 'An advanced installer failed during setup or servicing.'

		Case 14100
			$message[1] = 'ERROR_XML_ENCODING_MISMATCH'
			$message[2] = 'The character encoding in the XML declaration did not match the encoding used in the document.'

		Case 14101
			$message[1] = 'ERROR_SXS_MANIFEST_IDENTITY_SAME_BUT_CONTENTS_DIFFERENT'
			$message[2] = 'The identities of the manifests are identical but their contents are different.'

		Case 14102
			$message[1] = 'ERROR_SXS_IDENTITIES_DIFFERENT'
			$message[2] = 'The component identities are different.'

		Case 14103
			$message[1] = 'ERROR_SXS_ASSEMBLY_IS_NOT_A_DEPLOYMENT'
			$message[2] = 'The assembly is not a deployment.'

		Case 14104
			$message[1] = 'ERROR_SXS_FILE_NOT_PART_OF_ASSEMBLY'
			$message[2] = 'The file is not a part of the assembly.'

		Case 14105
			$message[1] = 'ERROR_SXS_MANIFEST_TOO_BIG'
			$message[2] = 'The size of the manifest exceeds the maximum allowed.'

		Case 14106
			$message[1] = 'ERROR_SXS_SETTING_NOT_REGISTERED'
			$message[2] = 'The setting is not registered.'

		Case 14107
			$message[1] = 'ERROR_SXS_TRANSACTION_CLOSURE_INCOMPLETE'
			$message[2] = 'One or more required members of the transaction are not present.'

		Case 14108
			$message[1] = 'ERROR_SMI_PRIMITIVE_INSTALLER_FAILED'
			$message[2] = 'The SMI primitive installer failed during setup or servicing.'

		Case 14109
			$message[1] = 'ERROR_GENERIC_COMMAND_FAILED'
			$message[2] = 'A generic command executable returned a result that indicates failure.'

		Case 14110
			$message[1] = 'ERROR_SXS_FILE_HASH_MISSING'
			$message[2] = 'A component is missing file verification information in its manifest.'

		Case 15000
			$message[1] = 'ERROR_EVT_INVALID_CHANNEL_PATH'
			$message[2] = 'The specified channel path is invalid.'

		Case 15001
			$message[1] = 'ERROR_EVT_INVALID_QUERY'
			$message[2] = 'The specified query is invalid.'

		Case 15002
			$message[1] = 'ERROR_EVT_PUBLISHER_METADATA_NOT_FOUND'
			$message[2] = 'The publisher metadata cannot be found in the resource.'

		Case 15003
			$message[1] = 'ERROR_EVT_EVENT_TEMPLATE_NOT_FOUND'
			$message[2] = 'The template for an event definition cannot be found in the resource (error = %1).'

		Case 15004
			$message[1] = 'ERROR_EVT_INVALID_PUBLISHER_NAME'
			$message[2] = 'The specified publisher name is invalid.'

		Case 15005
			$message[1] = 'ERROR_EVT_INVALID_EVENT_DATA'
			$message[2] = 'The event data raised by the publisher is not compatible with the event template definition in the publisher''s manifest'

		Case 15007
			$message[1] = 'ERROR_EVT_CHANNEL_NOT_FOUND'
			$message[2] = 'The specified channel could not be found. Check channel configuration.'

		Case 15008
			$message[1] = 'ERROR_EVT_MALFORMED_XML_TEXT'
			$message[2] = 'The specified xml text was not well-formed. See Extended Error for more details.'

		Case 15009
			$message[1] = 'ERROR_EVT_SUBSCRIPTION_TO_DIRECT_CHANNEL'
			$message[2] = 'The caller is trying to subscribe to a direct channel which is not allowed. The events for a direct channel go directly to a logfile and cannot be subscribed to.'

		Case 15010
			$message[1] = 'ERROR_EVT_CONFIGURATION_ERROR'
			$message[2] = 'Configuration error.'

		Case 15011
			$message[1] = 'ERROR_EVT_QUERY_RESULT_STALE'
			$message[2] = 'The query result is stale / invalid. This may be due to the log being cleared or rolling over after the query result was created. Users should handle this code by releasing the query result object and reissuing the query.'

		Case 15012
			$message[1] = 'ERROR_EVT_QUERY_RESULT_INVALID_POSITION'
			$message[2] = 'Query result is currently at an invalid position.'

		Case 15013
			$message[1] = 'ERROR_EVT_NON_VALIDATING_MSXML'
			$message[2] = 'Registered MSXML doesn''t support validation.'

		Case 15014
			$message[1] = 'ERROR_EVT_FILTER_ALREADYSCOPED'
			$message[2] = 'An expression can only be followed by a change of scope operation if it itself evaluates to a node set and is not already part of some other change of scope operation.'

		Case 15015
			$message[1] = 'ERROR_EVT_FILTER_NOTELTSET'
			$message[2] = 'Can''t perform a step operation from a term that does not represent an element set.'

		Case 15016
			$message[1] = 'ERROR_EVT_FILTER_INVARG'
			$message[2] = 'Left hand side arguments to binary operators must be either attributes, nodes or variables and right hand side arguments must be constants.'

		Case 15017
			$message[1] = 'ERROR_EVT_FILTER_INVTEST'
			$message[2] = 'A step operation must involve either a node test or, in the case of a predicate, an algebraic expression against which to test each node in the node set identified by the preceding node set can be evaluated.'

		Case 15018
			$message[1] = 'ERROR_EVT_FILTER_INVTYPE'
			$message[2] = 'This data type is currently unsupported.'

		Case 15019
			$message[1] = 'ERROR_EVT_FILTER_PARSEERR'
			$message[2] = 'A syntax error occurred at position %1!d!'

		Case 15020
			$message[1] = 'ERROR_EVT_FILTER_UNSUPPORTEDOP'
			$message[2] = 'This operator is unsupported by this implementation of the filter.'

		Case 15021
			$message[1] = 'ERROR_EVT_FILTER_UNEXPECTEDTOKEN'
			$message[2] = 'The token encountered was unexpected.'

		Case 15022
			$message[1] = 'ERROR_EVT_INVALID_OPERATION_OVER_ENABLED_DIRECT_CHANNEL'
			$message[2] = 'The requested operation cannot be performed over an enabled direct channel. The channel must first be disabled before performing the requested operation.'

		Case 15023
			$message[1] = 'ERROR_EVT_INVALID_CHANNEL_PROPERTY_VALUE'
			$message[2] = 'Channel property %1!s! contains invalid value. The value has invalid type, is outside of valid range, can''t be updated or is not supported by this type of channel.'

		Case 15024
			$message[1] = 'ERROR_EVT_INVALID_PUBLISHER_PROPERTY_VALUE'
			$message[2] = 'Publisher property %1!s! contains invalid value. The value has invalid type, is outside of valid range, can''t be updated or is not supported by this type of publisher.'

		Case 15025
			$message[1] = 'ERROR_EVT_CHANNEL_CANNOT_ACTIVATE'
			$message[2] = 'The channel fails to activate.'

		Case 15026
			$message[1] = 'ERROR_EVT_FILTER_TOO_COMPLEX'
			$message[2] = 'The xpath expression exceeded supported complexity. Please simplify it or split it into two or more simple expressions. '

		Case 15027
			$message[1] = 'ERROR_EVT_MESSAGE_NOT_FOUND'
			$message[2] = 'The message resource is present but the message is not found in the string/message table.'

		Case 15028
			$message[1] = 'ERROR_EVT_MESSAGE_ID_NOT_FOUND'
			$message[2] = 'The message identifier for the desired message could not be found. '

		Case 15029
			$message[1] = 'ERROR_EVT_UNRESOLVED_VALUE_INSERT'
			$message[2] = 'The substitution string for insert index (%1) could not be found. '

		Case 15030
			$message[1] = 'ERROR_EVT_UNRESOLVED_PARAMETER_INSERT'
			$message[2] = 'The description string for parameter reference (%1) could not be found. '

		Case 15031
			$message[1] = 'ERROR_EVT_MAX_INSERTS_REACHED'
			$message[2] = 'The maximum number of replacements has been reached.'

		Case 15032
			$message[1] = 'ERROR_EVT_EVENT_DEFINITION_NOT_FOUND'
			$message[2] = 'The event definition could not be found for the event identifier (%1).'

		Case 15033
			$message[1] = 'ERROR_EVT_MESSAGE_LOCALE_NOT_FOUND'
			$message[2] = 'The locale specific resource for the desired message is not present.'

		Case 15034
			$message[1] = 'ERROR_EVT_VERSION_TOO_OLD'
			$message[2] = 'The resource is too old to be compatible.'

		Case 15035
			$message[1] = 'ERROR_EVT_VERSION_TOO_NEW'
			$message[2] = 'The resource is too new to be compatible.'

		Case 15036
			$message[1] = 'ERROR_EVT_CANNOT_OPEN_CHANNEL_OF_QUERY'
			$message[2] = 'The channel at index %1!d! of the query cannot be opened.'

		Case 15037
			$message[1] = 'ERROR_EVT_PUBLISHER_DISABLED'
			$message[2] = 'The publisher has been disabled and its resource is not available. This usually occurs when the publisher is in the process of being uninstalled or upgraded.'

		Case 15038
			$message[1] = 'ERROR_EVT_FILTER_OUT_OF_RANGE'
			$message[2] = 'Attempted to create a numeric type that is outside of its valid range.'

		Case 15080
			$message[1] = 'ERROR_EC_SUBSCRIPTION_CANNOT_ACTIVATE'
			$message[2] = 'The subscription fails to activate.'

		Case 15081
			$message[1] = 'ERROR_EC_LOG_DISABLED'
			$message[2] = 'The log of the subscription is in disabled state, and cannot be used to forward events. The log must first be enabled before the subscription can be activated.'

		Case 15082
			$message[1] = 'ERROR_EC_CIRCULAR_FORWARDING'
			$message[2] = 'When forwarding events from local machine to itself, the query of the subscription can''t contain target log of the subscription.'

		Case 15083
			$message[1] = 'ERROR_EC_CREDSTORE_FULL'
			$message[2] = 'The credential store that is used to save credentials is full.'

		Case 15084
			$message[1] = 'ERROR_EC_CRED_NOT_FOUND'
			$message[2] = 'The credential used by this subscription can''t be found in credential store.'

		Case 15085
			$message[1] = 'ERROR_EC_NO_ACTIVE_CHANNEL'
			$message[2] = 'No active channel is found for the query.'

		Case 15100
			$message[1] = 'ERROR_MUI_FILE_NOT_FOUND'
			$message[2] = 'The resource loader failed to find MUI file.'

		Case 15101
			$message[1] = 'ERROR_MUI_INVALID_FILE'
			$message[2] = 'The resource loader failed to load MUI file because the file fail to pass validation.'

		Case 15102
			$message[1] = 'ERROR_MUI_INVALID_RC_CONFIG'
			$message[2] = 'The RC Manifest is corrupted with garbage data or unsupported version or missing required item.'

		Case 15103
			$message[1] = 'ERROR_MUI_INVALID_LOCALE_NAME'
			$message[2] = 'The RC Manifest has invalid culture name.'

		Case 15104
			$message[1] = 'ERROR_MUI_INVALID_ULTIMATEFALLBACK_NAME'
			$message[2] = 'The RC Manifest has invalid ultimatefallback name.'

		Case 15105
			$message[1] = 'ERROR_MUI_FILE_NOT_LOADED'
			$message[2] = 'The resource loader cache doesn''t have loaded MUI entry.'

		Case 15106
			$message[1] = 'ERROR_RESOURCE_ENUM_USER_STOP'
			$message[2] = 'User stop resource enumeration.'

		Case 15107
			$message[1] = 'ERROR_MUI_INTLSETTINGS_UILANG_NOT_INSTALLED'
			$message[2] = 'UI language installation failed.'

		Case 15108
			$message[1] = 'ERROR_MUI_INTLSETTINGS_INVALID_LOCALE_NAME'
			$message[2] = 'Locale installation failed.'

		Case 15200
			$message[1] = 'ERROR_MCA_INVALID_CAPABILITIES_STRING'
			$message[2] = 'The monitor returned a DDC/CI capabilities string that did not comply with the ACCESS.bus 3.0, DDC/CI 1.1, or MCCS 2 Revision 1 specification.'

		Case 15201
			$message[1] = 'ERROR_MCA_INVALID_VCP_VERSION'
			$message[2] = 'The monitor''s VCP Version (0xDF) VCP code returned an invalid version value.'

		Case 15202
			$message[1] = 'ERROR_MCA_MONITOR_VIOLATES_MCCS_SPECIFICATION'
			$message[2] = 'The monitor does not comply with the MCCS specification it claims to supports.'

		Case 15203
			$message[1] = 'ERROR_MCA_MCCS_VERSION_MISMATCH'
			$message[2] = 'The MCCS version in a monitor''s mccs_ver capability does not match the MCCS version the monitor reports when the VCP Version (0xDF) VCP code is used.'

		Case 15204
			$message[1] = 'ERROR_MCA_UNSUPPORTED_MCCS_VERSION'
			$message[2] = 'The Monitor Configuration API only works with monitors that support the MCCS 1.0 specification, MCCS 2.0 specification, or the MCCS 2.0 Revision 1 specification.'

		Case 15205
			$message[1] = 'ERROR_MCA_INTERNAL_ERROR'
			$message[2] = 'An internal Monitor Configuration API error occurred.'

		Case 15206
			$message[1] = 'ERROR_MCA_INVALID_TECHNOLOGY_TYPE_RETURNED'
			$message[2] = 'The monitor returned an invalid monitor technology type. CRT, Plasma, and LCD (TFT) are examples of monitor technology types. This error implies that the monitor violated the MCCS 2.0 or the MCCS 2.0 Revision 1 specification.'

		Case 15207
			$message[1] = 'ERROR_MCA_UNSUPPORTED_COLOR_TEMPERATURE'
			$message[2] = 'The caller of SetMonitorColorTemperature specified a color temperature that the current monitor did not support. This error implies that the monitor violated the MCCS 2.0 or the MCCS 2.0 Revision 1 specification.'

		Case 15250
			$message[1] = 'ERROR_AMBIGUOUS_SYSTEM_DEVICE'
			$message[2] = 'The requested system device cannot be identified due to multiple indistinguishable devices potentially matching the identification criteria. '

		Case 15299
			$message[1] = 'ERROR_SYSTEM_DEVICE_NOT_FOUND'
			$message[2] = 'The requested system device cannot be found.'

		Case Else
			$message[0] = 0

	EndSwitch
	Return $message
EndFunc

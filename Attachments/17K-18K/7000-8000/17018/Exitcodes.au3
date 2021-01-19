;===============================================================================
;
; Description:      Returns the exit code and description based on executable that is run
; Syntax:           _Getcode($Exitcode)
; Parameter(s):     $Exitcode - The exit code generated from the Runwait command
; Requirement(s):   None
; Return Value(s):  On Success - Returns the relevant error code and description
; Author(s):        Lyle de Groot
; Notes:			- This comes in handy in particular when using running msi's and retreiving
;					  their unique error code and error description(s)
;					- Codes retrived from                                                      
;					- Custom codes can be added to this script and read, especially when wanting
;					  to write to the event viewer
;
; Example script:	#include <Exitcodes.au3>
;					$var = RunWait("Notepad.exe", @WindowsDir, @SW_MAXIMIZE)
;					$Result = _Getcode($var)
;					MsgBox(64, "Return message", $Result)
;===============================================================================


Func _Getcode($Exitcode)
Global $ExitValue 
	Switch $Exitcode
		Case 0
			$ExitValue = '0 The operation completed successfully.'
		Case 1
			$ExitValue = '1 Incorrect function.'
		Case 2
			$ExitValue = '2 The system cannot find the file specified.'
		Case 3
			$ExitValue = '3 The system cannot find the path specified.'
		Case 4
			$ExitValue = '4 The system cannot open the file.'
		Case 5
			$ExitValue = '5 Access is denied.'
		Case 6
			$ExitValue = '6 The handle is invalid.'
		Case 7
			$ExitValue = '7 The storage control blocks were destroyed.'
		Case 8
			$ExitValue = '8 Not enough storage is available to process this command.'
		Case 9
			$ExitValue = '9 The storage control block address is invalid.'
		Case 10
			$ExitValue = '10 The environment is incorrect.'
		Case 11
			$ExitValue = '11 An attempt was made to load a program with an incorrect format.'
		Case 12
			$ExitValue = '12 The access code is invalid.'
		Case 13
			$ExitValue = '13 The data is invalid.'
		Case 14
			$ExitValue = '14 Not enough storage is available to complete this operation.'
		Case 15
			$ExitValue = '15 The system cannot find the drive specified.'
		Case 16
			$ExitValue = '16 The directory cannot be removed.'
		Case 17
			$ExitValue = '17 The system cannot move the file to a different disk drive.'
		Case 18
			$ExitValue = '18 There are no more files.'
		Case 19
			$ExitValue = '19 The media is write protected.'
		Case 20
			$ExitValue = '20 The system cannot find the device specified.'
		Case 21
			$ExitValue = '21 The device is not ready.'
		Case 22
			$ExitValue = '22 The device does not recognize the command.'
		Case 23
			$ExitValue = '23 Data error (cyclic redundancy check).'
		Case 24
			$ExitValue = '24 The program issued a command but the command length is incorrect.'
		Case 25
			$ExitValue = '25 The drive cannot locate a specific area or track on the disk.'
		Case 26
			$ExitValue = '26 The specified disk or diskette cannot be accessed.'
		Case 27
			$ExitValue = '27 The drive cannot find the sector requested.'
		Case 28
			$ExitValue = '28 The printer is out of paper.'
		Case 29
			$ExitValue = '29 The system cannot write to the specified device.'
		Case 30
			$ExitValue = '30 The system cannot read from the specified device.'
		Case 31
			$ExitValue = '31 A device attached to the system is not functioning.'
		Case 32
			$ExitValue = '32 The process cannot access the file because it is being used by another process.'
		Case 33
			$ExitValue = '33 The process cannot access the file because another process has locked a portion of the file.'
		Case 34
			$ExitValue = '34 The wrong diskette is in the drive. Insert %2 (Volume Serial Number: %3) into drive %1.'
		Case 36
			$ExitValue = '36 Too many files opened for sharing.'
		Case 38
			$ExitValue = '38 Reached the end of the file.'
		Case 39
			$ExitValue = '39 The disk is full.'
		Case 50
			$ExitValue = '50 The request is not supported.'
		Case 51
			$ExitValue = '51 Windows cannot find the network path. Verify that the network path is correct and the destination computer is not busy or turned off. If Windows still cannot find the network path, contact your network administrator.'
		Case 52
			$ExitValue = '52 You were not connected because a duplicate name exists on the network. Go to System in the Control Panel to change the computer name and try again.'
		Case 53
			$ExitValue = '53 The network path was not found.'
		Case 54
			$ExitValue = '54 The network is busy.'
		Case 55
			$ExitValue = '55 The specified network resource or device is no longer available.'
		Case 56
			$ExitValue = '56 The network BIOS command limit has been reached.'
		Case 57
			$ExitValue = '57 A network adapter hardware error occurred.'
		Case 58
			$ExitValue = '58 The specified server cannot perform the requested operation.'
		Case 59
			$ExitValue = '59 An unexpected network error occurred.'
		Case 60
			$ExitValue = '60 The remote adapter is not compatible.'
		Case 61
			$ExitValue = '61 The printer queue is full.'
		Case 62
			$ExitValue = '62 Space to store the file waiting to be printed is not available on the"' 
		Case 63
			$ExitValue = '63 Your file waiting to be printed was deleted.'
		Case 64
			$ExitValue = '64 The specified network name is no longer available.'
		Case 65
			$ExitValue = '65 Network access is denied.'
		Case 66
			$ExitValue = '66 The network resource type is not correct.'
		Case 67
			$ExitValue = '67 The network name cannot be found.'
		Case 68
			$ExitValue = '68 The name limit for the local computer network adapter card was exceede"' 
		Case 69
			$ExitValue = '69 The network BIOS session limit was exceeded.'
		Case 70
			$ExitValue = '70 The remote server has been paused or is in the process of being starte"' 
		Case 71
			$ExitValue = '71 No more connections can be made to this remote computer at this time b"' 
		Case 72
			$ExitValue = '72 The specified printer or disk device has been paused.'
		Case 80
			$ExitValue = '80 The file exists.'
		Case 82
			$ExitValue = '82 The directory or file cannot be created.'
		Case 83
			$ExitValue = '83 Fail on INT 24.'
		Case 84
			$ExitValue = '84 Storage to process this request is not available.'
		Case 85
			$ExitValue = '85 The local device name is already in use.'
		Case 86
			$ExitValue = '86 The specified network password is not correct.'
		Case 87
			$ExitValue = '87 The parameter is incorrect.'
		Case 88
			$ExitValue = '88 A write fault occurred on the network.'
		Case 89
			$ExitValue = '89 The system cannot start another process at this time.'
		Case 100
			$ExitValue = '100 Cannot create another system semaphore.'
		Case 101
			$ExitValue = '101 The exclusive semaphore is owned by another process.'
		Case 102
			$ExitValue = '102 The semaphore is set and cannot be closed.'
		Case 103
			$ExitValue = '103 The semaphore cannot be set again.'
		Case 104
			$ExitValue = '104 Cannot request exclusive semaphores at interrupt time.'
		Case 105
			$ExitValue = '105 The previous ownership of this semaphore has ended.'
		Case 106
			$ExitValue = '106 Insert the diskette for drive %1.'
		Case 107
			$ExitValue = '107 The program stopped because an alternate diskette was not inserted.'
		Case 108
			$ExitValue = '108 The disk is in use or locked by another process.'
		Case 109
			$ExitValue = '109 The pipe has been ended.'
		Case 110
			$ExitValue = '110 The system cannot open the device or file specified.'
		Case 111
			$ExitValue = '111 The file name is too long.'
		Case 112
			$ExitValue = '112 There is not enough space on the disk.'
		Case 113
			$ExitValue = '113 No more internal file identifiers available.'
		Case 114
			$ExitValue = '114 The target internal file identifier is incorrect.'
		Case 117
			$ExitValue = '117 The IOCTL call made by the application program is not correct.'
		Case 118
			$ExitValue = '118 The verify-on-write switch parameter value is not correct.'
		Case 119
			$ExitValue = '119 The system does not support the command requested.'
		Case 120
			$ExitValue = '120 This function is not supported on this system.'
		Case 121
			$ExitValue = '121 The semaphore timeout period has expired.'
		Case 122
			$ExitValue = '122 The data area passed to a system call is too small.'
		Case 123
			$ExitValue = '123 The filename, directory name, or volume label syntax is incorrect.'
		Case 124
			$ExitValue = '124 The system call level is not correct.'
		Case 125
			$ExitValue = '125 The disk has no volume label.'
		Case 126
			$ExitValue = '126 The specified module could not be found.'
		Case 127
			$ExitValue = '127 The specified procedure could not be found.'
		Case 128
			$ExitValue = '128 There are no child processes to wait for.'
		Case 129
			$ExitValue = '129 The %1 application cannot be run in Win32 mode.'
		Case 130
			$ExitValue = '130 Attempt to use a file handle to an open disk partition for an operation other than raw disk I/O.'
		Case 131
			$ExitValue = '131 An attempt was made to move the file pointer before the beginning of the file.'
		Case 132
			$ExitValue = '132 The file pointer cannot be set on the specified device or file.'
		Case 133
			$ExitValue = '133 A JOIN or SUBST command cannot be used for a drive that contains previously joined drives.'
		Case 134
			$ExitValue = '134 An attempt was made to use a JOIN or SUBST command on a drive that has already been joined.'
		Case 135
			$ExitValue = '135 An attempt was made to use a JOIN or SUBST command on a drive that has already been substituted.'
		Case 136
			$ExitValue = '136 The system tried to delete the JOIN of a drive that is not joined.'
		Case 137
			$ExitValue = '137 The system tried to delete the substitution of a drive that is not substituted.'
		Case 138
			$ExitValue = '138 The system tried to join a drive to a directory on a joined drive.'
		Case 139
			$ExitValue = '139 The system tried to substitute a drive to a directory on a substituted drive.'
		Case 140
			$ExitValue = '140 The system tried to join a drive to a directory on a substituted drive.'
		Case 141
			$ExitValue = '141 The system tried to SUBST a drive to a directory on a joined drive.'
		Case 142
			$ExitValue = '142 The system cannot perform a JOIN or SUBST at this time.'
		Case 143
			$ExitValue = '143 The system cannot join or substitute a drive to or for a directory on the same drive.'
		Case 144
			$ExitValue = '144 The directory is not a subdirectory of the root directory.'
		Case 145
			$ExitValue = '145 The directory is not empty.'
		Case 146
			$ExitValue = '146 The path specified is being used in a substitute.'
		Case 147
			$ExitValue = '147 Not enough resources are available to process this command.'
		Case 148
			$ExitValue = '148 The path specified cannot be used at this time.'
		Case 149
			$ExitValue = '149 An attempt was made to join or substitute a drive for which a directory on the drive is the target of a previous substitute.'
		Case 150
			$ExitValue = '150 System trace information was not specified in your CONFIG.SYS file, or tracing is disallowed.'
		Case 151
			$ExitValue = '151 The number of specified semaphore events for DosMuxSemWait is not correct.'
		Case 152
			$ExitValue = '152 DosMuxSemWait did not execute; too many semaphores are already set.'
		Case 153
			$ExitValue = '153 The DosMuxSemWait list is not correct.'
		Case 154
			$ExitValue = '154 The volume label you entered exceeds the label character limit of the target file system.'
		Case 155
			$ExitValue = '155 Cannot create another thread.'
		Case 156
			$ExitValue = '156 The recipient process has refused the signal.'
		Case 157
			$ExitValue = '157 The segment is already discarded and cannot be locked.'
		Case 158
			$ExitValue = '158 The segment is already unlocked.'
		Case 159
			$ExitValue = '159 The address for the thread ID is not correct.'
		Case 160
			$ExitValue = '160 The argument string passed to DosExecPgm is not correct.'
		Case 161
			$ExitValue = '161 The specified path is invalid.'
		Case 162
			$ExitValue = '162 A signal is already pending.'
		Case 164
			$ExitValue = '164 No more threads can be created in the system.'
		Case 167
			$ExitValue = '167 Unable to lock a region of a file.'
		Case 170
			$ExitValue = '170 The requested resource is in use.'
		Case 173
			$ExitValue = '173 A lock request was not outstanding for the supplied cancel region.'
		Case 174
			$ExitValue = '174 The file system does not support atomic changes to the lock type.'
		Case 180
			$ExitValue = '180 The system detected a segment number that was not correct.'
		Case 182
			$ExitValue = '182 The operating system cannot run %1.'
		Case 183
			$ExitValue = '183 Cannot create a file when that file already exists.'
		Case 186
			$ExitValue = '186 The flag passed is not correct.'
		Case 187
			$ExitValue = '187 The specified system semaphore name was not found.'
		Case 188
			$ExitValue = '188 The operating system cannot run %1.'
		Case 189
			$ExitValue = '189 The operating system cannot run %1.'
		Case 190
			$ExitValue = '190 The operating system cannot run %1.'
		Case 191
			$ExitValue = '191 Cannot run %1 in Win32 mode.'
		Case 192
			$ExitValue = '192 The operating system cannot run %1.'
		Case 193
			$ExitValue = '193 %1 is not a valid Win32 application.'
		Case 194
			$ExitValue = '194 The operating system cannot run %1.'
		Case 195
			$ExitValue = '195 The operating system cannot run %1.'
		Case 196
			$ExitValue = '196 The operating system cannot run this application program.'
		Case 197
			$ExitValue = '197 The operating system is not presently configured to run this application.'
		Case 198
			$ExitValue = '198 The operating system cannot run %1.'
		Case 199
			$ExitValue = '199 The operating system cannot run this application program.'
		Case 200
			$ExitValue = '200 The code segment cannot be greater than or equal to 64K.'
		Case 201
			$ExitValue = '201 The operating system cannot run %1.'
		Case 202
			$ExitValue = '202 The operating system cannot run %1.'
		Case 203
			$ExitValue = '203 The system could not find the environment option that was entered.'
		Case 205
			$ExitValue = '205 No process in the command subtree has a signal handler.'
		Case 206
			$ExitValue = '206 The filename or extension is too long.'
		Case 207
			$ExitValue = '207 The ring 2 stack is in use.'
		Case 208
			$ExitValue = '208 The global filename characters, * or ?, are entered incorrectly or too many global filename characters are specified.'
		Case 209
			$ExitValue = '209 The signal being posted is not correct.'
		Case 210
			$ExitValue = '210 The signal handler cannot be set.'
		Case 212
			$ExitValue = '212 The segment is locked and cannot be reallocated.'
		Case 214
			$ExitValue = '214 Too many dynamic-link modules are attached to this program or dynamic-link module.'
		Case 215
			$ExitValue = '215 Cannot nest calls to LoadModule.'
		Case 216
			$ExitValue = '216 The image file %1 is valid, but is for a machine type other than the current machine.'
		Case 230
			$ExitValue = '230 The pipe state is invalid.'
		Case 231
			$ExitValue = '231 All pipe instances are busy.'
		Case 232
			$ExitValue = '232 The pipe is being closed.'
		Case 233
			$ExitValue = '233 No process is on the other end of the pipe.'
		Case 234
			$ExitValue = '234 More data is available.'
		Case 240
			$ExitValue = '240 The session was canceled.'
		Case 254
			$ExitValue = '254 The specified extended attribute name was invalid.'
		Case 255
			$ExitValue = '255 The extended attributes are inconsistent.'
		Case 258
			$ExitValue = '258 The wait operation timed out.'
		Case 259
			$ExitValue = '259 Process is still active.'
		Case 266
			$ExitValue = '266 The copy functions cannot be used.'
		Case 267
			$ExitValue = '267 The directory name is invalid.'
		Case 275
			$ExitValue = '275 The extended attributes did not fit in the buffer.'
		Case 276
			$ExitValue = '276 The extended attribute file on the mounted file system is corrupt.'
		Case 277
			$ExitValue = '277 The extended attribute table file is full.'
		Case 278
			$ExitValue = '278 The specified extended attribute handle is invalid.'
		Case 282
			$ExitValue = '282 The mounted file system does not support extended attributes.'
		Case 288
			$ExitValue = '288 Attempt to release mutex not owned by caller.'
		Case 298
			$ExitValue = '298 Too many posts were made to a semaphore.'
		Case 299
			$ExitValue = '299 Only part of a ReadProcessMemory or WriteProcessMemory request was completed.'
		Case 300
			$ExitValue = '300 The oplock request is denied.'
		Case 301
			$ExitValue = '301 An invalid oplock acknowledgment was received by the system.'
		Case 302
			$ExitValue = '302 The volume is too fragmented to complete this operation.'
		Case 303
			$ExitValue = '303 The file cannot be opened because it is in the process of being deleted.'
		Case 317
			$ExitValue = '317 The system cannot find message text for message number 0x%1 in the message file for %2.'
		Case 487
			$ExitValue = '487 Attempt to access invalid address.'
		Case 534
			$ExitValue = '534 Arithmetic result exceeded 32 bits.'
		Case 535
			$ExitValue = '535 There is a process on other end of the pipe.'
		Case 536
			$ExitValue = '536 Waiting for a process to open the other end of the pipe.'
		Case 994
			$ExitValue = '994 Access to the extended attribute was denied.'
		Case 995
			$ExitValue = '995 The I/O operation has been aborted because of either a thread exit or an application request.'
		Case 996
			$ExitValue = '996 Overlapped I/O event is not in a signaled state.'
		Case 997
			$ExitValue = '997 Overlapped I/O operation is in progress.'
		Case 998
			$ExitValue = '998 Invalid access to memory location.'
		Case 999
			$ExitValue = '999 Error performing inpage operation.'
		Case 1001
			$ExitValue = '1001 Recursion too deep; the stack overflowed.'
		Case 1002
			$ExitValue = '1002 The window cannot act on the sent message.'
		Case 1003
			$ExitValue = '1003 Cannot complete this function.'
		Case 1004
			$ExitValue = '1004 Invalid flags.'
		Case 1005
			$ExitValue = '1005 The volume does not contain a recognized file system. Please make sure that all required file system drivers are loaded and that the volume is not corrupted.'
		Case 1006
			$ExitValue = '1006 The volume for a file has been externally altered so that the opened file is no longer valid.'
		Case 1007
			$ExitValue = '1007 The requested operation cannot be performed in full-screen mode.'
		Case 1008
			$ExitValue = '1008 An attempt was made to reference a token that does not exist.'
		Case 1009
			$ExitValue = '1009 The configuration registry database is corrupt.'
		Case 1010
			$ExitValue = '1010 The configuration registry key is invalid.'
		Case 1011
			$ExitValue = '1011 The configuration registry key could not be opened.'
		Case 1012
			$ExitValue = '1012 The configuration registry key could not be read.'
		Case 1013
			$ExitValue = '1013 The configuration registry key could not be written.'
		Case 1014
			$ExitValue = '1014 One of the files in the registry database had to be recovered by use of a log or alternate copy. The recovery was successful.'
		Case 1015
			$ExitValue = '1015 The registry is corrupted. The structure of one of the files containing registry data is corrupted, or the systems memory image of the file is corrupted, Or the file could Not be recovered because the alternate copy Or log was absent Or corrupted.'
		Case 1016
			$ExitValue = '1016 An I/O operation initiated by the registry failed unrecoverably. The registry could not read in, or write out, or flush, one of the files that contain the systems image of the registry.'
		Case 1017
			$ExitValue = '1017 The system has attempted to load or restore a file into the registry, but the specified file is not in a registry file format.'
		Case 1018
			$ExitValue = '1018 Illegal operation attempted on a registry key that has been marked for deletion.'
		Case 1019
			$ExitValue = '1019 System could not allocate the required space in a registry log.'
		Case 1020
			$ExitValue = '1020 Cannot create a symbolic link in a registry key that already has subkeys or values.'
		Case 1021
			$ExitValue = '1021 Cannot create a stable subkey under a volatile parent key.'
		Case 1022
			$ExitValue = '1022 A notify change request is being completed and the information is not being returned in the callers buffer. The caller now needs To enumerate the files To find the changes.'
		Case 1051
			$ExitValue = '1051 A stop control has been sent to a service that other running services are dependent on.'
		Case 1052
			$ExitValue = '1052 The requested control is not valid for this service.'
		Case 1053
			$ExitValue = '1053 The service did not respond to the start or control request in a timely fashion.'
		Case 1054
			$ExitValue = '1054 A thread could not be created for the service.'
		Case 1055
			$ExitValue = '1055 The service database is locked.'
		Case 1056
			$ExitValue = '1056 An instance of the service is already running.'
		Case 1057
			$ExitValue = '1057 The account name is invalid or does not exist, or the password is invalid for the account name specified.'
		Case 1058
			$ExitValue = '1058 The service cannot be started, either because it is disabled or because it has no enabled devices associated with it.'
		Case 1059
			$ExitValue = '1059 Circular service dependency was specified.'
		Case 1060
			$ExitValue = '1060 The specified service does not exist as an installed service.'
		Case 1061
			$ExitValue = '1061 The service cannot accept control messages at this time.'
		Case 1062
			$ExitValue = '1062 The service has not been started.'
		Case 1063
			$ExitValue = '1063 The service process could not connect to the service controller.'
		Case 1064
			$ExitValue = '1064 An exception occurred in the service when handling the control request.'
		Case 1065
			$ExitValue = '1065 The database specified does not exist.'
		Case 1066
			$ExitValue = '1066 The service has returned a service-specific error code.'
		Case 1067
			$ExitValue = '1067 The process terminated unexpectedly.'
		Case 1068
			$ExitValue = '1068 The dependency service or group failed to start.'
		Case 1069
			$ExitValue = '1069 The service did not start due to a logon failure.'
		Case 1070
			$ExitValue = '1070 After starting, the service hung in a start-pending state.'
		Case 1071
			$ExitValue = '1071 The specified service database lock is invalid.'
		Case 1072
			$ExitValue = '1072 The specified service has been marked for deletion.'
		Case 1073
			$ExitValue = '1073 The specified service already exists.'
		Case 1074
			$ExitValue = '1074 The system is currently running with the last-known-good configuration.'
		Case 1075
			$ExitValue = '1075 The dependency service does not exist or has been marked for deletion.'
		Case 1076
			$ExitValue = '1076 The current boot has already been accepted for use as the last-known-good control set.'
		Case 1077
			$ExitValue = '1077 No attempts to start the service have been made since the last boot.'
		Case 1078
			$ExitValue = '1078 The name is already in use as either a service name or a service display name.'
		Case 1079
			$ExitValue = '1079 The account specified for this service is different from the account specified for other services running in the same process.'
		Case 1080
			$ExitValue = '1080 Failure actions can only be set for Win32 services, not for drivers.'
		Case 1081
			$ExitValue = '1081 This service runs in the same process as the service control manager. Therefore, the service control manager cannot take action if this services process terminates unexpectedly.'
		Case 1082
			$ExitValue = '1082 No recovery program has been configured for this service.'
		Case 1083
			$ExitValue = '1083 The executable program that this service is configured to run in does not implement the service.'
		Case 1084
			$ExitValue = '1084 This service cannot be started in Safe Mode.'
		Case 1100
			$ExitValue = '1100 The physical end of the tape has been reached.'
		Case 1101
			$ExitValue = '1101 A tape access reached a filemark.'
		Case 1102
			$ExitValue = '1102 The beginning of the tape or a partition was encountered.'
		Case 1103
			$ExitValue = '1103 A tape access reached the end of a set of files.'
		Case 1104
			$ExitValue = '1104 No more data is on the tape.'
		Case 1105
			$ExitValue = '1105 Tape could not be partitioned.'
		Case 1106
			$ExitValue = '1106 When accessing a new tape of a multivolume partition, the current block size is incorrect.'
		Case 1107
			$ExitValue = '1107 Tape partition information could not be found when loading a tape.'
		Case 1108
			$ExitValue = '1108 Unable to lock the media eject mechanism.'
		Case 1109
			$ExitValue = '1109 Unable to unload the media.'
		Case 1110
			$ExitValue = '1110 The media in the drive may have changed.'
		Case 1111
			$ExitValue = '1111 The I/O bus was reset.'
		Case 1112
			$ExitValue = '1112 No media in drive.'
		Case 1113
			$ExitValue = '1113 No mapping for the Unicode character exists in the target multi-byte code page.'
		Case 1114
			$ExitValue = '1114 A dynamic link library (DLL) initialization routine failed.'
		Case 1115
			$ExitValue = '1115 A system shutdown is in progress.'
		Case 1116
			$ExitValue = '1116 Unable to abort the system shutdown because no shutdown was in progress.'
		Case 1117
			$ExitValue = '1117 The request could not be performed because of an I/O device error.'
		Case 1118
			$ExitValue = '1118 No serial device was successfully initialized. The serial driver will unload.'
		Case 1119
			$ExitValue = '1119 Unable to open a device that was sharing an interrupt request (IRQ) with other devices. At least one other device that uses that IRQ was already opened.'
		Case 1120
			$ExitValue = '1120 A serial I/O operation was completed by another write to the serial port. (The IOCTL_SERIAL_XOFF_COUNTER reached zero.)"' 
		Case 1121
			$ExitValue = '1121 A serial I/O operation completed because the timeout period expired. (The IOCTL_SERIAL_XOFF_COUNTER did not reach zero.)"' 
		Case 1122
			$ExitValue = '1122 No ID address mark was found on the floppy disk.'
		Case 1123
			$ExitValue = '1123 Mismatch between the floppy disk sector ID field and the floppy disk controller track address.'
		Case 1124
			$ExitValue = '1124 The floppy disk controller reported an error that is not recognized by the floppy disk driver.'
		Case 1125
			$ExitValue = '1125 The floppy disk controller returned inconsistent results in its registers.'
		Case 1126
			$ExitValue = '1126 While accessing the hard disk, a recalibrate operation failed, even after retries.'
		Case 1127
			$ExitValue = '1127 While accessing the hard disk, a disk operation failed even after retries.'
		Case 1128
			$ExitValue = '1128 While accessing the hard disk, a disk controller reset was needed, but even that failed.'
		Case 1129
			$ExitValue = '1129 Physical end of tape encountered.'
		Case 1130
			$ExitValue = '1130 Not enough server storage is available to process this command.'
		Case 1131
			$ExitValue = '1131 A potential deadlock condition has been detected.'
		Case 1132
			$ExitValue = '1132 The base address or the file offset specified does not have the proper alignment.'
		Case 1140
			$ExitValue = '1140 An attempt to change the system power state was vetoed by another application or driver.'
		Case 1141
			$ExitValue = '1141 The system BIOS failed an attempt to change the system power state.'
		Case 1142
			$ExitValue = '1142 An attempt was made to create more links on a file than the file system supports.'
		Case 1150
			$ExitValue = '1150 The specified program requires a newer version of Windows.'
		Case 1151
			$ExitValue = '1151 The specified program is not a Windows or MS-DOS program.'
		Case 1152
			$ExitValue = '1152 Cannot start more than one instance of the specified program.'
		Case 1153
			$ExitValue = '1153 The specified program was written for an earlier version of Windows.'
		Case 1154
			$ExitValue = '1154 One of the library files needed to run this application is damaged.'
		Case 1155
			$ExitValue = '1155 No application is associated with the specified file for this operation.'
		Case 1156
			$ExitValue = '1156 An error occurred in sending the command to the application.'
		Case 1157
			$ExitValue = '1157 One of the library files needed to run this application cannot be found.'
		Case 1158
			$ExitValue = '1158 The current process has used all of its system allowance of handles for Window Manager objects.'
		Case 1159
			$ExitValue = '1159 The message can be used only with synchronous operations.'
		Case 1160
			$ExitValue = '1160 The indicated source element has no media.'
		Case 1161
			$ExitValue = '1161 The indicated destination element already contains media.'
		Case 1162
			$ExitValue = '1162 The indicated element does not exist.'
		Case 1163
			$ExitValue = '1163 The indicated element is part of a magazine that is not present.'
		Case 1164
			$ExitValue = '1164 The indicated device requires reinitialization due to hardware errors.'
		Case 1165
			$ExitValue = '1165 The device has indicated that cleaning is required before further operations are attempted.'
		Case 1166
			$ExitValue = '1166 The device has indicated that its door is open.'
		Case 1167
			$ExitValue = '1167 The device is not connected.'
		Case 1168
			$ExitValue = '1168 Element not found.'
		Case 1169
			$ExitValue = '1169 There was no match for the specified key in the index.'
		Case 1170
			$ExitValue = '1170 The property set specified does not exist on the object.'
		Case 1171
			$ExitValue = '1171 The point passed to GetMouseMovePointsEx is not in the buffer.'
		Case 1172
			$ExitValue = '1172 The tracking (workstation) service is not running.'
		Case 1173
			$ExitValue = '1173 The Volume ID could not be found.'
		Case 1175
			$ExitValue = '1175 Unable to remove the file to be replaced.'
		Case 1176
			$ExitValue = '1176 Unable to move the replacement file to the file to be replaced. The file to be replaced has retained its original name.'
		Case 1177
			$ExitValue = '1177 Unable to move the replacement file to the file to be replaced. The file to be replaced has been renamed using the backup name.'
		Case 1178
			$ExitValue = '1178 The volume change journal is being deleted.'
		Case 1179
			$ExitValue = '1179 The volume change journal is not active.'
		Case 1180
			$ExitValue = '1180 A file was found, but it may not be the correct file.'
		Case 1181
			$ExitValue = '1181 The journal entry has been deleted from the journal.'
		Case 1200
			$ExitValue = '1200 The specified device name is invalid.'
		Case 1201
			$ExitValue = '1201 The device is not currently connected but it is a remembered connection.'
		Case 1202
			$ExitValue = '1202 The local device name has a remembered connection to another network resource.'
		Case 1203
			$ExitValue = '1203 No network provider accepted the given network path.'
		Case 1204
			$ExitValue = '1204 The specified network provider name is invalid.'
		Case 1205
			$ExitValue = '1205 Unable to open the network connection profile.'
		Case 1206
			$ExitValue = '1206 The network connection profile is corrupted.'
		Case 1207
			$ExitValue = '1207 Cannot enumerate a noncontainer.'
		Case 1208
			$ExitValue = '1208 An extended error has occurred.'
		Case 1209
			$ExitValue = '1209 The format of the specified group name is invalid.'
		Case 1210
			$ExitValue = '1210 The format of the specified computer name is invalid.'
		Case 1211
			$ExitValue = '1211 The format of the specified event name is invalid.'
		Case 1212
			$ExitValue = '1212 The format of the specified domain name is invalid.'
		Case 1213
			$ExitValue = '1213 The format of the specified service name is invalid.'
		Case 1214
			$ExitValue = '1214 The format of the specified network name is invalid.'
		Case 1215
			$ExitValue = '1215 The format of the specified share name is invalid.'
		Case 1216
			$ExitValue = '1216 The format of the specified password is invalid.'
		Case 1217
			$ExitValue = '1217 The format of the specified message name is invalid.'
		Case 1218
			$ExitValue = '1218 The format of the specified message destination is invalid.'
		Case 1219
			$ExitValue = '1219 Multiple connections to a server or shared resource by the same user, using more than one user name, are not allowed. Disconnect all previous connections to the server or shared resource and try again.'
		Case 1220
			$ExitValue = '1220 An attempt was made to establish a session to a network server, but there are already too many sessions established to that server.'
		Case 1221
			$ExitValue = '1221 The workgroup or domain name is already in use by another computer on the network.'
		Case 1222
			$ExitValue = '1222 The network is not present or not started.'
		Case 1223
			$ExitValue = '1223 The operation was canceled by the user.'
		Case 1224
			$ExitValue = '1224 The requested operation cannot be performed on a file with a user-mapped section open.'
		Case 1225
			$ExitValue = '1225 The remote system refused the network connection.'
		Case 1226
			$ExitValue = '1226 The network connection was gracefully closed.'
		Case 1227
			$ExitValue = '1227 The network transport endpoint already has an address associated with it.'
		Case 1228
			$ExitValue = '1228 An address has not yet been associated with the network endpoint.'
		Case 1229
			$ExitValue = '1229 An operation was attempted on a nonexistent network connection.'
		Case 1230
			$ExitValue = '1230 An invalid operation was attempted on an active network connection.'
		Case 1231
			$ExitValue = '1231 The network location cannot be reached. For information about network troubleshooting, see Windows Help.'
		Case 1232
			$ExitValue = '1232 The network location cannot be reached. For information about network troubleshooting, see Windows Help.'
		Case 1233
			$ExitValue = '1233 The network location cannot be reached. For information about network troubleshooting, see Windows Help.'
		Case 1234
			$ExitValue = '1234 No service is operating at the destination network endpoint on the remote system.'
		Case 1235
			$ExitValue = '1235 The request was aborted.'
		Case 1236
			$ExitValue = '1236 The network connection was aborted by the local system.'
		Case 1237
			$ExitValue = '1237 The operation could not be completed. A retry should be performed.'
		Case 1238
			$ExitValue = '1238 A connection to the server could not be made because the limit on the number of concurrent connections for this account has been reached.'
		Case 1239
			$ExitValue = '1239 Attempting to log in during an unauthorized time of day for this account.'
		Case 1240
			$ExitValue = '1240 The account is not authorized to log in from this station.'
		Case 1241
			$ExitValue = '1241 The network address could not be used for the operation requested.'
		Case 1242
			$ExitValue = '1242 The service is already registered.'
		Case 1243
			$ExitValue = '1243 The specified service does not exist.'
		Case 1244
			$ExitValue = '1244 The operation being requested was not performed because the user has not been authenticated.'
		Case 1245
			$ExitValue = '1245 The operation being requested was not performed because the user has not logged on to the network. The specified service does not exist.'
		Case 1246
			$ExitValue = '1246 Continue with work in progress.'
		Case 1247
			$ExitValue = '1247 An attempt was made to perform an initialization operation when initialization has already been completed.'
		Case 1248
			$ExitValue = '1248 No more local devices.'
		Case 1249
			$ExitValue = '1249 The specified site does not exist.'
		Case 1250
			$ExitValue = '1250 A domain controller with the specified name already exists.'
		Case 1251
			$ExitValue = '1251 This operation is supported only when you are connected to the server.'
		Case 1252
			$ExitValue = '1252 The group policy framework should call the extension even if there are no changes.'
		Case 1253
			$ExitValue = '1253 The specified user does not have a valid profile.'
		Case 1254
			$ExitValue = '1254 This operation is not supported on a Microsoft Small Business Server.'
		Case 1255
			$ExitValue = '1255 The server machine is shutting down.'
		Case 1256
			$ExitValue = '1256 The remote system is not available. For information about network troubleshooting, see Windows Help.'
		Case 1257
			$ExitValue = '1257 The security identifier provided is not from an account domain.'
		Case 1258
			$ExitValue = '1258 The security identifier provided does not have a domain component.'
		Case 1259
			$ExitValue = '1259 AppHelp dialog canceled thus preventing the application from starting.'
		Case 1260
			$ExitValue = '1260 Windows cannot open this program because it has been prevented by a software restriction policy. For more information, open Event Viewer or contact your system administrator.'
		Case 1261
			$ExitValue = '1261 A program attempt to use an invalid register value. Normally caused by an uninitialized register. This error is Itanium specific.'
		Case 1262
			$ExitValue = '1262 The share is currently offline or does not exist.'
		Case 1263
			$ExitValue = '1263 The kerberos protocol encountered an error while validating the KDC certificate during smartcard logon.'
		Case 1264
			$ExitValue = '1264 The kerberos protocol encountered an error while attempting to utilize the smartcard subsystem.'
		Case 1265
			$ExitValue = '1265 The system detected a possible attempt to compromise security. Please ensure that you can contact the server that authenticated you.'
		Case 1266
			$ExitValue = '1266 The smartcard certificate used for authentication has been revoked. Please contact your system administrator. There may be additional information in the event log.'
		Case 1267
			$ExitValue = '1267 An untrusted certificate authority was detected while processing the smartcard certificate used for authentication. Please contact your system administrator.'
		Case 1268
			$ExitValue = '1268 The revocation status of the smartcard certificate used for authentication could not be determined. Please contact your system administrator.'
		Case 1269
			$ExitValue = '1269 The smartcard certificate used for authentication was not trusted. Please contact your system administrator.'
		Case 1270
			$ExitValue = '1270 The smartcard certificate used for authentication has expired. Please contact your system administrator.'
		Case 1271
			$ExitValue = '1271 The machine is locked and cannot be shut down without the force option.'
		Case 1273
			$ExitValue = '1273 An application-defined callback gave invalid data when called.'
		Case 1274
			$ExitValue = '1274 The group policy framework should call the extension in the synchronous foreground policy refresh.'
		Case 1275
			$ExitValue = '1275 This driver has been blocked from loading.'
		Case 1276
			$ExitValue = '1276 A dynamic link library (DLL) referenced a module that was neither a DLL nor the processs executable image.'
		Case 1300
			$ExitValue = '1300 Not all privileges referenced are assigned to the caller.'
		Case 1301
			$ExitValue = '1301 Some mapping between account names and security IDs was not done.'
		Case 1302
			$ExitValue = '1302 No system quota limits are specifically set for this account.'
		Case 1303
			$ExitValue = '1303 No encryption key is available. A well-known encryption key was returned.'
		Case 1304
			$ExitValue = '1304 The password is too complex to be converted to a LAN Manager password. The LAN Manager password returned is a NULL string.'
		Case 1305
			$ExitValue = '1305 The revision level is unknown.'
		Case 1306
			$ExitValue = '1306 Indicates two revision levels are incompatible.'
		Case 1307
			$ExitValue = '1307 This security ID may not be assigned as the owner of this object.'
		Case 1308
			$ExitValue = '1308 This security ID may not be assigned as the primary group of an object.'
		Case 1309
			$ExitValue = '1309 An attempt has been made to operate on an impersonation token by a thread that is not currently impersonating a client.'
		Case 1310
			$ExitValue = '1310 The group may not be disabled.'
		Case 1311
			$ExitValue = '1311 There are currently no logon servers available to service the logon request.'
		Case 1312
			$ExitValue = '1312 A specified logon session does not exist. It may already have been terminated.'
		Case 1313
			$ExitValue = '1313 A specified privilege does not exist.'
		Case 1314
			$ExitValue = '1314 A required privilege is not held by the client.'
		Case 1315
			$ExitValue = '1315 The name provided is not a properly formed account name.'
		Case 1316
			$ExitValue = '1316 The specified user already exists.'
		Case 1317
			$ExitValue = '1317 The specified user does not exist.'
		Case 1318
			$ExitValue = '1318 The specified group already exists.'
		Case 1319
			$ExitValue = '1319 The specified group does not exist.'
		Case 1320
			$ExitValue = '1320 Either the specified user account is already a member of the specified group, or the specified group cannot be deleted because it contains a member.'
		Case 1321
			$ExitValue = '1321 The specified user account is not a member of the specified group account.'
		Case 1322
			$ExitValue = '1322 The last remaining administration account cannot be disabled or deleted.'
		Case 1323
			$ExitValue = '1323 Unable to update the password. The value provided as the current password is incorrect.'
		Case 1324
			$ExitValue = '1324 Unable to update the password. The value provided for the new password contains values that are not allowed in passwords.'
		Case 1325
			$ExitValue = '1325 Unable to update the password. The value provided for the new password does not meet the length, complexity, or history requirement of the domain.'
		Case 1326
			$ExitValue = '1326 Logon failure: unknown user name or bad password.'
		Case 1327
			$ExitValue = '1327 Logon failure: user account restriction. Possible reasons are blank passwords not allowed, logon hour restrictions, or a policy restriction has been enforced.'
		Case 1328
			$ExitValue = '1328 Logon failure: account logon time restriction violation.'
		Case 1329
			$ExitValue = '1329 Logon failure: user not allowed to log on to this computer.'
		Case 1330
			$ExitValue = '1330 Logon failure: the specified account password has expired.'
		Case 1331
			$ExitValue = '1331 Logon failure: account currently disabled.'
		Case 1332
			$ExitValue = '1332 No mapping between account names and security IDs was done.'
		Case 1333
			$ExitValue = '1333 Too many local user identifiers (LUIDs) were requested at one time.'
		Case 1334
			$ExitValue = '1334 No more local user identifiers (LUIDs) are available.'
		Case 1335
			$ExitValue = '1335 The subauthority part of a security ID is invalid for this particular use.'
		Case 1336
			$ExitValue = '1336 The access control list (ACL) structure is invalid.'
		Case 1337
			$ExitValue = '1337 The security ID structure is invalid.'
		Case 1338
			$ExitValue = '1338 The security descriptor structure is invalid.'
		Case 1340
			$ExitValue = '1340 The inherited access control list (ACL) or access control entry (ACE) could not be built.'
		Case 1341
			$ExitValue = '1341 The server is currently disabled.'
		Case 1342
			$ExitValue = '1342 The server is currently enabled.'
		Case 1343
			$ExitValue = '1343 The value provided was an invalid value for an identifier authority.'
		Case 1344
			$ExitValue = '1344 No more memory is available for security information updates.'
		Case 1345
			$ExitValue = '1345 The specified attributes are invalid, or incompatible with the attributes for the group as a whole.'
		Case 1346
			$ExitValue = '1346 Either a required impersonation level was not provided, or the provided impersonation level is invalid.'
		Case 1347
			$ExitValue = '1347 Cannot open an anonymous level security token.'
		Case 1348
			$ExitValue = '1348 The validation information class requested was invalid.'
		Case 1349
			$ExitValue = '1349 The type of the token is inappropriate for its attempted use.'
		Case 1350
			$ExitValue = '1350 Unable to perform a security operation on an object that has no associated security.'
		Case 1351
			$ExitValue = '1351 Configuration information could not be read from the domain controller, either because the machine is unavailable, or access has been denied.'
		Case 1352
			$ExitValue = '1352 The security account manager (SAM) or local security authority (LSA) server was in the wrong state to perform the security operation.'
		Case 1353
			$ExitValue = '1353 The domain was in the wrong state to perform the security operation.'
		Case 1354
			$ExitValue = '1354 This operation is only allowed for the Primary Domain Controller of the domain.'
		Case 1355
			$ExitValue = '1355 The specified domain either does not exist or could not be contacted.'
		Case 1356
			$ExitValue = '1356 The specified domain already exists.'
		Case 1357
			$ExitValue = '1357 An attempt was made to exceed the limit on the number of domains per server.'
		Case 1358
			$ExitValue = '1358 Unable to complete the requested operation because of either a catastrophic media failure or a data structure corruption on the disk.'
		Case 1359
			$ExitValue = '1359 An internal error occurred.'
		Case 1360
			$ExitValue = '1360 Generic access types were contained in an access mask which should already be mapped to nongeneric types.'
		Case 1361
			$ExitValue = '1361 A security descriptor is not in the right format (absolute or self-relative).'
		Case 1362
			$ExitValue = '1362 The requested action is restricted for use by logon processes only. The calling process has not registered as a logon process.'
		Case 1363
			$ExitValue = '1363 Cannot start a new logon session with an ID that is already in use.'
		Case 1364
			$ExitValue = '1364 A specified authentication package is unknown.'
		Case 1365
			$ExitValue = '1365 The logon session is not in a state that is consistent with the requested operation.'
		Case 1366
			$ExitValue = '1366 The logon session ID is already in use.'
		Case 1367
			$ExitValue = '1367 A logon request contained an invalid logon type value.'
		Case 1368
			$ExitValue = '1368 Unable to impersonate using a named pipe until data has been read from that pipe.'
		Case 1369
			$ExitValue = '1369 The transaction state of a registry subtree is incompatible with the requested operation.'
		Case 1370
			$ExitValue = '1370 An internal security database corruption has been encountered.'
		Case 1371
			$ExitValue = '1371 Cannot perform this operation on built-in accounts.'
		Case 1372
			$ExitValue = '1372 Cannot perform this operation on this built-in special group.'
		Case 1373
			$ExitValue = '1373 Cannot perform this operation on this built-in special user.'
		Case 1374
			$ExitValue = '1374 The user cannot be removed from a group because the group is currently the users primary group.'
		Case 1375
			$ExitValue = '1375 The token is already in use as a primary token.'
		Case 1376
			$ExitValue = '1376 The specified local group does not exist.'
		Case 1377
			$ExitValue = '1377 The specified account name is not a member of the local group.'
		Case 1378
			$ExitValue = '1378 The specified account name is already a member of the local group.'
		Case 1379
			$ExitValue = '1379 The specified local group already exists.'
		Case 1380
			$ExitValue = '1380 Logon failure: the user has not been granted the requested logon type at this computer.'
		Case 1381
			$ExitValue = '1381 The maximum number of secrets that may be stored in a single system has been exceeded.'
		Case 1382
			$ExitValue = '1382 The length of a secret exceeds the maximum length allowed.'
		Case 1383
			$ExitValue = '1383 The local security authority database contains an internal inconsistency.'
		Case 1384
			$ExitValue = '1384 During a logon attempt, the users security context accumulated too many security IDs.'
		Case 1385
			$ExitValue = '1385 Logon failure: the user has not been granted the requested logon type at this computer.'
		Case 1386
			$ExitValue = '1386 A cross-encrypted password is necessary to change a user password.'
		Case 1387
			$ExitValue = '1387 A new member could not be added to or removed from the local group because the member does not exist.'
		Case 1388
			$ExitValue = '1388 A new member could not be added to a local group because the member has the wrong account type.'
		Case 1389
			$ExitValue = '1389 Too many security IDs have been specified.'
		Case 1390
			$ExitValue = '1390 A cross-encrypted password is necessary to change this user password.'
		Case 1391
			$ExitValue = '1391 Indicates an ACL contains no inheritable components.'
		Case 1392
			$ExitValue = '1392 The file or directory is corrupted and unreadable.'
		Case 1393
			$ExitValue = '1393 The disk structure is corrupted and unreadable.'
		Case 1394
			$ExitValue = '1394 There is no user session key for the specified logon session.'
		Case 1395
			$ExitValue = '1395 The service being accessed is licensed for a particular number of connections. No more connections can be made to the service at this time because there are already as many connections as the service can accept.'
		Case 1396
			$ExitValue = '1396 Logon Failure: The target account name is incorrect.'
		Case 1397
			$ExitValue = '1397 Mutual Authentication failed. The servers password is out of date at the domain controller.'
		Case 1398
			$ExitValue = '1398 There is a time and/or date difference between the client and server.'
		Case 1399
			$ExitValue = '1399 This operation cannot be performed on the current domain.'
		Case 1400
			$ExitValue = '1400 Invalid window handle.'
		Case 1401
			$ExitValue = '1401 Invalid menu handle.'
		Case 1402
			$ExitValue = '1402 Invalid cursor handle.'
		Case 1403
			$ExitValue = '1403 Invalid accelerator table handle.'
		Case 1404
			$ExitValue = '1404 Invalid hook handle.'
		Case 1405
			$ExitValue = '1405 Invalid handle to a multiple-window position structure.'
		Case 1406
			$ExitValue = '1406 Cannot create a top-level child window.'
		Case 1407
			$ExitValue = '1407 Cannot find window class.'
		Case 1408
			$ExitValue = '1408 Invalid window; it belongs to other thread.'
		Case 1409
			$ExitValue = '1409 Hot key is already registered.'
		Case 1410
			$ExitValue = '1410 Class already exists.'
		Case 1411
			$ExitValue = '1411 Class does not exist.'
		Case 1412
			$ExitValue = '1412 Class still has open windows.'
		Case 1413
			$ExitValue = '1413 Invalid index.'
		Case 1414
			$ExitValue = '1414 Invalid icon handle.'
		Case 1415
			$ExitValue = '1415 Using private DIALOG window words.'
		Case 1416
			$ExitValue = '1416 The list box identifier was not found.'
		Case 1417
			$ExitValue = '1417 No wildcards were found.'
		Case 1418
			$ExitValue = '1418 Thread does not have a clipboard open.'
		Case 1419
			$ExitValue = '1419 Hot key is not registered.'
		Case 1420
			$ExitValue = '1420 The window is not a valid dialog window.'
		Case 1421
			$ExitValue = '1421 Control ID not found.'
		Case 1422
			$ExitValue = '1422 Invalid message for a combo box because it does not have an edit control.'
		Case 1423
			$ExitValue = '1423 The window is not a combo box.'
		Case 1424
			$ExitValue = '1424 Height must be less than 256.'
		Case 1425
			$ExitValue = '1425 Invalid device context (DC) handle.'
		Case 1426
			$ExitValue = '1426 Invalid hook procedure type.'
		Case 1427
			$ExitValue = '1427 Invalid hook procedure.'
		Case 1428
			$ExitValue = '1428 Cannot set nonlocal hook without a module handle.'
		Case 1429
			$ExitValue = '1429 This hook procedure can only be set globally.'
		Case 1430
			$ExitValue = '1430 The journal hook procedure is already installed.'
		Case 1431
			$ExitValue = '1431 The hook procedure is not installed.'
		Case 1432
			$ExitValue = '1432 Invalid message for single-selection list box.'
		Case 1433
			$ExitValue = '1433 LB_SETCOUNT sent to non-lazy list box.'
		Case 1434
			$ExitValue = '1434 This list box does not support tab stops.'
		Case 1435
			$ExitValue = '1435 Cannot destroy object created by another thread.'
		Case 1436
			$ExitValue = '1436 Child windows cannot have menus.'
		Case 1437
			$ExitValue = '1437 The window does not have a system menu.'
		Case 1438
			$ExitValue = '1438 Invalid message box style.'
		Case 1439
			$ExitValue = '1439 Invalid system-wide (SPI_*) parameter.'
		Case 1440
			$ExitValue = '1440 Screen already locked.'
		Case 1441
			$ExitValue = '1441 All handles to windows in a multiple-window position structure must have the same parent.'
		Case 1442
			$ExitValue = '1442 The window is not a child window.'
		Case 1443
			$ExitValue = '1443 Invalid GW_* command.'
		Case 1444
			$ExitValue = '1444 Invalid thread identifier.'
		Case 1445
			$ExitValue = '1445 Cannot process a message from a window that is not a multiple document interface (MDI) window.'
		Case 1446
			$ExitValue = '1446 Popup menu already active.'
		Case 1447
			$ExitValue = '1447 The window does not have scroll bars.'
		Case 1448
			$ExitValue = '1448 Scroll bar range cannot be greater than MAXLONG.'
		Case 1449
			$ExitValue = '1449 Cannot show or remove the window in the way specified.'
		Case 1450
			$ExitValue = '1450 Insufficient system resources exist to complete the requested service.'
		Case 1451
			$ExitValue = '1451 Insufficient system resources exist to complete the requested service.'
		Case 1452
			$ExitValue = '1452 Insufficient system resources exist to complete the requested service.'
		Case 1453
			$ExitValue = '1453 Insufficient quota to complete the requested service.'
		Case 1454
			$ExitValue = '1454 Insufficient quota to complete the requested service.'
		Case 1455
			$ExitValue = '1455 The paging file is too small for this operation to complete.'
		Case 1456
			$ExitValue = '1456 A menu item was not found.'
		Case 1457
			$ExitValue = '1457 Invalid keyboard layout handle.'
		Case 1458
			$ExitValue = '1458 Hook type not allowed.'
		Case 1459
			$ExitValue = '1459 This operation requires an interactive window station.'
		Case 1460
			$ExitValue = '1460 This operation returned because the timeout period expired.'
		Case 1461
			$ExitValue = '1461 Invalid monitor handle.'
		Case 1500
			$ExitValue = '1500 The event log file is corrupted.'
		Case 1501
			$ExitValue = '1501 No event log file could be opened, so the event logging service did not start.'
		Case 1502
			$ExitValue = '1502 The event log file is full.'
		Case 1503
			$ExitValue = '1503 The event log file has changed between read operations.'
		Case 1601
			$ExitValue = '1601 The Windows Installer service could not be accessed. This can occur if you are running Windows in safe mode, or if the Windows Installer is not correctly installed. Contact your support personnel for assistance.'
		Case 1602
			$ExitValue = '1602 User cancelled installation.'
		Case 1603
			$ExitValue = '1603 Fatal error during installation.'
		Case 1604
			$ExitValue = '1604 Installation suspended, incomplete.'
		Case 1605
			$ExitValue = '1605 This action is only valid for products that are currently installed.'
		Case 1606
			$ExitValue = '1606 Feature ID not registered.'
		Case 1607
			$ExitValue = '1607 Component ID not registered.'
		Case 1608
			$ExitValue = '1608 Unknown property.'
		Case 1609
			$ExitValue = '1609 Handle is in an invalid state.'
		Case 1610
			$ExitValue = '1610 The configuration data for this product is corrupt. Contact your support personnel.'
		Case 1611
			$ExitValue = '1611 Component qualifier not present.'
		Case 1612
			$ExitValue = '1612 The installation source for this product is not available. Verify that the source exists and that you can access it.'
		Case 1613
			$ExitValue = '1613 This installation package cannot be installed by the Windows Installer service. You must install a Windows service pack that contains a newer version of the Windows Installer service.'
		Case 1614
			$ExitValue = '1614 Product is uninstalled.'
		Case 1615
			$ExitValue = '1615 SQL query syntax invalid or unsupported.'
		Case 1616
			$ExitValue = '1616 Record field does not exist.'
		Case 1617
			$ExitValue = '1617 The device has been removed.'
		Case 1618
			$ExitValue = '1618 Another installation is already in progress. Complete that installation before proceeding with this install.'
		Case 1619
			$ExitValue = '1619 This installation package could not be opened. Verify that the package exists and that you can access it, or contact the application vendor to verify that this is a valid Windows Installer package.'
		Case 1620
			$ExitValue = '1620 This installation package could not be opened. Contact the application vendor to verify that this is a valid Windows Installer package.'
		Case 1621
			$ExitValue = '1621 There was an error starting the Windows Installer service user interface. Contact your support personnel.'
		Case 1622
			$ExitValue = '1622 Error opening installation log file. Verify that the specified log file location exists and that you can write to it.'
		Case 1623
			$ExitValue = '1623 The language of this installation package is not supported by your system.'
		Case 1624
			$ExitValue = '1624 Error applying transforms. Verify that the specified transform paths are valid.'
		Case 1625
			$ExitValue = '1625 This installation is forbidden by system policy. Contact your system administrator.'
		Case 1626
			$ExitValue = '1626 Function could not be executed.'
		Case 1627
			$ExitValue = '1627 Function failed during execution.'
		Case 1628
			$ExitValue = '1628 Invalid or unknown table specified.'
		Case 1629
			$ExitValue = '1629 Data supplied is of wrong type.'
		Case 1630
			$ExitValue = '1630 Data of this type is not supported.'
		Case 1631
			$ExitValue = '1631 The Windows Installer service failed to start. Contact your support personnel.'
		Case 1632
			$ExitValue = '1632 The Temp folder is on a drive that is full or inaccessible. Free up space on the drive or verify that you have write permission on the Temp folder.'
		Case 1633
			$ExitValue = '1633 This installation package is not supported by this processor type. Contact your product vendor.'
		Case 1634
			$ExitValue = '1634 Component not used on this computer.'
		Case 1635
			$ExitValue = '1635 This patch package could not be opened. Verify that the patch package exists and that you can access it, or contact the application vendor to verify that this is a valid Windows Installer patch package.'
		Case 1636
			$ExitValue = '1636 This patch package could not be opened. Contact the application vendor to verify that this is a valid Windows Installer patch package.'
		Case 1637
			$ExitValue = '1637 This patch package cannot be processed by the Windows Installer service. You must install a Windows service pack that contains a newer version of the Windows Installer service.'
		Case 1638
			$ExitValue = '1638 Another version of this product is already installed. Installation of this version cannot continue. To configure or remove the existing version of this product, use Add/Remove Programs on the Control Panel.'
		Case 1639
			$ExitValue = '1639 Invalid command line argument. Consult the Windows Installer SDK for detailed command line help.'
		Case 1640
			$ExitValue = '1640 Only administrators have permission to add, remove, or configure server software during a Terminal Services remote session. If you want to install or configure software on the server, contact your network administrator.'
		Case 1641
			$ExitValue = '1641 The requested operation completed successfully. The system will be restarted so the changes can take effect.'
		Case 1642
			$ExitValue = '1642 The upgrade patch cannot be installed by the Windows Installer service because the program to be upgraded may be missing, or the upgrade patch may update a different version of the program. Verify that the program to be upgraded exists on your computer and that you have the correct upgrade patch.'
		Case 1643
			$ExitValue = '1643 The patch package is not permitted by software restriction policy.'
		Case 1644
			$ExitValue = '1644 One or more customizations are not permitted by software restriction policy.'
		Case 1700
			$ExitValue = '1700 The string binding is invalid.'
		Case 1701
			$ExitValue = '1701 The binding handle is not the correct type.'
		Case 1702
			$ExitValue = '1702 The binding handle is invalid.'
		Case 1703
			$ExitValue = '1703 The RPC protocol sequence is not supported.'
		Case 1704
			$ExitValue = '1704 The RPC protocol sequence is invalid.'
		Case 1705
			$ExitValue = '1705 The string universal unique identifier (UUID) is invalid.'
		Case 1706
			$ExitValue = '1706 The endpoint format is invalid.'
		Case 1707
			$ExitValue = '1707 The network address is invalid.'
		Case 1708
			$ExitValue = '1708 No endpoint was found.'
		Case 1709
			$ExitValue = '1709 The timeout value is invalid.'
		Case 1710
			$ExitValue = '1710 The object universal unique identifier (UUID) was not found.'
		Case 1711
			$ExitValue = '1711 The object universal unique identifier (UUID) has already been registered.'
		Case 1712
			$ExitValue = '1712 The type universal unique identifier (UUID) has already been registered.'
		Case 1713
			$ExitValue = '1713 The RPC server is already listening.'
		Case 1714
			$ExitValue = '1714 No protocol sequences have been registered.'
		Case 1715
			$ExitValue = '1715 The RPC server is not listening.'
		Case 1716
			$ExitValue = '1716 The manager type is unknown.'
		Case 1717
			$ExitValue = '1717 The interface is unknown.'
		Case 1718
			$ExitValue = '1718 There are no bindings.'
		Case 1719
			$ExitValue = '1719 There are no protocol sequences.'
		Case 1720
			$ExitValue = '1720 The endpoint cannot be created.'
		Case 1721
			$ExitValue = '1721 Not enough resources are available to complete this operation.'
		Case 1722
			$ExitValue = '1722 The RPC server is unavailable.'
		Case 1723
			$ExitValue = '1723 The RPC server is too busy to complete this operation.'
		Case 1724
			$ExitValue = '1724 The network options are invalid.'
		Case 1725
			$ExitValue = '1725 There are no remote procedure calls active on this thread.'
		Case 1726
			$ExitValue = '1726 The remote procedure call failed.'
		Case 1727
			$ExitValue = '1727 The remote procedure call failed and did not execute.'
		Case 1728
			$ExitValue = '1728 A remote procedure call (RPC) protocol error occurred.'
		Case 1730
			$ExitValue = '1730 The transfer syntax is not supported by the RPC server.'
		Case 1732
			$ExitValue = '1732 The universal unique identifier (UUID) type is not supported.'
		Case 1733
			$ExitValue = '1733 The tag is invalid.'
		Case 1734
			$ExitValue = '1734 The array bounds are invalid.'
		Case 1735
			$ExitValue = '1735 The binding does not contain an entry name.'
		Case 1736
			$ExitValue = '1736 The name syntax is invalid.'
		Case 1737
			$ExitValue = '1737 The name syntax is not supported.'
		Case 1739
			$ExitValue = '1739 No network address is available to use to construct a universal unique identifier (UUID).'
		Case 1740
			$ExitValue = '1740 The endpoint is a duplicate.'
		Case 1741
			$ExitValue = '1741 The authentication type is unknown.'
		Case 1742
			$ExitValue = '1742 The maximum number of calls is too small.'
		Case 1743
			$ExitValue = '1743 The string is too long.'
		Case 1744
			$ExitValue = '1744 The RPC protocol sequence was not found.'
		Case 1745
			$ExitValue = '1745 The procedure number is out of range.'
		Case 1746
			$ExitValue = '1746 The binding does not contain any authentication information.'
		Case 1747
			$ExitValue = '1747 The authentication service is unknown.'
		Case 1748
			$ExitValue = '1748 The authentication level is unknown.'
		Case 1749
			$ExitValue = '1749 The security context is invalid.'
		Case 1750
			$ExitValue = '1750 The authorization service is unknown.'
		Case 1751
			$ExitValue = '1751 The entry is invalid.'
		Case 1752
			$ExitValue = '1752 The server endpoint cannot perform the operation.'
		Case 1753
			$ExitValue = '1753 There are no more endpoints available from the endpoint mapper.'
		Case 1754
			$ExitValue = '1754 No interfaces have been exported.'
		Case 1755
			$ExitValue = '1755 The entry name is incomplete.'
		Case 1756
			$ExitValue = '1756 The version option is invalid.'
		Case 1757
			$ExitValue = '1757 There are no more members.'
		Case 1758
			$ExitValue = '1758 There is nothing to unexport.'
		Case 1759
			$ExitValue = '1759 The interface was not found.'
		Case 1760
			$ExitValue = '1760 The entry already exists.'
		Case 1761
			$ExitValue = '1761 The entry is not found.'
		Case 1762
			$ExitValue = '1762 The name service is unavailable.'
		Case 1763
			$ExitValue = '1763 The network address family is invalid.'
		Case 1764
			$ExitValue = '1764 The requested operation is not supported.'
		Case 1765
			$ExitValue = '1765 No security context is available to allow impersonation.'
		Case 1766
			$ExitValue = '1766 An internal error occurred in a remote procedure call (RPC).'
		Case 1767
			$ExitValue = '1767 The RPC server attempted an integer division by zero.'
		Case 1768
			$ExitValue = '1768 An addressing error occurred in the RPC server.'
		Case 1769
			$ExitValue = '1769 A floating-point operation at the RPC server caused a division by zero.'
		Case 1770
			$ExitValue = '1770 A floating-point underflow occurred at the RPC server.'
		Case 1771
			$ExitValue = '1771 A floating-point overflow occurred at the RPC server.'
		Case 1772
			$ExitValue = '1772 The list of RPC servers available for the binding of auto handles has been exhausted.'
		Case 1773
			$ExitValue = '1773 Unable to open the character translation table file.'
		Case 1774
			$ExitValue = '1774 The file containing the character translation table has fewer than 512 bytes.'
		Case 1775
			$ExitValue = '1775 A null context handle was passed from the client to the host during a remote procedure call.'
		Case 1777
			$ExitValue = '1777 The context handle changed during a remote procedure call.'
		Case 1778
			$ExitValue = '1778 The binding handles passed to a remote procedure call do not match.'
		Case 1779
			$ExitValue = '1779 The stub is unable to get the remote procedure call handle.'
		Case 1780
			$ExitValue = '1780 A null reference pointer was passed to the stub.'
		Case 1781
			$ExitValue = '1781 The enumeration value is out of range.'
		Case 1782
			$ExitValue = '1782 The byte count is too small.'
		Case 1783
			$ExitValue = '1783 The stub received bad data.'
		Case 1784
			$ExitValue = '1784 The supplied user buffer is not valid for the requested operation.'
		Case 1785
			$ExitValue = '1785 The disk media is not recognized. It may not be formatted.'
		Case 1786
			$ExitValue = '1786 The workstation does not have a trust secret.'
		Case 1787
			$ExitValue = '1787 The security database on the server does not have a computer account for this workstation trust relationship.'
		Case 1788
			$ExitValue = '1788 The trust relationship between the primary domain and the trusted domain failed.'
		Case 1789
			$ExitValue = '1789 The trust relationship between this workstation and the primary domain failed.'
		Case 1790
			$ExitValue = '1790 The network logon failed.'
		Case 1791
			$ExitValue = '1791 A remote procedure call is already in progress for this thread.'
		Case 1792
			$ExitValue = '1792 An attempt was made to logon, but the network logon service was not started.'
		Case 1793
			$ExitValue = '1793 The users account has expired.'
		Case 1794
			$ExitValue = '1794 The redirector is in use and cannot be unloaded.'
		Case 1795
			$ExitValue = '1795 The specified printer driver is already installed.'
		Case 1796
			$ExitValue = '1796 The specified port is unknown.'
		Case 1797
			$ExitValue = '1797 The printer driver is unknown.'
		Case 1798
			$ExitValue = '1798 The print processor is unknown.'
		Case 1799
			$ExitValue = '1799 The specified separator file is invalid.'
		Case 1800
			$ExitValue = '1800 The specified priority is invalid.'
		Case 1801
			$ExitValue = '1801 The printer name is invalid.'
		Case 1802
			$ExitValue = '1802 The printer already exists.'
		Case 1803
			$ExitValue = '1803 The printer command is invalid.'
		Case 1804
			$ExitValue = '1804 The specified datatype is invalid.'
		Case 1805
			$ExitValue = '1805 The environment specified is invalid.'
		Case 1806
			$ExitValue = '1806 There are no more bindings.'
		Case 1807
			$ExitValue = '1807 The account used is an interdomain trust account. Use your global user account or local user account to access this server.'
		Case 1808
			$ExitValue = '1808 The account used is a computer account. Use your global user account or local user account to access this server.'
		Case 1809
			$ExitValue = '1809 The account used is a server trust account. Use your global user account or local user account to access this server.'
		Case 1810
			$ExitValue = '1810 The name or security ID (SID) of the domain specified is inconsistent with the trust information for that domain.'
		Case 1811
			$ExitValue = '1811 The server is in use and cannot be unloaded.'
		Case 1812
			$ExitValue = '1812 The specified image file did not contain a resource section.'
		Case 1813
			$ExitValue = '1813 The specified resource type cannot be found in the image file.'
		Case 1814
			$ExitValue = '1814 The specified resource name cannot be found in the image file.'
		Case 1815
			$ExitValue = '1815 The specified resource language ID cannot be found in the image file.'
		Case 1816
			$ExitValue = '1816 Not enough quota is available to process this command.'
		Case 1817
			$ExitValue = '1817 No interfaces have been registered.'
		Case 1818
			$ExitValue = '1818 The remote procedure call was cancelled.'
		Case 1819
			$ExitValue = '1819 The binding handle does not contain all required information.'
		Case 1820
			$ExitValue = '1820 A communications failure occurred during a remote procedure call.'
		Case 1821
			$ExitValue = '1821 The requested authentication level is not supported.'
		Case 1822
			$ExitValue = '1822 No principal name registered.'
		Case 1823
			$ExitValue = '1823 The error specified is not a valid Windows RPC error code.'
		Case 1824
			$ExitValue = '1824 A UUID that is valid only on this computer has been allocated.'
		Case 1825
			$ExitValue = '1825 A security package specific error occurred.'
		Case 1826
			$ExitValue = '1826 Thread is not canceled.'
		Case 1827
			$ExitValue = '1827 Invalid operation on the encoding/decoding handle.'
		Case 1828
			$ExitValue = '1828 Incompatible version of the serializing package.'
		Case 1829
			$ExitValue = '1829 Incompatible version of the RPC stub.'
		Case 1830
			$ExitValue = '1830 The RPC pipe object is invalid or corrupted.'
		Case 1831
			$ExitValue = '1831 An invalid operation was attempted on an RPC pipe object.'
		Case 1832
			$ExitValue = '1832 Unsupported RPC pipe version.'
		Case 1898
			$ExitValue = '1898 The group member was not found.'
		Case 1899
			$ExitValue = '1899 The endpoint mapper database entry could not be created.'
		Case 1900
			$ExitValue = '1900 The object universal unique identifier (UUID) is the nil UUID.'
		Case 1901
			$ExitValue = '1901 The specified time is invalid.'
		Case 1902
			$ExitValue = '1902 The specified form name is invalid.'
		Case 1903
			$ExitValue = '1903 The specified form size is invalid.'
		Case 1904
			$ExitValue = '1904 The specified printer handle is already being waited on"' 
		Case 1905
			$ExitValue = '1905 The specified printer has been deleted.'
		Case 1906
			$ExitValue = '1906 The state of the printer is invalid.'
		Case 1907
			$ExitValue = '1907 The users password must be changed before logging on the first time.'
		Case 1908
			$ExitValue = '1908 Could not find the domain controller for this domain.'
		Case 1909
			$ExitValue = '1909 The referenced account is currently locked out and may not be logged on to.'
		Case 1910
			$ExitValue = '1910 The object exporter specified was not found.'
		Case 1911
			$ExitValue = '1911 The object specified was not found.'
		Case 1912
			$ExitValue = '1912 The object resolver set specified was not found.'
		Case 1913
			$ExitValue = '1913 Some data remains to be sent in the request buffer.'
		Case 1914
			$ExitValue = '1914 Invalid asynchronous remote procedure call handle.'
		Case 1915
			$ExitValue = '1915 Invalid asynchronous RPC call handle for this operation.'
		Case 1916
			$ExitValue = '1916 The RPC pipe object has already been closed.'
		Case 1917
			$ExitValue = '1917 The RPC call completed before all pipes were processed.'
		Case 1918
			$ExitValue = '1918 No more data is available from the RPC pipe.'
		Case 1919
			$ExitValue = '1919 No site name is available for this machine.'
		Case 1920
			$ExitValue = '1920 The file cannot be accessed by the system.'
		Case 1921
			$ExitValue = '1921 The name of the file cannot be resolved by the system.'
		Case 1922
			$ExitValue = '1922 The entry is not of the expected type.'
		Case 1923
			$ExitValue = '1923 Not all object UUIDs could be exported to the specified entry.'
		Case 1924
			$ExitValue = '1924 Interface could not be exported to the specified entry.'
		Case 1925
			$ExitValue = '1925 The specified profile entry could not be added.'
		Case 1926
			$ExitValue = '1926 The specified profile element could not be added.'
		Case 1927
			$ExitValue = '1927 The specified profile element could not be removed.'
		Case 1928
			$ExitValue = '1928 The group element could not be added.'
		Case 1929
			$ExitValue = '1929 The group element could not be removed.'
		Case 1930
			$ExitValue = '1930 The printer driver is not compatible with a policy enabled on your computer that blocks NT 4.0 drivers.'
		Case 1931
			$ExitValue = '1931 The context has expired and can no longer be used.'
		Case 2000
			$ExitValue = '2000 The pixel format is invalid.'
		Case 2001
			$ExitValue = '2001 The specified driver is invalid.'
		Case 2002
			$ExitValue = '2002 The window style or class attribute is invalid for this operation.'
		Case 2003
			$ExitValue = '2003 The requested metafile operation is not supported.'
		Case 2004
			$ExitValue = '2004 The requested transformation operation is not supported.'
		Case 2005
			$ExitValue = '2005 The requested clipping operation is not supported.'
		Case 2010
			$ExitValue = '2010 The specified color management module is invalid.'
		Case 2011
			$ExitValue = '2011 The specified color profile is invalid.'
		Case 2012
			$ExitValue = '2012 The specified tag was not found.'
		Case 2013
			$ExitValue = '2013 A required tag is not present.'
		Case 2014
			$ExitValue = '2014 The specified tag is already present.'
		Case 2015
			$ExitValue = '2015 The specified color profile is not associated with any device.'
		Case 2016
			$ExitValue = '2016 The specified color profile was not found.'
		Case 2017
			$ExitValue = '2017 The specified color space is invalid.'
		Case 2018
			$ExitValue = '2018 Image Color Management is not enabled.'
		Case 2019
			$ExitValue = '2019 There was an error while deleting the color transform.'
		Case 2020
			$ExitValue = '2020 The specified color transform is invalid.'
		Case 2021
			$ExitValue = '2021 The specified transform does not match the bitmaps color space.'
		Case 2022
			$ExitValue = '2022 The specified named color index is not present in the profile.'
		Case 2108
			$ExitValue = '2108 The network connection was made successfully, but the user had to be prompted for a password other than the one originally specified.'
		Case 2109
			$ExitValue = '2109 The network connection was made successfully using default credentials.'
		Case 2202
			$ExitValue = '2202 The specified username is invalid.'
		Case 2250
			$ExitValue = '2250 This network connection does not exist.'
		Case 2401
			$ExitValue = '2401 This network connection has files open or requests pending.'
		Case 2402
			$ExitValue = '2402 Active connections still exist.'
		Case 2404
			$ExitValue = '2404 The device is in use by an active process and cannot be disconnected.'
		Case 3000
			$ExitValue = '3000 The specified print monitor is unknown.'
		Case 3001
			$ExitValue = '3001 The specified printer driver is currently in use.'
		Case 3002
			$ExitValue = '3002 The spool file was not found.'
		Case 3003
			$ExitValue = '3003 A StartDocPrinter call was not issued.'
		Case 3004
			$ExitValue = '3004 An AddJob call was not issued.'
		Case 3005
			$ExitValue = '3005 The specified print processor has already been installed.'
		Case 3006
			$ExitValue = '3006 The specified print monitor has already been installed.'
		Case 3007
			$ExitValue = '3007 The specified print monitor does not have the required functions.'
		Case 3008
			$ExitValue = '3008 The specified print monitor is currently in use.'
		Case 3009
			$ExitValue = '3009 The requested operation is not allowed when there are jobs queued to the printer.'
		Case 3010
			$ExitValue = '3010 The requested operation is successful. Changes will not be effective until the system is rebooted.'
		Case 3011
			$ExitValue = '3011 The requested operation is successful. Changes will not be effective until the service is restarted.'
		Case 3012
			$ExitValue = '3012 No printers were found.'
		Case 3013
			$ExitValue = '3013 The printer driver is known to be unreliable.'
		Case 3014
			$ExitValue = '3014 The printer driver is known to harm the system.'
		Case 4000
			$ExitValue = '4000 WINS encountered an error while processing the command.'
		Case 4001
			$ExitValue = '4001 The local WINS cannot be deleted.'
		Case 4002
			$ExitValue = '4002 The importation from the file failed.'
		Case 4003
			$ExitValue = '4003 The backup failed. Was a full backup done before?"' 
		Case 4004
			$ExitValue = '4004 The backup failed. Check the directory to which you are backing the database.'
		Case 4005
			$ExitValue = '4005 The name does not exist in the WINS database.'
		Case 4006
			$ExitValue = '4006 Replication with a nonconfigured partner is not allowed.'
		Case 4100
			$ExitValue = '4100 The DHCP client has obtained an IP address that is already in use on the network. The local interface will be disabled until the DHCP client can obtain a new address.'
		Case 4200
			$ExitValue = '4200 The GUID passed was not recognized as valid by a WMI data provider.'
		Case 4201
			$ExitValue = '4201 The instance name passed was not recognized as valid by a WMI data provider.'
		Case 4202
			$ExitValue = '4202 The data item ID passed was not recognized as valid by a WMI data provider.'
		Case 4203
			$ExitValue = '4203 The WMI request could not be completed and should be retried.'
		Case 4204
			$ExitValue = '4204 The WMI data provider could not be located.'
		Case 4205
			$ExitValue = '4205 The WMI data provider references an instance set that has not been registered.'
		Case 4206
			$ExitValue = '4206 The WMI data block or event notification has already been enabled.'
		Case 4207
			$ExitValue = '4207 The WMI data block is no longer available.'
		Case 4208
			$ExitValue = '4208 The WMI data service is not available.'
		Case 4209
			$ExitValue = '4209 The WMI data provider failed to carry out the request.'
		Case 4210
			$ExitValue = '4210 The WMI MOF information is not valid.'
		Case 4211
			$ExitValue = '4211 The WMI registration information is not valid.'
		Case 4212
			$ExitValue = '4212 The WMI data block or event notification has already been disabled.'
		Case 4213
			$ExitValue = '4213 The WMI data item or data block is read only.'
		Case 4214
			$ExitValue = '4214 The WMI data item or data block could not be changed.'
		Case 4300
			$ExitValue = '4300 The media identifier does not represent a valid medium.'
		Case 4301
			$ExitValue = '4301 The library identifier does not represent a valid library.'
		Case 4302
			$ExitValue = '4302 The media pool identifier does not represent a valid media pool.'
		Case 4303
			$ExitValue = '4303 The drive and medium are not compatible or exist in different libraries.'
		Case 4304
			$ExitValue = '4304 The medium currently exists in an offline library and must be online to perform this operation.'
		Case 4305
			$ExitValue = '4305 The operation cannot be performed on an offline library.'
		Case 4306
			$ExitValue = '4306 The library, drive, or media pool is empty.'
		Case 4307
			$ExitValue = '4307 The library, drive, or media pool must be empty to perform this operation.'
		Case 4308
			$ExitValue = '4308 No media is currently available in this media pool or library.'
		Case 4309
			$ExitValue = '4309 A resource required for this operation is disabled.'
		Case 4310
			$ExitValue = '4310 The media identifier does not represent a valid cleaner.'
		Case 4311
			$ExitValue = '4311 The drive cannot be cleaned or does not support cleaning.'
		Case 4312
			$ExitValue = '4312 The object identifier does not represent a valid object.'
		Case 4313
			$ExitValue = '4313 Unable to read from or write to the database.'
		Case 4314
			$ExitValue = '4314 The database is full.'
		Case 4315
			$ExitValue = '4315 The medium is not compatible with the device or media pool.'
		Case 4316
			$ExitValue = '4316 The resource required for this operation does not exist.'
		Case 4317
			$ExitValue = '4317 The operation identifier is not valid.'
		Case 4318
			$ExitValue = '4318 The media is not mounted or ready for use.'
		Case 4319
			$ExitValue = '4319 The device is not ready for use.'
		Case 4320
			$ExitValue = '4320 The operator or administrator has refused the request.'
		Case 4321
			$ExitValue = '4321 The drive identifier does not represent a valid drive.'
		Case 4322
			$ExitValue = '4322 Library is full. No slot is available for use.'
		Case 4323
			$ExitValue = '4323 The transport cannot access the medium.'
		Case 4324
			$ExitValue = '4324 Unable to load the medium into the drive.'
		Case 4325
			$ExitValue = '4325 Unable to retrieve status about the drive.'
		Case 4326
			$ExitValue = '4326 Unable to retrieve status about the slot.'
		Case 4327
			$ExitValue = '4327 Unable to retrieve status about the transport.'
		Case 4328
			$ExitValue = '4328 Cannot use the transport because it is already in use.'
		Case 4329
			$ExitValue = '4329 Unable to open or close the inject/eject port.'
		Case 4330
			$ExitValue = '4330 Unable to eject the media because it is in a drive.'
		Case 4331
			$ExitValue = '4331 A cleaner slot is already reserved.'
		Case 4332
			$ExitValue = '4332 A cleaner slot is not reserved.'
		Case 4333
			$ExitValue = '4333 The cleaner cartridge has performed the maximum number of drive cleanings.'
		Case 4334
			$ExitValue = '4334 Unexpected on-medium identifier.'
		Case 4335
			$ExitValue = '4335 The last remaining item in this group or resource cannot be deleted.'
		Case 4336
			$ExitValue = '4336 The message provided exceeds the maximum size allowed for this parameter.'
		Case 4337
			$ExitValue = '4337 The volume contains system or paging files.'
		Case 4338
			$ExitValue = '4338 The media type cannot be removed from this library since at least one drive in the library reports it can support this media type.'
		Case 4339
			$ExitValue = '4339 This offline media cannot be mounted on this system since no enabled drives are present which can be used.'
		Case 4340
			$ExitValue = '4340 A cleaner cartridge is present in the tape library.'
		Case 4350
			$ExitValue = '4350 The remote storage service was not able to recall the file.'
		Case 4351
			$ExitValue = '4351 The remote storage service is not operational at this time.'
		Case 4352
			$ExitValue = '4352 The remote storage service encountered a media error.'
		Case 4390
			$ExitValue = '4390 The file or directory is not a reparse point.'
		Case 4391
			$ExitValue = '4391 The reparse point attribute cannot be set because it conflicts with an existing attribute.'
		Case 4392
			$ExitValue = '4392 The data present in the reparse point buffer is invalid.'
		Case 4393
			$ExitValue = '4393 The tag present in the reparse point buffer is invalid.'
		Case 4394
			$ExitValue = '4394 There is a mismatch between the tag specified in the request and the tag present in the reparse point.'
		Case 4500
			$ExitValue = '4500 Single Instance Storage is not available on this volume.'
		Case 5001
			$ExitValue = '5001 The cluster resource cannot be moved to another group because other resources are dependent on it.'
		Case 5002
			$ExitValue = '5002 The cluster resource dependency cannot be found.'
		Case 5003
			$ExitValue = '5003 The cluster resource cannot be made dependent on the specified resource because it is already dependent.'
		Case 5004
			$ExitValue = '5004 The cluster resource is not online.'
		Case 5005
			$ExitValue = '5005 A cluster node is not available for this operation.'
		Case 5006
			$ExitValue = '5006 The cluster resource is not available.'
		Case 5007
			$ExitValue = '5007 The cluster resource could not be found.'
		Case 5008
			$ExitValue = '5008 The cluster is being shut down.'
		Case 5009
			$ExitValue = '5009 A cluster node cannot be evicted from the cluster unless the node is down.'
		Case 5010
			$ExitValue = '5010 The object already exists.'
		Case 5011
			$ExitValue = '5011 The object is already in the list.'
		Case 5012
			$ExitValue = '5012 The cluster group is not available for any new requests.'
		Case 5013
			$ExitValue = '5013 The cluster group could not be found.'
		Case 5014
			$ExitValue = '5014 The operation could not be completed because the cluster group is not online.'
		Case 5015
			$ExitValue = '5015 The cluster node is not the owner of the resource.'
		Case 5016
			$ExitValue = '5016 The cluster node is not the owner of the group.'
		Case 5017
			$ExitValue = '5017 The cluster resource could not be created in the specified resource monitor.'
		Case 5018
			$ExitValue = '5018 The cluster resource could not be brought online by the resource monitor.'
		Case 5019
			$ExitValue = '5019 The operation could not be completed because the cluster resource is online.'
		Case 5020
			$ExitValue = '5020 The cluster resource could not be deleted or brought offline because it is the quorum resource.'
		Case 5021
			$ExitValue = '5021 The cluster could not make the specified resource a quorum resource because it is not capable of being a quorum resource.'
		Case 5022
			$ExitValue = '5022 The cluster software is shutting down.'
		Case 5023
			$ExitValue = '5023 The group or resource is not in the correct state to perform the requested operation.'
		Case 5024
			$ExitValue = '5024 The properties were stored but not all changes will take effect until the next time the resource is brought online.'
		Case 5025
			$ExitValue = '5025 The cluster could not make the specified resource a quorum resource because it does not belong to a shared storage class.'
		Case 5026
			$ExitValue = '5026 The cluster resource could not be deleted since it is a core resource.'
		Case 5027
			$ExitValue = '5027 The quorum resource failed to come online.'
		Case 5028
			$ExitValue = '5028 The quorum log could not be created or mounted successfully.'
		Case 5029
			$ExitValue = '5029 The cluster log is corrupt.'
		Case 5030
			$ExitValue = '5030 The record could not be written to the cluster log since it exceeds the maximum size.'
		Case 5031
			$ExitValue = '5031 The cluster log exceeds its maximum size.'
		Case 5032
			$ExitValue = '5032 No checkpoint record was found in the cluster log.'
		Case 5033
			$ExitValue = '5033 The minimum required disk space needed for logging is not available.'
		Case 5034
			$ExitValue = '5034 The cluster node failed to take control of the quorum resource because the resource is owned by another active node.'
		Case 5035
			$ExitValue = '5035 A cluster network is not available for this operation.'
		Case 5036
			$ExitValue = '5036 A cluster node is not available for this operation.'
		Case 5037
			$ExitValue = '5037 All cluster nodes must be running to perform this operation.'
		Case 5038
			$ExitValue = '5038 A cluster resource failed.'
		Case 5039
			$ExitValue = '5039 The cluster node is not valid.'
		Case 5040
			$ExitValue = '5040 The cluster node already exists.'
		Case 5041
			$ExitValue = '5041 A node is in the process of joining the cluster.'
		Case 5042
			$ExitValue = '5042 The cluster node was not found.'
		Case 5043
			$ExitValue = '5043 The cluster local node information was not found.'
		Case 5044
			$ExitValue = '5044 The cluster network already exists.'
		Case 5045
			$ExitValue = '5045 The cluster network was not found.'
		Case 5046
			$ExitValue = '5046 The cluster network interface already exists.'
		Case 5047
			$ExitValue = '5047 The cluster network interface was not found.'
		Case 5048
			$ExitValue = '5048 The cluster request is not valid for this object.'
		Case 5049
			$ExitValue = '5049 The cluster network provider is not valid.'
		Case 5050
			$ExitValue = '5050 The cluster node is down.'
		Case 5051
			$ExitValue = '5051 The cluster node is not reachable.'
		Case 5052
			$ExitValue = '5052 The cluster node is not a member of the cluster.'
		Case 5053
			$ExitValue = '5053 A cluster join operation is not in progress.'
		Case 5054
			$ExitValue = '5054 The cluster network is not valid.'
		Case 5056
			$ExitValue = '5056 The cluster node is up.'
		Case 5057
			$ExitValue = '5057 The cluster IP address is already in use.'
		Case 5058
			$ExitValue = '5058 The cluster node is not paused.'
		Case 5059
			$ExitValue = '5059 No cluster security context is available.'
		Case 5060
			$ExitValue = '5060 The cluster network is not configured for internal cluster communication.'
		Case 5061
			$ExitValue = '5061 The cluster node is already up.'
		Case 5062
			$ExitValue = '5062 The cluster node is already down.'
		Case 5063
			$ExitValue = '5063 The cluster network is already online.'
		Case 5064
			$ExitValue = '5064 The cluster network is already offline.'
		Case 5065
			$ExitValue = '5065 The cluster node is already a member of the cluster.'
		Case 5066
			$ExitValue = '5066 The cluster network is the only one configured for internal cluster communication between two or more active cluster nodes. The internal communication capability cannot be removed from the network.'
		Case 5067
			$ExitValue = '5067 One or more cluster resources depend on the network to provide service to clients. The client access capability cannot be removed from the network.'
		Case 5068
			$ExitValue = '5068 This operation cannot be performed on the cluster resource as it the quorum resource. You may not bring the quorum resource offline or modify its possible owners list.'
		Case 5069
			$ExitValue = '5069 The cluster quorum resource is not allowed to have any dependencies.'
		Case 5070
			$ExitValue = '5070 The cluster node is paused.'
		Case 5071
			$ExitValue = '5071 The cluster resource cannot be brought online. The owner node cannot run this resource.'
		Case 5072
			$ExitValue = '5072 The cluster node is not ready to perform the requested operation.'
		Case 5073
			$ExitValue = '5073 The cluster node is shutting down.'
		Case 5074
			$ExitValue = '5074 The cluster join operation was aborted.'
		Case 5075
			$ExitValue = '5075 The cluster join operation failed due to incompatible software versions between the joining node and its sponsor.'
		Case 5076
			$ExitValue = '5076 This resource cannot be created because the cluster has reached the limit on the number of resources it can monitor.'
		Case 5077
			$ExitValue = '5077 The system configuration changed during the cluster join or form operation. The join or form operation was aborted.'
		Case 5078
			$ExitValue = '5078 The specified resource type was not found.'
		Case 5079
			$ExitValue = '5079 The specified node does not support a resource of this type. This may be due to version inconsistencies or due to the absence of the resource DLL on this node.'
		Case 5080
			$ExitValue = '5080 The specified resource name is supported by this resource DLL. This may be due to a bad (or changed) name supplied to the resource DLL.'
		Case 5081
			$ExitValue = '5081 No authentication package could be registered with the RPC server.'
		Case 5082
			$ExitValue = '5082 You cannot bring the group online because the owner of the group is not in the preferred list for the group. To change the owner node for the group, move the group.'
		Case 5083
			$ExitValue = '5083 The join operation failed because the cluster database sequence number has changed or is incompatible with the locker node. This may happen during a join operation if the cluster database was changing during the join.'
		Case 5084
			$ExitValue = '5084 The resource monitor will not allow the fail operation to be performed while the resource is in its current state. This may happen if the resource is in a pending state.'
		Case 5085
			$ExitValue = '5085 A non locker code got a request to reserve the lock for making global updates.'
		Case 5086
			$ExitValue = '5086 The quorum disk could not be located by the cluster service.'
		Case 5087
			$ExitValue = '5087 The backup up cluster database is possibly corrupt.'
		Case 5088
			$ExitValue = '5088 A DFS root already exists in this cluster node.'
		Case 5089
			$ExitValue = '5089 An attempt to modify a resource property failed because it conflicts with another existing property.'
		Case 5890
			$ExitValue = '5890 An operation was attempted that is incompatible with the current membership state of the node.'
		Case 5891
			$ExitValue = '5891 The quorum resource does not contain the quorum log.'
		Case 5892
			$ExitValue = '5892 The membership engine requested shutdown of the cluster service on this node.'
		Case 5893
			$ExitValue = '5893 The join operation failed because the cluster instance ID of the joining node does not match the cluster instance ID of the sponsor node.'
		Case 5894
			$ExitValue = '5894 A matching network for the specified IP address could not be found. Please also specify a subnet mask and a cluster network.'
		Case 5895
			$ExitValue = '5895 The actual data type of the property did not match the expected data type of the property.'
		Case 5896
			$ExitValue = '5896 The cluster node was evicted from the cluster successfully, but the node was not cleaned up. Extended status information explaining why the node was not cleaned up is available.'
		Case 5897
			$ExitValue = '5897 Two or more parameter values specified for a resources properties are In conflict.'
		Case 5898
			$ExitValue = '5898 This computer cannot be made a member of a cluster.'
		Case 5899
			$ExitValue = '5899 This computer cannot be made a member of a cluster because it does not have the correct version of Windows installed.'
		Case 5900
			$ExitValue = '5900 A cluster cannot be created with the specified cluster name because that cluster name is already in use. Specify a different name for the cluster.'
		Case 6000
			$ExitValue = '6000 The specified file could not be encrypted.'
		Case 6001
			$ExitValue = '6001 The specified file could not be decrypted.'
		Case 6002
			$ExitValue = '6002 The specified file is encrypted and the user does not have the ability to decrypt it.'
		Case 6003
			$ExitValue = '6003 There is no valid encryption recovery policy configured for this system.'
		Case 6004
			$ExitValue = '6004 The required encryption driver is not loaded for this system.'
		Case 6005
			$ExitValue = '6005 The file was encrypted with a different encryption driver than is currently loaded.'
		Case 6006
			$ExitValue = '6006 There are no EFS keys defined for the user.'
		Case 6007
			$ExitValue = '6007 The specified file is not encrypted.'
		Case 6008
			$ExitValue = '6008 The specified file is not in the defined EFS export format.'
		Case 6009
			$ExitValue = '6009 The specified file is read only.'
		Case 6010
			$ExitValue = '6010 The directory has been disabled for encryption.'
		Case 6011
			$ExitValue = '6011 The server is not trusted for remote encryption operation.'
		Case 6012
			$ExitValue = '6012 Recovery policy configured for this system contains invalid recovery certificate.'
		Case 6013
			$ExitValue = '6013 The encryption algorithm used on the source file needs a bigger key buffer than the one on the destination file.'
		Case 6014
			$ExitValue = '6014 The disk partition does not support file encryption.'
		Case 6015
			$ExitValue = '6015 This machine is disabled for file encryption.'
		Case 6016
			$ExitValue = '6016 A newer system is required to decrypt this encrypted file.'
		Case 6118
			$ExitValue = '6118 The list of servers for this workgroup is not currently available.'
		Case 6200
			$ExitValue = '6200 The Task Scheduler service must be configured to run in the System account to function properly. Individual tasks may be configured to run in other accounts.'
		Case 7001
			$ExitValue = '7001 The specified session name is invalid.'
		Case 7002
			$ExitValue = '7002 The specified protocol driver is invalid.'
		Case 7003
			$ExitValue = '7003 The specified protocol driver was not found in the system path.'
		Case 7004
			$ExitValue = '7004 The specified terminal connection driver was not found in the system path.'
		Case 7005
			$ExitValue = '7005 A registry key for event logging could not be created for this session.'
		Case 7006
			$ExitValue = '7006 A service with the same name already exists on the system.'
		Case 7007
			$ExitValue = '7007 A close operation is pending on the session.'
		Case 7008
			$ExitValue = '7008 There are no free output buffers available.'
		Case 7009
			$ExitValue = '7009 The MODEM.INF file was not found.'
		Case 7010
			$ExitValue = '7010 The modem name was not found in MODEM.INF.'
		Case 7011
			$ExitValue = '7011 The modem did not accept the command sent to it. Verify that the configured modem name matches the attached modem.'
		Case 7012
			$ExitValue = '7012 The modem did not respond to the command sent to it. Verify that the modem is properly cabled and powered on.'
		Case 7013
			$ExitValue = '7013 Carrier detect has failed or carrier has been dropped due to disconnect.'
		Case 7014
			$ExitValue = '7014 Dial tone not detected within the required time. Verify that the phone cable is properly attached and functional.'
		Case 7015
			$ExitValue = '7015 Busy signal detected at remote site on callback.'
		Case 7016
			$ExitValue = '7016 Voice detected at remote site on callback.'
		Case 7017
			$ExitValue = '7017 Transport driver error"' 
		Case 7022
			$ExitValue = '7022 The specified session cannot be found.'
		Case 7023
			$ExitValue = '7023 The specified session name is already in use.'
		Case 7024
			$ExitValue = '7024 The requested operation cannot be completed because the terminal connection is currently busy processing a connect, disconnect, reset, or delete operation.'
		Case 7025
			$ExitValue = '7025 An attempt has been made to connect to a session whose video mode is not supported by the current client.'
		Case 7035
			$ExitValue = '7035 The application attempted to enable DOS graphics mode. DOS graphics mode is not supported.'
		Case 7037
			$ExitValue = '7037 Your interactive logon privilege has been disabled. Please contact your administrator.'
		Case 7038
			$ExitValue = '7038 The requested operation can be performed only on the system console. This is most often the result of a driver or system DLL requiring direct console access.'
		Case 7040
			$ExitValue = '7040 The client failed to respond to the server connect message.'
		Case 7041
			$ExitValue = '7041 Disconnecting the console session is not supported.'
		Case 7042
			$ExitValue = '7042 Reconnecting a disconnected session to the console is not supported.'
		Case 7044
			$ExitValue = '7044 The request to control another session remotely was denied.'
		Case 7045
			$ExitValue = '7045 The requested session access is denied.'
		Case 7049
			$ExitValue = '7049 The specified terminal connection driver is invalid.'
		Case 7050
			$ExitValue = '7050 The requested session cannot be controlled remotely. This may be because the session is disconnected or does not currently have a user logged on.'
		Case 7051
			$ExitValue = '7051 The requested session is not configured to allow remote control.'
		Case 7052
			$ExitValue = '7052 Your request to connect to this Terminal Server has been rejected. Your Terminal Server client license number is currently being used by another user. Please call your system administrator to obtain a unique license number.'
		Case 7053
			$ExitValue = '7053 Your request to connect to this Terminal Server has been rejected. Your Terminal Server client license number has not been entered for this copy of the Terminal Server client. Please contact your system administrator.'
		Case 7054
			$ExitValue = '7054 The system has reached its licensed logon limit. Please try again later.'
		Case 7055
			$ExitValue = '7055 The client you are using is not licensed to use this system. Your logon request is denied.'
		Case 7056
			$ExitValue = '7056 The system license has expired. Your logon request is denied.'
		Case 7057
			$ExitValue = '7057 Remote control could not be terminated because the specified session is not currently being remotely controlled.'
		Case 7058
			$ExitValue = '7058 The remote control of the console was terminated because the display mode was changed. Changing the display mode in a remote control session is not supported.'
		Case 8001
			$ExitValue = '8001 The file replication service API was called incorrectly.'
		Case 8002
			$ExitValue = '8002 The file replication service cannot be started.'
		Case 8003
			$ExitValue = '8003 The file replication service cannot be stopped.'
		Case 8004
			$ExitValue = '8004 The file replication service API terminated the request. The event log may have more information.'
		Case 8005
			$ExitValue = '8005 The file replication service terminated the request. The event log may have more information.'
		Case 8006
			$ExitValue = '8006 The file replication service cannot be contacted. The event log may have more information.'
		Case 8007
			$ExitValue = '8007 The file replication service cannot satisfy the request because the user has insufficient privileges. The event log may have more information.'
		Case 8008
			$ExitValue = '8008 The file replication service cannot satisfy the request because authenticated RPC is not available. The event log may have more information.'
		Case 8009
			$ExitValue = '8009 The file replication service cannot satisfy the request because the user has insufficient privileges on the domain controller. The event log may have more information.'
		Case 8010
			$ExitValue = '8010 The file replication service cannot satisfy the request because authenticated RPC is not available on the domain controller. The event log may have more information.'
		Case 8011
			$ExitValue = '8011 The file replication service cannot communicate with the file replication service on the domain controller. The event log may have more information.'
		Case 8012
			$ExitValue = '8012 The file replication service on the domain controller cannot communicate with the file replication service on this computer. The event log may have more information.'
		Case 8013
			$ExitValue = '8013 The file replication service cannot populate the system volume because of an internal error. The event log may have more information.'
		Case 8014
			$ExitValue = '8014 The file replication service cannot populate the system volume because of an internal timeout. The event log may have more information.'
		Case 8015
			$ExitValue = '8015 The file replication service cannot process the request. The system volume is busy with a previous request.'
		Case 8016
			$ExitValue = '8016 The file replication service cannot stop replicating the system volume because of an internal error. The event log may have more information.'
		Case 8017
			$ExitValue = '8017 The file replication service detected an invalid parameter.'
		Case 8200
			$ExitValue = '8200 An error occurred while installing the directory service. For more information, see the event log.'
		Case 8201
			$ExitValue = '8201 The directory service evaluated group memberships locally.'
		Case 8202
			$ExitValue = '8202 The specified directory service attribute or value does not exist.'
		Case 8203
			$ExitValue = '8203 The attribute syntax specified to the directory service is invalid.'
		Case 8204
			$ExitValue = '8204 The attribute type specified to the directory service is not defined.'
		Case 8205
			$ExitValue = '8205 The specified directory service attribute or value already exists.'
		Case 8206
			$ExitValue = '8206 The directory service is busy.'
		Case 8207
			$ExitValue = '8207 The directory service is unavailable.'
		Case 8208
			$ExitValue = '8208 The directory service was unable to allocate a relative identifier.'
		Case 8209
			$ExitValue = '8209 The directory service has exhausted the pool of relative identifiers.'
		Case 8210
			$ExitValue = '8210 The requested operation could not be performed because the directory service is not the master for that type of operation.'
		Case 8211
			$ExitValue = '8211 The directory service was unable to initialize the subsystem that allocates relative identifiers.'
		Case 8212
			$ExitValue = '8212 The requested operation did not satisfy one or more constraints associated with the class of the object.'
		Case 8213
			$ExitValue = '8213 The directory service can perform the requested operation only on a leaf object.'
		Case 8214
			$ExitValue = '8214 The directory service cannot perform the requested operation on the RDN attribute of an object.'
		Case 8215
			$ExitValue = '8215 The directory service detected an attempt to modify the object class of an object.'
		Case 8216
			$ExitValue = '8216 The requested cross-domain move operation could not be performed.'
		Case 8217
			$ExitValue = '8217 Unable to contact the global catalog server.'
		Case 8218
			$ExitValue = '8218 The policy object is shared and can only be modified at the root.'
		Case 8219
			$ExitValue = '8219 The policy object does not exist.'
		Case 8220
			$ExitValue = '8220 The requested policy information is only in the directory service.'
		Case 8221
			$ExitValue = '8221 A domain controller promotion is currently active.'
		Case 8222
			$ExitValue = '8222 A domain controller promotion is not currently active"' 
		Case 8224
			$ExitValue = '8224 An operations error occurred.'
		Case 8225
			$ExitValue = '8225 A protocol error occurred.'
		Case 8226
			$ExitValue = '8226 The time limit for this request was exceeded.'
		Case 8227
			$ExitValue = '8227 The size limit for this request was exceeded.'
		Case 8228
			$ExitValue = '8228 The administrative limit for this request was exceeded.'
		Case 8229
			$ExitValue = '8229 The compare response was false.'
		Case 8230
			$ExitValue = '8230 The compare response was true.'
		Case 8231
			$ExitValue = '8231 The requested authentication method is not supported by the server.'
		Case 8232
			$ExitValue = '8232 A more secure authentication method is required for this server.'
		Case 8233
			$ExitValue = '8233 Inappropriate authentication.'
		Case 8234
			$ExitValue = '8234 The authentication mechanism is unknown.'
		Case 8235
			$ExitValue = '8235 A referral was returned from the server.'
		Case 8236
			$ExitValue = '8236 The server does not support the requested critical extension.'
		Case 8237
			$ExitValue = '8237 This request requires a secure connection.'
		Case 8238
			$ExitValue = '8238 Inappropriate matching.'
		Case 8239
			$ExitValue = '8239 A constraint violation occurred.'
		Case 8240
			$ExitValue = '8240 There is no such object on the server.'
		Case 8241
			$ExitValue = '8241 There is an alias problem.'
		Case 8242
			$ExitValue = '8242 An invalid dn syntax has been specified.'
		Case 8243
			$ExitValue = '8243 The object is a leaf object.'
		Case 8244
			$ExitValue = '8244 There is an alias dereferencing problem.'
		Case 8245
			$ExitValue = '8245 The server is unwilling to process the request.'
		Case 8246
			$ExitValue = '8246 A loop has been detected.'
		Case 8247
			$ExitValue = '8247 There is a naming violation.'
		Case 8248
			$ExitValue = '8248 The result set is too large.'
		Case 8249
			$ExitValue = '8249 The operation affects multiple DSAs"' 
		Case 8250
			$ExitValue = '8250 The server is not operational.'
		Case 8251
			$ExitValue = '8251 A local error has occurred.'
		Case 8252
			$ExitValue = '8252 An encoding error has occurred.'
		Case 8253
			$ExitValue = '8253 A decoding error has occurred.'
		Case 8254
			$ExitValue = '8254 The search filter cannot be recognized.'
		Case 8255
			$ExitValue = '8255 One or more parameters are illegal.'
		Case 8256
			$ExitValue = '8256 The specified method is not supported.'
		Case 8257
			$ExitValue = '8257 No results were returned.'
		Case 8258
			$ExitValue = '8258 The specified control is not supported by the server.'
		Case 8259
			$ExitValue = '8259 A referral loop was detected by the client.'
		Case 8260
			$ExitValue = '8260 The preset referral limit was exceeded.'
		Case 8261
			$ExitValue = '8261 The search requires a SORT control.'
		Case 8262
			$ExitValue = '8262 The search results exceed the offset range specified.'
		Case 8301
			$ExitValue = '8301 The root object must be the head of a naming context. The root object cannot have an instantiated parent.'
		Case 8302
			$ExitValue = '8302 The add replica operation cannot be performed. The naming context must be writable in order to create the replica.'
		Case 8303
			$ExitValue = '8303 A reference to an attribute that is not defined in the schema occurred.'
		Case 8304
			$ExitValue = '8304 The maximum size of an object has been exceeded.'
		Case 8305
			$ExitValue = '8305 An attempt was made to add an object to the directory with a name that is already in use.'
		Case 8306
			$ExitValue = '8306 An attempt was made to add an object of a class that does not have an RDN defined in the schema.'
		Case 8307
			$ExitValue = '8307 An attempt was made to add an object using an RDN that is not the RDN defined in the schema.'
		Case 8308
			$ExitValue = '8308 None of the requested attributes were found on the objects.'
		Case 8309
			$ExitValue = '8309 The user buffer is too small.'
		Case 8310
			$ExitValue = '8310 The attribute specified in the operation is not present on the object.'
		Case 8311
			$ExitValue = '8311 Illegal modify operation. Some aspect of the modification is not permitted.'
		Case 8312
			$ExitValue = '8312 The specified object is too large.'
		Case 8313
			$ExitValue = '8313 The specified instance type is not valid.'
		Case 8314
			$ExitValue = '8314 The operation must be performed at a master DSA.'
		Case 8315
			$ExitValue = '8315 The object class attribute must be specified.'
		Case 8316
			$ExitValue = '8316 A required attribute is missing.'
		Case 8317
			$ExitValue = '8317 An attempt was made to modify an object to include an attribute that is not legal for its class"' 
		Case 8318
			$ExitValue = '8318 The specified attribute is already present on the object.'
		Case 8320
			$ExitValue = '8320 The specified attribute is not present, or has no values.'
		Case 8321
			$ExitValue = '8321 Multiple values were specified for an attribute that can have only one value.'
		Case 8322
			$ExitValue = '8322 A value for the attribute was not in the acceptable range of values.'
		Case 8323
			$ExitValue = '8323 The specified value already exists.'
		Case 8324
			$ExitValue = '8324 The attribute cannot be removed because it is not present on the object.'
		Case 8325
			$ExitValue = '8325 The attribute value cannot be removed because it is not present on the object.'
		Case 8326
			$ExitValue = '8326 The specified root object cannot be a subref.'
		Case 8327
			$ExitValue = '8327 Chaining is not permitted.'
		Case 8328
			$ExitValue = '8328 Chained evaluation is not permitted.'
		Case 8329
			$ExitValue = '8329 The operation could not be performed because the objects parent is either uninstantiated Or deleted.'
		Case 8330
			$ExitValue = '8330 Having a parent that is an alias is not permitted. Aliases are leaf objects.'
		Case 8331
			$ExitValue = '8331 The object and parent must be of the same type, either both masters or both replicas.'
		Case 8332
			$ExitValue = '8332 The operation cannot be performed because child objects exist. This operation can only be performed on a leaf object.'
		Case 8333
			$ExitValue = '8333 Directory object not found.'
		Case 8334
			$ExitValue = '8334 The aliased object is missing.'
		Case 8335
			$ExitValue = '8335 The object name has bad syntax.'
		Case 8336
			$ExitValue = '8336 It is not permitted for an alias to refer to another alias.'
		Case 8337
			$ExitValue = '8337 The alias cannot be dereferenced.'
		Case 8338
			$ExitValue = '8338 The operation is out of scope.'
		Case 8339
			$ExitValue = '8339 The operation cannot continue because the object is in the process of being removed.'
		Case 8340
			$ExitValue = '8340 The DSA object cannot be deleted.'
		Case 8341
			$ExitValue = '8341 A directory service error has occurred.'
		Case 8342
			$ExitValue = '8342 The operation can only be performed on an internal master DSA object.'
		Case 8343
			$ExitValue = '8343 The object must be of class DSA.'
		Case 8344
			$ExitValue = '8344 Insufficient access rights to perform the operation.'
		Case 8345
			$ExitValue = '8345 The object cannot be added because the parent is not on the list of possible superiors.'
		Case 8346
			$ExitValue = '8346 Access to the attribute is not permitted because the attribute is owned by the Security Accounts Manager (SAM).'
		Case 8347
			$ExitValue = '8347 The name has too many parts.'
		Case 8348
			$ExitValue = '8348 The name is too long.'
		Case 8349
			$ExitValue = '8349 The name value is too long.'
		Case 8350
			$ExitValue = '8350 The directory service encountered an error parsing a name.'
		Case 8351
			$ExitValue = '8351 The directory service cannot get the attribute type for a name.'
		Case 8352
			$ExitValue = '8352 The name does not identify an object; the name identifies a phantom.'
		Case 8353
			$ExitValue = '8353 The security descriptor is too short.'
		Case 8354
			$ExitValue = '8354 The security descriptor is invalid.'
		Case 8355
			$ExitValue = '8355 Failed to create name for deleted object.'
		Case 8356
			$ExitValue = '8356 The parent of a new subref must exist.'
		Case 8357
			$ExitValue = '8357 The object must be a naming context.'
		Case 8358
			$ExitValue = '8358 It is not permitted to add an attribute which is owned by the system.'
		Case 8359
			$ExitValue = '8359 The class of the object must be structural; you cannot instantiate an abstract class.'
		Case 8360
			$ExitValue = '8360 The schema object could not be found.'
		Case 8361
			$ExitValue = '8361 A local object with this GUID (dead or alive) already exists.'
		Case 8362
			$ExitValue = '8362 The operation cannot be performed on a back link.'
		Case 8363
			$ExitValue = '8363 The cross reference for the specified naming context could not be found.'
		Case 8364
			$ExitValue = '8364 The operation could not be performed because the directory service is shutting down.'
		Case 8365
			$ExitValue = '8365 The directory service request is invalid.'
		Case 8366
			$ExitValue = '8366 The role owner attribute could not be read.'
		Case 8367
			$ExitValue = '8367 The requested FSMO operation failed. The current FSMO holder could not be reached.'
		Case 8368
			$ExitValue = '8368 Modification of a DN across a naming context is not permitted.'
		Case 8369
			$ExitValue = '8369 The attribute cannot be modified because it is owned by the system.'
		Case 8370
			$ExitValue = '8370 Only the replicator can perform this function.'
		Case 8371
			$ExitValue = '8371 The specified class is not defined.'
		Case 8372
			$ExitValue = '8372 The specified class is not a subclass.'
		Case 8373
			$ExitValue = '8373 The name reference is invalid.'
		Case 8374
			$ExitValue = '8374 A cross reference already exists.'
		Case 8375
			$ExitValue = '8375 It is not permitted to delete a master cross reference.'
		Case 8376
			$ExitValue = '8376 Subtree notifications are only supported on NC heads.'
		Case 8377
			$ExitValue = '8377 Notification filter is too complex.'
		Case 8378
			$ExitValue = '8378 Schema update failed: duplicate RDN.'
		Case 8379
			$ExitValue = '8379 Schema update failed: duplicate OID"' 
		Case 8380
			$ExitValue = '8380 Schema update failed: duplicate MAPI identifier.'
		Case 8381
			$ExitValue = '8381 Schema update failed: duplicate schema-id GUID.'
		Case 8382
			$ExitValue = '8382 Schema update failed: duplicate LDAP display name.'
		Case 8383
			$ExitValue = '8383 Schema update failed: range-lower less than range upper"' 
		Case 8384
			$ExitValue = '8384 Schema update failed: syntax mismatch"' 
		Case 8385
			$ExitValue = '8385 Schema deletion failed: attribute is used in must-contain"' 
		Case 8386
			$ExitValue = '8386 Schema deletion failed: attribute is used in may-contain"' 
		Case 8387
			$ExitValue = '8387 Schema update failed: attribute in may-contain does not exist"' 
		Case 8388
			$ExitValue = '8388 Schema update failed: attribute in must-contain does not exist"' 
		Case 8389
			$ExitValue = '8389 Schema update failed: class in aux-class list does not exist or is not an auxiliary class"' 
		Case 8390
			$ExitValue = '8390 Schema update failed: class in poss-superiors does not exist"' 
		Case 8391
			$ExitValue = '8391 Schema update failed: class in subclassof list does not exist or does not satisfy hierarchy rules"' 
		Case 8392
			$ExitValue = '8392 Schema update failed: Rdn-Att-Id has wrong syntax"' 
		Case 8393
			$ExitValue = '8393 Schema deletion failed: class is used as auxiliary class"' 
		Case 8394
			$ExitValue = '8394 Schema deletion failed: class is used as sub class"' 
		Case 8395
			$ExitValue = '8395 Schema deletion failed: class is used as poss superior"' 
		Case 8396
			$ExitValue = '8396 Schema update failed in recalculating validation cache.'
		Case 8397
			$ExitValue = '8397 The tree deletion is not finished.'
		Case 8398
			$ExitValue = '8398 The requested delete operation could not be performed.'
		Case 8399
			$ExitValue = '8399 Cannot read the governs class identifier for the schema record.'
		Case 8400
			$ExitValue = '8400 The attribute schema has bad syntax.'
		Case 8401
			$ExitValue = '8401 The attribute could not be cached.'
		Case 8402
			$ExitValue = '8402 The class could not be cached.'
		Case 8403
			$ExitValue = '8403 The attribute could not be removed from the cache.'
		Case 8404
			$ExitValue = '8404 The class could not be removed from the cache.'
		Case 8405
			$ExitValue = '8405 The distinguished name attribute could not be read.'
		Case 8406
			$ExitValue = '8406 A required subref is missing.'
		Case 8407
			$ExitValue = '8407 The instance type attribute could not be retrieved.'
		Case 8408
			$ExitValue = '8408 An internal error has occurred.'
		Case 8409
			$ExitValue = '8409 A database error has occurred.'
		Case 8410
			$ExitValue = '8410 The attribute GOVERNSID is missing.'
		Case 8411
			$ExitValue = '8411 An expected attribute is missing.'
		Case 8412
			$ExitValue = '8412 The specified naming context is missing a cross reference.'
		Case 8413
			$ExitValue = '8413 A security checking error has occurred.'
		Case 8414
			$ExitValue = '8414 The schema is not loaded.'
		Case 8415
			$ExitValue = '8415 Schema allocation failed. Please check if the machine is running low on memory.'
		Case 8416
			$ExitValue = '8416 Failed to obtain the required syntax for the attribute schema.'
		Case 8417
			$ExitValue = '8417 The global catalog verification failed. The global catalog is not available or does not support the operation. Some part of the directory is currently not available.'
		Case 8418
			$ExitValue = '8418 The replication operation failed because of a schema mismatch between the servers involved.'
		Case 8419
			$ExitValue = '8419 The DSA object could not be found.'
		Case 8420
			$ExitValue = '8420 The naming context could not be found.'
		Case 8421
			$ExitValue = '8421 The naming context could not be found in the cache.'
		Case 8422
			$ExitValue = '8422 The child object could not be retrieved.'
		Case 8423
			$ExitValue = '8423 The modification was not permitted for security reasons.'
		Case 8424
			$ExitValue = '8424 The operation cannot replace the hidden record.'
		Case 8425
			$ExitValue = '8425 The hierarchy file is invalid.'
		Case 8426
			$ExitValue = '8426 The attempt to build the hierarchy table failed.'
		Case 8427
			$ExitValue = '8427 The directory configuration parameter is missing from the registry.'
		Case 8428
			$ExitValue = '8428 The attempt to count the address book indices failed.'
		Case 8429
			$ExitValue = '8429 The allocation of the hierarchy table failed.'
		Case 8430
			$ExitValue = '8430 The directory service encountered an internal failure.'
		Case 8431
			$ExitValue = '8431 The directory service encountered an unknown failure.'
		Case 8432
			$ExitValue = '8432 A root object requires a class of top.'
		Case 8433
			$ExitValue = '8433 This directory server is shutting down, and cannot take ownership of new floating single-master operation roles.'
		Case 8434
			$ExitValue = '8434 The directory service is missing mandatory configuration information, and is unable to determine the ownership of floating single-master operation roles.'
		Case 8435
			$ExitValue = '8435 The directory service was unable to transfer ownership of one or more floating single-master operation roles to other servers.'
		Case 8436
			$ExitValue = '8436 The replication operation failed.'
		Case 8437
			$ExitValue = '8437 An invalid parameter was specified for this replication operation.'
		Case 8438
			$ExitValue = '8438 The directory service is too busy to complete the replication operation at this time.'
		Case 8439
			$ExitValue = '8439 The distinguished name specified for this replication operation is invalid.'
		Case 8440
			$ExitValue = '8440 The naming context specified for this replication operation is invalid.'
		Case 8441
			$ExitValue = '8441 The distinguished name specified for this replication operation already exists.'
		Case 8442
			$ExitValue = '8442 The replication system encountered an internal error.'
		Case 8443
			$ExitValue = '8443 The replication operation encountered a database inconsistency.'
		Case 8444
			$ExitValue = '8444 The server specified for this replication operation could not be contacted.'
		Case 8445
			$ExitValue = '8445 The replication operation encountered an object with an invalid instance type.'
		Case 8446
			$ExitValue = '8446 The replication operation failed to allocate memory.'
		Case 8447
			$ExitValue = '8447 The replication operation encountered an error with the mail system.'
		Case 8448
			$ExitValue = '8448 The replication reference information for the target server already exists.'
		Case 8449
			$ExitValue = '8449 The replication reference information for the target server does not exist.'
		Case 8450
			$ExitValue = '8450 The naming context cannot be removed because it is replicated to another server.'
		Case 8451
			$ExitValue = '8451 The replication operation encountered a database error.'
		Case 8452
			$ExitValue = '8452 The naming context is in the process of being removed or is not replicated from the specified server.'
		Case 8453
			$ExitValue = '8453 Replication access was denied.'
		Case 8454
			$ExitValue = '8454 The requested operation is not supported by this version of the directory service.'
		Case 8455
			$ExitValue = '8455 The replication remote procedure call was cancelled.'
		Case 8456
			$ExitValue = '8456 The source server is currently rejecting replication requests.'
		Case 8457
			$ExitValue = '8457 The destination server is currently rejecting replication requests.'
		Case 8458
			$ExitValue = '8458 The replication operation failed due to a collision of object names.'
		Case 8459
			$ExitValue = '8459 The replication source has been reinstalled.'
		Case 8460
			$ExitValue = '8460 The replication operation failed because a required parent object is missing.'
		Case 8461
			$ExitValue = '8461 The replication operation was preempted.'
		Case 8462
			$ExitValue = '8462 The replication synchronization attempt was abandoned because of a lack of updates.'
		Case 8463
			$ExitValue = '8463 The replication operation was terminated because the system is shutting down.'
		Case 8464
			$ExitValue = '8464 The replication synchronization attempt failed as the destination partial attribute set is not a subset of source partial attribute set.'
		Case 8465
			$ExitValue = '8465 The replication synchronization attempt failed because a master replica attempted to sync from a partial replica.'
		Case 8466
			$ExitValue = '8466 The server specified for this replication operation was contacted, but that server was unable to contact an additional server needed to complete the operation.'
		Case 8467
			$ExitValue = '8467 The version of the Active Directory schema of the source forest is not compatible with the version of Active Directory on this computer. You must upgrade the operating system on a domain controller in the source forest before this computer can be added as a domain controller to that forest.'
		Case 8468
			$ExitValue = '8468 Schema update failed: An attribute with the same link identifier already exists.'
		Case 8469
			$ExitValue = '8469 Name translation: Generic processing error.'
		Case 8470
			$ExitValue = '8470 Name translation: Could not find the name or insufficient right to see name.'
		Case 8471
			$ExitValue = '8471 Name translation: Input name mapped to more than one output name.'
		Case 8472
			$ExitValue = '8472 Name translation: Input name found, but not the associated output format.'
		Case 8473
			$ExitValue = '8473 Name translation: Unable to resolve completely, only the domain was found.'
		Case 8474
			$ExitValue = '8474 Name translation: Unable to perform purely syntactical mapping at the client without going out to the wire.'
		Case 8475
			$ExitValue = '8475 Modification of a constructed att is not allowed.'
		Case 8476
			$ExitValue = '8476 The OM-Object-Class specified is incorrect for an attribute with the specified syntax.'
		Case 8477
			$ExitValue = '8477 The replication request has been posted; waiting for reply.'
		Case 8478
			$ExitValue = '8478 The requested operation requires a directory service, and none was available.'
		Case 8479
			$ExitValue = '8479 The LDAP display name of the class or attribute contains non-ASCII characters.'
		Case 8480
			$ExitValue = '8480 The requested search operation is only supported for base searches.'
		Case 8481
			$ExitValue = '8481 The search failed to retrieve attributes from the database.'
		Case 8482
			$ExitValue = '8482 The schema update operation tried to add a backward link attribute that has no corresponding forward link.'
		Case 8483
			$ExitValue = '8483 Source and destination of a cross domain move do not agree on the objects epoch number. Either source Or destination does Not have the latest version of the object.'
		Case 8484
			$ExitValue = '8484 Source and destination of a cross domain move do not agree on the objects current name. Either source Or destination does Not have the latest version of the object.'
		Case 8485
			$ExitValue = '8485 Source and destination of a cross domain move operation are identical. Caller should use local move operation instead of cross domain move operation.'
		Case 8486
			$ExitValue = '8486 Source and destination for a cross domain move are not in agreement on the naming contexts in the forest. Either source or destination does not have the latest version of the Partitions container.'
		Case 8487
			$ExitValue = '8487 Destination of a cross domain move is not authoritative for the destination naming context.'
		Case 8488
			$ExitValue = '8488 Source and destination of a cross domain move do not agree on the identity of the source object. Either source or destination does not have the latest version of the source object.'
		Case 8489
			$ExitValue = '8489 Object being moved across domains is already known to be deleted by the destination server. The source server does not have the latest version of the source object.'
		Case 8490
			$ExitValue = '8490 Another operation which requires exclusive access to the PDC PSMO is already in progress.'
		Case 8491
			$ExitValue = '8491 A cross domain move operation failed such that the two versions of the moved object exist - one each in the source and destination domains. The destination object needs to be removed to restore the system to a consistent state.'
		Case 8492
			$ExitValue = '8492 This object may not be moved across domain boundaries either because cross domain moves for this class are disallowed, or the object has some special characteristics, eg: trust account or restricted RID, which prevent its move.'
		Case 8493
			$ExitValue = '8493 Cannot move objects With memberships across domain boundaries as once moved, this would violate the membership conditions of the account group. Remove the object from any account group memberships And retry.'
		Case 8494
			$ExitValue = '8494 A naming context head must be the immediate child of another naming context head, not of an interior node.'
		Case 8495
			$ExitValue = '8495 The directory cannot validate the proposed naming context name because it does not hold a replica of the naming context above the proposed naming context. Please ensure that the domain naming master role is held by a server that is configured as a global catalog server, and that the server is up to date with its replication partners. (Applies only to Windows 2000 Domain Naming masters)"' 
		Case 8496
			$ExitValue = '8496 Destination domain must be in native mode.'
		Case 8497
			$ExitValue = '8497 The operation cannot be performed because the server does not have an infrastructure container in the domain of interest.'
		Case 8498
			$ExitValue = '8498 Cross-domain move of non-empty account groups is not allowed.'
		Case 8499
			$ExitValue = '8499 Cross-domain move of non-empty resource groups is not allowed.'
		Case 8500
			$ExitValue = '8500 The search flags for the attribute are invalid. The ANR bit is valid only on attributes of Unicode or Teletex strings.'
		Case 8501
			$ExitValue = '8501 Tree deletions starting at an object which has an NC head as a descendant are not allowed.'
		Case 8502
			$ExitValue = '8502 The directory service failed to lock a tree in preparation for a tree deletion because the tree was in use.'
		Case 8503
			$ExitValue = '8503 The directory service failed to identify the list of objects to delete while attempting a tree deletion.'
		Case 8504
			$ExitValue = '8504 Security Accounts Manager initialization failed because of the following error: %1.'
		Case 8505
			$ExitValue = '8505 Only an administrator can modify the membership list of an administrative group.'
		Case 8506
			$ExitValue = '8506 Cannot change the primary group ID of a domain controller account.'
		Case 8507
			$ExitValue = '8507 An attempt is made to modify the base schema.'
		Case 8508
			$ExitValue = '8508 Adding a new mandatory attribute to an existing class, deleting a mandatory attribute from an existing class, or adding an optional attribute to the special class Top that is not a backlink attribute (directly or through inheritance, for example, by adding or deleting an auxiliary class) is not allowed.'
		Case 8509
			$ExitValue = '8509 Schema update is not allowed on this DC because the DC is not the schema FSMO Role Owner.'
		Case 8510
			$ExitValue = '8510 An object of this class cannot be created under the schema container. You can only create attribute-schema and class-schema objects under the schema container.'
		Case 8511
			$ExitValue = '8511 The replica/child install failed to get the objectVersion attribute on the schema container on the source DC. Either the attribute is missing on the schema container or the credentials supplied do not have permission to read it.'
		Case 8512
			$ExitValue = '8512 The replica/child install failed to read the objectVersion attribute in the SCHEMA section of the file schema.ini in the system32 directory.'
		Case 8513
			$ExitValue = '8513 The specified group type is invalid.'
		Case 8514
			$ExitValue = '8514 Cannot nest global groups in a mixed domain if the group is security-enabled.'
		Case 8515
			$ExitValue = '8515 Cannot nest local groups in a mixed domain if the group is security-enabled.'
		Case 8516
			$ExitValue = '8516 A global group cannot have a local group as a member.'
		Case 8517
			$ExitValue = '8517 A global group cannot have a universal group as a member.'
		Case 8518
			$ExitValue = '8518 A universal group cannot have a local group as a member.'
		Case 8519
			$ExitValue = '8519 A global group cannot have a cross-domain member.'
		Case 8520
			$ExitValue = '8520 A local group cannot have another cross-domain local group as a member.'
		Case 8521
			$ExitValue = '8521 A group with primary members cannot change to a security-disabled group.'
		Case 8522
			$ExitValue = '8522 The schema cache load failed to convert the string default SD on a class-schema object.'
		Case 8523
			$ExitValue = '8523 Only DSAs configured to be Global Catalog servers should be allowed to hold the Domain Naming Master FSMO role. (Applies only to Windows 2000 servers)"' 
		Case 8524
			$ExitValue = '8524 The DSA operation is unable to proceed because of a DNS lookup failure.'
		Case 8525
			$ExitValue = '8525 While processing a change to the DNS Host Name for an object, the Service Principal Name values could not be kept in sync.'
		Case 8526
			$ExitValue = '8526 The Security Descriptor attribute could not be read.'
		Case 8527
			$ExitValue = '8527 The object requested was not found, but an object with that key was found.'
		Case 8528
			$ExitValue = '8528 The syntax of the linked attributed being added is incorrect. Forward links can only have syntax 2.5.5.1, 2.5.5.7, and 2.5.5.14, and backlinks can only have syntax 2.5.5.1.'
		Case 8529
			$ExitValue = '8529 Security Account Manager needs to get the boot password.'
		Case 8530
			$ExitValue = '8530 Security Account Manager needs to get the boot key from floppy disk.'
		Case 8531
			$ExitValue = '8531 Directory Service cannot start.'
		Case 8532
			$ExitValue = '8532 Directory Services could not start.'
		Case 8533
			$ExitValue = '8533 The connection between client and server requires packet privacy or better.'
		Case 8534
			$ExitValue = '8534 The source domain may not be in the same forest as destination.'
		Case 8535
			$ExitValue = '8535 The destination domain must be in the forest.'
		Case 8536
			$ExitValue = '8536 The operation requires that destination domain auditing be enabled.'
		Case 8537
			$ExitValue = '8537 The operation could not locate a DC For the source domain.'
		Case 8538
			$ExitValue = '8538 The source object must be a group or user.'
		Case 8539
			$ExitValue = '8539 The source objects SID already exists In destination forest.'
		Case 8540
			$ExitValue = '8540 The source and destination object must be of the same type.'
		Case 8541
			$ExitValue = '8541 Security Accounts Manager initialization failed because of the following error: %1.'
		Case 8542
			$ExitValue = '8542 Schema information could not be included in the replication request.'
		Case 8543
			$ExitValue = '8543 The replication operation could not be completed due to a schema incompatibility.'
		Case 8544
			$ExitValue = '8544 The replication operation could not be completed due to a previous schema incompatibility.'
		Case 8545
			$ExitValue = '8545 The replication update could not be applied because either the source or the destination has not yet received information regarding a recent cross-domain move operation.'
		Case 8546
			$ExitValue = '8546 The requested domain could not be deleted because there exist domain controllers that still host this domain.'
		Case 8547
			$ExitValue = '8547 The requested operation can be performed only on a global catalog server.'
		Case 8548
			$ExitValue = '8548 A local group can only be a member of other local groups in the same domain.'
		Case 8549
			$ExitValue = '8549 Foreign security principals cannot be members of universal groups.'
		Case 8550
			$ExitValue = '8550 The attribute is not allowed to be replicated to the GC because of security reasons.'
		Case 8551
			$ExitValue = '8551 The checkpoint with the PDC could not be taken because there are too many modifications being processed currently.'
		Case 8552
			$ExitValue = '8552 The operation requires that source domain auditing be enabled.'
		Case 8553
			$ExitValue = '8553 Security principal objects can only be created inside domain naming contexts.'
		Case 8554
			$ExitValue = '8554 A Service Principal Name (SPN) could not be constructed because the provided hostname is not in the necessary format.'
		Case 8555
			$ExitValue = '8555 A Filter was passed that uses constructed attributes.'
		Case 8556
			$ExitValue = '8556 The unicodePwd attribute value must be enclosed in double quotes.'
		Case 8557
			$ExitValue = '8557 Your computer could not be joined to the domain. You have exceeded the maximum number of computer accounts you are allowed to create in this domain. Contact your system administrator to have this limit reset or increased.'
		Case 8558
			$ExitValue = '8558 For security reasons, the operation must be run on the destination DC.'
		Case 8559
			$ExitValue = '8559 For security reasons, the source DC must be NT4SP4 or greater.'
		Case 8560
			$ExitValue = '8560 Critical Directory Service System objects cannot be deleted during tree delete operations. The tree delete may have been partially performed.'
		Case 8561
			$ExitValue = '8561 Directory Services could not start because of the following error: %1.'
		Case 8562
			$ExitValue = '8562 Security Accounts Manager initialization failed because of the following error: %1.'
		Case 8563
			$ExitValue = '8563 This version of Windows is too old to support the current directory forest behavior. You must upgrade the operating system on this server before it can become a domain controller in this forest.'
		Case 8564
			$ExitValue = '8564 This version of Windows is too old to support the current domain behavior. You must upgrade the operating system on this server before it can become a domain controller in this domain.'
		Case 8565
			$ExitValue = '8565 This version of Windows no longer supports the behavior version in use in this directory forest. You must advance the forest behavior version before this server can become a domain controller in the forest.'
		Case 8566
			$ExitValue = '8566 This version of Windows no longer supports the behavior version in use in this domain. You must advance the domain behavior version before this server can become a domain controller in the domain.'
		Case 8567
			$ExitValue = '8567 The version of Windows is incompatible with the behavior version of the domain or forest.'
		Case 8568
			$ExitValue = '8568 The behavior version cannot be increased to the requested value because Domain Controllers still exist with versions lower than the requested value.'
		Case 8569
			$ExitValue = '8569 The behavior version value cannot be increased while the domain is still in mixed domain mode. You must first change the domain to native mode before increasing the behavior version.'
		Case 8570
			$ExitValue = '8570 The sort order requested is not supported.'
		Case 8571
			$ExitValue = '8571 Found an object with a non unique name.'
		Case 8572
			$ExitValue = '8572 The machine account was created pre-NT4. The account needs to be recreated.'
		Case 8573
			$ExitValue = '8573 The database is out of version store.'
		Case 8574
			$ExitValue = '8574 Unable to continue operation because multiple conflicting controls were used.'
		Case 8575
			$ExitValue = '8575 Unable to find a valid security descriptor reference domain for this partition.'
		Case 8576
			$ExitValue = '8576 Schema update failed: The link identifier is reserved.'
		Case 8577
			$ExitValue = '8577 Schema update failed: There are no link identifiers available.'
		Case 8578
			$ExitValue = '8578 An account group cannot have a universal group as a member.'
		Case 8579
			$ExitValue = '8579 Rename or move operations on naming context heads or read-only objects are not allowed.'
		Case 8580
			$ExitValue = '8580 Move operations on objects in the schema naming context are not allowed.'
		Case 8581
			$ExitValue = '8581 A system flag has been set on the object and does not allow the object to be moved or renamed.'
		Case 8582
			$ExitValue = '8582 This object is not allowed to change its grandparent container. Moves are not forbidden on this object, but are restricted to sibling containers.'
		Case 8583
			$ExitValue = '8583 Unable to resolve completely, a referral to another forest is generated.'
		Case 8584
			$ExitValue = '8584 The requested action is not supported on standard server.'
		Case 8585
			$ExitValue = '8585 Could not access a partition of the Active Directory located on a remote server. Make sure at least one server is running for the partition in question.'
		Case 8586
			$ExitValue = '8586 The directory cannot validate the proposed naming context (or partition) name because it does not hold a replica nor can it contact a replica of the naming context above the proposed naming context. Please ensure that the parent naming context is properly registered in DNS, and at least one replica of this naming context is reachable by the Domain Naming master.'
		Case 8587
			$ExitValue = '8587 The thread limit for this request was exceeded.'
		Case 8588
			$ExitValue = '8588 The Global catalog server is not in the closet site.'
		Case 8589
			$ExitValue = '8589 The DS cannot derive a service principal name (SPN) with which to mutually authenticate the target server because the corresponding server object in the local DS database has no serverReference attribute.'
		Case 8590
			$ExitValue = '8590 The Directory Service failed to enter single user mode.'
		Case 8591
			$ExitValue = '8591 The Directory Service cannot parse the script because of a syntax error.'
		Case 8592
			$ExitValue = '8592 The Directory Service cannot process the script because of an error.'
		Case 8593
			$ExitValue = '8593 The directory service cannot perform the requested operation because the servers involved are of different replication epochs (which is usually related to a domain rename that is in progress).'
		Case 8594
			$ExitValue = '8594 The directory service binding must be renegotiated due to a change in the server extensions information.'
		Case 8595
			$ExitValue = '8595 Operation not allowed on a disabled cross ref.'
		Case 8596
			$ExitValue = '8596 Schema update failed: No values for msDS-IntId are available.'
		Case 8597
			$ExitValue = '8597 Schema update failed: Duplicate msDS-INtId. Retry the operation.'
		Case 8598
			$ExitValue = '8598 Schema deletion failed: attribute is used in rDNAttID.'
		Case 8599
			$ExitValue = '8599 The directory service failed to authorize the request.'
		Case 8600
			$ExitValue = '8600 The Directory Service cannot process the script because it is invalid.'
		Case 8601
			$ExitValue = '8601 The remote create cross reference operation failed on the Domain Naming Master FSMO. The operations error is In the extended data.'
		Case 9001
			$ExitValue = '9001 DNS server unable to interpret format.'
		Case 9002
			$ExitValue = '9002 DNS server failure.'
		Case 9003
			$ExitValue = '9003 DNS name does not exist.'
		Case 9004
			$ExitValue = '9004 DNS request not supported by name server.'
		Case 9005
			$ExitValue = '9005 DNS operation refused.'
		Case 9006
			$ExitValue = '9006 DNS name that ought not exist, does exist.'
		Case 9007
			$ExitValue = '9007 DNS RR set that ought not exist, does exist.'
		Case 9008
			$ExitValue = '9008 DNS RR set that ought to exist, does not exist.'
		Case 9009
			$ExitValue = '9009 DNS server not authoritative for zone.'
		Case 9010
			$ExitValue = '9010 DNS name in update or prereq is not in zone.'
		Case 9016
			$ExitValue = '9016 DNS signature failed to verify.'
		Case 9017
			$ExitValue = '9017 DNS bad key.'
		Case 9018
			$ExitValue = '9018 DNS signature validity expired.'
		Case 9501
			$ExitValue = '9501 No records found for given DNS query.'
		Case 9502
			$ExitValue = '9502 Bad DNS packet.'
		Case 9503
			$ExitValue = '9503 No DNS packet.'
		Case 9504
			$ExitValue = '9504 DNS error, check rcode.'
		Case 9505
			$ExitValue = '9505 Unsecured DNS packet.'
		Case 9551
			$ExitValue = '9551 Invalid DNS type.'
		Case 9552
			$ExitValue = '9552 Invalid IP address.'
		Case 9553
			$ExitValue = '9553 Invalid property.'
		Case 9554
			$ExitValue = '9554 Try DNS operation again later.'
		Case 9555
			$ExitValue = '9555 Record for given name and type is not unique.'
		Case 9556
			$ExitValue = '9556 DNS name does not comply with RFC specifications.'
		Case 9557
			$ExitValue = '9557 DNS name is a fully-qualified DNS name.'
		Case 9558
			$ExitValue = '9558 DNS name is dotted (multi-label).'
		Case 9559
			$ExitValue = '9559 DNS name is a single-part name.'
		Case 9560
			$ExitValue = '9560 DSN name contains an invalid character.'
		Case 9561
			$ExitValue = '9561 DNS name is entirely numeric.'
		Case 9562
			$ExitValue = '9562 The operation requested is not permitted on a DNS root server.'
		Case 9601
			$ExitValue = '9601 DNS zone does not exist.'
		Case 9602
			$ExitValue = '9602 DNS zone information not available.'
		Case 9603
			$ExitValue = '9603 Invalid operation for DNS zone.'
		Case 9604
			$ExitValue = '9604 Invalid DNS zone configuration.'
		Case 9605
			$ExitValue = '9605 DNS zone has no start of authority (SOA) record.'
		Case 9606
			$ExitValue = '9606 DNS zone has no name server (NS) record.'
		Case 9607
			$ExitValue = '9607 DNS zone is locked.'
		Case 9608
			$ExitValue = '9608 DNS zone creation failed.'
		Case 9609
			$ExitValue = '9609 DNS zone already exists.'
		Case 9610
			$ExitValue = '9610 DNS automatic zone already exists.'
		Case 9611
			$ExitValue = '9611 Invalid DNS zone type.'
		Case 9612
			$ExitValue = '9612 Secondary DNS zone requires master IP address.'
		Case 9613
			$ExitValue = '9613 DNS zone not secondary.'
		Case 9614
			$ExitValue = '9614 Need secondary IP address.'
		Case 9615
			$ExitValue = '9615 WINS initialization failed.'
		Case 9616
			$ExitValue = '9616 Need WINS servers.'
		Case 9617
			$ExitValue = '9617 NBTSTAT initialization call failed.'
		Case 9618
			$ExitValue = '9618 Invalid delete of start of authority (SOA)"' 
		Case 9619
			$ExitValue = '9619 A conditional forwarding zone already exists for that name.'
		Case 9620
			$ExitValue = '9620 This zone must be configured with one or more master DNS server IP addresses.'
		Case 9621
			$ExitValue = '9621 The operation cannot be performed because this zone is shutdown.'
		Case 9651
			$ExitValue = '9651 Primary DNS zone requires datafile.'
		Case 9652
			$ExitValue = '9652 Invalid datafile name for DNS zone.'
		Case 9653
			$ExitValue = '9653 Failed to open datafile for DNS zone.'
		Case 9654
			$ExitValue = '9654 Failed to write datafile for DNS zone.'
		Case 9655
			$ExitValue = '9655 Failure while reading datafile for DNS zone.'
		Case 9701
			$ExitValue = '9701 DNS record does not exist.'
		Case 9702
			$ExitValue = '9702 DNS record format error.'
		Case 9703
			$ExitValue = '9703 Node creation failure in DNS.'
		Case 9704
			$ExitValue = '9704 Unknown DNS record type.'
		Case 9705
			$ExitValue = '9705 DNS record timed out.'
		Case 9706
			$ExitValue = '9706 Name not in DNS zone.'
		Case 9707
			$ExitValue = '9707 CNAME loop detected.'
		Case 9708
			$ExitValue = '9708 Node is a CNAME DNS record.'
		Case 9709
			$ExitValue = '9709 A CNAME record already exists for given name.'
		Case 9710
			$ExitValue = '9710 Record only at DNS zone root.'
		Case 9711
			$ExitValue = '9711 DNS record already exists.'
		Case 9712
			$ExitValue = '9712 Secondary DNS zone data error.'
		Case 9713
			$ExitValue = '9713 Could not create DNS cache data.'
		Case 9714
			$ExitValue = '9714 DNS name does not exist.'
		Case 9715
			$ExitValue = '9715 Could not create pointer (PTR) record.'
		Case 9716
			$ExitValue = '9716 DNS domain was undeleted.'
		Case 9717
			$ExitValue = '9717 The directory service is unavailable.'
		Case 9718
			$ExitValue = '9718 DNS zone already exists in the directory service.'
		Case 9719
			$ExitValue = '9719 DNS server not creating or reading the boot file for the directory service integrated DNS zone.'
		Case 9751
			$ExitValue = '9751 DNS AXFR (zone transfer) complete.'
		Case 9752
			$ExitValue = '9752 DNS zone transfer failed.'
		Case 9753
			$ExitValue = '9753 Added local WINS server.'
		Case 9801
			$ExitValue = '9801 Secure update call needs to continue update request.'
		Case 9851
			$ExitValue = '9851 TCP/IP network protocol not installed.'
		Case 9852
			$ExitValue = '9852 No DNS servers configured for local system.'
		Case 9901
			$ExitValue = '9901 The specified directory partition does not exist.'
		Case 9902
			$ExitValue = '9902 The specified directory partition already exists.'
		Case 9903
			$ExitValue = '9903 The DS is not enlisted in the specified directory partition.'
		Case 9904
			$ExitValue = '9904 The DS is already enlisted in the specified directory partition.'
		Case 10004
			$ExitValue = '10004 A blocking operation was interrupted by a call to WSACancelBlockingCall.'
		Case 10009
			$ExitValue = '10009 The file handle supplied is not valid.'
		Case 10013
			$ExitValue = '10013 An attempt was made to access a socket in a way forbidden by its access permissions.'
		Case 10014
			$ExitValue = '10014 The system detected an invalid pointer address in attempting to use a pointer argument in a call.'
		Case 10022
			$ExitValue = '10022 An invalid argument was supplied.'
		Case 10024
			$ExitValue = '10024 Too many open sockets.'
		Case 10035
			$ExitValue = '10035 A non-blocking socket operation could not be completed immediately.'
		Case 10036
			$ExitValue = '10036 A blocking operation is currently executing.'
		Case 10037
			$ExitValue = '10037 An operation was attempted on a non-blocking socket that already had an operation in progress.'
		Case 10038
			$ExitValue = '10038 An operation was attempted on something that is not a socket.'
		Case 10039
			$ExitValue = '10039 A required address was omitted from an operation on a socket.'
		Case 10040
			$ExitValue = '10040 A message sent on a datagram socket was larger than the internal message buffer or some other network limit, or the buffer used to receive a datagram into was smaller than the datagram itself.'
		Case 10041
			$ExitValue = '10041 A protocol was specified in the socket function call that does not support the semantics of the socket type requested.'
		Case 10042
			$ExitValue = '10042 An unknown, invalid, or unsupported option or level was specified in a getsockopt or setsockopt call.'
		Case 10043
			$ExitValue = '10043 The requested protocol has not been configured into the system, or no implementation for it exists.'
		Case 10044
			$ExitValue = '10044 The support for the specified socket type does not exist in this address family.'
		Case 10045
			$ExitValue = '10045 The attempted operation is not supported for the type of object referenced.'
		Case 10046
			$ExitValue = '10046 The protocol family has not been configured into the system or no implementation for it exists.'
		Case 10047
			$ExitValue = '10047 An address incompatible with the requested protocol was used.'
		Case 10048
			$ExitValue = '10048 Only one usage of each socket address (protocol/network address/port) is normally permitted.'
		Case 10049
			$ExitValue = '10049 The requested address is not valid in its context.'
		Case 10050
			$ExitValue = '10050 A socket operation encountered a dead network.'
		Case 10051
			$ExitValue = '10051 A socket operation was attempted to an unreachable network.'
		Case 10052
			$ExitValue = '10052 The connection has been broken due to keep-alive activity detecting a failure while the operation was in progress.'
		Case 10053
			$ExitValue = '10053 An established connection was aborted by the software in your host machine.'
		Case 10054
			$ExitValue = '10054 An existing connection was forcibly closed by the remote host.'
		Case 10055
			$ExitValue = '10055 An operation on a socket could not be performed because the system lacked sufficient buffer space or because a queue was full.'
		Case 10056
			$ExitValue = '10056 A connect request was made on an already connected socket.'
		Case 10057
			$ExitValue = '10057 A request to send or receive data was disallowed because the socket is not connected and (when sending on a datagram socket using a sendto call) no address was supplied.'
		Case 10058
			$ExitValue = '10058 A request to send or receive data was disallowed because the socket had already been shut down in that direction with a previous shutdown call.'
		Case 10059
			$ExitValue = '10059 Too many references to some kernel object.'
		Case 10060
			$ExitValue = '10060 A connection attempt failed because the connected party did not properly respond after a period of time, or established connection failed because connected host has failed to respond.'
		Case 10061
			$ExitValue = '10061 No connection could be made because the target machine actively refused it.'
		Case 10062
			$ExitValue = '10062 Cannot translate name.'
		Case 10063
			$ExitValue = '10063 Name component or name was too long.'
		Case 10064
			$ExitValue = '10064 A socket operation failed because the destination host was down.'
		Case 10065
			$ExitValue = '10065 A socket operation was attempted to an unreachable host.'
		Case 10066
			$ExitValue = '10066 Cannot remove a directory that is not empty.'
		Case 10067
			$ExitValue = '10067 A Windows Sockets implementation may have a limit on the number of applications that may use it simultaneously.'
		Case 10068
			$ExitValue = '10068 Ran out of quota.'
		Case 10069
			$ExitValue = '10069 Ran out of disk quota.'
		Case 10070
			$ExitValue = '10070 File handle reference is no longer available.'
		Case 10071
			$ExitValue = '10071 Item is not available locally.'
		Case 10091
			$ExitValue = '10091 WSAStartup cannot function at this time because the underlying system it uses to provide network services is currently unavailable.'
		Case 10092
			$ExitValue = '10092 The Windows Sockets version requested is not supported.'
		Case 10093
			$ExitValue = '10093 Either the application has not called WSAStartup, or WSAStartup failed.'
		Case 10101
			$ExitValue = '10101 Returned by WSARecv or WSARecvFrom to indicate the remote party has initiated a graceful shutdown sequence.'
		Case 10102
			$ExitValue = '10102 No more results can be returned by WSALookupServiceNext.'
		Case 10103
			$ExitValue = '10103 A call to WSALookupServiceEnd was made while this call was still processing. The call has been canceled.'
		Case 10104
			$ExitValue = '10104 The procedure call table is invalid.'
		Case 10105
			$ExitValue = '10105 The requested service provider is invalid.'
		Case 10106
			$ExitValue = '10106 The requested service provider could not be loaded or initialized.'
		Case 10107
			$ExitValue = '10107 A system call that should never fail has failed.'
		Case 10108
			$ExitValue = '10108 No such service is known. The service cannot be found in the specified name space.'
		Case 10109
			$ExitValue = '10109 The specified class was not found.'
		Case 10110
			$ExitValue = '10110 No more results can be returned by WSALookupServiceNext.'
		Case 10111
			$ExitValue = '10111 A call to WSALookupServiceEnd was made while this call was still processing. The call has been canceled.'
		Case 10112
			$ExitValue = '10112 A database query failed because it was actively refused.'
		Case 11001
			$ExitValue = '11001 No such host is known.'
		Case 11002
			$ExitValue = '11002 This is usually a temporary error during hostname resolution and means that the local server did not receive a response from an authoritative server.'
		Case 11003
			$ExitValue = '11003 A non-recoverable error occurred during a database lookup.'
		Case 11004
			$ExitValue = '11004 The requested name is valid and was found in the database, but it does not have the correct associated data being resolved for.'
		Case 11005
			$ExitValue = '11005 At least one reserve has arrived.'
		Case 11006
			$ExitValue = '11006 At least one path has arrived.'
		Case 11007
			$ExitValue = '11007 There are no senders.'
		Case 11008
			$ExitValue = '11008 There are no receivers.'
		Case 11009
			$ExitValue = '11009 Reserve has been confirmed.'
		Case 11010
			$ExitValue = '11010 Error due to lack of resources.'
		Case 11011
			$ExitValue = '11011 Rejected for administrative reasons - bad credentials.'
		Case 11012
			$ExitValue = '11012 Unknown or conflicting style.'
		Case 11013
			$ExitValue = '11013 Problem with some part of the filterspec or providerspecific buffer in general.'
		Case 11014
			$ExitValue = '11014 Problem with some part of the flowspec.'
		Case 11015
			$ExitValue = '11015 General QOS error.'
		Case 11016
			$ExitValue = '11016 An invalid or unrecognized service type was found in the flowspec.'
		Case 11017
			$ExitValue = '11017 An invalid or inconsistent flowspec was found in the QOS structure.'
		Case 11018
			$ExitValue = '11018 Invalid QOS provider-specific buffer.'
		Case 11019
			$ExitValue = '11019 An invalid QOS filter style was used.'
		Case 11020
			$ExitValue = '11020 An invalid QOS filter type was used.'
		Case 11021
			$ExitValue = '11021 An incorrect number of QOS FILTERSPECs were specified in the FLOWDESCRIPTOR.'
		Case 11022
			$ExitValue = '11022 An object with an invalid ObjectLength field was specified in the QOS provider-specific buffer.'
		Case 11023
			$ExitValue = '11023 An incorrect number of flow descriptors was specified in the QOS structure.'
		Case 11024
			$ExitValue = '11024 An unrecognized object was found in the QOS provider-specific buffer.'
		Case 11025
			$ExitValue = '11025 An invalid policy object was found in the QOS provider-specific buffer.'
		Case 11026
			$ExitValue = '11026 An invalid QOS flow descriptor was found in the flow descriptor list.'
		Case 11027
			$ExitValue = '11027 An invalid or inconsistent flowspec was found in the QOS provider-specific buffer.'
		Case 11028
			$ExitValue = '11028 An invalid FILTERSPEC was found in the QOS provider-specific buffer.'
		Case 11029
			$ExitValue = '11029 An invalid shape discard mode object was found in the QOS provider-specific buffer.'
		Case 11030
			$ExitValue = '11030 An invalid shaping rate object was found in the QOS provider-specific buffer.'
		Case 11031
			$ExitValue = '11031 A reserved policy element was found in the QOS provider-specific buffer.'
		Case 13000
			$ExitValue = '13000 The specified quick mode policy already exists.'
		Case 13001
			$ExitValue = '13001 The specified quick mode policy was not found.'
		Case 13002
			$ExitValue = '13002 The specified quick mode policy is being used.'
		Case 13003
			$ExitValue = '13003 The specified main mode policy already exists.'
		Case 13004
			$ExitValue = '13004 The specified main mode policy was not found.'
		Case 13005
			$ExitValue = '13005 The specified main mode policy is being used.'
		Case 13006
			$ExitValue = '13006 The specified main mode filter already exists.'
		Case 13007
			$ExitValue = '13007 The specified main mode filter was not found.'
		Case 13008
			$ExitValue = '13008 The specified transport mode filter already exists.'
		Case 13009
			$ExitValue = '13009 The specified transport mode filter does not exist.'
		Case 13010
			$ExitValue = '13010 The specified main mode authentication list exists.'
		Case 13011
			$ExitValue = '13011 The specified main mode authentication list was not found.'
		Case 13012
			$ExitValue = '13012 The specified quick mode policy is being used.'
		Case 13013
			$ExitValue = '13013 The specified main mode policy was not found.'
		Case 13014
			$ExitValue = '13014 The specified quick mode policy was not found.'
		Case 13015
			$ExitValue = '13015 The manifest file contains one or more syntax errors.'
		Case 13016
			$ExitValue = '13016 The application attempted to activate a disabled activation context.'
		Case 13017
			$ExitValue = '13017 The requested lookup key was not found in any active activation context.'
		Case 13018
			$ExitValue = '13018 The Main Mode filter is pending deletion.'
		Case 13019
			$ExitValue = '13019 The transport filter is pending deletion.'
		Case 13020
			$ExitValue = '13020 The tunnel filter is pending deletion.'
		Case 13021
			$ExitValue = '13021 The Main Mode policy is pending deletion.'
		Case 13022
			$ExitValue = '13022 The Main Mode authentication bundle is pending deletion.'
		Case 13023
			$ExitValue = '13023 The Quick Mode policy is pending deletion.'
		Case 13801
			$ExitValue = '13801 IKE authentication credentials are unacceptable.'
		Case 13802
			$ExitValue = '13802 IKE security attributes are unacceptable.'
		Case 13803
			$ExitValue = '13803 IKE Negotiation in progress.'
		Case 13804
			$ExitValue = '13804 General processing error.'
		Case 13805
			$ExitValue = '13805 Negotiation timed out.'
		Case 13806
			$ExitValue = '13806 IKE failed to find valid machine certificate.'
		Case 13807
			$ExitValue = '13807 IKE SA deleted by peer before establishment completed.'
		Case 13808
			$ExitValue = '13808 IKE SA deleted before establishment completed.'
		Case 13809
			$ExitValue = '13809 Negotiation request sat in Queue too long.'
		Case 13810
			$ExitValue = '13810 Negotiation request sat in Queue too long.'
		Case 13811
			$ExitValue = '13811 Negotiation request sat in Queue too long.'
		Case 13812
			$ExitValue = '13812 Negotiation request sat in Queue too long.'
		Case 13813
			$ExitValue = '13813 No response from peer.'
		Case 13814
			$ExitValue = '13814 Negotiation took too long.'
		Case 13815
			$ExitValue = '13815 Negotiation took too long.'
		Case 13816
			$ExitValue = '13816 Unknown error occurred.'
		Case 13817
			$ExitValue = '13817 Certificate Revocation Check failed.'
		Case 13818
			$ExitValue = '13818 Invalid certificate key usage.'
		Case 13819
			$ExitValue = '13819 Invalid certificate type.'
		Case 13820
			$ExitValue = '13820 No private key associated with machine certificate.'
		Case 13822
			$ExitValue = '13822 Failure in Diffie-Helman computation.'
		Case 13824
			$ExitValue = '13824 Invalid header.'
		Case 13825
			$ExitValue = '13825 No policy configured.'
		Case 13826
			$ExitValue = '13826 Failed to verify signature.'
		Case 13827
			$ExitValue = '13827 Failed to authenticate using Kerberos.'
		Case 13828
			$ExitValue = '13828 Peers certificate did Not have a public key.'
		Case 13829
			$ExitValue = '13829 Error processing error payload.'
		Case 13830
			$ExitValue = '13830 Error processing SA payload.'
		Case 13831
			$ExitValue = '13831 Error processing Proposal payload.'
		Case 13832
			$ExitValue = '13832 Error processing Transform payload.'
		Case 13833
			$ExitValue = '13833 Error processing KE payload.'
		Case 13834
			$ExitValue = '13834 Error processing ID payload.'
		Case 13835
			$ExitValue = '13835 Error processing Cert payload.'
		Case 13836
			$ExitValue = '13836 Error processing Certificate Request payload.'
		Case 13837
			$ExitValue = '13837 Error processing Hash payload.'
		Case 13838
			$ExitValue = '13838 Error processing Signature payload.'
		Case 13839
			$ExitValue = '13839 Error processing Nonce payload.'
		Case 13840
			$ExitValue = '13840 Error processing Notify payload.'
		Case 13841
			$ExitValue = '13841 Error processing Delete Payload.'
		Case 13842
			$ExitValue = '13842 Error processing VendorId payload.'
		Case 13843
			$ExitValue = '13843 Invalid payload received.'
		Case 13844
			$ExitValue = '13844 Soft SA loaded.'
		Case 13845
			$ExitValue = '13845 Soft SA torn down.'
		Case 13846
			$ExitValue = '13846 Invalid cookie received..'
		Case 13847
			$ExitValue = '13847 Peer failed to send valid machine certificate.'
		Case 13848
			$ExitValue = '13848 Certification Revocation check of peers certificate failed.'
		Case 13849
			$ExitValue = '13849 New policy invalidated SAs formed with old policy.'
		Case 13850
			$ExitValue = '13850 There is no available Main Mode IKE policy.'
		Case 13851
			$ExitValue = '13851 Failed to enabled TCB privilege.'
		Case 13852
			$ExitValue = '13852 Failed to load SECURITY.DLL.'
		Case 13853
			$ExitValue = '13853 Failed to obtain security function table dispatch address from SSPI.'
		Case 13854
			$ExitValue = '13854 Failed to query Kerberos package to obtain max token size.'
		Case 13855
			$ExitValue = '13855 Failed to obtain Kerberos server credentials for ISAKMP/ERROR_IPSEC_IKE service. Kerberos authentication will not function. The most likely reason for this is lack of domain membership. This is normal if your computer is a member of a workgroup.'
		Case 13856
			$ExitValue = '13856 Failed to determine SSPI principal name for ISAKMP/ERROR_IPSEC_IKE service (QueryCredentialsAttributes).'
		Case 13857
			$ExitValue = '13857 Failed to obtain new SPI for the inbound SA from Ipsec driver. The most common cause for this is that the driver does not have the correct filter. Check your policy to verify the filters.'
		Case 13858
			$ExitValue = '13858 Given filter is invalid.'
		Case 13859
			$ExitValue = '13859 Memory allocation failed.'
		Case 13860
			$ExitValue = '13860 Failed to add Security Association to IPSec Driver. The most common cause for this is if the IKE negotiation took too long to complete. If the problem persists, reduce the load on the faulting machine.'
		Case 13861
			$ExitValue = '13861 Invalid policy.'
		Case 13862
			$ExitValue = '13862 Invalid DOI.'
		Case 13863
			$ExitValue = '13863 Invalid situation.'
		Case 13864
			$ExitValue = '13864 Diffie-Hellman failure.'
		Case 13865
			$ExitValue = '13865 Invalid Diffie-Hellman group.'
		Case 13866
			$ExitValue = '13866 Error encrypting payload.'
		Case 13867
			$ExitValue = '13867 Error decrypting payload.'
		Case 13868
			$ExitValue = '13868 Policy match error.'
		Case 13869
			$ExitValue = '13869 Unsupported ID.'
		Case 13870
			$ExitValue = '13870 Hash verification failed.'
		Case 13871
			$ExitValue = '13871 Invalid hash algorithm.'
		Case 13872
			$ExitValue = '13872 Invalid hash size.'
		Case 13873
			$ExitValue = '13873 Invalid encryption algorithm.'
		Case 13874
			$ExitValue = '13874 Invalid authentication algorithm.'
		Case 13875
			$ExitValue = '13875 Invalid certificate signature.'
		Case 13876
			$ExitValue = '13876 Load failed.'
		Case 13877
			$ExitValue = '13877 Deleted via RPC call.'
		Case 13878
			$ExitValue = '13878 Temporary state created to perform reinit. This is not a real failure.'
		Case 13879
			$ExitValue = '13879 The lifetime value received in the Responder Lifetime Notify is below the Windows 2000 configured minimum value. Please fix the policy on the peer machine.'
		Case 13881
			$ExitValue = '13881 Key length in certificate is too small for configured security requirements.'
		Case 13882
			$ExitValue = '13882 Max number of established MM SAs to peer exceeded.'
		Case 13883
			$ExitValue = '13883 IKE received a policy that disables negotiation.'
		Case 13884
			$ExitValue = '13884 ERROR_IPSEC_IKE_NEG_STATUS_END"' 
		Case 14000
			$ExitValue = '14000 The requested section was not present in the activation context.'
		Case 14001
			$ExitValue = '14001 This application has failed to start because the application configuration is incorrect. Reinstalling the application may fix this problem.'
		Case 14002
			$ExitValue = '14002 The application binding data format is invalid.'
		Case 14003
			$ExitValue = '14003 The referenced assembly is not installed on your system.'
		Case 14004
			$ExitValue = '14004 The manifest file does not begin with the required tag and format information.'
		Case 14005
			$ExitValue = '14005 The manifest file contains one or more syntax errors.'
		Case 14006
			$ExitValue = '14006 The application attempted to activate a disabled activation context.'
		Case 14007
			$ExitValue = '14007 The requested lookup key was not found in any active activation context.'
		Case 14008
			$ExitValue = '14008 A component version required by the application conflicts with another component version already active.'
		Case 14009
			$ExitValue = '14009 The type requested activation context section does not match the query API used.'
		Case 14010
			$ExitValue = '14010 Lack of system resources has required isolated activation to be disabled for the current thread of execution.'
		Case 14011
			$ExitValue = '14011 An attempt to set the process default activation context failed because the process default activation context was already set.'
		Case 14012
			$ExitValue = '14012 The encoding group identifier specified is not recognized.'
		Case 14013
			$ExitValue = '14013 The encoding requested is not recognized.'
		Case 14014
			$ExitValue = '14014 The manifest contains a reference to an invalid URI.'
		Case 14015
			$ExitValue = '14015 The application manifest contains a reference to a dependent assembly which is not installed.'
		Case 14016
			$ExitValue = '14016 The manifest for an assembly used by the application has a reference to a dependent assembly which is not installed.'
		Case 14017
			$ExitValue = '14017 The manifest contains an attribute for the assembly identity which is not valid.'
		Case 14018
			$ExitValue = '14018 The manifest is missing the required default namespace specification on the assembly element.'
		Case 14019
			$ExitValue = '14019 The manifest has a default namespace specified on the assembly element but its value is not "urn:schemas-microsoft-com:asm.v1".'
		Case 14020
			$ExitValue = '14020 The private manifest probe has crossed the reparse-point-associated path.'
		Case 14021
			$ExitValue = '14021 Two or more components referenced directly or indirectly by the application manifest have files by the same name.'
		Case 14022
			$ExitValue = '14022 Two or more components referenced directly or indirectly by the application manifest have window classes with the same name.'
		Case 14023
			$ExitValue = '14023 Two or more components referenced directly or indirectly by the application manifest have the same COM server CLSIDs.'
		Case 14024
			$ExitValue = '14024 Two or more components referenced directly or indirectly by the application manifest have proxies for the same COM interface IIDs.'
		Case 14025
			$ExitValue = '14025 Two or more components referenced directly or indirectly by the application manifest have the same COM type library TLBIDs.'
		Case 14026
			$ExitValue = '14026 Two or more components referenced directly or indirectly by the application manifest have the same COM ProgIDs.'
		Case 14027
			$ExitValue = '14027 Two or more components referenced directly or indirectly by the application manifest are different versions of the same component which is not permitted.'
		Case 14028
			$ExitValue = '14028 A components file does Not match the verification information present In the component manifest.'
		Case 14029
			$ExitValue = '14029 The policy manifest contains one or more syntax errors.'
		Case 14030
			$ExitValue = '14030 Manifest Parse Error : A string literal was expected, but no opening quote character was found.'
		Case 14031
			$ExitValue = '14031 Manifest Parse Error : Incorrect syntax was used in a comment.'
		Case 14032
			$ExitValue = '14032 Manifest Parse Error : A name was started with an invalid character.'
		Case 14033
			$ExitValue = '14033 Manifest Parse Error : A name contained an invalid character.'
		Case 14034
			$ExitValue = '14034 Manifest Parse Error : A string literal contained an invalid character.'
		Case 14035
			$ExitValue = '14035 Manifest Parse Error : Invalid syntax for an XML declaration.'
		Case 14036
			$ExitValue = '14036 Manifest Parse Error : An invalid character was found in text content.'
		Case 14037
			$ExitValue = '14037 Manifest Parse Error : Required white space was missing.'
		Case 14038
			$ExitValue = '14038 Manifest Parse Error : The character ' > ' was expected.'
		Case 14039
			$ExitValue = '14039 Manifest Parse Error : A semi colon character was expected.'
		Case 14040
			$ExitValue = '14040 Manifest Parse Error : Unbalanced parentheses.'
		Case 14041
			$ExitValue = '14041 Manifest Parse Error : Internal error.'
		Case 14042
			$ExitValue = '14042 Manifest Parse Error : White space is not allowed at this location.'
		Case 14043
			$ExitValue = '14043 Manifest Parse Error : End of file reached in invalid state for current encoding.'
		Case 14044
			$ExitValue = '14044 Manifest Parse Error : Missing parenthesis.'
		Case 14045
			$ExitValue = '14045 Manifest Parse Error : A single or double closing quote character is missing."  ' 
		Case 14046
			$ExitValue = '14046 Manifest Parse Error : Multiple colons are not allowed in a name.'
		Case 14047
			$ExitValue = '14047 Manifest Parse Error : Invalid character for decimal digit.'
		Case 14048
			$ExitValue = '14048 Manifest Parse Error : Invalid character for hexadecimal digit.'
		Case 14049
			$ExitValue = '14049 Manifest Parse Error : Invalid Unicode character value for this platform.'
		Case 14050
			$ExitValue = '14050 Manifest Parse Error : Expecting white space or ?.'
		Case 14051
			$ExitValue = '14051 Manifest Parse Error : End tag was not expected at this location.'
		Case 14052
			$ExitValue = '14052 Manifest Parse Error : The following tags were not closed: %1.'
		Case 14053
			$ExitValue = '14053 Manifest Parse Error : Duplicate attribute.'
		Case 14054
			$ExitValue = '14054 Manifest Parse Error : Only one top level element is allowed in an XML document.'
		Case 14055
			$ExitValue = '14055 Manifest Parse Error : Invalid at the top level of the document.'
		Case 14056
			$ExitValue = '14056 Manifest Parse Error : Invalid XML declaration.'
		Case 14057
			$ExitValue = '14057 Manifest Parse Error : XML document must have a top level element.'
		Case 14058
			$ExitValue = '14058 Manifest Parse Error : Unexpected end of file.'
		Case 14059
			$ExitValue = '14059 Manifest Parse Error : Parameter entities cannot be used inside markup declarations in an internal subset.'
		Case 14060
			$ExitValue = '14060 Manifest Parse Error : Element was not closed.'
		Case 14061
			$ExitValue = '14061 Manifest Parse Error : End element was missing the character ' > '.'
		Case 14062
			$ExitValue = '14062 Manifest Parse Error : A string literal was not closed.'
		Case 14063
			$ExitValue = '14063 Manifest Parse Error : A comment was not closed.'
		Case 14064
			$ExitValue = '14064 Manifest Parse Error : A declaration was not closed.'
		Case 14065
			$ExitValue = '14065 Manifest Parse Error : A CDATA section was not closed.'
		Case 14066
			$ExitValue = '14066 Manifest Parse Error : The namespace prefix is not allowed to start with the reserved string "xml".'
		Case 14067
			$ExitValue = '14067 Manifest Parse Error : System does not support the specified encoding.'
		Case 14068
			$ExitValue = '14068 Manifest Parse Error : Switch from current encoding to specified encoding not supported.'
		Case 14069
			$ExitValue = '14069 Manifest Parse Error : The name xml is reserved and must be lower case.'
		Case 14070
			$ExitValue = '14070 Manifest Parse Error : The standalone attribute must have the value yes or no.'
		Case 14071
			$ExitValue = '14071 Manifest Parse Error : The standalone attribute cannot be used in external entities.'
		Case 14072
			$ExitValue = '14072 Manifest Parse Error : Invalid version number.'
		Case 14073
			$ExitValue = '14073 Manifest Parse Error : Missing equals sign between attribute and attribute value.'
		Case 14074
			$ExitValue = '14074 Assembly Protection Error: Unable to recover the specified assembly.'
		Case 14075
			$ExitValue = '14075 Assembly Protection Error: The public key for an assembly was too short to be allowed.'
		Case 14076
			$ExitValue = '14076 Assembly Protection Error: The catalog for an assembly is not valid, or does not match the assemblys manifest.'
		Case 14077
			$ExitValue = '14077 An HRESULT could not be translated to a corresponding Win32 error code.'
		Case 14078
			$ExitValue = '14078 Assembly Protection Error: The catalog for an assembly is missing.'
		Case 14079
			$ExitValue = '14079 The supplied assembly identity is missing one or more attributes which must be present in this context.'
		Case 14080
			$ExitValue = '14080 The supplied assembly identity has one or more attribute names that contain characters not permitted in XML names.'
			
	EndSwitch
	Return $ExitValue
EndFunc   ;==>Getcode
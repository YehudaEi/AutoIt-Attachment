#include-once
;
;   File: MCI_ShowError.au3
;
; - Shows MCI Error Codes and Strings
; - Released: Nov-18-2010, by ripdad
; - Based on information obtained from MSDN
;
Global Const $MCIERR_BASE = 256
Global Const $MCIERR_INVALID_DEVICE_ID = 257
Global Const $MCIERR_UNRECOGNIZED_KEYWORD = 259
Global Const $MCIERR_UNRECOGNIZED_COMMAND = 261
Global Const $MCIERR_HARDWARE = 262
Global Const $MCIERR_INVALID_DEVICE_NAME = 263
Global Const $MCIERR_OUT_OF_MEMORY = 264
Global Const $MCIERR_DEVICE_OPEN = 265
Global Const $MCIERR_CANNOT_LOAD_DRIVER = 266
Global Const $MCIERR_MISSING_COMMAND_STRING = 267
Global Const $MCIERR_PARAM_OVERFLOW = 268
Global Const $MCIERR_MISSING_STRING_ARGUMENT = 269
Global Const $MCIERR_BAD_INTEGER = 270
Global Const $MCIERR_PARSER_INTERNAL = 271
Global Const $MCIERR_DRIVER_INTERNAL = 272
Global Const $MCIERR_MISSING_PARAMETER = 273
Global Const $MCIERR_UNSUPPORTED_FUNCTION = 274
Global Const $MCIERR_FILE_NOT_FOUND = 275
Global Const $MCIERR_DEVICE_NOT_READY = 276
Global Const $MCIERR_INTERNAL = 277
Global Const $MCIERR_DRIVER = 278
Global Const $MCIERR_CANNOT_USE_ALL = 279
Global Const $MCIERR_MULTIPLE = 280
Global Const $MCIERR_EXTENSION_NOT_FOUND = 281
Global Const $MCIERR_OUTOFRANGE = 282
Global Const $MCIERR_FLAGS_NOT_COMPATIBLE = 283
Global Const $MCIERR_FILE_NOT_SAVED = 286
Global Const $MCIERR_DEVICE_TYPE_REQUIRED = 287
Global Const $MCIERR_DEVICE_LOCKED = 288
Global Const $MCIERR_DUPLICATE_ALIAS = 289
Global Const $MCIERR_BAD_CONSTANT = 290
Global Const $MCIERR_MUST_USE_SHAREABLE = 291
Global Const $MCIERR_MISSING_DEVICE_NAME = 292
Global Const $MCIERR_BAD_TIME_FORMAT = 293
Global Const $MCIERR_NO_CLOSING_QUOTE = 294
Global Const $MCIERR_DUPLICATE_FLAGS = 295
Global Const $MCIERR_INVALID_FILE = 296
Global Const $MCIERR_NULL_PARAMETER_BLOCK = 297
Global Const $MCIERR_UNNAMED_RESOURCE = 298
Global Const $MCIERR_NEW_REQUIRES_ALIAS = 299
Global Const $MCIERR_NOTIFY_ON_AUTO_OPEN = 300
Global Const $MCIERR_NO_ELEMENT_ALLOWED = 301
Global Const $MCIERR_NONAPPLICABLE_FUNCTION = 302
Global Const $MCIERR_ILLEGAL_FOR_AUTO_OPEN = 303
Global Const $MCIERR_FILENAME_REQUIRED = 304
Global Const $MCIERR_EXTRA_CHARACTERS = 305
Global Const $MCIERR_DEVICE_NOT_INSTALLED = 306
Global Const $MCIERR_GET_CD = 307
Global Const $MCIERR_SET_CD = 308
Global Const $MCIERR_SET_DRIVE = 309
Global Const $MCIERR_DEVICE_LENGTH = 310
Global Const $MCIERR_DEVICE_ORD_LENGTH = 311
Global Const $MCIERR_NO_INTEGER = 312
Global Const $MCIERR_WAVE_OUTPUTSINUSE = 320
Global Const $MCIERR_WAVE_SETOUTPUTINUSE = 321
Global Const $MCIERR_WAVE_INPUTSINUSE = 322
Global Const $MCIERR_WAVE_SETINPUTINUSE = 323
Global Const $MCIERR_WAVE_OUTPUTUNSPECIFIED = 324
Global Const $MCIERR_WAVE_INPUTUNSPECIFIED = 325
Global Const $MCIERR_WAVE_OUTPUTSUNSUITABLE = 326
Global Const $MCIERR_WAVE_SETOUTPUTUNSUITABLE = 327
Global Const $MCIERR_WAVE_INPUTSUNSUITABLE = 328
Global Const $MCIERR_WAVE_SETINPUTUNSUITABLE = 329
Global Const $MCIERR_SEQ_DIV_INCOMPATIBLE = 336
Global Const $MCIERR_SEQ_PORT_INUSE = 337
Global Const $MCIERR_SEQ_PORT_NONEXISTENT = 338
Global Const $MCIERR_SEQ_PORT_MAPNODEVICE = 339
Global Const $MCIERR_SEQ_PORT_MISCERROR = 340
Global Const $MCIERR_SEQ_TIMER = 341
Global Const $MCIERR_SEQ_PORTUNSPECIFIED = 342
Global Const $MCIERR_SEQ_NOMIDIPRESENT = 343
Global Const $MCIERR_NO_WINDOW = 346
Global Const $MCIERR_CREATEWINDOW = 347
Global Const $MCIERR_FILE_READ = 348
Global Const $MCIERR_FILE_WRITE = 349
Global Const $MCIERR_AVI_OLDAVIFORMAT = 356
Global Const $MCIERR_AVI_NOTINTERLEAVED = 357
Global Const $MCIERR_AVI_NODISPDIB = 358
Global Const $MCIERR_AVI_CANTPLAYFULLSCREEN = 359
Global Const $MCIERR_AVI_TOOBIGFORVGA = 360
Global Const $MCIERR_AVI_NOCOMPRESSOR = 361
Global Const $MCIERR_AVI_DISPLAYERROR = 362
Global Const $MCIERR_AVI_AUDIOERROR = 363
Global Const $MCIERR_AVI_BADPALETTE = 364
Global Const $MCIERR_CUSTOM_DRIVER_BASE = 512
;
; #FUNCTION# ======================================================================================
; Name...........: mciShowError
; Description ...: Displays via MsgBox the MCI Error Number and Associated Error String
; Syntax.........: mciShowError($number)
;
;   Usage Example:
;
;   #include "MCI_ShowError.au3"
;
;   Local $errmsg = DllCall("winmm.dll", "dword", "mciSendStringW", etc, etc ... )
;   If @error Then Return -1
;   If $errmsg[0] <> 0 Then
;       mciShowError($errmsg[0])
;       Return -2
;   EndIf
;
; Parameters ....:
; Return values .: Success: Displays MCI Error Message
; Author ........: ripdad
; Modified.......:
; Remarks .......: For obtaining MCI error messages
; Related .......:
; Link ..........: MSDN
; Example .......: Yes
; =================================================================================================
Func mciShowError($errStr)
    Local $mciErrorMsg = ''
    Switch $errStr
        Case $MCIERR_INVALID_DEVICE_ID
            $mciErrorMsg = "MCIERR_INVALID_DEVICE_ID" & @CRLF & "Use the ID given to the device when the device was opened."
        Case $MCIERR_UNRECOGNIZED_KEYWORD
            $mciErrorMsg = "MCIERR_UNRECOGNIZED_KEYWORD" & @CRLF & "An unknown command parameter was specified."
        Case $MCIERR_UNRECOGNIZED_COMMAND
            $mciErrorMsg = "MCIERR_UNRECOGNIZED_COMMAND" & @CRLF & "The driver cannot recognize the specified command."
        Case $MCIERR_HARDWARE
            $mciErrorMsg = "MCIERR_HARDWARE" & @CRLF & "The specified device exhibits a problem. Check that the device is working correctly or contact the device manufacturer."
        Case $MCIERR_INVALID_DEVICE_NAME
            $mciErrorMsg = "MCIERR_INVALID_DEVICE_NAME" & @CRLF & "The specified device is not open nor recognized by MCI."
        Case $MCIERR_OUT_OF_MEMORY
            $mciErrorMsg = "MCIERR_OUT_OF_MEMORY" & @CRLF & "Your system does not have enough memory for this task. Quit one or more applications to increase the available memory, then, try to perform the task again."
        Case $MCIERR_DEVICE_OPEN
            $mciErrorMsg = "MCIERR_DEVICE_OPEN" & @CRLF & "The device name is already used as an alias by this application. Use a unique alias."
        Case $MCIERR_CANNOT_LOAD_DRIVER
            $mciErrorMsg = "MCIERR_CANNOT_LOAD_DRIVER" & @CRLF & "The specified device driver will not load properly."
        Case $MCIERR_MISSING_COMMAND_STRING
            $mciErrorMsg = "MCIERR_MISSING_COMMAND_STRING" & @CRLF & "No command was specified."
        Case $MCIERR_PARAM_OVERFLOW
            $mciErrorMsg = "MCIERR_PARAM_OVERFLOW" & @CRLF & "The output string was not long enough."
        Case $MCIERR_MISSING_STRING_ARGUMENT
            $mciErrorMsg = "MCIERR_MISSING_STRING_ARGUMENT" & @CRLF & "A string value was missing from the command."
        Case $MCIERR_BAD_INTEGER
            $mciErrorMsg = "MCIERR_BAD_INTEGER" & @CRLF & "An integer in the command was invalid or missing."
        Case $MCIERR_PARSER_INTERNAL
            $mciErrorMsg = "MCIERR_PARSER_INTERNAL" & @CRLF & "An internal parser error occurred."
        Case $MCIERR_DRIVER_INTERNAL
            $mciErrorMsg = "MCIERR_DRIVER_INTERNAL" & @CRLF & "The device driver exhibits a problem. Check with the device manufacturer about obtaining a new driver."
        Case $MCIERR_MISSING_PARAMETER
            $mciErrorMsg = "MCIERR_MISSING_PARAMETER" & @CRLF & "The specified command requires a parameter, which you must supply."
        Case $MCIERR_UNSUPPORTED_FUNCTION
            $mciErrorMsg = "MCIERR_UNSUPPORTED_FUNCTION" & @CRLF & "The MCI device driver the system is using does not support the specified command."
        Case $MCIERR_FILE_NOT_FOUND
            $mciErrorMsg = "MCIERR_FILE_NOT_FOUND" & @CRLF & "The requested file was not found. Check that the path and filename are correct."
        Case $MCIERR_DEVICE_NOT_READY
            $mciErrorMsg = "MCIERR_DEVICE_NOT_READY" & @CRLF & "The device driver is not ready."
        Case $MCIERR_INTERNAL
            $mciErrorMsg = "MCIERR_INTERNAL" & @CRLF & "A problem occurred in initializing MCI. Try restarting the Windows operating system."
        Case $MCIERR_DRIVER
            $mciErrorMsg = "MCIERR_DRIVER" & @CRLF & "The device driver exhibits a problem. Check with the device manufacturer about obtaining a new driver."
        Case $MCIERR_CANNOT_USE_ALL
            $mciErrorMsg = "MCIERR_CANNOT_USE_ALL" & @CRLF & "The device name" & ' "all" ' & "is not allowed for this command."
        Case $MCIERR_MULTIPLE
            $mciErrorMsg = "MCIERR_MULTIPLE" & @CRLF & "Errors occurred in more than one device. Specify each command and device separately to identify the devices causing the errors."
        Case $MCIERR_EXTENSION_NOT_FOUND
            $mciErrorMsg = "MCIERR_EXTENSION_NOT_FOUND" & @CRLF & "The specified extension has no device type associated with it. Specify a device type."
        Case $MCIERR_OUTOFRANGE
            $mciErrorMsg = "MCIERR_OUTOFRANGE" & @CRLF & "The specified parameter value is out of range for the specified MCI command."
        Case $MCIERR_FLAGS_NOT_COMPATIBLE
            $mciErrorMsg = "MCIERR_FLAGS_NOT_COMPATIBLE" & @CRLF & "The specified parameters cannot be used together."
        Case $MCIERR_FILE_NOT_SAVED
            $mciErrorMsg = "MCIERR_FILE_NOT_SAVED" & @CRLF & "The file was not saved. Make sure your system has sufficient disk space or has an intact network connection."
        Case $MCIERR_DEVICE_TYPE_REQUIRED
            $mciErrorMsg = "MCIERR_DEVICE_TYPE_REQUIRED" & @CRLF & "The specified device cannot be found on the system. Check that the device is installed and the device name is spelled correctly."
        Case $MCIERR_DEVICE_LOCKED
            $mciErrorMsg = "MCIERR_DEVICE_LOCKED" & @CRLF & "The device is now being closed. Wait a few seconds, then try again."
        Case $MCIERR_DUPLICATE_ALIAS
            $mciErrorMsg = "MCIERR_DUPLICATE_ALIAS" & @CRLF & "The specified alias is already used in this application. Use a unique alias."
        Case $MCIERR_BAD_CONSTANT
            $mciErrorMsg = "MCIERR_BAD_CONSTANT" & @CRLF & "The value specified for a parameter is unknown."
        Case $MCIERR_MUST_USE_SHAREABLE
            $mciErrorMsg = "MCIERR_MUST_USE_SHAREABLE" & @CRLF & "The device driver is already in use. You must specify the" & ' "shareable" ' & "parameter with each open command to share the device."
        Case $MCIERR_MISSING_DEVICE_NAME
            $mciErrorMsg = "MCIERR_MISSING_DEVICE_NAME" & @CRLF & "No device name was specified."
        Case $MCIERR_BAD_TIME_FORMAT
            $mciErrorMsg = "MCIERR_BAD_TIME_FORMAT" & @CRLF & "The specified value for the time format is invalid."
        Case $MCIERR_NO_CLOSING_QUOTE
            $mciErrorMsg = "MCIERR_NO_CLOSING_QUOTE" & @CRLF & "A closing quotation mark is missing."
        Case $MCIERR_DUPLICATE_FLAGS
            $mciErrorMsg = "MCIERR_DUPLICATE_FLAGS" & @CRLF & "A flag or value was specified twice."
        Case $MCIERR_INVALID_FILE
            $mciErrorMsg = "MCIERR_INVALID_FILE" & @CRLF & "The specified file cannot be played on the specified MCI device. The file may be corrupt or may use an incorrect file format."
        Case $MCIERR_NULL_PARAMETER_BLOCK
            $mciErrorMsg = "MCIERR_NULL_PARAMETER_BLOCK" & @CRLF & "A null parameter block (structure) was passed to MCI."
        Case $MCIERR_UNNAMED_RESOURCE
            $mciErrorMsg = "MCIERR_UNNAMED_RESOURCE" & @CRLF & "You cannot store an unnamed file. Specify a filename."
        Case $MCIERR_NEW_REQUIRES_ALIAS
            $mciErrorMsg = "MCIERR_NEW_REQUIRES_ALIAS" & @CRLF & "An alias must be used with the" & ' "new" ' & "device name."
        Case $MCIERR_NOTIFY_ON_AUTO_OPEN
            $mciErrorMsg = "MCIERR_NOTIFY_ON_AUTO_OPEN" & @CRLF & "The" & ' "notify" ' & "flag is illegal with auto-open."
        Case $MCIERR_NO_ELEMENT_ALLOWED
            $mciErrorMsg = "MCIERR_NO_ELEMENT_ALLOWED" & @CRLF & "The specified device does not use a filename."
        Case $MCIERR_NONAPPLICABLE_FUNCTION
            $mciErrorMsg = "MCIERR_NONAPPLICABLE_FUNCTION" & @CRLF & "The specified MCI command sequence cannot be performed in the given order. Correct the command sequence; then, try again."
        Case $MCIERR_ILLEGAL_FOR_AUTO_OPEN
            $mciErrorMsg = "MCIERR_ILLEGAL_FOR_AUTO_OPEN" & @CRLF & "MCI will not perform the specified command on an automatically opened device. Wait until the device is closed, then try to perform the command."
        Case $MCIERR_FILENAME_REQUIRED
            $mciErrorMsg = "MCIERR_FILENAME_REQUIRED" & @CRLF & "The filename is invalid. Make sure the filename is no longer than eight characters, followed by a period and an extension."
        Case $MCIERR_EXTRA_CHARACTERS
            $mciErrorMsg = "MCIERR_EXTRA_CHARACTERS" & @CRLF & "You must enclose a string with quotation marks; characters following the closing quotation mark are not valid."
        Case $MCIERR_DEVICE_NOT_INSTALLED
            $mciErrorMsg = "MCIERR_DEVICE_NOT_INSTALLED" & @CRLF & "The specified device is not installed on the system. Use the Drivers option from the Control Panel to install the device."
        Case $MCIERR_GET_CD
            $mciErrorMsg = "MCIERR_GET_CD" & @CRLF & "The requested file OR MCI device was not found. Try changing directories or restarting your system."
        Case $MCIERR_SET_CD
            $mciErrorMsg = "MCIERR_SET_CD" & @CRLF & "The specified file or MCI device is inaccessible because the application cannot change directories."
        Case $MCIERR_SET_DRIVE
            $mciErrorMsg = "MCIERR_SET_DRIVE" & @CRLF & "The specified file or MCI device is inaccessible because the application cannot change drives."
        Case $MCIERR_DEVICE_LENGTH
            $mciErrorMsg = "MCIERR_DEVICE_LENGTH" & @CRLF & "The device or driver name is too long. Specify a device or driver name that is less than 79 characters."
        Case $MCIERR_DEVICE_ORD_LENGTH
            $mciErrorMsg = "MCIERR_DEVICE_ORD_LENGTH" & @CRLF & "The device or driver name is too long. Specify a device or driver name that is less than 79 characters."
        Case $MCIERR_NO_INTEGER
            $mciErrorMsg = "MCIERR_NO_INTEGER" & @CRLF & "The parameter for this MCI command must be an integer value."
        Case $MCIERR_WAVE_OUTPUTSINUSE
            $mciErrorMsg = "MCIERR_WAVE_OUTPUTSINUSE" & @CRLF & "All waveform devices that can play files in the current format are in use. Wait until one of these devices is free; then, try again."
        Case $MCIERR_WAVE_SETOUTPUTINUSE
            $mciErrorMsg = "MCIERR_WAVE_SETOUTPUTINUSE" & @CRLF & "The current waveform device is in use. Wait until the device is free; then, try again to set the device for playback."
        Case $MCIERR_WAVE_INPUTSINUSE
            $mciErrorMsg = "MCIERR_WAVE_INPUTSINUSE" & @CRLF & "All waveform devices that can record files in the current format are in use. Wait until one of these devices is free; then, try again."
        Case $MCIERR_WAVE_SETINPUTINUSE
            $mciErrorMsg = "MCIERR_WAVE_SETINPUTINUSE" & @CRLF & "The current waveform device is in use. Wait until the device is free; then, try again to set the device for recording."
        Case $MCIERR_WAVE_OUTPUTUNSPECIFIED
            $mciErrorMsg = "MCIERR_WAVE_OUTPUTUNSPECIFIED" & @CRLF & "You can specify any compatible waveform playback device."
        Case $MCIERR_WAVE_INPUTUNSPECIFIED
            $mciErrorMsg = "MCIERR_WAVE_INPUTUNSPECIFIED" & @CRLF & "You can specify any compatible waveform recording device."
        Case $MCIERR_WAVE_OUTPUTSUNSUITABLE
            $mciErrorMsg = "MCIERR_WAVE_OUTPUTSUNSUITABLE" & @CRLF & "No installed waveform device can play files in the current format. Use the Drivers option from the Control Panel to install a suitable waveform device."
        Case $MCIERR_WAVE_SETOUTPUTUNSUITABLE
            $mciErrorMsg = "MCIERR_WAVE_SETOUTPUTUNSUITABLE" & @CRLF & "The device you are using to playback a waveform cannot recognize the data format."
        Case $MCIERR_WAVE_INPUTSUNSUITABLE
            $mciErrorMsg = "MCIERR_WAVE_INPUTSUNSUITABLE" & @CRLF & "No installed waveform device can record files in the current format. Use the Drivers option from the Control Panel to install a suitable waveform recording device."
        Case $MCIERR_WAVE_SETINPUTUNSUITABLE
            $mciErrorMsg = "MCIERR_WAVE_SETINPUTUNSUITABLE" & @CRLF & "The device you are using to record a waveform cannot recognize the data format."
        Case $MCIERR_SEQ_DIV_INCOMPATIBLE
            $mciErrorMsg = "MCIERR_SEQ_DIV_INCOMPATIBLE" & @CRLF & "The time formats of the" & ' "song pointer" ' & "and SMPTE are singular. You can't use them together."
        Case $MCIERR_SEQ_PORT_INUSE
            $mciErrorMsg = "MCIERR_SEQ_PORT_INUSE" & @CRLF & "The specified MIDI port is already in use. Wait until it is free; then, try again."
        Case $MCIERR_SEQ_PORT_NONEXISTENT
            $mciErrorMsg = "MCIERR_SEQ_PORT_NONEXISTENT" & @CRLF & "The specified MIDI device is not installed on the system. Use the Drivers option from the Control Panel to install a MIDI device."
        Case $MCIERR_SEQ_PORT_MAPNODEVICE
            $mciErrorMsg = "MCIERR_SEQ_PORT_MAPNODEVICE" & @CRLF & "The current MIDI Mapper setup refers to a MIDI device that is not installed on the system. Use the MIDI Mapper from the Control Panel to edit the setup."
        Case $MCIERR_SEQ_PORT_MISCERROR
            $mciErrorMsg = "MCIERR_SEQ_PORT_MISCERROR" & @CRLF & "An error occurred with specified port."
        Case $MCIERR_SEQ_TIMER
            $mciErrorMsg = "MCIERR_SEQ_TIMER" & @CRLF & "All multimedia timers are being used by other applications. Quit one of these applications; then, try again."
        Case $MCIERR_SEQ_PORTUNSPECIFIED
            $mciErrorMsg = "MCIERR_SEQ_PORTUNSPECIFIED" & @CRLF & "The system does not have a current MIDI port specified."
        Case $MCIERR_SEQ_NOMIDIPRESENT
            $mciErrorMsg = "MCIERR_SEQ_NOMIDIPRESENT" & @CRLF & "This system has no installed MIDI devices. Use the Drivers option from the Control Panel to install a MIDI driver."
        Case $MCIERR_NO_WINDOW
            $mciErrorMsg = "MCIERR_NO_WINDOW" & @CRLF & "There is no display window."
        Case $MCIERR_CREATEWINDOW
            $mciErrorMsg = "MCIERR_CREATEWINDOW" & @CRLF & "Could not create or use window."
        Case $MCIERR_FILE_READ
            $mciErrorMsg = "MCIERR_FILE_READ" & @CRLF & "A read from the file failed. Make sure the file is present on your system or that your system has an intact network connection."
        Case $MCIERR_FILE_WRITE
            $mciErrorMsg = "MCIERR_FILE_WRITE" & @CRLF & "A write to the file failed. Make sure your system has sufficient disk space or has an intact network connection."
        Case $MCIERR_AVI_OLDAVIFORMAT
            $mciErrorMsg = "MCIERR_AVI_OLDAVIFORMAT" & @CRLF & "This AVI file is of an obsolete format."
        Case $MCIERR_AVI_NOTINTERLEAVED
            $mciErrorMsg = "MCIERR_AVI_NOTINTERLEAVED" & @CRLF & "This AVI file is not interleaved."
        Case $MCIERR_AVI_NODISPDIB
            $mciErrorMsg = "MCIERR_AVI_NODISPDIB" & @CRLF & "256 color VGA mode not available."
        Case $MCIERR_AVI_CANTPLAYFULLSCREEN
            $mciErrorMsg = "MCIERR_AVI_CANTPLAYFULLSCREEN" & @CRLF & "This AVI file cannot be played in full screen mode."
        Case $MCIERR_AVI_TOOBIGFORVGA
            $mciErrorMsg = "MCIERR_AVI_TOOBIGFORVGA" & @CRLF & "This AVI file is too big to be played in the selected VGA mode."
        Case $MCIERR_AVI_NOCOMPRESSOR
            $mciErrorMsg = "MCIERR_AVI_NOCOMPRESSOR" & @CRLF & "Can't locate installable compressor needed to play this file."
        Case $MCIERR_AVI_DISPLAYERROR
            $mciErrorMsg = "MCIERR_AVI_DISPLAYERROR" & @CRLF & "Unknown error while attempting to display video."
        Case $MCIERR_AVI_AUDIOERROR
            $mciErrorMsg = "MCIERR_AVI_AUDIOERROR" & @CRLF & "Unknown error while attempting to play audio."
        Case $MCIERR_AVI_BADPALETTE
            $mciErrorMsg = "MCIERR_AVI_BADPALETTE" & @CRLF & "Unable to switch to new palette."
        Case Else
            $mciErrorMsg = "Unknown Error"
    EndSwitch
    MsgBox(8208, "MCI Error: " & $errStr, $mciErrorMsg)
EndFunc
;

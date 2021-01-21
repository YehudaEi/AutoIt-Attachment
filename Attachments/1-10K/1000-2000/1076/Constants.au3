#include-once

; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.0
; Language:       English
; Author(s):      Jeremy Landes <jlandes@landeserve.com>
;                 David Nuttall <danuttall@rocketmail.com>
; Description:    This file is meant to be included in an AutoIt v3 script to
;                 provide access to these constants.
;
; ------------------------------------------------------------------------------


;==============================================
; AutoIt Options Constants
;==============================================
; Sets the way coords are used in the mouse and pixel functions
Global Const $OPT_COORDSRELATIVE   =    0 ; Relative coords to the active window
Global Const $OPT_COORDSABSOLUTE   =    1 ; Absolute screen coordinates (default)

; Sets how errors are handled if a Run/RunWait function fails
Global Const $OPT_ERRORSILENT      =    0 ; Silent error (@error set to 1)
Global Const $OPT_ERRORFATAL       =    1 ; Fatal error (default)

; Alters the use of Caps Lock 
Global Const $OPT_CAPSNOSTORE      =    0 ; Don't store/restore Caps Lock state
Global Const $OPT_CAPSSTORE        =    1 ; Store/restore Caps Lock state (default)

; Alters the method that is used to match window titles
Global Const $OPT_MATCHSTART       =    1 ; Match the title from the start (default)
Global Const $OPT_MATCHANY         =    2 ; Match any substring in the title
Global Const $OPT_MATCHEXACT       =    3 ; Match the title exactly


;==============================================
; File Constants
;==============================================
; Indicates file copy and install options
Global Const $FC_NOOVERWRITE       =    0 ; Do not overwrite existing files (default)
Global Const $FC_OVERWRITE         =    1 ; Overwrite existing files

; Indicates file date and time options
Global Const $FT_MODIFIED          =    0 ; Date and time file was last modified (default)
Global Const $FT_CREATED           =    1 ; Date and time file was created
Global Const $FT_ACCESSED          =    2 ; Date and time file was last accessed

; Indicates the mode to open a file
Global Const $FO_READ              =    0 ; Read mode
Global Const $FO_APPEND            =    1 ; Write mode (append)
Global Const $FO_OVERWRITE         =    2 ; Write mode (erase previous contents)

; Indicates file read options
Global Const $EOF                  =   -1 ; End-of-file reached

; Indicates file open and save dialog options
Global Const $FD_FILEMUSTEXIST     =    1 ; File must exist
Global Const $FD_PATHMUSTEXIST     =    2 ; Path must exist
Global Const $FD_MULTISELECT       =    4 ; Allow multi-select
Global Const $FD_PROMPTCREATENEW   =    8 ; Prompt to create new file
Global Const $FD_PROMPTOVERWRITE   =   16 ; Prompt to overWrite file


;==============================================
; Keyboard Constants
;==============================================
; Changes how keys are processed
Global Const $KB_SENDSPECIAL       =    0 ; Special characters indicate key presses (default)
Global Const $KB_SENDRAW           =    1 ; Keys are sent raw

; Sets the state of the Caps Lock key
Global Const $KB_CAPSOFF           =    0 ; Caps Lock is off
Global Const $KB_CAPSON            =    1 ; Caps Lock is on


;==============================================
; Message Box Constants
;==============================================
; Indicates the buttons displayed in the message box
Global Const $MB_OK                =    0 ; One push button: OK
Global Const $MB_OKCANCEL          =    1 ; Two push buttons: OK and Cancel
Global Const $MB_ABORTRETRYIGNORE  =    2 ; Three push buttons: Abort, Retry, and Ignore
Global Const $MB_YESNOCANCEL       =    3 ; Three push buttons: Yes, No, and Cancel
Global Const $MB_YESNO             =    4 ; Two push buttons: Yes and No
Global Const $MB_RETRYCANCEL       =    5 ; Two push buttons: Retry and Cancel
Global Const $MB_CANCELTRYCONTINUE =    6 ; Three push buttons: Cancel, Try Again, Continue

; Displays an icon in the message box
Global Const $MB_ICONHAND          =   16 ; Stop-sign icon
Global Const $MB_ICONQUESTION      =   32 ; Question-mark icon
Global Const $MB_ICONEXCLAMATION   =   48 ; Exclamation-point icon
Global Const $MB_ICONASTERISK      =   64 ; Icon consisting of an 'i' in a circle

; Indicates the default button
Global Const $MB_DEFBUTTON1        =    0 ; The first button is the default button
Global Const $MB_DEFBUTTON2        =  256 ; The second button is the default button
Global Const $MB_DEFBUTTON3        =  512 ; The third button is the default button

; Indicates the modality of the dialog box
Global Const $MB_APPLMODAL         =    0 ; Application modal
Global Const $MB_SYSTEMMODAL       = 4096 ; System modal
Global Const $MB_TASKMODAL         = 8192 ; Task modal

; Indicates the button selected in the message box
Global Const $IDOK                 =    1 ; OK button was selected
Global Const $IDCANCEL             =    2 ; Cancel button was selected
Global Const $IDABORT              =    3 ; Abort button was selected
Global Const $IDRETRY              =    4 ; Retry button was selected
Global Const $IDIGNORE             =    5 ; Ignore button was selected
Global Const $IDYES                =    6 ; Yes button was selected
Global Const $IDNO                 =    7 ; No button was selected
Global Const $IDTRYAGAIN           =   10 ; Try Again button was selected
Global Const $IDCONTINUE           =   11 ; Continue button was selected


;==============================================
; Progress and Splash Constants
;==============================================
; Indicates properties of the displayed progress or splash dialog
Global Const $DLG_NOTITLE          =    1 ; Titleless window
Global Const $DLG_NOTONTOP         =    2 ; Without "always on top" attribute
Global Const $DLG_TEXTLEFT         =    4 ; Left justified text
Global Const $DLG_TEXTRIGHT        =    8 ; Right justified text


;==============================================
; Tray Tip Constants
;==============================================
; Indicates the type of Ballon Tip to display
Global Const $TIP_ICONNONE         =    0 ; No icon (default)
Global Const $TIP_ICONASTERISK     =    1 ; Info icon
Global Const $TIP_ICONEXCLAMATION  =    2 ; Warning icon
Global Const $TIP_ICONHAND         =    3 ; Error icon
Global Const $TIP_NOSOUND          =   16 ; No sound


;==============================================
; Mouse Constants
;==============================================
; Indicates current mouse cursor
Global Const $IDC_UNKNOWN          =    0 ; Unknown cursor
Global Const $IDC_APPSTARTING      =    1 ; Standard arrow and small hourglass
Global Const $IDC_ARROW            =    2 ; Standard arrow
Global Const $IDC_CROSS            =    3 ; Crosshair
Global Const $IDC_HELP             =    4 ; Arrow and question mark
Global Const $IDC_IBEAM            =    5 ; I-beam
Global Const $IDC_ICON             =    6 ; Obsolete
Global Const $IDC_NO               =    7 ; Slashed circle
Global Const $IDC_SIZE             =    8 ; Obsolete
Global Const $IDC_SIZEALL          =    9 ; Four-pointed arrow pointing N, S, E, and W
Global Const $IDC_SIZENESW         =   10 ; Double-pointed arrow pointing NE and SW
Global Const $IDC_SIZENS           =   11 ; Double-pointed arrow pointing N and S
Global Const $IDC_SIZENWSE         =   12 ; Double-pointed arrow pointing NW and SE
Global Const $IDC_SIZEWE           =   13 ; Double-pointed arrow pointing W and E
Global Const $IDC_UPARROW          =   14 ; Vertical arrow
Global Const $IDC_WAIT             =   15 ; Hourglass


;==============================================
; Process Constants
;==============================================
; Indicates the type of shutdown
Global Const $SD_LOGOFF            =    0 ; Logoff
Global Const $SD_SHUTDOWN          =    1 ; Shutdown
Global Const $SD_REBOOT            =    2 ; Reboot
Global Const $SD_FORCE             =    4 ; Force
Global Const $SD_POWERDOWN         =    8 ; Power down


;==============================================
; String Constants
;==============================================
; Indicates if string operations should be case sensitive
Global Const $STR_NOCASESENSE      =    0 ; Not case sensitive (default)
Global Const $STR_CASESENSE        =    1 ; Case sensitive

; IndicateS the type of stripping that should be performed
Global Const $STR_STRIPLEADING     =    1 ; Strip leading whitespace
Global Const $STR_STRIPTRAILING    =    2 ; Strip trailing whitespace
Global Const $STR_STRIPSPACES      =    4 ; Strip double (or more) spaces between words

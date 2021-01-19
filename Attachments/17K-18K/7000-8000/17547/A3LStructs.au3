#include-once

Opt("MustDeclareVars", 1)

; #INDEX# =======================================================================================================================
; Title .........: Structures
; Description ...: This module contains common structures for Auto3Lib that are not related to a specifc module.
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================

; #STRUCTURE# ===================================================================================================================
; Description ...: tagBITMAPFILEHEADER structure
; Fields ........: Type      - Specifies the file type, must be "BM"
;                  Size      - Specifies the size, in bytes, of the bitmap file
;                  Reserved1 - Reserved; must be zero
;                  Reserved2 - Reserved; must be zero
;                  OffBits   - Specifies the offset, in bytes, from the beginning of the structure to the bitmap bits
; Author ........: Paul Campbell (PaulIA)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagBITMAPFILEHEADER = "short Type;uint Size;short Reserved1;short Reserved2;int OffBits"

; #STRUCTURE# ===================================================================================================================
; Description ...: tagBITMAPINFO structure
; Fields ........: Size          - The number of bytes required by the structure, minus the size of the RGBQuad data
;                  Width         - Specifies the width of the bitmap, in pixels
;                  Height        - Specifies the height of the bitmap, in pixels
;                  Planes        - Specifies the number of planes for the target device. This must be set to 1
;                  BitCount      - Specifies the number of bits-per-pixel
;                  Compression   - Specifies the type of compression for a compressed bottom-up bitmap
;                  SizeImage     - Specifies the size, in bytes, of the image
;                  XPelsPerMeter - Specifies the horizontal resolution, in pixels-per-meter, of the target device for the bitmap
;                  YPelsPerMeter - Specifies the vertical resolution, in pixels-per-meter, of the target device for the bitmap
;                  ClrUsed       - Specifies the number of color indexes in the color table that are actually used by the bitmap
;                  ClrImportant  - Specifies the number of color indexes that are required for displaying the bitmap
;                  RGBQuad       - An array of tagRGBQUAD structures. The elements of the array that make up the color table.
; Author ........: Paul Campbell (PaulIA)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagBITMAPINFO = "dword Size;long Width;long Height;ushort Planes;ushort BitCount;dword Compression;dword SizeImage;" & _
             "long XPelsPerMeter;long YPelsPerMeter;dword ClrUsed;dword ClrImportant;dword RGBQuad"

; #STRUCTURE# ===================================================================================================================
; Description ...: tagBITMAPINFOHEADER structure
; Fields ........: Size          - The number of bytes required by the structure
;                  Width         - Specifies the width of the bitmap, in pixels
;                  Height        - Specifies the height of the bitmap, in pixels
;                  Planes        - Specifies the number of planes for the target device. This must be set to 1
;                  BitCount      - Specifies the number of bits-per-pixel
;                  Compression   - Specifies the type of compression for a compressed bottom-up bitmap
;                  SizeImage     - Specifies the size, in bytes, of the image
;                  XPelsPerMeter - Specifies the horizontal resolution, in pixels-per-meter, of the target device for the bitmap
;                  YPelsPerMeter - Specifies the vertical resolution, in pixels-per-meter, of the target device for the bitmap
;                  ClrUsed       - Specifies the number of color indexes in the color table that are actually used by the bitmap
;                  ClrImportant  - Specifies the number of color indexes that are required for displaying the bitmap
; Author ........: Paul Campbell (PaulIA)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagBITMAPINFOHEADER = "int Size;int Width;int Height;short Planes;short BitCount;int Compression;int SizeImage;" & _
             "int XPelsPerMeter;int YPelsPerMeter;int ClrUsed;int ClrImportant"

; #STRUCTURE# ===================================================================================================================
; Description ...: tagBLENDFUNCTION structure
; Fields ........: Op     - Specifies the source blend operation:
;                  Flags  - Must be zero
;                  Alpha  - Specifies an alpha transparency value to be used on the entire source bitmap.  This value is combined
;                  +with any per-pixel alpha values in the source bitmap.  If set  to  0,  it  is  assumed  that  your  image  is
;                  +transparent. Set to 255 (opaque) when you only want to use per-pixel alpha values.
;                  Format - This member controls the way the source and destination bitmaps are interpreted:
;                  |$AC_SRC_ALPHA - This flag is set when the bitmap has an Alpha channel (that is, per-pixel alpha).  Note  that
;                  +the APIs use premultiplied alpha, which means that the red, green and blue channel values in the bitmap  must
;                  +be premultiplied with the alpha channel value.
; Author ........: Paul Campbell (PaulIA)
; Remarks .......: The source bitmap used with tagBLENDFUNCTION must be 32 bpp
; ===============================================================================================================================
Global Const $tagBLENDFUNCTION = "byte Op;byte Flags;byte Alpha;byte Format"

; #STRUCTURE# ===================================================================================================================
; Description ...: tagCURSORINFO structure
; Fields ........: Size    - Specifies the size, in bytes, of the structure
;                  Flags   - Specifies the cursor state. This parameter can be one of the following values:
;                  |0               - The cursor is hidden
;                  |$CURSOR_SHOWING - The cursor is showing
;                  hCursor - Handle to the cursor
;                  X       - X position of the cursor, in screen coordinates
;                  Y       - Y position of the cursor, in screen coordinates
; Author ........: Paul Campbell (PaulIA)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagCURSORINFO = "int Size;int Flags;hwnd hCursor;int X;int Y"

; #STRUCTURE# ===================================================================================================================
; Description ...: tagDISPLAY_DEVICE structure
; Fields ........: Size   - Specifies the size, in bytes, of the structure
;                  Name   - Either the adapter device or the monitor device
;                  String - Either a description of the display adapter or of the display monitor
;                  Flags  - Device state flags:
;                  |$DISPLAY_DEVICE_ATTACHED_TO_DESKTOP - The device is part of the desktop
;                  |$DISPLAY_DEVICE_MIRRORING_DRIVER    - Represents a pseudo device used to mirror drawing for remoting or other
;                  +purposes. An invisible pseudo monitor is associated with this device.
;                  |$DISPLAY_DEVICE_MODESPRUNED         - The device has more display modes than its output devices support
;                  |$DISPLAY_DEVICE_PRIMARY_DEVICE      - The primary desktop is on the device
;                  |$DISPLAY_DEVICE_REMOVABLE           - The device is removable; it cannot be the primary display
;                  |$DISPLAY_DEVICE_VGA_COMPATIBLE      - The device is VGA compatible.
;                  ID     - This is the Plug and Play identifier
;                  Key    - Reserved
; Author ........: Paul Campbell (PaulIA)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagDISPLAY_DEVICE = "int Size;char Name[32];char String[128];int Flags;char ID[128];char Key[128]"

; #STRUCTURE# ===================================================================================================================
; Description ...: tagFLASHWINDOW structure
; Fields ........: Size    - The size of the structure, in bytes
;                  hWnd    - A handle to the window to be flashed. The window can be either opened or minimized.
;                  Flags   - The flash status. This parameter can be one or more of the following values:
;                  |$FLASHW_ALL       - Flash both the window caption and taskbar button
;                  |$FLASHW_CAPTION   - Flash the window caption
;                  |$FLASHW_STOP      - Stop flashing
;                  |$FLASHW_TIMER     - Flash continuously, until the $FLASHW_STOP flag is set
;                  |$FLASHW_TIMERNOFG - Flash continuously until the window comes to the foreground
;                  |$FLASHW_TRAY      - Flash the taskbar button
;                  Count   - The number of times to flash the window
;                  Timeout - The rate at which the window is to be flashed, in milliseconds
; Author ........: Paul Campbell (PaulIA)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagFLASHWINDOW = "int Size;hwnd hWnd;int Flags;int Count;int TimeOut"

; #STRUCTURE# ===================================================================================================================
; Description ...: tagGUID structure
; Fields ........: Data 1 - Data 1 element
;                  Data 2 - Data 2 element
;                  Data 3 - Data 2 element
;                  Data 4 - Data 2 element
; Author ........: Paul Campbell (PaulIA)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagGUID = "int Data1;short Data2;short Data3;byte Data4[8]"

; #STRUCTURE# ===================================================================================================================
; Description ...: tagICONINFO structure
; Fields ........: Icon     - Specifies the contents of the structure:
;                  |True  - Icon
;                  |False - Cursor
;                  XHotSpot - Specifies the x-coordinate of a cursor's hot spot
;                  YHotSpot - Specifies the y-coordinate of the cursor's hot spot
;                  hMask    - Specifies the icon bitmask bitmap
;                  hColor   - Handle to the icon color bitmap
; Author ........: Paul Campbell (PaulIA)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagICONINFO = "int Icon;int XHotSpot;int YHotSpot;hwnd hMask;hwnd hColor"

; #STRUCTURE# ===================================================================================================================
; Description ...: tagLOGFONT structure
; Fields ........: Height         - Height, in logical units, of the font's character cell or character
;                  Width          - Specifies the average width, in logical units, of characters in the font
;                  Escapement     - Specifies the angle, in tenths of degrees, between the escapement vector and the X axis
;                  Orientation    - Specifies the angle, in tenths of degrees, between each character's base line and the X axis
;                  Weight         - Specifies the weight of the font in the range 0 through 1000
;                  Italic         - Specifies an italic font if set to True
;                  Underline      - Specifies an underlined font if set to True
;                  StrikeOut      - Specifies a strikeout font if set to True
;                  CharSet        - Specifies the character set
;                  OutPrecision   - Specifies the output precision
;                  ClipPrecision  - Specifies the clipping precision
;                  Quality        - Specifies the output quality
;                  PitchAndFamily - Specifies the pitch and family of the font
;                  FaceName       - Specifies the typeface name of the font
; Author ........: Paul Campbell (PaulIA)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagLOGFONT = "int Height;int Width;int Escapement;int Orientation;int Weight;byte Italic;byte Underline;" & _
             "byte Strikeout;byte CharSet;byte OutPrecision;byte ClipPrecision;byte Quality;byte PitchAndFamily;char FaceName[32]"

; #STRUCTURE# ===================================================================================================================
; Description ...: tagNMHDR structure
; Fields ........: hWndFrom - Window handle to the control sending a message
;                  IDFrom   - Identifier of the control sending a message
;                  Code     - Notification code
; Author ........: Paul Campbell (PaulIA)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagNMHDR = "int hWndFrom;int IDFrom;int Code"

; #STRUCTURE# ===================================================================================================================
; Description ...: tagPEB structure
; Fields ........: Reserved1    - Reserved for internal use by the operating system
;                  Debugging    - Indicates whether the specified process is currently being debugged
;                  Reserved2    - Reserved for internal use by the operating system
;                  LoaderData   - A pointer to a tagPEB_LDR_DATA structure that contains information about the loaded modules
;                  Parameters   - A pointer to an tagRTL_USER_PROCESS_PARAMETERS structure that contains process parameters
;                  Reserved3    - Reserved for internal use by the operating system
;                  PPIR         - A callback function that is used to initialize the application compatibility layer on Win2K
;                  Reserved4    - Reserved for internal use by the operating system
;                  SessionID    - The Terminal Services session identifier associated with the current process
; Author ........: Paul Campbell (PaulIA)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagPEB = "byte Reserved1[2];byte Debugging;byte Reserved2[9];ptr LoaderData;ptr Parameters;byte Reserved3[312];" & _
             "ptr PPIR;byte Res4[132];int SessionID"

; #STRUCTURE# ===================================================================================================================
; Description ...: tagPOINT structure
; Fields ........: X - Specifies the x-coordinate of the point
;                  Y - Specifies the y-coordinate of the point
; Author ........: Paul Campbell (PaulIA)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagPOINT = "int X;int Y"

; #STRUCTURE# ===================================================================================================================
; Description ...: tagPROCESS_BASIC_INFORMATION structure
; Fields ........: Reserved1    - Reserved for internal use by the operating system
;                  PEBBaseAddr  - Pointes to a PEB structure
;                  Reserved2    - Reserved for internal use by the operating system
;                  ProcessID    - Points to the system's unique identifier for the process
;                  Reserved3    - Reserved for internal use by the operating system
; Author ........: Paul Campbell (PaulIA)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagPROCESS_BASIC_INFORMATION = "ptr Reserved1;ptr PEBBaseAddr;ptr Reserved2[2];ptr ProcessID;ptr Reserved3"

; #STRUCTURE# ===================================================================================================================
; Description ...: tagPROCESS_INFORMATION structure
; Fields ........: hProcess  - A handle to the newly created process
;                  hThread   - A handle to the primary thread of the newly created process
;                  ProcessID - A value that can be used to identify a process
;                  ThreadID  - A value that can be used to identify a thread
; Author ........: Paul Campbell (PaulIA)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagPROCESS_INFORMATION = "hwnd hProcess;hwnd hThread;int ProcessID;int ThreadID"

; #STRUCTURE# ===================================================================================================================
; Description ...: tagRECT structure
; Fields ........: Left   - Specifies the x-coordinate of the upper-left corner of the rectangle
;                  Top    - Specifies the y-coordinate of the upper-left corner of the rectangle
;                  Right  - Specifies the x-coordinate of the lower-right corner of the rectangle
;                  Bottom - Specifies the y-coordinate of the lower-right corner of the rectangle
; Author ........: Paul Campbell (PaulIA)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagRECT = "int Left;int Top;int Right;int Bottom"

; #STRUCTURE# ===================================================================================================================
; Description ...: tagRTL_USER_PROCESS_PARAMETERS structure
; Fields ........: Reserved1    - Reserved for internal use by the operating system
;                  IPLen        - ImagePath length
;                  IPMax        - ImagePath maximum length
;                  ImagePath    - The path of the image file for the process
;                  CLLen        - CommandLine length
;                  CLMax        - CommandLine maximum length
;                  CommandLine  - The command line string passed to the process
;                  Reserved2    - Reserved for internal use by the operating system
; Author ........: Paul Campbell (PaulIA)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagRTL_USER_PROCESS_PARAMETERS = "byte Reserved1[56];short IPLen;short IPMax;ptr ImagePath;short CLLen;" & _
             "short CLMax;ptr CommandLine;byte Reserved2[92]"

; #STRUCTURE# ===================================================================================================================
; Description ...: tagSECURITY_ATTRIBUTES structure
; Fields ........: Length        - The size, in bytes, of this structure
;                  Descriptor    - A pointer to a security descriptor for the object that controls the sharing of it
;                  InheritHandle - If True, the new process inherits the handle.
; Author ........: Paul Campbell (PaulIA)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagSECURITY_ATTRIBUTES = "int Length;ptr Descriptor;int InheritHandle"

; #STRUCTURE# ===================================================================================================================
; Description ...: tagSIZE structure
; Fields ........: X - Width
;                  Y - Height
; Author ........: Paul Campbell (PaulIA)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagSIZE = "int X;int Y"

; #STRUCTURE# ===================================================================================================================
; Description ...: tagSTARTUPINFO structure
; Fields ........: Size          - The size of the structure, in bytes
;                  Reserved1     - Reserved, must be zero
;                  Desktop       - The name of the desktop, or the name of both the desktop and window station for this process
;                  Title         - For console processes, the title displayed in the title bar if a new console is created
;                  X             - If Flags specifies $STARTF_USEPOSITION, this member is the x offset of the upper  left  corner
;                  +of a window if a new window is created, in pixels.
;                  Y             - If Flags specifies $STARTF_USEPOSITION, this member is the y offset of the upper  left  corner
;                  +of a window if a new window is created, in pixels.
;                  XSize         - If Flags specifies $STARTF_USESIZE, this member is the height of the window, in pixels
;                  YSize         - If Flags specifies $STARTF_USESIZE, this member is the width of the window, in pixels
;                  XCountChars   - If Flags specifies $STARTF_USECOUNTCHARS, if a new console window  is  created  in  a  console
;                  +process, this member specifies the screen buffer width, in character columns.
;                  YCountChars   - If Flags specifies $STARTF_USECOUNTCHARS, if a new console window  is  created  in  a  console
;                  +process, this member specifies the screen buffer height, in character rows.
;                  FillAttribute - If Flags specifies $STARTF_USEFILLATTRIBUTE, this member is the initial  text  and  background
;                  +colors if a new console window is created in a console application.
;                  Flags         - Determines which members are used when the process creates a window:
;                  |$STARTF_FORCEONFEEDBACK  - The cursor is in feedback mode for two seconds after CreateProcess is  called. The
;                  +Working in Background cursor is displayed.  If during those two seconds the process makes the first GUI call,
;                  +the system gives five more seconds to the process.  If during those five seconds the process shows a  window,
;                  +the system gives five more seconds to the process to finish drawing the window. The system turns the feedback
;                  +cursor off after the first call to GetMessage, regardless of whether the process is drawing.
;                  |$STARTF_FORCEOFFFEEDBACK - Indicates that the feedback cursor is forced off while the  process  is  starting.
;                  +The Normal Select cursor is displayed.
;                  |$STARTF_RUNFULLSCREEN    - Indicates that the process should be run in  full  screen  mode,  rather  than  in
;                  +windowed mode. This flag is only valid for console applications running on an x86 computer.
;                  |$STARTF_USECOUNTCHARS    - The XCountChars and YCountChars members are valid
;                  |$STARTF_USEFILLATTRIBUTE - The FillAttribute member is valid
;                  |$STARTF_USEPOSITION      - The X and Y members are valid
;                  |$STARTF_USESHOWWINDOW    - The ShowWindow member is valid
;                  |$STARTF_USESIZE          - The XSize and YSize members are valid
;                  |$STARTF_USESTDHANDLES    - The hStdInput, hStdOutput, and hStdError members are valid
;                  ShowWindow    - If Flags specifies $STARTF_USESHOWWINDOW, this member can be any of the SW_ constants
;                  Reserved2     -  Reserved, must be zero
;                  Reserved3     -  Reserved, must be zero
;                  StdInput      - If Flags specifies $STARTF_USESTDHANDLES, this member is the standard input handle
;                  StdOutput     - If Flags specifies $STARTF_USESTDHANDLES, this member is the standard output handle
;                  StdError      - If Flags specifies $STARTF_USESTDHANDLES, this member is the standard error handle
; Author ........: Paul Campbell (PaulIA)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagSTARTUPINFO = "int Size;ptr Reserved1;ptr Desktop;ptr Title;int X;int Y;int XSize;int YSize;int XCountChars;" & _
             "int YCountChars;int FillAttribute;int Flags;short ShowWindow;short Reserved2;ptr Reserved3;int StdInput;"        & _
             "int StdOutput;int StdError"

; #STRUCTURE# ===================================================================================================================
; Description ...: tagWINDOWPOS structure
; Fields ........: hWnd        - Handle to the window
;                  InsertAfter - Specifies the position of the window in Z order
;                  X           - Specifies the position of the left edge of the window
;                  Y           - Specifies the position of the top edge of the window
;                  CX          - Specifies the window width, in pixels
;                  CY          - Specifies the window height, in pixels
;                  Flags       - Specifies the window position. This member can be one or more of the following values:
;                  |$SWP_DRAWFRAME      - Draws a frame around the window
;                  |$SWP_FRAMECHANGED   - Sends a WM_NCCALCSIZE message to the window, even if the window's size is not being changed
;                  |$SWP_HIDEWINDOW     - Hides the window
;                  |$SWP_NOACTIVATE     - Does not activate the window
;                  |$SWP_NOCOPYBITS     - Discards the entire contents of the client area
;                  |$SWP_NOMOVE         - Retains the current position (ignores the x and y parameters)
;                  |$SWP_ NOOWNERZORDER - Does not change the owner window's position in the Z order
;                  |$SWP_NOREDRAW       - Does not redraw changes
;                  |$SWP_NOREPOSITION   - Same as the SWP_NOOWNERZORDER flag
;                  |$SWP_NOSENDCHANGING - Prevents the window from receiving the WM_WINDOWPOSCHANGING message
;                  |$SWP_NOSIZE         - Retains the current size (ignores the cx and cy parameters)
;                  |$SWP_NOZORDER       - Retains the current Z order (ignores the InsertAfter parameter)
;                  |$SWP_SHOWWINDOW     - Displays the window
; Author ........: Paul Campbell (PaulIA)
; Remarks .......:
; ===============================================================================================================================
Global Const $tagWINDOWPOS = "int hWnd;int InsertAfter;int X;int Y;int CX;int CY;int Flags"

Opt("MustDeclareVars", 0)
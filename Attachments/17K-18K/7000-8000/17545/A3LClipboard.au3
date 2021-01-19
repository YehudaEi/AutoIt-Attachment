#include-once
#include <A3LMemory.au3>
#include <A3LWinAPI.au3>

Opt("MustDeclareVars", 1)

; #INDEX# =======================================================================================================================
; Title .........: Clipboard
; Description ...: The clipboard is a set of functions and messages that  enable  applications  to  transfer  data.  Because  all
;                  applications have access to the clipboard, data can be easily transferred between applications  or  within  an
;                  application.
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
  Global Const $CF_TEXT                 = 1             ; Text format
  Global Const $CF_BITMAP               = 2             ; Handle to a bitmap (HBITMAP)
  Global Const $CF_METAFILEPICT         = 3             ; Handle to a metafile picture (METAFILEPICT)
  Global Const $CF_SYLK                 = 4             ; Microsoft Symbolic Link (SYLK) format
  Global Const $CF_DIF                  = 5             ; Software Arts' Data Interchange Format
  Global Const $CF_TIFF                 = 6             ; Tagged image file format
  Global Const $CF_OEMTEXT              = 7             ; Text format containing characters in the OEM character set
  Global Const $CF_DIB                  = 8             ; BITMAPINFO structure followed by the bitmap bits
  Global Const $CF_PALETTE              = 9             ; Handle to a color palette
  Global Const $CF_PENDATA              = 10            ; Data for the pen extensions to Pen Computing
  Global Const $CF_RIFF                 = 11            ; Represents audio data in RIFF format
  Global Const $CF_WAVE                 = 12            ; Represents audio data in WAVE format
  Global Const $CF_UNICODETEXT          = 13            ; Unicode text format
  Global Const $CF_ENHMETAFILE          = 14            ; Handle to an enhanced metafile (HENHMETAFILE)
  Global Const $CF_HDROP                = 15            ; Handle to type HDROP that identifies a list of files
  Global Const $CF_LOCALE               = 16            ; Handle to the locale identifier associated with text in the clipboard
  Global Const $CF_DIBV5                = 17            ; BITMAPV5HEADER structure followed by bitmap color and the bitmap bits
  Global Const $CF_OWNERDISPLAY         = 0x0080        ; Owner display format
  Global Const $CF_DSPTEXT              = 0x0081        ; Text display format associated with a private format
  Global Const $CF_DSPBITMAP            = 0x0082        ; Bitmap display format associated with a private format
  Global Const $CF_DSPMETAFILEPICT      = 0x0083        ; Metafile picture display format associated with a private format
  Global Const $CF_DSPENHMETAFILE       = 0x008E        ; Enhanced metafile display format associated with a private format
  Global Const $CF_PRIVATEFIRST         = 0x0200        ; Range of integer values for private clipboard formats
  Global Const $CF_PRIVATELAST          = 0x02FF        ; Range of integer values for private clipboard formats
  Global Const $CF_GDIOBJFIRST          = 0x0300        ; Range for (GDI) object clipboard formats
  Global Const $CF_GDIOBJLAST           = 0x03FF        ; Range for (GDI) object clipboard formats
; ===============================================================================================================================

; #MESSAGES# ====================================================================================================================
  Global Const $WM_CUT                  = 0x00000300
  Global Const $WM_COPY                 = 0x00000301
  Global Const $WM_PASTE                = 0x00000302
  Global Const $WM_CLEAR                = 0x00000303
  Global Const $WM_UNDO                 = 0x00000304
; ===============================================================================================================================

; #NOTIFICATIONS# ===============================================================================================================
  Global Const $WM_RENDERFORMAT         = 0x00000305    ; Sent if the owner has delayed rendering a specific clipboard format
  Global Const $WM_RENDERALLFORMATS     = 0x00000306    ; Sent if the owner has delayed rendering clipboard formats
  Global Const $WM_DESTROYCLIPBOARD     = 0x00000307    ; Sent when a call to EmptyClipboard empties the clipboard
  Global Const $WM_DRAWCLIPBOARD        = 0x00000308    ; Sent when the content of the clipboard changes
  Global Const $WM_PAINTCLIPBOARD       = 0x00000309    ; Sent when the clipboard viewer's client area needs repainting
  Global Const $WM_VSCROLLCLIPBOARD     = 0x0000030A    ; Sent when an event occurs in the viewer's vertical scroll bar
  Global Const $WM_SIZECLIPBOARD        = 0x0000030B    ; Sent when the clipboard viewer's client area has changed size
  Global Const $WM_ASKCBFORMATNAME      = 0x0000030C    ; Sent to request the name of a $CF_OWNERDISPLAY clipboard format
  Global Const $WM_CHANGECBCHAIN        = 0x0000030D    ; Sent when a window is being removed from the chain
  Global Const $WM_HSCROLLCLIPBOARD     = 0x0000030E    ; Sent when an event occurs in the viewer's horizontal scroll bar
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Description ...: Removes a specified window from the chain of clipboard viewers
; Parameters ....: $hRemove     - Handle to the window to be removed from the chain.  The handle must have  been  passed  to  the
;                  +_Clip_SetClipboardViewer function.
;                  $hNewNext    - Handle to the window that follows the $hRemove window in the clipboard viewer  chain.  This  is
;                  +the handle returned by _Clip_SetViewer, unless the sequence was changed in response  to  a  $WM_CHANGECBCHAIN
;                  +message.
; Return values .:
; Author ........: Paul Campbell (PaulIA)
; Remarks .......: The window identified by $hNewNext replaces the $hRemove window  in  the  chain.  The _Clip_SetViewer function
;                  sends a $WM_CHANGECBCHAIN message to the first window in the clipboard viewer chain.
; Related .......: _Clip_SetViewer
; ===============================================================================================================================
Func _Clip_ChangeChain($hRemove, $hNewNext)
  DllCall("User32.dll", "int", "ChangeClipboardChain", "hwnd", $hRemove, "hwnd", $hNewNext)
EndFunc

; #FUNCTION# ====================================================================================================================
; Description ...: Closes the clipboard
; Parameters ....:
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Remarks .......: When the window has finished examining or changing the clipboard close the clipboard by calling this function.
;                  This enables other windows to access the clipboard.  Do not place an object on the  clipboard  after  calling
;                  this function.
; Related .......: _Clip_Open
; ===============================================================================================================================
Func _Clip_Close()
  Local $aResult

  $aResult = DllCall("User32.dll", "int", "CloseClipboard")
  Return SetError($aResult[0]=0, 0, $aResult[0]<>0)
EndFunc

; #FUNCTION# ====================================================================================================================
; Description ...: Retrieves the number of different data formats currently on the clipboard
; Parameters ....:
; Return values .: Success      - The number of different data formats currently on the clipboard
; Author ........: Paul Campbell (PaulIA)
; Remarks .......:
; Related .......: _Clip_EnumFormats
; ===============================================================================================================================
Func _Clip_CountFormats()
  Local $aResult

  $aResult = DllCall("User32.dll", "int", "CountClipboardFormats")
  Return $aResult[0]
EndFunc

; #FUNCTION# ====================================================================================================================
; Description ...: Empties the clipboard and frees handles to data in the clipboard
; Parameters ....:
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Remarks .......: Before calling this function, you must open the clipboard by using the _Clip_Open function.  If you  specified
;                  a NULL window handle when opening the clipboard, this function succeeds but sets the clipboard owner to  NULL.
;                  Note that this causes _Clip_SetData to fail.
; Related .......: _Clip_Open, _Clip_SetData
; ===============================================================================================================================
Func _Clip_Empty()
  Local $aResult

  $aResult = DllCall("User32.dll", "int", "EmptyClipboard")
  Return SetError($aResult[0]=0, 0, $aResult[0]<>0)
EndFunc

; #FUNCTION# ====================================================================================================================
; Description ...: Enumerates the data formats currently available on the clipboard
; Parameters ....: $iFormat     - Specifies a clipboard format that is known to be available. To start an enumeration of formats,
;                  +set $iFormat to zero. When $iFormat is zero, the function retrieves the first available clipboard format. For
;                  +subsequent calls during an enumeration, set $iFormat to the result of the previous call.
; Return values .: Success      - The clipboard format that follows the specified format
;                  Failure      - 0
; Author ........: Paul Campbell (PaulIA)
; Remarks .......: You must open the clipboard before enumerating its formats
; Related .......: _Clip_Open
; ===============================================================================================================================
Func _Clip_EnumFormats($iFormat)
  Local $aResult

  $aResult = DllCall("User32.dll", "int", "EnumClipboardFormats", "int", $iFormat)
  Return $aResult[0]
EndFunc

; #FUNCTION# ====================================================================================================================
; Description ...: Returns a string representation of a standard clipboard format
; Parameters ....: $iFormat     - Specifies a clipboard format
; Return values .: Success      - String representation of the clipboard format
; Author ........: Paul Campbell (PaulIA)
; Remarks .......:
; Related .......:
; ===============================================================================================================================
Func _Clip_FormatStr($iFormat)
  Switch $iFormat
    case $CF_TEXT
      Return "Text"
    case $CF_BITMAP
      Return "Bitmap"
    case $CF_METAFILEPICT
      Return "Metafile Picture"
    case $CF_SYLK
      Return "SYLK"
    case $CF_DIF
      Return "DIF"
    case $CF_TIFF
      Return "TIFF"
    case $CF_OEMTEXT
      Return "OEM Text"
    case $CF_DIB
      Return "DIB"
    case $CF_PALETTE
      Return "Palette"
    case $CF_PENDATA
      Return "Pen Data"
    case $CF_RIFF
      Return "RIFF"
    case $CF_WAVE
      Return "WAVE"
    case $CF_UNICODETEXT
      Return "Unicode Text"
    case $CF_ENHMETAFILE
      Return "Enhanced Metafile"
    case $CF_HDROP
      Return "HDROP"
    case $CF_LOCALE
      Return "Locale"
    case $CF_DIBV5
      Return "DIB V5"
    case $CF_OWNERDISPLAY
      Return "Owner Display"
    case $CF_DSPTEXT
      Return "Private Text"
    case $CF_DSPBITMAP
      Return "Private Bitmap"
    case $CF_DSPMETAFILEPICT
      Return "Private Metafile Picture"
    case $CF_DSPENHMETAFILE
      Return "Private Enhanced Metafile"
    case else
      Return _Clip_GetFormatName($iFormat)
  EndSwitch
EndFunc

; #FUNCTION# ====================================================================================================================
; Description ...: Retrieves data from the clipboard in a specified format
; Parameters ....: $iFormat     - Specifies a clipboard format:
;                  |CF_TEXT            - Text format
;                  |CF_BITMAP          - Handle to a bitmap (HBITMAP)
;                  |CF_METAFILEPICT    - Handle to a metafile picture (METAFILEPICT)
;                  |CF_SYLK            - Microsoft Symbolic Link (SYLK) format
;                  |CF_DIF             - Software Arts' Data Interchange Format
;                  |CF_TIFF            - Tagged image file format
;                  |CF_OEMTEXT         - Text format containing characters in the OEM character set
;                  |CF_DIB             - BITMAPINFO structure followed by the bitmap bits
;                  |CF_PALETTE         - Handle to a color palette
;                  |CF_PENDATA         - Data for the pen extensions to Pen Computing
;                  |CF_RIFF            - Represents audio data in RIFF format
;                  |CF_WAVE            - Represents audio data in WAVE format
;                  |CF_UNICODETEXT     - Unicode text format
;                  |CF_ENHMETAFILE     - Handle to an enhanced metafile (HENHMETAFILE)
;                  |CF_HDROP           - Handle to type HDROP that identifies a list of files
;                  |CF_LOCALE          - Handle to the locale identifier associated with text in the clipboard
;                  |CF_DIBV5           - BITMAPV5HEADER structure followed by bitmap color and the bitmap bits
;                  |CF_OWNERDISPLAY    - Owner display format
;                  |CF_DSPTEXT         - Text display format associated with a private format
;                  |CF_DSPBITMAP       - Bitmap display format associated with a private format
;                  |CF_DSPMETAFILEPICT - Metafile picture display format associated with a private format
;                  |CF_DSPENHMETAFILE  - Enhanced metafile display format associated with a private format
; Return values .: Success      - Text for text based formats or a handle for all other formats
;                  Failure      - 0
; Author ........: Paul Campbell (PaulIA)
; Remarks .......: This function performs all of the steps neccesary to get data from the clipboard. It checks to see if the data
;                  format is available, opens the clipboard, closes the clipboard and returns the data (converting it to a string
;                  if needed.  If you need a finer degree of control over retrieving data from the clipboard, you may want to use
;                  the _Clip_GetDataEx function.
; Related .......: _Clip_GetDataEx, _Clip_SetData
; ===============================================================================================================================
Func _Clip_GetData($iFormat=1)
  Local $hMemory, $tData

  if not _Clip_IsFormatAvailable($iFormat) then Return SetError(-1, 0, 0)
  if not _Clip_Open(0) then Return SetError(-2, 0, 0)
  $hMemory = _Clip_GetDataEx($iFormat)
  _Clip_Close()
  if $hMemory = 0 then Return SetError(-3, 0, 0)
  Switch $iFormat
    case $CF_TEXT, $CF_OEMTEXT
      $tData = DllStructCreate("char Text[2097152]", $hMemory)
      Return DllStructGetData($tData, "Text")
    case $CF_UNICODETEXT
      Return _API_WideCharToMultiByte($tData)
    case else
      Return $hMemory
  EndSwitch
EndFunc

; #FUNCTION# ====================================================================================================================
; Description ...: Retrieves data from the clipboard in a specified format
; Parameters ....: $iFormat     - Specifies a clipboard format:
;                  |CF_TEXT            - Text format
;                  |CF_BITMAP          - Handle to a bitmap (HBITMAP)
;                  |CF_METAFILEPICT    - Handle to a metafile picture (METAFILEPICT)
;                  |CF_SYLK            - Microsoft Symbolic Link (SYLK) format
;                  |CF_DIF             - Software Arts' Data Interchange Format
;                  |CF_TIFF            - Tagged image file format
;                  |CF_OEMTEXT         - Text format containing characters in the OEM character set
;                  |CF_DIB             - BITMAPINFO structure followed by the bitmap bits
;                  |CF_PALETTE         - Handle to a color palette
;                  |CF_PENDATA         - Data for the pen extensions to Pen Computing
;                  |CF_RIFF            - Represents audio data in RIFF format
;                  |CF_WAVE            - Represents audio data in WAVE format
;                  |CF_UNICODETEXT     - Unicode text format
;                  |CF_ENHMETAFILE     - Handle to an enhanced metafile (HENHMETAFILE)
;                  |CF_HDROP           - Handle to type HDROP that identifies a list of files
;                  |CF_LOCALE          - Handle to the locale identifier associated with text in the clipboard
;                  |CF_DIBV5           - BITMAPV5HEADER structure followed by bitmap color and the bitmap bits
;                  |CF_OWNERDISPLAY    - Owner display format
;                  |CF_DSPTEXT         - Text display format associated with a private format
;                  |CF_DSPBITMAP       - Bitmap display format associated with a private format
;                  |CF_DSPMETAFILEPICT - Metafile picture display format associated with a private format
;                  |CF_DSPENHMETAFILE  - Enhanced metafile display format associated with a private format
; Return values .: Success      - Handle to a clipboard object in the specified format
;                  Failure      - 0
; Author ........: Paul Campbell (PaulIA)
; Remarks .......: The clipboard controls the handle that the _Clip_GetData function returns, not  the  application.  You  should
;                  copy the data immediately.  The application must not free the handle nor leave it locked. The application must
;                  not use the handle after the _Clip_Empty or  _Clip_Close  function  is  called,  or  after  the  _Clip_SetData
;                  function is called with the same clipboard format.
; Related .......: _Clip_SetData
; ===============================================================================================================================
Func _Clip_GetDataEx($iFormat=1)
  Local $aResult

  $aResult = DllCall("User32.dll", "hwnd", "GetClipboardData", "int", $iFormat)
  Return SetError($aResult[0]=0, 0, $aResult[0])
EndFunc

; #FUNCTION# ====================================================================================================================
; Description ...: Retrieves the name of the specified registered format
; Parameters ....: $iFormat     - Specifies the type of format to be retrieved
; Return values .: Success      - Format name
;                  Failure      - Blank string
; Author ........: Paul Campbell (PaulIA)
; Remarks .......: The $iFormat parameter must not specify any of the predefined clipboard formats
; Related .......:
; ===============================================================================================================================
Func _Clip_GetFormatName($iFormat)
  Local $aResult

  $aResult = DllCall("User32.dll", "int", "GetClipboardFormatNameA", "int", $iFormat, "str", "", "int", 4096)
  Return $aResult[2]
EndFunc

; #FUNCTION# ====================================================================================================================
; Description ...: Retrieves the handle to the window that currently has the clipboard open
; Parameters ....:
; Return values .: Success      - The handle to the window that has the clipboard open
;                  Failure      - Zero if no window has the clipboard open
; Author ........: Paul Campbell (PaulIA)
; Remarks .......: If an application or DLL specifies a NULL window handle when calling the _Clip_Open  function,  the  clipboard
;                  is opened but is not associated with a window.  In such a case, _Clip_GetOpenWindow returns 0.
; Related .......: _Clip_GetOwner, _Clip_Open
; ===============================================================================================================================
Func _Clip_GetOpenWindow()
  Local $aResult

  $aResult = DllCall("User32.dll", "hwnd", "GetOpenClipboardWindow")
  Return $aResult[0]
EndFunc

; #FUNCTION# ====================================================================================================================
; Description ...: Retrieves the window handle of the current owner of the clipboard
; Parameters ....:
; Return values .: Success      - The handle to the window that owns the clipboard
;                  Failure      - 0
; Author ........: Paul Campbell (PaulIA)
; Remarks .......: The clipboard can still contain data even if the clipboard is not currently owned.  In general, the  clipboard
;                  owner is the window that last placed data in clipboard. The _Clip_Empty function assigns clipboard ownership.
; Related .......: _Clip_Empty
; ===============================================================================================================================
Func _Clip_GetOwner()
  Local $aResult

  $aResult = DllCall("User32.dll", "hwnd", "GetClipboardOwner")
  Return $aResult[0]
EndFunc

; #FUNCTION# ====================================================================================================================
; Description ...: Retrieves the first available clipboard format in the specified list
; Parameters ....: $aFormats    - Array with the following format:
;                  |[0] - Number of formats (n)
;                  |[1] - Format 1
;                  |[2] - Format 2
;                  |[n] - Format n
; Return values .: Success      - The first clipboard format in the list for which data is available
;                  Failure      - Format not found due to:
;                  |-1 - Clipboard has data, but not in any of the formats requested
;                  | 0 - Clipboard is empty
; Author ........: Paul Campbell (PaulIA)
; Remarks .......:
; Related .......: _Clip_CountFormats, _Clip_EnumFormats
; ===============================================================================================================================
Func _Clip_GetPriorityFormat($aFormats)
  Local $iI, $tData, $aResult

  if not IsArray($aFormats) then Return SetError(-1, 0, 0)
  if $aFormats[0] <= 0      then Return SetError(-2, 0, 0)

  $tData = DllStructCreate("int[" & $aFormats[0] & "]")
  for $iI = 1 to $aFormats[0]
    DllStructSetData($tData, 1, $aFormats[$iI], $iI)
  next

  $aResult = DllCall("User32.dll", "int", "GetPriorityClipboardFormat", "ptr", DllStructGetPtr($tData), "int", $aFormats[0])
  Return $aResult[0]
EndFunc

; #FUNCTION# ====================================================================================================================
; Description ...: Retrieves the clipboard sequence number for the current window station
; Parameters ....:
; Return values .: Success      - The clipboard sequence number
;                  Failure      - 0
; Author ........: Paul Campbell (PaulIA)
; Remarks .......: The system keeps a serial number for the clipboard for each window station.  This number is  incremented  when
;                  the contents of the clipboard change or the clipboard is emptied. You can track this value to determine if the
;                  clipboard contents have changed and optimize creating data objects.  If clipboard rendering  is  delayed,  the
;                  sequence number is not incremented until the changes are rendered.
; Related .......:
; ===============================================================================================================================
Func _Clip_GetSequenceNumber()
  Local $aResult

  $aResult = DllCall("User32.dll", "dword", "GetClipboardSequenceNumber")
  Return $aResult[0]
EndFunc

; #FUNCTION# ====================================================================================================================
; Description ...: Retrieves the handle to the first window in the clipboard viewer chain
; Parameters ....:
; Return values .: Success      - The handle to the first window in the clipboard viewer chain
;                  Failure      - Zero if there is no clipboard viewer
; Author ........: Paul Campbell (PaulIA)
; Remarks .......:
; Related .......: _Clip_SetViewer
; ===============================================================================================================================
Func _Clip_GetViewer()
  Local $aResult

  $aResult = DllCall("User32.dll", "hwnd", "GetClipboardViewer")
  Return $aResult[0]
EndFunc

; #FUNCTION# ====================================================================================================================
; Description ...: Determines whether the clipboard contains data in the specified format
; Parameters ....: $iFormat     - Specifies a standard or registered clipboard format
; Return values .: True         - Clipboard contains data in the specified format
;                  False        - Clipboard does not contain data in the specified format
; Author ........: Paul Campbell (PaulIA)
; Remarks .......:
; Related .......:
; ===============================================================================================================================
Func _Clip_IsFormatAvailable($iFormat)
  Local $aResult

  $aResult = DllCall("User32.dll", "int", "IsClipboardFormatAvailable", "int", $iFormat)
  Return $aResult[0] <> 0
EndFunc

; #FUNCTION# ====================================================================================================================
; Description ...: Opens the clipboard and prevents other applications from modifying the clipboard
; Parameters ....: $hOwner      - Handle to the window to be associated with the open clipboard. If this parameter is 0, the open
;                  +clipboard is associated with the current task.
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Remarks .......: This function fails if another window has the clipboard  open.  Call  the  _Clip_Close  function  after  every
;                  successful call to this function. The window identified by the $hOwner parameter does not become the clipboard
;                  owner unless the _Clip_Empty function is called.  If you call _Clip_Open with hwnd set to 0, _Clip_Empty  sets
;                  the clipboard owner to0 which causes _Clip_SetData to fail.
; Related .......: _Clip_Close, _Clip_Empty
; ===============================================================================================================================
Func _Clip_Open($hOwner)
  Local $aResult

  $aResult = DllCall("User32.dll", "int", "OpenClipboard", "hwnd", $hOwner)
  Return SetError($aResult[0]=0, 0, $aResult[0]<>0)
EndFunc

; #FUNCTION# ====================================================================================================================
; Description ...: Registers a new clipboard format
; Parameters ....: $sFormat     - The name of the new format
; Return values .: Success      - The registered clipboard format
;                  Failure      - 0
; Author ........: Paul Campbell (PaulIA)
; Remarks .......: If a registered format with the specified name already exists, a new format is not registered and  the  return
;                  value identifies the existing format.  This enables more than one application to copy and paste data using the
;                  same registered clipboard format. Note that the format name comparison is case-insensitive.
; Related .......: _Clip_EnumFormats
; ===============================================================================================================================
Func _Clip_RegisterFormat($sFormat)
  Local $aResult

  $aResult = DllCall("User32.dll", "int", "RegisterClipboardFormat", "str", $sFormat)
  Return SetError($aResult[0]=0, 0, $aResult[0])
EndFunc

; #FUNCTION# ====================================================================================================================
; Description ...: Places data on the clipboard in a specified clipboard format
; Parameters ....: $hMemory     - Handle to the data in the specified format.  This parameter can be NULL,  indicating  that  the
;                  +window provides data in the specified clipboard format upon request.  If a window delays rendering,  it  must
;                  +process the $WM_RENDERFORMAT and $WM_RENDERALLFORMATS messages.  If this function succeeds, the  system  owns
;                  +the object identified by the $hMemory parameter.  The application may not write to  or  free  the  data  once
;                  +ownership has been transferred to the system, but it can lock and read from the data  until  the  _Clip_Close
;                  +function is called.  The memory must be unlocked before the clipboard is closed.  If the  $hMemory  parameter
;                  +identifies a memory object, the object must have been allocated using the function  with  the  $GMEM_MOVEABLE
;                  +flag.
;                  $iFormat     - Specifies a clipboard format:
;                  |CF_TEXT            - Text format
;                  |CF_BITMAP          - Handle to a bitmap (HBITMAP)
;                  |CF_METAFILEPICT    - Handle to a metafile picture (METAFILEPICT)
;                  |CF_SYLK            - Microsoft Symbolic Link (SYLK) format
;                  |CF_DIF             - Software Arts' Data Interchange Format
;                  |CF_TIFF            - Tagged image file format
;                  |CF_OEMTEXT         - Text format containing characters in the OEM character set
;                  |CF_DIB             - BITMAPINFO structure followed by the bitmap bits
;                  |CF_PALETTE         - Handle to a color palette
;                  |CF_PENDATA         - Data for the pen extensions to Pen Computing
;                  |CF_RIFF            - Represents audio data in RIFF format
;                  |CF_WAVE            - Represents audio data in WAVE format
;                  |CF_UNICODETEXT     - Unicode text format
;                  |CF_ENHMETAFILE     - Handle to an enhanced metafile (HENHMETAFILE)
;                  |CF_HDROP           - Handle to type HDROP that identifies a list of files
;                  |CF_LOCALE          - Handle to the locale identifier associated with text in the clipboard
;                  |CF_DIBV5           - BITMAPV5HEADER structure followed by bitmap color and the bitmap bits
;                  |CF_OWNERDISPLAY    - Owner display format
;                  |CF_DSPTEXT         - Text display format associated with a private format
;                  |CF_DSPBITMAP       - Bitmap display format associated with a private format
;                  |CF_DSPMETAFILEPICT - Metafile picture display format associated with a private format
;                  |CF_DSPENHMETAFILE  - Enhanced metafile display format associated with a private format
; Return values .: Success      - The handle to the data
;                  Failure      - 0
; Author ........: Paul Campbell (PaulIA)
; Remarks .......: This function performs all of the steps neccesary to put data on the clipboard.  It will allocate  the  global
;                  memory object, open the clipboard, place the data on the clipboard and close the clipboard.  If you need  more
;                  control over putting data on the clipboard, you may want to use the _Clip_SetDataEx function.
; Related .......: _Clip_GetData, _Clip_SetDataEx
; ===============================================================================================================================
Func _Clip_SetData($vData, $iFormat=1)
  Local $tData, $hLock, $hMemory, $iSize

  Switch $iFormat
    case $CF_TEXT, $CF_OEMTEXT
      $iSize = StringLen($vData) + 1
      $hMemory = _Mem_GlobalAlloc($iSize, $GHND)
      if $hMemory = 0 then Return SetError(-1, 0, 0)
      $hLock = _Mem_GlobalLock($hMemory)
      if $hLock = 0 then Return SetError(-2, 0, 0)
      $tData = DllStructCreate("char Text[" & $iSize & "]", $hLock)
      DllStructSetData($tData, "Text", $vData)
      _Mem_GlobalUnlock($hMemory)
    case else
      ; Assume all other formats are a pointer or a handle (until users tell me otherwise) :)
      $hMemory = $vData
  EndSwitch

  if not _Clip_Open(0) then Return SetError(-5, 0, 0)
  if not _Clip_Empty() then Return SetError(-6, 0, 0)
  if not _Clip_SetDataEx($hMemory, $iFormat) then
    _Clip_Close()
    Return SetError(-7, 0, 0)
  endif

  _Clip_Close()
  Return $hMemory
EndFunc

; #FUNCTION# ====================================================================================================================
; Description ...: Places data on the clipboard in a specified clipboard format
; Parameters ....: $hMemory     - Handle to the data in the specified format.  This parameter can be NULL,  indicating  that  the
;                  +window provides data in the specified clipboard format upon request.  If a window delays rendering,  it  must
;                  +process the $WM_RENDERFORMAT and $WM_RENDERALLFORMATS messages.  If this function succeeds, the  system  owns
;                  +the object identified by the $hMemory parameter.  The application may not write to  or  free  the  data  once
;                  +ownership has been transferred to the system, but it can lock and read from the data  until  the  _Clip_Close
;                  +function is called.  The memory must be unlocked before the clipboard is closed.  If the  $hMemory  parameter
;                  +identifies a memory object, the object must have been allocated using the function  with  the  $GMEM_MOVEABLE
;                  +flag.
;                  $iFormat     - Specifies a clipboard format:
;                  |CF_TEXT            - Text format
;                  |CF_BITMAP          - Handle to a bitmap (HBITMAP)
;                  |CF_METAFILEPICT    - Handle to a metafile picture (METAFILEPICT)
;                  |CF_SYLK            - Microsoft Symbolic Link (SYLK) format
;                  |CF_DIF             - Software Arts' Data Interchange Format
;                  |CF_TIFF            - Tagged image file format
;                  |CF_OEMTEXT         - Text format containing characters in the OEM character set
;                  |CF_DIB             - BITMAPINFO structure followed by the bitmap bits
;                  |CF_PALETTE         - Handle to a color palette
;                  |CF_PENDATA         - Data for the pen extensions to Pen Computing
;                  |CF_RIFF            - Represents audio data in RIFF format
;                  |CF_WAVE            - Represents audio data in WAVE format
;                  |CF_UNICODETEXT     - Unicode text format
;                  |CF_ENHMETAFILE     - Handle to an enhanced metafile (HENHMETAFILE)
;                  |CF_HDROP           - Handle to type HDROP that identifies a list of files
;                  |CF_LOCALE          - Handle to the locale identifier associated with text in the clipboard
;                  |CF_DIBV5           - BITMAPV5HEADER structure followed by bitmap color and the bitmap bits
;                  |CF_OWNERDISPLAY    - Owner display format
;                  |CF_DSPTEXT         - Text display format associated with a private format
;                  |CF_DSPBITMAP       - Bitmap display format associated with a private format
;                  |CF_DSPMETAFILEPICT - Metafile picture display format associated with a private format
;                  |CF_DSPENHMETAFILE  - Enhanced metafile display format associated with a private format
; Return values .: Success      - The handle to the data
;                  Failure      - 0
; Author ........: Paul Campbell (PaulIA)
; Remarks .......: The $iFormat parameter can identify a registered clipboard format, or it can be one of the standard  clipboard
;                  formats. If an application calls this function in response to $WM_RENDERFORMAT  or  $WM_RENDERALLFORMATS,  the
;                  application should not use the handle after this function has been called.  If an application calls _Clip_Open
;                  with a NULL handle, _Clip_Empty sets the clipboard owner to NULL; this causes this function to fail.
; Related .......: _Clip_Empty, _Clip_GetData, _Clip_Open
; ===============================================================================================================================
Func _Clip_SetDataEx(ByRef $hMemory, $iFormat=1)
  Local $aResult

  $aResult = DllCall("User32.dll", "int", "SetClipboardData", "int", $iFormat, "hwnd", $hMemory)
  Return SetError($aResult[0]=0, 0, $aResult[0])
EndFunc

; #FUNCTION# ====================================================================================================================
; Description ...: Adds the specified window to the chain of clipboard viewers
; Parameters ....: $hViewer     - Handle to the window to be added to the clipboard chain
; Return values .: Success      - The handle to the next window in the clipboard viewer chain
;                  Failure      - Zero if there is no clipboard viewer
; Author ........: Paul Campbell (PaulIA)
; Remarks .......: The windows that are part of the clipboard viewer chain must process the clipboard messages  $WM_CHANGECBCHAIN
;                  and $WM_DRAWCLIPBOARD. Each clipboard viewer window calls the _API_SendMessage function to pass these messages
;                  to the next window in the clipboard viewer chain. A clipboard viewer window must eventually remove itself from
;                  the clipboard viewer chain by calling the _Clip_ChangeChain function.
; Related .......: _Clip_ChangeChain, _Clip_GetViewer
; ===============================================================================================================================
Func _Clip_SetViewer($hViewer)
  Local $aResult

  $aResult = DllCall("User32.dll", "hwnd", "SetClipboardViewer", "hwnd", $hViewer)
  Return $aResult[0]
EndFunc

Opt("MustDeclareVars", 0)
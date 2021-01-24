#include-once
#Region UDF Header
;=================================================================================================
; FTD2XX.dll_UDF for use with the FTD2xx.dll
;=================================================================================================
; AutoIt Version:   3.3.0
; Language:   		English
; Platform:   		Win2K+
; Author:         	Neil Jensen (wakido;NBJ)
;=================================================================================================
; Requirements:  	FTD2XX.dll (http://www.ftdichip.com/FTDrivers.htm)
;					An FTD2XX Device for FT and USB functions
;					Any Modifications are posted on the AutoIt Forums
;=================================================================================================
; Credits:  		All of the AutoIT Community on the AutoIt Forums
;					brunomusw  & DanP2 in the topic http://www.autoitscript.com/forum/index.php?showtopic=63258
;					Nwfu in the topic http://www.autoitscript.com/forum/index.php?showtopic=28112&st=0
;					FTDI (www.ftdi.com)for the overwhelming documentation, samples and dll
;=================================================================================================
; References:  		http://www.ftdichip.com/FTDrivers.htm
;=================================================================================================
;
; ------------------------------
; FT Classic Interface Functions
; ------------------------------
; Notes:			The functions listed in this section are compatible with all FTDI devices.
;
; Functions:		_FT_CreateDeviceInfoList($lpdwNumDevs)
;					_FT_GetDeviceInfoList($pDest, $lpdwNumDevs)
;					_FT_GetDeviceInfoDetail($dwIndex, $lpdwFlags, $lpdwType, $lpdwID, $lpdwLocId, $pcSerialNumber, $pcDescription, $FT_HANDLE)
;					_FT_ListDevices($pvArg1, $pvArg2, $dwFlags)
;					_FT_Open($iDevice, $FT_HANDLE)
;					_FT_OpenEx($pvArg1, $dwFlags, $FT_HANDLE)
;					_FT_Close($FT_HANDLE)
;					_FT_Read($FT_HANDLE, $lpBuffer, $dwBytesToRead, $lpdwBytesReturned)
;					_FT_Write($FT_HANDLE, $lpBuffer, $dwBytesToWrite, $lpdwBytesWritten)
;					_FT_SetBaudRate($FT_HANDLE, $lngBaudRate)
;					_FT_SetDivisor ($FT_HANDLE , $usDivisor)
;					_FT_SetDataCharacteristics($FT_HANDLE, $uWordLength, $uStopBits, $uParity)
;					_FT_SetFlowControl($FT_HANDLE, $usFlowControl, $uXon, $uXoff)
;					_FT_SetDtr($FT_HANDLE)
;					_FT_ClrDtr($FT_HANDLE)
;					_FT_SetRts($FT_HANDLE)
;					_FT_ClrRts($FT_HANDLE)
;					_FT_GetModemStatus($FT_HANDLE, $lpdwModemStatus)
;					_FT_GetQueueStatus($FT_HANDLE, $lpdwAmountInRxQueue)
;					_FT_GetDeviceInfo ($FT_HANDLE, $pftType, $lpdwID, $pcSerialNumber,  $pcDescription,  $pvDummy)
;					_FT_GetDriverVersion ($FT_HANDLE, $lpdwDriverVersion)
;					_FT_GetLibraryVersion ($lpdwDLLVersion)
;					_FT_GetComPortNumber ($FT_HANDLE $lplComPortNumber)
;					_FT_GetStatus($FT_HANDLE, $lpdwAmountInRxQueue, $lpdwAmountInTxQueue, $lpdwEventStatus)
;					_FT_SetEventNotification($FT_HANDLE, $dwEventMask, $pvArg)
;					_FT_SetChars($FT_HANDLE, $uEventCh, $uEventChEn, $uErrorCh, $uErrorChEn)
;					_FT_SetBreakOn($FT_HANDLE)
;					_FT_SetBreakOff($FT_HANDLE)
;					_FT_Purge($FT_HANDLE, $dwMask)
;					_FT_ResetDevice($FT_HANDLE)
;					_FT_ResetPort($FT_HANDLE)
;					_FT_CyclePort($FT_HANDLE)
;					_FT_Rescan()
;					_FT_Reload ($wVID, $wPID)
;					_FT_SetResetPipeRetryCount ($FT_HANDLE,$dwCount)
;					_FT_StopInTask ($FT_HANDLE )
;					_FT_RestartInTask ($FT_HANDLE )
;					_FT_SetDeadmanTimeout ($FT_HANDLE ,  $dwDeadmanTimeout)
;
; -------------------------------
; FT EEPROM Programming Interface
; -------------------------------
; Notes: 			FTDI device EEPROMs can be both read and programmed using the functions listed in this section.
;
; Functions: 		_FT_ReadEE ($FT_HANDLE, $dwWordOffset, $lpwValue)
;					_FT_WriteEE($FT_HANDLE, $dwWordOffset, $wValue)
;					_FT_EraseEE($FT_HANDLE)
;					_FT_EE_Read (FT_HANDLE , $pData)
;					_FT_EE_ReadEx (FT_HANDLE , $pData,  $Manufacturer,  $ManufacturerId,  $Description,  $SerialNumber)
;					_FT_EE_Program (FT_HANDLE , $pData)
;					_FT_EE_ProgramEx (FT_HANDLE , $pData,  $Manufacturer,  $ManufacturerId,  $Description,  $SerialNumber)
;					_FT_EE_UASize (FT_HANDLE , $lpdwSize)
;					_FT_EE_UARead (FT_HANDLE , $pucData,  $dwDataLen,  $lpdwBytesRead)
;					_FT_EE_UAWrite (FT_HANDLE ,$pucData,  $dwDataLen)
;
; -------------------------
; FT Extended API Functions - Still to be completed
; -------------------------
; Notes:			The extended API functions do not apply to FT8U232AM or FT8U245AM devices.  FTDI’s other
;					USB-UART and USB-FIFO ICs (the FT2232H, FT4232H, FT232R, FT245R, FT2232, FT232B and
;					FT245B) do support these functions.  Note that there is device dependence in some of these functions.
;
; Functions:***		FT_SetLatencyTimer (FT_HANDLE ftHandle, UCHAR ucTimer)
;			***		FT_GetLatencyTimer (FT_HANDLE ftHandle, PUCHAR pucTimer)
;			***		FT_SetBitmode (FT_HANDLE ftHandle, UCHAR ucMask, UCHAR ucMode)
;			***		FT_GetBitmode (FT_HANDLE ftHandle, PUCHAR pucMode)
;			***		FT_SetUSBParameters (FT_HANDLE ftHandle, DWORD dwInTransferSize, DWORD dwOutTransferSize)
;			***
; ----------------------
; FT Win32 API Functions - Still to be completed
; ----------------------
; Notes:			The functions in this section are supplied to ease porting from a Win32 serial port application.
;					These functions are supported under non-Windows platforms to assist with porting existing
;					applications from Windows.  Note that classic D2XX functions and the Win32 D2XX functions
;					should not be mixed unless stated.
;
; Functions:***		FT_W32_CreateFile (PVOID pvArg1, DWORD dwAccess, DWORD dwShareMode, LPSECURITY_ATTRIBUTES lpSecurityAttributes, DWORD dwCreate, DWORD dwAttrsAndFlags, HANDLE hTemplate)
;			***		FT_W32_CloseHandle (FT_HANDLE ftHandle)
;			***		FT_W32_ReadFile (FT_HANDLE ftHandle, LPVOID lpBuffer, DWORD dwBytesToRead, LPDWORD lpdwBytesReturned, LPOVERLAPPED lpOverlapped)
;			***		FT_W32_WriteFile (FT_HANDLE ftHandle, LPVOID lpBuffer, DWORD dwBytesToWrite, LPDWORD lpdwBytesWritten, LPOVERLAPPED lpOverlapped)
;			***		FT_W32_GetOverlappedResult (FT_HANDLE ftHandle, LPOVERLAPPED lpOverlapped, LPDWORD lpdwBytesTransferred, BOOL bWait)
;			***		FT_W32_EscapeCommFunction (FT_HANDLE ftHandle, DWORD dwFunc)
;			***		FT_W32_GetCommModemStatus (FT_HANDLE ftHandle, LPDWORD lpdwStat)
;			***		FT_W32_SetupComm (FT_HANDLE ftHandle, DWORD dwReadBufferSize, DWORD dwWriteBufferSize)
;			***		FT_W32_SetCommState (FT_HANDLE ftHandle, LPFTDCB lpftDcb)
;			***		FT_W32_GetCommState (FT_HANDLE ftHandle, LPFTDCB lpftDcb)
;			***		FT_W32_SetCommTimeouts (FT_HANDLE ftHandle, LPFTTIMEOUTS lpftTimeouts)
;			***		FT_W32_GetCommTimeouts (FT_HANDLE ftHandle, LPFTTIMEOUTS lpftTimeouts)
;			***		FT_W32_SetCommBreak (FT_HANDLE ftHandle)
;			***		FT_W32_ClearCommBreak (FT_HANDLE ftHandle)
;			***		FT_W32_SetCommMask (FT_HANDLE ftHandle, DWORD dwMask)
;			***		FT_W32_GetCommMask (FT_HANDLE ftHandle, LPDWORD lpdwEventMask)
;			***		FT_W32_SetupComm (FT_HANDLE ftHandle, LPDWORD lpdwEvent, LPOVERLAPPED lpOverlapped)
;			***		FT_W32_PurgeComm (FT_HANDLE ftHandle, DWORD dwFlags)
;			***		FT_W32_GetLastError (FT_HANDLE ftHandle)
;			***		FT_W32_ClearCommError (FT_HANDLE ftHandle, LPDWORD lpdwErrors, LPFTCOMSTAT lpftComstat)
; ----------------------------------
; Error further information Function
; ----------------------------------
; Notes:			Function to return further information from the other Functions
; Functions:		_USBFT_ErrorDescription($i_Error)
;=================================================================================================
; Changelog:	V 0.0.1 	- Initial Release - Classic Interface and EEPROM sections done i think
;							- Issue with _FT_GetDeviceInfoDetail needs further assistance
;							- FT Extended API Functions - Still to be completed if call for it
; 							- FT Win32 API Functions - Still to be completed if call for it
;=================================================================================================
#EndRegion UDF Header


;
#Region Constants and Variables
#include-once
; #CONSTANTS# ;===============================================================================
; Flags for_FT_ListDevices
Const $FT_LIST_BY_NUMBER_ONLY = 0x80000000
Const $FT_LIST_BY_INDEX = 0x40000000
Const $FT_LIST_ALL = 0x20000000
; Flags for_FT_OpenEx
Const $FT_OPEN_BY_SERIAL_NUMBER = 1
Const $FT_OPEN_BY_DESCRIPTION = 2
Const $FT_OPEN_BY_LOCATION = 4
;Word Legnths
Const $FT_BITS_8 = 8
Const $FT_BITS_7 = 7
Const $FT_BITS_6 = 6
Const $FT_BITS_5 = 5
;Stop Bits
Const $FT_STOP_BITS_1 = 0
Const $FT_STOP_BITS_1_5 = 1
Const $FT_STOP_BITS_2 = 2
;Parity
Const $FT_PARITY_NONE = 0
Const $FT_PARITY_ODD = 1
Const $FT_PARITY_EVEN = 2
Const $FT_PARITY_MARK = 3
Const $FT_PARITY_SPACE = 4
;Purge
Const $FT_PURGE_RX = 1
Const $FT_PURGE_TX = 2
;Events
Const $FT_EVENT_RXCHAR = 1
Const $FT_EVENT_MODEM_STATUS = 2
;Flow Control
Const $FT_FLOW_NONE = 0x0000
Const $FT_FLOW_RTS_CTS = 0x0100
Const $FT_FLOW_DTR_DSR = 0x0200
Const $FT_FLOW_XON_XOFF = 0x0400

; #VARIABLES ;===============================================================================
;passed as Parameters
Global $v_Dll = DllOpen('FTD2xx.dll') ; open the DLL
Global $fthandle = DllStructCreate('DWORD') ; the dll struct to hold the handle to keep reusing
Global $FT_HANDLE = '' ; the handle to keep reusing
Global $lpdwNumDevs = DllStructCreate('dword') ; The number of Devices as returned and set
Global $pDest = DllStructCreate('DWORD Flags;DWORD Type;DWORD ID;DWORD LocId;char SerialNumber[16];char Description[64];DWORD ftHandle')
Global $dwIndex = ''; Index of the entry in the device info list
Global $lpdwFlags = DllStructCreate('ulong') ; unsigned long to store the flag value.
Global $lpdwType = DllStructCreate('ulong') ; unsigned long to store device type
Global $lpdwID = DllStructCreate('ulong') ; unsigned long to store device ID
Global $lpdwLocId = DllStructCreate('ulong') ; unsigned long to store the device location ID.
Global $pcSerialNumber = DllStructCreate('char[128]') ; buffer to store device serial number as a null-terminated string.
Global $pcDescription = DllStructCreate('char[128]') ; buffer to store device description as a null-terminated string.
Global $pvArg1 = '' ; varies!
Global $pvArg2 = '' ; varies!
Global $dwFlags = '' ; flags to return different information
Global $iDevice = '' ; the device you wish to interact with
Global $lpBuffer = DllStructCreate('char[128]') ; buffer that receives the data from the device. or to hold data to write to device
Global $dwBytesToRead = '' ;
Global $lpdwBytesReturned = DllStructCreate('DWORD') ; variable of type DWORD which receives the number of bytes read from the device.
Global $dwBytesToWrite = '' ; Variable to hold the Number of bytes to write to the device.
Global $lpdwBytesWritten = DllStructCreate('DWORD') ; variable of type DWORD which receives the number of bytes written to the device.
Global $dwMask = '' ; Mask for Purge Directives
Global $dwBaudRate = '' ; variable to set the Baud Rate
Global $usDivisor = '' ; varialbe to set the divisor
Global $uWordLength = '' ; variable to set the word legnth
Global $uStopBits = '' ; variable to set the stop bits
Global $uParity = '' ; variable to set the parity
Global $usFlowControl = '' ; variable to set the Flow Control
Global $uXon = '' ; Character used to signal Xon. Only used if flow control is $FT_FLOW_XON_XOFF.
Global $uXoff = '' ; Character used to signal Xoff. Only used if flow control is $FT_FLOW_XON_XOFF.
Global $lpdwModemStatus = DllStructCreate('DWORD') ; variable of type DWORD which receives the modem status and line status from the device.
Global $lpdwAmountInRxQueue = DllStructCreate('DWORD') ; variable of type DWORD which receives the number of bytes in the receive queue.
Global $pftType = DllStructCreate('ulong') ; unsigned long variable to store device type.
Global $pvDummy = '' ; Reserved for future use - should be set to NULL.
Global $lpdwDriverVersion = DllStructCreate('DWORD') ; DWORD variable to hold the driver version number.
Global $lpdwDLLVersion = DllStructCreate('DWORD') ; DWORD variable to hold the DLL version number.
Global $lplComPortNumber = DllStructCreate('LONG') ; variable of type LONG which receives the COM port	number associated with the device.
Global $lpdwAmountInTxQueue = DllStructCreate('DWORD') ; variable of type DWORD which receives the number of characters in the transmit queue.
Global $lpdwEventStatus = DllStructCreate('DWORD') ; variable of type DWORD which receives the current state of the event status.
Global $dwEventMask = '' ; variable for Conditions that cause the event to be set.
Global $pvArg = '' ; Interpreted as the handle of an event.
Global $uEventCh = '' ; Event character.
Global $uEventChEn = '' ; 0 if event character disabled, non-zero otherwise.
Global $uErrorCh = '' ; Error character.
Global $uErrorChEn = '' ; 0 if error character disabled, non-zero otherwise.
Global $wVID = '' ; Vendor ID of the devices to reload the driver for.
Global $wPID = '' ; Product ID of the devices to reload the driver for.
Global $dwCount = '' ; Unsigned long containing required ResetPipeRetryCount
Global $dwDeadmanTimeout = '' ; Deadman timeout value in milliseconds.  Default value is 5000.
;EEPROM VARIABLES
$dwWordOffset = '' ;EEPROM location to read from/write to.
$lpwValue = DllStructCreate('Ulong') ;variable of type WORD (value read from the EEPROM.)
$wValue = '' ; WORD value to write to the EEPROM.
$pData = '';	structure of type FT_PROGRAM_DATA. see documentation to create
$Manufacturer = DllStructCreate('char[128]') ; a null-terminated string containing the manufacturer name.
$ManufacturerId = DllStructCreate('char[128]') ; a null-terminated string containing the manufacturer ID
$Description = DllStructCreate('char[128]') ; a null-terminated string containing the device description.
$SerialNumber = DllStructCreate('char[128]') ; a null-terminated string containing the device serial Number.
$lpdwSize = DllStructCreate('DWORD') ;a DWORD that receives the available size, in bytes, of the EEPROM user area
$pucData = DllStructCreate('char[2000]') ;a buffer that contains storage for data to be read
$dwDataLen = '' ; Size, in bytes, of buffer that contains storage for the data to be read
$lpdwBytesRead = DllStructCreate('DWORD') ;a DWORD that receives the number of bytes read.




Local $i_Error = ''
#EndRegion Constants and Variables


#Region FT Classic Interface
;	|=======================================FT CLASSIC INTERFACE====================================================|
;	|										FT CLASSIC INTERFACE													|
;	|=======================================FT CLASSIC INTERFACE====================================================|

; #FUNCTION# ;===============================================================================
;
; Name...........:  _FT_CreateDeviceInfoList
; Description ...: 	This function builds a device information list and returns the number of D2XX devices
;					connected to the system.  The list contains information about both unopen and open devices.
;
; Syntax.........:  _FT_CreateDeviceInfoList($lpdwNumDevs)
;
; Parameters.....: 	$lpdwNumDevs      Pointer to unsigned long to store the number of devices connected.
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the Classic FTD2XX.dll interface
;						An application can use this function to get the number of devices attached to the system.  It
;						can then allocate space for the device information list and retrieve the list using
;						_FT_GetDeviceInfoList or _FT_GetDeviceInfoDetail.
;						If the devices connected to the system change, the device info list will not be updated until
;						_FT_CreateDeviceInfoList is called again.
; Related .......:
; Link ..........:
; Example .......:
; Original ......: FT_CreateDeviceInfoList (LPDWORD lpdwNumDevs)
;==========================================================================================
Func _FT_CreateDeviceInfoList($lpdwNumDevs)
	$v_Result = DllCall($v_Dll, 'long', 'FT_CreateDeviceInfoList', 'ptr', DllStructGetPtr($lpdwNumDevs))
	Return $v_Result[0]
EndFunc   ;==>_FT_CreateDeviceInfoList

; #FUNCTION# ;===============================================================================
;
; Name...........:  _FT_GetDeviceInfoList
; Description ...: 	This function returns a device information list and the number of D2XX devices in the list.
;
; Syntax.........:  _FT_GetDeviceInfoList( $pDest, $lpdwNumDevs)
;
; Parameters.....: 	$pDest        		Pointer to an array of FT_DEVICE_LIST_INFO_NODE structures.
;					$lpdwNumDevs     	Pointer to the number of elements in the array.
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the Classic FTD2XX.dll interface
;					This function should only be called after calling FT_CreateDeviceInfoList.
;					If the devices connected to the system change, the device info list will not be updated until
;					FT_CreateDeviceInfoList is called again.
;					Location ID information is not returned for devices that are open when FT_CreateDeviceInfoList is called.
;					Information is not available for devices which are open in other processes.
;					In this case, the Flags parameter of the FT_DEVICE_LIST_INFO_NODE will indicate that the device is open, but
;					other fields will be unpopulated.
;					The flag value is a 4-byte bit map containing miscellaneous data as defined Appendix A – Type
;					Definitions.  Bit 0 (least significant bit) of this number indicates if the port is open (1) or closed
;					(0).  Bit 1 indicates if the device is enumerated as a high-speed USB device (2) or a full-speed
;					USB device (0).  The remaining bits (2 - 31) are reserved.
;		Appendix A:	FT_FLAGS_OPENED = 0x00000001
;					FT_FLAGS_HISPEED = 0x00000002
;					The array of FT_DEVICE_LIST_INFO_NODES contains all available data on each device.  The
;					structure of FT_DEVICE_LIST_INFO_NODES is given in the Appendix.  The storage for the list
;					must be allocated by the application.  The number of devices returned by
;					FT_CreateDeviceInfoList can be used to do this.
;		Appendix:	FT_DEVICE_LIST_INFO_NODE (see FT_GetDeviceInfoList and FT_GetDeviceInfoDetail)
;						typedef struct _ft_device_list_info_node {
;						  DWORD Flags;
;						  DWORD Type;
;						  DWORD ID;
;						  DWORD LocId;
;						  char SerialNumber[16];
;						 char Description[64];
;						  FT_HANDLE ftHandle;
;						} FT_DEVICE_LIST_INFO_NODE;
;
;					When programming in Visual Basic, LabVIEW or similar languages, FT_GetDeviceInfoDetail
;					may be required instead of this function.
;					Please note that Linux, Mac OS X and Windows CE do not support location IDs.  As such, the
;					Location ID parameter in the structure will be empty under these operating systems.
; Related .......:
; Link ..........:
; Example .......:
; Original ......: FT_GetDeviceInfoList (FT_DEVICE_LIST_INFO_NODE *pDest, LPDWORD lpdwNumDevs)
;==========================================================================================
Func _FT_GetDeviceInfoList($pDest, $lpdwNumDevs)
	$v_Result = DllCall($v_Dll, 'long', 'FT_GetDeviceInfoList', 'ptr', DllStructGetPtr($pDest), 'ptr', DllStructGetPtr($lpdwNumDevs))
	Return $v_Result[0]
EndFunc   ;==>_FT_GetDeviceInfoList

; #FUNCTION# ;===============================================================================
;
; Name...........:  _FT_GetDeviceInfoDetail
; Description ...: 	This function returns an entry from the device information list.
;
; Syntax.........:  _FT_GetDeviceInfoDetail($dwIndex, $lpdwFlags, $lpdwType, $lpdwID, $lpdwLocId, $pcSerialNumber, $pcDescription, $FT_HANDLE)
;
; Parameters.....: 	$dwIndex		Index of the entry in the device info list.
;					$lpdwFlags		Pointer to unsigned long to store the flag value.
;					$lpdwType		Pointer to unsigned long to store device type.
;					$lpdwID			Pointer to unsigned long to store device ID.
;					$lpdwLocId		Pointer to unsigned long to store the device location ID.
;					$pcSerialNumber	Pointer to buffer to store device serial number as a null-terminated string.
;					$pcDescription	Pointer to buffer to store device description as a null-terminated string.
;					$FT_HANDLE		Pointer to a variable of type FT_HANDLE where the handle will be stored.
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the Classic FTD2XX.dll interface
;					This function should only be called after calling FT_CreateDeviceInfoList.  If the devices
;					connected to the system change, the device info list will not be updated until
;					FT_CreateDeviceInfoList is called again.
;					The index value is zero-based.
;					The flag value is a 4-byte bit map containing miscellaneous data as defined Appendix A – Type
;					Definitions.  Bit 0 (least significant bit) of this number indicates if the port is open (1) or closed
;					(0).  Bit 1 indicates if the device is enumerated as a high-speed USB device (2) or a full-speed
;					USB device (0).  The remaining bits (2 - 31) are reserved.
;					Location ID information is not returned for devices that are open when
;					FT_CreateDeviceInfoList is called.
;					Information is not available for devices which are open in other processes.  In this case, the
;					lpdwFlags parameter will indicate that the device is open, but other fields will be unpopulated.
;					To return the whole device info list as an array of FT_DEVICE_LIST_INFO_NODE structures,
;					use FT_CreateDeviceInfoList.
;					Please note that Linux, Mac OS X and Windows CE do not support location IDs.  As such, the
;					Location ID parameter in the structure will be empty under these operating systems.
; Related .......:
; Link ..........:
; Example .......:
; Original ......: FT_GetDeviceInfoDetail (DWORD dwIndex, LPDWORD lpdwFlags,  LPDWORD lpdwType, LPDWORD lpdwID, LPDWORD lpdwLocId, PCHAR pcSerialNumber, PCHAR pcDescription, FT_HANDLE *ftHandle)
;==========================================================================================
Func _FT_GetDeviceInfoDetail($dwIndex, $lpdwFlags, $lpdwType, $lpdwID, $lpdwLocId, $pcSerialNumber, $pcDescription, $FT_HANDLE)
	$v_Result = DllCall($v_Dll, 'long', 'FT_GetDeviceInfoList', 'DWORD', $dwIndex, 'ptr', DllStructGetPtr($lpdwFlags), 'ptr', DllStructGetPtr($lpdwType), 'ptr', DllStructGetPtr($lpdwID), 'ptr', DllStructGetPtr($lpdwLocId), 'ptr', DllStructGetPtr($pcSerialNumber), 'ptr', DllStructGetPtr($pcDescription), 'ptr', DllStructGetPtr($fthandle))
	$FT_HANDLE = DllStructGetData($fthandle, 1)
	Return $v_Result[0]
EndFunc   ;==>_FT_GetDeviceInfoDetail

; #FUNCTION# ;===============================================================================
;
; Name...........: _FT_ListDevices
; Description ...: 	Gets information concerning the devices currently connected.  This function can return
;					information such as the number of devices connected, the device serial number and device
;					description strings, and the location IDs of connected devices.
;
; Syntax.........: _FT_ListDevices($pvArg1, $pvArg2, $dwFlags)
;
; Parameters ....: 	$pvArg1			Meaning depends on $dwFlags
;					$pvArg2			Meaning depends on $dwFlags
;					$dwFlags		Determines format of returned information.
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the Classic FTD2XX.dll interface
;					This function can be used in a number of ways to return different types of information.
;					A more powerful way to get device information is to use the _FT_CreateDeviceInfoList(),
;					_FT_GetDeviceInfoList() and _FT_GetDeviceInfoDetail() functions as they return all the available
;					information on devices.
;					In its simplest form, it can be used to return the number of devices currently connected.
;					If $FT_LIST_NUMBER_ONLY bit is set in $dwFlags, the parameter $pvArg1 is interpreted as a pointer
;					to a DWORD location to store the number of devices currently connected.
;					It can be used to return device information:
;						if $FT_OPEN_BY_SERIAL_NUMBER bit is set in $dwFlags, the serial number string will be returned;
;						if $FT_OPEN_BY_DESCRIPTION bit is set in $dwFlags, the product description string will be returned;
;						if $FT_OPEN_BY_LOCATION bit is set in $dwFlags, the Location ID will be returned;
;						if none of these bits is set, the serial number string will be returned by default.
;					It can be used to return device string information for a single device.
;						If $FT_LIST_BY_INDEX and $FT_OPEN_BY_SERIAL_NUMBER or $FT_OPEN_BY_DESCRIPTION bits are set in $dwFlags,
;					the	parameter $pvArg1 is interpreted as the index of the device, and the parameter $pvArg2 is
;					interpreted as a pointer to a buffer to contain the appropriate string.  Indexes are zero-based,
;					and the error code 2 (FT_DEVICE_NOT_FOUND) is returned for an invalid index.
;					It can be used to return device string information for all connected devices.  If FT_LIST_ALL
;					and $FT_OPEN_BY_SERIAL_NUMBER or $FT_OPEN_BY_DESCRIPTION bits are set in $dwFlags, the
;					parameter $pvArg1 is interpreted as a pointer to an array of pointers to buffers to contain the
;					appropriate strings and the parameter $pvArg2 is interpreted as a pointer to a DWORD location
;					to store the number of devices currently connected.  Note that, for $pvArg1, the last entry in
;					the array of pointers to buffers should be a NULL pointer so the array will contain one more
;					location than the number of devices connected.
;					The location ID of a device is returned if $FT_LIST_BY_INDEX and $FT_OPEN_BY_LOCATION bits
;					are set in $dwFlags.  In this case the parameter $pvArg1 is interpreted as the index of the
;					device, and the parameter $pvArg2 is interpreted as a pointer to a variable of type long to
;					contain the location ID.  Indexes are zero-based, and the error code 2 (FT_DEVICE_NOT_FOUND)
;					is returned for an invalid index.  Please note that Windows CE and Linux do not support
;					location IDs.
;					The location IDs of all connected devices are returned if $FT_LIST_ALL and
;					$FT_OPEN_BY_LOCATION bits are set in $dwFlags.  In this case, the parameter $pvArg1 is
;					interpreted as a pointer to an array of variables of type long to contain the location IDs, and
;					the parameter $pvArg2 is interpreted as a pointer to a DWORD location to store the number of
;					devices currently connected.
; Related .......:
; Link ..........;
; Example .......;
; Original ......; FT_ListDevices (PVOID pvArg1, PVOID pvArg2, DWORD dwFlags)
;==========================================================================================
Func _FT_ListDevices($pvArg1, $pvArg2, $dwFlags)
	If $dwFlags = BitOR($FT_LIST_BY_INDEX, $FT_OPEN_BY_DESCRIPTION) Or $dwFlags = BitOR($FT_LIST_BY_INDEX, $FT_OPEN_BY_SERIAL_NUMBER) Then
		$_result = DllCall('ftd2xx.dll', 'long', 'FT_ListDevices', 'dword', $pvArg1, 'ptr', DllStructGetPtr($pvArg2), 'DWORD', $dwFlags)
		ConsoleWrite(@CR & '--- BitOr dwflags ---')
	Else
		$_result = DllCall('ftd2xx.dll', 'long', 'FT_ListDevices', 'ptr', DllStructGetPtr($pvArg1), 'ptr', DllStructGetPtr($pvArg2), 'DWORD', $dwFlags)
	EndIf
	Return $_result[0]
EndFunc   ;==>_FT_ListDevices

; #FUNCTION# ;===============================================================================
;
; Name...........: _FT_Open
; Description ...: 	Open the device and return a handle which will be used for subsequent accesses.
;
; Syntax.........: _FT_Open($iDevice, $FT_HANDLE)
;
; Parameters.....: 	iDevice			Index of the device to open.  Indices are 0 based.
;					$FT_HANDLE		Pointer to a dllstruct of type long where the handle will be
;									stored.  This handle must be used to access the device.
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the Classic FTD2XX.dll interface
;						Although this function can be used to open multiple devices by setting iDevice to 0, 1, 2 etc.
;						there is no ability to open a specific device.  To open named devices, use the function
;						FT_OpenEx.
; Related .......:
; Link ..........:
; Example .......:
; Original ......: FT_Open (int iDevice, FT_HANDLE *ftHandle)
;==========================================================================================
Func _FT_Open($iDevice, $fthandle)
	$v_Result = DllCall($v_Dll, 'long', 'FT_Open', 'int', $iDevice, 'ptr', DllStructGetPtr($fthandle))
	$FT_HANDLE = DllStructGetData($fthandle, 1)
	Return $v_Result[0]
EndFunc   ;==>_FT_Open

; #FUNCTION# ;===============================================================================
;
; Name...........: _FT_OpenEx
; Description ...: 	Open the specified device and return a handle that will be used for subsequent accesses.  The
;					device can be specified by its serial number, device description or location.
;					This function can also be used to open multiple devices simultaneously.  Multiple devices can
;					be specified by serial number, device description or location ID (location information derived
;					from the physical location of a device on USB).  Location IDs for specific USB ports can be
;					obtained using the utility USBView and are given in hexadecimal format.  Location IDs for
;					devices connected to a system can be obtained by calling FT_GetDeviceInfoList or
;					FT_ListDevices with the appropriate flags.
;
; Syntax.........: _FT_OpenEx($pvArg1, $dwFlags, $FT_HANDLE)
;
; Parameters.....: 	$pvArg1			Pointer to an argument whose type depends on the value of
;									dwFlags.  It is normally be interpreted as a pointer to a null
;									terminated string.
;				   	$dwFlags		FT_OPEN_BY_SERIAL_NUMBER, FT_OPEN_BY_DESCRIPTION or
;									FT_OPEN_BY_LOCATION.
;					$FT_HANDLE		Pointer to a dllstruct of type long where the handle will be
;									stored.  This handle must be used to access the device.
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the Classic FTD2XX.dll interface
;					The parameter specified in $pvArg1 depends on $dwFlags: if $dwFlags is
;					$FT_OPEN_BY_SERIAL_NUMBER, $pvArg1 is interpreted as a  pointer to a null-terminated string
;					that represents the serial number of the device;  if $dwFlags is $FT_OPEN_BY_DESCRIPTION,
;					$pvArg1 is interpreted as a  pointer to a null-terminated string that represents the device
;					description;  if $dwFlags is $FT_OPEN_BY_LOCATION, $pvArg1 is interpreted as a long value that
;					contains the location ID of the device.
;					Please note that Windows CE does not support location IDs.
; Related .......:
; Link ..........:
; Example .......:
; Original ......: FT_OpenEx (PVOID pvArg1, DWORD dwFlags, FT_HANDLE *ftHandle)
;==========================================================================================
Func _FT_OpenEx($pvArg1, $dwFlags, $FT_HANDLE)
	If $dwFlags = $FT_OPEN_BY_LOCATION Then
		$v_Result = DllCall($v_Dll, 'long', 'FT_OpenEx', 'long', $pvArg1, 'DWORD', $dwFlags, 'ptr', DllStructGetPtr($fthandle, 1))
	Else
		$v_Result = DllCall($v_Dll, 'long', 'FT_OpenEx', 'ptr', $pvArg1, 'DWORD', $dwFlags, 'ptr', DllStructGetPtr($fthandle, 1))
	EndIf
	$FT_HANDLE = DllStructGetData($fthandle, 1)
	Return $v_Result[0]
EndFunc   ;==>_FT_OpenEx

; #FUNCTION# ;===============================================================================
;
; Name...........: _FT_Close
; Description ...: 	Close an open device
;
; Syntax.........: _FT_Close($FT_HANDLE)
;
; Parameters.....: 	$FT_HANDLE	Handle of the Device to close
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the Classic FTD2XX.dll interface
; Related .......:
; Link ..........:
; Example .......:
; Original ......: FT_Close (FT_HANDLE ftHandle)
;==========================================================================================
Func _FT_Close($FT_HANDLE)
	$v_Result = DllCall($v_Dll, 'long', 'FT_Close', 'ptr', $FT_HANDLE)
	Return $v_Result[0]
EndFunc   ;==>_FT_Close

; #FUNCTION# ;===============================================================================
;
; Name...........: _FT_Read
; Description ...: 	Read data from the device
;
; Syntax.........: _FT_Read($FT_HANDLE, $lpBuffer, $dwBytesToRead, $lpdwBytesReturned)
;
; Parameters.....: 	$FT_HANDLE     		Handle of the device.
;					$lpBuffer     		Pointer to the buffer that receives the data from the device.
;					$dwBytesToRead     	Number of bytes to be read from the device.
;					$lpdwBytesReturned	Pointer to a variable of type DWORD which receives the number of
;										bytes read from the device.
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the Classic FTD2XX.dll interface
;						FT_Read always returns the number of bytes read in $lpdwBytesReturned.
;						This function does not return until d$wBytesToRead bytes have been read into the buffer.  The
;						number of bytes in the receive queue can be determined by calling FT_GetStatus or
;						FT_GetQueueStatus, and passed to FT_Read as $dwBytesToRead so that the function reads the
;						device and returns immediately.
;						When a read timeout value has been specified in a previous call to FT_SetTimeouts, FT_Read
;						returns when the timer expires or $dwBytesToRead have been read, whichever occurs first.  If
;						the timeout occurred, FT_Read reads available data into the buffer and returns 0 (FT_OK).
;						An application should use the function return value and $lpdwBytesReturned when processing
;						the buffer.  If the return value is 0 (FT_OK), and $lpdwBytesReturned is equal to $dwBytesToRead
;						then FT_Read has completed normally.  If the return value is FT_OK, and $lpdwBytesReturned
;						is less then $dwBytesToRead then a timeout has occurred and the read has been partially
;						completed.  Note that if a timeout occurred and no data was read, the return value is still
;						0 (FT_OK).
;						A return value of 4 (FT_IO_ERROR) suggests an error in the parameters of the function, or a fatal
;						error like a USB disconnect has occurred
; Related .......:
; Link ..........:
; Example .......:
; Original ......: FT_Read (FT_HANDLE ftHandle, LPVOID lpBuffer, DWORD dwBytesToRead, LPDWORD lpdwBytesReturned)
;==========================================================================================
Func _FT_Read($FT_HANDLE, $lpBuffer, $dwBytesToRead, $lpdwBytesReturned)
	$v_Result = DllCall($v_Dll, 'long', 'FT_Read', 'ptr', $FT_HANDLE, 'ptr', DllStructGetPtr($lpBuffer), 'DWORD', $dwBytesToRead, 'ptr', DllStructGetPtr($lpdwBytesReturned))
EndFunc   ;==>_FT_Read

; #FUNCTION# ;===============================================================================
;
; Name...........: _FT_Write
; Description ...: 	Write data to the device
;
; Syntax.........: _FT_Write($FT_HANDLE, $lpBuffer, $dwBytesToWrite, $lpdwBytesWritten)
;
; Parameters.....: 	$FT_HANDLE			Handle of the device.
;					$lpBuffer			Pointer to the buffer that contains the data to be written to the device.
;					$dwBytesToWrite		Number of bytes to write to the device.
;					$lpdwBytesWritten	Pointer to a variable of type DWORD which receives the number of
;					   					bytes written to the device.
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the Classic FTD2XX.dll interface
; Related .......:
; Link ..........:
; Example .......:
; Original ......: FT_Write (FT_HANDLE ftHandle, LPVOID lpBuffer, DWORD dwBytesToWrite, LPDWORD lpdwBytesWritten)
;==========================================================================================
Func _FT_Write($FT_HANDLE, $lpBuffer, $dwBytesToWrite, $lpdwBytesWritten)
	$v_Result = DllCall($v_Dll, 'long', 'FT_Write', 'ptr', $FT_HANDLE, 'ptr', DllStructGetPtr($lpBuffer), 'DWORD', $dwBytesToWrite, 'ptr', DllStructGetPtr($lpdwBytesWritten))
	Return $v_Result[0]
EndFunc   ;==>_FT_Write

; #FUNCTION# ;===============================================================================
;
; Name...........: _FT_SetBaudRate
; Description ...: 	This function sets the baud rate for the device.
;
; Syntax.........: _FT_SetBaudRate($FT_HANDLE, $dwBaudRate)
;
; Parameters.....: 	$FT_HANDLE      	Handle of the device.
;					$dwBaudRate    		Baud rate
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the Classic FTD2XX.dll interface
; Related .......:
; Link ..........:
; Example .......:
; Original ......: FT_SetBaudRate (FT_HANDLE ftHandle, DWORD dwBaudRate)
;==========================================================================================
Func _FT_SetBaudRate($FT_HANDLE, $dwBaudRate)
	$v_Result = DllCall($v_Dll, 'long', 'FT_SetBaudRate', 'ptr', $FT_HANDLE, 'DWORD', $dwBaudRate)
	Return $v_Result[0]
EndFunc   ;==>_FT_SetBaudRate

; #FUNCTION# ;===============================================================================
;
; Name...........: _FT_SetDivisor
; Description ...: 	This function sets the baud rate for the device.  It is used to set non-standard baud rates.
;
; Syntax.........: _FT_SetBaudRate($FT_HANDLE, $usDivisor)
;
; Parameters.....: 	$FT_HANDLE      	Handle of the device.
;					$usDivisor    		Divisor
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the Classic FTD2XX.dll interface
;						This function is no longer required as FT_SetBaudRate will now automatically calculate the
;						required divisor for a requested baud rate.  The application note "Setting baud rates for the
;						FT8U232AM" is available from the Application Notes section of the FTDI website describes how
;						to calculate the divisor for a non-standard baud rate.
; Related .......:
; Link ..........:
; Example .......:
; Original ......:FT_SetDivisor (FT_HANDLE ftHandle, USHORT usDivisor)
;==========================================================================================
Func _FT_SetDivisor($FT_HANDLE, $usDivisor)
	$v_Result = DllCall($v_Dll, 'long', 'FT_SetDivisor', 'ptr', $FT_HANDLE, 'ushort', $usDivisor)
	Return $v_Result[0]
EndFunc   ;==>_FT_SetDivisor

; #FUNCTION# ;===============================================================================
;
; Name...........: _FT_SetDataCharacteristics
; Description ...: 	This function sets the data characteristics for the device.
;
; Syntax.........: _FT_SetDataCharacteristics ($FT_HANDLE, $uWordLength, $uStopBits, $uParity)
;
; Parameters.....: 	$FT_HANDLE		Handle of the device.
;					$uWordLength	Number of bits per word - must be one of:
;									|$FT_BITS_8 		(8)
;									|$FT_BITS_7 		(7)
;					$uStopBits		Number of stop bits - must be one of:
;									|$FT_STOP_BITS_1 	(0)
;									|$FT_STOP_BITS_1_5 	(1)
;									|$FT_STOP_BITS_2 	(2)
;					$uParity		Parity - must be one of:
;									|$FT_PARITY_NONE 	(0)
;									|$FT_PARITY_ODD  	(1)
;									|$FT_PARITY_EVEN 	(2)
;									|$FT_PARITY_MARK 	(3)
;									|$FT_PARITY SPACE 	(4)
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the Classic FTD2XX.dll interface
; Related .......:
; Link ..........:
; Example .......:
; Original ......: FT_SetDataCharacteristics (FT_HANDLE ftHandle, UCHAR uWordLength, UCHAR uStopBits, UCHAR uParity)
;==========================================================================================
Func _FT_SetDataCharacteristics($FT_HANDLE, $uWordLength, $uStopBits, $uParity)
	$v_Result = DllCall($v_Dll, 'long', 'FT_SetDataCharacteristics', 'ptr', $FT_HANDLE, 'byte', $uWordLength, 'byte', $uStopBits, 'byte', $uParity)
	Return $v_Result[0]
EndFunc   ;==>_FT_SetDataCharacteristics

; #FUNCTION# ;===============================================================================
;
; Name...........:  _FT_SetTimeouts
; Description ...: 	This function sets the read and write timeouts for the device
;
; Syntax.........: _FT_SetTimeouts($FT_HANDLE, $dwReadTimeout, $dwWriteTimeout)
;
; Parameters.....: 	$FT_HANDLE			Handle of the device.
;					$dwReadTimeout		Read timeout in milliseconds.
;					$dwWriteTimeout		Write timeout in milliseconds.
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the Classic FTD2XX.dll interface
; Related .......:
; Link ..........:
; Example .......:
; Original ......: FT_SetTimeouts (FT_HANDLE ftHandle, DWORD dwReadTimeout, DWORD dwWriteTimeout)
;==========================================================================================
Func _FT_SetTimeouts($FT_HANDLE, $dwReadTimeout, $dwWriteTimeout)
	$v_Result = DllCall($v_Dll, 'long', '_FT_SetTimeouts', 'ptr', $FT_HANDLE, 'DWORD', $dwReadTimeout, 'DWORD', $dwWriteTimeout)
	Return $v_Result[0]
EndFunc   ;==>_FT_SetTimeouts

; #FUNCTION# ;===============================================================================
;
; Name...........: _FT_SetFlowControl
; Description ...: 	This function sets the flow control for the device.
;
; Syntax.........: FT_SetFlowControl ($FT_HANDLE , $usFlowControl, $uXon, $uXoff)
;
; Parameters.....: 	$FT_HANDLE		Handle of the device.
;					$usFlowControl	Flow Control - must be one of:
;									|$FT_FLOW_NONE		(0x0000)
;									|$FT_FLOW_RTS_CTS	(0x0100)
;									|$FT_FLOW_DTR_DSR	(0x0200)
;									|$FT_FLOW_XON_XOFF	(0x0400)
;					$uXon			Character used to signal Xon. Only used if flow control is $FT_FLOW_XON_XOFF.
;					$uXoff			Character used to signal Xoff. Only used if flow control is $FT_FLOW_XON_XOFF.
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the Classic FTD2XX.dll interface
; Related .......:
; Link ..........:
; Example .......:
; Original ......:FT_SetFlowControl (FT_HANDLE ftHandle, USHORT usFlowControl, UCHAR uXon, UCHAR uXoff)
;==========================================================================================
Func _FT_SetFlowControl($FT_HANDLE, $usFlowControl, $uXon, $uXoff)
	$v_Result = DllCall($v_Dll, 'long', 'FT_SetFlowControl', 'ptr', $FT_HANDLE, 'ushort', $usFlowControl, 'str', $uXon, 'str', $uXoff)
	Return $v_Result[0]
EndFunc   ;==>_FT_SetFlowControl

; #FUNCTION# ;===============================================================================
;
; Name...........: _FT_SetDtr
; Description ...: 	This function sets the Data Terminal Ready (DTR) control signal.
;
; Syntax.........: _FT_SetDtr($FT_HANDLE)
;
; Parameters.....: 	$FT_HANDLE		Handle of the device.
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the Classic FTD2XX.dll interface
; Related .......:
; Link ..........:
; Example .......:
; Original ......: FT_SetDtr (FT_HANDLE ftHandle)
;==========================================================================================
Func _FT_SetDtr($FT_HANDLE)
	$v_Result = DllCall($v_Dll, 'long', 'FT_SetDtr', 'ptr', $FT_HANDLE)
	Return $v_Result[0]
EndFunc   ;==>_FT_SetDtr

; #FUNCTION# ;===============================================================================
;
; Name...........: FT_ClrDtr
; Description ...: 	This function clears the Data Terminal Ready (DTR) control signal
;
; Syntax.........: _FT_ClrDtr($FT_HANDLE)
;
; Parameters.....: 	$FT_HANDLE		Handle of the device.
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the Classic FTD2XX.dll interface
;					This function de-asserts the Data Terminal Ready (DTR) line of the device.
; Related .......:
; Link ..........:
; Example .......:
; Original ......:FT_ClrDtr (FT_HANDLE ftHandle)
;==========================================================================================
Func _FT_ClrDtr($FT_HANDLE)
	$v_Result = DllCall($v_Dll, 'long', 'FT_ClrDtr', 'ptr', $FT_HANDLE)
	Return $v_Result[0]
EndFunc   ;==>_FT_ClrDtr

; #FUNCTION# ;===============================================================================
;
; Name...........: _FT_SetRts
; Description ...: 	This function sets the Request To Send (RTS) control signal
;
; Syntax.........: _FT_SetRts($FT_HANDLE)
;
; Parameters.....: 	$FT_HANDLE		Handle of the device.
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the Classic FTD2XX.dll interface
;					This function asserts the Request To Send (RTS) line of the device.
; Related .......:
; Link ..........:
; Example .......:
; Original ......: FT_SetRts (FT_HANDLE ftHandle)
;==========================================================================================
Func _FT_SetRts($FT_HANDLE)
	$v_Result = DllCall($v_Dll, 'long', 'FT_SetRts', 'ptr', $FT_HANDLE)
	Return $v_Result[0]
EndFunc   ;==>_FT_SetRts

; #FUNCTION# ;===============================================================================
;
; Name...........: _FT_ClrRts
; Description ...: 	This function clears the Request To Send (RTS) control signal
;
; Syntax.........: _FT_ClrRts($FT_HANDLE)
;
; Parameters.....: 	$FT_HANDLE		Handle of the device.
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the Classic FTD2XX.dll interface
;					This function asserts the Request To Send (RTS) line of the device.
; Related .......:
; Link ..........:
; Example .......:
; Original ......: FT_ClrRts (FT_HANDLE ftHandle)
;==========================================================================================
Func _FT_ClrRts($FT_HANDLE)
	$v_Result = DllCall($v_Dll, 'long', 'FT_ClrRts', 'ptr', $FT_HANDLE)
	Return $v_Result[0]
EndFunc   ;==>_FT_ClrRts

; #FUNCTION# ;===============================================================================
;
; Name...........: _FT_GetModemStatus
; Description ...: 	Gets the modem status and line status from the device.
;
; Syntax.........: _FT_GetModemStatus($FT_HANDLE, $lpdwModemStatus)
;
; Parameters.....: 	$FT_HANDLE			Handle of the device.
;					$lpdwModemStatus    Pointer to a variable of type DWORD which receives the modem
;										status and line status from the device.
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the Classic FTD2XX.dll interface
;						The least significant byte of the lpdwModemStatus value holds the modem status.  On
;						Windows and Windows CE, the line status is held in the second least significant byte of the
;						lpdwModemStatus value.
;						The modem status is bit-mapped as follows: Clear To Send (CTS) = 0x10, Data Set Ready
;						(DSR) = 0x20, Ring Indicator (RI) = 0x40, Data Carrier Detect (DCD) = 0x80.
;						The line status is bit-mapped as follows: Overrun Error (OE) = 0x02, Parity Error (PE) = 0x04,
;						Framing Error (FE) = 0x08, Break Interrupt (BI) = 0x10.
; Related .......:
; Link ..........:
; Example .......:
; Original ......: FT_GetModemStatus (FT_HANDLE ftHandle, LPDWORD lpdwModemStatus)
;==========================================================================================
Func _FT_GetModemStatus($FT_HANDLE, $lpdwModemStatus)
	$v_Result = DllCall($v_Dll, 'long', 'FT_GetModemStatus', 'ptr', $FT_HANDLE, 'ptr', DllStructGetPtr($lpdwModemStatus))
	Return $v_Result[0]
EndFunc   ;==>_FT_GetModemStatus

; #FUNCTION# ;===============================================================================
;
; Name...........:  _FT_GetQueueStatus
; Description ...: 	Gets the number of bytes in the receive queue.
;
; Syntax.........: _FT_GetQueueStatus($FT_HANDLE, $lpdwAmountInRxQueue)
;
; Parameters.....: 	$FT_HANDLE				Handle of the device.
;					$lpdwAmountInRxQueue	Pointer to a variable of type DWORD which receives the number of
;											bytes in the receive queue.
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the Classic FTD2XX.dll interface
; Related .......:
; Link ..........:
; Example .......:
; Original ......:  FT_GetQueueStatus (FT_HANDLE ftHandle, LPDWORD lpdwAmountInRxQueue)
;==========================================================================================
Func _FT_GetQueueStatus($FT_HANDLE, $lpdwAmountInRxQueue)
	$v_Result = DllCall($v_Dll, 'long', 'FT_GetQueueStatus', 'ptr', $FT_HANDLE, 'ptr', DllStructGetPtr($lpdwAmountInRxQueue))
	Return $v_Result[0]
EndFunc   ;==>_FT_GetQueueStatus

; #FUNCTION# ;===============================================================================
;
; Name...........:  _FT_GetDeviceInfo
; Description ...: 	Get device information for an open device.
;
; Syntax.........: _FT_GetDeviceInfo ($FT_HANDLE, $pftType, $lpdwID, $pcSerialNumber,  $pcDescription,  $pvDummy)
;
; Parameters.....: 	$FT_HANDLE				Handle of the device.
;					$pftType				Pointer to unsigned long to store device type.
;					$lpdwID					Pointer to unsigned long to store device ID.
;					$pcSerialNumber			Pointer to buffer to store device serial number as a null-terminated  string.
;					$pcDescription			Pointer to buffer to store device description as a null-terminated string.
;					$pvDummy				Reserved for future use - should be set to NULL.
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the Classic FTD2XX.dll interface
;						This function is used to return the device type, device ID, device description and serial number.
;						The device ID is encoded in a DWORD - the most significant word contains the vendor ID, and
;						the least significant word contains the product ID.  So the returned ID 0x04036001
;						corresponds to the device ID VID_0403&PID_6001.
; Related .......:
; Link ..........:
; Example .......:
; Original ......:  FT_GetDeviceInfo (FT_HANDLE ftHandle, FT_DEVICE *pftType, LPDWORD lpdwID, PCHAR pcSerialNumber, PCHAR pcDescription, PVOID pvDummy)
;==========================================================================================
Func _FT_GetDeviceInfo($FT_HANDLE, $pftType, $lpdwID, $pcSerialNumber, $pcDescription, $pvDummy)
	$v_Result = DllCall($v_Dll, 'long', 'FT_GetDeviceInfo', 'ptr', $FT_HANDLE, 'ptr', DllStructGetPtr($pftType), "ptr", DllStructGetPtr($lpdwID), 'ptr', DllStructGetPtr($pcSerialNumber), 'ptr', DllStructGetPtr($pcDescription), 'ptr', 0)
	Return $v_Result[0]
EndFunc   ;==>_FT_GetDeviceInfo

; #FUNCTION# ;===============================================================================
;
; Name...........:  _FT_GetDriverVersion
; Description ...: 	Gets the device status including number of characters in the receive queue, number of
;					characters in the transmit queue, and the current event status.
;
; Syntax.........:  _FT_GetDriverVersion($FT_HANDLE, $lpdwAmountInRxQueue, $lpdwAmountInTxQueue, $lpdwEventStatus)
;
; Parameters.....: 	$FT_HANDLE				Handle of the device.
;					$lpdwDriverVersion 		Pointer to DWORD (the driver version number).
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the Classic FTD2XX.dll interface
; Related .......:
; Link ..........:
; Example .......:
; Original ......:	 FT_GetDriverVersion (FT_HANDLE ftHandle, LPDWORD lpdwDriverVersion)
;==========================================================================================
Func _FT_GetDriverVersion($FT_HANDLE, $lpdwDriverVersion)
	$v_Result = DllCall($v_Dll, 'long', 'FT_GetDriverVersion', 'ptr', $FT_HANDLE, 'ptr', DllStructGetPtr($lpdwDriverVersion))
	Return $v_Result[0]
EndFunc   ;==>_FT_GetDriverVersion

; #FUNCTION# ;===============================================================================
;
; Name...........:  _FT_GetLibraryVersion
; Description ...: 	This function returns D2XX DLL version number.
;
; Syntax.........:  _FT_GetLibraryVersion($lpdwDLLVersion)
;
; Parameters.....: 	$lpdwDLLVersion				Pointer to the DLL version number.
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the Classic FTD2XX.dll interface
;						A version number consists of major, minor and build version numbers contained in a 4-byte
;						field (unsigned long).  Byte0 (least significant) holds the build version, Byte1 holds the minor
;						version, and Byte2 holds the major version.  Byte3 is currently set to zero.
;						For example, D2XX DLL version "3.01.15" is represented as 0x00030115.  Note that this
;						function does not take a handle, and so it can be called without opening a device.
; Related .......:
; Link ..........:
; Example .......:
; Original ......:	 FT_GetLibraryVersion (LPDWORD lpdwDLLVersion)
;==========================================================================================
Func _FT_GetLibraryVersion($lpdwDLLVersion)
	$v_Result = DllCall($v_Dll, 'long', 'FT_GetLibraryVersion', 'ptr', DllStructGetPtr($lpdwDLLVersion))
	Return $v_Result[0]
EndFunc   ;==>_FT_GetLibraryVersion

; #FUNCTION# ;===============================================================================
;
; Name...........:  _FT_GetComPortNumber
; Description ...: 	Retrieves the COM port associated with a device.
;
; Syntax.........:  _FT_GetComPortNumber ($FT_HANDLE ,  $lplComPortNumber)
;
; Parameters.....: 	$FT_HANDLE 			Handle of the device.
;					$lplComPortNumber	Pointer to a variable of type LONG which receives the COM port
;										number associated with the device.
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the Classic FTD2XX.dll interface
;						This function is only available when using the Windows CDM driver as both the D2XX and VCP
;						drivers can be installed at the same time.
;						If no COM port is associated with the device, lplComPortNumber will have a value of -1.
; Related .......:
; Link ..........:
; Example .......:
; Original ......:	 FT_GetComPortNumber (FT_HANDLE ftHandle, LPLONG lplComPortNumber)
;==========================================================================================
Func _FT_GetComPortNumber($FT_HANDLE, $lplComPortNumber)
	$v_Result = DllCall($v_Dll, 'long', 'FT_GetComPortNumber', 'ptr', $FT_HANDLE, 'ptr', DllStructGetPtr($lplComPortNumber))
	Return $v_Result[0]
EndFunc   ;==>_FT_GetComPortNumber

; #FUNCTION# ;===============================================================================
;
; Name...........:  _FT_GetStatus
; Description ...: 	Gets the device status including number of characters in the receive queue, number of
;					characters in the transmit queue, and the current event status.
;
; Syntax.........:  _FT_GetStatus ($FT_HANDLE, $lpdwAmountInRxQueue, $lpdwAmountInTxQueue, $lpdwEventStatus)
;
; Parameters.....: 	$FT_HANDLE				Handle of the device.
;					$lpdwAmountInRxQueue  	Pointer to a variable of type DWORD which receives the number of
;											characters in the receive queue.
;					$lpdwAmountInTxQueue  	Pointer to a variable of type DWORD which receives the number of
;											characters in the transmit queue.
;					$lpdwEventStatus  		Pointer to a variable of type DWORD which receives the current
;											state of the event status.
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the Classic FTD2XX.dll interface
; Related .......:
; Link ..........:
; Example .......:
; Original ......: FT_GetStatus (FT_HANDLE ftHandle, LPDWORD lpdwAmountInRxQueue, LPDWORD lpdwAmountInTxQueue, LPDWORD lpdwEventStatus)
;==========================================================================================
Func _FT_GetStatus($FT_HANDLE, $lpdwAmountInRxQueue, $lpdwAmountInTxQueue, $lpdwEventStatus)
	$v_Result = DllCall($v_Dll, 'long', 'FT_GetStatus', 'ptr', $FT_HANDLE, 'ptr', DllStructGetPtr($lpdwAmountInRxQueue), 'ptr', DllStructGetPtr($lpdwAmountInTxQueue), 'ptr', DllStructGetPtr($lpdwEventStatus))
	Return $v_Result[0]
EndFunc   ;==>_FT_GetStatus

; #FUNCTION# ;===============================================================================
;
; Name...........:  _FT_SetEventNotification
; Description ...: 	Sets conditions for event notification.
;
; Syntax.........:  _FT_SetEventNotification($FT_HANDLE, $dwEventMask, $pvArg)
;
; Parameters.....: 	$FT_HANDLE				Handle of the device.
;					$dwEventMask     		Conditions that cause the event to be set.
;					$pvArg        			Interpreted as the handle of an event.
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the Classic FTD2XX.dll interface
;						An application can use this function to setup conditions which allow a thread to block until one
;						of the conditions is met.  Typically, an application will create an event, call this function, then
;						block on the event.  When the conditions are met, the event is set, and the application thread
;						unblocked.
;						dwEventMask is a bit-map that describes the events the application is interested in.  pvArg is
;						interpreted as the handle of an event which has been created by the application.  If one of the
;						event conditions is met, the event is set.
;						If FT_EVENT_RXCHAR is set in dwEventMask, the event will be set when a character has been
;						received by the device.
;						If FT_EVENT_MODEM_STATUS is set in dwEventMask, the event will be set when a change in
;						the modem signals has been detected by the device.
;						If FT_EVENT_LINE_STATUS is set in dwEventMask, the event will be set when a change in the
;						line status has been detected by the device.
; Related .......:
; Link ..........:
; Example .......:
; Original ......:	FT_SetEventNotification (FT_HANDLE ftHandle, DWORD dwEventMask, PVOID pvArg)
;==========================================================================================
Func _FT_SetEventNotification($FT_HANDLE, $dwEventMask, $pvArg)
	$v_Result = DllCall($v_Dll, 'long', 'FT_SetEventNotification', 'ptr', $FT_HANDLE, 'DWORD', $dwEventMask, 'ptr', $pvArg)
	Return $v_Result[0]
EndFunc   ;==>_FT_SetEventNotification

; #FUNCTION# ;===============================================================================
;
; Name...........:  _FT_SetChars
; Description ...: 	This function sets the special characters for the device.
;
; Syntax.........: _FT_SetChars($FT_HANDLE, $uEventCh, $uEventChEn, $uErrorCh, $uErrorChEn)
;
; Parameters.....: 	$FT_HANDLE				Handle of the device.
;					$uEventCh     			Event character.
;					$uEventChEn      		0 if event character disabled, non-zero otherwise.
;					$uErrorCh     			Error character.
;					$uErrorChEn      		0 if error character disabled, non-zero otherwise.
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the Classic FTD2XX.dll interface
;					This function allows for inserting specified characters in the data stream to represent events
;					firing or errors occurring.
; Related .......:
; Link ..........:
; Example .......:
; Original ......: FT_SetChars (FT_HANDLE ftHandle, UCHAR uEventCh, UCHAR uEventChEn, UCHAR uErrorCh, UCHAR uErrorChEn)
;==========================================================================================
Func _FT_SetChars($FT_HANDLE, $uEventCh, $uEventChEn, $uErrorCh, $uErrorChEn)
	$v_Result = DllCall($v_Dll, 'long', 'FT_SetChars', 'ptr', $FT_HANDLE, 'str', $uEventCh, 'str', $uEventChEn, 'str', $uErrorCh, 'str', $uErrorChEn)
	Return $v_Result[0]
EndFunc   ;==>_FT_SetChars

; #FUNCTION# ;===============================================================================
;
; Name...........:  _FT_SetBreakOn
; Description ...: 	Sets the BREAK condition for the device.
;
; Syntax.........: _FT_SetBreakOn($FT_HANDLE)
;
; Parameters.....: 	$FT_HANDLE				Handle of the device.
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the Classic FTD2XX.dll interface
; Related .......:
; Link ..........:
; Example .......:
; Original ......: FT_SetBreakOn (FT_HANDLE ftHandle)
;==========================================================================================
Func _FT_SetBreakOn($FT_HANDLE)
	$v_Result = DllCall($v_Dll, 'long', 'FT_SetBreakOn', 'ptr', $FT_HANDLE)
	Return $v_Result[0]
EndFunc   ;==>_FT_SetBreakOn

; #FUNCTION# ;===============================================================================
;
; Name...........:  _FT_SetBreakOff
; Description ...: 	Resets the BREAK condition for the device.
;
; Syntax.........: _FT_SetBreakOff($FT_HANDLE)
;
; Parameters.....: 	$FT_HANDLE				Handle of the device.
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the Classic FTD2XX.dll interface
; Related .......:
; Link ..........:
; Example .......:
; Original ......: FT_SetBreakOff (FT_HANDLE ftHandle)
;==========================================================================================
Func _FT_SetBreakOff($FT_HANDLE)
	$v_Result = DllCall($v_Dll, 'long', 'FT_SetBreakOff', 'ptr', $FT_HANDLE)
	Return $v_Result[0]
EndFunc   ;==>_FT_SetBreakOff

; #FUNCTION# ;===============================================================================
;
; Name...........:  _FT_Purge
; Description ...: 	This function purges receive and transmit buffers in the device.
;
; Syntax.........: _FT_Purge($FT_HANDLE,  $dwMask)
;
; Parameters.....: 	$FT_HANDLE				Handle of the device.
;					$dwMask     			Combination of $FT_PURGE_RX and $FT_PURGE_TX.
;											BitOr ($FT_PURGE_RX , $FT_PURGE_TX) for both
;											$FT_PURGE_RX. To purge recieve buffer
;											$FT_PURGE_TX. To purge transmit buffer
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the Classic FTD2XX.dll interface
; Related .......:
; Link ..........:
; Example .......:
; Original ......:  FT_Purge(FT_HANDLE ftHandle, DWORD dwMask)
;==========================================================================================
Func _FT_Purge($FT_HANDLE, $dwMask)
	$v_Result = DllCall($v_Dll, 'long', 'FT_Purge', 'ptr', $FT_HANDLE, 'DWORD', $dwMask)
	Return $v_Result[0]
EndFunc   ;==>_FT_Purge

; #FUNCTION# ;===============================================================================
;
; Name...........:  _FT_ResetDevice
; Description ...: 	This function sends a reset command to the device
;
; Syntax.........:  _FT_ResetDevice($FT_HANDLE)
;
; Parameters.....: 	$FT_HANDLE				Handle of the device.
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the Classic FTD2XX.dll interface
; Related .......:
; Link ..........:
; Example .......:
; Original ......: FT_ResetDevice (FT_HANDLE ftHandle)
;==========================================================================================
Func _FT_ResetDevice($FT_HANDLE)
	$v_Result = DllCall($v_Dll, 'long', 'FT_ResetDevice', 'ptr', $FT_HANDLE)
	Return $v_Result[0]
EndFunc   ;==>_FT_ResetDevice

; #FUNCTION# ;===============================================================================
;
; Name...........:  _FT_ResetPort
; Description ...: 	Send a reset command to the port.
;
; Syntax.........:  _FT_ResetPort($FT_HANDLE)
;
; Parameters.....: 	$FT_HANDLE				Handle of the device.
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the Classic FTD2XX.dll interface
;						This function is used to attempt to recover the port after a failure.  It is not equivalent to an
;						unplug-replug event.  For the equivalent of an unplug-replug event, use FT_CyclePort.
; Related .......:
; Link ..........:
; Example .......:
; Original ......: FT_ResetPort (FT_HANDLE ftHandle)
;==========================================================================================
Func _FT_ResetPort($FT_HANDLE)
	$v_Result = DllCall($v_Dll, 'long', 'FT_ResetPort', 'ptr', $FT_HANDLE)
	Return $v_Result[0]
EndFunc   ;==>_FT_ResetPort

; #FUNCTION# ;===============================================================================
;
; Name...........:  _FT_CyclePort
; Description ...: 	Send a cycle command to the USB port.
;
; Syntax.........:  _FT_ResetPort($FT_HANDLE)
;
; Parameters.....: 	$FT_HANDLE				Handle of the device.
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the Classic FTD2XX.dll interface
;						This function is used to attempt to recover the port after a failure.  It is not equivalent to an
;						unplug-replug event.  For the equivalent of an unplug-replug event, use FT_CyclePort.
; Related .......:
; Link ..........:
; Example .......:
; Original ......: FT_CyclePort  (FT_HANDLE ftHandle)
;==========================================================================================
Func _FT_CyclePort($FT_HANDLE)
	$v_Result = DllCall($v_Dll, 'long', 'FT_CyclePort', 'ptr', $FT_HANDLE)
	Return $v_Result[0]
EndFunc   ;==>_FT_CyclePort

; #FUNCTION# ;===============================================================================
;
; Name...........:  _FT_Rescan
; Description ...: 	This function can be of use when trying to recover devices programatically.
;
; Syntax.........:   _FT_Rescan ()
;
; Parameters.....: 	<NONE>
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the Classic FTD2XX.dll interface
;					Calling FT_Rescan is equivalent to clicking the "Scan for hardware changes" button in the
;					Device Manager.  Only USB hardware is checked for new devices.  All USB devices are
;					scanned, not just FTDI devices.
; Related .......:
; Link ..........:
; Example .......:
; Original ......:  FT_Rescan ()
;==========================================================================================
Func _FT_Rescan()
	$v_Result = DllCall($v_Dll, 'long', 'FT_Rescan')
	Return $v_Result[0]
EndFunc   ;==>_FT_Rescan

; #FUNCTION# ;===============================================================================
;
; Name...........:  _FT_Reload
; Description ...: 	This function forces a reload of the driver for devices with a specific VID and PID combination.
;
; Syntax.........:   _FT_Reload ( $wVID,  $wPID)
;
; Parameters.....: 	$wVID		Vendor ID of the devices to reload the driver for.
;					$wPID		Product ID of the devices to reload the driver for.
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the Classic FTD2XX.dll interface
;						Calling FT_Reload forces the operating system to unload and reload the driver for the specified
;						device IDs.  If the VID and PID parameters are null, the drivers for USB root hubs will be
;						reloaded, causing all USB devices connected to reload their drivers.  Please note that this
;						function will not work correctly on 64-bit Windows when called from a 32-bit application.
; Related .......:
; Link ..........:
; Example .......:
; Original ......:  FT_Reload (WORD wVID, WORD wPID)
;==========================================================================================
Func _FT_Reload($wVID, $wPID)
	$v_Result = DllCall($v_Dll, 'long', 'FT_Reload', 'long', $wVID, 'long', $wPID)
	Return $v_Result[0]
EndFunc   ;==>_FT_Reload

; #FUNCTION# ;===============================================================================
;
; Name...........:  _FT_SetResetPipeRetryCount
; Description ...: 	Set the ResetPipeRetryCount value.
;
; Syntax.........:  _FT_SetResetPipeRetryCount ( $FT_HANDLE,  $dwCount)
;
; Parameters.....: 	$FT_HANDLE		Handle of the device.
;					$dwCount		Unsigned long containing required ResetPipeRetryCount.
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the Classic FTD2XX.dll interface
;						This function is used to set the ResetPipeRetryCount.  ResetPipeRetryCount controls the
;						maximum number of times that the driver tries to reset a pipe on which an error has occurred.
;						ResetPipeRequestRetryCount defaults to 50.  It may be necessary to increase this value in
;						noisy environments where a lot of USB errors occur.
; Related .......:
; Link ..........:
; Example .......:
; Original ......:  FT_SetResetPipeRetryCount (FT_HANDLE ftHandle, DWORD dwCount)
;==========================================================================================
Func _FT_SetResetPipeRetryCount($FT_HANDLE, $dwCount)
	$v_Result = DllCall($v_Dll, 'long', 'FT_SetResetPipeRetryCount', 'ptr', $FT_HANDLE, 'DWORD', $dwCount)
	Return $v_Result[0]
EndFunc   ;==>_FT_SetResetPipeRetryCount

; #FUNCTION# ;===============================================================================
;
; Name...........:  _FT_StopInTask
; Description ...: 	Stops the driver's IN task.
;
; Syntax.........:  _FT_StopInTask ( $FT_HANDLE)
;
; Parameters.....: 	$FT_HANDLE		Handle of the device.
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the Classic FTD2XX.dll interface
;						This function is used to put the driver's IN task (read) into a wait state.  It can be used in
;						situations where data is being received continuously, so that the device can be purged without
;						more data being received.  It is used together with FT_RestartInTask which sets the IN task
;						running again.
; Related .......:
; Link ..........:
; Example .......:
; Original ......:  FT_StopInTask (FT_HANDLE ftHandle)
;==========================================================================================
Func _FT_StopInTask($FT_HANDLE)
	$v_Result = DllCall($v_Dll, 'long', 'FT_StopInTask', 'ptr', $FT_HANDLE)
	Return $v_Result[0]
EndFunc   ;==>_FT_StopInTask

; #FUNCTION# ;===============================================================================
;
; Name...........:  _FT_RestartInTask
; Description ...: 	Stops the driver's IN task.
;
; Syntax.........:  _FT_RestartInTask ( $FT_HANDLE)
;
; Parameters.....: 	$FT_HANDLE		Handle of the device.
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the Classic FTD2XX.dll interface
;							This function is used to restart the driver's IN task (read) after it has been stopped by a call to
;							FT_StopInTask.
; Related .......:
; Link ..........:
; Example .......:
; Original ......:   FT_RestartInTask (FT_HANDLE ftHandle)
;==========================================================================================
Func _FT_RestartInTask($FT_HANDLE)
	$v_Result = DllCall($v_Dll, 'long', 'FT_RestartInTask', 'ptr', $FT_HANDLE)
	Return $v_Result[0]
EndFunc   ;==>_FT_RestartInTask

; #FUNCTION# ;===============================================================================
;
; Name...........:  _FT_SetDeadmanTimeout
; Description ...: 	This function allows the maximum time in milliseconds that a USB request can remain
;					outstanding to be set.
;
; Syntax.........:  _FT_SetDeadmanTimeout($FT_HANDLE, $dwDeadmanTimeout)
;
; Parameters.....: 	$FT_HANDLE			Handle of the device.
;					$dwDeadmanTimeout	Deadman timeout value in milliseconds.  Default value is 5000.
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the Classic FTD2XX.dll interface
;						The deadman timeout is referred to in application note AN232B-10 Advanced Driver Options
;						from the FTDI web site as the USB timeout.  It is unlikely that this function will be required by
;						most users.
; Related .......:
; Link ..........:
; Example .......:
; Original ......:  FT_SetDeadmanTimeout (FT_HANDLE ftHandle, DWORD dwDeadmanTimeout)
;==========================================================================================
Func _FT_SetDeadmanTimeout($FT_HANDLE, $dwDeadmanTimeout)
	$v_Result = DllCall($v_Dll, 'long', 'FT_SetDeadmanTimeout', 'ptr', $FT_HANDLE, 'DWORD', $dwDeadmanTimeout)
	Return $v_Result[0]
EndFunc   ;==>_FT_SetDeadmanTimeout

#EndRegion FT Classic Interface
;
#Region FT EEPROM Programming Interface
; #FUNCTION# ;===============================================================================
;
; Name...........:  _FT_ReadEE
; Description ...: 	Read a value from an EEPROM location.
;
; Syntax.........:  _FT_ReadEE ($FT_HANDLE, $dwWordOffset, $lpwValue)
;
; Parameters.....: 	$FT_HANDLE			Handle of the device.
;					$dwWordOffset		EEPROM location to read from.
;					$lpwValue			Pointer to the WORD value read from the EEPROM.
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the FTD2XX.dll EEPROM Programming Interface
;						EEPROMs for FTDI devices are organised by WORD, so each value returned is 16-bits wide.
; Related .......:
; Link ..........:
; Example .......:
; Original ......: FT_ReadEE (FT_HANDLE ftHandle, DWORD dwWordOffset, LPWORD lpwValue)
;==========================================================================================
Func _FT_ReadEE($FT_HANDLE, $dwWordOffset, $lpwValue)
	$v_Result = DllCall($v_Dll, 'long', 'FT_ReadEE', 'ptr', $FT_HANDLE, 'DWORD', $dwWordOffset, 'ptr', DllStructGetPtr($lpwValue))
	Return $v_Result[0]
EndFunc   ;==>_FT_ReadEE

; #FUNCTION# ;===============================================================================
;
; Name...........:  _FT_WriteEE
; Description ...: 	Write a value to an EEPROM location.
;
; Syntax.........:  _FT_WriteEE ($FT_HANDLE, $dwWordOffset, $wValue)
;
; Parameters.....: 	$FT_HANDLE			Handle of the device.
;					$dwWordOffset		EEPROM location to write to.
;					$wValue				WORD value to write to the EEPROM.
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the FTD2XX.dll EEPROM Programming Interface
;						EEPROMs for FTDI devices are organised by WORD, so each value written to the EEPROM is 16-bits wide.
; Related .......:
; Link ..........:
; Example .......:
; Original ......: FT_WriteEE (FT_HANDLE ftHandle, DWORD dwWordOffset, WORD wValue)
;==========================================================================================
Func _FT_WriteEE($FT_HANDLE, $dwWordOffset, $wValue)
	$v_Result = DllCall($v_Dll, 'long', 'FT_WriteEE', 'ptr', $FT_HANDLE, 'DWORD', $dwWordOffset, 'ulong', $wValue)
	Return $v_Result[0]
EndFunc   ;==>_FT_WriteEE

; #FUNCTION# ;===============================================================================
;
; Name...........:  _FT_EraseEE
; Description ...: 	Erases the device EEPROM.
;
; Syntax.........:  _FT_EraseEE ($FT_HANDLE)
;
; Parameters.....: 	$FT_HANDLE			Handle of the device.
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the FTD2XX.dll EEPROM Programming Interface
;						EEPROMs for FTDI devices are organised by WORD, so each value written to the EEPROM is 16-bits wide.
; Related .......:
; Link ..........:
; Example .......:
; Original ......: FT_EraseEE (FT_HANDLE ftHandle)
;==========================================================================================
Func _FT_EraseEE($FT_HANDLE)
	MsgBox(0, 'ERASE EEPROM', 'Comment out the msgbox and return line if you want to erase the eeprom')
	Return
	$v_Result = DllCall($v_Dll, 'long', '_FT_EraseEE', 'ptr', $FT_HANDLE)
	Return $v_Result[0]
EndFunc   ;==>_FT_EraseEE

; #FUNCTION# ;===============================================================================
;
; Name...........:  FT_EE_Read
; Description ...: 	Read the contents of the EEPROM.
;
; Syntax.........:  FT_EE_Read ($FT_HANDLE)
;
; Parameters.....: 	$FT_HANDLE			Handle of the device.
;					$pData        		Pointer to structure of type FT_PROGRAM_DATA.
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the FTD2XX.dll EEPROM Programming Interface
;						This function interprets the parameter pData as a pointer to a structure of type
;						FT_PROGRAM_DATA that contains storage for the data to be read from the EEPROM.
;						The function does not perform any checks on buffer sizes, so the buffers passed in the
;						FT_PROGRAM_DATA structure must be big enough to accommodate their respective strings
;						(including null terminators).  The sizes shown in the following example are more than
;						adequate and can be rounded down if necessary.  The restriction is that the Manufacturer
;						string length plus the Description string length is less than or equal to 40 characters.
;						Note that the DLL must be informed which version of the FT_PROGRAM_DATA structure is
;						being used.  This is done through the Signature1, Signature2 and Version elements of the
;						structure.  Signature1 should always be 0x00000000, Signature2 should always be 0xFFFFFFFF
;						and Version can be set to use whichever version is required.  For compatibility with all current
;						devices Version should be set to the latest version of the FT_PROGRAM_DATA structure which
;						is defined in FTD2XX.h.   See url above for more information.
; Related .......:
; Link ..........:
; Example .......:
; Original ......: FT_EE_Read(FT_HANDLE ftHandle, PFT_PROGRAM_DATA pData)
;==========================================================================================
Func _FT_EE_Read($FT_HANDLE, $pData)
	$v_Result = DllCall($v_Dll, 'long', 'FT_EE_Read', 'ptr', $FT_HANDLE, 'ptr', DllStructGetPtr($pData))
	Return $v_Result[0]
EndFunc   ;==>_FT_EE_Read


; #FUNCTION# ;===============================================================================
;
; Name...........:  _FT_EE_ReadEx
; Description ...: 	Read the contents of the EEPROM and pass strings separately.
;
; Syntax.........:  _FT_EE_ReadEx($FT_HANDLE, $pData, $Manufacturer, $ManufacturerId, $Description, $SerialNumber)
;
; Parameters.....: 	$FT_HANDLE			Handle of the device.
;					$pData     			Pointer to structure of type FT_PROGRAM_DATA.
;					$Manufacturer     	Pointer to a null-terminated string containing the manufacturer name.
;					$ManufacturerId     Pointer to a null-terminated string containing the manufacturer ID.
;					$Description    	Pointer to a null-terminated string containing the device description.
;					$SerialNumber   	Pointer to a null-terminated string containing the device serial number.
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the FTD2XX.dll EEPROM Programming Interface
;						This variation of the standard FT_EE_Read function was included to provide support for
;						languages such as LabVIEW where problems can occur when string pointers are contained in a
;						structure.
;						This function interprets the parameter pData as a pointer to a structure of type
;						FT_PROGRAM_DATA that contains storage for the data to be read from the EEPROM.
;						The function does not perform any checks on buffer sizes, so the buffers passed in the
;						FT_PROGRAM_DATA structure must be big enough to accommodate their respective strings
;						(including null terminators).
;						Note that the DLL must be informed which version of the FT_PROGRAM_DATA structure is
;						being used.  This is done through the Signature1, Signature2 and Version elements of the
;						structure.  Signature1 should always be 0x00000000, Signature2 should always be 0xFFFFFFFF
;						and Version can be set to use whichever version is required.  For compatibility with all current
;						devices Version should be set to the latest version of the FT_PROGRAM_DATA structure which
;						is defined in FTD2XX.h.
;						The string parameters in the FT_PROGRAM_DATA structure should be passed as DWORDs to
;						avoid overlapping of parameters.  All string pointers are passed out separately from the
;						FT_PROGRAM_DATA structure.
; Related .......:
; Link ..........:
; Example .......:
; Original ......: FT_EE_ReadEx(FT_HANDLE ftHandle, PFT_PROGRAM_DATA pData, char * Manufacturer, char * ManufacturerId, char * Description, char * SerialNumber)
;==========================================================================================
Func _FT_EE_ReadEx($FT_HANDLE, $pData, $Manufacturer, $ManufacturerId, $Description, $SerialNumber)
	$v_Result = DllCall($v_Dll, 'long', 'FT_EE_ReadEx', 'ptr', $FT_HANDLE, 'ptr', DllStructGetPtr($pData), 'ptr', DllStructGetPtr($Manufacturer), 'ptr', DllStructGetPtr($ManufacturerId), 'ptr', DllStructGetPtr($Description), 'ptr', DllStructGetPtr($SerialNumber))
	Return $v_Result[0]
EndFunc   ;==>_FT_EE_ReadEx

; #FUNCTION# ;===============================================================================
;
; Name...........:  _FT_EE_Program
; Description ...: 	Program the EEPROM.
;
; Syntax.........:  _FT_EE_Program($FT_HANDLE, $pData)
;
; Parameters.....: 	$FT_HANDLE			Handle of the device.
;					$pData     			Pointer to structure of type FT_PROGRAM_DATA.
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the FTD2XX.dll EEPROM Programming Interface
;						This function interprets the parameter pData as a pointer to a structure of type
;						FT_PROGRAM_DATA that contains the data to write to the EEPROM.  The data is written to
;						EEPROM, then read back and verified.
;						If the SerialNumber field in FT_PROGRAM_DATA is NULL, or SerialNumber points to a NULL
;						string, a serial number based on the ManufacturerId and the current date and time will be
;						generated.  The Manufacturer string length plus the Description string length must be less than
;						or equal to 40 characters.
;						Note that the DLL must be informed which version of the FT_PROGRAM_DATA structure is
;						being used.  This is done through the Signature1, Signature2 and Version elements of the
;						structure.  Signature1 should always be 0x00000000, Signature2 should always be 0xFFFFFFFF
;						and Version can be set to use whichever version is required.  For compatibility with all current
;						devices Version should be set to the latest version of the FT_PROGRAM_DATA structure which
;						is defined in FTD2XX.h.
;						If pData is NULL, the structure version will default to 0 (original BM series) and the device will
;						be programmed with the default data.
; Related .......:
; Link ..........:
; Example .......:
; Original ......: FT_EE_Program(FT_HANDLE ftHandle, PFT_PROGRAM_DATA pData)
;==========================================================================================
Func _FT_EE_Program($FT_HANDLE, $pData)
	$v_Result = DllCall($v_Dll, 'long', 'FT_EE_Program', 'ptr', $FT_HANDLE, 'ptr', DllStructGetPtr($pData))
	Return $v_Result[0]
EndFunc   ;==>_FT_EE_Program

; #FUNCTION# ;===============================================================================
;
; Name...........:  _FT_EE_ProgramEx
; Description ...: 	Program the EEPROM and pass strings separately.
;
; Syntax.........:  _FT_EE_ReadEx($FT_HANDLE, $pData, $Manufacturer, $ManufacturerId, $Description, $SerialNumber)
;
; Parameters.....: 	$FT_HANDLE			Handle of the device.
;					$pData     			Pointer to structure of type FT_PROGRAM_DATA.
;					$Manufacturer     	Pointer to a null-terminated string containing the manufacturer name.
;					$ManufacturerId     Pointer to a null-terminated string containing the manufacturer ID.
;					$Description    	Pointer to a null-terminated string containing the device description.
;					$SerialNumber   	Pointer to a null-terminated string containing the device serial number.
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the FTD2XX.dll EEPROM Programming Interface
;						This variation of the FT_EE_Program function was included to provide support for languages
;						such as LabVIEW where problems can occur when string pointers are contained in a structure.
;						This function interprets the parameter pData as a pointer to a structure of type
;						FT_PROGRAM_DATA that contains the data to write to the EEPROM.  The data is written to
;						EEPROM, then read back and verified.
;						The string pointer parameters in the FT_PROGRAM_DATA structure should be allocated as
;						DWORDs to avoid overlapping of parameters.  The string parameters are then passed in
;						separately.
;						If the SerialNumber field is NULL, or SerialNumber points to a NULL string, a serial number
;						based on the ManufacturerId and the current date and time will be generated.  The
;						Manufacturer string length plus the Description string length must be less than or equal to 40
;						characters.
;						Note that the DLL must be informed which version of the FT_PROGRAM_DATA structure is
;						being used.  This is done through the Signature1, Signature2 and Version elements of the
;						structure.  Signature1 should always be 0x00000000, Signature2 should always be 0xFFFFFFFF
;						and Version can be set to use whichever version is required.  For compatibility with all current
;						devices Version should be set to the latest version of the FT_PROGRAM_DATA structure which
;						is defined in FTD2XX.h.
;						If pData is NULL, the structure version will default to 0 (original BM series) and the device will
;						be programmed with the default data:
; Related .......:
; Link ..........:
; Example .......:
; Original ......: FT_EE_ProgramEx(FT_HANDLE ftHandle, PFT_PROGRAM_DATA pData, char * Manufacturer, char * ManufacturerId, char * Description, char * SerialNumber)
;==========================================================================================
Func _FT_EE_ProgramEx($FT_HANDLE, $pData, $Manufacturer, $ManufacturerId, $Description, $SerialNumber)
	$v_Result = DllCall($v_Dll, 'long', 'FT_EE_ReadEx', 'ptr', $FT_HANDLE, 'ptr', DllStructGetPtr($pData), 'ptr', DllStructGetPtr($Manufacturer), 'ptr', DllStructGetPtr($ManufacturerId), 'ptr', DllStructGetPtr($Description), 'ptr', DllStructGetPtr($SerialNumber))
	Return $v_Result[0]
EndFunc   ;==>_FT_EE_ProgramEx

; #FUNCTION# ;===============================================================================
;
; Name...........:  _FT_EE_UASize
; Description ...: 	Get the available size of the EEPROM user area.
;
; Syntax.........:  _FT_EE_UASize($FT_HANDLE, $lpdwSize)
;
; Parameters.....: 	$FT_HANDLE			Handle of the device.
;					$lpdwSize     		Pointer to a DWORD that receives the available size, in bytes, of the EEPROM user area
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the FTD2XX.dll EEPROM Programming Interface
;						The user area of an FTDI device EEPROM is the total area of the EEPROM that is unused by
;						device configuration information and descriptors.  This area is available to the user to store
;						information specific to their application.  The size of the user area depends on the length of the
;						Manufacturer, ManufacturerId, Description and SerialNumber strings programmed into the
;						EEPROM.
; Related .......:
; Link ..........:
; Example .......:
; Original ......: FT_EE_UASize (FT_HANDLE ftHandle, LPDWORD lpdwSize)
;==========================================================================================
Func _FT_EE_UASize($FT_HANDLE, $lpdwSize)
	$v_Result = DllCall($v_Dll, 'long', 'FT_EE_UASize', 'ptr', $FT_HANDLE, 'ptr', DllStructGetPtr($lpdwSize))
	Return $v_Result[0]
EndFunc   ;==>_FT_EE_UASize
; #FUNCTION# ;===============================================================================
;
; Name...........:  _FT_EE_UASize
; Description ...: 	Read the contents of the EEPROM user area.
;
; Syntax.........:  _FT_EE_UARead($FT_HANDLE, $pucData, $dwDataLen , $lpdwBytesRead)
;
; Parameters.....: 	$FT_HANDLE			Handle of the device.
;					$pucData			Pointer to a buffer that contains storage for data to be read.
;					$dwDataLen			Size, in bytes, of buffer that contains storage for the data to be read.
;					$lpdwBytesRead		Pointer to a DWORD that receives the number of bytes read.
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the FTD2XX.dll EEPROM Programming Interface
;						This function interprets the parameter pucData as a pointer to an array of bytes of size
;						dwDataLen that contains storage for the data to be read from the EEPROM user area.  The
;						actual number of bytes read is stored in the DWORD referenced by lpdwBytesRead.
;						If dwDataLen is less than the size of the EEPROM user area, then dwDataLen bytes are read
;						into the buffer.  Otherwise, the whole of the EEPROM user area is read into the buffer.  The
;						available user area size can be determined by calling FT_EE_UASize.
;						An application should check the function return value and lpdwBytesRead when FT_EE_UARead
;						returns.
; Related .......:
; Link ..........:
; Example .......:
; Original ......: FT_EE_UARead(FT_HANDLE ftHandle, PUCHAR pucData, DWORD dwDataLen, LPDWORD lpdwBytesRead)
;==========================================================================================
Func _FT_EE_UARead($FT_HANDLE, $pucData, $dwDataLen, $lpdwBytesRead)
	$v_Result = DllCall($v_Dll, 'long', 'FT_EE_UARead', 'ptr', $FT_HANDLE, 'ptr', DllStructGetPtr($pucData), 'DWORD', $dwDataLen, 'ptr', DllStructGetPtr($lpdwBytesRead))
	Return $v_Result[0]
EndFunc   ;==>_FT_EE_UARead

; #FUNCTION# ;===============================================================================
;
; Name...........:  _FT_EE_UAWrite
; Description ...: 	Write data into the EEPROM user area.
;
; Syntax.........:  _FT_EE_UAWrite($FT_HANDLE, $pucData, $dwDataLen)
;
; Parameters.....: 	$FT_HANDLE			Handle of the device.
;					$pucData			Pointer to a buffer that contains storage for data to be read.
;					$dwDataLen			Size, in bytes, of buffer that contains storage for the data to be read.
;
; Return values .: Sucess - 0 if successful,
;                  Failure - the return value is an FT error code.
;				   	|x - use _USBFT_ErrorDescription(x) for more detailed information
;
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......: Part of the FTD2XX.dll EEPROM Programming Interface
;						This function interprets the parameter pucData as a pointer to an array of bytes of size
;						dwDataLen that contains the data to be written to the EEPROM user area.  It is a programming
;						error for dwDataLen to be greater than the size of the EEPROM user area.  The available user
;						area size can be determined by calling FT_EE_UASize.
; Related .......:
; Link ..........:
; Example .......:
; Original ......: 	FT_EE_UAWrite(FT_HANDLE ftHandle, PUCHAR pucData, DWORD dwDataLen)
;==========================================================================================
Func _FT_EE_UAWrite($FT_HANDLE, $pucData, $dwDataLen)
	$v_Result = DllCall($v_Dll, 'long', 'FT_EE_UAWrite', 'ptr', $FT_HANDLE, 'ptr', DllStructGetPtr($pucData), 'DWORD', $dwDataLen)
	Return $v_Result[0]
EndFunc   ;==>_FT_EE_UAWrite


#EndRegion FT EEPROM Programming Interface
;
#Region Extended API Functions

#EndRegion Extended API Functions
;
#Region FT-Win32 API Functions

#EndRegion FT-Win32 API Functions
;
#Region _USBFT_ErrorDescription
; #FUNCTION# ;===============================================================================
;
; Name...........: _USBFT_ErrorDescription($i_Error)
; Description ...: Returns The Long Description for the Error Number
; Syntax.........: _USBFT_ErrorDescription($i_Error) usually _USBFT_ErrorDescription(@error)
; Parameters ....: $i_Error - an interger from 0 to n depending on the number of devices connected
; Return values .: Success - The FT_Long Description for the Error Number
; Author ........: Neil Jensen (wakido;NBJ)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; YES
;
;==========================================================================================
Func _USBFT_ErrorDescription($i_Error)
	Local $i_ErrorCode[21]
	$i_ErrorCode[0] = 'FT_OK'
	$i_ErrorCode[1] = 'FT_INVALID_HANDLE'
	$i_ErrorCode[2] = 'FT_DEVICE_NOT_FOUND'
	$i_ErrorCode[3] = 'FT_DEVICE_NOT_OPENED'
	$i_ErrorCode[4] = 'FT_IO_ERROR'
	$i_ErrorCode[5] = 'FT_INSUFFICIENT_RESOURCES'
	$i_ErrorCode[6] = 'FT_INVALID_PARAMETER'
	$i_ErrorCode[7] = 'FT_INVALID_BAUD_RATE'
	$i_ErrorCode[8] = 'FT_DEVICE_NOT_OPENED_FOR_ERASE'
	$i_ErrorCode[9] = 'FT_DEVICE_NOT_OPENED_FOR_WRITE'
	$i_ErrorCode[10] = 'FT_FAILED_TO_WRITE_DEVICE'
	$i_ErrorCode[11] = 'FT_EEPROM_READ_FAILED'
	$i_ErrorCode[12] = 'FT_EEPROM_WRITE_FAILED'
	$i_ErrorCode[13] = 'FT_EEPROM_ERASE_FAILED'
	$i_ErrorCode[14] = 'FT_EEPROM_NOT_PRESENT'
	$i_ErrorCode[15] = 'FT_EEPROM_NOT_PROGRAMMED'
	$i_ErrorCode[16] = 'FT_INVALID_ARGS'
	$i_ErrorCode[17] = 'FT_NOT_SUPPORTED'
	$i_ErrorCode[18] = 'FT_OTHER_ERROR'
	$i_ErrorCode[19] = 'FT_DEVICE_LIST_NOT_READY'
	If $i_Error > 19 Then Return 'Unknown Error #' & $i_Error
	Return $i_ErrorCode[$i_Error]
EndFunc   ;==>_USBFT_ErrorDescription

#EndRegion _USBFT_ErrorDescription


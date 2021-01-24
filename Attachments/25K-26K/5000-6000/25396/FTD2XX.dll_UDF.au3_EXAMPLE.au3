#include <FTD2XX.dll_UDF.au3>
#Region Example
ConsoleWrite(@CR & '!------------_FT_CreateDeviceInfoList($lpdwNumDevs)')
$Do = _FT_CreateDeviceInfoList($lpdwNumDevs)
ConsoleWrite(@CR & _USBFT_ErrorDescription($Do))
ConsoleWrite(@CR & DllStructGetData($lpdwNumDevs, 1))

ConsoleWrite(@CR & '!------------_FT_GetDeviceInfoList( $pDest,  $lpdwNumDevs)')
$Do = _FT_GetDeviceInfoList($pDest, $lpdwNumDevs)
ConsoleWrite(@CR & _USBFT_ErrorDescription($Do))
ConsoleWrite(@CR & DllStructGetData($pDest, 1))
ConsoleWrite(@CR & DllStructGetData($lpdwNumDevs, 1))

ConsoleWrite(@CR&'!------------_FT_GetDeviceInfoDetail( $dwIndex,  $lpdwFlags,  $lpdwType,  $lpdwID,  $lpdwLocId,  $pcSerialNumber,  $pcDescription,  $FT_HANDLE)')
$do= _FT_GetDeviceInfoDetail( $dwIndex,  $lpdwFlags,  $lpdwType,  $lpdwID,  $lpdwLocId,  $pcSerialNumber,  $pcDescription,  $FT_HANDLE)
ConsoleWrite(@CR&_USBFT_ErrorDescription($Do))
ConsoleWrite(@CR&DllStructGetData($dwIndex,1))
ConsoleWrite(@CR&DllStructGetData($lpdwFlags,1))
ConsoleWrite(@CR&DllStructGetData($lpdwType,1))
ConsoleWrite(@CR&DllStructGetData($lpdwID,1))
ConsoleWrite(@CR&DllStructGetData($lpdwLocId,1))
ConsoleWrite(@CR&DllStructGetData($pcSerialNumber,1))
ConsoleWrite(@CR&DllStructGetData($pcDescription,1))
ConsoleWrite(@CR&$FT_HANDLE)

ConsoleWrite(@CR & '!------------_FT_ListDevices($pvArg1, $pvArg2, $FT_LIST_BY_NUMBER_ONLY)')
$pvArg1 = DllStructCreate('long')
$pvArg2 = DllStructCreate('long')
$Do = _FT_ListDevices($pvArg1, $pvArg2, $FT_LIST_BY_NUMBER_ONLY)
ConsoleWrite(@CR & _USBFT_ErrorDescription($Do))
ConsoleWrite(@CR & DllStructGetData($pvArg1, 1))
For $i_Loop = 0 To UBound($Do) - 1
	ConsoleWrite(@CR & '$v_Result[' & $i_Loop & ']=' & $Do[$i_Loop])
Next


ConsoleWrite(@CR & '!------------_FT_ListDevices(0, $pvArg2, BitOR($FT_LIST_BY_INDEX,$FT_OPEN_BY_DESCRIPTION))')
$pvArg1 = 0
$pvArg2 = DllStructCreate('char[100]')
$Do = _FT_ListDevices($pvArg1, $pvArg2, BitOR($FT_LIST_BY_INDEX, $FT_OPEN_BY_DESCRIPTION))
ConsoleWrite(@CR & _USBFT_ErrorDescription($Do))
ConsoleWrite(@CR & DllStructGetData($pvArg2, 1))

ConsoleWrite(@CR & '!------------_FT_ListDevices(0, $pvArg2, BitOR($FT_LIST_BY_INDEX,$FT_OPEN_BY_SERIAL_NUMBER))')
$pvArg1 = 0
$pvArg2 = DllStructCreate('char[100]')
$Do = _FT_ListDevices($pvArg1, $pvArg2, BitOR($FT_LIST_BY_INDEX, $FT_OPEN_BY_SERIAL_NUMBER))
ConsoleWrite(@CR & _USBFT_ErrorDescription($Do))
ConsoleWrite(@CR & DllStructGetData($pvArg2, 1))

ConsoleWrite(@CR & '!------------_FT_Open(0, $fthandle)')
$Do = _FT_Open(0, $fthandle)
ConsoleWrite(@CR & _USBFT_ErrorDescription($Do))
ConsoleWrite(@CR & DllStructGetData($fthandle, 1))
ConsoleWrite(@CR & $FT_HANDLE)

ConsoleWrite(@CR & '!------------_FT_Write($FT_HANDLE,  $lpBuffer,  $dwBytesToWrite,  $lpdwBytesWritten)')
DllStructSetData($lpBuffer, 1, "STRING")
$dwBytesToWrite = StringLen("STRING")
$Do = _FT_Write($FT_HANDLE, $lpBuffer, $dwBytesToWrite, $lpdwBytesWritten)
ConsoleWrite(@CR & _USBFT_ErrorDescription($Do))
ConsoleWrite(@CR & DllStructGetData($lpBuffer, 1))
ConsoleWrite(@CR & $dwBytesToWrite)
ConsoleWrite(@CR & DllStructGetData($lpdwBytesWritten, 1))


ConsoleWrite(@CR & '!------------_FT_SetBaudRate($FT_HANDLE, 9600)')
$Do = _FT_SetBaudRate($FT_HANDLE, 9600)
ConsoleWrite(@CR & _USBFT_ErrorDescription($Do))

ConsoleWrite(@CR & '!------------_FT_GetComPortNumber ($FT_HANDLE, $lplComPortNumber)')
$Do = _FT_GetComPortNumber($FT_HANDLE, $lplComPortNumber)
ConsoleWrite(@CR & _USBFT_ErrorDescription($Do))
ConsoleWrite(@CR & DllStructGetData($lplComPortNumber, 1))

ConsoleWrite(@CR & '!------------_FT_GetStatus($FT_HANDLE, $lpdwAmountInRxQueue, $lpdwAmountInTxQueue, $lpdwEventStatus)')
$Do = _FT_GetStatus($FT_HANDLE, $lpdwAmountInRxQueue, $lpdwAmountInTxQueue, $lpdwEventStatus)
ConsoleWrite(@CR & _USBFT_ErrorDescription($Do))
ConsoleWrite(@CR & DllStructGetData($lpdwAmountInRxQueue, 1))
ConsoleWrite(@CR & DllStructGetData($lpdwAmountInTxQueue, 1))
ConsoleWrite(@CR & DllStructGetData($lpdwEventStatus, 1))


$dwBytesToRead = DllStructGetData($lpdwAmountInRxQueue, 1)
DllStructSetData($lpBuffer, 1, '')
ConsoleWrite(@CR & '!------------_FT_Read($FT_HANDLE,  $lpBuffer,  $dwBytesToRead,  $lpdwBytesReturned)')
$Do = _FT_Read($FT_HANDLE, $lpBuffer, $dwBytesToRead, $lpdwBytesReturned)
ConsoleWrite(@CR & _USBFT_ErrorDescription($Do))
ConsoleWrite(@CR & DllStructGetData($lpBuffer, 1))
ConsoleWrite(@CR & $dwBytesToRead)
ConsoleWrite(@CR & DllStructGetData($lpdwBytesReturned, 1))

ConsoleWrite(@CR & '!------------_FT_GetDeviceInfo ($FT_HANDLE, $pftType, $lpdwID, $pcSerialNumber,  $pcDescription,  $pvDummy)')
$Do = _FT_GetDeviceInfo($FT_HANDLE, $pftType, $lpdwID, $pcSerialNumber, $pcDescription, $pvDummy)
ConsoleWrite(@CR & _USBFT_ErrorDescription($Do))
ConsoleWrite(@CR & DllStructGetData($pftType, 1))
ConsoleWrite(@CR & DllStructGetData($lpdwID, 1))
ConsoleWrite(@CR & DllStructGetData($pcSerialNumber, 1))
ConsoleWrite(@CR & DllStructGetData($pcDescription, 1))
ConsoleWrite(@CR & DllStructGetData($pvDummy, 1))

ConsoleWrite(@CR & '!------------_FT_GetModemStatus($FT_HANDLE, $lpdwModemStatus)')
$Do = _FT_GetModemStatus($FT_HANDLE, $lpdwModemStatus)
ConsoleWrite(@CR & _USBFT_ErrorDescription($Do))
ConsoleWrite(@CR & DllStructGetData($lpdwModemStatus, 1))

ConsoleWrite(@CR & '!------------_FT_GetQueueStatus($FT_HANDLE, $lpdwAmountInRxQueue)')
$Do = _FT_GetQueueStatus($FT_HANDLE, $lpdwAmountInRxQueue)
ConsoleWrite(@CR & _USBFT_ErrorDescription($Do))
ConsoleWrite(@CR & DllStructGetData($lpdwAmountInRxQueue, 1))

ConsoleWrite(@CR & '!------------_FT_GetDriverVersion ($FT_HANDLE, $lpdwDriverVersion)')
$Do = _FT_GetDriverVersion($FT_HANDLE, $lpdwDriverVersion)
ConsoleWrite(@CR & _USBFT_ErrorDescription($Do))
ConsoleWrite(@CR & DllStructGetData($lpdwDriverVersion, 1))
ConsoleWrite(@CR & Hex(DllStructGetData($lpdwDriverVersion, 1)))

ConsoleWrite(@CR & '!------------_FT_SetDataCharacteristics($FT_HANDLE, $uWordLength, $uStopBits, $uParity)')
$uWordLength = $FT_BITS_8
$uStopBits = $FT_STOP_BITS_1
$uParity = $FT_PARITY_EVEN
$Do = _FT_SetDataCharacteristics($FT_HANDLE, $uWordLength, $uStopBits, $uParity)
ConsoleWrite(@CR & _USBFT_ErrorDescription($Do))
ConsoleWrite(@CR & $uWordLength)
ConsoleWrite(@CR & $uStopBits)
ConsoleWrite(@CR & $uParity)

ConsoleWrite(@CR & '!------------_FT_SetFlowControl($FT_HANDLE, $usFlowControl, $uXon, $uXoff)')
$usFlowControl = $FT_FLOW_XON_XOFF
$uXon = 'A'
$uXoff = 'C'
$Do = _FT_SetFlowControl($FT_HANDLE, $usFlowControl, $uXon, $uXoff)
ConsoleWrite(@CR & _USBFT_ErrorDescription($Do))
ConsoleWrite(@CR & $usFlowControl)
ConsoleWrite(@CR & $uXon)
ConsoleWrite(@CR & $uXoff)
;					

ConsoleWrite(@CR & '!------------_FT_Rescan()')
$Do = _FT_Rescan()
ConsoleWrite(@CR & _USBFT_ErrorDescription($Do))

ConsoleWrite(@CR & '!------------_FT_SetBreakOn($FT_HANDLE)')
$Do = _FT_SetBreakOn($FT_HANDLE)
ConsoleWrite(@CR & _USBFT_ErrorDescription($Do))

ConsoleWrite(@CR & '!------------_FT_SetBreakOff($FT_HANDLE)')
$Do = _FT_SetBreakOff($FT_HANDLE)
ConsoleWrite(@CR & _USBFT_ErrorDescription($Do))

ConsoleWrite(@CR & '!------------_FT_Purge($FT_HANDLE, $dwMask)')
$dwMask = BitOR($FT_PURGE_RX, $FT_PURGE_TX)
$Do = _FT_Purge($FT_HANDLE, $dwMask)
ConsoleWrite(@CR & _USBFT_ErrorDescription($Do))
ConsoleWrite(@CR & $dwMask)

ConsoleWrite(@CR & '!------------_FT_ResetDevice($FT_HANDLE)')
$Do = _FT_ResetDevice($FT_HANDLE)
ConsoleWrite(@CR & _USBFT_ErrorDescription($Do))

ConsoleWrite(@CR & '!------------_FT_ResetPort($FT_HANDLE)')
$Do = _FT_ResetPort($FT_HANDLE)
ConsoleWrite(@CR & _USBFT_ErrorDescription($Do))

ConsoleWrite(@CR & '!------------_FT_CyclePort($FT_HANDLE)')
$Do = _FT_CyclePort($FT_HANDLE)
ConsoleWrite(@CR & _USBFT_ErrorDescription($Do))

ConsoleWrite(@CR & '!------------_FT_Close($FT_HANDLE)')
$Do = _FT_Close($FT_HANDLE)
ConsoleWrite(@CR & _USBFT_ErrorDescription($Do))

ConsoleWrite(@CR & '!------------_FT_GetLibraryVersion ($lpdwDLLVersion)')
$Do = _FT_GetLibraryVersion($lpdwDLLVersion)
ConsoleWrite(@CR & _USBFT_ErrorDescription($Do))
ConsoleWrite(@CR & DllStructGetData($lpdwDLLVersion, 1))
ConsoleWrite(@CR & Hex(DllStructGetData($lpdwDLLVersion, 1)))





ConsoleWrite(@CR)

#EndRegion Example
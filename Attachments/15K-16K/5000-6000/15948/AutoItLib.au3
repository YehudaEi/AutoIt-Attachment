;All these are taken from the AutoItLibrary made by PaulIA
#region *** GLOBAL VARIABLES ***
Global Const $tagGDIPLUSSTARTUPINPUT = "int Version;int Callback;int NoThread;int NoCodecs"
Global Const $tagGUID = "int Data1;short Data2;short Data3;byte Data4[8]"
Global Const $tagGDIIMAGECODECINFO = "byte CLSID[16];byte FormatID[16];ptr CodecName;ptr DllName;ptr FormatDesc;ptr FileExt;" & _
             "ptr MimeType;dword Flags;dword Version;dword SigCount;dword SigSize;ptr SigPattern;ptr SigMask"
			 
Global Const $SPI_SETDESKWALLPAPER              = 0x0014
Global Const $SPIF_UPDATEINIFILE                = 0x0001
Global Const $SPIF_SENDCHANGE                   = 0x0002

Global $ghA3LGDIDll = 0
Global $giA3LToken  = 0
#endRegion
#region *** FUNCTIONS ***
Func _GDI_Startup()
  Local $tInput, $tToken, $aResult

  $ghA3LGDIDll = DllOpen("GDIPlus.dll")
  if $ghA3LGDIDll = -1 then Return SetError(-1, -1, False)

  $tInput = DllStructCreate($tagGDIPLUSSTARTUPINPUT)
  DllStructSetData($tInput, "Version", 1)
  $tToken = DllStructCreate("int Data")
  $aResult = DllCall($ghA3LGDIDll, "int", "GdiplusStartup", "ptr", DllStructGetPtr($tToken), "ptr", DllStructGetPtr($tInput), "ptr", 0)
  $giA3LToken = DllStructGetData($tToken, "Data")
  Return $aResult[0] <> 0
EndFunc

Func _GDI_LoadFromFile($sFileName)
  Local $pFileName, $tFileName, $pImage, $tImage, $aResult

  $tFileName = _API_MultiByteToWideChar($sFileName)
  $pFileName = DllStructGetPtr($tFileName)
  $tImage    = DllStructCreate("hwnd Image")
  $pImage    = DllStructGetPtr($tImage)
  $aResult   = DllCall($ghA3LGDIDll, "int", "GdipLoadImageFromFile", "ptr", $pFileName, "ptr", $pImage)
  Return SetError($aResult[0], 0, DllStructGetData($tImage, "Image"))
EndFunc

Func _API_MultiByteToWideChar($sText, $iCodePage=0, $iFlags=0)
  Local $iText, $pText, $tText

  $iText = StringLen($sText) + 1
  $tText = DllStructCreate("byte[" & $iText * 2 & "]")
  $pText = DllStructGetPtr($tText)
  DllCall("Kernel32.dll", "int", "MultiByteToWideChar", "int", $iCodePage, "int", $iFlags, "str", $sText, "int", $iText, _
          "ptr", $pText, "int", $iText * 2)
  Return $tText
EndFunc

Func _GDI_GetEncoderCLSID($sFileExt)
  Local $iI, $aEncoders

  $aEncoders = _GDI_GetImageEncoders()
  for $iI = 1 to $aEncoders[0][0]
    if StringInStr($aEncoders[$iI][6], "*." & $sFileExt) > 0 then Return $aEncoders[$iI][1]
  next
  Return SetError(-1, -1, "")
EndFunc

Func _GDI_GetImageEncoders()
  Local $iI, $iCount, $iSize, $pBuffer, $tBuffer, $tCodec, $aResult, $aInfo[1][14]

  $iCount  = _GDI_GetImageEncodersCount()
  $iSize   = _GDI_GetImageEncodersSize ()
  $tBuffer = DllStructCreate("byte[" & $iSize & "]")
  $pBuffer = DllStructGetPtr($tBuffer)
  $aResult = DllCall($ghA3LGDIDll, "int", "GdipGetImageEncoders", "int", $iCount, "int", $iSize, "ptr", $pBuffer)
  if $aResult[0] <> 0 then Return SetError($aResult[0], 0, $aInfo)

  Dim $aInfo[$iCount + 1][14]
  $aInfo[0][0] = $iCount
  for $iI = 1 to $iCount
    $tCodec = DllStructCreate($tagGDIIMAGECODECINFO, $pBuffer)
    $aInfo[$iI][ 1] = _API_StringFromGUID(DllStructGetPtr($tCodec, "CLSID"   ))
    $aInfo[$iI][ 2] = _API_StringFromGUID(DllStructGetPtr($tCodec, "FormatID"))
    $aInfo[$iI][ 3] = _API_WideCharToMultiByte(DllStructGetData($tCodec, "CodecName") )
    $aInfo[$iI][ 4] = _API_WideCharToMultiByte(DllStructGetData($tCodec, "DllName") )
    $aInfo[$iI][ 5] = _API_WideCharToMultiByte(DllStructGetData($tCodec, "FormatDesc"))
    $aInfo[$iI][ 6] = _API_WideCharToMultiByte(DllStructGetData($tCodec, "FileExt") )
    $aInfo[$iI][ 7] = _API_WideCharToMultiByte(DllStructGetData($tCodec, "MimeType") )
    $aInfo[$iI][ 8] = DllStructGetData($tCodec, "Flags")
    $aInfo[$iI][ 9] = DllStructGetData($tCodec, "Version")
    $aInfo[$iI][10] = DllStructGetData($tCodec, "SigCount")
    $aInfo[$iI][11] = DllStructGetData($tCodec, "SigSize")
    $aInfo[$iI][12] = DllStructGetData($tCodec, "SigPattern")
    $aInfo[$iI][13] = DllStructGetData($tCodec, "SigMask")
    $pBuffer += DllStructGetSize($tCodec)
  next
  Return $aInfo
EndFunc

Func _API_StringFromGUID($pGUID)
  Local $aResult

  $aResult = DllCall("Ole32.dll", "int", "StringFromGUID2", "ptr", $pGUID, "wstr", "", "int", 40)
  Return SetError($aResult[0] <> 0, 0, $aResult[2])
EndFunc

Func _API_WideCharToMultiByte($pUnicode)
  Local $tBuffer

  $tBuffer = DllStructCreate("char Text[4096]")
  DllCall("Kernel32.dll", "int", "WideCharToMultiByte", "int", 0, "int", 0, "ptr", $pUnicode, "int", -1, "ptr", _
          DllStructGetPtr($tBuffer), "int", 4096, "int", 0, "int", 0)
  Return DllStructGetData($tBuffer, "Text")
EndFunc

Func _GDI_GetImageEncodersCount()
  Local $pCount, $pSize, $tBuffer, $aResult

  $tBuffer = DllStructCreate("int Count;int Size")
  $pCount  = DllStructGetPtr($tBuffer, "Count")
  $pSize   = DllStructGetPtr($tBuffer, "Size" )
  $aResult = DllCall($ghA3LGDIDll, "int", "GdipGetImageEncodersSize", "ptr", $pCount, "ptr", $pSize)
  Return SetError($aResult[0], 0, DllStructGetData($tBuffer, "Count"))
EndFunc

Func _GDI_GetImageEncodersSize()
  Local $pCount, $pSize, $tBuffer, $aResult

  $tBuffer = DllStructCreate("int Count;int Size")
  $pCount  = DllStructGetPtr($tBuffer, "Count")
  $pSize   = DllStructGetPtr($tBuffer, "Size" )
  $aResult = DllCall($ghA3LGDIDll, "int", "GdipGetImageEncodersSize", "ptr", $pCount, "ptr", $pSize)
  Return SetError($aResult[0], 0, DllStructGetData($tBuffer, "Size"))
EndFunc

Func _Str_ChangeFileExt($sFileName, $sExtension)
  Local $iIndex

  $iIndex = _Str_LastDelimiter(".\:", $sFileName)
  if ($iIndex = 0) or (StringMid($sFileName, $iIndex, 1) <> ".") then $iIndex = StringLen($sFileName) + 1
  Return StringLeft($sFileName, $iIndex - 1) & $sExtension
EndFunc

Func _Str_LastDelimiter($sDelimiters, $sString)
  Local $iI, $iN, $sDelimiter

  for $iI = 1 to StringLen($sDelimiters)
    $sDelimiter = StringMid($sDelimiters, $iI, 1)
    $iN = StringInStr($sString, $sDelimiter, 0, -1)
    if $iN > 0 then Return $iN
  next
EndFunc

Func _GDI_SaveToFile($hImage, $sFileName, $sEncoder, $pParams=0)
  Local $pFileName, $tFileName, $pGUID, $tGUID, $aResult

  $tFileName = _API_MultiByteToWideChar($sFileName)
  $pFileName = DllStructGetPtr($tFileName)
  $tGUID     = _API_GUIDFromString($sEncoder)
  $pGUID     = DllStructGetPtr($tGUID)
  $aResult   = DllCall($ghA3LGDIDll, "int", "GdipSaveImageToFile", "hwnd", $hImage, "ptr", $pFileName, "ptr", $pGUID, "ptr", $pParams)
  Return SetError($aResult[0], 0, $aResult[0]=0)
EndFunc

Func _API_GUIDFromString($sGUID)
  Local $tGUID

  $tGUID = DllStructCreate($tagGUID)
  _API_GUIDFromStringEx($sGUID, DllStructGetPtr($tGUID))
  Return SetError(@Error, 0, $tGUID)
EndFunc

Func _API_GUIDFromStringEx($sGUID, $pGUID)
  Local $tData, $aResult

  $tData   = _API_MultiByteToWideChar($sGUID)
  $aResult = DllCall("Ole32.dll", "int", "CLSIDFromString", "ptr", DllStructGetPtr($tData), "ptr", $pGUID)
  Return $aResult[0] <> 0
EndFunc

Func _GDI_DisposeImage($hImage)
  Local $aResult

  $aResult = DllCall($ghA3LGDIDll, "int", "GdipDisposeImage", "hwnd", $hImage)
  Return SetError($aResult[0], 0, $aResult[0]=0)
EndFunc

Func _GDI_Shutdown()
  if $ghA3LGDIDll <= 0 then Return SetError(-1, -1, False)
  DllCall($ghA3LGDIDll, "none", "GdiplusShutdown", "ptr", $giA3LToken)
  DllClose($ghA3LGDIDll)
EndFunc

Func _API_SystemParametersInfo($iAction, $iParam=0, $vParam=0, $iWinIni=0)
  Local $aResult

  $aResult = DllCall("user32.dll", "int", "SystemParametersInfo", "int", $iAction, "int", $iParam, "int", $vParam, "int", $iWinIni)
  Return $aResult[0] <> 0
EndFunc
#endRegion
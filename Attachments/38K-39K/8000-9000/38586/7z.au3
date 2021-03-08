#include-once

; #INDEX# ======================================================================
; Title .........: 7z.au3
; Version  ......: 0.1.b
; Language ......: English
; Author(s) .....: dany
; Link ..........:
; Description ...: AutoIt3 API for 7z.dll.
; Remarks .......: BETA! This UDF should NOT be used in public software until a
;                  stable version 1.0 is released.
; ==============================================================================

; #CURRENT# ====================================================================
;_7z_Startup
;_7z_GetVersion
;_7z_CreateObject
;_7z_GetNumberOfMethods
;_7z_GetMethodProperty
;_7z_GetNumberOfFormats
;_7z_GetHandlerProperty
;_7z_GetHandlerProperty2
;_7z_SetLargePageMode
; ==============================================================================

; #INTERNAL_USE_ONLY# ==========================================================
;__7z_Shutdown
;__7z_IsX64
;__7z_IsValidGUID
;__7z_GUIDStructGetPtr
; ==============================================================================

; #CONSTANTS# ==================================================================
Global Const $7Z_VERSION = '0.1.b'

; @error return codes.
Global Enum $E_7Z_DLL_FILE_UNUSABLE = 1, $E_7Z_DLL_UNKNOWN_RETURN_TYPE, _
    $E_7Z_DLL_FUNCTION_NOT_FOUND, $E_7Z_DLL_BAD_NUMBER_OF_PARAMETERS, $E_7Z_DLL_BAD_PARAMETER, _
    $E_7Z_BAD_FUNCTION_ARGUMENT, _
    $E_7Z_DLL_NOT_FOUND, $E_7Z_FAILED_DLL_OPEN, $E_7Z_INVALID_GUID, _
    $E_7Z_X64_INCOMPATIBLE

Global Const $7Z_INTERFACE_UNKNOWN = '00000000-0000-0000-C000-000000000046'
; From CPP\7zip\Guid.txt
; IProgress.h
Global Const $7Z_INTERFACE_PROGRESS = '23170F69-40C1-278A-0000-000500000000'
; IFolderArchive.h
Global Const $7Z_INTERFACE_ARCHIVE_FOLDER = '23170F69-40C1-278A-0000-000500010000'
Global Const $7Z_INTERFACE_FILE_EXTRACT_CALLBACK = '23170F69-40C1-278A-0000-000700010000'
Global Const $7Z_INTERFACE_OUT_FOLDER_ARCHIVE = '23170F69-40C1-278A-0000-000A00010000'
Global Const $7Z_INTERFACE_FOLDER_ARCHIVE_UPDATE_CALLBACK = '23170F69-40C1-278A-0000-000B00010000'
Global Const $7Z_INTERFACE_AGENT = '23170F69-40C1-278A-0000-000C00010000'
Global Const $7Z_INTERFACE_IN_FOLDER_ARCHIVE = '23170F69-40C1-278A-0000-000E00010000'
; IStream.h
Global Const $7Z_INTERFACE_SEQUENTIAL_IN_STREAM = '23170F69-40C1-278A-0000-000100030000'
Global Const $7Z_INTERFACE_SEQUENTIAL_OUT_STREAM = '23170F69-40C1-278A-0000-000200030000'
Global Const $7Z_INTERFACE_IN_STREAM = '23170F69-40C1-278A-0000-000300030000'
Global Const $7Z_INTERFACE_OUT_STREAM = '23170F69-40C1-278A-0000-000400030000'
Global Const $7Z_INTERFACE_STREAM_GET_SIZE = '23170F69-40C1-278A-0000-000600030000'
Global Const $7Z_INTERFACE_OUT_STREAM_FLUSH = '23170F69-40C1-278A-0000-000700030000'
; ICoder.h
Global Const $7Z_INTERFACE_COMPRESS_PROGRESS_INFO = '23170F69-40C1-278A-0000-000400040000'
Global Const $7Z_INTERFACE_COMPRESS_CODER = '23170F69-40C1-278A-0000-000500040000'
Global Const $7Z_INTERFACE_COMPRESS_CODER2 = '23170F69-40C1-278A-0000-001800040000'
Global Const $7Z_INTERFACE_COMPRESS_SET_CODER_PROPERTIES = '23170F69-40C1-278A-0000-002000040000'
Global Const $7Z_INTERFACE_COMPRESS_SET_DECODER_PROPERTIES = '23170F69-40C1-278A-0000-002100040000'
Global Const $7Z_INTERFACE_COMPRESS_SET_DECODER_PROPERTIES2 = '23170F69-40C1-278A-0000-002200040000'
Global Const $7Z_INTERFACE_COMPRESS_WRITE_CODER_PROPERTIES = '23170F69-40C1-278A-0000-002300040000'
Global Const $7Z_INTERFACE_COMPRESS_GET_IN_STREAM_PROCESSED_SIZE = '23170F69-40C1-278A-0000-002400040000'
Global Const $7Z_INTERFACE_COMPRESS_SET_CODER_MT = '23170F69-40C1-278A-0000-002500040000'
Global Const $7Z_INTERFACE_COMPRESS_GET_SUB_STREAM_SIZE = '23170F69-40C1-278A-0000-003000040000'
Global Const $7Z_INTERFACE_COMPRESS_SET_IN_STREAM = '23170F69-40C1-278A-0000-003100040000'
Global Const $7Z_INTERFACE_COMPRESS_SET_OUT_STREAM = '23170F69-40C1-278A-0000-003200040000'
Global Const $7Z_INTERFACE_COMPRESS_SET_IN_STREAM_SIZE = '23170F69-40C1-278A-0000-003300040000'
Global Const $7Z_INTERFACE_COMPRESS_SET_OUT_STREAM_SIZE = '23170F69-40C1-278A-0000-003400040000'
Global Const $7Z_INTERFACE_COMPRESS_SET_BUF_SIZE = '23170F69-40C1-278A-0000-003500040000'
Global Const $7Z_INTERFACE_COMPRESS_FILTER = '23170F69-40C1-278A-0000-004000040000'
Global Const $7Z_INTERFACE_COMPRESS_CODECS_INFO = '23170F69-40C1-278A-0000-006000040000'
Global Const $7Z_INTERFACE_SET_COMPRESS_CODECS_INFO = '23170F69-40C1-278A-0000-006100040000'
Global Const $7Z_INTERFACE_CRYPTO_PROPERTIES = '23170F69-40C1-278A-0000-008000040000'
Global Const $7Z_INTERFACE_CRYPTO_RESET_SALT = '23170F69-40C1-278A-0000-008800040000'
Global Const $7Z_INTERFACE_CRYPTO_RESET_INIT_VECTOR = '23170F69-40C1-278A-0000-008C00040000'
Global Const $7Z_INTERFACE_CRYPTO_SET_PASSWORD = '23170F69-40C1-278A-0000-009000040000'
Global Const $7Z_INTERFACE_CRYPTO_SET_CRC = '23170F69-40C1-278A-0000-00A000040000'
; IPassword.h
Global Const $7Z_INTERFACE_CRYPTO_GET_TEXT_PASSWORD = '23170F69-40C1-278A-0000-001000050000'
Global Const $7Z_INTERFACE_CRYPTO_GET_TEXT_PASSWORD2 = '23170F69-40C1-278A-0000-001100050000'
; IArchive.h
Global Const $7Z_INTERFACE_SET_PROPERTIES = '23170F69-40C1-278A-0000-000300060000'
Global Const $7Z_INTERFACE_ARCHIVE_OPEN_CALLBACK = '23170F69-40C1-278A-0000-001000060000'
Global Const $7Z_INTERFACE_ARCHIVE_EXTRACT_CALLBACK = '23170F69-40C1-278A-0000-002000060000'
Global Const $7Z_INTERFACE_ARCHIVE_OPEN_VOLUME_CALLBACK = '23170F69-40C1-278A-0000-003000060000'
Global Const $7Z_INTERFACE_IN_ARCHIVE_GET_STREAM = '23170F69-40C1-278A-0000-004000060000'
Global Const $7Z_INTERFACE_ARCHIVE_OPEN_SET_SUB_ARCHIVE_NAME = '23170F69-40C1-278A-0000-005000060000'
Global Const $7Z_INTERFACE_IN_ARCHIVE = '23170F69-40C1-278A-0000-006000060000'
Global Const $7Z_INTERFACE_ARCHIVE_OPEN_SEQ = '23170F69-40C1-278A-0000-006100060000'
Global Const $7Z_INTERFACE_ARCHIVE_UPDATE_CALLBACK = '23170F69-40C1-278A-0000-008000060000'
Global Const $7Z_INTERFACE_ARCHIVE_UPDATE_CALLBACK2 = '23170F69-40C1-278A-0000-008200060000'
Global Const $7Z_INTERFACE_OUT_ARCHIVE = '23170F69-40C1-278A-0000-00A000060000'
; IFolder.h
Global Const $7Z_INTERFACE_FOLDER_FOLDER = '23170F69-40C1-278A-0000-000000080000'
Global Const $7Z_INTERFACE_ENUM_PROPERTIES = '23170F69-40C1-278A-0000-000100080000'
Global Const $7Z_INTERFACE_FOLDER_GET_TYPEID = '23170F69-40C1-278A-0000-000200080000'
Global Const $7Z_INTERFACE_FOLDER_GET_PATH = '23170F69-40C1-278A-0000-000300080000'
Global Const $7Z_INTERFACE_FOLDER_WAS_CHANGED = '23170F69-40C1-278A-0000-000400080000'
Global Const $7Z_INTERFACE_FOLDER_OPERATIONS = '23170F69-40C1-278A-0000-000600080000'
Global Const $7Z_INTERFACE_FOLDER_GET_SYSTEM_ICON_INDEX = '23170F69-40C1-278A-0000-000700080000'
Global Const $7Z_INTERFACE_FOLDER_GET_ITEM_FULLSIZE = '23170F69-40C1-278A-0000-000800080000'
Global Const $7Z_INTERFACE_FOLDER_CLONE = '23170F69-40C1-278A-0000-000900080000'
Global Const $7Z_INTERFACE_FOLDER_SET_FLATMODE = '23170F69-40C1-278A-0000-000A00080000'
Global Const $7Z_INTERFACE_FOLDER_OPERATIONS_EXTRACT_CALLBACK = '23170F69-40C1-278A-0000-000B00080000'
Global Const $7Z_INTERFACE_FOLDER_PROPERTIES = '23170F69-40C1-278A-0000-000E00080000'
Global Const $7Z_INTERFACE_FOLDER_ARC_PROPS = '23170F69-40C1-278A-0000-001000080000'
Global Const $7Z_INTERFACE_GET_FOLDER_ARC_PROPS = '23170F69-40C1-278A-0000-001100080000'
; IFolder.h :: FOLDER_MANAGER_INTERFACE
Global Const $7Z_INTERFACE_FOLDER_MANAGER = '23170F69-40C1-278A-0000-000500090000'
; PluginInterface.h
Global Const $7Z_INTERFACE_INIT_CONTEXT_MENU = '23170F69-40C1-278A-0000-0001000A0000'
Global Const $7Z_INTERFACE_PLUGIN_OPTIONS_CALLBACK = '23170F69-40C1-278A-0000-0002000A0000'
Global Const $7Z_INTERFACE_PLUGIN_OPTIONS = '23170F69-40C1-278A-0000-0003000A0000'

; Handler GUIDS.
Global Const $7Z_HANDLER_ZIP = '23170F69-40C1-278A-1000-000110010000'
Global Const $7Z_HANDLER_BZIP2 = '23170F69-40C1-278A-1000-000110020000'
Global Const $7Z_HANDLER_RAR = '23170F69-40C1-278A-1000-000110030000'
Global Const $7Z_HANDLER_ARJ = '23170F69-40C1-278A-1000-000110040000'
Global Const $7Z_HANDLER_Z = '23170F69-40C1-278A-1000-000110050000'
Global Const $7Z_HANDLER_LZH = '23170F69-40C1-278A-1000-000110060000'
Global Const $7Z_HANDLER_7Z = '23170F69-40C1-278A-1000-000110070000'
Global Const $7Z_HANDLER_CAB = '23170F69-40C1-278A-1000-000110080000'
Global Const $7Z_HANDLER_NSIS = '23170F69-40C1-278A-1000-000110090000'
Global Const $7Z_HANDLER_LZMA = '23170F69-40C1-278A-1000-0001100A0000'
Global Const $7Z_HANDLER_LZMA86 = '23170F69-40C1-278A-1000-0001100B0000'
Global Const $7Z_HANDLER_XZ = '23170F69-40C1-278A-1000-0001100C0000'
Global Const $7Z_HANDLER_PPMD = '23170F69-40C1-278A-1000-0001100D0000'

Global Const $7Z_HANDLER_SQUASHFS = '23170F69-40C1-278A-1000-000110D20000'
Global Const $7Z_HANDLER_CRAMFS = '23170F69-40C1-278A-1000-000110D30000'
Global Const $7Z_HANDLER_APM = '23170F69-40C1-278A-1000-000110D40000'
Global Const $7Z_HANDLER_MSLZ = '23170F69-40C1-278A-1000-000110D50000'
Global Const $7Z_HANDLER_FLV = '23170F69-40C1-278A-1000-000110D60000'
Global Const $7Z_HANDLER_SWF = '23170F69-40C1-278A-1000-000110D70000'
Global Const $7Z_HANDLER_SWFC = '23170F69-40C1-278A-1000-000110D80000'
Global Const $7Z_HANDLER_NTFS = '23170F69-40C1-278A-1000-000110D90000'
Global Const $7Z_HANDLER_FAT = '23170F69-40C1-278A-1000-000110DA0000'
Global Const $7Z_HANDLER_MBR = '23170F69-40C1-278A-1000-000110DB0000'
Global Const $7Z_HANDLER_VHD = '23170F69-40C1-278A-1000-000110DC0000'
Global Const $7Z_HANDLER_PE = '23170F69-40C1-278A-1000-000110DD0000'
Global Const $7Z_HANDLER_ELF = '23170F69-40C1-278A-1000-000110DE0000'
Global Const $7Z_HANDLER_MACHO = '23170F69-40C1-278A-1000-000110DF0000'
Global Const $7Z_HANDLER_UDF = '23170F69-40C1-278A-1000-000110E00000'
Global Const $7Z_HANDLER_XAR = '23170F69-40C1-278A-1000-000110E10000'
Global Const $7Z_HANDLER_MUB = '23170F69-40C1-278A-1000-000110E20000'
Global Const $7Z_HANDLER_HFS = '23170F69-40C1-278A-1000-000110E30000'
Global Const $7Z_HANDLER_DMG = '23170F69-40C1-278A-1000-000110E40000'
Global Const $7Z_HANDLER_COMPOUND = '23170F69-40C1-278A-1000-000110E50000'
Global Const $7Z_HANDLER_WIM = '23170F69-40C1-278A-1000-000110E60000'
Global Const $7Z_HANDLER_ISO = '23170F69-40C1-278A-1000-000110E70000'
Global Const $7Z_HANDLER_BKF = '23170F69-40C1-278A-1000-000110E80000'
Global Const $7Z_HANDLER_CHM = '23170F69-40C1-278A-1000-000110E90000'
Global Const $7Z_HANDLER_SPLIT = '23170F69-40C1-278A-1000-000110EA0000'
Global Const $7Z_HANDLER_RPM = '23170F69-40C1-278A-1000-000110EB0000'
Global Const $7Z_HANDLER_DEB = '23170F69-40C1-278A-1000-000110EC0000'
Global Const $7Z_HANDLER_CPIO = '23170F69-40C1-278A-1000-000110ED0000'
Global Const $7Z_HANDLER_TAR = '23170F69-40C1-278A-1000-000110EE0000'
Global Const $7Z_HANDLER_GZIP = '23170F69-40C1-278A-1000-000110EF0000'

; CPP\7zip\PropID.h
Global Const $7Z_PROPID_NO_PROPERTY = 0
Global Const $7Z_PROPID_MAIN_SUB_FILE = 1
Global Const $7Z_PROPID_HANDLER_ITEM_INDEX = 2
Global Const $7Z_PROPID_PATH = 3
Global Const $7Z_PROPID_NAME = 4
Global Const $7Z_PROPID_EXTENSION = 5
Global Const $7Z_PROPID_ISDIR = 6
Global Const $7Z_PROPID_SIZE = 7
Global Const $7Z_PROPID_PACKSIZE = 8
Global Const $7Z_PROPID_ATTRIB = 9
Global Const $7Z_PROPID_CTIME = 10
Global Const $7Z_PROPID_ATIME = 11
Global Const $7Z_PROPID_MTIME = 12
Global Const $7Z_PROPID_SOLID = 13
Global Const $7Z_PROPID_COMMENTED = 14
Global Const $7Z_PROPID_ENCRYPTED = 15
Global Const $7Z_PROPID_SPLIT_BEFORE = 16
Global Const $7Z_PROPID_SPLIT_AFTER = 17
Global Const $7Z_PROPID_DICTIONARY_SIZE = 18
Global Const $7Z_PROPID_CRC = 19
Global Const $7Z_PROPID_TYPE = 20
Global Const $7Z_PROPID_IS_ANTI = 21
Global Const $7Z_PROPID_METHOD = 22
Global Const $7Z_PROPID_HOST_OS = 23
Global Const $7Z_PROPID_FILESYSTEM = 24
Global Const $7Z_PROPID_USER = 25
Global Const $7Z_PROPID_GROUP = 26
Global Const $7Z_PROPID_BLOCK = 27
Global Const $7Z_PROPID_COMMENT = 28
Global Const $7Z_PROPID_POSITION = 29
Global Const $7Z_PROPID_PREFIX = 30
Global Const $7Z_PROPID_NUM_SUB_DIRS = 31
Global Const $7Z_PROPID_NUM_SUB_FILES = 32
Global Const $7Z_PROPID_UNPACK_VER = 33
Global Const $7Z_PROPID_VOLUME = 34
Global Const $7Z_PROPID_IS_VOLUME = 35
Global Const $7Z_PROPID_OFFSET = 36
Global Const $7Z_PROPID_LINKS = 37
Global Const $7Z_PROPID_NUM_BLOCKS = 38
Global Const $7Z_PROPID_NUM_VOLUMES = 39
Global Const $7Z_PROPID_TIME_TYPE = 40
Global Const $7Z_PROPID_BIT64 = 41
Global Const $7Z_PROPID_BIG_ENDIAN = 42
Global Const $7Z_PROPID_CPU = 43
Global Const $7Z_PROPID_PHY_SIZE = 44
Global Const $7Z_PROPID_HEADERS_SIZE = 45
Global Const $7Z_PROPID_CHECKSUM = 46
Global Const $7Z_PROPID_CHARACTS = 47
Global Const $7Z_PROPID_VA = 48
Global Const $7Z_PROPID_ID = 49
Global Const $7Z_PROPID_SHORT_NAME = 50
Global Const $7Z_PROPID_CREATOR_APP = 51
Global Const $7Z_PROPID_SECTOR_SIZE = 52
Global Const $7Z_PROPID_POSIX_ATTRIB = 53
Global Const $7Z_PROPID_LINK = 54
Global Const $7Z_PROPID_ERROR = 55
Global Const $7Z_PROPID_TOTAL_SIZE = 0x1100
Global Const $7Z_PROPID_FREE_SPACE = 0x1101
Global Const $7Z_PROPID_CLUSTER_SIZE = 0x1102
Global Const $7Z_PROPID_VOLUME_NAME = 0x1104
Global Const $7Z_PROPID_LOCAL_NAME = 0x1200
Global Const $7Z_PROPID_PROVIDER = 0x1201
Global Const $7Z_PROPID_USER_DEFINED = 0x10000

; CPP\Common\MyWindows.h
Global Const $7Z_VT_EMPTY = 0
Global Const $7Z_VT_NULL = 1
Global Const $7Z_VT_I2 = 2
Global Const $7Z_VT_I4 = 3
Global Const $7Z_VT_R4 = 4
Global Const $7Z_VT_R8 = 5
Global Const $7Z_VT_CY = 6
Global Const $7Z_VT_DATE = 7
Global Const $7Z_VT_BSTR = 8
Global Const $7Z_VT_DISPATCH = 9
Global Const $7Z_VT_ERROR = 10
Global Const $7Z_VT_BOOL = 11
Global Const $7Z_VT_VARIANT = 12
Global Const $7Z_VT_UNKNOWN = 13
Global Const $7Z_VT_DECIMAL = 14
Global Const $7Z_VT_I1 = 16
Global Const $7Z_VT_UI1 = 17
Global Const $7Z_VT_UI2 = 18
Global Const $7Z_VT_UI4 = 19
Global Const $7Z_VT_I8 = 20
Global Const $7Z_VT_UI8 = 21
Global Const $7Z_VT_INT = 22
Global Const $7Z_VT_UINT = 23
Global Const $7Z_VT_VOID = 24
Global Const $7Z_VT_HRESULT = 25
Global Const $7Z_VT_FILETIME = 64
; ==============================================================================

; #INTERNAL_USE_ONLY# ==========================================================
Global Const $__7Z_INSTALLER_GUI_SFX = '7zSD.sfx' ; Software installer, GUI version.
Global Const $__7Z_INSTALLER_CONSOLE_SFX = '7zS.sfx' ; Software installer, console version.
Global Const $__7Z_SELFEXTRACT_GUI_SFX = '7zS2.sfx' ; Self-extracting archive, GUI version.
Global Const $__7Z_SELFEXTRACT_CONSOLE_SFX = '7zS2con.sfx' ; Self-extracting archive, console version.
; CPP\Common\MyGuidDef.h
Global Const $__7Z_TAG_GUID = 'ulong Data1;ushort Data2;ushort Data3;byte Data4[8]'
; CPP\Common\MyWindows.h
Global Const $__7Z_TAG_PROPVARIANT = 'ushort vt;word wReserved1;word wReserved2;word wReserved3;byte[16]'

Global $__7z_sDLL = '7z.dll'
Global $__7z_sDLLDir = @ScriptDir & '\Res\'
Global $__7z_sDLLPath = $__7z_sDLLDir & $__7z_sDLL
Global $__7z_hDLL = -1
; ==============================================================================

; #FUNCTION# ===================================================================
; Name...........: _7z_Startup
; Description ...: Loads 7z.dll.
; Syntax.........: _7z_Startup([$sDLLPath])
; Parameters ....: $sDLLPath - String: Path to 7z.dll. Default @ScriptDir & '\Res\7z.dll'.
; Return values .: Success - Int: Returns 1.
;                  Failure - Int: Returns 0 and sets @error:
;                  |7 $E_7Z_DLL_NOT_FOUND 7z.dll not found.
;                  |8 $E_7Z_FAILED_DLL_OPEN Failed to open 7z.dll.
;                  |10 $E_7Z_X64_INCOMPATIBLE 7z.dll is not 64-bit.
; Author ........: dany
; Modified ......:
; Remarks .......: OnAutoItExitRegisters __7z_Shutdown.
; Related .......:
; ==============================================================================
Func _7z_Startup($sDLLPath = Default)
    If -1 <> $__7z_hDLL Then Return 1
    If Not IsString($sDLLPath) Or '' = $sDLLPath Then $sDLLPath = $__7z_sDLLPath
    $sDLLPath = StringReplace($sDLLPath, '/', '\')
    If Not FileExists($sDLLPath) Then
        $sDLLPath = $__7z_sDLLPath
        If Not FileExists($sDLLPath) Then
            $sDLLPath = $__7z_sDLL ; Use PATH.
            If Not FileExists($sDLLPath) Then Return SetError($E_7Z_DLL_NOT_FOUND, 0, 0)
        EndIf
    EndIf
    If @AutoItX64 And Not __7z_IsX64($sDLLPath) Then Return SetError($E_7Z_X64_INCOMPATIBLE, 0, 0)
    $__7z_hDLL = DllOpen($sDLLPath)
    If @error Then Return SetError($E_7Z_FAILED_DLL_OPEN, 0, 0)
    $__7z_sDLLPath = $sDLLPath
    $__7z_sDLL = StringTrimLeft($__7z_sDLLPath, StringInStr($__7z_sDLLPath, '\', 2, -1))
    $__7z_sDLLDir = StringLeft($__7z_sDLLPath, StringInStr($__7z_sDLLPath, '\', 2, -1) - 1)
    If '' <> $__7z_sDLLDir Then $__7z_sDLLDir &= '\'
    OnAutoItExitRegister('__7z_Shutdown')
    Return 1
EndFunc   ;==>_7z_Startup

; #FUNCTION# ===================================================================
; Name...........: _7z_GetVersion
; Description ...: Get 7z.dll version number.
; Syntax.........: _7z_GetVersion()
; Parameters ....:
; Return values .: Success - String: 7z.dll file version.
;                  Failure - String: Returns 0.0.0.0 and sets @error to 1.
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7z_GetVersion()
    Return FileGetVersion($__7z_sDLLPath)
EndFunc   ;==>_7z_GetVersion

; #FUNCTION# ===================================================================
; Name...........: _7z_CreateObject
; Description ...: Create a 7z COM object.
; Syntax.........: _7z_CreateObject($sGUID, $sInterfaceID)
; Parameters ....: $sGUID  - String:
;                  $sInterfaceID - String:
; Return values .: Success - Object: A 7z COM object.
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7Z_DLL_FILE_UNUSABLE Unable to use the DLL file.
;                  |2 $E_7Z_DLL_UNKNOWN_RETURN_TYPE Unknown return type.
;                  |3 $E_7Z_DLL_FUNCTION_NOT_FOUND Function not found in the DLL file.
;                  |4 $E_7Z_DLL_BAD_NUMBER_OF_PARAMETERS Bad number of parameters.
;                  |5 $E_7Z_DLL_BAD_PARAMETER Bad parameter.
;                  |6 $E_7Z_BAD_FUNCTION_ARGUMENT Bad function argument.
;                  |7 $E_7Z_DLL_NOT_FOUND 7z.dll not found.
;                  |8 $E_7Z_FAILED_DLL_OPEN Failed to open 7z.dll.
;                  |9 $E_7Z_INVALID_GUID Invalid 7z GUID.
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7z_CreateObject($sGUID, $sInterfaceID)
    If Not IsString($sGUID) Or Not IsString($sInterfaceID) Then Return SetError($E_7Z_BAD_FUNCTION_ARGUMENT, 0, 0)
    If Not __7z_IsValidGUID($sGUID) Or Not __7z_IsValidGUID($sInterfaceID) Then Return SetError($E_7Z_INVALID_GUID, 0, 0)
    If Not _7z_Startup() Then Return SetError(@error, 0, 0)
    Local $aRes, $pGUID, $pInterface
    $pGUID = __7z_GUIDStructGetPtr($sGUID)
    $pInterface = __7z_GUIDStructGetPtr($sInterfaceID)
    $aRes = DllCall($__7z_hDLL, 'uint', 'CreateObject', 'struct*', $pGUID, 'struct*', $pInterface, 'ptr*', 0)
    If @error Then Return SetError(@error, 0, 0)
    Return $aRes[3]
EndFunc   ;==>_7z_CreateObject

; #FUNCTION# ===================================================================
; Name...........: _7z_GetNumberOfMethods
; Description ...: Get the number of available 7z methods.
; Syntax.........: _7z_GetNumberOfMethods()
; Parameters ....:
; Return values .: Success - Int: Number of 7z methods.
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7Z_DLL_FILE_UNUSABLE Unable to use the DLL file.
;                  |2 $E_7Z_DLL_UNKNOWN_RETURN_TYPE Unknown return type.
;                  |3 $E_7Z_DLL_FUNCTION_NOT_FOUND Function not found in the DLL file.
;                  |4 $E_7Z_DLL_BAD_NUMBER_OF_PARAMETERS Bad number of parameters.
;                  |5 $E_7Z_DLL_BAD_PARAMETER Bad parameter.
;                  |7 $E_7Z_DLL_NOT_FOUND 7z.dll not found.
;                  |8 $E_7Z_FAILED_DLL_OPEN Failed to open 7z.dll.
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7z_GetNumberOfMethods()
    If Not _7z_Startup() Then Return SetError(@error, 0, 0)
    Local $aRes = DllCall($__7z_hDLL, 'uint', 'GetNumberOfMethods', 'uint*', 0)
    If @error Then Return SetError(@error, 0, 0)
    Return $aRes[1]
EndFunc   ;==>_7z_GetNumberOfMethods

; #FUNCTION# ===================================================================
; Name...........: _7z_GetMethodProperty
; Description ...:
; Syntax.........: _7z_GetMethodProperty($iIndex, $iPropID)
; Parameters ....: $iIndex - Int:
;                  $iPropID - Int:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7Z_DLL_FILE_UNUSABLE Unable to use the DLL file.
;                  |2 $E_7Z_DLL_UNKNOWN_RETURN_TYPE Unknown return type.
;                  |3 $E_7Z_DLL_FUNCTION_NOT_FOUND Function not found in the DLL file.
;                  |4 $E_7Z_DLL_BAD_NUMBER_OF_PARAMETERS Bad number of parameters.
;                  |5 $E_7Z_DLL_BAD_PARAMETER Bad parameter.
;                  |6 $E_7Z_BAD_FUNCTION_ARGUMENT Bad function argument.
;                  |7 $E_7Z_DLL_NOT_FOUND 7z.dll not found.
;                  |8 $E_7Z_FAILED_DLL_OPEN Failed to open 7z.dll.
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7z_GetMethodProperty($iIndex, $iPropID)
    If Not IsInt($iIndex) Or Not IsInt($iPropID) Then Return SetError($E_7Z_BAD_FUNCTION_ARGUMENT, 0, 0)
    If Not _7z_Startup() Then Return SetError(@error, 0, 0)
    Local $aRes, $tPropVariant = DllStructCreate($__7Z_TAG_PROPVARIANT)
    $aRes = DllCall($__7z_hDLL, 'uint', 'GetMethodProperty', 'uint', $iIndex, 'ulong', $sPropID, 'ptr*', $tPropVariant)
    If @error Then Return SetError(@error, 0, 0)
    Return $aRes[3]
EndFunc   ;==>_7z_GetMethodProperty

; #FUNCTION# ===================================================================
; Name...........: _7z_GetNumberOfFormats
; Description ...: Get the number of available 7z formats.
; Syntax.........: _7z_GetNumberOfFormats()
; Parameters ....:
; Return values .: Success - Int: Number of available 7z formats.
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7Z_DLL_FILE_UNUSABLE Unable to use the DLL file.
;                  |2 $E_7Z_DLL_UNKNOWN_RETURN_TYPE Unknown return type.
;                  |3 $E_7Z_DLL_FUNCTION_NOT_FOUND Function not found in the DLL file.
;                  |4 $E_7Z_DLL_BAD_NUMBER_OF_PARAMETERS Bad number of parameters.
;                  |5 $E_7Z_DLL_BAD_PARAMETER Bad parameter.
;                  |7 $E_7Z_DLL_NOT_FOUND 7z.dll not found.
;                  |8 $E_7Z_FAILED_DLL_OPEN Failed to open 7z.dll.
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7z_GetNumberOfFormats()
    If Not _7z_Startup() Then Return SetError(@error, 0, 0)
    Local $aRes = DllCall($__7z_hDLL, 'uint', 'GetNumberOfFormats', 'uint*', 0)
    If @error Then Return SetError(@error, 0, 0)
    Return $aRes[1]
EndFunc   ;==>_7z_GetNumberOfFormats

; #FUNCTION# ===================================================================
; Name...........: _7z_GetHandlerProperty
; Description ...:
; Syntax.........: _7z_GetHandlerProperty($iPropID)
; Parameters ....: $iPropID - Int:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7Z_DLL_FILE_UNUSABLE Unable to use the DLL file.
;                  |2 $E_7Z_DLL_UNKNOWN_RETURN_TYPE Unknown return type.
;                  |3 $E_7Z_DLL_FUNCTION_NOT_FOUND Function not found in the DLL file.
;                  |4 $E_7Z_DLL_BAD_NUMBER_OF_PARAMETERS Bad number of parameters.
;                  |5 $E_7Z_DLL_BAD_PARAMETER Bad parameter.
;                  |6 $E_7Z_BAD_FUNCTION_ARGUMENT Bad function argument.
;                  |7 $E_7Z_DLL_NOT_FOUND 7z.dll not found.
;                  |8 $E_7Z_FAILED_DLL_OPEN Failed to open 7z.dll.
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7z_GetHandlerProperty($iPropID)
    If Not IsInt($iPropID) Then Return SetError($E_7Z_BAD_FUNCTION_ARGUMENT, 0, 0)
    If Not _7z_Startup() Then Return SetError(@error, 0, 0)
    Local $aRes, $tPropVariant = DllStructCreate($__7Z_TAG_PROPVARIANT)
    $aRes = DllCall($__7z_hDLL, 'uint', 'GetHandlerProperty', 'ulong', $sPropID, 'ptr*', $tPropVariant)
    If @error Then Return SetError(@error, 0, 0)
    Return $aRes[2]
EndFunc   ;==>_7z_GetHandlerProperty

; #FUNCTION# ===================================================================
; Name...........: _7z_GetHandlerProperty2
; Description ...:
; Syntax.........: _7z_GetHandlerProperty2($iIndex, $iPropID)
; Parameters ....: $iIndex - Int:
;                  $iPropID - Int:
; Return values .: Success -
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7Z_DLL_FILE_UNUSABLE Unable to use the DLL file.
;                  |2 $E_7Z_DLL_UNKNOWN_RETURN_TYPE Unknown return type.
;                  |3 $E_7Z_DLL_FUNCTION_NOT_FOUND Function not found in the DLL file.
;                  |4 $E_7Z_DLL_BAD_NUMBER_OF_PARAMETERS Bad number of parameters.
;                  |5 $E_7Z_DLL_BAD_PARAMETER Bad parameter.
;                  |6 $E_7Z_BAD_FUNCTION_ARGUMENT Bad function argument.
;                  |7 $E_7Z_DLL_NOT_FOUND 7z.dll not found.
;                  |8 $E_7Z_FAILED_DLL_OPEN Failed to open 7z.dll.
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7z_GetHandlerProperty2($iIndex, $iPropID)
    If Not IsInt($iIndex) Or Not IsInt($iPropID) Then Return SetError($E_7Z_BAD_FUNCTION_ARGUMENT, 0, 0)
    If Not _7z_Startup() Then Return SetError(@error, 0, 0)
    Local $aRes, $tPropVariant = DllStructCreate($__7Z_TAG_PROPVARIANT)
    $aRes = DllCall($__7z_hDLL, 'uint', 'GetHandlerProperty2', 'uint', $iIndex, 'ulong', $sPropID, 'ptr*', $tPropVariant)
    If @error Then Return SetError(@error, 0, 0)
    Return $aRes[3]
EndFunc   ;==>_7z_GetHandlerProperty2

; #FUNCTION# ===================================================================
; Name...........: _7z_SetLargePageMode
; Description ...:
; Syntax.........: _7z_SetLargePageMode()
; Parameters ....:
; Return values .: Success - Int: Returns 1.
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 $E_7Z_DLL_FILE_UNUSABLE Unable to use the DLL file.
;                  |2 $E_7Z_DLL_UNKNOWN_RETURN_TYPE Unknown return type.
;                  |3 $E_7Z_DLL_FUNCTION_NOT_FOUND Function not found in the DLL file.
;                  |4 $E_7Z_DLL_BAD_NUMBER_OF_PARAMETERS Bad number of parameters.
;                  |5 $E_7Z_DLL_BAD_PARAMETER Bad parameter.
;                  |7 $E_7Z_DLL_NOT_FOUND 7z.dll not found.
;                  |8 $E_7Z_FAILED_DLL_OPEN Failed to open 7z.dll.
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......:
; ==============================================================================
Func _7z_SetLargePageMode()
    If Not _7z_Startup() Then Return SetError(@error, 0, 0)
    DllCall($__7z_hDLL, 'uint', 'SetLargePageMode')
    If @error Then Return SetError(@error, 0, 0)
    Return 1
EndFunc   ;==>_7z_SetLargePageMode

; #INTERNAL_USE_ONLY# ==========================================================
; Name...........: __7z_Shutdown
; Description ...: Unloads 7z.dll.
; Syntax.........: __7z_Shutdown()
; Parameters ....:
; Return values .:
; Author ........: dany
; Modified ......:
; Remarks .......: For Internal Use Only. OnAutoItRegistered by _7z_Startup().
; Related .......:
; ==============================================================================
Func __7z_Shutdown()
    If -1 <> $__7z_hDLL Then DllClose($__7z_hDLL)
EndFunc   ;==>__7z_Shutdown

; #INTERNAL_USE_ONLY# ==========================================================
; Name...........: __7z_IsX64
; Description ...: Check bitness of 7z.dll.
; Syntax.........: __7z_IsX64($sDLLPath)
; Parameters ....: $sDLLPath - String: Path to 7z.dll.
; Return values .:
; Author ........: SmOke_N
; Modified ......: dany
; Remarks .......: For Internal Use Only. Simplified return codes.
;                  |See http://www.autoitscript.com/forum/topic/144318-how-to-tell-if-a-exe-or-dll-is-x64-or-x86/#entry1017329
; Related .......:
; ==============================================================================
Func __7z_IsX64($sDLLPath)
    Local $sSZType, $hBinary = FileOpen($sDLLPath, 16)
    If $hBinary = -1 Then Return 0
    If BinaryToString(FileRead($hBinary, 2)) <> 'MZ' Then
        FileClose($hBinary)
        Return 0
    EndIf
    FileSetPos($hBinary, 60, 0)
    $sSZType = FileRead($hBinary, 4)
    FileSetPos($hBinary, Number($sSZType) + 4, 0)
    $sSZType = FileRead($hBinary, 2)
    FileClose($hBinary)
    Switch $sSZType
        Case '0x6486'
            Return 1
        Case '0x0002'
            Return 1
        Case '0x4C01'
            Return 0
    EndSwitch
    Return 0
EndFunc   ;==>__7z_IsX64

; #INTERNAL_USE_ONLY# ==========================================================
; Name...........: __7z_IsValidGUID
; Description ...: Check if a string is a valid 7z GUID.
; Syntax.........: __7z_IsValidGUID($sGUID)
; Parameters ....: $sGUID  - String: A 7z GUID.
; Return values .: Int: Returns 1 or 0.
; Author ........: dany
; Modified ......:
; Remarks .......: For Internal Use Only.
; Related .......:
; ==============================================================================
Func __7z_IsValidGUID($sGUID)
    If $7Z_INTERFACE_UNKNOWN = $sGUID Then Return 1
    Return StringRegExp($sGUID, '^23170F69-40C1-278A-0000-[[:xdigit:]]{12}$')
EndFunc   ;==>__7z_IsValidGUID

; #INTERNAL_USE_ONLY# ==========================================================
; Name...........: __7z_GUIDStructGetPtr
; Description ...: Get a pointer to a 7z GUID Struct.
; Syntax.........: __7z_GUIDStructGetPtr($sGUID)
; Parameters ....: $sGUID  - String: A 7z GUID.
; Return values .: Ptr: A pointer to a 7z GUID Struct.
; Author ........: dany
; Modified ......:
; Remarks .......: For Internal Use Only.
; Related .......:
; ==============================================================================
Func __7z_GUIDStructGetPtr($sGUID)
    Local $tGUID, $aGUID = StringSplit($sGUID, '-')
    $tGUID = DllStructCreate($__7Z_TAG_GUID)
    DllStructSetData($tGUID, 'Data1', Dec($aGUID[1]))
    DllStructSetData($tGUID, 'Data2', Dec($aGUID[2]))
    DllStructSetData($tGUID, 'Data3', Dec($aGUID[3]))
    DllStructSetData($tGUID, 'Data4', Dec($aGUID[4] & $aGUID[5]))
    Return $tGUID;DllStructGetPtr($tGUID)
EndFunc   ;==>__7z_GUIDStructGetPtr

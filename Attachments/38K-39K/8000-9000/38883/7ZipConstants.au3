#include-once

; #INDEX# ======================================================================
; Title .........: 7ZipConstants.au3
; Version  ......: 1.0
; Language ......: English
; Author(s) .....: dany
; Link ..........:
; Description ...: Constants for 7Zip.au3.
; Remarks .......:
; ==============================================================================

#Region Public constants and variables.
; src\7-zip32.h
; String: EXTRACTINGINFO Structure.
Global Const $7ZIP_TAG_EXTRACTINGINFO = 'dword dwFileSize;' & _
        'dword dwWriteSize;' & _
        'char szSourceFileName[' & ($7ZIP_FNAME_MAX32 + 1) & '];' & _
        'char dummy1[3];' & _
        'char szDestFileName[' & ($7ZIP_FNAME_MAX32 + 1) & '];' & _
        'char dummy[3]'

; src\7-zip32.h
; String: EXTRACTINGINFOEX Structure.
Global Const $7ZIP_TAG_EXTRACTINGINFOEX = 'struct;' & $7ZIP_TAG_EXTRACTINGINFO & ';endstruct exinfo;' & _
        'dword dwCompressedSize;' & _
        'dword dwCRC;' & _
        'uint uOSType;' & _
        'word wRatio;' & _
        'word wDate;' & _
        'word wTime;' & _
        'char szAttribute[8];' & _
        'char szMode[8]'

; src\7-zip32.h
; String: EXTRACTINGINFOEX32 Structure.
Global Const $7ZIP_TAG_EXTRACTINGINFOEX32 = 'dword dwStructSize;' & _
        'struct;' & $7ZIP_TAG_EXTRACTINGINFO & ';endstruct exinfo;' & _
        'dword dwFileSize;' & _
        'dword dwCompressedSize;' & _
        'dword dwWriteSize;' & _
        'dword dwAttributes;' & _
        'dword dwCRC;' & _
        'uint uOSType;' & _
        'word wRatio;' & _
        $7ZIP_TAG_FILETIME & ' ftCreateTime;' & _
        $7ZIP_TAG_FILETIME & ' ftAccessTime;' & _
        $7ZIP_TAG_FILETIME & ' ftWriteTime;' & _
        'char szMode[8];' & _
        'char szSourceFileName[' & ($7ZIP_FNAME_MAX32 + 1) & '];' & _
        'char dummy1[3];' & _
        'char szDestFileName[' & ($7ZIP_FNAME_MAX32 + 1) & '];' & _
        'char dummy2[3]'

; src\7-zip32.h
; String: EXTRACTINGINFOEX64 Structure.
Global Const $7ZIP_TAG_EXTRACTINGINFOEX64 = 'dword dwStructSize;' & _
        'struct;' & $7ZIP_TAG_EXTRACTINGINFO & ';endstruct exinfo;' & _
        'int64 llFileSize;' & _
        'int64 llCompressedSize;' & _
        'int64 llWriteSize;' & _
        'dword dwAttributes;' & _
        'dword dwCRC;' & _
        'uint uOSType;' & _
        'word wRatio;' & _
        $7ZIP_TAG_FILETIME & ' ftCreateTime;' & _
        $7ZIP_TAG_FILETIME & ' ftAccessTime;' & _
        $7ZIP_TAG_FILETIME & ' ftWriteTime;' & _
        'char szMode[8];' & _
        'char szSourceFileName[' & ($7ZIP_FNAME_MAX32 + 1) & '];' & _
        'char dummy1[3];' & _
        'char szDestFileName[' & ($7ZIP_FNAME_MAX32 + 1) & '];' & _
        'char dummy2[3]'

; #CONSTANTS# ==================================================================
; Name...........: $7ZIP_ERROR_*
; Description ...: 7-Zip error return constants.
; Author ........: dany
; Modified ......:
; Remarks .......: src\7-zip32.h
; Related .......:
; ==============================================================================
Global Const $7ZIP_ERROR_DISK_SPACE = 0x8005
Global Const $7ZIP_ERROR_READ_ONLY = 0x8006
Global Const $7ZIP_ERROR_USER_SKIP = 0x8007
Global Const $7ZIP_ERROR_UNKNOWN_TYPE = 0x8008
Global Const $7ZIP_ERROR_METHOD = 0x8009
Global Const $7ZIP_ERROR_PASSWORD_FILE = 0x800A
Global Const $7ZIP_ERROR_VERSION = 0x800B
Global Const $7ZIP_ERROR_FILE_CRC = 0x800C
Global Const $7ZIP_ERROR_FILE_OPEN = 0x800D
Global Const $7ZIP_ERROR_MORE_FRESH = 0x800E
Global Const $7ZIP_ERROR_NOT_EXIST = 0x800F
Global Const $7ZIP_ERROR_ALREADY_EXIST = 0x8010
Global Const $7ZIP_ERROR_TOO_MANY_FILES = 0x8011
Global Const $7ZIP_ERROR_MAKE_DIRECTORY = 0x8012
Global Const $7ZIP_ERROR_CANNOT_WRITE = 0x8013
Global Const $7ZIP_ERROR_HUFFMAN_CODE = 0x8014
Global Const $7ZIP_ERROR_COMMENT_HEADER = 0x8015
Global Const $7ZIP_ERROR_HEADER_CRC = 0x8016
Global Const $7ZIP_ERROR_HEADER_BROKEN = 0x8017
Global Const $7ZIP_ERROR_ARC_FILE_OPEN = 0x8018
Global Const $7ZIP_ERROR_NOT_ARC_FILE = 0x8019
Global Const $7ZIP_ERROR_CANNOT_READ = 0x801A
Global Const $7ZIP_ERROR_FILE_STYLE = 0x801B
Global Const $7ZIP_ERROR_COMMAND_NAME = 0x801C
Global Const $7ZIP_ERROR_MORE_HEAP_MEMORY = 0x801D
Global Const $7ZIP_ERROR_ENOUGH_MEMORY = 0x801E
Global Const $7ZIP_ERROR_ALREADY_RUNNING = 0x801F
Global Const $7ZIP_ERROR_USER_CANCEL = 0x8020
Global Const $7ZIP_ERROR_HARC_IS_NOT_OPENED = 0x8021
Global Const $7ZIP_ERROR_NOT_SEARCH_MODE = 0x8022
Global Const $7ZIP_ERROR_NOT_SUPPORT = 0x8023
Global Const $7ZIP_ERROR_TIME_STAMP = 0x8024
Global Const $7ZIP_ERROR_TMP_OPEN = 0x8025
Global Const $7ZIP_ERROR_LONG_FILE_NAME = 0x8026
Global Const $7ZIP_ERROR_ARC_READ_ONLY = 0x8027
Global Const $7ZIP_ERROR_SAME_NAME_FILE = 0x8028
Global Const $7ZIP_ERROR_NOT_FIND_ARC_FILE = 0x8029
Global Const $7ZIP_ERROR_RESPONSE_READ = 0x802A
Global Const $7ZIP_ERROR_NOT_FILENAME = 0x802B
Global Const $7ZIP_ERROR_TMP_COPY = 0x802C
Global Const $7ZIP_ERROR_EOF = 0x802D
Global Const $7ZIP_ERROR_ADD_TO_LARC = 0x802E
Global Const $7ZIP_ERROR_TMP_BACK_SPACE = 0x802F
Global Const $7ZIP_ERROR_SHARING = 0x8030
Global Const $7ZIP_ERROR_NOT_FIND_FILE = 0x8031
Global Const $7ZIP_ERROR_LOG_FILE = 0x8032
Global Const $7ZIP_ERROR_NO_DEVICE = 0x8033
Global Const $7ZIP_ERROR_GET_ATTRIBUTES = 0x8034
Global Const $7ZIP_ERROR_SET_ATTRIBUTES = 0x8035
Global Const $7ZIP_ERROR_GET_INFORMATION = 0x8036
Global Const $7ZIP_ERROR_GET_POINT = 0x8037
Global Const $7ZIP_ERROR_SET_POINT = 0x8038
Global Const $7ZIP_ERROR_CONVERT_TIME = 0x8039
Global Const $7ZIP_ERROR_GET_TIME = 0x803a
Global Const $7ZIP_ERROR_SET_TIME = 0x803b
Global Const $7ZIP_ERROR_CLOSE_FILE = 0x803c
Global Const $7ZIP_ERROR_HEAP_MEMORY = 0x803d
Global Const $7ZIP_ERROR_HANDLE = 0x803e
Global Const $7ZIP_ERROR_TIME_STAMP_RANGE = 0x803f
Global Const $7ZIP_ERROR_MAKE_ARCHIVE = 0x8040
Global Const $7ZIP_ERROR_NOT_CONFIRM_NAME = 0x8041
Global Const $7ZIP_ERROR_UNEXPECTED_EOF = 0x8042
Global Const $7ZIP_ERROR_INVALID_END_MARK = 0x8043
Global Const $7ZIP_ERROR_INVOLVED_LZH = 0x8044
Global Const $7ZIP_ERROR_NO_END_MARK = 0x8045
Global Const $7ZIP_ERROR_HDR_INVALID_SIZE = 0x8046
Global Const $7ZIP_ERROR_UNKNOWN_LEVEL = 0x8047
Global Const $7ZIP_ERROR_BROKEN_DATA = 0x8048
Global Const $7ZIP_ERROR_WARNING = 0x8101
Global Const $7ZIP_ERROR_FATAL = 0x8102
Global Const $7ZIP_ERROR_DURING_DECOMPRESSION = 0x8103
Global Const $7ZIP_ERROR_DIR_FILE_WIDTH_64BIT_SIZE = 0x8104
Global Const $7ZIP_ERROR_FILE_CHANGED_DURING_OPERATION = 0x8105

; #CONSTANTS# ==================================================================
; Name...........: $7ZIP_ATTR_*
; Description ...: 7-Zip file attribute constants.
; Author ........: dany
; Modified ......:
; Remarks .......: src\7-zip32.h
; Related .......: _7Zip_GetAttribute
; ==============================================================================
Global Const $7ZIP_ATTR_READONLY = 0x01 ; Readonly file.
Global Const $7ZIP_ATTR_HIDDEN = 0x02 ; Hidden file.
Global Const $7ZIP_ATTR_SYSTEM = 0x04 ; System file.
Global Const $7ZIP_ATTR_LABEL = 0x08 ; Volume label.
Global Const $7ZIP_ATTR_DIRECTORY = 0x10 ; Directory.
Global Const $7ZIP_ATTR_ARCHIVE = 0x20 ; Archived file.
Global Const $7ZIP_ATTR_ENCRYPTED = 0x40 ; Encrypted file.

; #CONSTANTS# ==================================================================
; Name...........: $7ZIP_CHECKARCHIVE_*
; Description ...: 7-Zip check archive constants.
; Author ........: dany
; Modified ......:
; Remarks .......: src\7-zip32.h
; Related .......: _7Zip_CheckArchive
; ==============================================================================
Global Const $7ZIP_CHECKARCHIVE_RAPID = 0
Global Const $7ZIP_CHECKARCHIVE_BASIC = 1
Global Const $7ZIP_CHECKARCHIVE_FULLCRC = 2
Global Const $7ZIP_CHECKARCHIVE_RECOVERY = 4
Global Const $7ZIP_CHECKARCHIVE_SFX = 8
Global Const $7ZIP_CHECKARCHIVE_ALL = 16
Global Const $7ZIP_CHECKARCHIVE_ENDDATA = 32

; #CONSTANTS# ==================================================================
; Name...........: $7ZIP_ARCHIVETYPE_*
; Description ...: 7-Zip archive type constants.
; Author ........: dany
; Modified ......:
; Remarks .......: src\7-zip32.h
; Related .......: _7Zip_GetArchiveType
; ==============================================================================
Global Const $7ZIP_ARCHIVETYPE_UNKNOWN = 0
Global Const $7ZIP_ARCHIVETYPE_ZIP = 1
Global Const $7ZIP_ARCHIVETYPE_7Z = 2

; #CONSTANTS# ==================================================================
; Name...........: $7ZIP_M_*
; Description ...: 7-Zip open archive mode constants.
; Author ........: dany
; Modified ......:
; Remarks .......: src\7-zip32.h
; Related .......: _7Zip_OpenArchive
; ==============================================================================
Global Const $7ZIP_M_INIT_FILE_USE = 0x00000001
Global Const $7ZIP_M_REGARDLESS_INIT_FILE = 0x00000002
Global Const $7ZIP_M_NO_BACKGROUND_MODE = 0x00000004
Global Const $7ZIP_M_NOT_USE_TIME_STAMP = 0x00000008
Global Const $7ZIP_M_EXTRACT_REPLACE_FILE = 0x00000010
Global Const $7ZIP_M_EXTRACT_NEW_FILE = 0x00000020
Global Const $7ZIP_M_EXTRACT_UPDATE_FILE = 0x00000040
Global Const $7ZIP_M_CHECK_ALL_PATH = 0x00000100
Global Const $7ZIP_M_CHECK_FILENAME_ONLY = 0x00000200
Global Const $7ZIP_M_CHECK_DISK_SIZE = 0x00000400
Global Const $7ZIP_M_REGARDLESS_DISK_SIZE = 0x00000800
Global Const $7ZIP_M_USE_DRIVE_LETTER = 0x00001000
Global Const $7ZIP_M_NOT_USE_DRIVE_LETTER = 0x00002000
Global Const $7ZIP_M_INQUIRE_DIRECTORY = 0x00004000
Global Const $7ZIP_M_NOT_INQUIRE_DIRECTORY = 0x00008000
Global Const $7ZIP_M_INQUIRE_WRITE = 0x00010000
Global Const $7ZIP_M_NOT_INQUIRE_WRITE = 0x00020000
Global Const $7ZIP_M_CHECK_READONLY = 0x00040000
Global Const $7ZIP_M_REGARDLESS_READONLY = 0x00080000
Global Const $7ZIP_M_REGARD_E_COMMAND = 0x00100000
Global Const $7ZIP_M_REGARD_X_COMMAND = 0x00200000
Global Const $7ZIP_M_ERROR_MESSAGE_ON = 0x00400000
Global Const $7ZIP_M_ERROR_MESSAGE_OFF = 0x00800000
Global Const $7ZIP_M_BAR_WINDOW_ON = 0x01000000
Global Const $7ZIP_M_BAR_WINDOW_OFF = 0x02000000
Global Const $7ZIP_M_CHECK_PATH = 0x04000000
Global Const $7ZIP_M_RECOVERY_ON = 0x08000000
Global Const $7ZIP_M_MAKE_INDEX_FILE = 0x10000000
Global Const $7ZIP_M_NOT_MAKE_INDEX_FILE = 0x20000000
Global Const $7ZIP_M_EXTRACT_FOUND_FILE = 0x40000000
Global Const $7ZIP_M_EXTRACT_NAMED_FILE = 0x80000000

; #CONSTANTS# ==================================================================
; Name...........: $7ZIP_OSTYPE_*
; Description ...: 7-Zip OS type constants.
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......: _7Zip_GetOSType
; ==============================================================================
Global Const $7ZIP_OSTYPE_UNKNOWN = -1
Global Const $7ZIP_OSTYPE_MS_DOS = 0
Global Const $7ZIP_OSTYPE_PRIMOS = 1
Global Const $7ZIP_OSTYPE_UNIX = 2
Global Const $7ZIP_OSTYPE_AMIGA = 3
Global Const $7ZIP_OSTYPE_MAC_OS = 4
Global Const $7ZIP_OSTYPE_OS2 = 5
Global Const $7ZIP_OSTYPE_APPLE_GS = 6
Global Const $7ZIP_OSTYPE_ATARI_ST = 7
Global Const $7ZIP_OSTYPE_NEXT = 8
Global Const $7ZIP_OSTYPE_VAX_VMS = 9
Global Const $7ZIP_OSTYPE_OTHERS = 10 ; その他。
Global Const $7ZIP_OSTYPE_OS9 = 11
Global Const $7ZIP_OSTYPE_OS68K = 12
Global Const $7ZIP_OSTYPE_OS386 = 13
Global Const $7ZIP_OSTYPE_HUMAN = 14
Global Const $7ZIP_OSTYPE_CPM = 15
Global Const $7ZIP_OSTYPE_FLEX = 16
Global Const $7ZIP_OSTYPE_RUNSER = 17
Global Const $7ZIP_OSTYPE_VM_CMS = 18
Global Const $7ZIP_OSTYPE_Z_SYSTEM = 19
Global Const $7ZIP_OSTYPE_TOPS20 = 20
Global Const $7ZIP_OSTYPE_WINDOWS_NTFS = 21

; #CONSTANTS# ==================================================================
; Name...........: $7ZIP_PRIORITY_*
; Description ...: 7-Zip priority constants.
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......: _7Zip_SetPriority
; ==============================================================================
Global Const $7ZIP_PRIORITY_IDLE = -15
Global Const $7ZIP_PRIORITY_NORMAL = 0

; #CONSTANTS# ==================================================================
; Name...........: $7ZIP_QUERY_*
; Description ...: 7-Zip query function constants.
; Author ........: dany
; Modified ......:
; Remarks .......: src\7-zip32.h
; Related .......: _7Zip_QueryFunctionList
; ==============================================================================
Global Const $7ZIP_QUERY_RUN = 0 ; ISARC
Global Const $7ZIP_QUERY_GET_VERSION = 1
Global Const $7ZIP_QUERY_GET_CURSOR_INTERVAL = 2
Global Const $7ZIP_QUERY_SET_CURSOR_INTERVAL = 3
Global Const $7ZIP_QUERY_GET_BACK_GROUND_MODE = 4
Global Const $7ZIP_QUERY_SET_BACK_GROUND_MODE = 5
Global Const $7ZIP_QUERY_GET_CURSOR_MODE = 6
Global Const $7ZIP_QUERY_SET_CURSOR_MODE = 7
Global Const $7ZIP_QUERY_GET_RUNNING = 8
Global Const $7ZIP_QUERY_CHECK_ARCHIVE = 16
Global Const $7ZIP_QUERY_CONFIG_DIALOG = 17
Global Const $7ZIP_QUERY_GET_FILE_COUNT = 18
Global Const $7ZIP_QUERY_QUERY_FUNCTION_LIST = 19
Global Const $7ZIP_QUERY_OPEN_ARCHIVE = 23
Global Const $7ZIP_QUERY_CLOSE_ARCHIVE = 24
Global Const $7ZIP_QUERY_FIND_FIRST = 25
Global Const $7ZIP_QUERY_FIND_NEXT = 26
Global Const $7ZIP_QUERY_SET_OWNERWINDOW = 31
Global Const $7ZIP_QUERY_CLEAR_OWNERWINDOW = 32
Global Const $7ZIP_QUERY_SET_OWNERWINDOWEX = 33
Global Const $7ZIP_QUERY_KILL_OWNERWINDOWEX = 34
Global Const $7ZIP_QUERY_GET_ARC_FILE_NAME = 40
Global Const $7ZIP_QUERY_GET_ARC_FILE_SIZE = 41
Global Const $7ZIP_QUERY_GET_ARC_ORIGINAL_SIZE = 42
Global Const $7ZIP_QUERY_GET_ARC_COMPRESSED_SIZE = 43
Global Const $7ZIP_QUERY_GET_ARC_RATIO = 44
Global Const $7ZIP_QUERY_GET_ARC_DATE = 45
Global Const $7ZIP_QUERY_GET_ARC_TIME = 46
;Global Const $7ZIP_QUERY_GET_ARC_OS_TYPE = 47
;Global Const $7ZIP_QUERY_GET_ARC_IS_SFX_FILE = 48
Global Const $7ZIP_QUERY_GET_ARC_WRITE_TIME_EX = 49
Global Const $7ZIP_QUERY_GET_ARC_CREATE_TIME_EX = 50
Global Const $7ZIP_QUERY_GET_ARC_ACCESS_TIME_EX = 51
;Global Const $7ZIP_QUERY_GET_ARC_CREATE_TIME_EX2 = 52
;Global Const $7ZIP_QUERY_GET_ARC_WRITE_TIME_EX2 = 53
Global Const $7ZIP_QUERY_GET_FILE_NAME = 57
Global Const $7ZIP_QUERY_GET_ORIGINAL_SIZE = 58
Global Const $7ZIP_QUERY_GET_COMPRESSED_SIZE = 59
Global Const $7ZIP_QUERY_GET_RATIO = 60
Global Const $7ZIP_QUERY_GET_DATE = 61
Global Const $7ZIP_QUERY_GET_TIME = 62
Global Const $7ZIP_QUERY_GET_CRC = 63
Global Const $7ZIP_QUERY_GET_ATTRIBUTE = 64
Global Const $7ZIP_QUERY_GET_OS_TYPE = 65
Global Const $7ZIP_QUERY_GET_METHOD = 66
Global Const $7ZIP_QUERY_GET_WRITE_TIME = 67
Global Const $7ZIP_QUERY_GET_CREATE_TIME = 68
Global Const $7ZIP_QUERY_GET_ACCESS_TIME = 69
Global Const $7ZIP_QUERY_GET_WRITE_TIME_EX = 70
Global Const $7ZIP_QUERY_GET_CREATE_TIME_EX = 71
Global Const $7ZIP_QUERY_GET_ACCESS_TIME_EX = 72
;Global Const $7ZIP_QUERY_SET_ENUM_MEMBERS_PROC = 80
;Global Const $7ZIP_QUERY_CLEAR_ENUM_MEMBERS_PROC = 81
Global Const $7ZIP_QUERY_GET_ARC_FILE_SIZE_EX = 82
Global Const $7ZIP_QUERY_GET_ARC_ORIGINAL_SIZE_EX = 83
Global Const $7ZIP_QUERY_GET_ARC_COMPRESSED_SIZE_EX = 84
Global Const $7ZIP_QUERY_GET_ORIGINAL_SIZE_EX = 85
Global Const $7ZIP_QUERY_GET_COMPRESSED_SIZE_EX = 86
Global Const $7ZIP_QUERY_SET_OWNERWINDOWEX_64 = 87
Global Const $7ZIP_QUERY_KILL_OWNERWINDOWEX_64 = 88
;Global Const $7ZIP_QUERY_SET_ENUM_MEMBERS_PROC64 = 89
;Global Const $7ZIP_QUERY_CLEAR_ENUM_MEMBERS_PROC64 = 90
;Global Const $7ZIP_QUERY_OPEN_ARCHIVE2 = 91
Global Const $7ZIP_QUERY_GET_ARC_READ_SIZE = 92
Global Const $7ZIP_QUERY_GET_ARC_READ_SIZE_EX = 93
Global Const $7ZIP_QUERY_SET_PRIORITY = 100
Global Const $7ZIP_QUERY_SET_UNICODE_MODE = 114
Global Const $7ZIP_QUERY_SET_DEFAULT_PASSWORD = 178
Global Const $7ZIP_QUERY_GET_DEFAULT_PASSWORD = 179
Global Const $7ZIP_QUERY_PASSWORD_DIALOG = 180
; 7Zip.au3 functions.
Global Const $7ZIP_QUERY_STARTUP = 200
Global Const $7ZIP_QUERY_SHUTDOWN = 201
Global Const $7ZIP_QUERY_ADD = 202
Global Const $7ZIP_QUERY_CREATE_SFX = 203
Global Const $7ZIP_QUERY_CREATE_SFXEX = 204
Global Const $7ZIP_QUERY_DELETE = 205
Global Const $7ZIP_QUERY_DOWNLOAD_7ZIP32_DLL = 206
Global Const $7ZIP_QUERY_EXTRACT = 207
Global Const $7ZIP_QUERY_EXTRACTEX = 208
Global Const $7ZIP_QUERY_UPDATE = 209

; #CONSTANTS# ==================================================================
; Name...........: $7ZIP_ARCEXTRACT_*
; Description ...: 7-Zip callback constants.
; Author ........: dany
; Modified ......:
; Remarks .......: src\7-zip32.h
; Related .......: _7Zip_SetOwnerWindowEx, _7Zip_SetOwnerWindowEx64
; ==============================================================================
Global Const $7ZIP_WM_ARCEXTRACT = 'wm_arcextract'
Global Const $7ZIP_ARCEXTRACT_BEGIN = 0
Global Const $7ZIP_ARCEXTRACT_INPROCESS = 1
Global Const $7ZIP_ARCEXTRACT_END = 2
Global Const $7ZIP_ARCEXTRACT_OPEN = 3
Global Const $7ZIP_ARCEXTRACT_COPY = 4

; #CONSTANTS# ==================================================================
; Name...........: $7ZIP_SFX_*
; Description ...: 7-Zip SFX constants.
; Author ........: dany
; Modified ......:
; Remarks .......:
; Related .......: _7Zip_CreateSFX/Ex
; ==============================================================================
Global Const $7ZIP_SFX_INSTALLER_GUI = 1 ; Software installer, GUI version.
Global Const $7ZIP_SFX_INSTALLER_CONSOLE = 2 ; Software installer, console version.
Global Const $7ZIP_SFX_SELFEXTRACT_GUI = 3 ; Self-extracting archive, GUI version.
Global Const $7ZIP_SFX_SELFEXTRACT_CONSOLE = 4 ; Self-extracting archive, console version.
#EndRegion Public constants and variables.

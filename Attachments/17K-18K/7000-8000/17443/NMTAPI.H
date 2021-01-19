// NMTAPI - Nexus Mainframe Terminal Application Program Interface
//
// Copyright - Nexus Integration 
// Author and owner - Hans Erik Næsheim (nihen@online.no)
//
// NMTAPI - A dll with support for tn3270 sessions to host systems
// based on async. Winsock. Terminal type is 3278 model 2 (IBM-3278-2)
//
// The nmtapi.dll will not be loaded 
// if an invalid, expired or no licence number are include in nmt.ini
// 
// Your application is responsible for starting winsock, and must
// provide two message functions for WM_HOST_RESOLVED and WM_ASYNC_IO
//
//    m_hApiLib = LoadLibrary ("NMTAPI.DLL");
//
//    m_fConnectHost = 
//    (CONNECT_API) GetProcAddress (m_hApiLib, "NmtConnectHost");
//    m_fHostResolved = 
//    (ASYNC_API) GetProcAddress (m_hApiLib, "NmtHostResolved");
// 
//    // Async Winsock
//    ON_MESSAGE(WM_HOST_RESOLVED, OnHostResolved)
//    ON_MESSAGE(WM_ASYNC_IO, OnAsyncIo)
//
// int CAbc::OnConnectHost (char * pHostName, int nPort, int * pSid) {
//
//    int sid, sState;
//
//    if (m_fConnectHost)
//       sState = (int) (* m_fConnectHost) (pHostNmae, nPort, m_hWnd, & sid);
//
//    // Don't call ConnectHost until Host Name has been resolved!
//
//    * pSid = sid; return sState;
// }
//
// LRESULT CAbc::OnHostResolved (WPARAM wParam, LPARAM lParam) {  
//
//    int sid, sState;
//
//    if (m_fHostResolved)
//       sState = (int) (* m_fHostResolved) (wParam, lParam, & sid);
//
//    // Test sid and sState
//    return 0;
// }
//
// LRESULT CAbc::OnAsyncIo (WPARAM wParam, LPARAM lParam) {
//
//    int sid, sState;
//
//    if (m_fAsyncIo)
//       sState = (int) (* m_fAsyncIo) (wParam, lParam, & sid);
//
//    // Test sid and sState
//    return 0;
// }
//

#define INVALID_SID                -1

#define MAX_HOST_SESSIONS           2  // 2048        // 2 // 256

// Only 3278 model 2 will be supported 
// Telnet terminal name: IBM-3278-2

#define EBCDIC_SPACE             0x40
#define EBCDIC_DUP               0x1C // DUP Character
#define EBCDIC_FM                0x1E // Field Mark Character

#define DEFAULT_ROWS               24
#define DEFAULT_COLUMNS            80

#define WM_HOST_RESOLVED     (WM_USER + 101)
#define WM_ASYNC_IO          (WM_USER + 102)

typedef struct {
   // 0, 0 as first row and column
   BYTE Attribute [DEFAULT_ROWS] [DEFAULT_COLUMNS];
   // if Attribute [r][c] then a valid 3270 Start Field, else 0x00
   BYTE Character [DEFAULT_ROWS] [DEFAULT_COLUMNS];
   // if Character [r][c] then a valid Ansi character, else 0x00
} SessionImage;
                               
typedef SessionImage FAR * ImagePtr;

// Session state and valid return values from the dll

typedef enum {
   InvalidLicence,      // Invalid NMT licence (nmt.ini)
   Unavailable,         // Not initialized or invalid session id
   ResolveHostName,
   ConnectingHost,      // Connecting in progress
   SessionConnected,    // Session connected and ready for input
   NoInputField,        // The cursor is not in an input field
   SessionDisconnected,
   WaitForAsyncWrite,   // Host request not completed
   SessionLocked,       // Session/keyboard locked
                        // Request completed, waiting for host response 
                        // Tapeahead not supported in this API
   SessionUpdated,      // New outbound/response from host
                        // Session state will be set to Connected 
                        // after a GetSessionState call
   ImageUpdated,        // Image or cursor updated by application,
                        // (connected and ready for more input)
   InsertOverflow,      // Input field to small
   NoFreeSession,
   OkTranslation,
   StringInImage,       NoStringFound,
   StartFieldPos,       ProtectedFieldPos, NonDisplayFieldPos,
                        HighlightedFieldPos, NumericFieldPos,
   UnformattedImage,    // No start field in session image
   InvalidParameter,
   InvalidHostName,     ResolveHostError,
   NoWsaStartup,        GetSocketError, AsyncConnectError,   
                        AsyncWriteError, AsyncReadError
} Session_State;

// Translation index

typedef enum {
     Austrian, Belgian, Canadian_French, Danish, Finnish, French, 
     German, Italian, Netherlands, Norwegian, Portuguese, Spanish,
     Swedish, Swiss, UK_English, US_English
} TranslationIndex;            

// Typdefs for the dll functions
typedef int (FAR PASCAL * TRANSLATION_API) (INT);

typedef int (FAR PASCAL * DISCONNECT_API) (INT);

typedef int (FAR PASCAL * CONNECT_API) (LPSTR, INT, HWND, LPINT);
typedef int (FAR PASCAL * CONNECT_LU_API) (LPSTR, LPSTR, INT, HWND, LPINT);   // New

typedef int (FAR PASCAL * ASYNC_API) (WPARAM, LPARAM, LPINT);

typedef int (FAR PASCAL * FUNCTIONKEY_API) (INT, INT);

typedef int (FAR PASCAL * SESSIONSTATE_API) (INT);
typedef int (FAR PASCAL * TYPESTRING_API) (INT, LPSTR, LPINT);
typedef int (FAR PASCAL * SETCURSORPOS_API) (INT, INT, INT);
typedef int (FAR PASCAL * GETCURSORPOS_API) (INT, LPINT, LPINT);
typedef int (FAR PASCAL * GETSTARTFIELD_API) (INT, LPINT, LPINT);
typedef int (FAR PASCAL * STARTFIELDINFO_API) (INT, INT, INT);

typedef int (FAR PASCAL * GETSTRINGPOS_API) (INT, LPINT, LPINT, LPSTR);

typedef int (FAR PASCAL * GETCHARACTER_API) (INT, INT, INT, LPBYTE);
typedef int (FAR PASCAL * GETSESSIONIMAGE_API) (INT, ImagePtr);

// Function keys for NmtFunctionKey

#define MF_RESET                    1
#define MF_IMG_TAB                  2
#define MF_IMG_BACKTAB              3
#define MF_IMG_ARROW_HOME           4
#define MF_IMG_ARROW_UP             5
#define MF_IMG_ARROW_DOWN           6
#define MF_IMG_ARROW_LEFT           7
#define MF_IMG_ARROW_RIGHT          8
#define MF_IMG_ARROW_DELETE         9
#define MF_IMG_BACKSPACE           10
#define MF_IMG_ERASE_TO_EOF        11
#define MF_IMG_ERASE_INPUT         12
#define MF_IMG_ERASE_FIELD         13
#define MF_IMG_DUP_KEY             14
#define MF_IMG_FIELD_MARK_KEY      15
#define MF_ENTER                   16
#define MF_PA1                     17
#define MF_PA2                     18
#define MF_PA3                     19
#define MF_CLEAR                   20
#define MF_PF1                     21
#define MF_PF2                     22
#define MF_PF3                     23
#define MF_PF4                     24
#define MF_PF5                     25
#define MF_PF6                     26
#define MF_PF7                     27
#define MF_PF8                     28
#define MF_PF9                     29
#define MF_PF10                    30
#define MF_PF11                    31
#define MF_PF12                    32
#define MF_PF13                    33
#define MF_PF14                    34
#define MF_PF15                    35
#define MF_PF16                    36
#define MF_PF17                    37
#define MF_PF18                    38
#define MF_PF19                    39
#define MF_PF20                    40
#define MF_PF21                    41
#define MF_PF22                    42
#define MF_PF23                    43
#define MF_PF24                    44
#define MF_ATTENTION               45
#define MF_SYS_REQUEST             47
 
// Functions supported in the DLL
// The winsock function WSAStartup () must have been called
//    All functions will return session state
//    sid - session identification

int WINAPI NmtSetTranslation (TranslationIndex);
// Set common Ansi/EBCDIC transalation (Def. US_English)
//    Return OkTtranslation or InvalidParameter

int WINAPI NmtConnectHost (char * pIpAdd, int nPort, HWND hWnd, int * pSid);
// pIpAddr     - Host name (abc | abc.xyz.nn) or IP addr (123.45.67.89)
// nPort       - Host telnet port
// hWnd        - Message wnd. which will be used for async WS
// pSid        - A valid sid (0 - 255) or -1 will be returned
//       No new connections must be done before the 
//       the host name has been resolved in the previous call.

int WINAPI NmtConnectHostDevice (char * pIpAdd, char * pLuName, int nPort, HWND hWnd, int * pSid);  // New
// Just like NmtConnectHost, but with an extra parameter for LU/Device name.

int WINAPI NmtDisconnect (int sid);
//       Return SessionDisconnected if valid sid and connected
//       else it will return Unavailable

int WINAPI NmtHostResolved (WPARAM wp, LPARAM lp, int * pSid);
// wp / lp     - afx_msg / WS  parameters, don't touch!!!
// pSid        - A sid will be returned/included
//       Return 0 from OnHostResolved

int WINAPI NmtAsyncIo (WPARAM wp, LPARAM lp, int * pSid);
// wp / lp     - afx_msg / WS  parameters, don't touch!!!
// pSid        - A sid will be returned/included
//       Remember to test state and pSid      
//       Return 0 from OnAsyncIon

int WINAPI NmtSessionState (int nSid);

int WINAPI NmtFunctionKey (int nSid, int nKey);
// nKey        - MF_RESET, MF_IMG_TAB, MF_ENTER, etc

int WINAPI NmtTypeString (int nSid, char * pString, int * pLength);
// It will return session state if the string has been inserted, or 
// NoInputFiled, InsertOverflow or Invalidparameter
// pString     - Pointer to the Ansi text which will be typed, 
//               terminated with null (0x00)
// pLength     - Pointer to the string/text length, it will be
//               updated with the number of characters inserted

int WINAPI NmtSetCursorPos (int nSid, int nRow, int nColumn);
int WINAPI NmtGetCursorPos (int nSid, int * pRow, int * pColumn);

int WINAPI NmtGetNextStartField (int nSid, int * pRow, int * pColumn);
// Get next SF pos after Row/Column, it will return session state
// and next SF pos if formatted, else UnformattedImage
int WINAPI NmtGetCurrentStartField (int nSid, int * pRow, int * pColumn);
// Get current SF pos according to Row/Column, it will return session state
// and current SF pos if formatted, else UnformattedImage
int WINAPI NmtGetPreviousStartField (int nSid, int * pRow, int * pColumn);
// Get previous SF pos according to Row/Column, it will return session state
// and previous SF pos if formatted, else UnformattedImage

int WINAPI NmtStartFieldPos (int nSid, int nRow, int nColumn);
// It will return StartFieldPos if nSid is a valid sid and 
// a Start Field is located in the image pos. at nRow and nColumn,
// else it will return InvalidParameter or UnformattedImage

int WINAPI NmtProtectedFieldPos (int nSid, int nRow, int nColumn);
// It will return ProtectedFieldPos if nSid is a valid sid and 
// nRow and nColumn is located in a Protected field, 
// else it will return InvalidParameter or UnformattedImage

int WINAPI NmtNumericFieldPos (int nSid, int nRow, int nColumn);
// It will return NumericFieldPos if nSid is a valid sid and 
// nRow and nColumn is located in a Numeric field, 
// else it will return InvalidParameter or UnformattedImage 

int WINAPI NmtNondisplayFieldPos (int nSid, int nRow, int nColumn);
// It will return NonDisplayFieldPos if nSid is a valid sid and 
// nRow and nColumn is located in a non display field, 
// else it will return InvalidParameter or UnformattedImage

int WINAPI NmtHighlightedFieldPos (int nSid, int nRow, int nColumn);
// It will return HighlightedFieldPos if nSid is a valid sid and 
// nRow and nColumn is located in a highlighted field, 
// else it will return InvalidParameter or UnformattedImage

int WINAPI NmtGetStringPos (int nSid, int * pRow, int * pColumn, char * pString);
// It will return StringInImage, NoStringFound or InvalidParameter
// pRow        - A valid row pos. will be returned
//               if the string has been found in the session image
// pColumn     - A valid column pos. will be returned if ... .. .
// pString     - Pointer to the text/string (0x00 terminated)
//               which the function will search for

int WINAPI NmtGetImageCharacter (int nSid, int nRow, int nColumn, BYTE * pByte);
// It will return session state and image char. in pByte

int WINAPI NmtGetSessionImage (int nSid, ImagePtr pImage);
// It will return session state
// sid
// pImage      - Copy SessionImage to pImage


// Other functions will be included later.






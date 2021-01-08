'AutoitDLL.inc was renamed to AutiItX3DLL.inc and slightly modified by myself
'modifications:
'
'send >>>> "ByVal nY As Long" was added so syntax must be e.g.: Send ("TEXT",) or Send("{ENTER}",0)

'Attribute VB_Name = "AutoItDLLDecl"
'Option Explicit

Declare Sub BlockInput           Lib "AutoItX3" Alias "AU3_BlockInput"           (ByVal nToggle As Long)

Declare Sub ClipGet              Lib "AutoItX3" Alias "AU3_ClipGet"              (ByVal szText As String)
Declare Sub ClipPut              Lib "AutoItX3" Alias "AU3_ClipPut"              (ByVal szText As String)

Declare Sub DetectHiddenText     Lib "AutoItX3" Alias "AU3_DetectHiddenText"     (ByVal nToggle As Long)

Declare Function WinActive          Lib "AutoItX3" Alias "AU3_WinActive"          (ByVal szTitle As String, ByVal szText As String) As Long
Declare Function WinExists          Lib "AutoItX3" Alias "AU3_WinExists"           (ByVal szTitle As String, ByVal szText As String) As Long
Declare Sub AutoItInit           Lib "AutoItX3" Alias "AU3_Init" ()
Declare Sub IniDelete            Lib "AutoItX3" Alias "AU3_IniDelete"            (ByVal szFile As String, ByVal szSection As String, ByVal szValue As String)
Declare Sub IniRead              Lib "AutoItX3" Alias "AU3_IniRead"              (ByVal szFile As String, ByVal szSection As String, ByVal szValue As String, ByVal szResult As String)
Declare Sub IniWrite             Lib "AutoItX3" Alias "AU3_IniWrite"             (ByVal szFile As String, ByVal szSection As String, ByVal szValue As String, ByVal szResult As String)

Declare Sub LeftClick            Lib "AutoItX3" Alias "AU3_LeftClick"            (ByVal nX As Long, ByVal nY As Long)
Declare Sub LeftClickDrag        Lib "AutoItX3" Alias "AU3_LeftClickDrag"        (ByVal nX1 As Long, ByVal nY1 As Long, ByVal nX2 As Long, ByVal nY2 As Long)

Declare Sub MouseMove            Lib "AutoItX3" Alias "AU3_MouseMove"            (ByVal nX As Long, ByVal nY As Long)
Declare Function MouseGetPosX         Lib "AutoItX3" Alias "AU3_MouseGetPosX"         () As Long
Declare Function MouseGetPosY         Lib "AutoItX3" Alias "AU3_MouseGetPosY"         () As Long

Declare Sub RightClick           Lib "AutoItX3" Alias "AU3_RightClick"           (ByVal nX As Long)
Declare Sub RightClickDrag       Lib "AutoItX3" Alias "AU3_RightClickDrag"       (ByVal nX1 As Long, ByVal nY1 As Long, ByVal nX2 As Long, ByVal nY2 As Long)

Declare Sub Send                 Lib "AutoItX3" Alias "AU3_Send"                 (ByVal szLine As String, ByVal nY As Long)
Declare Sub SetCapslockState     Lib "AutoItX3" Alias "AU3_SetCapslockState"     (ByVal nToggle As Long)
Declare Sub SetKeyDelay          Lib "AutoItX3" Alias "AU3_SetKeyDelay"          (ByVal nDelay As Long)
Declare Sub SetStoreCapslockMode Lib "AutoItX3" Alias "AU3_SetStoreCapslockMode" (ByVal nToggle As Long)
Declare Sub SetTitleMatchMode    Lib "AutoItX3" Alias "AU3_SetTitleMatchMode"    (ByVal nMode As Long)
Declare Sub SetWinDelay          Lib "AutoItX3" Alias "AU3_SetWinDelay"          (ByVal nDelay As Long)
Declare Sub Shutdown             Lib "AutoItX3" Alias "AU3_Shutdown"             (ByVal nFlag As Long)
Declare Sub Sleep                Lib "AutoItX3" Alias "AU3_Sleep"                (ByVal nMilli As Long)

Declare Function WinWait              Lib "AutoItX3" Alias "AU3_WinWait"              (ByVal szTitle As String, ByVal szText As String, ByVal nTimeout As Long) As Long
Declare Function WinWaitActive        Lib "AutoItX3" Alias "AU3_WinWaitActive"        (ByVal szTitle As String, ByVal szText As String, ByVal nTimeout As Long) As Long
Declare Function WinWaitNotActive     Lib "AutoItX3" Alias "AU3_WinWaitNotActive"     (ByVal szTitle As String, ByVal szText As String, ByVal nTimeout As Long) As Long
Declare Function WinWaitClose         Lib "AutoItX3" Alias "AU3_WinWaitClose"         (ByVal szTitle As String, ByVal szText As String, ByVal nTimeout As Long) As Long
Declare Sub WinHide              Lib "AutoItX3" Alias "AU3_WinHide"              (ByVal szTitle As String, ByVal szText As String)
Declare Sub WinRestore           Lib "AutoItX3" Alias "AU3_WinRestore"           (ByVal szTitle As String, ByVal szText As String)
Declare Sub WinMinimize          Lib "AutoItX3" Alias "AU3_WinMinimize"          (ByVal szTitle As String, ByVal szText As String)
Declare Sub WinMaximize          Lib "AutoItX3" Alias "AU3_WinMaximize"          (ByVal szTitle As String, ByVal szText As String)
Declare Sub WinMinimizeAll       Lib "AutoItX3" Alias "AU3_WinMinimizeAll"       ()
Declare Sub WinActivate          Lib "AutoItX3" Alias "AU3_WinActivate"          (ByVal szTitle As String, ByVal szText As String)
Declare Sub WinClose             Lib "AutoItX3" Alias "AU3_WinClose"             (ByVal szTitle As String, ByVal szText As String)
Declare Sub WinMove              Lib "AutoItX3" Alias "AU3_WinMove"              (ByVal szTitle As String, ByVal szText As String, ByVal nX As Long, ByVal nY As Long, ByVal nWidth As Long, ByVal nHeight As Long)
Declare Sub WinSetTitle          Lib "AutoItX3" Alias "AU3_WinSetTitle"          (ByVal szTitle As String, ByVal szText As String, ByVal szNewTitle As String)
Declare Sub WinGetActiveTitle    Lib "AutoItX3" Alias "AU3_WinGetActiveTitle"    (ByVal szTitle As String)
Declare Sub WinShow              Lib "AutoItX3" Alias "AU3_WinShow"              (ByVal szTitle As String, ByVal szText As String)
Declare Sub WinKill              Lib "AutoItX3" Alias "AU3_WinKill"              (ByVal szTitle As String, ByVal szText As String)
Declare Sub WinMinimizeAllUndo   Lib "AutoItX3" Alias "AU3_WinMinimizeAllUndo"   ()

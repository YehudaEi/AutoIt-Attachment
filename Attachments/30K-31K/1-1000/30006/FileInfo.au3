;FileInfo-UDF
;Date:        February 27, 2010
;Author:     funkey

#include-once
Opt("ExpandEnvStrings", 1)

; #FUNCTION# ======================================================================================
; Name ..........: _FileGetApp()
; Description ...: Returns path and filename of the standard application to open the filetype
; Syntax ........: _FileGetApp($sFileName)
; Parameters ....: $sFileName - Filename with or without path
; Author ........: funkey
; Related .......: _FileGetExt
; Example .......: Yes
;                  Local $Filename = "C:\boot.ini"
;                  ConsoleWrite("Application: " & _FileGetApp($Filename) & @CR)
; =================================================================================================

Func _FileGetApp($sFileName)
	;funkey
	Local $sExt = _FileGetExt($sFileName)
	Local $sDesc = RegRead("HKCR\." & $sExt, "")
	Local $sApp = RegRead("HKCR\" & $sDesc & "\shell\open\command", "")
	If @error Then Return "RUNDLL32.EXE SHELL32.DLL,OpenAs _RunDLL" ;no extension --> Open With Dialog
	$sApp = StringLeft($sApp, StringInStr($sApp, " ", 0, -1) - 1)
	If $sApp = '"%1"' Then Return $sFileName
	Return $sApp
EndFunc

; #FUNCTION# ======================================================================================
; Name ..........: _FileGetDesc()
; Description ...: Returns the description of the filetype
; Syntax ........: _FileGetDesc($sFileName)
; Parameters ....: $sFileName - Filename with or without path
; Author ........: funkey
; Related .......: _FileGetExt
; Example .......: Yes
;                  Local $Filename = "C:\boot.ini"
;                  ConsoleWrite("Application: " & _FileGetDesc($Filename) & @CR)
; =================================================================================================

Func _FileGetDesc($sFileName)
	;funkey
	Local $sExt = _FileGetExt($sFileName)
	If $sExt = "" Then Return "File" ;no extension
	Local $sDesc = RegRead("HKCR\." & $sExt, "")
	If @error Then Return SetError(1, 0, StringUpper($sExt) & " File") ;unknown filetype
	Return RegRead("HKCR\" & $sDesc, "")
EndFunc

; #FUNCTION# ======================================================================================
; Name ..........: _FileGetExt()
; Description ...: Description
; Syntax ........: _FileGetExt($sFileName)
; Parameters ....: $sFileName - Filename with or without path
; Author ........: funkey
; Example .......: Yes
;                  Local $Filename = "C:\boot.ini"
;                  ConsoleWrite("Application: " & _FileGetExt($Filename) & @CR)
; =================================================================================================

Func _FileGetExt($sFileName)
	;funkey
	Local $sExt = StringTrimLeft($sFileName, StringInStr($sFileName, ".", 0, -1))
	If StringInStr($sExt, "\") Or StringInStr($sExt, "/") Then Return "" ;no extension
	Return $sExt
EndFunc

; #FUNCTION# ======================================================================================
; Name ..........: _FileGetIcon()
; Description ...: Returns the iconfile and the index of a given filetype
; Syntax ........: _FileGetIcon($sFileName)
; Parameters ....: $sFileName - Filename with or without path
; Return values .: aIcon[0] - Name of the iconfile
;                  aIcon[1] - Index of the icon
; Author ........: funkey
; Related .......: _FileGetExt
; Example .......: Yes
;                  Local $Filename = "C:\boot.ini"
;                  Local $aIcon = _FileGetIcon($Filename)
;                  ConsoleWrite("Icon:        " & $aIcon[0] & " / Index: " & $aIcon[1] &@CR)
; =================================================================================================

Func _FileGetIcon($sFileName)
	;funkey
	Local $aIcon[2] = [@WindowsDir & "\System32\shell32.dll", "0"]
	Local $sExt = _FileGetExt($sFileName)
	Local $sDesc = RegRead("HKCR\." & $sExt, "")
	Local $sIcon = RegRead("HKCR\" & $sDesc & "\DefaultIcon", "")
	If @error Then Return $aIcon
	If $sIcon = "%1" Then
		$aIcon[0] = $sFileName
		Return $aIcon
	EndIf
	Local $iPos = StringInStr($sIcon, ",", 0, -1)
	$aIcon[0] = StringLeft($sIcon, $iPos - 1)
	$aIcon[1] = StringTrimLeft($sIcon, $iPos)
	Return $aIcon
EndFunc

; #FUNCTION# ======================================================================================
; Name ..........: _ShellExecute()
; Description ...: Description
; Syntax ........: _ShellExecute($sFileName[, $sParameter = ""[, $sWorkingdir = ""[, $show_flag = @SW_SHOW]]])
; Parameters ....: $sFileName   - Filename with path
;                  $sParameter  - [optional] Any parameters for the program. Blank ("") uses none. (default:"")
;                  $sWorkingdir - [optional] The working directory. Blank ("") uses the current working directory. (default:"")
;                  $show_flag   - [optional] The "show" flag of the executed program: (default:@SW_SHOW)
;                  |  @SW_HIDE = Hidden window (or Default keyword)
;                  |  @SW_MINIMIZE = Minimized window
;                  |  @SW_MAXIMIZE = Maximized window
; Return values .: ProcessID of the started application
; Author ........: funkey
; Related .......:
; Example .......: Yes
;                  Local $Filename = "C:\boot.ini"
;                  Local $a = _ShellExecute($FileName)
;                  ConsoleWrite("PID: " & $a & " - Error: " & @error & @CR)
; =================================================================================================

Func _ShellExecute($sFileName, $sParameter = "", $sWorkingdir = "", $show_flag = @SW_SHOW) ; 'open' is always used for the verb
	;funkey
	If Not FileExists($sFileName) Then Return SetError(1, 0, 0)
	Local $sApp = _FileGetApp($sFileName)
	Local $Cmd = $sApp & " " & $sParameter & " " & $sFileName
	If $sApp = $sFileName Then $Cmd = $sFileName
	Local $PID = Run($Cmd, $sWorkingdir, $show_flag)
	Return SetError(@error, 0, $PID)
EndFunc

; #FUNCTION# ======================================================================================
; Name ..........: _ShellExecuteAs()
; Description ...: Executes an file  under the context of a different user
; Syntax ........: _ShellExecuteAs($sUsername, $sDomain, $sPassword, $logon_flag, $sFileName[, $sWorkingdir = ""[, $show_flag = Default[, $opt_flag = 0]]])
; Parameters ....: $sUsername   - The username to log on with.
;                  $sDomain     - The domain to authenticate against.
;                  $sPassword   - The password for the user.
;                  $logon_flag  - 0 - Interactive logon with no profile.
;                  |1 - Interactive logon with profile.
;                  |2 - Network credentials only.
;                  |4 - Inherit the calling processes environment instead of the user's.
;                  $sFileName   - Filename with path
;                  $sWorkingdir - [optional] The working directory. If not specified, then the value of @SystemDir will be used. This is not the path to the program. (default:"")
;                  $show_flag   - [optional] The "show" flag of the executed program: (default:Default)
;                  |  @SW_HIDE = Hidden window (or Default keyword)
;                  |  @SW_MINIMIZE = Minimized window
;                  |  @SW_MAXIMIZE = Maximized window
;                  $opt_flag    - [optional] Controls various options related to how the parent and child process interact. (default:0)
;                  |  0x1 ($STDIN_CHILD) = Provide a handle to the child's STDIN stream
;                  |  0x2 ($STDOUT_CHILD) = Provide a handle to the child's STDOUT stream
;                  |  0x4 ($STDERR_CHILD) = Provide a handle to the child's STDERR stream
;                  |  0x8 ($STDERR_MERGED) = Provides the same handle for STDOUT and STDERR. Implies both $STDOUT_CHILD and $STDERR_CHILD.
;                  |  0x10 ($STDIO_INHERIT_PARENT) = Provide the child with the parent's STDIO streams. This flag can not be combined with any other STDIO flag. This flag is only useful when the parent is compiled as a Console application.
;                  |  0x10000 ($RUN_CREATE_NEW_CONSOLE) = The child console process should be created with it's own window instead of using the parent's window. This flag is only useful when the parent is compiled as a Console application.
; Return values .: ProcessID of the started application
; Author ........: funkey
; Related .......: _FileGetApp
; Example .......: Yes
;                  Local $Filename = "C:\boot.ini"
;                  Local $a = _ShellExecuteAs(@UserName, @ComputerName, "password", 1, $FileName, "", @SW_SHOW)
;                  ConsoleWrite("PID: " & $a & " - Error: " & @error & @CR)
; =================================================================================================

Func _ShellExecuteAs($sUsername, $sDomain, $sPassword, $logon_flag, $sFileName, $sWorkingdir = "", $show_flag = Default, $opt_flag = 0)
	;funkey
	If Not FileExists($sFileName) Then Return SetError(1, 0, 0)
	Local $sApp = _FileGetApp($sFileName)
	Local $Cmd = $sApp & " " & $sFileName
	If $sApp = $sFileName Then $Cmd = $sFileName
	Local $PID = RunAs($sUsername, $sDomain, $sPassword, $logon_flag, $Cmd, $sWorkingdir, $show_flag, $opt_flag)
	Return SetError(@error, 0, $PID)
EndFunc


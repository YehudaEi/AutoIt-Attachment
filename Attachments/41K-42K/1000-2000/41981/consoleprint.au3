#include <WinAPI.au3>
#include "getprocess.au3"
#AutoIt3Wrapper_Change2CUI=y
#comments-start
File:ConsolePrint.au3
Author:Jim Michaels
Create Date:9/24/2013
last Updated:9/24/2013
Copyright: 
	portions based on examples from MSDN Copyright (C) 2013 Microsoft
Abstract:
	subset of the more useful output-type of Win32 API console 
	functions, for writing debugging output.
Language: Autoit
#comments-end
global $consoleIsAttachedToParent=false
Func GetConsoleWindow() ;returns HWND
	;http://msdn.microsoft.com/en-us/library/windows/desktop/ms683175%28v=vs.85%29.aspx
	Local $aResult = DllCall("kernel32.dll", "HWND", "GetConsoleWindow")
	return $aResult[0]
EndFunc
Func GetLargestConsoleWindowSize($hConsoleOutput) ;returns COORD
	;http://msdn.microsoft.com/en-us/library/windows/desktop/ms683193%28v=vs.85%29.aspx
	Local $aResult = DllCall("kernel32.dll", "DWORD", "GetLargestConsoleWindowSize","HANDLE",$hConsoleOutput)
	return $aResult[0]
EndFunc
Func GetConsoleCursorInfo($hConsoleOutput, byref $lpConsoleCursorInfo) ;returns BOOL
	;http://msdn.microsoft.com/en-us/library/windows/desktop/ms683163%28v=vs.85%29.aspx
	Local $aResult = DllCall("kernel32.dll", "BOOL", "GetConsoleCursorInfo", "HANDLE", $hConsoleOutput, "ptr", $lpConsoleCursorInfo)
	return ($aResult[0]<>0)
EndFunc

global const $STD_INPUT_HANDLE=-10, $STD_OUTPUT_HANDLE=-11, $STD_ERROR_HANDLE=-12
Func GetStdHandle($nStdHandle) ;returns HANDLE to specified device
	;http://msdn.microsoft.com/en-us/library/windows/desktop/ms683231%28v=vs.85%29.aspx
	Local $aResult = DllCall("kernel32.dll", "HANDLE", "GetStdHandle", "DWORD", $nStdHandle)
	return $aResult[0]
EndFunc
Func SetStdHandle($nStdHandle, $hHandle) ;returns BOOL
	;http://msdn.microsoft.com/en-us/library/windows/desktop/ms686244%28v=vs.85%29.aspx
	Local $aResult = DllCall("kernel32.dll", "BOOL", "SetStdHandle", "DWORD", $nStdHandle, "HANDLE", $hHandle)
	return ($aResult[0]<>0)
EndFunc
Func WriteConsoleOutputCharacter($hConsoleOutput, $str, $dwLength, $dwWriteCoord, byref $lpNumberOfCharsWritten) ;returns BOOL
	;http://msdn.microsoft.com/en-us/library/windows/desktop/ms687410%28v=vs.85%29.aspx
	;may need work on lpNumberOfCharsWritten and str
	;if (1==@AutoItX64) then
		Local $aResult = DllCall("kernel32.dll", "BOOL", "WriteConsoleOutputCharacter", "HANDLE", $hConsoleOutput, "wstr", $str, "DWORD", $dwLength, "DWORD", $dwWriteCoord, "ptr:", $lpNumberOfCharsWritten)
		return ($aResult[0]<>0)
	;else
	;	return (0<>DllCall("kernel32.dll", "BOOL", "WriteConsoleOutputCharacter", "HANDLE", $hConsoleOutput, "str", $str, "DWORD", $dwLength, "DWORD", $dwWriteCoord, "ptr:", $lpNumberOfCharsWritten))
	;endif
EndFunc
Func FillConsoleOutputCharacter($hConsoleOutput, $cCharacter, $dwnLength, $dwWriteCoord, byref $lpNumberOfCharsWritten) ;returns BOOL
	;http://msdn.microsoft.com/en-us/library/windows/desktop/ms682663%28v=vs.85%29.aspx
	;may need work on lpNumberOfCharsWritten
	Local $aResult = DllCall("kernel32.dll", "BOOL", "FillConsoleOutputCharacter", "HANDLE", $hConsoleOutput, "WORD", $cCharacter, "DWORD", $dwnLength, "DWORD", $dwWriteCoord, "ptr", $lpNumberOfCharsWritten)
	return ($aResult[0]<>0)
EndFunc

global const $CONSOLE_TEXTMODE_BUFFER=1
Func CreateConsoleScreenBuffer($dwDesiredAccess, $dwShareMode, $lpSecurityAttributes, $dwFlags, byref $lpScreenBufferData) ;returns HANDLE
	;http://msdn.microsoft.com/en-us/library/windows/desktop/ms682122%28v=vs.85%29.aspx
	;may need work on lpSecurityAttributes, lpScreenBufferData
	Local $aResult = DllCall("kernel32.dll", "HANDLE", "CreateConsoleScreenBuffer", "DWORD", $dwDesiredAccess, "DWORD", $dwShareMode, "ptr", $lpSecurityAttributes, "DWORD", $dwFlags, "ptr", $lpScreenBufferData)
	return $aResult[0]
EndFunc
Func FreeConsole() ;returns BOOL
	;http://msdn.microsoft.com/en-us/library/windows/desktop/ms683150%28v=vs.85%29.aspx
	return (0<>DllCall("kernel32.dll", "BOOL", "FreeConsole"))
EndFunc
Func SetConsoleTitle($lpConsoleTitle) ;returns BOOL
	;http://msdn.microsoft.com/en-us/library/windows/desktop/ms686050%28v=vs.85%29.aspx
	;if (1==@AutoItX64) then
		Local $aResult = DllCall("kernel32.dll", "BOOL", "SetConsoleTitle", "wstr", $lpConsoleTitle)
		return ($aResult[0]<>0)
	;else
	;	return (0<>DllCall("kernel32.dll", "BOOL", "SetConsoleTitle", "str", $lpConsoleTitle))
	;endif
EndFunc
Func GetConsoleScreenBufferInfoEx($hConsoleOutput, $lpConsoleScreenBufferInfoEx) ;returns BOOL
	;http://msdn.microsoft.com/en-us/library/windows/desktop/ms686039%28v=vs.85%29.aspx
	;may need work on lpConsoleScreenBufferInfoEx
	Local $aResult = DllCall("kernel32.dll", "BOOL", "GetConsoleScreenBufferInfoEx", "HANDLE", $hConsoleOutput, "ptr", $lpConsoleScreenBufferInfoEx)
	return ($aResult[0]<>0)
EndFunc
Func SetConsoleScreenBufferInfoEx($hConsoleOutput, $lpConsoleScreenBufferInfoEx) ;returns BOOL
	;http://msdn.microsoft.com/en-us/library/windows/desktop/ms686039%28v=vs.85%29.aspx
	;may need work on lpConsoleScreenBufferInfoEx
	Local $aResult = DllCall("kernel32.dll", "BOOL", "SetConsoleScreenBufferInfoEx", "HANDLE", $hConsoleOutput, "ptr", $lpConsoleScreenBufferInfoEx)
	return ($aResult[0]<>0)
EndFunc
Func SetConsoleScreenBufferSize($hConsoleOutput, $dwcoordSize) ;returns BOOL
	;http://msdn.microsoft.com/en-us/library/windows/desktop/ms686044%28v=vs.85%29.aspx
	;may need work on lpConsoleScreenBufferInfoEx
	Local $aResult = DllCall("kernel32.dll", "BOOL", "SetConsoleScreenBufferSize", $hConsoleOutput, $dwcoordSize)
	return ($aResult[0]<>0)
EndFunc
global const $ATTACH_PARENT_PROCESS=-1
Func AttachConsole($dwProcessId) ;returns BOOL
	;http://msdn.microsoft.com/en-us/library/windows/desktop/ms681952%28v=vs.85%29.aspx
	Local $aResult = DllCall("kernel32.dll", "BOOL", "AttachConsole", $dwProcessId)
	return ($aResult[0]<>0)
EndFunc
Func GetConsoleProcessList($lpdwProcessList, $dwProcessCount) ;returns DWORD
	;http://msdn.microsoft.com/en-us/library/windows/desktop/ms683170%28v=vs.85%29.aspx
	return DllCall("kernel32.dll", "DWORD", "GetConsoleProcessList", "ptr", $lpdwProcessList, "DWORD", $dwProcessCount)
EndFunc
Func GetConsoleProcessListArr(byref $arrProcessIDs) ;returns boolean, $arrProcessIDs[0] is array size, will redim array and contain the process id's
	;http://msdn.microsoft.com/en-us/library/windows/desktop/ms683170%28v=vs.85%29.aspx
	local $i, $st=dllstructcreate("DWORD dwProcessList["&$arrProcessIDs[0]&"]")
	local $count=GetConsoleProcessList(dllstructgetptr($st), $arrProcessIDs[0])
	local $count2=$count ;necessary to initialize $count later in loop
	if ($count<=$arrProcessIDs[0]) then
		$arrProcessIDs[0]=$count
		for $i=1 to $count
			$arrProcessIDs[$i]=dllstructgetdata($st,$i)
		next
	else
		do 
			$count=$count2 ;use new value
			;count contains the element count that array SHOULD be
			redim $arrProcessIDs[$count+1]
			$st=dllstructcreate("DWORD dwProcessList["&$count&"]")
			$count2=GetConsoleProcessList(dllstructgetptr($st), $count)
			if $count2<=$count then
				$arrProcessIDs[0]=$count2
				for $i=1 to $count2
					$arrProcessIDs[$i]=dllstructgetdata($st,$i)
				next
			else
			endif
		until $count2<=$count
	endif
EndFunc
Func AllocConsole() ;returns BOOL
	;http://msdn.microsoft.com/en-us/library/windows/desktop/ms681944%28v=vs.85%29.aspx
	;may need work on lpConsoleScreenBufferInfoEx
	return (0<>DllCall("kernel32.dll", "BOOL", "AllocConsole"))
EndFunc




;Func GetConsoleCursorInfo($hConsoleOutput, $lpConsoleCursorInfo); returns BOOL
;	;http://msdn.microsoft.com/en-us/library/windows/desktop/ms683163%28v=vs.85%29.aspx
;	return (0<>DllCall("kernel32.dll", "BOOL", "GetConsoleCursorInfo", "HANDLE", $hConsoleOutput, "ptr", $lpConsoleCursorInfo))
;EndFunc

;struct CONSOLE_CURSOR_INFO DWORD dwSize;BOOL bVisible; http://msdn.microsoft.com/en-us/library/windows/desktop/ms682068%28v=vs.85%29.aspx
;struct COORD SHORT X, Y; (DWORD) http://msdn.microsoft.com/en-us/library/windows/desktop/ms682119%28v=vs.85%29.aspx
;struct SMALL_RECT SHORT Left, Top, Right, Bottom; http://msdn.microsoft.com/en-us/library/windows/desktop/ms686311%28v=vs.85%29.aspx
;struct CONSOLE_SCREEN_BUFFER_INFOEX ULONG cbSize;COORD dwSize;COORD dwCursorPosition;WORD wAttributes;SMALL_RECT srWindow;COORD dwMaximumWindowSize;WORD wPopupAttributes;BOOL bFullSscreenSupported;COLORREF ColorTable[16];  http://msdn.microsoft.com/en-us/library/windows/desktop/ms682091%28v=vs.85%29.aspx
global $CONSOLE_CURSOR_INFO = DllStructCreate("DWORD dwSize;BOOL bVisible")
global $CONSOLE_SCREEN_BUFFER_INFOEX=dllstructcreate("ULONG cbSize;WORD dwSizeX;WORD dwSizeY;WORD dwCursorPositionX;WORD dwCursorPositionY;WORD wAttributes;WORD srWindowLeft;WORD srWindowTop;WORD srWindowRight;WORD srWindowBottom;WORD dwMaximumWindowSizeX;WORD dwMaximumWindowSizeY;WORD wPopupAttributes;BOOL bFullScreenSupported;DWORD ColorTable[16]")
global $SMALL_RECT=dllstructcreate("short Left;short Top;short Right;short Bottom")
global $COORD=dllstructcreate("short X;short Y")
global $CHAR_INFO=dllstructcreate("WORD UnicodeChar") ;http://msdn.microsoft.com/en-us/library/windows/desktop/ms682013%28v=vs.85%29.aspx

;Func GetLargestConsoleWindowSize($hConsoleOutput); returns COORD
;	;http://msdn.microsoft.com/en-us/library/windows/desktop/ms683193%28v=vs.85%29.aspx
;	return DllCall("kernel32.dll", "DWORD", "GetLargestConsoleWindowSize", "HANDLE", $hConsoleOutput)
;EndFunc
Func ScrollConsoleScreenBuffer($hConsoleOutput, $lpScrollRectangle, $lpClipRectangle, $dwcoordDestinationOrigin, $lpFill); returns BOOL
	;http://msdn.microsoft.com/en-us/library/windows/desktop/ms685107%28v=vs.85%29.aspx
	Local $aResult = DllCall("kernel32.dll", "BOOL", "ScrollConsoleScreenBuffer", "HANDLE", $hConsoleOutput, "ptr", $lpScrollRectangle, "ptr", $lpClipRectangle, "DWORD", $dwcoordDestinationOrigin, "ptr", $lpFill)
	return ($aResult[0]<>0)
EndFunc
Func SetConsoleCursorPosition($hConsoleOutput, $dwcoordCursorPosition); returns BOOL
	;http://msdn.microsoft.com/en-us/library/windows/desktop/ms686025%28v=vs.85%29.aspx
	Local $aResult = DllCall("kernel32.dll", "BOOL", "SetConsoleCursorPosition", "HANDLE", $hConsoleOutput, "DWORD", $dwcoordCursorPosition)
	return ($aResult[0]<>0)
EndFunc
Func SetConsoleActiveScreenBuffer($hConsoleOutput); returns BOOL
	;http://msdn.microsoft.com/en-us/library/windows/desktop/ms686010%28v=vs.85%29.aspx
	Local $aResult = DllCall("kernel32.dll", "BOOL", "SetConsoleActiveScreenBuffer", "HANDLE", $hConsoleOutput)
	return ($aResult[0]<>0)
EndFunc
global $hstd=GetStdHandle($STD_OUTPUT_HANDLE);

#comments-start
Author:Jim Michaels
Abstract:writes str to parent console of window or creates new console and writes str to the new console. 
		only ASCII/ANSI works. @crlf is handled appropriately. 
		the cmd shell's prompt will not show after this is excecuted,
		but it is there, you can run a cmd shell command and it will go.
		if you want a prompt, hit Enter.
Created:9/25/2013
#comments-end
func ConsolePrint($str) ;returns boolean
	return ConsoleOut($str&@crlf)
endfunc
#comments-start
Author:Jim Michaels
Abstract:writes str to parent console of window or creates new console and writes str to the new console
		only ASCII/ANSI works. @crlf is handled appropriately. 
		the cmd shell's prompt will not show after this is excecuted,
		but it is there, you can run a cmd shell command and it will go.
		if you want a prompt, hit Enter.
Created:9/25/2013
#comments-end
func ConsoleOut($str) ;returns boolean
	Local $i;,$stString = DllStructCreate("wchar["&stringlen($str)&"]")
	;Local $structsize = DllStructGetSize($stString) / 2
	local $csbiInfoEx = $CONSOLE_SCREEN_BUFFER_INFOEX
	local $pcsbiInfoEx=dllstructgetptr($csbiInfoEx)
	local $stStr,$bytesWritten;
	;DllStructSetData($stString, 1, $str)
	;local $hwnd=GetConsoleWindow()
	if (not $consoleIsAttachedToParent) then
		_WinAPI_AttachConsole($ATTACH_PARENT_PROCESS)
		;_WinAPI_AttachConsole(GetCurrentProcessId())
		$consoleIsAttachedToParent=true
	endif
	if ($INVALID_HANDLE_VALUE=$hstd) then
		$hstd=GetStdHandle($STD_OUTPUT_HANDLE)
	endif
	if ($INVALID_HANDLE_VALUE=$hstd) then
		msgbox(1,"oops","ConsoleOut():could not GetStdHandle()")
		return false;
	else
		;SetConsoleActiveScreenBuffer($hstd)
		;consolewrite($str)
		;return true
		;if (GetConsoleScreenBufferInfoEx($hstd, $pcsbiInfoEx)) then
		;	local $wAttribs=dllstructgetdata($csbiInfoEx,"wAttributes")
		;	local oldColors=wAttribs;
		;	
		$stStr=dllstructcreate("BYTE wc["&stringlen($str)&"]")
		for $i=1 to stringlen($str)
			dllstructsetdata($stStr,"wc",asc(stringmid($str,$i,1)), $i)
		next
		if (_WinAPI_WriteFile($hstd, dllstructgetptr($stStr), DllStructGetSize($stStr), $bytesWritten)) then
			if ($bytesWritten<>DllStructGetSize($stStr)) then
				return false
			endif
		else
			return false
		endif
	endif
	return false
endfunc
global $hNewScreenBuffer=$INVALID_HANDLE_VALUE
func CreateConsole($consoleTitle); returns $hConsole or $INVALID_HANDLE_VALUE
	AllocConsole()
	if (not AttachConsole($ATTACH_PARENT_PROCESS)) then 
		if (AttachConsole(GetCurrentProcessId())) then
			;drop through we have success
		else
			return false
		endif
	else
		return false
	endif
	
	if (""<>$consoleTitle) then
		SetConsoleTitle($consoleTitle)
	endif
	;$hNewScreenBuffer = CreateConsoleScreenBuffer(bitor($GENERIC_READ,$GENERIC_WRITE), bitor($FILE_SHARE_READ,$FILE_SHARE_WRITE),0,$CONSOLE_TEXTMODE_BUFFER, 0)
	;SetConsoleActiveScreenBuffer($hNewScreenBuffer)
	SetConsoleActiveScreenBuffer($hstd)
	;fSuccess = WriteConsoleOutput($hNewScreenBuffer,$chiBuffer,$coordBufSize,$coordBufCoord,dllstructgetptr($srctWriteRect))
endfunc

















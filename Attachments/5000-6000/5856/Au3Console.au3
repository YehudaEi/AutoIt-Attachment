#include-once
;===============================================================================
;
; Description:		: A list of colour values for the console
; Requirement:		: AutoIt Console Plugin - By: Mixture63 (Au3Console.dll)
; Note(s):			: $CC_* stands for console color *
;                     I'm red-green color blind, so some names may be wrong
;                     For use with ConsoleSetColours and ConsoleSetColor
;
;===============================================================================
Global Const $CC_BLACK = 0
Global Const $CC_DARKBLUE = 1
Global Const $CC_DARKGREEN = 2
Global Const $CC_DARKBLUEGREEN = 3
Global Const $CC_DARKBROWN = 4
Global Const $CC_PURPLE = 5
Global Const $CC_BROWN = 6
Global Const $CC_GREY = 7
Global Const $CC_DARKGREY = 8
Global Const $CC_BLUE = 9
Global Const $CC_GREEN = 10
Global Const $CC_BLUEGREEN = 11
Global Const $CC_RED = 12
Global Const $CC_PINK = 13
Global Const $CC_YELLOW = 14
Global Const $CC_WHITE = 15
;===============================================================================
;
; Description:		: Sets the colors of a "console"
; Parameter(s):		: $fg - Foreground Color
;                     $bg - Background Color
; Requirement:		: AutoIt Console Plugin - By: Mixture63 (Au3Console.dll)
; Return Value(s):	: n/a
; Author(s):		: nfwu
; Note(s):			: Notice the 's' in the name... colors.
;
;===============================================================================
Func ConsoleSetColors($fg, $bg)
	ConsoleSetColor($fg+$bg*16)
EndFunc
;===============================================================================
;
; Description:		: Prints a line to the "console" followed by a @CRLF
; Parameter(s):		: $data - The data to print
; Requirement:		: AutoIt Console Plugin - By: Mixture63 (Au3Console.dll)
; Return Value(s):	: n/a
; Author(s):		: nfwu
; Note(s):			: You cannot use ConsoleClearCurrentLine to clear data 
;                     printed by this as it positions the cursor at a new line
;                     after printing.
;
;===============================================================================
Func ConsolePrintLine($data)
	ConsolePrint($data&@CRLF)
EndFunc
;===============================================================================
;
; Description:		: Reads a line of input from the "console"
; Parameter(s):		: -
; Requirement:		: AutoIt Console Plugin - By: Mixture63 (Au3Console.dll)
; Return Value(s):	: The line that is read from the console
; Author(s):		: nfwu
; Note(s):			: -
;
;===============================================================================
Func ConsoleInputLine()
	Local $ret_val = ""
	Local $data = ConsoleInput(1)
	While $data <> @CR
		$ret_val &= $data
		$data = ConsoleInput(1)
	WEnd
	ConsoleInput(1) ;;Get rid of the LineFeed (@LF)
	Return $ret_val
EndFunc
;===============================================================================
;
; Description:		: Clears the current line the cursor is on in the "console"
; Parameter(s):		: -
; Requirement:		: AutoIt Console Plugin - By: Mixture63 (Au3Console.dll)
; Return Value(s):	: n/a
; Author(s):		: nfwu
; Note(s):			: You can only clear what you printed to the console if you 
;                     used ConsolePrint and did not have any @CR, @LF or @CRLF
;                     in the output.
;
;===============================================================================
Func ConsoleClearCurrentLine()
	For $i = 1 To 100
		ConsolePrint( Chr(8) )
	Next
	For $i = 1 To 100
		ConsolePrint( " " )
	Next
	For $i = 1 To 100
		ConsolePrint( Chr(8) )
	Next
EndFunc
;===============================================================================
;
; Description:		: Clears the "console" by restarting it.
; Parameter(s):		: $t - the title of the "console" window
; Requirement:		: AutoIt Console Plugin - By: Mixture63 (Au3Console.dll)
; Return Value(s):	: n/a
; Author(s):		: nfwu
; Note(s):			: -
;
;===============================================================================
Func ConsoleRestart($t)
	ConsoleFree()
	ConsoleLoad($t)
EndFunc
; #INDEX# =======================================================================================================================
; Title .........: Console
; AutoIt Version : 3.3.0.0+
; Language ......: English
; Description ...: Functions that assist with consoles.
; Author(s) .....: Janus Thorborg (Shaggi)
; ===============================================================================================================================
#include-once
#OnAutoItStartRegister "__Console__StartUp"

; #CURRENT# =====================================================================================================================
;Cout
;Cin
;Cerr
;system
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
;__Console__CreateConsole
;__Console__KillConsole
;__Console__StartUp
;__Console__ShutDown
;__Console__GetStdHandle
; ===============================================================================================================================

; #VARIABLES# ===================================================================================================================
;	Don't touch these.
Global $__Dll_Kernel32, $__Amount__Startup_Console, $__ConsoleHandle__Output, $__ConsoleHandle__Input, $__ConsoleHandle__Error
Global $_Included_Console = True
; ===============================================================================================================================
; #CONSTANTS# ===================================================================================================================
;	Thanks to Matt Diesel (Mat) for writing these down.
; Attributes flags (colors)
; WinCon.h (153 - 160)
Global Const $COLOR_1 = 1
Global Const $COLOR_2 = 2
Global Const $COLOR_3 = 3
Global Const $COLOR_4 = 4
Global Const $COLOR_5 = 5
Global Const $COLOR_6 = 6
Global Const $COLOR_7 = 7
Global Const $COLOR_8 = 8
Global Const $COLOR_9 = 9
Global Const $COLOR_10 = 10
Global Const $COLOR_11 = 11
Global Const $COLOR_12 = 12
Global Const $COLOR_13 = 13
Global Const $COLOR_14 = 14
Global Const $COLOR_15 = 15
Global Const $COLOR_16 = 16
Global Const $COLOR_17 = 17
Global Const $COLOR_18 = 18
Global Const $COLOR_19 = 19
Global Const $COLOR_20 = 20
Global Const $COLOR_21 = 21
Global Const $COLOR_22 = 22
Global Const $COLOR_23 = 23
Global Const $COLOR_24 = 24
Global Const $COLOR_25 = 25
Global Const $COLOR_26 = 26
Global Const $COLOR_27 = 27
Global Const $COLOR_28 = 28
Global Const $COLOR_29 = 29
Global Const $COLOR_30 = 30
Global Const $COLOR_31 = 31
Global Const $COLOR_32 = 32
Global Const $COLOR_33 = 33
Global Const $COLOR_34 = 34
Global Const $COLOR_35 = 35
Global Const $COLOR_36 = 36
Global Const $COLOR_37 = 37
Global Const $COLOR_38 = 38
Global Const $COLOR_39 = 39
Global Const $COLOR_40 = 40
Global Const $COLOR_41 = 41
Global Const $COLOR_42 = 42
Global Const $COLOR_43 = 43
Global Const $COLOR_44 = 44
Global Const $COLOR_45 = 45
Global Const $COLOR_46 = 46
Global Const $COLOR_47 = 47
Global Const $COLOR_48 = 48
Global Const $COLOR_49 = 49
Global Const $COLOR_50 = 50
Global Const $COLOR_51 = 51
Global Const $COLOR_52 = 52
Global Const $COLOR_53 = 53
Global Const $COLOR_54 = 54
Global Const $COLOR_55 = 55
Global Const $COLOR_56 = 56
Global Const $COLOR_57 = 57
Global Const $COLOR_58 = 58
Global Const $COLOR_59 = 59
Global Const $COLOR_60 = 60
Global Const $COLOR_61 = 61
Global Const $COLOR_62 = 62
Global Const $COLOR_63 = 63
Global Const $COLOR_64 = 64
Global Const $COLOR_65 = 65
Global Const $COLOR_66 = 66
Global Const $COLOR_67 = 67
Global Const $COLOR_68 = 68
Global Const $COLOR_69 = 69
Global Const $COLOR_70 = 70
Global Const $COLOR_71 = 71
Global Const $COLOR_72 = 72
Global Const $COLOR_73 = 73
Global Const $COLOR_74 = 74
Global Const $COLOR_75 = 75
Global Const $COLOR_76 = 76
Global Const $COLOR_77 = 77
Global Const $COLOR_78 = 78
Global Const $COLOR_79 = 79
Global Const $COLOR_80 = 80
Global Const $COLOR_81 = 81
Global Const $COLOR_82 = 82
Global Const $COLOR_83 = 83
Global Const $COLOR_84 = 84
Global Const $COLOR_85 = 85
Global Const $COLOR_86 = 86
Global Const $COLOR_87 = 87
Global Const $COLOR_88 = 88
Global Const $COLOR_89 = 89
Global Const $COLOR_90 = 90
Global Const $COLOR_91 = 91
Global Const $COLOR_92 = 92
Global Const $COLOR_93 = 93
Global Const $COLOR_94 = 94
Global Const $COLOR_95 = 95
Global Const $COLOR_96 = 96
Global Const $COLOR_97 = 97
Global Const $COLOR_98 = 98
Global Const $COLOR_99 = 99
Global Const $COLOR_100 = 100
Global Const $COLOR_101 = 101
Global Const $COLOR_102 = 102
Global Const $COLOR_103 = 103
Global Const $COLOR_104 = 104
Global Const $COLOR_105 = 105
Global Const $COLOR_106 = 106
Global Const $COLOR_107 = 107
Global Const $COLOR_108 = 108
Global Const $COLOR_109 = 109
Global Const $COLOR_110 = 110
Global Const $COLOR_111 = 111
Global Const $COLOR_112 = 112
Global Const $COLOR_113 = 113
Global Const $COLOR_114 = 114
Global Const $COLOR_115 = 115
Global Const $COLOR_116 = 116
Global Const $COLOR_117 = 117
Global Const $COLOR_118 = 118
Global Const $COLOR_119 = 119
Global Const $COLOR_120 = 120
Global Const $COLOR_121 = 121
Global Const $COLOR_122 = 122
Global Const $COLOR_123 = 123
Global Const $COLOR_124 = 124
Global Const $COLOR_125 = 125
Global Const $COLOR_126 = 126
Global Const $COLOR_127 = 127
Global Const $COLOR_128 = 128
Global Const $COLOR_129 = 129
Global Const $COLOR_130 = 130
Global Const $COLOR_131 = 131
Global Const $COLOR_132 = 132
Global Const $COLOR_133 = 133
Global Const $COLOR_134 = 134
Global Const $COLOR_135 = 135
Global Const $COLOR_136 = 136
Global Const $COLOR_137 = 137
Global Const $COLOR_138 = 138
Global Const $COLOR_139 = 139
Global Const $COLOR_140 = 140
Global Const $COLOR_141 = 141
Global Const $COLOR_142 = 142
Global Const $COLOR_143 = 143
Global Const $COLOR_144 = 144
Global Const $COLOR_145 = 145
Global Const $COLOR_146 = 146
Global Const $COLOR_147 = 147
Global Const $COLOR_148 = 148
Global Const $COLOR_149 = 149
Global Const $COLOR_150 = 150
Global Const $COLOR_151 = 151
Global Const $COLOR_152 = 152
Global Const $COLOR_153 = 153
Global Const $COLOR_154 = 154
Global Const $COLOR_155 = 155
Global Const $COLOR_156 = 156
Global Const $COLOR_157 = 157
Global Const $COLOR_158 = 158
Global Const $COLOR_159 = 159
Global Const $COLOR_160 = 160
Global Const $COLOR_161 = 161
Global Const $COLOR_162 = 162
Global Const $COLOR_163 = 163
Global Const $COLOR_164 = 164
Global Const $COLOR_165 = 165
Global Const $COLOR_166 = 166
Global Const $COLOR_167 = 167
Global Const $COLOR_168 = 168
Global Const $COLOR_169 = 169
Global Const $COLOR_170 = 170
Global Const $COLOR_171 = 171
Global Const $COLOR_172 = 172
Global Const $COLOR_173 = 173
Global Const $COLOR_174 = 174
Global Const $COLOR_175 = 175
Global Const $COLOR_176 = 176
Global Const $COLOR_177 = 177
Global Const $COLOR_178 = 178
Global Const $COLOR_179 = 179
Global Const $COLOR_180 = 180
Global Const $COLOR_181 = 181
Global Const $COLOR_182 = 182
Global Const $COLOR_183 = 183
Global Const $COLOR_184 = 184
Global Const $COLOR_185 = 185
Global Const $COLOR_186 = 186
Global Const $COLOR_187 = 187
Global Const $COLOR_188 = 188
Global Const $COLOR_189 = 189
Global Const $COLOR_190 = 190
Global Const $COLOR_191 = 191
Global Const $COLOR_192 = 192
Global Const $COLOR_193 = 193
Global Const $COLOR_194 = 194
Global Const $COLOR_195 = 195
Global Const $COLOR_196 = 196
Global Const $COLOR_197 = 197
Global Const $COLOR_198 = 198
Global Const $COLOR_199 = 199
Global Const $COLOR_200 = 200
Global Const $COLOR_201 = 201
Global Const $COLOR_202 = 202
Global Const $COLOR_203 = 203
Global Const $COLOR_204 = 204
Global Const $COLOR_205 = 205
Global Const $COLOR_206 = 206
Global Const $COLOR_207 = 207
Global Const $COLOR_208 = 208
Global Const $COLOR_209 = 209
Global Const $COLOR_210 = 210
Global Const $COLOR_211 = 211
Global Const $COLOR_212 = 212
Global Const $COLOR_213 = 213
Global Const $COLOR_214 = 214
Global Const $COLOR_215 = 215
Global Const $COLOR_216 = 216
Global Const $COLOR_217 = 217
Global Const $COLOR_218 = 218
Global Const $COLOR_219 = 219
Global Const $COLOR_220 = 220
Global Const $COLOR_221 = 221
Global Const $COLOR_222 = 222
Global Const $COLOR_223 = 223
Global Const $COLOR_224 = 224
Global Const $COLOR_225 = 225
Global Const $COLOR_226 = 226
Global Const $COLOR_227 = 227
Global Const $COLOR_228 = 228
Global Const $COLOR_229 = 229
Global Const $COLOR_230 = 230
Global Const $COLOR_231 = 231
Global Const $COLOR_232 = 232
Global Const $COLOR_233 = 233
Global Const $COLOR_234 = 234
Global Const $COLOR_235 = 235
Global Const $COLOR_236 = 236
Global Const $COLOR_237 = 237
Global Const $COLOR_238 = 238
Global Const $COLOR_239 = 239
Global Const $COLOR_240 = 240
Global Const $COLOR_241 = 241
Global Const $COLOR_242 = 242
Global Const $COLOR_243 = 243
Global Const $COLOR_244 = 244
Global Const $COLOR_245 = 245
Global Const $COLOR_246 = 246
Global Const $COLOR_247 = 247
Global Const $COLOR_248 = 248
Global Const $COLOR_249 = 249
Global Const $COLOR_250 = 250
Global Const $COLOR_251 = 251
Global Const $COLOR_252 = 252
Global Const $COLOR_253 = 253
Global Const $COLOR_254 = 254
Global Const $COLOR_255 = 255
; Attributes flags
; WinCon.h (161 - 169)
Global Const $COMMON_LVB_LEADING_BYTE = 0x0100 ; Leading Byte of DBCS
Global Const $COMMON_LVB_TRAILING_BYTE = 0x0200 ; Trailing Byte of DBCS
Global Const $COMMON_LVB_GRID_HORIZONTAL = 0x0400 ; DBCS: Grid attribute: top horizontal.
Global Const $COMMON_LVB_GRID_LVERTICAL = 0x0800 ; DBCS: Grid attribute: left vertical.
Global Const $COMMON_LVB_GRID_RVERTICAL = 0x1000 ; DBCS: Grid attribute: right vertical.
Global Const $COMMON_LVB_REVERSE_VIDEO = 0x4000 ; DBCS: Reverse fore/back ground attribute.
Global Const $COMMON_LVB_UNDERSCORE = 0x8000 ; DBCS: Underscore.
Global Const $COMMON_LVB_SBCSDBCS = 0x0300 ; SBCS or DBCS flag.
; ===============================================================================================================================
; #STRUCTURES# ==================================================================================================================
; $tag_CONSOLE_SCREEN_BUFFER_INFO
; $tagCHAR_INFO_W
; $tagPSMALL_RECT
; ===============================================================================================================================
;	These are merely provided for convinience, they aren't used (yet)
Global Const $tag_CONSOLE_SCREEN_BUFFER_INFO = "short dwSizeX; short dwSizeY; short dwCursorPositionX;short dwCursorPositionY; word wAttributes;" & _
		"SHORT srWindowLeft; SHORT srWindowRight; SHORT srWindowLeft; SHORT srWindowBottom;" & _
		"short dwMaximumWindowSizeX; short dwMaximumWindowSizeY"
Global Const $tagCHAR_INFO_W = "WCHAR UnicodeChar; WORD Attributes"
Global Const $tagPSMALL_RECT = "SHORT Left; SHORT Right; SHORT Left; SHORT Bottom;"
; ===============================================================================================================================
; #FUNCTION# ====================================================================================================================
; Name...........: system
; Description ...: Invokes the command processor to execute a command. Once the command execution has terminated, the processor
;				   gives the control back to the program, returning an int value, whose interpretation is system-dependent.
;				   The function call also be used with NULL as argument to check whether a command processor exists.
; Syntax.........: system($szCommand)
; Parameters ....: $szString      		- A string containing a system command to be executed.
; Return values .: Success              - Depends on command given.
;                  Failure              - Depends on command given.
; Author ........: Janus Thorborg (Shaggi)
; Modified.......: 15/03/2011
; Remarks .......: Common use is system("pause").
; Related .......:
; Link ..........: http://www.cplusplus.com/reference/clibrary/cstdlib/system/
; Example .......: No
; ===============================================================================================================================
Func system($szCommand)
	If $szCommand Then
		If Not $__Amount__Startup_Console Then
			__Console__CreateConsole()
			$__Amount__Startup_Console += 1
		EndIf
		Return RunWait(@ComSpec & " /c " & StringUpper($szCommand), @ScriptDir, Default, 0x10)
	EndIf
	Return False
EndFunc   ;==>system
; #FUNCTION# ====================================================================================================================
; Name...........: Cout
; Description ...: Writes a UNICODE string to the Standard Output Stream, with optional attributes. Similar to std::cout in C++ and
;					ConsoleWrite().
; Syntax.........: Cout($szString [, $iAttr = -1])
; Parameters ....: $szString      		- A string to write to the Standard Output Stream.
;                  $iAttr             	- If supplied, the function sets the current text attributes to this before writing,
;										  and resets it back to normal after writing. Attributes (Thanks to Matt Diesel (Mat)):
;                                       |FOREGROUND_BLUE - Text color contains blue.
;                                       |FOREGROUND_GREEN - Text color contains green.
;                                       |FOREGROUND_RED - Text color contains red.
;                                       |FOREGROUND_INTENSITY - Text color is intensified.
;                                       |BACKGROUND_BLUE - Background color contains blue.
;                                       |BACKGROUND_GREEN - Background color contains green.
;                                       |BACKGROUND_RED - Background color contains red.
;                                       |BACKGROUND_INTENSITY - Background color is intensified.
;                                         BitOR these together, if more than one attribute is used.
; Return values .: Success              - True
;                  Failure              - False
; Author ........: Janus Thorborg (Shaggi)
; Modified.......: 15/03/2011
; Remarks .......:
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/ms687401(VS.85).aspx
; Example .......: No
; ===============================================================================================================================
Func Cout($szString, $iAttr = -1)
	If Not $__Amount__Startup_Console Then
		__Console__CreateConsole()
		$__Amount__Startup_Console += 1
	EndIf
	Local $lpBuffer = DllStructCreate("wchar[" & StringLen($szString) & "]")
	DllStructSetData($lpBuffer, 1, $szString)
	Local $lpNumberOfCharsWritten = 0
	ConsoleWrite($szString)
	Switch $iAttr
		Case -1
			Local $aResult = DllCall($__Dll_Kernel32, "BOOL", "WriteConsoleW", _
					"handle", $__ConsoleHandle__Output, _
					"ptr", DllStructGetPtr($lpBuffer), _
					"dword", StringLen($szString), _
					"dword*", $lpNumberOfCharsWritten, _
					"ptr", 0)
			Return $aResult[0]
		Case Else
			Local $aResult1 = DllCall($__Dll_Kernel32, "BOOL", "SetConsoleTextAttribute", "handle", $__ConsoleHandle__Output, "word", $iAttr)
			Local $aResult2 = DllCall($__Dll_Kernel32, "BOOL", "WriteConsoleW", _
					"handle", $__ConsoleHandle__Output, _
					"ptr", DllStructGetPtr($lpBuffer), _
					"dword", StringLen($szString), _
					"dword*", $lpNumberOfCharsWritten, _
					"ptr", 0)
			Local $aResult3 = DllCall($__Dll_Kernel32, "BOOL", "SetConsoleTextAttribute", "handle", $__ConsoleHandle__Output, "word", 0x7)
			Switch $aResult2[0]
				Case 0
					Return False
				Case Else
					Return (($aResult1[0] <> 0) AND ($aResult3[0] <> 0))
			EndSwitch
	EndSwitch
	Return False
EndFunc   ;==>Cout
; #FUNCTION# ====================================================================================================================
; Name...........: Cerr
; Description ...: Writes a UNICODE string to the Standard Error Stream, with optional attributes. Similar to std::cerr in C++ and
;					ConsoleWriteError().
; Syntax.........: Cerr($szString [, $iAttr = -1])
; Parameters ....: $szString      		- A string to write to the Standard Error Stream.
;                  $iAttr             	- If supplied, the function sets the current text attributes to this before writing,
;										  and resets it back to normal after writing. Attributes (Thanks to Matt Diesel (Mat)):
;                                       |FOREGROUND_BLUE - Text color contains blue.
;                                       |FOREGROUND_GREEN - Text color contains green.
;                                       |FOREGROUND_RED - Text color contains red.
;                                       |FOREGROUND_INTENSITY - Text color is intensified.
;                                       |BACKGROUND_BLUE - Background color contains blue.
;                                       |BACKGROUND_GREEN - Background color contains green.
;                                       |BACKGROUND_RED - Background color contains red.
;                                       |BACKGROUND_INTENSITY - Background color is intensified.
;                                         BitOR these together, if more than one attribute is used.
; Return values .: Success              - True
;                  Failure              - False
; Author ........: Janus Thorborg (Shaggi)
; Modified.......: 15/03/2011
; Remarks .......:
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/ms687401(VS.85).aspx
; Example .......: No
; ===============================================================================================================================
Func Cerr($szString, $iAttr = -1)
	If Not $__Amount__Startup_Console Then
		__Console__CreateConsole()
		$__Amount__Startup_Console += 1
	EndIf
	Local $lpBuffer = DllStructCreate("wchar[" & StringLen($szString) & "]")
	DllStructSetData($lpBuffer, 1, $szString)
	Local $lpNumberOfCharsWritten = 0
	ConsoleWrite($szString)
	Switch $iAttr
		Case -1
			Local $aResult = DllCall($__Dll_Kernel32, "BOOL", "WriteConsoleW", _
					"handle", $__ConsoleHandle__Error, _
					"ptr", DllStructGetPtr($lpBuffer), _
					"dword", StringLen($szString), _
					"dword*", $lpNumberOfCharsWritten, _
					"ptr", 0)
			Return $aResult[0]
		Case Else
			Local $aResult1 = DllCall($__Dll_Kernel32, "BOOL", "SetConsoleTextAttribute", "handle", $__ConsoleHandle__Error, "word", $iAttr)
			Local $aResult2 = DllCall($__Dll_Kernel32, "BOOL", "WriteConsoleW", _
					"handle", $__ConsoleHandle__Error, _
					"ptr", DllStructGetPtr($lpBuffer), _
					"dword", StringLen($szString), _
					"dword*", $lpNumberOfCharsWritten, _
					"ptr", 0)
			Local $aResult3 = DllCall($__Dll_Kernel32, "BOOL", "SetConsoleTextAttribute", "handle", $__ConsoleHandle__Error, "word", 0x7)
			Switch $aResult2[0]
				Case 0
					Return False
				Case Else
					Return (($aResult1[0] <> 0) AND ($aResult3[0] <> 0))
			EndSwitch
	EndSwitch
	Return False
EndFunc   ;==>Cerr
; #FUNCTION# ====================================================================================================================
; Name...........: Cin
; Description ...: Retrieves a UNICODE string from the Standard Input Stream, with optional size. Similar to std::cin in C++.
; Syntax.........: Cin(ByRef $szString [, $iSize = 1024])
; Parameters ....: $szString      		- A string the content is copied to.
;                  $iSize            	- If supplied, the function sets the maximal size of the characters read to this.
; Return values .: Success              - Actual amount of characters read.
;                  Failure              - False
; Author ........: Janus Thorborg (Shaggi)
; Modified.......: 16/03/2011
; Remarks .......: Returns once something has been typed into console AND enter is pressed.
; Related .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/ms684958(VS.85).aspx
; Example .......: No
; ===============================================================================================================================
Func Cin(ByRef $szString, $iSize = 1024)
	If Not $__Amount__Startup_Console Then
		__Console__CreateConsole()
		$__Amount__Startup_Console += 1
	EndIf
	Local $lpBuffer = DllStructCreate("wchar[" & $iSize & "]")
	Local $lpNumberOfCharsRead = 0
	Local $aResult = DllCall($__Dll_Kernel32, "BOOL", "ReadConsoleW", _
			"handle", $__ConsoleHandle__Input, _
			"ptr", DllStructGetPtr($lpBuffer), _
			"dword", DllStructGetSize($lpBuffer), _
			"dword*", $lpNumberOfCharsRead, _
			"ptr", 0)
	Select
		Case Not $aResult[0]
			Return False
		Case Else
			$szString = StringTrimRight(DllStructGetData($lpBuffer, 1),2)
			Return $aResult[4]
	EndSelect
EndFunc   ;==>Cin
; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __Console_StartUp()
; Description ...: Checks if running under SciTE, if, then executes the script via ShellExecute so own console can be opened.
;				   Exits with the errorcode the executed script did.
; Syntax.........: __Console_StartUp()
; Parameters ....: None
; Return values .: None
; Author ........: Janus Thorborg (Shaggi)
; Modified.......: 16/03/2011
; Remarks .......: This function is used internally. Called automatically on AutoIt startup.
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __Console__StartUp()
	Local $bIsRunningFromScite = StringInStr($CmdLineRaw, "/ErrorStdOut")
	Local $bIsRecursed = Execute(StringLeft($Cmdline[$Cmdline[0]],StringLen("/Console=")))
	If ($bIsRunningFromScite > 0) AND NOT $bIsRecursed Then
		Local $szCommandLine = '"' & @AutoItExe & '" "' & @ScriptFullPath & '" /Console=True'
		ConsoleWrite(@CRLF & "!<Console.au3>:" & @CRLF & @TAB & "Launching process on own..." & @CRLF & "+" & @TAB & "CmdLine:" & $szCommandLine & @CRLF)
		Local $iReturnCode = RunWait($szCommandline)
		ConsoleWrite(@CRLF & ">" & @TAB & @ScriptName & " returned " & $iReturnCode & " (0x" & Hex($iReturnCode, 8) & ")" & @CRLF)
		Exit $iReturnCode
	EndIf
	Global $__Dll_Kernel32 = DllOpen("kernel32.dll")
	OnAutoItExitRegister("__Console__ShutDown")
EndFunc   ;==>__Console_StartUp
; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __Console_ShutDown()
; Description ...: If a console is present, it detaches and closes any handles opened.
; Syntax.........: __Console_ShutDown()
; Parameters ....: None
; Return values .: None
; Author ........: Janus Thorborg (Shaggi)
; Modified.......: 15/03/2011
; Remarks .......: This function is used internally. Called automatically on AutoIt shutdown.
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __Console__ShutDown()
	If $__Amount__Startup_Console Then
		__Console__KillConsole()
		DllCall($__Dll_Kernel32,"BOOL","CloseHandle","handle",$__ConsoleHandle__Output)
		DllCall($__Dll_Kernel32,"BOOL","CloseHandle","handle",$__ConsoleHandle__Input)
		DllCall($__Dll_Kernel32,"BOOL","CloseHandle","handle",$__ConsoleHandle__Error)
	EndIf
	DllClose($__Dll_Kernel32)
EndFunc   ;==>__Console_ShutDown
; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __Console_CreateConsole()
; Description ...: Allocates an console, and opens up handles for the three standard streams: Input, Output and Error.
; Syntax.........: __Console_CreateConsole()
; Parameters ....: None
; Return values .: Success              - True
;                  Failure              - False
; Author ........: Janus Thorborg (Shaggi)
; Modified.......: 15/03/2011
; Remarks .......: This function is used internally. Called automatically the first time any of the Cin, Cerr or Cout funcs is used.
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __Console__CreateConsole()
	If Not $__Amount__Startup_Console Then
		$__Amount__Startup_Console += 1
		Local $aResult = DllCall($__Dll_Kernel32, "BOOL", "AllocConsole")
		$__ConsoleHandle__Output = __Console__GetStdHandle()
		$__ConsoleHandle__Input = __Console__GetStdHandle(-10)
		$__ConsoleHandle__Error = __Console__GetStdHandle(-12)
		Return $aResult[0]
	EndIf
EndFunc   ;==>__Console__CreateConsole
; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __Console_ShutDown()
; Description ...: Frees the console from the process.
; Syntax.........: __Console_ShutDown()
; Parameters ....: None
; Return values .: None
; Author ........: Janus Thorborg (Shaggi)
; Modified.......: 15/03/2011
; Remarks .......: This function is used internally. Called automatically on AutoIt shutdown.
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __Console__KillConsole()
	Local $aResult = DllCall($__Dll_Kernel32, "BOOL", "FreeConsole")
	Return $aResult[0]
EndFunc   ;==>__Console__KillConsole
; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __Console_GetStdHandle()
; Description ...: Returns an handle to the desired standard stream.
; Syntax.........: __Console_GetStdHandle()
; Parameters ....: None
; Return values .: Success              - A handle to the stream.
;                  Failure              - 0
; Author ........: Janus Thorborg (Shaggi)
; Modified.......: 15/03/2011
; Remarks .......: This function is used internally. Called automatically the first time any of the Cin, Cerr or Cout funcs is used.
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __Console__GetStdHandle($nStdHandle = -11)
	Local $aResult = DllCall($__Dll_Kernel32, "handle", "GetStdHandle", _
			"dword", $nStdHandle)
	Return $aResult[0]
EndFunc   ;==>__Console__GetStdHandle
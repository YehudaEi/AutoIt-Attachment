;example
#include <GUIConstants.au3>

GUICreate("my gui")
$a1 = GUICtrlCreateButton("asfds",5,5)
$a2 = GUICtrlCreateButton("sdfg",25,25)
$a3 = GUICtrlCreateButton("vcmn",45,45)
$a4 = GUICtrlCreateButton("fgj",65,65)
$a5 = GUICtrlCreateButton("fgj",85,85)
$a6 = GUICtrlCreateButton("uir",105,105)
$container1 = _GUICtrlCreateContainer($a2,$a4,$a6)
$container2 = _GUICtrlCreateContainer($a1,$a3,$a5)
GUISetState()


_GUIContainerSetState($container2,$GUI_HIDE)
sleep(500)
_GUIContainerSetState($container1,$GUI_HIDE)
_GUIContainerSetState($container2,$GUI_SHOW)

sleep(500)
_GUIContainerSetState($container1,$GUI_SHOW)
_GUIContainerSetState($container2,$GUI_HIDE)
sleep(500)
; /example

#include-once
;===============================================================================
;
; Function Name:   _GUICtrlCreateContainer($ctrl_1, ctrl_2, ... , ctrl_n)
; Description:    Creates a container for mass GUIcontrol handling
; Parameter(s):   $ctrl_1 = the first id of the container
;				  $ctrl_2 = the second id
;				  $ctrl_n = ... the n'th id (up to 255 id's supported)
; Requirement(s):  none
; Return Value(s): the id of the container
; Author(s):       rakudave
;
;===============================================================================

Func _GUICtrlCreateContainer($ctrl_1, $ctrl_2, $ctrl_3 = 0, $ctrl_4 = 0, $ctrl_5 = 0, $ctrl_6 = 0, $ctrl_7 = 0, $ctrl_8 = 0, $ctrl_9 = 0, $ctrl_10 = 0, $ctrl_11 = 0, $ctrl_12 = 0, $ctrl_13 = 0, $ctrl_14 = 0, $ctrl_15 = 0, $ctrl_16 = 0, $ctrl_17 = 0, $ctrl_18 = 0, $ctrl_19 = 0, $ctrl_20 = 0, $ctrl_21 = 0, $ctrl_22 = 0, $ctrl_23 = 0, $ctrl_24 = 0, $ctrl_25 = 0, $ctrl_26 = 0, $ctrl_27 = 0, $ctrl_28 = 0, $ctrl_29 = 0, $ctrl_30 = 0, $ctrl_31 = 0, $ctrl_32 = 0, $ctrl_33 = 0, $ctrl_34 = 0, $ctrl_35 = 0, $ctrl_36 = 0, $ctrl_37 = 0, $ctrl_38 = 0, $ctrl_39 = 0, $ctrl_40 = 0, $ctrl_41 = 0, $ctrl_42 = 0, $ctrl_43 = 0, $ctrl_44 = 0, $ctrl_45 = 0, $ctrl_46 = 0, $ctrl_47 = 0, $ctrl_48 = 0, $ctrl_49 = 0, $ctrl_50 = 0, $ctrl_51 = 0, $ctrl_52 = 0, $ctrl_53 = 0, $ctrl_54 = 0, $ctrl_55 = 0, $ctrl_56 = 0, $ctrl_57 = 0, $ctrl_58 = 0, $ctrl_59 = 0, $ctrl_60 = 0, $ctrl_61 = 0, $ctrl_62 = 0, $ctrl_63 = 0, $ctrl_64 = 0, $ctrl_65 = 0, $ctrl_66 = 0, $ctrl_67 = 0, $ctrl_68 = 0, $ctrl_69 = 0, $ctrl_70 = 0, $ctrl_71 = 0, $ctrl_72 = 0, $ctrl_73 = 0, $ctrl_74 = 0, $ctrl_75 = 0, $ctrl_76 = 0, $ctrl_77 = 0, $ctrl_78 = 0, $ctrl_79 = 0, $ctrl_80 = 0, $ctrl_81 = 0, $ctrl_82 = 0, $ctrl_83 = 0, $ctrl_84 = 0, $ctrl_85 = 0, $ctrl_86 = 0, $ctrl_87 = 0, $ctrl_88 = 0, $ctrl_89 = 0, $ctrl_90 = 0, $ctrl_91 = 0, $ctrl_92 = 0, $ctrl_93 = 0, $ctrl_94 = 0, $ctrl_95 = 0, $ctrl_96 = 0, $ctrl_97 = 0, $ctrl_98 = 0, $ctrl_99 = 0, $ctrl_100 = 0, $ctrl_101 = 0, $ctrl_102 = 0, $ctrl_103 = 0, $ctrl_104 = 0, $ctrl_105 = 0, $ctrl_106 = 0, $ctrl_107 = 0, $ctrl_108 = 0, $ctrl_109 = 0, $ctrl_110 = 0, $ctrl_111 = 0, $ctrl_112 = 0, $ctrl_113 = 0, $ctrl_114 = 0, $ctrl_115 = 0, $ctrl_116 = 0, $ctrl_117 = 0, $ctrl_118 = 0, $ctrl_119 = 0, $ctrl_120 = 0, $ctrl_121 = 0, $ctrl_122 = 0, $ctrl_123 = 0, $ctrl_124 = 0, $ctrl_125 = 0, $ctrl_126 = 0, $ctrl_127 = 0, $ctrl_128 = 0, $ctrl_129 = 0, $ctrl_130 = 0, $ctrl_131 = 0, $ctrl_132 = 0, $ctrl_133 = 0, $ctrl_134 = 0, $ctrl_135 = 0, $ctrl_136 = 0, $ctrl_137 = 0, $ctrl_138 = 0, $ctrl_139 = 0, $ctrl_140 = 0, $ctrl_141 = 0, $ctrl_142 = 0, $ctrl_143 = 0, $ctrl_144 = 0, $ctrl_145 = 0, $ctrl_146 = 0, $ctrl_147 = 0, $ctrl_148 = 0, $ctrl_149 = 0, $ctrl_150 = 0, $ctrl_151 = 0, $ctrl_152 = 0, $ctrl_153 = 0, $ctrl_154 = 0, $ctrl_155 = 0, $ctrl_156 = 0, $ctrl_157 = 0, $ctrl_158 = 0, $ctrl_159 = 0, $ctrl_160 = 0, $ctrl_161 = 0, $ctrl_162 = 0, $ctrl_163 = 0, $ctrl_164 = 0, $ctrl_165 = 0, $ctrl_166 = 0, $ctrl_167 = 0, $ctrl_168 = 0, $ctrl_169 = 0, $ctrl_170 = 0, $ctrl_171 = 0, $ctrl_172 = 0, $ctrl_173 = 0, $ctrl_174 = 0, $ctrl_175 = 0, $ctrl_176 = 0, $ctrl_177 = 0, $ctrl_178 = 0, $ctrl_179 = 0, $ctrl_180 = 0, $ctrl_181 = 0, $ctrl_182 = 0, $ctrl_183 = 0, $ctrl_184 = 0, $ctrl_185 = 0, $ctrl_186 = 0, $ctrl_187 = 0, $ctrl_188 = 0, $ctrl_189 = 0, $ctrl_190 = 0, $ctrl_191 = 0, $ctrl_192 = 0, $ctrl_193 = 0, $ctrl_194 = 0, $ctrl_195 = 0, $ctrl_196 = 0, $ctrl_197 = 0, $ctrl_198 = 0, $ctrl_199 = 0, $ctrl_200 = 0, $ctrl_201 = 0, $ctrl_202 = 0, $ctrl_203 = 0, $ctrl_204 = 0, $ctrl_205 = 0, $ctrl_206 = 0, $ctrl_207 = 0, $ctrl_208 = 0, $ctrl_209 = 0, $ctrl_210 = 0, $ctrl_211 = 0, $ctrl_212 = 0, $ctrl_213 = 0, $ctrl_214 = 0, $ctrl_215 = 0, $ctrl_216 = 0, $ctrl_217 = 0, $ctrl_218 = 0, $ctrl_219 = 0, $ctrl_220 = 0, $ctrl_221 = 0, $ctrl_222 = 0, $ctrl_223 = 0, $ctrl_224 = 0, $ctrl_225 = 0, $ctrl_226 = 0, $ctrl_227 = 0, $ctrl_228 = 0, $ctrl_229 = 0, $ctrl_230 = 0, $ctrl_231 = 0, $ctrl_232 = 0, $ctrl_233 = 0, $ctrl_234 = 0, $ctrl_235 = 0, $ctrl_236 = 0, $ctrl_237 = 0, $ctrl_238 = 0, $ctrl_239 = 0, $ctrl_240 = 0, $ctrl_241 = 0, $ctrl_242 = 0, $ctrl_243 = 0, $ctrl_244 = 0, $ctrl_245 = 0, $ctrl_246 = 0, $ctrl_247 = 0, $ctrl_248 = 0, $ctrl_249 = 0, $ctrl_250 = 0, $ctrl_251 = 0, $ctrl_252 = 0, $ctrl_253 = 0, $ctrl_254 = 0, $ctrl_255 = 0)
	Local $ctrl[256]
	$ctrl[1] = $ctrl_1
	$ctrl[2] = $ctrl_2
	$ctrl[3] = $ctrl_3
	$ctrl[4] = $ctrl_4
	$ctrl[5] = $ctrl_5
	$ctrl[6] = $ctrl_6
	$ctrl[7] = $ctrl_7
	$ctrl[8] = $ctrl_8
	$ctrl[9] = $ctrl_9
	$ctrl[10] = $ctrl_10
	$ctrl[11] = $ctrl_11
	$ctrl[12] = $ctrl_12
	$ctrl[13] = $ctrl_13
	$ctrl[14] = $ctrl_14
	$ctrl[15] = $ctrl_15
	$ctrl[16] = $ctrl_16
	$ctrl[17] = $ctrl_17
	$ctrl[18] = $ctrl_18
	$ctrl[19] = $ctrl_19
	$ctrl[20] = $ctrl_20
	$ctrl[21] = $ctrl_21
	$ctrl[22] = $ctrl_22
	$ctrl[23] = $ctrl_23
	$ctrl[24] = $ctrl_24
	$ctrl[25] = $ctrl_25
	$ctrl[26] = $ctrl_26
	$ctrl[27] = $ctrl_27
	$ctrl[28] = $ctrl_28
	$ctrl[29] = $ctrl_29
	$ctrl[30] = $ctrl_30
	$ctrl[31] = $ctrl_31
	$ctrl[32] = $ctrl_32
	$ctrl[33] = $ctrl_33
	$ctrl[34] = $ctrl_34
	$ctrl[35] = $ctrl_35
	$ctrl[36] = $ctrl_36
	$ctrl[37] = $ctrl_37
	$ctrl[38] = $ctrl_38
	$ctrl[39] = $ctrl_39
	$ctrl[40] = $ctrl_40
	$ctrl[41] = $ctrl_41
	$ctrl[42] = $ctrl_42
	$ctrl[43] = $ctrl_43
	$ctrl[44] = $ctrl_44
	$ctrl[45] = $ctrl_45
	$ctrl[46] = $ctrl_46
	$ctrl[47] = $ctrl_47
	$ctrl[48] = $ctrl_48
	$ctrl[49] = $ctrl_49
	$ctrl[50] = $ctrl_50
	$ctrl[51] = $ctrl_51
	$ctrl[52] = $ctrl_52
	$ctrl[53] = $ctrl_53
	$ctrl[54] = $ctrl_54
	$ctrl[55] = $ctrl_55
	$ctrl[56] = $ctrl_56
	$ctrl[57] = $ctrl_57
	$ctrl[58] = $ctrl_58
	$ctrl[59] = $ctrl_59
	$ctrl[60] = $ctrl_60
	$ctrl[61] = $ctrl_61
	$ctrl[62] = $ctrl_62
	$ctrl[63] = $ctrl_63
	$ctrl[64] = $ctrl_64
	$ctrl[65] = $ctrl_65
	$ctrl[66] = $ctrl_66
	$ctrl[67] = $ctrl_67
	$ctrl[68] = $ctrl_68
	$ctrl[69] = $ctrl_69
	$ctrl[70] = $ctrl_70
	$ctrl[71] = $ctrl_71
	$ctrl[72] = $ctrl_72
	$ctrl[73] = $ctrl_73
	$ctrl[74] = $ctrl_74
	$ctrl[75] = $ctrl_75
	$ctrl[76] = $ctrl_76
	$ctrl[77] = $ctrl_77
	$ctrl[78] = $ctrl_78
	$ctrl[79] = $ctrl_79
	$ctrl[80] = $ctrl_80
	$ctrl[81] = $ctrl_81
	$ctrl[82] = $ctrl_82
	$ctrl[83] = $ctrl_83
	$ctrl[84] = $ctrl_84
	$ctrl[85] = $ctrl_85
	$ctrl[86] = $ctrl_86
	$ctrl[87] = $ctrl_87
	$ctrl[88] = $ctrl_88
	$ctrl[89] = $ctrl_89
	$ctrl[90] = $ctrl_90
	$ctrl[91] = $ctrl_91
	$ctrl[92] = $ctrl_92
	$ctrl[93] = $ctrl_93
	$ctrl[94] = $ctrl_94
	$ctrl[95] = $ctrl_95
	$ctrl[96] = $ctrl_96
	$ctrl[97] = $ctrl_97
	$ctrl[98] = $ctrl_98
	$ctrl[99] = $ctrl_99
	$ctrl[100] = $ctrl_100
	$ctrl[101] = $ctrl_101
	$ctrl[102] = $ctrl_102
	$ctrl[103] = $ctrl_103
	$ctrl[104] = $ctrl_104
	$ctrl[105] = $ctrl_105
	$ctrl[106] = $ctrl_106
	$ctrl[107] = $ctrl_107
	$ctrl[108] = $ctrl_108
	$ctrl[109] = $ctrl_109
	$ctrl[110] = $ctrl_110
	$ctrl[111] = $ctrl_111
	$ctrl[112] = $ctrl_112
	$ctrl[113] = $ctrl_113
	$ctrl[114] = $ctrl_114
	$ctrl[115] = $ctrl_115
	$ctrl[116] = $ctrl_116
	$ctrl[117] = $ctrl_117
	$ctrl[118] = $ctrl_118
	$ctrl[119] = $ctrl_119
	$ctrl[120] = $ctrl_120
	$ctrl[121] = $ctrl_121
	$ctrl[122] = $ctrl_122
	$ctrl[123] = $ctrl_123
	$ctrl[124] = $ctrl_124
	$ctrl[125] = $ctrl_125
	$ctrl[126] = $ctrl_126
	$ctrl[127] = $ctrl_127
	$ctrl[128] = $ctrl_128
	$ctrl[129] = $ctrl_129
	$ctrl[130] = $ctrl_130
	$ctrl[131] = $ctrl_131
	$ctrl[132] = $ctrl_132
	$ctrl[133] = $ctrl_133
	$ctrl[134] = $ctrl_134
	$ctrl[135] = $ctrl_135
	$ctrl[136] = $ctrl_136
	$ctrl[137] = $ctrl_137
	$ctrl[138] = $ctrl_138
	$ctrl[139] = $ctrl_139
	$ctrl[140] = $ctrl_140
	$ctrl[141] = $ctrl_141
	$ctrl[142] = $ctrl_142
	$ctrl[143] = $ctrl_143
	$ctrl[144] = $ctrl_144
	$ctrl[145] = $ctrl_145
	$ctrl[146] = $ctrl_146
	$ctrl[147] = $ctrl_147
	$ctrl[148] = $ctrl_148
	$ctrl[149] = $ctrl_149
	$ctrl[150] = $ctrl_150
	$ctrl[151] = $ctrl_151
	$ctrl[152] = $ctrl_152
	$ctrl[153] = $ctrl_153
	$ctrl[154] = $ctrl_154
	$ctrl[155] = $ctrl_155
	$ctrl[156] = $ctrl_156
	$ctrl[157] = $ctrl_157
	$ctrl[158] = $ctrl_158
	$ctrl[159] = $ctrl_159
	$ctrl[160] = $ctrl_160
	$ctrl[161] = $ctrl_161
	$ctrl[162] = $ctrl_162
	$ctrl[163] = $ctrl_163
	$ctrl[164] = $ctrl_164
	$ctrl[165] = $ctrl_165
	$ctrl[166] = $ctrl_166
	$ctrl[167] = $ctrl_167
	$ctrl[168] = $ctrl_168
	$ctrl[169] = $ctrl_169
	$ctrl[170] = $ctrl_170
	$ctrl[171] = $ctrl_171
	$ctrl[172] = $ctrl_172
	$ctrl[173] = $ctrl_173
	$ctrl[174] = $ctrl_174
	$ctrl[175] = $ctrl_175
	$ctrl[176] = $ctrl_176
	$ctrl[177] = $ctrl_177
	$ctrl[178] = $ctrl_178
	$ctrl[179] = $ctrl_179
	$ctrl[180] = $ctrl_180
	$ctrl[181] = $ctrl_181
	$ctrl[182] = $ctrl_182
	$ctrl[183] = $ctrl_183
	$ctrl[184] = $ctrl_184
	$ctrl[185] = $ctrl_185
	$ctrl[186] = $ctrl_186
	$ctrl[187] = $ctrl_187
	$ctrl[188] = $ctrl_188
	$ctrl[189] = $ctrl_189
	$ctrl[190] = $ctrl_190
	$ctrl[191] = $ctrl_191
	$ctrl[192] = $ctrl_192
	$ctrl[193] = $ctrl_193
	$ctrl[194] = $ctrl_194
	$ctrl[195] = $ctrl_195
	$ctrl[196] = $ctrl_196
	$ctrl[197] = $ctrl_197
	$ctrl[198] = $ctrl_198
	$ctrl[199] = $ctrl_199
	$ctrl[200] = $ctrl_200
	$ctrl[201] = $ctrl_201
	$ctrl[202] = $ctrl_202
	$ctrl[203] = $ctrl_203
	$ctrl[204] = $ctrl_204
	$ctrl[205] = $ctrl_205
	$ctrl[206] = $ctrl_206
	$ctrl[207] = $ctrl_207
	$ctrl[208] = $ctrl_208
	$ctrl[209] = $ctrl_209
	$ctrl[210] = $ctrl_210
	$ctrl[211] = $ctrl_211
	$ctrl[212] = $ctrl_212
	$ctrl[213] = $ctrl_213
	$ctrl[214] = $ctrl_214
	$ctrl[215] = $ctrl_215
	$ctrl[216] = $ctrl_216
	$ctrl[217] = $ctrl_217
	$ctrl[218] = $ctrl_218
	$ctrl[219] = $ctrl_219
	$ctrl[220] = $ctrl_220
	$ctrl[221] = $ctrl_221
	$ctrl[222] = $ctrl_222
	$ctrl[223] = $ctrl_223
	$ctrl[224] = $ctrl_224
	$ctrl[225] = $ctrl_225
	$ctrl[226] = $ctrl_226
	$ctrl[227] = $ctrl_227
	$ctrl[228] = $ctrl_228
	$ctrl[229] = $ctrl_229
	$ctrl[230] = $ctrl_230
	$ctrl[231] = $ctrl_231
	$ctrl[232] = $ctrl_232
	$ctrl[233] = $ctrl_233
	$ctrl[234] = $ctrl_234
	$ctrl[235] = $ctrl_235
	$ctrl[236] = $ctrl_236
	$ctrl[237] = $ctrl_237
	$ctrl[238] = $ctrl_238
	$ctrl[239] = $ctrl_239
	$ctrl[240] = $ctrl_240
	$ctrl[241] = $ctrl_241
	$ctrl[242] = $ctrl_242
	$ctrl[243] = $ctrl_243
	$ctrl[244] = $ctrl_244
	$ctrl[245] = $ctrl_245
	$ctrl[246] = $ctrl_246
	$ctrl[247] = $ctrl_247
	$ctrl[248] = $ctrl_248
	$ctrl[249] = $ctrl_249
	$ctrl[250] = $ctrl_250
	$ctrl[251] = $ctrl_251
	$ctrl[252] = $ctrl_252
	$ctrl[253] = $ctrl_253
	$ctrl[254] = $ctrl_254
	$ctrl[255] = $ctrl_255
return $ctrl
EndFunc


;===============================================================================
;
; Function Name:   _GUIContainerSetState($ctrl,$state)
; Description:    Changes the state of a container
; Parameter(s):   $ctrl = the id of the container
;				  $state = the state of the container (such as $GUI_DISABLE)
; Requirement(s):  none
; Return Value(s): 0 if $ctrl is not an array
; Author(s):       rakudave
;
;===============================================================================
Func _GUIContainerSetState($ctrl,$state)
	If IsArray($ctrl) = 0 then return 0
	for $x = 1 to 255
		GUICtrlSetState($ctrl[$x],$state)
		If $ctrl[$x] = 0 then ExitLoop
	next
	return 1
EndFunc

;===============================================================================
;
; Function Name:   _GUIContainerSetBkColor($ctrl,$color)
; Description:    Sets the background color of a container
; Parameter(s):   $ctrl = the id of the container
;				  $color = the backgroundcolor (hex)
; Requirement(s):  none
; Return Value(s): 0 if $ctrl is not an array
; Author(s):       rakudave
;
;===============================================================================
Func _GUIContainerSetBkColor($ctrl,$color)
	If IsArray($ctrl) = 0 then return 0
	for $x = 1 to 255
		GUICtrlSetBkColor($ctrl[$x],$color)
		If $ctrl[$x] = 0 then ExitLoop
	next
	return 1
EndFunc

;===============================================================================
;
; Function Name:   _GUIContainerSetColor($ctrl,$color)
; Description:    Sets the text color of a container
; Parameter(s):   $ctrl = the id of the container
;				  $color = the color (hex)
; Requirement(s):  none
; Return Value(s): 0 if $ctrl is not an array
; Author(s):       rakudave
;
;===============================================================================
Func _GUIContainerSetColor($ctrl,$color)
	If IsArray($ctrl) = 0 then return 0
	for $x = 1 to 255
		GUICtrlSetColor($ctrl[$x],$color)
		If $ctrl[$x] = 0 then ExitLoop
	next
	return 1
EndFunc

;===============================================================================
;
; Function Name:   _GUIContainerSetData($ctrl,$data[,$default = -1])
; Description:    Modifies the data for a container
; Parameter(s):   $ctrl = the id of the container
;				  $data = the data to set
;				  $default = [optional] default value
; Requirement(s):  none
; Return Value(s): 0 if $ctrl is not an array
; Author(s):       rakudave
;
;===============================================================================
Func _GUIContainerSetData($ctrl,$data,$default = -1)
	If IsArray($ctrl) = 0 then return 0
	for $x = 1 to 255
		GUICtrlSetData($ctrl[$x],$data,$default)
		If $ctrl[$x] = 0 then ExitLoop
	next
	return 1
EndFunc

;===============================================================================
;
; Function Name:   _GUIContainerSetCursor($ctrl,$cursor)
; Description:    Sets mouse cursor icon for a particular container
; Parameter(s):   $ctrl = the id of the container
;				  $cursor = the cursorID
; Requirement(s):  none
; Return Value(s): 0 if $ctrl is not an array
; Author(s):       rakudave
;
;===============================================================================
Func _GUIContainerSetCursor($ctrl,$cursor)
	If IsArray($ctrl) = 0 then return 0
	for $x = 1 to 255
		GUICtrlSetCursor($ctrl[$x],$cursor)
		If $ctrl[$x] = 0 then ExitLoop
	next
	return 1
EndFunc

;===============================================================================
;
; Function Name:   _GUIContainerSetFont($ctrl, $size = 9, $weight = 400, $attribute = 0, $fontname = "Arial")
; Description:    Sets the Font parameter for a container
; Parameter(s):   $ctrl = the id of the container
;				  $size = Fontsize (default is 9). 
;				  $weight = [optional] Font weight (default 400 = normal). 
;				  $attribute = [optional] To define italic:2 underlined:4 strike:8 char format (add together the values of all the styles required, 2+4 = italic and underlined). 
;				  $fontname = [optional] The name of the font to use. 
;				  
; Requirement(s):  none
; Return Value(s): 0 if $ctrl is not an array
; Author(s):       rakudave
;
;===============================================================================
Func _GUIContainerSetFont($ctrl, $size = 9, $weight = 400, $attribute = 0, $fontname = "Arial")
	If IsArray($ctrl) = 0 then return 0
	for $x = 1 to 255
		GUICtrlSetFont($ctrl[$x], $size, $weight, $attribute, $fontname)
		If $ctrl[$x] = 0 then ExitLoop
	next
	return 1
EndFunc

;===============================================================================
;
; Function Name:   _GUIContainerSetImage($ctrl, $image, $iconID = -1, $icontype = 1)
; Description:    Sets the bitmap or icon image to use for a container
; Parameter(s):   $ctrl = the id of the container
;				  $image = The filename containing the picture to be display on the control. 
;				  iconID = [optional] Icon identifier if the file contain multiple icons. Otherwise -1. 
;				  icontype = [optional] To select a specific icon size : 0 = small, 1 = normal (default).
;				  		   	For a TreeViewItem the icon size : 2 = selected, 4 for non-selected item. 
;
; Requirement(s):  none
; Return Value(s): 0 if $ctrl is not an array
; Author(s):       rakudave
;
;===============================================================================
;GUICtrlSetImage . 
Func _GUIContainerSetImage($ctrl, $image, $iconID = -1, $icontype = 1)
	If IsArray($ctrl) = 0 then return 0
	for $x = 1 to 255
		GUICtrlSetImage($ctrl[$x],$image, $iconID, $icontype)

		If $ctrl[$x] = 0 then ExitLoop
	next
	return 1
EndFunc

;===============================================================================
;
; Function Name:   _GUIContainerSetLimit($ctrl, $max, $min = 0)
; Description:    Limit the number of characters/pixels for a container
; Parameter(s):   $ctrl = the id of the container
;				  $max = maximum
;				  $min = [optional] minimum
; Requirement(s):  none
; Return Value(s): 0 if $ctrl is not an array
; Author(s):       rakudave
;
;===============================================================================
Func _GUIContainerSetLimit($ctrl, $max, $min = 0)
	If IsArray($ctrl) = 0 then return 0
	for $x = 1 to 255
		GUICtrlSetLimit($ctrl[$x],$max,$min)
		If $ctrl[$x] = 0 then ExitLoop
	next
	return 1
EndFunc

;===============================================================================
;
; Function Name:   _GUIContainerSetStyle($ctrl,$style,$exStyle = -1)
; Description:    Changes the style of a container
; Parameter(s):   $ctrl = the id of the container
;				  $style = Defines the style of the control. See GUI Control Styles Appendix.                
;				  $exStyle = [optional] Defines the extended Style of the control. See Extended Style Table. 
; Requirement(s):  none
; Return Value(s): 0 if $ctrl is not an array
; Author(s):       rakudave
;
;===============================================================================
Func _GUIContainerSetStyle($ctrl,$style,$exStyle = -1)
	If IsArray($ctrl) = 0 then return 0
	for $x = 1 to 255
		GUICtrlSetStyle($ctrl[$x],$style, $exStyle)
		If $ctrl[$x] = 0 then ExitLoop
	next
	return 1
EndFunc

;===============================================================================
;
; Function Name:   _GUIContainerSetCursor($ctrl,$cursor)
; Description:    Sets the tip text associated with a container
; Parameter(s):   $ctrl = the id of the container
;				  $tip = text of the tip
; Requirement(s):  none
; Return Value(s): 0 if $ctrl is not an array
; Author(s):       rakudave
;
;===============================================================================
Func _GUIContainerSetTip($ctrl,$tip)
	If IsArray($ctrl) = 0 then return 0
	for $x = 1 to 255
		GUICtrlSetTip($ctrl[$x],$tip)
		If $ctrl[$x] = 0 then ExitLoop
	next
	return 1
EndFunc



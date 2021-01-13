#include <GUIConstants.au3>
#include <GuiListView.au3>
Opt("GUIOnEventMode", 1)

Dim $arColors[140][5]	; 0=Name, 1=Hex, 2=Sort-Index Saturation, 3=Sort-Index Brightness, 4= If 1 => Font=white
Dim $arItem[140], $ind, $col, $hex, $strCopy
Dim $PaleGreen = 0x98FB98, $Navy = 0x000080

$arColors[0][0] = "AliceBlue"
$arColors[0][1] = 0xF0F8FF
$arColors[0][2] = 109
$arColors[0][3] = 129
$arColors[1][0] = "AntiqueWhite"
$arColors[1][1] = 0xFAEBD7	
$arColors[1][2] = 69
$arColors[1][3] = 117
$arColors[2][0] = "Aqua"
$arColors[2][1] = 0x00FFFF 	
$arColors[2][2] = 31
$arColors[2][3] = 92
$arColors[3][0] = "Aquamarine"
$arColors[3][1] = 0x7FFFD4
$arColors[3][2] = 98
$arColors[3][3] = 118
$arColors[4][0] = "Azure"
$arColors[4][1] = 0xF0FFFF 	
$arColors[4][2] = 102
$arColors[4][3] = 138
$arColors[5][0] = "Beige"
$arColors[5][1] = 0xF5F5DC 	
$arColors[5][2] = 82
$arColors[5][3] = 121
$arColors[6][0] = "Bisque"
$arColors[6][1] = 0xFFE4C4 	
$arColors[6][2] = 66
$arColors[6][3] = 111
$arColors[7][0] = "Black"
$arColors[7][1] = 0x000000 	
$arColors[7][2] = 131
$arColors[7][3] = 0
$arColors[8][0] = "BlanchedAlmond"
$arColors[8][1] = 0xFFEBCD
$arColors[8][2] = 71
$arColors[8][3] = 115
$arColors[9][0] = "Blue"
$arColors[9][1] = 0x0000FF 	
$arColors[9][2] = 40
$arColors[9][3] = 6
$arColors[10][0] = "BlueViolet"
$arColors[10][1] = 0x8A2BE2
$arColors[10][2] = 41
$arColors[10][3] = 19
$arColors[11][0] = "Brown"
$arColors[11][1] = 0xA52A2A 	
$arColors[11][2] = 52
$arColors[11][3] = 16
$arColors[12][0] = "BurlyWood"
$arColors[12][1] = 0xDEB887	
$arColors[12][2] = 67
$arColors[12][3] = 79
$arColors[13][0] = "CadetBlue"
$arColors[13][1] = 0x5F9EA0	
$arColors[13][2] = 103
$arColors[13][3] = 62
$arColors[14][0] = "Chartreuse"
$arColors[14][1] = 0x7FFF00
$arColors[14][2] = 19
$arColors[14][3] = 96
$arColors[15][0] = "Chocolate"
$arColors[15][1] = 0xD2691E	
$arColors[15][2] = 8
$arColors[15][3] = 28
$arColors[16][0] = "Coral"
$arColors[16][1] = 0xFF7F50
$arColors[16][2] = 6
$arColors[16][3] = 53
$arColors[17][0] = "Cornflower Blue"
$arColors[17][1] = 0x6495ED
$arColors[17][2] = 113
$arColors[17][3] = 67
$arColors[18][0] = "Cornsilk"
$arColors[18][1] = 0xFFF8DC	
$arColors[18][2] = 77
$arColors[18][3] = 126
$arColors[19][0] = "Crimson"
$arColors[19][1] = 0xDC143C 	
$arColors[19][2] = 51
$arColors[19][3] = 22
$arColors[20][0] = "Cyan"
$arColors[20][1] = 0x00FFFF 	
$arColors[20][2] = 32
$arColors[20][3] = 93
$arColors[21][0] = "DarkBlue"
$arColors[21][1] = 0x00008B	
$arColors[21][2] = 38
$arColors[21][3] = 2
$arColors[22][0] = "DarkCyan"
$arColors[22][1] = 0x008B8B	
$arColors[22][2] = 30
$arColors[22][3] = 34
$arColors[23][0] = "DarkGoldenrod"
$arColors[23][1] = 0xB8860B
$arColors[23][2] = 12
$arColors[23][3] = 40
$arColors[24][0] = "DarkGray"
$arColors[24][1] = 0xA9A9A9	
$arColors[24][2] = 134
$arColors[24][3] = 73
$arColors[25][0] = "DarkGreen"
$arColors[25][1] = 0x006400	
$arColors[25][2] = 89
$arColors[25][3] = 14
$arColors[26][0] = "DarkKhaki"
$arColors[26][1] = 0xBDB76B	
$arColors[26][2] = 81
$arColors[26][3] = 74
$arColors[27][0] = "DarkMagenta"
$arColors[27][1] = 0x8B008B
$arColors[27][2] = 45
$arColors[27][3] = 10
$arColors[28][0] = "DarkOliveGreen"
$arColors[28][1] = 0x556B2F
$arColors[28][2] = 87
$arColors[28][3] = 20
$arColors[29][0] = "DarkOrange"
$arColors[29][1] = 0xFF8C00
$arColors[29][2] = 10
$arColors[29][3] = 50
$arColors[30][0] = "DarkOrchid"
$arColors[30][1] = 0x9932CC
$arColors[30][2] = 42
$arColors[30][3] = 25
$arColors[31][0] = "DarkRed"
$arColors[31][1] = 0x8B0000 	
$arColors[31][2] = 1
$arColors[31][3] = 8
$arColors[32][0] = "DarkSalmon"
$arColors[32][1] = 0xE9967A
$arColors[32][2] = 58
$arColors[32][3] = 64
$arColors[33][0] = "DarkSeaGreen"
$arColors[33][1] = 0x8FBC8F
$arColors[33][2] = 88
$arColors[33][3] = 77
$arColors[34][0] = "DarkSlateBlue"
$arColors[34][1] = 0x483D8B
$arColors[34][2] = 118
$arColors[34][3] = 13
$arColors[35][0] = "DarkSlateGray"
$arColors[35][1] = 0x2F4F4F
$arColors[35][2] = 99
$arColors[35][3] = 15
$arColors[36][0] = "DarkTurquoise"
$arColors[36][1] = 0x00CED1
$arColors[36][2] = 33
$arColors[36][3] = 70
$arColors[37][0] = "DarkViolet"
$arColors[37][1] = 0x9400D3
$arColors[37][2] = 43
$arColors[37][3] = 11
$arColors[38][0] = "DeepPink"
$arColors[38][1] = 0xFF1493	
$arColors[38][2] = 49
$arColors[38][3] = 39
$arColors[39][0] = "DeepSkyBlue"
$arColors[39][1] = 0x00BFFF
$arColors[39][2] = 34
$arColors[39][3] = 65
$arColors[40][0] = "DimGray"
$arColors[40][1] = 0x696969 	
$arColors[40][2] = 132
$arColors[40][3] = 27
$arColors[41][0] = "DodgerBlue"
$arColors[41][1] = 0x1E90FF
$arColors[41][2] = 35
$arColors[41][3] = 49
$arColors[42][0] = "FireBrick"
$arColors[42][1] = 0xB22222	
$arColors[42][2] = 2
$arColors[42][3] = 17
$arColors[43][0] = "FloralWhite"
$arColors[43][1] = 0xFFFAF0
$arColors[43][2] = 76
$arColors[43][3] = 130
$arColors[44][0] = "ForestGreen"
$arColors[44][1] = 0x228B22
$arColors[44][2] = 90
$arColors[44][3] = 37
$arColors[45][0] = "Fuchsia"
$arColors[45][1] = 0xFF00FF 	
$arColors[45][2] = 46
$arColors[45][3] = 29
$arColors[46][0] = "Gainsboro"
$arColors[46][1] = 0xDCDCDC	
$arColors[46][2] = 137
$arColors[46][3] = 107
$arColors[47][0] = "GhostWhite"
$arColors[47][1] = 0xF8F8FF
$arColors[47][2] = 115
$arColors[47][3] = 131
$arColors[48][0] = "Gold"
$arColors[48][1] = 0xFFD700
$arColors[48][2] = 14
$arColors[48][3] = 80
$arColors[49][0] = "Goldenrod"
$arColors[49][1] = 0xDAA520	
$arColors[49][2] = 13
$arColors[49][3] = 61
$arColors[50][0] = "Gray"
$arColors[50][1] = 0x808080
$arColors[50][2] = 133
$arColors[50][3] = 46
$arColors[51][0] = "Green"
$arColors[51][1] = 0x008000
$arColors[51][2] = 21
$arColors[51][3] = 21
$arColors[52][0] = "GreenYellow"
$arColors[52][1] = 0xADFF2F
$arColors[52][2] = 18
$arColors[52][3] = 101
$arColors[53][0] = "Honeydew"
$arColors[53][1] = 0xF0FFF0	
$arColors[53][2] = 93
$arColors[53][3] = 134
$arColors[54][0] = "HotPink"
$arColors[54][1] = 0xFF69B4 	
$arColors[54][2] = 50
$arColors[54][3] = 58
$arColors[55][0] = "IndianRed"
$arColors[55][1] = 0xCD5C5C	
$arColors[55][2] = 53
$arColors[55][3] = 33
$arColors[56][0] = "Indigo"
$arColors[56][1] = 0x4B0082 	
$arColors[56][2] = 121
$arColors[56][3] = 5
$arColors[57][0] = "Ivory"
$arColors[57][1] = 0xFFFFF0
$arColors[57][2] = 85
$arColors[57][3] = 136
$arColors[58][0] = "Khaki"
$arColors[58][1] = 0xF0E68C
$arColors[58][2] = 78
$arColors[58][3] = 104
$arColors[59][0] = "Lavender"
$arColors[59][1] = 0xE6E6FA	
$arColors[59][2] = 114
$arColors[59][3] = 116
$arColors[60][0] = "LavenderBlush"
$arColors[60][1] = 0xFFF0F5
$arColors[60][2] = 127
$arColors[60][3] = 122
$arColors[61][0] = "LawnGreen"
$arColors[61][1] = 0x7CFC00	
$arColors[61][2] = 20
$arColors[61][3] = 94
$arColors[62][0] = "LemonChiffon"
$arColors[62][1] = 0xFFFACD
$arColors[62][2] = 79
$arColors[62][3] = 124
$arColors[63][0] = "LightBlue"
$arColors[63][1] = 0xADD8E6	
$arColors[63][2] = 105
$arColors[63][3] = 99
$arColors[64][0] = "LightCoral"
$arColors[64][1] = 0xF08080
$arColors[64][2] = 55
$arColors[64][3] = 57
$arColors[65][0] = "LightCyan"
$arColors[65][1] = 0xE0FFFF	
$arColors[65][2] = 101
$arColors[65][3] = 135
$arColors[66][0] = "LightGoldenrodYellow"
$arColors[66][1] = 0xFAFAD2
$arColors[66][2] = 83
$arColors[66][3] = 125
$arColors[67][0] = "LightGreen"
$arColors[67][1] = 0x90EE90
$arColors[67][2] = 91
$arColors[67][3] = 100
$arColors[68][0] = "LightGray"
$arColors[68][1] = 0xD3D3D3	
$arColors[68][2] = 136
$arColors[68][3] = 98
$arColors[69][0] = "LightPink"
$arColors[69][1] = 0xFFB6C1	
$arColors[69][2] = 130
$arColors[69][3] = 82
$arColors[70][0] = "LightSalmon"
$arColors[70][1] = 0xFFA07A
$arColors[70][2] = 59
$arColors[70][3] = 71
$arColors[71][0] = "LightSeaGreen"
$arColors[71][1] = 0x20B2AA
$arColors[71][2] = 27
$arColors[71][3] = 63
$arColors[72][0] = "LightSkyBlue"
$arColors[72][1] = 0x87CEFA
$arColors[72][2] = 107
$arColors[72][3] = 97
$arColors[73][0] = "LightSlateGray"
$arColors[73][1] = 0x778899
$arColors[73][2] = 111
$arColors[73][3] = 54
$arColors[74][0] = "LightSteelBlue"
$arColors[74][1] = 0xB0C4DE
$arColors[74][2] = 112
$arColors[74][3] = 89
$arColors[75][0] = "LightYellow"
$arColors[75][1] = 0xFFFFE0
$arColors[75][2] = 84
$arColors[75][3] = 132
$arColors[76][0] = "Lime"
$arColors[76][1] = 0x00FF00
$arColors[76][2] = 22
$arColors[76][3] = 84
$arColors[77][0] = "LimeGreen"
$arColors[77][1] = 0x32CD32	
$arColors[77][2] = 23
$arColors[77][3] = 72
$arColors[78][0] = "Linen"
$arColors[78][1] = 0xFAF0E6
$arColors[78][2] = 65
$arColors[78][3] = 120
$arColors[79][0] = "Magenta"
$arColors[79][1] = 0xFF00FF
$arColors[79][2] = 47
$arColors[79][3] = 30
$arColors[80][0] = "Maroon"
$arColors[80][1] = 0x800000
$arColors[80][2] = 0
$arColors[80][3] = 7
$arColors[81][0] = "MediumAquamarine"
$arColors[81][1] = 0x66CDAA
$arColors[81][2] = 97
$arColors[81][3] = 81
$arColors[82][0] = "MediumBlue"
$arColors[82][1] = 0x0000CD
$arColors[82][2] = 39
$arColors[82][3] = 3
$arColors[83][0] = "MediumOrchid"
$arColors[83][1] = 0xBA55D3
$arColors[83][2] = 122
$arColors[83][3] = 38
$arColors[84][0] = "MediumPurple"
$arColors[84][1] = 0x9370DB
$arColors[84][2] = 120
$arColors[84][3] = 51
$arColors[85][0] = "MediumSeaGreen"
$arColors[85][1] = 0x3CB371
$arColors[85][2] = 95
$arColors[85][3] = 68
$arColors[86][0] = "MediumSlateBlue"
$arColors[86][1] = 0x7B68EE
$arColors[86][2] = 119
$arColors[86][3] = 43
$arColors[87][0] = "MediumSpringGreen"
$arColors[87][1] = 0x00FA9A
$arColors[87][2] = 25
$arColors[87][3] = 86
$arColors[88][0] = "MediumTurquoise"
$arColors[88][1] = 0x48D1CC
$arColors[88][2] = 28
$arColors[88][3] = 85
$arColors[89][0] = "MediumVioletRed"
$arColors[89][1] = 0xC71585
$arColors[89][2] = 48
$arColors[89][3] = 23
$arColors[90][0] = "MidnightBlue"
$arColors[90][1] = 0x191970
$arColors[90][2] = 116
$arColors[90][3] = 4
$arColors[91][0] = "MintCream"
$arColors[91][1] = 0xF5FFFA 	
$arColors[91][2] = 96
$arColors[91][3] = 137
$arColors[92][0] = "MistyRose"
$arColors[92][1] = 0xFFE4E1 	
$arColors[92][2] = 57
$arColors[92][3] = 113
$arColors[93][0] = "Moccasin"
$arColors[93][1] = 0xFFE4B5 
$arColors[93][2] = 73
$arColors[93][3] = 110
$arColors[94][0] = "NavajoWhite"
$arColors[94][1] = 0xFFDEAD 		
$arColors[94][2] = 70
$arColors[94][3] = 106
$arColors[95][0] = "Navy"
$arColors[95][1] = 0x000080
$arColors[95][2] = 37
$arColors[95][3] = 1
$arColors[96][0] = "OldLace"
$arColors[96][1] = 0xFDF5E6 	
$arColors[96][2] = 75
$arColors[96][3] = 123
$arColors[97][0] = "Olive"
$arColors[97][1] = 0x808000
$arColors[97][2] = 15
$arColors[97][3] = 32
$arColors[98][0] = "OliveDrab"
$arColors[98][1] = 0x6B8E23 		
$arColors[98][2] = 86
$arColors[98][3] = 42
$arColors[99][0] = "Orange"
$arColors[99][1] = 0xFFA500 	
$arColors[99][2] = 11
$arColors[99][3] = 60
$arColors[100][0] = "OrangeRed"
$arColors[100][1] = 0xFF4500 	
$arColors[100][2] = 7
$arColors[100][3] = 35
$arColors[101][0] = "Orchid"
$arColors[101][1] = 0xDA70D6
$arColors[101][2] = 126
$arColors[101][3] = 55
$arColors[102][0] = "PaleGoldenrod"
$arColors[102][1] = 0xEEE8AA 	 	
$arColors[102][2] = 80
$arColors[102][3] = 109
$arColors[103][0] = "PaleGreen"
$arColors[103][1] = 0x98FB98 	
$arColors[103][2] = 92
$arColors[103][3] = 112
$arColors[104][0] = "PaleTurquoise"
$arColors[104][1] = 0xAFEEEE 	
$arColors[104][2] = 100
$arColors[104][3] = 114
$arColors[105][0] = "PaleVioletRed"
$arColors[105][1] = 0xDB7093 	
$arColors[105][2] = 128
$arColors[105][3] = 45
$arColors[106][0] = "PapayaWhip"
$arColors[106][1] = 0xFFEFD5 	
$arColors[106][2] = 72
$arColors[106][3] = 119
$arColors[107][0] = "PeachPuff"
$arColors[107][1] = 0xFFDAB9 	
$arColors[107][2] = 63
$arColors[107][3] = 102
$arColors[108][0] = "Peru"
$arColors[108][1] = 0xCD853F
$arColors[108][2] = 64
$arColors[108][3] = 48
$arColors[109][0] = "Pink"
$arColors[109][1] = 0xFFC0CB 	 	
$arColors[109][2] = 129
$arColors[109][3] = 90
$arColors[110][0] = "Plum"
$arColors[110][1] = 0xDDA0DD 	
$arColors[110][2] = 123
$arColors[110][3] = 75
$arColors[111][0] = "PowderBlue"
$arColors[111][1] = 0xB0E0E6 	
$arColors[111][2] = 104
$arColors[111][3] = 108
$arColors[112][0] = "Purple"
$arColors[112][1] = 0x800080
$arColors[112][2] = 44
$arColors[112][3] = 9
$arColors[113][0] = "Red"
$arColors[113][1] = 0xFF0000
$arColors[113][2] = 3
$arColors[113][3] = 24
$arColors[114][0] = "RosyBrown"
$arColors[114][1] = 0xBC8F8F 	
$arColors[114][2] = 54
$arColors[114][3] = 59
$arColors[115][0] = "RoyalBlue"
$arColors[115][1] = 0x4169E1 	
$arColors[115][2] = 36
$arColors[115][3] = 36
$arColors[116][0] = "SaddleBrown"
$arColors[116][1] = 0x8B4513 	
$arColors[116][2] = 62
$arColors[116][3] = 12
$arColors[117][0] = "Salmon"
$arColors[117][1] = 0xFA8072 	
$arColors[117][2] = 4
$arColors[117][3] = 56
$arColors[118][0] = "SandyBrown"
$arColors[118][1] = 0xF4A460 	
$arColors[118][2] = 9
$arColors[118][3] = 69
$arColors[119][0] = "SeaGreen"
$arColors[119][1] = 0x2E8B57 	
$arColors[119][2] = 94
$arColors[119][3] = 41
$arColors[120][0] = "SeaShell"
$arColors[120][1] = 0xFFF5EE 	
$arColors[120][2] = 61
$arColors[120][3] = 127
$arColors[121][0] = "Sienna"
$arColors[121][1] = 0xA0522D 	
$arColors[121][2] = 60
$arColors[121][3] = 18
$arColors[122][0] = "Silver"
$arColors[122][1] = 0xC0C0C0	
$arColors[122][2] = 135
$arColors[122][3] = 83
$arColors[123][0] = "SkyBlue"
$arColors[123][1] = 0x87CEEB 	
$arColors[123][2] = 106
$arColors[123][3] = 95
$arColors[124][0] = "SlateBlue"
$arColors[124][1] = 0x6A5ACD 	
$arColors[124][2] = 117
$arColors[124][3] = 31
$arColors[125][0] = "SlateGray"
$arColors[125][1] = 0x708090 	
$arColors[125][2] = 110
$arColors[125][3] = 47
$arColors[126][0] = "Snow"
$arColors[126][1] = 0xFFFAFA 	
$arColors[126][2] = 56
$arColors[126][3] = 133
$arColors[127][0] = "SpringGreen"
$arColors[127][1] = 0x00FF7F 	
$arColors[127][2] = 24
$arColors[127][3] = 88
$arColors[128][0] = "SteelBlue"
$arColors[128][1] = 0x4682B4 	
$arColors[128][2] = 108
$arColors[128][3] = 52
$arColors[129][0] = "Tan"
$arColors[129][1] = 0xD2B48C 	
$arColors[129][2] = 68
$arColors[129][3] = 76
$arColors[130][0] = "Teal"
$arColors[130][1] = 0x008080
$arColors[130][2] = 29
$arColors[130][3] = 26
$arColors[131][0] = "Thistle"
$arColors[131][1] = 0xD8BFD8 	
$arColors[131][2] = 125
$arColors[131][3] = 87
$arColors[132][0] = "Tomato"
$arColors[132][1] = 0xFF6347 	
$arColors[132][2] = 5
$arColors[132][3] = 44
$arColors[133][0] = "Turquoise"
$arColors[133][1] = 0x40E0D0 	
$arColors[133][2] = 26
$arColors[133][3] = 91
$arColors[134][0] = "Violet"
$arColors[134][1] = 0xEE82EE 	
$arColors[134][2] = 124
$arColors[134][3] = 66
$arColors[135][0] = "Wheat"
$arColors[135][1] = 0xF5DEB3 	
$arColors[135][2] = 74
$arColors[135][3] = 105
$arColors[136][0] = "White"
$arColors[136][1] = 0xFFFFFF
$arColors[136][2] = 139
$arColors[136][3] = 139
$arColors[137][0] = "WhiteSmoke"
$arColors[137][1] = 0xF5F5F5 	
$arColors[137][2] = 138
$arColors[137][3] = 128
$arColors[138][0] = "Yellow"
$arColors[138][1] = 0xFFFF00
$arColors[138][2] = 16
$arColors[138][3] = 103
$arColors[139][0] = "YellowGreen"
$arColors[139][1] = 0x9ACD32
$arColors[139][2] = 17
$arColors[139][3] = 78

$arColors[7][4] = 1 
$arColors[9][4] = 1 
$arColors[11][4] = 1 
$arColors[13][4] = 1 
$arColors[15][4] = 1 
$arColors[19][4] = 1 
$arColors[21][4] = 1 
$arColors[22][4] = 1 
$arColors[23][4] = 1 
$arColors[25][4] = 1 
$arColors[27][4] = 1 
$arColors[28][4] = 1 
$arColors[31][4] = 1 
$arColors[34][4] = 1 
$arColors[35][4] = 1 
$arColors[40][4] = 1 
$arColors[42][4] = 1 
$arColors[44][4] = 1 
$arColors[50][4] = 1 
$arColors[51][4] = 1 
$arColors[55][4] = 1 
$arColors[56][4] = 1 
$arColors[71][4] = 1 
$arColors[73][4] = 1 
$arColors[77][4] = 1 
$arColors[80][4] = 1 
$arColors[82][4] = 1 
$arColors[85][4] = 1 
$arColors[89][4] = 1 
$arColors[90][4] = 1 
$arColors[95][4] = 1 
$arColors[97][4] = 1 
$arColors[98][4] = 1 
$arColors[108][4] = 1 
$arColors[112][4] = 1 
$arColors[116][4] = 1 
$arColors[119][4] = 1 
$arColors[121][4] = 1 
$arColors[124][4] = 1 
$arColors[125][4] = 1 
$arColors[128][4] = 1 
$arColors[130][4] = 1 

$Form1 = GUICreate("HEX-Code Color Table", 415, 683, -1, -1)
GUISetOnEvent($GUI_EVENT_CLOSE, "AForm1Close")
GUISetOnEvent($GUI_EVENT_SECONDARYDOWN, "SpecialEvents")
GUICtrlCreateGroup("Order by", 0, 0, 415, 38)
$rName = GUICtrlCreateRadio("Name", 30, 15, 80)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetOnEvent(-1, "rNameClick")
$rSatt = GUICtrlCreateRadio("Saturation", 170, 15, 80)
GUICtrlSetOnEvent(-1, "rSattClick")
$rHell = GUICtrlCreateRadio("Brightness", 300, 15, 80)
GUICtrlSetOnEvent(-1, "rHellClick")
GUICtrlCreateGroup ("",-99,-99,1,1)  
$ListView1 = GUICtrlCreateListView("Color|Name|HEX-Code", 0, 40, 420, 642)
_GUICtrlListViewSetColumnWidth(-1, 0, 135)
_GUICtrlListViewSetColumnWidth(-1, 1, 135)
_GUICtrlListViewSetColumnWidth(-1, 2, 128)


$GUICopy = GUICreate("GUICopy", 161, 115, -1, -1, BitOR($WS_MINIMIZEBOX,$WS_SIZEBOX, _
$WS_THICKFRAME,$WS_GROUP,$WS_CLIPSIBLINGS,$WS_POPUP))
GUISetBkColor(0xFFFFF0, $GUICopy)
$lbShowColor = GUICtrlCreateLabel("", 10, 10, 140, 30, BitOR($SS_CENTER,$WS_BORDER))
$bCopyTo = GUICtrlCreateButton("Copy To Clipboard", 10, 53, 140, 22, $BS_DEFPUSHBUTTON)
GUICtrlSetOnEvent(-1, "bCopyToClick")
$bEscCopyTo = GUICtrlCreateButton("Escape", 10, 82, 140, 22, 0)
GUICtrlSetOnEvent(-1, "bEscCopyToClick")

GUISetState(@SW_SHOW, $Form1)
_SetData(0)

While 1
	Sleep(100)
WEnd
		
Func AForm1Close()
	Exit
EndFunc

Func rNameClick()
	_GUICtrlListViewDeleteAllItems($ListView1)
	_SetData(0)
EndFunc

Func rSattClick()
	_GUICtrlListViewDeleteAllItems($ListView1)
	_SetData(2)
EndFunc

Func rHellClick()
	_GUICtrlListViewDeleteAllItems($ListView1)
	_SetData(3)
EndFunc

Func _SetData($SortIndx)
	_ArraySort($arColors, 0, 0, 0, 5, $SortIndx)
	For $i = 0 To UBound($arColors)-1
		$arItem[$i] = GUICtrlCreateListViewItem( "|" &$arColors[$i][0] & "|0x" & Hex($arColors[$i][1],6), $ListView1)
		If $arColors[$i][4] = 1 Then GUICtrlSetColor(-1, 0xFFFFFF)
		GUICtrlSetBkColor(-1,$arColors[$i][1])
	Next
EndFunc

Func SpecialEvents()    
    If @GUI_CTRLID = $GUI_EVENT_SECONDARYDOWN Then
		If ControlGetFocus($Form1, "HEX-Code Color Table") = "SysListView321" Then
			$ind = _GUICtrlListViewGetCurSel($ListView1)
			$col = _GUICtrlListViewGetItemText($ListView1, $ind, 1)
			$hex = _GUICtrlListViewGetItemText($ListView1, $ind, 2)	
			If $arColors[$ind][4] = 1 Then
				GUISetBkColor($PaleGreen, $GUICopy)
				GUICtrlSetColor($lbShowColor, 0xFFFFFF)
			Else
				GUISetBkColor($Navy, $GUICopy)
				GUICtrlSetColor($lbShowColor, 0x000000)
			EndIf
			GUICtrlSetBkColor($lbShowColor, $arColors[$ind][1])
			GUICtrlSetData($lbShowColor, $arColors[$ind][0])
			GUISetState(@SW_SHOW, $GUICopy)
		EndIf
	EndIf
EndFunc

Func bCopyToClick()
	$strCopy = '$' & $col & " = " & $hex
	ClipPut($strCopy)
	GUISetState(@SW_HIDE, $GUICopy)
	ToolTip(@TAB & $strCopy & @CRLF & @CRLF & "are copied to Clipboard.", @DesktopWidth/2, @DesktopHeight/2, "Clipboard", 1, 1)
	Sleep(5000)
	ToolTip("")
EndFunc
		
Func bEscCopyToClick()
	GUISetState(@SW_HIDE, $GUICopy)
EndFunc
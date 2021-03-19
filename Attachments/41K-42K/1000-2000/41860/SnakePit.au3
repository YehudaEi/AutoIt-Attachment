#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Add_Constants=n
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Misc.au3>
#include <WinAPI.au3>
#include <Array.au3>
#include <Sound.au3>
#include <GDIPlus.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIComboBox.au3>
#include <StaticConstants.au3>
Opt("GUIOnEventMode", 1)
Opt("MustDeclareVars", 1)
Opt("WinTitleMatchMode", 4)

Local $setuptimer = TimerInit()

#region assets
Global $assetsDir = @TempDir & "\snake pit"
Local $assets[133][2]
DirCreate($assetsDir)
If Not FileExists($assetsDir) Then
	MsgBox(0,"Error","No permission to create temporary files.")
	Exit
EndIf

$assets[0][0] = "\Blank.gif"
$assets[0][1] = 'R0lGODlhCAAIAIIAMQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDCAi63P4wypgAADs='
$assets[1][0] = "\Egg.gif"
$assets[1][1] = 'R0lGODlhCAAIAIIAMQD/AAAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDhi6DA7rPSUdrVfGyXoCADs='
$assets[2][0] = "\Player0.gif"
$assets[2][1] = 'R0lGODlhCAAIAIIAMf//AAAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDEBiwrKHgLRkhu/HaR3HzQQIAOw=='
$assets[3][0] = "\Player1.gif"
$assets[3][1] = 'R0lGODlhCAAIAIIAMf//AAAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDEBiwrKHgsTmfXNY2XWGkUQIAOw=='
$assets[4][0] = "\Snake-Corner-LD-Blue.gif"
$assets[4][1] = 'R0lGODlhCAAIAIIAMQAAAAAA/wAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDgi63BDBQcgmVTauXKdKADs='
$assets[5][0] = "\Snake-Corner-LD-Cyan.gif"
$assets[5][1] = 'R0lGODlhCAAIAIIAMQAAAAD//wAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDgi63BDBQcgmVTauXKdKADs='
$assets[6][0] = "\Snake-Corner-LD-Green.gif"
$assets[6][1] = 'R0lGODlhCAAIAIIAMQAAAAD/AAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDgi63BDBQcgmVTauXKdKADs='
$assets[7][0] = "\Snake-Corner-LD-Magenta.gif"
$assets[7][1] = 'R0lGODlhCAAIAIIAMQAAAP8A/wAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDgi63BDBQcgmVTauXKdKADs='
$assets[8][0] = "\Snake-Corner-LD-Red.gif"
$assets[8][1] = 'R0lGODlhCAAIAIIAMQAAAP8AAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDgi63BDBQcgmVTauXKdKADs='
$assets[9][0] = "\Snake-Corner-LD-White.gif"
$assets[9][1] = 'R0lGODlhCAAIAIIAMQAAAP///wMDAwQEBAUFBQYGBgICAgEBASwAAAAACAAIAAIDDgi63BDBQcgmVTauXKdKADs='
$assets[10][0] = "\Snake-Corner-LD-Yellow.gif"
$assets[10][1] = 'R0lGODlhCAAIAIIAMQAAAP//AAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDgi63BDBQcgmVTauXKdKADs='
$assets[11][0] = "\Snake-Corner-LU-Blue.gif"
$assets[11][1] = 'R0lGODlhCAAIAIIAMQAAAAAA/wAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDggQHLrNwfainBe+zftOADs='
$assets[12][0] = "\Snake-Corner-LU-Cyan.gif"
$assets[12][1] = 'R0lGODlhCAAIAIIAMQAAAAD//wAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDggQHLrNwfainBe+zftOADs='
$assets[13][0] = "\Snake-Corner-LU-Green.gif"
$assets[13][1] = 'R0lGODlhCAAIAIIAMQAAAAD/AAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDggQHLrNwfainBe+zftOADs='
$assets[14][0] = "\Snake-Corner-LU-Magenta.gif"
$assets[14][1] = 'R0lGODlhCAAIAIIAMQAAAP8A/wAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDggQHLrNwfainBe+zftOADs='
$assets[15][0] = "\Snake-Corner-LU-Red.gif"
$assets[15][1] = 'R0lGODlhCAAIAIIAMQAAAP8AAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDggQHLrNwfainBe+zftOADs='
$assets[16][0] = "\Snake-Corner-LU-White.gif"
$assets[16][1] = 'R0lGODlhCAAIAIIAMQAAAP///wMDAwQEBAUFBQYGBgICAgEBASwAAAAACAAIAAIDDggQHLrNwfainBe+zftOADs='
$assets[17][0] = "\Snake-Corner-LU-Yellow.gif"
$assets[17][1] = 'R0lGODlhCAAIAIIAMQAAAP//AAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDggQHLrNwfainBe+zftOADs='
$assets[18][0] = "\Snake-Corner-RD-Blue.gif"
$assets[18][1] = 'R0lGODlhCAAIAIIAMQAAAAAA/wAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDwi63A4hsBgXrepKeC1VCQA7'
$assets[19][0] = "\Snake-Corner-RD-Cyan.gif"
$assets[19][1] = 'R0lGODlhCAAIAIIAMQAAAAD//wAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDwi63A4hsBgXrepKeC1VCQA7'
$assets[20][0] = "\Snake-Corner-RD-Green.gif"
$assets[20][1] = 'R0lGODlhCAAIAIIAMQAAAAD/AAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDwi63A4hsBgXrepKeC1VCQA7'
$assets[21][0] = "\Snake-Corner-RD-Magenta.gif"
$assets[21][1] = 'R0lGODlhCAAIAIIAMQAAAP8A/wAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDwi63A4hsBgXrepKeC1VCQA7'
$assets[22][0] = "\Snake-Corner-RD-Red.gif"
$assets[22][1] = 'R0lGODlhCAAIAIIAMQAAAP8AAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDwi63A4hsBgXrepKeC1VCQA7'
$assets[23][0] = "\Snake-Corner-RD-White.gif"
$assets[23][1] = 'R0lGODlhCAAIAIIAMQAAAP///wMDAwQEBAUFBQYGBgICAgEBASwAAAAACAAIAAIDDwi63A4hsBgXrepKeC1VCQA7'
$assets[24][0] = "\Snake-Corner-RD-Yellow.gif"
$assets[24][1] = 'R0lGODlhCAAIAIIAMQAAAP//AAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDwi63A4hsBgXrepKeC1VCQA7'
$assets[25][0] = "\Snake-Corner-RU-Blue.gif"
$assets[25][1] = 'R0lGODlhCAAIAIIAMQAAAAAA/wAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDwgQHKqNvRVfdLZNiLd/CQA7'
$assets[26][0] = "\Snake-Corner-RU-Cyan.gif"
$assets[26][1] = 'R0lGODlhCAAIAIIAMQAAAAD//wAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDwgQHKqNvRVfdLZNiLd/CQA7'
$assets[27][0] = "\Snake-Corner-RU-Green.gif"
$assets[27][1] = 'R0lGODlhCAAIAIIAMQAAAAD/AAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDwgQHKqNvRVfdLZNiLd/CQA7'
$assets[28][0] = "\Snake-Corner-RU-Magenta.gif"
$assets[28][1] = 'R0lGODlhCAAIAIIAMQAAAP8A/wAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDwgQHKqNvRVfdLZNiLd/CQA7'
$assets[29][0] = "\Snake-Corner-RU-Red.gif"
$assets[29][1] = 'R0lGODlhCAAIAIIAMQAAAP8AAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDwgQHKqNvRVfdLZNiLd/CQA7'
$assets[30][0] = "\Snake-Corner-RU-White.gif"
$assets[30][1] = 'R0lGODlhCAAIAIIAMQAAAP///wMDAwQEBAUFBQYGBgICAgEBASwAAAAACAAIAAIDDwgQHKqNvRVfdLZNiLd/CQA7'
$assets[31][0] = "\Snake-Corner-RU-Yellow.gif"
$assets[31][1] = 'R0lGODlhCAAIAIIAMQAAAP//AAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDwgQHKqNvRVfdLZNiLd/CQA7'
$assets[32][0] = "\Snake-Head-D-Blue.gif"
$assets[32][1] = 'R0lGODlhCAAIAIIAMQAAAAAA/wAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDEQixDKrhvSUjtJhK6Cx3IJgAADs='
$assets[33][0] = "\Snake-Head-D-Cyan.gif"
$assets[33][1] = 'R0lGODlhCAAIAIIAMQAAAAD//wAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDEQixDKrhvSUjtJhK6Cx3IJgAADs='
$assets[34][0] = "\Snake-Head-D-Green.gif"
$assets[34][1] = 'R0lGODlhCAAIAIIAMQAAAAD/AAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDEQixDKrhvSUjtJhK6Cx3IJgAADs='
$assets[35][0] = "\Snake-Head-D-Magenta.gif"
$assets[35][1] = 'R0lGODlhCAAIAIIAMQAAAP8A/wAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDEQixDKrhvSUjtJhK6Cx3IJgAADs='
$assets[36][0] = "\Snake-Head-D-Red.gif"
$assets[36][1] = 'R0lGODlhCAAIAIIAMQAAAP8AAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDEQixDKrhvSUjtJhK6Cx3IJgAADs='
$assets[37][0] = "\Snake-Head-D-White.gif"
$assets[37][1] = 'R0lGODlhCAAIAIIAMQAAAP///wMDAwQEBAUFBQYGBgICAgEBASwAAAAACAAIAAIDEQixDKrhvSUjtJhK6Cx3IJgAADs='
$assets[38][0] = "\Snake-Head-D-Yellow.gif"
$assets[38][1] = 'R0lGODlhCAAIAIIAMQAAAP//AAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDEQixDKrhvSUjtJhK6Cx3IJgAADs='
$assets[39][0] = "\Snake-Head-L-Blue.gif"
$assets[39][1] = 'R0lGODlhCAAIAIIAMQAAAAAA/wAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDwi6G/4BQBXpZI81CZ1eCQA7'
$assets[40][0] = "\Snake-Head-L-Cyan.gif"
$assets[40][1] = 'R0lGODlhCAAIAIIAMQAAAAD//wAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDwi6G/4BQBXpZI81CZ1eCQA7'
$assets[41][0] = "\Snake-Head-L-Green.gif"
$assets[41][1] = 'R0lGODlhCAAIAIIAMQAAAAD/AAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDwi6G/4BQBXpZI81CZ1eCQA7'
$assets[42][0] = "\Snake-Head-L-Magenta.gif"
$assets[42][1] = 'R0lGODlhCAAIAIIAMQAAAP8A/wAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDwi6G/4BQBXpZI81CZ1eCQA7'
$assets[43][0] = "\Snake-Head-L-Red.gif"
$assets[43][1] = 'R0lGODlhCAAIAIIAMQAAAP8AAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDwi6G/4BQBXpZI81CZ1eCQA7'
$assets[44][0] = "\Snake-Head-L-White.gif"
$assets[44][1] = 'R0lGODlhCAAIAIIAMQAAAP///wMDAwQEBAUFBQYGBgICAgEBASwAAAAACAAIAAIDDwi6G/4BQBXpZI81CZ1eCQA7'
$assets[45][0] = "\Snake-Head-L-Yellow.gif"
$assets[45][1] = 'R0lGODlhCAAIAIIAMQAAAP//AAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDwi6G/4BQBXpZI81CZ1eCQA7'
$assets[46][0] = "\Snake-Head-R-Blue.gif"
$assets[46][1] = 'R0lGODlhCAAIAIIAMQAAAAAA/wAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDEAi6Gv4BRPlobY5JjeHkQAIAOw=='
$assets[47][0] = "\Snake-Head-R-Cyan.gif"
$assets[47][1] = 'R0lGODlhCAAIAIIAMQAAAAD//wAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDEAi6Gv4BRPlobY5JjeHkQAIAOw=='
$assets[48][0] = "\Snake-Head-R-Green.gif"
$assets[48][1] = 'R0lGODlhCAAIAIIAMQAAAAD/AAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDEAi6Gv4BRPlobY5JjeHkQAIAOw=='
$assets[49][0] = "\Snake-Head-R-Magenta.gif"
$assets[49][1] = 'R0lGODlhCAAIAIIAMQAAAP8A/wAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDEAi6Gv4BRPlobY5JjeHkQAIAOw=='
$assets[50][0] = "\Snake-Head-R-Red.gif"
$assets[50][1] = 'R0lGODlhCAAIAIIAMQAAAP8AAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDEAi6Gv4BRPlobY5JjeHkQAIAOw=='
$assets[51][0] = "\Snake-Head-R-White.gif"
$assets[51][1] = 'R0lGODlhCAAIAIIAMQAAAP///wMDAwQEBAUFBQYGBgICAgEBASwAAAAACAAIAAIDEAi6Gv4BRPlobY5JjeHkQAIAOw=='
$assets[52][0] = "\Snake-Head-R-Yellow.gif"
$assets[52][1] = 'R0lGODlhCAAIAIIAMQAAAP//AAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDEAi6Gv4BRPlobY5JjeHkQAIAOw=='
$assets[53][0] = "\Snake-Head-U-Blue.gif"
$assets[53][1] = 'R0lGODlhCAAIAIIAMQAAAAAA/wAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDEQi6G+0ARkgDVfbaiCefmZMAADs='
$assets[54][0] = "\Snake-Head-U-Cyan.gif"
$assets[54][1] = 'R0lGODlhCAAIAIIAMQAAAAD//wAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDEQi6G+0ARkgDVfbaiCefmZMAADs='
$assets[55][0] = "\Snake-Head-U-Green.gif"
$assets[55][1] = 'R0lGODlhCAAIAIIAMQAAAAD/AAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDEQi6G+0ARkgDVfbaiCefmZMAADs='
$assets[56][0] = "\Snake-Head-U-Magenta.gif"
$assets[56][1] = 'R0lGODlhCAAIAIIAMQAAAP8A/wAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDEQi6G+0ARkgDVfbaiCefmZMAADs='
$assets[57][0] = "\Snake-Head-U-Red.gif"
$assets[57][1] = 'R0lGODlhCAAIAIIAMQAAAP8AAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDEQi6G+0ARkgDVfbaiCefmZMAADs='
$assets[58][0] = "\Snake-Head-U-White.gif"
$assets[58][1] = 'R0lGODlhCAAIAIIAMQAAAP///wMDAwQEBAUFBQYGBgICAgEBASwAAAAACAAIAAIDEQi6G+0ARkgDVfbaiCefmZMAADs='
$assets[59][0] = "\Snake-Head-U-Yellow.gif"
$assets[59][1] = 'R0lGODlhCAAIAIIAMQAAAP//AAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDEQi6G+0ARkgDVfbaiCefmZMAADs='
$assets[60][0] = "\Snake-LR-Blue.gif"
$assets[60][1] = 'R0lGODlhCAAIAIIAMQAA/wAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDCxi63AEwykmrdHglADs='
$assets[61][0] = "\Snake-LR-Cyan.gif"
$assets[61][1] = 'R0lGODlhCAAIAIIAMQD//wAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDCxi63AEwykmrdHglADs='
$assets[62][0] = "\Snake-LR-Green.gif"
$assets[62][1] = 'R0lGODlhCAAIAIIAMQD/AAAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDCxi63AEwykmrdHglADs='
$assets[63][0] = "\Snake-LR-Magenta.gif"
$assets[63][1] = 'R0lGODlhCAAIAIIAMf8A/wAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDCxi63AEwykmrdHglADs='
$assets[64][0] = "\Snake-LR-Red.gif"
$assets[64][1] = 'R0lGODlhCAAIAIIAMf8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDCxi63AEwykmrdHglADs='
$assets[65][0] = "\Snake-LR-White.gif"
$assets[65][1] = 'R0lGODlhCAAIAIIAMf///wAAAAMDAwQEBAUFBQYGBgICAgEBASwAAAAACAAIAAIDCxi63AEwykmrdHglADs='
$assets[66][0] = "\Snake-LR-Yellow.gif"
$assets[66][1] = 'R0lGODlhCAAIAIIAMf//AAAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDCxi63AEwykmrdHglADs='
$assets[67][0] = "\Snake-Tail-D-Blue.gif"
$assets[67][1] = 'R0lGODlhCAAIAIIAMQAAAAAA/wAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDwgQHKrNvfigrKxavS5XCQA7'
$assets[68][0] = "\Snake-Tail-D-Cyan.gif"
$assets[68][1] = 'R0lGODlhCAAIAIIAMQAAAAD//wAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDwgQHKrNvfigrKxavS5XCQA7'
$assets[69][0] = "\Snake-Tail-D-Green.gif"
$assets[69][1] = 'R0lGODlhCAAIAIIAMQAAAAD/AAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDwgQHKrNvfigrKxavS5XCQA7'
$assets[70][0] = "\Snake-Tail-D-Magenta.gif"
$assets[70][1] = 'R0lGODlhCAAIAIIAMQAAAP8A/wAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDwgQHKrNvfigrKxavS5XCQA7'
$assets[71][0] = "\Snake-Tail-D-Red.gif"
$assets[71][1] = 'R0lGODlhCAAIAIIAMQAAAP8AAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDwgQHKrNvfigrKxavS5XCQA7'
$assets[72][0] = "\Snake-Tail-D-White.gif"
$assets[72][1] = 'R0lGODlhCAAIAIIAMQAAAP///wMDAwQEBAUFBQYGBgICAgEBASwAAAAACAAIAAIDDwgQHKrNvfigrKxavS5XCQA7'
$assets[73][0] = "\Snake-Tail-D-Yellow.gif"
$assets[73][1] = 'R0lGODlhCAAIAIIAMQAAAP//AAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDwgQHKrNvfigrKxavS5XCQA7'
$assets[74][0] = "\Snake-Tail-L-Blue.gif"
$assets[74][1] = 'R0lGODlhCAAIAIIAMQAAAAAA/wAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDQi63B4QwBnpbNdplQAAOw=='
$assets[75][0] = "\Snake-Tail-L-Cyan.gif"
$assets[75][1] = 'R0lGODlhCAAIAIIAMQAAAAD//wAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDQi63B4QwBnpbNdplQAAOw=='
$assets[76][0] = "\Snake-Tail-L-Green.gif"
$assets[76][1] = 'R0lGODlhCAAIAIIAMQAAAAD/AAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDQi63B4QwBnpbNdplQAAOw=='
$assets[77][0] = "\Snake-Tail-L-Magenta.gif"
$assets[77][1] = 'R0lGODlhCAAIAIIAMQAAAP8A/wAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDQi63B4QwBnpbNdplQAAOw=='
$assets[78][0] = "\Snake-Tail-L-Red.gif"
$assets[78][1] = 'R0lGODlhCAAIAIIAMQAAAP8AAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDQi63B4QwBnpbNdplQAAOw=='
$assets[79][0] = "\Snake-Tail-L-White.gif"
$assets[79][1] = 'R0lGODlhCAAIAIIAMQAAAP///wMDAwQEBAUFBQYGBgICAgEBASwAAAAACAAIAAIDDQi63B4QwBnpbNdplQAAOw=='
$assets[80][0] = "\Snake-Tail-L-Yellow.gif"
$assets[80][1] = 'R0lGODlhCAAIAIIAMQAAAP//AAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDQi63B4QwBnpbNdplQAAOw=='
$assets[81][0] = "\Snake-Tail-R-Blue.gif"
$assets[81][1] = 'R0lGODlhCAAIAIIAMQAAAAAA/wAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDQi63BCwwRnpfNFpnQAAOw=='
$assets[82][0] = "\Snake-Tail-R-Cyan.gif"
$assets[82][1] = 'R0lGODlhCAAIAIIAMQAAAAD//wAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDQi63BCwwRnpfNFpnQAAOw=='
$assets[83][0] = "\Snake-Tail-R-Green.gif"
$assets[83][1] = 'R0lGODlhCAAIAIIAMQAAAAD/AAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDQi63BCwwRnpfNFpnQAAOw=='
$assets[84][0] = "\Snake-Tail-R-Magenta.gif"
$assets[84][1] = 'R0lGODlhCAAIAIIAMQAAAP8A/wAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDQi63BCwwRnpfNFpnQAAOw=='
$assets[85][0] = "\Snake-Tail-R-Red.gif"
$assets[85][1] = 'R0lGODlhCAAIAIIAMQAAAP8AAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDQi63BCwwRnpfNFpnQAAOw=='
$assets[86][0] = "\Snake-Tail-R-White.gif"
$assets[86][1] = 'R0lGODlhCAAIAIIAMQAAAP///wMDAwQEBAUFBQYGBgICAgEBASwAAAAACAAIAAIDDQi63BCwwRnpfNFpnQAAOw=='
$assets[87][0] = "\Snake-Tail-R-Yellow.gif"
$assets[87][1] = 'R0lGODlhCAAIAIIAMQAAAP//AAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDQi63BCwwRnpfNFpnQAAOw=='
$assets[88][0] = "\Snake-Tail-U-Blue.gif"
$assets[88][1] = 'R0lGODlhCAAIAIIAMQAAAAAA/wAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDwi6DBHNwfZiZe+qPHdWCQA7'
$assets[89][0] = "\Snake-Tail-U-Cyan.gif"
$assets[89][1] = 'R0lGODlhCAAIAIIAMQAAAAD//wAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDwi6DBHNwfZiZe+qPHdWCQA7'
$assets[90][0] = "\Snake-Tail-U-Green.gif"
$assets[90][1] = 'R0lGODlhCAAIAIIAMQAAAAD/AAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDwi6DBHNwfZiZe+qPHdWCQA7'
$assets[91][0] = "\Snake-Tail-U-Magenta.gif"
$assets[91][1] = 'R0lGODlhCAAIAIIAMQAAAP8A/wAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDwi6DBHNwfZiZe+qPHdWCQA7'
$assets[92][0] = "\Snake-Tail-U-Red.gif"
$assets[92][1] = 'R0lGODlhCAAIAIIAMQAAAP8AAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDwi6DBHNwfZiZe+qPHdWCQA7'
$assets[93][0] = "\Snake-Tail-U-White.gif"
$assets[93][1] = 'R0lGODlhCAAIAIIAMQAAAP///wMDAwQEBAUFBQYGBgICAgEBASwAAAAACAAIAAIDDwi6DBHNwfZiZe+qPHdWCQA7'
$assets[94][0] = "\Snake-Tail-U-Yellow.gif"
$assets[94][1] = 'R0lGODlhCAAIAIIAMQAAAP//AAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDwi6DBHNwfZiZe+qPHdWCQA7'
$assets[95][0] = "\Snake-UD-Blue.gif"
$assets[95][1] = 'R0lGODlhCAAIAIIAMQAA/wAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDhgBDKrNvfhWq3RezfBOADs='
$assets[96][0] = "\Snake-UD-Cyan.gif"
$assets[96][1] = 'R0lGODlhCAAIAIIAMQD//wAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDhgBDKrNvfhWq3RezfBOADs='
$assets[97][0] = "\Snake-UD-Green.gif"
$assets[97][1] = 'R0lGODlhCAAIAIIAMQD/AAAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDhgBDKrNvfhWq3RezfBOADs='
$assets[98][0] = "\Snake-UD-Magenta.gif"
$assets[98][1] = 'R0lGODlhCAAIAIIAMf8A/wAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDhgBDKrNvfhWq3RezfBOADs='
$assets[99][0] = "\Snake-UD-Red.gif"
$assets[99][1] = 'R0lGODlhCAAIAIIAMf8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDhgBDKrNvfhWq3RezfBOADs='
$assets[100][0] = "\Snake-UD-White.gif"
$assets[100][1] = 'R0lGODlhCAAIAIIAMf///wAAAAMDAwQEBAUFBQYGBgICAgEBASwAAAAACAAIAAIDDhgBDKrNvfhWq3RezfBOADs='
$assets[101][0] = "\Snake-UD-Yellow.gif"
$assets[101][1] = 'R0lGODlhCAAIAIIAMf//AAAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDhgBDKrNvfhWq3RezfBOADs='
$assets[102][0] = "\Snake-UTurn-D-Blue.gif"
$assets[102][1] = 'R0lGODlhCAAIAIIAMQAA/wAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDxgBDLqNwUgVdVe2iV9UCQA7'
$assets[103][0] = "\Snake-UTurn-D-Cyan.gif"
$assets[103][1] = 'R0lGODlhCAAIAIIAMQD//wAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDxgBDLqNwUgVdVe2iV9UCQA7'
$assets[104][0] = "\Snake-UTurn-D-Green.gif"
$assets[104][1] = 'R0lGODlhCAAIAIIAMQD/AAAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDxgBDLqNwUgVdVe2iV9UCQA7'
$assets[105][0] = "\Snake-UTurn-D-Magenta.gif"
$assets[105][1] = 'R0lGODlhCAAIAIIAMf8A/wAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDxgBDLqNwUgVdVe2iV9UCQA7'
$assets[106][0] = "\Snake-UTurn-D-Red.gif"
$assets[106][1] = 'R0lGODlhCAAIAIIAMf8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDxgBDLqNwUgVdVe2iV9UCQA7'
$assets[107][0] = "\Snake-UTurn-D-White.gif"
$assets[107][1] = 'R0lGODlhCAAIAIIAMf///wAAAAMDAwQEBAUFBQYGBgICAgEBASwAAAAACAAIAAIDDxgBDLqNwUgVdVe2iV9UCQA7'
$assets[108][0] = "\Snake-UTurn-D-Yellow.gif"
$assets[108][1] = 'R0lGODlhCAAIAIIAMf//AAAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDxgBDLqNwUgVdVe2iV9UCQA7'
$assets[109][0] = "\Snake-UTurn-L-Blue.gif"
$assets[109][1] = 'R0lGODlhCAAIAIIAMQAA/wAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDxgBDLqNwUhVdXE2Le0OCQA7'
$assets[110][0] = "\Snake-UTurn-L-Cyan.gif"
$assets[110][1] = 'R0lGODlhCAAIAIIAMQD//wAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDxgBDLqNwUhVdXE2Le0OCQA7'
$assets[111][0] = "\Snake-UTurn-L-Green.gif"
$assets[111][1] = 'R0lGODlhCAAIAIIAMQD/AAAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDxgBDLqNwUhVdXE2Le0OCQA7'
$assets[112][0] = "\Snake-UTurn-L-Magenta.gif"
$assets[112][1] = 'R0lGODlhCAAIAIIAMf8A/wAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDxgBDLqNwUhVdXE2Le0OCQA7'
$assets[113][0] = "\Snake-UTurn-L-Red.gif"
$assets[113][1] = 'R0lGODlhCAAIAIIAMf8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDxgBDLqNwUhVdXE2Le0OCQA7'
$assets[114][0] = "\Snake-UTurn-L-White.gif"
$assets[114][1] = 'R0lGODlhCAAIAIIAMf///wAAAAMDAwQEBAUFBQYGBgICAgEBASwAAAAACAAIAAIDDxgBDLqNwUhVdXE2Le0OCQA7'
$assets[115][0] = "\Snake-UTurn-L-Yellow.gif"
$assets[115][1] = 'R0lGODlhCAAIAIIAMf//AAAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDxgBDLqNwUhVdXE2Le0OCQA7'
$assets[116][0] = "\Snake-UTurn-R-Blue.gif"
$assets[116][1] = 'R0lGODlhCAAIAIIAMQAA/wAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDhgBDLqNwTidpTW27BROADs='
$assets[117][0] = "\Snake-UTurn-R-Cyan.gif"
$assets[117][1] = 'R0lGODlhCAAIAIIAMQD//wAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDhgBDLqNwTidpTW27BROADs='
$assets[118][0] = "\Snake-UTurn-R-Green.gif"
$assets[118][1] = 'R0lGODlhCAAIAIIAMQD/AAAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDhgBDLqNwTidpTW27BROADs='
$assets[119][0] = "\Snake-UTurn-R-Magenta.gif"
$assets[119][1] = 'R0lGODlhCAAIAIIAMf8A/wAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDhgBDLqNwTidpTW27BROADs='
$assets[120][0] = "\Snake-UTurn-R-Red.gif"
$assets[120][1] = 'R0lGODlhCAAIAIIAMf8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDhgBDLqNwTidpTW27BROADs='
$assets[121][0] = "\Snake-UTurn-R-White.gif"
$assets[121][1] = 'R0lGODlhCAAIAIIAMf///wAAAAMDAwQEBAUFBQYGBgICAgEBASwAAAAACAAIAAIDDhgBDLqNwTidpTW27BROADs='
$assets[122][0] = "\Snake-UTurn-R-Yellow.gif"
$assets[122][1] = 'R0lGODlhCAAIAIIAMf//AAAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDhgBDLqNwTidpTW27BROADs='
$assets[123][0] = "\Snake-UTurn-U-Blue.gif"
$assets[123][1] = 'R0lGODlhCAAIAIIAMQAA/wAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDhgBDLqrRdcqtcrqKXNPADs='
$assets[124][0] = "\Snake-UTurn-U-Cyan.gif"
$assets[124][1] = 'R0lGODlhCAAIAIIAMQD//wAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDhgBDLqrRdcqtcrqKXNPADs='
$assets[125][0] = "\Snake-UTurn-U-Green.gif"
$assets[125][1] = 'R0lGODlhCAAIAIIAMQD/AAAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDhgBDLqrRdcqtcrqKXNPADs='
$assets[126][0] = "\Snake-UTurn-U-Magenta.gif"
$assets[126][1] = 'R0lGODlhCAAIAIIAMf8A/wAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDhgBDLqrRdcqtcrqKXNPADs='
$assets[127][0] = "\Snake-UTurn-U-Red.gif"
$assets[127][1] = 'R0lGODlhCAAIAIIAMf8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDhgBDLqrRdcqtcrqKXNPADs='
$assets[128][0] = "\Snake-UTurn-U-White.gif"
$assets[128][1] = 'R0lGODlhCAAIAIIAMf///wAAAAMDAwQEBAUFBQYGBgICAgEBASwAAAAACAAIAAIDDhgBDLqrRdcqtcrqKXNPADs='
$assets[129][0] = "\Snake-UTurn-U-Yellow.gif"
$assets[129][1] = 'R0lGODlhCAAIAIIAMf//AAAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAACAAIAAIDDhgBDLqrRdcqtcrqKXNPADs='
$assets[130][0] = "\Die.wav"
$assets[130][1] &= 'UklGRrArAABXQVZFZm10IBAAAAABAAIARKwAABCxAgAEABAAZGF0YYwrAAD2qfepI50inV+iWqIXnRKds6GvoX6dfZ1UoVWh1Z3Vnf2g+6Axni+enqCgoJCelZ4xoDqgA58Jn6mfrZ/Cn8mfPZ5DnsSmxqZktmO2A7YCtve297ZQtlS2q7avtoy2kbZ5tn22tra2tly2XbbMttG2R7ZPtta23LZDtka227bZtkq2RLbZttO2ULZPtsu2y7Zctlm2wba9tmm2Zba1trG2dbZwtqu2p7Z8tny2oLajtoC2gbaetp22hLaCtp+2mraGtn22pLaftny2f7aktqi2dbZ3tq22rrZutm+2tra0tmi2Z7a7tr62X7Zktr+2vbZktl+2vba/tmS2bLastrS2eraCtom2j7ZrtW21qqGnoYWehp4toDKg7p7ynvmf+Z8TnxSf3p/inyafKJ/Pn82fOJ83n8CfwJ9En0SftZ+0n0+fTJ+vn6mfWJ9Tn6ifpJ9cn1mfo5+in12fXJ+hn6OfWp9fn6CfpJ9an1qfpp+kn1ifV5+on6qfUp9Wn6mfrp9Pn1Sfq5+un1CfVZ+nn6ufWZ9bn52fn5/TsdKxHrcbtye2I7butu62ObY8tt6247ZBtki21bbXtk62TrbNts62V7ZYtsO2w7ZjtmC2u7a4tm22abaztqy2eLZ0tqa2prZ/tn+2nbabtom2ibaRtpi2jLaTtoy2ibactpO2iraAtqK2nLaAtn62pLamtna2e7aptq22b7ZytrO2tLZrtmi2kraOtiCqIarJnsie0Z/Mn1GfTZ+in6GfZJ9mn5OflZ9tn26fjZ+On3Sfb5+Nn4ifdp94n4Kfi592n3yfgZ+Cn3+ffp99n32fhJ+En3efdZ+Nn4ufbp9un5WflJ9mn2Gfop+gn1afWp+rn7CfR59Jn76fv582nzOf2J/SnxyfGJ/6n/mf5p7lnk+gT6Avni6eK6Mro/20/bRptmi2qLalto62i7aGtoa2o7aptm62eLavtrW2aLZptrq2urZktmS2vba9tmK2Y7a9tr62Y7Zjtry2u7Zmtmm2tLa5tmq2b7avtq+2drZxtqu2pbaAtnm2oraatou2hraStpS2kraXtoK2hbaltqK2drZvtrq2uLZatl+2zrbTtky2TbYMtgm24affpweeC54noC6gGZ8cn7+fvZ9Xn1Sfm5+an22fcp+En4iffp99n3yffJ+En4ifdZ92n4qfiJ92n3Kfi5+Ln3KfeJ+Fn4ufdp94n4Sfg59/n3yffZ9/n4OfhJ93n3afi5+Nn22fb5+Tn5SfZ59nn5mfnZ9en2GfoZ+hn1qfW5+ln6afWJ9Un6ufpp9Xn1efpZ+on1mfXJ+dn5+faJ9sn4SfjJ/wr/mvE7cWtzK2M7bctt22TbZQtse2zrZZtl22v7a/tmW2Z7a1tra2b7ZstrG2rLZ3tnO2qLartne2fbahtqe2fLZ9tqK2orZ/tn62oraftoK2fLaktp62gbZ9tqO2obZ/tnu2pragtn+2fLajtqK2gLZ8tqK2n7aDtoC2nbabtoi2iLaTtpW2kbaRtom2iLaetqO2dLZ4trW2sbZktlu20rbPtj22Q7bytvm2DrYRtjK3LrfFtcC1o7egtwi1CLUyuTK5U65WrrycvpzRoNOgtJ64nv6f/58unymftp+xn2OfYZ+Ln4yff5+Bn3OfdZ+Rn5KfZ59ln56fmp9gn2Cfn5+in1yfXZ+hn6KfXZ9cn6Gfop9cn2GfnJ+hn1+fYZ+cn52fYp9in5ufm59kn2KfnJ+an2OfZJ+an52fYZ9in56fm59in1+fn5+fn16fXp+in56fYJ9an6Sfnp9gn12fn5+fn2GfY5+Xn5qfap9sn4qfjJ9+n3yfc59un6efo582nzWfBaADoFafVJ/9sf2xO7g8uIe1hbVWt1G39rXztRK3EbcitiO27bbutj+2QbbTtte2U7ZWtsG2xrZhtmi2s7a0tnO2cbaotqy2'
$assets[130][1] &= 'eLZ+tp+2oraCtoK2nLaatoi2h7aXtpe2i7aLtpO2lLaOto+2j7aQtpK2lLaJtoy2mLaYtoS2hradtqK2erZ/tqa2qrZxtnS2sra1tmS2Z7bBtsS2U7ZXttO21bZBtkO26Lbptiu2LLYBtwK3ELYNtiW3Irfmtee1WrdYt5S1kLUBuAG4VbNTs1qeUp7cn9afbp9pn3Ofa5+nn6CfUJ9On7iftp9Enz+fwZ++nz2fQp+7n8GfQZ9An7yfuJ9Jn0efsp+0n06fUZ+pn6qfWZ9Yn6GfoZ9in2GfmZ+Xn2qfbJ+Nn5Ofb59yn4ufiJ94n3Wfh5+En3yfeJ+Fn4Cffp98n4Cfg597n3+fgJ+Bn3yff5+An4GffZ9+n3+fgZ9/n36ffp9/n4CfgZ99n3mfh5+En3Wfd5+Mn42fbZ9nn56fmJ9en2GfjJ+Sn/Kg9aBMsE2wBLgDuNG1yrUWtwu3NbYutty22rZUtlS2wbbBtmi2aLawtrK2dLZ3tqW2oraFtny2nbabtoi2i7aRtpW2jraTtou2jLaYtpW2ibaDtqC2mbaEtn+2orajtnq2fbamtqi2dbZ6tqi2rbZytnS2rbaytmq2d7aqtre2a7ZvtrK2srZvtm22sraxtm+2crastrC2dLZztqq2p7Z8toC2mradtoy2j7aEtoq2p7autlm2X7brtu624rXftS64LLjEqMKol56VnjmgOKDwnvGe8Z/ynx+fJJ/Ln86fPZ8/n7OfuZ9Pn1Kfpp+in2OfX5+Yn5afbp9sn4yfjZ91n3efg5+Gn3yffJ+An32fg5+Bn3qffJ+Dn4efdp94n4ifiJ90n3efiJ+Ln3KfdZ+Ln4ufcp9xn46fjZ9vn3Gfj5+Pn26fbZ+Sn5OfaJ9un5KfmJ9ln2efmp+Zn2KfYp+gn52fXp9an6efpZ9Un1ifqp+un02fS5+5n7mfOp89n9Sf2J/1nvee/qD+oEyxSrH6tvS2YLZbtri2uLZstm22sbaytnC2b7awtq22dbZxtq22qrZ3tnW2qraotnm2ebaltqa2fLZ9tqG2o7Z+toO2mrajtn+2h7aYtp62hLaItpa2m7aHtom2l7aVto22h7aXtpS2jLaMtpO2lLaNto22kraSto+2j7aQto+2k7aQto62jbaUtpW2ibaLtpe2mraEtoW2n7actoG2fLaotqS2d7ZytrS2sbZmtme2xLbFtky2Sbbztu22/LX2tcm3xbdasFuwSqFKoV2fWJ+An32fhZ+Gn3mfep+Cn4OffZ9+n36fgZ9+n4GffZ99n4KfgJ99n36fgJ+Bn36ffZ+An4Cff59+n4Cffp+An36fgJ9+n4Cff59+n4Cff598n4Sffp99n3yfg5+Gn3Wfep+In4mfc59wn5Gfj59qn2yfl5+Wn2SfYp+gn5+fWp9bn6ifp59Tn1Cfsp+vn0ufS5+1n7afR59Fn7qfuZ9En0WfuZ+2n0ufR5+xn6+fWJ9Zn5Ofk5+Rn46fBJ8BnyiyJ7Jut2+36bXttRe3GrcYthq2+rb4tjO2Mbbktua2Q7ZGttK21LZUtlW2xLbEtmO2Yra3trm2bbZvtqu2r7Z1tny2obaltn+2gLadtp62hLaHtpe2mbaJtoq2lLaXtoq2jraRtpW2jLaPtpK2kLaRto62kLaRtpG2kbaNto22lraTtou2h7abtpi2hbaBtqO2n7Z8tnm2rLartm62bra6trm2X7Zbts+2zrZEtkW27bbrtiC2GrYltyC30LXQtXS3e7corDCspJ2onVSgVaAEnwSfzZ/Kn1CfTJ+gn5mfc59rn4efhJ+Cn4CfeJ91n4+fh59zn26fkJ+Tn2mfbJ+Wn5Cfbp9ln5eflZ9pn2mflZ+Vn2mfaZ+Vn5WfaZ9on5eflJ9pn2efl5+Yn2SfaJ+Yn5mfZJ9mn5ifnJ9in2OfnJ+en16fY5+cn6CfX59fn56foZ9dn2KfnJ+en2KfY5+Yn5mfaZ9rn42fkJ92n3effp96n5OfjJ9fn1ef'
$assets[130][1] &= 'wp+7nxifGZ8loC6gCZ8Qn+Gw47B0uG+4dbVytVq3XLfxtfm1CLcRtye2K7bktuW2SrZJtsu2yrZgtl62ura3tnC2bbattqq2fLZ2tqW2o7Z+toO2mrahtoK2hLactpm2iLaFtpm2mraHtoa2m7aVtoy2hbaYtpi2ibaJtpe2kraRtoq2kbaPtpS2lraFtoe2oLahtna2ebaxtrW2X7ZgttG20LY6tju2AbcEt/O1+LVnt223PbVDtQ25ErlBrEOsyp3HnaagoqC4nrmeDqAQoBOfEp/Tn86fRJ89n7Kfq59en1qfmZ+an2yfbZ+Ln4yfdp96n4CfhZ98n4CffZ99n4OfgZ98n3mfhp+Dn3qfeJ+Gn4mfc593n4ufiZ9yn3CfkZ+Tn2Sfap+cn6GfU59Xn7aftp81nzOf6J/pn+Oe5554oHygd514nRmqF6pdt1y3xbXEtSm3KLccthi277bptkq2RrbItsu2YrZntq62sLZ7tnu2m7aetoq2jraLto62mbabtn+2gbaktqa2drZ2tq62rrZutnC2sra2tmi2bLa3tra2abZntrm2ubZntmm2tba6tme2braxtra2bLZytqu2sbZ0tnS2qrartm+2dLbZtt22lLKWsiSiIqKrnqae/Z/9nyOfKJ/Dn8efRZ9Dn7Ofrp9Wn1OfpZ+mn1yfXJ+gn5yfZJ9jn5efmp9nn2iflJ+Wn2ifb5+Nn5efaZ9vn5Gfj59un3CfjJ+Tn22fcJ+On42fcp9wn42fjJ9yn3Wfh5+Ln3efdp+Fn4KfgJ9/n3ifdp+Un5CfW59Sn9efzJ+tnqaeiqyKrPe29bYxtim25bbitkm2SbbQtsq2XbZYtr+2wrZktmi2tLaytnW2brartqm2e7Z+tp62nbaKtoS2lbaStpS2kbaJtoe2nraetny2frantqu2b7Z0trO2tLZntmW2wLa/tlu2XbbItsu2ULZSttS21LZHtkW24rbctj22OLbwtu+2IrYhtiO3Irf2sPewnZ+bn1ufVZ+xn6ifUp9Kn7WfsJ9Mn06frp+0n02fT5+un62fU59Sn6ufpZ9cn1afpJ+hn1+fYZ+Zn52fZZ9nn5Wfkp9wn2qfkZ+Ln3afcJ+Ln4efeJ95n4OfhZ97n3ufg59+n4Kfe5+Bn32fgZ9/n4Cfe5+Cn4Cffp9+n3+fgp99n36fgJ+An3+ffp9+n4Gffp+Bn3yfgJ9/n4Cff598n4OffJ+Cn3ufgp9/n32fgJ9+n4afdZ97n4+flJ86nz+fT6FNoUCwOLCat5O3GLYTtuG23bZXtlO2w7a9tmm2Zba2trW2brZstrK2sbZvtnG2r7autnO2cbautq22dLZytq22rLZztnm2pbattna2eraltqO2grZ6tqK2mbaLtoW2lbaQtpe2kraEtoS2pbartmm2bLbEtsi2QrZKtvK2+bYBtge2VLdVt2q1ZrVduFm4zanNqfOc9JzYoNWgop6enh2gHKANnw2f0p/Sn0OfRJ+on6efZp9nn4mfi5+An32feJ9yn5Sfjp9pn2Sfnp+fn1qfXZ+kn6qfUJ9an6ifq59Un1Cfrp+qn1WfUJ+tn6afWp9Un6efop9en16fm5+en2WfZ5+Sn5GfdJ9yn4SfhJ+Bn3+ffp96n2OfYZ8/ojyijbKIsqy3rLf2tfu187b4tkO2RbbLts22XrZftrm2vbZotmy2sbaztm+2c7aqtrS2bbZ2tqy2r7ZwtnS2rbaxtm+2b7aztrC2b7Zrtra2s7Zstmq2tra1tmu2a7a0trW2bLZwtq22sbZ1tna2oramtoS2ibaKtoy2qLaptlm2W7b3tve2yLXDtXe4b7i2pq6m9J3vnY2gi6C2nrWeH6AgoPue/Z7rn+ufJp8kn8qfyZ9Dn0Kfr5+wn1mfW5+Zn5ufa59wn4afi597n3yffZ95n4ufhp9yn3GfkZ+Pn22fap+Vn5Ofap9pn5Wfk59sn2qfkp+Rn3Cfbp+Mn4yfdZ96n36fiJ97n4af'
$assets[130][1] &= 'c596n4yfkJ9mn2qfnp+fn1WfVJ+0n7SfZZ9snySrLatkt2i3OrY5tr22ubZ+tnS2n7aVtpO2i7aPtoe2nbaWtoa2g7aftpy2g7aAtp+2obZ/toK2nraftoK2gradtp22hLaGtpi2m7aHtom2lraWtoy2iraVtpC2kraNtpG2jbaUtpG2jbaNtpO2lraJto22lLaVtoy2ibaXtpO2jbaLtpS2k7aOto+2jraRtpO2kraMtoi2mraatoG2hbagtqS2drZ7tqu2srZntmq2wrbBtk+2Trbrtu62/rUBtrO3tLc7sT2x0KHToUWfR5+In4yfeZ99n4Kfg596n3ifiZ+Dn3ifdZ+Kn4ufcZ91n4mfj59vn3Sfi5+Nn3Gfcp+Mn42fcZ9yn4yfjJ9yn3SfiJ+Pn2+fd5+In4ufdJ91n4ifiZ93n3Sfip+En3ufdJ+In4WfeZ95n4SfhZ96n3mfhZ+Cn32feZ+En4GffJ9/n32fhJ98n4Gfe5+Bn3+fhJ95n3ufhZ+Hn3Wfdp+Ln4ufb59wn5SfkZ9nn2Ofo5+in02fT5/Mn86f1p7WnlqpV6lttme2i7aGtpi2nLaGto62kbaTtpC2j7aPto+2kbaXtoe2kLaStpa2i7aLtpW2lLaMtoy2k7aVtou2jraTtpG2kLaNtpK2j7aStpC2jraPtpK2k7aNtou2lraTtoy2iraXtpS2jLaItpm2kbaQtoe2l7aRto+2jraQtpG2kbaRto62ibaatpa2hbaGtp22o7Z3toK2o7avtmy2dLa1trS2ZbZitsa2xLZTtk+23LbbtjS2OLb/tga38LX0tZa3mLd0s3azvKLDokyfUJ+Un5GfbJ9nn5ufmJ9in1+fo5+dn1+fWp+kn6OfWp9cn6Kfop9en12fnp+fn2KfY5+Yn5mfaJ9rn4+fkZ9yn3Ofh5+En4Cfep9+n3qfiZ+Hn3GfcZ+Sn5KfaJ9ln52fm59en1+fo5+jn1ifWJ+on6ifVp9Tn6ufpp9Zn1afo5+pn1ifYJ+an52fap9nn4+fh5+Dn3ifeJ9wn5yfnp9Kn1Cfyp/MnxCfDZ8joB+gkZ6PnvygAaGPnJWcWKxZrGy5arn/tP20nLedt8y10rUdtyW3H7YjtuO25bZQtlK2vba+tnC2craitqW2hbaFtpW2kLaWtpG2ibaGtp62nbZ+toO2nrantnm2fbamtqO2fLZ5tqe2prZ5tnu2pbaotni2e7altqm2drZ8tqW2qrZ2tne2rLantni2cbawtq22cLZwtrO2srZqtm22tra6tmO2Zra9tsG2XLZgtsO2xrZXtly2xrbKtla2VLbNtsy2UrZWtsq2zLZWtlO21rbNtuaz37O9oL2g357knvWf+J8Xnxif3Z/bnyqfKZ/On8+fNJ84n8Gfw59Bn0CfuJ+6n0ifTJ+vn66fVZ9Qn6qfpZ9cn1qfoJ+hn1+fYp+bn5qfZ59in5qflp9on2qfkp+Vn2yfap+Sn5KfbJ9xn4ufkZ9xn2+fjp+Jn3afdZ+Gn4afe598n36ff5+En4SfdJ91n4+flJ9in2efop+in1GfUZ+5n7qfN581n9mf2Z8QnxSfA6AFoNue2p5OoEygc55xnvug+aADnQad06bXpiu5L7lWtV+1PbdGtyG2I7bTttK2a7ZrtqC2oLaRtoy2ibaCtqW2pLZ0tni2rbawtm22b7aztrW2a7Zotru2r7ZytmO2u7awtnC2a7aytrK2cLZvtrC2rbZ0tnG2rrastnO2d7antq+2crZ4tqq2qbZ3tnS2rLartnS2dLautqm2d7Zwtq+2rLZ0tnG2r7astnS2crautqq2d7Z0tqm2qLZ8tny2nradtou2jLaHtoy2pbaqtl62YLbntua2/LX+tci2zravpLakr52znZagl6C0nreeG6AeoP2eAp/ln+2fI58rn8Sfy59Bn0SfsZ+sn1yfV5+dn5yfap9qn42fjZ93n3ifgJ+En36fhZ91n3yfhp+Jn3OfdZ+Kn46f'
$assets[130][1] &= 'bp91n4mfkZ9un3OfjJ+Ln3WfcJ+Nn4efd593n4Ofi591n32fgZ+Cn3+fe5+Bn3+ff5+Cn3qff5+Bn4SfeZ98n4Kfhp94n32fgJ+En32fe5+Cn32fgp+Bn3qfeJ+Mn4afcZ9tn5iflZ90n22fGawRrCG3HLdNtk62uLa7tnK2drahtqe2f7aFtpe2m7aJtou2kraVto22kbaNtpG2kbaSto62jbaTtpK2jraNtpO2kbaPto+2kLaRtpC2kbaOto+2kbaWtom2jbaWtpO2jbaGtpm2mbaFtom2mLaatoe2hraatpi2iLaItpa2mraItou2k7aVto62j7aOto22mLaUtoi2gbaktqC2d7Z7tq22srZltmi2w7bGtky2Ubbgtue2IbYmtiC3J7extba1JrgmuJuwl7CeoJugv5+7n0ifSJ+ln6efZZ9on4ufjp95n3uffZ99n4efg595n2+fkZ+Jn3Kfbp+Qn5GfbJ9tn5Kfkp9rn22fkZ+Tn2yfa5+Tn5GfbJ9vn4+fj59yn2ufkp+Ln3Ofbp+Qn4qfc59yn4qfjp9wn3afiJ+Mn3Sfc5+Kn4qfdJ92n4ifiZ91n3afh5+Ln3OfeJ+Hn4WffJ90n4ifgZ9+n3uff5+Bn4Cfg594n3efjZ+Ln2qfaJ+kn6GfRp9Fn+af6Z+GnoaeQqo7qoi2frZltl22vra4tm+2braptq22erZ9tp62n7aGtoi2k7aXto22kbaMto+2lLaWtom2hractpm2hbaEtpy2n7aAtoS2nractoa2fragtpy2hLaGtpi2m7aHtou2kraXtoy2kbaMto+2lraVtoe2hraetp62frZ9tqa2qbZztnW2sLavtm22a7a5tre2ZrZitsG2vrZftl22xbbEtlu2V7bKtsi2VrZVts62y7ZPtk6267bptkyySLJ+oH6gBp8Kn9Wf258xnzafwJ/Fnz+fQp+4n7qfR59Mn66fs59Pn1Kfqp+qn1efVp+ln6efWJ9en5+fpJ9cn1yfo5+en2CfWp+kn5+fXp9an6SfpZ9Wn1ufpp+pn1OfVJ+sn7CfSp9Rn7Gftp9Fn0ifup+8nz6fQZ/Bn8SfNp81n9Gf0J8bnx2fNKA4oJ6yobL3tvm2PLZBttq23LZItke21rbWtk22TLbSts62VrZPts62x7Zbtlq2wLbHtl22Zba3tr62ZrZutq62tLZxtnW2p7aqtnq2fbaftqG2hLaEtpi2lraPtoq2kbaRtpC2mbaEtoy2mbabtoK2g7aftqS2eLaBtqK2qrZ1tne2qravtna2frZNtlG2RqlFqaieqp7an96fRp9Hn6afqJ9fn2Kfl5+Zn2mfaZ+Un4+fcZ9sn5Cfi591n3CfjJ+Hn3mfdJ+In4SffJ93n4affJ+En32ffZ94n4qfhJ92n3Cfkp+Pn2mfaZ+an56fWZ9en6ifrZ9In02fvJ++nzSfOJ/Tn9mfFJ8Zn/2fA6DWnt2eY6BnoPyd+50HpAakgLWCtUW2Sba9tsK2drZ7tpS2l7aXtpe2f7Z/tqi2qrZwtnO2sra0tmi2a7a3try2YrZptri2vbZktmW2vLa3tmq2Zra2tru2ZrZvtrC2tLZwtnG2rLaqtnq2eLaktqG2hLaAtpq2mLaOto22jLaLtpy2nrZ5tnu2sbattma2Z7bDtsi2XbZgtrW1trUBpwCnBp4FnjSgNaAPnxGfy5/Hn06fRp+pn6GfZ59jn5KfkJ91n3OfhZ+Fn32ff597n36fhJ+En3efeJ+In4ifdZ91n4mfip91n3Ofi5+Hn3ifc5+Jn4ifdp95n4OfiJ94n3yfgZ+Cn3+fe5+Bn3+ff5+Cn3uffZ+Dn4Ofe591n4yfgJ99n3OfiJ+Jn3Sfep+En4qfdZ94n4afhp96n3efhZ+Bn3+ff595n3+fhZ+Mn2qfbp+fn56fSp9Dn+yf5596nnueiamMqWa2ZLZdtlu2xbbFtmK2Yba5trO2dLZttqu2q7Z5tn+2nLagtoe2hraVtpK2'
$assets[130][1] &= 'lLaPtoy2hraetpy2frZ/tqe2prZ2tm+2t7autmy2Z7a8tr62XLZitsS2xrZXtlO20bbNtk62T7bTtte2SLZIttq22LZGtki217batkq2R7bVttC2VbZXtsG2xbbetOG0GaEboa+es54YoB2g+Z77nvWf9p8Snxaf3p/knySfJJ/Un82fOZ8wn8Wfwp9Cn0WfsZ+3n06fVJ+jn6qfWp9in5afnZ9nn2+fiJ+Sn3Sfd5+Dn4Gfgp9/n3qfeZ+In4yfbZ90n4+fkp9pn2qfmJ+Vn2efYZ+fn5yfXp9dn6Wfp59Qn1Wfsp+1n0qfSJ8UqxCrHLcbt0+2Ura2trm2c7Zytqm2prZ8tn22obaitoC2gLaetp+2g7aDtpy2mraItoW2mraTtpC2iLaVto22lraQtoy2h7adtpm2g7Z8tqm2prZxtna2sba4tmK2Y7bGtsS2U7ZRttm217Y+tju28rbutiO2ILYRtxK39rX7tUa3SLeltaO15Lfkt6ewq7AIngueDKANoD+fQp+Vn5eff59/n2+fcp+Vn5qfXp9hn6KfpJ9Wn1mfp5+qn1SfVJ+rn6ifVp9Vn6ifqJ9Xn1afqJ+kn1yfVZ+nn6OfWp9dn6Gfo59cn1qfpZ+hn1yfWJ+nn6WfV59Un66fqJ9Rn06ftZ+1n0KfPZ/Pn8WfI58enwagCKCOnpCenqKfohizFrPDtsK2h7aJtpS2k7aMtoi2m7aUtoq2g7aetpq2g7aGtpq2n7aCtoO2nrabtoW2graetpu2hraAtqC2mbaHtoO2mraetoK2iLaZtpy2hbaCtqC2mbaFtoK2nbahtn62gragtqK2fLZ+tqW2pLZ6tnm2qLaqtnS2d7artq62b7Z2tqu2s7ZttnO2r7autnO2cLautq22drZ1tqe2pLaBtoK2lLabtpG2lbZ8tn+2tra2tk62S7YBt/622rXXtTa3LrfapdWld515naygr6CsnqmeIaAfoACfAp/kn+KfMZ8sn8Cfvp9Nn1Kfn5+ln2SfaZ+Mn4+fd597n3yffp+Hn4efcp9xn5GfkZ9pn2uflp+Wn2efZp+Yn5ifZ59mn5eflJ9tn2ifk5+Nn3Wfbp+Ln4efe596n36fgJ+Dn4ifcJ91n5Gfj59qn2Wfnp+an1+fWp+pn6OfVp9Rn7GfrJ9Pn0ifuJ+0n0afSZ+2n7qfRJ9In7SfuZ9Jn06fqZ+sn2CfYp9/n4KfN7E4sSq3Jrcgth6277bwtj22Orbdttq2TbZMts22zbZZtlm2wrbBtmS2Yba7tra2bbZttq22tLZwtnW2qbartne2eraktqe2e7Z8tqS2obaAtny2orajtn22f7ajtp62grZ8tqO2oLaAtn+2oLagtoC2g7abtqG2gLaJtpW2m7aKtou2kLaTtpG2mraAtoe2oraktnS2c7a2trm2W7ZdttK20rY9tjy2+bb4tg62DrY0tzC3xLXAtaG3oLcMtQy1JbkmuaKuoK7KnMacy6DIoLyewJ72n/yfL58zn62fr59ln2ifhJ+Ln4Cfh59un3KflJ+Vn2SfZJ+dn5+fXZ9dn6OfoZ9cn1yfoZ+kn1ufXJ+in6CfX59dn6CfnZ9in2Gfm5+cn2WfYJ+en5afZ59ln5efmp9ln2afmZ+Xn2efZJ+Zn5ufYp9mn5qfm59hn2OfnZ+dn2GfX5+fn52fYp9fn56fm59ln2Gfmp+Yn2ifbp+Jn5Gfd59+n3KfeZ+an5+fQJ9En+mf7Z/On82f/7H5sTW4MbiPtY21ULdItwG29LUQtwa3LbYptua247ZLtkm2ybbMtl62Zrawtra2dbZ2tqK2oLaItoa2k7aRtpW2k7aHtom2mbaktni2hLahtqW2erZ7tqa2p7Z5tnq2pbamtny2fbahtqC2hLZ/tp+2lbaOtoi2kraRtpS2lbaFtoa2obagtnm2erastq62bLZttrm2vLZctmW2wbbLtlC2V7bPttS2R7ZKtty23bY+tju27bbnti22KrYNtxS3'
$assets[130][1] &= 'l7WitYqjj6MYnxef0Z/NnzefMp/Jn8OfPp83n8WfvJ9Dn0GfuJ+8n0afSp+xn7GfUZ9Sn6afrZ9Vn16fnJ+in2KfZJ+Wn5Wfbp9rn46fj59xn3mfgZ+Jn3qffp99n36fhJ+Cn3mfd5+Jn4mfc59yn4+fi59xn26fkZ+Rn2ufbJ+Vn5GfbJ9on5WflZ9on2yfkp+Vn2mfbZ+Qn5Wfa59tn4+fkp9un3Gfi5+Nn3Ofdp+Gn4efe593n4WfgJ99n3+fhJ+Kn0mfTZ+wobGhDLENsba3trcBtv+167bttky2Ura/tsG2a7Zptq62rrZ4tnq2obaitoS2gLactpm2ibaKtpO2lbaPtou2k7aPtpG2kraMtpC2kraSto62jLaTtpS2jLaOtpO2kbaQtou2lbaPtpK2i7aUto62kraOtpG2kLaPtpO2jLaSto+2k7aOto62k7aPtpG2jraRto+2kraQto62kLaQtpe2iLaMtpe2mraCtoi2nLahtnu2fraotqy2a7ZutsK2xbY5tkC2SLdOt1atV63cn9ufeZ95n32ffp+An3+fgZ9/n32ffJ+En4Kfe595n4Wfhp92n32fgZ+In3ifeZ+Gn4GffZ96n4Kfg599n3ufg599n4Gff598n4Gffp+En3mffZ+Dn4Ofe594n4afg597n3mfhJ+En3qffZ9/n4Wfe59/n36ff5+Bn4OfeJ97n4efiZ9xn3Ofj5+Sn2ifap+Zn5mfYJ9fn6SfpZ9Un1Cftp+un0efQ5/Cn8WfLp8xn92f258OnwmfHKAXoImegp5FojuiYbNcs7S2sraEtoG2obaetn62e7aotqa2drZ6tqa2rrZztna2rLantnq2dLaptqq2drZ9tqG2qbZ7tnu2pLaitn62f7agtqG2gLaAtqC2n7aAtoO2nLajtn22hLadtqK2fbaCtqC2orZ9tn+2obamtnq2fbaktqa2ebZ7tqW2qrZ2tnq2p7altn22d7antqS2fbZ9tqC2oLaFtoO2mLaTtpW2jraJtoG2qramtmm2abbNtsq2ObY0the3FrfDtcW1ULdOt+2m56ZdnVydsKCzoK2erp4coBigCJ8Gn96f4J8xnzSfu5+9n02fUJ+jn6ifYJ9hn5efkZ90n2yfjJ+Gn3yfeJ+Cn3+fgp9/n3yffJ+Cn4mfdJ94n4mfiJ90n3SfjJ+Ln3Gfcp+Mn5KfbJ9un5Kfkp9pn22fk5+Xn2efYp+fn5mfYZ9en6SfoJ9Zn1ifqp+rn06fUZ+xn7SfR59In7ifvZ8/nz+fxJ+/nzufN5/Kn8afNp8yn8yfzJ8xnzOfy5/KnzafNJ/Sn9GfV7NSsym3ILccthe2+rb9tiu2MLbqtuy2O7Y7tt+23rZItke21LbPtli2ULbJtsS2YbZhtrm2uLZvtmy2rbautna2fLagtqK2hLaCtpm2mbaKto62jraUto+2lbaJto62lbaVtou2hrabtpa2ibaGtpq2mLaItoe2mraTto62h7aXtpS2jbaLtpS2kLaSto62kLaMtpa2kraLtou2lbabtoO2iraYtp62gLaFtp+2nraBtna2sbamtme2ZLbztvO2prSptKGlpKWinqGe5Z/hn0CfQJ+tn7GfVp9Zn6Cfop9fn2OfmZ+bn2WfaJ+Tn5qfZ59pn5afj59wn2ufkJ+Rn26fcJ+Nn4+fcJ9zn4qfi591n3Wfhp+Jn3effJ9/n4Sff59+n36feJ+Kn4Ofdp9yn5Cfj59qn2afn5+Zn12fWJ+un62fSJ9Hn7Gfrp9moGOgKK8mrxC4CrjXtdO1B7cJtzm2O7bSttG2XLZatr62ubZttmm2sbaytnC2drantq+2c7Z6tqa2qbZ4tnq2pbaotnm2e7altqO2f7Z6tqS2obaAtoC2nradtoa2hraVtpa2kbaPtom2h7ajtp62eLZvtr62urZRtlS25rbqthK2ErZJt0K3e7V3tTy4PritqK2oAJ0Cndqg4aCSnpeeKKApoP6eAp/dn+Sf'
$assets[130][1] &= 'Mp83n7WftZ9an1ifmJ+Vn3afcZ+Cn36fiZ+Gn3CfbZ+Yn5WfYp9in6CfpJ9Wn1ufpp+qn1OfVJ+rn6yfUp9Tn6qfrJ9Un1Ofqp+nn1ifWp+gn6SfYJ9dn52fl59sn2afk5+Ln3ifb5+Pn4mfTp9Ln9Si0qJFs0Czi7eEtwu2Bbbvtuy2SrZJtsm2ybZhtl+2ura5tmu2bLaxtrK2cLZxtq62rbZ0tnK2rrastnS2cLaxtq22crZstre2rbZxtme2uraytmy2Zra7tra2abZltrq2ubZptmW2uba3tmq2brautrG2d7Z2tqC2nraRtpG2drZ5ttC21Lb6tfu1GbgXuK6lqKUdnhWefKB0oMGevJ4eoB6g+J77nu+f858cnx2f05/TnzifOJ+5n7yfTZ9Qn6Wfop9on12fmJ+Ln3ufcZ+En36fh5+Dn3Sfcp+Sn5CfaZ9mn5yfm59en2GfoZ+gn12fWZ+ln6SfWp9an6Ofo59dn1yfoZ+bn2efYJ+Yn5afbp9rn46fh59+n3effp97n4yfip9pn2ufnp+fn1WfUZ+6n7OfPZ84n9Sf0p8anx2f9J/4n++e8p4roC2gpZ6jnqmgqKCfnaKdsaSypBm3GLf0tfW15bbntmO2X7aotqS2i7aKtou2i7adtpq2gbZ+tqW2oLaAtni2qbactoW2ebajtqG2f7aDtp22nLaGtoS2mbaetoK2iLaatpu2g7aHtpm2orZ9toC2pbaltnS2erastrO2aLZntsK2vrZYtle20rbUtkG2Qrbttuy2HbYZtke3Q7cGtAi0yKXOpQOeCJ5yoHSgtZ61njOgNKDantyeE6ARoACf+57tn+mfL58rn7Sfr590n3CfYZ9fn9Sf05/rnu2eXaBeoEWeQp4voS6hOJ08nZOilqIpmymbF6YVpleTV5M='
$assets[131][0] = "\EatSnake.wav"
$assets[131][1] &= 'UklGRkQVAABXQVZFZm10IBAAAAABAAIAgLsAAADuAgAEABAAZGF0YSAVAAAAAAAADP8L/xb+GP4h/ST9LPwv/Dj7OftG+kL6UvlO+Vz4XPhl92j3cfZy9n71ffWJ9Ir0kvOW857yofKq8avxt/C18MPvwe/N7s7u1+3a7ePs5ezu6/Dr+ur86gXqB+oQ6RPpG+gf6CfnKecz5jPmQeU95U3kSORX41bjYeJh4m7hauF74HXgh9+A35Hejt6a3Zvdpdym3LHbsdu82r7axtnK2dHY1Njg19zX7tbl1vvV8NUF1f/UDNQN1BfTF9Mk0iPSXtxi3KHbqdvn2u7aMNow2njZddm+2LzYAtgD2EjXSNeP1o7W09XV1RnVGtVh1F7Up9Ok0+3S6tIy0jHSeNF20b7QvNAD0APQSc9Iz5DOjc7VzdXNGc0czV/MYcymy6bL68rsyjPKMMp5yXbJvsi/yADIBshIx0nHkMaOxtbF1MUcxRnFYsRgxKfDpsPtwuzCMcI0wnjBd8GAs32z7avpq/iq9KoEqgCqDqkMqRmoGagjpySnL6YvpjylOaVIpEOkVaNOo1+iXKJooWmhcqB2oHyfgp99n4Cffp+An3+ffZ+En3efiJ93n4Wfe5+Bn36fgJ9/n36fgJ9+n4CfgJ98n4KffZ+An3+ff59+n4GffJ+Cn32fgJ9+n4Cffp9/n4CffZ+Cn3yfgZ99n4KffJ+Bn5+knaSTto22kraPtpG2j7aRto+2kLaRto62k7aNtpK2jraTtoy2lLaNtpG2kbaOtpK2j7aRto62kraOtpO2jbaSto+2kLaRto62kraPtpC2kbaNtpS2jbaSto62kraOtpK2j7aQtpG2jraTtoy2lbaLtpS2jbaSto+2kLaQtpC2kLaQtpC2kLaPtpK2jbaUtoy2k7aPto+2kraOtrKjsqN+n3+ff59/n4CffZ+Cn3yfgZ9+n3+fgJ9+n4CffZ+Cn3yfgZ9+n3+fgJ9+n36fgp98n4Gff599n4KffZ+An3+ffp+An3+ff59/n36fgJ9+n4Cff59+n4Cffp+An3+ff59+n4Cff59/n3+ff59/n3+ffp+Bn32fgJ9/n36fgJ9/n36fgZ98n4KffZ+An3+ffp+Bn32fzaHLoZC2kbaQtpC2j7aQtpC2kLaSto22kraPto+2k7aNtpG2kbaOtpK2j7aPtpK2jraSto62kbaQto+2kraNtpO2jraRto+2kbaPtpK2jraRtpC2j7aSto62kbaRto62kraOtpK2jraSto+2kLaQtpC2kLaQtpC2kLaQtpC2kLaPtpK2jraRtpC2j7aSto62kraNtpS2i7aWtou2k7aOtpG2kbaOtpO2jLaTtpC2j7aRto+2kbaPtpG2j7aRto+2kbaPtpG2j7aRto+2kraNtpO2jbaTto62kbaPtpehlaGAn32fg596n4Sfe5+Bn3+ffp+An3+ffp+An36fgJ9/n36fgJ9+n4Cffp+An3+ffp+An36ff5+An3+ffZ+Bn36fgJ9+n4CffZ+Bn36ff5+An32fgZ99n4GffZ+Bn32fgZ99n4CfgJ98n4Ofep+En3yfgJ9/n3+ffp+Bn32fgZ99n4Cff59/n3+ff599n4KffZ+Bn32fV61VrZG2kLaQtpC2kLaQto+2kraPtpC2kLaQtpC2kLaQtpG2jraSto62kraPtpC2kLaQtpC2kLaPtpK2jraSto62kbaQtpC2kLaRto62kraPto+2k7aMtpS2jbaSto62kraOtpK2jraSto62kraOtpK2jraSto62kraPtpC2kLaQtpC2kbaOtpK2jraSto62kraPto+2krY/tEK0gJ99n4CfgJ98n4Ofe5+Dn3ufg598n4Gffp9+n4Gffp+An36ff5+An36fgJ9+n4Cff59+n3+fgZ98n4Ofep+Cn3+ffZ+Cn3ufg598n4Gffp9+n4KffJ+Bn36ff5+An3+ffZ+Bn32fgp99n3+fgJ99n4Gffp9/n3+f'
$assets[131][1] &= 'gJ99n4CfgJ99n4Kfe5+Dn3ufg598n4CfgJ99n4GffZ/8qfmpkbaPtpC2kbaPtpG2kLaPtpG2j7aRtpC2kLaPtpK2jraRtpC2j7aSto62kbaPtpK2jbaUtou2lbaNtpG2kLaQtpC2kLaQtpC2kLaQtpC2j7aSto62kbaQto+2kbaQto+2kbaQto+2kraNtpO2jbaSto+2kbaPtpG2jraSto+2kLaRto+2kbaPtpC2kbaOtpO2jbaTtnS0ebR+n4Cff599n4KffJ+Cn32ff59/n4Cffp+Bn3yfgp98n4Kffp9/n36fgJ9+n4Cff59+n4Cffp9/n4Cffp+An3+ffp+Bn3yfgZ9/n3+ff59/n36fgJ9/n3+ff59/n3+ffp+Bn32fgJ9/n36fgJ9/n36fgZ98n4Gff59+n4Cff59+n4Cffp+An36fgJ9+n3+fgZ98n4Gffp+An36fgJ9+n4Cff59+n4Cff59+n4Cffp+An3+ffp+An32fgp99n4Cff59+n4GffJ+Dn3ufgp99n4GffJ+Dn3qfhJ+NtpG2kLaQtpC2kbaOtpK2jraTto22kraPtpC2kLaRto62k7aNtpK2jraSto+2kLaRto62k7aNtpK2j7aRtpC2j7aRto+2kbaQto+2kbaPtpG2j7aRto+2kLaRto+2kbaPtpC2kLaQtpG2jraSto62kbaRto62kbaQto+2kraPtpC2kLaQtpC2kLaRto+2kLaRto+2kLaRto62k7aNtpK2j7aQtpG2jraSto62k7aNtpK2jraSto+2kLaQto+2kraOtpK2j7aOtpO2jraSto+2uKi6qH+ff59/n3+ff59/n3+ff59/n4Cffp9/n4CffZ+Bn36ff5+An32fgp97n4Sfep+Dn32fgJ9+n4GffJ+Cn3yfgZ9/n36fgJ99n4KffJ+Bn36ff59/n4Gfe5+Dn3ufg598n4GffZ+Bn32fgZ99n4Cff59/n36fgZ99n4Cffp+Bn3yfg597n4KffZ+Bn32fgZ98n4Ofe5+Cn36ffp+Bn3yfgp98n4Ofe5+Cn32fgJ9/n36fgJ9/n3+ff59/n36fgJ+An32fgp98n4Cff59/n3+fgJ9+n3+ff59/n5C2kbaOtpK2jraSto62kbaQto+2kraNtpK2kLaOtpO2jraQtpG2j7aQtpG2j7aRto+2kbaPtpG2j7aSto22lLaMtpK2kbaOtpG2kLaOtpS2jLaTto62kbaPtpG2j7aRtpC2j7aRto+2kLaRto+2kbaPtpC2kLaRto+2kbaPtpC2kLaStoy2lbaLtpS2jbaSto62kraPtpC2kLaQtpC2kLaRto62kbaRto62kraOtpG2kLaRto62kbaQto+2k7aNtpG2kLaQtpC2kbaNtpS2jLaUtoy2w6m/qX+ff59/n3+ff5+An32fgZ99n4CfgJ99n4GffZ+An3+ff59/n3+ff59/n36fgZ99n4GffZ+An36fgZ98n4KffZ+An3+ffp+An4CffJ+Dn3qfhJ97n4KffZ+An36fgJ9+n4Cff59/n3+ff59+n4GffZ+Bn32fgJ9/n3+ffp+Bn3yfgp99n4GffJ+Dn3qfhJ97n4GfgJ97n4Sfep+Cn3+ffZ+Bn32fgZ99n4Gffp9+n4KffJ+Bn36ff5+An36ff5+An32fgp98n4Gff59+n4Cffp+An36fCasFq5G2j7aSto62kbaQto+2kraPto+2kbaQtpC2kbaOtpG2kLaQtpG2jraSto62kraOtpK2jraSto62kraOtpK2j7aQtpC2kbaOtpK2j7aPtpK2j7aQtpC2kLaPtpK2jraRtpG2jbaUtoy2k7aOtpG2kLaRto62kraOtpG2kbaOtpK2j7aPtpO2jLaUto22kbaQtpG2jraSto62kbaRto62kraOtpK2jraTtoy2k7aPtpC2kbaOtpK2jraSto62kbaQto+2kbaPtpG2j7aSto22k7Y+tES0fp9+n4Cffp9/n4CffZ+Bn36ffp+Bn3yf'
$assets[131][1] &= 'gp99n4Cffp+Bn3yfgp99n4Cff59+n4GffZ+An36fgJ9+n4GffJ+Bn36fgJ9+n4GffJ+Bn3+ffp+An36ff5+Bn3yfgZ9+n3+fgJ9+n3+ff5+An32fgp98n4GffZ+Bn36ff5+An3yfg597n4Ofep+En3ufgp9+n36fgJ9/n36fgZ99n4Cff59+n4GffZ+Bn3yfg597n4KffZ+An3+ff59+n4Cffp+An3+ff59+n4Cffp+Bn32fgJ9+n4Cff59+n4Cf+K/6r4+2kbaPtpG2j7aRto+2kbaQto+2kbaPtpK2jbaTto62kLaSto22k7aOtpG2j7aSto22lLaLtpW2jbaRtpC2j7aSto22lbaKtpW2jbaQtpK2jraRtpC2j7aRtpC2j7aSto22k7aOtpK2jbaTto22k7aOtpC2kbaPtpG2j7aRto+2kbaPtpG2j7aRto+2kbaPtpG2j7aRtpC2kLaPtpG2j7aSto22k7aOtpC2kbaOtpO2jbaTtoy2k7aQto+2kLaRto62k7aNtpK2j7aRto+2kLZBtEK0fZ+Bn32fgZ9+n3+ff59+n4GffZ+Bn32fgZ99n4Cff59/n3+ff59+n4Cffp+Bn32fgJ9+n4Cff59+n4GffJ+Cn32fgJ9+n4GffJ+Cn32ff5+Bn32ff5+Cn3qfhJ97n4Gff59/n36fgZ97n4Sfe5+Cn32fgJ9+n4Cff59+n4Cffp+An3+ff59+n4Cff59/n4CffJ+Dn3ufg598n4Cff59/n3+fgJ99n4Gffp9/n4Cffp9/n4CffZ+Bn36ff59/n3+ff5+An32fgZ9+n36fgZ9+n3+ff58bpBqkkraPto+2kraOtpG2kbaOtpK2jraSto62kraOtpK2j7aQtpG2jbaVtou2lbaLtpS2jbaTto22kraOtpO2jbaSto+2j7aTtoy2lLaNtpK2jraSto62k7aNtpG2kbaPtpC2kbaOtpK2j7aQtpG2j7aQtpC2kLaRto+2kLaRto62kraPtpC2kLaRto62kraPtpC2kbaPtpG2j7aRto+2kraOtpG2kLaPtpK2jraSto62kbaQto+2kraOtpG2kLaPtpK2jraQtpK2jraSto22k7aNtpS2jbYwpy+nfp+An3+ff59/n36fgJ9+n4GffZ+An3+ffp+Bn32fgJ9/n3+ffp+An36fgZ98n4Kfe5+En3ufgZ9+n3+fgZ98n4KffJ+Bn3+ffp+An36fgJ9+n4Cffp9/n3+fgJ99n4Kfe5+Dn3yfgZ99n4Gffp9/n4CffJ+Cn36ffp+Cn3qfhJ97n4KffZ+An36fgZ99n4Cffp+An36fgZ98n4KffZ+An3+ffp+An3+ffp+Bn32fgJ9/n36fgJ9+n4Cff59+n4Cffp9/n4GffZ+An3+ff59+n4GffZ+Sto+2kLaQto+2k7aNtpO2jLaTto62kraPtpC2kLaQtpC2kLaQtpC2kLaQtpC2kLaQtpC2j7aRtpC2j7aSto62kbaQtpC2kLaQtpC2kLaQtpG2j7aRto+2kLaRtpC2j7aRtpC2jraUtou2lLaOtpG2kLaOtpO2jLaWtoq2k7aQto62k7aNtpO2jbaTto22kraQto+2kbaPtrKjsaN+n4Cff59/n3+ff59/n4CffZ+Cn3ufg598n4Gffp9/n3+fgJ99n4Kfe5+Dn3yfgZ99n4Cff59/n36fgJ9/n36fgZ98n4Kffp9+n4GffJ+Dn3ufgp98n4KffZ+An3+ffZ+Cn3yfgZ9/n32fgZ9+n3+fgJ9+n3+fgJ99n4Gffp+An36ffp+Bn32fgZ99n4GffZ+Bn32f+6n6qZC2j7aTtou2lbaLtpW2jLaTto22kraQto+2kraNtpO2jraSto62kbaPtpK2j7aQtpC2jraUto22kbaRto22lLaMtpS2jLaUtoy2k7aPto+2kraOtpG2kLaQto+2kraNtpS2jLaTto62kbaQtpC2j7aSto62kbaQto+2kraOtpK2jraRtpC2kLaPtpK2'
$assets[131][1] &= 'jraSto62kbZ3tHe0f59/n36fgZ9+n36fgp97n4Kffp9+n4Kfe5+Cn36ffp+Bn32fgJ9/n3+ffp+Bn32fgZ99n4GffZ+An4CffZ+Bn32fgZ99n4GffZ+An4CffZ+Bn32fgJ+An32fgp98n4Gffp9/n3+fgJ9+n3+fgJ99n4KffJ+Cn3yfgZ9/n36fgJ9/n32fg596n4Sfep+Dn32fgJ9+n4Cffp8wpy+nj7aRtpC2kLaQto+2kraOtpG2kLaPtpK2jraRto+2kbaQto+2kraNtpK2j7aRto+2kbaOtpG2kbaNtpW2iraWtoq2lbaNtpG2kraMtpS2jLaTto62kraOtpK2jbaUtou2lraLtpS2jLaTto62kraPto+2kraOtpK2jraSto62kraOtpG2kbaOtpK2jraRtpC2kLaPtpO2jLaUtoy2k7aOtpK2j7aPtpK2jraSto+2kLaPtpK2jraSto62kraOtpK2jraSto62k7aMtpS2jbaSto+2kLZBtEG0f5+An32fgp97n4OffJ+Bn36fgJ99n4GffZ+An3+ff59/n3+ffp+An3+ffp+Cn3ufgp99n4Cff59/n36fgZ99n4Cff59+n4GffJ+Cn3yfg597n4KffJ+Cn32fgJ9/n3+ff59+n4Cff59+n4Cffp+An36ff59/n3+fgZ97n4Ofe5+Dn32ff5+An36ff5+Bn3yfgZ9/n32fgp/ysfSxkbaPtki3Srf/twG4uri2uHW5b7kquiq64briupy7l7tWvFC8C70NvcC9xb17vnu+Nb8zv+u/7r+iwKbAXcFbwRfCE8LPwszCh8OEw0DEPMT4xPXEr8WvxWbGaMYfxx7H2cfXx4/IkchHyUrJ/8kByrjKuspwy3LLKcwpzOPM4MybzZvNUM5VzgjPDc/Cz8TPedB+0ErMUMxxw3PDZcRkxFrFVMVMxkjGPMc8xy3IL8gfySLJD8oVygPLBcv3y/XL68zozNvN2s3Pzs3Ov8/Bz67QttCi0aPRmNKU0orTiNN61HzUa9Vt1V/WX9ZS11HXQthF2DPZOdkk2izaFtsd2wrcDtz83ALd7d303eDe5N7V39Xfx+DI4Ljhu+Gq4qzioOOb45Lkj+SB5YXlcuZ25mbnZudZ6FnoS+lM6TvqQOos6zPrIOwi7BTtE+0H7gbu+O757unv7O/c8N3wzvHR8b7yxfKv87jzovSn9Jj1l/WL9on2ffd792/4b/hf+WP5T/pW+kT7RPs5/DX8K/0p/Rv+HP4P/wv/AwD9/w=='
$assets[132][0] = "\Egg.wav"
$assets[132][1] &= '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'
$assets[132][1] &= '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'
$assets[132][1] &= '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'
$assets[132][1] &= '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'
$assets[132][1] &= 'graCtru2vrZFtkq29bb5tgO2AbZTt1S3cLV1tYe4hLjdr9WvxJ+5n+6f5Z9Dnz6fnp+bn3ufeZ90n3Cfm5+Zn1mfW5+tn62fSZ9Fn8Gfv58znzSf4J/hn82ezJ4KpQulXLRitFS3XLcEtgu2/7YHtyO2KrbytvS2L7Yxtu228LYwtjS27bbxtiy2Mrb1tve2HbYgtha3Hbe1rbutD58Qn6ifqZ9on2qfkJ+Pn26fap+an5WfYJ9bn66fsJ87nz+f25/Yn/+e/Z4+oEGgXZ5fnoqoiai8uLm4h7WAtTa3Lbcutie2zrbMtnS2d7aKtpG2rraytk+2Tbb7tvW2+LXxtXu3ercWtRq1d7l/uZGomKjJnMqcBqEEoXaedp5DoEOg6J7lnvqf9p8fnyCfyJ/On0OfRp+on6efap9nn3+fe5+tn6if457fngGv/q42tzm3CbYQtv22A7cmtjC26bb3ti22NLbwtuq2NLYptvy297Ydthy2FrcZt+K15rWYt5e3z7PLs3iidKJdn1+flJ+Sn2afYp+in6KfVZ9Yn6yfr59Jn02ft5+8nzqfRJ/Cn9CfIJ8qn/af+5+bnpye8KPpoxizDrNat1m3HLYjtuS257ZGtkK22LbVtk22ULbMttS2T7ZVtsq2zbZTtlu2w7bOtlG2WbbituO2krKRskShQ6G4nreeE6AQoACf/574n/SfDZ8In/Wf9Z8Fnwif/J//n/We9p4aoBmgyZ7GnmqgbKAYniGe5qLrome2abZBtka2o7aotp+2m7ZqtmO207bUtjO2OrYAtwS3ALYAtkS3Rreotau1wbfEt9O00rSmuZ+5batmq7qctJzloOCgqp6mng2gBaAqnyKfuJ+0n2SfY5+Gn4SfjJ+Jn2WfY5+qn6WfS59En8yfzZ/1nvie6aTupOC03rRTt1C3+7X2tR63FrcOtgW2G7cTtwq2BbYdtx+3+7X9tSy3LrflteS1UrdSt6S1o7Xjt+C3hrODs1CgUqCbn52fiJ+An2ifV5+3n6yfQZ8+n82f0p8bnySf7p/0n/Ke9Z4soDCglJ6bns6g1qAUnRidhaiDqAe4BLiBtX+1TLdGtw22Brb3tvO2RrZHtsK2xLZztm22n7aVtqO2m7ZktmG27rbstty12rVBuDe4Baj5p2yeap5LoEug5p7fngKg858hnxKf2J/TnzefOp+3n76fTJ9Pn6Wfpp9in2Sfj5+Vn2+fc5+1n7KfrayqrD23Qbc+tkS2ura/tnW2e7aWtpq2k7aYtnu2gbattrG2YbZgttO20rY1tjS2ELcLt+W12LU0tyS3cKloqVudW52boJmgyZ7CngegA6AcnxqfzJ/In0ufRZ+on56fcp9qn32ff5+Yn5yfQJ87n/yf9J+Fn4Kf0LHOsU+4T7hwtXi1Zrdwt9O127UytzO3/LX3tR63IrcCtgq2FrcYtwe2B7YftyC38rXxtVW3TbfgsteylJ+On0qfRp/In8mfKp8rn92f2Z8dnxmf7J/snwifCZ8BoAKg7J7tnimgKKCxnqyemqCWoK+dtJ0cpSGl8rXqtTq2LLbTtsm2b7Zwtpu2oLaSto+2hbZ8tq+2rrZgtmy2xrbRtji2PbYLtw63xLXHtTq4O7iJrImsYJ9jn/if+J8bnxSf2J/RnzmfN5+8n7ufTZ9Kn6ufqJ9dn2CflZ+Zn2+fdp96n32fnJ+anyefKZ+9rL2s8LbvtlS2Vraztri2d7aCtpC2m7aVtpe2fbZ3tri2tLZZtlq227bdtie2KbYftx+3xLXFtaO3ord2rHKsb51qnXmgeKDtnu6e2J/an0mfS5+Xn5efgZ98n2qfZp+wn7GfLZ84n+yf95/OntOemqCaoDydOJ2iq5qr67fmt5S1i7VUt0S3Abb9tQW3Dbcnti625Lbltkm2RbbQtsq2YbZctra2sraBtn22gbZ/tvy2+7aYpZ2lx57KngygCKALnwOf75/tnxSfG5/hn+efGJ8Zn+if6J8Qnw2f'
$assets[132][1] &= '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'
$assets[132][1] &= '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'
$assets[132][1] &= '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'
$assets[132][1] &= 'pLamtne2fbantq+2arZttsS2v7ZBtj+2Pbc+t/ql9qUCn/6e2J/cnzOfOZ+9n8OfPp9En72fwZ8znzWf5p/on66es56KqJGoEbYZtqG2qbaDtoi2mbaatoK2hraetqi2cLZ6trG2t7Zrtm62dbR1tKGipqJdnl6eOqA4oOie654IoAeg9p70nhagHKDBnseee6B+oGeebJ5xsHqwkbiYuE61UbWKt4i3tLWwtWu3abemtam1oremtxS1GLUzuTm5v6rBqsSdv523oLSgj56UnkmgUKC7nrqeS6BLoJSelp6zoLega51xnUGnRad2tnq2DLYOtvi287ZCtj2217bStlK2UrbOtti2NrZAtim3LLfZs92zt6S/pJCekZ4DoPufHp8Un+Wf3J8bnxef85/1n/Ge9Z4soDigxp7Pnumq6apvuHC4rrWttRm3Gbc1tjW20LbMtme2Y7attq620rbNtkK3ObeJt4e307fTtzq4N7huuGy46LjquAa5B7mYuZq5n7mhuUq6S7o1ujW6BLsHu7m6vrrVu9S7JLsgu0W8Rryjrq2uiKWSpRmpIqmAp4mnjKmMqYqogKhqql+qQKk6qZarlqthqWKpG7UatTXCOMLvvvW+ecF9wRTAEsDzwezBwsDAwLDCt8IKwRLBN8Q8xLi9wL07r0WvFLEZsW+wbLCPsYyxg7GDsT2yPLJ8sniy/7L/slqzXrNHtEu0Ar8Cv6vHpMeIxoHGn8efx2bHaMcmyCbIGcgYyMzIzsinyK/IlsmfyerD78OZt5i3E7oSuiO5Jbm0uq+6F7oMuou7hbvkuuG6ebx1vIO7gLspviq+Xc1gzXPNds2izafNNc46zj/OQ87WztjO+c71zlfPVc8K0AvQY8Vnxb/AwMBFwkPCysHJwQDDBsOswrLC1sPXw4DDf8PSxNPE3MPew4TMgsyW05PTv9PB003UUtRn1GnU89Tz1AvVC9Wf1Z3Vo9Wc1X/WedaA04HTIcsny83J0cnzyvfK2MrcyrvLwcuzy7rLl8yezH/Mh8yCzYzN0s3YzRbXGNc32zLbG9oS2mrbYNvk2uHaA9wF3HXbeNvR3NLcxNvD21jeWN4t1y3XXtFY0erT5NMF0wDTb9Rr1APUAtQ21TrV0NTX1DLWPNYw1TXVvdm92dXg1ODJ4Mrgo+Gk4YThheE84j7iKuIv4ubi6eK74r3iy+PM4xbiE+JA3DnckNuL2wXcBdxz3Hfc29zf3EndS9263bjdIt4f3o/ekd423zjfKeQn5PXn9Oef56XnTOhQ6GDoYOjo6OnoB+kN6YzpkOml6aPpSepB6hLoCuiO44vjyOTF5LPksOSG5YjlkeWY5VrmWuZv5mfmQOc65y/nK+dz6HDoK+4k7jzuNe6l7qHu6+7p7kTvQ++P74/v6+/q7y/wMfCU8JnwyPDM8ErxSPFa8VfxGPIY8onwiPDE7cTt3+7j7uru7O6a75fv2e/X72PwZ/C38L3wNPEz8Z3xmvEE8gfye/KA8s/y0PJs823zdvN48471j/Vz93D3h/eC9wf4BPg6+Dj4n/ig+OX45vg++T35kfmR+dz53fk8+jn6f/p7+uX65voa+yH7i/uT+2/7cvv8+v76RvtJ+9X71fsg/CD8rfyx/PX8/PyD/Yn90P3X/Vj+YP6r/rP+Lv80/4r/jv8AAP//'

For $i = 0 To 132
	_makeAsset($assets[$i][0],$assets[$i][1])
Next

#endregion

#region playarea
Global $playarea[22][32] = _
		[[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1], _
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1], _
		[1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1], _
		[1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1], _
		[1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1], _
		[1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1], _
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1], _
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1], _
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1], _
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1], _
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1], _
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1], _
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1], _
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1], _
		[1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1], _
		[1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1], _
		[1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1], _
		[1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1], _
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1], _
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1], _
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1], _
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]]
Global $playareaBlank = $playarea
#endregion playarea

#region sound
Local $soundDir = $assetsDir & "\"
Local $soundEgg = _SoundOpen($soundDir & "egg.wav")
If @error = 2 Then
	MsgBox(0, "Error", "The egg sound file does not exist")
	Exit
ElseIf @extended <> 0 Then
	Local $iExtended = @extended ; Assign because @extended will be set after DllCall.
	Local $tText = DllStructCreate("char[128]")
	DllCall("winmm.dll", "short", "mciGetErrorStringA", "str", $iExtended, "ptr", DllStructGetPtr($tText), "int", 128)
	MsgBox(0, "Error", "The open failed." & @CRLF & "Error Number: " & $iExtended & @CRLF & "Error Description: " & DllStructGetData($tText, 1) & @CRLF & "Please Note: The sound may still play correctly.")
EndIf
Local $soundDie = _SoundOpen($soundDir & "Die.wav")
If @error = 2 Then
	MsgBox(0, "Error", "The egg sound file does not exist")
	Exit
ElseIf @extended <> 0 Then
	Local $iExtended = @extended ; Assign because @extended will be set after DllCall.
	Local $tText = DllStructCreate("char[128]")
	DllCall("winmm.dll", "short", "mciGetErrorStringA", "str", $iExtended, "ptr", DllStructGetPtr($tText), "int", 128)
	MsgBox(0, "Error", "The open failed." & @CRLF & "Error Number: " & $iExtended & @CRLF & "Error Description: " & DllStructGetData($tText, 1) & @CRLF & "Please Note: The sound may still play correctly.")
EndIf
Local $soundEatSnake = _SoundOpen($soundDir & "EatSnake.wav")
If @error = 2 Then
	MsgBox(0, "Error", "The egg sound file does not exist")
	Exit
ElseIf @extended <> 0 Then
	Local $iExtended = @extended ; Assign because @extended will be set after DllCall.
	Local $tText = DllStructCreate("char[128]")
	DllCall("winmm.dll", "short", "mciGetErrorStringA", "str", $iExtended, "ptr", DllStructGetPtr($tText), "int", 128)
	MsgBox(0, "Error", "The open failed." & @CRLF & "Error Number: " & $iExtended & @CRLF & "Error Description: " & DllStructGetData($tText, 1) & @CRLF & "Please Note: The sound may still play correctly.")
EndIf
#endregion sound

#region intro
Global $sizeMulitplier = 3
Local $formIntro = GUICreate("Snake Pit", 354, 274, 192, 124)
Local $editDescription = GUICtrlCreateEdit("", 8, 8, 337, 177, BitOR($ES_READONLY, $ES_WANTRETURN))
GUICtrlSetData(-1, StringFormat("Snake Pit was released in 1983 as a game of the ZX Spectrum 48k.\r\n\r\nSnake Pit was originally written by Mike Singleton for Postern. To the \r\nbest of my knowledge, this game is abandonware. Neither the author \r\nor the publisher are contactable and as such I consider this an orphan \r\nwork. If any party responsible for the original title has any objection to \r\nthis reproduction then please contact me on \r\ncopyright@elliskingdom.co.uk. \r\n\r\nOriginal description from cassette inlay:\r\nSee if you can gobble up the snakes as they writhe around the screen \r\n- before they have a chance to eat you. Superb graphics on a totally \r\naddictive game."))
Local $buttonStart = GUICtrlCreateButton("Start", 8, 232, 337, 33)
Local $ComboSize = GUICtrlCreateCombo("", 136, 200, 185, 19, $CBS_DROPDOWNLIST)
GUICtrlSetData(-1, "1x (Original Spectrum Resolution|2x|3x (Default)|4x|5x")
_GUICtrlComboBox_SetCurSel($ComboSize, 2)
Local $labelSize = GUICtrlCreateLabel("Game size multiplier:", 32, 202, 99, 17)
GUISetOnEvent($GUI_EVENT_CLOSE, "_quit")
GUICtrlSetOnEvent($buttonStart, "_exitIntro")
GUISetState(@SW_SHOW)
Local $introPassed = False
While $introPassed = False
	Sleep(100)
WEnd
#endregion intro

#region setup
Global $snake0xpos[30]
Global $snake1xpos[30]
Global $snake2xpos[30]
Global $snake3xpos[30]
Global $snake4xpos[30]
Global $snake5xpos[30]
Global $snake6xpos[30]
Global $snake0ypos[30]
Global $snake1ypos[30]
Global $snake2ypos[30]
Global $snake3ypos[30]
Global $snake4ypos[30]
Global $snake5ypos[30]
Global $snake6ypos[30]
Global $snakeAlive[7] = [True, True, True, True, True, True, True]
Global $snakeDirection[7][30] = [[2, 2],[2, 2],[2, 2],[2, 2],[2, 2],[2, 2],[2, 2]]
Global $screen[22][32]
Global $gfxFolder = $assetsDir & "\"
Global $playerFrame = 0
Global $playerAlive = True
Global $snakeEatingEnabled = False
Global $olddirection = "stopped"
Global $direction = "stopped"
Global $tickpause = 70
Global $hWidth = 32 * 8 * $sizeMulitplier
Global $hHeight = 22 * 8 * $sizeMulitplier
Global $gridSquareSize = 8 * $sizeMulitplier
Global $dll = DllOpen("user32.dll")
Global $playerX = 25
Global $playerY = 14
Global $score = 0
Global $move = 0
Global $scalebugworkaround = 0
Switch $sizeMulitplier
	Case 1
		$scalebugworkaround = 0
	Case 2
		$scalebugworkaround = 1
	Case 3
		$scalebugworkaround = 1
	Case 4
		$scalebugworkaround = 2
	Case 5
		$scalebugworkaround = 2
EndSwitch
HotKeySet("{LEFT}", "_left")
HotKeySet("{RIGHT}", "_right")
HotKeySet("{UP}", "_up")
HotKeySet("{DOWN}", "_down")
HotKeySet("s", "_start")
HotKeySet("{ESC}", "_quit")

Global $hWnd = GUICreate("Snake Pit", $hWidth, $hHeight) ;, -1, -1, $WS_BORDER)
GUISetOnEvent($GUI_EVENT_CLOSE, "_quit")
GUISetState()

_GDIPlus_Startup()
;blue red magenta green cyan yellow white
Global $hEgg = _GDIPlus_ScaleImage($gfxFolder & "Egg.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
Global $hPlayer0 = _GDIPlus_ScaleImage($gfxFolder & "Player0.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
Global $hPlayer1 = _GDIPlus_ScaleImage($gfxFolder & "Player1.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
Global $hBlank = _GDIPlus_ScaleImage($gfxFolder & "Blank.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
Global $hSnakeHeadD[7]
$hSnakeHeadD[0] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Head-D-Blue.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeHeadD[1] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Head-D-Red.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeHeadD[2] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Head-D-Magenta.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeHeadD[3] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Head-D-Green.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeHeadD[4] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Head-D-Cyan.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeHeadD[5] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Head-D-Yellow.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeHeadD[6] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Head-D-White.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
Global $hSnakeHeadU[7]
$hSnakeHeadU[0] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Head-U-Blue.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeHeadU[1] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Head-U-Red.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeHeadU[2] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Head-U-Magenta.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeHeadU[3] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Head-U-Green.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeHeadU[4] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Head-U-Cyan.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeHeadU[5] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Head-U-Yellow.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeHeadU[6] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Head-U-White.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
Global $hSnakeHeadL[7]
$hSnakeHeadL[0] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Head-L-Blue.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeHeadL[1] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Head-L-Red.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeHeadL[2] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Head-L-Magenta.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeHeadL[3] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Head-L-Green.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeHeadL[4] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Head-L-Cyan.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeHeadL[5] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Head-L-Yellow.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeHeadL[6] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Head-L-White.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
Global $hSnakeHeadR[7]
$hSnakeHeadR[0] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Head-R-Blue.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeHeadR[1] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Head-R-Red.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeHeadR[2] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Head-R-Magenta.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeHeadR[3] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Head-R-Green.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeHeadR[4] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Head-R-Cyan.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeHeadR[5] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Head-R-Yellow.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeHeadR[6] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Head-R-White.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
Global $hSnakeLR[7]
$hSnakeLR[0] = _GDIPlus_ScaleImage($gfxFolder & "Snake-LR-Blue.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeLR[1] = _GDIPlus_ScaleImage($gfxFolder & "Snake-LR-Red.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeLR[2] = _GDIPlus_ScaleImage($gfxFolder & "Snake-LR-Magenta.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeLR[3] = _GDIPlus_ScaleImage($gfxFolder & "Snake-LR-Green.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeLR[4] = _GDIPlus_ScaleImage($gfxFolder & "Snake-LR-Cyan.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeLR[5] = _GDIPlus_ScaleImage($gfxFolder & "Snake-LR-Yellow.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeLR[6] = _GDIPlus_ScaleImage($gfxFolder & "Snake-LR-White.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
Global $hSnakeUD[7]
$hSnakeUD[0] = _GDIPlus_ScaleImage($gfxFolder & "Snake-UD-Blue.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeUD[1] = _GDIPlus_ScaleImage($gfxFolder & "Snake-UD-Red.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeUD[2] = _GDIPlus_ScaleImage($gfxFolder & "Snake-UD-Magenta.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeUD[3] = _GDIPlus_ScaleImage($gfxFolder & "Snake-UD-Green.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeUD[4] = _GDIPlus_ScaleImage($gfxFolder & "Snake-UD-Cyan.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeUD[5] = _GDIPlus_ScaleImage($gfxFolder & "Snake-UD-Yellow.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeUD[6] = _GDIPlus_ScaleImage($gfxFolder & "Snake-UD-White.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
Global $hSnakeCornerLD[7]
$hSnakeCornerLD[0] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Corner-LD-Blue.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeCornerLD[1] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Corner-LD-Red.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeCornerLD[2] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Corner-LD-Magenta.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeCornerLD[3] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Corner-LD-Green.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeCornerLD[4] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Corner-LD-Cyan.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeCornerLD[5] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Corner-LD-Yellow.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeCornerLD[6] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Corner-LD-White.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
Global $hSnakeCornerLU[7]
$hSnakeCornerLU[0] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Corner-LU-Blue.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeCornerLU[1] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Corner-LU-Red.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeCornerLU[2] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Corner-LU-Magenta.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeCornerLU[3] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Corner-LU-Green.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeCornerLU[4] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Corner-LU-Cyan.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeCornerLU[5] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Corner-LU-Yellow.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeCornerLU[6] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Corner-LU-White.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
Global $hSnakeCornerRD[7]
$hSnakeCornerRD[0] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Corner-RD-Blue.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeCornerRD[1] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Corner-RD-Red.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeCornerRD[2] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Corner-RD-Magenta.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeCornerRD[3] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Corner-RD-Green.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeCornerRD[4] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Corner-RD-Cyan.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeCornerRD[5] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Corner-RD-Yellow.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeCornerRD[6] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Corner-RD-White.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
Global $hSnakeCornerRU[7]
$hSnakeCornerRU[0] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Corner-RU-Blue.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeCornerRU[1] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Corner-RU-Red.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeCornerRU[2] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Corner-RU-Magenta.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeCornerRU[3] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Corner-RU-Green.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeCornerRU[4] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Corner-RU-Cyan.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeCornerRU[5] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Corner-RU-Yellow.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeCornerRU[6] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Corner-RU-White.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
Global $hSnakeTailD[7]
$hSnakeTailD[0] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Tail-D-Blue.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeTailD[1] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Tail-D-Red.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeTailD[2] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Tail-D-Magenta.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeTailD[3] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Tail-D-Green.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeTailD[4] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Tail-D-Cyan.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeTailD[5] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Tail-D-Yellow.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeTailD[6] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Tail-D-White.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
Global $hSnakeTailU[7]
$hSnakeTailU[0] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Tail-U-Blue.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeTailU[1] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Tail-U-Red.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeTailU[2] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Tail-U-Magenta.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeTailU[3] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Tail-U-Green.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeTailU[4] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Tail-U-Cyan.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeTailU[5] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Tail-U-Yellow.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeTailU[6] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Tail-U-White.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
Global $hSnakeTailL[7]
$hSnakeTailL[0] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Tail-L-Blue.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeTailL[1] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Tail-L-Red.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeTailL[2] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Tail-L-Magenta.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeTailL[3] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Tail-L-Green.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeTailL[4] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Tail-L-Cyan.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeTailL[5] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Tail-L-Yellow.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeTailL[6] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Tail-L-White.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
Global $hSnakeTailR[7]
$hSnakeTailR[0] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Tail-R-Blue.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeTailR[1] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Tail-R-Red.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeTailR[2] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Tail-R-Magenta.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeTailR[3] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Tail-R-Green.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeTailR[4] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Tail-R-Cyan.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeTailR[5] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Tail-R-Yellow.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeTailR[6] = _GDIPlus_ScaleImage($gfxFolder & "Snake-Tail-R-White.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
Global $hSnakeUTurnD[7]
$hSnakeUTurnD[0] = _GDIPlus_ScaleImage($gfxFolder & "Snake-UTurn-D-Blue.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeUTurnD[1] = _GDIPlus_ScaleImage($gfxFolder & "Snake-UTurn-D-Red.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeUTurnD[2] = _GDIPlus_ScaleImage($gfxFolder & "Snake-UTurn-D-Magenta.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeUTurnD[3] = _GDIPlus_ScaleImage($gfxFolder & "Snake-UTurn-D-Green.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeUTurnD[4] = _GDIPlus_ScaleImage($gfxFolder & "Snake-UTurn-D-Cyan.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeUTurnD[5] = _GDIPlus_ScaleImage($gfxFolder & "Snake-UTurn-D-Yellow.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeUTurnD[6] = _GDIPlus_ScaleImage($gfxFolder & "Snake-UTurn-D-White.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
Global $hSnakeUTurnU[7]
$hSnakeUTurnU[0] = _GDIPlus_ScaleImage($gfxFolder & "Snake-UTurn-U-Blue.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeUTurnU[1] = _GDIPlus_ScaleImage($gfxFolder & "Snake-UTurn-U-Red.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeUTurnU[2] = _GDIPlus_ScaleImage($gfxFolder & "Snake-UTurn-U-Magenta.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeUTurnU[3] = _GDIPlus_ScaleImage($gfxFolder & "Snake-UTurn-U-Green.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeUTurnU[4] = _GDIPlus_ScaleImage($gfxFolder & "Snake-UTurn-U-Cyan.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeUTurnU[5] = _GDIPlus_ScaleImage($gfxFolder & "Snake-UTurn-U-Yellow.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeUTurnU[6] = _GDIPlus_ScaleImage($gfxFolder & "Snake-UTurn-U-White.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
Global $hSnakeUTurnL[7]
$hSnakeUTurnL[0] = _GDIPlus_ScaleImage($gfxFolder & "Snake-UTurn-L-Blue.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeUTurnL[1] = _GDIPlus_ScaleImage($gfxFolder & "Snake-UTurn-L-Red.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeUTurnL[2] = _GDIPlus_ScaleImage($gfxFolder & "Snake-UTurn-L-Magenta.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeUTurnL[3] = _GDIPlus_ScaleImage($gfxFolder & "Snake-UTurn-L-Green.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeUTurnL[4] = _GDIPlus_ScaleImage($gfxFolder & "Snake-UTurn-L-Cyan.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeUTurnL[5] = _GDIPlus_ScaleImage($gfxFolder & "Snake-UTurn-L-Yellow.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeUTurnL[6] = _GDIPlus_ScaleImage($gfxFolder & "Snake-UTurn-L-White.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
Global $hSnakeUTurnR[7]
$hSnakeUTurnR[0] = _GDIPlus_ScaleImage($gfxFolder & "Snake-UTurn-R-Blue.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeUTurnR[1] = _GDIPlus_ScaleImage($gfxFolder & "Snake-UTurn-R-Red.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeUTurnR[2] = _GDIPlus_ScaleImage($gfxFolder & "Snake-UTurn-R-Magenta.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeUTurnR[3] = _GDIPlus_ScaleImage($gfxFolder & "Snake-UTurn-R-Green.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeUTurnR[4] = _GDIPlus_ScaleImage($gfxFolder & "Snake-UTurn-R-Cyan.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeUTurnR[5] = _GDIPlus_ScaleImage($gfxFolder & "Snake-UTurn-R-Yellow.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)
$hSnakeUTurnR[6] = _GDIPlus_ScaleImage($gfxFolder & "Snake-UTurn-R-White.gif", 8 * $sizeMulitplier + $scalebugworkaround, 8 * $sizeMulitplier + $scalebugworkaround, 5)

Global $hGraphic = _GDIPlus_GraphicsCreateFromHWND($hWnd)
GUISetState($hWnd)
Local $setuptimer = TimerInit()
_resetPlayArea()
ConsoleWrite(@CRLF & "Setup time = " & TimerDiff($setuptimer) & @CRLF)
#endregion setup

While 1
	Sleep($tickpause)
	$move = $move + 1
	$direction = GetDirection($direction)
	If $playerAlive Then _resetHotKeys()
	_movePlayer($direction)
	For $i = 0 To 6 ;0 to 6
		If $snakeAlive[$i] Then _moveSnake($i)
	Next
	If $move = 1 Then _move1Tail()
	_drawPlayer()
	Local $eggs = _countEggs()
WEnd

Func _exitIntro()
	$sizeMulitplier = _GUICtrlComboBox_GetCurSel($ComboSize) + 1
	GUIDelete($formIntro)
	Sleep(20)
	$introPassed = True
EndFunc   ;==>_exitIntro

Func _movePlayer($direction)
	_blankGridSquare($playerY, $playerX)
	Local $newPlayerX = $playerX
	Local $newPlayerY = $playerY
	Switch $direction()
		Case "left"
			If $playerX > 0 Then $newPlayerX = $playerX - 1
		Case "right"
			If $playerX < 31 Then $newPlayerX = $playerX + 1
		Case "up"
			If $playerY > 0 Then $newPlayerY = $playerY - 1
		Case "down"
			If $playerY < 21 Then $newPlayerY = $playerY + 1
	EndSwitch
	If $direction <> "stopped" Then
		Local $targetContentType = $playarea[$newPlayerY][$newPlayerX]
		If $targetContentType < 2 Then
			$playerX = $newPlayerX
			$playerY = $newPlayerY
		EndIf
		If $targetContentType = 1 Then
			_SoundPlay($soundEgg, 0)
			$playarea[$playerY][$playerX] = 0
			_score(10)
		EndIf
		If $targetContentType >= 20 Then
			If $targetContentType <= 26 Then
				_gameOver()
			EndIf
		EndIf
		If $snakeEatingEnabled = True Then
			If $targetContentType >= 30 Then
				If $targetContentType <= 36 Then
					Local $snake = $targetContentType - 30
					_EatSnake($snake)
				EndIf
			EndIf
		EndIf
	EndIf
EndFunc   ;==>_movePlayer

Func _drawPlayer()
	If $playerAlive = True Then
		If $playerFrame = 0 Then
			_drawGridSquare($playerY, $playerX, $hPlayer0)
			$playerFrame = 1
		Else
			_drawGridSquare($playerY, $playerX, $hPlayer1)
			$playerFrame = 0
		EndIf
	EndIf
EndFunc   ;==>_drawPlayer

Func _moveSnake($snake)
	Local $headx
	Local $heady
	Local $lastdir = $snakeDirection[$snake][0]
	Local $dir = "none"
	Local $canEatEgg = 0
	Switch $snake
		Case 0
			$heady = $snake0ypos[0]
			$headx = $snake0xpos[0]
		Case 1
			$heady = $snake1ypos[0]
			$headx = $snake1xpos[0]
			$canEatEgg = 1
		Case 2
			$heady = $snake2ypos[0]
			$headx = $snake2xpos[0]
		Case 3
			$heady = $snake3ypos[0]
			$headx = $snake3xpos[0]
		Case 4
			$heady = $snake4ypos[0]
			$headx = $snake4xpos[0]
		Case 5
			$heady = $snake5ypos[0]
			$headx = $snake5xpos[0]
		Case 6
			$heady = $snake6ypos[0]
			$headx = $snake6xpos[0]
	EndSwitch
	Local $directioncontents = _getDirectionContents($headx, $heady)
	Local $rand = Random(1, 10, 1)
	If $rand <= 7 Then
		If $directioncontents[$lastdir][1] <= $canEatEgg Then
			$dir = $lastdir
		EndIf
		If $directioncontents[$lastdir][1] = $snake + 10 Then
			$dir = $lastdir
		EndIf
		If $directioncontents[$lastdir][1] = $snake + 20 Then
			$dir = $lastdir
		EndIf
		If $directioncontents[$lastdir][1] = $snake + 30 Then
			$dir = $lastdir
		EndIf
	EndIf
	If $dir = "none" Then
		Local $uturn
		Switch $lastdir
			Case 1
				$uturn = 2
			Case 2
				$uturn = 1
			Case 3
				$uturn = 4
			Case 4
				$uturn = 3
		EndSwitch
		$directioncontents[$uturn][1] = 100
		_ArrayRandom($directioncontents)
		For $i = 0 To 5
			If $directioncontents[$i][1] <= $canEatEgg Then
				$dir = $directioncontents[$i][0]
				ExitLoop
			EndIf
			If $directioncontents[$i][1] = $snake + 30 Then
				$dir = $directioncontents[$i][0]
				ExitLoop
			EndIf
			If $directioncontents[$i][1] = $snake + 10 Then
				$dir = $directioncontents[$i][0]
				ExitLoop
			EndIf
		Next
		If $dir = "none" Then $dir = $uturn
	EndIf
	If $move = 1 Then $dir = 2
	For $i = 29 To 1 Step -1
		$snakeDirection[$snake][$i] = $snakeDirection[$snake][$i - 1]
	Next
	$snakeDirection[$snake][0] = $dir
	Switch $dir
		Case 1
			_UpdateSnakePos($snake, $headx, $heady - 1)
		Case 2
			_UpdateSnakePos($snake, $headx, $heady + 1)
		Case 3
			_UpdateSnakePos($snake, $headx - 1, $heady)
		Case 4
			_UpdateSnakePos($snake, $headx + 1, $heady)
	EndSwitch
EndFunc   ;==>_moveSnake

Func _UpdateSnakePos($snake, $x, $y)
	Switch $snake
		Case 0
			$playarea[$snake0ypos[29]][$snake0xpos[29]] = 0
			$playarea[$snake0ypos[0]][$snake0xpos[0]] = 10 + $snake
			If $move > 29 Then _drawGridSquare($snake0ypos[29], $snake0xpos[29], $hBlank)
			_ArrayPush($snake0xpos, $x, 1)
			_ArrayPush($snake0ypos, $y, 1)
			$playarea[$snake0ypos[29]][$snake0xpos[29]] = 30 + $snake
			$playarea[$snake0ypos[0]][$snake0xpos[0]] = 20 + $snake
			$playarea[$snake0ypos[1]][$snake0xpos[1]] = 10
		Case 1
			$playarea[$snake1ypos[29]][$snake1xpos[29]] = 0
			$playarea[$snake1ypos[0]][$snake1xpos[0]] = 10 + $snake
			If $move > 29 Then _drawGridSquare($snake1ypos[29], $snake1xpos[29], $hBlank)
			_ArrayPush($snake1xpos, $x, 1)
			_ArrayPush($snake1ypos, $y, 1)
			$playarea[$snake1ypos[29]][$snake1xpos[29]] = 30 + $snake
			$playarea[$snake1ypos[0]][$snake1xpos[0]] = 20 + $snake
			$playarea[$snake1ypos[1]][$snake1xpos[1]] = 11
		Case 2
			$playarea[$snake2ypos[29]][$snake2xpos[29]] = 0
			If $move > 29 Then _drawGridSquare($snake2ypos[29], $snake2xpos[29], $hBlank)
			_ArrayPush($snake2xpos, $x, 1)
			_ArrayPush($snake2ypos, $y, 1)
			$playarea[$snake2ypos[29]][$snake2xpos[29]] = 30 + $snake
			$playarea[$snake2ypos[0]][$snake2xpos[0]] = 20 + $snake
			$playarea[$snake2ypos[1]][$snake2xpos[1]] = 12
		Case 3
			$playarea[$snake3ypos[29]][$snake3xpos[29]] = 0
			$playarea[$snake3ypos[0]][$snake3xpos[0]] = 10 + $snake
			If $move > 29 Then _drawGridSquare($snake3ypos[29], $snake3xpos[29], $hBlank)
			_ArrayPush($snake3xpos, $x, 1)
			_ArrayPush($snake3ypos, $y, 1)
			$playarea[$snake3ypos[29]][$snake3xpos[29]] = 30 + $snake
			$playarea[$snake3ypos[0]][$snake3xpos[0]] = 20 + $snake
			$playarea[$snake3ypos[1]][$snake3xpos[1]] = 13
		Case 4
			$playarea[$snake4ypos[29]][$snake4xpos[29]] = 0
			$playarea[$snake4ypos[0]][$snake4xpos[0]] = 10 + $snake
			If $move > 29 Then _drawGridSquare($snake4ypos[29], $snake4xpos[29], $hBlank)
			_ArrayPush($snake4xpos, $x, 1)
			_ArrayPush($snake4ypos, $y, 1)
			$playarea[$snake4ypos[29]][$snake4xpos[29]] = 30 + $snake
			$playarea[$snake4ypos[0]][$snake4xpos[0]] = 20 + $snake
			$playarea[$snake4ypos[1]][$snake4xpos[1]] = 14
		Case 5
			$playarea[$snake5ypos[29]][$snake5xpos[29]] = 0
			$playarea[$snake5ypos[0]][$snake5xpos[0]] = 10 + $snake
			If $move > 29 Then _drawGridSquare($snake5ypos[29], $snake5xpos[29], $hBlank)
			_ArrayPush($snake5xpos, $x, 1)
			_ArrayPush($snake5ypos, $y, 1)
			$playarea[$snake5ypos[29]][$snake5xpos[29]] = 30 + $snake
			$playarea[$snake5ypos[0]][$snake5xpos[0]] = 20 + $snake
			$playarea[$snake5ypos[1]][$snake5xpos[1]] = 15
		Case 6
			$playarea[$snake6ypos[29]][$snake6xpos[29]] = 0
			$playarea[$snake6ypos[0]][$snake6xpos[0]] = 10 + $snake
			If $move > 29 Then _drawGridSquare($snake6ypos[29], $snake6xpos[29], $hBlank)
			_ArrayPush($snake6xpos, $x, 1)
			_ArrayPush($snake6ypos, $y, 1)
			$playarea[$snake6ypos[29]][$snake6xpos[29]] = 30 + $snake
			$playarea[$snake6ypos[0]][$snake6xpos[0]] = 20 + $snake
			$playarea[$snake6ypos[1]][$snake6xpos[1]] = 16
	EndSwitch
	_drawSnake($snake)
	If $y = $playerY Then
		If $x = $playerX Then
			_gameOver()
		EndIf
	EndIf
EndFunc   ;==>_UpdateSnakePos

Func _drawSnake($snake)
	Local $snakexpos
	Local $snakeypos
	Switch $snake
		Case 0
			$snakexpos = $snake0xpos
			$snakeypos = $snake0ypos
		Case 1
			$snakexpos = $snake1xpos
			$snakeypos = $snake1ypos
		Case 2
			$snakexpos = $snake2xpos
			$snakeypos = $snake2ypos
		Case 3
			$snakexpos = $snake3xpos
			$snakeypos = $snake3ypos
		Case 4
			$snakexpos = $snake4xpos
			$snakeypos = $snake4ypos
		Case 5
			$snakexpos = $snake5xpos
			$snakeypos = $snake5ypos
		Case 6
			$snakexpos = $snake6xpos
			$snakeypos = $snake6ypos
	EndSwitch
	Local $headx = $snakexpos[0]
	Local $heady = $snakeypos[0]
	Local $midx = $snakexpos[1]
	Local $midy = $snakeypos[1]

	Local $tail2x = $snakexpos[28]
	Local $tail2y = $snakeypos[28]
	Local $tail1x = $snakexpos[29]
	Local $tail1y = $snakeypos[29]
	;draw tail end
	If $tail1x < $tail2x Then
		_drawGridSquare($tail1y, $tail1x, $hSnakeTailL[$snake])
	ElseIf $tail1x > $tail2x Then
		_drawGridSquare($tail1y, $tail1x, $hSnakeTailR[$snake])
	ElseIf $tail1y < $tail2y Then
		_drawGridSquare($tail1y, $tail1x, $hSnakeTailU[$snake])
	ElseIf $tail1y > $tail2y Then
		_drawGridSquare($tail1y, $tail1x, $hSnakeTailD[$snake])
	EndIf
	;draw head
	Switch $snakeDirection[$snake][0]
		Case 1
			_drawGridSquare($heady, $headx, $hSnakeHeadU[$snake])
		Case 2
			_drawGridSquare($heady, $headx, $hSnakeHeadD[$snake])
		Case 3
			_drawGridSquare($heady, $headx, $hSnakeHeadL[$snake])
		Case 4
			_drawGridSquare($heady, $headx, $hSnakeHeadR[$snake])
	EndSwitch
	;draw segment after head
	Switch $snakeDirection[$snake][1]
		Case 1 ;up
			Switch $snakeDirection[$snake][0]
				Case 1 ;up up
					_drawGridSquare($midy, $midx, $hSnakeUD[$snake])
				Case 2 ;up down
					_drawGridSquare($midy, $midx, $hSnakeUTurnD[$snake])
				Case 3 ;up left
					_drawGridSquare($midy, $midx, $hSnakeCornerLD[$snake])
				Case 4 ;up right
					_drawGridSquare($midy, $midx, $hSnakeCornerRD[$snake])
			EndSwitch
		Case 2 ;down
			Switch $snakeDirection[$snake][0]
				Case 1 ;down up
					_drawGridSquare($midy, $midx, $hSnakeUTurnU[$snake])
				Case 2 ;down down
					_drawGridSquare($midy, $midx, $hSnakeUD[$snake])
				Case 3 ;down left
					_drawGridSquare($midy, $midx, $hSnakeCornerLU[$snake])
				Case 4 ;down right
					_drawGridSquare($midy, $midx, $hSnakeCornerRU[$snake])
			EndSwitch
		Case 3 ;left
			Switch $snakeDirection[$snake][0]
				Case 1 ;left up
					_drawGridSquare($midy, $midx, $hSnakeCornerRU[$snake])
				Case 2 ;left down
					_drawGridSquare($midy, $midx, $hSnakeCornerRD[$snake])
				Case 3 ;left left
					_drawGridSquare($midy, $midx, $hSnakeLR[$snake])
				Case 4 ;left right
					_drawGridSquare($midy, $midx, $hSnakeUTurnR[$snake])
			EndSwitch
		Case 4 ;right
			Switch $snakeDirection[$snake][0]
				Case 1 ;right up
					_drawGridSquare($midy, $midx, $hSnakeCornerLU[$snake])
				Case 2 ;right down
					_drawGridSquare($midy, $midx, $hSnakeCornerLD[$snake])
				Case 3 ;right left
					_drawGridSquare($midy, $midx, $hSnakeUTurnL[$snake])
				Case 4 ;right right
					_drawGridSquare($midy, $midx, $hSnakeLR[$snake])
			EndSwitch
	EndSwitch
	;sort out crossovers
	For $i = 28 To 2 Step -1
		If $playarea[$snakeypos[$i]][$snakexpos[$i]] = 0 Then
			Switch $snakeDirection[$snake][$i]
				Case 1 ;up
					Switch $snakeDirection[$snake][$i - 1]
						Case 1 ;up up
							_drawGridSquare($snakeypos[$i], $snakexpos[$i], $hSnakeUD[$snake])
						Case 2 ;up down
							_drawGridSquare($snakeypos[$i], $snakexpos[$i], $hSnakeUTurnD[$snake])
						Case 3 ;up left
							_drawGridSquare($snakeypos[$i], $snakexpos[$i], $hSnakeCornerLD[$snake])
						Case 4 ;up right
							_drawGridSquare($snakeypos[$i], $snakexpos[$i], $hSnakeCornerRD[$snake])
					EndSwitch
				Case 2 ;down
					Switch $snakeDirection[$snake][$i - 1]
						Case 1 ;down up
							_drawGridSquare($snakeypos[$i], $snakexpos[$i], $hSnakeUTurnU[$snake])
						Case 2 ;down down
							_drawGridSquare($snakeypos[$i], $snakexpos[$i], $hSnakeUD[$snake])
						Case 3 ;down left
							_drawGridSquare($snakeypos[$i], $snakexpos[$i], $hSnakeCornerLU[$snake])
						Case 4 ;down right
							_drawGridSquare($snakeypos[$i], $snakexpos[$i], $hSnakeCornerRU[$snake])
					EndSwitch
				Case 3 ;left
					Switch $snakeDirection[$snake][$i - 1]
						Case 1 ;left up
							_drawGridSquare($snakeypos[$i], $snakexpos[$i], $hSnakeCornerRU[$snake])
						Case 2 ;left down
							_drawGridSquare($snakeypos[$i], $snakexpos[$i], $hSnakeCornerRD[$snake])
						Case 3 ;left left
							_drawGridSquare($snakeypos[$i], $snakexpos[$i], $hSnakeLR[$snake])
						Case 4 ;left right
							_drawGridSquare($snakeypos[$i], $snakexpos[$i], $hSnakeUTurnR[$snake])
					EndSwitch
				Case 4 ;right
					Switch $snakeDirection[$snake][$i - 1]
						Case 1 ;right up
							_drawGridSquare($snakeypos[$i], $snakexpos[$i], $hSnakeCornerLU[$snake])
						Case 2 ;right down
							_drawGridSquare($snakeypos[$i], $snakexpos[$i], $hSnakeCornerLD[$snake])
						Case 3 ;right left
							_drawGridSquare($snakeypos[$i], $snakexpos[$i], $hSnakeUTurnL[$snake])
						Case 4 ;right right
							_drawGridSquare($snakeypos[$i], $snakexpos[$i], $hSnakeLR[$snake])
					EndSwitch
			EndSwitch
			$playarea[$snakeypos[$i]][$snakexpos[$i]] = $snake + 10
		EndIf
	Next
EndFunc   ;==>_drawSnake

Func _move1Tail()
	_drawGridSquare(2, 4, $hSnakeTailU[0]) ; blue
	_drawGridSquare(2, 11, $hSnakeTailU[1]) ; red
	_drawGridSquare(2, 18, $hSnakeTailU[2]) ; magenta
	_drawGridSquare(2, 25, $hSnakeTailU[3]) ; green
	_drawGridSquare(14, 4, $hSnakeTailU[4]) ; cyan
	_drawGridSquare(14, 11, $hSnakeTailU[5]) ; yellow
	_drawGridSquare(14, 18, $hSnakeTailU[6]) ; white
EndFunc   ;==>_move1Tail

Func _getDirectionContents($x, $y)
	Local $directioncontents[6][2]
	$directioncontents[0][1] = 100
	$directioncontents[1][1] = _getGridcontent($x, $y - 1)
	$directioncontents[2][1] = _getGridcontent($x, $y + 1)
	$directioncontents[3][1] = _getGridcontent($x - 1, $y)
	$directioncontents[4][1] = _getGridcontent($x + 1, $y)
	$directioncontents[5][1] = 100
	For $i = 0 To 5
		$directioncontents[$i][0] = $i
	Next
	Return $directioncontents
EndFunc   ;==>_getDirectionContents

Func _getGridcontent($x, $y)
	If $x < 0 Then Return 100
	If $x > 31 Then Return 100
	If $y < 0 Then Return 100
	If $y > 21 Then Return 100
	Local $content = $playarea[$y][$x]
	Return $content
EndFunc   ;==>_getGridcontent

Func _countEggs()
	Local $eggs = 0
	For $i = 0 To 31
		For $j = 0 To 21
			If $playarea[$j][$i] = 1 Then $eggs = $eggs + 1
		Next
	Next
	If $eggs = 0 Then $snakeEatingEnabled = True
EndFunc   ;==>_countEggs

Func _EatSnake($snake)
	Local $snakexpos
	Local $snakeypos
	Switch $snake
		Case 0
			$snakexpos = $snake0xpos
			$snakeypos = $snake0ypos
		Case 1
			$snakexpos = $snake1xpos
			$snakeypos = $snake1ypos
		Case 2
			$snakexpos = $snake2xpos
			$snakeypos = $snake2ypos
		Case 3
			$snakexpos = $snake3xpos
			$snakeypos = $snake3ypos
		Case 4
			$snakexpos = $snake4xpos
			$snakeypos = $snake4ypos
		Case 5
			$snakexpos = $snake5xpos
			$snakeypos = $snake5ypos
		Case 6
			$snakexpos = $snake6xpos
			$snakeypos = $snake6ypos
	EndSwitch
	For $j = 29 To 0 Step -1
		For $i = $j - 1 To 1 Step -1
			If $playarea[$snakeypos[$i]][$snakexpos[$i]] = 0 Then
				Switch $snakeDirection[$snake][$i]
					Case 1 ;up
						Switch $snakeDirection[$snake][$i - 1]
							Case 1 ;up up
								_drawGridSquare($snakeypos[$i], $snakexpos[$i], $hSnakeUD[$snake])
							Case 2 ;up down
								_drawGridSquare($snakeypos[$i], $snakexpos[$i], $hSnakeUTurnD[$snake])
							Case 3 ;up left
								_drawGridSquare($snakeypos[$i], $snakexpos[$i], $hSnakeCornerLD[$snake])
							Case 4 ;up right
								_drawGridSquare($snakeypos[$i], $snakexpos[$i], $hSnakeCornerRD[$snake])
						EndSwitch
					Case 2 ;down
						Switch $snakeDirection[$snake][$i - 1]
							Case 1 ;down up
								_drawGridSquare($snakeypos[$i], $snakexpos[$i], $hSnakeUTurnU[$snake])
							Case 2 ;down down
								_drawGridSquare($snakeypos[$i], $snakexpos[$i], $hSnakeUD[$snake])
							Case 3 ;down left
								_drawGridSquare($snakeypos[$i], $snakexpos[$i], $hSnakeCornerLU[$snake])
							Case 4 ;down right
								_drawGridSquare($snakeypos[$i], $snakexpos[$i], $hSnakeCornerRU[$snake])
						EndSwitch
					Case 3 ;left
						Switch $snakeDirection[$snake][$i - 1]
							Case 1 ;left up
								_drawGridSquare($snakeypos[$i], $snakexpos[$i], $hSnakeCornerRU[$snake])
							Case 2 ;left down
								_drawGridSquare($snakeypos[$i], $snakexpos[$i], $hSnakeCornerRD[$snake])
							Case 3 ;left left
								_drawGridSquare($snakeypos[$i], $snakexpos[$i], $hSnakeLR[$snake])
							Case 4 ;left right
								_drawGridSquare($snakeypos[$i], $snakexpos[$i], $hSnakeUTurnR[$snake])
						EndSwitch
					Case 4 ;right
						Switch $snakeDirection[$snake][$i - 1]
							Case 1 ;right up
								_drawGridSquare($snakeypos[$i], $snakexpos[$i], $hSnakeCornerLU[$snake])
							Case 2 ;right down
								_drawGridSquare($snakeypos[$i], $snakexpos[$i], $hSnakeCornerLD[$snake])
							Case 3 ;right left
								_drawGridSquare($snakeypos[$i], $snakexpos[$i], $hSnakeUTurnL[$snake])
							Case 4 ;right right
								_drawGridSquare($snakeypos[$i], $snakexpos[$i], $hSnakeLR[$snake])
						EndSwitch
				EndSwitch
			EndIf
		Next
		Switch $snakeDirection[$snake][0]
			Case 1
				_drawGridSquare($snakeypos[0], $snakexpos[0], $hSnakeHeadU[$snake])
			Case 2
				_drawGridSquare($snakeypos[0], $snakexpos[0], $hSnakeHeadD[$snake])
			Case 3
				_drawGridSquare($snakeypos[0], $snakexpos[0], $hSnakeHeadL[$snake])
			Case 4
				_drawGridSquare($snakeypos[0], $snakexpos[0], $hSnakeHeadR[$snake])
		EndSwitch
		_drawGridSquare($playerY, $playerX, $hBlank)
		$playerX = $snakexpos[$j]
		$playerY = $snakeypos[$j]
		_drawPlayer()
		$playarea[$playerY][$playerX] = 0
		_SoundPlay($soundEatSnake, 0)
		_score(10)
		Sleep(20)
	Next
	$snakeAlive[$snake] = False
	Local $snakesEaten = 0
	For $i = 0 To 6
		If $snakeAlive[$i] = False Then $snakesEaten = $snakesEaten + 1
	Next
	If $snakesEaten = 7 Then _levelComplete()
EndFunc   ;==>_EatSnake

Func _levelComplete()
	MsgBox(0, "Area clear", "Press OK to reset and start again.... but faster.")
	$tickpause = $tickpause - 10
	_resetPlayArea()
EndFunc   ;==>_levelComplete

Func _drawGridSquare($x, $y, $image)
	;_WinAPI_RedrawWindow($hWnd, 0, 0, $RDW_UPDATENOW)
	_GDIPlus_GraphicsDrawImage($hGraphic, $image, $y * 8 * $sizeMulitplier, $x * 8 * $sizeMulitplier)
	;_WinAPI_RedrawWindow($hWnd, 0, 0, $RDW_VALIDATE)
EndFunc   ;==>_drawGridSquare

Func _blankGridSquare($x, $y)
	_drawGridSquare($x, $y, $hBlank)
EndFunc   ;==>_blankGridSquare

#region playerInputHandling
Func GetDirection($direction)
	Switch $direction
		Case "left"
			If _IsPressed(25) Then
				Return $direction
			EndIf
		Case "right"
			If _IsPressed(27) Then
				Return $direction
			EndIf
		Case "up"
			If _IsPressed(26) Then
				Return $direction
			EndIf
		Case "down"
			If _IsPressed(28) Then
				Return $direction
			EndIf
	EndSwitch
	Switch $olddirection
		Case "left"
			If _IsPressed(25) Then
				$direction = "left"
				Return "left"
			EndIf
		Case "right"
			If _IsPressed(27) Then
				$direction = "right"
				Return "right"
			EndIf
		Case "up"
			If _IsPressed(26) Then
				$direction = "up"
				Return "up"
			EndIf
		Case "down"
			If _IsPressed(28) Then
				$direction = "down"
				Return "down"
			EndIf
	EndSwitch
	Return "stopped"
EndFunc   ;==>GetDirection

Func _resetHotKeys()
	HotKeySet("{LEFT}", "_left")
	HotKeySet("{RIGHT}", "_right")
	HotKeySet("{UP}", "_up")
	HotKeySet("{DOWN}", "_down")
EndFunc   ;==>_resetHotKeys

Func _left()
	$olddirection = $direction
	$direction = "left"
	HotKeySet("{LEFT}")
	HotKeySet("{RIGHT}", "_right")
	HotKeySet("{UP}", "_up")
	HotKeySet("{DOWN}", "_down")
EndFunc   ;==>_left

Func _right()
	$olddirection = $direction
	$direction = "right"
	HotKeySet("{LEFT}", "_left")
	HotKeySet("{RIGHT}")
	HotKeySet("{UP}", "_up")
	HotKeySet("{DOWN}", "_down")
EndFunc   ;==>_right

Func _up()
	$olddirection = $direction
	$direction = "up"
	HotKeySet("{LEFT}", "_left")
	HotKeySet("{RIGHT}", "_right")
	HotKeySet("{UP}")
	HotKeySet("{DOWN}", "_down")
EndFunc   ;==>_up

Func _down()
	$olddirection = $direction
	$direction = "down"
	HotKeySet("{LEFT}", "_left")
	HotKeySet("{RIGHT}", "_right")
	HotKeySet("{UP}", "_up")
	HotKeySet("{DOWN}")
EndFunc   ;==>_down

Func _start()
	_score(0, 1)
	_resetPlayArea()
EndFunc   ;==>_start
#endregion playerInputHandling

Func _quit()
	Exit
EndFunc   ;==>_quit

Func _gameOver()
	_SoundPlay($soundDie, 0)
	$playerAlive = False
	$playerX = -1
	$playerY = -1
	HotKeySet("{LEFT}")
	HotKeySet("{RIGHT}")
	HotKeySet("{UP}")
	HotKeySet("{DOWN}")
	MsgBox(0, "Game Over", "Your final score was " & $score & @CRLF & "Press S to Start again")
EndFunc   ;==>_gameOver

Func _resetPlayArea()
	$move = 0
	$playerX = 25
	$playerY = 14
	$playerAlive = True
	$playarea = $playareaBlank
	$snakeEatingEnabled = False
	Global $snakeAlive[7] = [True, True, True, True, True, True, True]
	Global $snakeDirection[7][30] = [[2, 2],[2, 2],[2, 2],[2, 2],[2, 2],[2, 2],[2, 2]]
	For $x = 0 To 31
		For $y = 0 To 21
			If $playarea[$y][$x] = 1 Then _drawGridSquare($y, $x, $hEgg)
			If $playarea[$y][$x] = 0 Then _drawGridSquare($y, $x, $hBlank)
		Next
	Next
	For $i = 0 To 29 ; blue
		$snake0ypos[$i] = 2
		$snake0xpos[$i] = 4
	Next
	$playarea[2][4] = 20
	For $i = 0 To 29 ; red
		$snake1ypos[$i] = 2
		$snake1xpos[$i] = 11
	Next
	$playarea[2][11] = 21
	For $i = 0 To 29 ; magenta
		$snake2ypos[$i] = 2
		$snake2xpos[$i] = 18
	Next
	$playarea[2][18] = 22
	For $i = 0 To 29 ; green
		$snake3ypos[$i] = 2
		$snake3xpos[$i] = 25
	Next
	$playarea[2][25] = 23
	For $i = 0 To 29 ; cyan
		$snake4ypos[$i] = 14
		$snake4xpos[$i] = 4
	Next
	$playarea[14][4] = 24
	For $i = 0 To 29 ; yellow
		$snake5ypos[$i] = 14
		$snake5xpos[$i] = 11
	Next
	$playarea[14][11] = 25
	For $i = 0 To 29 ; white
		$snake6ypos[$i] = 14
		$snake6xpos[$i] = 18
	Next
	$playarea[14][18] = 26
	_drawGridSquare(2, 4, $hSnakeHeadD[0]) ; blue
	_drawGridSquare(2, 11, $hSnakeHeadD[1]) ; red
	_drawGridSquare(2, 18, $hSnakeHeadD[2]) ; magenta
	_drawGridSquare(2, 25, $hSnakeHeadD[3]) ; green
	_drawGridSquare(14, 4, $hSnakeHeadD[4]) ; cyan
	_drawGridSquare(14, 11, $hSnakeHeadD[5]) ; yellow
	_drawGridSquare(14, 18, $hSnakeHeadD[6]) ; white
EndFunc   ;==>_resetPlayArea

Func _score($i, $force = 0)
	$score = $score + $i
	If $force = 1 Then $score = $i
	Local $stringUpdate
	If $sizeMulitplier = 1 Then
		$stringUpdate = "Score:" & $score
	Else
		$stringUpdate = "Snake Pit     Score:" & $score
	EndIf
	WinSetTitle("handle=" & $hWnd, "", $stringUpdate)
EndFunc   ;==>_score

Func _makeAsset($filename,$base64string)
	Local $base64data
	$base64data = $base64string
	Local $bString = Binary(_Base64Decode($base64data))
	Local $hFile = FileOpen($assetsDir & $filename, 18)
	FileWrite($hFile,$bString)
	FileClose($hFile)
EndFunc   ;==>_makeAsset

Func _Base64Decode($sB64String)
	Local $struct = DllStructCreate("int")
	Local $a_Call = DllCall("Crypt32.dll", "int", "CryptStringToBinary", "str", $sB64String, "int", 0, "int", 1, "ptr", 0, "ptr", DllStructGetPtr($struct, 1), "ptr", 0, "ptr", 0)
	If @error Or Not $a_Call[0] Then Return SetError(1, 0, "")
	Local $a = DllStructCreate("byte[" & DllStructGetData($struct, 1) & "]")
	$a_Call = DllCall("Crypt32.dll", "int", "CryptStringToBinary", "str", $sB64String, "int", 0, "int", 1, "ptr", DllStructGetPtr($a), "ptr", DllStructGetPtr($struct, 1), "ptr", 0, "ptr", 0)
	If @error Or Not $a_Call[0] Then Return SetError(2, 0, "")
	Return DllStructGetData($a, 1)
EndFunc   ;==>_Base64Decode

Func _GDIPlus_ScaleImage($sFile, $iW, $iH, $iInterpolationMode = 7) ;coded by UEZ 2012
	If Not FileExists($sFile) Then Return SetError(1, 0, 0)
	Local $hImage = _GDIPlus_ImageLoadFromFile($sFile)
	If @error Then Return SetError(2, 0, 0)
	Local $hBitmap = DllCall($ghGDIPDll, "uint", "GdipCreateBitmapFromScan0", "int", $iW, "int", $iH, "int", 0, "int", 0x0026200A, "ptr", 0, "int*", 0)
	If @error Then Return SetError(3, 0, 0)
	$hBitmap = $hBitmap[6]
	Local $hBmpCtxt = _GDIPlus_ImageGetGraphicsContext($hBitmap)
	DllCall($ghGDIPDll, "uint", "GdipSetInterpolationMode", "handle", $hBmpCtxt, "int", $iInterpolationMode)
	_GDIPlus_GraphicsDrawImageRect($hBmpCtxt, $hImage, 0, 0, $iW, $iH)
	_GDIPlus_ImageDispose($hImage)
	_GDIPlus_GraphicsDispose($hBmpCtxt)
	Return $hBitmap
EndFunc   ;==>_GDIPlus_ScaleImage

Func _ArrayRandom(ByRef $avArray, $iStart = 0, $iEnd = 0) ; by Tom Vernooij, Based on Yashied's method
	If Not IsArray($avArray) Then Return SetError(1, 0, 0)
	Local $iRow, $iCol, $rRow, $Temp, $numCols = UBound($avArray, 2), $Ubound = UBound($avArray) - 1
	; Bounds checking
	If $iEnd < 1 Or $iEnd > $Ubound Then $iEnd = $Ubound
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(2, 0, 0)
	;	for 2 dimentional arrays:
	If $numCols Then
		For $iRow = $iStart To $iEnd ;for each row...
			$rRow = Random($iStart, $iEnd, 1) ;...select a random row
			For $iCol = 0 To $numCols - 1 ;swich the values for each cell in the rows
				$Temp = $avArray[$iRow][$iCol]
				$avArray[$iRow][$iCol] = $avArray[$rRow][$iCol]
				$avArray[$rRow][$iCol] = $Temp
			Next
		Next
		;	for 1 dimentional arrays:
	Else
		For $iRow = $iStart To $iEnd ;for each cell...
			$rRow = Random($iStart, $iEnd, 1) ;...select a random cell
			$Temp = $avArray[$iRow] ;switch the values in the cells
			$avArray[$iRow] = $avArray[$rRow]
			$avArray[$rRow] = $Temp
		Next
	EndIf
	Return 1
EndFunc   ;==>_ArrayRandom
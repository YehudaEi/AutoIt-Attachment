#include <GUIConstants.au3>
#include <Date.au3>

Dim $Timer1Active = 0, $Timer2Active = 0, $Timer3Active = 0, $Timer4Active = 0, $Timer5Active = 0, $Timer6Active = 0, $Timer7Active = 0, $Timer8Active = 0
Dim $Timer9Active = 0, $Timer10Active = 0, $Timer11Active = 0, $Timer12Active = 0, $Timer13Active = 0, $Timer14Active = 0, $Timer15Active = 0, $Timer16Active = 0
Dim $Timer17Active = 0, $Timer18Active = 0, $Timer19Active = 0, $Timer20Active = 0, $Timer21Active = 0, $Timer22Active = 0, $Timer23Active = 0, $Timer24Active = 0
Dim $Timer25Active = 0, $Timer26Active = 0, $Timer27Active = 0, $Timer28Active = 0, $Timer29Active = 0, $Timer30Active = 0, $Timer31Active = 0, $Timer32Active = 0
Dim $Timer33Active = 0, $Timer34Active = 0, $Timer35Active = 0, $Timer36Active = 0, $Timer37Active = 0, $Timer38Active = 0, $Timer39Active = 0, $Timer40Active = 0
Dim $Timer41Active = 0, $Timer42Active = 0, $Timer43Active = 0, $Timer44Active = 0, $Timer45Active = 0, $Timer46Active = 0, $Timer47Active = 0, $Timer48Active = 0
Dim $Timer49Active = 0, $Timer50Active = 0, $Timer51Active = 0

Global $Name, $TotalTime, $Station, $Unit

$Log = FileOpen ("logfile.txt", 1)
FileWriteLine ($Log, "Logfile started: " & _DateTimeFormat( _NowCalc(),0) & @CRLF &  @CRLF)
FileClose ($Log)

AdlibEnable("AllTimers", 500)

GUICreate("Net Cafe' Log by TSgt Farrell", 990, 370)

$tab=GUICtrlCreateTab (5,0, 980,370)
$tab0=GUICtrlCreateTabitem ("Computers")

;======================== Computers =================================

GUICtrlSetState(-1,$GUI_SHOW)
;Input 1
$Button_1 = GuiCtrlCreateButton("Start", 5, 70, 50, 20)
$Button_2 = GuiCtrlCreateButton("Stop", 55, 70, 50, 20)
$Input_3 = GuiCtrlCreateInput("Name", 5, 90, 100, 20, 0x1000)
$Input_4 = GuiCtrlCreateInput("Unit", 5, 110, 100, 20, 0x1000)
$Label_5 = GuiCtrlCreateLabel("", 5, 40, 100, 30, 0x1000)
GUICtrlSetFont ($Label_5, 16)
GUICtrlSetData($Label_5, "00:00:00")
GUICtrlCreateLabel("Computer 1", 5, 20, 100, 20, $SS_CENTER)
;Input 2
$Button_6 = GuiCtrlCreateButton("Start", 115, 70, 50, 20)
$Button_7 = GuiCtrlCreateButton("Stop", 165, 70, 50, 20)
$Label_8 = GuiCtrlCreateLabel("00:00:00", 115, 40, 100, 30, 0x1000)
$Input_9 = GuiCtrlCreateInput("Name", 115, 90, 100, 20, 0x1000)
$Input_10 = GuiCtrlCreateInput("Unit", 115, 110, 100, 20, 0x1000)
GUICtrlSetFont ($Label_8, 16)
GuiCtrlCreateLabel("Computer 2", 115, 20, 100, 20, $SS_CENTER)
;Input 3
$Button_11 = GuiCtrlCreateButton("Start", 225, 70, 50, 20)
$Button_12 = GuiCtrlCreateButton("Stop", 275, 70, 50, 20)
$Input_13 = GuiCtrlCreateInput("Name", 225, 90, 100, 20, 0x1000)
$Input_14 = GuiCtrlCreateInput("Unit", 225, 110, 100, 20, 0x1000)
$Label_15 = GuiCtrlCreateLabel("00:00:00", 225, 40, 100, 30, 0x1000)
GUICtrlSetFont ($Label_15, 16)
GuiCtrlCreateLabel("Computer 3", 225, 20, 100, 20, $SS_CENTER)
;Input 4
$Button_16 = GuiCtrlCreateButton("Start", 335, 70, 50, 20)
$Button_17 = GuiCtrlCreateButton("Stop", 385, 70, 50, 20)
$Input_18 = GuiCtrlCreateInput("Name", 335, 90, 100, 20, 0x1000)
$Input_19 = GuiCtrlCreateInput("Unit", 335, 110, 100, 20, 0x1000)
$Label_20 = GuiCtrlCreateLabel("00:00:00", 335, 40, 100, 30, 0x1000)
GUICtrlSetFont ($Label_20, 16)
GuiCtrlCreateLabel("Computer 4", 335, 20, 100, 20, $SS_CENTER)
;Input 5
$Button_21 = GuiCtrlCreateButton("Start", 445, 70, 50, 20)
$Button_22 = GuiCtrlCreateButton("Stop", 495, 70, 50, 20)
$Input_23 = GuiCtrlCreateInput("Name", 445, 90, 100, 20, 0x1000)
$Input_24 = GuiCtrlCreateInput("Unit", 445, 110, 100, 20, 0x1000)
$Label_25 = GuiCtrlCreateLabel("00:00:00", 445, 40, 100, 30, 0x1000)
GUICtrlSetFont ($Label_25, 16)
GuiCtrlCreateLabel("Computer 5", 445, 20, 100, 20, $SS_CENTER)
;Input 6
$Button_26 = GuiCtrlCreateButton("Start", 555, 70, 50, 20)
$Button_27 = GuiCtrlCreateButton("Stop", 605, 70, 50, 20)
$Input_28 = GuiCtrlCreateInput("Name", 555, 90, 100, 20, 0x1000)
$Input_29 = GuiCtrlCreateInput("Unit", 555, 110, 100, 20, 0x1000)
$Label_30 = GuiCtrlCreateLabel("00:00:00", 555, 40, 100, 30, 0x1000)
GUICtrlSetFont ($Label_30, 16)
GuiCtrlCreateLabel("Computer 6", 555, 20, 100, 20, $SS_CENTER)
;Input 7
$Button_31 = GuiCtrlCreateButton("Start", 665, 70, 50, 20)
$Button_32 = GuiCtrlCreateButton("Stop", 715, 70, 50, 20)
$Input_33 = GuiCtrlCreateInput("Name", 665, 90, 100, 20, 0x1000)
$Input_34 = GuiCtrlCreateInput("Unit", 665, 110, 100, 20, 0x1000)
$Label_35 = GuiCtrlCreateLabel("00:00:00", 665, 40, 100, 30, 0x1000)
GUICtrlSetFont ($Label_35, 16)
GuiCtrlCreateLabel("Computer 7", 665, 20, 100, 20, $SS_CENTER)
;Input 8
$Button_36 = GuiCtrlCreateButton("Start", 775, 70, 50, 20)
$Button_37 = GuiCtrlCreateButton("Stop", 825, 70, 50, 20)
$Input_38 = GuiCtrlCreateInput("Name", 775, 90, 100, 20, 0x1000)
$Input_39 = GuiCtrlCreateInput("Unit", 775, 110, 100, 20, 0x1000)
$Label_40 = GuiCtrlCreateLabel("00:00:00", 775, 40, 100, 30, 0x1000)
GUICtrlSetFont ($Label_40, 16)
GuiCtrlCreateLabel("Computer 8", 775, 20, 100, 20, $SS_CENTER)
;Input 9
$Button_41 = GuiCtrlCreateButton("Start", 885, 70, 50, 20)
$Button_42 = GuiCtrlCreateButton("Stop", 935, 70, 50, 20)
$Input_43 = GuiCtrlCreateInput("Name", 885, 90, 100, 20, 0x1000)
$Input_44 = GuiCtrlCreateInput("Unit", 885, 110, 100, 20, 0x1000)
$Label_45 = GuiCtrlCreateLabel("00:00:00", 885, 40, 100, 30, 0x1000)
GUICtrlSetFont ($Label_45, 16)
GuiCtrlCreateLabel("Computer 9", 885, 20, 100, 20, $SS_CENTER)
;Input 10
GuiCtrlCreateLabel("Computer 10", 5, 135, 100, 20, $SS_CENTER)
$Label_46 = GuiCtrlCreateLabel("00:00:00", 5, 155, 100, 30, 0x1000)
$Button_47 = GuiCtrlCreateButton("Start", 5, 185, 50, 20)
$Button_48 = GuiCtrlCreateButton("Stop", 55, 185, 50, 20)
$Input_49 = GuiCtrlCreateInput("Name", 5, 205, 100, 20, 0x1000)
$Input_50 = GuiCtrlCreateInput("Unit", 5, 225, 100, 20, 0x1000)
GUICtrlSetFont ($Label_46, 16)
;Input 11
$Button_51 = GuiCtrlCreateButton("Start", 115, 185, 50, 20)
$Button_52 = GuiCtrlCreateButton("Stop", 165, 185, 50, 20)
$Input_53 = GuiCtrlCreateInput("Name", 115, 205, 100, 20, 0x1000)
$Input_54 = GuiCtrlCreateInput("Unit", 115, 225, 100, 20, 0x1000)
$Label_55 = GuiCtrlCreateLabel("00:00:00", 115, 155, 100, 30, 0x1000)
GUICtrlSetFont ($Label_55, 16)
GuiCtrlCreateLabel("Computer 11", 115, 135, 100, 20, $SS_CENTER)
;Input 12
$Button_56 = GuiCtrlCreateButton("Start", 225, 185, 50, 20)
$Button_57 = GuiCtrlCreateButton("Stop", 275, 185, 50, 20)
$Input_58= GuiCtrlCreateInput("Name", 225, 205, 100, 20, 0x1000)
$Input_59 = GuiCtrlCreateInput("Unit", 225, 225, 100, 20, 0x1000)
$Label_60 = GuiCtrlCreateLabel("00:00:00", 225, 155, 100, 30, 0x1000)
GUICtrlSetFont ($Label_60, 16)
GuiCtrlCreateLabel("Computer 12", 225, 135, 100, 20, $SS_CENTER)
;Input 13
$Button_61 = GuiCtrlCreateButton("Start", 335, 185, 50, 20)
$Button_62 = GuiCtrlCreateButton("Stop", 385, 185, 50, 20)
$Input_63 = GuiCtrlCreateInput("Name", 335, 205, 100, 20, 0x1000)
$Input_64 = GuiCtrlCreateInput("Unit", 335, 225, 100, 20, 0x1000)
$Label_65 = GuiCtrlCreateLabel("00:00:00", 335, 155, 100, 30, 0x1000)
GUICtrlSetFont ($Label_65, 16)
GuiCtrlCreateLabel("Computer 13", 335, 135, 100, 20, $SS_CENTER)
;Input 14
$Button_66 = GuiCtrlCreateButton("Start", 445, 185, 50, 20)
$Button_67 = GuiCtrlCreateButton("Stop", 495, 185, 50, 20)
$Input_68 = GuiCtrlCreateInput("Name", 445, 205, 100, 20, 0x1000)
$Input_69 = GuiCtrlCreateInput("Unit", 445, 225, 100, 20, 0x1000)
$Label_70 = GuiCtrlCreateLabel("00:00:00", 445, 155, 100, 30, 0x1000)
GUICtrlSetFont ($Label_70, 16)
GuiCtrlCreateLabel("Computer 14", 445, 135, 100, 20, $SS_CENTER)
;Input 15
$Button_71 = GuiCtrlCreateButton("Start", 555, 185, 50, 20)
$Button_72 = GuiCtrlCreateButton("Stop", 605, 185, 50, 20)
$Input_73 = GuiCtrlCreateInput("Name", 555, 205, 100, 20, 0x1000)
$Input_74 = GuiCtrlCreateInput("Unit", 555, 225, 100, 20, 0x1000)
$Label_75 = GuiCtrlCreateLabel("00:00:00", 555, 155, 100, 30, 0x1000)
GUICtrlSetFont ($Label_75, 16)
GuiCtrlCreateLabel("Computer 15", 555, 135, 100, 20, $SS_CENTER)
;Input 16
$Button_76 = GuiCtrlCreateButton("Start", 665, 185, 50, 20)
$Button_77 = GuiCtrlCreateButton("Stop", 715, 185, 50, 20)
$Input_78 = GuiCtrlCreateInput("Name", 665, 205, 100, 20, 0x1000)
$Input_79 = GuiCtrlCreateInput("Unit", 665, 225, 100, 20, 0x1000)
$Label_80 = GuiCtrlCreateLabel("00:00:00", 665, 155, 100, 30, 0x1000)
GUICtrlSetFont ($Label_80, 16)
GuiCtrlCreateLabel("Computer 16", 665, 135, 100, 20, $SS_CENTER)
;Input 17
$Button_81 = GuiCtrlCreateButton("Start", 775, 185, 50, 20)
$Button_82 = GuiCtrlCreateButton("Stop", 825, 185, 50, 20)
$Input_83 = GuiCtrlCreateInput("Name", 775, 205, 100, 20, 0x1000)
$Input_84 = GuiCtrlCreateInput("Unit", 775, 225, 100, 20, 0x1000)
$Label_85 = GuiCtrlCreateLabel("00:00:00", 775, 155, 100, 30, 0x1000)
GUICtrlSetFont ($Label_85, 16)
GuiCtrlCreateLabel("Computer 17", 775, 135, 100, 20, $SS_CENTER)
;Input 18
$Button_86 = GuiCtrlCreateButton("Start", 885, 185, 50, 20)
$Button_87 = GuiCtrlCreateButton("Stop", 935, 185, 50, 20)
$Input_88 = GuiCtrlCreateInput("Name", 885, 205, 100, 20, 0x1000)
$Input_89 = GuiCtrlCreateInput("Unit", 885, 225, 100, 20, 0x1000)
$Label_90 = GuiCtrlCreateLabel("00:00:00", 885, 155, 100, 30, 0x1000)
GUICtrlSetFont ($Label_90, 16)
GuiCtrlCreateLabel("Computer 18", 885, 135, 100, 20, $SS_CENTER)
;Input 19
$Button_91 = GuiCtrlCreateButton("Start", 5, 300, 50, 20)
$Button_92 = GuiCtrlCreateButton("Stop", 55, 300, 50, 20)
$Input_93 = GuiCtrlCreateInput("Name", 5, 320, 100, 20, 0x1000)
$Input_94 = GuiCtrlCreateInput("Unit", 5, 340, 100, 20, 0x1000)
$Label_95 = GuiCtrlCreateLabel("00:00:00", 5, 270, 100, 30, 0x1000)
GUICtrlSetFont ($Label_95, 16)
GuiCtrlCreateLabel("Computer 19", 5, 250, 100, 20, $SS_CENTER)
;Input 20
$Button_96 = GuiCtrlCreateButton("Start", 115, 300, 50, 20)
$Button_97 = GuiCtrlCreateButton("Stop", 165, 300, 50, 20)
$Input_98 = GuiCtrlCreateInput("Name", 115, 320, 100, 20, 0x1000)
$Input_99 = GuiCtrlCreateInput("Unit", 115, 340, 100, 20, 0x1000)
$Label_100 = GuiCtrlCreateLabel("00:00:00", 115, 270, 100, 30, 0x1000)
GUICtrlSetFont ($Label_100, 16)
GuiCtrlCreateLabel("Computer 20", 115, 250, 100, 20, $SS_CENTER)
;Input 21
$Button_101 = GuiCtrlCreateButton("Start", 225, 300, 50, 20)
$Button_102 = GuiCtrlCreateButton("Stop", 275, 300, 50, 20)
$Input_103 = GuiCtrlCreateInput("Name", 225, 320, 100, 20, 0x1000)
$Input_104 = GuiCtrlCreateInput("Unit", 225, 340, 100, 20, 0x1000)
$Label_105 = GuiCtrlCreateLabel("00:00:00", 225, 270, 100, 30, 0x1000)
GUICtrlSetFont ($Label_105, 16)
GuiCtrlCreateLabel("Computer 21", 225, 250, 100, 20, $SS_CENTER)
;Input 22
$Button_106 = GuiCtrlCreateButton("Start", 335, 300, 50, 20)
$Button_107 = GuiCtrlCreateButton("Stop", 385, 300, 50, 20)
$Input_108 = GuiCtrlCreateInput("Name", 335, 320, 100, 20, 0x1000)
$Input_109 = GuiCtrlCreateInput("Unit", 335, 340, 100, 20, 0x1000)
$Label_110 = GuiCtrlCreateLabel("00:00:00", 335, 270, 100, 30, 0x1000)
GUICtrlSetFont ($Label_110, 16)
GuiCtrlCreateLabel("Computer 22", 335, 250, 100, 20, $SS_CENTER)
;Input 23
$Button_111 = GuiCtrlCreateButton("Start", 445, 300, 50, 20)
$Button_112 = GuiCtrlCreateButton("Stop", 495, 300, 50, 20)
$Input_113 = GuiCtrlCreateInput("Name", 445, 320, 100, 20, 0x1000)
$Input_114 = GuiCtrlCreateInput("Unit", 445, 340, 100, 20, 0x1000)
$Label_115 = GuiCtrlCreateLabel("00:00:00", 445, 270, 100, 30, 0x1000)
GUICtrlSetFont ($Label_115, 16)
GuiCtrlCreateLabel("Computer 23", 445, 250, 100, 20, $SS_CENTER)
;Input 24
$Button_116 = GuiCtrlCreateButton("Start", 555, 300, 50, 20)
$Button_117 = GuiCtrlCreateButton("Stop", 605, 300, 50, 20)
$Input_118 = GuiCtrlCreateInput("Name", 555, 320, 100, 20, 0x1000)
$Input_119 = GuiCtrlCreateInput("Unit", 555, 340, 100, 20, 0x1000)
$Label_120 = GuiCtrlCreateLabel("00:00:00", 555, 270, 100, 30, 0x1000)
GUICtrlSetFont ($Label_120, 16)
GuiCtrlCreateLabel("Computer 24", 555, 250, 100, 20, $SS_CENTER)
;Input 25
$Button_121 = GuiCtrlCreateButton("Start", 665, 300, 50, 20)
$Button_122 = GuiCtrlCreateButton("Stop", 715, 300, 50, 20)
$Input_123 = GuiCtrlCreateInput("Name", 665, 320, 100, 20, 0x1000)
$Input_124 = GuiCtrlCreateInput("Unit", 665, 340, 100, 20, 0x1000)
$Label_125 = GuiCtrlCreateLabel("00:00:00", 665, 270, 100, 30, 0x1000)
GUICtrlSetFont ($Label_125, 16)
GuiCtrlCreateLabel("Computer 25", 665, 250, 100, 20, $SS_CENTER)
;Input 26
$Button_126 = GuiCtrlCreateButton("Start", 775, 300, 50, 20)
$Button_127 = GuiCtrlCreateButton("Stop", 825, 300, 50, 20)
$Input_128 = GuiCtrlCreateInput("Name", 775, 320, 100, 20, 0x1000)
$Input_129 = GuiCtrlCreateInput("Unit", 775, 340, 100, 20, 0x1000)
$Label_130 = GuiCtrlCreateLabel("00:00:00", 775, 270, 100, 30, 0x1000)
GUICtrlSetFont ($Label_130, 16)
GuiCtrlCreateLabel("Computer 26", 775, 250, 100, 20, $SS_CENTER)
;Input 27
$Button_131 = GuiCtrlCreateButton("Start", 885, 300, 50, 20)
$Button_132 = GuiCtrlCreateButton("Stop", 935, 300, 50, 20)
$Input_133 = GuiCtrlCreateInput("Name", 885, 320, 100, 20, 0x1000)
$Input_134 = GuiCtrlCreateInput("Unit", 885, 340, 100, 20, 0x1000)
$Label_135 = GuiCtrlCreateLabel("00:00:00", 885, 270, 100, 30, 0x1000)
GUICtrlSetFont ($Label_135, 16)
GuiCtrlCreateLabel("Computer 27", 885, 250, 100, 20, $SS_CENTER)

;======================== Phones =================================

$tab1=GUICtrlCreateTabitem ( "Phones")

;Input 28
$Button_136 = GuiCtrlCreateButton("Start", 5, 70, 50, 20)
$Button_137 = GuiCtrlCreateButton("Stop", 55, 70, 50, 20)
$Input_138 = GuiCtrlCreateInput("Name", 5, 90, 100, 20, 0x1000)
$Input_139 = GuiCtrlCreateInput("Unit", 5, 110, 100, 20, 0x1000)
$Label_140 = GuiCtrlCreateLabel("00:00:00", 5, 40, 100, 30, 0x1000)
GUICtrlSetFont ($Label_140, 16)
GuiCtrlCreateLabel("Phone 1", 5, 20, 100, 20, $SS_CENTER)
;Input 29
$Button_141 = GuiCtrlCreateButton("Start", 115, 70, 50, 20)
$Button_142 = GuiCtrlCreateButton("Stop", 165, 70, 50, 20)
$Input_143 = GuiCtrlCreateInput("Name", 115, 90, 100, 20, 0x1000)
$Input_144 = GuiCtrlCreateInput("Unit", 115, 110, 100, 20, 0x1000)
$Label_145 = GuiCtrlCreateLabel("00:00:00", 115, 40, 100, 30, 0x1000)
GUICtrlSetFont ($Label_145, 16)
GuiCtrlCreateLabel("Phone 2", 115, 20, 100, 20, $SS_CENTER)
;Input 30
$Button_146 = GuiCtrlCreateButton("Start", 225, 70, 50, 20)
$Button_147 = GuiCtrlCreateButton("Stop", 275, 70, 50, 20)
$Input_148 = GuiCtrlCreateInput("Name", 225, 90, 100, 20, 0x1000)
$Input_149 = GuiCtrlCreateInput("Unit", 225, 110, 100, 20, 0x1000)
$Label_150 = GuiCtrlCreateLabel("00:00:00", 225, 40, 100, 30, 0x1000)
GUICtrlSetFont ($Label_150, 16)
GuiCtrlCreateLabel("Phone 3", 225, 20, 100, 20, $SS_CENTER)
;Input 31
$Button_151 = GuiCtrlCreateButton("Start", 335, 70, 50, 20)
$Button_152 = GuiCtrlCreateButton("Stop", 385, 70, 50, 20)
$Input_153 = GuiCtrlCreateInput("Name", 335, 90, 100, 20, 0x1000)
$Input_154 = GuiCtrlCreateInput("Unit", 335, 110, 100, 20, 0x1000)
$Label_155 = GuiCtrlCreateLabel("00:00:00", 335, 40, 100, 30, 0x1000)
GUICtrlSetFont ($Label_155, 16)
GuiCtrlCreateLabel("Phone 4", 335, 20, 100, 20, $SS_CENTER)
;Input 32
$Button_156 = GuiCtrlCreateButton("Start", 445, 70, 50, 20)
$Button_157 = GuiCtrlCreateButton("Stop", 495, 70, 50, 20)
$Input_158 = GuiCtrlCreateInput("Name", 445, 90, 100, 20, 0x1000)
$Input_159 = GuiCtrlCreateInput("Unit", 445, 110, 100, 20, 0x1000)
$Label_160 = GuiCtrlCreateLabel("00:00:00", 445, 40, 100, 30, 0x1000)
GUICtrlSetFont ($Label_160, 16)
GuiCtrlCreateLabel("Phone 5", 445, 20, 100, 20, $SS_CENTER)
;Input 33
$Button_161 = GuiCtrlCreateButton("Start", 555, 70, 50, 20)
$Button_162 = GuiCtrlCreateButton("Stop", 605, 70, 50, 20)
$Input_163 = GuiCtrlCreateInput("Name", 555, 90, 100, 20, 0x1000)
$Input_164 = GuiCtrlCreateInput("Unit", 555, 110, 100, 20, 0x1000)
$Label_165 = GuiCtrlCreateLabel("00:00:00", 555, 40, 100, 30, 0x1000)
GUICtrlSetFont ($Label_165, 16)
GuiCtrlCreateLabel("Phone 6", 555, 20, 100, 20, $SS_CENTER)
;Input 34
$Button_166 = GuiCtrlCreateButton("Start", 665, 70, 50, 20)
$Button_167 = GuiCtrlCreateButton("Stop", 715, 70, 50, 20)
$Input_168 = GuiCtrlCreateInput("Name", 665, 90, 100, 20, 0x1000)
$Input_169 = GuiCtrlCreateInput("Unit", 665, 110, 100, 20, 0x1000)
$Label_170 = GuiCtrlCreateLabel("00:00:00", 665, 40, 100, 30, 0x1000)
GUICtrlSetFont ($Label_170, 16)
GuiCtrlCreateLabel("Phone 7", 665, 20, 100, 20, $SS_CENTER)
;Input 35
$Button_171 = GuiCtrlCreateButton("Start", 775, 70, 50, 20)
$Button_172 = GuiCtrlCreateButton("Stop", 825, 70, 50, 20)
$Input_173 = GuiCtrlCreateInput("Name", 775, 90, 100, 20, 0x1000)
$Input_174 = GuiCtrlCreateInput("Unit", 775, 110, 100, 20, 0x1000)
$Label_175 = GuiCtrlCreateLabel("00:00:00", 775, 40, 100, 30, 0x1000)
GUICtrlSetFont ($Label_175, 16)
GuiCtrlCreateLabel("Phone 8", 775, 20, 100, 20, $SS_CENTER)
;Input 36
$Button_176 = GuiCtrlCreateButton("Start", 885, 70, 50, 20)
$Button_177 = GuiCtrlCreateButton("Stop", 935, 70, 50, 20)
$Input_178 = GuiCtrlCreateInput("Name", 885, 90, 100, 20, 0x1000)
$Input_179 = GuiCtrlCreateInput("Unit", 885, 110, 100, 20, 0x1000)
$Label_180 = GuiCtrlCreateLabel("00:00:00", 885, 40, 100, 30, 0x1000)
GUICtrlSetFont ($Label_180, 16)
GuiCtrlCreateLabel("Phone 9", 885, 20, 100, 20, $SS_CENTER)
;Input 37
$Button_181 = GuiCtrlCreateButton("Start", 5, 185, 50, 20)
$Button_182 = GuiCtrlCreateButton("Stop", 55, 185, 50, 20)
$Input_183 = GuiCtrlCreateInput("Name", 5, 205, 100, 20, 0x1000)
$Input_184 = GuiCtrlCreateInput("Unit", 5, 225, 100, 20, 0x1000)
$Label_185 = GuiCtrlCreateLabel("00:00:00", 5, 155, 100, 30, 0x1000)
GUICtrlSetFont ($Label_185, 16)
GuiCtrlCreateLabel("Phone 10", 5, 135, 100, 20, $SS_CENTER)
;Input 38
$Button_186 = GuiCtrlCreateButton("Start", 115, 185, 50, 20)
$Button_187 = GuiCtrlCreateButton("Stop", 165, 185, 50, 20)
$Input_188 = GuiCtrlCreateInput("Name", 115, 205, 100, 20, 0x1000)
$Input_189 = GuiCtrlCreateInput("Unit", 115, 225, 100, 20, 0x1000)
$Label_190 = GuiCtrlCreateLabel("00:00:00", 115, 155, 100, 30, 0x1000)
GUICtrlSetFont ($Label_190, 16)
GuiCtrlCreateLabel("Phone 11", 115, 135, 100, 20, $SS_CENTER)
;Input 39
$Button_191 = GuiCtrlCreateButton("Start", 225, 185, 50, 20)
$Button_192 = GuiCtrlCreateButton("Stop", 275, 185, 50, 20)
$Input_193 = GuiCtrlCreateInput("Name", 225, 205, 100, 20, 0x1000)
$Input_194 = GuiCtrlCreateInput("Unit", 225, 225, 100, 20, 0x1000)
$Label_195 = GuiCtrlCreateLabel("00:00:00", 225, 155, 100, 30, 0x1000)
GUICtrlSetFont ($Label_195, 16)
GuiCtrlCreateLabel("Phone 12", 225, 135, 100, 20, $SS_CENTER)
;Input 40
$Button_196 = GuiCtrlCreateButton("Start", 335, 185, 50, 20)
$Button_197 = GuiCtrlCreateButton("Stop", 385, 185, 50, 20)
$Input_198 = GuiCtrlCreateInput("Name", 335, 205, 100, 20, 0x1000)
$Input_199 = GuiCtrlCreateInput("Unit", 335, 225, 100, 20, 0x1000)
$Label_200 = GuiCtrlCreateLabel("00:00:00", 335, 155, 100, 30, 0x1000)
GUICtrlSetFont ($Label_200, 16)
GuiCtrlCreateLabel("Phone 13", 335, 135, 100, 20, $SS_CENTER)
;Input 41
$Button_201 = GuiCtrlCreateButton("Start", 445, 185, 50, 20)
$Button_202 = GuiCtrlCreateButton("Stop", 495, 185, 50, 20)
$Input_203 = GuiCtrlCreateInput("Name", 445, 205, 100, 20, 0x1000)
$Input_204 = GuiCtrlCreateInput("Unit", 445, 225, 100, 20, 0x1000)
$Label_205 = GuiCtrlCreateLabel("00:00:00", 445, 155, 100, 30, 0x1000)
GUICtrlSetFont ($Label_205, 16)
GuiCtrlCreateLabel("Phone 14", 445, 135, 100, 20, $SS_CENTER)
;Input 42
$Button_206 = GuiCtrlCreateButton("Start", 555, 185, 50, 20)
$Button_207 = GuiCtrlCreateButton("Stop", 605, 185, 50, 20)
$Input_208 = GuiCtrlCreateInput("Name", 555, 205, 100, 20, 0x1000)
$Input_209 = GuiCtrlCreateInput("Unit", 555, 225, 100, 20, 0x1000)
$Label_210 = GuiCtrlCreateLabel("00:00:00", 555, 155, 100, 30, 0x1000)
GUICtrlSetFont ($Label_210, 16)
GuiCtrlCreateLabel("Phone 15", 555, 135, 100, 20, $SS_CENTER)
;Input 43
$Button_211 = GuiCtrlCreateButton("Start", 665, 185, 50, 20)
$Button_212 = GuiCtrlCreateButton("Stop", 715, 185, 50, 20)
$Input_213 = GuiCtrlCreateInput("Name", 665, 205, 100, 20, 0x1000)
$Input_214 = GuiCtrlCreateInput("Unit", 665, 225, 100, 20, 0x1000)
$Label_215 = GuiCtrlCreateLabel("00:00:00", 665, 155, 100, 30, 0x1000)
GUICtrlSetFont ($Label_215, 16)
GuiCtrlCreateLabel("Phone 16", 665, 135, 100, 20, $SS_CENTER)
;Input 44
$Button_216 = GuiCtrlCreateButton("Start", 775, 185, 50, 20)
$Button_217 = GuiCtrlCreateButton("Stop", 825, 185, 50, 20)
$Input_218 = GuiCtrlCreateInput("Name", 775, 205, 100, 20, 0x1000)
$Input_219 = GuiCtrlCreateInput("Unit", 775, 225, 100, 20, 0x1000)
$Label_220 = GuiCtrlCreateLabel("00:00:00", 775, 155, 100, 30, 0x1000)
GUICtrlSetFont ($Label_220, 16)
GuiCtrlCreateLabel("Phone 17", 775, 135, 100, 20, $SS_CENTER)
;Input 45
$Button_221 = GuiCtrlCreateButton("Start", 885, 185, 50, 20)
$Button_222 = GuiCtrlCreateButton("Stop", 935, 185, 50, 20)
$Input_223 = GuiCtrlCreateInput("Name", 885, 205, 100, 20, 0x1000)
$Input_224 = GuiCtrlCreateInput("Unit", 885, 225, 100, 20, 0x1000)
$Label_225 = GuiCtrlCreateLabel("00:00:00", 885, 155, 100, 30, 0x1000)
GUICtrlSetFont ($Label_225, 16)
GuiCtrlCreateLabel("Phone 18", 885, 135, 100, 20, $SS_CENTER)

;======================== PC's =================================

$tab2=GUICtrlCreateTabitem ("PC's")

;Input 28
$Button_226 = GuiCtrlCreateButton("Start", 5, 70, 50, 20)
$Button_227 = GuiCtrlCreateButton("Stop", 55, 70, 50, 20)
$Input_228 = GuiCtrlCreateInput("Name", 5, 90, 100, 20, 0x1000)
$Input_229 = GuiCtrlCreateInput("Unit", 5, 110, 100, 20, 0x1000)
$Label_230 = GuiCtrlCreateLabel("00:00:00", 5, 40, 100, 30, 0x1000)
GUICtrlSetFont ($Label_230, 16)
GuiCtrlCreateLabel("PC 1", 5, 20, 100, 20, $SS_CENTER)
;Input 29
$Button_231 = GuiCtrlCreateButton("Start", 115, 70, 50, 20)
$Button_232 = GuiCtrlCreateButton("Stop", 165, 70, 50, 20)
$Input_233 = GuiCtrlCreateInput("Name", 115, 90, 100, 20, 0x1000)
$Input_234 = GuiCtrlCreateInput("Unit", 115, 110, 100, 20, 0x1000)
$Label_235 = GuiCtrlCreateLabel("00:00:00", 115, 40, 100, 30, 0x1000)
GUICtrlSetFont ($Label_235, 16)
GuiCtrlCreateLabel("PC 2", 115, 20, 100, 20, $SS_CENTER)
;Input 30
$Button_236 = GuiCtrlCreateButton("Start", 225, 70, 50, 20)
$Button_237 = GuiCtrlCreateButton("Stop", 275, 70, 50, 20)
$Input_238 = GuiCtrlCreateInput("Name", 225, 90, 100, 20, 0x1000)
$Input_239 = GuiCtrlCreateInput("Unit", 225, 110, 100, 20, 0x1000)
$Label_240 = GuiCtrlCreateLabel("00:00:00", 225, 40, 100, 30, 0x1000)
GUICtrlSetFont ($Label_240, 16)
GuiCtrlCreateLabel("PC 3", 225, 20, 100, 20, $SS_CENTER)
;Input 31
$Button_241 = GuiCtrlCreateButton("Start", 335, 70, 50, 20)
$Button_242 = GuiCtrlCreateButton("Stop", 385, 70, 50, 20)
$Input_243 = GuiCtrlCreateInput("Name", 335, 90, 100, 20, 0x1000)
$Input_244 = GuiCtrlCreateInput("Unit", 335, 110, 100, 20, 0x1000)
$Label_245 = GuiCtrlCreateLabel("00:00:00", 335, 40, 100, 30, 0x1000)
GUICtrlSetFont ($Label_245, 16)
GuiCtrlCreateLabel("PC 4", 335, 20, 100, 20, $SS_CENTER)
;Input 32
$Button_246 = GuiCtrlCreateButton("Start", 445, 70, 50, 20)
$Button_247 = GuiCtrlCreateButton("Stop", 495, 70, 50, 20)
$Input_248 = GuiCtrlCreateInput("Name", 445, 90, 100, 20, 0x1000)
$Input_249 = GuiCtrlCreateInput("Unit", 445, 110, 100, 20, 0x1000)
$Label_250 = GuiCtrlCreateLabel("00:00:00", 445, 40, 100, 30, 0x1000)
GUICtrlSetFont ($Label_250, 16)
GuiCtrlCreateLabel("PC 5", 445, 20, 100, 20, $SS_CENTER)
;Input 33
$Button_251 = GuiCtrlCreateButton("Start", 555, 70, 50, 20)
$Button_252 = GuiCtrlCreateButton("Stop", 605, 70, 50, 20)
$Input_253 = GuiCtrlCreateInput("Name", 555, 90, 100, 20, 0x1000)
$Input_254 = GuiCtrlCreateInput("Unit", 555, 110, 100, 20, 0x1000)
$Label_255 = GuiCtrlCreateLabel("00:00:00", 555, 40, 100, 30, 0x1000)
GUICtrlSetFont ($Label_255, 16)
GuiCtrlCreateLabel("PC 6", 555, 20, 100, 20, $SS_CENTER)

GUICtrlCreateTabitem ("")

GUISetState()

While 1
    $msg = GUIGetMsg()
    Select
        Case $msg = $Button_1
            $Timer1Active = 1
            $timer1 = TimerInit()
        Case $msg = $Button_2
            $Timer1Active = 0
            GUICtrlSetData($Label_5, "00:00:00")
			GUICtrlSetColor($Label_5, 0x000000)
			$Name = GUICtrlRead ($Input_3)
			GUICtrlSetData($Input_3, "Name")
			$Unit = GUICtrlRead ($Input_4)
			GUICtrlSetData($Input_4, "Unit")
			$Station = "Computer 1"
			RecordStuff()
			
        Case $msg = $Button_6
            $Timer2Active = 1
            $timer2 = TimerInit()
        Case $msg = $Button_7
            $Timer2Active = 0
            GUICtrlSetData($Label_8, "00:00:00")
			GUICtrlSetColor($Label_8,0x000000)
			$Name = GUICtrlRead ($Input_9)
			GUICtrlSetData($Input_9, "Name")
			$Unit = GUICtrlRead ($Input_10)
			GUICtrlSetData($Input_10, "Unit")
			$Station = "Computer 2"
			RecordStuff()
			
		Case $msg = $Button_11
            $Timer3Active = 1
            $timer3 = TimerInit()
        Case $msg = $Button_12
            $Timer3Active = 0
            GUICtrlSetData($Label_15, "00:00:00")
			GUICtrlSetColor($Label_15,0x000000)
			$Name = GUICtrlRead ($Input_13)
			GUICtrlSetData($Input_13, "Name")
			$Unit = GUICtrlRead ($Input_14)
			GUICtrlSetData($Input_14, "Unit")
			$Station = "Computer 3"
			RecordStuff()
			
		Case $msg = $Button_16
            $Timer4Active = 1
            $timer4 = TimerInit()
         Case $msg = $Button_17
            $Timer4Active = 0
            GUICtrlSetData($Label_20, "00:00:00")
			GUICtrlSetColor($Label_20,0x000000)
			$Name = GUICtrlRead ($Input_18)
			GUICtrlSetData($Input_18, "Name")
			$Unit = GUICtrlRead ($Input_19)
			GUICtrlSetData($Input_19, "Unit")
			$Station = "Computer 4"
			RecordStuff()
			
		Case $msg = $Button_21
            $Timer5Active = 1
            $timer5 = TimerInit()
         Case $msg = $Button_22
            $Timer5Active = 0
            GUICtrlSetData($Label_25, "00:00:00")
			GUICtrlSetColor($Label_25,0x000000)
			$Name = GUICtrlRead ($Input_23)
			GUICtrlSetData($Input_23, "Name")
			$Unit = GUICtrlRead ($Input_24)
			GUICtrlSetData($Input_24, "Unit")
			$Station = "Computer 5"
			RecordStuff()
			
		Case $msg = $Button_26
            $Timer6Active = 1
            $timer6 = TimerInit()
        Case $msg = $Button_27
            $Timer6Active = 0
            GUICtrlSetData($Label_30, "00:00:00")
			GUICtrlSetColor($Label_30,0x000000)
			$Name = GUICtrlRead ($Input_28)
			GUICtrlSetData($Input_28, "Name")
			$Unit = GUICtrlRead ($Input_29)
			GUICtrlSetData($Input_29, "Unit")
			$Station = "Computer 6"
			RecordStuff()
			
		Case $msg = $Button_31
            $Timer7Active = 1
            $timer7 = TimerInit()
        Case $msg = $Button_32
            $Timer7Active = 0
            GUICtrlSetData($Label_35, "00:00:00")
			GUICtrlSetColor($Label_35,0x000000)
			$Name = GUICtrlRead ($Input_33)
			GUICtrlSetData($Input_33, "Name")
			$Unit = GUICtrlRead ($Input_34)
			GUICtrlSetData($Input_34, "Unit")
			$Station = "Computer 7"
			RecordStuff()
			
		Case $msg = $Button_36
            $Timer8Active = 1
            $timer8 = TimerInit()
        Case $msg = $Button_37
            $Timer8Active = 0
            GUICtrlSetData($Label_40, "00:00:00")
			GUICtrlSetColor($Label_40,0x000000)
			$Name = GUICtrlRead ($Input_38)
			GUICtrlSetData($Input_38, "Name")
			$Unit = GUICtrlRead ($Input_39)
			GUICtrlSetData($Input_39, "Unit")
			$Station = "Computer 8"
			RecordStuff()
			
		Case $msg = $Button_41
            $Timer9Active = 1
            $timer9 = TimerInit()
        Case $msg = $Button_42
            $Timer9Active = 0
            GUICtrlSetData($Label_45, "00:00:00")
			GUICtrlSetColor($Label_45,0x000000)
			$Name = GUICtrlRead ($Input_43)
			GUICtrlSetData($Input_43, "Name")
			$Unit = GUICtrlRead ($Input_44)
			GUICtrlSetData($Input_44, "Unit")
			$Station = "Computer 9"
			RecordStuff()
			
		Case $msg = $Button_47
            $Timer10Active = 1
            $timer10 = TimerInit()
        Case $msg = $Button_48
            $Timer10Active = 0
            GUICtrlSetData($Label_46, "00:00:00")
			GUICtrlSetColor($Label_46,0x000000)
			$Name = GUICtrlRead ($Input_49)
			GUICtrlSetData($Input_49, "Name")
			$Unit = GUICtrlRead ($Input_50)
			GUICtrlSetData($Input_50, "Unit")
			$Station = "Computer 10"
			RecordStuff()
			
		Case $msg = $Button_51
            $Timer11Active = 1
            $timer11 = TimerInit()
        Case $msg = $Button_52
            $Timer11Active = 0
            GUICtrlSetData($Label_55, "00:00:00")
			GUICtrlSetColor($Label_55,0x000000)
			$Name = GUICtrlRead ($Input_53)
			GUICtrlSetData($Input_53, "Name")
			$Unit = GUICtrlRead ($Input_54)
			GUICtrlSetData($Input_54, "Unit")
			$Station = "Computer 11"
			RecordStuff()
			
		Case $msg = $Button_56
            $Timer12Active = 1
            $timer12 = TimerInit()
        Case $msg = $Button_57
            $Timer12Active = 0
            GUICtrlSetData($Label_60, "00:00:00")
			GUICtrlSetColor($Label_60,0x000000)
			$Name = GUICtrlRead ($Input_58)
			GUICtrlSetData($Input_58, "Name")
			$Unit = GUICtrlRead ($Input_59)
			GUICtrlSetData($Input_59, "Unit")
			$Station = "Computer 12"
			RecordStuff()
			
		Case $msg = $Button_61
            $Timer13Active = 1
            $timer13 = TimerInit()
        Case $msg = $Button_62
            $Timer13Active = 0
            GUICtrlSetData($Label_65, "00:00:00")
			GUICtrlSetColor($Label_65,0x000000)
			$Name = GUICtrlRead ($Input_63)
			GUICtrlSetData($Input_63, "Name")
			$Unit = GUICtrlRead ($Input_64)
			GUICtrlSetData($Input_64, "Unit")
			$Station = "Computer 13"
			RecordStuff()
			
		Case $msg = $Button_66
            $Timer14Active = 1
            $timer14 = TimerInit()
        Case $msg = $Button_67
            $Timer14Active = 0
            GUICtrlSetData($Label_70, "00:00:00")
			GUICtrlSetColor($Label_70,0x000000)
			$Name = GUICtrlRead ($Input_68)
			GUICtrlSetData($Input_68, "Name")
			$Unit = GUICtrlRead ($Input_69)
			GUICtrlSetData($Input_69, "Unit")
			$Station = "Computer 14"
			RecordStuff()
			
		Case $msg = $Button_71
            $Timer15Active = 1
            $timer15 = TimerInit()
        Case $msg = $Button_72
            $Timer15Active = 0
            GUICtrlSetData($Label_75, "00:00:00")
			GUICtrlSetColor($Label_75,0x000000)
			$Name = GUICtrlRead ($Input_73)
			GUICtrlSetData($Input_73, "Name")
			$Unit = GUICtrlRead ($Input_74)
			GUICtrlSetData($Input_74, "Unit")
			$Station = "Computer 15"
			RecordStuff()
			
		Case $msg = $Button_76
            $Timer16Active = 1
            $timer16 = TimerInit()
        Case $msg = $Button_77
            $Timer16Active = 0
            GUICtrlSetData($Label_80, "00:00:00")
			GUICtrlSetColor($Label_80,0x000000)
			$Name = GUICtrlRead ($Input_78)
			GUICtrlSetData($Input_78, "Name")
			$Unit = GUICtrlRead ($Input_79)
			GUICtrlSetData($Input_79, "Unit")
			$Station = "Computer 16"
			RecordStuff()
			
		Case $msg = $Button_81
            $Timer17Active = 1
            $timer17 = TimerInit()
        Case $msg = $Button_82
            $Timer17Active = 0
            GUICtrlSetData($Label_85, "00:00:00")
			GUICtrlSetColor($Label_85,0x000000)
			$Name = GUICtrlRead ($Input_83)
			GUICtrlSetData($Input_83, "Name")
			$Unit = GUICtrlRead ($Input_84)
			GUICtrlSetData($Input_84, "Unit")
			$Station = "Computer 17"
			RecordStuff()
			
		Case $msg = $Button_86
            $Timer18Active = 1
            $timer18 = TimerInit()
        Case $msg = $Button_87
            $Timer18Active = 0
            GUICtrlSetData($Label_90, "00:00:00")
			GUICtrlSetColor($Label_90,0x000000)
			$Name = GUICtrlRead ($Input_88)
			GUICtrlSetData($Input_88, "Name")
			$Unit = GUICtrlRead ($Input_89)
			GUICtrlSetData($Input_89, "Unit")
			$Station = "Computer 18"
			RecordStuff()
			
		Case $msg = $Button_91
            $Timer19Active = 1
            $timer19 = TimerInit()
        Case $msg = $Button_92
            $Timer19Active = 0
            GUICtrlSetData($Label_95, "00:00:00")
			GUICtrlSetColor($Label_95,0x000000)
			$Name = GUICtrlRead ($Input_93)
			GUICtrlSetData($Input_93, "Name")
			$Unit = GUICtrlRead ($Input_94)
			GUICtrlSetData($Input_94, "Unit")
			$Station = "Computer 19"
			RecordStuff()
		
		Case $msg = $Button_96
            $Timer20Active = 1
            $timer20 = TimerInit()
        Case $msg = $Button_97
            $Timer20Active = 0
            GUICtrlSetData($Label_100, "00:00:00")
			GUICtrlSetColor($Label_100,0x000000)
			$Name = GUICtrlRead ($Input_98)
			GUICtrlSetData($Input_98, "Name")
			$Unit = GUICtrlRead ($Input_99)
			GUICtrlSetData($Input_99, "Unit")
			$Station = "Computer 20"
			RecordStuff()
		
		Case $msg = $Button_101
            $Timer21Active = 1
            $timer21 = TimerInit()
        Case $msg = $Button_102
            $Timer21Active = 0
            GUICtrlSetData($Label_105, "00:00:00")
			GUICtrlSetColor($Label_105,0x000000)
			$Name = GUICtrlRead ($Input_103)
			GUICtrlSetData($Input_103, "Name")
			$Unit = GUICtrlRead ($Input_104)
			GUICtrlSetData($Input_104, "Unit")
			$Station = "Computer 21"
			RecordStuff()
		
		Case $msg = $Button_106
            $Timer22Active = 1
            $timer22 = TimerInit()
        Case $msg = $Button_107
            $Timer22Active = 0
            GUICtrlSetData($Label_110, "00:00:00")
			GUICtrlSetColor($Label_110,0x000000)
			$Name = GUICtrlRead ($Input_108)
			GUICtrlSetData($Input_108, "Name")
			$Unit = GUICtrlRead ($Input_109)
			GUICtrlSetData($Input_109, "Unit")
			$Station = "Computer 22"
			RecordStuff()
		
		Case $msg = $Button_111
            $Timer23Active = 1
            $timer23 = TimerInit()
        Case $msg = $Button_112
            $Timer23Active = 0
            GUICtrlSetData($Label_115, "00:00:00")
			GUICtrlSetColor($Label_115,0x000000)
			$Name = GUICtrlRead ($Input_113)
			GUICtrlSetData($Input_113, "Name")
			$Unit = GUICtrlRead ($Input_114)
			GUICtrlSetData($Input_114, "Unit")
			$Station = "Computer 23"
			RecordStuff()
		
		Case $msg = $Button_116
            $Timer24Active = 1
            $timer24 = TimerInit()
        Case $msg = $Button_117
            $Timer24Active = 0
            GUICtrlSetData($Label_120, "00:00:00")
			GUICtrlSetColor($Label_120,0x000000)
			$Name = GUICtrlRead ($Input_118)
			GUICtrlSetData($Input_118, "Name")
			$Unit = GUICtrlRead ($Input_119)
			GUICtrlSetData($Input_119, "Unit")
			$Station = "Computer 24"
			RecordStuff()
		
		Case $msg = $Button_121
            $Timer25Active = 1
            $timer25 = TimerInit()
        Case $msg = $Button_122
            $Timer25Active = 0
            GUICtrlSetData($Label_125, "00:00:00")
			GUICtrlSetColor($Label_125,0x000000)
			$Name = GUICtrlRead ($Input_123)
			GUICtrlSetData($Input_123, "Name")
			$Unit = GUICtrlRead ($Input_124)
			GUICtrlSetData($Input_124, "Unit")
			$Station = "Computer 25"
			RecordStuff()
		
		Case $msg = $Button_126
            $Timer26Active = 1
            $timer26 = TimerInit()
        Case $msg = $Button_127
            $Timer26Active = 0
            GUICtrlSetData($Label_130, "00:00:00")
			GUICtrlSetColor($Label_130,0x000000)
			$Name = GUICtrlRead ($Input_128)
			GUICtrlSetData($Input_128, "Name")
			$Unit = GUICtrlRead ($Input_129)
			GUICtrlSetData($Input_129, "Unit")
			$Station = "Computer 26"
			RecordStuff()
		
		Case $msg = $Button_131
            $Timer27Active = 1
            $timer27 = TimerInit()
        Case $msg = $Button_132
            $Timer27Active = 0
            GUICtrlSetData($Label_135, "00:00:00")
			GUICtrlSetColor($Label_135,0x000000)
			$Name = GUICtrlRead ($Input_133)
			GUICtrlSetData($Input_133, "Name")
			$Unit = GUICtrlRead ($Input_134)
			GUICtrlSetData($Input_134, "Unit")
			$Station = "Computer 27"
			RecordStuff()
		
		Case $msg = $Button_136
            $Timer28Active = 1
            $timer28 = TimerInit()
        Case $msg = $Button_137
            $Timer28Active = 0
            GUICtrlSetData($Label_140, "00:00:00")
			GUICtrlSetColor($Label_140,0x000000)
			$Name = GUICtrlRead ($Input_138)
			GUICtrlSetData($Input_138, "Name")
			$Unit = GUICtrlRead ($Input_139)
			GUICtrlSetData($Input_139, "Unit")
			$Station = "Phone 1"
			RecordStuff()
		
		Case $msg = $Button_141
            $Timer29Active = 1
            $timer29 = TimerInit()
        Case $msg = $Button_142
            $Timer29Active = 0
            GUICtrlSetData($Label_145, "00:00:00")
			GUICtrlSetColor($Label_145,0x000000)
			$Name = GUICtrlRead ($Input_143)
			GUICtrlSetData($Input_143, "Name")
			$Unit = GUICtrlRead ($Input_144)
			GUICtrlSetData($Input_144, "Unit")
			$Station = "Phone 2"
			RecordStuff()
		
		Case $msg = $Button_146
            $Timer30Active = 1
            $timer30 = TimerInit()
        Case $msg = $Button_147
            $Timer30Active = 0
            GUICtrlSetData($Label_150, "00:00:00")
			GUICtrlSetColor($Label_150,0x000000)
			$Name = GUICtrlRead ($Input_148)
			GUICtrlSetData($Input_148, "Name")
			$Unit = GUICtrlRead ($Input_149)
			GUICtrlSetData($Input_149, "Unit")
			$Station = "Phone 3"
			RecordStuff()
		
		Case $msg = $Button_151
            $Timer31Active = 1
            $timer31 = TimerInit()
        Case $msg = $Button_152
            $Timer31Active = 0
            GUICtrlSetData($Label_155, "00:00:00")
			GUICtrlSetColor($Label_155,0x000000)
			$Name = GUICtrlRead ($Input_153)
			GUICtrlSetData($Input_153, "Name")
			$Unit = GUICtrlRead ($Input_154)
			GUICtrlSetData($Input_154, "Unit")
			$Station = "Phone 4"
			RecordStuff()
		
		Case $msg = $Button_156
            $Timer32Active = 1
            $timer32 = TimerInit()
        Case $msg = $Button_157
            $Timer32Active = 0
            GUICtrlSetData($Label_160, "00:00:00")
			GUICtrlSetColor($Label_160,0x000000)
			$Name = GUICtrlRead ($Input_158)
			GUICtrlSetData($Input_158, "Name")
			$Unit = GUICtrlRead ($Input_159)
			GUICtrlSetData($Input_159, "Unit")
			$Station = "Phone 5"
			RecordStuff()
		
		Case $msg = $Button_161
            $Timer33Active = 1
            $timer33 = TimerInit()
        Case $msg = $Button_162
            $Timer33Active = 0
            GUICtrlSetData($Label_165, "00:00:00")
			GUICtrlSetColor($Label_165,0x000000)
			$Name = GUICtrlRead ($Input_163)
			GUICtrlSetData($Input_163, "Name")
			$Unit = GUICtrlRead ($Input_164)
			GUICtrlSetData($Input_164, "Unit")
			$Station = "Phone 6"
			RecordStuff()

		Case $msg = $Button_166
            $Timer34Active = 1
            $timer34 = TimerInit()
        Case $msg = $Button_167
            $Timer34Active = 0
            GUICtrlSetData($Label_170, "00:00:00")
			GUICtrlSetColor($Label_170,0x000000)
			$Name = GUICtrlRead ($Input_168)
			GUICtrlSetData($Input_168, "Name")
			$Unit = GUICtrlRead ($Input_169)
			GUICtrlSetData($Input_169, "Unit")
			$Station = "Phone 7"
			RecordStuff()

		Case $msg = $Button_171
            $Timer35Active = 1
            $timer35 = TimerInit()
        Case $msg = $Button_172
            $Timer35Active = 0
            GUICtrlSetData($Label_175, "00:00:00")
			GUICtrlSetColor($Label_175,0x000000)
			$Name = GUICtrlRead ($Input_173)
			GUICtrlSetData($Input_173, "Name")
			$Unit = GUICtrlRead ($Input_174)
			GUICtrlSetData($Input_174, "Unit")
			$Station = "Phone 8"
			RecordStuff()

		Case $msg = $Button_176
            $Timer36Active = 1
            $timer36 = TimerInit()
        Case $msg = $Button_177
            $Timer36Active = 0
            GUICtrlSetData($Label_180, "00:00:00")
			GUICtrlSetColor($Label_180,0x000000)
			$Name = GUICtrlRead ($Input_178)
			GUICtrlSetData($Input_178, "Name")
			$Unit = GUICtrlRead ($Input_179)
			GUICtrlSetData($Input_179, "Unit")
			$Station = "Phone 9"
			RecordStuff()

		Case $msg = $Button_181
            $Timer37Active = 1
            $timer37 = TimerInit()
        Case $msg = $Button_182
            $Timer37Active = 0
            GUICtrlSetData($Label_185, "00:00:00")
			GUICtrlSetColor($Label_185,0x000000)
			$Name = GUICtrlRead ($Input_183)
			GUICtrlSetData($Input_183, "Name")
			$Unit = GUICtrlRead ($Input_184)
			GUICtrlSetData($Input_184, "Unit")
			$Station = "Phone 10"
			RecordStuff()

		Case $msg = $Button_186
            $Timer38Active = 1
            $timer38 = TimerInit()
        Case $msg = $Button_187
            $Timer38Active = 0
            GUICtrlSetData($Label_190, "00:00:00")
			GUICtrlSetColor($Label_190,0x000000)
			$Name = GUICtrlRead ($Input_188)
			GUICtrlSetData($Input_188, "Name")
			$Unit = GUICtrlRead ($Input_189)
			GUICtrlSetData($Input_189, "Unit")
			$Station = "Phone 11"
			RecordStuff()

		Case $msg = $Button_191
            $Timer39Active = 1
            $timer39 = TimerInit()
        Case $msg = $Button_192
            $Timer39Active = 0
            GUICtrlSetData($Label_195, "00:00:00")
			GUICtrlSetColor($Label_195,0x000000)
			$Name = GUICtrlRead ($Input_193)
			GUICtrlSetData($Input_193, "Name")
			$Unit = GUICtrlRead ($Input_194)
			GUICtrlSetData($Input_194, "Unit")
			$Station = "Phone 12"
			RecordStuff()

		Case $msg = $Button_196
            $Timer40Active = 1
            $timer40 = TimerInit()
        Case $msg = $Button_197
            $Timer40Active = 0
            GUICtrlSetData($Label_200, "00:00:00")
			GUICtrlSetColor($Label_200,0x000000)
			$Name = GUICtrlRead ($Input_198)
			GUICtrlSetData($Input_198, "Name")
			$Unit = GUICtrlRead ($Input_199)
			GUICtrlSetData($Input_199, "Unit")
			$Station = "Phone 13"
			RecordStuff()

		Case $msg = $Button_201
            $Timer41Active = 1
            $timer41 = TimerInit()
        Case $msg = $Button_202
            $Timer41Active = 0
            GUICtrlSetData($Label_205, "00:00:00")
			GUICtrlSetColor($Label_205,0x000000)
			$Name = GUICtrlRead ($Input_203)
			GUICtrlSetData($Input_203, "Name")
			$Unit = GUICtrlRead ($Input_204)
			GUICtrlSetData($Input_204, "Unit")
			$Station = "Phone 14"
			RecordStuff()

		Case $msg = $Button_206
            $Timer42Active = 1
            $timer42 = TimerInit()
        Case $msg = $Button_207
            $Timer42Active = 0
            GUICtrlSetData($Label_210, "00:00:00")
			GUICtrlSetColor($Label_210,0x000000)
			$Name = GUICtrlRead ($Input_208)
			GUICtrlSetData($Input_208, "Name")
			$Unit = GUICtrlRead ($Input_209)
			GUICtrlSetData($Input_209, "Unit")
			$Station = "Phone 15"
			RecordStuff()

		Case $msg = $Button_211
            $Timer43Active = 1
            $timer43 = TimerInit()
        Case $msg = $Button_212
            $Timer43Active = 0
            GUICtrlSetData($Label_215, "00:00:00")
			GUICtrlSetColor($Label_215,0x000000)
			$Name = GUICtrlRead ($Input_213)
			GUICtrlSetData($Input_213, "Name")
			$Unit = GUICtrlRead ($Input_214)
			GUICtrlSetData($Input_214, "Unit")
			$Station = "Phone 16"
			RecordStuff()

		Case $msg = $Button_216
            $Timer44Active = 1
            $Timer44 = TimerInit()
        Case $msg = $Button_217
            $Timer44Active = 0
            GUICtrlSetData($Label_220, "00:00:00")
			GUICtrlSetColor($Label_220,0x000000)
			$Name = GUICtrlRead ($Input_218)
			GUICtrlSetData($Input_218, "Name")
			$Unit = GUICtrlRead ($Input_219)
			GUICtrlSetData($Input_218, "Unit")
			$Station = "Phone 17"
			RecordStuff()

		Case $msg = $Button_221
            $Timer45Active = 1
            $timer45 = TimerInit()
        Case $msg = $Button_222
            $Timer45Active = 0
            GUICtrlSetData($Label_225, "00:00:00")
			GUICtrlSetColor($Label_225,0x000000)
			$Name = GUICtrlRead ($Input_223)
			GUICtrlSetData($Input_223, "Name")
			$Unit = GUICtrlRead ($Input_224)
			GUICtrlSetData($Input_224, "Unit")
			$Station = "Phone 18"
			RecordStuff()

		Case $msg = $Button_226
            $Timer46Active = 1
            $timer46 = TimerInit()
        Case $msg = $Button_227
            $Timer46Active = 0
            GUICtrlSetData($Label_230, "00:00:00")
			GUICtrlSetColor($Label_230,0x000000)
			$Name = GUICtrlRead ($Input_228)
			GUICtrlSetData($Input_228, "Name")
			$Unit = GUICtrlRead ($Input_229)
			GUICtrlSetData($Input_229, "Unit")
			$Station = "PC 1"
			RecordStuff()

		Case $msg = $Button_231
            $Timer47Active = 1
            $timer47 = TimerInit()
        Case $msg = $Button_232
            $Timer47Active = 0
            GUICtrlSetData($Label_235, "00:00:00")
			GUICtrlSetColor($Label_235,0x000000)
			$Name = GUICtrlRead ($Input_233)
			GUICtrlSetData($Input_233, "Name")
			$Unit = GUICtrlRead ($Input_234)
			GUICtrlSetData($Input_234, "Unit")
			$Station = "PC 2"
			RecordStuff()

		Case $msg = $Button_236
            $Timer48Active = 1
            $timer48 = TimerInit()
        Case $msg = $Button_237
            $Timer48Active = 0
            GUICtrlSetData($Label_240, "00:00:00")
			GUICtrlSetColor($Label_240,0x000000)
			$Name = GUICtrlRead ($Input_238)
			GUICtrlSetData($Input_238, "Name")
			$Unit = GUICtrlRead ($Input_239)
			GUICtrlSetData($Input_239, "Unit")
			$Station = "PC 3"
			RecordStuff()

		Case $msg = $Button_241
            $Timer49Active = 1
            $timer49 = TimerInit()
        Case $msg = $Button_242
            $Timer49Active = 0
            GUICtrlSetData($Label_245, "00:00:00")
			GUICtrlSetColor($Label_245,0x000000)
			$Name = GUICtrlRead ($Input_243)
			GUICtrlSetData($Input_243, "Name")
			$Unit = GUICtrlRead ($Input_244)
			GUICtrlSetData($Input_244, "Unit")
			$Station = "PC 4"
			RecordStuff()

		Case $msg = $Button_246
            $Timer50Active = 1
            $timer50 = TimerInit()
        Case $msg = $Button_247
            $Timer50Active = 0
            GUICtrlSetData($Label_250, "00:00:00")
			GUICtrlSetColor($Label_250,0x000000)
			$Name = GUICtrlRead ($Input_248)
			GUICtrlSetData($Input_248, "Name")
			$Unit = GUICtrlRead ($Input_249)
			GUICtrlSetData($Input_249, "Unit")
			$Station = "PC 5"
			RecordStuff()

		Case $msg = $Button_251
            $Timer51Active = 1
            $timer51 = TimerInit()
        Case $msg = $Button_252
            $Timer51Active = 0
            GUICtrlSetData($Label_255, "00:00:00")
			GUICtrlSetColor($Label_255,0x000000)
			$Name = GUICtrlRead ($Input_253)
			GUICtrlSetData($Input_253, "Name")
			$Unit = GUICtrlRead ($Input_254)
			GUICtrlSetData($Input_254, "Unit")
			$Station = "PC 6"
			RecordStuff()
        Case $msg = $GUI_EVENT_CLOSE
    EndSelect
    If $msg = $GUI_EVENT_CLOSE Then ExitLoop
WEnd
	
Func AllTimers()
Local $Secs, $Mins, $Hour
	
Local $Time1, $Time2, $Time3, $Time4, $Time5, $Time6, $Time7, $Time8, $Time9, $Time10, $Time11, $Time12, $Time13, $Time14, $Time15, $Time16, $Time17, $Time18
Local $Time19, $Time20 ,$Time21, $Time22, $Time23, $Time24, $Time25, $Time26, $Time27, $Time28, $Time29, $Time30, $Time31, $Time32, $Time32, $Time33, $Time34
Local $Time35, $Time36 ,$Time37, $Time38, $Time39, $Time40, $Time41, $Time42, $Time43, $Time44, $Time45, $Time46, $Time47, $Time48, $Time49, $Time50, $Time51
	
Local $sTime1 = $Time1, $sTime2 = $Time2, $sTime3 = $Time3, $sTime4 = $Time4, $sTime5 = $Time5, $sTime6 = $Time6, $sTime7 = $Time7, $sTime8 = $Time8
Local $sTime9 = $Time9, $sTime10 = $Time10, $sTime11 = $Time11, $sTime12 = $Time12, $sTime13 = $Time13, $sTime14 = $Time14, $sTime15 = $Time15, $sTime16 = $Time16
Local $sTime17 = $Time17, $sTime18 = $Time18, $sTime19 = $Time19, $sTime20 = $Time20, $sTime21 = $Time21, $sTime22 = $Time22, $sTime23 = $Time23, $sTime24 = $Time24
Local $sTime25 = $Time25, $sTime26 = $Time26, $sTime27 = $Time27, $sTime28 = $Time28, $sTime29 = $Time29, $sTime30 = $Time30, $sTime31 = $Time31, $sTime32 = $Time32
Local $sTime33 = $Time33, $sTime34 = $Time34, $sTime35 = $Time35, $sTime36 = $Time36, $sTime37 = $Time37, $sTime38 = $Time38, $sTime39 = $Time39, $sTime40 = $Time40
Local $sTime41 = $Time41, $sTime42 = $Time42, $sTime43 = $Time43, $sTime44 = $Time44, $sTime45 = $Time45, $sTime46 = $Time46, $sTime47 = $Time47, $sTime48 = $Time48
Local $sTime49 = $Time49, $sTime50 = $Time50, $sTime51 = $Time51

    If $Timer1Active Then
        _TicksToTime(Int(TimerDiff($timer1)), $Hour, $Mins, $Secs)
        $Time1 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime1 <> $Time1 Then GUICtrlSetData($Label_5, $Time1)
		If $Mins = 30 Then GUICtrlSetColor($Label_5, 0xff0000)
		$TotalTime = $Time1
	EndIf
	
    If $Timer2Active Then
        _TicksToTime(Int(TimerDiff($timer2)), $Hour, $Mins, $Secs)
        $Time2 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime2 <> $Time2 Then GUICtrlSetData($Label_8, $Time2)
		If $Mins = 30 Then GUICtrlSetColor($Label_8, 0xff0000)
	EndIf
	
	If $Timer3Active Then
        _TicksToTime(Int(TimerDiff($timer3)), $Hour, $Mins, $Secs)
        $Time3 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime3 <> $Time3 Then GUICtrlSetData($Label_15, $Time3)
		If $Mins = 30 Then GUICtrlSetColor($Label_15, 0xff0000)
		EndIf
		
	If $Timer4Active Then
        _TicksToTime(Int(TimerDiff($timer4)), $Hour, $Mins, $Secs)
        $Time4 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime4 <> $Time4 Then GUICtrlSetData($Label_20, $Time4)
		If $Mins = 30 Then GUICtrlSetColor($Label_20, 0xff0000)
	EndIf
		
	If $Timer5Active Then
        _TicksToTime(Int(TimerDiff($timer5)), $Hour, $Mins, $Secs)
        $Time5 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime5 <> $Time5 Then GUICtrlSetData($Label_25, $Time5)
		If $Mins = 30 Then GUICtrlSetColor($Label_25, 0xff0000)
		EndIf
		
	If $Timer6Active Then
        _TicksToTime(Int(TimerDiff($timer6)), $Hour, $Mins, $Secs)
        $Time6 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime6 <> $Time6 Then GUICtrlSetData($Label_30, $Time6)
		If $Mins = 30 Then GUICtrlSetColor($Label_30, 0xff0000)
	EndIf
		
	If $Timer7Active Then
        _TicksToTime(Int(TimerDiff($timer7)), $Hour, $Mins, $Secs)
        $Time7 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime7 <> $Time7 Then GUICtrlSetData($Label_35, $Time7)
		If $Mins = 30 Then GUICtrlSetColor($Label_35, 0xff0000)
	EndIf
		
	If $Timer8Active Then
        _TicksToTime(Int(TimerDiff($timer8)), $Hour, $Mins, $Secs)
        $Time8 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime8 <> $Time8 Then GUICtrlSetData($Label_40, $Time8)
		If $Mins = 30 Then GUICtrlSetColor($Label_40, 0xff0000)
	EndIf
		
	If $Timer9Active Then
        _TicksToTime(Int(TimerDiff($timer9)), $Hour, $Mins, $Secs)
        $Time9 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime9 <> $Time9 Then GUICtrlSetData($Label_45, $Time9)
		If $Mins = 30 Then GUICtrlSetColor($Label_45, 0xff0000)
	EndIf
		
	If $Timer10Active Then
        _TicksToTime(Int(TimerDiff($timer10)), $Hour, $Mins, $Secs)
        $Time10 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
		If $sTime10 <> $Time10 Then GUICtrlSetData($Label_46, $Time10)
		If $Mins = 30 Then GUICtrlSetColor($Label_46, 0xff0000)
	EndIf
		
	If $Timer11Active Then
        _TicksToTime(Int(TimerDiff($timer11)), $Hour, $Mins, $Secs)
        $Time11 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime11 <> $Time11 Then GUICtrlSetData($Label_55, $Time11)
		If $Mins = 30 Then GUICtrlSetColor($Label_55, 0xff0000)
		EndIf
		
	If $Timer12Active Then
        _TicksToTime(Int(TimerDiff($timer12)), $Hour, $Mins, $Secs)
        $Time12 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime12 <> $Time12 Then GUICtrlSetData($Label_60, $Time12)
		If $Mins = 30 Then GUICtrlSetColor($Label_60, 0xff0000)
	EndIf
		
	If $Timer13Active Then
        _TicksToTime(Int(TimerDiff($timer13)), $Hour, $Mins, $Secs)
        $Time13 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime13 <> $Time13 Then GUICtrlSetData($Label_65, $Time13)
		If $Mins = 30 Then GUICtrlSetColor($Label_65, 0xff0000)
	EndIf
		
	If $Timer14Active Then
        _TicksToTime(Int(TimerDiff($timer14)), $Hour, $Mins, $Secs)
        $Time14 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime14 <> $Time14 Then GUICtrlSetData($Label_70, $Time14)
		If $Mins = 30 Then GUICtrlSetColor($Label_70, 0xff0000)
	EndIf
		
	If $Timer15Active Then
        _TicksToTime(Int(TimerDiff($timer15)), $Hour, $Mins, $Secs)
        $Time15 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime15 <> $Time15 Then GUICtrlSetData($Label_75, $Time15)
		If $Mins = 30 Then GUICtrlSetColor($Label_75, 0xff0000)
	EndIf
		
	If $Timer16Active Then
        _TicksToTime(Int(TimerDiff($timer16)), $Hour, $Mins, $Secs)
        $Time16 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime16 <> $Time16 Then GUICtrlSetData($Label_80, $Time16)
		If $Mins = 30 Then GUICtrlSetColor($Label_80, 0xff0000)
	EndIf
		
	If $Timer17Active Then
        _TicksToTime(Int(TimerDiff($timer17)), $Hour, $Mins, $Secs)
        $Time17 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime16 <> $Time17 Then GUICtrlSetData($Label_85, $Time17)
		If $Mins = 30 Then GUICtrlSetColor($Label_85, 0xff0000)
	EndIf
		
	If $Timer18Active Then
        _TicksToTime(Int(TimerDiff($timer18)), $Hour, $Mins, $Secs)
        $Time18 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime18 <> $Time18 Then GUICtrlSetData($Label_90, $Time18)
		If $Mins = 30 Then GUICtrlSetColor($Label_90, 0xff0000)
		EndIf
		
	If $Timer19Active Then
        _TicksToTime(Int(TimerDiff($timer19)), $Hour, $Mins, $Secs)
        $Time19 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime19 <> $Time19 Then GUICtrlSetData($Label_95, $Time19)
		If $Mins = 30 Then GUICtrlSetColor($Label_95, 0xff0000)
	EndIf
		
	If $Timer20Active Then
        _TicksToTime(Int(TimerDiff($timer20)), $Hour, $Mins, $Secs)
        $Time20 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime20 <> $Time20 Then GUICtrlSetData($Label_100, $Time20)
		If $Mins = 30 Then GUICtrlSetColor($Label_100, 0xff0000)
	EndIf
	
	If $Timer21Active Then
        _TicksToTime(Int(TimerDiff($timer21)), $Hour, $Mins, $Secs)
        $Time21 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime21 <> $Time21 Then GUICtrlSetData($Label_105, $Time21)
		If $Mins = 30 Then GUICtrlSetColor($Label_105, 0xff0000)
	EndIf
	
	If $Timer22Active Then
        _TicksToTime(Int(TimerDiff($timer22)), $Hour, $Mins, $Secs)
        $Time22 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime22 <> $Time22 Then GUICtrlSetData($Label_110, $Time22)
		If $Mins = 30 Then GUICtrlSetColor($Label_110, 0xff0000)
	EndIf
	
	If $Timer23Active Then
        _TicksToTime(Int(TimerDiff($timer23)), $Hour, $Mins, $Secs)
        $Time23 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime23 <> $Time23 Then GUICtrlSetData($Label_115, $Time23)
		If $Mins = 30 Then GUICtrlSetColor($Label_115, 0xff0000)
	EndIf
		
	If $Timer24Active Then
        _TicksToTime(Int(TimerDiff($timer24)), $Hour, $Mins, $Secs)
        $Time24 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime24 <> $Time24 Then GUICtrlSetData($Label_120, $Time24)
		If $Mins = 30 Then GUICtrlSetColor($Label_120, 0xff0000)
	EndIf
	
	If $Timer25Active Then
        _TicksToTime(Int(TimerDiff($timer25)), $Hour, $Mins, $Secs)
        $Time25 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime25 <> $Time25 Then GUICtrlSetData($Label_125, $Time25)
		If $Mins = 30 Then GUICtrlSetColor($Label_125, 0xff0000)
	EndIf
		
	If $Timer26Active Then
        _TicksToTime(Int(TimerDiff($timer26)), $Hour, $Mins, $Secs)
        $Time26 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime26 <> $Time26 Then GUICtrlSetData($Label_130, $Time26)
		If $Mins = 30 Then GUICtrlSetColor($Label_130, 0xff0000)
	EndIf
	
	If $Timer27Active Then
        _TicksToTime(Int(TimerDiff($timer27)), $Hour, $Mins, $Secs)
        $Time27 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime27 <> $Time27 Then GUICtrlSetData($Label_135, $Time27)
		If $Mins = 30 Then GUICtrlSetColor($Label_135, 0xff0000)
	EndIf
	
	If $Timer28Active Then
        _TicksToTime(Int(TimerDiff($timer28)), $Hour, $Mins, $Secs)
        $Time28 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime28 <> $Time28 Then GUICtrlSetData($Label_140, $Time28)
		If $Mins = 15 Then GUICtrlSetColor($Label_140, 0xff0000)
	EndIf
	
	If $Timer29Active Then
        _TicksToTime(Int(TimerDiff($timer29)), $Hour, $Mins, $Secs)
        $Time29 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime29 <> $Time29 Then GUICtrlSetData($Label_145, $Time29)
		If $Mins = 15 Then GUICtrlSetColor($Label_145, 0xff0000)
	EndIf
	
	If $Timer30Active Then
        _TicksToTime(Int(TimerDiff($timer30)), $Hour, $Mins, $Secs)
        $Time30 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime30 <> $Time30 Then GUICtrlSetData($Label_150, $Time30)
		If $Mins = 15 Then GUICtrlSetColor($Label_150, 0xff0000)
	EndIf
	
	If $Timer31Active Then
        _TicksToTime(Int(TimerDiff($timer31)), $Hour, $Mins, $Secs)
        $Time31 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime31 <> $Time31 Then GUICtrlSetData($Label_155, $Time31)
		If $Mins = 15 Then GUICtrlSetColor($Label_155, 0xff0000)
	EndIf
	
	If $Timer32Active Then
        _TicksToTime(Int(TimerDiff($timer32)), $Hour, $Mins, $Secs)
        $Time32 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime32 <> $Time32 Then GUICtrlSetData($Label_160, $Time32)
		If $Mins = 15 Then GUICtrlSetColor($Label_160, 0xff0000)
	EndIf
	
	If $Timer33Active Then
        _TicksToTime(Int(TimerDiff($timer33)), $Hour, $Mins, $Secs)
        $Time33 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime33 <> $Time33 Then GUICtrlSetData($Label_165, $Time33)
		If $Mins = 15 Then GUICtrlSetColor($Label_165, 0xff0000)
		EndIf

	If $Timer34Active Then
        _TicksToTime(Int(TimerDiff($timer34)), $Hour, $Mins, $Secs)
        $Time34 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime34 <> $Time34 Then GUICtrlSetData($Label_170, $Time34)
		If $Mins = 15 Then GUICtrlSetColor($Label_170, 0xff0000)
	EndIf

	If $Timer35Active Then
        _TicksToTime(Int(TimerDiff($timer35)), $Hour, $Mins, $Secs)
        $Time35 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime35 <> $Time35 Then GUICtrlSetData($Label_175, $Time35)
		If $Mins = 15 Then GUICtrlSetColor($Label_175, 0xff0000)
	EndIf

	If $Timer36Active Then
        _TicksToTime(Int(TimerDiff($timer36)), $Hour, $Mins, $Secs)
        $Time36 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime36 <> $Time36 Then GUICtrlSetData($Label_180, $Time36)
		If $Mins = 15 Then GUICtrlSetColor($Label_180, 0xff0000)
	EndIf

	If $Timer37Active Then
        _TicksToTime(Int(TimerDiff($timer37)), $Hour, $Mins, $Secs)
        $Time37 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime37 <> $Time37 Then GUICtrlSetData($Label_185, $Time37)
		If $Mins = 15 Then GUICtrlSetColor($Label_185, 0xff0000)
	EndIf

	If $Timer38Active Then
        _TicksToTime(Int(TimerDiff($timer38)), $Hour, $Mins, $Secs)
        $Time38 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime38 <> $Time38 Then GUICtrlSetData($Label_190, $Time38)
		If $Mins = 15 Then GUICtrlSetColor($Label_190, 0xff0000)
    EndIf
	
	If $Timer39Active Then
        _TicksToTime(Int(TimerDiff($timer39)), $Hour, $Mins, $Secs)
        $Time39 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime39 <> $Time39 Then GUICtrlSetData($Label_195, $Time39)
		If $Mins = 15 Then GUICtrlSetColor($Label_195, 0xff0000)
    EndIf
	
	If $Timer40Active Then
        _TicksToTime(Int(TimerDiff($timer40)), $Hour, $Mins, $Secs)
        $Time40 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime40 <> $Time40 Then GUICtrlSetData($Label_200, $Time40)
		If $Mins = 15 Then GUICtrlSetColor($Label_200, 0xff0000)
    EndIf
	
	If $Timer41Active Then
        _TicksToTime(Int(TimerDiff($timer41)), $Hour, $Mins, $Secs)
        $Time41 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime41 <> $Time41 Then GUICtrlSetData($Label_205, $Time41)
		If $Mins = 15 Then GUICtrlSetColor($Label_205, 0xff0000)
    EndIf
	
	If $Timer42Active Then
        _TicksToTime(Int(TimerDiff($timer42)), $Hour, $Mins, $Secs)
        $Time42 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime42 <> $Time42 Then GUICtrlSetData($Label_210, $Time42)
		If $Mins = 15 Then GUICtrlSetColor($Label_210, 0xff0000)
    EndIf
	
	If $Timer43Active Then
        _TicksToTime(Int(TimerDiff($timer43)), $Hour, $Mins, $Secs)
        $Time43 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime43 <> $Time43 Then GUICtrlSetData($Label_215, $Time43)
		If $Mins = 15 Then GUICtrlSetColor($Label_215, 0xff0000)
    EndIf
	
	If $Timer44Active Then
        _TicksToTime(Int(TimerDiff($timer44)), $Hour, $Mins, $Secs)
        $Time44 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime44 <> $Time44 Then GUICtrlSetData($Label_220, $Time44)
		If $Mins = 15 Then GUICtrlSetColor($Label_220, 0xff0000)
    EndIf
	
	If $Timer45Active Then
        _TicksToTime(Int(TimerDiff($timer45)), $Hour, $Mins, $Secs)
        $Time45 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime45 <> $Time45 Then GUICtrlSetData($Label_225, $Time45)
		If $Mins = 15 Then GUICtrlSetColor($Label_225, 0xff0000)
	EndIf

	If $Timer46Active Then
        _TicksToTime(Int(TimerDiff($timer46)), $Hour, $Mins, $Secs)
        $Time46 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime46 <> $Time46 Then GUICtrlSetData($Label_230, $Time46)
		If $Mins = 30 Then GUICtrlSetColor($Label_230, 0xff0000)
	EndIf

	If $Timer47Active Then
        _TicksToTime(Int(TimerDiff($timer47)), $Hour, $Mins, $Secs)
        $Time47 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime47 <> $Time47 Then GUICtrlSetData($Label_235, $Time47)
		If $Mins = 30 Then GUICtrlSetColor($Label_235, 0xff0000)
	EndIf

	If $Timer48Active Then
        _TicksToTime(Int(TimerDiff($timer48)), $Hour, $Mins, $Secs)
        $Time48 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime48 <> $Time48 Then GUICtrlSetData($Label_240, $Time48)
		If $Mins = 30 Then GUICtrlSetColor($Label_240, 0xff0000)
	EndIf

	If $Timer49Active Then
        _TicksToTime(Int(TimerDiff($timer49)), $Hour, $Mins, $Secs)
        $Time49 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime49 <> $Time49 Then GUICtrlSetData($Label_245, $Time49)
		If $Mins = 30 Then GUICtrlSetColor($Label_245, 0xff0000)
	EndIf
	
	If $Timer50Active Then
        _TicksToTime(Int(TimerDiff($timer50)), $Hour, $Mins, $Secs)
        $Time50 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime50 <> $Time50 Then GUICtrlSetData($Label_250, $Time50)
		If $Mins = 30 Then GUICtrlSetColor($Label_250, 0xff0000)
	EndIf
	
	If $Timer51Active Then
        _TicksToTime(Int(TimerDiff($timer51)), $Hour, $Mins, $Secs)
        $Time51 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime51 <> $Time51 Then GUICtrlSetData($Label_255, $Time51)
		If $Mins = 30 Then GUICtrlSetColor($Label_255, 0xff0000)
	EndIf
EndFunc

Func RecordStuff ()
	$LogStuff = FileOpen ("logfile.txt", 1)
	FileWriteLine ($LogStuff, "Station: " & $Unit & @CRLF)
	FileWriteLine ($LogStuff, "User name: " & $Name & @CRLF)
	FileWriteLine ($LogStuff, "Unit: " & $Name & @CRLF)
	FileWriteLine ($LogStuff, "Total time: " & $TotalTime & @CRLF & @CRLF)
	FileClose ($LogStuff)
EndFunc
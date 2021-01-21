#include <GUIConstants.au3>
#include <Date.au3>

Dim $Timer1Active = 0, $Timer2Active = 0, $Timer3Active = 0, $Timer4Active = 0, $Timer5Active = 0, $Timer6Active = 0, $Timer7Active = 0, $Timer8Active = 0
Dim $Timer9Active = 0, $Timer10Active = 0, $Timer11Active = 0, $Timer12Active = 0, $Timer13Active = 0, $Timer14Active = 0, $Timer15Active = 0, $Timer16Active = 0
Dim $Timer17Active = 0, $Timer18Active = 0, $Timer19Active = 0, $Timer20Active = 0, $Timer21Active = 0, $Timer22Active = 0, $Timer23Active = 0, $Timer24Active = 0
Dim $Timer25Active = 0, $Timer26Active = 0, $Timer27Active = 0, $Timer28Active = 0, $Timer29Active = 0, $Timer30Active = 0, $Timer31Active = 0, $Timer32Active = 0
Dim $Timer33Active = 0

Global $Name, $TotalTime, $Unit

$Log = FileOpen ("logfile.txt", 1)
FileWriteLine ($Log, "Logfile started: " & _DateTimeFormat( _NowCalc(),0) & @CRLF &  @CRLF)
FileClose ($Log)

AdlibEnable("AllTimers", 500)

GuiCreate("Net Cafe' Log by TSgt Farrell", 981, 470)

;Top computer label
GuiCtrlCreateLabel("Computers", 0, 0, 980, 20, $SS_CENTER, $WS_EX_STATICEDGE)
GUICtrlSetFont(3, 12)
GUICtrlSetColor(3, 000000)
GUICtrlSetBkColor(3, 999999)

;Input 1
$Button_2 = GuiCtrlCreateButton("Start", 0, 70, 50, 20)
$Button_3 = GuiCtrlCreateButton("Stop", 50, 70, 50, 20)
$Input_4 = GuiCtrlCreateInput("", 0, 90, 100, 20, 0x1000)
$Label_5 = GuiCtrlCreateLabel("", 0, 40, 100, 30, 0x1000)
GUICtrlSetFont (7, 16)
GUICtrlSetData($Label_5, "00:00:00")
GuiCtrlCreateLabel("Computer 1", 0, 20, 100, 20, $SS_CENTER)
;Input 2
$Button_7 = GuiCtrlCreateButton("Start", 110, 70, 50, 20)
$Button_8 = GuiCtrlCreateButton("Stop", 160, 70, 50, 20)
$Label_9 = GuiCtrlCreateLabel("", 110, 40, 100, 30, 0x1000)
$Input_10 = GuiCtrlCreateInput("", 110, 90, 100, 20, 0x1000)
GUICtrlSetFont (11, 16)
GUICtrlSetData($Label_9, "00:00:00")
GuiCtrlCreateLabel("Computer 2", 110, 20, 100, 20, $SS_CENTER)
;Input 3
$Button_12 = GuiCtrlCreateButton("Start", 220, 70, 50, 20)
$Button_13 = GuiCtrlCreateButton("Stop", 270, 70, 50, 20)
$Input_14 = GuiCtrlCreateInput("", 220, 90, 100, 20, 0x1000)
$Label_15 = GuiCtrlCreateLabel("", 220, 40, 100, 30, 0x1000)
GUICtrlSetFont (17, 16)
GUICtrlSetData($Label_15, "00:00:00")
GuiCtrlCreateLabel("Computer 3", 220, 20, 100, 20, $SS_CENTER)
;Input 4
$Button_17 = GuiCtrlCreateButton("Start", 330, 70, 50, 20)
$Button_18 = GuiCtrlCreateButton("Stop", 380, 70, 50, 20)
$Input_19 = GuiCtrlCreateInput("", 330, 90, 100, 20, 0x1000)
$Label_20 = GuiCtrlCreateLabel("", 330, 40, 100, 30, 0x1000)
GUICtrlSetFont (22, 16)
GUICtrlSetData($Label_20, "00:00:00")
GuiCtrlCreateLabel("Computer 4", 330, 20, 100, 20, $SS_CENTER)
;Input 5
$Button_22 = GuiCtrlCreateButton("Start", 440, 70, 50, 20)
$Button_23 = GuiCtrlCreateButton("Stop", 490, 70, 50, 20)
$Input_24 = GuiCtrlCreateInput("", 440, 90, 100, 20, 0x1000)
$Label_25 = GuiCtrlCreateLabel("", 440, 40, 100, 30, 0x1000)
GUICtrlSetFont (27, 16)
GUICtrlSetData($Label_25, "00:00:00")
GuiCtrlCreateLabel("Computer 5", 440, 20, 100, 20, $SS_CENTER)
;Input 6
$Button_27 = GuiCtrlCreateButton("Start", 550, 70, 50, 20)
$Button_28 = GuiCtrlCreateButton("Stop", 600, 70, 50, 20)
$Input_29 = GuiCtrlCreateInput("", 550, 90, 100, 20, 0x1000)
$Label_30 = GuiCtrlCreateLabel("", 550, 40, 100, 30, 0x1000)
GUICtrlSetFont (32, 16)
GUICtrlSetData($Label_30, "00:00:00")
GuiCtrlCreateLabel("Computer 6", 550, 20, 100, 20, $SS_CENTER)
;Input 7
$Button_32 = GuiCtrlCreateButton("Start", 660, 70, 50, 20)
$Button_33 = GuiCtrlCreateButton("Stop", 710, 70, 50, 20)
$Input_34 = GuiCtrlCreateInput("", 660, 90, 100, 20, 0x1000)
$Label_35 = GuiCtrlCreateLabel("", 660, 40, 100, 30, 0x1000)
GUICtrlSetFont (37, 16)
GUICtrlSetData($Label_35, "00:00:00")
GuiCtrlCreateLabel("Computer 7", 660, 20, 100, 20, $SS_CENTER)
;Input 8
$Button_37 = GuiCtrlCreateButton("Start", 770, 70, 50, 20)
$Button_38 = GuiCtrlCreateButton("Stop", 820, 70, 50, 20)
$Input_39 = GuiCtrlCreateInput("", 770, 90, 100, 20, 0x1000)
$Label_40 = GuiCtrlCreateLabel("", 770, 40, 100, 30, 0x1000)
GUICtrlSetFont (42, 16)
GUICtrlSetData($Label_40, "00:00:00")
GuiCtrlCreateLabel("Computer 8", 770, 20, 100, 20, $SS_CENTER)
;Input 9
$Button_42 = GuiCtrlCreateButton("Start", 880, 70, 50, 20)
$Button_43 = GuiCtrlCreateButton("Stop", 930, 70, 50, 20)
$Input_44 = GuiCtrlCreateInput("", 880, 90, 100, 20, 0x1000)
$Label_45 = GuiCtrlCreateLabel("", 880, 40, 100, 30, 0x1000)
GUICtrlSetFont (47, 16)
GUICtrlSetData($Label_45, "00:00:00")
GuiCtrlCreateLabel("Computer 9", 880, 20, 100, 20, $SS_CENTER)
;Input 10
GuiCtrlCreateLabel("Computer 10", 0, 120, 100, 20, $SS_CENTER)
$Label_48 = GuiCtrlCreateLabel("", 0, 140, 100, 30, 0x1000)
$Button_49 = GuiCtrlCreateButton("Start", 0, 170, 50, 20)
$Button_50 = GuiCtrlCreateButton("Stop", 50, 170, 50, 20)
$Input_51 = GuiCtrlCreateInput("", 0, 190, 100, 20, 0x1000)
GUICtrlSetFont (50, 16)
GUICtrlSetData($Label_48, "00:00:00")
;Input 11
$Button_52 = GuiCtrlCreateButton("Start", 110, 170, 50, 20)
$Button_53 = GuiCtrlCreateButton("Stop", 160, 170, 50, 20)
$Input_54 = GuiCtrlCreateInput("", 110, 190, 100, 20, 0x1000)
$Label_55 = GuiCtrlCreateLabel("", 110, 140, 100, 30, 0x1000)
GUICtrlSetFont (57, 16)
GUICtrlSetData($Label_55, "00:00:00")
GuiCtrlCreateLabel("Computer 11", 110, 120, 100, 20, $SS_CENTER)
;Input 12
$Button_57 = GuiCtrlCreateButton("Start", 220, 170, 50, 20)
$Button_58 = GuiCtrlCreateButton("Stop", 270, 170, 50, 20)
$Input_59 = GuiCtrlCreateInput("", 220, 190, 100, 20, 0x1000)
$Label_60 = GuiCtrlCreateLabel("", 220, 140, 100, 30, 0x1000)
GUICtrlSetFont (62, 16)
GUICtrlSetData($Label_60, "00:00:00")
GuiCtrlCreateLabel("Computer 12", 220, 120, 100, 20, $SS_CENTER)
;Input 13
$Button_62 = GuiCtrlCreateButton("Start", 330, 170, 50, 20)
$Button_63 = GuiCtrlCreateButton("Stop", 380, 170, 50, 20)
$Input_64 = GuiCtrlCreateInput("", 330, 190, 100, 20, 0x1000)
$Label_65 = GuiCtrlCreateLabel("", 330, 140, 100, 30, 0x1000)
GUICtrlSetFont (67, 16)
GUICtrlSetData($Label_65, "00:00:00")
GuiCtrlCreateLabel("Computer 13", 330, 120, 100, 20, $SS_CENTER)
;Input 14
$Button_67 = GuiCtrlCreateButton("Start", 440, 170, 50, 20)
$Button_68 = GuiCtrlCreateButton("Stop", 490, 170, 50, 20)
$Input_69 = GuiCtrlCreateInput("", 440, 190, 100, 20, 0x1000)
$Label_70 = GuiCtrlCreateLabel("", 440, 140, 100, 30, 0x1000)
GUICtrlSetFont (72, 16)
GUICtrlSetData($Label_70, "00:00:00")
GuiCtrlCreateLabel("Computer 14", 440, 120, 100, 20, $SS_CENTER)
;Input 15
$Button_72 = GuiCtrlCreateButton("Start", 550, 170, 50, 20)
$Button_73 = GuiCtrlCreateButton("Stop", 600, 170, 50, 20)
$Input_74 = GuiCtrlCreateInput("", 550, 190, 100, 20, 0x1000)
$Label_75 = GuiCtrlCreateLabel("", 550, 140, 100, 30, 0x1000)
GUICtrlSetFont (77, 16)
GUICtrlSetData($Label_75, "00:00:00")
GuiCtrlCreateLabel("Computer 15", 550, 120, 100, 20, $SS_CENTER)
;Input 16
$Button_77 = GuiCtrlCreateButton("Start", 660, 170, 50, 20)
$Button_78 = GuiCtrlCreateButton("Stop", 710, 170, 50, 20)
$Input_79 = GuiCtrlCreateInput("", 660, 190, 100, 20, 0x1000)
$Label_80 = GuiCtrlCreateLabel("", 660, 140, 100, 30, 0x1000)
GUICtrlSetFont (82, 16)
GUICtrlSetData($Label_80, "00:00:00")
GuiCtrlCreateLabel("Computer 16", 660, 120, 100, 20, $SS_CENTER)
;Input 17
$Button_82 = GuiCtrlCreateButton("Start", 770, 170, 50, 20)
$Button_83 = GuiCtrlCreateButton("Stop", 820, 170, 50, 20)
$Input_84 = GuiCtrlCreateInput("", 770, 190, 100, 20, 0x1000)
$Label_85 = GuiCtrlCreateLabel("", 770, 140, 100, 30, 0x1000)
GUICtrlSetFont (87, 16)
GUICtrlSetData($Label_85, "00:00:00")
GuiCtrlCreateLabel("Computer 17", 770, 120, 100, 20, $SS_CENTER)
;Input 18
$Button_87 = GuiCtrlCreateButton("Start", 880, 170, 50, 20)
$Button_88 = GuiCtrlCreateButton("Stop", 930, 170, 50, 20)
$Input_89 = GuiCtrlCreateInput("", 880, 190, 100, 20, 0x1000)
$Label_90 = GuiCtrlCreateLabel("", 880, 140, 100, 30, 0x1000)
GUICtrlSetFont (92, 16)
GUICtrlSetData($Label_90, "00:00:00")
GuiCtrlCreateLabel("Computer 18", 880, 120, 100, 20, $SS_CENTER)

;Middle phones label
GuiCtrlCreateLabel("Phones", 0, 220, 980, 20, $SS_CENTER, $WS_EX_STATICEDGE)
GUICtrlSetFont(94, 12)
GUICtrlSetColor(94, 000000)
GUICtrlSetBkColor(94, 999999)

;Input 19
$Button_93 = GuiCtrlCreateButton("Start", 0, 290, 50, 20)
$Button_94 = GuiCtrlCreateButton("Stop", 50, 290, 50, 20)
$Label_95 = GuiCtrlCreateLabel("", 0, 260, 100, 30, 0x1000)
GuiCtrlCreateLabel("Phone 1", 0, 240, 100, 20, $SS_CENTER)
GUICtrlSetFont (97, 16)
GUICtrlSetData($Label_95, "00:00:00")
$Input_97 = GuiCtrlCreateInput("", 0, 310, 100, 20, 0x1000)
;Input 20
$Button_98 = GuiCtrlCreateButton("Start", 110, 290, 50, 20)
$Button_99 = GuiCtrlCreateButton("Stop", 160, 290, 50, 20)
$Input_100 = GuiCtrlCreateInput("", 110, 310, 100, 20, 0x1000)
$Label_101 = GuiCtrlCreateLabel("", 110, 260, 100, 30, 0x1000)
GUICtrlSetFont (103, 16)
GUICtrlSetData($Label_101, "00:00:00")
GuiCtrlCreateLabel("Phone 2", 110, 240, 100, 20, $SS_CENTER)
;Input 21
$Button_103 = GuiCtrlCreateButton("Start", 220, 290, 50, 20)
$Button_104 = GuiCtrlCreateButton("Stop", 270, 290, 50, 20)
$Input_105 = GuiCtrlCreateInput("", 220, 310, 100, 20, 0x1000)
$Label_106 = GuiCtrlCreateLabel("", 220, 260, 100, 30, 0x1000)
GUICtrlSetFont (108, 16)
GUICtrlSetData($Label_106, "00:00:00")
GuiCtrlCreateLabel("Phone 3", 220, 240, 100, 20, $SS_CENTER)
;Input 22
$Button_108 = GuiCtrlCreateButton("Start", 330, 290, 50, 20)
$Button_109 = GuiCtrlCreateButton("Stop", 380, 290, 50, 20)
$Input_110 = GuiCtrlCreateInput("", 330, 310, 100, 20, 0x1000)
$Label_111 = GuiCtrlCreateLabel("", 330, 260, 100, 30, 0x1000)
GUICtrlSetFont (113, 16)
GUICtrlSetData($Label_111, "00:00:00")
GuiCtrlCreateLabel("Phone 4", 330, 240, 100, 20, $SS_CENTER)
;Input 23
$Button_113 = GuiCtrlCreateButton("Start", 440, 290, 50, 20)
$Button_114 = GuiCtrlCreateButton("Stop", 490, 290, 50, 20)
$Input_115 = GuiCtrlCreateInput("", 440, 310, 100, 20, 0x1000)
$Label_116 = GuiCtrlCreateLabel("", 440, 260, 100, 30, 0x1000)
GUICtrlSetFont (118, 16)
GUICtrlSetData($Label_116, "00:00:00")
GuiCtrlCreateLabel("Phone 5", 440, 240, 100, 20, $SS_CENTER)
;Input 24
$Button_118 = GuiCtrlCreateButton("Start", 550, 290, 50, 20)
$Button_119 = GuiCtrlCreateButton("Stop", 600, 290, 50, 20)
$Input_120 = GuiCtrlCreateInput("", 550, 310, 100, 20, 0x1000)
$Label_121 = GuiCtrlCreateLabel("", 550, 260, 100, 30, 0x1000)
GUICtrlSetFont (123, 16)
GUICtrlSetData($Label_121, "00:00:00")
GuiCtrlCreateLabel("Phone 6", 550, 240, 100, 20, $SS_CENTER)
;Input 25
$Button_123 = GuiCtrlCreateButton("Start", 660, 290, 50, 20)
$Button_124 = GuiCtrlCreateButton("Stop", 710, 290, 50, 20)
$Input_125 = GuiCtrlCreateInput("", 660, 310, 100, 20, 0x1000)
$Label_126 = GuiCtrlCreateLabel("", 660, 260, 100, 30, 0x1000)
GUICtrlSetFont (128, 16)
GUICtrlSetData($Label_126, "00:00:00")
GuiCtrlCreateLabel("Phone 7", 660, 240, 100, 20, $SS_CENTER)
;Input 26
$Button_128 = GuiCtrlCreateButton("Start", 770, 290, 50, 20)
$Button_129 = GuiCtrlCreateButton("Stop", 820, 290, 50, 20)
$Input_130 = GuiCtrlCreateInput("", 770, 310, 100, 20, 0x1000)
$Label_131 = GuiCtrlCreateLabel("", 770, 260, 100, 30, 0x1000)
GUICtrlSetFont (133, 16)
GUICtrlSetData($Label_131, "00:00:00")
GuiCtrlCreateLabel("Phone 8", 770, 240, 100, 20, $SS_CENTER)
;Input 27
$Button_133 = GuiCtrlCreateButton("Start", 880, 290, 50, 20)
$Button_134 = GuiCtrlCreateButton("Stop", 930, 290, 50, 20)
$Input_135 = GuiCtrlCreateInput("", 880, 310, 100, 20, 0x1000)
$Label_136 = GuiCtrlCreateLabel("", 880, 260, 100, 30, 0x1000)
GUICtrlSetFont (138, 16)
GUICtrlSetData($Label_136, "00:00:00")
GuiCtrlCreateLabel("Phone 9", 880, 240, 100, 20, $SS_CENTER)

;Bottom PC label
GuiCtrlCreateLabel("PC's", 0, 340, 980, 20, $SS_CENTER, $WS_EX_STATICEDGE)
GUICtrlSetFont(140, 12)
GUICtrlSetColor(140, 000000)
GUICtrlSetBkColor(140, 999999)

;Input 28
$Button_139 = GuiCtrlCreateButton("Start", 0, 410, 50, 20)
$Button_140 = GuiCtrlCreateButton("Stop", 50, 410, 50, 20)
$Label_141 = GuiCtrlCreateLabel("", 0, 380, 100, 30, 0x1000)
GUICtrlSetFont (143, 16)
GUICtrlSetData($Label_141, "00:00:00")
GuiCtrlCreateLabel("PC 1", 0, 360, 100, 20, $SS_CENTER)
$Input_143 = GuiCtrlCreateInput("", 0, 430, 100, 20, 0x1000)
;Input 29
$Button_144 = GuiCtrlCreateButton("Start", 110, 410, 50, 20)
$Button_145 = GuiCtrlCreateButton("Stop", 160, 410, 50, 20)
$Input_146 = GuiCtrlCreateInput("", 110, 430, 100, 20, 0x1000)
$Label_147 = GuiCtrlCreateLabel("", 110, 380, 100, 30, 0x1000)
GUICtrlSetFont (149, 16)
GUICtrlSetData($Label_147, "00:00:00")
GuiCtrlCreateLabel("PC 2", 110, 360, 100, 20, $SS_CENTER)
;Input 30
$Button_149 = GuiCtrlCreateButton("Start", 220, 410, 50, 20)
$Button_150 = GuiCtrlCreateButton("Stop", 270, 410, 50, 20)
$Input_151 = GuiCtrlCreateInput("", 220, 430, 100, 20, 0x1000)
$Label_152 = GuiCtrlCreateLabel("", 220, 380, 100, 30, 0x1000)
GUICtrlSetFont (154, 16)
GUICtrlSetData($Label_152, "00:00:00")
GuiCtrlCreateLabel("PC 3", 220, 360, 100, 20, $SS_CENTER)
;Input 31
$Button_154 = GuiCtrlCreateButton("Start", 330, 410, 50, 20)
$Button_155 = GuiCtrlCreateButton("Stop", 380, 410, 50, 20)
$Input_156 = GuiCtrlCreateInput("", 330, 430, 100, 20, 0x1000)
$Label_157 = GuiCtrlCreateLabel("", 330, 380, 100, 30, 0x1000)
GUICtrlSetFont (159, 16)
GUICtrlSetData($Label_157, "00:00:00")
GuiCtrlCreateLabel("PC 4", 330, 360, 100, 20, $SS_CENTER)
;Input 32
$Button_159 = GuiCtrlCreateButton("Start", 440, 410, 50, 20)
$Button_160 = GuiCtrlCreateButton("Stop", 490, 410, 50, 20)
$Input_161 = GuiCtrlCreateInput("", 440, 430, 100, 20, 0x1000)
$Label_162 = GuiCtrlCreateLabel("", 440, 380, 100, 30, 0x1000)
GUICtrlSetFont (164, 16)
GUICtrlSetData($Label_162, "00:00:00")
GuiCtrlCreateLabel("PC 5", 440, 360, 100, 20, $SS_CENTER)
;Input 33
$Button_164 = GuiCtrlCreateButton("Start", 550, 410, 50, 20)
$Button_165 = GuiCtrlCreateButton("Stop", 600, 410, 50, 20)
$Input_166 = GuiCtrlCreateInput("", 550, 430, 100, 20, 0x1000)
$Label_167 = GuiCtrlCreateLabel("", 550, 380, 100, 30, 0x1000)
GUICtrlSetFont (169, 16)
GUICtrlSetData($Label_167, "00:00:00")
GuiCtrlCreateLabel("PC 6", 550, 360, 100, 20, $SS_CENTER)

GUISetState()

While 1
    $msg = GUIGetMsg()
    Select
        Case $msg = $Button_2
            $Timer1Active = 1
            $timer1 = TimerInit()
        Case $msg = $Button_3
            $Timer1Active = 0
            GUICtrlSetData($Label_5, "00:00:00")
			GUICtrlSetColor($Label_5, 0x000000)
			$Name = GUICtrlRead ($Input_4)
			GUICtrlSetData($Input_4, "")
			$Unit = "Computer 1"
			RecordStuff()
			
        Case $msg = $Button_7
            $Timer2Active = 1
            $timer2 = TimerInit()
        Case $msg = $Button_8
            $Timer2Active = 0
            GUICtrlSetData($Label_9, "00:00:00")
			GUICtrlSetColor($Label_9, 0x000000)
			$Name = GUICtrlRead ($Input_10)
			GUICtrlSetData($Input_10, "")
			$Unit = "Computer 2"
			RecordStuff()
			
		Case $msg = $Button_12
            $Timer3Active = 1
            $timer3 = TimerInit()
        Case $msg = $Button_13
            $Timer3Active = 0
            GUICtrlSetData($Label_15, "00:00:00")
			GUICtrlSetColor($Label_15, 0x000000)
			$Name = GUICtrlRead ($Input_14)
			GUICtrlSetData($Input_14, "")
			$Unit = "Computer 3"
			RecordStuff()
			
		Case $msg = $Button_17
            $Timer4Active = 1
            $timer4 = TimerInit()
        Case $msg = $Button_18
            $Timer4Active = 0
            GUICtrlSetData($Label_20, "00:00:00")
			GUICtrlSetColor($Label_20, 0x000000)
			$Name = GUICtrlRead ($Input_19)
			GUICtrlSetData($Input_19, "")
			$Unit = "Computer 4"
			RecordStuff()
			
		Case $msg = $Button_22
            $Timer5Active = 1
            $timer5 = TimerInit()
        Case $msg = $Button_23
            $Timer5Active = 0
            GUICtrlSetData($Label_25, "00:00:00")
			GUICtrlSetColor($Label_25, 0x000000)
			$Name = GUICtrlRead ($Input_24)
			GUICtrlSetData($Input_24, "")
			$Unit = "Computer 5"
			RecordStuff()
			
		Case $msg = $Button_27
            $Timer6Active = 1
            $timer6 = TimerInit()
        Case $msg = $Button_28
            $Timer6Active = 0
            GUICtrlSetData($Label_30, "00:00:00")
			GUICtrlSetColor($Label_30, 0x000000)
			$Name = GUICtrlRead ($Input_29)
			GUICtrlSetData($Input_29, "")
			$Unit = "Computer 6"
			RecordStuff()
			
		Case $msg = $Button_32
            $Timer7Active = 1
            $timer7 = TimerInit()
        Case $msg = $Button_33
            $Timer7Active = 0
            GUICtrlSetData($Label_35, "00:00:00")
			GUICtrlSetColor($Label_35, 0x000000)
			$Name = GUICtrlRead ($Input_34)
			GUICtrlSetData($Input_34, "")
			$Unit = "Computer 7"
			RecordStuff()
			
		Case $msg = $Button_37
            $Timer8Active = 1
            $timer8 = TimerInit()
        Case $msg = $Button_38
            $Timer8Active = 0
            GUICtrlSetData($Label_40, "00:00:00")
			GUICtrlSetColor($Label_40, 0x000000)
			$Name = GUICtrlRead ($Input_39)
			GUICtrlSetData($Input_39, "")
			$Unit = "Computer 8"
			RecordStuff()
			
		Case $msg = $Button_42
            $Timer9Active = 1
            $timer9 = TimerInit()
        Case $msg = $Button_43
            $Timer9Active = 0
            GUICtrlSetData($Label_45, "00:00:00")
			GUICtrlSetColor($Label_45, 0x000000)
			$Name = GUICtrlRead ($Input_44)
			GUICtrlSetData($Input_44, "")
			$Unit = "Computer 9"
			RecordStuff()
			
		Case $msg = $Button_49
            $Timer10Active = 1
            $timer10 = TimerInit()
        Case $msg = $Button_50
            $Timer10Active = 0
            GUICtrlSetData($Label_48, "00:00:00")
			GUICtrlSetColor($Label_48, 0x000000)
			$Name = GUICtrlRead ($Input_51)
			GUICtrlSetData($Input_51, "")
			$Unit = "Computer 10"
			RecordStuff()
			
		Case $msg = $Button_52
            $Timer11Active = 1
            $timer11 = TimerInit()
        Case $msg = $Button_53
            $Timer11Active = 0
            GUICtrlSetData($Label_55, "00:00:00")
			GUICtrlSetColor($Label_55, 0x000000)
			$Name = GUICtrlRead ($Input_54)
			GUICtrlSetData($Input_54, "")
			$Unit = "Computer 11"
			RecordStuff()
			
		Case $msg = $Button_57
            $Timer12Active = 1
            $timer12 = TimerInit()
        Case $msg = $Button_58
            $Timer12Active = 0
            GUICtrlSetData($Label_60, "00:00:00")
			GUICtrlSetColor($Label_60, 0x000000)
			$Name = GUICtrlRead ($Input_59)
			GUICtrlSetData($Input_59, "")
			$Unit = "Computer 12"
			RecordStuff()
			
		Case $msg = $Button_62
            $Timer13Active = 1
            $timer13 = TimerInit()
        Case $msg = $Button_63
            $Timer13Active = 0
            GUICtrlSetData($Label_65, "00:00:00")
			GUICtrlSetColor($Label_65, 0x000000)
			$Name = GUICtrlRead ($Input_64)
			GUICtrlSetData($Input_64, "")
			$Unit = "Computer 13"
			RecordStuff()
			
		Case $msg = $Button_67
            $Timer14Active = 1
            $timer14 = TimerInit()
        Case $msg = $Button_68
            $Timer14Active = 0
            GUICtrlSetData($Label_70, "00:00:00")
			GUICtrlSetColor($Label_70, 0x000000)
			$Name = GUICtrlRead ($Input_69)
			GUICtrlSetData($Input_69, "")
			$Unit = "Computer 14"
			RecordStuff()
			
		Case $msg = $Button_72
            $Timer15Active = 1
            $timer15 = TimerInit()
        Case $msg = $Button_73
            $Timer15Active = 0
            GUICtrlSetData($Label_75, "00:00:00")
			GUICtrlSetColor($Label_75, 0x000000)
			$Name = GUICtrlRead ($Input_74)
			GUICtrlSetData($Input_74, "")
			$Unit = "Computer 15"
			RecordStuff()
			
		Case $msg = $Button_77
            $Timer16Active = 1
            $timer16 = TimerInit()
        Case $msg = $Button_78
            $Timer16Active = 0
            GUICtrlSetData($Label_80, "00:00:00")
			GUICtrlSetColor($Label_80, 0x000000)
			$Name = GUICtrlRead ($Input_79)
			GUICtrlSetData($Input_79, "")
			$Unit = "Computer 16"
			RecordStuff()
			
		Case $msg = $Button_82
            $Timer17Active = 1
            $timer17 = TimerInit()
        Case $msg = $Button_83
            $Timer17Active = 0
            GUICtrlSetData($Label_85, "00:00:00")
			GUICtrlSetColor($Label_85, 0x000000)
			$Name = GUICtrlRead ($Input_84)
			GUICtrlSetData($Input_84, "")
			$Unit = "Computer 17"
			RecordStuff()
			
		Case $msg = $Button_87
            $Timer18Active = 1
            $timer18 = TimerInit()
        Case $msg = $Button_88
            $Timer18Active = 0
            GUICtrlSetData($Label_90, "00:00:00")
			GUICtrlSetColor($Label_90, 0x000000)
			$Name = GUICtrlRead ($Input_89)
			GUICtrlSetData($Input_89, "")
			$Unit = "Computer 18"
			RecordStuff()
			
		Case $msg = $Button_93
            $Timer19Active = 1
            $timer19 = TimerInit()
        Case $msg = $Button_94
            $Timer19Active = 0
            GUICtrlSetData($Label_95, "00:00:00")
			GUICtrlSetColor($Label_95, 0x000000)
			$Name = GUICtrlRead ($Input_97)
			GUICtrlSetData($Input_97, "")
			$Unit = "Phone 1"
			RecordStuff()
		
		Case $msg = $Button_98
            $Timer20Active = 1
            $timer20 = TimerInit()
        Case $msg = $Button_99
            $Timer20Active = 0
            GUICtrlSetData($Label_101, "00:00:00")
			GUICtrlSetColor($Label_101, 0x000000)
			$Name = GUICtrlRead ($Input_100)
			GUICtrlSetData($Input_100, "")
			$Unit = "Phone 2"
			RecordStuff()
		
		Case $msg = $Button_103
            $Timer21Active = 1
            $timer21 = TimerInit()
        Case $msg = $Button_104
            $Timer21Active = 0
            GUICtrlSetData($Label_106, "00:00:00")
			GUICtrlSetColor($Label_106, 0x000000)
			$Name = GUICtrlRead ($Input_105)
			GUICtrlSetData($Input_105, "")
			$Unit = "Phone 3"
			RecordStuff()
		
		Case $msg = $Button_108
            $Timer22Active = 1
            $timer22 = TimerInit()
        Case $msg = $Button_109
            $Timer22Active = 0
            GUICtrlSetData($Label_111, "00:00:00")
			GUICtrlSetColor($Label_111, 0x000000)
			$Name = GUICtrlRead ($Input_110)
			GUICtrlSetData($Input_110, "")
			$Unit = "Phone 4"
			RecordStuff()
		
		Case $msg = $Button_113
            $Timer23Active = 1
            $timer23 = TimerInit()
        Case $msg = $Button_114
            $Timer23Active = 0
            GUICtrlSetData($Label_116, "00:00:00")
			GUICtrlSetColor($Label_116, 0x000000)
			$Name = GUICtrlRead ($Input_115)
			GUICtrlSetData($Input_115, "")
			$Unit = "Phone 5"
			RecordStuff()
		
		Case $msg = $Button_118
            $Timer24Active = 1
            $timer24 = TimerInit()
        Case $msg = $Button_119
            $Timer24Active = 0
            GUICtrlSetData($Label_121, "00:00:00")
			GUICtrlSetColor($Label_121, 0x000000)
			$Name = GUICtrlRead ($Input_120)
			GUICtrlSetData($Input_120, "")
			$Unit = "Phone 6"
			RecordStuff()
		
		Case $msg = $Button_123
            $Timer25Active = 1
            $timer25 = TimerInit()
        Case $msg = $Button_124
            $Timer25Active = 0
            GUICtrlSetData($Label_126, "00:00:00")
			GUICtrlSetColor($Label_126, 0x000000)
			$Name = GUICtrlRead ($Input_125)
			GUICtrlSetData($Input_125, "")
			$Unit = "Phone 7"
			RecordStuff()
		
		Case $msg = $Button_128
            $Timer26Active = 1
            $timer26 = TimerInit()
        Case $msg = $Button_129
            $Timer26Active = 0
            GUICtrlSetData($Label_131, "00:00:00")
			GUICtrlSetColor($Label_131, 0x000000)
			$Name = GUICtrlRead ($Input_130)
			GUICtrlSetData($Input_130, "")
			$Unit = "Phone 8"
			RecordStuff()
		
		Case $msg = $Button_133
            $Timer27Active = 1
            $timer27 = TimerInit()
        Case $msg = $Button_134
            $Timer27Active = 0
            GUICtrlSetData($Label_136, "00:00:00")
			GUICtrlSetColor($Label_136, 0x000000)
			$Name = GUICtrlRead ($Input_135)
			GUICtrlSetData($Input_135, "")
			$Unit = "Phone 9"
			RecordStuff()
		
		Case $msg = $Button_139
            $Timer28Active = 1
            $timer28 = TimerInit()
        Case $msg = $Button_140
            $Timer28Active = 0
            GUICtrlSetData($Label_141, "00:00:00")
			GUICtrlSetColor($Label_141, 0x000000)
			$Name = GUICtrlRead ($Input_143)
			GUICtrlSetData($Input_143, "")
			$Unit = "PC 1"
			RecordStuff()
		
		Case $msg = $Button_144
            $Timer29Active = 1
            $timer29 = TimerInit()
        Case $msg = $Button_145
            $Timer29Active = 0
            GUICtrlSetData($Label_147, "00:00:00")
			GUICtrlSetColor($Label_147, 0x000000)
			$Name = GUICtrlRead ($Input_146)
			GUICtrlSetData($Input_146, "")
			$Unit = "PC 2"
			RecordStuff()
		
		Case $msg = $Button_149
            $Timer30Active = 1
            $timer30 = TimerInit()
        Case $msg = $Button_150
            $Timer30Active = 0
            GUICtrlSetData($Label_152, "00:00:00")
			GUICtrlSetColor($Label_152, 0x000000)
			$Name = GUICtrlRead ($Input_151)
			GUICtrlSetData($Input_151, "")
			$Unit = "PC 3"
			RecordStuff()
		
		Case $msg = $Button_154
            $Timer31Active = 1
            $timer31 = TimerInit()
        Case $msg = $Button_155
            $Timer31Active = 0
            GUICtrlSetData($Label_157, "00:00:00")
			GUICtrlSetColor($Label_157, 0x000000)
			$Name = GUICtrlRead ($Input_156)
			GUICtrlSetData($Input_156, "")
			$Unit = "PC 4"
			RecordStuff()
		
		Case $msg = $Button_159
            $Timer32Active = 1
            $timer32 = TimerInit()
        Case $msg = $Button_160
            $Timer32Active = 0
            GUICtrlSetData($Label_162, "00:00:00")
			GUICtrlSetColor($Label_162, 0x000000)
			$Name = GUICtrlRead ($Input_161)
			GUICtrlSetData($Input_161, "")
			$Unit = "PC 5"
			RecordStuff()
		
		Case $msg = $Button_164
            $Timer33Active = 1
            $timer33 = TimerInit()
        Case $msg = $Button_165
            $Timer33Active = 0
            GUICtrlSetData($Label_167, "00:00:00")
			GUICtrlSetColor($Label_167, 0x000000)
			$Name = GUICtrlRead ($Input_166)
			GUICtrlSetData($Input_166, "")
			$Unit = "PC 6"
			RecordStuff()
			
        Case $msg = $GUI_EVENT_CLOSE
    EndSelect
    If $msg = $GUI_EVENT_CLOSE Then ExitLoop
WEnd

Func AllTimers()
    Local $Secs, $Mins, $Hour
	
	Local $Time1, $Time2, $Time3, $Time4, $Time5, $Time6, $Time7, $Time8, $Time9, $Time10, $Time11, $Time12, $Time13, $Time14, $Time15, $Time16, $Time17, $Time18
	Local $Time19, $Time20 ,$Time21, $Time22, $Time23, $Time24, $Time25, $Time26, $Time27, $Time28, $Time29, $Time30, $Time31, $Time32, $Time32, $Time33
	
	Local $sTime1 = $Time1, $sTime2 = $Time2, $sTime3 = $Time3, $sTime4 = $Time4, $sTime5 = $Time5, $sTime6 = $Time6, $sTime7 = $Time7, $sTime8 = $Time8
	Local $sTime9 = $Time9, $sTime10 = $Time10, $sTime11 = $Time11, $sTime12 = $Time12, $sTime13 = $Time13, $sTime14 = $Time14, $sTime15 = $Time15, $sTime16 = $Time16
	Local $sTime17 = $Time17, $sTime18 = $Time18, $sTime19 = $Time19, $sTime20 = $Time20, $sTime21 = $Time21, $sTime22 = $Time22, $sTime23 = $Time23, $sTime24 = $Time24
	Local $sTime25 = $Time25, $sTime26 = $Time26, $sTime27 = $Time27, $sTime28 = $Time28, $sTime29 = $Time29, $sTime30 = $Time30, $sTime31 = $Time31, $sTime32 = $Time32
	Local $sTime33 = $Time33

    If $Timer1Active Then
        _TicksToTime(Int(TimerDiff($timer1)), $Hour, $Mins, $Secs)
        $Time1 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime1 <> $Time1 Then ControlSetText("Net Cafe' Log by TSgt Farrell", "", $Label_5, $Time1)
		If $Mins > 30 Then GUICtrlSetColor($Label_5, 0xff0000)
		$TotalTime = $Time1
	EndIf
	
    If $Timer2Active Then
        _TicksToTime(Int(TimerDiff($timer2)), $Hour, $Mins, $Secs)
        $Time2 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime2 <> $Time2 Then ControlSetText("Net Cafe' Log by TSgt Farrell", "", $Label_9, $Time2)
		If $Mins > 30 Then GUICtrlSetColor($Label_9, 0xff0000)
	EndIf
	
	If $Timer3Active Then
        _TicksToTime(Int(TimerDiff($timer3)), $Hour, $Mins, $Secs)
        $Time3 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime3 <> $Time3 Then ControlSetText("Net Cafe' Log by TSgt Farrell", "", $Label_15, $Time3)
		If $Mins > 30 Then GUICtrlSetColor($Label_15, 0xff0000)
		EndIf
		
	If $Timer4Active Then
        _TicksToTime(Int(TimerDiff($timer4)), $Hour, $Mins, $Secs)
        $Time4 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime4 <> $Time4 Then ControlSetText("Net Cafe' Log by TSgt Farrell", "", $Label_20, $Time4)
		If $Mins > 30 Then GUICtrlSetColor($Label_20, 0xff0000)
	EndIf
		
	If $Timer5Active Then
        _TicksToTime(Int(TimerDiff($timer5)), $Hour, $Mins, $Secs)
        $Time5 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime5 <> $Time5 Then ControlSetText("Net Cafe' Log by TSgt Farrell", "", $Label_25, $Time5)
		If $Mins > 30 Then GUICtrlSetColor($Label_25, 0xff0000)
		EndIf
		
	If $Timer6Active Then
        _TicksToTime(Int(TimerDiff($timer6)), $Hour, $Mins, $Secs)
        $Time6 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime6 <> $Time6 Then ControlSetText("Net Cafe' Log by TSgt Farrell", "", $Label_30, $Time6)
		If $Mins > 30 Then GUICtrlSetColor($Label_30, 0xff0000)
	EndIf
		
	If $Timer7Active Then
        _TicksToTime(Int(TimerDiff($timer7)), $Hour, $Mins, $Secs)
        $Time7 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime7 <> $Time7 Then ControlSetText("Net Cafe' Log by TSgt Farrell", "", $Label_35, $Time7)
		If $Mins > 30 Then GUICtrlSetColor($Label_35, 0xff0000)
	EndIf
		
	If $Timer8Active Then
        _TicksToTime(Int(TimerDiff($timer8)), $Hour, $Mins, $Secs)
        $Time8 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime8 <> $Time8 Then ControlSetText("Net Cafe' Log by TSgt Farrell", "", $Label_40, $Time8)
		If $Mins > 30 Then GUICtrlSetColor($Label_40, 0xff0000)
	EndIf
		
	If $Timer9Active Then
        _TicksToTime(Int(TimerDiff($timer9)), $Hour, $Mins, $Secs)
        $Time9 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime9 <> $Time9 Then ControlSetText("Net Cafe' Log by TSgt Farrell", "", $Label_45, $Time9)
		If $Mins > 30 Then GUICtrlSetColor($Label_45, 0xff0000)
	EndIf
		
	If $Timer10Active Then
        _TicksToTime(Int(TimerDiff($timer10)), $Hour, $Mins, $Secs)
        $Time10 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime10 <> $Time10 Then ControlSetText("Net Cafe' Log by TSgt Farrell", "", $Label_48, $Time10)
		If $Mins > 30 Then GUICtrlSetColor($Label_48, 0xff0000)
	EndIf
		
	If $Timer11Active Then
        _TicksToTime(Int(TimerDiff($timer11)), $Hour, $Mins, $Secs)
        $Time11 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime11 <> $Time11 Then ControlSetText("Net Cafe' Log by TSgt Farrell", "", $Label_55, $Time11)
		If $Mins > 30 Then GUICtrlSetColor($Label_55, 0xff0000)
		EndIf
		
	If $Timer12Active Then
        _TicksToTime(Int(TimerDiff($timer12)), $Hour, $Mins, $Secs)
        $Time12 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime12 <> $Time12 Then ControlSetText("Net Cafe' Log by TSgt Farrell", "", $Label_60, $Time12)
		If $Mins > 30 Then GUICtrlSetColor($Label_60, 0xff0000)
	EndIf
		
	If $Timer13Active Then
        _TicksToTime(Int(TimerDiff($timer13)), $Hour, $Mins, $Secs)
        $Time13 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime13 <> $Time13 Then ControlSetText("Net Cafe' Log by TSgt Farrell", "", $Label_65, $Time13)
		If $Mins > 30 Then GUICtrlSetColor($Label_65, 0xff0000)
	EndIf
		
	If $Timer14Active Then
        _TicksToTime(Int(TimerDiff($timer14)), $Hour, $Mins, $Secs)
        $Time14 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime14 <> $Time14 Then ControlSetText("Net Cafe' Log by TSgt Farrell", "", $Label_70, $Time14)
		If $Mins > 30 Then GUICtrlSetColor($Label_70, 0xff0000)
	EndIf
		
	If $Timer15Active Then
        _TicksToTime(Int(TimerDiff($timer15)), $Hour, $Mins, $Secs)
        $Time15 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime15 <> $Time15 Then ControlSetText("Net Cafe' Log by TSgt Farrell", "", $Label_75, $Time15)
		If $Mins > 30 Then GUICtrlSetColor($Label_75, 0xff0000)
	EndIf
		
	If $Timer16Active Then
        _TicksToTime(Int(TimerDiff($timer16)), $Hour, $Mins, $Secs)
        $Time16 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime16 <> $Time16 Then ControlSetText("Net Cafe' Log by TSgt Farrell", "", $Label_80, $Time16)
		If $Mins > 30 Then GUICtrlSetColor($Label_80, 0xff0000)
	EndIf
		
	If $Timer17Active Then
        _TicksToTime(Int(TimerDiff($timer17)), $Hour, $Mins, $Secs)
        $Time17 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime16 <> $Time17 Then ControlSetText("Net Cafe' Log by TSgt Farrell", "", $Label_85, $Time17)
		If $Mins > 30 Then GUICtrlSetColor($Label_85, 0xff0000)
	EndIf
		
	If $Timer18Active Then
        _TicksToTime(Int(TimerDiff($timer18)), $Hour, $Mins, $Secs)
        $Time18 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime18 <> $Time18 Then ControlSetText("Net Cafe' Log by TSgt Farrell", "", $Label_90, $Time18)
		If $Mins > 30 Then GUICtrlSetColor($Label_90, 0xff0000)
		EndIf
		
	If $Timer19Active Then
        _TicksToTime(Int(TimerDiff($timer19)), $Hour, $Mins, $Secs)
        $Time19 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime19 <> $Time19 Then ControlSetText("Net Cafe' Log by TSgt Farrell", "", $Label_95, $Time19)
		If $Mins > 15 Then GUICtrlSetColor($Label_95, 0xff0000)
	EndIf
		
	If $Timer20Active Then
        _TicksToTime(Int(TimerDiff($timer20)), $Hour, $Mins, $Secs)
        $Time20 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime20 <> $Time20 Then ControlSetText("Net Cafe' Log by TSgt Farrell", "", $Label_101, $Time20)
		If $Mins > 15 Then GUICtrlSetColor($Label_101, 0xff0000)
	EndIf
	
	If $Timer21Active Then
        _TicksToTime(Int(TimerDiff($timer21)), $Hour, $Mins, $Secs)
        $Time21 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime21 <> $Time21 Then ControlSetText("Net Cafe' Log by TSgt Farrell", "", $Label_106, $Time21)
		If $Mins > 15 Then GUICtrlSetColor($Label_106, 0xff0000)
	EndIf
	
	If $Timer22Active Then
        _TicksToTime(Int(TimerDiff($timer22)), $Hour, $Mins, $Secs)
        $Time22 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime22 <> $Time22 Then ControlSetText("Net Cafe' Log by TSgt Farrell", "", $Label_111, $Time22)
		If $Mins > 15 Then GUICtrlSetColor($Label_111, 0xff0000)
	EndIf
	
	If $Timer23Active Then
        _TicksToTime(Int(TimerDiff($timer23)), $Hour, $Mins, $Secs)
        $Time23 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime23 <> $Time23 Then ControlSetText("Net Cafe' Log by TSgt Farrell", "", $Label_116, $Time23)
		If $Mins > 15 Then GUICtrlSetColor($Label_116, 0xff0000)
	EndIf
		
	If $Timer24Active Then
        _TicksToTime(Int(TimerDiff($timer24)), $Hour, $Mins, $Secs)
        $Time24 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime24 <> $Time24 Then ControlSetText("Net Cafe' Log by TSgt Farrell", "", $Label_121, $Time24)
		If $Mins > 15 Then GUICtrlSetColor($Label_121, 0xff0000)
	EndIf
	
	If $Timer25Active Then
        _TicksToTime(Int(TimerDiff($timer25)), $Hour, $Mins, $Secs)
        $Time25 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime25 <> $Time25 Then ControlSetText("Net Cafe' Log by TSgt Farrell", "", $Label_126, $Time25)
		If $Mins > 15 Then GUICtrlSetColor($Label_126, 0xff0000)
	EndIf
		
	If $Timer26Active Then
        _TicksToTime(Int(TimerDiff($timer26)), $Hour, $Mins, $Secs)
        $Time26 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime26 <> $Time26 Then ControlSetText("Net Cafe' Log by TSgt Farrell", "", $Label_131, $Time26)
		If $Mins > 15 Then GUICtrlSetColor($Label_131, 0xff0000)
	EndIf
	
	If $Timer27Active Then
        _TicksToTime(Int(TimerDiff($timer27)), $Hour, $Mins, $Secs)
        $Time27 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime27 <> $Time27 Then ControlSetText("Net Cafe' Log by TSgt Farrell", "", $Label_136, $Time27)
		If $Mins > 15 Then GUICtrlSetColor($Label_136, 0xff0000)
	EndIf
	
	If $Timer28Active Then
        _TicksToTime(Int(TimerDiff($timer28)), $Hour, $Mins, $Secs)
        $Time28 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime28 <> $Time28 Then ControlSetText("Net Cafe' Log by TSgt Farrell", "", $Label_141, $Time28)
		If $Mins > 30 Then GUICtrlSetColor($Label_141, 0xff0000)
	EndIf
	
	If $Timer29Active Then
        _TicksToTime(Int(TimerDiff($timer29)), $Hour, $Mins, $Secs)
        $Time29 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime29 <> $Time29 Then ControlSetText("Net Cafe' Log by TSgt Farrell", "", $Label_147, $Time29)
		If $Mins > 30 Then GUICtrlSetColor($Label_147, 0xff0000)
	EndIf
	
	If $Timer30Active Then
        _TicksToTime(Int(TimerDiff($timer30)), $Hour, $Mins, $Secs)
        $Time30 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime30 <> $Time30 Then ControlSetText("Net Cafe' Log by TSgt Farrell", "", $Label_152, $Time30)
		If $Mins > 30 Then GUICtrlSetColor($Label_152, 0xff0000)
	EndIf
	
	If $Timer31Active Then
        _TicksToTime(Int(TimerDiff($timer31)), $Hour, $Mins, $Secs)
        $Time31 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime31 <> $Time31 Then ControlSetText("Net Cafe' Log by TSgt Farrell", "", $Label_157, $Time31)
		If $Mins > 30 Then GUICtrlSetColor($Label_157, 0xff0000)
	EndIf
	
	If $Timer32Active Then
        _TicksToTime(Int(TimerDiff($timer32)), $Hour, $Mins, $Secs)
        $Time32 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime32 <> $Time32 Then ControlSetText("Net Cafe' Log by TSgt Farrell", "", $Label_162, $Time32)
		If $Mins > 30 Then GUICtrlSetColor($Label_162, 0xff0000)
	EndIf
	
	If $Timer33Active Then
        _TicksToTime(Int(TimerDiff($timer33)), $Hour, $Mins, $Secs)
        $Time33 = StringFormat("%02i:%02i:%02i", $Hour, $Mins, $Secs)
        If $sTime33 <> $Time33 Then ControlSetText("Net Cafe' Log by TSgt Farrell", "", $Label_167, $Time33)
		If $Mins > 30 Then GUICtrlSetColor($Label_167, 0xff0000)
    EndIf
EndFunc

Func RecordStuff ()
	$LogStuff = FileOpen ("logfile.txt", 1)
	FileWriteLine ($LogStuff, "Station: " & $Unit & @CRLF)
	FileWriteLine ($LogStuff, "User name: " & $Name & @CRLF)
	FileWriteLine ($LogStuff, "Total time: " & $TotalTime & @CRLF & @CRLF)
	FileClose ($LogStuff)
EndFunc
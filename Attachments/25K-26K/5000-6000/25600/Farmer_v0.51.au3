#RequireAdmin
#include <IE.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ComboConstants.au3>
#include <Date.au3>


Opt("TrayMenuMode",1)
Opt("TrayOnEventMode", 1)
TraySetIcon("files\favicon.ico")
$pokazitray = TrayCreateItem("Pokaži")
$skrijtray = TrayCreateItem("Skrij")
$Izhodtray = TrayCreateItem("Izhod")
TrayItemSetOnEvent($Izhodtray, "Vnpjt")
TrayItemSetOnEvent($pokazitray, "pokazi")
TrayItemSetOnEvent($skrijtray, "skrij")
Func Vnpjt()
	_IEQuit($ie)
	Exit
EndFunc
Func pokazi()
	GUISetState(@SW_SHOW, $statuswin)
EndFunc
Func skrij()
	GUISetState(@SW_HIDE, $statuswin)
EndFunc


$ini1 = IniRead("save.ini", "PODATKI", "user", "")
$ini2 = IniRead("save.ini", "PODATKI", "password", "")
$ini3 = IniRead("save.ini", "PODATKI", "x1", "")
$ini4 = IniRead("save.ini", "PODATKI", "x2", "")
$ini5 = IniRead("save.ini", "PODATKI", "x3", "")
$ini6 = IniRead("save.ini", "PODATKI", "x4", "")
$ini7 = IniRead("save.ini", "PODATKI", "x5", "")
$ini8 = IniRead("save.ini", "PODATKI", "y1", "")
$ini9 = IniRead("save.ini", "PODATKI", "y2", "")
$ini10 = IniRead("save.ini", "PODATKI", "y3", "")
$ini11 = IniRead("save.ini", "PODATKI", "y4", "")
$ini12 = IniRead("save.ini", "PODATKI", "y5", "")
$ini16 = IniRead("save.ini", "PODATKI", "x6", "")
$ini17 = IniRead("save.ini", "PODATKI", "y6", "")
$ini18 = IniRead("save.ini", "PODATKI", "x7", "")
$ini19 = IniRead("save.ini", "PODATKI", "y7", "")
$ini20 = IniRead("save.ini", "PODATKI", "x8", "")
$ini21 = IniRead("save.ini", "PODATKI", "y8", "")
$ini22 = IniRead("save.ini", "PODATKI", "x9", "")
$ini23 = IniRead("save.ini", "PODATKI", "y9", "")
$ini24 = IniRead("save.ini", "PODATKI", "x10", "")
$ini25 = IniRead("save.ini", "PODATKI", "y10", "")
$ini26 = IniRead("save.ini", "PODATKI", "x11", "")
$ini27 = IniRead("save.ini", "PODATKI", "y11", "")
$ini28 = IniRead("save.ini", "PODATKI", "x12", "")
$ini29 = IniRead("save.ini", "PODATKI", "y12", "")
$ini30 = IniRead("save.ini", "PODATKI", "x13", "")
$ini31 = IniRead("save.ini", "PODATKI", "y13", "")
$ini32 = IniRead("save.ini", "PODATKI", "x14", "")
$ini33 = IniRead("save.ini", "PODATKI", "y14", "")
$ini34 = IniRead("save.ini", "PODATKI", "x15", "")
$ini35 = IniRead("save.ini", "PODATKI", "y15", "")
$ini36 = IniRead("save.ini", "PODATKI", "x16", "")
$ini37 = IniRead("save.ini", "PODATKI", "y16", "")
$ini38 = IniRead("save.ini", "PODATKI", "x17", "")
$ini39 = IniRead("save.ini", "PODATKI", "y17", "")
$ini40 = IniRead("save.ini", "PODATKI", "x18", "")
$ini41 = IniRead("save.ini", "PODATKI", "y18", "")
$ini42 = IniRead("save.ini", "PODATKI", "x19", "")
$ini43 = IniRead("save.ini", "PODATKI", "y19", "")
$ini44 = IniRead("save.ini", "PODATKI", "x20", "")
$ini45 = IniRead("save.ini", "PODATKI", "y20", "")
$ini46 = IniRead("save.ini", "PODATKI", "x21", "")
$ini47 = IniRead("save.ini", "PODATKI", "y21", "")
$ini48 = IniRead("save.ini", "PODATKI", "x22", "")
$ini49 = IniRead("save.ini", "PODATKI", "y22", "")
$ini50 = IniRead("save.ini", "PODATKI", "x23", "")
$ini51 = IniRead("save.ini", "PODATKI", "y23", "")
$ini52 = IniRead("save.ini", "PODATKI", "x24", "")
$ini53 = IniRead("save.ini", "PODATKI", "y24", "")
$ini54 = IniRead("save.ini", "PODATKI", "x25", "")
$ini55 = IniRead("save.ini", "PODATKI", "y25", "")
$ini56 = IniRead("save.ini", "PODATKI", "x26", "")
$ini57 = IniRead("save.ini", "PODATKI", "y26", "")
$ini58 = IniRead("save.ini", "PODATKI", "x27", "")
$ini59 = IniRead("save.ini", "PODATKI", "y27", "")
$ini60 = IniRead("save.ini", "PODATKI", "x28", "")
$ini61 = IniRead("save.ini", "PODATKI", "y28", "")
$ini62 = IniRead("save.ini", "PODATKI", "x29", "")
$ini63 = IniRead("save.ini", "PODATKI", "y29", "")
$ini64 = IniRead("save.ini", "PODATKI", "x30", "")
$ini65 = IniRead("save.ini", "PODATKI", "y30", "")
$ini66 = IniRead("save.ini", "PODATKI", "x31", "")
$ini67 = IniRead("save.ini", "PODATKI", "y31", "")
$ini68 = IniRead("save.ini", "PODATKI", "x32", "")
$ini69 = IniRead("save.ini", "PODATKI", "y32", "")
$ini70 = IniRead("save.ini", "PODATKI", "x33", "")
$ini71 = IniRead("save.ini", "PODATKI", "y33", "")
$ini72 = IniRead("save.ini", "PODATKI", "x34", "")
$ini73 = IniRead("save.ini", "PODATKI", "y34", "")
$ini74 = IniRead("save.ini", "PODATKI", "x35", "")
$ini75 = IniRead("save.ini", "PODATKI", "y35", "")
$ini76 = IniRead("save.ini", "PODATKI", "x36", "")
$ini77 = IniRead("save.ini", "PODATKI", "y36", "")
$ini78 = IniRead("save.ini", "PODATKI", "x37", "")
$ini79 = IniRead("save.ini", "PODATKI", "y37", "")
$ini80 = IniRead("save.ini", "PODATKI", "x38", "")
$ini81 = IniRead("save.ini", "PODATKI", "y38", "")
$ini82 = IniRead("save.ini", "PODATKI", "x39", "")
$ini83 = IniRead("save.ini", "PODATKI", "y39", "")
$ini84 = IniRead("save.ini", "PODATKI", "x40", "")
$ini85 = IniRead("save.ini", "PODATKI", "y40", "")
;
$ini86 = IniRead("save.ini", "PODATKI", "x41", "")
$ini87 = IniRead("save.ini", "PODATKI", "y41", "")
$ini88 = IniRead("save.ini", "PODATKI", "x42", "")
$ini89 = IniRead("save.ini", "PODATKI", "y42", "")
$ini90 = IniRead("save.ini", "PODATKI", "x43", "")
$ini91 = IniRead("save.ini", "PODATKI", "y43", "")
$ini92 = IniRead("save.ini", "PODATKI", "x44", "")
$ini93 = IniRead("save.ini", "PODATKI", "y44", "")
$ini94 = IniRead("save.ini", "PODATKI", "x45", "")
$ini95 = IniRead("save.ini", "PODATKI", "y45", "")
$ini96 = IniRead("save.ini", "PODATKI", "x46", "")
$ini97 = IniRead("save.ini", "PODATKI", "y46", "")
$ini98 = IniRead("save.ini", "PODATKI", "x47", "")
$ini99 = IniRead("save.ini", "PODATKI", "y47", "")
$ini100 = IniRead("save.ini", "PODATKI", "x48", "")
$ini101 = IniRead("save.ini", "PODATKI", "y48", "")
$ini102 = IniRead("save.ini", "PODATKI", "x49", "")
$ini103 = IniRead("save.ini", "PODATKI", "y49", "")
$ini104 = IniRead("save.ini", "PODATKI", "x50", "")
$ini105 = IniRead("save.ini", "PODATKI", "y50", "")
$ini106 = IniRead("save.ini", "PODATKI", "x51", "")
$ini107 = IniRead("save.ini", "PODATKI", "y51", "")
$ini108 = IniRead("save.ini", "PODATKI", "x52", "")
$ini109 = IniRead("save.ini", "PODATKI", "y52", "")
$ini110 = IniRead("save.ini", "PODATKI", "x53", "")
$ini111 = IniRead("save.ini", "PODATKI", "y53", "")
$ini112 = IniRead("save.ini", "PODATKI", "x54", "")
$ini113 = IniRead("save.ini", "PODATKI", "y54", "")
$ini114 = IniRead("save.ini", "PODATKI", "x55", "")
$ini115 = IniRead("save.ini", "PODATKI", "y55", "")
$ini116 = IniRead("save.ini", "PODATKI", "x56", "")
$ini117 = IniRead("save.ini", "PODATKI", "y56", "")
$ini118 = IniRead("save.ini", "PODATKI", "x57", "")
$ini119 = IniRead("save.ini", "PODATKI", "y57", "")
$ini120 = IniRead("save.ini", "PODATKI", "x58", "")
$ini121 = IniRead("save.ini", "PODATKI", "y58", "")
$ini122 = IniRead("save.ini", "PODATKI", "x59", "")
$ini123 = IniRead("save.ini", "PODATKI", "y59", "")
$ini124 = IniRead("save.ini", "PODATKI", "x60", "")
$ini125 = IniRead("save.ini", "PODATKI", "y60", "")
$ini126 = IniRead("save.ini", "PODATKI", "x61", "")
$ini127 = IniRead("save.ini", "PODATKI", "y61", "")
$ini128 = IniRead("save.ini", "PODATKI", "x62", "")
$ini129 = IniRead("save.ini", "PODATKI", "y62", "")
$ini130 = IniRead("save.ini", "PODATKI", "x63", "")
$ini131 = IniRead("save.ini", "PODATKI", "y63", "")
$ini132 = IniRead("save.ini", "PODATKI", "x64", "")
$ini133 = IniRead("save.ini", "PODATKI", "y64", "")
$ini134 = IniRead("save.ini", "PODATKI", "x65", "")
$ini135 = IniRead("save.ini", "PODATKI", "y65", "")
$ini136 = IniRead("save.ini", "PODATKI", "x66", "")
$ini137 = IniRead("save.ini", "PODATKI", "y66", "")
$ini138 = IniRead("save.ini", "PODATKI", "x67", "")
$ini139 = IniRead("save.ini", "PODATKI", "y67", "")
$ini140 = IniRead("save.ini", "PODATKI", "x68", "")
$ini141 = IniRead("save.ini", "PODATKI", "y68", "")
$ini142 = IniRead("save.ini", "PODATKI", "x69", "")
$ini143 = IniRead("save.ini", "PODATKI", "y69", "")
$ini144 = IniRead("save.ini", "PODATKI", "x70", "")
$ini145 = IniRead("save.ini", "PODATKI", "y70", "")
$ini146 = IniRead("save.ini", "PODATKI", "x71", "")
$ini147 = IniRead("save.ini", "PODATKI", "y71", "")
$ini148 = IniRead("save.ini", "PODATKI", "x72", "")
$ini149 = IniRead("save.ini", "PODATKI", "y72", "")
$ini150 = IniRead("save.ini", "PODATKI", "x73", "")
$ini151 = IniRead("save.ini", "PODATKI", "y73", "")
$ini152 = IniRead("save.ini", "PODATKI", "x74", "")
$ini153 = IniRead("save.ini", "PODATKI", "y74", "")
$ini154 = IniRead("save.ini", "PODATKI", "x75", "")
$ini155 = IniRead("save.ini", "PODATKI", "y75", "")
$ini156 = IniRead("save.ini", "PODATKI", "x76", "")
$ini157 = IniRead("save.ini", "PODATKI", "y76", "")
$ini158 = IniRead("save.ini", "PODATKI", "x77", "")
$ini159 = IniRead("save.ini", "PODATKI", "y77", "")
$ini160 = IniRead("save.ini", "PODATKI", "x78", "")
$ini161 = IniRead("save.ini", "PODATKI", "y78", "")
$ini162 = IniRead("save.ini", "PODATKI", "x79", "")
$ini163 = IniRead("save.ini", "PODATKI", "y79", "")
$ini164 = IniRead("save.ini", "PODATKI", "x80", "")
$ini165 = IniRead("save.ini", "PODATKI", "y80", "")
;
$ini166 = IniRead("save.ini", "PODATKI", "x81", "")
$ini167 = IniRead("save.ini", "PODATKI", "x82", "")
$ini168 = IniRead("save.ini", "PODATKI", "x83", "")
$ini169 = IniRead("save.ini", "PODATKI", "x84", "")
$ini170 = IniRead("save.ini", "PODATKI", "x85", "")
$ini171 = IniRead("save.ini", "PODATKI", "y81", "")
$ini172 = IniRead("save.ini", "PODATKI", "y82", "")
$ini173 = IniRead("save.ini", "PODATKI", "y83", "")
$ini174 = IniRead("save.ini", "PODATKI", "y84", "")
$ini175 = IniRead("save.ini", "PODATKI", "y85", "")
$ini176 = IniRead("save.ini", "PODATKI", "x86", "")
$ini177 = IniRead("save.ini", "PODATKI", "y86", "")
$ini178 = IniRead("save.ini", "PODATKI", "x87", "")
$ini179 = IniRead("save.ini", "PODATKI", "y87", "")
$ini180 = IniRead("save.ini", "PODATKI", "x88", "")
$ini181 = IniRead("save.ini", "PODATKI", "y88", "")
$ini182 = IniRead("save.ini", "PODATKI", "x89", "")
$ini183 = IniRead("save.ini", "PODATKI", "y89", "")
$ini184 = IniRead("save.ini", "PODATKI", "x90", "")
$ini185 = IniRead("save.ini", "PODATKI", "y90", "")
$ini186 = IniRead("save.ini", "PODATKI", "x91", "")
$ini187 = IniRead("save.ini", "PODATKI", "y91", "")
$ini188 = IniRead("save.ini", "PODATKI", "x92", "")
$ini189 = IniRead("save.ini", "PODATKI", "y92", "")
$ini190 = IniRead("save.ini", "PODATKI", "x93", "")
$ini191 = IniRead("save.ini", "PODATKI", "y93", "")
$ini192 = IniRead("save.ini", "PODATKI", "x94", "")
$ini193 = IniRead("save.ini", "PODATKI", "y94", "")
$ini194 = IniRead("save.ini", "PODATKI", "x95", "")
$ini195 = IniRead("save.ini", "PODATKI", "y95", "")
$ini196 = IniRead("save.ini", "PODATKI", "x96", "")
$ini197 = IniRead("save.ini", "PODATKI", "y96", "")
$ini198 = IniRead("save.ini", "PODATKI", "x97", "")
$ini199 = IniRead("save.ini", "PODATKI", "y97", "")
$ini200 = IniRead("save.ini", "PODATKI", "x98", "")
$ini201 = IniRead("save.ini", "PODATKI", "y98", "")
$ini202 = IniRead("save.ini", "PODATKI", "x99", "")
$ini203 = IniRead("save.ini", "PODATKI", "y99", "")
$ini204 = IniRead("save.ini", "PODATKI", "x100", "")
$ini205 = IniRead("save.ini", "PODATKI", "y100", "")
$ini206 = IniRead("save.ini", "PODATKI", "x101", "")
$ini207 = IniRead("save.ini", "PODATKI", "y101", "")
$ini208 = IniRead("save.ini", "PODATKI", "x102", "")
$ini209 = IniRead("save.ini", "PODATKI", "y102", "")
$ini210 = IniRead("save.ini", "PODATKI", "x103", "")
$ini211 = IniRead("save.ini", "PODATKI", "y103", "")
$ini212 = IniRead("save.ini", "PODATKI", "x104", "")
$ini213 = IniRead("save.ini", "PODATKI", "y104", "")
$ini214 = IniRead("save.ini", "PODATKI", "x105", "")
$ini215 = IniRead("save.ini", "PODATKI", "y105", "")
$ini216 = IniRead("save.ini", "PODATKI", "x106", "")
$ini217 = IniRead("save.ini", "PODATKI", "y106", "")
$ini218 = IniRead("save.ini", "PODATKI", "x107", "")
$ini219 = IniRead("save.ini", "PODATKI", "y107", "")
$ini220 = IniRead("save.ini", "PODATKI", "x108", "")
$ini221 = IniRead("save.ini", "PODATKI", "y108", "")
$ini222 = IniRead("save.ini", "PODATKI", "x109", "")
$ini223 = IniRead("save.ini", "PODATKI", "y109", "")
$ini224 = IniRead("save.ini", "PODATKI", "x110", "")
$ini225 = IniRead("save.ini", "PODATKI", "y110", "")
$ini226 = IniRead("save.ini", "PODATKI", "x111", "")
$ini227 = IniRead("save.ini", "PODATKI", "y111", "")
$ini228 = IniRead("save.ini", "PODATKI", "x112", "")
$ini229 = IniRead("save.ini", "PODATKI", "y112", "")
$ini230 = IniRead("save.ini", "PODATKI", "x113", "")
$ini231 = IniRead("save.ini", "PODATKI", "y113", "")
$ini232 = IniRead("save.ini", "PODATKI", "x114", "")
$ini233 = IniRead("save.ini", "PODATKI", "y114", "")
$ini234 = IniRead("save.ini", "PODATKI", "x115", "")
$ini235 = IniRead("save.ini", "PODATKI", "y115", "")
$ini236 = IniRead("save.ini", "PODATKI", "x116", "")
$ini237 = IniRead("save.ini", "PODATKI", "y116", "")
$ini238 = IniRead("save.ini", "PODATKI", "x117", "")
$ini239 = IniRead("save.ini", "PODATKI", "y117", "")
$ini240 = IniRead("save.ini", "PODATKI", "x118", "")
$ini241 = IniRead("save.ini", "PODATKI", "y118", "")
$ini242 = IniRead("save.ini", "PODATKI", "x119", "")
$ini243 = IniRead("save.ini", "PODATKI", "y119", "")
$ini244 = IniRead("save.ini", "PODATKI", "x120", "")
$ini245 = IniRead("save.ini", "PODATKI", "y120", "")
$ini246 = IniRead("save.ini", "PODATKI", "barakeid", "")
;
;

$Form1 = GUICreate("Travian Farmer by DoctorSLO", 800, 600, 197, 126)
$gok = GUICtrlCreateButton("OK", 650, 565, 60, 22)
GUICtrlCreateLabel("Made By DoctorSLO :)", 400, 565)
GUICtrlCreateTab(0, 0, 800, 550)
GUICtrlCreateTabItem("Nastavitve")
GUICtrlCreateLabel("Ime", 10, 50, 21, 17)
GUICtrlCreateLabel("Geslo", 10, 92, 31, 17)
$gime = GUICtrlCreateInput($ini1, 57, 48, 121, 21)
$ggeslo = GUICtrlCreateInput($ini2, 57, 90, 121, 21, $ES_PASSWORD)
GUICtrlCreateLabel("Na vsako farmo pošlji (enote skupaj):", 10, 140)
$ggorjacar = GUICtrlCreateInput(10, 10, 165, 31, 21)
GUICtrlCreateLabel("gorjaèarjev", 43, 168)
$gpaladin = GUICtrlCreateInput(0, 10, 190, 31, 21)
GUICtrlCreateLabel("paladinov", 43, 192)
$sekire = GUICtrlCreateInput(0, 10, 215, 31, 21)
GUICtrlCreateLabel("metalcev sekir", 43, 217)
$vitezi = GUICtrlCreateInput(0, 10, 242, 31, 21)
GUICtrlCreateLabel("tevtonskih vitezov", 43, 244)

GUICtrlCreateLabel("...in enote ki bodo poslane posebej:", 10, 300)
$ggorjacar2 = GUICtrlCreateInput(0, 10, 325, 31, 21)
GUICtrlCreateLabel("gorjaèarjev", 43, 327)
$gpaladin2 = GUICtrlCreateInput(0, 10, 350, 31, 21)
GUICtrlCreateLabel("paladinov", 43, 352)
$sekire2 = GUICtrlCreateInput(0, 10, 375, 31, 21)
GUICtrlCreateLabel("metalcev sekir", 43, 377)
$vitezi2 = GUICtrlCreateInput(0, 10, 400, 31, 21)
GUICtrlCreateLabel("tevtonskih vitezov", 43, 402)

GUICtrlCreateLabel("Pavza potem ko so vse farme 1-krat napadene(v minutah):", 300, 48)
$pavza = GUICtrlCreateInput(0, 580, 46, 31, 21)
GUICtrlCreateLabel("Ob napadu na tvoje mesto:", 265, 83)
$obnapadu = GUICtrlCreateCombo("", 400, 80, 200, 30, $CBS_DROPDOWNLIST)
GUICtrlSetData(-1, "Odmakni samo napadalne enote|Odmakni vse enote|Ne naredi nicesar", "Odmakni samo napadalne enote")
GUICtrlCreateLabel("Koordinate za umik so nastavljene na prvo farmo, torej pazljivo izberi prvo farmo, da je vedno na voljo", 265, 110)
GUICtrlCreateLabel("ID barak, ki bo uporabljen za urjenje novih enot, in za porabo surovin pri prihajajoèih napadih:", 245, 140)
$idbarak = GUICtrlCreateInput($ini246, 688, 138, 31, 21)
GUICtrlCreateLabel("Surovine porabljaj:", 245, 162)
$surovine = GUIctrlCreateCombo("", 350, 160, 300, 30, $CBS_DROPDOWNLIST)
GUICtrlSetData(-1, "Ne porabljaj surovin(razen èe sem napaden)|Sproti|Po enem napadu na vse farme", "Ne porabljaj surovin(razen èe sem napaden)")
GUICtrlCreateLabel("Gorjaèarji:", 245, 192)
$traingor = GUICtrlCreateInput(0, 320, 190, 31, 21)
GUICtrlCreateLabel("Sulièarji:", 245, 217)
$trainsulic = GUICtrlCreateInput(0, 320, 215, 31, 21)
GUICtrlCreateLabel("Metalci sekir:", 245, 242)
$trainmet = GUICtrlCreateInput(0, 320, 240, 31, 21)
GUICtrlCreateLabel("Novo v 0.5:", 250, 400)
GUICtrlCreateLabel("-Popravek BUGa: preskakovanje farm", 245, 415)
GUICtrlCreateLabel("-Popravek BUGa: v celoti popravljen sistem za odmikanje vojske in poraba surovin ob napadu", 245, 430)
GUICtrlCreateLabel("-Novo: Zdaj farmer deluje brez offsets.ini, ker jih poišèe sam", 245, 445)
GUICtrlCreateLabel("", 245, 460)



GUICtrlCreateTabItem("Farme")
$gx1 = GUICtrlCreateInput($ini3, 30, 102, 37, 21)
$gy1 = GUICtrlCreateInput($ini8, 93, 102, 37, 21)
$gx2 = GUICtrlCreateInput($ini4, 30, 129, 37, 21)
$gy2 = GUICtrlCreateInput($ini9, 93, 129, 37, 21)
$gx3 = GUICtrlCreateInput($ini5, 30, 156, 37, 21)
$gy3 = GUICtrlCreateInput($ini10, 93, 156, 37, 21)
$gx4 = GUICtrlCreateInput($ini6, 30, 183, 37, 21)
$gy4 = GUICtrlCreateInput($ini11, 93, 183, 37, 21)
$gx5 = GUICtrlCreateInput($ini7, 30, 210, 37, 21)
$gy5 = GUICtrlCreateInput($ini12, 93, 210, 37, 21)
$gx6 = GUICtrlCreateInput($ini16, 30, 241, 37, 21)
$gy6 = GUICtrlCreateInput($ini17, 93, 241, 37, 21)
$gx7 = GUICtrlCreateInput($ini18, 30, 268, 37, 21)
$gy7 = GUICtrlCreateInput($ini19, 93, 268, 37, 21)
$gx8 = GUICtrlCreateInput($ini20, 30, 295, 37, 21)
$gy8 = GUICtrlCreateInput($ini21, 93, 295, 37, 21)
$gx9 = GUICtrlCreateInput($ini22, 30, 322, 37, 21)
$gy9 = GUICtrlCreateInput($ini23, 93, 322, 37, 21)
$gx10 = GUICtrlCreateInput($ini24, 30, 349, 37, 21)
$gy10 = GUICtrlCreateInput($ini25, 93, 349, 37, 21)
$gx11 = GUICtrlCreateInput($ini26, 200, 102, 37, 21)
$gy11 = GUICtrlCreateInput($ini27, 260, 102, 37, 21)
$gx12 = GUICtrlCreateInput($ini28, 200, 129, 37, 21)
$gy12 = GUICtrlCreateInput($ini29, 260, 129, 37, 21)
$gx13 = GUICtrlCreateInput($ini30, 200, 156, 37, 21)
$gy13 = GUICtrlCreateInput($ini31, 260, 156, 37, 21)
$gx14 = GUICtrlCreateInput($ini32, 200, 183, 37, 21)
$gy14 = GUICtrlCreateInput($ini33, 260, 183, 37, 21)
$gx15 = GUICtrlCreateInput($ini34, 200, 210, 37, 21)
$gy15 = GUICtrlCreateInput($ini35, 260, 210, 37, 21)
$gx16 = GUICtrlCreateInput($ini36, 200, 241, 37, 21)
$gy16 = GUICtrlCreateInput($ini37, 260, 241, 37, 21)
$gx17 = GUICtrlCreateInput($ini38, 200, 268, 37, 21)
$gy17 = GUICtrlCreateInput($ini39, 260, 268, 37, 21)
$gx18 = GUICtrlCreateInput($ini40, 200, 295, 37, 21)
$gy18 = GUICtrlCreateInput($ini41, 260, 295, 37, 21)
$gx19 = GUICtrlCreateInput($ini42, 200, 322, 37, 21)
$gy19 = GUICtrlCreateInput($ini43, 260, 322, 37, 21)
$gx20 = GUICtrlCreateInput($ini44, 200, 349, 37, 21)
$gy20 = GUICtrlCreateInput($ini45, 260, 349, 37, 21)
$gx21 = GUICtrlCreateInput($ini46, 450, 102, 37, 21)
$gy21 = GUICtrlCreateInput($ini47, 513, 102, 37, 21)
$gx22 = GUICtrlCreateInput($ini48, 450, 129, 37, 21)
$gy22 = GUICtrlCreateInput($ini49, 513, 129, 37, 21)
$gx23 = GUICtrlCreateInput($ini50, 450, 156, 37, 21)
$gy23 = GUICtrlCreateInput($ini51, 513, 156, 37, 21)
$gx24 = GUICtrlCreateInput($ini52, 450, 183, 37, 21)
$gy24 = GUICtrlCreateInput($ini53, 513, 183, 37, 21)
$gx25 = GUICtrlCreateInput($ini54, 450, 210, 37, 21)
$gy25 = GUICtrlCreateInput($ini55, 513, 210, 37, 21)
$gx26 = GUICtrlCreateInput($ini56, 450, 241, 37, 21)
$gy26 = GUICtrlCreateInput($ini57, 513, 241, 37, 21)
$gx27 = GUICtrlCreateInput($ini58, 450, 268, 37, 21)
$gy27 = GUICtrlCreateInput($ini59, 513, 268, 37, 21)
$gx28 = GUICtrlCreateInput($ini60, 450, 295, 37, 21)
$gy28 = GUICtrlCreateInput($ini61, 513, 295, 37, 21)
$gx29 = GUICtrlCreateInput($ini62, 450, 322, 37, 21)
$gy29 = GUICtrlCreateInput($ini63, 513, 322, 37, 21)
$gx30 = GUICtrlCreateInput($ini64, 450, 349, 37, 21)
$gy30 = GUICtrlCreateInput($ini65, 513, 349, 37, 21)
$gx31 = GUICtrlCreateInput($ini66, 620, 102, 37, 21)
$gy31 = GUICtrlCreateInput($ini67, 680, 102, 37, 21)
$gx32 = GUICtrlCreateInput($ini68, 620, 129, 37, 21)
$gy32 = GUICtrlCreateInput($ini69, 680, 129, 37, 21)
$gx33 = GUICtrlCreateInput($ini70, 620, 156, 37, 21)
$gy33 = GUICtrlCreateInput($ini71, 680, 156, 37, 21)
$gx34 = GUICtrlCreateInput($ini72, 620, 183, 37, 21)
$gy34 = GUICtrlCreateInput($ini73, 680, 183, 37, 21)
$gx35 = GUICtrlCreateInput($ini74, 620, 210, 37, 21)
$gy35 = GUICtrlCreateInput($ini75, 680, 210, 37, 21)
$gx36 = GUICtrlCreateInput($ini76, 620, 241, 37, 21)
$gy36 = GUICtrlCreateInput($ini77, 680, 241, 37, 21)
$gx37 = GUICtrlCreateInput($ini78, 620, 268, 37, 21)
$gy37 = GUICtrlCreateInput($ini79, 680, 268, 37, 21)
$gx38 = GUICtrlCreateInput($ini80, 620, 295, 37, 21)
$gy38 = GUICtrlCreateInput($ini81, 680, 295, 37, 21)
$gx39 = GUICtrlCreateInput($ini82, 620, 322, 37, 21)
$gy39 = GUICtrlCreateInput($ini83, 680, 322, 37, 21)
$gx40 = GUICtrlCreateInput($ini84, 620, 349, 37, 21)
$gy40 = GUICtrlCreateInput($ini85, 680, 349, 37, 21)
GUICtrlCreateLabel("X:", 432, 105, 11, 17)
GUICtrlCreateLabel("X:", 605, 105, 11, 17)
GUICtrlCreateLabel("Y:", 665, 105, 11, 17)
GUICtrlCreateLabel("X:", 605, 132, 11, 17)
GUICtrlCreateLabel("X:", 605, 159, 11, 17)
GUICtrlCreateLabel("X:", 605, 186, 11, 17)
GUICtrlCreateLabel("X:", 605, 213, 11, 17)
GUICtrlCreateLabel("Y:", 665, 159, 11, 17)
GUICtrlCreateLabel("Y:", 665, 186, 11, 17)
GUICtrlCreateLabel("Y:", 665, 213, 11, 17)
GUICtrlCreateLabel("Y:", 665, 132, 11, 17)
GUICtrlCreateLabel("Y:", 498, 159, 11, 17)
GUICtrlCreateLabel("X:", 432, 352, 11, 17)
GUICtrlCreateLabel("X:", 605, 352, 11, 17)
GUICtrlCreateLabel("Y:", 665, 352, 11, 17)
GUICtrlCreateLabel("X:", 605, 244, 11, 17)
GUICtrlCreateLabel("X:", 605, 271, 11, 17)
GUICtrlCreateLabel("X:", 605, 298, 11, 17)
GUICtrlCreateLabel("X:", 605, 325, 11, 17)
GUICtrlCreateLabel("Y:", 665, 325, 11, 17)
GUICtrlCreateLabel("Y:", 665, 271, 11, 17)
GUICtrlCreateLabel("Y:", 665, 298, 11, 17)
GUICtrlCreateLabel("Y:", 665, 244, 11, 17)
GUICtrlCreateLabel("Y:", 665, 244, 11, 17)
GUICtrlCreateLabel("Y:", 498, 271, 11, 17)
GUICtrlCreateLabel("X:", 432, 132, 11, 17)
GUICtrlCreateLabel("Y:", 498, 132, 11, 17)
GUICtrlCreateLabel("Y:", 498, 108, 11, 17)
GUICtrlCreateLabel("Y:", 498, 186, 11, 17)
GUICtrlCreateLabel("Y:", 498, 213, 11, 17)
GUICtrlCreateLabel("X:", 432, 159, 11, 17)
GUICtrlCreateLabel("X:", 432, 186, 11, 17)
GUICtrlCreateLabel("X:", 432, 213, 11, 17)
GUICtrlCreateLabel("X:", 432, 244, 11, 17)
GUICtrlCreateLabel("Y:", 498, 244, 11, 17)
GUICtrlCreateLabel("Y:", 498, 352, 11, 17)
GUICtrlCreateLabel("Y:", 498, 298, 11, 17)
GUICtrlCreateLabel("Y:", 498, 325, 11, 17)
GUICtrlCreateLabel("X:", 432, 271, 11, 17)
GUICtrlCreateLabel("X:", 432, 298, 11, 17)
GUICtrlCreateLabel("X:", 432, 325, 11, 17)

GUICtrlCreateLabel("X:", 12, 105, 11, 17)
GUICtrlCreateLabel("X:", 185, 105, 11, 17)
GUICtrlCreateLabel("Y:", 245, 105, 11, 17)
GUICtrlCreateLabel("X:", 185, 132, 11, 17)
GUICtrlCreateLabel("X:", 185, 159, 11, 17)
GUICtrlCreateLabel("X:", 185, 186, 11, 17)
GUICtrlCreateLabel("X:", 185, 213, 11, 17)
GUICtrlCreateLabel("Y:", 245, 159, 11, 17)
GUICtrlCreateLabel("Y:", 245, 186, 11, 17)
GUICtrlCreateLabel("Y:", 245, 213, 11, 17)
GUICtrlCreateLabel("Y:", 245, 132, 11, 17)
GUICtrlCreateLabel("Y:", 78, 159, 11, 17)
GUICtrlCreateLabel("X:", 12, 352, 11, 17)
GUICtrlCreateLabel("X:", 185, 352, 11, 17)
GUICtrlCreateLabel("Y:", 245, 352, 11, 17)
GUICtrlCreateLabel("X:", 185, 244, 11, 17)
GUICtrlCreateLabel("X:", 185, 271, 11, 17)
GUICtrlCreateLabel("X:", 185, 298, 11, 17)
GUICtrlCreateLabel("X:", 185, 325, 11, 17)
GUICtrlCreateLabel("Y:", 245, 325, 11, 17)
GUICtrlCreateLabel("Y:", 245, 271, 11, 17)
GUICtrlCreateLabel("Y:", 245, 298, 11, 17)
GUICtrlCreateLabel("Y:", 245, 244, 11, 17)
GUICtrlCreateLabel("Y:", 245, 244, 11, 17)
GUICtrlCreateLabel("Y:", 78, 271, 11, 17)
GUICtrlCreateLabel("FARME", 5, 25, 790, 28, $SS_CENTER)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, 0x00FF00)
GUICtrlCreateLabel("X:", 12, 132, 11, 17)
GUICtrlCreateLabel("Y:", 78, 132, 11, 17)
GUICtrlCreateLabel("Y:", 78, 108, 11, 17)
GUICtrlCreateLabel("Y:", 78, 186, 11, 17)
GUICtrlCreateLabel("Y:", 78, 213, 11, 17)
GUICtrlCreateLabel("X:", 12, 159, 11, 17)
GUICtrlCreateLabel("X:", 12, 186, 11, 17)
GUICtrlCreateLabel("X:", 12, 213, 11, 17)
GUICtrlCreateLabel("X:", 12, 244, 11, 17)
GUICtrlCreateLabel("Y:", 78, 244, 11, 17)
GUICtrlCreateLabel("Y:", 78, 352, 11, 17)
GUICtrlCreateLabel("Y:", 78, 298, 11, 17)
GUICtrlCreateLabel("Y:", 78, 325, 11, 17)
GUICtrlCreateLabel("X:", 12, 271, 11, 17)
GUICtrlCreateLabel("X:", 12, 298, 11, 17)
GUICtrlCreateLabel("X:", 12, 325, 11, 17)
GUICtrlCreateTabItem("Farme2")
$gx41 = GUICtrlCreateInput($ini86, 30, 102, 37, 21)
$gy41 = GUICtrlCreateInput($ini87, 93, 102, 37, 21)
$gx42 = GUICtrlCreateInput($ini88, 30, 129, 37, 21)
$gy42 = GUICtrlCreateInput($ini89, 93, 129, 37, 21)
$gx43 = GUICtrlCreateInput($ini90, 30, 156, 37, 21)
$gy43 = GUICtrlCreateInput($ini91, 93, 156, 37, 21)
$gx44 = GUICtrlCreateInput($ini92, 30, 183, 37, 21)
$gy44 = GUICtrlCreateInput($ini93, 93, 183, 37, 21)
$gx45 = GUICtrlCreateInput($ini94, 30, 210, 37, 21)
$gy45 = GUICtrlCreateInput($ini95, 93, 210, 37, 21)
$gx46 = GUICtrlCreateInput($ini96, 30, 241, 37, 21)
$gy46 = GUICtrlCreateInput($ini97, 93, 241, 37, 21)
$gx47 = GUICtrlCreateInput($ini98, 30, 268, 37, 21)
$gy47 = GUICtrlCreateInput($ini99, 93, 268, 37, 21)
$gx48 = GUICtrlCreateInput($ini100, 30, 295, 37, 21)
$gy48 = GUICtrlCreateInput($ini101, 93, 295, 37, 21)
$gx49 = GUICtrlCreateInput($ini102, 30, 322, 37, 21)
$gy49 = GUICtrlCreateInput($ini103, 93, 322, 37, 21)
$gx50 = GUICtrlCreateInput($ini104, 30, 349, 37, 21)
$gy50 = GUICtrlCreateInput($ini105, 93, 349, 37, 21)
$gx51 = GUICtrlCreateInput($ini106, 200, 102, 37, 21)
$gy51 = GUICtrlCreateInput($ini107, 260, 102, 37, 21)
$gx52 = GUICtrlCreateInput($ini108, 200, 129, 37, 21)
$gy52 = GUICtrlCreateInput($ini109, 260, 129, 37, 21)
$gx53 = GUICtrlCreateInput($ini110, 200, 156, 37, 21)
$gy53 = GUICtrlCreateInput($ini111, 260, 156, 37, 21)
$gx54 = GUICtrlCreateInput($ini112, 200, 183, 37, 21)
$gy54 = GUICtrlCreateInput($ini113, 260, 183, 37, 21)
$gx55 = GUICtrlCreateInput($ini114, 200, 210, 37, 21)
$gy55 = GUICtrlCreateInput($ini115, 260, 210, 37, 21)
$gx56 = GUICtrlCreateInput($ini116, 200, 241, 37, 21)
$gy56 = GUICtrlCreateInput($ini117, 260, 241, 37, 21)
$gx57 = GUICtrlCreateInput($ini118, 200, 268, 37, 21)
$gy57 = GUICtrlCreateInput($ini119, 260, 268, 37, 21)
$gx58 = GUICtrlCreateInput($ini120, 200, 295, 37, 21)
$gy58 = GUICtrlCreateInput($ini121, 260, 295, 37, 21)
$gx59 = GUICtrlCreateInput($ini122, 200, 322, 37, 21)
$gy59 = GUICtrlCreateInput($ini123, 260, 322, 37, 21)
$gx60 = GUICtrlCreateInput($ini124, 200, 349, 37, 21)
$gy60 = GUICtrlCreateInput($ini125, 260, 349, 37, 21)
$gx61 = GUICtrlCreateInput($ini126, 450, 102, 37, 21)
$gy61 = GUICtrlCreateInput($ini127, 513, 102, 37, 21)
$gx62 = GUICtrlCreateInput($ini128, 450, 129, 37, 21)
$gy62 = GUICtrlCreateInput($ini129, 513, 129, 37, 21)
$gx63 = GUICtrlCreateInput($ini130, 450, 156, 37, 21)
$gy63 = GUICtrlCreateInput($ini131, 513, 156, 37, 21)
$gx64 = GUICtrlCreateInput($ini132, 450, 183, 37, 21)
$gy64 = GUICtrlCreateInput($ini133, 513, 183, 37, 21)
$gx65 = GUICtrlCreateInput($ini134, 450, 210, 37, 21)
$gy65 = GUICtrlCreateInput($ini135, 513, 210, 37, 21)
$gx66 = GUICtrlCreateInput($ini136, 450, 241, 37, 21)
$gy66 = GUICtrlCreateInput($ini137, 513, 241, 37, 21)
$gx67 = GUICtrlCreateInput($ini138, 450, 268, 37, 21)
$gy67 = GUICtrlCreateInput($ini139, 513, 268, 37, 21)
$gx68 = GUICtrlCreateInput($ini140, 450, 295, 37, 21)
$gy68 = GUICtrlCreateInput($ini141, 513, 295, 37, 21)
$gx69 = GUICtrlCreateInput($ini142, 450, 322, 37, 21)
$gy69 = GUICtrlCreateInput($ini143, 513, 322, 37, 21)
$gx70 = GUICtrlCreateInput($ini144, 450, 349, 37, 21)
$gy70 = GUICtrlCreateInput($ini145, 513, 349, 37, 21)
$gx71 = GUICtrlCreateInput($ini146, 620, 102, 37, 21)
$gy71 = GUICtrlCreateInput($ini147, 680, 102, 37, 21)
$gx72 = GUICtrlCreateInput($ini148, 620, 129, 37, 21)
$gy72 = GUICtrlCreateInput($ini149, 680, 129, 37, 21)
$gx73 = GUICtrlCreateInput($ini150, 620, 156, 37, 21)
$gy73 = GUICtrlCreateInput($ini151, 680, 156, 37, 21)
$gx74 = GUICtrlCreateInput($ini152, 620, 183, 37, 21)
$gy74 = GUICtrlCreateInput($ini153, 680, 183, 37, 21)
$gx75 = GUICtrlCreateInput($ini154, 620, 210, 37, 21)
$gy75 = GUICtrlCreateInput($ini155, 680, 210, 37, 21)
$gx76 = GUICtrlCreateInput($ini156, 620, 241, 37, 21)
$gy76 = GUICtrlCreateInput($ini157, 680, 241, 37, 21)
$gx77 = GUICtrlCreateInput($ini158, 620, 268, 37, 21)
$gy77 = GUICtrlCreateInput($ini159, 680, 268, 37, 21)
$gx78 = GUICtrlCreateInput($ini160, 620, 295, 37, 21)
$gy78 = GUICtrlCreateInput($ini161, 680, 295, 37, 21)
$gx79 = GUICtrlCreateInput($ini162, 620, 322, 37, 21)
$gy79 = GUICtrlCreateInput($ini163, 680, 322, 37, 21)
$gx80 = GUICtrlCreateInput($ini164, 620, 349, 37, 21)
$gy80 = GUICtrlCreateInput($ini165, 680, 349, 37, 21)
GUICtrlCreateLabel("X:", 432, 105, 11, 17)
GUICtrlCreateLabel("X:", 605, 105, 11, 17)
GUICtrlCreateLabel("Y:", 665, 105, 11, 17)
GUICtrlCreateLabel("X:", 605, 132, 11, 17)
GUICtrlCreateLabel("X:", 605, 159, 11, 17)
GUICtrlCreateLabel("X:", 605, 186, 11, 17)
GUICtrlCreateLabel("X:", 605, 213, 11, 17)
GUICtrlCreateLabel("Y:", 665, 159, 11, 17)
GUICtrlCreateLabel("Y:", 665, 186, 11, 17)
GUICtrlCreateLabel("Y:", 665, 213, 11, 17)
GUICtrlCreateLabel("Y:", 665, 132, 11, 17)
GUICtrlCreateLabel("Y:", 498, 159, 11, 17)
GUICtrlCreateLabel("X:", 432, 352, 11, 17)
GUICtrlCreateLabel("X:", 605, 352, 11, 17)
GUICtrlCreateLabel("Y:", 665, 352, 11, 17)
GUICtrlCreateLabel("X:", 605, 244, 11, 17)
GUICtrlCreateLabel("X:", 605, 271, 11, 17)
GUICtrlCreateLabel("X:", 605, 298, 11, 17)
GUICtrlCreateLabel("X:", 605, 325, 11, 17)
GUICtrlCreateLabel("Y:", 665, 325, 11, 17)
GUICtrlCreateLabel("Y:", 665, 271, 11, 17)
GUICtrlCreateLabel("Y:", 665, 298, 11, 17)
GUICtrlCreateLabel("Y:", 665, 244, 11, 17)
GUICtrlCreateLabel("Y:", 665, 244, 11, 17)
GUICtrlCreateLabel("Y:", 498, 271, 11, 17)
GUICtrlCreateLabel("X:", 432, 132, 11, 17)
GUICtrlCreateLabel("Y:", 498, 132, 11, 17)
GUICtrlCreateLabel("Y:", 498, 108, 11, 17)
GUICtrlCreateLabel("Y:", 498, 186, 11, 17)
GUICtrlCreateLabel("Y:", 498, 213, 11, 17)
GUICtrlCreateLabel("X:", 432, 159, 11, 17)
GUICtrlCreateLabel("X:", 432, 186, 11, 17)
GUICtrlCreateLabel("X:", 432, 213, 11, 17)
GUICtrlCreateLabel("X:", 432, 244, 11, 17)
GUICtrlCreateLabel("Y:", 498, 244, 11, 17)
GUICtrlCreateLabel("Y:", 498, 352, 11, 17)
GUICtrlCreateLabel("Y:", 498, 298, 11, 17)
GUICtrlCreateLabel("Y:", 498, 325, 11, 17)
GUICtrlCreateLabel("X:", 432, 271, 11, 17)
GUICtrlCreateLabel("X:", 432, 298, 11, 17)
GUICtrlCreateLabel("X:", 432, 325, 11, 17)

GUICtrlCreateLabel("X:", 12, 105, 11, 17)
GUICtrlCreateLabel("X:", 185, 105, 11, 17)
GUICtrlCreateLabel("Y:", 245, 105, 11, 17)
GUICtrlCreateLabel("X:", 185, 132, 11, 17)
GUICtrlCreateLabel("X:", 185, 159, 11, 17)
GUICtrlCreateLabel("X:", 185, 186, 11, 17)
GUICtrlCreateLabel("X:", 185, 213, 11, 17)
GUICtrlCreateLabel("Y:", 245, 159, 11, 17)
GUICtrlCreateLabel("Y:", 245, 186, 11, 17)
GUICtrlCreateLabel("Y:", 245, 213, 11, 17)
GUICtrlCreateLabel("Y:", 245, 132, 11, 17)
GUICtrlCreateLabel("Y:", 78, 159, 11, 17)
GUICtrlCreateLabel("X:", 12, 352, 11, 17)
GUICtrlCreateLabel("X:", 185, 352, 11, 17)
GUICtrlCreateLabel("Y:", 245, 352, 11, 17)
GUICtrlCreateLabel("X:", 185, 244, 11, 17)
GUICtrlCreateLabel("X:", 185, 271, 11, 17)
GUICtrlCreateLabel("X:", 185, 298, 11, 17)
GUICtrlCreateLabel("X:", 185, 325, 11, 17)
GUICtrlCreateLabel("Y:", 245, 325, 11, 17)
GUICtrlCreateLabel("Y:", 245, 271, 11, 17)
GUICtrlCreateLabel("Y:", 245, 298, 11, 17)
GUICtrlCreateLabel("Y:", 245, 244, 11, 17)
GUICtrlCreateLabel("Y:", 245, 244, 11, 17)
GUICtrlCreateLabel("Y:", 78, 271, 11, 17)
GUICtrlCreateLabel("FARME2", 5, 25, 790, 28, $SS_CENTER)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, 0x00FF00)
GUICtrlCreateLabel("X:", 12, 132, 11, 17)
GUICtrlCreateLabel("Y:", 78, 132, 11, 17)
GUICtrlCreateLabel("Y:", 78, 108, 11, 17)
GUICtrlCreateLabel("Y:", 78, 186, 11, 17)
GUICtrlCreateLabel("Y:", 78, 213, 11, 17)
GUICtrlCreateLabel("X:", 12, 159, 11, 17)
GUICtrlCreateLabel("X:", 12, 186, 11, 17)
GUICtrlCreateLabel("X:", 12, 213, 11, 17)
GUICtrlCreateLabel("X:", 12, 244, 11, 17)
GUICtrlCreateLabel("Y:", 78, 244, 11, 17)
GUICtrlCreateLabel("Y:", 78, 352, 11, 17)
GUICtrlCreateLabel("Y:", 78, 298, 11, 17)
GUICtrlCreateLabel("Y:", 78, 325, 11, 17)
GUICtrlCreateLabel("X:", 12, 271, 11, 17)
GUICtrlCreateLabel("X:", 12, 298, 11, 17)
GUICtrlCreateLabel("X:", 12, 325, 11, 17)
GUICtrlCreateTabItem("Farme3")
$gx81 = GUICtrlCreateInput($ini166, 30, 102, 37, 21)
$gy81 = GUICtrlCreateInput($ini167, 93, 102, 37, 21)
$gx82 = GUICtrlCreateInput($ini168, 30, 129, 37, 21)
$gy82 = GUICtrlCreateInput($ini169, 93, 129, 37, 21)
$gx83 = GUICtrlCreateInput($ini170, 30, 156, 37, 21)
$gy83 = GUICtrlCreateInput($ini171, 93, 156, 37, 21)
$gx84 = GUICtrlCreateInput($ini172, 30, 183, 37, 21)
$gy84 = GUICtrlCreateInput($ini173, 93, 183, 37, 21)
$gx85 = GUICtrlCreateInput($ini174, 30, 210, 37, 21)
$gy85 = GUICtrlCreateInput($ini175, 93, 210, 37, 21)
$gx86 = GUICtrlCreateInput($ini176, 30, 241, 37, 21)
$gy86 = GUICtrlCreateInput($ini177, 93, 241, 37, 21)
$gx87 = GUICtrlCreateInput($ini178, 30, 268, 37, 21)
$gy87 = GUICtrlCreateInput($ini179, 93, 268, 37, 21)
$gx88 = GUICtrlCreateInput($ini180, 30, 295, 37, 21)
$gy88 = GUICtrlCreateInput($ini181, 93, 295, 37, 21)
$gx89 = GUICtrlCreateInput($ini182, 30, 322, 37, 21)
$gy89 = GUICtrlCreateInput($ini183, 93, 322, 37, 21)
$gx90 = GUICtrlCreateInput($ini184, 30, 349, 37, 21)
$gy90 = GUICtrlCreateInput($ini185, 93, 349, 37, 21)
$gx91 = GUICtrlCreateInput($ini186, 200, 102, 37, 21)
$gy91 = GUICtrlCreateInput($ini187, 260, 102, 37, 21)
$gx92 = GUICtrlCreateInput($ini188, 200, 129, 37, 21)
$gy92 = GUICtrlCreateInput($ini189, 260, 129, 37, 21)
$gx93 = GUICtrlCreateInput($ini190, 200, 156, 37, 21)
$gy93 = GUICtrlCreateInput($ini191, 260, 156, 37, 21)
$gx94 = GUICtrlCreateInput($ini192, 200, 183, 37, 21)
$gy94 = GUICtrlCreateInput($ini193, 260, 183, 37, 21)
$gx95 = GUICtrlCreateInput($ini194, 200, 210, 37, 21)
$gy95 = GUICtrlCreateInput($ini195, 260, 210, 37, 21)
$gx96 = GUICtrlCreateInput($ini196, 200, 241, 37, 21)
$gy96 = GUICtrlCreateInput($ini197, 260, 241, 37, 21)
$gx97 = GUICtrlCreateInput($ini198, 200, 268, 37, 21)
$gy97 = GUICtrlCreateInput($ini199, 260, 268, 37, 21)
$gx98 = GUICtrlCreateInput($ini200, 200, 295, 37, 21)
$gy98 = GUICtrlCreateInput($ini201, 260, 295, 37, 21)
$gx99 = GUICtrlCreateInput($ini202, 200, 322, 37, 21)
$gy99 = GUICtrlCreateInput($ini203, 260, 322, 37, 21)
$gx100 = GUICtrlCreateInput($ini204, 200, 349, 37, 21)
$gy100 = GUICtrlCreateInput($ini205, 260, 349, 37, 21)
$gx101 = GUICtrlCreateInput($ini206, 450, 102, 37, 21)
$gy101 = GUICtrlCreateInput($ini207, 513, 102, 37, 21)
$gx102 = GUICtrlCreateInput($ini208, 450, 129, 37, 21)
$gy102 = GUICtrlCreateInput($ini209, 513, 129, 37, 21)
$gx103 = GUICtrlCreateInput($ini210, 450, 156, 37, 21)
$gy103 = GUICtrlCreateInput($ini211, 513, 156, 37, 21)
$gx104 = GUICtrlCreateInput($ini212, 450, 183, 37, 21)
$gy104 = GUICtrlCreateInput($ini213, 513, 183, 37, 21)
$gx105 = GUICtrlCreateInput($ini214, 450, 210, 37, 21)
$gy105 = GUICtrlCreateInput($ini215, 513, 210, 37, 21)
$gx106 = GUICtrlCreateInput($ini216, 450, 241, 37, 21)
$gy106 = GUICtrlCreateInput($ini217, 513, 241, 37, 21)
$gx107 = GUICtrlCreateInput($ini218, 450, 268, 37, 21)
$gy107 = GUICtrlCreateInput($ini219, 513, 268, 37, 21)
$gx108 = GUICtrlCreateInput($ini220, 450, 295, 37, 21)
$gy108 = GUICtrlCreateInput($ini221, 513, 295, 37, 21)
$gx109 = GUICtrlCreateInput($ini222, 450, 322, 37, 21)
$gy109 = GUICtrlCreateInput($ini223, 513, 322, 37, 21)
$gx110 = GUICtrlCreateInput($ini224, 450, 349, 37, 21)
$gy110 = GUICtrlCreateInput($ini225, 513, 349, 37, 21)
$gx111 = GUICtrlCreateInput($ini226, 620, 102, 37, 21)
$gy111 = GUICtrlCreateInput($ini227, 680, 102, 37, 21)
$gx112 = GUICtrlCreateInput($ini228, 620, 129, 37, 21)
$gy112 = GUICtrlCreateInput($ini229, 680, 129, 37, 21)
$gx113 = GUICtrlCreateInput($ini230, 620, 156, 37, 21)
$gy113 = GUICtrlCreateInput($ini231, 680, 156, 37, 21)
$gx114 = GUICtrlCreateInput($ini232, 620, 183, 37, 21)
$gy114 = GUICtrlCreateInput($ini233, 680, 183, 37, 21)
$gx115 = GUICtrlCreateInput($ini234, 620, 210, 37, 21)
$gy115 = GUICtrlCreateInput($ini235, 680, 210, 37, 21)
$gx116 = GUICtrlCreateInput($ini236, 620, 241, 37, 21)
$gy116 = GUICtrlCreateInput($ini237, 680, 241, 37, 21)
$gx117 = GUICtrlCreateInput($ini238, 620, 268, 37, 21)
$gy117 = GUICtrlCreateInput($ini239, 680, 268, 37, 21)
$gx118 = GUICtrlCreateInput($ini240, 620, 295, 37, 21)
$gy118 = GUICtrlCreateInput($ini241, 680, 295, 37, 21)
$gx119 = GUICtrlCreateInput($ini242, 620, 322, 37, 21)
$gy119 = GUICtrlCreateInput($ini243, 680, 322, 37, 21)
$gx120 = GUICtrlCreateInput($ini244, 620, 349, 37, 21)
$gy120 = GUICtrlCreateInput($ini245, 680, 349, 37, 21)
GUICtrlCreateLabel("X:", 432, 105, 11, 17)
GUICtrlCreateLabel("X:", 605, 105, 11, 17)
GUICtrlCreateLabel("Y:", 665, 105, 11, 17)
GUICtrlCreateLabel("X:", 605, 132, 11, 17)
GUICtrlCreateLabel("X:", 605, 159, 11, 17)
GUICtrlCreateLabel("X:", 605, 186, 11, 17)
GUICtrlCreateLabel("X:", 605, 213, 11, 17)
GUICtrlCreateLabel("Y:", 665, 159, 11, 17)
GUICtrlCreateLabel("Y:", 665, 186, 11, 17)
GUICtrlCreateLabel("Y:", 665, 213, 11, 17)
GUICtrlCreateLabel("Y:", 665, 132, 11, 17)
GUICtrlCreateLabel("Y:", 498, 159, 11, 17)
GUICtrlCreateLabel("X:", 432, 352, 11, 17)
GUICtrlCreateLabel("X:", 605, 352, 11, 17)
GUICtrlCreateLabel("Y:", 665, 352, 11, 17)
GUICtrlCreateLabel("X:", 605, 244, 11, 17)
GUICtrlCreateLabel("X:", 605, 271, 11, 17)
GUICtrlCreateLabel("X:", 605, 298, 11, 17)
GUICtrlCreateLabel("X:", 605, 325, 11, 17)
GUICtrlCreateLabel("Y:", 665, 325, 11, 17)
GUICtrlCreateLabel("Y:", 665, 271, 11, 17)
GUICtrlCreateLabel("Y:", 665, 298, 11, 17)
GUICtrlCreateLabel("Y:", 665, 244, 11, 17)
GUICtrlCreateLabel("Y:", 665, 244, 11, 17)
GUICtrlCreateLabel("Y:", 498, 271, 11, 17)
GUICtrlCreateLabel("X:", 432, 132, 11, 17)
GUICtrlCreateLabel("Y:", 498, 132, 11, 17)
GUICtrlCreateLabel("Y:", 498, 108, 11, 17)
GUICtrlCreateLabel("Y:", 498, 186, 11, 17)
GUICtrlCreateLabel("Y:", 498, 213, 11, 17)
GUICtrlCreateLabel("X:", 432, 159, 11, 17)
GUICtrlCreateLabel("X:", 432, 186, 11, 17)
GUICtrlCreateLabel("X:", 432, 213, 11, 17)
GUICtrlCreateLabel("X:", 432, 244, 11, 17)
GUICtrlCreateLabel("Y:", 498, 244, 11, 17)
GUICtrlCreateLabel("Y:", 498, 352, 11, 17)
GUICtrlCreateLabel("Y:", 498, 298, 11, 17)
GUICtrlCreateLabel("Y:", 498, 325, 11, 17)
GUICtrlCreateLabel("X:", 432, 271, 11, 17)
GUICtrlCreateLabel("X:", 432, 298, 11, 17)
GUICtrlCreateLabel("X:", 432, 325, 11, 17)

GUICtrlCreateLabel("X:", 12, 105, 11, 17)
GUICtrlCreateLabel("X:", 185, 105, 11, 17)
GUICtrlCreateLabel("Y:", 245, 105, 11, 17)
GUICtrlCreateLabel("X:", 185, 132, 11, 17)
GUICtrlCreateLabel("X:", 185, 159, 11, 17)
GUICtrlCreateLabel("X:", 185, 186, 11, 17)
GUICtrlCreateLabel("X:", 185, 213, 11, 17)
GUICtrlCreateLabel("Y:", 245, 159, 11, 17)
GUICtrlCreateLabel("Y:", 245, 186, 11, 17)
GUICtrlCreateLabel("Y:", 245, 213, 11, 17)
GUICtrlCreateLabel("Y:", 245, 132, 11, 17)
GUICtrlCreateLabel("Y:", 78, 159, 11, 17)
GUICtrlCreateLabel("X:", 12, 352, 11, 17)
GUICtrlCreateLabel("X:", 185, 352, 11, 17)
GUICtrlCreateLabel("Y:", 245, 352, 11, 17)
GUICtrlCreateLabel("X:", 185, 244, 11, 17)
GUICtrlCreateLabel("X:", 185, 271, 11, 17)
GUICtrlCreateLabel("X:", 185, 298, 11, 17)
GUICtrlCreateLabel("X:", 185, 325, 11, 17)
GUICtrlCreateLabel("Y:", 245, 325, 11, 17)
GUICtrlCreateLabel("Y:", 245, 271, 11, 17)
GUICtrlCreateLabel("Y:", 245, 298, 11, 17)
GUICtrlCreateLabel("Y:", 245, 244, 11, 17)
GUICtrlCreateLabel("Y:", 245, 244, 11, 17)
GUICtrlCreateLabel("Y:", 78, 271, 11, 17)
GUICtrlCreateLabel("FARME3", 5, 25, 790, 28, $SS_CENTER)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, 0x00FF00)
GUICtrlCreateLabel("X:", 12, 132, 11, 17)
GUICtrlCreateLabel("Y:", 78, 132, 11, 17)
GUICtrlCreateLabel("Y:", 78, 108, 11, 17)
GUICtrlCreateLabel("Y:", 78, 186, 11, 17)
GUICtrlCreateLabel("Y:", 78, 213, 11, 17)
GUICtrlCreateLabel("X:", 12, 159, 11, 17)
GUICtrlCreateLabel("X:", 12, 186, 11, 17)
GUICtrlCreateLabel("X:", 12, 213, 11, 17)
GUICtrlCreateLabel("X:", 12, 244, 11, 17)
GUICtrlCreateLabel("Y:", 78, 244, 11, 17)
GUICtrlCreateLabel("Y:", 78, 352, 11, 17)
GUICtrlCreateLabel("Y:", 78, 298, 11, 17)
GUICtrlCreateLabel("Y:", 78, 325, 11, 17)
GUICtrlCreateLabel("X:", 12, 271, 11, 17)
GUICtrlCreateLabel("X:", 12, 298, 11, 17)
GUICtrlCreateLabel("X:", 12, 325, 11, 17)

GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $gok
			$user = GUICtrlRead($gime)
			$password = GUICtrlRead($ggeslo)
			$gorjacar = GUICtrlRead($ggorjacar)
			If $gorjacar = 0 Then
				$gorjacar = Number(-1)
			EndIf
			$gorjacar2 = GUICtrlRead($ggorjacar2)
			$paladin =  GUICtrlRead($gpaladin)
			If $paladin = 0 Then
				$paladin = Number(-1)
			EndIf
			$paladin2 =  GUICtrlRead($gpaladin2)
			$metalec =  GUICtrlRead($sekire)
			If $metalec = 0 Then
				$metalec = Number(-1)
			EndIf
			$metalec2 =  GUICtrlRead($sekire2)
			$tevtonskivitez =  GUICtrlRead($vitezi)
			If $tevtonskivitez = 0 Then
				$tevtonskivitez = Number(-1)
			EndIf
			$tevtonskivitez2 =  GUICtrlRead($vitezi2)
			$pavza2 = GUICtrlRead($pavza)*60*1000
			$izbiraumika = GUICtrlRead($obnapadu)
			$barakeid = GUICtrlRead($idbarak)
			$surovine2 = GUICtrlRead($surovine)
			$izurigorjacarje = GUICtrlRead($traingor)
			$izurisulicarje = GUICtrlRead($trainsulic)
			$izurimetalce = GUICtrlRead($trainmet)
			$x1 = GUICtrlRead($gx1)
			$x2 = GUICtrlRead($gx2)
			$x3 = GUICtrlRead($gx3)
			$x4 = GUICtrlRead($gx4)
			$x5 = GUICtrlRead($gx5)
			$x6 = GUICtrlRead($gx6)
			$x7 = GUICtrlRead($gx7)
			$x8 = GUICtrlRead($gx8)
			$x9 = GUICtrlRead($gx9)
			$x10 = GUICtrlRead($gx10)
			$x11 = GUICtrlRead($gx11)
			$x12 = GUICtrlRead($gx12)
			$x13 = GUICtrlRead($gx13)
			$x14 = GUICtrlRead($gx14)
			$x15 = GUICtrlRead($gx15)
			$x16 = GUICtrlRead($gx16)
			$x17 = GUICtrlRead($gx17)
			$x18 = GUICtrlRead($gx18)
			$x19 = GUICtrlRead($gx19)
			$x20 = GUICtrlRead($gx20)
			$y1 = GUICtrlRead($gy1)
			$y2 = GUICtrlRead($gy2)
			$y3 = GUICtrlRead($gy3)
			$y4 = GUICtrlRead($gy4)
			$y5 = GUICtrlRead($gy5)
			$y6 = GUICtrlRead($gy6)
			$y7 = GUICtrlRead($gy7)
			$y8 = GUICtrlRead($gy8)
			$y9 = GUICtrlRead($gy9)
			$y10 = GUICtrlRead($gy10)
			$y11 = GUICtrlRead($gy11)
			$y12 = GUICtrlRead($gy12)
			$y13 = GUICtrlRead($gy13)
			$y14 = GUICtrlRead($gy14)
			$y15 = GUICtrlRead($gy15)
			$y16 = GUICtrlRead($gy16)
			$y17 = GUICtrlRead($gy17)
			$y18 = GUICtrlRead($gy18)
			$y19 = GUICtrlRead($gy19)
			$y20 = GUICtrlRead($gy20)
			$x21 = GUICtrlRead($gx21)
			$x22 = GUICtrlRead($gx22)
			$x23 = GUICtrlRead($gx23)
			$x24 = GUICtrlRead($gx24)
			$x25 = GUICtrlRead($gx25)
			$x26 = GUICtrlRead($gx26)
			$x27 = GUICtrlRead($gx27)
			$x28 = GUICtrlRead($gx28)
			$x29 = GUICtrlRead($gx29)
			$x30 = GUICtrlRead($gx30)
			$x31 = GUICtrlRead($gx31)
			$x32 = GUICtrlRead($gx32)
			$x33 = GUICtrlRead($gx33)
			$x34 = GUICtrlRead($gx34)
			$x35 = GUICtrlRead($gx35)
			$x36 = GUICtrlRead($gx36)
			$x37 = GUICtrlRead($gx37)
			$x38 = GUICtrlRead($gx38)
			$x39 = GUICtrlRead($gx39)
			$x40 = GUICtrlRead($gx40)
			$y21 = GUICtrlRead($gy21)
			$y22 = GUICtrlRead($gy22)
			$y23 = GUICtrlRead($gy23)
			$y24 = GUICtrlRead($gy24)
			$y25 = GUICtrlRead($gy25)
			$y26 = GUICtrlRead($gy26)
			$y27 = GUICtrlRead($gy27)
			$y28 = GUICtrlRead($gy28)
			$y29 = GUICtrlRead($gy29)
			$y30 = GUICtrlRead($gy30)
			$y31 = GUICtrlRead($gy31)
			$y32 = GUICtrlRead($gy32)
			$y33 = GUICtrlRead($gy33)
			$y34 = GUICtrlRead($gy34)
			$y35 = GUICtrlRead($gy35)
			$y36 = GUICtrlRead($gy36)
			$y37 = GUICtrlRead($gy37)
			$y38 = GUICtrlRead($gy38)
			$y39 = GUICtrlRead($gy39)
			$y40 = GUICtrlRead($gy40)
			$x41 = GUICtrlRead($gx41)
			$x42 = GUICtrlRead($gx42)
			$x43 = GUICtrlRead($gx43)
			$x44 = GUICtrlRead($gx44)
			$x45 = GUICtrlRead($gx45)
			$x46 = GUICtrlRead($gx46)
			$x47 = GUICtrlRead($gx47)
			$x48 = GUICtrlRead($gx48)
			$x49 = GUICtrlRead($gx49)
			$x50 = GUICtrlRead($gx50)
			$x51 = GUICtrlRead($gx51)
			$x52 = GUICtrlRead($gx52)
			$x53 = GUICtrlRead($gx53)
			$x54 = GUICtrlRead($gx54)
			$x55 = GUICtrlRead($gx55)
			$x56 = GUICtrlRead($gx56)
			$x57 = GUICtrlRead($gx57)
			$x58 = GUICtrlRead($gx58)
			$x59 = GUICtrlRead($gx59)
			$x60 = GUICtrlRead($gx60)
			$y41 = GUICtrlRead($gy41)
			$y42 = GUICtrlRead($gy42)
			$y43 = GUICtrlRead($gy43)
			$y44 = GUICtrlRead($gy44)
			$y45 = GUICtrlRead($gy45)
			$y46 = GUICtrlRead($gy46)
			$y47 = GUICtrlRead($gy47)
			$y48 = GUICtrlRead($gy48)
			$y49 = GUICtrlRead($gy49)
			$y50 = GUICtrlRead($gy50)
			$y51 = GUICtrlRead($gy51)
			$y52 = GUICtrlRead($gy52)
			$y53 = GUICtrlRead($gy53)
			$y54 = GUICtrlRead($gy54)
			$y55 = GUICtrlRead($gy55)
			$y56 = GUICtrlRead($gy56)
			$y57 = GUICtrlRead($gy57)
			$y58 = GUICtrlRead($gy58)
			$y59 = GUICtrlRead($gy59)
			$y60 = GUICtrlRead($gy60)
			$x61 = GUICtrlRead($gx61)
			$x62 = GUICtrlRead($gx62)
			$x63 = GUICtrlRead($gx63)
			$x64 = GUICtrlRead($gx64)
			$x65 = GUICtrlRead($gx65)
			$x66 = GUICtrlRead($gx66)
			$x67 = GUICtrlRead($gx67)
			$x68 = GUICtrlRead($gx68)
			$x69 = GUICtrlRead($gx69)
			$x70 = GUICtrlRead($gx70)
			$x71 = GUICtrlRead($gx71)
			$x72 = GUICtrlRead($gx72)
			$x73 = GUICtrlRead($gx73)
			$x74 = GUICtrlRead($gx74)
			$x75 = GUICtrlRead($gx75)
			$x76 = GUICtrlRead($gx76)
			$x77 = GUICtrlRead($gx77)
			$x78 = GUICtrlRead($gx78)
			$x79 = GUICtrlRead($gx79)
			$x80 = GUICtrlRead($gx80)
			$y61 = GUICtrlRead($gy61)
			$y62 = GUICtrlRead($gy62)
			$y63 = GUICtrlRead($gy63)
			$y64 = GUICtrlRead($gy64)
			$y65 = GUICtrlRead($gy65)
			$y66 = GUICtrlRead($gy66)
			$y67 = GUICtrlRead($gy67)
			$y68 = GUICtrlRead($gy68)
			$y69 = GUICtrlRead($gy69)
			$y70 = GUICtrlRead($gy70)
			$y71 = GUICtrlRead($gy71)
			$y72 = GUICtrlRead($gy72)
			$y73 = GUICtrlRead($gy73)
			$y74 = GUICtrlRead($gy74)
			$y75 = GUICtrlRead($gy75)
			$y76 = GUICtrlRead($gy76)
			$y77 = GUICtrlRead($gy77)
			$y78 = GUICtrlRead($gy78)
			$y79 = GUICtrlRead($gy79)
			$y80 = GUICtrlRead($gy80)
			$x81 = GUICtrlRead($gx81)
			$x82 = GUICtrlRead($gx82)
			$x83 = GUICtrlRead($gx83)
			$x84 = GUICtrlRead($gx84)
			$x85 = GUICtrlRead($gx85)
			$x86 = GUICtrlRead($gx86)
			$x87 = GUICtrlRead($gx87)
			$x88 = GUICtrlRead($gx88)
			$x89 = GUICtrlRead($gx89)
			$x90 = GUICtrlRead($gx90)
			$x91 = GUICtrlRead($gx91)
			$x92 = GUICtrlRead($gx92)
			$x93 = GUICtrlRead($gx93)
			$x94 = GUICtrlRead($gx94)
			$x95 = GUICtrlRead($gx95)
			$x96 = GUICtrlRead($gx96)
			$x97 = GUICtrlRead($gx97)
			$x98 = GUICtrlRead($gx98)
			$x99 = GUICtrlRead($gx99)
			$x100 = GUICtrlRead($gx100)
			$y81 = GUICtrlRead($gy81)
			$y82 = GUICtrlRead($gy82)
			$y83 = GUICtrlRead($gy83)
			$y84 = GUICtrlRead($gy84)
			$y85 = GUICtrlRead($gy85)
			$y86 = GUICtrlRead($gy86)
			$y87 = GUICtrlRead($gy87)
			$y88 = GUICtrlRead($gy88)
			$y89 = GUICtrlRead($gy89)
			$y90 = GUICtrlRead($gy90)
			$y91 = GUICtrlRead($gy91)
			$y92 = GUICtrlRead($gy92)
			$y93 = GUICtrlRead($gy93)
			$y94 = GUICtrlRead($gy94)
			$y95 = GUICtrlRead($gy95)
			$y96 = GUICtrlRead($gy96)
			$y97 = GUICtrlRead($gy97)
			$y98 = GUICtrlRead($gy98)
			$y99 = GUICtrlRead($gy99)
			$y100 = GUICtrlRead($gy100)
			$x101 = GUICtrlRead($gx101)
			$x102 = GUICtrlRead($gx102)
			$x103 = GUICtrlRead($gx103)
			$x104 = GUICtrlRead($gx104)
			$x105 = GUICtrlRead($gx105)
			$x106 = GUICtrlRead($gx106)
			$x107 = GUICtrlRead($gx107)
			$x108 = GUICtrlRead($gx108)
			$x109 = GUICtrlRead($gx109)
			$x110 = GUICtrlRead($gx110)
			$x111 = GUICtrlRead($gx111)
			$x112 = GUICtrlRead($gx112)
			$x113 = GUICtrlRead($gx113)
			$x114 = GUICtrlRead($gx114)
			$x115 = GUICtrlRead($gx115)
			$x116 = GUICtrlRead($gx116)
			$x117 = GUICtrlRead($gx117)
			$x118 = GUICtrlRead($gx118)
			$x119 = GUICtrlRead($gx119)
			$x120 = GUICtrlRead($gx120)
			$y101 = GUICtrlRead($gy101)
			$y102 = GUICtrlRead($gy102)
			$y103 = GUICtrlRead($gy103)
			$y104 = GUICtrlRead($gy104)
			$y105 = GUICtrlRead($gy105)
			$y106 = GUICtrlRead($gy106)
			$y107 = GUICtrlRead($gy107)
			$y108 = GUICtrlRead($gy108)
			$y109 = GUICtrlRead($gy109)
			$y110 = GUICtrlRead($gy110)
			$y111 = GUICtrlRead($gy111)
			$y112 = GUICtrlRead($gy112)
			$y113 = GUICtrlRead($gy113)
			$y114 = GUICtrlRead($gy114)
			$y115 = GUICtrlRead($gy115)
			$y116 = GUICtrlRead($gy116)
			$y117 = GUICtrlRead($gy117)
			$y118 = GUICtrlRead($gy118)
			$y119 = GUICtrlRead($gy119)
			$y120 = GUICtrlRead($gy120)
			IniWrite("save.ini", "PODATKI", "user", $user)
			IniWrite("save.ini", "PODATKI", "password", $password)
			IniWrite("save.ini", "PODATKI", "gorjacar", $gorjacar)
			IniWrite("save.ini", "PODATKI", "x1", $x1)
			IniWrite("save.ini", "PODATKI", "x2", $x2)
			IniWrite("save.ini", "PODATKI", "x3", $x3)
			IniWrite("save.ini", "PODATKI", "x4", $x4)
			IniWrite("save.ini", "PODATKI", "x5", $x5)
			IniWrite("save.ini", "PODATKI", "x6", $x6)
			IniWrite("save.ini", "PODATKI", "x7", $x7)
			IniWrite("save.ini", "PODATKI", "x8", $x8)
			IniWrite("save.ini", "PODATKI", "x9", $x9)
			IniWrite("save.ini", "PODATKI", "x10", $x10)
			IniWrite("save.ini", "PODATKI", "x11", $x11)
			IniWrite("save.ini", "PODATKI", "x12", $x12)
			IniWrite("save.ini", "PODATKI", "x13", $x13)
			IniWrite("save.ini", "PODATKI", "x14", $x14)
			IniWrite("save.ini", "PODATKI", "x15", $x15)
			IniWrite("save.ini", "PODATKI", "x16", $x16)
			IniWrite("save.ini", "PODATKI", "x17", $x17)
			IniWrite("save.ini", "PODATKI", "x18", $x18)
			IniWrite("save.ini", "PODATKI", "x19", $x19)
			IniWrite("save.ini", "PODATKI", "x20", $x20)
			IniWrite("save.ini", "PODATKI", "y1", $y1)
			IniWrite("save.ini", "PODATKI", "y2", $y2)
			IniWrite("save.ini", "PODATKI", "y3", $y3)
			IniWrite("save.ini", "PODATKI", "y4", $y4)
			IniWrite("save.ini", "PODATKI", "y5", $y5)
			IniWrite("save.ini", "PODATKI", "y6", $y6)
			IniWrite("save.ini", "PODATKI", "y7", $y7)
			IniWrite("save.ini", "PODATKI", "y8", $y8)
			IniWrite("save.ini", "PODATKI", "y9", $y9)
			IniWrite("save.ini", "PODATKI", "y10", $y10)
			IniWrite("save.ini", "PODATKI", "y11", $y11)
			IniWrite("save.ini", "PODATKI", "y12", $y12)
			IniWrite("save.ini", "PODATKI", "y13", $y13)
			IniWrite("save.ini", "PODATKI", "y14", $y14)
			IniWrite("save.ini", "PODATKI", "y15", $y15)
			IniWrite("save.ini", "PODATKI", "y16", $y16)
			IniWrite("save.ini", "PODATKI", "y17", $y17)
			IniWrite("save.ini", "PODATKI", "y18", $y18)
			IniWrite("save.ini", "PODATKI", "y19", $y19)
			IniWrite("save.ini", "PODATKI", "y20", $y20)
			IniWrite("save.ini", "PODATKI", "x21", $x21)
			IniWrite("save.ini", "PODATKI", "x22", $x22)
			IniWrite("save.ini", "PODATKI", "x23", $x23)
			IniWrite("save.ini", "PODATKI", "x24", $x24)
			IniWrite("save.ini", "PODATKI", "x25", $x25)
			IniWrite("save.ini", "PODATKI", "x26", $x26)
			IniWrite("save.ini", "PODATKI", "x27", $x27)
			IniWrite("save.ini", "PODATKI", "x28", $x28)
			IniWrite("save.ini", "PODATKI", "x29", $x29)
			IniWrite("save.ini", "PODATKI", "x30", $x30)
			IniWrite("save.ini", "PODATKI", "x31", $x31)
			IniWrite("save.ini", "PODATKI", "x32", $x32)
			IniWrite("save.ini", "PODATKI", "x33", $x33)
			IniWrite("save.ini", "PODATKI", "x34", $x34)
			IniWrite("save.ini", "PODATKI", "x35", $x35)
			IniWrite("save.ini", "PODATKI", "x36", $x36)
			IniWrite("save.ini", "PODATKI", "x37", $x37)
			IniWrite("save.ini", "PODATKI", "x38", $x38)
			IniWrite("save.ini", "PODATKI", "x39", $x39)
			IniWrite("save.ini", "PODATKI", "x40", $x40)
			IniWrite("save.ini", "PODATKI", "y21", $y21)
			IniWrite("save.ini", "PODATKI", "y22", $y22)
			IniWrite("save.ini", "PODATKI", "y23", $y23)
			IniWrite("save.ini", "PODATKI", "y24", $y24)
			IniWrite("save.ini", "PODATKI", "y25", $y25)
			IniWrite("save.ini", "PODATKI", "y26", $y26)
			IniWrite("save.ini", "PODATKI", "y27", $y27)
			IniWrite("save.ini", "PODATKI", "y28", $y28)
			IniWrite("save.ini", "PODATKI", "y29", $y29)
			IniWrite("save.ini", "PODATKI", "y30", $y30)
			IniWrite("save.ini", "PODATKI", "y31", $y31)
			IniWrite("save.ini", "PODATKI", "y32", $y32)
			IniWrite("save.ini", "PODATKI", "y33", $y33)
			IniWrite("save.ini", "PODATKI", "y34", $y34)
			IniWrite("save.ini", "PODATKI", "y35", $y35)
			IniWrite("save.ini", "PODATKI", "y36", $y36)
			IniWrite("save.ini", "PODATKI", "y37", $y37)
			IniWrite("save.ini", "PODATKI", "y38", $y38)
			IniWrite("save.ini", "PODATKI", "y39", $y39)
			IniWrite("save.ini", "PODATKI", "y40", $y40)
			;
			IniWrite("save.ini", "PODATKI", "x41", $x41)
			IniWrite("save.ini", "PODATKI", "x42", $x42)
			IniWrite("save.ini", "PODATKI", "x43", $x43)
			IniWrite("save.ini", "PODATKI", "x44", $x44)
			IniWrite("save.ini", "PODATKI", "x45", $x45)
			IniWrite("save.ini", "PODATKI", "x46", $x46)
			IniWrite("save.ini", "PODATKI", "x47", $x47)
			IniWrite("save.ini", "PODATKI", "x48", $x48)
			IniWrite("save.ini", "PODATKI", "x49", $x49)
			IniWrite("save.ini", "PODATKI", "x50", $x50)
			IniWrite("save.ini", "PODATKI", "x51", $x51)
			IniWrite("save.ini", "PODATKI", "x52", $x52)
			IniWrite("save.ini", "PODATKI", "x53", $x53)
			IniWrite("save.ini", "PODATKI", "x54", $x54)
			IniWrite("save.ini", "PODATKI", "x55", $x55)
			IniWrite("save.ini", "PODATKI", "x56", $x56)
			IniWrite("save.ini", "PODATKI", "x57", $x57)
			IniWrite("save.ini", "PODATKI", "x58", $x58)
			IniWrite("save.ini", "PODATKI", "x59", $x59)
			IniWrite("save.ini", "PODATKI", "x60", $x60)
			IniWrite("save.ini", "PODATKI", "y41", $y41)
			IniWrite("save.ini", "PODATKI", "y42", $y42)
			IniWrite("save.ini", "PODATKI", "y43", $y43)
			IniWrite("save.ini", "PODATKI", "y44", $y44)
			IniWrite("save.ini", "PODATKI", "y45", $y45)
			IniWrite("save.ini", "PODATKI", "y46", $y46)
			IniWrite("save.ini", "PODATKI", "y47", $y47)
			IniWrite("save.ini", "PODATKI", "y48", $y48)
			IniWrite("save.ini", "PODATKI", "y49", $y49)
			IniWrite("save.ini", "PODATKI", "y50", $y50)
			IniWrite("save.ini", "PODATKI", "y51", $y51)
			IniWrite("save.ini", "PODATKI", "y52", $y52)
			IniWrite("save.ini", "PODATKI", "y53", $y53)
			IniWrite("save.ini", "PODATKI", "y54", $y54)
			IniWrite("save.ini", "PODATKI", "y55", $y55)
			IniWrite("save.ini", "PODATKI", "y56", $y56)
			IniWrite("save.ini", "PODATKI", "y57", $y57)
			IniWrite("save.ini", "PODATKI", "y58", $y58)
			IniWrite("save.ini", "PODATKI", "y59", $y59)
			IniWrite("save.ini", "PODATKI", "y60", $y60)
			IniWrite("save.ini", "PODATKI", "x61", $x61)
			IniWrite("save.ini", "PODATKI", "x62", $x62)
			IniWrite("save.ini", "PODATKI", "x63", $x63)
			IniWrite("save.ini", "PODATKI", "x64", $x64)
			IniWrite("save.ini", "PODATKI", "x65", $x65)
			IniWrite("save.ini", "PODATKI", "x66", $x66)
			IniWrite("save.ini", "PODATKI", "x67", $x67)
			IniWrite("save.ini", "PODATKI", "x68", $x68)
			IniWrite("save.ini", "PODATKI", "x69", $x69)
			IniWrite("save.ini", "PODATKI", "x70", $x70)
			IniWrite("save.ini", "PODATKI", "x71", $x71)
			IniWrite("save.ini", "PODATKI", "x72", $x72)
			IniWrite("save.ini", "PODATKI", "x73", $x73)
			IniWrite("save.ini", "PODATKI", "x74", $x74)
			IniWrite("save.ini", "PODATKI", "x75", $x75)
			IniWrite("save.ini", "PODATKI", "x76", $x76)
			IniWrite("save.ini", "PODATKI", "x77", $x77)
			IniWrite("save.ini", "PODATKI", "x78", $x78)
			IniWrite("save.ini", "PODATKI", "x79", $x79)
			IniWrite("save.ini", "PODATKI", "x80", $x80)
			IniWrite("save.ini", "PODATKI", "y61", $y61)
			IniWrite("save.ini", "PODATKI", "y62", $y62)
			IniWrite("save.ini", "PODATKI", "y63", $y63)
			IniWrite("save.ini", "PODATKI", "y64", $y64)
			IniWrite("save.ini", "PODATKI", "y65", $y65)
			IniWrite("save.ini", "PODATKI", "y66", $y66)
			IniWrite("save.ini", "PODATKI", "y67", $y67)
			IniWrite("save.ini", "PODATKI", "y68", $y68)
			IniWrite("save.ini", "PODATKI", "y69", $y69)
			IniWrite("save.ini", "PODATKI", "y70", $y70)
			IniWrite("save.ini", "PODATKI", "y71", $y71)
			IniWrite("save.ini", "PODATKI", "y72", $y72)
			IniWrite("save.ini", "PODATKI", "y73", $y73)
			IniWrite("save.ini", "PODATKI", "y74", $y74)
			IniWrite("save.ini", "PODATKI", "y75", $y75)
			IniWrite("save.ini", "PODATKI", "y76", $y76)
			IniWrite("save.ini", "PODATKI", "y77", $y77)
			IniWrite("save.ini", "PODATKI", "y78", $y78)
			IniWrite("save.ini", "PODATKI", "y79", $y79)
			IniWrite("save.ini", "PODATKI", "y80", $y80)
			;
			IniWrite("save.ini", "PODATKI", "x81", $x81)
			IniWrite("save.ini", "PODATKI", "x82", $x82)
			IniWrite("save.ini", "PODATKI", "x83", $x83)
			IniWrite("save.ini", "PODATKI", "x84", $x84)
			IniWrite("save.ini", "PODATKI", "x85", $x85)
			IniWrite("save.ini", "PODATKI", "x86", $x86)
			IniWrite("save.ini", "PODATKI", "x87", $x87)
			IniWrite("save.ini", "PODATKI", "x88", $x88)
			IniWrite("save.ini", "PODATKI", "x89", $x89)
			IniWrite("save.ini", "PODATKI", "x90", $x90)
			IniWrite("save.ini", "PODATKI", "x91", $x91)
			IniWrite("save.ini", "PODATKI", "x92", $x92)
			IniWrite("save.ini", "PODATKI", "x93", $x93)
			IniWrite("save.ini", "PODATKI", "x94", $x94)
			IniWrite("save.ini", "PODATKI", "x95", $x95)
			IniWrite("save.ini", "PODATKI", "x96", $x96)
			IniWrite("save.ini", "PODATKI", "x97", $x97)
			IniWrite("save.ini", "PODATKI", "x98", $x98)
			IniWrite("save.ini", "PODATKI", "x99", $x99)
			IniWrite("save.ini", "PODATKI", "x100", $x100)
			IniWrite("save.ini", "PODATKI", "y81", $y81)
			IniWrite("save.ini", "PODATKI", "y82", $y82)
			IniWrite("save.ini", "PODATKI", "y83", $y83)
			IniWrite("save.ini", "PODATKI", "y84", $y84)
			IniWrite("save.ini", "PODATKI", "y85", $y85)
			IniWrite("save.ini", "PODATKI", "y86", $y86)
			IniWrite("save.ini", "PODATKI", "y87", $y87)
			IniWrite("save.ini", "PODATKI", "y88", $y88)
			IniWrite("save.ini", "PODATKI", "y89", $y89)
			IniWrite("save.ini", "PODATKI", "y90", $y90)
			IniWrite("save.ini", "PODATKI", "y91", $y91)
			IniWrite("save.ini", "PODATKI", "y92", $y92)
			IniWrite("save.ini", "PODATKI", "y93", $y93)
			IniWrite("save.ini", "PODATKI", "y94", $y94)
			IniWrite("save.ini", "PODATKI", "y95", $y95)
			IniWrite("save.ini", "PODATKI", "y96", $y96)
			IniWrite("save.ini", "PODATKI", "y97", $y97)
			IniWrite("save.ini", "PODATKI", "y98", $y98)
			IniWrite("save.ini", "PODATKI", "y99", $y99)
			IniWrite("save.ini", "PODATKI", "y100", $y100)
			IniWrite("save.ini", "PODATKI", "x101", $x101)
			IniWrite("save.ini", "PODATKI", "x102", $x102)
			IniWrite("save.ini", "PODATKI", "x103", $x103)
			IniWrite("save.ini", "PODATKI", "x104", $x104)
			IniWrite("save.ini", "PODATKI", "x105", $x105)
			IniWrite("save.ini", "PODATKI", "x106", $x106)
			IniWrite("save.ini", "PODATKI", "x107", $x107)
			IniWrite("save.ini", "PODATKI", "x108", $x108)
			IniWrite("save.ini", "PODATKI", "x109", $x109)
			IniWrite("save.ini", "PODATKI", "x110", $x110)
			IniWrite("save.ini", "PODATKI", "x111", $x111)
			IniWrite("save.ini", "PODATKI", "x112", $x112)
			IniWrite("save.ini", "PODATKI", "x113", $x113)
			IniWrite("save.ini", "PODATKI", "x114", $x114)
			IniWrite("save.ini", "PODATKI", "x115", $x115)
			IniWrite("save.ini", "PODATKI", "x116", $x116)
			IniWrite("save.ini", "PODATKI", "x117", $x117)
			IniWrite("save.ini", "PODATKI", "x118", $x118)
			IniWrite("save.ini", "PODATKI", "x119", $x119)
			IniWrite("save.ini", "PODATKI", "x120", $x120)
			IniWrite("save.ini", "PODATKI", "y101", $y101)
			IniWrite("save.ini", "PODATKI", "y102", $y102)
			IniWrite("save.ini", "PODATKI", "y103", $y103)
			IniWrite("save.ini", "PODATKI", "y104", $y104)
			IniWrite("save.ini", "PODATKI", "y105", $y105)
			IniWrite("save.ini", "PODATKI", "y106", $y106)
			IniWrite("save.ini", "PODATKI", "y107", $y107)
			IniWrite("save.ini", "PODATKI", "y108", $y108)
			IniWrite("save.ini", "PODATKI", "y109", $y109)
			IniWrite("save.ini", "PODATKI", "y110", $y110)
			IniWrite("save.ini", "PODATKI", "y111", $y111)
			IniWrite("save.ini", "PODATKI", "y112", $y112)
			IniWrite("save.ini", "PODATKI", "y113", $y113)
			IniWrite("save.ini", "PODATKI", "y114", $y114)
			IniWrite("save.ini", "PODATKI", "y115", $y115)
			IniWrite("save.ini", "PODATKI", "y116", $y116)
			IniWrite("save.ini", "PODATKI", "y117", $y117)
			IniWrite("save.ini", "PODATKI", "y118", $y118)
			IniWrite("save.ini", "PODATKI", "y119", $y119)
			IniWrite("save.ini", "PODATKI", "y120", $y120)
			
			IniWrite("save.ini", "PODATKI", "barakeid", $barakeid)
			GUIDelete($Form1)
			
			$ie = _IECreate("http://speed.travian.si", 0, 0)
			$html = _IEBodyReadHTML($ie)
			$muca = StringRegExp($html, 'class="fm fm110" maxLength=15 value=(\w+) name=(\w+)', 1)
			$offime = $muca[1]
			$pw = StringRegExp($html, 'class="fm fm110" type=password maxLength=20 value="" name=(\w+)', 1)
			$offgeslo = $pw[0]
			$ime = _IEGetObjByName($ie, $offime)
			$geslo = _IEGetObjByName($ie, $offgeslo)
			$prijava = _IEGetObjByName($ie, "s1")

			_IEFormElementSetValue($ime, $user)
			_IEFormElementSetValue($geslo, $password)
			_IEAction($prijava, "click")
			_IELoadWait($ie)
			$check = _IEBodyReadHTML($ie)
			If StringInStr($check, "Pregled naselbine") Then
				MsgBox(0, "Travian auto farm", "Login je bil uspešen, Auto farm se bo zdaj aktiviral")
				_IEQuit($ie)
			Else 
				MsgBox(0, "Travian auto farm", "Login ni bil uspešen, razlogov za to je lahko veè :). Prosim poskusi ponovno.")
				_IEQuit($ie)
				Exit
			EndIf
			ExitLoop
	EndSwitch
WEnd
$statuswin = GUICreate("Travian Farmer - Status", 500, 300)
GUICtrlCreateLabel("Zgodovina dogodkov", 10, 10)
GUICtrlCreateLabel("Za vklop oz. izklop tega okna .. desni klik na tray ikono.", 30, 50)
$lol22 = GUICtrlCreateEdit("Gattering log..."& @CRLF, 10, 100, 480, 200, $ES_READONLY + $ES_AUTOHSCROLL + $ES_AUTOVSCROLL)
GUISetState(@SW_SHOW)

login()
Do 
	$ata = 10
	loginchecker()
	$x = $x1
	$y = $y1
	check()
	If $x2 = "" Then
		;
	Else
		loginchecker()
		$x = $x2
		$y = $y2
		check()
	EndIf
	If $x3 = "" Then
		;
	Else
		loginchecker()
		$x = $x3
		$y = $y3
		check()
	EndIf
	If $x4 = "" Then
		;
	Else
		loginchecker()
		$x = $x4
		$y = $y4
		check()
	EndIf
	If $x5 = "" Then
		;
	Else
		loginchecker()
		$x = $x5
		$y = $y5
		check()
	EndIf
	If $x6 = "" Then
		;
	Else
		loginchecker()
		$x = $x6
		$y = $y6
		check()
	EndIf
	If $x7 = "" Then
		;
	Else
		loginchecker()
		$x = $x7
		$y = $y7
		check()
	EndIf
	If $x8 = "" Then
		;
	Else
		loginchecker()
		$x = $x8
		$y = $y8
		check()
	EndIf
	If $x9 = "" Then
		;
	Else
		loginchecker()
		$x = $x9
		$y = $y9
		check()
	EndIf
	If $x10 = "" Then
		;
	Else
		loginchecker()
		$x = $x10
		$y = $y10
		check()
	EndIf
	If $x11 = "" Then
		;
	Else
		loginchecker()
		$x = $x11
		$y = $y11
		check()
	EndIf
	If $x12 = "" Then
		;
	Else
		loginchecker()
		$x = $x12
		$y = $y12
		check()
	EndIf
	If $x13 = "" Then
		;
	Else
		loginchecker()
		$x = $x13
		$y = $y13
		check()
	EndIf
	If $x14 = "" Then
		;
	Else
		loginchecker()
		$x = $x14
		$y = $y14
		check()
	EndIf
	If $x15 = "" Then
		;
	Else
		loginchecker()
		$x = $x15
		$y = $y15
		check()
	EndIf
	If $x16 = "" Then
		;
	Else
		loginchecker()
		$x = $x16
		$y = $y16
		check()
	EndIf
	If $x17 = "" Then
		;
	Else
		loginchecker()
		$x = $x17
		$y = $y17
		check()
	EndIf
	If $x18 = "" Then
		;
	Else
		loginchecker()
		$x = $x18
		$y = $y18
		check()
	EndIf
	If $x19 = "" Then
		;
	Else
		loginchecker()
		$x = $x19
		$y = $y19
		check()
	EndIf
	If $x20 = "" Then
		;
	Else
		loginchecker()
		$x = $x20
		$y = $y20
		check()
	EndIf
	If $x21 = "" Then
		;
	Else
		loginchecker()
		$x = $x21
		$y = $y21
		check()
	EndIf
	If $x22 = "" Then
		;
	Else
		loginchecker()
		$x = $x22
		$y = $y22
		check()
	EndIf
	If $x23 = "" Then
		;
	Else
		loginchecker()
		$x = $x23
		$y = $y23
		check()
	EndIf
	If $x24 = "" Then
		;
	Else
		loginchecker()
		$x = $x24
		$y = $y24
		check()
	EndIf
	If $x25 = "" Then
		;
	Else
		loginchecker()
		$x = $x25
		$y = $y25
		check()
	EndIf
	If $x26 = "" Then
		;
	Else
		loginchecker()
		$x = $x26
		$y = $y26
		check()
	EndIf
	If $x27 = "" Then
		;
	Else
		loginchecker()
		$x = $x27
		$y = $y27
		check()
	EndIf
	If $x28 = "" Then
		;
	Else
		loginchecker()
		$x = $x28
		$y = $y28
		check()
	EndIf
	If $x29 = "" Then
		;
	Else
		loginchecker()
		$x = $x29
		$y = $y29
		check()
	EndIf
	If $x30 = "" Then
		;
	Else
		loginchecker()
		$x = $x30
		$y = $y30
		check()
	EndIf
	If $x31 = "" Then
		;
	Else
		loginchecker()
		$x = $x31
		$y = $y31
		check()
	EndIf
	If $x32 = "" Then
		;
	Else
		loginchecker()
		$x = $x32
		$y = $y32
		check()
	EndIf
	If $x33 = "" Then
		;
	Else
		loginchecker()
		$x = $x33
		$y = $y33
		check()
	EndIf
	If $x34 = "" Then
		;
	Else
		loginchecker()
		$x = $x34
		$y = $y34
		check()
	EndIf
	If $x35 = "" Then
		;
	Else
		loginchecker()
		$x = $x35
		$y = $y35
		check()
	EndIf
	If $x36 = "" Then
		;
	Else
		loginchecker()
		$x = $x36
		$y = $y36
		check()
	EndIf
	If $x37 = "" Then
		;
	Else
		loginchecker()
		$x = $x37
		$y = $y37
		check()
	EndIf
	If $x38 = "" Then
		;
	Else
		loginchecker()
		$x = $x38
		$y = $y38
		check()
	EndIf
	If $x39 = "" Then
		;
	Else
		loginchecker()
		$x = $x39
		$y = $y39
		check()
	EndIf
	If $x40 = "" Then
		;
	Else
		loginchecker()
		$x = $x40
		$y = $y40
		check()
	EndIf
	If $x41 = "" Then
		;
	Else
		loginchecker()
		$x = $x41
		$y = $y41
		check()
	EndIf
	If $x42 = "" Then
		;
	Else
		loginchecker()
		$x = $x42
		$y = $y42
		check()
	EndIf
	If $x43 = "" Then
		;
	Else
		loginchecker()
		$x = $x43
		$y = $y43
		check()
	EndIf
	If $x44 = "" Then
		;
	Else
		loginchecker()
		$x = $x44
		$y = $y44
		check()
	EndIf
	If $x45 = "" Then
		;
	Else
		loginchecker()
		$x = $x45
		$y = $y45
		check()
	EndIf
	If $x46 = "" Then
		;
	Else
		loginchecker()
		$x = $x46
		$y = $y46
		check()
	EndIf
	If $x47 = "" Then
		;
	Else
		loginchecker()
		$x = $x47
		$y = $y47
		check()
	EndIf
	If $x48 = "" Then
		;
	Else
		loginchecker()
		$x = $x48
		$y = $y48
		check()
	EndIf
	If $x49 = "" Then
		;
	Else
		loginchecker()
		$x = $x49
		$y = $y49
		check()
	EndIf
	If $x50 = "" Then
		;
	Else
		loginchecker()
		$x = $x50
		$y = $y50
		check()
	EndIf
	If $x51 = "" Then
		;
	Else
		loginchecker()
		$x = $x51
		$y = $y51
		check()
	EndIf
	If $x52 = "" Then
		;
	Else
		loginchecker()
		$x = $x52
		$y = $y52
		check()
	EndIf
	If $x53 = "" Then
		;
	Else
		loginchecker()
		$x = $x53
		$y = $y53
		check()
	EndIf
	If $x54 = "" Then
		;
	Else
		loginchecker()
		$x = $x54
		$y = $y54
		check()
	EndIf
	If $x55 = "" Then
		;
	Else
		loginchecker()
		$x = $x55
		$y = $y55
		check()
	EndIf
	If $x56 = "" Then
		;
	Else
		loginchecker()
		$x = $x56
		$y = $y56
		check()
	EndIf
	If $x57 = "" Then
		;
	Else
		loginchecker()
		$x = $x57
		$y = $y57
		check()
	EndIf
	If $x58 = "" Then
		;
	Else
		loginchecker()
		$x = $x58
		$y = $y58
		check()
	EndIf
	If $x59 = "" Then
		;
	Else
		loginchecker()
		$x = $x59
		$y = $y59
		check()
	EndIf
	If $x60 = "" Then
		;
	Else
		loginchecker()
		$x = $x60
		$y = $y60
		check()
	EndIf
	If $x61 = "" Then
		;
	Else
		loginchecker()
		$x = $x61
		$y = $y61
		check()
	EndIf
	If $x62 = "" Then
		;
	Else
		loginchecker()
		$x = $x62
		$y = $y62
		check()
	EndIf
	If $x63 = "" Then
		;
	Else
		loginchecker()
		$x = $x63
		$y = $y63
		check()
	EndIf
	If $x64 = "" Then
		;
	Else
		loginchecker()
		$x = $x64
		$y = $y64
		check()
	EndIf
	If $x65 = "" Then
		;
	Else
		loginchecker()
		$x = $x65
		$y = $y65
		check()
	EndIf
	If $x66 = "" Then
		;
	Else
		loginchecker()
		$x = $x66
		$y = $y66
		check()
	EndIf
	If $x67 = "" Then
		;
	Else
		loginchecker()
		$x = $x67
		$y = $y67
		check()
	EndIf
	If $x68 = "" Then
		;
	Else
		loginchecker()
		$x = $x68
		$y = $y68
		check()
	EndIf
	If $x69 = "" Then
		;
	Else
		loginchecker()
		$x = $x69
		$y = $y69
		check()
	EndIf
	If $x70 = "" Then
		;
	Else
		loginchecker()
		$x = $x70
		$y = $y70
		check()
	EndIf
	If $x71 = "" Then
		;
	Else
		loginchecker()
		$x = $x71
		$y = $y71
		check()
	EndIf
	If $x72 = "" Then
		;
	Else
		loginchecker()
		$x = $x72
		$y = $y72
		check()
	EndIf
	If $x73 = "" Then
		;
	Else
		loginchecker()
		$x = $x73
		$y = $y73
		check()
	EndIf
	If $x74 = "" Then
		;
	Else
		loginchecker()
		$x = $x74
		$y = $y74
		check()
	EndIf
	If $x75 = "" Then
		;
	Else
		loginchecker()
		$x = $x75
		$y = $y75
		check()
	EndIf
	If $x76 = "" Then
		;
	Else
		loginchecker()
		$x = $x76
		$y = $y76
		check()
	EndIf
	If $x77 = "" Then
		;
	Else
		loginchecker()
		$x = $x77
		$y = $y77
		check()
	EndIf
	If $x78 = "" Then
		;
	Else
		loginchecker()
		$x = $x78
		$y = $y78
		check()
	EndIf
	If $x79 = "" Then
		;
	Else
		loginchecker()
		$x = $x79
		$y = $y79
		check()
	EndIf
	If $x80 = "" Then
		;
	Else
		loginchecker()
		$x = $x80
		$y = $y80
		check()
	EndIf
	If $x81 = "" Then
		;
	Else
		loginchecker()
		$x = $x81
		$y = $y81
		check()
	EndIf
	If $x82 = "" Then
		;
	Else
		loginchecker()
		$x = $x82
		$y = $y82
		check()
	EndIf
	If $x83 = "" Then
		;
	Else
		loginchecker()
		$x = $x83
		$y = $y83
		check()
	EndIf
	If $x84 = "" Then
		;
	Else
		loginchecker()
		$x = $x84
		$y = $y84
		check()
	EndIf
	If $x85 = "" Then
		;
	Else
		loginchecker()
		$x = $x85
		$y = $y85
		check()
	EndIf
	If $x86 = "" Then
		;
	Else
		loginchecker()
		$x = $x86
		$y = $y86
		check()
	EndIf
	If $x87 = "" Then
		;
	Else
		loginchecker()
		$x = $x87
		$y = $y87
		check()
	EndIf
	If $x88 = "" Then
		;
	Else
		loginchecker()
		$x = $x88
		$y = $y88
		check()
	EndIf
	If $x89 = "" Then
		;
	Else
		loginchecker()
		$x = $x89
		$y = $y89
		check()
	EndIf
	If $x90 = "" Then
		;
	Else
		loginchecker()
		$x = $x90
		$y = $y90
		check()
	EndIf
	If $x91 = "" Then
		;
	Else
		loginchecker()
		$x = $x91
		$y = $y91
		check()
	EndIf
	If $x92 = "" Then
		;
	Else
		loginchecker()
		$x = $x92
		$y = $y92
		check()
	EndIf
	If $x93 = "" Then
		;
	Else
		loginchecker()
		$x = $x93
		$y = $y93
		check()
	EndIf
	If $x94 = "" Then
		;
	Else
		loginchecker()
		$x = $x94
		$y = $y94
		check()
	EndIf
	If $x95 = "" Then
		;
	Else
		loginchecker()
		$x = $x95
		$y = $y95
		check()
	EndIf
	If $x96 = "" Then
		;
	Else
		loginchecker()
		$x = $x96
		$y = $y96
		check()
	EndIf
	If $x97 = "" Then
		;
	Else
		loginchecker()
		$x = $x97
		$y = $y97
		check()
	EndIf
	If $x98 = "" Then
		;
	Else
		loginchecker()
		$x = $x98
		$y = $y98
		check()
	EndIf
	If $x99 = "" Then
		;
	Else
		loginchecker()
		$x = $x99
		$y = $y99
		check()
	EndIf
	If $x100 = "" Then
		;
	Else
		loginchecker()
		$x = $x100
		$y = $y100
		check()
	EndIf
	If $x101 = "" Then
		;
	Else
		loginchecker()
		$x = $x101
		$y = $y101
		check()
	EndIf
	If $x102 = "" Then
		;
	Else
		loginchecker()
		$x = $x102
		$y = $y102
		check()
	EndIf
	If $x103 = "" Then
		;
	Else
		loginchecker()
		$x = $x103
		$y = $y103
		check()
	EndIf
	If $x104 = "" Then
		;
	Else
		loginchecker()
		$x = $x104
		$y = $y104
		check()
	EndIf
	If $x105 = "" Then
		;
	Else
		loginchecker()
		$x = $x105
		$y = $y105
		check()
	EndIf
	If $x106 = "" Then
		;
	Else
		loginchecker()
		$x = $x106
		$y = $y106
		check()
	EndIf
	If $x107 = "" Then
		;
	Else
		loginchecker()
		$x = $x107
		$y = $y107
		check()
	EndIf
	If $x108 = "" Then
		;
	Else
		loginchecker()
		$x = $x108
		$y = $y108
		check()
	EndIf
	If $x109 = "" Then
		;
	Else
		loginchecker()
		$x = $x109
		$y = $y109
		check()
	EndIf
	If $x110 = "" Then
		;
	Else
		loginchecker()
		$x = $x110
		$y = $y110
		check()
	EndIf
	If $x111 = "" Then
		;
	Else
		loginchecker()
		$x = $x111
		$y = $y111
		check()
	EndIf
	If $x112 = "" Then
		;
	Else
		loginchecker()
		$x = $x112
		$y = $y112
		check()
	EndIf
	If $x113 = "" Then
		;
	Else
		loginchecker()
		$x = $x113
		$y = $y113
		check()
	EndIf
	If $x114 = "" Then
		;
	Else
		loginchecker()
		$x = $x114
		$y = $y114
		check()
	EndIf
	If $x115 = "" Then
		;
	Else
		loginchecker()
		$x = $x115
		$y = $y115
		check()
	EndIf
	If $x116 = "" Then
		;
	Else
		loginchecker()
		$x = $x116
		$y = $y116
		check()
	EndIf
	If $x117 = "" Then
		;
	Else
		loginchecker()
		$x = $x117
		$y = $y117
		check()
	EndIf
	If $x118 = "" Then
		;
	Else
		loginchecker()
		$x = $x118
		$y = $y118
		check()
	EndIf
	If $x119 = "" Then
		;
	Else
		loginchecker()
		$x = $x119
		$y = $y119
		check()
	EndIf
	If $x120 = "" Then
		;
	Else
		loginchecker()
		$x = $x120
		$y = $y120
		check()
	EndIf
	If $surovine2 = "Po enem napadu na vse farme" Then
		If $barakeid = "" Then
			;
		Else
			_IENavigate($ie, "http://speed.travian.si/build.php?id="&$barakeid)
			$gorjacarbarake = _IEGetObjByName($ie, "t1")
			$sulicarbarake = _IEGetObjByName($ie, "t2")
			$metalecbarake = _IEGetObjByName($ie, "t3")
			_IEFormElementSetValue($gorjacarbarake, $izurigorjacarje)
			_IEFormElementSetValue($sulicarbarake, $izurisulicarje)
			_IEFormElementSetValue($metalecbarake, $izurimetalce)
			$izuri = _IEGetObjByName($ie, "s1")
			_IEAction($izuri, "click")
			_IELoadWait($ie)
			GUICtrlSetData($lol22, "["&_Now()&"]"&" Treniranje novih enot konèano."& @CRLF, 3)
		EndIf
	EndIf
	GUICtrlSetData($lol22, "["&_Now()&"]"&" Farmer STOPED for "&$pavza2/60/1000&" minutes"& @CRLF, 3)
	Sleep($pavza2)
Until $ata = 0
_IEQuit($ie)
Exit





Func login()
	GUICtrlSetData($lol22, "["&_Now()&"]"&" Loging in ..."& @CRLF, 3)
	$ie = _IECreate("http://speed.travian.si", 0, 0)
	$muca = StringRegExp($html, 'class="fm fm110" maxLength=15 value=(\w+) name=(\w+)', 1)
	$offime = $muca[1]
	$pw = StringRegExp($html, 'class="fm fm110" type=password maxLength=20 value="" name=(\w+)', 1)
	$offgeslo = $pw[0]
	$ime = _IEGetObjByName($ie, $offime)
	$geslo = _IEGetObjByName($ie, $offgeslo)
	$prijava = _IEGetObjByName($ie, "s1")
	_IEFormElementSetValue($ime, $user)
	_IEFormElementSetValue($geslo, $password)
	_IEAction($prijava, "click")
	_IELoadWait($ie)
EndFunc

Func loginchecker()
	_IENavigate($ie, "http://speed.travian.si/dorf1.php")
	$blah = _IEBodyReadText($ie)
	If StringInStr($blah, "Èe se hoèeš prijaviti moraš imeti omogoèene piškotke") Then
		GUICtrlSetData($lol22, "["&_Now()&"]"&" Nisi logiran v igro."& @CRLF, 3)
		_IEQuit($ie)
		Sleep(5000)
		login()
	EndIf
EndFunc	
	
Func check()
	GUICtrlSetData($lol22, "["&_Now()&"]"&" Preverjam naselje ..."& @CRLF, 3)
	$umik = 0
	$donapadase = 999999
	_IENavigate($ie, "http://speed.travian.si/dorf1.php")
	$text = _IEBodyReadText($ie)
	$ennapad = StringRegExp($text, "» \d+Napadv")
	$vecnapadov = StringRegExp($text, "» \d+Napadiob")
	If $ennapad = 1 Then
		$ntime = StringRegExp($text, "» \d+Napadv(\d+):(\d+):(\d+) h", 3)
		$nure = Number($ntime[0])
		$nminute = Number($ntime[1])
		$nsekunde = Number($ntime[2])
		$donapadase = $nure*60*60*1000 + $nminute*60*1000 + $nsekunde*1000
	EndIf
	If $vecnapadov = 1 Then
		$ntime = StringRegExp($text, "» \d+Napadiob(\d+):(\d+):(\d+) h", 3)
		$nure = Number($ntime[0])
		$nminute = Number($ntime[1])
		$nsekunde = Number($ntime[2])
		$donapadase = $nure*60*60*1000 + $nminute*60*1000 + $nsekunde*1000
	EndIf
	If 300000 >= $donapadase Then
		If $izbiraumika = "Odmakni samo napadalne enote" Then
			If StringInStr($text, "Enote:"&@CRLF&"brez") Then
				$umik = 0
			Else 
				$umik = 2
			EndIf
		ElseIf $izbiraumika = "Odmakni vse enote" Then
			If StringInStr($text, "Enote:"&@CRLF&"brez") Then
				$umik = 0
			Else
				$umik = 1
			EndIf
		ElseIf $izbiraumika = "Ne naredi nicesar" Then
			$umik = 0
		EndIf
	EndIf
	If $gorjacar = -1 Then
		$gorjacarjev = Number(-1)
	ElseIf StringInStr($text, "Gorjaèarjev") Then
		$gorjacarjev2 = StringRegExp($text, "(\d+)Gorjaèarjev", 3)
		$gorjacarjev = Number($gorjacarjev2[0])
	Else 
		$gorjacarjev = 0
	EndIf
	If $paladin = -1 Then
		$paladinov = Number(-1)
	ElseIf StringInStr($text, "Paladinov") Then
		$paladinov2 = StringRegExp($text, "(\d+)Paladinov", 3)
		$paladinov = Number($paladinov2[0])
	Else 
		$paladinov = 0
	EndIf
	If $metalec = -1 Then
		$metalcev = Number(-1)
	ElseIf StringInStr($text, "Metalcev sekir") Then
		$metalcev2 = StringRegExp($text, "(\d+)Metalcev sekir", 3)
		$metalcev = Number($metalcev2[0])
	Else 
		$metalcev = 0
	EndIf
	If $tevtonskivitez = -1 Then
		$tevtonskihvitezov = Number(-1)
	ElseIf StringInStr($text, "Tevtonskih vitezov") Then
		$tevtonskihvitezov2 = StringRegExp($text, "(\d+)Tevtonskih vitezov", 3)
		$tevtonskihvitezov = Number($tevtonskihvitezov2[0])
	Else
		$tevtonskihvitezov = 0
	EndIf
	
	If $gorjacar2 = 0 Then
		$gorjacarjev2 = Number(-1)
	ElseIf StringInStr($text, "Gorjaèarjev") Then
		$gorjacarjev10 = StringRegExp($text, "(\d+)Gorjaèarjev", 3)
		$gorjacarjev2 = Number($gorjacarjev10[0])
	Else 
		$gorjacarjev2 = 0
	EndIf
	If $paladin2 = 0 Then
		$paladinov2 = Number(-1)
	ElseIf StringInStr($text, "Paladinov") Then
		$paladinov10 = StringRegExp($text, "(\d+)Paladinov", 3)
		$paladinov2 = Number($paladinov10[0])
	Else 
		$paladinov2 = Number(0)
	EndIf
	If $metalec2 = 0 Then
		$metalcev2 = Number(-1)
	ElseIf StringInStr($text, "Metalcev sekir") Then
		$metalcev10 = StringRegExp($text, "(\d+)Metalcev sekir", 3)
		$metalcev2 = Number($metalcev10[0])
	Else 
		$metalcev2 = 0
	EndIf
	If $tevtonskivitez2 = 0 Then
		$tevtonskihvitezov2 = Number(-1)
	ElseIf StringInStr($text, "Tevtonskih vitezov") Then
		$tevtonskihvitezov10 = StringRegExp($text, "(\d+)Tevtonskih vitezov", 3)
		$tevtonskihvitezov2 = Number($metalcev10[0])
	Else 
		$tevtonskihvitezov2 = 0
	EndIf
	If $umik = 1 Then
		GUICtrlSetData($lol22, "["&_Now()&"]"&" Napad v tvoje naselje v manj kot 5 min"& @CRLF, 3)
		GUICtrlSetData($lol22, "["&_Now()&"]"&" Odmikam vso vojsko ..."& @CRLF, 3)
		_IENavigate($ie, "http://speed.travian.si/a2b.php")
		$1 = _IEGetObjByName($ie, "t1")
		$2 = _IEGetObjByName($ie, "t2")
		$3 = _IEGetObjByName($ie, "t3")
		$4 = _IEGetObjByName($ie, "t4")
		$5 = _IEGetObjByName($ie, "t5")
		$6 = _IEGetObjByName($ie, "t6")
		$7 = _IEGetObjByName($ie, "t7")
		$8 = _IEGetObjByName($ie, "t8")
		$9 = _IEGetObjByName($ie, "t9")
		$10 = _IEGetObjByName($ie, "t10")
		$11 = _IEGetObjByName($ie, "t11")
		$nx = _IEGetObjByName($ie, "x")
		$ny = _IEGetObjByName($ie, "y")
		_IEFormElementSetValue($1, "999999")
		_IEFormElementSetValue($2, "999999")
		_IEFormElementSetValue($3, "999999")
		_IEFormElementSetValue($4, "999999")
		_IEFormElementSetValue($5, "999999")
		_IEFormElementSetValue($6, "999999")
		_IEFormElementSetValue($7, "999999")
		_IEFormElementSetValue($8, "999999")
		_IEFormElementSetValue($9, "999999")
		_IEFormElementSetValue($10, "999999")
		_IEFormElementSetValue($11, "9999")
		_IEFormElementSetValue($nx, $x1)
		_IEFormElementSetValue($ny, $y1)
		$form = _IEFormGetObjByName($ie, "snd")
		_IEFormElementRadioSelect($form, 4, "c")
		$ok = _IEGetObjByName($ie, "s1")
		_IEAction($ok, "click")
		_IELoadWait($ie)
		$send = _IEGetObjByName($ie, "s1")
		_IEAction($send, "click")
		_IELoadWait($ie)
		GUICtrlSetData($lol22, "["&_Now()&"]"&" Vojska je bila odmaknjena na prvo farmo."& @CRLF, 3)
		If $barakeid = "" Then
			;
		Else
			GUICtrlSetData($lol22, "["&_Now()&"]"&" Zasilno porabljanje surovin ..."& @CRLF, 3)
			_IENavigate($ie, "http://speed.travian.si/build.php?id="&$barakeid)
			$html = _IEBodyReadHTML($ie)
			$gorjacarbarake = _IEGetObjByName($ie, "t1")
			$kolikogorjacarjev = StringRegExp($html, "document.snd.t1.value=(\d+)", 1)
			$kolikogorjacarjev2 = $kolikogorjacarjev[0]
			_IEFormElementSetValue($gorjacarbarake, $kolikogorjacarjev2)
			$izuri = _IEGetObjByName($ie, "s1")
			_IEAction($izuri, "click")
			_IELoadWait($ie)
			GUICtrlSetData($lol22, "["&_Now()&"]"&" Zasilno porabljanje surovin konèano."& @CRLF, 3)
		EndIf
	ElseIf $umik = 2 Then
		GUICtrlSetData($lol22, "["&_Now()&"]"&" Napad v tvoje naselje v manj kot 5 min"& @CRLF, 3)
		GUICtrlSetData($lol22, "["&_Now()&"]"&" Odmikam napadalno vojsko ..."& @CRLF, 3)
		_IENavigate($ie, "http://speed.travian.si/a2b.php")
		$1 = _IEGetObjByName($ie, "t1")
		$3 = _IEGetObjByName($ie, "t3")
		$4 = _IEGetObjByName($ie, "t4")
		$6 = _IEGetObjByName($ie, "t6")
		$7 = _IEGetObjByName($ie, "t7")
		$8 = _IEGetObjByName($ie, "t8")
		$9 = _IEGetObjByName($ie, "t9")
		$10 = _IEGetObjByName($ie, "t10")
		$11 = _IEGetObjByName($ie, "t11")
		$nx = _IEGetObjByName($ie, "x")
		$ny = _IEGetObjByName($ie, "y")
		_IEFormElementSetValue($1, "999999")
		_IEFormElementSetValue($3, "999999")
		_IEFormElementSetValue($4, "999999")
		_IEFormElementSetValue($6, "999999")
		_IEFormElementSetValue($7, "999999")
		_IEFormElementSetValue($8, "999999")
		_IEFormElementSetValue($9, "999999")
		_IEFormElementSetValue($10, "999999")
		_IEFormElementSetValue($11, "9999")
		_IEFormElementSetValue($nx, $x1)
		_IEFormElementSetValue($ny, $y1)
		$form = _IEFormGetObjByName($ie, "snd")
		_IEFormElementRadioSelect($form, 4, "c")
		$ok = _IEGetObjByName($ie, "s1")
		_IEAction($ok, "click")
		_IELoadWait($ie)
		$send = _IEGetObjByName($ie, "s1")
		_IEAction($send, "click")
		_IELoadWait($ie)
		GUICtrlSetData($lol22, "["&_Now()&"]"&" Vojska je bila odmaknjena na prvo farmo."& @CRLF, 3)
		If $barakeid = "" Then
			;
		Else
			GUICtrlSetData($lol22, "["&_Now()&"]"&" Zasilno porabljanje surovin ..."& @CRLF, 3)
			_IENavigate($ie, "http://speed.travian.si/build.php?id="&$barakeid)
			$html = _IEBodyReadHTML($ie)
			$gorjacarbarake = _IEGetObjByName($ie, "t1")
			$kolikogorjacarjev = StringRegExp($html, "document.snd.t1.value=(\d+)", 1)
			$kolikogorjacarjev2 = $kolikogorjacarjev[0]
			_IEFormElementSetValue($gorjacarbarake, $kolikogorjacarjev2)
			$izuri = _IEGetObjByName($ie, "s1")
			_IEAction($izuri, "click")
			_IELoadWait($ie)
			GUICtrlSetData($lol22, "["&_Now()&"]"&" Zasilno porabljanje surovin konèano."& @CRLF, 3)
		EndIf
	ElseIf $gorjacarjev >= $gorjacar And $paladinov >= $paladin And $metalcev >= $metalec And $tevtonskihvitezov >= $tevtonskivitez  Then
		GUICtrlSetData($lol22, "["&_Now()&"]"&" Pošiljam enote na farmo: "&$x&" "&$y&" ..."& @CRLF, 3)
		_IENavigate($ie, "http://speed.travian.si/a2b.php")
		$ngorjacar = _IEGetObjByName($ie, "t1")
		$npaladin = _IEGetObjByName($ie, "t5")
		$nmetalec = _IEGetObjByName($ie, "t3")
		$nx = _IEGetObjByName($ie, "x")
		$ny = _IEGetObjByName($ie, "y")
		_IEFormElementSetValue($ngorjacar, $gorjacar)
		_IEFormElementSetValue($npaladin, $paladin)
		_IEFormElementSetValue($nmetalec, $metalec)
		_IEFormElementSetValue($nx, $x)
		_IEFormElementSetValue($ny, $y)
		$form = _IEFormGetObjByName($ie, "snd")
		_IEFormElementRadioSelect($form, 4, "c")
		$ok = _IEGetObjByName($ie, "s1")
		_IEAction($ok, "click")
		_IELoadWait($ie)
		$send = _IEGetObjByName($ie, "s1")
		_IEAction($send, "click")
		_IELoadWait($ie)
	ElseIf $gorjacarjev2 >= $gorjacar2 Then
		GUICtrlSetData($lol22, "["&_Now()&"]"&" Posiljam gorjacarje na farmo: "&$x&" "&$y&" ..."& @CRLF, 3)
		_IENavigate($ie, "http://speed.travian.si/a2b.php")
		$ngorjacar = _IEGetObjByName($ie, "t1")
		$nx = _IEGetObjByName($ie, "x")
		$ny = _IEGetObjByName($ie, "y")
		_IEFormElementSetValue($ngorjacar, $gorjacar2)
		_IEFormElementSetValue($nx, $x)
		_IEFormElementSetValue($ny, $y)
		$form = _IEFormGetObjByName($ie, "snd")
		_IEFormElementRadioSelect($form, 4, "c")
		$ok = _IEGetObjByName($ie, "s1")
		_IEAction($ok, "click")
		_IELoadWait($ie)
		$send = _IEGetObjByName($ie, "s1")
		_IEAction($send, "click")
		_IELoadWait($ie)
	ElseIf $paladinov2 >= $paladin2 Then
		GUICtrlSetData($lol22, "["&_Now()&"]"&" Posiljam paladine na farmo: "&$x&" "&$y&" ..."& @CRLF, 3)
		_IENavigate($ie, "http://speed.travian.si/a2b.php")
		$npaladin = _IEGetObjByName($ie, "t5")
		$nx = _IEGetObjByName($ie, "x")
		$ny = _IEGetObjByName($ie, "y")
		_IEFormElementSetValue($npaladin, $paladin2)
		_IEFormElementSetValue($nx, $x)
		_IEFormElementSetValue($ny, $y)
		$form = _IEFormGetObjByName($ie, "snd")
		_IEFormElementRadioSelect($form, 4, "c")
		$ok = _IEGetObjByName($ie, "s1")
		_IEAction($ok, "click")
		_IELoadWait($ie)
		$send = _IEGetObjByName($ie, "s1")
		_IEAction($send, "click")
		_IELoadWait($ie)
	ElseIf $metalcev2 >= $metalec2 Then
		GUICtrlSetData($lol22, "["&_Now()&"]"&" Posiljam metalce sekir na farmo: "&$x&" "&$y&" ..."& @CRLF, 3)
		_IENavigate($ie, "http://speed.travian.si/a2b.php")
		$nmetalec = _IEGetObjByName($ie, "t3")
		$nx = _IEGetObjByName($ie, "x")
		$ny = _IEGetObjByName($ie, "y")
		_IEFormElementSetValue($nmetalec, $metalec2)
		_IEFormElementSetValue($nx, $x)
		_IEFormElementSetValue($ny, $y)
		$form = _IEFormGetObjByName($ie, "snd")
		_IEFormElementRadioSelect($form, 4, "c")
		$ok = _IEGetObjByName($ie, "s1")
		_IEAction($ok, "click")
		_IELoadWait($ie)
		$send = _IEGetObjByName($ie, "s1")
		_IEAction($send, "click")
		_IELoadWait($ie)
	ElseIf $tevtonskihvitezov2 >= $tevtonskivitez2 Then
		GUICtrlSetData($lol22, "["&_Now()&"]"&" Posiljam tevtonske viteze na farmo: "&$x&" "&$y&" ..."& @CRLF, 3)
		_IENavigate($ie, "http://speed.travian.si/a2b.php")
		$ntevtonskivitez = _IEGetObjByName($ie, "t6")
		$nx = _IEGetObjByName($ie, "x")
		$ny = _IEGetObjByName($ie, "y")
		_IEFormElementSetValue($ntevtonskivitez, $tevtonskivitez2)
		_IEFormElementSetValue($nx, $x)
		_IEFormElementSetValue($ny, $y)
		$form = _IEFormGetObjByName($ie, "snd")
		_IEFormElementRadioSelect($form, 4, "c")
		$ok = _IEGetObjByName($ie, "s1")
		_IEAction($ok, "click")
		_IELoadWait($ie)
		$send = _IEGetObjByName($ie, "s1")
		_IEAction($send, "click")
		_IELoadWait($ie)
	Else 
		GUICtrlSetData($lol22, "["&_Now()&"]"&" V naselju trenutno ni panike, in vsa vojska je v akciji =)"& @CRLF, 3)
		Sleep(60000)
		loginchecker()
		check()
	EndIf
	If $surovine2 = "Sproti" Then
		If $barakeid = "" Then
			;
		Else
			_IENavigate($ie, "http://speed.travian.si/build.php?id="&$barakeid)
			$gorjacarbarake = _IEGetObjByName($ie, "t1")
			$sulicarbarake = _IEGetObjByName($ie, "t2")
			$metalecbarake = _IEGetObjByName($ie, "t3")
			_IEFormElementSetValue($gorjacarbarake, $izurigorjacarje)
			_IEFormElementSetValue($sulicarbarake, $izurisulicarje)
			_IEFormElementSetValue($metalecbarake, $izurimetalce)
			$izuri = _IEGetObjByName($ie, "s1")
			_IEAction($izuri, "click")
			_IELoadWait($ie)
			GUICtrlSetData($lol22, "["&_Now()&"]"&" Treniranje novih enot konèano."& @CRLF, 3)
		EndIf
	EndIf
EndFunc
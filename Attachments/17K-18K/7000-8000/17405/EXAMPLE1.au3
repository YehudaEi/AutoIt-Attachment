#include<embedswfxmlchart.au3>
#include <guiconstants.au3>
#include <array.au3>

$GUI = GUICreate("SWF Chart Example 1 - Same graphs, different methods", 600, 600, -1, -1)
GUISetBkColor (0x000000)
GUISetState(@SW_SHOW)

Dim $chart[25][2]

;---------------------------------------------------
;Prepare chart data
;---------------------------------------------------

;axis_category
$chart[0][0] = "axis_category"
$chart[0][1] = ObjCreate("Scripting.Dictionary")
With $chart[0][1]
	.Add( "skip", "0")
	.Add( "font", "Arial")
	.Add( "bold", "true")
	.Add( "size", "14")
	.Add( "color", "000000")
	.Add( "alpha", "0")
	.Add( "orientation", "horizontal")
	.Add( "margin", "")
	.Add( "min", "")
	.Add( "max", "")
	.Add( "prefix", "")
	.Add( "suffix", "")
	.Add( "decimals", "")
	.Add( "decimal_char", "")
	.Add( "seperator", "")
	;MsgBox(0,"",$assocObj.Item( "Age"))
EndWith

;axis_ticks
$chart[1][0] = "axis_ticks"
$chart[1][1] = ObjCreate("Scripting.Dictionary")
With $chart[1][1]
	.Add( "value_ticks", "true")
	.Add( "category_ticks", "true")
	.Add( "position", "outside")
	.Add( "major_thickness", "2")
	.Add( "major_color", "000000")
	.Add( "minor_thickness", "1")
	.Add( "minor_color", "222222")
	.Add( "minor_count", "1")
EndWith

;axis_value
$chart[2][0] = "axis_value"
$chart[2][1] = ObjCreate("Scripting.Dictionary")
With $chart[2][1]
	.Add("min", "0")
	.Add("max", "120")
	.Add("steps", "6")
	.Add("prefix", "")
	.Add("suffix", "")
	.Add("decimals", "0")
	.Add("decimal_char", "")
	.Add("separator", "")
	.Add("show_min", "true")
	.Add("font", "arial")
	.Add("bold", "true")
	.Add("size", "10")
	.Add("color", "ffffff")
	.Add("background_color", "") 
	.Add("alpha", "50")
	.Add("orientation", "") 
EndWith

;axis_value_text
$chart[3][0] = "axis_value_text"
$chart[3][1] = "" ;ARRAY
;---------------------------------------------------


;---------------------------------------------------
;chart_border
$chart[4][0] = "chart_border"
$chart[4][1] = ObjCreate("Scripting.Dictionary")
With $chart[4][1]
	.Add("top_thickness", "2")
	.Add("bottom_thickness", "2")
	.Add("left_thickness", "2")
	.Add("right_thickness", "2")
	.Add("color", "000000") 
EndWith

;chart_data						 
Dim $chart_data[3][32] = [[ "","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31" ], _
						[ "Region A",10,12,11,15,20,22,21,25,31,32,28,29,40,41,45,50,65,45,50,51,65,60,62,65,45,55,59,52,53,40,45 ], _
						[ "Region B",30,32,35,40,42,35,36,31,35,36,40,42,40,38,40,40,38,36,30,29,28,25,28,29,30,40,32,33,34,30,35 ]]

$chart[5][0] = "chart_data"
$chart[5][1] = $chart_data ;2D ARRAY

;chart_grid_h
$chart[6][0] = "chart_grid_h"
$chart[6][1] = ObjCreate("Scripting.Dictionary")
With $chart[6][1]
	.Add("thickness", "1")
	.Add("color", "000000")
	.Add("alpha", "10")
	.Add("type", "solid")
EndWith

;chart_grid_v
$chart[7][0] = "chart_grid_v"
$chart[7][1] = ObjCreate("Scripting.Dictionary")
With $chart[7][1]
	.Add("thickness", "1")
	.Add("color", "000000")
	.Add("alpha", "10")
	.Add("type", "solid")
EndWith

;chart_pref
$chart[8][0] = "chart_pref"
$chart[8][1] = ObjCreate("Scripting.Dictionary")
With $chart[8][1]
	.Add("line_thickness", "2")
	.Add("point_shape", "none")
	.Add("fill_shape", "false")
EndWith

;chart_rect
$chart[9][0] = "chart_rect"
$chart[9][1] = ObjCreate("Scripting.Dictionary")
With $chart[9][1]
	.Add("x", "40")
	.Add("y", "25")
	.Add("width", "335")
	.Add("height", "200")
	.Add("positive_color", "000000")
	.Add("negative_color", "ff0000")
	.Add("positive_alpha", "30")
	.Add("negative_alpha", "10")
EndWith

;chart_transition
$chart[10][0] = "chart_transition"
$chart[10][1] = ObjCreate("Scripting.Dictionary")

;chart_type
$chart[11][0] = "chart_type"
$chart[11][1] = "line" ;STRING OR ARRAY (for mixed chart)

;chart_value
$chart[12][0] = "chart_value"
$chart[12][1] = ObjCreate("Scripting.Dictionary")
With $chart[12][1]
	.Add("prefix", "")
	.Add("suffix", "")
	.Add("deciamals", "")
	.Add("decimal_char", "")
	.Add("seperator", "")
	.Add("position", "cursor")
	.Add("hide_zero", "")
	.Add("as_percentage", "")
	.Add("font", "")
	.Add("bold", "")
	.Add("size", "12")
	.Add("color", "ffffff")
	.Add("background_color", "")
	.Add("alpha", "75")
EndWith

;chart_value_text
$chart[13][0] = "chart_value_text"
$chart[13][1] = "" ;ARRAY
;---------------------------------------------------


;---------------------------------------------------
;draw
Dim $draw[2] = [ObjCreate("Scripting.Dictionary"), ObjCreate("Scripting.Dictionary")]
With $draw[1]
	.Add("type", "text")
	.Add("text", "hertz")
	.Add("color", "ffffff")
	.Add("alpha", "15")
	.Add("font", "arial")
	.Add("rotation", "-90")
	.Add("bold", "true")
	.Add("size", "50")
	.Add("x", "-10")
	.Add("y", "348")
	.Add("width", "300")
	.Add("height", "150")
	.Add("h_align", "center")
	.Add("v_align", "top")
EndWith
With $draw[0]
	.Add("type", "text")
	.Add("text", "output")
	.Add("color", "000000")
	.Add("alpha", "15")
	.Add("font", "arial")
	.Add("rotation", "0")
	.Add("bold", "true")
	.Add("size", "60")
	.Add("x", "0")
	.Add("y", "0")
	.Add("width", "320")
	.Add("height", "300")
	.Add("h_align", "left")
	.Add("v_align", "bottom")
EndWith

$chart[14][0] = "draw"
$chart[14][1] = $draw ;ARRAY of OBJECTS
;---------------------------------------------------


;---------------------------------------------------
;legend_label
$chart[15][0] = "legend_label"
$chart[15][1] = ObjCreate("Scripting.Dictionary")

;legend_rect
$chart[16][0] = "legend_rect"
$chart[16][1] = ObjCreate("Scripting.Dictionary")
With $chart[16][1]
	.Add("x", "-100")
	.Add("y", "-100")
	.Add("width", "10")
	.Add("height", "10")
	.Add("margin", "10")
	.Add("fill_color", "")
	.Add("fill_alpha", "")
	.Add("line_color", "")
	.Add("line_alpha", "")
	.Add("line_thickness", "")
EndWith

;legend_transition
$chart[17][0] = "legend_transition"
$chart[17][1] = ObjCreate("Scripting.Dictionary")
;---------------------------------------------------


;---------------------------------------------------
;link
$chart[18][0] = "link"
$chart[18][1] = "" ;ARRAY of OBJECTS

;link_data
$chart[19][0] = "link_data"
$chart[19][1] = ObjCreate("Scripting.Dictionary")

;live_data
$chart[20][0] = "live_data"
$chart[20][1] = ObjCreate("Scripting.Dictionary")
;---------------------------------------------------


;---------------------------------------------------
;series_color
$chart[21][0] = "series_color"
$chart[21][1] =  _ArrayCreate("77bb11","cc5511")

;series_explode
$chart[22][0] = "series_explode"
$chart[22][1] = "" ;ARRAY

;series_gap
$chart[23][0] = "series_gap"
$chart[23][1] = ObjCreate("Scripting.Dictionary")

;series_switch
$chart[24][0] = "series_switch"
$chart[24][1] = "" ;BOOLEAN
;---------------------------------------------------

;EXAMPLE 1: Generate from file
$chart1 = _CreateSWFChart(@ScriptDir &'\Gallery_Line_2.xml', 0,0,600,300)

;EXAMPLE 2: Generate from raw XML
$chartXml = _array2xml($chart)
$chart2 = _CreateSWFChart($chartXml, 0,300,600,300, 1)

;EXAMPLE 3: Update existing chart with raw XML
;_UpdateSWFChart($chart2, $chartXml, 1)

;EXAMPLE 4: Update existing chart from file
;FileDelete("swfxmlchart.xml")
;FileWrite("swfxmlchart.xml", $chartXml)
;_UpdateSWFChart($chart2, @ScriptDir &'\swfxmlchart.xml', 0)

; MAIN LOOP
While 1
    Switch GUIGetMsg()
        Case $GUI_EVENT_CLOSE
            ExitLoop
    EndSwitch
    Sleep(10)
WEnd
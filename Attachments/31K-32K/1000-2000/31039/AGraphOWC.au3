;=====================================================
; AGraphOWC - sample of OWC Chart used by AutoIt
; It allows to create and show the image obtained by MS OWC
; Requirement:
; - MS OWC installed
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiComboBoxEx.au3>
#include <WinAPI.au3>
#include "AGraph_Constants.au3"

;===============================================================
Global $Caption = "AGraphOWC © Valery Ivanov, 21 June 2010"
Global $ChartCaption = "Example of AutoOWC Chart"
Global $oGraph, $GUIActiveX
Global $CaptureButton, $msg
Global $oChartSpace, $oChart, $oSeries

Global $GUI_Chart, $hGUI_Chart
Global $FileSaved = @ScriptDir & "\Graph.gif"
Global $ViewW = 512, $ViewH = 480

Global $Graph_ChartType, $GraphChartTypesLine = "ColumnClustered|ColumnStacked|ColumnStacked100|BarClustered|BarStacked|BarStacked100|Line|LineStacked|LineStacked100|LineMarkers|LineStackedMarkers|LineStacked100Markers|SmoothLine|SmoothLineStacked|SmoothLineStacked100|SmoothLineMarkers|SmoothLineStackedMarkers|SmoothLineStacked100Markers|ScatterMarkers|ScatterLine|ScatterLineMarkers|ScatterLineFilled|ScatterSmoothLine|ScatterSmoothLineMarkers|Area|AreaStacked|AreaStacked100|RadarLine|RadarLineMarkers|RadarLineFilled|RadarSmoothLine|RadarSmoothLineMarkers|PolarMarkers|PolarLine|PolarLineMarkers|PolarSmoothLine|PolarSmoothLineMarkers|Column3D|ColumnClustered3D|ColumnStacked3D|ColumnStacked1003D|Bar3D|BarClustered3D|BarStacked3D|BarStacked1003D|Line3D|LineOverlapped3D|LineStacked3D|LineStacked1003D|Area3D|AreaOverlapped3D|AreaStacked3D|AreaStacked1003D|Pie|PieExploded|PieStacked|Pie3D|PieExploded3D"
Global $InvalidCharts = "Combo3D|Combo|Bubble|BubbleLine|Doughnut|DoughnutExploded|StockHLC|StockOHLC"

Global $GraphChartTypes = StringSplit($GraphChartTypesLine,"|")
Global $GraphTypeName = "ColumnClustered"

Global $Line_Color, $Interior_Color, $Border_Color

$oChartSpace = ObjCreate("OWC11.Chartspace")

$oChartSpace.HasChartSpaceTitle = True
$oChartSpace.ChartSpaceTitle.Caption  = $ChartCaption

$oChart = $oChartSpace.Charts.Add(0)
$oChart.HasLegend = True
$oChart.HasTitle = True

$oChart.Type = $chChartTypeColumnClustered

$oSeries = $oChartSpace.Charts(0).SeriesCollection.Add(0)

_PopulateChart()

;-------------------------------
; Create a simple GUI for our output
GUICreate($Caption, 810, 680, 10, 10, $WS_OVERLAPPEDWINDOW)

;-------------------------------
$GraphChartTypeLabel = GUICtrlCreateLabel ("Chart:", 10, 55, 40, 20)
$Graph_ChartType = $chChartTypeColumnClustered
$GraphChartTypeChoice = GUICtrlCreateCombo ("", 50, 50, 100, 20)
GUICtrlSetData ($GraphChartTypeChoice, $GraphChartTypesLine, "ColumnClustered")

$ViewButton = GUICtrlCreateButton("View", 10, 10, 100, 30)
$SaveButton = GUICtrlCreateButton("Export", 130, 10, 100, 30)

if FileExists ($FileSaved) then 
 $GUI_Chart = GUICtrlCreatePic($FileSaved, 190, 100, $ViewW, $ViewH)
 $hGUI_Chart = GUICtrlGetHandle ($GUI_Chart)
endif

;GUICtrlSetState($GUI_Chart, $GUI_HIDE)

GUISetState()       ;Show GUI

; Waiting for user to close the window
While 1
 $msg = GUIGetMsg()
 Select 
 Case $msg = $GUI_EVENT_CLOSE
  ExitLoop
 case $msg = $GraphChartTypeChoice
  $Graph_ChartType = GetChoiceGraphChartType($GraphChartTypeChoice)
  $oChart.Type = $Graph_ChartType
  _PopulateChart()
  _ViewGraph()
 case $msg = $ViewButton
  _PopulateChart()
  _ViewGraph()
 case $msg = $SaveButton
  _SaveView()
 EndSelect
WEnd

GUIDelete()

;=====================================
; Capture Graph image
func _ViewGraph()

$Interior_Color = GetColor()
$Border_Color = GetColor()

$oChartSpace.Border.Color = $Border_Color
$oChartSpace.Interior.Color = $Interior_Color

;Format the chartspace elements.
With $oChart
 .Border.Color = $Border_Color
 ;Format the chart elements.
 .Interior.Color = $Interior_Color
 .PlotArea.Interior.Color = $Interior_Color

 .HasLegend = True
 .Legend.Position = Random(0,4,1)
 .HasTitle = True
 .Title.Caption = $GraphTypeName
EndWith

If StringInStr($GraphTypeName, "Pie") or StringInStr($GraphTypeName, "Doughnut") then 
else
 With $oChart
  .Axes(0).HasTitle = True
  .Axes(0).Title.Caption = "X"
  .Axes(1).HasTitle = True
  .Axes(1).Title.Caption = "Sin(X/15)"
 EndWith
endif

;Export the chart to the temporary file
$oChartSpace.ExportPicture($FileSaved,"gif", $ViewW, $ViewH)

if Not $hGUI_Chart then 
 $GUI_Chart = GUICtrlCreatePic($FileSaved, 190, 100, $ViewW, $ViewH)
 $hGUI_Chart = GUICtrlGetHandle ($GUI_Chart)
endif

GUICtrlSetImage ($GUI_Chart, $FileSaved)
GUICtrlSetState($GUI_Chart, $GUI_SHOW)
endfunc

;===========================
Func _SaveView()
local $hBitmap
  $hBitmap = _ScreenCapture_CaptureWnd($FileSaved, $hGUI_Chart)
  _WinAPI_DeleteObject($hBitmap)
EndFunc   ;==>_Save

;===========================
Func _PopulateChart()
local $X, $Y, $YMin, $YMax, $YAbs, $Z

 $oChartSpace.Charts(0).SeriesCollection.Delete(0)

 $oSeries = $oChartSpace.Charts(0).SeriesCollection.Add(0)

 If StringInStr($GraphTypeName, "Pie") then 
  $oSeries.SetData($chDimCategories, $chDataLiteral, "IE,FireFox,Mozilla,Opera,Others")
  $oSeries.SetData($chDimValues, $chDataLiteral, "21,60,12,5,2")

 else
  $Line_Color = GetColor()
  $oSeries.Line.Color = $Line_Color
  $oSeries.Interior.Color = $Interior_Color

  $X = ""
  $Y = ""
  $YMin = ""
  $YMax = ""
  $YAbs = ""
  $Z = ""
  for $i = 1 to 30
   $X &= 24*($i-1) & "°,"
   $Y &= Sin(2*3.14*($i-1)/15) & ","
   $YAbs &= Abs(Sin(2*3.14*($i-1)/15)) & ","
   $YMin &= Abs(Sin(2*3.14*($i-1)/15))*Random(0.0,1.0) & ","
   $YMax &= Abs(Sin(2*3.14*($i-1)/15))*Random(1.0,2.0) & ","
   $Z &= Log(($i-1)/10) & ","
  next

  ;Populate data from arrays:
  If StringInStr($GraphTypeName, "Scatter") then 
   $oSeries.SetData($chDimXValues, $chDataLiteral, StringTrimRight($X,1))
   $oSeries.SetData($chDimYValues, $chDataLiteral, StringTrimRight($Y,1))
   $oSeries.Marker.Style = Random(1,9,1)
  elseif StringInStr($GraphTypeName, "Polar") then 
   $oSeries.SetData($chDimThetaValues, $chDataLiteral, StringTrimRight($X,1))
   $oSeries.SetData($chDimRValues, $chDataLiteral, StringTrimRight($YMax,1))
  elseif StringInStr($GraphTypeName, "Radar") then 
   $oSeries.SetData($chDimValues, $chDataLiteral, StringTrimRight($X,1))
   $oSeries.SetData($chDimValues, $chDataLiteral, StringTrimRight($YMin,1))
  elseif StringInStr($GraphTypeName, "Stock") then 
   $oSeries.SetData($chDimLowValues, $chDataLiteral, StringTrimRight($YMin,1))
   $oSeries.SetData($chDimHighValues, $chDataLiteral, StringTrimRight($YMax,1))
   $oSeries.Marker.Style = Random(1,9,1)
  elseif StringInStr($GraphTypeName, "Bubble") then 
   $oSeries.SetData($chDimCategories, $chDataLiteral, StringTrimRight($X,1))
   $oSeries.SetData($chDimBubbleValues, $chDataLiteral, StringTrimRight($Y,1))
  elseif StringInStr($GraphTypeName, "Line") or StringInStr($GraphTypeName, "Area") then 
   ;Name the dataseries (name appears in Legend):
   $oSeries.SetData ($chDimSeriesNames, $chDataLiteral, "Cases")
   $oSeries.SetData($chDimCategories, $chDataLiteral, StringTrimRight($X,1))
   $oSeries.SetData($chDimValues, $chDataLiteral, StringTrimRight($X,1))
   $oSeries.SetData($chDimValues, $chDataLiteral, StringTrimRight($Y,1))
   $oSeries.Marker.Style = Random(1,9,1)
  elseif StringInStr($GraphTypeName, "Bar") or StringInStr($GraphTypeName, "Column") then 
   ;Name the dataseries (name appears in Legend):
   $oSeries.SetData ($chDimSeriesNames, $chDataLiteral, "Cases")
   $oSeries.SetData($chDimCategories, $chDataLiteral, StringTrimRight($X,1))
   $oSeries.SetData($chDimValues, $chDataLiteral, StringTrimRight($X,1))
   $oSeries.SetData($chDimValues, $chDataLiteral, StringTrimRight($Y,1))
   $oSeries.Marker.Style = Random(1,9,1)
  else

  endif

 endif
endfunc

;=============================
; Return value of GraphType constants choiced
func GetChoiceGraphChartType($CtrlId)
local $Type
 $Type = GuiCtrlRead($CtrlId)
 for $i = 1 to $GraphChartTypes[0]
   if $Type = $GraphChartTypes[$i] then 
    $GraphTypeName = $Type
    return Eval("chChartType" & $Type)
   endif
 next
endfunc

;=============================
; Return random color
func GetColor()
local $Type
 $Index = Random(1,$ColorNameList[0])
 return $ColorNameList[$Index]
endfunc

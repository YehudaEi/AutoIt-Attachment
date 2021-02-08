;=====================================================
; AGraph Preview - sample of MS Graph used by AutoIt
; It allows to create and show the image obtained from Graph application
; Version 0.3
; Requirement:
; - Registered MS Graph.exe application
; History
; 23.06.10
; Added:
; - TrendLines and TrendLineEquation
; Fixed:
; - other dataset content
; 24.06.10
; Added:
; - tuning Interior, Axes, Titles, GridLines, Fonts
; Fixed:
; - other dataset content
; 24.06.10
; Added:
; - tuning Pattern, Grids, Elevation, Rotation

#include <GDIP.au3>
#Include <Memory.au3>
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#Include <WinAPI.au3>
#include <ClipBoard.au3>
#include <ScreenCapture.au3>
#include "AGraph_Constants.au3"

;===============================================================
Global $Caption = "AGraph Preview © Valery Ivanov, 21 June 2010"

Global $oGraph, $GUIActiveX
Global $CaptureButton, $msg

Global $oApplication, $oDataSheet, $oRange
Global $oChart, $oChartArea, $oChartTitle, $oCorners, $oDataTable, $oFloor, $oLegend
Global $oTrendLine, $oPlotArea, $oSurfaceGroup, $oWalls

Global $oPreview

Global $hWndGraph, $hWndGui

Global $ClassID = "[CLASS:ShImgVw:CZoomWnd; INSTANCE:1]"
Global $GUI_OBJ, $hGUI_OBJ

Global $FileSaved = @ScriptDir & "\Graph.emf"
Global $WMFFileSaved = $FileSaved
Global $JPGFileSaved = StringTrimRight($FileSaved, 4) & ".jpg"
Global $ViewW = 580, $ViewH = 540

Global $Graph_ChartType, $GraphChartTypesLine = "Area|Line|XYScatter|ColumnStacked|ColumnStacked100|3DColumnClustered|3DColumnStacked|3DColumnStacked100|BarClustered|BarStacked|BarStacked100|3DBarClustered|3DBarStacked|3DBarStacked100|LineStacked|LineStacked100|LineMarkers|LineMarkersStacked|LineMarkersStacked100|XYScatterSmooth|XYScatterSmoothNoMarkers|XYScatterLines|XYScatterLinesNoMarkers|AreaStacked|AreaStacked100|3DAreaStacked|3DAreaStacked100|Surface|SurfaceWireframe|SurfaceTopView|SurfaceTopViewWireframe|CylinderColClustered|CylinderColStacked|CylinderColStacked100|CylinderBarClustered|CylinderBarStacked|CylinderBarStacked100|CylinderCol|ConeColClustered|ConeColStacked|ConeColStacked100|ConeBarClustered|ConeBarStacked|ConeBarStacked100|ConeCol|PyramidColClustered|PyramidColStacked|PyramidColStacked100|PyramidBarClustered|PyramidBarStacked|PyramidBarStacked100|PyramidCol|3DColumn|3DLine|3DArea|Pie|PieOfPie|PieExploded|3DPie|3DPieExploded|BarOfPie|Radar|RadarMarkers|RadarFilled|Doughnut|DoughnutExploded|Bubble|Bubble3DEffect"
; This charts are for special dataset, only!
Global $InvalidCharts = "StockHLC|StockOHLC|StockVHLC|StockVOHLC|"
Global $GraphChartTypes = StringSplit($GraphChartTypesLine,"|")
Global $GraphTypeName 

Global $TrendLine, $TrendLineFlag = 0
Global $TrendLine_Type, $TrendLineTypesLine = "Exponential|Linear|Logarithmic|MovingAvg|Polynomial|Power"
Global $TrendLineTypes = StringSplit($TrendLineTypesLine,"|")
Global $TrendEquation, $TrendEquationFlag = 0

$oPreview = ObjCreate("Preview.Preview")
    
$oApplication = ObjCreate("MSGraph.Application")
;$oApplication.ChartWizardDisplay()
$oApplication.Visible = False
$oChart = $oApplication.Chart()
$oChart.ChartType = $xlLine

$hWndGraph = WinGetHandle("Microsoft Graph","")
$oApplication.WindowState = $xlMinimized

$oDataSheet = $oApplication.DataSheet
$oRange = $oDataSheet.Cells()

_PopulateDataSheet()

;-------------------------------
; Create a simple GUI for our output
GUICreate($Caption, 800, 525, 10, 10, $WS_OVERLAPPEDWINDOW)

;-------------------------------
$GraphChartTypeLabel = GUICtrlCreateLabel ("Chart:", 10, 55, 40, 20)
GUICtrlSetFont(-1, 10, 800, 0, "Verdana")

$Graph_ChartType = $xlLine
$GraphChartTypeChoice = GUICtrlCreateCombo ("", 80, 50, 120, 20)
GUICtrlSetFont(-1, 10, 800, 0, "Verdana")
GUICtrlSetData ($GraphChartTypeChoice, $GraphChartTypesLine, "Line")

$TrendLine = GUICtrlCreateCheckbox ("TrendLine", 10, 85, 120, 20)
GUICtrlSetFont(-1, 10, 800, 0, "Verdana")
GUICtrlSetState (-1, $GUI_UNCHECKED)

$TrendLineTypeLabel = GUICtrlCreateLabel ("TrendLine:", 10, 125, 40, 20)
GUICtrlSetFont(-1, 10, 800, 0, "Verdana")
GUICtrlSetState ($TrendLineTypeLabel, $GUI_HIDE)

$TrendLine_Type = $xlPolynomial
$TrendLineTypeChoice = GUICtrlCreateCombo ("", 80, 120, 120, 20)
GUICtrlSetFont(-1, 10, 800, 0, "Verdana")
GUICtrlSetData ($TrendLineTypeChoice, $TrendLineTypesLine, "Polynomial")
GUICtrlSetState ($TrendLineTypeChoice, $GUI_HIDE)

$TrendEquation = GUICtrlCreateCheckbox ("Equation", 10, 150, 120, 20)
GUICtrlSetFont(-1, 10, 800, 0, "Verdana")
GUICtrlSetState (-1, $GUI_UNCHECKED)
GUICtrlSetState ($TrendEquation, $GUI_HIDE)

$ViewButton = GUICtrlCreateButton("View", 10, 10, 100, 30)
$PopulateButton = GUICtrlCreateButton("Populate", 130, 10, 100, 30)
$SaveButton = GUICtrlCreateButton("Export", 250, 10, 100, 30)

$GUI_OBJ = GUICtrlCreateObj($oPreview, 210, 80, $ViewW, $ViewH)
GUICtrlSetState($GUI_OBJ, $GUI_NOFOCUS)
$hGUI_OBJ = ControlGetHandle("Embedded Graph control Test", "", $ClassID)

$GraphTypeValue = ""

GUISetState()       ;Show GUI
WinMove($hWndGraph,"", 0, 50, 500, 600)

; Waiting for user to close the window
While 1
 $msg = GUIGetMsg()
 Select 
 Case $msg = $GUI_EVENT_CLOSE
  ExitLoop
 case $msg = $TrendEquation
  $TrendEquationFlag = 0
  if GUICtrlRead($TrendEquation) = $GUI_CHECKED then $TrendEquation = 1 

 case $msg = $TrendLine
  $TrendLineFlag = 0
  if GUICtrlRead($TrendLine) = $GUI_CHECKED then 
    $TrendLineFlag = 1
    GUICtrlSetState ($TrendLineTypeLabel, $GUI_SHOW)
    GUICtrlSetState ($TrendLineTypeChoice, $GUI_SHOW)
    GUICtrlSetState ($TrendEquation, $GUI_SHOW)
  else
    GUICtrlSetState ($TrendLineTypeLabel, $GUI_HIDE)
    GUICtrlSetState ($TrendLineTypeChoice, $GUI_HIDE)
    GUICtrlSetState ($TrendEquation, $GUI_HIDE)
  endif
 case $msg = $GraphChartTypeChoice
  _PrepChart()
  _ViewGraph()
 case $msg = $ViewButton
  _PrepChart()
  _ViewGraph()
 case $msg = $PopulateButton
  _PopulateDataSheet()
 case $msg = $SaveButton
;  _SaveView()
 EndSelect
WEnd

GUIDelete()

;=====================================
; Prepare Chart 
func _PrepChart()
local $TrendL

  $TrendLine_Type = GetChoiceTrendLineType($TrendLineTypeChoice)
  $Graph_ChartType = GetChoiceGraphChartType($GraphChartTypeChoice)
  $oChart.ChartType = $Graph_ChartType

  if $Graph_ChartType < $xlSurface then 
   for $oSeries in $oChart.SeriesCollection
     for $oTrendL in $oSeries.TrendLines
      $oTrendL.Delete()
     next
   next
  endif
  
  if $TrendLineFlag then 
   for $oSeries in $oChart.SeriesCollection
    $oTrendL = $oSeries.TrendLines.Add
    if $TrendEquationFlag then 
      $oTrendL.DisplayEquation = True
    else
      $oTrendL.DisplayEquation = True
    endif
    $oTrendL.Type = $TrendLine_Type
   next
   GUICtrlSetState ($TrendLine, $GUI_UNCHECKED)
   $TrendLineFlag = 0
   GUICtrlSetState ($TrendLineTypeLabel, $GUI_HIDE)
   GUICtrlSetState ($TrendLineTypeChoice, $GUI_HIDE)
   GUICtrlSetState ($TrendEquation, $GUI_HIDE)
  endif

  ; Interior colors
  $oChart.ChartArea.Interior.Color = 0xDDFFFF
  $oChart.PlotArea.Interior.Color = 0xBBEEEE
  if StringInStr($GraphTypeName,"XYScatter") then 
    $oChart.PlotArea.Interior.Pattern = $xlPatternLightUp
  else
    $oChart.PlotArea.Interior.Pattern = $xlPatternNone
  endif

  $oChart.HasTitle = True

  ; Title of chart
  with $oChart.ChartTitle
   .Text = $GraphTypeName & @Lf & " (type " & $oChart.Type & "; subtype " & $oChart.SubType & ")"
   .Font.Name = "Tahoma"
   .Font.Color = 0x888888
   .Font.Bold = True
   .Font.Size = 16
   .Shadow = False
  endwith

  ; Axes of chart
  ; Skip Pie, Radar and Doughnut types
 if Not StringInStr($GraphTypeName,"Pie") and Not StringInStr($GraphTypeName,"Radar") and Not StringInStr($GraphTypeName,"Doughnut") then 

  ; X-Axis
  $oChart.HasAxis($xlCategory, $xlPrimary) = True
  with $oChart.Axes($xlCategory)
   .HasMajorGridlines = True
   .HasMinorGridlines = False
   .HasTitle = True
   .AxisTitle.Caption = "Angles"
   .AxisTitle.Shadow = False
   .AxisTitle.Font.Name = "Tahoma"
   .AxisTitle.Font.Color = 0x884444
   .AxisTitle.Font.Bold = True
   .AxisTitle.Font.Italic = False
   .AxisTitle.Font.Size = 10
   if StringInStr($GraphTypeName,"Bar") then 
     .AxisTitle.Orientation = $xlUpward ; may be xlHorizontal, xlVertical, xlUpward
   else 
     .AxisTitle.Orientation = $xlHorizontal
   endif
  endwith

  ; Y-Axis
  $oChart.HasAxis($xlValue, $xlPrimary) = True
  with $oChart.Axes($xlValue)
   .HasMajorGridlines = True
   .HasMinorGridlines = False
   .HasTitle = True
   if StringInStr($GraphTypeName,"Line") then 
   .ScaleType = $xlLogarithmic
   .AxisTitle.Caption = "Values (log)"
   else
   .ScaleType = $xlLinear
   .AxisTitle.Caption = "Values"
   endif
   .AxisTitle.Shadow = False
   .AxisTitle.Font.Name = "Tahoma"
   .AxisTitle.Font.Color = 0x884444
   .AxisTitle.Font.Bold = True
   .AxisTitle.Font.Italic = False
   .AxisTitle.Font.Size = 10
   if StringInStr($GraphTypeName,"Bar") then 
     .AxisTitle.Orientation = $xlHorizontal
   else 
     .AxisTitle.Orientation = $xlUpward ; may be xlHorizontal, xlVertical, xlUpward
   endif
  endwith

 endif

  ; MarkerStyle
  if StringInStr($GraphTypeName,"Marker") then 
   for $oSeries in $oChart.SeriesCollection
    $oSeries.MarkerStyle = $xlMarkerStyleDiamond
   next
  endif


 if StringInStr($GraphTypeName,"3DLine") or StringInStr($GraphTypeName,"3DColumn") or StringInStr($GraphTypeName,"3DBar") then 
  $oChart.RightAngleAxes = False
 endif

 if Not StringInStr($GraphTypeName,"Bubble") then

 ; The rotation of the 3-D chart around the z-axis, in degrees. 
  if StringInStr($GraphTypeName,"3D") then 
    if StringInStr($GraphTypeName,"3DBar") then 
     $oChart.Elevation = 10
     $oChart.Rotation = 0
    else
     $oChart.Elevation = 15
     $oChart.Rotation = 40
   endif
  endif

 endif

 ;Now copy prepared chart to clipboard

 $oChart.ChartArea.Copy()

endfunc

;=====================================
; View image of Graph 
func _ViewGraph()
Local $hEnMetaFile, $hFileMetaFile

  if Not _ClipBoard_IsFormatAvailable($CF_ENHMETAFILE) then return
  If Not _ClipBoard_Open($hWndGraph) Then  return

  $hEnMetaFile = _ClipBoard_GetDataEx($CF_ENHMETAFILE)
  ; Save resultant image
  $hFileMetaFile = DllCall("gdi32.dll", "int", "CopyEnhMetaFile", "hwnd", $hEnMetaFile, "str", $WMFFileSaved)
  $hFileMetaFile = $hFileMetaFile[0]
  _WinAPI_DeleteEnhMetaFile($hFileMetaFile)
  _MemGlobalUnlock($hEnMetaFile)

  _ClipBoard_Close()
  $oPreview.ShowFile ($WMFFileSaved, 1)

endfunc

;===========================
Func _SaveView()
local $hBitmap
  $hBitmap = _ScreenCapture_CaptureWnd($JPGFileSaved, $hGUI_OBJ)
  _WinAPI_DeleteObject($hBitmap)
EndFunc   ;==>_Save

;===========================
Func _PopulateDataSheet()
local $Count = 30
with $oDataSheet
 .Cells.Clear
 .Cells(1,1).Value = "X"
 .Cells(2,1).Value = "Sin(X)"
 .Cells(3,1).Value = "Log(X/10)"
 .Cells(4,1).Value = "ATan(Log(X/20))"

 For $i = 2 to $Count+1
  .Cells(1,$i).Value = 12*($i-1) & "°"
  .Cells(2,$i).Value = Sin(3.14*($i-1)/15)
  .Cells(3,$i).Value = Log(($i-1)/10)
  .Cells(4,$i).Value = ATan(Log(($i-1)/20))
 next
endwith

EndFunc   ;==>_PopulateDataSheet

;=============================
; Return value of GraphType constants choiced
func GetChoiceGraphChartType($CtrlId)
local $Type
 $Type = GuiCtrlRead($CtrlId)
 for $i = 1 to $GraphChartTypes[0]
   if $Type = $GraphChartTypes[$i] then 
    $GraphTypeName = $Type
    return Eval("xl" & $Type)
   endif
 next
endfunc

;=============================
; Return value of TrendlineType constants choiced
func GetChoiceTrendlineType($CtrlId)
local $Type
 $Type = GuiCtrlRead($CtrlId)
 for $i = 1 to $TrendlineTypes[0]
   if $Type = $TrendlineTypes[$i] then 
    return Eval("xl" & $Type)
   endif
 next
endfunc

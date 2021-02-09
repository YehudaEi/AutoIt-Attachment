;=========================================
; Graph.exe Enums
;=========================================
; msoFillType
Global Const $msoFillBackground = 0x5
Global Const $msoFillGradient = 0x3
Global Const $msoFillMixed = -2
Global Const $msoFillPatterned = 0x2
Global Const $msoFillPicture = 0x6
Global Const $msoFillSolid = 0x1
Global Const $msoFillTextured = 0x4

; MsoGradientColorType
Global Const $msoGradientColorMixed         = -2
Global Const $msoGradientOneColor           = 0x1
Global Const $msoGradientPresetColors       = 0x3
Global Const $msoGradientTwoColors          = 0x2
Global Const $msoGradientDiagonalDown       = 0x4
Global Const $msoGradientDiagonalUp         = 0x3
Global Const $msoGradientFromCenter         = 0x7
Global Const $msoGradientFromCorner         = 0x5
Global Const $msoGradientFromTitle          = 0x6
Global Const $msoGradientHorizontal         = 0x1
Global Const $msoGradientMixed              = -2
Global Const $msoGradientVertical           = 0x2

; XlChartGallery
Global Const $xlBuiltIn = 21
Global Const $xlUserDefined = 22
Global Const $xlAnyGallery = 23

; XlColorIndex
Global Const $xlColorIndexAutomatic = -4105
Global Const $xlColorIndexNone = -4142

; XlEndStyleCap
Global Const $xlCap = 1
Global Const $xlNoCap = 2

; XlRowCol
Global Const $xlColumns = 2
Global Const $xlRows = 1

; XlScaleType
Global Const $xlScaleLinear = -4132
Global Const $xlScaleLogarithmic = -4133

; XlDataSeriesType
Global Const $xlAutoFill = 4
Global Const $xlChronological = 3
Global Const $xlGrowth = 2
Global Const $xlDataSeriesLinear = -4132

; XlAxisCrosses
Global Const $xlAxisCrossesAutomatic = -4105
Global Const $xlAxisCrossesCustom = -4114
Global Const $xlAxisCrossesMaximum = 2
Global Const $xlAxisCrossesMinimum = 4

; XlAxisGroup
Global Const $xlPrimary = 1
Global Const $xlSecondary = 2

; XlBackground
Global Const $xlBackgroundAutomatic = -4105
Global Const $xlBackgroundOpaque = 3
Global Const $xlBackgroundTransparent = 2

; XlWindowState
Global Const $xlMaximized = -4137
Global Const $xlMinimized = -4140
Global Const $xlNormal = -4143

; XlAxisType
Global Const $xlCategory = 1
Global Const $xlSeriesAxis = 3
Global Const $xlValue = 2

; XlArrowHeadLength
Global Const $xlArrowHeadLengthLong = 3
Global Const $xlArrowHeadLengthMedium = -4138
Global Const $xlArrowHeadLengthShort = 1

; XlVAlign
Global Const $xlVAlignBottom = -4107
Global Const $xlVAlignCenter = -4108
Global Const $xlVAlignDistributed = -4117
Global Const $xlVAlignJustify = -4130
Global Const $xlVAlignTop = -4160

; XlTickMark
Global Const $xlTickMarkCross = 4
Global Const $xlTickMarkInside = 2
Global Const $xlTickMarkNone = -4142
Global Const $xlTickMarkOutside = 3

; XlErrorBarDirection
Global Const $xlX = -4168
Global Const $xlY = 1

; XlErrorBarInclude
Global Const $xlErrorBarIncludeBoth = 1
Global Const $xlErrorBarIncludeMinusValues = 3
Global Const $xlErrorBarIncludeNone = -4142
Global Const $xlErrorBarIncludePlusValues = 2

; XlDisplayBlanksAs
Global Const $xlInterpolated = 3
Global Const $xlNotPlotted = 1
Global Const $xlZero = 2

; XlArrowHeadStyle
Global Const $xlArrowHeadStyleClosed = 3
Global Const $xlArrowHeadStyleDoubleClosed = 5
Global Const $xlArrowHeadStyleDoubleOpen = 4
Global Const $xlArrowHeadStyleNone = -4142
Global Const $xlArrowHeadStyleOpen = 2

; XlArrowHeadWidth
Global Const $xlArrowHeadWidthMedium = -4138
Global Const $xlArrowHeadWidthNarrow = 1
Global Const $xlArrowHeadWidthWide = 3

; XlHAlign
Global Const $xlHAlignCenter = -4108
Global Const $xlHAlignCenterAcrossSelection = 7
Global Const $xlHAlignDistributed = -4117
Global Const $xlHAlignFill = 5
Global Const $xlHAlignGeneral = 1
Global Const $xlHAlignJustify = -4130
Global Const $xlHAlignLeft = -4131
Global Const $xlHAlignRight = -4152

; XlTickLabelPosition
Global Const $xlTickLabelPositionHigh = -4127
Global Const $xlTickLabelPositionLow = -4134
Global Const $xlTickLabelPositionNextToAxis = 4
Global Const $xlTickLabelPositionNone = -4142

; XlLegendPosition
Global Const $xlLegendPositionBottom = -4107
Global Const $xlLegendPositionCorner = 2
Global Const $xlLegendPositionLeft = -4131
Global Const $xlLegendPositionRight = -4152
Global Const $xlLegendPositionTop = -4160

; XlChartPictureType
Global Const $xlStackScale = 3
Global Const $xlStack = 2
Global Const $xlStretch = 1

; XlChartPicturePlacement
Global Const $xlSides = 1
Global Const $xlEnd = 2
Global Const $xlEndSides = 3
Global Const $xlFront = 4
Global Const $xlFrontSides = 5
Global Const $xlFrontEnd = 6
Global Const $xlAllFaces = 7

; XlOrientation
Global Const $xlDownward = -4170
Global Const $xlHorizontal = -4128
Global Const $xlUpward = -4171
Global Const $xlVertical = -4166

; XlTickLabelOrientation
Global Const $xlTickLabelOrientationAutomatic = -4105
Global Const $xlTickLabelOrientationDownward = -4170
Global Const $xlTickLabelOrientationHorizontal = -4128
Global Const $xlTickLabelOrientationUpward = -4171
Global Const $xlTickLabelOrientationVertical = -4166

; XlBorderWeight
Global Const $xlHairline = 1
Global Const $xlMedium = -4138
Global Const $xlThick = 4
Global Const $xlThin = 2

; XlDataSeriesDate
Global Const $xlDay = 1
Global Const $xlMonth = 3
Global Const $xlWeekday = 2
Global Const $xlYear = 4

; XlUnderlineStyle
Global Const $xlUnderlineStyleDouble = -4119
Global Const $xlUnderlineStyleDoubleAccounting = 5
Global Const $xlUnderlineStyleNone = -4142
Global Const $xlUnderlineStyleSingle = 2
Global Const $xlUnderlineStyleSingleAccounting = 4

; XlErrorBarType
Global Const $xlErrorBarTypeCustom = -4114
Global Const $xlErrorBarTypeFixedValue = 1
Global Const $xlErrorBarTypePercent = 2
Global Const $xlErrorBarTypeStDev = -4155
Global Const $xlErrorBarTypeStError = 4

; XlTrendlineType
Global Const $xlExponential = 5
Global Const $xlLinear = -4132
Global Const $xlLogarithmic = -4133
Global Const $xlMovingAvg = 6
Global Const $xlPolynomial = 3
Global Const $xlPower = 4

; XlLineStyle
Global Const $xlContinuous = 1
Global Const $xlDash = -4115
Global Const $xlDashDot = 4
Global Const $xlDashDotDot = 5
Global Const $xlDot = -4118
Global Const $xlDouble = -4119
Global Const $xlSlantDashDot = 13
Global Const $xlLineStyleNone = -4142

; XlDataLabelsType
Global Const $xlDataLabelsShowNone = -4142
Global Const $xlDataLabelsShowValue = 2
Global Const $xlDataLabelsShowPercent = 3
Global Const $xlDataLabelsShowLabel = 4
Global Const $xlDataLabelsShowLabelAndPercent = 5
Global Const $xlDataLabelsShowBubbleSizes = 6

; XlMarkerStyle
Global Const $xlMarkerStyleAutomatic = -4105
Global Const $xlMarkerStyleCircle = 8
Global Const $xlMarkerStyleDash = -4115
Global Const $xlMarkerStyleDiamond = 2
Global Const $xlMarkerStyleDot = -4118
Global Const $xlMarkerStyleNone = -4142
Global Const $xlMarkerStylePicture = -4147
Global Const $xlMarkerStylePlus = 9
Global Const $xlMarkerStyleSquare = 1
Global Const $xlMarkerStyleStar = 5
Global Const $xlMarkerStyleTriangle = 3
Global Const $xlMarkerStyleX = -4168

; XlPictureConvertorType
Global Const $xlBMP = 1
Global Const $xlCGM = 7
Global Const $xlDRW = 4
Global Const $xlDXF = 5
Global Const $xlEPS = 8
Global Const $xlHGL = 6
Global Const $xlPCT = 13
Global Const $xlPCX = 10
Global Const $xlPIC = 11
Global Const $xlPLT = 12
Global Const $xlTIF = 9
Global Const $xlWMF = 2
Global Const $xlWPG = 3

; XlPattern
Global Const $xlPatternAutomatic = -4105
Global Const $xlPatternChecker = 9
Global Const $xlPatternCrissCross = 16
Global Const $xlPatternDown = -4121
Global Const $xlPatternGray16 = 17
Global Const $xlPatternGray25 = -4124
Global Const $xlPatternGray50 = -4125
Global Const $xlPatternGray75 = -4126
Global Const $xlPatternGray8 = 18
Global Const $xlPatternGrid = 15
Global Const $xlPatternHorizontal = -4128
Global Const $xlPatternLightDown = 13
Global Const $xlPatternLightHorizontal = 11
Global Const $xlPatternLightUp = 14
Global Const $xlPatternLightVertical = 12
Global Const $xlPatternNone = -4142
Global Const $xlPatternSemiGray75 = 10
Global Const $xlPatternSolid = 1
Global Const $xlPatternUp = -4162
Global Const $xlPatternVertical = -4166

; XlChartSplitType
Global Const $xlSplitByPosition = 1
Global Const $xlSplitByPercentValue = 3
Global Const $xlSplitByCustomSplit = 4
Global Const $xlSplitByValue = 2

; XlDisplayUnit
Global Const $xlHundreds = -2
Global Const $xlThousands = -3
Global Const $xlTenThousands = -4
Global Const $xlHundredThousands = -5
Global Const $xlMillions = -6
Global Const $xlTenMillions = -7
Global Const $xlHundredMillions = -8
Global Const $xlThousandMillions = -9
Global Const $xlMillionMillions = -10

; XlDataLabelPosition
Global Const $xlLabelPositionCenter = -4108
Global Const $xlLabelPositionAbove = 0
Global Const $xlLabelPositionBelow = 1
Global Const $xlLabelPositionLeft = -4131
Global Const $xlLabelPositionRight = -4152
Global Const $xlLabelPositionOutsideEnd = 2
Global Const $xlLabelPositionInsideEnd = 3
Global Const $xlLabelPositionInsideBase = 4
Global Const $xlLabelPositionBestFit = 5
Global Const $xlLabelPositionMixed = 6
Global Const $xlLabelPositionCustom = 7

; XlTimeUnit
Global Const $xlDays = 0
Global Const $xlMonths = 1
Global Const $xlYears = 2

; XlCategoryType
Global Const $xlCategoryScale = 2
Global Const $xlTimeScale = 3
Global Const $xlAutomaticScale = -4105

; XlBarShape
Global Const $xlBox = 0
Global Const $xlPyramidToPoint = 1
Global Const $xlPyramidToMax = 2
Global Const $xlCylinder = 3
Global Const $xlConeToPoint = 4
Global Const $xlConeToMax = 5

; XlChartItem
Global Const $xlDataLabel = 0
Global Const $xlChartArea = 2
Global Const $xlSeries = 3
Global Const $xlChartTitle = 4
Global Const $xlWalls = 5
Global Const $xlCorners = 6
Global Const $xlDataTable = 7
Global Const $xlTrendline = 8
Global Const $xlErrorBars = 9
Global Const $xlXErrorBars = 10
Global Const $xlYErrorBars = 11
Global Const $xlLegendEntry = 12
Global Const $xlLegendKey = 13
Global Const $xlShape = 14
Global Const $xlMajorGridlines = 15
Global Const $xlMinorGridlines = 16
Global Const $xlAxisTitle = 17
Global Const $xlUpBars = 18
Global Const $xlPlotArea = 19
Global Const $xlDownBars = 20
Global Const $xlAxis = 21
Global Const $xlSeriesLines = 22
Global Const $xlFloor = 23
Global Const $xlLegend = 24
Global Const $xlHiLoLines = 25
Global Const $xlDropLines = 26
Global Const $xlRadarAxisLabels = 27
Global Const $xlNothing = 28
Global Const $xlLeaderLines = 29
Global Const $xlDisplayUnitLabel = 30
Global Const $xlPivotChartFieldButton = 31
Global Const $xlPivotChartDropZone = 32

; XlSizeRepresents
Global Const $xlSizeIsWidth = 2
Global Const $xlSizeIsArea = 1

; XlInsertShiftDirection
Global Const $xlShiftDown = -4121
Global Const $xlShiftToRight = -4161

; XlDeleteShiftDirection
Global Const $xlShiftToLeft = -4159
Global Const $xlShiftUp = -4162

; XlDirection
Global Const $xlDown = -4121
Global Const $xlToLeft = -4159
Global Const $xlToRight = -4161
Global Const $xlUp = -4162

; XlConsolidationFunction
Global Const $xlAverage = -4106
Global Const $xlCount = -4112
Global Const $xlCountNums = -4113
Global Const $xlMax = -4136
Global Const $xlMin = -4139
Global Const $xlProduct = -4149
Global Const $xlStDev = -4155
Global Const $xlStDevP = -4156
Global Const $xlSum = -4157
Global Const $xlVar = -4164
Global Const $xlVarP = -4165
Global Const $xlUnknown = 1000

; XlSheetType
Global Const $xlChart = -4109
Global Const $xlDialogSheet = -4116
Global Const $xlExcel4IntlMacroSheet = 4
Global Const $xlExcel4MacroSheet = 3
Global Const $xlWorksheet = -4167

; XlLocationInTable
Global Const $xlColumnHeader = -4110
Global Const $xlColumnItem = 5
Global Const $xlDataHeader = 3
Global Const $xlDataItem = 7
Global Const $xlPageHeader = 2
Global Const $xlPageItem = 6
Global Const $xlRowHeader = -4153
Global Const $xlRowItem = 4
Global Const $xlTableBody = 8

; XlFindLookIn
Global Const $xlFormulas = -4123
Global Const $xlComments = -4144
Global Const $xlValues = -4163

; XlWindowType
Global Const $xlChartAsWindow = 5
Global Const $xlChartInPlace = 4
Global Const $xlClipboard = 3
Global Const $xlInfo = -4129
Global Const $xlWorkbook = 1

; XlPivotFieldDataType
Global Const $xlDate = 2
Global Const $xlNumber = -4145
Global Const $xlText = -4158

; XlCopyPictureFormat
Global Const $xlBitmap = 2
Global Const $xlPicture = -4147

; XlPivotTableSourceType
Global Const $xlScenario = 4
Global Const $xlConsolidation = 3
Global Const $xlDatabase = 1
Global Const $xlExternal = 2
Global Const $xlPivotTable = -4148

; XlReferenceStyle
Global Const $xlA1 = 1
Global Const $xlR1C1 = -4150

; XlPivotFormatType
Global Const $xlReport1 = 0
Global Const $xlReport2 = 1
Global Const $xlReport3 = 2
Global Const $xlReport4 = 3
Global Const $xlReport5 = 4
Global Const $xlReport6 = 5
Global Const $xlReport7 = 6
Global Const $xlReport8 = 7
Global Const $xlReport9 = 8
Global Const $xlReport10 = 9
Global Const $xlTable1 = 10
Global Const $xlTable2 = 11
Global Const $xlTable3 = 12
Global Const $xlTable4 = 13
Global Const $xlTable5 = 14
Global Const $xlTable6 = 15
Global Const $xlTable7 = 16
Global Const $xlTable8 = 17
Global Const $xlTable9 = 18
Global Const $xlTable10 = 19
Global Const $xlPTClassic = 20
Global Const $xlPTNone = 21

; XlCmdType
Global Const $xlCmdCube = 1
Global Const $xlCmdSql = 2
Global Const $xlCmdTable = 3
Global Const $xlCmdDefault = 4

; XlColumnDataType
Global Const $xlGeneralFormat = 1
Global Const $xlTextFormat = 2
Global Const $xlMDYFormat = 3
Global Const $xlDMYFormat = 4
Global Const $xlYMDFormat = 5
Global Const $xlMYDFormat = 6
Global Const $xlDYMFormat = 7
Global Const $xlYDMFormat = 8
Global Const $xlSkipColumn = 9
Global Const $xlEMDFormat = 10

; XlQueryType
Global Const $xlODBCQuery = 1
Global Const $xlDAORecordset = 2
Global Const $xlWebQuery = 4
Global Const $xlOLEDBQuery = 5
Global Const $xlTextImport = 6
Global Const $xlADORecordset = 7

; XlWebSelectionType
Global Const $xlEntirePage = 1
Global Const $xlAllTables = 2
Global Const $xlSpecifiedTables = 3

; XlCubeFieldType
Global Const $xlHierarchy = 1
Global Const $xlMeasure = 2
Global Const $xlSet = 3

; XlWebFormatting
Global Const $xlWebFormattingAll = 1
Global Const $xlWebFormattingRTF = 2
Global Const $xlWebFormattingNone = 3

; XlDisplayDrawingObjects
Global Const $xlDisplayShapes = -4104
Global Const $xlHide = 3
Global Const $xlPlaceholders = 2

; XlSubtototalLocationType
Global Const $xlAtTop = 1
Global Const $xlAtBottom = 2

; XlDataLabelSeparator
Global Const $xlDataLabelSeparatorDefault = 1

; XlRangeValueDataType
Global Const $xlRangeValueDefault = 10
Global Const $xlRangeValueXMLSpreadsheet = 11
Global Const $xlRangeValueMSPersistXML = 12

; XlInsertFormatOrigin
Global Const $xlFormatFromLeftOrAbove = 0
Global Const $xlFormatFromRightOrBelow = 1

; XlArabicModes
Global Const $xlArabicNone = 0
Global Const $xlArabicStrictAlefHamza = 1
Global Const $xlArabicStrictFinalYaa = 2
Global Const $xlArabicBothStrict = 3

; XlImportDataAs
Global Const $xlQueryTable = 0
Global Const $xlPivotTableReport = 1

; XlCalculatedMemberType
Global Const $xlCalculatedMember = 0
Global Const $xlCalculatedSet = 1

; XlHebrewModes
Global Const $xlHebrewFullScript = 0
Global Const $xlHebrewPartialScript = 1
Global Const $xlHebrewMixedScript = 2
Global Const $xlHebrewMixedAuthorizedScript = 3

; XlChartTypes
Global Const $xlArea = 1
Global Const $xlLine = 4
Global Const $xlPie = 5
Global Const $xlColumnClustered = 51
Global Const $xlColumnStacked = 52
Global Const $xlColumnStacked100 = 53
Global Const $xl3DColumnClustered = 54
Global Const $xl3DColumnStacked = 55
Global Const $xl3DColumnStacked100 = 56
Global Const $xlBarClustered = 57
Global Const $xlBarStacked = 58
Global Const $xlBarStacked100 = 59
Global Const $xl3DBarClustered = 60
Global Const $xl3DBarStacked = 61
Global Const $xl3DBarStacked100 = 62
Global Const $xlLineStacked = 63
Global Const $xlLineStacked100 = 64
Global Const $xlLineMarkers = 65
Global Const $xlLineMarkersStacked = 66
Global Const $xlLineMarkersStacked100 = 67
Global Const $xlPieOfPie = 68
Global Const $xlPieExploded = 69
Global Const $xl3DPieExploded = 70
Global Const $xlBarOfPie = 71
Global Const $xlXYScatterSmooth = 72
Global Const $xlXYScatterSmoothNoMarkers = 73
Global Const $xlXYScatterLines = 74
Global Const $xlXYScatterLinesNoMarkers = 75
Global Const $xlAreaStacked = 76
Global Const $xlAreaStacked100 = 77
Global Const $xl3DAreaStacked = 78
Global Const $xl3DAreaStacked100 = 79
Global Const $xlDoughnutExploded = 80
Global Const $xlRadarMarkers = 81
Global Const $xlRadarFilled = 82
Global Const $xlSurface = 83
Global Const $xlSurfaceWireframe = 84
Global Const $xlSurfaceTopView = 85
Global Const $xlSurfaceTopViewWireframe = 86

Global Const $xlBubble = 15
Global Const $xlBubble3DEffect = 87
Global Const $xlStockHLC = 88
Global Const $xlStockOHLC = 89
Global Const $xlStockVHLC = 90
Global Const $xlStockVOHLC = 91
Global Const $xlCylinderColClustered = 92
Global Const $xlCylinderColStacked = 93
Global Const $xlCylinderColStacked100 = 94
Global Const $xlCylinderBarClustered = 95
Global Const $xlCylinderBarStacked = 96
Global Const $xlCylinderBarStacked100 = 97
Global Const $xlCylinderCol = 98
Global Const $xlConeColClustered = 99
Global Const $xlConeColStacked = 100
Global Const $xlConeColStacked100 = 101
Global Const $xlConeBarClustered = 102
Global Const $xlConeBarStacked = 103
Global Const $xlConeBarStacked100 = 104
Global Const $xlConeCol = 105
Global Const $xlPyramidColClustered = 106
Global Const $xlPyramidColStacked = 107
Global Const $xlPyramidColStacked100 = 108
Global Const $xlPyramidBarClustered = 109
Global Const $xlPyramidBarStacked = 110
Global Const $xlPyramidBarStacked100 = 111
Global Const $xlPyramidCol = 112

Global Const $xl3DColumn = -4100
Global Const $xlRadar = -4151
Global Const $xl3DLine = -4101
Global Const $xl3DPie = -4102
Global Const $xlXYScatter = -4169
Global Const $xl3DArea = -4098
Global Const $xlDoughnut = -4120

;=========================================
; OWC11 Enums
;=========================================

; ChartPatternTypeEnum
$chPattern5Percent = 1
$chPattern10Percent = 2
$chPattern20Percent = 3
$chPattern25Percent = 4
$chPattern30Percent = 5
$chPattern40Percent = 6
$chPattern50Percent = 7
$chPattern60Percent = 8
$chPattern70Percent = 9
$chPattern75Percent = 10
$chPattern80Percent = 11
$chPattern90Percent = 12
$chPatternDarkHorizontal = 13
$chPatternDarkVertical = 14
$chPatternDarkDownwardDiagonal = 15
$chPatternDarkUpwardDiagonal = 16
$chPatternSmallCheckerBoard = 17
$chPatternTrellis = 18
$chPatternLightHorizontal = 19
$chPatternLightVertical = 20
$chPatternLightDownwardDiagonal = 21
$chPatternLightUpwardDiagonal = 22
$chPatternSmallGrid = 23
$chPatternDottedDiamond = 24
$chPatternWideDownwardDiagonal = 25
$chPatternWideUpwardDiagonal = 26
$chPatternDashedUpwardDiagonal = 27
$chPatternDashedDownwardDiagonal = 28
$chPatternNarrowVertical = 29
$chPatternNarrowHorizontal = 30
$chPatternDashedVertical = 31
$chPatternDashedHorizontal = 32
$chPatternLargeConfetti = 33
$chPatternLargeGrid = 34
$chPatternHorizontalBrick = 35
$chPatternLargeCheckerBoard = 36
$chPatternSmallConfetti = 37
$chPatternZigZag = 38
$chPatternSolidDiamond = 39
$chPatternDiagonalBrick = 40
$chPatternOutlinedDiamond = 41
$chPatternPlaid = 42
$chPatternSphere = 43
$chPatternWeave = 44
$chPatternDottedGrid = 45
$chPatternDivot = 46
$chPatternShingle = 47
$chPatternWave = 48


; ChartFillTypeEnum
$chFillSolid = 1
$chFillPatterned = 2
$chFillGradientOneColor = 3
$chFillGradientTwoColors = 4
$chFillGradientPresetColors = 5
$chFillTexturePreset = 6
$chFillTextureUserDefined = 7

; ChartPresetGradientTypeEnum
$chGradientEarlySunset = 1
$chGradientLateSunset = 2
$chGradientNightfall = 3
$chGradientDaybreak = 4
$chGradientHorizon = 5
$chGradientDesert = 6
$chGradientOcean = 7
$chGradientCalmWater = 8
$chGradientFire = 9
$chGradientFog = 10
$chGradientMoss = 11
$chGradientPeacock = 12
$chGradientWheat = 13
$chGradientParchment = 14
$chGradientMahogany = 15
$chGradientRainbow = 16
$chGradientRainbowII = 17
$chGradientGold = 18
$chGradientGoldII = 19
$chGradientBrass = 20
$chGradientChrome = 21
$chGradientChromeII = 22
$chGradientSilver = 23
$chGradientSapphire = 24

; ChartGradientStyleEnum
$chGradientHorizontal = 1
$chGradientVertical = 2
$chGradientDiagonalUp = 3
$chGradientDiagonalDown = 4
$chGradientFromCorner = 5
$chGradientFromCenter = 7

; ChartGradientVariantEnum
$chGradientVariantStart = 1
$chGradientVariantEnd = 2
$chGradientVariantCenter = 3
$chGradientVariantEdges = 4

; ChartPresetTextureEnum
$chTexturePapyrus = 1
$chTextureCanvas = 2
$chTextureDenim = 3
$chTextureWovenMat = 4
$chTextureWaterDroplets = 5
$chTexturePaperBag = 6
$chTextureFishFossil = 7
$chTextureSand = 8
$chTextureGreenMarble = 9
$chTextureWhiteMarble = 10
$chTextureBrownMarble = 11
$chTextureGranite = 12
$chTextureNewsprint = 13
$chTextureRecycledPaper = 14
$chTextureParchment = 15
$chTextureStationery = 16
$chTextureBlueTissuePaper = 17
$chTexturePinkTissuePaper = 18
$chTexturePurpleMesh = 19
$chTextureBouquet = 20
$chTextureCork = 21
$chTextureWalnut = 22
$chTextureOak = 23
$chTextureMediumWood = 24

; ChartTextureFormatEnum
$chStack = 1
$chStackScale = 2
$chStretch = 3
$chTile = 4
$chStretchPlot = 5

; ChartTexturePlacementEnum
$chAllFaces = 7
$chEnd = 2
$chEndSides = 6
$chFront = 1
$chFrontEnd = 3
$chFrontSides = 5
$chSides = 4
$chProjectFront = 8

; ChartLineDashStyleEnum
$chLineDash = 0
$chLineDashDot = 1
$chLineDashDotDot = 2
$chLineLongDash = 4
$chLineLongDashDot = 5
$chLineRoundDot = 6
$chLineSolid = 7
$chLineSquareDot = 8

; LineWeightEnum
$owcLineWeightHairline = 0
$owcLineWeightThin = 1
$owcLineWeightMedium = 2
$owcLineWeightThick = 3

; UnderlineStyleEnum
$owcUnderlineStyleNone = 0
$owcUnderlineStyleSingle = 1
$owcUnderlineStyleDouble = 2
$owcUnderlineStyleSingleAccounting = 3
$owcUnderlineStyleDoubleAccounting = 4

; ChartLineMiterEnum
$chLineMiterBevel = 0
$chLineMiterMiter = 1
$chLineMiterRound = 2

; ChartDrawModesEnum
$chDrawModePaint = 1
$chDrawModeSelection = 2
$chDrawModeHitTest = 3
$chDrawModeScale = 4

; ChartChartLayoutEnum
$chChartLayoutAutomatic = 0
$chChartLayoutHorizontal = 1
$chChartLayoutVertical = 2

; ChartScaleOrientationEnum
$chScaleOrientationMinMax = 0
$chScaleOrientationMaxMin = 1

; ChartScaleTypeEnum
$chScaleTypeLinear = 0
$chScaleTypeLogarithmic = 1

; ChartAxisCrossesEnum
$chAxisCrossesAutomatic = 0
$chAxisCrossesCustom = 3

; ChartSelectionsEnum
$chSelectionNone = -1
$chSelectionAxis = 0
$chSelectionChart = 1
$chSelectionPlotArea = 2
$chSelectionDataLabels = 3
$chSelectionErrorbars = 4
$chSelectionGridlines = 5
$chSelectionLegend = 6
$chSelectionLegendEntry = 7
$chSelectionPoint = 8
$chSelectionSeries = 9
$chSelectionTitle = 10
$chSelectionTrendline = 11
$chSelectionChartSpace = 12
$chSelectionSurface = 13
$chSelectionField = 14
$chSelectionUserDefined = -2
$chSelectionCategoryLabel = 16
$chSelectionDropZone = 17
$chSelectionDataLabel = 18

; ChartTickMarkEnum
$chTickMarkAutomatic = 0
$chTickMarkNone = 1
$chTickMarkInside = 2
$chTickMarkOutside = 3
$chTickMarkCross = 4

; ChartAxisPositionEnum
$chAxisPositionTop = -1
$chAxisPositionBottom = -2
$chAxisPositionLeft = -3
$chAxisPositionRight = -4
$chAxisPositionRadial = -5
$chAxisPositionCircular = -6
$chAxisPositionCategory = -7
$chAxisPositionTimescale = -7
$chAxisPositionValue = -8
$chAxisPositionSeries = -9
$chAxisPositionPrimary = -10
$chAxisPositionSecondary = -11

; ChartTitlePositionEnum
$chTitlePositionAutomatic = 0
$chTitlePositionTop = 1
$chTitlePositionBottom = 2
$chTitlePositionLeft = 3
$chTitlePositionRight = 4

; ChartAxisTypeEnum
$chCategoryAxis = 0
$chValueAxis = 1
$chTimescaleAxis = 2
$chSeriesAxis = 3

; ChartAxisGroupingEnum
$chAxisGroupingNone = 0
$chAxisGroupingAuto = 1
$chAxisGroupingManual = 2

; ChartAxisUnitTypeEnum
$chAxisUnitDay = 0
$chAxisUnitWeek = 1
$chAxisUnitMonth = 2
$chAxisUnitQuarter = 3
$chAxisUnitYear = 4

; ChartGroupingTotalFunctionEnum
$chFunctionSum = 1
$chFunctionCount = 2
$chFunctionMin = 3
$chFunctionMax = 4
$chFunctionAvg = 5
$chFunctionDefault = 6

; PivotHAlignmentEnum
$plHAlignAutomatic = 0
$plHAlignLeft = 1
$plHAlignCenter = 2
$plHAlignRight = 3

; PivotFieldGroupOnEnum
$plGroupOnEachValue = 0
$plGroupOnPrefixChars = 1
$plGroupOnYears = 2
$plGroupOnQtrs = 3
$plGroupOnMonths = 4
$plGroupOnWeeks = 5
$plGroupOnDays = 6
$plGroupOnHours = 7
$plGroupOnMinutes = 8
$plGroupOnSeconds = 9
$plGroupOnInterval = 10

; PivotFieldSortDirectionEnum
$plSortDirectionDefault = 0
$plSortDirectionAscending = 1
$plSortDirectionDescending = 2
$plSortDirectionCustom = 4
$plSortDirectionCustomAscending = 5
$plSortDirectionCustomDescending = 6

; PivotFieldTypeEnum
$plTypeRegular = 1
$plTypeCalculated = 2
$plTypeTimeYears = 4
$plTypeTimeHalfYears = 5
$plTypeTimeQuarters = 6
$plTypeTimeMonths = 7
$plTypeTimeWeeks = 8
$plTypeTimeDays = 9
$plTypeTimeHours = 10
$plTypeTimeMinutes = 11
$plTypeTimeSeconds = 12
$plTypeTimeUndefined = 13
$plTypeUnknown = 14
$plTypeUserDefined = 15
$plTypeTimeWeekdays = 16
$plTypeCustomGroup = 17

; PivotFieldFilterFunctionEnum
$plFilterFunctionNone = 0
$plFilterFunctionTopCount = 3
$plFilterFunctionBottomCount = 4
$plFilterFunctionTopPercent = 5
$plFilterFunctionBottomPercent = 6
$plFilterFunctionTopSum = 7
$plFilterFunctionBottomSum = 8

; PivotTotalFunctionEnum
$plFunctionUnknown = 0
$plFunctionSum = 1
$plFunctionCount = 2
$plFunctionMin = 3
$plFunctionMax = 4
$plFunctionAverage = 5
$plFunctionStdDev = 6
$plFunctionVar = 7
$plFunctionStdDevP = 10
$plFunctionVarP = 11
$plFunctionCalculated = 127

; PivotTotalTypeEnum
$plTotalTypeIntrinsic = 1
$plTotalTypeUserDefined = 2
$plTotalTypeCalculated = 3

; PivotShowAsEnum
$plShowAsNormal = 0
$plShowAsPercentOfRowTotal = 1
$plShowAsPercentOfColumnTotal = 2
$plShowAsPercentOfRowParent = 3
$plShowAsPercentOfColumnParent = 4
$plShowAsPercentOfGrandTotal = 5

; PivotMemberPropertyDisplayEnum
$plDisplayPropertyNone = 0
$plDisplayPropertyInReport = 1
$plDisplayPropertyInScreenTip = 2
$plDisplayPropertyInAll = 3

; PivotMemberFindFormatEnum
$plFindFormatMember = 0
$plFindFormatPathName = 1
$plFindFormatPathInt = 2
$plFindFormatPathHex = 3

; PivotMemberCustomGroupTypeEnum
$plGroupTypeRegular = 1
$plGroupTypeCustomGroup = 2
$plGroupTypeFallThrough = 3
$plGroupTypePlaceHolder = 4
$plGroupTypeStaticOther = 5
$plGroupTypeDynamicOther = 6

; PivotFieldSetOrientationEnum
$plOrientationNone = 0
$plOrientationColumnAxis = 1
$plOrientationRowAxis = 2
$plOrientationFilterAxis = 4
$plOrientationDataAxis = 8
$plOrientationPageAxis = 16

; PivotFieldSetTypeEnum
$plFieldSetTypeTime = 1
$plFieldSetTypeOther = 2
$plFieldSetTypeUnknown = 3
$plFieldSetTypeUserDefined = 4

; PivotMembersCompareByEnum
$plMembersCompareByUniqueName = 0
$plMembersCompareByName = 1

; PivotFilterUpdateMemberStateEnum
$plMemberStateClear = 1
$plMemberStateChecked = 2
$plMemberStateGray = 3

; PivotFieldSetAllIncludeExcludeEnum
$plAllDefault = 0
$plAllInclude = 1
$plAllExclude = 2

; PivotViewTotalOrientationEnum
$plTotalOrientationRow = 1
$plTotalOrientationColumn = 2

; PivotTableExpandEnum
$plExpandAutomatic = 0
$plExpandAlways = 1
$plExpandNever = 2

; PivotExportActionEnum
$plExportActionNone = 0
$plExportActionOpenInExcel = 1

; ProviderType
$providerTypeUnknown = 1
$providerTypeRelational = 2
$providerTypeMultidimensional = 3

; PivotTableMemberExpandEnum
$plMemberExpandAutomatic = 0
$plMemberExpandAlways = 1
$plMemberExpandNever = 2

; PivotScrollTypeEnum
$plScrollTypeNone = 0
$plScrollTypeTop = 1
$plScrollTypeLeft = 2
$plScrollTypeBottom = 4
$plScrollTypeRight = 8
$plScrollTypeAll = 15

; PivotArrowModeEnum
$plArrowModeAccept = 0
$plArrowModeEdit = 1

; PivotCaretPositionEnum
$plCaretPositionAtEnd = 0
$plCaretPositionAtMouse = 1

; PivotEditModeEnum
$plEditNone = 0
$plEditInProgress = 1

; ChartLegendPositionEnum
$chLegendPositionAutomatic = 0
$chLegendPositionTop = 1
$chLegendPositionBottom = 2
$chLegendPositionLeft = 3
$chLegendPositionRight = 4

; ChartProjectionModeEnum
$chProjectionModePerspective = 0
$chProjectionModeOrthographic = 1

; ChartDataLabelPositionEnum
$chLabelPositionAutomatic = 0
$chLabelPositionCenter = 1
$chLabelPositionInsideEnd = 2
$chLabelPositionInsideBase = 3
$chLabelPositionOutsideEnd = 4
$chLabelPositionOutsideBase = 5
$chLabelPositionLeft = 6
$chLabelPositionRight = 7
$chLabelPositionTop = 8
$chLabelPositionBottom = 9

; ChartDimensionsEnum
$chDimSeriesNames = 0
$chDimCategories = 1
$chDimValues = 2
$chDimYValues = 3
$chDimXValues = 4
$chDimOpenValues = 5
$chDimCloseValues = 6
$chDimHighValues = 7
$chDimLowValues = 8
$chDimBubbleValues = 9
$chDimRValues = 10
$chDimThetaValues = 11
$chDimFilter = 14
$chDimCharts = 15
$chDimFormatValues = 16

; ChartSelectMode
$chSelectModeReplace = 0
$chSelectModeAdd = 1
$chSelectModeRemove = 2
$chSelectModeToggle = 3

; ChartEndStyleEnum
$chEndStyleNone = 1
$chEndStyleCap = 2

; ChartErrorBarDirectionEnum
$chErrorBarDirectionY = 0
$chErrorBarDirectionX = 1

; ChartErrorBarIncludeEnum
$chErrorBarIncludePlusValues = 0
$chErrorBarIncludeMinusValues = 1
$chErrorBarIncludeBoth = 2

; ChartErrorBarTypeEnum
$chErrorBarTypeFixedValue = 0
$chErrorBarTypePercent = 1
$chErrorBarTypeCustom = 2

; ChartErrorBarCustomValuesEnum
$chErrorBarPlusValues = 12
$chErrorBarMinusValues = 13

; ChartMarkerStyleEnum
$chMarkerStyleNone = 0
$chMarkerStyleSquare = 1
$chMarkerStyleDiamond = 2
$chMarkerStyleTriangle = 3
$chMarkerStyleX = 4
$chMarkerStyleStar = 5
$chMarkerStyleDot = 6
$chMarkerStyleDash = 7
$chMarkerStyleCircle = 8
$chMarkerStylePlus = 9

; ChartTrendlineTypeEnum
$chTrendlineTypeExponential = 0
$chTrendlineTypeLinear = 1
$chTrendlineTypeLogarithmic = 2
$chTrendlineTypePolynomial = 3
$chTrendlineTypePower = 4
$chTrendlineTypeMovingAverage = 5

; ChartChartTypeEnum
$chChartTypeCombo3D = -2
$chChartTypeCombo = -1
$chChartTypeColumnClustered = 0
$chChartTypeColumnStacked = 1
$chChartTypeColumnStacked100 = 2
$chChartTypeBarClustered = 3
$chChartTypeBarStacked = 4
$chChartTypeBarStacked100 = 5
$chChartTypeLine = 6
$chChartTypeLineMarkers = 7
$chChartTypeLineStacked = 8
$chChartTypeLineStackedMarkers = 9
$chChartTypeLineStacked100 = 10
$chChartTypeLineStacked100Markers = 11
$chChartTypeSmoothLine = 12
$chChartTypeSmoothLineMarkers = 13
$chChartTypeSmoothLineStacked = 14
$chChartTypeSmoothLineStackedMarkers = 15
$chChartTypeSmoothLineStacked100 = 16
$chChartTypeSmoothLineStacked100Markers = 17
$chChartTypePie = 18
$chChartTypePieExploded = 19
$chChartTypePieStacked = 20
$chChartTypeScatterMarkers = 21
$chChartTypeScatterSmoothLineMarkers = 22
$chChartTypeScatterSmoothLine = 23
$chChartTypeScatterLineMarkers = 24
$chChartTypeScatterLine = 25
$chChartTypeScatterLineFilled = 26
$chChartTypeBubble = 27
$chChartTypeBubbleLine = 28
$chChartTypeArea = 29
$chChartTypeAreaStacked = 30
$chChartTypeAreaStacked100 = 31
$chChartTypeDoughnut = 32
$chChartTypeDoughnutExploded = 33
$chChartTypeRadarLine = 34
$chChartTypeRadarLineMarkers = 35
$chChartTypeRadarLineFilled = 36
$chChartTypeRadarSmoothLine = 37
$chChartTypeRadarSmoothLineMarkers = 38
$chChartTypeStockHLC = 39
$chChartTypeStockOHLC = 40
$chChartTypePolarMarkers = 41
$chChartTypePolarLine = 42
$chChartTypePolarLineMarkers = 43
$chChartTypePolarSmoothLine = 44
$chChartTypePolarSmoothLineMarkers = 45
$chChartTypeColumn3D = 46
$chChartTypeColumnClustered3D = 47
$chChartTypeColumnStacked3D = 48
$chChartTypeColumnStacked1003D = 49
$chChartTypeBar3D = 50
$chChartTypeBarClustered3D = 51
$chChartTypeBarStacked3D = 52
$chChartTypeBarStacked1003D = 53
$chChartTypeLine3D = 54
$chChartTypeLineOverlapped3D = 55
$chChartTypeLineStacked3D = 56
$chChartTypeLineStacked1003D = 57
$chChartTypePie3D = 58
$chChartTypePieExploded3D = 59
$chChartTypeArea3D = 60
$chChartTypeAreaOverlapped3D = 61
$chChartTypeAreaStacked3D = 62
$chChartTypeAreaStacked1003D = 63

; ChartDataPointEnum
$chDataPointFirst = 0
$chDataPointLast = 1

; ChartBoundaryValueTypeEnum
$chBoundaryValuePercent = 0
$chBoundaryValueAbsolute = 1

; ChartSizeRepresentsEnum
$chSizeIsWidth = 0
$chSizeIsArea = 1

; ChartDataSourceTypeEnum
$chDataSourceTypeUnknown = 0
$chDataSourceTypeSpreadsheet = 1
$chDataSourceTypePivotTable = 3
$chDataSourceTypeQuery = 4
$chDataSourceTypeDSC = 5

; ChartSelectionMarksEnum
$chSelectionMarksNone = 0
$chSelectionMarksAll = 1
$chSelectionMarksPivot = 2

; ChartPlotAggregatesEnum
$chPlotAggregatesNone = 0
$chPlotAggregatesSeries = 1
$chPlotAggregatesCategories = 2
$chPlotAggregatesCharts = 3
$chPlotAggregatesFromTotalOrientation = 4

; ChartDropZonesEnum
$chDropZoneFilter = 0
$chDropZoneSeries = 1
$chDropZoneCategories = 2
$chDropZoneData = 3
$chDropZoneCharts = 4

; XlSearchDirection
$xlNext = 1
$xlPrevious = 2

; XlSortOrder
$xlAscending = 1
$xlDescending = 2

; XlYesNoGuess
$xlGuess = 0
$xlYes = 1
$xlNo = 2

; SheetExportActionEnum
$ssExportActionNone = 0
$ssExportActionOpenInExcel = 1

; SheetExportFormat
$ssExportAsAppropriate = 0
$ssExportXMLSpreadsheet = 1
$ssExportHTML = 2

; SheetFilterFunction
$ssFilterFunctionInclude = 1
$ssFilterFunctionExclude = 2

; XlSheetVisibility
$xlSheetVisible = -1
$xlSheetHidden = 0
$xlSheetVeryHidden = 2

; XlCalculation
$xlCalculationAutomatic = -4105
$xlCalculationManual = -4135

; XlBordersIndex
$xlEdgeLeft = 7
$xlEdgeTop = 8
$xlEdgeBottom = 9
$xlEdgeRight = 10
$xlInsideVertical = 11
$xlInsideHorizontal = 12

; XlReadingOrder
$xlContext = -5002
$xlLTR = -5003
$xlRTL = -5004

; TipTypeEnum
$eTipTypeNone = -1
$eTipTypeText = 0
$eTipTypeHTML = 1
$eTipTypeAuto = 2

; LineStyleEnum
$owcLineStyleNone = 0
$owcLineStyleAutomatic = 1
$owcLineStyleSolid = 2
$owcLineStyleDash = 3
$owcLineStyleDot = 4
$owcLineStyleDashDot = 5
$owcLineStyleDashDotDot = 6

; ExpandBitmapTypeEnum
$ecBitmapPlusMinus = 0
$ecBitmapUpDownArrow = 1
$ecBitmapOpenCloseFolder = 2

; DscFieldTypeEnum
$dscParameter = -1
$dscOutput = 1
$dscCalculated = 2
$dscGrouping = 3

; DscTotalTypeEnum
$dscNone = 0
$dscSum = 1
$dscAvg = 2
$dscMin = 3
$dscMax = 4
$dscCount = 5
$dscAny = 6
$dscStdev = 7

; DscGroupOnEnum
$dscEachValue = 0
$dscPrefix = 1
$dscYear = 2
$dscQuarter = 3
$dscMonth = 4
$dscWeek = 5
$dscDay = 6
$dscHour = 7
$dscMinute = 8
$dscInterval = 9

; DscJoinTypeEnum
$dscInnerJoin = 1
$dscLeftOuterJoin = 2
$dscRightOuterJoin = 3

; DscPageRelTypeEnum
$dscSublist = 1
$dscLookup = 2

; DscObjectTypeEnum
$dscobjUnknown = -1
$dscobjSchemaRowsource = 1
$dscobjSchemaField = 2
$dscobjSchemaRelationship = 4
$dscobjRecordsetDef = 8
$dscobjPageRowsource = 16
$dscobjPageField = 32
$dscobjSublistRelationship = 64
$dscobjLookupRelationship = 128
$dscobjGroupingDef = 256
$dscobjDatamodel = 512
$dscobjPageRelatedField = 1024
$dscobjParameterValue = 2048
$dscobjSchemaRelatedField = 4096
$dscobjSchemaParameter = 8192
$dscobjSchemaProperty = 16384
$dscobjSchemaDiagram = 32768

; NavButtonEnum
$navbtnMoveFirst = 0
$navbtnMovePrev = 1
$navbtnMoveNext = 2
$navbtnMoveLast = 3
$navbtnNew = 4
$navbtnDelete = 5
$navbtnSave = 6
$navbtnUndo = 7
$navbtnSortAscending = 8
$navbtnSortDescending = 9
$navbtnApplyFilter = 10
$navbtnToggleFilter = 11
$navbtnHelp = 12

; DscDropTypeEnum
$dscDefault = 0
$dscGrid = 1
$dscFields = 2

; DscDropLocationEnum
$dscAbove = 1
$dscWithin = 2
$dscBelow = 3

; DscHyperlinkPartEnum
$dschlDisplayedValue = 0
$dschlDisplayText = 1
$dschlAddress = 2
$dschlSubAddress = 3
$dschlScreenTip = 4
$dschlFullAddress = 5

; DscLocationEnum
$dscSystem = -1
$dscClient = 0
$dscServer = 1

; DscRecordsetTypeEnum
$dscSnapshot = 1
$dscUpdatableSnapshot = 2

; DscRowsourceTypeEnum
$dscTable = 1
$dscView = 2
$dscCommandText = 3
$dscProcedure = 4
$dscCommandFile = 5
$dscCommandDSP = 6

; DscFetchTypeEnum
$dscFull = 1
$dscParameterized = 2
$dscSelectControl = 32768

; DscAdviseTypeEnum
$dscAdd = 1
$dscDelete = 2
$dscMove = 3
$dscLoad = 4
$dscChange = 5
$dscDeleteComplete = 6
$dscRename = 7

; OCCommandId
$ocCommandAbout = 1007
$ocCommandUndo = 1000
$ocCommandCut = 1001
$ocCommandCopy = 1002
$ocCommandPaste = 1003
$ocCommandProperties = 1005
$ocCommandHelp = 1006
$ocCommandExport = 1004
$ocCommandSortAsc = 2000
$ocCommandSortDesc = 2031
$ocCommandChooser = 1010
$ocCommandAutoFilter = 1017
$ocCommandAutoCalc = 1016
$ocCommandCollapse = 1013
$ocCommandExpand = 1012
$ocCommandRefresh = 1014

; XlApplicationInternational
$xl24HourClock = 33
$xl4DigitYears = 43
$xlAlternateArraySeparator = 16
$xlColumnSeparator = 14
$xlCountryCode = 1
$xlCountrySetting = 2
$xlCurrencyBefore = 37
$xlCurrencyCode = 25
$xlCurrencyDigits = 27
$xlCurrencyLeadingZeros = 40
$xlCurrencyMinusSign = 38
$xlCurrencyNegative = 28
$xlCurrencySpaceBefore = 36
$xlCurrencyTrailingZeros = 39
$xlDateOrder = 32
$xlDateSeparator = 17
$xlDayCode = 21
$xlDayLeadingZero = 42
$xlDecimalSeparator = 3
$xlGeneralFormatName = 26
$xlHourCode = 22
$xlLeftBrace = 12
$xlLeftBracket = 10
$xlListSeparator = 5
$xlLowerCaseColumnLetter = 9
$xlLowerCaseRowLetter = 8
$xlMDY = 44
$xlMetric = 35
$xlMinuteCode = 23
$xlMonthCode = 20
$xlMonthLeadingZero = 41
$xlMonthNameChars = 30
$xlNoncurrencyDigits = 29
$xlNonEnglishFunctions = 34
$xlRightBrace = 13
$xlRightBracket = 11
$xlRowSeparator = 15
$xlSecondCode = 24
$xlThousandsSeparator = 4
$xlTimeLeadingZero = 45
$xlTimeSeparator = 18
$xlUpperCaseColumnLetter = 7
$xlUpperCaseRowLetter = 6
$xlWeekdayNameChars = 31
$xlYearCode = 19

; FieldListRelationshipTypeEnum
$flrelNoRel = 0
$flrelOneToMany = 1
$flrelManyToOne = 2
$flrelOneToOnePrimaryPrimary = 4
$flrelOneToOnePrimaryForeign = 8
$flrelUniqueConstraint = 16
$flrelUniqueIndex = 32

; FieldListObjectTypeEnum
$flTables = 1
$flViews = 2
$flStoredProcedures = 4
$flCmdText = 8
$flSchemaDiagrams = 16
$flOLAPCube = 32
$flAll = 63

; DaAttrEnum
$daLength = 1
$daPrecision = 2
$daScale = 3

; SectTypeEnum
$sectTypeNone = 0
$sectTypeCaption = 1
$sectTypeHeader = 2
$sectTypeFooter = 3
$sectTypeRecNav = 4

; DscStatusEnum
$dscDeleteOK = 0
$dscDeleteCancel = 1
$dscDeleteUserCancel = 2

; DscDisplayAlert
$dscDataAlertContinue = 0
$dscDataAlertDisplay = 1

; DefaultControlTypeEnum
$ctlTypeTextBox = 0
$ctlTypeBoundSpan = 1
$ctlTypeBoundHTML = 1

; DataPageDesignerFlags
$designFlagDontDelete = 1
$designFlagDontCleanup = 2

; ExportableConnectStringEnum
$exportNone = 0
$exportForExcel = 1

; DscOfflineTypeEnum
$dscOfflineNone = 0
$dscOfflineMerge = 1
$dscOfflineXMLDataFile = 2

; DscXMLLocationEnum
$dscXMLEmbedded = 0
$dscXMLDataFile = 1

; DscSaveAsEnum
$dscSaveAsEmbeddedXML = 0
$dscSaveAsXMLDataFile = 1

; DscEncodingEnum
$dscUTF8 = 0
$dscUTF16 = 1

; NotificationType
$dscConnectionReset = 0
$dscDataReset = 1

; RefreshType
$dscRefreshConnection = 0
$dscRefreshData = 1

; SynchronizationStatus
$dscSynchronizing = 0
$dscSynchronizationDone = 1

; FieldListSelectRestriction
$flSRNone = 0
$flSRParent = 1
$flSRParentAndType = 2

; ChartFillStyleEnum
$chNone = -1
$chSolid = 0

; ChartColorIndexEnum
$chColorAutomatic = -1
$chColorNone = -2

; ChartDataGroupingFunctionEnum
$chDataGroupingFunctionMinimum = 0
$chDataGroupingFunctionMaximum = 1
$chDataGroupingFunctionSum = 2
$chDataGroupingFunctionAverage = 3

; ChartSeriesByEnum
$chSeriesByRows = 0
$chSeriesByColumns = 1

; ChartSpecialDataSourcesEnum
$chDataBound = 0
$chDataLiteral = -1
$chDataNone = -2
$chDataLinked = -3

; ChartPivotDataReferenceEnum
$chPivotColumns = -1
$chPivotRows = -2
$chPivotColAggregates = -3
$chPivotRowAggregates = -4

; Chart3DSurfaceEnum
$chSurfaceBackWall = 0
$chSurfaceSideWall = 1
$chSurfaceFloor = 2

; ChartLabelOrientationEnum
$chLabelOrientationAutomatic = 1000
$chLabelOrientationHorizontal = 0
$chLabelOrientationUpward = 90
$chLabelOrientationDownward = -90

; ChartCommandIdEnum
$chCommandCut = 1001
$chCommandDeleteSelection = 1011
$chCommandShowPropertyToolbox = 1005
$chCommandShowContextMenu = 6001
$chCommandUndo = 1000
$chCommandSelectPrevMinor = 6002
$chCommandSelectNextMinor = 6003
$chCommandSelectPrevMajor = 6004
$chCommandSelectNextMajor = 6005
$chCommandShowHelp = 1006
$chCommandShowAbout = 1007
$chCommandPassiveAlert = 6026
$chCommandLaunchDataFinder = 6027
$chCommandShowLegend = 6028
$chCommandRefresh = 1014
$chCommandByRowCol = 6032
$chCommandSortAscending = 2000
$chCommandSortDescending = 2031
$chCommandAutoFilter = 1017
$chCommandAutoCalc = 1016
$chCommandExpand = 1012
$chCommandCollapse = 1013
$chCommandDrill = 6034
$chCommandFieldList = 1010
$chCommandFilterByMenu = 1015
$chCommandSortAscendingByTotal = 6035
$chCommandSortDescendingByTotal = 6036
$chCommandDrillOut = 6037
$chCommandTogglePropertiesInScreenTip = 6038
$chCommandChartType = 6039
$chCommandShowWizard = 6040
$chCommandSum = 6041
$chCommandCount = 6042
$chCommandMin = 6043
$chCommandMax = 6044
$chCommandAverage = 6045
$chCommandStdDev = 6046
$chCommandVar = 6047
$chCommandStdDevP = 6048
$chCommandVarP = 6049
$chCommandFontName = 1050
$chCommandFontSize = 1051
$chCommandBold = 1052
$chCommandItalic = 1053
$chCommandUnderline = 1054
$chCommandLineColor = 1055
$chCommandInteriorColor = 1056
$chCommandFontColor = 1057
$chCommandMultiChart = 6050
$chCommandUnifiedScales = 6051
$chCommandShowDropZones = 6052
$chCommandShowToolbar = 6053
$chCommandShowTop1 = 1100
$chCommandShowTop2 = 1101
$chCommandShowTop5 = 1102
$chCommandShowTop10 = 1103
$chCommandShowTop25 = 1104
$chCommandShowTop1Percent = 1105
$chCommandShowTop2Percent = 1106
$chCommandShowTop5Percent = 1107
$chCommandShowTop10Percent = 1108
$chCommandShowTop25Percent = 1109
$chCommandShowBottom1 = 1110
$chCommandShowBottom2 = 1111
$chCommandShowBottom5 = 1112
$chCommandShowBottom10 = 1113
$chCommandShowBottom25 = 1114
$chCommandShowBottom1Percent = 1115
$chCommandShowBottom2Percent = 1116
$chCommandShowBottom5Percent = 1117
$chCommandShowBottom10Percent = 1118
$chCommandShowBottom25Percent = 1119
$chCommandShowOther = 1120
$chCommandShowAll = 1121
$chCommandShowTopNMenu = 1123
$chCommandShowBottomNMenu = 1124
$chCommandConditionalFilter = 1125
$chCommandMoveToFilterArea = 6054
$chCommandMoveToSeriesArea = 6055
$chCommandMoveToCategoryArea = 6056
$chCommandMoveToChartArea = 6057

; BindingLoadMode
$Normal = 0
$OM = 1
$Delay = 2

; SpreadSheetCommandId
$ssCommandUndo = 1000
$ssCommandCut = 1001
$ssCommandCopy = 1002
$ssCommandPaste = 1003
$ssCommandExport = 1004
$ssCommandProperties = 1005
$ssCommandHelp = 1006
$ssCommandAbout = 1007
$ssCommandSortAsc = 2000
$ssCommandSortAscLast = 2030
$ssCommandSortDesc = 2031
$ssCommandSortDescLast = 2061
$ssCommandAutosum = 10000
$ssCommandAutoFilter = 10001
$ssCommandClear = 10002
$ssCommandBold = 1052
$ssCommandItalic = 1053
$ssCommandUnderline = 1054
$ssCommandDeleteRows = 10006
$ssCommandDeleteCols = 10007
$ssCommandInsertRows = 10008
$ssCommandInsertCols = 10009
$ssCommandRecalcForce = 10010
$ssCommandSelectRow = 10011
$ssCommandSelectCol = 10012
$ssCommandSelectAll = 10013
$ssCommandMoveLeft = 10014
$ssCommandMoveUp = 10015
$ssCommandMoveRight = 10016
$ssCommandMoveDown = 10017
$ssCommandScrollLeft = 10018
$ssCommandScrollUp = 10019
$ssCommandScrollRight = 10020
$ssCommandScrollDown = 10021
$ssCommandMoveNext = 10022
$ssCommandMovePrevious = 10023
$ssCommandTabNext = 10024
$ssCommandTabPrevious = 10025
$ssCommandMoveToEndLeft = 10026
$ssCommandMoveToEndUp = 10027
$ssCommandMoveToEndRight = 10028
$ssCommandMoveToEndDown = 10029
$ssCommandExpandLeft = 10030
$ssCommandExpandUp = 10031
$ssCommandExpandRight = 10032
$ssCommandExpandDown = 10033
$ssCommandExpandToEndLeft = 10034
$ssCommandExpandToEndUp = 10035
$ssCommandExpandToEndRight = 10036
$ssCommandExpandToEndDown = 10037
$ssCommandEnterEditMode = 10038
$ssCommandShowContextMenu = 10039
$ssCommandToggleToolbar = 10040
$ssCommandEscape = 10041
$ssCommandMoveToLast = 10042
$ssCommandExpandToLast = 10043
$ssCommandMoveToLastInRow = 10044
$ssCommandMovePageDown = 10045
$ssCommandExpandPageDown = 10046
$ssCommandMovePageUp = 10047
$ssCommandExpandPageUp = 10048
$ssCommandMovePageRight = 10062
$ssCommandExpandPageRight = 10063
$ssCommandMovePageLeft = 10064
$ssCommandExpandPageLeft = 10065
$ssCommandMoveToOrigin = 10049
$ssCommandExpandToOrigin = 10050
$ssCommandMoveToHome = 10051
$ssCommandExpandToHome = 10052
$ssCommandExpandMenu = 10053
$ssCommandEat = 10054
$ssCommandNextSheet = 10055
$ssCommandPrevSheet = 10056
$ssCommandNewSheet = 10057
$ssCommandSelectArray = 10058
$ssCommandSelectArraySilent = 10067
$ssCommandRecalc = 10059
$ssCommandRefresh = 10060
$ssCommandRefreshAll = 10061
$ssCommandMakeActiveCellVisible = 10066
$ssCommandRefreshData = 10068
$ssCommandSaveData = 10069
$ssCommandEditQuery = 10070
$ssCommandDeleteQuery = 10071
$ssCommandSetChartRange = 10072
$ssCommandOpenHyperlink = 10073

; SheetCommandEnum
$ssCalculate = 0
$ssInsertRows = 2
$ssInsertColumns = 3
$ssDeleteRows = 4
$ssDeleteColumns = 5
$ssCut = 6
$ssCopy = 7
$ssPaste = 8
$ssExport = 9
$ssUndo = 10
$ssSortAscending = 11
$ssSortDescending = 12
$ssFind = 13
$ssClear = 14
$ssAutoFilter = 15
$ssProperties = 16
$ssHelp = 17

; XlConstants
$xlAutomatic = -4105
$xlNone = -4142

; XlLookAt
$xlPart = 2
$xlWhole = 1

; XlSearchOrder
$xlByColumns = 2
$xlByRows = 1

; AddinClientTypeEnum
$ssCoerceNum = 1
$ssCoerceStr = 2
$ssCoerceBool = 4
$ssCoerceErr = 16
$ssCoerceMulti = 64
$ssCoerceInt = 2048

; PivotViewReasonEnum
$plViewReasonSelectionChange = 0
$plViewReasonSystemColorChange = 1
$plViewReasonDataChange = 2
$plViewReasonFontNameChange = 3
$plViewReasonFontSizeChange = 4
$plViewReasonFontBoldChange = 5
$plViewReasonFontItalicChange = 6
$plViewReasonFontUnderlineChange = 7
$plViewReasonMemberExpandedChange = 8
$plViewReasonCellExpandedChange = 9
$plViewReasonDetailRowHeightChange = 10
$plViewReasonFieldDetailWidthChange = 11
$plViewReasonFieldGroupedWidthChange = 12
$plViewReasonViewDetailWidthChange = 13
$plViewReasonFieldSetWidthChange = 14
$plViewReasonTotalWidthChange = 15
$plViewReasonForeColorChange = 16
$plViewReasonBackColorChange = 17
$plViewReasonAlignmentChange = 18
$plViewReasonNumberFormatChange = 19
$plViewReasonDetailTopChange = 20
$plViewReasonDetailLeftChange = 21
$plViewReasonTopChange = 22
$plViewReasonLeftChange = 23
$plViewReasonRightToLeftChange = 24
$plViewReasonTotalOrientationChange = 25
$plViewReasonDisplayOutlineChange = 26
$plViewReasonFieldCaptionChange = 27
$plViewReasonFieldSetCaptionChange = 28
$plViewReasonLabelCaptionChange = 29
$plViewReasonMemberCaptionChange = 30
$plViewReasonTotalCaptionChange = 31
$plViewReasonAllowFilteringChange = 32
$plViewReasonAllowGroupingChange = 33
$plViewReasonWidthChange = 34
$plViewReasonHeightChange = 35
$plViewReasonLabelVisibleChange = 36
$plViewReasonDisplayToolbarChange = 37
$plViewReasonMaxHeightChange = 38
$plViewReasonMaxWidthChange = 39
$plViewReasonAutoFitChange = 40
$plViewReasonFieldExpandedChange = 41
$plViewReasonExpandDetailsChange = 42
$plViewReasonDetailMaxWidthChange = 43
$plViewReasonDetailMaxHeightChange = 44
$plViewReasonTopOffsetChange = 45
$plViewReasonLeftOffsetChange = 46
$plViewReasonDetailTopOffsetChange = 47
$plViewReasonDetailLeftOffsetChange = 48
$plViewReasonIsHyperlinkChange = 49
$plViewReasonMemberPropertyDisplayInChange = 50
$plViewReasonMemberPropertyCaptionChange = 51
$plViewReasonMemberPropertiesOrderChange = 52
$plViewReasonFieldGroupedHeightChange = 53
$plViewReasonMemberHeightChange = 54
$plViewReasonMemberWidthChange = 55
$plViewReasonPropertyValueWidthChange = 56
$plViewReasonPropertyHeightChange = 57
$plViewReasonShowDetails = 58
$plViewReasonHideDetails = 59
$plViewReasonAllowCustomOrderingChange = 60
$plViewReasonAllowPropertyToolbox = 61
$plViewReasonExpandMembersChange = 62
$plViewReasonAllowEditsChange = 63
$plViewReasonAllowAdditionsChange = 64
$plViewReasonAllowDeletionsChange = 65
$plViewReasonSetFocus = 66
$plViewReasonKillFocus = 67
$plViewReasonDisplayScreenTipsChange = 68
$plViewReasonShowAsChange = 69
$plViewReasonMemberCaptionsChange = 70
$plViewReasonPropertyCaptionWidthChange = 71
$plViewReasonDataMemberCaptionChange = 72
$plViewReasonDisplayInFieldListChange = 73
$plViewReasonToolbarChange = 74
$plViewReasonUseProviderFormattingChange = 75
$plViewReasonXMLApplied = 76
$plViewReasonBeginUnfreezing = 77
$plViewReasonEndUnfreezing = 78

; PivotDataReasonEnum
$plDataReasonInsertFieldSet = 0
$plDataReasonRemoveFieldSet = 1
$plDataReasonInsertTotal = 2
$plDataReasonRemoveTotal = 3
$plDataReasonAllowDetailsChange = 4
$plDataReasonSortDirectionChange = 5
$plDataReasonSortOnChange = 6
$plDataReasonSortOnScopeChange = 7
$plDataReasonFilterFunctionChange = 8
$plDataReasonFilterContextChange = 9
$plDataReasonDisplayCalculatedMembersChange = 10
$plDataReasonFilterOnChange = 11
$plDataReasonFilterOnScopeChange = 12
$plDataReasonFilterFunctionValueChange = 13
$plDataReasonTotalNameChange = 14
$plDataReasonIncludedMembersChange = 15
$plDataReasonExcludedMembersChange = 16
$plDataReasonIsIncludedChange = 17
$plDataReasonDisplayEmptyMembersChange = 19
$plDataReasonTotalFunctionChange = 20
$plDataReasonUser = 21
$plDataReasonDataSourceChange = 22
$plDataReasonDataMemberChange = 23
$plDataReasonGroupOnChange = 24
$plDataReasonUnknown = 25
$plDataReasonGroupStartChange = 26
$plDataReasonGroupIntervalChange = 27
$plDataReasonIsFilteredChange = 28
$plDataReasonOrderedMembersChange = 29
$plDataReasonGroupEndChange = 30
$plDataReasonCommandTextChange = 31
$plDataReasonConnectionStringChange = 32
$plDataReasonMemberPropertyIsIncludedChange = 33
$plDataReasonMemberPropertyDisplayInChange = 34
$plDataReasonSubtotalsChange = 35
$plDataReasonTotalExpressionChange = 36
$plDataReasonTotalSolveOrderChange = 37
$plDataReasonTotalDeleted = 38
$plDataReasonFieldSetDeleted = 39
$plDataReasonRecordChanged = 40
$plDataReasonAllowMultiFilterChange = 41
$plDataReasonAllIncludeExcludeChange = 42
$plDataReasonAdhocFieldAdded = 43
$plDataReasonAdhocFieldDeleted = 44
$plDataReasonAdhocMemberChanged = 45
$plDataReasonAlwaysIncludeInCubeChange = 46
$plDataReasonExpressionChange = 47
$plDataReasonTotalAllMembersChange = 48
$plDataReasonDisplayCellColorChange = 49
$plDataReasonFilterCrossJoinsChange = 50
$plDataReasonRefreshDataSource = 51
$plDataReasonFieldSetNameChange = 52
$plDataReasonFieldNameChange = 53

; PivotTableReasonEnum
$plPivotTableReasonTotalAdded = 0
$plPivotTableReasonTotalDeleted = 1
$plPivotTableReasonFieldSetAdded = 2
$plPivotTableReasonFieldAdded = 3

; PivotCommandId
$plCommandAbout = 1007
$plCommandDelete = 1011
$plCommandFilterBySel = 12001
$plCommandChooser = 1010
$plCommandProperties = 1005
$plCommandInsertField = 12004
$plCommandAutoSum = 12005
$plCommandAutoCount = 12006
$plCommandAutoMin = 12007
$plCommandAutoMax = 12008
$plCommandDropzones = 12009
$plCommandRemove = 12010
$plCommandNextHorz = 12012
$plCommandNextVert = 12013
$plCommandLeftEdge = 12014
$plCommandRightEdge = 12015
$plCommandTopLeftEdge = 12016
$plCommandBottomRightEdge = 12017
$plCommandNextHorzCell = 12018
$plCommandPrevHorzCell = 12019
$plCommandLastLeft = 12020
$plCommandLastRight = 12021
$plCommandLastUp = 12022
$plCommandLastDown = 12023
$plCommandEnterDetails = 12024
$plCommandExitDetails = 12025
$plCommandLeft = 12026
$plCommandRight = 12027
$plCommandUp = 12028
$plCommandDown = 12029
$plCommandPageUp = 12030
$plCommandPageDown = 12031
$plCommandPageLeft = 12032
$plCommandPageRight = 12033
$plCommandGroupByRow = 12034
$plCommandGroupByColumn = 12035
$plCommandUngroup = 12036
$plCommandFilter = 12037
$plCommandPromote = 12038
$plCommandDemote = 12039
$plCommandExpand = 1012
$plCommandCollapse = 1013
$plCommandSubtotal = 12042
$plCommandExport = 1004
$plCommandToolbar = 12044
$plCommandSortAsc = 2000
$plCommandSortDesc = 2031
$plCommandClearCustomOrdering = 12154
$plCommandHelp = 1006
$plCommandRefresh = 1014
$plCommandAutoFilter = 1017
$plCommandCopy = 1002
$plCommandExpandIndicator = 12051
$plCommandSelectField = 12052
$plCommandSelectRow = 12053
$plCommandSelectAll = 12054
$plCommandFormatGeneral = 12055
$plCommandFormatCurrency = 12056
$plCommandFormatPercent = 12057
$plCommandFormatExponent = 12058
$plCommandFormatDate = 12059
$plCommandFormatTime = 12060
$plCommandFormatComma = 12061
$plCommandFormatBold = 12062
$plCommandFormatItalic = 12063
$plCommandFormatUnderline = 12064
$plCommandFormatUnderline2 = 12146
$plCommandFilterByMenu = 12065
$plCommandContextMenu = 12066
$plCommandPrevHorz = 12067
$plCommandPrevVert = 12068
$plCommandNextVertCell = 12069
$plCommandPrevVertCell = 12070
$plCommandExtendLeft = 12072
$plCommandExtendRight = 12073
$plCommandExtendUp = 12074
$plCommandExtendDown = 12075
$plCommandExtendPageLeft = 12076
$plCommandExtendPageRight = 12077
$plCommandExtendPageUp = 12078
$plCommandExtendPageDown = 12079
$plCommandHyperlink = 12082
$plCommandOpenHyperlinkInPlace = 12083
$plCommandOpenHyperlinkInWindow = 12084
$plCommandMoveMemUp = 12085
$plCommandMoveMemDown = 12086
$plCommandMoveMemLeft = 12087
$plCommandMoveMemRight = 12088
$plCommandAutoAverage = 12089
$plCommandAutoStdDev = 12090
$plCommandAutoVar = 12091
$plCommandAutoStdDevP = 12092
$plCommandAutoVarP = 12093
$plCommandShowDetails = 12095
$plCommandHideDetails = 12096
$plCommandTogglePropertiesInReport = 12097
$plCommandTogglePropertiesInScreenTip = 12098
$plCommandStartEdit = 12099
$plCommandEndEdit = 12100
$plCommandDeleteRow = 12101
$plCommandCreateCalculatedTotal = 12102
$plCommandPaste = 1003
$plCommandExtendTopLeftEdge = 12107
$plCommandExtendBottomRightEdge = 12108
$plCommandTogglePropertyInReport = 12900
$plCommandTogglePropertyInScreenTip = 12950
$plCommandAutoCalc = 1016
$plCommandCalculated = 12110
$plCommandShowTop1 = 1100
$plCommandShowTop2 = 1101
$plCommandShowTop5 = 1102
$plCommandShowTop10 = 1103
$plCommandShowTop25 = 1104
$plCommandShowTop1Percent = 1105
$plCommandShowTop2Percent = 1106
$plCommandShowTop5Percent = 1107
$plCommandShowTop10Percent = 1108
$plCommandShowTop25Percent = 1109
$plCommandShowBottom1 = 1110
$plCommandShowBottom2 = 1111
$plCommandShowBottom5 = 1112
$plCommandShowBottom10 = 1113
$plCommandShowBottom25 = 1114
$plCommandShowBottom1Percent = 1115
$plCommandShowBottom2Percent = 1116
$plCommandShowBottom5Percent = 1117
$plCommandShowBottom10Percent = 1118
$plCommandShowBottom25Percent = 1119
$plCommandShowOther = 1120
$plCommandShowAll = 1121
$plCommandShowTopNMenu = 1123
$plCommandShowBottomNMenu = 1124
$plCommandConditionalFilter = 1125
$plCommandShowAs = 12134
$plCommandShowAsNormal = 12135
$plCommandShowAsPercentOfRowTotal = 12136
$plCommandShowAsPercentOfColumnTotal = 12137
$plCommandShowAsPercentOfRowParent = 12138
$plCommandShowAsPercentOfColumnParent = 12139
$plCommandShowAsPercentOfGrandTotal = 12140
$plCommandFormatAlignLeft = 12141
$plCommandFormatAlignCenter = 12142
$plCommandFormatAlignRight = 12143
$plCommandFormatAlignAutomatic = 12158
$plCommandFormatName = 12144
$plCommandFormatSize = 12145
$plCommandFormatForeColor = 12147
$plCommandFormatBackColor = 12148
$plCommandShowAllPropertiesInReport = 12149
$plCommandHideAllPropertiesInReport = 12150
$plCommandShowAllPropertiesInScreenTip = 12151
$plCommandHideAllPropertiesInScreenTip = 12152
$plCommandProfile = 12153
$plCommandGroupMembers = 12155
$plCommandUngroupMembers = 12156
$plCommandCut = 12157

;ColorNameList 
$ColorNameList  = StringSplit("lightpink,pink,crimson,lavenderblush,palevioletred,hotpink,deeppink,mediumvioletred,orchid,thistle,plum,violet,fuchsia,fuchsia,darkmagenta,purple,mediumorchid,darkviolet,darkorchid,indigo,blueviolet,mediumpurple,mediumslateblue,slateblue,darkslateblue,ghostwhite,lavender,blue,mediumblue,darkblue,navy,midnightblue,royalblue,cornflowerblue,lightsteelblue,lightslategray,slategray,dodgerblue,aliceblue,steelblue,lightskyblue,skyblue,deepskyblue,lightblue,powderblue,cadetblue,darkturquoise,azure,lightcyan,paleturquoise,aqua,aqua,darkcyan,teal,darkslategray,mediumturquoise,lightseagreen,turquoise,aquamarine,mediumaquamarine,mediumspringgreen,mintcream,springgreen,mediumseagreen,seagreen,honeydew,darkseagreen,palegreen,lightgreen,limegreen,lime,forestgreen,green,darkgreen,lawngreen,chartreuse,greenyellow,darkolivegreen,yellowgreen,olivedrab,ivory,beige,lightyellow,lightgoldenrodyellow,yellow,olive,darkkhaki,palegoldenrod,lemonchiffon,khaki,gold,cornsilk,goldenrod,darkgoldenrod,floralwhite,oldlace,wheat,orange,moccasin,papayawhip,blanchedalmond,navajowhite,antiquewhite,tan,burlywood,darkorange,bisque,linen,peru,peachpuff,sandybrown,chocolate,saddlebrown,seashell,sienna,lightsalmon,coral,orangered,darksalmon,tomato,salmon,mistyrose,lightcoral,snow,rosybrown,indianred,red,brown,firebrick,darkred,maroon,white,whitesmoke,gainsboro,lightgrey,silver,darkgray,gray,dimgray,black",",")
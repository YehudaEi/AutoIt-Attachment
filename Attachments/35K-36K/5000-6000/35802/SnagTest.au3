; ==========================================================================
;
; AutoIt3 Source File
;
; NAME: SnagTest.au3
;
; AUTHOR: Cynthia Pepper
; DATE  : 11/16/2011
;
; COMMENT: Adapted from vbscript file SnagTest.vbs found on
;          http://www.robvanderwoude.com/vbstech_automation_snagit.php
;          The script captures the desktop using TechSmith Snagit's COM server,
;          then saves the captured image to the C drive.
;          Tested using autoit3 version 3.3.6.1 and Snagit 10.0.1
;
; ==========================================================================

Opt("MustDeclareVars", 1)

Global $objSnagit

; Capture input type
Global Const $siiDesktop        =  0
Global Const $siiWindow         =  1
Global Const $siiRegion         =  4
Global Const $siiGraphicFile    =  6
Global Const $siiClipboard      =  7
Global Const $siiDOSScreen      =  8
Global Const $siiMenu           =  9
Global Const $siiObject         = 10
Global Const $siiProgramFile    = 11
Global Const $siiFreehand       = 12
Global Const $siiEllipse        = 13
Global Const $siiRoundedRect    = 14
Global Const $siiTriangle       = 15
Global Const $siiPolygon        = 16
Global Const $siiWallpaper      = 17
Global Const $siiCustomScroll   = 18
Global Const $siiTWAIN          = 19
Global Const $siiDirectX        = 20
Global Const $siiExtendedWindow = 23

; Window selection method
Global Const $swsmInteractive   =  0
Global Const $swsmActive        =  1
Global Const $swsmHandle        =  2
Global Const $swsmPoint         =  3

; Capture output type
Global Const $sioPrinter        =  1
Global Const $sioFile           =  2
Global Const $sioClipboard      =  4
Global Const $sioMail           =  8
Global Const $sioFTP            = 32

; Output image type
Global Const $siftBMP           =  0
Global Const $siftPCX           =  1
Global Const $siftTIFF          =  2
Global Const $siftJPEG          =  3
Global Const $siftGIF           =  4
Global Const $siftPNG           =  5
Global Const $siftTGA           =  6

; Output color depth
Global Const $sicdAuto          =  0
Global Const $sicd1Bit          =  1
Global Const $sicd2Bit          =  2
Global Const $sicd3Bit          =  3
Global Const $sicd4Bit          =  4
Global Const $sicd5Bit          =  5
Global Const $sicd6Bit          =  6
Global Const $sicd7Bit          =  7
Global Const $sicd8Bit          =  8
Global Const $sicd16Bit         = 16
Global Const $sicd24Bit         = 24
Global Const $sicd32Bit         = 32

; Output file naming method
Global Const $sofnmPrompt       =  0
Global Const $sofnmFixed        =  1
Global Const $sofnmAuto         =  2

Main()

Func Main()

    ; Create the Snagit object
    Dim $objSnagit = ObjCreate( "SNAGIT.ImageCapture.1" )

    ; Set input options
    $objSnagit.Input = $siiDesktop
    $objSnagit.IncludeCursor = "True"

    ; Set output options
	$objSnagit.Output = $sioFile
    $objSnagit.OutputImageFile.FileType = $siftPNG
    $objSnagit.OutputImageFile.ColorDepth = $sicd32Bit
    $objSnagit.OutputImageFile.FileNamingMethod = $sofnmFixed
    $objSnagit.OutputImageFile.Filename = "snagtestau3"
    $objSnagit.OutputImageFile.Directory = "C:\"

    ; Capture
	$objSnagit.Capture

    Do
        Sleep(10)
    Until $objSnagit.IsCaptureDone

EndFunc
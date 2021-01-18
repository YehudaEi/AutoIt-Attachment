; ----------------------------------------------------------------------------
;
; VBScript to AutoIt Converter v0.4
;
; ----------------------------------------------------------------------------

#include <bk-logfile.au3>

;************************************************
;
; DOC2PDF.VBS Microsoft Scripting Host Script (Requires Version 5.6 or newer)()
; --------------------------------------------------------------------------------
;
; Author: Michael Suodenjoki
; Created: 2007.07.07
;
; This script can create a PDF file from a Word document provided you;re using
; Word 2007 and have the ;Office Add-in: Save As PDF; installed.
;

; Constants
$onst $WdDoNotSaveChanges = 0

; see WdSaveFormat enumeration constants: 
; http://msdn2.microsoft.com/en-us/library/bb238158.aspx
Const $wdFormatPDF = 17  ; PDF format. 
Const $wdFormatXPS = 18  ; XPS format. 


; Global variables
Dim $arguments
 $arguments = $CmdLine

; ***********************************************
; ECHOLOGO()
;
; Outputs the logo information.
;
Func EchoLogo()
  If Not ($arguments.Named.Exists("nologo") Or $arguments.Named.Exists("n")) Then
    _WriteLog ("doc2pdf Version 2.0, Michael Suodenjoki 2007")
    _WriteLog ("==================================================")
    _WriteLog ("")
  EndIf
EndFunc

; ***********************************************
; ECHOUSAGE()
;
; Outputs the usage information.
;
Func EchoUsage()
  If $arguments.Count=0 Or $arguments.Named.Exists("help") Or _
    $arguments.Named.Exists("h") (_)
  Then
    _WriteLog ("Generates a PDF from a Word document file using Word 2007.")
    _WriteLog ("")
(    _WriteLog ("Usage: doc2pdf.vbs <options> <doc-file> [/o:<pdf-file>]"))
    _WriteLog ("")
    _WriteLog ("Available Options:")
    _WriteLog ("")
    _WriteLog (" /nologo - Specifies that the logo shouldn't be displayed")
    _WriteLog (" /help   - Specifies that this usage/help information " + _)
                 "should be displayed."
    _WriteLog (" /debug  - Specifies that debug output should be displayed.")
    _WriteLog ("")
    _WriteLog ("Parameters:")
    _WriteLog ("")
    _WriteLog (" /o:<pdf-file> Optionally specification of output file (PDF).")
    _WriteLog ("")
  EndIf 
EndFunc

; ***********************************************
; CHECKARGS()
;
; Makes some preliminary checks of the $arguments.
; Quits the application is any problem is found.
;
Func CheckArgs()
  ; Check that <doc-file> is specified
  If $arguments.Unnamed.Count <> 1 Then
    _WriteLog ("Error: Obligatory <doc-file> parameter missing!")
;VA     WScript.Quit 1
  EndIf

  $bShowDebug = $arguments.Named.Exists("debug") Or $arguments.Named.Exists("d")

EndFunc


; ***********************************************
; DOC2PDF()
;
; Converts a Word document to PDF using Word 2007.
;
; Input:
; $sDocFile - Full path to Word document.
; $sPDFFile - Optional full path to output file.
;
; If not specified the output PDF file
; will be the same as the $sDocFile except
; file extension will be .pdf.
;
Func DOC2PDF( $sDocFile, $sPDFFile )

  Dim $fso ; As FileSystemObject
  Dim $wdo ; As Word.Application
  Dim $wdoc ; As Word.Document
  Dim $wdocs ; As Word.Documents
  Dim $sPrevPrinter ; As String

   $fso = ObjCreate("Scripting.FileSystemObject")
   $wdo = ObjCreate("Word.Application")
   $wdocs = $wdo.Documents

  $sDocFile = $fso.GetAbsolutePathName($sDocFile)

  ; Debug outputs...
  If $bShowDebug Then
    _WriteLog ("Doc file = '" + $sDocFile + "'")
    _WriteLog ("PDF file = '" + $sPDFFile + "'")
  EndIf

  $sFolder = $fso.GetParentFolderName($sDocFile)

  If StringLen($sPDFFile)=0 Then
    $sPDFFile = $fso.GetBaseName($sDocFile) + ".pdf"
  EndIf

  If StringLen($fso.GetParentFolderName($sPDFFile))=0 Then
    $sPDFFile = $sFolder + "\" + $sPDFFile
  EndIf

  ; Open the Word document
   $wdoc = $wdocs.Open($sDocFile)

  ; Let Word document save as PDF
  ; - for documentation of SaveAs() method,
  ;   see http://msdn2.microsoft.com/en-us/library/bb221597.aspx 
  $wdoc.SaveAs ($sPDFFile, $wdFormatPDF)

  $wdoc.Close ($WdDoNotSaveChanges)
  $wdo.Quit ($WdDoNotSaveChanges)
;VA   Set $wdo = Nothing

;VA   Set $fso = Nothing

EndFunc

; *** MAIN **************************************

 EchoLogo()
 EchoUsage()
 CheckArgs()
 DOC2PDF( $arguments.Unnamed.Item(0), $arguments.Named.Item("o") )

;VA Set $arguments = Nothing

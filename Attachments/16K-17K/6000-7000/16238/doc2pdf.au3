; ----------------------------------------------------------------------------
;
; VBScript to AutoIt Converter v0.4
;
; ----------------------------------------------------------------------------

#include <File.au3>

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
Const $WdDoNotSaveChanges = 0

; see WdSaveFormat enumeration constants: 
; http://msdn2.microsoft.com/en-us/library/bb238158.aspx
Const $wdFormatPDF = 17  ; PDF format. 
Const $wdFormatXPS = 18  ; XPS format. 


; Global variables
Dim $arguments
 $arguments = $CmdLine

; ***********************************************
; CHECKARGS()
;
; Makes some preliminary checks of the $arguments.
; Quits the application is any problem is found.
;


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
  Dim $bShowDebug = false

   $fso = ObjCreate("Scripting.FileSystemObject")
   $wdo = ObjCreate("Word.Application")
   $wdocs = $wdo.Documents

  $sDocFile = $fso.GetAbsolutePathName($sDocFile)

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

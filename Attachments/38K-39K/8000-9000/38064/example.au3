#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=DocsCopy.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <Date.au3>
#include <File.au3>
#include <WindowsConstants.au3>
#include <Word.au3>
#include <Excel.au3>

;------------------------------------------------------
; Getting Customer Name for Directory Creation
;------------------------------------------------------

$Cust = InputBox ("Customer Name", "Customer Name")
$Location = InputBox ("Customer Location", "Customer Location")

;------------------------------------------------------
; Create Directory for Document Storage
; -----------------------------------------------------

DirCreate ("D:\Documents\" & $Cust)
$Doclocale = ("D:\Documents\" & $Cust)

;------------------------------------------------------
; Copy Engagement Docs
;------------------------------------------------------

FileCopy ("C:\ConsultDocs\*.*", $Doclocale)
FileMove ($DocLocale & "\Daily Status.xls", $DocLocale & "\" & $Cust & " Daily Status.xls")
FileMove ($DocLocale & "\Project Completion document.doc", $DocLocale & "\" & $Cust & " Project Completion document.doc")
FileMove ($DocLocale & "\Health Check.docx", $DocLocale & "\" & $Cust & " Health Check.docx")
FileMove ($DocLocale & "\Server Installation and Production Server Layout.docx", $DocLocale & "\" & $Cust & " Server Installation and Production Server Layout.docx")

;-------------------------------------------------------
; Gather project information
;-------------------------------------------------------
$oDStatus = ($DocLocale & "\" & $Cust & " Daily Status.xls")
$oProjDoc = ($DocLocale & "\" & $Cust & " Project Completion document.doc")
$oHlthDoc = ($DocLocale & "\" & $Cust & " Health Check.docx")
$oLayout = ($DocLocale & "\" & $Cust & " Server Installation and Production Server Layout.docx")
$oStartDate = Inputbox ("Start Date", "Start Date")
$oEndDate = InputBox ("End Date", "End Date")
$oConsultant = InputBox ("Consultant Name", "Consultant Name")
$oSOWDate = InputBox ("SOW Date", "SOW Date")

;--------------------------------------------------------
; Update Project Completion Document
;--------------------------------------------------------
$oWordApp = _WordCreate ($oProjDoc)
$oDoc = _WordDocGetCollection ($oWordApp, 0)
ConsoleWrite(@error & @CRLF)
_WordDocFindReplace( $oDoc, "RefStartDate", $oStartDate)
ConsoleWrite(@error & @CRLF)
_WordDocFindReplace( $oDoc, "RefEndDate", $oEndDate)
ConsoleWrite(@error & @CRLF)
_WordDocFindReplace( $oDoc, "RefConsultant", $oLDConsultant)
ConsoleWrite(@error & @CRLF)
_WordDocFindReplace( $oDoc, "RefSOWDate", $oSOWDate)
ConsoleWrite(@error & @CRLF)
_WordDocFindReplace( $oDoc, "RefCustomerName", $Cust)
_WordDocSave($oDoc)
_WordDocClose ($oDoc)
ConsoleWrite(@error & @CRLF)

;------------------------------------------------------------
; Update Health Check Document
;------------------------------------------------------------
$oWordApp1 = _WordCreate ($oHlthDoc)
$oDoc1 = _WordDocGetCollection ($oWordApp1, 0)
;$oWordApp = _WordCreate ($oProjDoc)
ConsoleWrite(@error & @CRLF)
$oDoc1 = _WordDocGetCollection ($oWordApp1, 0)
ConsoleWrite(@error & @CRLF)
_WordDocFindReplace( $oDoc1, "RefStartDate", $oStartDate)
ConsoleWrite(@error & @CRLF)
_WordDocFindReplace( $oDoc1, "RefEndDate", $oEndDate)
ConsoleWrite(@error & @CRLF)
_WordDocFindReplace( $oDoc1, "RefConsultant", $oLDConsultant)
ConsoleWrite(@error & @CRLF)
_WordDocFindReplace( $oDoc1, "RefSOWDate", $oSOWDate)
ConsoleWrite(@error & @CRLF)
_WordDocFindReplace( $oDoc1, "RefCustomerName", $Cust)
_WordDocFindReplace( $oDoc1, "refLocation", $Location)
_WordDocSave($oDoc1)
_WordDocClose ($oDoc1)
ConsoleWrite(@error & @CRLF)

;------------------------------------------------------------
; Update Daily Status Report
;------------------------------------------------------------
$rRowNum = "3H"
$oExcel = _ExcelBookOpen ($oDStatus)
_ExcelWriteCell ($oExcel, $oConsultant, 3, 8 )
_ExcelWriteCell ($oExcel, $Cust, 2, 8 )
_ExcelWriteCell ($oExcel, $oStartDate, 5, 8 )
_ExcelWriteCell ($oExcel, $oEndDate, 6, 8 )
_ExcelBookSave ($oExcel)
_ExcelBookClose ($oDStatus)
ConsoleWrite(@error & @CRLF)

;---------------------------------------------------------------------
; Update LANDesk Core Server Installation and Production Server Layout
;---------------------------------------------------------------------
$oWordApp2 = _WordCreate ($oLayout)
$oDoc2 = _WordDocGetCollection ($oWordApp2, 0)
ConsoleWrite(@error & @CRLF)
_WordDocFindReplace( $oDoc2, "RefStartDate", $oStartDate)
ConsoleWrite(@error & @CRLF)
_WordDocFindReplace( $oDoc2, "RefEndDate", $oEndDate)
ConsoleWrite(@error & @CRLF)
_WordDocFindReplace( $oDoc2, "RefConsultant", $oLDConsultant)
ConsoleWrite(@error & @CRLF)
_WordDocFindReplace( $oDoc2, "RefSOWDate", $oSOWDate)
ConsoleWrite(@error & @CRLF)
_WordDocFindReplace( $oDoc2, "RefCustomerName", $Cust)
_WordDocFindReplace( $oDoc2, "refLocation", $Location)
_WordDocSave($oDoc2)
_WordDocClose ($oDoc2)
ConsoleWrite(@error & @CRLF)
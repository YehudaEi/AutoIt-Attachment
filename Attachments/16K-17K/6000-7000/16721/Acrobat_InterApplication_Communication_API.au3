#include-once
;===============================================================================
; UPDATE HISTORY:
;			1.1.0 - new func _AcrobatIC_JSGetObject
;					new func _AcrobatIC_DocGetWinTitle
;			1.0.1 - fixed obj.exit issue by adding obj.hide
;			1.0.0 - initial
;===============================================================================


;===============================================================================
;
; Function Name:    _AcrobatIC_Create()
; Description:      Create Acrobat Window
; Parameter(s):     
;					$aic_Show				- Optional: specifies whether or not the Acrobat Window is visible
;												True  = (Default) Show window
;												False = Leave window hiden
;
; Requirement(s):   
; Return Value(s):  On Success	- Returns the AcroExch.App Object Ref 
;                   On Failure	- Returns 0 and sets @ERROR
;					@ERROR		- 0 = Object not created
;					@Extended	- 
; CallTip:
; Author(s):        John Bailey
;
;===============================================================================
Func _AcrobatIC_Create($aic_Show=True)
	
	$aic_obj = ObjCreate("AcroExch.App")
	If not IsObj($aic_obj) then 
		SetError(0,'',0)
	EndIf

	If $aic_Show Then $aic_obj.Show
	
	
	Return $aic_obj
EndFunc

;===============================================================================
;
; Function Name:    _AcrobatIC_AppCloseAllDocs()
; Description:      Closes all open acrobat docs
; Parameter(s):     
;					$aic_obj		- 	ref		- The obj ref var
;					$aic_Exit	 	-	boolean	- Optional: specifies whether or not to exit Acrobat App
;													False = (Default) Leave open Acrobat App
;													True  = Exit/Close Acrobat App
;
; Requirement(s):   
; Return Value(s):  On Success	- Returns -1
;                   On Failure	- Returns 0 and sets @ERROR
;					@ERROR		- 0 = not an obj
;								- 1 = Did not close
;					@Extended	- 
; CallTip:
; Author(s):        John Bailey
;
;===============================================================================
Func _AcrobatIC_AppCloseAllDocs(ByRef $aic_obj, $aic_Exit=False)
	If not IsObj($aic_obj) then 
		SetError(0,'',0)
	EndIf
	Local $exitReturn
	Local $aic_closeStatus = $aic_obj.CloseAllDocs()
	
	If $aic_Exit Then
		$aic_obj.Hide ; Hide is required before the exit process can be executed
		$exitReturn = $aic_obj.Exit
	EndIf
	
	If $aic_closeStatus > -1 Then
		SetError(1,'',0)
	Else
		Return $exitReturn
	EndIf 
EndFunc

;===============================================================================
;
; Function Name:	_AcrobatIC_AppExit()
; Description:		Exits Acrobat app
; Parameter(s):     
;					$aic_obj		- 	ref		- The obj ref var
;					$aic_OnlyIfNoDocs - boolean	- Optional: specifies whether to close if only no docs are open in the App
;													False = (Default) Exit regardless
;													True  = Exit/Close Acrobat App only if docs are not open
;
; Requirement(s):   
; Return Value(s):  On Success	- Returns -1 = "This includes closing any open documents, releasing OLE references, and finally exiting the application."
;                   On Failure	- Returns 0 and sets @ERROR
;					@ERROR		- 0 = not an obj
;								- 1 = couldn't close because documents were still open (only if $aic_OnlyIfNoDocs=True)
;					@Extended	- 
; CallTip:
; Note:				"This method does not work if the application is visible (if the user is in control of the application). 
;						In such cases, if the Show method had previously been called, you can call Hide and then Exit." This is why the obj.hide is used first
;						before the obj.exit.
; Author(s):        John Bailey
;
;===============================================================================
Func _AcrobatIC_AppExit(ByRef $aic_oApp,$aic_OnlyIfNoDocs=False)
	If not IsObj($aic_oApp) then 
		SetError(0,'',0)
	EndIf
	
	Local $exitReturn
	
	If $aic_OnlyIfNoDocs Then
		Local $openNumDocs = $aic_oApp.GetNumAVDocs()
		If $openNumDocs = 0 Then
			$aic_oApp.Hide 
			$exitReturn=$aic_oApp.Exit
		Else
			SetError(1,'',0)
		EndIf
	Else
		$aic_oApp.hide ; Hide is required before the exit process can be executed
		$exitReturn=$aic_oApp.Exit
	EndIf
	
	Return $exitReturn
EndFunc

;===============================================================================
;
; Function Name:	_AcrobatIC_AVDocCreate()
; Description:		Creates AVDoc
; Parameter(s):     
;					$aic_obj		- 	ref		- The obj ref var
;
; Requirement(s):   
; Return Value(s):  On Success	- Returns the AVDoc Obj Ref
;                   On Failure	- Returns 0 and sets @ERROR
;					@ERROR		- 0 = not an obj
;					@Extended	- 
; CallTip:
; Author(s):        John Bailey
;
;===============================================================================
Func _AcrobatIC_AVDocCreate(ByRef $aic_obj)
	If not IsObj($aic_obj) then ; I don't understand how to attach it to a specific app obj
		SetError(0,'',0)
	EndIf
	
	Local $aic_oAVDoc = ObjCreate("AcroExch.AVDoc")
	If not IsObj($aic_oAVDoc) then 
		SetError(1,'',0)
	EndIf
	Return $aic_oAVDoc
EndFunc

;===============================================================================
;
; Function Name:	_AcrobatIC_AVDocOpenNew()
; Description:		Opens a PDF
; Parameter(s):     
;					$aic_oApp	- 	ref		- The obj ref var (Must be an App Obj)
;				    $aic_FiletoOpen	-	string	- specifies what file to open
;					$aic_DocTitle 	-	string	- Optional: specifies the document title
;													'' 	  = (Default) blank like this means the file name and location will be used as the name
;
; Requirement(s):   
; Return Value(s):  On Success	- Returns the AVDoc Obj Ref
;                   On Failure	- Returns 0 and sets @ERROR
;					@ERROR		- 0 = $aic_oApp is not an obj
;					@Extended	- 
; CallTip:
; Author(s):        John Bailey
;
;===============================================================================
Func _AcrobatIC_AVDocOpenNew(ByRef $aic_oApp,$aic_FiletoOpen,$aic_DocTitle='')
	If Not IsObj($aic_oApp) then
		SetError(0,'',0)
	EndIf
	Local $aic_oAVDoc = _AcrobatIC_AVDocCreate($aic_oApp)
	If $aic_DocTitle = '' Then
		$aic_oAVDoc.Open($aic_FiletoOpen,$aic_FiletoOpen)
	Else
		$aic_oAVDoc.Open($aic_FiletoOpen,$aic_DocTitle)
	EndIf
	Return $aic_oAVDoc
EndFunc
;===============================================================================
;
; Function Name:	_AcrobatIC_AVDocClose()
; Description:		Closes a PDF
; Parameter(s):     
;					$aic_oAVDoc		- 	ref		- The obj ref var (Must be a AVDoc Obj)
;				    $aic_FiletoOpen	-	string	- specifies what file to open
;					$aic_DocTitle 	-	string	- Optional: specifies the document title
;													'' 	  = (Default) blank like this means the file name and location will be used as the name
;
; Requirement(s):   
; Return Value(s):  On Success	- Returns 1
;                   On Failure	- Returns 0 and sets @ERROR
;					@ERROR		- 0 = not an obj
;								- 1 = obj is not a valid AcroExch.AVDoc obj
;					@Extended	- 
; CallTip:
; Author(s):        John Bailey
;
;===============================================================================
Func _AcrobatIC_AVDocClose(ByRef $aic_oAVDoc,$aic_Save=False)
	If Not IsObj($aic_oAVDoc) then ; I don't understand how to attach it to a specific app obj
		SetError(0,'',0)
	EndIf
	If $aic_oAVDoc.IsValid = False Then 
		SetError(1,'',0)
	EndIf
	If $aic_Save Then
		$aic_oAVDoc.Close(1)
	Else
		$aic_oAVDoc.Close(0)
	EndIf
	Return 1
EndFunc


;===============================================================================
;
; Function Name:	_AcrobatIC_AVDocPrint()
; Description:		Prints a PDF
; Parameter(s):     
;					$aic_obj		- 	ref		- The obj ref var (Must be a AVDoc Obj)
;					$aic_nFirstPage	-	number	- Optional: specifies which page to start printing
;													0 = (Default) The first page in a PDDoc object is page 0.
;					$aic_nFirstPage	-	number	- Optional: specifies which page to end printing
;													-1 = (Default) The last page in the document will be used.
;					$aic_nPSLevel	-	number	- Optional: specifies which PostScriptLevel to use
;													2 = (Default) PostScript Level 2 operators are used.
;													3 = PostScript Language Level 3 operators are also used.
;					$aic_nPSLevel	-	number	- Optional: specifies to use binary data included in the PostScript program
;													0 = (Default) all data is encoded as 7-bit ASCII.
;													greater than zero = binary data may be included in the PostScript program.
;					$aic_bShrinkToFit	number	- Optional: specifies whether the page content should be shrunk (if necessary) to fir within the print area
;													0 = (Default) no shrink
;													greater than zero = the page is shrunk (if necessary) to fit within the imageable area of the printed page.
;
;					--- PostScript printing Only --- Below params are only ---
;					$aic_bReverse	-	number	- Optional: specifies whether the to reverse the print order (Post
;													0 = (Default) no
;													greater than zero = print the pages in reverse order. If false, print the pages in the regular order.
;					$aic_bFarEastFontOpt -number- Optional: specifies whether the destination printer has multibyte fonts
;													0 = (Default) no 
;													greater than zero = the destination printer has multibyte fonts.
;					$aic_bEmitHalftones	-number	- Optional: specifies whether the page content should be shrunk (if necessary) to fir within the print area
;													0 = (Default) no
;					--- End PostScriptOnly ----- end
;
;													greater than zero = emit the halftones specified in the document
;					$aic_iPageOption	number	- Optional: specifies Pages in the range to print.
;													0 = (Default) no shrink
;													? = Pages in the range to print. Must be one of: PDAllPages, PDEvenPagesOnly, or PDOddPagesOnly.
;
; Requirement(s):   
; Return Value(s):  On Success	- Returns 1
;                   On Failure	- Returns 0 and sets @ERROR
;					@ERROR		- 0 = not an obj
;								- 1 = obj is not a valid AcroExch.AVDoc obj
;					 			- 2 = there were any exceptions while printing or no document was open
;					@Extended	- 
; CallTip:
; Author(s):        John Bailey
;
;===============================================================================
Func _AcrobatIC_AVDocPrint(ByRef $aic_obj,$aic_nFirstPage=0,$aic_nLastPage=-1,$aic_nPSLevel=2,$aic_bBinaryOk=0,$aic_bShrinkToFit=0,$aic_bReverse=0,$aic_bFarEastFontOpt=0,$aic_bEmitHalftones=0,$aic_iPageOption=0)
	If Not IsObj($aic_obj) then ; I don't understand how to attach it to a specific app obj
		SetError(0,'',0)
	EndIf
	If $aic_obj.IsValid = False Then 
		SetError(1,'',0)
	EndIf
	
	If $aic_nLastPage=-1 Then
		Local $aic_oPDDoc = $aic_obj.GetPDDoc()
		$aic_nLastPage = $aic_oPDDoc.GetNumPages()
	EndIf
	If $aic_bBinaryOk > 0 Then
		$aic_bBinaryOk = 0
	EndIf
	Local $aic_result = $aic_obj.PrintPagesEx($aic_nFirstPage,$aic_nLastPage,$aic_nPSLevel,$aic_bBinaryOk,$aic_bShrinkToFit,$aic_bReverse,$aic_bFarEastFontOpt,$aic_bEmitHalftones,$aic_iPageOption);
	If $aic_result <> -1 Then
		SetError(2,'',0)
	EndIf
	Return 1
EndFunc

;===============================================================================
;
; Function Name:	_AcrobatIC_DocGetWinTitle()
; Description:		Gets the window’s title.
; Parameter(s):     
;					$aic_oAVDoc			- 	ref		- The obj ref var (Must be a AVDoc Obj)
;
; Requirement(s):   
; Return Value(s):  On Success	- Returns The Doc's Win Title
;                   On Failure	- Returns 0 and sets @ERROR
;					@ERROR		- 0 = not an obj
;
;					@Extended	- 
; CallTip:
; Author(s):        John Bailey
;
;===============================================================================
Func _AcrobatIC_DocGetWinTitle(ByRef $aic_oAVDoc)
	If Not IsObj($aic_oAVDoc) then
		SetError(0,'',0)
	EndIf
	Local $aic_Title = $aic_oAVDoc.GetTitle
	
	Return $aic_Title
EndFunc

;===============================================================================
;
; Function Name:	_AcrobatIC_PDDocCreateNew()
; Description:		Gets the AcroExch.PDDoc associated with an AcroExch.AVDoc.
; Parameter(s):     
;					$aic_oPDDoc			- 	ref		- The obj ref var (Must be a PDDoc Obj)
;
; Requirement(s):   
; Return Value(s):  On Success	- Returns -1
;                   On Failure	- Returns 0 and sets @ERROR
;					@ERROR		- 0 = the $aic_oPDDoc is not an obj
;
;					@Extended	- 
; CallTip:
; Author(s):        John Bailey
;
;===============================================================================
Func _AcrobatIC_PDDocCreateNew(ByRef $aic_oPDDoc)
	If Not IsObj($aic_oPDDoc) then
		SetError(0,'',0)
	EndIf
	Local $PDDocNewReturn = $aic_oPDDoc.Create()
	Return $PDDocNewReturn
EndFunc


;===============================================================================
;
; Function Name:	_AcrobatIC_PDDocGetObject()
; Description:		Gets the AcroExch.PDDoc associated with an AcroExch.AVDoc.
; Parameter(s):     
;					$aic_oAVDoc			- 	ref		- The obj ref var (Must be a AVDoc Obj)
;
; Requirement(s):   
; Return Value(s):  On Success	- Returns obj id for the PDDoc
;                   On Failure	- Returns 0 and sets @ERROR
;					@ERROR		- 0 = not an obj
;
;					@Extended	- 
; CallTip:
; Author(s):        John Bailey
;
;===============================================================================
Func _AcrobatIC_PDDocGetObject(ByRef $aic_oAVDoc)
	If Not IsObj($aic_oAVDoc) then
		SetError(0,'',0)
	EndIf
	Local $PDDocObjReturn = $aic_oAVDoc.GetPDDoc()
	Return $PDDocObjReturn
EndFunc



;===============================================================================
;
; Function Name:	_AcrobatIC_JSGetObject()
; Description:		Gets a dual interface to the JavaScript object associated with the PDDoc
; Parameter(s):     
;					$aic_oPDDoc			- 	ref		- The obj ref var (Must be a PDDoc Obj)
;					$aic_showConsole	-	boolean	- Optional: specifies whether or not to show the js console
;													true	= (Default) makes the console visible
;													false	= leaves the console hidden
;					$aic_consoleClear	-	boolean	- Optional: specifies whether or not to clear text in the console
;													true	= (Default) clears console text
;													false	= leaves the console text
;
; Requirement(s):   
; Return Value(s):  On Success	- Returns The interface to the JavaScript object
;                   On Failure	- Returns 0 and sets @ERROR
;					@ERROR		- 0 = not an obj
;
;					@Extended	- 
; CallTip:
; Author(s):        John Bailey
;
;===============================================================================
Func _AcrobatIC_JSGetObject(ByRef $aic_oPDDoc,$aic_showConsole=true,$aic_consoleClear=True)
	If Not IsObj($aic_oPDDoc) then
		SetError(0,'',0)
	EndIf
	Local $jsobjReturn = $aic_oPDDoc.GetJSObject
	If $aic_showConsole Then
		$jsobjReturn.console.Show
	EndIf
	If $aic_consoleClear Then
		$jsobjReturn.console.Clear
	EndIf
	
	Return $jsobjReturn
EndFunc



;===============================================================================
;
; Function Name:    _AcrobatIC_OpenFileFresh()
; Description:      Open an Acrobat File by creating everything needed (see Note)
; Parameter(s):     $aic_FiletoOpen	-	string	- specifies what file to open
;					$aic_Show 		-	boolean	- Optional: specifies whether or not the Acrobat Window is visible
;													True  = (Default) Show window
;													False = Leave window hiden
;					$aic_DocTitle 	-	string	- Optional: specifies the document title
;													'' 	  = (Default) blank like this means the file name and location will be used as the name
;													
;					$aic_ReturnObjRef	number	- Optional: specifies which obj to return
;													0 = (Default) Returns AcroExch.PDDoc Object Ref
;													1 = Returns AcroExch.AVDoc Object Ref
;													2 = Returns AcroExch.App Object Ref
; Requirement(s):   
; Return Value(s):  On Success	- Returns either
;									the AcroExch.App Object Ref (2)
;									the AcroExch.AVDoc Object Ref (1)
;									the AcroExch.PDDoc Object Ref (0) Default
;                   On Failure	- Returns 0 and sets @ERROR
;					@ERROR		- 0 = AcroExch.App obj not created
;								- 1 = AcroExch.AVDoc obj not created
;					@Extended	- 
; CallTip:			
; Note(s):			This is a "self contained" file open, so _Create() and _AVDoc() are not needed.
; Author(s):        John Bailey
;
;===============================================================================
Func _AcrobatIC_OpenFileFresh($aic_FiletoOpen,$aic_Show=True,$aic_DocTitle='',$aic_ReturnObjRef=0)
	Local $aic_oApp = ObjCreate("AcroExch.App")
	If not IsObj($aic_oApp) then 
		SetError(0,'',0)
	EndIf
	Local $aic_oAVDoc = ObjCreate("AcroExch.AVDoc")
	If not IsObj($aic_oAVDoc) then 
		SetError(1,'',0)
	EndIf
	If $aic_DocTitle = '' Then
		$aic_oAVDoc.Open($aic_FiletoOpen,$aic_FiletoOpen)
	Else
		$aic_oAVDoc.Open($aic_FiletoOpen,$aic_DocTitle)
	EndIf
	
	If $aic_Show Then
		$aic_oApp.Show
	EndIf

	Local $aic_oPDDoc = $aic_oAVDoc.GetPDDoc()
	
	If $aic_ReturnObjRef = 0 Then
		Return $aic_oPDDoc
	ElseIf $aic_ReturnObjRef = 1 Then
		Return $aic_oAVDoc
	ElseIf $aic_ReturnObjRef = 2 Then
		Return $aic_oApp
	Else
		Return $aic_oPDDoc
	EndIf
EndFunc


; Test XML Parser
; 
; First download the mssecure.cab from:
; http://go.microsoft.com/fwlink/?linkid=23130
; extract the file 'mssecure.xml' and place it in the same directory as this script
;
#include <GUIConstants.au3>


$PatchArr=ReadXML("mssecure.xml")

GUICreate("listview items",610,400, (@desktopwidth-610)/2,200)
GUISetBkColor (0x00E0FFFF)  ; will change background color

$listview = GUICtrlCreateListView ("col1  |col2|col3  |col4 ",10,10,600,380)


For $rows = 1 to $PatchArr[0]

	$RowArr=$PatchArr[$rows]

	if not isarray($rowarr)	then
		msgbox(0,"","warning: $rowarr ($patcharr["& $rows & "] is not an array!")
		continueloop
	endif

	$String=""
	for $cols = 1 to $RowArr[0]
		$String = $string & $rowarr[$cols] & "|"
	next
	GUICtrlCreateListViewItem($string,$listview)
next

GUISetState()

Do
  $msg = GUIGetMsg ()
     
Until $msg = $GUI_EVENT_CLOSE


Exit


Func ReadXML($XMLFileName)

Dim $RowArray[5]	; [$columns]

; http://msdn.microsoft.com/library/default.asp?url=/library/en-us/xmlsdk/html/xmmscXMLDOMMethods.asp

; Open MSXML version 3
$xmlObj = ObjCreate("Msxml2.FreeThreadedDomDocument")

;(use this for MSXML version 4):
;$xmlObj = ObjCreate("Msxml2.FreeThreadedDomDocument.4.0")

$xmlObj.SetProperty("ServerHTTPRequest", 0)
$xmlObj.async = 0


; Load document
$xmlObj.load($XMLFilename)

;  Alternative way of reading the document
;  $XMLDocument=FileRead($XMLFilename,FileGetSize($XMLFilename) )
;  $xmlObj.loadXML($XMLDocument)


$myErr = $xmlObj.parseError
If $myErr.errorCode <> 0 Then
   Msgbox(0,"","Error loading document. Reason: " & $myErr.reason)
   exit
endif



$xmlobj.validateOnParse = 0
$xmlobj.resolveExternals = 0
$xmlobj.setProperty("SelectionLanguage", "XPath")


$BullID=""

$objNodeList = $xmlobj.documentElement.selectNodes("Bulletins/Bulletin")
If IsObj($ObjNodeList) Then

 MsgBox (0,"","Press OK to display " & $objNodeList.length & " bulletins.")

 Dim $PatchArray[$objNodeList.length+1]

 $PatchArray[0]=$objNodeList.length

 For $Node = 1 To $objNodeList.length 
    $objNode = $objNodeList.nextNode
    If IsObj($ObjNode) Then

       Dim $RowArray[5]	; [$columns]

       $RowArray[0]=4		; 4 columns

       $objNamedNodeMap = $objNode.attributes

       $RowArray[2]= $objNamedNodeMap.GetNamedItem("BulletinID").text	; Bulletin Number
       $RowArray[3]= $objNamedNodeMap.GetNamedItem("Title").text	; Description


       ; Collect the first Q-Number only

       $objQNumberNodeList = $ObjNode.selectNodes("QNumbers/QNumber")	
       If IsObj($objQNumberNodeList) Then 

	  $objQNumberNode = $objQNumberNodeList.nextNode
          If IsObj($objQNumberNode) Then

             $objQNumberNodeMap = $objQNumberNode.attributes

	     If IsObj($objQNumberNodeMap) Then $RowArray[1]= $objQNumberNodeMap.GetNamedItem("QNumber").text

          Endif
       Endif



       $objPatchNodeList = $ObjNode.selectNodes("Patches/Patch")	
       If IsObj($objPatchNodeList) Then 

        $BullID=$BullID & " " & $objPatchNodeList.Length & " Patch(es)." 

	 For $PatchNode = 1 to $objPatchNodeList.Length
	   $objPatchNode = $objPatchNodeList.nextNode
           If IsObj($objPatchNode) Then

              $objPatchNodeMap = $objPatchNode.attributes

	      If IsObj($objPatchNodeMap) Then 

			Redim $PatchArray[$Node+2]
			$RowArray[4]= $objPatchNodeMap.GetNamedItem("PatchName").text
			$PatchArray[$Node] = $RowArray  ; patch filename
			$Node +=1
			
	      else
			Redim $PatchArray[$Node+2]

			$RowArray[4]= "NO PATCH NODEMAP!"
			$PatchArray[$Node] = $RowArray  ; no map
			$Node +=1
			
              Endif

           Endif
         Next
       Endif

    Endif
    $PatchArray[$Node]=$RowArray
 Next
Endif
 Return $PatchArray
Endfunc
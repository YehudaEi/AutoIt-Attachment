#include <file.au3>
#include <array.au3>
#include <GUIConstants.au3>
#include <SQLite.au3>
#include <SQLite.dll.au3>
#include <EzSkin.au3>
; I have removed this section from the much larger project to make it easier to deal with 
; In the actual usage it reads and writes to a database ..which is why the extra #includes and variables
; The code will run as is (using some dummy settings that I plugged in)
Dim $FirstChap = 2 ; the first chapter link in the Assessment Report 
Dim $LastChap = 18   ; the last chapter link in the Assessment Report
Dim $NoChpts = 17   ; total number of chapters in the Assessment Report
Dim $Test
Dim $Table
Dim $LinkNum = "1"
DIM $LikeThis = "'%Chapter "& $LinkNum &"%'"          ; this will be the field referenced in query using Where or Like condition
Dim $adCol = "Qq_Explanation"
Dim $Find = '%Chapter 3%'
Dim $rcount = 0
Dim $qid
Dim $answer
Dim $qid_array[1]
Dim $sArrayString
Dim $CatCnt
Dim $NewAddress
Dim $Text1 = "Orig note - "
;Dim $filename = FileOpenDialog ("Select QZR", @WorkingDir, "(*.qzr;*mdb)", 1)
;Const $CINFO = "Driver={Microsoft Access Driver (*.mdb)};Dbq="& $filename;"
;Const $ConnStrg = "Driver={Microsoft Access Driver (*.mdb)};Dbq="& $filename;"
Dim $rData = "xxxPRE "
Dim $adTable ="Qe_Category"
Dim $adCol = "Qc_Cat_Desc"
Dim $sTotal = 0
;************************************* Define the Queries ******************************************

form3()
Func Form3()

Dim $oRS
Dim $oConn
Dim $rcount
Dim $qid_array[1]
Dim $qid
Dim $sArrayString
Dim $iChp2
Dim $ChpCnt
Dim $LT = 65
Dim $LT2 = 65
Dim $Ll
Dim $Ll2
Dim $Tall = 200
Dim $Extend
Dim $bTall
Dim $ChapArray[30]
Dim $INPUT

;___________________________________________________________________________

$Tall =  120 + $NoChpts * 25 
$bTall = $Tall -35  


;________________________________________________________________________________
#Region ### START Koda GUI section ### Form=C:\Program Files\CramMaster\Data\PSB_Script_project\AForm3.kxf
$Form1 = GUICreate("Available for each Chapter", 762, $Tall, 193, 115)
;Opt("GUICoordMode",2)
GUISetBkColor(0x404040)
$Label1 = GUICtrlCreateLabel("This form will show number points marked in each of the chapters. ",136, 8, 675, 20)
GUICtrlSetFont(-1, 10, 800, 0, "Pyin3")
GUICtrlSetColor(-1, 0xFFFF00)
GUICtrlSetBkColor(-1, 0x404040)
$Label2 = GUICtrlCreateLabel("How many do you want to include in the report from each of these chapters.", 16, 32, 736, 20)
GUICtrlSetFont(-1, 10, 800, 0, "Pyin3")
GUICtrlSetColor(-1, 0xFFFF00)
GUICtrlSetBkColor(-1, 0x404040)
$Button1 = GUICtrlCreateButton("Proceed", 360, $bTall, 75, 25, 0)
;==============================
For $iChp2 = $FirstChap to $LastChap
	$LinkNum = $iChp2
	$LikeThis = "'%Chapter "& $LinkNum &"%'" 
;; One Chapter at a time loop from here down "
;$oConn = ObjCreate("ADODB.Connection")
;$oRS = ObjCreate("ADODB.Recordset")
;$oConn.Open($ConnStrg)
;$oRS.Open("Select Qq_QuestCode From "& $Table2 &" where  Qq_Explanation Like "& $LikeThis &" And Qq_TypeCode=1;", $oConn, 1, 3)
;$ChpCnt = $oRS.RecordCount
$ChpCnt = 12
 GUICtrlCreateLabel(" Chapter "& $iChp2 &" has "& $ChpCnt &" points available. How many do you wish to include in the report?", 48, $LT, 564, 18)
	GUICtrlSetFont(-1, 9, 800, 0, "Tahoma")
	GUICtrlSetBkColor(-1, 0xC0C0C0)
$LT = $LT + 25	
;==========================
If $ChpCnt <> 0 then

$ChapArray[$ChpCnt]=GUICtrlCreateInput("", 632, $LT2, 52, 18)
;_ArrayAdd($ChapArray,GUICtrlCreateInput("", 632, $LT2, 52, 18))
GUICtrlSetFont(-1, 9, 800, 0, "Tahoma")
GUICtrlSetBkColor(-1, 0xFFFFFF)
$LT2 = $LT2 + 25	
Else
endif
;++++++++++++++++++++++++++++++++++++++++++
Next  ; Loop Back for next chpt link
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Button1
			GUIDelete()
								;--- Test Message to show results		
									Dim $sArrayString = _ArrayToString( $ChapArray,@TAB, 1 )
									MsgBox( 4096, "_ArrayToString() Test", $sArrayString )
			Exit
	EndSwitch
WEnd

EndFunc


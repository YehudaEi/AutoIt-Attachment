#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=SQLite2.ico
#AutoIt3Wrapper_Res_Description=SQLite Listview with BLOB Objects
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=GreenCan
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****

#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.8.1
	Author:         GreenCan

	Credits to:
	1. trancexx: GIFAnimation.au3
		http://www.autoitscript.com/forum/topic/96132-gif-animation/
	2. smashly: _ImageResize()
		Resizes and converts different graphicformats
		http://www.autoitscript.com/forum/topic/80138-simple-image-resize-function/?p=577084
	3. rover: Customize Draw of Listview rows
	          Optimizations of WS_NOTIFY
		I also thank rover for giving a second method to resolve the image space issue.
		I implemented the one proposed by KaFu, because very simple to implement
	4. KaFu: Solved the Listview issue with image space in Columns one.
		http://www.autoitscript.com/forum/topic/150653-solved-image-in-listview-issue/?p=1076344
	5. jchd: For some hints and background info on SQLite
		http://www.autoitscript.com/forum/topic/150508-sqlite-listview-and-blob-demo/?p=1076010
	6. Yashied: WinAPIEx.au3
		http://www.autoitscript.com/forum/topic/98712-winapiex-udf/

	Script Function:
		ListView SQLite database tables with BLOBs
		This example will identify, display and export BLOB objects natively
		Pre-requisites:
		Examples of native BLOB identification
		BLOB with header:
			Each BLOB object should contain a header section containing the filename with extension followed by a NUL byte
			This is a compromise to be able to identify any kind of object that can be stored in a BLOB
			It would not be required for images (see hereunder) but there is no way to identify an objet like an AU3 file,
			because this file does not contain any header section.  Same for txt or CSV and many other header-less formats.
		BLOB without header:
			Headers are not required if the BLOB only contain images

		The file name may not contain a path !

	SQL
		The Table containing a BLOB requires to have a Primary  and unique key to be able to display the image or execute the object.
		The primary key is used to retrieve the BLOB object (the correct record) in the table when clicking on the object cell, see WM_NOTIfY for more details
		I was inclined to use RowID as a key (this requires no additional column in the table) to the object's record but jchd convinced me to backtrack as RowID
		is volatile.

		You can force the primary key to be hidden in the Listview by setting $bHidePrimary = True

		If, for any case, the BLOB is wrongly formatted, but still is identified as an image, but not displayable, a black square will be displayed in the ListView

	Remarks:
		The script was not tested on Windows XP !
		Although, I don't see why it would not fiunctionproperly

	Known problems:
		None, me (?)

#ce ----------------------------------------------------------------------------
#include <sqlite.au3>
#include <windowsconstants.au3>
#include <GUIConstantsEx.au3>
#include <GIFAnimation.au3>
#include <Misc.au3>
#include <guilistview.au3>
#include <GuiImageList.au3>
#include <GDIPlus.au3>
#include <WinAPIEx.au3>

If _Singleton(@ScriptName, 1) = 0 Then Exit
Opt("MustDeclareVars", 1)


#region declare
; Required as Global
Global $sDatabase, $sTable, $sMainSQL, $bHidePrimary, $bBlowRaw
Global $sSQL, $hMainGui, $hListView

; Debug mode: set to 1 for debug
Global $iDebug = 0

; Required for WM_NOTIFY, _ExecBin
Global Const $CDDS_SUBITEMPREPAINT = BitOR($CDDS_ITEMPREPAINT, $CDDS_SUBITEM)
Global Const $CDDS_SUBITEMPOSTPAINT = BitOR($CDDS_ITEMPOSTPAINT, $CDDS_SUBITEM)
Global $cExecBin
Global $iLastItem = -1, $iLastsubitemNR = -1, $subitemNR
Global $hImage
Global $aBLOB[1], $aNames ; required for _IsBLOB()
Global $hGui_ImageView, $bGui_ImageView
Global $sFileName
Global $sExportFolder = @ScriptDir & "\Exports"

; Required for Image Viewer
Global $sPrimary = "", $hGIF, $hGIFLabel, $hButtonExport, $hButtonClosePreview
#endregion declare

;~ #cs

#region examples
; example 1
MsgBox(0, "Example 1","This example shows SQLite table Image_store." & @CR _
	& "The report shows the BLOB object, an image or other object." & @CR _
	& "Click on the object to view the image or execute the object." & @CR _
	& "Column 'BLOB Header' shows the file name that is stored in the BLOB." & @CR _
	& "The primary key is hidden in this example.", 30)
$sDatabase = @ScriptDir & "\GreenCan_demo2.db"
$sTable = "Image_store"
$sMainSQL = "SELECT Filename, TypeOfObject, Object, Key, Title, LENGTH(Object) as 'BLOB size', SUBSTR(Object,1,instr(Object,CHAR(0))) as 'BLOB Header' FROM " & $sTable & " ORDER BY Key"
$bHidePrimary = True ; Hide the primary key Column

#region test only
;~ $sDatabase = @ScriptDir & "\GreenCan_demo3.db"

; these SQLs will also function:
;~ $sMainSQL = "SELECT Filename, TypeOfObject, Object, Key, Title, LENGTH(Object) as 'BLOB size', SUBSTR(Object,1,instr(Object,CHAR(0))) as 'BLOB Header' FROM " & $sTable & " ORDER BY Filename"
;~ $sMainSQL = "SELECT Filename, TypeOfObject, Object, Key, Title, LENGTH(Object) as 'BLOB size', SUBSTR(Object,1,instr(Object,CHAR(0))) as 'BLOB Header' FROM " & $sTable & " ORDER BY Key"
;~ $sMainSQL = "SELECT Filename, TypeOfObject, Object, Key, Title, LENGTH(Object) as 'BLOB size', SUBSTR(Object,1,instr(Object,CHAR(0))) as 'BLOB Header', Object FROM " & $sTable & " ORDER BY Key"
;~ $sMainSQL = "SELECT Filename, TypeOfObject, Object, Title, Key, LENGTH(Object) as 'BLOB size' FROM " & $sTable & " ORDER BY Filename"
;~ $sMainSQL = "SELECT Title, Object, Key FROM " & $sTable
;~ $sMainSQL = "SELECT Object, Key FROM " & $sTable ; object is first column
;~ $sMainSQL = "SELECT KEY, OBJECT FROM " & $sTable ; object is last column
;~ $sMainSQL = "SELECT KEY, OBJECT,null FROM " & $sTable ; object is in the middle
;~ $sMainSQL = "SELECT * FROM " & $sTable ; Generic all columns ( * ) used
;~ $sMainSQL = "SELECT * FROM " & $sTable & " ORDER by 1"; Generic all columns ( * ) used
;~ $sMainSQL = "SELECT Filename, TypeOfObject, Title, Key, LENGTH(Object) as 'BLOB size' FROM " & $sTable & " ORDER BY Filename" ; no BLOB
#endregion test only
List_Viewer($sDatabase, $sTable, $sMainSQL, $bHidePrimary)
If @error Then Exit MsgBox(16, "List_Viewer Error", "SQLite Error: " & @error & @CR &  "Extended: " & @extended)

; example 2 - Listview without BLOB
MsgBox(0, "Example 2","This example shows SQLite table Image_store again" & @CR _
	& "but this time without the BLOB column." & @CR _
	& "The Listview looks like a familiar text only Listview.", 30)
$sDatabase = @ScriptDir & "\GreenCan_demo2.db"
$iDebug = 0 ; set to 1 for debug mode
$sDatabase = @ScriptDir & "\GreenCan_demo2.db"
$sTable = "Image_store"
$sMainSQL = "SELECT Filename, TypeOfObject, Title, Key, LENGTH(Object) as 'BLOB size' FROM " & $sTable & " ORDER BY Filename" ; no BLOB
$bHidePrimary = True ; Hide the primary key Column
List_Viewer($sDatabase, $sTable, $sMainSQL, $bHidePrimary)
If @error Then Exit MsgBox(16, "List_Viewer Error", "SQLite Error: " & @error & @CR &  "Extended: " & @extended)

; example 3 - other table
MsgBox(0, "Example 3","This example shows SQLite table animals." & @CR _
	& "The table contains 2 BLOB columns." & @CR _
	& "The primary key is shown in this example.", 30)

$sDatabase = @ScriptDir & "\GreenCan_demo2.db"
$sTable = "animals"
;~ $sMainSQL = "SELECT * FROM " & $sTable ; Generic all columns ( * ) used
$sMainSQL = "SELECT Name,LatinName,Family,AverageSizeCm,AverageWeightGram,Distribution,Image,Map, SUBSTR(Map,1,100) as 'BLOB Header' FROM " & $sTable
$bHidePrimary = False ; Hide the primary key Column
List_Viewer($sDatabase, $sTable, $sMainSQL, $bHidePrimary)
If @error Then Exit MsgBox(16, "List_Viewer Error", "SQLite Error: " & @error & @CR &  "Extended: " & @extended)

;~ #ce

; example 4 - Listview with raw BLOB (images only)
MsgBox(0, "Example 4","This example shows SQLite table animals_Raw." & @CR _
	& "The animals_Raw table is similar to the animals table" & @CR _
	& "except that the BLOB contains only Raw hex code without header data." & @CR _
	& "The BLOB preferably only contains images. Other formats are not recognized." & @CR _
	& "Because of the image recognition algorithm, the Litview is a little bit slower to build." & @CR _
	& "The object is directly extractable because it does not contain any header data." & @CR _
	& "The format of the BLOB is compatible with other SQLite Database browsers that can display images." & @CR _
	& "Check the tooltip when you flyover the object." & @CR _
	& "But you will notice that the file name starts with a tilde, there is no link to a file name.", 30)

$sDatabase = @ScriptDir & "\GreenCan_demo2.db"
$iDebug = 0 ; set to 1 for debug mode
$sTable = "animals_Raw"
;~ $sMainSQL = "SELECT Name,LatinName,Family,AverageSizeCm,AverageWeightGram,Distribution,Image,Map, SUBSTR(Map,1,100) as 'BLOB Header' FROM " & $sTable
$sMainSQL = "SELECT * FROM " & $sTable ; Generic all columns ( * ) used
$bHidePrimary = False ; Hide the primary key Column
$bBlowRaw = 1
List_Viewer($sDatabase, $sTable, $sMainSQL, $bHidePrimary, 1)
If @error Then Exit MsgBox(16, "List_Viewer Error", "SQLite Error: " & @error & @CR &  "Extended: " & @extended)

; example 5 - Listview with raw BLOB (images and other unrecognizable objects)
MsgBox(0, "Example 5","This example shows SQLite table Image_store_Raw." & @CR _
	& "Unlike the animals table, this table contains images and other objects," & @CR _
	& "the BLOB contains only Raw hex code without header data." & @CR _
	& "The non graphic objects cannot be recognized.", 30)

$sDatabase = @ScriptDir & "\GreenCan_demo2.db"
$iDebug = 0 ; set to 1 for debug mode
$sTable = "Image_store_Raw"
$sMainSQL = "SELECT * FROM " & $sTable ; Generic all columns ( * ) used
$bHidePrimary = False ; Hide the primary key Column
$bBlowRaw = 1
List_Viewer($sDatabase, $sTable, $sMainSQL, $bHidePrimary, 1)
If @error Then Exit MsgBox(16, "List_Viewer Error", "SQLite Error: " & @error & @CR &  "Extended: " & @extended)


MsgBox(0, "Listview with BLOB", "End of Example")
#endregion examples

Exit
#FUNCTION# ==============================================================
; #FUNCTION# ====================================================================================================================
; Name...........: List_Viewer
; Description....: Creates a ListView for a SQLite table
; Syntax.........: List_Viewer($sDatabase, $sTable, $sMainSQL, $bHidePrimary[, $bBlowRaw = 0])
; Parameters.....: $sDatabase - SQLite DataBase full path file name.
;                  $sTable    - Table to be queried.
;                  $sMainSQL  - The SQL to be fired.
;                  $bBlowRaw  - Optional: Specifies whether the BLOB contains filename in the header or not (default = 0)
;								$bBlowRaw = 1 means that the BLOB contains no header data, and can be used as is when exporting, this
;								is only valid for tables with BLOB columns that contain only images.
; Return values .: Success - 1
;					Failure	- Returns @error
;                  |1 - SQLite startup failure or database not found, see @extended for more details
;                  |2 - _SQLite_QuerySingleRow on Count rows failure, see @extended for more details
;                  |3 - _SQLite_Query on PRAGMA failure, see @extended for more details
;                  |4 - _SQLite_Query on Main Query failure, see @extended for more details
;                  |5 - _SQLite_FetchNames on Titles Query failure, see @extended for more details
;                  |6 - File open error (file creation)
;                  |7 - _SQLite_Query on Main Query ReQuery failure, see @extended for more details
;                  |8 - File copy error (file export)
; Author.........: GreenCan
; Modified.......:
; Remarks........: None
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================
Func List_Viewer($sDatabase, $sTable, $sMainSQL, $bHidePrimary, $bBlowRaw = 0)
	Local $iGUIWidth = 985, $iGUIHeigth = 550, $aRows, $iMaxRec, $hQuery, $sColumnNames, $iObjectPosition, $bBLOBisLastColumn, $sSetColumnOrder, _
		$bDisplayObject, $iImageSize, $iZeroBased, $sFileextension, $aResult, $StringRemainder, $hFile, $iMaxRows, $sColumnHeadings, $iImages, _
		$hButtonClose, $msg, $Result, $sEndOfFileNameFlag
	$bGui_ImageView = False ; reset
	_SQLite_Startup()
	If @error Then Return SetError(1, 0, @error)
	If $iDebug Then ConsoleWrite("_SQLite_LibVersion=" & _SQLite_LibVersion() & @CRLF)
	_SQLite_Open($sDatabase, $SQLITE_OPEN_READONLY )
	If @error Then Return SetError(1, 0, @error)

	; Step 1 - Count number of rows in table
	$sSQL = "SELECT count(*) FROM " & $sTable
	_SQLite_QuerySingleRow(-1, $sSQL, $aRows)
	If @error Then Return SetError(2, 0, @error)

	$iMaxRec = $aRows[0]

	$hMainGui = GUICreate("Database: " & StringRight($sDatabase, StringLen($sDatabase) - StringInStr($sDatabase, "\", 0, -1)) & "  -  Table: " & $sTable & "  -  (" & $iMaxRec & " Rows)", $iGUIWidth, $iGUIHeigth, -1, -1, $WS_OVERLAPPEDWINDOW)
	GUISetBkColor(0xFFFFFF)

	#region populate $aBLOB Array with all BLOB Columns
	; Step 2 - Populate $aBlob
	Dim $aBLOB[1] ; used for BLOB Field list
	$sPrimary = "" ; used to retrieve BLOB in Image Viewer

	; PRAGMA to make a BLOB list and to find the primary key
	$sSQL = "PRAGMA table_info(" & $sTable & ")"
	_SQLite_Query(-1, $sSQL, $hQuery)
	If @error Then Return SetError(3, 0, @error)

	; go through all records to identify all BLOBs and the first Primary Key
	$sColumnNames = ""
	While _SQLite_FetchData($hQuery, $aRows) = $SQLITE_OK
		If $iDebug Then ConsoleWrite(@ScriptLineNumber & " " & $aRows[1] & " " & $aRows[2] & " " & $aRows[3] & " " & $aRows[4] & " " & $aRows[5] & @CR)
		If StringInStr($sMainSQL, " * ") Then $sColumnNames &= $aRows[1] & "," ; if generic all columns  symbol * used
		If $sPrimary = "" Then
			If $aRows[5] = 1 Then $sPrimary = $aRows[1]
		EndIf
		If $aRows[2] = "BLOB" Then _ArrayAdd($aBLOB, $aRows[1])
	WEnd
	If StringInStr($sMainSQL, " * ") Then ; if generic all columns  symbol * used
		$sColumnNames = StringTrimRight($sColumnNames, 1)
		$sMainSQL = StringReplace($sMainSQL," * ", " " & $sColumnNames & " ")
	EndIf
	#endregion populate $aBLOB Array with all BLOB Columns

	If $iDebug Then _ArrayDisplay($aBLOB, @ScriptLineNumber)

	; IMPORTANT remark !!!!!
	; a Primary key column is a mandatory column in the SQL because it will link the BLOB for visualization, see WM_NOTIfY
	; it should always be part of the SQL in the listview containing objects
	; You can hide the Primary key with $bHidePrimary, place it preferably as last column of the SQL, so it won't disturb the Listview if you accidentelly unhide it.

	#region Image space issue - Part 1
	; build the corrected SQL statement
	; Correct Image space issue first column, by moving BLOB column to position 1

	$sMainSQL = StringReplace($sMainSQL, ", ", ",")
	If $iDebug Then ConsoleWrite(@ScriptLineNumber & " " & $sMainSQL & @CR)

	; 1. test if Object is in the middle of the SQL
	; remember the position (via count) of the first BLOB column & ',' so that it can be repositioned later
	StringReplace(StringLeft($sMainSQL, StringInStr($sMainSQL, "," & $aBLOB[1] & ",")), ",", "")
	$iObjectPosition = @extended
	$bBLOBisLastColumn = False
	If $iObjectPosition = 0 Then
		; 2. Not found, now test if Object is the last column
		; Object not found so try to find the object as the last column ( just before FROM)
		; try the position (via count) of the first BLOB column & space so that it can be repositioned later
		StringReplace(StringLeft($sMainSQL, StringInStr($sMainSQL, "," & $aBLOB[1] & " ")), ",", "")
		$iObjectPosition = @extended
		If $iObjectPosition > 0 Then ; If 0 it's the First Column and we don't need to change the SQL string
			; Last column
			$bBLOBisLastColumn = True
			$sMainSQL = StringReplace($sMainSQL, "SELECT ", "")
			$sMainSQL = "SELECT " & $aBLOB[1] & "," & StringLeft($sMainSQL, StringInStr($sMainSQL, "," & $aBLOB[1] & " ")-1) & " " & StringTrimLeft($sMainSQL, StringInStr($sMainSQL, "," & $aBLOB[1] & " ") + StringLen($aBLOB[1]) + 1)
		EndIf
	Else
		$sMainSQL = StringReplace($sMainSQL, "SELECT ", "")
		$sMainSQL = "SELECT " & $aBLOB[1] & "," & StringLeft($sMainSQL, StringInStr($sMainSQL, "," & $aBLOB[1] & ",")) & StringTrimLeft($sMainSQL, StringInStr($sMainSQL, "," & $aBLOB[1] & ",") + StringLen($aBLOB[1]) + 1)
	EndIf
	If $iDebug Then ConsoleWrite(@ScriptLineNumber & " " & $sMainSQL & @CR)
	#endregion Image space issue - Part 1

	; Now fire the SQL first time
	_SQLite_Query(-1, $sMainSQL, $hQuery)
	If @error Then Return SetError(4, 0, @error)
	; Get Query Titles
	_SQLite_FetchNames($hQuery, $aNames) ; Read out Column Names
	If @error Then Return SetError(5, 0, @error)

	#region Image space issue - Part 2
	; Prepare _GUICtrlListView_SetColumnOrder
	$sSetColumnOrder = "" ; this will be used with _GUICtrlListView_SetColumnOrder to reset the column order to the initial SQL order
	$bDisplayObject = True

	; is there any object in the SQL?
	If _ArraySearch($aNames, $aBLOB[1]) = -1 Then
		$bDisplayObject = False
	Else
		If Not $bBLOBisLastColumn Then
			For $i = 1 To UBound($aNames) - 1
				If $i = $iObjectPosition + 1 Then
					$sSetColumnOrder &= "0|" & $i & "|"
				Else
					$sSetColumnOrder &= $i & "|"
				EndIf
			Next
		Else
			For $i = 1 To UBound($aNames) - 1
				If $iDebug Then ConsoleWrite(@ScriptLineNumber & " " & $i & " " &  UBound($aNames) & @CR)
				$sSetColumnOrder &= $i & "|"
			Next
			$sSetColumnOrder &=   "0|"
		EndIf
		$sSetColumnOrder = StringTrimRight($sSetColumnOrder, 1)
	EndIf
	If $iDebug Then ConsoleWrite(@ScriptLineNumber & " $bDisplayObject: " & $bDisplayObject & " " & $sSetColumnOrder & @CR)
	If $iDebug Then _ArrayDisplay($aNames, @ScriptLineNumber)
	#endregion Image space issue - Part 2

	#region Load images
  	; Step 3 - Load images
	If $bDisplayObject Then
		$iImageSize = 48 ; size of image is 48 x 48 but you can change it
		$hImage = _GUIImageList_Create($iImageSize, $iImageSize, 5)

		; first the generic images
		If Not FileExists(@ScriptDir & "\Resources\_Unsupported.bmp") Then Create_resources()
		If $bBlowRaw Then
			If Not FileExists(@ScriptDir & "\Resources\_Unsupported.bmp") Then ; error correction: added to avoid a shift of images if the file is not there
				_GUIImageList_AddIcon($hImage, @SystemDir & "\shell32.dll", 52) ; 52 is a black square
			Else
				_GUIImageList_AddBitmap($hImage, @ScriptDir & "\Resources\_Unsupported.bmp") ; execute
			EndIf
		Else
			If Not FileExists(@ScriptDir & "\Resources\_DatabaseExecute.bmp") Then ; error correction: added to avoid a shift of images if the file is not there
				_GUIImageList_AddIcon($hImage, @SystemDir & "\shell32.dll", 52)
			Else
				_GUIImageList_AddBitmap($hImage, @ScriptDir & "\Resources\_DatabaseExecute.bmp") ; Unsupported format
			EndIf
		EndIf
		If Not FileExists(@ScriptDir & "\Resources\_Image.bmp") Then ; error correction: added to avoid a shift of images if the file is not there
			_GUIImageList_AddIcon($hImage, @SystemDir & "\shell32.dll", 52)
		Else
			_GUIImageList_AddBitmap($hImage, @ScriptDir & "\Resources\_Image.bmp") ; image
		EndIf

		; and now the one in the Database
		$iZeroBased = -1
		While _SQLite_FetchData($hQuery, $aRows) = $SQLITE_OK
			$iZeroBased += 1
			For $i = 0 To UBound($aNames) - 1 ; check every column
				If _IsBLOB($aNames[$i], $aBLOB) Then
					If $bBlowRaw Then
						; $aRows[$i] = $aRows[$i]  ; raw BLOB
						If StringMid($aRows[$i], 3,8) == "89504E47" Then ; png file signature
							$sFileextension = "png"
							$sFileName = _TempFile(@TempDir, "~", "." & $sFileextension)
							$sFileName = StringRight($sFileName, StringLen($sFileName) - StringInStr($sFileName, "\", 0, -1)) ; split filename from path
						ElseIf StringMid($aRows[$i], 3,4) == "424D" Then ; bmp file signature 424D
							$sFileextension = "bmp"
							$sFileName = _TempFile(@TempDir, "~", "." & $sFileextension)
							$sFileName = StringRight($sFileName, StringLen($sFileName) - StringInStr($sFileName, "\", 0, -1)) ; split filename from path
						ElseIf StringMid($aRows[$i], 15,8) == "4A464946" Then ; jpg file signature 4A464946
							$sFileextension = "jpg"
							$sFileName = _TempFile(@TempDir, "~", "." & $sFileextension)
							$sFileName = StringRight($sFileName, StringLen($sFileName) - StringInStr($sFileName, "\", 0, -1)) ; split filename from path
						ElseIf StringMid($aRows[$i], 3,6) == "474946" Then ; gif file signature 474946
							$sFileextension = "gif"
							$sFileName = _TempFile(@TempDir, "~", "." & $sFileextension)
							$sFileName = StringRight($sFileName, StringLen($sFileName) - StringInStr($sFileName, "\", 0, -1)) ; split filename from path
						ElseIf StringMid($aRows[$i], 3,8) == "00000100" Then ; ico file signature 00000100
							$sFileextension = "ico"
							$sFileName = _TempFile(@TempDir, "~", "." & $sFileextension)
							$sFileName = StringRight($sFileName, StringLen($sFileName) - StringInStr($sFileName, "\", 0, -1)) ; split filename from path
						Else
							; unknown
							$sFileextension = ""
							$sFileName = ""
						EndIf
					Else
						; identify which type of BLOB object here, by checking the header for the filename
						; split file name and BLOB object
						$sEndOfFileNameFlag = StringInStr($aRows[$i], "00")
						If Int($sEndOfFileNameFlag / 2) = $sEndOfFileNameFlag / 2 Then $sEndOfFileNameFlag += 1
						$sFileName = BinaryToString(StringLeft($aRows[$i], $sEndOfFileNameFlag - 1))
						; Trimmed BLOB
						$aRows[$i] = "0x" & StringTrimLeft($aRows[$i], $sEndOfFileNameFlag + 1)
						$sFileextension = StringTrimLeft($sFileName, StringInStr($sFileName, "."))
					EndIf
					If StringInStr(".gif;.png;.jpg;.bmp;.jpeg;.ico;", $sFileextension) > 0 Then
						; ConsoleWrite(@ScriptLineNumber & " " & $aRows[1] & @CR)
						; this does not function for any other graphic type but .bmp
						; so first convert all images to small size bmp
						$aResult = StringRegExp($aRows[$i], "(.{4094}|.{1,4094)", 3)
						$StringRemainder = StringTrimLeft($aRows[$i], Int(StringLen($aRows[$i]) / 4094) * 4094)
						$sFileName = @TempDir & "\" & $sFileName
						; create object
						$hFile = FileOpen($sFileName, 16 + 2)
						If $hFile = -1 Then Return SetError(6, 0, 0)
						$iMaxRows = UBound($aResult)
						If $iMaxRows = 0 Then ; BLOB contains less than 4094 bytes
							FileWrite($hFile, $StringRemainder)
						Else
							FileWrite($hFile, $aResult[0]) ; "0x" already exists for the first row
							For $ii = 1 To $iMaxRows - 1
								FileWrite($hFile, "0x" & $aResult[$ii])
							Next
							FileWrite($hFile, "0x" & $StringRemainder)
						EndIf
						FileClose($hFile)

						_ImageResize($sFileName, StringTrimRight($sFileName, 3) & "bmp", 48, 48)
						If Not @error Then
							If Not FileExists(StringTrimRight($sFileName, 3) & "bmp") Then ; error correction: added to avoid a shift of images if the file is not there
								_GUIImageList_AddIcon($hImage, @SystemDir & "\shell32.dll", 52)
							Else
								_GUIImageList_AddBitmap($hImage, StringTrimRight($sFileName, 3) & "bmp")
							EndIf
							; cleanup
							FileDelete($sFileName)
							FileDelete(StringTrimRight($sFileName, 3) & "bmp")
						Else
							ConsoleWrite(@ScriptLineNumber & " " & StringTrimRight($sFileName, 3) & "bmp" & " error: " & @error & @CR)

						EndIf
					EndIf
				EndIf
			Next
		WEnd
	EndIf
	#endregion Load images

	#region ListView
	;  Step 4 - Listview
	$cExecBin = GUICtrlCreateDummy()

	$sColumnHeadings = ""
	For $i = 0 To UBound($aNames) - 1 ; every column
		$sColumnHeadings &= $aNames[$i] & "|"
	Next
	$sColumnHeadings = StringTrimRight($sColumnHeadings, 1)
	$hListView = GUICtrlCreateListView($sColumnHeadings, 10, 10, $iGUIWidth - 20, $iGUIHeigth - 50, $LVS_REPORT, $LVS_EX_REGIONAL)
	_GUICtrlListView_BeginUpdate($hListView)
	_GUICtrlListView_SetExtendedListViewStyle($hListView, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT, _
			$LVS_EX_SUBITEMIMAGES, $LVS_EX_INFOTIP, $LVS_EX_HEADERDRAGDROP))

	; and now we have to re-query :(
	If $bDisplayObject Then _GUICtrlListView_SetImageList($hListView, $hImage, 1)
	_SQLite_Query(-1, $sMainSQL, $hQuery)
	If @error Then Return SetError(7, 0, @error)
	$iImages = 2
	$iZeroBased = -1
	While _SQLite_FetchData($hQuery, $aRows) = $SQLITE_OK
		$iZeroBased += 1
		For $i = 0 To UBound($aNames) - 1 ; check every column
			If $i = 0 Then ; First Column so requires _GUICtrlListView_AddItem
				If _IsBLOB($aNames[$i], $aBLOB) Then
					If $aRows[$i] = "" Then ; empty BLOB
						_GUICtrlListView_AddItem($hListView, $aRows[$i], _GUIImageList_GetImageCount($hImage) + 1)
					Else
						If $bBlowRaw Then
							If StringMid($aRows[$i], 3,8) == "89504E47" Then ; png file signature
								$sFileextension = "png"
							ElseIf StringMid($aRows[$i], 3,4) == "424D" Then ; bmp file signature 424D
								$sFileextension = "bmp"
							ElseIf StringMid($aRows[$i], 15,8) == "4A464946" Then ; jpg file signature 4A464946
								$sFileextension = "jpg"
							ElseIf StringMid($aRows[$i], 3,6) == "474946" Then ; gif file signature 474946
								$sFileextension = "gif"
							ElseIf StringMid($aRows[$i], 3,8) == "00000100" Then ; ico file signature 00000100
								$sFileextension = "ico"
							Else
								; unknown
								$sFileextension = ""
							EndIf
						Else
							; split file name and BLOB object
							$sEndOfFileNameFlag = StringInStr($aRows[$i], "00")
							If Int($sEndOfFileNameFlag / 2) = $sEndOfFileNameFlag / 2 Then $sEndOfFileNameFlag += 1
							$sFileName = BinaryToString(StringLeft($aRows[$i], $sEndOfFileNameFlag - 1))
							$sFileextension = StringTrimLeft($sFileName, StringInStr($sFileName, "."))
						EndIf
						If StringInStr(".gif;.png;.jpg;.bmp;.jpeg;.ico;.tif;", $sFileextension) > 0 Then
							If StringInStr(".tif;", $sFileextension) = 0 Then
								_GUICtrlListView_AddItem($hListView, "", $iImages) ; bmp exist in ImageList
								$iImages += 1
							Else
								_GUICtrlListView_AddItem($hListView, "", 1) ; unable to convert tif to bmp
							EndIf
						Else
							_GUICtrlListView_AddItem($hListView, "", 0) ; executable object
						EndIf
					EndIf
				Else
					If $bDisplayObject Then
						; with BLOBobject image
						_GUICtrlListView_AddItem($hListView, $aRows[$i], _GUIImageList_GetImageCount($hImage) + 1)
					Else
						; without BLOB object image
						_GUICtrlListView_AddItem($hListView, $aRows[$i])
					EndIf
				EndIf
			Else
				If _IsBLOB($aNames[$i], $aBLOB) Then
					If $aRows[$i] = "" Then ; empty BLOB
						_GUICtrlListView_AddSubItem($hListView, $iZeroBased, $aRows[$i], $i)
					Else
						If $bBlowRaw Then
							If StringMid($aRows[$i], 3,8) == "89504E47" Then ; png file signature
								$sFileextension = "png"
							ElseIf StringMid($aRows[$i], 3,4) == "424D" Then ; bmp file signature 424D
								$sFileextension = "bmp"
							ElseIf StringMid($aRows[$i], 15,8) == "4A464946" Then ; jpg file signature 4A464946
								$sFileextension = "jpg"
							ElseIf StringMid($aRows[$i], 3,6) == "474946" Then ; gif file signature 474946
								$sFileextension = "gif"
							ElseIf StringMid($aRows[$i], 3,8) == "00000100" Then ; ico file signature 00000100
								$sFileextension = "ico"
							Else
								; unknown
								$sFileextension = ""
							EndIf
						Else
							; split file name and BLOB object
							$sEndOfFileNameFlag = StringInStr($aRows[$i], "00")
							If Int($sEndOfFileNameFlag / 2) = $sEndOfFileNameFlag / 2 Then $sEndOfFileNameFlag += 1
							$sFileName = BinaryToString(StringLeft($aRows[$i], $sEndOfFileNameFlag - 1))
							$sFileextension = StringTrimLeft($sFileName, StringInStr($sFileName, "."))
						EndIf
						If StringInStr(".gif;.png;.jpg;.bmp;.jpeg;.ico;.tif", $sFileextension) > 0 Then
							If StringInStr(".tif;", $sFileextension) = 0 Then
								_GUICtrlListView_AddSubItem($hListView, $iZeroBased, "", $i, $iImages) ; bmp exist in ImageList
								$iImages += 1
							Else
								_GUICtrlListView_AddSubItem($hListView, $iZeroBased, "", $i, 1) ; unable to convert tif to bmp
							EndIf
						Else
							_GUICtrlListView_AddSubItem($hListView, $iZeroBased, "", $i, 0) ; executable object
						EndIf
					EndIf
				Else
					_GUICtrlListView_AddSubItem($hListView, $iZeroBased, $aRows[$i], $i)
				EndIf
			EndIf
		Next
	WEnd

	; Reset the original column order of the query
	If $bDisplayObject Then _GUICtrlListView_SetColumnOrder($hListView, $sSetColumnOrder) ; $sSetColumnOrder = something like "1|2|0|3|4|5|6|7"
	;_GUICtrlListView_RedrawItems($hListView, 0, 1)

	; Columns width and alignment
	For $i = 0 To UBound($aNames) - 1
		GUICtrlSendMsg($hListView, $LVM_SETCOLUMNWIDTH, $i, -1)
		GUICtrlSendMsg($hListView, $LVM_SETCOLUMNWIDTH, $i, -2) ; title

		; identify Column position of the Primary Key and hide it if requested
		If $bHidePrimary And StringUpper($aNames[$i]) = $sPrimary Then
			GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, $i, 0) ; Primary key
			_GUICtrlListView_JustifyColumn($hListView, $i, 1) ; right align Primary Key for who wants to see the column
		EndIf

		If _IsBLOB($aNames[$i], $aBLOB) Then GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, $i, $iImageSize + 5) ; fit BLOB column to the size of the image

		; overrule for the example only
		If StringUpper($aNames[$i]) = "TITLE" Then
			GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, $i, 240)
		ElseIf StringUpper($aNames[$i]) = "TYPEOFOBJECT" Then
			_GUICtrlListView_JustifyColumn($hListView, $i, 2) ; center
		ElseIf StringUpper($aNames[$i]) = "BLOB SIZE" Then
			_GUICtrlListView_JustifyColumn($hListView, $i, 1) ; right align
		EndIf
	Next
	_GUICtrlListView_EndUpdate($hListView)
	#endregion ListView

	GUIRegisterMsg($WM_NOTIfY, "WM_NOTIFY") ; new WM_NOTIFY to capture click and double click in this listview

	$hButtonClose = GUICtrlCreateButton("Close", $iGUIWidth - 65, $iGUIHeigth - 30, 50, 25)
	GUICtrlSetResizing(-1, 768 + 64 + 4) ; $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKRIGHT

	GUISetState()
	While 1
		$msg = GUIGetMsg()
		Select
			Case $bGui_ImageView And ($msg = -3 Or $msg = $hButtonClosePreview) ; close $hGui_ImageView
				FileDelete($sFileName) ; delete last image file in temp folder
				GUIDelete($hGui_ImageView)
				$bGui_ImageView = False
				WinActivate($hMainGui)

			Case $msg = -3 Or $msg = $hButtonClose ; Main GUI, exit
				ToolTip("")
				GUIDelete($hMainGui)
				$bGui_ImageView = False
				_SQLite_Close($sDatabase)
				_SQLite_Shutdown()
				Return 1

			Case $msg = $cExecBin
				_ExecBin(GUICtrlRead($cExecBin))
				If @error = 1 Then
					MsgBox(16, "ExecBin Error", "SQLite Error on _SQLite_QuerySingleRow, Get BLOB data" & @CR & "Error: " & @error & @CR &  "Extended: " & @extended)
				ElseIf @error = 2 Then
					MsgBox(16, "ExecBin Error", "Wrong Blob format" & @CR & "Filename not found in BLOB header" & @CR & "Error: " & @error & @CR &  "Extended: " & @extended)
				ElseIf @error = 3 Then
					MsgBox(16, "ExecBin Error", "Unable to create file" & @CR & "Error: " & @error & @CR &  "Extended: " & @extended)
 				EndIf

			Case $bGui_ImageView And $msg = $hButtonExport ; only copy image file if Image Viewer is open
				$Result = FileCopy($sFileName, $sExportFolder, 1 + 8)
				If $Result = 0 Then Return SetError(8, 0, 0)
		EndSelect
	WEnd
EndFunc ;==>List_Viewer
#FUNCTION# ==============================================================
Func _IsBLOB($sFieldName, $aBLOB)
	; identify field types
	If _ArraySearch($aBLOB, $sFieldName, 1) > 0 Then Return True
	Return False
EndFunc   ;==>_IsBLOB
#FUNCTION# ==============================================================
Func WM_NOTIFY($hwnd, $iMsg, $wParam, $lParam)
	; this udf will show a window with the content of a cell. Displays only If the data contains @CRLF (multiline)
	; the udf replaces WM_NOTIFY in Listviewer ($hListView)
	Local $hWndFrom, $iCode, $IDFrom, $tNMHDR, $hWndListView, $tInfo, $sToolTipData, _
			$aTitle, $ColumnOrder, $aItem, $Position, $Rows_to_Clip, $aItem_Rect, $sTypeOfObject, $aRow, $aResult, _
			$StringRemainder, $sDescription, $hFile, $iMaxRows, $sSQL, $iItem
	$hWndListView = $hListView
	If Not IsHWnd($hListView) Then $hWndListView = GUICtrlGetHandle($hListView)
	$tNMHDR = DllStructCreate($tagNMHDR, $lParam)
	$iCode = DllStructGetData($tNMHDR, "Code")
	$IDFrom = DllStructGetData($tNMHDR, "IDFrom")
	$hWndFrom = DllStructGetData($tNMHDR, "hWndFrom")

	Switch $hWndFrom
		Case $hWndListView
			Switch $iCode

				Case $NM_CUSTOMDRAW
					Local $tCustDraw = DllStructCreate($tagNMLVCUSTOMDRAW, $lParam)
					Local $iItem = DllStructGetData($tCustDraw, "dwItemSpec")
					Local $iSubItem = DllStructGetData($tCustDraw, "iSubItem")
					Local $hDC = DllStructGetData($tCustDraw, "hDC")
					Local $iDrawStage = DllStructGetData($tCustDraw, "dwDrawStage")
					Local $iItemState = DllStructGetData($tCustDraw, "uItemState")
					Switch $iDrawStage
						Case $CDDS_PREPAINT
							Return $CDRF_NOTIFYITEMDRAW
						Case $CDDS_ITEMPREPAINT
							If Mod($iItem, 2) Then ;optional alternate row colours, GUI_BKCOLOR_LV_ALTERNATE does not work with customdraw
								DllStructSetData($tCustDraw, 'clrTextBk', 0xE6E6E6)
							EndIf
							Return $CDRF_NOTIFYSUBITEMDRAW
						Case $CDDS_SUBITEMPREPAINT
							Return $CDRF_NOTIFYPOSTPAINT
						Case $CDDS_SUBITEMPOSTPAINT
							Local $iX, $iY, $tSubItemRect
;~ #cs
							; this is just an example used only when the table is 'Image_store'. Displays multiline text in customdraw hardcoded on column 6
							; please remove for other usage
							If $sTable = "Image_store" And $iSubItem = 6 And _GUICtrlListView_GetItemText($hListView, $iItem, 5) = "" Then
								Local $iTxtCol = _WinAPI_SetTextColor($hDC, 0x00BB00)
								;_WinAPI_SetBkColor($hDC, 0x494949)
								_WinAPI_SetBkMode($hDC, $TRANSPARENT)
								If _WinAPI_GetVersion() < '6.0' Then ;In XP the Rect Top and Bottom are always zero in tagNMLVCUSTOMDRAW, so...
									Local $tSubItemRect = DllStructCreate($tagRECT)
									DllStructSetData($tSubItemRect, "Top", $iSubItem) ;get subitem rect for column 4
									DllStructSetData($tSubItemRect, "Left", $LVIR_BOUNDS)
									_SendMessage($hWndFrom, $LVM_GETSUBITEMRECT, $iItem, $tSubItemRect, 0, "wparam", "struct*")
								Else
									$tSubItemRect = DllStructCreate($tagRECT, DllStructGetPtr($tCustDraw, 6))
								EndIf
								DllStructSetData($tSubItemRect, 2, DllStructGetData($tSubItemRect, 2) + 4)
								Local $sTxt = "zero bytes" & @LF & "in the BLOB"
								DllCall("user32.dll", "int", "DrawTextW", "hwnd", $hDC, "wstr", $sTxt, "int", StringLen($sTxt), "struct*", $tSubItemRect, "int", $DT_CENTER) ; $DT_LEFT
								_WinAPI_SetTextColor($hDC, $iTxtCol)
							EndIf
;~ #ce
							If $iSubItem <> 3 Then Return $CDRF_DODEFAULT
							If $iItemState = 0 Then Return $CDRF_DODEFAULT

							If _WinAPI_GetVersion() < '6.0' Then ;In XP the Rect Top and Bottom are always zero in tagNMLVCUSTOMDRAW, so...
								$tSubItemRect = DllStructCreate($tagRECT)
								DllStructSetData($tSubItemRect, "Top", $iSubItem) ;get subitem rect for column 3
								DllStructSetData($tSubItemRect, "Left", $LVIR_BOUNDS)
								_SendMessage($hWndFrom, $LVM_GETSUBITEMRECT, $iItem, $tSubItemRect, 0, "wparam", "struct*")
								DllStructSetData($tSubItemRect, 1, DllStructGetData($tSubItemRect, 1) + 1) ;+2 (+2 for 1 pixel border around icon - combined with row/height 51)
								DllStructSetData($tSubItemRect, 4, DllStructGetData($tSubItemRect, 4) - 1)
								$iX = DllStructGetData($tSubItemRect, 1)
								$iY = DllStructGetData($tSubItemRect, 2)
							Else
								$iX = DllStructGetData($tCustDraw, 6)
								$iY = DllStructGetData($tCustDraw, 7)
							EndIf
							Local $iImgIdx = _GUICtrlListView_GetItemImage($hWndFrom, $iItem, 3) ;get imagelist index only for subitem 3
							If $iImgIdx = -1 Then Return $CDRF_DODEFAULT
							_GUIImageList_DrawEx($hImage, $iImgIdx, $hDC, $iX, $iY, 0, 0, $CLR_NONE, $CLR_NONE, 0)

							Return $CDRF_NEWFONT
					EndSwitch

				Case $LVN_HOTTRACK; Sent by a list-view control when the user moves the mouse over an item
					$tInfo = DllStructCreate($tagNMLISTVIEW, $lParam)
					$iItem = DllStructGetData($tInfo, "Item")
					$subitemNR = DllStructGetData($tInfo, "SubItem")
					If $iItem > -1 And _IsBLOB($aNames[$subitemNR], $aBLOB) Then
						$tInfo = DllStructCreate($tagNMLISTVIEW, $lParam)
						$aItem_Rect = _GUICtrlListView_GetItemRect($hListView, $iItem)
						; On purpose, I am not querying the database to find out if this is an image, I don't think it would be efficient and fast enough.
						; a generic tooltip like the one hereunder should be more appropriate here but for the sake of the example, I differentiate between image nd executable object
						If $bBlowRaw Then
							$sToolTipData = "Click to Preview image"
						Else
							$sToolTipData = "Click to Preview image" & @CR & "or execute the object"
						EndIf
						ToolTip($sToolTipData, MouseGetPos(0) + 20, MouseGetPos(1) + 20)
					Else
						ToolTip("")
					EndIf

				Case $NM_CLICK
					$tInfo = DllStructCreate($tagNMLISTVIEW, $lParam)
					$subitemNR = DllStructGetData($tInfo, "SubItem")

					If _IsBLOB($aNames[$subitemNR], $aBLOB) Then
						$iItem = DllStructGetData($tInfo, "Item")
						If $iItem > -1 then
;	~ 						$Column_attribute = _GUICtrlListView_GetColumn($IDFrom, $subitemNR)
							If $iLastItem = $iItem And $iLastsubitemNR = $subitemNR And $bGui_ImageView Then Return 0 ; if clicked on same cell in same listview
							$iLastItem = $iItem
							$iLastsubitemNR = $subitemNR
							GUICtrlSendToDummy($cExecBin, $iItem)
						EndIf
					Else
						If $bGui_ImageView Then
							GUIDelete($hGui_ImageView)
							$bGui_ImageView = False
						EndIf
					EndIf

			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY
#FUNCTION# ==============================================================
Func _ExecBin($iItem)
	Local $aRow, $iKey, $aResult, $StringRemainder, $sDescription, $hFile, $iMaxRows, $Primary_Key, $sFileextension, $sEndOfFileNameFlag

	If $bGui_ImageView Then FileDelete($sFileName) ; delete previous file in temp folder

	; identify Column position of Primary Key
	For $i = 0 To UBound($aNames) - 1 ; every column
		If StringUpper($aNames[$i]) = $sPrimary Then
			$Primary_Key = _GUICtrlListView_GetItemText($hListView, $iItem, $i)
			;ConsoleWrite(@ScriptLineNumber & " " & $Primary_Key & @CR)
			ExitLoop
		EndIf
	Next

	$sSQL = "SELECT " & $aNames[$subitemNR] & " FROM " & $sTable & " where " & $sPrimary & "='" & $Primary_Key & "'"
	If $iDebug Then ConsoleWrite(@ScriptLineNumber & " " & $sSQL & @CR)
	_SQLite_QuerySingleRow(-1, $sSQL, $aRow)
	If @error Then Return SetError(1, 0, @error)

	If $aRow[0] <> "" Then ; NOT an empty BLOB
		If $bBlowRaw Then
			; $aRow[0] = $aRow[0]  ; raw BLOB
			If StringMid($aRow[0], 3,8) == "89504E47" Then ; png file signature
				$sFileextension = "png"
				$sFileName = _TempFile(@TempDir, "~", "." & $sFileextension)
				$sFileName = StringRight($sFileName, StringLen($sFileName) - StringInStr($sFileName, "\", 0, -1)) ; split filename from path
			ElseIf StringMid($aRow[0], 3,4) == "424D" Then ; bmp file signature 424D
				$sFileextension = "bmp"
				$sFileName = _TempFile(@TempDir, "~", "." & $sFileextension)
				$sFileName = StringRight($sFileName, StringLen($sFileName) - StringInStr($sFileName, "\", 0, -1)) ; split filename from path
			ElseIf StringMid($aRow[0], 15,8) == "4A464946" Then ; jpg file signature 4A464946
				$sFileextension = "jpg"
				$sFileName = _TempFile(@TempDir, "~", "." & $sFileextension)
				$sFileName = StringRight($sFileName, StringLen($sFileName) - StringInStr($sFileName, "\", 0, -1)) ; split filename from path
			ElseIf StringMid($aRow[0], 3,6) == "474946" Then ; gif file signature 474946
				$sFileextension = "gif"
				$sFileName = _TempFile(@TempDir, "~", "." & $sFileextension)
				$sFileName = StringRight($sFileName, StringLen($sFileName) - StringInStr($sFileName, "\", 0, -1)) ; split filename from path
			ElseIf StringMid($aRow[0], 3,8) == "00000100" Then ; ico file signature 00000100
				$sFileextension = "ico"
				$sFileName = _TempFile(@TempDir, "~", "." & $sFileextension)
				$sFileName = StringRight($sFileName, StringLen($sFileName) - StringInStr($sFileName, "\", 0, -1)) ; split filename from path
			Else
				; unknown format
				MsgBox(48, "Cannot View", "Sorry, the object cannot be recognized as an image", 3) ; not an error
				Return 1
			EndIf
		Else
			; split file name and BLOB object
			$sEndOfFileNameFlag = StringInStr($aRow[0], "00")
			If Int($sEndOfFileNameFlag / 2) = $sEndOfFileNameFlag / 2 Then $sEndOfFileNameFlag += 1
			$sFileName = BinaryToString(StringLeft($aRow[0], $sEndOfFileNameFlag - 1))
			If @error Then Return SetError(2, 0, @error)
			$aRow[0] = "0x" & StringTrimLeft($aRow[0], $sEndOfFileNameFlag + 1)
			$sFileextension = StringTrimLeft($sFileName, StringInStr($sFileName, "."))
		EndIf
		$aResult = StringRegExp($aRow[0], "(.{4094}|.{1,4094)", 3)
		$StringRemainder = StringTrimLeft($aRow[0], Int(StringLen($aRow[0]) / 4094) * 4094)

		$sDescription = $sFileName

		If StringInStr(".gif;.png;.jpg;.tif;.bmp;.jpeg;.ico;", $sFileextension) > 0 Then
			$sFileName = @TempDir & "\" & $sFileName
		Else
			; create executable objects in export folder
			$sFileName = $sExportFolder & "\" & $sFileName
		EndIf

		; create object
		$hFile = FileOpen($sFileName, 16 + 2)
		If @error Then Return SetError(3, 0, 0)
		$iMaxRows = UBound($aResult)
		If $iMaxRows = 0 Then ; BLOB contains less than 4094 bytes
			FileWrite($hFile, $StringRemainder)
		Else
			FileWrite($hFile, $aResult[0]) ; "0x" already exists for the first row
			For $ii = 1 To $iMaxRows - 1
				FileWrite($hFile, "0x" & $aResult[$ii])
			Next
			FileWrite($hFile, "0x" & $StringRemainder)
		EndIf
		FileClose($hFile)
		If StringInStr(".gif;.png;.jpg;.tif;.bmp;.jpeg;.ico;", $sFileextension) > 0 Then
			_DisplayImage($sFileName, $sDescription)
		Else
			If $bGui_ImageView Then
				GUIDelete($hGui_ImageView)
				$bGui_ImageView = False
			EndIf
			ToolTip("Executing...", MouseGetPos(0) + 20, MouseGetPos(1) + 20)
			ShellExecute($sFileName, "", @ScriptDir)
			; just don't know how to export (move to @scriptdir on request) these files yet, so I don't delete the objects
			; and I cannot delete here unless I ShellExecuteWait of course
;~ 			FileDelete($sFileName)
			ToolTip("")
		EndIf
	EndIf

	Return 1
EndFunc   ;==>_ExecBin
#FUNCTION# ==============================================================
Func _DisplayImage($sFile, $sDescription)
	Local $window_open, $aGIFDimension, $iOriginalW, $iOriginalH, $aClientSize, $nScale, $iPosX, $iPosY, $sTip, $iGUIWidth, $iGUIHeigth
	$window_open = WinList("Image Viewer") ; check If window already exists
	If $window_open[0][0] = 0 Then
		$iGUIWidth = 500
		$iGUIHeigth = 400
		$hGui_ImageView = GUICreate("Image Viewer", $iGUIWidth, $iGUIHeigth, 5, 5, Default, Default, $hMainGui) ; & StringRegExpReplace($sFile, ".*\\(.*?)\\", "")
		$bGui_ImageView = True
		GUISetBkColor(0xFFFFFF)
		$hButtonExport = GUICtrlCreateButton("Export", $iGUIWidth - 165, $iGUIHeigth - 30, 70, 25)
		GUICtrlSetResizing(-1, 768 + 64 + 4) ; $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKRIGHT
		GUICtrlSetTip(-1, "Export to " & $sExportFolder)
		$hButtonClosePreview = GUICtrlCreateButton("Close", $iGUIWidth - 85, $iGUIHeigth - 30, 70, 25)
		GUICtrlSetResizing(-1, 768 + 64 + 4) ; $GUI_DOCKSIZE + $GUI_DOCKBOTTOM + $GUI_DOCKRIGHT
	Else
		; window already exist so only change the content
		_GIF_DeleteGIF($hGIF) ; first delete the previous image
		GUICtrlDelete($hGIFLabel) ; and delete the image label
	EndIf

	$aGIFDimension = _GIF_GetDimension($sFile)
	$iOriginalW = $aGIFDimension[0]
	$iOriginalH = $aGIFDimension[1]

	$aClientSize = WinGetClientSize($hGui_ImageView)
	; Resize image to fit gui (trancexx)
	$nScale = 1
	While 1
		If $aClientSize[0] - 50 < $aGIFDimension[0] Or $aClientSize[1] - 70 < $aGIFDimension[1] Then
			$nScale /= 1.01
			$aGIFDimension[1] = Round($aGIFDimension[1] * $nScale)
			$aGIFDimension[0] = Round($aGIFDimension[0] * $nScale)
		Else
			ExitLoop
		EndIf
	WEnd
	$iPosX = ($aClientSize[0] - $aGIFDimension[0]) / 2
	$iPosY = 15
	If $iPosY + $aGIFDimension[1] > $aClientSize[1] - 50 Then $iPosY -= $aGIFDimension[1] - $aClientSize[1] + 50 ; not to cover buttons
	$hGIF = _GUICtrlCreateGIF($sFile, "", $iPosX, $iPosY, $aGIFDimension[0], $aGIFDimension[1])
	GUICtrlSetResizing(-1, 768 + 128 + 8 + 32) ; $GUI_DOCKSIZE + $GUI_DOCKVCENTER + $GUI_DOCKHCENTER + $GUI_DOCKTOP
	$sTip = "Size: " & $iOriginalW & " x " & $iOriginalH
	If $nScale < 1 Then $sTip &= @LF & "Resized to fit to: " & $aGIFDimension[0] & " x " & $aGIFDimension[1]
	GUICtrlSetTip($hGIF, $sTip, StringRegExpReplace($sFile, ".*\\", ""), 1)
	$hGIFLabel = GUICtrlCreateLabel($sDescription, 70, $iPosY + $aGIFDimension[1] + 5, $aClientSize[0] - 140, 20, 1) ; $SS_CENTER
	GUISetState()
	Return
EndFunc   ;==>_DisplayImage
#FUNCTION# ==============================================================
; #FUNCTION# =========================================================================================
; Name...........: _ImageResize
; Description....: Resize an image and optionally convert it to the format you want.
; Syntax.........: _ImageResize($sInImage, $sOutImage, $iW, $iH)
; Parameters ....: $sInImage  - Full path to the image to resize / convert.
;                               In types: *.bmp, *.gif, *.ico, *.jpg, *.jpeg, *.png, *.tif, *.tiff
;                  $sOutImage - Full path where to save the resized / converted image.
;                               Out types: *.bmp, *.gif, *.jpg, *.jpeg, *.png, *.tif, *.tiff
;                  $iW        - Width to resize image to.
;                  $iH        - Height to resize image to.
; Return values .: Success    - Return 1 and @error 0
;                  Failure    - Return 0 and @error 1~5
;                               @error 1 = In File does not exist
;                               @error 2 = In File format not supported
;                               @error 3 = Out File path does not exist
;                               @error 4 = Out file format not supported
;                               @error 5 = Resize Width or Height not an integer
; Author ........: smashly
; ====================================================================================================
Func _ImageResize($sInImage, $sOutImage, $iW, $iH)
	Local $hwnd, $hDC, $hBMP, $hImage1, $hImage2, $hGraphic, $CLSID, $i = 0, $sOP, $sOF, $Ext, $sInExt
	Local $sType = "BMP|GIF|ICO|JPG|JPEG|PNG|TIF|TIFF" ; not sure that all tiff formats do convert correctly, I get a black square with the ones I tested

	If Not FileExists($sInImage) Then Return SetError(1, 0, 0)
	$sInExt = StringUpper(StringTrimLeft($sInImage, StringInStr($sInImage, ".", 0, -1)))
	If Not StringRegExp($sInExt, "\A(" & $sType & ")\z", 0) Then Return SetError(2, 0, 0)

	;OutFile path, to use later on.
	$sOP = StringLeft($sOutImage, StringInStr($sOutImage, "\", 0, -1))
	If Not FileExists($sOP) Then Return SetError(3, 0, 0)

	;OutFile name, to use later on.
	$sOF = StringTrimLeft($sOutImage, StringInStr($sOutImage, "\", 0, -1))

	;OutFile extension , to use for the encoder later on.
	$Ext = StringUpper(StringTrimLeft($sOutImage, StringInStr($sOutImage, ".", 0, -1)))
	If Not StringRegExp($Ext, "\A(" & $sType & ")\z", 0) Or $Ext = "ICO" Then Return SetError(4, 0, 0)

	If Not IsInt($iW) And Not IsInt($iH) Then Return SetError(5, 0, 0)

	; Win api to create blank bitmap at the width and height to put your resized image on.
	$hwnd = _WinAPI_GetDesktopWindow()
	$hDC = _WinAPI_GetDC($hwnd)
	$hBMP = _WinAPI_CreateCompatibleBitmap($hDC, $iW, $iH)
	_WinAPI_ReleaseDC($hwnd, $hDC)

	;Start GDIPlus
	_GDIPlus_Startup()

	;Get the handle of blank bitmap you created above as an image
	$hImage1 = _GDIPlus_BitmapCreateFromHBITMAP($hBMP)

	;Load the image you want to resize.
	$hImage2 = _GDIPlus_ImageLoadFromFile($sInImage)

	;Get the graphic context of the blank bitmap
	$hGraphic = _GDIPlus_ImageGetGraphicsContext($hImage1)

	;Draw the loaded image onto the blank bitmap at the size you want
	_GDIPlus_GraphicsDrawImageRect($hGraphic, $hImage2, 0, 0, $iW, $iW)

	;Get the encoder of to save the resized image in the format you want.
	$CLSID = _GDIPlus_EncodersGetCLSID($Ext)

	$sOutImage = $sOP & $sOF
	;Save the new resized image.
	_GDIPlus_ImageSaveToFileEx($hImage1, $sOutImage, $CLSID)

	;Clean up and shutdown GDIPlus.
	_GDIPlus_ImageDispose($hImage1)
	_GDIPlus_ImageDispose($hImage2)
	_GDIPlus_GraphicsDispose($hGraphic)
	_WinAPI_DeleteObject($hBMP)
	_GDIPlus_Shutdown()
EndFunc   ;==>_ImageResize
#FUNCTION# ==============================================================
Func Create_resources()
	; create the export folder
	DirCreate(@ScriptDir & "\Exports")
	; extract the resources
	Local $hFile, $FileName
	$hFile = FileOpen(@ScriptDir & "\Resources\_DatabaseExecute.bmp",16+8+2) ; create folder is needed
	If $hFile = -1 Then MsgBox(48,"Error", "Cannot create resource file")
	$FileName = "0x424D381B000000000000360000002800000030000000300000000100180000000000021B0000C30E0000C30E00000000000000000000FFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFEFEFEFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFEFEFEFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFEFEFEFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFEFEFEFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFAFAF5F5F5F8F8F7FDFCFBFFFFFFFFFFFFFFFFFFFAFBFBF2F4F6EDF1F4EAF1F6" & _
		"EDF5FAFAFFFFD9F6FFE7E9E9FFFFFFFFFFFFFFFFFFFCFCFCFBFBFBFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAF9F9F9FAFAFAF6F6F6FFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9F9FAF4F4F4FEFFFFECF0F2C7C9CAB3B2" & _
		"B1ABABABABAAA9A8A19CA292869D847492786993725F65838E7EBCD894857E9A9FA1C7CCCFF2F2F3F7F7F6F8F8F8FAFAFAFAFAFAF9F9F9F9F9F9F9F9F9F9F9F9" & _
		"F9F9F9F8F8F8F9F9F9F6F6F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8" & _
		"F8F9F8F9F9D5D1CEA89082B69B8CD2C2B8E5DFDDEBE1DBE3CBBAD5AB8DC78C67B97850B16A409D603762C0DB8B999A7E4A2C6F5B4D7E7D7BD3D3D4E9E9E9EDED" & _
		"EDF3F3F3F7F7F7F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9FAFAF3F4F3CA9D82CC9371DDB49DE3CBBCE7D9D1E6D7CEDDC3B2D0A78CC38E6BB87C58B1744EAC5D3284A29897EAFF9A" & _
		"978CB47147937661B9BBBDE1E1E1ECECECEEEEEEF3F3F3F7F7F7F9F9F9F8F8F8F9F9F9F8F8F8F9F9F9F6F6F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFAFBF3F2F1D09E80C38E6ECEA690DDC4B5E8DBD3EADCD4E1C8B7D2AA90C38E6A" & _
		"B77B55AF704AA760388E7355A4ECED80CAE18C8B81C59677D4D8DAD4D4D4E7E7E7F5F5F5F7F7F7F6F6F6F7F7F7F8F8F8F9F9F9F9F9F9F9F9F9F6F6F6FFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFAFBF4F2F2D2A184D09B7BD9B39CE1CA" & _
		"BBE9DBD4EBDCD3E2CAB8D4AD91C58F6CB97D58B1714BA869429857319BCEC49CE5EA62B9D3A6AEA9EFE7E4E2E4E5E5E5E5F0F0F0F7F7F7F9F9F9F9F9F9F9F9F9" & _
		"F9F9F9F9F9F9FAFAFAF7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA" & _
		"FAFBF3F2F2D2A183D19D7DE1BEAAEFDED5F7F2F2F4ECE8E5CFC0D2A98DC18863B4744DAD683EA6653C9C51298C927D8EF0F974CBD757BFE3CBE3ECF8F1EEEDEF" & _
		"F0F1F0F0F2F2F2F7F7F7F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFAFAF3F1F1D2A184D39F80E3C1ADF0DED4F5EEE9F4EBE5EEDED2E6CEBEDDC0ACD5B19AD2AA92CBA288AC724F956D5068" & _
		"D4EB6FD7E758CDE552C2EDDCEFF3FCF9F7F6F8F8F8F8F8F8F8F8F9F9F9F9F9F9F9F9F9F8F8F8F9F9F9F6F6F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFAFAF3F2F1D2A082C68F6CC59271BE8A69B68161B17C5CAF7B5AAD795AAB7757" & _
		"AF7B5DB48366B2866AA7785AAF7450558C9C59D4F250D3EE4AD1F64DC0EDE4F3F8FBFAF9F7F8F8FAF9F9F9F9F9F9F9F9F9F9F9F8F8F8F9F9F9F6F6F6FFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9FAFBF4F4F3AE7C5D884E2D794427723D" & _
		"20703C1F723F237644297A4B317E50377B4D3377482D743F23743B1D843F1C5436273F8DA349D8F840D4F92FC7F44DC0EDEBF6F8FAFAF9F8F9F9F9F9F9FAFAFA" & _
		"FAFAFAF9F9F9FAFAFAF7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8" & _
		"F7F7FBFBFCB8A59B64381F875F48A07D66BA9F8FCDB8ABD4C1B4D5BEAFD1B5A4C9AA97C39D86AD9A87868E856179774E615F2F7A8E40D4F82CCDF735D3F81CBF" & _
		"F357C2EEF5F9F9FAF9F9F8F8F9F9F9F9F9F9F9F9F9F9F9F9F9F6F6F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9F9F9F5F6F6C5A38CC48F6EE6BFA8F5E3D8FEFBFAFCF6F3EBD8C9D7B095C58C68B87B54B9673A82A2916CFAFF36D7FF25" & _
		"D7FF29D4FF26CBF828CCF728CBF72DD0F913B9F167C7EEFBFBF9FAF9F8F7F8F8F8F8F8F8F8F8F9F9F9F6F6F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFBFBF2F1EFD29E7ED4A080E0BDA9EEDDD3F5F0EFF2EBE7E5D0C2D4AE93C48E6C" & _
		"B87B56B16D46A3673F6EDADA65E3F926C9F42ECDF62DCEF82ECEF92FCFF930D0F92AD1F908B4F06FCAEFF4F8F8F7F8F8F8F8F8F8F8F8F9F9F9F6F6F6FFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFAFBF3F3F1D3A184D09C7CE0BDA8EEDD" & _
		"D3F6F1F0F4EDE9E6D1C3D4AE94C48F6CB87B56B0714BB05E327784735CE8FD5AD6F13CD1F343D4F446D7F942D4F741CEF480E2F880E1F762CBF1C5EAF5FAFAF9" & _
		"F8F9F9F9F9F9F9F9F9F6F6F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA" & _
		"FAFBF3F2F1D2A184D29D7DE1BDA9EFDCD4F7F1F1F4EDE9E7D2C3D4AF93C48F6BB87B56B17048A86841A0572F44ABC368E4FB64D6E85EDAF165E1F966E2F83FC1" & _
		"EC97DAF2FFFFFAFFFDF9F9F9F9F9F9F9FAFAFAF9F9F9FAFAFAF7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFAFBF3F2F1D2A184D19D7DE0BDA8EFDDD3F6F0F0F3ECE8E6D1C3D4AE95C5906DB97C57B1714AA76942A35B337F6E5A3A" & _
		"CDF888E0E97ADFEA83EBF883ECF882EAF74BC3EBAEE4F3FFFBFAF6F7F8F8F8F8F9F9F9F8F8F8F9F9F9F6F6F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFAFBF2F2F1D2A083D09C7DE0BCA9EFDED5F7F3F3F4EEEAE5D0C2D1AA8EC18864" & _
		"B4734CAC683EA46035985A36A3552B579EA96CE5FB99E3E395F1F996F0F89AF3F98EEBF658C4EACBEDF5FFFBF9F6F8F8F9F9F9F8F8F8F9F9F9F6F6F6FFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFAFBF3F2F2D3A184D39F80E2C0ABEEDB" & _
		"D0F3E9E3F1E7DFEBD9CDE3CAB8DABBA5D3AD95CDA084BF8E6EA87453A568459C725368DCEA96ECF196F1F797F2F995F1F89DF6FA86E6F460C7EBDDF2F7FEFAF9" & _
		"F8F9F9F9F9F9FAFAFAF7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA" & _
		"FAFBF4F2F1D3A182C48C69C49270C08D6DB88564B37E5EAE7A5AAD7759AB7657AE795AB17E5FB07D5EAB7758AC7C5CB26E4998AA9891FEFF8BEDF684EEF886EE" & _
		"F884EDF88DF4F96BDBF261C8EBEAF6F9FCF9F9F7F8F8F9F9F9F6F6F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFAFBF3F2F1AA75548E533080482A763F20733C1D753E1E7742247B482B7F4D317D4C307A492B7643287543287645297E" & _
		"4A2C8E533189D1CA84F5FC66E6F76AE9F86AE9F968E8F871EEFA4ACFEF65CBECF6FAF9FBF9F8F7F8F9F6F6F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8F8F8F9FAFAAE978A582E1781563CA17559B5927CC5A692CAAA95C9A48BC59A7E" & _
		"BC8C6DB4805FA57050925E4187563B704831643018A1B0A97BF5FD55E0F545DFF849E0F849E0F848DFF84FE4F929C2ED6DCEEFFEFCFAF7F8F8F5F6F6FFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8F9F8F8FAFABEA392AD7D5EE4BDA5F6E3" & _
		"D9FFFCFCFCF7F5ECD9CCD8B297C58E6AB97A53B47147AA683F9F613BA1643EA76E4A8B5C3DC9AB9B8CEAFC47D9F52ED9F82BD7F82CD7F82BD7F82BD7F82FDAF9" & _
		"11B6ED7DD3F0FFFEFAF6F5F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA" & _
		"FBFBF2F2F0D3A081D8A283E1BEAAEDDCD3F6F0EFF3EBE7E5D0C2D4AE93C48F6CB97B56B27048A8663F9A5D399A5E39A26A47AA7653CAA085DCF4FB34C5F626D2" & _
		"F70ACFF80DCFF80DCFF90CCEF80DCFF910CEF800AEEC8AD8F3FCFAF6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9FAFBF3F2F1D2A183D19C7CE1BCA9EEDDD3F7F1F1F4EDE9E6D2C3D4AF93C48F6CB97B56B27148A8663F9C5E399C5F3AA2" & _
		"6A47A7734FC1A189FFFDFB93D9F54BCCF347CFF540CDF53DCCF53ACBF536C8F532C8F62AC1F336BDF1D9F0F5FEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFE" & _
		"FEFEFEFEFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFAFBF3F2F1D3A083D19D7DE1BCA8EEDDD3F6F1F0F4EDE8E6D1C2D3AD92C38D69" & _
		"B77954B06E45A5643B9B5D389C5F3BA36A46A77350C3A189F9FAFBFCFAF8EFF5F7EFF3F7F0F4F7F0F4F7F0F4F7EEF4F7ECF3F7EBF3F6F2F7F8F3F4F4FFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFEFEFEFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFAFBF3F2F1D3A185D29E7FE2BEABEFE0" & _
		"D7F8F4F4F5EFECE7D5C8D7B39AC79574BC825DB57751B27A579E633E995C37A16944A8734FC4A188FAFBFBF8F9F9FCFBFAFCFBFAFCFBFAFCFBFAFCFBFAFCFBFA" & _
		"FCFBFAFCFAF9FCFAFAF5F5F5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA" & _
		"FAFBF3F2F2D19D7ECD9674DAB49BE1C8B7E5D2C5E7D4C6E4CFBFE1C8B8DEC2B1D8B8A3DABCA6E2CCBCB68769AA7352A97352A87552C4A38BFAFAFBF8F9F9F9F9" & _
		"F9F9F9F9F9F9F9F9F9FAF9F9FAF9F9FAF9F9F9F8F8F8F9F9FAF5F5F5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFAFBFBF1EFEED2AA8FDABCA8E2CCBBE1C9B8DEC2AFD8B69FD1A98DCC9F81C69675C28D6AC18B67C18B68BE835FBC825DBD" & _
		"825EAF6F49BD9276FAFBFCF8F8F8F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F9F8F8F8F9F9F9F4F4F4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9FAFAF4F5F5F0E7E1EADBD1E6D5C6E2CBBADBBDA8D6B39BD3AC92CFA488CC9E7F" & _
		"C99777C6916FC18965BD825EBB7D56B97B53B97C56DBC0AEFAFBFBF9F9F8FAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAFAF9F9F9FAFAFAF5F5F5FFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEF9F9F9F2F2F2F6F7F7F2F1EFEFEBE7EBE2" & _
		"DBE6D8CEE3D0C3DFC9BADBC2B2D6BCAAD5B7A4D4B5A1D5B5A1D6BBA9DDC8BAE5D8D0EFEEECF8FCFDF5F5F5F6F5F5F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6F6" & _
		"F5F5F5F5F5F5F6F6F6F1F1F1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFD" & _
		"FDFDFAFAFAFBFBFAFBFCFCFCFDFEFDFEFFFDFFFFFDFFFFFDFEFFFCFEFFFCFEFFFCFFFFFDFFFFFEFFFFFFFFFFFFFFFFFFFFFFFDFDFEFBFAFAFBFBFBFBFBFBFBFB" & _
		"FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFAFAFAFBFBFBFAFAFAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFEFEFFFEFEFFFEFEFFFFFEFFFEFEFFFEFEFFFEFEFEFEFDFEFEFDFEFEFDFF" & _
		"FEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000"
	FileWrite($hFile,$FileName)
	FileClose($hFile)
	$FileName = ""

ConsoleWrite(@ScriptLineNumber & @CR)
	$hFile = FileOpen(@ScriptDir & "\Resources\_Unsupported.bmp",16+2)
	If $hFile = -1 Then MsgBox(48,"Error", "Cannot create resource file")
	$FileName = "0x424D761A00000000000036000000280000002E000000300000000100180000000000401A0000C40E0000C40E00000000000000000001FFFFFBFFFFFBFFFFFC" & _
		"FFFFFCFFFEFFFFFEFFFFFEFFFDFEFFFFFDFFFFFDFFFFFDFFFFFDFFFFFDFFFFFDFFFFFDFFFFFDFFFFFDFFFFFCFFFFFBFFFFFDFFFFFFFCFFFFF9FFFFF9FBFFFCFA" & _
		"FFFFFAFEFFFFFCFFFFFDFFFDFFFFFBFFFCFAFFFCFAFFFCFAFFFEFDFFFEFFFDFFFFFDFFFCFDFFF9FEFFFAFFFFFBFFFFFFFFFEFFFFFCFDFFFBFBFFFBFFFFFEFFFF" & _
		"FE0000FFFFFCFFFFFCFFFFFEFFFFFEFFFEFFFFFFFFFDFFFFFBFFFFFDFFFFFFFEFFFFFEFFFFFEFFFFFEFFFFFFFFFFFFFFFFFFFFFFFEFFFFFDFFFFFDFFFFFDFFFF" & _
		"FFFCFFFFFBFFFFFBFDFFFCFDFFFFFFFDFFFFFDFFFFFDFFFFFFFEFDFFFCFDFFFCFBFFFEFDFFFEFFFFFFFFFEFFFFFEFFFDFEFFFBFEFFFBFFFFFBFFFFFFFFFEFFFF" & _
		"FCFFFFFCFDFFFCFFFFFEFFFFFE0000FFFFFFFFFFFFFDFFFFFDFFFFFDFFFFFBFFFFFAFFFFF8FFFFF4FFFEF8FFFEFFFFFCFFFFFCFFFFFCFFFFFBFBFFFBFBFFFCFF" & _
		"FFFEFFFFFFFDFFFFFDFFFFFFFFFEFFFFFEFFFFFEFFFEFFFFFDFFFFFDFFFFFDFFFFFEFFFFFFFEFFFFFCFFFFFEFFFFFEFFFEFFFFFEFFFFFEFFFDFEFFFDFEFFFDFE" & _
		"FFFDFFFFFDFFFFFFFFFEFFFFFCFFFFFCFFFFFCFFFFFEFFFFFE0000FFFEFFFDFFFFFDFFFFFBFFFFFBFFFFFAFFFFFBFFFFFAFFFEF6FFFEF8FFFCFFFFFCFFFFFCFF" & _
		"FFFBFFFFFBFAFFFBFAFFFBFFFFFBFFFFFCFBFFFEFAFFFFFDFFFFFFFEFFFFFEFFFFFEFFFFFDFFFFFEFFFFFEFFFFFFFEFFFFFEFFFFFEFFFFFEFFFEFFFFFEFFFFFD" & _
		"FFFFFEFFFDFFFFFFFEFFFFFEFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFEFDFFFEFBFFFFFAFFFF0000FFFDFFFFFEFFFFFEFFFFFEFFFBFFFFFCFEFEFFFDFEFFFEFDFC" & _
		"FFFDFAFFFDFAFFFDFCFFFDFFFDFEFFFDFEFCFEFEFAFFFDFDFFFBFDFFF9FBFFFCFBFFFEFBFFFFFDFEFFFDFEFFFDFEFFFBFFFFFBFFFEFBFFFCFBFFFCFDFFFEFFFF" & _
		"FFFFFEFFFFFEFFFFFEFFFFFEFFFFFFFFFFFFFFFFFFFEFFFFFEFFFFFEFFFEFFFFFDFEFFFEFFFBFFFFF6FFFFF3FFFFF1FFFF0000FFFDFFFFFDFFFFFEFFFDFFFFFA" & _
		"FEFFFCFEFEFFFDFEFFFEFDFFFFFEFFFFFEFBFFFEFDFFFFFFFEFFFFFEFFFDFFFFFBFFFFFEFFFAFCFFFAF9FFFBF7FFFDFBFEFFFDFDFFFFFDFFFDFEFFFAFFFFF8FF" & _
		"FCF8FFFCFAFFFCFDFFFFFFFEFFFFFEFFFFFEFFFDFEFFFDFFFFFFFFFFFFFFFEFFFFFCFFFFFCFFFFFEFFFFFEFFFCFFFFFCFFFFFEFFF8FEFFF3FFFFEFFFFF0000FD" & _
		"FDFFFDFDFFFDFEFFFBFFFFF9FFFEF9FFFDFEFFFDFFFFFBFFFFFCFFFFFCFFFFFCFFFFFEFFFFFEFFFFFFFAFFFFFAFFFFFFFDFCFDFEFAF3FFFDF2FFFEFAFDFFFFFC" & _
		"FFFFFBFFFFFDFFFEFFFDFAFFFBF7FFFBF9FFFDFFFDFFFFFCFFFFFBFFFEFCFFFEFCFFFEFDFFFEFEFEFCFFFDFAFFFBFAFFFBFAFFFDFEFFFDFFFCFFFFFCFFFFFBFF" & _
		"FFFDFFFBFEFFF8FFFF0000FDFEFFFBFFFFFBFFFFFAFFFFF7FFFDF9FFFDFCFFFDFFFFFBFFFDFAFFFDFAFFFDFCFFFDFCFFFDFDFBFDFDF9FDFEFBFDFEFFFCFDFFFD" & _
		"FDF6FEFDF5FFFEFAFDFFFFFCFFFFFBFFFFFDFFFEFFFDFAFFFDFAFFFDFCFEFEFFFCFFFFFCFFFFFCFFFEFDFFFBFBFFFBFCFFFAFCFDFAFCFCFAFDFBFAFDFBF9FEFC" & _
		"FBFDFDFFFDFFFFFCFFFFFCFFFFFDFFFFFFFFFDFFFF0000FFFFFEFCFFFDFAFFFDF7FEFBFAFFFEF7FCFAFDFFFEFFFDFEFFFDFFFFFCFFFEFDFFF8FBFFFFFDFFFFFD" & _
		"FFFFFBFFFFFCFFFFFDFFFFFBFEFFFDFFFFFEFFF7FBFCFBFFFFFAF9FBFFFFFFFAFFFFF8FEFDFCFCFCFFFFFFFCFBFDFFFEFFFEFDFFFCFEFFFAFFFFF7FCFFFAFFFF" & _
		"FBFDFDFFFDFEFFFEFFFFFDFDFFFEFFFDFFFFFCFEFFFFFDFEFFFFFEFFFFFCFBFFFB0000FFFFFCFFFFFBFDFFFEF9FEFCFCFFFDFAFDFBFAFCFCF1EFEFFFEEF2FFFA" & _
		"FEFCF5F8F1ECEEE5DADDE2D4D6F1E0E3E6D5D8E6DBDDEBE3E4F1E8EBF8F3F5FBFFFFF6FCFBFCFEFEFBFDFDF4FCFBFAFFFFFFFFFFFFFAF9FBF8F4FDF9F4FBF2EE" & _
		"ECE3DFDFDAD7E4DFDCE2D9D6EADEDCE8DADBF2E8E8F4EFF1F7F9FAFBFFFFFAFEFFFCFEFEFDFFFEFDFFFCFDFFFB0000FFFEFAFFFFFAFFFFFCFEFFFDFFFDFCFEFE" & _
		"FEF8FDFCE1E1E1FBF1F1FFFDFCFFFBF9FBE0DCDDC0B9C09F96C4A096C2A39AA79A929E9996BBB5B6DDDADCF5FAF9F6FBF9FBFCFAFBFCFAF8FCFDF3F7F8FAF8F7" & _
		"FFFCF5FFFFF3FFFBEBF4D6CBD2B0A3C6A798C2A394C49D94BB9993BAA7A2C2BBB8EAE8E8F4F6F7FFFEFFFAFDFFF7FFFFF8FFFFFDFFFFFFFFFF0000FFFFFCFFFD" & _
		"FAFFFFFEFEFFFDFFFBFCFFFEFEFBFFFFDCE0DBEAE4DDBCA29BC68E83D78E80C27663BF7258AA5A3DA76247B1816FAB9086A79E9AC0C2C2E3E6E4F8FBF9FCFBF7" & _
		"FFFDFCFBFCFFF9FBFCFBF8F3FFFFF2FFF0DAD3947FC0705FB7614FB15C46A85742AD6050995F53AD968ED9D6D1DCDEDEF7FBFCFFFDFFFEFDFFF5FEFFF6FFFFFD" & _
		"FEFFFFFDFF0000FDFFFFF8FDFCFAFFFFFAFFFFFEFBFDFFFDFDFFFFFEE0E3DAF5F5E5D8B09D9C2C18B52109C02C08C63206C22E00B62D00B54729C7826FA09084" & _
		"9CA39EC6C9C7EEEFEDFEFFFDFDFDFDF9FCFFF6F8F9FDF9EEFFFFEDF69579B0280CC3250ED02914CD280FC52D14A82D19A35140DFC3B8EBEEE5E1EAE7ECF4F4FF" & _
		"FDFFFFFCFFF9FEFFF8FFFFFDFDFFFFFDFF0000FAFFFFF5FDFCF5FFFFFAFFFFFFFCFFFFFBFDFFFFFFE1E1DBF1F2E2FFFFEDF68973C02407E93611EF3303EE3200" & _
		"E53401C72E07C15339BB9283A29C95B0ADA9D8D6D5F4F2F1F8F8F8F5F8FDFBF6F7FFFFF2FFC2A7C33B17DB2803EF2B0DF4290EF12B0FDB2E14B23820ECA492FF" & _
		"EADEF8FCF6E8EEEDF2F7FAFFFEFFFFFDFFFEFDFFFFFEFFFFFEFFFFFDFF0000FCFFFDFAFFFDF9FEFFFBFEFFFFFBFFFFF8FFFFFBFFE2DCE1EFF0ECFFFBEFFFEEDD" & _
		"C9634CCC2308F92F10F02902F13205E7360BB92D09C06D5EB68B88A29391BBB6B7E8E0E1FDF8FAF0F2FAFFFDFEFFDED0BF5133CC2E00F13504F12D03F5330EE3" & _
		"2B0DBB2C10DE977CFBE3CDFEF9F0FAFCFCE3DFE5F6F4FAFBFFFFFCFEFEFFFEFBFFFFFBFFFFFBFFFFFB0000FFFEFDFFFFFFF9FEFFFAFDFFFFFBFFFFFAFFFFFBFF" & _
		"E0DCE2EDF1F2FCFCF6FFFFF3FFD4C4C63C2ADB260DF02C0AF42C02F13205D53009B63925C8776FB4908AA89C9AD5CACCF0E5E8FFF8FBFFF2EFDF7766BF2D0AE6" & _
		"3403F33400F12F00E02D06C42F14CF6A54FFDEC8F8F6E4FAFAF4FCFBFDF0E9F0F7F3F9FAFFFFFAFFFDFFFFFAFFFFF9FFFFF9FFFFF90000FFFEFFFFFEFFF7FDFF" & _
		"F8FEFFFFFDFFFFFCFEFFFEFFE0E0E0EAF2F1F6FCFBFEF9F8FFFDF7FDA597B83018E02907FC3007F22E06E8310ACD2A0AC2462ECC917EA69085AD9FA3DDCBD2FF" & _
		"F4F2F2A095BA260EEA3410EC2E00EB2D00F43808C02401AE5241F0C1B9FFEAE4FFFCF5FFFDF9FBF9F9EBEBEBF6F6F6FBFFFFFCFEFEFFFEFDFFFFFEFFFFFEFFFF" & _
		"FE0000FFFDFFFFFEFFF9FEFFF8FFFFFFFEFFFFFDFCFFFFFCE0E1DDE6ECEBF9FEFFF5F6FAFFF7F8FFF9EEDF846FC52A09ED3009E92700EE2D05E92E08C52D0ABD" & _
		"6144C59381AA9391CBADACF9ADA1B93C27D92708FA310AF13102E83204D83007BD3F23E1A89FFEECEBFFF6F7FFFBFBFFFBFAFDFBFAE8EBE9F5F8F6FDFFFFFCFE" & _
		"FEFEFEFEFFFFFFFFFEFFFFFEFF0000FFFFFCFFFFFEFAFFFEFAFFFFFFFFFEFFFDFAFFFFFBE2E1DDEFECEEFFFEFFF6F9FEF8F6F6FFFFF7FFEBD9CC583FCA2B09E9" & _
		"3208EF2D00F03306DB3108BA2F0ECC6C54BF9588C49383BD472AD42E09F4330BEE2600ED2F06DA330EB12A0EE78B78FFDDD8FFF8F9FFF5F5FDF8F7FEFCFBFCFF" & _
		"FDE7E9E9F4F9F8FDFFFFFCFEFEFEFEFEFFFFFFFFFEFFFFFEFF0000FFFFFBFFFFFBFCFFFBFDFFFEFFFFFCFFFDFAFFFFFCE4E0DFEFE8EBFFFDFFFBFBFFF7FCFDF5" & _
		"F9F3FFFFF0FFC8B4BD4226D73108EE2F00F13102E32C02DC330EBF371AD68268BD6345C52A03ED2E01F83103F02C02E3310EB9290DD0725FFFD4C9FFF1ECFFF8" & _
		"F8FCF8F7FEFCFBFCFFFDFBFFFEE1E6E5F2F7F6FDFFFFFEFEFEFFFEFEFFFFFFFFFEFFFFFEFF0000FFFFFBFFFFFBFFFFFBFFFFFCFFFFFCFDFEFAFFFFFCE2E0DFF8" & _
		"EFF2FFF8FDFCFBFFFAFEFFFBFFFCF9F4EBFFFFF2F5A993BF300BEC3509EE2D02F23109EC330DD82F0ADA441CD63C13E83306ED2800F72F00F3370EC4280AC050" & _
		"3CF9C7BBFFF1EBFFFAF7FAFBF9FDFEFCFBFEFCF9FEFCFAFFFDE2E7E6F4F9F8FDFFFFFEFEFEFFFEFEFFFFFFFFFEFFFFFEFF0000FFFFFEFFFFFEFFFEFDFFFFFEFD" & _
		"FFFEFBFEFCFDFFFEE2E0E0F8F2F3FFFAFDFEFBFDFDFDFDF8F9F7FFFFF9FFFCF5FFFAEBF08167BF2300EC340CF22E06F3310CE72801E92F00F13302F42F01F934" & _
		"08F73408CF2600B63C24F1AA9CFDEAE2F1F7F2F6FBF9F4F9F7F7FCFAF5FAF8F7FEFBFAFFFDE4E9E8F7F9F9FFFFFFFEFEFEFFFEFEFFFFFFFFFEFFFFFEFF0000FB" & _
		"FEFFFDFFFFFFFDFFFFFFFFFBFFFFF8FEFDFDFFFFE0E0E0EAE8E8FFFEFFFFFEFDFFFDFDFFFCFCFFF9F9FAFBF7FFFAF3FFE3D8C95943CE2805EF2E06EE2804F42D" & _
		"06F33101F02F00F83307E82700E32E07BC2E0FCC8375FADED7FFFDF3F5FDF6F7FEF9F8FDFBFAFFFDF7FCFAFBFFFEFAFFFDE6E8E8F6F6F6FFFFFFFFFEFEFFFEFE" & _
		"FFFFFFFFFFFFFFFFFF0000FBFEFFFBFEFFFEFDFFFFFEFFFBFFFFF9FDFEFDFFFFE0DFE1F0F0F0FFFFFEFFFEFBFFFCF9FFFEFEFFF9FAF8FCFDFEFAF9FFFBF8FFCE" & _
		"C0C4381BE12E09F2300BF32D03F53000F42F00F12B01E82E0CCC2C0CCD5E44DAB0A4E1DDD8F3F7F1F8FFF8F5FBF6F7FCFAF9FEFCF8FBF9FCFFFDF9FCFAE8E8E8" & _
		"FAF8F8FFFFFFFFFEFEFFFEFEFFFFFFFFFFFFFFFFFF0000FDFEFFFBFEFFFBFEFFFDFEFFFEFDFFFEFDFFFFFEFFDFDEE0EDEDEDFFFFFEFDFCF8FEFDF9FFFDFCFCFB" & _
		"FDF9F8FCFFFBFFFFF7F7FFFAF2FF9D89CB2F11E5330AEE2F00F33100F42F00F62C07DE2B0ECB4A2FD48570BFA293C6C4BCEAEBE9F8FAFAFBFEFCFAFDFBF9FCFA" & _
		"FDFEFCFEFCFCFFFEFEEBE9E9F8F6F6FFFFFFFFFEFEFEFEFEFFFFFFFFFFFFFDFFFF0000FFFEFFFFFEFFFBFFFFFAFEFFFEFDFFFFFEFEFFFFFFDDDFDFEEF1EFFCFF" & _
		"FDFCFDFBFDFFFEF3F7F8FAFDFFFFFDFFF7F3F8FCF8F7FFF8EEFFBEACC93011E22E04F33200F43000F83100FD330CDA2708C8472CE0917CB39687A7A49CCDCDCD" & _
		"F1F3F4F8FAFAFCFDFBFBFCFAFFFDFCFFFCFDFFFCFDECE7E8FAF5F6FFFFFFFFFEFEFEFEFEFFFFFFFDFFFFFDFFFF0000FFFFFCFFFFFEFEFFFDFAFFFEFEFEFEFEFF" & _
		"FDFFFFFEDDE0DEE9EEECFBFFFEFAFCFDFBFFFFF9FDFFEEF4F9F6FCFFFCFEFFFFFFF8FFE4D4D04F34DB2B07F43006F62A00F62C00F82D00F72C00EE2F08CE2D0D" & _
		"CA5A43C095869C9691AFAEB0D7DADEF5F4F6FEFCFCFDFBFBFFFBFCFFFDFEFFFEFFECE6E7FBF6F7FFFFFFFFFEFEFEFEFEFDFFFFFDFFFFFDFFFF0000FFFFFBFFFF" & _
		"FBFFFEFDFCFFFDFEFFFDFBFEFCFDFFFCDBE1DCE9EFEAFAFFFEFDFEFFF8F8FEFBFEFFFAFEFFF3F7F8FFFAF6FFF6E8C9745EB72000E92C05F82E05FF360CEB2300" & _
		"F73107F12A00F53409E02B04B4280BBC7260B0938AA49A9ABABCBDE7E7E7FAF8F8FDFBFBFFFAFBFFFDFEFFFEFFEDE7E8FBF6F7FFFFFFFEFEFEFCFEFEFDFFFFFD" & _
		"FFFFFDFFFF0000FFFFF8FFFFFBFFFEFDFEFEFEFEFEFEFBFEFCFDFFFBDBE2DBEEF4EFF7FCFBFAFBFFFBF9FFFDF9FEFFFDFEF3EDE8FFFFF2F89D88B32B0EDF340E" & _
		"EC2B03F12C06F12C06E92C06E52B03F3340DEB2A02F3350AD32E07B23B21CD8272AF938CA4A09FCACACAEAEAEAFCFAFAFEFCFCFFFCFDFFFDFEEBE6E7F9F7F7FF" & _
		"FFFFFCFEFEFCFEFEFDFFFFFDFFFFFFFFFF0000FFFFFAFFFFFCFFFEFEFEFDFFFFFDFFFDFDFDFDFFFBDAE2D8EDF1EBFDFFFEFAFBFFFAFBFFFCF9FBFFF4F0FFFFF4" & _
		"FFCCBABF371BD52703EF350CF23207ED330BD32501E44F2DD6411FD22500EB2F06EE2F00E53205C82D0CC6543DC18A7DA8968FAEABA7D1D3D3F2F2F2FFFDFDFE" & _
		"FCFCFEFCFCE9E7E7F9F9F9FDFFFFFAFFFEFAFFFEFDFFFFFFFFFFFFFFFF0000F9FFFDFAFFFFFAFDFFFEFBFFFFFAFFFFFBFEFDFFFCDAE2D8ECECE6FEFCFBFDFFFF" & _
		"FAFEFFF4FAF5FFFFF5FFE9DAC7503ADC2C0DFB320BED2C00EB3206D82C02C03814FFB598FFAF92C4300CEA340AE83002E42B00E5320BC02A0BC0634CBF9284A2" & _
		"9690B2B7B6D9DBDBF5F5F5FBFBFBFCFCFCE8E8E8F7F9F9FBFFFFFAFFFEFAFFFEFDFFFFFFFFFFFFFFFF0000F7FFFEF8FFFFFAFCFFFFFBFFFFFAFFFFFBFEFBFFFE" & _
		"D9E0DBF1F2EEFFFFFEF8F7F9FBF9F8FFFEF3FFFDEBE27A63C32A0BEA2B04FC2F02F02D01E13309C53512E18064FFE1CEFFF8E2E87C5AC52800E53409EF3106EA" & _
		"2C03D72B07B43516C97863AB8E85A5A1A0C4C2C2E9E6E8FBF8FAFDFCFEE6E8E8F3F8F7FAFFFEF9FFFDFCFEFEFFFFFFFFFEFFFFFEFF0000FDFFFFFDFFFFFEFDFF" & _
		"FFFCFFFFFCFFFBFDFEF7FFFED5E0DEE8EFF2F8FBFFFEF9FBFFF6F3FFFDEDFAAD93B82909E63209E93000ED3000EF3003CA2706D06752FFCBC1FEE8E3FFFEF3FF" & _
		"EBCEB94E28D02C01F9390EE72B02E33009D52F0AC04529BD8677A28F8AB2A4A6D0C6CCF1EAF1FFFDFFDFE4E3F5FCF9FAFFFCFAFFFBFEFFFDFFFEFFFFFDFFFFFC" & _
		"FF0000FFFEFFFFFEFFFFFCFEFFFDFFFCFEFFF9FDFEF8FFFFDBE3E3E6EDF0FCFEFFFCF5F2FFFAF1FFD4C0B23E1FE0350FED2B00F53B05E23100D42E07C7462BF3" & _
		"B1A6FFE5E4FFF6FAFFFBF9FFFFECFFC3A4BC320EDA2A02EB330BE62A01EF3106C82907B95E49BB8D82AD908CB8ABADE1DDE2F1F2F6E6E8E9F5F8F6FBFFFCFAFF" & _
		"FBFEFEFEFFFEFFFFFCFFFFFCFF0000FFFDFFFFFDFFFFFDFFFFFFFFFDFFFFF8FDFCFDFDFDDEDEDEF0F2F2FFFFFCFFF9ECFFEFDDCF5F48C6280AEB2E07F93103EF" & _
		"2D00DF380DAC3012E19382FEE0DBFEF7FAFEF6FDFDF7FCFCFAF2FFFFEFE4846CBC2B0BE43209F62F01F22600EB330BB62B10C86F5AC4998AA69C92B4BAB5E1E7" & _
		"E6ECE9EBFEF9FAFFFFFFFCFEFEFCFEFFFFFDFFFFFCFFFFFCFF0000FFFCFFFFFDFFFFFDFEFFFFFEFFFFFEFFFDFCFFFDFDDEDCDCE8E9E7FFF9F3FFFFF1DF927FB3" & _
		"2912E23416E9300AEF320BEB340DBB2808D5816FFFDCD4F3EBEBF6FBFEF7F5FBFAF9FDF6FBFCFFFAF4FFEEDEC85A40CA2805F4330BFA3207F2330CD32D0EBD43" & _
		"2BDEA28CCFBDACCACBC2DBE2DFEDE8EAF8F1F4FFFEFFFAFDFFFAFDFFFFFDFFFFFDFFFFFCFF0000FBFEFFFDFEFFFDFDFDFFFCF8FFFBF9FFFEFEFFFEFFDCE0E1F1" & _
		"F4F2FFFEF8FFAEA6A02618BE2712C11F03D12E0EC9290BB91E07D86354FFE4DDFEF8F9F8F7FBF8FBFFF8FCFDFBFDFDFAF9FDFFF7F9FFF7F0FFCCBBB9331BCE26" & _
		"07DB2C0BCF1D00D32409B4260FB35D49FFE2D3F4E7DFF2F0EFE7E2E4FDF9FEFBFEFFF7FDFFF9FDFFFDFEFFFFFDFFFFFDFF0000F9FEFFFAFFFFFEFFFDFFFEFAFF" & _
		"FCFCFFFCFDFBFEFFD6DDE0EBEBEBFFF0ECCC7E77C2564AD6604DDA634DD5634CD26550CB6356FFD0CAFFFAFBF4F9FCF9FAFEF7F6F8F7FCFAF7FCFAFFFEFFFFFA" & _
		"FCFFF8F5FFFBF3FBA294D15B48DD6650DF634BE4624BC95844A55F4EEBC5B9FFFEF8FFFEFDECEBEDF4F5F9FAFFFFF9FEFFF9FEFFFDFEFFFFFEFFFFFEFF0000F9" & _
		"FEFDFAFFFEFFFFFEFFFFFEFFFFFFF6FAFBF4FDFFDDE1E6F0EBEDFFF4F2FFEAE3FFF0E3FFF5E6FFF3E1FFEDDEFFEEE1FFF5F0FFF3F2F9F3F4F7F6F8FBF6F7F8F4" & _
		"F3FBFBF5F7FBF5E9F5EFEFF8F5F6F7F5FDF0EEFFFAF5FFEEE6FFECDDFFF7E6FFF2E2FFF9EAFFF0E5FBF1EAF9FAF8F1F7F6DFE4E7EEF3F6FDFEFFFEFDFFFEFDFF" & _
		"FFFEFFFDFFFFFBFFFF0000FDFFFCFCFFFBFEFCFBFFFFFFF8FDFEF0F9FCF6FFFFEFF3F8FBF6F8FFFBFBFFFFFBFAFDF4FEFFF5FFFEF4FFFEF6FFFFFBF6FCFBF6FC" & _
		"FBFBFCFAFFFFFBFCF8F7FFFBFAFDFBFAF9FDF8F4FFFAF0FCF6F8FDFCFDFCFEF5F4F6FDFFFFF2FCF6F5FFF8FBFFF9F6F7F3FDFFFEF7FCFBF6FBFCF3FBFBF1F9F9" & _
		"FBFFFFFFFEFFFFFEFEFFFDFEFFFFFFFDFFFFFAFFFF0000FFFFF9FFFFFBFFFFFEFFFEFFFBFEFFFAFEFFFAFFFFFBFFFFFFFEFEFFFDFEFCFEFEFAFFFEFAFEFFFCFE" & _
		"FFFCFEFFFCFEFFFDFFFFFDFFFEFDFFF9FFFFF8FFFFFCFFFFFFFDFEFFFDFEFFFBFFFFFBFFFEFBFFFFFBFFFFFFFDFFFFFDFFFFFEFFFFFEFFFFFDFFFFFCFFFFFDFF" & _
		"FDFEFFFBFEFFFBFFFFFDFFFFFFFFFFFFFFFFFFFFFEFFFFFEFFFFFEFFFFFFFFFFFF0000FFFFF8FFFFFBFFFFFFFFFEFFFBFEFFFAFEFFFBFFFFFDFFFFFFFEFDFFFE" & _
		"FDFCFEFFFAFDFFFAFDFFFAFDFFFCFDFFFEFDFFFFFEFFFFFFFEFFFFF8FFFFF8FFFFFCFFFEFFFDFCFFFDFCFFFFFEFFFFFFFFFDFFFEFBFFFFFFFEFFFFFDFFFFFDFF" & _
		"FFFCFFFFFAFFFFFBFFFFFDFFFDFEFFFDFFFFFFFEFFFFFFFFFFFFFFFFFFFEFDFFFEFFFFFCFFFFFCFFFFFEFFFEFF0000FFFFF9FFFFFBFFFEFFFDFEFFF8FEFFF8FF" & _
		"FFFFFFFEFFFFFCFFFFFBFFFFFCFFFEFFFFFEFFFFFEFFFFFEFFFFFEFFFFFFFEFFFEFFFFFFFEFFFFFBFFFFFBFFFFFEFFFDFFFFFBFFFFFBFFFFFDFFFFFFFFFFFFFC" & _
		"FDFFFBFFFFFEFFFFFEFFFEFFFFFEFFFFFDFFFFFDFFFFFFFEFDFFFEFFFFFCFFFFFEFFFEFFFFFEFFFFFFFFFDFFFEFFFFFCFFFFFCFFFFFEFFFFFE0000FFFFFBFFFF" & _
		"FCFFFEFFFDFEFFFBFEFFFBFFFFFFFFFCFFFFFBFFFFFBFFFFFBFFFFFEFFFFFFFDFFFFFFFFFFFFFFFEFFFFFCFFFEFFFFFEFFFFFFFEFFFFFEFFFEFFFFFDFFFFFDFF" & _
		"FFFDFFFFFDFFFFFEFFFFFFFCFDFFF9FFFFFBFFFFFCFDFFFFFDFFFFFFFFFFFFFFFEFDFFFBFDFFFBFFFFFBFFFFFCFFFFFEFFFEFFFFFEFFFDFFFFFFFFFEFFFFFCFF" & _
		"FFFCFFFFFC0000FDFFFFFDFFFFFDFFFFFFFEFFFFFEFFFFFEFEFFFFFCFFFFFCFFFFFCFFFFFCFBFFFEF8FFFEF8FFFEFBFFFEFFFFFCFFFFFCFFFEFFFFFEFFFBFEFF" & _
		"FAFFFFFBFFFFFBFFFFFBFFFFFDFFFFFFFEFFFFFFFEFDFFFCFBFFFBFBFFFBFDFFFCFFFEFFFFFEFFF8FFFEF6FFFCFBFFF9FDFFF9FFFFF9FFFFFBFFFFFFFFFEFFFF" & _
		"FEFFFFFEFFFFFFFFFFFFFCFFFFFCFFFFFB0000FBFEFFFBFEFFFDFFFFFFFFFFFFFEFEFFFFFCFFFFFEFFFFFEFFFFFEFFFFFFFAFFFFF8FFFEFAFFFEFBFFFCFFFFFC" & _
		"FFFFFEFFFEFFFDFDFFFAFEFFF8FEFFFAFFFFFAFFFEFBFFFCFFFFFCFFFEFEFFFEFEFDFFFEFAFFFEFAFFFEFBFFFEFFFEFFFFFEFFF6FFFFF6FFFEFBFFFBFFFFF9FF" & _
		"FFF9FFFFFCFDFFFFFDFEFFFFFDFFFFFEFFFFFFFFFDFFFCFDFFFCFDFFFB0000FFFCFFFFFDFFFFFFFFFFFFFCFFFFFBFFFFFCFFFFFFFFFEFFFDFEFFFBFEFFFBFEFF" & _
		"FDFFFFFFFFFFFFFFFFFDFFFFFDFFFFFFFEFFFFFEFFFDFEFFFDFEFFFFFEFFFFFFFEFFFFFBFFFFFBFFFFFCFFFEFFFFFEFFFBFEFFFAFFFFFBFFFFFFFFFFFFFEFFFF" & _
		"FDFFFDFDFFFFFFFFFFFFFCFDFFFCFDFFFEFBFFFFFDFDFFFFFDFFFFFDFFFFFFFEFDFFFCFDFFFCFBFFFC0000FFFBFFFFFCFFFFFFFFFFFFFBFDFFFBFDFFFBFFFEFF" & _
		"FFFEFFFBFDFFFAFEFFFDFDFFFFFEFFFFFEFFFFFFFFFDFEFFFBFFFFFFFEFFFFFFFFFFFEFFFFFEFFFFFEFFFFFFFEFFFFFBFFFFFBFFFFFCFFFEFFFFFDFFFBFDFFFA" & _
		"FEFFFBFEFFFFFFFFFFFEFFFFFBFFFFFBFFFFFDFFFFFFFEFDFFFEFBFFFEFBFEFFFDFDFFFFFDFFFFFDFFFFFFFEFDFFFCFBFFFCFBFFFC0000"
	FileWrite($hFile,$FileName)
	FileClose($hFile)
	$FileName = ""

	$hFile = FileOpen(@ScriptDir & "\Resources\_Image.bmp", 16 + 2)
	If $hFile = -1 Then Exit MsgBox(48, "Error", "Cannot create resource file")
	$FileName = "0x424D361B000000000000360000002800000030000000300000000100180000000000001B0000130B0000130B00000000000000000001FFFFFFFFFFFFFFFFFF" & _
			"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
			"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
			"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFEFEFEFEFEFEFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFD" & _
			"FDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
			"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9F9F9EBEBEBEBEBEBEDEDEDEDEDEDECECECECECECECECECECECECECEC" & _
			"ECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECECEDEDEDECECECEDEDEDEFEFEFF9F9F9FFFFFFFEFEFEFFFFFFFFFFFFFFFFFF" & _
			"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE7E7E7C0C0C0AFAFAFC7C7C7C4" & _
			"C4C4C5C5C5C5C5C5C5C5C5C5C5C5C6C6C6C5C5C5C6C6C6C6C6C6C6C6C6C7C7C7C6C6C6C7C7C7C7C7C7C7C7C7C6C6C6C5C5C5C5C5C5C4C4C4C3C3C3C2C2C2C1C1" & _
			"C1CFCFCFFFFFFFFCFCFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
			"FFFFFFDCDCDCA5A5A5CFCFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
			"FFFFFFFFFFFFFFFFFDFDFDF8F8F8F7F7F7D2D2D2C3C3C3FFFFFFFDFDFDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
			"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEDCDCDCA3A3A3C4C4C4FBFBFBF0F0F0F4F4F4F5F5F5F6F6F6F6F6F6F7F7F7F6F6F6F7F7F7F8F8F8F8F8F8F9F9F9" & _
			"F8F8F8F9F9F9FAFAFAF9F9F9F8F8F8F6F6F6F2F2F2EEEEEEEAEAEAE6E6E6DCDCDCD9D9D9D1D1D1B7B7B7FEFEFEFCFCFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
			"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDCDCDCA3A3A3C7C7C7FFFFFFF4F4F4F8F8F8F9F9F9FAFAFAF9F9F9FAFA" & _
			"FAFAFAFAFBFBFBFCFCFCFCFCFCFCFCFCFDFDFDFDFDFDFDFDFDFDFDFDFCFCFCFAFAFAF6F6F6F1F1F1EDEDEDE9E9E9DFDFDFC5C5C5D4D3D4DADADAB1B1B1FBFBFB" & _
			"FEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEDBDBDBA2A2A2C6C6C6FFFFFFF4" & _
			"F4F4F8F8F8F9F9F9FAFAFAFAFAFAFBFBFBFAFAFAFBFBFBFCFCFCFCFCFCFDFDFDFCFCFCFDFDFDFEFEFEFDFDFDFCFCFCFAFAFAF5F5F5F2F2F2EEEEEEEAEAEAE3E2" & _
			"E2C2C1C1BAB9B9DEDEDED8D8D8AEAEAEF6F6F6FEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
			"FEFEFEDBDBDBA2A2A2C6C6C6FEFEFEF3F3F3F7F7F7F8F8F8F9F9F9F8F9F9F9F9FAF9F9F9F9FAFAFAFBFBFAFBFBFBFCFCFAFBFBFBFCFCFCFCFDFCFCFDFAFAFBF8" & _
			"F8F9F5F6F6F1F2F2EEEEEEEAEAEAE5E5E6CCCCCDA5A4A4DDDDDDE0E0E0D9D9D9ABABABF1F1F1FCFCFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
			"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEDBDBDBA2A2A2C5C5C5FFFFFFF6F5F4F8F8F8FBFAF9FCFBFAFBFAF9FCFBFAFDFCFBFFFEFCFFFFFDFFFFFDFFFFFD" & _
			"FFFFFDFFFFFEFFFFFFFFFFFFFFFFFFFFFFFDFDFCFAF9F7F5F5F3F1F1EFEDECEBE9DBDAD8A3A3A2CACACAF7F7F7D9D8D8DBDBDBAAAAAAF5F5F5FEFEFEFFFFFFFF" & _
			"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEDBDBDBA2A2A2C7C7C6F9FBFDE8EBF0F5F6F6EEF0F5EEF0F5EEF0F5ECF0" & _
			"F5E8EEF4E6EBF4E6ECF5E7ECF5E7EDF5E6ECF5E2E9F3E0E6F2DFE6F2DEE5F1DCE4F0DBE2EEDAE1ECD8DFEAD6DDE8D5DCE6D2D8E2AEB0B4B4B3B2FFFFFFEDEDED" & _
			"D7D7D7D7D7D7ABABABF8F8F8FCFCFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEDBDBDBA2A2A2CAC8C7EEF3FBD1" & _
			"DAE8E6ECF2D5DDEDD4DDECD3DDECC8D6E9B8CBE4B5C7E4B6C8E5B6C8E6B8CAE7B4C8E4A4BCDC9BB1D799B0D799AFD699AFD69AB0D89EB4D9A0B7DAA2B9DCA2B9" & _
			"DCB0C7E9B4BCC8A8A7A5FFFFFFFFFFFFF6F6F6DDDDDDD6D6D6AEAEAEFCFCFCFDFDFDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
			"FEFEFEDBDBDBA2A2A2C8C7C6F4F8FCD3DAE7DBE2EED6DFECD6DFECD4DEEDC7D6E8B8CBE5B9CBE6BCCCE7BBCCE7BDCEE8B4C9E3A8BEDDA2B8DAA1B6DBA2B6DAA3" & _
			"B6DBA3B8DAA5BADBA6BCDCA8BDDEA9BDDEACC2E3BEC5D1ABA9A6ABABAAB8B7B6CECDCBDDDDDCDBDBDBD5D5D6B2B2B2FFFFFFFDFDFDFFFFFFFFFFFFFFFFFFFFFF" & _
			"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEDBDBDBA2A2A2C8C7C6F5F9FDCCD5E3D3DCE9D4DDECD5DEEDD2DDEDCBD9EBBECFE6B6CAE5BACBE6BBCCE7B8CAE6" & _
			"AEC3E0A4BADAA1B6D8A0B6DAA1B7D9A2B7DAA3B9DBA4BADBA5BBDCA7BCDEAABEDFAABFE0B5C7E0BEC9DDBBC6D6B3BAC3B0B5BCB4B6B8C6C6C5D7D6D5CFCECEBF" & _
			"BFBFFFFFFFFDFDFDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEDBDBDBA2A2A2C7C7C6F4F7FBC5CFDFCDD8E5D0DAE8D3DCEAD1DDECCDDB" & _
			"ECC4D3E7B9CAE5B9CBE5B9CAE6B1C4E1A7BCDCA2B7DAA2B7D9A2B7D9A2B8D9A3B9D9A3BADAA5BBDCA6BCDDA8BCDEA9BEDFABC0E0ABC1E1B5CBE8C4D7F1CBDEF5" & _
			"CFE0F6D2DFF0D1DAE7D2D8E1E0E3E8CDCDCECBCBCBFDFDFDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEDBDBDBA2A2A2C8C8C7F2F5FBBE" & _
			"C9DCC9D2E2C9D5E5CBD8E7CEDAECCCDBECC4D3E6B7CBE4B4C8E3ACC2DFA6BCDBA3B9D9A3B9DAA3B9DAA3B9DAA3B9DAA3BADAA4BADBA6BCDDA7BCDEA8BDDDA9BF" & _
			"DFACC1E1ADC2E1AFC4E1BBCDE8C4D6EDC6D9EECCDCF0D2E0F4D3E0F4CEDAEEF3F6FBC4C4C3F4F4F4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
			"FEFEFEDBDBDBA2A2A2C9C7C6F1F4F9B9C5D9C3CEE1C3D0E1C6D4E4C8D6E8C8D6E8BCCEE5B0C6E1ABC1DEA5BBDBA1B8D9A0B7D99EB4D89EB4D79DB5D89FB6D9A1" & _
			"B7DAA4BADBA6BCDDA8BEDEAAC0E0ABC1E0ABC1E1ADC2E3AFC5E3B4C9E5C1D3EDC7D9EFC8DAEFCCDCF0CFDEF1CBDAEFF0F4FACCCBC9E9E9E9FFFFFFFFFFFFFFFF" & _
			"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEDBDBDBA2A2A2C8C8C7EFF3F8B4C0D5BEC9DEBFCBDFC1CEE1C2D0E2B9CAE1AEC3DFA9BEDC97AFD28BA3CA84A0C8" & _
			"819DC7829CC9839DCA859FCA88A1CB8BA4CD90A9CF96AFD49DB4D9A5BBDCAABFE0B0C4E2B3C7E4AFC5E3B2C8E4BDCEE9C5D7EEC8DAF0CADAF1CDDDF1C9DAEDF4" & _
			"F8FECBCBCAE7E7E7FEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEDBDBDBA2A2A2C8C7C7EDF1F7ADBCD3B7C6D9B9C7DCBAC8DEB2C3DDA8BC" & _
			"DAA1B7D77E99C36C8BBD6A8ABC6888B96886B56A86B36F8AB87591BF7D98C6839ECC88A3CF89A4CE8DA6CD94AED2A7BEDFBBCDE6CBD8EAC0D0E8B0C6E4B7CAE6" & _
			"C1D4ECC7D9EFC7DAF0CBDAF0C7D7EDF7FBFFCDCCCBE6E6E6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEDBDBDBA2A2A2C9C8C7ECF0F6A9" & _
			"B7CFB2C1D7B3C2D9ACBDD8A2B7D4A8BCDA7B96C04A6BA14157842C3C5E2029441B223C1920391D243C29304A323A584553755F739A7D95C088A4CF93ACD3B1C5" & _
			"E2C4D4E8D3DDEDDBE3EFC7D5E9B3C8E4BFD1EAC6D8EEC8DAF0C9DAF0C6D6EEFAFEFECECECCE7E7E7FEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
			"FEFEFEDBDBDBA2A2A2C9C8C7EAEEF5A4B2CDAEBCD4A9B9D4A0B4D29AAFCF809AC237568F09132E00000200000000000000000000000200000200000700000000" & _
			"00050A0914272E455A6D90A4BBDBBBCDE7C8D5E7D5DFEED8E1EEDFE7F0C5D3E9BACDE8C6D7EEC7D9EFC8DAEFC3D5EDFBFFFFCFCECEE6E6E6FEFEFEFFFFFFFFFF" & _
			"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEDBDBDBA2A2A2C9C8C7E8ECF49AAAC7A6B4CFA3B3D194A9C96E8AB645659D0E1A3A000000030814020A1A0D111A" & _
			"2B34424450645A69806475924E648629416708193700000918152252596FA0B3D0BDCFE9CAD8E9D7E0EEDBE4EFDAE3F0C0D2EAC3D5EDC7D8EFC8DAEFC1D4ECFB" & _
			"FEFFD0CFCEE6E6E6FEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEDBDBDBA2A2A2CAC9C6E3E9F1869CBE91A5C69CADCB899EC25D7AAA5775" & _
			"A8131728020B1913386F2C425F5E66718F9296B6B4B4D0CECCE7E7E6ECF1F6DBE5F3ADBED85C78A51F2D4A4B484F5A6072A4B7D4BDD0E9CDD9EAD7E1EFDAE3EF" & _
			"D0DCEEC1D4ECC7D9EEC7D9EFC2D5ECFBFFFFCFCECEE6E6E6FEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEDBDBDBA2A2A2CBCAC7DFE5EF7B" & _
			"91B7869BC08DA2C58AA1C3647FAC6683B542567D00000511223D3C46535F656F919394AEB1B3BEC2C4AD9E9BB0927ECAB1A2E0DEE1EBEEF2A5BBDF3B48624240" & _
			"4551596FB6CAE7BDCFE7D0DCEDD6DEEDD2DEEEC5D7EDC5D8EEC7D9EEC1D4EBFCFFFFD0CFCEE6E6E6FEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
			"FEFEFEDBDBDBA2A2A2CBCAC8DCE3EC6F87AD7C93B7859ABF8DA2C37B93BA6680AD6B86B71F283F0001053844575D646E909394A0A0A16E473C5E1900914800C4" & _
			"7C00CE9035D3CAC5F7F9F893A8CD202636211F2E7F8CA6BFD3EFC4D2E7CFDCEDCDDBEDC6D6EDC4D6EEC7D8EFC0D4EBFAFEFFD0CFCEE6E6E6FEFEFEFFFFFFFFFF" & _
			"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEDBDBDBA2A2A2CCCBC7D9DEEA657BA7748AB08095BB8B9FC48DA0C37D93BA708BB5637DA60E122013161C5E6671" & _
			"8C91976B4C405A1900702B02924F03CD9404E6A807CA9344CED0D7D3D8E230415F000000343A4EAFC2DEBDCEE6C9D9ECC8D8EEC5D6EEC5D6EEC6D8EEC0D3EBFA" & _
			"FFFFD0CFCDE6E6E6FEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEDBDBDBA2A2A2CBCBC8D6DDE86279A77489B1697DA37084A88BA0C490A5" & _
			"C7899FC27E96BF647AA310152517181C5F5D6360340E7239023E1301150900754E1BEEDBA4C37F12B7ACAAD0D4D56A738400000102020E7B87A0C9DCF6BECFE6" & _
			"C2D4EAC2D3EAC3D3EBC4D5ECBED0E8F8FDFFD0CFCEE6E6E6FEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEDBDBDBA2A2A2CCCAC7D6DCE861" & _
			"78A67083AE5B6D92506181515E798093B68598B994A8CB8FA4C87B91B73A455D10101A210F004825001D08020000022B12038E5512804402918885989C9F4343" & _
			"46000000010109222538A3B3CCC1D3EEB9C9E2BDCDE6BECDE6BFCFE7BACAE4F7FCFFD0CFCEE6E6E6FEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
			"FEFEFEDBDBDBA2A2A2CCCAC7D5DBE76076A46F84AD7186AC768CB344526E262F43232A3D606E8B90A5C797ACCE99AFD27F93B4424F6710131A00000000000017" & _
			"05002106001E0A062526280E0F1300000101010A01011200000B16182A93A2BCBDD1ECB5C5DFB9C9E4B9C9E4B3C4E0F5FAFED0CFCEE6E6E6FEFEFEFFFFFFFFFF" & _
			"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEDBDBDBA2A2A2CBCAC7D4DAE65E73A26E84AC7387AE778AB07F94BB5A6A8813192D06091B333C557081A08A9CBD" & _
			"9CB0D29EB3D5899BBC56637C1C212C00000100000000000000000000000000000000000202041414182E0507190B0B1B91A0BABACDEAB0C2DDB4C6E1ADC0DDF3" & _
			"F8FFD0CFCDE6E6E6FEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEDBDBDBA2A2A2CCC9C6D4D9E55D73A16D81A97084AB7588AF778BB1869C" & _
			"C466789A0B122801081D050D232A38536D80A0869ABA98ACCD9EB3D691A6C85D6E9037435A1A1F2E0D111C121622242D4145557461769F6E87B3667EA92E3956" & _
			"1315279AAAC5B2C6E3AEC0DBAABDD9F2F7FED0CFCEE6E6E6FEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEDBDBDBA2A2A2CBCAC7D3D8E45C" & _
			"719D6B7FA76F82AA7286AE768AB0778BB1859AC14F617F0F1C330A162E000A211826404253718B9FC08EA2C493A7C88DA4CB829CC77D94BE7389B2768EB87E99" & _
			"C47F9BC77C96C27891BD7A93C07F9BC946577C2E354AA7BAD6ABBDDAA3B5D3F0F5FDCFCECEE6E6E6FEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
			"FEFEFEDBDBDBA2A2A2CACAC7D2D7E35B6F9B6A7EA66C80A87083AB7588AE778BB1798CB27C91B62F3F5C0B183016253D14233A27344F5261808DA2C58EA1C38E" & _
			"A2C2889CBF8398BF8299C08098BE7E94BC7C92BB7B92BC7A92BB7991BA7690BA839FCB4F61845A647EAEC0E09DAECEEFF4FCD0CFCEE6E6E6FEFEFEFFFFFFFFFF" & _
			"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEDBDBDBA2A2A2CBCAC6D1D6E2596E9A687BA46A7EA66E81A97184AC7487AE7589AF7B8EB46F83A71D2C470B1A31" & _
			"0A19310B1A33202D486A7B9B91A3C78B9FC28EA1C38DA0C3899DC2879BC18499C08398BF8197BE8097BE7E95BD7D94BD7A91BA819BC86070908897B39FB2D3EC" & _
			"F1F9D1CFCEE6E6E6FEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEDBDBDBA2A2A2CBC9C7D0D5E1566A986679A3687CA56A7EA66D81A97083" & _
			"AB7286AC7487AE7C8FB57C8BAC5D6B87424F6B2835500F1D39313F5B717F9D8EA0C48A9DC38A9EC28CA1C48EA1C48DA1C48B9FC38A9EC2889DC1879CC1879BC0" & _
			"869BC1889CC28DA2C67C8CAB93A7C8EAEFF9D0CFCEE6E6E6FEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEDBDBDBA2A2A2CACAC6D0D4E056" & _
			"68966476A16478A2677AA36A7DA66C80A86E82AA7184AC788BAF8897B6929EBE909BBB808CAA5B68832C3A57303F5B717E9B8191B1889BBE889CC1889BC18B9F" & _
			"C38DA1C38DA1C38EA2C48FA3C58FA3C590A4C591A5C693A6C893A5C78C9FC1E9EEF8D0CFCDE6E6E6FEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
			"FEFEFEDBDBDBA2A2A2CBC9C6CED3DF53659361729E6174A06477A36679A4687CA46A7FA76E82A97B8CAF8592B38994B48D99B7939EBC909CB9606B892F3E5B22" & _
			"324E4B59747D8AA594A1C08F9FC28699BE879AC0889CC18A9DC28C9FC28EA0C38FA1C390A3C590A2C493A4C68A9DC0E7ECF4D0CFCEE6E6E6FEFEFEFFFFFFFFFF" & _
			"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEDBDBDBA2A2A2CAC9C5CDD2DD5061915D6E9A5E709C60739E6376A16578A3677BA36C80A77B8BAE8391B18894B3" & _
			"8B95B48E99B78F9AB88691AE56627F4F5B773C49653B4B6763718D8E9BB699A6C38E9EC0879BBF889BC08A9CC28A9CC1899CC08C9DC18D9DC28FA0C28698BDE5" & _
			"E9F3D0CECDE6E6E6FEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEDBDBDBA2A2A2C9C9C6CBD0DC4D5E8D5A6B975A6B985D6E9B5F719D6175" & _
			"A06377A06C7EA67A89AC808DAE8591B18993B38D97B5919BB9929BBA8892AE5F6C875E6B883241603444624757757A87A38F9BB88D9AB88896B5808EB07F92B7" & _
			"8599BE8698BE8799BF889BBF8193BAE3E8F2CFCFCDE6E6E6FEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEDBDBDBA2A2A2C9C8C5CBCFDC49" & _
			"5C8E5667935768955A6B985C6D9A5E6F9C60739E6B7DA47987AA7D8AAC828DAF8591B18A95B28E98B5919AB8959EBA8994AE757F9B717C975563814353724253" & _
			"725363826674936F7E9D7482A37D8FB38195BA8095B98195BA8396BC7B8FB6E0E6F0D0CFCDE6E6E6FEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
			"FEFEFEDBDBDBA2A2A2CBCAC6C3C7D23E51805468955264915667945869965A6A985E709B6A7CA27583A87A86A97F8AAB828DAF8691AF8A95B28E98B5929BB89B" & _
			"A2BD9FA6C09DA4BE989FBB8A95B28892B18D98B68F9BB8929CBA8E99B98192B67B8FB47C90B47D8FB67F91B7778AB2DEE3EED0CECDE6E6E6FEFEFEFFFFFFFFFF" & _
			"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEDCDCDCA3A3A3CAC9C7C3C9D532446F495A845366945265925667945869955D6E9B697AA17380A67783A87C86AA" & _
			"7F8AAD838EAE8792B08D96B39099B5969CB79A9FB8999FB9969EBB969FBC959DBA909AB78C97B48A95B28592B17C8DB2788BB2798BB2798CB27C8FB37386AEDD" & _
			"E2ECCFCECCE7E7E7FEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDCDCDCA3A3A3C8C7C4BBC0CC283C6E34446E3B4B79465B8B475B8A4B5E" & _
			"8C5365925E709866759C6B78A06F7BA1737FA37882A67B86A7808BA9848DAC8991AF8F94B18D93B18891B08690AE838EAD818CAC818BAB7F8AAB7784AA6E81A9" & _
			"6C7FA86D7FA96E80A97081AB667AA3D5DBE5CECECBE6E6E6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEDBDBDBA2A2A2CBCBCAF3F4F5C2" & _
			"C7D1CCD0DBC9CDD5D0D4DED1D6E1D2D6E1D4D9E3D8DCE5DADEE6DBDFE7DDE0E8DEE1E9E0E2E9E1E4EBE2E5EBE4E6ECE5E6EDE6E7EEE6E7EEE6E7EFE5E7EEE5E7" & _
			"EEE4E6EEE4E7EEE4E7EFE2E5EEE0E4EEE0E4EEE0E4EDE1E5EEE1E5EEDCE0EAFFFFFFD3D3D2E7E7E7FEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
			"FFFFFFDEDEDEA7A7A7A5A5A5C0C0BFC3C1BFC3C2BFC3C3C1C3C2BFC3C2BFC3C2BFC3C2BFC3C2BFC3C2BFC3C2BFC2C2BFC3C2C0C2C2BFC2C2C0C3C2C0C2C1BFC2" & _
			"C2C0C2C2BFC2C2BFC2C2C0C2C2C0C3C2C0C3C3C0C3C2C0C3C3C0C3C3C0C3C3C1C4C3C1C3C3C1C3C3C1C3C3C1C3C2C0C3C3C2AFAFAFE8E8E8FFFFFFFFFFFFFFFF" & _
			"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFECECECC7C7C7BCBCBCBEBEBEBEBEBEBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBD" & _
			"BDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBDBEBEBEBDBDBDBF" & _
			"BFBFD2D2D2EFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFCFCF4F4F4EFEFEFEEEEEEEFEFEFEEEEEEEEEEEEEEEEEEEEEEEEEEEE" & _
			"EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE" & _
			"EEEEEEEEEEEEEEEEEEEFEFEFEEEEEEEFEFEFF4F4F4FCFCFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
			"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
			"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"
	FileWrite($hFile, $FileName)
	FileClose($hFile)
	$FileName = ""
	Return
EndFunc   ;==>Create_resources
#FUNCTION# ==============================================================
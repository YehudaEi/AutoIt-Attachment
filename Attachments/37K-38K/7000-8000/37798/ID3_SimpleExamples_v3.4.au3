#include-once
#include <ID3_v3.4.au3>
#include <Array.au3>
#include <File.au3>
#cs #ID3_SimpleExamples.au3  Latest Changes.......: ;========================================================
	Release 3.4 - 20120610
		-First Release
#ce ;========================================================================================================


;Un-comment one at a time to try each example


_ID3Example_ReadShowAllExistingTags()

;~ _ID3Example_ReadShowTitle()

;~ _ID3Example_ReadID3v2APIC()

;~ _ID3Example_ReadID3v2TXXX()

;~ _ID3Example_WriteID3v2Only()

;~ _ID3Example_WriteID3v1Only()

;~ _ID3Example_WriteID3NewTitles()

;~ _ID3Example_WriteID3v2Picture()

;~ _ID3Example_WriteID3v2TXXX()

;~ _ID3DeleteFiles() ;clean-up any Lyric files and/or Picture files that were written to hard disk

Exit



Func _ID3Example_ReadShowAllExistingTags()
	$Filename = FileOpenDialog( "Select Mp3 File", "", "Muisc (*.mp3)")
	$sFileTagInfo = _ID3ReadTag($Filename)
	MsgBox(0,"$sFileTagInfo",$sFileTagInfo)
	$aTagList = StringSplit($sFileTagInfo,@CRLF,1)
	For $iTag = 2 To $aTagList[0] - 1
		Dim $aTagFieldList = StringSplit($aTagList[$iTag],"|")
		Dim $a2DTagFields[$aTagFieldList[0]-1][2] ;2D Array to hold FieldNames and FieldStrings
		For $iField = 2 To $aTagFieldList[0]
			$a2DTagFields[$iField-2][0] = $aTagFieldList[$iField]
			If StringInStr($aTagFieldList[1],"ID3v2") > 0 Then
				Dim $aFrameInfo = StringSplit($aTagFieldList[$iField],":")
				Dim $sFrameID = $aFrameInfo[1]
				Dim $iNumFrames = $aFrameInfo[2]
				$a2DTagFields[$iField-2][1] = ""
				For $iFrame = 1 To $iNumFrames
					$a2DTagFields[$iField-2][1] &= _ID3GetTagField($sFrameID,$iFrame) & " | "
				Next
				$a2DTagFields[$iField-2][1] = StringTrimRight($a2DTagFields[$iField-2][1],3)
			ElseIf StringInStr($aTagFieldList[1],"ID3v1") > 0 Then
				$a2DTagFields[$iField-2][1] =_ID3GetTagField($aTagFieldList[$iField])
			ElseIf StringInStr($aTagFieldList[1],"APEv2") > 0 Then
				$a2DTagFields[$iField-2][1] =_APEv2_GetItemValueString($aTagFieldList[$iField])
			EndIf
		Next
		_ArrayDisplay($a2DTagFields,$aTagFieldList[1])
	Next
EndFunc

Func _ID3Example_ReadShowTitle()
	$Filename = FileOpenDialog ( "Select Mp3 File", "", "Muisc (*.mp3)")
	_ID3ReadTag($Filename,3) ;read only ID3v1 and ID3v2 tags
	MsgBox(0,"ID3v1 Title",_ID3GetTagField("Title")) ;Title from ID3v1
	MsgBox(0,"ID3v2 Title",_ID3GetTagField("TIT2")) ;Title from ID3v2
EndFunc

Func _ID3Example_ReadID3v2APIC()
	Dim $sAPIC_PictureTypes = "Other|32x32 pixels 'file icon'|Other file icon|Cover (front)|Cover (back)|Leaflet page|"
	$sAPIC_PictureTypes &= "Media (e.g. lable side of CD)|Lead artist/lead performer/soloist|Artist/performer|Conductor|"
	$sAPIC_PictureTypes &= "Lyricist/text writer|Recording Location|During recording|During performance|Movie/video screen capture|"
	$sAPIC_PictureTypes &= "A bright coloured fish|Illustration|Band/artist logotype|Publisher/Studio logotype"

	$Filename = FileOpenDialog("Select Mp3 File", "", "Muisc (*.mp3)")
	_ID3ReadTag($Filename,2)

	Local $AlbumArtFile = _ID3GetTagField("APIC")
	Local $NumAPIC = @extended ;holds number of Pictures in tag
	MsgBox(0,"AlbumArtFile",$AlbumArtFile)

	Local $PicTypeIndex = StringInStr($AlbumArtFile,chr(0))
	Local $aAPIC_PictureTypes = StringSplit($sAPIC_PictureTypes,"|",2)
	MsgBox(0,"APIC_PictureType",$aAPIC_PictureTypes[Number(StringMid($AlbumArtFile,$PicTypeIndex+1))])
EndFunc

Func _ID3Example_ReadID3v2TXXX()

	$Filename = FileOpenDialog("Select Mp3 File", "", "Muisc (*.mp3)")
	_ID3ReadTag($Filename,2)

	Local $TXXX = _ID3GetTagField("TXXX",1,1) ;return array (This will return the Description and String of the TXXX frame)
	Local $NumTXXX = @extended

	If $NumTXXX > 0 Then

		Local $a2DTXXX[$NumTXXX][2] ;2D Array to hold Description and String
		$a2DTXXX[0][0] = $TXXX[2] ;Description
		$a2DTXXX[0][1] = $TXXX[1] ;String

		For $iTXXX = 1 To $NumTXXX - 1
			$TXXX = _ID3GetTagField("TXXX",$iTXXX + 1,1)
			$a2DTXXX[$iTXXX][0] = $TXXX[2] ;Description
			$a2DTXXX[$iTXXX][1] = $TXXX[1] ;String
		Next

		_ArrayDisplay($a2DTXXX,"TXXX",-1,0,"","","   |Description|String")
	EndIf
EndFunc

Func _ID3Example_WriteID3v2Only()

	$Filename = FileOpenDialog( "Select Mp3 File", "", "Muisc (*.mp3)")

	_ID3ReadTag($Filename,2) ;must read in existing tag first to ensure other fields are saved

	_ID3SetTagField("COMM","TEST COMMENT - ID3v2 Comment Tag")
	_ID3WriteTag($Filename,2)

EndFunc

Func _ID3Example_WriteID3v1Only()

	$Filename = FileOpenDialog( "Select Mp3 File", "", "Muisc (*.mp3)")

	_ID3ReadTag($Filename,1) ;must read in existing tag first to ensure other fields are saved

	_ID3SetTagField("Comment","TEST COMMENT - ID3v1 Comment Tag")
	_ID3WriteTag($Filename,1)

EndFunc

Func _ID3Example_WriteID3NewTitles()

	$Filename = FileOpenDialog("Select Mp3 File", "", "Muisc (*.mp3)")

	_ID3ReadTag($Filename,3) ;must read in existing tag first to ensure other fields are saved

	_ID3SetTagField("Title","New Title - ID3v1")
	_ID3SetTagField("TIT2","New Title - ID3v2")

	_ID3WriteTag($Filename) ;by default this will write both ID3v1 and ID3v2

EndFunc

Func _ID3Example_WriteID3v2Picture()

	$Filename = FileOpenDialog("Select Mp3 File", "", "Muisc (*.mp3)")

	_ID3ReadTag($Filename,2) ;must read in existing tag first to ensure other fields are saved

	$PIC_Filename = FileOpenDialog("Select Image File", "", "Images (*.jpg;*.jpeg;*.png)", 1 + 4 )
	IF Not @error Then

		Local $iAPIC_PictureType = 3 ;Cover (front), see _ID3Example_ReadID3v2APIC() for others
		Local $iAPIC_index = 1
		Local $sAPIC = $PIC_Filename & "|" & "" & "|" & String($iAPIC_PictureType) ;$sPictureFilename|$sDescription|$iPictureType ; see _h_ID3v2_CreateFrameAPIC()

		_ID3v2Frame_SetFields("APIC",$sAPIC,$iAPIC_index,"|") ; | is the delimiter

		_ID3WriteTag($Filename,2)
	EndIf
EndFunc

Func _ID3Example_WriteID3v2TXXX()

	$Filename = FileOpenDialog("Select Mp3 File", "", "Muisc (*.mp3)")

	_ID3ReadTag($Filename,2) ;must read in existing tag first to ensure other fields are saved

	Local $iTXXX_index = 1; change this to edit multiple TXXX frames

	Local $sTXXX = "Description" & "|" & "StringValue"    ; | is the delimiter, so that Discription and StringValue can be set
	_ID3v2Frame_SetFields("TXXX",$sTXXX,$iTXXX_index,"|") ; | is the delimiter

;~ 	Local $sTXXX = "StringValue"  ; No delimiter, so that only StringValue is set
;~ 	_ID3v2Frame_SetFields("TXXX",$sTXXX,$iTXXX_index) ; do not specify delimter


	_ID3WriteTag($Filename,2)
EndFunc




#include-once
#include <Array.au3>
#include <String.au3>
#include <FTP.au3>

Dim $ID3Filenames = ""

;===============================================================================
; Function Name:    _ID3TagToArray()
; Description:      Reads ID3 Tag data from mp3 file and stores tag data in an array
;						Reads ID3v1.0, ID3v1.1, ID3v2.3, ID3v2.2($sFilter will not work for ID3v2.2)
; Parameter(s):     $Filename 	- Filename of mp3 file include full path
;					$iFlag		- ID3 Version to read (Default: 2 => ID3v2)
;									1 => Read ID3v1
;									2 => Read ID3v2
;									3 => Read ID3v2 from a file on an ftp
;					$sFilter	- ID3v2 Frame Filter (Default: -1 => all frames) 
;									If used format should be a pipe delimted string 
;									of the Frame IDs (ie. "TIT2|TALB|TPE1|TYER|APIC")
; Requirement(s):   None
; Return Value(s):  On Success - Returns the Array of tag fields and data.
;                   On Failure - 0 and Sets @error = -1 for end-of-file, @error = 1 for other errors
;Notes:	(Frame ID Definitions - not all may work)
;~ AENC Audio encryption
;~ APIC Attached picture
;~ COMM Comments
;~ COMR Commercial frame
;~ ENCR Encryption method registration
;~ EQUA Equalization
;~ ETCO Event timing codes
;~ GEOB General encapsulated object
;~ GRID Group identification registration
;~ IPLS Involved people list
;~ LINK Linked information
;~ MCDI Music CD identifier
;~ MLLT MPEG location lookup table
;~ OWNE Ownership frame
;~ PRIV Private frame
;~ PCNT Play counter
;~ POPM Popularimeter
;~ POSS Position synchronisation frame
;~ RBUF Recommended buffer size
;~ RVAD Relative volume adjustment
;~ RVRB Reverb
;~ SYLT Synchronized lyric/text
;~ SYTC Synchronized tempo codes
;~ TALB Album/Movie/Show title
;~ TBPM BPM (beats per minute)
;~ TCOM Composer
;~ TCON Content type
;~ TCOP Copyright message
;~ TDAT Date
;~ TDLY Playlist delay
;~ TENC Encoded by
;~ TEXT Lyricist/Text writer
;~ TFLT File type
;~ TIME Time
;~ TIT1 Content group description
;~ TIT2 Title/songname/content description
;~ TIT3 Subtitle/Description refinement
;~ TKEY Initial key
;~ TLAN Language(s)
;~ TLEN Length
;~ TMED Media type
;~ TOAL Original album/movie/show title
;~ TOFN Original filename
;~ TOLY Original lyricist(s)/text writer(s)
;~ TOPE Original artist(s)/performer(s)
;~ TORY Original release year
;~ TOWN File owner/licensee
;~ TPE1 Lead performer(s)/Soloist(s)
;~ TPE2 Band/orchestra/accompaniment
;~ TPE3 Conductor/performer refinement
;~ TPE4 Interpreted, remixed, or otherwise modified by
;~ TPOS Part of a set
;~ TPUB Publisher
;~ TRCK Track number/Position in set
;~ TRDA Recording dates
;~ TRSN Internet radio station name
;~ TRSO Internet radio station owner
;~ TSIZ Size
;~ TSRC ISRC (international standard recording code)
;~ TSSE Software/Hardware and settings used for encoding
;~ TYER Year
;~ TXXX User defined text information frame
;~ UFID Unique file identifier
;~ USER Terms of use
;~ USLT Unsychronized lyric/text transcription
;~ WCOM Commercial information
;~ WCOP Copyright/Legal information
;~ WOAF Official audio file webpage
;~ WOAR Official artist/performer webpage
;~ WOAS Official audio source webpage
;~ WORS Official internet radio station homepage
;~ WPAY Payment
;~ WPUB Publishers official webpage
;~ WXXX User defined URL link frame 
;===============================================================================
Func _ID3TagToArray($Filename,$iFlag = 2, $sFilter = -1)
	
Local $ID3TagArray[1] = [0]

	Switch $iFlag
		Case 1
			If Not(FileExists($Filename)) Then Return 0
			_ReadID3V1($Filename,$ID3TagArray)
		Case 2
			If Not(FileExists($Filename)) Then Return 0
			_ReadID3V2($Filename,$ID3TagArray,$sFilter)
		Case 3
			_ReadID3V2FTP($Filename,$ID3TagArray,$sFilter)
	EndSwitch

	Return $ID3TagArray

EndFunc

;===============================================================================
; Function Name:    _ID3DeleteFiles()
; Description:      Deletes any files created by ID3.au3 (ie. AlbumArt.jpeg and SongLyrics.txt)
; Parameter(s):     None
; Requirement(s):   None
; Return Value(s):  On Success - Returns 1.
;                   On Failure - Returns 0 
;===============================================================================
Func _ID3DeleteFiles()
	
	If $ID3Filenames == "" Then Return 1
	$aID3File = StringSplit($ID3Filenames,"|")
	For $i = 1 To $aID3File[0]
		If FileExists($aID3File[$i]) Then
			$ret = FileDelete($aID3File[$i])
			If $ret == 0 Then Return 0
		EndIf
	Next
	$ID3Filenames = ""
	
	Return 1
	
EndFunc
; -----------------------------------------------------------------------------



;-------------------  Main File Reading Functions -----------------------------

Func _ReadID3v2($Filename, ByRef $aID3V2Tag, $sFilter = -1)
		
	Local $ZPAD = 0, $BytesRead = 0
	Local $hFile = FileOpen($Filename,0)
	
	;read "ID3" string
	If Not(FileRead($hFile, 3) == "ID3") Then 
		FileClose($hFile)
		SetError(1)
		Return 0
	EndIf
	
	;GetTagVer
	Local $FrameIDLen
	Local $ID3v2Version = String(Number(_StringToHex(FileRead($hFile,1)))) & "." & String(Number(_StringToHex(FileRead($hFile,1))))
	If $sFilter == -1 Then
		_ArrayAdd($aID3V2Tag,"Version" & "|" & "ID3v2." & $ID3v2Version)
		$aID3V2Tag[0] += 1
	EndIf
	
	
	If StringInStr($ID3v2Version,"2.") Then
		$FrameIDLen = 3
		$sFilter = -1 ;this will get all the tag frames($sFilter is based on the 4 char FrameIDs only)
	Else
		$FrameIDLen = 4
	EndIf
	

	;GetTagFlags
	Local $TagFlags = _HexToBin(_StringToHex(FileRead($hFile,1)))
	Local $Unsynchronisation = StringMid($TagFlags,1,1)
	Local $ExtendedHeader = StringMid($TagFlags,2,1)
	Local $ExperimentalIndicator = StringMid($TagFlags,3,1)
	Local $Footer = StringMid($TagFlags,4,1)
	If Not $TagFlags == "00000000" Then
		MsgBox(0,"$ID3TagFlags", $TagFlags)
	EndIf
	If $sFilter == -1 Then
		_ArrayAdd($aID3V2Tag,"Unsynchronisation" & "|" & $Unsynchronisation)
		_ArrayAdd($aID3V2Tag,"ExtendedHeader" & "|" & $ExtendedHeader)
		_ArrayAdd($aID3V2Tag,"ExperimentalIndicator" & "|" & $ExperimentalIndicator)
		_ArrayAdd($aID3V2Tag,"Footer" & "|" & $Footer)
		$aID3V2Tag[0] += 4
	EndIf
	
	
	;GetTagSize
	Local $TagSizeBin = ""
	$TagHeaderBin = _HexToBin(_StringToHex(FileRead($hFile,4)))
	For $i = 1 To 33 Step 8
		$TagSizeBin &= StringMid($TagHeaderBin,$i + 1,7) ;Skip most significant bit in every byte
	Next
	Local $TagSize = Dec(_BinToHex($TagSizeBin)) + 10 ;add 10 to include header
	If $sFilter == -1 Then
		_ArrayAdd($aID3V2Tag,"TagSize" & "|" & $TagSize)
		$aID3V2Tag[0] += 1
	EndIf

	$BytesRead = 10 ;ID3 Header has been read (Header Size = 10 Bytes)
	
	
	Local $ZPadding, $FrameIDFristHex, $FrameID, $FrameSizeHex, $FrameSize, $FrameFlag1, $FrameFlag2, $FoundTag, $index
	
	;Get Rest Of Tag 
	While $BytesRead < $TagSize
		$ZPadding = 0 
		$FrameIDFristHex = _StringToHex(FileRead($hFile,1))
		$BytesRead += 1
		
		;check for NULL 
		If $FrameIDFristHex == "00" Then
			While $FrameIDFristHex == "00"
				$ZPadding += 1
				$FrameIDFristHex = _StringToHex(FileRead($hFile,1))
				$BytesRead += 1
				If $BytesRead >= $TagSize Then
					ExitLoop
				EndIf
			WEnd
			$ZPAD = $ZPadding
			ExitLoop
		Else
			
			$FrameID = Chr(Dec($FrameIDFristHex)) & String(FileRead($hFile,$FrameIDLen-1))
			$BytesRead += $FrameIDLen-1
			
			;Check for a valid frameID string
			If StringIsAlNum($FrameID) Then
				
				$FrameSizeHex = _StringToHex(FileRead($hFile,$FrameIDLen))
				$BytesRead += $FrameIDLen
				
				;Check for version 2.3 or 2.2
				If $FrameIDLen == 4 Then
					$FrameSize = _HexToUint32($FrameSizeHex)
					$FrameFlag1 = _HexToBin(_StringToHex(FileRead($hFile,1)))
					$FrameFlag2 = _HexToBin(_StringToHex(FileRead($hFile,1)))
					$BytesRead += 2
				ElseIf $FrameIDLen == 3 Then
					$FrameSize = Dec($FrameSizeHex)
					MsgBox(0,"$FrameSize",$FrameSize & "    " & $FrameSizeHex)
				EndIf
				
				
				;Add FrameID and Frame Data to array
				If $sFilter == -1 Then
					$FrameData = _GetID3v2FrameString($hFile, $FrameID, $FrameSize)
					_ArrayAdd($aID3V2Tag,$FrameData)
					$aID3V2Tag[0] += 1
					$BytesRead += $FrameSize
				Else
					If StringInStr($sFilter,$FrameID) Then
						$FrameData = _GetID3v2FrameString($hFile, $FrameID, $FrameSize)
						_ArrayAdd($aID3V2Tag,$FrameData)
						$aID3V2Tag[0] += 1
					Else
						FileRead($hFile,$FrameSize)
					EndIf
					$BytesRead += $FrameSize
				EndIf
				
				
			EndIf
		EndIf
	WEnd
	
	;get MPEG Header
	If $sFilter == -1 Then
		Local $MPEGHeaderCheck = $FrameIDFristHex & _StringToHex(FileRead($hFile,50))
		Local $index = StringInStr($MPEGHeaderCheck,"FF")
		Local $MPEGHeaderHex = StringMid($MPEGHeaderCheck,$index,8)
		;check MPEG Header
		If _CheckMPEGHeader($MPEGHeaderHex) Then
			_ArrayAdd($aID3V2Tag,"MPEG" & "|" & $MPEGHeaderHex)
			$aID3V2Tag[0] += 1
		EndIf
		If $ZPAD >= 1 Then
			_ArrayAdd($aID3V2Tag,"ZPAD" & "|" & $ZPAD)
			$aID3V2Tag[0] += 1
		EndIf
	EndIf

	FileClose($hFile)
	Return 1
	
EndFunc

Func _GetID3v2FrameString($hFile, $FrameID, $FrameLen)
	
	Local $FrameString = 0, $bTagFieldFound = False

	If StringLen($FrameID) == 4 Then
		Switch $FrameID
			Case "TIT1" ;Content group description
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TIT2" ;Title/songname/content description
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TIT3" ;Subtitle/Description refinement
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TEXT" ;Lyricist/Text writer
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TLAN" ;Language(s)
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TKEY" ;Initial key
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TMED" ;Media type
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TOAL" ;Original album/movie/show title
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TOFN" ;Original filename
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TOLY" ;Original lyricist(s)/text writer(s)
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TOPE" ;Original artist(s)/performer(s)
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TORY" ;Original release year
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TPE1" ;Lead performer(s)/Soloist(s)
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TPE2" ;Band/orchestra/accompaniment
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TPE3" ;Conductor/performer refinement
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TPE4" ;Interpreted, remixed, or otherwise modified by
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TPOS" ;Part of a set
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TALB" ;Album/Movie/Show title
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TRCK" ;Track number/Position in set
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TYER" ;Year
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "COMM" ;Comment
				$bTagFieldFound = True
				$CommentField = _FormatString(FileRead($hFile,$FrameLen))
				$CommentInfo = StringMid($CommentField,1,3)
				If $CommentInfo == "eng" Or $CommentInfo == "XXX" Then
					$CommentField =  StringTrimLeft($CommentField,3)
				EndIf
				$FrameString = $FrameID & "|" & $CommentField
			Case "APIC" ;Picture
				$bTagFieldFound = True
				$AlbumArtFilename = _GetAlbumArt($hFile,$FrameLen)
				If $AlbumArtFilename == -1 Then
					$FrameString = $FrameID & "|" & "Error: Not JPEG Format"
				Else
					$ID3Filenames &= $AlbumArtFilename & "|"
					$FrameString = $FrameID & "|" & $AlbumArtFilename
				EndIf
			Case "USLT" ;Lyrics
				$bTagFieldFound = True
				$LyricsField = _FormatString(FileRead($hFile,$FrameLen))
				$LyricsInfo = StringMid($LyricsField,1,3)
				If $LyricsInfo == "eng" Or $LyricsInfo == "XXX" Then
					$LyricsField = StringTrimLeft($LyricsField,3)
				EndIf
				$LyricsFilename = @ScriptDir & "\" & "SongLyrics.txt"
				$hLyricFile = FileOpen($LyricsFilename, 2) ;Open for write and erase existing
				FileWrite($hLyricFile,$LyricsField)
				FileClose($hLyricFile)
				$FrameString = $FrameID & "|" & $LyricsFilename
				$ID3Filenames &= $LyricsFilename & "|"
			Case "TSSE" ;Software/Hardware and settings used for encoding
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TENC" ;Encoded by
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TCOP" ;Copyright message
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TBPM" ;BPM (beats per minute)
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TRDA" ;Recording dates
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TRSN" ;Internet radio station name
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TRSO" ;Internet radio station owner
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TSIZ" ;Size
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TSRC" ;ISRC (international standard recording code)
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TCON" ;Content Type/Genre
				$bTagFieldFound = True
				$Genre = _FormatString(FileRead($hFile,$FrameLen))
				If StringMid($Genre,1,1) == "(" Then ;check if first char is "("
					$closeparindex = StringInStr($Genre,")")
					$GenreID = StringMid($Genre,2,$closeparindex-1)
					$Genre = _GetGenreByID($GenreID)
				EndIf ;If no "(" then return the whole field as is
				$FrameString = $FrameID & "|" & $Genre
			Case "TLEN" ;Length in ms
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TPUB" ;Publisher
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "NCON" ;??                                     --- non-standard NCON frame in tag
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & "Non-Standard NCON Frame"
				FileRead($hfile,$FrameLen)
			Case "TFLT" ;File Type
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "UFID" ;Unique File ID
				$bTagFieldFound = True
				$UFID = _FormatString(FileRead($hFile,$FrameLen))
				$testindex = StringInStr($UFID,"3CD")
				If Not ($testindex == 0) Then
					$UFID = StringMid($UFID,1,$testindex-1)
				EndIf
				$FrameString = $FrameID & "|" & $UFID
			Case "TCOM" ;Composer
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "WCOM" ;Commercial Info URL
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "WCOP" ;Copyright/Legal information
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "WXXX" ;User defined URL
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "WPAY" ;Payment
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "WOAR" ;Official artist/performer webpage
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "WOAS" ;Official audio source webpage
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "WOAF" ;Official audio file webpage
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "WORS" ;Official internet radio station homepage
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "WPUB" ;Publishers official webpage
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "PRIV" ;Private frame
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "PCNT" ;Play counter
				$bTagFieldFound = True

				$FrameString = $FrameID & "|" & _HexToUint32(_StringToHex(FileRead($hFile,4))) ;Not Tested
			Case Else
				$FrameString = $FrameID & "|" & "Undefined FrameID"
				FileRead($hFile,$FrameLen)
				
		EndSwitch
		
		
	ElseIf StringLen($FrameID) == 3 Then
		
		
		Switch $FrameID
			Case "TT1" ;Content group description
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TT2" ;Title/songname/content description
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TT3" ;Subtitle/Description refinement
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TXT" ;Lyricist/Text writer
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TLA" ;Language(s)
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TKE" ;Initial key
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TMT" ;Media type
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TOT" ;Original album/movie/show title
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TOF" ;Original filename
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TOL" ;Original lyricist(s)/text writer(s)
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TOA" ;Original artist(s)/performer(s)
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TOR" ;Original release year
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TP1" ;Lead performer(s)/Soloist(s)
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TP2" ;Band/orchestra/accompaniment
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TP3" ;Conductor/performer refinement
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TP4" ;Interpreted, remixed, or otherwise modified by
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TPA" ;Part of a set
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TAL" ;Album/Movie/Show title
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TRK" ;Track number/Position in set
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TYE" ;Year
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "COM" ;Comment
				$bTagFieldFound = True
				$CommentField = _FormatString(FileRead($hFile,$FrameLen))
				$CommentInfo = StringMid($CommentField,1,3)
				If $CommentInfo == "eng" Or $CommentInfo == "XXX" Then
					$CommentField =  StringTrimLeft($CommentField,3)
				EndIf
				$FrameString = $FrameID & "|" & $CommentField
			Case "PIC" ;Picture
				$bTagFieldFound = True
				$AlbumArtFilename = _GetAlbumArt($hFile,$FrameLen)
				If $AlbumArtFilename == -1 Then
					$FrameString = $FrameID & "|" & "Error: Not JPEG Format"
				Else
					$ID3Filenames &= $AlbumArtFilename & "|"
					$FrameString = $FrameID & "|" & $AlbumArtFilename
				EndIf
			Case "ULT" ;Lyrics
				$bTagFieldFound = True
				$LyricsField = _FormatString(FileRead($hFile,$FrameLen))
				$LyricsInfo = StringMid($LyricsField,1,3)
				If $LyricsInfo == "eng" Or $LyricsInfo == "XXX" Then
					$LyricsField = StringTrimLeft($LyricsField,3)
				EndIf
				$LyricsFilename = @ScriptDir & "\" & "SongLyrics.txt"
				$hLyricFile = FileOpen($LyricsFilename, 2) ;Open for write and erase existing
				FileWrite($hLyricFile,$LyricsField)
				FileClose($hLyricFile)
				$FrameString = $FrameID & "|" & $LyricsFilename
				$ID3Filenames &= $LyricsFilename & "|"
			Case "TSS" ;Software/Hardware and settings used for encoding
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TEN" ;Encoded by
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TCR" ;Copyright message
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TBP" ;BPM (beats per minute)
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))	
			Case "TRD" ;Recording dates
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TSI" ;Size
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TRC" ;ISRC (international standard recording code)
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TCO" ;Content Type/Genre
				$bTagFieldFound = True
				$Genre = _FormatString(FileRead($hFile,$FrameLen))
				If StringMid($Genre,1,1) == "(" Then ;check if first char is "("
					$closeparindex = StringInStr($Genre,")")
					$GenreID = StringMid($Genre,2,$closeparindex-1)
					$Genre = _GetGenreByID($GenreID)
				EndIf ;If no "(" then return the whole field as is
				$FrameString = $FrameID & "|" & $Genre
			Case "TLE" ;Length in ms
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TPB" ;Publisher
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "TFT" ;File Type
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "UFI" ;Unique File ID
				$bTagFieldFound = True
				$UFID = _FormatString(FileRead($hFile,$FrameLen))
				$testindex = StringInStr($UFID,"3CD")
				If Not ($testindex == 0) Then
					$UFID = StringMid($UFID,1,$testindex-1)
				EndIf
				$FrameString = $FrameID & "|" & $UFID
			Case "TCM" ;Composer
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "WCM" ;Commercial Info URL
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "WCP" ;Copyright/Legal information
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "WXX" ;User defined URL
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "WAR" ;Official artist/performer webpage
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "WAS" ;Official audio source webpage
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "WAF" ;Official audio file webpage
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "WPB" ;Publishers official webpage
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _FormatString(FileRead($hFile,$FrameLen))
			Case "RVA" ;Relative volume adjustment
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & "TBP - Relative Volume Adjustment" ;Not Tested
				FileRead($hFile,$FrameLen)
			Case "CNT" ;Play counter
				$bTagFieldFound = True
				$FrameString = $FrameID & "|" & _HexToUint32(_StringToHex(FileRead($hFile,4))) ;Not Tested
			Case Else
				FileRead($hFile,$FrameLen)
				$FrameString = $FrameID & "|" & "Undefined FrameID"
				
		EndSwitch
		
	EndIf
	
	If $bTagFieldFound == False Then
		SetError(1)
	EndIf
	
	Return $FrameString
	
EndFunc

Func _ReadID3v1($Filename, ByRef $aID3V1Tag)
	
	Local $hfile = FileOpen($Filename,0)
	FileRead($hfile,FileGetSize($Filename)-128)
	Local $ID3v1ID = String(FileRead($hfile,3))
	
	If Not($ID3v1ID == "TAG") Then
		FileClose($hfile)
		SetError(-1)
		Return 0
	EndIf
	
	Local $Title, $Artist, $Album, $Year, $Comment, $Track, $GenreID, $Genre
	
	$Title = _FormatString(FileRead($hfile,30))
	_ArrayAdd($aID3V1Tag,"Title" & "|" & $Title)
	$aID3V1Tag[0] += 1

	$Artist = _FormatString(FileRead($hFile,30))
	_ArrayAdd($aID3V1Tag,"Artist" & "|" & $Artist)
	$aID3V1Tag[0] += 1

	$Album = _FormatString(FileRead($hFile,30))
	_ArrayAdd($aID3V1Tag,"Album" & "|" & $Album)
	$aID3V1Tag[0] += 1
	
	$Year = _FormatString(FileRead($hFile,4))
	_ArrayAdd($aID3V1Tag,"Year" & "|" & $Year)
	$aID3V1Tag[0] += 1
	
	$Comment = _FormatString(FileRead($hFile,28))
	_ArrayAdd($aID3V1Tag,"Comment" & "|" & $Comment)
	$aID3V1Tag[0] += 1
	
	$Track = Dec(_StringToHex(FileRead($hfile,2)))
	If $Track < 1000 And $Track > 0 Then
		_ArrayAdd($aID3V1Tag,"Track" & "|" & $Track)
		$aID3V1Tag[0] += 1
	EndIf
		
	$GenreID = Dec(_StringToHex(FileRead($hfile,1)))
	$Genre = _GetGenreByID($GenreID)
	_ArrayAdd($aID3V1Tag,"Genre" & "|" & $Genre)
	$aID3V1Tag[0] += 1
	
	If $Track == 0 Then
		_ArrayAdd($aID3V1Tag,"Version" & "|" & "ID3v1.0")
		$aID3V1Tag[0] += 1
	Else
		_ArrayAdd($aID3V1Tag,"Version" & "|" & "ID3v1.1")
		$aID3V1Tag[0] += 1
	EndIf
	
	FileClose($hfile)
	Return 1
	
EndFunc


Func _ReadID3V2FTP($FTPFilename, ByRef $aID3V2Tag, $sFilter = -1)
	
	Local $ZPAD = 0, $BytesRead = 0, $ServerName = 0, $Username = 0, $Password = 0, $ServerPort = 0
	
	Local $Filename = _FTPGetLinkStringInfo($FTPFilename, $ServerName, $Username, $Password, $ServerPort)
	Local $Open = _FTPOpen('MyFTP Control')
	Local $Conn = _FTPConnect($Open, $ServerName, $Username, $Password, $ServerPort)
	Local $hFile = _FTPOpenFile($Conn,$Filename)
	
	;read the "ID3" string
	If Not(_FTPReadFile($hFile, 3) == "ID3") Then 
		_FTPCloseFile($hFile)
		_FTPClose($Open)
		SetError(1)
		Return 0
	EndIf
	
	;GetTagVer
	Local $FrameIDLen
	Local $ID3v2Version = String(Number(_StringToHex(_FTPReadFile($hFile,1)))) & "." & String(Number(_StringToHex(_FTPReadFile($hFile,1))))
	If StringInStr($ID3v2Version,"2.") Then
		$FrameIDLen = 3
	Else
		$FrameIDLen = 4
	EndIf
	If $sFilter == -1 Then
		_ArrayAdd($aID3V2Tag,"Version" & "|" & "ID3v2." & $ID3v2Version)
		$aID3V2Tag[0] += 1
	EndIf
	
	
	;GetTagFlags
	Local $TagFlags = _HexToBin(_StringToHex(_FTPReadFile($hFile,1)))
	Local $Unsynchronisation = StringMid($TagFlags,1,1)
	
	Local $ExtendedHeader = StringMid($TagFlags,2,1)
	
	Local $ExperimentalIndicator = StringMid($TagFlags,3,1)
	
	Local $Footer = StringMid($TagFlags,4,1)
	
	If Not $TagFlags == "00000000" Then
		MsgBox(0,"$ID3TagFlags", $TagFlags)
	EndIf
	If $sFilter == -1 Then
		_ArrayAdd($aID3V2Tag,"Unsynchronisation" & "|" & $Unsynchronisation)
		_ArrayAdd($aID3V2Tag,"ExtendedHeader" & "|" & $ExtendedHeader)
		_ArrayAdd($aID3V2Tag,"ExperimentalIndicator" & "|" & $ExperimentalIndicator)
		_ArrayAdd($aID3V2Tag,"Footer" & "|" & $Footer)
		$aID3V2Tag[0] += 4
	EndIf
	
	
	;GetTagSize
	Local $TagSizeBin = ""
	$TagHeaderBin = _HexToBin(_StringToHex(_FTPReadFile($hFile,4)))
	For $i = 1 To 33 Step 8
		$TagSizeBin &= StringMid($TagHeaderBin,$i + 1,7) ;Skip most significant bit in every byte
	Next
	Local $TagSize = Dec(_BinToHex($TagSizeBin)) + 10 ;add 10 to include header
	If $sFilter == -1 Then
		_ArrayAdd($aID3V2Tag,"TagSize" & "|" & $TagSize)
		$aID3V2Tag[0] += 1
	EndIf
	
	
	$BytesRead = 10 ;ID3 Header has been read (Header Size = 10 Bytes)
	
	;Get Rest Of Tag
	Local $ZPadding, $FrameIDFristHex, $FrameID, $FrameSizeHex, $FrameSize, $FrameFlag1, $FrameFlag2, $FoundTag
	While $BytesRead < $TagSize
		$ZPadding = 0 
		$FrameIDFristHex = _StringToHex(_FTPReadFile($hFile,1))
		$BytesRead += 1
		
		;check for NULL 
		If $FrameIDFristHex == "00" Then
			While $FrameIDFristHex == "00"
				$ZPadding += 1
				$FrameIDFristHex = _StringToHex(_FTPReadFile($hFile,1))
				$BytesRead += 1
				If $BytesRead >= $TagSize Then
					ExitLoop
				EndIf
			WEnd
			$ZPAD = $ZPadding
			ExitLoop
		Else
			
			
			$FrameID = Chr(Dec($FrameIDFristHex)) & String(_FTPReadFile($hFile,$FrameIDLen-1))
			$BytesRead += $FrameIDLen - 1
			;Check for a valid frameID string
			If StringIsAlNum($FrameID) Then
				
				$FrameSizeHex = Hex(_FTPReadFile($hFile,$FrameIDLen))
				$BytesRead += $FrameIDLen
				
				;Check for version 2.3 or 2.2
				If $FrameIDLen == 4 Then
					$FrameSize = _HexToUint32($FrameSizeHex)
					$FrameFlag1 = _HexToBin(_StringToHex(_FTPReadFile($hFile,1)))
					$FrameFlag2 = _HexToBin(_StringToHex(_FTPReadFile($hFile,1)))
					$BytesRead += 2
				ElseIf $FrameIDLen == 3 Then
					$FrameSize = Dec($FrameSizeHex)
				EndIf
			
				;Add FrameID and Frame Data to array
				If $sFilter == -1 Then
					$FoundTag = _ID3v2FTPFieldsToArray($hFile, $FrameID, $FrameSize, $aID3V2Tag)
					If Not $FoundTag Then
						_FTPReadFile($hFile,$FrameSize)
					EndIf
					$BytesRead += $FrameSize
				Else
					If StringInStr($sFilter,$FrameID) Then
						_ID3v2FTPFieldsToArray($hFile, $FrameID, $FrameSize, $aID3V2Tag)
					Else
						_FTPReadFile($hFile,$FrameSize)
					EndIf
					$BytesRead += $FrameSize
				EndIf
			EndIf
		EndIf
	WEnd
	
	If $sFilter == -1 Then
		;Get MPEG Header
		Local $MPEGHeaderCheck = $FrameIDFristHex & _StringToHex(_FTPReadFile($hFile,50))
		Local $index = StringInStr($MPEGHeaderCheck,"FF")
		Local $MPEGHeaderHex = StringMid($MPEGHeaderCheck,$index,8)
		;check MPEG Header
		If _CheckMPEGHeader($MPEGHeaderHex) Then
			_ArrayAdd($aID3V2Tag,"MPEG" & "|" & $MPEGHeaderHex)
			$aID3V2Tag[0] += 1
		EndIf
		If $ZPAD >= 1 Then
			_ArrayAdd($aID3V2Tag,"ZPAD" & "|" & $ZPAD)
			$aID3V2Tag[0] += 1
		EndIf
	EndIf
		
	
	_FTPCloseFile($hFile)
	_FTPClose($Open)
	Return 1
	
EndFunc

Func _ID3v2FTPFieldsToArray($hFile, $FrameID, $FrameLen, ByRef $aID3V2Tag)
	
	$aID3V2Tag[0] += 1
	$bTagFieldFound = False
	
	If StringLen($FrameID) == 4 Then
		Switch $FrameID
			Case "TIT1" ;Content group description
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TIT2" ;Title/songname/content description
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TIT3" ;Subtitle/Description refinement
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TEXT" ;Lyricist/Text writer
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TLAN" ;Language(s)
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TKEY" ;Initial key
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TMED" ;Media type
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TOAL" ;Original album/movie/show title
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TOFN" ;Original filename
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TOLY" ;Original lyricist(s)/text writer(s)
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TOPE" ;Original artist(s)/performer(s)
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TORY" ;Original release year
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TPE1" ;Lead performer(s)/Soloist(s)
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TPE2" ;Band/orchestra/accompaniment
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TPE3" ;Conductor/performer refinement
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TPE4" ;Interpreted, remixed, or otherwise modified by
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TPOS" ;Part of a set
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TALB" ;Album/Movie/Show title
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TRCK" ;Track number/Position in set
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TYER" ;Year
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "COMM" ;Comment
				$bTagFieldFound = True
				$CommentField = _FormatString(_FTPReadFile($hFile,$FrameLen))
				$CommentInfo = StringMid($CommentField,1,3)
				If $CommentInfo == "eng" Or $CommentInfo == "XXX" Then
					$CommentField =  StringTrimLeft($CommentField,3)
				EndIf
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & $CommentField)
			Case "APIC" ;Picture
				$bTagFieldFound = True
				$AlbumArtFilename = _GetAlbumArtFTP($hFile,$FrameLen)
				If $AlbumArtFilename == -1 Then
					_ArrayAdd($aID3V2Tag,$FrameID & "|" & "Error: Not JPEG Format")
				Else
					$ID3Filenames &= $AlbumArtFilename & "|"
					_ArrayAdd($aID3V2Tag,$FrameID & "|" & $AlbumArtFilename)
				EndIf
			Case "USLT" ;Lyrics
				$bTagFieldFound = True
				$LyricsField = _FormatString(_FTPReadFile($hFile,$FrameLen))
				$LyricsInfo = StringMid($LyricsField,1,3)
				If $LyricsInfo == "eng" Or $LyricsInfo == "XXX" Then
					$LyricsField = StringTrimLeft($LyricsField,3)
				EndIf
				$LyricsFilename = @ScriptDir & "\" & "SongLyrics.txt"
				$hLyricFile = FileOpen($LyricsFilename, 2) ;Open for write and erase existing
				FileWrite($hLyricFile,$LyricsField)
				FileClose($hLyricFile)
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & $LyricsFilename)
				$ID3Filenames &= $LyricsFilename & "|"
			Case "TSSE" ;Software/Hardware and settings used for encoding
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TENC" ;Encoded by
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TCOP" ;Copyright message
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TBPM" ;BPM (beats per minute)
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))	
			Case "TRDA" ;Recording dates
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TRSN" ;Internet radio station name
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TRSO" ;Internet radio station owner
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TSIZ" ;Size
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TSRC" ;ISRC (international standard recording code)
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TCON" ;Content Type/Genre
				$bTagFieldFound = True
				$Genre = _FormatString(_FTPReadFile($hFile,$FrameLen))
				If StringMid($Genre,1,1) == "(" Then ;check if first char is "("
					$closeparindex = StringInStr($Genre,")")
					$GenreID = StringMid($Genre,2,$closeparindex-1)
					$Genre = _GetGenreByID($GenreID)
				EndIf ;If no "(" then return the whole field as is
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & $Genre)
			Case "TLEN" ;Length in ms
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TPUB" ;Publisher
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "NCON" ;??                                     --- non-standard NCON frame in tag
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & "Non-Standard NCON Frame")
				_FTPReadFile($hfile,$FrameLen)
			Case "TFLT" ;File Type
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "UFID" ;Unique File ID
				$bTagFieldFound = True
				$UFID = _FormatString(_FTPReadFile($hFile,$FrameLen))
				$testindex = StringInStr($UFID,"3CD")
				If Not ($testindex == 0) Then
					$UFID = StringMid($UFID,1,$testindex-1)
				EndIf
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & $UFID)
			Case "TCOM" ;Composer
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "WCOM" ;Commercial Info URL
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "WCOP" ;Copyright/Legal information
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "WXXX" ;User defined URL
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "WPAY" ;Payment
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "WOAR" ;Official artist/performer webpage
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "WOAS" ;Official audio source webpage
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "WOAF" ;Official audio file webpage
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "WORS" ;Official internet radio station homepage
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "WPUB" ;Publishers official webpage
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "PRIV" ;Private frame
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "PCNT" ;Play counter
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _HexToUint32(_StringToHex(_FTPReadFile($hFile,4)))) ;Not Tested
			Case Else
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & "Undefined FrameID")
				
		EndSwitch
		
		
	ElseIf StringLen($FrameID) == 3 Then
		
		
		Switch $FrameID
			Case "TT1" ;Content group description
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TT2" ;Title/songname/content description
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TT3" ;Subtitle/Description refinement
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TXT" ;Lyricist/Text writer
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TLA" ;Language(s)
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TKE" ;Initial key
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TMT" ;Media type
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TOT" ;Original album/movie/show title
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TOF" ;Original filename
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TOL" ;Original lyricist(s)/text writer(s)
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TOA" ;Original artist(s)/performer(s)
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TOR" ;Original release year
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TP1" ;Lead performer(s)/Soloist(s)
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TP2" ;Band/orchestra/accompaniment
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TP3" ;Conductor/performer refinement
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TP4" ;Interpreted, remixed, or otherwise modified by
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TPA" ;Part of a set
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TAL" ;Album/Movie/Show title
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TRK" ;Track number/Position in set
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TYE" ;Year
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "COM" ;Comment
				$bTagFieldFound = True
				$CommentField = _FormatString(_FTPReadFile($hFile,$FrameLen))
				$CommentInfo = StringMid($CommentField,1,3)
				If $CommentInfo == "eng" Or $CommentInfo == "XXX" Then
					$CommentField =  StringTrimLeft($CommentField,3)
				EndIf
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & $CommentField)
			Case "PIC" ;Picture
				$bTagFieldFound = True
				$AlbumArtFilename = _GetAlbumArtFTP($hFile,$FrameLen)
				If $AlbumArtFilename == -1 Then
					_ArrayAdd($aID3V2Tag,$FrameID & "|" & "Error: Not JPEG Format")
				Else
					$ID3Filenames &= $AlbumArtFilename & "|"
					_ArrayAdd($aID3V2Tag,$FrameID & "|" & $AlbumArtFilename)
				EndIf
			Case "ULT" ;Lyrics
				$bTagFieldFound = True
				$LyricsField = _FormatString(_FTPReadFile($hFile,$FrameLen))
				$LyricsInfo = StringMid($LyricsField,1,3)
				If $LyricsInfo == "eng" Or $LyricsInfo == "XXX" Then
					$LyricsField = StringTrimLeft($LyricsField,3)
				EndIf
				$LyricsFilename = @ScriptDir & "\" & "SongLyrics.txt"
				$hLyricFile = FileOpen($LyricsFilename, 2) ;Open for write and erase existing
				FileWrite($hLyricFile,$LyricsField)
				FileClose($hLyricFile)
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & $LyricsFilename)
				$ID3Filenames &= $LyricsFilename & "|"
			Case "TSS" ;Software/Hardware and settings used for encoding
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TEN" ;Encoded by
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TCR" ;Copyright message
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TBP" ;BPM (beats per minute)
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))	
			Case "TRD" ;Recording dates
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TSI" ;Size
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TRC" ;ISRC (international standard recording code)
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TCO" ;Content Type/Genre
				$bTagFieldFound = True
				$Genre = _FormatString(_FTPReadFile($hFile,$FrameLen))
				If StringMid($Genre,1,1) == "(" Then ;check if first char is "("
					$closeparindex = StringInStr($Genre,")")
					$GenreID = StringMid($Genre,2,$closeparindex-1)
					$Genre = _GetGenreByID($GenreID)
				EndIf ;If no "(" then return the whole field as is
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & $Genre)
			Case "TLE" ;Length in ms
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TPB" ;Publisher
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "TFT" ;File Type
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "UFI" ;Unique File ID
				$bTagFieldFound = True
				$UFID = _FormatString(_FTPReadFile($hFile,$FrameLen))
				$testindex = StringInStr($UFID,"3CD")
				If Not ($testindex == 0) Then
					$UFID = StringMid($UFID,1,$testindex-1)
				EndIf
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & $UFID)
			Case "TCM" ;Composer
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "WCM" ;Commercial Info URL
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "WCP" ;Copyright/Legal information
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "WXX" ;User defined URL
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "WAR" ;Official artist/performer webpage
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "WAS" ;Official audio source webpage
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "WAF" ;Official audio file webpage
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "WPB" ;Publishers official webpage
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _FormatString(_FTPReadFile($hFile,$FrameLen)))
			Case "RVA" ;Relative volume adjustment
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & "TBP - Relative Volume Adjustment") ;Not Tested
				_FTPReadFile($hFile,$FrameLen)
			Case "CNT" ;Play counter
				$bTagFieldFound = True
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & _HexToUint32(_StringToHex(_FTPReadFile($hFile,4)))) ;Not Tested
			Case Else
				_ArrayAdd($aID3V2Tag,$FrameID & "|" & "Undefined FrameID")
				
		EndSwitch
		
	EndIf
	
	Return $bTagFieldFound
	
EndFunc
; -----------------------------------------------------------------------------




;--------------------------  Support Functions --------------------------------

Func _CheckMPEGHeader($MPEGFrameSyncHex)
	
	$MPEGFrameSyncUint32 = _HexToUint32($MPEGFrameSyncHex)
	
	If $MPEGFrameSyncUint32 > _HexToUint32("FFE00000") Then 
		If $MPEGFrameSyncUint32 < _HexToUint32("FFFFEC00") Then
			If Not(StringMid($MPEGFrameSyncHex,4,1) == "0") Then
				If Not(StringMid($MPEGFrameSyncHex,4,1) == "1") Then
					If Not(StringMid($MPEGFrameSyncHex,4,1) == "9") Then
						;valid MPEG Header Found
						Return 1
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
		
	Return 0

EndFunc

Func _GetAlbumArt($hFile,$FrameLen)

	Local $BytestoRead = 70, $PicStart, $PicFile_h, $AlbumArtFilename, $WriteError
	Local $Checkimage = _StringToHex(FileRead($hFile,$BytestoRead));read in some to find the pic header
	Local $ImageIndex = StringInStr($Checkimage,"00FFD8FFE000") ;index into hex string
	Local $ImageHdr = StringLeft($Checkimage,$ImageIndex-1)

	$ImageHdr = BinaryString("0x" & $ImageHdr)
	$ImageHdr = StringReplace($ImageHdr,Chr(00), Chr(32))
	$ImageHdr = StringReplace($ImageHdr,Chr(01), Chr(32))
	$ImageHdr = StringReplace($ImageHdr,Chr(02), Chr(32))
	$ImageHdr = StringReplace($ImageHdr,Chr(03), Chr(32))
	$ImageHdr = String($ImageHdr)

	If StringInStr($ImageHdr,"jpg") Or StringInStr($ImageHdr,"jpeg") Then
		If StringInStr($ImageHdr,"Cover Image") Then
			$AlbumArtFilename = @ScriptDir & "\" & "AlbumArtCover.jpg"
		Else
			$AlbumArtFilename = @ScriptDir & "\" & "AlbumArt.jpg"
		EndIf
		
		$PicStart = StringTrimLeft($Checkimage,$ImageIndex+1) ;starts at FF not 00FF
		$PicFile_h = FileOpen($AlbumArtFilename, 2) ;Open for write and erase existing
		FileWrite($PicFile_h, BinaryString("0x" & $PicStart))
		$WriteError = FileWrite($PicFile_h,FileRead($hFile, $FrameLen - $BytestoRead))
		FileClose($PicFile_h)
		
	Else
		$AlbumArtFilename = -1
		MsgBox(0,"APIC Error","AlbumArt Found But not jpeg format")
	EndIf

	Return $AlbumArtFilename
	
EndFunc

Func _GetAlbumArtFTP($hFile,$FrameLen)
	 
	$BytestoRead = 70
	$Checkimage = _StringToHex(_FTPReadFile($hFile,$BytestoRead));read in some to find the pic header
	$ImageIndex = StringInStr($Checkimage,"00FFD8FFE000") ;index into hex string

	$ImageHdr = StringLeft($Checkimage,$ImageIndex-1)

	$ImageHdr = BinaryString("0x" & $ImageHdr)
	$ImageHdr = StringReplace($ImageHdr,Chr(00), Chr(32))
	$ImageHdr = StringReplace($ImageHdr,Chr(01), Chr(32))
	$ImageHdr = StringReplace($ImageHdr,Chr(02), Chr(32))
	$ImageHdr = StringReplace($ImageHdr,Chr(03), Chr(32))
	$ImageHdr = String($ImageHdr)

	If StringInStr($ImageHdr,"jpg") Or StringInStr($ImageHdr,"jpeg") Then
		If StringInStr($ImageHdr,"Cover Image") Then
			$AlbumArtFilename = @ScriptDir & "\" & "AlbumArtCover.jpg"
		Else
			$AlbumArtFilename = @ScriptDir & "\" & "AlbumArt.jpg"
		EndIf
		
		;Write picture to local file
		$PicStart = StringTrimLeft($Checkimage,$ImageIndex+1) ;starts at FF not 00FF
		$PicFile_h = FileOpen($AlbumArtFilename, 2) ;Open for write and erase existing
		FileWrite($PicFile_h, BinaryString("0x" & $PicStart))
		$WriteError = FileWrite($PicFile_h,_FTPReadFile($hFile, $FrameLen - $BytestoRead))
		FileClose($PicFile_h)
		
	Else
		$AlbumArtFilename = -1
		MsgBox(0,"APIC Error","AlbumArt Found But not jpeg format")
	EndIf

	Return $AlbumArtFilename
	
EndFunc

;Author: YDY (Lazycat)  Thank you for writing all this out
Func _GetGenreByID($iID)
    Local $asGenre = StringSplit("Blues,Classic Rock,Country,Dance,Disco,Funk,Grunge,Hip-Hop," & _
    "Jazz,Metal,New Age, Oldies,Other,Pop,R&B,Rap,Reggae,Rock,Techno,Industrial,Alternative," & _
    "Ska,Death Metal,Pranks,Soundtrack,Euro-Techno,Ambient,Trip-Hop,Vocal,Jazz+Funk,Fusion," & _
    "Trance,Classical,Instrumental,Acid,House,Game,Sound Clip,Gospel,Noise,Alternative Rock," & _
    "Bass,Soul,Punk,Space,Meditative,Instrumental Pop,Instrumental Rock,Ethnic,Gothic,Darkwave," & _
    "Techno-Industrial,Electronic,Pop-Folk,Eurodance,Dream,Southern Rock,Comedy,Cult,Gangsta," & _
    "Top 40,Christian Rap,Pop/Funk,Jungle,Native US,Cabaret,New Wave,Psychadelic,Rave,Showtunes," & _
    "Trailer,Lo-Fi,Tribal,Acid Punk,Acid Jazz,Polka,Retro,Musical,Rock & Roll,Hard Rock,Folk," & _
    "Folk-Rock,National Folk,Swing,Fast Fusion,Bebob,Latin,Revival,Celtic,Bluegrass,Avantgarde," & _
    "Gothic Rock,Progressive Rock,Psychedelic Rock,Symphonic Rock,Slow Rock,Big Band,Chorus," & _
    "Easy Listening,Acoustic,Humour,Speech,Chanson,Opera,Chamber Music,Sonata,Symphony,Booty Bass," & _
    "Primus,Porn Groove,Satire,Slow Jam,Club,Tango,Samba,Folklore,Ballad,Power Ballad,Rhytmic Soul," & _
    "Freestyle,Duet,Punk Rock,Drum Solo,Acapella,Euro-House,Dance Hall,Goa,Drum & Bass,Club-House," & _
    "Hardcore,Terror,Indie,BritPop,Negerpunk,Polsk Punk,Beat,Christian Gangsta,Heavy Metal,Black Metal," & _
    "Crossover,Contemporary C,Christian Rock,Merengue,Salsa,Thrash Metal,Anime,JPop,SynthPop", ",")
    If ($iID >= 0) and ($iID < 148) Then Return $asGenre[$iID + 1]
    Return("")
EndFunc

Func _FormatString($sBinary)
	
	$sBinary = StringReplace($sBinary,Chr(00), Chr(32))
	$sBinary = StringReplace($sBinary,Chr(01), Chr(32))
	$sBinary = StringReplace($sBinary,Chr(02), Chr(32))
	$sBinary = StringReplace($sBinary,Chr(03), Chr(32))
	
	Return StringStripWS(String($sBinary), 3)
EndFunc

Func _HexToUint32($HexString4Byte)

	Return Dec(StringLeft($HexString4Byte,2)) * Dec("FFFFFF") + Dec(StringTrimLeft($HexString4Byte,2));need this because function Dec is signed

EndFunc

Func _HexToBin($HexString)
	Local $Bin = ""
	For $i = 1 To StringLen($HexString) Step 1
		$Hex = StringRight(StringLeft($HexString, $i), 1)
		Select
		Case $Hex = "0"
			$Bin = $Bin & "0000"
		Case $Hex = "1"
			$Bin = $Bin & "0001"
		Case $Hex = "2"
			$Bin = $Bin & "0010"
		Case $Hex = "3"
			$Bin = $Bin & "0011"
		Case $Hex = "4"
			$Bin = $Bin & "0100"
		Case $Hex = "5"
			$Bin = $Bin & "0101"
		Case $Hex = "6"
			$Bin = $Bin & "0110"
		Case $Hex = "7"
			$Bin = $Bin & "0111"
		Case $Hex = "8"
			$Bin = $Bin & "1000"
		Case $Hex = "9"
			$Bin = $Bin & "1001"
		Case $Hex = "A"
			$Bin = $Bin & "1010"
		Case $Hex = "B"
			$Bin = $Bin & "1011"
		Case $Hex = "C"
			$Bin = $Bin & "1100"
		Case $Hex = "D"
			$Bin = $Bin & "1101"
		Case $Hex = "E"
			$Bin = $Bin & "1110"
		Case $Hex = "F"
			$Bin = $Bin & "1111"
		Case Else
			SetError(-1)
		EndSelect
	Next
	If @error Then 
		Return "ERROR"
	Else
		Return $Bin
	EndIf
EndFunc

Func _BinToHex($BinString)
	Local $Hex = ""
	If Not IsInt(StringLen($BinString) / 4) Then
		$Num = ((StringLen($BinString) / 4) - Int(StringLen($BinString) / 4)) * 4
;~ 		MsgBox(0, "", $Num)
		For $i = 1 To 4 - $Num Step 1
			$BinString = "0" & $BinString
		Next
	EndIf
	
	For $i = 4 To StringLen($BinString) Step 4
		$Bin = StringLeft(StringRight($BinString, $i), 4)
		Select
		Case $Bin = "0000"
			$Hex = $Hex & "0"
		Case $Bin = "0001"
			$Hex = $Hex & "1"
		Case $Bin = "0010"
			$Hex = $Hex & "2"
		Case $Bin = "0011"
			$Hex = $Hex & "3"
		Case $Bin = "0100"
			$Hex = $Hex & "4"
		Case $Bin = "0101"
			$Hex = $Hex & "5"
		Case $Bin = "0110"
			$Hex = $Hex & "6"
		Case $Bin = "0111"
			$Hex = $Hex & "7"
		Case $Bin = "1000"
			$Hex = $Hex & "8"
		Case $Bin = "1001"
			$Hex = $Hex & "9"
		Case $Bin = "1010"
			$Hex = $Hex & "A"
		Case $Bin = "1011"
			$Hex = $Hex & "B"
		Case $Bin = "1100"
			$Hex = $Hex & "C"
		Case $Bin = "1101"
			$Hex = $Hex & "D"
		Case $Bin = "1110"
			$Hex = $Hex & "E"
		Case $Bin = "1111"
			$Hex = $Hex & "F"
		Case Else
			SetError(-1)
		EndSelect
	Next
	If @error Then 
		Return "ERROR"
	Else
		Return _StringReverse($Hex)
	EndIf
EndFunc
; -----------------------------------------------------------------------------

;===============================================================================
;
;
; media info tags UDF by nobbe
; now 	using "mediainfo"                                 
;
; the rest of the info is only for demonstration ..  WMA-INFO. etc-
;
;===============================================================================


#include-once
#include "_debug.au3"; udf for debugging into output window
;

$debug = 0;

Func _media_tag_from_file($myfilename) ; using mediainfo.dll now
	Local $DLL
	Local $rc
	Local $ret_str
	Local $Open_Result
	
	Local $loc_mp3_title = "";
	Local $loc_mp3_artist = "";
	Local $loc_mp3_album = "";
	Local $loc_mp3_year = "";
	Local $loc_mp3_drm = "";

	;Loading the DLL and you can use a full path
	$DLL = DllOpen("MediaInfo.dll") ; make shure it exists in path !!
	
	;New MediaInfo handle
	$Handle = DllCall($DLL, "ptr", "MediaInfo_New") ; ?? fielname???

	;Open you can use a full path
	$Open_Result = DllCall($DLL, "int", "MediaInfo_Open", "ptr", $Handle[0], "wstr", $myfilename) 

	; now get info
	$ret = DllCall($DLL, "wstr", "MediaInfo_Get", "ptr", $Handle[0], "int", 0, "int", 0, "wstr", "Album", "int", 1, "int", 0)
	If $debug > 0 Then
		MsgBox(0, "Get with Stream=General and Parameter=Album", $ret[0])
	EndIf
	$loc_mp3_album = StringStripWS($ret[0], 7);

	$ret = DllCall($DLL, "wstr", "MediaInfo_Get", "ptr", $Handle[0], "int", 0, "int", 0, "wstr", "Title", "int", 1, "int", 0)
	If $debug > 0 Then
		MsgBox(0, "Get with Stream=General and Parameter=Title", $ret[0])
	EndIf
	$loc_mp3_title = StringStripWS($ret[0], 7);

	$ret = DllCall($DLL, "wstr", "MediaInfo_Get", "ptr", $Handle[0], "int", 0, "int", 0, "wstr", "Performer", "int", 1, "int", 0)
	If $debug > 0 Then
		MsgBox(0, "Get with Stream=General and Parameter=Performer", $ret[0])
	EndIf
	$loc_mp3_artist = StringStripWS($ret[0], 7);

	;	$loc_mp3_year = StringStripWS($loc_mp3_year, 7) ; all WS
	;	$loc_mp3_drm = StringStripWS($loc_mp3_drm, 7) ; all WS

	$ret_str = $loc_mp3_artist & "|" & $loc_mp3_title & "|" & $loc_mp3_album & "|" & $loc_mp3_year & "|" & $loc_mp3_drm

	;Delete MediaInfo handle
	$Handle = DllCall($DLL, "none", "MediaInfo_Delete", "ptr", $Handle[0])

	;Close the DLL
	DllClose($DLL)

	Return $ret_str
EndFunc   ;==>_media_tag_from_file








;	$mp3_artist = StringStripWS($val[1], 7) ; all WS
;	$mp3_title = StringStripWS($val[2], 7) ; all WS
;	$mp3_album = StringStripWS($val[3], 7) ; all WS
;	$mp3_year = StringStripWS($val[4], 7) ; all WS
;	$mp3_drm = StringStripWS($val[5], 7) ; all WS
;
; input : filename :full path name required
;
; output : string with relevant information
;
Func _media_tag_from_file_using_wma_info($filename)
	Local $rc
	Local $ret_str
	Local $outfile = "wma.info";
	
	Local $loc_mp3_title = "";
	Local $loc_mp3_artist = "";
	Local $loc_mp3_album = "";
	Local $loc_mp3_year = "";
	Local $loc_mp3_drm = "";
	

	; we need to get file info first ! wait until finished or we get no results
	;
	$pid = RunWait('wma_info.exe "' & $filename & '" ' & $outfile, @ScriptDir, @SW_HIDE) ;;
	
	$file = FileOpen($outfile, 0) ; öffnen und lesen
	If $file = -1 Then
		;MsgBox(0, "Error", "Unable to open file.")
	Else
		
		While 1
			$line = FileReadLine($file)
			If @error = -1 Then ExitLoop
			
			;     MsgBox(0, "Line read:", $line)
			
			If StringInStr($line, "Title:") Then
				$val = StringSplit($line, ":")
				$loc_mp3_title = StringStripWS($val[2], 7) ; all WS
			ElseIf StringInStr($line, "Artist:") Then
				$val = StringSplit($line, ":")
				$loc_mp3_artist = StringStripWS($val[2], 7) ; all WS
			ElseIf StringInStr($line, "Album:") Then
				$val = StringSplit($line, ":")
				$loc_mp3_album = StringStripWS($val[2], 7) ; all WS
			ElseIf StringInStr($line, "Year:") Then
				$val = StringSplit($line, ":")
				$loc_mp3_year = StringStripWS($val[2], 7) ; all WS
			ElseIf StringInStr($line, "DRM:") Then
				$val = StringSplit($line, ":")
				$loc_mp3_drm = StringStripWS($val[2], 7) ; all WS
			EndIf
			
		WEnd
	EndIf ; file open?
	FileClose($file)
	
	$ret_str = $loc_mp3_artist & "|" & $loc_mp3_title & "|" & $loc_mp3_album & "|" & $loc_mp3_year & "|" & $loc_mp3_drm

	Return $ret_str
EndFunc   ;==>_media_tag_from_file_using_wma_info




;
; input : filename :full path name required
;
; output : string with relevant information
;
Func _media_tag_from_file_with_WMPLAYER_OCX($filename)

	Local $rc
	Local $ret_str
	Local $string

	Local $ret1 = "";
	Local $ret2 = "";
	Local $ret3 = "";
	Local $ret4 = "";
	Local $ret5 = "";
	Local $ret6 = "";

	$oPlayer = ObjCreate("WMPlayer.OCX")

	; open ??
	If Not IsObj($oPlayer) Then
		$oPlayer = 0; delete sort of...
		;		_DebugPrint ("obj could not be created");
		Return -1;
	EndIf
	
	$oPlayer.url = $filename 	; Full path required ..
	$rc = $oPlayer.mediaCollection.add ($filename) 	; Full path required ..

	$ret_str = "";

	;pl = Player.mediaCollection.getByAttribute("Title", TrackTitle) ' finds track name. returns a playlist
	;pl = Player.mediaCollection.getByAttribute("Author", TrackArtist) ' find album name


	$ret1 = $oPlayer.currentMedia.getItemInfobyAtom ($oPlayer.mediaCollection.getMediaAtom ("Artist"));
	$ret_str = $ret_str & $ret1 & "|" ;
	If $debug > 0 Then
		_DebugPrint ($ret1)
	EndIf

	$ret2 = $oPlayer.currentMedia.getItemInfobyAtom ($oPlayer.mediaCollection.getMediaAtom ("Title"));
	$ret_str = $ret_str & $ret2 & "|" ;
	If $debug > 0 Then
		_DebugPrint ($ret2)
	EndIf

	$ret3 = $oPlayer.currentMedia.getItemInfobyAtom ($oPlayer.mediaCollection.getMediaAtom ("Album"));
	$ret_str = $ret_str & $ret3 & "|" ;
	If $debug > 0 Then
		_DebugPrint ($ret3);
	EndIf

	$ret4 = $oPlayer.currentMedia.getItemInfobyAtom ($oPlayer.mediaCollection.getMediaAtom ("CreationDate"));
	$ret_str = $ret_str & $ret4 & "|" ;
	If $debug > 0 Then
		_DebugPrint ($ret4);
	EndIf

	$ret5 = $oPlayer.currentMedia.getItemInfobyAtom ($oPlayer.mediaCollection.getMediaAtom ("Is_Protected"));
	$ret_str = $ret_str & $ret5 & "|" ;
	If $debug > 0 Then
		_DebugPrint ($ret5);
	EndIf

	$oPlayer.close () ; not really

	$oPlayer.url = "" 	; Full path required ..
	$oPlayer = 0; delete sort of...

	;	sleep(500); hmm give it some time... aparentyl when too fast , it cannot get info properly

	Return $ret_str;

EndFunc   ;==>_media_tag_from_file_with_WMPLAYER_OCX

#cs
	
	The following attributes are available for an audio item in the library.
	
	* AcquisitionTime Attribute
	* AlbumID Attribute
	* AlbumIDAlbumArtist Attribute
	* Author Attribute
	* AverageLevel Attribute
	* Bitrate Attribute
	* BuyNow Attribute
	* BuyTickets Attribute
	* Channels Attribute
	* Copyright Attribute
	* CurrentBitrate Attribute
	* Duration Attribute
	* FileSize Attribute
	* FileType Attribute
	* Is_Protected
	* IsVBR Attribute
	* MediaType Attribute
	* MoreInfo Attribute
	* PartOfSet Attribute
	* PeakValue Attribute
	* PlaylistIndex Attribute
	* ProviderLogoURL Attribute
	* ProviderURL Attribute
	* RecordingTime Attribute
	* RecordingTimeDay Attribute
	* RecordingTimeMonth Attribute
	* RecordingTimeYear Attribute
	* RecordingTimeYearMonth Attribute
	* RecordingTimeYearMonthDay Attribute
	* ReleaseDate Attribute
	* ReleaseDateDay Attribute
	* ReleaseDateMonth Attribute
	* ReleaseDateYear Attribute
	* ReleaseDateYearMonth Attribute
	* ReleaseDateYearMonthDay Attribute
	* RequestState Attribute
	* ShadowFilePath Attribute
	* SourceURL Attribute
	* SyncState Attribute
	* Title Attribute
	* TrackingID Attribute
	* UserCustom1 Attribute
	* UserCustom2 Attribute
	* UserEffectiveRating Attribute
	* UserLastPlayedTime Attribute
	* UserPlayCount Attribute
	* UserPlaycountAfternoon Attribute
	* UserPlaycountEvening Attribute
	* UserPlaycountMorning Attribute
	* UserPlaycountNight Attribute
	* UserPlaycountWeekday Attribute
	* UserPlaycountWeekend Attribute
	* UserRating Attribute
	* UserServiceRating Attribute
	* WM/AlbumArtist Attribute
	* WM/AlbumTitle Attribute
	* WM/Category Attribute
	* WM/Composer Attribute
	* WM/Conductor Attribute
	* WM/ContentDistributor Attribute
	* WM/ContentGroupDescription Attribute
	* WM/EncodingTime Attribute
	* WM/Genre Attribute
	* WM/GenreID Attribute
	* WM/InitialKey Attribute
	* WM/Language Attribute
	* WM/Lyrics Attribute
	* WM/MCDI Attribute
	* WM/MediaClassPrimaryID Attribute
	* WM/MediaClassSecondaryID Attribute
	* WM/Mood Attribute
	* WM/ParentalRating Attribute
	* WM/Period Attribute
	* WM/ProtectionType Attribute
	* WM/Provider Attribute
	* WM/ProviderRating Attribute
	* WM/ProviderStyle Attribute
	* WM/Publisher Attribute
	* WM/SubscriptionContentID Attribute
	* WM/SubTitle Attribute
	* WM/TrackNumber Attribute
	* WM/UniqueFileIdentifier Attribute
	* WM/WMCollectionGroupID Attribute
	* WM/WMCollectionID Attribute
	* WM/WMContentID Attribute
	* WM/Writer Attribute
	* WM/Year Attribute
#ce
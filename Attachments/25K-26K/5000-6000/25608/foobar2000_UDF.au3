Global $FB2K_TrackChanged
Global $FB2K_Seek
Global $FB2K_PlayPause




Func _FB2K_GetVolume(ByRef $aObjs)
	Return $aObjs[1] .Settings.Volume
EndFunc   ;==>_FB2K_GetVolume

Func _FB2K_SetVolume(ByRef $aObjs, $dVolume)
	$aObjs[1] .Settings.Volume = $dVolume
EndFunc   ;==>_FB2K_SetVolume

Func _FB2K_GetPlaybackOrder($aObjs)
	Return $aObjs[1] .Settings.ActivePlaybackOrder
EndFunc   ;==>_FB2K_GetPlaybackOrder
Func _FB2K_SetPlaybackOrder($aObjs, $sMode)
	$aObjs[1] .Settings.ActivePlaybackOrder = $sMode
EndFunc   ;==>_FB2K_SetPlaybackOrder


Func _FB2K_FormatTrackTitle(ByRef $oTrack, $sTagz)
	Return $oTrack.FormatTitle($sTagz)
EndFunc   ;==>_FB2K_FormatTrackTitle

Func _FB2K_PlayTrack(ByRef $aObjs, ByRef $oPlaylist, $iIndex)
	$aObjs[3] .ActivePlaylist = $oPlaylist
	$oPlaylist.DoDefaultAction($iIndex)
EndFunc   ;==>_FB2K_PlayTrack

Func _FB2K_GetActivePlaylist(ByRef $aObjs)
	Return $aObjs[3] .ActivePlaylist
EndFunc   ;==>_FB2K_GetActivePlaylist

Func _FB2K_SetActivePlaylist(ByRef $aObjs, $oPlaylist)
	$aObjs[3] .ActivePlaylist = $oPlaylist
EndFunc   ;==>_FB2K_SetActivePlaylist


Func _FB2K_GetPlaylistTracks(ByRef $oPlaylist)
	Local $oTracks = $oPlaylist.GetTracks()
	Local $aTracks[$oTracks.Count]
	$i = 0
	For $track In $oTracks
		$aTracks[$i] = $track
		$i += 1
	Next
	Return $aTracks
EndFunc   ;==>_FB2K_GetPlaylistTracks

Func _FB2K_GetPlaylistTrackCount(ByRef $oPlaylist)
	Return $oPlaylist.GetTracks().Count
EndFunc   ;==>_FB2K_GetPlaylistTrackCount

Func _FB2K_GetPlayerPath(ByRef $aObjs)
	Return $aObjs[0] .ApplicationPath
EndFunc   ;==>_FB2K_GetPlayerPath

Func _FB2K_IsMinimized(ByRef $aObjs)
	Return ($aObjs[0] .Minimized = -1)
EndFunc   ;==>_FB2K_IsMinimized


Func _FB2K_Shutdown(ByRef $aObjs)
	For $i = 0 To UBound($aObjs) - 1
		$aObjs[$i] = ""
	Next

EndFunc   ;==>_FB2K_Shutdown

Func _FB2K_GetPlaylists(ByRef $aObjs)
	Local $aPlaylists[$aObjs[3] .Count]
	$i = 0
	For $playlist In $aObjs[3]
		$aPlaylists[$i] = $playlist
		$i += 1
	Next
	Return $aPlaylists
EndFunc   ;==>_FB2K_GetPlaylists

Func _FB2K_GetPlaylistCount(ByRef $aObjs)
	Return $aObjs[3] .Count
EndFunc   ;==>_FB2K_GetPlaylistCount



Func _FB2K_GetVersion(ByRef $aObjs)
	Return $aObjs[0] .Name
EndFunc   ;==>_FB2K_GetVersion




Func _FB2K_Startup($iStartUp = False)
	Local $aArray[4]
	SetError(0)
	If (Not $iStartUp) And (Not ProcessExists("foobar2000.exe")) Then Return SetError(2, 0, -1)
	$aArray[0] = ObjCreate("Foobar2000.Application.0.7")
	If Not IsObj($aArray[0]) Then Return SetError(1, 0, -1)
	$aArray[1] = $aArray[0] .Playback
	ObjEvent($aArray[1], "_FB2K_Event_")
	$aArray[2] = $aArray[0] .MediaLibrary
	$aArray[3] = $aArray[0] .Playlists
	Return $aArray
EndFunc   ;==>_FB2K_Startup

Func _FB2K_GetPlaylistName(ByRef $oPlaylist)
	Return $oPlaylist.Name
EndFunc   ;==>_FB2K_GetPlaylistName


Func _FB2K_AddPlaylist(ByRef $aObjs, $sName)
	Local $oPL = $aObjs[3] .Add($sName)
	Return $oPL
EndFunc   ;==>_FB2K_AddPlaylist

Func _FB2K_RemovePlaylist(ByRef $aObjs, $oPlaylist)
	$aObjs[3] .Remove($oPlaylist)
EndFunc   ;==>_FB2K_RemovePlaylist

Func _FB2K_RenamePlaylist(ByRef $oPlaylist, $sName)
	$oPlaylist.Name = $sName
EndFunc   ;==>_FB2K_RenamePlaylist

Func _FB2K_PlayPause(ByRef $aObjs)
	$aObjs[1] .Pause()
EndFunc   ;==>_FB2K_PlayPause

Func _FB2K_Next(ByRef $aObjs)
	$aObjs[1] .Next ()
EndFunc   ;==>_FB2K_Next

Func _FB2K_Previous(ByRef $aObjs)
	$aObjs[1] .Previous()
EndFunc   ;==>_FB2K_Previous

Func _FB2K_RescanMediaLibrary(ByRef $aObjs)
	$aObjs[2] .Rescan()
EndFunc   ;==>_FB2K_RescanMediaLibrary

Func _FB2K_FormatPlayingTitle(ByRef $aObjs, $sTagz)
	Local $sResult = $aObjs[1] .FormatTitle($sTagz)
	Return $sResult
EndFunc   ;==>_FB2K_FormatPlayingTitle

Func _FB2K_IsPlaying(ByRef $aObjs)
	Local $iState = $aObjs[1] .IsPaused()
	If $iState Then Return 0
	Return 1
EndFunc   ;==>_FB2K_IsPlaying

Func _FB2K_Seek(ByRef $aObjs, $iSeconds)
	$aObjs[1] .Seek($iSeconds)
EndFunc   ;==>_FB2K_Seek

Func _FB2K_SeekRelative(ByRef $aObjs, $iSeconds)
	$aObjs[1] .SeekRelative($iSeconds)
EndFunc   ;==>_FB2K_SeekRelative



#Region Event functions.
Func _FB2K_Event_TrackChanged()
	If $FB2K_TrackChanged <> "" Then Call($FB2K_TrackChanged)
EndFunc   ;==>_FB2K_Event_TrackChanged
#EndRegion Event functions.
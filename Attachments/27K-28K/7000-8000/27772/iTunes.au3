#include <array.au3>
#include <File.au3>

$vol_percent = 10
$Lyric_text = ""
$p_name = "Playlist"
$file_path = ""
$i_num = 1
Global $iTunesApp = ""
Global $Library_Tracks = ""
Global $file = ""
Global $path = ""
$Library_Playlist = ""
$Playlist_Handle = ""

Func _iTunes_Start()
	$iTunesApp = ObjCreate("iTunes.Application")
	$Library_Playlist = $iTunesApp.LibraryPlaylist
	$Library_Tracks = $iTunesApp.LibraryPlaylist.Tracks
	$sel_Track = $iTunesApp.SelectedTracks
	$current_Track = $iTunesApp.CurrentTrack
	$Player_State = $iTunesApp.PlayerState
	$Playlist_Handle = $iTunesApp.LibrarySource.Playlists
EndFunc   ;==>_iTunes_Start

Func _iTunes_Library_Tracks()
	Dim $aArray[1]
	For $item in $Library_Tracks
		_ArrayAdd($aArray, $item.Name)
	Next
	$aArray[0] = _iTunes_Library_CountTracks()
	Return $aArray
EndFunc

Func _iTunes_Vol_Up($vol_percent)
	$iTunesApp.SoundVolume = $iTunesApp.SoundVolume + $vol_percent
EndFunc   ;==>_iTunes_Vol_Up

Func _iTunes_Vol_Down($vol_percent)
	$iTunesApp.SoundVolume = $iTunesApp.SoundVolume - $vol_percent
EndFunc   ;==>_iTunes_Vol_Down

Func _iTunes_Prev()
	$iTunesApp.PreviousTrack
EndFunc   ;==>_iTunes_Prev

Func _iTunes_Next()
	$iTunesApp.NextTrack
EndFunc   ;==>_iTunes_Next

Func _iTunes_Current_LyricsSet($Lyric_text)
	$iTunesApp.CurrentTrack.Lyrics = $Lyric_text
EndFunc   ;==>_iTunes_Set_Lyric

Func _iTunes_Current_LyricsGet()
	Return $iTunesApp.CurrentTrack.Lyrics
EndFunc   ;==>_iTunes_Set_Lyric

Func _iTunes_Current_ArtworkSaveToTmp()
	$file = _TempFile(Default, Default, ".jpg")
	$iTunesApp.CurrentTrack.Artwork(1).SaveArtworkToFile($file)
	Return $file
EndFunc   ;==>_iTunes_Current_Artwork_Get_tmp

Func _iTunes_Current_Artwork_Get($path)
	$iTunesApp.CurrentTrack.Artwork(1).SaveArtworkToFile($file)
EndFunc   ;==>_iTunes_Current_Artwork_Get

Func _iTunes_Current_Artwork_Set($path)
	$iTunesApp.CurrentTrack.Artwork(1).SetArtworkFromFile($path)
EndFunc   ;==>_iTunes_Current_Artwork_Set

Func _iTunes_Play_Pause()
	$iTunesApp.PlayPause
EndFunc   ;==>_iTunes_Play_Pause

Func _iTunes_PlayList_Create($p_name)
	$iTunesApp.CreatePlaylist($p_name)
EndFunc   ;==>_iTunes_PlayList_Create

Func _iTunes_PlayList_Add($PlayList_Name, $song_Name)
	$sng_nm = $Library_Tracks.ItemByName($song_Name)
	$Playlist_Handle.ItemByName($PlayList_Name).AddTrack($sng_nm)
EndFunc   ;==>_iTunes_PlayList_Add

Func _iTunes_Playlist_Delete($PlayList_Name)
	$Playlist_Handle.ItemByName($PlayList_Name).Delete
EndFunc   ;==>_iTunes_Playlist_Delete

Func _iTunes_Playlist_Info($PlayList_Name)
	$playlist = $Playlist_Handle.ItemByName($PlayList_Name)
	$pInfo = _ArrayCreate($playlist.Kind,$playlist.duration,$playlist.shuffle,$playlist.size,$playlist.SongRepeat,$playlist.time,$playlist.Visible)
	Return $pInfo
EndFunc   ;==>_iTunes_Playlist_Info

Func _iTunes_Playlist_PlayFirst($PlayList_Name)
	$Playlist_Handle.ItemByName($PlayList_Name).PlayFirstTrack
EndFunc   ;==>_iTunes_Playlist_PlayFirst

Func _iTunes_Playlist_Search($PlayList_Name,$search)
	dim $return
	$sResults = $Playlist_Handle.ItemByName($PlayList_Name).search($search,0)
	for $track in $sResults
		_ArrayAdd($return,$track)
	Next
	Return $return
EndFunc

Func _iTunes_Library_CountTracks()
	Return $Library_Tracks.Count
EndFunc   ;==>_iTunes_Library_CountTracks

Func _iTunes_Library_AddTrack($path)
	$Library_Playlist.AddTrack($path)
EndFunc   ;==>_iTunes_Library_AddTrack

Func _iTunes_Song_LyricsGet($song_Name)
	return $Library_Tracks.ItemByName($song_Name).Lyrics
EndFunc

Func _iTunes_Song_LyricsSet($song_Name,$lyrics)
	$Library_Tracks.ItemByName($song_Name).Lyrics = $lyrics
EndFunc

Func _iTunes_Song_ArtworkSaveToTmp($song_Name)
	$file = _TempFile(Default, Default, ".jpg")
	$Library_Tracks.ItemByName($song_Name).Artwork(1).SaveArtworkToFile($file)
	Return $file
EndFunc   ;==>_iTunes_Current_Artwork_Get_tmp

Func _iTunes_Song_Artwork_Get($song_Name,$path)
	$Library_Tracks.ItemByName($song_Name).Artwork(1).SaveArtworkToFile($file)
EndFunc   ;==>_iTunes_Current_Artwork_Get

Func _iTunes_Song_Artwork_Set($song_Name,$path)
	$Library_Tracks.ItemByName($song_Name).Artwork(1).SetArtworkFromFile($path)
EndFunc   ;==>_iTunes_Current_Artwork_Set

Func _iTunes_Library_DeleteTrack($song_Name)
	$Library_Tracks.ItemByName($song_Name).Delete
EndFunc   ;==>_iTunes_Library_DeleteTrack

Func _iTunes_Get_Vol()
	Return $iTunesApp.SoundVolume
EndFunc   ;==>_iTunes_Get_Vol

Func _iTunes_Vol_Set($vol_percent)
	$iTunesApp.SoundVolume = $vol_percent
EndFunc   ;==>_iTunes_Set_Vol_Percent

;Func _iTunes_Get_Selected()
	;dim $sTracks
	;for $track in $iTunesApp.SelectedTracks
		;_ArrayAdd($sTracks,$track)
	;Next
;return $sTracks
;EndFunc

Func _iTunes_Get_Selected($flag)
	Dim $aSelTracks[1]

	Switch $flag


		Case 1
			For $track In $iTunesApp.SelectedTracks
				_ArrayAdd($aSelTracks, $track.name)
				$aSelTracks[0] = UBound($aSelTracks)-1
			Next
			
		Case 2
			For $track In $iTunesApp.SelectedTracks
				_ArrayAdd($aSelTracks, $track.Location)
				$aSelTracks[0] = UBound($aSelTracks)-1
			Next

		Case 3
			For $track In $iTunesApp.SelectedTracks
				_ArrayAdd($aSelTracks, $track.Rating)
				$aSelTracks[0] = UBound($aSelTracks)-1
			Next

		Case 4
			For $track In $iTunesApp.SelectedTracks
				_ArrayAdd($aSelTracks, $track.Time)
				$aSelTracks[0] = UBound($aSelTracks)-1
			Next

	EndSwitch

	Return $aSelTracks
EndFunc   ;==>_iTunes_Get_Selected

Func _iTunes_Selected_GetInfo()
dim $sInfo	
	For $track In $iTunesApp.SelectedTracks
		$tInfo = $track.Album & "|" & _
		$track.artist & "|" & _
		$track.BPM & "|" & _
		$track.comment & "|" & _
		$track.Compilation & "|" & _
		$track.Composer & "|" & _
		$track.DateAdded & "|" & _
		$track.Duration & "|" & _
		$track.EQ & "|" & _
		$track.Genre & "|" & _
		$track.KindAsString & "|" & _
		$track.ModificationDate & "|" & _
		$track.PlayedCount & "|" & _
		$track.PlayedDate & "|" & _
		$track.Playlist & "|" & _
		$track.Rating & "|" & _
		$track.SampleRate & "|" & _
		$track.Size & "|" & _
		$track.Time & "|" & _
		$track.TrackNumber & "|" & _
		$track.VolumeAdjustment & "|" & _
		$track.Year
		
			_ArrayAdd($sInfo,$tInfo)
		Next
		
		Return $sInfo
EndFunc   ;==>_iTunes_Selected_GetInfo



Func _iTunes_Song_GetInfo($song_Name)
	$song = $Library_Tracks.ItemByName($song_Name)
	if IsObj($song) then 
		$tInfo = _ArrayCreate($song.Album)
		_ArrayAdd($tInfo, $song.artist)
		_ArrayAdd($tInfo, $song.BPM)
		_ArrayAdd($tInfo, $song.comment)
		_ArrayAdd($tInfo, $song.Compilation)
		_ArrayAdd($tInfo, $song.Composer)
		_ArrayAdd($tInfo, $song.DateAdded)
	_ArrayAdd($tInfo, $song.Duration)
	_ArrayAdd($tInfo, $song.EQ)
	_ArrayAdd($tInfo, $song.Genre)
	_ArrayAdd($tInfo, $song.KindAsString)
	_ArrayAdd($tInfo, $song.ModificationDate)
	_ArrayAdd($tInfo, $song.PlayedCount)
	_ArrayAdd($tInfo, $song.PlayedDate)
	_ArrayAdd($tInfo, $song.Playlist)
	_ArrayAdd($tInfo, $song.Rating)
	_ArrayAdd($tInfo, $song.SampleRate)
	_ArrayAdd($tInfo, $song.Size)
	_ArrayAdd($tInfo, $song.Time)
	_ArrayAdd($tInfo, $song.TrackNumber)
	_ArrayAdd($tInfo, $song.VolumeAdjustment)
	_ArrayAdd($tInfo, $song.Year)

	Return $tInfo
Else
	Return 1
	EndIf
EndFunc   ;==>_iTunes_Song_GetInfo

Func _iTunes_Current_GetInfo()
	$tInfo = _ArrayCreate($iTunesApp.CurrentTrack.Album)
	_ArrayAdd($tInfo, $iTunesApp.CurrentTrack.artist)
	_ArrayAdd($tInfo, $iTunesApp.CurrentTrack.name)
	_ArrayAdd($tInfo, $iTunesApp.CurrentTrack.comment)
	_ArrayAdd($tInfo, $iTunesApp.CurrentTrack.Compilation)
	_ArrayAdd($tInfo, $iTunesApp.CurrentTrack.Composer)
	_ArrayAdd($tInfo, $iTunesApp.CurrentTrack.DateAdded)
	_ArrayAdd($tInfo, $iTunesApp.CurrentTrack.Duration)
	_ArrayAdd($tInfo, $iTunesApp.CurrentTrack.EQ)
	_ArrayAdd($tInfo, $iTunesApp.CurrentTrack.Genre)
	_ArrayAdd($tInfo, $iTunesApp.CurrentTrack.KindAsString)
	_ArrayAdd($tInfo, $iTunesApp.CurrentTrack.ModificationDate)
	_ArrayAdd($tInfo, $iTunesApp.CurrentTrack.PlayedCount)
	_ArrayAdd($tInfo, $iTunesApp.CurrentTrack.PlayedDate)
	_ArrayAdd($tInfo, $iTunesApp.CurrentTrack.Playlist)
	_ArrayAdd($tInfo, $iTunesApp.CurrentTrack.Rating)
	_ArrayAdd($tInfo, $iTunesApp.CurrentTrack.SampleRate)
	_ArrayAdd($tInfo, $iTunesApp.CurrentTrack.Size)
	_ArrayAdd($tInfo, $iTunesApp.CurrentTrack.Time)
	_ArrayAdd($tInfo, $iTunesApp.CurrentTrack.TrackNumber)
	_ArrayAdd($tInfo, $iTunesApp.CurrentTrack.VolumeAdjustment)
	_ArrayAdd($tInfo, $iTunesApp.CurrentTrack.Year)
	
	Return $tInfo
EndFunc   ;==>_iTunes_Current_Get_Info

Func _iTunes_Quit()
	$iTunesApp.Quit
EndFunc   ;==>_iTunes_Quit

Func _iTunes_iPod_Update()
	$iTunesApp.iPodSource.UpdateIPod
EndFunc   ;==>_iTunes_iPod_Update

Func _iTunes_iPod_Eject()
	$iTunesApp.iPodSource.EjectIPod
EndFunc   ;==>_iTunes_iPod_Eject

Func _iTunes_iPod_Version()
	Return $iTunesApp.iPodSource.SoftwareVersion
EndFunc   ;==>_iTunes_iPod_Version

Func _iTunes_Visuals_Enable()
	$iTunesApp.VisualsEnabled = 1
EndFunc   ;==>_iTUnes_Visuals_Enable

Func _iTunes_Visuals_Disable()
	$iTunesApp.VisualsEnabled = 0
EndFunc   ;==>_iTunes_Visuals_Disable

Func _iTunes_Get_ITL_Path()
	Return $iTunesApp.LibraryXMLPath
EndFunc   ;==>_iTunes_Get_ITL_Path

Func _iTunes_Podcast_Subscribe($podcast_url)
	$iTunesApp.SubscribeToPodcast($podcast_url)
EndFunc   ;==>_iTunes_Podcast_Subscribe

Func _iTunes_Podcast_UpdateFeeds()
	$iTunesApp.UpdatePodcastFeeds
EndFunc   ;==>_iTunes_Podcast_UpdateFeeds

Func _iTunes_Player_Get_State()
	Return $iTunesApp.PlayerState
EndFunc   ;==>_iTunes_Player_Get_State

Func _iTunes_MiniPlayer($state = 1)
	If $state = 1 Then
		$iTunesApp.BrowserWindow.MiniPlayer = 1
	Else
		$iTunesApp.BrowserWindow.MiniPlayer = 0
	EndIf
	
	Return $iTunesApp.BrowserWindow.MiniPlayer
EndFunc   ;==>_iTunes_MiniPlayer

Func _iTunes_Unload()
	If IsObj($iTunesApp) Then _iTunes_Quit()
	$iTunesApp = ""
EndFunc	

Func _iTunes_Mute()
    $iTunesApp.Mute = String(not $iTunesApp.Mute)
EndFunc

#cs USER CALLTIP ENRTRIES
_iTunes_Start() Starts iTunes If not running and initializes the functions. Required #include <iTunes.au3>
_iTunes_Vol_Up([$vol_percent = 10]) Volume Up. Required #include <iTunes.au3>
_iTunes_Vol_Down([$vol_percent = 10]) Volume Down. Required #include <iTunes.au3>
_iTunes_Prev() Previous Song. Required #include <iTunes.au3>
_iTunes_Next() Next Song. Required #include <iTunes.au3>
_iTunes_Current_LyricsSet($Lyric_text) Set Lyrics to Current Song. Required #include <iTunes.au3>
_iTunes_Current_LyricsGet() Get Lyrics for Current Song. Required #include <iTunes.au3>
_iTunes_Current_ArtworkSaveToTmp() Save Current Song's Artwork to .tmp file (returns the tmp name). Required #include <iTunes.au3>
_iTunes_Current_Artwork_Get($path) Saves Current Song's Artwork to path. Required #include <iTunes.au3>
_iTunes_Current_Artwork_Set($path) Set Current Song's Artwork form image. Required #include <iTunes.au3>
_iTunes_Play_Pause() Play/Pause. Required #include <iTunes.au3>
_iTunes_PlayList_Create($p_name) Create Playlist. Required #include <iTunes.au3>
_iTunes_PlayList_Add($PlayList_Name, $song_Name)  Add a Library Song to a Playlist. Required #include <iTunes.au3>
_iTunes_Playlist_Delete($PlayList_Name) Delete Playlist. Required #include <iTunes.au3>
_iTunes_Playlist_Info($PlayList_Name) Get Playlist's info. Required #include <iTunes.au3>
_iTunes_Playlist_PlayFirst($PlayList_Name) Play First Song in Playlist. Required #include <iTunes.au3>
_iTunes_Playlist_Search($PlayList_Name,$search) Search Song in Playlist. Required #include <iTunes.au3>
_iTunes_Library_CountTracks() Count Library Tracks. Required #include <iTunes.au3>
_iTunes_Library_AddTrack($path) Add file to library. Required #include <iTunes.au3>
_iTunes_Library_Tracks() Get the Librarie's Track List. Required <iTunes.au3>
_iTunes_Song_LyricsGet($song_Name) Get Song's Lyrics. Required #include <iTunes.au3>
_iTunes_Song_LyricsSet($song_Name,$lyrics) Set Song's Lyrics. Required #include <iTunes.au3>
_iTunes_Song_ArtworkSaveToTmp($song_Name) Save Song's Artwork to .tmp file. Required #include <iTunes.au3>
_iTunes_Song_Artwork_Get($song_Name,$path) Save Song's Artwork to file. Required #include <iTunes.au3>
_iTunes_Song_Artwork_Set($song_Name,$path) Set Song's Artwork form image. Required #include <iTunes.au3>
_iTunes_Library_DeleteTrack($song_Name) Delete track. Required #include <iTunes.au3>
_iTunes_Get_Vol() Get Volume Percentage. Required #include <iTunes.au3>
_iTunes_Vol_Set($vol_percent) Set Volume Percentage. Required #include <iTunes.au3>
_iTunes_Get_Selected() Get Selected Tracks. Required #include <iTunes.au3>
_iTunes_Selected_GetInfo() Returns an array containing Selected Tracks info. Required #include <iTunes.au3>
_iTunes_Song_GetInfo($song_Name) Returns an array containing Song's info. Required #include <iTunes.au3>
_iTunes_Current_GetInfo() Returns an array containing Current Song's Info. Required #include <iTunes.au3>
_iTunes_Quit() Quit iTunes. Required #include <iTunes.au3>
_iTunes_iPod_Update() Update iPod. Required #include <iTunes.au3>
_iTunes_iPod_Eject() Eject iPod. Required #include <iTunes.au3>
_iTunes_iPod_Version() Get iPod Software Version. Required #include <iTunes.au3>
_iTunes_Visuals_Enable() Enable Visuals. Required #include <iTunes.au3>
_iTunes_Visuals_Disable() Disable Visuals. Required #include <iTunes.au3>
_iTunes_Get_ITL_Path() Returns "library.itl" (XML file containing iTunes library info) path. Required #include <iTunes.au3>
_iTunes_Podcast_Subscribe($podcast_url) Subscribe to podcast. Required #include <iTunes.au3>
_iTunes_Podcast_UpdateFeeds() Update Podcast Feeds. Required #include <iTunes.au3>
_iTunes_Player_Get_State() Get Player State. Required #include <iTunes.au3>
_iTunes_MiniPlayer([$state = 1]) Set MiniPlayer state. Required #include <iTunes.au3>
_iTunes_UnLoad() Unload iTunes COM Object. Required #include <iTunes.au3>
_iTunes_Mute() Mute iTunes. Required #include <iTunes.au3>
#ce
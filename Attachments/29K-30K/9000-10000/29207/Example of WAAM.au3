; *  Autoit 3.3.0
; ---------------------------------------
; *  AutoIt3 Syntax Checker v1.54.8
; *  WAAM.au3 - 0 error(s), 0 warning(s)
; *  Exit code: 0    Time: 0.262
; ---------------------------------------
;
; WAAM - WinAmpAutoMate v.016 -- Filename: WAAM.au3 -- Date Released: January 08, 2010
;
; Function: Automation for Radio Stations and Internet Streams
;
; (Explanation of this very simple script; starting from the top):
; * Plays MCID.mp3 (Morse Code Station ID) at the top of every hour. You can use your particular ID instead.
; * Downloads FSNBulletin.mp3 (a 3 minute news spot) to play at noon. (updates itself once an hour in the background)
; * Plays ID and then connects to a live network from 6AM till noon.
; * Moves Previous Days' Podcast to Archives Directory. (thereby cleaning the podcast folders for a new enqueue)
; * While this script runs, Juice Podcast Downloader is downloading the current days' podcast.
; * At 12:00:05, News.m3u is executed, thereby disconnecting from the live network and plays FSNBulletin.mp3 and ID.
; * As News is played, the first podcasts are enqueued. (will play till 3pm)
; * Additional podcasts will be enqueued as the day progresses. (works round the clock)
;
; (Other Information):
; * Script runs Monday thru Friday. (though some functions are still running on weekend. ie: MCID and FSNBulletin update)
; * Script provides us about 98% automation on weekdays. Weekends are free-running on our station.
; * Download.exe is a command line program that can be obtained from: http://noeld.com/programs.asp?cat=misc#download
; * Juice Podcast Downloader can be obtained from: http://juicereceiver.sourceforge.net/
; * This script has only been tested on two Windows XP Pro SP2 machines and runs flawless so far.
;
; (Folder Structure):
; C:\Podcast
; C:\Podcast\Archives
; C:\Podcast\Folder1
; C:\Podcast\Folder2
; C:\Podcast\Folder3
; etc, etc
;
; * Place Download.exe, m3u's, pls's, ID's and News mp3's in folder C:\Podcast
; Folder names will change as Juice is subscribing podcast. You must edit the associated folders to reflect those
; changes and arrange them for the correct time slots that also need editing to suit your taste.
;
; * If you want a seven day week instead of five, edit these lines to reflect this outcome:
;
; From this:  If @WDAY = 2 or @WDAY = 3 or @WDAY = 4 or @WDAY = 5 or @WDAY =6 and @HOUR = 02 and @MIN = 45 and @SEC = 00 Then
;
;   To this:  If @HOUR = 02 and @MIN = 45 and @SEC = 00 Then
;
; * You can add additional lines for the weekend in this example:
;
; If @WDAY = 1 or @WDAY = 7 and @HOUR = 15 and @MIN = 00 and @SEC = 00 Then
; Run('c:\program files\winamp\winamp.exe /add, "c:\Podcast\Folder8"')
; Sleep(1000)
; EndIf
;
; * Or for a particular day in this example:
;
; If @WDAY = 1 and @HOUR = 12 and @MIN = 30 and @SEC = 00 Then
; Run('c:\program files\winamp\winamp.exe /add, "c:\Podcast\Folder9"')
; Sleep(1000)
; EndIf
;
; You can also remove ("or @WDay = #") entrys for odd and even days
;
; ---------------
; End Explanation
; ---------------
;  Begin Script:
; ---------------
;
While 1
	Sleep(245)
	If @MIN = 00 and @SEC = 00 Then
		SoundPlay("c:\Podcast\MCID.mp3", 1) ; Plays ID at the top of every hour
		Sleep(1000)
	EndIf
	If @MIN = 55 and @SEC = 00 Then
		Run(@ComSpec & " /c " & 'c:\Podcast\download.exe                                           /update /output:c:\Podcast', "", @SW_HIDE) ; Downloads the lastest news spot
		Sleep(1000)
	EndIf
	If @WDAY = 2 or @WDAY = 3 or @WDAY = 4 or @WDAY = 5 or @WDAY = 6 and @HOUR = 06 and @MIN = 00 and @SEC = 05 Then
		ShellExecute("c:\Podcast\Network.m3u") ; Start of new day. Hard connect to live network thereby clearing the queue
		Sleep(1000)
	EndIf
	If @WDAY = 2 or @WDAY = 3 or @WDAY = 4 or @WDAY = 5 or @WDAY = 6 and @HOUR = 06 and @MIN = 05 and @SEC = 00 Then
		FileMove("c:\Podcast\Folder1\*.mp3", "c:\Podcast\Archives\Folder1\", 9) ; Primary Podcast Archiver
		Sleep(3000)
		FileMove("c:\Podcast\Folder2\*.mp3", "c:\Podcast\Archives\Folder2\", 9) ; Primary Podcast Archiver
		Sleep(3000)
		FileMove("c:\Podcast\Folder3\*.mp3", "c:\Podcast\Archives\Folder3\", 9) ; Primary Podcast Archiver
		Sleep(3000)
		FileMove("c:\Podcast\Folder4\*.mp3", "c:\Podcast\Archives\Folder4\", 9) ; Primary Podcast Archiver
		Sleep(3000)
		FileMove("c:\Podcast\Folder5\*.mp3", "c:\Podcast\Archives\Folder5\", 9) ; Primary Podcast Archiver
		Sleep(3000)
		FileMove("c:\Podcast\Folder6\*.mp3", "c:\Podcast\Archives\Folder6\", 9) ; Primary Podcast Archiver
		Sleep(3000)
		FileMove("c:\Podcast\Folder7\*.mp3", "c:\Podcast\Archives\Folder7\", 9) ; Primary Podcast Archiver
		Sleep(3000)
		FileMove("c:\Podcast\Folder8\*.mp3", "c:\Podcast\Archives\Folder8\", 9) ; Extra Podcast Archiver
		Sleep(3000)
		FileMove("c:\Podcast\Folder9\*.mp3", "c:\Podcast\Archives\Folder9\", 9) ; Extra Podcast Archiver
		Sleep(1000)
	EndIf
	If @WDAY = 2 or @WDAY = 3 or @WDAY = 4 or @WDAY = 5 or @WDAY = 6 and @HOUR = 12 and @MIN = 00 and @SEC = 05 Then
		ShellExecute("c:\Podcast\News.m3u") ; Hard disconnect from live network and plays 3 minute news and station ID
		Sleep(1000)
	EndIf
	If @WDAY = 2 or @WDAY = 3 or @WDAY = 4 or @WDAY = 5 or @WDAY = 6 and @HOUR = 12 and @MIN = 00 and @SEC = 30 Then
		Run('c:\program files\winamp\winamp.exe /add, "c:\Podcast\Folder1"') ; First podcast enqueue of the day
		Sleep(1000)
	EndIf
	If @WDAY = 2 or @WDAY = 3 or @WDAY = 4 or @WDAY = 5 or @WDAY = 6 and @HOUR = 14 and @MIN = 45 and @SEC = 00 Then
		Run('c:\program files\winamp\winamp.exe /add, "c:\Podcast\Folder2"') ; Second podcast enqueue of the day
		Sleep(1000)
	EndIf
	If @WDAY = 2 or @WDAY = 3 or @WDAY = 4 or @WDAY = 5 or @WDAY = 6 and @HOUR = 16 and @MIN = 30 and @SEC = 00 Then
		Run('c:\program files\winamp\winamp.exe /add, "c:\Podcast\Folder3"') ; Third podcast enqueue of the day
		Sleep(1000)
	EndIf
	If @WDAY = 2 or @WDAY = 3 or @WDAY = 4 or @WDAY = 5 or @WDAY = 6 and @HOUR = 18 and @MIN = 30 and @SEC = 00 Then
		Run('c:\program files\winamp\winamp.exe /add, "c:\Podcast\Folder4"') ; Fourth podcast enqueue of the day
		Sleep(1000)
	EndIf
	If @WDAY = 2 or @WDAY = 3 or @WDAY = 4 or @WDAY = 5 or @WDAY = 6 and @HOUR = 20 and @MIN = 30 and @SEC = 00 Then
		Run('c:\program files\winamp\winamp.exe /add, "c:\Podcast\Folder5"') ; Fifth podcast enqueue of the day
		Sleep(1000)
	EndIf
	If @WDAY = 2 or @WDAY = 3 or @WDAY = 4 or @WDAY = 5 or @WDAY = 6 and @HOUR = 00 and @MIN = 30 and @SEC = 00 Then
		Run('c:\program files\winamp\winamp.exe /add, "c:\Podcast\Folder6"') ; Sixth podcast enqueue of the day
		Sleep(1000)
	EndIf
	If @WDAY = 2 or @WDAY = 3 or @WDAY = 4 or @WDAY = 5 or @WDAY = 6 and @HOUR = 02 and @MIN = 45 and @SEC = 00 Then
		Run('c:\program files\winamp\winamp.exe /add, "c:\Podcast\Folder7"') ; Seventh and last podcast enqueue of the day
		Sleep(1000)
	EndIf
	If @WDAY = 2 or @WDAY = 3 or @WDAY = 4 or @WDAY = 5 or @WDAY = 6 and @HOUR = 02 and @MIN = 50 and @SEC = 00 Then
		Run('c:\program files\winamp\winamp.exe /add, "c:\Podcast\Network.m3u"') ; Soft connect to network. Takes up the slack (20 minutes) between last podcast and live network
		Sleep(1000)
	EndIf
WEnd
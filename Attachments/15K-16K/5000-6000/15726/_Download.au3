#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.5.0 (beta)
 Author:         Acid Corps
 Title:          Auto Download

 Script Function:
	Simplifies Downloading
	
	$sDownload = Link to file to download
	                 Format http://www.example.com/file.exe
					 
	$sFilename = Name to save download file as (optional)
	                 Default: Original name from download link
					 
	$sSize     = Size of file to download (optional)
	                 Format: 100 or 100 KB or 100 MB or 100 GB
	                 If not stated attempts to use InetGetSize (does not always work)
					 
	$sFolder   = Folder to save file to (optional)
	                 Default: Script Directory
	                 Format: C:\My Folder
					 
	$sProxy    = Proxy to connect to the net (optional)
	                 Default: No Proxy
					 Format: Proxy:Port
					 1 = Default Proxy
					 
	$sName     = Username for download (optional)
	                 For use with ftp and some http downloads
					 
	$sPass     = Password for download (optional)
	                 For use with ftp and some http downloads
					 
	$sProgress = Progress bar on or off (optional)
	                 Default: On
					 
	If you do not wish to use ,"", to omit variables then use ,0, and default will be used
	
	Usage: _Download($sDownload, $sFilename, $sSize, $sFolder, $sProxy, $sName, $sPass, $sProgress)

#ce ----------------------------------------------------------------------------

Func _Download($sDownload, $sFilename=0, $sSize=0, $sFolder=0, $sProxy=0, $sName=0, $sPass=0, $sProgress=0)
Opt("ExpandEnvStrings", 1)

;   Setting Proxy
	If $sProxy = 1 Then 
		HttpSetProxy(0)
		FtpSetProxy(0)
	EndIf
	
	If $sProxy <> 0 And $sProxy <> 1 And $sName <> 0 And $sPass <> 0 Then 
		HttpSetProxy(2, $sProxy, $sName, $sPass)
		FtpSetProxy(2, $sProxy, $sName, $sPass)
	EndIf
	
;  Setting Size
	If $sSize = 0 Then
		$ssSize = InetGetSize($sDownload)
	Else
		$ssSize = $sSize
	EndIf
	
	If StringRight($sSize, 2) = "kb" Then $sSizeTimes = 1024
	If StringRight($sSize, 2) = "mb" Then $sSizeTimes = 1048576
	If StringRight($sSize, 2) = "gb" Then $sSizeTimes = 1073741824
	
;   Finding Filename
    If $sFilename = 0 Then
		$ssFilename = StringTrimLeft($sDownload,StringInStr($sDownload,"/",1,-1))
	Else
		$ssFileName = $sFileName
	EndIf
	
;   Progress/Download
    If $sProgress = 0 then
         Dim $ssSize = InetGetSize($sDownload)
		 INetGet($sDownload,$ssFilename)
         ProgressOn("Downloading...", "Retrieving new version.")
                 While @InetGetActive
			     Dim $p = (100 * @InetGetBytesRead) / $ssSize
			     ProgressSet($p, @InetGetBytesRead & "/" & $ssSize & " bytes", "Download in progress.")
             Sleep(250)
		 ProgressOff()
     WEnd
     Else
	     InetGet($sDownload, $ssFilename)

     EndIf
EndFunc


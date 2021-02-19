#include <file.au3>
#include <Array.au3>

;Get the latest Stinger files
InetGet("http://download.nai.com/products/mcafee-avert/", @ScriptDir & "\Stinger.doc")

;Put them in a document
FileOpen("Stinger.doc", 0)

Local $Records[1]
Local $TrimString[100]

;Read array and find specific files
_FileReadToArray("Stinger.doc", $Records)
For $x = 1 to $Records[0]
	IF StringInStr($Records[$x],"stinger101") Then
		$TrimString[$x] = StringMid($Records[$x],61,8);Look for just the 101xxxxx files
	EndIf	
Next

FileClose("Stinger.doc")

;Get the latest one, which is the largest numbered one
$LatestStingerNumber = _ArrayMax($TrimString)

;Download the latest file
;Author ........: guinness
Global $FileURL = "http://download.nai.com/products/mcafee-avert/stinger" & $LatestStingerNumber & ".exe"
Global $File = _InetGetProgress($FileURL, "C:\Documents and Settings\Jon\Desktop\Batch")


Func _InetGetProgress($sURL, $sDirectory = "C:\Documents and Settings\Jon\Desktop\Batch")
    Local $hDownload, $iBytesRead, $iFileSize, $iPercentage, $sFile, $sProgressText
    $sFile = StringRegExpReplace($sURL, "^.*/", "")
    If @error Then
        Return SetError(1, 0, $sFile)
    EndIf
    If StringRight($sDirectory, 1) <> "\" Then
        $sDirectory = $sDirectory & "\"
    EndIf
    $sDirectory = $sDirectory & $sFile
    $iFileSize = InetGetSize($sURL, 1)
    $hDownload = InetGet($sURL, $sDirectory, 0, 1)
    If @error Then
        Return SetError(1, 0, $sFile)
    EndIf
    ProgressOn("", "")
    While InetGetInfo($hDownload, 2) = 0
        $iBytesRead = InetGetInfo($hDownload, 0)
        $iPercentage = $iBytesRead * 100 / $iFileSize
        $sProgressText = "Downloading " & __ByteSuffix($iBytesRead) & " Of " & __ByteSuffix($iFileSize)
        ProgressSet(Round($iPercentage, 0), $sProgressText, "Downloading " & $sDirectory)
        Sleep(100)
    WEnd
    InetClose($hDownload)
    ProgressOff()
    Return $sFile
EndFunc   ;==>_InetGetProgress

Func __ByteSuffix($iBytes)
    Local $A, $aArray[6] = [" B", " KB", " MB", " GB", " TB", " PB"]
    While $iBytes > 1023
        $A += 1
        $iBytes /= 1024
    WEnd
    Return Round($iBytes) & $aArray[$A]
EndFunc   ;==>__ByteSuffix

;Run the file
ShellExecute("stinger" &  $LatestStingerNumber & ".exe", "/ADL /GO /LOG /SILENT", "C:\Documents and Settings\Jon\Desktop\Batch\",  "")


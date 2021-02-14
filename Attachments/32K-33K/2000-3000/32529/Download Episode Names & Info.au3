#include <array.au3>
#include <file.au3>
Global $aFile, $aLinks
Global $IniFilePath, $sSource, $sLink
Global $n = 0

$IniFilePath = "Names.ini"
$sSource = BinaryToString(InetRead("http://www.oneplace.com/ministries/paws-and-tales/listen/broadcast-archives.html"))
$aLinks = StringRegExp($sSource,'(?i)(?s)<a class="EpisodeLink" href="(.*?)">(.*?)</a>',3)
If Not IsArray($aLinks) Then
    MsgBox(0,"error","No links found!")
    Exit
EndIf

FileDelete($IniFilePath)

Global $aLinkTitles[UBound($aLinks)/2][2] ;this is still a good way to create an array is big enough, althoug probably too big if you skip double links.

For $i = 0 To UBound($aLinks) -1 Step 2
    $sLink = StringReplace($aLinks[$i],"/ministries/paws-and-tales/listen/","/player/paws-and-tales/")
    _ArraySearch($aLinkTitles,$sLink) ;check if this link already exists
    If Not @error Then ContinueLoop ;skip the loop if a match was found
    $aLinkTitles[$n][0] = $sLink ;place at the next free index
    $aLinkTitles[$n][1] = StringRegExpReplace($aLinks[$i+1],"(?i)(?:Episode #\d+: ){0,1}(.*?)(?:â€.*){0,1}","$1") ;place at the next free index
    $n += 1 ;increase the link count
Next
ReDim $aLinkTitles[$n][2] ;resize the array to match the amount of links in it.

IniWriteSection($IniFilePath, "Links and Names", $aLinkTitles, 0) ;this saves all itemes in one section.

$IniFilePath = "Desc.ini"
$sSource = BinaryToString(InetRead("http://www.oneplace.com/ministries/paws-and-tales/listen/broadcast-archives.html"))
$aLinks = StringRegExp($sSource,'(?i)(?s)<a class="EpisodeLink" href="(.*?)">(.*?)</a>',3)
If Not IsArray($aLinks) Then
    MsgBox(0,"error","No links found!")
    Exit
EndIf

FileDelete($IniFilePath)

Global $aLinkTitles[UBound($aLinks)/2][2] ;this is still a good way to create an array is big enough, althoug probably too big if you skip double links.

For $i = 0 To UBound($aLinks) -1 Step 2
	$sSource2 = BinaryToString(InetRead($aLinks[$i]),4) 
	$aLinks2 = StringRegExp($sSource2,'(?i)(?s)<div class="EpisodeDescription">(.*?)</div>',3)
    for $j = 0 to UBound($aLinks2) - 1
	$aLinkTitle = StringRegExpReplace($aLinks[$i+1],"(?i)(?:Episode #\d+: ){0,1}(.*?)(?:â€.*){0,1}","$1")
		IniWrite($IniFilePath, "Info", $aLinkTitle, $aLinks2[$j])
Next
Next

MsgBox(0, "Test", "Process complete..")
Func SplitFiles($file,$pathforparts,$nameofparts,$numberofparts)
DirCreate($pathforparts)
$pathoffile = FileRead($file,FileGetSize($file))
$amount = FileGetSize($file)
$parts = $amount/$numberofparts
$round = Floor($parts)
$total = $round * $numberofparts
$leftover = $amount - $total
Dim $part[$numberofparts + 1]
for $i = 1 to $numberofparts
if $i <> 1 and $i <> $numberofparts then 
$part[$i] = StringTrimLeft($pathoffile,($round * $i) - $round )
$left = StringLeft($part[$i],$round)
$part[$i] = $left
EndIf
if $i = $numberofparts then 
	$part[$i] = StringTrimLeft($pathoffile,($round * $i) - $round )
$left = StringLeft($part[$i],$round)
$right = StringRight($pathoffile,$leftover)

$part[$i] = $left & $right
EndIf
if $i = 1 then $part[$i] = FileRead($file,$round)
FileWrite($pathforparts & "\" & $nameofparts & "_" & $i & ".fp",$part[$i])
Next
EndFunc
Func JoinFiles($filename,$pathofparts,$saveparts)
$numberoffiles = 0
	$es = FileFindFirstFile($pathofparts & "\" & "*.fp*")
	If $es = -1 Then
    MsgBox(0, "Error", "can't find any files to join")
    Exit
EndIf
	while 1
	$file = FileFindNextFile($es) 
   If @error Then ExitLoop
$numberoffiles +=1
WEnd
FileClose($es)
	$es = FileFindFirstFile($pathofparts & "\" & "*.fp*")
	If $es = -1 Then
    MsgBox(0, "Error", "can't find any files to join")
    Exit
EndIf
Dim $part[$numberoffiles + 1]
for $i = 1 to $numberoffiles
	$part[$i] = FileFindNextFile($es) 
If @error Then ExitLoop
Next
for $i = 1 to $numberoffiles
	$data = FileRead($pathofparts & "\" & $part[$i],FileGetSize($pathofparts & "\" & $part[$i]))
	FileWrite($pathofparts & "\" & $filename,$data)
Next
if $saveparts = 0 then 
for $i = 1 to $numberoffiles
FileDelete($pathofparts & "\" & $part[$i])
Next
EndIf
EndFunc
Func Attach($file,$attachment)
	$parttoattach = FileRead($attachment,FileGetSize($attachment))
	$sizeoffile = FileRead($file,FileGetSize($file))
	$sizeofattachment = FileGetSize($attachment)
	$filetype = StringSplit($attachment,".",1)
	$extension = $filetype[2]
	FileDelete($file)
	FileWrite($file,$sizeoffile & $parttoattach & "," & $sizeofattachment & "," & $extension)
EndFunc
Func DeAttach($file,$attachmentname,$pathfordeattachment)
$filedata = FileRead($file,FileGetSize($file))
$data = StringRight($filedata,27)
$ins = StringSplit($data,",",1)
if $ins[0] < 3 then MsgBox(16,"Error","There are not attachments attached to that file")
$uselessdata = StringLen($ins[1])
$fileandattachment = StringTrimRight($filedata,27)
$bigfile = FileGetSize($file)
$infoext = StringLen($ins[3])
$infosize = StringLen($ins[2])
$info = $infoext + $infosize + 2
$notattachment = $bigfile - $ins[2] - $info
$partdata = StringTrimLeft($filedata,$notattachment)
$deattachment = StringTrimRight($partdata,$info)

$data2deattach = $deattachment 
FileWrite($pathfordeattachment & $attachmentname& "." & $ins[3],$data2deattach)
EndFunc

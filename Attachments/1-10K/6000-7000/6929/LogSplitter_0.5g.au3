#include<file.au3>
#include<GUIconstants.au3>

opt("GUIoneventmode",1)

$filesize = ""
$path = ""
$file_name1 = "" 
$orig_file = $file_name1 & ".txt"
;~ $splitsize = 50000000
$openorig = FileOpen($path & $orig_file,0)
$fqfilepath = $path & $orig_file
$x = 0
$y = 1

$main = GUICreate("Filesplitter",350,300,-1,-1)
GUISetOnEvent($GUI_EVENT_CLOSE, "SpecialEvents")

$openfile = GUICtrlCreateButton("...",250,40,20,18)
GUICtrlSetOnEvent(-1,"_fileopen")

$list1 = GUICtrlCreateInput($fqfilepath,20,40,230,20, )
;~ GUICtrlSetState(-1,$GUI_ACCEPTFILES)
$label1 = GUICtrlCreateLabel("File to be Split", 20,20,"",20)
$label2 = GUICtrlCreateLabel("Filesize"& $Filesize, 20,100,"",20)
$label3 = GUICtrlCreateLabel("splitsize"& $Filesize, 20,70,"",20)
$button1 = GUICtrlCreateButton("Split File",280,40,-1,20)
GUIctrlSetOnEvent(-1,"_splitfile")

$input = GUICtrlCreateInput ("2",100,70, 40, 20)
$updown = GUICtrlCreateUpdown($input)
$progressbar1 = GUICtrlCreateProgress(20,200,300,20,$PBS_SMooth)
;~ $progressLabel = GUICtrlCreateLabel("Current Progress: ")


GUISetState(@SW_SHOW)

while 1
sleep(10)
WEnd

func _SplitFile()
	while 1
		$splitsize = $input * 1000000
		$x = $x +1 
		$outfile = $file_name1 &"_"& $y &"_split.txt"
		$line = FileRead($openorig,$x)
		$error= @error
		FileWrite($path&$outfile,$line)
		if $error = -1 Then
			Exitloop
		EndIf
		if  FileGetSize($path& $outfile)> $splitsize Then
			$y = $y +1
		EndIf
		GUICtrlSetData ($progressbar1,(FileGetSize($path& $outfile)/$splitsize)*100)

	Wend
	MsgBox(0,"done",$y & " output files")
EndFunc()

Func SpecialEvents()
	if @GUI_CtrlId = $GUI_EVENT_CLOSE Then
		Exit
		EndIf
EndFunc

Func _fileopen()
	$fqfilepath= FileOpenDialog("open",@ScriptDir,"Text files (*.txt)")
	GUICtrlSetData($list1,$fqfilepath)
	$filesize = FileGetSize($fqfilepath)
	GUICtrlSetData($label2,"Filesize: " & round(filegetsize($fqfilepath)/1000,1) & " KBytes")
EndFunc
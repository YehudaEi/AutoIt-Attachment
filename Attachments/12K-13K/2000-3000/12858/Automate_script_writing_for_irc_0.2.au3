#include <File.au3>

$readfile = "read.txt"   ; file to read
$writefile = "write.txt" ; file to write results into 


$mainfile="irc2.48.au3"

$comp=250

$linediff=705	 ;  start place of program from another, 
		 ;  if a mainfile is specified it will be what ever it has unless the text can't be found
$searchbelow=40	 ; Will search to begin with - $searchbelow to the end of the file 

; --------- config-------

_FileCreate($writefile)

$rfile = FileOpen($readfile, 0)
$wfile = FileOpen($writefile, 1)


$placef="yes"
if $mainfile <> "" then 
$maxlines2 = _FileCountLines($mainfile) + 1
$placef="no"
endif




$maxlines = _FileCountLines($readfile) + 1


$buttons = ""
$checkboxes = ""
$inputs = ""
$edits = ""
$combos2 = ""

$nbuttons = ""
$ncheckboxes = ""
$ninputs = ""
$nedits = ""
$ncombos = ""

$rbuttons = ""
$rcheckboxes = ""
$rinputs = ""
$redits = ""
$rcombos = ""

$dbuttons = ""
$dcheckboxes = ""
$dinputs = ""
$dedits = ""
$dcombos = ""

$defbuttons = ""
$defcheckboxes = ""
$definputs = ""
$defedits = ""
$defcombos 	= ""

$tbuttons 	= 0
$tcheckboxes	= 0
$tinputs 	= 0
$tedits 	= 0
$tcombos 	= 0


$now = 0

While $now < $maxlines
	
	$now = $now + 1
	
	$line = FileReadLine($rfile, $now)
	
	$found = "no"
	If StringInStr($line, "GUICtrlCreateButton") > 0 Then $found = "button"
	If StringInStr($line, "GUICtrlCreateCheckbox") > 0 Then $found = "checkbox"
	If StringInStr($line, "GUICtrlCreateInput") > 0 Then $found = "input"
	If StringInStr($line, "GUICtrlCreateEdit") > 0 Then $found = "edit"
	If StringInStr($line, "GUICtrlCreateCombo") > 0 Then $found = "Combo"
	
	If $found <> "no" Then


	if $placef="no" then 
		$mfile = FileOpen($mainfile, 1)


	$now2=$linediff-$searchbelow

	while $placef="no" AND $now2 < $maxlines2
		$now2=$now2+1
		$line2=filereadline($mfile,$now2)
		if $line=$line2 then 
		$placef="yes"
		$linediff=$line2		
		endif
	wend


	if $placef="no" then

	$max=$linediff-$searchbelow+1

	while $placef="no" AND $now2 < $max
		$now2=$now2+1
		$line2=filereadline($mfile,$now2)
		if $line=$line2 then 
		$placef="yes"
		$linediff=$line2		
		endif
	wend
	endif	

	fileclose($mainfile)
	endif

				

		
		$p = StringInStr($line, "= GUICtrlCreate" & $found) - 2
		If $p = -2 Then $p = StringInStr($line, "=GUICtrlCreate " & $found) - 3
		$v = StringStripWS(StringLeft($line, $p), 3)
		
		$ps = StringInStr($line, """")
		$pe = StringInStr($line, """", 0, 2)-$ps+1
		
		$va = $line & ";	Line " & $now + $linediff & @CRLF
		$vb = $v & @CRLF
		$vc = $v & " 	= GUICtrlRead (" & $v & ")" & ";		" & $found &  @CRLF
		$vd = $v & "		= GUICtrlData (" & $v & "," & $v & ")" & ";		" & $found &  @CRLF
		$ve = $v & "		=" & StringMid($line, $ps, $pe) & " ;   Start: " & $ps & " End: " & $pe  & " line "& $now + $linediff & "	" & $found & @CRLF
		
		Switch $found
			
			Case "button"
				$buttons &= $va
				$nbuttons &= $vb
				$rbuttons &= $vc
				$dbuttons &= $vd
				$defbuttons &= $ve
				$tbuttons+=1
				
			Case "checkbox"
				$checkboxes &= $va
				$ncheckboxes &= $vb
				$rcheckboxes &= $vc
				$dcheckboxes &= $vd
				$defcheckboxes &= $ve
				$tcheckboxes+=1
				
			Case "input"
				$inputs &= $va
				$ninputs &= $vb
				$rinputs &= $vc
				$dinputs &= $vd
				$definputs &= $ve
				$tinputs+=1

			Case "edit"
				$edits &= $va
				$nedits &= $vb
				$redits &= $vc
				$dedits &= $vd
				$defedits &= $ve
				$tedits+=1

			Case "Combo"
				$combos2 &= $va
				$ncombos &= $vb
				$rcombos &= $vc
				$dcombos &= $vd
				$defcombos &= $ve
				$tcombos+=1
				
			Case Else
				$nothing = ""
		EndSwitch
		
	EndIf
WEnd


$tfound=$tbuttons + $tcheckboxes + $tinputs + $tedits + $tcombos


FileWrite($wfile, "; ====================== Total found " & $tfound & " - Line diff " & $linediff & " ================================================ " & @CRLF)
FileWrite($wfile, "; --------------- Buttons - " & $tbuttons & " found ---------------------" & @CRLF)
FileWrite($wfile, $nbuttons & @CRLF)

FileWrite($wfile, "; --------------- Checkboxes  - " & $tcheckboxes & " found ---------------------" & @CRLF)
FileWrite($wfile, $ncheckboxes & @CRLF)

FileWrite($wfile, "; --------------- Input - " & $tinputs & " found ---------------------" & @CRLF)
FileWrite($wfile, $ninputs & @CRLF)

FileWrite($wfile, "; --------------- Edits - " & $tedits & " found ---------------------" & @CRLF)
FileWrite($wfile, $nedits & @CRLF)

FileWrite($wfile, "; --------------- Combos  - " & $tcombos & " found ---------------------" & @CRLF)
FileWrite($wfile, $ncombos & @CRLF)


FileWrite($wfile, @CRLF & "; ======================= Defaults =============================================" & @CRLF & @CRLF)

FileWrite($wfile, $defbuttons & @CRLF)
FileWrite($wfile, $defcheckboxes & @CRLF)
FileWrite($wfile, $definputs & @CRLF)
FileWrite($wfile, $defedits & @CRLF)
FileWrite($wfile, $defcombos & @CRLF)


FileWrite($wfile, @CRLF & "; ================== Read GUI CTRL ====================================" & @CRLF & @CRLF)

FileWrite($wfile, $rbuttons & @CRLF)
FileWrite($wfile, $rcheckboxes & @CRLF)
FileWrite($wfile, $rinputs & @CRLF)
FileWrite($wfile, $redits & @CRLF)
FileWrite($wfile, $rcombos & @CRLF)

FileWrite($wfile, "; =========================== Set GUI CTRL=========================================" & @CRLF)

FileWrite($wfile, $dbuttons & @CRLF)
FileWrite($wfile, $dcheckboxes & @CRLF)
FileWrite($wfile, $dinputs & @CRLF)
FileWrite($wfile, $dedits & @CRLF)
FileWrite($wfile, $dcombos & @CRLF)

FileWrite($wfile, "; ======================= Refernce picked up ===================================" & @CRLF)


FileWrite($wfile, @CRLF & "; --------------- Buttons ---------------------" & @CRLF)
FileWrite($wfile, $buttons & @CRLF)

FileWrite($wfile, "; --------------- Checkboxes ---------------------" & @CRLF)
FileWrite($wfile, $checkboxes & @CRLF)

FileWrite($wfile, "; --------------- Input ---------------------" & @CRLF)
FileWrite($wfile, $inputs & @CRLF)

FileWrite($wfile, "; --------------- Edits ---------------------" & @CRLF)
FileWrite($wfile, $edits & @CRLF)

FileWrite($wfile, "; --------------- Combos ---------------------" & @CRLF)
FileWrite($wfile, $combos2 & @CRLF)


;StringStripWS ( "string", flag )




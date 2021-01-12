#CS
_________________________________________
	Adam1213™ -                   
	Release date: 14/1/07
_________________________________________
#CE

#include <File.au3>
#Include <Array.au3>

$testmode=0
$movedir=0

$filter=InputBox ("Renamer", "Filter (* at end for end)", "", "", 400,100, -1, -1)
if $filter='ext' then
	extrenamer()
endif
if stringright($filter,1)='*' Then 
	$locate=1; // end of name
	$filter=StringTrimRight($filter, 1)
	$description=' Put * at end to keep end'
else
	$description=''
	$locate=0; // start of name
endif

$moveto=InputBox ("Renamer", "Move to"&$description, $filter&"\"&$filter, "", 400,100, -1, -1)

if $locate=1 and stringright($moveto, 1)='*' Then 
	$moveto=StringTrimRight($moveto, 1)
	$keepend=1
else 
	$keepend=0
endif


;if $moveto=='' then 
;	exit
;endif

$dpos=stringinstr($moveto, '\')
if $dpos>0 then
	if $dpos=stringlen($moveto) then 
		$movedir=1;
		$dir=$moveto
	else 
		$dir=stringleft($moveto, $dpos)
	endif
	if $testmode=0 then DirCreate ($dir)
endif

$len=stringlen($filter)


$FileList=_FileListToArray(@workingdir, '*' & $filter &'*', 1)
If (Not IsArray($FileList)) and (@Error=1) Then
    MsgBox (0,"","No Files\Folders Found.")
    Exit
EndIf
;_ArrayDisplay($FileList,"$FileList")

$r=0

for $i=1 to $FileList[0]
	$oldname=$FileList[$i]
	if $oldname='r.au3' then continueloop
	$ext=stringmid($oldname, StringInStr($oldname, '.', 0, -1))
	$ext_l=stringlen($ext)
	
	if $locate then 
		$t=stringright($oldname, $ext_l+$len); = END OF NAME ====
		$t=stringmid($t, 1, $len)
	else 
		$t=stringleft($oldname, $len); =================================== START OF NAME ===
	endif

	if $testmode then msgbox(0,'Test',$oldname&': '&$filter&'='&$t)
	;if $i>10 then exit
	
	if $t=$filter then
		$r+=1
		if $locate then
			;=============== END OF NAME ========================================
			if $keepend then
				$newname=stringmid($oldname, 1, stringlen($oldname)-$ext_l+1) & $ext
			else
				$newname=stringmid($oldname, 1, stringlen($oldname)-$len-$ext_l) & $ext
			endif
		else 
			;=============== START OF NAME ========================================
			$newname=stringmid($oldname, $len+1)
		endif
		$newname=$moveto&$newname
		if $r=1 then  msgbox(0,$oldname,$newname)
		if $TESTMODE=0 then
			FileMove ($oldname, $newname)
		else
			msgbox(0,'Rename', $oldname&@CRLF&$newname)
		endif
	endif
next

func extrenamer()
	$newext=InputBox ("Renamer", "Add at end", '', "", 400,100, -1, -1)
		
	$FileList=_FileListToArray(@workingdir)
	If (Not IsArray($FileList)) and (@Error=1) Then
		MsgBox (0,"","No Files\Folders Found.")
		Exit
	EndIf
	_ArrayDisplay($FileList,"$FileList")

	$r=0

	for $i=1 to $FileList[0]
		$oldname=$Filelist[$i]
		$newname=$oldname&$newext
		FileMove ($oldname, $newname, 9)	
		
		exit;
		exit;
		$a=$b+1
	next
endfunc
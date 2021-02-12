;================================================================= Game boot ===========================================================
;Author: Nguyen Huy Truong (xx3004@yahoo.com)
;=======================================================================================================================================
#include <File.au3>
#include <String.au3>

;=================================Constant declaration====================
$lngFile=@ScriptDir&"\en-us.lg";
;=================================End declaration=========================

;=================================Basic function==========================
Func w($num);
	If $num <10 Then $num="00"&$num;
	If $num <100 And $num >9 Then $num="0"&$num;
	$s=IniReadSectionNames($lngFile);
	$section=$s[1];
	Return IniRead($lngFile, "TBG", $num, "Error");
EndFunc

Func e($txt);
	Return _StringEncrypt(1, $txt, "dX", 1);
EndFunc

Func d($txt);
	Return _StringEncrypt(0, $txt, "dX", 1);
EndFunc

Func bInfo($fID, $fPs);
	IniWrite(@ScriptDir&"\dsm\dat.dxf", $fID, "ps", e($fPs));
	IniWrite(@ScriptDir&"\dsm\dat.dxf", $fID, "exp", e(0));
	IniWrite(@ScriptDir&"\dsm\dat.dxf", $fID, "ck", e(0));
	IniWrite(@ScriptDir&"\dsm\dat.dxf", $fID, "pt", e(0));
	IniWrite(@ScriptDir&"\dsm\dat.dxf", $fID, "nn", e(0));
	IniWrite(@ScriptDir&"\dsm\dat.dxf", $fID, "mm", e(0));
	IniWrite(@ScriptDir&"\dsm\dat.dxf", $fID, "tm", e(0));
	IniWrite(@ScriptDir&"\dsm\dat.dxf", $fID, "hg", e(0));
	IniWrite(@ScriptDir&"\dsm\dat.dxf", $fID, "st", e(0));
	IniWrite(@ScriptDir&"\dsm\dat.dxf", $fID, "vk", e(1));
	IniWrite(@ScriptDir&"\dsm\dat.dxf", $fID, "cvk", e(1));
	IniWrite(@ScriptDir&"\dsm\dat.dxf", $fID, "kh", e(1));
	IniWrite(@ScriptDir&"\dsm\dat.dxf", $fID, "ckh", e(1));
	IniWrite(@ScriptDir&"\dsm\dat.dxf", $fID, "ar", e(1));
	IniWrite(@ScriptDir&"\dsm\dat.dxf", $fID, "car", e(1));
	IniWrite(@ScriptDir&"\dsm\dat.dxf", $fID, "hm", e(1));
	IniWrite(@ScriptDir&"\dsm\dat.dxf", $fID, "chm", e(1));
	IniWrite(@ScriptDir&"\dsm\dat.dxf", $fID, "r1", e(1));
	IniWrite(@ScriptDir&"\dsm\dat.dxf", $fID, "cr1", e(1));
	IniWrite(@ScriptDir&"\dsm\dat.dxf", $fID, "r2", e(1));
	IniWrite(@ScriptDir&"\dsm\dat.dxf", $fID, "cr2", e(1));
	IniWrite(@ScriptDir&"\dsm\dat.dxf", $fID, "aml", e(1));
	IniWrite(@ScriptDir&"\dsm\dat.dxf", $fID, "caml", e(1));
	IniWrite(@ScriptDir&"\dsm\dat.dxf", $fID, "gs", e(0));
	IniWrite(@ScriptDir&"\dsm\dat.dxf", $fID, "g", e(500));
	IniWrite(@ScriptDir&"\dsm\dat.dxf", $fID, "c", e(0));
	;Stuff=url#name#ck#pt#nn#mm#tm#hg#st
	IniWrite(@ScriptDir&"\dsm\inv_vk.inv", $fID, 1, e("b.jpg#Stone Hammer#25#5#5#5#5#0#50"));
	IniWrite(@ScriptDir&"\dsm\inv_kh.inv", $fID, 1, e("nud.jpg#Wooden Shield#5#10#5#5#5#2#0"));
	IniWrite(@ScriptDir&"\dsm\inv_ar.inv", $fID, 1, e("nud.jpg#Wooden Armor#5#10#5#5#5#2#0"));
	IniWrite(@ScriptDir&"\dsm\inv_hm.inv", $fID, 1, e("nud.jpg#Wooden Helmet#5#10#5#5#5#2#0"));
	IniWrite(@ScriptDir&"\dsm\inv_r1.inv", $fID, 1, e("nud.jpg#Ring of Luck#5#5#5#10#5#0#0"));
	IniWrite(@ScriptDir&"\dsm\inv_r2.inv", $fID, 1, e("nud.jpg#Ring of Intelligence#5#5#5#5#10#0#0"));
	IniWrite(@ScriptDir&"\dsm\inv_aml.inv", $fID, 1, e("nud.jpg#Pendent of power#10#5#5#5#10#0#0"));
EndFunc
;=================================End function============================

;Check users list
If (FileExists(@ScriptDir&"\users.dxf")==0) Then
	_FileCreate(@ScriptDir&"\users.dxf");
	$id=InputBox(w(29), w(30), w(31));
	$ps=InputBox(w(29), w(032), "", w(033));
	$f=FileOpen(@ScriptDir&"\users.dxf", 2);
	FileWrite($f, $id);
	FileClose($f);
	DirCreate(@ScriptDir&"\dsm\");
	_FileCreate(@ScriptDir&"\dsm\dat.dxf");
	$f=FileOpen(@ScriptDir&"\dsm\dat.dxf", 2);
	FileWrite($f, "["&$id&"]");
	FileClose($f);
	_FileCreate(@ScriptDir&"\dsm\inv_gs.inv");
	_FileCreate(@ScriptDir&"\dsm\inv_vk.inv");
	_FileCreate(@ScriptDir&"\dsm\inv_kh.inv");
	_FileCreate(@ScriptDir&"\dsm\inv_r1.inv");
	_FileCreate(@ScriptDir&"\dsm\inv_r2.inv");
	_FileCreate(@ScriptDir&"\dsm\inv_ar.inv");
	_FileCreate(@ScriptDir&"\dsm\inv_hm.inv");
	_FileCreate(@ScriptDir&"\dsm\inv_aml.inv");
	bInfo($id, $ps);
EndIf

Run(@ScriptDir&"\TBG.exe");
Exit;
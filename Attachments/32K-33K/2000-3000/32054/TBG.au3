;================================================================= Game .exe ===========================================================
;Author: Nguyen Huy Truong (xx3004@yahoo.com)
;=======================================================================================================================================

#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#include <String.au3>
#include <GUIListBox.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>

;=================================Constant declaration====================
$lngFile=@ScriptDir&"\en-us.lg";
Const $uID=FileRead(@ScriptDir&"\users.dxf");
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

Func g($type,$currentUse, $num);
	$temp=StringSplit(d(IniRead(@ScriptDir&"\dsm\inv_"&$type&".inv", $uID, $currentUse, "Error")), "#");
	Return $temp[$num];
EndFunc

Func requestData();
	;EXP ck pt nn mm tm hg st cvk ckh chm car cr1 cr2 caml ack apt ann amm atm ahg ast c ;
	Global $t[500];
	$t['exp']=d(IniRead(@ScriptDir&"\dsm\dat.dxf", $uID, "exp", "Error"));
	$t['ck']=d(IniRead(@ScriptDir&"\dsm\dat.dxf", $uID, "ck", "Error"));
	$t['pt']=d(IniRead(@ScriptDir&"\dsm\dat.dxf", $uID, "pt", "Error"));
	$t['nn']=d(IniRead(@ScriptDir&"\dsm\dat.dxf", $uID, "nn", "Error"));
	$t['mm']=d(IniRead(@ScriptDir&"\dsm\dat.dxf", $uID, "mm", "Error"));
	$t['tm']=d(IniRead(@ScriptDir&"\dsm\dat.dxf", $uID, "tm", "Error"));
	$t['hg']=d(IniRead(@ScriptDir&"\dsm\dat.dxf", $uID, "hg", "Error"));
	$t['st']=d(IniRead(@ScriptDir&"\dsm\dat.dxf", $uID, "st", "Error"));
	$t['cvk']=d(IniRead(@ScriptDir&"\dsm\dat.dxf", $uID, "cvk", "Error"));
	$t['ckh']=d(IniRead(@ScriptDir&"\dsm\dat.dxf", $uID, "ckh", "Error"));
	$t['chm']=d(IniRead(@ScriptDir&"\dsm\dat.dxf", $uID, "chm", "Error"));
	$t['car']=d(IniRead(@ScriptDir&"\dsm\dat.dxf", $uID, "car", "Error"));
	$t['cr1']=d(IniRead(@ScriptDir&"\dsm\dat.dxf", $uID, "cr1", "Error"));
	$t['cr2']=d(IniRead(@ScriptDir&"\dsm\dat.dxf", $uID, "cr2", "Error"));
	$t['caml']=d(IniRead(@ScriptDir&"\dsm\dat.dxf", $uID, "caml", "Error"));
	$t['c']=d(IniRead(@ScriptDir&"\dsm\dat.dxf", $uID, "c", "Error"));
	$t['g']=d(IniRead(@ScriptDir&"\dsm\dat.dxf", $uID, "g", "Error"));
	$t['vk']=d(IniRead(@ScriptDir&"\dsm\dat.dxf", $uID, "vk", "Error"));
	$t['kh']=d(IniRead(@ScriptDir&"\dsm\dat.dxf", $uID, "kh", "Error"));
	$t['ar']=d(IniRead(@ScriptDir&"\dsm\dat.dxf", $uID, "ar", "Error"));
	$t['r1']=d(IniRead(@ScriptDir&"\dsm\dat.dxf", $uID, "r1", "Error"));
	$t['r2']=d(IniRead(@ScriptDir&"\dsm\dat.dxf", $uID, "r2", "Error"));
	$t['aml']=d(IniRead(@ScriptDir&"\dsm\dat.dxf", $uID, "aml", "Error"));
	;1=url 2=name 3=ck 4=pt 5=nn 6=mm 7=tm 8=hg 9=st
	$t['tck']=g('vk', $t['cvk'], 3)+g('ar', $t['car'], 3)+g('r1', $t['cr1'], 3)+g('r2', $t['cr2'], 3)+g('aml', $t['caml'], 3)+g('kh', $t['ckh'], 3)+g('hm', $t['chm'], 3);
	$t['tck']=g('vk', $t['cvk'], 3)+g('ar', $t['car'], 3)+g('r1', $t['cr1'], 3)+g('r2', $t['cr2'], 3)+g('aml', $t['caml'], 3)+g('kh', $t['ckh'], 3)+g('hm', $t['chm'], 3);
	;$t['tpt']=g('vk', $t['cvk'], 4)+g('ar', $t['car'], 4)+g('r1', $t['cr1'], 4)+g('r2', $t['cr2'], 4)+g('aml', $t['caml'], 4)+g('kh', $t['ckh'], 4)+g('hm', $t['chm'], 4)
	;$t['tnn']=g('vk', $t['cvk'], 5)+g('ar', $t['car'], 5)+g('r1', $t['cr1'], 5)+g('r2', $t['cr2'], 5)+g('aml', $t['caml'], 5)+g('kh', $t['ckh'], 5)+g('hm', $t['chm'], 5);
	;$t['tmm']=g('vk', $t['cvk'], 6)+g('ar', $t['car'], 6)+g('r1', $t['cr1'], 6)+g('r2', $t['cr2'], 6)+g('aml', $t['caml'], 6)+g('kh', $t['ckh'], 6)+g('hm', $t['chm'], 6);
	;$t['ttm']=g('vk', $t['cvk'], 7)+g('ar', $t['car'], 7)+g('r1', $t['cr1'], 7)+g('r2', $t['cr2'], 7)+g('aml', $t['caml'], 7)+g('kh', $t['ckh'], 7)+g('hm', $t['chm'], 7);
	;$t['tst']=g('vk', $t['cvk'], 8)+g('ar', $t['car'], 8)+g('r1', $t['cr1'], 8)+g('r2', $t['cr2'], 8)+g('aml', $t['caml'], 8)+g('kh', $t['ckh'], 8)+g('hm', $t['chm'], 8);
	;$t['thg']=g('vk', $t['cvk'], 9)+g('ar', $t['car'], 9)+g('r1', $t['cr1'], 9)+g('r2', $t['cr2'], 9)+g('aml', $t['caml'], 9)+g('kh', $t['ckh'], 9)+g('hm', $t['chm'], 9);
EndFunc

;Func updateDes($item);
	;If $item == 'hm' Then
	;	MsgBox(0,"",g('hm', $t['chm'], 2));
		;GUICtrlSetData($listDes, g('hm', $t['chm'], 2));
		;GUICtrlSetData($listDes, "Attack: "&g('hm', $t['chm'], 3));
		;GUICtrlSetData($listDes, "Defense: "&g('hm', $t['chm'], 4));
		;GUICtrlSetData($listDes, "Agility: "&g('hm', $t['chm'], 5));
		;GUICtrlSetData($listDes, "Luck: "&g('hm', $t['chm'], 6));
		;GUICtrlSetData($listDes, "Intelligence: "&g('hm', $t['chm'], 7));
		;GUICtrlSetData($listDes, "Armor: "&g('hm', $t['chm'], 8));
		;GUICtrlSetData($listDes, "Damage: "&g('hm', $t['chm'], 9));
	;EndIf
;EndFunc;
;=================================End function============================
requestData();
$gameForm = GUICreate(w(1), 506, 501, 386, 189);
$sAR = GUICtrlCreateButton(w(4), 410, 8, 87, 27);
GUICtrlCreateTab(8, 40, 489, 457);
GUICtrlSetResizing(-1, $GUI_DOCKWIDTH+$GUI_DOCKHEIGHT);

;=======================================================================
$cardsTab = GUICtrlCreateTabItem(w(5));
$t1 = GUICtrlCreateLabel(w(11), 24, 72, 359, 17);
$t2 = GUICtrlCreateLabel(w(12), 24, 88, 362, 17);
$t3 = GUICtrlCreateLabel(w(13), 24, 104, 370, 17);
$cti = GUICtrlCreatePic(@ScriptDir&"\Images\ct.jpg", 15, 128, 113, 89);
$hvi = GUICtrlCreatePic(@ScriptDir&"\Images\hv.jpg", 136, 128, 113, 89);
$tli = GUICtrlCreatePic(@ScriptDir&"\Images\tl.jpg", 256, 128, 113, 89);
$bhi = GUICtrlCreatePic(@ScriptDir&"\Images\bh.jpg", 376, 128, 113, 89);
$ct = GUICtrlCreateRadio("", 60, 224, 17, 17);
$hv = GUICtrlCreateRadio("", 187, 224, 17, 17);
$tl = GUICtrlCreateRadio("", 307, 224, 17, 17);
$bh = GUICtrlCreateRadio("", 425, 224, 17, 17);
$des = GUICtrlCreateLabel(w(14), 24, 248, 452, 17);
$instruct = GUICtrlCreateEdit("", 24, 272, 457, 209, BitOR($ES_AUTOVSCROLL,$ES_AUTOHSCROLL,$ES_READONLY,$ES_WANTRETURN,$WS_VSCROLL, $ES_MULTILINE));
GUICtrlSetData(-1, w(19)&@CRLF&"     "&w(20)&@CRLF&"     "&w(21)&@CRLF&"     "&w(22)&@CRLF&"     "&w(23)&@CRLF&"     "&w(24)&@CRLF&w(25)&@CRLF&w(26)&@CRLF&w(27));
;=======================================================================

;=======================================================================
$infoTab = GUICtrlCreateTabItem(w(34));
$l5 = GUICtrlCreateLabel(w(35), 16, 72, 35, 17);
$l6 = GUICtrlCreateLabel(w(36), 192, 72, 36, 17);
$l7 = GUICtrlCreateLabel(w(37), 296, 72, 28, 17);
$expPro = GUICtrlCreateProgress(40, 96, 425, 17, BitOR($PBS_SMOOTH,$WS_BORDER));
$lvl1 = GUICtrlCreatePic(@ScriptDir&"\Levels\1.gif", 256, 70, 17, 17, BitOR($SS_NOTIFY,$WS_GROUP,$WS_BORDER));
$lvl2 = GUICtrlCreatePic(@ScriptDir&"\Levels\1.gif", 16, 96, 17, 17, BitOR($SS_NOTIFY,$WS_GROUP,$WS_BORDER));
$lvl3 = GUICtrlCreatePic(@ScriptDir&"\Levels\2.gif", 472, 96, 17, 17, BitOR($SS_NOTIFY,$WS_GROUP,$WS_BORDER));
$lv1 = GUICtrlCreateLabel("Level 1", 16, 120, 39, 17);
$lv2 = GUICtrlCreateLabel("Level 2", 448, 120, 39, 17);
$l8 = GUICtrlCreateLabel(w(38), 16, 136, 258, 17);
$hmi = GUICtrlCreatePic(@ScriptDir&"\Weapons\nud.jpg", 192, 160, 89, 89, BitOR($SS_NOTIFY,$WS_GROUP));
$wi = GUICtrlCreatePic(@ScriptDir&"\Weapons\stool.jpg", 72, 256, 89, 89, BitOR($SS_NOTIFY,$WS_GROUP));
$si = GUICtrlCreatePic(@ScriptDir&"\Weapons\nud.jpg", 328, 248, 89, 89, BitOR($SS_NOTIFY,$WS_GROUP));
$ari = GUICtrlCreatePic(@ScriptDir&"\Weapons\nud.jpg", 200, 256, 89, 89, BitOR($SS_NOTIFY,$WS_GROUP));
$r2i = GUICtrlCreatePic(@ScriptDir&"\Weapons\nud.jpg", 376, 160, 33, 33, BitOR($SS_NOTIFY,$WS_GROUP));
$r1i = GUICtrlCreatePic(@ScriptDir&"\Weapons\nud.jpg", 328, 160, 33, 33, BitOR($SS_NOTIFY,$WS_GROUP));
$ami = GUICtrlCreatePic(@ScriptDir&"\Weapons\nud.jpg", 352, 208, 33, 33, BitOR($SS_NOTIFY,$WS_GROUP));
$atk = GUICtrlCreateProgress(88, 368, 361, 17, BitOR($PBS_SMOOTH,$WS_BORDER));
$def = GUICtrlCreateProgress(88, 392, 361, 17, BitOR($PBS_SMOOTH,$WS_BORDER));
$agi = GUICtrlCreateProgress(88, 416, 361, 17, BitOR($PBS_SMOOTH,$WS_BORDER));
$lck = GUICtrlCreateProgress(88, 440, 361, 17, BitOR($PBS_SMOOTH,$WS_BORDER));
$int = GUICtrlCreateProgress(88, 464, 361, 17, BitOR($PBS_SMOOTH,$WS_BORDER));
$l9 = GUICtrlCreateLabel(w(39), 24, 368, 54, 17);
$l10 = GUICtrlCreateLabel(w(40), 24, 392, 56, 17);
$l11 = GUICtrlCreateLabel(w(41), 24, 416, 50, 17);
$l12 = GUICtrlCreateLabel(w(42), 24, 440, 55, 17);
$l13 = GUICtrlCreateLabel(w(43), 24, 464, 61, 17);
$l14 = GUICtrlCreateLabel("0", 456, 368, 34, 17);
$l15 = GUICtrlCreateLabel("0", 456, 392, 34, 17);
$l16 = GUICtrlCreateLabel("0", 456, 416, 34, 17);
$l17 = GUICtrlCreateLabel("0", 456, 440, 34, 17);
$l18 = GUICtrlCreateLabel("0", 456, 464, 34, 17);
$listDes = GUICtrlCreateList("", 16, 160, 153, 84, $WS_VSCROLL);
;=======================================================================

;=======================================================================
$inventoryTab = GUICtrlCreateTabItem(w(6));
;=======================================================================

;=======================================================================
$worksTab = GUICtrlCreateTabItem(w(7));
;=======================================================================

;=======================================================================
$arenaTab = GUICtrlCreateTabItem(w(8));
;=======================================================================

;=======================================================================
$smithTab = GUICtrlCreateTabItem(w(9));
;=======================================================================

;=======================================================================
$shopTab = GUICtrlCreateTabItem(w(28));
;=======================================================================

;=======================================================================
$beastTab = GUICtrlCreateTabItem(w(10));
;=======================================================================
$id=FileRead(@ScriptDir&"\users.dxf");
GUICtrlCreateTabItem("");
GUISetState(@SW_SHOW);

While 1;
	$nMsg = GUIGetMsg();
	Switch $nMsg;
		Case $GUI_EVENT_CLOSE;
			Exit;
		Case $ct;
			GUICtrlSetData($des, w(15));
			IniWrite(@ScriptDir&"\DSM\dat.dxf", $id, "c", e("13#0#0#0#0#0#0"));
		Case $hv;
			GUICtrlSetData($des, w(16));
			IniWrite(@ScriptDir&"\DSM\dat.dxf", $id, "c", e("0#13#0#0#0#0#0"));
		Case $tl;
			GUICtrlSetData($des, w(17));
			IniWrite(@ScriptDir&"\DSM\dat.dxf", $id, "c", e("0#0#13#0#0#0#0"));
		Case $bh;
			GUICtrlSetData($des, w(18));
			IniWrite(@ScriptDir&"\DSM\dat.dxf", $id, "c", e("0#0#0#13#0#0#0"));
		Case $hmi;
			;updateDes('hm');
		Case $wi;
			;MsgBox(0,"","Weapon");
		Case $ari;
			;MsgBox(0,"","Armor");
		Case $r1i;
			;MsgBox(0,"","Ring 1");
		Case $r2i;
			;MsgBox(0,"","Ring 2");
		Case $ami;
			;MsgBox(0,"","Amulet");
		Case $si;
			;MsgBox(0,"","Shield");
EndSwitch;
WEnd;
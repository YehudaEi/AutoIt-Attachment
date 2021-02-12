#include-once
; #INDEX# =======================================================================================================================
; Title .........: MainDomain
; AutoIt Version : 3.0
; Language ......: English
; Description ...: Functions that assist with geting the main domain of a url domain.
; Author(s) .....: XTR
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Name...........: MainDomain
; Description ...: Returns a string containing the domain name that belongs to a given URL.
; Syntax.........: MainDomain( $strUrl )
; Parameters ....: $strUrl - The URL of domain to get
; Return values .: Success      - The name of the domain
;                  Failure      - Blank string
; Author ........: XTR
; Remarks .......: 2010-09-27
; Samples .......: Next lines
;                  MsgBox(0,"MainDomain",MainDomain("http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"))
;                  MsgBox(0,"MainDomain",MainDomain("http://www.w3.org"))
;                  MsgBox(0,"MainDomain",MainDomain("www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"))
;                  MsgBox(0,"MainDomain",MainDomain("www.w3.org"))
; ===============================================================================================================================
Func MainDomain($strUrl)
 If $strUrl = "" Then return ""
 If StringInStr($strUrl,"/") Then
  If StringInStr($strUrl, "://") Then $strUrl = StringMid($strUrl, StringInStr($strUrl, "://") + 3)
  If StringInStr($strUrl, "/") Then $strUrl = StringLeft($strUrl, StringInStr($strUrl, "/") - 1)
 EndIf
 ;# version 2006122601, last updated wed dec 27 09:07:02 2006 utc
 Local $strKnownNetTop = ".ac.ad.ae.aero.af.ag.ai.al.am.an.ao.aq.ar.arpa.as.asia.at.au.aw.ax.az.ba.bb.bd.be.bf.bg.bh"
 $strKnownNetTop &= ".bi.biz.bj.bl.bm.bn.bo.br.bs.bt.bv.bw.by.bz.ca.cat.cc.cd.cf.cg.ch.ci.ck"
 $strKnownNetTop &= ".cl.cm.cn.co.com.coop.cr.cs.cu.cv.cx.cy.cz.de.dj.dk.dm.do.dz.ec.edu.ee.eg"
 $strKnownNetTop &= ".eh.er.es.et.eu.fi.fj.fk.fm.fo.fr.fx.ga.gb.gd.ge.gf.gg.gh.gi.gl.gm.gn.gov"
 $strKnownNetTop &= ".gp.gq.gr.gs.gt.gu.gw.gy.hk.hm.hn.hr.ht.hu.id.ie.il.im.in.info.int.io.iq"
 $strKnownNetTop &= ".ir.is.it.je.jm.jo.jobs.jp.ke.kg.kh.ki.km.kn.kp.kr.kw.ky.kz.la.lb.lc.li.lk"
 $strKnownNetTop &= ".lr.ls.lt.lu.lv.ly.ma.mc.md.me.mf.mg.mh.mil.mk.ml.mm.mn.mo.mobi.mp.mq.mr.ms"
 $strKnownNetTop &= ".mt.mu.museum.mv.mw.mx.my.mz.na.name.nato.nc.ne.net.nf.ng.ni.nl.no.np.nr.nt"
 $strKnownNetTop &= ".nu.nz.om.org.pa.pe.pf.pg.ph.pk.pl.pm.pn.pr.pro.ps.pt.pw.py.qa.re.ro.rs.ru"
 $strKnownNetTop &= ".rw.s.sa.sb.sc.sd.se.sg.sh.si.sj.sk.sl.sm.sn.so.sr.st.su.sv.sy.sz.tc.td.tel"
 $strKnownNetTop &= ".tf.tg.th.tj.tk.tl.tm.tn.to.tp.tr.travel.tt.tv.tw.tz.ua.ug.uk.um.us.uy.uz.va"
 $strKnownNetTop &= ".vc.ve.vg.vi.vn.vu.wf.ws.ye.yt.yu.za.zm.zr.zw"
 $strUrl = StringLower($strUrl)
 If $strUrl = "www.al.com" Then $strUrl = "al"
 If $strUrl = "ftp.it.ru" Then $strUrl = "it"
 If StringRight($strUrl, 5) = "gu.ma" Then $strUrl = "gu"
 If StringInStr($strUrl, ".") <> StringInStr($strUrl, ".", 0, -1) Then
  If StringLeft(StringLeft($strUrl, StringInStr($strUrl, ".")), 1) = "w" Then
   If StringInStr("w.0123456789", StringMid($strUrl, 2, 1)) And StringInStr("w.0123456789", StringMid($strUrl, 3, 1)) Then $strUrl = StringMid($strUrl, StringInStr($strUrl, ".") + 1)
  EndIf
 EndIf
 While 1
  If StringInStr($strUrl, ".") Then
   If StringInStr($strKnownNetTop, StringMid($strUrl, StringInStr($strUrl, ".", 0, -1))) THEN
    $strUrl = StringLeft($strUrl, StringInStr($strUrl, ".", 0, -1) - 1)
   Else
    ExitLoop
   EndIf
  Else
   ExitLoop
  EndIf
 Wend
 Local $strOrgUrl = $strUrl
 If StringInStr($strUrl, ".") Then $strUrl = StringMid($strUrl, StringInStr($strUrl, ".", 0, 1) + 1)
 If $strUrl = "con" Then
  $strUrl = "con[0]"
  $strOrgUrl = StringReplace($strOrgUrl, "con", "\")
 EndIf
 If $strUrl = "aux" Then
  $strUrl = "aux[0]"
  $strOrgUrl = StringReplace($strOrgUrl, "aux", "\")
 EndIf
 If $strUrl = "com1" Then
  $strUrl = "com[1]"
  $strOrgUrl = StringReplace($strOrgUrl, "com1", "\")
 EndIf
 If $strUrl = "com2" Then
  $strUrl = "com[2]"
  $strOrgUrl = StringReplace($strOrgUrl, "com2", "\")
 EndIf
 If $strUrl = "com3" Then
  $strUrl = "com[3]"
  $strOrgUrl = StringReplace($strOrgUrl, "com3", "\")
 EndIf
 If $strUrl = "com4" Then
  $strUrl = "com[4]"
  $strOrgUrl = StringReplace($strOrgUrl, "com4", "\")
 EndIf
 If $strUrl = "lpt1" Then
  $strUrl = "lpt[1]"
  $strOrgUrl = StringReplace($strOrgUrl, "lpt1", "\")
 EndIf
 If $strUrl = "lpt2" Then
  $strUrl = "lpt[2]"
  $strOrgUrl = StringReplace($strOrgUrl, "lpt2", "\")
 EndIf
 If $strUrl = "lpt3" Then
  $strUrl = "lpt[3]"
  $strOrgUrl = StringReplace($strOrgUrl, "lpt3", "\")
 EndIf
 If $strUrl = "prn" Then
  $strUrl = "prn[0]"
  $strOrgUrl = StringReplace($strOrgUrl, "prn", "\")
 EndIf
 If $strUrl = "nul" Then
  $strUrl = "nul[1]"
  $strOrgUrl = StringReplace($strOrgUrl, "nul", "\")
 EndIf
 While StringInStr($strOrgUrl, ".") <> 0
  $strOrgUrl = StringReplace($strOrgUrl, ".", "\")
 Wend
 While StringInStr($strOrgUrl, $strUrl) <> 0
  $strOrgUrl = StringReplace($strOrgUrl, $strUrl, "\")
 Wend
 While StringInStr($strOrgUrl, "\\") <> 0
  $strOrgUrl = StringReplace($strOrgUrl, "\\", "\")
 Wend
 If $strOrgUrl <> "\" OR $strOrgUrl <> "\\" OR $strOrgUrl <> "" Then
  $strUrl = $strUrl & "\" & $strOrgUrl
 EndIf
 While StringInStr($strUrl, "\\") <> 0
  $strUrl = StringReplace($strUrl, "\\", "\")
 Wend
 While StringLeft($strUrl, 1) = "\"
  $strUrl = StringMid($strUrl, 2)
 Wend
 While StringRight($strUrl, 1) = "\"
  $strUrl = StringLeft($strUrl, StringLen($strUrl) - 1)
 Wend
 return $strUrl
EndFunc

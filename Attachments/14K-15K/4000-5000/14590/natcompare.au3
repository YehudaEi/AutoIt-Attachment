#region CopyRight Notice (Don't want to get sued, ya know?)
#cs
  natcompare.au3 -- Perform 'natural order' comparisons of strings in AutoIt 3.
  Copyright (C) 2007 by Ariel Poliak <apoliak[at]gmail[dot]com>
  
  Based on natcompare.js by Kristof Coomans. See below for further copyright information.
  
  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.
  
  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:
  
  1. The origin of this software must not be misrepresented; you must not
  claim that you wrote the original software. If you use this software
  in a product, an acknowledgment in the product documentation would be
  appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
  misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.
  
  natcompare.js copyright notice:
  ====ORIGINAL COPYRIGHT NOTICE====
  /*
  natcompare.js -- Perform 'natural order' comparisons of strings in JavaScript.
  Copyright (C) 2005 by SCK-CEN (Belgian Nucleair Research Centre)
  Written by Kristof Coomans <kristof[dot]coomans[at]sckcen[dot]be>
  
  Based on the Java version by Pierre-Luc Paour, of which this is more or less a straight conversion.
  Copyright (C) 2003 by Pierre-Luc Paour <natorder@paour.com>
  
  The Java version was based on the C version by Martin Pool.
  Copyright (C) 2000 by Martin Pool <mbp@humbug.org.au>
  
  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.
  
  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:
  
  1. The origin of this software must not be misrepresented; you must not
  claim that you wrote the original software. If you use this software
  in a product, an acknowledgment in the product documentation would be
  appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
  misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.
  */
  ==END ORIGINAL COPYRIGHT NOTICE==
#ce
#endregion CopyRight Notice (Don't want to get sued, ya know?)
Func _isWhitespaceChar($a)
  Local $charCode;
  $charCode = Asc(StringLeft($a, 1))
  If $charCode <= 32 Then
    Return True
  Else
    Return False
  EndIf
EndFunc   ;==>_isWhitespaceChar
Func _isDigitChar($a)
  Local $charCode;
  $charCode = Asc(StringLeft($a, 1))
  If $charCode >= 48 And $charCode <= 57 Then
    Return True
  Else
    Return False
  EndIf
EndFunc   ;==>_isDigitChar
Func _compareRight($a, $b)
  Local $bias = 0
  Local $ia = 0
  Local $ib = 0
  Local $ca
  Local $cb
  ;// The longest run of digits wins.  That aside, the greatest
  ;// value wins, but we can't know that it will until we've scanned
  ;// both numbers to know that they have the same magnitude, so we
  ;// remember it in BIAS.
  While True
    $ca = StringMid($a, $ia + 1, 1)
    $cb = StringMid($b, $ib + 1, 1)
    If Not _isDigitChar($ca) And Not _isDigitChar($cb) Then
      Return $bias
    ElseIf Not _isDigitChar($ca) Then
      Return -1
    ElseIf Not _isDigitChar($cb) Then
      Return 1
    ElseIf $ca < $cb Then
      If $bias = 0 Then
        $bias = -1
      EndIf
    ElseIf $ca > $cb Then
      If $bias = 0 Then
        $bias = 1
      EndIf
    ElseIf $ca = 0 And $cb = 0 Then
      Return $bias
    EndIf
    $ia += 1
    $ib += 1
  WEnd
EndFunc   ;==>_compareRight
Func _natcompare($a, $b)
  Local $ia = 0, $ib = 0
  Local $nza = 0, $nzb = 0
  Local $ca, $cb
  Local $result
  While True
    ;// only count the number of zeroes leading the last number compared
    $nza = 0
    $nzb = 0
    $ca = StringMid($a, $ia + 1, 1)
    $cb = StringMid($b, $ib + 1, 1)
    ;// skip over leading spaces or zeros
    While $ca <> "" And _isWhitespaceChar($ca) Or $ca == '0'
      If $ca == '0' Then
        $nza += 1
      Else
        ;// only count consecutive zeroes
        $nza = 0;
      EndIf
      $ia += 1
      $ca = StringMid($a, $ia + 1, 1)
    WEnd
    While $cb <> "" And _isWhitespaceChar($cb) Or $cb == '0'
      If $cb == '0' Then
        $nzb += 1
      Else
        ;// only count consecutive zeroes
        $nzb = 0;
      EndIf
      $ib += 1
      $cb = StringMid($b, $ib + 1, 1)
    WEnd
    ;// process run of digits
    If _isDigitChar($ca) And _isDigitChar($cb) Then
      $result = _compareRight(StringRight($a, StringLen($a) - $ia), StringRight($b, StringLen($b) - $ib))
      ;If ($result <> 0) Then
        Return $result;
      ;EndIf
    EndIf
    If ($ca == 0 And $cb == 0) Then
      ;// The strings compare the same.  Perhaps the caller
      ;// will want to call strcmp to break the tie.
      Return 0;$nza - $nzb
    EndIf
    If ($ca < $cb) Then
      Return -1;
    ElseIf ($ca > $cb) Then
      Return 1;
    EndIf
    $ia += 1
    $ib += 1
  WEnd
  Return 0
EndFunc   ;==>_natcompare
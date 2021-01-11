; Set the global variable so we don't have to declare it each time.
Global $stringStart   = '<span style="color: #999">';
Global $stringEnd     = '</span>';
Global $commentStart  = '<span style="color: #090; font-style: italic">';
Global $commentEnd    = '</span>';
Global $keywordStart  = '<span style="color: #00f; font-weight: bold">';
Global $keywordEnd    = '</span>';
Global $functionStart = '<span style="color: #009; font-weight: bold; font-style: italic">';
Global $functionEnd   = '</span>';
Global $numberStart   = '<span style="color: #909; font-weight: bold; font-style: italic">';
Global $numberEnd     = '</span>';
Global $macroStart    = '<span style="color: #f0f; font-weight: bold">';
Global $macroEnd      = '</span>';
Global $variableStart = '<span style="color: #900; font-weight: bold">';
Global $variableEnd   = '</span>';
Global $hashStart     = '<span style="color: #f0f; font-style: italic">';
Global $hashEnd       = '</span>';

; Escapes the HTML character
func returnEscapedChar($c)
	if ($c == '<') then
		return '&lt;';
	elseIf ($c == '>') then
		return '&gt;';
	elseIf ($c == '&') then
		return '&amp;';
	else
		return $c;
	endIf
endFunc

; Replaces the keywords
func replaceKeywords(byRef $p, $s)
	$p = stringRegExpReplace($p, '(?i)([^a-z0-9_])(' & $s & ')([^a-z0-9_])', '\1' & $keywordStart & '\2' & $keywordEnd & '\3');
endFunc

; Main function
func _SyntaxHighlight($d)
	; Windows line ending   --> Unix line ending.
	$d = stringReplace($d, @CrLf, @Lf);
	; Macintosh line ending --> Unix line ending.
	$d = stringReplace($d, @Cr, @Lf);

	; Split into lines...
	$l = stringSplit($d, @Lf, 1);
	$o = ''; The output.
	for $i = 1 to $l[0]
		$p = ''; Current parsed line.
		$t = ''; Text notation.
		; For each character...
		for $j = 1 to stringLen($l[$i])
			; Set the current char...
			$cchar = stringMid($l[$i], $j, 1);
			; If we found the double quote
			if ($cchar == '"') then
				; If no text opened then open the text.
				if ($t == '') then
					$t = '"';
					$p &= $stringStart & '"';
				; If the text is opened using the " then close the text.
				elseIf ($t == '"') then
					$t = '';
					$p &= '"' & $stringEnd;
				; Else (e.g. opened using the ', or comment mode), print as normal.
				else
					$p &= '"';
				endIf
			; But if we found the single quote
			elseIf ($cchar == "'") then
				; If no text is opened then open the text.
				if ($t == '') then
					$t = "'";
					$p &= $stringStart & "'";
				; If the text if opened using the ' then close the text.
				elseIf ($t == "'") then
					$t = '';
					$p &= "'" & $stringEnd;
				; Else, print as normal.
				else
					$p &= "'";
				endIf
			; If we found a ; and no text is opened, it is a comment.
			elseIf ($cchar == ';' And $t == '') then
				$t = ';';
				$p &= $commentStart & ';';
			; If we found a # and no text is opened, it is a hash statement.
			elseIf ($cchar == '#' And $t == '') then
				$t = '#';
				$p &= $hashStart & '#';
			; Other characters...
			else
				; If current text is normal text, print normally.
				; This way we can hilight keywords correctly.
				if ($t == '') then
					; We print as normal.
					$p &= returnEscapedChar($cchar);
				; In the comment or in a string? Print as entitied.
				else
					$p &= '&#' & asc($cchar) & ';';
				endIf
			endIf
		next
		; OKay, we finished the loop, we closed the unclosed string.
		if ($t == '"' Or $t == "'") then
			$p &= $stringEnd;
		; .. and we close the comment.
		elseIf ($t == ';') then
			$p &= $commentEnd;
		; .. and we close the hash.
		elseIf ($t == '#') then
			$p &= $hashEnd;
		endIf
		; We indent the text, so it's easier to parse.
		$p = ' ' & $p & ' ';
		; Highlight the keyword. $p is byref.
		replaceKeywords ($p, 'if');
		replaceKeywords ($p, 'then');
		replaceKeywords ($p, 'elseif');
		replaceKeywords ($p, 'else');
		replaceKeywords ($p, 'endif');
		replaceKeywords ($p, 'select');
		replaceKeywords ($p, 'switch');
		replaceKeywords ($p, 'case');
		replaceKeywords ($p, 'endswitch');
		replaceKeywords ($p, 'endselect');
		replaceKeywords ($p, 'for');
		replaceKeywords ($p, 'in');
		replaceKeywords ($p, 'next');
		replaceKeywords ($p, 'step');
		replaceKeywords ($p, 'with');
		replaceKeywords ($p, 'endwith');
		replaceKeywords ($p, 'while');
		replaceKeywords ($p, 'wend');
		replaceKeywords ($p, 'do');
		replaceKeywords ($p, 'until');
		replaceKeywords ($p, 'func');
		replaceKeywords ($p, 'endfunc');
		replaceKeywords ($p, 'const');
		replaceKeywords ($p, 'continuecase');
		replaceKeywords ($p, 'continueloop');
		replaceKeywords ($p, 'default');
		replaceKeywords ($p, 'dim');
		replaceKeywords ($p, 'enum');
		replaceKeywords ($p, 'exit');
		replaceKeywords ($p, 'exitloop');
		replaceKeywords ($p, 'false');
		replaceKeywords ($p, 'global');
		replaceKeywords ($p, 'local');
		replaceKeywords ($p, 'redim');
		replaceKeywords ($p, 'return');
		replaceKeywords ($p, 'true');
		; Highlight the number.
		$p = stringRegExpReplace($p, '([^A-Za-z0-9_#])([0-9]+)([^A-Za-z0-9_])', '\1' & $numberStart & '\2' & $numberEnd & '\3');
		; .. and the hexadecimal too.
		$p = stringRegExpReplace($p, '([^A-Za-z0-9_#])(0x)([0-9]+)([^A-Za-z0-9_])', '\1' & $numberStart & '\2\3' & $numberEnd & '\4');
		; Now, highlight the function.
		$p = stringRegExpReplace($p, '([A-Za-z0-9_]+)(\s*?)\(', $functionStart & '\1' & $functionEnd & '\2(');
		; Then, highlight the macro.
		$p = stringRegExpReplace($p, '@([A-Za-z0-9_]+)', $macroStart & '@\1' & $macroEnd);
		; And some variable.
		$p = stringRegExpReplace($p, '\$([A-Za-z0-9_]+)', $variableStart & '$\1' & $variableEnd);
		; Finally, outdent the text.
		$p = stringMid($p, 2);
		$o &= $p & @CrLf;
	next

	return $o;
endFunc

; Test script:
ConsoleWrite ('X-Powered-By: the DtTvB' & @CrLf);
ConsoleWrite ('Content-Type: text/html' & @CrLf);
ConsoleWrite (@CrLf);

$data = fileRead('compiler.txt');
ConsoleWrite ('<pre>' & _SyntaxHighlight($data) & '</pre>');

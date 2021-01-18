;===============================================================================
; Autoit version
; Paul Tero, July 2001
; http:; www.tero.co.uk/des/
;
; Optimised for performance with large blocks by Michael Hayworth, November 2001
; http:; www.netdealing.com
;
; Converted from JavaScript/PHP to AutoIt by Matthew Robinson, April 2007
;
; THIS SOFTWARE IS PROVIDED "AS IS" AND
; ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
; ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
; FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
; DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
; OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
; HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
; OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
; SUCH DAMAGE.
;================================================================================

Local $key = "8787878787878787"
Local $message = "Supercalifradialisticexpialidocious"
Local $ciphertext = des($key, $message, 1)
ConsoleWrite("DES Test Encrypted: " & stringToHex($ciphertext))
Local $recovered_message = des($key, $ciphertext, 0)
ConsoleWrite(@CRLF)
ConsoleWrite("DES Test Decrypted: " & $recovered_message)
ConsoleWrite(@CRLF)

;===================================================================
; des
; this takes the key, the message, and whether to encrypt or decrypt
; Error Codes Returned:
; 		-1 : Incorrect Key Length (must be 16 or 48)
;===================================================================
Func des($key, $message, $encrypt, $mode = 0, $iv = '')
	; declaring this locally speeds things up a bit
	Local $spfunction1[64] = [0x1010400, 0, 0x10000, 0x1010404, 0x1010004, 0x10404, 0x4, 0x10000, 0x400, 0x1010400, 0x1010404, 0x400, 0x1000404, 0x1010004, 0x1000000, 0x4, 0x404, 0x1000400, 0x1000400, 0x10400, 0x10400, 0x1010000, 0x1010000, 0x1000404, 0x10004, 0x1000004, 0x1000004, 0x10004, 0, 0x404, 0x10404, 0x1000000, 0x10000, 0x1010404, 0x4, 0x1010000, 0x1010400, 0x1000000, 0x1000000, 0x400, 0x1010004, 0x10000, 0x10400, 0x1000004, 0x400, 0x4, 0x1000404, 0x10404, 0x1010404, 0x10004, 0x1010000, 0x1000404, 0x1000004, 0x404, 0x10404, 0x1010400, 0x404, 0x1000400, 0x1000400, 0, 0x10004, 0x10400, 0, 0x1010004]
	Local $spfunction2[64] = [ -0x7fef7fe0, -0x7fff8000, 0x8000, 0x108020, 0x100000, 0x20, -0x7fefffe0, -0x7fff7fe0, -0x7fffffe0, -0x7fef7fe0, -0x7fef8000, -0x80000000, -0x7fff8000, 0x100000, 0x20, -0x7fefffe0, 0x108000, 0x100020, -0x7fff7fe0, 0, -0x80000000, 0x8000, 0x108020, -0x7ff00000, 0x100020, -0x7fffffe0, 0, 0x108000, 0x8020, -0x7fef8000, -0x7ff00000, 0x8020, 0, 0x108020, -0x7fefffe0, 0x100000, -0x7fff7fe0, -0x7ff00000, -0x7fef8000, 0x8000, -0x7ff00000, -0x7fff8000, 0x20, -0x7fef7fe0, 0x108020, 0x20, 0x8000, -0x80000000, 0x8020, -0x7fef8000, 0x100000, -0x7fffffe0, 0x100020, -0x7fff7fe0, -0x7fffffe0, 0x100020, 0x108000, 0, -0x7fff8000, 0x8020, -0x80000000, -0x7fefffe0, -0x7fef7fe0, 0x108000]
	Local $spfunction3[64] = [0x208, 0x8020200, 0, 0x8020008, 0x8000200, 0, 0x20208, 0x8000200, 0x20008, 0x8000008, 0x8000008, 0x20000, 0x8020208, 0x20008, 0x8020000, 0x208, 0x8000000, 0x8, 0x8020200, 0x200, 0x20200, 0x8020000, 0x8020008, 0x20208, 0x8000208, 0x20200, 0x20000, 0x8000208, 0x8, 0x8020208, 0x200, 0x8000000, 0x8020200, 0x8000000, 0x20008, 0x208, 0x20000, 0x8020200, 0x8000200, 0, 0x200, 0x20008, 0x8020208, 0x8000200, 0x8000008, 0x200, 0, 0x8020008, 0x8000208, 0x20000, 0x8000000, 0x8020208, 0x8, 0x20208, 0x20200, 0x8000008, 0x8020000, 0x8000208, 0x208, 0x8020000, 0x20208, 0x8, 0x8020008, 0x20200]
	Local $spfunction4[64] = [0x802001, 0x2081, 0x2081, 0x80, 0x802080, 0x800081, 0x800001, 0x2001, 0, 0x802000, 0x802000, 0x802081, 0x81, 0, 0x800080, 0x800001, 0x1, 0x2000, 0x800000, 0x802001, 0x80, 0x800000, 0x2001, 0x2080, 0x800081, 0x1, 0x2080, 0x800080, 0x2000, 0x802080, 0x802081, 0x81, 0x800080, 0x800001, 0x802000, 0x802081, 0x81, 0, 0, 0x802000, 0x2080, 0x800080, 0x800081, 0x1, 0x802001, 0x2081, 0x2081, 0x80, 0x802081, 0x81, 0x1, 0x2000, 0x800001, 0x2001, 0x802080, 0x800081, 0x2001, 0x2080, 0x800000, 0x802001, 0x80, 0x800000, 0x2000, 0x802080]
	Local $spfunction5[64] = [0x100, 0x2080100, 0x2080000, 0x42000100, 0x80000, 0x100, 0x40000000, 0x2080000, 0x40080100, 0x80000, 0x2000100, 0x40080100, 0x42000100, 0x42080000, 0x80100, 0x40000000, 0x2000000, 0x40080000, 0x40080000, 0, 0x40000100, 0x42080100, 0x42080100, 0x2000100, 0x42080000, 0x40000100, 0, 0x42000000, 0x2080100, 0x2000000, 0x42000000, 0x80100, 0x80000, 0x42000100, 0x100, 0x2000000, 0x40000000, 0x2080000, 0x42000100, 0x40080100, 0x2000100, 0x40000000, 0x42080000, 0x2080100, 0x40080100, 0x100, 0x2000000, 0x42080000, 0x42080100, 0x80100, 0x42000000, 0x42080100, 0x2080000, 0, 0x40080000, 0x42000000, 0x80100, 0x2000100, 0x40000100, 0x80000, 0, 0x40080000, 0x2080100, 0x40000100]
	Local $spfunction6[64] = [0x20000010, 0x20400000, 0x4000, 0x20404010, 0x20400000, 0x10, 0x20404010, 0x400000, 0x20004000, 0x404010, 0x400000, 0x20000010, 0x400010, 0x20004000, 0x20000000, 0x4010, 0, 0x400010, 0x20004010, 0x4000, 0x404000, 0x20004010, 0x10, 0x20400010, 0x20400010, 0, 0x404010, 0x20404000, 0x4010, 0x404000, 0x20404000, 0x20000000, 0x20004000, 0x10, 0x20400010, 0x404000, 0x20404010, 0x400000, 0x4010, 0x20000010, 0x400000, 0x20004000, 0x20000000, 0x4010, 0x20000010, 0x20404010, 0x404000, 0x20400000, 0x404010, 0x20404000, 0, 0x20400010, 0x10, 0x4000, 0x20400000, 0x404010, 0x4000, 0x400010, 0x20004010, 0, 0x20404000, 0x20000000, 0x400010, 0x20004010]
	Local $spfunction7[64] = [0x200000, 0x4200002, 0x4000802, 0, 0x800, 0x4000802, 0x200802, 0x4200800, 0x4200802, 0x200000, 0, 0x4000002, 0x2, 0x4000000, 0x4200002, 0x802, 0x4000800, 0x200802, 0x200002, 0x4000800, 0x4000002, 0x4200000, 0x4200800, 0x200002, 0x4200000, 0x800, 0x802, 0x4200802, 0x200800, 0x2, 0x4000000, 0x200800, 0x4000000, 0x200800, 0x200000, 0x4000802, 0x4000802, 0x4200002, 0x4200002, 0x2, 0x200002, 0x4000000, 0x4000800, 0x200000, 0x4200800, 0x802, 0x200802, 0x4200800, 0x802, 0x4000002, 0x4200802, 0x4200000, 0x200800, 0, 0x2, 0x4200802, 0, 0x200802, 0x4200000, 0x800, 0x4000002, 0x4000800, 0x800, 0x200002]
	Local $spfunction8[64] = [0x10001040, 0x1000, 0x40000, 0x10041040, 0x10000000, 0x10001040, 0x40, 0x10000000, 0x40040, 0x10040000, 0x10041040, 0x41000, 0x10041000, 0x41040, 0x1000, 0x40, 0x10040000, 0x10000040, 0x10001000, 0x1040, 0x41000, 0x40040, 0x10040040, 0x10041000, 0x1040, 0, 0, 0x10040040, 0x10000040, 0x10001000, 0x41040, 0x40000, 0x41040, 0x40000, 0x10041000, 0x1000, 0x40, 0x10040040, 0x1000, 0x41040, 0x10001000, 0x40, 0x10000040, 0x10040000, 0x10040040, 0x10000000, 0x40000, 0x10001040, 0, 0x10041040, 0x40040, 0x10000040, 0x10040000, 0x10001000, 0x10001040, 0, 0x10041040, 0x41000, 0x41000, 0x1040, 0x1040, 0x40040, 0x10000000, 0x10041000]
	Local $masks[33] = [4294967295, 2147483647, 1073741823, 536870911, 268435455, 134217727, 67108863, 33554431, 16777215, 8388607, 4194303, 2097151, 1048575, 524287, 262143, 131071, 65535, 32767, 16383, 8191, 4095, 2047, 1023, 511, 255, 127, 63, 31, 15, 7, 3, 1, 0]
	Local $fill
	; create the 16 or 48 subkeys we will need
	$keys = des_createKeys($key)
	If @error == 1 Then
		SetError(-1)
		Return 0
	EndIf
	$m = 0
	$chunk = 0
	; set up the loops for single and triple des
	If UBound($keys) == 32 Then
		Local $iterations = 3
	Else
		Local $iterations = 9
	EndIf

	If ($iterations == 3) Then
		If $encrypt == 1 Then
			Local $looping[3] = [0, 32, 2]
		Else
			Local $looping[3] = [30, -2, -2]
		EndIf
	Else
		If $encrypt == 1 Then
			Local $looping[9] = [0, 32, 2, 62, 30, -2, 64, 96, 2]
		Else
			Local $looping[9] = [94, 62, -2, 32, 64, 2, 30, -2, -2]
		EndIf
	EndIf

	If $encrypt == 1 Then
		$fill = 8
		If Mod(StringLen($message), 8) <> 0 Then
			$fill = 8 - Mod(StringLen($message), 8)
		EndIf
		For $i = 1 To $fill
			$message &= Chr($fill)
		Next
	EndIf
	$len = StringLen($message)
	; store the result here
	$result = ""
	$tempresult = ""

	If ($mode == 1) Then ; CBC mode
		$cbcleft = BitOR(BitShift(Asc(StringMid($iv, 1, 1)), -24), BitShift(Asc(StringMid($iv, 2, 1)), -16), BitShift(Asc(StringMid($iv, 3, 1)), -8), Asc(StringMid($iv, 4, 1)))
		$cbcright = BitOR(BitShift(Asc(StringMid($iv, 5, 1)), -24), BitShift(Asc(StringMid($iv, 6, 1)), -16), BitShift(Asc(StringMid($iv, 7, 1)), -8), Asc(StringMid($iv, 8, 1)))
	EndIf

	; loop through each 64 bit chunk of the message
	While $m < $len
		$left = BitOR(BitShift(Asc(StringMid($message, $m + 1, 1)), -24), BitShift(Asc(StringMid($message, $m + 2, 1)), -16), BitShift(Asc(StringMid($message, $m + 3, 1)), -8), Asc(StringMid($message, $m + 4, 1)))
		$right = BitOR(BitShift(Asc(StringMid($message, $m + 5, 1)), -24), BitShift(Asc(StringMid($message, $m + 6, 1)), -16), BitShift(Asc(StringMid($message, $m + 7, 1)), -8), Asc(StringMid($message, $m + 8, 1)))
		$m += 8
		
		; for Cipher Block Chaining mode, xor the message with the previous result
		If $mode == 1 Then
			If $encrypt Then
				$left = BitXOR($left, $cbcleft)
				$right = BitXOR($right, $cbcright)
			Else
				$cbcleft2 = $cbcleft
				$cbcright2 = $cbcright
				$cbcleft = $left
				$cbcright = $right
			EndIf
		EndIf

		; first each 64 but chunk of the message must be permuted according to IP
		$temp = BitAND(BitXOR(BitAND(BitShift($left, 4), $masks[4]), $right), 0x0f0f0f0f)
		$right = BitXOR($right, $temp)
		$left = BitXOR($left, BitShift($temp, -4))
		
		$temp = BitAND(BitXOR(BitAND(BitShift($left, 16), $masks[16]), $right), 0x0000ffff)
		$right = BitXOR($right, $temp)
		$left = BitXOR($left, BitShift($temp, -16))
		
		$temp = BitAND(BitXOR(BitAND(BitShift($right, 2), $masks[2]), $left), 0x33333333)
		$left = BitXOR($left, $temp)
		$right = BitXOR($right, BitShift($temp, -2))
		
		$temp = BitAND(BitXOR(BitAND(BitShift($right, 8), $masks[8]), $left), 0x00ff00ff)
		$left = BitXOR($left, $temp)
		$right = BitXOR($right, BitShift($temp, -8))
		
		$temp = BitAND(BitXOR(BitAND(BitShift($left, 1), $masks[1]), $right), 0x55555555)
		$right = BitXOR($right, $temp)
		$left = BitXOR($left, BitShift($temp, -1))
		
		$left = BitOR(BitShift($left, -1), BitAND(BitShift($left, 31), $masks[31]))
		$right = BitOR(BitShift($right, -1), BitAND(BitShift($right, 31), $masks[31]))

		; do this either 1 or 3 times for each chunk of the message
		For $j = 0 To $iterations - 1 Step 3
			$endloop = $looping[$j + 1]
			$loopinc = $looping[$j + 2]
			; now go through and perform the encryption or decryption
			$i = $looping[$j]
			While $i <> $endloop ; for efficiency
				$right1 = BitXOR($right, $keys[$i])
				$right2 = BitXOR(BitOR(BitAND(BitShift($right, 4), $masks[4]), BitShift($right, -28)), $keys[$i + 1])
				; the result is attained by passing these bytes through the S selection functions
				$temp = $left
				$left = $right
				$right = BitXOR($temp, BitOR($spfunction2[BitAND(BitAND(BitShift($right1, 24), $masks[24]), 0x3f) ], $spfunction4[BitAND(BitAND(BitShift($right1, 16), $masks[16]), 0x3f) ], $spfunction6[BitAND(BitAND(BitShift($right1, 8), $masks[8]), 0x3f) ], $spfunction8[BitAND($right1, 0x3f) ], $spfunction1[BitAND(BitAND(BitShift($right2, 24), $masks[24]), 0x3f) ], $spfunction3[BitAND(BitAND(BitShift($right2, 16), $masks[16]), 0x3f) ], $spfunction5[BitAND(BitAND(BitShift($right2, 8), $masks[8]), 0x3f) ], $spfunction7[BitAND($right2, 0x3f) ]))
				$i += $loopinc
			WEnd
			; unreverse left and right
			$temp = $left
			$left = $right
			$right = $temp
		Next ; for either 1 or 3 iterations

		; move then each one bit to the right
		$left = BitOR(BitAND(BitShift($left, 1), $masks[1]), BitShift($left, -31))
		$right = BitOR(BitAND(BitShift($right, 1), $masks[1]), BitShift($right, -31))

		; now perform IP-1, which is IP in the opposite direction
		$temp = BitAND(BitXOR(BitAND(BitShift($left, 1), $masks[1]), $right), 0x55555555)
		$right = BitXOR($right, $temp)
		$left = BitXOR($left, BitShift($temp, -1))
		
		$temp = BitAND(BitXOR(BitAND(BitShift($right, 8), $masks[8]), $left), 0x00ff00ff)
		$left = BitXOR($left, $temp)
		$right = BitXOR($right, BitShift($temp, -8))
		
		$temp = BitAND(BitXOR(BitAND(BitShift($right, 2), $masks[2]), $left), 0x33333333)
		$left = BitXOR($left, $temp)
		$right = BitXOR($right, BitShift($temp, -2))
		
		$temp = BitAND(BitXOR(BitAND(BitShift($left, 16), $masks[16]), $right), 0x0000ffff)
		$right = BitXOR($right, $temp)
		$left = BitXOR($left, BitShift($temp, -16))
		
		$temp = BitAND(BitXOR(BitAND(BitShift($left, 4), $masks[4]), $right), 0x0f0f0f0f)
		$right = BitXOR($right, $temp)
		$left = BitXOR($left, BitShift($temp, -4))

		; for Cipher Block Chaining mode, xor the message with the previous result
		If $mode == 1 Then
			If $encrypt == 1 Then
				$cbcleft = $left
				$cbcright = $right
			Else
				$left = BitXOR($left, $cbcleft2)
				$right = BitXOR($right, $cbcright2)
			EndIf
		EndIf
		$tempresult &= Chr(BitAND(BitShift($left, 24), $masks[24]))
		$tempresult &= Chr(BitAND(BitAND(BitShift($left, 16), $masks[16]), 0xff))
		$tempresult &= Chr(BitAND(BitAND(BitShift($left, 8), $masks[8]), 0xff))
		$tempresult &= Chr(BitAND($left, 0xff))
		$tempresult &= Chr(BitAND(BitShift($right, 24), $masks[24]))
		$tempresult &= Chr(BitAND(BitAND(BitShift($right, 16), $masks[16]), 0xff))
		$tempresult &= Chr(BitAND(BitAND(BitShift($right, 8), $masks[8]), 0xff))
		$tempresult &= Chr(BitAND($right, 0xff))

		$chunk += 8
		If $chunk == 512 Then
			$result &= $tempresult
			$tempresult = ""
			$chunk = 0
		EndIf
	WEnd ; for every 8 characters, or 64 bits in the message
	
	$result &= $tempresult
	If $encrypt == 0 Then
		$fill = Asc(StringRight($result, 1))
		$result = StringTrimRight($result, $fill)
	EndIf
	Return $result
EndFunc   ;==>des

; des_createKeys
; this takes as input a 64 bit key (even though only 56 bits are used)
; as an array of 2 integers, and returns 16 48 bit keys
Func des_createKeys($key)
	; declaring this locally speeds things up a bit
	Local $pc2bytes0[16] = [0, 0x4, 0x20000000, 0x20000004, 0x10000, 0x10004, 0x20010000, 0x20010004, 0x200, 0x204, 0x20000200, 0x20000204, 0x10200, 0x10204, 0x20010200, 0x20010204]
	Local $pc2bytes1[16] = [0, 0x1, 0x100000, 0x100001, 0x4000000, 0x4000001, 0x4100000, 0x4100001, 0x100, 0x101, 0x100100, 0x100101, 0x4000100, 0x4000101, 0x4100100, 0x4100101]
	Local $pc2bytes2[16] = [0, 0x8, 0x800, 0x808, 0x1000000, 0x1000008, 0x1000800, 0x1000808, 0, 0x8, 0x800, 0x808, 0x1000000, 0x1000008, 0x1000800, 0x1000808]
	Local $pc2bytes3[16] = [0, 0x200000, 0x8000000, 0x8200000, 0x2000, 0x202000, 0x8002000, 0x8202000, 0x20000, 0x220000, 0x8020000, 0x8220000, 0x22000, 0x222000, 0x8022000, 0x8222000]
	Local $pc2bytes4[16] = [0, 0x40000, 0x10, 0x40010, 0, 0x40000, 0x10, 0x40010, 0x1000, 0x41000, 0x1010, 0x41010, 0x1000, 0x41000, 0x1010, 0x41010]
	Local $pc2bytes5[16] = [0, 0x400, 0x20, 0x420, 0, 0x400, 0x20, 0x420, 0x2000000, 0x2000400, 0x2000020, 0x2000420, 0x2000000, 0x2000400, 0x2000020, 0x2000420]
	Local $pc2bytes6[16] = [0, 0x10000000, 0x80000, 0x10080000, 0x2, 0x10000002, 0x80002, 0x10080002, 0, 0x10000000, 0x80000, 0x10080000, 0x2, 0x10000002, 0x80002, 0x10080002]
	Local $pc2bytes7[16] = [0, 0x10000, 0x800, 0x10800, 0x20000000, 0x20010000, 0x20000800, 0x20010800, 0x20000, 0x30000, 0x20800, 0x30800, 0x20020000, 0x20030000, 0x20020800, 0x20030800]
	Local $pc2bytes8[16] = [0, 0x40000, 0, 0x40000, 0x2, 0x40002, 0x2, 0x40002, 0x2000000, 0x2040000, 0x2000000, 0x2040000, 0x2000002, 0x2040002, 0x2000002, 0x2040002]
	Local $pc2bytes9[16] = [0, 0x10000000, 0x8, 0x10000008, 0, 0x10000000, 0x8, 0x10000008, 0x400, 0x10000400, 0x408, 0x10000408, 0x400, 0x10000400, 0x408, 0x10000408]
	Local $pc2bytes10[16] = [0, 0x20, 0, 0x20, 0x100000, 0x100020, 0x100000, 0x100020, 0x2000, 0x2020, 0x2000, 0x2020, 0x102000, 0x102020, 0x102000, 0x102020]
	Local $pc2bytes11[16] = [0, 0x1000000, 0x200, 0x1000200, 0x200000, 0x1200000, 0x200200, 0x1200200, 0x4000000, 0x5000000, 0x4000200, 0x5000200, 0x4200000, 0x5200000, 0x4200200, 0x5200200]
	Local $pc2bytes12[16] = [0, 0x1000, 0x8000000, 0x8001000, 0x80000, 0x81000, 0x8080000, 0x8081000, 0x10, 0x1010, 0x8000010, 0x8001010, 0x80010, 0x81010, 0x8080010, 0x8081010]
	Local $pc2bytes13[16] = [0, 0x4, 0x100, 0x104, 0, 0x4, 0x100, 0x104, 0x1, 0x5, 0x101, 0x105, 0x1, 0x5, 0x101, 0x105]
	Local $masks[33] = [4294967295, 2147483647, 1073741823, 536870911, 268435455, 134217727, 67108863, 33554431, 16777215, 8388607, 4194303, 2097151, 1048575, 524287, 262143, 131071, 65535, 32767, 16383, 8191, 4095, 2047, 1023, 511, 255, 127, 63, 31, 15, 7, 3, 1, 0]

	; how many iterations (1 for des, 3 for triple des)
	If StringLen($key) == 48 Then
		Local $iterations = 3
	ElseIf StringLen($key) == 16 Then
		Local $iterations = 1
	Else
		SetError(1)
		Return 0
	EndIf

	; stores the return keys
	Local $keys[32 * $iterations]
	; now define the left shifts which need to be done
	Local $shifts[16] = [0, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0]
	; other variables
	Local $lefttemp, $righttemp, $m = 0, $n = 0, $temp

	For $j = 1 To $iterations ; either 1 or 3 iterations
		$left = BitOR(BitShift(Dec(StringMid($key, $m + 1, 2)), -24), BitShift(Dec(StringMid($key, $m + 3, 2)), -16), BitShift(Dec(StringMid($key, $m + 5, 2)), -8), Dec(StringMid($key, $m + 7, 2)))
		$right = BitOR(BitShift(Dec(StringMid($key, $m + 9, 2)), -24), BitShift(Dec(StringMid($key, $m + 11, 2)), -16), BitShift(Dec(StringMid($key, $m + 13, 2)), -8), Dec(StringMid($key, $m + 15, 2)))
		$m += 16

		$temp = BitAND(BitXOR(BitAND(BitShift($left, 4), $masks[4]), $right), 0x0f0f0f0f)
		$right = BitXOR($right, $temp)
		$left = BitXOR($left, BitShift($temp, -4))

		$temp = BitAND(BitXOR(BitAND(BitShift($right, 16), $masks[16]), $left), 0x0000ffff)
		$left = BitXOR($left, $temp)
		$right = BitXOR($right, BitShift($temp, -16))

		$temp = BitAND(BitXOR(BitAND(BitShift($left, 2), $masks[2]), $right), 0x33333333)
		$right = BitXOR($right, $temp)
		$left = BitXOR($left, BitShift($temp, -2))

		$temp = BitAND(BitXOR(BitAND(BitShift($right, 16), $masks[16]), $left), 0x0000ffff)
		$left = BitXOR($left, $temp)
		$right = BitXOR($right, BitShift($temp, -16))

		$temp = BitAND(BitXOR(BitAND(BitShift($left, 1), $masks[1]), $right), 0x55555555)
		$right = BitXOR($right, $temp)
		$left = BitXOR($left, BitShift($temp, -1))

		$temp = BitAND(BitXOR(BitAND(BitShift($right, 8), $masks[8]), $left), 0x00ff00ff)
		$left = BitXOR($left, $temp)
		$right = BitXOR($right, BitShift($temp, -8))

		$temp = BitAND(BitXOR(BitAND(BitShift($left, 1), $masks[1]), $right), 0x55555555)
		$right = BitXOR($right, $temp)
		$left = BitXOR($left, BitShift($temp, -1))

		; the right side needs to be shifted and to get the last four bits of the left side
		$temp = BitOR(BitShift($left, -8), BitAND(BitAND(BitShift($right, 20), $masks[20]), 0x000000f0))
		; left needs to be put upside down
		$left = BitOR(BitShift($right, -24), BitAND(BitShift($right, -8), 0xff0000), BitAND(BitAND(BitShift($right, 8), $masks[8]), 0xff00), BitAND(BitAND(BitShift($right, 24), $masks[24]), 0xf0))
		$right = $temp

		; now go through and perform these shifts on the left and right keys
		For $i = 0 To UBound($shifts) - 1
			; shift the keys either one or two bits to the left
			If $shifts[$i] == 1 Then
				$left = BitOR(BitShift($left, -2), BitAND(BitShift($left, 26), $masks[26]))
				$right = BitOR(BitShift($right, -2), BitAND(BitShift($right, 26), $masks[26]))
			Else
				$left = BitOR(BitShift($left, -1), BitAND(BitShift($left, 27), $masks[27]))
				$right = BitOR(BitShift($right, -1), BitAND(BitShift($right, 27), $masks[27]))
			EndIf
			$left = BitAND($left, -0xf)
			$right = BitAND($right, -0xf)

			; now apply PC-2, in such a way that E is easier when encrypting or decrypting
			; this conversion will look like PC-2 except only the last 6 bits of each byte are used
			; rather than 48 consecutive bits and the order of lines will be according to
			; how the S selection functions will be applied: S2, S4, S6, S8, S1, S3, S5, S7
			$lefttemp = BitOR($pc2bytes0[BitAND(BitShift($left, 28), $masks[28]) ], $pc2bytes1[BitAND(BitAND(BitShift($left, 24), $masks[24]), 0xf) ], $pc2bytes2[BitAND(BitAND(BitShift($left, 20), $masks[20]), 0xf) ], $pc2bytes3[BitAND(BitAND(BitShift($left, 16), $masks[16]), 0xf) ], $pc2bytes4[BitAND(BitAND(BitShift($left, 12), $masks[12]), 0xf) ], $pc2bytes5[BitAND(BitAND(BitShift($left, 8), $masks[8]), 0xf) ], $pc2bytes6[BitAND(BitAND(BitShift($left, 4), $masks[4]), 0xf) ])
			$righttemp = BitOR($pc2bytes7[BitAND(BitShift($right, 28), $masks[28]) ], $pc2bytes8[BitAND(BitAND(BitShift($right, 24), $masks[24]), 0xf) ], $pc2bytes9[BitAND(BitAND(BitShift($right, 20), $masks[20]), 0xf) ], $pc2bytes10[BitAND(BitAND(BitShift($right, 16), $masks[16]), 0xf) ], $pc2bytes11[BitAND(BitAND(BitShift($right, 12), $masks[12]), 0xf) ], $pc2bytes12[BitAND(BitAND(BitShift($right, 8), $masks[8]), 0xf) ], $pc2bytes13[BitAND(BitAND(BitShift($right, 4), $masks[4]), 0xf) ])
			$temp = BitAND(BitXOR(BitAND(BitShift($righttemp, 16), $masks[16]), $lefttemp), 0x0000ffff)
			$keys[$n] = BitXOR($lefttemp, $temp)
			$keys[$n + 1] = BitXOR($righttemp, BitShift($temp, -16))
			$n += 2
		Next
	Next ; for each iterations
	; return the keys we've created
	Return $keys
EndFunc   ;==>des_createKeys

Func stringToHex($s)
	Dim $result = "0x"
	Dim $temp = StringSplit($s, "")
	For $i = 1 To $temp[0]
		$result &= Hex(Asc($temp[$i]), 2)
	Next
	Return $result
EndFunc   ;==>stringToHex
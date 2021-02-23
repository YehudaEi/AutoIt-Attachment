$fileHandle=FileOpen("Image.bmp",16)
$imageHeader=imageHeader($fileHandle)
$imageData=imageData($fileHandle,$imageHeader)

$width=DllStructGetData($imageHeader,"width")
$height=DllStructGetData($imageHeader,"height")

FileClose($fileHandle)

$pid=Run("mspaint.exe")

WinActivate("untitled - Paint")
WinWaitActive("untitled - Paint")
WinGetHandle("untitled - Paint")
WinMove("untitled - Paint","",0,0,1024,768,1)

$_x=70
$_y=70

For $y=0 To $height-1
	For $x=0 To $width-1
		If $imageData[$y][$x] Then
			MouseClick("left",$_x+$x,$_y+$y,1,1)
		EndIf
	Next
Next


Func imageHeader(ByRef $handle)
	$magic=        FileRead($handle,2)
	$fileSize=     FileRead($handle,4)
	$reserved=     FileRead($handle,4)
	$dataOffset=   FileRead($handle,4)
	$headerSize=   FileRead($handle,4)
	$width=        FileRead($handle,4)
	$height=       FileRead($handle,4)
	$planes=       FileRead($handle,2)
	$bits=         FileRead($handle,2)
	$compression=  FileRead($handle,4)
	$dataSize=     FileRead($handle,4)
	$hRes=         FileRead($handle,4)
	$vRes=         FileRead($handle,4)
	$pallet=       FileRead($handle,1)
	
	$RowSize_pad=Int(((Int($bits)*Int($width))/Int(8)))
	$RowSize=$RowSize_pad
	While Mod($RowSize_pad,4) <> 0
		$RowSize_pad+=1
	WEnd
	
	$ArraySize=(Int($RowSize)*Int($height))
	
	$dimstruct="WORD magic;DWORD fileSize;DWORD reserved;" & _
	"DWORD dataOffset;DWORD headerSize;DWORD width;DWORD height;" & _
	"WORD planes;WORD bits;DWORD compression;DWORD dataSize;DWORD hRes;" & _
	"DWORD vRes;DWORD pallet;UINT rowSize;UINT rowSize_pad;UINT arraySize;"
	
	Local $Data=DllStructCreate($dimstruct)
	
	DllStructSetData($Data,"magic",$magic)
	DllStructSetData($Data,"fileSize",$fileSize)
	DllStructSetData($Data,"reserved",$reserved)
	DllStructSetData($Data,"dataOffset",$dataOffset)
	DllStructSetData($Data,"headerSize",$headerSize)
	DllStructSetData($Data,"width",$width)
	DllStructSetData($Data,"height",$height)
	DllStructSetData($Data,"planes",$planes)
	DllStructSetData($Data,"bits",$bits)
	DllStructSetData($Data,"compression",$compression)
	DllStructSetData($Data,"dataSize",$dataSize)
	DllStructSetData($Data,"hRes",$hRes)
	DllStructSetData($Data,"vRes",$vRes)
	DllStructSetData($Data,"pallet",$pallet)
	DllStructSetData($Data,"rowSize",$RowSize)
	DllStructSetData($Data,"arraySize",$ArraySize)
	DllStructSetData($Data,"rowSize_pad",$RowSize_pad)
	return $Data
EndFunc

Func imageData(ByRef $handle,ByRef $headerData)
	
	Local $8bit[8]
	$8bit[0]=1
	$8bit[1]=2
	$8bit[2]=4
	$8bit[3]=8
	$8bit[4]=16
	$8bit[5]=32
	$8bit[6]=64
	$8bit[7]=128
	$offSet     = DLLStructGetData($headerData,"dataOffset")
	$arraySize  = DllStructGetData($headerData,"arraySize")
	$rowSize    = DllStructGetData($headerData,"rowSize_pad")
	$row        = DLLStructGetData($headerData,"rowSize")
	$width      = DLLStructGetData($headerData,"width")
	$height     = DLLStructGetData($headerData,"height")
	
	ConsoleWrite($width)
	Local $pixelData[$height][$width+1]
	
	FileSetPos($handle,$offSet,0)
	$filePos=FileGetPos($handle)
	
	For $y=0 To $height-1
		$counter=0
		For $x=0 To $rowSize-1
			$byte=FileRead($handle,1)
			ConsoleWrite($x&Chr(0xA))
			For $i = 0 To 7
				If $x == 27 AND $i >= 3 Then
					ContinueLoop
				EndIf
				$val=BitAND($byte,$8bit[$i])
				$pixelData[$y][$counter]=($val<>$8bit[$i])
				$counter+=1
			Next
		Next
	Next
	
	return $pixelData
	
EndFunc
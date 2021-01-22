#include <array.au3>
#include "ExtProp.au3"
Const $ICMF_CHOOSE_KEYFRAME = 1
Const $ICMF_CHOOSE_DATARATE = 2
Const $ICMF_CHOOSE_PREVIEW = 4
Const $AVIIF_KEYFRAME = 10


$AVI_COMPRESS_OPTIONS=DllStructCreate("dword fccType;dword fccHandler;dword dwKeyFrameEvery;dword dwQuality;dword dwBytesPerSecond;dword dwFlags;dword lpFormat;dword cbFormat;dword lpParms;dword cbParms;dword dwInterleaveEvery")
$AVI_STREAM_INFO = DllStructCreate("dword fccType;dword fccHandler;dword dwFlags;dword dwCaps;ushort wPriority;ushort vLanguage;dword dwScale;dword dwRate;dword dwStart;dword dwLength;dword dwInitialFrames;dword dwSuggestedBufferSize;dword dwQuality;dword dwSampleSize;int rcFrame[4];dword dwEditCount;dword dwFormatChangeCount;char szName[64]")
$BITMAPINFOHEADER = DllStructCreate("dword biSize;dword biWidth;dword biHeight;ushort biPlanes;ushort biBitCount;dword biCompression;dword biSizeImage;dword biXPelsPerMeter;dword biYPelsPerMeter;dword biClrUsed;dword biClrImportant")
$BITMAPFILEHEADER = DllStructCreate("ushort bfType;int bfSize;ushort bfReserved1;ushort bfReserved2;int bfOffBits")
$BITMAPINFO=DllStructCreate($tagBITMAPINFO)


If @error Then 
	MsgBox(16,"Error!","Error creating struct: "&@error)
	Exit
EndIf
Dim $pics[3]=[@ScriptDir&"\1.bmp",@ScriptDir&"\2.bmp",@ScriptDir&"\3.bmp"]
CreateAVI(@ScriptDir&"\hej.avi",$pics,10)

Func CreateAVI($FileName, $IList, $FramesPerSec)
	$dll=DllOpen("avifil32.dll")
	Local $pFile,$ps,$pOpts,$psCompressed
	Local $Opts=$AVI_COMPRESS_OPTIONS
	Local $strhdr=$AVI_STREAM_INFO
	Local $i=0
	Local $BFile,$m_Bih=$BITMAPINFOHEADER,$m_Bfh=$BITMAPFILEHEADER,$m_MemBits,$m_MemBitMapInfo
	FileDelete($FileName)
	DllStructSetData($Opts,"fccHandler",541215044)
	DllCall($dll,"none","AVIFileInit")
	$pOpts=DllStructGetPtr($Opts)
	$array=DllCall($dll,"int","AVIFileOpen","ptr*",$pFile,"str",$FileName,"dword",BitOR(1,4096),"dword",0)
	$pFile=$array[1]
;~ 	MsgBox(0,"",$pFile)
	$binfo=_GetExtProperty($IList[0],31)
	$temp=StringSplit($binfo," x ")
	$width=$temp[1]
	$height=$temp[4]
	DllStructSetData($strhdr,"fccType",1935960438)
	DllStructSetData($strhdr,"fccHandler",0)
	DllStructSetData($strhdr,"dwScale",1)
	DllStructSetData($strhdr,"dwRate",$FramesPerSec)
	DllStructSetData($strhdr,"dwSuggestedBufferSize",FileGetSize($IList[0]))
	DllStructSetData($strhdr,"rcFrame",0,1)
	DllStructSetData($strhdr,"rcFrame",0,2)
	DllStructSetData($strhdr,"rcFrame",$width,3)
	DllStructSetData($strhdr,"rcFrame",$height,4)
	$dllreturn=DllCall($dll,"int","AVIFileCreateStream","ptr",$pFile,"ptr*",$ps,"ptr",DllStructGetPtr($strhdr))
	$ps=$dllreturn[2]
	$dllreturn=DllCall($dll,"int","AVIMakeCompressedStream","ptr*",$psCompressed,"ptr",$ps,"ptr",$pOpts,"ptr",0)
	$psCompressed=$dllreturn[1]
;~ 	$dllreturn=DllCall($dll,"int","AVIStreamSetFormat","ptr",$psCompressed,"long",0,
	
	Local $firststruct=$m_Bfh
	Local $secondstruct=$m_Bih
	_GetBITMAPINFO($IList[0],$firststruct,$secondstruct)
	DllStructSetData($BITMAPINFO,"Width",DllStructGetData($secondstruct,"biWidth"))
	DllStructSetData($BITMAPINFO,"Height",DllStructGetData($secondstruct,"biHeight"))
	DllStructSetData($BITMAPINFO,"Planes",1)
	DllStructSetData($BITMAPINFO,"BitCount",24)
	DllStructSetData($BITMAPINFO,"Compression",0)
	$dllreturn=DllCall($dll,"int","AVIStreamSetFormat","ptr",$psCompressed,"int",0,"ptr",DllStructGetPtr($BITMAPINFO),"long",DllStructGetSize($BITMAPINFO))
	_ArrayDisplay($dllreturn)
	For $i=0 To UBound($IList)-1
		$t=DllStructCreate("str buffer;")
		$handle=FileOpen($IList[$i],16)
		DllStructSetData($t,"buffer",FileRead($handle))
		FileClose($handle)
		$dllreturn=DllCall($dll,"int","AVIStreamWrite","ptr",$psCompressed,"int",$i,"int",1,"ptr",DllStructGetPtr($t),"long",DllStructGetSize($t),"dword",10,"none",0,"none",0)
		_ArrayDisplay($dllreturn)
		Next

	


If @error Then MsgBox(0,"","")
	EndFunc
	
	
Func _GetBITMAPINFO ($bitmap, ByRef $struct1, ByRef $struct2)
$hFile = _WinAPI_CreateFile($bitmap,2,2,2)
Local $readbytes
 _WinAPI_ReadFile($hFile,DllStructGetPtr($struct1),DllStructGetSize($struct1),$readbytes)
$aResult = DllCall("kernel32.dll", "int", "SetFilePointerEx", "hwnd", $hFile, "uint64", -4, "long*", 0, "int", 1)
$aResult[0] = 0 
_WinAPI_ReadFile($hFile,DllstructGetPtr($struct2),DllStructGetSize($struct2),$readbytes)
EndFunc









#CS

// DLL External declarations

function AVISaveOptions(Hwnd : DWORD; uiFlags : DWORD; nStreams : DWORD;
                        pPavi : Pointer; plpOptions : Pointer) : boolean;
                        stdcall; external 'avifil32.dll';

function AVIFileCreateStream(pFile : DWORD; pPavi : Pointer; pSi : Pointer) : integer;
                             stdcall; external 'avifil32.dll';

function AVIFileOpen(pPfile : Pointer; szFile : PChar; uMode : DWORD;
                     clSid : DWORD) : integer;
                     stdCall; external 'avifil32.dll';

function AVIMakeCompressedStream(psCompressed : Pointer; psSource : DWORD;
                                 lpOptions : Pointer; pclsidHandler : DWORD) : integer;
                                 stdcall; external 'avifil32.dll';

function AVIStreamSetFormat(pAvi : DWORD; lPos : DWORD; lpGormat : Pointer;
                            cbFormat : DWORD) : integer;
                            stdcall; external 'avifil32.dll';

function AVIStreamWrite(pAvi : DWORD; lStart : DWORD; lSamples : DWORD;
                        lBuffer : Pointer; cBuffer : DWORD; dwFlags : DWORD;
                        plSampWritten : DWORD; plBytesWritten : DWORD) : integer;
                        stdcall; external 'avifil32.dll';

function AVISaveOptionsFree(nStreams : DWORD; ppOptions : Pointer) : integer;
                            stdcall; external 'avifil32.dll';

function AVIFileRelease(pFile : DWORD) : integer; stdcall; external 'avifil32.dll';

procedure AVIFileInit; stdcall; external 'avifil32.dll';

procedure AVIFileExit; stdcall; external 'avifil32.dll';

function AVIStreamRelease(pAvi : DWORD) : integer; stdcall; external 'avifil32.dll';

function mmioStringToFOURCCA(sz : PChar; uFlags : DWORD) : integer;
                             stdcall; external 'winmm.dll';

// ============================================================================
// Main Function to Create AVI file from BMP file listing
// ============================================================================

procedure CreateAVI(const FileName : string; IList : TStrings;
                    FramesPerSec : integer = 10);
var Opts : AVI_COMPRESS_OPTIONS;
    pOpts : Pointer;
    pFile,ps,psCompressed : DWORD;
    strhdr : AVI_STREAM_INFO;
    i : integer;
    BFile : file;
    m_Bih : BITMAPINFOHEADER;
    m_Bfh : BITMAPFILEHEADER;
    m_MemBits : packed array of byte;
    m_MemBitMapInfo : packed array of byte;
begin
  DeleteFile(FileName);
  Fillchar(Opts,SizeOf(Opts),0);
  FillChar(strhdr,SizeOf(strhdr),0);
  Opts.fccHandler := 541215044;    // Full frames Uncompressed
  AVIFileInit;
  pfile := 0;
  pOpts := @Opts;

  if AVIFileOpen(@pFile,PChar(FileName),OF_WRITE or OF_CREATE,0) = 0 then begin
     // Determine Bitmap Properties from file item[0] in list
     AssignFile(BFile,IList[0]);
     Reset(BFile,1);
     BlockRead(BFile,m_Bfh,SizeOf(m_Bfh));
     BlockRead(BFile,m_Bih,SizeOf(m_Bih));
     SetLength(m_MemBitMapInfo,m_bfh.bfOffBits - 14);
     SetLength(m_MemBits,m_Bih.biSizeImage);
     Seek(BFile,SizeOf(m_Bfh));
     BlockRead(BFile,m_MemBitMapInfo[0],length(m_MemBitMapInfo));
     CloseFile(BFile);

     strhdr.fccType := mmioStringToFOURCCA('vids', 0);      // stream type video
     strhdr.fccHandler := 0;                                // def AVI handler
     strhdr.dwScale := 1;
     strhdr.dwRate := FramesPerSec;                         // fps 1 to 30
     strhdr.dwSuggestedBufferSize := m_Bih.biSizeImage;     // size of 1 frame
     SetRect(strhdr.rcFrame,0,0,m_Bih.biWidth,m_Bih.biHeight);

     if AVIFileCreateStream(pFile,@ps,@strhdr) = 0 then begin
        // if you want user selection options then call following line
        // (but seems to only like "Full frames Uncompressed option)

        // AVISaveOptions(Application.Handle,
        //                ICMF_CHOOSE_KEYFRAME or ICMF_CHOOSE_DATARATE,
        //                1,@ps,@pOpts);
        // AVISaveOptionsFree(1,@pOpts);

        if AVIMakeCompressedStream(@psCompressed,ps,@opts,0) = 0 then begin
            if AVIStreamSetFormat(psCompressed,0,@m_memBitmapInfo[0],
                                  length(m_MemBitMapInfo)) = 0 then begin

               for i := 0 to IList.Count - 1 do begin
                 AssignFile(BFile,IList[i]);
                 Reset(BFile,1);
                 Seek(BFile,m_bfh.bfOffBits);
                 BlockRead(BFile,m_MemBits[0],m_Bih.biSizeImage);
                 Seek(BFile,SizeOf(m_Bfh));
                 BlockRead(BFile,m_MemBitMapInfo[0],length(m_MemBitMapInfo));
                 CloseFile(BFile);
                 if AVIStreamWrite(psCompressed,i,1,@m_MemBits[0],
                                   m_Bih.biSizeImage,AVIIF_KEYFRAME,0,0) <> 0 then begin
                    ShowMessage('Error during Write AVI File');
                    break;
                 end;
               end;
            end;
        end;
     end;

     AVIStreamRelease(ps);
     AVIStreamRelease(psCompressed);
     AVIFileRelease(pFile);
  end;

  AVIFileExit;
  m_MemBitMapInfo := nil;
  m_memBits := nil;
end;


#CE
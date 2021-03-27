#include-once
#include <CVConstants.au3>
#include <CVTag.au3>
#include <CVcore_c.au3>
#include <CVimgproc_c.au3>

; #INDEX# =======================================================================================================================
; Title .........: OpenCVFcns
; AutoIt Version : 3.3.10.2
; Language ......: English
; Description ...: functions of OpenCV
; Author(s) .....: Mylise
; ===============================================================================================================================

; #Functions# ======================================================================================================================

Global $_opencv_core, $_opencv_highgui, $_opencv_imgproc, $_opencv_calib3d, $_opencv_features2d

Dim $CV_CAP[39] = ['CV_CAP_PROP_POS_MSEC','CV_CAP_PROP_POS_FRAMES','CV_CAP_PROP_POS_AVI_RATIO', _
				   'CV_CAP_PROP_FRAME_WIDTH','CV_CAP_PROP_FRAME_HEIGHT','CV_CAP_PROP_FPS', _
				   'CV_CAP_PROP_FOURCC','CV_CAP_PROP_FRAME_COUNT','CV_CAP_PROP_FORMAT', _
				   'CV_CAP_PROP_MODE','CV_CAP_PROP_BRIGHTNESS','CV_CAP_PROP_CONTRAST', _
				   'CV_CAP_PROP_SATURATION','CV_CAP_PROP_HUE','CV_CAP_PROP_GAIN', _
				   'CV_CAP_PROP_EXPOSURE','CV_CAP_PROP_CONVERT_RGB','CV_CAP_PROP_WHITE_BALANCE_BLUE_U', _
				   'CV_CAP_PROP_RECTIFICATION','CV_CAP_PROP_MONOCROME','CV_CAP_PROP_SHARPNESS', _
				   'CV_CAP_PROP_AUTO_EXPOSURE','CV_CAP_PROP_GAMMA','CV_CAP_PROP_TEMPERATURE', _
				   'CV_CAP_PROP_TRIGGER','CV_CAP_PROP_TRIGGER_DELAY','CV_CAP_PROP_WHITE_BALANCE_RED_V', _
				   'CV_CAP_PROP_ZOOM','CV_CAP_PROP_FOCUS','CV_CAP_PROP_GUID','CV_CAP_PROP_ISO_SPEED', _
				   'CV_CAP_PROP_MAX_DC1394','CV_CAP_PROP_BACKLIGHT','CV_CAP_PROP_PAN','CV_CAP_PROP_TILT', _
				   'CV_CAP_PROP_ROLL','CV_CAP_PROP_IRIS','CV_CAP_PROP_SETTINGS']

;----
; myfcns
;------------------------------------------------
; _Opencv_cvSqr($pIplImage, $xt, $yt)
;
; $pIplImage is a pointer to IplImage of type 8UC3 (24bits) created by opencv
; $xt and yt are size of image
;
; Returns a pointer to the squared frame image
;
Func _Opencv_cvSqr(ByRef $pIplImage, $xt = 640 , $yt = 480)

    $_aResult = DllCall($_opencv_core, "int:cdecl", "cvCreateImage", "int", $yt, "int", $yt, "int", 8, "int", 3 )
	If @error Then ConsoleWrite("error5")
	Local $pIplImagedst = $_aResult[0]

	Local $x = int(($xt-$yt)/2)
	Local $y = 0
    Local $width = $yt
	Local $height = $yt

	DllCall($_opencv_core, "none:cdecl", "cvSetImageROI", "ptr", $pIplImage, "int", $x, "int", $y, "int", $width, "int", $height)
	If @error Then ConsoleWrite("error1" & @error & @CRLF)

	DllCall($_opencv_core, "none:cdecl", "cvCopy", "ptr", $pIplImage, "ptr", $pIplImagedst, "ptr", 0)
	If @error Then ConsoleWrite("error4" & @error & @CRLF)

    DllCall($_opencv_core, "none:cdecl", "cvResetImageROI", "ptr", $pIplImage)
	If @error Then ConsoleWrite("error3" & @error & @CRLF)

    Return $pIplImagedst

EndFunc	;==>_Opencv_cvSqr

;------------------------------------------------
; _OpenCV_SaveImage($filename,$pIplImage)
;
; $filename is a string identifying the location of image file if $filename = "" then autoi file open dialog box will appear
;
; Returns a pointer of loaded image in an IplImage format
;
Func _OpenCV_SaveImage(ByRef $filename ,$pIplImage)

   If $filename = "" Then $filename = "test.jpg"
   ;ConsoleWrite("error2" & $filename )
   DllCall($_opencv_highgui, "int:cdecl", "cvSaveImage", "str", $filename, "ptr", $pIplImage )
   If @error Then ConsoleWrite("error fileimage")


EndFunc ;==>_Opencv_SaveImage

;------------------------------------------------
; _Opencv_BMP2IPL($pBmpImage)
;
; $pBmpImage is a a pointer to GDI bitmap object of type 8UC4 (32bits)
;
; Returns a pointer to IPLimage type 8UC3 (24bits)
; Author: Mylise
;
Func _Opencv_BMP2IPL($pBmpImage)

Local $iW = _GDIPlus_ImageGetWidth($pBmpImage), $iH = _GDIPlus_ImageGetHeight($pBmpImage)

Local $tBitmapData = _GDIPlus_BitmapLockBits($pBmpImage, 0, 0, $iW, $iH, $GDIP_ILMREAD, $GDIP_PXF32ARGB)

Local $pIPL = _cvCreateImageHeader( _cvSize($iW, $iH) , 8 , 4 )

_cvSetData($pIPL, DllStructGetData($tBitmapData,"scan0"), DllStructGetData($tBitmapData,"stride"))

Local $pIplDst = _cvCloneImage($pIPL)

_cvReleaseImageHeader($pIPL)

_GDIPlus_BitmapUnlockBits($pBmpImage, $tBitmapData)

$pIplDst2 = _cvCreateImage(_cvSize($iW, $iH) , 8 , 3)
_cvCvtColor($pIplDst,$pIplDst2,$CV_BGRA2BGR)
_cvReleaseImageHeader($pIplDst)

Return $pIplDst2

EndFunc

;------------------------------------------------
; _Opencv_IPL2BMP($pIplImage)
;
; $pIplImage is a a pointer to IplImage of type 8UC3 (24bits) created by opencv
;
; Returns a pointer to GDI compatible bitmap image
; Author: Mylise
;
Func _Opencv_IPL2BMP($pIplImage)

	Local $tIplImage = DllStructCreate($tagIplImage, $pIplImage)

;Un-comment these lines of code if you want to see IplImage header information
;for $i = 1 to 22
;	ConsoleWrite( $nIplImage[$i-1] & DllStructGetData($tIplImage,$i) & @CRLF)
;Next

	$_aResult = DllCall($_opencv_core, "int:cdecl", "cvCreateImage", "int", DllStructGetData($tIplImage,'width'), "int", DllStructGetData($tIplImage,'height'), "int", 8, "int", 4 )
	If @error Then ConsoleWrite("error5")

	Local $pIplImagedst = $_aResult[0]
	Local $tIplImagedst = DllStructCreate($tagIplImage, $pIplImagedst)


	DllCall($_opencv_imgproc, "none:cdecl", "cvCvtColor", "ptr", $pIplImage, "ptr", $pIplImagedst, "int", $CV_BGR2BGRA)
	If @error Then ConsoleWrite("error6" & @error & @CRLF)

	Local $dataptr= DllStructGetData($tIplImagedst,'imageData')

	Local $hBMP = _WinAPI_CreateBitmap(DllStructGetData($tIplImagedst,'width'), DllStructGetData($tIplImagedst,'height'), 1, 32 , $dataptr)

;memory cleanup
	$tIplImage = 0
	$tIplImagedst = 0
	$dataptr = 0
	DllCall($_opencv_core, "none:cdecl", "cvReleaseImage", "ptr*", $pIplImagedst)
	If @error Then ConsoleWrite("error7")

	Return $hBMP

EndFunc	;==>_Opencv_GetWebCamFrame



;------------------------------------------------
; _OpenCV_WebCam($index = 0)
;
; $index is a value indicating the type of webcam and which webcam to select
; Returns a pointer to CVCapture
;
Func _OpenCV_WebCam($index = 0)

	Local $_aResult = DllCall($_opencv_highgui, "int:cdecl", "cvCreateCameraCapture", "int", $index)
	If @error Then MsgBox(0,"","Can not find webcam")
	Return $_aResult[0]

EndFunc	;==>_OpenCV_WebCam

;------------------------------------------------
; _Opencv_SetWebCam($pCvCapture, $x=640, $y=480 )
;
; $pCvCapture is a a pointer to CVCapture linked to the webcam and obtained from _OpenCV_WebCam() function
; $x,$y are used to set the width and height of the webcam. If resolutionis not supported, it will select the next lowest one!
;
Func _Opencv_SetWebCam($pCvCapture, ByRef $x, ByRef $y )

If $x = -1 and $y = -1 Then

   dim $xt[20] = [320 , 640 , 800 , 1024 , 1024 , 1152, 1280 , 1280, 1280 , 1280, 1280 , 1360, 1366, 1400, 1440, 1600, 1600, 1680, 1920]
   dim $yt[20] = [240 , 480 , 600 , 600 ,  768 ,  864,  720,   768,   800 ,  960, 1024,  768,  768,  1050, 900,  900,  1200, 1050, 1080]


	Local $_aResult = DllCall($_opencv_highgui, "int:cdecl", "cvSetCaptureProperty", "ptr", $pCvCapture, "int", $CV_CAP_PROP_FRAME_HEIGHT, "double", $yt[0])
	If @error Then ConsoleWrite("error3")
    Local $_aResult = DllCall($_opencv_highgui, "double:cdecl", "cvGetCaptureProperty", "ptr", $pCvCapture, "int", $CV_CAP_PROP_FRAME_HEIGHT)
	If @error Then ConsoleWrite("error3")

;ConsoleWrite("yret = " & $yt[$itt] & ", " & $_aResult[0] & @crlf)

for $itt = 0 to 18

    Local $_aResult = DllCall($_opencv_highgui, "int:cdecl", "cvSetCaptureProperty", "ptr", $pCvCapture, "int", $CV_CAP_PROP_FRAME_WIDTH, "double", $xt[$itt])
	If @error Then ConsoleWrite("error2")
	Local $_aResult = DllCall($_opencv_highgui, "double:cdecl", "cvGetCaptureProperty", "ptr", $pCvCapture, "int", $CV_CAP_PROP_FRAME_WIDTH)
	If @error Then ConsoleWrite("error2")

$x = $_aResult[0]
;ConsoleWrite("xret = " & $xt[$itt] & ", " & $_aResult[0] & @crlf)

    Local $_aResult = DllCall($_opencv_highgui, "int:cdecl", "cvSetCaptureProperty", "ptr", $pCvCapture, "int", $CV_CAP_PROP_FRAME_HEIGHT, "double", $yt[$itt])
	If @error Then ConsoleWrite("error3")
    Local $_aResult = DllCall($_opencv_highgui, "double:cdecl", "cvGetCaptureProperty", "ptr", $pCvCapture, "int", $CV_CAP_PROP_FRAME_HEIGHT)
	If @error Then ConsoleWrite("error3")
$y = $_aResult[0]
;ConsoleWrite("yret = " & $yt[$itt] & ", " & $_aResult[0] & @crlf)

Next


Else

	Local $_aResult = DllCall($_opencv_highgui, "int:cdecl", "cvSetCaptureProperty", "ptr", $pCvCapture, "int", $CV_CAP_PROP_FRAME_WIDTH, "double", $x)
	If @error Then ConsoleWrite("error2")

	Local $_aResult = DllCall($_opencv_highgui, "int:cdecl", "cvSetCaptureProperty", "ptr", $pCvCapture, "int", $CV_CAP_PROP_FRAME_HEIGHT, "double", $y)
	If @error Then ConsoleWrite("error3")

EndIf

;Un-comment these lines of code if you want to see available setting for webcam
;For $i = 0 to 37
;   	Local $_aResult = DllCall($_opencv_highgui, "double:cdecl", "cvGetCaptureProperty", "ptr", $pCvCapture, "int", $i)
;	If @error Then ConsoleWrite("error setwebcam")
;	ConsoleWrite($CV_CAP[$i] & "=" & $_aResult[0] & @CRLF)
 ;Next

EndFunc	;==>_Opencv_SetWebCam


;------------------------------------------------
; _Opencv_GetWebCamFrame($pCvCapture)
;
; $pCvCapture is a a pointer to CVCapture linked to the webcam and obtained from _OpenCV_WebCam() function
;
; Returns a pointer to the captured frame in an IplImage format
;
Func _Opencv_GetWebCamFrame($pCvCapture)

	$_aResult = DllCall($_opencv_highgui, "int:cdecl", "cvQueryFrame", "ptr", $pCvCapture)
	If @error Then ConsoleWrite("error4")

	Return $_aResult[0]

EndFunc	;==>_Opencv_GetWebCamFrame

;------------------------------------------------
; _Opencv_CloseWebCam($pCvCapture)
;
; $pCvCapture is a a pointer to CVCapture linked to the webcam and obtained from _OpenCV_WebCam() function
;
Func _Opencv_CloseWebCam($pCvCapture)

    DllCall($_opencv_highgui, "none:cdecl", "cvReleaseCapture", "ptr*", $pCvCapture)
	If @error Then ConsoleWrite("error8")
;    _Opencv_CloseDLL()


EndFunc	;==>_Opencv_CloseWebCam

;------------------------------------------------
; _Opencv_cvZoom($pIplImage, $factor = 1, $type = 1)
;
; $pIplImage is a pointer to IplImage of type 8UC3 (24bits) created by opencv
; $factor is zoom factor from center of image
; $type = CV_INTER_NN=0, CV_INTER_LINEAR=1, CV_INTER_CUBIC=2, CV_INTER_AREA=3, CV_INTER_LANCZOS4 =4
;
;
Func _Opencv_cvZoom(ByRef $pIplImage, $factor = 1 , $type = 1)

	$_aResult = DllCall($_opencv_core, "int:cdecl", "cvCloneImage", "ptr", $pIplImage )
	Local $pIplImagedst = $_aResult[0]

	Local $tIplImage = DllStructCreate($tagIplImage, $pIplImage)

	Local $Kzoom = ($factor-1)/(2*$factor)
	Local $x = int(DllStructGetData($tIplImage,'width') * $Kzoom)
	Local $y = int(DllStructGetData($tIplImage,'height') * $Kzoom)
    Local $width = int(DllStructGetData($tIplImage,'width') / $factor)
	Local $height = int(DllStructGetData($tIplImage,'height') / $factor)

	DllCall($_opencv_core, "none:cdecl", "cvSetImageROI", "ptr", $pIplImage, "int", $x, "int", $y, "int", $width, "int", $height)
	If @error Then ConsoleWrite("error1" & @error & @CRLF)

	DllCall($_opencv_imgproc, "none:cdecl", "cvResize", "ptr", $pIplImage, "ptr", $pIplImagedst, "int", $type)
	If @error Then ConsoleWrite("error2" & @error & @CRLF)

        DllCall($_opencv_core, "none:cdecl", "cvResetImageROI", "ptr", $pIplImage)
	If @error Then ConsoleWrite("error3" & @error & @CRLF)

	DllCall($_opencv_core, "none:cdecl", "cvCopy", "ptr", $pIplImagedst, "ptr", $pIplImage, "ptr", 0)
	If @error Then ConsoleWrite("error4" & @error & @CRLF)

	DllCall($_opencv_core, "none:cdecl", "cvReleaseImage", "ptr*", $pIplImagedst)
	If @error Then ConsoleWrite("error5")

EndFunc	;==>_Opencv_cvZoom

;------------------------------------------------
; _Opencv_ZoomUp($pIplImage, $filter = 7)
;
; $pIplImage is a a pointer to IplImage of type 8UC3 (24bits) created by opencv
;
; Author: DLavoie
;
Func _Opencv_ZoomUp($pIplImage, $filter, $channel)

	Local $tIplImage = DllStructCreate($tagIplImage, $pIplImage)

;Un-comment these lines of code if you want to see IplImage header information
;for $i = 1 to 22
;	ConsoleWrite( $nIplImage[$i-1] & DllStructGetData($tIplImage,$i) & @CRLF)
;Next

	$_aResult = DllCall($_opencv_core, "int:cdecl", "cvCreateImage", "int", DllStructGetData($tIplImage,'width')*2, "int", DllStructGetData($tIplImage,'height')*2, "int", 8, "int", $channel )
	If @error Then ConsoleWrite("error5")

	Local $pIplImagedst = $_aResult[0]

;CVAPI(void)  cvPyrUp( const CvArr* src, CvArr* dst,
;                      int filter CV_DEFAULT(CV_GAUSSIAN_5x5) );
	DllCall($_opencv_imgproc, "none:cdecl", "cvPyrUp", "ptr", $pIplImage, "ptr", $pIplImagedst, "int",$filter)
	If @error Then ConsoleWrite("error6" & @error & @CRLF)

	Return $pIplImagedst

EndFunc	;==>_Opencv_ZoomUp

;------------------------------------------------
; _Opencv_ZoomDown($pIplImage, $filter = 7)
;
; $pIplImage is a a pointer to IplImage of type 8UC3 (24bits) created by opencv must be divisible by 2
;
; Author: DLavoie
;
Func _Opencv_ZoomDown($pIplImage, $filter, $channel)

	Local $tIplImage = DllStructCreate($tagIplImage, $pIplImage)

;Un-comment these lines of code if you want to see IplImage header information
;for $i = 1 to 22
;	ConsoleWrite( $nIplImage[$i-1] & DllStructGetData($tIplImage,$i) & @CRLF)
;Next

	$_aResult = DllCall($_opencv_core, "int:cdecl", "cvCreateImage", "int", DllStructGetData($tIplImage,'width')/2, "int", DllStructGetData($tIplImage,'height')/2, "int", 8, "int", $channel )
	If @error Then ConsoleWrite("error5")

	Local $pIplImagedst = $_aResult[0]

;CVAPI(void)  cvPyrDown( const CvArr* src, CvArr* dst,
;                        int filter CV_DEFAULT(CV_GAUSSIAN_5x5) );
	DllCall($_opencv_imgproc, "none:cdecl", "cvPyrDown", "ptr", $pIplImage, "ptr", $pIplImagedst, "int",$filter)
	If @error Then ConsoleWrite("error6" & @error & @CRLF)

	Return $pIplImagedst

EndFunc	;==>_Opencv_ZoomDown


;----------------
;myfcn EndFunc

;------------------------------------------------
;/*
;CVAPI(void) cvDestroyAllWindows( void );
;
;
Func _cvDestroyAllWindows(); )

DllCall($_opencv_highgui , "none:cdecl" , "cvDestroyAllWindows" ); )
If @error Then ConsoleWrite( "error in cvDestroyAllWindows")

Return
EndFunc ;==>_cvDestroyAllWindows

;------------------------------------------------
;/*
;CVAPI(int) cvStartWindowThread( void );
;
;
Func _cvStartWindowThread(); )

local $_aResult = DllCall($_opencv_highgui , "int:cdecl" , "cvStartWindowThread" ); )
If @error Then ConsoleWrite( "error in cvStartWindowThread")

Return
EndFunc ;==>_cvStartWindowThread

;------------------------------------------------
;/*
;CVAPI(double)  cvThreshold( const CvArr*  src, CvArr*  dst, double threshold, double max_value, int threshold_type );
; threshold type
;/* 0: Binary     1: Binary Inverted     2: Threshold Truncated     3: Threshold to Zero     4: Threshold to Zero Inverted   */


Func _cvThreshold( $cvsrc , $cvdst , $cvthreshold , $cvmax_value , $cvthreshold_type )

local $_aResult = DllCall($_opencv_imgproc , "double:cdecl" , "cvThreshold" , "ptr" , $cvsrc , "ptr" , $cvdst , "double" , $cvthreshold , "double" , $cvmax_value , "int" , $cvthreshold_type )
If @error Then ConsoleWrite( "error in cvThreshold")

Return
EndFunc ;==>_cvThreshold

;------------------------------------------------
;/*
;CVAPI(void) cvSet2D( CvArr* arr, int idx0, int idx1, CvScalar value );
;
;
Func _cvSet2D( $cvarr , $cvidx0 , $cvidx1 , $cvvalue )

DllCall($_opencv_core , "none:cdecl" , "cvSet2D" , "ptr" , $cvarr , "int" , $cvidx0 , "int" , $cvidx1 , "double" , $cvvalue , "double" , 0, "double" , 0, "double" , 0 )
If @error Then ConsoleWrite( "error in cvSet2D")

Return
EndFunc ;==>_cvSet2D

;------------------------------------------------
;/*
;CVAPI(void) cvFilter2D( const CvArr* src, CvArr* dst, const CvMat* kernel, CvPoint anchor CV_DEFAULT(cvPoint(-1-1)));
;
;
Func _cvFilter2D( $cvsrc , $cvdst , $cvkernel , $cvanchor = _cvPoint(-1,-1))

;DllCall($_opencv_imgproc , "none:cdecl" , "cvFilter2D" , "ptr" , $cvsrc , "ptr" , $cvdst , "ptr" , $cvkernel , "int" , -1 , "int" , -1)
DllCall($_opencv_imgproc , "none:cdecl" , "cvFilter2D" , "ptr" , $cvsrc , "ptr" , $cvdst , "ptr" , $cvkernel , "struct" , $cvanchor)

If @error Then ConsoleWrite( "error in cvFilter2D")

Return
EndFunc ;==>_cvFilter2D

;------------------------------------------------
;/*
;CVAPI(void) cvConvertImage( const CvArr* src, CvArr* dst, int flags CV_DEFAULT(0));
;
;
Func _cvConvertImage( $cvsrc , $cvdst , $cvflags = 0 )

DllCall($_opencv_highgui , "none:cdecl" , "cvConvertImage" , "ptr" , $cvsrc , "ptr" , $cvdst , "int" , $cvflags )
If @error Then ConsoleWrite( "error in cvConvertImage")

Return
EndFunc ;==>_cvConvertImage

;------------------------------------------------
;/*
;CVAPI(IplImage*)  cvCreateImage( CvSize size, int depth, int channels );
;
;
Func _cvCreateImage( $cvsize , $cvdepth , $cvchannels )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvCreateImage" , "struct" , $cvsize , "int" , $cvdepth , "int" , $cvchannels )
If @error Then ConsoleWrite( "error in cvCreateImage")

Return $_aResult[0]
EndFunc ;==>_cvCreateImage


;------------------------------------------------
;/*
;CVAPI(CvMat*) cvInitMatHeader( CvMat* mat, int rows, int cols, int type, void* data CV_DEFAULT(NULL), int step CV_DEFAULT(CV_AUTOSTEP) );
;
;
Func _cvInitMatHeader( $cvmat , $cvrows , $cvcols , $cvtype , $cvdata = Null , $cvstep = $CV_AUTO_STEP )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvInitMatHeader" , "ptr" , $cvmat , "int" , $cvrows , "int" , $cvcols , "int" , $cvtype , "ptr" , $cvdata , "int" , $cvstep )
If @error Then ConsoleWrite( "error in cvInitMatHeader")

Return $_aResult[0]
EndFunc ;==>_cvInitMatHeader


;------------------------------------------------
;/*
;CVAPI(double) cvGetCaptureProperty( CvCapture* capture, int property_id );
;
;
Func _cvGetCaptureProperty( $cvcapture , $cvproperty_id )

local $_aResult = DllCall($_opencv_highgui , "double:cdecl" , "cvGetCaptureProperty" , "ptr" , $cvcapture , "int" , $cvproperty_id )
If @error Then ConsoleWrite( "error in cvGetCaptureProperty")

Return $_aResult[0]
EndFunc ;==>_cvGetCaptureProperty


;------------------------------------------------
;/*
;CVAPI(int)    cvSetCaptureProperty( CvCapture* capture, int property_id, double value );
;
;
Func _cvSetCaptureProperty( $cvcapture , $cvproperty_id , $cvvalue = 0 )

local $_aResult = DllCall($_opencv_highgui , "int:cdecl" , "cvSetCaptureProperty" , "ptr" , $cvcapture , "int" , $cvproperty_id , "double" , $cvvalue )
If @error Then ConsoleWrite( "error in cvSetCaptureProperty")

Return $_aResult[0]
EndFunc ;==>_cvSetCaptureProperty


;------------------------------------------------
;/*
;CVAPI(schar*)  cvGetSeqElem( const CvSeq* seq, int index );
;
;
Func _cvGetSeqElem( $cvseq , $cvindex )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvGetSeqElem" , "ptr" , $cvseq , "int" , $cvindex )
If @error Then ConsoleWrite( "error in cvGetSeqElem")

Return $_aResult[0]
EndFunc ;==>_cvGetSeqElem

;------------------------------------------------
;/*
;CVAPI(CvSeq*) cvHoughCircles( CvArr* image, void* circle_storage, int method, double dp, double min_dist, double param1 CV_DEFAULT(100), double param2 CV_DEFAULT(100), int min_radius CV_DEFAULT(0), int max_radius CV_DEFAULT(0));
;
;
Func _cvHoughCircles( $cvimage , $cvcircle_storage , $cvmethod , $cvdp , $cvmin_dist , $cvparam1 = 100 , $cvparam2 = 100 , $cvmin_radius = 0 , $cvmax_radius = 0 )

local $_aResult = DllCall($_opencv_imgproc , "ptr:cdecl" , "cvHoughCircles" , "ptr" , $cvimage , "ptr" , $cvcircle_storage , "int" , $cvmethod , "double" , $cvdp , "double" , $cvmin_dist , "double" , $cvparam1 , "double" , $cvparam2 , "int" , $cvmin_radius , "int" , $cvmax_radius )
If @error Then ConsoleWrite( "error in cvHoughCircles")

Return $_aResult[0]
EndFunc ;==>_cvHoughCircles


;------------------------------------------------
;/*
;CVAPI(CvMemStorage*)  cvCreateMemStorage( int block_size CV_DEFAULT(0));
;
;
Func _cvCreateMemStorage( $cvblock_size )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvCreateMemStorage" , "int" , $cvblock_size )
If @error Then ConsoleWrite( "error in cvCreateMemStorage")

Return $_aResult[0]
EndFunc ;==>_cvCreateMemStorage

;------------------------------------------------
;/*
;CVAPI(void)  cvEqualizeHist( const CvArr* src, CvArr* dst );
;
;
Func _cvEqualizeHist( $cvsrc , $cvdst )

DllCall($_opencv_imgproc , "none:cdecl" , "cvEqualizeHist" , "ptr" , $cvsrc , "ptr" , $cvdst )
If @error Then ConsoleWrite( "error in cvEqualizeHist")

Return
EndFunc ;==>_cvEqualizeHist


;------------------------------------------------;/*
;CVAPI(int) cvCheckChessboard(IplImage* src, CvSize size);
;
;
Func _cvCheckChessboard( $cvsrc , $cvsize); )

local $_aResult = DllCall($_opencv_calib3d , "int:cdecl" , "cvCheckChessboard" , "ptr" , $cvsrc , "struct" , $cvsize); )
If @error Then ConsoleWrite("error in cvCheckChessboard")

Return $_aResult[0]
EndFunc ;==>_cvCheckChessboard

;------------------------------------------------;/*
;CVAPI(void) cvDrawChessboardCorners( CvArr* image, CvSize pattern_size, CvPoint2D32f* corners, int count, int pattern_was_found );
;
;
Func _cvDrawChessboardCorners( $cvimage , $cvpattern_size , $cvcorners , $cvcount , $cvpattern_was_found )

DllCall($_opencv_calib3d , "none:cdecl" , "cvDrawChessboardCorners" , "ptr" , $cvimage , "struct" , $cvpattern_size , "ptr" , $cvcorners , "int" , $cvcount , "int" , $cvpattern_was_found )
If @error Then ConsoleWrite("error in cvDrawChessboardCorners")

Return
EndFunc ;==>_cvDrawChessboardCorners


;------------------------------------------------;/*
;CVAPI(void)  cvFindCornerSubPix( const CvArr* image, CvPoint2D32f* corners, int count, CvSize win, CvSize zero_zone, CvTermCriteria  criteria );
;
;
Func _cvFindCornerSubPix( $cvimage , $cvcorners , $cvcount , $cvwin , $cvzero_zone , $cvcriteria )

DllCall($_opencv_imgproc , "none:cdecl" , "cvFindCornerSubPix" , "ptr" , $cvimage , "ptr" , $cvcorners , "int" , $cvcount , "struct" , $cvwin , "struct" , $cvzero_zone , "struct" , $cvcriteria )

If @error Then ConsoleWrite("error in cvFindCornerSubPix")

Return
EndFunc ;==>_cvFindCornerSubPix


;------------------------------------------------;/*
;CVAPI(int) cvFindChessboardCorners( const void* image, CvSize pattern_size, CvPoint2D32f* corners, int* corner_count CV_DEFAULT(NULL), int flags CV_DEFAULT(CV_CALIB_CB_ADAPTIVE_THRESH+CV_CALIB_CB_NORMALIZE_IMAGE) );
;
;
Func _cvFindChessboardCorners( $cvimage , $cvpattern_size , $cvcorners , ByRef $cvcorner_count , $cvflags = ($CV_CALIB_CB_ADAPTIVE_THRESH+$CV_CALIB_CB_NORMALIZE_IMAGE) )

Local $vcvcorner_count = DllStructCreate("int")
DllStructSetData( $vcvcorner_count, 1, $cvcorner_count)

local $_aResult = DllCall($_opencv_calib3d , "int:cdecl" , "cvFindChessboardCorners" , "ptr" , $cvimage , "struct" , $cvpattern_size , "ptr" , $cvcorners , "ptr" , DllStructGetPtr($vcvcorner_count) , "int" , $cvflags )
If @error Then ConsoleWrite("error in cvFindChessboardCorners")

$cvcorner_count = DllStructGetData( $vcvcorner_count, 1 )

Return $_aResult[0]
EndFunc ;==>_cvFindChessboardCorners


;------------------------------------------------;/*
;CVAPI(CvMat*)  cvCreateMat( int rows, int cols, int type );
;
;
Func _cvCreateMat( $cvrows , $cvcols , $cvtype )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvCreateMat" , "int" , $cvrows , "int" , $cvcols , "int" , $cvtype )
If @error Then ConsoleWrite("error in cvCreateMat")

Return $_aResult[0]
EndFunc ;==>_cvCreateMat

;------------------------------------------------
;/*
;CVAPI(void)  cvAddWeighted( const CvArr* src1, double alpha, const CvArr* src2, double beta, double gamma, CvArr* dst );
;
;
Func _cvAddWeighted( $cvsrc1 , $cvalpha , $cvsrc2 , $cvbeta , $cvgamma , $cvdst )

DllCall($_opencv_core , "none:cdecl" , "cvAddWeighted" , "ptr" , $cvsrc1 , "double" , $cvalpha , "ptr" , $cvsrc2 , "double" , $cvbeta , "double" , $cvgamma , "ptr" , $cvdst )
If @error Then ConsoleWrite("error in cvAddWeighted")

Return
EndFunc ;==>_cvAddWeighted


;------------------------------------------------;/*
;CVAPI(IplImage*) cvCloneImage( const IplImage* image );
;
;
Func _cvCloneImage( $cvimage )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvCloneImage" , "ptr" , $cvimage )
If @error Then ConsoleWrite("error in cvCloneImage")

Return $_aResult[0]
EndFunc ;==>_cvCloneImage


;------------------------------------------------;/*
;CVAPI(void)  cvAddS( const CvArr* src, CvScalar value, CvArr* dst, const CvArr* mask CV_DEFAULT(NULL));
;
;
Func _cvAddS( $cvsrc , $cvvalue , $cvdst , $cvmask = "" )

;ConsoleWrite("cvvalue = " & DllStructGetData($cvvalue,1) & " h=" & DllStructGetData($cvvalue,2) & DllStructGetData($cvvalue,3) & DllStructGetData($cvvalue,4) & @CRLF )


DllCall($_opencv_core , "none:cdecl" , "cvAddS" , "ptr" , $cvsrc , "struct" , $cvvalue , "ptr" , $cvdst , "ptr" , $cvmask )
; used bottom line for earlier versions of autoit
;DllCall($_opencv_core , "none:cdecl" , "cvAddS" , "ptr" , $cvsrc , "double" , DllStructGetData($cvvalue,1) , "double" , DllStructGetData($cvvalue,2) , "double" , DllStructGetData($cvvalue,3) , "double" , DllStructGetData($cvvalue,4) , "ptr" , $cvdst , "ptr" , $cvmask )

If @error Then ConsoleWrite("error in cvAddS")

Return
EndFunc ;==>_cvAddS

;------------------------------------------------;/*
;CVAPI(void)  cvSetImageROI( IplImage* image, CvRect rect );
;
;
Func _cvSetImageROI( $cvimage , $cvrect )

DllCall($_opencv_core , "none:cdecl" , "cvSetImageROI" , "ptr" , $cvimage , "struct" , $cvrect )
If @error Then ConsoleWrite("error in cvSetImageROI")

Return
EndFunc ;==>_cvSetImageROI


;------------------------------------------------;/*
;CVAPI(void)  cvResetImageROI( IplImage* image );
;
;
Func _cvResetImageROI( $cvimage )

DllCall($_opencv_core , "none:cdecl" , "cvResetImageROI" , "ptr" , $cvimage )
If @error Then ConsoleWrite("error in cvResetImageROI")

Return
EndFunc ;==>_cvResetImageROI


;------------------------------------------------;/*
;CVAPI(void)  cvCvtColor( const CvArr* src, CvArr* dst, int code );
;
;
Func _cvCvtColor( $cvsrc , $cvdst , $cvcode )

DllCall($_opencv_imgproc , "none:cdecl" , "cvCvtColor" , "ptr" , $cvsrc , "ptr" , $cvdst , "int" , $cvcode )
If @error Then ConsoleWrite("error in cvCvtColor")

Return
EndFunc ;==>_cvCvtColor

;------------------------------------------------;/*
;CVAPI(void)  cvCanny( const CvArr* image, CvArr* edges, double threshold1, double threshold2, int  aperture_size CV_DEFAULT(3) );
;
;
Func _cvCanny( $cvimage , $cvedges , $cvthreshold1 , $cvthreshold2 , $cvaperture_size = 3 )
DllCall($_opencv_imgproc , "none:cdecl" , "cvCanny" , "ptr" , $cvimage , "ptr" , $cvedges , "double" , $cvthreshold1 , "double" , $cvthreshold2 , "int" , $cvaperture_size )
If @error Then ConsoleWrite("error in cvCanny")

Return
EndFunc ;==>_cvCanny


;------------------------------------------------;/*
;CVAPI(void)  cvPyrDown( const CvArr* src, CvArr* dst, int filter CV_DEFAULT(CV_GAUSSIAN_5x5) );
;
;
Func _cvPyrDown( $cvsrc , $cvdst , $cvfilter = $CV_GAUSSIAN_5x5 )

DllCall($_opencv_imgproc , "none:cdecl" , "cvPyrDown" , "ptr" , $cvsrc , "ptr" , $cvdst , "int" , $cvfilter )
If @error Then ConsoleWrite("error in cvPyrDown")

Return
EndFunc ;==>_cvPyrDown


;------------------------------------------------
;/*
;CVAPI(void) cvSmooth( const CvArr* src, CvArr* dst, int smoothtype CV_DEFAULT(CV_GAUSSIAN), int size1 CV_DEFAULT(3), int size2 CV_DEFAULT(0), double sigma1 CV_DEFAULT(0), double sigma2 CV_DEFAULT(0));
;
;
Func _cvSmooth( $cvsrc , $cvdst , $cvsmoothtype = $CV_GAUSSIAN , $cvsize1 = 3 , $cvsize2 = 0  , $cvsigma1 = 0 , $cvsigma2 = 0)

DllCall($_opencv_imgproc , "none:cdecl" , "cvSmooth" , "ptr" , $cvsrc , "ptr" , $cvdst , "int" , $cvsmoothtype , "int" , $cvsize1 , "int" , $cvsize2 , "double" , $cvsigma1 , "double" , $cvsigma2 )
If @error Then ConsoleWrite("error in cvSmooth")

Return
EndFunc ;==>_cvSmooth

;------------------------------------------------
;/* Returns Cvmat pointer */
; $darray of size $rows * $cols
Func _cvMat($rows, $cols, $type, $darray)

Local $pmat = _cvCreateMat( $rows, $cols, $type )

for $ir = 0 to $rows-1
   for $ic = 0 to $cols-1
	  _cvSet2D( $pmat, $ir, $ic, $darray[$ir*$cols + $ic] );
   Next
Next


;Local $cvmat = _cvInitMatHeader( $pmat , $rows , $cols , $type , DllStructGetPtr($vdarray) )

;ConsoleWrite("cvmat = " & $pmat & " 2=" & $cvmat & " 3=" & DllStructGetPtr($vdarray)& @CRLF )

Return $pmat

EndFunc ;==>_cvMat



;------------------------------------------------
;/* Returns Point structure of array in elements */
;
Func _cvPoint($x,$y)

Local $vPoint = DllStructCreate($tagCvPoint)
DllStructSetData($vPoint, "x", $x)
DllStructSetData($vPoint, "y", $y)


;ConsoleWrite("csize image w = " & DllStructGetData($vsize,'width') & " h=" & DllStructGetData($vsize,'height') & " var=" & DllStructGetPtr($vsize) & @CRLF )

Return $vPoint
EndFunc ;==>_cvPoint


;------------------------------------------------
;/* Returns Point structure of array in elements */
;
Func _cvPoint2D32f($x,$y)

Local $vPoint = DllStructCreate($tagCvPoint2D32f)
DllStructSetData($vPoint, "x", $x)
DllStructSetData($vPoint, "y", $y)


;ConsoleWrite("csize image w = " & DllStructGetData($vsize,'width') & " h=" & DllStructGetData($vsize,'height') & " var=" & DllStructGetPtr($vsize) & @CRLF )

Return $vPoint
EndFunc ;==>_cvPoint2D32f


;------------------------------------------------
;/* Returns Point structure of array in elements */
;
Func _cvPoint2D64f($x,$y)

Local $vPoint = DllStructCreate($tagCvPoint2D64f)
DllStructSetData($vPoint, "x", $x)
DllStructSetData($vPoint, "y", $y)


;ConsoleWrite("csize image w = " & DllStructGetData($vsize,'width') & " h=" & DllStructGetData($vsize,'height') & " var=" & DllStructGetPtr($vsize) & @CRLF )

Return $vPoint
EndFunc ;==>_cvPoint2D64f


;------------------------------------------------
;/* Returns Point structure of array in elements */
;
Func _cvPoint3D32f($x,$y,$z)

Local $vPoint = DllStructCreate($tagCvPoint3D32f)
DllStructSetData($vPoint, "x", $x)
DllStructSetData($vPoint, "y", $y)
DllStructSetData($vPoint, "z", $z)

;ConsoleWrite("csize image w = " & DllStructGetData($vsize,'width') & " h=" & DllStructGetData($vsize,'height') & " var=" & DllStructGetPtr($vsize) & @CRLF )

Return $vPoint
EndFunc ;==>_cvPoint2D32f


;------------------------------------------------
;/* Returns Point structure of array in elements */
;
Func _cvPoint3D64f($x,$y,$z)

Local $vPoint = DllStructCreate($tagCvPoint3D64f)
DllStructSetData($vPoint, "x", $x)
DllStructSetData($vPoint, "y", $y)
DllStructSetData($vPoint, "z", $z)

;ConsoleWrite("csize image w = " & DllStructGetData($vsize,'width') & " h=" & DllStructGetData($vsize,'height') & " var=" & DllStructGetPtr($vsize) & @CRLF )

Return $vPoint
EndFunc ;==>_cvPoint2D32f


;------------------------------------------------
;/* Returns Scalar structure of array in elements */
;
Func _cvScalar($value)

Local $vScalar = DllStructCreate($tagCvScalar)

If VarGetType($value) = "Array" Then
ConsoleWrite( "= " & $value[0] & $value[1] & $value[2] & $value[3])
   DllStructSetData($vScalar, 1, $value[0])
   DllStructSetData($vScalar, 2, $value[1])
   DllStructSetData($vScalar, 3, $value[2])
   DllStructSetData($vScalar, 4, $value[3])
Else
   DllStructSetData($vScalar, 1, $value)
   DllStructSetData($vScalar, 2, $value)
   DllStructSetData($vScalar, 3, $value)
   DllStructSetData($vScalar, 4, $value)
EndIf
;ConsoleWrite("cvvalue = " & DllStructGetData($vScalar,1) & " h=" & DllStructGetData($vScalar,2) & DllStructGetData($vScalar,3) & DllStructGetData($vScalar,4) & @CRLF )

Return $vScalar

EndFunc ;==>_cvScalar

;------------------------------------------------
;/* Returns Scalar structure of array in elements */
;
Func _CV_RGB($cvRed, $cvGreen, $cvBlue)

Local $vScalar = DllStructCreate($tagCvScalar)


   DllStructSetData($vScalar, 1, $cvBlue)
   DllStructSetData($vScalar, 2, $cvGreen)
   DllStructSetData($vScalar, 3, $cvRed)
   DllStructSetData($vScalar, 4, 0)

;ConsoleWrite("cvvalue = " & DllStructGetData($vScalar,1) & " h=" & DllStructGetData($vScalar,2) & DllStructGetData($vScalar,3) & DllStructGetData($vScalar,4) & @CRLF )

Return $vScalar

EndFunc ;==>_CV_RGB

;------------------------------------------------
;/* Returns Size structure of array in elements */
;
Func _cvSize($width,$height)

Local $vSize = DllStructCreate($tagCvSize)

DllStructSetData($vSize, "width", $width)
DllStructSetData($vSize, "height", $height)

;ConsoleWrite("csize image w = " & DllStructGetData($vsize,'width') & " h=" & DllStructGetData($vsize,'height') & " var=" & DllStructGetPtr($vsize) & @CRLF )

Return $vSize

EndFunc ;==>_cvSize

;------------------------------------------------
;/* Returns Slice structure of array in elements */
;
Func _cvSlice($start,$end)

Local $vSlice = DllStructCreate($tagCvSlice)

DllStructSetData($vSlice, "start_index", $start)
DllStructSetData($vSlice, "end_index", $end)


Return $vSlice

EndFunc ;==>_cvSlice

;------------------------------------------------
;/* Returns Slice structure of array in elements */
;
Func _cvContourPerimeter($contour)

Local $_aResult = _cvArcLength( $contour , _CvSlice(0,0x3fffffff) , 1)

Return $_aResult

EndFunc ;==>_cvSlice

;------------------------------------------------
;/* Returns Rect structure of array in elements */
;
Func _cvRect($x,$y,$width,$height)

Local $vRect = DllStructCreate($tagCvRect)
DllStructSetData($vRect, "x", $x)
DllStructSetData($vRect, "y", $y)
DllStructSetData($vRect, "width", $width)
DllStructSetData($vRect, "height", $height)

;ConsoleWrite("csize image w = " & DllStructGetData($vsize,'width') & " h=" & DllStructGetData($vsize,'height') & " var=" & DllStructGetPtr($vsize) & @CRLF )

Return $vRect

EndFunc ;==>_cvRect

;------------------------------------------------
;/* Returns termcriteria structure of array in elements */
;
Func _cvTermCriteria( $type, $max_iter,$epsilon)

Local $vPoint = DllStructCreate($tagcvTermCriteria)
DllStructSetData($vPoint, "type", $type)
DllStructSetData($vPoint, "max_iter", $max_iter)
DllStructSetData($vPoint, "epsilon", $epsilon)

;ConsoleWrite("csize image w = " & DllStructGetData($vsize,'width') & " h=" & DllStructGetData($vsize,'height') & " var=" & DllStructGetPtr($vsize) & @CRLF )

Return $vPoint
EndFunc ;==>_cvPoint2D32f


;------------------------------------------------
;/* Returns width and height of array in elements */
;CVAPI(CvSize) cvGetSize( const CvArr* arr );
Func _cvGetSize( $pimage )

local $_aResult = DllCall($_opencv_core, "int64:cdecl", "cvGetSize", "ptr", $pimage)
If @error Then ConsoleWrite("error csize image ")

Local $width = BitAND(0xFFFFFFFF , $_aResult[0])
Local $height = int( $_aResult[0]/2^32)

Local $vsize = DllStructCreate($tagCvSize)
DllStructSetData($vsize, "width", $width)
DllStructSetData($vsize, "height", $height)

;ConsoleWrite("csize image w = " & DllStructGetData($vsize,'width') & " h=" & DllStructGetData($vsize,'height') & " var=" & DllStructGetPtr($vsize) & @CRLF )

Return $vsize

EndFunc ;==>__cvCreateImage



;------------------------------------------------
;/* Creates IPL image (header and data) */
;CVAPI(IplImage*)  cvCreateImage( CvSize size, int depth, int channels );
Func _cvCreateImagex( $psize, $depth, $channels )

Local $vsize = DllStructCreate($tagCvSize, DllStructGetPtr($psize))
;ConsoleWrite("..csize image w = " & DllStructGetData($vsize,'width') & " h=" & DllStructGetData($vsize,'height') & " var=" & $psize & " var=" & DllStructGetPtr($vsize) & @CRLF )

local $_aResult = DllCall($_opencv_core, "int:cdecl", "cvCreateImage", "int", DllStructGetData($vsize,'width'), "int", DllStructGetData($vsize,'height'), "int", $depth, "int", $channels)
If @error Then ConsoleWrite("error create image ")

Return $_aResult[0]

EndFunc ;==>__cvCreateImage

;------------------------------------------------
;/*
;CVAPI(void)  cvReleaseMat( CvMat** mat );
;
;
Func _cvReleaseMat( $cvmat )

DllCall($_opencv_core , "none:cdecl" , "cvReleaseMat" , "ptr*" , $cvmat )
If @error Then ConsoleWrite( "error in cvReleaseMat")

Return
EndFunc ;==>_cvReleaseMat



;------------------------------------------------
;/* destroy window and all the trackers associated with it */
;CVAPI(void) cvDestroyWindow( const char* name );
Func _cvDestroyWindow($name)

Local $vname = DllStructCreate($tagchar)
DllStructSetData($vname, 1, $name)

DllCall($_opencv_core, "none:cdecl", "cvDestroyWindow", "ptr", DllStructGetPtr($vname))
If @error Then ConsoleWrite("error window release " & $name)

EndFunc ;==>_cvDestroyWindow


;------------------------------------------------
;/* Releases IPL image header and data */
;CVAPI(void)  cvReleaseImage( IplImage** image );
Func _cvReleaseImage($pimage)

DllCall($_opencv_core, "none:cdecl", "cvReleaseImage", "ptr*", $pimage)
If @error Then ConsoleWrite("error image release")

EndFunc ;==>_cvReleaseImage



;------------------------------------------------
;/* wait for key event infinitely (delay<=0) or for "delay" milliseconds */
;CVAPI(int) cvWaitKey(int delay CV_DEFAULT(0));

Func _cvWaitKey($delay = $CV_DEFAULT )

local $_aResult = DllCall($_opencv_highgui, "int:cdecl", "cvWaitKey", "int", $delay )
If @error Then ConsoleWrite("error wait key")

EndFunc ;==>_cvWaitKey


;------------------------------------------------
;/* display image within window (highgui windows remember their content) */
;CVAPI(void) cvShowImage( const char* name, const CvArr* image );

Func _cvShowImage($name , $pimage)

Local $vname = DllStructCreate($tagchar)
DllStructSetData($vname, 1, $name)

DllCall($_opencv_highgui, "none:cdecl", "cvShowImage", "ptr", DllStructGetPtr($vname), "ptr" , $pimage )
If @error Then ConsoleWrite("error display" & $name)

EndFunc ;==>_cvShowImage


;------------------------------------------------
;/* create window */
;CVAPI(int) cvNamedWindow( const char* name, int flags CV_DEFAULT(CV_WINDOW_AUTOSIZE) );
Func _cvNamedWindow($name , $flags = $CV_WINDOW_AUTOSIZE )

Local $vname = DllStructCreate($tagchar)
DllStructSetData($vname, 1, $name)

local $_aResult = DllCall($_opencv_highgui, "int:cdecl", "cvNamedWindow", "ptr", DllStructGetPtr($vname), "int" , $flags )
If @error Then ConsoleWrite("error winname" & $name)

EndFunc ;==>_cvNamedWindow


;------------------------------------------------
; _cvLoadImage($filename)
;
; $filename is a string identifying the location of image file if $filename = "" then autoi file open dialog box will appear
;
; Returns a pointer of loaded image in an IplImage format
;
Func _cvLoadImage(ByRef $filename , $iscolor = $CV_LOAD_IMAGE_COLOR )

   If $filename = "" Then $filename = FileOpenDialog( "Select graphic file", @ScriptDir & "\", "Images (*.jpg;*.bmp;*.png)", 3,"",$hwnd )
   ;ConsoleWrite("error2" & $filename )
   $_aResult = DllCall($_opencv_highgui, "int:cdecl", "cvLoadImage", "str", $filename, "int", $iscolor )
   If @error Then ConsoleWrite("File not loading")

   Return $_aResult[0]

EndFunc ;==>_cvLoadImage


;------------------------------------------------
; _Opencv_CloseDLL()
;
;
;
Func _Opencv_CloseDLL()
	DllClose($_opencv_core)

	DllClose($_opencv_highgui)

	DllClose($_opencv_imgproc)

	DllClose($_opencv_calib3d)

	DllClose($_opencv_features2d)
EndFunc


;------------------------------------------------
; _OpenCV_Startup()
;
;
;
Func _OpenCV_Startup()

	$_opencv_core = DllOpen("opencv_core245.dll")

	$_opencv_highgui = DllOpen("opencv_highgui245.dll")

    $_opencv_imgproc = DllOpen("opencv_imgproc245.dll")

	$_opencv_calib3d = DllOpen("opencv_calib3d245.dll")

	$_opencv_features2d = DllOpen("opencv_features2d245.dll")

EndFunc   ;==>_OpenCV_Startup
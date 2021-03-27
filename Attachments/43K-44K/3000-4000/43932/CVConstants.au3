#include-once

; #INDEX# =======================================================================================================================
; Title .........: CVConstants
; AutoIt Version : 3.3.10.2
; Language ......: English
; Description ...: Constants for OpenCV
; Author(s) .....: Mylise
; ===============================================================================================================================

; #Constants# ======================================================================================================================
Global Const $CV_PI   = 3.1415926535897932384626433832795
Global Const $CV_LOG2 = 0.69314718055994530941723212145818
Global Const $CV_AUTO_STEP  = 0x7fffffff
Global Const $CV_DEFAULT = 0

Global Const $CV_LOAD_IMAGE_UNCHANGED = -1
Global Const $CV_LOAD_IMAGE_GRAYSCALE = 0
Global Const $CV_LOAD_IMAGE_COLOR = 1
Global Const $CV_LOAD_IMAGE_ANYDEPTH = 2
Global Const $CV_LOAD_IMAGE_ANYCOLOR = 4

; These 4 flags are used by cvSet/GetWindowProperty
Global Const $CV_WND_PROP_FULLSCREEN = 0 	; to change/get window's fullscreen property
Global Const $CV_WND_PROP_AUTOSIZE = 1 		; to change/get window's autosize property
Global Const $CV_WND_PROP_ASPECTRATIO = 2 	; to change/get window's aspectratio property
Global Const $CV_WND_PROP_OPENGL = 3 		; to change/get window's opengl support

; These 3 flags are used by cvNamedWindow and cvSet/GetWindowProperty
Global Const $CV_WINDOW_NORMAL = 0x00000000		; the user can resize the window (no constraint)  / also use to switch a fullscreen window to a normal size
Global Const $CV_WINDOW_AUTOSIZE = 0x00000001	; the user cannot resize the window, the size is constrainted by the image displayed
Global Const $CV_WINDOW_OPENGL = 0x00001000		; window with opengl support

; Those flags are only for Qt
Global Const $CV_GUI_EXPANDED = 0x00000000	; status bar and tool bar
Global Const $CV_GUI_NORMAL = 0x00000010	; old fashious way

; These 3 flags are used by cvNamedWindow and cvSet/GetWindowProperty
Global Const $CV_WINDOW_FULLSCREEN = 1			; change the window to fullscreen
Global Const $CV_WINDOW_FREERATIO = 0x00000100	; the image expends as much as it can (no ratio constraint)
Global Const $CV_WINDOW_KEEPRATIO = 0x00000000	; the ration image is respected.

; Video Files and Cameras types and parameters
Global Const $CV_CAP_PROP_POS_MSEC       =0
Global Const $CV_CAP_PROP_POS_FRAMES     =1
Global Const $CV_CAP_PROP_POS_AVI_RATIO  =2
Global Const $CV_CAP_PROP_FRAME_WIDTH    =3
Global Const $CV_CAP_PROP_FRAME_HEIGHT   =4
Global Const $CV_CAP_PROP_FPS            =5
Global Const $CV_CAP_PROP_FOURCC         =6
Global Const $CV_CAP_PROP_FRAME_COUNT    =7
Global Const $CV_CAP_PROP_FORMAT         =8
Global Const $CV_CAP_PROP_MODE           =9
Global Const $CV_CAP_PROP_BRIGHTNESS    =10
Global Const $CV_CAP_PROP_CONTRAST      =11
Global Const $CV_CAP_PROP_SATURATION    =12
Global Const $CV_CAP_PROP_HUE           =13
Global Const $CV_CAP_PROP_GAIN          =14
Global Const $CV_CAP_PROP_EXPOSURE      =15
Global Const $CV_CAP_PROP_CONVERT_RGB   =16
Global Const $CV_CAP_PROP_WHITE_BALANCE_BLUE_U =17
Global Const $CV_CAP_PROP_RECTIFICATION =18
Global Const $CV_CAP_PROP_MONOCROME     =19
Global Const $CV_CAP_PROP_SHARPNESS     =20
Global Const $CV_CAP_PROP_AUTO_EXPOSURE =21
Global Const $CV_CAP_PROP_GAMMA         =22
Global Const $CV_CAP_PROP_TEMPERATURE   =23
Global Const $CV_CAP_PROP_TRIGGER       =24
Global Const $CV_CAP_PROP_TRIGGER_DELAY =25
Global Const $CV_CAP_PROP_WHITE_BALANCE_RED_V =26
Global Const $CV_CAP_PROP_ZOOM          =27
Global Const $CV_CAP_PROP_FOCUS         =28
Global Const $CV_CAP_PROP_GUID          =29
Global Const $CV_CAP_PROP_ISO_SPEED     =30
Global Const $CV_CAP_PROP_MAX_DC1394    =31
Global Const $CV_CAP_PROP_BACKLIGHT     =32
Global Const $CV_CAP_PROP_PAN           =33
Global Const $CV_CAP_PROP_TILT          =34
Global Const $CV_CAP_PROP_ROLL          =35
Global Const $CV_CAP_PROP_IRIS          =36
Global Const $CV_CAP_PROP_SETTINGS      =37

;Different constant used by opencv for selecting webcam ie. dshow web cam index would be 700, 701, 702, etc...
Global Const $CV_CAP_ANY      =0;     // autodetect
Global Const $CV_CAP_MIL      =100;   // MIL proprietary drivers
Global Const $CV_CAP_VFW      =200;   // platform native
Global Const $CV_CAP_V4L      =200;
Global Const $CV_CAP_V4L2     =200;
Global Const $CV_CAP_FIREWARE =300;   // IEEE 1394 drivers
Global Const $CV_CAP_FIREWIRE =300;
Global Const $CV_CAP_IEEE1394 =300;
Global Const $CV_CAP_DC1394   =300;
Global Const $CV_CAP_CMU1394  =300;
Global Const $CV_CAP_STEREO   =400;   // TYZX proprietary drivers
Global Const $CV_CAP_TYZX     =400;
Global Const $CV_TYZX_LEFT    =400;
Global Const $CV_TYZX_RIGHT   =401;
Global Const $CV_TYZX_COLOR   =402;
Global Const $CV_TYZX_Z       =403;
Global Const $CV_CAP_QT       =500;   // QuickTime
Global Const $CV_CAP_UNICAP   =600;   // Unicap drivers
Global Const $CV_CAP_DSHOW    =700;   // DirectShow (via videoInput)
Global Const $CV_CAP_MSMF     =1400;  // Microsoft Media Foundation (via videoInput)
Global Const $CV_CAP_PVAPI    =800;   // PvAPI, Prosilica GigE SDK
Global Const $CV_CAP_OPENNI   =900;   // OpenNI (for Kinect)
Global Const $CV_CAP_OPENNI_ASUS =910;   // OpenNI (for Asus Xtion)
Global Const $CV_CAP_ANDROID  =1000;  // Android
Global Const $CV_CAP_XIAPI    =1100;   // XIMEA Camera API
Global Const $CV_CAP_AVFOUNDATION = 1200;  // AVFoundation framework for iOS (OS X Lion will have the same API)
Global Const $CV_CAP_GIGANETIX = 1300;  // Smartek Giganetix GigEVisionSDK

;/* Image smooth methods */
Global Const $CV_BLUR_NO_SCALE =0
Global Const $CV_BLUR  =1
Global Const $CV_GAUSSIAN  =2
Global Const $CV_MEDIAN =3
Global Const $CV_BILATERAL =4

; image types
Global Const $IPL_DEPTH_SIGN = 0x80000000

Global Const $IPL_DEPTH_1U =    1
Global Const $IPL_DEPTH_8U =    8
Global Const $IPL_DEPTH_16U =  16
Global Const $IPL_DEPTH_32F =  32

Global Const $IPL_DEPTH_8S = (BitOR($IPL_DEPTH_SIGN , 8))
Global Const $IPL_DEPTH_16S = (BitOR($IPL_DEPTH_SIGN ,16))
Global Const $IPL_DEPTH_32S = (BitOR($IPL_DEPTH_SIGN , 32))

; CV channel types
Global Const $CV_8UC1 = 0
Global Const $CV_8UC2 = 8
Global Const $CV_8UC3 = 16
Global Const $CV_8UC4 = 24

Global Const $CV_8SC1 = 1
Global Const $CV_8SC2 = 9
Global Const $CV_8SC3 = 17
Global Const $CV_8SC4 = 25

Global Const $CV_16UC1 = 2
Global Const $CV_16UC2 = 10
Global Const $CV_16UC3 = 18
Global Const $CV_16UC4 = 26

Global Const $CV_16SC1 = 3
Global Const $CV_16SC2 = 11
Global Const $CV_16SC3 = 19
Global Const $CV_16SC4 = 27

Global Const $CV_32SC1 = 3
Global Const $CV_32SC2 = 12
Global Const $CV_32SC3 = 20
Global Const $CV_32SC4 = 28

Global Const $CV_32FC1 = 5
Global Const $CV_32FC2 = 13
Global Const $CV_32FC3 = 21
Global Const $CV_32FC4 = 29

Global Const $CV_64FC1 = 6
Global Const $CV_64FC2 = 14
Global Const $CV_64FC3 = 22
Global Const $CV_64FC4 = 30

; Mouse
Global Const $CV_EVENT_MOUSEMOVE      =0
Global Const $CV_EVENT_LBUTTONDOWN    =1
Global Const $CV_EVENT_RBUTTONDOWN    =2
Global Const $CV_EVENT_MBUTTONDOWN    =3
Global Const $CV_EVENT_LBUTTONUP      =4
Global Const $CV_EVENT_RBUTTONUP      =5
Global Const $CV_EVENT_MBUTTONUP      =6
Global Const $CV_EVENT_LBUTTONDBLCLK  =7
Global Const $CV_EVENT_RBUTTONDBLCLK  =8
Global Const $CV_EVENT_MBUTTONDBLCLK  =9

Global Const $CV_EVENT_FLAG_LBUTTON   =1
Global Const $CV_EVENT_FLAG_RBUTTON   =2
Global Const $CV_EVENT_FLAG_MBUTTON   =4
Global Const $CV_EVENT_FLAG_CTRLKEY   =8
Global Const $CV_EVENT_FLAG_SHIFTKEY  =16
Global Const $CV_EVENT_FLAG_ALTKEY    =32

; Save file image format
Global Const $CV_IMWRITE_JPEG_QUALITY =1
Global Const $CV_IMWRITE_PNG_COMPRESSION =16
Global Const $CV_IMWRITE_PNG_STRATEGY =17
Global Const $CV_IMWRITE_PNG_BILEVEL =18
Global Const $CV_IMWRITE_PNG_STRATEGY_DEFAULT =0
Global Const $CV_IMWRITE_PNG_STRATEGY_FILTERED =1
Global Const $CV_IMWRITE_PNG_STRATEGY_HUFFMAN_ONLY =2
Global Const $CV_IMWRITE_PNG_STRATEGY_RLE =3
Global Const $CV_IMWRITE_PNG_STRATEGY_FIXED =4
Global Const $CV_IMWRITE_PXM_BINARY =32

; cvConvertImage flip types
Global Const $CV_CVTIMG_FLIP      =1
Global Const $CV_CVTIMG_SWAP_RB   =2

; compare operation
Global Const $CV_CMP_EQ   =0
Global Const $CV_CMP_GT   =1
Global Const $CV_CMP_GE   =2
Global Const $CV_CMP_LT   =3
Global Const $CV_CMP_LE   =4
Global Const $CV_CMP_NE   =5

; cvSort flags
Global Const $CV_SORT_EVERY_ROW =0
Global Const $CV_SORT_EVERY_COLUMN =1
Global Const $CV_SORT_ASCENDING =0
Global Const $CV_SORT_DESCENDING =16

;/* types of array norm */
Global Const $CV_C            =1
Global Const $CV_L1           =2
Global Const $CV_L2           =4
Global Const $CV_NORM_MASK    =7
Global Const $CV_RELATIVE     =8
Global Const $CV_DIFF         =16
Global Const $CV_MINMAX       =32

Global Const $CV_DIFF_C       =(BitOR($CV_DIFF , $CV_C))
Global Const $CV_DIFF_L1      =(BitOR($CV_DIFF , $CV_L1))
Global Const $CV_DIFF_L2      =(BitOR($CV_DIFF , $CV_L2))
Global Const $CV_RELATIVE_C   =(BitOR($CV_RELATIVE , $CV_C))
Global Const $CV_RELATIVE_L1  =(BitOR($CV_RELATIVE , $CV_L1))
Global Const $CV_RELATIVE_L2  =(BitOR($CV_RELATIVE , $CV_L2))

;/*********************************** CPU capabilities ***********************************/

Global Const $CV_CPU_NONE    =0
Global Const $CV_CPU_MMX     =1
Global Const $CV_CPU_SSE     =2
Global Const $CV_CPU_SSE2    =3
Global Const $CV_CPU_SSE3    =4
Global Const $CV_CPU_SSSE3   =5
Global Const $CV_CPU_SSE4_1  =6
Global Const $CV_CPU_SSE4_2  =7
Global Const $CV_CPU_POPCNT  =8
Global Const $CV_CPU_AVX    =10
Global Const $CV_HARDWARE_MAX_FEATURE =255

; cvFindChessBoard flag

Global Const $CV_CALIB_CB_ADAPTIVE_THRESH  =1
Global Const $CV_CALIB_CB_NORMALIZE_IMAGE  =2
Global Const $CV_CALIB_CB_FILTER_QUADS     =4
Global Const $CV_CALIB_CB_FAST_CHECK       =8

Global Const $CV_CALIB_USE_INTRINSIC_GUESS  =1
Global Const $CV_CALIB_FIX_ASPECT_RATIO     =2
Global Const $CV_CALIB_FIX_PRINCIPAL_POINT  =4
Global Const $CV_CALIB_ZERO_TANGENT_DIST    =8
Global Const $CV_CALIB_FIX_FOCAL_LENGTH =16
Global Const $CV_CALIB_FIX_K1  =32
Global Const $CV_CALIB_FIX_K2  =64
Global Const $CV_CALIB_FIX_K3  =128
Global Const $CV_CALIB_FIX_K4  =2048
Global Const $CV_CALIB_FIX_K5  =4096
Global Const $CV_CALIB_FIX_K6  =8192
Global Const $CV_CALIB_RATIONAL_MODEL =16384

;/* Filters used in pyramid decomposition */

Global Const $CV_GAUSSIAN_5x5 = 7

;/* Special filters */


Global Const $CV_SCHARR =-1
Global Const $CV_MAX_SOBEL_KSIZE =7

;/* Constants for color conversion */


Global Const $CV_BGR2BGRA    =0
Global Const $CV_RGB2RGBA    = $CV_BGR2BGRA

Global Const $CV_BGRA2BGR    =1
Global Const $CV_RGBA2RGB    = $CV_BGRA2BGR

Global Const $CV_BGR2RGBA    =2
Global Const $CV_RGB2BGRA    = $CV_BGR2RGBA

Global Const $CV_RGBA2BGR    =3
Global Const $CV_BGRA2RGB    = $CV_RGBA2BGR

Global Const $CV_BGR2RGB     =4
Global Const $CV_RGB2BGR     = $CV_BGR2RGB

Global Const $CV_BGRA2RGBA   =5
Global Const $CV_RGBA2BGRA   = $CV_BGRA2RGBA

Global Const $CV_BGR2GRAY    =6
Global Const $CV_RGB2GRAY    =7
Global Const $CV_GRAY2BGR    =8
Global Const $CV_GRAY2RGB    = $CV_GRAY2BGR
Global Const $CV_GRAY2BGRA   =9
Global Const $CV_GRAY2RGBA   = $CV_GRAY2BGRA
Global Const $CV_BGRA2GRAY   =10
Global Const $CV_RGBA2GRAY   =11

Global Const $CV_BGR2BGR565  =12
Global Const $CV_RGB2BGR565  =13
Global Const $CV_BGR5652BGR  =14
Global Const $CV_BGR5652RGB  =15
Global Const $CV_BGRA2BGR565 =16
Global Const $CV_RGBA2BGR565 =17
Global Const $CV_BGR5652BGRA =18
Global Const $CV_BGR5652RGBA =19

Global Const $CV_GRAY2BGR565 =20
Global Const $CV_BGR5652GRAY =21

Global Const $CV_BGR2BGR555  =22
Global Const $CV_RGB2BGR555  =23
Global Const $CV_BGR5552BGR  =24
Global Const $CV_BGR5552RGB  =25
Global Const $CV_BGRA2BGR555 =26
Global Const $CV_RGBA2BGR555 =27
Global Const $CV_BGR5552BGRA =28
Global Const $CV_BGR5552RGBA =29

Global Const $CV_GRAY2BGR555 =30
Global Const $CV_BGR5552GRAY =31

Global Const $CV_BGR2XYZ     =32
Global Const $CV_RGB2XYZ     =33
Global Const $CV_XYZ2BGR     =34
Global Const $CV_XYZ2RGB     =35

Global Const $CV_BGR2YCrCb   =36
Global Const $CV_RGB2YCrCb   =37
Global Const $CV_YCrCb2BGR   =38
Global Const $CV_YCrCb2RGB   =39

Global Const $CV_BGR2HSV     =40
Global Const $CV_RGB2HSV     =41

Global Const $CV_BGR2Lab     =44
Global Const $CV_RGB2Lab     =45

Global Const $CV_BayerBG2BGR =46
Global Const $CV_BayerGB2BGR =47
Global Const $CV_BayerRG2BGR =48
Global Const $CV_BayerGR2BGR =49

Global Const $CV_BayerBG2RGB = $CV_BayerRG2BGR
Global Const $CV_BayerGB2RGB = $CV_BayerGR2BGR
Global Const $CV_BayerRG2RGB = $CV_BayerBG2BGR
Global Const $CV_BayerGR2RGB = $CV_BayerGB2BGR

Global Const $CV_BGR2Luv     =50
Global Const $CV_RGB2Luv     =51
Global Const $CV_BGR2HLS     =52
Global Const $CV_RGB2HLS     =53

Global Const $CV_HSV2BGR     =54
Global Const $CV_HSV2RGB     =55

Global Const $CV_Lab2BGR     =56
Global Const $CV_Lab2RGB     =57
Global Const $CV_Luv2BGR     =58
Global Const $CV_Luv2RGB     =59
Global Const $CV_HLS2BGR     =60
Global Const $CV_HLS2RGB     =61

Global Const $CV_BayerBG2BGR_VNG =62
Global Const $CV_BayerGB2BGR_VNG =63
Global Const $CV_BayerRG2BGR_VNG =64
Global Const $CV_BayerGR2BGR_VNG =65

Global Const $CV_BayerBG2RGB_VNG = $CV_BayerRG2BGR_VNG
Global Const $CV_BayerGB2RGB_VNG = $CV_BayerGR2BGR_VNG
Global Const $CV_BayerRG2RGB_VNG = $CV_BayerBG2BGR_VNG
Global Const $CV_BayerGR2RGB_VNG = $CV_BayerGB2BGR_VNG

Global Const $CV_BGR2HSV_FULL = 66
Global Const $CV_RGB2HSV_FULL = 67
Global Const $CV_BGR2HLS_FULL = 68
Global Const $CV_RGB2HLS_FULL = 69

Global Const $CV_HSV2BGR_FULL = 70
Global Const $CV_HSV2RGB_FULL = 71
Global Const $CV_HLS2BGR_FULL = 72
Global Const $CV_HLS2RGB_FULL = 73

Global Const $CV_LBGR2Lab     = 74
Global Const $CV_LRGB2Lab     = 75
Global Const $CV_LBGR2Luv     = 76
Global Const $CV_LRGB2Luv     = 77

Global Const $CV_Lab2LBGR     = 78
Global Const $CV_Lab2LRGB     = 79
Global Const $CV_Luv2LBGR     = 80
Global Const $CV_Luv2LRGB     = 81

Global Const $CV_BGR2YUV      = 82
Global Const $CV_RGB2YUV      = 83
Global Const $CV_YUV2BGR      = 84
Global Const $CV_YUV2RGB      = 85

Global Const $CV_BayerBG2GRAY = 86
Global Const $CV_BayerGB2GRAY = 87
Global Const $CV_BayerRG2GRAY = 88
Global Const $CV_BayerGR2GRAY = 89

;    //YUV 4:2:0 formats family
Global Const $CV_YUV2RGB_NV12 = 90
Global Const $CV_YUV2BGR_NV12 = 91
Global Const $CV_YUV2RGB_NV21 = 92
Global Const $CV_YUV2BGR_NV21 = 93
Global Const $CV_YUV420sp2RGB = $CV_YUV2RGB_NV21
Global Const $CV_YUV420sp2BGR = $CV_YUV2BGR_NV21

Global Const $CV_YUV2RGBA_NV12 = 94
Global Const $CV_YUV2BGRA_NV12 = 95
Global Const $CV_YUV2RGBA_NV21 = 96
Global Const $CV_YUV2BGRA_NV21 = 97
Global Const $CV_YUV420sp2RGBA = $CV_YUV2RGBA_NV21
Global Const $CV_YUV420sp2BGRA = $CV_YUV2BGRA_NV21

Global Const $CV_YUV2RGB_YV12 = 98
Global Const $CV_YUV2BGR_YV12 = 99
Global Const $CV_YUV2RGB_IYUV = 100
Global Const $CV_YUV2BGR_IYUV = 101
Global Const $CV_YUV2RGB_I420 = $CV_YUV2RGB_IYUV
Global Const $CV_YUV2BGR_I420 = $CV_YUV2BGR_IYUV
Global Const $CV_YUV420p2RGB = $CV_YUV2RGB_YV12
Global Const $CV_YUV420p2BGR = $CV_YUV2BGR_YV12

Global Const $CV_YUV2RGBA_YV12 = 102
Global Const $CV_YUV2BGRA_YV12 = 103
Global Const $CV_YUV2RGBA_IYUV = 104
Global Const $CV_YUV2BGRA_IYUV = 105
Global Const $CV_YUV2RGBA_I420 = $CV_YUV2RGBA_IYUV
Global Const $CV_YUV2BGRA_I420 = $CV_YUV2BGRA_IYUV
Global Const $CV_YUV420p2RGBA = $CV_YUV2RGBA_YV12
Global Const $CV_YUV420p2BGRA = $CV_YUV2BGRA_YV12

Global Const $CV_YUV2GRAY_420 = 106
Global Const $CV_YUV2GRAY_NV21 = $CV_YUV2GRAY_420
Global Const $CV_YUV2GRAY_NV12 = $CV_YUV2GRAY_420
Global Const $CV_YUV2GRAY_YV12 = $CV_YUV2GRAY_420
Global Const $CV_YUV2GRAY_IYUV = $CV_YUV2GRAY_420
Global Const $CV_YUV2GRAY_I420 = $CV_YUV2GRAY_420
Global Const $CV_YUV420sp2GRAY = $CV_YUV2GRAY_420
Global Const $CV_YUV420p2GRAY = $CV_YUV2GRAY_420

;    //YUV 4:2:2 formats family
Global Const $CV_YUV2RGB_UYVY = 107
Global Const $CV_YUV2BGR_UYVY = 108
;   //CV_YUV2RGB_VYUY = 109
;    //CV_YUV2BGR_VYUY = 110
Global Const $CV_YUV2RGB_Y422 = $CV_YUV2RGB_UYVY
Global Const $CV_YUV2BGR_Y422 = $CV_YUV2BGR_UYVY
Global Const $CV_YUV2RGB_UYNV = $CV_YUV2RGB_UYVY
Global Const $CV_YUV2BGR_UYNV = $CV_YUV2BGR_UYVY

Global Const $CV_YUV2RGBA_UYVY = 111
Global Const $CV_YUV2BGRA_UYVY = 112
;    //CV_YUV2RGBA_VYUY = 113
;    //CV_YUV2BGRA_VYUY = 114
Global Const $CV_YUV2RGBA_Y422 = $CV_YUV2RGBA_UYVY
Global Const $CV_YUV2BGRA_Y422 = $CV_YUV2BGRA_UYVY
Global Const $CV_YUV2RGBA_UYNV = $CV_YUV2RGBA_UYVY
Global Const $CV_YUV2BGRA_UYNV = $CV_YUV2BGRA_UYVY

Global Const $CV_YUV2RGB_YUY2 = 115
Global Const $CV_YUV2BGR_YUY2 = 116
Global Const $CV_YUV2RGB_YVYU = 117
Global Const $CV_YUV2BGR_YVYU = 118
Global Const $CV_YUV2RGB_YUYV = $CV_YUV2RGB_YUY2
Global Const $CV_YUV2BGR_YUYV = $CV_YUV2BGR_YUY2
Global Const $CV_YUV2RGB_YUNV = $CV_YUV2RGB_YUY2
Global Const $CV_YUV2BGR_YUNV = $CV_YUV2BGR_YUY2

Global Const $CV_YUV2RGBA_YUY2 = 119
Global Const $CV_YUV2BGRA_YUY2 = 120
Global Const $CV_YUV2RGBA_YVYU = 121
Global Const $CV_YUV2BGRA_YVYU = 122
Global Const $CV_YUV2RGBA_YUYV = $CV_YUV2RGBA_YUY2
Global Const $CV_YUV2BGRA_YUYV = $CV_YUV2BGRA_YUY2
Global Const $CV_YUV2RGBA_YUNV = $CV_YUV2RGBA_YUY2
Global Const $CV_YUV2BGRA_YUNV = $CV_YUV2BGRA_YUY2

Global Const $CV_YUV2GRAY_UYVY = 123
Global Const $CV_YUV2GRAY_YUY2 = 124
;    //CV_YUV2GRAY_VYUY = $CV_YUV2GRAY_UYVY
Global Const $CV_YUV2GRAY_Y422 = $CV_YUV2GRAY_UYVY
Global Const $CV_YUV2GRAY_UYNV = $CV_YUV2GRAY_UYVY
Global Const $CV_YUV2GRAY_YVYU = $CV_YUV2GRAY_YUY2
Global Const $CV_YUV2GRAY_YUYV = $CV_YUV2GRAY_YUY2
Global Const $CV_YUV2GRAY_YUNV = $CV_YUV2GRAY_YUY2

;    // alpha premultiplication
Global Const $CV_RGBA2mRGBA = 125
Global Const $CV_mRGBA2RGBA = 126

Global Const $CV_RGB2YUV_I420 = 127
Global Const $CV_BGR2YUV_I420 = 128
Global Const $CV_RGB2YUV_IYUV = $CV_RGB2YUV_I420
Global Const $CV_BGR2YUV_IYUV = $CV_BGR2YUV_I420

Global Const $CV_RGBA2YUV_I420 = 129
Global Const $CV_BGRA2YUV_I420 = 130
Global Const $CV_RGBA2YUV_IYUV = $CV_RGBA2YUV_I420
Global Const $CV_BGRA2YUV_IYUV = $CV_BGRA2YUV_I420
Global Const $CV_RGB2YUV_YV12  = 131
Global Const $CV_BGR2YUV_YV12  = 132
Global Const $CV_RGBA2YUV_YV12 = 133
Global Const $CV_BGRA2YUV_YV12 = 134

Global Const $CV_COLORCVT_MAX  = 135


;/* Sub-pixel interpolation methods */


Global Const $CV_INTER_NN        =0
Global Const $CV_INTER_LINEAR    =1
Global Const $CV_INTER_CUBIC     =2
Global Const $CV_INTER_AREA      =3
Global Const $CV_INTER_LANCZOS4  =4


;/* ... and other image warping flags */


Global Const $CV_WARP_FILL_OUTLIERS =8
Global Const $CV_WARP_INVERSE_MAP  =16


;/* Shapes of a structuring element for morphological operations */


Global Const $CV_SHAPE_RECT      =0
Global Const $CV_SHAPE_CROSS     =1
Global Const $CV_SHAPE_ELLIPSE   =2
Global Const $CV_SHAPE_CUSTOM    =100


;/* Morphological operations */


Global Const $CV_MOP_ERODE        =0
Global Const $CV_MOP_DILATE       =1
Global Const $CV_MOP_OPEN         =2
Global Const $CV_MOP_CLOSE        =3
Global Const $CV_MOP_GRADIENT     =4
Global Const $CV_MOP_TOPHAT       =5
Global Const $CV_MOP_BLACKHAT     =6

;/* Template matching methods */

Global Const $CV_TM_SQDIFF        =0
Global Const $CV_TM_SQDIFF_NORMED =1
Global Const $CV_TM_CCORR         =2
Global Const $CV_TM_CCORR_NORMED  =3
Global Const $CV_TM_CCOEFF        =4
Global Const $CV_TM_CCOEFF_NORMED =5

;/* Contour retrieval modes */

Global Const $CV_RETR_EXTERNAL=0
Global Const $CV_RETR_LIST=1
Global Const $CV_RETR_CCOMP=2
Global Const $CV_RETR_TREE=3
Global Const $CV_RETR_FLOODFILL=4

;/* Contour approximation methods */

Global Const $CV_CHAIN_CODE=0
Global Const $CV_CHAIN_APPROX_NONE=1
Global Const $CV_CHAIN_APPROX_SIMPLE=2
Global Const $CV_CHAIN_APPROX_TC89_L1=3
Global Const $CV_CHAIN_APPROX_TC89_KCOS=4
Global Const $CV_LINK_RUNS=5

;/* Histogram comparison methods */

Global Const $CV_COMP_CORREL        =0
Global Const $CV_COMP_CHISQR        =1
Global Const $CV_COMP_INTERSECT     =2
Global Const $CV_COMP_BHATTACHARYYA =3
Global Const $CV_COMP_HELLINGER     = $CV_COMP_BHATTACHARYYA

;/* Mask size for distance transform */

Global Const $CV_DIST_MASK_3   =3
Global Const $CV_DIST_MASK_5   =5
Global Const $CV_DIST_MASK_PRECISE =0

;/* Content of output label array: connected components or pixels */

Global Const $CV_DIST_LABEL_CCOMP = 0
Global Const $CV_DIST_LABEL_PIXEL = 1

;/* Distance types for Distance Transform and M-estimators */

Global Const $CV_DIST_USER    =-1  ;/* User defined distance */
Global Const $CV_DIST_L1      =1   ;/* distance = |x1-x2| + |y1-y2| */
Global Const $CV_DIST_L2      =2   ;/* the simple euclidean distance */
Global Const $CV_DIST_C       =3   ;/* distance = max(|x1-x2||y1-y2|) */
Global Const $CV_DIST_L12     =4   ;/* L1-L2 metric: distance = 2(sqrt(1+x*x/2) - 1)) */
Global Const $CV_DIST_FAIR    =5   ;/* distance = c^2(|x|/c-log(1+|x|/c)) c = 1.3998 */
Global Const $CV_DIST_WELSCH  =6   ;/* distance = c^2/2(1-exp(-(x/c)^2)) c = 2.9846 */
Global Const $CV_DIST_HUBER   =7    ;/* distance = |x|<c ? x^2/2 : c(|x|-c/2) c=1.345 */

;/* Threshold types */

Global Const $CV_THRESH_BINARY      =0  ;/* value = value > threshold ? max_value : 0       */
Global Const $CV_THRESH_BINARY_INV  =1  ;/* value = value > threshold ? 0 : max_value       */
Global Const $CV_THRESH_TRUNC       =2  ;/* value = value > threshold ? threshold : value   */
Global Const $CV_THRESH_TOZERO      =3  ;/* value = value > threshold ? value : 0           */
Global Const $CV_THRESH_TOZERO_INV  =4  ;/* value = value > threshold ? 0 : value           */
Global Const $CV_THRESH_MASK        =7
Global Const $CV_THRESH_OTSU        =8  ;/* use Otsu algorithm to choose the optimal threshold value;
                                        ;   combine the flag with one of the above CV_THRESH_* values */

;/* Adaptive threshold methods */

Global Const $CV_ADAPTIVE_THRESH_MEAN_C  =0
Global Const $CV_ADAPTIVE_THRESH_GAUSSIAN_C  =1

;/* FloodFill flags */

Global Const $CV_FLOODFILL_FIXED_RANGE = BitShift(1, -16);
Global Const $CV_FLOODFILL_MASK_ONLY   = BitShift(1, -17)

;/* Variants of a Hough transform */

Global Const $CV_HOUGH_STANDARD =0
Global Const $CV_HOUGH_PROBABILISTIC =1
Global Const $CV_HOUGH_MULTI_SCALE =2
Global Const $CV_HOUGH_GRADIENT =3

;/* For font */
Global Const $CV_FONT_LIGHT           = 25 ;//QFont::Light,
Global Const $CV_FONT_NORMAL          = 50 ;//QFont::Normal,
Global Const $CV_FONT_DEMIBOLD        = 63 ;//QFont::DemiBold,
Global Const $CV_FONT_BOLD            = 75 ;//QFont::Bold,
Global Const $CV_FONT_BLACK           = 87 ;//QFont::Black

Global Const $CV_STYLE_NORMAL         = 0 ;//QFont::StyleNormal,
Global Const $CV_STYLE_ITALIC         = 1 ;//QFont::StyleItalic,
Global Const $CV_STYLE_OBLIQUE        = 2 ;//QFont::StyleOblique

; type of button
Global Const $CV_PUSH_BUTTON = 0
Global Const $CV_CHECKBOX = 1
Global Const $CV_RADIOBOX = 2

Global Const $CV_TERMCRIT_ITER    =1
Global Const $CV_TERMCRIT_NUMBER  =$CV_TERMCRIT_ITER
Global Const $CV_TERMCRIT_EPS     =2

;/* Contour approximation algorithms */

Global Const $CV_POLY_APPROX_DP = 0

; ===============================================================================================================================

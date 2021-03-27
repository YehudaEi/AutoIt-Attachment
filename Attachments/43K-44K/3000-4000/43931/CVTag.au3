#include-once

; #INDEX# =======================================================================================================================
; Title .........: CVTag
; AutoIt Version : 3.3.10.2
; Language ......: English
; Description ...: Tags for OpenCV
; Author(s) .....: Mylise
; ===============================================================================================================================
;
; Local $v"name of variable" = DllStructCreate($tag"name of tag")
; use --> DllStructSetData($v"name of variable", "item# or name of item" , value)
;
; use --> Local $p"name of variable" = DllStructGetPtr($v"name of variable")
; use in DLLcall --> "ptr", $p"name of variable"
;
; Local $v"name of variable" = DllStructCreate($tag"name of tag", pointer of "variable")
; use --> Local value = DllStructGetData($v"name of variable", "item# or name of item")
;

; #Tags# ======================================================================================================================

Global $tagchar = _
   "char name[40];"

Global $tagIplImage = _
    "int  nSize;" & _             ;/* sizeof(IplImage) */
    "int  ID;" & _             ;                /* version (=0)*/
    "int  nChannels;" & _             ;         /* Most of OpenCV functions support 1,2,3 or 4 channels */
    "int  alphaChannel;" & _             ;      /* Ignored by OpenCV */
    "int  depth;" & _             ;             /* Pixel depth in bits: IPL_DEPTH_8U, IPL_DEPTH_8S, IPL_DEPTH_16S, IPL_DEPTH_32S, IPL_DEPTH_32F and IPL_DEPTH_64F are supported.  */
    "byte colorModel[4];" & _             ;     /* Ignored by OpenCV */
    "byte channelSeq[4];" & _             ;     /* ditto */
    "int  dataOrder;" & _             ;         /* 0 - interleaved color channels, 1 - separate color channels.cvCreateImage can only create interleaved images */
    "int  origin;" & _             ;            /* 0 - top-left origin,1 - bottom-left origin (Windows bitmaps style).  */
    "int  align;" & _             ;             /* Alignment of image rows (4 or 8). OpenCV ignores it and uses widthStep instead.    */
    "int  width;" & _             ;             /* Image width in pixels.                           */
    "int  height;" & _             ;            /* Image height in pixels.                          */
    "ptr IplROI;" & _             ;    /* Image ROI. If NULL, the whole image is selected. */
    "ptr maskROI;" & _             ;      /* Must be NULL. */
    "ptr  imageId;" & _             ;                 /* "           " */
    "ptr tileInfo;" & _             ;  /* "           " */
    "int  imageSize;" & _             ;         /* Image data size in bytes (==image->height*image->widthStep in case of interleaved data)*/
    "ptr imageData;" & _             ;        /* Pointer to aligned image data.         */
    "int  widthStep;" & _             ;         /* Size of aligned image row in bytes.    */
    "int  BorderMode[4];" & _             ;     /* Ignored by OpenCV.                     */
    "int  BorderConst[4];" & _             ;    /* Ditto.                                 */
    "ptr imageDataOrigin;"             ;  /* Pointer to very origin of image data (not necessarily aligned) - needed for correct deallocation */

Global $tagIplROI = _
    "int  coi;" & _             ; /* 0 - no COI (all channels are selected), 1 - 0th channel is selected ...*/
    "int  xOffset;" & _
    "int  yOffset;" & _
    "int  width;" & _
    "int  height;"

Global $tagCvRect = _
    "int x;" & _
    "int y;" & _
    "int width;" & _
    "int height;"

Global $tagCvPoint = _
    "int x;" & _
    "int y;"

Global $tagCvPoint2D32f = _
    "float x;" & _
    "float y;"

Global $tagCvPoint3D32f = _
    "float x;" & _
    "float y;" & _
    "float z;"

Global $tagCvPoint2D64f = _
    "double x;" & _
    "double y;"

Global $tagCvPoint3D64f = _
    "double x;" & _
    "double y;" & _
    "double z;"

Global $tagCvSize = _
    "int width;" & _
    "int height;"

Global $tagCvSize2D32f = _
    "float width;" & _
    "float height;"

Global $tagCvBox2D = _
    "float x;" & _              ;/* Center of the box.      */
    "float y;"	& _
    "float width;" & _          ;/* Box width and length.      */
    "float height;"	& _
    "float angle;"              ;/* Angle between the horizontal axis     */
                                ;/* and the first side (i.e. length) in degrees */

Global $tagCvScalar = _
    "double val1;" & _
	"double val2;" & _
	"double val3;" & _
	"double val4;"


Global $tagCvTermCriteria = _
    "int type;" & _      ;  /* may be combination of CV_TERMCRIT_ITER CV_TERMCRIT_EPS */
    "int max_iter;" & _
    "double epsilon;"

Global $tagCvMat = _
    "int type;" & _            ; should and with 0xFF to get type value
	"int step;" & _
	"int u1;" & _
	"int u2;" & _
	"ptr data;" & _
	"int rows;" & _
	"int cols;"

Global $tagCvSeq = _
    "int flags;" & _ ;sequence flags, including the sequence signature (CV_SEQ_MAGIC_VAL or CV_SET_MAGIC_VAL), type of the elements and some other information about the sequence.
    "int header_size;" & _ ;size of the sequence header. It should be sizeof(CvSeq) at minimum. See CreateSeq().
    "ptr h_next;" & _
	"ptr h_prev;" & _
	"ptr v_next;" & _
	"ptr v_prev;" & _ ;pointers to another sequences in a sequence tree. Sequence trees are used to store hierarchical contour structures, retrieved by FindContours()
    "int total;" & _ ;the number of sequence elements
    "int elem_size;" & _ ;size of each sequence element in bytes
    "ptr block_max;" & _ ;memory storage where the sequence resides. It can be a NULL pointer.
    "ptr w_ptr;" & _;pointer to the first data block
    "int delta_elems;" & _
    "ptr storage;" & _
    "ptr free_blocks;" & _
    "ptr first;" & _
	"int padding1;" & _
	"int padding2;"

Global $tagCvContour = _
    "int flags;" & _ ;sequence flags, including the sequence signature (CV_SEQ_MAGIC_VAL or CV_SET_MAGIC_VAL), type of the elements and some other information about the sequence.
    "int header_size;" & _ ;size of the sequence header. It should be sizeof(CvSeq) at minimum. See CreateSeq().
    "ptr h_next;" & _
	"ptr h_prev;" & _
	"ptr v_next;" & _
	"ptr v_prev;" & _ ;pointers to another sequences in a sequence tree. Sequence trees are used to store hierarchical contour structures, retrieved by FindContours()
    "int total;" & _ ;the number of sequence elements
    "int elem_size;" & _ ;size of each sequence element in bytes
    "ptr block_max;" & _ ;memory storage where the sequence resides. It can be a NULL pointer.
    "ptr w_ptr;" & _;pointer to the first data block
    "int delta_elems;" & _
    "ptr storage;" & _
    "ptr free_blocks;" & _
    "ptr first;" & _
    "int x;" & _
    "int y;" & _
    "int width;" & _
    "int height;" & _
	"int color;" & _
	"int reserved1;" & _
	"int reserved2;" & _
	"int reserved3;" & _
    "int padding1;" & _
	"int padding2;"

Global $tagCvSeqBlock = _
    "ptr next;" & _
    "ptr prev;" & _
    "int start_index;" & _
    "int count;" & _ ;the number of sequence elements
    "ptr data;" & _ ;memory storage where the sequence resides. It can be a NULL pointer.
    "int delimiter;" ;pointer to the first data block

Global $tagCvSlice = _
    "int start_index;" & _
    "int end_index;"

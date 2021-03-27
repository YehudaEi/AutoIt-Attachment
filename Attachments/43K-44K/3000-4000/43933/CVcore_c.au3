#include-once

; #INDEX# =======================================================================================================================
; Title .........: CVcore
; AutoIt Version : 3.3.10.2
; Language ......: English
; Description ...: Functions that assist with OpenCV
;                  It enables applications to use OpenCV core library functions.
; Author ........: Mylise
; Modified ......:
; Dll ...........: opencv_core245.dll
; ===============================================================================================================================


;------------------------------------------------
;/*
;CVAPI(void*)  cvAlloc( size_t size );
;
;
Func _cvAlloc( $cvsize )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvAlloc" , "Int" , $cvsize )
If @error Then ConsoleWrite( "error in cvAlloc")

Return $_aResult[0]
EndFunc ;==>_cvAlloc


;------------------------------------------------
;/*
;CVAPI(void)   cvFree_( void* ptr );
;
;
Func _cvFree_( $cvptr )

DllCall($_opencv_core , "none:cdecl" , "cvFree_" , "ptr*" , $cvptr )
If @error Then ConsoleWrite( "error in cvFree_")

Return
EndFunc ;==>_cvFree_


;------------------------------------------------
;/*
;CVAPI(IplImage*)  cvCreateImageHeader( CvSize size, int depth, int channels );
;
;
Func _cvCreateImageHeader( $cvsize , $cvdepth , $cvchannels )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvCreateImageHeader" , "struct" , $cvsize , "int" , $cvdepth , "int" , $cvchannels )
If @error Then ConsoleWrite( "error in cvCreateImageHeader")

Return $_aResult[0]
EndFunc ;==>_cvCreateImageHeader


;------------------------------------------------
;/*
;CVAPI(void)  cvReleaseImageHeader( IplImage** image );
;
;
Func _cvReleaseImageHeader( $cvimage )

DllCall($_opencv_core , "none:cdecl" , "cvReleaseImageHeader" , "ptr*" , $cvimage )
If @error Then ConsoleWrite( "error in cvReleaseImageHeader")

Return
EndFunc ;==>_cvReleaseImageHeader


;------------------------------------------------
;/*
;CVAPI(void)  cvSetImageCOI( IplImage* image, int coi );
;
;
Func _cvSetImageCOI( $cvimage , $cvcoi )

DllCall($_opencv_core , "none:cdecl" , "cvSetImageCOI" , "ptr" , $cvimage , "int" , $cvcoi )
If @error Then ConsoleWrite( "error in cvSetImageCOI")

Return
EndFunc ;==>_cvSetImageCOI


;------------------------------------------------
;/*
;CVAPI(int)  cvGetImageCOI( const IplImage* image );
;
;
Func _cvGetImageCOI( $cvimage )

local $_aResult = DllCall($_opencv_core , "int:cdecl" , "cvGetImageCOI" , "ptr" , $cvimage )
If @error Then ConsoleWrite( "error in cvGetImageCOI")

Return $_aResult[0]
EndFunc ;==>_cvGetImageCOI


;------------------------------------------------
;/*
;CVAPI(CvMat*)  cvCreateMatHeader( int rows, int cols, int type );
;
;
Func _cvCreateMatHeader( $cvrows , $cvcols , $cvtype )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvCreateMatHeader" , "int" , $cvrows , "int" , $cvcols , "int" , $cvtype )
If @error Then ConsoleWrite( "error in cvCreateMatHeader")

Return $_aResult[0]
EndFunc ;==>_cvCreateMatHeader


;------------------------------------------------
;/*
;CVAPI(CvMat*) cvCloneMat( const CvMat* mat );
;
;
Func _cvCloneMat( $cvmat )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvCloneMat" , "ptr" , $cvmat )
If @error Then ConsoleWrite( "error in cvCloneMat")

Return $_aResult[0]
EndFunc ;==>_cvCloneMat


;------------------------------------------------
;/*
;CVAPI(CvMat*) cvGetSubRect( const CvArr* arr, CvMat* submat, CvRect rect );
;
;
Func _cvGetSubRect( $cvarr , $cvsubmat , $cvrect )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvGetSubRect" , "ptr" , $cvarr , "ptr" , $cvsubmat , "struct" , $cvrect )
If @error Then ConsoleWrite( "error in cvGetSubRect")

Return $_aResult[0]
EndFunc ;==>_cvGetSubRect


;------------------------------------------------
;/*
;CVAPI(CvMat*) cvGetRows( const CvArr* arr, CvMat* submat, int start_row, int end_row, int delta_row CV_DEFAULT(1));
;
;
Func _cvGetRows( $cvarr , $cvsubmat , $cvstart_row , $cvend_row , $cvdelta_row = 1 )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvGetRows" , "ptr" , $cvarr , "ptr" , $cvsubmat , "int" , $cvstart_row , "int" , $cvend_row , "int" , $cvdelta_row )
If @error Then ConsoleWrite( "error in cvGetRows")

Return $_aResult[0]
EndFunc ;==>_cvGetRows


;------------------------------------------------
;/*
;CVAPI(CvMat*) cvGetCols( const CvArr* arr, CvMat* submat, int start_col, int end_col );
;
;
Func _cvGetCols( $cvarr , $cvsubmat , $cvstart_col , $cvend_col )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvGetCols" , "ptr" , $cvarr , "ptr" , $cvsubmat , "int" , $cvstart_col , "int" , $cvend_col )
If @error Then ConsoleWrite( "error in cvGetCols")

Return $_aResult[0]
EndFunc ;==>_cvGetCols


;------------------------------------------------
;/*
;CVAPI(CvMat*) cvGetDiag( const CvArr* arr, CvMat* submat, int diag CV_DEFAULT(0));
;
;
Func _cvGetDiag( $cvarr , $cvsubmat , $cvdiag = 0 )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvGetDiag" , "ptr" , $cvarr , "ptr" , $cvsubmat , "int" , $cvdiag )
If @error Then ConsoleWrite( "error in cvGetDiag")

Return $_aResult[0]
EndFunc ;==>_cvGetDiag


;------------------------------------------------
;/*
;CVAPI(void) cvScalarToRawData( const CvScalar* scalar, void* data, int type, int extend_to_12 CV_DEFAULT(0) );
;
;
Func _cvScalarToRawData( $cvscalar , $cvdata , $cvtype , $cvextend_to_12 = 0 )

DllCall($_opencv_core , "none:cdecl" , "cvScalarToRawData" , "ptr" , $cvscalar , "ptr" , $cvdata , "int" , $cvtype , "int" , $cvextend_to_12 )
If @error Then ConsoleWrite( "error in cvScalarToRawData")

Return
EndFunc ;==>_cvScalarToRawData


;------------------------------------------------
;/*
;CVAPI(void) cvRawDataToScalar( const void* data, int type, CvScalar* scalar );
;
;
Func _cvRawDataToScalar( $cvdata , $cvtype , $cvscalar )

DllCall($_opencv_core , "none:cdecl" , "cvRawDataToScalar" , "ptr" , $cvdata , "int" , $cvtype , "ptr" , $cvscalar )
If @error Then ConsoleWrite( "error in cvRawDataToScalar")

Return
EndFunc ;==>_cvRawDataToScalar


;------------------------------------------------
;/*
;CVAPI(CvMatND*)  cvCreateMatNDHeader( int dims, const int* sizes, int type );
;
;
Func _cvCreateMatNDHeader( $cvdims , $cvsizes , $cvtype )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvCreateMatNDHeader" , "int" , $cvdims , "ptr" , $cvsizes , "int" , $cvtype )
If @error Then ConsoleWrite( "error in cvCreateMatNDHeader")

Return $_aResult[0]
EndFunc ;==>_cvCreateMatNDHeader


;------------------------------------------------
;/*
;CVAPI(CvMatND*)  cvCreateMatND( int dims, const int* sizes, int type );
;
;
Func _cvCreateMatND( $cvdims , $cvsizes , $cvtype )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvCreateMatND" , "int" , $cvdims , "ptr" , $cvsizes , "int" , $cvtype )
If @error Then ConsoleWrite( "error in cvCreateMatND")

Return $_aResult[0]
EndFunc ;==>_cvCreateMatND


;------------------------------------------------
;/*
;CVAPI(CvMatND*)  cvInitMatNDHeader( CvMatND* mat, int dims, const int* sizes, int type, void* data CV_DEFAULT(NULL) );
;
;
Func _cvInitMatNDHeader( $cvmat , $cvdims , $cvsizes , $cvtype , $cvdata = Null)

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvInitMatNDHeader" , "ptr" , $cvmat , "int" , $cvdims , "ptr" , $cvsizes , "int" , $cvtype , "ptr" , $cvdata )
If @error Then ConsoleWrite( "error in cvInitMatNDHeader")

Return $_aResult[0]
EndFunc ;==>_cvInitMatNDHeader


;------------------------------------------------
;/*
;CVAPI(CvMatND*) cvCloneMatND( const CvMatND* mat );
;
;
Func _cvCloneMatND( $cvmat )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvCloneMatND" , "ptr" , $cvmat )
If @error Then ConsoleWrite( "error in cvCloneMatND")

Return $_aResult[0]
EndFunc ;==>_cvCloneMatND


;------------------------------------------------
;/*
;CVAPI(CvSparseMat*)  cvCreateSparseMat( int dims, const int* sizes, int type );
;
;
Func _cvCreateSparseMat( $cvdims , $cvsizes , $cvtype )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvCreateSparseMat" , "int" , $cvdims , "ptr" , $cvsizes , "int" , $cvtype )
If @error Then ConsoleWrite( "error in cvCreateSparseMat")

Return $_aResult[0]
EndFunc ;==>_cvCreateSparseMat


;------------------------------------------------
;/*
;CVAPI(void)  cvReleaseSparseMat( CvSparseMat** mat );
;
;
Func _cvReleaseSparseMat( $cvmat )

DllCall($_opencv_core , "none:cdecl" , "cvReleaseSparseMat" , "ptr*" , $cvmat )
If @error Then ConsoleWrite( "error in cvReleaseSparseMat")

Return
EndFunc ;==>_cvReleaseSparseMat


;------------------------------------------------
;/*
;CVAPI(CvSparseMat*) cvCloneSparseMat( const CvSparseMat* mat );
;
;
Func _cvCloneSparseMat( $cvmat )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvCloneSparseMat" , "ptr" , $cvmat )
If @error Then ConsoleWrite( "error in cvCloneSparseMat")

Return $_aResult[0]
EndFunc ;==>_cvCloneSparseMat


;------------------------------------------------
;/*
;CVAPI(CvSparseNode*) cvInitSparseMatIterator( const CvSparseMat* mat, CvSparseMatIterator* mat_iterator );
;
;
Func _cvInitSparseMatIterator( $cvmat , $cvmat_iterator )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvInitSparseMatIterator" , "ptr" , $cvmat , "ptr" , $cvmat_iterator )
If @error Then ConsoleWrite( "error in cvInitSparseMatIterator")

Return $_aResult[0]
EndFunc ;==>_cvInitSparseMatIterator


;------------------------------------------------
;/*
;CVAPI(int) cvInitNArrayIterator( int count, CvArr** arrs, const CvArr* mask, CvMatND* stubs, CvNArrayIterator* array_iterator, int flags CV_DEFAULT(0) );
;
;
Func _cvInitNArrayIterator( $cvcount , $cvarrs , $cvmask , $cvstubs , $cvarray_iterator , $cvflags )

local $_aResult = DllCall($_opencv_core , "int:cdecl" , "cvInitNArrayIterator" , "int" , $cvcount , "ptr*" , $cvarrs , "ptr" , $cvmask , "ptr" , $cvstubs , "ptr" , $cvarray_iterator , "int" , $cvflags )
If @error Then ConsoleWrite( "error in cvInitNArrayIterator")

Return $_aResult[0]
EndFunc ;==>_cvInitNArrayIterator


;------------------------------------------------
;/*
;CVAPI(int) cvNextNArraySlice( CvNArrayIterator* array_iterator );
;
;
Func _cvNextNArraySlice( $cvarray_iterator )

local $_aResult = DllCall($_opencv_core , "int:cdecl" , "cvNextNArraySlice" , "ptr" , $cvarray_iterator )
If @error Then ConsoleWrite( "error in cvNextNArraySlice")

Return $_aResult[0]
EndFunc ;==>_cvNextNArraySlice


;------------------------------------------------
;/*
;CVAPI(int) cvGetElemType( const CvArr* arr );
;
;
Func _cvGetElemType( $cvarr )

local $_aResult = DllCall($_opencv_core , "int:cdecl" , "cvGetElemType" , "ptr" , $cvarr )
If @error Then ConsoleWrite( "error in cvGetElemType")

Return $_aResult[0]
EndFunc ;==>_cvGetElemType


;------------------------------------------------
;/*
;CVAPI(int) cvGetDims( const CvArr* arr, int* sizes CV_DEFAULT(NULL) );
;
;
Func _cvGetDims( $cvarr , $cvsizes = Null)

local $_aResult = DllCall($_opencv_core , "int:cdecl" , "cvGetDims" , "ptr" , $cvarr , "ptr" , $cvsizes )
If @error Then ConsoleWrite( "error in cvGetDims")

Return $_aResult[0]
EndFunc ;==>_cvGetDims


;------------------------------------------------
;/*
;CVAPI(int) cvGetDimSize( const CvArr* arr, int index );
;
;
Func _cvGetDimSize( $cvarr , $cvindex )

local $_aResult = DllCall($_opencv_core , "int:cdecl" , "cvGetDimSize" , "ptr" , $cvarr , "int" , $cvindex )
If @error Then ConsoleWrite( "error in cvGetDimSize")

Return $_aResult[0]
EndFunc ;==>_cvGetDimSize


;------------------------------------------------
;/*
;CVAPI(uchar*) cvPtr1D( const CvArr* arr, int idx0, int* type CV_DEFAULT(NULL));
;
;
Func _cvPtr1D( $cvarr , $cvidx0 , $cvtype = Null )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvPtr1D" , "ptr" , $cvarr , "int" , $cvidx0 , "ptr" , $cvtype )
If @error Then ConsoleWrite( "error in cvPtr1D")

Return $_aResult[0]
EndFunc ;==>_cvPtr1D


;------------------------------------------------
;/*
;CVAPI(uchar*) cvPtr2D( const CvArr* arr, int idx0, int idx1, int* type CV_DEFAULT(NULL) );
;
;
Func _cvPtr2D( $cvarr , $cvidx0 , $cvidx1 , $cvtype = Null )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvPtr2D" , "ptr" , $cvarr , "int" , $cvidx0 , "int" , $cvidx1 , "ptr" , $cvtype )
If @error Then ConsoleWrite( "error in cvPtr2D")

Return $_aResult[0]
EndFunc ;==>_cvPtr2D


;------------------------------------------------
;/*
;CVAPI(uchar*) cvPtr3D( const CvArr* arr, int idx0, int idx1, int idx2, int* type CV_DEFAULT(NULL));
;
;
Func _cvPtr3D( $cvarr , $cvidx0 , $cvidx1 , $cvidx2 , $cvtype = Null )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvPtr3D" , "ptr" , $cvarr , "int" , $cvidx0 , "int" , $cvidx1 , "int" , $cvidx2 , "ptr" , $cvtype )
If @error Then ConsoleWrite( "error in cvPtr3D")

Return $_aResult[0]
EndFunc ;==>_cvPtr3D


;------------------------------------------------
;/*
;CVAPI(uchar*) cvPtrND( const CvArr* arr, const int* idx, int* type
;
;
Func _cvPtrND( $cvarr , $cvidx , $cvtype )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvPtrND" , "ptr" , $cvarr , "ptr" , $cvidx , "ptr" , $cvtype )
If @error Then ConsoleWrite( "error in cvPtrND")

Return $_aResult[0]
EndFunc ;==>_cvPtrND


;------------------------------------------------
;/*
;CVAPI(double) cvGetReal1D( const CvArr* arr, int idx0 );
;
;
Func _cvGetReal1D( $cvarr , $cvidx0 )

local $_aResult = DllCall($_opencv_core , "double:cdecl" , "cvGetReal1D" , "ptr" , $cvarr , "int" , $cvidx0 )
If @error Then ConsoleWrite( "error in cvGetReal1D")

Return $_aResult[0]
EndFunc ;==>_cvGetReal1D


;------------------------------------------------
;/*
;CVAPI(double) cvGetReal2D( const CvArr* arr, int idx0, int idx1 );
;
;
Func _cvGetReal2D( $cvarr , $cvidx0 , $cvidx1 )

local $_aResult = DllCall($_opencv_core , "double:cdecl" , "cvGetReal2D" , "ptr" , $cvarr , "int" , $cvidx0 , "int" , $cvidx1 )
If @error Then ConsoleWrite( "error in cvGetReal2D")

Return $_aResult[0]
EndFunc ;==>_cvGetReal2D


;------------------------------------------------
;/*
;CVAPI(double) cvGetReal3D( const CvArr* arr, int idx0, int idx1, int idx2 );
;
;
Func _cvGetReal3D( $cvarr , $cvidx0 , $cvidx1 , $cvidx2 )

local $_aResult = DllCall($_opencv_core , "double:cdecl" , "cvGetReal3D" , "ptr" , $cvarr , "int" , $cvidx0 , "int" , $cvidx1 , "int" , $cvidx2 )
If @error Then ConsoleWrite( "error in cvGetReal3D")

Return $_aResult[0]
EndFunc ;==>_cvGetReal3D


;------------------------------------------------
;/*
;CVAPI(double) cvGetRealND( const CvArr* arr, const int* idx );
;
;
Func _cvGetRealND( $cvarr , $cvidx )

local $_aResult = DllCall($_opencv_core , "double:cdecl" , "cvGetRealND" , "ptr" , $cvarr , "ptr" , $cvidx )
If @error Then ConsoleWrite( "error in cvGetRealND")

Return $_aResult[0]
EndFunc ;==>_cvGetRealND


;------------------------------------------------
;/*
;CVAPI(void) cvSet1D( CvArr* arr, int idx0, CvScalar value );
;
;
Func _cvSet1D( $cvarr , $cvidx0 , $cvvalue )

DllCall($_opencv_core , "none:cdecl" , "cvSet1D" , "ptr" , $cvarr , "int" , $cvidx0 , "struct" , $cvvalue )
If @error Then ConsoleWrite( "error in cvSet1D")

Return
EndFunc ;==>_cvSet1D


;------------------------------------------------
;/*
;CVAPI(void) cvSet3D( CvArr* arr, int idx0, int idx1, int idx2, CvScalar value );
;
;
Func _cvSet3D( $cvarr , $cvidx0 , $cvidx1 , $cvidx2 , $cvvalue )

DllCall($_opencv_core , "none:cdecl" , "cvSet3D" , "ptr" , $cvarr , "int" , $cvidx0 , "int" , $cvidx1 , "int" , $cvidx2 , "struct" , $cvvalue )
If @error Then ConsoleWrite( "error in cvSet3D")

Return
EndFunc ;==>_cvSet3D


;------------------------------------------------
;/*
;CVAPI(void) cvSetND( CvArr* arr, const int* idx, CvScalar value );
;
;
Func _cvSetND( $cvarr , $cvidx , $cvvalue )

DllCall($_opencv_core , "none:cdecl" , "cvSetND" , "ptr" , $cvarr , "ptr" , $cvidx , "struct" , $cvvalue )
If @error Then ConsoleWrite( "error in cvSetND")

Return
EndFunc ;==>_cvSetND


;------------------------------------------------
;/*
;CVAPI(void) cvSetReal1D( CvArr* arr, int idx0, double value );
;
;
Func _cvSetReal1D( $cvarr , $cvidx0 , $cvvalue )

DllCall($_opencv_core , "none:cdecl" , "cvSetReal1D" , "ptr" , $cvarr , "int" , $cvidx0 , "double" , $cvvalue )
If @error Then ConsoleWrite( "error in cvSetReal1D")

Return
EndFunc ;==>_cvSetReal1D


;------------------------------------------------
;/*
;CVAPI(void) cvSetReal2D( CvArr* arr, int idx0, int idx1, double value );
;
;
Func _cvSetReal2D( $cvarr , $cvidx0 , $cvidx1 , $cvvalue )

DllCall($_opencv_core , "none:cdecl" , "cvSetReal2D" , "ptr" , $cvarr , "int" , $cvidx0 , "int" , $cvidx1 , "double" , $cvvalue )
If @error Then ConsoleWrite( "error in cvSetReal2D")

Return
EndFunc ;==>_cvSetReal2D


;------------------------------------------------
;/*
;CVAPI(void) cvSetReal3D( CvArr* arr, int idx0, int idx1, int idx2, double value );
;
;
Func _cvSetReal3D( $cvarr , $cvidx0 , $cvidx1 , $cvidx2 , $cvvalue )

DllCall($_opencv_core , "none:cdecl" , "cvSetReal3D" , "ptr" , $cvarr , "int" , $cvidx0 , "int" , $cvidx1 , "int" , $cvidx2 , "double" , $cvvalue )
If @error Then ConsoleWrite( "error in cvSetReal3D")

Return
EndFunc ;==>_cvSetReal3D


;------------------------------------------------
;/*
;CVAPI(void) cvSetRealND( CvArr* arr, const int* idx, double value );
;
;
Func _cvSetRealND( $cvarr , $cvidx , $cvvalue )

DllCall($_opencv_core , "none:cdecl" , "cvSetRealND" , "ptr" , $cvarr , "ptr" , $cvidx , "double" , $cvvalue )
If @error Then ConsoleWrite( "error in cvSetRealND")

Return
EndFunc ;==>_cvSetRealND


;------------------------------------------------
;/*
;CVAPI(void) cvClearND( CvArr* arr, const int* idx );
;
;
Func _cvClearND( $cvarr , $cvidx )

DllCall($_opencv_core , "none:cdecl" , "cvClearND" , "ptr" , $cvarr , "ptr" , $cvidx )
If @error Then ConsoleWrite( "error in cvClearND")

Return
EndFunc ;==>_cvClearND


;------------------------------------------------
;/*
;CVAPI(CvMat*) cvGetMat( const CvArr* arr, CvMat* header, int* coi CV_DEFAULT(NULL), int allowND CV_DEFAULT(0));
;
;
Func _cvGetMat( $cvarr , $cvheader , $cvcoi = Null , $cvallowND = 0 )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvGetMat" , "ptr" , $cvarr , "ptr" , $cvheader , "ptr" , $cvcoi , "int" , $cvallowND )
If @error Then ConsoleWrite( "error in cvGetMat")

Return $_aResult[0]
EndFunc ;==>_cvGetMat


;------------------------------------------------
;/*
;CVAPI(IplImage*) cvGetImage( const CvArr* arr, IplImage* image_header );
;
;
Func _cvGetImage( $cvarr , $cvimage_header )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvGetImage" , "ptr" , $cvarr , "ptr" , $cvimage_header )
If @error Then ConsoleWrite( "error in cvGetImage")

Return $_aResult[0]
EndFunc ;==>_cvGetImage


;------------------------------------------------
;/*
;CVAPI(CvArr*) cvReshapeMatND( const CvArr* arr, int sizeof_header, CvArr* header, int new_cn, int new_dims, int* new_sizes );
;
;
Func _cvReshapeMatND( $cvarr , $cvsizeof_header , $cvheader , $cvnew_cn , $cvnew_dims , $cvnew_sizes )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvReshapeMatND" , "ptr" , $cvarr , "int" , $cvsizeof_header , "ptr" , $cvheader , "int" , $cvnew_cn , "int" , $cvnew_dims , "ptr" , $cvnew_sizes )
If @error Then ConsoleWrite( "error in cvReshapeMatND")

Return $_aResult[0]
EndFunc ;==>_cvReshapeMatND


;------------------------------------------------
;/*
;CVAPI(CvMat*) cvReshape( const CvArr* arr, CvMat* header, int new_cn, int new_rows CV_DEFAULT(0) );
;
;
Func _cvReshape( $cvarr , $cvheader , $cvnew_cn , $cvnew_rows )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvReshape" , "ptr" , $cvarr , "ptr" , $cvheader , "int" , $cvnew_cn , "int" , $cvnew_rows )
If @error Then ConsoleWrite( "error in cvReshape")

Return $_aResult[0]
EndFunc ;==>_cvReshape


;------------------------------------------------
;/*
;CVAPI(void) cvRepeat( const CvArr* src, CvArr* dst );
;
;
Func _cvRepeat( $cvsrc , $cvdst )

DllCall($_opencv_core , "none:cdecl" , "cvRepeat" , "ptr" , $cvsrc , "ptr" , $cvdst )
If @error Then ConsoleWrite( "error in cvRepeat")

Return
EndFunc ;==>_cvRepeat


;------------------------------------------------
;/*
;CVAPI(void)  cvCreateData( CvArr* arr );
;
;
Func _cvCreateData( $cvarr )

DllCall($_opencv_core , "none:cdecl" , "cvCreateData" , "ptr" , $cvarr )
If @error Then ConsoleWrite( "error in cvCreateData")

Return
EndFunc ;==>_cvCreateData


;------------------------------------------------
;/*
;CVAPI(void)  cvReleaseData( CvArr* arr );
;
;
Func _cvReleaseData( $cvarr )

DllCall($_opencv_core , "none:cdecl" , "cvReleaseData" , "ptr" , $cvarr )
If @error Then ConsoleWrite( "error in cvReleaseData")

Return
EndFunc ;==>_cvReleaseData


;------------------------------------------------
;/*
;CVAPI(void)  cvSetData( CvArr* arr, void* data, int step );
;
;
Func _cvSetData( $cvarr , $cvdata , $cvstep )

DllCall($_opencv_core , "none:cdecl" , "cvSetData" , "ptr" , $cvarr , "ptr" , $cvdata , "int" , $cvstep )
If @error Then ConsoleWrite( "error in cvSetData")

Return
EndFunc ;==>_cvSetData


;------------------------------------------------
;/*
;CVAPI(void) cvGetRawData( const CvArr* arr, uchar** data, int* step CV_DEFAULT(NULL), CvSize* roi_size CV_DEFAULT(NULL));
;
;
Func _cvGetRawData( $cvarr , $cvdata , $cvstep = Null , $cvroi_size = Null )

DllCall($_opencv_core , "none:cdecl" , "cvGetRawData" , "ptr" , $cvarr , "ptr*" , $cvdata , "ptr" , $cvstep , "ptr" , $cvroi_size )
If @error Then ConsoleWrite( "error in cvGetRawData")

Return
EndFunc ;==>_cvGetRawData


;------------------------------------------------
;/*
;CVAPI(void)  cvCopy( const CvArr* src, CvArr* dst, const CvArr* mask CV_DEFAULT(NULL) );
;
;
Func _cvCopy( $cvsrc , $cvdst , $cvmask = Null )

DllCall($_opencv_core , "none:cdecl" , "cvCopy" , "ptr" , $cvsrc , "ptr" , $cvdst , "ptr" , $cvmask )
If @error Then ConsoleWrite( "error in cvCopy")

Return
EndFunc ;==>_cvCopy


;------------------------------------------------
;/*
;CVAPI(void)  cvSet( CvArr* arr, CvScalar value, const CvArr* mask CV_DEFAULT(NULL) );
;
;
Func _cvSet( $cvarr , $cvvalue , $cvmask = Null)

DllCall($_opencv_core , "none:cdecl" , "cvSet" , "ptr" , $cvarr , "struct" , $cvvalue , "ptr" , $cvmask )
If @error Then ConsoleWrite( "error in cvSet")

Return
EndFunc ;==>_cvSet


;------------------------------------------------
;/*
;CVAPI(void)  cvSetZero( CvArr* arr );
;
;
Func _cvSetZero( $cvarr )

DllCall($_opencv_core , "none:cdecl" , "cvSetZero" , "ptr" , $cvarr )
If @error Then ConsoleWrite( "error in cvSetZero")

Return
EndFunc ;==>_cvSetZero


;------------------------------------------------
;/*
;CVAPI(void)  cvSplit( const CvArr* src, CvArr* dst0, CvArr* dst1, CvArr* dst2, CvArr* dst3 );
;
;
Func _cvSplit( $cvsrc , $cvdst0 , $cvdst1 , $cvdst2 , $cvdst3 )

DllCall($_opencv_core , "none:cdecl" , "cvSplit" , "ptr" , $cvsrc , "ptr" , $cvdst0 , "ptr" , $cvdst1 , "ptr" , $cvdst2 , "ptr" , $cvdst3 )
If @error Then ConsoleWrite( "error in cvSplit")

Return
EndFunc ;==>_cvSplit


;------------------------------------------------
;/*
;CVAPI(void)  cvMerge( const CvArr* src0, const CvArr* src1, const CvArr* src2, const CvArr* src3, CvArr* dst );
;
;
Func _cvMerge( $cvsrc0 , $cvsrc1 , $cvsrc2 , $cvsrc3 , $cvdst )

DllCall($_opencv_core , "none:cdecl" , "cvMerge" , "ptr" , $cvsrc0 , "ptr" , $cvsrc1 , "ptr" , $cvsrc2 , "ptr" , $cvsrc3 , "ptr" , $cvdst )
If @error Then ConsoleWrite( "error in cvMerge")

Return
EndFunc ;==>_cvMerge


;------------------------------------------------
;/*
;CVAPI(void)  cvMixChannels( const CvArr** src, int src_count, CvArr** dst, int dst_count, const int* from_to, int pair_count );
;
;
Func _cvMixChannels( $cvsrc , $cvsrc_count , $cvdst , $cvdst_count , $cvfrom_to , $cvpair_count )

DllCall($_opencv_core , "none:cdecl" , "cvMixChannels" , "ptr*" , $cvsrc , "int" , $cvsrc_count , "ptr*" , $cvdst , "int" , $cvdst_count , "ptr" , $cvfrom_to , "int" , $cvpair_count )
If @error Then ConsoleWrite( "error in cvMixChannels")

Return
EndFunc ;==>_cvMixChannels


;------------------------------------------------
;/*
;CVAPI(void)  cvConvertScale( const CvArr* src, CvArr* dst, double scale CV_DEFAULT(1), double shift CV_DEFAULT(0) );
;
;
Func _cvConvertScale( $cvsrc , $cvdst , $cvscale = 1 , $cvshift = 0)

DllCall($_opencv_core , "none:cdecl" , "cvConvertScale" , "ptr" , $cvsrc , "ptr" , $cvdst , "double" , $cvscale , "double" , $cvshift )
If @error Then ConsoleWrite( "error in cvConvertScale")

Return
EndFunc ;==>_cvConvertScale


;------------------------------------------------
;/*
;CVAPI(void)  cvConvertScaleAbs( const CvArr* src, CvArr* dst, double scale CV_DEFAULT(1), double shift CV_DEFAULT(0) );
;
;
Func _cvConvertScaleAbs( $cvsrc , $cvdst , $cvscale = 1 , $cvshift = 0 )

DllCall($_opencv_core , "none:cdecl" , "cvConvertScaleAbs" , "ptr" , $cvsrc , "ptr" , $cvdst , "double" , $cvscale , "double" , $cvshift )
If @error Then ConsoleWrite( "error in cvConvertScaleAbs")

Return
EndFunc ;==>_cvConvertScaleAbs


;------------------------------------------------
;/*
;CVAPI(void)  cvAdd( const CvArr* src1, const CvArr* src2, CvArr* dst, const CvArr* mask CV_DEFAULT(NULL));
;
;
Func _cvAdd( $cvsrc1 , $cvsrc2 , $cvdst , $cvmask = Null )

DllCall($_opencv_core , "none:cdecl" , "cvAdd" , "ptr" , $cvsrc1 , "ptr" , $cvsrc2 , "ptr" , $cvdst , "ptr" , $cvmask )
If @error Then ConsoleWrite( "error in cvAdd")

Return
EndFunc ;==>_cvAdd


;------------------------------------------------
;/*
;CVAPI(void)  cvSub( const CvArr* src1, const CvArr* src2, CvArr* dst, const CvArr* mask CV_DEFAULT(NULL));
;
;
Func _cvSub( $cvsrc1 , $cvsrc2 , $cvdst , $cvmask )

DllCall($_opencv_core , "none:cdecl" , "cvSub" , "ptr" , $cvsrc1 , "ptr" , $cvsrc2 , "ptr" , $cvdst , "ptr" , $cvmask )
If @error Then ConsoleWrite( "error in cvSub")

Return
EndFunc ;==>_cvSub


;------------------------------------------------
;/*
;CVAPI(void)  cvSubRS( const CvArr* src, CvScalar value, CvArr* dst, const CvArr* mask CV_DEFAULT(NULL));
;
;
Func _cvSubRS( $cvsrc , $cvvalue , $cvdst , $cvmask )

DllCall($_opencv_core , "none:cdecl" , "cvSubRS" , "ptr" , $cvsrc , "struct" , $cvvalue , "ptr" , $cvdst , "ptr" , $cvmask )
If @error Then ConsoleWrite( "error in cvSubRS")

Return
EndFunc ;==>_cvSubRS


;------------------------------------------------
;/*
;CVAPI(void)  cvMul( const CvArr* src1, const CvArr* src2, CvArr* dst, double scale CV_DEFAULT(1) );
;
;
Func _cvMul( $cvsrc1 , $cvsrc2 , $cvdst , $cvscale = 1 )

DllCall($_opencv_core , "none:cdecl" , "cvMul" , "ptr" , $cvsrc1 , "ptr" , $cvsrc2 , "ptr" , $cvdst , "double" , $cvscale )
If @error Then ConsoleWrite( "error in cvMul")

Return
EndFunc ;==>_cvMul


;------------------------------------------------
;/*
;CVAPI(void)  cvDiv( const CvArr* src1, const CvArr* src2, CvArr* dst, double scale CV_DEFAULT(1));
;
;
Func _cvDiv( $cvsrc1 , $cvsrc2 , $cvdst , $cvscale = 1  )

DllCall($_opencv_core , "none:cdecl" , "cvDiv" , "ptr" , $cvsrc1 , "ptr" , $cvsrc2 , "ptr" , $cvdst , "double" , $cvscale )
If @error Then ConsoleWrite( "error in cvDiv")

Return
EndFunc ;==>_cvDiv


;------------------------------------------------
;/*
;CVAPI(void)  cvScaleAdd( const CvArr* src1, CvScalar scale, const CvArr* src2, CvArr* dst );
;
;
Func _cvScaleAdd( $cvsrc1 , $cvscale , $cvsrc2 , $cvdst )

DllCall($_opencv_core , "none:cdecl" , "cvScaleAdd" , "ptr" , $cvsrc1 , "struct" , $cvscale , "ptr" , $cvsrc2 , "ptr" , $cvdst )
If @error Then ConsoleWrite( "error in cvScaleAdd")

Return
EndFunc ;==>_cvScaleAdd


;------------------------------------------------
;/*
;CVAPI(double)  cvDotProduct( const CvArr* src1, const CvArr* src2 );
;
;
Func _cvDotProduct( $cvsrc1 , $cvsrc2 )

local $_aResult = DllCall($_opencv_core , "double:cdecl" , "cvDotProduct" , "ptr" , $cvsrc1 , "ptr" , $cvsrc2 )
If @error Then ConsoleWrite( "error in cvDotProduct")

Return $_aResult[0]
EndFunc ;==>_cvDotProduct


;------------------------------------------------
;/*
;CVAPI(void) cvAnd( const CvArr* src1, const CvArr* src2, CvArr* dst, const CvArr* mask CV_DEFAULT(NULL));
;
;
Func _cvAnd( $cvsrc1 , $cvsrc2 , $cvdst , $cvmask = Null )

DllCall($_opencv_core , "none:cdecl" , "cvAnd" , "ptr" , $cvsrc1 , "ptr" , $cvsrc2 , "ptr" , $cvdst , "ptr" , $cvmask )
If @error Then ConsoleWrite( "error in cvAnd")

Return
EndFunc ;==>_cvAnd


;------------------------------------------------
;/*
;CVAPI(void) cvAndS( const CvArr* src, CvScalar value, CvArr* dst, const CvArr* mask CV_DEFAULT(NULL));
;
;
Func _cvAndS( $cvsrc , $cvvalue , $cvdst , $cvmask = Null )

DllCall($_opencv_core , "none:cdecl" , "cvAndS" , "ptr" , $cvsrc , "struct" , $cvvalue , "ptr" , $cvdst , "ptr" , $cvmask )
If @error Then ConsoleWrite( "error in cvAndS")

Return
EndFunc ;==>_cvAndS


;------------------------------------------------
;/*
;CVAPI(void) cvOr( const CvArr* src1, const CvArr* src2, CvArr* dst, const CvArr* mask CV_DEFAULT(NULL));
;
;
Func _cvOr( $cvsrc1 , $cvsrc2 , $cvdst , $cvmask = Null )

DllCall($_opencv_core , "none:cdecl" , "cvOr" , "ptr" , $cvsrc1 , "ptr" , $cvsrc2 , "ptr" , $cvdst , "ptr" , $cvmask )
If @error Then ConsoleWrite( "error in cvOr")

Return
EndFunc ;==>_cvOr


;------------------------------------------------
;/*
;CVAPI(void) cvOrS( const CvArr* src, CvScalar value, CvArr* dst, const CvArr* mask CV_DEFAULT(NULL));
;
;
Func _cvOrS( $cvsrc , $cvvalue , $cvdst , $cvmask = Null )

DllCall($_opencv_core , "none:cdecl" , "cvOrS" , "ptr" , $cvsrc , "struct" , $cvvalue , "ptr" , $cvdst , "ptr" , $cvmask )
If @error Then ConsoleWrite( "error in cvOrS")

Return
EndFunc ;==>_cvOrS


;------------------------------------------------
;/*
;CVAPI(void) cvXor( const CvArr* src1, const CvArr* src2, CvArr* dst, const CvArr* mask CV_DEFAULT(NULL));
;
;
Func _cvXor( $cvsrc1 , $cvsrc2 , $cvdst , $cvmask = Null )

DllCall($_opencv_core , "none:cdecl" , "cvXor" , "ptr" , $cvsrc1 , "ptr" , $cvsrc2 , "ptr" , $cvdst , "ptr" , $cvmask )
If @error Then ConsoleWrite( "error in cvXor")

Return
EndFunc ;==>_cvXor


;------------------------------------------------
;/*
;CVAPI(void) cvXorS( const CvArr* src, CvScalar value, CvArr* dst, const CvArr* mask CV_DEFAULT(NULL));
;
;
Func _cvXorS( $cvsrc , $cvvalue , $cvdst , $cvmask = Null )

DllCall($_opencv_core , "none:cdecl" , "cvXorS" , "ptr" , $cvsrc , "int" , $cvvalue , "ptr" , $cvdst , "ptr" , $cvmask )
If @error Then ConsoleWrite( "error in cvXorS")

Return
EndFunc ;==>_cvXorS


;------------------------------------------------
;/*
;CVAPI(void) cvNot( const CvArr* src, CvArr* dst );
;
;
Func _cvNot( $cvsrc , $cvdst )

DllCall($_opencv_core , "none:cdecl" , "cvNot" , "ptr" , $cvsrc , "ptr" , $cvdst )
If @error Then ConsoleWrite( "error in cvNot")

Return
EndFunc ;==>_cvNot


;------------------------------------------------
;/*
;CVAPI(void) cvInRange( const CvArr* src, const CvArr* lower, const CvArr* upper, CvArr* dst );
;
;
Func _cvInRange( $cvsrc , $cvlower , $cvupper , $cvdst )

DllCall($_opencv_core , "none:cdecl" , "cvInRange" , "ptr" , $cvsrc , "ptr" , $cvlower , "ptr" , $cvupper , "ptr" , $cvdst )
If @error Then ConsoleWrite( "error in cvInRange")

Return
EndFunc ;==>_cvInRange


;------------------------------------------------
;/*
;CVAPI(void) cvInRangeS( const CvArr* src, CvScalar lower, CvScalar upper, CvArr* dst );
;
;
Func _cvInRangeS( $cvsrc , $cvlower , $cvupper , $cvdst )

DllCall($_opencv_core , "none:cdecl" , "cvInRangeS" , "ptr" , $cvsrc , "struct" , $cvlower , "struct" , $cvupper , "ptr" , $cvdst )
If @error Then ConsoleWrite( "error in cvInRangeS")

Return
EndFunc ;==>_cvInRangeS


;------------------------------------------------
;/*
;CVAPI(void) cvCmp( const CvArr* src1, const CvArr* src2, CvArr* dst, int cmp_op);
;
;
Func _cvCmp( $cvsrc1 , $cvsrc2 , $cvdst , $cvcmp_op); )

DllCall($_opencv_core , "none:cdecl" , "cvCmp" , "ptr" , $cvsrc1 , "ptr" , $cvsrc2 , "ptr" , $cvdst , "int" , $cvcmp_op); )
If @error Then ConsoleWrite( "error in cvCmp")

Return
EndFunc ;==>_cvCmp


;------------------------------------------------
;/*
;CVAPI(void) cvCmpS( const CvArr* src, double value, CvArr* dst, int cmp_op );
;
;
Func _cvCmpS( $cvsrc , $cvvalue , $cvdst , $cvcmp_op )

DllCall($_opencv_core , "none:cdecl" , "cvCmpS" , "ptr" , $cvsrc , "double" , $cvvalue , "ptr" , $cvdst , "int" , $cvcmp_op )
If @error Then ConsoleWrite( "error in cvCmpS")

Return
EndFunc ;==>_cvCmpS


;------------------------------------------------
;/*
;CVAPI(void) cvMin( const CvArr* src1, const CvArr* src2, CvArr* dst );
;
;
Func _cvMin( $cvsrc1 , $cvsrc2 , $cvdst )

DllCall($_opencv_core , "none:cdecl" , "cvMin" , "ptr" , $cvsrc1 , "ptr" , $cvsrc2 , "ptr" , $cvdst )
If @error Then ConsoleWrite( "error in cvMin")

Return
EndFunc ;==>_cvMin


;------------------------------------------------
;/*
;CVAPI(void) cvMax( const CvArr* src1, const CvArr* src2, CvArr* dst );
;
;
Func _cvMax( $cvsrc1 , $cvsrc2 , $cvdst )

DllCall($_opencv_core , "none:cdecl" , "cvMax" , "ptr" , $cvsrc1 , "ptr" , $cvsrc2 , "ptr" , $cvdst )
If @error Then ConsoleWrite( "error in cvMax")

Return
EndFunc ;==>_cvMax


;------------------------------------------------
;/*
;CVAPI(void) cvMinS( const CvArr* src, double value, CvArr* dst );
;
;
Func _cvMinS( $cvsrc , $cvvalue , $cvdst )

DllCall($_opencv_core , "none:cdecl" , "cvMinS" , "ptr" , $cvsrc , "double" , $cvvalue , "ptr" , $cvdst )
If @error Then ConsoleWrite( "error in cvMinS")

Return
EndFunc ;==>_cvMinS


;------------------------------------------------
;/*
;CVAPI(void) cvMaxS( const CvArr* src, double value, CvArr* dst );
;
;
Func _cvMaxS( $cvsrc , $cvvalue , $cvdst )

DllCall($_opencv_core , "none:cdecl" , "cvMaxS" , "ptr" , $cvsrc , "double" , $cvvalue , "ptr" , $cvdst )
If @error Then ConsoleWrite( "error in cvMaxS")

Return
EndFunc ;==>_cvMaxS


;------------------------------------------------
;/*
;CVAPI(void) cvAbsDiff( const CvArr* src1, const CvArr* src2, CvArr* dst );
;
;
Func _cvAbsDiff( $cvsrc1 , $cvsrc2 , $cvdst )

DllCall($_opencv_core , "none:cdecl" , "cvAbsDiff" , "ptr" , $cvsrc1 , "ptr" , $cvsrc2 , "ptr" , $cvdst )
If @error Then ConsoleWrite( "error in cvAbsDiff")

Return
EndFunc ;==>_cvAbsDiff


;------------------------------------------------
;/*
;CVAPI(void) cvAbsDiffS( const CvArr* src, CvArr* dst, CvScalar value );
;
;
Func _cvAbsDiffS( $cvsrc , $cvdst , $cvvalue )

DllCall($_opencv_core , "none:cdecl" , "cvAbsDiffS" , "ptr" , $cvsrc , "ptr" , $cvdst , "struct" , $cvvalue )
If @error Then ConsoleWrite( "error in cvAbsDiffS")

Return
EndFunc ;==>_cvAbsDiffS


;------------------------------------------------
;/*
;CVAPI(void)  cvCartToPolar( const CvArr* x, const CvArr* y, CvArr* magnitude, CvArr* angle CV_DEFAULT(NULL), int angle_in_degrees CV_DEFAULT(0));
;
;
Func _cvCartToPolar( $cvx , $cvy , $cvmagnitude , $cvangle = Null , $cvangle_in_degrees = 0 )

DllCall($_opencv_core , "none:cdecl" , "cvCartToPolar" , "ptr" , $cvx , "ptr" , $cvy , "ptr" , $cvmagnitude , "ptr" , $cvangle , "int" , $cvangle_in_degrees )
If @error Then ConsoleWrite( "error in cvCartToPolar")

Return
EndFunc ;==>_cvCartToPolar


;------------------------------------------------
;/*
;CVAPI(void)  cvPolarToCart( const CvArr* magnitude, const CvArr* angle, CvArr* x, CvArr* y, int angle_in_degrees CV_DEFAULT(0));
;
;
Func _cvPolarToCart( $cvmagnitude , $cvangle , $cvx , $cvy , $cvangle_in_degrees )

DllCall($_opencv_core , "none:cdecl" , "cvPolarToCart" , "ptr" , $cvmagnitude , "ptr" , $cvangle , "ptr" , $cvx , "ptr" , $cvy , "int" , $cvangle_in_degrees )
If @error Then ConsoleWrite( "error in cvPolarToCart")

Return
EndFunc ;==>_cvPolarToCart


;------------------------------------------------
;/*
;CVAPI(void)  cvPow( const CvArr* src, CvArr* dst, double power );
;
;
Func _cvPow( $cvsrc , $cvdst , $cvpower )

DllCall($_opencv_core , "none:cdecl" , "cvPow" , "ptr" , $cvsrc , "ptr" , $cvdst , "double" , $cvpower )
If @error Then ConsoleWrite( "error in cvPow")

Return
EndFunc ;==>_cvPow


;------------------------------------------------
;/*
;CVAPI(void)  cvExp( const CvArr* src, CvArr* dst );
;
;
Func _cvExp( $cvsrc , $cvdst )

DllCall($_opencv_core , "none:cdecl" , "cvExp" , "ptr" , $cvsrc , "ptr" , $cvdst )
If @error Then ConsoleWrite( "error in cvExp")

Return
EndFunc ;==>_cvExp


;------------------------------------------------
;/*
;CVAPI(void)  cvLog( const CvArr* src, CvArr* dst );
;
;
Func _cvLog( $cvsrc , $cvdst )

DllCall($_opencv_core , "none:cdecl" , "cvLog" , "ptr" , $cvsrc , "ptr" , $cvdst )
If @error Then ConsoleWrite( "error in cvLog")

Return
EndFunc ;==>_cvLog


;------------------------------------------------
;/*
;CVAPI(float) cvFastArctan( float y, float x );
;
;
Func _cvFastArctan( $cvy , $cvx )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvFastArctan" , "float" , $cvy , "float" , $cvx )
If @error Then ConsoleWrite( "error in cvFastArctan")

Return $_aResult[0]
EndFunc ;==>_cvFastArctan


;------------------------------------------------
;/*
;CVAPI(float)  cvCbrt( float value );
;
;
Func _cvCbrt( $cvvalue )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvCbrt" , "float" , $cvvalue )
If @error Then ConsoleWrite( "error in cvCbrt")

Return $_aResult[0]
EndFunc ;==>_cvCbrt


;------------------------------------------------
;/*
;CVAPI(int)  cvCheckArr( const CvArr* arr, int flags CV_DEFAULT(0), double min_val CV_DEFAULT(0), double max_val CV_DEFAULT(0));
;
;
Func _cvCheckArr( $cvarr , $cvflags , $cvmin_val , $cvmax_val )

local $_aResult = DllCall($_opencv_core , "int:cdecl" , "cvCheckArr" , "ptr" , $cvarr , "int" , $cvflags , "double" , $cvmin_val , "double" , $cvmax_val )
If @error Then ConsoleWrite( "error in cvCheckArr")

Return $_aResult[0]
EndFunc ;==>_cvCheckArr


;------------------------------------------------
;/*
;CVAPI(void) cvRandArr( CvRNG* rng, CvArr* arr, int dist_type, CvScalar param1, CvScalar param2 );
;
;
Func _cvRandArr( $cvrng , $cvarr , $cvdist_type , $cvparam1 , $cvparam2 )

DllCall($_opencv_core , "none:cdecl" , "cvRandArr" , "ptr" , $cvrng , "ptr" , $cvarr , "int" , $cvdist_type , "int" , $cvparam1 , "struct" , $cvparam2 )
If @error Then ConsoleWrite( "error in cvRandArr")

Return
EndFunc ;==>_cvRandArr


;------------------------------------------------
;/*
;CVAPI(void) cvRandShuffle( CvArr* mat, CvRNG* rng, double iter_factor CV_DEFAULT(1.));
;
;
Func _cvRandShuffle( $cvmat , $cvrng , $cviter_factor )

DllCall($_opencv_core , "none:cdecl" , "cvRandShuffle" , "ptr" , $cvmat , "ptr" , $cvrng , "double" , $cviter_factor )
If @error Then ConsoleWrite( "error in cvRandShuffle")

Return
EndFunc ;==>_cvRandShuffle


;------------------------------------------------
;/*
;CVAPI(void) cvSort( const CvArr* src, CvArr* dst CV_DEFAULT(NULL), CvArr* idxmat CV_DEFAULT(NULL), int flags CV_DEFAULT(0));
;
;
Func _cvSort( $cvsrc , $cvdst , $cvidxmat , $cvflags )

DllCall($_opencv_core , "none:cdecl" , "cvSort" , "ptr" , $cvsrc , "ptr" , $cvdst , "ptr" , $cvidxmat , "int" , $cvflags )
If @error Then ConsoleWrite( "error in cvSort")

Return
EndFunc ;==>_cvSort


;------------------------------------------------
;/*
;CVAPI(int) cvSolveCubic( const CvMat* coeffs, CvMat* roots );
;
;
Func _cvSolveCubic( $cvcoeffs , $cvroots )

local $_aResult = DllCall($_opencv_core , "int:cdecl" , "cvSolveCubic" , "ptr" , $cvcoeffs , "ptr" , $cvroots )
If @error Then ConsoleWrite( "error in cvSolveCubic")

Return $_aResult[0]
EndFunc ;==>_cvSolveCubic


;------------------------------------------------
;/*
;CVAPI(void) cvSolvePoly(const CvMat* coeffs, CvMat *roots2, int maxiter CV_DEFAULT(20), int fig CV_DEFAULT(100));
;
;
Func _cvSolvePoly( $cvcoeffs , $cvroots2 , $cvmaxiter , $cvfig )

DllCall($_opencv_core , "none:cdecl" , "cvSolvePoly" , "ptr" , $cvcoeffs , "ptr" , $cvroots2 , "int" , $cvmaxiter , "int" , $cvfig )
If @error Then ConsoleWrite( "error in cvSolvePoly")

Return
EndFunc ;==>_cvSolvePoly


;------------------------------------------------
;/*
;CVAPI(void)  cvCrossProduct( const CvArr* src1, const CvArr* src2, CvArr* dst );
;
;
Func _cvCrossProduct( $cvsrc1 , $cvsrc2 , $cvdst )

DllCall($_opencv_core , "none:cdecl" , "cvCrossProduct" , "ptr" , $cvsrc1 , "ptr" , $cvsrc2 , "ptr" , $cvdst )
If @error Then ConsoleWrite( "error in cvCrossProduct")

Return
EndFunc ;==>_cvCrossProduct


;------------------------------------------------
;/*
;CVAPI(void)  cvGEMM( const CvArr* src1, const CvArr* src2, double alpha, const CvArr* src3, double beta, CvArr* dst, int tABC CV_DEFAULT(0));
;
;
Func _cvGEMM( $cvsrc1 , $cvsrc2 , $cvalpha , $cvsrc3 , $cvbeta , $cvdst , $cvtABC )

DllCall($_opencv_core , "none:cdecl" , "cvGEMM" , "ptr" , $cvsrc1 , "ptr" , $cvsrc2 , "double" , $cvalpha , "ptr" , $cvsrc3 , "double" , $cvbeta , "ptr" , $cvdst , "int" , $cvtABC )
If @error Then ConsoleWrite( "error in cvGEMM")

Return
EndFunc ;==>_cvGEMM


;------------------------------------------------
;/*
;CVAPI(void)  cvTransform( const CvArr* src, CvArr* dst, const CvMat* transmat, const CvMat* shiftvec CV_DEFAULT(NULL));
;
;
Func _cvTransform( $cvsrc , $cvdst , $cvtransmat , $cvshiftvec )

DllCall($_opencv_core , "none:cdecl" , "cvTransform" , "ptr" , $cvsrc , "ptr" , $cvdst , "ptr" , $cvtransmat , "ptr" , $cvshiftvec )
If @error Then ConsoleWrite( "error in cvTransform")

Return
EndFunc ;==>_cvTransform


;------------------------------------------------
;/*
;CVAPI(void)  cvPerspectiveTransform( const CvArr* src, CvArr* dst, const CvMat* mat );
;
;
Func _cvPerspectiveTransform( $cvsrc , $cvdst , $cvmat )

DllCall($_opencv_core , "none:cdecl" , "cvPerspectiveTransform" , "ptr" , $cvsrc , "ptr" , $cvdst , "ptr" , $cvmat )
If @error Then ConsoleWrite( "error in cvPerspectiveTransform")

Return
EndFunc ;==>_cvPerspectiveTransform


;------------------------------------------------
;/*
;CVAPI(void) cvMulTransposed( const CvArr* src, CvArr* dst, int order, const CvArr* delta CV_DEFAULT(NULL), double scale CV_DEFAULT(1.) );
;
;
Func _cvMulTransposed( $cvsrc , $cvdst , $cvorder , $cvdelta , $cvscale )

DllCall($_opencv_core , "none:cdecl" , "cvMulTransposed" , "ptr" , $cvsrc , "ptr" , $cvdst , "int" , $cvorder , "ptr" , $cvdelta , "double" , $cvscale )
If @error Then ConsoleWrite( "error in cvMulTransposed")

Return
EndFunc ;==>_cvMulTransposed


;------------------------------------------------
;/*
;CVAPI(void)  cvTranspose( const CvArr* src, CvArr* dst );
;
;
Func _cvTranspose( $cvsrc , $cvdst )

DllCall($_opencv_core , "none:cdecl" , "cvTranspose" , "ptr" , $cvsrc , "ptr" , $cvdst )
If @error Then ConsoleWrite( "error in cvTranspose")

Return
EndFunc ;==>_cvTranspose


;------------------------------------------------
;/*
;CVAPI(void)  cvCompleteSymm( CvMat* matrix, int LtoR CV_DEFAULT(0) );
;
;
Func _cvCompleteSymm( $cvmatrix , $cvLtoR )

DllCall($_opencv_core , "none:cdecl" , "cvCompleteSymm" , "ptr" , $cvmatrix , "int" , $cvLtoR )
If @error Then ConsoleWrite( "error in cvCompleteSymm")

Return
EndFunc ;==>_cvCompleteSymm


;------------------------------------------------
;/*
;CVAPI(void)  cvFlip( const CvArr* src, CvArr* dst CV_DEFAULT(NULL), int flip_mode CV_DEFAULT(0));
;
;
Func _cvFlip( $cvsrc , $cvdst = Null , $cvflip_mode = 0 )

DllCall($_opencv_core , "none:cdecl" , "cvFlip" , "ptr" , $cvsrc , "ptr" , $cvdst , "int" , $cvflip_mode )
If @error Then ConsoleWrite( "error in cvFlip")

Return
EndFunc ;==>_cvFlip


;------------------------------------------------
;/*
;CVAPI(void)   cvSVD( CvArr* A, CvArr* W, CvArr* U CV_DEFAULT(NULL), CvArr* V CV_DEFAULT(NULL), int flags CV_DEFAULT(0));
;
;
Func _cvSVD( $cvA , $cvW , $cvU , $cvV , $cvflags )

DllCall($_opencv_core , "none:cdecl" , "cvSVD" , "ptr" , $cvA , "ptr" , $cvW , "ptr" , $cvU , "ptr" , $cvV , "int" , $cvflags )
If @error Then ConsoleWrite( "error in cvSVD")

Return
EndFunc ;==>_cvSVD


;------------------------------------------------
;/*
;CVAPI(void)   cvSVBkSb( const CvArr* W, const CvArr* U, const CvArr* V, const CvArr* B, CvArr* X, int flags );
;
;
Func _cvSVBkSb( $cvW , $cvU , $cvV , $cvB , $cvX , $cvflags )

DllCall($_opencv_core , "none:cdecl" , "cvSVBkSb" , "ptr" , $cvW , "ptr" , $cvU , "ptr" , $cvV , "ptr" , $cvB , "ptr" , $cvX , "int" , $cvflags )
If @error Then ConsoleWrite( "error in cvSVBkSb")

Return
EndFunc ;==>_cvSVBkSb


;------------------------------------------------
;/*
;CVAPI(double)  cvInvert( const CvArr* src, CvArr* dst, int method CV_DEFAULT(CV_LU));
;
;
Func _cvInvert( $cvsrc , $cvdst , $cvmethod )

local $_aResult = DllCall($_opencv_core , "double:cdecl" , "cvInvert" , "ptr" , $cvsrc , "ptr" , $cvdst , "int" , $cvmethod )
If @error Then ConsoleWrite( "error in cvInvert")

Return $_aResult[0]
EndFunc ;==>_cvInvert


;------------------------------------------------
;/*
;CVAPI(int)  cvSolve( const CvArr* src1, const CvArr* src2, CvArr* dst, int method CV_DEFAULT(CV_LU));
;
;
Func _cvSolve( $cvsrc1 , $cvsrc2 , $cvdst , $cvmethod )

local $_aResult = DllCall($_opencv_core , "int:cdecl" , "cvSolve" , "ptr" , $cvsrc1 , "ptr" , $cvsrc2 , "ptr" , $cvdst , "int" , $cvmethod )
If @error Then ConsoleWrite( "error in cvSolve")

Return $_aResult[0]
EndFunc ;==>_cvSolve


;------------------------------------------------
;/*
;CVAPI(double) cvDet( const CvArr* mat );
;
;
Func _cvDet( $cvmat )

local $_aResult = DllCall($_opencv_core , "double:cdecl" , "cvDet" , "ptr" , $cvmat )
If @error Then ConsoleWrite( "error in cvDet")

Return $_aResult[0]
EndFunc ;==>_cvDet


;------------------------------------------------
;/*
;CVAPI(void)  cvEigenVV( CvArr* mat, CvArr* evects, CvArr* evals, double eps CV_DEFAULT(0), int lowindex CV_DEFAULT(-1), int highindex CV_DEFAULT(-1));
;
;
Func _cvEigenVV( $cvmat , $cvevects , $cvevals , $cveps , $cvlowindex , $cvhighindex )

DllCall($_opencv_core , "none:cdecl" , "cvEigenVV" , "ptr" , $cvmat , "ptr" , $cvevects , "ptr" , $cvevals , "double" , $cveps , "int" , $cvlowindex , "int" , $cvhighindex )
If @error Then ConsoleWrite( "error in cvEigenVV")

Return
EndFunc ;==>_cvEigenVV


;------------------------------------------------
;/*
;CVAPI(void)  cvSetIdentity( CvArr* mat, CvScalar value CV_DEFAULT(cvRealScalar(1)) );
;
;
Func _cvSetIdentity( $cvmat , $cvvalue )

DllCall($_opencv_core , "none:cdecl" , "cvSetIdentity" , "ptr" , $cvmat , "struct" , $cvvalue )
If @error Then ConsoleWrite( "error in cvSetIdentity")

Return
EndFunc ;==>_cvSetIdentity


;------------------------------------------------
;/*
;CVAPI(CvArr*)  cvRange( CvArr* mat, double start, double end );
;
;
Func _cvRange( $cvmat , $cvstart , $cvend )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvRange" , "ptr" , $cvmat , "double" , $cvstart , "double" , $cvend )
If @error Then ConsoleWrite( "error in cvRange")

Return $_aResult[0]
EndFunc ;==>_cvRange


;------------------------------------------------
;/*
;CVAPI(void)  cvCalcCovarMatrix( const CvArr** vects, int count, CvArr* cov_mat, CvArr* avg, int flags );
;
;
Func _cvCalcCovarMatrix( $cvvects , $cvcount , $cvcov_mat , $cvavg , $cvflags )

DllCall($_opencv_core , "none:cdecl" , "cvCalcCovarMatrix" , "ptr*" , $cvvects , "int" , $cvcount , "ptr" , $cvcov_mat , "ptr" , $cvavg , "int" , $cvflags )
If @error Then ConsoleWrite( "error in cvCalcCovarMatrix")

Return
EndFunc ;==>_cvCalcCovarMatrix


;------------------------------------------------
;/*
;CVAPI(void)  cvCalcPCA( const CvArr* data, CvArr* mean, CvArr* eigenvals, CvArr* eigenvects, int flags );
;
;
Func _cvCalcPCA( $cvdata , $cvmean , $cveigenvals , $cveigenvects , $cvflags )

DllCall($_opencv_core , "none:cdecl" , "cvCalcPCA" , "ptr" , $cvdata , "ptr" , $cvmean , "ptr" , $cveigenvals , "ptr" , $cveigenvects , "int" , $cvflags )
If @error Then ConsoleWrite( "error in cvCalcPCA")

Return
EndFunc ;==>_cvCalcPCA


;------------------------------------------------
;/*
;CVAPI(void)  cvProjectPCA( const CvArr* data, const CvArr* mean, const CvArr* eigenvects, CvArr* result );
;
;
Func _cvProjectPCA( $cvdata , $cvmean , $cveigenvects , $cvresult )

DllCall($_opencv_core , "none:cdecl" , "cvProjectPCA" , "ptr" , $cvdata , "ptr" , $cvmean , "ptr" , $cveigenvects , "ptr" , $cvresult )
If @error Then ConsoleWrite( "error in cvProjectPCA")

Return
EndFunc ;==>_cvProjectPCA


;------------------------------------------------
;/*
;CVAPI(void)  cvBackProjectPCA( const CvArr* proj, const CvArr* mean, const CvArr* eigenvects, CvArr* result );
;
;
Func _cvBackProjectPCA( $cvproj , $cvmean , $cveigenvects , $cvresult )

DllCall($_opencv_core , "none:cdecl" , "cvBackProjectPCA" , "ptr" , $cvproj , "ptr" , $cvmean , "ptr" , $cveigenvects , "ptr" , $cvresult )
If @error Then ConsoleWrite( "error in cvBackProjectPCA")

Return
EndFunc ;==>_cvBackProjectPCA


;------------------------------------------------
;/*
;CVAPI(double)  cvMahalanobis( const CvArr* vec1, const CvArr* vec2, const CvArr* mat );
;
;
Func _cvMahalanobis( $cvvec1 , $cvvec2 , $cvmat )

local $_aResult = DllCall($_opencv_core , "double:cdecl" , "cvMahalanobis" , "ptr" , $cvvec1 , "ptr" , $cvvec2 , "ptr" , $cvmat )
If @error Then ConsoleWrite( "error in cvMahalanobis")

Return $_aResult[0]
EndFunc ;==>_cvMahalanobis


;------------------------------------------------
;/*
;CVAPI(int)  cvCountNonZero( const CvArr* arr );
;
;
Func _cvCountNonZero( $cvarr )

local $_aResult = DllCall($_opencv_core , "int:cdecl" , "cvCountNonZero" , "ptr" , $cvarr )
If @error Then ConsoleWrite( "error in cvCountNonZero")

Return $_aResult[0]
EndFunc ;==>_cvCountNonZero


;------------------------------------------------
;/*
;CVAPI(void)  cvAvgSdv( const CvArr* arr, CvScalar* mean, CvScalar* std_dev, const CvArr* mask CV_DEFAULT(NULL) );
;
;
Func _cvAvgSdv( $cvarr , $cvmean , $cvstd_dev , $cvmask )

DllCall($_opencv_core , "none:cdecl" , "cvAvgSdv" , "ptr" , $cvarr , "ptr" , $cvmean , "ptr" , $cvstd_dev , "ptr" , $cvmask )
If @error Then ConsoleWrite( "error in cvAvgSdv")

Return
EndFunc ;==>_cvAvgSdv


;------------------------------------------------
;/*
;CVAPI(void)  cvMinMaxLoc( const CvArr* arr, double* min_val, double* max_val, CvPoint* min_loc CV_DEFAULT(NULL), CvPoint* max_loc CV_DEFAULT(NULL), const CvArr* mask CV_DEFAULT(NULL) );
;
;
Func _cvMinMaxLoc( $cvarr , $cvmin_val , $cvmax_val , $cvmin_loc , $cvmax_loc , $cvmask )

DllCall($_opencv_core , "none:cdecl" , "cvMinMaxLoc" , "ptr" , $cvarr , "ptr" , $cvmin_val , "ptr" , $cvmax_val , "ptr" , $cvmin_loc , "ptr" , $cvmax_loc , "ptr" , $cvmask )
If @error Then ConsoleWrite( "error in cvMinMaxLoc")

Return
EndFunc ;==>_cvMinMaxLoc


;------------------------------------------------
;/*
;CVAPI(double)  cvNorm( const CvArr* arr1, const CvArr* arr2 CV_DEFAULT(NULL), int norm_type CV_DEFAULT(CV_L2), const CvArr* mask CV_DEFAULT(NULL) );
;
;
Func _cvNorm( $cvarr1 , $cvarr2 , $cvnorm_type , $cvmask )

local $_aResult = DllCall($_opencv_core , "double:cdecl" , "cvNorm" , "ptr" , $cvarr1 , "ptr" , $cvarr2 , "int" , $cvnorm_type , "ptr" , $cvmask )
If @error Then ConsoleWrite( "error in cvNorm")

Return $_aResult[0]
EndFunc ;==>_cvNorm


;------------------------------------------------
;/*
;CVAPI(void)  cvNormalize( const CvArr* src, CvArr* dst, double a CV_DEFAULT(1.), double b CV_DEFAULT(0.), int norm_type CV_DEFAULT(CV_L2), const CvArr* mask CV_DEFAULT(NULL) );
;
;
Func _cvNormalize( $cvsrc , $cvdst , $cva , $cvb , $cvnorm_type , $cvmask )

DllCall($_opencv_core , "none:cdecl" , "cvNormalize" , "ptr" , $cvsrc , "ptr" , $cvdst , "double" , $cva , "double" , $cvb , "int" , $cvnorm_type , "ptr" , $cvmask )
If @error Then ConsoleWrite( "error in cvNormalize")

Return
EndFunc ;==>_cvNormalize


;------------------------------------------------
;/*
;CVAPI(void)  cvReduce( const CvArr* src, CvArr* dst, int dim CV_DEFAULT(-1), int op CV_DEFAULT(CV_REDUCE_SUM) );
;
;
Func _cvReduce( $cvsrc , $cvdst , $cvdim , $cvop )

DllCall($_opencv_core , "none:cdecl" , "cvReduce" , "ptr" , $cvsrc , "ptr" , $cvdst , "int" , $cvdim , "int" , $cvop )
If @error Then ConsoleWrite( "error in cvReduce")

Return
EndFunc ;==>_cvReduce


;------------------------------------------------
;/*
;CVAPI(void)  cvDFT( const CvArr* src, CvArr* dst, int flags, int nonzero_rows CV_DEFAULT(0) );
;
;
Func _cvDFT( $cvsrc , $cvdst , $cvflags , $cvnonzero_rows )

DllCall($_opencv_core , "none:cdecl" , "cvDFT" , "ptr" , $cvsrc , "ptr" , $cvdst , "int" , $cvflags , "int" , $cvnonzero_rows )
If @error Then ConsoleWrite( "error in cvDFT")

Return
EndFunc ;==>_cvDFT


;------------------------------------------------
;/*
;CVAPI(void)  cvMulSpectrums( const CvArr* src1, const CvArr* src2, CvArr* dst, int flags );
;
;
Func _cvMulSpectrums( $cvsrc1 , $cvsrc2 , $cvdst , $cvflags )

DllCall($_opencv_core , "none:cdecl" , "cvMulSpectrums" , "ptr" , $cvsrc1 , "ptr" , $cvsrc2 , "ptr" , $cvdst , "int" , $cvflags )
If @error Then ConsoleWrite( "error in cvMulSpectrums")

Return
EndFunc ;==>_cvMulSpectrums


;------------------------------------------------
;/*
;CVAPI(int)  cvGetOptimalDFTSize( int size0 );
;
;
Func _cvGetOptimalDFTSize( $cvsize0 )

local $_aResult = DllCall($_opencv_core , "int:cdecl" , "cvGetOptimalDFTSize" , "int" , $cvsize0 )
If @error Then ConsoleWrite( "error in cvGetOptimalDFTSize")

Return $_aResult[0]
EndFunc ;==>_cvGetOptimalDFTSize


;------------------------------------------------
;/*
;CVAPI(void)  cvDCT( const CvArr* src, CvArr* dst, int flags );
;
;
Func _cvDCT( $cvsrc , $cvdst , $cvflags )

DllCall($_opencv_core , "none:cdecl" , "cvDCT" , "ptr" , $cvsrc , "ptr" , $cvdst , "int" , $cvflags )
If @error Then ConsoleWrite( "error in cvDCT")

Return
EndFunc ;==>_cvDCT


;------------------------------------------------
;/*
;CVAPI(int) cvSliceLength( CvSlice slice, const CvSeq* seq );
;
;
Func _cvSliceLength( $cvslice , $cvseq )

local $_aResult = DllCall($_opencv_core , "int:cdecl" , "cvSliceLength" , "ptr" , $cvslice , "ptr" , $cvseq )
If @error Then ConsoleWrite( "error in cvSliceLength")

Return $_aResult[0]
EndFunc ;==>_cvSliceLength


;------------------------------------------------
;/*
;CVAPI(CvMemStorage*)  cvCreateChildMemStorage( CvMemStorage* parent );
;
;
Func _cvCreateChildMemStorage( $cvparent )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvCreateChildMemStorage" , "ptr" , $cvparent )
If @error Then ConsoleWrite( "error in cvCreateChildMemStorage")

Return $_aResult[0]
EndFunc ;==>_cvCreateChildMemStorage


;------------------------------------------------
;/*
;CVAPI(void)  cvReleaseMemStorage( CvMemStorage** storage );
;
;
Func _cvReleaseMemStorage( $cvstorage )

DllCall($_opencv_core , "none:cdecl" , "cvReleaseMemStorage" , "ptr*" , $cvstorage )
If @error Then ConsoleWrite( "error in cvReleaseMemStorage")

Return
EndFunc ;==>_cvReleaseMemStorage


;------------------------------------------------
;/*
;CVAPI(void)  cvClearMemStorage( CvMemStorage* storage );
;
;
Func _cvClearMemStorage( $cvstorage )

DllCall($_opencv_core , "none:cdecl" , "cvClearMemStorage" , "ptr" , $cvstorage )
If @error Then ConsoleWrite( "error in cvClearMemStorage")

Return
EndFunc ;==>_cvClearMemStorage


;------------------------------------------------
;/*
;CVAPI(void)  cvSaveMemStoragePos( const CvMemStorage* storage, CvMemStoragePos* pos );
;
;
Func _cvSaveMemStoragePos( $cvstorage , $cvpos )

DllCall($_opencv_core , "none:cdecl" , "cvSaveMemStoragePos" , "ptr" , $cvstorage , "ptr" , $cvpos )
If @error Then ConsoleWrite( "error in cvSaveMemStoragePos")

Return
EndFunc ;==>_cvSaveMemStoragePos


;------------------------------------------------
;/*
;CVAPI(void)  cvRestoreMemStoragePos( CvMemStorage* storage, CvMemStoragePos* pos );
;
;
Func _cvRestoreMemStoragePos( $cvstorage , $cvpos )

DllCall($_opencv_core , "none:cdecl" , "cvRestoreMemStoragePos" , "ptr" , $cvstorage , "ptr" , $cvpos )
If @error Then ConsoleWrite( "error in cvRestoreMemStoragePos")

Return
EndFunc ;==>_cvRestoreMemStoragePos


;------------------------------------------------
;/*
;CVAPI(void*) cvMemStorageAlloc( CvMemStorage* storage, size_t size );
;
;
Func _cvMemStorageAlloc( $cvstorage , $cvsize )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvMemStorageAlloc" , "ptr" , $cvstorage , "ptr" , $cvsize )
If @error Then ConsoleWrite( "error in cvMemStorageAlloc")

Return $_aResult[0]
EndFunc ;==>_cvMemStorageAlloc


;------------------------------------------------
;/*
;CVAPI(CvSeq*)  cvCreateSeq( int seq_flags, size_t header_size, size_t elem_size, CvMemStorage* storage );
;
;
Func _cvCreateSeq( $cvseq_flags , $cvheader_size , $cvelem_size , $cvstorage )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvCreateSeq" , "int" , $cvseq_flags , "ptr" , $cvheader_size , "ptr" , $cvelem_size , "ptr" , $cvstorage )
If @error Then ConsoleWrite( "error in cvCreateSeq")

Return $_aResult[0]
EndFunc ;==>_cvCreateSeq


;------------------------------------------------
;/*
;CVAPI(void)  cvSetSeqBlockSize( CvSeq* seq, int delta_elems );
;
;
Func _cvSetSeqBlockSize( $cvseq , $cvdelta_elems )

DllCall($_opencv_core , "none:cdecl" , "cvSetSeqBlockSize" , "ptr" , $cvseq , "int" , $cvdelta_elems )
If @error Then ConsoleWrite( "error in cvSetSeqBlockSize")

Return
EndFunc ;==>_cvSetSeqBlockSize


;------------------------------------------------
;/*
;CVAPI(schar*)  cvSeqPush( CvSeq* seq, const void* element CV_DEFAULT(NULL));
;
;
Func _cvSeqPush( $cvseq , $cvelement )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvSeqPush" , "ptr" , $cvseq , "ptr" , $cvelement )
If @error Then ConsoleWrite( "error in cvSeqPush")

Return $_aResult[0]
EndFunc ;==>_cvSeqPush


;------------------------------------------------
;/*
;CVAPI(schar*)  cvSeqPushFront( CvSeq* seq, const void* element CV_DEFAULT(NULL));
;
;
Func _cvSeqPushFront( $cvseq , $cvelement )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvSeqPushFront" , "ptr" , $cvseq , "ptr" , $cvelement )
If @error Then ConsoleWrite( "error in cvSeqPushFront")

Return $_aResult[0]
EndFunc ;==>_cvSeqPushFront


;------------------------------------------------
;/*
;CVAPI(void)  cvSeqPop( CvSeq* seq, void* element CV_DEFAULT(NULL));
;
;
Func _cvSeqPop( $cvseq , $cvelement )

DllCall($_opencv_core , "none:cdecl" , "cvSeqPop" , "ptr" , $cvseq , "ptr" , $cvelement )
If @error Then ConsoleWrite( "error in cvSeqPop")

Return
EndFunc ;==>_cvSeqPop


;------------------------------------------------
;/*
;CVAPI(void)  cvSeqPopFront( CvSeq* seq, void* element CV_DEFAULT(NULL));
;
;
Func _cvSeqPopFront( $cvseq , $cvelement )

DllCall($_opencv_core , "none:cdecl" , "cvSeqPopFront" , "ptr" , $cvseq , "ptr" , $cvelement )
If @error Then ConsoleWrite( "error in cvSeqPopFront")

Return
EndFunc ;==>_cvSeqPopFront


;------------------------------------------------
;/*
;CVAPI(void)  cvSeqPushMulti( CvSeq* seq, const void* elements, int count, int in_front CV_DEFAULT(0) );
;
;
Func _cvSeqPushMulti( $cvseq , $cvelements , $cvcount , $cvin_front )

DllCall($_opencv_core , "none:cdecl" , "cvSeqPushMulti" , "ptr" , $cvseq , "ptr" , $cvelements , "int" , $cvcount , "int" , $cvin_front )
If @error Then ConsoleWrite( "error in cvSeqPushMulti")

Return
EndFunc ;==>_cvSeqPushMulti


;------------------------------------------------
;/*
;CVAPI(void)  cvSeqPopMulti( CvSeq* seq, void* elements, int count, int in_front CV_DEFAULT(0) );
;
;
Func _cvSeqPopMulti( $cvseq , $cvelements , $cvcount , $cvin_front )

DllCall($_opencv_core , "none:cdecl" , "cvSeqPopMulti" , "ptr" , $cvseq , "ptr" , $cvelements , "int" , $cvcount , "int" , $cvin_front )
If @error Then ConsoleWrite( "error in cvSeqPopMulti")

Return
EndFunc ;==>_cvSeqPopMulti


;------------------------------------------------
;/*
;CVAPI(schar*)  cvSeqInsert( CvSeq* seq, int before_index, const void* element CV_DEFAULT(NULL));
;
;
Func _cvSeqInsert( $cvseq , $cvbefore_index , $cvelement )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvSeqInsert" , "ptr" , $cvseq , "int" , $cvbefore_index , "ptr" , $cvelement )
If @error Then ConsoleWrite( "error in cvSeqInsert")

Return $_aResult[0]
EndFunc ;==>_cvSeqInsert


;------------------------------------------------
;/*
;CVAPI(void)  cvSeqRemove( CvSeq* seq, int index );
;
;
Func _cvSeqRemove( $cvseq , $cvindex )

DllCall($_opencv_core , "none:cdecl" , "cvSeqRemove" , "ptr" , $cvseq , "int" , $cvindex )
If @error Then ConsoleWrite( "error in cvSeqRemove")

Return
EndFunc ;==>_cvSeqRemove


;------------------------------------------------
;/*
;CVAPI(void)  cvClearSeq( CvSeq* seq );
;
;
Func _cvClearSeq( $cvseq )

DllCall($_opencv_core , "none:cdecl" , "cvClearSeq" , "ptr" , $cvseq )
If @error Then ConsoleWrite( "error in cvClearSeq")

Return
EndFunc ;==>_cvClearSeq


;------------------------------------------------
;/*
;CVAPI(int)  cvSeqElemIdx( const CvSeq* seq, const void* element, CvSeqBlock** block CV_DEFAULT(NULL) );
;
;
Func _cvSeqElemIdx( $cvseq , $cvelement , $cvblock )

local $_aResult = DllCall($_opencv_core , "int:cdecl" , "cvSeqElemIdx" , "ptr" , $cvseq , "ptr" , $cvelement , "ptr*" , $cvblock )
If @error Then ConsoleWrite( "error in cvSeqElemIdx")

Return $_aResult[0]
EndFunc ;==>_cvSeqElemIdx


;------------------------------------------------
;/*
;CVAPI(void)  cvStartAppendToSeq( CvSeq* seq, CvSeqWriter* writer );
;
;
Func _cvStartAppendToSeq( $cvseq , $cvwriter )

DllCall($_opencv_core , "none:cdecl" , "cvStartAppendToSeq" , "ptr" , $cvseq , "ptr" , $cvwriter )
If @error Then ConsoleWrite( "error in cvStartAppendToSeq")

Return
EndFunc ;==>_cvStartAppendToSeq


;------------------------------------------------
;/*
;CVAPI(void)  cvStartWriteSeq( int seq_flags, int header_size, int elem_size, CvMemStorage* storage, CvSeqWriter* writer );
;
;
Func _cvStartWriteSeq( $cvseq_flags , $cvheader_size , $cvelem_size , $cvstorage , $cvwriter )

DllCall($_opencv_core , "none:cdecl" , "cvStartWriteSeq" , "int" , $cvseq_flags , "int" , $cvheader_size , "int" , $cvelem_size , "ptr" , $cvstorage , "ptr" , $cvwriter )
If @error Then ConsoleWrite( "error in cvStartWriteSeq")

Return
EndFunc ;==>_cvStartWriteSeq


;------------------------------------------------
;/*
;CVAPI(CvSeq*)  cvEndWriteSeq( CvSeqWriter* writer );
;
;
Func _cvEndWriteSeq( $cvwriter )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvEndWriteSeq" , "ptr" , $cvwriter )
If @error Then ConsoleWrite( "error in cvEndWriteSeq")

Return $_aResult[0]
EndFunc ;==>_cvEndWriteSeq


;------------------------------------------------
;/*
;CVAPI(void)   cvFlushSeqWriter( CvSeqWriter* writer );
;
;
Func _cvFlushSeqWriter( $cvwriter )

DllCall($_opencv_core , "none:cdecl" , "cvFlushSeqWriter" , "ptr" , $cvwriter )
If @error Then ConsoleWrite( "error in cvFlushSeqWriter")

Return
EndFunc ;==>_cvFlushSeqWriter


;------------------------------------------------
;/*
;CVAPI(void) cvStartReadSeq( const CvSeq* seq, CvSeqReader* reader, int reverse CV_DEFAULT(0) );
;
;
Func _cvStartReadSeq( $cvseq , $cvreader , $cvreverse )

DllCall($_opencv_core , "none:cdecl" , "cvStartReadSeq" , "ptr" , $cvseq , "ptr" , $cvreader , "int" , $cvreverse )
If @error Then ConsoleWrite( "error in cvStartReadSeq")

Return
EndFunc ;==>_cvStartReadSeq


;------------------------------------------------
;/*
;CVAPI(int)  cvGetSeqReaderPos( CvSeqReader* reader );
;
;
Func _cvGetSeqReaderPos( $cvreader )

local $_aResult = DllCall($_opencv_core , "int:cdecl" , "cvGetSeqReaderPos" , "ptr" , $cvreader )
If @error Then ConsoleWrite( "error in cvGetSeqReaderPos")

Return $_aResult[0]
EndFunc ;==>_cvGetSeqReaderPos


;------------------------------------------------
;/*
;CVAPI(void)   cvSetSeqReaderPos( CvSeqReader* reader, int index, int is_relative CV_DEFAULT(0));
;
;
Func _cvSetSeqReaderPos( $cvreader , $cvindex , $cvis_relative )

DllCall($_opencv_core , "none:cdecl" , "cvSetSeqReaderPos" , "ptr" , $cvreader , "int" , $cvindex , "int" , $cvis_relative )
If @error Then ConsoleWrite( "error in cvSetSeqReaderPos")

Return
EndFunc ;==>_cvSetSeqReaderPos


;------------------------------------------------
;/*
;CVAPI(void*)  cvCvtSeqToArray( const CvSeq* seq, void* elements, CvSlice slice CV_DEFAULT(CV_WHOLE_SEQ) );
;
;
Func _cvCvtSeqToArray( $cvseq , $cvelements , $cvslice )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvCvtSeqToArray" , "ptr" , $cvseq , "ptr" , $cvelements , "ptr" , $cvslice )
If @error Then ConsoleWrite( "error in cvCvtSeqToArray")

Return $_aResult[0]
EndFunc ;==>_cvCvtSeqToArray


;------------------------------------------------
;/*
;CVAPI(CvSeq*) cvMakeSeqHeaderForArray( int seq_type, int header_size, int elem_size, void* elements, int total, CvSeq* seq, CvSeqBlock* block );
;
;
Func _cvMakeSeqHeaderForArray( $cvseq_type , $cvheader_size , $cvelem_size , $cvelements , $cvtotal , $cvseq , $cvblock )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvMakeSeqHeaderForArray" , "int" , $cvseq_type , "int" , $cvheader_size , "int" , $cvelem_size , "ptr" , $cvelements , "int" , $cvtotal , "ptr" , $cvseq , "ptr" , $cvblock )
If @error Then ConsoleWrite( "error in cvMakeSeqHeaderForArray")

Return $_aResult[0]
EndFunc ;==>_cvMakeSeqHeaderForArray


;------------------------------------------------
;/*
;CVAPI(CvSeq*) cvSeqSlice( const CvSeq* seq, CvSlice slice, CvMemStorage* storage CV_DEFAULT(NULL), int copy_data CV_DEFAULT(0));
;
;
Func _cvSeqSlice( $cvseq , $cvslice , $cvstorage , $cvcopy_data )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvSeqSlice" , "ptr" , $cvseq , "ptr" , $cvslice , "ptr" , $cvstorage , "int" , $cvcopy_data )
If @error Then ConsoleWrite( "error in cvSeqSlice")

Return $_aResult[0]
EndFunc ;==>_cvSeqSlice


;------------------------------------------------
;/*
;CVAPI(void)  cvSeqRemoveSlice( CvSeq* seq, CvSlice slice );
;
;
Func _cvSeqRemoveSlice( $cvseq , $cvslice )

DllCall($_opencv_core , "none:cdecl" , "cvSeqRemoveSlice" , "ptr" , $cvseq , "ptr" , $cvslice )
If @error Then ConsoleWrite( "error in cvSeqRemoveSlice")

Return
EndFunc ;==>_cvSeqRemoveSlice


;------------------------------------------------
;/*
;CVAPI(void)  cvSeqInsertSlice( CvSeq* seq, int before_index, const CvArr* from_arr );
;
;
Func _cvSeqInsertSlice( $cvseq , $cvbefore_index , $cvfrom_arr )

DllCall($_opencv_core , "none:cdecl" , "cvSeqInsertSlice" , "ptr" , $cvseq , "int" , $cvbefore_index , "ptr" , $cvfrom_arr )
If @error Then ConsoleWrite( "error in cvSeqInsertSlice")

Return
EndFunc ;==>_cvSeqInsertSlice


;------------------------------------------------
;/*
;CVAPI(void) cvSeqSort( CvSeq* seq, CvCmpFunc func, void* userdata CV_DEFAULT(NULL) );
;
;
Func _cvSeqSort( $cvseq , $cvfunc , $cvuserdata )

DllCall($_opencv_core , "none:cdecl" , "cvSeqSort" , "ptr" , $cvseq , "ptr" , $cvfunc , "ptr" , $cvuserdata )
If @error Then ConsoleWrite( "error in cvSeqSort")

Return
EndFunc ;==>_cvSeqSort


;------------------------------------------------
;/*
;CVAPI(schar*) cvSeqSearch( CvSeq* seq, const void* elem, CvCmpFunc func, int is_sorted, int* elem_idx, void* userdata CV_DEFAULT(NULL) );
;
;
Func _cvSeqSearch( $cvseq , $cvelem , $cvfunc , $cvis_sorted , $cvelem_idx , $cvuserdata )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvSeqSearch" , "ptr" , $cvseq , "ptr" , $cvelem , "ptr" , $cvfunc , "int" , $cvis_sorted , "ptr" , $cvelem_idx , "ptr" , $cvuserdata )
If @error Then ConsoleWrite( "error in cvSeqSearch")

Return $_aResult[0]
EndFunc ;==>_cvSeqSearch


;------------------------------------------------
;/*
;CVAPI(void) cvSeqInvert( CvSeq* seq );
;
;
Func _cvSeqInvert( $cvseq )

DllCall($_opencv_core , "none:cdecl" , "cvSeqInvert" , "ptr" , $cvseq )
If @error Then ConsoleWrite( "error in cvSeqInvert")

Return
EndFunc ;==>_cvSeqInvert


;------------------------------------------------
;/*
;CVAPI(int)  cvSeqPartition( const CvSeq* seq, CvMemStorage* storage, CvSeq** labels, CvCmpFunc is_equal, void* userdata );
;
;
Func _cvSeqPartition( $cvseq , $cvstorage , $cvlabels , $cvis_equal , $cvuserdata )

local $_aResult = DllCall($_opencv_core , "int:cdecl" , "cvSeqPartition" , "ptr" , $cvseq , "ptr" , $cvstorage , "ptr*" , $cvlabels , "ptr" , $cvis_equal , "ptr" , $cvuserdata )
If @error Then ConsoleWrite( "error in cvSeqPartition")

Return $_aResult[0]
EndFunc ;==>_cvSeqPartition


;------------------------------------------------
;/*
;CVAPI(void)  cvChangeSeqBlock( void* reader, int direction );
;
;
Func _cvChangeSeqBlock( $cvreader , $cvdirection )

DllCall($_opencv_core , "none:cdecl" , "cvChangeSeqBlock" , "ptr" , $cvreader , "int" , $cvdirection )
If @error Then ConsoleWrite( "error in cvChangeSeqBlock")

Return
EndFunc ;==>_cvChangeSeqBlock


;------------------------------------------------
;/*
;CVAPI(void)  cvCreateSeqBlock( CvSeqWriter* writer );
;
;
Func _cvCreateSeqBlock( $cvwriter )

DllCall($_opencv_core , "none:cdecl" , "cvCreateSeqBlock" , "ptr" , $cvwriter )
If @error Then ConsoleWrite( "error in cvCreateSeqBlock")

Return
EndFunc ;==>_cvCreateSeqBlock


;------------------------------------------------
;/*
;CVAPI(CvSet*)  cvCreateSet( int set_flags, int header_size, int elem_size, CvMemStorage* storage );
;
;
Func _cvCreateSet( $cvset_flags , $cvheader_size , $cvelem_size , $cvstorage )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvCreateSet" , "int" , $cvset_flags , "int" , $cvheader_size , "int" , $cvelem_size , "ptr" , $cvstorage )
If @error Then ConsoleWrite( "error in cvCreateSet")

Return $_aResult[0]
EndFunc ;==>_cvCreateSet


;------------------------------------------------
;/*
;CVAPI(int)  cvSetAdd( CvSet* set_header, CvSetElem* elem CV_DEFAULT(NULL), CvSetElem** inserted_elem CV_DEFAULT(NULL) );
;
;
Func _cvSetAdd( $cvset_header , $cvelem , $cvinserted_elem )

local $_aResult = DllCall($_opencv_core , "int:cdecl" , "cvSetAdd" , "ptr" , $cvset_header , "ptr" , $cvelem , "ptr*" , $cvinserted_elem )
If @error Then ConsoleWrite( "error in cvSetAdd")

Return $_aResult[0]
EndFunc ;==>_cvSetAdd


;------------------------------------------------
;/*
;CVAPI(void)   cvSetRemove( CvSet* set_header, int index );
;
;
Func _cvSetRemove( $cvset_header , $cvindex )

DllCall($_opencv_core , "none:cdecl" , "cvSetRemove" , "ptr" , $cvset_header , "int" , $cvindex )
If @error Then ConsoleWrite( "error in cvSetRemove")

Return
EndFunc ;==>_cvSetRemove


;------------------------------------------------
;/*
;CVAPI(void)  cvClearSet( CvSet* set_header );
;
;
Func _cvClearSet( $cvset_header )

DllCall($_opencv_core , "none:cdecl" , "cvClearSet" , "ptr" , $cvset_header )
If @error Then ConsoleWrite( "error in cvClearSet")

Return
EndFunc ;==>_cvClearSet


;------------------------------------------------
;/*
;CVAPI(CvGraph*)  cvCreateGraph( int graph_flags, int header_size, int vtx_size, int edge_size, CvMemStorage* storage );
;
;
Func _cvCreateGraph( $cvgraph_flags , $cvheader_size , $cvvtx_size , $cvedge_size , $cvstorage )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvCreateGraph" , "int" , $cvgraph_flags , "int" , $cvheader_size , "int" , $cvvtx_size , "int" , $cvedge_size , "ptr" , $cvstorage )
If @error Then ConsoleWrite( "error in cvCreateGraph")

Return $_aResult[0]
EndFunc ;==>_cvCreateGraph


;------------------------------------------------
;/*
;CVAPI(int)  cvGraphAddVtx( CvGraph* graph, const CvGraphVtx* vtx
;
;
Func _cvGraphAddVtx( $cvgraph , $cvvtx )

local $_aResult = DllCall($_opencv_core , "int:cdecl" , "cvGraphAddVtx" , "ptr" , $cvgraph , "ptr" , $cvvtx )
If @error Then ConsoleWrite( "error in cvGraphAddVtx")

Return $_aResult[0]
EndFunc ;==>_cvGraphAddVtx


;------------------------------------------------
;/*
;CVAPI(int)  cvGraphRemoveVtx( CvGraph* graph, int index );
;
;
Func _cvGraphRemoveVtx( $cvgraph , $cvindex )

local $_aResult = DllCall($_opencv_core , "int:cdecl" , "cvGraphRemoveVtx" , "ptr" , $cvgraph , "int" , $cvindex )
If @error Then ConsoleWrite( "error in cvGraphRemoveVtx")

Return $_aResult[0]
EndFunc ;==>_cvGraphRemoveVtx


;------------------------------------------------
;/*
;CVAPI(int)  cvGraphRemoveVtxByPtr( CvGraph* graph, CvGraphVtx* vtx );
;
;
Func _cvGraphRemoveVtxByPtr( $cvgraph , $cvvtx )

local $_aResult = DllCall($_opencv_core , "int:cdecl" , "cvGraphRemoveVtxByPtr" , "ptr" , $cvgraph , "ptr" , $cvvtx )
If @error Then ConsoleWrite( "error in cvGraphRemoveVtxByPtr")

Return $_aResult[0]
EndFunc ;==>_cvGraphRemoveVtxByPtr


;------------------------------------------------
;/*
;CVAPI(int)  cvGraphAddEdge( CvGraph* graph, int start_idx, int end_idx, const CvGraphEdge* edge CV_DEFAULT(NULL), CvGraphEdge** inserted_edge CV_DEFAULT(NULL) );
;
;
Func _cvGraphAddEdge( $cvgraph , $cvstart_idx , $cvend_idx , $cvedge , $cvinserted_edge )

local $_aResult = DllCall($_opencv_core , "int:cdecl" , "cvGraphAddEdge" , "ptr" , $cvgraph , "int" , $cvstart_idx , "int" , $cvend_idx , "ptr" , $cvedge , "ptr*" , $cvinserted_edge )
If @error Then ConsoleWrite( "error in cvGraphAddEdge")

Return $_aResult[0]
EndFunc ;==>_cvGraphAddEdge


;------------------------------------------------
;/*
;CVAPI(int)  cvGraphAddEdgeByPtr( CvGraph* graph, CvGraphVtx* start_vtx, CvGraphVtx* end_vtx, const CvGraphEdge* edge CV_DEFAULT(NULL), CvGraphEdge** inserted_edge CV_DEFAULT(NULL) );
;
;
Func _cvGraphAddEdgeByPtr( $cvgraph , $cvstart_vtx , $cvend_vtx , $cvedge , $cvinserted_edge )

local $_aResult = DllCall($_opencv_core , "int:cdecl" , "cvGraphAddEdgeByPtr" , "ptr" , $cvgraph , "ptr" , $cvstart_vtx , "ptr" , $cvend_vtx , "ptr" , $cvedge , "ptr*" , $cvinserted_edge )
If @error Then ConsoleWrite( "error in cvGraphAddEdgeByPtr")

Return $_aResult[0]
EndFunc ;==>_cvGraphAddEdgeByPtr


;------------------------------------------------
;/*
;CVAPI(void)  cvGraphRemoveEdge( CvGraph* graph, int start_idx, int end_idx );
;
;
Func _cvGraphRemoveEdge( $cvgraph , $cvstart_idx , $cvend_idx )

DllCall($_opencv_core , "none:cdecl" , "cvGraphRemoveEdge" , "ptr" , $cvgraph , "int" , $cvstart_idx , "int" , $cvend_idx )
If @error Then ConsoleWrite( "error in cvGraphRemoveEdge")

Return
EndFunc ;==>_cvGraphRemoveEdge


;------------------------------------------------
;/*
;CVAPI(void)  cvGraphRemoveEdgeByPtr( CvGraph* graph, CvGraphVtx* start_vtx, CvGraphVtx* end_vtx );
;
;
Func _cvGraphRemoveEdgeByPtr( $cvgraph , $cvstart_vtx , $cvend_vtx )

DllCall($_opencv_core , "none:cdecl" , "cvGraphRemoveEdgeByPtr" , "ptr" , $cvgraph , "ptr" , $cvstart_vtx , "ptr" , $cvend_vtx )
If @error Then ConsoleWrite( "error in cvGraphRemoveEdgeByPtr")

Return
EndFunc ;==>_cvGraphRemoveEdgeByPtr


;------------------------------------------------
;/*
;CVAPI(CvGraphEdge*)  cvFindGraphEdge( const CvGraph* graph, int start_idx, int end_idx );
;
;
Func _cvFindGraphEdge( $cvgraph , $cvstart_idx , $cvend_idx )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvFindGraphEdge" , "ptr" , $cvgraph , "int" , $cvstart_idx , "int" , $cvend_idx )
If @error Then ConsoleWrite( "error in cvFindGraphEdge")

Return $_aResult[0]
EndFunc ;==>_cvFindGraphEdge


;------------------------------------------------
;/*
;CVAPI(CvGraphEdge*)  cvFindGraphEdgeByPtr( const CvGraph* graph, const CvGraphVtx* start_vtx, const CvGraphVtx* end_vtx );
;
;
Func _cvFindGraphEdgeByPtr( $cvgraph , $cvstart_vtx , $cvend_vtx )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvFindGraphEdgeByPtr" , "ptr" , $cvgraph , "ptr" , $cvstart_vtx , "ptr" , $cvend_vtx )
If @error Then ConsoleWrite( "error in cvFindGraphEdgeByPtr")

Return $_aResult[0]
EndFunc ;==>_cvFindGraphEdgeByPtr


;------------------------------------------------
;/*
;CVAPI(void)  cvClearGraph( CvGraph* graph );
;
;
Func _cvClearGraph( $cvgraph )

DllCall($_opencv_core , "none:cdecl" , "cvClearGraph" , "ptr" , $cvgraph )
If @error Then ConsoleWrite( "error in cvClearGraph")

Return
EndFunc ;==>_cvClearGraph


;------------------------------------------------
;/*
;CVAPI(int)  cvGraphVtxDegree( const CvGraph* graph, int vtx_idx );
;
;
Func _cvGraphVtxDegree( $cvgraph , $cvvtx_idx )

local $_aResult = DllCall($_opencv_core , "int:cdecl" , "cvGraphVtxDegree" , "ptr" , $cvgraph , "int" , $cvvtx_idx )
If @error Then ConsoleWrite( "error in cvGraphVtxDegree")

Return $_aResult[0]
EndFunc ;==>_cvGraphVtxDegree


;------------------------------------------------
;/*
;CVAPI(int)  cvGraphVtxDegreeByPtr( const CvGraph* graph, const CvGraphVtx* vtx );
;
;
Func _cvGraphVtxDegreeByPtr( $cvgraph , $cvvtx )

local $_aResult = DllCall($_opencv_core , "int:cdecl" , "cvGraphVtxDegreeByPtr" , "ptr" , $cvgraph , "ptr" , $cvvtx )
If @error Then ConsoleWrite( "error in cvGraphVtxDegreeByPtr")

Return $_aResult[0]
EndFunc ;==>_cvGraphVtxDegreeByPtr


;------------------------------------------------
;/*
;CVAPI(CvGraphScanner*)  cvCreateGraphScanner( CvGraph* graph, CvGraphVtx* vtx CV_DEFAULT(NULL), int mask CV_DEFAULT(CV_GRAPH_ALL_ITEMS));
;
;
Func _cvCreateGraphScanner( $cvgraph , $cvvtx , $cvmask )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvCreateGraphScanner" , "ptr" , $cvgraph , "ptr" , $cvvtx , "int" , $cvmask )
If @error Then ConsoleWrite( "error in cvCreateGraphScanner")

Return $_aResult[0]
EndFunc ;==>_cvCreateGraphScanner


;------------------------------------------------
;/*
;CVAPI(void) cvReleaseGraphScanner( CvGraphScanner** scanner );
;
;
Func _cvReleaseGraphScanner( $cvscanner )

DllCall($_opencv_core , "none:cdecl" , "cvReleaseGraphScanner" , "ptr*" , $cvscanner )
If @error Then ConsoleWrite( "error in cvReleaseGraphScanner")

Return
EndFunc ;==>_cvReleaseGraphScanner


;------------------------------------------------
;/*
;CVAPI(int)  cvNextGraphItem( CvGraphScanner* scanner );
;
;
Func _cvNextGraphItem( $cvscanner )

local $_aResult = DllCall($_opencv_core , "int:cdecl" , "cvNextGraphItem" , "ptr" , $cvscanner )
If @error Then ConsoleWrite( "error in cvNextGraphItem")

Return $_aResult[0]
EndFunc ;==>_cvNextGraphItem


;------------------------------------------------
;/*
;CVAPI(CvGraph*) cvCloneGraph( const CvGraph* graph, CvMemStorage* storage );
;
;
Func _cvCloneGraph( $cvgraph , $cvstorage )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvCloneGraph" , "ptr" , $cvgraph , "ptr" , $cvstorage )
If @error Then ConsoleWrite( "error in cvCloneGraph")

Return $_aResult[0]
EndFunc ;==>_cvCloneGraph


;------------------------------------------------
;/*
;CVAPI(void)  cvLine( CvArr* img, CvPoint pt1, CvPoint pt2, CvScalar color, int thickness CV_DEFAULT(1), int line_type CV_DEFAULT(8), int shift CV_DEFAULT(0) );
;
;
Func _cvLine( $cvimg , $cvpt1 , $cvpt2 , $cvcolor , $cvthickness , $cvline_type , $cvshift )

DllCall($_opencv_core , "none:cdecl" , "cvLine" , "ptr" , $cvimg , "struct" , $cvpt1 , "struct" , $cvpt2 , "struct" , $cvcolor , "int" , $cvthickness , "int" , $cvline_type , "int" , $cvshift )
If @error Then ConsoleWrite( "error in cvLine")

Return
EndFunc ;==>_cvLine


;------------------------------------------------
;/*
;CVAPI(void)  cvRectangle( CvArr* img, CvPoint pt1, CvPoint pt2, CvScalar color, int thickness CV_DEFAULT(1), int line_type CV_DEFAULT(8), int shift CV_DEFAULT(0));
;
;
Func _cvRectangle( $cvimg , $cvpt1 , $cvpt2 , $cvcolor , $cvthickness , $cvline_type , $cvshift )

DllCall($_opencv_core , "none:cdecl" , "cvRectangle" , "ptr" , $cvimg , "struct" , $cvpt1 , "struct" , $cvpt2 , "struct" , $cvcolor , "int" , $cvthickness , "int" , $cvline_type , "int" , $cvshift )
If @error Then ConsoleWrite( "error in cvRectangle")

Return
EndFunc ;==>_cvRectangle


;------------------------------------------------
;/*
;CVAPI(void)  cvRectangleR( CvArr* img, CvRect r, CvScalar color, int thickness CV_DEFAULT(1), int line_type CV_DEFAULT(8), int shift CV_DEFAULT(0));
;
;
Func _cvRectangleR( $cvimg , $cvr , $cvcolor , $cvthickness , $cvline_type , $cvshift )

DllCall($_opencv_core , "none:cdecl" , "cvRectangleR" , "ptr" , $cvimg , "struct" , $cvr , "struct" , $cvcolor , "int" , $cvthickness , "int" , $cvline_type , "int" , $cvshift )
If @error Then ConsoleWrite( "error in cvRectangleR")

Return
EndFunc ;==>_cvRectangleR


;------------------------------------------------
;/*
;CVAPI(void)  cvCircle( CvArr* img, CvPoint center, int radius, CvScalar color, int thickness CV_DEFAULT(1), int line_type CV_DEFAULT(8), int shift CV_DEFAULT(0));
;
;
Func _cvCircle( $cvimg , $cvcenter , $cvradius , $cvcolor , $cvthickness , $cvline_type , $cvshift )

DllCall($_opencv_core , "none:cdecl" , "cvCircle" , "ptr" , $cvimg , "struct" , $cvcenter , "int" , $cvradius , "struct" , $cvcolor , "int" , $cvthickness , "int" , $cvline_type , "int" , $cvshift )
If @error Then ConsoleWrite( "error in cvCircle")

Return
EndFunc ;==>_cvCircle


;------------------------------------------------
;/*
;CVAPI(void)  cvEllipse( CvArr* img, CvPoint center, CvSize axes, double angle, double start_angle, double end_angle, CvScalar color, int thickness CV_DEFAULT(1), int line_type CV_DEFAULT(8), int shift CV_DEFAULT(0));
;
;
Func _cvEllipse( $cvimg , $cvcenter , $cvaxes , $cvangle , $cvstart_angle , $cvend_angle , $cvcolor , $cvthickness , $cvline_type , $cvshift )

DllCall($_opencv_core , "none:cdecl" , "cvEllipse" , "ptr" , $cvimg , "struct" , $cvcenter , "struct" , $cvaxes , "double" , $cvangle , "double" , $cvstart_angle , "double" , $cvend_angle , "struct" , $cvcolor , "int" , $cvthickness , "int" , $cvline_type , "int" , $cvshift )
If @error Then ConsoleWrite( "error in cvEllipse")

Return
EndFunc ;==>_cvEllipse


;------------------------------------------------
;/*
;CVAPI(void)  cvFillConvexPoly( CvArr* img, const CvPoint* pts, int npts, CvScalar color, int line_type CV_DEFAULT(8), int shift CV_DEFAULT(0));
;
;
Func _cvFillConvexPoly( $cvimg , $cvpts , $cvnpts , $cvcolor , $cvline_type , $cvshift )

DllCall($_opencv_core , "none:cdecl" , "cvFillConvexPoly" , "ptr" , $cvimg , "ptr" , $cvpts , "Int" , $cvnpts , "struct" , $cvcolor , "int" , $cvline_type , "int" , $cvshift )
If @error Then ConsoleWrite( "error in cvFillConvexPoly")

Return
EndFunc ;==>_cvFillConvexPoly


;------------------------------------------------
;/*
;CVAPI(void)  cvFillPoly( CvArr* img, CvPoint** pts, const int* npts, int contours, CvScalar color, int line_type CV_DEFAULT(8), int shift CV_DEFAULT(0) );
;
;
Func _cvFillPoly( $cvimg , $cvpts , $cvnpts , $cvcontours , $cvcolor , $cvline_type , $cvshift )

DllCall($_opencv_core , "none:cdecl" , "cvFillPoly" , "ptr" , $cvimg , "ptr*" , $cvpts , "ptr" , $cvnpts , "int" , $cvcontours , "struct" , $cvcolor , "int" , $cvline_type , "int" , $cvshift )
If @error Then ConsoleWrite( "error in cvFillPoly")

Return
EndFunc ;==>_cvFillPoly


;------------------------------------------------
;/*
;CVAPI(void)  cvPolyLine( CvArr* img, CvPoint** pts, const int* npts, int contours, int is_closed, CvScalar color, int thickness CV_DEFAULT(1), int line_type CV_DEFAULT(8), int shift CV_DEFAULT(0) );
;
;
Func _cvPolyLine( $cvimg , $cvpts , $cvnpts , $cvcontours , $cvis_closed , $cvcolor , $cvthickness , $cvline_type , $cvshift )

DllCall($_opencv_core , "none:cdecl" , "cvPolyLine" , "ptr" , $cvimg , "ptr*" , $cvpts , "ptr" , $cvnpts , "int" , $cvcontours , "int" , $cvis_closed , "struct" , $cvcolor , "int" , $cvthickness , "int" , $cvline_type , "int" , $cvshift )
If @error Then ConsoleWrite( "error in cvPolyLine")

Return
EndFunc ;==>_cvPolyLine


;------------------------------------------------
;/*
;CVAPI(int) cvClipLine( CvSize img_size, CvPoint* pt1, CvPoint* pt2 );
;
;
Func _cvClipLine( $cvimg_size , $cvpt1 , $cvpt2 )

local $_aResult = DllCall($_opencv_core , "int:cdecl" , "cvClipLine" , "struct" , $cvimg_size , "ptr" , $cvpt1 , "ptr" , $cvpt2 )
If @error Then ConsoleWrite( "error in cvClipLine")

Return $_aResult[0]
EndFunc ;==>_cvClipLine


;------------------------------------------------
;/*
;CVAPI(int)  cvInitLineIterator( const CvArr* image, CvPoint pt1, CvPoint pt2, CvLineIterator* line_iterator, int connectivity CV_DEFAULT(8), int left_to_right CV_DEFAULT(0));
;
;
Func _cvInitLineIterator( $cvimage , $cvpt1 , $cvpt2 , $cvline_iterator , $cvconnectivity , $cvleft_to_right )

local $_aResult = DllCall($_opencv_core , "int:cdecl" , "cvInitLineIterator" , "ptr" , $cvimage , "struct" , $cvpt1 , "struct" , $cvpt2 , "ptr" , $cvline_iterator , "int" , $cvconnectivity , "int" , $cvleft_to_right )
If @error Then ConsoleWrite( "error in cvInitLineIterator")

Return $_aResult[0]
EndFunc ;==>_cvInitLineIterator


;------------------------------------------------
;/*
;CVAPI(void)  cvInitFont( CvFont* font, int font_face, double hscale, double vscale, double shear CV_DEFAULT(0), int thickness CV_DEFAULT(1), int line_type CV_DEFAULT(8));
;
;
Func _cvInitFont( $cvfont , $cvfont_face , $cvhscale , $cvvscale , $cvshear , $cvthickness , $cvline_type )

DllCall($_opencv_core , "none:cdecl" , "cvInitFont" , "ptr" , $cvfont , "int" , $cvfont_face , "double" , $cvhscale , "double" , $cvvscale , "double" , $cvshear , "int" , $cvthickness , "int" , $cvline_type )
If @error Then ConsoleWrite( "error in cvInitFont")

Return
EndFunc ;==>_cvInitFont


;------------------------------------------------
;/*
;CVAPI(void)  cvPutText( CvArr* img, const char* text, CvPoint org, const CvFont* font, CvScalar color );
;
;
Func _cvPutText( $cvimg , $cvtext , $cvorg , $cvfont , $cvcolor )

DllCall($_opencv_core , "none:cdecl" , "cvPutText" , "ptr" , $cvimg , "ptr" , $cvtext , "struct" , $cvorg , "ptr" , $cvfont , "struct" , $cvcolor )
If @error Then ConsoleWrite( "error in cvPutText")

Return
EndFunc ;==>_cvPutText


;------------------------------------------------
;/*
;CVAPI(void)  cvGetTextSize( const char* text_string, const CvFont* font, CvSize* text_size, int* baseline );
;
;
Func _cvGetTextSize( $cvtext_string , $cvfont , $cvtext_size , $cvbaseline )

DllCall($_opencv_core , "none:cdecl" , "cvGetTextSize" , "ptr" , $cvtext_string , "ptr" , $cvfont , "ptr" , $cvtext_size , "ptr" , $cvbaseline )
If @error Then ConsoleWrite( "error in cvGetTextSize")

Return
EndFunc ;==>_cvGetTextSize


;------------------------------------------------
;/*
;CVAPI(int) cvEllipse2Poly( CvPoint center, CvSize axes, int angle, int arc_start, int arc_end, CvPoint * pts, int delta );
;
;
Func _cvEllipse2Poly( $cvcenter , $cvaxes , $cvangle , $cvarc_start , $cvarc_end , $cvpts , $cvdelta )

local $_aResult = DllCall($_opencv_core , "int:cdecl" , "cvEllipse2Poly" , "struct" , $cvcenter , "struct" , $cvaxes , "int" , $cvangle , "int" , $cvarc_start , "int" , $cvarc_end , "ptr" , $cvpts , "int" , $cvdelta )
If @error Then ConsoleWrite( "error in cvEllipse2Poly")

Return $_aResult[0]
EndFunc ;==>_cvEllipse2Poly

;------------------------------------------------
;/*
;CVAPI(void)  cvDrawContours( CvArr *img, CvSeq* contour,
;                             CvScalar external_color, CvScalar hole_color,
;                             int max_level, int thickness CV_DEFAULT(1),
;                             int line_type CV_DEFAULT(8),
;                             CvPoint offset CV_DEFAULT(cvPoint(0,0)));
;
Func _cvDrawContours( $cvimg , $cvcontour , $cvexternal_color , $cvhole_color , $cvmax_level , $cvthickness , $cvline_type, $cvoffset )

local $_aResult = DllCall($_opencv_core , "none:cdecl" , "cvDrawContours" , "ptr" , $cvimg , "ptr" , $cvcontour , "struct" ,  $cvexternal_color , "struct" , $cvhole_color , "int" , $cvmax_level , "int" , $cvthickness , "int" , $cvline_type, "struct" , $cvoffset )
If @error Then ConsoleWrite( "error in cvDrawContours")

Return
EndFunc ;==>_cvDrawContours

;------------------------------------------------
;/*
;CVAPI(void) cvLUT( const CvArr* src, CvArr* dst, const CvArr* lut );
;
;
Func _cvLUT( $cvsrc , $cvdst , $cvlut )

DllCall($_opencv_core , "none:cdecl" , "cvLUT" , "ptr" , $cvsrc , "ptr" , $cvdst , "ptr" , $cvlut )
If @error Then ConsoleWrite( "error in cvLUT")

Return
EndFunc ;==>_cvLUT


;------------------------------------------------
;/*
;CVAPI(void) cvInitTreeNodeIterator( CvTreeNodeIterator* tree_iterator, const void* first, int max_level );
;
;
Func _cvInitTreeNodeIterator( $cvtree_iterator , $cvfirst , $cvmax_level )

DllCall($_opencv_core , "none:cdecl" , "cvInitTreeNodeIterator" , "ptr" , $cvtree_iterator , "ptr" , $cvfirst , "int" , $cvmax_level )
If @error Then ConsoleWrite( "error in cvInitTreeNodeIterator")

Return
EndFunc ;==>_cvInitTreeNodeIterator


;------------------------------------------------
;/*
;CVAPI(void*) cvNextTreeNode( CvTreeNodeIterator* tree_iterator );
;
;
Func _cvNextTreeNode( $cvtree_iterator )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvNextTreeNode" , "ptr" , $cvtree_iterator )
If @error Then ConsoleWrite( "error in cvNextTreeNode")

Return $_aResult[0]
EndFunc ;==>_cvNextTreeNode


;------------------------------------------------
;/*
;CVAPI(void*) cvPrevTreeNode( CvTreeNodeIterator* tree_iterator );
;
;
Func _cvPrevTreeNode( $cvtree_iterator )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvPrevTreeNode" , "ptr" , $cvtree_iterator )
If @error Then ConsoleWrite( "error in cvPrevTreeNode")

Return $_aResult[0]
EndFunc ;==>_cvPrevTreeNode


;------------------------------------------------
;/*
;CVAPI(void) cvInsertNodeIntoTree( void* node, void* parent, void* frame );
;
;
Func _cvInsertNodeIntoTree( $cvnode , $cvparent , $cvframe )

DllCall($_opencv_core , "none:cdecl" , "cvInsertNodeIntoTree" , "ptr" , $cvnode , "ptr" , $cvparent , "ptr" , $cvframe )
If @error Then ConsoleWrite( "error in cvInsertNodeIntoTree")

Return
EndFunc ;==>_cvInsertNodeIntoTree


;------------------------------------------------
;/*
;CVAPI(void) cvRemoveNodeFromTree( void* node, void* frame );
;
;
Func _cvRemoveNodeFromTree( $cvnode , $cvframe )

DllCall($_opencv_core , "none:cdecl" , "cvRemoveNodeFromTree" , "ptr" , $cvnode , "ptr" , $cvframe )
If @error Then ConsoleWrite( "error in cvRemoveNodeFromTree")

Return
EndFunc ;==>_cvRemoveNodeFromTree


;------------------------------------------------
;/*
;CVAPI(CvSeq*) cvTreeToNodeSeq( const void* first, int header_size, CvMemStorage* storage );
;
;
Func _cvTreeToNodeSeq( $cvfirst , $cvheader_size , $cvstorage )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvTreeToNodeSeq" , "ptr" , $cvfirst , "int" , $cvheader_size , "ptr" , $cvstorage )
If @error Then ConsoleWrite( "error in cvTreeToNodeSeq")

Return $_aResult[0]
EndFunc ;==>_cvTreeToNodeSeq


;------------------------------------------------
;/*
;CVAPI(int) cvKMeans2( const CvArr* samples, int cluster_count, CvArr* labels, CvTermCriteria termcrit, int attempts CV_DEFAULT(1), CvRNG* rng CV_DEFAULT(0), int flags CV_DEFAULT(0), CvArr* _centers CV_DEFAULT(0), double* compactness CV_DEFAULT(0) );
;
;
Func _cvKMeans2( $cvsamples , $cvcluster_count , $cvlabels , $cvtermcrit , $cvattempts , $cvrng , $cvflags , $cv_centers , $cvcompactness )

local $_aResult = DllCall($_opencv_core , "int:cdecl" , "cvKMeans2" , "ptr" , $cvsamples , "int" , $cvcluster_count , "ptr" , $cvlabels , "struct" , $cvtermcrit , "int" , $cvattempts , "ptr" , $cvrng , "int" , $cvflags , "ptr" , $cv_centers , "ptr" , $cvcompactness )
If @error Then ConsoleWrite( "error in cvKMeans2")

Return $_aResult[0]
EndFunc ;==>_cvKMeans2


;------------------------------------------------
;/*
;CVAPI(int)  cvRegisterModule( const CvModuleInfo* module_info );
;
;
Func _cvRegisterModule( $cvmodule_info )

local $_aResult = DllCall($_opencv_core , "int:cdecl" , "cvRegisterModule" , "ptr" , $cvmodule_info )
If @error Then ConsoleWrite( "error in cvRegisterModule")

Return $_aResult[0]
EndFunc ;==>_cvRegisterModule


;------------------------------------------------
;/*
;CVAPI(int)  cvUseOptimized( int on_off );
;
;
Func _cvUseOptimized( $cvon_off )

local $_aResult = DllCall($_opencv_core , "int:cdecl" , "cvUseOptimized" , "int" , $cvon_off )
If @error Then ConsoleWrite( "error in cvUseOptimized")

Return $_aResult[0]
EndFunc ;==>_cvUseOptimized


;------------------------------------------------
;/*
;CVAPI(void)  cvGetModuleInfo( const char* module_name, const char** version, const char** loaded_addon_plugins );
;
;
Func _cvGetModuleInfo( $cvmodule_name , $cvversion , $cvloaded_addon_plugins )

DllCall($_opencv_core , "none:cdecl" , "cvGetModuleInfo" , "ptr" , $cvmodule_name , "ptr*" , $cvversion , "ptr*" , $cvloaded_addon_plugins )
If @error Then ConsoleWrite( "error in cvGetModuleInfo")

Return
EndFunc ;==>_cvGetModuleInfo


;------------------------------------------------
;/*
;CVAPI(const char*) cvAttrValue( const CvAttrList* attr, const char* attr_name );
;
;
Func _cvAttrValue( $cvattr , $cvattr_name )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvAttrValue" , "ptr" , $cvattr , "ptr" , $cvattr_name )
If @error Then ConsoleWrite( "error in cvAttrValue")

Return $_aResult[0]
EndFunc ;==>_cvAttrValue


;------------------------------------------------
;/*
;CVAPI(void) cvRelease( void** struct_ptr );
;
;
Func _cvRelease( $cvstruct_ptr )

DllCall($_opencv_core , "none:cdecl" , "cvRelease" , "ptr*" , $cvstruct_ptr )
If @error Then ConsoleWrite( "error in cvRelease")

Return
EndFunc ;==>_cvRelease


;------------------------------------------------
;/*
;CVAPI(void*) cvClone( const void* struct_ptr );
;
;
Func _cvClone( $cvstruct_ptr )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvClone" , "ptr" , $cvstruct_ptr )
If @error Then ConsoleWrite( "error in cvClone")

Return $_aResult[0]
EndFunc ;==>_cvClone


;------------------------------------------------
;/*
;CVAPI(int) cvCheckHardwareSupport(int feature);
;
;
Func _cvCheckHardwareSupport( $cvfeature); )

local $_aResult = DllCall($_opencv_core , "int:cdecl" , "cvCheckHardwareSupport" , "int" , $cvfeature); )
If @error Then ConsoleWrite( "error in cvCheckHardwareSupport")

Return $_aResult[0]
EndFunc ;==>_cvCheckHardwareSupport


;------------------------------------------------
;/*
;CVAPI(int)  cvGetNumThreads( void );
;
;
Func _cvGetNumThreads( $cv); )

local $_aResult = DllCall($_opencv_core , "int:cdecl" , "cvGetNumThreads" , "none" , $cv); )
If @error Then ConsoleWrite( "error in cvGetNumThreads")

Return $_aResult[0]
EndFunc ;==>_cvGetNumThreads


;------------------------------------------------
;/*
;CVAPI(void) cvSetNumThreads( int threads CV_DEFAULT(0) );
;
;
Func _cvSetNumThreads( $cvthreads )

DllCall($_opencv_core , "none:cdecl" , "cvSetNumThreads" , "int" , $cvthreads )
If @error Then ConsoleWrite( "error in cvSetNumThreads")

Return
EndFunc ;==>_cvSetNumThreads


;------------------------------------------------
;/*
;CVAPI(int)  cvGetThreadNum( void );
;
;
Func _cvGetThreadNum( $cv); )

local $_aResult = DllCall($_opencv_core , "int:cdecl" , "cvGetThreadNum" , "none" , $cv); )
If @error Then ConsoleWrite( "error in cvGetThreadNum")

Return $_aResult[0]
EndFunc ;==>_cvGetThreadNum


;------------------------------------------------
;/*
;CVAPI(int) cvGetErrStatus( void );
;
;
Func _cvGetErrStatus( $cv); )

local $_aResult = DllCall($_opencv_core , "int:cdecl" , "cvGetErrStatus" , "none" , $cv); )
If @error Then ConsoleWrite( "error in cvGetErrStatus")

Return $_aResult[0]
EndFunc ;==>_cvGetErrStatus


;------------------------------------------------
;/*
;CVAPI(void) cvSetErrStatus( int status );
;
;
Func _cvSetErrStatus( $cvstatus )

DllCall($_opencv_core , "none:cdecl" , "cvSetErrStatus" , "int" , $cvstatus )
If @error Then ConsoleWrite( "error in cvSetErrStatus")

Return
EndFunc ;==>_cvSetErrStatus


;------------------------------------------------
;/*
;CVAPI(int)  cvGetErrMode( void );
;
;
Func _cvGetErrMode( $cv); )

local $_aResult = DllCall($_opencv_core , "int:cdecl" , "cvGetErrMode" , "none" , $cv); )
If @error Then ConsoleWrite( "error in cvGetErrMode")

Return $_aResult[0]
EndFunc ;==>_cvGetErrMode


;------------------------------------------------
;/*
;CVAPI(int) cvSetErrMode( int mode );
;
;
Func _cvSetErrMode( $cvmode )

local $_aResult = DllCall($_opencv_core , "int:cdecl" , "cvSetErrMode" , "int" , $cvmode )
If @error Then ConsoleWrite( "error in cvSetErrMode")

Return $_aResult[0]
EndFunc ;==>_cvSetErrMode


;------------------------------------------------
;/*
;CVAPI(void) cvError( int status, const char* func_name, const char* err_msg, const char* file_name, int line );
;
;
Func _cvError( $cvstatus , $cvfunc_name , $cverr_msg , $cvfile_name , $cvline )

DllCall($_opencv_core , "none:cdecl" , "cvError" , "int" , $cvstatus , "ptr" , $cvfunc_name , "ptr" , $cverr_msg , "ptr" , $cvfile_name , "int" , $cvline )
If @error Then ConsoleWrite( "error in cvError")

Return
EndFunc ;==>_cvError


;------------------------------------------------
;/*
;CVAPI(const char*) cvErrorStr( int status );
;
;
Func _cvErrorStr( $cvstatus )

local $_aResult = DllCall($_opencv_core , "ptr:cdecl" , "cvErrorStr" , "int" , $cvstatus )
If @error Then ConsoleWrite( "error in cvErrorStr")

Return $_aResult[0]
EndFunc ;==>_cvErrorStr


;------------------------------------------------
;/*
;CVAPI(int) cvGetErrInfo( const char** errcode_desc, const char** description, const char** filename, int* line );
;
;
Func _cvGetErrInfo( $cverrcode_desc , $cvdescription , $cvfilename , $cvline )

local $_aResult = DllCall($_opencv_core , "int:cdecl" , "cvGetErrInfo" , "ptr*" , $cverrcode_desc , "ptr*" , $cvdescription , "ptr*" , $cvfilename , "ptr" , $cvline )
If @error Then ConsoleWrite( "error in cvGetErrInfo")

Return $_aResult[0]
EndFunc ;==>_cvGetErrInfo


;------------------------------------------------
;/*
;CVAPI(int) cvErrorFromIppStatus( int ipp_status );
;
;
Func _cvErrorFromIppStatus( $cvipp_status )

local $_aResult = DllCall($_opencv_core , "int:cdecl" , "cvErrorFromIppStatus" , "int" , $cvipp_status )
If @error Then ConsoleWrite( "error in cvErrorFromIppStatus")

Return $_aResult[0]
EndFunc ;==>_cvErrorFromIppStatus

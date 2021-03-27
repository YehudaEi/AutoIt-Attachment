#include-once

; #INDEX# =======================================================================================================================
; Title .........: CVimgproc
; AutoIt Version : 3.3.10.2
; Language ......: English
; Description ...: Functions that assist with OpenCV
;                  It enables applications to use OpenCV imgproc library functions.
; Author ........: Mylise
; Modified ......:
; Dll ...........: opencv_imgproc245.dll
; ===============================================================================================================================


;------------------------------------------------
;/*
;CVAPI(void)  cvAcc( const CvArr* image, CvArr* sum, const CvArr* mask CV_DEFAULT(NULL) );
;
;
Func _cvAcc( $cvimage , $cvsum , $cvmask = Null )

DllCall($_opencv_imgproc , "none:cdecl" , "cvAcc" , "ptr" , $cvimage , "ptr" , $cvsum , "ptr" , $cvmask )
If @error Then ConsoleWrite( "error in cvAcc")

Return
EndFunc ;==>_cvAcc


;------------------------------------------------
;/*
;CVAPI(void)  cvSquareAcc( const CvArr* image, CvArr* sqsum, const CvArr* mask CV_DEFAULT(NULL) );
;
;
Func _cvSquareAcc( $cvimage , $cvsqsum , $cvmask = Null )

DllCall($_opencv_imgproc , "none:cdecl" , "cvSquareAcc" , "ptr" , $cvimage , "ptr" , $cvsqsum , "ptr" , $cvmask )
If @error Then ConsoleWrite( "error in cvSquareAcc")

Return
EndFunc ;==>_cvSquareAcc


;------------------------------------------------
;/*
;CVAPI(void)  cvMultiplyAcc( const CvArr* image1, const CvArr* image2, CvArr* acc, const CvArr* mask CV_DEFAULT(NULL) );
;
;
Func _cvMultiplyAcc( $cvimage1 , $cvimage2 , $cvacc , $cvmask = Null)

DllCall($_opencv_imgproc , "none:cdecl" , "cvMultiplyAcc" , "ptr" , $cvimage1 , "ptr" , $cvimage2 , "ptr" , $cvacc , "ptr" , $cvmask )
If @error Then ConsoleWrite( "error in cvMultiplyAcc")

Return
EndFunc ;==>_cvMultiplyAcc


;------------------------------------------------
;/*
;CVAPI(void)  cvRunningAvg( const CvArr* image, CvArr* acc, double alpha, const CvArr* mask CV_DEFAULT(NULL) );
;
;
Func _cvRunningAvg( $cvimage , $cvacc , $cvalpha , $cvmask = Null )

DllCall($_opencv_imgproc , "none:cdecl" , "cvRunningAvg" , "ptr" , $cvimage , "ptr" , $cvacc , "double" , $cvalpha , "ptr" , $cvmask )
If @error Then ConsoleWrite( "error in cvRunningAvg")

Return
EndFunc ;==>_cvRunningAvg


;------------------------------------------------
;/*
;CVAPI(void) cvCopyMakeBorder( const CvArr* src, CvArr* dst, CvPoint offset, int bordertype, CvScalar value CV_DEFAULT(cvScalarAll(0)));
;
;
Func _cvCopyMakeBorder( $cvsrc , $cvdst , $cvoffset , $cvbordertype , $cvvalue )

DllCall($_opencv_imgproc , "none:cdecl" , "cvCopyMakeBorder" , "ptr" , $cvsrc , "ptr" , $cvdst , "struct" , $cvoffset , "int" , $cvbordertype , "struct" , $cvvalue )
If @error Then ConsoleWrite( "error in cvCopyMakeBorder")

Return
EndFunc ;==>_cvCopyMakeBorder


;------------------------------------------------
;/*
;CVAPI(void) cvIntegral( const CvArr* image, CvArr* sum, CvArr* sqsum CV_DEFAULT(NULL), CvArr* tilted_sum CV_DEFAULT(NULL));
;
;
Func _cvIntegral( $cvimage , $cvsum , $cvsqsum = Null , $cvtilted_sum = Null )

DllCall($_opencv_imgproc , "none:cdecl" , "cvIntegral" , "ptr" , $cvimage , "ptr" , $cvsum , "ptr" , $cvsqsum , "ptr" , $cvtilted_sum )
If @error Then ConsoleWrite( "error in cvIntegral")

Return
EndFunc ;==>_cvIntegral


;------------------------------------------------
;/*
;CVAPI(void) cvPyrMeanShiftFiltering( const CvArr* src, CvArr* dst, double sp, double sr, int max_level CV_DEFAULT(1), CvTermCriteria termcrit CV_DEFAULT(cvTermCriteria(CV_TERMCRIT_ITER+CV_TERMCRIT_EPS_5_1)));
;
;
Func _cvPyrMeanShiftFiltering( $cvsrc , $cvdst , $cvsp , $cvsr , $cvmax_level  , $cvtermcrit )

DllCall($_opencv_imgproc , "none:cdecl" , "cvPyrMeanShiftFiltering" , "ptr" , $cvsrc , "ptr" , $cvdst , "double" , $cvsp , "double" , $cvsr , "int" , $cvmax_level , "struct" , $cvtermcrit )
If @error Then ConsoleWrite( "error in cvPyrMeanShiftFiltering")

Return
EndFunc ;==>_cvPyrMeanShiftFiltering


;------------------------------------------------
;/*
;CVAPI(void) cvWatershed( const CvArr* image, CvArr* markers );
;
;
Func _cvWatershed( $cvimage , $cvmarkers )

DllCall($_opencv_imgproc , "none:cdecl" , "cvWatershed" , "ptr" , $cvimage , "ptr" , $cvmarkers )
If @error Then ConsoleWrite( "error in cvWatershed")

Return
EndFunc ;==>_cvWatershed


;------------------------------------------------
;/*
;CVAPI(void) cvSobel( const CvArr* src, CvArr* dst, int xorder, int yorder, int aperture_size CV_DEFAULT(3));
;
;
Func _cvSobel( $cvsrc , $cvdst , $cvxorder , $cvyorder , $cvaperture_size = 3 )

DllCall($_opencv_imgproc , "none:cdecl" , "cvSobel" , "ptr" , $cvsrc , "ptr" , $cvdst , "int" , $cvxorder , "int" , $cvyorder , "int" , $cvaperture_size )
If @error Then ConsoleWrite( "error in cvSobel")

Return
EndFunc ;==>_cvSobel


;------------------------------------------------
;/*
;CVAPI(void) cvLaplace( const CvArr* src, CvArr* dst, int aperture_size CV_DEFAULT(3) );
;
;
Func _cvLaplace( $cvsrc , $cvdst , $cvaperture_size = 3 )

DllCall($_opencv_imgproc , "none:cdecl" , "cvLaplace" , "ptr" , $cvsrc , "ptr" , $cvdst , "int" , $cvaperture_size )
If @error Then ConsoleWrite( "error in cvLaplace")

Return
EndFunc ;==>_cvLaplace


;------------------------------------------------
;/*
;CVAPI(void)  cvResize( const CvArr* src, CvArr* dst, int interpolation CV_DEFAULT( CV_INTER_LINEAR ));
;
;
Func _cvResize( $cvsrc , $cvdst , $cvinterpolation = $CV_INTER_LINEAR)

DllCall($_opencv_imgproc , "none:cdecl" , "cvResize" , "ptr" , $cvsrc , "ptr" , $cvdst , "int" , $cvinterpolation )
If @error Then ConsoleWrite( "error in cvResize")

Return
EndFunc ;==>_cvResize


;------------------------------------------------
;/*
;CVAPI(void)  cvWarpAffine( const CvArr* src, CvArr* dst, const CvMat* map_matrix, int flags CV_DEFAULT(CV_INTER_LINEAR+CV_WARP_FILL_OUTLIERS), CvScalar fillval CV_DEFAULT(cvScalarAll(0)) );
;
;
Func _cvWarpAffine( $cvsrc , $cvdst , $cvmap_matrix , $cvflags , $cvfillval )

DllCall($_opencv_imgproc , "none:cdecl" , "cvWarpAffine" , "ptr" , $cvsrc , "ptr" , $cvdst , "ptr" , $cvmap_matrix , "int" , $cvflags , "struct" , $cvfillval )
If @error Then ConsoleWrite( "error in cvWarpAffine")

Return
EndFunc ;==>_cvWarpAffine


;------------------------------------------------
;/*
;CVAPI(CvMat*)  cv2DRotationMatrix( CvPoint2D32f center, double angle, double scale, CvMat* map_matrix );
;
;
Func _cv2DRotationMatrix( $cvcenter , $cvangle , $cvscale , $cvmap_matrix )

local $_aResult = DllCall($_opencv_imgproc , "ptr:cdecl" , "cv2DRotationMatrix" , "struct" , $cvcenter , "double" , $cvangle , "double" , $cvscale , "ptr" , $cvmap_matrix )
If @error Then ConsoleWrite( "error in cv2DRotationMatrix")

Return $_aResult[0]
EndFunc ;==>_cv2DRotationMatrix


;------------------------------------------------
;/*
;CVAPI(void)  cvWarpPerspective( const CvArr* src, CvArr* dst, const CvMat* map_matrix, int flags CV_DEFAULT(CV_INTER_LINEAR+CV_WARP_FILL_OUTLIERS), CvScalar fillval CV_DEFAULT(cvScalarAll(0)) );
;
;
Func _cvWarpPerspective( $cvsrc , $cvdst , $cvmap_matrix , $cvflags , $cvfillval )

DllCall($_opencv_imgproc , "none:cdecl" , "cvWarpPerspective" , "ptr" , $cvsrc , "ptr" , $cvdst , "ptr" , $cvmap_matrix , "int" , $cvflags , "struct" , $cvfillval )
If @error Then ConsoleWrite( "error in cvWarpPerspective")

Return
EndFunc ;==>_cvWarpPerspective


;------------------------------------------------
;/*
;CVAPI(void)  cvRemap( const CvArr* src, CvArr* dst, const CvArr* mapx, const CvArr* mapy, int flags CV_DEFAULT(CV_INTER_LINEAR+CV_WARP_FILL_OUTLIERS), CvScalar fillval CV_DEFAULT(cvScalarAll(0)) );
;
;
Func _cvRemap( $cvsrc , $cvdst , $cvmapx , $cvmapy , $cvflags , $cvfillval )

DllCall($_opencv_imgproc , "none:cdecl" , "cvRemap" , "ptr" , $cvsrc , "ptr" , $cvdst , "ptr" , $cvmapx , "ptr" , $cvmapy , "int" , $cvflags , "struct" , $cvfillval )
If @error Then ConsoleWrite( "error in cvRemap")

Return
EndFunc ;==>_cvRemap


;------------------------------------------------
;/*
;CVAPI(void)  cvConvertMaps( const CvArr* mapx, const CvArr* mapy, CvArr* mapxy, CvArr* mapalpha );
;
;
Func _cvConvertMaps( $cvmapx , $cvmapy , $cvmapxy , $cvmapalpha )

DllCall($_opencv_imgproc , "none:cdecl" , "cvConvertMaps" , "ptr" , $cvmapx , "ptr" , $cvmapy , "ptr" , $cvmapxy , "ptr" , $cvmapalpha )
If @error Then ConsoleWrite( "error in cvConvertMaps")

Return
EndFunc ;==>_cvConvertMaps


;------------------------------------------------
;/*
;CVAPI(void)  cvLogPolar( const CvArr* src, CvArr* dst, CvPoint2D32f center, double M, int flags CV_DEFAULT(CV_INTER_LINEAR+CV_WARP_FILL_OUTLIERS));
;
;
Func _cvLogPolar( $cvsrc , $cvdst , $cvcenter , $cvM , $cvflags )

DllCall($_opencv_imgproc , "none:cdecl" , "cvLogPolar" , "ptr" , $cvsrc , "ptr" , $cvdst , "struct" , $cvcenter , "double" , $cvM , "int" , $cvflags )
If @error Then ConsoleWrite( "error in cvLogPolar")

Return
EndFunc ;==>_cvLogPolar


;------------------------------------------------
;/*
;CVAPI(void)  cvLinearPolar( const CvArr* src, CvArr* dst, CvPoint2D32f center, double maxRadius, int flags CV_DEFAULT(CV_INTER_LINEAR+CV_WARP_FILL_OUTLIERS));
;
;
Func _cvLinearPolar( $cvsrc , $cvdst , $cvcenter , $cvmaxRadius , $cvflags )

DllCall($_opencv_imgproc , "none:cdecl" , "cvLinearPolar" , "ptr" , $cvsrc , "ptr" , $cvdst , "struct" , $cvcenter , "double" , $cvmaxRadius , "int" , $cvflags )
If @error Then ConsoleWrite( "error in cvLinearPolar")

Return
EndFunc ;==>_cvLinearPolar


;------------------------------------------------
;/*
;CVAPI(void) cvUndistort2( const CvArr* src, CvArr* dst, const CvMat* camera_matrix, const CvMat* distortion_coeffs, const CvMat* new_camera_matrix CV_DEFAULT(0) );
;
;
Func _cvUndistort2( $cvsrc , $cvdst , $cvcamera_matrix , $cvdistortion_coeffs , $cvnew_camera_matrix )

DllCall($_opencv_imgproc , "none:cdecl" , "cvUndistort2" , "ptr" , $cvsrc , "ptr" , $cvdst , "ptr" , $cvcamera_matrix , "ptr" , $cvdistortion_coeffs , "ptr" , $cvnew_camera_matrix )
If @error Then ConsoleWrite( "error in cvUndistort2")

Return
EndFunc ;==>_cvUndistort2


;------------------------------------------------
;/*
;CVAPI(void) cvInitUndistortMap( const CvMat* camera_matrix, const CvMat* distortion_coeffs, CvArr* mapx, CvArr* mapy );
;
;
Func _cvInitUndistortMap( $cvcamera_matrix , $cvdistortion_coeffs , $cvmapx , $cvmapy )

DllCall($_opencv_imgproc , "none:cdecl" , "cvInitUndistortMap" , "ptr" , $cvcamera_matrix , "ptr" , $cvdistortion_coeffs , "ptr" , $cvmapx , "ptr" , $cvmapy )
If @error Then ConsoleWrite( "error in cvInitUndistortMap")

Return
EndFunc ;==>_cvInitUndistortMap


;------------------------------------------------
;/*
;CVAPI(void) cvInitUndistortRectifyMap( const CvMat* camera_matrix, const CvMat* dist_coeffs, const CvMat *R, const CvMat* new_camera_matrix, CvArr* mapx, CvArr* mapy );
;
;
Func _cvInitUndistortRectifyMap( $cvcamera_matrix , $cvdist_coeffs , $cvR , $cvnew_camera_matrix , $cvmapx , $cvmapy )

DllCall($_opencv_imgproc , "none:cdecl" , "cvInitUndistortRectifyMap" , "ptr" , $cvcamera_matrix , "ptr" , $cvdist_coeffs , "ptr" , $cvR , "ptr" , $cvnew_camera_matrix , "ptr" , $cvmapx , "ptr" , $cvmapy )
If @error Then ConsoleWrite( "error in cvInitUndistortRectifyMap")

Return
EndFunc ;==>_cvInitUndistortRectifyMap


;------------------------------------------------
;/*
;CVAPI(void) cvUndistortPoints( const CvMat* src, CvMat* dst, const CvMat* camera_matrix, const CvMat* dist_coeffs, const CvMat* R CV_DEFAULT(0), const CvMat* P CV_DEFAULT(0));
;
;
Func _cvUndistortPoints( $cvsrc , $cvdst , $cvcamera_matrix , $cvdist_coeffs , $cvR , $cvP )

DllCall($_opencv_imgproc , "none:cdecl" , "cvUndistortPoints" , "ptr" , $cvsrc , "ptr" , $cvdst , "ptr" , $cvcamera_matrix , "ptr" , $cvdist_coeffs , "ptr" , $cvR , "ptr" , $cvP )
If @error Then ConsoleWrite( "error in cvUndistortPoints")

Return
EndFunc ;==>_cvUndistortPoints


;------------------------------------------------
;/*
;CVAPI(IplConvKernel*)  cvCreateStructuringElementEx( int cols, int rows, int anchor_x, int anchor_y, int shape, int* values CV_DEFAULT(NULL) );
;
;
Func _cvCreateStructuringElementEx( $cvcols , $cvrows , $cvanchor_x , $cvanchor_y , $cvshape , $cvvalues = Null )

local $_aResult = DllCall($_opencv_imgproc , "ptr:cdecl" , "cvCreateStructuringElementEx" , "int" , $cvcols , "int" , $cvrows , "int" , $cvanchor_x , "int" , $cvanchor_y , "int" , $cvshape , "ptr" , $cvvalues )
If @error Then ConsoleWrite( "error in cvCreateStructuringElementEx")

Return $_aResult[0]
EndFunc ;==>_cvCreateStructuringElementEx


;------------------------------------------------
;/*
;CVAPI(void)  cvReleaseStructuringElement( IplConvKernel** element );
;
;
Func _cvReleaseStructuringElement( $cvelement )

DllCall($_opencv_imgproc , "none:cdecl" , "cvReleaseStructuringElement" , "ptr*" , $cvelement )
If @error Then ConsoleWrite( "error in cvReleaseStructuringElement")

Return
EndFunc ;==>_cvReleaseStructuringElement


;------------------------------------------------
;/*
;CVAPI(void)  cvErode( const CvArr* src, CvArr* dst, IplConvKernel* element CV_DEFAULT(NULL), int iterations CV_DEFAULT(1) );
;
;
Func _cvErode( $cvsrc , $cvdst , $cvelement = Null , $cviterations = 1 )

DllCall($_opencv_imgproc , "none:cdecl" , "cvErode" , "ptr" , $cvsrc , "ptr" , $cvdst , "ptr" , $cvelement , "int" , $cviterations )
If @error Then ConsoleWrite( "error in cvErode")

Return
EndFunc ;==>_cvErode


;------------------------------------------------
;/*
;CVAPI(void)  cvDilate( const CvArr* src, CvArr* dst, IplConvKernel* element CV_DEFAULT(NULL), int iterations CV_DEFAULT(1) );
;
;
Func _cvDilate( $cvsrc , $cvdst , $cvelement = Null , $cviterations = 1 )

DllCall($_opencv_imgproc , "none:cdecl" , "cvDilate" , "ptr" , $cvsrc , "ptr" , $cvdst , "ptr" , $cvelement , "int" , $cviterations )
If @error Then ConsoleWrite( "error in cvDilate")

Return
EndFunc ;==>_cvDilate


;------------------------------------------------
;/*
;CVAPI(void)  cvMorphologyEx( const CvArr* src, CvArr* dst, CvArr* temp, IplConvKernel* element, int operation, int iterations CV_DEFAULT(1) );
;
;
Func _cvMorphologyEx( $cvsrc , $cvdst , $cvtemp , $cvelement , $cvoperation , $cviterations = 1)

DllCall($_opencv_imgproc , "none:cdecl" , "cvMorphologyEx" , "ptr" , $cvsrc , "ptr" , $cvdst , "ptr" , $cvtemp , "ptr" , $cvelement , "int" , $cvoperation , "int" , $cviterations )
If @error Then ConsoleWrite( "error in cvMorphologyEx")

Return
EndFunc ;==>_cvMorphologyEx


;------------------------------------------------
;/*
;CVAPI(void) cvMoments( const CvArr* arr, CvMoments* moments, int binary CV_DEFAULT(0));
;
;
Func _cvMoments( $cvarr , $cvmoments , $cvbinary )

DllCall($_opencv_imgproc , "none:cdecl" , "cvMoments" , "ptr" , $cvarr , "ptr" , $cvmoments , "int" , $cvbinary )
If @error Then ConsoleWrite( "error in cvMoments")

Return
EndFunc ;==>_cvMoments


;------------------------------------------------
;/*
;CVAPI(double)  cvGetSpatialMoment( CvMoments* moments, int x_order, int y_order );CVAPI(double) cvGetCentralMoment( CvMoments* moments, int x_order, int y_order );
;
;
Func _cvGetSpatialMoment( $cvmoments , $cvx_order , $cvy_order  )

local $_aResult = DllCall($_opencv_imgproc , "double:cdecl" , "cvGetSpatialMoment" , "ptr" , $cvmoments , "int" , $cvx_order , "int" , $cvy_order  )
If @error Then ConsoleWrite( "error in cvGetSpatialMoment")

Return $_aResult[0]
EndFunc ;==>_cvGetSpatialMoment


;------------------------------------------------
;/*
;CVAPI(double)  cvGetNormalizedCentralMoment( CvMoments* moments, int x_order, int y_order );
;
;
Func _cvGetNormalizedCentralMoment( $cvmoments , $cvx_order , $cvy_order )

local $_aResult = DllCall($_opencv_imgproc , "double:cdecl" , "cvGetNormalizedCentralMoment" , "ptr" , $cvmoments , "int" , $cvx_order , "int" , $cvy_order )
If @error Then ConsoleWrite( "error in cvGetNormalizedCentralMoment")

Return $_aResult[0]
EndFunc ;==>_cvGetNormalizedCentralMoment


;------------------------------------------------
;/*
;CVAPI(int)  cvSampleLine( const CvArr* image, CvPoint pt1, CvPoint pt2, void* buffer, int connectivity CV_DEFAULT(8));
;
;
Func _cvSampleLine( $cvimage , $cvpt1 , $cvpt2 , $cvbuffer , $cvconnectivity )

local $_aResult = DllCall($_opencv_imgproc , "int:cdecl" , "cvSampleLine" , "ptr" , $cvimage , "struct" , $cvpt1 , "struct" , $cvpt2 , "ptr" , $cvbuffer , "int" , $cvconnectivity )
If @error Then ConsoleWrite( "error in cvSampleLine")

Return $_aResult[0]
EndFunc ;==>_cvSampleLine


;------------------------------------------------
;/*
;CVAPI(void)  cvGetRectSubPix( const CvArr* src, CvArr* dst, CvPoint2D32f center );
;
;
Func _cvGetRectSubPix( $cvsrc , $cvdst , $cvcenter )

DllCall($_opencv_imgproc , "none:cdecl" , "cvGetRectSubPix" , "ptr" , $cvsrc , "ptr" , $cvdst , "struct" , $cvcenter )
If @error Then ConsoleWrite( "error in cvGetRectSubPix")

Return
EndFunc ;==>_cvGetRectSubPix


;------------------------------------------------
;/*
;CVAPI(void)  cvGetQuadrangleSubPix( const CvArr* src, CvArr* dst, const CvMat* map_matrix );
;
;
Func _cvGetQuadrangleSubPix( $cvsrc , $cvdst , $cvmap_matrix )

DllCall($_opencv_imgproc , "none:cdecl" , "cvGetQuadrangleSubPix" , "ptr" , $cvsrc , "ptr" , $cvdst , "ptr" , $cvmap_matrix )
If @error Then ConsoleWrite( "error in cvGetQuadrangleSubPix")

Return
EndFunc ;==>_cvGetQuadrangleSubPix


;------------------------------------------------
;/*
;CVAPI(void)  cvMatchTemplate( const CvArr* image, const CvArr* templ, CvArr* result, int method );
;
;
Func _cvMatchTemplate( $cvimage , $cvtempl , $cvresult , $cvmethod )

DllCall($_opencv_imgproc , "none:cdecl" , "cvMatchTemplate" , "ptr" , $cvimage , "ptr" , $cvtempl , "ptr" , $cvresult , "int" , $cvmethod )
If @error Then ConsoleWrite( "error in cvMatchTemplate")

Return
EndFunc ;==>_cvMatchTemplate


;------------------------------------------------
;/*
;CVAPI(int)  cvFindContours( CvArr* image, CvMemStorage* storage, CvSeq** first_contour, int header_size CV_DEFAULT(sizeof(CvContour)), int mode CV_DEFAULT(CV_RETR_LIST), int method CV_DEFAULT(CV_CHAIN_APPROX_SIMPLE), CvPoint offset CV_DEFAULT(cvPoint(0_0)));
;
;
Func _cvFindContours( $cvimage , $cvstorage , ByRef $cvfirst_contour , $cvheader_size , $cvmode , $cvmethod , $cvoffset )

local $_aResult = DllCall($_opencv_imgproc , "int:cdecl" , "cvFindContours" , "ptr" , $cvimage , "ptr" , $cvstorage , "Ptr*" , $cvfirst_contour , "int" , $cvheader_size , "int" , $cvmode , "int" , $cvmethod , "struct" , $cvoffset )
If @error Then ConsoleWrite( "error in cvFindContours")

Return $_aResult[0]
EndFunc ;==>_cvFindContours


;------------------------------------------------
;/*
;CVAPI(CvSeq*)  cvApproxPoly( const void* src_seq, int header_size, CvMemStorage* storage, int method, double eps, int recursive CV_DEFAULT(0));
;
;
Func _cvApproxPoly( $cvsrc_seq , $cvheader_size , $cvstorage , $cvmethod , $cveps , $cvrecursive = 0 )

local $_aResult = DllCall($_opencv_imgproc , "ptr:cdecl" , "cvApproxPoly" , "ptr" , $cvsrc_seq , "int" , $cvheader_size , "ptr" , $cvstorage , "int" , $cvmethod , "double" , $cveps , "int" , $cvrecursive )
If @error Then ConsoleWrite( "error in cvApproxPoly")

Return $_aResult[0]
EndFunc ;==>_cvApproxPoly


;------------------------------------------------
;/*
;CVAPI(double)  cvArcLength( const void* curve, CvSlice slice CV_DEFAULT(CV_WHOLE_SEQ), int is_closed CV_DEFAULT(-1));
;
;
Func _cvArcLength( $cvcurve , $cvslice = _CvSlice(0,0x3fffffff) , $cvis_closed  = -1)

local $_aResult = DllCall($_opencv_imgproc , "double:cdecl" , "cvArcLength" , "ptr" , $cvcurve , "struct" , $cvslice , "int" , $cvis_closed )
If @error Then ConsoleWrite( "error in cvArcLength")

Return $_aResult[0]
EndFunc ;==>_cvArcLength


;------------------------------------------------
;/*
;CVAPI(int)  cvMinEnclosingCircle( const CvArr* points, CvPoint2D32f* center, float* radius );
;
;
Func _cvMinEnclosingCircle( $cvpoints , $cvcenter , $cvradius )

local $_aResult = DllCall($_opencv_imgproc , "int:cdecl" , "cvMinEnclosingCircle" , "ptr" , $cvpoints , "ptr" , $cvcenter , "ptr" , $cvradius )
If @error Then ConsoleWrite( "error in cvMinEnclosingCircle")

Return $_aResult[0]
EndFunc ;==>_cvMinEnclosingCircle


;------------------------------------------------
;/*
;CVAPI(double)  cvMatchShapes( const void* object1, const void* object2, int method, double parameter CV_DEFAULT(0));
;
;
Func _cvMatchShapes( $cvobject1 , $cvobject2 , $cvmethod , $cvparameter )

local $_aResult = DllCall($_opencv_imgproc , "double:cdecl" , "cvMatchShapes" , "ptr" , $cvobject1 , "ptr" , $cvobject2 , "int" , $cvmethod , "double" , $cvparameter )
If @error Then ConsoleWrite( "error in cvMatchShapes")

Return $_aResult[0]
EndFunc ;==>_cvMatchShapes


;------------------------------------------------
;/*
;CVAPI(int)  cvCheckContourConvexity( const CvArr* contour );
;
;
Func _cvCheckContourConvexity( $cvcontour )

local $_aResult = DllCall($_opencv_imgproc , "int:cdecl" , "cvCheckContourConvexity" , "ptr" , $cvcontour )
If @error Then ConsoleWrite( "error in cvCheckContourConvexity")

Return $_aResult[0]
EndFunc ;==>_cvCheckContourConvexity


;------------------------------------------------
;/*
;CVAPI(CvSeq*) cvPointSeqFromMat( int seq_kind, const CvArr* mat, CvContour* contour_header, CvSeqBlock* block );
;
;
Func _cvPointSeqFromMat( $cvseq_kind , $cvmat , $cvcontour_header , $cvblock )

local $_aResult = DllCall($_opencv_imgproc , "ptr:cdecl" , "cvPointSeqFromMat" , "int" , $cvseq_kind , "ptr" , $cvmat , "ptr" , $cvcontour_header , "ptr" , $cvblock )
If @error Then ConsoleWrite( "error in cvPointSeqFromMat")

Return $_aResult[0]
EndFunc ;==>_cvPointSeqFromMat


;------------------------------------------------
;/*
;CVAPI(double) cvPointPolygonTest( const CvArr* contour, CvPoint2D32f pt, int measure_dist );
;
;
Func _cvPointPolygonTest( $cvcontour , $cvpt , $cvmeasure_dist )

local $_aResult = DllCall($_opencv_imgproc , "double:cdecl" , "cvPointPolygonTest" , "ptr" , $cvcontour , "struct" , $cvpt , "int" , $cvmeasure_dist )
If @error Then ConsoleWrite( "error in cvPointPolygonTest")

Return $_aResult[0]
EndFunc ;==>_cvPointPolygonTest


;------------------------------------------------
;/*
;CVAPI(void)  cvReleaseHist( CvHistogram** hist );
;
;
Func _cvReleaseHist( $cvhist )

DllCall($_opencv_imgproc , "none:cdecl" , "cvReleaseHist" , "ptr*" , $cvhist )
If @error Then ConsoleWrite( "error in cvReleaseHist")

Return
EndFunc ;==>_cvReleaseHist


;------------------------------------------------
;/*
;CVAPI(void)  cvClearHist( CvHistogram* hist );
;
;
Func _cvClearHist( $cvhist )

DllCall($_opencv_imgproc , "none:cdecl" , "cvClearHist" , "ptr" , $cvhist )
If @error Then ConsoleWrite( "error in cvClearHist")

Return
EndFunc ;==>_cvClearHist


;------------------------------------------------
;/*
;CVAPI(void)  cvGetMinMaxHistValue( const CvHistogram* hist, float* min_value, float* max_value, int* min_idx CV_DEFAULT(NULL), int* max_idx CV_DEFAULT(NULL));
;
;
Func _cvGetMinMaxHistValue( $cvhist , $cvmin_value , $cvmax_value , $cvmin_idx , $cvmax_idx )

DllCall($_opencv_imgproc , "none:cdecl" , "cvGetMinMaxHistValue" , "ptr" , $cvhist , "ptr" , $cvmin_value , "ptr" , $cvmax_value , "ptr" , $cvmin_idx , "ptr" , $cvmax_idx )
If @error Then ConsoleWrite( "error in cvGetMinMaxHistValue")

Return
EndFunc ;==>_cvGetMinMaxHistValue


;------------------------------------------------
;/*
;CVAPI(void)  cvNormalizeHist( CvHistogram* hist, double factor );
;
;
Func _cvNormalizeHist( $cvhist , $cvfactor )

DllCall($_opencv_imgproc , "none:cdecl" , "cvNormalizeHist" , "ptr" , $cvhist , "double" , $cvfactor )
If @error Then ConsoleWrite( "error in cvNormalizeHist")

Return
EndFunc ;==>_cvNormalizeHist


;------------------------------------------------
;/*
;CVAPI(void)  cvThreshHist( CvHistogram* hist, double threshold );
;
;
Func _cvThreshHist( $cvhist , $cvthreshold )

DllCall($_opencv_imgproc , "none:cdecl" , "cvThreshHist" , "ptr" , $cvhist , "double" , $cvthreshold )
If @error Then ConsoleWrite( "error in cvThreshHist")

Return
EndFunc ;==>_cvThreshHist


;------------------------------------------------
;/*
;CVAPI(double)  cvCompareHist( const CvHistogram* hist1, const CvHistogram* hist2, int method);
;
;
Func _cvCompareHist( $cvhist1 , $cvhist2 , $cvmethod); )

local $_aResult = DllCall($_opencv_imgproc , "double:cdecl" , "cvCompareHist" , "ptr" , $cvhist1 , "ptr" , $cvhist2 , "int" , $cvmethod); )
If @error Then ConsoleWrite( "error in cvCompareHist")

Return $_aResult[0]
EndFunc ;==>_cvCompareHist


;------------------------------------------------
;/*
;CVAPI(void)  cvCopyHist( const CvHistogram* src, CvHistogram** dst );
;
;
Func _cvCopyHist( $cvsrc , $cvdst )

DllCall($_opencv_imgproc , "none:cdecl" , "cvCopyHist" , "ptr" , $cvsrc , "ptr*" , $cvdst )
If @error Then ConsoleWrite( "error in cvCopyHist")

Return
EndFunc ;==>_cvCopyHist


;------------------------------------------------
;/*
;CVAPI(void)  cvCalcBayesianProb( CvHistogram** src, int number, CvHistogram** dst);
;
;
Func _cvCalcBayesianProb( $cvsrc , $cvnumber , $cvdst); )

DllCall($_opencv_imgproc , "none:cdecl" , "cvCalcBayesianProb" , "ptr*" , $cvsrc , "int" , $cvnumber , "ptr*" , $cvdst); )
If @error Then ConsoleWrite( "error in cvCalcBayesianProb")

Return
EndFunc ;==>_cvCalcBayesianProb


;------------------------------------------------
;/*
;CVAPI(void)  cvCalcArrHist( CvArr** arr, CvHistogram* hist, int accumulate CV_DEFAULT(0), const CvArr* mask CV_DEFAULT(NULL) );
;
;
Func _cvCalcArrHist( $cvarr , $cvhist , $cvaccumulate , $cvmask )

DllCall($_opencv_imgproc , "none:cdecl" , "cvCalcArrHist" , "ptr*" , $cvarr , "ptr" , $cvhist , "int" , $cvaccumulate , "ptr" , $cvmask )
If @error Then ConsoleWrite( "error in cvCalcArrHist")

Return
EndFunc ;==>_cvCalcArrHist


;------------------------------------------------
;/*
;CVAPI(void)  cvCalcArrBackProject( CvArr** image, CvArr* dst, const CvHistogram* hist );
;
;
Func _cvCalcArrBackProject( $cvimage , $cvdst , $cvhist )

DllCall($_opencv_imgproc , "none:cdecl" , "cvCalcArrBackProject" , "ptr*" , $cvimage , "ptr" , $cvdst , "ptr" , $cvhist )
If @error Then ConsoleWrite( "error in cvCalcArrBackProject")

Return
EndFunc ;==>_cvCalcArrBackProject


;------------------------------------------------
;/*
;CVAPI(void)  cvCalcArrBackProjectPatch( CvArr** image, CvArr* dst, CvSize range, CvHistogram* hist, int method, double factor );
;
;
Func _cvCalcArrBackProjectPatch( $cvimage , $cvdst , $cvrange , $cvhist , $cvmethod , $cvfactor )

DllCall($_opencv_imgproc , "none:cdecl" , "cvCalcArrBackProjectPatch" , "ptr*" , $cvimage , "ptr" , $cvdst , "struct" , $cvrange , "ptr" , $cvhist , "int" , $cvmethod , "double" , $cvfactor )
If @error Then ConsoleWrite( "error in cvCalcArrBackProjectPatch")

Return
EndFunc ;==>_cvCalcArrBackProjectPatch


;------------------------------------------------
;/*
;CVAPI(void)  cvCalcProbDensity( const CvHistogram* hist1, const CvHistogram* hist2, CvHistogram* dst_hist, double scale CV_DEFAULT(255) );
;
;
Func _cvCalcProbDensity( $cvhist1 , $cvhist2 , $cvdst_hist , $cvscale )

DllCall($_opencv_imgproc , "none:cdecl" , "cvCalcProbDensity" , "ptr" , $cvhist1 , "ptr" , $cvhist2 , "ptr" , $cvdst_hist , "double" , $cvscale )
If @error Then ConsoleWrite( "error in cvCalcProbDensity")

Return
EndFunc ;==>_cvCalcProbDensity


;------------------------------------------------
;/*
;CVAPI(void)  cvDistTransform( const CvArr* src, CvArr* dst, int distance_type CV_DEFAULT(CV_DIST_L2), int mask_size CV_DEFAULT(3), const float* mask CV_DEFAULT(NULL), CvArr* labels CV_DEFAULT(NULL), int labelType CV_DEFAULT(CV_DIST_LABEL_CCOMP));
;
;
Func _cvDistTransform( $cvsrc , $cvdst , $cvdistance_type , $cvmask_size , $cvmask , $cvlabels , $cvlabelType )

DllCall($_opencv_imgproc , "none:cdecl" , "cvDistTransform" , "ptr" , $cvsrc , "ptr" , $cvdst , "int" , $cvdistance_type , "int" , $cvmask_size , "ptr" , $cvmask , "ptr" , $cvlabels , "int" , $cvlabelType )
If @error Then ConsoleWrite( "error in cvDistTransform")

Return
EndFunc ;==>_cvDistTransform


;------------------------------------------------
;/*
;CVAPI(void)  cvAdaptiveThreshold( const CvArr* src, CvArr* dst, double max_value, int adaptive_method CV_DEFAULT(CV_ADAPTIVE_THRESH_MEAN_C), int threshold_type CV_DEFAULT(CV_THRESH_BINARY), int block_size CV_DEFAULT(3), double param1 CV_DEFAULT(5));
;
;
Func _cvAdaptiveThreshold( $cvsrc , $cvdst , $cvmax_value , $cvadaptive_method , $cvthreshold_type , $cvblock_size , $cvparam1 )

DllCall($_opencv_imgproc , "none:cdecl" , "cvAdaptiveThreshold" , "ptr" , $cvsrc , "ptr" , $cvdst , "double" , $cvmax_value , "int" , $cvadaptive_method , "int" , $cvthreshold_type , "int" , $cvblock_size , "double" , $cvparam1 )
If @error Then ConsoleWrite( "error in cvAdaptiveThreshold")

Return
EndFunc ;==>_cvAdaptiveThreshold


;------------------------------------------------
;/*
;CVAPI(void)  cvFloodFill( CvArr* image, CvPoint seed_point, CvScalar new_val, CvScalar lo_diff CV_DEFAULT(cvScalarAll(0)), CvScalar up_diff CV_DEFAULT(cvScalarAll(0)), CvConnectedComp* comp CV_DEFAULT(NULL), int flags CV_DEFAULT(4), CvArr* mask CV_DEFAULT(NULL));
;
;
Func _cvFloodFill( $cvimage , $cvseed_point , $cvnew_val , $cvlo_diff , $cvup_diff , $cvcomp , $cvflags , $cvmask )

DllCall($_opencv_imgproc , "none:cdecl" , "cvFloodFill" , "ptr" , $cvimage , "struct" , $cvseed_point , "struct" , $cvnew_val , "struct" , $cvlo_diff , "struct" , $cvup_diff , "ptr" , $cvcomp , "int" , $cvflags , "ptr" , $cvmask )
If @error Then ConsoleWrite( "error in cvFloodFill")

Return
EndFunc ;==>_cvFloodFill


;------------------------------------------------
;/*
;CVAPI(void) cvPreCornerDetect( const CvArr* image, CvArr* corners, int aperture_size CV_DEFAULT(3) );
;
;
Func _cvPreCornerDetect( $cvimage , $cvcorners , $cvaperture_size = 3 )

DllCall($_opencv_imgproc , "none:cdecl" , "cvPreCornerDetect" , "ptr" , $cvimage , "ptr" , $cvcorners , "int" , $cvaperture_size )
If @error Then ConsoleWrite( "error in cvPreCornerDetect")

Return
EndFunc ;==>_cvPreCornerDetect


;------------------------------------------------
;/*
;CVAPI(void)  cvCornerEigenValsAndVecs( const CvArr* image, CvArr* eigenvv, int block_size, int aperture_size CV_DEFAULT(3) );
;
;
Func _cvCornerEigenValsAndVecs( $cvimage , $cveigenvv , $cvblock_size , $cvaperture_size = 3 )

DllCall($_opencv_imgproc , "none:cdecl" , "cvCornerEigenValsAndVecs" , "ptr" , $cvimage , "ptr" , $cveigenvv , "int" , $cvblock_size , "int" , $cvaperture_size )
If @error Then ConsoleWrite( "error in cvCornerEigenValsAndVecs")

Return
EndFunc ;==>_cvCornerEigenValsAndVecs


;------------------------------------------------
;/*
;CVAPI(void)  cvCornerMinEigenVal( const CvArr* image, CvArr* eigenval, int block_size, int aperture_size CV_DEFAULT(3) );
;
;
Func _cvCornerMinEigenVal( $cvimage , $cveigenval , $cvblock_size , $cvaperture_size = 3 )

DllCall($_opencv_imgproc , "none:cdecl" , "cvCornerMinEigenVal" , "ptr" , $cvimage , "ptr" , $cveigenval , "int" , $cvblock_size , "int" , $cvaperture_size )
If @error Then ConsoleWrite( "error in cvCornerMinEigenVal")

Return
EndFunc ;==>_cvCornerMinEigenVal


;------------------------------------------------
;/*
;CVAPI(void)  cvCornerHarris( const CvArr* image, CvArr* harris_responce, int block_size, int aperture_size CV_DEFAULT(3), double k CV_DEFAULT(0.04) );
;
;
Func _cvCornerHarris( $cvimage , $cvharris_responce , $cvblock_size , $cvaperture_size = 3 , $cvk = 0.04 )

DllCall($_opencv_imgproc , "none:cdecl" , "cvCornerHarris" , "ptr" , $cvimage , "ptr" , $cvharris_responce , "int" , $cvblock_size , "int" , $cvaperture_size , "double" , $cvk )
If @error Then ConsoleWrite( "error in cvCornerHarris")

Return
EndFunc ;==>_cvCornerHarris


;------------------------------------------------
;/*
;CVAPI(void)  cvGoodFeaturesToTrack( const CvArr* image, CvArr* eig_image, CvArr* temp_image, CvPoint2D32f* corners, int* corner_count, double quality_level, double min_distance, const CvArr* mask CV_DEFAULT(NULL), int block_size CV_DEFAULT(3), int use_harris CV_DEFAULT(0), double k CV_DEFAULT(0.04) );
;
;
Func _cvGoodFeaturesToTrack( $cvimage , $cveig_image , $cvtemp_image , $cvcorners , $cvcorner_count , $cvquality_level , $cvmin_distance , $cvmask , $cvblock_size , $cvuse_harris , $cvk )

DllCall($_opencv_imgproc , "none:cdecl" , "cvGoodFeaturesToTrack" , "ptr" , $cvimage , "ptr" , $cveig_image , "ptr" , $cvtemp_image , "ptr" , $cvcorners , "ptr" , $cvcorner_count , "double" , $cvquality_level , "double" , $cvmin_distance , "ptr" , $cvmask , "int" , $cvblock_size , "int" , $cvuse_harris , "double" , $cvk )
If @error Then ConsoleWrite( "error in cvGoodFeaturesToTrack")

Return
EndFunc ;==>_cvGoodFeaturesToTrack


;------------------------------------------------
;/*
;CVAPI(CvSeq*)  cvHoughLines2( CvArr* image, void* line_storage, int method, double rho, double theta, int threshold, double param1 CV_DEFAULT(0), double param2 CV_DEFAULT(0));
;
;
Func _cvHoughLines2( $cvimage , $cvline_storage , $cvmethod , $cvrho , $cvtheta , $cvthreshold , $cvparam1 , $cvparam2 )

local $_aResult = DllCall($_opencv_imgproc , "ptr:cdecl" , "cvHoughLines2" , "ptr" , $cvimage , "ptr" , $cvline_storage , "int" , $cvmethod , "double" , $cvrho , "double" , $cvtheta , "int" , $cvthreshold , "double" , $cvparam1 , "double" , $cvparam2 )
If @error Then ConsoleWrite( "error in cvHoughLines2")

Return $_aResult[0]
EndFunc ;==>_cvHoughLines2


;------------------------------------------------
;/*
;CVAPI(void)  cvFitLine( const CvArr* points, int dist_type, double param, double reps, double aeps, float* line );
;
;
Func _cvFitLine( $cvpoints , $cvdist_type , $cvparam , $cvreps , $cvaeps , $cvline )

DllCall($_opencv_imgproc , "none:cdecl" , "cvFitLine" , "ptr" , $cvpoints , "int" , $cvdist_type , "double" , $cvparam , "double" , $cvreps , "double" , $cvaeps , "ptr" , $cvline )
If @error Then ConsoleWrite( "error in cvFitLine")

Return
EndFunc ;==>_cvFitLine



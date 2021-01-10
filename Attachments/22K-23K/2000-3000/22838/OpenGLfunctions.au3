; Functions ;

Func glAccum($op, $value)
	DllCall("opengl32.dll", "none", "glAccum", "uint", $op, "float", $value)
EndFunc   ;==>glAccum

Func glAlphaFunc($func, $ref)
	DllCall("opengl32.dll", "none", "glAlphaFunc", "uint", $func, "float", $ref)
EndFunc   ;==>glAlphaFunc

Func glAreTexturesResident($n, $textures, $residences)
	DllCall("opengl32.dll", "ubyte", "glAreTexturesResident", "int", $n, "dword", $textures, "dword", $residences)
EndFunc   ;==>glAreTexturesResident

Func glarrayElement($i)
	DllCall("opengl32.dll", "none", "glarrayElement", "int", $i)
EndFunc   ;==>glarrayElement

Func glBegin($mode)
	DllCall("opengl32.dll", "none", "glBegin", "uint", $mode)
EndFunc   ;==>glBegin

Func glBindTexture($target, $texture)
	DllCall("opengl32.dll", "none", "glBindTexture", "uint", $target, "uint", $texture)
EndFunc   ;==>glBindTexture

Func glBitmap($width, $height, $xorig, $yorig, $xmove, $ymove, $bitmap)
	DllCall("opengl32.dll", "none", "glBitmap", "int", $width, "int", $height, "float", $xorig, "float", $yorig, "float", $xmove, "float", $ymove, "dword", $bitmap)
EndFunc   ;==>glBitmap

Func glBlendFunc($sfactor, $dfactor)
	DllCall("opengl32.dll", "none", "glBlendFunc", "uint", $sfactor, "uint", $dfactor)
EndFunc   ;==>glBlendFunc

Func glCallList($list)
	DllCall("opengl32.dll", "none", "glCallList", "uint", $list)
EndFunc   ;==>glCallList

Func glCallLists($n, $type, $lists)
	DllCall("opengl32.dll", "none", "glCallLists", "int", $n, "uint", $type, "dword", $lists)
EndFunc   ;==>glCallLists

Func glClear($mask)
	DllCall("opengl32.dll", "none", "glClear", "uint", $mask)
EndFunc   ;==>glClear

Func glClearAccum($red, $green, $blue, $alpha)
	DllCall("opengl32.dll", "none", "glClearAccum", "float", $red, "float", $green, "float", $blue, "float", $alpha)
EndFunc   ;==>glClearAccum

Func glClearColor($red, $green, $blue, $alpha)
	DllCall("opengl32.dll", "none", "glClearColor", "float", $red, "float", $green, "float", $blue, "float", $alpha)
EndFunc   ;==>glClearColor

Func glClearDepth($depth)
	DllCall("opengl32.dll", "none", "glClearDepth", "double", $depth)
EndFunc   ;==>glClearDepth

Func glClearIndex($c)
	DllCall("opengl32.dll", "none", "glClearIndex", "float", $c)
EndFunc   ;==>glClearIndex

Func glClearStencil($s)
	DllCall("opengl32.dll", "none", "glClearStencil", "int", $s)
EndFunc   ;==>glClearStencil

Func glClipPlane($plane, $equation)
	DllCall("opengl32.dll", "none", "glClipPlane", "uint", $plane, "dword", $equation)
EndFunc   ;==>glClipPlane

Func glColor3b($red, $green, $blue)
	DllCall("opengl32.dll", "none", "glColor3b", "byte", $red, "byte", $green, "byte", $blue)
EndFunc   ;==>glColor3b

Func glColor3bv($v)
	DllCall("opengl32.dll", "none", "glColor3bv", "dword", $v)
EndFunc   ;==>glColor3bv

Func glColor3d($red, $green, $blue)
	DllCall("opengl32.dll", "none", "glColor3d", "double", $red, "double", $green, "double", $blue)
EndFunc   ;==>glColor3d

Func glColor3dv($v)
	DllCall("opengl32.dll", "none", "glColor3dv", "dword", $v)
EndFunc   ;==>glColor3dv

Func glColor3f($red, $green, $blue)
	DllCall("opengl32.dll", "none", "glColor3f", "float", $red, "float", $green, "float", $blue)
EndFunc   ;==>glColor3f

Func glColor3fv($v)
	DllCall("opengl32.dll", "none", "glColor3fv", "dword", $v)
EndFunc   ;==>glColor3fv

Func glColor3i($red, $green, $blue)
	DllCall("opengl32.dll", "none", "glColor3i", "int", $red, "int", $green, "int", $blue)
EndFunc   ;==>glColor3i

Func glColor3iv($v)
	DllCall("opengl32.dll", "none", "glColor3iv", "dword", $v)
EndFunc   ;==>glColor3iv

Func glColor3s($red, $green, $blue)
	DllCall("opengl32.dll", "none", "glColor3s", "short", $red, "short", $green, "short", $blue)
EndFunc   ;==>glColor3s

Func glColor3sv($v)
	DllCall("opengl32.dll", "none", "glColor3sv", "dword", $v)
EndFunc   ;==>glColor3sv

Func glColor3ub($red, $green, $blue)
	DllCall("opengl32.dll", "none", "glColor3ub", "ubyte", $red, "ubyte", $green, "ubyte", $blue)
EndFunc   ;==>glColor3ub

Func glColor3ubv($v)
	DllCall("opengl32.dll", "none", "glColor3ubv", "dword", $v)
EndFunc   ;==>glColor3ubv

Func glColor3ui($red, $green, $blue)
	DllCall("opengl32.dll", "none", "glColor3ui", "uint", $red, "uint", $green, "uint", $blue)
EndFunc   ;==>glColor3ui

Func glColor3uiv($v)
	DllCall("opengl32.dll", "none", "glColor3uiv", "dword", $v)
EndFunc   ;==>glColor3uiv

Func glColor3us($red, $green, $blue)
	DllCall("opengl32.dll", "none", "glColor3us", "ushort", $red, "ushort", $green, "ushort", $blue)
EndFunc   ;==>glColor3us

Func glColor3usv($v)
	DllCall("opengl32.dll", "none", "glColor3usv", "dword", $v)
EndFunc   ;==>glColor3usv

Func glColor4b($red, $green, $blue, $alpha)
	DllCall("opengl32.dll", "none", "glColor4b", "byte", $red, "byte", $green, "byte", $blue, "byte", $alpha)
EndFunc   ;==>glColor4b

Func glColor4bv($v)
	DllCall("opengl32.dll", "none", "glColor4bv", "dword", $v)
EndFunc   ;==>glColor4bv

Func glColor4d($red, $green, $blue, $alpha)
	DllCall("opengl32.dll", "none", "glColor4d", "double", $red, "double", $green, "double", $blue, "double", $alpha)
EndFunc   ;==>glColor4d

Func glColor4dv($v)
	DllCall("opengl32.dll", "none", "glColor4dv", "dword", $v)
EndFunc   ;==>glColor4dv

Func glColor4f($red, $green, $blue, $alpha)
	DllCall("opengl32.dll", "none", "glColor4f", "float", $red, "float", $green, "float", $blue, "float", $alpha)
EndFunc   ;==>glColor4f

Func glColor4fv($v)
	DllCall("opengl32.dll", "none", "glColor4fv", "dword", $v)
EndFunc   ;==>glColor4fv

Func glColor4i($red, $green, $blue, $alpha)
	DllCall("opengl32.dll", "none", "glColor4i", "int", $red, "int", $green, "int", $blue, "int", $alpha)
EndFunc   ;==>glColor4i

Func glColor4iv($v)
	DllCall("opengl32.dll", "none", "glColor4iv", "dword", $v)
EndFunc   ;==>glColor4iv

Func glColor4s($red, $green, $blue, $alpha)
	DllCall("opengl32.dll", "none", "glColor4s", "short", $red, "short", $green, "short", $blue, "short", $alpha)
EndFunc   ;==>glColor4s

Func glColor4sv($v)
	DllCall("opengl32.dll", "none", "glColor4sv", "dword", $v)
EndFunc   ;==>glColor4sv

Func glColor4ub($red, $green, $blue, $alpha)
	DllCall("opengl32.dll", "none", "glColor4ub", "ubyte", $red, "ubyte", $green, "ubyte", $blue, "ubyte", $alpha)
EndFunc   ;==>glColor4ub

Func glColor4ubv($v)
	DllCall("opengl32.dll", "none", "glColor4ubv", "dword", $v)
EndFunc   ;==>glColor4ubv

Func glColor4ui($red, $green, $blue, $alpha)
	DllCall("opengl32.dll", "none", "glColor4ui", "uint", $red, "uint", $green, "uint", $blue, "uint", $alpha)
EndFunc   ;==>glColor4ui

Func glColor4uiv($v)
	DllCall("opengl32.dll", "none", "glColor4uiv", "dword", $v)
EndFunc   ;==>glColor4uiv

Func glColor4us($red, $green, $blue, $alpha)
	DllCall("opengl32.dll", "none", "glColor4us", "ushort", $red, "ushort", $green, "ushort", $blue, "ushort", $alpha)
EndFunc   ;==>glColor4us

Func glColor4usv($v)
	DllCall("opengl32.dll", "none", "glColor4usv", "dword", $v)
EndFunc   ;==>glColor4usv

Func glColormask($red, $green, $blue, $alpha)
	DllCall("opengl32.dll", "none", "glColormask", "ubyte", $red, "ubyte", $green, "ubyte", $blue, "ubyte", $alpha)
EndFunc   ;==>glColormask

Func glColorMaterial($face, $mode)
	DllCall("opengl32.dll", "none", "glColorMaterial", "uint", $face, "uint", $mode)
EndFunc   ;==>glColorMaterial

Func glColorpointer($size, $type, $stride, $pointer)
	DllCall("opengl32.dll", "none", "glColorpointer", "int", $size, "uint", $type, "int", $stride, "dword", $pointer)
EndFunc   ;==>glColorpointer

Func glCopypixels($x, $y, $width, $height, $type)
	DllCall("opengl32.dll", "none", "glCopypixels", "int", $x, "int", $y, "int", $width, "int", $height, "uint", $type)
EndFunc   ;==>glCopypixels

Func glCopyTexImage1D($target, $level, $internalformat, $x, $y, $width, $border)
	DllCall("opengl32.dll", "none", "glCopyTexImage1D", "uint", $target, "int", $level, "uint", $internalformat, "int", $x, "int", $y, "int", $width, "int", $border)
EndFunc   ;==>glCopyTexImage1D

Func glCopyTexImage2D($target, $level, $internalformat, $x, $y, $width, $height, $border)
	DllCall("opengl32.dll", "none", "glCopyTexImage2D", "uint", $target, "int", $level, "uint", $internalformat, "int", $x, "int", $y, "int", $width, "int", $height, "int", $border)
EndFunc   ;==>glCopyTexImage2D

Func glCopyTexSubImage1D($target, $level, $xoffset, $x, $y, $width)
	DllCall("opengl32.dll", "none", "glCopyTexSubImage1D", "uint", $target, "int", $level, "int", $xoffset, "int", $x, "int", $y, "int", $width)
EndFunc   ;==>glCopyTexSubImage1D

Func glCopyTexSubImage2D($target, $level, $xoffset, $yoffset, $x, $y, $width, $height)
	DllCall("opengl32.dll", "none", "glCopyTexSubImage2D", "uint", $target, "int", $level, "int", $xoffset, "int", $yoffset, "int", $x, "int", $y, "int", $width, "int", $height)
EndFunc   ;==>glCopyTexSubImage2D

Func glCullFace($mode)
	DllCall("opengl32.dll", "none", "glCullFace", "uint", $mode)
EndFunc   ;==>glCullFace

Func glDeleteLists($list, $range)
	DllCall("opengl32.dll", "none", "glDeleteLists", "uint", $list, "int", $range)
EndFunc   ;==>glDeleteLists

Func glDeleteTextures($n, $textures)
	DllCall("opengl32.dll", "none", "glDeleteTextures", "int", $n, "dword", $textures)
EndFunc   ;==>glDeleteTextures

Func glDepthFunc($func)
	DllCall("opengl32.dll", "none", "glDepthFunc", "uint", $func)
EndFunc   ;==>glDepthFunc

Func glDepthmask($flag)
	DllCall("opengl32.dll", "none", "glDepthmask", "ubyte", $flag)
EndFunc   ;==>glDepthmask

Func glDepthRange($zNear, $zFar)
	DllCall("opengl32.dll", "none", "glDepthRange", "double", $zNear, "double", $zFar)
EndFunc   ;==>glDepthRange

Func glDisable($cap)
	DllCall("opengl32.dll", "none", "glDisable", "uint", $cap)
EndFunc   ;==>glDisable

Func glDisableClientState($array)
	DllCall("opengl32.dll", "none", "glDisableClientState", "uint", $array)
EndFunc   ;==>glDisableClientState

Func glDrawarrays($mode, $first, $count)
	DllCall("opengl32.dll", "none", "glDrawarrays", "uint", $mode, "int", $first, "int", $count)
EndFunc   ;==>glDrawarrays

Func glDrawBuffer($mode)
	DllCall("opengl32.dll", "none", "glDrawBuffer", "uint", $mode)
EndFunc   ;==>glDrawBuffer

Func glDrawElements($mode, $count, $type, $indices)
	DllCall("opengl32.dll", "none", "glDrawElements", "uint", $mode, "int", $count, "uint", $type, "dword", $indices)
EndFunc   ;==>glDrawElements

Func glDrawPixels($width, $height, $format, $type, $pixels)
	DllCall("opengl32.dll", "none", "glDrawPixels", "int", $width, "int", $height, "uint", $format, "uint", $type, "dword", $pixels)
EndFunc   ;==>glDrawPixels

Func glEdgeFlag($flag)
	DllCall("opengl32.dll", "none", "glEdgeFlag", "ubyte", $flag)
EndFunc   ;==>glEdgeFlag

Func glEdgeFlagpointer($stride, $pointer)
	DllCall("opengl32.dll", "none", "glEdgeFlagpointer", "int", $stride, "dword", $pointer)
EndFunc   ;==>glEdgeFlagpointer

Func glEdgeFlagv($flag)
	DllCall("opengl32.dll", "none", "glEdgeFlagv", "dword", $flag)
EndFunc   ;==>glEdgeFlagv

Func glEnable($cap)
	DllCall("opengl32.dll", "none", "glEnable", "uint", $cap)
EndFunc   ;==>glEnable

Func glEnableClientState($array)
	DllCall("opengl32.dll", "none", "glEnableClientState", "uint", $array)
EndFunc   ;==>glEnableClientState

Func glEnd()
	DllCall("opengl32.dll", "none", "glEnd")
EndFunc   ;==>glEnd

Func glEndList()
	DllCall("opengl32.dll", "none", "glEndList")
EndFunc   ;==>glEndList

Func glEvalcoord1d($u)
	DllCall("opengl32.dll", "none", "glEvalcoord1d", "double", $u)
EndFunc   ;==>glEvalcoord1d

Func glEvalcoord1dv($u)
	DllCall("opengl32.dll", "none", "glEvalcoord1dv", "dword", $u)
EndFunc   ;==>glEvalcoord1dv

Func glEvalcoord1f($u)
	DllCall("opengl32.dll", "none", "glEvalcoord1f", "float", $u)
EndFunc   ;==>glEvalcoord1f

Func glEvalcoord1fv($u)
	DllCall("opengl32.dll", "none", "glEvalcoord1fv", "dword", $u)
EndFunc   ;==>glEvalcoord1fv

Func glEvalcoord2d($u, $v)
	DllCall("opengl32.dll", "none", "glEvalcoord2d", "double", $u, "double", $v)
EndFunc   ;==>glEvalcoord2d

Func glEvalcoord2dv($u)
	DllCall("opengl32.dll", "none", "glEvalcoord2dv", "dword", $u)
EndFunc   ;==>glEvalcoord2dv

Func glEvalcoord2f($u, $v)
	DllCall("opengl32.dll", "none", "glEvalcoord2f", "float", $u, "float", $v)
EndFunc   ;==>glEvalcoord2f

Func glEvalcoord2fv($u)
	DllCall("opengl32.dll", "none", "glEvalcoord2fv", "dword", $u)
EndFunc   ;==>glEvalcoord2fv

Func glEvalMesh1($mode, $i1, $i2)
	DllCall("opengl32.dll", "none", "glEvalMesh1", "uint", $mode, "int", $i1, "int", $i2)
EndFunc   ;==>glEvalMesh1

Func glEvalMesh2($mode, $i1, $i2, $j1, $j2)
	DllCall("opengl32.dll", "none", "glEvalMesh2", "uint", $mode, "int", $i1, "int", $i2, "int", $j1, "int", $j2)
EndFunc   ;==>glEvalMesh2

Func glEvalPoint1($i)
	DllCall("opengl32.dll", "none", "glEvalPoint1", "int", $i)
EndFunc   ;==>glEvalPoint1

Func glEvalPoint2($i, $j)
	DllCall("opengl32.dll", "none", "glEvalPoint2", "int", $i, "int", $j)
EndFunc   ;==>glEvalPoint2

Func glFeedbackBuffer($size, $type, $buffer)
	DllCall("opengl32.dll", "none", "glFeedbackBuffer", "int", $size, "uint", $type, "dword", $buffer)
EndFunc   ;==>glFeedbackBuffer

Func glFinish()
	DllCall("opengl32.dll", "none", "glFinish")
EndFunc   ;==>glFinish

Func glFlush()
	DllCall("opengl32.dll", "none", "glFlush")
EndFunc   ;==>glFlush

Func glFogf($pname, $param)
	DllCall("opengl32.dll", "none", "glFogf", "uint", $pname, "float", $param)
EndFunc   ;==>glFogf

Func glFogfv($pname, $params)
	DllCall("opengl32.dll", "none", "glFogfv", "uint", $pname, "dword", $params)
EndFunc   ;==>glFogfv

Func glFogi($pname, $param)
	DllCall("opengl32.dll", "none", "glFogi", "uint", $pname, "int", $param)
EndFunc   ;==>glFogi

Func glFogiv($pname, $params)
	DllCall("opengl32.dll", "none", "glFogiv", "uint", $pname, "dword", $params)
EndFunc   ;==>glFogiv

Func glFrontFace($mode)
	DllCall("opengl32.dll", "none", "glFrontFace", "uint", $mode)
EndFunc   ;==>glFrontFace

Func glFrustum($left, $right, $bottom, $top, $zNear, $zFar)
	DllCall("opengl32.dll", "none", "glFrustum", "double", $left, "double", $right, "double", $bottom, "double", $top, "double", $zNear, "double", $zFar)
EndFunc   ;==>glFrustum

Func glGenLists($range)
	DllCall("opengl32.dll", "uint", "glGenLists", "int", $range)
EndFunc   ;==>glGenLists

Func glGenTextures($n, $textures)
	DllCall("opengl32.dll", "none", "glGenTextures", "int", $n, "dword", $textures)
EndFunc   ;==>glGenTextures

Func glGetBooleanv($pname, $params)
	DllCall("opengl32.dll", "none", "glGetBooleanv", "uint", $pname, "dword", $params)
EndFunc   ;==>glGetBooleanv

Func glGetClipPlane($plane, $equation)
	DllCall("opengl32.dll", "none", "glGetClipPlane", "uint", $plane, "dword", $equation)
EndFunc   ;==>glGetClipPlane

Func glGetDoublev($pname, $params)
	DllCall("opengl32.dll", "none", "glGetDoublev", "uint", $pname, "dword", $params)
EndFunc   ;==>glGetDoublev

Func glGetError()
	DllCall("opengl32.dll", "uint", "glGetError")
EndFunc   ;==>glGetError

Func glGetFloatv($pname, $params)
	DllCall("opengl32.dll", "none", "glGetFloatv", "uint", $pname, "dword", $params)
EndFunc   ;==>glGetFloatv

Func glGetIntegerv($pname, $params)
	DllCall("opengl32.dll", "none", "glGetIntegerv", "uint", $pname, "dword", $params)
EndFunc   ;==>glGetIntegerv

Func glGetlightfv($light, $pname, $params)
	DllCall("opengl32.dll", "none", "glGetlightfv", "uint", $light, "uint", $pname, "dword", $params)
EndFunc   ;==>glGetlightfv

Func glGetlightiv($light, $pname, $params)
	DllCall("opengl32.dll", "none", "glGetlightiv", "uint", $light, "uint", $pname, "dword", $params)
EndFunc   ;==>glGetlightiv

Func glGetMapdv($target, $query, $v)
	DllCall("opengl32.dll", "none", "glGetMapdv", "uint", $target, "uint", $query, "dword", $v)
EndFunc   ;==>glGetMapdv

Func glGetMapfv($target, $query, $v)
	DllCall("opengl32.dll", "none", "glGetMapfv", "uint", $target, "uint", $query, "dword", $v)
EndFunc   ;==>glGetMapfv

Func glGetMapiv($target, $query, $v)
	DllCall("opengl32.dll", "none", "glGetMapiv", "uint", $target, "uint", $query, "dword", $v)
EndFunc   ;==>glGetMapiv

Func glGetMaterialfv($face, $pname, $params)
	DllCall("opengl32.dll", "none", "glGetMaterialfv", "uint", $face, "uint", $pname, "dword", $params)
EndFunc   ;==>glGetMaterialfv

Func glGetMaterialiv($face, $pname, $params)
	DllCall("opengl32.dll", "none", "glGetMaterialiv", "uint", $face, "uint", $pname, "dword", $params)
EndFunc   ;==>glGetMaterialiv

Func glGetPixelMapfv($map, $values)
	DllCall("opengl32.dll", "none", "glGetPixelMapfv", "uint", $map, "dword", $values)
EndFunc   ;==>glGetPixelMapfv

Func glGetPixelMapuiv($map, $values)
	DllCall("opengl32.dll", "none", "glGetPixelMapuiv", "uint", $map, "dword", $values)
EndFunc   ;==>glGetPixelMapuiv

Func glGetPixelMapusv($map, $values)
	DllCall("opengl32.dll", "none", "glGetPixelMapusv", "uint", $map, "dword", $values)
EndFunc   ;==>glGetPixelMapusv

Func glGetpointerv($pname, $params)
	DllCall("opengl32.dll", "none", "glGetpointerv", "uint", $pname, "dword", $params)
EndFunc   ;==>glGetpointerv

Func glGetPolygonStipple($mask)
	DllCall("opengl32.dll", "none", "glGetPolygonStipple", "dword", $mask)
EndFunc   ;==>glGetPolygonStipple

Func glGetString($name)
	DllCall("opengl32.dll", "dword", "glGetString", "uint", $name)
EndFunc   ;==>glGetString

Func glGetTexEnvfv($target, $pname, $params)
	DllCall("opengl32.dll", "none", "glGetTexEnvfv", "uint", $target, "uint", $pname, "dword", $params)
EndFunc   ;==>glGetTexEnvfv

Func glGetTexEnviv($target, $pname, $params)
	DllCall("opengl32.dll", "none", "glGetTexEnviv", "uint", $target, "uint", $pname, "dword", $params)
EndFunc   ;==>glGetTexEnviv

Func glGetTexGendv($coord, $pname, $params)
	DllCall("opengl32.dll", "none", "glGetTexGendv", "uint", $coord, "uint", $pname, "dword", $params)
EndFunc   ;==>glGetTexGendv

Func glGetTexGenfv($coord, $pname, $params)
	DllCall("opengl32.dll", "none", "glGetTexGenfv", "uint", $coord, "uint", $pname, "dword", $params)
EndFunc   ;==>glGetTexGenfv

Func glGetTexGeniv($coord, $pname, $params)
	DllCall("opengl32.dll", "none", "glGetTexGeniv", "uint", $coord, "uint", $pname, "dword", $params)
EndFunc   ;==>glGetTexGeniv

Func glGetTexImage($target, $level, $format, $type, $pixels)
	DllCall("opengl32.dll", "none", "glGetTexImage", "uint", $target, "int", $level, "uint", $format, "uint", $type, "dword", $pixels)
EndFunc   ;==>glGetTexImage

Func glGetTexlevelparameterfv($target, $level, $pname, $params)
	DllCall("opengl32.dll", "none", "glGetTexlevelparameterfv", "uint", $target, "int", $level, "uint", $pname, "dword", $params)
EndFunc   ;==>glGetTexlevelparameterfv

Func glGetTexlevelparameteriv($target, $level, $pname, $params)
	DllCall("opengl32.dll", "none", "glGetTexlevelparameteriv", "uint", $target, "int", $level, "uint", $pname, "dword", $params)
EndFunc   ;==>glGetTexlevelparameteriv

Func glGetTexparameterfv($target, $pname, $params)
	DllCall("opengl32.dll", "none", "glGetTexparameterfv", "uint", $target, "uint", $pname, "dword", $params)
EndFunc   ;==>glGetTexparameterfv

Func glGetTexparameteriv($target, $pname, $params)
	DllCall("opengl32.dll", "none", "glGetTexparameteriv", "uint", $target, "uint", $pname, "dword", $params)
EndFunc   ;==>glGetTexparameteriv

Func glHint($target, $mode)
	DllCall("opengl32.dll", "none", "glHint", "uint", $target, "uint", $mode)
EndFunc   ;==>glHint

Func glIndexmask($mask)
	DllCall("opengl32.dll", "none", "glIndexmask", "uint", $mask)
EndFunc   ;==>glIndexmask

Func glIndexpointer($type, $stride, $pointer)
	DllCall("opengl32.dll", "none", "glIndexpointer", "uint", $type, "int", $stride, "dword", $pointer)
EndFunc   ;==>glIndexpointer

Func glIndexd($c)
	DllCall("opengl32.dll", "none", "glIndexd", "double", $c)
EndFunc   ;==>glIndexd

Func glIndexdv($c)
	DllCall("opengl32.dll", "none", "glIndexdv", "dword", $c)
EndFunc   ;==>glIndexdv

Func glIndexf($c)
	DllCall("opengl32.dll", "none", "glIndexf", "float", $c)
EndFunc   ;==>glIndexf

Func glIndexfv($c)
	DllCall("opengl32.dll", "none", "glIndexfv", "dword", $c)
EndFunc   ;==>glIndexfv

Func glIndexi($c)
	DllCall("opengl32.dll", "none", "glIndexi", "int", $c)
EndFunc   ;==>glIndexi

Func glIndexiv($c)
	DllCall("opengl32.dll", "none", "glIndexiv", "dword", $c)
EndFunc   ;==>glIndexiv

Func glIndexs($c)
	DllCall("opengl32.dll", "none", "glIndexs", "short", $c)
EndFunc   ;==>glIndexs

Func glIndexsv($c)
	DllCall("opengl32.dll", "none", "glIndexsv", "dword", $c)
EndFunc   ;==>glIndexsv

Func glIndexub($c)
	DllCall("opengl32.dll", "none", "glIndexub", "ubyte", $c)
EndFunc   ;==>glIndexub

Func glIndexubv($c)
	DllCall("opengl32.dll", "none", "glIndexubv", "dword", $c)
EndFunc   ;==>glIndexubv

Func glInitNames()
	DllCall("opengl32.dll", "none", "glInitNames")
EndFunc   ;==>glInitNames

Func glInterleavedarrays($format, $stride, $pointer)
	DllCall("opengl32.dll", "none", "glInterleavedarrays", "uint", $format, "int", $stride, "dword", $pointer)
EndFunc   ;==>glInterleavedarrays

Func glIsEnabled($cap)
	DllCall("opengl32.dll", "ubyte", "glIsEnabled", "uint", $cap)
EndFunc   ;==>glIsEnabled

Func glIsList($list)
	DllCall("opengl32.dll", "ubyte", "glIsList", "uint", $list)
EndFunc   ;==>glIsList

Func glIsTexture($texture)
	DllCall("opengl32.dll", "ubyte", "glIsTexture", "uint", $texture)
EndFunc   ;==>glIsTexture

Func gllightModelf($pname, $param)
	DllCall("opengl32.dll", "none", "gllightModelf", "uint", $pname, "float", $param)
EndFunc   ;==>gllightModelf

Func gllightModelfv($pname, $params)
	DllCall("opengl32.dll", "none", "gllightModelfv", "uint", $pname, "dword", $params)
EndFunc   ;==>gllightModelfv

Func gllightModeli($pname, $param)
	DllCall("opengl32.dll", "none", "gllightModeli", "uint", $pname, "int", $param)
EndFunc   ;==>gllightModeli

Func gllightModeliv($pname, $params)
	DllCall("opengl32.dll", "none", "gllightModeliv", "uint", $pname, "dword", $params)
EndFunc   ;==>gllightModeliv

Func gllightf($light, $pname, $param)
	DllCall("opengl32.dll", "none", "gllightf", "uint", $light, "uint", $pname, "float", $param)
EndFunc   ;==>gllightf

Func gllightfv($light, $pname, $params)
	DllCall("opengl32.dll", "none", "gllightfv", "uint", $light, "uint", $pname, "dword", $params)
EndFunc   ;==>gllightfv

Func gllighti($light, $pname, $param)
	DllCall("opengl32.dll", "none", "gllighti", "uint", $light, "uint", $pname, "int", $param)
EndFunc   ;==>gllighti

Func gllightiv($light, $pname, $params)
	DllCall("opengl32.dll", "none", "gllightiv", "uint", $light, "uint", $pname, "dword", $params)
EndFunc   ;==>gllightiv

Func glLineStipple($factor, $pattern)
	DllCall("opengl32.dll", "none", "glLineStipple", "int", $factor, "ushort", $pattern)
EndFunc   ;==>glLineStipple

Func glLinewidth($width)
	DllCall("opengl32.dll", "none", "glLinewidth", "float", $width)
EndFunc   ;==>glLinewidth

Func glListBase($base)
	DllCall("opengl32.dll", "none", "glListBase", "uint", $base)
EndFunc   ;==>glListBase

Func glLoadIdentity()
	DllCall("opengl32.dll", "none", "glLoadIdentity")
EndFunc   ;==>glLoadIdentity

Func glLoadMatrixd($m)
	DllCall("opengl32.dll", "none", "glLoadMatrixd", "dword", $m)
EndFunc   ;==>glLoadMatrixd

Func glLoadMatrixf($m)
	DllCall("opengl32.dll", "none", "glLoadMatrixf", "dword", $m)
EndFunc   ;==>glLoadMatrixf

Func glLoadName($name)
	DllCall("opengl32.dll", "none", "glLoadName", "uint", $name)
EndFunc   ;==>glLoadName

Func glLogicOp($opcode)
	DllCall("opengl32.dll", "none", "glLogicOp", "uint", $opcode)
EndFunc   ;==>glLogicOp

Func glMap1d($target, $u1, $u2, $stride, $order, $points)
	DllCall("opengl32.dll", "none", "glMap1d", "uint", $target, "double", $u1, "double", $u2, "int", $stride, "int", $order, "dword", $points)
EndFunc   ;==>glMap1d

Func glMap1f($target, $u1, $u2, $stride, $order, $points)
	DllCall("opengl32.dll", "none", "glMap1f", "uint", $target, "float", $u1, "float", $u2, "int", $stride, "int", $order, "dword", $points)
EndFunc   ;==>glMap1f

Func glMap2d($target, $u1, $u2, $ustride, $uorder, $v1, $v2, $vstride, $vorder, $points)
	DllCall("opengl32.dll", "none", "glMap2d", "uint", $target, "double", $u1, "double", $u2, "int", $ustride, "int", $uorder, "double", $v1, "double", $v2, "int", $vstride, "int", $vorder, "dword", $points)
EndFunc   ;==>glMap2d

Func glMap2f($target, $u1, $u2, $ustride, $uorder, $v1, $v2, $vstride, $vorder, $points)
	DllCall("opengl32.dll", "none", "glMap2f", "uint", $target, "float", $u1, "float", $u2, "int", $ustride, "int", $uorder, "float", $v1, "float", $v2, "int", $vstride, "int", $vorder, "dword", $points)
EndFunc   ;==>glMap2f

Func glMapGrid1d($un, $u1, $u2)
	DllCall("opengl32.dll", "none", "glMapGrid1d", "int", $un, "double", $u1, "double", $u2)
EndFunc   ;==>glMapGrid1d

Func glMapGrid1f($un, $u1, $u2)
	DllCall("opengl32.dll", "none", "glMapGrid1f", "int", $un, "float", $u1, "float", $u2)
EndFunc   ;==>glMapGrid1f

Func glMapGrid2d($un, $u1, $u2, $vn, $v1, $v2)
	DllCall("opengl32.dll", "none", "glMapGrid2d", "int", $un, "double", $u1, "double", $u2, "int", $vn, "double", $v1, "double", $v2)
EndFunc   ;==>glMapGrid2d

Func glMapGrid2f($un, $u1, $u2, $vn, $v1, $v2)
	DllCall("opengl32.dll", "none", "glMapGrid2f", "int", $un, "float", $u1, "float", $u2, "int", $vn, "float", $v1, "float", $v2)
EndFunc   ;==>glMapGrid2f

Func glMaterialf($face, $pname, $param)
	DllCall("opengl32.dll", "none", "glMaterialf", "uint", $face, "uint", $pname, "float", $param)
EndFunc   ;==>glMaterialf

Func glMaterialfv($face, $pname, $params)
	DllCall("opengl32.dll", "none", "glMaterialfv", "uint", $face, "uint", $pname, "dword", $params)
EndFunc   ;==>glMaterialfv

Func glMateriali($face, $pname, $param)
	DllCall("opengl32.dll", "none", "glMateriali", "uint", $face, "uint", $pname, "int", $param)
EndFunc   ;==>glMateriali

Func glMaterialiv($face, $pname, $params)
	DllCall("opengl32.dll", "none", "glMaterialiv", "uint", $face, "uint", $pname, "dword", $params)
EndFunc   ;==>glMaterialiv

Func glMatrixMode($mode)
	DllCall("opengl32.dll", "none", "glMatrixMode", "uint", $mode)
EndFunc   ;==>glMatrixMode

Func glMultMatrixd($m)
	DllCall("opengl32.dll", "none", "glMultMatrixd", "dword", $m)
EndFunc   ;==>glMultMatrixd

Func glMultMatrixf($m)
	DllCall("opengl32.dll", "none", "glMultMatrixf", "dword", $m)
EndFunc   ;==>glMultMatrixf

Func glNewList($list, $mode)
	DllCall("opengl32.dll", "none", "glNewList", "uint", $list, "uint", $mode)
EndFunc   ;==>glNewList

Func glNormal3b($nx, $ny, $nz)
	DllCall("opengl32.dll", "none", "glNormal3b", "byte", $nx, "byte", $ny, "byte", $nz)
EndFunc   ;==>glNormal3b

Func glNormal3bv($v)
	DllCall("opengl32.dll", "none", "glNormal3bv", "dword", $v)
EndFunc   ;==>glNormal3bv

Func glNormal3d($nx, $ny, $nz)
	DllCall("opengl32.dll", "none", "glNormal3d", "double", $nx, "double", $ny, "double", $nz)
EndFunc   ;==>glNormal3d

Func glNormal3dv($v)
	DllCall("opengl32.dll", "none", "glNormal3dv", "dword", $v)
EndFunc   ;==>glNormal3dv

Func glNormal3f($nx, $ny, $nz)
	DllCall("opengl32.dll", "none", "glNormal3f", "float", $nx, "float", $ny, "float", $nz)
EndFunc   ;==>glNormal3f

Func glNormal3fv($v)
	DllCall("opengl32.dll", "none", "glNormal3fv", "dword", $v)
EndFunc   ;==>glNormal3fv

Func glNormal3i($nx, $ny, $nz)
	DllCall("opengl32.dll", "none", "glNormal3i", "int", $nx, "int", $ny, "int", $nz)
EndFunc   ;==>glNormal3i

Func glNormal3iv($v)
	DllCall("opengl32.dll", "none", "glNormal3iv", "dword", $v)
EndFunc   ;==>glNormal3iv

Func glNormal3s($nx, $ny, $nz)
	DllCall("opengl32.dll", "none", "glNormal3s", "short", $nx, "short", $ny, "short", $nz)
EndFunc   ;==>glNormal3s

Func glNormal3sv($v)
	DllCall("opengl32.dll", "none", "glNormal3sv", "dword", $v)
EndFunc   ;==>glNormal3sv

Func glNormalpointer($type, $stride, $pointer)
	DllCall("opengl32.dll", "none", "glNormalpointer", "uint", $type, "int", $stride, "dword", $pointer)
EndFunc   ;==>glNormalpointer

Func glOrtho($left, $right, $bottom, $top, $zNear, $zFar)
	DllCall("opengl32.dll", "none", "glOrtho", "double", $left, "double", $right, "double", $bottom, "double", $top, "double", $zNear, "double", $zFar)
EndFunc   ;==>glOrtho

Func glPassThrough($token)
	DllCall("opengl32.dll", "none", "glPassThrough", "float", $token)
EndFunc   ;==>glPassThrough

Func glPixelMapfv($map, $mapsize, $values)
	DllCall("opengl32.dll", "none", "glPixelMapfv", "uint", $map, "int", $mapsize, "dword", $values)
EndFunc   ;==>glPixelMapfv

Func glPixelMapuiv($map, $mapsize, $values)
	DllCall("opengl32.dll", "none", "glPixelMapuiv", "uint", $map, "int", $mapsize, "dword", $values)
EndFunc   ;==>glPixelMapuiv

Func glPixelMapusv($map, $mapsize, $values)
	DllCall("opengl32.dll", "none", "glPixelMapusv", "uint", $map, "int", $mapsize, "dword", $values)
EndFunc   ;==>glPixelMapusv

Func glpixelstoref($pname, $param)
	DllCall("opengl32.dll", "none", "glpixelstoref", "uint", $pname, "float", $param)
EndFunc   ;==>glpixelstoref

Func glpixelstorei($pname, $param)
	DllCall("opengl32.dll", "none", "glpixelstorei", "uint", $pname, "int", $param)
EndFunc   ;==>glpixelstorei

Func glPixelTransferf($pname, $param)
	DllCall("opengl32.dll", "none", "glPixelTransferf", "uint", $pname, "float", $param)
EndFunc   ;==>glPixelTransferf

Func glPixelTransferi($pname, $param)
	DllCall("opengl32.dll", "none", "glPixelTransferi", "uint", $pname, "int", $param)
EndFunc   ;==>glPixelTransferi

Func glPixelZoom($xfactor, $yfactor)
	DllCall("opengl32.dll", "none", "glPixelZoom", "float", $xfactor, "float", $yfactor)
EndFunc   ;==>glPixelZoom

Func glPointsize($size)
	DllCall("opengl32.dll", "none", "glPointsize", "float", $size)
EndFunc   ;==>glPointsize

Func glPolygonMode($face, $mode)
	DllCall("opengl32.dll", "none", "glPolygonMode", "uint", $face, "uint", $mode)
EndFunc   ;==>glPolygonMode

Func glPolygonOffset($factor, $units)
	DllCall("opengl32.dll", "none", "glPolygonOffset", "float", $factor, "float", $units)
EndFunc   ;==>glPolygonOffset

Func glPolygonStipple($mask)
	DllCall("opengl32.dll", "none", "glPolygonStipple", "dword", $mask)
EndFunc   ;==>glPolygonStipple

Func glPopAttrib()
	DllCall("opengl32.dll", "none", "glPopAttrib")
EndFunc   ;==>glPopAttrib

Func glPopClientAttrib()
	DllCall("opengl32.dll", "none", "glPopClientAttrib")
EndFunc   ;==>glPopClientAttrib

Func glPopMatrix()
	DllCall("opengl32.dll", "none", "glPopMatrix")
EndFunc   ;==>glPopMatrix

Func glPopname()
	DllCall("opengl32.dll", "none", "glPopname")
EndFunc   ;==>glPopname

Func glPrioritizeTextures($n, $textures, $priorities)
	DllCall("opengl32.dll", "none", "glPrioritizeTextures", "int", $n, "dword", $textures, "dword", $priorities)
EndFunc   ;==>glPrioritizeTextures

Func glPushAttrib($mask)
	DllCall("opengl32.dll", "none", "glPushAttrib", "uint", $mask)
EndFunc   ;==>glPushAttrib

Func glPushClientAttrib($mask)
	DllCall("opengl32.dll", "none", "glPushClientAttrib", "uint", $mask)
EndFunc   ;==>glPushClientAttrib

Func glPushMatrix()
	DllCall("opengl32.dll", "none", "glPushMatrix")
EndFunc   ;==>glPushMatrix

Func glPushName($name)
	DllCall("opengl32.dll", "none", "glPushName", "uint", $name)
EndFunc   ;==>glPushName

Func glRasterPos2d($x, $y)
	DllCall("opengl32.dll", "none", "glRasterPos2d", "double", $x, "double", $y)
EndFunc   ;==>glRasterPos2d

Func glRasterPos2dv($v)
	DllCall("opengl32.dll", "none", "glRasterPos2dv", "dword", $v)
EndFunc   ;==>glRasterPos2dv

Func glRasterPos2f($x, $y)
	DllCall("opengl32.dll", "none", "glRasterPos2f", "float", $x, "float", $y)
EndFunc   ;==>glRasterPos2f

Func glRasterPos2fv($v)
	DllCall("opengl32.dll", "none", "glRasterPos2fv", "dword", $v)
EndFunc   ;==>glRasterPos2fv

Func glRasterPos2i($x, $y)
	DllCall("opengl32.dll", "none", "glRasterPos2i", "int", $x, "int", $y)
EndFunc   ;==>glRasterPos2i

Func glRasterPos2iv($v)
	DllCall("opengl32.dll", "none", "glRasterPos2iv", "dword", $v)
EndFunc   ;==>glRasterPos2iv

Func glRasterPos2s($x, $y)
	DllCall("opengl32.dll", "none", "glRasterPos2s", "short", $x, "short", $y)
EndFunc   ;==>glRasterPos2s

Func glRasterPos2sv($v)
	DllCall("opengl32.dll", "none", "glRasterPos2sv", "dword", $v)
EndFunc   ;==>glRasterPos2sv

Func glRasterPos3d($x, $y, $z)
	DllCall("opengl32.dll", "none", "glRasterPos3d", "double", $x, "double", $y, "double", $z)
EndFunc   ;==>glRasterPos3d

Func glRasterPos3dv($v)
	DllCall("opengl32.dll", "none", "glRasterPos3dv", "dword", $v)
EndFunc   ;==>glRasterPos3dv

Func glRasterPos3f($x, $y, $z)
	DllCall("opengl32.dll", "none", "glRasterPos3f", "float", $x, "float", $y, "float", $z)
EndFunc   ;==>glRasterPos3f

Func glRasterPos3fv($v)
	DllCall("opengl32.dll", "none", "glRasterPos3fv", "dword", $v)
EndFunc   ;==>glRasterPos3fv

Func glRasterPos3i($x, $y, $z)
	DllCall("opengl32.dll", "none", "glRasterPos3i", "int", $x, "int", $y, "int", $z)
EndFunc   ;==>glRasterPos3i

Func glRasterPos3iv($v)
	DllCall("opengl32.dll", "none", "glRasterPos3iv", "dword", $v)
EndFunc   ;==>glRasterPos3iv

Func glRasterPos3s($x, $y, $z)
	DllCall("opengl32.dll", "none", "glRasterPos3s", "short", $x, "short", $y, "short", $z)
EndFunc   ;==>glRasterPos3s

Func glRasterPos3sv($v)
	DllCall("opengl32.dll", "none", "glRasterPos3sv", "dword", $v)
EndFunc   ;==>glRasterPos3sv

Func glRasterPos4d($x, $y, $z, $w)
	DllCall("opengl32.dll", "none", "glRasterPos4d", "double", $x, "double", $y, "double", $z, "double", $w)
EndFunc   ;==>glRasterPos4d

Func glRasterPos4dv($v)
	DllCall("opengl32.dll", "none", "glRasterPos4dv", "dword", $v)
EndFunc   ;==>glRasterPos4dv

Func glRasterPos4f($x, $y, $z, $w)
	DllCall("opengl32.dll", "none", "glRasterPos4f", "float", $x, "float", $y, "float", $z, "float", $w)
EndFunc   ;==>glRasterPos4f

Func glRasterPos4fv($v)
	DllCall("opengl32.dll", "none", "glRasterPos4fv", "dword", $v)
EndFunc   ;==>glRasterPos4fv

Func glRasterPos4i($x, $y, $z, $w)
	DllCall("opengl32.dll", "none", "glRasterPos4i", "int", $x, "int", $y, "int", $z, "int", $w)
EndFunc   ;==>glRasterPos4i

Func glRasterPos4iv($v)
	DllCall("opengl32.dll", "none", "glRasterPos4iv", "dword", $v)
EndFunc   ;==>glRasterPos4iv

Func glRasterPos4s($x, $y, $z, $w)
	DllCall("opengl32.dll", "none", "glRasterPos4s", "short", $x, "short", $y, "short", $z, "short", $w)
EndFunc   ;==>glRasterPos4s

Func glRasterPos4sv($v)
	DllCall("opengl32.dll", "none", "glRasterPos4sv", "dword", $v)
EndFunc   ;==>glRasterPos4sv

Func glReadBuffer($mode)
	DllCall("opengl32.dll", "none", "glReadBuffer", "uint", $mode)
EndFunc   ;==>glReadBuffer

Func glReadpixels($x, $y, $width, $height, $format, $type, $pixels)
	DllCall("opengl32.dll", "none", "glReadpixels", "int", $x, "int", $y, "int", $width, "int", $height, "uint", $format, "uint", $type, "dword", $pixels)
EndFunc   ;==>glReadpixels

Func glRectd($x1, $y1, $x2, $y2)
	DllCall("opengl32.dll", "none", "glRectd", "double", $x1, "double", $y1, "double", $x2, "double", $y2)
EndFunc   ;==>glRectd

Func glRectdv($v1, $v2)
	DllCall("opengl32.dll", "none", "glRectdv", "dword", $v1, "dword", $v2)
EndFunc   ;==>glRectdv

Func glRectf($x1, $y1, $x2, $y2)
	DllCall("opengl32.dll", "none", "glRectf", "float", $x1, "float", $y1, "float", $x2, "float", $y2)
EndFunc   ;==>glRectf

Func glRectfv($v1, $v2)
	DllCall("opengl32.dll", "none", "glRectfv", "dword", $v1, "dword", $v2)
EndFunc   ;==>glRectfv

Func glRecti($x1, $y1, $x2, $y2)
	DllCall("opengl32.dll", "none", "glRecti", "int", $x1, "int", $y1, "int", $x2, "int", $y2)
EndFunc   ;==>glRecti

Func glRectiv($v1, $v2)
	DllCall("opengl32.dll", "none", "glRectiv", "dword", $v1, "dword", $v2)
EndFunc   ;==>glRectiv

Func glRects($x1, $y1, $x2, $y2)
	DllCall("opengl32.dll", "none", "glRects", "short", $x1, "short", $y1, "short", $x2, "short", $y2)
EndFunc   ;==>glRects

Func glRectsv($v1, $v2)
	DllCall("opengl32.dll", "none", "glRectsv", "dword", $v1, "dword", $v2)
EndFunc   ;==>glRectsv

Func glRenderMode($mode)
	DllCall("opengl32.dll", "int", "glRenderMode", "uint", $mode)
EndFunc   ;==>glRenderMode

Func glRotated($angle, $x, $y, $z)
	DllCall("opengl32.dll", "none", "glRotated", "double", $angle, "double", $x, "double", $y, "double", $z)
EndFunc   ;==>glRotated

Func glRotatef($angle, $x, $y, $z)
	DllCall("opengl32.dll", "none", "glRotatef", "float", $angle, "float", $x, "float", $y, "float", $z)
EndFunc   ;==>glRotatef

Func glScaled($x, $y, $z)
	DllCall("opengl32.dll", "none", "glScaled", "double", $x, "double", $y, "double", $z)
EndFunc   ;==>glScaled

Func glScalef($x, $y, $z)
	DllCall("opengl32.dll", "none", "glScalef", "float", $x, "float", $y, "float", $z)
EndFunc   ;==>glScalef

Func glScissor($x, $y, $width, $height)
	DllCall("opengl32.dll", "none", "glScissor", "int", $x, "int", $y, "int", $width, "int", $height)
EndFunc   ;==>glScissor

Func glSelectBuffer($size, $buffer)
	DllCall("opengl32.dll", "none", "glSelectBuffer", "int", $size, "dword", $buffer)
EndFunc   ;==>glSelectBuffer

Func glShadeModel($mode)
	DllCall("opengl32.dll", "none", "glShadeModel", "uint", $mode)
EndFunc   ;==>glShadeModel

Func glStencilFunc($func, $ref, $mask)
	DllCall("opengl32.dll", "none", "glStencilFunc", "uint", $func, "int", $ref, "uint", $mask)
EndFunc   ;==>glStencilFunc

Func glStencilmask($mask)
	DllCall("opengl32.dll", "none", "glStencilmask", "uint", $mask)
EndFunc   ;==>glStencilmask

Func glStencilOp($fail, $zfail, $zpass)
	DllCall("opengl32.dll", "none", "glStencilOp", "uint", $fail, "uint", $zfail, "uint", $zpass)
EndFunc   ;==>glStencilOp

Func glTexcoord1d($s)
	DllCall("opengl32.dll", "none", "glTexcoord1d", "double", $s)
EndFunc   ;==>glTexcoord1d

Func glTexcoord1dv($v)
	DllCall("opengl32.dll", "none", "glTexcoord1dv", "dword", $v)
EndFunc   ;==>glTexcoord1dv

Func glTexcoord1f($s)
	DllCall("opengl32.dll", "none", "glTexcoord1f", "float", $s)
EndFunc   ;==>glTexcoord1f

Func glTexcoord1fv($v)
	DllCall("opengl32.dll", "none", "glTexcoord1fv", "dword", $v)
EndFunc   ;==>glTexcoord1fv

Func glTexcoord1i($s)
	DllCall("opengl32.dll", "none", "glTexcoord1i", "int", $s)
EndFunc   ;==>glTexcoord1i

Func glTexcoord1iv($v)
	DllCall("opengl32.dll", "none", "glTexcoord1iv", "dword", $v)
EndFunc   ;==>glTexcoord1iv

Func glTexcoord1s($s)
	DllCall("opengl32.dll", "none", "glTexcoord1s", "short", $s)
EndFunc   ;==>glTexcoord1s

Func glTexcoord1sv($v)
	DllCall("opengl32.dll", "none", "glTexcoord1sv", "dword", $v)
EndFunc   ;==>glTexcoord1sv

Func glTexcoord2d($s, $t)
	DllCall("opengl32.dll", "none", "glTexcoord2d", "double", $s, "double", $t)
EndFunc   ;==>glTexcoord2d

Func glTexcoord2dv($v)
	DllCall("opengl32.dll", "none", "glTexcoord2dv", "dword", $v)
EndFunc   ;==>glTexcoord2dv

Func glTexcoord2f($s, $t)
	DllCall("opengl32.dll", "none", "glTexcoord2f", "float", $s, "float", $t)
EndFunc   ;==>glTexcoord2f

Func glTexcoord2fv($v)
	DllCall("opengl32.dll", "none", "glTexcoord2fv", "dword", $v)
EndFunc   ;==>glTexcoord2fv

Func glTexcoord2i($s, $t)
	DllCall("opengl32.dll", "none", "glTexcoord2i", "int", $s, "int", $t)
EndFunc   ;==>glTexcoord2i

Func glTexcoord2iv($v)
	DllCall("opengl32.dll", "none", "glTexcoord2iv", "dword", $v)
EndFunc   ;==>glTexcoord2iv

Func glTexcoord2s($s, $t)
	DllCall("opengl32.dll", "none", "glTexcoord2s", "short", $s, "short", $t)
EndFunc   ;==>glTexcoord2s

Func glTexcoord2sv($v)
	DllCall("opengl32.dll", "none", "glTexcoord2sv", "dword", $v)
EndFunc   ;==>glTexcoord2sv

Func glTexcoord3d($s, $t, $r)
	DllCall("opengl32.dll", "none", "glTexcoord3d", "double", $s, "double", $t, "double", $r)
EndFunc   ;==>glTexcoord3d

Func glTexcoord3dv($v)
	DllCall("opengl32.dll", "none", "glTexcoord3dv", "dword", $v)
EndFunc   ;==>glTexcoord3dv

Func glTexcoord3f($s, $t, $r)
	DllCall("opengl32.dll", "none", "glTexcoord3f", "float", $s, "float", $t, "float", $r)
EndFunc   ;==>glTexcoord3f

Func glTexcoord3fv($v)
	DllCall("opengl32.dll", "none", "glTexcoord3fv", "dword", $v)
EndFunc   ;==>glTexcoord3fv

Func glTexcoord3i($s, $t, $r)
	DllCall("opengl32.dll", "none", "glTexcoord3i", "int", $s, "int", $t, "int", $r)
EndFunc   ;==>glTexcoord3i

Func glTexcoord3iv($v)
	DllCall("opengl32.dll", "none", "glTexcoord3iv", "dword", $v)
EndFunc   ;==>glTexcoord3iv

Func glTexcoord3s($s, $t, $r)
	DllCall("opengl32.dll", "none", "glTexcoord3s", "short", $s, "short", $t, "short", $r)
EndFunc   ;==>glTexcoord3s

Func glTexcoord3sv($v)
	DllCall("opengl32.dll", "none", "glTexcoord3sv", "dword", $v)
EndFunc   ;==>glTexcoord3sv

Func glTexcoord4d($s, $t, $r, $q)
	DllCall("opengl32.dll", "none", "glTexcoord4d", "double", $s, "double", $t, "double", $r, "double", $q)
EndFunc   ;==>glTexcoord4d

Func glTexcoord4dv($v)
	DllCall("opengl32.dll", "none", "glTexcoord4dv", "dword", $v)
EndFunc   ;==>glTexcoord4dv

Func glTexcoord4f($s, $t, $r, $q)
	DllCall("opengl32.dll", "none", "glTexcoord4f", "float", $s, "float", $t, "float", $r, "float", $q)
EndFunc   ;==>glTexcoord4f

Func glTexcoord4fv($v)
	DllCall("opengl32.dll", "none", "glTexcoord4fv", "dword", $v)
EndFunc   ;==>glTexcoord4fv

Func glTexcoord4i($s, $t, $r, $q)
	DllCall("opengl32.dll", "none", "glTexcoord4i", "int", $s, "int", $t, "int", $r, "int", $q)
EndFunc   ;==>glTexcoord4i

Func glTexcoord4iv($v)
	DllCall("opengl32.dll", "none", "glTexcoord4iv", "dword", $v)
EndFunc   ;==>glTexcoord4iv

Func glTexcoord4s($s, $t, $r, $q)
	DllCall("opengl32.dll", "none", "glTexcoord4s", "short", $s, "short", $t, "short", $r, "short", $q)
EndFunc   ;==>glTexcoord4s

Func glTexcoord4sv($v)
	DllCall("opengl32.dll", "none", "glTexcoord4sv", "dword", $v)
EndFunc   ;==>glTexcoord4sv

Func glTexcoordpointer($size, $type, $stride, $pointer)
	DllCall("opengl32.dll", "none", "glTexcoordpointer", "int", $size, "uint", $type, "int", $stride, "dword", $pointer)
EndFunc   ;==>glTexcoordpointer

Func glTexEnvf($target, $pname, $param)
	DllCall("opengl32.dll", "none", "glTexEnvf", "uint", $target, "uint", $pname, "float", $param)
EndFunc   ;==>glTexEnvf

Func glTexEnvfv($target, $pname, $params)
	DllCall("opengl32.dll", "none", "glTexEnvfv", "uint", $target, "uint", $pname, "dword", $params)
EndFunc   ;==>glTexEnvfv

Func glTexEnvi($target, $pname, $param)
	DllCall("opengl32.dll", "none", "glTexEnvi", "uint", $target, "uint", $pname, "int", $param)
EndFunc   ;==>glTexEnvi

Func glTexEnviv($target, $pname, $params)
	DllCall("opengl32.dll", "none", "glTexEnviv", "uint", $target, "uint", $pname, "dword", $params)
EndFunc   ;==>glTexEnviv

Func glTexGend($coord, $pname, $param)
	DllCall("opengl32.dll", "none", "glTexGend", "uint", $coord, "uint", $pname, "double", $param)
EndFunc   ;==>glTexGend

Func glTexGendv($coord, $pname, $params)
	DllCall("opengl32.dll", "none", "glTexGendv", "uint", $coord, "uint", $pname, "dword", $params)
EndFunc   ;==>glTexGendv

Func glTexGenf($coord, $pname, $param)
	DllCall("opengl32.dll", "none", "glTexGenf", "uint", $coord, "uint", $pname, "float", $param)
EndFunc   ;==>glTexGenf

Func glTexGenfv($coord, $pname, $params)
	DllCall("opengl32.dll", "none", "glTexGenfv", "uint", $coord, "uint", $pname, "dword", $params)
EndFunc   ;==>glTexGenfv

Func glTexGeni($coord, $pname, $param)
	DllCall("opengl32.dll", "none", "glTexGeni", "uint", $coord, "uint", $pname, "int", $param)
EndFunc   ;==>glTexGeni

Func glTexGeniv($coord, $pname, $params)
	DllCall("opengl32.dll", "none", "glTexGeniv", "uint", $coord, "uint", $pname, "dword", $params)
EndFunc   ;==>glTexGeniv

Func glTexImage1D($target, $level, $internalformat, $width, $border, $format, $type, $pixels)
	DllCall("opengl32.dll", "none", "glTexImage1D", "uint", $target, "int", $level, "int", $internalformat, "int", $width, "int", $border, "uint", $format, "uint", $type, "dword", $pixels)
EndFunc   ;==>glTexImage1D

Func glTexImage2D($target, $level, $internalformat, $width, $height, $border, $format, $type, $pixels)
	DllCall("opengl32.dll", "none", "glTexImage2D", "uint", $target, "int", $level, "int", $internalformat, "int", $width, "int", $height, "int", $border, "uint", $format, "uint", $type, "dword", $pixels)
EndFunc   ;==>glTexImage2D

Func glTexparameterf($target, $pname, $param)
	DllCall("opengl32.dll", "none", "glTexparameterf", "uint", $target, "uint", $pname, "float", $param)
EndFunc   ;==>glTexparameterf

Func glTexparameterfv($target, $pname, $params)
	DllCall("opengl32.dll", "none", "glTexparameterfv", "uint", $target, "uint", $pname, "dword", $params)
EndFunc   ;==>glTexparameterfv

Func glTexparameteri($target, $pname, $param)
	DllCall("opengl32.dll", "none", "glTexparameteri", "uint", $target, "uint", $pname, "int", $param)
EndFunc   ;==>glTexparameteri

Func glTexparameteriv($target, $pname, $params)
	DllCall("opengl32.dll", "none", "glTexparameteriv", "uint", $target, "uint", $pname, "dword", $params)
EndFunc   ;==>glTexparameteriv

Func glTexSubImage1D($target, $level, $xoffset, $width, $format, $type, $pixels)
	DllCall("opengl32.dll", "none", "glTexSubImage1D", "uint", $target, "int", $level, "int", $xoffset, "int", $width, "uint", $format, "uint", $type, "dword", $pixels)
EndFunc   ;==>glTexSubImage1D

Func glTexSubImage2D($target, $level, $xoffset, $yoffset, $width, $height, $format, $type, $pixels)
	DllCall("opengl32.dll", "none", "glTexSubImage2D", "uint", $target, "int", $level, "int", $xoffset, "int", $yoffset, "int", $width, "int", $height, "uint", $format, "uint", $type, "dword", $pixels)
EndFunc   ;==>glTexSubImage2D

Func glTranslated($x, $y, $z)
	DllCall("opengl32.dll", "none", "glTranslated", "double", $x, "double", $y, "double", $z)
EndFunc   ;==>glTranslated

Func glTranslatef($x, $y, $z)
	DllCall("opengl32.dll", "none", "glTranslatef", "float", $x, "float", $y, "float", $z)
EndFunc   ;==>glTranslatef

Func glVertex2d($x, $y)
	DllCall("opengl32.dll", "none", "glVertex2d", "double", $x, "double", $y)
EndFunc   ;==>glVertex2d

Func glVertex2dv($v)
	DllCall("opengl32.dll", "none", "glVertex2dv", "dword", $v)
EndFunc   ;==>glVertex2dv

Func glVertex2f($x, $y)
	DllCall("opengl32.dll", "none", "glVertex2f", "float", $x, "float", $y)
EndFunc   ;==>glVertex2f

Func glVertex2fv($v)
	DllCall("opengl32.dll", "none", "glVertex2fv", "dword", $v)
EndFunc   ;==>glVertex2fv

Func glVertex2i($x, $y)
	DllCall("opengl32.dll", "none", "glVertex2i", "int", $x, "int", $y)
EndFunc   ;==>glVertex2i

Func glVertex2iv($v)
	DllCall("opengl32.dll", "none", "glVertex2iv", "dword", $v)
EndFunc   ;==>glVertex2iv

Func glVertex2s($x, $y)
	DllCall("opengl32.dll", "none", "glVertex2s", "short", $x, "short", $y)
EndFunc   ;==>glVertex2s

Func glVertex2sv($v)
	DllCall("opengl32.dll", "none", "glVertex2sv", "dword", $v)
EndFunc   ;==>glVertex2sv

Func glVertex3d($x, $y, $z)
	DllCall("opengl32.dll", "none", "glVertex3d", "double", $x, "double", $y, "double", $z)
EndFunc   ;==>glVertex3d

Func glVertex3dv($v)
	DllCall("opengl32.dll", "none", "glVertex3dv", "dword", $v)
EndFunc   ;==>glVertex3dv

Func glVertex3f($x, $y, $z)
	DllCall("opengl32.dll", "none", "glVertex3f", "float", $x, "float", $y, "float", $z)
EndFunc   ;==>glVertex3f

Func glVertex3fv($v)
	DllCall("opengl32.dll", "none", "glVertex3fv", "dword", $v)
EndFunc   ;==>glVertex3fv

Func glVertex3i($x, $y, $z)
	DllCall("opengl32.dll", "none", "glVertex3i", "int", $x, "int", $y, "int", $z)
EndFunc   ;==>glVertex3i

Func glVertex3iv($v)
	DllCall("opengl32.dll", "none", "glVertex3iv", "dword", $v)
EndFunc   ;==>glVertex3iv

Func glVertex3s($x, $y, $z)
	DllCall("opengl32.dll", "none", "glVertex3s", "short", $x, "short", $y, "short", $z)
EndFunc   ;==>glVertex3s

Func glVertex3sv($v)
	DllCall("opengl32.dll", "none", "glVertex3sv", "dword", $v)
EndFunc   ;==>glVertex3sv

Func glVertex4d($x, $y, $z, $w)
	DllCall("opengl32.dll", "none", "glVertex4d", "double", $x, "double", $y, "double", $z, "double", $w)
EndFunc   ;==>glVertex4d

Func glVertex4dv($v)
	DllCall("opengl32.dll", "none", "glVertex4dv", "dword", $v)
EndFunc   ;==>glVertex4dv

Func glVertex4f($x, $y, $z, $w)
	DllCall("opengl32.dll", "none", "glVertex4f", "float", $x, "float", $y, "float", $z, "float", $w)
EndFunc   ;==>glVertex4f

Func glVertex4fv($v)
	DllCall("opengl32.dll", "none", "glVertex4fv", "dword", $v)
EndFunc   ;==>glVertex4fv

Func glVertex4i($x, $y, $z, $w)
	DllCall("opengl32.dll", "none", "glVertex4i", "int", $x, "int", $y, "int", $z, "int", $w)
EndFunc   ;==>glVertex4i

Func glVertex4iv($v)
	DllCall("opengl32.dll", "none", "glVertex4iv", "dword", $v)
EndFunc   ;==>glVertex4iv

Func glVertex4s($x, $y, $z, $w)
	DllCall("opengl32.dll", "none", "glVertex4s", "short", $x, "short", $y, "short", $z, "short", $w)
EndFunc   ;==>glVertex4s

Func glVertex4sv($v)
	DllCall("opengl32.dll", "none", "glVertex4sv", "dword", $v)
EndFunc   ;==>glVertex4sv

Func glVertexpointer($size, $type, $stride, $pointer)
	DllCall("opengl32.dll", "none", "glVertexpointer", "int", $size, "uint", $type, "int", $stride, "dword", $pointer)
EndFunc   ;==>glVertexpointer

Func glViewport($x, $y, $width, $height)
	DllCall("opengl32.dll", "none", "glViewport", "int", $x, "int", $y, "int", $width, "int", $height)
EndFunc   ;==>glViewport
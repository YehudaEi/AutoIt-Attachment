#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.8.1
	Author:         minx

	Script Function:
		GLUT32 Functions

#ce ----------------------------------------------------------------------------

#include-once

Global $__GLUT_hDLL = "glut32.dll"

Func glutSolidTeapot($size)
	DllCall($__GLUT_hDLL, "none", "glutSolidTeapot", "double", $size)
EndFunc   ;==>glutSolidTeapot

Func glutWireTeapot($size)
	DllCall($__GLUT_hDLL, "none", "glutWireTeapot", "double", $size)
EndFunc   ;==>glutWireTeapot

Func glutSolidIcosahedron()
	DllCall($__GLUT_hDLL, "none", "glutSolidIcosahedron")
EndFunc   ;==>glutSolidIcosahedron

Func glutWireIcosahedron()
	DllCall($__GLUT_hDLL, "none", "glutWireIcosahedron")
EndFunc   ;==>glutWireIcosahedron

Func glutSolidCone($base, $height, $slices, $stacks)
	DllCall($__GLUT_hDLL, "none", "glutSolidCone", "double", $base, "double", $height, "int", $slices, "int", $stacks)
EndFunc   ;==>glutSolidCone

Func glutWireCone($base, $height, $slices, $stacks)
	DllCall($__GLUT_hDLL, "none", "glutWireCone", "double", $base, "double", $height, "int", $slices, "int", $stacks)
EndFunc   ;==>glutWireCone


Func glutInitWindowSize($width, $height)
	DllCall($__GLUT_hDLL, "none", "glutInitWindowSize", "int", $width, "int", $height)
EndFunc   ;==>glutInitWindowSize

Func glutInitWindowPosition($x, $y)
	DllCall($__GLUT_hDLL, "none", "glutInitWindowPosition", "int", $x, "int", $y)
EndFunc   ;==>glutInitWindowPosition


Func glutInitDisplayMode($x)
	DllCall($__GLUT_hDLL, "BOOLEAN", "glutInitDisplayMode", "int", $x)
EndFunc   ;==>glutInitDisplayMode

Func glutCreateWindow($x)
	DllCall($__GLUT_hDLL, "int", "glutCreateWindow", "char", $x)
EndFunc   ;==>glutInitDisplayMode


Func glutInit()
	DllOpen($__GL_hDLL)
	;DllCall($__GLUT_hDLL, "none", "glutInit", "int", $x,"char",$y)
EndFunc   ;==>glutInitDisplayMode

Func glutSolidTetrahedron()
	DllCall($__GLUT_hDLL, "none", "glutSolidTetrahedron")
EndFunc   ;==>glutSolidTetrahedron

Func glutWireTetrahedron()
	DllCall($__GLUT_hDLL, "none", "glutWireTetrahedron")
EndFunc   ;==>glutWireTetrahedron

Func glutSolidCube($size)
	DllCall("glut32.dll", "none", "glutSolidCube", "double", $size)
EndFunc   ;==>glutSolidCube

Func glutWireCube($size)
	DllCall("glut32.dll", "none", "glutWireCube", "double", $size)
EndFunc   ;==>glutWireCube

Func glutWireSphere($radius, $slices, $stacks)
    DllCall("glut32.dll", "none", "glutWireSphere", "double", $radius, "long", $slices, "long", $stacks)
EndFunc   ;==>glutWireSphere

Func glutSolidSphere($radius, $slices, $stacks)
    DllCall("glut32.dll", "none", "glutSolidSphere", "double", $radius, "long", $slices, "long", $stacks)
EndFunc   ;==>glutSolidSphere

Func glutSolidOctahedron()
	DllCall($__GLUT_hDLL, "none", "glutSolidOctahedron")
EndFunc   ;==>glutSolidOctahedron

Func glutWireOctahedron()
	DllCall($__GLUT_hDLL, "none", "glutWireOctahedron")
EndFunc   ;==>glutWireOctahedron

Func glutSolidDodecahedron()
	DllCall($__GLUT_hDLL, "none", "glutSolidDodecahedron")
EndFunc   ;==>glutSolidDodecahedron

Func glutWireDodecahedron()
	DllCall($__GLUT_hDLL, "none", "glutWireDodecahedron")
EndFunc   ;==>glutWireDodecahedron

Func glutWireTorus($innerRadius, $outerRadius, $sides, $rings)
	DllCall($__GLUT_hDLL, "none", "glutWireTorus", "double", $innerRadius, "double", $outerRadius, "int", $sides, "int", $rings)
EndFunc

Func glutSolidTorus($innerRadius, $outerRadius, $sides, $rings)
	DllCall($__GLUT_hDLL, "none", "glutSolidTorus", "double", $innerRadius, "double", $outerRadius, "int", $sides, "int", $rings)
EndFunc
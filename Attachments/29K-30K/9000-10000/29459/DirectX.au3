;.......script written by trancexx (trancexx at yahoo dot com); Based on Direct3D example by Andrey Ch.

Opt("MustDeclareVars", 1)
Opt("GUIOnEventMode", 1)

Global Const $D3DCLEAR_TARGET = 1
Global Const $D3DFVF_XYZRHW = 0x40
Global Const $D3DFVF_DIFFUSE = 4
Global Const $D3DPT_TRIANGLELIST = 4
Global Const $D3DSWAPEFFECT_DISCARD = 1
Global Const $D3DDEVTYPE_HAL = 1
Global Const $D3DCREATE_SOFTWARE_VERTEXPROCESSING = 0x20
Global Const $D3DADAPTER_DEFAULT = 0
Global Const $D3DPOOL_DEFAULT = 0


; Used Dlls
Global Const $hD3D9 = DllOpen("d3d9.dll")
Global Const $hUSER32 = DllOpen("user32.dll")
Global Const $hKERNEL32 = DllOpen("kernel32.dll")

; GUI
Global Const $hGUI = GUICreate("DirectX -- Direct3D", 400, 400)

; IDirect3D9 interface
Global Const $pD3D9 = _Direct3DCreate9()
; IDirect3D9 interface structure
Global Const $tD3D9Interface = _D3D9_CreateD3D9Interface($pD3D9)

; CreateDevice Method pointer
Global Const $pCreateDevice = DllStructGetData($tD3D9Interface, "CreateDevice")
; Call CreateDevice to cet IDirect3DDevice9 interface
Global Const $pDevice = _D3D9_CreateDevice($hGUI, $pD3D9, $pCreateDevice)

; IDirect3DDevice9 interface structure
Global Const $tD3DDevice9Interface = _D3D9_CreateD3DDevice9Interface($pDevice)


; Defining three points of the triangle to make
Global $tagCUSTOMVERTEX = "float X;float Y;float Z;float rhw;dword Color;"
Global $tVERTICES = DllStructCreate($tagCUSTOMVERTEX & $tagCUSTOMVERTEX & $tagCUSTOMVERTEX)

; First point
DllStructSetData($tVERTICES, 1, 200) ; X
DllStructSetData($tVERTICES, 2, 50) ; Y
DllStructSetData($tVERTICES, 3, 0) ; Z
DllStructSetData($tVERTICES, 4, 1) ; Z
DllStructSetData($tVERTICES, 5, 0xFFFF0000) ; Red (ARGB)

; Second point
DllStructSetData($tVERTICES, 6, 350) ; X
DllStructSetData($tVERTICES, 7, 350) ; Y
DllStructSetData($tVERTICES, 8, 0) ; Z
DllStructSetData($tVERTICES, 9, 1)
DllStructSetData($tVERTICES, 10, 0xFF00FF00) ; Green (ARGB)

; Third point
DllStructSetData($tVERTICES, 11, 50) ; X
DllStructSetData($tVERTICES, 12, 350) ; Y
DllStructSetData($tVERTICES, 13, 0) ; Z
DllStructSetData($tVERTICES, 14, 1)
DllStructSetData($tVERTICES, 15, 0xFF0000FF) ; Blue (ARGB)


; Create IDirect3DVertexBuffer9 interface
Global Const $pD3DVB = _D3D9_CreateVertexBuffer($pDevice, DllStructGetSize($tVERTICES), 0, BitOR($D3DFVF_XYZRHW, $D3DFVF_DIFFUSE), $D3DPOOL_DEFAULT)

; IDirect3DVertexBuffer9 structure
Global Const $tIDirect3DVertexBuffer9 = _D3D9_CreateVertexStructure($pD3DVB)

_D3DVB_Lock($pD3DVB, DllStructGetSize($tVERTICES), DllStructGetPtr($tVERTICES), 0)
_D3DVB_Unlock($pD3DVB)


; Handle exit
GUISetOnEvent(-3, "_Quit")
; Show GUI
GUISetState()

; Render scene every 50ms till exit
While 1
	_Render()
	Sleep(50)
WEnd




; Drawing function
Func _Render()

	_D3DDevice9_Clear($pDevice, 0, 0, $D3DCLEAR_TARGET, 0xFFFFFF00, 1, 0) ;  yellow (ARGB)

	_D3DDevice9_BeginScene($pDevice)

	_D3DDevice9_SetStreamSource($pDevice, 0, $pD3DVB, 0, 20) ; DllStructGetSize($tCUSTOMVERTEX)

	_D3DDevice9_SetFVF($pDevice, 0x44) ; BitOR($D3DFVF_XYZRHW, $D3DFVF_DIFFUSE)
	_D3DDevice9_DrawPrimitive($pDevice, $D3DPT_TRIANGLELIST, 0, 1)
	_D3DDevice9_EndScene($pDevice)
	_D3DDevice9_Present($pDevice, 0, 0, 0, 0)

EndFunc   ;==>_Render



; D3DDevice9 Functions (Methods):

Func _D3DDevice9_BeginScene($pDevice)
	Local Static $pFunc = DllStructGetData($tD3DDevice9Interface, "BeginScene")
	Return _D3D9_Call($pDevice, $pFunc)
EndFunc   ;==>_D3DDevice9_BeginScene

Func _D3DDevice9_Clear($pDevice, $iCount, $pRects, $iFlags, $iColor, $nZ, $iStencil)
	Local Static $tFloat = DllStructCreate("float")
	Local Static $pFloat = DllStructGetPtr($tFloat)
	DllStructSetData($tFloat, 1, $nZ)
	Local Static $pFunc = DllStructGetData($tD3DDevice9Interface, "Clear")
	Return _D3D9_Call($pDevice, $pFunc, $iCount, $pRects, $iFlags, $iColor, $pFloat, $iStencil)
EndFunc   ;==>_D3DDevice9_Clear

Func _D3DDevice9_DrawPrimitive($pDevice, $iPrimitiveType, $iStartVertex, $iPrimitiveCount)
	Local Static $pFunc = DllStructGetData($tD3DDevice9Interface, "DrawPrimitive")
	Return _D3D9_Call($pDevice, $pFunc, $iPrimitiveType, $iStartVertex, $iPrimitiveCount)
EndFunc   ;==>_D3DDevice9_DrawPrimitive

Func _D3DDevice9_EndScene($pDevice)
	Local Static $pFunc = DllStructGetData($tD3DDevice9Interface, "EndScene")
	Return _D3D9_Call($pDevice, $pFunc)
EndFunc   ;==>_D3DDevice9_EndScene

Func _D3DDevice9_Present($pDevice, $pSourceRect, $pDestRect, $hDestWindowOverride, $pDirtyRegion)
	Local Static $pFunc = DllStructGetData($tD3DDevice9Interface, "Present")
	Return _D3D9_Call($pDevice, $pFunc, $pSourceRect, $pDestRect, $hDestWindowOverride, $pDirtyRegion)
EndFunc   ;==>_D3DDevice9_Present

Func _D3DDevice9_SetFVF($pDevice, $iFVF)
	Local Static $pFunc = DllStructGetData($tD3DDevice9Interface, "SetFVF")
	Return _D3D9_Call($pDevice, $pFunc, $iFVF)
EndFunc   ;==>_D3DDevice9_SetFVF

Func _D3DDevice9_SetStreamSource($pDevice, $iStreamNumber, $pStreamData, $iOffsetInBytes, $iStride)
	Local Static $pFunc = DllStructGetData($tD3DDevice9Interface, "SetStreamSource")
	Return _D3D9_Call($pDevice, $pFunc, $iStreamNumber, $pStreamData, $iOffsetInBytes, $iStride)
EndFunc   ;==>_D3DDevice9_SetStreamSource



; Direct3D9 functions:
Func _Direct3DCreate9()

	Local $aCall = DllCall($hD3D9, "ptr", "Direct3DCreate9", "dword", 32) ; D3D_SDK_VERSION = 32

	If @error Or Not $aCall[0] Then
		Return SetError(1, 0, 0)
	EndIf

	Return $aCall[0]

EndFunc   ;==>_Direct3DCreate9


Func _D3D9_CreateD3D9Interface($pD3D9)

	Local $tD3D9Interface = DllStructCreate("ptr QueryInterface;" & _
			"ptr AddRef;" & _
			"ptr Release;" & _
			"ptr RegisterSoftwareDevice;" & _
			"ptr GetAdapterCount;" & _
			"ptr GetAdapterIdentifier;" & _
			"ptr GetAdapterModeCount;" & _
			"ptr EnumAdapterModes;" & _
			"ptr GetAdapterDisplayMode;" & _
			"ptr CheckDeviceType;" & _
			"ptr CheckDeviceFormat;" & _
			"ptr CheckDeviceMultiSampleType;" & _
			"ptr CheckDepthStencilMatch;" & _
			"ptr CheckDeviceFormatConversion;" & _
			"ptr GetDeviceCaps;" & _
			"ptr GetAdapterMonitor;" & _
			"ptr CreateDevice;", _
			_DereferencePointer($pD3D9))

	Return $tD3D9Interface

EndFunc   ;==>_D3D9_CreateD3D9Interface


Func _D3D9_CreateDevice($hWnd, $pD3D9, $pCreateDevice)

	Local $tD3DPRESENT_PARAMETERS = DllStructCreate("dword BackBufferWidth;" & _
			"dword BackBufferHeight;" & _
			"dword BackBufferFormat;" & _
			"dword BackBufferCount;" & _
			"dword MultiSampleType;" & _
			"dword MultiSampleQuality;" & _
			"dword SwapEffect;" & _
			"ptr DeviceWindow;" & _
			"int Windowed;" & _
			"int EnableAutoDepthStencil;" & _
			"dword AutoDepthStencilFormat;" & _
			"dword Flags;" & _
			"dword FullScreenRefreshRateInHz;" & _
			"dword PresentationInterval;")

	DllStructSetData($tD3DPRESENT_PARAMETERS, "SwapEffect", $D3DSWAPEFFECT_DISCARD)
	DllStructSetData($tD3DPRESENT_PARAMETERS, "Windowed", 1)

	Local $tDevice = DllStructCreate("ptr")
	Local $iDevice = _D3D9_Call($pD3D9, $pCreateDevice, $D3DADAPTER_DEFAULT, $D3DDEVTYPE_HAL, $hWnd, $D3DCREATE_SOFTWARE_VERTEXPROCESSING, DllStructGetPtr($tD3DPRESENT_PARAMETERS), DllStructGetPtr($tDevice))

	If $iDevice Then Return SetError(1, 0, 0)
	Return DllStructGetData($tDevice, 1)

EndFunc   ;==>_D3D9_CreateDevice


Func _D3D9_CreateD3DDevice9Interface($pDevice)

	Local $tD3DDevice9Interface = DllStructCreate("ptr QueryInterface;" & _
			"ptr AddRef;" & _
			"ptr Release;" & _
			"ptr TestCooperativeLevel;" & _
			"ptr GetAvailableTextureMem;" & _
			"ptr EvictManagedResources;" & _
			"ptr GetDirect3D;" & _
			"ptr GetDeviceCaps;" & _
			"ptr GetDisplayMode;" & _
			"ptr GetCreationParameters;" & _
			"ptr SetCursorProperties;" & _
			"ptr SetCursorPosition;" & _
			"ptr ShowCursor;" & _
			"ptr CreateAdditionalSwapChain;" & _
			"ptr GetSwapChain;" & _
			"ptr GetNumberOfSwapChains;" & _
			"ptr Reset;" & _
			"ptr Present;" & _
			"ptr GetBackBuffer;" & _
			"ptr GetRasterStatus;" & _
			"ptr SetDialogBoxMode;" & _
			"ptr SetGammaRamp;" & _
			"ptr GetGammaRamp;" & _
			"ptr CreateTexture;" & _
			"ptr CreateVolumeTexture;" & _
			"ptr CreateCubeTexture;" & _
			"ptr CreateVertexBuffer;" & _
			"ptr CreateIndexBuffer;" & _
			"ptr CreateRenderTarget;" & _
			"ptr CreateDepthStencilSurface;" & _
			"ptr UpdateSurface;" & _
			"ptr UpdateTexture;" & _
			"ptr GetRenderTargetData;" & _
			"ptr GetFrontBufferData;" & _
			"ptr StretchRect;" & _
			"ptr ColorFill;" & _
			"ptr CreateOffscreenPlainSurface;" & _
			"ptr SetRenderTarget;" & _
			"ptr GetRenderTarget;" & _
			"ptr SetDepthStencilSurface;" & _
			"ptr GetDepthStencilSurface;" & _
			"ptr BeginScene;" & _
			"ptr EndScene;" & _
			"ptr Clear;" & _
			"ptr SetTransform;" & _
			"ptr GetTransform;" & _
			"ptr MultiplyTransform;" & _
			"ptr SetViewport;" & _
			"ptr GetViewport;" & _
			"ptr SetMaterial;" & _
			"ptr GetMaterial;" & _
			"ptr SetLight;" & _
			"ptr GetLight;" & _
			"ptr LightEnable;" & _
			"ptr GetLightEnable;" & _
			"ptr SetClipPlane;" & _
			"ptr GetClipPlane;" & _
			"ptr SetRenderState;" & _
			"ptr GetRenderState;" & _
			"ptr CreateStateBlock;" & _
			"ptr BeginStateBlock;" & _
			"ptr EndStateBlock;" & _
			"ptr SetClipStatus;" & _
			"ptr GetClipStatus;" & _
			"ptr GetTexture;" & _
			"ptr SetTexture;" & _
			"ptr GetTextureStageState;" & _
			"ptr SetTextureStageState;" & _
			"ptr GetSamplerState;" & _
			"ptr SetSamplerState;" & _
			"ptr ValidateDevice;" & _
			"ptr SetPaletteEntries;" & _
			"ptr GetPaletteEntries;" & _
			"ptr SetCurrentTexturePalette;" & _
			"ptr GetCurrentTexturePalette;" & _
			"ptr SetScissorRect;" & _
			"ptr GetScissorRect;" & _
			"ptr SetSoftwareVertexProcessing;" & _
			"ptr GetSoftwareVertexProcessing;" & _
			"ptr SetNPatchMode;" & _
			"ptr GetNPatchMode;" & _
			"ptr DrawPrimitive;" & _
			"ptr DrawIndexedPrimitive;" & _
			"ptr DrawPrimitiveUP;" & _
			"ptr DrawIndexedPrimitiveUP;" & _
			"ptr ProcessVertices;" & _
			"ptr CreateVertexDeclaration;" & _
			"ptr SetVertexDeclaration;" & _
			"ptr GetVertexDeclaration;" & _
			"ptr SetFVF;" & _
			"ptr GetFVF;" & _
			"ptr CreateVertexShader;" & _
			"ptr SetVertexShader;" & _
			"ptr GetVertexShader;" & _
			"ptr SetVertexShaderConstantF;" & _
			"ptr GetVertexShaderConstantF;" & _
			"ptr SetVertexShaderConstantI;" & _
			"ptr GetVertexShaderConstantI;" & _
			"ptr SetVertexShaderConstantB;" & _
			"ptr GetVertexShaderConstantB;" & _
			"ptr SetStreamSource;" & _
			"ptr GetStreamSource;" & _
			"ptr SetStreamSourceFreq;" & _
			"ptr GetStreamSourceFreq;" & _
			"ptr SetIndices;" & _
			"ptr GetIndices;" & _
			"ptr CreatePixelShader;" & _
			"ptr SetPixelShader;" & _
			"ptr GetPixelShader;" & _
			"ptr SetPixelShaderConstantF;" & _
			"ptr GetPixelShaderConstantF;" & _
			"ptr SetPixelShaderConstantI;" & _
			"ptr GetPixelShaderConstantI;" & _
			"ptr SetPixelShaderConstantB;" & _
			"ptr GetPixelShaderConstantB;" & _
			"ptr DrawRectPatch;" & _
			"ptr DrawTriPatch;" & _
			"ptr DeletePatch;" & _
			"ptr CreateQuery;", _
			_DereferencePointer($pDevice))

	Return $tD3DDevice9Interface

EndFunc   ;==>_D3D9_CreateD3DDevice9Interface


Func _D3D9_CreateVertexBuffer($pDevice, $iLength, $iUsage, $iFVF, $iPool)

	Local Static $pCreateVertexBuffer = DllStructGetData($tD3DDevice9Interface, "CreateVertexBuffer")
	Local $tD3DVB = DllStructCreate("ptr")
	_D3D9_Call($pDevice, $pCreateVertexBuffer, $iLength, $iUsage, $iFVF, $iPool, DllStructGetPtr($tD3DVB), 0)
	Return DllStructGetData($tD3DVB, 1)

EndFunc   ;==>_D3D9_CreateVertexBuffer


Func _D3D9_CreateVertexStructure($pD3DVB)

	Local $tIDirect3DVertexBuffer9 = DllStructCreate("ptr QueryInterface;" & _
			"ptr AddRef;" & _
			"ptr Release;" & _
			"ptr GetDevice;" & _
			"ptr SetPrivateData;" & _
			"ptr GetPrivateData;" & _
			"ptr FreePrivateData;" & _
			"ptr SetPriority;" & _
			"ptr GetPriority;" & _
			"ptr PreLoad;" & _
			"ptr GetType;" & _
			"ptr Lock;" & _
			"ptr Unlock;" & _
			"ptr GetDesc;", _
			_DereferencePointer($pD3DVB))

	Return $tIDirect3DVertexBuffer9

EndFunc   ;==>_D3D9_CreateVertexStructure


Func _D3DVB_Lock($pD3DVB, $iSizeToLock, $pData, $iFlags)

	Local Static $pLock = DllStructGetData($tIDirect3DVertexBuffer9, "Lock")
	Local $tVert = DllStructCreate("ptr")
	_D3D9_Call($pD3DVB, $pLock, 0, $iSizeToLock, DllStructGetPtr($tVert), 0)
	Local $pVert = DllStructGetData($tVert, 1)
	_CopyVert($pVert, $pData, $iSizeToLock)

	Return 0

EndFunc   ;==>_D3DVB_Lock


Func _D3DVB_Unlock($pD3DVB)

	Local Static $pFunc = DllStructGetData($tIDirect3DVertexBuffer9, "Unlock")
	Return _D3D9_Call($pD3DVB, $pFunc)

EndFunc   ;==>_D3DVB_Unlock


Func _CopyVert($pPointer1, $pPointer2, $iSize)
	DllCall($hKERNEL32, "none", "RtlMoveMemory", "ptr", $pPointer1, "ptr", $pPointer2, "dword_ptr", $iSize)
	If @error Then Return SetError(1, 0, 0)
	Return 1
EndFunc   ;==>_CopyVert







; The savior functions:

Func _D3D9_Call($pObject, $pFunc, $vParam1 = 0, $vParam2 = 0, $vParam3 = 0, $vParam4 = 0, $vParam5 = 0, $vParam6 = 0, $vParam7 = 0, $vParam8 = 0, $vParam9 = 0)

	Local Static $tCode = _AllocateExeCode(58)
	Local Static $pCode = DllStructGetPtr($tCode)
	Local $sPushParams

	Local $iNumParams = @NumParams
	For $i = $iNumParams - 2 To 1 Step -1
		$sPushParams &= "68" & SwapEndian(Eval("vParam" & $i))
	Next

	DllStructSetData($tCode, 1, "0x" & $sPushParams & "68" & SwapEndian($pObject) & "B8" & SwapEndian($pFunc) & "FFD0" & "C3")

	Local $aCall = DllCall($hUSER32, "dword", "CallWindowProcW", _
			"ptr", $pCode, _
			"int", 0, _
			"int", 0, _
			"int", 0, _
			"int", 0)

	If @error Then Return -1

	Return $aCall[0]

EndFunc   ;==>_D3D9_Call





; And four different functions:

Func _AllocateExeCode($iSize)
	Local $tCode = DllStructCreate("byte[" & $iSize & "]")
	_UnprotectMemory(DllStructGetPtr($tCode), $iSize)
	Return $tCode
EndFunc   ;==>_AllocateExeCode

Func _UnprotectMemory($pPointer, $iSize)
	Local $aCall = DllCall("kernel32.dll", "int", "VirtualProtect", _
			"ptr", $pPointer, _
			"dword", $iSize, _
			"dword", 64, _ ; MEM_EXECUTE_READWRITE
			"dword*", 0)
	If @error Or Not $aCall[0] Then
		Return SetError(1, 0, 0)
	EndIf
	Return $aCall[4]
EndFunc   ;==>_UnprotectMemory

Func SwapEndian($iValue)
	Return Hex(BinaryMid($iValue, 1, 4))
EndFunc   ;==>SwapEndian

Func _DereferencePointer($pPointer)
	Return DllStructGetData(DllStructCreate("ptr", $pPointer), 1)
EndFunc   ;==>_DereferencePointer



; On Exit Function
Func _Quit()
	; Releasing all three used interface here (I'm skipping it now because this is just before exit anyway)
	Exit
EndFunc   ;==>_Quit

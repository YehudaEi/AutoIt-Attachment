// fast pixel search dll.cpp : Defines the entry point for the DLL application.
//
#include "stdafx.h"


#ifdef _MANAGED
#pragma managed(push, off)
#endif


BOOL APIENTRY DllMain( HMODULE hModule,DWORD  ul_reason_for_call,LPVOID lpReserved)
{
    return TRUE;
}

#ifdef _MANAGED
#pragma managed(pop)
#endif


__declspec(dllexport)int SearchRegion(int nLeft, int nTop, int nWidth, int nHeight,  int nColor, int nStepX, int nStepY, int nRadius )
{	
	COLORREF CLR; //color of selected pixel
	int found = 98304;
	int Y;
	int X;
	double Temp;

		//save a screenshot to memory
HWND hDesktopWnd = GetDesktopWindow(); // Desktop handle
HDC hDesktopDC = GetDC(hDesktopWnd); // Desktop DC

	BITMAPINFO bi;
	void *pBits = NULL;
	ZeroMemory(&bi, sizeof(bi));
	bi.bmiHeader.biSize = sizeof(bi.bmiHeader);
	bi.bmiHeader.biHeight = nHeight;
	bi.bmiHeader.biWidth = nWidth;
	bi.bmiHeader.biPlanes = 1;
	bi.bmiHeader.biBitCount = 24;
	bi.bmiHeader.biCompression = BI_RGB;
	bi.bmiHeader.biSizeImage = ((nWidth * bi.bmiHeader.biBitCount +31)& ~31) /8 * nHeight; 
	HDC	hBmpFileDC=CreateCompatibleDC(hDesktopDC);
	HBITMAP	hBmpFileBitmap=CreateDIBSection(hDesktopDC,&bi,DIB_RGB_COLORS,&pBits,NULL,0);
	SelectObject(hBmpFileDC, hBmpFileBitmap);
	BitBlt(hBmpFileDC, 0, 0, nWidth, nHeight, hDesktopDC, nLeft,nTop, SRCCOPY);
	//search the screenshot
if (nRadius == -1)
{
for (X = 0; X <= nWidth; X+=nStepX)
	{
		for (Y = nTop; Y<= nHeight; Y+=nStepY)
		{
CLR = GetPixel(hBmpFileDC, X, Y);
if (CLR == nColor)
{
	found = (nLeft +X) * 131072 + Y + nTop;
	ReleaseDC(hDesktopWnd,hDesktopDC);
	DeleteDC(hBmpFileDC);
	DeleteObject(hBmpFileBitmap);
		return found;
			}
		}
	}
}
else
{
	for (X = 0; X <= 2*nRadius; X+=nStepX)
	{
		for (Y = nTop; Y<= 2*nRadius; Y+=nStepY)
		{Temp = (X - 23)^2+ (Y- 23)^2;
			Temp = sqrt (Temp);
			if (Temp<=nRadius)
			{
CLR = GetPixel(hBmpFileDC, X, Y);
if (CLR == nColor)
{ found = (nLeft +X) * 131072 + Y + nTop;
ReleaseDC(hDesktopWnd,hDesktopDC);
	DeleteDC(hBmpFileDC);
	DeleteObject(hBmpFileBitmap);
		return found;
}


			}
		}
	}
}
	ReleaseDC(hDesktopWnd,hDesktopDC);
	DeleteDC(hBmpFileDC);
	DeleteObject(hBmpFileBitmap);
   	return found;
}

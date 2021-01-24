// main.h
#ifndef __MAIN_H__
#define __MAIN_H__

#include <windows.h>

/*  To use this exported function of dll, include this header
*  in your project.
*/

#define DLL_EXPORT __declspec(dllexport) WINAPI



#ifdef __cplusplus
extern "C"
{
#endif

int DLL_EXPORT MySHFileOpW(LPSHFILEOPSTRUCT lpFileOp);
int DLL_EXPORT GetSHFileOpW(void *p);

#ifdef __cplusplus
}
#endif

#endif // __MAIN_H__
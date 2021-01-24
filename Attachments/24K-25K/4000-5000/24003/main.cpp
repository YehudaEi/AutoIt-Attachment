// main.cpp
#include "main.h"

int (WINAPI *pMySHFileOpW) (LPSHFILEOPSTRUCT); // pointer to the bridge

// SHFileOpW hook function
int DLL_EXPORT MySHFileOpW(LPSHFILEOPSTRUCT lpFileOp)
{
    if (pMySHFileOpW == NULL)
        return 1;
    
    // do something
    
    
    // call the original SHFileOpW function through the Bridge
    return pMySHFileOpW(lpFileOp);
}

// obtain the address to the Bridge
int DLL_EXPORT GetSHFileOpW(void *p)
{
    // this function must be called before setting the hook to provide the hooking function with the bridge address
    pMySHFileOpW = (int (WINAPI *)(LPSHFILEOPSTRUCT)) p;
    return 0;
}

BOOL WINAPI DllMain(HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpvReserved)
{
    switch (fdwReason)
    {
        case DLL_PROCESS_ATTACH:
            pMySHFileOpW = NULL;
        case DLL_PROCESS_DETACH:
        case DLL_THREAD_ATTACH:
        case DLL_THREAD_DETACH:
            break;
    }
    return TRUE; // succesful
}
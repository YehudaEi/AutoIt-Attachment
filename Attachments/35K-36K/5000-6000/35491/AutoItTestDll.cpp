// AutoItTestDll.cpp : Defines the exported functions for the DLL application.
//

#include "stdafx.h"

int _stdcall TestFunc(int x, int y)
{
    return x + y;
}

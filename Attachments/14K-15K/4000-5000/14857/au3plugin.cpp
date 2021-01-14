
/*
 *
 * AutoIt v3 Plugin SDK
 *
 * Copyright (C)1999-2006 Jonathan Bennett <jon at autoitscript com>
 *
 * au3plugin.c
 *
 * This code may be freely used to create plugins for use in AutoIt.
 *
 */

#include <stdio.h>
#include <windows.h>
#include "au3plugin.h"

// Disable 64bit warnings on Visual C .NET
#ifdef _MSC_VER
	#pragma warning(disable : 4311 4312)
#endif


/****************************************************************************
 * AU3_AllocVar()
 ****************************************************************************/

AU3_PLUGIN_VAR* AU3_AllocVar(void)
{
	AU3_PLUGIN_VAR *pVar = (AU3_PLUGIN_VAR *)malloc(sizeof(AU3_PLUGIN_VAR));
	pVar->m_nType	= AU3_PLUGIN_INT32;
	pVar->m_nValue	= 0;

	return pVar;
}


/****************************************************************************
 * AU3_ResetVar()
 ****************************************************************************/

void AU3_ResetVar(AU3_PLUGIN_VAR *pVar)
{
	if (pVar == NULL)
		return;

	if (pVar->m_nType == AU3_PLUGIN_STRING)
		free(pVar->m_szValue);

	pVar->m_nType	= AU3_PLUGIN_INT32;
	pVar->m_nValue	= 0;
}


/****************************************************************************
 * AU3_FreeVar()
 ****************************************************************************/

AU3_PLUGINAPI void AU3_FreeVar(AU3_PLUGIN_VAR *pVar)
{
	if (pVar == NULL)
		return;

	AU3_ResetVar(pVar);

	free(pVar);
}


/****************************************************************************
 * AU3_GetType()
 ****************************************************************************/

int AU3_GetType(const AU3_PLUGIN_VAR *pVar)
{
	return pVar->m_nType;
}


/****************************************************************************
 * AU3_SetString()
 ****************************************************************************/

void AU3_SetString(AU3_PLUGIN_VAR *pVar, const char *szString)
{
	AU3_ResetVar(pVar);

	pVar->m_nType = AU3_PLUGIN_STRING;
	pVar->m_szValue = (char *)malloc( strlen(szString)+1 );
	strcpy(pVar->m_szValue, szString);
}


/****************************************************************************
 * AU3_GetString()
 ****************************************************************************/

char * AU3_GetString(const AU3_PLUGIN_VAR *pVar)
{
	char	szTemp[32];						// It is unclear just how many 0000 the sprintf function can add...
	char	*szString;

	if (pVar->m_nType == AU3_PLUGIN_STRING)
	{
		szString = (char *)malloc( strlen(pVar->m_szValue)+1 );
		strcpy(szString, pVar->m_szValue);
		return szString;
	}


	switch(pVar->m_nType)
	{
		case AU3_PLUGIN_INT32:
			// Work out the string representation of the number
			itoa(pVar->m_nValue, szTemp, 10);
			break;

		case AU3_PLUGIN_INT64:
			// Work out the string representation of the number
			_i64toa(pVar->m_n64Value, szTemp, 10);
			break;

		case AU3_PLUGIN_DOUBLE:
			// Work out the string representation of the number, don't print trailing zeros
			sprintf(szTemp, "%.15g", pVar->m_fValue);		// Have at least 15 digits after the . for precision (default is 6)
			break;

		case AU3_PLUGIN_HWND:
			sprintf(szTemp, "0x%p", pVar->m_hWnd);
			break;
	}

	szString = (char *)malloc( strlen(szTemp)+1 );
	strcpy(szString, szTemp);
	return szString;

}


/****************************************************************************
 * AU3_FreeString()
 ****************************************************************************/

void AU3_FreeString(char *szString)
{
	free(szString);

}

/****************************************************************************
 * AU3_SetInt32()
 ****************************************************************************/

void AU3_SetInt32(AU3_PLUGIN_VAR *pVar, int nValue)
{
	AU3_ResetVar(pVar);

	pVar->m_nType = AU3_PLUGIN_INT32;
	pVar->m_nValue = nValue;
}


/****************************************************************************
 * AU3_GetInt32()
 ****************************************************************************/

int AU3_GetInt32(const AU3_PLUGIN_VAR *pVar)
{
	switch (pVar->m_nType)
	{
		case AU3_PLUGIN_INT32:
			return pVar->m_nValue;

		case AU3_PLUGIN_DOUBLE:
			return (int)pVar->m_fValue;

		case AU3_PLUGIN_STRING:
			if ( (pVar->m_szValue[0] == '0') && (pVar->m_szValue[1] == 'x' || pVar->m_szValue[1] == 'X') )
			{
				return AU3_HexToDec(&pVar->m_szValue[2]);	// Assume hex conversion
			}
			else
				return atoi(pVar->m_szValue);

		case AU3_PLUGIN_INT64:
			return (int)pVar->m_n64Value;

		case AU3_PLUGIN_HWND:
			return (int)pVar->m_hWnd;

		default:
			return 0;
	}

}


/****************************************************************************
 * AU3_SetInt64()
 ****************************************************************************/

void AU3_SetInt64(AU3_PLUGIN_VAR *pVar, __int64 n64Value)
{
	AU3_ResetVar(pVar);

	pVar->m_nType = AU3_PLUGIN_INT64;
	pVar->m_n64Value = n64Value;
}


/****************************************************************************
 * AU3_GetInt64()
 ****************************************************************************/

__int64 AU3_GetInt64(const AU3_PLUGIN_VAR *pVar)
{
	switch (pVar->m_nType)
	{
		case AU3_PLUGIN_INT32:
			return (__int64)pVar->m_nValue;

		case AU3_PLUGIN_DOUBLE:
			return (__int64)pVar->m_fValue;

		case AU3_PLUGIN_STRING:
			if ( (pVar->m_szValue[0] == '0') && (pVar->m_szValue[1] == 'x' || pVar->m_szValue[1] == 'X') )
			{
				return (__int64)AU3_HexToDec(&pVar->m_szValue[2]);	// Assume hex conversion
			}
			else
				return _atoi64(pVar->m_szValue);

		case AU3_PLUGIN_INT64:
			return pVar->m_n64Value;

		default:
			return 0;
	}

}


/****************************************************************************
 * AU3_SetDouble()
 ****************************************************************************/

void AU3_SetDouble(AU3_PLUGIN_VAR *pVar, double fValue)
{
	AU3_ResetVar(pVar);

	pVar->m_nType = AU3_PLUGIN_DOUBLE;
	pVar->m_fValue = fValue;
}


/****************************************************************************
 * AU3_GetDouble()
 ****************************************************************************/

double AU3_GetDouble(const AU3_PLUGIN_VAR *pVar)
{
	switch (pVar->m_nType)
	{
		case AU3_PLUGIN_INT32:
			return (double)pVar->m_nValue;

		case AU3_PLUGIN_DOUBLE:
			return pVar->m_fValue;

		case AU3_PLUGIN_STRING:
			if ( (pVar->m_szValue[0] == '0') && (pVar->m_szValue[1] == 'x' || pVar->m_szValue[1] == 'X') )
			{
				return (double)AU3_HexToDec(&pVar->m_szValue[2]);	// Assume hex conversion
			}
			else
				return atof(pVar->m_szValue);

		case AU3_PLUGIN_INT64:
			return (double)pVar->m_n64Value;

		default:
			return 0;
	}

}


/****************************************************************************
 * AU3_SethWnd()
 ****************************************************************************/

void AU3_SethWnd(AU3_PLUGIN_VAR *pVar, HWND hWnd)
{
	AU3_ResetVar(pVar);

	pVar->m_nType = AU3_PLUGIN_HWND;
	pVar->m_hWnd = hWnd;
}


/****************************************************************************
 * AU3_GethWnd()
 ****************************************************************************/

HWND AU3_GethWnd(const AU3_PLUGIN_VAR *pVar)
{
	switch (pVar->m_nType)
	{
		case AU3_PLUGIN_HWND:
			return pVar->m_hWnd;

		case AU3_PLUGIN_INT32:
			return (HWND)pVar->m_nValue;

		case AU3_PLUGIN_STRING:
			if ( (pVar->m_szValue[0] == '0') && (pVar->m_szValue[1] == 'x' || pVar->m_szValue[1] == 'X') )
			{
				return (HWND)AU3_HexToDec(&pVar->m_szValue[2]);	// Assume hex conversion
			}
			else
				return (HWND)atoi(pVar->m_szValue);

		default:
			return 0;
	}

}

/****************************************************************************
 * AU3_HexToDec()
 ****************************************************************************/

int AU3_HexToDec(const char *szHex)
{
	// Really crappy hex conversion
	int nDec;
	int i, j;
	int nMult;

	i = (int)strlen(szHex) - 1;

	nDec = 0;
	nMult = 1;
	for (j = 0; j < 8; ++j)
	{
		if (i < 0)
			break;

		if (szHex[i] >= '0' && szHex[i] <= '9')
			nDec += (szHex[i] - '0') * nMult;
		else if (szHex[i] >= 'A' && szHex[i] <= 'F')
			nDec += (((szHex[i] - 'A'))+10) * nMult;
		else if (szHex[i] >= 'a' && szHex[i] <= 'f')
			nDec += (((szHex[i] - 'a'))+10) * nMult;
		else
		{
			return 0;
		}

		--i;
		nMult = nMult * 16;
	}

	if (i != -1)
		nDec = 0;

	return nDec;

}

#ifndef __AU3PLUGIN_H
#define __AU3PLUGIN_H

/*
 *
 * AutoIt v3 Plugin SDK
 *
 * Copyright (C)1999-2006 Jonathan Bennett <jon at autoitscript com>
 *
 * au3plugin.h
 *
 * This code may be freely used to create plugins for use in AutoIt.
 *
 */

/* Includes */
#include <windows.h>


/* Defines */
#ifdef __cplusplus
	#define AU3_PLUGINAPI extern "C" __declspec(dllexport)
#else
	#define AU3_PLUGINAPI __declspec(dllexport)
#endif


#define AU3_PLUGIN_OK			0
#define AU3_PLUGIN_ERR			1

#define AU3_PLUGIN_INT32		1				/* 32bit Integer */
#define AU3_PLUGIN_INT64		2				/* 64bit Integer */
#define AU3_PLUGIN_DOUBLE		3				/* Double float */
#define AU3_PLUGIN_STRING		4				/* String */
#define AU3_PLUGIN_HWND			5				/* Handle (Window) */

#define AU3_PLUGIN_ITOA_MAX		65				/* Maximum returned length of an i64toa operation */


/* Variant and plugin function structures */
typedef struct tagAU3_PLUGIN_VAR
{
	int		m_nType;							/* Type */

	union
	{
		int			m_nValue;					/* Value of int32 (for AU3_PLUGIN_INT32) */
		__int64		m_n64Value;					/* Value of int64 (for AU3_PLUGIN_INT64) */
		double		m_fValue;					/* Value of double (for AU3_PLUGIN_DOUBLE) */
		char		*m_szValue;					/* Value of double (for AU3_PLUGIN_STRING) */
		HWND		m_hWnd;						/* Value of handle (for AU3_PLUGIN_HWND) */
	};

} AU3_PLUGIN_VAR;


typedef struct tagAU3_PLUGIN_FUNC
{
	char		*m_szName;
	int			m_nMinParams;
	int			m_nMaxParams;

} AU3_PLUGIN_FUNC;


/* Simplified function declarations */
#define AU3_PLUGIN_DEFINE(funcname) AU3_PLUGINAPI int funcname(int n_AU3_NumParams, const AU3_PLUGIN_VAR *p_AU3_Params, AU3_PLUGIN_VAR **p_AU3_Result, int *n_AU3_ErrorCode, int *n_AU3_ExtCode)


/* Helper functions for working with variant like variables */
AU3_PLUGIN_VAR *	AU3_AllocVar(void);
AU3_PLUGINAPI void	AU3_FreeVar(AU3_PLUGIN_VAR *pVar);
void				AU3_ResetVar(AU3_PLUGIN_VAR *pVar);
int					AU3_GetType(const AU3_PLUGIN_VAR *pVar);
void				AU3_SetString(AU3_PLUGIN_VAR *pVar, const char *szString);
char *				AU3_GetString(const AU3_PLUGIN_VAR *pVar);
void				AU3_FreeString(char *szString);
void				AU3_SetInt32(AU3_PLUGIN_VAR *pVar, int nValue);
int					AU3_GetInt32(const AU3_PLUGIN_VAR *pVar);
void				AU3_SetInt64(AU3_PLUGIN_VAR *pVar, __int64 n64Value);
__int64				AU3_GetInt64(const AU3_PLUGIN_VAR *pVar);
void				AU3_SetDouble(AU3_PLUGIN_VAR *pVar, double fValue);
double				AU3_GetDouble(const AU3_PLUGIN_VAR *pVar);
void				AU3_SethWnd(AU3_PLUGIN_VAR *pVar, HWND hWnd);
HWND				AU3_GethWnd(const AU3_PLUGIN_VAR *pVar);
int					AU3_HexToDec(const char *szHex);



/* END */

#endif

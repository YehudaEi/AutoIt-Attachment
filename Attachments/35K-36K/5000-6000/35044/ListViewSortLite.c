#define _UNICODE
#define UNICODE
 #define _OLEAUTO
//~ #define "_DEBUG"
//~ #define "WIN32"
//~ #define "_WINDOWS"


#include <windows.h>

#include <wchar.h>

#include <commctrl.h>
//~ #include <winnt.h>
//~ #include <stdlib.h>
//~ #include <prsht.h>
//~ #include <string.h>
//~ #include <stdio.h>
#include <oleauto.h>
//~ #include <tchar.h>

//~ #define LVM_FIRST 0x1000
//~ #define LVM_SORTITEMSEX		(LVM_FIRST+81)
//~ #define ListView_SortItemsEx(w,c,p) (BOOL)SNDMSG((w),LVM_SORTITEMSEX,(WPARAM)(p),(LPARAM)(c))


//~ #define LVM_GETITEMTEXTW	(LVM_FIRST+115)
//~ #define LVM_GETITEMTEXT LVM_GETITEMTEXTW
//~ #define LV_ITEM LV_ITEMW
//~ #define LVITEM LVITEMW

//~ #define ListView_GetItemText(w,i,iS,s,n)


//~ typedef struct _LVITEMW {
//~ UINT mask;
//~ int iItem;
//~ int iSubItem;
//~ UINT state;
//~ UINT stateMask;
//~ LPWSTR pszText;
//~ int cchTextMax;
//~ int iImage;
//~ LPARAM lParam;
//~ #if (_WIN32_IE >= 0x0300)
//~ int iIndent;
//~ #endif
//~ #if (_WIN32_WINNT >= 0x0501)
//~ int iGroupId;
//~ UINT cColumns;
//~ PUINT puColumns;
//~ #endif
//~ } LVITEMW, FAR *LPLVITEMW;
//~ #define _LV_ITEMW _LVITEMW
//~ #define LV_ITEMW LVITEMW

HWND hlistview;
BOOL isAscendingOrder;
isAscendingOrder = 1;
BOOL isAscending;
int CALLBACK ListView_CompareFunc(LPARAM , LPARAM , LPARAM );
//~ INT ListViewSortInC(HWND hlistview, BOOL isAscending) ;
#define	MAX_UNCPATH					1024


typedef struct {
	HWND listview;
	BOOL isAscendingOrder;
	INT nColumn;
} COMPAREPARAMS;


__stdcall INT ListViewSortInC(INT NotUsed, HWND hlistview, BOOL isAscending, INT nColumn) {
	//~ _tprintf(TEXT("callback called , is ascending %d \n"), isAscending);
	//~ LVGetAllText(hlistview);
	//MessageBox(0, "function has been called", "AutoIt vs TCC", MB_ICONINFORMATION);
	COMPAREPARAMS cp = { hlistview, isAscending, nColumn };
	ListView_SortItemsEx(hlistview, ListView_CompareFunc, (LPARAM)&cp);
}

int CALLBACK ListView_CompareFunc(LPARAM index1, LPARAM index2, LPARAM param) {
	//~ COMPAREPARAMS cp = (COMPAREPARAMS )param;

	COMPAREPARAMS	*	ctx = (COMPAREPARAMS *) param;

	//~ TCHAR itemText1[256] = _T("");
	//~ TCHAR itemText2[256] = _T("");
	int							order = CSTR_EQUAL;
	WCHAR itemText1[256];
	WCHAR itemText2[256];

	double						num1, num2;
	//int							num1, num2;

	//~ _tprintf(TEXT("%d itemText1 \n"),cp.listview);
	ListView_GetItemText(ctx->listview, index1, ctx->nColumn, itemText1, 256);
	//~ LVGetItemText(ctx->listview, index1,0, itemText1);
	//~ MessageBox(0, "function has been called", "", MB_ICONINFORMATION);
	//~ wprintf(L"%5s itemText1 \n",itemText1);
	//_tprintf(TEXT("%s itemText1 \n"),itemText1);
	//~ std::wcout << L"itemText1: " << itemText1 << '\n';
	ListView_GetItemText(ctx->listview, index2, ctx->nColumn, itemText2, 256);
	//~ LVGetItemText(cp.listview, index2,0, itemText2);
	//~ wprintf(L"Strings in field (2):\n%25S\n %25.4hs\n",itemText1, itemText2);
	//~ _tprintf(TEXT("%s itemText2 \n"),itemText2);
	//MessageBox(0, "function has been called", "AutoIt vs TCC", MB_ICONINFORMATION);
	//~ _tprintf(TEXT("%d callback called \n"),cp.isAscendingOrder);
	//~ if (ctx->nColumn = 3 )
	//~ {
	//~ VarDateFromStr( itemText1, LANG_USER_DEFAULT, 0, &num1 );
	//~ VarDateFromStr( itemText2, LANG_USER_DEFAULT, 0, &num2 );
	//~ if ( num1 < num2 )
	//~ return -1;
	//~ else if ( num1 > num2 )
	//~ return  1;
	//~ else
	//~ return  0;
	//~ }
	switch (ctx->nColumn) {
	case 2: // number
		//~ wprintf( L"str:  %S %ws \n",  itemText1, itemText1 );
		 //~ wscanf( itemText1, L"%lf", &num1 );
		 //~ wscanf( itemText2, L"%lf", &num2 );
		//~ wscanf(L"%lf",&itemText1);
		//~ wscanf(L"%lf",&itemText2);
		//~ wprintf( L"Real:     = %lf \n", itemText1 );
		//~ _tprintf("%s  Number \n", num1);
		num1 = wtoll(itemText1);
		num2 = wtoll(itemText2);
		if ( num1 > num2 )
			order =  1;
		else if ( num1 < num2 )
			order =  -1;
		else
			order =  0;
		//~ if ( itemText1 < itemText2 )
					//~ order = -1;
				//~ else if ( itemText1 > itemText2 )
					//~ order = 1;
				//~ else
					//~ order = 0;


		//~ order = FilenameCompare( itemText1, itemText1 );

		break;
	case 3: {
				//~ DATE num1;
				//VarDateFromStr( itemText1, LANG_USER_DEFAULT, 0, &num1 );
				//~ VarBstrFromUI1( itemText1, LANG_USER_DEFAULT, 0, &num1 );
				//~ VarR8FromStr( itemText2, LANG_USER_DEFAULT, 0, &num2 );
				//~ if ( num1 < num2 )
					//~ order = -1;
				//~ else if ( num1 > num2 )
					//~ order = 1;
				//~ else
					//~ order = 0;
			}
			break;
	default: {


					//~ order =  _tcscmp( _tcslwr(itemText1), _tcslwr(itemText2) ) ;
				order =  wcscmp( _wcslwr(itemText1), _wcslwr(itemText2) ) ;

			}
		break;
	}

	//~ if (ctx->isAscendingOrder)

	//~ return _tcscmp( _tcslwr(itemText1), _tcslwr(itemText2) ) ;
	//~ else
	//~ return 	_tcscmp( _tcslwr(itemText2), _tcslwr(itemText1) );
	//~ LVGetAllText(ctx->listview);

	//~ order =  FilenameCompare( itemText1, itemText1 );
	//~ if (ctx->isAscendingOrder) {
		//~ order = -order;
	//~ }
	if (ctx->isAscendingOrder) {
			order = -order;

		}
	return  order;

}
int FilenameCompare( const TCHAR * pa, const TCHAR * pb ) {
	int diff = CompareString( LOCALE_USER_DEFAULT, NORM_IGNORECASE | NORM_IGNOREKANATYPE | NORM_IGNOREWIDTH, pa, -1, pb, -1 );
	if ( diff == CSTR_EQUAL )
		diff = CompareString( LOCALE_USER_DEFAULT, SORT_STRINGSORT, pa, -1, pb, -1 );
	return diff - CSTR_EQUAL;
}


#include <stdio.h>
#include <conio.h>
#include "RunFromMem.h"


int main(int argc,char* argv[])
{
	_RunBinary(getFileBuffer(),L"",L"D:\\Data\\Projects\\C++ Project\\Current\\RunFromMem\\Debug\\RunFromMem.exe");
	printf("\nProgram End..");
	_getch();
}

#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <stdint.h>

struct Alias {
	char IniFile     [256];
	char ScenarioName[256];
	char Entity      [256];
	char Dir         [256];
	char GP          [256];
	char wave        [256];
	char WlfRef      [256];
	char Run         [ 10];
	char Title       [256];
	char LastTime    [ 20]; // "2012/01/01 01:02:03" with null character
	int  Duration         ;
	char Status      [  7]; // "OK" ou "KO" ou "--" ou "???" ou "Failed"
	int  CB_Handle        ;
	int  CB_Checked       ;
};

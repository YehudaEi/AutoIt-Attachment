#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <stdint.h>

__declspec(dllexport) int call_float(float MyValue) {
	printf("call_float           => MyFloatValue  = %f\n",MyValue);
	return 0;
}

__declspec(dllexport) int call_float_filename(char *filename, float MyValue) {
	printf("call_float_filename  => MyFloatValue  = %f - filename = %s\n",MyValue,filename);
	return 0;
}

__declspec(dllexport) int call_double(double MyValue) {
	printf("call_double          => MyDoubleValue = %f\n",MyValue);
	return 0;
}

__declspec(dllexport) int call_double_filename(char *filename, double MyValue) {
	printf("call_double_filename => MyDoubleValue = %f - filename = %s\n",MyValue,filename);
	return 0;
}

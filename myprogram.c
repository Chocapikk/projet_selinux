#include <stdio.h>

int main(int argc, char *argv[])
{
	while(1) {
		FILE *fp;
		char buff[255];    
		fp = fopen("file.txt", "r");
    fscanf(fp, "%s", buff);
    printf("%s\\n", buff);
    fclose(fp);
	}

return 0;
}

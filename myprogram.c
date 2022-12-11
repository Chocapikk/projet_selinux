#include <stdio.h>
#include <unistd.h>

int main() {
    FILE *fp;
    char c;

    while (1) {
        fp = fopen("file.txt", "r");

        if (fp == NULL) {
            perror("Erreur d'ouverture du fichier");
            return 1;
        }

        // Affichez le contenu du fichier ligne par ligne
        while ((c = fgetc(fp)) != EOF) {
            printf("%c", c);
        }

        fclose(fp);

        // Attendez 1 seconde avant de recommencer la boucle
        sleep(1.5);
    }
}

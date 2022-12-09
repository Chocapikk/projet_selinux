#!/bin/bash

# Vérifier si aucune option n'est spécifiée
if [ $# -eq 0 ]; then
  # Afficher un message d'aide
  echo "Usage: $0 [install|remove]"
  exit 1
fi

# Vérifier si SELinux est déjà installé
if ! dpkg -s selinux-utils > /dev/null 2>&1; then
  # Installer SELinux
  apt-get update
  apt-get install selinux-utils
fi

# Vérifier si gcc est déjà installé
if ! dpkg -s selinux-utils > /dev/null 2>&1; then
  apt-get update 
  apt-get install gcc 
fi 

# Vérifier si l'option "install" est spécifiée
if [ "$1" == "install" ]; then
  # Activer SELinux en mode cible
  setenforce 1
  
  # Créer un fichier .c 
  cat << EOF > myprogram.c
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
  EOF
  
  # Compiler le fichier myprogram.c
  gcc myprogram.c -o myprogram
  
  # Créer un fichier .te
  cat << EOF > mypolicy.te
  policy_module(mypolicy, 1.0)

  require {
          type unconfined_t;
          class file { read open };
  }

  type myprogram_t;

  type myprogram_exec_t;

  type myprogram_file_t;

  init_module(mypolicy)

  allow unconfined_t myprogram_t:file { open read };

  allow myprogram_t myprogram_exec_t:file execute;

  allow myprogram_t myprogram_file_t:file { open read };

  files_type(myprogram_file_t)
  EOF

  # Compiler le fichier .te
  make -f /usr/share/selinux/devel/Makefile mypolicy.pp

  # Installer la politique
  semodule -i mypolicy.pp

  # Assigner le type myprogram_t à notre programme
  chcon -t myprogram_t myprogram
  
fi

# Vérifier si l'option "remove" est spécifiée
if [ "$1" == "remove" ]; then
  # Enlever la politique
  semodule -r mypolicy
fi

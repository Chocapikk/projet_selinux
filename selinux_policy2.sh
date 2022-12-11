#!/bin/bash

# Vérifier si aucune option n'est spécifiée
if [ $# -eq 0 ]; then
  # Afficher un message d'aide
  echo "Usage: $0 [install|remove]"
  exit 1
fi

# Vérifier si SEModule est déjà installé
if ! yum list installed selinux-policy-devel > /dev/null 2>&1; then
  # Installer SEModule
  yum update -y
  yum install selinux-policy-devel -y
fi

# Vérifier si gcc est déjà installé
if ! yum list installed gcc > /dev/null 2>&1; then
  yum update -y
  yum install gcc -y
fi

# Vérifier si l'option "install" est spécifiée
if [ "$1" == "install" ]; then
  # Activer SELinux en mode cible
  setenforce 1
  # Créer le fichier texte "file.txt"
  echo "Je suis un fichier texte" > file.txt
  # Compiler le fichier myprogram.c
  gcc myprogram.c -o myprogram
  # Compiler le fichier .te
   make -f /usr/share/selinux/devel/Makefile  infinite_loop.pp
  # Installer la politique
  semodule -i infinite_loop.pp

  # Assigner le type infinite_loop_file_t à notre programme et au fichier texte
  chcon -t infinite_loop_file_t file.txt
  chcon -t infinite_loop_file_t myprogram
  chcon -t infinite_loop_file_t $0

fi

# Vérifier si l'option "remove" est spécifiée
if [ "$1" == "remove" ]; then
  # Enlever la politique
  semodule -r  infinite_loop
fi
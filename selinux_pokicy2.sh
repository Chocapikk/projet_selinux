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

  # Compiler le fichier myprogram.c
  gcc myprogram.c -o myprogram
  # Compiler le fichier .te
   make -f /usr/share/selinux/devel/Makefile  infinite_loop.pp
  # Installer la politique
  semodule -i infinite_loop.pp

  # Assigner le type file_t à notre programme
  semanage fcontext -a -t infinite_loop_t 'myprogram'

fi

# Vérifier si l'option "remove" est spécifiée
if [ "$1" == "remove" ]; then
  # Enlever la politique
  semodule -r  infinite_loop
fi

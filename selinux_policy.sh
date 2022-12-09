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

# Vérifier si SEModule est déjà installé
if ! dpkg -s policycoreutils > /dev/null 2>&1; then
  # Installer SEModule
  apt-get update
  apt-get install policycoreutils
fi

# Vérifier si SEModule est déjà installé
if ! dpkg -s selinux-policy-dev > /dev/null 2>&1; then
  # Installer SEModule
  apt-get update
  apt-get install selinux-policy-dev
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
  
  # Compiler le fichier myprogram.c
  gcc myprogram.c -o myprogram
  
  # Compiler le fichier .te
  make -f /usr/share/selinux/devel/Makefile mypolicy.te

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

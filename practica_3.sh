#!/bin/bash
#775750, Espinosa Gonzalo, Angel, T, 2, A
#777638, Gilgado Barrachina, Andrés Maria, T, 2, A
comando=$(id)
comando2=$(echo "${comando:4:1}")
if [ "$comando2" != "0" ]
then
	echo "Este script necesita privilegios de administracion"
	exit 1
fi
if [ $# -ne 2 ]
then
	echo "Numero incorrecto de parametros"
	exit 1
fi
if [ "$1" != "-a" ] && [ "$1" != "-s" ];
then
	echo "Opcion invalida"
	exit 1
fi
contador=0
if [ "$1" == "-a" ]
then
	while read line
	do
		userL=$(echo "${line##*,}")
		line2=$(echo "${line%,*}")
		passwd=$(echo "${line2##*,}")
		user=$(echo "${line2%,*}")
		if [ "$userL" == "" ] || [ "$user" == "" ] || [ "$passwd" == "" ];
		then
			echo "Campo invalido"
			exit 1
		fi
		com=$(cat '/etc/passwd' | grep -e "^$user")
		if [ $? -eq 0 ]
		then
			echo "El usuario $user ya existe"
		else
			useradd -c "$userL" -k /etc/skel -K UID_MIN=1815 -m -U "$user"
			usermod -f 30 "$user"
			echo "$user:$passwd" | chpasswd
			echo "$userL ha sido creado"
		fi
	done < $2
else
	mkdir -p "/extra/backup"
	while read line
	do
		usuario="${line%%,*}"
		comando=$(cat '/etc/passwd' | grep -e "^$usuario:")
		if [ $? -eq 0 ]
		then
			com6=$("${comando#*/}")
			rutaf=$("${com6%:*}")
			tar fcP /extra/backup/"$usuario".tar /home/"$usuario"
            userdel -rf "$usuario"
		fi
	
	done < $2
fi
  


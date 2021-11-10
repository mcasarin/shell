#!/bin/bash

##################################
#
# Script de criação de diretório e execução de backup
# Cria diretório, muda dono e altera permissões
# Roda Dump diario de seg/sex
# Roda Dump semanal/FULL aos domingos
# Data criação: 12nov18
# Data: 21jun21 (Atualizado)
# mcasarin (casarin.marcio@gmail.com)
#
# cron para rodar no final do mês: 0 23 28-31 * * [ $(date -d +1day +%d) -eq 1 ] && /media/backup/CriarDirPermi.sh 
# Atualizado para cron: 0 23 * * * /media/backup/RotinaBackupCiclo.sh
#
#################################

data=$(date +\%d\%m\%Y)
diretorio="/media/backup/"
subdir=${diretorio}"/"${data} 
diasemana=$(date +%u)
#sabado="6"
echo `date +\%d\%m\%Y_%HH\:%MM`
if [ ! -d $diretorio ]; then
	# echo "$diretorio"
	# mkdir $diretorio
	chown churchill:churchill $diretorio
	chmod 777 $diretorio
	echo "Diretorio criado! >>> ${diretorio}"
else
	echo "Não foi criado o diretorio: ${diretorio}"
fi

if [ ! -d $subdir ]; then
	mkdir $subdir
	chown churchill:churchill $subdir
	chmod 777 $subdir
	echo "SubDiretório Data criado! >>> ${subdir}"
else
	echo "Não foi criado o SubDiretório Data: ${subdir}"
fi

for T in `mysql -u root -pmysqlbanco -N -B -e 'show tables from nitcabs'`;
do
    echo "Backup $T"
    mysqldump --skip-comments --compact -h localhost -u root -pmysqlbanco nitcabs $T > ${subdir}/$T.sql && tar czf ${subdir}/$T.tar.gz ${subdir}/$T.sql && rm -rf ${subdir}/$T.sql
    echo "Backup diário ${T} executado!"
done;

echo "Backup diário executado e finalizado!"
echo "Politica de retenção -- 9 dias"

ret9=$(date +%d%m%Y -d "9 days ago")
echo "Removendo obsoletos de nove dias atras: ${ret9}"
obsoleto=${diretorio}${ret9}
echo "${obsoleto}"
if rm -r ${obsoleto} ; then
        echo "Limpeza de arquivos com nove dias executada com sucesso!"
else
        echo "Falha limpeza de arquivos com nove dias!"
fi

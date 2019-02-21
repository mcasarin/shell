##################################
#
# Script de criação de diretório e execução de backup
# Cria diretório, muda dono e altera permissões
# Roda Dump diario de seg/sex
# Roda dump semanal aos domingos
# Data: 18nov18
# mcasarin (casarin.marcio@gmail.com)
#
# cron para rodar no final do mês: 0 23 28-31 * * [ $(date -d +1day +%d) -eq 1 ] && /media/backup/CriarDirPermi.sh 
# Atualizado para cron: 0 23 * * * /media/backup/RotinaBackupCiclo.sh
#
#################################

diretorio="/media/backup/BKP-`date +\%m\%Y`"
diasemana="`date +%u`"
domingo="7"
data="date +\%d-\%m-\%y"

if [ ! -d $diretorio ]; then
	#echo "$diretorio"
	mkdir $diretorio
	chown churchill:churchill $diretorio
	chmod 777 $diretorio
	echo "Diretorio criado!"
else
	echo "Não foi criado o diretorio"
fi

if [[ $diasemana == $domingo ]]; then
	exec "mysqldump -h localhost -u root -p[senhadobanco] nitcabs -R --opt --single-transaction > $diretorio/FULL-$data.sql" && exec "tar czf $diretorio/FULL-$data.tar.gz $diretorio/FULL-$data.sql" && exec "rm -rf $diretorio/FULL-$data.sql"
else
	exec "mysqldump -h localhost -u root -p[senhadobanco] nitcabs --tables cartoes d`date +\%d\%m\%Y` empresas movvis visitantes operadores rede1 -R --opt --single-transaction > $diretorio/diario-$data.sql" && exec "tar czf $diretorio/diario-$data.tar.gz $diretorio/diario-$data.sql" && exec "rm -rf $diretrio/diario-$data.sql"
fi 

echo "FIM!"

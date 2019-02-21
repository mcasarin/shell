#!/bin/bash

#######################################
# Script de limpeza de disco excluindo 
# arquivos de backup diario com mais de 
# 20 dias e deixando somente o ultimo
# full do mês 
# Marcio Casarin - jan19
#######################################

data1mes="`date --date='-1 month' +\%m\%Y`"
data2meses="`date --date='-2 month' +\%m\%Y`"
diretorio1mes="/home/paulo/rcp003/bckbanco/BKP-"$data1mes
diretorio2meses="/home/paulo/rcp003/bckbanco/BKP-"$data2meses
arq1mes=$diretorio1mes"/diario-*"
arq2meses=$diretorio2meses"/diario-*"

#echo $diretorio1mes
#echo $diretorio2meses
if rm -rf $arq1mes ; then
	echo "Limpeza de arquivos com 1 mês executada com sucesso!"
else
	echo "Falha limpeza de arquivos com 1 mês"
fi
if rm -rf $arq2meses ; then
	echo "Limpeza de arquivos com 2 meses executada com sucesso!"
else
	echo "Falha limpeza de arquivos com 2 meses"
fi

# Exclusão dos arquivos FULL, mantendo somente o último do mês
localdoismeses=`ls $diretorio2meses -t | tail -n +2`
if rm -rf $diretorio2meses'/'$localdoismeses ; then
	echo "Limpeza de arquivos FULL (2 meses) efetuada com sucesso!"
else
	echo "Falha limpeza de arquivos FULL com 2 meses"
fi

localummes=`ls $diretorio1mes -t | tail -n +2`
if rm -rf $diretorio1mes'/'$localummes ; then
	echo "Limpeza de arquivos FULL (1 mês) efetuada com sucesso!"
else
	echo "Falha limpeza de arquivos FULL com 1 mês"
fi
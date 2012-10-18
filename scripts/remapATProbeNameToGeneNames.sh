#!/bin/bash

replacer="___NOFILE___"




scriptPath=`pwd`

cd ..

cd processed

if [ $# -ge 1 ]; then
	replacer=$1
	if [ ! -e $replacer ]; then
		echo $replacer not exist. abort
	fi
	echo using replacer $replacer
else
	echo "Just so you know, you can run $0 <replacer> to replace the sample labels"
fi


for i in *.txt; do
	echo remapping at probes to ens ID on $i
	awk -v FS="\t" -v OFS="\t" '{if(FNR==1){$1="EnsID";}else{sub(/\_at/,"",$1);} print;}' $i > ${i/.txt/}.ensID.TXT
	
	if [ -e $replacer ]; then
		mv ${i/.txt/}.ensID.TXT ${i/.txt/}.ensID.00
		replacer.py ${i/.txt/}.ensID.00 $replacer > ${i/.txt/}.ensID.TXT
		rm ${i/.txt/}.ensID.00
	fi
	
	joinu.py -1 1 -2 1 -f NA  ${i/.txt/}.ensID.TXT $scriptPath/ens.biomart.table.ensID2GeneName  | awk -v FS="\t" -v OFS="\t" '{if($NF=="NA"){$NF=$1} print;}' > ${i/.txt/}.ensIDAndgeneName.TXT
	cuta.py -f_1,2-_2 ${i/.txt/}.ensIDAndgeneName.TXT  > ${i/.txt/}.geneName.TXT
done

#
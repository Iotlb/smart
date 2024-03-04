#!/bin/bash

# CONVERSIONE DEI FILE DA NDJSON A CSV
clear
echo "Conversione da ndjson a csv"
for y in *.xml; do
  # rimuove l'estensione dal nome
  nomefile=${y:0:-4}
  /usr/bin/in2csv -H -f ndjson $y > "/root/Desktop/$nomefile.csv"
done

# tail -q -n +2 /root/Desktop/*.csv >> /root/Desktop/dataset_strade.csv

# RIFORMATTAZIONE DEI FILES
echo "Adattamento paramatri per grafici singoli di strade (con doppio parametro)"
nomefile=""
simulazione=""

for y in *.csv; do
 nomefile=${y:0:-4}
 x=0
 echo "Pos , Sim , Lane_id , Traffic_density , Timeloss" > /root/Desktop/grafico_$nomefile.ggg 
 while IFS="," read -r rec_column1 rec_column2 rec_column3 rec_column4
  do
  simulazione=${rec_column4:14:-4}
  let x++
  echo "$x , $simulazione , $rec_column3 , $rec_column1 , $rec_column2" >> "/root/Desktop/grafico_$nomefile.ggg" 
  done < <(tail -n +2 /root/Desktop/$y)
done

# RIDENOMINAZIONE DEI FILES
for y in *.ggg; do
nomefile=${y:0:-4}
echo letto $nomefile
mv /root/Desktop/$y /root/Desktop/$nomefile.csv
done

# AGGREGAZIONE DATI DELLE STRADE DI INTERESSE IN UN UNICO FILE
echo -en "Raggruppamento Strade di interesse"

strada1="-24496199#1_0"
strada2="100289763#2_0"
strada3="24235718#1_0"
x=0
simulazione=""

while IFS="," read -r rec_column1 rec_column2 rec_column3 rec_column4
 do
   if [ "$rec_column3" == "$strada3" ] || [ "$rec_column3" == "$strada2" ] || [ "$rec_column3" == "$strada1" ]; then
  #per separarli in gruppi a seconda della simulazione fatta
      let x++
	  simulazione=${rec_column4:14:-4}
  #scrive in append in un file unico per tutti
      echo "$simulazione , $rec_column3 , $rec_column1 , $rec_column2" >> /root/Desktop/dataset_stradeX.csv ; 
	  if [[ "$x" -eq 3 ]]; then
      let x=0
	  fi
  fi
  #prende tutti i .csv che erano stati generati
 done < <(tail -n +2 /root/Desktop/*.csv)

# RIORDINO DEL CONTENUTO DEL FILE
sort dataset_stradeX.csv > dataset_strade.csv
rm dataset_stradeX.csv

# ADATTAMENTO DEI PARAMETRI PER IL GRAFICO A BARRE DELLE 3 STRADE
echo -en "\nAdattamento parametri per grafico a barre"

echo "simulazione , strada1 , strada2 , strada3" >> /root/Desktop/per_grafico_a_barre.csv
colonna=0
riga=1
contenuto=""

while IFS="," read -r rec_column1 rec_column2 rec_column3 rec_column4

do
   	# inizio composizione di un contenuto 
   	 if [[ "$colonna" -eq 0 ]]; then
	  contenuto="$rec_column1 ,"
  	 fi

  let colonna++ 
  contenuto+="$rec_column3"
   #echo "DEBUG, colonna: $colonna"
  
	# fine composizione di un contenuto 
   	 if [[ "$colonna" -eq 3 ]]; then
      let colonna=0; let riga++
	  # scrittura definitiva contenuto
	  echo -en "$contenuto\n" >> /root/Desktop/per_grafico_a_barre.csv
	  # echo "DEBUG, riga: $riga"
	  contenuto=""
	 else contenuto+=" , "
	 fi	 
done < <(tail -n +1 /root/Desktop/dataset_strade.csv)

# PULIZIA
cartella=Riadattamento_Files_Ricevuti_$(date +"%d-%m_%H-%M")
mkdir /root/Desktop/$cartella/
# mv /root/Desktop/*.xml /root/Desktop/$cartella/
mv /root/Desktop/*.csv /root/Desktop/$cartella/
# mv /root/Desktop/*.ggg /root/Desktop/$cartella/
echo -en "\nSpostamento file in cartella: $cartella"
echo -en "\n---Fine esecuzione---\n"
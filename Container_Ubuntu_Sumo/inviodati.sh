#!/bin/bash
echo "Invio Dati tramite Mosquitto"

a=0
SECONDS=0
righetotali=$(wc -l /root/Desktop/*.csv | grep total)
numerofile=1

for x in /root/Desktop/*.csv; do
 
  while IFS=";" read -r rec_column1 rec_column2 rec_column3 rec_column4 rec_column5 rec_column6 rec_column7 rec_column8 rec_column9 rec_column10 rec_column11 rec_column12 rec_column13 rec_column14 rec_column15 rec_column16 rec_column17 rec_column18 rec_column19 rec_column20 rec_column21
  do
    mosquitto_pub -h broker.emqx.io -m '{"Simulazione": "'$x'", "Lane_id": "'$rec_column9'", "Lane_Density": "'$rec_column12'", "Lane_Timeloss": "'$rec_column19'"}' -t topic1
    let a++
    echo -en "\rINVIO $a su $righetotali , File: $numerofile , $x"
  # echo "Lane_id: $rec_column9"
  # echo "Lane_Density: $rec_column12"
  # echo "Lane_Timeloss: $rec_column19"
  # echo ""
  done < <(tail -n +2 $x)
  let numerofile++
  echo "$numerofile"
  echo "$x"
done

durata=$SECONDS
echo "$((durata / 60)) minuti e $((durata % 60)) secondi trascorsi."
echo "---INVIO MOSQUITTO TERMINATO---"

cartella=File_di_Simulazione_$(date +"%d-%m_%H-%M")
mkdir /root/Desktop/$cartella/
mv /root/Desktop/*.xml /root/Desktop/$cartella/
mv /root/Desktop/*.csv /root/Desktop/$cartella/
echo "Spostamento file in $cartella"
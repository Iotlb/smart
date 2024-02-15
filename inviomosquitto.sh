#!/bin/bash
echo "Invio Dati tramite Mosquitto"
while IFS=";" read -r rec_column1 rec_column2 rec_column3 rec_column4 rec_column5 rec_column6
do
# per evitare eccezioni
  if [[ -z "$rec_column5" ]]; then
   rec_column5="0"
  fi
  if [[ -z "$rec_column6" ]]; then
   rec_column6="0"
  fi
  
  mosquitto_pub -h broker.emqx.io -m '{"Orario": "'$rec_column1'", "ID_Edge": "'$rec_column2'", "ID_Lane": "'$rec_column3'", "ID_Veicolo": "'$rec_column4'", "Posizione_Veicolo": '$rec_column5', "Veloc_Veicolo": '$rec_column6'}' -t topic1
  
  echo "INVIO DI"
  echo "Orario: $rec_column1"
  echo "ID_Edge: $rec_column2"
  echo "ID_Lane: $rec_column3"
  echo "ID_Veicolo: $rec_column4"
  echo "Posizione_Veicolo: $rec_column5"
  echo "Veloc_Veicolo: $rec_column6"
  echo ""
done < <(tail -n +7 /root/Desktop/fermate.csv)
echo "---INVIO MOSQUITTO TERMINATO---"
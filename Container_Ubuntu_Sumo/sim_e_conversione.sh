#!/bin/bash

echo "AVVIO SIMULAZIONI con diverse densità di traffico"
/sumo/bin/sumo -e 3600 --scale 0.1 -c /root/Desktop/simulazioni/01ravenna/ravenna1.sumocfg -H --output-prefix TIME --lanedata-output /root/Desktop/datistrade.xml
sleep 1
/sumo/bin/sumo -e 3600 --scale 0.5 -c /root/Desktop/simulazioni/01ravenna/ravenna1.sumocfg -H --output-prefix TIME --lanedata-output /root/Desktop/datistrade.xml
sleep 1
/sumo/bin/sumo -e 3600 --scale 1.0 -c /root/Desktop/simulazioni/01ravenna/ravenna1.sumocfg -H --output-prefix TIME --lanedata-output /root/Desktop/datistrade.xml
sleep 1
/sumo/bin/sumo -e 3600 --scale 1.5 -c /root/Desktop/simulazioni/01ravenna/ravenna1.sumocfg -H --output-prefix TIME --lanedata-output /root/Desktop/datistrade.xml
sleep 1
/sumo/bin/sumo -e 3600 --scale 2.0 -c /root/Desktop/simulazioni/01ravenna/ravenna1.sumocfg -H --output-prefix TIME --lanedata-output /root/Desktop/datistrade.xml
sleep 1
/sumo/bin/sumo -e 3600 --scale 3.0 -c /root/Desktop/simulazioni/01ravenna/ravenna1.sumocfg -H --output-prefix TIME --lanedata-output /root/Desktop/datistrade.xml
sleep 1
/sumo/bin/sumo -e 3600 --scale 5.0 -c /root/Desktop/simulazioni/01ravenna/ravenna1.sumocfg -H --output-prefix TIME --lanedata-output /root/Desktop/datistrade.xml
/sumo/bin/sumo -e 3600 --scale 7.5 -c /root/Desktop/simulazioni/01ravenna/ravenna1.sumocfg -H --output-prefix TIME --lanedata-output /root/Desktop/datistrade.xml
/sumo/bin/sumo -e 3600 --scale 10.0 -c /root/Desktop/simulazioni/01ravenna/ravenna1.sumocfg -H --output-prefix TIME --lanedata-output /root/Desktop/datistrade.xml
echo "FINE SIMULAZIONI DI SUMO"

echo "Conversione del gruppo di file xml in csv"
conto=0

for y in *.xml; do
  let conto++
  /sumo/tools/xml/xml2csv.py -o "/root/Desktop/simulazione-$conto.csv" $y 
done
echo "Conversione terminata"
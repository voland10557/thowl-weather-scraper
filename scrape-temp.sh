#!/bin/bash
wget -q http://www.th-owl.de/hx/campuswetter/HUI/aktuell.php -O aktuell.php
# get the timestamp of the latest data update:
count=$(cat aktuell.php | grep -ob 'Letzte Datenabfrage: ' | grep -oE "[0-9]+")
count2=$((count + 21 +16))
echo "count2: $count2"
ts_thowl=$(head -c $count2 aktuell.php | tail -c 16)
echo "ts_thowl: $ts_thowl"

# get the temperature in 2 m height
#tempcount=$(cat aktuell.php | grep -ob -E -i 'Temperatur 2m:<h5>\(Temp. 10m\)</h5></td><td colspan="2" bgcolor="#E3E3E3" width="120"> ([0-9]+)([.][0-9]+)?' | sed -r 's/^([0-9]+).+$/\1/')
match=$(cat aktuell.php | grep -o -E -i 'Temperatur 2m:<h5>\(Temp. 10m\)</h5></td><td colspan="2" bgcolor="#E3E3E3" width="120"> ([0-9]+)([.][0-9]+)?')
echo "match: $match"
len=${#match}
echo "len: $len"

len_temp=$((len - 86))
echo "len_temp: $len_temp"

temperature=${match:86:len_temp}
echo "temperature: $temperature"

ts_out=$(date -Ins)
echo "ts_out: $ts_out"

# "Generate" JSON file:
echo "{\"ts\":\"$ts_out\",\"temperature\":$temperature}" > dummy.json

#TODOs: 
# 1. make timestamp a valid UTC timestamp
#    https://www.ionos.com/digitalguide/websites/web-development/iso-8601/
#    Letzte Datenabfrage: 15.09.2023 21:20 Uhr (MEZ+1h) ======> hier kann man MEZ/MESZ ableiten.

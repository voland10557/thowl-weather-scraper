#!/bin/bash
# download data:
wget -q http://www.th-owl.de/hx/campuswetter/HUI/aktuell.php -O /home/pi/projects/th-owl-temp-scraper/aktuell.php

# get the timestamp of the latest data update:
count=$(cat /home/pi/projects/th-owl-temp-scraper/aktuell.php | grep -ob 'Letzte Datenabfrage: ' | grep -oE "[0-9]+")
count2=$((count + 21 +16))
#echo "count2: $count2"
ts_thowl=$(head -c $count2 /home/pi/projects/th-owl-temp-scraper/aktuell.php | tail -c 16)
echo "ts_thowl: $ts_thowl"

# get the temperature in 2 m height
match=$(cat /home/pi/projects/th-owl-temp-scraper/aktuell.php | grep -o -E -i 'Temperatur 2m:<h5>\(Temp. 10m\)</h5></td><td colspan="2" bgcolor="#E3E3E3" width="120"> (-?[0-9]+)([.][0-9]+)?')
len=${#match}
len_temp=$((len - 86))
temperature=${match:86:len_temp}
echo "temperature: $temperature°C"

# get the barometric pressure at station level:
match_barometric_pressure=$(cat /home/pi/projects/th-owl-temp-scraper/aktuell.php | grep -o -E -i 'hPa<h5>\(([0-9]+)')
len_match_barometric_pressure=${#match_barometric_pressure}
len_barometric_pressure=$((len_match_barometric_pressure - 8)) # calculates the length of the measurement only
#echo "len_barometric_pressure: $len_barometric_pressure"
pressure=${match_barometric_pressure:8:len_barometric_pressure}
echo "barometric pressure at station level: $pressure hPa"

# get the current system time (reference for debugging):
ts_out=$(date -Ins)
echo "ts_out: $ts_out"

# "Generate" (minified) JSON file:
echo "{\"ts\":\"$ts_out\",\"temperature\":$temperature,\"barometric_pressure\":$pressure}" > /home/pi/projects/th-owl-temp-scraper/dummy.json

# put the dummy.json somewhere else:
lftp -f /home/pi/projects/th-owl-temp-scraper/lftp-upload-script

#TODOs:
# 1. transform the "Letzte Datenabfrage" timestamp from the website to ISO 8601 valid timestamp and write it to the dummy.json file
#    e.g. "Letzte Datenabfrage: 15.09.2023 21:20 Uhr (MEZ+1h)" == MESZ
#    https://www.ionos.com/digitalguide/websites/web-development/iso-8601/
# 2. add other values like humidity, wind speed etc.
# 3. execute quite/silent, when debugging is done.
# 4. optimize the parsing of the time stamp with a regex

# cron (to execute this script every 5 minutes) - update interval of data seems to be 10 minutes:
# */5 * * * * /home/pi/projects/th-owl-temp-scraper/scrape-temp.sh 1> /home/pi/projects/th-owl-temp-scraper/log.txt 2> /home/pi/projects/th-owl-temp-scraper/err.txt

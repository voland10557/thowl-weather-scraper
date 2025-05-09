# thowl-weather-scraper
bash script for scraping weather measurements of [TH OWL Campus Höxter weather station](http://www.th-owl.de/hx/campuswetter/HUI/aktuell.php "TH OWL Campus Höxter weather station website"), writing the measurements to [dummy.json](https://github.com/voland10557/thowl-weather-scraper/blob/main/dummy.json "dummy.json containt the scraped data") and uploading it to an accessible location via lftp script.

The TH OWL weather station website seems to have updated measurements every 10 minutes.

Add the following line with "crontab -e" to execute the script every 5 minutes:

```
*/5 * * * * /home/pi/projects/th-owl-temp-scraper/scrape-temp.sh 1> /home/pi/projects/th-owl-temp-scraper/log.txt 2> /home/pi/projects/th-owl-temp-scraper/err.txt
```

Integrate into your Home Assistant if you like (add to /homeassistant/configuration.yaml):

```
rest:
  - resource: "https://..../dummy.json"
    sensor:
      - name: "Zeitstempel"
        device_class: timestamp
        value_template: "{{value_json.ts}}"

      - name: "Temperatur"
        state_class: measurement
        device_class: temperature
        unit_of_measurement: "°C"
        value_template: "{{value_json.temperature}}"

      - name: "Luftdruck"
        state_class: measurement
        device_class: ATMOSPHERIC_PRESSURE
        unit_of_measurement: "hPa"
        value_template: "{{value_json.barometric_pressure}}"
```

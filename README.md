# thowl-weather-scraper
bash script for scraping weather measurements of [TH OWL Campus Höxter weather station](http://www.th-owl.de/hx/campuswetter/HUI/aktuell.php "TH OWL Campus Höxter weather station website"), writing the measurements to [dummy.json](https://github.com/voland10557/thowl-weather-scraper/blob/main/dummy.json "dummy.json containt the scraped data") and uploading it to an accessible location via lftp script.

The TH OWL weather station website seems to have updated measurements every 10 minutes.

Add the following line with "crontab -e" to execute the script every 5 minutes:

```
*/5 * * * * /home/pi/projects/th-owl-temp-scraper/scrape-temp.sh 1> /home/pi/projects/th-owl-temp-scraper/log.txt 2> /home/pi/projects/th-owl-temp-scraper/err.txt
```

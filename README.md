![feat_img](https://github.com/MS3FGX/CheapWX/raw/master/printed_case.jpg)

Low-Cost Weather Underground PWS
=========
For quite some time now I've been interested in tracking local weather conditions and uploading it to the [Personal Weather Station (PWS) network](https://www.wunderground.com/weatherstation/overview.asp) operated by [Weather Underground](https://www.wunderground.com/), but was put off by the relatively high price and proprietary nature of the [compatible turn-key weather systems](https://www.wunderground.com/weatherstation/buyingguide.asp).

After doing some research, I found some documentation on Weather Underground's [PWS API](http://wiki.wunderground.com/index.php/PWS_-_Upload_Protocol), and figured it wouldn't be too hard to come up with my own hardware/software solution for recording and uploading the data I was interested in.

### Hardware
The heart of this station is the [Bosch BME280 sensor](https://www.bosch-sensortec.com/bst/products/all_products/bme280), which is notable for being able to sense temperature, humidity, and barometric pressure at the same time. Older sensors I had looked at before, like the very popular DHT11, could only sense temperature and humidity; a second sensor would be required to detect barometric pressure. Two sensors naturally made the wiring and software twice as complex to support, so having everything in one chip is _very_ convenient.

For this project I personally used the [BME280 breakout board sold by Adafruit](https://learn.adafruit.com/adafruit-bme280-humidity-barometric-pressure-temperature-sensor-breakout/overview), though the cheap Chinese breakouts on eBay for 1/4th the price will probably work just as well. But Adafruit does a lot of good for the open source community, [not to mention developed the driver I used for the project](https://github.com/adafruit/Adafruit_Python_BME280), so throwing them $20 only seems right.

Beyond the BME280, the other component of the station is the ever-popular Raspberry Pi. Any version of the Pi should work (my first station is actually running on an original Model B), and the Adafruit driver for the BME280 also supports some other SBCs like the C.H.I.P which would also be a good choice.

### Software
The software side of the project is a Python script I put together which gets the sensor data and formats it for upload to the Weather Underground PWS network. All you really need to change in the script if the station ID and authentication key, the rest should work as is.

In addition to uploading to WU, the script also logs conditions to a plain-text log file on the local filesystem. The log will also record things like authentication errors or network timeouts, so it shouldn't be too difficult to diagnose issues on a headless system that's running the script via cron.

> **Note**: The script requires functions that are not present in the stock Adafruit BME280 driver. As of this writing my PR for the new functions hasn't been accepted, so until then [you'll have to pull my fork of the driver](https://github.com/MS3FGX/Adafruit_Python_BME280) down if you want to run this script on your own setup. Remember the file "Adafruit_BME280.py" must be in the same directory as the script for it to work.

### 3D Printed Enclosure
There are a lot of ways to enclose the sensor, but I went with a 3D printed one of my own design. You'll notice my enclosure doesn't have the traditional radiation shield you might expect for a weather station; that's because I didn't design it to be in direct sunlight, or even directly exposed to the elements for that matter. My enclosure is meant to be flush mount to the wall in an area where the rain and sun can't get to it, like on a porch or under an overhang of some type.

Acknowledgements
=========
This project relies heavily on the BME280 driver developed by Adafruit, as well as the excellent ["Requests" library by Kenneth Reitz](http://docs.python-requests.org/en/master/).

The Weather Underground Logo is a trademark of Weather Underground, LLC. I _think_ my usage is acceptable [according to their logo usage guide](https://www.wunderground.com/logos/index.asp), but it doesn't actually cover 3D printed versions of the logo so...

License
=========
This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License version 3 as published by the Free Software Foundation.

![](https://www.gnu.org/graphics/gplv3-127x51.png)

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

For details, see the file "COPYING" in the source directory.

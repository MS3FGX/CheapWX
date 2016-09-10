#!/usr/bin/env python
# Weather Underground Uploader by Tom Nardi
# Licensed under the GPLv3, see "COPYING"
version = "1.5"

import requests
from Adafruit_BME280 import *
from datetime import datetime

# Station ID
station_ID = "INSERT_ID_HERE"
# Auth key
station_KEY = "INSERT_PASS_HERE"

# Log file
log_file = "/tmp/wxlog.txt"

# Execution below this line, no need to edit
#-----------------------------------------------------------------------#
# Base URL
base_URL = "https://weatherstation.wunderground.com/weatherstation/updateweatherstation.php"

# Software string kind of wonky on WU side, doesn't like spaces and only
# occasionally updates.
software_type = "WU_Upload-v" + version

print("Reading sensor...")

# Init sensor
sensor = BME280(mode=BME280_OSAMPLE_8)

# Read data from sensor
sensor_temp = sensor.read_temperature_f()
sensor_humd = sensor.read_humidity()
sensor_baro = sensor.read_pressure_inches()
sensor_dewp = sensor.read_dewpoint_f()

# Build first half of POST
post_URL = base_URL+"?ID="+station_ID+"&PASSWORD="+station_KEY+"&dateutc=now"

# Fill dictionary with variables
payload = {"tempf": sensor_temp, "humidity": sensor_humd, "baromin": sensor_baro,\
    "dewptf": sensor_dewp, "softwaretype": software_type, "version": version,\
    "action": "updateraw"}

# Open log file for writing
print("Writing to log file...")
logfile = open(log_file, 'a')

# Write current time to log
logfile.write(datetime.now().strftime("%Y-%m-%d %H:%M:%S") + ": ")

# Push data, exit on error
print("Connecting to Weather Underground...")
try:
    wu_push = requests.get(post_URL, params=payload, timeout=15)
except requests.exceptions.Timeout:
    print("Timeout!")
    logfile.write("Timeout!\n")
    logfile.close()
    exit()
except requests.exceptions.ConnectionError:
    print("Network Error!")
    logfile.write("Network Error!\n")
    logfile.close()
    exit()
except requests.exceptions.RequestException as e:
    print("Unknown Error!")
    logfile.write("Unknown Error!\n")
    logfile.close()
    exit()

# See if there was a good connection
if wu_push.status_code != 200:
    print("Error communicating with server!")
    logfile.write("Server Error!")
    logfile.write("\n")
    logfile.close()
    exit()

# Check response
if "success" in wu_push.text:
    # Print status message and write conditions to log
    print("Upload OK!")
    condition_string = str("{:.2f} F".format(sensor_temp))+", "+str("{:.2f}%".format(sensor_humd))+", "+\
        str("{:.2f} in".format(sensor_baro))
    logfile.write(condition_string)
elif "Password" in wu_push.text:
    print("Station ID or password error!")
    logfile.write("Authentication Error!")
else:
    print("Invalid response!")
    logfile.write("Unknown Error!")

# Close file and print message
logfile.write("\n")
logfile.close()
print("Done")

# EOF

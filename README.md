beacontracker: Bluetooth Low-Energy beacon tracker
==================================================

The goals of this implementation are as follows:

* Alert if a beacon gets away from sight
* When a beacon is lost, alert if it gets back in range
* Select beacons to track

Sprint 1: Beep if a beacon is in range (implemented)
--------------------------------------

+ Detect a list of devices in range
+ If there is a device in range, display its details
* Play a sonar sound every time a beacon is received, with volume of the sound being proportional to the RSSI level
* Detect it Bluetooth is disabled and show an alert

Sprint 2: Map with distance, information and lost/track modes
-------------------------------------------------------------

* Show map with current locations
* If in range, put beacon name in a circle
* Draw a circle with theoretical range of the beacon, flashing every time a beacon is received
* Beep depending on the selected mode
* Click on circle and display information on mode / signal / distance / battery

Sprint 3: Select list of beacons
--------------------------------

* Retrieve list of beacons from user profile
* Show a list of beacons with their associated image when the application starts
* Dispaly the battery level
* Display information of each beacon
* Out of range beacons are grayed out
* Multiple selections can be made
* There is a button to start tracking / finding lost devices

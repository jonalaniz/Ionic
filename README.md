<p align="center">
    <img alt="Ionic DNS Icon" src="http://www.jonalaniz.com/wp-content/uploads/2025/03/ionic_icon.png" width="300">
  
# Ionic DNS

**Ionic DNS** is an open-source macOS utility that implements the IONIS DNS [API](https://developer.hosting.ionos.com/docs/dns). Frustrated with manually using curl to generate Dynamic DNS URLs for clients, I developed Ionic DNS to simplify this workflow. Written entirely in Swift, Ionic DNS provides an easier way to manage your DNS settings than using the web interface or calling the API commands manually.

<p align="center">
    <img alt="Ionic DNS Screen Shot" src="https://static.jonalaniz.com/ionic/ss_ionic.png" width="640">


## Features
- **Overview**: View all your DNS Zones, Records, and Values.
- **Dynamic DNS**: Easily select one or multiple A records in a Zone and generate a Dynamic DNS update URL.

## To Do

- ~~**Quick Enable/Disable**: Enable/disable a record with one click.~~
- ~~**Save**: Save IONOS API Keys to disk.~~
- ~~**Delete**: Delete a record.**~~
- ~~**Implement graceful Error handling**~~
- ~~**Create Record**: Create a new record in a Zone.~~
- ~~**Edit**: Edit a record.~~
- **Auto Updating:** Implement Sparkle updating.

## Requirements
- macOS 11 (Big Sur)

## Installation
- Latest binary can be found in the releases section on GitHub.

Scouter was built on Xcode 16 with Swift 5. It has no dependencies, so you should be able to just clone and run.

## Setup

*Ionic DNS requires an IONOS API Key which can be generated [here](https://developer.hosting.ionos.com/keys).*

1. Enter your IONOS API Key.
2. Click 'Connect'.

## Contributions
Contributions are welcome, feel free to submit issues or pull requests to help improve Ionic DNS.

## Support
This is currenlty all I got going in my life, so why not buy me some coffee to keep me going?

<a href="https://www.buymeacoffee.com/jonalaniz" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/yellow_img.png" alt="Buy Me A Coffee" height="41" width="174"></a>

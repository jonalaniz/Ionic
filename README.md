<p align="center">
    <img alt="Ionic DNS Icon" src="http://www.jonalaniz.com/wp-content/uploads/2025/03/ionic_icon.png" width="300">
  
# Ionic DNS

**Ionic DNS** is an open-source macOS utility that implements the IONIS DNS [API](https://developer.hosting.ionos.com/docs/dns). Frustrated with manually using curl to generate Dynamic DNS URLs for clients, I developed Ionic DNS to simplify this workflow. Written entirely in Swift, Ionic DNS provides an easier way to manage your DNS settings than using the web interface or calling the API commands manually.

<p align="center">
    <img alt="Login View" src="https://static.jonalaniz.com/ionic/login.png" width="400">
    <img alt="Main View" src="https://static.jonalaniz.com/ionic/main.png" width="400">
</p>
<p align="center">
    <img alt="Record Creation" src="https://static.jonalaniz.com/ionic/record.png" width="400">
  	<img alt="Dynamic DNS" src="https://static.jonalaniz.com/ionic/ddns.png" width="400">
</p>

## Features
- **Overview**: View all your DNS Zones, Records, and Values.
- **Keychain Support**: Ionic DNS saves your API Key securely using keychain for quick login.
- **Record Create**: Create A, AAAA, CNAME, MX, NS, SRV, and TXT records.
- **Record Editing**: Modify existing Record content and TTL values.
- **Record Deleting**: Delete a record in a Zone.
- **Dynamic DNS**: Easily select one or multiple A/AAAA records in a Zone and generate a Dynamic DNS update URL.
- - **Auto Updating:** Implement Sparkle updating.

## To Do

- **Key Manager:** Implement API Key managment for multiple accounts.

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

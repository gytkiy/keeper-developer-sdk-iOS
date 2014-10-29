# Keeper FastFill Developer SDK for iOS

Keeper is the world's most secure password manager and digital file vault, with over 5 million users across 80 countries.  

The Keeper SDK for iOS is a simple and powerful way for you to incorporate Keeper's secure login and registration technology into your iOS app.  With just a few taps, your users can either register an account with your service, or login to an existing account with their Keeper vault.

## Scenario 1: Login with Existing Account

In this case, the user already has a login and password for your service stored in their Keeper vault.

* User taps on the Keeper lock from your app login screen
* User authenticates with Keeper using Touch ID or Master Password.
* User taps on "Fill & Save" to login to your app.

## Scenario 2: Create a New Account

In this case, the user wants to sign up with your service using their Keeper vault.

* User taps on the Keeper lock from your signup screen
* User authenticates with Keeper using Touch ID or Master Password. 
* User generates a strong password and taps "Fill & Save".

## Developer Setup Instructions

1.  Install Keeper from the [App Store](https://itunes.apple.com/us/app/keeper-password-manager-digital/id287170072?mt=8) on your device.
2.  Clone our [Github repo](https://github.com/Keeper-Security/keeper-developer-sdk-iOS).
3.  Add the KeeperExtensionSDK.framework library to your project.

For sample code demonstrating the calls to Keeper, run the "My Bank App" sample project.

## Security

Keeper is the most secure platform for your users to create accounts and login with existing credentials into your app or service.  To read more about Keeper's encryption, privacy and security, visit our [security disclosure](https://keepersecurity.com/security) page.

## Contact Us

To contact our engineering operations team, email us at ops@keepersecurity.com. For more information about Keeper, visit our website at [https://keepersecurity.com](https://keepersecurity.com).

<hr>
Copyright © 2014 Keeper Security, Inc.<br>
U.S. Patent No. 8,868,932, 8,656,504 and 8,738,934<br>
Patents Pending

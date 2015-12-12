btcbar
======

A tiny status bar widget for OS X that displays the latest USD/BTC spot price from several exchanges.

## Screenshot

Here is how btcbar looks in your status bar:

![Screenshot](https://raw.github.com/nearengine/btcbar/master/Resources/screenshot.png)

And how you can select a ticker:

![Menu Screenshot](https://raw.github.com/nearengine/btcbar/master/Resources/screenshot2.png)

## Installation

Simply place btcbar.app in your `/Applications` folder, and optionally add it to `Login Items` in `System Preferences > Users & Groups` to display it automatically on startup.

## Download

The current version of btcbar (2.3.0) can be downloaded here:

https://github.com/nearengine/btcbar/releases/download/v2.3.0/btcbar_2_3_0.zip

It requires OS X 10.7+ and a 64-bit processor.

## Changelog

### 2.3.0

* Fix #15 text cut off on launch
* Fix #14 setting update frequency to 60 seconds (from 10 seconds)
* Fix #13 Huobi ticker error **Note:** Strict TLS 1.2 checks had to be disabled for the Huobi domain due to their insecure HTTPS certificate. It was only using HTTP until this release, so this is unfortunate but is not a regression.
* Use the new Huobi and OKCoin USD tickers rather than CNY price **Note:** Apologies to anyone this inconveniences. Also, this change will reset your default ticker.
* Tickers are now sorted alphabetically

TODO:
* Implement multiple currency pair support on tickers in the near future to support switching between currencies.
* Make ticker loading and default ticker handling more robust so they can be swapped out or plugged in easier.
* Implement self-updates from within the app
* Figure out an appropriate OSS license

### 2.2.1

* Fix bug where icon disappears on error

### 2.2.0

* Adds BitFinexUSD, WinkDexUSD, HuobiCNY and OKCoinCNY
* New status bar icon with Yosemite (dark theme) support

### 2.1.4

* Removes MtGox

### 2.1.3

* Fixes issue where the local currency code was displayed instead of the USD symbol
* Improves error handling: if there is an error, the icon will fade and a descriptive error will be displayed in the tooltip when hovering over btcbar rather than taking up space in your menu bar

### 2.1.2

* Uses new HTTPS MtGox API to fix "json error"
* Better organization for repo and XCode project
* Standardizes use of commas in tickers

### 2.1.1

* Enables live prices in menu
* Fixes a minor bug in the ticker switching code

### 2.1.0

* New BTCe/USD ticker
* Manually refreshes when a ticker is clicked
* Decreases disk io/cpu time/power usage
* Greatly increases modularity (tickers now have a protocol, menu is dynamically generated)

### 2.0.0

* Adds Bitstamp and Coinbase, and a little better backend abstraction so it will be easier to add future tickers.

TODO:
* Live updating prices for each menu item in the dropdown
* More robust abstraction of tickers/dynamic menu

### 1.0.0

* The first release, which uses MtGox's USD ticker API.

## License

This project currently retains my copyright, although I am considering moving to a FOSS license as it matures.

The source is provided for inspection, considering the nature of Bitcoin. You are free to download and build for personal use, but please don't redistribute this project yet.

## Donate

If for some reason you feel like donating a few micro btc to future development, those should go here:

`1D3NtjVFpoXonqk3MZwsYD9iV5WA7MRXUj`

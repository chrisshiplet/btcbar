btcbar
======

A tiny status bar widget for OS X that displays the latest USD/BTC spot price from BitStamp, BTCe, Coinbase, and MtGox.

## Screenshot

Here is how btcbar looks in your status bar:

![Screenshot](https://raw.github.com/nearengine/btcbar/master/Resources/screenshot.png)

And how you can select a ticker:

![Menu Screenshot](https://raw.github.com/nearengine/btcbar/master/Resources/screenshot2.png)

## Installation

Simply place btcbar.app in your `/Applications` folder, and optionally add it to `Login Items` in `System Preferences > Users & Groups` to display it automatically on startup.

## Download

The current version of btcbar (2.1.0) can be downloaded here:

https://github.com/nearengine/btcbar/releases/download/v2.1.0/btcbar_2_1_0.zip

It requires OS X 10.7+ and a 64-bit processor.

## Changelog

### 2.1.0

* New BTCe/USD ticker
* Manually refreshes when a ticker is clicked
* Decreased disk io/cpu time/power usage
* Greatly increased modularity (tickers now have a protocol, menu is dynamically generated)

### 2.0.0

Adds Bitstamp and Coinbase, and a little better backend abstraction so it will be easier to add future tickers.

TODO:
* Live updating prices for each menu item in the dropdown
* More robust abstraction of tickers/dynamic menu

### 1.0.0

The first release, which uses MtGox's USD ticker API.

## Donate

If for some reason you feel like donating a few micro btc to future development, those should go here:

`1AmsBDouePjXxe2R2kFwbuCdBSpsxwtrUt`

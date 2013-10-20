//
//  AppDelegate.m
//  btcbar
//

#import "AppDelegate.h"

@implementation AppDelegate


//
// INITIALIZE STATUS BAR ITEM
//

- (void)awakeFromNib
{
    // Load ticker preference
    prefs = [NSUserDefaults standardUserDefaults];
    
    // If preference does not exist, default to MtGoxUSD
    if (![prefs objectForKey:@"btcbar_ticker"])
        [prefs setObject:@"MtGoxUSD" forKey:@"btcbar_ticker"];
    
    // Set NSOnState for the selected ticker in the menu
    for (NSMenuItem *menuitem in _menu.itemArray)
        if ([menuitem.title isEqualToString:[prefs objectForKey:@"btcbar_ticker"]])
            [menuitem setState:NSOnState];
    
    // Initialize each ticker and get first updates
    mt_gox = [[MtGoxFetcher alloc] init];
    bitstamp_usd = [[BitStampUSDFetcher alloc] init];
    coinbase_usd = [[CoinbaseUSDFetcher alloc] init];
    
    // Initialize our status bar item with flexible width
    btcbarStatusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];

    // Set Image
    btcbarStatusImage = [NSImage imageNamed:@"btclogo"];
    [btcbarStatusItem setImage:btcbarStatusImage];

    // Set Alternate (Highlighted state) Image
    btcbarHighlightStatusImage = [NSImage imageNamed:@"btclogoAlternate"];
    [btcbarStatusItem setAlternateImage:btcbarHighlightStatusImage];

    // Set options on click
    [btcbarStatusItem setHighlightMode:YES];
    [btcbarStatusItem setMenu:btcbarMenu];

    // Setup timer to update menu bar every other second
    updateViewTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(updateViewTimerAction:) userInfo:nil repeats:YES];
    [self updateViewTimerAction:updateViewTimer];
    
    // Setup timer to update all tickers every 10 seconds
    updateDataTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(updateDataTimerAction:) userInfo:nil repeats:YES];
}


//
// MENU OUTLETS
//
//

// Outlet for menu items which change current ticker
- (void)menuActionSetTicker:(id)sender
{
    // Cast sender to a menu item
    NSMenuItem *senderItem = (NSMenuItem *)sender;
    
    // Set all menu items to "off" state
    for (NSMenuItem *menuitem in _menu.itemArray)
        [menuitem setState:NSOffState];
    
    // Set this menu item to "on" state
    [sender setState:NSOnState];
    
    // Update ticker preference
    [prefs setObject:senderItem.title forKey:@"btcbar_ticker"];
    
    // Force the status item value and website button to update
    [self updateViewTimerAction:updateViewTimer];
}

// "Open in Browser" outlet
- (void)menuActionBrowser:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:webUrl]];
}

// "Quit" outlet
- (void)menuActionQuit:(id)sender
{
    [NSApp performSelector:@selector(terminate:) withObject:nil afterDelay:0.0];
}


//
// TIMER CALLBACKS
//

// Updates the status item with one of the tickers, depending on which one the user has selected
// Updates the link that the "Open in Browser" menu item uses
- (void)updateViewTimerAction:(NSTimer*)timer
{
    NSString *tickerSetting = [prefs stringForKey:@"btcbar_ticker"];
    
    if ([tickerSetting isEqualToString:@"MtGoxUSD"])
    {
        [btcbarStatusItem setTitle:mt_gox.ticker];
        webUrl = mt_gox.url;
    }
    else if ([tickerSetting isEqualToString:@"BitstampUSD"])
    {
        [btcbarStatusItem setTitle:bitstamp_usd.ticker];
        webUrl = bitstamp_usd.url;
    }
    else if ([tickerSetting isEqualToString:@"CoinbaseUSD"])
    {
        [btcbarStatusItem setTitle:coinbase_usd.ticker];
        webUrl = coinbase_usd.url;
    }
    else
    {
        [btcbarStatusItem setTitle:@"invalid default"];
        webUrl = @"";
    }
}

// Requests for each ticker to update itself
- (void)updateDataTimerAction:(NSTimer*)timer
{
    [mt_gox requestUpdate];
    [bitstamp_usd requestUpdate];
    [coinbase_usd requestUpdate];
}

@end

//
//  AppDelegate.h
//  btcbar
//

#import <Cocoa/Cocoa.h>

#import "MtGoxFetcher.h"
#import "BitStampUSDFetcher.h"
#import "CoinbaseUSDFetcher.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    IBOutlet NSMenu *btcbarMenu;
    NSStatusItem *btcbarStatusItem;
    NSImage *btcbarStatusImage;
    NSImage *btcbarHighlightStatusImage;
    NSTimer *updateViewTimer;
    NSTimer *updateDataTimer;
    NSUserDefaults *prefs;
    NSString *webUrl;
    MtGoxFetcher *mt_gox;
    BitStampUSDFetcher *bitstamp_usd;
    CoinbaseUSDFetcher *coinbase_usd;
}

@property (assign) IBOutlet NSMenu *menu;

- (IBAction)menuActionSetTicker:(id)sender;
- (IBAction)menuActionBrowser:(id)sender;
- (IBAction)menuActionQuit:(id)sender;

- (void)updateViewTimerAction:(NSTimer*)timer;
- (void)updateDataTimerAction:(NSTimer*)timer;

@end

//
//  Fetcher.h
//  btcbar
//

#import <Foundation/Foundation.h>

@protocol Fetcher <NSObject>

// Current title in the menu
@property (nonatomic) NSString* ticker_menu;

// Current price of the ticker, including currency symbol
@property (nonatomic) NSString* ticker;

// URL that the "Open in Browser" option opens
@property (nonatomic) NSString* url;

// Error message if ticker returns nil
@property (nonatomic) NSError* error;

// Trigger a refresh, update `ticker` when it completes
- (void)requestUpdate;

@end

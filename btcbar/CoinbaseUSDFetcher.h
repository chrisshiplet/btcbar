//
//  CoinbaseUSDFetcher.h
//  btcbar
//

#import <Foundation/Foundation.h>
#import "Fetcher.h"

@interface CoinbaseUSDFetcher : NSObject<Fetcher, NSURLConnectionDelegate>
{
    NSMutableData *_responseData;
}

@property (nonatomic) NSString* ticker;
@property (nonatomic) NSString* ticker_menu;
@property (nonatomic) NSString* url;

- (void)requestUpdate;

@end

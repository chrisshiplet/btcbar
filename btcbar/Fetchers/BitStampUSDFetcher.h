//
//  BitStampUSDFetcher.h
//  btcbar
//

#import <Foundation/Foundation.h>
#import "Fetcher.h"

@interface BitStampUSDFetcher : NSObject<Fetcher, NSURLConnectionDelegate>
{
    NSMutableData *_responseData;
}

@property (nonatomic) NSString* ticker;
@property (nonatomic) NSString* ticker_menu;
@property (nonatomic) NSString* url;

- (void)requestUpdate;

@end

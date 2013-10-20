//
//  MtGoxFetcher.h
//  btcbar
//

#import <Foundation/Foundation.h>

@interface MtGoxFetcher : NSObject<NSURLConnectionDelegate>
{
    NSMutableData *_responseData;
}

@property NSString* ticker;
@property NSString* url;

- (void)requestUpdate;

@end

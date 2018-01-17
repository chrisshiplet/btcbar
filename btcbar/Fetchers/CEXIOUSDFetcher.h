//
//  CEXIOUSDFetcher.h
//  btcbar
//
//  Copyright (c) 2018 nearengine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Fetcher.h"

@interface CEXIOUSDFetcher : NSObject<Fetcher, NSURLConnectionDelegate>

@property (nonatomic) NSString* ticker;
@property (nonatomic) NSString* ticker_menu;
@property (nonatomic) NSString* url;
@property (nonatomic) NSError* error;
@property (nonatomic) NSMutableData *responseData;

- (void)requestUpdate;

@end

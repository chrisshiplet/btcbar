//
//  CoinbaseUSDFetcher.m
//  btcbar
//

#import "CoinbaseUSDFetcher.h"

@implementation CoinbaseUSDFetcher

- (id)init
{
    if (self = [super init])
    {
        // Menu Item Name
        self.ticker_menu = @"CoinbaseUSD";
        
        // Default ticker value
        self.ticker = @"";
        
        // Website location
        self.url = @"https://coinbase.com/";
        
        // Immediately request first update
        [self requestUpdate];
    }
    
    return self;
}

// Override Ticker setter to trigger status item update
- (void)setTicker:(NSString *)tickerString
{
    // Update the ticker value
    _ticker = tickerString;
    
    // Trigger notification to update ticker
    [[NSNotificationCenter defaultCenter] postNotificationName:@"btcbar_ticker_update" object:self];
}

// Initiates an asyncronous HTTP connection
- (void)requestUpdate
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://coinbase.com/api/v1/prices/spot_rate"]];
    
    // Set the request's user agent
    [request addValue:@"btcbar/2.0 (CoinbaseUSDFetcher)" forHTTPHeaderField:@"User-Agent"];
    
    // Initialize a connection from our request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    // Go go go
    [connection start];
}

// Initializes data storage on request response
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.responseData = [[NSMutableData alloc] init];
}

// Appends response data
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}

// Indiciate no caching
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return nil;
}

// Parse data after load
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Parse the JSON into results
    NSError *jsonParsingError = nil;
    NSDictionary *results = [[NSDictionary alloc] init];
    results = [NSJSONSerialization JSONObjectWithData:self.responseData options:0 error:&jsonParsingError];
    
    // Results parsed successfully from JSON
    if(results)
    {
        // Get API status
        NSString *resultsStatus = [results objectForKey:@"amount"];
        
        // If API call succeeded update the ticker...
        if(resultsStatus)
        {
            NSDecimalNumber *resultsStatusNumber = [NSDecimalNumber decimalNumberWithString:resultsStatus];
            NSNumberFormatter *currencyStyle = [[NSNumberFormatter alloc] init];
            currencyStyle.numberStyle = NSNumberFormatterCurrencyStyle;
            self.ticker = [currencyStyle stringFromNumber:resultsStatusNumber];
        }
        // Otherwise log an error...
        else
        {
            NSLog(@"CoinbaseUSDFetcher: api error");
            [self setTicker:@"api error"];
        }
    }
    // JSON parsing failed
    else
    {
        NSLog(@"CoinbaseUSDFetcher: json error");
        [self setTicker:@"json error"];
    }
}

// HTTP request failed
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"CoinbaseUSDFetcher: %@", error);
    [self setTicker:@"connection error"];
}

@end

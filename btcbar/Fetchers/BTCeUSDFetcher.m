//
//  BTCeUSDFetcher.m
//  btcbar
//

#import "BTCeUSDFetcher.h"

@implementation BTCeUSDFetcher

- (id)init
{
    if (self = [super init])
    {
        // Menu Item Name
        self.ticker_menu = @"BTCeUSD";
        
        // Default ticker value
        self.ticker = @"";
        
        // Website location
        self.url = @"https://btc-e.com/";
        
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
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://btc-e.com/api/2/btc_usd/ticker"]];
    
    // Set the request's user agent
    [request addValue:@"btcbar/2.0 (BTCeUSDFetcher)" forHTTPHeaderField:@"User-Agent"];
    
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
        
        if ([[results objectForKey:@"ticker"] objectForKey:@"last"])
        {
            NSNumberFormatter *currencyStyle = [[NSNumberFormatter alloc] init];
            currencyStyle.numberStyle = NSNumberFormatterCurrencyStyle;
            self.ticker = [currencyStyle stringFromNumber:[[results objectForKey:@"ticker"] objectForKey:@"last"]];
        }
        else
        {
            NSLog(@"BTCeUSDFetcher: api error");
            [self setTicker:@"api error"];
        }
    }
    // JSON parsing failed
    else
    {
        NSLog(@"BTCeUSDFetcher: json error");
        [self setTicker:@"json error"];
    }
}

// HTTP request failed
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"BTCeUSDFetcher: %@", error);
    [self setTicker:@"connection error"];
}

@end

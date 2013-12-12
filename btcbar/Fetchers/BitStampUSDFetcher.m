//
//  BitStampUSDFetcher.m
//  btcbar
//

#import "BitStampUSDFetcher.h"

@implementation BitStampUSDFetcher

- (id) init
{
    if (self = [super init])
    {
        // Menu Item Name
        [self setTicker_menu:@"BitStampUSD"];
        
        // Default ticker value
        [self setTicker:@""];
        
        // Website location
        [self setUrl:@"https://www.bitstamp.net/"];
        
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
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.bitstamp.net/api/ticker/"]];
    
    // Set the request's user agent
    [request addValue:@"btcbar/2.0 (BitStampUSDFetcher)" forHTTPHeaderField:@"User-Agent"];
    
    // Initialize a connection from our request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    // Go go go
    [connection start];
}

// Initializes data storage on request response
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _responseData = [[NSMutableData alloc] init];
}

// Appends response data
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
}

// Indiciate no caching
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
    return nil;
}

// Parse data after load
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Parse the JSON into results
    NSError *jsonParsingError = nil;
    NSDictionary *results = [[NSDictionary alloc] init];
    results = [NSJSONSerialization JSONObjectWithData:_responseData options:0 error:&jsonParsingError];
    
    // Results parsed successfully from JSON
    if(results)
    {
        // Get API status
        NSString *resultsStatus = [results objectForKey:@"last"];
        
        // If API call succeeded update the ticker...
        if(resultsStatus)
        {
            NSNumberFormatter *currencyStyle = [[NSNumberFormatter alloc] init];
            [currencyStyle setNumberStyle:NSNumberFormatterCurrencyStyle];
            resultsStatus = [currencyStyle stringFromNumber:[NSDecimalNumber decimalNumberWithString:resultsStatus]];
            [self setTicker:resultsStatus];
        }
        // Otherwise log an error...
        else
        {
            NSLog(@"BitStampUSDFetcher: api error");
            [self setTicker:@"api error"];
        }
    }
    // JSON parsing failed
    else
    {
        NSLog(@"BitStampUSDFetcher: json error");
        [self setTicker:@"json error"];
    }
}

// HTTP request failed
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"BitStampUSDFetcher: %@", error);
    [self setTicker:@"connection error"];
}

@end

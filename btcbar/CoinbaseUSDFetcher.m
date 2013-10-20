//
//  CoinbaseUSDFetcher.m
//  btcbar
//

#import "CoinbaseUSDFetcher.h"

@implementation CoinbaseUSDFetcher

@synthesize ticker;

- (id) init
{
    if (self = [super init])
    {
        // Default ticker value
        [self setTicker:@""];
        
        // Website location
        [self setUrl:@"https://coinbase.com/"];
        
        // Immediately request first update
        [self requestUpdate];
    }
    
    return self;
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
        // Get MtGox API status
        NSString *resultsStatus = [results objectForKey:@"amount"];
        
        // If API call succeeded update the ticker...
        if(resultsStatus)
        {
            [self setTicker:[@"$" stringByAppendingString:resultsStatus]];
        }
        // Otherwise log an error...
        else
        {
            NSLog(@"CoinbaseUSDFetcher: api error");
            [self setTicker:@"CoinbaseUSDFetcher: api error"];
        }
    }
    // JSON parsing failed
    else
    {
        NSLog(@"CoinbaseUSDFetcher: json error");
        [self setTicker:@"CoinbaseUSDFetcher: json error"];
    }
}

// HTTP request failed
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"CoinbaseUSDFetcher: %@", error);
    [self setTicker:@"CoinbaseUSDFetcher: connection error"];
}

@end

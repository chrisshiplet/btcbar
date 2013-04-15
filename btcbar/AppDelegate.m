//
//  AppDelegate.m
//  btcbar
//

#import "AppDelegate.h"

@implementation AppDelegate


//
// INITIALIZE STATUS BAR ITEM
//
- (void)awakeFromNib
{
    // Initialize our status bar item with flexible width
    btcbarStatusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];

    // Set Image
    btcbarStatusImage = [NSImage imageNamed:@"btclogo"];
    [btcbarStatusItem setImage:btcbarStatusImage];

    // Set Alternate (Highlighted state) Image
    btcbarHighlightStatusImage = [NSImage imageNamed:@"btclogoAlternate"];
    [btcbarStatusItem setAlternateImage:btcbarHighlightStatusImage];

    // Set options on click
    [btcbarStatusItem setHighlightMode:YES];
    [btcbarStatusItem setMenu:btcbarMenu];

    // Setup timer to update menu bar every 30 seconds
    updateTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(updateTimerAction:) userInfo:nil repeats:YES];

    // Update the menu bar for the first time
    [self updateMenuBar];
}


//
// ASYNC FETCH LATEST DATA
//

// updateMenuBar initiates an asyncronous connection to MtGox's v1 API
- (void)updateMenuBar
{
    // Cancel any previous connections we made
    [connection cancel];

    // Initialize a datastore, url, and request
    NSMutableData *data = [[NSMutableData alloc] init];
    receivedData = data;
    NSURL *url = [NSURL URLWithString:@"http://data.mtgox.com/api/1/BTCUSD/ticker"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    // Set the request's user agent per MtGox's API requirements
    [request addValue:@"btcbar widget for OS X" forHTTPHeaderField:@"User-Agent"];

    // Initialize a connection from our request
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];

    // Go go go
    [connection start];
}

// didReceiveData callback appends the most recent chunk to our data object
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [receivedData appendData:data];
}

// didFailWithError callback means the request failed, log and display error
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [btcbarStatusItem setTitle:@"connect err"];
    NSLog(@"%@" , error);
}

// connectionDidFinishLoading callback means we succeeded, try to parse JSON and update the displayed value
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    // Parse the JSON into results
    NSError *jsonParsingError = nil;
    NSDictionary *results = [NSJSONSerialization JSONObjectWithData:receivedData options:0 error:&jsonParsingError];

    // Create dictionary from JSON response
    if(results) {
        
        // Save the status from the results
        NSString *resultsStatus = [results objectForKey:@"result"];

        // See if it succeeded
        if([resultsStatus isEqualToString:@"success"]) {
            [btcbarStatusItem setTitle:[[[results objectForKey:@"return"] objectForKey:@"last"] objectForKey:@"display"]];
        } else {
            [btcbarStatusItem setTitle:@"mtgox err"];
        }
    } else {
        // JSON parsing failed
        [btcbarStatusItem setTitle:@"json err"];
    }
}


//
// MENU ACTIONS
//

// "Open MtGox" option
- (void)menuActionMtGox:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://mtgox.com"]];
}

// "Quit btcbar" Option
- (void)menuActionQuit:(id)sender
{
    [NSApp performSelector:@selector(terminate:) withObject:nil afterDelay:0.0];
}


//
// TIMER CALLBACK
//

// This updates the menu bar every so many seconds (defined in awakeFromNib)
- (void)updateTimerAction:(NSTimer*)timer
{
    [self updateMenuBar];
}

@end

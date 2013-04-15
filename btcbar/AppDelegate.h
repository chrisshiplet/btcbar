//
//  AppDelegate.h
//  btcbar
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    IBOutlet NSMenu *btcbarMenu;
    NSStatusItem *btcbarStatusItem;
    NSImage *btcbarStatusImage;
    NSImage *btcbarHighlightStatusImage;
    NSTimer *updateTimer;
    NSURLConnection *connection;
    NSMutableData *receivedData;
}

- (void)updateMenuBar;

- (IBAction)menuActionMtGox:(id)sender;
- (IBAction)menuActionQuit:(id)sender;

- (void)updateTimerAction:(NSTimer*)timer;

@end

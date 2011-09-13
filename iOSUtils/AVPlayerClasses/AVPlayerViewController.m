//
//  AVPlayerViewController.m
//  SingingCard
//
//  Created by Roee Kremer on 8/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AVPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AVPlayerDemoPlaybackView.h"

@implementation AVPlayerViewController

@synthesize player;
@synthesize delegate;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
	self.player = nil;
    [super dealloc];
}

static const NSString *ItemStatusContext;

-(void)loadAssetFromURL:(NSURL *)fileURL {
	AVURLAsset *asset = [AVURLAsset URLAssetWithURL:fileURL options:nil];
    NSString *tracksKey = @"tracks";
	
    [asset loadValuesAsynchronouslyForKeys:[NSArray arrayWithObject:tracksKey] completionHandler:
     ^{
		 NSError *error = nil;
		 AVKeyValueStatus status = [asset statusOfValueForKey:tracksKey error:&error];
		 
		 if (status == AVKeyValueStatusLoaded) {
			 AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
			 
			 AVPlayerLayer *layer = (AVPlayerLayer *)[(AVPlayerDemoPlaybackView *)self.view layer];
			 [layer addObserver:self forKeyPath:@"readyForDisplay"
							 options:0 context:&ItemStatusContext];
			 
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
			 self.player = [AVPlayer playerWithPlayerItem:playerItem];
			 [(AVPlayerDemoPlaybackView *)self.view setPlayer:self.player];
			 [self.player play];
		 }
		 else {
			 // Deal with the error appropriately.
			 NSLog(@"The asset's tracks were not loaded:\n%@", [error localizedDescription]);
		 }
     }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
	
    if (context == &ItemStatusContext) {
        [delegate AVPlayerLayerIsReadyForDisplay:self];
        return;
    }
    [super observeValueForKeyPath:keyPath ofObject:object
						   change:change context:context];
    return;
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
   [self dismissModalViewControllerAnimated:NO];
}

-(IBAction)skip:(id)sender {
	[self.player pause];
	[self dismissModalViewControllerAnimated:NO];
}

@end

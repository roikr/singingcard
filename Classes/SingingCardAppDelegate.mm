//
//  SingingCardAppDelegate.m
//  SingingCard
//
//  Created by Roee Kremer on 12/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SingingCardAppDelegate.h"
#import "MainViewController.h"
#import "ShareManager.h"

#import "AVPlayerDemoPlaybackViewController.h"
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>

#include "Constants.h"
#include "testApp.h"

@implementation SingingCardAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize mainViewController;

@synthesize OFSAptr;
@synthesize lastSavedVersion;
@synthesize shareManager;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
	//----- DAMIAN
	// set data path root for ofToDataPath()
	// path on iPhone will be ~/Applications/{application GUID}/openFrameworks.app/data
	// get the resource path for the bundle (ie '~/Applications/{application GUID}/openFrameworks.app')
	NSString *bundle_path_ns = [[NSBundle mainBundle] resourcePath];
	// convert to UTF8 STL string
	string path = [bundle_path_ns UTF8String];
	// append data
	//path.append( "/data/" ); // ZACH
	path.append( "/" ); // ZACH
	ofLog(OF_LOG_VERBOSE, "setting data path root to " + path);
	ofSetDataPathRoot( path );
	//-----
	
	
	
	self.OFSAptr = new testApp;
	self.shareManager = [ShareManager shareManager];
	
		
	OFSAptr->setup();
	[mainViewController updateViews];
	
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
		while (1) {
			OFSAptr->update(); // also update bNeedDisplay
			if (OFSAptr->bNeedDisplay) {
				if (mainViewController) {
					dispatch_async(dispatch_get_main_queue(), ^{
						[mainViewController updateViews];
					});
					OFSAptr->bNeedDisplay = false;
				}
			}
		}
	});
	
	
	//[self.window addSubview:self.navigationController.view];
	[self.window makeKeyWindow];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [self.mainViewController stopAnimation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self.mainViewController startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self.mainViewController stopAnimation];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Handle any background procedures not related to animation here.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Handle any foreground procedures not related to animation here.
}

- (void)dealloc
{
    [mainViewController release];
    [window release];
    
    [super dealloc];
}



- (void)playURL:(NSURL *)url {
	
	AVPlayerDemoPlaybackViewController* mPlaybackViewController = [[[AVPlayerDemoPlaybackViewController allocWithZone:[self zone]] init] autorelease];
	
	[mPlaybackViewController setURL:url]; //[NSURL fileURLWithPath:[documentsDirectory stringByAppendingPathComponent:@"video.mov"]]
	[[mPlaybackViewController player] seekToTime:CMTimeMakeWithSeconds(0.0, NSEC_PER_SEC) toleranceBefore:CMTimeMake(1, 2 * NSEC_PER_SEC) toleranceAfter:CMTimeMake(1, 2 * NSEC_PER_SEC)];
	
	//[[mPlaybackViewController player] seekToTime:CMTimeMakeWithSeconds([defaults doubleForKey:AVPlayerDemoContentTimeUserDefaultsKey], NSEC_PER_SEC) toleranceBefore:CMTimeMake(1, 2 * NSEC_PER_SEC) toleranceAfter:CMTimeMake(1, 2 * NSEC_PER_SEC)];
	
	[self presentModalViewController:mPlaybackViewController animated:NO];
}

- (void)presentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated {
	[navigationController presentModalViewController:modalViewController animated:animated];
}

- (void)dismissModalViewControllerAnimated:(BOOL)animated {
	[navigationController dismissModalViewControllerAnimated:animated];
}

- (void)pushViewController:(UIViewController *)controller {
	[navigationController pushViewController:controller animated:YES];
}

- (void) popViewController {
	[navigationController popViewControllerAnimated:YES];
}


@end

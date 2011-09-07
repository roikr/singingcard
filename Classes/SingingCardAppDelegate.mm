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

//#import "AVPlayerDemoPlaybackViewController.h"
#import "AVPlayerViewController.h"
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>

#include "Constants.h"
#include "testApp.h"
#include "ofMainExt.h"
#include "EAGLView.h"
#include "RKMacros.h"

@implementation SingingCardAppDelegate

@synthesize window;
@synthesize eAGLView;


@synthesize mainViewController;

@synthesize OFSAptr;
@synthesize lastSavedVersion;
@synthesize shareManager;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    RKLog(@"application didFinishLaunchingWithOptions");
	setiPhoneDataPath();	
	
	

	self.OFSAptr = new testApp;
	self.shareManager = [ShareManager shareManager];
	

	OFSAptr->setup();
		
	self.window.rootViewController = self.mainViewController;
	[self.window makeKeyAndVisible];
	
	AVPlayerViewController *playerViewController =[[AVPlayerViewController alloc] initWithNibName:@"AVPlayerViewController" bundle:nil];
	[playerViewController loadAssetFromURL:[[NSBundle mainBundle] URLForResource:@"shana_tova_intro" withExtension:@"mov"]];
	[self.mainViewController presentModalViewController:playerViewController animated:NO];
	[playerViewController release];
	
//	 AVPlayerDemoPlaybackViewController* mPlaybackViewController = [[[AVPlayerDemoPlaybackViewController allocWithZone:[self zone]] init] autorelease];
//	 [mPlaybackViewController setURL:]; //[NSURL fileURLWithPath:[documentsDirectory stringByAppendingPathComponent:@"video.mov"]]
//	 [[mPlaybackViewController player] seekToTime:CMTimeMakeWithSeconds(0.0, NSEC_PER_SEC) toleranceBefore:CMTimeMake(1, 2 * NSEC_PER_SEC) toleranceAfter:CMTimeMake(1, 2 * NSEC_PER_SEC)];
//	 
//	 //[[mPlaybackViewController player] seekToTime:CMTimeMakeWithSeconds([defaults doubleForKey:AVPlayerDemoContentTimeUserDefaultsKey], NSEC_PER_SEC) toleranceBefore:CMTimeMake(1, 2 * NSEC_PER_SEC) toleranceAfter:CMTimeMake(1, 2 * NSEC_PER_SEC)];
//	 
//	 [self.mainViewController presentModalViewController:mPlaybackViewController animated:NO];
	
	 
	 
	
	
	[self.eAGLView setInterfaceOrientation:UIInterfaceOrientationLandscapeRight duration:0];
	
	return YES;
}



- (void)applicationDidBecomeActive:(UIApplication *)application {
    RKLog(@"applicationDidBecomeActive");
	/*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
	
	[self.eAGLView startAnimation];

	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
		RKLog(@"update loop started");
		
		while ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
			if (OFSAptr) {
				
				//OFSAptr->update(); // also update bNeedDisplay
				
				if (OFSAptr->bNeedDisplay) {
					dispatch_async(dispatch_get_main_queue(), ^{
						
						[mainViewController updateViews];
						
						
						
						
					});
					OFSAptr->bNeedDisplay = false; // this should stay out off the main view async call
				}
				
			}
			
		}
		RKLog(@"update loop exited");		
	});

	
	if (OFSAptr) {
		OFSAptr->soundStreamStart();
	}
	
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    RKLog(@"applicationWillResignActive");
	[self.eAGLView stopAnimation];
	
	if (OFSAptr) {
		OFSAptr->soundStreamStop();
	}
}



- (void)applicationWillTerminate:(UIApplication *)application
{
     RKLog(@"applicationWillTerminate");
	[self.eAGLView stopAnimation]; 
}

- (void)beginInterruption {
	RKLog(@"beginInterruption");
	if (OFSAptr) {
		OFSAptr->soundStreamStop();
	}
}

- (void)endInterruptionWithFlags:(NSUInteger)flags {
	RKLog(@"endInterruptionWithFlags: %u",flags);
	
	if (flags && AVAudioSessionInterruptionFlags_ShouldResume) {
		NSError *activationError = nil;
		[[AVAudioSession sharedInstance] setActive: YES error: &activationError];
		RKLog(@"audio session activated");
		if (OFSAptr) {
			OFSAptr->soundStreamStart();
		}
		
	}
	
}





- (void)applicationDidEnterBackground:(UIApplication *)application
{
     RKLog(@"applicationDidEnterBackground");
	// Handle any background procedures not related to animation here.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    RKLog(@"applicationWillEnterForeground");
	// Handle any foreground procedures not related to animation here.
}

- (void)dealloc
{
    [eAGLView release];
	[mainViewController release];

    [window release];
    
    [super dealloc];
}







@end

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
}



- (void)applicationWillTerminate:(UIApplication *)application
{
     RKLog(@"applicationWillTerminate");
	[self.eAGLView stopAnimation]; 
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

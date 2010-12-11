//
//  SingingCardAppDelegate.h
//  SingingCard
//
//  Created by Roee Kremer on 12/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MainViewController;
@class ShareManager;
class testApp;

@interface SingingCardAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MainViewController *mainViewController;
	UINavigationController *navigationController;
	
	testApp *OFSAptr;
	
	ShareManager *shareManager;
	NSInteger lastSavedVersion;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MainViewController *mainViewController;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property testApp *OFSAptr;

@property (nonatomic, retain) ShareManager *shareManager;
@property NSInteger lastSavedVersion;

- (void)presentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated;
- (void)dismissModalViewControllerAnimated:(BOOL)animated;
- (void)pushViewController:(UIViewController *)controller;
- (void)popViewController;
- (void)playURL:(NSURL *)url;

@end



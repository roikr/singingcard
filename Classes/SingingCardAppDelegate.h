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
@class EAGLView;
class testApp;

@interface SingingCardAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	EAGLView *eAGLView;
    MainViewController *mainViewController;
	\
		
	testApp *OFSAptr;
	
	ShareManager *shareManager;
	NSInteger lastSavedVersion;
	
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic,retain)  IBOutlet EAGLView *eAGLView;
@property (nonatomic, retain) IBOutlet MainViewController *mainViewController;


@property testApp *OFSAptr;

@property (nonatomic, retain) ShareManager *shareManager;
@property NSInteger lastSavedVersion;





@end



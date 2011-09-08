//
//  ShareViewController.m
//  SingingCard
//
//  Created by Roee Kremer on 9/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShareViewController.h"
#import "SingingCardAppDelegate.h"
#import "ShareManager.h"
#import "RKMacros.h"

@interface ShareViewController() 
-(void) presentActionSheet;
@end


@implementation ShareViewController

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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


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
    [super dealloc];
}


#pragma mark actionSheet

- (void)viewDidAppear:(BOOL)animated {	
	
}

-(void) presentActionSheet {
		
	
	UIActionSheet* sheet = [[[UIActionSheet alloc] init] autorelease];
	sheet.actionSheetStyle = UIActionSheetStyleDefault;
	
	//sheet.title = @"Illustrations";
	sheet.delegate = self;
	
	
	[sheet addButtonWithTitle:@"Upload to FaceBook"];
	[sheet addButtonWithTitle:@"Upload to YouTube"];
	
	[sheet addButtonWithTitle:@"Add to Library"];
	
	
	[sheet addButtonWithTitle:@"Send via mail"];
	[sheet addButtonWithTitle:@"Send ringtone"];
	
	
	
	
	[sheet addButtonWithTitle:@"Done"];
	//	[sheet addButtonWithTitle:@"Render"];
	//	[sheet addButtonWithTitle:@"Play"];
	
	
	
	[sheet showInView:self.view];
	//sheet.cancelButtonIndex = [sheet addButtonWithTitle:@"Cancel"];
	
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {
	RKLog(@"willPresentActionSheet");
	
	
}

- (void)actionSheet:(UIActionSheet *)modalView clickedButtonAtIndex:(NSInteger)buttonIndex {
	RKLog(@"actionSheet clickedButtonAtIndex");
}



- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
	RKLog(@"actionSheet didDismissWithButtonIndex");
	NSUInteger action;
	switch (buttonIndex)
	{
		case 0: 
			action = ACTION_UPLOAD_TO_FACEBOOK;
			break;
		case 1:
			action = ACTION_UPLOAD_TO_YOUTUBE;
			break;
		case 2:
			action = ACTION_ADD_TO_LIBRARY;
			break;
		case 3:
			action = ACTION_SEND_VIA_MAIL;
			break;
		case 4:
			action = ACTION_SEND_RINGTONE;
			break;
		case 5:
			action = ACTION_DONE;
			break;
	}
	[self.parentViewController dismissModalViewControllerAnimated:NO];
	[((SingingCardAppDelegate *)[[UIApplication sharedApplication] delegate]).shareManager execute:action];
}



@end

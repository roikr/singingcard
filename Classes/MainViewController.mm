//
//  MainViewController.m
//  SingingCard
//
//  Created by Roee Kremer on 12/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h> // only for camera count

#import "MainViewController.h"
#import "EAGLView.h"
#import "SingingCardAppDelegate.h"

#include "Constants.h"
#include "testApp.h"

#import "EAGLView.h"
#import "glu.h"
#import "ShareManager.h"

#import "RKMacros.h"

#import "ShareManager.h"




@interface MainViewController ()



@end

@implementation MainViewController

@synthesize liveView;
@synthesize recordView;
@synthesize playView;
@synthesize playButton;


//@synthesize shareProgressView;




//@synthesize cameraToggleButton = _cameraToggleButton;

- (void)viewDidLoad	// need to be called after the EAGL awaked from nib
//- (void)awakeFromNib
{
     [super viewDidLoad];
		
	//[[self cameraToggleButton] setEnabled:[self cameraCount] > 1];
	
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

- (void)dealloc
{
   
    
    
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	
    
}








- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (testApp *)OFSAptr {
	return [(SingingCardAppDelegate*)[[UIApplication sharedApplication] delegate] OFSAptr];
}

- (void)updateViews {
	
//	if (self.navigationController.topViewController != self) {
//		return;
//	}
	

	liveView.hidden = YES;
	recordView.hidden = YES;
	playView.hidden = YES;
	playButton.selected = NO;
	
	
	
	switch (self.OFSAptr->getSongState()) {
		case SONG_IDLE:
		case SONG_PLAY: {
			buttonsView.hidden = NO;
			switch (self.OFSAptr->getState()) {
				case STATE_LIVE:
					liveView.hidden = NO;

					break;
				case STATE_RECORD:
					recordView.hidden = NO;
					
					break;
				case STATE_PLAY:
					playView.hidden = NO;
					playButton.selected = self.OFSAptr->getSongState() == SONG_PLAY;
				default:
					break;
			}
			
			
	
		}	break;
		case SONG_RENDER_AUDIO:
		case SONG_RENDER_VIDEO:
		case SONG_RENDER_AUDIO_FINISHED:
		case SONG_CANCEL_RENDER_AUDIO:
			
		default:
			break;
	}
}


- (IBAction) live:(id)sender {
	self.OFSAptr->live();
}

- (IBAction) record:(id)sender {
	self.OFSAptr->record();
}

- (IBAction) preview:(id)sender {
	self.OFSAptr->preview();
}

- (IBAction) play:(id)sender {
		self.OFSAptr->setSongState(self.OFSAptr->getSongState() == SONG_PLAY ? SONG_IDLE : SONG_PLAY);
}

- (IBAction) stop:(id)sender {
	self.OFSAptr->setSongState(SONG_IDLE);
}

- (IBAction) share:(id)sender {
	
	ShareManager *shareManager = [(SingingCardAppDelegate*)[[UIApplication sharedApplication] delegate] shareManager];
	
	if ([shareManager isUploading]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sharing" 
														message:@"Video upload in progress"
													   delegate:nil  cancelButtonTitle:@"OK"  otherButtonTitles: nil];
		[alert show];
		[alert release];
	} else {
		
		//[[(SingingCardAppDelegate*)[[UIApplication sharedApplication] delegate] shareManager] prepare];
		self.OFSAptr->setSongState(SONG_IDLE);
		[shareManager menuWithView:self.view];
	}
	// BUG FIX: this is very important: don't present from milgromViewController as it will result in crash when returning to BandView after share
	
}
//
//- (IBAction)cameraToggle:(id)sender
//{
//    self.OFSAptr->cameraToggle();
//}


#pragma mark Render && Share

- (void) setShareProgress:(float) progress {
//	[shareProgressView setRect:CGRectMake(0, 1.0-progress, 1.0f,progress)];
}







- (NSUInteger) cameraCount
{
    return [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
}

@end

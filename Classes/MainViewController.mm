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

#import "MilgromMacros.h"

#import "CustomImageView.h"
#import "ShareManager.h"
#import "OpenGLTOMovie.h"
#import "ExportManager.h"



@interface MainViewController ()
@property (nonatomic, retain) EAGLContext *context;
@property (nonatomic, assign) CADisplayLink *displayLink;

- (void)updateRenderProgress;
- (void)renderAudioDidFinish;
- (void)updateExportProgress:(ExportManager*)manager;
- (NSUInteger) cameraCount;


@end

@implementation MainViewController

@synthesize animating, context, displayLink;

@synthesize buttonsView;

@synthesize renderView;
@synthesize renderLabel;
@synthesize renderTextView;

@synthesize shareProgressView;
@synthesize renderProgressView;
@synthesize exportManager;
@synthesize renderManager;

@synthesize eAGLView;

@synthesize cameraToggleButton = _cameraToggleButton;

- (void)viewDidLoad	// need to be called after the EAGL awaked from nib
//- (void)awakeFromNib
{
    
	EAGLContext *aContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
    
       
    if (!aContext)
        NSLog(@"Failed to create ES context");
    else if (![EAGLContext setCurrentContext:aContext])
        NSLog(@"Failed to set ES context current");
    
	self.context = aContext;
	[aContext release];
	
	
	
	[eAGLView setContext:context];
    [eAGLView setFramebuffer];
    
    
    
    animating = FALSE;
    animationFrameInterval = 1;
    self.displayLink = nil;
	
	[[self cameraToggleButton] setEnabled:[self cameraCount] > 1];
	
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)dealloc
{
   
    
    // Tear down context.
    if ([EAGLContext currentContext] == context)
        [EAGLContext setCurrentContext:nil];
    
    [context release];
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self startAnimation];
    [super viewWillAppear:animated];
	
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self stopAnimation];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	
    // Tear down context.
    if ([EAGLContext currentContext] == context)
        [EAGLContext setCurrentContext:nil];
	self.context = nil;	
}

- (NSInteger)animationFrameInterval
{
    return animationFrameInterval;
}

- (void)setAnimationFrameInterval:(NSInteger)frameInterval
{
    /*
	 Frame interval defines how many display frames must pass between each time the display link fires.
	 The display link will only fire 30 times a second when the frame internal is two on a display that refreshes 60 times a second. The default frame interval setting of one will fire 60 times a second when the display refreshes at 60 times a second. A frame interval setting of less than one results in undefined behavior.
	 */
    if (frameInterval >= 1)
    {
        animationFrameInterval = frameInterval;
        
        if (animating)
        {
            [self stopAnimation];
            [self startAnimation];
        }
    }
}

- (void)startAnimation
{
    if (!animating)
    {
        CADisplayLink *aDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawFrame)];
        [aDisplayLink setFrameInterval:animationFrameInterval];
        [aDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        self.displayLink = aDisplayLink;
        
        animating = TRUE;
    }
}

- (void)stopAnimation
{
    if (animating)
    {
        [self.displayLink invalidate];
        self.displayLink = nil;
        animating = FALSE;
    }
}

- (void)drawFrame 
{
    if (self.OFSAptr->getIsFboNeeded()) {
		[self.eAGLView setContext:context];
		
		self.OFSAptr->fboDraw();
	}
	
	
	[self.eAGLView setFramebuffer];
    
	glMatrixMode (GL_PROJECTION);
	glLoadIdentity ();
	gluOrtho2D (0, self.eAGLView.framebufferWidth, 0, self.eAGLView.framebufferHeight);
	glMatrixMode(GL_MODELVIEW);
	
	glLoadIdentity();
	glScalef(1.0, -1.0,1.0);
	glTranslatef(0, -self.eAGLView.framebufferHeight, 0);
	
	self.OFSAptr->draw();
	
	[self.eAGLView presentFramebuffer];
	
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
	
	if (self.navigationController.topViewController != self) {
		return;
	}
	
	
	buttonsView.hidden = YES;
	renderView.hidden = YES;
	
	switch (self.OFSAptr->getSongState()) {
		case SONG_IDLE:
		case SONG_PLAY:
			buttonsView.hidden = NO;
			break;
		case SONG_RENDER_AUDIO:
		case SONG_RENDER_VIDEO:
		case SONG_RENDER_AUDIO_FINISHED:
		case SONG_CANCEL_RENDER_AUDIO:
			renderView.hidden = NO;
		default:
			break;
	}
		
	
}


- (IBAction) shoot:(id)sender {
	self.OFSAptr->record();
}

- (IBAction) preview:(id)sender {
	self.OFSAptr->preview();
}
- (IBAction) play:(id)sender {
	self.OFSAptr->setSongState(SONG_PLAY);
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

- (IBAction)cameraToggle:(id)sender
{
    self.OFSAptr->cameraToggle();
}


#pragma mark Render && Share

- (void) setShareProgress:(float) progress {
	[shareProgressView setRect:CGRectMake(0, 1.0-progress, 1.0f,progress)];
}


- (void) setRenderProgress:(float) progress {
	[renderProgressView setProgress:progress];
	//[renderProgressView setRect:CGRectMake(0.0f, 0.0f,progress,1.0f)];
}

- (void)updateRenderProgress
{
	
	if (self.OFSAptr->getSongState()==SONG_RENDER_AUDIO || self.OFSAptr->getSongState()==SONG_RENDER_VIDEO) {
		float progress = self.OFSAptr->getRenderProgress();
		[self setRenderProgress:progress];
		//NSLog(@"rendering, progrss: %2.2f",progress);
		
		NSArray *modes = [[[NSArray alloc] initWithObjects:NSDefaultRunLoopMode, UITrackingRunLoopMode, nil] autorelease];
		[self performSelector:@selector(updateRenderProgress) withObject:nil afterDelay:0.1 inModes:modes];
	}
}

- (void)renderAudio {
	self.renderLabel.text = @"Creating audio";
	[self setRenderProgress:0.0f];
	
	dispatch_queue_t myCustomQueue;
	myCustomQueue = dispatch_queue_create("renderAudioQueue", NULL);
	
	//[milgromViewController stopAnimation];
	self.OFSAptr->soundStreamStop();
	
	dispatch_async(myCustomQueue, ^{
		
		self.OFSAptr->renderAudio();
		
		
		dispatch_async(dispatch_get_main_queue(), ^{
			[self renderAudioDidFinish];
		});
		
		
	});
	
	dispatch_release(myCustomQueue);
	
	NSArray *modes = [[[NSArray alloc] initWithObjects:NSDefaultRunLoopMode, UITrackingRunLoopMode, nil] autorelease];
	[self performSelector:@selector(updateRenderProgress) withObject:nil afterDelay:0.1 inModes:modes];
	
}



- (void)renderAudioDidFinish {
	
	self.OFSAptr->soundStreamStart();
	//[milgromViewController startAnimation];
	[[(SingingCardAppDelegate*)[[UIApplication sharedApplication] delegate] shareManager] action];
	
}




- (void)renderVideo {
	//[(TouchView*)self.view  setRenderTouch:NO];
	
	self.renderLabel.text = @"Creating video";
	[self setRenderProgress:0.0f];
	
	SingingCardAppDelegate * appDelegate = (SingingCardAppDelegate*)[[UIApplication sharedApplication] delegate];
	ShareManager *shareManager = [appDelegate shareManager];
	
	//[milgromViewController stopAnimation];
	self.OFSAptr->soundStreamStop();
	self.OFSAptr->setSongState(SONG_RENDER_VIDEO);
	
	self.renderManager = [OpenGLTOMovie renderManager];
	
	dispatch_queue_t myCustomQueue;
	myCustomQueue = dispatch_queue_create("renderQueue", NULL);
	
	
	
	dispatch_async(myCustomQueue, ^{
		
		//OFSAptr->renderAudio();
		
		
		[renderManager writeToVideoURL:[NSURL fileURLWithPath:[[shareManager getVideoPath]  stringByAppendingPathExtension:@"mov"]] 
						  withAudioURL:[NSURL fileURLWithPath:[[shareManager getVideoPath] stringByAppendingPathExtension:@"wav"]] 
		 
						   withContext:context
							  withSize:CGSizeMake(480, 320) 
			   withAudioAverageBitRate:[NSNumber numberWithInt: 192000 ]
			   withVideoAverageBitRate:[NSNumber numberWithDouble:256.0*1024.0]
		 
		 
			 withInitializationHandler:^ {
				 glMatrixMode (GL_PROJECTION);
				 glLoadIdentity ();
				 gluOrtho2D (0, 480, 0, 320);
				 
			 }
		 
						 withDrawFrame:^(int frameNum) {
							 NSLog(@"rendering frame: %i, progress: %2.2f",frameNum,self.OFSAptr->getRenderProgress());
							 self.OFSAptr->seekFrame(frameNum);
							 
							 glMatrixMode(GL_MODELVIEW);
							 glLoadIdentity();
							 
							 self.OFSAptr->draw();
							 
						 }
		 
					   withIsRendering:^ {
						   
						   return (int)(self.OFSAptr->getSongState()==SONG_RENDER_VIDEO);
					   }
		 
				 withCompletionHandler:^ {
					 NSLog(@"write completed");
					 
					 self.OFSAptr->setSongState(SONG_IDLE);
					 self.OFSAptr->soundStreamStart();
					 //[milgromViewController startAnimation];
					 [shareManager action];
					 self.renderManager = nil;
					 
					 //renderingView.hidden = YES;
					 //[self action];
					 
				 }
		 
		 ];
	});
	
	
	dispatch_release(myCustomQueue);
	
	NSArray *modes = [[[NSArray alloc] initWithObjects:NSDefaultRunLoopMode, UITrackingRunLoopMode, nil] autorelease];
	[self performSelector:@selector(updateRenderProgress) withObject:nil afterDelay:0.1 inModes:modes];
	
}


- (void)exportRingtone {
	self.renderLabel.text = @"Exporting ringtone";
	//renderingView.hidden = NO;
	[self setRenderProgress:0.0f];
	
	
	ShareManager *shareManager = [(SingingCardAppDelegate*)[[UIApplication sharedApplication] delegate] shareManager];
	
	self.OFSAptr->soundStreamStop();
	
	
	self.exportManager = [ExportManager  exportAudio:[NSURL fileURLWithPath:[[shareManager getVideoPath] stringByAppendingPathExtension:@"wav"]]
						  
											   toURL:[NSURL fileURLWithPath:[[shareManager getVideoPath] stringByAppendingPathExtension:@"m4r"]]
						  
						  
							   withCompletionHandler:^ {
								   NSLog(@"export completed");
								   
								   self.OFSAptr->setSongState(SONG_IDLE);
								   self.OFSAptr->soundStreamStart();
								   
								   if ([exportManager didExportComplete]) {
									   [[(SingingCardAppDelegate*)[[UIApplication sharedApplication] delegate] shareManager] action];
								   }
								   
								   self.exportManager = nil;
								   [self updateViews];
								   
							   }];
	
	NSArray *modes = [[NSArray alloc] initWithObjects:NSDefaultRunLoopMode, UITrackingRunLoopMode, nil];
	[self performSelector:@selector(updateExportProgress:) withObject:exportManager afterDelay:0.5 inModes:modes];
	
	
}




- (void)updateExportProgress:(ExportManager*)manager
{
	
	if (!manager.didFinish) {
		//MilgromLog(@"export audio, progrss: %2.2f",manager.progress);
		[self setRenderProgress:manager.progress];
		NSArray *modes = [[[NSArray alloc] initWithObjects:NSDefaultRunLoopMode, UITrackingRunLoopMode, nil] autorelease];
		[self performSelector:@selector(updateExportProgress:) withObject:manager afterDelay:0.5 inModes:modes];
	}
}





- (void)cancelRendering:(id)sender {
	
	SingingCardAppDelegate * appDelegate = (SingingCardAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	switch (self.OFSAptr->getSongState()) {
		case SONG_RENDER_VIDEO:  {
			
			
			
			[self.renderManager cancelRender];
			self.renderManager = nil;
			self.OFSAptr->setSongState(SONG_IDLE);
			self.OFSAptr->soundStreamStart();
			//[appDelegate.milgromViewController startAnimation];
			
		}	break;
		case SONG_RENDER_AUDIO:
			[appDelegate.shareManager cancel];
			self.OFSAptr->setSongState(SONG_CANCEL_RENDER_AUDIO);
			break;
		default:
			break;
	}
	
	if (exportManager) {
		[exportManager cancelExport];
		self.exportManager = nil;
		self.OFSAptr->setSongState(SONG_IDLE);
		self.OFSAptr->soundStreamStart();
	}
	
	
}

- (NSUInteger) cameraCount
{
    return [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
}

@end

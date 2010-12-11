//
//  MainViewController.m
//  SingingCard
//
//  Created by Roee Kremer on 12/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>





#include "Constants.h"
#include "testApp.h"

#import "MainViewController.h"
#import "EAGLView.h"
#import "ShareManager.h"
#import "SingingCardAppDelegate.h"
#import "MilgromMacros.h"

#import "CustomImageView.h"
#import "ShareManager.h"
#import "OpenGLTOMovie.h"
#import "glu.h"
#import "ExportManager.h"



@interface MainViewController ()
@property (nonatomic, retain) EAGLContext *context;
@property (nonatomic, assign) CADisplayLink *displayLink;

- (void)updateRenderProgress;
- (void)renderAudioDidFinish;
- (void)updateExportProgress:(ExportManager*)manager;


@end

@implementation MainViewController

@synthesize animating, context, displayLink;

@synthesize renderView;
@synthesize renderLabel;
@synthesize renderTextView;

@synthesize shareProgressView;
@synthesize renderProgressView;
@synthesize exportManager;
@synthesize renderManager;

@synthesize eaglView;

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
	
	
	
	[eaglView setContext:context];
    [eaglView setFramebuffer];
    
    
    
    animating = FALSE;
    animationFrameInterval = 1;
    self.displayLink = nil;
	
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
    [eaglView setFramebuffer];
    
    // Replace the implementation of this method to do your own custom drawing.
    static const GLfloat squareVertices[] = {
        -0.5f, -0.33f,
        0.5f, -0.33f,
        -0.5f,  0.33f,
        0.5f,  0.33f,
    };
    
    static const GLubyte squareColors[] = {
        255, 255,   0, 255,
        0,   255, 255, 255,
        0,     0,   0,   0,
        255,   0, 255, 255,
    };
    
    static float transY = 0.0f;
    
    glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    
        glMatrixMode(GL_PROJECTION);
        glLoadIdentity();
        glMatrixMode(GL_MODELVIEW);
        glLoadIdentity();
        glTranslatef(0.0f, (GLfloat)(sinf(transY)/2.0f), 0.0f);
        transY += 0.075f;
        
        glVertexPointer(2, GL_FLOAT, 0, squareVertices);
        glEnableClientState(GL_VERTEX_ARRAY);
        glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
        glEnableClientState(GL_COLOR_ARRAY);
    
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    [eaglView presentFramebuffer];
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
}

#pragma mark Render && Share

- (void) setShareProgress:(float) progress {
	[shareProgressView setRect:CGRectMake(0, 1.0-progress, 1.0f,progress)];
}

- (void)share:(id)sender {
	
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


- (void) setRenderProgress:(float) progress {
	[renderProgressView setRect:CGRectMake(0.0f, 0.0f,progress,1.0f)];
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
	self.renderTextView.text = @"";// @"(it can take some time, depends on your song length...)";
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
	self.renderTextView.text = @"pinch and drag screen to create camera movements.\n\ndouble tap screen to zoom.";
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
		
		
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		[renderManager writeToVideoURL:[NSURL fileURLWithPath:[[shareManager getVideoPath]  stringByAppendingPathExtension:@"mov"]] withAudioURL:[NSURL fileURLWithPath:[[paths objectAtIndex:0] stringByAppendingPathComponent:@"temp.wav"]] 
		 
						   withContext:context
							  withSize:CGSizeMake(480, 320) 
		 
		 
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
							 
							 self.OFSAptr->render();
							 
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
	self.renderTextView.text = @"(it can take some time, depends on your song length...)";
	//renderingView.hidden = NO;
	[self setRenderProgress:0.0f];
	
	
	ShareManager *shareManager = [(SingingCardAppDelegate*)[[UIApplication sharedApplication] delegate] shareManager];
	
	self.OFSAptr->soundStreamStop();
	
	//ShareManager *shareManager = [(SingingCardAppDelegate*)[[UIApplication sharedApplication] delegate] shareManager];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
	self.exportManager = [ExportManager  exportAudio:[NSURL fileURLWithPath:[[paths objectAtIndex:0] stringByAppendingPathComponent:@"temp.wav"]]
						  
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



@end

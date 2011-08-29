//
//  RenderProgressView.h
//  SingingCard
//
//  Created by Roee Kremer on 8/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface RenderProgressView : UIView {
	UIProgressView *progressView;
	UIButton *cancelButton;
}

@property (nonatomic,retain ) IBOutlet UIProgressView *progressView;
@property (nonatomic,retain ) IBOutlet UIButton *cancelButton;

-(void)setRenderProgress:(float)progress;


@end

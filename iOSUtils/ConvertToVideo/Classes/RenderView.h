//
//  RenderView.h
//  ConvertToVideo
//
//  Created by Roee Kremer on 11/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RenderView : UIView {
}

@property (nonatomic,retain) IBOutlet UIView *slideView;

+(RenderView *) renderViewWithFrame:(CGRect)frame;

@end

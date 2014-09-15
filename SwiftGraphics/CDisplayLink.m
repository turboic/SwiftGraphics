//
//  CDisplayLink.m
//  Newton
//
//  Created by Jonathan Wight on 9/14/14.
//  Copyright (c) 2014 toxicsoftware. All rights reserved.
//

#import "CDisplayLink.h"

#import <QuartzCore/QuartzCore.h>

@interface CDisplayLink ()
@property (readwrite, nonatomic, assign) CVDisplayLinkRef displayLink;
@end

@implementation CDisplayLink

- (id)init
    {
    if ((self = [super init]) != NULL)
        {
		CVDisplayLinkCreateWithCGDisplay(0, &_displayLink);
		CVDisplayLinkSetOutputCallback(_displayLink, MyCVDisplayLinkOutputCallback, (__bridge void *)self);
        }
    return self;
    }

- (void)dealloc
    {
    [self stop];

    CVDisplayLinkRelease(_displayLink);
    }

- (void)start
    {
    CVDisplayLinkStart(_displayLink);
    }

- (void)stop;
    {
    CVDisplayLinkStop(_displayLink);
    }

static CVReturn MyCVDisplayLinkOutputCallback(CVDisplayLinkRef displayLink, const CVTimeStamp *inNow, const CVTimeStamp *inOutputTime, CVOptionFlags flagsIn, CVOptionFlags *flagsOut, void *displayLinkContext)
	{
	@autoreleasepool
		{
        CDisplayLink *self = (__bridge CDisplayLink *)displayLinkContext;
        if (self.displayLinkBlock != NULL)
            {
            self.displayLinkBlock(inNow, inOutputTime);
            }
		}
	return(kCVReturnSuccess);
	}


@end

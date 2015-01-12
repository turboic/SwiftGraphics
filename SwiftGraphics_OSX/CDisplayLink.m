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
@property (readwrite, nonatomic, assign) CFAbsoluteTime startTime;
@property (readwrite, nonatomic, assign) CFAbsoluteTime lastTime;
@property (readwrite, nonatomic, assign) uint64_t frames;
@property (readwrite, nonatomic, assign) double fps;

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
    self.startTime = CFAbsoluteTimeGetCurrent();
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
        CFAbsoluteTime theNow = CFAbsoluteTimeGetCurrent();

        if (self.lastTime == 0)
            {
            self.lastTime = CFAbsoluteTimeGetCurrent();
            self.frames = 0;
            }
        else
            {
            self.frames++;
            

            if (theNow >= self.lastTime + 1.0)
                {
                double diff = theNow - self.lastTime;
                self.fps = (double)self.frames / diff;
                self.lastTime = theNow;
                self.frames = 0;
                }
            }


        const NSTimeInterval deltaTime = 1.0 / (inOutputTime->rateScalar * (double)inOutputTime->videoTimeScale / (double)inOutputTime->videoRefreshPeriod);
        if (self.displayLinkBlock != NULL)
            {
            self.displayLinkBlock(theNow - self.startTime, deltaTime, self.fps);
            }

		}
        
	return(kCVReturnSuccess);
	}


@end

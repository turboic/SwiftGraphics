//
//  CDisplayLink.h
//  Newton
//
//  Created by Jonathan Wight on 9/14/14.
//  Copyright (c) 2014 toxicsoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <QuartzCore/QuartzCore.h>

@interface CDisplayLink : NSObject
@property (readwrite, nonatomic, copy) void (^displayLinkBlock)(const CVTimeStamp *inNow, const CVTimeStamp *inOutputTime);

- (void)start;
- (void)stop;

@end

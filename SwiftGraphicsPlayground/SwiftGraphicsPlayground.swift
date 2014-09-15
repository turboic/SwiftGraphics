//
//  SwiftGraphicsPlayground.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 9/15/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import AppKit
import SwiftGraphics

public func random() -> CGFloat {
    return CGFloat(arc4random_uniform(UInt32.max)) / CGFloat(UInt32.max)
}

public func random(range:ClosedInterval<CGFloat>) -> CGFloat {
    return random() * (range.end - range.start) + range.start
}

public func random(range:CGRect) -> CGPoint {
    return CGPoint(
        x:range.origin.x + random() * range.size.width,
        y:range.origin.y + random() * range.size.height
    )
}

public class DemoView : NSView {
    public var drawBlock: ((ctx:CGContext, bounds:CGRect) -> Void)?
    public var tickBlock: ((Void) -> Void)? { didSet { displayLink.start() } }
    let displayLink: CDisplayLink = CDisplayLink()


    required public init(coder: NSCoder) {
        super.init(coder:coder)

        displayLink.displayLinkBlock = {
            (a:UnsafePointer <CVTimeStamp>, b:UnsafePointer <CVTimeStamp>) in
            self.tick()
        }
    }

    override public init(frame frameRect: NSRect) {
        super.init(frame:frameRect)

        displayLink.displayLinkBlock = {
            (a:UnsafePointer <CVTimeStamp>, b:UnsafePointer <CVTimeStamp>) in
            self.tick()
        }
    }

    override public func drawRect(dirtyRect: NSRect) {
        let ctx = NSGraphicsContext.currentContext().CGContext
        drawBlock?(ctx:ctx, bounds:bounds)
    }

    func tick() {
        dispatch_async(dispatch_get_main_queue()) {
            self.tickBlock?()
            self.needsDisplay = true
            return
        }
    }
}


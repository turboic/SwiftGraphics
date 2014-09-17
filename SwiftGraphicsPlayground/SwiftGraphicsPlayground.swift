//
//  SwiftGraphicsPlayground.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 9/15/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import AppKit
import SwiftGraphics

public class Random {

    // This is pretty crude

    var _seed:UInt32?
    public var seed:UInt32? {
        get {
            return _seed
        }
        set {
            _seed = newValue
            srandom(newValue!)
        }
    }
    
    public init() {
    }

    public func randomUniform(uniform:UInt32) -> UInt32 {
        return UInt32(random()) % uniform
    }

    public func randomFloat() -> CGFloat {
        // TODO: Gross!
        let r = CGFloat(randomUniform(1000000)) / CGFloat(1000000)
        return r
    }

    public func randomFloat(range:ClosedInterval<CGFloat>) -> CGFloat {
        let r = randomFloat() * (range.end - range.start) + range.start
        return r
    }

    public func randomCGPoint(range:CGRect) -> CGPoint {
        let r = CGPoint(
            x:range.origin.x + randomFloat() * range.size.width,
            y:range.origin.y + randomFloat() * range.size.height
        )
        return r
    }
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


//
//  SwiftGraphicsPlayground.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 9/15/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import AppKit
import SwiftGraphics

public func pt(x:CGFloat, y:CGFloat) -> CGPoint {
    return CGPoint(x:x, y:y)
}


// MARK: Plotting points

public extension CGContext {
    func plotPoints(points:[CGPoint]) {
        for (index, point) in enumerate(points) {
            self.strokeCross(CGRect(center:point, diameter:10))
        }
    }
}

// MARK: Rendering in views

public func SGPRender(identifier:String, showView:((identifier:String, view:NSView) -> Void), block:((ctx:CGContext, bounds:CGRect) -> Void)) {
    let demoView = SwiftGraphicsPlayground.DemoView(frame:CGRect(size:CGSize(w:480, h:320)))
    demoView.drawBlock = block
    showView(identifier: identifier, view: demoView)
}

public class DemoView : NSView {
    public var drawBlock: ((ctx:CGContext, bounds:CGRect) -> Void)?
    public var tickBlock: ((Void) -> Void)? { didSet { displayLink.start() } }
    let displayLink: CDisplayLink = CDisplayLink()

    required public init?(coder: NSCoder) {
        super.init(coder:coder)

        displayLink.displayLinkBlock = {
            (deltaTime:NSTimeInterval, fps:Double) in
            self.tick()
        }
    }

    override public init(frame frameRect: NSRect) {
        super.init(frame:frameRect)

        displayLink.displayLinkBlock = {
            (deltaTime:NSTimeInterval, fps:Double) in
            self.tick()
        }
    }

    override public func drawRect(dirtyRect: NSRect) {
        let ctx = NSGraphicsContext.currentContext()!.CGContext
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

// MARK: Random

public class Random {

    // This is pretty crude

    public var seed:UInt32 {
        didSet {
            srandom(seed)
        }
    }

    public init(seed:UInt32) {
        self.seed = seed
        srandom(seed)
    }

    public init() {
        self.seed = arc4random()
        srandom(seed)
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
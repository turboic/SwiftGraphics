//
//  CGContext_OSX.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/12/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import Foundation

import CoreGraphics
import Foundation

import AppKit

public extension CGContext {
    var nsimage : NSImage {
        get { 
            // This assumes the context is a bitmap context
            let cgimage = CGBitmapContextCreateImage(self)
            let size = CGSize(width:CGFloat(CGImageGetWidth(cgimage)), height:CGFloat(CGImageGetHeight(cgimage)))
            let nsimage = NSImage(CGImage:cgimage, size:size)
            return nsimage
        }
    }
}

// MARK: Strings

public extension CGContext {
    func draw(string:String, point:CGPoint, attributes:NSDictionary?) {
        string._bridgeToObjectiveC().drawAtPoint(point, withAttributes:attributes)
    }

    func drawLabel(string:String, point:CGPoint, size:CGFloat) {
        let attributes = [NSFontAttributeName:NSFont.labelFontOfSize(size)]
        self.draw(string, point:point, attributes:attributes)
    }
}

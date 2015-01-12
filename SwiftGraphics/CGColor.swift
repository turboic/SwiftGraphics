//
//  CGColor.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/12/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import Foundation

#if os(OSX)
import AppKit
#endif

public extension CGColor {

    class func color(# colorSpace:CGColorSpace, components:[CGFloat]) -> CGColor! {
        let color = components.withUnsafeBufferPointer {
            (buffer:UnsafeBufferPointer<CGFloat>) -> CGColorRef in
            return CGColorCreate(colorSpace, buffer.baseAddress)
        }
        return color
    }

    class func color(# hue:CGFloat, saturation:CGFloat, brightness:CGFloat, alpha:CGFloat) -> CGColor! {
#if os(OSX)
        return NSColor(deviceHue: hue, saturation: saturation, brightness: brightness, alpha: alpha).CGColor
#else
        return UIColor(deviceHue: hue, saturation: saturation, brightness: brightness, alpha: alpha).CGColor
#endif
    }
}

public extension CGColor {
    func withAlpha(alpha:CGFloat) -> CGColor {
        return CGColorCreateCopyWithAlpha(self, alpha)
    }
}

public extension CGColorSpace {
    var name:String {
        return CGColorSpaceCopyName(self)
    }
}

public extension CGColor {

    var colorSpace:CGColorSpaceRef {
        get {
            return CGColorGetColorSpace(self)
        }
    }

    class func whiteColor() -> CGColor { return NSColor.whiteColor().CGColor }
    class func blackColor() -> CGColor { return NSColor.blackColor().CGColor }
    class func redColor() -> CGColor { return NSColor.redColor().CGColor }
    class func greenColor() -> CGColor { return NSColor.greenColor().CGColor }
    class func blueColor() -> CGColor { return NSColor.blueColor().CGColor }
}

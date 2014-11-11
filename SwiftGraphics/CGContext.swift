//
//  CGContext.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 8/24/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import CoreGraphics

// TODO: This code is mostly experimental, use at your own risk - see TODO.markdown

public extension CGContext {

    class func bitmapContext(size:CGSize) -> CGContext! {
        let colorspace = CGColorSpaceCreateDeviceRGB()    
        var bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedFirst.rawValue)
        return CGBitmapContextCreate(nil, UInt(size.width), UInt(size.height), 8, UInt(size.width) * 4, colorspace, bitmapInfo)
    }

    func fillRect(rect:CGRect) {
        CGContextFillRect(self, rect)
    }

    func strokeRect(rect:CGRect) {
        CGContextStrokeRect(self, rect)
    }

    func strokeEllipseInRect(rect:CGRect) {
        CGContextStrokeEllipseInRect(self, rect)
    }

    func strokeLines(points:[CGPoint]) {
        points.withUnsafeBufferPointer {
            (p:UnsafeBufferPointer<CGPoint>) -> Void in
            CGContextStrokeLineSegments(self, p.baseAddress, UInt(points.count))
        }
    }

    func strokeLine(p1:CGPoint, _ p2:CGPoint) {
        self.strokeLines([p1, p2])
    }

    // TODO: Rename strokePolygon?
    func strokeLine(points:[CGPoint], close:Bool = false) {
        var newPoints:[CGPoint] = []
        for (first, second) in GeneratorOf(SlidingWindow(points)) {
            if second == nil {
                if (close == true) {
                    newPoints.append(first)
                    newPoints.append(points[0])
                }
                break
            }
            newPoints.append(first)
            newPoints.append(second!)
        }


        self.strokeLines(newPoints)
    }

    
    func fillCircle(#center:CGPoint, radius:CGFloat) {
        let rect = CGRect(center:center, size:CGSize(width:radius * 2, height:radius * 2))
        CGContextFillEllipseInRect(self, rect)
    }
    
    func fillCircle(circle:Circle) {
        CGContextFillEllipseInRect(self, circle.frame)
    }

    func with(block:() -> Void) {
        CGContextSaveGState(self)
        block()
        CGContextRestoreGState(self)
    }
}

// MARK: Colors

public extension CGContext {
#if os(OSX)
    func setStrokeColor(color:NSColor) {
        CGContextSetStrokeColorWithColor(self, color.CGColor)
    }

    func setFillColor(color:NSColor) {
        CGContextSetFillColorWithColor(self, color.CGColor)
    }

    func withColor(color:NSColor, block:() -> Void) {
        with {
            CGContextSetStrokeColorWithColor(self, color.CGColor)
            CGContextSetFillColorWithColor(self, color.CGColor)
            block()
        }
    }
#endif
}

// MARK: Images

public extension CGImageRef {
    var size : CGSize { get { return CGSize(width:CGFloat(CGImageGetWidth(self)), height:CGFloat(CGImageGetHeight(self))) } }
}

public extension CGContext {
#if os(OSX)
    var nsimage : NSImage {
        get { 
            let cgimage = CGBitmapContextCreateImage(self)
            let nsimage = NSImage(CGImage:cgimage, size:cgimage.size)
            return nsimage
        }
    }
#endif
}

// MARK: Strings

public extension CGContext {
#if os(OSX)
    func draw(string:String, point:CGPoint, attributes:NSDictionary?) {
        string._bridgeToObjectiveC().drawAtPoint(point, withAttributes:attributes)
    }

    func drawLabel(string:String, point:CGPoint, size:CGFloat) {
        let attributes = [NSFontAttributeName:NSFont.labelFontOfSize(size)]
        self.draw(string, point:point, attributes:attributes)
    }
#endif
}

// MARK: Convenience shapes

public extension CGContext {

    func strokeCross(rect:CGRect) {
        let linePoints = [
            CGPoint(x:rect.minX, y:rect.midY), CGPoint(x:rect.maxX, y:rect.midY),
            CGPoint(x:rect.midX, y:rect.minY), CGPoint(x:rect.midX, y:rect.maxY),
        ]
        self.strokeLines(linePoints)
    }

    func strokeSaltire(rect:CGRect) {    
        let linePoints = [
            CGPoint(x:rect.minX, y:rect.minY), CGPoint(x:rect.maxX, y:rect.maxY),
            CGPoint(x:rect.minX, y:rect.maxY), CGPoint(x:rect.maxX, y:rect.minY),
        ]
        self.strokeLines(linePoints)
    }

}

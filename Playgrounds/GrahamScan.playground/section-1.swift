// Playground - noun: a place where people can play

import Cocoa
import SwiftGraphics
import SwiftGraphicsPlayground
import XCPlayground

var points = arrayOfRandomPoints(50, CGRect(w:480, h:320))

let hull = grahamScan(points)

SGPRender("Test", XCPShowView) {
    (ctx:CGContext, bounds:CGRect) in
    for (index, point) in enumerate(points) {
        let color = contains(hull, point) ? NSColor.redColor() : NSColor.blackColor()
        color.set()

        ctx.strokeCross(CGRect(center:point, radius:5))
        ctx.drawLabel("\(index)", point:point + CGPoint(x:2, y:0), size:10)
    }
    
    ctx.strokeLine(hull, close:true)
}


